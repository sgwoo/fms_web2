/**
 * 고객지원업무스케쥴
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2002. 3. 4
 * @ last modify date : 
 */
package acar.car_sche;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.io.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class CarSchDatabase {

    private static CarSchDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized CarSchDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new CarSchDatabase();
        return instance;
    }
    
    private CarSchDatabase() throws DatabaseException {
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
     * 당일업무 차량정비 ( 2003/03/05 ) - Yongsoon Kwon 
	 * 20040921 Yongsoon Kwon. 수정
     */
    private TodayScheBean makeTodayScheBean(ResultSet results) throws DatabaseException {

        try {
            TodayScheBean bean = new TodayScheBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
			bean.setServ_id(results.getString("SERV_ID"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_name(results.getString("CAR_NAME"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setOff_nm(results.getString("OFF_NM"));
			bean.setServ_dt(results.getString("SERV_DT"));
			bean.setServ_st(results.getString("SERV_ST"));
			bean.setRep_cont(results.getString("REP_CONT"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
     * 당일업무 거래처방문( 2003/03/05 ) - Yongsoon Kwon
     */
    private TodaySche2Bean makeTodaySche2Bean(ResultSet results) throws DatabaseException {

        try {
            TodaySche2Bean bean = new TodaySche2Bean();

		    bean.setClient_id(results.getString("CLIENT_ID"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setVst_title(results.getString("VST_TITLE"));
			bean.setVst_cont(results.getString("VST_CONT"));
		    
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
        
        query = " select a.work_id, a.user_id USER_ID, a.seq SEQ, a.start_year START_YEAR, a.start_mon START_MON, a.start_day START_DAY, a.title TITLE, a.content CONTENT, a.reg_dt REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, a.sch_chk SCH_CHK \n"
        		+ " from \n"
				+ "     (select work_id,user_id,seq,start_year,start_mon,start_day,title,content,reg_dt,sch_kd,\n"
				+ "      decode(sch_chk, '','', '1','업무일지', '2','현지출근', '3','년차', '4','휴가', '5','병가', '6','경조사', '7','훈련', '8','결근', '0','재택근무') as sch_chk\n"
        		+ "      from sch_prv \n"
				+ "      where start_year=? and start_mon=? and sch_st='M' and user_id=? or (sch_kd='2' and sch_st='M')) a,\n"
				+ "      users b\n"
				+ " where a.user_id=b.user_id\n and a.start_year=? and a.start_mon=?";


        Collection<CarScheBean> col = new ArrayList<CarScheBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, start_year.trim());
    		pstmt.setString(2, start_mon.trim());
    		pstmt.setString(3, user_id.trim());
    		pstmt.setString(4, start_year.trim());
    		pstmt.setString(5, start_mon.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeCarScheBean(rs));
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
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
            rs.close();
            pstmt1.close();

			
            query="INSERT INTO SCH_PRV(USER_ID, SEQ, START_YEAR, START_MON, START_DAY, TITLE, CONTENT, REG_DT, SCH_KD, SCH_ST,SCH_CHK, ov_yn, count, work_id)\n"
                + "values('"+bean.getUser_id().trim()+"',\n"
            	+ " "+seq+",\n"
            	+ " '"+bean.getStart_year().trim()+"',\n"
            	+ " '"+bean.getStart_mon().trim()+"',\n"
            	+ " '"+bean.getStart_day().trim()+"',\n"
            	+ " '"+bean.getTitle().trim()+"',\n"
            	+ " '"+bean.getContent().trim()+"',\n"
            	+ " to_char(sysdate,'YYYYMMDD'),\n"
				+ " '"+bean.getSch_kd().trim()+"', 'M', \n"
				+ " '"+bean.getSch_chk().trim()+"',\n"
				+ " '"+bean.getOv_yn().trim()+"',\n"
				+ " '"+bean.getCount().trim()+"',\n"
				+ " '"+bean.getWork_id().trim()+"')\n";
				
			pstmt = con.createStatement();
			count = pstmt.executeUpdate(query);		
            pstmt.close();
            con.commit();

        }catch(Exception se){
			System.out.println("[CarSchDatabase:insertCarSche]"+se);
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
				+ " work_id='"+bean.getWork_id()+"'\n"
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

        }catch(SQLException se){
			System.out.println("[CarSchDatabase:updateCarSche]"+se);
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
			System.out.println("[CarSchDatabase:deleteCarSche]"+se);
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
            rs.close();
            pstmt1.close();

            pstmt = con.prepareStatement(query);
			pstmt.setInt   (1, seq_no);
			pstmt.setString(2, bean.getSche_year().trim());
			pstmt.setString(3, bean.getSche_mon().trim());
			pstmt.setString(4, bean.getUser_id().trim());
			pstmt.setString(5, bean.getCont().trim());           
            count = pstmt.executeUpdate();             
            pstmt.close();
            con.commit();

        }catch(Exception se){
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
     *  당일업무내용 차량정비 - 2004.03.05. Yongsoon Kwon.
     */
    public TodayScheBean[] getTodaySche(String user_id,String dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		Collection<TodayScheBean> col = new ArrayList<TodayScheBean>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select a.car_mng_id, a.serv_id, b.car_no car_no, f.car_nm||' '||e.car_name car_name, nvl(h.firm_nm,h.client_nm) firm_nm, g.off_nm off_nm, a.serv_dt, a.serv_st, a.rep_cont "+
				" from service a, car_reg b, cont c, car_etc d, car_nm e, car_mng f, serv_off g, client h "+
				" 	where a.checker= ? "+
				" 	and a.serv_dt = ? "+
				" 	and a.car_mng_id = b.car_mng_id "+
				" 	and a.rent_mng_id = c.rent_mng_id "+
				" 	and a.rent_l_cd = c.rent_l_cd "+
				" 	and a.rent_mng_id = d.rent_mng_id "+
				" 	and a.rent_l_cd = d.rent_l_cd "+
				" 	and d.car_id = e.car_id(+) "+
				" 	and d.car_seq = e.car_seq(+) "+
				" 	and e.car_comp_id = f.car_comp_id "+
				" 	and e.car_cd = f.code "+
				" 	and a.off_id = g.off_id(+)"+
				"	and c.client_id = h.client_id "+
				" union "+
				" select a.car_mng_id,'',b.car_no, f.car_nm||' '||e.car_name car_name, "+
				" nvl(g.firm_nm,g.client_nm) frim_nm,'',a.che_dt, decode(che_kd,'1','8','2','9',''), a.che_comp "+
				" from car_maint a, car_reg b, cont c, car_etc d, car_nm e, car_mng f, client g "+
				" where a.car_mng_id = b.car_mng_id "+
				" and a.car_mng_id = c.car_mng_id "+
				" and c.rent_mng_id = d.rent_mng_id "+
				" and c.rent_l_cd = d.rent_l_cd "+
				" and d.car_id = e.car_id "+
				" and d.car_seq = e.car_seq "+
				" and e.car_comp_id = f.car_comp_id "+
				" and e.car_cd = f.code "+
				" and c.client_id = g.client_id "+
				" and a.che_no=? and a.che_dt=? ";

        try{
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, user_id);
    		pstmt.setString(2, dt);
			pstmt.setString(3, user_id);
    		pstmt.setString(4, dt);
   		
    		rs = pstmt.executeQuery();

            while(rs.next()){    
				col.add(makeTodayScheBean(rs));
             }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (TodayScheBean[])col.toArray(new TodayScheBean[0]);
    }
	 /**
     *  당일업무내용 거래처방문 - 2004.03.05. Yongsoon Kwon.
     */
    public TodaySche2Bean[] getTodaySche2(String user_id, String dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		Collection<TodaySche2Bean> col = new ArrayList<TodaySche2Bean>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select a.client_id, nvl(b.firm_nm,b.client_nm) firm_nm, a.vst_title, a.vst_cont "+
				" from cycle_vst a, client b "+
				" where a.client_id = b.client_id "+
				" and a.visiter = ? "+
				" and a.vst_dt = ? ";

        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, user_id);
			pstmt.setString(2, dt);
   		
    		rs = pstmt.executeQuery();

            while(rs.next()){    
				col.add(makeTodaySche2Bean(rs));
             }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (TodaySche2Bean[])col.toArray(new TodaySche2Bean[0]);
    }

    /**
     * 일정전체조회, 20040825, Yongsoon Kwon.
     */
    public CarScheBean [] getCarScheDay(String start_year, String start_mon, String start_day) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select a.work_id, a.user_id, b.user_nm, a.seq, a.start_year, a.start_mon, a.start_day, a.title, a.content, a.reg_dt, a.sch_kd, \n"+
	 			"		decode(a.sch_chk, '','', '1','업무일지', '2','현지출근', '3','년차', '4','휴가', '5','병가', '6','경조사', '7','훈련', '8','결근', '0','재택근무') as sch_chk \n"+
				"  from sch_prv a, users b where a.user_id=b.user_id and b.dept_id='0002' and a.start_year=? and a.start_mon=? and a.start_day =?";// and a.sch_st='M' 
		Collection<CarScheBean> col = new ArrayList<CarScheBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, start_year.trim());
    		pstmt.setString(2, start_mon.trim());
    		pstmt.setString(3, start_day.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeCarScheBean(rs));
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[CarSchDatabase:getCarScheDay(String start_year, String start_mon, String start_day)]"+se);
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
     *  당일업무내용 거래처방문,자동차정비 있을경우 업무일지 클릭할 수 있도록 - 2004.10.12. Yongsoon Kwon.
     */
	public Vector getTodaySchList(String s_user_id, String s_year, String s_month, String s_day) throws DatabaseException, DataSourceEmptyException{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select checker, substr(serv_dt,1,4) s_year, substr(serv_dt,5,2) s_month, substr(serv_dt,7,2) s_day "+
				" from (select checker, serv_dt from service a, users b where a.checker=b.user_id "+
				"	 		 and b.dept_id = '0002' and b.user_id not in('000006','000002','000001')  "+
				"	 union 	 "+
				"	 select visiter, vst_dt  from cycle_vst a, users b where a.visiter=b.user_id "+
				"	 		 and b.dept_id = '0002' and b.user_id not in('000006','000002','000001')  "+
				"	) a,  "+
				"	users u "+
				" where u.user_id = a.checker " ;

		if(!s_user_id.equals(""))	query += " and a.checker='"+s_user_id+"'";
		if(!s_year.equals(""))		query += " and a.serv_dt like '"+s_year+"%'";
		if(!s_month.equals(""))		query += " and substr(a.serv_dt,5,2)='"+s_month+"'";
		if(!s_day.equals(""))		query += " and substr(a.serv_dt,7,2)='"+s_day+"'";

		query += " and not exists (select * from sch_prv b where a.checker=b.user_id and start_year='"+s_year+"' and start_mon='"+s_month+"' and  start_day='"+s_day+"' ) ";
		try {
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
			System.out.println("[CarSchDatabase:getTodaySchList]"+se);
			 throw new DatabaseException();
        }finally{
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
     * 일정세부조회-오늘스케줄
     */
    public CarScheBean getCarScheTodayBean(String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        CarScheBean sc = new CarScheBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select a.work_id, a.user_id USER_ID, a.seq SEQ, a.start_year START_YEAR, a.start_mon START_MON, a.start_day START_DAY, a.title TITLE, a.content CONTENT, a.reg_dt REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, a.sch_chk SCH_CHK \n"
				+ "from sch_prv a, users b\n"
				+ "where a.user_id=? and a.sch_chk not in ('1','2','0') and a.start_year||a.start_mon||a.start_day=to_char(sysdate,'YYYYMMDD') and a.user_id=b.user_id\n";

        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, user_id.trim());
    		
    		rs = pstmt.executeQuery();

            if (rs.next()){
                sc = makeCarScheBean(rs);
			}

            rs.close();
            pstmt.close();
        }catch(SQLException se){
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
     * 일정세부조회-오늘스케줄
     */
    public CarScheBean getCarScheVacBean(String user_id, String sche_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        CarScheBean sc = new CarScheBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select a.work_id, a.user_id USER_ID, a.seq SEQ, a.start_year START_YEAR, a.start_mon START_MON, a.start_day START_DAY, a.title TITLE, a.content CONTENT, a.reg_dt REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, a.sch_chk SCH_CHK \n"
				+ "from sch_prv a, users b\n"
				+ "where a.user_id=? and a.sch_chk not in ('1','2','0') and a.start_year||a.start_mon||a.start_day=replace(?,'-','') and a.user_id=b.user_id\n";

        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, user_id.trim());
			pstmt.setString(2, sche_dt.trim());
    		
    		rs = pstmt.executeQuery();

            if (rs.next()){
                sc = makeCarScheBean(rs);
			}

            rs.close();
            pstmt.close();
        }catch(SQLException se){
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


	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/
	
	 /**
     * 일정전체조회
     */
    public CarScheBean [] getCarScheAll(String start_year, String start_mon, String start_day, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "   select a.user_id, b.user_nm, a.seq, a.start_year, a.start_mon, a.start_day, "
				+ "        a.title, a.content, a.reg_dt, a.sch_kd, a.sch_chk, a.work_id, '' count \n"
        		+ " from \n"
				+ "        ( select user_id, seq, start_year, start_mon, start_day, title, content, reg_dt, sch_kd, sch_chk as sch_chk_cd, \n"
				+ "                 decode(sch_chk, '','', '1','업무일지', '2','현지출근', '3','년차', '4','휴가', '5','병가', '6','경조사', '7','훈련', '8','결근', '0','재택근무') as sch_chk, \n"
				+ "	                work_id \n"
        		+ "          from   sch_prv \n"
				+ "          where  start_year=? and start_mon=? and start_day=? and user_id=?" //and sch_st='M' 
				+ "        ) a,\n"
				+ "        users b \n"
				+ " where  a.user_id=b.user_id\n and a.start_year=? and a.start_mon=? and a.start_day=? order by a.sch_chk_cd";

		

        Collection<CarScheBean> col = new ArrayList<CarScheBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, start_year.trim());
    		pstmt.setString(2, start_mon.trim());
    		pstmt.setString(3, start_day.trim());
    		pstmt.setString(4, user_id.trim());
    		pstmt.setString(5, start_year.trim());
    		pstmt.setString(6, start_mon.trim());
    		pstmt.setString(7, start_day.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
                
				col.add(makeCarScheBean(rs));
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
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
     * 휴가현황
     */
    public Vector getCarSchStat() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " select c.code, c.nm, \n"+
				"        count(decode(a.sch_dt,to_char(sysdate,'YYYYMMDD'),b.user_nm)) cnt1, \n"+
				"        count(decode(a.sch_dt,to_char(sysdate+1,'YYYYMMDD'),b.user_nm)) cnt2 \n"+
				" from   (select * from code where c_st='0002' and code in ('0001','0002','0003','0005','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018')) c, \n"+
				"        users b, \n"+
				"        (select a.user_id, a.start_year||a.start_mon||a.start_day as sch_dt \n"+
				"         from   sch_prv a, free_time b \n"+
				"         where  a.start_year||a.start_mon||a.start_day between to_char(sysdate,'YYYYMMDD') and to_char(sysdate+1,'YYYYMMDD') \n"+
				"                and a.sch_chk not in ('1','2','8') \n"+
				"                and a.user_id=b.user_id and a.start_year||a.start_mon||a.start_day between b.start_date and b.end_date "+
				"                and nvl(b.cancel,'N')<>'Y' "+
				"        ) a \n"+
				" where  c.code=b.dept_id \n"+
				"        and b.user_id=a.user_id(+) \n"+
				" group by c.code, c.nm \n"+
				" order by c.code";

        try{
            pstmt = con.prepareStatement(query);
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
        }catch(SQLException se){
			System.out.println("[CarSchDatabase:getCarSchStat]"+se);
			System.out.println("[CarSchDatabase:getCarSchStat]"+query);
			throw new DatabaseException();
        }finally{
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
     * 휴가현황
     */
    public Vector getCarSchStat(String dt1, String dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " select c.code, c.nm, \n"+
				"        count(decode(a.sch_dt,replace('"+dt1+"','-',''),b.user_nm)) cnt1, \n"+
				"        count(decode(a.sch_dt,replace('"+dt2+"','-',''),b.user_nm)) cnt2 \n"+
				" from   (select * from code where c_st='0002' and code in ('0001','0002','0003','0005','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018')) c, \n"+
				"        users b, \n"+
				"        (select a.user_id, a.start_year||a.start_mon||a.start_day as sch_dt \n"+
				"         from   sch_prv a, free_time b \n"+
				"         where  a.start_year||a.start_mon||a.start_day between replace('"+dt1+"','-','') and replace('"+dt2+"','-','') \n"+
				"                and a.sch_chk not in ('1','2','8') \n"+
				"                and a.user_id=b.user_id and a.start_year||a.start_mon||a.start_day between b.start_date and b.end_date "+
				"                and nvl(b.cancel,'N')<>'Y' "+
				"        ) a \n"+
				" where  c.code=b.dept_id \n"+
				"        and b.user_id=a.user_id(+) \n"+
				" group by c.code, c.nm \n"+
				" order by c.code";

        try{
            pstmt = con.prepareStatement(query);
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
        }catch(SQLException se){
			System.out.println("[CarSchDatabase:getCarSchStat]"+se);
			System.out.println("[CarSchDatabase:getCarSchStat]"+query);
			throw new DatabaseException();
        }finally{
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
     * 부서별 휴가현황
     */
    public Vector getCarSchDeptStatList(String dt_st, String dept_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.user_nm, c.user_m_tel, a.seq, decode(a.sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','휴가', '5','병가', '6','경조사', '7','훈련', '8','결근', '9','포상휴가', '0','재택근무') as sch_chk, "+
				"        a.title, a.content, a.work_id, d.user_nm as work_nm, d.user_m_tel as work_m_tel, "+
				"        b.start_date, b.end_date, "+
				"        decode(a.ov_yn,'Y','무급','N','유급') ov_yn, "+
				"        decode(a.gj_ck,'N','결재전','Y','결재완료') gj_ck "+
				" from   sch_prv a, (select * from free_time where to_char(sysdate+"+dt_st+",'YYYYMMDD') between start_date and end_date and nvl(cancel,'N')<>'Y' ) b, users c, users d "+
				" where  "+
//				"        a.sch_chk in ('3','4','5','9','7','6') "+
				"        a.sch_chk not in ('1','2','8','0') "+
				"        and a.start_year||a.start_mon||a.start_day=to_char(sysdate+"+dt_st+",'YYYYMMDD') and a.user_id=b.user_id(+) "+
				"        and a.user_id=c.user_id "+
				"        and a.work_id=d.user_id(+)"+
				" ";

		if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";

		query += " order by c.dept_id, a.user_id ";


        try{
            pstmt = con.prepareStatement(query);
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
//			System.out.println("[CarSchDatabase:getCarSchDeptStatList]"+query);
        }catch(SQLException se){
			System.out.println("[CarSchDatabase:getCarSchDeptStatList]"+se);
			System.out.println("[CarSchDatabase:getCarSchDeptStatList]"+query);
			 throw new DatabaseException();
        }finally{
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
     * 부서별 휴가현황
     */
    public Vector getCarSchDeptStatList(String dt_st, String dept_id, String r_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.user_nm, c.user_m_tel, a.seq, decode(a.sch_chk, '','', '1','업무일지', '2','현지출근', '3','연차', '4','휴가', '5','병가', '6','경조사', '7','훈련', '8','결근', '9','포상휴가', '0','재택근무') as sch_chk, "+
				"        a.title, a.content, a.work_id, d.user_nm as work_nm, d.user_m_tel as work_m_tel, "+
				"        b.start_date, b.end_date, "+
				"        decode(a.ov_yn,'Y','무급','N','유급') ov_yn, "+
				"        decode(a.gj_ck,'N','결재전','Y','결재완료') gj_ck "+
				" from   sch_prv a, (select * from free_time where replace('"+r_dt+"','-','') between start_date and end_date and nvl(cancel,'N')<>'Y' ) b, users c, users d "+
				" where  "+
//				"        a.sch_chk in ('3','4','5','9','7','6') "+
				"        a.sch_chk not in ('1','2','8','0') "+
				"        and a.start_year||a.start_mon||a.start_day=replace('"+r_dt+"','-','') and a.user_id=b.user_id(+) "+
				"        and a.user_id=c.user_id "+
				"        and a.work_id=d.user_id(+)"+
				" ";

		if(!dept_id.equals("")) query += " and c.dept_id='"+dept_id+"'";

		query += " order by c.dept_id, a.user_id ";


        try{
            pstmt = con.prepareStatement(query);
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
//			System.out.println("[CarSchDatabase:getCarSchDeptStatList]"+query);
        }catch(SQLException se){
			System.out.println("[CarSchDatabase:getCarSchDeptStatList]"+se);
			System.out.println("[CarSchDatabase:getCarSchDeptStatList]"+query);
			 throw new DatabaseException();
        }finally{
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
