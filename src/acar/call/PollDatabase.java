package acar.call;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.common.*;
import acar.cont.*;
import acar.util.*;

public class PollDatabase
{
	private Connection conn = null;
	public static PollDatabase db;
	
	public static PollDatabase getInstance()
	{
		if(PollDatabase.db == null)
			PollDatabase.db = new PollDatabase();
		return PollDatabase.db;	
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
     * 계약 현황 조회
     */
    public Vector getRentCondCallAll(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4, String sort, String st_nm, String user_id) 
    {
        getConnection();
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";      
		String user_query = "";        
		String s_dt1 = "to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";  
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt4 = "to_char(sysdate,'YYYY')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//계약일
		if(gubun2.equals("1")){     
			if(dt.equals("1"))								dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))							dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt4+"||'%'\n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and nvl(b.rent_dt,a.rent_dt) "+s_dt3+"\n";
			
		//대여개시일
		}else if (gubun2.equals("2")){ 				
			if(dt.equals("1"))								dt_query = "and  ( b.rent_start_dt like "+s_dt2+"||'%' or to_char(cpr.answer_date, 'yyyymmdd') like "+s_dt2+"||'%' ) \n";
			else if(dt.equals("2"))							dt_query = "and b.rent_start_dt like "+s_dt4+"||'%' \n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = "and b.rent_start_dt "+s_dt3+"\n";
		} else {
			dt_query = " and c.firm_nm like '%"+ st_nm + "%' and substr(nvl(b.rent_dt,a.rent_dt),1,6)>= '200709' \n";
		}
        
              //call center :000071, 000194
                if  ( user_id.equals("000071") || user_id.equals("000194") ) {
                	   user_query  = " and  cpr.reg_id = '" + user_id + "'";
                }	 
              
        
        query = " select\n"+
				" a.rent_mng_id, a.rent_l_cd, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, b.rent_start_dt, c.firm_nm, c.client_nm, g.car_nm, f.car_name,\n"+
				" a.dlv_dt, d.init_reg_dt, b.con_mon,\n"+
				" decode(b.rent_st,'1','','연장') ext_st, \n"+
				" decode(nvl(a.car_gu,a.reg_id),'1','신차','0','재리스') car_gu, \n"+
				" decode(a.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st,\n"+
				" decode(a.rent_st,'1','신규','2','연장','3','대차','4','증차','5','연장','6','재리스','7','재리스') rent_st,\n"+
				" decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
				" decode(a.bus_st,'1','인터넷','2','영업사원','3','기존업체소개','4','카달로그발송','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st,\n"+
				" j.emp_nm, jj.emp_nm as chul_nm, k.user_nm as bus_nm, l.user_nm as bus_nm2, m.user_nm as mng_nm,  decode(a.call_st , 'N', '9', cp.gubun ) as gubun \n"+
				" from cont a, fee b, client c, car_reg d, car_etc e, car_nm f, car_mng g, cont_etc  ce,  \n"+
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='1' and a.emp_id=b.emp_id ) j,\n"+
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='2' and a.emp_id=b.emp_id ) jj,\n"+
				"      (select a.rent_mng_id, a.rent_l_cd, '1' as gubun from cont_call a where poll_id <> 0 group by a.rent_mng_id, a.rent_l_cd  ) cp,\n"+
				"      (select a.rent_mng_id, a.rent_l_cd,  reg_id , answer_date from cont_call a where  poll_id = 0   ) cpr,\n"+
				"      users k, users l, users m, users  ll \n"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2','4','5') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				dt_query +user_query+
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+)\n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+)\n"+
				" and a.rent_mng_id=cp.rent_mng_id(+) and a.rent_l_cd=cp.rent_l_cd(+)\n"+
				" and a.rent_mng_id=cpr.rent_mng_id(+) and a.rent_l_cd=cpr.rent_l_cd(+)\n"+
				" and a.rent_mng_id=ce.rent_mng_id(+) and a.rent_l_cd=ce.rent_l_cd(+) and ce.rent_suc_dt is null \n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)\n"+
				" and ce.bus_agnt_id=ll.user_id(+) \n"+
			//	" and a.mng_id=m.user_id(+) ";
				" and a.mng_id=m.user_id(+) and b.rent_st = '1' and nvl(a.car_gu,a.reg_id) = '1' "; //연장제외, 재리스제외 -2009년부터, 승계제외

		if(gubun3.equals("1") && !gubun4.equals("")) query += " and decode(b.rent_st,'1',a.bus_id,b.ext_agnt)='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";

		if(sort.equals("1"))		query += " order by nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("2"))	query += " order by b.rent_start_dt";
		else if(sort.equals("3"))	query += " order by c.firm_nm, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("4"))	query += " order by a.bus_id, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("5"))	query += " order by a.bus_st, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("6"))	query += " order by j.emp_nm, nvl(b.rent_dt,a.rent_dt)";
	//	else if(sort.equals("7"))	query += " order by decode(a.call_st , 'N', '9', cp.gubun ) desc, decode(a.rent_st,'2',1,'5',2,'6',3,'7',4,'3',5,'4',6,'1',7), nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("7"))	query += " order by decode(a.call_st , 'N', '9', cp.gubun ) desc, b.rent_start_dt, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("8"))	query += " order by to_number(b.con_mon)";

        try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
            
 //          System.out.println(" getRentCondCallAll = " + query);
            
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
			System.out.println("[PollDatabase:getRentCondCallAll]"+e);
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


	public ContCallBean getContCall(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
			String query = "";
		ContCallBean bean = new ContCallBean();

		query = " select C.POLL_ID, P.QUESTION, C.ANSWER, C.ANSWER_REM  "+
				" from cont_call C, live_poll P "+
				" where C.rent_mng_id = '" + rent_mng_id  + "' and C.rent_l_cd = '" + rent_l_cd  + "' and c.poll_id= p.poll_id ";

	
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
    		while(rs.next())
			{
				bean.setPoll_id			(rs.getString("POLL_ID")==null?0:Integer.parseInt(rs.getString("POLL_ID")));
				bean.setQuestion		(rs.getString("QUESTION")==null?"":rs.getString("QUESTION"));
		
			
			}
			rs.close();
			pstmt.close();
						
		} catch (SQLException e) {
	  		e.printStackTrace();
	  		bean = null;
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}
	
	public Vector getPollAll(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select C.POLL_ID, P.QUESTION, C.ANSWER, C.ANSWER_REM   "+
				" from cont_call C, live_poll P "+
				" where  c.poll_id <> 0 and C.rent_mng_id = '" + rent_mng_id  + "' and C.rent_l_cd = '" + rent_l_cd  + "' and c.poll_id= p.poll_id(+) order by poll_seq ";

	
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

	//
	public int checkContCall(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(*) from cont_call 	where poll_id <> 0 and  rent_mng_id = '" + rent_mng_id  + "' and rent_l_cd = '" + rent_l_cd  + "' ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:checkContCall]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}

	//콜센터 
	public LivePollBean insertLivePoll(LivePollBean poll)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String id_sql = " select MAX(nvl(poll_id, 0))+1  as ID from live_poll ";
		int  c_id= 0;
		try{
				pstmt1 = conn.prepareStatement(id_sql);
		    	rs = pstmt1.executeQuery();
		    	if(rs.next())
		    	{
		    		c_id=rs.getInt(1);
		    	}
				rs.close();
				pstmt1.close();

		} catch (SQLException e) {
	  		e.printStackTrace();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  	}
	  	
		if(c_id == 0)	c_id = 1;
		poll.setPoll_id(c_id);
		
		String query = " insert into LIVE_POLL ( POLL_ID, QUESTION, ANSWER1, ANSWER2, ANSWER3, ANSWER4, ANSWER5, ANSWER6, ANSWER7, "+
						" ANSWER8, USE_YN, ANSWER1_REM, ANSWER2_REM, ANSWER3_REM, ANSWER4_REM, ANSWER5_REM, ANSWER6_REM, ANSWER7_REM, ANSWER8_REM,  " +
						" POLL_ST , POLL_SEQ, POLL_TYPE ,  ANSWER9, ANSWER9_REM , ANSWER10, ANSWER10_REM, POLL_TITLE, START_DT, END_DT  ) values ("+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,  "+
						" ?, ?, ? , ?, ? , ?, ?, "+
						" ?, replace(?,'-',''), replace(?,'-',''), ?, to_char(sysdate,'YYYYMMDD') )"+
						" ";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1,  poll.getPoll_id()	);
			pstmt.setString(2,  poll.getQuestion().trim()	);
			pstmt.setString(3,  poll.getAnswer1().trim()	);
			pstmt.setString(4,  poll.getAnswer2().trim()	);
			pstmt.setString(5,  poll.getAnswer3().trim()	);
			pstmt.setString(6,  poll.getAnswer4().trim()	);
			pstmt.setString(7,  poll.getAnswer5().trim()	);
			pstmt.setString(8,  poll.getAnswer6().trim()	);
			pstmt.setString(9,  poll.getAnswer7().trim()	);	
			pstmt.setString(10,  poll.getAnswer8().trim()	);
			pstmt.setString(11,  poll.getUse_yn()	);
			pstmt.setString(12,  poll.getAnswer1_rem()	);
			pstmt.setString(13,  poll.getAnswer2_rem()	);
			pstmt.setString(14,  poll.getAnswer3_rem()	);
			pstmt.setString(15,  poll.getAnswer4_rem()	);
			pstmt.setString(16,  poll.getAnswer5_rem()	);
			pstmt.setString(17,  poll.getAnswer6_rem()	);
			pstmt.setString(18,  poll.getAnswer7_rem()	);	
			pstmt.setString(19,  poll.getAnswer8_rem()	);
			pstmt.setString(20,  poll.getPoll_st()	);
			pstmt.setInt(21,  poll.getPoll_seq()	);
			pstmt.setString(22,  poll.getPoll_type()	);
			pstmt.setString(23,  poll.getAnswer9()	);
			pstmt.setString(24,  poll.getAnswer9_rem()	);
			pstmt.setString(25,  poll.getAnswer10()	);
			pstmt.setString(26,  poll.getAnswer10_rem()	);

			pstmt.setString(27,  poll.getPoll_title()	);
			pstmt.setString(28,  poll.getStart_dt()	);
			pstmt.setString(29,  poll.getEnd_dt()	);
			pstmt.setString(30,  poll.getReg_id()	);
			
		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
		  	System.out.println("[PollDatabase:insertLivePoll]\n"+e);
			System.out.println("[PollDatabase:insertLivePoll]\n"+query);
			e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[PollDatabase:insertLivePoll]\n"+e);
			System.out.println("[PollDatabase:insertLivePoll]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return poll;
		}
	}
	

	//콜센터 
	public boolean insertContCall(ContCallBean bean, String answer_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		
		String query = " insert into cont_call ( RENT_MNG_ID, RENT_l_CD, POLL_ID, ANSWER, ANSWER_REM, ANSWER_DATE, UPDATE_DATE , REG_ID, POLL_S_ID) values ("+
						" ?, ?, ?, ?, ?, sysdate, sysdate, ?, ? )";	
						
		String query1 = " insert into cont_call ( RENT_MNG_ID, RENT_l_CD, POLL_ID, ANSWER, ANSWER_REM, ANSWER_DATE, UPDATE_DATE,  REG_ID, POLL_S_ID ) values ("+
						" ?, ?, ?, ?, ?, sysdate, sysdate, ?, ? )";						
		try 
		{
			conn.setAutoCommit(false);
			
			if (!answer_dt.equals("")){
				pstmt = conn.prepareStatement(query1);
				pstmt.setString(1,  bean.getRent_mng_id().trim()	);
				pstmt.setString(2,  bean.getRent_l_cd().trim()	);
				pstmt.setInt(3,  	bean.getPoll_id() );
				pstmt.setString(4,  bean.getAnswer().trim()	);
				pstmt.setString(5,  bean.getAnswer_rem().trim()	);
				pstmt.setString(6,  bean.getReg_id().trim()	);
				pstmt.setInt(7,  	bean.getPoll_s_id() );			
			
			} else {				 	
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,  bean.getRent_mng_id().trim()	);
				pstmt.setString(2,  bean.getRent_l_cd().trim()	);
				pstmt.setInt(3,  bean.getPoll_id()	);
				pstmt.setString(4,  bean.getAnswer().trim()	);
				pstmt.setString(5,  bean.getAnswer_rem().trim()	);
				pstmt.setString(6,  bean.getReg_id().trim()	);
				pstmt.setInt(7,  	bean.getPoll_s_id() );
			}			
							
		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
		  	System.out.println("[PollDatabase:insertContCall]\n"+e);
		   	System.out.println("[PollDatabase:insertContCall]\n"+ bean.getRent_mng_id());
		   	System.out.println("[PollDatabase:insertContCall]\n"+bean.getRent_l_cd());
		   	System.out.println("[PollDatabase:insertContCall]\n"+bean.getPoll_id());
		   	System.out.println("[PollDatabase:insertContCall]\n"+bean.getAnswer());
			e.printStackTrace();
			flag = false;
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[PollDatabase:insertContCall]\n"+e);
		   	System.out.println("[PollDatabase:insertContCall]\n"+ bean.getRent_mng_id());
		   	System.out.println("[PollDatabase:insertContCall]\n"+bean.getRent_l_cd());
		   	System.out.println("[PollDatabase:insertContCall]\n"+bean.getPoll_id());
		   	System.out.println("[PollDatabase:insertContCall]\n"+bean.getAnswer());
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
		
		// 콜센타 등록 삭제
	public boolean deleteContCall(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " DELETE from cont_call where rent_mng_id =? and rent_l_cd =? and poll_id <> 0 ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id);
			pstmt.setString	(2,		rent_l_cd);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:deleteContCall]\n"+e);
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

/* poll 수정 */
	public boolean updatePoll(LivePollBean poll)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = " update LIVE_POLL set "+
						" QUESTION = ?, "+
						" ANSWER1 = ?, "+
						" ANSWER2 = ?, "+
						" ANSWER3 = ?, "+
						" ANSWER4 = ?, "+
						" ANSWER5 = ?, "+
						" ANSWER6 = ?, "+
						" ANSWER7 = ?, "+
						" ANSWER8 = ?, "+
						" use_yn = ?, "+
						" ANSWER1_REM = ?, "+
						" ANSWER2_REM = ?, "+
						" ANSWER3_REM = ?, "+
						" ANSWER4_REM = ?, "+
						" ANSWER5_REM = ?, "+
						" ANSWER6_REM = ?, "+
						" ANSWER7_REM = ?, "+
						" ANSWER8_REM = ? ,"+
						" poll_st = ?,   "+
						" poll_seq = ?, "+	
						" ANSWER9 = ? ,"+
						" ANSWER9_REM = ? , "+			
						" ANSWER10 = ? ,"+
						" ANSWER10_REM = ?"+				
						" where POLL_ID = ? ";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, poll.getQuestion());
			pstmt.setString(2, poll.getAnswer1());
			pstmt.setString(3, poll.getAnswer2());
			pstmt.setString(4, poll.getAnswer3());
			pstmt.setString(5, poll.getAnswer4());
			pstmt.setString(6, poll.getAnswer5());
			pstmt.setString(7, poll.getAnswer6());
			pstmt.setString(8, poll.getAnswer7());
			pstmt.setString(9, poll.getAnswer8());
			pstmt.setString(10, poll.getUse_yn());
			pstmt.setString(11, poll.getAnswer1_rem());
			pstmt.setString(12, poll.getAnswer2_rem());
			pstmt.setString(13, poll.getAnswer3_rem());
			pstmt.setString(14, poll.getAnswer4_rem());
			pstmt.setString(15, poll.getAnswer5_rem());
			pstmt.setString(16, poll.getAnswer6_rem());
			pstmt.setString(17, poll.getAnswer7_rem());
			pstmt.setString(18, poll.getAnswer8_rem());
			pstmt.setString(19, poll.getPoll_st());
			pstmt.setInt(20, poll.getPoll_seq());	
			pstmt.setString(21, poll.getAnswer9());
			pstmt.setString(22, poll.getAnswer9_rem());	
			pstmt.setString(23, poll.getAnswer10());
			pstmt.setString(24, poll.getAnswer10_rem());	
			pstmt.setInt(25, poll.getPoll_id());								
	
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[PollDatabase:updatePoll]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:updatePoll]\n"+e);
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
	 *	고객별 계약리스트
	 */
	 
	public Vector getContList(String client_id, String dt, String ref_dt1, String ref_dt2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";		

		if(dt.equals("1"))	where = " and C.rent_dt = to_char(sysdate,'YYYYMMDD')";
		if(dt.equals("2"))	where = " and C.rent_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(dt.equals("4"))	where = " and C.rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		query = " select rent_mng_id, rent_l_cd, car_no, user_nm, rent_start_dt, rent_end_dt,\n"+
						" is_run, is_run_num, rent_dt, CAR_NM, CAR_NAME, rent_way\n"+
					"from\n"+
					"(\n"+
						"SELECT C.rent_mng_id RENT_MNG_ID, C.rent_l_cd RENT_L_CD, R.car_no CAR_NO, U.user_nm USER_NM,\n"+
								" decode(F.rent_start_dt, '', '', substr(F.rent_start_dt, 1, 4)||'-'||substr(F.rent_start_dt, 5, 2)||'-'||substr(F.rent_start_dt, 7, 2)) RENT_START_DT,\n"+
								" decode(F.rent_end_dt, '', '', substr(F.rent_end_dt, 1, 4)||'-'||substr(F.rent_end_dt, 5, 2)||'-'||substr(F.rent_end_dt, 7, 2)) RENT_END_DT,\n"+ 
								" decode(C.use_yn, 'N', '해약', decode(F.rent_start_dt, '', '신규', '대여')) IS_RUN, decode(C.use_yn, 'N', '2', decode(F.rent_start_dt, '', '1', '0')) IS_RUN_NUM,\n"+
								" decode(C.rent_dt, '', '', substr(C.rent_dt, 1, 4)||'-'||substr(C.rent_dt, 5, 2)||'-'||substr(C.rent_dt, 7, 2)) rent_dt,\n"+ 
								" M.CAR_NM, N.car_NAME, DECODE(F.rent_way, '1', '일반식', '2', '맞춤식') rent_way\n"+
						" FROM CONT C, CLIENT L, CAR_REG R, FEE F, USERS U,"+
					  "      CAR_ETC E, CAR_NM N, CAR_MNG M"+
						" where nvl(C.use_yn,'Y')='Y' and C.client_id = L.client_id "+where+" AND  "+
							  " C.car_mng_id = R.car_mng_id(+) AND"+
							  " C.rent_l_cd = F.rent_l_cd AND"+
							  " C.rent_mng_id = F.rent_mng_id AND"+
							  " C.bus_id = U.user_id AND"+
							  " C.rent_mng_id=E.rent_mng_id and C.rent_l_cd=E.rent_l_cd and E.car_id=N.car_id and E.car_seq=N.car_seq"+
							  " and N.car_comp_id=M.car_comp_id and N.car_cd=M.code and"+
							  " C.client_id =?"+
							  " order by C.rent_start_dt"+
					")\n"+
					"order by is_run_num";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
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
	 *	Poll 리스트
	 */
	public Vector getPollAll(String poll_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT * FROM live_poll where poll_id = " + Integer.parseInt(poll_id) + " order by poll_type, poll_seq " ;

	
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
			System.out.println("[PollDatabase:getPollAll(poll_id)]"+e);
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
	 *	Poll 리스트
	 */
	public Vector getPollAll()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT a.POLL_ID, a.POLL_SEQ, a.POLL_ST, a.POLL_TYPE, a.question, a.ANSWER1, a.ANSWER2, a.ANSWER3, a.ANSWER4, a.ANSWER5, a.ANSWER6, a.ANSWER7, a.ANSWER8, a.ANSWER9, a.ANSWER10,  \n"+
				" a.ANSWER1_REM, a.ANSWER2_REM, a.ANSWER3_REM, a.ANSWER4_REM, a.ANSWER5_REM, a.ANSWER6_REM, a.ANSWER7_REM, a.ANSWER8_REM, a.ANSWER9_REM, a.ANSWER10_REM, a.USE_YN,    \n"+
				" DECODE(TRIM(a.poll_st), '1', '신규', '4', '증차', '3', '대차', '5', '연장', '6', '재리스(신규)', '8', '재리스(기존)', '9', '월렌트(신규)', '10', '월렌트(기존)','2','순회정비','7','사고처리') AS poll_st_nm,  \n"+
				" DECODE(a.poll_type, '1','계약', '2','순회정비', '3','사고처리') AS poll_type_nm  \n"+
				" FROM live_poll a where a.use_yn = 'Y' order by poll_type, poll_st, poll_seq ";

	
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
			System.out.println("[PollDatabase:getPollAll]"+e);
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
	 *	Poll 리스트
	 */
	public Vector getPollAll(String poll_st, String gubun, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	//	String r_poll_st="1";
		
	//	if (poll_st.equals("3")) {
//		 	r_poll_st = "3";
	//	} 
		//else if (poll_st.equals("4")){	
	//		r_poll_st = "4";
	//	}
	//	else {
	//		r_poll_st = "1";
	//	}
		 
        query = " SELECT a.*, decode(a.poll_st, '1', '신규', '4', '증차', '3', '대차',  '5', '연장',  '6', '재리스(신규)', '8', '재리스(기존)') as poll_st_nm FROM live_poll a where a.use_yn = 'Y' and poll_st = '"+ poll_st + "'  order by poll_st, poll_seq  ";

	
		try {
		//	System.out.println ("query=" + query);
			
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
			System.out.println("[PollDatabase:getPollAll]"+e);
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
	 *	poll정보
	 */
	 
	public LivePollBean getPollBean(String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		LivePollBean bean = new LivePollBean();
        String query = "";
        
        query = " SELECT POLL_ID, QUESTION, ANSWER1, ANSWER2, ANSWER3, ANSWER4, ANSWER5, ANSWER6, ANSWER7, "+
				" ANSWER8, USE_YN, ANSWER1_REM, ANSWER2_REM, ANSWER3_REM, ANSWER4_REM, ANSWER5_REM, ANSWER6_REM, ANSWER7_REM, ANSWER8_REM ,  "+
				" POLL_ST, POLL_SEQ , POLL_TYPE, ANSWER9, ANSWER9_REM , ANSWER10, ANSWER10_REM  "+
				" FROM LIVE_POLL where POLL_ID=" + Integer.parseInt(seq) ;

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
	            bean.setPoll_id(rs.getInt("POLL_ID"));				
			    bean.setQuestion(rs.getString("QUESTION"));			
			    bean.setAnswer1(rs.getString("ANSWER1"));	
			    bean.setAnswer2(rs.getString("ANSWER2")==null?"":rs.getString("ANSWER2"));	
			    bean.setAnswer3(rs.getString("ANSWER3")==null?"":rs.getString("ANSWER3"));		
		        bean.setAnswer4(rs.getString("ANSWER4")==null?"":rs.getString("ANSWER4"));		
			    bean.setAnswer5(rs.getString("ANSWER5")==null?"":rs.getString("ANSWER5"));		
			    bean.setAnswer6(rs.getString("ANSWER6")==null?"":rs.getString("ANSWER6"));		
			    bean.setAnswer7(rs.getString("ANSWER7")==null?"":rs.getString("ANSWER7"));		
			    bean.setAnswer8(rs.getString("ANSWER8")==null?"":rs.getString("ANSWER8"));	
			    bean.setAnswer1_rem(rs.getString("ANSWER1_REM")==null?"0":rs.getString("ANSWER1_REM"));		
		        bean.setAnswer2_rem(rs.getString("ANSWER2_REM")==null?"0":rs.getString("ANSWER2_REM"));		
			    bean.setAnswer3_rem(rs.getString("ANSWER3_REM")==null?"0":rs.getString("ANSWER3_REM"));		
		        bean.setAnswer4_rem(rs.getString("ANSWER4_REM")==null?"0":rs.getString("ANSWER4_REM"));		
			    bean.setAnswer5_rem(rs.getString("ANSWER5_REM")==null?"0":rs.getString("ANSWER5_REM"));		
			    bean.setAnswer6_rem(rs.getString("ANSWER6_REM")==null?"0":rs.getString("ANSWER6_REM"));		
			    bean.setAnswer7_rem(rs.getString("ANSWER7_REM")==null?"0":rs.getString("ANSWER7_REM"));		
			    bean.setAnswer8_rem(rs.getString("ANSWER8_REM")==null?"0":rs.getString("ANSWER8_REM"));			
			    bean.setUse_yn(rs.getString("USE_YN"));	
			    bean.setPoll_st(rs.getString("POLL_ST")==null?"":rs.getString("POLL_ST"));	
			    bean.setPoll_seq(rs.getInt("POLL_SEQ"));	
			    bean.setPoll_type(rs.getString("POLL_TYPE"));	
			     bean.setAnswer9(rs.getString("ANSWER9")==null?"":rs.getString("ANSWER9"));	
			    bean.setAnswer9_rem(rs.getString("ANSWER9_REM")==null?"0":rs.getString("ANSWER9_REM"));					
			    bean.setAnswer10(rs.getString("ANSWER10")==null?"":rs.getString("ANSWER10"));	
			    bean.setAnswer10_rem(rs.getString("ANSWER10_REM")==null?"0":rs.getString("ANSWER10_REM"));					
			
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[PollDatabase:getPollBean]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}
	
	/**
	* 계약 현황 조회 - 콜등록
	*/
    public Vector getRentCondAll(String dt,String ref_dt1,String ref_dt2, String gubun2, String sort, String s_kd, String t_wd) 
    {
       	getConnection();
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";    
		String kd_query = "";        
		String s_dt1 = "to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";  
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt4 = "to_char(sysdate,'YYYY')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//콜등록일
		if (gubun2.equals("3")) {
			if (dt.equals("1"))				dt_query = " and cc.answer_date2 like "+s_dt2+"||'%' \n";
			else if (dt.equals("2"))		dt_query = " and cc.answer_date2 like "+s_dt4+"||'%' \n";
			else if (dt.equals("4"))		dt_query = " and cc.answer_date2 like "+s_dt1+"||'%' \n";
			else if (dt.equals("3"))		dt_query = " and cc.answer_date2 "+s_dt3+"\n";
			
		//계약일
		} else if (gubun2.equals("1")) {
			if (dt.equals("1"))				dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt2+"||'%' \n";
			else if (dt.equals("2"))		dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt4+"||'%' \n";
			else if (dt.equals("4"))		dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt1+"||'%' \n";
			else if (dt.equals("3"))		dt_query = " and nvl(b.rent_dt,a.rent_dt) "+s_dt3+"\n";
			
		//대여개시일
		} else {
			if (dt.equals("1"))				dt_query = "and b.rent_start_dt like "+s_dt2+"||'%' \n";
			else if (dt.equals("2"))		dt_query = "and b.rent_start_dt like "+s_dt4+"||'%' \n";
			else if (dt.equals("4"))		dt_query = "and b.rent_start_dt like "+s_dt1+"||'%' \n";
			else if (dt.equals("3"))		dt_query = "and b.rent_start_dt "+s_dt3+"\n";
		}
    
        if (s_kd.equals("1"))			kd_query += " and a.rent_l_cd like '%"+ t_wd + "%'";
        else if (s_kd.equals("2"))		kd_query += " and c.firm_nm like '%"+ t_wd + "%'";
        else if (s_kd.equals("3"))		kd_query += " and j.emp_nm  like '%"+ t_wd + "%'";	
        else if (s_kd.equals("4"))		kd_query += " and n.user_nm  like '%"+ t_wd + "%'";
		
        query = " select\n"+
				" a.rent_mng_id, a.rent_l_cd, cc.answer_date, cc.reg_id, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, b.rent_start_dt, c.firm_nm, c.client_nm, g.car_nm, f.car_name,\n"+
				" a.dlv_dt, d.init_reg_dt, b.con_mon,\n"+
				" decode(b.rent_st,'1','','연장') ext_st, \n"+
				" decode(nvl(a.car_gu,a.reg_id),'1','신차','0','재리스') car_gu, \n"+
				" decode(a.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st,\n"+
				" decode(a.rent_st,'1','신규','2','연장','3','대차','4','증차','5','연장','6','재리스','7','재리스') rent_st,\n"+
				" decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
				" decode(a.bus_st,'1','인터넷','2','영업사원','3','기존업체소개','4','카달로그발송','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st,\n"+
				" j.emp_nm, jj.emp_nm as chul_nm, k.user_nm as bus_nm, l.user_nm as bus_nm2, m.user_nm as  mng_nm, n.user_nm call_nm , nvl(ccc.r_answer, 'N')  r_answer, cq.rr_answer  \n"+
				" from cont a, fee b, client c, car_reg d, car_etc e, car_nm f, car_mng g, \n"+
				"      (select rent_mng_id, rent_l_cd, reg_id,  to_char(answer_date, 'YYYY-MM-DD') AS answer_date,  to_char(answer_date, 'YYYYMMDD') AS answer_date2 from cont_call where poll_id <> 0  group by  rent_mng_id, rent_l_cd, reg_id, answer_date) cc,\n"+
			   	"      (select rent_mng_id, rent_l_cd, decode(answer, '1', 'Y', 'N' ) r_answer from cont_call where poll_id in ('67', '68', '69' )  group by  rent_mng_id, rent_l_cd , decode(answer, '1', 'Y', 'N' ) ) ccc, 	   \n"+
			   	"      (select rent_mng_id, rent_l_cd, decode(answer, '000', 'Y', 'N' ) rr_answer from cont_call where poll_id  = 0  group by  rent_mng_id, rent_l_cd , decode(answer, '000', 'Y', 'N' ) ) cq, 	   \n"+					      	
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='1' and a.emp_id=b.emp_id ) j,\n"+
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='2' and a.emp_id=b.emp_id ) jj,\n"+
				"      users k, users l, users m, users n \n"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2','4','5') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				dt_query + kd_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+			
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+)\n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+)\n"+
				" and a.rent_mng_id=cc.rent_mng_id and a.rent_l_cd=cc.rent_l_cd\n"+
				" and a.rent_mng_id=ccc.rent_mng_id(+) and a.rent_l_cd=ccc.rent_l_cd(+)\n"+
				" and a.rent_mng_id=cq.rent_mng_id(+) and a.rent_l_cd=cq.rent_l_cd(+)\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)\n"+
				" and a.mng_id=m.user_id(+)\n"+
				" and cc.reg_id=n.user_id(+)";
				
		query += " order by nvl(ccc.r_answer, 'N')   desc,  cc.answer_date desc, nvl(b.rent_dt,a.rent_dt) desc";
	

        try{
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
			System.out.println("[PollDatabase:getRentCondAll]"+e);
			System.out.println("[PollDatabase:getRentCondAll]"+query);
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

	// 콜센타 비대상 등록
	public int updateContCall(String[] ch_call){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
//		String token = null ;
		String rent_mng_id = "";
		String rent_l_cd = "";
//	 	String chk= "";
	 				
		String query = " update cont set call_st = 'N' where rent_mng_id =? and rent_l_cd =?";
		
		try 
		{
			conn.setAutoCommit(false);
			
			for(int i=0 ; i<ch_call.length ; i++){
				String chk = ch_call[i];
				
				StringTokenizer token = new StringTokenizer(chk,"^");
				
				while(token.hasMoreTokens()) {
				
					rent_mng_id = token.nextToken().trim();	
					rent_l_cd = token.nextToken().trim();	
					
					pstmt = conn.prepareStatement(query);
					pstmt.setString	(1,		rent_mng_id);
					pstmt.setString	(2,		rent_l_cd);
		//			System.out.println ( "rent_mng_id=" + rent_mng_id + "| rent_l_cd = " + rent_l_cd );
					result = pstmt.executeUpdate();
		  			pstmt.close();

				}		
			}
			
			conn.commit();
	 	
	 	} catch (Exception e) {
            try{
				System.out.println("[PollDatabase:updateContCall []]\n"+e);
                conn.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	  
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
		}
		return result;
	}


		// 콜센타 비대상 등록
	public boolean updateContCall(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update cont set call_st = 'N' where rent_mng_id =? and rent_l_cd =?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id);
			pstmt.setString	(2,		rent_l_cd);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:updateContCall]\n"+e);
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
	
	
		// 콜센타 비대상 등록 - 최근 4개월
	public boolean updateContCallDt()
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		     
		query = " update cont set call_st = 'N'  " +
		        " where client_id in ( select distinct b.client_id  from (select rent_mng_id, rent_l_cd , to_char(answer_date, 'yyyy-mm-dd')  answer_date  from cont_call where poll_id <> 0 group by rent_mng_id, rent_l_cd, to_char(answer_date, 'yyyy-mm-dd')  ) a, cont b , client c " +
				"  where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and MONTHS_BETWEEN(sysdate, a.answer_date) <  7  " +
				"  and b.use_yn = 'Y' and b.client_id = c.client_id and nvl(b.call_st, '1') = 'C' ) and use_yn = 'Y' and rent_dt > '20070531' and nvl(call_st, '1')  not in ( 'C' , 'N' ) and  car_st not in ( '2', '4' , '5')  ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	   	} catch (Exception e) {
			System.out.println("[PollDatabase:updateContCallDt]\n"+e);
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

		// 콜센타 비대상 등록
	public boolean updateContCallYes(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update cont set call_st = 'C' where rent_mng_id =? and rent_l_cd =?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id);
			pstmt.setString	(2,		rent_l_cd);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:updateContCallYes]\n"+e);
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
	
	//계약 수정 : 계약정보 조회(아래프레임) (cont,fee)
	public ContBaseBean getContBaseAll(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ContBaseBean base = new ContBaseBean();
		String query = "";
		query = " select C.RENT_MNG_ID, C.RENT_L_CD, C.CLIENT_ID, C.CAR_MNG_ID, C.REG_ID, C.CAR_ST, decode(F.rent_st,'1','','연장')EXT_ST,"+
				" C.RENT_ST, C.R_SITE, C.P_ZIP, C.P_ADDR, C.O_MAP, C.RENT_DT, C.USE_YN,"+
				" C.R_SITE_ZIP, C.R_SITE_ADDR, C.DRIVING_EXT, C.DRIVING_AGE, C.LOAN_EXT, C.OTHERS, C.CAR_JA, C.SCAN_FILE,"+
				" decode(C.DLV_DT, '', '', substr(C.DLV_DT, 1, 4) || '-' || substr(C.DLV_DT, 5, 2) || '-'||substr(C.DLV_DT, 7, 2)) DLV_DT,"+
				" c.gcp_kd GCP_KD, c.bacdt_kd BACDT_KD, c.spr_kd, "+// 보험가입금액-대물배상,자기신체사고 추가부분 -20041221; Yongsoon Kwon.
				" F.RENT_WAY, F.CON_MON, C.tax_agnt, C.tax_type, C.sanction_id, C.sanction_date, C.sanction, "+
				" C.BRCH_ID, C.bus_st, C.BUS_ID, C.BUS_ID2, C.BUS_ID3, C.MNG_ID, C.MNG_ID2, C.UPDATE_ID, C.UPDATE_DT,"+
				" decode(C.RENT_START_DT, '', '', substr(C.RENT_START_DT, 1, 4) || '-' || substr(C.RENT_START_DT, 5, 2) || '-'||substr(C.RENT_START_DT, 7, 2)) RENT_START_DT,"+
				" decode(C.RENT_END_DT, '', '', substr(C.RENT_END_DT, 1, 4) || '-' || substr(C.RENT_END_DT, 5, 2) || '-'||substr(C.RENT_END_DT, 7, 2)) RENT_END_DT"+
				" from CONT C, fee F"+
				" where C.rent_mng_id = F.rent_mng_id and"+
				" C.rent_l_cd = F.rent_l_cd and"+
				" C.RENT_MNG_ID = ? and C.RENT_L_CD = ? ";
			//	" F.rent_st <> '2'";
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mng_id);
			pstmt.setString(2, l_cd);
		   	rs = pstmt.executeQuery();
			int i =0;
			while(rs.next())
			{
				base.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				base.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				base.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				base.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				base.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				base.setRent_dt(rs.getString("RENT_DT")==null?"":rs.getString("RENT_DT"));
				base.setDlv_dt(rs.getString("DLV_DT")==null?"":rs.getString("DLV_DT"));
				base.setRent_way(rs.getString("RENT_WAY")==null?"":rs.getString("RENT_WAY"));
				base.setCon_mon(rs.getString("CON_MON")==null?"":rs.getString("CON_MON"));
				base.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				base.setCar_st(rs.getString("CAR_ST")==null?"":rs.getString("CAR_ST"));
				base.setR_site(rs.getString("R_SITE")==null?"":rs.getString("R_SITE"));
				base.setP_zip(rs.getString("P_ZIP")==null?"":rs.getString("P_ZIP"));
				base.setP_addr(rs.getString("P_ADDR")==null?"":rs.getString("P_ADDR"));
				base.setO_map(rs.getString("O_MAP")==null?"":rs.getString("O_MAP"));
				base.setUse_yn(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				//추가
				base.setR_site_zip(rs.getString("R_SITE_ZIP")==null?"":rs.getString("R_SITE_ZIP"));
				base.setR_site_addr(rs.getString("R_SITE_ADDR")==null?"":rs.getString("R_SITE_ADDR"));
				base.setDriving_ext(rs.getString("DRIVING_EXT")==null?"":rs.getString("DRIVING_EXT"));
				base.setDriving_age(rs.getString("DRIVING_AGE")==null?"":rs.getString("DRIVING_AGE"));
				base.setLoan_ext(rs.getString("LOAN_EXT")==null?"":rs.getString("LOAN_EXT"));
				base.setOthers(rs.getString("OTHERS")==null?"":rs.getString("OTHERS"));
				base.setCar_ja(rs.getString("CAR_JA")==null?0:Integer.parseInt(rs.getString("CAR_JA")));
				base.setScan_file(rs.getString("SCAN_FILE")==null?"":rs.getString("SCAN_FILE"));
				//추가
				base.setGcp_kd(rs.getString("GCP_KD")==null?"":rs.getString("GCP_KD"));
				base.setBacdt_kd(rs.getString("BACDT_KD")==null?"":rs.getString("BACDT_KD"));
				//20050826
				base.setSpr_kd(rs.getString("SPR_KD")==null?"":rs.getString("SPR_KD"));
				//20051013
				base.setTax_agnt(rs.getString("tax_agnt")==null?"":rs.getString("tax_agnt"));
				base.setTax_type(rs.getString("tax_type")==null?"":rs.getString("tax_type"));
				//20061228
				base.setSanction_id(rs.getString("sanction_id")==null?"":rs.getString("sanction_id"));
				base.setSanction_date(rs.getString("sanction_date")==null?"":rs.getString("sanction_date"));
				base.setSanction(rs.getString("sanction")==null?"":rs.getString("sanction"));
				//20070608
				base.setBrch_id(rs.getString("BRCH_ID")==null?"":rs.getString("BRCH_ID"));
				base.setBus_id(rs.getString("BUS_ID")==null?"":rs.getString("BUS_ID"));
				base.setBus_id2(rs.getString("BUS_ID2")==null?"":rs.getString("BUS_ID2"));
				base.setMng_id(rs.getString("MNG_ID")==null?"":rs.getString("MNG_ID"));
				base.setMng_id2(rs.getString("MNG_ID2")==null?"":rs.getString("MNG_ID2"));
				base.setBus_st(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				base.setRent_start_dt(rs.getString("RENT_START_DT")==null?"":rs.getString("RENT_START_DT"));
				base.setRent_end_dt(rs.getString("RENT_END_DT")==null?"":rs.getString("RENT_END_DT"));
				base.setUpdate_id(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
				base.setUpdate_dt(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
				base.setBus_id3(rs.getString("BUS_ID3")==null?"":rs.getString("BUS_ID3"));
				
				base.setExt_st(rs.getString("EXT_ST")==null?"":rs.getString("EXT_ST"));
				i++;
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddContDatabase:getContBaseAll]\n"+e);
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
	
	
	/**
     * 정비 현황 조회 - 카드 + 출금
	*/
    public Vector getCarServiceCallAll(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4, String sort, String st_nm, String user_id) 
    {
        getConnection();
        
        System.out.println(ref_dt1);
        System.out.println(ref_dt2);
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";    
		String dt1_query = "";       
		String user_query = "";
		String kd_query = "";
		String s_dt1 = "to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";  
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt4 = "to_char(sysdate,'YYYY')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//정비일 - 카드 / 정비일 - 현금
		if (gubun2.equals("1")) {
			if (dt.equals("1")) {
				dt_query  = " and a.buy_dt like "+s_dt2+"||'%' \n";
				dt1_query = " and b.p_pay_dt like "+s_dt2+"||'%' \n";
			} else if (dt.equals("2")) {
				dt_query  = " and a.buy_dt like "+s_dt4+"||'%' \n";
				dt1_query = " and b.p_pay_dt like "+s_dt4+"||'%' \n";
			} else if (dt.equals("3") && !ref_dt1.equals("")) {
				dt_query  = " and a.buy_dt "+s_dt3+"\n";
				dt1_query = " and b.p_pay_dt "+s_dt3+"\n";
			}
		}
		
		if (gubun2.equals("2")) {
			if (dt.equals("1")) {
				dt_query  = " and a.buy_dt like "+s_dt2+"||'%' \n";
				dt1_query = " and b.p_pay_dt like "+s_dt2+"||'%' \n";
			} else if (dt.equals("2")) {
				dt_query  = " and a.buy_dt like "+s_dt4+"||'%' \n";
				dt1_query = " and b.p_pay_dt like "+s_dt4+"||'%' \n";
			} else if (dt.equals("3") && !ref_dt1.equals("")) {
				dt_query  = " and a.buy_dt "+s_dt3+"\n";
				dt1_query = " and b.p_pay_dt "+s_dt3+"\n";
			}
			
			if (!st_nm.equals("")) {
				kd_query = " and v.firm_nm like '%" + st_nm + "%' ";
			}
		}
		
		//call center :000071, 000194
        if (user_id.equals("000071") || user_id.equals("000194")) {
        	user_query  = " and  cpr.reg_id = '" + user_id + "'";
        }
        
        //재리스 제외	
		query = " select s.serv_dt, a.* from (	 "+	
		 			" select /*+  merge(v) */ "+
					" cp.gubun  as gubun ,'카드' p_gubun, a.buy_dt as rent_dt , a.buy_amt, c.user_nm, v.rent_mng_id, v.rent_l_cd, v.firm_nm, cc.car_nm, cn.car_name,\n" +
					" v.con_mon, decode( v.car_gu ,'1','신차','0','재리스') car_gu,\n" +
					" decode(v.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st, v.rent_way,  cc.init_reg_dt, \n"+					
					" to_number(i.seq) seq, i.item_code car_mng_id, i.serv_id, i.acct_cont, i.call_t_nm, i.call_t_tel  \n"+
					" from card_doc a, card b, users c, card_doc_item i , cont_n_view v, car_reg cc,  car_etc g, car_nm cn, \n"+
					"      (select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, '1' as gubun from service_call a where  a.poll_id <> 0   group by a.rent_mng_id, a.rent_l_cd , a.car_mng_id, a.serv_id ) cp, \n"+
					"     (select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.reg_id from service_call a where  a.poll_id = 0  group by a.rent_mng_id, a.rent_l_cd , a.car_mng_id, a.serv_id,  a.reg_id ) cpr    \n"+                
					" where a.cardno=b.cardno and nvl(a.buy_user_id,a.reg_id)=c.user_id(+)  \n"+
					" and a.cardno = i.cardno and a.buy_id = i.buy_id \n"+
					" and i.rent_l_cd = cp.rent_l_cd(+) and i.item_code= cp.car_mng_id(+) and i.serv_id = cp.serv_id(+) \n" + 
					"  and i.rent_l_cd = cpr.rent_l_cd(+) and i.item_code= cpr.car_mng_id(+) and i.serv_id = cpr.serv_id(+) \n" + 				
					" and a.acct_code = '00005' and a.acct_code_g = '6' and a.buy_dt >= '20100801'  and v.car_gu = '1' \n"+
					"	and v.car_mng_id = cc.car_mng_id  and v.rent_mng_id = g.rent_mng_id(+)  and v.rent_l_cd = g.rent_l_cd(+)  \n"+
                       			"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n"+
					dt_query + user_query + kd_query +
					" and i.rent_l_cd = v.rent_l_cd and v.car_st not in ('2','4','5') \n"+
				"  union all	 \n"+
     			" select /*+  no_merge(v) */  "+
     			"    cp.gubun  as gubun , '현금' p_gubun,  b.p_pay_dt as rent_dt , a.i_amt as buy_amt, c.user_nm, v.rent_mng_id, v.rent_l_cd, v.firm_nm, cc.car_nm, cn.car_name,   \n"+
				"	 v.con_mon, decode( v.car_gu ,'1','신차','0','재리스') car_gu,   \n"+
				"	 decode(v.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st, v.rent_way,  cc.init_reg_dt,   \n"+ 				
				"	 a.i_seq seq, a.p_cd3 car_mng_id, a.p_cd5 serv_id, a.p_cont acct_cont, a.call_t_nm, a.call_t_tel   \n"+
				"	 from pay_item a, pay b, users c,  cont_n_view v,   car_reg cc,  car_etc g, car_nm cn, \n"+
				"	      (select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, '1' as gubun from service_call a  where a.poll_id <> 0  group by a.rent_mng_id, a.rent_l_cd , a.car_mng_id, a.serv_id ) cp ,  \n"+
				"   	      (select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.reg_id from service_call a where  a.poll_id = 0  group by a.rent_mng_id, a.rent_l_cd , a.car_mng_id, a.serv_id,  a.reg_id ) cpr    \n"+
				"	 where a.reqseq=b.reqseq and nvl(a.buy_user_id, '999999')=c.user_id(+)  \n"+ 					
				"	 and a.p_cd2 = cp.rent_l_cd(+) and  a.p_cd3 = cp.car_mng_id(+) and  a.p_cd5 = cp.serv_id(+)   \n"+
				"         and a.p_cd2 = cpr.rent_l_cd(+) and  a.p_cd3 = cpr.car_mng_id(+) and  a.p_cd5 = cpr.serv_id(+)   \n"+                       	  
				"	 and a.acct_code = '45700' and a.acct_code_g = '6' and b.p_pay_dt >= '20100801'    and v.car_gu = '1' \n"+
					"	and v.car_mng_id = cc.car_mng_id  and v.rent_mng_id = g.rent_mng_id(+)  and v.rent_l_cd = g.rent_l_cd(+)  \n"+
                       			"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n"+
           			dt1_query + user_query + kd_query +
				"   and a.p_cd2 = v.rent_l_cd and v.car_st not in ('2','4','5') )  a, service s  \n"+
				"   where a.car_mng_id = s.car_mng_id and a.serv_id = s.serv_id  \n"+
				"	  and substr(s.serv_dt, 1, 6) = substr(a.rent_dt, 1, 6) ";							
						
		query += " order by   2 desc, 4 desc ";
      
        try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
            
            
            
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while (rs.next()) {				
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
			}
            rs.close();
            stmt.close();
        
        } catch (SQLException e) {
			System.out.println("[PollDatabase:getCarServiceCallAll]"+e);
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
    
    public Vector getServicePollAll(String rent_mng_id, String rent_l_cd, String car_mng_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select C.POLL_ID, P.QUESTION, C.ANSWER, C.ANSWER_REM   "+
				" from service_call C, live_poll P "+
				" where  c.poll_id <>  0 and  C.rent_mng_id = '" + rent_mng_id  + "' and C.rent_l_cd = '" + rent_l_cd  + "' and c.car_mng_id = '"+ car_mng_id + "' and serv_id = '" + serv_id + "'" +
				"  and c.poll_id= p.poll_id(+) order by poll_seq ";

	
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
			System.out.println("[PollDatabase:getServicePollAll]"+e);
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
     * 사고  현황 조회 20191213 검색조건 수정 
	*/
    public Vector getCarAccidentCallAll(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4, String sort, String st_nm, String user_id) 
    {
		getConnection();
	        
		Statement stmt = null;
	    ResultSet rs = null;
		Vector vt = new Vector();
		     
		String query = "";
		String dt_query = "";    
		String kd_query = "";        
		String user_query = "";
		String s_dt1 = "to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";  
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt4 = "to_char(sysdate,'YYYY')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//콜등록일
		if (gubun2.equals("3")) {     
			if(dt.equals("1"))				dt_query = " and replace(cc.answer_date, '-', '') like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))			dt_query = " and replace(cc.answer_date, '-', '') like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))			dt_query = " and replace(cc.answer_date, '-', '') like "+s_dt1+"||'%' \n";
			else if(dt.equals("3"))			dt_query = " and replace(cc.answer_date, '-', '') "+s_dt3+"\n";
			
		//사고일
		} else if (gubun2.equals("1")) {     
			if(dt.equals("1"))				dt_query = " and a.accid_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))			dt_query = " and a.accid_dt like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))			dt_query = " and a.accid_dt like "+s_dt1+"||'%' \n";
			else if(dt.equals("3"))			dt_query = " and a.accid_dt "+s_dt3+"\n";		
				
		//정비일
		} else {				
			if(dt.equals("1"))				dt_query = "and s.serv_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))			dt_query = "and s.serv_dt like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))			dt_query = "and s.serv_dt like "+s_dt1+"||'%' \n";
			else if(dt.equals("3"))			dt_query = "and s.serv_dt "+s_dt3+"\n";
		}
		
		//상호
		//20191213 사고현황의 경우 기준일이 사고일로 조회하고있어 상호 또한 사고일 기준으로 조회
		if (gubun2.equals("2")) {
			
			if(dt.equals("1"))				dt_query = " and a.accid_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))			dt_query = " and a.accid_dt like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))			dt_query = " and a.accid_dt like "+s_dt1+"||'%' \n";
			else if(dt.equals("3"))			dt_query = " and a.accid_dt "+s_dt3+"\n";
			
			if (!st_nm.equals("")) {
				kd_query = " AND b.firm_nm LIKE '%"+st_nm+"%' ";
			}			
		}
            
		//call center :000071, 000194
		if ( user_id.equals("000071") || user_id.equals("000194") ) {
			user_query  = " and  cpr.reg_id = '" + user_id + "'";
		}	 
                
		query = " select /*+  merge(b) */"+
				"    distinct cp.gubun  as gubun , substr(a.accid_dt,1,8) accid_dt ,   a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm,  cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, a.acc_id, "+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm\n"+
				" from   accident a, cont_n_view b, insur e, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) f, ins_com g,"+
				"     (select a.rent_mng_id, a.rent_l_cd, '1' as gubun from accident_call a where poll_id <> 0 group by a.rent_mng_id, a.rent_l_cd  ) cp, \n"+
        				"     (select a.rent_mng_id, a.rent_l_cd,  reg_id from accident_call a where  poll_id = 0  group by a.rent_mng_id, a.rent_l_cd , reg_id ) cpr, "+
				"        rent_cont h, cont i, client j, users k,  car_reg c,  car_etc g1, car_nm cn , service s  "+
				" where  a.car_mng_id = c.car_mng_id and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and e.car_mng_id=f.car_mng_id and e.ins_st=f.ins_st and e.ins_com_id=g.ins_com_id and a.car_mng_id=e.car_mng_id"+
				"	and a.rent_mng_id = g1.rent_mng_id(+)  and a.rent_l_cd = g1.rent_l_cd(+)  \n"+				
                       		"	and g1.car_id=cn.car_id(+)  and    g1.car_seq=cn.car_seq(+) "+
                       		"        and a.rent_mng_id=cp.rent_mng_id(+) and a.rent_l_cd=cp.rent_l_cd(+) "+
         				"        and a.rent_mng_id=cpr.rent_mng_id(+) and a.rent_l_cd=cpr.rent_l_cd(+)  \n"+		
                       		"        and a.car_mng_id = s.car_mng_id and a.accid_id = s.accid_id and s.serv_st in ('5', '4' , '13')    and a.accid_st not in ('1' )  and b.car_st not in ( '2', '4')  "+
                       		dt_query + user_query + kd_query +
				"        and a.rent_s_cd=h.rent_s_cd(+) and h.sub_l_cd=i.rent_l_cd(+) and h.cust_id=j.client_id(+) and h.cust_id=k.user_id(+) ";				
		query += " order by   1 desc, 2 asc ";	
		    
        try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
            
            //System.out.println("PollDatabase:getCarAccidentCallAll="+ query);
            
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while (rs.next()) {				
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
            rs.close();
            stmt.close();
        
        } catch (SQLException e) {
			System.out.println("[PollDatabase:getCarAccidentCallAll]"+e);
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
     * 사고 콜등록 현황조회(20191213 검색조건 수정)
     */
    public Vector getCarAccidentCallAll(String dt, String ref_dt1, String ref_dt2, String gubun2, String sort, String s_kd, String t_wd) 
    {
       	getConnection();
       	
       	System.out.println(s_kd);
       	System.out.println(t_wd);
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";
		String dt1_query = "";
		String kd_query = "";
		
		String s_dt1 = "to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";  
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt4 = "to_char(sysdate,'YYYY')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
		
		//사고일		
		if (gubun2.equals("1")) {
			if(dt.equals("1"))								dt_query = " and a.accid_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))							dt_query = " and a.accid_dt like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))							dt_query = " and a.accid_dt like "+s_dt1+"||'%' \n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and a.accid_dt "+s_dt3+"\n";
		} else {
			if(dt.equals("1"))								dt_query = " and cc.answer_date like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))							dt_query = " and cc.answer_date like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))							dt_query = " and cc.answer_date like "+s_dt1+"||'%' \n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and cc.answer_date "+s_dt3+"\n";			
		}
		
		//검색조건
		if (s_kd.equals("1")) {
			kd_query = " AND b.firm_nm LIKE '%"+ t_wd + "%' ";
		} else if (s_kd.equals("2")) {
			kd_query = " AND cc.user_nm LIKE '%"+ t_wd + "%' ";
		}
     
		
		query = " select /*+  merge(b) */  distinct  "+
				"      nvl(ccc.r_answer, 'N')  r_answer, cq.rr_answer  ,   cc.answer_date,  substr(a.accid_dt,1,8) accid_dt ,   a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm,  cn.car_name, b.use_yn, \n"+
				"        a.accid_id, a.accid_st, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, a.acc_id, \n"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, a.our_num, a.settle_st, cc.reg_id creg_id, cc.user_nm \n"+
				" from   accident a, cont_n_view b, insur e, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) f, ins_com g, \n"+
				"        rent_cont h, cont i, client j, users k,  car_reg c,  car_etc g1, car_nm cn , service s  , \n "+
				"	  (select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.accid_id, to_char(a.answer_date, 'YYYYMMDD') AS answer_date, a.reg_id, b.user_id, b.user_nm  from accident_call a , users b WHERE a.reg_id = b.user_id(+) and a.poll_id <> 0  group by  a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.accid_id, a.reg_id, a.answer_date, b.user_id, b.user_nm) cc , \n"+
			 	"         (select rent_mng_id, rent_l_cd,  car_mng_id, accid_id,  decode(answer, '1', 'Y', 'N' ) r_answer from accident_call where poll_id = 71 group by  rent_mng_id, rent_l_cd ,  car_mng_id, accid_id,  decode(answer, '1', 'Y', 'N' ) ) ccc, 	   \n"+
			   	"         (select rent_mng_id, rent_l_cd, car_mng_id, accid_id, decode(answer, '000', 'Y', 'N' ) rr_answer from accident_call where poll_id  = 0  group by  rent_mng_id, rent_l_cd , car_mng_id, accid_id, decode(answer, '000', 'Y', 'N' ) ) cq 	   \n"+	
				" where  a.car_mng_id = c.car_mng_id and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and e.car_mng_id=f.car_mng_id and e.ins_st=f.ins_st and e.ins_com_id=g.ins_com_id and a.car_mng_id=e.car_mng_id"+
				"	and a.rent_mng_id = g1.rent_mng_id(+)  and a.rent_l_cd = g1.rent_l_cd(+)  \n"+
                       		"	and g1.car_id=cn.car_id(+)  and    g1.car_seq=cn.car_seq(+)   \n"+
                       		"        and a.car_mng_id = s.car_mng_id and a.accid_id = s.accid_id and s.serv_st in ('5', '4', '13')    \n"+
                       		"        and a.rent_mng_id= cc.rent_mng_id and a.rent_l_cd = cc.rent_l_cd and a.car_mng_id = cc.car_mng_id and a.accid_id = cc.accid_id \n" + 		
                       		"        and cc.rent_mng_id = ccc.rent_mng_id(+) and cc.rent_l_cd = ccc.rent_l_cd(+) and  cc.car_mng_id = ccc.car_mng_id(+) and  cc.accid_id  = ccc.accid_id(+) \n" + 		
				"        and cc.rent_mng_id = cq.rent_mng_id(+) and cc.rent_l_cd = cq.rent_l_cd(+) and  cc.car_mng_id = cq.car_mng_id(+) and  cc.accid_id  = cq.accid_id(+) \n" + 				
                       		dt_query +
                       		kd_query +
				"        and a.rent_s_cd=h.rent_s_cd(+) and h.sub_l_cd=i.rent_l_cd(+) and h.cust_id=j.client_id(+) and h.cust_id=k.user_id(+)";
				
		query += " order by    1 desc, 3 desc, 4 desc ";			
		
        try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
            
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while (rs.next()) {				
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
			}
            rs.close();
            stmt.close();
            
        } catch (SQLException e) {
			System.out.println("[PollDatabase:getCarAccidentCallAll]"+e);
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
    
    //사고call 
	public Vector getAccidentPollAll(String rent_mng_id, String rent_l_cd, String car_mng_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select C.POLL_ID, P.QUESTION, C.ANSWER, C.ANSWER_REM   "+
				" from accident_call C, live_poll P "+
				" where  c.poll_id <>  0 and  C.rent_mng_id = '" + rent_mng_id  + "' and C.rent_l_cd = '" + rent_l_cd  + "' and c.car_mng_id = '"+ car_mng_id + "' and accid_id = '" + accid_id + "'" +
				"  and c.poll_id= p.poll_id(+) order by poll_seq ";
	
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
			System.out.println("[PollDatabase:getServicePollAll]"+e);
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
	 *	Poll 리스트
	 */
	public Vector getPollTypeAll(String poll_type)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		 
        query = " SELECT a.*  from live_poll a where a.use_yn = 'Y' and poll_type = '"+ poll_type + "'  order by poll_st, poll_seq  ";
	
		try {
		//	System.out.println ("query=" + query);
			
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
			System.out.println("[PollDatabase:getPollTypeAll]"+e);
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
	
	//카드 서비스 수정 : 계약정보 조회(아래프레임)
	public Hashtable getServiceBaseAll(String rent_l_cd, String car_mng_id, String serv_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " select  '카드' p_gubun , C.RENT_L_CD, C.ITEM_CODE CAR_MNG_ID, c.SERV_ID,"+
				" C.ITEM_NAME, c.ACCT_CONT, c.CALL_T_NM, c.CALL_T_TEL, s.SERV_DT , A.buy_amt , so.off_nm  \n"+			
				" from card_doc_item C, service s , card_doc A, serv_off so  "+
				" where a.cardno = c.cardno and a.buy_id = c.buy_id and  c.rent_l_cd =s.rent_l_cd(+) and c.item_code = s.car_mng_id(+) and c.serv_id = s.serv_id(+) and C.rent_l_cd = '"+rent_l_cd+"' and C.item_code = '"+car_mng_id+"' and c.serv_id =  '"+serv_id+"'" +
				" and s.off_id = so.off_id(+) "+
				" union all \n" +
				" select  '현금' p_gubun,  a.p_cd2 RENT_L_CD, a.p_cd3 CAR_MNG_ID, a.p_cd5 SERV_ID,"+
				" c.car_no ITEM_NAME, a.p_cont ACCT_CONT, a.CALL_T_NM, a.CALL_T_TEL, s.SERV_DT ,  a.i_amt as buy_amt, so.off_nm  \n"+	
				" from pay_item a, cont_n_view v,  service s , car_reg c   , serv_off so  \n"+	
				" where a.p_cd1 = v.rent_mng_id and a.p_cd2 = v.rent_l_cd and v.car_mng_id = c.car_mng_id and a.p_cd2 = s.rent_l_cd(+) and  a.p_cd3 = s.car_mng_id(+) and  a.p_cd5 = s.serv_id(+) and a.p_cd2 = '"+rent_l_cd+"' and a.p_cd3 = '"+car_mng_id+"' and a.p_cd5 =  '"+serv_id+"'" +
				" and s.off_id = so.off_id(+) " ; 
		//   System.out.println("getServiceBaseAll =" + query);
		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
	//	    System.out.println("getServiceBaseAll =" + query);
		  
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
			System.out.println("[PollDatabase:getServiceBaseAll]\n"+e);			
			System.out.println("[PollDatabase:getServiceBaseAll]\n"+query);			
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
		
	
	public String getServiceItemName(String car_mng_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String  item_nm = "";

		String query = "";
		
		query = "SELECT   car_mng_id, serv_id, SUBSTR (MAX (SYS_CONNECT_BY_PATH (item, ', ')), 2) item_nm "+
				"  FROM (SELECT replace(item,',',' ') item,   car_mng_id, serv_id, "+
				"                   ROW_NUMBER () OVER (PARTITION BY car_mng_id, serv_id ORDER BY item) rnum "+
				"              FROM serv_item  where car_mng_id = '" + car_mng_id + "' and serv_id = '" + serv_id + "') "+
				"	START WITH rnum = 1 "+
				"	CONNECT BY PRIOR rnum = rnum - 1 AND PRIOR car_mng_id = car_mng_id and serv_id = serv_id "+
				"	  GROUP BY  car_mng_id, serv_id ";
  
  
		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				item_nm = rs.getString(3);
			}
			rs.close();
			pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:getServiceItemName]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return item_nm;
		}			
	}
	
	//정비call
	public int checkServiceCall(String rent_mng_id, String rent_l_cd, String car_mng_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(*) from service_call 	where  poll_id <> 0 and rent_mng_id = '" + rent_mng_id  + "' and rent_l_cd = '" + rent_l_cd  + "' and car_mng_id = '"+ car_mng_id + "' and serv_id = '" + serv_id + "'";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:checkServiceCall]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}
	
	// 콜센타 정비 call 등록 삭제
	public boolean deleteServiceCall(String rent_mng_id, String rent_l_cd, String car_mng_id, String serv_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " DELETE from service_call where poll_id <> 0 and rent_mng_id =? and rent_l_cd =? and car_mng_id = ? and serv_id = ? ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id);
			pstmt.setString	(2,		rent_l_cd);
			pstmt.setString	(3,		car_mng_id);
			pstmt.setString	(4,		serv_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:deleteServiceCall]\n"+e);
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
	
	// 정비 콜센터 
	public boolean insertServiceCall(ContCallBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = " insert into service_call ( RENT_MNG_ID, RENT_l_CD, CAR_MNG_ID, SERV_ID, POLL_ID, ANSWER, ANSWER_REM, ANSWER_DATE, P_GUBUN, REG_ID, POLL_S_ID ) values ("+
						" ?, ?, ?, ?, ?, ?, ?, sysdate, ?, ?, ?  )";		
		try 
		{
			conn.setAutoCommit(false);

	//		System.out.println (bean.getAnswer_rem().trim());
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getRent_mng_id().trim()	);
			pstmt.setString(2,  bean.getRent_l_cd().trim()	);
			pstmt.setString(3,  bean.getCar_mng_id().trim()	);
			pstmt.setString(4,  bean.getServ_id().trim()	);
			pstmt.setInt(5,  bean.getPoll_id()	);
			pstmt.setString(6,  bean.getAnswer().trim()	);
			pstmt.setString(7,  bean.getAnswer_rem().trim()	);
			pstmt.setString(8,  bean.getP_gubun().trim()	);	
			pstmt.setString(9,  bean.getReg_id().trim()	);		
			pstmt.setInt(10,  	bean.getPoll_s_id() );
					
		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
		  	System.out.println("[PollDatabase:insertServiceCall]\n"+e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[PollDatabase:insertServiceCall]\n"+e);
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
	
	//콜센터 - 정비현황
	public boolean updateServiceCall(ContCallBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		// ANSWER_DATE = sysdate ,
		//String query = " update accident_call set ANSWER = ? , ANSWER_REM = ? , REG_ID = ? where rent_mng_id = ? and rent_l_cd = ? and car_mng_id = ? and accid_id = ? and poll_id = ? ";	
		
		String query = " UPDATE service_call SET ANSWER = '"+bean.getAnswer().trim()+"' ,  "+
						" ANSWER_REM =  '"+bean.getAnswer_rem().trim()+"' , "+
							" REG_ID =  '"+bean.getReg_id().trim()+"' "+
							" where "+
							" rent_mng_id =  '"+bean.getRent_mng_id().trim()+"' "+
							" and rent_l_cd =  '"+bean.getRent_l_cd().trim()+"' "+
							" and car_mng_id =  '"+bean.getCar_mng_id().trim()+"' "+
							" and serv_id =  '"+bean.getServ_id().trim()+"' "+
							" and poll_id =  '"+bean.getPoll_id()+"' ";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);			
		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();

		} catch (SQLException e) {
			System.out.println("[PollDatabase:updateServiceCall]\n" + e);
		  	System.out.println("[PollDatabase:updateServiceCall]\n" + query);
		  	System.out.println("[PollDatabase:updateServiceCall]\n" + bean.getRent_mng_id());
		   	System.out.println("[PollDatabase:updateServiceCall]\n" + bean.getRent_l_cd());
		   	System.out.println("[PollDatabase:updateServiceCall]\n" + bean.getPoll_id());
		   	System.out.println("[PollDatabase:updateServiceCall]\n" + bean.getServ_id());
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:updateServiceCall]\n" + e);
		  	System.out.println("[PollDatabase:updateServiceCall]\n" + query);
		   	System.out.println("[PollDatabase:updateServiceCall]\n" + bean.getRent_mng_id());
		   	System.out.println("[PollDatabase:updateServiceCall]\n" + bean.getRent_l_cd());
		   	System.out.println("[PollDatabase:updateServiceCall]\n" + bean.getPoll_id());
		   	System.out.println("[PollDatabase:updateServiceCall]\n" + bean.getServ_id());
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
     * 정비 콜등록 현황조회
     */
    public Vector getServiceCallAll(String dt,String ref_dt1,String ref_dt2, String gubun2, String sort, String s_kd, String t_wd) 
    {
       	getConnection();
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";    
		String dt1_query = "";    
		String kd_query = "";        
		
		String s_dt1 = "to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";  
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt4 = "to_char(sysdate,'YYYY')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
		
		//정비일		
		if(gubun2.equals("1")){     
			if(dt.equals("1"))								dt_query = " and a.buy_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))							dt_query = " and a.buy_dt like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))							dt_query = " and a.buy_dt like "+s_dt1+"||'%' \n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and a.buy_dt "+s_dt3+"\n";
		} else {
			if(dt.equals("1"))								dt_query = " and cc.answer_date like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))							dt_query = " and cc.answer_date like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))							dt_query = " and cc.answer_date like "+s_dt1+"||'%' \n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and cc.answer_date "+s_dt3+"\n";			
		}		
             
                 //정비일		
		if(gubun2.equals("1")){     
			if(dt.equals("1"))								dt1_query = " and b.p_pay_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))							dt1_query = " and b.p_pay_dt like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))							dt1_query = " and b.p_pay_dt like "+s_dt1+"||'%' \n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt1_query = " and b.p_pay_dt "+s_dt3+"\n";		
		} else {
			if(dt.equals("1"))								dt1_query = " and cc.answer_date like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))							dt1_query = " and cc.answer_date like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))							dt1_query = " and cc.answer_date like "+s_dt1+"||'%' \n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt1_query = " and cc.answer_date "+s_dt3+"\n";				
		}		
			
		if(s_kd.equals("1"))	kd_query += " and v.firm_nm like '%"+ t_wd + "%'";
		else if(s_kd.equals("2"))	kd_query += " and cu.user_nm like '%"+ t_wd + "%'";
		
		query = " select "+
					" nvl(ccc.r_answer, 'N')  r_answer, cq.rr_answer  ,  cc.answer_date,  '카드' p_gubun, a.buy_dt as rent_dt , a.buy_amt, c.user_nm, v.rent_mng_id, v.rent_l_cd, v.firm_nm, cr.car_nm, cn.car_name,\n" +
					" v.con_mon, decode( v.car_gu ,'1','신차','0','재리스')car_gu,\n" +
					" decode(v.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st, v.rent_way,  cr.init_reg_dt, \n"+					
					" to_number(i.seq) seq, i.item_code car_mng_id, i.serv_id, i.acct_cont, i.call_t_nm, i.call_t_tel, cu.user_nm  call_nm\n"+
					" from card_doc a, card b, users c, card_doc_item i , cont_n_view v,  car_reg cr,  car_etc g, car_nm cn , users cu, \n"+
					"      (select rent_mng_id, rent_l_cd, car_mng_id, serv_id, to_char(answer_date, 'YYYYMMDD') AS answer_date, reg_id  from service_call where poll_id <> 0  group by  rent_mng_id, rent_l_cd, car_mng_id, serv_id, reg_id,  to_char(answer_date, 'YYYYMMDD') ) cc , \n"+
				 	"      (select rent_mng_id, rent_l_cd,  car_mng_id, serv_id,  decode(answer, '1', 'Y', 'N' ) r_answer from service_call where poll_id = 70 group by  rent_mng_id, rent_l_cd ,  car_mng_id, serv_id,  decode(answer, '1', 'Y', 'N' ) ) ccc, 	   \n"+
			   		"      (select rent_mng_id, rent_l_cd, car_mng_id, serv_id, decode(answer, '000', 'Y', 'N' ) rr_answer from service_call where poll_id  = 0  group by  rent_mng_id, rent_l_cd , car_mng_id, serv_id, decode(answer, '000', 'Y', 'N' ) ) cq 	   \n"+	
					" where a.cardno=b.cardno and nvl(a.buy_user_id,a.reg_id)=c.user_id(+)  \n"+
					" and a.cardno = i.cardno and a.buy_id = i.buy_id \n"+
					" and i.rent_l_cd = cc.rent_l_cd and i.item_code= cc.car_mng_id and i.serv_id = cc.serv_id \n" + 		
					" and cc.rent_l_cd = ccc.rent_l_cd(+) and  cc.car_mng_id = ccc.car_mng_id(+) and  cc.serv_id  = ccc.serv_id(+) \n" + 		
					" and cc.rent_l_cd = cq.rent_l_cd(+) and  cc.car_mng_id = cq.car_mng_id(+) and  cc.serv_id  = cq.serv_id(+) \n" + 				
					" and a.acct_code = '00005' and a.acct_code_g = '6' and a.buy_dt >= '20100801' \n"+
					dt_query +  kd_query + 
					" and i.rent_l_cd = v.rent_l_cd and v.car_st not in ('2','4','5')  and cc.reg_id = cu.user_id(+)   \n"+
					"	and v.car_mng_id = cr.car_mng_id  and v.rent_mng_id = g.rent_mng_id(+)  and v.rent_l_cd = g.rent_l_cd(+)  \n"+
                       			"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n"+
					"  union all	 \n"+
	     			" select /*+  merge(v) */  "+
	     				"  nvl(ccc.r_answer, 'N')  r_answer, cq.rr_answer  ,   cc.answer_date,  '현금' p_gubun,  b.p_pay_dt as rent_dt , a.i_amt as buy_amt, c.user_nm, v.rent_mng_id, v.rent_l_cd, v.firm_nm ,cr.car_nm ,  cn.car_name,   \n"+
					"	 v.con_mon, decode( v.car_gu ,'1','신차','0','재리스')car_gu,   \n"+
					"	 decode(v.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st, v.rent_way,  cr.init_reg_dt,   \n"+ 				
					"	 a.i_seq seq, a.p_cd3 car_mng_id, a.p_cd5 serv_id, a.p_cont acct_cont, a.call_t_nm, a.call_t_tel, cu.user_nm  call_nm   \n"+
					"	 from pay_item a, pay b, users c,  cont_n_view v,    car_reg cr,  car_etc g, car_nm cn , users cu , \n"+
					"	 (select rent_mng_id, rent_l_cd, car_mng_id, serv_id, to_char(answer_date, 'YYYYMMDD') AS answer_date, reg_id  from service_call where poll_id <> 0  group by  rent_mng_id, rent_l_cd, car_mng_id, serv_id, reg_id, to_char(answer_date, 'YYYYMMDD') ) cc, \n"+
				 	"         (select rent_mng_id, rent_l_cd,  car_mng_id, serv_id,  decode(answer, '1', 'Y', 'N' ) r_answer from service_call where poll_id = 70 group by  rent_mng_id, rent_l_cd ,  car_mng_id, serv_id,  decode(answer, '1', 'Y', 'N' ) ) ccc, 	   \n"+
			   		"         (select rent_mng_id, rent_l_cd, car_mng_id, serv_id, decode(answer, '000', 'Y', 'N' ) rr_answer from service_call where poll_id  = 0  group by  rent_mng_id, rent_l_cd , car_mng_id, serv_id, decode(answer, '000', 'Y', 'N' ) ) cq 	   \n"+	
					"	 where a.reqseq=b.reqseq and nvl(a.buy_user_id, '999999')=c.user_id(+)  \n"+ 					
					"	 and a.p_cd2 = cc.rent_l_cd and  a.p_cd3 = cc.car_mng_id and  a.p_cd5 = cc.serv_id   \n"+
					"        and cc.rent_l_cd = ccc.rent_l_cd(+) and  cc.car_mng_id = ccc.car_mng_id(+) and  cc.serv_id  = ccc.serv_id(+) \n" + 		
					"        and cc.rent_l_cd = cq.rent_l_cd(+) and  cc.car_mng_id = cq.car_mng_id(+) and  cc.serv_id  = cq.serv_id(+) \n" + 				
					"	 and a.acct_code = '45700' and a.acct_code_g = '6' and b.p_pay_dt >= '20100801'   \n"+
					dt1_query + kd_query +
					"	 and a.p_cd2 = v.rent_l_cd and v.car_st not in ('2','4','5') and cc.reg_id = cu.user_id(+)  \n"+
					"	and v.car_mng_id = cr.car_mng_id  and v.rent_mng_id = g.rent_mng_id(+)  and v.rent_l_cd = g.rent_l_cd(+)  \n"+
                       			"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+)  \n";				
						
		query += " order by  1 desc,  3 desc, 5 desc ";		
		
        try{
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
			System.out.println("[PollDatabase:getServiceCallAll]"+e);
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
		
	public String getAnswerDate(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String  answer_dt = "";
		
		String query = "select to_char(answer_date, 'yyyymmdd') from cont_call where poll_id <> 0 and  rent_mng_id = '" + rent_mng_id  + "' and rent_l_cd = '" + rent_l_cd  + "'";
    
		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				answer_dt = rs.getString(1);
			}
            rs.close();
            pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:getAnswerDate]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return answer_dt;
		}			
	}
	
	public String getCallReg_id(String rent_mng_id, String rent_l_cd )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String  answer_dt = "";
		
		String query = "select  reg_id  from cont_call where rent_mng_id = '" + rent_mng_id  + "' and rent_l_cd = '" + rent_l_cd  + "' and rownum = 1";
    
		try 
		{
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery();
			if(rs.next()){
				answer_dt = rs.getString(1);
			}
            rs.close();
            pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:getCallReg_id]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return answer_dt;
		}			
	}
	
	
	/**
	 *	콜센터현황 통계
	 */
	public Hashtable getStatCall(String dt, String ref_dt1, String ref_dt2, String gubun2, String  s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
	
		String dt_query = "";    
		String kd_query = "";        
		String s_dt1 = "to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";  
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt4 = "to_char(sysdate,'YYYY')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

	  // 콜등록일
		if(gubun2.equals("3")){     
			if(dt.equals("1"))				dt_query = " and cc.answer_date2 like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))			dt_query = " and cc.answer_date2 like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))			dt_query = " and cc.answer_date2 like "+s_dt1+"||'%' \n";
			else if(dt.equals("3"))			dt_query = " and cc.answer_date2 "+s_dt3+"\n";
			
		//계약일
		} else if(gubun2.equals("1")){     
			if(dt.equals("1"))				dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))			dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))			dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt1+"||'%' \n";
			else if(dt.equals("3"))			dt_query = " and nvl(b.rent_dt,a.rent_dt) "+s_dt3+"\n";
			
		//대여개시일
		}else{				
			if(dt.equals("1"))				dt_query = "and b.rent_start_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))			dt_query = "and b.rent_start_dt like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))			dt_query = "and b.rent_start_dt like "+s_dt1+"||'%' \n";
			else if(dt.equals("3"))			dt_query = "and b.rent_start_dt "+s_dt3+"\n";
		}        
    
	    	if(s_kd.equals("1"))	kd_query += " and a.rent_l_cd like '%"+ t_wd + "%'";
		else if(s_kd.equals("2"))	kd_query += " and c.firm_nm like '%"+ t_wd + "%'";
		else if(s_kd.equals("3"))	kd_query += " and j.emp_nm  like '%"+ t_wd + "%'";	
		else if(s_kd.equals("4"))	kd_query += " and n.user_nm  like '%"+ t_wd + "%'";	
		
		
		 query =  " select \n "+
			        "	       count(decode(a.r_bus_st,'2', decode(cc.answer, '9', 1))) cnt0, "+
			        "  	       count(decode(a.r_bus_st,'2', decode(cc.answer, '7', 1))) cnt1, "+
		                  "	       count(decode(a.r_bus_st,'9', decode(cc.answer, '9', 1))) cnt2, "+
			        "	       count(decode(a.r_bus_st,'9', decode(cc.answer, '7', 1))) cnt3 "+
			         " from  (select decode(a.bus_st,'2','2','9') r_bus_st, a.*  from cont a where a.car_st <> '4' ) a, fee b, client c, car_reg d, car_etc e, car_nm f, car_mng g, \n"+
			         "       (select rent_mng_id, rent_l_cd, to_char(answer_date, 'YYYY-MM-DD') AS answer_date, to_char(answer_date, 'YYYYMMDD') AS answer_date2, reg_id , decode(answer, '7', '7', '9' ) answer from cont_call where poll_id in ('1', '4', '8' ) group by  rent_mng_id, rent_l_cd, answer_date, reg_id , decode(answer, '7', '7', '9' ) ) cc, \n "+
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='1' and a.emp_id=b.emp_id ) j,\n"+
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='2' and a.emp_id=b.emp_id ) jj,\n"+
				"      users k, users l, users m, users n \n"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2','5') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				dt_query + kd_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+)\n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+)\n"+
				" and a.rent_mng_id=cc.rent_mng_id and a.rent_l_cd=cc.rent_l_cd\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)\n"+
				" and a.mng_id=m.user_id(+)\n"+
				" and cc.reg_id=n.user_id(+)";
								
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
			System.out.println("[PollDatabase:getStatCall]"+e);
			System.out.println("[PollDatabase:getStatCall]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}	
	
	
	public String getCallServiceReg_id(String rent_mng_id, String rent_l_cd, String car_mng_id, String serv_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String  answer_dt = "";
		
		String query = "select  reg_id  from service_call where rent_mng_id = '" + rent_mng_id  + "' and rent_l_cd = '" + rent_l_cd  + "'  and car_mng_id = '"+ car_mng_id + "' and serv_id = '" + serv_id + "' and rownum = 1";
    
		try 
		{
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery();
			if(rs.next()){
				answer_dt = rs.getString(1);
			}
            rs.close();
            pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:getCallServiceReg_id]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return answer_dt;
		}			
	}
	
	
	public Vector CallCnt(String reg_id, String year) 
	{
	       	getConnection();
	        
	         Statement stmt = null;
	         ResultSet rs = null;
	         Vector vt = new Vector();
	         String query = "";
				
		query = " 	select mm, sum(cnt0) cnt0, sum(cnt1) cnt1, sum(cnt2) cnt2  \n"+
			     "	    from (  \n"+
			     "	          select '01'  mm, 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '02' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     " 	          select '03' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '04' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+   
			     "	          select '05' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     " 	           union all \n"+
			     "	          select '06' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '07' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '08' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all   \n"+    
			     "	          select '09'mm  , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '10' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '11' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all  \n"+       
			     "	          select '12' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all  \n"+
			     "	        	 select   substr(replace(cc.answer_date, '-', '') ,5,2) mm, \n"+
			     "		       	       count(decode(cc.answer, '9', 1)) cnt0, \n"+
			     "		         	       count(decode(cc.answer, '7', 1)) cnt1 , \n"+
			     "	                               0 cnt2 \n"+
			     "	           	          from  cont a, fee b, \n"+
			     "				                (select rent_mng_id, rent_l_cd, to_char(answer_date, 'YYYY-MM-DD') AS answer_date , reg_id ,\n"+
			     "						  case when poll_id = '1' and answer = '7' then '7'  \n"+
			     "						        when poll_id = '4' and answer = '7'  then '7' \n"+
			     "						        when poll_id = '8' and answer = '7'  then '7' \n"+
			     "						        when poll_id = '72' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '76' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '77' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '78' and answer = '9'  then '7' \n"+
			     "						        when poll_id = '79' and answer = '9'  then '7' \n"+
			     "						        when poll_id = '80' and answer = '9'  then '7' \n"+
		     	     "						        when poll_id = '81' and answer = '10'  then '7' \n"+
			     "						        when poll_id = '82' and answer = '10'  then '7' \n"+
			     "						        when poll_id = '83' and answer = '10'  then '7' \n"+
			     "						        else '9' end   answer from cont_call where poll_id in  ('1', '4', '8' , '72', '76', '77' ,  '78', '79', '80', '81', '82', '83' ) group by  rent_mng_id, rent_l_cd, to_char(answer_date, 'YYYY-MM-DD'), reg_id ,  \n"+
			      "						  case when poll_id = '1' and answer = '7' then '7'  \n"+
			     "						        when poll_id = '4' and answer = '7'  then '7' \n"+
			     "						        when poll_id = '8' and answer = '7'  then '7' \n"+
			     "						        when poll_id = '72' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '76' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '77' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '78' and answer = '9'  then '7' \n"+
			     "						        when poll_id = '79' and answer = '9'  then '7' \n"+
			     "						        when poll_id = '80' and answer = '9'  then '7' \n"+	
			      "						        when poll_id = '81' and answer = '10'  then '7' \n"+
			     "						        when poll_id = '82' and answer = '10'  then '7' \n"+
			     "						        when poll_id = '83' and answer = '10'  then '7' \n"+	
			     " 					           	else '9' end  ) cc  \n"+	
			     "					 where nvl(a.use_yn,'Y')='Y' and a.car_st<> '2' and a.car_gu <> '4' \n"+
		              "		 				 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
			     "					 and cc.answer_date like '"+year+"%'  \n"+			   
			     "					 and a.rent_mng_id=cc.rent_mng_id and a.rent_l_cd=cc.rent_l_cd	\n"+	
			     "					 and cc.reg_id='"+ reg_id + "'  \n"+
			     "	        group by substr(replace(cc.answer_date, '-', '') ,5,2)     \n"+
			     "	    union all    \n"+
			     "	      select   substr(to_char(cc.answer_date, 'YYYYMMDD'),5, 2) mm, 0 cnt0, 0 cnt1 , count(cc.poll_id) cnt2 \n"+
			     "	            from service_call cc where cc.poll_id = 47   and     to_char(answer_date, 'YYYY')= '"+year+"'  \n"+
			     "					 and cc.reg_id='"+ reg_id + "'  \n"+
			     "	            group by  substr(to_char(cc.answer_date, 'YYYYMMDD'),5, 2)  	\n"+	 	  
			     "   union all    \n"+
			     "	      select   substr(to_char(cc.answer_date, 'YYYYMMDD'),5, 2) mm, 0 cnt0, 0 cnt1 , count(cc.poll_id) cnt2 \n"+
			     "	            from accident_call cc where cc.poll_id = 61   and     to_char(answer_date, 'YYYY')= '"+year+"'  \n"+
			     "					 and cc.reg_id='"+ reg_id + "'  \n"+
			     "	            group by  substr(to_char(cc.answer_date, 'YYYYMMDD'),5, 2)  	\n"+   	        
		 	     "	    ) a \n"+
			     "	    group by mm \n"+
			     "	    order by mm  ";
    		
		
        try{
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
			System.out.println("[PollDatabase:CallCnt]"+e);
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


	//사고call
	public int checkAccidentCall(String rent_mng_id, String rent_l_cd, String car_mng_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(*) from accident_call 	where  poll_id <> 0 and rent_mng_id = '" + rent_mng_id  + "' and rent_l_cd = '" + rent_l_cd  + "' and car_mng_id = '"+ car_mng_id + "' and accid_id = '" + accid_id + "'";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
            rs.close();
            pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:checkAccidentCall]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}
	
	// 콜센타 사고 등록 삭제
	public boolean deleteAccidentCall(String rent_mng_id, String rent_l_cd, String car_mng_id, String accid_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " DELETE from accident_call where poll_id <> 0 and rent_mng_id =? and rent_l_cd =? and car_mng_id = ? and accid_id = ? ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id);
			pstmt.setString	(2,		rent_l_cd);
			pstmt.setString	(3,		car_mng_id);
			pstmt.setString	(4,		accid_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:deleteAccidentCall]\n"+e);
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
	
	// 정비 콜센터 
	public boolean insertAccidentCall(ContCallBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = " insert into accident_call ( RENT_MNG_ID, RENT_l_CD, CAR_MNG_ID, ACCID_ID, POLL_ID, ANSWER, ANSWER_REM, ANSWER_DATE, P_GUBUN, REG_ID, POLL_S_ID ) values ("+
						" ?, ?, ?, ?, ?, ?, ?, sysdate, ?, ?, ?  )";		
		try 
		{
			conn.setAutoCommit(false);

	//		System.out.println (bean.getAnswer_rem().trim());
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getRent_mng_id().trim()	);
			pstmt.setString(2,  bean.getRent_l_cd().trim()	);
			pstmt.setString(3,  bean.getCar_mng_id().trim()	);
			pstmt.setString(4,  bean.getAccid_id().trim()	);
			pstmt.setInt(5,  bean.getPoll_id()	);
			pstmt.setString(6,  bean.getAnswer().trim()	);
			pstmt.setString(7,  bean.getAnswer_rem().trim()	);
			pstmt.setString(8,  bean.getP_gubun().trim()	);	
			pstmt.setString(9,  bean.getReg_id().trim()	);	
			pstmt.setInt(10,  	bean.getPoll_s_id() );
					
		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
		  	System.out.println("[PollDatabase:insertAccidentCall]\n"+e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[PollDatabase:insertAccidentCall]\n"+e);
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
	
	
	public Vector CallCnt(String reg_id, String year, String mon) 
	{
	       	getConnection();
	        
	         Statement stmt = null;
	         ResultSet rs = null;
	         Vector vt = new Vector();
	         String query = "";
	         String st_mon = "";
	         
	         st_mon = AddUtil.addZero(mon);
				
		     
			     
		query = " 	     select  a.user_id, u.user_nm, u.dept_id,  c.nm as dept_nm,   sum(cnt0) cnt0, sum(cnt1) cnt1, sum(cnt2) cnt2 , sum(cnt3) cnt3   \n"+	
			     "	          from (   \n"+	
			     "	                     select   a.bus_id user_id,  count(cc.answer) cnt0,   0 cnt1 ,     0 cnt2 , 0 cnt3   \n"+	
		              "		                               from  cont a, fee b,    \n"+	
		              "		                                        (select rent_mng_id, rent_l_cd, to_char(answer_date, 'YYYY-MM-DD') AS answer_date , reg_id , decode(answer, '7', '7', '9' ) answer from cont_call where poll_id in ('1', '4', '8' , '72', '76', '77' ,  '78', '79', '80') group by  rent_mng_id, rent_l_cd, to_char(answer_date, 'YYYY-MM-DD'), reg_id , decode(answer, '7', '7', '9' ) ) cc  	   \n"+					      	
			    "	                              where nvl(a.use_yn,'Y')='Y' and a.car_st<> '2' and a.car_gu <> '4'    \n"+	
			    "	                             and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd    \n"+	
			    "	                             and replace(cc.answer_date, '-', '') like '"+year+st_mon+"%'  	  \n"+			   
			    "	                             and a.rent_mng_id=cc.rent_mng_id and a.rent_l_cd=cc.rent_l_cd	   \n"+				     					
			    "	                             group by a.bus_id   \n"+	
			    "	                     union all   \n"+	
			    "	                        select   a.bus_id user_id,  0 cnt0,   sum(decode(cc.answer, '1', 1, 0) )  cnt1 ,    0 cnt2 , 0 cnt3    \n"+	
			    "	                               from  cont a, fee b,    \n"+	
			    "	                                        (select rent_mng_id, rent_l_cd, to_char(answer_date, 'YYYY-MM-DD') AS answer_date , reg_id , decode(answer, '1', '1', '9' ) answer from cont_call where poll_id in ('67', '68', '69' ) group by  rent_mng_id, rent_l_cd, to_char(answer_date, 'YYYY-MM-DD'), reg_id , decode(answer, '1', '1', '9' ) ) cc  		   \n"+				      	
			    "	                             where nvl(a.use_yn,'Y')='Y' and a.car_st<> '2' and a.car_gu <> '4'    \n"+	
			    "	                             and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd    \n"+	
			    "	                             and replace(cc.answer_date, '-', '') like '"+year+st_mon+"%'  	   \n"+			   
			    "	                             and a.rent_mng_id=cc.rent_mng_id and a.rent_l_cd=cc.rent_l_cd	  \n"+				     					
			    "	                             group by a.bus_id     \n"+	
			    "	                     union all     \n"+	
			    "	                     select    c.mng_id user_id,  0 cnt0, 0 cnt1 , count(cc.poll_id) cnt2 , 0 cnt3     \n"+	
			    "				   	            from service_call cc  , cont c     \n"+	
			    "	                             where cc.rent_mng_id = c.rent_mng_id and cc.rent_l_cd = c.rent_l_cd and cc.poll_id = 47     \n"+	
			    "	                            and     to_char(answer_date, 'YYYYMMDD') like '"+year+st_mon+"%'       \n"+				   				
			    "	                           group by  c.mng_id	        \n"+	
			    "	                     union all     \n"+	
			    "	                     select    c.mng_id user_id,  0 cnt0, 0 cnt1 , 0 cnt2 , sum(decode(cc.answer, '1', 1, 0) ) cnt3     \n"+	
			    "				   	            from service_call cc  , cont c      \n"+	
			    "	                             where cc.rent_mng_id = c.rent_mng_id and cc.rent_l_cd = c.rent_l_cd and cc.poll_id = 70      \n"+	
			    "	                            and     to_char(answer_date, 'YYYYMMDD') like '"+year+st_mon+"%'  	    \n"+				   				
			    "	                           group by  c.mng_id	     \n"+	   
			    "	                      union all    \n"+	
			    "	                     select     c.mng_id user_id, 0 cnt0, 0 cnt1 , count(cc.poll_id) cnt2 , 0 cnt3     \n"+	
			    "	                                    from accident_call cc , cont c     \n"+	
			    "	                                    where cc.rent_mng_id = c.rent_mng_id and cc.rent_l_cd = c.rent_l_cd and cc.poll_id = 61       \n"+	
			    "	                                    and     to_char(answer_date, 'YYYYMMDD') like '"+year+st_mon+"%'       \n"+	
			    "	                                     group by  c.mng_id	         \n"+	
			    "	              union all      \n"+	
			    "	              select   c.mng_id user_id, 0 cnt0, 0 cnt1 , 0 cnt2, sum(decode(cc.answer, '1', 1, 0) ) cnt3     \n"+	
			    "	                                    from accident_call cc , cont c    \n"+	
			    "	                                    where cc.rent_mng_id = c.rent_mng_id and cc.rent_l_cd = c.rent_l_cd and cc.poll_id = 71       \n"+	
			    "	                                    and     to_char(answer_date, 'YYYYMMDD') like '"+year+st_mon+"%'  	    \n"+			 
			    "	                                    group by  c.mng_id	      \n"+	
			   "	 ) a, users u , (select * from CODE where c_st='0002') c    \n"+	
			   "          where a.user_id = u.user_id and u.use_yn = 'Y'  and u.dept_id = c.code(+)   \n"+	
			   "          group by a.user_id,u.user_nm, u.dept_id, u.user_pos , c.nm  \n"+	
			   "          order by u.dept_id ,  decode(u.user_pos, '차장', 1, '과장',2,'대리', 3, 4) ";
    		
		
        try{
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
			System.out.println("[PollDatabase:CallCnt]"+e);
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
	
	
		// 콜센타 -  계약 대표 통화 등록
	public boolean updateContCallReq(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update cont_call set answer = '000'    where rent_mng_id =? and rent_l_cd =? and poll_id=0 ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id);
			pstmt.setString	(2,		rent_l_cd);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:updateContCallReq]\n"+e);
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
		
		// 콜센타 -  계약 대표 통화 등록
	public boolean updateReqServCall(String rent_mng_id, String rent_l_cd, String car_mng_id, String serv_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update service_call set answer = '000'    where rent_mng_id =? and rent_l_cd =? and car_mng_id = ? and serv_id = ? and poll_id=0 ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id);
			pstmt.setString	(2,		rent_l_cd);
			pstmt.setString	(3,		car_mng_id);
			pstmt.setString	(4,		serv_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:updateReqServCall]\n"+e);
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
			
			
			// 콜센타 -  계약 대표 통화 등록
	public boolean updateReqAccidentCall(String rent_mng_id, String rent_l_cd, String car_mng_id, String accid_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update accident_call set answer = '000'    where rent_mng_id =? and rent_l_cd =? and car_mng_id = ? and accid_id = ? and poll_id=0 ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id);
			pstmt.setString	(2,		rent_l_cd);
			pstmt.setString	(3,		car_mng_id);
			pstmt.setString	(4,		accid_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:updateReqAccidentCall]\n"+e);
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
	

 	public String getCallAccidentReg_id(String rent_mng_id, String rent_l_cd, String car_mng_id, String accid_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String  answer_dt = "";
		
		String query = "select  reg_id  from accident_call where rent_mng_id = '" + rent_mng_id  + "' and rent_l_cd = '" + rent_l_cd  + "'  and car_mng_id = '"+ car_mng_id + "' and accid_id = '" + accid_id + "' and rownum = 1";
    
		try 
		{
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery();
			if(rs.next()){
				answer_dt = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:getCallAccidentReg_id]"+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return answer_dt;
		}			
	}	
	






/****************************/

public String getPollNextId()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String query = "";
		String  poll_id= "";

		query = "  select NVL(MAX(poll_id), 0)+1  as POLL_ID from SURVEY ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   				if(rs.next())
		    	{
		    		poll_id=rs.getString(1)==null?"1":rs.getString(1);

		    	}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[PollDatabase:getPollNextSeq]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return poll_id;
		}		
	}

public String getPollNextSeq(int poll_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String query = "";
		String  poll_seq= "";

		query = "  select NVL(MAX(poll_seq), 0)+1  as POLL_SEQ from SURVEY_POLL WHERE poll_id = '"+poll_id+"' ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   				if(rs.next())
		    	{
		    		poll_seq=rs.getString(1)==null?"1":rs.getString(1);

		    	}
			rs.close();
			pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[PollDatabase:getPollNextSeq]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return poll_seq;
		}		
	}


//콜항목 survey 등록
	public SurveyPollBean insertSurvey(SurveyPollBean poll)
	{
		getConnection();
		PreparedStatement pstmt = null;

		
		String query = " insert into SURVEY ( POLL_ID, USE_YN, " +
						" POLL_ST, POLL_TYPE, POLL_TITLE, START_DT, END_DT, REG_ID, REG_DT, POLL_SU ) values ("+
						" ?, ?, "+
						" ?, ?, ?, replace(?,'-',''), replace(?,'-',''), ?, to_char(sysdate,'YYYYMMDD'), ? ) "+
						" ";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1,		poll.getPoll_id()			);
			pstmt.setString(2,  poll.getUse_yn().trim()	);
			pstmt.setString(3,  poll.getPoll_st().trim()	);
			pstmt.setString(4,  poll.getPoll_type().trim()	);
			pstmt.setString(5,  poll.getPoll_title().trim()	);
			pstmt.setString(6,  poll.getStart_dt()	);
			pstmt.setString(7,  poll.getEnd_dt()	);
			pstmt.setString(8,  poll.getReg_id()	);
			pstmt.setInt(9,		poll.getPoll_su()			);

		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();

	  	} catch (Exception e) {
		  	System.out.println("[PollDatabase:insertSurvey]\n"+e);
			System.out.println("[PollDatabase:insertSurvey]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return poll;
		}
	}
	



//콜항목 survey_poll 한건 등록
	public boolean insertSurvey_poll(SurveyPollBean poll)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

			

		query = " INSERT INTO SURVEY_POLL ( "+
				" POLL_ID, POLL_SEQ, A_SEQ, CONTENT, CHK ) "+
				" values ( ?, ?, ?, ?, ? )"+
				" ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1,		poll.getPoll_id()			);
			pstmt.setInt(2,		poll.getPoll_seq()	);
			pstmt.setInt(3,		poll.getA_seq	());
			pstmt.setString	(4,		poll.getContent());
			pstmt.setString	(5,		poll.getChk());			

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:insertSurvey_poll]\n"+e);
			System.out.println("[PollDatabase:insertSurvey_poll]\n"+query);
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



//survey 리스트
	public Vector getSurvey_list(String gubun1, String gubun2, String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT a.POLL_ID, DECODE(a.USE_YN,'Y','사용','N','미사용') USE_NM, a.POLL_ST, a.POLL_TITLE, a.POLL_TYPE, a.START_DT,  NVL(a.END_DT,'99991231') AS end_dt, a.REG_ID, a.REG_DT, a.POLL_SU, b.USER_NM \n"+
				" FROM SURVEY a, USERS b WHERE  a.REG_ID=b.USER_ID  \n"+
				" ";

		if(!gubun1.equals("")){
			if(!gubun1.equals("") && !gubun2.equals("")){
				query += " and a.poll_type = '"+gubun1+"' and a.poll_st = '"+gubun2+"' ";
			}else if(!gubun1.equals("") && gubun2.equals("")){
				query += " and a.poll_type = '"+gubun1+"' ";
			}
		}

		if(!gubun3.equals("")){
			query +=" and a.use_yn = '"+gubun3+"' ";
		}

		query += " order by decode(a.poll_type,'계약','1','순회정비','2','사고처리','3'), decode(a.poll_st,'대차','1','증차','2','재리스','3','월렌트','4','순회정비','5','사고처리','6'), a.reg_dt desc,  a.poll_su DESC ";

//System.out.println("[PollDatabase:getSurvey_list]"+query);
	

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
			System.out.println("[PollDatabase:getSurvey_list]"+e);
			System.out.println("[PollDatabase:getSurvey_list]"+query);
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


//설문기본 셋팅값
	public Hashtable getSurvey_Basic(String poll_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " SELECT a.POLL_ID, a.USE_YN, a.POLL_ST, a.POLL_TITLE, a.POLL_TYPE, a.START_DT,  NVL(a.END_DT,'99991231') AS end_dt, a.REG_ID,	a.REG_DT, \n"+
				" a.poll_st, a.poll_type, a.poll_su \n"+
				" FROM SURVEY a WHERE  a.use_yn = 'Y' and a.poll_id = '"+ poll_id + "' \n"+
				" "; 

		//   System.out.println("getSurvey_Basic =" + query);

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
			System.out.println("[PollDatabase:getSurvey_Basic]\n"+e);			
			System.out.println("[PollDatabase:getSurvey_Basic]\n"+query);			
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



//설문회차별 질문 리스트 
	public Vector getSurvey_viewAll(String poll_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.POLL_ID, b.POLL_SEQ, b.A_SEQ, b.CONTENT, b.CHK, b.MULTI_CHK \n"+
				" FROM SURVEY a, SURVEY_POLL b WHERE a.POLL_ID=b.POLL_ID   \n"+
				" and a.poll_id = '"+ poll_id + "' and b.a_seq = '0' \n"+
				" ";

		query += " order by a.poll_id, b.poll_seq, b.a_seq  ";
	
		try {
		//	System.out.println ("getSurvey_view=" + query);
			
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
			System.out.println("[PollDatabase:getSurvey_view]"+e);
			System.out.println("[PollDatabase:getSurvey_view]"+query);
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
	
	
//설문회차별 질문 리스트 
	public Vector getSurvey_view(String poll_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.POLL_ID, b.POLL_SEQ, b.A_SEQ, b.CONTENT, b.CHK, b.MULTI_CHK \n"+
				" FROM SURVEY a, SURVEY_POLL b WHERE a.POLL_ID=b.POLL_ID  AND  a.use_yn = 'Y' \n"+
				" and a.poll_id = '"+ poll_id + "' and b.a_seq = '0' \n"+
				" ";

		query += " order by a.poll_id, b.poll_seq, b.a_seq  ";
	
		try {
		//	System.out.println ("getSurvey_view=" + query);
			
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
			System.out.println("[PollDatabase:getSurvey_view]"+e);
			System.out.println("[PollDatabase:getSurvey_view]"+query);
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


//설문회차별 답변 리스트 
	public Vector getSurvey_answer(String poll_id, String poll_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.POLL_ID, b.POLL_SEQ, b.A_SEQ, b.CONTENT, b.CHK, b.MULTI_CHK \n"+
				" FROM SURVEY a, SURVEY_POLL b WHERE a.POLL_ID=b.POLL_ID  AND  a.use_yn = 'Y' \n"+
				" and b.poll_id = '"+ poll_id + "' and b.poll_seq = '"+ poll_seq + "' and b.a_seq <> '0' \n"+
				" ";

		query += " order by a.poll_id, b.poll_seq, b.a_seq  ";
	
		try {
		//	System.out.println ("getSurvey_view=" + query);
			
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
			System.out.println("[PollDatabase:getSurvey_answer]"+e);
			System.out.println("[PollDatabase:getSurvey_answer]"+query);
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


//설문회차별 1개 문항 리스트 
	public Vector getSurvey_One_view(String poll_id, String poll_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.POLL_ID, b.POLL_SEQ, b.A_SEQ, b.CONTENT, b.CHK, b.MULTI_CHK \n"+
				" FROM SURVEY a, SURVEY_POLL b WHERE a.POLL_ID=b.POLL_ID  AND  a.use_yn = 'Y' \n"+
				" and a.poll_id = '"+ poll_id + "' and b.poll_seq = '"+ poll_seq + "' \n"+
				" ";

		query += " order by a.poll_id, b.poll_seq, b.a_seq  ";

//	System.out.println ("getSurvey_One_view=" + query);

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
			System.out.println("[PollDatabase:getSurvey_One_view]"+e);
			System.out.println("[PollDatabase:getSurvey_One_view]"+query);
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


//설문전체 삭제
	public boolean deleteSurvey_poll_all(SurveyPollBean poll)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		String query = "";
		String query1 = "";

			
		query = "  DELETE from SURVEY where poll_id = '"+poll.getPoll_id()+"' ";

		query1 = "  DELETE from SURVEY_POLL where poll_id ='"+poll.getPoll_id()+"'  ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.executeUpdate();
			pstmt1.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:deleteSurvey_poll_all]\n"+e);
			System.out.println("[PollDatabase:deleteSurvey_poll_all]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

//설문 문항 한건 삭제
	public boolean deleteSurvey_poll_one(SurveyPollBean poll)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "";

			
		query = "  DELETE from SURVEY_POLL where poll_id ='"+poll.getPoll_id()+"' and poll_seq = '"+poll.getPoll_seq()+"' ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:deleteSurvey_poll_one]\n"+e);
			System.out.println("[PollDatabase:deleteSurvey_poll_one]\n"+query);
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

//콜항목 survey_poll 한건 수정
	public boolean updateSurvey_poll(SurveyPollBean poll)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

				query = " UPDATE SURVEY_POLL SET "+
						" CONTENT = ?, "+
						" CHK = ? "+
						" WHERE POLL_ID = ? AND POLL_SEQ = ? AND A_SEQ = ? ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		poll.getContent());
			pstmt.setString	(2,		poll.getChk());			
			pstmt.setInt(3,		poll.getPoll_id()			);
			pstmt.setInt(4,		poll.getPoll_seq()	);
			pstmt.setInt(5,		poll.getA_seq	());


			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:updateSurvey_poll]\n"+e);
			System.out.println("[PollDatabase:updateSurvey_poll]\n"+query);
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



//콜항목 survey_poll 한건 수정
	public boolean updateSurvey_basic(SurveyPollBean poll)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = " UPDATE SURVEY SET "+
						" USE_YN = ?, "+
						" POLL_SU = ?, "+
						" POLL_TITLE = ?, "+
						" START_DT = replace(?,'-',''), "+
						" END_DT = replace(?,'-','') "+
						" WHERE POLL_ID = ? ";

//System.out.println("[PollDatabase:updateSurvey_basic=]\n"+query);
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		poll.getUse_yn());
			pstmt.setInt	(2,		poll.getPoll_su());
			pstmt.setString	(3,		poll.getPoll_title());			
			pstmt.setString	(4,		poll.getStart_dt());			
			pstmt.setString	(5,		poll.getEnd_dt());			
			pstmt.setInt(6,		poll.getPoll_id());								
	
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+e);
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+poll.getUse_yn());
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+poll.getPoll_su());
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+poll.getPoll_title());
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+poll.getStart_dt());
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+poll.getPoll_id());

			e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+e);
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+poll.getUse_yn());
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+poll.getPoll_su());
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+poll.getPoll_title());
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+poll.getStart_dt());
			System.out.println("[PollDatabase:updateSurvey_basic]\n"+poll.getPoll_id());
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



public String getPollNextSu(String poll_type, String poll_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String query = "";
		String  poll_su= "";

		query = "  select NVL(MAX(poll_su), 0)+1  as POLL_SU from SURVEY WHERE poll_type = '"+poll_type+"' and poll_st = '"+poll_st+"' ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   				if(rs.next())
		    	{
		    		poll_su=rs.getString(1)==null?"1":rs.getString(1);

		    	}
				rs.close();
				pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[PollDatabase:getPollNextSu]\n"+e);
			System.out.println("[PollDatabase:getPollNextSu]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return poll_su;
		}		
	}

public String getPollSearchSu(String poll_type, String poll_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String query = "";
		String  poll_su= "";

		query = "  select  MAX(poll_su) AS POLL_SU from SURVEY WHERE poll_type = '"+poll_type+"' and poll_st = '"+poll_st+"' ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   				if(rs.next())
		    	{
		    		poll_su=rs.getString(1)==null?"":rs.getString(1);

		    	}
				rs.close();
				pstmt.close();
			
		} catch (SQLException e) {
			System.out.println("[PollDatabase:getPollSearchSu]\n"+e);
			System.out.println("[PollDatabase:getPollSearchSu]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return poll_su;
		}		
	}


	/**
	 *	
	 */
	public Vector getSurvey_Play_Q(String poll_st, String search_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		 
        query = " SELECT a.POLL_SU, a.POLL_TITLE, a.START_DT, a.END_DT, a.USE_YN, b.POLL_ID, b.POLL_SEQ, b.A_SEQ, b.CONTENT "+
				" FROM SURVEY a, SURVEY_POLL b, "+
				" (SELECT poll_id, poll_su as max_su FROM SURVEY WHERE USE_YN = 'Y'AND poll_st = '"+poll_st+"' AND  TO_DATE('"+search_dt+"','YYYY-MM-DD') BETWEEN TO_DATE(start_dt,'YYYY-MM-DD') AND TO_DATE(NVL(end_dt,'99991231'),'YYYY-MM-DD') + 0.99999 )c "+
				" WHERE a.POLL_ID=b.POLL_ID AND a.POLL_su = c.max_su AND a.use_yn = 'Y'  AND b.a_seq = '0' AND a.poll_st = '"+poll_st+"' "+
				"";

		query += "	ORDER BY a.poll_id, b.poll_seq, b.a_seq"; 
       


	
		try {
//System.out.println ("getSurvey_Play_Q_rent_start_dt=" + search_dt);
//System.out.println ("getSurvey_Play_Q=" + query);
			
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
			
			// System.out.println("[PollDatabase:getSurvey_Play_Q]"+query);

		} catch (SQLException e) {
			System.out.println("[PollDatabase:getSurvey_Play_Q]"+e);
			System.out.println("[PollDatabase:getSurvey_Play_Q]"+query);
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



	public Hashtable getSurvey_Play_Basic(String poll_st)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " SELECT a.POLL_SU, a.POLL_TITLE, a.START_DT, a.END_DT, a.USE_YN "+
				" FROM SURVEY a, (SELECT poll_id, MAX(poll_su) max_su FROM SURVEY WHERE USE_YN = 'Y' AND poll_st = '"+ poll_st + "' )c  "+
				" WHERE a.POLL_su = c.max_su AND a.use_yn = 'Y' AND a.poll_st = '"+ poll_st + "' \n"+
				" "; 

		//   System.out.println("getSurvey_Play_Basic =" + query);

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
			System.out.println("[PollDatabase:getSurvey_Play_Basic]\n"+e);			
			System.out.println("[PollDatabase:getSurvey_Play_Basic]\n"+query);			
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


public Vector getSurveyContPollAll(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.POLL_ID, b.content, a.ANSWER, a.ANSWER_REM, a.POLL_S_ID, b.poll_seq "+
				" FROM cont_call a, SURVEY_POLL b "+
				" WHERE a.poll_id <> 0 AND a.poll_s_id= b.poll_id AND a.POLL_ID = b.POLL_SEQ AND b.A_SEQ = '0' "+
				" AND a.rent_mng_id = '" + rent_mng_id  + "' AND a.rent_l_cd = '" + rent_l_cd  + "' "+
				" ";

		query += "ORDER BY b.poll_seq ";

//System.out.println("[PollDatabase:getSurveyPollAll]\n"+query);
	
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



//사고call 
       public Vector getSurveyAccidentPollAll(String rent_mng_id, String rent_l_cd, String car_mng_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.POLL_ID, b.content, a.ANSWER, a.ANSWER_REM, a.POLL_S_ID, b.POLL_SEQ  "+
				" FROM accident_call a, SURVEY_POLL b "+
				" WHERE a.poll_id <> 0  AND a.poll_s_id= b.poll_id AND a.POLL_ID = b.POLL_SEQ AND b.A_SEQ = '0' "+
				" and  a.rent_mng_id = '" + rent_mng_id  + "' and a.rent_l_cd = '" + rent_l_cd  + "' and a.car_mng_id = '"+ car_mng_id + "' and a.accid_id = '" + accid_id + "'" +
				"  ";
		query += " order by b.poll_seq ";

//System.out.println("[PollDatabase:getSurveyAccidentPollAll]"+query);
	
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
			System.out.println("[PollDatabase:getSurveyAccidentPollAll]"+e);
			System.out.println("[PollDatabase:getSurveyAccidentPollAll]"+query);
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
		


//정비콜
 public Vector getSurveyServicePollAll(String rent_mng_id, String rent_l_cd, String car_mng_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.POLL_ID, b.content, a.ANSWER, a.ANSWER_REM , a.POLL_S_ID, b.POLL_SEQ "+
				" FROM service_call a, SURVEY_POLL b "+
				" WHERE a.poll_id <> 0 AND a.poll_s_id= b.poll_id AND a.POLL_ID = b.POLL_SEQ AND b.A_SEQ = '0' "+
				" and  a.rent_mng_id = '" + rent_mng_id  + "' and a.rent_l_cd = '" + rent_l_cd  + "' and a.car_mng_id = '"+ car_mng_id + "' and a.serv_id = '" + serv_id + "'" +
				" ";

		query += " order by b.poll_seq ";

//System.out.println("[PollDatabase:getSurveyServicePollAll]"+query);	

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
			System.out.println("[PollDatabase:getSurveyServicePollAll]"+e);
			System.out.println("[PollDatabase:getSurveyServicePollAll]"+query);
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



//통계검색화면용
	public Vector getSurvey_All_list(String poll_type, String poll_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT a.POLL_ID, DECODE(a.USE_YN,'Y','사용','N','미사용') USE_NM, a.POLL_ST, a.POLL_TITLE, a.POLL_TYPE, a.START_DT,  NVL(a.END_DT,'99991231') AS end_dt, a.REG_ID, a.REG_DT, a.POLL_SU \n"+
				" FROM SURVEY a  where a.poll_type =  '"+ poll_type + "' and a.poll_st =  '"+ poll_st + "' \n"+
				" ";

	
		query += " ORDER BY a.POLL_TYPE, a.POLL_ST, a.POLL_ID desc ";

//System.out.println("[PollDatabase:getSurvey_All_list]"+query);
	

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
			System.out.println("[PollDatabase:getSurvey_All_list]"+e);
			System.out.println("[PollDatabase:getSurvey_All_list]"+query);
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
	 *	계약 Poll 리스트
	 */
	public Vector getSurveyContPollTot(String ref_dt1, String ref_dt2, String poll_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " select 'A' gubun, b.p_cont, a.poll_s_id, a.poll_id, b.a_cnt, a.cnt1, a.cnt2, a.cnt3, a.cnt4, a.cnt5, a.cnt6, a.cnt7, a.cnt8, a.cnt9, a.cnt10, a.cnt11 \n"+
				" from (select poll_s_id, poll_id, \n"+
				" to_char(count(decode(answer,'1',poll_id))) cnt1, to_char(count(decode(answer,'2',poll_id))) cnt2, \n"+
				" to_char(count(decode(answer,'3',poll_id))) cnt3, to_char(count(decode(answer,'4',poll_id))) cnt4, \n"+
				" to_char(count(decode(answer,'5',poll_id))) cnt5, to_char(count(decode(answer,'6',poll_id))) cnt6, \n"+
				" to_char(count(decode(answer,'7',poll_id))) cnt7, to_char(count(decode(answer,'8',poll_id))) cnt8,  to_char(count(decode(answer,'9',poll_id))) cnt9, to_char(count(decode(answer,'10',poll_id))) cnt10, to_char(count(0)) cnt11 \n"+
				" from   cont_call \n"+
				" where  poll_s_id='"+poll_id+"' and to_char(answer_date,'YYYYMMDD') between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') group by poll_s_id, poll_id) a,  \n"+
				" (select poll_id, poll_seq, count(0)-1 as a_cnt, max(decode(a_seq,0,content)) p_cont  from survey_poll group by poll_id, poll_seq) b \n"+
				" where a.poll_s_id=b.poll_id and a.poll_id=b.poll_seq  \n"+
				" union all \n"+
				" select 'Q' gubun, '' p_cont, poll_id as poll_s_id, poll_seq as poll_id, count(0)-1 as a_cnt, \n"+
				" max(decode(a_seq,1,content)) cnt1, max(decode(a_seq,2,content)) cnt2, \n"+
				" max(decode(a_seq,3,content)) cnt3, max(decode(a_seq,4,content)) cnt4, \n"+
				" max(decode(a_seq,5,content)) cnt5, max(decode(a_seq,6,content)) cnt6, \n"+
				" max(decode(a_seq,7,content)) cnt7, max(decode(a_seq,8,content)) cnt8, max(decode(a_seq,9,content)) cnt9, max(decode(a_seq,10,content)) cnt10, '합계' cnt11 \n"+
				" from   survey_poll \n"+
				" where  poll_id='"+poll_id+"' group by poll_id, poll_seq order by 3,4,1 desc"+
				"  ";

//			System.out.println("[PollDatabase:getSurveyContPollTot]"+query);

	
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
			System.out.println("[PollDatabase:getSurveyContPollTot]"+e);
			System.out.println("[PollDatabase:getSurveyContPollTot]"+query);
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
	 *	정비 Poll 리스트
	 */
	public Vector getSurveyServicePollTot()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

         query = " SELECT poll_s_id, poll_id, "+
				" (SELECT content FROM survey_poll WHERE poll_id  = a.poll_s_id AND poll_seq = a.poll_id AND a_seq = 0 ) content, "+
				" COUNT(DECODE(answer, 1, 1)) a1, COUNT(DECODE(answer, 2, 1)) a2, COUNT(DECODE(answer, 4, 1)) a4, COUNT(DECODE(answer, 3, 1)) a3, COUNT(DECODE(answer, 5, 1)) a5 "+
				" FROM SERVICE_CALL a WHERE poll_s_id IS NOT NULL "+
				" GROUP BY poll_s_id, poll_id "+
				"  ";
	query += "  ORDER BY poll_s_id, poll_id ";

//			System.out.println("[PollDatabase:getSurveyContPollTot]"+query);

	
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
			System.out.println("[PollDatabase:getSurveyServicePollTot]"+e);
			System.out.println("[PollDatabase:getSurveyServicePollTot]"+query);
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
	 *	사고 Poll 리스트
	 */
	public Vector getSurveyAccidentPollTot()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

       query = " SELECT poll_s_id, poll_id, "+
				" (SELECT content FROM survey_poll WHERE poll_id  = a.poll_s_id AND poll_seq = a.poll_id AND a_seq = 0 ) content, "+
				" COUNT(DECODE(answer, 1, 1)) a1, COUNT(DECODE(answer, 2, 1)) a2, COUNT(DECODE(answer, 4, 1)) a4, COUNT(DECODE(answer, 3, 1)) a3, COUNT(DECODE(answer, 5, 1)) a5 "+
				" FROM ACCIDENT_CALL a WHERE poll_s_id IS NOT NULL "+
				" GROUP BY poll_s_id, poll_id "+
				"  ";
	query += "  ORDER BY poll_s_id, poll_id ";


//			System.out.println("[PollDatabase:getSurveyContPollTot]"+query);

	
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
			System.out.println("[PollDatabase:getSurveyAccidentPollTot]"+e);
			System.out.println("[PollDatabase:getSurveyAccidentPollTot]"+query);
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




	//콜센터 -계약콜 수정.
	public boolean updateCont_Call(ContCallBean bean, String answer_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		
		String query = " update cont_call set ANSWER = ? , ANSWER_REM = ? , UPDATE_DATE = sysdate , REG_ID = ? where rent_mng_id = ? and rent_l_cd = ? and poll_id = ? ";	
						
		String query1 = " update cont_call set ANSWER = ? , ANSWER_REM = ? , UPDATE_DATE = sysdate , REG_ID = ? where rent_mng_id = ? and rent_l_cd = ? and poll_id = ? ";	

		try 
		{
			conn.setAutoCommit(false);

			//System.out.println (bean.getAnswer_rem().trim());
			
			if (!answer_dt.equals("")){
				pstmt = conn.prepareStatement(query1);
				pstmt.setString(1,  bean.getAnswer().trim()	);
				pstmt.setString(2,  bean.getAnswer_rem().trim()	);
				pstmt.setString(3,  bean.getReg_id().trim()	);
				pstmt.setString(4,  bean.getRent_mng_id().trim()	);
				pstmt.setString(5,  bean.getRent_l_cd().trim()	);
				pstmt.setInt(6,  	bean.getPoll_id() );

			//	pstmt.setString(6,  answer_dt );
			
			} else {				 	
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,  bean.getAnswer().trim()	);
				pstmt.setString(2,  bean.getAnswer_rem().trim()	);
				pstmt.setString(3,  bean.getReg_id().trim()	);
				pstmt.setString(4,  bean.getRent_mng_id().trim()	);
				pstmt.setString(5,  bean.getRent_l_cd().trim()	);
				pstmt.setInt(6,  	bean.getPoll_id() );
			}			
							
		    pstmt.executeUpdate();
			pstmt.close();


		    conn.commit();
		} catch (SQLException e) {
		  	System.out.println("[PollDatabase:updateCont_Call]\n"+e);
		   	System.out.println("[PollDatabase:updateCont_Call]\n"+ bean.getRent_mng_id());
		   	System.out.println("[PollDatabase:updateCont_Call]\n"+bean.getRent_l_cd());
		   	System.out.println("[PollDatabase:updateCont_Call]\n"+bean.getPoll_id());
			e.printStackTrace();
			flag = false;
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[PollDatabase:updateCont_Call]\n"+e);
		   	System.out.println("[PollDatabase:updateCont_Call]\n"+ bean.getRent_mng_id());
		   	System.out.println("[PollDatabase:updateCont_Call]\n"+bean.getRent_l_cd());
		   	System.out.println("[PollDatabase:updateCont_Call]\n"+bean.getPoll_id());
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
	 *	계약 Poll 리스트
	 */
	public Vector getSurveyContPollTot_list(String ref_dt1, String ref_dt2, String gubun3, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT a.poll_id, a.poll_seq, c.POLL_ST, c.POLL_TYPE, a.a_seq, NVL(a.content, '합계') content, DECODE(GROUPING(a.a_seq), 0, LISTAGG(b.rent_l_cd) WITHIN GROUP(ORDER BY b.rent_l_cd) ) graph, COUNT(b.rent_l_cd) cnt "+
				" FROM survey_poll a, cont_call b, SURVEY c "+
				" WHERE  c.POLL_ID = a.POLL_ID and a.poll_id = b.poll_s_id(+) AND a.poll_seq = b.poll_id(+) AND a.a_seq = b.answer(+) AND a.poll_id  = '"+gubun3+"' and c.poll_type = '"+gubun1+"' and c.poll_st = '"+gubun2+"'   "+
				" GROUP BY a.poll_id, a.poll_seq, c.POLL_ST, c.POLL_TYPE, ROLLUP((a.a_seq, a.content)) "+
				" ORDER BY a.poll_id, a.poll_seq, a.a_seq "+
				"  ";

//			System.out.println("[PollDatabase:getSurveyContPollTot_list]"+query);

	
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
			System.out.println("[PollDatabase:getSurveyContPollTot_list]"+e);
			System.out.println("[PollDatabase:getSurveyContPollTot_list]"+query);
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
	 *	계약 Poll 리스트
	 */
	public Vector getSurveyCallPollTot_list(String ref_dt1, String ref_dt2, String gubun3, String gubun1, String gubun2, String table_nm, String gubun4)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		if(!ref_dt1.equals("")&&!ref_dt2.equals("")){	//기간검색
			if(gubun4.equals("1")){	//계약일자
				sub_query += " AND (a.a_seq = '0' OR (d.rent_dt BETWEEN replace('"+ref_dt1+"', '-','') AND replace('"+ref_dt2+"', '-','')))	";
			}else if(gubun4.equals("2")){	//출고일자
				sub_query += " AND (a.a_seq = '0' OR (d.dlv_dt BETWEEN replace('"+ref_dt1+"', '-','') AND replace('"+ref_dt2+"', '-',''))) ";
			}else if(gubun4.equals("3")){	//콜 등록일자
				sub_query += " AND (a.a_seq = '0' OR (TO_CHAR(b.answer_date, 'YYYYMMDD') BETWEEN replace('"+ref_dt1+"', '-','') AND replace('"+ref_dt2+"', '-',''))) ";
			}
		}

    //  query = " SELECT a.poll_id, a.poll_seq, c.POLL_ST, c.POLL_TYPE, a.a_seq, NVL(a.content, '합계') content, DECODE(GROUPING(a.a_seq), 0, LISTAGG(b.rent_l_cd) WITHIN GROUP(ORDER BY b.rent_l_cd) ) graph, COUNT(b.rent_l_cd) cnt "+
        query = " SELECT a.poll_id, a.poll_seq, c.POLL_ST, c.POLL_TYPE, a.a_seq, NVL(a.content, '합계') content, DECODE(GROUPING(a.a_seq), 0, COUNT(b.rent_l_cd) ) graph, COUNT(b.rent_l_cd) cnt "+
				" FROM survey_poll a, "+table_nm+" b, SURVEY c, cont d "+
				" WHERE  c.POLL_ID = a.POLL_ID and a.poll_id = b.poll_s_id(+) AND a.poll_seq = b.poll_id(+) AND TO_CHAR(a.a_seq) = b.answer(+) AND a.poll_id  = '"+gubun3+"' and c.poll_type = '"+gubun1+"' and c.poll_st = '"+gubun2+"'   "+
				" AND b.rent_l_cd  = d.rent_l_cd(+) AND b.rent_mng_id = d.rent_mng_id(+)"+	//추가
				sub_query+
		//		" WHERE  c.POLL_ID = a.POLL_ID and a.poll_id = b.poll_s_id(+) AND a.poll_seq = b.poll_id(+) AND a.a_seq = b.answer(+) AND a.poll_id  = '"+gubun3+"' and c.poll_type = '"+gubun1+"' and c.poll_st = '"+gubun2+"'   "+
				" GROUP BY a.poll_id, a.poll_seq, c.POLL_ST, c.POLL_TYPE, ROLLUP((a.a_seq, a.content)) "+
				" ORDER BY a.poll_id, a.poll_seq, a.a_seq "+
				"  ";

	//System.out.println("[PollDatabase:getSurveyCallPollTot_list]"+query);

	
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
			System.out.println("[PollDatabase:getSurveyCallPollTot_list]"+e);
			System.out.println("[PollDatabase:getSurveyCallPollTot_list]"+query);
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
	 *	계약 Poll 리스트 2차 // checkbox 추가로인한 colum row분리 
	 */
	public Vector getSurveyCallPollTot_list2(String ref_dt1, String ref_dt2, String gubun3, String gubun1, String gubun2, String table_nm, String gubun4)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String temp_query = "";
		if(!ref_dt1.equals("")&&!ref_dt2.equals("")){	//기간검색
			if(gubun4.equals("1")){	//계약일자
				sub_query += " AND (a.a_seq = '0' OR (d.rent_dt BETWEEN replace('"+ref_dt1+"', '-','') AND replace('"+ref_dt2+"', '-','')))	";
			}else if(gubun4.equals("2")){	//출고일자
				sub_query += " AND (a.a_seq = '0' OR (d.dlv_dt BETWEEN replace('"+ref_dt1+"', '-','') AND replace('"+ref_dt2+"', '-',''))) ";
			}else if(gubun4.equals("3")){	//콜 등록일자
				sub_query += " AND (a.a_seq = '0' OR (TO_CHAR(b.answer_date, 'YYYYMMDD') BETWEEN replace('"+ref_dt1+"', '-','') AND replace('"+ref_dt2+"', '-',''))) ";
			}
		}
		
		
		temp_query = " (select rent_mng_id, rent_l_cd, poll_id, regexp_substr(answer,'[^/]+', 1, b.seq) as answer, answer_rem, answer_date, reg_id, poll_s_id " +
							"	 from (select rent_mng_id, rent_l_cd, poll_id, answer, nvl(LENGTH(regexp_REPLACE(answer,'[^/]+')), 0) + 1 cnt,  " +
						  	"			answer_rem, answer_date, reg_id, poll_s_id " +
						    "    from "+table_nm+" ) a, " +
						    "    (select rownum seq " +
						    "      from dual " +
						    "    CONNECT BY ROWNUM <= 100 " +
						    "    ) b ) ";


        query = " SELECT a.poll_id, a.poll_seq, c.POLL_ST, c.POLL_TYPE, a.a_seq, NVL(a.content, '합계') content, DECODE(GROUPING(a.a_seq), 0, COUNT(b.rent_l_cd) ) graph, COUNT(b.rent_l_cd) cnt "+
				" FROM survey_poll a, "+temp_query+" b, SURVEY c, cont d "+
				" WHERE  c.POLL_ID = a.POLL_ID and a.poll_id = b.poll_s_id(+) AND a.poll_seq = b.poll_id(+) AND TO_CHAR(a.a_seq) = b.answer(+) AND a.poll_id  = '"+gubun3+"' and c.poll_type = '"+gubun1+"' and c.poll_st = '"+gubun2+"'   "+
				" AND b.rent_l_cd  = d.rent_l_cd(+) AND b.rent_mng_id = d.rent_mng_id(+)"+
				sub_query+
				" GROUP BY a.poll_id, a.poll_seq, c.POLL_ST, c.POLL_TYPE, ROLLUP((a.a_seq, a.content)) "+
				" ORDER BY a.poll_id, a.poll_seq, a.a_seq "+
				"  ";

	//System.out.println("[PollDatabase:getSurveyCallPollTot_list2]"+query);

	
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
			System.out.println("[PollDatabase:getSurveyCallPollTot_list2]"+e);
			System.out.println("[PollDatabase:getSurveyCallPollTot_list2]"+query);
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


//설문문항만 가져오기
	public Hashtable getSurvey_Poll_Question(String poll_id, String poll_seq)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " SELECT poll_seq, content FROM SURVEY_POLL WHERE poll_seq = '"+ poll_seq + "' AND poll_id = '"+ poll_id + "' AND a_seq = '0' "+
				" "; 

		//   System.out.println("getSurvey_Poll_Question =" + query);

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
			System.out.println("[PollDatabase:getSurvey_Poll_Question]\n"+e);			
			System.out.println("[PollDatabase:getSurvey_Poll_Question]\n"+query);			
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
	 *	세부 Poll 리스트
	 */
	public Vector getSurveyContPollView_listOne(String poll_id, String poll_seq, String a_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT * FROM survey_poll WHERE poll_id = '"+poll_id+"' AND poll_seq = '"+poll_seq+"' AND a_seq IN ('0','"+a_seq+"') "+
				"  ";

//			System.out.println("[PollDatabase:getSurveyContPollView_listOne]"+query);

	
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
			System.out.println("[PollDatabase:getSurveyContPollView_listOne]"+e);
			System.out.println("[PollDatabase:getSurveyContPollView_listOne]"+query);
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
	 *	세부 Poll 리스트2
	 */
	public Vector getSurveyContPollView_listTwo(String poll_id, String poll_seq, String a_seq, String table_nm, String gubun4, String ref_dt1, String ref_dt2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query 	 = "";
		String subquery  = "";
		String subquery2 = "";
		String subquery3 = "";
		String temp_query = "";

		if(table_nm.equals("CONT_CALL")){
			subquery = " '' as car_mng_id, '' as accid_id, '' as serv_id, ";
		}else if(table_nm.equals("ACCIDENT_CALL")){
			subquery = " b.CAR_MNG_ID, b.ACCID_ID, '' as serv_id, ";
		}else if(table_nm.equals("SERVICE_CALL")){
			subquery = " b.CAR_MNG_ID, b.SERV_ID, '' as accid_id, ";
		}

		if(!gubun4.equals("")&&!ref_dt1.equals("")&&!ref_dt2.equals("")){
			if(gubun4.equals("1")){	//계약일자
				subquery2 += " AND (c.rent_dt BETWEEN replace('"+ref_dt1+"', '-','') AND replace('"+ref_dt2+"', '-',''))	";
			}else if(gubun4.equals("2")){	//출고일자
				subquery2 += " AND (c.dlv_dt BETWEEN replace('"+ref_dt1+"', '-','') AND replace('"+ref_dt2+"', '-','')) ";
			}else if(gubun4.equals("3")){	//콜 등록일자
				subquery2 += " AND (TO_CHAR(b.answer_date, 'YYYYMMDD') BETWEEN replace('"+ref_dt1+"', '-','') AND replace('"+ref_dt2+"', '-','')) ";
			}
		}
		
		if(table_nm.equals("ACCIDENT_CALL")){
			subquery3 = " ,b.CAR_MNG_ID, b.ACCID_ID ";
		}else if(table_nm.equals("SERVICE_CALL")){
			subquery3 = " ,b.CAR_MNG_ID, b.SERV_ID ";
		}
		
		// checkbox추가로 인한 구분자 colum data row분리
		if (table_nm.equals("CONT_CALL")) {
			temp_query = " (select rent_mng_id, rent_l_cd, poll_id, regexp_substr(answer,'[^/]+', 1, b.seq) as answer, answer_rem, answer_date, reg_id, poll_s_id " +
					"	 from (select rent_mng_id, rent_l_cd, poll_id, answer, nvl(LENGTH(regexp_REPLACE(answer,'[^/]+')), 0) + 1 cnt,  " +
				  	"			answer_rem, answer_date, reg_id, poll_s_id " +
				    "    from "+table_nm+" ) a, " +
				    "    (select rownum seq " +
				    "      from dual " +
				    "    CONNECT BY ROWNUM <= 100 " +
				    "    ) b ) ";
		} else {
			temp_query = table_nm;
		}

        query = " SELECT a.POLL_TYPE, a.POLL_ST, a.POLL_SU, c.RENT_MNG_ID, c.RENT_L_CD, "+subquery+" d.FIRM_NM, e.car_no, E.CAR_NM, b.ANSWER_REM, TO_CHAR(b.ANSWER_DATE, 'YYYY-MM-DD') AS ANSWER_DATE, "+
        		" c.RENT_DT, "+	//계약일자추가(20181107)
        		" DECODE(c.bus_st,'1','인터넷','2','영업사원','3','업체소개','4','catalog','5','전화상담','6','기존업체','7','에이젼트','8','모바일','') as bus_st"+
				" FROM SURVEY a, "+temp_query+" b, CONT c, CLIENT d, CAR_REG e, SURVEY_POLL f"+
				" WHERE a.poll_id = b.poll_s_id AND b.RENT_L_CD = c.rent_l_cd AND b.rent_mng_id = c.rent_mng_id AND c.client_id = d.client_id  AND c.CAR_MNG_ID = e.CAR_MNG_ID "+
        		"	AND a.POLL_ID = f.POLL_ID"+
				"   AND b.POLL_S_ID = '"+poll_id+"' AND b.POLL_ID = '"+poll_seq+"' AND b.ANSWER = '"+a_seq+"' "+
				subquery2+	//기간검색반영(20181107)
				" group BY a.POLL_TYPE, a.POLL_ST, a.POLL_SU, c.RENT_MNG_ID, c.RENT_L_CD, d.FIRM_NM, e.car_no, E.CAR_NM, b.ANSWER_REM, b.ANSWER_DATE, c.RENT_DT, c.BUS_ST"+
				subquery3 + 
				"  ORDER BY b.ANSWER_DATE desc ";

			//System.out.println("[PollDatabase:getSurveyContPollView_listTwo]"+query); 

	
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
			System.out.println("[PollDatabase:getSurveyContPollView_listTwo]"+e);
			System.out.println("[PollDatabase:getSurveyContPollView_listTwo]"+query);
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



//설문응답자수 가져오기
	public Hashtable getSurvey_Poll_tot(String poll_id, String poll_seq, String table_nm)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " SELECT COUNT(rent_l_cd) AS tot FROM "+table_nm+" WHERE poll_s_id = '"+ poll_id + "' AND poll_id = '"+ poll_seq + "' GROUP BY poll_s_id  "+
				" "; 

		//   System.out.println("getSurvey_Poll_tot =" + query);

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		  
	    	ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"0":rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[PollDatabase:getSurvey_Poll_tot]\n"+e);			
			System.out.println("[PollDatabase:getSurvey_Poll_tot]\n"+query);			
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



//과거문항관리
	public Vector getOld_livePoll_question(String poll_type, String poll_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subquery = "";


		if(poll_type.equals("계약")&&poll_st.equals("신규")){
			subquery += " and poll_type = '1' and poll_st = '1' ";
		}else if(poll_type.equals("계약")&&poll_st.equals("증차")){
		subquery += " and poll_type = '1' and poll_st = '4' ";
		}else if(poll_type.equals("계약")&&poll_st.equals("대차")){
			subquery += " and poll_type = '1' and poll_st = '3' ";
		}else if(poll_type.equals("계약")&&poll_st.equals("연장")){
			subquery += " and poll_type = '1' and poll_st = '5' ";
		}else if(poll_type.equals("계약")&&poll_st.equals("재리스")){
			subquery += " and poll_type = '1' and poll_st in ( '6','8') ";
		}else if(poll_type.equals("계약")&&poll_st.equals("월렌트")){
			subquery += " and poll_type = '1' and poll_st in ( '9','10') ";
		}else if(poll_type.equals("순회정비")&&poll_st.equals("순회정비")){
			subquery += " and poll_type = '2' and poll_st = '2' ";
		}else if(poll_type.equals("사고처리")&&poll_st.equals("사고처리")){
			subquery += " and poll_type = '3' and poll_st = '7' ";
		}



        query = " SELECT QUESTION, POLL_TYPE, POLL_ST, POLL_SEQ FROM LIVE_POLL WHERE use_yn = 'Y' "+subquery+" "+
				" ORDER BY poll_seq ";

//			System.out.println("[PollDatabase:getOld_livePoll_question]"+query);

	
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
			System.out.println("[PollDatabase:getOld_livePoll_question]"+e);
			System.out.println("[PollDatabase:getOld_livePoll_question]"+query);
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



//과거문항보기관리
	public Vector getOld_livePoll_answers(String poll_type, String poll_st, String poll_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subquery = "";



        query = " SELECT poll_type, poll_st, poll_seq, ex, answer  "+ 
				" FROM LIVE_POLL unpivot(answer FOR ex IN (answer1 AS 1, answer2 AS 2, answer3 AS 3, answer4 AS 4, answer5 AS 5, answer6 AS 6, answer7 AS 7, answer8 AS 8, answer9 AS 9, answer10 AS 10)) "+
				" WHERE use_yn = 'Y' AND poll_type = '"+poll_type+"' AND poll_st = '"+poll_st+"'  AND poll_seq = '"+poll_seq+"' "+
				"  ORDER BY  ex ";

//			System.out.println("[PollDatabase:getOld_livePoll_answers]"+query);

	
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
			System.out.println("[PollDatabase:getOld_livePoll_answers]"+e);
			System.out.println("[PollDatabase:getOld_livePoll_answers]"+query);
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


//과거문항 응답자수
	public Hashtable getOld_poll_count(String poll_seq, String ex, String dt1, String dt2)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
		
		query = " SELECT poll_id, COUNT(rent_l_cd) cnt  FROM CONT_CALL WHERE poll_id ='"+poll_seq+"' AND answer = '"+ex+"' and poll_s_id is null "+ 
				" AND TO_CHAR(ANSWER_DATE, 'YYYYMMDD') BETWEEN replace('"+dt1+"', '-','') AND replace('"+dt2+"', '-','') "+
				" GROUP BY poll_id ";


		//   System.out.println("getOld_poll_count =" + query);

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
			System.out.println("[PollDatabase:getOld_poll_count]\n"+e);			
			System.out.println("[PollDatabase:getOld_poll_count]\n"+query);			
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
	 *	과거 세부 Poll 리스트
	 */
	public Vector getOld_SurveyContPollView_listOne(String poll_type, String poll_st, String poll_seq, String a_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " SELECT a.poll_type, a.poll_st, a.poll_seq, a.ex, a.answer "+
				" FROM (SELECT poll_type, poll_st, poll_seq, ex, answer "+
				" FROM LIVE_POLL unpivot(answer FOR ex IN (question AS 0, answer1 AS 1, answer2 AS 2, answer3 AS 3, answer4 AS 4, answer5 AS 5, answer6 AS 6, answer7 AS 7, answer8 AS 8, answer9 AS 9, answer10 AS 10))  "+
				" WHERE use_yn = 'Y' AND poll_type = '"+poll_type+"' AND poll_st = '"+poll_st+"'  AND poll_seq = '"+poll_seq+"' ORDER BY  ex) a, CONT_CALL b "+
				" WHERE a.poll_seq = b.poll_id AND a.ex IN ('0','"+a_seq+"') GROUP BY a.poll_type, a.poll_st, a.poll_seq, a.ex , a.answer ORDER BY a.ex";

//	System.out.println("[PollDatabase:getOld_SurveyContPollView_listOne]"+query);

	
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
			System.out.println("[PollDatabase:getOld_SurveyContPollView_listOne]"+e);
			System.out.println("[PollDatabase:getOld_SurveyContPollView_listOne]"+query);
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
	 *	과거세부 Poll 리스트2
	 */
	public Vector getOld_SurveyContPollView_listTwo(String poll_type, String poll_st, String poll_seq, String a_seq, String table_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subquery = "";

		if(table_nm.equals("CONT_CALL")){
			subquery = " '' as car_mng_id, '' as accid_id, '' as serv_id, ";
		}else if(table_nm.equals("ACCIDENT_CALL")){
			subquery = " b.CAR_MNG_ID, b.ACCID_ID, '' as serv_id, ";
		}else if(table_nm.equals("SERVICE_CALL")){
			subquery = " b.CAR_MNG_ID, b.SERV_ID, '' as accid_id, ";
		}



		query = " SELECT a.POLL_TYPE, a.POLL_ST, c.RENT_MNG_ID, c.RENT_L_CD, "+subquery+" d.FIRM_NM, e.car_no, E.CAR_NM, b.ANSWER_REM, TO_CHAR(b.ANSWER_DATE, 'YYYY-MM-DD') AS ANSWER_DATE  "+
				" FROM LIVE_POLL a, "+table_nm+" b, CONT c, CLIENT d, CAR_REG e  "+
				" WHERE a.POLL_SEQ = b.POLL_ID AND b.RENT_L_CD = c.rent_l_cd AND b.rent_mng_id = c.rent_mng_id AND c.client_id = d.client_id AND c.CAR_MNG_ID = e.CAR_MNG_ID AND b.POLL_S_ID IS null AND a.USE_YN = 'Y'  "+
				" AND a.POLL_type = '"+poll_type+"' AND a.poll_st = '"+poll_st+"' AND b.POLL_ID = '"+poll_seq+"' AND b.ANSWER = '"+a_seq+"' "+
				" ORDER BY b.ANSWER_DATE desc ";


//			System.out.println("[PollDatabase:getSurveyContPollView_listTwo]"+query);

	
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
			System.out.println("[PollDatabase:getSurveyContPollView_listTwo]"+e);
			System.out.println("[PollDatabase:getSurveyContPollView_listTwo]"+query);
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



//월렌트 콜 대상현황.
	public Vector getClsDocList(String dt, String ref_dt1, String ref_dt2, String s_kd, String t_wd, String gubun1, String andor, String chk, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = "";      
		String user_query = "";        
		String s_dt1 = "to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";  
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
		String s_dt4 = "to_char(sysdate,'YYYY')";



		//해지일
		if(gubun1.equals("1")){     
															
			if(dt.equals("1"))								dt_query = " and ( b.cls_dt like "+s_dt1+"||'%' or to_char(cpr.answer_date, 'yyyymmdd') like "+s_dt1+"||'%' ) \n";
			else if(dt.equals("2"))							dt_query = " and b.cls_dt like "+s_dt2+"||'%'\n";
			else if(dt.equals("3"))							dt_query = " and b.cls_dt like "+s_dt4+"||'%'\n";
			else if(dt.equals("4") && !ref_dt1.equals(""))	dt_query = " and b.cls_dt "+s_dt3+"\n";
			
		//계약번호
		}else if (gubun1.equals("2")){ 				
			dt_query = " and a.rent_l_cd like '%"+t_wd+"%' and nvl(b.cls_dt,a.rent_dt)>= '20070901' \n";
		} else {
			dt_query = " and c.firm_nm like '%"+t_wd+"%' and nvl(b.cls_dt,a.rent_dt)>= '20070901' \n";
		}
        
              //call center :000071, 000194
                if  ( user_id.equals("000071") || user_id.equals("000194") ) {
                	   user_query  = " and  cpr.reg_id = '" + user_id + "'";
                }	 



		query = " select /*+  merge(a) */ b.term_yn,  decode(a.call_st , 'N', '9', cp.gubun ) AS gubun, \n"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, b.cls_dt,\n"+
				" a.rent_dt, c.firm_nm, c.car_no, c.car_nm, a.rent_start_dt, \n"+
				" decode(i.dept_id,'0007','부산','0008','대전','') dept_nm, i.user_nm as bus_nm, \n"+
				" decode(a.use_yn,'Y','진행','N','해지','미결') use_st, b.cls_st, \n"+
				" decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' ,  '') cls_st_nm, \n"+
				" nvl(b.autodoc_yn, 'N') autodoc_yn , \n"+
				" decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit,"+
				" l.doc_no, l.doc_step, l.user_id1, l.user_id2, l.user_id3, l.user_id4, l.user_id5, l.user_dt1, l.user_dt2, l.user_dt3, l.user_dt4, l.user_dt5  \n"+
				" from cont a, cls_etc b,  client c, users i, users df,  car_reg c, \n"+
				" (select * from doc_settle where doc_st='11') l, \n"+
				" (SELECT a.rent_mng_id, a.rent_l_cd, '1' AS gubun FROM cont_call a WHERE poll_id <> 0 GROUP BY a.rent_mng_id, a.rent_l_cd) cp, \n"+
				" (SELECT a.rent_mng_id, a.rent_l_cd, reg_id, answer_date FROM cont_call a WHERE poll_id = 0 ) cpr \n"+
				" where a.car_st<>'2'  AND b.cls_dt >= '20170101' AND a.client_id=c.client_id \n"+
				" and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd \n"+
				" and  a.car_mng_id = c.car_mng_id(+) "+ 
				" and a.rent_l_cd=l.doc_id(+) \n"+
				" and l.user_id1=i.user_id(+) \n"+
				" and b.dft_saction_id=df.user_id(+) \n"+
				dt_query +user_query+
				" AND a.rent_mng_id=cp.rent_mng_id(+) AND a.rent_l_cd=cp.rent_l_cd(+) AND a.rent_mng_id=cpr.rent_mng_id(+) AND a.rent_l_cd=cpr.rent_l_cd(+) \n"+
				"";


		if (chk.equals("3"))     query += " and b.cls_st in ( '14' ) ";
		
		query += " order by  decode(a.call_st , 'N', '9', cp.gubun ) desc, l.doc_bit, b.cls_dt desc , a.rent_dt, a.rent_start_dt, a.rent_mng_id";

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
			System.out.println("[PollDatabase:getClsDocList]\n"+e);
			System.out.println("[PollDatabase:getClsDocList]\n"+query);
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


//월렌트 콜 완료 현황.
	public Vector getClsDocCallList(String dt, String ref_dt1, String ref_dt2, String s_kd, String t_wd, String gubun1, String andor, String chk, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String dt_query = "";      
		String user_query = "";        
		String s_dt1 = "to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";  
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
		String s_dt4 = "to_char(sysdate,'YYYY')";

		//해지일
		if(gubun1.equals("1")){     
															
			if(dt.equals("1"))								dt_query = " and ( b.cls_dt like "+s_dt1+"||'%' or to_char(cpr.answer_date, 'yyyymmdd') like "+s_dt1+"||'%' ) \n";
			else if(dt.equals("2"))							dt_query = " and b.cls_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("3"))							dt_query = " and b.cls_dt like "+s_dt4+"||'%' \n";
			else if(dt.equals("4") && !ref_dt1.equals(""))	dt_query = " and b.cls_dt "+s_dt3+"\n";
			
		//계약번호
		}else if (gubun1.equals("2")){ 				
			dt_query = " and nvl(c.firm_nm, ' ') like '%"+t_wd+"%' \n";

		}else if (gubun1.equals("3")){ 				
			if(dt.equals("1"))								dt_query = " and replace(cc.answer_date, '-', '') like "+s_dt1+"||'%' \n";
			else if(dt.equals("2"))							dt_query = " and replace(cc.answer_date, '-', '') like "+s_dt2+"||'%' \n";
			else if(dt.equals("3"))							dt_query = " and replace(cc.answer_date, '-', '') like "+s_dt4+"||'%' \n";
			else if(dt.equals("4") && !ref_dt1.equals(""))	dt_query = " and replace(cc.answer_date, '-', '') =  "+s_dt3+"\n";
		}
        
              //call center :000071, 000194
                if  ( user_id.equals("000071") || user_id.equals("000194") ) {
                	   user_query  = " and  cpr.reg_id = '" + user_id + "'";
                }	 



		query = " select /*+  merge(a) */ cq.rr_answer, j.user_nm AS CALL_nm, cc.answer_date, b.term_yn,  decode(a.call_st , 'N', '9', cp.gubun ) AS gubun, \n"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, b.cls_dt,\n"+
				" a.rent_dt, c.firm_nm, c.car_no, c.car_nm, a.rent_start_dt, \n"+
				" decode(i.dept_id,'0007','부산','0008','대전','') dept_nm, i.user_nm as bus_nm, \n"+
				" decode(a.use_yn,'Y','진행','N','해지','미결') use_st, b.cls_st, \n"+
				" decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' ,  '') cls_st_nm, \n"+
				" nvl(b.autodoc_yn, 'N') autodoc_yn , \n"+
				" decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit,"+
				" l.doc_no, l.doc_step, l.user_id1, l.user_id2, l.user_id3, l.user_id4, l.user_id5, l.user_dt1, l.user_dt2, l.user_dt3, l.user_dt4, l.user_dt5  \n"+
				" from cont a, cls_etc b,  client c, users i, users j, users df,  car_reg c, \n"+
				" (select * from doc_settle where doc_st='11') l, \n"+
				" (SELECT a.rent_mng_id, a.rent_l_cd, '1' AS gubun FROM cont_call a WHERE poll_id <> 0 GROUP BY a.rent_mng_id, a.rent_l_cd) cp, \n"+
				" (SELECT a.rent_mng_id, a.rent_l_cd, reg_id, answer_date FROM cont_call a WHERE poll_id = 0 ) cpr, \n"+
				" (SELECT rent_mng_id, rent_l_cd, reg_id, to_char(answer_date, 'YYYY-MM-DD') AS answer_date FROM cont_call WHERE poll_id <> 0 GROUP BY rent_mng_id, rent_l_cd, reg_id, to_char(answer_date, 'YYYY-MM-DD') ) cc, \n"+
				" (SELECT rent_mng_id, rent_l_cd, decode(answer, '1', 'Y', 'N' ) r_answer FROM cont_call WHERE poll_id IN ('67', '68', '69' ) GROUP BY rent_mng_id, rent_l_cd , decode(answer, '1', 'Y', 'N' ) ) ccc,  \n"+
				" (SELECT rent_mng_id, rent_l_cd, decode(answer, 'N', 'N', 'Y' ) rr_answer FROM cont_call  GROUP BY rent_mng_id, rent_l_cd , decode(answer, 'N', 'N', 'Y' ) ) cq \n"+
				" where a.car_st<>'2' AND a.client_id=c.client_id \n"+
				" and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd \n"+
				" and  a.car_mng_id = c.car_mng_id(+) \n"+
				" AND a.rent_mng_id=cc.rent_mng_id AND a.rent_l_cd=cc.rent_l_cd AND a.rent_mng_id=ccc.rent_mng_id(+) AND a.rent_l_cd=ccc.rent_l_cd(+)     AND a.rent_mng_id=cq.rent_mng_id(+)    AND a.rent_l_cd=cq.rent_l_cd(+) \n"+
				" and a.rent_l_cd=l.doc_id(+) \n"+
				" and l.user_id1=i.user_id(+)  AND cc.reg_id = j.user_id(+) \n"+
				" and b.dft_saction_id=df.user_id(+) \n"+
				dt_query +user_query+
				" AND a.rent_mng_id=cp.rent_mng_id(+) AND a.rent_l_cd=cp.rent_l_cd(+) AND a.rent_mng_id=cpr.rent_mng_id(+) AND a.rent_l_cd=cpr.rent_l_cd(+) \n"+
				"";


		if (chk.equals("3"))     query += " and b.cls_st in ( '14' ) ";


		query += " order by  cpr.answer_date desc, decode(a.call_st , 'N', '9', cp.gubun ) desc, l.doc_bit, b.cls_dt desc , a.rent_dt, a.rent_start_dt, a.rent_mng_id";


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
			System.out.println("[PollDatabase:getClsDocCallList]\n"+e);
			System.out.println("[PollDatabase:getClsDocCallList]\n"+query);
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


// N콜등록비용현황
public Vector NewCallCnt(String reg_id, String year) 
	{
	       	getConnection();
	        
	         Statement stmt = null;
	         ResultSet rs = null;
	         Vector vt = new Vector();
	         String query = "";
				
		query = " 	select mm, sum(cnt0) cnt0, sum(cnt1) cnt1, sum(cnt2) cnt2  \n"+
			     "	    from (  \n"+
			     "	          select '01'  mm, 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '02' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     " 	          select '03' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '04' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+   
			     "	          select '05' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     " 	           union all \n"+
			     "	          select '06' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '07' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '08' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all   \n"+    
			     "	          select '09'mm  , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '10' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all \n"+
			     "	          select '11' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all  \n"+       
			     "	          select '12' mm , 0 cnt0, 0  cnt1, 0 cnt2 from dual \n"+
			     "	           union all  \n"+
			     "	        	 select mm, cnt0, cnt1, cnt2 from ( \n"+
				  " 		 SELECT substr(replace(to_char(b.answer_date,'YYYYMMDD'), '-', '') ,5,2) mm, c.POLL_TYPE , COUNT(b.rent_l_cd) cnt0 , 0 cnt1 , 0 cnt2  \n"+
				  " 		 	FROM survey_poll a, cont_call b, SURVEY c  \n"+
				  " 		 WHERE b.answer <> 'N' AND c.POLL_ID = a.POLL_ID AND a.poll_id = b.poll_s_id AND a.poll_seq = b.poll_id AND a.a_seq = b.answer  \n"+
				  " 		 AND a.poll_seq = '1' AND to_char(b.answer_date,'YYYY')= '"+ year + "' AND b.reg_id='"+ reg_id + "'  \n"+
				  " 			GROUP BY substr(replace(to_char(b.answer_date,'YYYYMMDD'), '-', '') ,5,2), c.POLL_TYPE \n"+
				  " 	UNION ALL         \n"+
				  " 		SELECT substr(replace(to_char(b.answer_date,'YYYYMMDD'), '-', '') ,5,2) mm, c.POLL_TYPE, 0 cnt0, COUNT(b.rent_l_cd) cnt1 , 0 cnt2  \n"+
				  " 		FROM survey_poll a, cont_call b, SURVEY c  \n"+
				  " 		WHERE b.answer = 'N' AND a.poll_id = b.poll_s_id AND a.poll_seq = b.poll_id AND a.POLL_ID = c.POLL_ID AND a.a_seq = DECODE(b.answer,'N',0)  \n"+
				  " 		AND b.poll_id = '1' AND to_char(b.answer_date,'YYYY')= '"+ year + "' AND b.reg_id='"+ reg_id + "' \n"+
				  " 		GROUP BY substr(replace(to_char(b.answer_date,'YYYYMMDD'), '-', '') ,5,2), c.POLL_TYPE \n"+
		         "   union all    \n"+
				  "	      	 select   substr(replace(cc.answer_date, '-', '') ,5,2) mm, '계약' as poll_type, \n"+ //과거 call 등록비용 
			     "		       	       count(decode(cc.answer, '9', 1)) cnt0, count(decode(cc.answer, '7', 1)) cnt1 ,  0 cnt2 \n"+
			     "	           	          from  cont a, fee b, \n"+
			     "				                (select rent_mng_id, rent_l_cd, to_char(answer_date, 'YYYY-MM-DD') AS answer_date , reg_id ,\n"+
			     "						  case when poll_id = '1' and answer = '7' then '7'  \n"+
			     "						        when poll_id = '4' and answer = '7'  then '7' \n"+
			     "						        when poll_id = '8' and answer = '7'  then '7' \n"+
			     "						        when poll_id = '72' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '76' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '77' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '78' and answer = '9'  then '7' \n"+
			     "						        when poll_id = '79' and answer = '9'  then '7' \n"+
			     "						        when poll_id = '80' and answer = '9'  then '7' \n"+
		     	     "						        when poll_id = '81' and answer = '10'  then '7' \n"+
			     "						        when poll_id = '82' and answer = '10'  then '7' \n"+
			     "						        when poll_id = '83' and answer = '10'  then '7' \n"+
			     "						        else '9' end   answer from cont_call where  nvl(poll_s_id, '0') = '0' and poll_id in  ('1', '4', '8' , '72', '76', '77' ,  '78', '79', '80', '81', '82', '83' ) group by  rent_mng_id, rent_l_cd, to_char(answer_date, 'YYYY-MM-DD'), reg_id ,  \n"+
			      "						  case when poll_id = '1' and answer = '7' then '7'  \n"+
			     "						        when poll_id = '4' and answer = '7'  then '7' \n"+
			     "						        when poll_id = '8' and answer = '7'  then '7' \n"+
			     "						        when poll_id = '72' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '76' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '77' and answer = '8'  then '7' \n"+
			     "						        when poll_id = '78' and answer = '9'  then '7' \n"+
			     "						        when poll_id = '79' and answer = '9'  then '7' \n"+
			     "						        when poll_id = '80' and answer = '9'  then '7' \n"+	
			      "						        when poll_id = '81' and answer = '10'  then '7' \n"+
			     "						        when poll_id = '82' and answer = '10'  then '7' \n"+
			     "						        when poll_id = '83' and answer = '10'  then '7' \n"+	
			     " 					           	else '9' end  ) cc  \n"+	
			     "					 where nvl(a.use_yn,'Y')='Y' and a.car_st<> '2' and a.car_gu <> '4' \n"+
		              "		 				 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
			     "					 and cc.answer_date like '"+year+"%'  \n"+			   
			     "					 and a.rent_mng_id=cc.rent_mng_id and a.rent_l_cd=cc.rent_l_cd	\n"+	
			     "					 and cc.reg_id='"+ reg_id + "'  \n"+
			     "	        group by substr(replace(cc.answer_date, '-', '') ,5,2)  )     \n"+
			     "	   union all    \n"+
				"	       select mm, cnt0, cnt1, cnt2 from ( \n"+
				"	     SELECT substr(replace(to_char(b.answer_date,'YYYYMMDD'), '-', '') ,5,2) mm , c.POLL_TYPE, 0 cnt0, 0 cnt1, COUNT(b.rent_l_cd) cnt2 \n"+
				"	     FROM survey_poll a, accident_call b, SURVEY c \n"+
				"      	WHERE c.POLL_ID = a.POLL_ID AND a.poll_id = b.poll_s_id AND a.poll_seq = b.poll_id AND a.a_seq = b.answer \n"+
				"	      AND a.poll_seq = '1' AND to_char(b.answer_date,'YYYY')= '"+ year + "'AND b.reg_id='"+ reg_id + "' \n"+
				"	      GROUP BY substr(replace(to_char(b.answer_date,'YYYYMMDD'), '-', '') ,5,2), c.POLL_TYPE \n"+
				 "	  union all    \n"+
			    "	     select   substr(to_char(cc.answer_date, 'YYYYMMDD'),5, 2) mm, '순회정비' as poll_type,  0 cnt0, 0 cnt1 , count(cc.poll_id) cnt2 \n"+
			    "	         from service_call cc where cc.poll_id = 47   and     to_char(answer_date, 'YYYY')= '"+year+"'  \n"+
			    "			 and cc.reg_id='"+ reg_id + "'  \n"+
			    "	       group by  substr(to_char(cc.answer_date, 'YYYYMMDD'),5, 2) )   	\n"+	 	  	 	  
	 		   "     union all    \n"+
				"	  select mm, cnt0, cnt1, cnt2 from ( \n"+
				"	 SELECT substr(replace(to_char(b.answer_date,'YYYYMMDD'), '-', '') ,5,2) mm, c.POLL_TYPE , 0 cnt0, 0 cnt1, COUNT(b.rent_l_cd) cnt2 \n"+
				"	 FROM survey_poll a, service_call b, SURVEY c \n"+
				" 	 WHERE c.POLL_ID = a.POLL_ID AND a.poll_id = b.poll_s_id AND a.poll_seq = b.poll_id AND a.a_seq = b.answer \n"+
				"	 AND a.poll_seq = '1' AND to_char(b.answer_date,'YYYY')= '"+ year + "' AND b.reg_id='"+ reg_id + "' \n"+
				" 	 GROUP BY substr(replace(to_char(b.answer_date,'YYYYMMDD'), '-', '') ,5,2) , c.POLL_TYPE \n"+
			    "   union all    \n"+
			    "	  select   substr(to_char(cc.answer_date, 'YYYYMMDD'),5, 2) mm, '사고처리' as poll_type, 0 cnt0, 0 cnt1 , count(cc.poll_id) cnt2 \n"+
			    "	            from accident_call cc where cc.poll_id = 61   and     to_char(answer_date, 'YYYY')= '"+year+"'  \n"+
			    "					 and cc.reg_id='"+ reg_id + "'  \n"+
			    "	            group by  substr(to_char(cc.answer_date, 'YYYYMMDD'),5, 2)  )  	\n"+  				 	        
		 	     "	    ) a \n"+
			     "	    group by mm \n"+
			     "	    order by mm  ";
    		
		
        try{
        		
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
			System.out.println("[PollDatabase:NewCallCnt]"+e);
			System.out.println("[PollDatabase:NewCallCnt]"+query);
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
     * 계약 현황 조회 - 콜등록
     */
    public Vector NgetRentCondAll(String dt,String ref_dt1,String ref_dt2, String gubun2, String sort, String s_kd, String t_wd, String user_id) 
    {
       	getConnection();
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";    
		String kd_query = "";      
		String user_query = "";    
		String s_dt1 = "to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";  
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt4 = "to_char(sysdate,'YYYY')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

	  // 콜등록일
		if(gubun2.equals("3")){     
			if(dt.equals("1"))				dt_query = " and replace(cc.answer_date, '-', '') like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))			dt_query = " and replace(cc.answer_date, '-', '') like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))			dt_query = " and replace(cc.answer_date, '-', '') like "+s_dt1+"||'%' \n";
			else if(dt.equals("3"))			dt_query = " and replace(cc.answer_date, '-', '') "+s_dt3+"\n";
			
		//계약일
		} else if(gubun2.equals("1")){     
			if(dt.equals("1"))				dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))			dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))			dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt1+"||'%' \n";
			else if(dt.equals("3"))			dt_query = " and nvl(b.rent_dt,a.rent_dt) "+s_dt3+"\n";
			
		//대여개시일
		}else{				
			if(dt.equals("1"))				dt_query = "and b.rent_start_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("2"))			dt_query = "and b.rent_start_dt like "+s_dt4+"||'%' \n";
			else if(dt.equals("4"))			dt_query = "and b.rent_start_dt like "+s_dt1+"||'%' \n";
			else if(dt.equals("3"))			dt_query = "and b.rent_start_dt "+s_dt3+"\n";
		}
        
    
        if(s_kd.equals("1"))	kd_query += " and a.rent_l_cd like '%"+ t_wd + "%'";
	else if(s_kd.equals("2"))	kd_query += " and c.firm_nm like '%"+ t_wd + "%'";
	else if(s_kd.equals("3"))	kd_query += " and j.emp_nm  like '%"+ t_wd + "%'";	
	else if(s_kd.equals("4"))	kd_query += " and n.user_nm  like '%"+ t_wd + "%'";	


    if  ( user_id.equals("000071") || user_id.equals("000194") ) {
                	   user_query  = " and  cc.reg_id = '" + user_id + "'";
      }	 

		
        query = " select\n"+
				" a.rent_mng_id, a.rent_l_cd, cc.answer_date, cc.reg_id, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, b.rent_start_dt, c.firm_nm, c.client_nm, g.car_nm, f.car_name,\n"+
				" a.dlv_dt, d.init_reg_dt, b.con_mon,\n"+
				" decode(b.rent_st,'1','','연장') ext_st, \n"+
				" decode(nvl(a.car_gu,a.reg_id),'1','신차','0','재리스') car_gu, \n"+
				" decode(a.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st,\n"+
				" decode(a.rent_st,'1','신규','2','연장','3','대차','4','증차','5','연장','6','재리스','7','재리스') rent_st,\n"+
				" decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
				" decode(a.bus_st,'1','인터넷','2','영업사원','3','기존업체소개','4','카달로그발송','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st,\n"+
				" j.emp_nm, jj.emp_nm as chul_nm, k.user_nm as bus_nm, l.user_nm as bus_nm2, m.user_nm as  mng_nm, n.user_nm call_nm , nvl(ccc.r_answer, 'N')  r_answer, cq.rr_answer  \n"+
				" from cont a, fee b, client c, car_reg d, car_etc e, car_nm f, car_mng g, \n"+
				"      (select rent_mng_id, rent_l_cd, reg_id,  to_char(answer_date, 'YYYY-MM-DD') AS answer_date from cont_call where poll_id <> 0  group by  rent_mng_id, rent_l_cd, reg_id, to_char(answer_date, 'YYYY-MM-DD') ) cc,\n"+
			   	"      (select rent_mng_id, rent_l_cd, decode(answer, '1', 'Y', 'N' ) r_answer from cont_call where (  poll_id in ('67', '68', '69' ) or poll_s_id||poll_id in ( '114', '210', '310' ) )   group by  rent_mng_id, rent_l_cd , decode(answer, '1', 'Y', 'N' ) ) ccc, 	   \n"+
			   	"      (select rent_mng_id, rent_l_cd, decode(answer, '000', 'Y', 'N' ) rr_answer from cont_call where poll_id  = 0  group by  rent_mng_id, rent_l_cd , decode(answer, '000', 'Y', 'N' ) ) cq, 	   \n"+					      	
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='1' and a.emp_id=b.emp_id ) j,\n"+
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='2' and a.emp_id=b.emp_id ) jj,\n"+
				"      users k, users l, users m, users n \n"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2','4','5') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				dt_query + kd_query + user_query+
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+			
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+)\n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+)\n"+
				" and a.rent_mng_id=cc.rent_mng_id and a.rent_l_cd=cc.rent_l_cd\n"+
				" and a.rent_mng_id=ccc.rent_mng_id(+) and a.rent_l_cd=ccc.rent_l_cd(+)\n"+
				" and a.rent_mng_id=cq.rent_mng_id(+) and a.rent_l_cd=cq.rent_l_cd(+)\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)\n"+
				" and a.mng_id=m.user_id(+)\n"+
				" and cc.reg_id=n.user_id(+)";
				
		query += " order by nvl(ccc.r_answer, 'N')   desc,  cc.answer_date desc, nvl(b.rent_dt,a.rent_dt) desc";
	
        try{
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
			System.out.println("[PollDatabase:getRentCondAll]"+e);
			System.out.println("[PollDatabase:getRentCondAll]"+query);
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


	//콜센터 -계약콜 수정.
	public boolean updateService_Call(ContCallBean bean, String answer_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		
		String query = " update cont_call set ANSWER = ? , ANSWER_REM = ? , UPDATE_DATE = sysdate , REG_ID = ? where rent_mng_id = ? and rent_l_cd = ? and poll_id = ? ";	
						
		String query1 = " update cont_call set ANSWER = ? , ANSWER_REM = ? , UPDATE_DATE = sysdate , REG_ID = ? where rent_mng_id = ? and rent_l_cd = ? and poll_id = ? ";	

		try 
		{
			conn.setAutoCommit(false);

			//System.out.println (bean.getAnswer_rem().trim());
			
			if (!answer_dt.equals("")){
				pstmt = conn.prepareStatement(query1);
				pstmt.setString(1,  bean.getAnswer().trim()	);
				pstmt.setString(2,  bean.getAnswer_rem().trim()	);
				pstmt.setString(3,  bean.getReg_id().trim()	);
				pstmt.setString(4,  bean.getRent_mng_id().trim()	);
				pstmt.setString(5,  bean.getRent_l_cd().trim()	);
				pstmt.setInt(6,  	bean.getPoll_id() );

			//	pstmt.setString(6,  answer_dt );
			
			} else {				 	
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1,  bean.getAnswer().trim()	);
				pstmt.setString(2,  bean.getAnswer_rem().trim()	);
				pstmt.setString(3,  bean.getReg_id().trim()	);
				pstmt.setString(4,  bean.getRent_mng_id().trim()	);
				pstmt.setString(5,  bean.getRent_l_cd().trim()	);
				pstmt.setInt(6,  	bean.getPoll_id() );
			}			
							
		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();
		} catch (SQLException e) {
		  	System.out.println("[PollDatabase:updateService_Call]\n"+e);
		   	System.out.println("[PollDatabase:updateService_Call]\n"+ bean.getRent_mng_id());
		   	System.out.println("[PollDatabase:updateService_Call]\n"+bean.getRent_l_cd());
		   	System.out.println("[PollDatabase:updateService_Call]\n"+bean.getPoll_id());
			e.printStackTrace();
			flag = false;
			conn.rollback();
	  	} catch (Exception e) {
		  	System.out.println("[PollDatabase:updateService_Call]\n"+e);
		   	System.out.println("[PollDatabase:updateService_Call]\n"+ bean.getRent_mng_id());
		   	System.out.println("[PollDatabase:updateService_Call]\n"+bean.getRent_l_cd());
		   	System.out.println("[PollDatabase:updateService_Call]\n"+bean.getPoll_id());
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




	//콜센터 -계약콜 수정.
	public boolean updatetAccidentCall(ContCallBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		// ANSWER_DATE = sysdate ,
		//String query = " update accident_call set ANSWER = ? , ANSWER_REM = ? , REG_ID = ? where rent_mng_id = ? and rent_l_cd = ? and car_mng_id = ? and accid_id = ? and poll_id = ? ";	
		
		String query = " update accident_call set ANSWER = '"+bean.getAnswer().trim()+"' ,  "+
						" ANSWER_REM =  '"+bean.getAnswer_rem().trim()+"' , "+
							" REG_ID =  '"+bean.getReg_id().trim()+"' "+
							" where "+
							" rent_mng_id =  '"+bean.getRent_mng_id().trim()+"' "+
							" and rent_l_cd =  '"+bean.getRent_l_cd().trim()+"' "+
							" and car_mng_id =  '"+bean.getCar_mng_id().trim()+"' "+
							" and accid_id =  '"+bean.getAccid_id().trim()+"' "+
							" and poll_id =  '"+bean.getPoll_id()+"' ";	



		try 
		{
			conn.setAutoCommit(false);

			//System.out.println("[PollDatabase:updatetAccidentCall]\n"+query);			
			/*
			System.out.println ("getAnswer="+bean.getAnswer().trim());
			System.out.println ("getAnswer_rem="+bean.getAnswer_rem().trim());
			System.out.println ("getReg_id="+bean.getReg_id().trim());
			System.out.println ("getRent_mng_id="+bean.getRent_mng_id().trim());
			System.out.println ("getRent_l_cd="+bean.getRent_l_cd().trim());
			System.out.println ("getCar_mng_id="+bean.getCar_mng_id().trim());
			System.out.println ("getAccid_id="+bean.getAccid_id().trim());
			System.out.println ("getPoll_id="+bean.getPoll_id()); 	
		 	*/
			pstmt = conn.prepareStatement(query);
			/*
			pstmt.setString(1,  bean.getAnswer().trim()	);
			pstmt.setString(2,  bean.getAnswer_rem().trim()	);
			pstmt.setString(3,  bean.getReg_id().trim()	);
			pstmt.setString(4,  bean.getRent_mng_id().trim()	);
			pstmt.setString(5,  bean.getRent_l_cd().trim()	);
			pstmt.setString(6,  bean.getCar_mng_id().trim()	);
			pstmt.setString(7, 	bean.getAccid_id().trim() );
			pstmt.setInt(8,  	bean.getPoll_id() );
			*/			
		    pstmt.executeUpdate();
			pstmt.close();

		    conn.commit();

		} catch (SQLException e) {
			System.out.println("[PollDatabase:updatetAccidentCall]\n"+e);
		  	System.out.println("[PollDatabase:updatetAccidentCall]\n"+query);
		   	System.out.println("[PollDatabase:updatetAccidentCall]\n"+ bean.getRent_mng_id());
		   	System.out.println("[PollDatabase:updatetAccidentCall]\n"+bean.getRent_l_cd());
		   	System.out.println("[PollDatabase:updatetAccidentCall]\n"+bean.getPoll_id());
		   	System.out.println("[PollDatabase:updatetAccidentCall]\n"+bean.getAccid_id());
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
			System.out.println("[PollDatabase:updatetAccidentCall]\n"+e);
		  	System.out.println("[PollDatabase:updatetAccidentCall]\n"+query);
		   	System.out.println("[PollDatabase:updatetAccidentCall]\n"+ bean.getRent_mng_id());
		   	System.out.println("[PollDatabase:updatetAccidentCall]\n"+bean.getRent_l_cd());
		   	System.out.println("[PollDatabase:updatetAccidentCall]\n"+bean.getPoll_id());
		   	System.out.println("[PollDatabase:updatetAccidentCall]\n"+bean.getAccid_id());
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




}
