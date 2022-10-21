package acar.common;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class CommonDataBase
{
	private static CommonDataBase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
	//public static synchronized CommonDataBase getInstance() throws DatabaseException {
		public static synchronized CommonDataBase getInstance() {
        if (instance == null)
            instance = new CommonDataBase();
        return instance;
    }
    
    //private CommonDataBase() throws DatabaseException {
    	private CommonDataBase()  {
        connMgr = DBConnectionManager.getInstance();
    }
	
	
	/**
	 * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	/**
     * Code ( 2001/12/28 ) - Kim JungTae
     */
    private CodeBean makeCodeBean(ResultSet results) throws DatabaseException {

        try {
            CodeBean bean = new CodeBean();

            bean.setC_st(results.getString("C_ST"));					//코드분류
		    bean.setCode(results.getString("CODE"));					//코드(순차적증가)
		    bean.setNm_cd(results.getString("NM_CD"));					//사용코드명
		    bean.setNm(results.getString("NM"));						//명칭
		    bean.setCms_bk(results.getString("CMS_BK"));				//cms 
		    bean.setApp_st(results.getString("APP_ST"));				//관리현황 적용여부
			bean.setUse_yn(results.getString("USE_YN"));				//관리현황 적용여부
			bean.setVar1(results.getString("VAR1"));					//금융사-월상환료처리방식
			bean.setVar2(results.getString("VAR2"));					//금융사-이자처리방식
			bean.setVar3(results.getString("VAR3"));					//금융사-이자처리방식
			bean.setVar4(results.getString("VAR4"));					//금융사-1회차 이자 일자계산
			bean.setVar5(results.getString("VAR5"));					//금융사-마지막회차 이자 일자계산
			bean.setVar6(results.getString("VAR6"));					//금융사-회차 일자계산시 시작일 포함여부 
			bean.setEtc(results.getString("ETC"));						//금융사-금융사구분
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

    private CodeBean makeCodeBean2(ResultSet results) throws DatabaseException {

        try {
            CodeBean bean = new CodeBean();

            bean.setC_st(results.getString("C_ST"));					//코드분류
		    bean.setCode(results.getString("CODE"));					//코드(순차적증가)
		    bean.setNm_cd(results.getString("NM_CD"));					//사용코드명
		    bean.setNm(results.getString("NM"));						//명칭
		    bean.setApp_st(results.getString("APP_ST"));				//관리현황 적용여부
		 
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
    /**
     * 금융기관 검색용
     * author : 성승현
     * date : 2016.04.05
     */

    private CodeBean makeCodeBean3(ResultSet results) throws DatabaseException {

        try {
            CodeBean bean = new CodeBean();

            bean.setC_st(results.getString("C_ST"));					//코드분류
		    bean.setCode(results.getString("CODE"));					//코드(순차적증가)
		    bean.setNm_cd(results.getString("NM_CD"));					//사용코드명
		    bean.setNm(results.getString("NM"));						//명칭
		    bean.setCms_bk(results.getString("CMS_BK"));				//cms 
		    bean.setApp_st(results.getString("APP_ST"));				//관리현황 적용여부
		    bean.setGubun(results.getString("GUBUN"));				//금융기관 코드 검색
		    		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
    
    //출고지 거래처코드
    private CodeBean makeCodeBean4(ResultSet results) throws DatabaseException {

        try {
            CodeBean bean = new CodeBean();

		    bean.setApp_st(results.getString("APP_ST"));			//거래처코드
            bean.setEtc(results.getString("ETC"));					//거래처명
		    bean.setNm(results.getString("NM"));					//출고지
		    		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
    

	/**
     * 보험사 ( 2002/1/7 ) - Kim JungTae
     */
    private InsComBean makeInsComBean(ResultSet results) throws DatabaseException {

        try {
            InsComBean bean = new InsComBean();

            bean.setIns_com_id(results.getString("INS_COM_ID"));			
		    bean.setIns_com_nm(results.getString("INS_COM_NM"));			
		    bean.setCar_rate(results.getString("CAR_RATE"));				
		    bean.setIns_rate(results.getString("INS_RATE"));				
		    bean.setExt_date(results.getString("EXT_DATE"));						    
		    bean.setZip(results.getString("ZIP"));								
		    bean.setAddr(results.getString("ADDR"));						
		    bean.setIns_com_f_nm(results.getString("INS_COM_F_NM"));		    
		    bean.setAgnt_imgn_tel(results.getString("agnt_imgn_tel"));
		    bean.setAcc_tel(results.getString("acc_tel"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 자동차 등록 리스트 ( 2001/12/28 ) - Kim JungTae
     */
    private RentListBean makeRegListBean(ResultSet results) throws DatabaseException {

        try {
            RentListBean bean = new RentListBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));					//계약관리ID
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//계약코드
		    bean.setRent_dt(results.getString("RENT_DT"));					//계약일자
		    bean.setDlv_dt(results.getString("DLV_DT"));					//출고일자
		    bean.setClient_id(results.getString("CLIENT_ID"));					//고객ID
		    bean.setClient_nm(results.getString("CLIENT_NM"));					//고객 대표자명
		    bean.setFirm_nm(results.getString("FIRM_NM"));						//상호
		    bean.setO_tel(results.getString("O_TEL"));						//사무실전화
		    bean.setFax(results.getString("FAX"));						//FAX
		    bean.setBr_id(results.getString("BR_ID"));						//
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));					//자동차관리ID
		    bean.setInit_reg_dt(results.getString("INIT_REG_DT"));					//최초등록일
		    bean.setReg_gubun(results.getString("REG_GUBUN"));					//최초등록일
		    bean.setCar_no(results.getString("CAR_NO"));						//차량번호
		    bean.setCar_num(results.getString("CAR_NUM"));						//차대번호
		    bean.setRent_way(results.getString("RENT_WAY"));					//대여방식
		    bean.setCon_mon(results.getString("CON_MON"));						//대여개월
		    bean.setCar_id(results.getString("CAR_ID"));						//차명ID
		    bean.setImm_amt(results.getInt("IMM_AMT"));						//자차면책금
		    bean.setCar_name(results.getString("CAR_NAME"));					//차명
		    bean.setRent_start_dt(results.getString("RENT_START_DT"));				//대여개시일
		    bean.setRent_end_dt(results.getString("RENT_END_DT"));					//대여종료일
		    bean.setReg_ext_dt(results.getString("REG_EXT_DT"));					//등록예정일
		    bean.setRpt_no(results.getString("RPT_NO"));						//계출번호
		    bean.setCpt_cd(results.getString("CPT_CD"));						//은행코드
		    //bean.setBank_nm(results.getString("BANK_NM"));						//은행명
		    bean.setReg_id(results.getString("REG_ID"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
    
    // 20180628
    private CommonEtcBean makeCommonEtcBean(ResultSet results) throws DatabaseException {

        try {
        	CommonEtcBean bean = new CommonEtcBean();
        	if(results != null){        	
	            bean.setTable_nm(results.getString("TABLE_NM"));			//테이블 이름
			    bean.setCol_1_nm(results.getString("COL_1_NM"));			//컬럼1 이름
			    bean.setCol_1_val(results.getString("COL_1_VAL"));			//컬럼1 값
			    bean.setCol_2_nm(results.getString("COL_2_NM"));			//컬럼2 이름
			    bean.setCol_2_val(results.getString("COL_2_VAL"));			//컬럼2 값
			    bean.setCol_3_nm(results.getString("COL_3_NM"));			//컬럼3 이름
			    bean.setCol_3_val(results.getString("COL_3_VAL"));			//컬럼3 값
			    bean.setCol_4_nm(results.getString("COL_4_NM"));			//컬럼4 이름
			    bean.setCol_4_val(results.getString("COL_4_VAL"));			//컬럼4 값
			    bean.setEtc_nm(results.getString("ETC_NM"));				//기타 제목
			    bean.setEtc_content(results.getString("ETC_CONTENT"));		//기타 내용
			    bean.setReg_id(results.getString("REG_ID"));				 
			    bean.setReg_dt(results.getString("REG_DT"));
        	}
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
    
	/**
     * Code 전체 조회 ( 2001/12/28 ) - Kim JungTae
     */
    public CodeBean [] getCodeAll( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, USE_YN, VAR1, VAR2, VAR3, VAR4, VAR5, VAR6, ETC \n"
        		+ "FROM CODE \n"
        		+ "where C_ST='" + c_st + "'\n"
        		+ "and CODE <> '0000' order by code";

        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeCodeBean(rs));
 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    
    /**
     * Code 전체 조회 ( 2001/12/28 ) - Kim JungTae
     */
    public CodeBean [] getCodeAll( String c_st , String sort ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, USE_YN, VAR1, VAR2, VAR3, VAR4, VAR5, VAR6, ETC \n"
        		+ "FROM CODE \n"
        		+ "where C_ST='" + c_st + "'\n"
        		+ "and CODE <> '0000' ";
        
        if ( sort.equals("nm")) { 
        	query += " order by nm ";
        } else {
            query += " order by code ";        	
        }
        
        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeCodeBean(rs));
 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    
    /**
	 *	금융기관 리스트 조회
	 * author : 성승현
	 * date : 2016.04.05
	 */
    public CodeBean [] getFinanceCode( String gubun ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT b.C_ST, b.CODE, b.NM_CD, b.NM, b.CMS_BK, b.APP_ST, a.GUBUN\n"
        		+ "FROM CODE_ETC a, CODE b  \n"
        		+ "where b.C_ST=a.C_ST(+)  and b.CODE=a.CODE(+) and b.C_ST='0003' and b.CODE <> '0000' ";
       
        if(!gubun.equals("")) query += "and a.GUBUN='"+gubun+"'";
        
        query += " order by b.code,  b.nm ";

        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCodeBean3(rs));
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    
 /**
     * Code 전체 조회  - cms가능은향
     */
    public CodeBean [] getCodeAllCms( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, USE_YN, VAR1, VAR2, VAR3, VAR4, VAR5, VAR6, ETC \n"
        		+ "FROM CODE \n"
        		+ "where C_ST='" + c_st + "'\n"
        		+ "and CODE <> '0000'  and cms_bk is not null order by nm";

        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeCodeBean(rs));
 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    
        
	  /**
     * Code 전체 조회-가산적용
     */
    public CodeBean [] getCodeAll2(String c_st, String app_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		    if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, nvl(APP_ST,'N') APP_ST FROM CODE a where C_ST='"+c_st+"' and CODE <> '0000'";
		
	    if(!app_st.equals(""))	query += " and app_st='"+app_st+"'";

		query += " order by code";

        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
    				col.add(makeCodeBean2(rs));
 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    
  /**
    * Code 주차장 조회-가산적용
    * from : Code 전체 조회-가산적용
    * author : 성승현
    * date : 2016-11-09
    */
    public CodeBean [] getCodeAll3(String c_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		    if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, APP_ST FROM CODE a where C_ST='"+c_st+"' and CODE <> '0000' order by app_st";
		
	    //if(!app_st.equals(""))	query += " and app_st='"+app_st+"'";

		//query += " order by code";

        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
    				col.add(makeCodeBean2(rs));
 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }

  /**
     * Code 개별 조회
     */
	 public CodeBean getCodeBean(String c_st, String code , String auth_rw) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        CodeBean cb = new CodeBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        
           
        query = "SELECT C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, USE_YN, VAR1, VAR2, VAR3, VAR4, VAR5, VAR6, ETC \n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='" + c_st + "'\n"
        		+ "and CODE ='"+ code + "'\n";
        		
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next()) {
                cb = makeCodeBean(rs);
            }    
            //else
            //    throw new UnknownDataException("Could not find Code # " + c_st + "|" + code  + "|" + query );
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

        return cb;
    }

  /**
     * Code 개별 조회
     */
	 public CodeBean getCodeBean(String c_st, String nm_cd) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        CodeBean cb;

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        
           
        query = "SELECT C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, USE_YN, VAR1, VAR2, VAR3, VAR4, VAR5, VAR6, ETC \n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='" + c_st + "'\n"
        		+ "and nm_cd ='"+ nm_cd + "'\n";
        		
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                cb = makeCodeBean(rs);
            else
                throw new UnknownDataException("Could not find Code # " + c_st + "|" + nm_cd );
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

        return cb;
    }

    
	/**
	 *	메인 코드 항목 조회 리스트 조회
	 */
	public Vector getCodeList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT C_ST, CODE, NM_CD from CODE  where CODE = '0000' order by C_ST ";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
	
    /**
     * 보험사 전체 조회 ( 2002/1/7 ) - Kim JungTae
     */
    public InsComBean [] getInsComAll() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "select INS_COM_ID,INS_COM_NM,CAR_RATE,INS_RATE,EXT_DATE, ZIP, ADDR, INS_COM_F_NM, agnt_imgn_tel, acc_tel from ins_com order by seq, ins_com_nm";

        Collection<InsComBean> col = new ArrayList<InsComBean>();
        try{
            pstmt = con.prepareStatement(query);

            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeInsComBean(rs));
 
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
        return (InsComBean[])col.toArray(new InsComBean[0]);
    }

    /**
     * 보험사 검색 조회 ( 20110208 ) - jhm
     */
    public InsComBean [] getInsComAll(String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " select INS_COM_ID,INS_COM_NM,CAR_RATE,INS_RATE,EXT_DATE, ZIP, ADDR, INS_COM_F_NM, agnt_imgn_tel, acc_tel from ins_com ";

		if(!t_wd.equals("")) query += " where upper(nvl(INS_COM_NM, ' ')) like upper('%"+ t_wd +"%') ";
		
		query += " order by decode(ins_com_st,'조합',1,'외국',2,0), ins_com_nm";

        Collection<InsComBean> col = new ArrayList<InsComBean>();
        try{
            pstmt = con.prepareStatement(query);

            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeInsComBean(rs));
 
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
        return (InsComBean[])col.toArray(new InsComBean[0]);
    }

	/**
     * 계약사항, 자동차 등록 리스트 조회 ( 2002/1/3 ) - Kim JungTae
     */
    public RentListBean [] getRegListAll( String gubun, String ref_dt1, String ref_dt2, String rent_l_cd ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        
        String query = "";
        
        if(gubun.equals("1")){
        	subQuery = "and a.car_mng_id is null\n";
        }else if(gubun.equals("2")){
        	subQuery = "and a.car_mng_id is not null\n";
        }else{
        	subQuery = "";
        }
        
        query = "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_way as RENT_WAY,nvl(d.con_mon,'-') as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME,\n"//
		+ "i.cpt_cd as CPT_CD\n"//,j.nm as BANK_NM
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h\n"//--, code j
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like upper('%" + rent_l_cd + "%') and nvl(a.use_yn,'Y')='Y' and a.car_gu='1'\n"
		+ subQuery
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd order by c.firm_nm, a.rent_l_cd\n";
		//+ "and j.c_st = '0003'\n"
		//+ "and j.code <> '0000'\n"
		//+ "and i.cpt_cd = j.code(+)\n"
        Collection<RentListBean> col = new ArrayList<RentListBean>();
        try{
            pstmt = con.prepareStatement(query);
            //pstmt.setString(1, c_st.trim());
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeRegListBean(rs));
 
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
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }
    /**
     * 과태료 범칙금 등록시 계약 조회 ( 2002/1/10 ) - Kim JungTae
     */
    public RentListBean [] getCarRentListAll( String gubun, String rent_l_cd, String firm_nm, String car_no ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        
        String query = "";
        
        query = "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME,\n"//
		+ "i.cpt_cd as CPT_CD\n"//,j.nm as BANK_NM
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h\n"//--, code j
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like upper('%" + rent_l_cd + "%') and nvl(a.use_yn,'Y')='Y'\n"
		+ "and a.car_mng_id = b.car_mng_id and b.car_no like '%" + car_no + "%'\n"
		+ "and a.client_id = c.client_id and c.firm_nm like '%" + firm_nm + "%'\n"
		+ "and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n";
		//+ "and j.c_st = '0003'\n"
		//+ "and j.code <> '0000'\n"
		//+ "and i.cpt_cd = j.code(+)\n"

        Collection<RentListBean> col = new ArrayList<RentListBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeRegListBean(rs));
 
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
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }

	/**
     * 우편번호 검색 ( 2001/12/28 ) - Lee Min young
     */
	public Vector getZip(String dongStr) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		String sql = " select distinct ZIP_CD, SIDO, GUGUN, DONG, BUNJI from ZIP where GUGUN||DONG like '%" + dongStr + "%' order by 1,2,3,4,5";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		try {
			    pstmt = con.prepareStatement(sql);
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
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

		/**
     * 우편번호 검색 - 시도
     */
	public Vector getZip_sido() throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		String sql = " select substr(zip_cd,1,1) zip_cd, sido from zip group by substr(zip_cd, 1,1), sido ";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		try {
			    pstmt = con.prepareStatement(sql);
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
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();								
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/**
     * 우편번호 검색 - 시도별 구,군
     */
	public Vector getZip_gugun(String[] sido) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		String sql = " SELECT substr(zip_cd, 1,3) zip_cd, sido, gugun FROM zip WHERE substr(zip_cd,1,1) in ('";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		for(int i=0 ; i<sido.length ; i++){
			if(i == (sido.length -1))	sql += sido[i];
			else						sql += sido[i]+"', '";
		}
		sql += "') GROUP BY substr(zip_cd, 1,3), sido, gugun ";

		try {
			    pstmt = con.prepareStatement(sql);
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
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/**
	 *	자동차영업소리스트
	 *  args -  com_id : 자동차회사ID
	 */
	public Vector getCarOffList(String com_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " select CAR_OFF_ID, CAR_OFF_NM from CAR_OFF where car_comp_id = '" + com_id + "' ORDER BY CAR_OFF_NM ";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
	/**
	 *	자동차영업소리스트
	 *  args -  com_id : 자동차회사ID, off_nm : 영업소 이름
	 */
	public Vector getCarOffList(String com_id, String off_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " select O.CAR_OFF_ID CAR_OFF_ID, O.CAR_OFF_NM OFF_NM, C.NM COM_NM "+
						" from CAR_OFF O, CODE C "+
						" where  "+
						" 	O.CAR_COMP_ID = C.CODE and "+
						" 	C.c_st = '0001' and "+
						" 	O.CAR_COMP_ID like '%"+com_id+"%' and "+
						" 	O.car_off_nm like '%"+off_nm+"%' "+
						"	order by CAR_COMP_ID ";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
	
	/**
	 *	자동차영업사원리스트
	 *  args -  car_off_id : 자동차 영업소ID
	 */
	public Vector getCarOffEmpList(String car_off_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "select EMP_ID, EMP_NM from CAR_OFF_EMP where car_off_id like '" + car_off_id + "'";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
	/**
	 *	차종 및 차명 리스트 
	 *  args -  com_id : 자동차회사, car_cd : 차종ID, mode : (CAR 차종 / CAR_NM 차명)
	 *	mode "CAR_CODE" 추가. 20040426. Yongsoon Kwon.
	 */
	public Vector getCarList(String com_id, String car_cd, String mode) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "";
        
		if(mode.equals("CAR"))
			query = "select CAR_CD, CAR_NM from car_mng where use_yn='Y' and car_comp_id like '%"+ com_id +"%' order by car_nm";
		else if(mode.equals("CAR_NM")) 
			query = " select car_id, car_comp_id, car_cd, car_name"+
						" from car_nm"+
						" where use_yn='Y' and car_comp_id='"+com_id+"' and"+
								" car_cd in"+
									" ("+
									" select code"+
									" from car_mng"+
									" where use_yn='Y' and car_cd like '%"+car_cd+"%'"+
									" ) order by car_name";
		else if(mode.equals("CAR_CODE"))
			query = " select CODE, CAR_CD, CAR_NM from car_mng where use_yn='Y' and car_comp_id like '%"+ com_id +"%' order by car_nm";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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

	/**
	 *	NM_CD를 전달해 code테이블에서 code값을 가져오는 메소드
	 */
	public String getCodeByCd(String nm_cd, String c_st) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "select code from code where c_st='"+c_st+"' and nm_cd='"+nm_cd+"'";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}
	
	/**
	 *	사용자 리스트 조회
	 *  mode - CLIENT : 고객사용자, EMP : 사원사용자, BUS_EMP : 영업담당자, MNG_EMP : 관리담당자
	 */
	public Vector getUserList(String dept, String br_id, String mode) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	  	
		String query =	" select a.dept_id ,decode(a.dept_id,'0020','0000',a.dept_id) as dept_id2 , a.USER_ID, a.USER_NM, decode(a.user_pos,'대표이사', 0, '부장', 1, '팀장', 2, '이사', 3, '차장', 4, '과장', 5, '대리', 6, 9) POS, \n"+
						"        a.enter_dt, nvl(b.jg_dt,a.enter_dt) jg_dt, '1' st \n"+
						" from   USERS a, (SELECT user_id, max(jg_dt) jg_dt FROM INSA_POS GROUP BY user_id) b \n"+
						" where  a.use_yn='Y' \n"+
						"        AND a.user_id=b.user_id(+) \n"+
						" ";

			if(!dept.equals(""))				query += " and a.DEPT_ID = '"+ dept +"'  \n";
			if(!br_id.equals(""))				query += " and a.BR_ID = '"+ br_id +"'  \n";

			if(mode.equals("CLIENT"))			query += " and a.DEPT_ID is null  \n";
			else if(mode.equals("EMP"))			query += " and a.DEPT_ID in ('0001','0002','0003','0004','0006','0007','0008','0005','1000','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020')  \n";
/*임원빠진전체*/else if(mode.equals("ALL_EMP"))		query += " and a.DEPT_ID in ('0001','0002','0003','0006','0007','0008','0005','1000','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020')  \n";
			else if(mode.equals("AGENT"))		query += " and a.DEPT_ID in ('1000')  \n";
			else if(mode.equals("BUS_EMP"))		query += " and a.DEPT_ID = '0001'  \n";
			else if(mode.equals("MNG_EMP"))		query += " and a.DEPT_ID  in ('0002', '0015', '0016'  )  \n";
			else if(mode.equals("GEN_EMP"))		query += " and a.DEPT_ID = '0003'  \n";
/*외부업체*/  else if(mode.equals("OUTSIDE"))		query += " and a.DEPT_ID = '8888'  \n";    
			else if(mode.equals("BUS_MNG_EMP")) query += " and a.DEPT_ID in ('0001','0002')  \n";
			else if(mode.equals("LOAN_ST1"))    query += " and a.loan_st='1' and a.DEPT_ID in ('0001','0002','0003','0004','0006','0007','0008','0005','1000','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020')  \n";			
			else if(mode.equals("LOAN_ST2"))    query += " and a.loan_st='2' and a.DEPT_ID in ('0001','0002','0003','0004','0006','0007','0008','0005','1000','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020')  \n";
			else if(mode.equals("LOAN_ST0"))    query += " and a.loan_st is null and a.DEPT_ID in ('0001','0002','0003','0004','0006','0007','0008','0005','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020')  \n";

/*본사*/	else if(mode.equals("WATCH"))			query += " and a.DEPT_ID in ('0001','0002','0013','0014','0015','0017','0018','0009','0012') and a.loan_st is not null  \n";
/*부산*/	else if(mode.equals("WATCH_B"))			query += " and a.DEPT_ID in ('0007') and a.loan_st is not null \n";
/*부산+대구*/	else if(mode.equals("WATCH_BG"))	query += " and a.DEPT_ID in ('0007','0011') and a.loan_st is not null and a.user_id not in ('000053','000054') \n";
/*대전+광주*/	else if(mode.equals("WATCH_DK"))	query += " and a.DEPT_ID in ('0008','0010') and  a.user_pos in ('과장','사원', '대리') and a.loan_st is not null and a.user_id not in ('000149','000166') \n";
/*부산+대구+대전+광주*/ else if(mode.equals("WATCH_BGDK"))		query += " and a.DEPT_ID in ('0007','0011','0008','0010') and a.loan_st is not null and a.user_id not in ('000052','000053','000054') \n";
/*강남+인천+수원+강북+송파*/else if(mode.equals("WATCH_SIK3"))		query += " and a.DEPT_ID in ('0009','0012','0013','0017','0018') and a.loan_st is not null  \n";
/*대전*/	else if(mode.equals("WATCH_D"))		query += " and a.DEPT_ID in ('0008') and  a.loan_st is not null  \n";
/*강남*/	else if(mode.equals("WATCH_S"))		query += " and a.DEPT_ID in ('0009') and  a.loan_st is not null  \n";
/*광주*/	else if(mode.equals("WATCH_K"))		query += " and a.DEPT_ID in ('0010') and  a.loan_st is not null  \n";
/*대구*/	else if(mode.equals("WATCH_G"))		query += " and a.DEPT_ID in ('0011') and  a.loan_st is not null  \n";
/*인천*/	else if(mode.equals("WATCH_I"))		query += " and a.DEPT_ID in ('0012') and  a.loan_st is not null  \n";
/*수원*/	else if(mode.equals("WATCH_K3"))	query += " and a.DEPT_ID in ('0013') and  a.loan_st is not null  \n";
/*강북*/	else if(mode.equals("WATCH_JR"))	query += " and a.DEPT_ID in ('0017') and  a.loan_st is not null  \n";
/*송파*/	else if(mode.equals("WATCH_SP"))	query += " and a.DEPT_ID in ('0018') and  a.loan_st is not null  \n";

/*본사주말*/else if(mode.equals("WATCH_J"))	query += " and a.DEPT_ID in ('0001','0002','0013','0014','0015','0017','0018','0009','0012') and a.loan_st = '1'  \n";
/*부산주말*/else if(mode.equals("WATCH_B_J"))	query += " and a.DEPT_ID in ('0007') and  a.user_id not in ('000053') and a.loan_st = '1'  \n";
/*대전주말*/else if(mode.equals("WATCH_D_J"))	query += " and a.DEPT_ID in ('0008') and  a.user_id not in ('000052') and a.loan_st = '1'  \n";
/*강남주말*/else if(mode.equals("WATCH_S_J"))	query += " and a.DEPT_ID in ('0009') and  a.loan_st = '1'  \n";
/*광주주말*/else if(mode.equals("WATCH_J_J"))	query += " and a.DEPT_ID in ('0010') and  a.user_id not in ('000118') and a.loan_st = '1'  \n";
/*대구주말*/else if(mode.equals("WATCH_G_J"))	query += " and a.DEPT_ID in ('0011') and  a.user_id not in ('000054') and a.loan_st = '1'  \n";
/*인천주말*/else if(mode.equals("WATCH_I_J"))	query += " and a.DEPT_ID in ('0012') and  a.loan_st = '1'  \n";
/*수원주말*/else if(mode.equals("WATCH_K3_J"))	query += " and a.DEPT_ID in ('0013') and  a.loan_st = '1'  \n";

		else if(mode.equals("B_M_EMP"))			query += " and a.DEPT_ID in ('0001','0002','0003','0007','0008','0010','0011','0009','0012','0013','0014','0015','0017','0018','0020') \n";
		else if(mode.equals("SACTION"))			query += " and a.USER_ID in ('000003','000004', '000005', '000026' , '000028')  \n";
/*본사*/	else if(mode.equals("RM_MNG"))			query += " and a.DEPT_ID in ('0002','0014','0015','0009','0012','0017','0018') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') and a.user_id not in ('000119','000026','000225','000163') \n";
/*본사*/	else if(mode.equals("RM_MNG_201412"))	query += " and a.DEPT_ID in ('0002','0014','0015','0009','0012','0017','0018') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') and a.user_id not in ('000010','000011','000119') \n";
/*본사*/	else if(mode.equals("RM_MNG_201503"))	query += " and a.DEPT_ID in ('0002','0014','0015','0009','0012','0017','0018') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') and a.user_id not in ('000010','000013','000168','000119') \n";
/*본사*/	else if(mode.equals("RM_MNG_201506"))	query += " and a.DEPT_ID in ('0002','0014','0015','0009','0012','0017','0018') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') and a.user_id in ('000085','000011','000138','000010','000163') \n";
/*본사*/	else if(mode.equals("RM_MNG_201510"))	query += " and a.DEPT_ID in ('0002','0014','0015','0009','0012','0017','0018') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') and a.user_id in ('000224','000225','000226','000227','000243') \n";
/*본사*/	else if(mode.equals("RM_MNG_201512"))	query += " and a.DEPT_ID in ('0002','0014','0015','0009','0012','0017','0018') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') and a.user_id not in ('000138','000163','000168') \n";
/*본사*/	else if(mode.equals("RM_MNG_201711"))	query += " and a.DEPT_ID in ('0002','0014','0015','0009','0012','0017','0018') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') and a.user_id not in ('000163') \n";
/*본사*/	else if(mode.equals("RM_MNG_F_SP"))		query += " and a.user_id in ('000224','000225','000226','000227','000085','000163','000168') \n"; //전민건,이용우,김권우,김정원,김태연,조영석,박준범 - 미사용
/*부산*/	else if(mode.equals("RM_MNG_B"))		query += " and a.DEPT_ID in ('0007') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD')  \n";
/*대전*/	else if(mode.equals("RM_MNG_D"))		query += " and a.DEPT_ID in ('0008') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD')  \n";//대전
/*부산*/	else if(mode.equals("RM_MNG_B_I"))		query += " and a.DEPT_ID in ('0007') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') and a.user_id not in ('000066')  \n";
/*대전*/	else if(mode.equals("RM_MNG_D_I"))		query += " and a.DEPT_ID in ('0008') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') and a.user_id not in ('000052')   \n";//대전
/*강남*/	else if(mode.equals("RM_MNG_S"))		query += " and a.DEPT_ID in ('0009') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD')  \n";
/*광주*/	else if(mode.equals("RM_MNG_J"))		query += " and a.DEPT_ID in ('0010') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD')  \n";
/*대구*/	else if(mode.equals("RM_MNG_G"))		query += " and a.DEPT_ID in ('0011') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),2),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD')  \n";
/*인천*/	else if(mode.equals("RM_MNG_I"))		query += " and a.DEPT_ID in ('0012') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD')  \n";
/*수원*/	else if(mode.equals("RM_MNG_K3"))		query += " and a.DEPT_ID in ('0013') and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD')  \n";
/*수원*/	else if(mode.equals("RM_MNG_K3_201510"))	query += " and a.loan_st ='1' and TO_CHAR(ADD_MONTHS(TO_DATE(a.enter_dt,'YYYYMMDD'),3),'YYYYMMDD') < TO_CHAR(SYSDATE,'YYYYMMDD') and a.user_id in ('000241','000245') \n";//미사용


/*신용조회*/else if(mode.equals("SMS"))			query += " and a.DEPT_ID in ('0001','0002','0003','0004','0006', '0007', '0008', '0005','1000','0009','0010','0011', '0012','0013','0014','0015','0016','0017','0018','0020')  \n";
/*콜센터*/  else if(mode.equals("CALL"))		query += " and a.DEPT_ID = '8888' and a.user_work='콜센타'  \n";
/*과태료*/  else if(mode.equals("FINE"))		query += " and a.DEPT_ID = '8888' and (a.user_work like '%과태료%' or a.user_nm like '%과태료%')  \n";			
/*임원*/  else if(mode.equals("PR_EMP"))		query += " and a.DEPT_ID = '0004'  \n";

        if(mode.equals("EMP")||mode.equals("ALL_EMP")){

			query +=" union \n"+
					" SELECT a.dept_id,decode(a.dept_id,'0020','0000',a.dept_id) as dept_id2, '10'||a.dept_id AS user_id, '='||MIN(b.nm)||'=' user_nm, 9 AS pos, '' enter_dt, '' jg_dt, '0' st  \n"+
					" FROM   USERS a, (SELECT * FROM CODE WHERE c_st='0002') b  \n"+
					" WHERE  a.use_yn='Y' AND a.dept_id NOT IN ('8888') AND a.dept_id=B.CODE \n"+
					" GROUP BY a.dept_id HAVING COUNT(*)>0 \n"+
					" ";

      	}else if(mode.equals("B_M_EMP")){

			query +=" union \n"+
					" SELECT a.dept_id,decode(a.dept_id,'0020','0000',a.dept_id) as dept_id2, '10'||a.dept_id AS user_id, '='||MIN(b.nm)||'=' user_nm, 9 AS pos, '' enter_dt, '' jg_dt, '0' st  \n"+
					" FROM   USERS a, (SELECT * FROM CODE WHERE c_st='0002') b  \n"+
					" WHERE  a.use_yn='Y' AND a.dept_id NOT IN ('8888','0004','0005') AND a.dept_id=B.CODE \n"+
					" GROUP BY a.dept_id HAVING COUNT(*)>0 \n"+
					" ";
      	}else if(mode.equals("SMS")){//신용조회문자 관련  에이전트 추가

			query +=" union \n"+
					" SELECT a.dept_id,decode(a.dept_id,'0020','0000',a.dept_id) as dept_id2, '10'||a.dept_id AS user_id, '='||MIN(b.nm)||'=' user_nm, 9 AS pos, '' enter_dt, '' jg_dt, '0' st  \n"+
					" FROM   USERS a, (SELECT * FROM CODE WHERE c_st='0002') b  \n"+
					" WHERE  a.use_yn='Y' AND a.dept_id NOT IN ('8888') AND a.dept_id=B.CODE \n"+
					" GROUP BY a.dept_id HAVING COUNT(*)>0 \n"+
					" ";

      	}else if(mode.equals("LOAN_ST1")){ 

				query +=" union \n"+
						" SELECT a.dept_id,decode(a.dept_id,'0020','0000',a.dept_id) as dept_id2, '10'||a.dept_id AS user_id, '='||MIN(b.nm)||'=' user_nm, 9 AS pos, '' enter_dt, '' jg_dt, '0' st  \n"+
						" FROM   USERS a, (SELECT * FROM CODE WHERE c_st='0002') b  \n"+
						" WHERE  a.use_yn='Y' AND a.dept_id NOT IN ('8888') and a.loan_st='1' AND a.dept_id=B.CODE \n"+
						" GROUP BY a.dept_id HAVING COUNT(*)>0 \n"+
						" ";		
				
      	}else if(mode.equals("LOAN_ST2")){

				query +=" union \n"+
						" SELECT a.dept_id,decode(a.dept_id,'0020','0000',a.dept_id) as dept_id2, '10'||a.dept_id AS user_id, '='||MIN(b.nm)||'=' user_nm, 9 AS pos, '' enter_dt, '' jg_dt, '0' st  \n"+
						" FROM   USERS a, (SELECT * FROM CODE WHERE c_st='0002') b  \n"+
						" WHERE  a.use_yn='Y' AND a.dept_id NOT IN ('8888') and a.loan_st='2' AND a.dept_id=B.CODE \n"+
						" GROUP BY a.dept_id HAVING COUNT(*)>0 \n"+
						" ";					
      	}else if(mode.equals("LOAN_ST0")){

				query +=" union \n"+
						" SELECT a.dept_id,decode(a.dept_id,'0020','0000',a.dept_id) as dept_id2, '10'||a.dept_id AS user_id, '='||MIN(b.nm)||'=' user_nm, 9 AS pos, '' enter_dt, '' jg_dt, '0' st  \n"+
						" FROM   USERS a, (SELECT * FROM CODE WHERE c_st='0002') b  \n"+
						" WHERE  a.use_yn='Y' AND a.dept_id NOT IN ('1000','8888') and a.loan_st is null AND a.dept_id=B.CODE \n"+
						" GROUP BY a.dept_id HAVING COUNT(*)>0 \n"+
						" ";					
      	}


		if( mode.equals("RM_MNG") || mode.equals("RM_MNG_B") || mode.equals("RM_MNG_D") || mode.equals("RM_MNG_S") || mode.equals("RM_MNG_J") || mode.equals("RM_MNG_G") ||
			mode.equals("RM_MNG_201412") || mode.equals("RM_MNG_201503") || mode.equals("RM_MNG_201506") || mode.equals("RM_MNG_201510") || mode.equals("RM_MNG_201512") || mode.equals("RM_MNG_F_SP") ||
			mode.equals("RM_MNG_I") || mode.equals("RM_MNG_K3") || mode.equals("RM_MNG_K3_201510") 
		){
			query += " ORDER BY a.user_id ";
		}else {
			query += " ORDER BY dept_id2, st, pos, jg_dt, enter_dt, user_nm ";
		}

//System.out.println("getUserList( "+query);		

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getUserList]"+e);
			System.out.println("[CommonDataBase:getUserList]"+query);
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

	/**
	 *	사용자 리스트 조회
	 *  mode - CLIENT : 고객사용자, EMP : 사원사용자, BUS_EMP : 영업담당자, MNG_EMP : 관리담당자
	 */
	public Vector getUserList(String dept, String br_id, String mode, String use_yn) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

//	        String query = "select USER_ID, USER_NM, ID, DEPT_ID, USER_M_TEL from USERS where user_id is not null";
				
			String query =	" select a.dept_id, a.USER_ID, a.USER_NM,    decode(a.user_pos,'대표이사', 0, '부장', 1, '팀장', 2, '이사', 3, '차장', 4, '과장', 5, '대리', 6, 9) POS, \n"+
							"        a.enter_dt, nvl(b.jg_dt,a.enter_dt) jg_dt, '1' st ,  a.USER_M_TEL, a.ID   \n"+
							" from   USERS a, (SELECT user_id, max(jg_dt) jg_dt FROM INSA_POS GROUP BY user_id) b \n"+
							" where  a.user_id=b.user_id(+) \n"+
							" ";


        if(!use_yn.equals(""))				query += " and a.use_yn = '"+ use_yn +"' ";
        if(!dept.equals(""))				query += " and a.DEPT_ID = '"+ dept +"' ";

        if(!br_id.equals("") && !mode.equals("PARTNER"))				
											query += " and a.BR_ID = '"+ br_id +"' ";

		if(mode.equals("CLIENT"))			query += " and a.DEPT_ID is null ";
		else if(mode.equals("EMP"))			query += " and a.DEPT_ID in ('0001','0002','0003','0004','0006','0007','0008','0005','9999','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020')  \n";
	//	else if(mode.equals("EMP"))			query += " and a.DEPT_ID is not null ";
		else if(mode.equals("BUS_EMP"))		query += " and a.DEPT_ID = '0001' ";
		else if(mode.equals("MNG_EMP"))		query += " and a.DEPT_ID = '0002' ";
		else if(mode.equals("GEN_EMP"))		query += " and a.DEPT_ID = '0003' ";
		else if(mode.equals("BUS_MNG_EMP")) query += " and a.DEPT_ID in ('0001','0002') ";
		else if(mode.equals("HEAD"))		query += " and a.USER_POS not in ('인턴사원','사원','대리','대표이사','주주','외부업체') ";
		else if(mode.equals("HEAD2"))		query += " and a.USER_ID in ('000003','000004','000005','000006','000052','000053','000026') ";
		else if(mode.equals("BODY"))		query += " and a.USER_POS in ('사원','대리','과장') ";
		else if(mode.equals("BODY2"))		query += " and a.DEPT_ID in ('0001','0002','0003','0007','0008') ";
		else if(mode.equals("BUS_ID"))		query += " and a.USER_ID in (select BUS_ID from cont group by BUS_ID) ";
		else if(mode.equals("BUS_ID2"))		query += " and a.USER_ID in (select BUS_ID2 from cont group by BUS_ID2) ";
		else if(mode.equals("MNG_ID"))		query += " and a.USER_ID in (select MNG_ID from cont group by MNG_ID) ";
		else if(mode.equals("MESSAGE"))		query += " and a.DEPT_ID in ('0001','0002','0003','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018','0020') and a.M_IO = 'Y' ";//메제시받기 체크된 사람만

		else if(mode.equals("MESSAGE_S"))	query += " and a.DEPT_ID in ('0001') and a.M_IO = 'Y' ";
		else if(mode.equals("MESSAGE_B"))	query += " and a.DEPT_ID in ('0007') and a.M_IO = 'Y' ";
		else if(mode.equals("MESSAGE_D"))	query += " and a.DEPT_ID in ('0008') and a.M_IO = 'Y' ";
		else if(mode.equals("MESSAGE_K"))	query += " and a.DEPT_ID in ('0009') and a.M_IO = 'Y' ";
		else if(mode.equals("MESSAGE_J"))	query += " and a.DEPT_ID in ('0010') and a.M_IO = 'Y' ";
		else if(mode.equals("MESSAGE_G"))	query += " and a.DEPT_ID in ('0011') and a.M_IO = 'Y' ";
		else if(mode.equals("MESSAGE_I"))	query += " and a.DEPT_ID in ('0012') and a.M_IO = 'Y' ";
		else if(mode.equals("MESSAGE_W"))	query += " and a.DEPT_ID in ('0013') and a.M_IO = 'Y' ";
		else if(mode.equals("MESSAGE_JR"))	query += " and a.DEPT_ID in ('0017') and a.M_IO = 'Y' ";
		else if(mode.equals("MESSAGE_SP"))	query += " and a.DEPT_ID in ('0018') and a.M_IO = 'Y' ";

		else if(mode.equals("PARTNER"))		query += " and a.user_work like '%"+ br_id +"%' and a.user_m_tel is not null ";
		else if(mode.equals("loan_st"))		query += " and a.loan_st is not null  ";



       		 if(mode.equals("EMP")){

			query +=" union \n"+
					" SELECT a.dept_id, '10'||a.dept_id AS user_id, '='||MIN(b.nm)||'=' user_nm, 9 AS pos, '' enter_dt, '' jg_dt, '0' st  ,  '' USER_M_TEL, '' ID  \n"+
					" FROM   USERS a, (SELECT * FROM CODE WHERE c_st='0002') b  \n"+
					" WHERE  a.dept_id NOT IN ('8888') AND a.dept_id=B.CODE \n"+
					" GROUP BY a.dept_id HAVING COUNT(*)>0 \n"+
					" ";
		}
					
							
		if(use_yn.equals("N")){
			query += " ORDER BY a.user_id ";
		}else{
			if(mode.equals("PARTNER")){	
				query += " ORDER BY decode(a.user_id,'000223',0,1), a.enter_dt, a.user_id";
			}else{
//				query += " ORDER BY a.dept_id, decode(a.user_pos,'사원',1,0), a.user_id ";
				query += " ORDER BY dept_id, st, pos,  jg_dt , enter_dt, user_nm ";
			}
		}
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
//System.out.println("mode: "+mode);
//	System.out.println("common: "+query);
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
			System.out.println("[CommonDataBase:getUserList]"+e);
			System.out.println("[CommonDataBase:getUserList]"+query);
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
	
	/**
	 *	사용자 리스트 조회 - 
	 *  mode - CLIENT : 고객사용자, EMP : 사원사용자, BUS_EMP : 영업담당자, MNG_EMP : 관리담당자
	 */
	public Vector getUserList(String user_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "select USER_ID, USER_NM, ID, DEPT_ID, USE_YN, USER_POS, USER_M_TEL from USERS where user_id = '"+ user_id +"' ";

         
		query += " ORDER BY dept_id, decode(user_pos,'사원',1,0) ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getUserList]"+e);
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

	/**
	 *	팀장이 팀원들 리스트 조회
	 */
	public Vector getUserList_dept(String user_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " select user_id, user_nm, dept_id from users"+
						" where dept_id=(select dept_id from users where user_id='"+user_id+"') and user_pos in ('사원','대리','과장', '차장') and use_yn='Y'";

		query += " ORDER BY USER_ID ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getUserList_dept]"+e);
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
	
	/**
	 *	팀장이 팀원들 리스트 조회
	 */
	public String getUserDept(String user_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " select dept_id from users where user_id='"+user_id+"'";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String dept_id="";
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				dept_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CommonDataBase:getUserDept]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return dept_id;
	}

	/**
	 *	팀장이 팀원들 리스트 조회
	 */
	public String getUserBrch(String user_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " select br_id from users where user_id='"+user_id+"'";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String br_id="";
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				br_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CommonDataBase:getUserBrch]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return br_id;
	}

	/**
	 *	수금현황에서 영업담당자 검색 조건 조회
	 */
	public String getUserBusYn(String user_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " select user_id from users where user_id='"+user_id+"' and user_pos in ('사원','대리','과장', '차장' ) and dept_id <> '0003' and use_yn='Y'";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String id="";
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CommonDataBase:getUserBusYn]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return id;
	}

	/**
	 *	영업소 리스트 조회
	 */
	public Vector getBranchList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT BR_ID, BR_NM from BRANCH  order by DECODE(br_id,'S1','0000',taxregno) ";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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

	/**
	 *	영업소 리스트 조회(공급자)
	 */
	public Vector getBranchs() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT * from BRANCH where br_ent_no is not null order by BR_ID ";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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

	/**
	 *	영업소 리스트 조회(공급자)
	 */
	public Hashtable getBranch(String br_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		if(br_id.equals("S0"))	br_id= "S1";

        String query = "SELECT * from BRANCH where br_id='"+br_id+"'";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}
	
	/**
	 *	영업소 리스트 조회(공급자)
	 */
	public Hashtable getBranch2(String br_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT * from BRANCH where br_nm='"+br_nm+"'";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}	

	/**
	 *	계약코드와 계약관리번호로 영업/출고 영업소 가져오기
	 *  gubun - 1: 영업 , 2: 출고 
	 */
	public Hashtable getOffNm(String m_id, String l_cd, String gubun) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " select O.car_off_id ID, C.nm COM_NM, O.car_off_nm OFF_NM " +
  					  " from car_off O, code C " +
					  " where O.car_comp_id = C.code and " +
					  "		C.c_st = '0001' and " +
					  "		O.car_off_id =    " +
					  " 	( select car_off_id  " +
			 		  " from car_off_emp " +
					  " where " +
					  " emp_id = ( " +
					  " 	select emp_id " +
					  " 	from commi " +
					  " 	where RENT_MNG_ID  = '"+ m_id +"' and " +
					  "		  RENT_L_CD  = '"+ l_cd +"' and " +
					  "	  	  agnt_st = '"+ gubun +"'))";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/**
	 *	자동차관리번호로 차량번호, 차종 가져오기 
	 */
	public Hashtable getCar_detail(String c_m_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " select R.CAR_MNG_ID ID, R.CAR_NO CAR_NO, N.CAR_NAME CAR_NM "+
						" from car_reg R, cont C, car_etc E, car_nm N "+
						" where "+
							" R.car_mng_id = C.car_mng_id and "+
							" E.rent_mng_id = C.rent_mng_id and "+
							" E.rent_l_cd = C.rent_l_cd and "+
							" E.car_id = N.car_id and "+
							" R.car_mng_id = '"+ c_m_id +"'";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}	
	
	/**
	 *	cur_date(날짜) + mon(개월) 을 리턴
	 */
	public String addMonth(String cur_date, int mon) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "select to_char(add_months(to_date(replace('"+ AddUtil.ChangeDate(cur_date) +"','-',''), 'YYYY-MM-DD'), "+mon+"), 'YYYY-MM-DD') from dual";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {

			if(AddUtil.checkDate(cur_date)){
				if(cur_date.equals("--")){
					return cur_date;
				}

				pstmt = con.prepareStatement(query);
			    rs = pstmt.executeQuery();
   	
				while(rs.next())
				{				
					 rtn = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
			    pstmt.close();
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
			System.out.println("[CommonDataBase:addMonth]"+e);
			System.out.println("[CommonDataBase:addMonth]"+query);
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}
	
	/**
	 *	cur_date(날짜) + day(일) 을 리턴
	 */
	public String addDay(String cur_date, int day) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "select to_char(to_date(replace('"+ cur_date +"','-',''), 'YYYYMMDD')+"+ day +", 'YYYYMMDD') "+
						" from dual";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			if(AddUtil.checkDate(cur_date)){
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
				while(rs.next())
				{				
					 rtn = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
	            pstmt.close();
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
			System.out.println("[CommonDataBase:addDay]"+e);
			System.out.println("[CommonDataBase:addDay]"+query);
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}	
	
	/**
	 *	cur_date(날짜) + day(일) 을 리턴
	 */
	public String minusDay(String cur_date, int day) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "select to_char(to_date(replace('"+ cur_date +"','-',''), 'YYYY-MM-DD')-("+ day +"), 'YYYY-MM-DD') "+
						" from dual";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			if(AddUtil.checkDate(cur_date)){	
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
				if(rs.next())
				{				
					 rtn = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
		        pstmt.close();
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
			System.out.println("[CommonDataBase:minusDay]"+query);
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}	


	/**
	 *	차령 구해서 리턴 20050621. 재리스
	 */
	public Hashtable getOld(String cur_date) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "SELECT "+
					" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD'))/12) YEAR, "+
					" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD')) - "+
					" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD'))/12) * 12) MONTH, "+
					" TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD')) - "+
					" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD')))) * 30.5) DAY "+ 
					" FROM DUAL ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			if(AddUtil.checkDate(cur_date)){	
				pstmt = con.prepareStatement(query);
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
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/**
	 *	gubun - "BRCH", "USER", "DEPT", "CAR_OFF_EMP", "INS_COM", "CAR_COM", "CAR_OFF", "CAR_NM", "BANK"
	 */
	public String getNameById(String id, String gubun) throws DatabaseException, DataSourceEmptyException
	{
		String query = "";
		if(gubun.equals("BRCH"))
		{
			query = " select BR_NM from BRANCH where BR_ID = '"+ id +"'";
		}
		else if(gubun.equals("USER_BR"))
		{
			query = " select decode(br_id, 'S1', '본사', 'B1', '부산', 'D1', '대전', 'S2', '강남', 'I1', '인천', 'J1', '광주', 'G1', '대구', 'K3', '수원', 'S3', '강서', 'S4', '부천', 'U1', '울산','S5','광화문','S6','송파') USER_BR_NM from USERS where USER_ID = '"+ id +"'";
		}	
		else if(gubun.equals("USER_DE"))
		{
			query = " select decode(dept_id, '0001','영업팀', '0002','고객지원팀', '0003','총무팀', '0005', 'IT팀', '0007','부산지점', '0008','대전지점', '0009','강남지점', '0011','대구지점', '0010','광주지점', '0012','인천지점', '0013', '수원지점','0014', '강서지점','0015', '부천지점','0016', '울산지점','0017', '광화문지점','0018', '송파지점' ) USER_DE_NM from USERS where USER_ID = '"+ id +"'";
		}	
		else if(gubun.equals("USER"))
		{
			query = " select USER_NM from USERS where USER_ID = '"+ id +"'";
		}
		else if(gubun.equals("USER_PO"))
		{
			query = " select DECODE(user_pos,'','',USER_POS||' ')||USER_NM as USER_PO_NM from USERS where USER_ID = '"+ id +"'";
		}
		else if(gubun.equals("USER_ID"))
		{
			query = " select USER_ID from USERS where USER_NM = '"+ id +"'";
		}
		else if(gubun.equals("USER_SA"))
		{
			query = " select SA_CODE from USERS where USER_ID = '"+ id +"'";
		}
		else if(gubun.equals("DEPT"))
		{
			query = " select NM from CODE where C_ST = '0002' and CODE = '"+ id +"'";
		}
		else if(gubun.equals("CAR_OFF_EMP"))
		{
			query = " select EMP_NM from CAR_OFF_EMP where EMP_ID = '"+ id +"'";
		}
		else if(gubun.equals("INS_COM"))
		{
			query = " select INS_COM_NM from INS_COM where INS_COM_ID = '"+ id +"'";
		}
		else if(gubun.equals("CAR_COM"))
		{
			query = " select NM from CODE where C_ST = '0001' and CODE = '"+ id +"'";
		}
		else if(gubun.equals("CAR_OFF"))
		{
			query = " select CAR_OFF_NM from CAR_OFF where CAR_OFF_ID = '"+ id +"'";
		}
		else if(gubun.equals("CAR_MNG"))
		{
			if(id.length() > 4){
				query = " select CAR_NM from CAR_MNG where CAR_COMP_ID='"+ id.substring(0,4) +"' and CODE = '"+ id.substring(4) +"'";
			}else{
				query = " select CAR_NM from CAR_MNG where CAR_COMP_ID='"+ id +"' and CODE = '"+ id +"'";
			}
		}
		else if(gubun.equals("CAR_MNG_AB"))
		{
			if(id.length() > 4){
				query = " select AB_NM from CAR_MNG where CAR_COMP_ID='"+ id.substring(0,4) +"' and CODE = '"+ id.substring(4) +"'";
			}else{
				query = " select AB_NM from CAR_MNG where CAR_COMP_ID='"+ id +"' and CODE = '"+ id +"'";
			}
		}
		else if(gubun.equals("REFER_NM"))
		{
			if(id.length() > 4){
				query = " select REFER_NM from CAR_MNG where CAR_COMP_ID='"+ id.substring(0,4) +"' and CODE = '"+ id.substring(4) +"'";
			}else{
				query = " select REFER_NM from CAR_MNG where CAR_COMP_ID='"+ id +"' and CODE = '"+ id +"'";
			}
		}
		else if(gubun.equals("CAR_NM3"))
		{
			if(id.length() > 6){
				query = " select CAR_NAME from CAR_NM where CAR_ID = '"+ id.substring(0,6) +"' and CAR_SEQ = '"+ id.substring(6) +"'";
			}else{
				query = " select CAR_NAME from CAR_NM where CAR_ID = '"+ id +"' and CAR_SEQ = '"+ id +"'";
			}			
		}		
		else if(gubun.equals("CAR_NM"))
		{
			query = " select CAR_NAME from CAR_NM where CAR_ID = '"+ id +"'";
		}		
		else if(gubun.equals("FULL_CAR_NM"))
		{
			query = " select b.car_nm||' '||a.CAR_NAME from CAR_NM a, CAR_MNG b where a.CAR_ID = '"+ id +"' and a.car_comp_id=b.car_comp_id and a.car_cd=b.code";
		}		
		else if(gubun.equals("BANK"))
		{
			query = " select NM from CODE where C_ST = '0003' and CODE = '"+ id +"'";
		}
		else if(gubun.equals("CAR_NM2"))
		{
			query = " SELECT car_nm FROM car_reg WHERE car_mng_id = '"+ id +"'";
		}else if(gubun.equals("CAR_NO"))
		{
			query = " SELECT car_no FROM car_reg WHERE car_mng_id = '"+ id +"'";
		}else if(gubun.equals("CLIENT"))
		{
			query = " SELECT decode(firm_nm,'',client_nm,firm_nm) FROM client WHERE client_id='"+id+"'";
		}else if(gubun.equals("ENP_NO"))
		{
			query = " SELECT enp_no FROM client WHERE firm_nm='"+id+"'";
		}else if(gubun.equals("USER_M_TEL"))
		{
			query = " SELECT user_m_tel FROM users WHERE user_id = '" + id + "'";
		}else if(gubun.equals("CMS_BNK"))
		{
			query = " SELECT bname FROM bnk WHERE bcode = '" + id + "'";	
		}

		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}		
		return rtn;		
	}	
	
	/**
	 *	코드테이블 데이타 가져오기
	 */
	public String getNameByIdCode(String c_st, String code, String nm_cd) throws DatabaseException, DataSourceEmptyException
	{
		String query = "";
		query = " select NM from CODE where C_ST='"+c_st+"'";
		
		if(!code.equals(""))	query += " and code='"+code+"'";
		if(!nm_cd.equals(""))	query += " and nm_cd='"+nm_cd+"'";		

		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";

		//System.out.println("[CommonDatabase:getNameByIdCode()]query="+query);

		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

	//		System.out.println("[CommonDatabase:getNameByIdCode()]rtn="+rtn);

			if(nm_cd.equals("") && code.equals("")) rtn = "";

		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}		
		return rtn;		
	}	

	/**
	 *	코드테이블 데이타 가져오기
	 */
	public String getIdByNameCode(String c_st, String nm) throws DatabaseException, DataSourceEmptyException
	{
		String query = "";
		query = " select NM_CD from CODE where C_ST='"+c_st+"'";
		
		if(!nm.equals(""))	query += " and nm='"+nm+"'";		

		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";

		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

			if(nm.equals("")) rtn = "";

		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}		
		return rtn;		
	}	

	/**
	 *	 user_id로 권한 가져오기
	 */
	public String getUserAuth(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		String query = " select USER_AUT from USERS where USER_ID = '"+user_id+"'";
		
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}
	
	public String getSysDate() throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		String query = "select to_char(sysdate, 'YYYY-MM-DD') from dual";
		
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}			
		return rtn;
	}

	//배반차사용
	public String getSysDatehm() throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		String query = "select to_char(sysdate,'YYYYMMddhh24')|| '00'  from dual ";
		
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}			
		return rtn;
	}
	
	/**
     * 금융사 조회
     */
    public CodeBean [] getBankList(String c_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, USE_YN, VAR1, VAR2, VAR3, VAR4, VAR5, VAR6, ETC \n"
        		+ "FROM CODE a\n"
        		+ "where C_ST = '0003'\n"
        		+ "and CODE <> '0000'\n";

		if(c_st.equals("1")) {				query += " and NM like '%은행%' ";
		} else if(c_st.equals("2")) {		query += " and (nm NOT LIKE '%은행%' OR nm LIKE '%저축은행%')";
		} else {							query += " and nm LIKE '%"+c_st+"%' ";
		}

		query += " order by NM ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeCodeBean(rs));
 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }


	/**
	 *	자동차관리번호로 계약관리번호, 계약번호 가져오기 2003.10.16.목. Yongsoon Kwon -- 매각후 정비를 위해서 매입옵션포함함.
	 */
	public Hashtable getRent_id(String car_mng_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " SELECT a.rent_mng_id, a.rent_l_cd "+
						" FROM cont_n_view a, cls_cont c "+
						" WHERE a.car_mng_id=? and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+)  \n"+
						" AND    (nvl(a.use_yn,'Y')='Y' or nvl(c.cls_st,'0') in ('8', '6') ) ";
					
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,car_mng_id);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/**
	 * 계약관리번호, 계약번호로 자동차 관리번호 가져오기 2003.11.4.화. Yongsoon Kwon
	 */
	public String getCar_mng_id(String rent_mng_id,String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT car_mng_id FROM cont WHERE rent_mng_id=? AND rent_l_cd=? ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String car_mng_id = "";
		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,rent_mng_id);
				pstmt.setString(2,rent_l_cd);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next()){
				car_mng_id = rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID");
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return car_mng_id;
	}
	/**
	 * 계약관리번호, 계약번호로 거래처관리번호(client_id) 가져오기 2004.3.9.화. Yongsoon Kwon
	 */
	public String getClinet_id(String rent_mng_id,String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT client_id FROM cont WHERE rent_mng_id=? AND rent_l_cd=? ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String client_id = "";
		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,rent_mng_id);
				pstmt.setString(2,rent_l_cd);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next()){
				client_id = rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID");
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return client_id;
	}

	/**
	 *	계약관리번호, 계약번호로 담당자 조회하기 2004.5.28. Yongsoon Kwon.
	 */
	public Hashtable getDamdang(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT bus_id, bus_id2, mng_id, mng_id2 FROM cont WHERE rent_mng_id=? AND rent_l_cd=? ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,rent_mng_id);
				pstmt.setString(2,rent_l_cd);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/**
	 * 차량관리번호, 사고관리번호로 사고구분 조회 2004.6.11. Yongsoon Kwon
	 */
	public String getAccid_st(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT accid_st FROM accident WHERE car_mng_id=? AND accid_id=? ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String accid_st = "";

		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,car_mng_id);
				pstmt.setString(2,accid_id);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next()){
				accid_st = rs.getString("ACCID_ST")==null?"":rs.getString("ACCID_ST");
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return accid_st;
	}

	/**
     * 제1금융권(은행) 조회  ( 2004/08/21 ) - Yongsoon Kwon
     */
    public CodeBean [] getCodeAll_bank( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, USE_YN, VAR1, VAR2, VAR3, VAR4, VAR5, VAR6, ETC \n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='" + c_st + "'\n"
				+ " and (nm like '%은행%' or nm like '%금고%') "
        		+ "and CODE <> '0000' order by code";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeCodeBean(rs));
 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    
    
    /**
     * 코드 등록
     */
    
    public int insertCode(CodeBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
	               
		try{
        			
		  query="INSERT INTO CODE ( C_ST,\n"
								+ " CODE,\n"
								+ " NM_CD,\n"
								+ " NM,\n"
								+ " APP_ST,\n"
								+ " CMS_BK, var1, var2, var3, var4, var5, var6)\n"
          					   + " values(?,?,?,?,?,?,?,?,?,?,?,?)";

            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);

            pstmt.setString(1,  bean.getC_st().trim());
            pstmt.setString(2,  bean.getCode().trim());
            pstmt.setString(3,  bean.getNm_cd().trim());
            pstmt.setString(4,  bean.getNm().trim());
            pstmt.setString(5,  bean.getApp_st().trim());
            pstmt.setString(6,  bean.getCms_bk().trim());
            pstmt.setString(7,  bean.getVar1().trim());
            pstmt.setString(8,  bean.getVar2().trim());
            pstmt.setString(9,  bean.getVar3().trim());
            pstmt.setString(10,  bean.getVar4().trim());
            pstmt.setString(11, bean.getVar5().trim());
            pstmt.setString(12, bean.getVar6().trim());            
         
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
     * 코드 수정
     */
    public int updateCode(CodeBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
                
       try{
            
	       query="UPDATE CODE\n"
    			+ "SET NM_CD='"+bean.getNm_cd().trim()+"',\n"
	       		+ "NM='"+bean.getNm().trim()+"',\n"
	       		+ "CMS_BK='"+bean.getCms_bk().trim()+"',\n"
	       		+ "APP_ST='"+bean.getApp_st().trim()+"',\n"
   				+ "VAR1='"+bean.getVar1().trim()+"',\n"
				+ "VAR2='"+bean.getVar2().trim()+"',\n"
				+ "VAR3='"+bean.getVar3().trim()+"',\n"
   				+ "VAR4='"+bean.getVar4().trim()+"',\n"
				+ "VAR5='"+bean.getVar5().trim()+"',\n"
				+ "VAR6='"+bean.getVar6().trim()+"'\n"
    	       	+ "WHERE C_ST='"+bean.getC_st()+"'\n"
    	       	+ " AND CODE='"+bean.getCode()+"'\n";

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
     * 코드 삭제
     */
  
    public int deleteCode(CodeBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
     
        String query = "";
   
        int count = 0;
               
        query  = "DELETE CODE WHERE C_ST='"+bean.getC_st()+"' AND CODE='" + bean.getCode() +"'" ;
      
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
	 *	차령 구해서 리턴 재리스
	 */
	public Hashtable getOld(String cur_date, String rent_dt) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "SELECT "+
					" TRUNC( MONTHS_BETWEEN(TO_DATE(replace('"+ rent_dt +"','-',''), 'YYYYMMDD'), TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD'))/12) YEAR, "+
					" TRUNC( MONTHS_BETWEEN(TO_DATE(replace('"+ rent_dt +"','-',''), 'YYYYMMDD'), TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD')) - "+
					" TRUNC( MONTHS_BETWEEN(TO_DATE(replace('"+ rent_dt +"','-',''), 'YYYYMMDD'), TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD'))/12) * 12) MONTH, "+
					" TRUNC((MONTHS_BETWEEN(TO_DATE(replace('"+ rent_dt +"','-',''), 'YYYYMMDD'), TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD')) - "+
					" TRUNC( MONTHS_BETWEEN(TO_DATE(replace('"+ rent_dt +"','-',''), 'YYYYMMDD'), TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD')))) * 30.5) DAY "+ 
					" FROM DUAL ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			if(AddUtil.checkDate(rent_dt) && AddUtil.checkDate(cur_date)){	
				pstmt = con.prepareStatement(query);
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
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/**
	 *	차령 구해서 리턴 재리스 - rent_dt+-날짜 부터 cur_date까지
	 */
	public Hashtable getOld(String cur_date, String rent_dt, String days) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "SELECT "+
					" TRUNC( MONTHS_BETWEEN(TO_DATE(replace('"+ rent_dt +"','-',''), 'YYYYMMDD')"+days+", TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD'))/12) YEAR, "+
					" TRUNC( MONTHS_BETWEEN(TO_DATE(replace('"+ rent_dt +"','-',''), 'YYYYMMDD')"+days+", TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD')) - "+
					" TRUNC( MONTHS_BETWEEN(TO_DATE(replace('"+ rent_dt +"','-',''), 'YYYYMMDD')"+days+", TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD'))/12) * 12) MONTH, "+
					" TRUNC((MONTHS_BETWEEN(TO_DATE(replace('"+ rent_dt +"','-',''), 'YYYYMMDD')"+days+", TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD')) - "+
					" TRUNC( MONTHS_BETWEEN(TO_DATE(replace('"+ rent_dt +"','-',''), 'YYYYMMDD')"+days+", TO_DATE(replace('"+ cur_date +"','-',''), 'YYYYMMDD')))) * 30.5) DAY "+ 
					" FROM DUAL ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			if(AddUtil.checkDate(rent_dt) && AddUtil.checkDate(cur_date)){	
				pstmt = con.prepareStatement(query);
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
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	// vendor_st 
	public String getVendor_st(String ven_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT ven_st FROM vendor_view WHERE ven_code =? ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ven_st = "";
		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,ven_code);
			
		    	rs = pstmt.executeQuery();
   	
			while(rs.next()){
				ven_st = rs.getString("ven_st")==null?"":rs.getString("ven_st");
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ven_st;
	}

	/**
	 *	재난재해통지 대상자 조회(본사-남자)
	 */
	public Vector getAccidS1ManUserList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " SELECT * from users where use_yn='Y' and br_id='S1' and substr(user_ssn,7,1)='1' and dept_id not in ('8888') ";
//        String query = " SELECT * from users where user_id='000029'";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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

	/**
	 *	카드 소유자 리스트 조회
	 *  mode - CLIENT : 고객사용자, EMP : 사원사용자, BUS_EMP : 영업담당자, MNG_EMP : 관리담당자
	 */

public Vector getUserList2(String dept, String br_id, String gubun4) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		String query = "";
	  	
		query = " select "+
				" a.*, b.*, d.br_nm, e.nm dept_nm, c.user_nm, decode(a.card_st,'1','구매자금용','2','공용','3','임/직원지급용') card_st_nm"+
				" from card a, card_user b, users c, branch d, (select * from code where c_st='0002') e"+
				" where a.use_yn='Y' and c.use_yn = 'Y'"+
				" and a.cardno=b.cardno(+) and a.user_seq=b.seq(+) and b.user_id=c.user_id(+) and c.br_id=d.br_id(+) and c.dept_id=e.code(+) "+
//				" and a.CARD_KIND in ('우리비씨') "+
				" and b.user_id = '"+gubun4+"'";

//	System.out.println("[CommonDataBase:getUserList2]"+query);

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getUserList2]"+e);
			System.out.println("[CommonDataBase:getUserList2]"+query);
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

	/**
     * Code 전체 조회 ( 2001/12/28 ) - Kim JungTae
     */
    public CodeBean [] getCodeAll_0022( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT decode(substr(NM_CD,1,1),'S','1','D','2','B','3')  sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, USE_YN, VAR1, VAR2, VAR3, VAR4, VAR5, VAR6, ETC FROM CODE where C_ST='" + c_st + "' and CODE <> '0000' and nm_cd not like 'T%' ";

    	query +=" union ";
		query +=" select '1' sort, '0022' as C_ST , '' as CODE, 'S00' NM_CD, '=서울기준=' as NM, '' CMS_BK, '' APP_ST, '' USE_YN, '' VAR1, '' VAR2, '' VAR3, '' VAR4, '' VAR5, '' VAR6, '' ETC from dual ";
		query +=" union ";
		query +=" select '2' sort, '0022' as C_ST , '' as CODE, 'D00' NM_CD, '=대전기준=' as NM, '' CMS_BK, '' APP_ST, '' USE_YN, '' VAR1, '' VAR2, '' VAR3, '' VAR4, '' VAR5, '' VAR6, '' ETC from dual ";
		query +=" union ";
		query +=" select '3' sort, '0022' as C_ST , '' as CODE, 'B00' NM_CD, '=부산기준=' as NM, '' CMS_BK, '' APP_ST, '' USE_YN, '' VAR1, '' VAR2, '' VAR3, '' VAR4, '' VAR5, '' VAR6, '' ETC from dual ";
			       
      	query += " ORDER BY 1, 4 ";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeCodeBean(rs));
 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }

/*
     * Code 전체 조회 ( 2001/12/28 ) - Kim JungTae
     */
    public CodeBean [] getCodeAll_0022_t( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT decode(substr(NM_CD,1,1),'S','1','D','2','B','3')  sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, USE_YN, VAR1, VAR2, VAR3, VAR4, VAR5, VAR6, ETC FROM CODE where C_ST='" + c_st + "' and CODE <> '0000' and nm_cd  like 'T%' ";
    	query +=" union ";
		query +=" select '1' sort, '0022' as C_ST , '' as CODE, 'S00' NM_CD, '=서울기준=' as NM, '' CMS_BK, '' APP_ST, '' USE_YN, '' VAR1, '' VAR2, '' VAR3, '' VAR4, '' VAR5, '' VAR6, '' ETC from dual ";			       
      	query += " ORDER BY 1, 4 ";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeCodeBean(rs));
 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }


	/** 2009-02-09
	 *	사용자 리스트 조회 - 특근 수당 신청시 메신져로 메세지 받아 볼 담당자 찾기
	 *  mode - CLIENT : 고객사용자, EMP : 사원사용자, BUS_EMP : 영업담당자, MNG_EMP : 관리담당자
	 */
	public Vector getUserList_over_time(String dept, String br_id, String mode, String use_yn) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "select USER_ID, USER_NM, ID, DEPT_ID from USERS where user_id is not null";

        if(!use_yn.equals(""))				query += " and use_yn = '"+ use_yn +"' ";
        if(!dept.equals(""))				query += " and DEPT_ID = '"+ dept +"' ";
        if(!br_id.equals(""))				query += " and BR_ID = '"+ br_id +"' ";
		if(mode.equals("CLIENT"))			query += " and DEPT_ID is null ";
		else if(mode.equals("EMP"))			query += " and DEPT_ID is not null ";
		else if(mode.equals("BUS_EMP"))		query += " and DEPT_ID = '0001' ";
		else if(mode.equals("MNG_EMP"))		query += " and DEPT_ID = '0002' ";
		else if(mode.equals("GEN_EMP"))		query += " and DEPT_ID = '0003' ";
		else if(mode.equals("BUS_MNG_EMP")) query += " and DEPT_ID in ('0001','0002') ";
		else if(mode.equals("HEAD"))		query += " and USER_POS not in ('인턴사원','사원','대리','대표이사','주주','외부업체') ";
		else if(mode.equals("HEAD2"))		query += " and USER_ID in ('000003','000004','000005','000006','000052','000053') ";
		else if(mode.equals("BODY"))		query += " and USER_POS in ('사원','대리','과장') ";

		else if(mode.equals("BODY1"))		query += " and USER_ID in ('000004') "; //000004
		else if(mode.equals("BODY2"))		query += " and USER_ID in ('000005') "; //000005
		else if(mode.equals("BODY3"))		query += " and USER_ID in ('000006') "; //000006
		else if(mode.equals("BODY4"))		query += " and USER_ID in ('000053') "; //000053
		else if(mode.equals("BODY5"))		query += " and USER_ID in ('000052') "; //000052
		else if(mode.equals("BODY6"))		query += " and USER_ID in ('000003') "; //000003
		else if(mode.equals("BODY7"))		query += " and USER_ID in ('000237') "; //000063
		else if(mode.equals("BODY8"))		query += " and USER_ID in ('000237') "; //000237 IT팀장
		

		else if(mode.equals("BUS_ID"))		query += " and USER_ID in (select BUS_ID from cont group by BUS_ID) ";
		else if(mode.equals("BUS_ID2"))		query += " and USER_ID in (select BUS_ID2 from cont group by BUS_ID2) ";
		else if(mode.equals("MNG_ID"))		query += " and USER_ID in (select MNG_ID from cont group by MNG_ID) ";

		query += " ORDER BY dept_id, decode(user_pos,'사원',1,0) ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getUserList_over_time]"+e);
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

	// vendor_st 
	public String getCardDocVenSt(String ven_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT ven_st FROM card_doc WHERE ven_code =? and ven_st is not null "+
						" and (autodocu_data_no||autodocu_data_no) in (select max(autodocu_data_no||autodocu_data_no) from card_doc where ven_code =? and ven_st is not null group by autodocu_data_no||autodocu_data_no)";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ven_st = "";
		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,ven_code);
				pstmt.setString(2,ven_code);
			
		    	rs = pstmt.executeQuery();
   	
			if(rs.next()){
				ven_st = rs.getString("ven_st")==null?"":rs.getString("ven_st");
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ven_st;
	}

	// vendor_st 
	public String getTradeHisVenSt(String ven_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT ven_st FROM trade_his WHERE cust_code =? and ven_st is not null "+
						" and (reg_dt) in (select max(reg_dt) from trade_his where cust_code =? and ven_st is not null)";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ven_st = "";
		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,ven_code);
				pstmt.setString(2,ven_code);
			
		    	rs = pstmt.executeQuery();
   	
			if(rs.next()){
				ven_st = rs.getString("ven_st")==null?"":rs.getString("ven_st");
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ven_st;
	}

	/**
	 *	rent_l_cd로 rent_mng_id 구하기
	 */
	public String getRent_mng_id(String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "select rent_mng_id from cont where rent_l_cd='"+rent_l_cd+"'";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}
	
	
	/**
     * cms bank 
     */
    public Vector getCmsBank() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        
        String query = "";
        
        query = "SELECT bcode, bname FROM bnk ";

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
			System.out.println("[CommonDataBase:getCmsBank]"+e);
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
	
	
	// cms 정보 
	 
	public Hashtable getCmsBank_info(String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
            
	//	String query = "select cyj, cbnk, cbno  from cust where code='"+rent_l_cd+"' and cbit = '2'";
		
		String query = "select account_name as  cyj, bank_code as cbnk,  account_no as cbno  from cms.member_user  where cms_primary_seq ='"+rent_l_cd+"' and cms_status = '3'";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}
 
 
 	public Hashtable getCardCms_info(String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
            
	//	String query = "select cyj, cbnk, cbno  from cust where code='"+rent_l_cd+"' and cbit = '2'";
		
		String query = "select card_prid as  cyj, card_no as cbno  from cms.card_cms_mem  where cms_primary_seq ='"+rent_l_cd+"' and cms_status = 'Y'";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}
 
 
 
	/**
	 *	 전체직원수 가져오기 (퇴사3개월전 직원포함)
	 */
	public int getUserSize() throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rtn = 0;

		String query = " select nvl((a.cnt+b.cnt),0) cnt from "+
			           "        (select count(*) cnt from users where use_yn='Y' and dept_id<>'8888') a,"+
                 		"       (select count(*) cnt from users where use_yn='N' and out_dt >= to_char(add_months(sysdate,-3),'YYYYMMDD')) b";
		
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				 rtn = rs.getInt(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}
 
/* 해당팀 부서원만 조회 */

public Vector getUserListCooperation(String dept, String br_id, String mode, String use_yn) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "select USER_ID, USER_NM, ID, DEPT_ID, USER_POS, LOAN_ST from USERS where user_id is not null";

        if(!use_yn.equals(""))				query += " and use_yn = '"+ use_yn +"' ";
        if(!dept.equals(""))				query += " and DEPT_ID = '"+ dept +"' ";
        if(!br_id.equals(""))				query += " and BR_ID = '"+ br_id +"' ";
		if(mode.equals("CLIENT"))			query += " and DEPT_ID is null ";
		else if(mode.equals("EMP"))			query += " and DEPT_ID is not null ";
		else if(mode.equals("BUS_EMP"))		query += " and DEPT_ID = '0001' ";
		else if(mode.equals("MNG_EMP"))		query += " and DEPT_ID = '0002' ";
		else if(mode.equals("GEN_EMP"))		query += " and DEPT_ID = '0003' ";
		else if(mode.equals("BUS_MNG_EMP")) query += " and DEPT_ID in ('0001','0002') ";
		else if(mode.equals("HEAD"))		query += " and USER_POS not in ('인턴사원','사원','대리','대표이사','주주','외부업체') ";
		else if(mode.equals("HEAD2"))		query += " and USER_ID in ('000003','000004','000005','000006','000052','000053') ";
		else if(mode.equals("BODY"))		query += " and USER_POS in ('사원','대리','과장') ";

		else if(mode.equals("DEPT1"))		query += " and DEPT_ID in ('0001','0009') "; //000004 영업팀
		else if(mode.equals("DEPT2"))		query += " and DEPT_ID in ('0002') "; //000005 고객지원팀
		else if(mode.equals("DEPT3"))		query += " and DEPT_ID in ('0003') "; //000006 총무팀
		else if(mode.equals("DEPT7"))		query += " and DEPT_ID in ('0007') "; //000053 부산지점
		else if(mode.equals("DEPT8"))		query += " and DEPT_ID in ('0008') "; //000052 대전지점
		else if(mode.equals("DEPT9"))		query += " and DEPT_ID in ('0011') "; //000054 대구지점
		else if(mode.equals("DEPT10"))		query += " and DEPT_ID in ('0010') "; //000020 광주지점

		else if(mode.equals("BODY6"))		query += " and DEPT_ID in ('000003') "; //000003
		else if(mode.equals("BUS_ID"))		query += " and USER_ID in (select BUS_ID from cont group by BUS_ID) ";
		else if(mode.equals("BUS_ID2"))		query += " and USER_ID in (select BUS_ID2 from cont group by BUS_ID2) ";
		else if(mode.equals("MNG_ID"))		query += " and USER_ID in (select MNG_ID from cont group by MNG_ID) ";
		
		else if(mode.equals("LOAN"))		query += " and LOAN_ST in ('1', '2' ) "; 

		query += " ORDER BY dept_id, decode(user_pos,'사원',3,'대리', 2, '과장', 1, 0), USER_ID ";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getUserList_over_time]"+e);
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

/*	
쿨메신져 나한테 보내기
*/
/*
	public Vector getUserList_cooperation(String dept, String br_id, String mode, String use_yn) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "select USER_ID, USER_NM, ID, DEPT_ID from USERS where user_id is not null";

        if(!use_yn.equals(""))				query += " and use_yn = '"+ use_yn +"' ";
        if(!dept.equals(""))				query += " and DEPT_ID = '"+ dept +"' ";
        if(!br_id.equals(""))				query += " and BR_ID = '"+ br_id +"' ";
		if(mode.equals("CLIENT"))			query += " and DEPT_ID is null ";
		else if(mode.equals("EMP"))			query += " and DEPT_ID is not null ";
		else if(mode.equals("BUS_EMP"))		query += " and DEPT_ID = '0001' ";
		else if(mode.equals("MNG_EMP"))		query += " and DEPT_ID = '0002' ";
		else if(mode.equals("GEN_EMP"))		query += " and DEPT_ID = '0003' ";
		else if(mode.equals("BUS_MNG_EMP")) query += " and DEPT_ID in ('0001','0002') ";
		else if(mode.equals("HEAD"))		query += " and USER_POS not in ('인턴사원','사원','대리','대표이사','주주','외부업체') ";
		else if(mode.equals("HEAD2"))		query += " and USER_ID in ('000003','000004','000005','000006','000052','000053') ";
		else if(mode.equals("BODY"))		query += " and USER_POS in ('사원','대리','과장') ";
		
		else if(mode.equals("BODY1"))		query += " and USER_ID in ('000096') "; //000096 // 테스트
		else if(mode.equals("BODY2"))		query += " and USER_ID in ('000096') "; //000005
		else if(mode.equals("BODY3"))		query += " and USER_ID in ('000096') "; //000006
		else if(mode.equals("BODY4"))		query += " and USER_ID in ('000096') "; //000053
		else if(mode.equals("BODY5"))		query += " and USER_ID in ('000096') "; //000052
		else if(mode.equals("BODY6"))		query += " and USER_ID in ('000096') "; //000003

		else if(mode.equals("BUS_ID"))		query += " and USER_ID in (select BUS_ID from cont group by BUS_ID) ";
		else if(mode.equals("BUS_ID2"))		query += " and USER_ID in (select BUS_ID2 from cont group by BUS_ID2) ";
		else if(mode.equals("MNG_ID"))		query += " and USER_ID in (select MNG_ID from cont group by MNG_ID) ";

		query += " ORDER BY dept_id, decode(user_pos,'사원',1,0) ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getUserList_cooperation]"+e);
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
*/


	/**
	 *	계약코드와 계약관리번호로 문자발송할 사람 구하기
	 *  gubun - 1: 영업 , 2: 출고  gubun :1-> 차량이용자 (임시방편)
	 */
	public Hashtable getDmailSms(String m_id, String l_cd, String gubun) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
            
        String query = " select  \n" +
           			   "   decode(j.mgr_nm,'',decode(g.mgr_m_tel,'',decode(i.mgr_m_tel,'',decode(e.con_agnt_m_tel,'',e.client_nm,j.mgr_nm ),i.mgr_nm), g.mgr_nm), j.mgr_nm) nm,   \n" +
		               "   decode(j.mgr_m_tel,'',decode(g.mgr_m_tel,'',decode(i.mgr_m_tel,'',decode(e.con_agnt_m_tel,'',decode(e.client_st,'1','',e.m_tel),    j.mgr_m_tel),i.mgr_m_tel),g.mgr_m_tel),j.mgr_m_tel) tel, \n" +
		               "   d.rent_mng_id, d.rent_l_cd, decode(c.car_no,'',o.car_nm,c.car_no) car_no, \n" +
		               "   substr(e.firm_nm,1,10) firm_nm \n" +
					   "      from \n" +
					   "               cont d, client e, client_site f, car_reg c, car_etc b, car_nm a, car_mng o, \n" +
					   "               (select * from car_mgr where mgr_st='회계관리자') g, \n" +
					   "               (select * from car_mgr where mgr_st='차량관리자') i, \n" +
					   "               (select * from car_mgr where mgr_st='차량이용자') j \n" +
					   "      where    d.use_yn='Y' and d.car_st<>'2' and nvl(e.dly_sms,'Y')='Y' \n" +
					   "               and d.client_id=e.client_id \n" +
					   "               and d.client_id=f.CLIENT_ID(+) and d.r_site=f.seq(+) \n" +
					   "               and d.car_mng_id=c.car_mng_id(+) \n" +
					   "               and d.rent_mng_id=b.rent_mng_id and d.rent_l_cd=b.rent_l_cd and b.car_id=a.car_id and b.car_seq=a.car_seq and a.car_comp_id=o.car_comp_id and a.car_cd=o.code \n" +
					   "               and d.rent_mng_id=g.rent_mng_id and d.rent_l_cd=g.rent_l_cd \n" +
					   "               and d.rent_mng_id=i.rent_mng_id and d.rent_l_cd=i.rent_l_cd \n" +
					   "               and d.rent_mng_id=j.rent_mng_id and d.rent_l_cd=j.rent_l_cd \n" +
					   "               and d.rent_mng_id = '"+ m_id +"' and d.rent_l_cd = '"+ l_cd +"'";  
            
 					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}
	
	/**
	 *	계약코드와 계약관리번호로 문자발송할 사람 구하기
	 *  gubun :1-> 차량이용자 (임시방편) 2013-09-10
	 */
	public Hashtable getDmailSms2(String l_cd, String gubun) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
            
        String query = " select  \n" +
           			   "   decode(j.mgr_nm,'',decode(g.mgr_m_tel,'',decode(i.mgr_m_tel,'',decode(e.con_agnt_m_tel,'',e.client_nm,j.mgr_nm ),i.mgr_nm), g.mgr_nm), j.mgr_nm) nm,   \n" +
		               "   decode(j.mgr_m_tel,'',decode(g.mgr_m_tel,'',decode(i.mgr_m_tel,'',decode(e.con_agnt_m_tel,'',decode(e.client_st,'1','',e.m_tel),    j.mgr_m_tel),i.mgr_m_tel),g.mgr_m_tel),j.mgr_m_tel) tel, \n" +
		               "   d.rent_mng_id, d.rent_l_cd, decode(c.car_no,'',o.car_nm,c.car_no) car_no, \n" +
		               "   substr(e.firm_nm,1,10) firm_nm \n" +
					   "      from \n" +
					   "               cont d, client e, client_site f, car_reg c, car_etc b, car_nm a, car_mng o, \n" +
					   "               (select * from car_mgr where mgr_st='회계관리자') g, \n" +
					   "               (select * from car_mgr where mgr_st='차량관리자') i, \n" +
					   "               (select * from car_mgr where mgr_st='차량이용자') j \n" +
					   "      where    d.use_yn='Y' and d.car_st<>'2' and nvl(e.dly_sms,'Y')='Y' \n" +
					   "               and d.client_id=e.client_id \n" +
					   "               and d.client_id=f.CLIENT_ID(+) and d.r_site=f.seq(+) \n" +
					   "               and d.car_mng_id=c.car_mng_id(+) \n" +
					   "               and d.rent_mng_id=b.rent_mng_id and d.rent_l_cd=b.rent_l_cd and b.car_id=a.car_id and b.car_seq=a.car_seq and a.car_comp_id=o.car_comp_id and a.car_cd=o.code \n" +
					   "               and d.rent_mng_id=g.rent_mng_id and d.rent_l_cd=g.rent_l_cd \n" +
					   "               and d.rent_mng_id=i.rent_mng_id and d.rent_l_cd=i.rent_l_cd \n" +
					   "               and d.rent_mng_id=j.rent_mng_id and d.rent_l_cd=j.rent_l_cd \n" +
					   "               and d.rent_l_cd = '"+ l_cd +"'";  
            
 					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/**
	 *	계약코드와 계약관리번호로 문자발송할 사람 구하기
	 *  gubun - 1: 영업 , 2: 출고 
	 */
	public Hashtable getDmailSms(String m_id, String l_cd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
            
        String query = " select  \n" +
		               "   decode(e.con_agnt_m_tel,'',decode(g.mgr_m_tel,'',decode(i.mgr_m_tel,'',decode(j.mgr_m_tel,'',e.client_nm,j.mgr_nm ),i.mgr_nm), g.mgr_nm), e.con_agnt_nm) nm, \n" +
		               "   decode(e.con_agnt_m_tel,'',decode(g.mgr_m_tel,'',decode(i.mgr_m_tel,'',decode(j.mgr_m_tel,'',decode(e.client_st,'1','',e.m_tel),    j.mgr_m_tel),i.mgr_m_tel),g.mgr_m_tel),e.con_agnt_m_tel) tel, \n" +
		               "   d.rent_mng_id, d.rent_l_cd, decode(c.car_no,'',o.car_nm,c.car_no) car_no, \n" +
		               "   substr(e.firm_nm,1,10) firm_nm \n" +
					   "      from \n" +
					   "               cont d, client e, client_site f, car_reg c, car_etc b, car_nm a, car_mng o, \n" +
					   "               (select * from car_mgr where mgr_st='회계관리자') g, \n" +
					   "               (select * from car_mgr where mgr_st='차량관리자') i, \n" +
					   "               (select * from car_mgr where mgr_st='차량이용자') j \n" +
					   "      where    d.use_yn='Y' and d.car_st<>'2' and nvl(e.dly_sms,'Y')='Y' \n" +
					   "               and d.client_id=e.client_id \n" +
					   "               and d.client_id=f.CLIENT_ID(+) and d.r_site=f.seq(+) \n" +
					   "               and d.car_mng_id=c.car_mng_id(+) \n" +
					   "               and d.rent_mng_id=b.rent_mng_id and d.rent_l_cd=b.rent_l_cd and b.car_id=a.car_id and b.car_seq=a.car_seq and a.car_comp_id=o.car_comp_id and a.car_cd=o.code \n" +
					   "               and d.rent_mng_id=g.rent_mng_id and d.rent_l_cd=g.rent_l_cd \n" +
					   "               and d.rent_mng_id=i.rent_mng_id and d.rent_l_cd=i.rent_l_cd \n" +
					   "               and d.rent_mng_id=j.rent_mng_id and d.rent_l_cd=j.rent_l_cd \n" +
					   "               and d.rent_mng_id = '"+ m_id +"' and d.rent_l_cd = '"+ l_cd +"'";  
            
 					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}
	
	
	
	
	/**
	 *	 계약번호로 담당자 조회하기 2004.5.28. Yongsoon Kwon.
	 */
	public Hashtable getDamdang(String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT u.user_nm, u.user_m_tel,  u.user_h_tel, u.hot_tel  FROM cont a, users u WHERE a.rent_l_cd= ?  and a.mng_id = u.user_id ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);				
				pstmt.setString(1,rent_l_cd);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}
	
	
	/**
	 *	tax_no로 rent_l_cd 구하기
	 */
	public String getTaxRent_l_cd(String tax_no) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "select  rent_l_cd  from tax a where a.tax_no = '"+tax_no+"' and unity_chk = '0' ";

		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}
	
	/**
	 *	tax_no로 rent_l_cd 구하기
	 */
	public String getTaxItemListRent_l_cd(String item_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "select  rent_l_cd  from tax_item_list where item_id = '"+item_id+"' and item_seq=1 ";

		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}
	
	/**
     * 금융사 조회
     */
    public Vector getBankList() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");        
        
        String query = "";

        
        query = "SELECT  CODE, NM_CD, NM FROM CODE \n"
        		+ "where C_ST = '0003' and CODE <> '0000' order by NM \n";        		

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
    
    
    /**
     * 홈페이지 당직자 구분
     */
	public String getWatch_id(String cur_date) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

	//   select substr(to_char(sysdate,'YYYYMMddhh24miss'), 9, 4) from dual;
		String cal_date = cur_date;			
	
        String query = "SELECT  member_id FROM sch_watch where start_year||start_mon|| start_day = replace(?, '-', '') and watch_type = '2' ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String watch_id = "";
		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,cal_date);
			
		    	rs = pstmt.executeQuery();
   	
			while(rs.next()){
				watch_id = rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return watch_id;
		}
	}
	
	public String getWatch_id(String cur_date, String type) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

	//   select substr(to_char(sysdate,'YYYYMMddhh24miss'), 9, 4) from dual;
		String cal_date = cur_date;			
	
    	    String query = "SELECT  member_id5 FROM sch_watch where start_year||start_mon|| start_day = replace(?, '-', '') and watch_type = ? ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String watch_id = "";
		try {
			    pstmt = con.prepareStatement(query);
			    pstmt.setString(1,cal_date);
			    pstmt.setString(2,type);
			
		    	rs = pstmt.executeQuery();
   	
			while(rs.next()){
				watch_id = rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return watch_id;
		}
	}
	

	/**
	 *	개월수조희
	 */
	public String getMons(String use_e_dt, String use_s_dt) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "SELECT MONTHS_BETWEEN(TO_DATE(replace('"+ use_e_dt +"','-',''), 'YYYYMMDD')+1, TO_DATE(replace('"+ use_s_dt +"','-',''), 'YYYYMMDD')) MONTH FROM DUAL ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String mons = "";
		try {
			if(AddUtil.checkDate(use_e_dt) && AddUtil.checkDate(use_s_dt)){
				pstmt = con.prepareStatement(query);
			    rs = pstmt.executeQuery();

				if(rs.next())
				{
					mons = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
			    pstmt.close();
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return mons;
	}

	/**
	 *	개월수조희
	 */
	public String getMons2(String use_e_dt, String use_s_dt) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "SELECT MONTHS_BETWEEN(TO_DATE(replace('"+ use_e_dt +"','-',''), 'YYYYMMDD'), TO_DATE(replace('"+ use_s_dt +"','-',''), 'YYYYMMDD')) MONTH FROM DUAL ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String mons = "";
		try {
			if(AddUtil.checkDate(use_e_dt) && AddUtil.checkDate(use_s_dt)){
				pstmt = con.prepareStatement(query);
			    rs = pstmt.executeQuery();

				if(rs.next())
				{
					mons = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
			    pstmt.close();
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return mons;
	}
	
	
	
	/**
	 *	일수조희
	 */
	public int getDays(String use_e_dt, String use_s_dt) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "SELECT  TO_DATE(replace('"+ use_e_dt +"','-',''), 'YYYYMMDD')+1 -  TO_DATE(replace('"+ use_s_dt +"','-',''), 'YYYYMMDD') DAYS FROM DUAL ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int days = 0;
		try {
			if(AddUtil.checkDate(use_e_dt) && AddUtil.checkDate(use_s_dt)){	
				pstmt = con.prepareStatement(query);
			    rs = pstmt.executeQuery();

				if(rs.next())
				{
					days = rs.getInt(1);
				}
				rs.close();
			    pstmt.close();
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return days;
	}

	/**
	 *	일수조희
	 */
	public int getDays2(String use_e_dt, String use_s_dt) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "SELECT  TO_DATE(replace('"+ use_e_dt +"','-',''), 'YYYYMMDD') -  TO_DATE(replace('"+ use_s_dt +"','-',''), 'YYYYMMDD') DAYS FROM DUAL ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int days = 0;
		try {
			if(AddUtil.checkDate(use_e_dt) && AddUtil.checkDate(use_s_dt)){	
				pstmt = con.prepareStatement(query);
			    rs = pstmt.executeQuery();

				if(rs.next())
				{
					days = rs.getInt(1);
				}
				rs.close();
			    pstmt.close();
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return days;
	}
	

	/**
     * 계좌관리 조회
     */
    public Vector getBankAccList(String off_st, String off_id, String use_yn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");        
        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
        
        query = " select b.code as bank_cd, b.nm as  bank_nm, b.cms_bk, decode(a.acc_st,'1','영구계좌','2','가상계좌') acc_st_nm, a.* \n"+
				" from   bank_acc a, (select * from code where c_st='0003' and code<>'0000') b \n"+
				" where  a.off_st=? and a.off_id=? and a.bank_id=b.code \n"+
				" ";
        		 
		if(!use_yn.equals("")) query += " and nvl(a.use_yn,'Y')='"+use_yn+"'";

		query += " order by b.nm ";

		try {
		    pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		off_st);
			pstmt.setString	(2,		off_id);
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
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/**
     * 계좌관리 조회
     */
    public BankAccBean getBankAcc(String off_st, String off_id, int seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");        
        		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BankAccBean bean = new BankAccBean();
        String query = "";
        
        query = " select * from bank_acc where off_st=? and off_id=? and seq=? ";
        		 
		try {
		    pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		off_st);
			pstmt.setString	(2,		off_id);
			pstmt.setInt	(3,		seq);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setOff_st		(rs.getString("off_st")		==null?"":rs.getString("off_st"));
				bean.setOff_id		(rs.getString("off_id")		==null?"":rs.getString("off_id"));
				bean.setSeq			(rs.getInt   ("seq"));
	 			bean.setBank_id		(rs.getString("bank_id")	==null?"":rs.getString("bank_id"));	
				bean.setAcc_st		(rs.getString("acc_st")		==null?"":rs.getString("acc_st"));
				bean.setAcc_no		(rs.getString("acc_no")		==null?"":rs.getString("acc_no"));
				bean.setAcc_nm		(rs.getString("acc_nm")		==null?"":rs.getString("acc_nm"));
				bean.setUse_yn		(rs.getString("use_yn")		==null?"":rs.getString("use_yn"));
				bean.setEtc			(rs.getString("etc")		==null?"":rs.getString("etc"));	
				bean.setReg_id		(rs.getString("reg_id")		==null?"":rs.getString("reg_id"));	
				bean.setReg_dt		(rs.getString("reg_dt")		==null?"":rs.getString("reg_dt"));
				bean.setUpdate_id	(rs.getString("update_id")	==null?"":rs.getString("update_id"));
				bean.setUpdate_dt	(rs.getString("update_dt")	==null?"":rs.getString("update_dt"));
				bean.setAcc_ssn		(rs.getString("acc_ssn")	==null?"":rs.getString("acc_ssn"));
				bean.setAcc_zip		(rs.getString("acc_zip")	==null?"":rs.getString("acc_zip"));
				bean.setAcc_addr	(rs.getString("acc_addr")	==null?"":rs.getString("acc_addr"));
				bean.setFile_name1	(rs.getString("FILE_NAME1")	==null?"":rs.getString("FILE_NAME1"));
				bean.setFile_name2	(rs.getString("FILE_NAME2")	==null?"":rs.getString("FILE_NAME2"));
				bean.setFile_gubun1	(rs.getString("FILE_GUBUN1")==null?"":rs.getString("FILE_GUBUN1"));
				bean.setFile_gubun2	(rs.getString("FILE_GUBUN2")==null?"":rs.getString("FILE_GUBUN2"));

			}

			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return bean;
	}

    /**
     * 계좌관리 등록
     */
    
    public int insertBankAcc(BankAccBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
	               
		query = " INSERT INTO bank_acc "+
				"             ( off_st, off_id, seq, bank_id, acc_st, acc_no, acc_nm, use_yn, etc, reg_id, reg_dt, acc_ssn, acc_zip, acc_addr, conf_st ) \n"+
          		"	   values ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), replace(?,'-',''), ?, ?, ?)";

		try{
        			

            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getOff_st		().trim());
            pstmt.setString(2, bean.getOff_id		().trim());
            pstmt.setInt   (3, bean.getSeq			());
            pstmt.setString(4, bean.getBank_id		().trim());
            pstmt.setString(5, bean.getAcc_st		().trim());
            pstmt.setString(6, bean.getAcc_no		().trim());
            pstmt.setString(7, bean.getAcc_nm		().trim());
            pstmt.setString(8, bean.getUse_yn		().trim());
            pstmt.setString(9, bean.getEtc			().trim());
            pstmt.setString(10,bean.getReg_id		().trim());
            pstmt.setString(11,bean.getAcc_ssn		().trim());
            pstmt.setString(12,bean.getAcc_zip		().trim());
            pstmt.setString(13,bean.getAcc_addr		().trim());
            pstmt.setString(14,bean.getConf_st		().trim());
         
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
     * 계좌관리 수정 
     */
    public int updateBankAcc(BankAccBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE bank_acc SET "+
				"        bank_id = ?, acc_st = ?, acc_no = ?, acc_nm = ?, "+
				"        use_yn = ?, etc = ?, "+
				"        acc_ssn = ?, acc_zip = ?, acc_addr = ?, "+
				"		 update_id  = ?, update_dt=to_char(sysdate,'YYYYMMDD'), conf_st = ?  "+
				" WHERE  off_st=? and off_id=? and seq=? ";
            
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt.setString(1, bean.getBank_id		());
			pstmt.setString(2, bean.getAcc_st		());
            pstmt.setString(3, bean.getAcc_no		());
            pstmt.setString(4, bean.getAcc_nm		());
            pstmt.setString(5, bean.getUse_yn		());
            pstmt.setString(6, bean.getEtc			());
			pstmt.setString(7, bean.getAcc_ssn		());
            pstmt.setString(8, bean.getAcc_zip		());
            pstmt.setString(9, bean.getAcc_addr		());
			pstmt.setString(10,bean.getUpdate_id	());
            pstmt.setString(11,bean.getConf_st		());
            pstmt.setString(12,bean.getOff_st		());
            pstmt.setString(13,bean.getOff_id		());
            pstmt.setInt   (14,bean.getSeq			());
            count = pstmt.executeUpdate();             

			pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception:updateBankAcc(BankAccBean bean)");
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
     * 계좌관리 삭제
     */
  
    public int deleteBankAcc(BankAccBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;    
        String query = "";   
        int count = 0;
               
        query  = "DELETE bank_acc WHERE  off_st=? and off_id=? and seq=? " ;
      
		try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getOff_st		());
            pstmt.setString(2, bean.getOff_id		());
            pstmt.setInt   (3, bean.getSeq			());
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
	 *	월만 축출
	 */
	public String getDtMonth(String dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String mon="";

        String query = " select to_char(to_date(replace('"+dt+"','-',''),'YYYYMMDD'),'MM') mon from dual ";
		
		try {
			if(AddUtil.checkDate(dt)){	
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();    	
				if(rs.next())
				{				
					mon = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
				pstmt.close();
			}
		} catch (SQLException e) {
			System.out.println("[CommonDataBase:getDtMonth]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return mon;
	}


	/**
	 *	담당자조회
	 */
	public String getContMng_id(String car_mng_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "  select mng_id from cont_n_view where /*use_yn='Y' and */ car_mng_id='"+car_mng_id+"' ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String mng_id="";
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				mng_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CommonDataBase:getContMng_id]"+e);
			System.out.println("[CommonDataBase:getContMng_id]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return mng_id;
	}


	/**
	 *	매입옵션 관련서류 우편발송 문자 받을 담당자조회 20140312 류길선
	 */
	public String getOff_ls_after_sui_Mng_id(String car_mng_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        //String query = " select mng_id from cont_view where car_mng_id='"+car_mng_id+"' AND cls_st = '8' ";

	//	String query = " SELECT a.mng_id FROM CONT a, CLS_CONT b WHERE a.car_mng_id='"+car_mng_id+"' AND b.cls_st='8' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd ";
		//실제 기안자에게 메세지 전달 
		String query = " SELECT nvl(c.reg_id, a.mng_id)  FROM CONT a, CLS_CONT b , cls_etc c  "  
				 + " WHERE a.car_mng_id='"+car_mng_id+"' AND b.cls_st='8' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) ";
		
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String mng_id="";
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				mng_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CommonDataBase:getOff_ls_after_sui_Mng_id]"+e);
			System.out.println("[CommonDataBase:getOff_ls_after_sui_Mng_id]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return mng_id;
	}
 
	public String getOff_ls_after_sui_Mng_id_l_cd(String rent_l_cd ) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        //String query = " select mng_id from cont_view where car_mng_id='"+car_mng_id+"' AND cls_st = '8' ";

	//	String query = " SELECT a.mng_id FROM CONT a WHERE a.rent_l_cd='"+rent_l_cd+"' ";
		String query = " SELECT a.reg_id FROM cls_etc a WHERE a.rent_l_cd='"+rent_l_cd+"' ";  //매입옵션 기안자 
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String mng_id="";
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				mng_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CommonDataBase:getOff_ls_after_sui_Mng_id]"+e);
			System.out.println("[CommonDataBase:getOff_ls_after_sui_Mng_id]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return mng_id;
	}

    public CodeBean [] getLendCptCdAll() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.C_ST, a.CODE, a.NM_CD, a.NM, a.CMS_BK, a.APP_ST, a.USE_YN, a.VAR1, a.VAR2, a.VAR3, a.VAR4, a.VAR5, a.VAR6, a.ETC \n"+
				" FROM   (SELECT * FROM CODE WHERE c_st='0003' AND CODE<>'0000') a,  \n"+
				"        (SELECT cont_st, cont_bn FROM LEND_BANK GROUP BY cont_st, cont_bn ) b \n"+
				" WHERE  a.code=b.cont_bn \n"+
				" ORDER BY b.cont_st, a.nm ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCodeBean(rs)); 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    /**
     * 은행대출관리 개별 검색
     * author : 성승현
     * date : 2016. 04. 12.
     */
    public CodeBean [] getLendCptCdAll(String gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        String subQuery = "";

        if(gubun.equals("1") || gubun.equals("2") || gubun.equals("3") || gubun.equals("4")) subQuery = " and c.GUBUN='"+gubun+"'";
        
        query = " SELECT a.C_ST, a.CODE, a.NM_CD, a.NM, a.CMS_BK, a.APP_ST, c.GUBUN \n"+
				" FROM (SELECT * FROM CODE WHERE c_st='0003' AND CODE<>'0000') a,  \n"+
				"         (SELECT cont_st, cont_bn FROM LEND_BANK GROUP BY cont_st, cont_bn ) b, CODE_ETC c \n"+
				" WHERE  a.code=b.cont_bn(+) and a.C_ST=c.C_ST(+) and a.CODE=c.CODE(+)\n"+subQuery;
				
        
        query += " ORDER BY b.cont_st, a.nm ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCodeBean3(rs)); 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    
    public CodeBean [] getAllotCptCdAll() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.C_ST, a.CODE, a.NM_CD, a.NM, a.CMS_BK, a.APP_ST, a.USE_YN, a.VAR1, a.VAR2, a.VAR3, a.VAR4, a.VAR5, a.VAR6, a.ETC \n"+
				" FROM   (SELECT * FROM CODE WHERE c_st='0003' AND CODE<>'0000') a,  \n"+
				"        (SELECT cpt_cd_st, cpt_cd FROM allot GROUP BY cpt_cd_st, cpt_cd ) b \n"+
				" WHERE  a.code=b.cpt_cd \n"+
				" ORDER BY b.cpt_cd_st, a.nm ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCodeBean(rs)); 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }

    public CodeBean [] getDebtCptCdAll() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.C_ST, a.CODE, a.NM_CD, a.NM, a.CMS_BK, a.APP_ST, a.USE_YN, a.VAR1, a.VAR2, a.VAR3, a.VAR4, a.VAR5, a.VAR6, a.ETC \n"+
				" FROM   (SELECT * FROM CODE WHERE c_st='0003' AND CODE<>'0000') a,  \n"+
				"        (SELECT cpt_cd FROM debt_pay_view GROUP BY cpt_cd ) b \n"+
				" WHERE  a.code=b.cpt_cd \n"+
				" ORDER BY a.nm ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCodeBean(rs)); 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }

    public CodeBean [] getFundCptCdAll() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT a.C_ST, a.CODE, a.NM_CD, a.NM, a.CMS_BK, a.APP_ST, a.USE_YN, a.VAR1, a.VAR2, a.VAR3, a.VAR4, a.VAR5, a.VAR6, a.ETC \n"+
				" FROM   (SELECT * FROM CODE WHERE c_st='0003' AND CODE<>'0000') a,  \n"+
				"        (SELECT cont_bn_st, cont_bn FROM WORKING_FUND GROUP BY cont_bn_st, cont_bn ) b \n"+
				" WHERE  a.code=b.cont_bn \n"+
				" ORDER BY b.cont_bn_st, a.nm ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCodeBean(rs)); 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    /**
     * 자금관리 개별 검색
     * author : 성승현
     * date : 2016. 04. 12.
     */
    public CodeBean [] getFundCptCdAll(String gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        String subQuery = "";

        if(gubun.equals("1") || gubun.equals("2") || gubun.equals("3") || gubun.equals("4")) subQuery = " and c.GUBUN='"+gubun+"'";

        query = " SELECT a.C_ST, a.CODE, a.NM_CD, a.NM, a.CMS_BK, a.APP_ST, c.GUBUN \n"+
				" FROM   (SELECT * FROM CODE WHERE c_st='0003' AND CODE<>'0000') a,  \n"+
				"        (SELECT cont_bn_st, cont_bn FROM WORKING_FUND GROUP BY cont_bn_st, cont_bn ) b, CODE_ETC c \n"+
				" WHERE  a.code=b.cont_bn and a.C_ST=c.C_ST(+) and a.CODE=c.CODE(+)\n"+subQuery;		
        
        query += " ORDER BY b.cont_bn_st, a.NM ";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCodeBean3(rs)); 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }


//출고점(자동차)
	public Vector OutCarJCList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT * FROM PARTNER_OFFICE WHERE  po_gubun  =  '1' ";


		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
//System.out.println("mode: "+mode);
//System.out.println("common: "+query);
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
			System.out.println("[CommonDataBase:getUserList]"+e);
			System.out.println("[CommonDataBase:getUserList]"+query);
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


	/**
     * 도로명 우편번호 검색
     */
	public Vector getZipDoro(String dongStr) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		String sql = " select distinct substr(ZIP_CD,1,3)||'-'||substr(ZIP_CD,4,3) ZIP_CD, SIDO, GUGUN, DONG, EUPMYUN, DORO, DARAYNG from ZIP_DORO where DORO like '%" + dongStr + "%' order by 1,2,3,4,5,6";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		try {
			    pstmt = con.prepareStatement(sql);
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
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/**
     * 도로명 우편번호 검색
     */
	public Vector getZipDoro(String doro, String dong_yn, String swd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		String sql = " select substr(ZIP_CD,1,3)||'-'||substr(ZIP_CD,4,3) ZIP_CD, SIDO, GUGUN, DONG, EUPMYUN, DORO, DARAYNG "+
					 " from   ZIP_DORO where DORO like '%" + doro + "%' ";
	
		if(dong_yn.equals("Y") && !swd.equals("")) sql += " and EUPMYUN||DONG like '%"+swd+"%' ";

		sql += " order by 1,2,3,4,5,6";



		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		try {
			    pstmt = con.prepareStatement(sql);
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
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


	/*
	*	매각결정차량 탁송의뢰일 등록
	*/
	public int updateCons_dt( String car_mng_id)  throws DatabaseException, DataSourceEmptyException
	{
        		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            		throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;

		int result = 0;
		
		try{
			con.setAutoCommit(false);
				
			pstmt = con.prepareStatement("UPDATE car_reg set cons_dt = to_char(sysdate,'YYYYMMdd' )  WHERE car_mng_id =? ");
			pstmt.setString(1,car_mng_id);		
			result = pstmt.executeUpdate();
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
	        return result;
	    }
	
	/*
	*	매각결정차량 취소시 탁송의뢰일 리셋
	*/
	public int updateCons_dtNOT( String car_mng_id)  throws DatabaseException, DataSourceEmptyException
	{
        		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            		throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;

		int result = 0;
		
		try{
			con.setAutoCommit(false);
				
			pstmt = con.prepareStatement("UPDATE car_reg set cons_dt = ''  WHERE car_mng_id =? ");
			pstmt.setString(1,car_mng_id);		
			result = pstmt.executeUpdate();
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
	        return result;
	    }

	/*
	*	매각결정차량 취소시 경매장 리셋
	*/
	public int updateActn_idReset( String car_mng_id)  throws DatabaseException, DataSourceEmptyException
	{
        		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            		throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;

		int result = 0;
		
		try{
			con.setAutoCommit(false);
				
			pstmt = con.prepareStatement("UPDATE APPRSL set actn_id = ''  WHERE car_mng_id =? ");
			pstmt.setString(1,car_mng_id);		
			result = pstmt.executeUpdate();
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
	        return result;
	    }



	/**
	 *	대문자변환
	 */
	public String getReplaceUpper(String var) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " select upper('"+var+"') replace_var from dual ";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String replace_var ="";
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				replace_var = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CommonDataBase:getReplaceUpper]"+e);
			System.out.println("[CommonDataBase:getReplaceUpper]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return replace_var;
	}


	//네비게이션 ------------------------------------------------------------------------------------------------

	//네비게이션 리스트 조회 : 
	public Vector getNaviStatList()  throws DatabaseException, DataSourceEmptyException
	{
		    Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
     		       throw new DataSourceEmptyException("Can't get Connection !!");
			
		String query = " select * from navi_reg order by decode(gubun, '','1','R','2','3') , reg_dt";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
	
   /**
     * navi 등록
     */

    public int insertNavi(NaviBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
	               
		try{
        			
		  query="INSERT INTO NAVI_REG ( SERIAL_NO,\n"
								+ " MODEL,\n"
								+ " GUBUN,\n"
								+ " REMARK,\n"
								+ " REG_DT)\n"
          					   + " values (  ?, ?, ?, ?,  to_char(sysdate,'YYYYMMdd') )";

            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getSerial_no().trim());
            pstmt.setString(2, bean.getModel().trim());
            pstmt.setString(3, bean.getGubun().trim());
            pstmt.setString(4, bean.getRemark().trim());
                
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
     * navi 수정
     */
     
    public int updateNavi(NaviBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
                
       try{
            
	       query="UPDATE NAVI_REG \n"
    			+ " SET MODEL='"+bean.getModel().trim()+"',\n"
	       		+ " GUBUN='"+bean.getGubun().trim()+"',\n"
	       		+ " REMARK='"+bean.getRemark().trim()+"',\n"
	       		+ " UPD_DT=to_char(sysdate,'YYYYMMdd' ) \n"
    	       	+ " WHERE SERIAL_NO='"+bean.getSerial_no()+"'\n";
    	       	
//System.out.println("updateNavi(: "+query);
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
	
	//네비게이션 리스트 조회 : 
	public Vector getNaviStatListY()  throws DatabaseException, DataSourceEmptyException
	{
		    Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
     		       throw new DataSourceEmptyException("Can't get Connection !!");
			
		String query = " select * from navi_reg  where nvl(gubun, 'Y' ) not in ( 'N', 'R', 'M' )  order by reg_dt";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
	
	
	 /**
     * navi 수정
     */
     
    public int updateNaviStatus(String serial_no, String gubun, String remark ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
                
       try{
            
	       query="UPDATE NAVI_REG \n"
    			+ " SET GUBUN='"+gubun+"',\n"
	       		+ " REMARK='"+remark+"',\n"
	       		+ " UPD_DT=to_char(sysdate,'YYYYMMdd' ) \n"
    	       	+ " WHERE SERIAL_NO='"+serial_no+"'\n";
    	       	
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


	public int updateRent_feeNavi(String rent_s_cd, String serial_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
                
       try{
            
	       query="UPDATE rent_fee \n"
    			+ " SET serial_no='"+serial_no+"',\n"
	       		+ " update_dt=to_char(sysdate,'YYYYMMdd' ) \n"
    	       	+ " WHERE rent_s_cd='"+rent_s_cd+"'\n";
    	       	
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
    
	//월렌트-장기 네비등록
	public int updateFee_rmNavi(String rent_l_cd, String serial_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
                
       try{
            
	       query="UPDATE fee_rm \n"
    			+ " SET serial_no='"+serial_no+"',\n"
	       		+ " update_dt=to_char(sysdate,'YYYYMMdd' ) \n"
    	       	+ " WHERE rent_l_cd='"+rent_l_cd+"'\n";
    	       	
//System.out.println("updateFee_rmNavi(: "+query);

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
	*	월렌트 월대여료대비 적용율
	*/
	
    public Hashtable getEstiRmDayPers(String per)throws DatabaseException, DataSourceEmptyException
    {
	        Connection con = connMgr.getConnection(DATA_SOURCE);
	
	        if(con == null)
	            throw new DataSourceEmptyException("Can't get Connection !!");
	              
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
     		
		String var1 = "0.15";

		if(per.equals("")) per = "0";

		String query =  " SELECT \n";

		for (int i = 0 ; i < 30 ; i++){
			query +=	" ROUND( ("+var1+"+ROUND(POWER("+(i+1)+",1/2)/POWER(30,1/2)*(1-"+var1+"),2)) * 100 / (1-"+per+"), 0) AS per_"+(i+1)+", \n";	
		}

		query +=	" "+per+" as per "+
						" FROM   dual \n"+
						" ";

		try{

		//	System.out.println("[SecondhandDatabase:getEstiRmDayPers]"+query);

			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
            		pstmt.close();
		}catch(Exception e){		
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			   }catch(SQLException _ignored){}
				connMgr.freeConnection(DATA_SOURCE, con);
				con = null;
		  }
		 return ht;
		
	}
      
      
      public Vector getCodeAllV_0022( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        
        String query = "";
        
        query = " SELECT decode(substr(NM_CD,1,1),'S','1','D','2','B','3')  sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST FROM CODE where C_ST='" + c_st + "' and CODE <> '0000' and (  nm_cd not like 'T%'  and  nm_cd not like 'W%' ) ";
 

    	query +=" union ";
		query +=" select '1' sort, '0022' as C_ST , '' as CODE, 'S00' NM_CD, '=서울기준=' as NM , '' CMS_BK, '' APP_ST  from dual ";
		query +=" union ";
		query +=" select '2' sort, '0022' as C_ST , '' as CODE, 'D00' NM_CD, '=대전기준=' as NM, '' CMS_BK, '' APP_ST from dual ";
		query +=" union ";
		query +=" select '3' sort, '0022' as C_ST , '' as CODE, 'B00' NM_CD, '=부산기준=' as NM , '' CMS_BK, '' APP_ST from dual ";
			       
      	query += " ORDER BY 1, 4 ";

//System.out.println("[CommonDataBase:getCodeAll_0022]"+query);

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
			System.out.println("[CommonDataBase:getCodeAllV_0022]"+e);
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

 public Vector getCodeAllV_0022_all( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        
        String query = "";
        
        query = " SELECT decode(substr(NM_CD,1,1),'S','1','T', '2', 'C', '3', 'E', '4', 'F', '5', 'G', '5', 'D','6','B','7' ,'W', '8')  sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST FROM CODE where C_ST='" + c_st + "' and  code <> '0000'     \n";

        query +="   	 union  \n ";
        query +="select '1' sort, '0022' as C_ST , '00' as CODE, 'S00' NM_CD, '=== 서울기준  ===' as NM , '' CMS_BK, '' APP_ST  from dual   \n ";
        query +="	 union  \n ";
        query +="select '2' sort, '0022' as C_ST , '00' as CODE, 'T00' NM_CD, '=== 서울기준 ===' as NM , '' CMS_BK, '' APP_ST  from dual  \n ";
        query +="		 union   \n ";
        query +="select '3' sort, '0022' as C_ST , '00' as CODE, 'C00' NM_CD, '==서울기준(영남 및 그외정비소 출발/도착)==' as NM, '' CMS_BK, '' APP_ST from dual   \n ";
        query +="	 union  \n ";
        query +="select '4' sort, '0022' as C_ST , '00' as CODE, 'E00' NM_CD, '==서울기준(정비소(오토크린,아마존모터스,강서모터스) 출발/도착)==' as NM , '' CMS_BK, '' APP_ST from dual   \n ";
        query +="	union  \n ";
        query +="select '5' sort, '0022' as C_ST , '00' as CODE, 'F00' NM_CD, '==서울기준(공통)==' as NM , '' CMS_BK, '' APP_ST from dual   \n ";
        query +="		union  \n ";
        query +="select '6' sort, '0022' as C_ST , '00' as CODE, 'D00' NM_CD, '=== 대전기준 ===' as NM , '' CMS_BK, '' APP_ST from dual   \n ";
        query +="		union  \n ";
        query +="select '7' sort, '0022' as C_ST , '00' as CODE, 'B00' NM_CD, '=== 부산기준 ===' as NM , '' CMS_BK, '' APP_ST from dual  \n "; 
        query +="		union  \n ";
        query +="select '8' sort, '0022' as C_ST , '00' as CODE, 'W00' NM_CD, '=== 부산기준 ===' as NM , '' CMS_BK, '' APP_ST from dual   \n ";
           			       
        query += " ORDER BY 1, 4 ";
             	 
                
     // 	System.out.println("[CommonDataBase:getCodeAll_0022]"+query);

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
			System.out.println("[CommonDataBase:getCodeAllV_0022]"+e);
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

    
 public Vector getCodeAllV_0022_NNew( String c_st ) throws DatabaseException, DataSourceEmptyException{
     Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
         throw new DataSourceEmptyException("Can't get Connection !!");
     
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     Vector vt = new Vector();
     
     String query = "";
     
     query = " SELECT decode(substr(NM_CD,1,1),'S','1','T', '2', 'C', '3', 'E', '4', 'F', '5', 'D','6','B','7' ,'W', '8')  sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST \n " +
     		 "   FROM CODE where C_ST='" + c_st + "' and  code <> '0000' and code < '0038'  \n " ;     
     query +="   	 union  \n ";
     query +="select '1' sort, '0022' as C_ST , '00' as CODE, 'S00' NM_CD, '=== 서울기준  ===' as NM , '' CMS_BK, '' APP_ST  from dual   \n ";     
     query +="		union  \n ";
     query +="select '6' sort, '0022' as C_ST , '00' as CODE, 'D00' NM_CD, '=== 대전기준 ===' as NM , '' CMS_BK, '' APP_ST from dual   \n ";
     query +="		union  \n ";
     query +="select '7' sort, '0022' as C_ST , '00' as CODE, 'B00' NM_CD, '=== 부산기준 ===' as NM , '' CMS_BK, '' APP_ST from dual  \n ";     
        			       
     query += " ORDER BY 1, 4 ";
          	 
             
  // 	System.out.println("[CommonDataBase:getCodeAll_0022]"+query);

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
			System.out.println("[CommonDataBase:getCodeAllV_0022_NNew]"+e);
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


 
	/*
     * Code 전체 조회 ( 2001/12/28 ) - Kim JungTae
     */
    public Vector getCodeAllV_0022_t( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
          
        String query = "";
        
        query = " SELECT decode(substr(NM_CD,1,1),'S','1','D','2','B','3', '4')   sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, ETC \n " +
        		"	FROM CODE where C_ST='0022' and CODE <> '0000' and nm_cd  like 'T%'  \n " + 
        		"   and code in ( '0135', '0080', '0041', '0042', '0043', '0044', '0045', '0046', '0047', '0048' ) \n ";
        
   //     query = " SELECT decode(substr(NM_CD,1,1),'S','1','D','2','B','3','4')  sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, ETC FROM CODE where C_ST='" + c_st + "' and CODE <> '0000' and nm_cd  like 'T%' and code < '0136' ";

    	query +=" union \n";
	
//		query +=" select '1' sort, '0022' as C_ST , '' as CODE, 'S00' NM_CD, '=서울 기준 =' as NM , '' CMS_BK, '' APP_ST, '' ETC  from dual ";
		query +=" select '1' sort, '0022' as C_ST , '' as CODE, 'S00' NM_CD, '=서울(영남,신엠제이)기준 =' as NM , '' CMS_BK, '' APP_ST, '' ETC  from dual  \n";
		
		query +=" union  \n";
		query +=" select '5' sort, '0022' as C_ST , '' as CODE, 'S00' NM_CD, '=서울(영남,신엠제이 제외)기준=' as NM , '' CMS_BK, '' APP_ST, '' ETC  from dual  \n";
		
		query +=" union  \n";
		query +=" SELECT decode(substr(NM_CD,1,1),'S','1','D','2','B','3', '6')  sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, ETC  FROM CODE where C_ST='0022' and CODE <> '0000' and nm_cd  like 'T%' and  code > '0135'  \n";
		
		query +=" union  \n ";
		query +="   SELECT decode(substr(NM_CD,1,1),'S','1','D','2','B','3', '7')   sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, ETC   FROM CODE where C_ST='0022' and CODE <> '0000' and nm_cd  like 'T%'  \n " +
                " and code between  '0049' and '0134'   and code not in ( '0135', '0080')  \n";
        
      	query += " ORDER BY 1, 8, 4  \n ";
      	
    //    System.out.println("[CommonDataBase:getCodeAll_0022_t]"+query);

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
			System.out.println("[CommonDataBase:getCodeAllV_0022_t]"+e);
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

    /*
     * 아마존탁송 - 202207 탁송료 반영
     */
    public Vector getCodeAllV_0022_New( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
          
        String query = "";
                
        query = "  SELECT decode(substr(NM_CD,1,1),'C','1','E','2','F','3', '4')   sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, ETC \n " +
		     	"  FROM CODE where C_ST='0022' and CODE <> '0000' and nm_cd  like 'C%' \n " +
		        "  union  \n " +
		        "  SELECT decode(substr(NM_CD,1,1),'C','1','E','2','F','3', '4')   sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, ETC \n " +
		     	"  FROM CODE where C_ST='0022' and CODE <> '0000' and  nm_cd  like 'E%' \n " +
		     	"  union  \n " +
			    " SELECT decode(substr(NM_CD,1,1),'C','1','E','2','F','3', '4')   sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, ETC \n " +
			    " FROM CODE where C_ST='0022' and CODE <> '0000' and nm_cd  like 'G%' \n " +
		        "  union  \n " +
		        " SELECT decode(substr(NM_CD,1,1),'C','1','E','2','F','3', '4')   sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, ETC \n " +
		     	" FROM CODE where C_ST='0022' and CODE <> '0000' and nm_cd  like 'F%' \n " +
		        " union \n " +
		        " select '1' sort, '0022' as C_ST , '' as CODE, 'C00' NM_CD, '====서울(영남및 그외정비소 출발/도착)기준 ====' as NM , '' CMS_BK, '' APP_ST, '' ETC  from dual  \n " +
		        " union  \n " +
		        " select '2' sort, '0022' as C_ST , '' as CODE, 'E00' NM_CD, '====서울(정비소(오토크린,아마존모터스,강서모터스)출발/도착)기준====' as NM , '' CMS_BK, '' APP_ST, '' ETC  from dual  \n " +
		        " union  \n " +
		        " select '3' sort, '0022' as C_ST , '' as CODE, 'F00' NM_CD, '====서울기준(공통)====' as NM , '' CMS_BK, '' APP_ST, '' ETC  from dual \n " + 		
		        " ORDER BY 1, 8, 4  ";
           	
    //    System.out.println("[CommonDataBase:getCodeAll_0022_New]"+query);

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
			System.out.println("[CommonDataBase:getCodeAllV_0022_New]"+e);
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
    
 public Vector getCodeAllV_0022_w( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
          
        String query = "";
        
        query = " SELECT decode(substr(NM_CD,1,1),'S','1','D','2','B','3')  sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST FROM CODE where C_ST='" + c_st + "' and CODE <> '0000' and nm_cd  like 'W%' ";

    	query +=" union ";
		query +=" select '1' sort, '0022' as C_ST , '' as CODE, 'B00' NM_CD, '=부산기준=' as NM , '' CMS_BK, '' APP_ST  from dual ";
				       
      	query += " ORDER BY 1, 4 ";

//System.out.println("[CommonDataBase:getCodeAll_0022]"+query);

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
			System.out.println("[CommonDataBase:getCodeAllV_0022_w]"+e);
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

    
 public Vector getCodeAllV_0022_d( String c_st ) throws DatabaseException, DataSourceEmptyException{
     Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
         throw new DataSourceEmptyException("Can't get Connection !!");
     
     PreparedStatement pstmt = null;
     ResultSet rs = null;
     Vector vt = new Vector();
       
     String query = "";
     
     query = " SELECT decode(substr(NM_CD,1,1),'S','1','D','2','B','3')  sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST FROM CODE where C_ST='" + c_st + "' and CODE <> '0000' and nm_cd  like 'D%' ";

 	query +=" union ";
		query +=" select '1' sort, '0022' as C_ST , '' as CODE, 'D00' NM_CD, '== 대전기준 ==' as NM , '' CMS_BK, '' APP_ST  from dual ";
				       
   	query += " ORDER BY 1, 4 ";

//System.out.println("[CommonDataBase:getCodeAll_0022]"+query);

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
			System.out.println("[CommonDataBase:getCodeAllV_0022_d]"+e);
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

    /**
	 *	전국탁송 구간별요금
	 */
	public int getCmp_app_amt(String cmp_app) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rtn = 0;

		String query = "select to_number(app_st)   from code where c_st = '0022' and nm_cd  = '" + cmp_app + "' ";
				
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				 rtn = rs.getInt(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}
 
 	/**
	 *	영업소 리스트 조회(공급자)
	 */
	public Vector getUserBranchs(String st) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " SELECT * FROM BRANCH ";
				
		if(st.equals("rent")) query += " WHERE br_id NOT IN ('K1','K2','N1','U1')";
		
		query += " ORDER BY DECODE(br_id,'S1',0,1), br_nm ";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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

 	/**
	 *	부서 리스트 조회
	 */
	public Vector getUserDepts(String st) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = " SELECT * FROM code where c_st='0002' ";
				
		if(st.equals("cmp")) query += " AND CODE NOT IN ('0000','0003','0004','0005','0006','0016','0019','0020','8888','9999')";
		
		query += " ORDER BY DECODE(code,'0001',1,'0002',2,'1000',4,'9999',5,3), code ";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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

	/**
	 *	사용자 조회
	 */
	public Vector getUserSearchList(String mode, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	  	
		String query =	" SELECT a.user_nm, a.user_id, b.br_id, b.br_nm, a.dept_id, c.nm AS dept_nm \n"+
						" FROM   USERS a, BRANCH b, (SELECT * FROM CODE WHERE c_st='0002' AND CODE<>'0000') c \n"+
						" WHERE  a.user_nm LIKE '%"+t_wd+"%' AND a.BR_ID=b.br_id AND a.dept_id=C.CODE \n";


		if(mode.equals("EMP"))		query+= " and a.dept_id<>'8888' ";
		if(mode.equals("EMP_Y"))	query+= " and a.dept_id<>'8888' and a.use_yn='Y' ";
		if(mode.equals("EMP_N"))	query+= " and a.dept_id<>'8888' and a.use_yn='N' ";
		if(mode.equals("OFF"))		query+= " and a.dept_id= '8888' ";

		query += " ORDER BY DECODE(a.dept_id,'9999',3,'8888',2,1), a.user_nm";


		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getUserSearchList]"+e);
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

//사용자 명으로 사용자 ID 조회- 20140521 류길선
public Hashtable getDamdang_id(String user_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT user_id  FROM users WHERE user_nm = ? ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);				
				pstmt.setString(1,user_nm);
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
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/

	/**
	 *	사용자 리스트 조회
	 * 
	 */
	public Vector getUserSearchList(String br_id, String dept_id, String t_wd, String use_yn) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, b.br_nm, c.nm as dept_nm from users a, branch b, code c where a.br_id=b.br_id(+) and c.c_st='0002'   and a.dept_id=c.code "+
				" and a.dept_id not in ('8888','1000') "+
				" ";

		if(!br_id.equals(""))		query += " and nvl(b.br_id,'"+br_id+"') = '"+br_id+"'";

		if(!dept_id.equals(""))		query += " and a.dept_id='"+dept_id+"'";

		if(!t_wd.equals("")) {
				if (t_wd.equals("TT")) {
							query += " and a.user_nm in ('정채달', '안보국', '허승범', '조성희') ";
				} else if ( t_wd.equals("AA")) {
							query += " and a.user_id not in ( '000102') ";
				} else 
				{
					        query += " and a.user_nm like '%"+t_wd+"%'";
				}			
		}
		
		if(!use_yn.equals(""))		query += " and a.use_yn='"+use_yn+"'";

		query += " order by decode(a.user_id, '000053', '6', DECODE(a.USER_POS, '대표이사', '1', '부장', '3', '팀장', '4', '이사', 5, '차장', '6', '과장', '7', '대리', '8', '사원', '9', '10' )) , a.user_id ";

		
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
			System.out.println("[CommonDataBase:getUserSearchList]"+e);
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

/**
	 *	cur_date(날짜) + day(일) 을 리턴
	 */
	public String addDayBr(String cur_date, int day) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "select to_char(to_date(replace('"+ cur_date +"','-',''), 'YYYY-MM-DD')+"+ day +", 'YYYY-MM-DD') "+
						" from dual";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			if(AddUtil.checkDate(cur_date)){	
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
				while(rs.next())
				{				
					 rtn = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
		        pstmt.close();
			}
		} catch (SQLException e) {
	  		e.printStackTrace();
			System.out.println("[CommonDataBase:addDayBr]"+e);
			System.out.println("[CommonDataBase:addDayBr]"+query);
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}	

	/**
	 *	ACAR_ATTACH_FILE 리스트 조회
	 * 
	 */
	public Vector getAcarAttachFileList(String contentCode, String contentSeq, int attachedSeq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT seq, content_code, content_seq, file_name, file_size, file_type, save_file, save_folder, reg_userseq, reg_date, isdeleted, to_char(reg_date,'YYYYMMDD') reg_dt  "+
				" FROM   ACAR_ATTACH_FILE WHERE ISDELETED = 'N' "+
				" ";

		if(!contentCode.equals(""))		query += " and content_code = '"+contentCode+"'";

		if(!contentSeq.equals("")){
			if(contentCode.equals("BBS")){

				query += " and SUBSTR(content_seq, 0, TO_NUMBER(LENGTH(content_seq))-1) = '"+contentSeq+"' ";
			}else if(contentCode.equals("CAR_COL")){
				query += " and content_seq = '"+contentSeq+"'";
			}else if(contentCode.equals("APPRSL")){
				query += " and content_seq like '"+contentSeq+"%'";
				query += " AND TO_CHAR(REG_DATE,'YYYYMMDD') >= TO_CHAR(add_months(sysdate, -6),'YYYYMMDD') ";
			}else{
				query += " and content_seq like '"+contentSeq+"%'";
			}
		}

		if(attachedSeq > 0)				query += " and seq = "+attachedSeq+" ";
		
		if(contentCode.equals("CAR_COL_CAT")){
			query += " order by reg_date desc, seq desc";	
		}else {
			query += " order by reg_date , seq ";
		}

		
		
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
			System.out.println("[CommonDataBase:getAcarAttachFileList]"+e);
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

	/**
	 *	ACAR_ATTACH_FILE 리스트 조회
	 * 
	 */
	public Vector getAcarAttachFileListEqual(String contentCode, String contentSeq, int attachedSeq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT seq, content_code, content_seq, file_name, file_size, file_type, save_file, save_folder, reg_userseq, reg_date, isdeleted, to_char(reg_date,'YYYYMMDD') reg_dt "+
				" FROM   ACAR_ATTACH_FILE WHERE ISDELETED = 'N' "+
				" ";

		if(!contentCode.equals(""))		query += " and content_code = '"+contentCode+"'";

		if(!contentSeq.equals(""))		query += " and content_seq = '"+contentSeq+"'";

		if(attachedSeq > 0)				query += " and seq = "+attachedSeq+" ";

		query += " order by reg_date desc, seq ";


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
			System.out.println("[CommonDataBase:getAcarAttachFileListEqual]"+e);
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

	/**
	 *	ACAR_ATTACH_FILE 리스트 조회
	 * 
	 */
	public Vector getAcarAttachFileListLcScanEqual(String contentCode, String rent_mng_id, String rent_l_cd, String file_st, int attachedSeq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT seq, content_code, content_seq, file_name, file_size, file_type, save_file, save_folder, reg_userseq, reg_date, isdeleted, to_char(reg_date,'YYYYMMDD') reg_dt "+
				" FROM   ACAR_ATTACH_FILE WHERE ISDELETED = 'N' "+
				" ";

		if(!contentCode.equals(""))		query += " and content_code = '"+contentCode+"'";

		if(!rent_l_cd.equals(""))		query += " and substr(content_seq,1,19) = '"+rent_mng_id+""+rent_l_cd+"' and substr(content_seq,21) = '"+file_st+"' ";

		if(attachedSeq > 0)				query += " and seq = "+attachedSeq+" ";

		query += " order by reg_date desc, seq desc ";

		

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
			System.out.println("[CommonDataBase:getAcarAttachFileListLcScanEqual]"+e);
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


	/**
	 *	ACAR_ATTACH_FILE 한건 조회
	 * 
	 */
	public Hashtable getAcarAttachFile(String contentCode, String contentSeq, int attachedSeq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT seq, content_code, content_seq, file_name, file_size, file_type, save_file, save_folder, reg_userseq, reg_date, isdeleted, to_char(reg_date,'YYYYMMDD') reg_dt  "+
				" FROM   ACAR_ATTACH_FILE WHERE ISDELETED = 'N' "+
				" ";

		if(!contentCode.equals(""))		query += " and content_code = '"+contentCode+"'";

		if(!contentSeq.equals(""))		query += " and content_seq like '"+contentSeq+"%'";

		if(attachedSeq > 0)				query += " and seq = "+attachedSeq+" ";

		query += " order by reg_date, seq ";
		
		try {
			pstmt = con.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
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
			System.out.println("[CommonDataBase:getAcarAttachFile]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/**
	 *	ACAR_ATTACH_FILE 건 수 조회
	 */
	public int getAcarAttachFileCount(String contentCode, String contentSeq, int file_st) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
			throw new DataSourceEmptyException("Can't get Connection !!");
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int count = 0;
		
		query = " SELECT count(*)  "+
				" FROM   ACAR_ATTACH_FILE WHERE ISDELETED = 'N' "+
				" ";
		
		if(!contentCode.equals(""))		query += " and content_code = '"+contentCode+"'";
		
		if(!contentSeq.equals(""))		query += " and content_seq like '"+contentSeq+"%'";
		
		query += " and content_seq like '%"+file_st+"' ";
		
		try {
			pstmt = con.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			
			if(rs.next()){								
				count = rs.getInt(1);		
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CommonDataBase:getAcarAttachFile]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null ) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return count;
	}
	//메일링을 위한 seq로 하나조회하기
	public Vector getAcarAttachFileList(int attachedSeq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT seq, content_code, content_seq, file_name, file_size, file_type, save_file, save_folder, reg_userseq, reg_date, isdeleted, to_char(reg_date,'YYYYMMDD') reg_dt  "+
				" FROM   ACAR_ATTACH_FILE WHERE ISDELETED = 'N' and seq = "+attachedSeq+" ";

		query += " order by reg_date, seq ";

//System.out.println("[CommonDataBase:getAcarAttachFileList]"+query);		

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
			System.out.println("[CommonDataBase:getAcarAttachFileList]"+e);
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


	/**
	 *	ACAR_ATTACH_FILE 한건 조회
	 * 
	 */
	public Hashtable getAcarAttachFileEqual(String contentCode, String contentSeq, int attachedSeq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT seq, content_code, content_seq, file_name, file_size, file_type, save_file, save_folder, reg_userseq, reg_date, isdeleted, to_char(reg_date,'YYYYMMDD') reg_dt  "+
				" FROM   ACAR_ATTACH_FILE WHERE ISDELETED = 'N' "+
				" ";

		if(!contentCode.equals(""))		query += " and content_code = '"+contentCode+"'";

		if(!contentSeq.equals(""))		query += " and content_seq = '"+contentSeq+"'";

		if(attachedSeq > 0)				query += " and seq = "+attachedSeq+" ";

		query += " order by reg_date, seq ";
		
//			System.out.println("[CommonDataBase:getAcarAttachFileEqual]"+query);

		try {
			pstmt = con.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
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
			System.out.println("[CommonDataBase:getAcarAttachFileEqual]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/**
	 *	ACAR_ATTACH_FILE 현황 조회
	 * 
	 */
	public Hashtable getAcarAttachFileStat(String contentCode, String contentSeq, int attachedSeq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT count(0) file_count, max(file_type) file_type "+
				" FROM   ACAR_ATTACH_FILE WHERE ISDELETED = 'N' "+
				" ";

		if(!contentCode.equals(""))		query += " and content_code = '"+contentCode+"'";

		if(!contentSeq.equals(""))		query += " and content_seq like '"+contentSeq+"%'";

		if(attachedSeq > 0)				query += " and seq = "+attachedSeq+" ";

		
		try {
			pstmt = con.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
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
			System.out.println("[CommonDataBase:getAcarAttachFileStat]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

	/**
	 *	ACAR_ATTACH_FILE 리스트 조회
	 * 
	 */
	public Vector getAcarAttachFileLcScanClientMaxSeqList(String client_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
/*
		query = " SELECT SUBSTR(a.content_seq,21) file_st, MAX(seq) seq "+
				" FROM   ACAR_ATTACH_FILE a, CONT b "+
				" WHERE  a.content_code='LC_SCAN' AND a.ISDELETED = 'N' "+
				"        AND SUBSTR(a.content_seq,1,19)=b.rent_mng_id||b.rent_l_cd  "+
				"        and SUBSTR(a.content_seq,21) in ('2','3','4','6','7','8') "+
				"        AND b.client_id='"+client_id+"' and b.client_id not in ('000228') "+
				" GROUP BY SUBSTR(a.content_seq,21) "+
				" ";
*/
		//최근등록한 스캔파일 seq
		query = " SELECT file_st, seq FROM ( "+   
				" SELECT SUBSTR(a.content_seq,21) file_st, a.reg_date, a.seq, row_number() OVER (PARTITION BY SUBSTR(a.content_seq,21) ORDER BY a.reg_date DESC, a.seq DESC) RN1 "+
				"		 FROM   ACAR_ATTACH_FILE a, CONT b  "+
				"		 WHERE  a.content_code='LC_SCAN' AND a.ISDELETED = 'N' "+ 
				"		        AND SUBSTR(a.content_seq,1,19)=b.rent_mng_id||b.rent_l_cd "+  
				"		        and SUBSTR(a.content_seq,21) in ('2','3','4','6','7','8') "+
				"		        AND b.client_id='"+client_id+"' and b.client_id not in ('000228') "+
		        "  ) "+
		        " WHERE RN1=1 "+
		        " ";

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
			System.out.println("[CommonDataBase:getAcarAttachFileLcScanClientMaxSeqList]"+e);
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

	/**
	 *	ACAR_ATTACH_FILE 리스트 조회
	 * 
	 */
	public Vector getAcarAttachFileLcScanClientList(String client_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.rent_l_cd, c.rent_dt, a.seq, a.content_code, a.content_seq, a.file_name, a.file_size, a.file_type, a.save_file, a.save_folder, a.reg_userseq, a.reg_date, a.isdeleted, to_char(a.reg_date,'YYYYMMDD') reg_dt  "+
				" FROM   ACAR_ATTACH_FILE a, CONT b, FEE c  "+
				" WHERE  a.content_code='LC_SCAN' "+ //AND a.ISDELETED = 'N' 
				"        AND SUBSTR(a.content_seq,1,19)=b.rent_mng_id||b.rent_l_cd  "+
				"        AND b.client_id='"+client_id+"' "+
				"        AND SUBSTR(a.content_seq,1,20)=c.rent_mng_id||c.rent_l_cd||c.rent_st "+
				" ORDER BY SUBSTR(a.content_seq,21), a.reg_date, a.seq "+
				" ";


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
			System.out.println("[CommonDataBase:getAcarAttachFileLcScanClientList]"+e);
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


/*과태료 스캔파일 관련 RANK() OVER(ORDER BY REG_DATE DESC) RK 추가 */
public Vector getAcarAttachFileList_fine(String contentCode, String contentSeq, int attachedSeq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT substr(content_seq, 0, 6) AS rent_mng_id, substr(content_seq, 7,13) AS rent_l_cd, substr(content_seq, 21) AS file_st, file_type, \n"+
				" MAX(SEQ)       KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) SEQ ,  \n"+
				" MAX(substr(content_seq, 20,1))       KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) RENT_ST ,  \n"+
				" MAX(save_file) KEEP(DENSE_RANK LAST ORDER BY save_file) save_file ,  \n"+
				" MAX(save_folder) KEEP(DENSE_RANK LAST ORDER BY save_folder) save_folder ,  \n"+
				" MAX(reg_userseq)    KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) REG_ID ,  \n"+
				" MAX(reg_date)    KEEP(DENSE_RANK LAST ORDER BY FILE_NAME) REG_DT   \n"+
				" FROM ACAR_ATTACH_FILE \n"+
				" WHERE ISDELETED = 'N' AND file_type <> 'application/pdf'  AND substr(content_seq, 21) IN ('17','18','2','4') \n"+
				" ";

		if(!contentCode.equals(""))		query += " and content_code = '"+contentCode+"' ";

		if(!contentSeq.equals(""))		query += " and content_seq like '"+contentSeq+"%' ";

		if(attachedSeq > 0)				query += " and seq = "+attachedSeq+" ";

		query += " GROUP BY  substr(content_seq, 0, 6), substr(content_seq, 7,13)  , substr(content_seq, 21)  ,   file_type \n";
		query += " order by REG_DT, seq ";

//System.out.println("[CommonDataBase:getAcarAttachFileList_fine]"+query);		

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
			System.out.println("[CommonDataBase:getAcarAttachFileList_fine]"+e);
			System.out.println("[CommonDataBase:getAcarAttachFileList_fine]"+query);
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

public Vector getAcarAttachFileLcScanClientList_fine(String client_id, String contentSeq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

                //계약서 앞장
		query = " SELECT RANK() OVER(ORDER BY a.REG_DATE DESC) rk, RANK() OVER(ORDER BY a.seq desc) rk_seq, b.rent_l_cd, c.rent_dt, a.seq, a.content_code, a.content_seq, a.file_name, a.file_size, a.file_type, a.save_file, a.save_folder, a.reg_userseq, a.reg_date, a.isdeleted, to_char(a.reg_date,'YYYYMMDD') reg_dt  "+
				" FROM   ACAR_ATTACH_FILE a, CONT b, FEE c  "+
				" WHERE  a.content_code='LC_SCAN' AND a.ISDELETED = 'N' "+
				"        AND SUBSTR(a.content_seq,1,19)=b.rent_mng_id||b.rent_l_cd  "+
				"        AND SUBSTR(a.content_seq,1,20)=c.rent_mng_id||c.rent_l_cd||c.rent_st "+
//				"	 	 AND SUBSTR(a.content_seq,1,19)= '"+contentSeq+"' AND a.FILE_TYPE LIKE '%image%' AND SUBSTR(a.content_seq,21) IN ('17')  "+
				"		 AND SUBSTR(a.content_seq,1,20) like '"+contentSeq+"' AND a.FILE_TYPE LIKE '%image%' AND SUBSTR(a.content_seq,21) IN ('17')  "+
				" UNION ALL "+
		        //계약서 뒷장
				" SELECT RANK() OVER(ORDER BY a.REG_DATE DESC) rk, RANK() OVER(ORDER BY a.seq desc) rk_seq, b.rent_l_cd, c.rent_dt, a.seq, a.content_code, a.content_seq, a.file_name, a.file_size, a.file_type, a.save_file, a.save_folder, a.reg_userseq, a.reg_date, a.isdeleted, to_char(a.reg_date,'YYYYMMDD') reg_dt  "+
				" FROM   ACAR_ATTACH_FILE a, CONT b, FEE c  "+
				" WHERE  a.content_code='LC_SCAN' AND a.ISDELETED = 'N' "+
				"        AND SUBSTR(a.content_seq,1,19)=b.rent_mng_id||b.rent_l_cd  "+
				"        AND SUBSTR(a.content_seq,1,20)=c.rent_mng_id||c.rent_l_cd||c.rent_st "+
//				"		 AND SUBSTR(a.content_seq,1,19)= '"+contentSeq+"' AND a.FILE_TYPE LIKE '%image%' AND SUBSTR(a.content_seq,21) IN ('18')  "+
				"		 AND SUBSTR(a.content_seq,1,20) like '"+contentSeq+"' AND a.FILE_TYPE LIKE '%image%' AND SUBSTR(a.content_seq,21) IN ('18')  "+
				" UNION ALL "+
                //사업자등록증
				" SELECT RANK() OVER(ORDER BY a.REG_DATE DESC) rk, RANK() OVER(ORDER BY a.seq desc) rk_seq, b.rent_l_cd, c.rent_dt, a.seq, a.content_code, a.content_seq, a.file_name, a.file_size, a.file_type, a.save_file, a.save_folder, a.reg_userseq, a.reg_date, a.isdeleted, to_char(a.reg_date,'YYYYMMDD') reg_dt  "+
				" FROM   ACAR_ATTACH_FILE a, CONT b, FEE c ,client d "+
				" WHERE  a.content_code='LC_SCAN' AND a.ISDELETED = 'N' "+
				"        AND SUBSTR(a.content_seq,1,19)=b.rent_mng_id||b.rent_l_cd  "+
				"        AND b.client_id='"+client_id+"' "+
				"        AND SUBSTR(a.content_seq,1,20)=c.rent_mng_id||c.rent_l_cd||c.rent_st "+
				"	     AND a.FILE_TYPE LIKE '%image%' AND SUBSTR(a.content_seq,21) ='2'  AND b.CLIENT_ID = d.client_id AND d.client_st NOT in ('2') "+
				" UNION ALL "+
				//차량이용자확인요청서
				" SELECT RANK() OVER(ORDER BY a.REG_DATE DESC) rk, RANK() OVER(ORDER BY a.seq desc) rk_seq, b.rent_l_cd, c.rent_dt, a.seq, a.content_code, a.content_seq, a.file_name, a.file_size, a.file_type, a.save_file, a.save_folder, a.reg_userseq, a.reg_date, a.isdeleted, to_char(a.reg_date,'YYYYMMDD') reg_dt	"+
				" FROM   ACAR_ATTACH_FILE a, CONT b, FEE c	"+
				" WHERE  a.content_code='LC_SCAN' AND a.ISDELETED = 'N'	"+
				"		 AND SUBSTR(a.content_seq,1,19)=b.rent_mng_id||b.rent_l_cd	"+
				"		 AND SUBSTR(a.content_seq,1,20)=c.rent_mng_id||c.rent_l_cd||c.rent_st	"+
				"		 AND SUBSTR(a.content_seq,1,20) like '"+contentSeq+"' AND a.FILE_TYPE LIKE '%image%' AND SUBSTR(a.content_seq,21) IN ('27')	"+
				
//				" UNION ALL "+
                //신분증
//				" SELECT RANK() OVER(ORDER BY a.REG_DATE DESC) rk, RANK() OVER(ORDER BY a.seq desc) rk_seq, b.rent_l_cd, c.rent_dt, a.seq, a.content_code, a.content_seq, a.file_name, a.file_size, a.file_type, a.save_file, a.save_folder, a.reg_userseq, a.reg_date, a.isdeleted, to_char(a.reg_date,'YYYYMMDD') reg_dt  "+
//				" FROM   ACAR_ATTACH_FILE a, CONT b, FEE c ,client d "+
//				" WHERE  a.content_code='LC_SCAN' AND a.ISDELETED = 'N' "+
//				"        AND SUBSTR(a.content_seq,1,19)=b.rent_mng_id||b.rent_l_cd  "+
//				"        AND b.client_id='"+client_id+"' "+
//				"        AND SUBSTR(a.content_seq,1,20)=c.rent_mng_id||c.rent_l_cd||c.rent_st "+
//				"	 AND a.FILE_TYPE LIKE '%image%' AND SUBSTR(a.content_seq,21) = '4' AND b.CLIENT_ID = d.client_id AND d.client_st not in ('1')  "+
				" ";



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
			System.out.println("[CommonDataBase:getAcarAttachFileLcScanClientList_fine]"+query);
			System.out.println("[CommonDataBase:getAcarAttachFileLcScanClientList_fine]"+e);
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

/*
	public Vector getWatch_user_list(String mode) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query =  " SELECT * FROM ("+
						" SELECT '000124' AS watch_id FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '1' \n"+
						" UNION ALL  \n"+
						" SELECT '000217' FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '1'  \n"+
						" UNION ALL  \n"+
						" SELECT member_id5 FROM SCH_WATCH WHERE start_year||start_mon||start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '3'  \n"+
						" UNION ALL  \n"+
						" SELECT member_id6 FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '3'  \n"+
						" UNION ALL  \n"+
						" SELECT member_id5 FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '4'  \n"+
						" UNION ALL  \n"+
						" SELECT member_id6 FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '4' \n"+
						" ) where br_nm = '"+mode+"'";

         
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getWatch_user_list]"+e);
			System.out.println("[CommonDataBase:getWatch_user_list]"+e);
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
*/

//지점 선임자 + 당직자에게 경매차량 등록 문자 보낼때 당직자 불러오기
public Hashtable getWatch_user_list(String mode) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

       String query =  " SELECT a.watch_id, a.BR_NM, b.user_nm, b.user_m_tel AS m_tel FROM  ("+
						//" SELECT '000124' AS watch_id , '목동' AS BR_NM FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '1' \n"+
						" SELECT '000124' AS watch_id , '영남' AS BR_NM FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '1' \n"+
						" UNION ALL  \n"+
						//" SELECT '000217' , '목동' AS BR_NM FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '1'  \n"+
						" SELECT '000217' , '영남' AS BR_NM FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '1'  \n"+
						" UNION ALL  \n"+
						" SELECT member_id5,  '부산' AS BR_NM FROM SCH_WATCH WHERE start_year||start_mon||start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '3'  \n"+
						" UNION ALL  \n"+
						" SELECT member_id6,  '대구' AS BR_NM FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '3'  \n"+
						" UNION ALL  \n"+
						" SELECT member_id5,  '대전' AS BR_NM FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '4'  \n"+
						" UNION ALL  \n"+
						" SELECT member_id6,  '광주' AS BR_NM FROM SCH_WATCH WHERE start_year||start_mon|| start_day = replace(to_char(sysdate,'YYYYMMDD'), '-', '') AND watch_type = '4' \n"+
						" )  a, users b where a.watch_id = b.user_id and a.BR_NM = '"+mode+"'";

					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);				
				//pstmt.setString(1,rent_l_cd);
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
	  		e.printStackTrace();
				System.out.println("[CommonDataBase:getWatch_user_list]"+e);
			System.out.println("[CommonDataBase:getWatch_user_list]"+query);
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}



	/**
	 *	주간 당직자 + 고객상담요청 메세지 받기 신청자 사용자 리스트 조회
	 *  
	 */
	public Vector getSch_watchList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
				
			String query = "";

			query = " SELECT a.member_id3 AS user_id, b.user_nm, b.id, b.USER_M_TEL FROM SCH_WATCH a, USERS b WHERE a.member_id3 = b.user_id AND  a.START_YEAR||a.START_MON||a.START_DAY= to_char(sysdate,'YYYYMMdd') AND a.watch_type = '1' \n"+
					" UNION ALL \n"+
					" SELECT a.member_id4 AS user_id, b.user_nm, b.id, b.USER_M_TEL FROM SCH_WATCH a, USERS b WHERE a.member_id4 = b.user_id AND a.START_YEAR||a.START_MON||a.START_DAY= to_char(sysdate,'YYYYMMdd') AND a.watch_type = '1' \n"+
					" UNION ALL \n"+
					" SELECT a.member_id5 AS user_id, b.user_nm, b.id, b.USER_M_TEL FROM SCH_WATCH a, USERS b WHERE a.member_id5 = b.user_id AND a.START_YEAR||a.START_MON||a.START_DAY= to_char(sysdate,'YYYYMMdd') AND a.watch_type = '3' \n"+
					" UNION ALL \n"+
					" SELECT a.member_id6 AS user_id, b.user_nm, b.id, b.USER_M_TEL FROM SCH_WATCH a, USERS b WHERE a.member_id6 = b.user_id AND a.START_YEAR||a.START_MON||a.START_DAY= to_char(sysdate,'YYYYMMdd') AND a.watch_type = '3' \n"+
					" UNION ALL \n"+
					" SELECT a.member_id5 AS user_id, b.user_nm, b.id, b.USER_M_TEL FROM SCH_WATCH a, USERS b WHERE a.member_id5 = b.user_id AND a.START_YEAR||a.START_MON||a.START_DAY= to_char(sysdate,'YYYYMMdd') AND a.watch_type = '4' \n"+
					" UNION ALL \n"+
					" SELECT a.member_id6 AS user_id, b.user_nm, b.id, b.USER_M_TEL FROM SCH_WATCH a, USERS b WHERE a.member_id6 = b.user_id AND a.START_YEAR||a.START_MON||a.START_DAY= to_char(sysdate,'YYYYMMdd') AND a.watch_type = '4' \n"+
					" UNION ALL \n"+
					" SELECT a.member_id3 AS user_id, b.user_nm, b.id, b.USER_M_TEL FROM SCH_WATCH a, USERS b WHERE a.member_id3 = b.user_id AND a.START_YEAR||a.START_MON||a.START_DAY= to_char(sysdate,'YYYYMMdd') AND a.watch_type = '5' \n"+
					" UNION ALL \n"+
					" SELECT a.member_id4 AS user_id, b.user_nm, b.id, b.USER_M_TEL FROM SCH_WATCH a, USERS b WHERE a.member_id4 = b.user_id AND a.START_YEAR||a.START_MON||a.START_DAY= to_char(sysdate,'YYYYMMdd') AND a.watch_type = '5' \n"+
					" UNION ALL \n"+
					" SELECT a.member_id5 AS user_id, b.user_nm, b.id, b.USER_M_TEL FROM SCH_WATCH a, USERS b WHERE a.member_id5 = b.user_id AND a.START_YEAR||a.START_MON||a.START_DAY= to_char(sysdate,'YYYYMMdd') AND a.watch_type = '5' \n"+
					" UNION ALL  \n"+
					" SELECT user_id, user_nm, id, user_m_tel  FROM USERS WHERE m_io = 'Y' AND use_yn = 'Y' \n"+
					" ";


		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getSch_watchList]"+e);
			System.out.println("[CommonDataBase:getSch_watchList]"+query);
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


	 public Vector getJspExecuteList(String query) throws DatabaseException, DataSourceEmptyException
	{
    		 Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            		throw new DataSourceEmptyException("Can't get Connection !!");
				
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
	
                   
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
			System.out.println("[CommonDataBase:getJspExecuteList]"+e);
			System.out.println("[CommonDataBase:getJspExecuteList]"+query);
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


	    /**
     * 코드 수정
     */
    public int insupdCodeEtc(CodeEtcBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
         String query2 = "";
        int count = 0;
        int r_cnt = 0;
                  
       try{
            
              query = " select count(*) from code_etc   WHERE C_ST='"+bean.getC_st() + "' AND CODE='"+bean.getCode()+"'\n";
              
              query1="insert into code_etc( c_st, code, nm, zip, addr, gubun, ven_code)  values (?, ?, ?, ?, ? , ?, ? ) ";	
    			
              query2=" update  code_etc  set  nm=?, zip = ?,  addr = ?  , gubun = ?, ven_code = ? WHERE C_ST=? AND CODE= ?   ";
                        
              con.setAutoCommit(false);

	    pstmt = con.prepareStatement(query);
	    rs = pstmt.executeQuery();
                     
	    if(rs.next()){
			r_cnt = rs.getInt(1);
	    }
	    rs.close();
	    pstmt.close();

		if (  r_cnt > 0 ) { //update
	    	    pstmt1 = con.prepareStatement(query2);
         		pstmt1.setString(1, bean.getNm().trim());
				pstmt1.setString(2, bean.getZip().trim());
	            pstmt1.setString(3, bean.getAddr().trim());
	            pstmt1.setString(4, bean.getGubun().trim());
	            pstmt1.setString(5, bean.getVen_code().trim());
				pstmt1.setString(6, bean.getC_st());
				pstmt1.setString(7, bean.getCode());		         
                count = pstmt1.executeUpdate();
				pstmt1.close();
	    	
	    } else {   //insert
	    		pstmt1 = con.prepareStatement(query1);
         		pstmt1.setString(1, bean.getC_st());
				pstmt1.setString(2, bean.getCode());
	            pstmt1.setString(3, bean.getNm());
			    pstmt1.setString(4, bean.getZip().trim());
			    pstmt1.setString(5, bean.getAddr().trim());
			    pstmt1.setString(6, bean.getGubun().trim());	
			    pstmt1.setString(7, bean.getVen_code().trim());
                count = pstmt1.executeUpdate();
			    pstmt1.close();
	    	
	   } 		
                                  
            con.commit();

        }catch(Exception se){
            try{
		System.out.println("[CommonDataBase::insupdCodeEtc]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
                if(rs != null) rs.close();
                if(pstmt1 != null)	pstmt1.close();
         
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    public CodeEtcBean  getCodeEtc(String c_st, String c_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

               	 CodeEtcBean bean = new CodeEtcBean();
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
				
		 String query =  " SELECT  * from code_etc where c_st = '" + c_st + "' and code = '" + c_code + "'";
		try {
			    pstmt = con.prepareStatement(query);				
				//pstmt.setString(1,rent_l_cd);
		    	rs = pstmt.executeQuery();
		    	
		    	if(rs.next())
			{	
				    bean.setC_st(rs.getString("C_ST"));					//코드분류
				    bean.setCode(rs.getString("CODE"));					//코드(순차적증가)				
				    bean.setNm(rs.getString("NM"));						//명칭
				    bean.setZip(rs.getString("ZIP"));				// 
				    bean.setAddr(rs.getString("ADDR"));				//
				    bean.setGubun(rs.getString("GUBUN"));				//
				    bean.setVen_code(rs.getString("VEN_CODE"));				//
			}
			rs.close();
            		pstmt.close();
            
		} catch (SQLException e) {
	  		e.printStackTrace();
				System.out.println("[CommonDataBase:getCodeEtc]"+e);	
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return bean;
	}



//cms 관련 
public Hashtable getContViewCmsCase(String  client_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
	
	  String  query = " select a.client_id, c.firm_nm, u.user_nm, u.user_m_tel, c.con_agnt_email from (  "+
							  "  select a.client_id, min(a.bus_id2) bus_id2,  count(a.rent_l_cd) cnt  "+
							  "	    from cont a , cms.member_user b  "+
							  "	    where a.rent_l_cd = b.CMS_PRIMARY_SEQ and a.use_yn = 'Y' and b.cms_status = '3'   "+
							  "	    group by a.client_id "+
							  "	    having count(a.rent_l_cd) > 1 ) a, client c, users u "+
							  "	  where a.client_id = c.client_id and a.bus_id2 = u.user_id and a.client_id = '" + client_id + "'" ;  		  
      
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		try {
			    pstmt = con.prepareStatement(query);				
				//pstmt.setString(1,rent_l_cd);
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
	  		e.printStackTrace();
				System.out.println("[CommonDataBase:getContViewCmsCase]"+e);
			System.out.println("[CommonDataBase:getContViewCmsCase]"+query);
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}


	/**
	 *	사용자 조회
	 */
	public Vector getAgentUserSearchList(String agent_user_id, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	  	
		String query =  " SELECT '1' st, a.emp_nm AS user_nm, a.emp_id AS user_id, '' br_id, '에이전트' br_nm, c.car_off_id AS dept_id, c.car_off_nm AS dept_nm "+
					    " FROM   car_off_emp a, "+
					    "	     (SELECT a.sa_code FROM users a WHERE a.user_id='"+agent_user_id+"') b, "+
					    "	     car_off c "+
					    " WHERE  a.emp_id=b.sa_code AND a.car_off_id=c.car_off_id "+
         			    " union all "+
           			    " SELECT '2' st, a.emp_nm AS user_nm, a.emp_id AS user_id, '' br_id, '에이전트' br_nm, c.car_off_id AS dept_id, c.car_off_nm AS dept_nm "+
						" FROM   car_off_emp a, "+
						"        (SELECT a.sa_code, c.car_off_id FROM users a, car_off_emp b, car_off c WHERE a.user_id='"+agent_user_id+"' AND a.sa_code=b.emp_id AND b.agent_id=c.car_off_id) b, "+
						"        car_off c "+
						" WHERE  nvl(a.use_yn,'Y')='Y' and a.car_off_id=b.car_off_id AND a.car_off_id=c.car_off_id AND a.emp_id<>b.sa_code ";

		if(!t_wd.equals(""))		query += " and a.emp_nm like '%"+t_wd+"%'"; 

		query += " order by 1, 2 ";


		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
			System.out.println("[CommonDataBase:getAgentUserSearchList]"+e);
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

	/**
     * 홈페이지 요일 구분
     */
	public String getWeek_st(String cur_date) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT to_char( to_date(?), 'd')  FROM dual ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String week_st = "";
		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,cur_date);
			
		    	rs = pstmt.executeQuery();
   	
			while(rs.next()){
				week_st = rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return week_st;
		}
	}

	/**
     * 홈페이지 요일 구분
     */
	public int getHoliday_st(String cur_date) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT  count(*)  FROM holiday where hday = replace(?, '-', '') ";
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int hol_cnt = 0;
		try {
			    pstmt = con.prepareStatement(query);
				pstmt.setString(1,cur_date);
			
		    	rs = pstmt.executeQuery();
   	
			while(rs.next()){
				hol_cnt = rs.getInt(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return hol_cnt;
		}
	}
	
	// user_id로 성명, 핸드폰 번호 반환 2018. 01. 29
	public String getNameByUserId(String user_id, String gubun) throws DatabaseException, DataSourceEmptyException {
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "";
		String query_name = "select user_nm from users where use_yn = 'Y' and user_id='"+user_id+"'";
		String query_phone = "select user_m_tel from users where use_yn = 'Y' and user_id='"+user_id+"'";
		if(gubun.equals("name")){
			query = query_name;
		}else {
			query = query_phone;
		}
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			    pstmt = con.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}

	/**
     * 요일변환
     */
	public String getFGetDt(String f_st, String f_date, String day_num) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT F_getCmsIncomDt(replace('"+f_date+"','-',''))  FROM dual ";

		if(f_st.equals("F_getInsurPayDt")){

			query = "SELECT F_getInsurPayDt(replace('"+f_date+"','-',''))  FROM dual ";

		}else if(f_st.equals("F_getValdDt")){

			query = "SELECT F_getValdDt(replace('"+f_date+"','-',''), "+day_num+")  FROM dual ";

		}else if(f_st.equals("F_getAfterDay")){

			query = "SELECT F_getAfterDay(replace('"+f_date+"','-',''), "+day_num+")  FROM dual ";
		}
					  
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String week_st = "";
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();   	
			if(rs.next()){
				week_st = rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return week_st;
		}
	}
	
	//CommonEtc 테이블 한건 조회 (20180628)
	public CommonEtcBean getCommonEtc(String table_nm, String col_1_nm, String col_1_val, String col_2_nm, String col_2_val, String col_3_nm, String col_3_val, String col_4_nm, String col_4_val) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		CommonEtcBean ceb = new CommonEtcBean();
		
		Statement stmt = null;
		ResultSet rs = null;		
		String query = "";

		query = " SELECT table_nm, col_1_nm, col_1_val, col_2_nm, col_2_val, col_3_nm, col_3_val, col_4_nm, col_4_val, etc_nm, etc_content, reg_id, reg_dt  "+
				" FROM COMMON_ETC WHERE TABLE_NM = '"+table_nm+"'" +
				"  AND COL_1_NM = '"+col_1_nm+"' AND COL_1_VAL='"+col_1_val+"'" +
				" ";

		if(!col_2_nm.equals("")&&!col_2_val.equals(""))		query += "  AND COL_2_NM = '"+col_2_nm+"' AND COL_2_VAL='"+col_2_val+"'";
		if(!col_3_nm.equals("")&&!col_3_val.equals(""))		query += "  AND COL_3_NM = '"+col_3_nm+"' AND COL_3_VAL='"+col_3_val+"'";
		if(!col_4_nm.equals("")&&!col_4_val.equals(""))		query += "  AND COL_4_NM = '"+col_4_nm+"' AND COL_4_VAL='"+col_4_val+"'";

		try {
			stmt = con.createStatement();
		    rs = stmt.executeQuery(query);
    	
		    if (rs.next())
                ceb = makeCommonEtcBean(rs);
		    else
            	ceb = makeCommonEtcBean(null);
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

        return ceb;
	}
	
	//CommonEtc 테이블 등록 (20180628)
    public int insertCommonEtc(CommonEtcBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
	               
		try{
        			
		  query="INSERT INTO COMMON_ETC ( table_nm, col_1_nm, col_1_val, col_2_nm, col_2_val, col_3_nm, col_3_val,\n"
							   + " col_4_nm, col_4_val, etc_nm, etc_content, reg_id, reg_dt )\n"
          					   + " values(?,?,?,?,?,?,?,?,?,?,?,?, to_char(sysdate,'YYYYMMDD'))";

            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);

            pstmt.setString(1,  bean.getTable_nm().trim());
            pstmt.setString(2,  bean.getCol_1_nm().trim());
            pstmt.setString(3,  bean.getCol_1_val().trim());
            pstmt.setString(4,  bean.getCol_2_nm().trim());
            pstmt.setString(5,  bean.getCol_2_val().trim());
            pstmt.setString(6,  bean.getCol_3_nm().trim());
            pstmt.setString(7,  bean.getCol_3_val().trim());
            pstmt.setString(8,  bean.getCol_4_nm().trim());
            pstmt.setString(9,  bean.getCol_4_val().trim());
            pstmt.setString(10, bean.getEtc_nm().trim());
            pstmt.setString(11, bean.getEtc_content().trim());
            pstmt.setString(12, bean.getReg_id().trim());
         
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
    
    //CommonEtc 테이블 수정 (20180628)
    public int updateCommonEtc(CommonEtcBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
                
       try{
            
	       query="UPDATE COMMON_ETC\n"
    			+ "SET ETC_CONTENT = '"+bean.getEtc_content().trim()+"',\n"
	       		+ "	   REG_ID = '"+bean.getReg_id().trim()+"',\n"
	       		+ "	   REG_DT = to_char(sysdate,'YYYYMMDD')\n"
    	       	+ "WHERE TABLE_NM = '"+bean.getTable_nm()+"'\n"
    	       	+ "  AND COL_1_NM = '"+bean.getCol_1_nm()+"'\n"
    	       	+ "  AND COL_1_VAL = '"+bean.getCol_1_val()+"'\n";
	       if(!bean.getCol_2_nm().equals("")&&!bean.getCol_2_val().equals("")){		query += "AND COL_2_NM = '"+bean.getCol_2_nm()+"' AND COL_2_VAL = '"+bean.getCol_2_val()+"'\n";		}
	       if(!bean.getCol_3_nm().equals("")&&!bean.getCol_3_val().equals("")){		query += "AND COL_3_NM = '"+bean.getCol_3_nm()+"' AND COL_3_VAL = '"+bean.getCol_3_val()+"'\n";		}
	       if(!bean.getCol_4_nm().equals("")&&!bean.getCol_4_val().equals("")){		query += "AND COL_4_NM = '"+bean.getCol_4_nm()+"' AND COL_4_VAL = '"+bean.getCol_4_val()+"'\n";		}

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
    
    //CommonEtc 테이블 조건에 맞는 여러건 조회 (20180709)
    public CommonEtcBean [] getCommonEtcAll(String table_nm, String col_1_nm, String col_1_val, String col_2_nm, String col_2_val, String col_3_nm, String col_3_val, String col_4_nm, String col_4_val ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT table_nm, col_1_nm, col_1_val, col_2_nm, col_2_val, col_3_nm, col_3_val, col_4_nm, col_4_val, etc_nm, etc_content, reg_id, reg_dt  "+
				" FROM COMMON_ETC WHERE TABLE_NM = '"+table_nm+"'" +
				" ";
        if(!col_1_nm.equals("")&&!col_1_val.equals("")){	query += " AND COL_1_NM='" + col_1_nm +"' AND COL_1_VAL='" + col_1_val +"' \n";		}
        if(!col_2_nm.equals("")&&!col_2_val.equals("")){	query += " AND COL_2_NM='" + col_2_nm +"' AND COL_2_VAL='" + col_2_val +"' \n";		}
        if(!col_3_nm.equals("")&&!col_3_val.equals("")){	query += " AND COL_3_NM='" + col_3_nm +"' AND COL_3_VAL='" + col_3_val +"' \n";		}
        if(!col_4_nm.equals("")&&!col_4_val.equals("")){	query += " AND COL_4_NM='" + col_4_nm +"' AND COL_4_VAL='" + col_4_val +"' \n";		}
        
        //정렬조건
        if(table_nm.equals("add_car_amt")){			query += "	ORDER BY COL_2_VAL ASC ";		}
        if(table_nm.equals("fine_notice_ment")){	query += "	ORDER BY COL_1_VAL ASC ";		}
        
        
        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeCommonEtcBean(rs));
 
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
        return (CommonEtcBean[])col.toArray(new CommonEtcBean[0]);
    }
    
    //CommonEtc 테이블 삭제 (20180628)
    public int deleteCommonEtc(CommonEtcBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
     
        String query = "";
   
        int count = 0;
               
        query  = "DELETE COMMON_ETC WHERE TABLE_NM='"+bean.getTable_nm()+
        		 "' AND COL_1_NM='" + bean.getCol_1_nm() +"' AND COL_1_VAL='" + bean.getCol_1_val()+"' \n" ;
        
        if(!bean.getCol_2_nm().equals("")&&!bean.getCol_2_val().equals("")){	query += " AND COL_2_NM='" + bean.getCol_2_nm() +"' AND COL_2_VAL='" + bean.getCol_2_val()+"' \n";		}
        if(!bean.getCol_3_nm().equals("")&&!bean.getCol_3_val().equals("")){	query += " AND COL_3_NM='" + bean.getCol_3_nm() +"' AND COL_3_VAL='" + bean.getCol_3_val()+"' \n";		}
        if(!bean.getCol_4_nm().equals("")&&!bean.getCol_4_val().equals("")){	query += " AND COL_4_NM='" + bean.getCol_4_nm() +"' AND COL_4_VAL='" + bean.getCol_4_val()+"' \n";		}
      
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
	
	public Hashtable getCodeCase(String c_st, String code, String nm_cd, String nm, String app_st, String cms_bk, String etc, String bigo, String use_yn) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            	
		String  query = " select * from code where c_st='"+c_st+"' and code<>'0000' ";

		if(!code.equals(""))	query += " and code='"+code+"' ";
		if(!nm_cd.equals(""))	query += " and nm_cd='"+nm_cd+"' ";
		if(!nm.equals(""))		query += " and nm='"+nm+"' ";
		if(!app_st.equals(""))	query += " and app_st='"+app_st+"' ";
		if(!cms_bk.equals(""))	query += " and cms_bk='"+cms_bk+"' ";
		if(!etc.equals(""))		query += " and etc='"+etc+"' ";
		if(!bigo.equals(""))	query += " and bigo='"+bigo+"' ";
		if(!use_yn.equals(""))	query += " and use_yn='"+use_yn+"' ";
	        
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		try {
			    pstmt = con.prepareStatement(query);				
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
	  		e.printStackTrace();
			System.out.println("[CommonDataBase:getCodeCase]"+e);
			System.out.println("[CommonDataBase:getCodeCase]"+query);
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht; 
	}

    public CodeBean [] getCodeDlvExt( String c_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT app_st, etc, LISTAGG(nm, '|') WITHIN GROUP (ORDER BY nm) AS nm FROM code WHERE c_st='"+c_st+"' AND app_st IS NOT NULL GROUP BY app_st, etc";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeCodeBean4(rs));
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    
    public CodeBean [] getCodeAll_0043() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null; 
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT app_st as sort, C_ST, CODE, NM_CD, NM, CMS_BK, APP_ST, USE_YN, VAR1, VAR2, VAR3, VAR4, VAR5, VAR6, ETC FROM CODE where C_ST='0043' and CODE <> '0000' and nvl(use_yn,'Y')<>'N' ";

    	query +=" union ";
		query +=" select '1' sort, '0043' as C_ST , '0000' as CODE, '' NM_CD, '=비용=' as NM,     '' CMS_BK, '' APP_ST, '' USE_YN, '' VAR1, '' VAR2, '' VAR3, '' VAR4, '' VAR5, '' VAR6, '' ETC from dual ";
		query +=" union ";
		query +=" select '2' sort, '0043' as C_ST , '0000' as CODE, '' NM_CD, '=자산=' as NM,     '' CMS_BK, '' APP_ST, '' USE_YN, '' VAR1, '' VAR2, '' VAR3, '' VAR4, '' VAR5, '' VAR6, '' ETC from dual ";
		query +=" union ";
		query +=" select '3' sort, '0043' as C_ST , '0000' as CODE, '' NM_CD, '=부채=' as NM,     '' CMS_BK, '' APP_ST, '' USE_YN, '' VAR1, '' VAR2, '' VAR3, '' VAR4, '' VAR5, '' VAR6, '' ETC from dual ";
		query +=" union ";
		query +=" select '4' sort, '0043' as C_ST , '0000' as CODE, '' NM_CD, '=영업외수익=' as NM, '' CMS_BK, '' APP_ST, '' USE_YN, '' VAR1, '' VAR2, '' VAR3, '' VAR4, '' VAR5, '' VAR6, '' ETC from dual ";
			       
      	query += " ORDER BY 1, 3 ";
      	
      	//System.out.println("[CommonDataBase:getCodeAll_0043]"+query);


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeCodeBean(rs));
 
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
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }
    
    
    public String Num2Hangul(int amt , String gubun) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		String query = "select f_Num2Hangul (" + amt + " , '" + gubun + "') from dual";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
		
				pstmt = con.prepareStatement(query);
			    rs = pstmt.executeQuery();
   	
				while(rs.next())
				{				
					 rtn = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
			    pstmt.close();
		
		} catch (SQLException e) {
	  		e.printStackTrace();
			System.out.println("[CommonDataBase:Num2Hangul]"+e);
			System.out.println("[CommonDataBase:Num2Hangul]"+query);
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}
    
    //이자금액 계산
    public String getIntAmt(String rest_amt ,String int_per, String y_day, String s_day) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		
		//str_alt_int = String.valueOf( alt_rest[j-1] * AddUtil.parseDouble(lend_int) / 100 / 365 * use_days );
            
		String query = "select trunc (" + rest_amt + " * " + int_per + "/100 / "+y_day+" * "+s_day+" ) from dual";
		
		if(s_day.equals("")) {
			query = "select trunc (" + rest_amt + " * " + int_per + "/100 / "+y_day+" ) from dual";
		}

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
		
				pstmt = con.prepareStatement(query);
			    rs = pstmt.executeQuery();
   	
				while(rs.next())
				{				
					 rtn = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
			    pstmt.close();
		
		} catch (SQLException e) {
	  		e.printStackTrace();
			System.out.println("[CommonDataBase:getIntAmt]"+e);
			System.out.println("[CommonDataBase:getIntAmt]"+query);
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}    
    
    //D-day  - 0229인 경우 0228로 처리 
    public int getCar_D_day(String gubun ,String car_mng_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		
	//	String query = "select TRUNC(to_number(to_date(substr(maint_end_dt, 0,4) || substr(init_reg_dt, 5, 8),'YYYYMMDD')-sysdate)) AS d_day from car_reg where car_mng_id='"+car_mng_id+"'";
		
		String query = "select TRUNC(to_number(to_date(substr(maint_end_dt, 0,4) || decode(substr(init_reg_dt, 5, 8), '0229', '0228', substr(init_reg_dt, 5, 8)), 'yyyymmdd')-sysdate)) AS d_day from car_reg where car_mng_id='"+car_mng_id+"'";
		
		if(gubun.equals("car_end_dt")) {
			query = "select TRUNC(to_number(to_date(car_end_dt,'YYYYMMDD')-sysdate)) AS d_day from car_reg where car_mng_id='"+car_mng_id+"'";
		}

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rtn = 0;
		try {
		
				pstmt = con.prepareStatement(query);
			    rs = pstmt.executeQuery();
   	
				if(rs.next())
				{				
					 rtn = rs.getInt(1);
				}
				rs.close();
			    pstmt.close();
		
		} catch (SQLException e) {
	  		e.printStackTrace();
			System.out.println("[CommonDataBase:getCar_D_day]"+e);
			System.out.println("[CommonDataBase:getCar_D_day]"+query);
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}
    
    
    // 공휴일 리스트 조회
	public Vector getHolidayList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        String query = "SELECT TO_CHAR(TO_DATE(HDAY,'YYYYMMDD'),'MM/DD/YYYY') AS HDAY, HDAY_NM, SEQ FROM HOLIDAY WHERE HDAY BETWEEN '2022%' AND '2100%' ORDER BY HDAY";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
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
