/*
 * 사용자등록, 메뉴관리, 권한관리
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.user_mng;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class UserMngDatabase {

    private static UserMngDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized UserMngDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new UserMngDatabase();
        return instance;
    }
    
    private UserMngDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	/**
     * 사용자
     */
    private UsersBean makeUserBean(ResultSet results) throws DatabaseException {

        try {
            UsersBean bean = new UsersBean();

            bean.setUser_id(results.getString("USER_ID"));				//사용자 관리번호
		    bean.setBr_id(results.getString("BR_ID"));					// 지점ID
		    bean.setBr_nm(results.getString("BR_NM"));					//지점명칭
		    bean.setUser_nm(results.getString("USER_NM"));					//사용자이름
		    bean.setId(results.getString("ID"));						//사용자ID
		    bean.setUser_psd(results.getString("USER_PSD"));				//비밀번호
		    bean.setUser_ssn(results.getString("USER_SSN"));				//주민등록번호
		    bean.setUser_cd(results.getString("USER_CD"));					//사원번호
		    bean.setDept_id(results.getString("DEPT_ID"));					//부서ID
		    bean.setDept_nm(results.getString("DEPT_NM"));					//부서이름
		    bean.setUser_h_tel(results.getString("USER_H_TEL"));				//집전화번호
		    bean.setUser_m_tel(results.getString("USER_M_TEL"));				//휴대폰
		    bean.setIn_tel(results.getString("IN_TEL"));				//내선번호
		    bean.setHot_tel(results.getString("HOT_TEL"));				//직통번호
		    bean.setUser_email(results.getString("USER_EMAIL"));				//이메일
		    bean.setUser_pos(results.getString("USER_POS"));				//직위
		    bean.setUser_aut(results.getString("USER_AUT"));				//권한	
		    bean.setLic_no(results.getString("LIC_NO"));				//면허번호	
		    bean.setLic_dt(results.getString("LIC_DT"));				//면허취득일자	
		    bean.setEnter_dt(results.getString("ENTER_DT"));				//입사년월일
		    bean.setContent(results.getString("content"));				//인사말
		    bean.setFilename(results.getString("filename"));				//인사말
			bean.setFilename2(results.getString("filename2"));				//인사말
		    bean.setZip(results.getString("zip"));				//신분증주소 우편번호
		    bean.setAddr(results.getString("addr"));				//신분증주소 
		    bean.setMail_id(results.getString("mail_id"));				
		    bean.setMail_pw(results.getString("mail_pw"));				

		    bean.setLoan_st(results.getString("loan_st"));
		    bean.setSa_code(results.getString("sa_code"));
		    bean.setOut_dt(results.getString("out_dt"));
		    bean.setUse_yn(results.getString("use_yn"));
		    bean.setUser_work(results.getString("user_work"));
		    bean.setUser_i_tel(results.getString("USER_I_TEL"));			//무선인터넷사용자번호
		    bean.setFax_id(results.getString("fax_id"));					//인터넷팩스아이디
		    bean.setFax_pw(results.getString("fax_pw"));					//인터넷팩스비밀번호
		    bean.setPartner_id(results.getString("partner_id"));			//채권파트너아이디
		    bean.setI_fax(results.getString("i_fax"));						//인터넷팩스수신번호

			bean.setTaste(results.getString("taste"));						//취미
			bean.setSpecial(results.getString("special"));					//특기
			bean.setVen_code(results.getString("ven_code"));				//네오엠거래처코드
			bean.setGundea(results.getString("gundea"));					//병역사항
			bean.setBank_nm(results.getString("bank_nm"));					//은행
			bean.setBank_no(results.getString("bank_no"));					//계좌번호

			bean.setAdd_per(results.getString("add_per")==null?0:AddUtil.parseFloat(results.getString("add_per")));
			bean.setArea_id(results.getString("area_id")==null?"":results.getString("area_id"));
			bean.setArea_nm(results.getString("area_nm")==null?"":results.getString("area_nm"));

			bean.setHome_zip(results.getString("home_zip"));				//실거주주소 우편번호
		    bean.setHome_addr(results.getString("home_addr"));				//실거주주소 
		
			bean.setUser_job(results.getString("user_job"));				//직책
		    bean.setAgent_cont_view(results.getString("agent_cont_view"));	//에이전트계약조회구분
		    bean.setArs_group(results.getString("ars_group"));				//ars파트너
		
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

   private UsersBean makeSmartUserBean(ResultSet results) throws DatabaseException {

        try {
            UsersBean bean = new UsersBean();

            bean.setUser_id(results.getString("USER_ID"));				//사용자 관리번호
		    bean.setBr_id(results.getString("BR_ID"));					// 지점ID
		    bean.setBr_nm(results.getString("BR_NM"));					//지점명칭
		    bean.setUser_nm(results.getString("USER_NM"));					//사용자이름
		    bean.setId(results.getString("ID"));						//사용자ID		   
		    bean.setDept_id(results.getString("DEPT_ID"));					//부서ID
		    bean.setDept_nm(results.getString("DEPT_NM"));					//부서이름
		    bean.setUser_m_tel(results.getString("USER_M_TEL"));				//휴대폰
		    bean.setIn_tel(results.getString("IN_TEL"));				//내선번호
		    bean.setHot_tel(results.getString("HOT_TEL"));				//직통번호
		  
		    bean.setUser_pos(results.getString("USER_POS"));				//직위	
			bean.setFilename(results.getString("filename"));				//인사말
			bean.setFilename2(results.getString("filename2"));				//인사말
		  		  		 
		//	bean.setAge(results.getString("age")==null?"":results.getString("age"));
			bean.setSch_chk(results.getString("sch_chk")==null?"":results.getString("sch_chk"));
			bean.setLoan_st(results.getString("loan_st")==null?"":results.getString("loan_st"));
		
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}



	/**
     * 부서
     */
    private DeptBean makeDeptBean(ResultSet results) throws DatabaseException {

        try {
            DeptBean bean = new DeptBean();

            bean.setC_st(results.getString("C_ST"));					//코드분류
		    bean.setCode(results.getString("CODE"));					//코드(순차적증가)
		    bean.setNm_cd(results.getString("NM_CD"));					//사용코드명
		    bean.setNm(results.getString("NM"));						//부서이름
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 근무지
     */
    private AreaBean makeAreaBean(ResultSet results) throws DatabaseException {

        try {
            AreaBean bean = new AreaBean();

            bean.setC_st(results.getString("C_ST"));					//코드분류
		    bean.setCode(results.getString("CODE"));					//코드(순차적증가)
		    bean.setNm_cd(results.getString("NM_CD"));					//사용코드명
		    bean.setNm(results.getString("NM"));						//부서이름
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 지점
     */
    private BranchBean makeBranchBean(ResultSet results) throws DatabaseException {
        try {
            BranchBean bean = new BranchBean();

		    bean.setBr_id(results.getString("BR_ID"));							//저점ID
		    bean.setBr_ent_no(results.getString("BR_ENT_NO"));					//사업자등록번호
		    bean.setBr_nm(results.getString("BR_NM"));							//법인명
		    bean.setBr_st_dt(results.getString("BR_ST_DT"));					//개업년월일
		    bean.setBr_post(results.getString("BR_POST"));						//우편번호
		    bean.setBr_addr(results.getString("BR_ADDR"));						//주소
		    bean.setBr_item(results.getString("BR_ITEM"));						//종목
		    bean.setBr_sta(results.getString("BR_STA"));						//업태
		    bean.setBr_tax_o(results.getString("BR_TAX_O"));					//관할세무서
		    bean.setBr_own_nm(results.getString("BR_OWN_NM"));					//대표자
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
    }
	/**
     * 메뉴
     */
 /*   private MenuBean makeMenuBean(ResultSet results, String arg) throws DatabaseException {

        try {
            MenuBean bean = new MenuBean();

            bean.setM_st(results.getString("M_ST"));					//대메뉴 구분
		    bean.setM_cd(results.getString("M_CD"));					//소메뉴 구분
		    if(arg.equals("menu"))
		    {
		    bean.setM_nm(results.getString("M_NM"));					//메뉴명
		    bean.setUrl(results.getString("URL"));					//url
		    bean.setNote(results.getString("NOTE"));					//비고
		    bean.setSeq(results.getInt("SEQ"));						//순번
		    }else if(arg.equals("sub"))
		    {					
		    bean.setSeq_no(results.getInt("SEQ_NO"));						//서브메뉴SEQ
			bean.setSm_nm(results.getString("SM_NM"));					//서브메뉴명
			}
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

*/	/**
     * 메뉴2
     */
    private MenuBean makeMaMenuBean(ResultSet results, String arg) throws DatabaseException {

        try {
            MenuBean bean = new MenuBean();

            bean.setM_st(results.getString("M_ST"));					//대메뉴 구분
            bean.setM_st2(results.getString("M_ST2"));					//중메뉴 구분
		    bean.setM_cd(results.getString("M_CD"));					//소메뉴 구분
		    if(arg.equals("menu"))
		    {
		    bean.setM_nm(results.getString("M_NM"));					//메뉴명
		    bean.setUrl(results.getString("URL"));					//url
		    bean.setNote(results.getString("NOTE"));					//비고
		    bean.setSeq(results.getInt("SEQ"));						//순번
		    }else if(arg.equals("sub"))
		    {					
		    bean.setSeq_no(results.getInt("SEQ_NO"));						//서브메뉴SEQ
			bean.setSm_nm(results.getString("SM_NM"));					//서브메뉴명
			}
		    bean.setBase(results.getString("BASE"));					//기본페이지여부
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 권한
     */
    private AuthBean makeAuthBean(ResultSet results) throws DatabaseException {

        try {
            AuthBean bean = new AuthBean();
            bean.setM_st(results.getString("M_ST"));					//대메뉴 구분
            bean.setM_st2(results.getString("M_ST2"));					//대메뉴 구분
		    bean.setM_cd(results.getString("M_CD"));					//소메뉴 구분
		    bean.setM_nm(results.getString("M_NM"));					//메뉴명
		    bean.setUrl(results.getString("URL"));						//메뉴명
		    bean.setAuth_rw(results.getString("AUTH_RW"));
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
 	/**
     * 부서 전체 조회.
     */
    public String checkUserID(String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String id = "";
        
        String query = "";
        
        query = "SELECT ID FROM USERS WHERE ID='" + user_id + "'";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            if(rs.next())
                id = rs.getString("ID");

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
        return id;
    }
    /**
     * 사용자 조회
     */    
    public UsersBean getUsersBean(String user_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        UsersBean umb = new UsersBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		int cnt = 0;

        query = " SELECT a.USER_ID, a.BR_ID, a.USER_POS, b.BR_NM, a.USER_NM, a.ID,  text_decrypt(a.user_psd, 'pw') USER_PSD, a.USER_CD, text_decrypt(a.user_ssn, 'pw') USER_SSN, a.DEPT_ID, c.NM AS DEPT_NM, \n"+
				"        a.USER_H_TEL, a.USER_M_TEL, a.IN_TEL, a.HOT_TEL, a.USER_EMAIL, \n"+
				"        a.USER_POS  as USER_POS2, \n"+
				"        a.USER_AUT, a.LIC_NO, a.LIC_DT, nvl(a.ENTER_DT,'99999999') enter_dt, \n"+
				"        a.content, a.filename, a.zip, a.addr, a.mail_id, d.passwd as mail_pw, \n"+
				"        a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax,a.taste, a.special, a.ven_code, \n"+
				"        a.gundea, a.bank_nm, a.bank_no, \n"+
				"        a.filename2, a.add_per, a.area_id, e.nm as area_nm, a.home_zip, a.home_addr, a.user_job, a.agent_cont_view, a.ars_group \n"
        		+ "FROM  USERS a, BRANCH b, CODE c, mail_mng d, (select * from code where c_st='0029') e \n"
        		+ "where a.USER_ID='" + user_id +"' and a.BR_ID = b.BR_ID and c.C_ST = '0002' and c.CODE = a.DEPT_ID and a.mail_id=d.userid(+) and a.area_id=e.code(+) \n";


        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            if (rs.next())
                umb = makeUserBean(rs);
            
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

        return umb;
    }
    
    /**
     * 부서 전체 조회.
     */
    public DeptBean [] getDeptAll() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM\n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='0002'\n"
        		+ "and CODE <> '0000'";

        Collection<DeptBean> col = new ArrayList<DeptBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            //pstmt.setString(1, cont_id);
            while(rs.next()){
                
				col.add(makeDeptBean(rs));
 
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
        return (DeptBean[])col.toArray(new DeptBean[0]);
    }

    /**
     * 근무지 전체 조회. 0024->0029  채권그룹으로 변경 
     */
    public AreaBean [] getAreaAll(String dept_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT C_ST, CODE, NM_CD, NM\n"
        		+ "FROM CODE a\n"
        		+ "where C_ST='0029'\n"
        		+ "and CODE <> '0000'";

		if(!dept_id.equals("")){
			query += " and app_st='"+dept_id+"' ";
		}

        Collection<AreaBean> col = new ArrayList<AreaBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            
            while(rs.next()){
                
				col.add(makeAreaBean(rs));
 
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
        return (AreaBean[])col.toArray(new AreaBean[0]);
    }

    /**
     * 사용자 전체 조회.
     */
    public UsersBean [] getUserAll(String br_id, String dept_id, String user_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.USER_ID, \n"
        				+ "a.BR_ID, \n"
        				+ "b.BR_NM, \n"
        				+ "a.USER_NM, \n"
        				+ "a.ID, \n"
        				+ "a.USER_PSD, \n"
        				+ "a.USER_CD, \n"
        				+ "a.USER_SSN, \n"
        				+ "a.DEPT_ID, \n"
        				+ "c.NM AS DEPT_NM, \n"
        				+ "a.USER_H_TEL, \n"
        				+ "a.USER_M_TEL, \n"
						+ "a.IN_TEL, \n"
						+ "a.HOT_TEL, \n"
        				+ "a.USER_EMAIL, \n"
        				+ "a.USER_POS,\n"
        				+ "a.USER_AUT, a.LIC_NO, a.LIC_DT, a.ENTER_DT, a.content, a.filename, a.filename2, a.zip, a.addr, d.userid as mail_id, d.passwd as mail_pw, \n"
						+ "a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax, a.taste, a.special, a.ven_code, \n"
						+ "a.gundea, a.bank_nm, a.bank_no, a.add_per, a.area_id, e.nm as area_nm, a.home_zip, a.home_addr, a.user_job, a.agent_cont_view, a.ars_group  \n"
        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d, (select * from code where c_st='0029') e \n"
        		+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) \n"
        		+ "and a.DEPT_ID = c.CODE(+) and a.area_id=e.code(+) \n";

		if(!dept_id.equals("9999")) query += "  and nvl(a.use_yn,'Y')='Y'";
		else						query += "  and nvl(a.use_yn,'Y')='N'";

		if(!br_id.equals(""))	query += " and a.BR_ID like '%" + br_id + "%'";
		if(!dept_id.equals("")) query += " and a.DEPT_ID like '%" + dept_id + "%'";
		if(!user_nm.equals("")) query += " and a.USER_NM like '%" + user_nm + "%'";

// 원본		query += " order by a.br_id, a.DEPT_ID, a.enter_dt";
     query += " order by decode(decode(a.dept_id,'1000','',a.user_pos),'대표이사',1, '이사', 2, 3), decode(a.user_id, '000004', '1', '000005', '2', '9' ) , decode(a.dept_id , '0020', '0000' , a.dept_id) ,  decode(a.user_id, '000237', '0',decode(a.user_pos, '부장', 1,  '차장', 2, '과장',3,'대리', 4, 5)), a.user_id";
 //    query += "  order by decode(a.dept_id , '0020', '0000' , a.dept_id),  decode(a.user_id, '000237', '2', DECODE(a.USER_POS, '대표이사', '1', '이사', '2', '부장', '3', '팀장', '4', '차장' , '5', '과장' , '6', '대리', '7', '사원', '8', DECODE(a.dept_id,'1000','10','9') )) , a.user_id";
 
      
        Collection<UsersBean> col = new ArrayList<UsersBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeUserBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			//System.out.println("[UserMngDatabase:getUserAll]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (UsersBean[])col.toArray(new UsersBean[0]);
    }

    /**
     * 사용자 전체 조회.
     */
    public UsersBean [] getUserAllSostel(String br_id, String dept_id, String user_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.USER_ID, \n"
        				+ "a.BR_ID, \n"
        				+ "b.BR_NM, \n"
        				+ "a.USER_NM, \n"
        				+ "a.ID, \n"
        				+ "a.USER_PSD, \n"
        				+ "a.USER_CD, \n"
        				+ "a.USER_SSN, \n"
        				+ "a.DEPT_ID, \n"
        				+ "c.NM AS DEPT_NM, \n"
        				+ "a.USER_H_TEL, \n"
        				+ "a.USER_M_TEL, \n"
						+ "a.IN_TEL, \n"
						+ "a.HOT_TEL, \n"
        				+ "a.USER_EMAIL, \n"
        				+ "a.USER_POS, \n"
        				+ "a.USER_AUT, a.LIC_NO, a.LIC_DT, a.ENTER_DT, a.content, a.filename, a.filename2, a.zip, a.addr, d.userid as mail_id, d.passwd as mail_pw, \n"
						+ "a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax, a.taste, a.special, a.ven_code, \n"
						+ "a.gundea, a.bank_nm, a.bank_no, a.add_per, a.area_id, e.nm as area_nm , a.home_zip, a.home_addr, a.user_job, a.agent_cont_view, a.ars_group  \n"
        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d, (select * from code where c_st='0029') e \n"
				+ ",  car_off_emp f, car_off g "
        		+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and a.user_id not in ( '000203', '000330' ) \n"
        		+ "and a.DEPT_ID = c.CODE(+) and a.area_id=e.code(+) \n"
				+ "AND a.SA_CODE = f.emp_id(+) AND f.agent_id = g.car_off_id(+) AND NVL(g.work_st , 'C') NOT IN ('E') \n";

		if(!dept_id.equals("9999")) query += "  and nvl(a.use_yn,'Y')='Y'";
		else						query += "  and nvl(a.use_yn,'Y')='N'";

		if(!br_id.equals(""))	query += " and a.BR_ID like '%" + br_id + "%'";
		if(!dept_id.equals("")) query += " and a.DEPT_ID like '%" + dept_id + "%'";
		if(!user_nm.equals("")) query += " and a.USER_NM like '%" + user_nm + "%'";

// 원본		query += " order by a.br_id, a.DEPT_ID, a.enter_dt";
		query += "order by decode(a.user_id, '000237', '3',  decode(a.user_pos,'대표이사',1, '이사', 2, '팀장', 3,'부장', 4, '차장', 5, '과장', 6, '대리',7,8)), a.user_id, a.dept_id, a.area_id ";
	
//System.out.println("[UserMngDatabase:getUserAllSostel]"+query);

        Collection<UsersBean> col = new ArrayList<UsersBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeUserBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
		System.out.println("[UserMngDatabase:getUserSmsAll]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (UsersBean[])col.toArray(new UsersBean[0]);
    }

	 /**
     * 사용자 전체 조회.
     */
    public UsersBean [] getUserSmsAll(String br_id, String dept_id, String user_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "a.ID,\n"
        				+ "a.USER_PSD,\n"
        				+ "a.USER_CD,\n"
        				+ "a.USER_SSN,\n"
        				+ "a.DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_H_TEL,\n"
        				+ "a.USER_M_TEL,\n"
						+ "a.IN_TEL,\n"
						+ "a.HOT_TEL,\n"
        				+ "a.USER_EMAIL,\n"
        				+ "a.USER_POS,\n"
        				+ "a.USER_AUT, a.LIC_NO, a.LIC_DT, a.ENTER_DT, a.content, a.filename, a.filename2, a.zip, a.addr, d.userid as mail_id, d.passwd as mail_pw,\n"
						+ "a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax, a.taste, a.special, a.ven_code, \n"
						+ "a.gundea, a.bank_nm, a.bank_no, a.add_per, a.area_id, e.nm as area_nm, a.home_zip, a.home_addr, a.user_job, a.agent_cont_view, a.ars_group  \n"
        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d, (select * from code where c_st='0029') e \n"
        		+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+)\n"
        		+ "and a.DEPT_ID = c.CODE(+) and a.dept_id not in ( '8888' ) and a.user_id not in ('000035') and a.area_id=e.code(+) \n";

		if(!dept_id.equals("9999")) query += "  and nvl(a.use_yn,'Y')='Y'";
		else						query += "  and nvl(a.use_yn,'Y')='N'";

		if(!br_id.equals(""))	query += " and a.BR_ID like '%" + br_id + "%'";
		if(!dept_id.equals("")) query += " and a.DEPT_ID like '%" + dept_id + "%'";
		if(!user_nm.equals("")) query += " and a.USER_NM like '%" + user_nm + "%'";

// 원본		query += " order by a.br_id, a.DEPT_ID, a.enter_dt";
		query += "order by decode(a.user_pos,'대표이사',1,'이사', 2, '부장', 3,'팀장',  4, '차장', 5, '과장', 6, '대리',7,8), a.user_id, a.dept_id";


        Collection<UsersBean> col = new ArrayList<UsersBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeUserBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			//System.out.println("[UserMngDatabase:getUserSmsAll]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (UsersBean[])col.toArray(new UsersBean[0]);
    }
    
    /**
     * 지점 전체 조회.
     */
    public BranchBean [] getBranchAll() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.BR_ID,\n"
        				+ "a.BR_ENT_NO,\n"
        				+ "a.BR_NM,\n"
        				+ "nvl(substr(a.BR_ST_DT,1,4),'0000')||'-'||nvl(substr(a.BR_ST_DT,5,2),'00')||'-'||nvl(substr(a.BR_ST_DT,7,2),'00') as BR_ST_DT,\n"
        				+ "a.BR_POST,\n"
        				+ "a.BR_ADDR,\n"
        				+ "a.BR_ITEM,\n"
        				+ "a.BR_STA,\n"
        				+ "a.BR_TAX_O,\n"
        				+ "a.BR_OWN_NM \n"
        		+ "FROM BRANCH a where a.use_yn='Y'  \n"
        		+ "order by a.br_st_dt, a.br_id";

        Collection<BranchBean> col = new ArrayList<BranchBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeBranchBean(rs));
 
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
        return (BranchBean[])col.toArray(new BranchBean[0]);
    }
    /**
     * 메뉴 전체 조회.
     */
/*
    public MenuBean [] getMenuAll(String m_st,String arg) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        if(arg.equals("b"))
        {
	        query = "SELECT a.M_ST,\n"
	        				+ "a.M_CD,\n"
	                		+ "a.M_NM,\n"
	                		+ "a.URL,\n"
	                		+ "a.SEQ,\n"
	                		+ "a.NOTE\n"
	        		+ "FROM MENU a\n"
	        		+ "where m_st like '%%'\n"
	        		+ "and m_cd = '00'\n"
	        		+ "order by a.M_ST, a.SEQ";
        }else if(arg.equals("s")){
	        query = "SELECT a.M_ST,\n"
	        				+ "a.M_CD,\n"
	                		+ "a.M_NM,\n"
	                		+ "a.URL,\n"
	                		+ "a.SEQ,\n"
	                		+ "a.NOTE\n"
	        		+ "FROM MENU a\n"
	        		+ "where m_st like '%" + m_st + "%'\n"
	        		+ "and m_cd <> '00'\n"
	        		+ "order by a.M_ST, a.SEQ";
	    }

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeMenuBean(rs, "menu"));
 
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
        return (MenuBean[])col.toArray(new MenuBean[0]);
    }
*/

    /**
     * 서브 메뉴 전체 조회.
     */
/*
    public MenuBean [] getSubMenuAll(String m_st,String m_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        
	        query = "SELECT a.M_ST,\n"
	        				+ "a.M_CD,\n"
	                		+ "a.SEQ_NO,\n"
	                		+ "a.SM_NM\n"
	        		+ "FROM SUB_M a\n"
	        		+ "where m_st = '" + m_st + "'\n"
	        		+ "and m_cd = '" + m_cd + "'\n"
	        		+ "order by a.SEQ_NO";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeMenuBean(rs, "sub"));
 
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
        return (MenuBean[])col.toArray(new MenuBean[0]);
    }
*/
    
    /**
     * kakao_id 조회
     */
    public String getKakao(String kakao_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String return_kakao_id = "";
        
        String query = "";
        
        query = "SELECT * FROM KAKAO_MAP WHERE KAKAO_ID='" + kakao_id + "'";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            if(rs.next())
            	return_kakao_id = rs.getString("kakao_id");

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
        return return_kakao_id;
    }
    
    
    /**
     * kakao_map one row return
     */
    public String getKakaoMap(String kakao_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String return_id = "";
        
        String query = "";
        
        query = "SELECT * FROM KAKAO_MAP WHERE KAKAO_ID='" + kakao_id + "'";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            if(rs.next())
            	return_id = rs.getString("id");

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
        return return_id;
    }
    
    
    /**
     * kakao_id 등록.
     */
    public int insertKakaoMap(String user_id, String name, String kakao_id, String kakao_email, String use_yn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query = "INSERT INTO KAKAO_MAP(USER_ID,\n"
								+ "ID,\n"
								+ "KAKAO_ID,\n"
								+ "KAKAO_EMAIL,\n"
								+ "USE_YN,\n"
								+ "REG_DT)\n"
				+ "values(?,?,?,?,?,sysdate)";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, user_id);
            pstmt.setString(2, name);
            pstmt.setString(3, kakao_id);
            pstmt.setString(4, kakao_email);
            pstmt.setString(5, use_yn);
            
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
     * 사용자 등록.
     */
    public int insertUser(UsersBean bean) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	Statement stmt = null; 
    	String query = "";
    	String userQuery = "";
    	String user_id = "";
    	int count = 0;
    	
    	query="INSERT INTO USERS(USER_ID,\n"
    			+ "BR_ID,\n"
    			+ "USER_NM,\n"
    			+ "ID,\n"
    			+ "USER_PSD,\n"
    			+ "USER_CD,\n"
    			+ "USER_SSN,\n"
    			+ "DEPT_ID,\n"
    			+ "USER_H_TEL,\n"
    			+ "USER_M_TEL,\n"
    			+ "IN_TEL,\n"
    			+ "HOT_TEL,\n"
    			+ "USER_POS,\n"
    			+ "USER_AUT,\n"
    			+ "USER_EMAIL,\n"
    			+ "TASTE,\n"
    			+ "SPECIAL,\n"
    			+ "LIC_NO, LIC_DT, ENTER_DT, content, zip, addr, use_yn, end_dt,\n"
    			+ "mail_id, loan_st, user_work, user_i_tel, fax_id, fax_pw, gundea, area_id, home_zip, home_addr, sa_code)\n"
    			//	+ "from users\n"
    			+ "values(?, ?, ?, ?, text_encrypt(?, 'pw') , ?, text_encrypt(?, 'pw'), ?,?,?,?,?,?,?,?,?,?,?,replace(?,'-',''),replace(?,'-',''),?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    	
    	userQuery = "select nvl(lpad(max(user_id)+1,6,'0'),'000001') from users where user_id<>'999999'";
    	
    	try{
    		con.setAutoCommit(false);
    		
    		stmt = con.createStatement();
    		rs = stmt.executeQuery(userQuery);
    		if(rs.next())
    			user_id = rs.getString(1).trim();
    		rs.close();
    		stmt.close();
    		
    		pstmt = con.prepareStatement(query);
    		
    		pstmt.setString(1,  user_id.trim()				);
    		pstmt.setString(2,  bean.getBr_id().trim()		);
    		pstmt.setString(3,  bean.getUser_nm().trim()	);
    		pstmt.setString(4,  bean.getId().trim()			);
    		pstmt.setString(5,  bean.getUser_psd().trim()	);
    		pstmt.setString(6,  bean.getUser_cd().trim()	);
    		pstmt.setString(7,  bean.getUser_ssn().trim()	);
    		pstmt.setString(8,  bean.getDept_id().trim()	);
    		pstmt.setString(9,  bean.getUser_h_tel().trim()	);
    		pstmt.setString(10, bean.getUser_m_tel().trim()	);
    		pstmt.setString(11, bean.getIn_tel().trim()		);
    		pstmt.setString(12, bean.getHot_tel().trim()	);
    		pstmt.setString(13, bean.getUser_pos().trim()	);
    		pstmt.setString(14, bean.getUser_aut().trim()	);
    		pstmt.setString(15, bean.getUser_email().trim()	);
    		pstmt.setString(16, bean.getTaste().trim()		);
    		pstmt.setString(17, bean.getSpecial().trim()	);
    		pstmt.setString(18, bean.getLic_no().trim()		);
    		pstmt.setString(19, bean.getLic_dt().trim()		);
    		pstmt.setString(20, bean.getEnter_dt().trim()	);
    		pstmt.setString(21, bean.getContent().trim()	);
    		pstmt.setString(22, bean.getZip().trim()		);
    		pstmt.setString(23, bean.getAddr().trim()		);
    		pstmt.setString(24, bean.getUse_yn().trim()		);
    		pstmt.setString(25, AddUtil.getDate(1)+""+"1231");
    		pstmt.setString(26, bean.getMail_id().trim()	);
    		pstmt.setString(27, bean.getLoan_st().trim()	);
    		pstmt.setString(28, bean.getUser_work().trim()	);
    		pstmt.setString(29, bean.getUser_i_tel().trim()	);
    		pstmt.setString(30, bean.getFax_id().trim()		);
    		pstmt.setString(31, bean.getFax_pw().trim()		);
    		pstmt.setString(32, bean.getGundea().trim()		);
    		pstmt.setString(33, bean.getArea_id().trim()	);
    		pstmt.setString(34, bean.getHome_zip().trim()	);
    		pstmt.setString(35, bean.getHome_addr().trim()	);
    		pstmt.setString(36, bean.getSa_code().trim()	);	//영업사원코드추가(20181105)
    		
    		
    		count = pstmt.executeUpdate();
    		
    		pstmt.close();
    		con.commit();
    		
    		
    	}catch(SQLException se){
    		try{
    			System.out.println("[CostDatabase:getStatDebt]"+se);
    			
    			System.out.println("[user_id.trim()				]"+user_id.trim()				);
    			System.out.println("[bean.getBr_id().trim()		]"+bean.getBr_id().trim()		);
    			System.out.println("[bean.getUser_nm().trim()	]"+bean.getUser_nm().trim()		);
    			System.out.println("[bean.getId().trim()		]"+bean.getId().trim()			);
    			System.out.println("[bean.getUser_psd().trim()	]"+bean.getUser_psd().trim()	);
    			System.out.println("[bean.getUser_cd().trim()	]"+bean.getUser_cd().trim()		);
    			System.out.println("[bean.getUser_ssn().trim()	]"+bean.getUser_ssn().trim()	);
    			System.out.println("[bean.getDept_id().trim()	]"+bean.getDept_id().trim()		);
    			System.out.println("[bean.getUser_h_tel().trim()]"+bean.getUser_h_tel().trim()	);
    			System.out.println("[bean.getUser_m_tel().trim()]"+bean.getUser_m_tel().trim()	);
    			System.out.println("[bean.getIn_tel().trim()	]"+bean.getIn_tel().trim()		);
    			System.out.println("[bean.getHot_tel().trim()	]"+bean.getHot_tel().trim()		);
    			System.out.println("[bean.getUser_pos().trim()	]"+bean.getUser_pos().trim()	);
    			System.out.println("[bean.getUser_aut().trim()	]"+bean.getUser_aut().trim()	);
    			System.out.println("[bean.getUser_email().trim()]"+bean.getUser_email().trim()	);
    			System.out.println("[bean.getTaste().trim()		]"+bean.getTaste().trim()		);
    			System.out.println("[bean.getSpecial().trim()	]"+bean.getSpecial().trim()		);
    			System.out.println("[bean.getLic_no().trim()	]"+bean.getLic_no().trim()		);
    			System.out.println("[bean.getLic_dt().trim()	]"+bean.getLic_dt().trim()		);
    			System.out.println("[bean.getEnter_dt().trim()	]"+bean.getEnter_dt().trim()	);
    			System.out.println("[bean.getContent().trim()	]"+bean.getContent().trim()		);
    			System.out.println("[bean.getZip().trim()		]"+bean.getZip().trim()			);
    			System.out.println("[bean.getAddr().trim()		]"+bean.getAddr().trim()		);
    			System.out.println("[use_yn						]"+"Y"							);
    			System.out.println("[AddUtil.getDate(1)			]"+AddUtil.getDate(1)+""+"1231"	);
    			System.out.println("[bean.getMail_id().trim()	]"+bean.getMail_id().trim()		);
    			System.out.println("[bean.getLoan_st().trim()	]"+bean.getLoan_st().trim()		);
    			System.out.println("[bean.getUser_work().trim()	]"+bean.getUser_work().trim()	);
    			System.out.println("[bean.getUser_i_tel().trim()]"+bean.getUser_i_tel().trim()	);
    			System.out.println("[bean.getFax_id().trim()	]"+bean.getFax_id().trim()		);
    			System.out.println("[bean.getFax_pw().trim()	]"+bean.getFax_pw().trim()		);
    			System.out.println("[bean.getGundea().trim()	]"+bean.getGundea().trim()		);
    			System.out.println("[bean.getArea_id().trim()	]"+bean.getArea_id().trim()		);
    			System.out.println("[bean.getHome_ip().trim()	]"+bean.getHome_zip().trim()	);
    			System.out.println("[bean.getHome_addr().trim()	]"+bean.getHome_addr().trim()	);
    			System.out.println("[bean.getSa_code().trim()	]"+bean.getSa_code().trim()		);
    			
    			con.rollback();
    		}catch(SQLException _ignored){}
    		throw new DatabaseException("exception");
    	}finally{
    		try{
    			con.setAutoCommit(true);
    			if(rs != null) rs.close();
    			if(stmt != null) stmt.close();
    			if(pstmt != null) pstmt.close();
    		}catch(SQLException _ignored){}
    		connMgr.freeConnection(DATA_SOURCE, con);
    		con = null;
    		
    		//System.out.println(bean.getIn_tel());
//System.out.println(bean.getHot_tel());
    	}
    	return count;
    }
    /**
     * 사용자 수정.
     */
    public int updateUser(UsersBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String user_id = "";
        int count = 0;
                
        query="UPDATE USERS SET BR_ID=?,\n"
								+ "USER_NM=?,\n"
								+ "ID=?,\n"
								+ "USER_PSD=  text_encrypt(?, 'pw')  ,\n"
								+ "USER_CD=?,\n"
								+ "USER_SSN= text_encrypt(?, 'pw') ,\n"
								+ "DEPT_ID=?,\n"
								+ "USER_H_TEL=?,\n"
								+ "USER_M_TEL=?,\n"
								+ "IN_TEL=?,\n"
								+ "HOT_TEL=?,\n"
								+ "USER_POS=?,\n"
								+ "USER_AUT=?,\n"
								+ "USER_EMAIL=?, TASTE=?, SPECIAL = ?, LIC_NO=?, LIC_DT=replace(?,'-',''), ENTER_DT=replace(?,'-',''), content=?, filename=?,"
							   + " zip=?, addr=?,\n"
							   + " mail_id=?, loan_st=?, user_work=?, user_i_tel=?, fax_id=?, fax_pw=?, partner_id=?, i_fax=?, ven_code=?, gundea=?, add_per=?, area_id=?, home_zip=?, home_addr=?, sa_code=? "							
                         + "WHERE USER_ID=?";
 
       try{
            con.setAutoCommit(false);
            
           
            pstmt = con.prepareStatement(query);

            
            pstmt.setString(1, bean.getBr_id().trim());
            pstmt.setString(2, bean.getUser_nm().trim());
            pstmt.setString(3, bean.getId().trim());
            pstmt.setString(4, bean.getUser_psd().trim());
            pstmt.setString(5, bean.getUser_cd().trim());
            pstmt.setString(6, bean.getUser_ssn().trim());
            pstmt.setString(7, bean.getDept_id().trim());
            pstmt.setString(8, bean.getUser_h_tel().trim());
            pstmt.setString(9, bean.getUser_m_tel().trim());
			pstmt.setString(10, bean.getIn_tel().trim());
			pstmt.setString(11, bean.getHot_tel().trim());
            pstmt.setString(12, bean.getUser_pos().trim());
            pstmt.setString(13, bean.getUser_aut().trim());
            pstmt.setString(14, bean.getUser_email().trim());
			pstmt.setString(15, bean.getTaste().trim());
			pstmt.setString(16, bean.getSpecial().trim());
            pstmt.setString(17, bean.getLic_no().trim());
            pstmt.setString(18, bean.getLic_dt().trim());
            pstmt.setString(19, bean.getEnter_dt().trim());
            pstmt.setString(20, bean.getContent().trim());
            pstmt.setString(21, bean.getFilename().trim());
            pstmt.setString(22, bean.getZip().trim());
            pstmt.setString(23, bean.getAddr().trim());
            pstmt.setString(24, bean.getMail_id().trim());
            pstmt.setString(25, bean.getLoan_st().trim());
            pstmt.setString(26, bean.getUser_work().trim());
            pstmt.setString(27, bean.getUser_i_tel().trim());
            pstmt.setString(28, bean.getFax_id().trim());
            pstmt.setString(29, bean.getFax_pw().trim());
            pstmt.setString(30, bean.getPartner_id().trim());
            pstmt.setString(31, bean.getI_fax().trim());
            pstmt.setString(32, bean.getVen_code().trim());
            pstmt.setString(33, bean.getGundea().trim());
            pstmt.setFloat (34, bean.getAdd_per());
			pstmt.setString(35, bean.getArea_id().trim());
            pstmt.setString(36, bean.getHome_zip().trim());
            pstmt.setString(37, bean.getHome_addr().trim());
            pstmt.setString(38, bean.getSa_code().trim());	//영업사원코드 추가(20181105)

			pstmt.setString(39, bean.getUser_id().trim());
			
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
     * 비밀번호 수정.
     */
    public int updatePass(String user_id, String user_psd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE USERS SET USER_PSD=text_encrypt(?, 'pw') , END_DT=to_char(add_months(sysdate,12),'YYYYMMDD')\n"
            + "WHERE USER_ID=?";
 
       try{
            con.setAutoCommit(false);
            
           
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(2, user_id.trim());
            pstmt.setString(1, user_psd.trim());
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
     * 퇴사처리
     */
    public int updateUserOut(UsersBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query=" UPDATE USERS SET USE_YN='N', dept_out=?, dept_id='9999', out_dt=replace(?,',','') \n"
            + " WHERE USER_ID=? ";
 
       try{
            con.setAutoCommit(false);
            
           
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getDept_id());            
            pstmt.setString(2, bean.getOut_dt());
            pstmt.setString(3, bean.getUser_id());
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
     * 지점 등록.
     */
    public int insertBranch(BranchBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String br_id = "";
        int count = 0;
               
        query="INSERT INTO BRANCH(BR_ID,\n"
								+ "BR_ENT_NO,\n"
								+ "BR_NM,\n"
								+ "BR_ST_DT,\n"
								+ "BR_POST,\n"
								+ "BR_ADDR,\n"
								+ "BR_ITEM,\n"
								+ "BR_STA,\n"
								+ "BR_TAX_O,\n"
								+ "BR_OWN_NM)\n"
            + "values(?,?,?,replace(?,'-',''),?,?,?,?,?,?)";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
            br_id = bean.getBr_id().trim();
            pstmt.setString(1, br_id);
            pstmt.setString(2, bean.getBr_ent_no().trim());
            pstmt.setString(3, bean.getBr_nm().trim());
            pstmt.setString(4, bean.getBr_st_dt().trim());
            pstmt.setString(5, bean.getBr_post().trim());
            pstmt.setString(6, bean.getBr_addr().trim());
            pstmt.setString(7, bean.getBr_item().trim());
            pstmt.setString(8, bean.getBr_sta().trim());
            pstmt.setString(9, bean.getBr_tax_o().trim());
            pstmt.setString(10, bean.getBr_own_nm().trim());
            
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
     * 부서 등록.
     */
    public int insertDept(DeptBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="INSERT INTO CODE(C_ST,\n"
								+ "CODE,\n"
								+ "NM_CD,\n"
								+ "NM)\n"
            + "SELECT '0002',nvl(lpad(max(CODE)+1,4,'0'),'0001'),?,?\n"
            + "FROM CODE\n"
            + "WHERE C_ST='0002'\n";
            
       try{
            con.setAutoCommit(false);
            
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getNm().trim());
            pstmt.setString(2, bean.getNm().trim());
           
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
     * 메뉴 등록.
     */
    public int insertMenu(MenuBean bean, String arg) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String arg1 = "";
        int count = 0;
                
        if(arg.equals("b"))
        {
	        query="INSERT INTO Menu(M_ST,\n"
									+ "M_CD,\n"
									+ "M_NM,\n"
									+ "URL,\n"
									+ "NOTE,\n"
									+ "SEQ)\n"
	            + "SELECT nvl(lpad(max(M_ST)+1,2,'0'),'01'),?,?,?,?,?\n"
	            + "FROM MENU\n"
	            + "WHERE M_CD=?\n";
	        arg1 = "00";
         }else if(arg.equals("s")){
         		query="INSERT INTO Menu(M_ST,\n"
									+ "M_CD,\n"
									+ "M_NM,\n"
									+ "URL,\n"
									+ "NOTE,\n"
									+ "SEQ)\n"
	            + "SELECT ?,nvl(lpad(max(M_CD)+1,2,'0'),'01'),?,?,?,?\n"
	            + "FROM MENU\n"
	            + "WHERE M_ST=?\n";
	        arg1 = bean.getM_st().trim();
	     }

       try{
            con.setAutoCommit(false);
            
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, arg1);
            pstmt.setString(2, bean.getM_nm().trim());
            pstmt.setString(3, bean.getUrl().trim());
            pstmt.setString(4, bean.getNote().trim()); 
            pstmt.setInt(5, bean.getSeq());
            pstmt.setString(6, arg1);
           
           
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
     * 서브 메뉴 등록.
     */
    public int insertSubMenu(MenuBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
       
 		query="INSERT INTO SUB_M(M_ST,\n"
							+ "M_CD,\n"
							+ "SEQ_NO,\n"
							+ "SM_NM)\n"
        + "SELECT ?,?,nvl(max(SEQ_NO)+1,'1'),?\n"
        + "FROM SUB_M\n"
        + "WHERE M_ST=?\n"
        + "AND M_CD=?\n";


       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getM_st().trim());
            pstmt.setString(2, bean.getM_cd().trim());
            pstmt.setString(3, bean.getSm_nm().trim());
            pstmt.setString(4, bean.getM_st().trim());
            pstmt.setString(5, bean.getM_cd().trim());
           
           
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
     * 메뉴 수정.
     */
    public int updateMenu(MenuBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String m_st = "";
        String m_cd = "";
        int count = 0;
                
        
 		query="UPDATE Menu\n"
			+ "SET M_NM=?,\n"
				+ "URL=?,\n"
				+ "NOTE=?,\n"
				+ "SEQ=?\n"
	        + "WHERE M_ST=?\n"
	        + "AND M_CD=?";
        m_st = bean.getM_st().trim();
        m_cd = bean.getM_cd().trim();
	   

       try{
            con.setAutoCommit(false);
            
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getM_nm().trim());
            pstmt.setString(2, bean.getUrl().trim());
            pstmt.setString(3, bean.getNote().trim()); 
            pstmt.setInt(4, bean.getSeq());
            pstmt.setString(5, m_st);
            pstmt.setString(6, m_cd);
           
           
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
     * 서브 메뉴 수정.
     */
    public int updateSubMenu(MenuBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE SUB_M\n"
		        + "SET SM_NM=?\n"
		        + "WHERE M_ST=?\n"
		        + "AND M_CD=?\n"
		        + "AND SEQ_NO=?\n";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getSm_nm().trim());
            pstmt.setString(2, bean.getM_st().trim());
            pstmt.setString(3, bean.getM_cd().trim()); 
            pstmt.setInt(4, bean.getSeq_no());
           
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
     * 부서 수정.
     */
    public int updateDept(DeptBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE CODE\n"
        	+ "SET NM_CD=?,\n"
				+ "NM=?\n"
            + "WHERE C_ST='0002'\n"
            + "AND CODE=?";
            
       try{
            con.setAutoCommit(false);
            
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getNm().trim());
            pstmt.setString(2, bean.getNm().trim());
            pstmt.setString(3, bean.getCode().trim());
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
     * 지점 수정.
     */
    public String updateBranch(BranchBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String br_id = "";
        int count = 0;
               
        query="UPDATE BRANCH\n"
        	+ "SET BR_ENT_NO=?,\n"
				+ "BR_NM=?,\n"
				+ "BR_ST_DT=replace(?,'-',''),\n"
				+ "BR_POST=?,\n"
				+ "BR_ADDR=?,\n"
				+ "BR_ITEM=?,\n"
				+ "BR_STA=?,\n"
				+ "BR_TAX_O=?,\n"
				+ "BR_OWN_NM=?\n"
            + "WHERE BR_ID=?";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
            br_id = bean.getBr_id().trim();
            
            pstmt.setString(1, bean.getBr_ent_no().trim());
            pstmt.setString(2, bean.getBr_nm().trim());
            pstmt.setString(3, bean.getBr_st_dt().trim());
            pstmt.setString(4, bean.getBr_post().trim());
            pstmt.setString(5, bean.getBr_addr().trim());
            pstmt.setString(6, bean.getBr_item().trim());
            pstmt.setString(7, bean.getBr_sta().trim());
            pstmt.setString(8, bean.getBr_tax_o().trim());
            pstmt.setString(9, bean.getBr_own_nm().trim());
            pstmt.setString(10, br_id);
            
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
        return br_id;
    }
    /**
     * 권한등록(삭제후 등록한다.).
     */
     
    public void insertAuth(String user_id, String m_st, Vector v) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        int countD = 0;
        int countI = 0;
        String query1 = "delete us_me"
                             +" where user_id=?"
                             +" and m_st=?";

        String query2 = "insert into us_me(USER_ID,\n"
        								+ "M_ST,\n"
        								+ "M_CD,\n"
        								+ "AUTH_RW)\n"
                         +" values(?,?,?,'W')";
        try{
            con.setAutoCommit(false);
            /** 권한부여하기전에 먼저 삭제한다. */
            pstmt1 = con.prepareStatement(query1);
           
            pstmt1.setString(1, user_id.trim());
            pstmt1.setString(2, m_st.trim());
            countD = pstmt1.executeUpdate();

            /** 권한부여한다. */ 
   
            pstmt2 = con.prepareStatement(query2);
            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt2.setString(1, user_id.trim());
                pstmt2.setString(2, m_st.trim());
                pstmt2.setString(3, val[0].trim());
                countI = pstmt2.executeUpdate();
            }
            pstmt1.close();
            pstmt2.close();
            con.commit();
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }
    /**
     * 서브 메뉴 삭제
     */
    public int deleteSubMenu(String m_st, String m_cd, Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="DELETE SUB_M WHERE M_ST=? AND M_CD=? AND SEQ_NO=?\n";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            for(int i=0; i<v.size(); i++){
                int val [] = (int [])v.elementAt(i);

                pstmt.setString(1, m_st.trim());
                pstmt.setString(2, m_cd.trim());
                pstmt.setInt(3, val[0]);
                count = pstmt.executeUpdate();
                
            }
             
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
     * 서브 메뉴 삭제
     */
    public int deleteSMenu(String m_st, Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="DELETE MENU WHERE M_ST=? AND M_CD=?\n";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt.setString(1, m_st.trim());
                pstmt.setString(2, val[0].trim());
                count = pstmt.executeUpdate();
                
            }
             
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
     * 서브 메뉴 삭제
     */
    public int deleteBMenu(Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="DELETE MENU WHERE M_ST=?\n";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt.setString(1, val[0].trim());
                count = pstmt.executeUpdate();
            }
             
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
     * 사원코드 조회
     */
    public String getSaCode(String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sa_code = "";
        
        String query = "";
        
        query = "SELECT sa_code FROM USERS WHERE ID='" + user_id + "'";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            if(rs.next())
                sa_code = rs.getString("sa_code");

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
        return sa_code;
    }

	//NEW FMS 메뉴관리---------------------------------------------------------------------------------------------------------------

    /**
     * 메뉴 전체 조회.
     */
    public MenuBean [] getMaMenuAll(String m_st, String m_st2, String arg) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        if(arg.equals("b"))//대메뉴
        {
	        query = "SELECT a.M_ST,a.M_ST2,\n"
	        				+ "a.M_CD,\n"
	                		+ "a.M_NM,\n"
	                		+ "a.URL,\n"
	                		+ "a.SEQ,\n"
	                		+ "a.NOTE, a.BASE\n"
	        		+ "FROM MA_MENU a\n"
	        		+ "where m_st like '%%'\n"
	        		+ "and m_st2 = '00' and m_cd = '00'\n"
	        		+ "order by a.SEQ";
        }else if(arg.equals("m")){//중메뉴
	        query = "SELECT a.M_ST,a.M_ST2,\n"
	        				+ "a.M_CD,\n"
	                		+ "a.M_NM,\n"
	                		+ "a.URL,\n"
	                		+ "a.SEQ,\n"
	                		+ "a.NOTE, a.BASE\n"
	        		+ "FROM MA_MENU a\n"
	        		+ "where m_st like '%" + m_st + "%'\n"
	        		+ "and m_st2 <> '00' and m_cd = '00'\n"
	        		+ "order by a.M_ST, a.SEQ";
        }else if(arg.equals("s")){//소메뉴
	        query = "SELECT a.M_ST,a.M_ST2,\n"
	        				+ "a.M_CD,\n"
	                		+ "a.M_NM,\n"
	                		+ "a.URL,\n"
	                		+ "a.SEQ,\n"
	                		+ "a.NOTE, a.BASE\n"
	        		+ "FROM MA_MENU a\n"
	        		+ "where m_st like '%" + m_st + "%' and m_st2 like '%" + m_st2 + "%' \n"
	        		+ "and m_st2 <> '00' and m_cd <> '00'\n"
	        		+ "order by a.M_ST, a.M_ST2, a.SEQ";
	    }

        Collection<MenuBean> col = new ArrayList<MenuBean>();
        try{
            pstmt = con.prepareStatement(query);
            
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeMaMenuBean(rs, "menu"));
 
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
        return (MenuBean[])col.toArray(new MenuBean[0]);
    }
    /**
     * 메뉴 등록.
     */
    public int insertMaMenu(MenuBean bean, String arg) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String arg1 = "";
        String arg2 = "";
        int count = 0;
                
        if(arg.equals("b"))
        {
	        query="INSERT INTO MA_MENU (M_ST,M_ST2,\n"
									+ "M_CD,\n"
									+ "M_NM,\n"
									+ "URL,\n"
									+ "NOTE,\n"
									+ "SEQ, BASE)\n"
	            + "SELECT nvl(lpad(max(M_ST)+1,2,'0'),'01'),?,?,?,?,?,?,?\n"
	            + "FROM MA_MENU\n"
	            + "WHERE M_ST<>'99' and M_ST2=? and M_CD=?\n";
	        arg1 = "00";
	        arg2 = "00";
         }else if(arg.equals("m")){
         		query="INSERT INTO MA_MENU (M_ST,M_ST2,\n"
									+ "M_CD,\n"
									+ "M_NM,\n"
									+ "URL,\n"
									+ "NOTE,\n"
									+ "SEQ, BASE)\n"
	            + "SELECT ?,nvl(lpad(max(M_ST2)+1,2,'0'),'01'),?,?,?,?,?,?\n"
	            + "FROM MA_MENU\n"
	            + "WHERE M_ST=? and M_CD=?\n";
	        arg1 = bean.getM_st().trim();
	        arg2 = "00";
         }else if(arg.equals("s")){
         		query="INSERT INTO MA_MENU (M_ST,M_ST2,\n"
									+ "M_CD,\n"
									+ "M_NM,\n"
									+ "URL,\n"
									+ "NOTE,\n"
									+ "SEQ, BASE)\n"
	            + "SELECT ?,?,nvl(lpad(max(M_CD)+1,2,'0'),'01'),?,?,?,?,?\n"
	            + "FROM MA_MENU\n"
	            + "WHERE M_ST=? and m_st2=?\n";
	        arg1 = bean.getM_st().trim();
	        arg2 = bean.getM_st2().trim();
	     }

       try{
            con.setAutoCommit(false);
            
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, arg1);
            pstmt.setString(2, arg2);
            pstmt.setString(3, bean.getM_nm().trim());
            pstmt.setString(4, bean.getUrl().trim());
            pstmt.setString(5, bean.getNote().trim()); 
            pstmt.setInt   (6, bean.getSeq());
            pstmt.setString(7, bean.getBase());
            pstmt.setString(8, arg1);
            pstmt.setString(9, arg2);
           
           
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
     * 메뉴 수정.
     */
    public int updateMaMenu(MenuBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String m_st = "";
        String m_st2 = "";
        String m_cd = "";
        int count = 0;
                
        
 		query="UPDATE MA_Menu\n"
			+ "SET M_NM=?,\n"
				+ "URL=?,\n"
				+ "NOTE=?,\n"
				+ "SEQ=?, BASE=?\n"
	        + "WHERE M_ST=? and M_ST2=?\n"
	        + "AND M_CD=?";

        m_st	= bean.getM_st().trim();
        m_st2	= bean.getM_st2().trim();
        m_cd	= bean.getM_cd().trim();
	   

       try{
            con.setAutoCommit(false);
            
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getM_nm().trim());
            pstmt.setString(2, bean.getUrl().trim());
            pstmt.setString(3, bean.getNote().trim()); 
            pstmt.setInt(4, bean.getSeq());
            pstmt.setString(5, bean.getBase().trim()); 
            pstmt.setString(6, m_st);
            pstmt.setString(7, m_st2);
            pstmt.setString(8, m_cd);
           
           
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
     * 서브 메뉴 삭제
     */
    public int deleteBMaMenu(Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="DELETE MA_MENU WHERE M_ST=?\n";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt.setString(1, val[0].trim());
                count = pstmt.executeUpdate();
            }
             
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
     * 서브 메뉴 삭제
     */
    public int deleteMMaMenu(String m_st, Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="DELETE MA_MENU WHERE M_ST=? AND M_ST2=?\n";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt.setString(1, m_st.trim());
                pstmt.setString(2, val[0].trim());
                count = pstmt.executeUpdate();
                
            }
             
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
     * 서브 메뉴 삭제
     */
    public int deleteSMaMenu(String m_st, String m_st2, Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="DELETE MA_MENU WHERE M_ST=? AND M_ST2=? AND M_CD=?\n";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt.setString(1, m_st.trim());
                pstmt.setString(2, m_st2.trim());
                pstmt.setString(3, val[0].trim());
                count = pstmt.executeUpdate();
                
            }
             
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
     * 권한 전체 조회 - 사용자 권한 등록시 사용
     */
    public AuthBean [] getAuthMaAll(String user_id, String m_st, String m_st2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " SELECT a.M_ST, a.M_ST2, a.M_CD, a.M_NM, a.URL, nvl(b.auth_rw,'0')  as auth_rw \n"+
				" FROM\n"+
					"(SELECT * FROM ma_menu WHERE m_st='"+m_st.trim()+"' and m_st2='" +m_st2.trim() + "' and m_cd <> '00') a,\n"+
					"(SELECT * FROM us_ma_me WHERE user_id='"+user_id.trim()+"' and m_st='"+m_st.trim()+ "' and m_st2 = '"+ m_st2.trim() + "' ) b\n"+
				" WHERE a.m_cd=b.m_cd(+)  ORDER BY a.seq";

//		System.out.println("a=" + query);
        Collection<AuthBean> col = new ArrayList<AuthBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeAuthBean(rs));
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			//System.out.println("[UserMngDatabase:getAuthMaAll]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (AuthBean[])col.toArray(new AuthBean[0]);
    }

	/**
     * 권한 전체 조회 - login 후 개인별 2 depth 메뉴 display
     */
    public AuthBean [] getAuthMaMeAll(String user_id, String m_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        
      
      /*  
        query = " SELECT   a.M_ST, a.M_ST2, min(a.M_CD) as M_CD , a.M_NM, a.URL,  min(nvl(b.auth_rw,'0')) as auth_rw  \n"+
				" FROM \n"+
				"	(SELECT m_st, m_st2, m_cd , m_nm, url FROM ma_menu WHERE m_st='"+m_st.trim()+"' and m_st2 <> '00' and m_cd ='00') a, \n"+
				"	(SELECT m_st, m_st2, min(m_cd), max(auth_rw) as auth_rw  FROM us_ma_me WHERE user_id='"+user_id.trim()+"' and m_st='"+m_st.trim()+ "' and m_st2 <>'00' group by m_st, m_st2  ) b \n"+
				"  WHERE a.m_st=b.m_st and a.m_st2 = b.m_st2 and  nvl(b.auth_rw, '0') <> '0' group by a.m_st, a.m_st2, a.m_nm, a.url ORDER BY a.m_st2";
		      
      */
        query = "  SELECT  a.M_ST, a.M_ST2, b.M_CD as M_CD , a.M_NM, b.url, b.auth_rw \n"+
	   			"  FROM \n"+
				"  ( SELECT m_st, m_st2, m_cd , m_nm, url, seq FROM ma_menu WHERE m_st='"+m_st.trim()+ "'  and m_st2 <> '00' and m_cd ='00') a, \n"+
				"  ( SELECT a.m_st, a.m_st2, a.m_cd, a.auth_rw , b.url  FROM us_ma_me a, ma_menu b  WHERE a.user_id='"+user_id.trim()+"' and a.m_st='"+m_st.trim()+ "' and a.m_st2 <>'00' and a.m_st = b.m_st and a.m_st2 = b.m_st2 and a.m_cd = b.m_cd  and nvl(a.auth_rw, '0' ) <> '0'  ) b , \n"+
				"  ( SELECT a.m_st, a.m_st2, min(a.m_cd) as m_cd   FROM us_ma_me a  WHERE a. user_id='"+user_id.trim()+"'  and a.m_st='"+m_st.trim()+ "' and a.m_st2 <>'00'  and nvl(a.auth_rw, '0' ) <> '0'  group by a.m_st, a.m_st2 ) c \n"+
	   			"   WHERE a.m_st= b.m_st and a.m_st2 = b.m_st2 and a.m_st = c.m_st and a.m_st2 = c.m_st2 and b.m_cd = c.m_cd    order by a.seq, 1, 2, 3  ";
		
        Collection<AuthBean> col = new ArrayList<AuthBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeAuthBean(rs));
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			//System.out.println("[UserMngDatabase:getAuthMaMeAll]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (AuthBean[])col.toArray(new AuthBean[0]);
    }
    
    /**
     * 권한 전체 조회 - login 후 개인별 2 depth 메뉴 display vector
     */
      public Vector getAuthMaMeAll1(String user_id, String m_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        Vector vt = new Vector();
      
      /*  
        query = " SELECT   a.M_ST, a.M_ST2, min(a.M_CD) as M_CD , a.M_NM, a.URL,  min(nvl(b.auth_rw,'0')) as auth_rw  \n"+
				" FROM \n"+
				"	(SELECT m_st, m_st2, m_cd , m_nm, url FROM ma_menu WHERE m_st='"+m_st.trim()+"' and m_st2 <> '00' and m_cd ='00') a, \n"+
				"	(SELECT m_st, m_st2, min(m_cd), max(auth_rw) as auth_rw  FROM us_ma_me WHERE user_id='"+user_id.trim()+"' and m_st='"+m_st.trim()+ "' and m_st2 <>'00' group by m_st, m_st2  ) b \n"+
				"  WHERE a.m_st=b.m_st and a.m_st2 = b.m_st2 and  nvl(b.auth_rw, '0') <> '0' group by a.m_st, a.m_st2, a.m_nm, a.url ORDER BY a.m_st2";
		      
     
        query = "  SELECT  a.M_ST, a.M_ST2, b.M_CD as M_CD , a.M_NM, b.url, b.auth_rw \n"+
	   			"  FROM \n"+
				"  ( SELECT m_st, m_st2, m_cd , m_nm, url, seq FROM ma_menu WHERE m_st='"+m_st.trim()+ "'  and m_st2 <> '00' and m_cd ='00') a, \n"+
				"  ( SELECT a.m_st, a.m_st2, a.m_cd, a.auth_rw , b.url  FROM us_ma_me a, ma_menu b  WHERE a.user_id='"+user_id.trim()+"' and a.m_st='"+m_st.trim()+ "' and a.m_st2 <>'00' and a.m_st = b.m_st and a.m_st2 = b.m_st2 and a.m_cd = b.m_cd  and nvl(a.auth_rw, '0' ) <> '0'  ) b , \n"+
				"  ( SELECT a.m_st, a.m_st2, min(a.m_cd) as m_cd   FROM us_ma_me a  WHERE a. user_id='"+user_id.trim()+"'  and a.m_st='"+m_st.trim()+ "' and a.m_st2 <>'00'  and nvl(a.auth_rw, '0' ) <> '0'  group by a.m_st, a.m_st2 ) c \n"+
	   			"   WHERE a.m_st= b.m_st and a.m_st2 = b.m_st2 and a.m_st = c.m_st and a.m_st2 = c.m_st2 and b.m_cd = c.m_cd    order by a.seq  ";//, 1, 2, 3
		
		 */

		 /** 2015. 04. 06 ywkim 중메뉴 전체 가져옴. 기존 쿼리중 권한, url 정보 삭제**/
        query = " SELECT  M_ST,  M_ST2,  M_CD ,  M_NM  ";
        query += " FROM ";
        query += "	( ";
        query += "		SELECT A.SEQ,  A.M_ST,  A.M_ST2,  B.M_CD ,  A.M_NM ";
        query += "		FROM  ";
        query += "			MA_MENU A, ";
        query += "			(";
        query += "				SELECT M_ST,  M_ST2,  MIN(m_cd) AS M_CD ";
        query += "				FROM US_MA_ME ";
        query += "				WHERE user_id = '"+user_id.trim()+"' ";
       // query += " 				AND m_st='05' "; 
        query += " 				AND m_st2 <>'00' "; 
        query += " 				AND nvl(auth_rw, '0' ) <> '0' "; 
        query += " 				GROUP BY M_ST, M_ST2 "; 
        query += "			) B ";
        query += "			WHERE A.M_ST = B.M_ST "; 
        query += "			AND A.M_ST2 = B.M_ST2 "; 
        query += "			AND A.M_CD = 00 ";  
        query += "	) T";
        query += "	ORDER BY M_ST, SEQ ";

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
      	return vt;
    }
    

	 /**
     * 권한 전체 조회 - login 후 개인별 2 depth 메뉴 display vector
     */
      public Vector getAuthMaMeAll2(String user_id, String m_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        Vector vt = new Vector();
      
      /*  
        query = " SELECT   a.M_ST, a.M_ST2, min(a.M_CD) as M_CD , a.M_NM, a.URL,  min(nvl(b.auth_rw,'0')) as auth_rw  \n"+
				" FROM \n"+
				"	(SELECT m_st, m_st2, m_cd , m_nm, url FROM ma_menu WHERE m_st='"+m_st.trim()+"' and m_st2 <> '00' and m_cd ='00') a, \n"+
				"	(SELECT m_st, m_st2, min(m_cd), max(auth_rw) as auth_rw  FROM us_ma_me WHERE user_id='"+user_id.trim()+"' and m_st='"+m_st.trim()+ "' and m_st2 <>'00' group by m_st, m_st2  ) b \n"+
				"  WHERE a.m_st=b.m_st and a.m_st2 = b.m_st2 and  nvl(b.auth_rw, '0') <> '0' group by a.m_st, a.m_st2, a.m_nm, a.url ORDER BY a.m_st2";
		      
      */
        query = "  SELECT  a.M_ST, a.M_ST2, b.M_CD as M_CD , a.M_NM, b.url, b.auth_rw \n"+
	   			"  FROM \n"+
				"  ( SELECT m_st, m_st2, m_cd , m_nm, url, seq FROM ma_menu WHERE m_st='"+m_st.trim()+ "'  and m_st2 <> '00' and m_cd ='00') a, \n"+
				"  ( SELECT a.m_st, a.m_st2, a.m_cd, a.auth_rw , b.url  FROM us_ma_me a, ma_menu b  WHERE a.user_id='"+user_id.trim()+"' and a.m_st='"+m_st.trim()+ "' and a.m_st2 <>'00' and a.m_st = b.m_st and a.m_st2 = b.m_st2 and a.m_cd = b.m_cd  and nvl(a.auth_rw, '0' ) <> '0'  ) b , \n"+
				"  ( SELECT a.m_st, a.m_st2, min(a.m_cd) as m_cd   FROM us_ma_me a  WHERE a. user_id='"+user_id.trim()+"'  and a.m_st='"+m_st.trim()+ "' and a.m_st2 <>'00'  and nvl(a.auth_rw, '0' ) <> '0'  group by a.m_st, a.m_st2 ) c \n"+
	   			"   WHERE a.m_st= b.m_st and a.m_st2 = b.m_st2 and a.m_st = c.m_st and a.m_st2 = c.m_st2 and b.m_cd = c.m_cd    order by a.seq  ";//, 1, 2, 3
		
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
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
      	return vt;
    }
    

    
	/**
     * 권한 전체 조회 - login 후 개인별 3 depth 메뉴 display
     */
    public AuthBean [] getAuthMaMeAll(String user_id, String m_st, String m_st2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " SELECT a.M_ST, a.M_ST2, a.M_CD, a.M_NM, a.URL, nvl(b.auth_rw,'0')  as auth_rw \n"+
				" FROM\n"+
					"(SELECT * FROM ma_menu WHERE m_st='"+m_st.trim()+"' and m_st2='" +m_st2.trim() + "' and m_cd <> '00') a,\n"+
					"(SELECT * FROM us_ma_me WHERE user_id='"+user_id.trim()+"' and m_st='"+m_st.trim()+ "' and m_st2 = '"+ m_st2.trim() + "' ) b\n"+
				" WHERE a.m_cd=b.m_cd and  nvl(b.auth_rw, '0') <> '0'  ORDER BY a.seq";

//		System.out.println("a=" + query);
        Collection<AuthBean> col = new ArrayList<AuthBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeAuthBean(rs));
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			//System.out.println("[UserMngDatabase:getAuthMaMeAll]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (AuthBean[])col.toArray(new AuthBean[0]);
    }
    
   /**
     * 권한등록(삭제후 등록한다.).
     */
    public void insertAuthMa(String user_id, String m_st, String m_st2, Vector v) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        int countD = 0;
        int countI = 0;
        String query1 = "delete us_ma_me"
                             +" where user_id=?"
                             +" and m_st=?"
                             +" and m_st2=?";

        String query2 = "insert into us_ma_me(USER_ID,\n"
        								+ "M_ST,\n"
        								+ "M_ST2,\n"
        								+ "M_CD,\n"
        								+ "AUTH_RW)\n"
                         +" values(?,?,?,?,?)";
        try{
            con.setAutoCommit(false);
            /** 권한부여하기전에 먼저 삭제한다. */
            pstmt1 = con.prepareStatement(query1);
           
            pstmt1.setString(1, user_id.trim());
            pstmt1.setString(2, m_st.trim());
            pstmt1.setString(3, m_st2.trim());
            countD = pstmt1.executeUpdate();

            /** 권한부여한다. */ 
   
            pstmt2 = con.prepareStatement(query2);
            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt2.setString(1, user_id.trim());
                pstmt2.setString(2, m_st.trim());
                pstmt2.setString(3, m_st2.trim());
                pstmt2.setString(4, val[0].substring(0,2));
                pstmt2.setString(5, val[0].substring(2,3));
                
           //     pstmt2.setString(4, val[0].trim());
                countI = pstmt2.executeUpdate();
            }
            pstmt1.close();
            pstmt2.close();
            con.commit();
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

	//메뉴별 권한 조회 
	public String getMaMenuAuth(String user_id, String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String authrw = "";
        
		query = " SELECT auth_rw FROM us_ma_me WHERE user_id = '" + user_id + "' AND m_st='"+m_st+"' AND m_st2='"+m_st2+"' AND m_cd='"+m_cd+"'";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

  			if(rs.next())
                authrw = rs.getString("auth_rw");
                
		    rs.close();
            stmt.close();
        }catch(SQLException se){
        	 //System.out.println("[UserMngDatabase:getMaMenuAuth]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return authrw;
    }
     
	//사용자 권한 복사 

	public boolean deleteAuthCopy(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
            
		query = " DELETE from us_ma_me where user_id = '"+ user_id + "'";

		
		try {
			pstmt = con.prepareStatement(query);
			pstmt.executeUpdate();
		
		    pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
                flag = false;
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
       return flag;
    }
    	
    	//메뉴별 권한 조회 
	public Vector  getUserAuth(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String authrw = "0";
        Vector vt = new Vector();
        	
		query = " SELECT * FROM us_ma_me WHERE user_id = '" + user_id +"'";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
            stmt.close();
        }catch(SQLException se){
			//System.out.println("[UserMngDatabase:getUserAuth]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
      return vt;
    }
    
   public boolean insertAuthCopy(AuthBean bean) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
			
		query = " INSERT INTO us_ma_me ("+
				"	user_id,				"+
				"	m_st,				"+
				"	m_st2,			"+
				"	m_cd,			"+
				"	auth_rw         "+
				" ) VALUES "+ 
				" ( ?, ?, ?, ?, ? "+
				" )";

		try 
		{

			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getUser_id				());
			pstmt.setString	(2,		bean.getM_st				());
			pstmt.setString	(3,		bean.getM_st2			());
			pstmt.setString	(4,		bean.getM_cd			());
			pstmt.setString	(5,		bean.getAuth_rw		());
	
			pstmt.executeUpdate();
			
	    	pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
                flag = false;
                //System.out.println("[UserMngDatabase:getUserAuth]"+se);
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
       return flag;
    }

   public boolean updateMenuBaseAuth(String m_st, String m_st2, String m_cd, String user_id, String auth_rw) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
			
		query = " update us_ma_me set auth_rw=? where"+
				"	    user_id	=?		"+
				"	and m_st	=?		"+
				"	and m_st2	=?		"+
				"	and m_cd	=?		";

		try 
		{

			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		auth_rw	);
			pstmt.setString	(2,		user_id	);
			pstmt.setString	(3,		m_st	);
			pstmt.setString	(4,		m_st2	);
			pstmt.setString	(5,		m_cd	);
			pstmt.executeUpdate();
			
	    	pstmt.close();
            con.commit();
//System.out.println(query+" "+user_id+" "+auth_rw);
        }catch(SQLException se){
            try{
                con.rollback();
                flag = false;
                //System.out.println("[UserMngDatabase:updateMenuBaseAuth]"+se);
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
       return flag;
    }

   public boolean setMenuBaseAuth(String m_st, String m_st2, String m_cd, String user_id, String auth_rw) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
			
		query = " INSERT INTO us_ma_me ("+
				"	user_id,				"+
				"	m_st,				"+
				"	m_st2,			"+
				"	m_cd,			"+
				"	auth_rw         "+
				" ) VALUES "+ 
				" ( ?, ?, ?, ?, ? "+
				" )";

		try 
		{

			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		user_id	);
			pstmt.setString	(2,		m_st	);
			pstmt.setString	(3,		m_st2	);
			pstmt.setString	(4,		m_cd	);
			pstmt.setString	(5,		auth_rw	);
	
			pstmt.executeUpdate();
			
	    	pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
                flag = false;
                //System.out.println("[UserMngDatabase:setMenuBaseAuth]"+se);
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
       return flag;
    }

    //보아메일 비밀번호 조회
	public String  getVoaMailPswd(String mail_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String authrw = "0";
        String pswd = "";
        	
		query = " select passwd from mail_mng where userid = '" + mail_id +"'";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
          	if(rs.next())
			{				
				pswd = rs.getString(1);
			}
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			//System.out.println("[UserMngDatabase:getUserAuth]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
      return pswd;
    }

    /**
     * 사용자 조회
     */    
    public UsersBean getUserNmBean(String user_nm) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        UsersBean umb = new UsersBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = " SELECT a.USER_ID,a.BR_ID,b.BR_NM,a.USER_NM,a.ID,a.USER_PSD,a.USER_CD,text_decrypt(a.user_ssn, 'pw') USER_SSN,a.DEPT_ID,c.NM AS DEPT_NM, \n"+
				"        a.USER_H_TEL,a.USER_M_TEL,a.IN_TEL,a.HOT_TEL,a.USER_EMAIL,a.USER_POS,a.USER_AUT,a.LIC_NO,a.LIC_DT, nvl(a.ENTER_DT,'99999999') enter_dt, \n"+
				"        a.content,a.filename,a.filename2,a.zip,a.addr, a.mail_id, d.passwd as mail_pw, \n"+
				"        a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax,a.taste, a.special, a.ven_code, \n"+
				"        a.gundea, a.bank_nm, a.bank_no, a.add_per, a.area_id, e.nm as area_nm, a.home_zip, a.home_addr, a.user_job, a.agent_cont_view, a.ars_group  \n"
        		+ "FROM  USERS a, BRANCH b, CODE c, mail_mng d, (select * from code where c_st='0029') e \n"
        		+ "where a.user_nm='" + user_nm +"' and (a.user_nm='이의상' or a.dept_id not in ('8888','1000')) and a.BR_ID = b.BR_ID and c.C_ST = '0002' and c.CODE = a.DEPT_ID and a.mail_id=d.userid(+) and a.area_id=e.code(+) \n"
				+ "order by a.use_yn desc ";



        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            if (rs.next())
                umb = makeUserBean(rs);
            
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

        return umb;
    }
    
    /**
     * 사용자 조회
     */    
    public UsersBean getUserNmBusBean(String user_nm) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        UsersBean umb = new UsersBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = " SELECT a.USER_ID,a.BR_ID,b.BR_NM,a.USER_NM,a.ID,a.USER_PSD,a.USER_CD,text_decrypt(a.user_ssn, 'pw') USER_SSN,a.DEPT_ID,c.NM AS DEPT_NM, \n"+
				"        a.USER_H_TEL,a.USER_M_TEL,a.IN_TEL,a.HOT_TEL,a.USER_EMAIL,a.USER_POS,a.USER_AUT,a.LIC_NO,a.LIC_DT, nvl(a.ENTER_DT,'99999999') enter_dt, \n"+
				"        a.content,a.filename,a.filename2,a.zip,a.addr, a.mail_id, d.passwd as mail_pw, \n"+
				"        a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax,a.taste, a.special, a.ven_code, \n"+
				"        a.gundea, a.bank_nm, a.bank_no, a.add_per, a.area_id, e.nm as area_nm, a.home_zip, a.home_addr, a.user_job, a.agent_cont_view, a.ars_group  \n"
        		+ "FROM  USERS a, BRANCH b, CODE c, mail_mng d, (select * from code where c_st='0029') e \n"
        		+ "where a.user_nm='" + user_nm +"' and (a.loan_st is not null or a.dept_id='1000') and a.BR_ID = b.BR_ID and c.C_ST = '0002' and c.CODE = a.DEPT_ID and a.mail_id=d.userid(+) and a.area_id=e.code(+) \n"
				+ "order by a.use_yn desc ";



        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            if (rs.next())
                umb = makeUserBean(rs);
            
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

        return umb;
    }    

    /**
     * 사용자 전체 조회.
     */
    public UsersBean [] getUserAuthAll(String br_id, String dept_id, String user_nm, String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "a.ID,\n"
        				+ "a.USER_PSD,\n"
        				+ "a.USER_CD,\n"
        				+ "a.USER_SSN,\n"
        				+ "a.DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_H_TEL,\n"
        				+ "a.USER_M_TEL,\n"
						+ "a.IN_TEL,\n"
						+ "a.HOT_TEL,\n"
        				+ "a.USER_EMAIL,\n"
        				+ "a.USER_POS,\n"
        				+ "a.LIC_NO, a.LIC_DT, a.ENTER_DT, a.content, a.filename, a.filename2, a.zip, a.addr, d.userid as mail_id, d.passwd as mail_pw,\n"
						+ "a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax, a.taste, a.special, a.ven_code, \n"
						+ "e.auth_rw as USER_AUT, a.gundea, a.bank_nm, a.bank_no, a.add_per, a.area_id, f.nm as area_nm, a.home_zip, a.home_addr , '' age, '' sch_chk, a.user_job, a.agent_cont_view, a.ars_group \n"
        		+ " FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d, \n"
				+ "		(select * from us_ma_me where m_st='"+m_st+"' and m_st2='"+m_st2+"' and m_cd='"+m_cd+"') e, (select * from code where c_st='0029') f \n"
        		+ " where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) \n"
        		+ " and a.DEPT_ID = c.CODE(+) \n"
        		+ " and a.user_id = e.user_id(+) and a.area_id=f.code(+) \n"
				+ " ";

		if(!dept_id.equals("9999")) query += "  and nvl(a.use_yn,'Y')='Y'";
		else						query += "  and nvl(a.use_yn,'Y')='N'";

		if(!br_id.equals(""))	query += " and a.BR_ID like '%" + br_id + "%'";
		if(!user_nm.equals("")) query += " and a.USER_NM like '%" + user_nm + "%'";

		if(!dept_id.equals("")){
			if(dept_id.equals("acar"))			query += " and a.DEPT_ID not in ('8888','1000','1999') ";
			else if(dept_id.equals("agent"))	query += " and a.DEPT_ID in ('1000') ";
			else if(dept_id.equals("out"))		query += " and a.DEPT_ID in ('8888','1999') ";
			else								query += " and a.DEPT_ID like '%" + dept_id + "%' ";
		}


		query += "order by decode(a.user_pos,'대표이사',1, '이사', 2, '부장', 3,'팀장', 4, 5), a.dept_id, decode(a.user_pos, '이사',1, '부장', 2, '팀장',3 , '차장', 4, '과장',5,'대리',6,7), a.user_id";


        Collection<UsersBean> col = new ArrayList<UsersBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeUserBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[UserMngDatabase:getUserAuthAll]"+se);
			System.out.println("[UserMngDatabase:getUserAuthAll]"+query);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (UsersBean[])col.toArray(new UsersBean[0]);
    }

   /**
     * 권한등록(삭제후 등록한다.).
     */
    public void insertAuthUserCase(String user_id, String m_st, String m_st2, String m_cd, String auth_rw) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        int countD = 0;
        int countI = 0;
        String query1 = "delete us_ma_me"
                             +" where user_id=?"
                             +" and m_st=?"
                             +" and m_st2=?"
                             +" and m_cd=?"
							 +" ";

        String query2 = "insert into us_ma_me (USER_ID,\n"
        								+ "M_ST,\n"
        								+ "M_ST2,\n"
        								+ "M_CD,\n"
        								+ "AUTH_RW)\n"
                         +" values(?,?,?,?,?)";
        try{
            con.setAutoCommit(false);

            /** 권한부여하기전에 먼저 삭제한다. */
            pstmt1 = con.prepareStatement(query1);
           
            pstmt1.setString(1, user_id.trim());
            pstmt1.setString(2, m_st.trim());
            pstmt1.setString(3, m_st2.trim());
            pstmt1.setString(4, m_cd.trim());
            countD = pstmt1.executeUpdate();
			pstmt1.close();

            /** 권한부여한다. */    
            pstmt2 = con.prepareStatement(query2);
            pstmt2.setString(1, user_id.trim());
            pstmt2.setString(2, m_st.trim());
            pstmt2.setString(3, m_st2.trim());
            pstmt2.setString(4, m_cd);
            pstmt2.setString(5, auth_rw);                
	        countI = pstmt2.executeUpdate();            
            pstmt2.close();

            con.commit();
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }
 	/**
     * 사용자아이디 조회.
     */
    public String getUserID(String user_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String id = "";
        
        String query = "";
        
        query = "SELECT USER_ID FROM USERS WHERE USER_NM='" + user_nm + "'";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            if(rs.next())
                id = rs.getString("USER_ID");

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
        return id;
    }
    
 	/**
     * 사용자아이디 조회.
     */
    public String getUserNm(String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String id = "";
        
        String query = "";
        
        query = "SELECT USER_NM FROM USERS WHERE USER_ID='" + user_id + "'";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            if(rs.next())
                id = rs.getString("USER_NM");

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
        return id;
    }    


  /**
     * 사용자 전체 조회.
     */
    public UsersBean [] getUserAll2(String br_id, String dept_id, String user_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "a.ID,\n"
        				+ "a.USER_PSD,\n"
        				+ "a.USER_CD,\n"
        				+ "a.USER_SSN,\n"
        				+ "a.DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_H_TEL,\n"
        				+ "a.USER_M_TEL,\n"
						+ "a.IN_TEL,\n"
						+ "a.HOT_TEL,\n"
        				+ "a.USER_EMAIL,\n"
        				+ "a.USER_POS,\n"
        				+ "a.USER_AUT, a.LIC_NO, a.LIC_DT, a.ENTER_DT, a.content, a.filename, a.filename2, a.zip, a.addr, d.userid as mail_id, d.passwd as mail_pw,\n"
						+ "a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax, a.taste, a.special, a.ven_code, \n"
						+ "a.gundea, a.bank_nm, a.bank_no, a.add_per, a.area_id, e.nm as area_nm, a.home_zip, a.home_addr, a.user_job, a.agent_cont_view, a.ars_group  \n"
        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d, (select * from code where c_st='0029') e \n"
        		+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) and a.dept_id not in ('8888') and a.user_id not in ('000035' ) \n"
        		+ "and a.DEPT_ID = c.CODE(+) and a.area_id=e.code(+) \n";

		if(!dept_id.equals("9999")) query += "  and nvl(a.use_yn,'Y')='Y'";
		else						query += "  and nvl(a.use_yn,'Y')='N'";

		if(!br_id.equals(""))	query += " and a.BR_ID like '%" + br_id + "%'";
		if(!dept_id.equals("")) query += " and a.DEPT_ID like '%" + dept_id + "%'";
		if(!user_nm.equals("")) query += " and a.USER_NM like '%" + user_nm + "%'";

// 원본		query += " order by a.br_id, a.DEPT_ID, a.enter_dt";
		query += "order by decode(a.user_pos,'대표이사',1,'이사', 2, '부장', 3,'팀장', 4, 5), a.dept_id, decode(a.user_pos, '차장', 1, '과장',2,'대리',3,4), a.user_id";


        Collection<UsersBean> col = new ArrayList<UsersBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeUserBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			//System.out.println("[UserMngDatabase:getUserAll]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (UsersBean[])col.toArray(new UsersBean[0]);
    }

    /**
     * 은행계좌관리
     */
    public int updateUserBank(UsersBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query=" UPDATE USERS SET bank_nm=?, bank_no=?, sa_code=?, ven_code=? WHERE USER_ID=? ";
 
       try{
            con.setAutoCommit(false);
            
           
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, bean.getBank_nm	());
            pstmt.setString(2, bean.getBank_no	());
            pstmt.setString(3, bean.getSa_code	());
            pstmt.setString(4, bean.getVen_code	());
            pstmt.setString(5, bean.getUser_id	());
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
     * 점심 파트너 등록
     */
    public void UdateUser_group(String full_id, String reg_id) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        int countI = 0;

		String query = " UPDATE USERS SET USER_GROUP = trim(USER_GROUP||'"+full_id.trim()+"' ) WHERE USER_ID = '"+reg_id.trim()+"' ";


//System.out.println("UdateUser_group: "+query);

        try{
            con.setAutoCommit(false);

           pstmt = con.prepareStatement(query);
//            pstmt.setString(1, full_id.trim());
//            pstmt.setString(2, reg_id.trim());
                      
	        countI = pstmt.executeUpdate();            
            pstmt.close();

            con.commit();
        }catch(SQLException se){
			System.out.println("[UserMngDatabase:UdateUser_group]"+se);
			System.out.println("[UserMngDatabase:UdateUser_group]"+query);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

	 /**
     * 점심 파트너 해제
     */
    public void UdateUser_group2(String del_id, String user_id) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        int countI = 0;

		
		String query = "update users set  user_group = replace(user_group, ?,'') where user_id = ? ";



        try{
            con.setAutoCommit(false);

           pstmt = con.prepareStatement(query);
            pstmt.setString(1, del_id.trim());
            pstmt.setString(2, user_id.trim());
                      
	        countI = pstmt.executeUpdate();            
            pstmt.close();

            con.commit();
        }catch(SQLException se){
			System.out.println("[UserMngDatabase:UdateUser_group2]"+se);
			System.out.println("[UserMngDatabase:UdateUser_group2]"+query);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

     /**
     * 권한 전체 조회 - login 후 개인별 2 depth 메뉴 display vector
     */
      public Vector getAuthMaMeAllOffBMenu(String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        Vector vt = new Vector();
      
        query = "   SELECT a.M_ST, b.M_ST2, b.m_cd, replace(a.M_NM,'외부-','') M_NM  "+
	   			"   FROM   "+
				"          ( SELECT m_st, m_st2, m_cd , m_nm, url, seq FROM ma_menu WHERE  m_st2 = '00' and m_cd ='00' AND m_st > '22' AND m_st<>'99') a, "+ //외부메뉴
    			"          ( SELECT a.m_st, MIN(a.m_st2) m_st2, MIN(a.m_cd) m_cd FROM us_ma_me a, ma_menu b  WHERE a.user_id='"+user_id+"' and  a.m_st2 <>'00' and a.m_st = b.m_st and a.m_st2 = b.m_st2 and a.m_cd = b.m_cd and nvl(a.auth_rw,'0')<>'0' GROUP BY a.m_st) b "+				   
	   			"   WHERE  a.m_st= b.m_st "+     
                "   order by a.seq  ";
		
    
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            
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
      	return vt;
    }


		/**
     * 권한 전체 조회 - login 후 개인별 3 depth 메뉴 display
     */
    public AuthBean [] getAuthMaMeAllOff(String user_id, String m_st, String m_st2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " SELECT a.M_ST, a.M_ST2, a.M_CD, a.M_NM, a.URL, nvl(b.auth_rw,'0')  as auth_rw \n"+
				" FROM\n"+
					"(SELECT * FROM ma_menu WHERE m_st between '23' and '37' and m_st='"+m_st.trim()+"' and m_st2='" +m_st2.trim() + "' and m_cd <> '00') a,\n"+
					"(SELECT * FROM us_ma_me WHERE m_st between '23' and '37' and user_id='"+user_id.trim()+"' and m_st='"+m_st.trim()+ "' and m_st2 = '"+ m_st2.trim() + "' ) b\n"+
				" WHERE a.m_cd=b.m_cd and  nvl(b.auth_rw, '0') <> '0'  ORDER BY a.seq";

//		System.out.println("a=" + query);
        Collection<AuthBean> col = new ArrayList<AuthBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeAuthBean(rs));
            }
            
            rs.close();
            stmt.close();
        }catch(SQLException se){
			//System.out.println("[UserMngDatabase:getAuthMaMeAll]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (AuthBean[])col.toArray(new AuthBean[0]);
    }

	 /**
     * 조직도  - 협력업체
     */
      public Vector getSawonList(String dept_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        Vector vt = new Vector();
      
        query = " select"+
				" b.br_nm as br_nm,"+
				" c.nm as  dept_nm,"+
//				" to_number(to_char(sysdate,'YYYY'))-to_number('19'||substr(a.user_ssn,0,2))+1 age, "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('19'||SUBSTR(text_decrypt(a.user_ssn, 'pw' ),1,6),'YYYYMMDD'))/12) age, "+
				" trunc(TO_NUMBER(sysdate-to_date(a.enter_dt,'YYYYMMDD'))/365,0) enter_age, "+
				" a.*"+
				" from users a, "+
				" (select * from branch) b, "+
				" (select * from code where c_st='0002') c, "+
				" (SELECT user_id, max(jg_dt) jg_dt FROM INSA_POS GROUP BY user_id) d  "+		
				" where a.use_yn='Y' and a.dept_id <> '8888'"+
				" and a.br_id=b.br_id and a.dept_id=c.code AND a.user_id=d.user_id(+)";
				
		//임원외모두
		if(dept_id.equals("0000")){
			query += " and a.dept_id in ('0001','0002','0003','0007','0005', '0008','0009','0010','0011', '0012','0013','0014','0015','0016')";

			query += " order by a.enter_dt, text_decrypt(a.user_ssn, 'pw' ) ";

		//부서인원
		}else{
			if(!dept_id.equals("")) query += " and a.dept_id='"+dept_id+"'";

			query += " order by decode(a.br_id,'S1',1,'B1',2,'D1',3),"+
					"          decode(a.dept_id,'0004',1,'0001',2,'0002',3,'0003',4),"+
					"          decode(a.user_pos, '이사', 0, '부장', 1,'팀장', 2, '차장', '3', '과장',4,'대리',5,'사원',6),"+
					"          nvl(d.jg_dt,a.enter_dt), a.enter_dt, text_decrypt(a.user_ssn, 'pw' ) ";
		}

//System.out.println("[AddUserMngDatabase:getSawonList]"+query);
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
                
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[AddUserMngDatabase:getSawonList]"+se);
			System.out.println("[AddUserMngDatabase:getSawonList]"+query);
			throw new DatabaseException();
        }finally{
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
     * 사용자 수정.
     */
    public int updateUserAgent(UsersBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String user_id = "";
        int count = 0;
                
        query="UPDATE USERS SET     USER_H_TEL	=?,\n"
								+ " USER_M_TEL	=?,\n"
								+ " IN_TEL		=?,\n"
								+ " HOT_TEL		=?,\n"
								+ " USER_POS	=?,\n"
								+ " USER_EMAIL	=?, "+
								  " zip=?, addr=?,\n"+
								  " user_work=?, i_fax=?  \n"
            + "WHERE USER_ID=?";
 
       try{
            con.setAutoCommit(false);
            
           
            pstmt = con.prepareStatement(query);

            
            pstmt.setString(1, bean.getUser_h_tel().trim());
            pstmt.setString(2, bean.getUser_m_tel().trim());
			pstmt.setString(3, bean.getIn_tel().trim());
			pstmt.setString(4, bean.getHot_tel().trim());
            pstmt.setString(5, bean.getUser_pos().trim());
            pstmt.setString(6, bean.getUser_email().trim());
            pstmt.setString(7, bean.getZip().trim());
            pstmt.setString(8, bean.getAddr().trim());
            pstmt.setString(9, bean.getUser_work().trim());
            pstmt.setString(10, bean.getI_fax().trim());
			pstmt.setString(11, bean.getUser_id().trim());
			
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

	
	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/
	
 /**
     * 사용자 전체 조회.
     */

    public UsersBean [] getSostel_UserList(String dept_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT \n"
						+ "a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "a.ID,\n"
        				+ "a.DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"        			
        				+ "a.USER_M_TEL, e2.save_folder filename2, e2.save_file as filename, \n"
						+ "a.IN_TEL,\n"
						+ "a.HOT_TEL,\n"        				
        				+ "a.USER_POS,\n"        			
						+ "decode(e.sch_chk,'3','연차','5','병가','9','포상휴가','7','공가','6','경조사','') sch_chk, a.loan_st "
        		+ "FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d, (select * from code where c_st='0029') f, \n"
				+ "     ( select start_year||start_mon||start_day dt, work_id, user_id, title, content, sch_chk, gj_ck from sch_prv where sch_chk in ('3','5','9','7','6') and start_year||start_mon||start_day=to_char(sysdate,'YYYYMMDD')) e, "
				+ "     ( SELECT * FROM  ACAR_ATTACH_FILE WHERE content_code = 'USERS' and content_seq like '%1' AND ISDELETED = 'N') e2, "
			    + "     (SELECT max(TO_NUMBER(seq)) AS seq,content_seq,isdeleted  FROM  ACAR_ATTACH_FILE WHERE content_code = 'USERS' and content_seq like '%1' AND ISDELETED = 'N' group BY content_seq,isdeleted) f2 "
        		+ "where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+)\n"
        		+ "and a.DEPT_ID = c.CODE(+)\n"
				+ "and a.user_id=e.user_id(+)  and a.area_id=f.code(+) AND a.user_id||'1' = e2.content_seq(+) AND e2.content_seq = f2.content_seq(+) AND e2.seq = f2.seq(+) ";

		if(!dept_id.equals("9999")) query += "  and nvl(a.use_yn,'Y')='Y'";
		else						query += "  and nvl(a.use_yn,'Y')='N'";

		if(dept_id.equals("0000")){//임원
			query += "  and a.user_pos in ('대표이사','이사') and a.dept_id not in ('1000')";

			query += "order by a.user_id";

		}else{

			if(!dept_id.equals("")) query += " and a.DEPT_ID like '%" + dept_id + "%'";

			query += "order by decode(a.user_pos,'대표이사',1,'이사', 2, '팀장', 3, 4), a.dept_id, a.area_id,  decode(a.user_id, '000237', '0', decode(a.user_pos,'팀장', 0,'부장',1,  '차장',2, '과장',3,'대리',4,5) ), a.user_id";

		}



        Collection<UsersBean> col = new ArrayList<UsersBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeSmartUserBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[UserMngDatabase:getSostel_UserList]"+se);
			System.out.println("[UserMngDatabase:getSostel_UserList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (UsersBean[])col.toArray(new UsersBean[0]);
    }

/**
     * 지점정보 조회
     */    
    public Hashtable getBranch(String br_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";

		query = " select * from branch where br_id='"+br_id+"' ";


        try {
            pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            
            rs.close();
            pstmt.close();

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }finally{
            try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }


 /**
     * 사용자 조회
     */    
    public UsersBean getPartnerUsersBean(String user_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        UsersBean umb = new UsersBean();

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = " SELECT a.USER_ID,a.BR_ID,b.BR_NM,a.USER_NM,a.ID,a.USER_PSD,a.USER_CD,text_decrypt(a.user_ssn, 'pw') USER_SSN,a.DEPT_ID,c.NM AS DEPT_NM,"+
				" a.USER_H_TEL,a.USER_M_TEL,a.IN_TEL,a.HOT_TEL,a.USER_EMAIL, a.USER_POS ,a.USER_AUT,a.LIC_NO,a.LIC_DT, nvl(a.ENTER_DT,'99999999') enter_dt,"+
				" a.content,a.filename,a.filename2,a.zip,a.addr, a.mail_id, d.passwd as mail_pw,  a.area_id, '' area_nm, a.home_zip, a.home_addr, a.user_job, a.agent_cont_view, a.ars_group, "+
				" a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax,a.taste, a.special, a.ven_code, a.gundea, '' bank_nm, '' bank_no, '' filename2, '' add_per \n"
        		+ "FROM USERS a, BRANCH b, CODE c, mail_mng d\n"
        		+ "where a.partner_id='" + user_id +"' and a.BR_ID = b.BR_ID and c.C_ST = '0002' and c.CODE = a.DEPT_ID and a.mail_id=d.userid(+)\n";



        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            if (rs.next())
                umb = makeUserBean(rs);
            
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

        return umb;
    }

	//XML-MENU 메뉴관리 201606 ---------------------------------------------------------------------------------------------------------------

    /**
     * 메뉴 전체 조회.
     */
    public MenuBean [] getXmlMaMenuAll(String m_st, String m_st2, String arg) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        if(arg.equals("b"))//대메뉴
        {
	        query = "SELECT a.M_ST,a.M_ST2,\n"
	        				+ "a.M_CD,\n"
	                		+ "a.M_NM,\n"
	                		+ "a.URL,\n"
	                		+ "a.SEQ,\n"
	                		+ "a.NOTE, a.BASE\n"
	        		+ "FROM xml_menu a\n"
	        		+ "where m_st like '%%'\n"
	        		+ "and m_st2 = '00' and m_cd = '00'\n"
	        		+ "order by a.SEQ";
        }else if(arg.equals("m")){//중메뉴
	        query = "SELECT a.M_ST,a.M_ST2,\n"
	        				+ "a.M_CD,\n"
	                		+ "a.M_NM,\n"
	                		+ "a.URL,\n"
	                		+ "a.SEQ,\n"
	                		+ "a.NOTE, a.BASE\n"
	        		+ "FROM xml_menu a\n"
	        		+ "where m_st like '%" + m_st + "%'\n"
	        		+ "and m_st2 <> '00' and m_cd = '00'\n"
	        		+ "order by a.M_ST, a.SEQ";
        }else if(arg.equals("s")){//소메뉴
	        query = "SELECT a.M_ST,a.M_ST2,\n"
	        				+ "a.M_CD,\n"
	                		+ "a.M_NM,\n"
	                		+ "a.URL,\n"
	                		+ "a.SEQ,\n"
	                		+ "a.NOTE, a.BASE\n"
	        		+ "FROM xml_menu a\n"
	        		+ "where m_st like '%" + m_st + "%' and m_st2 like '%" + m_st2 + "%' \n"
	        		+ "and m_st2 <> '00' and m_cd <> '00'\n"
	        		+ "order by a.M_ST, a.M_ST2, a.SEQ";
	    }

        Collection<MenuBean> col = new ArrayList<MenuBean>();
        try{
            pstmt = con.prepareStatement(query);
            
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeMaMenuBean(rs, "menu"));
 
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
        return (MenuBean[])col.toArray(new MenuBean[0]);
    }
    /**
     * 메뉴 등록.
     */
    public int insertXmlMaMenu(MenuBean bean, String arg) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String arg1 = "";
        String arg2 = "";
        int count = 0;
                
        if(arg.equals("b"))
        {
	        query="INSERT INTO xml_menu (M_ST,M_ST2,M_CD,\n"
									+ "M_NM,\n"
									+ "URL,\n"
									+ "NOTE,\n"
									+ "SEQ,\n"
									+ "BASE)\n"
	            + "SELECT nvl(lpad(max(M_ST)+1,2,'0'),'01'),?,?,?,?,?,?,?\n"
	            + "FROM xml_menu\n"
	            + "WHERE M_ST<>'99' and M_ST2=? and M_CD=?\n";
	        arg1 = "00";
	        arg2 = "00";
         }else if(arg.equals("m")){
         		query="INSERT INTO xml_menu (M_ST,M_ST2,\n"
									+ "M_CD,\n"
									+ "M_NM,\n"
									+ "URL,\n"
									+ "NOTE,\n"
									+ "SEQ, BASE)\n"
	            + "SELECT ?,nvl(lpad(max(M_ST2)+1,2,'0'),'01'),?,?,?,?,?,?\n"
	            + "FROM xml_menu\n"
	            + "WHERE M_ST=? and M_CD=?\n";
	        arg1 = bean.getM_st().trim();
	        arg2 = "00";
         }else if(arg.equals("s")){
         		query="INSERT INTO xml_menu (M_ST,M_ST2,\n"
									+ "M_CD,\n"
									+ "M_NM,\n"
									+ "URL,\n"
									+ "NOTE,\n"
									+ "SEQ, BASE)\n"
	            + "SELECT ?,?,nvl(lpad(max(M_CD)+1,2,'0'),'01'),?,?,?,?,?\n"
	            + "FROM xml_menu\n"
	            + "WHERE M_ST=? and m_st2=?\n";
	        arg1 = bean.getM_st().trim();
	        arg2 = bean.getM_st2().trim();
	     }

       try{
            con.setAutoCommit(false);
            
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, arg1);
            pstmt.setString(2, arg2);
            pstmt.setString(3, bean.getM_nm().trim());
            pstmt.setString(4, bean.getUrl().trim());
            pstmt.setString(5, bean.getNote().trim()); 
            pstmt.setInt   (6, bean.getSeq());
            pstmt.setString(7, bean.getBase());
            pstmt.setString(8, arg1);
            pstmt.setString(9, arg2);
           
           
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
     * 메뉴 수정.
     */
    public int updateXmlMaMenu(MenuBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String m_st = "";
        String m_st2 = "";
        String m_cd = "";
        int count = 0;
                
        
 		query = " UPDATE xml_menu SET \n"
				+ "M_NM=?, \n"
				+ "URL=?,  \n"
				+ "NOTE=?, \n"
				+ "SEQ=?,  \n"
				+ "BASE=?  \n"
		        + "WHERE M_ST=? and M_ST2=? AND M_CD=? ";

        m_st	= bean.getM_st().trim();
        m_st2	= bean.getM_st2().trim();
        m_cd	= bean.getM_cd().trim();
	   
       try{
            con.setAutoCommit(false);
            
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getM_nm().trim());
            pstmt.setString(2, bean.getUrl().trim());
            pstmt.setString(3, bean.getNote().trim()); 
            pstmt.setInt   (4, bean.getSeq());
            pstmt.setString(5, bean.getBase().trim()); 
            pstmt.setString(6, m_st);
            pstmt.setString(7, m_st2);
            pstmt.setString(8, m_cd);
           
           
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
     * 서브 메뉴 삭제
     */
    public int deleteBXmlMaMenu(Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE xml_menu WHERE M_ST=? ";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt.setString(1, val[0].trim());
                count = pstmt.executeUpdate();
            }
             
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
     * 서브 메뉴 삭제
     */
    public int deleteMXmlMaMenu(String m_st, Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE xml_menu WHERE M_ST=? AND M_ST2=? ";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt.setString(1, m_st.trim());
                pstmt.setString(2, val[0].trim());
                count = pstmt.executeUpdate();
                
            }
             
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
     * 서브 메뉴 삭제
     */
    public int deleteSXmlMaMenu(String m_st, String m_st2, Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE xml_menu WHERE M_ST=? AND M_ST2=? AND M_CD=? ";

       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);

            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt.setString(1, m_st.trim());
                pstmt.setString(2, m_st2.trim());
                pstmt.setString(3, val[0].trim());
                count = pstmt.executeUpdate();
                
            }
             
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

	//메뉴별 권한 조회 
	public String getXmlMaMenuAuth(String user_id, String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String authrw = "";
        
		query = " SELECT auth_rw FROM xml_ma_me WHERE user_id = '" + user_id + "' AND m_st='"+m_st+"' AND m_st2='"+m_st2+"' AND m_cd='"+m_cd+"'";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

  			if(rs.next())
                authrw = rs.getString("auth_rw");
                
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
        return authrw;
    }

   public boolean setXmlMenuBaseAuth(String m_st, String m_st2, String m_cd, String user_id, String auth_rw) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
			
		query = " INSERT INTO xml_ma_me ("+
				"	user_id,				"+
				"	m_st,				"+
				"	m_st2,			"+
				"	m_cd,			"+
				"	auth_rw         "+
				" ) VALUES "+ 
				" ( ?, ?, ?, ?, ? "+
				" )";

		try 
		{

			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		user_id	);
			pstmt.setString	(2,		m_st	);
			pstmt.setString	(3,		m_st2	);
			pstmt.setString	(4,		m_cd	);
			pstmt.setString	(5,		auth_rw	);
	
			pstmt.executeUpdate();
			
	    	pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
                flag = false;
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
       return flag;
    }

   public boolean updateXmlMenuBaseAuth(String m_st, String m_st2, String m_cd, String user_id, String auth_rw) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
			
		query = " update xml_ma_me set auth_rw=? where"+
				"	    user_id	=?		"+
				"	and m_st	=?		"+
				"	and m_st2	=?		"+
				"	and m_cd	=?		";

		try 
		{

			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		auth_rw	);
			pstmt.setString	(2,		user_id	);
			pstmt.setString	(3,		m_st	);
			pstmt.setString	(4,		m_st2	);
			pstmt.setString	(5,		m_cd	);
			pstmt.executeUpdate();
			
	    	pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
                flag = false;
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
       return flag;
    }

    /**
     * 사용자 전체 조회.
     */
    public UsersBean [] getUserXmlAuthAll(String br_id, String dept_id, String user_nm, String m_st, String m_st2, String m_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.USER_ID,\n"
        				+ "a.BR_ID,\n"
        				+ "b.BR_NM,\n"
        				+ "a.USER_NM,\n"
        				+ "a.ID,\n"
        				+ "a.USER_PSD,\n"
        				+ "a.USER_CD,\n"
        				+ "a.USER_SSN,\n"
        				+ "a.DEPT_ID,\n"
        				+ "c.NM AS DEPT_NM,\n"
        				+ "a.USER_H_TEL,\n"
        				+ "a.USER_M_TEL,\n"
						+ "a.IN_TEL,\n"
						+ "a.HOT_TEL,\n"
        				+ "a.USER_EMAIL,\n"
        				+ "a.USER_POS,\n"
        				+ "a.LIC_NO, a.LIC_DT, a.ENTER_DT, a.content, a.filename, a.filename2, a.zip, a.addr, d.userid as mail_id, d.passwd as mail_pw,\n"
						+ "a.loan_st, a.sa_code, a.out_dt, a.use_yn, a.user_work, a.user_i_tel, a.fax_id, a.fax_pw, a.partner_id, a.i_fax, a.taste, a.special, a.ven_code, \n"
						+ "e.auth_rw as USER_AUT, a.gundea, a.bank_nm, a.bank_no, a.add_per, a.area_id, f.nm as area_nm, a.home_zip, a.home_addr , '' age, '' sch_chk, a.user_job, a.agent_cont_view, a.ars_group \n"
        		+ " FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c, mail_mng d, \n"
				+ "		(select * from xml_ma_me where m_st='"+m_st+"' and m_st2='"+m_st2+"' and m_cd='"+m_cd+"') e, (select * from code where c_st='0029') f \n"
        		+ " where a.BR_ID = b.BR_ID and a.mail_id=d.userid(+) \n"
        		+ " and a.DEPT_ID = c.CODE(+) \n"
        		+ " and a.user_id = e.user_id(+) and a.area_id=f.code(+) \n"
				+ " ";

		if(!dept_id.equals("9999")) query += "  and nvl(a.use_yn,'Y')='Y'";
		else						query += "  and nvl(a.use_yn,'Y')='N'";

		if(!br_id.equals(""))	query += " and a.BR_ID like '%" + br_id + "%'";
		if(!user_nm.equals("")) query += " and a.USER_NM like '%" + user_nm + "%'";

		if(!dept_id.equals("")){
			if(dept_id.equals("acar"))			query += " and a.DEPT_ID not in ('8888','1000','1999') ";
			else if(dept_id.equals("agent"))	query += " and a.DEPT_ID in ('1000') ";
			else if(dept_id.equals("out"))		query += " and a.DEPT_ID in ('8888','1999') ";
			else								query += " and a.DEPT_ID like '%" + dept_id + "%' ";
		}


		query += "order by decode(a.user_pos,'대표이사',1, '이사', 2, '팀장', 4, 5), a.dept_id, decode(a.user_id, '000237', '0',decode(a.user_pos, '부장', 1,  '차장', 2, '과장',3,'대리', 4, 5)) , a.user_id";


        Collection<UsersBean> col = new ArrayList<UsersBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeUserBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[UserMngDatabase:getUserXmlAuthAll]"+se);
			System.out.println("[UserMngDatabase:getUserXmlAuthAll]"+query);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (UsersBean[])col.toArray(new UsersBean[0]);
    }

   /**
     * 권한등록(삭제후 등록한다.).
     */
    public void insertXmlAuthUserCase(String user_id, String m_st, String m_st2, String m_cd, String auth_rw) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        int countD = 0;
        int countI = 0;
        String query1 = "delete xml_ma_me"
                             +" where user_id=?"
                             +" and m_st=?"
                             +" and m_st2=?"
                             +" and m_cd=?"
							 +" ";

        String query2 = "insert into xml_ma_me (USER_ID,\n"
        								+ "M_ST,\n"
        								+ "M_ST2,\n"
        								+ "M_CD,\n"
        								+ "AUTH_RW)\n"
                         +" values(?,?,?,?,?)";
        try{
            con.setAutoCommit(false);

            /** 권한부여하기전에 먼저 삭제한다. */
            pstmt1 = con.prepareStatement(query1);
           
            pstmt1.setString(1, user_id.trim());
            pstmt1.setString(2, m_st.trim());
            pstmt1.setString(3, m_st2.trim());
            pstmt1.setString(4, m_cd.trim());
            countD = pstmt1.executeUpdate();
			pstmt1.close();

            /** 권한부여한다. */    
            pstmt2 = con.prepareStatement(query2);
            pstmt2.setString(1, user_id.trim());
            pstmt2.setString(2, m_st.trim());
            pstmt2.setString(3, m_st2.trim());
            pstmt2.setString(4, m_cd);
            pstmt2.setString(5, auth_rw);                
	        countI = pstmt2.executeUpdate();            
            pstmt2.close();

            con.commit();
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

   /**
     * 권한등록(삭제후 등록한다.).
     */
    public void insertXmlAuthMa(String user_id, String m_st, String m_st2, Vector v) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        int countD = 0;
        int countI = 0;
        String query1 = "delete xml_ma_me"
                             +" where user_id=?"
                             +" and m_st=?"
                             +" and m_st2=?";

        String query2 = "insert into xml_ma_me(USER_ID,\n"
        								+ "M_ST,\n"
        								+ "M_ST2,\n"
        								+ "M_CD,\n"
        								+ "AUTH_RW)\n"
                         +" values(?,?,?,?,?)";
        try{
            con.setAutoCommit(false);
            /** 권한부여하기전에 먼저 삭제한다. */
            pstmt1 = con.prepareStatement(query1);
           
            pstmt1.setString(1, user_id.trim());
            pstmt1.setString(2, m_st.trim());
            pstmt1.setString(3, m_st2.trim());
            countD = pstmt1.executeUpdate();

            /** 권한부여한다. */ 
   
            pstmt2 = con.prepareStatement(query2);
            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);

                pstmt2.setString(1, user_id.trim());
                pstmt2.setString(2, m_st.trim());
                pstmt2.setString(3, m_st2.trim());
                pstmt2.setString(4, val[0].substring(0,2));
                pstmt2.setString(5, val[0].substring(2,3));                
                countI = pstmt2.executeUpdate();
            }
            pstmt1.close();
            pstmt2.close();
            con.commit();
        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

    /**
     * 권한 전체 조회 - 사용자 권한 등록시 사용
     */
    public AuthBean [] getXmlAuthMaAll(String user_id, String m_st, String m_st2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " SELECT a.M_ST, a.M_ST2, a.M_CD, a.M_NM, a.URL, nvl(b.auth_rw,'0')  as auth_rw \n"+
				" FROM\n"+
					"(SELECT * FROM xml_menu WHERE m_st='"+m_st.trim()+"' and m_st2='" +m_st2.trim() + "' and m_cd <> '00') a,\n"+
					"(SELECT * FROM xml_ma_me WHERE user_id='"+user_id.trim()+"' and m_st='"+m_st.trim()+ "' and m_st2 = '"+ m_st2.trim() + "' ) b\n"+
				" WHERE a.m_cd=b.m_cd(+)  ORDER BY a.seq";

        Collection<AuthBean> col = new ArrayList<AuthBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeAuthBean(rs));
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
        return (AuthBean[])col.toArray(new AuthBean[0]);
    }

	//사용자 권한 복사 

	public boolean deleteXmlAuthCopy(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
            
		query = " DELETE from xml_ma_me where user_id = '"+ user_id + "'";

		
		try {
			pstmt = con.prepareStatement(query);
			pstmt.executeUpdate();
		
		    pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
                flag = false;
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
       return flag;
    }

    	//메뉴별 권한 조회 
	public Vector  getUserXmlAuth(String user_id) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String authrw = "0";
        Vector vt = new Vector();
        	
		query = " SELECT * FROM xml_ma_me WHERE user_id = '" + user_id +"'";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
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
      return vt;
    }

   public boolean insertXmlAuthCopy(AuthBean bean) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
			
		query = " INSERT INTO xml_ma_me ("+
				"	user_id,				"+
				"	m_st,				"+
				"	m_st2,			"+
				"	m_cd,			"+
				"	auth_rw         "+
				" ) VALUES "+ 
				" ( ?, ?, ?, ?, ? "+
				" )";

		try 
		{

			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getUser_id				());
			pstmt.setString	(2,		bean.getM_st				());
			pstmt.setString	(3,		bean.getM_st2			());
			pstmt.setString	(4,		bean.getM_cd			());
			pstmt.setString	(5,		bean.getAuth_rw		());
	
			pstmt.executeUpdate();
			
	    	pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
                flag = false;
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
       return flag;
    }

 	/**
     * 휴가여부
     */
    public String getCarScheTodayChk(String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String w_user_id = "";
        
        String query = "";
        
        query = "   select a.work_id, a.user_id USER_ID, a.seq SEQ, a.start_year START_YEAR, a.start_mon START_MON, a.start_day START_DAY, a.title TITLE, a.content CONTENT, "
				+ "        a.reg_dt REG_DT, b.user_nm USER_NM, a.sch_kd SCH_KD, a.sch_chk SCH_CHK \n"
				+ " from   sch_prv a, users b\n"
				+ " where  a.user_id='"+user_id+"' "
				+ "        and a.sch_chk not in ('1','2','0') and a.start_year||a.start_mon||a.start_day=to_char(sysdate,'YYYYMMDD') "
				+ "        and a.user_id=b.user_id\n";

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            if(rs.next())
                w_user_id = rs.getString("USER_ID")==null?"":rs.getString("USER_ID");

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
        }
        return w_user_id;
    }

	public int updateUseArea(String user_id, String area_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
     
        int count = 0;                
        
 		query = " UPDATE users SET \n"
					+ "area_id =?  \n"
		        + "WHERE user_id =?  ";
   	   
       try{
            con.setAutoCommit(false);
            
            
            pstmt = con.prepareStatement(query);

            pstmt.setString(1, area_id);
            pstmt.setString(2, user_id);
                     
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
     * 에이전트 리뉴얼 작업 : 대메뉴 순서 변경 2018.04.06
     */
      public Vector getAuthMaMeAllAgent(String user_id, String m_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        Vector vt = new Vector();
      
        query = " SELECT  M_ST,  M_ST2,  M_CD ,  M_NM  ";
        query += " FROM ";
        query += "	( ";
        query += "		SELECT A.SEQ,  A.M_ST,  A.M_ST2,  B.M_CD ,  A.M_NM ";
        query += "		FROM  ";
        query += "			MA_MENU A, ";
        query += "			(";
        query += "				SELECT M_ST,  M_ST2,  MIN(m_cd) AS M_CD ";
        query += "				FROM US_MA_ME ";
        query += "				WHERE user_id = '"+user_id.trim()+"' "; 
        query += " 				AND m_st2 <>'00' "; 
        query += " 				AND nvl(auth_rw, '0' ) <> '0' "; 
        query += " 				GROUP BY M_ST, M_ST2 "; 
        query += "			) B ";
        query += "			WHERE A.M_ST = B.M_ST "; 
        query += "			AND A.M_ST2 = B.M_ST2 "; 
        query += "			AND A.M_CD = 00 ";  
        query += "	) T";
        query += "	ORDER BY M_ST, M_ST2, SEQ ";
    
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
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
            stmt.close();
        }catch(SQLException se){
			System.out.println("[UserMngDatabase:getAuthMaMeAllAgent]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
      	return vt;
    }

	//에이전트 대메뉴 리스트 조회	2018.04.05
    public Vector getAgentUpperMenuList(String user_id) throws DatabaseException, DataSourceEmptyException {
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        Statement stmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";

        query = " select M_ST2 AS M_ST "+
                " from (select a.seq, a.m_st, a.m_st2, b.m_cd, a.m_nm from ma_menu a, "+
			    " (select m_st, m_st2, min(m_cd) as m_cd from us_ma_me where user_id='"+user_id+"' "+
                " and m_st2 <>'00' and nvl(auth_rw, '0') <> '0' group by m_st, m_st2) b "+
                " where a.m_st = b.m_st and a.m_st2 = b.m_st2 and a.m_cd = 00) t order by m_st2";

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
                     ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
                }
                vt.add(ht); 
            }  
            rs.close();
            stmt.close();
        }catch(SQLException se){
            System.out.println("[UserMngDatabase:getAgentUpperMenuList]"+se);
            throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            con = null;
        }
      return vt;
    }
    
    //에이전트 리뉴얼 메뉴	2018.04.05
  	public Vector getAgentMenuList(String user_id) throws DatabaseException, DataSourceEmptyException {
  		Connection con = connMgr.getConnection(DATA_SOURCE);

          if(con == null)
              throw new DataSourceEmptyException("Can't get Connection !!");
              
  		Statement stmt = null;
  		ResultSet rs = null;
  		Vector vt = new Vector();
  		String query = "";

  		query = " select "+
                " distinct a.m_st2 as M_ST, a.M_ST2, a.M_CD, ltrim(a.m_st2, '0') as SEQ1, a.seq as SEQ2, a.M_NM, a.URL, 'N' as MYMENU_YN, b.AUTH_RW "+
                " from (select * from ma_menu where m_st='22' and m_cd <> '00') a "+
                " left outer join (select * from us_ma_me where user_id='"+user_id+"' and m_st='22') b "+
			    " on a.m_st2 = b.m_st2 and a.m_cd = b.m_cd "+
                " where b.auth_rw <> '0' order by 1, 4, 5";
//LTRIM(a.m_st2, '0') as SEQ1
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
  					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
  				}
  				vt.add(ht);	
  			}  
  			rs.close();
              stmt.close();
          }catch(SQLException se){
  			System.out.println("[UserMngDatabase:getAgentMenuList]"+se);
  			throw new DatabaseException();
          }finally{
              try{
                  if(rs != null ) rs.close();
                  if(stmt != null) stmt.close();
              }catch(SQLException _ignored){}
              connMgr.freeConnection(DATA_SOURCE, con);
  			con = null;
          }
        return vt;
      }
  	
  	//마이메뉴 리스트 조회 : 실제 마이메뉴 기능은 사용하지 않는다.	2018.04.05
  	public Vector getAgentMyMenuList(String user_id) throws DatabaseException, DataSourceEmptyException {
  		Connection con = connMgr.getConnection(DATA_SOURCE);
  		if(con == null)
              throw new DataSourceEmptyException("Can't get Connection !!");
              
  		Statement stmt = null;
  		ResultSet rs = null;
  		Vector vt = new Vector();
  		String query = "";

  		query = " select DISTINCT a.m_st, a.m_st2, a.m_cd, a.m_nm, a.m_nm AS m_nm1, a.m_nm AS m_nm2, B.AUTH_RW "+
  				" from (SELECT * FROM ma_menu WHERE m_st='22' and m_cd <> '00') a, "+
  				" (SELECT * FROM us_ma_me WHERE user_id='"+user_id+"' AND m_st='22') b "+
  				" where a.m_st2(+)=b.m_st2 AND b.auth_rw='4' ORDER BY a.m_st2";

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
  					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
  				}
  				vt.add(ht);	
  			}
  			
    			rs.close();
              stmt.close();
     		} catch (SQLException e) {
  			System.out.println("[UserMngDatabase:getAgentMyMenuList]\n"+e);
  	  		throw new DatabaseException();
  	    }finally{
              try{
                  if(rs != null ) rs.close();
                  if(stmt != null) stmt.close();
              }catch(SQLException _ignored){}
              connMgr.freeConnection(DATA_SOURCE, con);
  			con = null;
          }
        return vt;
      }
  	
  	//협력업체 메뉴 리뉴얼 작업		2018.04.25
  	public Vector getOffMenuList(String user_id) throws DatabaseException, DataSourceEmptyException {
  		Connection con = connMgr.getConnection(DATA_SOURCE);

          if(con == null)
              throw new DataSourceEmptyException("Can't get Connection !!");
              
  		Statement stmt = null;
  		ResultSet rs = null;
  		Vector vt = new Vector();
  		String query = "";

  		query = " select "+
                " distinct a.m_st, a.m_st2, a.m_cd, a.m_nm, a.url, a.note, a.seq, a.base, "+
                " case a.m_cd when '00' then '1' else b.auth_rw end as auth_rw "+
                " from (select * from ma_menu where m_st > '22' and m_st != '99' and m_st2 != '00' and (url !='.' or url IS null)) a, "+
                " (select * from us_ma_me where user_id= '"+user_id+"' and auth_rw <> '0') b "+
                " where a.m_st = b.m_st and a.m_st2 = b.m_st2 and (a.m_cd = b.m_cd or a.m_cd='00') order by 1, 2, "+
  				" (case m_cd when '00' then 1 else (case seq when 1 then 2 when 2 then 3 when 3 then 4 when 4 then 5 "+
                " when 5 then 6 when 6 then 7 when 7 then 8 when 8 then 9 when 9 then 10 when 10 then 11 when 11 then 12 end) end)  ";
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
  					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
  				}
  				vt.add(ht);	
  			}  
  			rs.close();
              stmt.close();
          }catch(SQLException se){
  			System.out.println("[UserMngDatabase:getOffMenuList]"+se);
  			throw new DatabaseException();
          }finally{
              try{
                  if(rs != null ) rs.close();
                  if(stmt != null) stmt.close();
              }catch(SQLException _ignored){}
              connMgr.freeConnection(DATA_SOURCE, con);
  			con = null;
          }
        return vt;
      }
  	
  	//협력업체 대메뉴 리스트 조회	2018.04.25
    public Vector getOffUpperMenuList(String user_id) throws DatabaseException, DataSourceEmptyException {
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        Statement stmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";

        query = " select distinct m_st "+
			    " from us_ma_me where user_id='"+user_id+"' and m_st > '22' and m_st != '99' and auth_rw != '0'";

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
                     ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
                }
                vt.add(ht); 
            }  
            rs.close();
            stmt.close();
        }catch(SQLException se){
            System.out.println("[UserMngDatabase:getOffUpperMenuList]"+se);
            throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            con = null;
        }
      return vt;
    }
    
    //협력업체 - 이름으로 정보fetch
    public Vector getOffUserList(String user_nm) throws DatabaseException, DataSourceEmptyException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement stmt = null;
        ResultSet rs = null;
        Vector vt = new Vector();
        String query = "";
        query = " select * "+
			    	 "   from users where dept_id = '8888' and use_yn = 'Y' and user_nm like '%"+user_nm+"%'";

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
                     ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
                }
                vt.add(ht); 
            }  
            rs.close();
            stmt.close();
        }catch(SQLException se){
            System.out.println("[UserMngDatabase:getOffUserList]"+se);
            throw new DatabaseException();
        }finally{
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
     * ARS 파트너 등록
     */
    public void UdateArs_group(String full_id, String reg_id) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        int countI = 0;

		String query = " UPDATE USERS SET ars_GROUP = trim('"+full_id.trim()+"') WHERE USER_ID = '"+reg_id.trim()+"' ";


        try{
            con.setAutoCommit(false);
            pstmt = con.prepareStatement(query);
	        countI = pstmt.executeUpdate();            
            pstmt.close();

            con.commit();
        }catch(SQLException se){
			System.out.println("[UserMngDatabase:UdateArs_group]"+se);
			System.out.println("[UserMngDatabase:UdateArs_group]"+query);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }    
    
    public String getSenderId(String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String return_id = "";
        
        String query = "";
        
        query = "SELECT id FROM users WHERE user_id='" + user_id + "'";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            
            if(rs.next())
            	return_id = rs.getString("id");

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
        return return_id;
    }
    
	 /**
     * 업무권한 변경
     */
    public void updateUsWUser(String w_nm, String user_id) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        int countI = 0;

		String query = " UPDATE us_me_w SET user_id = '"+user_id+"' WHERE w_nm = '"+w_nm+"' ";

        try{
            con.setAutoCommit(false);
            pstmt = con.prepareStatement(query);
	        countI = pstmt.executeUpdate();            
            pstmt.close();

            con.commit();
        }catch(SQLException se){
			System.out.println("[UserMngDatabase:updateUsWUser]"+se);
			System.out.println("[UserMngDatabase:updateUsWUser]"+query);
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException(Util.getStackTrace(se));
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }    
    
    //에이전트 사용자 등록인 경우
    public int updateEmpAgent(String sa_code, String agent_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE car_off_emp SET agent_id=? WHERE emp_id=? and agent_id is null ";
 
       try{
            con.setAutoCommit(false);
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, agent_id.trim());
            pstmt.setString(2, sa_code.trim());
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
  	
}