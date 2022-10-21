/**
 * ����
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_mng;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.common.*;
import acar.user_mng.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class CarMngDatabase {

    private static CarMngDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool�� ���� Connection ��ü�� �����ö� ����ϴ� Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // �̱��� Ŭ������ ���� 
    // �����ڸ� private �� ����
    public static synchronized CarMngDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new CarMngDatabase();
        return instance;
    }
    
    private CarMngDatabase() throws DatabaseException {
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
     * �������
     */
    private CarMngBean makeCarMngBean(ResultSet results) throws DatabaseException {

        try {
            CarMngBean bean = new CarMngBean();

            bean.setRent_mng_id(results.getString("RENT_MNG_ID"));				
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));
		    bean.setMng_id(results.getString("MNG_ID"));
		    bean.setMng_nm(results.getString("MNG_NM"));
		    bean.setNote(results.getString("NOTE"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * �ڵ��� ��� ����Ʈ ( 2001/12/28 ) - Kim JungTae
     */
    private RentListBean makeRegListBean(ResultSet results) throws DatabaseException {

        try {
            RentListBean bean = new RentListBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));					//������ID
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//����ڵ�
//		    bean.setRent_dt(results.getString("RENT_DT"));					//�������
//		    bean.setDlv_dt(results.getString("DLV_DT"));					//�������
//		    bean.setBus_id(results.getString("BUS_ID"));					//�������ID
//		    bean.setBus_nm(results.getString("BUS_NM"));					//��������ڸ�
		    bean.setMng_id(results.getString("MNG_ID"));					//�����ID
		    bean.setMng_id2(results.getString("MNG_ID2"));					//�����ID
//		    bean.setMng_nm(results.getString("MNG_NM"));					//������
//			bean.setMng_nm2(results.getString("MNG_NM2"));					//������
//		    bean.setClient_id(results.getString("CLIENT_ID"));					//��ID
		    bean.setClient_nm(results.getString("CLIENT_NM"));					//�� ��ǥ�ڸ�
		    bean.setFirm_nm(results.getString("FIRM_NM"));						//��ȣ
		    bean.setO_tel(results.getString("O_TEL"));						//�繫����ȭ
		    bean.setM_tel(results.getString("M_TEL"));
//		    bean.setFax(results.getString("FAX"));						//FAX
//		    bean.setBr_id(results.getString("BR_ID"));						//
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));					//�ڵ�������ID
		    bean.setInit_reg_dt(results.getString("INIT_REG_DT"));					//���ʵ����
//		    bean.setReg_gubun(results.getString("REG_GUBUN"));					//���ʵ����
		    bean.setCar_no(results.getString("CAR_NO"));						//������ȣ
//		    bean.setCar_num(results.getString("CAR_NUM"));						//�����ȣ
		    bean.setRent_way(results.getString("RENT_WAY"));					//�뿩���
		    bean.setCon_mon(results.getString("CON_MON"));						//�뿩����
//		    bean.setCar_id(results.getString("CAR_ID"));						//����ID
//		    bean.setImm_amt(results.getInt("IMM_AMT"));						//������å��
		    bean.setCar_name(results.getString("CAR_NAME"));					//����
//		    bean.setRent_start_dt(results.getString("RENT_START_DT"));				//�뿩������
		    bean.setRent_end_dt(results.getString("RENT_END_DT"));					//�뿩������
//		    bean.setReg_ext_dt(results.getString("REG_EXT_DT"));					//��Ͽ�����
//		    bean.setRpt_no(results.getString("RPT_NO"));						//�����ȣ
//		    bean.setCpt_cd(results.getString("CPT_CD"));						//�����ڵ�
		    //bean.setBank_nm(results.getString("BANK_NM"));						//�����
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
 	/**
     * ������� ��ȸ
     */    
    public CarMngBean getCarMngBean(String rent_mng_id, String rent_l_cd) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        CarMngBean cmb;

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        query = "SELECT a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, a.mng_id as MNG_ID, a.mng_id2 as MNG_ID2, b.user_nm as MNG_NM, a.note as NOTE\n"
        		+ "FROM cont a, users b\n"
        		+ "where a.rent_mng_id='" + rent_mng_id + "' and a.rent_l_cd='" + rent_l_cd + "' and a.mng_id=b.user_id\n";

        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                cmb = makeCarMngBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + rent_l_cd );
 			
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
        return cmb;
    }
	/**
     * ������, �ڵ��� ��� ����Ʈ ��ȸ ( 2002/1/3 ) - Kim JungTae
     */
    public RentListBean [] getRegListAll( String gubun, String gubun_nm, String q_sort ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String sortQuery = "";
        
        String query = "";

		if(gubun.equals("car_no")){
        	subQuery = "and car_no like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("firm_nm")){
        	subQuery = "and c.firm_nm like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("car_nm")){
        	subQuery = "and h.car_name like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("client_nm")){
        	subQuery = "and c.client_nm like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("mng_nm")){
        	subQuery = "and j.user_nm like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("init_reg_dt")){
        	subQuery = "and b.init_reg_dt = replace('" + gubun_nm + "','-','')\n";
        }else if(gubun.equals("r_site")){
        	subQuery = "and a.r_site like '%" + gubun_nm + "%'\n";
	}
	else{
        	subQuery = "and a.car_mng_id=''\n";
        }
        
        query = "select Y.RENT_MNG_ID, Y.RENT_L_CD, Y.RENT_DT, Y.DLV_DT, Y.CLIENT_ID, Y.CLIENT_NM,Y.FIRM_NM,Y.O_TEL,Y.M_TEL,Y.FAX,Y.BR_ID, Y.CAR_MNG_ID, Y.INIT_REG_DT, Y.REG_GUBUN, Y.CAR_NO, Y.CAR_NUM,\n"
		+ "Y.RENT_WAY,Y.CON_MON, Y.RENT_START_DT, Y.RENT_END_DT, Y.CAR_ID, Y.IMM_AMT, Y.REG_EXT_DT, Y.RPT_NO, Y.CAR_NAME, Y.CPT_CD,\n"
		+ "Y.BUS_ID, Y.BUS_NM, Y.MNG_ID, Z.MNG_ID2, Y.MNG_NM, Z.MNG_NM2\n"
		+ "FROM (\n"
		+ "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.m_tel as M_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'�̵��',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME,\n"//
		+ "i.cpt_cd as CPT_CD,\n"
		+ "a.bus_id as BUS_ID, e.user_nm as BUS_NM, a.mng_id as MNG_ID, decode(j.user_nm,null,'�̵��',j.user_nm) as MNG_NM\n"  
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, users j\n"//--, code j
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like upper('%%') and nvl(a.use_yn,'Y')='Y'\n"
		+ "and a.car_mng_id = b.car_mng_id\n"
		+ "and a.client_id = c.client_id\n"
		+ "and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.mng_id = j.user_id(+)\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd and d.rent_st='1'\n"
		+ subQuery
		+ ") Y, ( \n"
		+ "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, a.mng_id2 as MNG_ID2, decode(j.user_nm,null,'�̵��',j.user_nm) as MNG_NM2\n"  
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, users j\n"//--, code j
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like upper('%%') and nvl(a.use_yn,'Y')='Y'\n"
		+ "and a.car_mng_id = b.car_mng_id\n"
		+ "and a.client_id = c.client_id\n"
		+ "and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.mng_id2 = j.user_id(+)\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd and d.rent_st='1'\n"
		+ subQuery
		+ ") Z \n"
		+ "where Y.RENT_L_CD = Z.RENT_L_CD \n"
		+ "order by Y.firm_nm " + q_sort ;

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
     * ������, �ڵ��� ��� ����Ʈ ��ȸ
     */
    public RentListBean [] getRegListAll2( String gubun, String gubun_nm, String q_sort) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";

		if(gubun.equals("car_no")){
        	subQuery = "and car_no like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("firm_nm")){
        	subQuery = "and c.firm_nm like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("car_nm")){
        	subQuery = "and h.car_name like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("client_nm")){
        	subQuery = "and c.client_nm like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("mng_nm")){
        	subQuery = "and j.user_nm like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("init_reg_dt")){
        	subQuery = "and b.init_reg_dt = replace('" + gubun_nm + "','-','')\n";
        }else if(gubun.equals("r_site")){
        	subQuery = "and a.r_site like '%" + gubun_nm + "%'\n";
		}else{
        	subQuery = "and a.car_mng_id=''\n";
        }
        
        query = " select"+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.car_no,"+
				"        decode(b.init_reg_dt,null,'�̵��',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as init_reg_dt,"+
				"        h.car_name, c.client_nm, c.firm_nm, c.o_tel, c.m_tel, d.rent_way, d.con_mon,"+
				"        decode(e.rent_end_dt,null,'',substr(e.rent_end_dt,1,4)||'-'||substr(e.rent_end_dt,5,2)||'-'||substr(e.rent_end_dt,7,2)) as rent_end_dt,"+
				"        a.mng_id, a.mng_id2"+
				" from   cont a, car_reg b, client c, fee d, car_etc g, car_nm h, "+
				"        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) e \n"+
				" where  nvl(a.use_yn,'Y')='Y' and d.rent_st='1'\n"+
				"        and a.car_mng_id = b.car_mng_id\n"+
				"        and a.client_id = c.client_id\n"+
				"        and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"+
				"        and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"+
				"        and g.car_id = h.car_id and g.car_seq=h.car_seq "+
//				"        and d.rent_st <> '2'\n"+
				"        and d.rent_mng_id = e.rent_mng_id and d.rent_l_cd = e.rent_l_cd and d.rent_st=e.rent_st\n"+
				subQuery+
				"order by c.firm_nm "+ q_sort ;

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
     * ����� ��ü ��ȸ.
     */
    public UsersBean [] getUserAll() throws DatabaseException, DataSourceEmptyException{
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
        				+ "a.USER_EMAIL,\n"
        				+ "a.USER_POS,\n"
        				+ "a.USER_AUT\n"
        		+ "FROM USERS a, BRANCH b, CODE c\n"
        		+ "where  a.BR_ID = b.BR_ID\n"
        		+ "and c.C_ST = '0002'\n"
        		+ "and c.CODE = a.DEPT_ID\n";
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
     * ������� ����.
     */
    public int updateCarMng(CarMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query="UPDATE CONT\n"
        	+ "SET MNG_ID=?,\n"
				+ "MNG_ID2=?,\n"
				+ "NOTE=?\n"
            + "WHERE RENT_MNG_ID=? AND RENT_L_CD=?";
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, bean.getMng_id().trim());
			pstmt.setString(2, bean.getMng_id2().trim());
            pstmt.setString(3, bean.getNote().trim());
            pstmt.setString(4, bean.getRent_mng_id().trim());
            pstmt.setString(5, bean.getRent_l_cd().trim());

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
