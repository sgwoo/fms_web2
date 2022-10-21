/**
 * 고객지원업무스케쥴
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2002. 3. 4
 * @ last modify date : 
 */
package acar.schedule;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.io.*;
import acar.car_sche.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class ScheduleDatabase {

    private static ScheduleDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized ScheduleDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new ScheduleDatabase();
        return instance;
    }
    
    private ScheduleDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

	/**
     * 일정등록 ( 2001/12/28 ) - Kim JungTae
     */
    private CarScheBean makeCarScheBean(ResultSet results) throws DatabaseException {

        try {
            CarScheBean bean = new CarScheBean();

		    bean.setUser_id(results.getString("USER_ID"));
			bean.setUser_nm(results.getString("USER_NM"));
			bean.setSeq(results.getInt("SEQ"));
			bean.setStart_year(results.getString("START_YEAR"));
			bean.setStart_mon(results.getString("START_MON"));
			bean.setStart_day(results.getString("START_DAY"));
			bean.setTitle(results.getString("TITLE"));
			bean.setContent(results.getString("CONTENT"));
			bean.setReg_dt(results.getString("REG_DT"));
			bean.setSch_kd(results.getString("SCH_KD"));
			bean.setSch_chk(results.getString("SCH_CHK"));
			bean.setWork_id(results.getString("work_id"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 년월간 일정등록 ( 2001/12/28 ) - Kim JungTae
     */
    private YMScheBean makeYMScheBean(ResultSet results) throws DatabaseException {

        try {
            YMScheBean bean = new YMScheBean();

		    bean.setUser_id(results.getString("USER_ID"));
			bean.setSeq_no(results.getInt("SEQ_NO"));
			bean.setSche_year(results.getString("SCHE_YEAR"));
			bean.setSche_mon(results.getString("SCHE_MON"));
			bean.setCont(results.getString("CONT"));
			bean.setReg_dt(results.getString("REG_DT"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

    /**
     * 일정전체조회
     */
    public CarScheBean [] getCarScheAll(String start_year, String start_mon, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select work_id, a.user_id USER_ID, a.seq SEQ, a.start_year START_YEAR, a.start_mon START_MON, a.start_day START_DAY, a.title TITLE, a.content CONTENT, a.reg_dt REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, a.sch_chk SCH_CHK \n"
        		+ "from \n"
				        + "(select work_id,user_id,seq,start_year,start_mon,start_day,title,content,reg_dt,sch_kd,"
						+ "    decode(sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','휴가', '5','병가', '6','경조사', '7','공가', '8','휴직', '9','포상휴가', '0','재택근무') as sch_chk\n"
						+ "    from sch_prv where start_year=? and start_mon=? ) a, users b\n"
				+ "where a.user_id=b.user_id AND b.dept_id <> '9999' order by b.dept_id, b.user_id\n";

        Collection<CarScheBean> col = new ArrayList<CarScheBean>();
        try{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, start_year.trim());
    		pstmt.setString(2, start_mon.trim());    		
    		rs = pstmt.executeQuery();
            while(rs.next()){                
				col.add(makeCarScheBean(rs)); 
            }
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			 System.out.println("[ScheduleDatabase:getCarScheAll]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CarScheBean[])col.toArray(new CarScheBean[0]);
    }
    /**
     * 일정세부조회
     */
    public CarScheBean getCarScheBean(String user_id, int seq, String start_year, String start_mon, String start_day) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        CarScheBean sc;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select a.work_id, a.user_id USER_ID, a.seq SEQ, a.start_year START_YEAR, a.start_mon START_MON, a.start_day START_DAY, a.title TITLE, a.content CONTENT, a.reg_dt REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, a.sch_chk SCH_CHK \n"
				+ "from sch_prv a, users b\n"
				+ "where a.user_id=? and a.seq=? and a.start_year=? and a.start_mon=? and a.start_day=? and a.user_id=b.user_id\n";

        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, user_id.trim());
    		pstmt.setInt(2, seq);
    		pstmt.setString(3, start_year.trim());
    		pstmt.setString(4, start_mon.trim());
    		pstmt.setString(5, start_day.trim());
    		
    		rs = pstmt.executeQuery();

            if (rs.next())
                sc = makeCarScheBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + seq );

            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[ScheduleDatabase:getCarScheBean]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sc;
    }
    /**
     * 년월간일정전체조회
     */
    public YMScheBean [] getYMScheAll(String sche_year, String sche_mon) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select SEQ_NO, SCHE_YEAR, SCHE_MON, USER_ID, CONT, REG_DT\n"
        		+ "from ym_sche\n"
        		+ "where sche_year=? and sche_mon=?\n";


        Collection<YMScheBean> col = new ArrayList<YMScheBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, sche_year.trim());
    		pstmt.setString(2, sche_mon.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeYMScheBean(rs));
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[ScheduleDatabase:getYMScheAll]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (YMScheBean[])col.toArray(new YMScheBean[0]);
    }
    /**
     * 년월간일정세부조회
     */
    public YMScheBean getCarScheBean(int seq_no, String sche_year, String sche_mon) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        YMScheBean ymc;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select SEQ_NO, SCHE_YEAR, SCHE_MON, USER_ID, CONT, REG_DT\n"
        		+ "from ym_sche\n"
        		+ "where sche_year=? and sche_mon=? and seq_no=?\n";
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, sche_year.trim());
    		pstmt.setString(2, sche_mon.trim());
    		pstmt.setInt(3, seq_no);
    		
    		rs = pstmt.executeQuery();

            if (rs.next())
                ymc = makeYMScheBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + seq_no );
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[ScheduleDatabase:getCarScheBean]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ymc;
    }
	/**
     * 스케쥴등록
     */
    public int insertCarSche(CarScheBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        Statement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        int seq = 0;
        int count = 0;
                   
       try{
            con.setAutoCommit(false);

            query1="select nvl(max(seq)+1,1) from sch_prv where \n"
            		+ " user_id='"+bean.getUser_id().trim()+"'\n"
            		+ " and start_year='"+bean.getStart_year().trim()+"'\n"
            		+ " and start_mon='"+bean.getStart_mon().trim()+"'\n"
            		+ " and start_day='"+bean.getStart_day().trim()+"'";
			
            pstmt1 = con.createStatement();
            rs = pstmt1.executeQuery(query1);

            if(rs.next()){
				seq = rs.getInt(1);
            }
			
            query="INSERT INTO SCH_PRV(USER_ID, SEQ, START_YEAR, START_MON, START_DAY, TITLE, CONTENT, REG_DT, SCH_KD, SCH_ST, SCH_CHK, ov_yn, gj_ck, work_id, COUNT, doc_no, iwol )\n"
                + "values('"+bean.getUser_id().trim()+"',\n"
            	+ " "+seq+",\n"
            	+ " '"+bean.getStart_year().trim()+"',\n"
            	+ " '"+bean.getStart_mon().trim()+"',\n"
            	+ " '"+bean.getStart_day().trim()+"',\n"
            	+ " '"+bean.getTitle().trim()+"',\n"
            	+ " '"+bean.getContent().trim()+"',\n"
            	+ " to_char(sysdate,'YYYYMMDD'),\n"
				+ " '"+bean.getSch_kd().trim()+"', '"+bean.getSch_st().trim()+"',\n"
				+ " '"+bean.getSch_chk().trim()+"', \n"
				+ " '"+bean.getOv_yn().trim()+"', \n"
				+ " '"+bean.getGj_ck()+"', \n"
				+ " '"+bean.getWork_id().trim()+"', \n"
				+ " '"+bean.getCount().trim()+"', \n"
				+ " '"+bean.getDoc_no().trim()+"', \n"
				+ " '"+bean.getIwol().trim()+"' \n"
				+ " )\n";

			pstmt = con.createStatement();
			count = pstmt.executeUpdate(query);

            rs.close();
            pstmt1.close();
            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("[ScheduleDatabase:insertCarSche]"+se);
			System.out.println("[ScheduleDatabase:insertCarSche]"+query1);
			System.out.println("[ScheduleDatabase:insertCarSche]"+query);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }
	/**
     * 스케쥴수정
     */
    public int updateCarSche(CarScheBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		Statement pstmt = null;
        String query = "";
        int count = 0;


		 query="UPDATE SCH_PRV SET TITLE='"+bean.getTitle().trim()+"',\n" 
				+ " CONTENT='"+bean.getContent()+"',\n"
				+ " REG_DT=to_char(sysdate,'YYYYMMDD'),\n"
				+ " SCH_KD='"+bean.getSch_kd()+"',\n"
				+ " SCH_CHK='"+bean.getSch_chk()+"',\n"
				+ " work_id='"+bean.getWork_id()+"',\n"
				+ " OV_YN = '"+bean.getOv_yn()+"', \n"
				+ " GJ_CK = '"+bean.getGj_ck()+"' \n"
				+ " where user_id='"+bean.getUser_id()+"'\n"
				+ " and seq="+bean.getSeq()+" \n"
				+ " and start_year='"+bean.getStart_year()+"' \n"
				+ " and start_mon='"+bean.getStart_mon()+"'\n"
				+ " and start_day='"+bean.getStart_day()+"'\n";


       try{
            con.setAutoCommit(false);
            
            pstmt = con.createStatement();

            count = pstmt.executeUpdate(query);
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("[ScheduleDatabase:updateCarSche]"+se);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }
	/**
     * 스케쥴삭제
     */
    public int deleteCarSche(CarScheBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		Statement pstmt = null;
        String query = "";
        int count = 0;
                
        query="delete from SCH_PRV "
            + "where user_id='"+bean.getUser_id()+"'\n"
				+ " and seq="+bean.getSeq()+" \n"
				+ " and start_year='"+bean.getStart_year()+"' \n"
				+ " and start_mon='"+bean.getStart_mon()+"'\n"
				+ " and start_day='"+bean.getStart_day()+"'\n";
       try{
            con.setAutoCommit(false);
            
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);             
            pstmt.close();

            con.commit();

        }catch(Exception se){
			System.out.println("[ScheduleDatabase:deleteCarSche]"+se);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

    /**
     * 년월간 스케쥴 등록
     */
    public int insertYMSche(YMScheBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        int seq_no = 0;
        int count = 0;
                
        query="INSERT INTO YM_SCHE(SEQ_NO, SCHE_YEAR, SCHE_MON, USER_ID, CONT, REG_DT)\n"
            + "values(?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'))\n";

        query1="select nvl(max(seq_no)+1,1) from ym_sche where sche_year=? and sche_mon=?";
    
       try{
            con.setAutoCommit(false);
            pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, bean.getSche_year().trim());
            pstmt1.setString(2, bean.getSche_mon().trim());
			rs = pstmt1.executeQuery();

            if(rs.next()){
				seq_no = rs.getInt(1);
            }

            pstmt = con.prepareStatement(query);

			pstmt.setInt(1, seq_no);
			pstmt.setString(2, bean.getSche_year().trim());
			pstmt.setString(3, bean.getSche_mon().trim());
			pstmt.setString(4, bean.getUser_id().trim());
			pstmt.setString(5, bean.getCont().trim());
           
            count = pstmt.executeUpdate();
             
            rs.close();
            pstmt1.close();
            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("[ScheduleDatabase:insertYMSche]"+se);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }
    /**
     * 년월간 스케쥴 수정.
     */
    public int updateYMSche(YMScheBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE SCH_PRV SET USER_ID=?, CONT=?, REG_DT=to_cahr(sysdate, 'YYYYMMDD')\n"
            + "where seq_no=? and sche_year=? and sche_mon=?\n";
        
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);
			
			pstmt.setString(1, bean.getUser_id().trim());
			pstmt.setString(2, bean.getCont().trim());
			pstmt.setInt(3, bean.getSeq_no());
			pstmt.setString(4, bean.getSche_year().trim());
			pstmt.setString(5, bean.getSche_mon().trim());
           
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("[ScheduleDatabase:updateYMSche]"+se);
			try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

	//사장과의 식사(20090526)---------------------------------------------------------------------------------------------------------------------------------

   /**
     * 사장과식사 일정전체조회
     */
    public CeoLunchScheBean [] getCeoLunchSche(String start_year, String start_mon, String start_day) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";

        query = " select a.*, b.user_nm as member_nm1\n"
        		+ " from sch_ceolunch a, users b \n"
				+ " where a.start_year=? and a.start_mon=? and a.start_day=? \n"
				+ "	and a.member_id1=b.user_id(+) \n";



        Collection<CeoLunchScheBean> col = new ArrayList<CeoLunchScheBean>();
        try{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, start_year.trim());
    		pstmt.setString(2, start_mon.trim());
    		pstmt.setString(3, start_day.trim());

    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeCeoLunchScheBean(rs));
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[ScheduleDatabase:getCeoLunchScheAll]"+se);
			 System.out.println("[ScheduleDatabase:getCeoLunchScheAll]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CeoLunchScheBean[])col.toArray(new CeoLunchScheBean[0]);
    }

    /**
     * 사장과식사 일정전체조회
     */
    public CeoLunchScheBean [] getCeoLunchScheAll(String start_year, String start_mon, String start_day) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";

        query = " select a.*, b.user_nm as member_nm1\n"
        		+ " from sch_ceolunch a, users b \n"
				+ " where a.start_year=? and a.start_mon=? \n"
				+ "	and a.member_id1=b.user_id(+) \n";



        Collection<CeoLunchScheBean> col = new ArrayList<CeoLunchScheBean>();
        try{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, start_year.trim());
    		pstmt.setString(2, start_mon.trim());   		
    		rs = pstmt.executeQuery();
            while(rs.next()){                
				col.add(makeCeoLunchScheBean(rs)); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[ScheduleDatabase:getCeoLunchScheAll]"+se);
			 System.out.println("[ScheduleDatabase:getCeoLunchScheAll]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (CeoLunchScheBean[])col.toArray(new CeoLunchScheBean[0]);
    }

	/**
     * 스케쥴등록
     */
    public int insertCeoLunchSche(CeoLunchScheBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;

          query="INSERT INTO sch_ceolunch (START_YEAR, START_MON, START_DAY, REG_DT, time_st, member_id1, member_dt1 )\n"
                + "values( \n"
            	+ " '"+bean.getStart_year().trim()+"',\n"
            	+ " '"+bean.getStart_mon().trim()+"',\n"
            	+ " '"+bean.getStart_day().trim()+"',\n"
            	+ " to_char(sysdate,'YYYYMMDD'), \n"
				+ " '"+bean.getTime_st().trim()+"',\n"
				+ " '"+bean.getMember_id1().trim()+"',\n"
				+ " replace('"+bean.getMember_dt1().trim()+"','-','') \n"
				+ " )\n";


       try{
            con.setAutoCommit(false);			           
			pstmt = con.createStatement();
			count = pstmt.executeUpdate(query);
            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("[ScheduleDatabase:insertCeoLunchSche]"+se);
			System.out.println("[ScheduleDatabase:insertCeoLunchSche]"+query);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

	/**
     * 스케쥴수정
     */
    public int updateCeoLunchSche(CeoLunchScheBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
                   
       try{
            con.setAutoCommit(false);
			
            query = " update sch_ceolunch set \n"+
					"        time_st	='"+bean.getTime_st().trim()+"',  \n"+
					"        member_id1	='"+bean.getMember_id1().trim()+"',  \n"+
					"        member_dt1	=replace('"+bean.getMember_dt1().trim()+"','-','')  \n"+
					" where start_year='"+bean.getStart_year().trim()+"' and start_mon='"+bean.getStart_mon().trim()+"' and start_day='"+bean.getStart_day().trim()+"' ";

			pstmt = con.createStatement();
			count = pstmt.executeUpdate(query);
            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("[ScheduleDatabase:updateCeoLunchSche]"+se);
			System.out.println("[ScheduleDatabase:updateCeoLunchSche]"+query);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

	/**
     * 신청자삭제
     */
    public int delCeoLunchSche(CeoLunchScheBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
                   
       try{
            con.setAutoCommit(false);
			
            query = " delete from sch_ceolunch \n"+
					" where member_id1='"+bean.getMember_id1().trim()+"' and start_year='"+bean.getStart_year().trim()+"' and start_mon='"+bean.getStart_mon().trim()+"' and start_day='"+bean.getStart_day().trim()+"' ";


			pstmt = con.createStatement();
			count = pstmt.executeUpdate(query);
            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("[ScheduleDatabase:delCeoLunchSche]"+se);
			System.out.println("[ScheduleDatabase:delCeoLunchSche]"+query);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }


	/**
     * 스케쥴삭제
     */
    public int deleteCeoLunchSche(CeoLunchScheBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
                   
       try{
            con.setAutoCommit(false);
			
            query="delete from sch_ceolunch where START_YEAR='"+bean.getStart_year().trim()+"' and START_MON='"+bean.getStart_mon().trim()+"' and START_DAY='"+bean.getStart_day().trim()+"' and member_id1||member_id2||member_id3 is null \n";

			pstmt = con.createStatement();
			count = pstmt.executeUpdate(query);

            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("[ScheduleDatabase:deleteCeoLunchSche]"+se);
			System.out.println("[ScheduleDatabase:deleteCeoLunchSche]"+query);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }



	/**
     * 사장과 식사 일정등록 
     */
    private CeoLunchScheBean makeCeoLunchScheBean(ResultSet results) throws DatabaseException {

        try {
            CeoLunchScheBean bean = new CeoLunchScheBean();

			bean.setStart_year	(results.getString("START_YEAR"));
			bean.setStart_mon	(results.getString("START_MON"));
			bean.setStart_day	(results.getString("START_DAY"));
			bean.setReg_dt		(results.getString("REG_DT"));
			bean.setTime_st		(results.getString("TIME_ST"));
			bean.setMember_id1	(results.getString("MEMBER_ID1"));
			bean.setMember_dt1	(results.getString("MEMBER_DT1"));
			bean.setMember_nm1	(results.getString("MEMBER_NM1"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
    
    /**
     * 재택근무 파트너 입력 점검
     */
    public int getSchCheck(String user_id, String start_year, String start_mon, String start_day) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        int count = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "SELECT count(0) cnt \r\n"
        		+ "FROM sch_prv a,  \r\n"
        		+ "     (SELECT REPLACE(ars_group,'/','|') ars_group FROM users WHERE user_id=?) b\r\n"
        		+ "WHERE a.sch_chk='0' AND a.start_year=? AND a.start_mon=? AND a.start_day=?\r\n"
        		+ "AND regexp_like (b.ars_group, a.user_id)\n";

        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, user_id.trim());
    		pstmt.setString(2, start_year.trim());
    		pstmt.setString(3, start_mon.trim());
    		pstmt.setString(4, start_day.trim());    		
    		rs = pstmt.executeQuery();
            if (rs.next()) {
            	count = rs.getInt(1);
        	}
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[ScheduleDatabase:getSchCheck]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    /**
     * 중복체크
     */
    public int getSchRegCheck(String user_id, String start_year, String start_mon, String start_day) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        int count = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "SELECT count(0) cnt \r\n"
        		+ "FROM sch_prv a  \r\n"
        		+ "WHERE a.sch_chk='0' AND a.user_id=? AND a.start_year=? AND a.start_mon=? AND a.start_day=?\r\n"
        		+ " ";

        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, user_id.trim());
    		pstmt.setString(2, start_year.trim());
    		pstmt.setString(3, start_mon.trim());
    		pstmt.setString(4, start_day.trim());    		
    		rs = pstmt.executeQuery();
            if (rs.next()) {
            	count = rs.getInt(1);
        	}
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[ScheduleDatabase:getSchRegCheck]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    
    /**
     * 스케쥴삭제
     */
    public int deleteCarSche(String user_id, String start_year, String start_mon, String start_day , int seq)  throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		Statement pstmt = null;
        String query = "";
        int count = 0;
                
        query="delete from SCH_PRV "
            + "where user_id='"+user_id+"'\n"
				+ " and seq="+seq +" \n"
				+ " and start_year='"+start_year+"' \n"
				+ " and start_mon='"+start_mon+"'\n"
				+ " and start_day='"+start_day+"'\n";
       try{
            con.setAutoCommit(false);
            
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);             
            pstmt.close();

            con.commit();

        }catch(Exception se){
			System.out.println("[ScheduleDatabase:deleteCarSche]"+se);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }


}
