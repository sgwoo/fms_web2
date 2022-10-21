package common;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import acar.beans.AttachedFile;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;

public class AttachedDatabase{

    private static AttachedDatabase instance;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE = "acar"; 
 
    public static synchronized AttachedDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AttachedDatabase();
        return instance;
    }
    
    private AttachedDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }


    /**
     * 다중 첨부파일 저장.
     * @author Dev.ywkim
     * @since 2015. 04. 16
     * @param files
     * @see 테이블 SEQ에 트리거 걸려있음. 트리거 명 : ACAR_ATTACH_FILE_TRIGGER
     * @return
     * @throws DatabaseException
     * @throws DataSourceEmptyException
     */
	public boolean insertAttachedFileForMulti( List<AttachedFile> files ) throws DatabaseException, DataSourceEmptyException{
		
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
			throw new DataSourceEmptyException("Can't get Connection !!");
	        
		Statement stmt = null;
		int count = 0;

        String query = "";
        String query2 = "";
	     
        query = " INSERT ALL ";
	        
        for( AttachedFile file : files ){
        	query += " INTO ACAR_ATTACH_FILE   ";
        	query += " VALUES ";
        	query += " ( ";
        	query += " 		0 ";
        	query += " 		,'"+	file.getContentCode()	+"' ";
        	query += " 		,'" +	file.getContentSeq()	+"' ";
        	query += " 		,'"+	file.getFileName()		+"' ";
        	query += " 		,'"+	file.getFileSize()		+"' ";
        	query += " 		,'"+	file.getFileType()		+"' ";
        	query += " 		,'"+	file.getSaveFile()		+"' ";
        	query += " 		,'"+	file.getSaveFolder()	+"' ";
        	query += " 		,'"+	file.getRegUser()		+"' ";
        	query += " 		,SYSDATE ";
        	query += " 		,'N' ";
        	query += " ) ";
        }
        
        
        
        query += " SELECT * FROM DUAL ";
        System.out.println("============================ : " + query);
        
        
        try{
        	con.setAutoCommit(false);
            stmt = con.createStatement();
            count = stmt.executeUpdate(query);
            stmt.close();
            
            
            
            con.close();
            
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count > 0 ? true : false;
	}

	/**
	 * 단일 첨부파일 저장
	 * @author Dev.ywkim
	 * @since 2015. 04. 16
	 * @param file
	 * @return
	 * @throws DatabaseException
	 * @throws DataSourceEmptyException
	 */
	public boolean insertAttachedFileJustOne(AttachedFile file ) throws DatabaseException, DataSourceEmptyException{
		List<AttachedFile> files = new ArrayList<AttachedFile>();
		
		if( file != null  ){
			files.add(file);
		}
		
		return insertAttachedFileForMulti(files);
		
	}
	
	public List<AttachedFile> getAttachedFileInfoList(String contentCode, String contentSeq) throws DatabaseException, DataSourceEmptyException{
		return getAttachedFileInfoList(contentCode, contentSeq, 0);
	}
	
	/**
	 * 첨부파일 정보 가져오기 ( 다중. 리스트 형태 )
	 * @author Dev.ywkim
	 * @since 2015.04.16
	 * @param contentCode : 컨텐츠 코드
	 * @param contentSeq : 컨텐츠 시퀀스
	 * @param attachedSeq : 첨부파일 시퀀스 
	 * @return
	 * @throws DatabaseException 
	 * @throws DataSourceEmptyException 
	 */
	public List<AttachedFile> getAttachedFileInfoList(String contentCode, String contentSeq, int attachedSeq) throws DatabaseException, DataSourceEmptyException{
		
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");
        
        List<AttachedFile> result = new ArrayList<AttachedFile>();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";

        query += " SELECT A.SEQ, ";
        query += " 	A.CONTENT_CODE, ";
        query += " 	A.CONTENT_SEQ, ";
        query += " 	A.FILE_NAME, ";
        query += " 	A.FILE_SIZE, ";
        query += " 	A.FILE_TYPE, ";
        query += " 	A.SAVE_FILE, ";
        query += " 	A.SAVE_FOLDER, ";
        query += " 	A.REG_USERSEQ, ";
        query += " 	A.REG_DATE, ";
        query += " 	A.ISDELETED ";
        query += " FROM ACAR_ATTACH_FILE A ";
        query += " WHERE A.ISDELETED = 'N' ";
        
        if( contentCode != null && contentCode.length() > 0 ){
        	query += " AND A.CONTENT_CODE = '" + contentCode.toUpperCase() + "' ";
        }
        
        if( contentSeq != null && contentSeq.length() > 0 ){
        	query += " AND A.CONTENT_SEQ LIKE '%" + contentSeq + "%'";
        }
        
        if( attachedSeq > 0 ){
        	query += " AND A.SEQ = " + attachedSeq;	
        }
        
        query += " ORDER BY A.REG_DATE DESC ";
        
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            while (rs.next()) {
            	result.add(makeAttachedFileBean(rs));	
			}
            
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

		
		return result;	
	}
	
	public List<AttachedFile> getAttachedFileInfoList(String contentCode, String contentSeq, int attachedSeq, int attachedSize) throws DatabaseException, DataSourceEmptyException{
		
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");
        
        List<AttachedFile> result = new ArrayList<AttachedFile>();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";

        query += " SELECT A.SEQ, ";
        query += " 	A.CONTENT_CODE, ";
        query += " 	A.CONTENT_SEQ, ";
        query += " 	A.FILE_NAME, ";
        query += " 	A.FILE_SIZE, ";
        query += " 	A.FILE_TYPE, ";
        query += " 	A.SAVE_FILE, ";
        query += " 	A.SAVE_FOLDER, ";
        query += " 	A.REG_USERSEQ, ";
        query += " 	A.REG_DATE, ";
        query += " 	A.ISDELETED ";
        query += " FROM ACAR_ATTACH_FILE A ";
        query += " WHERE A.ISDELETED = 'N' ";
        
        if( contentCode != null && contentCode.length() > 0 ){
        	query += " AND A.CONTENT_CODE = '" + contentCode.toUpperCase() + "' ";
        }
        
        if( contentSeq != null && contentSeq.length() > 0 ){
        	query += " AND A.CONTENT_SEQ LIKE '%" + contentSeq + "%'";
        }
        
        if( attachedSeq > 0 ){
        	query += " AND A.SEQ = " + attachedSeq;	
        }
        
         if( attachedSize > 0 ){
        	query += " AND A.FILE_SIZE = " + attachedSize;	
        }
        
        query += " ORDER BY A.REG_DATE DESC ";
        
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            while (rs.next()) {
            	result.add(makeAttachedFileBean(rs));	
			}
            
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

		
		return result;	
	}
	
	/**
	 * 첨부파일 저장 정보 삭제처리
	 * @author Dev.ywkim
	 * @since 2015. 04. 17
	 * @param seq
	 */
	public boolean deleteFileForLogical(int seq) throws DatabaseException, DataSourceEmptyException{
		
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
			throw new DataSourceEmptyException("Can't get Connection !!");
	        
		Statement stmt = null;

        String query = "";
        int count = 0;
        
        query = " UPDATE ACAR_ATTACH_FILE SET ISDELETED = 'Y' WHERE SEQ =  " + seq;
        
        try{
        	con.setAutoCommit(false);
            stmt = con.createStatement();
            count = stmt.executeUpdate(query);
            stmt.close();
            con.close();
            
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count > 0 ? true : false;
	}
	
	/**
	 * 첨부파일 빈생성
	 * @author Dev.ywkim
	 * @since 2015. 04. 16
	 * @param results
	 * @return
	 * @throws DatabaseException
	 */
    @SuppressWarnings("unused")
	private AttachedFile makeAttachedFileBean(ResultSet results) throws DatabaseException {

        try {
        	AttachedFile bean = new AttachedFile();
            
            HashMap<String, String> columnMap = new HashMap<String, String>();
            
            ResultSetMetaData metaData = results.getMetaData();
            
            for (int i = 0; i < metaData.getColumnCount() ; i++) {
				columnMap.put(metaData.getColumnName(i + 1), "");
			}            
            
		    bean.setSeq			(columnMap.get("SEQ") 			!= null ? results.getInt("SEQ") 			: 0 	);
		    bean.setContentCode	(columnMap.get("CONTENT_CODE")	!= null ? results.getString("CONTENT_CODE")	: ""	);
		    bean.setContentSeq	(columnMap.get("CONTENT_SEQ")	!= null ? results.getString("CONTENT_SEQ") 	: "0"	);
		    bean.setFileName	(columnMap.get("FILE_NAME")		!= null ? results.getString("FILE_NAME")	: ""	);
		    bean.setFileSize	(columnMap.get("FILE_SIZE")		!= null ? results.getLong("FILE_SIZE") 		: 0		);
		    bean.setFileType	(columnMap.get("FILE_TYPE")		!= null ? results.getString("FILE_TYPE")	: ""	);
		    bean.setSaveFile	(columnMap.get("SAVE_FILE")		!= null ? results.getString("SAVE_FILE")	: ""	);
		    bean.setSaveFolder	(columnMap.get("SAVE_FOLDER")	!= null ? results.getString("SAVE_FOLDER")	: ""	);
		    bean.setRegUser		(columnMap.get("REG_USERSEQ")	!= null ? results.getString("REG_USERSEQ")	: "0"	);
		    bean.setRegDate		(columnMap.get("REG_DATE") 		!= null ? results.getString("REG_DATE")		: ""	);
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
	 * 중복처리 ( 단일. contentCode,content_seq )
	 * @author Dev.jhchoi
	 * @since 2015.04.16
	 * @param contentCode : 컨텐츠 코드
	 * @param contentSeq : 컨텐츠 시퀀스
	 * @return 
	 * @throws DatabaseException 
	 * @throws DataSourceEmptyException 
	 */
	public int getAttachedCheckOverFile(String contentCode,String contentSeq) throws DatabaseException, DataSourceEmptyException{
		
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";

        int count =0;
        query = " SELECT COUNT(*) FROM ACAR_ATTACH_FILE WHERE content_code ='"+contentCode+"' AND content_seq ='"+contentSeq+"' AND ISDELETED = 'N'";
        
        System.out.println(query);
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())count = rs.getInt(1);
            
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

		
		return count;	
	}
	
}