/**
 * 공지사항
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.off_anc;

import java.util.*;
import java.sql.*;
import java.io.CharArrayReader;
import java.io.IOException;
import java.io.Reader;
import java.io.Writer;

import acar.util.*;

import java.text.*;
import java.net.*;

import oracle.jdbc.*;
import oracle.sql.CLOB;

import javax.servlet.http.HttpServletRequest;

import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;
import acar.util.LoginBean;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

public class OffAncDatabase {

    private static OffAncDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized OffAncDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new OffAncDatabase();
        return instance;
    }
    
    private OffAncDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	
	
	/**
     * 공지사항
     * @modify : Dev.ywkim 
     * @modify_desc : ResultSet 동적 처리 수정
     */
    private AncBean makeAncBean(ResultSet results) throws DatabaseException {

        try {
            AncBean bean = new AncBean();
            
            HashMap<String, String> columnMap = new HashMap<String, String>();
            
            ResultSetMetaData metaData = results.getMetaData();
            
            for (int i = 0; i < metaData.getColumnCount() ; i++) {
				columnMap.put(metaData.getColumnName(i + 1), "");
			}            
            
		    bean.setBbs_id		(columnMap.get("BBS_ID") 		!= null ? results.getInt("BBS_ID") 			: 0 );
		    bean.setUser_id		(columnMap.get("USER_ID") 		!= null ? results.getString("USER_ID") 		: "");
		    bean.setUser_nm		(columnMap.get("USER_NM") 		!= null ? results.getString("USER_NM") 		: "");
		    bean.setBr_id		(columnMap.get("BR_ID") 		!= null ? results.getString("BR_ID") 		: "");
		    bean.setBr_nm		(columnMap.get("BR_NM") 		!= null ? results.getString("BR_NM") 		: "");
		    bean.setDept_id		(columnMap.get("DEPT_ID") 		!= null ? results.getString("DEPT_ID") 		: "");
		    bean.setDept_nm		(columnMap.get("DEPT_NM") 		!= null ? results.getString("DEPT_NM") 		: "");
		    bean.setReg_dt		(columnMap.get("REG_DT") 		!= null ? results.getString("REG_DT") 		: "");
		    bean.setExp_dt		(columnMap.get("EXP_DT") 		!= null ? results.getString	 ("EXP_DT") 	: "");
		    bean.setTitle		(columnMap.get("TITLE") 		!= null ? results.getString("TITLE") 		: "");
		    bean.setContent		(columnMap.get("CONTENT") 		!= null ? results.getString("CONTENT") 		: "");	
		    bean.setRead_chk	(columnMap.get("READ_CHK") 		!= null ? results.getString("READ_CHK") 	: "");	
		    bean.setUse_chk		(columnMap.get("USE_CHK") 		!= null ? results.getString("USE_CHK") 		: "");	
		    bean.setComment_cnt	(columnMap.get("COMMENT_CNT") 	!= null ? results.getString("COMMENT_CNT") 	: "");	
		    bean.setRead_yn		(columnMap.get("READ_YN") 		!= null ? results.getString("READ_YN") 		: "");
			bean.setBbs_st		(columnMap.get("BBS_ST") 		!= null ? results.getString	 ("BBS_ST") 	: "");
			bean.setAtt_file1	(columnMap.get("ATT_FILE1") 	!= null ? results.getString("ATT_FILE1") 	: "");
			bean.setAtt_file2	(columnMap.get("ATT_FILE2") 	!= null ? results.getString("ATT_FILE2") 	: "");
			bean.setAtt_file3	(columnMap.get("ATT_FILE3") 	!= null ? results.getString("ATT_FILE3") 	: "");
			bean.setAtt_file4	(columnMap.get("ATT_FILE4") 	!= null ? results.getString("ATT_FILE4") 	: "");
			bean.setAtt_file5	(columnMap.get("ATT_FILE5") 	!= null ? results.getString("ATT_FILE5") 	: "");
			bean.setP_view		(columnMap.get("P_VIEW") 		!= null ? results.getString("P_VIEW") 		: "");
			
			bean.setComst		(columnMap.get("COMST") 		!= null ? results.getString("COMST") 		: "");
			bean.setScm_yn		(columnMap.get("SCM_YN") 		!= null ? results.getString("SCM_YN") 		: "");
			bean.setExp_dt_chg_yn(columnMap.get("EXP_DT_CHG_YN")!= null ? results.getString("EXP_DT_CHG_YN"): "");
			bean.setImpor_yn	(columnMap.get("IMPOR_YN")		!= null ? results.getString("IMPOR_YN")		: "");	//20181121
			
			//20211220
			bean.setKeywords	(columnMap.get("KEYWORDS") 		!= null ? results.getString("KEYWORDS")		: "");
			bean.setCar_comp_id	(columnMap.get("CAR_COMP_ID") 	!= null ? results.getString("CAR_COMP_ID")	: "");
			bean.setCar_cd		(columnMap.get("CAR_CD") 		!= null ? results.getString("CAR_CD")		: "");
			bean.setEnd_st		(columnMap.get("END_ST") 		!= null ? results.getString("END_ST")		: ""); 


            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	
		
	/**
     * 공지사항_경조사
     */
    private Bbs_FBean makeBbs_FBean(ResultSet results) throws DatabaseException {

        try {
            Bbs_FBean bean = new Bbs_FBean();

		    bean.setBbs_id(results.getInt		 ("BBS_ID"));
		    bean.setD_user_id(results.getString	 ("D_USER_ID"));
		    bean.setD_user_nm(results.getString	 ("D_USER_NM"));
		    bean.setD_br_id(results.getString	 ("D_BR_ID"));
		    bean.setD_br_nm(results.getString	 ("D_BR_NM"));
		    bean.setD_dept_id(results.getString	 ("D_DEPT_ID"));
		    bean.setD_dept_nm(results.getString	 ("D_DEPT_NM"));
		    bean.setD_user_h_tel(results.getString	 ("D_USER_H_TEL"));
		    bean.setD_day_st(results.getString	 ("D_DAY_ST"));	
		    bean.setD_day_ed(results.getString	 ("D_DAY_ED"));	
		    bean.setPlace_nm(results.getString	 ("PLACE_NM"));	
		    bean.setPlace_tel(results.getString("PLACE_TEL"));	
		    bean.setPlace_addr(results.getString	 ("PLACE_ADDR"));
			bean.setChief_nm(results.getString	 ("CHIEF_NM"));
			bean.setD_day_place(results.getString	 ("D_DAY_PLACE"));
			bean.setFamily_relations(results.getString	 ("FAMILY_RELATIONS"));
			bean.setDeceased_nm(results.getString	 ("DECEASED_NM"));
			bean.setDeceased_day(results.getString	 ("DECEASED_DAY"));
			bean.setTitle_st(results.getString	 ("TITLE_ST"));


            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	
 	/**
     * 공지사항 개별 조회
     */    
    public AncBean getAncBean(int bbs_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        AncBean ab;

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID, c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT, substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT, a.title as TITLE, a.content as CONTENT,\n"   
				+ " a.read_chk, '' use_chk, e.comment_cnt, a.read_yn, a.bbs_st,  nvl(a.comst,'N') comst,\n"   
				+ " a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5, a.p_view as P_VIEW, a.scm_yn, a.EXP_DT_CHG_YN, a.IMPOR_YN, a.keywords, a.car_comp_id, a.car_cd, a.end_st \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ " where a.bbs_id=" + bbs_id + " and a.user_id=b.user_id and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+)\n";


        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
		

            if (rs.next())
                ab = makeAncBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + bbs_id );
 		
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
     * 마지막 공지사항 조회
     */    
    public AncBean getAncLastBean() throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        AncBean ab = new AncBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID, c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT, substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT, a.title as TITLE, a.content as CONTENT, \n"   
				+ " a.read_chk, '' use_chk, e.comment_cnt, a.read_yn, a.bbs_st, nvl(a.comst,'N') comst,\n"   
				+ " a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5, a.p_view as P_VIEW, a.scm_yn, a.exp_dt_chg_yn, a.impor_yn \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ " where a.bbs_st in ('1','4','6') and a.exp_dt >= to_char(sysdate,'YYYYMMDD') and a.user_id=b.user_id and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+) order by a.reg_dt desc, a.bbs_id desc\n";


        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                ab = makeAncBean(rs);
           
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
     * 마지막 공지사항 조회
     */    
    public AncBean getAncLastBeanA() throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        AncBean ab = new AncBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID, c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT, substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT, a.title as TITLE, a.content as CONTENT, \n"   
				+ " a.read_chk, '' use_chk, e.comment_cnt, a.read_yn, a.bbs_st, nvl(a.comst,'N') comst,\n"   
				+ " a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW , a.scm_yn, a.exp_dt_chg_yn, a.impor_yn \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ " where a.exp_dt >= to_char(sysdate,'YYYYMMDD') and a.user_id=b.user_id and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+) and (a.bbs_st ='8' or a.p_view in ('A','J')) order by a.reg_dt desc, a.bbs_id desc\n";


        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                ab = makeAncBean(rs);
           
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
     * 마지막 공지사항 조회 - 협력업체에 띄우기
     */    
    public AncBean getAncLastBeanP() throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        AncBean ab = new AncBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID, c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT, substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT, a.title as TITLE, a.content as CONTENT, \n"   
				+ " a.read_chk, '' use_chk, e.comment_cnt, a.read_yn, a.bbs_st, nvl(a.comst,'N') comst,\n"   
				+ " a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW ,  a.scm_yn, a.exp_dt_chg_yn, a.impor_yn \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ " where a.bbs_st in ('1','4','6') AND a.P_VIEW = 'Y' and a.exp_dt >= to_char(sysdate,'YYYYMMDD') and a.user_id=b.user_id and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+) order by a.reg_dt desc, a.bbs_id desc\n";


        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                ab = makeAncBean(rs);
           
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
     * 공지사항 전체조회(메인에 각 카테고리 별 리스트 보여주는 부분)
     */
    public AncBean [] getAncAll(String acar_id) throws DatabaseException, DataSourceEmptyException{
    	return getAncProc(null, acar_id);
    }

	/**
     * 공지사항 전체조회(메인에 각 카테고리 별 리스트 보여주는 부분)
     * 세션값을 받아 처리할때 사용
     */
    public AncBean [] getAncAll(HttpServletRequest request, String acar_id) throws DatabaseException, DataSourceEmptyException{
    	return getAncProc(request, acar_id);
    }
	public AncBean [] getAncAll(HttpServletRequest request, String acar_id,String gubun) throws DatabaseException, DataSourceEmptyException{
    	return getAncProc2(request, acar_id, gubun);
    }
	

	/**
     * 공지사항 전체조회(메인에 각 카테고리 별 리스트 보여주는 부분)
     */
    public AncBean [] getAncProc(HttpServletRequest request, String acar_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";

	 query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID,"+
				" c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, "+
				" substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT,"+
				" substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT,"+
				" a.title as TITLE, a.content as CONTENT,"+
				" decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk,\n"+
				" decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') use_chk, e.comment_cnt, a.read_yn, a.bbs_st, nvl(a.comst,'N') comst,\n"
				+ " a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW ,  a.scm_yn, a.exp_dt_chg_yn, a.impor_yn \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ "where a.user_id=b.user_id\n"
				+ subQuery
				+ "and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+)\n"
				+ "and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        


        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        

        if( request != null ){
        	LoginBean lb = LoginBean.getInstance();
        	String dept_id = lb.getSessionValue(request, "DEPT_ID");
        	
        	if( dept_id.equals("1000") || dept_id.equals("8888") ){
	        	String extType = "P";
	        	
	        	if( dept_id.equals("1000") ){
	        		extType = "A";
	        	}
	        	
	        	query += " AND ( P_VIEW ='J' OR P_VIEW = '"+extType+"' ) ";
        	}        	
        }
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";
        //query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.reg_dt desc";


        Collection<AncBean> col = new ArrayList<AncBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeAncBean(rs));
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
        return (AncBean[])col.toArray(new AncBean[0]);
    }

/**
     * 공지사항 전체조회2(메인에 각 카테고리 별 리스트 보여주는 부분 수정)
     */
    public AncBean [] getAncProc2(HttpServletRequest request, String acar_id, String gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
		if(gubun.equals("gong")){
			subQuery = " and a.bbs_st in('1','4','5','6') \n";
		}else if(gubun.equals("pan")){
			subQuery = " and a.bbs_st in('3') \n";
		}else if(gubun.equals("up")){
			subQuery = " and a.bbs_st in('7') \n";
		}
	 query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID,"+
				" c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, "+
				" substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT,"+
				" substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT,"+
				" a.title as TITLE, a.content as CONTENT,"+
				" decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk,\n"+
				" decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') use_chk, e.comment_cnt, a.read_yn, a.bbs_st, nvl(a.comst,'N') comst,\n"
				+ " a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW ,  a.scm_yn, a.exp_dt_chg_yn, a.impor_yn \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ "where a.user_id=b.user_id\n"
				+ subQuery
				+ "and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+)\n"
				+ "and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        


        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        

        if( request != null ){
        	LoginBean lb = LoginBean.getInstance();
        	String dept_id = lb.getSessionValue(request, "DEPT_ID");
        	
        	if( dept_id.equals("1000") || dept_id.equals("8888") ){
	        	String extType = "P";
	        	
	        	if( dept_id.equals("1000") ){
	        		extType = "A";
	        	}
	        	
	        	query += " AND ( P_VIEW ='J' OR P_VIEW = '"+extType+"' ) ";
        	}        	
        }
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";
        //query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.reg_dt desc";


        Collection<AncBean> col = new ArrayList<AncBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeAncBean(rs));
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
        return (AncBean[])col.toArray(new AncBean[0]);
    }

 	public AncBean [] getAncAll(String acar_id, String bbs_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";

	 query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID,"+
				" c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, "+
				" substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT,"+
				" substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT,"+
				" a.title as TITLE, a.content as CONTENT,"+
				" decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk,\n"+
				" decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') use_chk, e.comment_cnt, a.read_yn, a.bbs_st, nvl(a.comst,'N') comst,\n"
				+ " a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW, a.impor_yn \n"
				+ "from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ "where a.user_id=b.user_id\n"
				+ subQuery
				+ "and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+)\n"
				+ "and a.exp_dt >= to_char(sysdate,'YYYYMMDD') and a.bbs_st='"+bbs_st+"'";
        


        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";
        //query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.reg_dt desc";

        Collection<AncBean> col = new ArrayList<AncBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeAncBean(rs));
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
        return (AncBean[])col.toArray(new AncBean[0]);
    }

	/**
     * 공지사항 전체조회(리스트)
     */
    public AncBean [] getAncAll(String gubun, String gubun_nm, String acar_id) throws DatabaseException, DataSourceEmptyException{
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
        
        query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID,"+
				" c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, "+
				" substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT,"+
				" substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT,"+
				" a.title as TITLE, a.content as CONTENT,"+
				" decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk,\n"+
				" decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') use_chk, e.comment_cnt, a.read_yn, a.bbs_st, nvl(a.comst,'N') comst,  \n" +
				" a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW , a.scm_yn, a.exp_dt_chg_yn, a.impor_yn \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ " where a.user_id=b.user_id\n"
				+ subQuery
				+ " and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+)\n";
        
        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";
      
        Collection<AncBean> col = new ArrayList<AncBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
      
            while(rs.next()){
				col.add(makeAncBean(rs));
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
        return (AncBean[])col.toArray(new AncBean[0]);
    }
   
    /**
     * 프레임 헤더 Top 롤링 부분 공지사항 조회
     * @since 2015.04.14
     * @author Dev.ywkim
     * @param gubun
     * @param gubun_nm
     * @param acar_id
     * @return
     * @throws DatabaseException
     * @throws DataSourceEmptyException
     */
    public AncBean [] getAncFrameTop(String gubun, String gubun_nm, String acar_id, String extType) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;

        String query = "";
     
        query = " SELECT  ";
        query += "	BBS_ID ";
        query += "	, TITLE ";
        query += "	, BBS_ST ";
        query += "	, READ_YN, IMPOR_YN ";
        query += "	,SUBSTR(reg_dt,1,4)||'-'||SUBSTR(reg_dt,5,2)||'-'||SUBSTR(reg_dt,7,2) AS REG_DT ";
        query += " FROM BBS ";
        query += " WHERE bbs_st NOT IN ('8')  ";
        query += " AND exp_dt >= TO_CHAR(sysdate,'YYYYMMDD') ";
        if( extType != null && extType.length() > 0 ){
        	query += " AND ( P_VIEW ='J' OR P_VIEW = '"+extType+"' )  ";
        }
        query += " ORDER BY DECODE(SIGN(exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') DESC ";
        query += " ,read_yn ";
        query += " ,bbs_id DESC ";
        
        Collection<AncBean> col = new ArrayList<AncBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
      
            while(rs.next()){
				col.add(makeAncBean(rs));
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
        return (AncBean[])col.toArray(new AncBean[0]);
    }

	/**
     * 공지사항 전체조회(리스트) - 추가 : 카테고리별 검색
     */
	 public AncBean [] getAncAll2(String gubun, String gubun_nm, String gubun1, String acar_id) throws DatabaseException, DataSourceEmptyException{
		 
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
			
        if (gubun.equals("title")) {
        	subQuery = " and a.title like '%" + gubun_nm + "%'\n";
        } else if (gubun.equals("content")) {
        	subQuery = " and a.content like '%" + gubun_nm + "%'\n";
        } else if (gubun.equals("reg_dt")) {
        	subQuery = " and a.reg_dt >= replace('" + gubun_nm + "','-','')\n";
        } else if (gubun.equals("user_nm")) {
        	subQuery = " and b.user_nm like '%" + gubun_nm + "%'\n";
        } else if (gubun.equals("c_year")) {
        	subQuery = " and a.reg_dt like to_char(sysdate, 'yyyy')||'%' \n";
        } else if (gubun.equals("c_mon"))	 {
        	subQuery = " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        } else	{
        	subQuery = "";        
        }

        query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID,"+
				" c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, "+
				" substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT,"+
				" substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT,"+
				" a.title as TITLE, a.content as CONTENT,"+
				" decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk,\n"+
				" a.bbs_st,\n"+
				" decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') use_chk, e.comment_cnt, a.read_yn, nvl(a.comst,'N') comst,  \n" +
				" a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW , a.scm_yn, a.exp_dt_chg_yn, a.impor_yn  \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ " where a.user_id=b.user_id \n"
				+ subQuery
				+ " and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+) \n";

        if(acar_id.equals("") || gubun.equals("agent"))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
      
        if ( acar_id.equals("000071") ||   acar_id.equals("000194")  ) {  //CALL
     		  query += " and a.user_id  in ( '000071', '000194' )" ;
       }  
       
		
		if (   gubun1.equals("") ) {
			query += " and a.bbs_st not in ( '7', '8', '9' ) ";	 
		} else if ( gubun1.equals("8") ) {
			 query += " and (a.bbs_st = '" + gubun1 + "' or a.P_VIEW IN ('A','J')) ";	 
   	    } else {
			 query += " and a.bbs_st = '" + gubun1 + "'";	 
   	    } 		  
      		
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";


        Collection<AncBean> col = new ArrayList<AncBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            


            while(rs.next()){
				col.add(makeAncBean(rs));
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
        return (AncBean[])col.toArray(new AncBean[0]);
    }

	/**
     * 에이전트 공지 조회
     */
	 public AncBean [] getAgent_AncAll(String gubun, String gubun_nm, String gubun1, String acar_id) throws DatabaseException, DataSourceEmptyException{
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
        else if(gubun.equals("c_year"))	    subQuery = " and a.reg_dt like to_char(sysdate, 'yyyy')||'%' \n";
        else if(gubun.equals("c_mon"))	    subQuery = " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        else	                            subQuery = "";        

        query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID,"+
				" c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, "+
				" substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT,"+
				" substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT,"+
				" a.title as TITLE, a.content as CONTENT,"+
				" decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk,\n"+
				" a.bbs_st,\n"+
				" decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') use_chk, e.comment_cnt, a.read_yn, nvl(a.comst,'N') comst,  \n" +
				" a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW , a.scm_yn, a.exp_dt_chg_yn, a.impor_yn  \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ " where a.user_id=b.user_id \n"
				+ subQuery
				+ " and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+)  AND( a.bbs_st = '8' or a.P_VIEW  IN ('A','J'))   \n";

        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";
      
        Collection<AncBean> col = new ArrayList<AncBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            while(rs.next()){
				col.add(makeAncBean(rs));
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
        return (AncBean[])col.toArray(new AncBean[0]);
    }
	 
	 /**
	     * 협력업체 공지 조회
	     */
		 public AncBean [] getOff_AncAll(String gubun, String gubun_nm, String gubun1, String acar_id) throws DatabaseException, DataSourceEmptyException{
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
	        else if(gubun.equals("c_year"))	    subQuery = " and a.reg_dt like to_char(sysdate, 'yyyy')||'%' \n";
	        else if(gubun.equals("c_mon"))	    subQuery = " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'\n";
	        else	                            subQuery = "";        

	        query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID,"+
					" c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, "+
					" substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT,"+
					" substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT,"+
					" a.title as TITLE, a.content as CONTENT,"+
					" decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk,\n"+
					" a.bbs_st,\n"+
					" decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') use_chk, e.comment_cnt, a.read_yn, nvl(a.comst,'N') comst,  \n" +
					" a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW , a.scm_yn, a.exp_dt_chg_yn, a.impor_yn  \n"
					+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
					+ " where a.user_id=b.user_id \n"
					+ subQuery
					+ " and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+)  AND( a.bbs_st='9' or a.P_VIEW  IN ('Y', 'J'))   \n";

	        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
	        
	        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";
	      
	        Collection<AncBean> col = new ArrayList<AncBean>();
	        try{
	            stmt = con.createStatement();
	            rs = stmt.executeQuery(query);
	            
	            while(rs.next()){
					col.add(makeAncBean(rs));
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
	        return (AncBean[])col.toArray(new AncBean[0]);
	    }


    /**
     * 공지사항 등록
     */
    public int insertAnc(AncBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
		String exp_dt = bean.getExp_dt().trim();
    
		
		try{
        
			if(!exp_dt.equals("")){	
		       query ="insert into bbs(BBS_ID, USER_ID, REG_DT, EXP_DT, TITLE, CONTENT, READ_YN, BBS_ST, ATT_FILE1, VISIT_CNT, ATT_FILE2, ATT_FILE3, ATT_FILE4, ATT_FILE5, COMST, P_VIEW, SCM_YN)\n"
                      + "SELECT nvl(max(BBS_ID)+1,1),'"+bean.getUser_id().trim()+"',\n"
					  + "to_char(sysdate,'YYYYMMDD'),replace('"+bean.getExp_dt().trim()+"','-',''),\n"
					  + "'"+bean.getTitle().trim()+"','"+bean.getContent().trim()+"','"+bean.getRead_yn().trim()+"','"+bean.getBbs_st().trim()+"',\n"
					  + "'"+bean.getAtt_file1().trim()+"',0,'"+bean.getAtt_file2().trim()+"',\n"
 					  + "'"+bean.getAtt_file3().trim()+"','"+bean.getAtt_file4().trim()+"','"+bean.getAtt_file5().trim()+"','"+bean.getComst().trim()+"','"+bean.getP_view().trim()+"','"+bean.getScm_yn().trim()+"'\n"
			   		  + "FROM BBS\n";
			}else{
		       query ="insert into bbs(BBS_ID, USER_ID, REG_DT, EXP_DT, TITLE, CONTENT, READ_YN, BBS_ST, ATT_FILE1, VISIT_CNT, ATT_FILE2, ATT_FILE3, ATT_FILE4, ATT_FILE5, COMST, P_VIEW, SCM_YN)\n"
                      + "SELECT nvl(max(BBS_ID)+1,1),'"+bean.getUser_id().trim()+"',\n"
					  + "to_char(sysdate,'YYYYMMDD'),to_char(sysdate+7,'YYYYMMDD'),\n"
					  + "'"+bean.getTitle().trim()+"','"+bean.getContent().trim()+"','"+bean.getRead_yn().trim()+"','"+bean.getBbs_st().trim()+"',\n"
					  + "'"+bean.getAtt_file1().trim()+"',0,'"+bean.getAtt_file2().trim()+"',\n"
 					  + "'"+bean.getAtt_file3().trim()+"','"+bean.getAtt_file4().trim()+"','"+bean.getAtt_file5().trim()+"','"+bean.getComst().trim()+"','"+bean.getP_view().trim()+"','"+bean.getScm_yn().trim()+"'\n"
			   		  + "FROM BBS\n";
			}



            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("insertAnc: "+se);
			System.out.println("insertAnc: "+query);
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
     * 공지사항 수정
     */
    public int updateAnc(AncBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
      
      
        try{
            
	       query="UPDATE BBS\n"
    		   	+ "SET EXP_DT=replace('"+bean.getExp_dt().trim()+"','-',''),\n"
       			+ "TITLE='"+bean.getTitle().trim()+"',\n"
	       		+ "CONTENT='"+bean.getContent().trim()+"',\n"
	       		+ "READ_YN='"+bean.getRead_yn().trim()+"',\n"
				+ "BBS_ST='"+bean.getBbs_st().trim()+"',\n"
				+ "ATT_FILE1='"+bean.getAtt_file1().trim()+"',\n"
	       		+ "ATT_FILE2='"+bean.getAtt_file2().trim()+"',\n"
	       		+ "ATT_FILE3='"+bean.getAtt_file3().trim()+"',\n"
	       		+ "ATT_FILE4='"+bean.getAtt_file4().trim()+"',\n"
	       		+ "ATT_FILE5='"+bean.getAtt_file5().trim()+"',\n"
				+ "COMST='"+bean.getComst()+"',\n"
				+ "SCM_YN='"+bean.getScm_yn()+"',\n"
	       		+ "P_VIEW='"+bean.getP_view()+"',\n"
	       		+ "EXP_DT_CHG_YN='"+bean.getExp_dt_chg_yn().trim()+"'\n"
    	       	+ "WHERE BBS_ID="+bean.getBbs_id();

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
     * 공지사항 한건 삭제
     */
   

      public int deleteAnc(AncBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
		PreparedStatement pstmt6 = null;
        ResultSet rs = null;
        ResultSet rs1 = null;
        	
        String query = "";
        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
        String query5 = "";
        int count = 0;
        int count1 = 0;
        int count2 = 0;
        int count3 = 0;
        int count4 = 0;
        int b_cnt = 0;
        int b_cnt1 = 0;
               
        query  = "DELETE BBS WHERE BBS_ID='"+bean.getBbs_id()+"'";
        query1 = "SELECT COUNT(0) FROM BBS_COMMENT WHERE BBS_ID='"+bean.getBbs_id()+"'";
        query2 = "DELETE BBS_COMMENT WHERE BBS_ID='"+bean.getBbs_id()+"'";
		query3 = "DELETE BBS_FAMILY WHERE BBS_ID='"+bean.getBbs_id()+"'";
		query4 = "SELECT COUNT(0) FROM ACAR_ATTACH_FILE WHERE  CONTENT_CODE='BBS' AND ISDELETED='N' AND SUBSTR(CONTENT_SEQ, 0, 4)='"+bean.getBbs_id()+"'";
		query5 = "UPDATE ACAR_ATTACH_FILE SET ISDELETED='Y' WHERE CONTENT_CODE='BBS' AND SUBSTR(CONTENT_SEQ, 0, 4)='"+bean.getBbs_id()+"'";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);            
            count1 = pstmt.executeUpdate();
  			pstmt.close();
			
  			
			pstmt6 = con.prepareStatement(query1);
			rs = pstmt6.executeQuery();
			if(rs.next()){
				b_cnt = rs.getInt(1);
			}
			rs.close();
			pstmt6.close();

			if (b_cnt > 0) {
	            pstmt2 = con.prepareStatement(query2);            
	            count2 = pstmt2.executeUpdate();
	            pstmt2.close();
            }
			
			
			pstmt3 = con.prepareStatement(query3);            
			count3 = pstmt3.executeUpdate();
			pstmt3.close();
			
			
			pstmt4 = con.prepareStatement(query4);
			rs1 = pstmt4.executeQuery();
			if(rs1.next()){
				b_cnt1 = rs1.getInt(1);
			}
			rs1.close();
			pstmt4.close();

			if (b_cnt1 > 0) {
	            pstmt5 = con.prepareStatement(query5);            
	            count4 = pstmt5.executeUpdate();
	            pstmt5.close();	            
            }
			
  			count = count1 + count2 + count3 + count4;
 
 			con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                
				con.setAutoCommit(true);
				if(rs != null) rs.close();
				if(rs1 != null) rs1.close();
                if(pstmt != null) pstmt.close();
                if(pstmt1 != null) pstmt1.close();
				if(pstmt2 != null) pstmt2.close();
				if(pstmt3 != null) pstmt3.close();
				if(pstmt4 != null) pstmt4.close();
				if(pstmt5 != null) pstmt5.close();
				if(pstmt6 != null) pstmt6.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
      
  /**
   * 공지사항 댓글 한건 삭제 (추가 2017.08.16)
   */
  public int deleteAncComment(String bbs_id, int bbs_comment_seq) throws DatabaseException, DataSourceEmptyException{
      Connection con = connMgr.getConnection(DATA_SOURCE);

      if(con == null)
          throw new DataSourceEmptyException("Can't get Connection !!");
      PreparedStatement pstmt = null;
      String query = "";
      int count = 0;
             
      int bbs_id2 = Integer.parseInt(bbs_id); 
      
      query="DELETE BBS_COMMENT WHERE BBS_ID=? AND SEQ=?";
   
         try{  
              con.setAutoCommit(false);
                        
              pstmt = con.prepareStatement(query);
              
              pstmt.setInt(1, bbs_id2);
              pstmt.setInt(2, bbs_comment_seq);
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
     * IP Login수정
     */
    public int updateLogin(String ip, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query="UPDATE ip_mng\n"
        	+ "SET login_dt=sysdate, loginout='Y'\n"
            + "WHERE user_id=? and ip=?";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, user_id.trim());
            pstmt.setString(2, ip.trim());
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
     * IP Logout수정
     */
    public int updateLogout(String ip, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query="UPDATE ip_mng \n"
        	+ "SET logout_dt=sysdate, loginout='N'\n"
            + "WHERE user_id=? and ip=?";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, user_id.trim());
            pstmt.setString(2, ip.trim());
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
     * IP Log 등록
     */
    public int insertLoginLog(String ip, String user_id, String login_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query="insert into ip_log(ip, user_id, login_dt)\n"
        	+ "values (?,?,to_date(?, 'YYYYMMDDHH24MISS'))\n";
        try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, ip.trim());
            pstmt.setString(2, user_id.trim());
            pstmt.setString(3, login_dt.trim());
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
     * IP Log 등록
     */
    public int insertLoginLog(String ip, String user_id, String login_dt, String mobile_yn) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	PreparedStatement pstmt = null;
    	String query = "";
    	int count = 0;
    	
    	query="insert into ip_log(ip, user_id, login_dt, mobile_yn)\n"
    			+ "values (?,?,to_date(?, 'YYYYMMDDHH24MISS'), ?)\n";
    	try{
    		
    		con.setAutoCommit(false);
    		
    		pstmt = con.prepareStatement(query);
    		
    		pstmt.setString(1, ip.trim());
    		pstmt.setString(2, user_id.trim());
    		pstmt.setString(3, login_dt.trim());
    		pstmt.setString(4, mobile_yn.trim());
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
     * IP Log 등록
     */
    public int insertLoginLog2(String ip, String user_id, String login_dt, String kakao_id, String kakao_email) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	PreparedStatement pstmt = null;
    	String query = "";
    	int count = 0;
    	
    	query="insert into ip_log(ip, user_id, login_dt, kakao_id, kakao_email)\n"
    			+ "values (?,?,to_date(?, 'YYYYMMDDHH24MISS'),?,?)\n";
    	try{
    		
    		con.setAutoCommit(false);
    		
    		pstmt = con.prepareStatement(query);
    		
    		pstmt.setString(1, ip.trim());
    		pstmt.setString(2, user_id.trim());
    		pstmt.setString(3, login_dt.trim());
    		pstmt.setString(4, kakao_id.trim());
    		pstmt.setString(5, kakao_email.trim());
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
     * IP Log 등록
     */
    public int insertLoginLog2(String ip, String user_id, String login_dt, String kakao_id, String kakao_email, String mobile_yn) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	PreparedStatement pstmt = null;
    	String query = "";
    	int count = 0;
    	
    	query="insert into ip_log(ip, user_id, login_dt, kakao_id, kakao_email, mobile_yn)\n"
    			+ "values (?,?,to_date(?, 'YYYYMMDDHH24MISS'),?,?, ?)\n";
    	try{
    		
    		con.setAutoCommit(false);
    		
    		pstmt = con.prepareStatement(query);
    		
    		pstmt.setString(1, ip.trim());
    		pstmt.setString(2, user_id.trim());
    		pstmt.setString(3, login_dt.trim());
    		pstmt.setString(4, kakao_id.trim());
    		pstmt.setString(5, kakao_email.trim());
    		pstmt.setString(6, mobile_yn.trim());
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
     * IP Log수정
     */
    public int updateLogoutLog(String ip, String user_id, String login_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query="UPDATE ip_log\n"
        	+ "SET logout_dt=sysdate\n"
            + "WHERE user_id=? and ip=? and login_dt=to_date(?,'YYYYMMDDHH24MISS')";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, user_id.trim());
            pstmt.setString(2, ip.trim());
            pstmt.setString(3, login_dt.trim());
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
     * 공지사항 읽은거 체크
     */
    public int readChkAnc(int bbs_id, String acar_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement stmt = null;
        int count = 0;
               
        String query = " UPDATE bbs SET read_chk=concat(nvl(read_chk,''),'A"+acar_id+"') "+
				" WHERE bbs_id="+bbs_id+" and (read_chk is null or read_chk not like '%"+acar_id+"%')";
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
			System.out.println("[OffAncDatabase:readChkAnc]"+se);
			System.out.println("[OffAncDatabase:readChkAnc]"+query);
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

	/**
     * 출근관리 Attend 관리
     */
    public int attend(String ip, String user_id, String login_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement stmt1 = null;
        Statement stmt2 = null;
        Statement stmt3 = null;
        ResultSet rs1 = null;
        ResultSet rs2 = null;
		int chk1 = 0;
		int count = 0;
		String chk2 = "";
		String loin_time = "";

		String query_chk1 = " select count(0) from attend"+
							" where dt=to_char(sysdate,'YYYYMMDD') and user_id='"+user_id+"'";
               
		String query_chk2 = " select ip_chk, to_char(login_dt, 'HH24') login_time from attend"+
							" where dt=to_char(sysdate,'YYYYMMDD') and user_id='"+user_id+"'";

        try{
			//현재 아이피 체크
			String ip_chk = "2"; //외부
			if(ip.equals("127.0.0.1")){
				ip_chk="1";
			}else{
				if(ip.length() >= 10 && ( ip.substring(0,9).equals("211.52.73") || ip.substring(0,9).equals("211.52.78") || ip.equals("218.38.115.23") )){
					ip_chk="1"; //내부			
				}else{
					ip_chk="2";
				}
			}
            
            con.setAutoCommit(false);

			//user_id의 현재날짜 레코드 조회
			stmt1 = con.createStatement();            
            rs1 = stmt1.executeQuery(query_chk1);
            if(rs1.next()){
				chk1 = rs1.getInt(1);
			}
            rs1.close();
            stmt1.close();


			String query_ins  = " insert into attend (dt, user_id, login_dt, ip, ip_chk) "+
		    			        " values (to_char(sysdate,'YYYYMMDD'), '"+user_id.trim()+"',"+
								" to_date('"+login_dt.trim()+"', 'YYYYMMDDHH24MISS'),"+
								" '"+ip.trim()+"', '"+ip_chk+"')";	

			String query_upd  = " update attend set "+
								" login_dt=to_date('"+login_dt.trim()+"', 'YYYYMMDDHH24MISS'),"+
								" ip='"+ip.trim()+"', ip_chk='"+ip_chk+"'"+
						        " where dt=to_char(sysdate,'YYYYMMDD') and user_id ='"+user_id.trim()+"'";

			if(chk1 == 0){//없으면-현재날짜 레코드 생성

				stmt3 = con.createStatement();            
				count = stmt3.executeUpdate(query_ins);             
	            stmt3.close();				

			}else{//있으면-외부아이피시 수정

				//user_id의 현재날짜 아이피체크,로그인시간 조회
				stmt2 = con.createStatement();            
			    rs2 = stmt2.executeQuery(query_chk2);
				if(rs2.next()){
					chk2 = rs2.getString(1)==null?"":rs2.getString(1);
					loin_time = rs2.getString(2)==null?"":rs2.getString(2);
				}
			    rs2.close();
				stmt2.close();

				if(Integer.parseInt(loin_time) < 7){
					stmt3 = con.createStatement();            
					count = stmt3.executeUpdate(query_upd);             
			        stmt3.close();				
				}
			}

			con.commit();

        }catch(SQLException se){
			System.out.println("[OffAncDatabase:attend]"+se);
			System.out.println("[OffAncDatabase:attend]"+user_id);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs1 != null) rs1.close();
                if(rs2 != null) rs2.close();
                if(stmt1 != null) stmt1.close();
                if(stmt2 != null) stmt2.close();
				if(stmt3 != null) stmt3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
		return count;
    }
    
    /**
     * 출근관리 Attend 관리
     */
    public int attend2(String ip, String user_id, String login_dt, String mobile_status) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt1 = null;
    	Statement stmt2 = null;
    	Statement stmt3 = null;
    	ResultSet rs1 = null;
    	ResultSet rs2 = null;
    	int chk1 = 0;
    	int count = 0;
    	String chk2 = "";
    	String loin_time = "";
    	
    	String query_chk1 = " select count(0) from attend"+
    			" where dt=to_char(sysdate,'YYYYMMDD') and user_id='"+user_id+"'";
    	
    	String query_chk2 = " select ip_chk, to_char(login_dt, 'HH24') login_time from attend"+
    			" where dt=to_char(sysdate,'YYYYMMDD') and user_id='"+user_id+"'";
    	
    	try{
    		//현재 아이피 체크
    		String ip_chk = "2"; //외부
    		if(ip.equals("127.0.0.1")){
    			ip_chk="1";
    		}else{
    			if (mobile_status.equals("1")) {
        			ip_chk="3";
    			} else {
    				if(ip.length() >= 10 && ( ip.substring(0,9).equals("211.52.73") || ip.substring(0,9).equals("211.52.78") )){
    					ip_chk="1"; //내부			
    				}else{
    					ip_chk="2";
    				}
    			}    			
    		}
    		
    		con.setAutoCommit(false);
    		
    		//user_id의 현재날짜 레코드 조회
    		stmt1 = con.createStatement();            
    		rs1 = stmt1.executeQuery(query_chk1);
    		if(rs1.next()){
    			chk1 = rs1.getInt(1);
    		}
    		rs1.close();
    		stmt1.close();
    		
    		
    		String query_ins  = " insert into attend (dt, user_id, login_dt, ip, ip_chk) "+
    				" values (to_char(sysdate,'YYYYMMDD'), '"+user_id.trim()+"',"+
    				" to_date('"+login_dt.trim()+"', 'YYYYMMDDHH24MISS'),"+
    				" '"+ip.trim()+"', '"+ip_chk+"')";	
    		
    		String query_upd  = " update attend set "+
    				" login_dt=to_date('"+login_dt.trim()+"', 'YYYYMMDDHH24MISS'),"+
    				" ip='"+ip.trim()+"', ip_chk='"+ip_chk+"'"+
    				" where dt=to_char(sysdate,'YYYYMMDD') and user_id ='"+user_id.trim()+"'";
    		
    		if(chk1 == 0){//없으면-현재날짜 레코드 생성
    			
    			stmt3 = con.createStatement();            
    			count = stmt3.executeUpdate(query_ins);             
    			stmt3.close();				
    			
    		}else{//있으면-외부아이피시 수정
    			
    			//user_id의 현재날짜 아이피체크,로그인시간 조회
    			stmt2 = con.createStatement();            
    			rs2 = stmt2.executeQuery(query_chk2);
    			if(rs2.next()){
    				chk2 = rs2.getString(1)==null?"":rs2.getString(1);
    				loin_time = rs2.getString(2)==null?"":rs2.getString(2);
    			}
    			rs2.close();
    			stmt2.close();
    			
    			if(Integer.parseInt(loin_time) < 7){
    				stmt3 = con.createStatement();            
    				count = stmt3.executeUpdate(query_upd);             
    				stmt3.close();				
    			}
    		}
    		
    		con.commit();
    		
    	}catch(SQLException se){
    		System.out.println("[OffAncDatabase:attend]"+se);
    		System.out.println("[OffAncDatabase:attend]"+user_id);
    		try{
    			con.rollback();
    		}catch(SQLException _ignored){}
    		throw new DatabaseException("exception");
    	}finally{
    		try{
    			con.setAutoCommit(true);
    			if(rs1 != null) rs1.close();
    			if(rs2 != null) rs2.close();
    			if(stmt1 != null) stmt1.close();
    			if(stmt2 != null) stmt2.close();
    			if(stmt3 != null) stmt3.close();
    		}catch(SQLException _ignored){}
    		connMgr.freeConnection(DATA_SOURCE, con);
    		con = null;
    	}
    	return count;
    }
    
    
    	/**
     * 출근관리 Attend  logout 관리
     */
    public int attendLogOut(String ip, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement stmt1 = null;
        Statement stmt2 = null;
        Statement stmt3 = null;
        ResultSet rs1 = null;
        ResultSet rs2 = null;
		int chk1 = 0;
		int count = 0;
		String chk2 = "";
		String loout_time = "";
		String query_upd  =  "";		  

		String query_chk1 = " select count(0) from attend"+
							" where dt=to_char(sysdate,'YYYYMMDD') and user_id='"+user_id+"'";
               
		String query_chk2 = " select ip_chk, to_char(logout_dt, 'HH24MI') logout_time from attend"+
							" where dt=to_char(sysdate,'YYYYMMDD') and user_id='"+user_id+"'";

        try{
			//현재 아이피 체크
			String ip_chk = "2"; //외부
			if(ip.equals("127.0.0.1")){
				ip_chk="1";
			}else{
				if(ip.length() >= 10 && ip.substring(0,9).equals("211.52.73")){
					ip_chk="1"; //내부			
				}else{
					ip_chk="2";
				}
			}
            
            con.setAutoCommit(false);

			//user_id의 현재날짜 레코드 조회
			stmt1 = con.createStatement();            
            rs1 = stmt1.executeQuery(query_chk1);
            if(rs1.next()){
				chk1 = rs1.getInt(1);
			}
            rs1.close();
            stmt1.close();
			

			if(chk1 >  0){   

				//user_id의 현재날짜 아이피체크,로그인시간 조회
				stmt2 = con.createStatement();            
			    rs2 = stmt2.executeQuery(query_chk2);
				if(rs2.next()){
					chk2 = rs2.getString(1)==null?"":rs2.getString(1);   //ip_chk 
					loout_time = rs2.getString(2)==null?"":rs2.getString(2);
				}
			    rs2.close();
				stmt2.close();
			
			   query_upd  = " update attend set  logout_dt= sysdate  "+				
			       " where dt=to_char(sysdate,'YYYYMMDD')  and ip_chk = '"+ chk2+ "' and  user_id ='"+user_id.trim()+"'";
			   
				stmt3 = con.createStatement();            
				count = stmt3.executeUpdate(query_upd);             
			   stmt3.close();				
				
			}

			con.commit();

        }catch(SQLException se){
			System.out.println("[OffAncDatabase:attend]"+se);
			System.out.println("[OffAncDatabase:attend]"+user_id);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs1 != null) rs1.close();
                if(rs2 != null) rs2.close();
                if(stmt1 != null) stmt1.close();
                if(stmt2 != null) stmt2.close();
				if(stmt3 != null) stmt3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
		return count;
    }
    

	//----------------------------------------------------------------------------------------
	
	/**
     * 공지사항 결재여부 등록
     */
 
		public int updateBbsComst(AncBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
      
      
        try{
            
		 query="UPDATE bbs SET \n"
	       		+ "COMST ='"+bean.getComst().trim()+"'\n"
    	       	+ "WHERE bbs_id="+bean.getBbs_id();


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
     * 공지사항 댓글 등록
     */
    public int insertBbsComment(BbsCommentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
		try{
        
	       query ="insert into bbs_comment (BBS_ID,SEQ,REG_DT,REG_ID,CONTENT,COM_ST)\n"
                      + "SELECT '"+bean.getBbs_id()+"',nvl(max(SEQ)+1,1), sysdate,\n"
					  + "'"+bean.getReg_id().trim()+"','"+bean.getContent().trim()+"','"+bean.getCom_st().trim()+"'\n"
			   		  + "FROM bbs_comment where bbs_id='"+bean.getBbs_id()+"'";

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
     * 공지사항 댓글
     */
    private BbsCommentBean makeBbsCommentBean(ResultSet results) throws DatabaseException {

        try {
            BbsCommentBean bean = new BbsCommentBean();

		    bean.setBbs_id(results.getInt("BBS_ID"));
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
     * 공지사항 댓글 리스트
     */
    public BbsCommentBean [] getBbsCommentList(int bbs_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
                        
        query = "select a.bbs_id, a.seq, a.reg_id, a.content, to_char(a.reg_dt,'YYYY-MM-DD') reg_dt, b.user_nm\n"   
				+ "from bbs_comment a, users b\n"
				+ "where a.bbs_id="+bbs_id+" and a.reg_id=b.user_id order by a.reg_dt";
      
        Collection<BbsCommentBean> col = new ArrayList<BbsCommentBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeBbsCommentBean(rs));
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
        return (BbsCommentBean[])col.toArray(new BbsCommentBean[0]);
    }
    
    //공지사항 리스트
	public Vector getGongjiListExp(String br_id)throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from bbs where exp_dt >= to_char(sysdate,'YYYYMMDD') order by bbs_id desc";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 if(columnName.equals("TITLE") || columnName.equals("CONENT"))
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).replace('\b', '\"'));
					 else
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[OffAncDatabase:getGongjiList]\n"+e);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
		
			return vt;
		
	}

	/**
     * 출근관리 Attend 관리
     */
    public int attendChk(String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        Statement stmt = null;
        ResultSet rs = null;
		int count = 0;
               
		String query_chk =  " select count(0) "+
				            " from   attend "+
							" where  dt=to_char(sysdate,'YYYYMMDD') "+
							"        and user_id='"+user_id+"'"+
							"        and to_char(login_dt, 'HH24') > '07' "+
							" ";

        try{
			//user_id의 현재날짜 아이피체크,로그인시간 조회
			stmt = con.createStatement();            
		    rs = stmt.executeQuery(query_chk);
			if(rs.next()){
				count = rs.getInt(1);
			}
		    rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[OffAncDatabase:attendChk]\n"+e);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
		return count;
    }


	/**
     * 공지사항 개별 조회
     */    
    public Bbs_FBean getBbs_FBean2(int bbs_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        Bbs_FBean fb = new Bbs_FBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "select a.BBS_ID, a.D_USER_ID,b.USER_NM AS D_USER_NM, b.BR_ID AS D_BR_ID, c.BR_NM AS D_BR_NM, b.DEPT_ID AS D_DEPT_ID,  \n"
				+ " DECODE(b.DEPT_ID , '0001','영업팀','0002','고객지원팀','0003','총무팀','0004','임원','0005','채권관리팀','0007','부산지점','0008','대전지점','8888','외부업체','9999','퇴사자') AS D_DEPT_NM,  \n"
				+ " b.USER_M_TEL AS D_USER_H_TEL, a.D_DAY_ST, a.D_DAY_ED, a.PLACE_NM, a.PLACE_TEL, a.PLACE_ADDR, a.CHIEF_NM, a.D_DAY_PLACE, a.FAMILY_RELATIONS, a.DECEASED_NM, a.DECEASED_DAY, a.TITLE_ST  \n"
				+ " from BBS_FAMILY a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ " where a.bbs_id=" + bbs_id + " and a.d_user_id=b.user_id and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+)\n";
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);


            if (rs.next()){
                fb = makeBbs_FBean(rs);
            }else{
                //throw new UnknownDataException("Could not find Appcode # " + bbs_id );
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

        return fb;
    }


 /**
     * 공지사항 등록 // 경조사
     */
    public int insertAnc_Family1(Bbs_FBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
    
		
		try{
        
		       query ="insert into bbs_family(BBS_ID, REG_ID, REG_DT, TITLE, D_USER_ID, D_DAY_ST, D_DAY_ED, PLACE_NM, PLACE_TEL, PLACE_ADDR, CHIEF_NM, D_DAY_PLACE, FAMILY_RELATIONS, DECEASED_NM, DECEASED_DAY, TITLE_ST)\n"
                      + "values('"+bean.getBbs_id()+"','"+bean.getReg_id().trim()+"',\n"
					  + "to_char(sysdate,'YYYYMMDD'),'"+bean.getTitle().trim()+"', '"+bean.getD_user_id().trim()+"',\n"
					  + "'"+bean.getD_day_st().trim()+"','"+bean.getD_day_ed().trim()+"','"+bean.getPlace_nm().trim()+"','"+bean.getPlace_tel().trim()+"',\n"
					  + "'"+bean.getPlace_addr().trim()+"','"+bean.getChief_nm().trim()+"',\n"
 					  + "'"+bean.getD_day_place().trim()+"','"+bean.getFamily_relations().trim()+"','"+bean.getDeceased_nm().trim()+"','"+bean.getDeceased_day().trim()+"','"+bean.getTitle_st().trim()+"'\n"
			   		  + " )\n";


            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("insertAnc_Family1: "+se);
			System.out.println("insertAnc_Family1: "+query);
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
     * 공지사항 등록 // 경조사
     */
    public int insertAnc_Family2(Bbs_FBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
    
		
		try{
        
		       query ="insert into bbs_family(BBS_ID, REG_ID, REG_DT, TITLE, D_USER_ID, D_DAY_ST, D_DAY_ED, PLACE_NM, PLACE_TEL, PLACE_ADDR, CHIEF_NM, D_DAY_PLACE, FAMILY_RELATIONS, DECEASED_NM, DECEASED_DAY, TITLE_ST)\n"
                      + "values('"+bean.getBbs_id()+"','"+bean.getReg_id().trim()+"',\n"
					  + "to_char(sysdate,'YYYYMMDD'),'"+bean.getTitle().trim()+"', '"+bean.getD_user_id().trim()+"',\n"
					  + "'"+bean.getD_day_st().trim()+"','"+bean.getD_day_ed().trim()+"','"+bean.getPlace_nm().trim()+"','"+bean.getPlace_tel().trim()+"',\n"
					  + "'"+bean.getPlace_addr().trim()+"','"+bean.getChief_nm().trim()+"',\n"
 					  + "'"+bean.getD_day_place().trim()+"','"+bean.getFamily_relations().trim()+"','"+bean.getDeceased_nm().trim()+"','"+bean.getDeceased_day().trim()+"','"+bean.getTitle_st().trim()+"'\n"
			   		  + " )\n";


            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
            pstmt.close();
            con.commit();

        }catch(SQLException se){
			System.out.println("insertAnc_Family12: "+se);
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
	 * 게시글번호 조회 
	 */
	public String getBbs_id(String reg_id, String title)throws DatabaseException, DataSourceEmptyException{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		String bbs_id = "";

		query = "SELECT MAX(bbs_id) bbs_id FROM bbs WHERE user_id= '"+reg_id+"' and reg_dt = to_char(sysdate,'YYYYMMDD') ";
		
		try{
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			while(rs.next()){
				bbs_id = rs.getString(1)==null?"":rs.getString(1);
			}
		}catch(SQLException e){
			System.out.println("[GongjiDatabase:getBbs_id]"+e);
			System.out.println("[GongjiDatabase:getBbs_id]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(stmt != null) stmt.close();
			 }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return bbs_id;
		}
	}


	/**
     * 공지사항 개별 조회
     */    
    public Bbs_FBean getBbs_FBean(int bbs_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        Bbs_FBean fb = new Bbs_FBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = " SELECT a.bbs_id AS BBS_ID, a.d_user_id AS D_USER_ID, b.user_nm AS D_USER_NM, b.br_id AS D_BR_ID, c.br_nm AS D_BR_NM,  \n"+
				" b.dept_id AS D_DEPT_ID, d.nm AS D_DEPT_NM, b.USER_M_TEL AS D_USER_H_TEL, a.D_DAY_ST AS D_DAY_ST, a.D_DAY_ED AS D_DAY_ED,  \n"+
				" a.PLACE_NM AS PLACE_NM, a.PLACE_TEL AS PLACE_TEL, a.PLACE_ADDR AS PLACE_ADDR, a.CHIEF_NM AS CHIEF_NM, a.D_DAY_PLACE AS D_DAY_PLACE, \n"+
				" a.FAMILY_RELATIONS AS FAMILY_RELATIONS, a.DECEASED_NM AS DECEASED_NM, a.DECEASED_DAY AS DECEASED_DAY, a.TITLE_ST AS TITLE_ST \n"+		
				" FROM BBS_FAMILY a, users b, branch c, code d   \n"+
				" WHERE a.bbs_id=" + bbs_id + " AND a.d_user_id=b.user_id AND b.br_id=c.br_id AND d.c_st='0002' AND d.code <> '0000' AND b.dept_id=d.code  \n";

        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            if (rs.next()){
                fb = makeBbs_FBean(rs);
            }else{
                System.out.println("Could not find Appcode # " + bbs_id );
                //throw new UnknownDataException("Could not find Appcode # " + bbs_id );
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

        return fb;
    }

//
	public Hashtable LastBbs_Family()throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	

		Statement stmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		query = " Select * from bbs_family where  reg_dt + 7 = to_char(sysdate,'YYYYMMDD') ";



		try {
			stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[GongjiDatabase:LastBbs_Family]"+e);
			System.out.println("[GongjiDatabase:LastBbs_Family]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(stmt != null)		stmt.close();
			 }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return ht;
		}
	}


	/**
     * 공지사항 수정
     */
    public int updateAnc_Family1(Bbs_FBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
			
			query="UPDATE bbs_family\n"
    		   	+ "SET \n"
       			+ "TITLE='"+bean.getTitle().trim()+"',\n"
	       		+ "D_DAY_ST='"+bean.getD_day_st().trim()+"',\n"
	       		+ "D_DAY_ED='"+bean.getD_day_ed().trim()+"',\n"
				+ "PLACE_NM='"+bean.getPlace_nm().trim()+"',\n"
				+ "PLACE_TEL='"+bean.getPlace_tel().trim()+"',\n"
	       		+ "PLACE_ADDR='"+bean.getPlace_addr().trim()+"',\n"
	       		+ "TITLE_ST='"+bean.getTitle_st().trim()+"'\n"
    	       	+ "WHERE BBS_ID="+bean.getBbs_id();

			System.out.println("[GongjiDatabase:updateAnc_Family1]"+query);
      
        try{
            
	       

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
     * 공지사항 수정
     */
    public int updateAnc_Family2(Bbs_FBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
      
        query="UPDATE bbs_family\n"
    		   	+ "SET \n"
       			+ "TITLE='"+bean.getTitle().trim()+"',\n"
	       		+ "DECEASED_NM='"+bean.getDeceased_nm().trim()+"',\n"
	       		+ "DECEASED_DAY='"+bean.getDeceased_day().trim()+"',\n"
				+ "FAMILY_RELATIONS='"+bean.getFamily_relations().trim()+"',\n"
				+ "D_DAY_ST='"+bean.getD_day_st().trim()+"',\n"
	       		+ "D_DAY_PLACE='"+bean.getD_day_place().trim()+"',\n"
	       		+ "CHIEF_NM='"+bean.getChief_nm().trim()+"',\n"
	       		+ "PLACE_NM='"+bean.getPlace_nm().trim()+"',\n"
				+ "PLACE_TEL='"+bean.getPlace_tel().trim()+"',\n"
	       		+ "PLACE_ADDR='"+bean.getPlace_addr().trim()+"',\n"
	       		+ "TITLE_ST='"+bean.getTitle_st().trim()+"'\n"

    	       	+ "WHERE BBS_ID="+bean.getBbs_id();
        
        try{

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
     * 공지사항 전체조회(메인에 각 카테고리 별 리스트 보여주는 부분)
     */
    public AncBean [] getAncAllOff(String acar_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
                 
	 query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID,"+
				" c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, "+
				" substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT,"+
				" substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT,"+
				" a.title as TITLE, a.content as CONTENT,"+
				" decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk,\n"+
				" decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') use_chk, e.comment_cnt, a.read_yn, a.bbs_st, nvl(a.comst,'N') comst,\n"
				+ " a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW, a.impor_yn  \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ "where a.p_view in ('Y','J') and a.user_id=b.user_id\n"
				+ subQuery
				+ "and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+)\n"
				+ "and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        


        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";

        Collection<AncBean> col = new ArrayList<AncBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeAncBean(rs));
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
        return (AncBean[])col.toArray(new AncBean[0]);
    }


 /**
     * 마지막 공지사항 조회
     */    
    public AncBean getAncLastOffBean() throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        AncBean ab = new AncBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID, c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT, substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT, a.title as TITLE, a.content as CONTENT, \n"   
				+ " a.read_chk, '' use_chk, e.comment_cnt, a.read_yn, a.bbs_st, nvl(a.comst,'N') comst,\n"   
				+ " a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW, a.impor_yn  \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ " where a.p_view in ('Y','J') and a.exp_dt >= to_char(sysdate,'YYYYMMDD') and a.user_id=b.user_id and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+) order by a.reg_dt desc, a.bbs_id desc\n";


        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                ab = makeAncBean(rs);
           
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
     * 공지사항 전체조회(리스트) - 추가 : 카테고리별 검색
     */
	 public AncBean [] getAncAll2Off(String gubun, String gubun_nm, String gubun1, String acar_id) throws DatabaseException, DataSourceEmptyException{
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
        else if(gubun.equals("c_year"))	    subQuery = " and a.reg_dt like to_char(sysdate, 'yyyy')||'%' \n";
        else if(gubun.equals("c_mon"))	    subQuery = " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        else	                            subQuery = "";        

        query = " select a.bbs_id as BBS_ID, a.user_id as USER_ID, b.user_nm as USER_NM, b.br_id as BR_ID,"+
				" c.br_nm as BR_NM, b.dept_id as DEPT_ID,d.nm as DEPT_NM, "+
				" substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT,"+
				" substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT,"+
				" a.title as TITLE, a.content as CONTENT,"+
				" decode(instr(a.read_chk, 'A"+acar_id+"'), 0,'0', '1') read_chk,\n"+
				" a.bbs_st,\n"+
				" decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') use_chk, e.comment_cnt, a.read_yn, nvl(a.comst,'N') comst,  \n" +
				" a.att_file1 as ATT_FILE1, a.visit_cnt as VISIT_CNT, a.att_file2 as ATT_FILE2, a.att_file3 as ATT_FILE3, a.att_file4 as ATT_FILE4, a.att_file5 as ATT_FILE5,a.p_view as P_VIEW, a.impor_yn  \n"
				+ " from bbs a, users b, branch c, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e\n"
				+ " where ( a.bbs_st='9' or a.P_VIEW  IN ('Y', 'J')) And a.user_id=b.user_id \n"
				+ subQuery
				+ " and b.br_id=c.br_id and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+)\n";

        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        
        
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";
      
        Collection<AncBean> col = new ArrayList<AncBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            while(rs.next()){
				col.add(makeAncBean(rs));
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
        return (AncBean[])col.toArray(new AncBean[0]);
    }

	/**
     * 공지사항 전체조회(리스트) - 추가 : 카테고리별 검색
     */
	 public String getAncAllJSON(String gubun, String gubun_nm, String gubun1, String acar_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";	
		
		String jobjString = "";
		String bbs_id = "";
		String bbs_st = "";
		String title = "";

		int count = 0;
		
        if(gubun.equals("title"))			subQuery = " and a.title like '%" + gubun_nm + "%' ";
        else if(gubun.equals("content"))	subQuery = " and a.content like '%" + gubun_nm + "%' ";
        else if(gubun.equals("reg_dt"))		subQuery = " and a.reg_dt >= replace('" + gubun_nm + "','-','') ";
        else if(gubun.equals("user_nm"))	subQuery = " and b.user_nm like '%" + gubun_nm + "%' ";
        else if(gubun.equals("c_year"))	    subQuery = " and a.reg_dt like to_char(sysdate, 'yyyy')||'%' ";
        else if(gubun.equals("c_mon"))	    subQuery = " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%' ";
        else if(gubun.equals("period")){	//기간검색 추가(2018.01.26)
        	String[] period_arr = gubun_nm.split("~");
        	String period_st 	= period_arr[0];
        	String period_end 	= period_arr[1];
        	subQuery = " and a.reg_dt between replace('" + period_st + "','-','') and replace('" + period_end + "','-','') ";
        }
        else	                            subQuery = "";

        query = " select a.bbs_id as BBS_ID, b.user_nm as USER_NM, d.nm as DEPT_NM, "+
				"        substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT, "+
				"        substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT, "+
				"        replace(a.title,'\"',' ') as TITLE, "+
				"        a.bbs_st, decode(a.bbs_st,'1','일반공지','2','최근뉴스','3','판매조건','4','업무협조','5','경조사','6','규정및인사','' ) bbs_st_nm, "+
				"        e.comment_cnt, decode(a.read_yn,'Y','/images/n_icon.gif','/images/n_icon2.png') read_yn "+
				" from bbs a, users b, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e "+
				" where a.user_id=b.user_id "
				+ subQuery +
				" and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+) ";

        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
      
        if(acar_id.equals("000071") || acar_id.equals("000194")){  //CALL
			query += " and a.user_id  in ('000071', '000194')" ;
        }  
       		
		if(gubun1.equals("")){
			query += " and a.bbs_st not in ( '7', '8', '9' ) ";	 
		} else {
			query += " and a.bbs_st = '" + gubun1 + "'";	  
   	    } 		  
      		
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

			JSONObject jObj = new JSONObject();
			Collection<JSONObject> items = new ArrayList<JSONObject>();
            
            while(rs.next()){
				count++;	

				JSONArray jarr = new JSONArray();
		        JSONObject sObj = new JSONObject();

				bbs_id	= rs.getString("BBS_ID")==null?"":rs.getString("BBS_ID");
				bbs_st	= rs.getString("BBS_ST")==null?"":rs.getString("BBS_ST");
				title	= rs.getString("TITLE")==null?"":rs.getString("TITLE");

		        jarr.add(count);
		        jarr.add(rs.getString("READ_YN")==null?"":rs.getString("READ_YN"));
				jarr.add(rs.getString("BBS_ST_NM")==null?"":rs.getString("BBS_ST_NM"));
				jarr.add(title+"^javascript:AncDisp("+bbs_id+","+bbs_st+");^_self");
		        jarr.add(rs.getString("USER_NM")==null?"":rs.getString("USER_NM"));
			    jarr.add(rs.getString("DEPT_NM")==null?"":rs.getString("DEPT_NM"));
		        jarr.add(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
		        jarr.add(rs.getString("EXP_DT")==null?"":rs.getString("EXP_DT"));
			    jarr.add(rs.getString("COMMENT_CNT")==null?"":rs.getString("COMMENT_CNT"));
	        
				sObj.put("id",count+1);
		        sObj.put("data",jarr);
	        
		        items.add(sObj);

            }

			jObj.put("rows",items);

			jobjString = jObj.toString();

            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[OffAncDatabase:getAncAllJSON]"+se);
			System.out.println("[OffAncDatabase:getAncAllJSON]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return jobjString;
    }
	 
	 //공지사항 전체리스트 조회2 (검색기능 세분화) (2018.01.30)
	 public String getAncAllJSON2(String gubun1, String gubun_1, String gubun2, String gubun_2, String gubun3, String acar_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery1 = "";
        String subQuery2 = "";
        String query = "";	
		String jobjString = "";
		String bbs_id = "";
		String bbs_st = "";
		String title = "";
		int count = 0;
		
        if(gubun1.equals("title"))			subQuery1 = " and a.title like '%" + gubun_1 + "%' ";
        else if(gubun1.equals("content"))	subQuery1 = " and (a.content like '%" + gubun_1 + "%' or a.keywords like '%"+gubun_1+"%' ) ";
        else if(gubun1.equals("user_nm"))	subQuery1 = " and b.user_nm like '%" + gubun_1 + "%' ";
        else if(gubun1.equals("keywords"))	subQuery1 = " and a.keywords like '%" + gubun_1 + "%' ";

        if(gubun2.equals("c_year"))	   		subQuery2 = " and a.reg_dt like to_char(sysdate, 'yyyy')||'%' ";
        else if(gubun2.equals("c_mon"))	    subQuery2 = " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%' ";
        else if(gubun2.equals("period")){	//기간검색 추가(2018.01.26)
        	String[] period_arr = gubun_2.split("~");
        	String period_st 	= period_arr[0];
        	String period_end 	= period_arr[1];
        	subQuery2 = " and a.reg_dt between replace('" + period_st + "','-','') and replace('" + period_end + "','-','') ";
        }

        query = " select a.bbs_id as BBS_ID, b.user_nm as USER_NM, d.nm as DEPT_NM, "+
				"        substr(a.reg_dt,1,4)||'-'||substr(a.reg_dt,5,2)||'-'||substr(a.reg_dt,7,2) as REG_DT, "+
				"        substr(a.exp_dt,1,4)||'-'||substr(a.exp_dt,5,2)||'-'||substr(a.exp_dt,7,2) as EXP_DT, "+
				"        replace(a.title,'\"',' ') as TITLE, "+
				"        a.bbs_st, decode(a.bbs_st,'1','일반공지','2','최근뉴스','3','판매조건','4','업무협조','5','경조사','6','규정및인사','' )||decode(a.end_st,'1','-차종단산','2','-색상단산','') bbs_st_nm, "+
				"        e.comment_cnt, decode(a.read_yn,'Y','/images/n_icon.gif','/images/n_icon2.png') READ_YN, "+
				"		 a.mybbs_chk as MYBBS_CHK, " +		//나의공지사항 기능구현 위한 데이터 조회
				"		 CASE WHEN a.mybbs_chk LIKE '%" + acar_id + "%' THEN '/images/mservice_icon.gif' ELSE '/images/n_icon2.png' END AS MYBBS_YN, " +		//나의공지사항 아이콘
				"		 a.impor_yn as IMPOR_YN, " +		//중요공지사항 기능구현 위한 데이터 조회(20181121)
				"		 CASE WHEN a.impor_yn = 'Y' THEN '<span class=impor_Y></span>' ELSE '<span class=impor_N></span>' END AS IMPOR_IMG, a.keywords " +		//중요공지사항 아이콘(20181121)
				" from bbs a, users b, code d, (select bbs_id, count(0) as comment_cnt from bbs_comment group by bbs_id) e "+
				" where a.user_id=b.user_id " +
				subQuery1 +
				subQuery2 +
				" and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.bbs_id=e.bbs_id(+) ";

        if(acar_id.equals(""))  query += " and a.exp_dt >= to_char(sysdate,'YYYYMMDD')";
        if(acar_id.equals("000071") || acar_id.equals("000194")){  //CALL
			query += " and a.user_id  in ('000071', '000194')" ;
        } 
		//if(gubun1.equals("")){
			query += " and a.bbs_st not in ( '7', '8', '9' ) ";	 
		//} else {
		//	query += " and a.bbs_st = '" + gubun1 + "'";	  
   	    //}
		if(!gubun3.equals("")){
			if(gubun3.equals("M")){			query += " and a.mybbs_chk like '%"+acar_id+"%'";	}	//나의공지사항(20180220)
			else if(gubun3.equals("I")){	query += " and a.impor_yn = 'Y'";					}	//중요공지사항(20181122)
		}
        query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.bbs_id desc";
        //query += " order by decode(sign(a.exp_dt-to_char(sysdate,'YYYYMMDD')),-1,'N','Y') desc, a.read_yn, a.reg_dt desc";

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			JSONObject jObj = new JSONObject();
			Collection<JSONObject> items = new ArrayList<JSONObject>();
			
            while(rs.next()){
				count++;
				JSONArray jarr = new JSONArray();
		        JSONObject sObj = new JSONObject();
				bbs_id	= rs.getString("BBS_ID")==null?"":rs.getString("BBS_ID");
				bbs_st	= rs.getString("BBS_ST")==null?"":rs.getString("BBS_ST");
				title	= rs.getString("TITLE")==null?"":rs.getString("TITLE");
				String mybbs_chk = rs.getString("MYBBS_CHK")==null?"":rs.getString("MYBBS_CHK");
				String hidden_str = bbs_id +"/" + mybbs_chk; 
		        jarr.add("");	
		        jarr.add(count);
		        jarr.add(rs.getString("MYBBS_YN")==null?"":rs.getString("MYBBS_YN"));
		        jarr.add(rs.getString("IMPOR_IMG")==null?"":rs.getString("IMPOR_IMG"));
		        jarr.add(rs.getString("READ_YN")==null?"":rs.getString("READ_YN"));
				jarr.add(rs.getString("BBS_ST_NM")==null?"":rs.getString("BBS_ST_NM"));
				jarr.add(title+"^javascript:AncDisp("+bbs_id+","+bbs_st+");^_self");
				jarr.add(rs.getString("KEYWORDS")==null?"":rs.getString("KEYWORDS"));
		        jarr.add(rs.getString("USER_NM")==null?"":rs.getString("USER_NM"));
			    jarr.add(rs.getString("DEPT_NM")==null?"":rs.getString("DEPT_NM"));
		        jarr.add(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
		        jarr.add(rs.getString("EXP_DT")==null?"":rs.getString("EXP_DT"));
			    jarr.add(rs.getString("COMMENT_CNT")==null?"":rs.getString("COMMENT_CNT"));
			    jarr.add(hidden_str);
	        
				sObj.put("id",count+1);
		        sObj.put("data",jarr);
		        items.add(sObj);
            }
			jObj.put("rows",items);
			jobjString = jObj.toString();
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[OffAncDatabase:getAncAllJSON2]"+se);
			System.out.println("[OffAncDatabase:getAncAllJSON2]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return jobjString;
    }

  /**
     * 공지사항 등록  -- 
     */
  
    public int insertAncNew(AncBean bean) throws DatabaseException, DataSourceEmptyException {
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;
        ResultSet rs2 = null;
        String query = "";
        String query1 = ""; 
        String query2 = "";
        String strQuery = "";
        int count = 0;
	  	 String exp_dt = bean.getExp_dt().trim();
	    
	  	  int bbs_id = 0;
    	  	
    	
    	 query = " INSERT INTO bbs"+
				" (BBS_ID, USER_ID, REG_DT, EXP_DT, TITLE,"+  //5
				" READ_YN, BBS_ST, VISIT_CNT, COMST, P_VIEW,"+	//4
				" SCM_YN, CONTENT, IMPOR_YN, keywords, car_comp_id, car_cd, end_st "+  //3
				" )\n"+			
				" values(?, ?,  to_char(sysdate,'YYYYMMdd'), replace(?,'-',''), ?, "+
				" ?, ?, 0, ?, ?,"+
				" ?,  EMPTY_CLOB(), ?, ?, ?, ?, ? "+
				" )\n";
				
		 query2 = " INSERT INTO bbs"+
				" (BBS_ID, USER_ID, REG_DT, EXP_DT, TITLE,"+  //5
				" READ_YN, BBS_ST, VISIT_CNT, COMST, P_VIEW,"+	//4
				" SCM_YN, CONTENT, IMPOR_YN, keywords, car_comp_id, car_cd, end_st "+  //3
				" )\n"+			
				" values(?, ?,  to_char(sysdate,'YYYYMMdd'),  to_char(sysdate + 7, 'yyyymmdd'), ?, "+
				" ?, ?, 0, ?, ?,"+
				" ?,  EMPTY_CLOB(), ?, ?, ?, ?, ? "+
				" )\n";
						
		query1 = " select  nvl(max(BBS_ID)+1,1)  from bbs  ";
						
    		
		try{
		
			    con.setAutoCommit(false);
			    pstmt1 = con.prepareStatement(query1);
				rs = pstmt1.executeQuery();
	            if(rs.next()){
					bbs_id = rs.getInt(1);
			    }
				rs.close();
				pstmt1.close();
		
			  
			    if(!exp_dt.equals("")){
					pstmt = con.prepareStatement(query);
					pstmt.setInt 	(1,  bbs_id						);		
					pstmt.setString (2,  bean.getUser_id().trim()	);							
					pstmt.setString (3,  exp_dt						);	
					pstmt.setString (4,  bean.getTitle().trim()		);					
					pstmt.setString (5,  bean.getRead_yn().trim()	);
					pstmt.setString (6,  bean.getBbs_st().trim()	);
					pstmt.setString (7,  bean.getComst().trim()		);
					pstmt.setString (8,  bean.getP_view().trim()	);
					pstmt.setString (9,  bean.getScm_yn().trim()	);
					pstmt.setString (10, bean.getImpor_yn().trim()	);
					pstmt.setString (11, bean.getKeywords().trim()	);
					pstmt.setString (12, bean.getCar_comp_id().trim());
					pstmt.setString (13, bean.getCar_cd().trim());
					pstmt.setString (14, bean.getEnd_st().trim());
				       
					// Insert Row
		      		count = pstmt.executeUpdate();
					pstmt.close();
				} else {
					pstmt = con.prepareStatement(query2);
					pstmt.setInt 	(1,  bbs_id						);		
					pstmt.setString (2,  bean.getUser_id().trim()	);		
					pstmt.setString (3,  bean.getTitle().trim()		);					
					pstmt.setString (4,  bean.getRead_yn().trim()	);
					pstmt.setString (5,  bean.getBbs_st().trim()	);
					pstmt.setString (6,  bean.getComst().trim()		);
					pstmt.setString (7,  bean.getP_view().trim()	);
					pstmt.setString (8,  bean.getScm_yn().trim()	);
					pstmt.setString (9,  bean.getImpor_yn().trim()	);
					pstmt.setString (10, bean.getKeywords().trim()	);
					pstmt.setString (11, bean.getCar_comp_id().trim());
					pstmt.setString (12, bean.getCar_cd().trim());
					pstmt.setString (13, bean.getEnd_st().trim());
				       
					// Insert Row
		      	   count = pstmt.executeUpdate();
					pstmt.close();
				}
	         
	        if( count == 1 ) {
	        	
	            // Make Select Query & Row Lock
	            strQuery = "SELECT CONTENT FROM bbs WHERE bbs_id = ? FOR UPDATE";
	            pstmt2 = con.prepareStatement(strQuery);
	            pstmt2.setInt(1, bbs_id);
	            rs2 = pstmt2.executeQuery();
	 
		        String strCLOB = bean.getContent().trim();
	            if( rs2.next() ) {
	                CLOB clob = ((OracleResultSet)rs2).getCLOB("CONTENT");
	                Writer writer = clob.getCharacterOutputStream();
	                Reader reader = new CharArrayReader(strCLOB.toCharArray());
	                char[] buffer = new char[1024];
	                int read = 0;
	                 
	                while ((read = reader.read(buffer, 0, 1024)) != -1) {
	                    writer.write(buffer, 0, read);
	                }
	                reader.close();
	                writer.close();
	            }
				rs2.close();
				pstmt2.close();	             

	            con.commit();	 
       	 }
       	 con.close();
	 	  }catch(IOException ex) {
		  
		  }catch(SQLException se){
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
                if(rs2 != null) rs2.close();
                if(pstmt2 != null) pstmt2.close();
                
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

      /**
     * 공지사항 수정
     */
    public int updateAncNew(AncBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
      
        PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
        String query = "";
        String strQuery = "";
        ResultSet rs = null;
        int count = 0;
      
        query = " UPDATE BBS SET "
			  	   + " EXP_DT=replace(?,'-',''),\n"
			  	   + "TITLE=?,\n"
	         	   + "READ_YN= ?,\n"
				   + "BBS_ST= ?,\n"
				   + "COMST= ?,\n"
				   + "SCM_YN= ?,\n"
	       		   + "P_VIEW= ?, \n"				
				   + "CONTENT= empty_clob(), \n"	
				   + "EXP_DT_CHG_YN= ?, \n"
				   + "IMPOR_YN= ?, \n"		//중요 체크 추가(20181122)
				   + "keywords=?, \n"
				   + "car_comp_id=?, \n"
				   + "car_cd=?, \n"
				   + "end_st=? \n"
				   + " where BBS_ID=? ";
						
        try{
               
            con.setAutoCommit(false);
            
                
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,  bean.getExp_dt().trim());
			pstmt.setString	(2,  bean.getTitle().trim());
			pstmt.setString (3,  bean.getRead_yn());		
			pstmt.setString (4,  bean.getBbs_st());		
			pstmt.setString (5,  bean.getComst());		
			pstmt.setString (6,  bean.getScm_yn());		
			pstmt.setString (7,  bean.getP_view());
			pstmt.setString (8,  bean.getExp_dt_chg_yn());
			pstmt.setString (9,  bean.getImpor_yn());
			pstmt.setString (10, bean.getKeywords().trim());
			pstmt.setString (11, bean.getCar_comp_id().trim());
			pstmt.setString (12, bean.getCar_cd().trim());
			pstmt.setString (13, bean.getEnd_st().trim());
			pstmt.setInt   	(14, bean.getBbs_id());		
						
            count = pstmt.executeUpdate();
			pstmt.close();
			            
             if( count == 1 ) {
	        	
	            // Make Select Query & Row Lock
	            strQuery = "SELECT CONTENT FROM bbs WHERE bbs_id = ? FOR UPDATE";
	            pstmt2 = con.prepareStatement(strQuery);
	            pstmt2.setInt(1, bean.getBbs_id());
	            rs = pstmt2.executeQuery();
	 
		        String strCLOB = bean.getContent().trim();
	            if( rs.next() ) {
	                CLOB clob = ((OracleResultSet)rs).getCLOB("CONTENT");
	                Writer writer = clob.getCharacterOutputStream();
	                Reader reader = new CharArrayReader(strCLOB.toCharArray());
	                char[] buffer = new char[1024];
	                int read = 0;
	                 
	                while ((read = reader.read(buffer, 0, 1024)) != -1) {
	                    writer.write(buffer, 0, read);
	                }
	                reader.close();
	                writer.close();
				}
				rs.close();
				pstmt2.close();
	                                                     

				con.commit();
        
          }
          con.close();
       	 
		  }catch(IOException ex) {
		  	
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
				if(rs != null) rs.close();
				if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    //나의 공지사항에 담기,빼기 (2018.02.20)
    public int updateMyAnc(String bbs_id, String user_id, String mode) throws UnknownDataException, DataSourceEmptyException, DatabaseException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");
		
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String myBbs_chk = "";
		int result = 0;
		
		String query = "SELECT MYBBS_CHK FROM BBS WHERE BBS_ID='"+ bbs_id +"'";						//먼저 현재상태의 MYBBS_CHK 값을 가져옴
		try{
			con.setAutoCommit(false);
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
            if (rs.next()){
            	if(rs.getString(1)!= null){
            		myBbs_chk = rs.getString(1);
            	}
            	if(mode.equals("MI")){
            		myBbs_chk = myBbs_chk + "A" + user_id;
            	}else if(mode.equals("MD")){
            		String[] myBbs_arr = myBbs_chk.split("A");
            		myBbs_chk = "";
            		for(int i=1; i<myBbs_arr.length; i++){
            			if(!myBbs_arr[i].equals(user_id)){
            				myBbs_chk = myBbs_chk + "A" + myBbs_arr[i];
            			}
            		}
            	}
            	String query2 = "UPDATE BBS SET MYBBS_CHK='"+ myBbs_chk +"' WHERE BBS_ID='"+ bbs_id +"'";	//조회한 MYBBS_CHK 값에 user_id를 추가,삭제 한후 다시 업데이트
            	pstmt = con.prepareStatement(query2);
            	result = pstmt.executeUpdate();
            }			
 			rs.close();
			con.commit();
		}catch(Exception e){
            try{
				System.out.println("[OffAncDatabase: updateMyAnc(String bbs_id, String user_id)]"+e);
                con.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		}finally{
			try{
				con.setAutoCommit(true);
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return result;
	}
    
    //나의 공지사항 체크 (2018.02.20)
    public String selectMyAnc(String bbs_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");
		Statement stmt = null;
		ResultSet rs = null;
		String myBbs_chk = "";
		
		String query = "SELECT MYBBS_CHK FROM BBS WHERE BBS_ID='"+ bbs_id +"'";
		try{
			con.setAutoCommit(false);
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
            if (rs.next()){
            	if(rs.getString(1)!=null){
            		myBbs_chk = rs.getString(1);
            	}	
            }			
 			rs.close();
			con.commit();
		}catch(Exception e){
            try{
				System.out.println("[OffAncDatabase: selectMyAnc(String bbs_id)]"+e);
                con.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		}finally{
			try{
				con.setAutoCommit(true);
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return myBbs_chk;
	}
    
    //중요공지사항에 설정, 설정해제 (2018.11.21)
    public int updateImportAnc(String bbs_id, String mode) throws UnknownDataException, DataSourceEmptyException, DatabaseException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
        String value = "";
        if(mode.equals("II"))	value = "Y";	
        
        query="UPDATE BBS\n "
        	+ "SET impor_yn = ?\n "
            + "WHERE bbs_id=? ";
 
       try{ 
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, value.trim());
            pstmt.setString(2, bbs_id.trim());
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("[updateImportAnc] exception");
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
    
    
    //공지사항 리스트
	public Vector getEstiBbsList(String st, String car_comp_id, String car_cd, String car_com_nm, String car_nm, String car_nm2, String refer_nm, int s_day, String agent_st)throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		
		String query = "SELECT CASE WHEN a.exp_dt >= TO_CHAR(SYSDATE,'YYYYMMDD') THEN 0 ELSE 1 END seq, "
				+ " a.bbs_id, decode(a.bbs_st,'1','일반공지','3','판매조건','8','에이전트') bbs_st, a.title, a.reg_dt, a.exp_dt, b.user_nm, a.end_st, a.p_view "
				+ " FROM bbs a, users b where a.user_id=b.user_id ";
		
		query += " AND (a.exp_dt >= TO_CHAR(SYSDATE,'YYYYMMDD') OR a.exp_dt >= TO_CHAR(SYSDATE-"+s_day+",'YYYYMMDD')) ";
		

		//에이전트 허용분
		if(!agent_st.equals("")) {
			query += " and (a.bbs_st='8' or (a.bbs_st in ('1','3') AND a.p_view in ('A','J')) ) ";
		}else {
			query += " and a.bbs_st in ('1','3') ";
		}
		
		//수입차
		if(st.equals("1")) {
			//수입차는 현재 유효분만
			if(AddUtil.parseInt(car_comp_id) > 5 ) {
				query += " AND a.title LIKE '%수입차%' and a.exp_dt >= TO_CHAR(SYSDATE,'YYYYMMDD') ";
			}else {
				query += " AND 1<>1";
			}
		//제조사	
		}else if(st.equals("2")) {
			query += " AND (a.title LIKE '%"+car_com_nm+"%' or (a.car_comp_id='"+car_comp_id+"' and a.car_cd is null)) AND a.title not LIKE '%"+car_nm+"%'  ";
		//차종	
		}else if(st.equals("3")) {
			if(car_nm2.equals("")) {
				query += " AND (a.title LIKE '%"+car_nm+"%' or a.car_comp_id||a.car_cd='"+car_comp_id+""+car_cd+"' ) ";
			}else {
				if(refer_nm.equals("")) {
					//명칭이 여러개
					query += " AND (a.title LIKE '%"+car_nm+"%' or a.title LIKE '%"+car_nm2+"%' or a.car_comp_id||a.car_cd='"+car_comp_id+""+car_cd+"' "
							+ "     or a.content LIKE '%"+car_nm+"%' or a.content LIKE '%"+car_nm2+"%' "
							+ "     or a.keywords LIKE '%"+car_nm+"%' or a.keywords LIKE '%"+car_nm2+"%' "
							+ "    ) ";
				}else {
					//참조명칭이 있음
					query += " AND (a.title LIKE '%"+car_nm+"%' or a.title LIKE '%"+car_nm2+"%' or a.car_comp_id||a.car_cd='"+car_comp_id+""+car_cd+"' "
							+ "     or a.content LIKE '%"+car_nm+"%' or a.content LIKE '%"+car_nm2+"%' "
							+ "     or a.keywords LIKE '%"+car_nm+"%' or a.keywords LIKE '%"+car_nm2+"%' "
							+ "     or regexp_like (a.title, '"+refer_nm+"') or regexp_like (a.content, '"+refer_nm+"') or regexp_like (a.keywords, '"+refer_nm+"') "
							+ "    ) ";
				}
			}
		}
		
		query += " order by 1, 2 desc";

		try {
			
			pstmt = con.prepareStatement(query);
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
			System.out.println("[OffAncDatabase:getGongjiList]\n"+e);
			System.out.println("[OffAncDatabase:getGongjiList]\n"+query);
	  		e.printStackTrace();
		} finally {
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
