/**
 * 고객 불편사항 관리
 */
package acar.complain;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class ComplainDatabase {

    private static ComplainDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized ComplainDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new ComplainDatabase();
        return instance;
    }
    
    private ComplainDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

    /**
     * 불만사항
     */
    private OpinionBean makeOpinionBean(ResultSet results) throws DatabaseException {

        try {
        		OpinionBean bean = new OpinionBean();
            
            HashMap<String, String> columnMap = new HashMap<String, String>();
            
            ResultSetMetaData metaData = results.getMetaData();
            
            for (int i = 0; i < metaData.getColumnCount() ; i++) {
				columnMap.put(metaData.getColumnName(i + 1), "");
			}            
            
            bean.setSeq			(columnMap.get("SEQ") 		!= null ? results.getInt("SEQ") 			: 0 );
            bean.setGubun			(columnMap.get("GUBUN") 		!= null ? results.getString("GUBUN") 			: "" );
             bean.setEmail			(columnMap.get("EMAIL") 		!= null ? results.getString("EMAIL") 			: "" );
		    bean.setName			(columnMap.get("NAME") 		!= null ? results.getString("NAME") 			: "" );
		    bean.setTitle			(columnMap.get("TITLE") 		!= null ? results.getString("TITLE") 			: "" );
		    bean.setReg_dt		(columnMap.get("REG_DT") 		!= null ? results.getString("REG_DT") 			: "" );
		    bean.setTel				(columnMap.get("TEL") 		!= null ? results.getString("TEL") 			: "" );
		   
		    bean.setAcar_use		(columnMap.get("ACAR_USE") 		!= null ? results.getString("ACAR_USE") 			: "" ); 
		    bean.setContents			(columnMap.get("CONTENTS") 		!= null ? results.getString("CONTENTS") 			: "" );
		    bean.setAnswer			(columnMap.get("ANSWER") 		!= null ? results.getString("ANSWER") 			: "" );
		    bean.setAns_id			(columnMap.get("ANS_ID") 		!= null ? results.getString("ANS_ID") 			: "" );
		    bean.setAns_nm			(columnMap.get("ANS_NM") 		!= null ? results.getString("ANS_NM") 			: "" );
		    bean.setAns_dt			(columnMap.get("ANS_DT") 		!= null ? results.getString("ANS_DT") 			: "" );
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
    
	/**
     * 불편사항 등록.
     */
     
    public int insertComplain(OpinionBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
            
        String query = "";
        String query1 = "";
        
        int count = 0;
        int seq_no = 0;
                                  
      query = " INSERT INTO  OPINION  ( SEQ, GUBUN, EMAIL,  NAME, TEL,  ACAR_USE, TITLE, CONTENTS, REG_DT )  \n"+  //9
				" values(  ?, ? , ?, ?, ?, ?, ?, ?,  sysdate  )   \n";  // 9 ( syddate ) 
				
		query1= " select nvl(max(seq)+1,1) from OPINION ";
    
		try{
           	con.setAutoCommit(false);

	        pstmt1 = con.prepareStatement(query1);
	        
			rs = pstmt1.executeQuery();
	            if(rs.next()){
					seq_no = rs.getInt(1);
	            }
			rs.close();
			pstmt1.close();

	        pstmt = con.prepareStatement(query);
	        pstmt.setInt(1, seq_no);
	          pstmt.setString(2, bean.getGubun().trim());
	         pstmt.setString(3, bean.getEmail().trim());
			   pstmt.setString(4, bean.getName().trim());
			   pstmt.setString(5, bean.getTel().trim());
			   pstmt.setString(6, bean.getAcar_use().trim());
			   pstmt.setString(7, bean.getTitle().trim());
			   pstmt.setString(8, bean.getContents().trim());
	        count = pstmt.executeUpdate();
	       
	        pstmt.close(); 
            con.commit();                        

        }catch(Exception se){
			try{
				System.out.println("[ComplainDatabase:insertComplain]"+se);
       		         con.rollback();
            } catch(SQLException _ignored){}
			throw new DatabaseException("exception");
		} finally{
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
     * 답변 등록.
     */
     
    public int updateAnswer(int seq, String answer, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;            
        String query = "";
        
        int count = 0;
        int seq_no = 0;
        
        query = " update opinion  set answer=?, ans_id=?, ans_dt=sysdate WHERE SEQ = ?  \n";  // 8 ( syddate ) 
		
		try{
           	con.setAutoCommit(false);

	        pstmt = con.prepareStatement(query);
	        pstmt.setString(1, answer);
	        pstmt.setString(2, user_id);
	        pstmt.setInt(3, seq);	        
	        count = pstmt.executeUpdate();
	        pstmt.close(); 

            con.commit();                        

        }catch(Exception se){
			try{
				System.out.println("[ComplainDatabase:insertComplain]"+se);
       		         con.rollback();
            } catch(SQLException _ignored){}
			throw new DatabaseException("exception");
		} finally{
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
     * 불편사항 전체조회(fms)
     */
	 public OpinionBean [] getComplain2(String gubun, String gubun_nm, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";

        if(gubun.equals("title"))			subQuery = " and a.title like '%" + gubun_nm + "%' ";
        else if(gubun.equals("reg_dt"))		subQuery = " and to_char(a.reg_dt,'YYYYMMDD') =" + gubun_nm ;
        else if(gubun.equals("name"))		subQuery = " and a.name like '%" + gubun_nm + "%' ";
        else if(gubun.equals("c_year"))	    subQuery = " and to_char(a.reg_dt,'YYYY') = to_char(sysdate, 'yyyy') ";
        else if(gubun.equals("c_mon"))	    subQuery = " and to_char(a.reg_dt,'YYYYMM') = to_char(sysdate,'YYYYMM') ";
        else	                            subQuery = "";    
		
        query = " select a.seq, a.gubun, a.name, a.tel, a.email, a.answer, a.acar_use, a.title, a.contents, to_char(a.reg_dt, 'yyyy-mm-dd hh24:mi:ss' ) reg_dt, a.ans_id, a.ans_dt, b.user_nm as ans_nm \n"
               		+ " from opinion a, users b \n"
               		+ " where a.ans_id=b.user_id(+)  and a.gubun = 'C' \n"
               		+ subQuery;
     
        
        query += " order by DECODE(a.ans_id, null, '0', '1'), a.reg_dt desc ";

        Collection<OpinionBean> col = new ArrayList<OpinionBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
 
            while(rs.next()){
				col.add(makeOpinionBean(rs));
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
        return (OpinionBean[])col.toArray(new OpinionBean[0]);
    }
	 
	/**
	 * 불편사항 개별 조회
	 */    
	public OpinionBean getComplainBean(int seq) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
	    Connection con = connMgr.getConnection(DATA_SOURCE);
	    if(con == null) 
	        throw new DataSourceEmptyException("Can't get connection.!!");
	
	    OpinionBean ab;
	
	    Statement stmt = null;
	    ResultSet rs = null;
	    String query = "";
	    query =  " select a.seq, a.gubun, a.name, a.tel, a.email, a.answer, a.acar_use, a.title, a.contents, to_char(a.reg_dt, 'yyyy-mm-dd hh24:mi:ss' ) reg_dt, a.ans_id, a.ans_dt, b.user_nm as ans_nm  from opinion  a, users b \n"
	    			+ " where a.seq= " + seq
	    			+ " and a.ans_id=b.user_id(+)"; 
	    
	    try {
	        stmt = con.createStatement();
	        rs = stmt.executeQuery(query);
		
	        if (rs.next())
	            ab = makeOpinionBean(rs);
	        else
	            throw new UnknownDataException("Could not find Appcode # " + seq);
		
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
     *  의견 조회 fms)
     */
	 public OpinionBean [] getOpinionList(String s_yy, String s_mm, String email) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
     
        String query = "";

		   query = " select a.seq, a.gubun, a.name, a.tel, a.email, a.answer, a.acar_use, a.title, a.contents, to_char(a.reg_dt, 'yyyy-mm-dd hh24:mi:ss' ) reg_dt , a.ans_id, a.ans_dt, b.user_nm as ans_nm \n"
               		+ " from opinion a, users b \n"
               		+ " where a.ans_id=b.user_id(+)  and a.email = '" + email.trim() + "'"
               		+	"         ";
              		               		               		
		//	if(!s_yy.equals("") && !s_mm.equals(""))	query += " and  to_char(a.reg_dt , 'yyyymmdd')  between '"+s_yy+"' and '"+s_mm+"'";
		//	if(!s_yy.equals("") && s_mm.equals(""))		query += " and to_char(a.reg_dt, 'yyyymmdd')  like '%"+s_yy+"%'";
						
	        
 	     query += " order by a.reg_dt desc ";

        Collection<OpinionBean> col = new ArrayList<OpinionBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
 
            while(rs.next()){
				col.add(makeOpinionBean(rs));
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
        return (OpinionBean[])col.toArray(new OpinionBean[0]);
    }
    
       
    
}
