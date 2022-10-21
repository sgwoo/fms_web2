/*
 * ����ڵ��, �޴�����, ���Ѱ���
 * @ create date : 2003. 3. 3
 */
package acar.user_mng;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class AddUserMngDatabase {

    private static AddUserMngDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool�� ���� Connection ��ü�� �����ö� ����ϴ� Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // �̱��� Ŭ������ ���� 
    // �����ڸ� private �� ����
    public static synchronized AddUserMngDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AddUserMngDatabase();
        return instance;
    }
    
    private AddUserMngDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

    /**
     * Ư�� ���ڵ带 Bean�� �����Ͽ� Bean�� �����ϴ� �޼ҵ�
     */
	/**
     * �����
     */
    private UsersBean makeUserBean(ResultSet results) throws DatabaseException {

        try {
            UsersBean bean = new UsersBean();

            bean.setUser_id(results.getString("USER_ID"));				//����� ������ȣ
		    bean.setBr_id(results.getString("BR_ID"));					// ����ID
		    bean.setBr_nm(results.getString("BR_NM"));					//������Ī
		    bean.setUser_nm(results.getString("USER_NM"));					//������̸�
		    bean.setId(results.getString("ID"));						//�����ID
		    bean.setUser_psd(results.getString("USER_PSD"));				//��й�ȣ
		    bean.setUser_ssn(results.getString("USER_SSN"));				//�ֹε�Ϲ�ȣ
		    bean.setUser_cd(results.getString("USER_CD"));					//�����ȣ
		    bean.setDept_id(results.getString("DEPT_ID"));					//�μ�ID
		    bean.setDept_nm(results.getString("DEPT_NM"));					//�μ��̸�
		    bean.setUser_h_tel(results.getString("USER_H_TEL"));				//����ȭ��ȣ
		    bean.setUser_m_tel(results.getString("USER_M_TEL"));				//�޴���
		    bean.setUser_email(results.getString("USER_EMAIL"));				//�̸���
		    bean.setUser_pos(results.getString("USER_POS"));				//����
		    bean.setUser_aut(results.getString("USER_AUT"));				//����	
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * �μ�
     */
    private DeptBean makeDeptBean(ResultSet results) throws DatabaseException {

        try {
            DeptBean bean = new DeptBean();

            bean.setC_st(results.getString("C_ST"));					//�ڵ�з�
		    bean.setCode(results.getString("CODE"));					//�ڵ�(����������)
		    bean.setNm_cd(results.getString("NM_CD"));					//����ڵ��
		    bean.setNm(results.getString("NM"));						//�μ��̸�
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * ����
     */
    private BranchBean makeBranchBean(ResultSet results) throws DatabaseException {
        try {
            BranchBean bean = new BranchBean();

		    bean.setBr_id(results.getString("BR_ID"));							//����ID
		    bean.setBr_ent_no(results.getString("BR_ENT_NO"));					//����ڵ�Ϲ�ȣ
		    bean.setBr_nm(results.getString("BR_NM"));							//���θ�
		    bean.setBr_st_dt(results.getString("BR_ST_DT"));					//���������
		    bean.setBr_post(results.getString("BR_POST"));						//�����ȣ
		    bean.setBr_addr(results.getString("BR_ADDR"));						//�ּ�
		    bean.setBr_item(results.getString("BR_ITEM"));						//����
		    bean.setBr_sta(results.getString("BR_STA"));						//����
		    bean.setBr_tax_o(results.getString("BR_TAX_O"));					//���Ҽ�����
		    bean.setBr_own_nm(results.getString("BR_OWN_NM"));					//��ǥ��
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
    }
	/**
     * �޴�
     */
    private MenuBean makeMenuBean(ResultSet results, String arg) throws DatabaseException {

        try {
            MenuBean bean = new MenuBean();

            bean.setM_st(results.getString("M_ST"));					//��޴� ����
		    bean.setM_cd(results.getString("M_CD"));					//�Ҹ޴� ����
		    if(arg.equals("menu"))
		    {
		    bean.setM_nm(results.getString("M_NM"));					//�޴���
		    bean.setUrl(results.getString("URL"));					//url
		    bean.setNote(results.getString("NOTE"));					//���
		    bean.setSeq(results.getInt("SEQ"));						//����
		    }else if(arg.equals("sub"))
		    {					
		    bean.setSeq_no(results.getInt("SEQ_NO"));						//����޴�SEQ
			bean.setSm_nm(results.getString("SM_NM"));					//����޴���
		    bean.setUrl(results.getString("URL"));					//url
			}
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * ����
     */
    private AuthBean makeAuthBean(ResultSet results) throws DatabaseException {

        try {
            AuthBean bean = new AuthBean();
            bean.setM_st(results.getString("M_ST"));		//��޴� ����
		    bean.setM_cd(results.getString("M_CD"));		//�Ҹ޴� ����
		    bean.setM_nm(results.getString("M_NM"));		//�޴���
		    bean.setM_gu(results.getString("M_GU"));		//�޴� ���� 2
		    bean.setUrl(results.getString("URL"));			//�޴���
		    bean.setAuth_rw(results.getString("AUTH_RW"));
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

    /**
     * ���ѵ��(������ ����Ѵ�.).
     */
    public void insertAuth(String user_id, String m_st, Vector v) throws DatabaseException, DataSourceEmptyException, UnknownDataException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        int countD = 0;
        int countI = 0;
        String query1 = " delete us_me where user_id=? and m_st=?";

        String query2 = " insert into us_me(USER_ID, M_ST, M_CD, AUTH_RW, M_GU) values(?,?,?,?, '00')";
        try{
            con.setAutoCommit(false);
            pstmt1 = con.prepareStatement(query1);          
            pstmt1.setString(1, user_id.trim());
            pstmt1.setString(2, m_st.trim());
            countD = pstmt1.executeUpdate();
 
            pstmt2 = con.prepareStatement(query2);
            for(int i=0; i<v.size(); i++){
                String val [] = (String [])v.elementAt(i);
                pstmt2.setString(1, user_id.trim());
                pstmt2.setString(2, m_st.trim());
                pstmt2.setString(3, val[0].substring(0,2));
                pstmt2.setString(4, val[0].substring(2,3));

				countI = pstmt2.executeUpdate();
            }

            pstmt1.close();
            pstmt2.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddUserMngDatabase:insertAuth]"+se);
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
     * �޴� ��ü ��ȸ.
     */
    public MenuBean [] getMenuAll(String m_st, String arg) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        if(arg.equals("b")){
	        query = " SELECT M_ST, M_CD, M_NM, URL, SEQ, NOTE FROM menu\n"
	        	  + " where m_cd = '00' order by M_ST, SEQ";
        }else if(arg.equals("s")){
	        query = " SELECT M_ST, M_CD, M_NM, URL, SEQ, NOTE FROM menu\n"
	        	  + " where m_st like '%" + m_st + "%' and m_cd <> '00' order by M_ST, SEQ";
	    }

        Collection<MenuBean> col = new ArrayList<MenuBean>();

        try{
            pstmt = con.prepareStatement(query);            
            rs = pstmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeMenuBean(rs, "menu")); 
            }
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AddUserMngDatabase:getMenuAll]"+se);
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
     * ���� ��ü ��ȸ.
     */
    public AuthBean [] getAuthAll(String user_id, String m_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " SELECT a.M_ST, a.M_CD, a.M_NM, a.M_GU, a.URL, b.auth_rw\n"+
				" FROM\n"+
					"(SELECT * FROM menu WHERE m_st='"+m_st.trim()+"' and m_cd <> '00') a,\n"+
					"(SELECT * FROM us_me WHERE user_id='"+user_id.trim()+"' and m_st='"+m_st.trim()+"') b\n"+
				" WHERE a.m_cd=b.m_cd(+) ORDER BY a.seq";

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
			System.out.println("[AddUserMngDatabase:getAuthAll]"+se);
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
     * ���� �޴� ��ü ��ȸ.
     */
    public MenuBean [] getSubMenuAll(String m_st,String m_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";                
        query = " SELECT M_ST, M_CD, SEQ_NO, SM_NM, URL FROM sub_m"+
        		" where m_st = '" + m_st + "' and m_cd = '" + m_cd + "'\n"+
        		" order by SEQ_NO";


        Collection<MenuBean> col = new ArrayList<MenuBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeMenuBean(rs, "sub"));
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AddUserMngDatabase:getSubMenuAll]"+se);
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
     * �޴� ���.
     */
    public int insertMenu(MenuBean bean, String arg) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String arg1 = "";
        int count = 0;
                
        if(arg.equals("b")){
	        query = " INSERT INTO menu(M_ST, M_CD, M_NM, URL, NOTE, SEQ, M_GU)\n"+
						" SELECT nvl(lpad(max(M_ST)+1,2,'0'),'01'),?,?,?,?,?,?\n"+
			            " FROM test_menu\n"+
						" WHERE M_CD=?\n";
	        arg1 = "00";
         }else if(arg.equals("s")){
       		query = " INSERT INTO menu(M_ST, M_CD, M_NM, URL, NOTE, SEQ, M_GU)\n"+
						" SELECT ?,nvl(lpad(max(M_CD)+1,2,'0'),'01'),?,?,?,?,?\n"+
						" FROM test_menu\n"+
						" WHERE M_ST=?\n";
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
            pstmt.setString(7, arg1);                     
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddUserMngDatabase:insertMenu]"+se);
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
     * ���� �޴� ���.
     */
    public int insertSubMenu(MenuBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                       
 		query = " INSERT INTO sub_m (M_ST, M_CD, SEQ_NO, SM_NM, M_GU)\n"+
					" SELECT ?,?,nvl(max(SEQ_NO)+1,'1'),?,?\n"+
					" FROM SUB_M\n"+
					" WHERE M_ST=?\n"+
					" AND M_CD=?\n";
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getM_st().trim());
            pstmt.setString(2, bean.getM_cd().trim());
            pstmt.setString(3, bean.getSm_nm().trim());
            pstmt.setString(4, bean.getM_gu().trim());
			pstmt.setString(5, bean.getM_st().trim());
            pstmt.setString(6, bean.getM_cd().trim());                      
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddUserMngDatabase:insertSubMenu]"+se);
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
     * �޴� ����.
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
                        
 		query = " UPDATE menu SET M_NM=?, URL=?, NOTE=?, SEQ=? WHERE M_ST=? AND M_CD=?";
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
				System.out.println("[AddUserMngDatabase:updateMenu]"+se);
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
     * ���� �޴� ����.
     */
    public int updateSubMenu(MenuBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE SUB_M SET SM_NM=? WHERE M_ST=? AND M_CD=? AND SEQ_NO=?\n";

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
				System.out.println("[AddUserMngDatabase:updateSubMenu]"+se);
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
     * ���� �޴� ����
     */
    public int deleteSMenu(String m_st, Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="DELETE FROM MENU WHERE M_ST=? AND M_CD=?\n";

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

        }catch(Exception se){
            try{
				System.out.println("[AddUserMngDatabase:deleteSMenu]"+se);
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
     * ���� �޴� ����
     */
    public int deleteBMenu(Vector v) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="DELETE FROM MENU WHERE M_ST=?\n";

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

        }catch(Exception se){
            try{
				System.out.println("[AddUserMngDatabase:deleteBMenu]"+se);
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
     * ������
     */
      public Vector getSawonList(String dept_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        Vector vt = new Vector();
      
        query = " select e.save_folder, e.save_file as file_name, "+
				" b.br_nm as br_nm,"+
				" c.nm as  dept_nm,"+
//				" to_number(to_char(sysdate,'YYYY'))-to_number('19'||substr(a.user_ssn,0,2))+1 age, "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(decode(SUBSTR(text_decrypt(a.user_ssn, 'pw' ),7,1),'1','19','2','19','20')||SUBSTR(text_decrypt(a.user_ssn, 'pw' ),1,6),'YYYYMMDD'))/12) age, "+
				" trunc(TO_NUMBER(sysdate-to_date(a.enter_dt,'YYYYMMDD'))/365,0) enter_age, "+
				" a.*"+
				" from users a, "+
				" (select * from branch) b, "+
				" (select * from code where c_st='0002') c, "+
				" (SELECT user_id, max(jg_dt) jg_dt FROM INSA_POS GROUP BY user_id) d  ,( SELECT * FROM  ACAR_ATTACH_FILE WHERE content_code = 'USERS') e "+	
			    " ,(SELECT max(TO_NUMBER(seq)) AS seq,content_seq,isdeleted  FROM  ACAR_ATTACH_FILE WHERE content_code = 'USERS' group BY content_seq,isdeleted) f "+
				" where a.use_yn='Y' and a.dept_id <> '8888'"+
				" and a.br_id=b.br_id and a.dept_id=c.code AND a.user_id=d.user_id(+) AND a.user_id||'1' = e.content_seq"+
			    " AND e.content_seq = f.content_seq AND e.seq = f.seq "+   
				" AND f.ISDELETED = 'N' ";

		//�ӿ��ܸ��
		if(dept_id.equals("0000")){
			query += " and a.dept_id in ('0001','0002','0003','0007','0008','0009','0010','0011', '0012','0013','0014','0015','0016','0017','0018', '0005','0020')";

			query += " order by a.enter_dt, text_decrypt(a.user_ssn, 'pw' ) ";
		}else if(dept_id.equals("0004")){
			 query += " AND a.user_id IN ('000003','000004','000005', '000035') ";

			 query += " order by decode(a.br_id,'S1',1,'B1',2,'D1',3), a.id, "+
					"          decode(a.dept_id,'0004',1,'0001',2,'0002',3,'0003',4),"+
					"          decode(a.user_id, '000237', '1', decode(a.user_pos, '�̻�', 0, '����', 1,'����', 2, '����', '3', '����',4,'�븮',5,'���',6)) ,"+
					"          nvl(d.jg_dt,a.enter_dt), a.enter_dt, text_decrypt(a.user_ssn, 'pw' ) ";

		//�μ��ο�
		}else{
			if(!dept_id.equals("")) query += " and a.dept_id='"+dept_id+"'";

			query += " order by decode(a.br_id,'S1',1,'S3','2','S4','3','B1',4,'D1',5,'S2',6,'J1',7,'G1','8','U1','9'),"+
					"          decode(a.dept_id,'0004',1,'0001',2,'0002',3,'0003',4),"+
					"           decode(a.user_id, '000237', '1', decode(a.user_pos, '�̻�', 0, '����',1,'����',2, '����', '3', '����',4,'�븮',5,'���',6)),"+
					"          nvl(d.jg_dt,a.enter_dt), a.enter_dt, text_decrypt(a.user_ssn, 'pw' ) ";
		}

//		System.out.println("[AddUserMngDatabase:getSawonList]"+query);
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

}
