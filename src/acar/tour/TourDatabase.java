/**
 * 장기근속자  포상 
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2010. 06. 10
 * @ last modify date : 
 */

package acar.tour;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;


public class TourDatabase
{
	private Connection conn = null;
	public static TourDatabase db;
	
	public static TourDatabase getInstance()
	{
		if(TourDatabase.db == null)
			TourDatabase.db = new TourDatabase();
		return TourDatabase.db;
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
	 *	 전체조회 
	 */

	
	public Vector Member_list(String user_id, String s_kd, String t_wd, String yes)
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
         				+ "a.USER_POS, substr(to_char(sysdate,'yyyymmdd'),1,8) as to_day, a.ENTER_DT, \n"
						+ "to_char(add_months( a.ENTER_DT, 60 ), 'YYYYMMDD') AS year5, to_char(add_months( a.ENTER_DT, 132 ), 'YYYYMMDD') AS year11, to_char(add_months( a.ENTER_DT, 216 ), 'YYYYMMDD') AS year18, to_char(add_months( a.ENTER_DT, 300 ), 'YYYYMMDD') AS year25, to_char(add_months( a.ENTER_DT, 384 ), 'YYYYMMDD') AS year32, TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) YEAR,  \n"
						+ " substr( to_char( sysdate, 'YYYYMMDD' ), 1, 4 ) - substr( to_char(add_months( a.ENTER_DT, '60' ), 'YYYYMMDD' ), 1, 4 ) AS N_YEAR5, \n"
					    + " substr( to_char( sysdate, 'YYYYMMDD' ), 1, 4 ) - substr( to_char( add_months( a.ENTER_DT, '132' ), 'YYYYMMDD' ), 1, 4 ) AS N_YEAR11, \n"
						+ " substr( to_char( sysdate, 'YYYYMMDD' ), 1, 4 ) - substr( to_char( add_months( a.ENTER_DT, '216' ), 'YYYYMMDD' ), 1, 4 ) AS N_YEAR18, \n"
						+ " substr( to_char( sysdate, 'YYYYMMDD' ), 1, 4 ) - substr( to_char( add_months( a.ENTER_DT, '300' ), 'YYYYMMDD' ), 1, 4 ) AS N_YEAR25, \n"						
						 + "to_char(sysdate,'YYYYMMdd' ) to_day,\n"
				+ " p.year5_c, p.year11_c, p.year18_c, p.year25_c  \n"	
		        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, \n" 
		        		+"   ( select  user_id, sum(year5)  year5_c, sum(year11) year11_c, sum(year18) year18_c, sum(year25) year25_c \n"
				+"	    from  ( select user_id, decode(ps_count, 5, 1, 0 )  year5, decode(ps_count, 11, 1 , 0)  year11, decode(ps_count, 18, 1, 0 )  year18, decode(ps_count, 25, 1 , 0)  year25  from ps_box \n"
				+"	      ) group by user_id  order by user_id  ) p	\n"	    	
				+ "where a.BR_ID = b.BR_ID \n"
        				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','부장','팀장', '차장', '과장','대리','사원','인턴사원')  and a.user_id = p.user_id(+)  and a.dept_id not in ('1000')  \n";					
		query += "  and nvl(a.use_yn,'Y')='Y' and a.user_id not in ('000003', '000102' , '000035', '000177') and a.id not like 'devel%' ";

		if(s_kd.equals("1"))			query += " and a.user_nm like '%"+t_wd+"%'\n";	
		

		query += "order by decode(a.user_pos,'대표이사',1, '이사',2, '팀장',4,5), decode(a.user_id,'000004',1,'000005', 2, 3,4), decode(a.dept_id,'0020','0000',a.dept_id),   decode(a.user_id, '000237', '0', decode(a.user_pos, '팀장', 0, '부장', 1, '차장', 2, '과장',3,'대리', 4, 5)), a.user_id  ";



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
			System.out.println("[TourDatabase:Member_list]"+e);
			System.out.println("[TourDatabase:Member_list]"+query);
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

//1차
public Vector Member_list1(String user_id, String s_kd, String t_wd, String yes)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			 query =   " SELECT a.USER_ID, a.BR_ID, b.BR_NM, a.USER_POS,  a.USER_NM, a.DEPT_ID, c.NM AS DEPT_NM,  a.ENTER_DT, NVL(d.PS_COUNT,'0') AS PS_COUNT, \n"
						+ " substr( to_char( add_months(sysdate, 1), 'YYYYMMDD' ), 1, 6 ) - substr( to_char(add_months( a.ENTER_DT, '60' ), 'YYYYMMDD' ), 1, 6 ) AS day5, \n"
         				+ " substr(to_char(sysdate,'yyyymmdd'),1,8) as to_day, \n"
						+ " to_char(add_months( a.ENTER_DT, 60 ), 'YYYYMMDD') AS year5,  \n"
						+ " TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(a.enter_dt, 'YYYYMMDD'))/12) YEAR,  \n"
						+ " substr( to_char( sysdate, 'YYYYMMDD' ), 1, 4 ) - substr( to_char(add_months( a.ENTER_DT, '60' ), 'YYYYMMDD' ), 1, 4 ) AS to_day, \n"
						+ " substr( to_char( sysdate, 'YYYYMMDD' ), 1, 4 ) - substr( to_char(add_months( a.ENTER_DT, '60' ), 'YYYYMMDD' ), 1, 4 ) AS N_YEAR5 \n"
		        		+ " FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c , (SELECT USER_ID,PS_COUNT, MAX(PS_DT) PS_DT  FROM ps_box  WHERE PS_COUNT = '1' GROUP BY USER_ID, PS_COUNT) d \n"
						+ " where a.BR_ID = b.BR_ID and a.user_id = d.user_id(+) \n"
        				+ " and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','이사','부장','팀장','차장', '과장','대리','사원','인턴사원')\n";
					
					query += "  and nvl(a.use_yn,'Y')='Y' and a.user_id not in ('000003', '000102')";

		if(s_kd.equals("1"))			query += " and a.user_nm like '%"+t_wd+"%'\n";	
		

		query += "order by decode(a.user_pos,'대표이사',1, '이사',2,  '팀장',4,5), decode(a.user_id,'000004',1,'000005', 2, 3,4), a.dept_id, decode(a.user_pos ,'부장',0, '차장', 1, '과장',2,'대리',3,4), a.user_id  ";




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
			System.out.println("[TourDatabase:Member_list1]"+e);
			System.out.println("[TourDatabase:Member_list1]"+query);
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





//포상조회
	public Vector tour_view(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select user_id, seq, ps_dt, ps_content, ps_str_dt, ps_end_dt,  '근속포상'  as gubun, ps_amt, ps_count  from ps_box where USER_ID = '"+ user_id +"' order by to_number(ps_count) asc " ;

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
			System.out.println("[TourDatabase:tour_view]"+e);
			System.out.println("[TourDatabase:tour_view]"+query);
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

	//포상조회 입사5년차
	public Vector tour_view5(String user_id, String year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select decode(b.start_date, a.ps_str_dt, decode(b.end_date, a.ps_end_dt, 'Y','N'),'N') as YN, to_number(b.end_date - b.start_date )+1 as datea1, to_number(a.ps_end_dt - a.ps_str_dt )+1 as datea2, a.user_id, a.seq, a.ps_dt, a.ps_content, a.ps_str_dt, a.ps_end_dt, decode( a.ps_gubun, 2, '근로포상' ) AS gubun, a.ps_amt, b.* "+
				" from ps_box a, free_time b where a.USER_ID = b.USER_ID and a.PS_STR_DT = b.START_DATE and a.USER_ID = '"+ user_id +"' and a.ps_count = '"+year+"' and b.SCH_CHK = '9' ";

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
			System.out.println("[TourDatabase:tour_view5]"+e);
			System.out.println("[TourDatabase:tour_view5]"+query);
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




	//포상조회 입사25년차
	public Vector tour_view25(String user_id, String year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select decode(b.start_date, a.ps_str_dt, decode(b.end_date, a.ps_end_dt, 'Y','N'),'N') as YN, to_number(b.end_date - b.start_date )+1 as datea1, to_number(a.ps_end_dt - a.ps_str_dt )+1 as datea2, a.user_id, a.seq, a.ps_dt, a.ps_content, a.ps_str_dt, a.ps_end_dt, decode( a.ps_gubun, 2, '근로포상' ) AS gubun, a.ps_amt, b.* "+
				" from ps_box a, free_time b where a.USER_ID = b.USER_ID and a.PS_STR_DT = b.START_DATE and a.USER_ID = '"+ user_id +"' and a.ps_count = '"+year+"' and b.SCH_CHK = '9' ";

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
			System.out.println("[TourDatabase:tour_view25]"+e);
			System.out.println("[TourDatabase:tour_view25]"+query);
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

	public Vector InsaCardUserList(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.USER_ID,a.BR_ID,b.BR_NM,a.USER_NM,a.ID,a.USER_PSD,a.USER_CD,a.USER_SSN,a.DEPT_ID,c.NM AS DEPT_NM,"+
				" a.USER_H_TEL,a.USER_M_TEL,a.IN_TEL,a.HOT_TEL,a.USER_EMAIL,a.USER_POS,a.USER_AUT,a.LIC_NO,a.LIC_DT, nvl(a.ENTER_DT,'99999999') enter_dt,"+
				" a.content,a.filename,a.zip,a.addr, a.mail_id, d.passwd as mail_pw,"+
				" a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax ,a.taste, a.special, to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(a.enter_dt,'YYYYMMDD')+1 as w_day, a.gundea, decode(substr(a.user_ssn, 7,1), '1','남','2','여', '3','남','4','여') as jumin, a.bank_nm, a.bank_no, a.user_nm as bank_user\n"
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
			System.out.println("[TourDatabase:InsaCardUserList]"+e);
			System.out.println("[TourDatabase:InsaCardUserList]"+query);
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
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) YEAR,  "+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')) -  "+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) * 12) MONTH,  "+
				"					TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(enter_dt, 'YYYYMMDD')) -  "+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')))) * 30.5) DAY, "+
				" 					   user_id, br_id, decode(br_id,'S1','본사','B1','부산지점','D1','대전지점','') br_nm,   "+
				"					   dept_id, decode(dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0005','IT팀','0007','부산지점','0008','대전지점','0009','강남지점','0010','광주지점','0011','대구지점','0012','인천지점','0014','강서지점','0015','구로지점','0016','울산지점','0017','광화문지점','0018','송파지점') dept_nm,   "+
				"					   user_pos,user_nm, enter_dt   "+
				"			from users where use_yn='Y' and user_pos in  ('팀장', '이사','부장', '차장', '과장', '대리', '사원') ) b,  "+
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
				" where b.USER_ID='" + user_id +"' and b.user_id=c.user_id(+) and b.user_id=d.user_id(+) and b.dept_id in ('0001','0002','0003','0004','0006','0007','0008','0005','1000','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018') "+
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
			System.out.println("[TourDatabase:getVacationAll2()]"+e);
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
	 *	포상 입력하기
	 */
	
public int insertPs(TourBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		int count = 0;
		String query = "";
		String query_seq = "";

		int seq = 0;

 	  	query_seq = "select nvl(max(seq)+1, 1) from ps_box where user_id = '" + bean.getUser_id() + "'  ";	

		query = " insert into ps_box \n"+
				" (user_id, seq, ps_dt, ps_gubun, ps_content, ps_str_dt, ps_end_dt, ps_amt, ps_count , jigub \n"+
				" ) values ("+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "+
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
			pstmt.setString(3, bean.getPs_dt());
			pstmt.setString(4, bean.getPs_gubun());
			pstmt.setString(5, bean.getPs_content());
			pstmt.setString(6, bean.getPs_str_dt());
			pstmt.setString(7, bean.getPs_end_dt());
			pstmt.setString(8, bean.getPs_amt());
			pstmt.setString(9, bean.getPs_count());
			pstmt.setString(10, bean.getJigub());
			
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[TourDatabase:insertPs]\n"+e);
			System.out.println("[TourDatabase:insertPs]\n"+query);
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
	 *	 삭제는 없고 휴가일 사용을 clear - 휴가금액을 이미 지급 받았기에 일자  clear로  처리 
	 */

public int tour_del(TourBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";


		query = " update  FROM ps_box set ps_start_dt = null, ps_end_dt = null \n"+
				" where user_id=? and seq=?";		

		try 
		{	
			conn.setAutoCommit(false);		
		
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getUser_id());
			pstmt.setInt(2, bean.getSeq());
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[TourDatabase:tour_del]\n"+e);
			System.out.println("[TourDatabase:tour_del]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


public Vector tourlist(String s_kd, String t_wd, String yes, int st_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

				 query = " select a.USER_ID, a.BR_ID, b.BR_NM, a.USER_NM, "+
						 " e.nm as DEPT_NM, \n "+	
						 " a.USER_POS, a.ENTER_DT, substr( to_char( sysdate, 'yyyymmdd' ), 1, 8 ) AS to_day, \n "+
						 "  to_number("+st_year+" - substr( a.ENTER_DT, 1, 4 )) AS year, \n "+			
						 " to_number(c.PS_COUNT) ps_count , c.PS_DT as PS_STR_DT  \n"+
         				 " FROM USERS a, BRANCH b,  (select a.* from ps_box a, (select user_id, max(to_number(ps_count)) ps_count from ps_box where ps_dt like to_char('"+st_year+"%')  group by user_id) b where a.user_id = b.user_id and a.ps_count = b.ps_count ) c,  \n "+
         				 "  ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) e \n"+
				 " WHERE a.BR_ID = b.BR_ID and a.USER_ID = c.USER_ID(+)  and a.dept_id = e.code "+
        				"  and a.user_pos in ('대표이사','이사','부장','팀장','차장', '과장','대리','사원','인턴사원') \n" +
				"  and nvl(a.use_yn,'Y')='Y' and a.user_id not in ('000003', '000102', '000035', '000177') and  a.id not like 'devel%'\n" +
				"  and to_number("+st_year+" - substr( a.ENTER_DT, 1, 4 )) in ('5','11','18','25') ";

		if(s_kd.equals("1"))			query += " and a.user_nm like '%"+t_wd+"%'\n";


		query += "order by decode(a.user_pos,'대표이사',1, '이사',2, '부장',3, '팀장',4,5), a.enter_dt  ";

    //    System.out.println("query="+query);

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
			System.out.println("[TourDatabase:tourlist]"+e);
			System.out.println("[TourDatabase:tourlist]"+query);
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