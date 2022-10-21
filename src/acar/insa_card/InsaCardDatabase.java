/**
 * 인사카드
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 24
 * @ last modify date : 
 */

package acar.insa_card;

import java.io.*;
import java.sql.*;
import java.util.*;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import acar.database.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;


public class InsaCardDatabase
{
	private Connection conn = null;
	public static InsaCardDatabase db;
	
	public static InsaCardDatabase getInstance()
	{
		if(InsaCardDatabase.db == null)
			InsaCardDatabase.db = new InsaCardDatabase();
		return InsaCardDatabase.db;
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
	 *	조직관리 -> 인사기록카드 -> 전체조회 
	 */

	
	public Vector InsaCard(String user_id, String auth_rw, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = "SELECT a.USER_ID,\n"
        				+ " a.BR_ID,\n"
        				+ " b.BR_NM,\n"
        				+ " a.USER_NM,\n"
        				+ " a.ID,\n"
        				+ " a.USER_PSD,\n"
        				+ " a.USER_CD,\n"
        				+ "  text_decrypt(a.user_ssn, 'pw' ) USER_SSN,\n"
        				+ " a.DEPT_ID,\n"
        				+ " c.NM AS DEPT_NM,\n"
        				+ " a.USER_H_TEL,\n"
        				+ " a.USER_M_TEL,\n"
						+ " a.IN_TEL,\n"
						+ " a.HOT_TEL,\n"		
        				+ " a.USER_EMAIL,\n"
        				+ " a.USER_POS,\n"
        				+ " a.USER_AUT, a.LIC_NO, a.LIC_DT, a.ENTER_DT, a.content, a.filename, a.zip, a.addr, d.userid as mail_id, d.passwd as mail_pw,\n"
						+ " a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax, a.taste, a.special, a.gundea,   pp.jg_dt,  pp.pos , \n"
						+ " TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('19'||SUBSTR( text_decrypt(a.user_ssn, 'pw' ),1,6),'YYYYMMDD'))/12) age, "
						+ " TRUNC(MONTHS_BETWEEN(sysdate, TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) e_year ,    \n"
					 	+ " TRUNC(MONTHS_BETWEEN(sysdate, TO_DATE(a.enter_dt, 'YYYYMMDD')) -   "
						+ " TRUNC(MONTHS_BETWEEN(sysdate, TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) * 12) e_month \n"
			    		+ " FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d,   \n "
		        		+ "      ( select p.user_id, p.jg_dt, p.pos from insa_pos p, (select user_id, max(jg_dt) jg_dt from insa_pos group by user_id ) p1   where p.user_id = p1.user_id and p.jg_dt = p1.jg_dt  ) pp  \n"
		  				+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and a.user_id  = pp.user_id(+)  \n"
        				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','감사','팀장', '이사', '부장', '차장', '과장','대리','사원','인턴사원')    and nvl(a.use_yn,'Y')='Y' and a.dept_id not in ( '1000', '8888') \n"
		  				+ "and a.id not like 'develop%' and a.USER_ID NOT IN ('000177')"	//	조민규님,외부개발자 3명은 리스트에서 제외/ 임원(감사)은 추가(20181113)
		  				+ "	";
			
		if(s_kd.equals("1"))			query += " and a.user_nm like '%"+t_wd+"%'\n";		
		if(s_kd.equals("2"))			query += " and a.user_pos like '%"+t_wd+"%'\n";		
		if(s_kd.equals("3"))			query += " and a.taste like '%"+t_wd+"%'\n";		
		if(s_kd.equals("4"))			query += " and a.special like '%"+t_wd+"%'\n";		

//		query += "order by decode(a.user_pos,'대표이사', 1, '이사', 2, '부장', 3,'팀장', 4, 5), a.dept_id, decode(a.user_pos,'이사', 0, '차장', 1, '과장', 2, '대리', 3, 4), a.enter_dt, a.USER_SSN, a.USER_ID  ";

		if(sort_gubun.equals("1"))		query += " order by decode(a.user_pos,'대표이사',1,'이사',2,'감사',3,'부장',4,'팀장',5,6), a.dept_id, decode(a.user_pos,'이사', 0, '차장', 1, '과장', 2, '대리', 3, 4), a.enter_dt,  text_decrypt(a.user_ssn, 'pw' ), a.USER_ID , a.user_nm "+asc ;
		if(sort_gubun.equals("2"))		query += " order by decode(a.user_pos,'대표이사',1,'이사',2,'감사',3,'부장',4,'팀장',5,6), a.dept_id, decode(a.user_pos,'이사', 0, '차장', 1, '과장', 2, '대리', 3, 4), a.enter_dt,  text_decrypt(a.user_ssn, 'pw' ), a.USER_ID , a.user_pos "+asc ;
		if(sort_gubun.equals("3"))		query += " order by decode(a.user_pos,'대표이사',1,'이사',2,'감사',3,'부장',4,'팀장',5,6), a.dept_id, decode(a.user_pos,'이사', 0, '차장', 1, '과장', 2, '대리', 3, 4), a.enter_dt,  text_decrypt(a.user_ssn, 'pw' ), a.USER_ID , a.dept_id "+asc ;
		if(sort_gubun.equals("4"))		query += " order by a.enter_dt "+asc+" ,  text_decrypt(a.user_ssn, 'pw' ) "+asc ;
		if(sort_gubun.equals("5"))		query += " order by  text_decrypt(a.user_ssn, 'pw' ) "+asc+" ,a.enter_dt " ;

//		if(sort_gubun.equals("4"))		query += ", decode(a.br_id, 'S1','1', 'S2', 2, 'I1', 3, 'B1','4','D1','5', 6) "+asc ;



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
	//		System.out.println("[InsaCardDatabase:InsaCard]"+query);
		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:InsaCard]"+e);
			System.out.println("[InsaCardDatabase:InsaCard]"+query);
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
	 *	조직관리 -> 인사기록카드 -> 이름 클릭시 사용자 개별조회
	 */

	
	public Vector InsaCardUserList(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.USER_ID,a.BR_ID,b.BR_NM,a.USER_NM,a.ID,a.USER_PSD,a.USER_CD,  text_decrypt(a.user_ssn, 'pw' ) USER_SSN,a.DEPT_ID,c.NM AS DEPT_NM,"+
				" a.USER_H_TEL,a.USER_M_TEL,a.IN_TEL,a.HOT_TEL,a.USER_EMAIL,a.USER_POS,a.USER_AUT,a.LIC_NO,a.LIC_DT, nvl(a.ENTER_DT,'99999999') enter_dt,"+
				" a.content,a.filename,a.zip,a.addr, a.mail_id, d.passwd as mail_pw,  substr( text_decrypt(a.user_ssn, 'pw' ) , 1, 6) ssn1, substr( text_decrypt(a.user_ssn, 'pw' ), 7,1)||'******' ssn2 ,  substr( text_decrypt(a.user_ssn, 'pw' ), 7,7) ssn3,  "+
				" a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax ,a.taste, a.special, to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(a.enter_dt,'YYYYMMDD')+1 as w_day, a.gundea, decode(substr(text_decrypt(a.user_ssn, 'pw' ), 7,1), '1','남','2','여', '3','남','4','여') as jumin, a.bank_nm, a.bank_no, a.user_nm as bank_user, a.home_zip, a.home_addr\n"
        		+ "FROM USERS a, BRANCH b, CODE c, mail_mng d\n"
        		+ "where a.USER_ID='" + user_id +"' and a.BR_ID = b.BR_ID and c.C_ST = '0002' and c.CODE = a.DEPT_ID and a.mail_id=d.userid(+) and a.enter_dt is not null and a.enter_dt<>'99999999'\n";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:InsaCardUserList]"+e);
			System.out.println("[InsaCardDatabase:InsaCardUserList]"+query);
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
	*	사용자별 연차일수,사용일수,남은일수 계산 - 2008.11.24.월
	*/
	public Vector getVacationAll2(String user_id){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";


		query = "SELECT case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt))/12 *12) >=24 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') end END_DT,  b.*, "+
				" trunc(MONTHS_BETWEEN(TO_DATE(case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt))/12 *12) >=24 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') end), sysdate))RE_MONTH,  "+
				" ceil(MOD(MONTHS_BETWEEN(TO_DATE(case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt))/12 *12) >=24 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') end), sysdate) ,1 ) * 30) RE_DAY, "+
				" decode(b.YEAR, "+//+decode(b.YEAR,0,0,1)
				" 		0,b.MONTH, "+//1년미만자는 개월수
				" 		1,15, 2,15, 3,16, 4,16, 5,17, 6,17,	7,18, 8,18, 9,19, 10,19, 11,20, 12,20, 13,21, 14,21, 15,22, 16,22, 17,23, 18,23, 19,24, 20,24, "+
				"		decode(sign(b.YEAR-21),0,25,1,25,0) "+
				"		) VACATION, "+
				" nvl(decode(b.YEAR, "+
				"            0, d.vacation_cnt, 1, decode(substr(b.enter_dt,0,4),'2004',c.vacation_cnt,d.vacation_cnt), c.vacation_cnt "+
				"           ) "+
				"  ,0) V_CNT "+
				" FROM DUAL a, (select "+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) YEAR,  "+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(a.enter_dt, 'YYYYMMDD')) -  "+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) * 12) MONTH,  "+
				"					TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(a.enter_dt, 'YYYYMMDD')) -  "+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(a.enter_dt, 'YYYYMMDD')))) * 30.5) DAY, "+
				" 				a.user_id, a.br_id, decode(a.br_id,'S1','본사','B1','부산지점','D1','대전지점','S2','강남지점','J1','광주지점','G1','대구지점','I1','인천지점','S4','강서','S5','구로','U1','울산','S5','종로','S6','송파') br_nm,   "+
				"					a.dept_id, c.NM AS DEPT_NM,   "+
				"					a.user_pos, a.user_nm, a.enter_dt   "+
				"			from users a, (select * from CODE where c_st='0002') c where a.use_yn='Y' and a.DEPT_ID = c.CODE(+) and a.user_pos in  ('이사', '팀장', '차장', '과장', '대리', '사원') ) b,  "+
				"	   (select b.user_id, nvl(count(0),0) vacation_cnt   "+
				"		from sch_prv a, users b   "+
				"		where start_year||start_mon||start_day between to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) and to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4)-1  "+
				"		and sch_chk ='3'  "+
				"		and to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4))  "+
				"		and a.user_id(+) = b.user_id  "+
				"		group by b.user_id		  "+
				"		union  "+
				"		select b.user_id, nvl(count(0),0) vacation_cnt   "+
				"		from sch_prv a, users b   "+
				"		where start_year||start_mon||start_day between (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) and to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4)-1  "+
				"		and sch_chk ='3'  "+
				"		and to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4))  "+
				"		and a.user_id(+) = b.user_id  "+
				"		group by b.user_id  "+
				"		) c, "+
				"		(select b.user_id, nvl(count(0),0) vacation_cnt "+
				"		from sch_prv a, users b "+
				"		where start_year||start_mon||start_day between b.enter_dt and substr(b.enter_dt,0,4)+2||substr(b.enter_dt,5,4)-1 "+
				"		and sch_chk ='3' "+
				"		and a.user_id(+) = b.user_id "+
				"		group by b.user_id "+
				"		) d "+
				" where b.USER_ID='" + user_id +"' and b.user_id=c.user_id(+) and b.user_id=d.user_id(+) and b.dept_id in ('0001','0002','0003','0005', '0007', '0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018') "+
				subQuery+
				" order by decode(sign(to_number(substr(b.enter_dt,5,2))-to_number(to_char(sysdate,'mm'))),-1,  "+
				"                 to_number(to_char(sysdate,'mm'))-to_number(substr(b.enter_dt,5,2))-12,  "+
				"                 to_number(to_char(sysdate,'mm'))-to_number(substr(b.enter_dt,5,2))  "+
				"         ) desc , substr(b.enter_dt,7,2)	   ";


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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

		}catch(SQLException e){
			System.out.println("[InsaCardDatabase:getVacationAll2()]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}		
	}

	/**
	 *	학력정보 입력하기
	 */

public int insertSchool(Insa_ScBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

 	  	query_seq = "select nvl(max(seq)+1, 1)  from insa_school where user_id = '" + bean.getUser_id() + "'";	

		query = " insert into insa_school \n"+
				" (user_id, seq, sc_gubun, sc_ed_dt, sc_name, sc_study, sc_st\n"+
				" ) values ("+
				" ?, ?, ?, replace(?,'-',''), ?, ?, ?"+
				" )";		

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getSc_gubun());
			pstmt.setString(4, bean.getSc_ed_dt());
			pstmt.setString(5, bean.getSc_name());
			pstmt.setString(6, bean.getSc_study());
			pstmt.setString(7, bean.getSc_st());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:insertSchool]\n"+e);
			System.out.println("[InsaCardDatabase:insertSchool]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	/**
	 *	인사발령 입력하기
	 */
	

public int insertIb(Insa_IbBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";
		String u_query = "";

		int seq = 0;

 	  	query_seq = "select nvl(max(seq)+1, 1)  from insa_ib where user_id = '" + bean.getUser_id() + "'";	

		query = " insert into insa_ib \n"+
				" (user_id, seq, ib_dt, ib_gubun, ib_content, ib_job, ib_type, ib_dept \n"+
				" ) values ("+
				" ?, ?, replace(?,'-',''), ?, ?, ? , ?, ? "+
				" )";	
		
	//	u_query = " update users set  where user_id = '" + bean.getUser_id() + "'";	

		//user table 반영건 
		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getIb_dt());
			pstmt.setString(4, bean.getIb_gubun());
			pstmt.setString(5, bean.getIb_content());
			pstmt.setString(6, bean.getIb_job());
			pstmt.setString(7, bean.getIb_type());
			pstmt.setString(8, bean.getIb_dept());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();			
			

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:insertIb]\n"+e);
			System.out.println("[InsaCardDatabase:insertIb]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	상벌사항 입력하기
	 */
	
public int insertSb(Insa_SbBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

 	  	query_seq = "select nvl(max(seq)+1, 1) from insa_sb where user_id = '" + bean.getUser_id() + "'";	

		query = " insert into insa_sb \n"+
				" (user_id, seq, sb_dt, sb_gubun, sb_content, sb_js_dt, sb_je_dt\n"+
				" ) values ("+
				" ?, ?, replace(?,'-',''), ?, ?, ?, ?"+
				" )";		

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getSb_dt());
			pstmt.setString(4, bean.getSb_gubun());
			pstmt.setString(5, bean.getSb_content());
			pstmt.setString(6, bean.getSb_js_dt());
			pstmt.setString(7, bean.getSb_je_dt());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:insertSb]\n"+e);
			System.out.println("[InsaCardDatabase:insertSb]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	/**
	 *	가족사항 입력하기
	 */
	
public int insertFy(Insa_FyBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

 	  	query_seq = "select nvl(max(seq)+1, 1)  from insa_fy where user_id = '" + bean.getUser_id() + "'";	

		query = " insert into insa_fy \n"+
				" (user_id, seq, fy_gubun, fy_name, fy_birth\n"+
				" ) values ("+
				" ?, ?, ?, ?, ?"+
				" )";		

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getFy_gubun());
			pstmt.setString(4, bean.getFy_name());
			pstmt.setString(5, bean.getFy_birth());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:insertFy]\n"+e);
			System.out.println("[InsaCardDatabase:insertFy]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

 	/**
	 *	 신원보증 입력하기
	 */

	
public int insertSw(Insa_SwBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

 	  	query_seq = "select nvl(max(seq)+1, 1)  from insa_sw where user_id = '" + bean.getUser_id() + "'";	

		query = " insert into insa_sw \n"+
				" (user_id, seq, sw_gubun, sw_name, sw_ssn, sw_addr, sw_tel, sw_my_gubun, sw_st_dt, sw_ed_dt, \n"+
				" sw_up_dt, sw_insu_nm, sw_insu_money, sw_insu_no, sw_file, sw_jesan \n"+
				" ) values ("+
				" ?, ?, ?, ?, ?, ?, ?, ?, replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), ?, ?, ?, ?, ?"+
				" )";		

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getSw_gubun());
			pstmt.setString(4, bean.getSw_name());
			pstmt.setString(5, bean.getSw_ssn());
			pstmt.setString(6, bean.getSw_addr());
			pstmt.setString(7, bean.getSw_tel());
			pstmt.setString(8, bean.getSw_my_gubun());
			pstmt.setString(9, bean.getSw_st_dt());
			pstmt.setString(10, bean.getSw_ed_dt());
			pstmt.setString(11, bean.getSw_up_dt());
			pstmt.setString(12, bean.getSw_insu_nm());
			pstmt.setString(13, bean.getSw_insu_money());
			pstmt.setString(14, bean.getSw_insu_no());
			pstmt.setString(15, bean.getSw_file());
			pstmt.setString(16, bean.getSw_jesan());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:insertSw]\n"+e);
			System.out.println("[InsaCardDatabase:insertSw]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	전직경력 입력하기
	 */
	
public int insertWk(Insa_WkBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

 	  	query_seq = "select nvl(max(seq)+1, 1)  from insa_wk where user_id = '" + bean.getUser_id() + "'";	

		query = " insert into insa_wk \n"+
				" (user_id, seq, wk_st_dt, wk_ed_dt, wk_name, wk_pos, wk_work, wk_emp, wk_title\n"+
				" ) values ("+
				" ?, ?, replace(?,'-',''), replace(?,'-',''), ?, ?, ?, ?, ?"+
				" )";		

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getWk_st_dt());
			pstmt.setString(4, bean.getWk_ed_dt());
			pstmt.setString(5, bean.getWk_name());
			pstmt.setString(6, bean.getWk_pos());
			pstmt.setString(7, bean.getWk_work());
			pstmt.setString(8, bean.getWk_emp());
			pstmt.setString(9, bean.getWk_title());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:insertWk]\n"+e);
			System.out.println("[InsaCardDatabase:insertWk]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	자격/면허 입력하기
	 */

public int insertLs(Insa_LsBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

 	  	query_seq = "select nvl(max(seq)+1, 1)  from insa_ls where user_id = '" + bean.getUser_id() + "'";	

		query = " insert into insa_ls \n"+
				" (user_id, seq, ls_dt, ls_name, ls_bmng, ls_num\n"+
				" ) values ("+
				" ?, ?, replace(?,'-',''), ?, ?, ?"+
				" )";		

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getLs_dt());
			pstmt.setString(4, bean.getLs_name());
			pstmt.setString(5, bean.getLs_bmng());
			pstmt.setString(6, bean.getLs_num());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:insertLs]\n"+e);
			System.out.println("[InsaCardDatabase:insertLs]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	진급 입력하기
	 */

public int insertJg(Insa_JGBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

 	  	query_seq = "select nvl(max(seq)+1, 1)  from insa_pos where user_id = '" + bean.getUser_id() + "'";	

		query = " insert into insa_pos \n"+
				" (user_id, seq, jg_dt, br_dt, pos, note\n"+
				" ) values ("+
				" ?, ?, replace(?,'-',''), replace(?,'-',''), ?, ?"+
				" )";		

		try 
		{			
			conn.setAutoCommit(false);
			
  			stmt = conn.createStatement();
            rs = stmt.executeQuery(query_seq);
         
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
				
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getUser_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getJg_dt());
			pstmt.setString(4, bean.getBr_dt());
			pstmt.setString(5, bean.getPos());
			pstmt.setString(6, bean.getNote());

			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:insertJg]\n"+e);
			System.out.println("[InsaCardDatabase:insertJg]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(stmt != null) stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	조직관리 -> 인사기록카드 -> 학력사항 조회
	 */

	
	public Vector Insa_sc(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT user_id, seq, decode(sc_gubun,'1','고등학교','2','대학교','3','대학원','4','기타') as sc_gubun, sc_ed_dt, sc_name, sc_study, decode(sc_st, '1', '입학', '2', '졸업', '3', '편입', '4', '졸업예정', '5', '수료', '6', '재학', '7', '휴학') as sc_st\n"
        		+ "FROM Insa_school \n"
        		+ "where USER_ID='" + user_id +"'\n";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:Insa_sc]"+e);
			System.out.println("[InsaCardDatabase:Insa_sc]"+query);
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
	 *	조직관리 -> 인사기록카드 -> 인사발령 조회
	 */

	
	public Vector Insa_ib(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT ib_dt, decode(ib_gubun, '1', '정기인사','2','수시인사') as ib_gubun, ib_content, decode(ib_job, '1','외근직-1군','2','외근직-2군', '3','내근직')as ib_job , decode(ib_type, '1','직군','2','부서', '직군')as ib_type, ib_dept \n"
        		+ "FROM insa_ib \n"
        		+ "where USER_ID='" + user_id +"'\n";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:Insa_ib]"+e);
			System.out.println("[InsaCardDatabase:Insa_ib]"+query);
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
	 *	조직관리 -> 인사기록카드 -> 상벌사항 조회
	 */

	
	public Vector Insa_sb(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT user_id, seq, sb_dt, sb_content, decode(sb_gubun, '1','포상','2','시말서제출','3','감봉','4','대기발령','5','해고')as sb_gubun, sb_js_dt, sb_je_dt\n"
        		+ "FROM insa_sb \n"
        		+ "where USER_ID='" + user_id +"'\n";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:Insa_ib]"+e);
			System.out.println("[InsaCardDatabase:Insa_ib]"+query);
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
	 *	조직관리 -> 인사기록카드 -> 가족사항 조회
	 */

	
	public Vector Insa_fy(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT user_id, seq, fy_gubun, fy_name, fy_birth, TRUNC(MONTHS_BETWEEN(SYSDATE, fy_birth)/12)as fy_age\n"
        		+ "FROM insa_fy \n"
        		+ "where USER_ID='" + user_id +"'\n";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:Insa_fy]"+e);
			System.out.println("[InsaCardDatabase:Insa_fy]"+query);
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
	 *	조직관리 -> 인사기록카드 -> 신원보증사항 조회
	 */

	
	public Vector Insa_sw(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.user_id, a.seq, a.sw_gubun, a.sw_name, a.sw_ssn, a.sw_addr, a.sw_tel, a.sw_my_gubun, a.sw_st_dt, to_char(add_months(to_date(b.enter_dt, 'YYYYMMDD HH24:MI:SS'), '60'),'YYYYMMDD') as sw_ed_dt, a.sw_up_dt, a.sw_insu_nm, a.sw_insu_money, a.sw_insu_no, decode(a.sw_jesan, '1','유','2','무')as sw_jesan, a.sw_file \n"
        		+ "FROM insa_sw a, users b \n"
        		+ "where a.user_id = b.user_id and a.USER_ID='" + user_id +"'\n";



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:Insa_sw]"+e);
			System.out.println("[InsaCardDatabase:Insa_sw]"+query);
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
	 *	조직관리 -> 인사기록카드 -> 전직경력사항 조회
	 */

	
	public Vector Insa_wk(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT user_id, seq, wk_st_dt, wk_ed_dt, wk_name, wk_pos, wk_work, wk_title, decode(wk_emp,'1','상용직','2','계약직','3','임시직') as wk_emp, \n"+
				" TRUNC( MONTHS_BETWEEN( TO_DATE( wk_ed_dt, 'YYYYMMDD' ), TO_DATE( wk_st_dt, 'YYYYMMDD' )) / 12 ) YEAR,\n "+
				" TRUNC( MONTHS_BETWEEN( TO_DATE( wk_ed_dt, 'YYYYMMDD' ), TO_DATE( wk_st_dt, 'YYYYMMDD' )) - TRUNC( MONTHS_BETWEEN( TO_DATE( wk_ed_dt, 'YYYYMMDD' ), TO_DATE( wk_st_dt, 'YYYYMMDD' )) / 12 ) * 12 ) + 1 MONTH, \n"+
				" TRUNC(( MONTHS_BETWEEN( TO_DATE( wk_ed_dt, 'YYYYMMDD' ), TO_DATE( wk_st_dt, 'YYYYMMDD' )) - TRUNC( MONTHS_BETWEEN( TO_DATE( wk_ed_dt, 'YYYYMMDD' ), TO_DATE( wk_st_dt, 'YYYYMMDD' )))) * 30.5 ) DAY \n"+
        		" FROM insa_wk \n"+
        		" where USER_ID='" + user_id +"'\n";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:Insa_wk]"+e);
			System.out.println("[InsaCardDatabase:Insa_wk]"+query);
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
	 *	조직관리 -> 인사기록카드 -> 자격/면허 조회
	 */
	
	public Vector Insa_ls(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT *\n"
        		+ "FROM insa_ls \n"
        		+ "where USER_ID='" + user_id +"'\n";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:Insa_ls]"+e);
			System.out.println("[InsaCardDatabase:Insa_ls]"+query);
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
	 *	조직관리 -> 인사기록카드 -> 진급 조회
	 */

	
	public Vector Insa_Jg(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT *\n"
        		+ "FROM insa_pos \n"
        		+ "where USER_ID='" + user_id +"'\n";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:Insa_jg]"+e);
			System.out.println("[InsaCardDatabase:Insa_jg]"+query);
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
	 *	조직관리 -> 고용현황 -> 전체조회 (퇴직자 포함) -- 2009-01-05
	 */
public Vector gylist(String user_id, String auth_rw, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "a.DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_POS,\n"
        				+ "to_number(a.ENTER_DT) as enter_dt, \n"
						+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out\n"
		        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
						+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) \n"
        				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('이사', '부장', '팀장','차장', '과장','대리','사원') /* and a.use_yn = 'Y' */\n";



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gylist]"+e);
			System.out.println("[InsaCardDatabase:gylist]"+query);
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


public Vector gylist_yeardate(String user_id, String auth_rw, String s_kd, String t_wd, String sort_gubun, String asc, int yd1, int yd2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "decode(a.DEPT_ID,'9999',a.dept_out, a.dept_id) dept_id,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_POS,\n"
        				+ "to_number(a.ENTER_DT) as enter_dt, \n"
						+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out \n"
		        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
		        		//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청)
						+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and a.dept_id not in '1000' AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177') \n"
        				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','감사', '부장', '팀장','차장', '과장','대리','사원') and a.enter_dt <= '"+yd1+"'   AND A.USE_YN = 'Y' \n"
						+ "MINUS  "
						+ "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "decode(a.DEPT_ID,'9999',a.dept_out, a.dept_id) dept_id,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_POS,\n"
        				+ "to_number(a.ENTER_DT) as enter_dt, \n"
						+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out \n"
		        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
		        		//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청)
						+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and a.dept_id not in '1000' AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177')  \n"
        				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','감사', '부장', '팀장','차장', '과장','대리','사원') and a.out_dt < '"+yd2+"'   AND A.USE_YN = 'N' \n"
						+ "";

 

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gylist]"+e);
			System.out.println("[InsaCardDatabase:gylist]"+query);
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
	 *	조직관리 -> 충원/퇴사자현황 -> 2008년 충원/퇴사자 현황 - 2009-01-30
	 */
	public Vector gylist2008In(String user_id, int years, int yeare)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				  query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "DECODE(a.DEPT_ID, '9999', a.DEPT_OUT, a.dept_id) AS dept_id,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_POS,\n"
        				+ "to_number(a.ENTER_DT) as enter_dt, \n"
						+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out,  text_decrypt(a.user_ssn, 'pw' ) user_ssn\n"
		        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
						+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and (a.ENTER_DT >= '"+years+"' and a.ENTER_DT <= '"+yeare+"') \n"
						//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청) 
        				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','감사','부장','팀장','차장','과장','대리','사원')\n"
        				+ "AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177') \n"
        				+ "";



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gylist2008In]"+e);
			System.out.println("[InsaCardDatabase:gylist2008In]"+query);
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

	public Vector gylist2008Out(String user_id, int years, int yeare)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "a.DEPT_OUT AS DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_POS,\n"
        				+ "to_number(a.ENTER_DT) as enter_dt, \n"
						+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out,  text_decrypt(a.user_ssn, 'pw' ) user_ssn \n"
		        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
						+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and (a.out_dt >= '"+years+"' and a.out_dt <= '"+yeare+"') \n"
						//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청)  
        				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','감사','부장','팀장','차장','과장','대리','사원') and a.use_yn = 'N'\n"
        				+ " AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177') \n"
        				+ "";
        				



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gylist2008Out]"+e);
			System.out.println("[InsaCardDatabase:gylist2008Out]"+query);
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
	 *	조직관리 -> 충원/퇴사자현황 -> 2007년 충원/퇴사자 현황 - 2009-01-30
	 */
public Vector gylist2007In(String user_id, int years, int yeare)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = "SELECT a.USER_ID,\n"
					+ "a.BR_ID,\n"
					+ "b.BR_NM,\n"
					+ "a.USER_NM,\n"
					+ "DECODE(a.DEPT_ID, '9999', a.DEPT_OUT, a.dept_id) AS dept_id,\n"
					+ "c.NM AS DEPT_NM,\n"
					+ "a.USER_POS,\n"
					+ "to_number(a.ENTER_DT) as enter_dt, \n"
					+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out,  text_decrypt(a.user_ssn, 'pw' ) user_ssn\n"
		    		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
					+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and (a.ENTER_DT >= '"+years+"' and a.ENTER_DT <= '"+yeare+"') \n"
					//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청) 
					+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','감사','부장','팀장','차장','과장','대리','사원')\n"
    				+ "AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177') \n"
    				+ "";	


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gylist2007In]"+e);
			System.out.println("[InsaCardDatabase:gylist2007In]"+query);
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

public Vector gylist2007Out(String user_id, int years, int yeare)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "a.DEPT_OUT AS DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_POS,\n"
        				+ "to_number(a.ENTER_DT) as enter_dt, \n"
						+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out,  text_decrypt(a.user_ssn, 'pw' ) user_ssn\n"
		        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
						+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and (a.out_dt >= '"+years+"' and a.out_dt <= '"+yeare+"') \n"
						//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청) 
        				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','감사','부장','팀장','차장','과장','대리','사원') and a.use_yn = 'N'\n"
        				+ " AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177') \n"
        				+ "";
						


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gylist2007Out]"+e);
			System.out.println("[InsaCardDatabase:gylist2007Out]"+query);
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
	 *	조직관리 -> 충원/퇴사자현황 -> 2006년 충원/퇴사자 현황 - 2009-01-30
	 */
public Vector gylist2006In(String user_id, int years, int yeare)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = "SELECT a.USER_ID,\n"
					+ "a.BR_ID,\n"
					+ "b.BR_NM,\n"
					+ "a.USER_NM,\n"
					+ "DECODE(a.DEPT_ID, '9999', a.DEPT_OUT, a.dept_id) AS dept_id,\n"
					+ "c.NM AS DEPT_NM,\n"
					+ "a.USER_POS,\n"
					+ "to_number(a.ENTER_DT) as enter_dt, \n"
					+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out,  text_decrypt(a.user_ssn, 'pw' ) user_ssn\n"
	        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
					+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and (a.ENTER_DT >= '"+years+"' and a.ENTER_DT <= '"+yeare+"') \n"
					//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청) 
					+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','감사','부장','팀장','차장','과장','대리','사원')\n"
    				+ "AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177') \n"
    				+ "";
						


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gylist2006In]"+e);
			System.out.println("[InsaCardDatabase:gylist2006In]"+query);
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

public Vector gylist2006Out(String user_id, int years, int yeare)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "a.DEPT_OUT AS DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_POS,\n"
        				+ "to_number(a.ENTER_DT) as enter_dt, \n"
						+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out, text_decrypt(a.user_ssn, 'pw' ) user_ssn\n"
		        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
						+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and (a.out_dt >= '"+years+"' and a.out_dt <= '"+yeare+"') \n"
						//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청) 
        				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','감사','부장','팀장','차장','과장','대리','사원') and a.use_yn = 'N'\n"
        				+ " AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177') \n"
        				+ "";
						


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gylist2006Out]"+e);
			System.out.println("[InsaCardDatabase:gylist2006Out]"+query);
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
 *	조직관리 -> 충원/퇴사자현황 -> 당해년-3 충원/퇴사자 현황 - 2016-07-19
 */
public Vector gylist2005In(String user_id, int years, int yeare)
{
	getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Vector vt = new Vector();
	String query = "";

		query = "SELECT a.USER_ID,\n"
				+ "a.BR_ID,\n"
				+ "b.BR_NM,\n"
				+ "a.USER_NM,\n"
				+ "DECODE(a.DEPT_ID, '9999', a.DEPT_OUT, a.dept_id) AS dept_id,\n"
				+ "c.NM AS DEPT_NM,\n"
				+ "a.USER_POS,\n"
				+ "to_number(a.ENTER_DT) as enter_dt, \n"
				+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out,  text_decrypt(a.user_ssn, 'pw' ) user_ssn\n"
	    		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
				+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and (a.ENTER_DT >= '"+years+"' and a.ENTER_DT <= '"+yeare+"') \n"
				//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청) 
				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','감사','부장','팀장','차장','과장','대리','사원')\n"
				+ "AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177') \n"
				+ "";
					


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
				 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
			}
			vt.add(ht);	
		}
			rs.close();
			pstmt.close();

	} catch (SQLException e) {
		System.out.println("[InsaCardDatabase:gylist2005In]"+e);
		System.out.println("[InsaCardDatabase:gylist2005In]"+query);
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

public Vector gylist2005Out(String user_id, int years, int yeare)
{
	getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Vector vt = new Vector();
	String query = "";

			 query = "SELECT a.USER_ID,\n"
    				+ "a.BR_ID,\n"
    				+ "b.BR_NM,\n"
    				+ "a.USER_NM,\n"
    				+ "a.DEPT_OUT AS DEPT_ID,\n"
    				+ "c.NM AS DEPT_NM,\n"
    				+ "a.USER_POS,\n"
    				+ "to_number(a.ENTER_DT) as enter_dt, \n"
					+ "a.loan_st, a.out_dt, a.use_yn, a.dept_out,  text_decrypt(a.user_ssn, 'pw' ) user_ssn\n"
	        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d\n"
					+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and (a.out_dt >= '"+years+"' and a.out_dt <= '"+yeare+"') \n"
					//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청) 
    				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','감사','부장','팀장','차장','과장','대리','사원') and a.use_yn = 'N'\n"
    				+ " AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177') \n"
    				+ "";
					


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
				 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
			}
			vt.add(ht);	
		}
			rs.close();
			pstmt.close();

	} catch (SQLException e) {
		System.out.println("[InsaCardDatabase:gylist2006Out]"+e);
		System.out.println("[InsaCardDatabase:gylist2006Out]"+query);
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
	
	//순번
	public int getSeq(String gubun, String i_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int rtn = 0;
		
		query = " select  nvl(seq,0)+1  from insa_var  where gubun= ? and  i_year = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, gubun);	
			pstmt.setString(2, i_year);			
		   	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtn = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtn;
		}							
	}


	//순번
	public boolean getUpdateSeq(String gubun, String i_year, int seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
		
		query = " update insa_var set seq = ?  where gubun= ? and  i_year = ? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, seq);	
			pstmt.setString(2, gubun);	
			pstmt.setString(3, i_year);			
		   	pstmt.executeUpdate();
			pstmt.close();			
			conn.commit();
			
		} catch (Exception e) {
			System.out.println("[InsaCardDatabase:getUpdateSeq]"+e);
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



public int delete_Data(String user_id, int su_num, String st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count2 = 0;
		String query = "";


		query = " DELETE  FROM insa_"+st+" \n"+
				" where user_id='"+user_id+"' and seq= '"+su_num+"' ";		


		try 
		{			
		
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			count2 = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:delete_Data]\n"+e);
			System.out.println("[InsaCardDatabase:delete_Data]\n"+query);
	  		e.printStackTrace();
	  		count2 = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count2;
		}
	}



	/**
	 *	조직관리 -> 진급현황리스트
	 */

	public Vector Insa_promotion(String basic_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) YEAR,  \n"+
				" TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(a.enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) * 12) MONTH,  \n"+
				" c.NM AS DEPT_NM,  \n"+
				" a.user_id, a.user_pos, a.user_nm, a.enter_dt, b.pos, b.jg_dt , NVL(b.br_dt,a.enter_dt) br_dt, b.note, text_decrypt(a.user_ssn, 'pw' ) user_ssn, a.dept_id, a.loan_st,\n"+
				" TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(NVL(b.jg_dt,a.enter_dt), 'YYYYMMDD'))/12) j_YEAR,  \n"+
				" TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(NVL(b.jg_dt,a.enter_dt), 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(NVL(b.jg_dt,a.enter_dt), 'YYYYMMDD'))/12) * 12) j_MONTH, \n"+
				" TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE('19'||SUBSTR( text_decrypt(a.user_ssn, 'pw' ),1,6), 'YYYYMMDD'))/12) age,  \n"+
				" TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE('19'||SUBSTR( text_decrypt(a.user_ssn, 'pw' ),1,6), 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE('19'||SUBSTR( text_decrypt(a.user_ssn, 'pw' ),1,6), 'YYYYMMDD'))/12) * 12) age_MONTH, \n"+
				" CASE WHEN a.user_pos = '사원' and TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) >= 4 THEN	'대리' \n"+
				" WHEN a.user_pos = '대리' and TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(b.jg_dt, 'YYYYMMDD'))/12) >= 4 THEN '과장' \n"+
				" WHEN a.user_pos = '과장' and TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(b.jg_dt, 'YYYYMMDD'))/12) >= 6 THEN '차장' \n"+
				" WHEN a.user_pos = '차장' and TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(b.jg_dt, 'YYYYMMDD'))/12) >= 6 THEN '부장' \n"+	//추가(20181210)
				" END next_pos \n"+
				" FROM users a, \n"+
				" (SELECT a.user_id, a.pos, a.jg_dt, a.br_dt, a.note FROM INSA_POS a, (SELECT user_id, MAX(seq) max_seq FROM INSA_POS GROUP BY user_id ) b WHERE a.USER_ID = b.user_id AND a.SEQ = b.max_seq  ) b,  \n"+
				" (select * from CODE where c_st='0002') c "+
				" WHERE a.use_yn='Y' AND a.user_id = b.user_id(+) and a.DEPT_ID = c.CODE(+) \n"+
				" AND a.DEPT_ID IN ('0001','0002','0003','0005','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020') \n"+
				" AND a.USER_id NOT IN ('000031', '000124', '000177', '000238', '000285', '000302', '000333') and a.id not like 'develop%' \n"+
				" AND a.user_pos IN ('이사', '부장', '차장', '팀장', '과장', '대리', '사원') \n"+
				" ORDER BY a.enter_dt \n";


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:Insa_promotion]"+e);
			System.out.println("[InsaCardDatabase:Insa_promotion]"+query);
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
	 *	고용현황2 20160725 
	 * 성승현
	 */

	public Vector Insa_promotion2(String basic_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) YEAR,  \n"+
				" TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(a.enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) * 12) MONTH,  \n"+
				" c.NM AS DEPT_NM,  \n"+
				" a.user_id, a.user_pos, a.user_nm, a.enter_dt, b.pos, b.jg_dt , NVL(b.br_dt,a.enter_dt) br_dt, b.note, text_decrypt(a.user_ssn, 'pw' ) user_ssn, a.dept_id, a.loan_st,\n"+
				" TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(NVL(b.jg_dt,a.enter_dt), 'YYYYMMDD'))/12) j_YEAR,  \n"+
				" TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(NVL(b.jg_dt,a.enter_dt), 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(NVL(b.jg_dt,a.enter_dt), 'YYYYMMDD'))/12) * 12) j_MONTH, \n"+
				" TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE('19'||SUBSTR( text_decrypt(a.user_ssn, 'pw' ),1,6), 'YYYYMMDD'))/12) age,  \n"+
				" TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE('19'||SUBSTR( text_decrypt(a.user_ssn, 'pw' ),1,6), 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE('19'||SUBSTR( text_decrypt(a.user_ssn, 'pw' ),1,6), 'YYYYMMDD'))/12) * 12) age_MONTH, \n"+
				" CASE WHEN a.user_pos = '사원' and TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) >= 4 THEN	'대리' \n"+
				" WHEN a.user_pos = '대리' and TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(b.jg_dt, 'YYYYMMDD'))/12) >= 4 THEN '과장' \n"+
				" WHEN a.user_pos = '과장' and TRUNC(MONTHS_BETWEEN('"+basic_dt+"', TO_DATE(b.jg_dt, 'YYYYMMDD'))/12) >= 6 THEN '차장' \n"+
				" END next_pos \n"+
				" FROM users a, \n"+
				" (SELECT a.user_id, a.pos, a.jg_dt, a.br_dt, a.note FROM INSA_POS a, (SELECT user_id, MAX(seq) max_seq FROM INSA_POS GROUP BY user_id ) b WHERE a.USER_ID = b.user_id AND a.SEQ = b.max_seq  ) b,  \n"+
				" (select * from CODE where c_st='0002') c "+
				" WHERE 1=1 \n"+
			//	" AND a.use_yn='Y' \n"+
				" AND (a.use_yn='Y' OR (a.use_yn='N' AND out_dt > '"+basic_dt+"')) \n"+	//기준일자 이후 퇴사자는 카운팅(20181031)
				" AND a.user_id = b.user_id(+) and a.DEPT_ID = c.CODE(+) \n"+
				//VV 2018.07.11일 기준 외부개발자 3명,조민규님 의 id는 제외 처리(대표이사,감사 는 추가)(류길선과장님 요청) 
				" AND a.DEPT_ID IN ('0001','0002','0003','0004','0005','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020','9999') \n"+	//기준일자 이후 퇴사자 카운팅위해 9999 추가(20181031)
				" AND a.user_pos IN ('대표이사', '이사', '감사', '부장', '차장', '팀장', '과장', '대리', '사원') \n"+
				" AND a.id not like 'develop%' and a.USER_ID NOT IN ('000177') \n"+
				" AND a.enter_dt <= '"+basic_dt+"' \n"+	//추가(20181025)
				" ORDER BY a.enter_dt \n";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:Insa_promotion]"+e);
			System.out.println("[InsaCardDatabase:Insa_promotion]"+query);
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


	public Vector gylist_yeardate(String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		
		base_query = "SELECT loan_st_nm, dept_id,\r\n"
				+ "				               COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(SYSDATE,'YYYY'),user_id)) cnt1, --현재-당일\r\n"
				+ "				               COUNT(DECODE(SUBSTR(save_dt,1,4),to_char(add_months(sysdate,-12*1),'YYYY'),user_id)) cnt2, --1년전\r\n"
				+ "				               COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(add_months(sysdate,-12*2),'YYYY'),user_id)) cnt3, --2년전\r\n"
				+ "				               COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(add_months(sysdate,-12*3),'YYYY'),user_id)) cnt4, --3년전\r\n"
				+ "				               COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(add_months(sysdate,-12*4),'YYYY'),user_id)) cnt5  --4년전\r\n"
				+ "				        FROM \r\n"
				+ "				             (\r\n"
				+ "				               --마감현황 2018년부터\r\n"
				+ "				               SELECT save_dt,           user_id, user_nm, user_pos, br_id, DECODE(INSTR(user_pos||user_work,'이사'),0,dept_id,'0004') dept_id, loan_st, enter_dt, out_dt, user_work, user_fm, work_year, loan_st_nm FROM stat_user where save_dt LIKE '%1231'\r\n"
				+ "				               UNION ALL\r\n"
				+ "				               --당일\r\n"
				+ "				               SELECT TO_CHAR(SYSDATE,'YYYYMMDD') save_dt, user_id, user_nm, user_pos, br_id, DECODE(INSTR(user_pos||user_work,'이사'),0,dept_id,'0004') dept_id, loan_st, enter_dt, out_dt, user_work, '1' user_fm, '1' work_year, DECODE(NVL(loan_st,'0'),'1','외근직','2','외근직','내근직') loan_st_nm FROM users WHERE use_yn='Y' AND dept_id NOT IN ('8888','1000') AND NVL(dept_out,dept_id) NOT IN ('8888','1000') AND user_id NOT IN ('000177') AND NVL(user_work,'아마존카직원') NOT IN ('파견직원','에이전트','외부') AND id NOT LIKE 'develop%'\r\n"
				+ "				             ) \r\n"
				+ "				        GROUP BY loan_st_nm, dept_id";
		
//		+ "              --2017년 (마감관리전)"
//		+ "              UNION ALL"
//		+ "              SELECT '20171231' save_dt, user_id, user_nm, user_pos, br_id, DECODE(INSTR(user_pos||user_work,'이사'),0,dept_id,'0004') dept_id, loan_st, enter_dt, out_dt, user_work, '1' user_fm, '1' work_year, DECODE(NVL(loan_st,'0'),'1','외근직','2','외근직','내근직') loan_st_nm FROM users WHERE TO_CHAR(SYSDATE,'YYYY')='2021' AND enter_dt <= '20180101' AND dept_id NOT IN ('8888','1000') AND NVL(dept_out,dept_id) NOT IN ('8888','1000') AND user_id NOT IN ('000177') AND NVL(user_work,'아마존카직원') NOT IN ('파견직원','에이전트','외부') AND id NOT LIKE 'develop%'"
//		+ "              MINUS"
//		+ "              SELECT '20171231' save_dt, user_id, user_nm, user_pos, br_id, DECODE(INSTR(user_pos||user_work,'이사'),0,dept_id,'0004') dept_id, loan_st, enter_dt, out_dt, user_work, '1' user_fm, '1' work_year, DECODE(NVL(loan_st,'0'),'1','외근직','2','외근직','내근직') loan_st_nm FROM users WHERE TO_CHAR(SYSDATE,'YYYY')='2021' AND out_dt <= '20171231'"

		
		//직군별 현황 - 외근직
		if(mode.equals("1")) {
			
			query = "--직군별 고용현황\r\n"
					+ "SELECT a.loan_st_nm, a.dept_id, a.nm, a.loc_st, NVL(cnt1,0) cnt1, NVL(cnt2,0) cnt2, NVL(cnt3,0) cnt3, NVL(cnt4,0) cnt4, NVL(cnt5,0) cnt5\r\n"
					+ "FROM \r\n"
					+ "       ( " +base_query+ " ) b, \r\n"					
					+ "       (\r\n"
					+ "         SELECT '외근직' loan_st_nm, a.dept_id, replace(b.nm,' ','') nm, DECODE(INSTR(b.nm,'지점'),0,'본사','지점') loc_st \r\n"
					+ "         FROM   stat_user a, code b \r\n"
					+ "         WHERE  a.dept_id=b.code AND b.c_st='0002' AND a.dept_id<>'0004' \r\n"
					+ "         GROUP BY a.dept_id, b.nm\r\n"
					+ "       ) a\r\n"
					+ "WHERE b.loan_st_nm=a.loan_st_nm AND b.dept_id=a.dept_id\r\n"
					+ "ORDER BY a.loc_st, DECODE(a.nm,'임원',0,1), a.nm\r\n";
			
		}
		
		//직군별 현황 - 내근직
		if(mode.equals("2")) {
			
			query = "--직군별 고용현황\r\n"
					+ "SELECT a.loan_st_nm, a.dept_id, a.nm, a.loc_st, NVL(cnt1,0) cnt1, NVL(cnt2,0) cnt2, NVL(cnt3,0) cnt3, NVL(cnt4,0) cnt4, NVL(cnt5,0) cnt5\r\n"
					+ "FROM \r\n"
					+ "       ( " +base_query+ " ) b,  \r\n"
					+ "       (\r\n"
					+ "         SELECT '내근직' loan_st_nm, a.dept_id, replace(b.nm,' ','') nm, DECODE(INSTR(b.nm,'지점'),0,'본사','지점') loc_st \r\n"
					+ "         FROM   stat_user a, code b \r\n"
					+ "         WHERE  a.dept_id=b.code AND b.c_st='0002' \r\n"
					+ "         GROUP BY a.dept_id, b.nm\r\n"
					+ "       ) a\r\n"
					+ "WHERE b.loan_st_nm=a.loan_st_nm AND b.dept_id=a.dept_id\r\n"
					+ "ORDER BY a.loc_st, DECODE(a.nm,'임원',0,1), a.nm";
			
		}
		
		//부서별 현황 - 본점
		if(mode.equals("3")) {
			
			query = "--직군별 고용현황\r\n"
					+ "SELECT a.loan_st_nm, a.dept_id, a.nm, a.loc_st, NVL(cnt1,0) cnt1, NVL(cnt2,0) cnt2, NVL(cnt3,0) cnt3, NVL(cnt4,0) cnt4, NVL(cnt5,0) cnt5\r\n"
					+ "FROM \r\n"
					+ "       ( " +base_query+ " ) b,  \r\n"					
					+ "       (\r\n"
					+ "         SELECT '본점' loan_st_nm, a.dept_id, replace(b.nm,' ','') nm, DECODE(INSTR(b.nm,'지점'),0,'본사','지점') loc_st \r\n"
					+ "         FROM   stat_user a, code b \r\n"
					+ "         WHERE  a.dept_id=b.code AND b.c_st='0002' and b.nm not like '%지점%' \r\n"
					+ "         GROUP BY a.dept_id, b.nm\r\n"
					+ "       ) a\r\n"
					+ "WHERE b.dept_id=a.dept_id\r\n"
					+ "ORDER BY DECODE(a.nm,'임원',0,1), a.nm\r\n";
			
		}
		
		//부서별 현황 - 지점
		if(mode.equals("4")) {
			
			query = "--직군별 고용현황\r\n"
					+ "SELECT a.loan_st_nm, a.dept_id, a.nm, a.loc_st, NVL(cnt1,0) cnt1, NVL(cnt2,0) cnt2, NVL(cnt3,0) cnt3, NVL(cnt4,0) cnt4, NVL(cnt5,0) cnt5\r\n"
					+ "FROM \r\n"
					+ "       ( " +base_query+ " ) b,  \r\n"					
					+ "       (\r\n"
					+ "         SELECT '지점' loan_st_nm, a.dept_id, replace(b.nm,' ','') nm, DECODE(INSTR(b.nm,'지점'),0,'본사','지점') loc_st \r\n"
					+ "         FROM   stat_user a, code b \r\n"
					+ "         WHERE  a.dept_id=b.code AND b.c_st='0002' and b.nm like '%지점%' \r\n"
					+ "         GROUP BY a.dept_id, b.nm\r\n"
					+ "       ) a \r\n"
					+ "WHERE b.dept_id=a.dept_id\r\n"
					+ "ORDER BY a.nm\r\n";
			
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gylist_yeardate(String mode)]"+e);
			System.out.println("[InsaCardDatabase:gylist_yeardate(String mode)]"+query);
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


	public Vector gyTolist_yeardate(String mode)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		
		base_query = "SELECT loan_st_nm, dept_id,\r\n"
				+ "							 COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(SYSDATE,'YYYY'),DECODE(st,'충원',user_id))) cnt1, --현재-당일\r\n"
				+ "							 COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(SYSDATE,'YYYY'),DECODE(st,'퇴사',user_id))) cnt2, --현재-당일				\r\n"
				+ "							 COUNT(DECODE(SUBSTR(save_dt,1,4),to_char(add_months(sysdate,-12*1),'YYYY'),DECODE(st,'충원',user_id))) cnt3, --1년전\r\n"
				+ "							 COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(add_months(sysdate,-12*1),'YYYY'),DECODE(st,'퇴사',user_id))) cnt4, --1년전\r\n"
				+ "							 COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(add_months(sysdate,-12*2),'YYYY'),DECODE(st,'충원',user_id))) cnt5, --2년전\r\n"
				+ "							 COUNT(DECODE(SUBSTR(save_dt,1,4),to_char(add_months(sysdate,-12*2),'YYYY'),DECODE(st,'퇴사',user_id))) cnt6, --2년전\r\n"
				+ "							 COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(add_months(sysdate,-12*3),'YYYY'),DECODE(st,'충원',user_id))) cnt7, --3년전\r\n"
				+ "							 COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(add_months(sysdate,-12*3),'YYYY'),DECODE(st,'퇴사',user_id))) cnt8, --3년전\r\n"
				+ "							 COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(add_months(sysdate,-12*4),'YYYY'),DECODE(st,'충원',user_id))) cnt9, --4년전\r\n"
				+ "							 COUNT(DECODE(SUBSTR(save_dt,1,4),TO_CHAR(add_months(sysdate,-12*4),'YYYY'),DECODE(st,'퇴사',user_id))) cnt10 --4년전\r\n"
				+ "				FROM \r\n"
				+ "					     (\r\n"
				+ "				         SELECT '충원' st, enter_dt AS save_dt, user_id, user_nm, user_pos, br_id, DECODE(INSTR(user_pos||user_work,'이사'),0,NVL(dept_out,dept_id),'0004') dept_id, loan_st, enter_dt, out_dt, user_work, '1' user_fm, '1' work_year, DECODE(NVL(loan_st,'0'),'1','외근직','2','외근직','내근직') loan_st_nm\r\n"
				+ "				         FROM   users \r\n"
				+ "				         WHERE  enter_dt >= TO_CHAR(add_months(sysdate,-12*4),'YYYY')||'0101' \r\n"
				+ "				         AND dept_id NOT IN ('8888','1000') AND NVL(dept_out,dept_id) NOT IN ('8888','1000') \r\n"
				+ "				         AND user_id NOT IN ('000177') AND NVL(user_work,'아마존카직원') NOT IN ('파견직원','에이전트','외부') AND id NOT LIKE 'develop%'\r\n"
				+ "				         UNION ALL \r\n"
				+ "				         SELECT '퇴사' st, out_dt AS save_dt,   user_id, user_nm, user_pos, br_id, DECODE(INSTR(user_pos||user_work,'이사'),0,NVL(dept_out,dept_id),'0004') dept_id, loan_st, enter_dt, out_dt, user_work, '1' user_fm, '1' work_year, DECODE(NVL(loan_st,'0'),'1','외근직','2','외근직','내근직') loan_st_nm\r\n"
				+ "				         FROM   users \r\n"
				+ "				         WHERE  out_dt   >= TO_CHAR(add_months(sysdate,-12*4),'YYYY')||'0101' \r\n"
				+ "				         AND dept_id NOT IN ('8888','1000') AND NVL(dept_out,dept_id) NOT IN ('8888','1000') \r\n"
				+ "				         AND user_id NOT IN ('000177') AND NVL(user_work,'아마존카직원') NOT IN ('파견직원','에이전트','외부') AND id NOT LIKE 'develop%'\r\n"
				+ "				       ) \r\n"
				+ "				GROUP BY loan_st_nm, dept_id";
		
		//직군별 현황 - 외근직
		if(mode.equals("1")) {
			
			query = "--직군별 고용현황\r\n"
					+ "SELECT a.loan_st_nm, a.dept_id, a.nm, a.loc_st, NVL(cnt1,0) cnt1, NVL(cnt2,0) cnt2, NVL(cnt3,0) cnt3, NVL(cnt4,0) cnt4, NVL(cnt5,0) cnt5, NVL(cnt6,0) cnt6, NVL(cnt7,0) cnt7, NVL(cnt8,0) cnt8\r\n"
					+ "FROM \r\n"
					+ "       ( " +base_query+ " ) b,  \r\n"					
					+ "       (\r\n"
					+ "         SELECT '외근직' loan_st_nm, a.dept_id, replace(b.nm,' ','') nm, DECODE(INSTR(b.nm,'지점'),0,'본사','지점') loc_st \r\n"
					+ "         FROM   stat_user a, code b \r\n"
					+ "         WHERE  a.dept_id=b.code AND b.c_st='0002' AND a.dept_id<>'0004' \r\n"
					+ "         GROUP BY a.dept_id, b.nm\r\n"
					+ "       ) a\r\n"
					+ "WHERE b.loan_st_nm=a.loan_st_nm AND b.dept_id=a.dept_id\r\n"
					+ "ORDER BY a.loc_st, DECODE(a.nm,'임원',0,1), a.nm\r\n";
			
		}
		
		//직군별 현황 - 내근직
		if(mode.equals("2")) {
			
			query = "--직군별 고용현황\r\n"
					+ "SELECT a.loan_st_nm, a.dept_id, a.nm, a.loc_st, NVL(cnt1,0) cnt1, NVL(cnt2,0) cnt2, NVL(cnt3,0) cnt3, NVL(cnt4,0) cnt4, NVL(cnt5,0) cnt5, NVL(cnt6,0) cnt6, NVL(cnt7,0) cnt7, NVL(cnt8,0) cnt8\r\n"
					+ "FROM \r\n"
					+ "       ( " +base_query+ " ) b,  \r\n"
					+ "       (\r\n"
					+ "         SELECT '내근직' loan_st_nm, a.dept_id, replace(b.nm,' ','') nm, DECODE(INSTR(b.nm,'지점'),0,'본사','지점') loc_st \r\n"
					+ "         FROM   stat_user a, code b \r\n"
					+ "         WHERE  a.dept_id=b.code AND b.c_st='0002' \r\n"
					+ "         GROUP BY a.dept_id, b.nm\r\n"
					+ "       ) a\r\n"
					+ "WHERE b.loan_st_nm=a.loan_st_nm AND b.dept_id=a.dept_id\r\n"
					+ "ORDER BY a.loc_st, DECODE(a.nm,'임원',0,1), a.nm\r\n";
			
		}
		
		//부서별 현황 - 본점
		if(mode.equals("3")) {
			
			query = "--직군별 고용현황\r\n"
					+ "SELECT a.loan_st_nm, a.dept_id, a.nm, a.loc_st, NVL(cnt1,0) cnt1, NVL(cnt2,0) cnt2, NVL(cnt3,0) cnt3, NVL(cnt4,0) cnt4, NVL(cnt5,0) cnt5, NVL(cnt6,0) cnt6, NVL(cnt7,0) cnt7, NVL(cnt8,0) cnt8\r\n"
					+ "FROM \r\n"
					+ "       ( " +base_query+ " ) b,  \r\n"					
					+ "       (\r\n"
					+ "         SELECT '본점' loan_st_nm, a.dept_id, replace(b.nm,' ','') nm, DECODE(INSTR(b.nm,'지점'),0,'본사','지점') loc_st \r\n"
					+ "         FROM   stat_user a, code b \r\n"
					+ "         WHERE  a.dept_id=b.code AND b.c_st='0002' and b.nm not like '%지점%' \r\n"
					+ "         GROUP BY a.dept_id, b.nm\r\n"
					+ "       ) a\r\n"
					+ "WHERE b.dept_id=a.dept_id\r\n"
					+ "ORDER BY DECODE(a.nm,'임원',0,1), a.nm\r\n";
			
		}
		
		//부서별 현황 - 지점
		if(mode.equals("4")) {
			
			query = "--직군별 고용현황\r\n"
					+ "SELECT a.loan_st_nm, a.dept_id, a.nm, a.loc_st, NVL(cnt1,0) cnt1, NVL(cnt2,0) cnt2, NVL(cnt3,0) cnt3, NVL(cnt4,0) cnt4, NVL(cnt5,0) cnt5, NVL(cnt6,0) cnt6, NVL(cnt7,0) cnt7, NVL(cnt8,0) cnt8\r\n"
					+ "FROM \r\n"
					+ "       ( " +base_query+ " ) b,  \r\n"					
					+ "       (\r\n"
					+ "         SELECT '지점' loan_st_nm, a.dept_id, replace(b.nm,' ','') nm, DECODE(INSTR(b.nm,'지점'),0,'본사','지점') loc_st \r\n"
					+ "         FROM   stat_user a, code b \r\n"
					+ "         WHERE  a.dept_id=b.code AND b.c_st='0002' and b.nm like '%지점%' \r\n"
					+ "         GROUP BY a.dept_id, b.nm\r\n"
					+ "       ) a \r\n"
					+ "WHERE b.dept_id=a.dept_id\r\n"
					+ "ORDER BY a.nm\r\n";
			
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gyTolist_yeardate(String mode)]"+e);
			System.out.println("[InsaCardDatabase:gyTolist_yeardate(String mode)]"+query);
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

	public Vector gy2list_yeardate()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "SELECT DECODE(GROUPING(a.save_dt),1,'합계',a.save_dt) save_dt,\r\n"
				+ "				       DECODE(GROUPING_ID(a.save_dt,a.user_fm),1,'소계',3,'소계',DECODE(a.user_fm,'1','남','여')) user_fm,\r\n"
				+ "				       COUNT(DECODE(b.loan_st_nm,'1',DECODE(b.st,'충원',b.user_id))) cnt1,\r\n"
				+ "				       COUNT(DECODE(b.loan_st_nm,'2',DECODE(b.st,'충원',b.user_id))) cnt2,\r\n"
				+ "				       COUNT(DECODE(b.loan_st_nm,'3',DECODE(b.st,'충원',b.user_id))) cnt3,\r\n"
				+ "				       COUNT(DECODE(b.st,'충원',b.user_id)) cnt4,       \r\n"
				+ "				       COUNT(DECODE(b.loan_st_nm,'1',DECODE(b.st,'퇴사',b.user_id))) cnt5,\r\n"
				+ "				       COUNT(DECODE(b.loan_st_nm,'2',DECODE(b.st,'퇴사',b.user_id))) cnt6,\r\n"
				+ "				       COUNT(DECODE(b.loan_st_nm,'3',DECODE(b.st,'퇴사',b.user_id))) cnt7,\r\n"
				+ "				       COUNT(DECODE(b.st,'퇴사',b.user_id)) cnt8\r\n"
				+ "				FROM \r\n"
				+ "				       (\r\n"
				+ "				         SELECT TO_CHAR(SYSDATE,'YYYY') save_dt, '1' user_fm FROM dual\r\n"
				+ "				         UNION ALL\r\n"
				+ "				         SELECT TO_CHAR(SYSDATE,'YYYY') save_dt, '2' user_fm FROM dual\r\n"
				+ "				         UNION ALL\r\n"
				+ "				         SELECT TO_CHAR(add_months(sysdate,-12*1),'YYYY') save_dt, '1' user_fm FROM dual\r\n"
				+ "				         UNION ALL\r\n"
				+ "				         SELECT TO_CHAR(add_months(sysdate,-12*1),'YYYY') save_dt, '2' user_fm FROM dual\r\n"
				+ "				         UNION ALL\r\n"
				+ "				         SELECT TO_CHAR(add_months(sysdate,-12*2),'YYYY') save_dt, '1' user_fm FROM dual\r\n"
				+ "				         UNION ALL\r\n"
				+ "				         SELECT TO_CHAR(add_months(sysdate,-12*2),'YYYY') save_dt, '2' user_fm FROM dual\r\n"
				+ "				         UNION ALL\r\n"
				+ "				         SELECT TO_CHAR(add_months(sysdate,-12*3),'YYYY') save_dt, '1' user_fm FROM dual\r\n"
				+ "				         UNION ALL\r\n"
				+ "				         SELECT TO_CHAR(add_months(sysdate,-12*3),'YYYY') save_dt, '2' user_fm FROM dual\r\n"
				+ "				         UNION ALL\r\n"
				+ "				         SELECT TO_CHAR(add_months(sysdate,-12*4),'YYYY') save_dt, '1' user_fm FROM dual\r\n"
				+ "				         UNION ALL\r\n"
				+ "				         SELECT TO_CHAR(add_months(sysdate,-12*4),'YYYY') save_dt, '2' user_fm FROM dual\r\n"
				+ "				       ) a,\r\n"
				+ "					     (\r\n"
				+ "				         SELECT '충원' st, SUBSTR(enter_dt,1,4) AS save_dt, user_id, user_nm, user_pos, br_id, DECODE(INSTR(user_pos||user_work,'이사'),0,NVL(dept_out,dept_id),'0004') dept_id, loan_st, enter_dt, out_dt, user_work, SUBSTR(text_decrypt(user_ssn, 'pw'),7,1) user_fm, DECODE(NVL(loan_st,'0'),'1','1','2','1',DECODE(NVL(dept_out,dept_id),'0005','3','2')) loan_st_nm\r\n"
				+ "				         FROM   users \r\n"
				+ "				         WHERE  enter_dt >= TO_CHAR(add_months(sysdate,-12*4),'YYYY')||'0101'\r\n"
				+ "				         AND dept_id NOT IN ('8888','1000') AND NVL(dept_out,dept_id) NOT IN ('8888','1000') \r\n"
				+ "				         AND user_id NOT IN ('000177') AND NVL(user_work,'아마존카직원') NOT IN ('파견직원','에이전트','외부') AND id NOT LIKE 'develop%'\r\n"
				+ "				         UNION ALL \r\n"
				+ "				         SELECT '퇴사' st, SUBSTR(out_dt,1,4) AS save_dt,   user_id, user_nm, user_pos, br_id, DECODE(INSTR(user_pos||user_work,'이사'),0,NVL(dept_out,dept_id),'0004') dept_id, loan_st, enter_dt, out_dt, user_work, SUBSTR(text_decrypt(user_ssn, 'pw'),7,1) user_fm, DECODE(NVL(loan_st,'0'),'1','1','2','1',DECODE(NVL(dept_out,dept_id),'0005','3','2')) loan_st_nm\r\n"
				+ "				         FROM   users \r\n"
				+ "				         WHERE  out_dt >= TO_CHAR(add_months(sysdate,-12*4),'YYYY')||'0101'\r\n"
				+ "				         AND dept_id NOT IN ('8888','1000') AND NVL(dept_out,dept_id) NOT IN ('8888','1000') \r\n"
				+ "				         AND user_id NOT IN ('000177') AND NVL(user_work,'아마존카직원') NOT IN ('파견직원','에이전트','외부') AND id NOT LIKE 'develop%'\r\n"
				+ "				       ) b\r\n"
				+ "				WHERE a.save_dt=b.save_dt(+) AND a.user_fm=b.user_fm(+)       \r\n"
				+ "				GROUP BY ROLLUP (a.save_dt, a.user_fm)\r\n"
				+ "				ORDER BY GROUPING(a.save_dt), a.save_dt desc, a.user_fm";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gy2list_yeardate]"+e);
			System.out.println("[InsaCardDatabase:gy2list_yeardate]"+query);
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
	
	public Vector gy2list_in_yeardate(String save_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "SELECT b.cnt, a.user_fm,\r\n"
				+ "       a.cnt1, a.cnt2, a.cnt3, a.cnt4, a.cnt5, a.cnt6, a.cnt7, a.cnt8, \r\n"
				+ "       trunc(a.cnt1/b.cnt*100) per1, \r\n"
				+ "       trunc(a.cnt2/b.cnt*100) per2, \r\n"
				+ "       trunc(a.cnt3/b.cnt*100) per3, \r\n"
				+ "       trunc(a.cnt4/b.cnt*100) per4, \r\n"
				+ "       trunc(a.cnt5/b.cnt*100) per5, \r\n"
				+ "       trunc(a.cnt6/b.cnt*100) per6, \r\n"
				+ "       trunc(a.cnt7/b.cnt*100) per7, \r\n"
				+ "       trunc(a.cnt8/b.cnt*100) per8  \r\n"
				+ "FROM \r\n"
				+ "       (\r\n"
				+ "         SELECT DECODE(user_fm,'1','남','여') user_fm, \r\n"
				+ "                COUNT(DECODE(loan_st_nm,'내근직',user_id)) cnt1, \r\n"
				+ "                COUNT(DECODE(loan_st_nm,'외근직',user_id)) cnt2, \r\n"
				+ "                COUNT(DECODE(work_year,0,user_id)) cnt3, \r\n"
				+ "                COUNT(CASE WHEN work_year BETWEEN 1 AND 2 THEN user_id ELSE '' end) cnt4, \r\n"
				+ "                COUNT(CASE WHEN work_year BETWEEN 3 AND 4 THEN user_id ELSE '' end) cnt5, \r\n"
				+ "                COUNT(CASE WHEN work_year BETWEEN 5 AND 9 THEN user_id ELSE '' end) cnt6, \r\n"
				+ "                COUNT(CASE WHEN work_year BETWEEN 10 AND 50 THEN user_id ELSE '' end) cnt7, \r\n"
				+ "                COUNT(0) cnt8 \r\n"
				+ "         FROM \r\n"
				+ "         (\r\n"
				+ "            SELECT SUBSTR(save_dt,1,4) save_dt,     user_id, user_nm, user_pos, br_id, dept_id, loan_st, enter_dt, out_dt, user_work, user_fm, TO_NUMBER(work_year) work_year, loan_st_nm FROM stat_user where save_dt LIKE '%1231'\r\n"
				+ "            UNION ALL \r\n"
				+ "            SELECT TO_CHAR(SYSDATE,'YYYY') save_dt, user_id, user_nm, user_pos, br_id, dept_id, loan_st, enter_dt, out_dt, user_work, SUBSTR(text_decrypt(user_ssn, 'pw'),7,1) user_fm, TRUNC(MONTHS_BETWEEN(sysdate, TO_DATE(enter_dt, 'YYYYMMDD'))/12) work_year, DECODE(NVL(loan_st,'0'),'1','외근직','2','외근직','내근직') loan_st_nm FROM users WHERE use_yn='Y' AND dept_id NOT IN ('8888','1000') AND NVL(dept_out,dept_id) NOT IN ('8888','1000') AND user_id NOT IN ('000177') AND NVL(user_work,'아마존카직원') NOT IN ('파견직원','에이전트','외부') AND id NOT LIKE 'develop%'\r\n"
				+ "         )   \r\n"
				+ "         WHERE save_dt='"+save_dt+"'\r\n"
				+ "         GROUP BY user_fm\r\n"
				+ "         UNION all\r\n"
				+ "         SELECT '합계' user_fm, \r\n"
				+ "                COUNT(DECODE(loan_st_nm,'내근직',user_id)) cnt1, \r\n"
				+ "                COUNT(DECODE(loan_st_nm,'외근직',user_id)) cnt2, \r\n"
				+ "                COUNT(DECODE(work_year,0,user_id)) cnt3, \r\n"
				+ "                COUNT(CASE WHEN work_year BETWEEN 1 AND 2 THEN user_id ELSE '' end) cnt4, \r\n"
				+ "                COUNT(CASE WHEN work_year BETWEEN 3 AND 4 THEN user_id ELSE '' end) cnt5, \r\n"
				+ "                COUNT(CASE WHEN work_year BETWEEN 5 AND 9 THEN user_id ELSE '' end) cnt6, \r\n"
				+ "                COUNT(CASE WHEN work_year BETWEEN 10 AND 50 THEN user_id ELSE '' end) cnt7, \r\n"
				+ "                COUNT(0) cnt8 \r\n"
				+ "         FROM \r\n"
				+ "         (\r\n"
				+ "            SELECT SUBSTR(save_dt,1,4) save_dt,     user_id, user_nm, user_pos, br_id, dept_id, loan_st, enter_dt, out_dt, user_work, user_fm, TO_NUMBER(work_year) work_year, loan_st_nm FROM stat_user where save_dt LIKE '%1231'\r\n"
				+ "            UNION ALL \r\n"
				+ "            SELECT TO_CHAR(SYSDATE,'YYYY') save_dt, user_id, user_nm, user_pos, br_id, dept_id, loan_st, enter_dt, out_dt, user_work, SUBSTR(text_decrypt(user_ssn, 'pw'),7,1) user_fm, TRUNC(MONTHS_BETWEEN(sysdate, TO_DATE(enter_dt, 'YYYYMMDD'))/12) work_year, DECODE(NVL(loan_st,'0'),'1','외근직','2','외근직','내근직') loan_st_nm FROM users WHERE use_yn='Y' AND dept_id NOT IN ('8888','1000') AND NVL(dept_out,dept_id) NOT IN ('8888','1000') AND user_id NOT IN ('000177') AND NVL(user_work,'아마존카직원') NOT IN ('파견직원','에이전트','외부') AND id NOT LIKE 'develop%'\r\n"
				+ "         )   \r\n"
				+ "         WHERE save_dt='"+save_dt+"'\r\n"
				+ "         "
				+ "       ) a,\r\n"
				+ "       (\r\n"
				+ "         SELECT COUNT(0) cnt\r\n"
				+ "         FROM \r\n"
				+ "         (\r\n"
				+ "            SELECT SUBSTR(save_dt,1,4) save_dt,     user_id, user_nm, user_pos, br_id, dept_id, loan_st, enter_dt, out_dt, user_work, user_fm, TO_NUMBER(work_year) work_year, loan_st_nm FROM stat_user where save_dt LIKE '%1231'\r\n"
				+ "            UNION ALL \r\n"
				+ "            SELECT TO_CHAR(SYSDATE,'YYYY') save_dt, user_id, user_nm, user_pos, br_id, dept_id, loan_st, enter_dt, out_dt, user_work, SUBSTR(text_decrypt(user_ssn, 'pw'),7,1) user_fm, TRUNC(MONTHS_BETWEEN(sysdate, TO_DATE(enter_dt, 'YYYYMMDD'))/12) work_year, DECODE(NVL(loan_st,'0'),'1','외근직','2','외근직','내근직') loan_st_nm FROM users WHERE use_yn='Y' AND dept_id NOT IN ('8888','1000') AND NVL(dept_out,dept_id) NOT IN ('8888','1000') AND user_id NOT IN ('000177') AND NVL(user_work,'아마존카직원') NOT IN ('파견직원','에이전트','외부') AND id NOT LIKE 'develop%'\r\n"
				+ "         )   \r\n"
				+ "         WHERE save_dt='"+save_dt+"'\r\n"
				+ "       "
				+ "       ) b\r\n";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase:gy2list_in_yeardate(String save_dt)]"+e);
			System.out.println("[InsaCardDatabase:gy2list_in_yeardate(String save_dt)]"+query);
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

	//인사발령후 users 수정 - 2022-04-05	
	public int updateUserLoanSt(String user_id, String loan_st) 
	{
		
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";     
        int count = 0;   
        
        if (loan_st.equals("3")) loan_st = "";  //내근직인 경우 변경 
        
 		query = " UPDATE users SET loan_st =?  \n"
		        + "WHERE user_id =?  ";
   	   
       try{
    	   conn.setAutoCommit(false);
                        
            pstmt = conn.prepareStatement(query);

            pstmt.setString(1, loan_st);
            pstmt.setString(2, user_id);
                     
            count = pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

       } catch (SQLException e) {
			System.out.println("[InsaCardDatabase:updateUserLoanSt]\n"+e);
			System.out.println("[InsaCardDatabase:updateUserLoanSt]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();             
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
  
	//인사발령후 users 수정 - 2022-04-05	
	public int updateUserDeptId(String user_id, String dept_id) 
	{
			
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";     
	        int count = 0;                
	        String br_id = "";
	       	     	           
	        if ( dept_id.equals("0007")) { //부산지점
	        	br_id = "B1";
	        } else  if ( dept_id.equals("0008")) { //대전지점
	        	br_id = "D1";
	        } else  if ( dept_id.equals("0009")) { //강남지점 
	        	br_id = "S2";
	        } else  if ( dept_id.equals("0010")) { //광주지점
	        	br_id = "J1";
	        } else  if ( dept_id.equals("0011")) { //대구지점
	        	br_id = "G1";
	        } else  if ( dept_id.equals("0012")) { //인천지점
	        	br_id = "I1";			
	        } else  if ( dept_id.equals("0013")) { //수원지점
	        	br_id = "K3";		
	        } else  if ( dept_id.equals("0014")) { //강서지점
	        	br_id = "S3";		
	        } else  if ( dept_id.equals("0015")) { //구로지점->부천지점으로 명칭 변경 
	        	br_id = "S4"; 	
	        } else  if ( dept_id.equals("0017")) { //광화문지점
	        	br_id = "S5";		
	        } else  if ( dept_id.equals("0018")) { //송파지점
	        	br_id = "S6";		 			
	        } else {
	        	br_id = "S1";	
	        }
	  
	 		query = " UPDATE users SET br_id= ?, dept_id =?  \n"
			        + "WHERE user_id =?  ";
	   	   
	       try{
	    	    conn.setAutoCommit(false);
	                        
	            pstmt = conn.prepareStatement(query);

	            pstmt.setString(1, br_id);	
	            pstmt.setString(2, dept_id);
	            pstmt.setString(3, user_id);
	                     
	            count = pstmt.executeUpdate();
	             
	            pstmt.close();
	            conn.commit();

	       } catch (SQLException e) {
				System.out.println("[InsaCardDatabase:updateUserDeptId]\n"+e);
				System.out.println("[InsaCardDatabase:updateUserDeptId]\n"+query);
		  		e.printStackTrace();
		  		count = 0;
				conn.rollback();
		
			} finally {
				try{
					conn.setAutoCommit(true);
					if(rs != null) rs.close();             
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
	}
	
	/*
	 *	카드정산 프로시져 호출
	*/
	public String call_sp_make_pl_user(String s_year, String s_month, String gubun, String s_user)
	{
    	getConnection();
    	
    	String query = "{CALL P_MAKE_PLIT_USER (?,?,?,?,? )}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_year);
			cstmt.setString(2, s_month);
			cstmt.setString(3, gubun);
			cstmt.setString(4, s_user);			
			cstmt.registerOutParameter( 5, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값
			cstmt.close();				
	
		} catch (SQLException e) {
			System.out.println("[InsaCardDatabase::call_sp_make_pl_user]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
}