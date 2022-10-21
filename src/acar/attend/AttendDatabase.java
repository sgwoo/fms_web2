package acar.attend;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;

public class AttendDatabase
{
	private Connection conn = null;
	public static AttendDatabase db;
	
	public static AttendDatabase getInstance()
	{
		if(AttendDatabase.db == null)
			AttendDatabase.db = new AttendDatabase();
		return AttendDatabase.db;
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
	 *	Attend 전체조회(오늘날짜)
	 */
	public Vector getAttendToday(String s_kd, String t_wd, String dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" c.nm as dept_nm, a.user_nm, a.user_pos, a.user_id, a.team_nm,"+
		 		" decode(b.dt, '', '', SUBSTR(b.dt, 1, 4)||'-'||SUBSTR(b.dt, 5, 2)||'-'||SUBSTR(b.dt, 7, 2)) dt,"+
				" to_char(b.login_dt,'hh24:mi') as login_dt,"+
				" decode(nvl(b.ip_chk,''), '1','내부', '2','외부') ip_chk"+
				" from users a, attend b, code c "+
				" where a.use_yn='Y' and a.user_id=b.user_id and c.c_st='0002' and c.code=a.dept_id"+
				" and b.dt = '"+dt+"'";

		if(s_kd.equals("1"))							query += " and c.nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))						query += " and a.user_nm like '%"+t_wd+"%'";
                
		query += " order by a.dept_id, a.user_id";

		try {
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

		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getAttendToday]"+e);
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
	 *	Attend 사용자전체조회
	 */
	public Vector getAttendUser(String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.nm as dept_nm, a.user_nm, a.user_pos, a.user_id, a.team_nm"+
				" from users a, code b"+
				" where a.use_yn='Y' and b.c_st='0002' and b.code=a.dept_id and a.user_id<>'000035' and a.user_id<>'000000' ";

		if(s_kd.equals("1"))		query += " and b.nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and a.user_nm like '%"+t_wd+"%'";
                		
		query += " order by a.dept_id, a.user_id";

		try {

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

		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getAttendUser]"+e);
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
	 *	Attend 사용자전체조회
	 */
	public Vector getAttendUser2(String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.br_nm, b.nm as dept_nm, a.user_nm, a.user_pos, a.user_id, a.team_nm"+
				" from users a, code b, branch c"+
				" where a.use_yn='Y' and a.enter_dt is not null and b.c_st='0002' and b.code=a.dept_id and a.user_id not in ('000035', '000203' )  and a.dept_id not in ('1000','8888', '9999') and a.br_id=c.br_id  and a.USER_ID not in ('000003','000102', '000330')";// , '000177'

		if(s_kd.equals("1"))		query += " and b.nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and a.user_nm like '%"+t_wd+"%'";
                		
		query += " order by decode(a.user_pos,'대표이사',1, '이사', 2, '팀장',3,4), DECODE(a.user_id, '000004',1,'000005',2,'9'), decode(a.dept_id,'0004','0000','0020','0000',a.dept_id),  decode(a.user_id, '000237', '0', decode(a.user_pos, '팀장', 0, '부장', 1, '차장', 2, '과장',3,'대리', 4, 5)), a.user_id";

		try {

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

		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getAttendUser2]"+e);
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
     * Attend 사용자 개별 조회
     */
    public AttendBean getAttendUserDay(String user_id, String year, String month, String day)
	{
		getConnection();        
        AttendBean ab = new AttendBean();
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";

		query = " select decode(b.sch_chk, '',to_char(a.login_dt,'hh24:mi'), '1',to_char(a.login_dt,'hh24:mi'), '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직','9','포상휴가') ||  decode(b.gj_ck, 'N', '예정', '')  as login_dt,"+//||decode(b.work_id,'','','대체업무자:'||e.user_nm)
				" decode(nvl(a.ip_chk,''), '','', '1','내부', '2','외부', '3', '모바일') ip_chk, nvl( b.title, decode( b.sch_chk, '', '', '2', '현지출근', '3', '연차', '4', '출산휴가', '5', '병가', '6', '경조사', '7', '공가', '8', '휴직', '9','포상휴가' )) || decode( b.work_id,	   '', '', ' (대체업무자:' || e.user_nm || ')' ) AS title, "+
                " decode(b2.user_id,'','','[재택근무] ')||a.remark as remark,  b.content , "+
		    	"  to_char(a.logout_dt,'hh24:mi')  logout_dt " +
				" from attend a, "+
					"( select work_id, user_id, title, content, sch_chk, gj_ck from sch_prv where sch_chk not in ('1','0') and start_year='"+year+"' and start_mon='"+month+"' and start_day='"+day+"') b,"+
					"( select work_id, user_id, title, content, sch_chk, gj_ck from sch_prv where sch_chk ='0' and start_year='"+year+"' and start_mon='"+month+"' and start_day='"+day+"') b2,"+
					"( select hday, hday_nm from holiday where hday = '"+year+month+day+"') c, users e"+
				" where a.user_id='"+user_id+"' and a.dt='"+year+month+day+"' and a.user_id=b.user_id(+) and a.user_id=b2.user_id(+) and a.dt=c.hday(+) and b.work_id=e.user_id(+)";


		try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
            
			if(rs.next()){
			    ab.setLogin_dt(rs.getString("LOGIN_DT"));
			    ab.setLogout_dt(rs.getString("LOGOUT_DT"));
			    ab.setIp_chk(rs.getString("IP_CHK"));		    
			    ab.setTitle(rs.getString("TITLE"));		    
			    ab.setContent(rs.getString("CONTENT"));		
			    ab.setRemark(rs.getString("REMARK"));		    
			}
			rs.close();
			stmt.close();

        }catch(SQLException e){
			System.out.println("[AttendDatabase:getAttendUserDay]"+e);
	  		e.printStackTrace();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
        }
        return ab;
    }

/**
     * Attend 사용자 개별 조회(업무스케줄에서)
     */
    public AttendBean getAttendUserPrv(String user_id, String year, String month, String day)
	{
		getConnection();        
        AttendBean ab2 = new AttendBean();
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";


		query = " select decode(a.sch_chk, '','', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9', '포상휴가') ||  decode(a.gj_ck, 'N', '예정', '')  as login_dt, nvl(a.title, decode(a.sch_chk, '','', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','훈련', '8','휴직'))||decode(a.work_id,'','',' (대체업무자:'||b.user_nm||')') as title, a.content"+
				" from sch_prv a, users b"+
				" where a.user_id='"+user_id+"' and a.sch_chk not in ('1','0') and a.start_year='"+year+"' and a.start_mon='"+month+"' and a.start_day='"+day+"' and a.work_id=b.user_id(+)";

		
		try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
			if(rs.next()){
			    ab2.setLogin_dt(rs.getString("LOGIN_DT"));
			    ab2.setTitle(rs.getString("TITLE"));		    
			    ab2.setContent(rs.getString("CONTENT"));		    
			}
			rs.close();
			stmt.close();
				
        }catch(SQLException e){
			System.out.println("[AttendDatabase:getAttendUserPrv]"+e);
	  		e.printStackTrace();
        }finally{
            try{
	            if ( stmt != null )	stmt.close();
	            if ( rs != null )	rs.close();
			 
            }catch(SQLException _ignored){}
			closeConnection();
        }
        return ab2;
    }


	/**
     * Attend 사용자 개별 조회(업무스케줄에서)1
     */
    public Sch_prvBean getAttendUserPrv1(String user_id, String year, String month, String day)
	{
		getConnection();        
        Sch_prvBean ab2 = new Sch_prvBean();
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";

		
		query = " select decode(a.sch_chk, '','','1','', '2','', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상휴가') as login_dt, nvl(a.title, decode(a.sch_chk,'','','1','', '2','', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','훈련', '8','휴직'))||decode(a.work_id,'','',' (대체업무자:'||b.user_nm||')') as title, a.content"+
				" from sch_prv a, users b"+
				" where a.user_id='"+user_id+"' and a.sch_chk <> '1' and a.start_year='"+year+"' and a.start_mon='"+month+"' and a.start_day='"+day+"' and a.work_id=b.user_id(+)";

        try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
			if(rs.next()){
			   // ab2.setLogin_dt(rs.getString("LOGIN_DT"));
			    ab2.setTitle(rs.getString("TITLE"));		    
			    ab2.setContent(rs.getString("CONTENT"));
				ab2.setSch_chk(rs.getString("SCH_CHK"));
			}
			rs.close();
			stmt.close();
				
        }catch(SQLException e){
			System.out.println("[AttendDatabase:getAttendUserPrv]"+e);
	  		e.printStackTrace();
        }finally{
            try{
	            if ( stmt != null )	stmt.close();
	            if ( rs != null )	rs.close();
			 
            }catch(SQLException _ignored){}
			closeConnection();
        }
        return ab2;
    }
    
	/**
     * Attend 사용자 개별 조회(업무스케줄에서)2
     */
	public Sch_prvBean getAttendUserPrv2(String user_id, String year, String month, String day)
	{
		getConnection();        
        Sch_prvBean ab2 = new Sch_prvBean();
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";

		query = " select decode(a.sch_chk, '','','1','', '2','', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상휴가') as title, a.content, a.start_year, a.start_mon, a.start_day, a.sch_chk"+
				" from sch_prv a, users b"+
				" where a.user_id='"+user_id+"' and a.sch_chk <> '1' and a.sch_chk <> '2' and a.start_year='"+year+"' and a.start_mon='"+month+"' and a.start_day='"+day+"' and a.work_id=b.user_id(+)";
//		System.out.println(month);
        try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
			if(rs.next()){
			   // ab2.setLogin_dt(rs.getString("LOGIN_DT"));
			    ab2.setTitle(rs.getString("TITLE"));		    
			    ab2.setContent(rs.getString("CONTENT"));
				ab2.setSch_chk(rs.getString("SCH_CHK"));
				ab2.setStart_mon(rs.getString("START_MON"));
			}
			rs.close();
			stmt.close();
				
        }catch(SQLException e){
			System.out.println("[AttendDatabase:getAttendUserPrv2]"+e);
	  		e.printStackTrace();
        }finally{
            try{
	            if ( stmt != null )	stmt.close();
	            if ( rs != null )	rs.close();
			 
            }catch(SQLException _ignored){}
			closeConnection();
        }
        return ab2;
    }





	/**
	 *	Attend 사용자의 업무일지 조회
	 */
	public Hashtable getAttendUserPrvContent(String user_id, String year, String month, String day)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select seq, decode(sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상휴가', '0','재택근무') as sch_chk, title, content, work_id"+
				" from sch_prv "+
				" where user_id='"+user_id+"' and start_year='"+year+"' and start_mon='"+month+"' and start_day='"+day+"'"+
				" order by seq";
				
		try {
				pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery();
	    							  
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
		        pstmt.close();
			} catch (SQLException e) {
				System.out.println("[AttendDatabase:getAttendUserPrvContent]\n"+e);			
				System.out.println("[AttendDatabase:getAttendUserPrvContent]\n"+query);			
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
		

	/**
	 *	업무일지관리 리스트
	 */
	public Vector getUserPrvContent(String s_brch_id, String s_dept_id, String s_user_id, String s_year, String s_month, String s_day)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.seq, decode(a.sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상휴가', '0','재택근무') as sch_chk,"+
				" a.user_id, b.user_nm, b.dept_id, a.title, a.content, a.start_year||'-'||a.start_mon||'-'||a.start_day AS dt, a.work_id"+
				" from sch_prv a, users b where a.user_id=b.user_id";

		if(!s_brch_id.equals(""))		query += " and b.br_id='"+s_brch_id+"'";
		if(!s_dept_id.equals(""))		query += " and b.dept_id='"+s_dept_id+"'";
		if(!s_user_id.equals(""))		query += " and a.user_id='"+s_user_id+"'";
		if(!s_year.equals(""))		query += " and a.start_year='"+s_year+"'";
		if(!s_month.equals(""))		query += " and a.start_mon='"+s_month+"'";
		if(!s_day.equals(""))			query += " and a.start_day='"+s_day+"'";

		query += " order by b.br_id, b.dept_id, b.user_nm, a.start_year, a.start_mon, a.start_day, a.seq";
		try {
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

		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getUserPrvContent]"+e);
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
	 *	업무일지관리 리스트2 seq추가 Yongsoon Kwon. 20040921.
	 */
	public Vector getUserPrvContent2(String s_brch_id, String s_dept_id, String s_user_id, String s_year, String s_month, String s_day, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.seq, decode(a.sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상휴가', '0','재택근무') as sch_chk,"+
				" a.user_id, b.user_nm, b.dept_id, a.title, a.content, a.start_year||'-'||a.start_mon||'-'||a.start_day AS dt, a.work_id"+
				" from sch_prv a, users b where a.user_id=b.user_id";

		if(!s_brch_id.equals(""))		query += " and b.br_id='"+s_brch_id+"'";
		if(!s_dept_id.equals(""))		query += " and b.dept_id='"+s_dept_id+"'";
		if(!s_user_id.equals(""))		query += " and a.user_id='"+s_user_id+"'";
		if(!s_year.equals(""))			query += " and a.start_year='"+s_year+"'";
		if(!s_month.equals(""))			query += " and a.start_mon='"+s_month+"'";
		if(!s_day.equals(""))			query += " and a.start_day='"+s_day+"'";
		if(!seq.equals(""))				query += " and a.seq = '" + seq + "' ";

		query += " order by b.br_id, b.dept_id, b.user_nm, a.start_year, a.start_mon, a.start_day, a.seq";
		try {
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

		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getUserPrvContent2]"+e);
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

	// 공휴일관리--------------------------------------------------------------------------------------------

	/**
	 *	휴일명
	 */
	 
	public String getHoliday(String hday)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String hday_nm = "";
		String query = "";

		query = " select nvl(hday_nm, '-') hday_nm from holiday where hday='"+hday+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next()){
				hday_nm = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getHoliday]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return hday_nm;
		}
	}	
	 
	/* 휴일여부 */ 
	public int getHolidayCnt(String hday)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int hday_cnt = 0;
		String query = "";

		query = " select count(*) from holiday where hday=replace('"+hday+"' , '-', '') ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next()){
				hday_cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getHolidayCnt]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return hday_cnt;
		}
	}	

	/**
	 *	공휴일 리스트
	 */
	public Vector getHolidayList(String s_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
		 		" decode(hday, '', '', SUBSTR(hday, 1, 4)||'-'||SUBSTR(hday, 5, 2)||'-'||SUBSTR(hday, 7, 2)) hday, hday_nm, seq"+				
				" from holiday";

		if(!s_year.equals(""))	query += " where substr(hday,0,4) = '"+s_year+"'";

                
		query += " order by hday";

		try {

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

		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getHolidayList]"+e);
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
	 *	공휴일 등록
	 */
	public boolean insertHoliday(int seq, String hday, String hday_nm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2= null;
		ResultSet rs = null;
		int max_seq = 0;

		String query2 = "select max(seq)+1 from holiday";

		String query =  " insert into holiday (seq, hday, hday_nm)"+
						" values (?, replace('"+hday+"', '-', ''), '"+hday_nm+"')";			

		try 
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query2);
	    	rs = pstmt2.executeQuery();
			if(rs.next()){
				max_seq = rs.getInt(1);
			}
            rs.close();
            pstmt2.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, max_seq);		
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AttendDatabase:insertHoliday]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	공휴일 수정
	 */
	public boolean updateHoliday(int seq, String hday, String hday_nm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "update holiday set hday=replace('"+hday+"', '-', ''), hday_nm='"+hday_nm+"' where seq="+seq;			

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		    pstmt.executeUpdate();
			pstmt.close();
		    
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[AttendDatabase:updateHoliday]"+e);
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
	 *	공휴일 삭제
	 */
	public boolean deleteHoliday(int seq, String hday, String hday_nm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "delete from holiday where seq="+seq;			

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AttendDatabase:deleteHoliday]"+e);
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
     * 사유 .
     */
    public int updateRemark(AttendBean bean)
    {
		getConnection();
		
        PreparedStatement pstmt = null;
        String query = "";
     
        int count = 0;
                
        query="UPDATE attend SET remark=?\n"
		        + "WHERE USER_ID=? and dt= ?";
 
       try{
            conn.setAutoCommit(false);
                       
            pstmt = conn.prepareStatement(query);
            
            pstmt.setString(1, bean.getRemark().trim());
            pstmt.setString(2, bean.getUser_id().trim());
            pstmt.setString(3, bean.getDt());
                
            count = pstmt.executeUpdate();
            
			conn.commit(); 
            pstmt.close();
        
        } catch (Exception e) {
			System.out.println("[AttendDatabase:updateRemark]"+e);
			e.printStackTrace();
	  	//	flag = false;
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
	
	//당일 출근시간 조회
	public String getAttendDate(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String login_dt = "";
		String query = "";

		query = " select login_dt from attend where to_char(login_dt,'YYYYMMDD')=to_char(sysdate,'YYYYMMDD') and user_id='"+user_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next()){
				login_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getAttendDate]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return login_dt;
		}
	}	
	
	
		//평균 출근시간 조회
	public String getAvgAttendDate(String user_id, String yy, String mm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String login_dt = "";
		String query = "";

		
		query = " 	select to_char(trunc(sysdate)+ss/24/3600,'hh24:mi') \n" +
					 "		from ( select avg((a.login_dt-trunc(a.login_dt))*24*3600) ss from \n" +
					 "		( select a.login_dt from  \n" +
				    "			     ( select  a.user_id, a.login_dt, a.dt from attend a ,	 (select hday, hday_nm from holiday ) c \n" +
					 "		            where a. user_id='"+user_id+"' and a.dt like'"+ yy+ mm + "%'   \n" + 
					 "		             and a.dt = c.hday(+) and c.hday_nm is null \n" +
					 "		              and to_char(a.login_dt, 'D')  NOT IN ('1','7') ) a  \n" +
					 "		     minus    \n" +
					 "		     select a.login_dt from  \n" +
					 "		     ( select  a.user_id, a.login_dt, a.dt from attend a ,	 (select hday, hday_nm from holiday ) c \n" +
					 "		            where a. user_id='"+user_id+"' and a.dt like '" + yy + mm + "%' \n" +
					 "		             and a.dt = c.hday(+) and c.hday_nm is null \n" +
					 "		              and to_char(a.login_dt, 'D')  NOT IN ('1','7') ) a ,  \n" +
					 "		      ( select  start_year, start_mon, start_day, sch_chk \n" +
					 "		      from sch_prv where   user_id='"+user_id+"' ) b \n" +
					 "		     where  a.dt = b.start_year||b.start_mon||b.start_day  \n" +
					 "		)  a   \n" +
					 "		)  ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next()){
				login_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getAvgAttendDate]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return login_dt;
		}
	}	
		
	/**
	 *	재택근무현황
	 */
	public Vector getHomeWorkStat(String s_yy, String s_mm, int s_days, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		String s_ym = s_yy+""+s_mm;
		
		
		query = " select c.br_nm, b.nm as dept_nm, a.dept_id, a.user_nm, a.user_pos, a.user_id, a.team_nm, a.loan_st, ";
		
				
		for (int i = 0 ; i < s_days ; i++){
				query += " MIN(DECODE('"+s_ym+""+AddUtil.addZero2(i+1)+"',e.hday,'R2',d.dte,DECODE(d.d,7,'R',1,'R','W'))) h_dy"+(i+1)+", MIN(DECODE('"+s_ym+""+AddUtil.addZero2(i+1)+"',f.prv_dt,DECODE(f.title,'재택근무','B','Y'))) p_dy"+(i+1)+", \n";
		}
		
		
		query += " 0 ends\r\n"
				+ "from   users a, code b, branch c,\r\n"
				//+ "       --한달치\r\n"
				+ "       ( SELECT TO_CHAR(TO_DATE('"+s_ym+"01','YYYYMMDD')-1+LEVEL, 'YYYYMMDD') dte,\r\n"
				+ "                TO_CHAR(TO_DATE('"+s_ym+"01','YYYYMMDD')-1+LEVEL, 'D') d\r\n"
				+ "         FROM dual\r\n"
				+ "         CONNECT BY LEVEL <= "+s_days+"\r\n"
				+ "       ) d,         \r\n"
				//+ "       --공휴일\r\n"
				+ "       ( SELECT * FROM holiday WHERE hday LIKE '"+s_ym+"%') e,\r\n"
				//+ "       --연차&재택근무\r\n"
				+ "       ( SELECT user_id, start_year||start_mon||start_day AS prv_dt, decode(sch_chk, '3','연차', '4','출산휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상휴가', '0','재택근무') as title \r\n"
				+ "         from   sch_prv \r\n"
				+ "         WHERE sch_chk NOT IN ('1','2') AND start_year='"+s_yy+"' AND start_mon='"+s_mm+"' AND NVL(gj_ck,'Y') ='Y' \r\n"
				+ "       ) f\r\n"
				+ "where  a.use_yn='Y' and a.enter_dt is not null  \r\n"
				+ "and a.dept_id not in ('1000','8888', '9999')   \r\n"//--에이전트,외부업체,퇴사자
				+ "and a.USER_ID not in ('000003','000035', '000330' , '000203') \r\n"//--임원,개발자, 사용자(감사용)
				+ "and b.c_st='0002' and b.code=a.dept_id\r\n"
				+ "and a.br_id=c.br_id\r\n"
				+ "AND d.dte=e.hday(+)\r\n"
				+ "AND a.user_id=f.user_id(+)";

		if(s_kd.equals("1"))		query += " and b.nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and a.user_nm like '%"+t_wd+"%'";
		
		query += " GROUP BY c.br_nm, b.nm, a.dept_id, a.user_nm, a.user_pos, a.user_id, a.team_nm, a.loan_st \n";
                		
		query += " order by decode(a.user_pos,'대표이사',1, '이사', 2, '팀장',3,4), "+
						" DECODE(a.user_id, '000004',1,'000005',2,'9'), "+
						" decode(a.dept_id,'0004','0000','0020','0000',a.dept_id), "+
						" decode(a.loan_st,'',a.team_nm), "+
						" decode(a.user_id, '000237', '0', decode(a.user_pos, '팀장', 0, '부장', 1, '차장', 2, '과장',3,'대리', 4, 5)), "+
						" a.user_id";

		try {

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
            
            //System.out.println("[AttendDatabase:getHomeWorkStat]"+query);

		} catch (SQLException e) {
			System.out.println("[AttendDatabase:getHomeWorkStat]"+e);
			System.out.println("[AttendDatabase:getHomeWorkStat]"+query);
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
