/**
 * 게시판
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.off_anc;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class OffBulDatabase {

    private static OffBulDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized OffBulDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new OffBulDatabase();
        return instance;
    }
    
    private OffBulDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	
	
	/**
     * 사내 게시판
     */
    private BulBean makeBulBean(ResultSet results) throws DatabaseException {

        try {
            BulBean bean = new BulBean();

		    bean.setB_id(results.getInt			("B_ID"));
		    bean.setUser_id(results.getString	("USER_ID"));
		    bean.setUser_nm(results.getString	("USER_NM"));
		    bean.setBr_id(results.getString		("BR_ID"));
		    bean.setBr_nm(results.getString		("BR_NM"));
		    bean.setDept_id(results.getString	("DEPT_ID"));
		    bean.setDept_nm(results.getString	("DEPT_NM"));
		    bean.setReg_dt(results.getString	("REG_DT"));
		    bean.setExp_dt(results.getString	("EXP_DT"));
		    bean.setTitle(results.getString		("TITLE"));
		    bean.setContent(results.getString	("CONTENT"));	
		    bean.setRead_chk(results.getString	("READ_CHK"));	
		    bean.setUse_chk(results.getString	("USE_CHK"));	
		    bean.setAtt_file1(results.getString	("ATT_FILE1"));	
		    bean.setAtt_file2(results.getString	("ATT_FILE2"));	
		    bean.setAtt_file3(results.getString	("ATT_FILE3"));	
		    bean.setAtt_file4(results.getString	("ATT_FILE4"));	
		    bean.setAtt_file5(results.getString	("ATT_FILE5"));	
		    bean.setVisit_cnt(results.getInt	("VISIT_CNT"));
			bean.setB_st(results.getString	("B_ST"));
		    		
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	
 	/**
     * 사내 게시판 개별 조회
     */    
    public BulBean getBulBean(int b_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        BulBean ab;

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "select a.b_id as B_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID, c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT, substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT, a.title as TITLE, a.content as CONTENT,\n"   
				+ "a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.read_chk, '' use_chk,\n"   
				+ "a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5, a.B_ST \n"
				+ "from bulletin a, users b, branch c, code d\n"
				+ "where a.b_id=" + b_id + " and a.user_id=b.user_id and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code\n";

        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    		//System.out.println("query=" + query );
    		
            if (rs.next())
                ab = makeBulBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + b_id );
 			rs.close();
            stmt.close();
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return ab;
    }
    /**
     * 마지막 사내 게시판 조회
     */    
    public BulBean getBulLastBean() throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        BulBean ab = new BulBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "select a.b_id as B_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID, c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT, substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT, a.title as TITLE, a.content as CONTENT,\n"   
				+ "a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT,   a.read_chk, '' use_chk,\n"   
				+ "a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5, a.B_ST \n"
				+ "from bulletin a, users b, branch c, code d\n"
				+ "where a.b_id=(select max(b_id) from bulletin where exp_dt >= to_char(sysdate,'YYYYMMDD')) and a.user_id=b.user_id and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code\n";

        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                ab = makeBulBean(rs);
           
 			rs.close();
            stmt.close();
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return ab;
    }
	/**
     * 게시판 전체조회(메인)
     */
    public BulBean [] getBulAll(String acar_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
                        
        query = "select a.b_id as B_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID, c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT, substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT, a.title as TITLE, a.content as CONTENT,\n"   
				+ " a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk, '' use_chk,\n"   
				+ " a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5, a.B_ST \n"
				+ "from bulletin a, users b, branch c, code d\n"
				+ "where a.user_id=b.user_id\n"
				+ "and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code\n"
				+ "and a.exp_dt >= to_char(sysdate,'YYYYMMDD') order by a.bbs_id";
      
        Collection<BulBean> col = new ArrayList<BulBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeBulBean(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (BulBean[])col.toArray(new BulBean[0]);
    }

	/**
     * 게시판 전체조회(리스트)
     */
    public BulBean [] getBulAll(String gubun, String gubun_nm, String acar_id, String b_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
        
        if(gubun.equals("title"))			subQuery = " and a.title like '%" + gubun_nm + "%'\n";
        else if(gubun.equals("content"))	subQuery = " and a.content like '%" + gubun_nm + "%'\n";
        else if(gubun.equals("reg_dt"))		subQuery = " and a.reg_dt >= replace('" + gubun_nm + "','-','')\n";
        else if(gubun.equals("user_nm"))	subQuery = " and b.user_nm like '%" + gubun_nm + "%'\n";
        else if(gubun.equals("all"))	    subQuery = "";
        else	                            subQuery = "";
        
        query = "select a.b_id as B_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID,"+
				" c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, "+
				" substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT,"+
				" substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT,"+
				" a.title as TITLE, a.content as CONTENT, a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT,  "+
				" decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk,\n"+
				" decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') use_chk,\n"+
				" a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5, a.B_ST \n"
				+ "from bulletin a, users b, branch c, code d\n"
				+ "where a.user_id=b.user_id\n"
				+ subQuery
				+ "and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and nvl(a.b_st,'B') = '"+b_st+"' \n";
        
        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.b_id desc";
      
        Collection<BulBean> col = new ArrayList<BulBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
				col.add(makeBulBean(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (BulBean[])col.toArray(new BulBean[0]);
    }
   
    /**
     * 게시판 등록
     */
    public int insertBul(BulBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        Statement pstmt = null;
        String query = "";
        int count = 0;
		String exp_dt = bean.getExp_dt().trim();
     //  System.out.println(count);        
     //System.out.println("aa="+ bean.getAtt_file1().trim() );       
		try{
        
			if(!exp_dt.equals("")){	
		       query ="insert into bulletin(B_ID,USER_ID,REG_DT,EXP_DT,TITLE,CONTENT,ATT_FILE1,VISIT_CNT,ATT_FILE2, ATT_FILE3, ATT_FILE4, ATT_FILE5, B_ST)\n"
                      + "SELECT nvl(max(B_ID)+1,1),'"+bean.getUser_id().trim()+"',\n"
					  + "to_char(sysdate,'YYYYMMDD'),replace('"+bean.getExp_dt().trim()+"','-',''),\n"
					  + "'"+bean.getTitle().trim()+"','"+bean.getContent().trim()+"',\n"
					  + "'"+bean.getAtt_file1().trim()+"',0,'"+bean.getAtt_file2().trim()+"',\n"
 					  + "'"+bean.getAtt_file3().trim()+"','"+bean.getAtt_file4().trim()+"','"+bean.getAtt_file5().trim()+"','"+bean.getB_st().trim()+"' \n"
			   		  + "FROM BULLETIN\n";
			}else{
		       query ="insert into bulletin(B_ID,USER_ID,REG_DT,EXP_DT,TITLE,CONTENT,ATT_FILE1,VISIT_CNT,ATT_FILE2, ATT_FILE3, ATT_FILE4, ATT_FILE5, B_ST)\n"
                      + "SELECT nvl(max(B_ID)+1,1),'"+bean.getUser_id().trim()+"',\n"
					  + "to_char(sysdate,'YYYYMMDD'),to_char(sysdate+7,'YYYYMMDD'),\n"
					  + "'"+bean.getTitle().trim()+"','"+bean.getContent().trim()+"',\n"
					  + "'"+bean.getAtt_file1().trim()+"',0,'"+bean.getAtt_file2().trim()+"',\n"
					  + "'"+bean.getAtt_file3().trim()+"','"+bean.getAtt_file4().trim()+"','"+bean.getAtt_file5().trim()+"','"+bean.getB_st().trim()+"' \n"
			   		  + "FROM BULLETIN\n";
			}

            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                        
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
     * 사내게시판 수정
     */
    public int updateBul(BulBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
       try{

	       query="UPDATE BULLETIN\n"
    		   	+ "SET EXP_DT=replace('"+bean.getExp_dt().trim()+"','-',''),\n"
       			+ "TITLE='"+bean.getTitle().trim()+"',\n"
	       		+ "CONTENT='"+bean.getContent().trim()+"',\n"
	       		+ "ATT_FILE1='"+bean.getAtt_file1().trim()+"',\n"
	       		+ "ATT_FILE2='"+bean.getAtt_file2().trim()+"',\n"
	       		+ "ATT_FILE3='"+bean.getAtt_file3().trim()+"',\n"
	       		+ "ATT_FILE4='"+bean.getAtt_file4().trim()+"',\n"
	       		+ "ATT_FILE5='"+bean.getAtt_file5().trim()+"'\n"
    	       	+ "WHERE B_ID="+bean.getB_id();

            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
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
     * 사내 게시판 한건 삭제
     */
    public int deleteBul(BulBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
        String query = "";
        String query2 = "";
        int count = 0;
        int count1 = 0;
                 
        query  = "DELETE BULLETIN WHERE B_ID="+bean.getB_id();
        query2 = "DELETE BUL_COMMENT WHERE B_ID="+bean.getB_id();
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);            
            count = pstmt.executeUpdate();

	
            pstmt2 = con.prepareStatement(query2);            
            count1 = pstmt2.executeUpdate();
             
            pstmt.close();
            pstmt2.close();
            con.commit();
		
			
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){ }
              
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        
        return count;
    }
    
	/**
     * 사내 게시판 삭제
     */
    public int deleteBul() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query="DELETE BULLETIN WHERE EXP_DT < to_char(sysdate,'YYYYMMDD')\n";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
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
     * 사내게시판 읽은거 체크
     */
    public int readChkBul(int b_id, String acar_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement stmt = null;
        int count = 0;
               
        String query = " UPDATE bulletin SET read_chk=concat(nvl(read_chk,''),'A"+acar_id+"') "+
				" WHERE b_id="+b_id+" and (read_chk is null or read_chk not like '%"+acar_id+"%')";
       try{   		   		
            con.setAutoCommit(false);                      
            stmt = con.createStatement();            
            count = stmt.executeUpdate(query);             
            stmt.close();
            con.commit();
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	//조회수 증가
    public void getHitAdd(int b_id)throws DatabaseException, DataSourceEmptyException{
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
               
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query = " update bulletin set visit_cnt= visit_cnt + 1 where b_id="+b_id;
		
        try{
            con.setAutoCommit(false);
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
            pstmt.close();
		    con.commit();
            
	  	} catch (Exception e) {
			  try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
		} finally {
			 try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
		
    }


	//----------------------------------------------------------------------------------------

    /**
     * 사내 게시판 댓글 등록
     */
    
    public int insertBulComment(BulCommentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
		try{
        
	       query ="insert into bul_comment (B_ID,SEQ,REG_DT,REG_ID,CONTENT)\n"
                      + "SELECT '"+bean.getB_id()+"',nvl(max(SEQ)+1,1), sysdate,\n"
					  + "'"+bean.getReg_id().trim()+"','"+bean.getContent().trim()+"'\n"
			   		  + "FROM bul_comment where b_id='"+bean.getB_id()+"'";

            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
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
     * 사내게시판 댓글
     */
    
    private BulCommentBean makeBulCommentBean(ResultSet results) throws DatabaseException {

        try {
            BulCommentBean bean = new BulCommentBean();

		    bean.setB_id(results.getInt("B_ID"));
		    bean.setSeq(results.getInt("SEQ"));
		    bean.setContent(results.getString("CONTENT"));	
			bean.setReg_id(results.getString("REG_ID"));
		    bean.setReg_dt(results.getString("REG_DT"));
			bean.setUser_nm(results.getString("USER_NM"));
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

	/**
     * 사내 게시판 댓글 리스트
     */
    
    public BulCommentBean [] getBulCommentList(int b_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
                        
        query = "select a.b_id, a.seq, a.reg_id, a.content, to_char(a.reg_dt,'YYYY-MM-DD') reg_dt, b.user_nm\n"   
				+ "from bul_comment a, users b\n"
				+ "where a.b_id="+b_id+" and a.reg_id=b.user_id order by a.reg_dt";
      
        Collection<BulCommentBean> col = new ArrayList<BulCommentBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeBulCommentBean(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (BulCommentBean[])col.toArray(new BulCommentBean[0]);
    }

}
