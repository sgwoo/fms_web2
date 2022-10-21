package acar.bill_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.util.*;
import acar.common.*;
import acar.cont.*;
import card.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class NeoErpUDatabase
{
	private static NeoErpUDatabase instance;
	private Connection conn = null;
	private DBConnectionManager connMgr;   

	private final String DATA_SOURCE	= "acar";
	private final String DATA_SOURCE1	= "neoe"; 
 
	public static synchronized NeoErpUDatabase getInstance() {
		if (instance == null)
			instance = new NeoErpUDatabase();
		return instance;
	}
    
   	private NeoErpUDatabase()  {
		connMgr = DBConnectionManager.getInstance();
	}
	


	/**
     * �׿���-�ŷ�ó �ڵ� ��ȸ - ����
     */
    public String getVenCode(String ssn, String enp_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs2 = null;        
        String query1 = "", query2 = "";
		String ven_code = "";
		String ven_code2 = "";
        
        /*
        query1 = " SELECT ven_code FROM vendor WHERE s_idno='"+enp_no+"'";
        query2 = " SELECT ven_code FROM vendor WHERE id_no='"+ssn+"'";
        */
        
        query1 = " SELECT cd_partner  as ven_code FROM MA_PARTNER WHERE no_company='"+enp_no+"'";
        query2 = " SELECT cd_partner  as ven_code FROM MA_PARTNER WHERE no_res='"+ssn+"'  and nvl(no_company, '8888888888' ) = '8888888888'   ";

		try{
            pstmt = con1.prepareStatement(query1);
            rs = pstmt.executeQuery(query1);

            if(rs.next()){                
				ven_code = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
            pstmt.close();

            pstmt2 = con1.prepareStatement(query2);
            rs2 = pstmt2.executeQuery(query2);

            if(rs2.next()){                
				ven_code2 = rs2.getString(1)==null?"":rs2.getString(1);
			}
            rs2.close();
            pstmt2.close();

			if(ven_code.equals("") && !ssn.equals("")){
				ven_code = ven_code2;
			}
//			 System.out.println("[NeoErpUDatabasegetVenCode]"+query1);
//			 System.out.println("[NeoErpUDatabase:getVenCode]"+query2);
        }catch(SQLException se){
			 System.out.println("[NeoErpUDatabase:getVenCode]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ven_code;
    }


	/**
     * �׿���-�ŷ�ó����
     */
    public CodeBean [] getCodeAll(String cpt_nm, String car_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		if(car_no.length() > 6)		car_no = car_no.substring(5);        
		if(cpt_nm.length() > 14)	cpt_nm = cpt_nm.substring(0,14);

/*
        query = " SELECT c_code as C_ST, ven_code as CODE, ven_name as NM, ven_name as NM_CD "+
        		" FROM   vendor "+//dzais.
        		" where  c_code = '1000' and ven_name like '%"+cpt_nm+"%"+car_no+"%' "+
				" order by ven_name";
*/

        query = " select cd_company as C_ST, cd_partner as CODE, ln_partner as NM, ln_partner as NM_CD \n"+
				" from   MA_PARTNER \n"+
				" WHERE  cd_company='1000' AND ln_partner LIKE '%"+cpt_nm+"%"+car_no+"%' \n"+
				" ORDER BY ln_partner";


        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con1.prepareStatement(query);
			rs = pstmt.executeQuery();
            while(rs.next()){                
	            CodeBean bean = new CodeBean();
	            bean.setC_st	(rs.getString("C_ST"));					//�ڵ�з�
			    bean.setCode	(rs.getString("CODE"));					//�ڵ�(����������)
			    bean.setNm_cd	(rs.getString("NM_CD"));				//����ڵ��
				bean.setNm		(rs.getString("NM"));					//��Ī
				col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getCodeAll(String cpt_nm, String car_no)]"+se);
			System.out.println("[NeoErpUDatabase:getCodeAll(String cpt_nm, String car_no)]"+query);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (CodeBean[])col.toArray(new CodeBean[0]);
    } 

	/**
     * �׿���-�ŷ�ó����
     */
    public CodeBean [] getCodeAll(String cpt_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		if(cpt_nm.length() > 14)	cpt_nm = cpt_nm.substring(0,14);


        query = " select cd_company as C_ST, cd_partner as CODE, ln_partner as NM, ln_partner as NM_CD, no_company as APP_ST, no_res as CMS_BK \n"+
				" from   MA_PARTNER \n"+
				" WHERE  cd_company='1000' AND ln_partner LIKE '%"+cpt_nm+"%' \n"+
				" ORDER BY ln_partner";


        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con1.prepareStatement(query);
			rs = pstmt.executeQuery();
            while(rs.next()){                
	            CodeBean bean = new CodeBean();
	            bean.setC_st	(rs.getString("C_ST"));					//�ڵ�з�
			    bean.setCode	(rs.getString("CODE"));					//�ڵ�(����������)
			    bean.setNm_cd	(rs.getString("NM_CD"));				//����ڵ��
				bean.setNm		(rs.getString("NM"));					//��Ī
				bean.setApp_st	(rs.getString("APP_ST"));				//��Ÿ
				bean.setCms_bk	(rs.getString("CMS_BK"));				//��Ÿ
				col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getCodeAll(String cpt_nm)]"+se);
			System.out.println("[NeoErpUDatabase:getCodeAll(String cpt_nm)]"+query);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (CodeBean[])col.toArray(new CodeBean[0]);
    } 
	
	/**
     * �׿���-��ü����Ʈ
     */
    public CodeBean [] getCodeAllVen(String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
        
		if (t_wd.length() > 14)	t_wd = t_wd.substring(0,14);
/*
        query = " SELECT c_code as C_ST, ven_code as CODE, ven_name as NM, nvl(s_idno,id_no) as NM_CD"+
        		" FROM vendor"+//dzais.
        		" where c_code = '1000'";
				
		query += " and ven_name||s_idno||id_no like '%"+t_wd+"%'";

		query += " order by ven_name";
*/

        query = " select cd_company as C_ST, cd_partner as CODE, ln_partner as NM, nvl(no_company,no_res) as NM_CD \n"+
				" from   MA_PARTNER \n"+
				" WHERE  cd_company='1000' AND ln_partner||no_company||no_res like '%"+t_wd+"%' \n"+
				" ORDER BY ln_partner";


        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
            while(rs.next()){                
	            CodeBean bean = new CodeBean();
	            bean.setC_st(rs.getString("C_ST"));					//�ڵ�з�
			    bean.setCode(rs.getString("CODE"));					//�ڵ�(����������)
			    bean.setNm_cd(rs.getString("NM_CD"));				//����ڵ��
				bean.setNm(rs.getString("NM"));						//��Ī
				col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getCodeAllVen]"+se);
			System.out.println("[NeoErpUDatabase:getCodeAllVen]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }

   /**
     *	�ŷ�ó�ڵ� ��ȸ�ϱ�
     */
    public String getCustCodeNext() throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String cust_code = "";
		String min_code = "1000000";
		String max_code = "1999999";
                
		query = " select nvl(to_char(max(cd_partner)+1),'1000001') "+
				" from   MA_PARTNER "+
				" where  cd_company='1000' AND LENGTH(cd_partner)=7 AND cd_partner between '"+min_code+"' and '"+max_code+"' ";

		try{
    
			//�ŷ�ó�ڵ� �̱�
			pstmt = con1.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next()){
				cust_code = rs.getString(1).trim();
			}

			rs.close();
            pstmt.close();
    
		}catch(SQLException se){
				System.out.println("[NeoErpUDatabase:getCustCodeNext]"+se);
				System.out.println("[NeoErpUDatabase:getCustCodeNext]"+query);
				 throw new DatabaseException();
		}finally{
			try{
				if(rs != null )		rs.close();
	            if(pstmt != null)	pstmt.close();
			}catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
		}
		return cust_code;
	}

    /**
     *	�ŷ�ó ���
     */
    public boolean insertTrade(TradeBean t_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
		boolean flag = true;

                
//		String cust_code = getCustCodeNext();

		PreparedStatement pstmt2 = null;
        ResultSet rs = null;
        String query2 = "";
        String cust_code = "";
		String min_code = "1000000";
		String max_code = "1999999";

		query2 = " select nvl(to_char(max(cd_partner)+1),'1000001') "+
				" from   MA_PARTNER "+
				" where  cd_company='1000' AND LENGTH(cd_partner)=7 AND cd_partner between '"+min_code+"' and '"+max_code+"' ";

                

		query = " insert into MA_PARTNER ( "+
				"             CD_COMPANY, CD_PARTNER, LN_PARTNER, SN_PARTNER, FG_PARTNER,"+
				"             NO_COMPANY, NM_CEO, NO_POST1, DC_ADS1_H, SD_PARTNER, USE_YN, NO_RES, TP_JOB, CLS_JOB )\n"+
				" values("+
				"             '1000', ?, ?, replace(replace(?,'(��)',''),'(��)',''), '001',"+
				"             replace(?,'-',''), ?, ?, ?, to_char(sysdate,'YYYYMMDD'), 'Y', replace(?,'-',''), ?, ?)";

	   try{

            con1.setAutoCommit(false);

			//�ŷ�ó�ڵ� �̱�
			pstmt2 = con1.prepareStatement(query2);
			rs = pstmt2.executeQuery();
			if(rs.next()){
				cust_code = rs.getString(1).trim();
			}
			rs.close();
            pstmt2.close();

			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, cust_code			  );
			pstmt.setString(2, AddUtil.substringb(t_bean.getCust_name(),100));
			pstmt.setString(3, AddUtil.substringb(t_bean.getCust_name(),90));
			pstmt.setString(4, t_bean.getS_idno		());
			pstmt.setString(5, t_bean.getDname		());
			pstmt.setString(6, t_bean.getMail_no	());
			pstmt.setString(7, t_bean.getS_address	());
			pstmt.setString(8, t_bean.getId_no		());
			pstmt.setString(9, t_bean.getUptae		());
			pstmt.setString(10,t_bean.getJong		());
			pstmt.executeUpdate();						
            pstmt.close();

            con1.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[NeoErpUDatabase:insertTrade]"+se);
				System.out.println("[NeoErpUDatabase:cust_code			  ]"+cust_code			  );
				System.out.println("[NeoErpUDatabase:t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[NeoErpUDatabase:t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[NeoErpUDatabase:t_bean.getS_idno	()]"+t_bean.getS_idno	());
				System.out.println("[NeoErpUDatabase:t_bean.getDname	()]"+t_bean.getDname	());
				System.out.println("[NeoErpUDatabase:t_bean.getMail_no	()]"+t_bean.getMail_no	());
				System.out.println("[NeoErpUDatabase:t_bean.getS_address()]"+t_bean.getS_address());
				System.out.println("[NeoErpUDatabase:t_bean.getId_no	()]"+t_bean.getId_no	());
				System.out.println("[NeoErpUDatabase:t_bean.getUptae	()]"+t_bean.getUptae	());
				System.out.println("[NeoErpUDatabase:t_bean.getJong		()]"+t_bean.getJong		());
				System.out.println("[NeoErpUDatabase:t_bean.getUser_id	()]"+t_bean.getUser_id	());
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
				if(rs != null )		rs.close();
	            if(pstmt2 != null)	pstmt2.close();
                if(pstmt != null)	pstmt.close();
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return flag;
    }

    /**
     *	�ŷ�ó ����
     */
    public boolean updateTrade(TradeBean t_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
		boolean flag = true;
                
		query =" update MA_PARTNER set "+
				"       LN_PARTNER	= ?, "+
				"       SN_PARTNER	= replace(replace(?,'(��)',''),'(��)',''), "+
				"       NM_CEO		= ?, "+
				"       NO_POST1		= replace(?,'-',''), "+
				"       DC_ADS1_H	= ?, "+
				"       NO_RES		= replace(?,'-',''), "+
				"       NO_COMPANY	= replace(?,'-',''), "+
				"       NM_PTR		= ?, "+
				"       USE_YN   	= ?, "+
				"       TP_JOB		= ?, "+
				"       CLS_JOB		= ?  "+
				" where CD_COMPANY='1000' and CD_PARTNER=?";

	   try{

            con1.setAutoCommit(false);

			pstmt = con1.prepareStatement(query);
			pstmt.setString(1,  t_bean.getCust_name	());
			pstmt.setString(2,  t_bean.getCust_name	());
			pstmt.setString(3,  t_bean.getDname		());
			pstmt.setString(4,  t_bean.getMail_no	());
			pstmt.setString(5,  t_bean.getS_address	());
			pstmt.setString(6,  t_bean.getId_no		());
			pstmt.setString(7,  t_bean.getS_idno	());
			pstmt.setString(8,  t_bean.getDc_rmk	());
			pstmt.setString(9,  t_bean.getMd_gubun	());
			pstmt.setString(10, t_bean.getUptae		());
			pstmt.setString(11, t_bean.getJong		());
			pstmt.setString(12, t_bean.getCust_code	());
			pstmt.executeUpdate(); 
            pstmt.close();

            con1.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[NeoErpUDatabase:updateTrade]"+se);
				System.out.println("[t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[t_bean.getDname	()]"+t_bean.getDname	());
				System.out.println("[t_bean.getMail_no	()]"+t_bean.getMail_no	());
				System.out.println("[t_bean.getS_address()]"+t_bean.getS_address());
				System.out.println("[t_bean.getId_no	()]"+t_bean.getId_no	());
				System.out.println("[t_bean.getDc_rmk	()]"+t_bean.getDc_rmk	());
				System.out.println("[t_bean.getMd_gubun	()]"+t_bean.getMd_gubun	());
				System.out.println("[t_bean.getCust_code()]"+t_bean.getCust_code());
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return flag;
    }

	/**
     * �׿���-�ŷ�ó �ڵ� ��ȸ
     */
    public String getCustCode2(String s_idno, String cust_name) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		String cust_code = "";
        
        query = " SELECT CD_PARTNER FROM MA_PARTNER WHERE NO_COMPANY=replace('"+s_idno+"','-','') and LN_PARTNER='"+cust_name+"'";

		try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
            if(rs.next()){                
				cust_code = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[NeoErpUDatabase:getCustCode2]"+se);
			 System.out.println("[NeoErpUDatabase:getCustCode2]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return cust_code;
    }

	/**
     * �׿���-�ŷ�ó �ڵ� ��ȸ
     */
    public String getVenCodeChk(String ven_st, String cust_name, String ssn, String enp_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		String ven_code = "";
        

		if(ven_st.equals("2")){//����
			query = " SELECT CD_PARTNER FROM MA_PARTNER WHERE NO_RES='"+ssn+"' and LN_PARTNER='"+cust_name+"'";	
		}else{//����
			query = " SELECT CD_PARTNER FROM MA_PARTNER WHERE NO_COMPANY='"+enp_no+"' and LN_PARTNER='"+cust_name+"'";	
		}

		try{

            pstmt = con1.prepareStatement(query);
	        rs = pstmt.executeQuery();

			if(rs.next()){                
				ven_code = rs.getString(1)==null?"":rs.getString(1);
			}
	        rs.close();
		    pstmt.close();
	
        }catch(SQLException se){
			 System.out.println("[NeoErpUDatabase:getVenCodeChk]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ven_code;
    }

	/**
     * �׿���-���ฮ��Ʈ
     */
    public CodeBean [] getCodeAll() throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

/*        
        query = " SELECT c_code as C_ST, checkd_code as CODE, checkd_name as NM, checkd_name as NM_CD"+
        		" FROM checkd"+//dzais.
        		" where check_code='A03' and c_code = '1000'"+
				" order by decode(checkd_name, '����','1', '�ϳ�','2', '����','3', '9'), checkd_name";
*/

        query = " select cd_company as C_ST, cd_partner  as CODE, ln_partner as NM, ln_partner as NM_CD \n"+
				" from   MA_PARTNER \n"+
				" WHERE  fg_partner='002' and cd_company='1000' \n"+
				" ORDER BY decode(SUBSTR(ln_partner,1,2), '����','1', '�ϳ�','2', '����','3', '9'), ln_partner \n"+
				" ";

		Collection<CodeBean> col = new ArrayList<CodeBean>();

        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
            while(rs.next()){                
	            CodeBean bean = new CodeBean();
	            bean.setC_st	(rs.getString("C_ST"));					//�ڵ�з�
			    bean.setCode	(rs.getString("CODE"));					//�ڵ�(����������)
			    bean.setNm_cd	(rs.getString("NM_CD"));				//����ڵ��
				bean.setNm		(rs.getString("NM"));					//��Ī
				col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getCodeAll()]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }


		/**
     * �׿���-���ฮ��Ʈ
     */
    public CodeBean [] getInsideCodeAll() throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

/*        
        query = " select cd_company as C_ST, cd_partner  as CODE, ln_partner as NM, ln_partner as NM_CD \n"+
				" from   MA_PARTNER \n"+
				" WHERE  fg_partner='002' and cd_company='1000' \n"+
				" ORDER BY decode(SUBSTR(ln_partner,1,2), '����','1', '�ϳ�','2', '����','3', '9'), ln_partner \n"+
				" ";
*/
		
		//���� erp ������ �ִ� ���ุ 
		 query = " 	 select distinct  a.cd_company as C_ST, a.cd_partner  as CODE, a.ln_partner as NM, a.ln_partner as NM_CD \n"+
					  "		 from   neoe.MA_PARTNER  a,  amazoncar.erp_bank b \n"+
					  "		 WHERE  fg_partner='002' and cd_company='1000'  \n"+
			        "         and a.cd_partner  = substr(b.bank_nm, 0, 3)  \n"+
					  "		 ORDER BY decode(SUBSTR(ln_partner,1,2), '����','1', '�ϳ�','2', '����','3', '9'), ln_partner ";
	
		Collection<CodeBean> col = new ArrayList<CodeBean>();

        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
            while(rs.next()){                
	            CodeBean bean = new CodeBean();
	            bean.setC_st	(rs.getString("C_ST"));					//�ڵ�з�
			    bean.setCode	(rs.getString("CODE"));					//�ڵ�(����������)
			    bean.setNm_cd	(rs.getString("NM_CD"));				//����ڵ��
				bean.setNm		(rs.getString("NM"));					//��Ī
				col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getCodeAll()]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }

	
	
	
    
	/**
     * �׿���-�ŷ�ó ���� ��ȸ
     */
    public Hashtable getVendorCase(String ven_code) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1); //neom
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
 
 /*       
        query = " SELECT * FROM vendor WHERE ven_code='"+ven_code+"'";
*/

        query = " select cd_partner as ven_code, ln_partner as ven_name, \n"+
                "        tp_job,  cls_job,  dc_ads1_h as ads_hd,  nm_ceo, no_company as s_idno , e_mail  \n"+
				" from   MA_PARTNER \n"+
				" WHERE  cd_partner=replace('"+ven_code+"',' ','') \n";
		try{
            pstmt = con1.prepareStatement(query);
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
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getVendorCase(String ven_code)]"+se);
			System.out.println("[NeoErpUDatabase:getVendorCase(String ven_code)]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ht;
    }

	/**
     * �׿���-�ŷ�ó ���� ��ȸ
     */
    public Hashtable getVendorCaseS(String ven_code, String s_idno) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1); //neom
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
 
        query = " select cd_partner as ven_code, ln_partner as ven_name, \n"+
                "        tp_job,  cls_job,  dc_ads1_h as ads_hd,  nm_ceo  \n"+
				" from   MA_PARTNER \n"+
				" WHERE  cd_company='1000' \n";

		if(!ven_code.equals(""))	query += " and cd_partner='"+ven_code+"'";
		if(!s_idno.equals(""))		query += " and no_company=replace('"+s_idno+"','-','')";


		try{
            pstmt = con1.prepareStatement(query);
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
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getVendorCaseS(String ven_code, String s_idno)]"+se);
			System.out.println("[NeoErpUDatabase:getVendorCaseS(String ven_code, String s_idno)]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ht;
    }

	/**
     * �׿���-���� ���¹�ȣ ����Ʈ
     */
    public Vector getDepositList(String bank_code) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Vector vt = new Vector();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
 
 /*       
        query = " SELECT deposit_name, deposit_no"+
        		" FROM depositma"+//dzais.
        		" where bank_code='"+bank_code+"' AND node_code='S101' "+// order by deposit_no
				" order by decode(deposit_name, '�����������(8623)','1', '9'), deposit_no";
*/

        query = " select a.nm_deposit AS deposit_name, a.no_deposit AS deposit_no, a.cd_bank, a.cd_bank_send, yn_use \n"+
				" from   FI_DEPOSIT a, MA_PARTNER b \n"+
				" WHERE  a.cd_company='1000' AND NVL(a.yn_use,'Y')='Y' AND a.CD_BANK=b.cd_partner(+) and a.cd_bank='"+bank_code+"'   \n"+
				" ORDER BY decode(SUBSTR(a.nm_deposit,1,2), '����','1', '�ϳ�','2', '����','3', '9'), a.nm_deposit \n"+
				" ";

	    try{
            pstmt = con1.prepareStatement(query);
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
			System.out.println("[NeoErpUDatabase:getDepositList(String bank_code)]"+se);
			System.out.println("[NeoErpUDatabase:getDepositList(String bank_code)]"+query);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return vt;
    }

	/**
     * �׿���-���� ���¹�ȣ ����Ʈ
     */
    public Vector getFeeDepositList() throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1); //neom
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Vector vt = new Vector();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
/*        
        query = " select b.checkd_name, a.* "+
				" from   depositma a, checkd b "+
				" where  a.bank_code=b.checkd_code "+
				"        and b.check_code='A03' and b.c_code = '1000' "+
				"        and a.termi_date='00000000' "+
				"        and a.deposit_name not like '%�̻��%' "+
				"        and a.deposit_name not like '%MMF%' "+
				"        and a.deposit_name not like '%����%' "+
				"        and a.deposit_name not like '%����%' "+
				"        and a.deposit_name not like '%�ڵ���%' "+
				"        and a.deposit_name not like '%����%' "+
				"		 and a.deposit_no not in ('221-181337-31-00031')"+
				" order by decode(b.checkd_name, '����','1', '�ϳ�','2', '����','3', '9'), b.checkd_name, a.deposit_no";
*/

        query = " select a.nm_deposit AS deposit_name, a.no_deposit AS deposit_no, a.cd_bank, a.cd_bank_send, yn_use, NVL(b.ln_partner,SUBSTR(a.nm_deposit,1,2)) as checkd_name \n"+
				" from   FI_DEPOSIT a, MA_PARTNER b \n"+
				" WHERE  a.cd_company='1000' AND NVL(a.yn_use,'Y')='Y' AND a.CD_BANK=b.cd_partner(+) \n"+
				"        and a.nm_deposit not like '%�̻��%' "+
				"        and a.nm_deposit not like '%MMF%' "+
				"        and a.nm_deposit not like '%����%' "+
				"        and a.nm_deposit not like '%����%' "+
				"        and a.nm_deposit not like '%�ڵ���%' "+
				"        and a.nm_deposit not like '%����%' "+
				"        and a.nm_deposit not like '%�Һ�%' "+
				"        and a.nm_deposit not like '%����%' "+
				"        and a.nm_deposit not like '%����%' "+
				"		 and a.no_deposit not in ('221-181337-31-00031')"+
				" ORDER BY decode(SUBSTR(a.nm_deposit,1,2), '����','1', '�ϳ�','2', '����','3', '9'), a.nm_deposit, b.ln_partner, a.no_deposit \n"+
				" ";

	    try{
            pstmt = con1.prepareStatement(query);
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
			System.out.println("[NeoErpUDatabase:getFeeDepositList]"+se);
			System.out.println("[NeoErpUDatabase:getFeeDepositList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return vt;
    }

	/**
     * �׿���-���� ���¹�ȣ ����Ʈ
     */
    public Hashtable getFeeDepositCase(String deposit_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1); 
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " select a.nm_deposit AS deposit_name, a.no_deposit AS deposit_no, a.cd_bank as bank_code, a.cd_bank_send, yn_use, NVL(b.ln_partner,SUBSTR(a.nm_deposit,1,2)) as checkd_name \n"+
				" from   FI_DEPOSIT a, MA_PARTNER b \n"+
				" WHERE  a.no_deposit='"+deposit_no+"' and a.cd_company='1000' AND NVL(a.yn_use,'Y')='Y' AND a.CD_BANK=b.cd_partner(+) \n"+
				"        and a.nm_deposit not like '%�̻��%' "+
				"        and a.nm_deposit not like '%MMF%' "+
				"        and a.nm_deposit not like '%����%' "+
				"        and a.nm_deposit not like '%����%' "+
				"        and a.nm_deposit not like '%�ڵ���%' "+
				"        and a.nm_deposit not like '%����%' "+
				"        and a.nm_deposit not like '%�Һ�%' "+
				"        and a.nm_deposit not like '%����%' "+
				"        and a.nm_deposit not like '%����%' "+
				"		 and a.no_deposit not in ('221-181337-31-00031')"+
				" ORDER BY decode(SUBSTR(a.nm_deposit,1,2), '����','1', '�ϳ�','2', '����','3', '9'), a.nm_deposit, b.ln_partner, a.no_deposit \n"+
				" ";


	    try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);
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
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getFeeDepositCase]"+se);
			System.out.println("[NeoErpUDatabase:getFeeDepositCase]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ht;
    }

	/**
     * �׿���-�����ڵ��
     */
    public String getCodeByNm(String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//dzais
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		String nm = "";
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		if(!t_wd.equals("")){

			if(s_kd.equals("cardno")){//�ſ�ī��

//			    query = " SELECT card_name as name    FROM cardmana  where cardno = '"+t_wd+"'";  

			    query = " SELECT nm_card as name      FROM FI_CARD   where no_card = '"+t_wd+"'";  
	
//			}else if(s_kd.equals("item")){//ǰ��
//
//			    query = " SELECT nm_item as name      FROM v_item    where cd_item = '"+t_wd+"'";  
	
			}else if(s_kd.equals("ven")){//�ŷ�ó

//				query = " SELECT ven_name as name     FROM vendor    where ven_code = '"+t_wd+"'";

				query = " SELECT ln_partner as name   FROM MA_PARTNER where cd_partner = '"+t_wd+"'";
	
			}else if(s_kd.equals("depositma")){//���¹�ȣ

//				query = " SELECT deposit_name as name FROM depositma where deposit_no = '"+t_wd+"'";  

				query = " SELECT nm_deposit as name   FROM FI_DEPOSIT where no_deposit = '"+t_wd+"'";  
	
			}else if(s_kd.equals("bank")){//����

//				query = " SELECT checkd_name as name  FROM checkd    where check_code='A03' and c_code = '1000' and checkd_code ='"+t_wd+"'";  

				query = " SELECT ln_partner as name  FROM MA_PARTNER where fg_partner='002' and cd_company = '1000' and cd_partner ='"+t_wd+"'";  
	
			}
		}
        
     	
     		
	    try{
			if(!query.equals("")){
	            pstmt = con1.prepareStatement(query);
		        rs = pstmt.executeQuery();
			    if(rs.next()){                
					nm = rs.getString(1)==null?"":rs.getString(1);
	            }
		        rs.close();
			    pstmt.close();            
			}
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getCodeByNm]"+se);
			System.out.println("[NeoErpUDatabase:getCodeByNm]"+s_kd);
			System.out.println("[NeoErpUDatabase:getCodeByNm]"+t_wd);
			System.out.println("[NeoErpUDatabase:getCodeByNm]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return nm;
    }

	/**
     * �׿���-�����ڵ� ����Ʈ
     */
    public Vector getCodeSearch(String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//dzais
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Vector vt = new Vector();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		if(s_kd.equals("cardno")){//�ſ�ī��

/*
	        query = " SELECT cardno as code, card_name as name, card_sdate, replace(card_edate,' ','') card_edate, etc FROM cardmana";

			if(!t_wd.equals("")) query += " where cardno||card_name like '%"+t_wd+"%'";  
	
			query += " order by card_name";
*/

	        query = " SELECT no_card as code, nm_card as name, '' as card_sdate, dt_use||'01' as card_edate, etc_card as etc FROM FI_CARD";

			if(!t_wd.equals("")) query += " where no_card||nm_card like '%"+t_wd+"%'";  
	
			query += " order by nm_card";

		
//		}else if(s_kd.equals("item")){//ǰ��
//
//	        query = " SELECT cd_item as code, nm_item as name FROM v_item";
//
//			if(!t_wd.equals("")) query += " where nm_item like '%"+t_wd+"%'";  
//	
//			query += " order by nm_item";

		}else if(s_kd.equals("ven")){//�ŷ�ó

/*
			query = " SELECT ven_code as code, ven_name as name, s_idno, id_no FROM vendor";

			if(!t_wd.equals("")) query += " where ven_name like '%"+t_wd+"%'";  
	
			query += " order by ven_name";
*/

			query = " SELECT cd_partner as code, ln_partner as name, no_company as s_idno, no_res as id_no FROM MA_PARTNER";

			if(!t_wd.equals("")) query += " where ln_partner like '%"+t_wd+"%'";  
	
			query += " order by ln_partner";


		}else if(s_kd.equals("depositma")){//���¹�ȣ

/*
			query = " SELECT deposit_no as code, deposit_name as name FROM depositma";

			if(!t_wd.equals("")) query += " where deposit_name like '%"+t_wd+"%'";  
	
			query += " order by deposit_name";
*/

			query = " SELECT no_deposit as code, nm_deposit as name FROM FI_DEPOSIT";

			if(!t_wd.equals("")) query += " where nm_deposit like '%"+t_wd+"%'";  
	
			query += " order by nm_deposit";

		}
        
	    try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);
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
			System.out.println("[NeoErpUDatabase:getCodeSearch]"+se);
			System.out.println("[NeoErpUDatabase:getCodeSearch]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return vt;
    }

	/**
     * �׿���-�����/�ͼӺμ��ڵ�
     */
    public Hashtable getPerinfoDept(String user_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        Hashtable ht = new Hashtable();
        String query = "";
  
  /*      
        query = " SELECT a.*, b.dept_name"+
        		" FROM v_perinfo a, v_deptcode b"+//dzais.
        		" where a.dept_code=b.dept_code and a.c_code = '1000' and a.kname='"+user_nm+"'";
*/				

        query = " SELECT a.no_emp AS sa_code, a.CD_DEPT AS dept_code, a.CD_BIZAREA AS node_code, b.NM_DEPT AS dept_name \n"+
				" FROM   MA_EMP a, MA_DEPT b \n"+
				" WHERE  a.CD_DEPT=b.CD_DEPT \n"+
				"        and a.cd_company = '1000' AND nm_kor='"+user_nm+"'";


		try{
            pstmt = con1.prepareStatement(query);
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
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getPerinfoDept]"+se);
			System.out.println("[NeoErpUDatabase:getPerinfoDept]"+query);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ht;
    }

	/**
     * �׿���-��ü����Ʈ
     */
    public String getVendorEnpNo(String ven_code) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String enp_no = "";
        String query = "";
        
/*   
        query = " SELECT nvl(s_idno,id_no) enp_no"+
        		" FROM vendor"+//dzais.
        		" where c_code = '1000' and ven_code='"+ven_code+"'";
*/

				
        query = " SELECT nvl(no_company,no_res) enp_no"+
        		" FROM   MA_PARTNER"+
        		" where  cd_company = '1000' and cd_partner='"+ven_code+"'";
		
		try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
            if(rs.next()){                
				enp_no = rs.getString("enp_no")==null?"":rs.getString("enp_no");
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getVendorEnpNo]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return enp_no;
    }

    /* ī���� */
 
    public int insertCardmana(CardBean c_bean, Hashtable per, Hashtable br) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);	//neoe

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
       
        PreparedStatement pstmt2 = null;           
        String query2 = "";
        int count = 0;

		query2 =" insert into fi_card \n"+
				" ( \n"+
				"        no_card, cd_company, nm_card, \n"+
                "        tp_card, st_card, dt_use, yn_use, \n"+
				"        no_deposit, etc_card  \n"+
				" ) \n"+
				" values( \n"+
				"        ?, '1000', ?, \n"+
				"        '1', '1', substr(replace(?,'-',''),1,6), 'Y', \n"+
				"        ?, ? \n"+
				" )";

	   try{

            con1.setAutoCommit(false);
	
			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1,  c_bean.getCardno		());
			pstmt2.setString(2,  c_bean.getCard_name	());
			pstmt2.setString(3,  c_bean.getCard_edate	());
			pstmt2.setString(4,  c_bean.getAcc_no		());
			pstmt2.setString(5,  AddUtil.substringb(c_bean.getEtc(),100));			
			pstmt2.executeUpdate();
			pstmt2.close();

            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[NeoErpUDatabase:insertCardmana]"+se);
				System.out.println("[NeoErpUDatabase:insertCardmana]"+se);
				System.out.println("[c_bean.getCardno		()]"+c_bean.getCardno		());
				System.out.println("[c_bean.getCard_name	()]"+c_bean.getCard_name	());
				System.out.println("[c_bean.getCard_edate	()]"+c_bean.getCard_edate	());
				System.out.println("[c_bean.getAcc_no		()]"+c_bean.getAcc_no		());
				System.out.println("[c_bean.getEtc			()]"+c_bean.getEtc			());
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con1.setAutoCommit(true);
                if(pstmt2 != null)	pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return count;
    }

    /* ī����� */
 
    public int updateCardmana(CardBean c_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);	//neoe

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
       
        PreparedStatement pstmt2 = null;           
        String query2 = "";
        int count = 0;

		query2 =" update fi_card set	\n"+
				"        nm_card=?,		\n"+
				"        no_deposit=?,	\n"+
				"        etc_card=?		\n"+
				" where no_card=? and cd_company='1000'\n"+
				" ";

	   try{

            con1.setAutoCommit(false);
	
			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1,  c_bean.getCard_name	());
			pstmt2.setString(2,  c_bean.getAcc_no		());
			pstmt2.setString(3,  AddUtil.substringb(c_bean.getEtc(),100));			
			pstmt2.setString(4,  c_bean.getCardno		());
			pstmt2.executeUpdate();
			pstmt2.close();

            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[NeoErpUDatabase:updateCardmana]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con1.setAutoCommit(true);
                if(pstmt2 != null)	pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return count;
    }

    /**
     *	�ŷ�ó (�ŷ�ó�ڵ�,����ڹ�ȣ) �۾��� ��ȸ
     */
    public Hashtable getTradeHisRegIds(String cust_code, String buy_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Hashtable ht = new Hashtable();
        String query = "";
		
		 query = " SELECT a.reg_id AS f_reg_id, a.reg_dt AS f_reg_dt, \n"+
				 "        b.reg_id AS l_reg_id, b.reg_dt AS l_reg_dt  \n"+
				 " FROM   (SELECT reg_id, reg_dt FROM TRADE_HIS WHERE cust_code='"+cust_code+"' AND reg_dt = (SELECT min(reg_dt) FROM TRADE_HIS WHERE cust_code='"+cust_code+"' and to_char(reg_dt,'YYYYMMDD') <='"+buy_dt+"')) a, \n"+
				 "        (SELECT reg_id, reg_dt FROM TRADE_HIS WHERE cust_code='"+cust_code+"' AND reg_dt = (SELECT max(reg_dt) FROM TRADE_HIS WHERE cust_code='"+cust_code+"' and to_char(reg_dt,'YYYYMMDD') <='"+buy_dt+"')) b  \n"+
				 " ";

	   try{

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
		}catch(SQLException se){
				System.out.println("[NeoErpUDatabase:getTradeHisRegIds]"+se);
				System.out.println("[NeoErpUDatabase:getTradeHisRegIds]"+query);
				throw new DatabaseException();
	    }finally{
			try{
				if(rs != null )		rs.close();
	            if(pstmt != null)	pstmt.close();
			}catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
	    return ht;
    }

    /**
     *	�ŷ�ó (�ŷ�ó�ڵ�,����ڹ�ȣ) �ߺ�üũ�ϱ�
     */
    public int getTradeCheck(String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom_b(base)

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
//		query ="select count(*) from trade";
		
//		if(!s_kd.equals(""))	query += " where "+s_kd+" = replace('"+t_wd+"','-','')";


		query ="select count(*) from MA_PARTNER";
		
		if(!s_kd.equals(""))	query += " where no_company = replace('"+t_wd+"','-','')";
		
		try{
   
			pstmt = con1.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next()){
				count = rs.getInt(1);
			}

			rs.close();
            pstmt.close();
    
		}catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getTradeCheck]"+se);
			throw new DatabaseException();
		}finally{
			try{
				if(rs != null )		rs.close();
	            if(pstmt != null)	pstmt.close();
	        }catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
	    }
	    return count;
	}


	/**
     * �׿���-��ü����Ʈ
     */
    public TradeBean [] getBaseTradeSidnoSearchList_yn(String s_kd, String t_wd, String t_wd2, String use_yn) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom_b(base)
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
        
		if (t_wd.length() > 14)	t_wd = t_wd.substring(0,14);

/*
        query = " SELECT * "+
        		" FROM trade"+//dzais.
        		" where c_code = '1000'";
				
		query += " and s_idno||cust_name like '%"+t_wd+"%'";

		if(!t_wd2.equals(""))  query += " and cust_name like '%"+t_wd2+"%'";

		query += " order by s_idno, cust_name";
*/

        query = " SELECT cd_partner as cust_code, ln_partner as cust_name, no_company as s_idno, no_res as id_no, nm_ceo as dname, "+
				"        e_mail as mail_no, dc_ads1_h as s_address, '' md_gubun, dc_rmk "+
        		" FROM   MA_PARTNER"+
        		" where  cd_company = '1000'";
				
		query += " and no_company||ln_partner like '%"+t_wd+"%'";

		if(!use_yn.equals("")){
			query += " and nvl(use_yn,'Y') = '"+use_yn+"' ";
		}
		if(!t_wd2.equals(""))  query += " and ln_partner like '%"+t_wd2+"%'";

		query += " order by no_company, ln_partner";


        Collection<TradeBean> col = new ArrayList<TradeBean>();
        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
            while(rs.next()){                
	            TradeBean bean = new TradeBean();
	            bean.setCust_code	(rs.getString("CUST_CODE"));
			    bean.setCust_name	(rs.getString("CUST_NAME"));
			    bean.setS_idno		(rs.getString("S_IDNO"));
			    bean.setId_no		(rs.getString("ID_NO"));
	        	bean.setDname		(rs.getString("DNAME"));
			    bean.setMail_no		(rs.getString("MAIL_NO"));
			    bean.setS_address	(rs.getString("S_ADDRESS"));
			    bean.setMd_gubun	(rs.getString("MD_GUBUN"));
			    bean.setDc_rmk		(rs.getString("DC_RMK"));
			   col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getBaseTradeSidnoSearchList]"+se);
			System.out.println("[NeoErpUDatabase:getBaseTradeSidnoSearchList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (TradeBean[])col.toArray(new TradeBean[0]);
    }

public TradeBean [] getBaseTradeSidnoSearchList(String s_kd, String t_wd, String t_wd2) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom_b(base)
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
        
		if (t_wd.length() > 14)	t_wd = t_wd.substring(0,14);

/*
        query = " SELECT * "+
        		" FROM trade"+//dzais.
        		" where c_code = '1000'";
				
		query += " and s_idno||cust_name like '%"+t_wd+"%'";

		if(!t_wd2.equals(""))  query += " and cust_name like '%"+t_wd2+"%'";

		query += " order by s_idno, cust_name";
*/

        query = " SELECT cd_partner as cust_code, ln_partner as cust_name, no_company as s_idno, no_res as id_no, nm_ceo as dname, "+
				"        e_mail as mail_no, dc_ads1_h as s_address, '' md_gubun, dc_rmk "+
        		" FROM   MA_PARTNER"+
        		" where  cd_company = '1000'";
				
		query += " and no_company||ln_partner like '%"+t_wd+"%'";


		if(!t_wd2.equals(""))  query += " and ln_partner like '%"+t_wd2+"%'";

		query += " order by no_company, ln_partner";


        Collection<TradeBean> col = new ArrayList<TradeBean>();
        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
            while(rs.next()){                
	            TradeBean bean = new TradeBean();
	            bean.setCust_code	(rs.getString("CUST_CODE"));
			    bean.setCust_name	(rs.getString("CUST_NAME"));
			    bean.setS_idno		(rs.getString("S_IDNO"));
			    bean.setId_no		(rs.getString("ID_NO"));
	        	bean.setDname		(rs.getString("DNAME"));
			    bean.setMail_no		(rs.getString("MAIL_NO"));
			    bean.setS_address	(rs.getString("S_ADDRESS"));
			    bean.setMd_gubun	(rs.getString("MD_GUBUN"));
			    bean.setDc_rmk		(rs.getString("DC_RMK"));
			   col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getBaseTradeSidnoSearchList]"+se);
			System.out.println("[NeoErpUDatabase:getBaseTradeSidnoSearchList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (TradeBean[])col.toArray(new TradeBean[0]);
    }

	/**
     * �׿���-��ü����Ʈ
     */
    public TradeBean [] getBaseTradeList(String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom_b(base)
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
        
		if (t_wd.length() > 14)	t_wd = t_wd.substring(0,14);

        query = " SELECT cd_partner as cust_code, ln_partner as cust_name, no_company as s_idno, no_res as id_no, nm_ceo as dname, "+
				"        e_mail as mail_no, dc_ads1_h as s_address, '' md_gubun, dc_rmk "+
        		" FROM   MA_PARTNER"+
        		" where  cd_company = '1000' and nvl(use_yn,'Y')='Y'";
				
		query += " and no_company||no_res||ln_partner||cd_partner like '%"+t_wd+"%'";

		query += " order by ln_partner";


        Collection<TradeBean> col = new ArrayList<TradeBean>();

        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
            while(rs.next()){                
	            TradeBean bean = new TradeBean();
	            bean.setCust_code	(rs.getString("CUST_CODE"));
			    bean.setCust_name	(rs.getString("CUST_NAME"));
			    bean.setS_idno		(rs.getString("S_IDNO"));
			    bean.setId_no		(rs.getString("ID_NO"));
	        	bean.setDname		(rs.getString("DNAME"));
			    bean.setMail_no		(rs.getString("MAIL_NO"));
			    bean.setS_address	(rs.getString("S_ADDRESS"));
			    bean.setMd_gubun	(rs.getString("MD_GUBUN"));
			    bean.setDc_rmk		(rs.getString("DC_RMK"));
			   col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getBaseTradeList]"+se);
			System.out.println("[NeoErpUDatabase:getBaseTradeList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (TradeBean[])col.toArray(new TradeBean[0]);
    }

	/**
     * �׿���-�ŷ�ó �ڵ� ��ȸ
     */
    public String getVenCode2(String ssn, String enp_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1); //neom
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		String ven_code = "";
        
 //       query = " SELECT ven_code FROM vendor WHERE s_idno='"+enp_no+"'";


        query = " SELECT cd_partner as ven_code FROM MA_PARTNER WHERE no_company='"+enp_no+"'";


		try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
            if(rs.next()){                
				ven_code = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 System.out.println("[NeoErpUDatabase:getVenCode2]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ven_code;
    }

   /**
     *	�ŷ�ó (�ŷ�ó�ڵ�,����ڹ�ȣ) �ߺ�üũ�ϱ�
     */
    public Hashtable getTradeCase(String cust_code) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom_b(base)

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Hashtable ht = new Hashtable();
        String query = "";
		
//     query = " SELECT * FROM trade WHERE cust_code='"+cust_code+"'";


        query = " SELECT cd_partner as cust_code, ln_partner as cust_name, NM_CEO AS DNAME, no_company as s_idno, no_res as id_no, NO_POST1, DC_ADS1_H AS S_ADDRESS, DC_RMK, tp_job, cls_job "+
				" FROM   MA_PARTNER "+
				" WHERE  cd_partner='"+cust_code+"'";

	   try{

            pstmt = con1.prepareStatement(query);
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
    
		}catch(SQLException se){
				System.out.println("[NeoErpUDatabase:getTradeCase]"+se);
				 throw new DatabaseException();
	    }finally{
			try{
				if(rs != null )		rs.close();
	            if(pstmt != null)	pstmt.close();
			}catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
		}
	    return ht;
    }


   /**
     *	�ڵ���ǥ  
     */
    public String insertSetAutoDocu(String write_date,  Vector vt) throws DatabaseException, DataSourceEmptyException{
        Connection con  = connMgr.getConnection(DATA_SOURCE);	//acar
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);	//neom

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;

        String query = "";
        String query2 = "";
         
        String row_id = "";
           
		String table = "fi_adocu";
	        
         query = "select  'AM' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001')  from "+table+
			     //�������� "  where substr(row_id,1,2) = 'AM' and substr(row_id, 3,8) = replace(?,'-','')   ";  
				 "   WHERE ROW_ID LIKE 'AM'|| replace(?,'-','')|| '%'   ";

		 query2 =" insert into "+table+" ( "+
				" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
				" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
				" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
				" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  YN_ISS,  "+  //6  �ΰ�������
				" NM_NOTE, DTS_INSERT, ID_INSERT )\n"+   //1
				" values( "+
				" ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?, "+  
				" replace(?,'-',''),  ?,  ?,  ?,  ?,  ?,  ?,  "+
				" replace(?,'-',''),  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  "+
				" ?,  ?,  ?,  ?,  ?,  ?, "+  
				" substrb(?, 1, 99) , to_char(sysdate,'YYYYMMDD') , ?  "+
				" ) ";	

	   try{

		         con.setAutoCommit(false);
		         con1.setAutoCommit(false);
			
			//row_id ����
			pstmt1 = con1.prepareStatement(query);
			pstmt1.setString(1, write_date);
			pstmt1.setString(2, write_date);
		
			rs = pstmt1.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();
			}
			rs.close();
			pstmt1.close();	
			
			pstmt2 = con1.prepareStatement(query2);

			for(int i = 0 ; i < vt.size() ; i++){

				Hashtable ht = (Hashtable)vt.elementAt(i);

				pstmt2.setString(1, row_id);
				pstmt2.setString (2, String.valueOf(ht.get("ROW_NO")));
											
				//�ΰ����� ��� - ��ǥ��ȣ||���ι�ȣ , ��Ÿ *
				if (  String.valueOf(ht.get("NO_TAX")).equals("*") ) {
					pstmt2.setString (3, "*");					
				} else {	
					pstmt2.setString (3,  row_id  + String.valueOf(ht.get("ROW_NO"))   );												
				}
				
				pstmt2.setString (4, String.valueOf(ht.get("CD_PC")));
				pstmt2.setString (5, String.valueOf(ht.get("CD_WDEPT")));
				pstmt2.setString(6, row_id);
				pstmt2.setInt   (7, AddUtil.parseDigit(String.valueOf(ht.get("NO_DOLINE"))));								
				pstmt2.setString (8, String.valueOf(ht.get("CD_COMPANY")));
				pstmt2.setString (9, String.valueOf(ht.get("ID_WRITE")));
				pstmt2.setString (10, String.valueOf(ht.get("CD_DOCU")));
					
				pstmt2.setString(11, String.valueOf(ht.get("DT_ACCT")));
				pstmt2.setString(12, String.valueOf(ht.get("ST_DOCU")));
				pstmt2.setString(13, String.valueOf(ht.get("TP_DRCR")));
				pstmt2.setString(14, String.valueOf(ht.get("CD_ACCT")));					
		//		pstmt2.setInt   (15, AddUtil.parseDigit(String.valueOf(ht.get("AMT"))));
				pstmt2.setLong   (15, AddUtil.parseDigit4(String.valueOf(ht.get("AMT"))));
				pstmt2.setString(16, String.valueOf(ht.get("TP_GUBUN")));
				pstmt2.setString(17, String.valueOf(ht.get("CD_PARTNER")));				
				
				pstmt2.setString(18, String.valueOf(ht.get("DT_START")));
				pstmt2.setString(19, String.valueOf(ht.get("CD_BIZAREA")));
				pstmt2.setString(20, String.valueOf(ht.get("CD_DEPT")));
				pstmt2.setString(21, String.valueOf(ht.get("CD_CC")));
				pstmt2.setString(22, String.valueOf(ht.get("CD_PJT")));
				pstmt2.setString(23, String.valueOf(ht.get("CD_CARD")));
				pstmt2.setString(24, String.valueOf(ht.get("CD_EMPLOY")));
				pstmt2.setString(25, String.valueOf(ht.get("NO_DEPOSIT")));
				pstmt2.setString(26, String.valueOf(ht.get("CD_BANK")));
				pstmt2.setString(27, String.valueOf(ht.get("NO_ITEM")));
					
				//�ΰ����� ��� - ��ǥ��ȣ||���ι�ȣ , ��Ÿ *
				if (  String.valueOf(ht.get("NO_TAX")).equals("*") ) {
					pstmt2.setInt   (28,  0);		
					pstmt2.setInt   (29,  0);		
					pstmt2.setString(30,  "");
					pstmt2.setString(31,  "");
					pstmt2.setString(32,  "");	
						
				} else {	
					pstmt2.setInt   (28, AddUtil.parseDigit(String.valueOf(ht.get("AM_TAXSTD"))));		
					pstmt2.setInt   (29, AddUtil.parseDigit(String.valueOf(ht.get("AM_ADDTAX"))));		
					pstmt2.setString(30, String.valueOf(ht.get("TP_TAX")));
					pstmt2.setString(31, String.valueOf(ht.get("NO_COMPANY")));	
					pstmt2.setString (32,  row_id  + String.valueOf(ht.get("ROW_NO"))   );		
																
				}	
				
				//�ΰ���������(25500) �� ���ڼ��ݰ�꼭, ��ݱ�(13500)�� Ȯ������ ����.
				if (  String.valueOf(ht.get("CD_ACCT")).equals("25500") ) {	
					pstmt2.setString(33, "2");		
				} else {
					pstmt2.setString(33, "");		
				}	 						
							
				pstmt2.setString(34, String.valueOf(ht.get("NM_NOTE")));
				pstmt2.setString (35, String.valueOf(ht.get("ID_WRITE")));
			
				pstmt2.executeUpdate();
				
			}

			pstmt2.close();

            con.commit();
            con1.commit();
  

		}catch(Exception se){
            try{
				row_id = "0";
				System.out.println("[NeoErpUDatabase:insertSetAutoDocu]"+se);
                con.rollback();
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(rs != null) rs.close();
	            if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
	            connMgr.freeConnection(DATA_SOURCE, con);
	            connMgr.freeConnection(DATA_SOURCE1, con1);
		   con = null;
		  con1 = null;
        }
        return row_id;
    }
	

   /**
     *	�ڵ���ǥ   -������ :  cms :AI
     */
    public String insertSetAutoDocu(String write_date,  String gubun, Vector vt) throws DatabaseException, DataSourceEmptyException{
        Connection con  = connMgr.getConnection(DATA_SOURCE);	//acar
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);	//neom

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;

        String query = "";
        String query2 = "";
         
        String row_id = "";
           
		String table = "fi_adocu";
	        
         query = "select  '"+gubun +"' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001')  from "+table+"  where substr(row_id,1,2) = '"+gubun +"' and substr(row_id, 3,8) = replace(?,'-','')   ";      

		 query2 =" insert into "+table+" ( "+
				" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
				" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
				" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
				" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG, YN_ISS,  "+  //6  �ΰ�������
				" NM_NOTE, DTS_INSERT , ID_INSERT  )\n"+   //1
				" values( "+
				" ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?, "+  
				" replace(?,'-',''),  ?,  ?,  ?,  ?,  ?,  ?,  "+
				" replace(?,'-',''),  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  "+
				" ?,  ?,  ?,  ?,  ?, ?, "+  
				" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ) , ? "+
				" ) ";	

	   try{

		         con.setAutoCommit(false);
		         con1.setAutoCommit(false);
			
			//row_id ����
			pstmt1 = con1.prepareStatement(query);
			pstmt1.setString(1, write_date);
			pstmt1.setString(2, write_date);
		
			rs = pstmt1.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();
			}
			rs.close();
			pstmt1.close();

			pstmt2 = con1.prepareStatement(query2);
											
			for(int i = 0 ; i < vt.size() ; i++){
				
				Hashtable ht = (Hashtable)vt.elementAt(i);
							
				pstmt2.setString(1, row_id);
				pstmt2.setString(2, String.valueOf(ht.get("ROW_NO")));
															
				//�ΰ����� ��� - ��ǥ��ȣ||���ι�ȣ , ��Ÿ *
				if (  String.valueOf(ht.get("NO_TAX")).equals("*") ) {
					pstmt2.setString (3, "*");
				} else {	
					pstmt2.setString (3,  row_id  + String.valueOf(ht.get("ROW_NO"))   );							
				}
				
				pstmt2.setString (4, String.valueOf(ht.get("CD_PC")));
				pstmt2.setString (5, String.valueOf(ht.get("CD_WDEPT")));
				pstmt2.setString(6, row_id);
				pstmt2.setInt   (7, AddUtil.parseDigit(String.valueOf(ht.get("NO_DOLINE"))));								
				pstmt2.setString (8, String.valueOf(ht.get("CD_COMPANY")));
				pstmt2.setString (9, String.valueOf(ht.get("ID_WRITE")));
				pstmt2.setString (10, String.valueOf(ht.get("CD_DOCU")));
					
				pstmt2.setString(11, String.valueOf(ht.get("DT_ACCT")));
				pstmt2.setString(12, String.valueOf(ht.get("ST_DOCU")));
				pstmt2.setString(13, String.valueOf(ht.get("TP_DRCR")));
				pstmt2.setString(14, String.valueOf(ht.get("CD_ACCT")));					
				pstmt2.setInt   (15, AddUtil.parseDigit(String.valueOf(ht.get("AMT"))));
				pstmt2.setString(16, String.valueOf(ht.get("TP_GUBUN")));
				pstmt2.setString(17, String.valueOf(ht.get("CD_PARTNER")));				
				
				pstmt2.setString(18, String.valueOf(ht.get("DT_START")));
				pstmt2.setString(19, String.valueOf(ht.get("CD_BIZAREA")));
				pstmt2.setString(20, String.valueOf(ht.get("CD_DEPT")));
				pstmt2.setString(21, String.valueOf(ht.get("CD_CC")));
				pstmt2.setString(22, String.valueOf(ht.get("CD_PJT")));
				pstmt2.setString(23, String.valueOf(ht.get("CD_CARD")));
				pstmt2.setString(24, String.valueOf(ht.get("CD_EMPLOY")));
				pstmt2.setString(25, String.valueOf(ht.get("NO_DEPOSIT")));
				pstmt2.setString(26, String.valueOf(ht.get("CD_BANK")));
				pstmt2.setString(27, String.valueOf(ht.get("NO_ITEM")));
					
				//�ΰ����� ��� - ��ǥ��ȣ||���ι�ȣ , ��Ÿ *
				if (  String.valueOf(ht.get("NO_TAX")).equals("*") ) {
					pstmt2.setInt   (28,  0);		
					pstmt2.setInt   (29,  0);		
					pstmt2.setString(30,  "");
					pstmt2.setString(31,  "");
					pstmt2.setString(32,  "");				
				} else {	
					pstmt2.setInt   (28, AddUtil.parseDigit(String.valueOf(ht.get("AM_TAXSTD"))));		
					pstmt2.setInt   (29, AddUtil.parseDigit(String.valueOf(ht.get("AM_ADDTAX"))));		
					pstmt2.setString(30, String.valueOf(ht.get("TP_TAX")));
					pstmt2.setString(31, String.valueOf(ht.get("NO_COMPANY")));	
					pstmt2.setString (32,  row_id  + String.valueOf(ht.get("ROW_NO"))   );			
										
				}	
						
					//�ΰ���������(25500) �� ���ڼ��ݰ�꼭, ��ݱ�(13500)�� Ȯ������ ����.
				if (  String.valueOf(ht.get("CD_ACCT")).equals("25500") ) {	
					pstmt2.setString(33, "2");		
				} else {
					pstmt2.setString(33, "");		
				}	 			
																	
				pstmt2.setString(34, String.valueOf(ht.get("NM_NOTE")));
				pstmt2.setString (35, String.valueOf(ht.get("ID_WRITE")));
			
				pstmt2.executeUpdate();
				
			}

			pstmt2.close();

           con.commit();
           con1.commit();
  

		}catch(Exception se){
            try{
				row_id = "0";
				System.out.println("[NeoErpUDatabase:insertSetAutoDocu(gubun)]"+se);
                con.rollback();
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(rs != null) rs.close();
				if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
	            connMgr.freeConnection(DATA_SOURCE, con);
	            connMgr.freeConnection(DATA_SOURCE1, con1);
		   con = null;
		  con1 = null;
        }
        return row_id;
    }
	
	
	  /**
     *	����� �Ű� ���� ���޼����� ��ǥ
     */
     
    public int insertAssetCommRegAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;    
   
        ResultSet rs = null;

        String query = "";
        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
                
        String comm_amt ="";
        String car_no = "";
       
        String item_code = "";
        
        String row_id = "";
                          
        int amt1=0;
        int amt2=0;
        int amt3=0;
        int amt4=0;
   
        int i = 0;
		
        int count = 0;
      
        String table = "fi_adocu";
		
		
		 query = "select  'AM' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001')  from "+table+
			 //��������"  where substr(row_id,1,2) = 'AM' and substr(row_id, 3,8) = replace(?,'-','')   ";
				"   WHERE ROW_ID LIKE 'AM'|| replace(?,'-','')|| '%'   ";
	
		//���޼�����-����
		query1 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE , DTS_INSERT , ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1',  '83100',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" 0, 0,  '', '', '', "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd') , ?  "+
					" ) ";	
	                
	                
	           //��ݺ�-����
		query2 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT, ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1',  '46400',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" 0, 0,  '', '', '',  "+  
					" substrb(?, 1, 99) , to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
					
			  	//�ΰ�����ޱ�
		query3 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT, ID_INSERT, YN_ISS  )\n"+   //2
					" values( "+
					" ?,  ?,  ?, 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1',  '13500',  ?, '3',  ?,  "+
					" replace(?,'-','') , 'S101', '', '', '', '', '', '', '', '',  "+
					" ?,  ?,  '21', ?,  ?, "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ), ?, '2'  "+
					" ) ";	
			
			  	//������ - �뺯
		query4 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT, ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2',  '25300',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" 0, 0,  '', '', '',  "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ) , ?   "+
					" ) ";	
		
	
	   try{

	            con.setAutoCommit(false);
	            con1.setAutoCommit(false);
	                	            
	            //�ݾ� �Ľ�
	           comm_amt= ad_bean.getAcct_cont().trim();
	           
	           StringTokenizer token = new StringTokenizer(comm_amt,"^");
				
		   while(token.hasMoreTokens()) {
				
				amt1 = Integer.parseInt(token.nextToken().trim());	//���޼�����
				amt2 = Integer.parseInt(token.nextToken().trim());	//��ݺ�
				amt3 = Integer.parseInt(token.nextToken().trim());	//�ΰ�����ޱ�
				amt4 = Integer.parseInt(token.nextToken().trim());	//�Ѿ�
				
			}		
           
           	//ó����ȣ �̱�
			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, ad_bean.getAcct_dt().trim());
			pstmt.setString(2, ad_bean.getAcct_dt().trim());
			rs = pstmt.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();
			}
			rs.close();
			pstmt.close();	
			
			if ( amt1 > 0 ) {
				
			//	System.out.println("1");
				//����-���޼�����	()		    
				i++;     
				pstmt1 = con1.prepareStatement(query1);
				
				pstmt1.setString(1, row_id);
				pstmt1.setString (2,  String.valueOf(i));
				pstmt1.setString(3, row_id);
				pstmt1.setInt   (4,  i );		
				pstmt1.setString (5, ad_bean.getInsert_id().trim());
								
				pstmt1.setString(6, ad_bean.getAcct_dt().trim());		
				pstmt1.setInt   (7,  amt1);		
				pstmt1.setString(8, ad_bean.getVen_code());			
				
				pstmt1.setString(9, "����� ��Ź��ǰ�� ����. ��ǰ������ - " + ad_bean.getItem_name().trim());
				pstmt1.setString (10, ad_bean.getInsert_id().trim());
				pstmt1.executeUpdate();
			   	pstmt1.close();
			}		
							
			if ( amt2 > 0 ) {			
				//����- ��ݺ�
				i++; 	
		//		System.out.println("2");	
				pstmt2 = con1.prepareStatement(query2);
				
				pstmt2.setString(1, row_id);
				pstmt2.setString (2,  String.valueOf(i));
				pstmt2.setString(3, row_id);
				pstmt2.setInt   (4,  i );		
				pstmt2.setString (5, ad_bean.getInsert_id().trim());
								
				pstmt2.setString(6, ad_bean.getAcct_dt().trim());		
				pstmt2.setInt   (7,  amt2);		
				pstmt2.setString(8, ad_bean.getVen_code());		
								
				pstmt2.setString(9, "����� ��Ź��ǰ�� ����Ź�۴�� - " + ad_bean.getItem_name().trim());	
				pstmt2.setString (10, ad_bean.getInsert_id().trim());		
				pstmt2.executeUpdate();
				pstmt2.close();
			}
						
				//����-�ΰ�����ޱ�(13500)
			i++; 	
		//	System.out.println("3");	
			pstmt3 = con1.prepareStatement(query3);
		
			pstmt3.setString(1, row_id);
			pstmt3.setString (2,  String.valueOf(i) );
			pstmt3.setString (3,  row_id  + String.valueOf(i)  );					
			pstmt3.setString(4, row_id);
			pstmt3.setInt   (5,  i );		
			pstmt3.setString (6, ad_bean.getInsert_id().trim());
			
			pstmt3.setString(7, ad_bean.getAcct_dt().trim());		
			pstmt3.setInt   (8,  amt3);		
			pstmt3.setString(9, ad_bean.getVen_code());		
								
			pstmt3.setString(10, ad_bean.getAcct_dt().trim());	
				
			pstmt3.setInt   (11,  amt1 + amt2);		
			pstmt3.setInt   (12,  amt3);		
			pstmt3.setString(13,  ad_bean.getS_idno().trim());	
			pstmt3.setString (14,  row_id  + String.valueOf(i)  );		
			pstmt3.setString(15, "����� ��Ź��ǰ�� ����Ź�۴�� - " + ad_bean.getItem_name().trim());	
			pstmt3.setString (16, ad_bean.getInsert_id().trim());		
			pstmt3.executeUpdate();	
			pstmt3.close();
			
			//�뺯-�����ޱ�(25300)
			i++; 
		//	System.out.println("4");
			pstmt4 = con1.prepareStatement(query4);
			
			pstmt4.setString(1, row_id);
			pstmt4.setString (2,  String.valueOf(i));
			pstmt4.setString(3, row_id);
			pstmt4.setInt   (4,  i );		
			pstmt4.setString (5, ad_bean.getInsert_id().trim());
							
			pstmt4.setString(6, ad_bean.getAcct_dt().trim());		
			pstmt4.setInt   (7,  amt4);		
			pstmt4.setString(8, ad_bean.getVen_code());		
							
			pstmt4.setString(9, "����� ��Ź��ǰ�� ����. ��ǰ������  - " + ad_bean.getItem_name().trim());			
			pstmt4.setString (10, ad_bean.getInsert_id().trim());
			pstmt4.executeUpdate();
			pstmt4.close();
												        
		         		         
		      		         
		         con.commit();
		         con1.commit();

		}catch(Exception se){
            try{
			count = 1;
			System.out.println("[NeoErpUDatabase:insertAssetCommRegAutoDocu]"+se);
	                con.rollback();
	                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
				if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
                if(pstmt4 != null) pstmt4.close();             
                            
            }catch(SQLException _ignored){}
            	connMgr.freeConnection(DATA_SOURCE, con);
        		connMgr.freeConnection(DATA_SOURCE1, con1);
		con = null;
		con1 = null;
        }
        return count;
    }
    
   	  /**
     *	����� �Ű� ��ǥ
     */
     
    public int insertAssetSaleRegAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
 		PreparedStatement pstmt7 = null;      
 		PreparedStatement pstmt8 = null;      
 		PreparedStatement pstmt9 = null;      
		PreparedStatement pstmt10 = null;       //���������� 
  
        ResultSet rs = null;

        String query = "";
        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
        String query5 = "";
        String query6 = "";
        String query7 = "";
        
        String query8 = "";  //�Ű���
         String query9 = ""; // ��ΰ�
         String query10 = ""; // ���������� 
                                          
        String reg_amt ="";
        String car_no = "";
        String car_use = "";
        
        String item_code = "";
        String row_id =   "";
                          
        int amt1=0;
        int amt2=0;
        int amt3=0;
        int amt4=0;
        int amt5=0;
        int amt6=0;
        int amt7=0;
        int amt9=0;   //��ΰ��� 20160512   
        int amt10=0;   //����������  20170112   
   
   	int m_amt7= 0;
   
	int i = 0;
		
        int count = 0;
       
	String table = "fi_adocu";
                
	
	 query = "select  'AM' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001')  from "+table+
		 //��������"  where substr(row_id,1,2) = 'AM' and substr(row_id, 3,8) = replace(?,'-','')   ";      
				"   WHERE ROW_ID LIKE 'AM'|| replace(?,'-','')|| '%'   ";
	
	       //������	- 20120105 ���� ������ ó�� , 20180201 ���� �̼��� ó�� 
		query1 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE , DTS_INSERT , ID_INSERT )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
			//		" replace(?,'-',''),  '1',  '1',  '25900',  ?, '3',  ?,  "+
					" replace(?,'-',''),  '1',  '1',  '12000',  ?, '3',  ?,  "+
					" ? , '', '', '', '', '', '', '', '', '',  "+
					" 0, 0,  '', '', '', "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
					
		//������ - ����
		query2 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE,  DTS_INSERT, ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1',  '25300',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ) ,  ?  "+
					" ) ";	
					
		   	//����/�뿩�������-�뺯
		query3 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE , DTS_INSERT , ID_INSERT )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', ?,  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 99) , to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
					
			//�ΰ���������
		query4 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  YN_ISS,  "+  //6  �ΰ�������
					" NM_NOTE, DTS_INSERT, ID_INSERT   )\n"+   //2
					" values( "+
					" ?,  ?,  ?, 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2',  '25500',  ?, '3',  ?,  "+
					" replace(?,'-','') , 'S101', '', '', '', '', '', '', '', '',  "+
					" ?,  ?,  '11', ?, ?,  '2', "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";		
								
		//������ ���� -����
		query5 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE , DTS_INSERT, ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1', ?,  ?, '3',  '',  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" 0, 0,  '', '',  '',  "+  
					" substrb(?, 1, 99) , to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
										
		  	//ó������ - �뺯
		query6 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT, ID_INSERT   )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', ?,  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" 0, 0,  '', '',  '', "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
										
										
			//ó�мս� - ����
		query7 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1', ?,  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" 0, 0,  '', '', '',  "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ) , ?   "+
					" ) ";		
		
							
				//�Ű��� - �뺯 	
		query8 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT, ID_INSERT   )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', ?,  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" 0, 0,  '', '',  '', "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
										
								
			//��ΰ��� - ���� 
		query9  =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1', ?,  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" 0, 0,  '', '', '',  "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ) , ?   "+
					" ) ";			
					
					
			//����������  - ���� 
		query10  =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1', ?,  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" 0, 0,  '', '', '',  "+  
					" substrb(?, 1, 99), to_char(sysdate,'YYYYMMdd' ) , ?   "+
					" ) ";																																																																	
	
	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);
                
                      
            //�ݾ� �Ľ�:�Աݾ� ^ ������� ^  ��氡�� ^ ����ǥ�� ^ �ΰ��������� ^ ������ ����� ^ó������(ó�мս�)^��ΰ���^����������^  
           reg_amt= ad_bean.getAcct_cont().trim();
           
           StringTokenizer token = new StringTokenizer(reg_amt,"^");
				
		   while(token.hasMoreTokens()) {
				
				amt1 = Integer.parseInt(token.nextToken().trim());	//�Աݾ�
				amt2 = Integer.parseInt(token.nextToken().trim());	//�������
				amt3 = Integer.parseInt(token.nextToken().trim());	//��氡��
				amt4 = Integer.parseInt(token.nextToken().trim());	//����ǥ��
				amt5 = Integer.parseInt(token.nextToken().trim());	//�ΰ���������
				amt6 = Integer.parseInt(token.nextToken().trim());	//������ �����
				amt7 = Integer.parseInt(token.nextToken().trim());	//ó������(ó�мս�)
				amt9 = Integer.parseInt(token.nextToken().trim());	// ��ΰ���  
				amt10 = Integer.parseInt(token.nextToken().trim());	// ����������  
				
			}		
           
           	//ó����ȣ �̱�
			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, ad_bean.getAcct_dt().trim());
			pstmt.setString(2, ad_bean.getAcct_dt().trim());
			rs = pstmt.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();
			}
			rs.close();
			pstmt.close();	
			
			if (amt7 < 0) {
				m_amt7 = amt7 * (-1);
			}	
							
				
			//����-������(25900)	    - 20120105 ����
			i++;     
			pstmt1 = con1.prepareStatement(query1);			
			pstmt1.setString(1, row_id);
			pstmt1.setString (2,  String.valueOf(i));
			pstmt1.setString(3, row_id);
			pstmt1.setInt   (4,  i );		
			pstmt1.setString (5, ad_bean.getInsert_id().trim());
							
			pstmt1.setString(6, ad_bean.getAcct_dt().trim());		
			pstmt1.setInt   (7,  amt1);		
			pstmt1.setString(8, ad_bean.getVen_code());		
				
			pstmt1.setString(9, ad_bean.getAcct_dt().trim());		
			pstmt1.setString(10, "�����Ű� - " + ad_bean.getItem_name().trim());
			pstmt1.setString (11, ad_bean.getInsert_id().trim());
			pstmt1.executeUpdate();
			pstmt1.close();
						 						
			//����-�����ޱ�(25300)	  
			i++; 	
	//		System.out.println("2");	
			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1, row_id);
			pstmt2.setString (2,  String.valueOf(i));
			pstmt2.setString(3, row_id);
			pstmt2.setInt   (4,  i );		
			pstmt2.setString (5, ad_bean.getInsert_id().trim());
			
			pstmt2.setString(6, ad_bean.getAcct_dt().trim());		
			pstmt2.setInt   (7,  amt2);		
			pstmt2.setString(8, ad_bean.getVen_code());		
				
			pstmt2.setString(9, "�����Ű� �������ǰ������� - " + ad_bean.getItem_name().trim());	
			pstmt2.setString (10, ad_bean.getInsert_id().trim());
			pstmt2.executeUpdate();
			pstmt2.close();
											 				
			//�뺯-����/�뿩�������	()		 
			i++; 	
	//		System.out.println("3");	
			pstmt3 = con1.prepareStatement(query3);
			pstmt3.setString(1, row_id);
			pstmt3.setString (2,  String.valueOf(i));
			pstmt3.setString(3, row_id);
			pstmt3.setInt   (4,  i );		
			pstmt3.setString (5, ad_bean.getInsert_id().trim());
			
			pstmt3.setString(6, ad_bean.getAcct_dt().trim());		
			pstmt3.setString(7, ad_bean.getAcct_code());
			pstmt3.setInt   (8,  amt3);		
			pstmt3.setString(9, "000131");
				
			pstmt3.setString(10, "�����Ű� - " + ad_bean.getItem_name().trim());	
			pstmt3.setString (11, ad_bean.getInsert_id().trim());
			pstmt3.executeUpdate();
			pstmt3.close();
			
								 				
			//�뺯-�ΰ���������(25500)
			i++; 	
	//		System.out.println("4");	
			pstmt4 = con1.prepareStatement(query4);			
			pstmt4.setString(1, row_id);
			pstmt4.setString (2,  String.valueOf(i) );
			pstmt4.setString (3,  row_id  + String.valueOf(i)  );					
			pstmt4.setString(4, row_id);
			pstmt4.setInt   (5,  i);		
			pstmt4.setString (6, ad_bean.getInsert_id().trim());
			
			pstmt4.setString(7, ad_bean.getAcct_dt().trim());		
			pstmt4.setInt   (8,  amt5);		
			pstmt4.setString(9,  ad_bean.getVen_code2().trim());	
								
			pstmt4.setString(10, ad_bean.getAcct_dt().trim());		
			
			pstmt4.setInt   (11,  amt4);		
			pstmt4.setInt   (12,  amt5);	
			
			if (ad_bean.getVen_type().equals("1") ) {
				pstmt4.setString(13,  "8888888888");	
			} else {
				pstmt4.setString(13,  ad_bean.getS_idno().trim());		
			}	
			
			pstmt4.setString (14,  row_id  + String.valueOf(i)  );		
		
			pstmt4.setString(15, "�����Ű� - " + ad_bean.getItem_name().trim());			
			pstmt4.setString (16, ad_bean.getInsert_id().trim());
			pstmt4.executeUpdate();	
			pstmt4.close();
			  
		
			//����-����/�뿩������� �����󰢴����	()		 
			i++; 	
	//		System.out.println("5");	
			pstmt5 = con1.prepareStatement(query5);
			pstmt5.setString(1, row_id);
			pstmt5.setString (2,  String.valueOf(i));
			pstmt5.setString(3, row_id);
			pstmt5.setInt   (4,  i );		
			pstmt5.setString (5, ad_bean.getInsert_id().trim());
			
			pstmt5.setString(6, ad_bean.getAcct_dt().trim());		
			if (ad_bean.getAcct_code().equals("21900") ) {
				pstmt5.setString(7, "22000");
			}
			else {
				pstmt5.setString(7, "21800");
			}	
			pstmt5.setInt   (8,  amt6);		
			pstmt5.setString(9, "�����Ű� �����󰢴���� ��ü - " + ad_bean.getItem_name().trim());	
			pstmt5.setString (10, ad_bean.getInsert_id().trim());
			pstmt5.executeUpdate();
			pstmt5.close();
			
			
			if (amt10 > 0 ) {  //�����Ű� ���������������� �ִٸ�  
				//����-����/�뿩������� �����󰢴����	()		 
		    	i++; 	
	//		System.out.println("5");	
				pstmt10 = con1.prepareStatement(query10);
				pstmt10.setString(1, row_id);
				pstmt10.setString (2,  String.valueOf(i));
				pstmt10.setString(3, row_id);
				pstmt10.setInt   (4,  i );		
				pstmt10.setString (5, ad_bean.getInsert_id().trim());
				
				pstmt10.setString(6, ad_bean.getAcct_dt().trim());	
				
				//�Ű��� ���ź����� 
				if (ad_bean.getAcct_code().equals("21900") ) {  //���� 
					pstmt10.setString(7, "22010");
				}
				else {
					pstmt10.setString(7, "21810");
				}	
								
				pstmt10.setInt   (8,  amt10);	
				pstmt10.setString(9, "000131");		//�Ƹ���ī	
				pstmt10.setString(10, "�����Ű� ��������������  - " + ad_bean.getItem_name().trim());	
				pstmt10.setString (11, ad_bean.getInsert_id().trim());
			 	pstmt10.executeUpdate();
			 	pstmt10.close();
		 }
			
	   	    			   	    
	   	        	//�Ű���  
			i++; 
			pstmt8 = con1.prepareStatement(query8);
							
			pstmt8.setString(1, row_id);
			pstmt8.setString (2,  String.valueOf(i));
			pstmt8.setString(3, row_id);
			pstmt8.setInt   (4,  i );		
			pstmt8.setString (5, ad_bean.getInsert_id().trim());
			
			pstmt8.setString(6, ad_bean.getAcct_dt().trim());	
		
			if ( ad_bean.getAcct_code().equals("21900") ) { //���� 
				pstmt8.setString(7, "41510");
			} else {
				pstmt8.setString(7, "41310");
			}	
			pstmt8.setInt   (8, amt4);
			pstmt8.setString(9, "000131");		//�Ƹ���ī
			pstmt8.setString(10, "���� ó�� ���� - " + ad_bean.getItem_name().trim());				
			pstmt8.setString (11, ad_bean.getInsert_id().trim());
			pstmt8.executeUpdate();		
			pstmt8.close();
		         
		           	//��ΰ���  
			i++; 
			pstmt9 = con1.prepareStatement(query9);
					
			pstmt9.setString(1, row_id);
			pstmt9.setString (2,  String.valueOf(i));
			pstmt9.setString(3, row_id);
			pstmt9.setInt   (4,  i );		
			pstmt9.setString (5, ad_bean.getInsert_id().trim());
			
			pstmt9.setString(6, ad_bean.getAcct_dt().trim());	
			
			if ( ad_bean.getAcct_code().equals("21900") ) {
				pstmt9.setString(7, "45410");
			} else {
				pstmt9.setString(7, "45310");
			}	
			pstmt9.setInt   (8, amt9);
			pstmt9.setString(10, "���� ó�� ����  - " + ad_bean.getItem_name().trim());
															
			pstmt9.setString(9, "000131");		//�Ƹ���ī
			pstmt9.setString (11, ad_bean.getInsert_id().trim());
			pstmt9.executeUpdate();	
			pstmt9.close();
	   	    		
						                  
	         con.commit();
	         con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				//	System.out.println("�ΰ��� ");	
		    	//	System.out.println("acct_dt="+ ad_bean.getAcct_dt().trim() + " :data_no = " + data_no + ": i = 4 : node_code= " +  ad_bean.getNode_code().trim() );
				//	System.out.println("ven_type = " + ad_bean.getVen_type().trim() + " : gong_amt =" + amt4 + ": tax_vat = "+ amt5 + ":ven_code = " + ad_bean.getVen_code2().trim() + ": s_idno = " + ad_bean.getS_idno().trim() );	
	    		//	System.out.println("query8="+ query8);
				System.out.println("[NeoErpUDatabase:insertAssetSaleRegAutoDocu]"+se);
		   	  	con.rollback();
           	  	con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
				if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
                if(pstmt4 != null) pstmt4.close();
                if(pstmt5 != null) pstmt5.close();
                if(pstmt8 != null) pstmt8.close();
                if(pstmt9 != null) pstmt9.close();
                if(pstmt10 != null) pstmt10.close();
             
            }catch(SQLException _ignored){}
	            connMgr.freeConnection(DATA_SOURCE, con);
	            connMgr.freeConnection(DATA_SOURCE1, con1);
		  con = null;       
		  con1 = null;
        }
        return count;
    }

    /**
     *	�ڵ������ ��ǥ
     */
    public int insertCarRegAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
        PreparedStatement pstmt6 = null;
        PreparedStatement pstmt7 = null;
        ResultSet rs = null;

        String query = "";
        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
        String query4_1 = "";
        String query5 = "";
        String query6 = "";
        String query9 = "";
        
        String alt_amt ="";
        String car_no = "";
        
        String car_ext = "";
        String item_code = "";
        String car_use = "";
        String fuel_kd = "";
        String node_code = "S101";
        String ven_code = "";
        String acct_code = "";
        
           
        int amt1=0;
        int amt2=0;
        int amt3=0;
        int amt4=0;
        int amt5=0;
        int amt6=0;
        int amt7=0;  //��漼

	int i = 0;
		
        int count = 0;
        int data_no = 0;
        String row_id = "";
        
        String table = "fi_adocu";
                
	
	 query = "select  'AM' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001')  from "+table+
			//��������"  where substr(row_id,1,2) = 'AM' and substr(row_id, 3,8) = replace(?,'-','')   "; 
			 "   WHERE ROW_ID LIKE 'AM'|| replace(?,'-','')|| '%'   ";
	
		//����/�뿩�������-����
		query1 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT,  ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  ?,   ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1', ?,  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98) , to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
					
		
		//���ݰ�������-����		
		query3 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  ?,   ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1', '46300',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98), to_char(sysdate,'YYYYMMdd' ) , ?   "+
					" ) ";	
	
				
		//���������-����  //20211116 �������� ������������� 45510 �ϳ��� ���� : 45700->45510
		query4 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT   )\n"+   //2
					" values( "+
					" ?,  ?,  '*',  'S101',  ?,   ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1', '45510',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98) , to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
									
			//��ȣ�Ǵ� �����ޱ�-���� -��õ����� ��� ��ȣ�� �ŷ�ó - 000059
		 query4_1 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE , DTS_INSERT,  ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*',  'S101',  ?,  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1', '13400',  ?, '3',  ?,  "+
					" replace(?,'-',''), '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98) , to_char(sysdate,  'yyyymmdd' ) , ?  "+
					" ) ";	
	
		//���޼�����-����
		query5 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE , DTS_INSERT, ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  ?,   ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1', '83100',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98), to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
	
		//���ޱ�-�뺯
		query6 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*',  'S101',  ?,  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', '14200',  ?, '3',  '',  "+
					" replace(?,'-','') , '', '', '', '', '', '2008003', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98) , to_char(sysdate,'YYYYMMdd' ) , ? "+
					" ) ";	
					
							
		//������ - �뺯
		query9 =" insert into "+table+" ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT   )\n"+   //2
					" values( "+
					" ?,  ?,  '*', 'S101',  ?,   ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', '25300',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98) , to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
				
	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);
                   
          	//car_no �Ľ� : car_no^car_ext^car_use^fuel_kd
           car_no = ad_bean.getItem_name().trim();
           
           StringTokenizer token1 = new StringTokenizer(car_no,"^");
				
		   while(token1.hasMoreTokens()) {
				
				item_code = token1.nextToken().trim();	//�ڵ�����ȣ
				car_ext = token1.nextToken().trim();	//�������
				car_use = token1.nextToken().trim();	//�����뵵
				fuel_kd = token1.nextToken().trim();	//�ֹ���, lpg ,���� 
			}	
                        
            //������ϰ������� ���� ���� - ������ -> ���ޱ�
            if ( car_ext.equals("1") || car_ext.equals("2") || car_ext.equals("6") ) {
            //	node_code = "S101";
         //   	ven_code = "029846"; //�����û
            	ven_code = "001281";  //��������û 
            	acct_code = "14200";  // ���ޱ�            	
            }else if ( car_ext.equals("7") ) {  //��õ���
            //	node_code = "S101";
            	ven_code = "006110";
            	acct_code = "14200";  // ���ޱ�                        		
            }else if  ( car_ext.equals("5") ) {
            //   	node_code = "D101";	
            //   	ven_code = "607081"; 
            	ven_code = "607784"; //
               	acct_code = "14200";   //���� ���ޱ�
            }else if  ( car_ext.equals("3") ) { //�λ�
           //    	node_code = "B101";	
               	ven_code = "601514";  
               	acct_code = "14200";   //�λ� ������ 	
            }else if  ( car_ext.equals("9") ) { //���� - 20220405 �߰�         
               	ven_code = "006380";  
               	acct_code = "14200";   //���� ������ 	
        //    }else if  ( car_ext.equals("10") ) { //�뱸 - 20220405 �߰�          
        //       	ven_code = "006379";  
         //      	acct_code = "14200";   //�뱸 ������ 	        	
            }else {         
            	ven_code = "601458"; 	
            	acct_code = "14200"; //�λ� ���ޱ� 	
            }	
            
            
            if ( car_ext.equals("10") && fuel_kd.equals("8") ) {  //�뱸�鼭 �������� ��� 
             	   	ven_code = "996379"; 	
            }	
            
            //�ݾ� �Ľ�
           alt_amt= ad_bean.getAcct_cont().trim();
           
           StringTokenizer token = new StringTokenizer(alt_amt,"^");
				
		   while(token.hasMoreTokens()) {
				
				amt1 = Integer.parseInt(token.nextToken().trim());	//��ϼ�
				amt7 = Integer.parseInt(token.nextToken().trim());	//��漼
				amt2 = Integer.parseInt(token.nextToken().trim());	//���԰�ä
				amt3 = Integer.parseInt(token.nextToken().trim());	//��������
				amt4 = Integer.parseInt(token.nextToken().trim());	//��ȣ���ۺ�
				amt5 = Integer.parseInt(token.nextToken().trim());	//��Ÿ
				amt6 = Integer.parseInt(token.nextToken().trim());	//�Ѿ�					
			}		
        
           		
           	//ó����ȣ �̱�
			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, ad_bean.getAcct_dt().trim());
			pstmt.setString(2, ad_bean.getAcct_dt().trim());
			rs = pstmt.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();		
			}
			rs.close();
			pstmt.close();	
			
		
			//��ϼ�
			if ( amt1 > 0 ) {				
			//	System.out.println("1");
				//����-����/�뿩�������	()		    
				i++;     				
				pstmt1 = con1.prepareStatement(query1);
				pstmt1.setString(1, row_id);
				pstmt1.setString (2,  String.valueOf(i));
				pstmt1.setString (3,  ad_bean.getDept_code().trim());
				pstmt1.setString(4, row_id);
				pstmt1.setInt   (5,  i );		
				pstmt1.setString (6, ad_bean.getInsert_id().trim());
				
				pstmt1.setString(7, ad_bean.getAcct_dt().trim());		
				if (car_use.equals("1") ) {
					pstmt1.setString(8, "21700");
				}
				else {
					pstmt1.setString(8, "21900");
				}
				pstmt1.setInt   (9,  amt1);		
				pstmt1.setString(10, ven_code);	
								
				pstmt1.setString(11, "��ϼ� - " + item_code + " " + ad_bean.getCom_name().trim());		
				pstmt1.setString (12, ad_bean.getInsert_id().trim());		
				pstmt1.executeUpdate();			
			   	pstmt1.close();
			}		
				
						
			//��漼				
			if ( amt7 > 0 ) {				
			//	System.out.println("2");
				//����-����/�뿩�������	()		    
				i++; 				
				pstmt7 = con1.prepareStatement(query1);
				pstmt7.setString(1, row_id);
				pstmt7.setString (2,  String.valueOf(i));
				pstmt7.setString (3,   ad_bean.getDept_code().trim());
				pstmt7.setString(4, row_id);
				pstmt7.setInt   (5,  i );		
				pstmt7.setString (6, ad_bean.getInsert_id().trim());
				
				pstmt7.setString(7, ad_bean.getAcct_dt().trim());		
				if (car_use.equals("1") ) {
					pstmt7.setString(8, "21700");
				}
				else {
					pstmt7.setString(8, "21900");
				}
				pstmt7.setInt   (9,  amt7);		
				pstmt7.setString(10, ven_code);	
								
				pstmt7.setString(11, "��漼 - " + item_code + " " + ad_bean.getCom_name().trim());	
				pstmt7.setString (12, ad_bean.getInsert_id().trim());			
				pstmt7.executeUpdate();			
			   	pstmt7.close();
			 }		
				
			//���԰�ä				
			if ( amt2 > 0 ) {			
				//����-����/�뿩�������
				i++; 	
			//	System.out.println("3");	
				pstmt2 = con1.prepareStatement(query1);
				pstmt2.setString(1, row_id);
				pstmt2.setString (2,  String.valueOf(i));
				pstmt2.setString (3,  ad_bean.getDept_code().trim());
				pstmt2.setString(4, row_id);
				pstmt2.setInt   (5,  i );		
				pstmt2.setString (6, ad_bean.getInsert_id().trim());
				
				pstmt2.setString(7, ad_bean.getAcct_dt().trim());		
				if (car_use.equals("1") ) {
					pstmt2.setString(8, "21700");
				}
				else {
					pstmt2.setString(8, "21900");
				}
				pstmt2.setInt   (9,  amt2);		
				pstmt2.setString(10, ven_code);	
								
				pstmt2.setString(11, "���԰�ä - " + item_code + " " + ad_bean.getCom_name().trim());			
				pstmt2.setString (12, ad_bean.getInsert_id().trim());	
				pstmt2.executeUpdate();			
			   	pstmt2.close();	
			}
			
						 				
			//����-���ݰ�������(81700)
			i++; 	
		//	System.out.println("4");	
			pstmt3 = con1.prepareStatement(query3);
			pstmt3.setString(1, row_id);
			pstmt3.setString (2,  String.valueOf(i));
			pstmt3.setString (3,   ad_bean.getDept_code().trim());
			pstmt3.setString(4, row_id);
			pstmt3.setInt   (5,  i );		
			pstmt3.setString (6, ad_bean.getInsert_id().trim());
		
			pstmt3.setString(7, ad_bean.getAcct_dt().trim());		
			pstmt3.setInt   (8,  amt3);		
			pstmt3.setString(9, ven_code);	
						
			pstmt3.setString(10, "������ - " + item_code + " " + ad_bean.getCom_name().trim());		
			pstmt3.setString (11, ad_bean.getInsert_id().trim());		
			pstmt3.executeUpdate();			
		   	pstmt3.close();	
			
			if ( amt4 > 0 ) {						
				//����-���������(45700)
				i++; 
			//	System.out.println("5");
			 // ��õ��Ͻ� ��ȣ�Ǵ�� �����ޱ�  - 20150515 ��ȣ�Ǵ�� - �����  -- ��ȣ�Ǻ�� ���� - 20220405
			       if (	ven_code.equals("006110")  &&  (  amt4 == 8800 || amt4 == 24100 || amt4 == 21400 || amt4 == 7700 || amt4 == 20000 || amt4 == 9600 ) ) {  //�����ޱ�
			       		pstmt4 = con1.prepareStatement(query4_1); //�����ޱ�
						pstmt4.setString(1, row_id);
						pstmt4.setString (2,  String.valueOf(i));
						pstmt4.setString (3,   ad_bean.getDept_code().trim());
						pstmt4.setString(4, row_id);
						pstmt4.setInt   (5,  i );		
						pstmt4.setString (6, ad_bean.getInsert_id().trim());
							
						pstmt4.setString(7, ad_bean.getAcct_dt().trim());		
						pstmt4.setInt   (8,  amt4);	
						pstmt4.setString(9, "000059");	
					//	pstmt4.setString(9, ven_code);	
						pstmt4.setString(10, ad_bean.getAcct_dt().trim());	
																														
						pstmt4.setString(11, "��ȣ�Ǵ� - " + item_code + " " + ad_bean.getCom_name().trim());	
						pstmt4.setString (12, ad_bean.getInsert_id().trim());			
						pstmt4.executeUpdate();			
						pstmt4.close();			      	
							       			       	
			    }  else {		//�����				 
					
						pstmt4 = con1.prepareStatement(query4);
						pstmt4.setString(1, row_id);
						pstmt4.setString (2,  String.valueOf(i));
						pstmt4.setString (3,   ad_bean.getDept_code().trim());
						pstmt4.setString(4, row_id);
						pstmt4.setInt   (5,  i );		
						pstmt4.setString (6, ad_bean.getInsert_id().trim());
						
						pstmt4.setString(7, ad_bean.getAcct_dt().trim());		
						pstmt4.setInt   (8,  amt4);		
					//	pstmt4.setString(9, "000059");	
						pstmt4.setString(9, ven_code);								
					
						pstmt4.setString(10, "��ȣ�Ǵ� - " + item_code + " " + ad_bean.getCom_name().trim());	
						pstmt4.setString (11, ad_bean.getInsert_id().trim());			
						pstmt4.executeUpdate();			
						pstmt4.close();	
					
			  }		
			}		
			
			if ( amt5 > 0 ) {		
					
				//����-���޼�����(83100)
				i++; 				
			//	System.out.println("6");
				pstmt5 = con1.prepareStatement(query5);				
				pstmt5.setString(1, row_id);
				pstmt5.setString (2,  String.valueOf(i));
				pstmt5.setString (3,  ad_bean.getDept_code().trim());
				pstmt5.setString(4, row_id);
				pstmt5.setInt   (5,  i );		
				pstmt5.setString (6, ad_bean.getInsert_id().trim());
				
				pstmt5.setString(7, ad_bean.getAcct_dt().trim());		
				pstmt5.setInt   (8,  amt5);		
				pstmt5.setString(9, ven_code);	
								
				pstmt5.setString(10, "��ϴ�������� - " + item_code + " " + ad_bean.getCom_name().trim());		
				pstmt5.setString (11, ad_bean.getInsert_id().trim());		
				pstmt5.executeUpdate();			
			   	pstmt5.close();	
		        }
						
			//�뺯-���ޱ�(14200)
			i++; 
						
			if	(ad_bean.getInsert_id().trim().equals("2007007")  || ad_bean.getInsert_id().trim().equals("2005008") || ad_bean.getInsert_id().trim().equals("2009009")   ) {		//����		
			//	System.out.println( "����=" + ad_bean.getInsert_id().trim() );	   	
				pstmt6 = con1.prepareStatement(query9);
				pstmt6.setString(1, row_id);
				pstmt6.setString (2,  String.valueOf(i));
				pstmt6.setString (3,   ad_bean.getDept_code().trim());
				pstmt6.setString(4, row_id);
				pstmt6.setInt   (5,  i );		
				pstmt6.setString (6, ad_bean.getInsert_id().trim());
				
				pstmt6.setString(7, ad_bean.getAcct_dt().trim());		
				pstmt6.setInt   (8,  amt6);		
				pstmt6.setString(9, ven_code);	
								
				pstmt6.setString(10, "������� - " + item_code + " " + ad_bean.getCom_name().trim());	
				pstmt6.setString (11, ad_bean.getInsert_id().trim());			
				pstmt6.executeUpdate();			
			   	pstmt6.close();	
			
			} else {	
			//	System.out.println( "����=" + ad_bean.getInsert_id().trim() );				
				pstmt6 = con1.prepareStatement(query6);
				pstmt6.setString(1, row_id);
				pstmt6.setString (2,  String.valueOf(i));
				pstmt6.setString (3,   ad_bean.getDept_code().trim());
				pstmt6.setString(4, row_id);
				pstmt6.setInt   (5,  i );		
				pstmt6.setString (6, ad_bean.getInsert_id().trim());
				
				pstmt6.setString(7, ad_bean.getAcct_dt().trim());		
				pstmt6.setInt   (8,  amt6);		
								
				pstmt6.setString(9, ad_bean.getAcct_dt().trim());	
										
				pstmt6.setString(10, "�����񼱱ޱ� - " + item_code + " " + ad_bean.getCom_name().trim());	
				pstmt6.setString (11, ad_bean.getInsert_id().trim());			
				pstmt6.executeUpdate();	
				pstmt6.close();	
			}
        
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
			count = 1;
			System.out.println("[NeoErpUDatabase:insertCarRegAutoDocu]"+se);
                con.rollback();
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
				if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
                if(pstmt4 != null) pstmt4.close();
                if(pstmt5 != null) pstmt5.close();
                if(pstmt6 != null) pstmt6.close();
                if(pstmt7 != null) pstmt7.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
        }
        return count;
    }

      /**
     *	�繫ȸ��->���ݰ������� ��� 
     */
    public int insertFeeAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        ResultSet rs = null;

        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
        String query5 = "";
        String query6 = "";
        String query7 = "";
        String query8 = "";

        int count = 0;
        int data_no = 0;
        int i = 0;
        
        String row_id = "";
                
                 query1   = "select  'AM' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001')  from fi_adocu "+
					 //��������"  where substr(row_id,1,2) = 'AM' and substr(row_id, 3,8) = replace(?,'-','')   ";  
						"   WHERE ROW_ID LIKE 'AM'|| replace(?,'-','')|| '%'   ";
		
		//���뿹��
		query2 =" insert into  fi_adocu  ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', ?,  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '1', '10300',  ?, '3',  '',  "+
					" '' , '', '', '', '', '', '', ?, ?, '',  "+
					" '0', '0',  '', '',  '', "+  
					" substrb(?, 1, 98) , to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
		
		//�ܻ�����
		query3 =" insert into  fi_adocu  ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', ?,  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', '10800',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98) , to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
			
		//������
		query4 =" insert into  fi_adocu  ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT )\n"+   //2
					" values( "+
					" ?,  ?,  '*', ?,  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', '25900',  ?, '3',  ?,  "+
					" replace(?,'-','') , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '',  '', "+  
					" substrb(?, 1, 98), to_char(sysdate,'YYYYMMdd' ) , ?   "+
					" ) ";	

		//���뿩������
		query5 =" insert into  fi_adocu  ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT,  ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', ?,  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', '31100',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98), to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
										
			//��Ʈ�����������
		query6 =" insert into  fi_adocu  ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT  )\n"+   //1
					" values( "+
					" ?,  ?,  '*', ?,  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', '41400',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98), to_char(sysdate,'YYYYMMdd' ) , ?   "+
					" ) ";	
										
				//���������������
		query7 =" insert into  fi_adocu  ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', ?,  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', '41800',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98), to_char(sysdate,'YYYYMMdd' ) , ?  "+
					" ) ";	
				
					//������
		query8 =" insert into  fi_adocu  ( "+
					" ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, CD_COMPANY, ID_WRITE, CD_DOCU,"+   //10
					" DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, TP_GUBUN, CD_PARTNER,"+   //7
					" DT_START, CD_BIZAREA, CD_DEPT, CD_CC, CD_PJT, CD_CARD, CD_EMPLOY, NO_DEPOSIT, CD_BANK, NO_ITEM,"+  //10
					" AM_TAXSTD,  AM_ADDTAX,  TP_TAX,  NO_COMPANY,  CD_MNG,  "+  //5  �ΰ�������
					" NM_NOTE, DTS_INSERT , ID_INSERT  )\n"+   //2
					" values( "+
					" ?,  ?,  '*', ?,  '200',  ?,  ?, '1000',  ?,  '11', "+  
					" replace(?,'-',''),  '1',  '2', '93000',  ?, '3',  ?,  "+
					" '' , '', '', '', '', '', '', '', '', '',  "+
					" '0', '0',  '', '', '',  "+  
					" substrb(?, 1, 98) , to_char(sysdate,'YYYYMMdd' ) ,   ? "+
					" ) ";	
	
	   try{

		       	 con.setAutoCommit(false);
		          con1.setAutoCommit(false);

			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getAcct_dt().trim());
			pstmt1.setString(2, ad_bean.getAcct_dt().trim());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();
			}
			rs.close();
			pstmt1.close();			

			i++;     		
			//����-���뿹��(10300)
			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1, row_id);
			pstmt2.setString (2,  String.valueOf(i));
			pstmt2.setString (3,   ad_bean.getNode_code().trim());
			pstmt2.setString(4, row_id);
			pstmt2.setInt   (5,  i );		
			pstmt2.setString (6, ad_bean.getInsert_id().trim());
		
			pstmt2.setString(7, ad_bean.getAcct_dt().trim());		
			pstmt2.setInt   (8,   ad_bean.getAmt());
			
			pstmt2.setString(9,   ad_bean.getDeposit_no().trim());
			pstmt2.setString(10,   ad_bean.getBank_code().trim());
						
			pstmt2.setString(11,  ad_bean.getAcct_cont().trim());	
			pstmt2.setString (12, ad_bean.getInsert_id().trim());	
			pstmt2.executeUpdate();			
		   	pstmt2.close();	
		   	
		   	i++;    
			//�뺯-�ܻ�����
			if(ad_bean.getAcct_code().equals("10800")){		
				
				pstmt3 = con1.prepareStatement(query3);
				pstmt3.setString(1, row_id);
				pstmt3.setString (2,  String.valueOf(i));
				pstmt3.setString (3,   ad_bean.getNode_code().trim());
				pstmt3.setString(4, row_id);
				pstmt3.setInt   (5,  i );		
				pstmt3.setString (6, ad_bean.getInsert_id().trim());
			
				pstmt3.setString(7, ad_bean.getAcct_dt().trim());		
				pstmt3.setInt   (8,   ad_bean.getAmt());
				pstmt3.setString(9, ad_bean.getVen_code().trim());	
									
				pstmt3.setString(10,  ad_bean.getAcct_cont().trim());	
				pstmt3.setString (11, ad_bean.getInsert_id().trim());	
				pstmt3.executeUpdate();	
				pstmt3.close();
			
			//������
			}else if(ad_bean.getAcct_code().equals("25900")){

	        			pstmt3 = con1.prepareStatement(query4);
	        			pstmt3.setString(1, row_id);
				pstmt3.setString (2,  String.valueOf(i));
				pstmt3.setString (3,   ad_bean.getNode_code().trim());
				pstmt3.setString(4, row_id);
				pstmt3.setInt   (5,  i );		
				pstmt3.setString (6, ad_bean.getInsert_id().trim());
			
				pstmt3.setString(7, ad_bean.getAcct_dt().trim());		
				pstmt3.setInt   (8,   ad_bean.getAmt());
				pstmt3.setString(9, ad_bean.getVen_code().trim());	
									
				pstmt3.setString(10, ad_bean.getAcct_dt().trim());	
										
				pstmt3.setString(11,  ad_bean.getAcct_cont().trim());	
				pstmt3.setString (12, ad_bean.getInsert_id().trim());	
				pstmt3.executeUpdate();	
				pstmt3.close();
			

			//���뿩������
			}else if(ad_bean.getAcct_code().equals("31100")){

	           		pstmt3 = con1.prepareStatement(query5);
	           		pstmt3.setString(1, row_id);
				pstmt3.setString (2,  String.valueOf(i));
				pstmt3.setString (3,   ad_bean.getNode_code().trim());
				pstmt3.setString(4, row_id);
				pstmt3.setInt   (5,  i );		
				pstmt3.setString (6, ad_bean.getInsert_id().trim());
			
				pstmt3.setString(7, ad_bean.getAcct_dt().trim());		
				pstmt3.setInt   (8,   ad_bean.getAmt());
				pstmt3.setString(9, ad_bean.getVen_code().trim());	
									
				pstmt3.setString(10,  ad_bean.getAcct_cont().trim());		
				pstmt3.setString (11, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();	
				pstmt3.close();
			
			//��Ʈ�����������
			}else if(ad_bean.getAcct_code().equals("41400")){

	            		pstmt3 = con1.prepareStatement(query6);
	            		pstmt3.setString(1, row_id);
				pstmt3.setString (2,  String.valueOf(i));
				pstmt3.setString (3,   ad_bean.getNode_code().trim());
				pstmt3.setString(4, row_id);
				pstmt3.setInt   (5,  i );		
				pstmt3.setString (6, ad_bean.getInsert_id().trim());
			
				pstmt3.setString(7, ad_bean.getAcct_dt().trim());		
				pstmt3.setInt   (8,   ad_bean.getAmt());
				pstmt3.setString(9, ad_bean.getVen_code().trim());	
									
				pstmt3.setString(10,  ad_bean.getAcct_cont().trim());	
				pstmt3.setString (11, ad_bean.getInsert_id().trim());	
				pstmt3.executeUpdate();	 
				pstmt3.close();
				
			//���������������
			}else if(ad_bean.getAcct_code().equals("41800")){

			         pstmt3 = con1.prepareStatement(query7);
			         pstmt3.setString(1, row_id);
				pstmt3.setString (2,  String.valueOf(i));
				pstmt3.setString (3,   ad_bean.getNode_code().trim());
				pstmt3.setString(4, row_id);
				pstmt3.setInt   (5,  i );		
				pstmt3.setString (6, ad_bean.getInsert_id().trim());
			
				pstmt3.setString(7, ad_bean.getAcct_dt().trim());		
				pstmt3.setInt   (8,   ad_bean.getAmt());
				pstmt3.setString(9, ad_bean.getVen_code().trim());	
									
				pstmt3.setString(10,  ad_bean.getAcct_cont().trim());		
				pstmt3.setString (11, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();	  
				pstmt3.close();
					
						//������ - ���·�, ��ü����
			}else if(ad_bean.getAcct_code().equals("93000")){

			         pstmt3 = con1.prepareStatement(query8);
			         pstmt3.setString(1, row_id);
				pstmt3.setString (2,  String.valueOf(i));
				pstmt3.setString (3,   ad_bean.getNode_code().trim());
				pstmt3.setString(4, row_id);
				pstmt3.setInt   (5,  i );		
				pstmt3.setString (6, ad_bean.getInsert_id().trim());
			
				pstmt3.setString(7, ad_bean.getAcct_dt().trim());		
				pstmt3.setInt   (8,   ad_bean.getAmt());
				pstmt3.setString(9, ad_bean.getVen_code().trim());	
									
				pstmt3.setString(10,  ad_bean.getAcct_cont().trim());		
				pstmt3.setString (11, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();	 
				pstmt3.close();
		
			}	
		  
	            
	            con.commit();
	            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[NeoErpUDatabase:insertFeeAutoDocu]"+se);
                con.rollback();
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
        }
        return count;
    }




	/**
     * ���ν��� ȣ��
     */
    public String call_sp_card_account(String user_nm, String app_code, String cardno, String buy_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_CARD_ACCOUNT     (?,?,?,?,?)}";

	    try{

			//ȸ��ó�� ���ν���1 ȣ��(��ȸ���)
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, app_code);
			cstmt.setString(3, cardno);
			cstmt.setString(4, buy_id);
			cstmt.registerOutParameter(5, java.sql.Types.VARCHAR );
			cstmt.execute();

			sResult = cstmt.getString(5); // �����

			cstmt.close();


		}catch(SQLException se){
			System.out.println("[NeoErpUDatabase:call_sp_card_account]"+se);
			System.out.println("[NeoErpUDatabase:call_sp_card_account]sResult="+sResult);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }


     /**
     *	������� ���ݰ�꼭 ��� 
     */
    public String insertCarPurAmtAutoDocu(AutoDocuBean ad_bean, ContPurBean pur) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
        PreparedStatement pstmt6 = null;
        PreparedStatement pstmt7 = null;
		PreparedStatement pstmt8 = null;
        ResultSet rs = null;
		ResultSet rs8 = null;

        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
        String query5 = "";
        String query6 = "";
        String query7 = "";		
		String query8 = "";		
		String acct_code = "";		

        int count = 0;
        int data_no = 0;
		int data_line = 1;
		String row_id = "";

		String table = "fi_adocu";
                
		query8 = " select acct_code from pay_item where p_cd1=? and p_cd2=? and p_cd5=? and p_gubun='01' ";


	   try{

            con1.setAutoCommit(false);
			con.setAutoCommit(false);


			//ó����ȣ �̱�
			query1 =" select 'AU' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001') as row_id "+
					" from   "+table+" "+
					//��������" where  substr(row_id,1,2) = 'AU' and substr(row_id, 3,8) = replace(?,'-','') ";      
					"   WHERE ROW_ID LIKE 'AU'|| replace(?,'-','')|| '%'   ";

			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getWrite_dt().trim());
			pstmt1.setString(2, ad_bean.getWrite_dt().trim());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();
			}
			rs.close();
			pstmt1.close();			


			//����/�뿩������� (����) 21700 21900 : A03 A05 A06 �μ� ������Ʈ �ŷ�ó
			query2 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT, NO_DOCU, NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, CD_PARTNER, NM_NOTE "+												//3
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '1', ?, "+ad_bean.getAmt()+", "+
					"        '3', '"+ad_bean.getVen_code().trim()+"', substrb('"+ad_bean.getAcct_cont()+"', 1, 98) "+
					" ) ";	

			pstmt2 = con1.prepareStatement(query2);
			if(ad_bean.getCar_st().equals("2")){ //����
				pstmt2.setString(1, "21900");
			}else { //��Ʈ
				pstmt2.setString(1, "21700");
			}
			pstmt2.executeUpdate();			
		   	pstmt2.close();
		
			data_line++;

			
			//�ΰ�����ޱ� (����) 13500 A06 C14 B21 C05 C01 A01 A08 D18 �ŷ�ó�ڵ� �������� �߻����� ����ǥ�ؾ�, ������Ϲ�ȣ, �ͼӻ����, �ſ�ī��, �����ڻ��ǥ
			query3 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+												//3
					"        DT_START, CD_BIZAREA, AM_TAXSTD, AM_ADDTAX, TP_TAX, NO_COMPANY, CD_MNG, "+		//7  �ΰ�������
					"        NO_ASSET, YN_ISS "+
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '"+row_id+""+data_line+"', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '1', '13500', "+ad_bean.getAmt2()+", "+
					"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+"', 1, 98), "+
					"        replace('"+ad_bean.getAcct_dt()+"','-','') , 'S101', "+ad_bean.getAmt()+",  "+ad_bean.getAmt2()+",  '21', '"+ad_bean.getS_idno()+"',  '"+row_id+""+data_line+"', "+  
					"        '"+row_id+""+data_line+"', '2' "+
					" ) ";	

			pstmt3 = con1.prepareStatement(query3);		
			pstmt3.executeUpdate();		
            pstmt3.close();


			//20120827 �����ڻ�����������̺� �߰�
			//�����ڻ��������
			query3 =" insert into fi_adocu_asset ( "+
					"        CD_COMPANY, NO_ASSET, NO_LINE, "+			//3
					"        NO_TAX, DT_PUR, ST_ASSET, "+				//3
					"	     NM_ITEM, QT_ASSET, AM_PUR, AM_TAX "+			//4
					" ) values( "+
					"        '1000', '"+row_id+""+data_line+"', 1, "+
					"	     '"+row_id+""+data_line+"', replace('"+ad_bean.getWrite_dt()+"','-',''), '4', "+
					"	     '"+ad_bean.getNm_item()+"', 1, "+ad_bean.getAmt()+",  "+ad_bean.getAmt2()+" "+
					" ) ";	

			pstmt3 = con1.prepareStatement(query3);		
			pstmt3.executeUpdate();		
            pstmt3.close();


			data_line++;

			//���� �ִ�
			if(ad_bean.getAmt3() > 0){
				

				//20121221 ���ޱ�->�����ޱ�
				query4 =" insert into "+table+" ( "+
						"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
						"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
						"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
						" ) values( "+
						"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
						"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt3()+", "+
						"        '3',  '"+ad_bean.getVen_code2().trim()+"',  substrb('"+ad_bean.getAcct_cont()+"', 1, 98), '' "+
						" ) ";	


				pstmt4 = con1.prepareStatement(query4);
				pstmt4.executeUpdate();	
				pstmt4.close();

				data_line++;
			}


			//�ܱ�1
			if(ad_bean.getAmt4() > 0){

				String trf_cont = pur.getTrf_cont1();
				if(trf_cont.equals("")) trf_cont = pur.getCard_kind1()+"("+pur.getCardno1()+")";

				//��ݿ��� �������� ��������
				acct_code = "";
				pstmt8 = con.prepareStatement(query8);
				pstmt8.setString(1, pur.getRent_mng_id());
				pstmt8.setString(2, pur.getRent_l_cd());
				pstmt8.setString(3, "1");
				rs8 = pstmt8.executeQuery();
				if(rs8.next()){
					acct_code = rs8.getString("acct_code")==null?"":rs8.getString("acct_code");
				}
				rs8.close();
				pstmt8.close();

				acct_code = "25300";

				
				//�뺯-���ޱ�(13100) A06	B21	�ŷ�ó�ڵ� �߻�����
				if(acct_code.equals("13100")){
				
					query5 =" insert into "+table+" ( "+
							"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
							"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
							"        TP_GUBUN, CD_PARTNER, NM_NOTE, DT_START "+
							" ) values( "+
							"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
							"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '13100', "+ad_bean.getAmt4()+", "+
							"        '3',  '"+ad_bean.getVen_code4().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), replace('"+ad_bean.getAcct_dt()+"','-','') "+
							" ) ";	

				    pstmt5 = con1.prepareStatement(query5);
					pstmt5.executeUpdate();
				    pstmt5.close();

					data_line++;

				//�뺯-�����ޱ�(25300) A06	A08	A05 �ŷ�ó�ڵ� �ſ�ī���ȣ ������Ʈ
				}else{

					if(pur.getTrf_st1().equals("3") || pur.getTrf_st1().equals("2") || pur.getTrf_st1().equals("7")){

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt4()+", "+
								"        '3',  '"+ad_bean.getVen_code4().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '"+ad_bean.getCardno1()+"' "+
								" ) ";	

					}else if(pur.getTrf_st1().equals("4")){  //���� 29300 ������Ա�->25900 ������, �����ٵ���� �������ó���� ����

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25900', "+ad_bean.getAmt4()+", "+
								"        '3',  '"+ad_bean.getVen_code4().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '"+ad_bean.getCardno1()+"' "+
								" ) ";	

					}else if(pur.getTrf_st1().equals("5")){ //ĳ�������(91100)->��ǰ��(12600)->ĳ�������(91100) 

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '91100', "+ad_bean.getAmt4()+", "+
								"        '3',  '"+ad_bean.getVen_code4().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '"+ad_bean.getCardno1()+"' "+
								" ) ";	

					}else if(pur.getTrf_st1().equals("6")){ //���������κ�����(�뿩)


						if(ad_bean.getCar_st().equals("2")){ //����
							query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '22010', "+ad_bean.getAmt4()+", "+
								"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '' "+
								" ) ";	
						}else { //��Ʈ
							query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '21810', "+ad_bean.getAmt4()+", "+
								"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '' "+
								" ) ";	
						}


					}else{

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt4()+", "+
								"        '3',  '"+ad_bean.getVen_code2().trim()+"',  substrb('"+ad_bean.getAcct_cont()+"', 1, 98), '' "+
								" ) ";	

					}

				    pstmt5 = con1.prepareStatement(query5);
					pstmt5.executeUpdate();
				    pstmt5.close();

					data_line++;
				}				
			}


			//�ܱ�2
			if(ad_bean.getAmt5() > 0){

				String trf_cont = pur.getTrf_cont2();
				if(trf_cont.equals("")) trf_cont = pur.getCard_kind2()+"("+pur.getCardno2()+")";

				//��ݿ��� �������� ��������
				acct_code = "";
				pstmt8 = con.prepareStatement(query8);
				pstmt8.setString(1, pur.getRent_mng_id());
				pstmt8.setString(2, pur.getRent_l_cd());
				pstmt8.setString(3, "2");
				rs8 = pstmt8.executeQuery();
				if(rs8.next()){
					acct_code = rs8.getString("acct_code")==null?"":rs8.getString("acct_code");
				}
				rs8.close();
				pstmt8.close();

				acct_code = "25300";
				
				
				//�뺯-���ޱ�(13100) A06	B21	�ŷ�ó�ڵ� �߻�����
				if(acct_code.equals("13100")){

					query5 =" insert into "+table+" ( "+
							"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
							"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
							"        TP_GUBUN, CD_PARTNER, NM_NOTE, DT_START "+
							" ) values( "+
							"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
							"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '13100', "+ad_bean.getAmt5()+", "+
							"        '3',  '"+ad_bean.getVen_code5().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), replace('"+ad_bean.getAcct_dt()+"','-','') "+
							" ) ";	

				    pstmt5 = con1.prepareStatement(query5);
					pstmt5.executeUpdate();
				    pstmt5.close();

					data_line++;

				//�뺯-�����ޱ�(25300) A06	A08	A05 �ŷ�ó�ڵ� �ſ�ī���ȣ ������Ʈ
				}else{

					if(pur.getTrf_st2().equals("3") || pur.getTrf_st2().equals("2") || pur.getTrf_st2().equals("7")){

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt5()+", "+
								"        '3',  '"+ad_bean.getVen_code5().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '"+ad_bean.getCardno2()+"' "+
								" ) ";	

					}else if(pur.getTrf_st2().equals("4")){ //���� 29300 ������Ա�->25900 ������, �����ٵ���� �������ó���� ����

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25900', "+ad_bean.getAmt5()+", "+
								"        '3',  '"+ad_bean.getVen_code5().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '"+ad_bean.getCardno2()+"' "+
								" ) ";	

					}else if(pur.getTrf_st2().equals("5")){ //ĳ�������(91100)->��ǰ��(12600) ->ĳ�������(91100) 

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '91100', "+ad_bean.getAmt5()+", "+
								"        '3',  '"+ad_bean.getVen_code5().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '"+ad_bean.getCardno2()+"' "+
								" ) ";	

					}else if(pur.getTrf_st2().equals("6")){ //���������κ�����(�뿩)

						if(ad_bean.getCar_st().equals("1")){
							query5 =" insert into "+table+" ( "+
									"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
									"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
									"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
									" ) values( "+
									"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
									"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '21810', "+ad_bean.getAmt5()+", "+
									"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '' "+
									" ) ";	
						}else {
							query5 =" insert into "+table+" ( "+
									"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
									"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
									"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
									" ) values( "+
									"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
									"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '22010', "+ad_bean.getAmt5()+", "+
									"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '' "+
									" ) ";	
						}


					}else{

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt5()+", "+
								"        '3',  '"+ad_bean.getVen_code2().trim()+"',  substrb('"+ad_bean.getAcct_cont()+"', 1, 98), '' "+
								" ) ";	

					}

				    pstmt5 = con1.prepareStatement(query5);
					pstmt5.executeUpdate();
				    pstmt5.close();

					data_line++;
				}			
			}


			//�ܱ�3
			if(ad_bean.getAmt6() > 0){

				String trf_cont = pur.getTrf_cont3();
				if(trf_cont.equals("")) trf_cont = pur.getCard_kind3()+"("+pur.getCardno3()+")";

				//��ݿ��� �������� ��������
				acct_code = "";
				pstmt8 = con.prepareStatement(query8);
				pstmt8.setString(1, pur.getRent_mng_id());
				pstmt8.setString(2, pur.getRent_l_cd());
				pstmt8.setString(3, "3");
				rs8 = pstmt8.executeQuery();
				if(rs8.next()){
					acct_code = rs8.getString("acct_code")==null?"":rs8.getString("acct_code");
				}
				rs8.close();
				pstmt8.close();

				acct_code = "25300";


				//�뺯-���ޱ�(13100) A06	B21	�ŷ�ó�ڵ� �߻�����
				if(acct_code.equals("13100")){

					query5 =" insert into "+table+" ( "+
							"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
							"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
							"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+
							"        DT_START "+
							" ) values( "+
							"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
							"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '13100', "+ad_bean.getAmt6()+", "+
							"        '3',  '"+ad_bean.getVen_code6().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), "+
							"        replace('"+ad_bean.getAcct_dt()+"','-','') "+
							" ) ";	

				    pstmt5 = con1.prepareStatement(query5);
					pstmt5.executeUpdate();
				    pstmt5.close();

					data_line++;

				//�뺯-�����ޱ�(25300) A06	A08	A05 �ŷ�ó�ڵ� �ſ�ī���ȣ ������Ʈ
				}else{

					if(pur.getTrf_st3().equals("3") || pur.getTrf_st3().equals("2") || pur.getTrf_st3().equals("7")){

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+
								"        CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt6()+", "+
								"        '3',  '"+ad_bean.getVen_code6().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), "+
								"        '"+ad_bean.getCardno3()+"' "+
								" ) ";	

					}else if(pur.getTrf_st3().equals("4")){ //���� 29300 ������Ա�->25900 ������, �����ٵ���� �������ó���� ����

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+
								"        CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25900', "+ad_bean.getAmt6()+", "+
								"        '3',  '"+ad_bean.getVen_code6().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), "+
								"        '"+ad_bean.getCardno3()+"' "+
								" ) ";	

					}else if(pur.getTrf_st3().equals("5")){ //ĳ�������(91100)->��ǰ��(12600) ->ĳ�������(91100) 

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+
								"        CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '91100', "+ad_bean.getAmt6()+", "+
								"        '3',  '"+ad_bean.getVen_code6().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), "+
								"        '"+ad_bean.getCardno3()+"' "+
								" ) ";	

					}else if(pur.getTrf_st3().equals("6")){ //���������κ�����(�뿩)

						if(ad_bean.getCar_st().equals("1")){
							query5 =" insert into "+table+" ( "+
									"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
									"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
									"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
									" ) values( "+
									"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
									"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '21810', "+ad_bean.getAmt6()+", "+
									"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '' "+
									" ) ";	
						}else {
							query5 =" insert into "+table+" ( "+
									"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
									"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
									"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
									" ) values( "+
									"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
									"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '22010', "+ad_bean.getAmt6()+", "+
									"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '' "+
									" ) ";	
						}

					}else{

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+
								"        CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt6()+", "+
								"        '3',  '"+ad_bean.getVen_code2().trim()+"',  substrb('"+ad_bean.getAcct_cont()+"', 1, 98), "+
								"        '' "+
								" ) ";	

					}

				    pstmt5 = con1.prepareStatement(query5);
					pstmt5.executeUpdate();
				    pstmt5.close();

					data_line++;
				}
			}


			//�ܱ�4
			if(ad_bean.getAmt7() > 0){

				String trf_cont = pur.getTrf_cont4();
				if(trf_cont.equals("")) trf_cont = pur.getCard_kind4()+"("+pur.getCardno4()+")";

				//��ݿ��� �������� ��������
				acct_code = "";
				pstmt8 = con.prepareStatement(query8);
				pstmt8.setString(1, pur.getRent_mng_id());
				pstmt8.setString(2, pur.getRent_l_cd());
				pstmt8.setString(3, "4");
				rs8 = pstmt8.executeQuery();
				if(rs8.next()){
					acct_code = rs8.getString("acct_code")==null?"":rs8.getString("acct_code");
				}
				rs8.close();
				pstmt8.close();

				acct_code = "25300";


				//�뺯-���ޱ�(13100) A06	B21	�ŷ�ó�ڵ� �߻�����
				if(acct_code.equals("13100")){

					query5 =" insert into "+table+" ( "+
							"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
							"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
							"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+
							"        DT_START "+
							" ) values( "+
							"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
							"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '13100', "+ad_bean.getAmt5()+", "+
							"        '3',  '"+ad_bean.getVen_code5().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), "+
							"        replace('"+ad_bean.getAcct_dt()+"','-','') "+
							" ) ";	

				    pstmt5 = con1.prepareStatement(query5);
					pstmt5.executeUpdate();
				    pstmt5.close();

					data_line++;

				//�뺯-�����ޱ�(25300) A06	A08	A05 �ŷ�ó�ڵ� �ſ�ī���ȣ ������Ʈ
				}else{

					if(pur.getTrf_st4().equals("3") || pur.getTrf_st4().equals("2") || pur.getTrf_st4().equals("7")){

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+
								"        CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt7()+", "+
								"        '3',  '"+ad_bean.getVen_code7().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), "+
								"        '"+ad_bean.getCardno4()+"' "+
								" ) ";	

					}else if(pur.getTrf_st4().equals("4")){ //���� 29300 ������Ա�->25900 ������, �����ٵ���� �������ó���� ����

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+
								"        CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25900', "+ad_bean.getAmt7()+", "+
								"        '3',  '"+ad_bean.getVen_code7().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), "+
								"        '"+ad_bean.getCardno4()+"' "+
								" ) ";	

					}else if(pur.getTrf_st4().equals("5")){ //ĳ�������(91100)->��ǰ��(12600) ->ĳ�������(91100) 

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+
								"        CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '91100', "+ad_bean.getAmt7()+", "+
								"        '3',  '"+ad_bean.getVen_code7().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), "+
								"        '"+ad_bean.getCardno4()+"' "+
								" ) ";	

					}else if(pur.getTrf_st4().equals("6")){ //���������κ�����(�뿩)

						if(ad_bean.getCar_st().equals("1")){
							query5 =" insert into "+table+" ( "+
									"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
									"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
									"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
									" ) values( "+
									"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
									"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '21810', "+ad_bean.getAmt7()+", "+
									"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '' "+
									" ) ";	
						}else {
							query5 =" insert into "+table+" ( "+
									"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
									"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
									"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
									" ) values( "+
									"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
									"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '22010', "+ad_bean.getAmt7()+", "+
									"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+":"+trf_cont+"', 1, 98), '' "+
									" ) ";	
						}


					}else{

						query5 =" insert into "+table+" ( "+
								"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
								"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
								"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+
								"        CD_CARD "+
								" ) values( "+
								"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
								"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt7()+", "+
								"        '3',  '"+ad_bean.getVen_code2().trim()+"',  substrb('"+ad_bean.getAcct_cont()+"', 1, 98), "+
								"        '' "+
								" ) ";	

					}

				    pstmt5 = con1.prepareStatement(query5);
					pstmt5.executeUpdate();
				    pstmt5.close();

					data_line++;
				}				
			}

            con1.commit();
			con.commit();

		}catch(Exception se){
            try{
				count = 1;
				data_no = 0;
				System.out.println("[NeoErpUDatabase:insertCarPurAmtAutoDocu]"+se);
                con1.rollback();
				con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
				if(rs8 != null) rs8.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
                if(pstmt4 != null) pstmt4.close();
                if(pstmt5 != null) pstmt5.close();
                if(pstmt6 != null) pstmt6.close();
                if(pstmt7 != null) pstmt7.close();
				if(pstmt8 != null) pstmt8.close();
				if(con1 != null)   con1.close();
				if(con != null)   con.close();
                con1.setAutoCommit(true);
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			connMgr.freeConnection(DATA_SOURCE1, con);
			con1 = null;
			con = null;
        }
        return row_id;
    }


   /**
     *	�������� �ڵ���ǥ ��� 
     */
    public String insertCommiAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt  = null;
		PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
        PreparedStatement pstmt6 = null;
        PreparedStatement pstmt7 = null;
        PreparedStatement pstmt8 = null;

        ResultSet rs = null;

        String query = "";
        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
        String query5 = "";
        String query6 = "";
        String query7 = "";
        String query8 = "";

        int data_line = 1;
		String row_id = "";

		String table = "fi_adocu";


	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);


			//ó����ȣ �̱�
			query =" select 'AM' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001') as row_id "+
					" from   "+table+" "+
					"   WHERE ROW_ID LIKE 'AM'|| replace(?,'-','')|| '%'   ";

			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, ad_bean.getAcct_dt().trim());
			pstmt.setString(2, ad_bean.getAcct_dt().trim());
			rs = pstmt.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();	
			}
			rs.close();
			pstmt.close();	


			//��������(45500)-���� --A02 A05 A04 A06 �ڽ�Ʈ���� ������Ʈ ��� �ŷ�ó�ڵ�
			query1 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT, NO_DOCU, NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, CD_PARTNER, CD_CC, NM_NOTE "+										//4
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getAcct_dt()+"','-',''),  '1',  '1', '45500', "+ad_bean.getAmt()+", "+
					"        '3', '"+ad_bean.getVen_code()+"', '200', substrb('"+ad_bean.getAcct_cont()+"', 1, 98) "+
					" ) ";	

			pstmt1 = con1.prepareStatement(query1);
			pstmt1.executeUpdate();
			pstmt1.close();

			data_line++;


			//������(25400)-�뺯 (�ҵ漼) --B21	A06 �߻����� �ŷ�ó (������������)
			query2 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, CD_PARTNER, DT_START, NM_NOTE "+										//4
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '"+row_id+""+data_line+"', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getAcct_dt()+"','-',''),  '1',  '2', '25400', "+ad_bean.getAmt2()+", "+
					"        '3',  '001272',  replace('"+ad_bean.getAcct_dt()+"','-',''), substrb('"+"[�ҵ漼]"+ad_bean.getFirm_nm().trim()+" "+ad_bean.getAcct_cont().trim()+"', 1, 98) "+
					" ) ";

			pstmt2 = con1.prepareStatement(query2);
			pstmt2.executeUpdate();	
			pstmt2.close();

			data_line++;


			//������(25400)-�뺯 (�ҵ漼) --B21	A06 �߻����� �ŷ�ó (��������û)
			query3 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, CD_PARTNER, DT_START, NM_NOTE "+										//4
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '"+row_id+""+data_line+"', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getAcct_dt()+"','-',''),  '1',  '2', '25400', "+ad_bean.getAmt3()+", "+
					"        '3',  '001281',  replace('"+ad_bean.getAcct_dt()+"','-',''), substrb('"+"[�ֹμ�]"+ad_bean.getFirm_nm().trim()+" "+ad_bean.getAcct_cont().trim()+"', 1, 98) "+
					" ) ";

			pstmt3 = con1.prepareStatement(query3);
			pstmt3.executeUpdate();
			pstmt3.close();

			data_line++;


			//���뿹��-�뺯 --A09	A07 ������� �����ݰ���
			query4 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, CD_BANK, NO_DEPOSIT, NM_NOTE "+										//4
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '"+row_id+""+data_line+"', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getAcct_dt()+"','-',''),  '1',  '2', '10300', "+ad_bean.getAmt4()+", "+
					"        '3',  '"+ad_bean.getBank_code()+"',  '"+ad_bean.getDeposit_no()+"', substrb('"+ad_bean.getAcct_cont().trim()+"', 1, 98) "+
					" ) ";

			pstmt4 = con1.prepareStatement(query4);
			pstmt4.executeUpdate();
			pstmt4.close();

			data_line++;


			if(ad_bean.getAmt8()>0 && ad_bean.getAcct_cd4().equals("83100")){

				//���޼�����(�۱ݼ�����)-����--A02	A05	A04	A06 �ڽ�Ʈ���� ������Ʈ ��� �ŷ�ó�ڵ�
				query5 =" insert into "+table+" ( "+
						"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT, NO_DOCU, NO_DOLINE, "+				//7
						"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
						"        TP_GUBUN, CD_PARTNER, CD_CC, NM_NOTE "+										//4
						" ) values( "+
						"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
						"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getAcct_dt()+"','-',''),  '1',  '1', '83100', "+ad_bean.getAmt8()+", "+
						"        '3', '', '200', substrb('"+ad_bean.getAcct_cont()+"', 1, 98) "+
						" ) ";	


				//DATA_GUBUN = 53 -> �ڷᱸ��:��Ÿ(53)

				pstmt5 = con1.prepareStatement(query5);
				pstmt5.executeUpdate();
				pstmt5.close();

				data_line++;

			}

			//���İ���1 (-) ������
			if(ad_bean.getAmt5()<0 && ad_bean.getAcct_cd1().equals("25400")){

				//������(25400)-�뺯 (�ҵ漼) --B21	A06 �߻����� �ŷ�ó 
				query6 =" insert into "+table+" ( "+
						"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+				//7
						"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
						"        TP_GUBUN, CD_PARTNER, DT_START, NM_NOTE "+										//4
						" ) values( "+
						"        '"+row_id+"', '"+data_line+"', '"+row_id+""+data_line+"', 'S101', '200', '"+row_id+"', "+data_line+", "+
						"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getAcct_dt()+"','-',''),  '1',  '2', '25400', "+-ad_bean.getAmt5()+", "+
						"        '3',  '',  replace('"+ad_bean.getAcct_dt()+"','-',''), substrb('"+"[����]"+ad_bean.getAcct_cont1().trim()+" "+ad_bean.getAcct_cont().trim()+"', 1, 98) "+
					" ) ";

				pstmt6 = con1.prepareStatement(query6);
				pstmt6.executeUpdate();
				pstmt6.close();

				data_line++;
			}

			//���İ���2 (-) ������
			if(ad_bean.getAmt6()<0 && ad_bean.getAcct_cd2().equals("25400")){

				//������(25400)-�뺯 (�ҵ漼) --B21	A06 �߻����� �ŷ�ó 
				query7 =" insert into "+table+" ( "+
						"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+				//7
						"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
						"        TP_GUBUN, CD_PARTNER, DT_START, NM_NOTE "+										//4
						" ) values( "+
						"        '"+row_id+"', '"+data_line+"', '"+row_id+""+data_line+"', 'S101', '200', '"+row_id+"', "+data_line+", "+
						"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getAcct_dt()+"','-',''),  '1',  '2', '25400', "+-ad_bean.getAmt6()+", "+
						"        '3',  '',  replace('"+ad_bean.getAcct_dt()+"','-',''), substrb('"+"[����]"+ad_bean.getAcct_cont2().trim()+" "+ad_bean.getAcct_cont().trim()+"', 1, 98) "+
					" ) ";

				pstmt7 = con1.prepareStatement(query7);
				pstmt7.executeUpdate();
				pstmt7.close();

				data_line++;
			}

			//���İ���3 (-) ������
			if(ad_bean.getAmt7()<0 && ad_bean.getAcct_cd3().equals("25400")){

				//������(25400)-�뺯 (�ҵ漼) --B21	A06 �߻����� �ŷ�ó 
				query8 =" insert into "+table+" ( "+
						"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+				//7
						"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
						"        TP_GUBUN, CD_PARTNER, DT_START, NM_NOTE "+										//4
						" ) values( "+
						"        '"+row_id+"', '"+data_line+"', '"+row_id+""+data_line+"', 'S101', '200', '"+row_id+"', "+data_line+", "+
						"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getAcct_dt()+"','-',''),  '1',  '2', '25400', "+-ad_bean.getAmt7()+", "+
						"        '3',  '',  replace('"+ad_bean.getAcct_dt()+"','-',''), substrb('"+"[����]"+ad_bean.getAcct_cont3().trim()+" "+ad_bean.getAcct_cont().trim()+"', 1, 98) "+
					" ) ";

				pstmt8 = con1.prepareStatement(query8);
				pstmt8.executeUpdate();
				pstmt8.close();

				data_line++;
			}


            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				System.out.println("[NeoErpUDatabase:insertCommiAutoDocu]"+se);
                con.rollback();
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
				if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
                if(pstmt4 != null) pstmt4.close();
                if(pstmt5 != null) pstmt5.close();
                if(pstmt6 != null) pstmt6.close();
                if(pstmt7 != null) pstmt7.close();
                if(pstmt8 != null) pstmt8.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
        }
        return row_id;
    }

     /**
     *	[���] ������Աݰ��� ����������ä�������� ��ü ��ǥ
     */
    public String insertDebtSettleAutoDocu(String write_date, Vector vt) throws DatabaseException, DataSourceEmptyException{
        Connection con  = connMgr.getConnection(DATA_SOURCE);	//acar
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);	//neom

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;

        String query = "";
        String query2 = "";

		String row_id = "";
		String table = "fi_adocu";	
		String dept_code = "200";

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);


			//ó����ȣ �̱�
			query =" select 'AN' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001') as row_id "+
					" from   "+table+" "+
					"  WHERE ROW_ID LIKE 'AN'|| replace(?,'-','') ||'%' ";     

			pstmt1 = con1.prepareStatement(query);
			pstmt1.setString(1, write_date);
			pstmt1.setString(2, write_date);
			rs = pstmt1.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();
			}
			rs.close();
			pstmt1.close();	


			query2 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU,  NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, NM_NOTE, CD_PARTNER, DT_START, CD_CC, CD_BANK, NO_DEPOSIT, dts_insert "+			//7
					" ) values( "+
					"        ?, ?, '*', 'S101', ?, ?, ?, "+
					"        '1000', ?, '11', replace(?,'-',''),  '1',  ?, ?, ?, "+
					"        '3', ?, ?, replace(?,'-',''), ?, ?, ?, to_char(sysdate,'YYYYMMDD') "+
					" ) ";	

			pstmt2 = con1.prepareStatement(query2);

			for(int i = 0 ; i < vt.size() ; i++){

				Hashtable ht = (Hashtable)vt.elementAt(i);

				dept_code = String.valueOf(ht.get("DEPT_CODE"));	

				if ( dept_code.equals("") || dept_code.equals("null") || AddUtil.lengthb(dept_code) > 4 ) {
				    dept_code = "200";	
				}
					
				
				pstmt2.setString(1, row_id);
				pstmt2.setString(2, String.valueOf(i+1));
				pstmt2.setString(3, dept_code);
				pstmt2.setString(4, row_id);
				pstmt2.setInt   (5, i+1);
				
				pstmt2.setString(6, String.valueOf(ht.get("INSERT_ID")));
				pstmt2.setString(7, String.valueOf(ht.get("WRITE_DATE")));

				if(String.valueOf(ht.get("AMT_GUBUN")).equals("3")) pstmt2.setString(8, "1");
				if(String.valueOf(ht.get("AMT_GUBUN")).equals("4")) pstmt2.setString(8, "2");
				
				//20211116 �������� ������������� 45510 �ϳ��� ���� : 91800->45510
				if(String.valueOf(ht.get("ACCT_CODE")).equals("91800")){
					ht.put("ACCT_CODE","45510");					
				}				

				pstmt2.setString(9, String.valueOf(ht.get("ACCT_CODE")));
				pstmt2.setInt   (10, AddUtil.parseDigit(String.valueOf(ht.get("DR_AMT")))+AddUtil.parseDigit(String.valueOf(ht.get("CR_AMT"))));

				//������Ա�
				if(String.valueOf(ht.get("ACCT_CODE")).equals("29300")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME6"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE1"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, String.valueOf(ht.get("CHECKD_NAME3"))); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//����������ä
				if(String.valueOf(ht.get("ACCT_CODE")).equals("26400")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME4"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE1"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, String.valueOf(ht.get("CHECKD_NAME2"))); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//�ܻ�����
				if(String.valueOf(ht.get("ACCT_CODE")).equals("10800")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME5"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE1"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//��ü�����
				if(String.valueOf(ht.get("ACCT_CODE")).equals("91300")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME5"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE1"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, "200"); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//���뿹��
				if(String.valueOf(ht.get("ACCT_CODE")).equals("10300")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME4"))); //����
					pstmt2.setString(12, ""); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, String.valueOf(ht.get("CHECKD_CODE1"))); //�������
					pstmt2.setString(16, String.valueOf(ht.get("CHECKD_CODE2"))); //�����ݰ���
				}
				//�������ظ�å��
				if(String.valueOf(ht.get("ACCT_CODE")).equals("91800") || String.valueOf(ht.get("ACCT_CODE")).equals("45510")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME5"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE4"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, "200"); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//������ A02	A05	A04	A06
				if(String.valueOf(ht.get("ACCT_CODE")).equals("93000")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME5"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE4"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, "200"); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//���·Ό���� A06	A10 �ŷ�ó ǰ��
				if(String.valueOf(ht.get("ACCT_CODE")).equals("27400")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME3"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE1"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//���·�̼��� A06	A10 �ŷ�ó ǰ��
				if(String.valueOf(ht.get("ACCT_CODE")).equals("12400")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME3"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE1"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//��ս� A02	A05	A04	A06
				if(String.valueOf(ht.get("ACCT_CODE")).equals("96000")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME5"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE4"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, "200"); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//������ A02	A05	A04	A06
				if(String.valueOf(ht.get("ACCT_CODE")).equals("93000")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME5"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE4"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, "200"); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//�뿩�������޺���� A06
				if(String.valueOf(ht.get("ACCT_CODE")).equals("13300")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME3"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE2"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//�����������޺���� A06
				if(String.valueOf(ht.get("ACCT_CODE")).equals("13200")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME3"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE2"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//�̼��� --A06	B21
				if(String.valueOf(ht.get("ACCT_CODE")).equals("12000")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME4"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE1"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//�����ޱ� --A06	A08	A05
				if(String.valueOf(ht.get("ACCT_CODE")).equals("25300")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME5"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE1"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//ĳ������� --A06	A08	A05
				if(String.valueOf(ht.get("ACCT_CODE")).equals("91100")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME5"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE1"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}
				//������ --A06	A08	A05
				if(String.valueOf(ht.get("ACCT_CODE")).equals("25900")){
					pstmt2.setString(11, String.valueOf(ht.get("CHECKD_NAME5"))); //����
					pstmt2.setString(12, String.valueOf(ht.get("CHECKD_CODE1"))); //�ŷ�ó�ڵ�
					pstmt2.setString(13, ""); //�߻�����
					pstmt2.setString(14, ""); //�ڽ�Ʈ����
					pstmt2.setString(15, ""); //�������
					pstmt2.setString(16, ""); //�����ݰ���
				}

				pstmt2.executeUpdate();
				
			}

			pstmt2.close();

            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				row_id = "";
				System.out.println("[NeoErpUDatabase:insertDebtSettleAutoDocu]"+se);
				System.out.println("[NeoErpUDatabase:insertDebtSettleAutoDocu row_id=]"+row_id);
                con.rollback();
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(rs != null) rs.close();
				if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
        }
        return row_id;
    }

	/**
     * �ڵ���ǥ ��� üũ
     */
    public int getAutodocuChk(String data_gubun, String write_date, String data_no, String data_line, int cr_amt, String checkd_name4) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
		int count = 0;
		String query = "";
        
        query = " select count(*) from FI_ADOCU a where a.CD_DOCU='"+data_gubun+"'";

		if(!write_date.equals(""))		query += " and a.dt_acct	=replace('"+write_date+"','-','')";
		if(!data_no.equals(""))			query += " and a.no_docu	='"+data_no+"'";
		if(!data_line.equals(""))		query += " and a.no_doline	='"+data_line+"'";
		if(cr_amt > 0)					query += " and a.amt		="+cr_amt+"";
		if(!checkd_name4.equals(""))	query += " and a.nm_note	='"+checkd_name4+"'";
		
		try{

			pstmt = con1.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
            pstmt.close();

        }catch(SQLException se){
			 System.out.println("[NeoErpUDatabase:getAutodocuChk]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return count;
    }

	/**
     * �ڵ���ǥ ��ȸ
     */
    public Vector getAutodocuPayList(String write_date, String data_no, String data_gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        
        query = " SELECT a.CD_DOCU AS data_gubun, a.dt_acct AS write_date, a.no_docu AS data_no, a.tp_docu AS docu_stat, decode(a.tp_docu,'N','��ó��','Y','ó��') stat_nm, \n"+
				"        '�Ϲ�' gubun, DECODE(max(a.no_tax),'*','N','Y') taxrela, max(a.NM_NOTE) AS cont \n"+
				" FROM   FI_ADOCU a \n"+
				" where  a.CD_DOCU='11' ";


		if(!write_date.equals(""))		query += " and a.dt_acct	=replace('"+write_date+"','-','')";
		if(!data_no.equals(""))			query += " and a.no_docu	='"+data_no+"'";
		if(!data_gubun.equals(""))		query += " and a.CD_DOCU	='"+data_gubun+"'";
		

		query += " group by a.CD_DOCU, a.dt_acct, a.no_docu, a.tp_docu "+
				 " order by a.dt_acct, a.no_docu, a.CD_DOCU, a.tp_docu";


		try{

			pstmt = con1.prepareStatement(query);
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

        }catch(SQLException se){
			 System.out.println("[NeoErpUDatabase:getAutodocuPayList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return vt;
    }

    /**
     *	�ڵ���ǥ ����
     */
    public boolean deleteAutodocu(String write_date, String data_no, String data_gubun, String taxrela) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        String query1 = "";
		boolean flag = true;
                
		query1 = " delete from FI_ADOCU where dt_acct=replace(?,'-','') and no_docu=? and CD_DOCU=? and tp_docu='N' ";
		

	   try{

            con1.setAutoCommit(false);

			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, write_date);
			pstmt1.setString(2, data_no);
			pstmt1.setString(3, data_gubun);
			pstmt1.executeUpdate();
			pstmt1.close();
			
            con1.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[NeoErpUDatabase:deleteAutodocu]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt1 != null)	pstmt1.close();
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return flag;
    }

	/**
     * �׿���-���������̸�
     */
    public Hashtable getAcctCodeNm(String acct_code) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1); //neom
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = " SELECT nm_pacct AS acct_name, nm_acct AS acct_name2 from FI_ACCTCODE WHERE cd_company='1000' AND cd_acct='"+acct_code+"' ";
        
	    try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);
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
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getAcctCodeNm]"+se);
			System.out.println("[NeoErpUDatabase:getAcctCodeNm]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ht;
    }


/**
     *	�ŷ�ó ���
     */
    public boolean insertTradeHis(TradeBean t_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
		boolean flag = true;

		//String cust_code = getCustCodeNext();
                
		query =" insert into trade_his (CUST_CODE, CUST_NAME, DNAME, S_IDNO, ID_NO, "+
				" MAIL_NO, S_ADDRESS, UPTAE, JONG, MD_GUBUN, DC_RMK, VEN_ST, REG_DT, REG_ID)\n"+
				" values("+
				" ?, ?, ?, replace(?,'-',''), replace(?,'-',''), "+
				" replace(?,'-',''), ?, ?, ?, ?, ?, ?, sysdate, ?)";

	   try{

            con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);

			pstmt.setString(1, t_bean.getCust_code());
			pstmt.setString(2, t_bean.getCust_name());
			pstmt.setString(3, t_bean.getDname()	);
			pstmt.setString(4, t_bean.getS_idno()	);
			pstmt.setString(5, t_bean.getId_no()	);
			pstmt.setString(6, t_bean.getMail_no()	);
			pstmt.setString(7, t_bean.getS_address());
			pstmt.setString(8, t_bean.getUptae()	);
			pstmt.setString(9, t_bean.getJong()		);
			pstmt.setString(10,t_bean.getMd_gubun()	);
			pstmt.setString(11,t_bean.getDc_rmk()	);
			pstmt.setString(12,t_bean.getVen_st()	);
			pstmt.setString(13,t_bean.getUser_id()	);

			pstmt.executeUpdate();
						
            pstmt.close();
            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[NeoErpUDatabase:insertTradeHis]"+se);

				System.out.println("[NeoErpUDatabase:t_bean.getCust_code()]"+t_bean.getCust_code());
				System.out.println("[NeoErpUDatabase:t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[NeoErpUDatabase:t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[NeoErpUDatabase:t_bean.getS_idno()	 ]"+t_bean.getS_idno()	 );
				System.out.println("[NeoErpUDatabase:t_bean.getDname()	 ]"+t_bean.getDname()	 );
				System.out.println("[NeoErpUDatabase:t_bean.getMail_no()	 ]"+t_bean.getMail_no()	 );
				System.out.println("[NeoErpUDatabase:t_bean.getS_address()]"+t_bean.getS_address());
				System.out.println("[NeoErpUDatabase:t_bean.getId_no()	 ]"+t_bean.getId_no()	 );
				System.out.println("[NeoErpUDatabase:t_bean.getUptae()	 ]"+t_bean.getUptae()	 );
				System.out.println("[NeoErpUDatabase:t_bean.getJong()	 ]"+t_bean.getJong()	 );
				System.out.println("[NeoErpUDatabase:t_bean.getUser_id()	 ]"+t_bean.getUser_id()	 );

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

 /**
     *	�ŷ�ó (�ŷ�ó�ڵ�,����ڹ�ȣ) �ߺ�üũ�ϱ�
     */
    public Hashtable getTradeHisCase(String cust_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Hashtable ht = new Hashtable();
        String query = "";
		
        query = " SELECT * FROM trade_his WHERE cust_code='"+cust_code+"' and reg_dt = (select max(reg_dt) from trade_his where cust_code='"+cust_code+"')";

	   try{

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
    
		}catch(SQLException se){
				System.out.println("[NeoErpUDatabase:getTradeHisCase]"+se);
				 throw new DatabaseException();
	    }finally{
			try{
				if(rs != null )		rs.close();
	            if(pstmt != null)	pstmt.close();
			}catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
	    return ht;
    }

/**
     * �׿���-��ü����Ʈ
     */
    public TradeBean [] getTradeHisList(String ven_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
        
        query = " SELECT * FROM trade_his where cust_code = '"+ven_code+"' order by reg_dt";

	//	System.out.println("[AddBillMngDatabase:getTradeHisList]"+query);

        Collection col = new ArrayList();

        try{
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

            while(rs.next()){
                
	            TradeBean bean = new TradeBean();

	            bean.setCust_code	(rs.getString("CUST_CODE")	==null?"":rs.getString("CUST_CODE"));
			    bean.setCust_name	(rs.getString("CUST_NAME")	==null?"":rs.getString("CUST_NAME"));
			    bean.setS_idno		(rs.getString("S_IDNO")		==null?"":rs.getString("S_IDNO"));
				bean.setId_no		(rs.getString("ID_NO")		==null?"":rs.getString("ID_NO"));
	            bean.setDname		(rs.getString("DNAME")		==null?"":rs.getString("DNAME"));
			    bean.setMail_no		(rs.getString("MAIL_NO")	==null?"":rs.getString("MAIL_NO"));
			    bean.setS_address	(rs.getString("S_ADDRESS")	==null?"":rs.getString("S_ADDRESS"));
			    bean.setMd_gubun	(rs.getString("MD_GUBUN")	==null?"":rs.getString("MD_GUBUN"));
			    bean.setDc_rmk		(rs.getString("DC_RMK")		==null?"":rs.getString("DC_RMK"));
			    bean.setVen_st		(rs.getString("VEN_ST")		==null?"":rs.getString("VEN_ST"));
			    bean.setReg_dt		(rs.getString("REG_DT")		==null?"":rs.getString("REG_DT"));
			    bean.setUser_id		(rs.getString("REG_ID")		==null?"":rs.getString("REG_ID"));

				col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getTradeHisList]"+se);
			System.out.println("[NeoErpUDatabase:getTradeHisList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (TradeBean[])col.toArray(new TradeBean[0]);
    }


	/**
     * �ڵ���ǥ ��ȸ
     */
    public Vector getFI_ADOCU_LIST(String dt_acct, String gubun, String nm_note) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        
        query = " SELECT a.* \n"+
				" FROM   FI_ADOCU a \n"+
				" where  a.dt_acct	=replace('"+dt_acct+"','-','') ";

		if(gubun.equals("ins_add"))		query += " and a.nm_note LIKE '%����%"+nm_note+"%' ";
		
		try{

			pstmt = con1.prepareStatement(query);
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

        }catch(SQLException se){
			 System.out.println("[NeoErpUDatabase:getFI_ADOCU_LIST]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return vt;
    }


  /**
     *	[1�ܰ�] data_no ��������
     */
     /*
    public int insertCardAutoDocu_step1(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query1 = "";
        int data_no = 0;
                
		query1 =" select nvl(max(data_no)+1,1) from autodocu where DATA_GUBUN='51' and  write_date=replace(?,'-','')";

	   try{
     
			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getWrite_dt().trim());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}

		    rs.close();
            pstmt1.close();
             
         }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:insertCardAutoDocu_step1]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return data_no;
    }    
 */          

    /**
     *	[2�ܰ�] ������� �ڵ���ǥ ����
     */
     /*
    public boolean insertCardAutoDocu_step2(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt2 = null;
		String query2 = "";
		boolean flag = true;
                
		//�������
		query2 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+ //(WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '3', ?, 0, ?,"+					//(DR_AMT, ACCT_CODE)
				"  ?,  ?,  ?,  ?,  ?,"+									//(CHECK_CODE1 ~CHECK_CODE5)
				"  ?, '', '', '', '',"+									//(CHECK_CODE6 ~CHECK_CODE10)
				"  ?,  ?,  ?,  ?,  ?,"+									//(CHECKD_CODE1~CHECKD_CODE5)
				"  ?, '', '', '', '',"+									//(CHECKD_CODE6~CHECKD_CODE10)
				"  substrb(?, 1, 98),  substrb(?, 1, 98),  substrb(?, 1, 98),  substrb(?, 1, 98),  substrb(?, 1, 98),"+									//(CHECKD_NAME1~CHECKD_NAME5)
				"  substrb(?, 1, 98), '', '', '', '',"+									//(CHECKD_NAME6~CHECKD_NAME10)
				" ?, to_char(sysdate,'YYYYMMDD') )";					//(INSERT_ID)

	   try{

            con1.setAutoCommit(false);

			//����-�������------------------------------------------------------------------------------------
			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1, ad_bean.getWrite_dt().trim());
			pstmt2.setInt   (2, ad_bean.getData_no());
			if(ad_bean.getData_line() == 0){ 
				pstmt2.setInt	(3, 1);
			}else{
				pstmt2.setInt	(3, ad_bean.getData_line());
			}
			pstmt2.setString(4, ad_bean.getNode_code().trim());
			pstmt2.setInt   (5, ad_bean.getAmt());

			//2006��3��1�� �ŷ��к��� �������� �ڵ尪�� ����ȴ�.-------

			if(ad_bean.getAcct_code().equals("00001")){//�����Ļ���
				if(AddUtil.parseInt(ad_bean.getWrite_dt()) < 20060301){
					if(ad_bean.getDept_code().equals("500") || ad_bean.getDept_code().equals("400")){//������,������
						pstmt2.setString(6, "51100");
					}else{
						pstmt2.setString(6, "81100");
					}
				}else{
						pstmt2.setString(6, "81100");
				}
			}else if(ad_bean.getAcct_code().equals("00002")){//�����
				if(AddUtil.parseInt(ad_bean.getWrite_dt()) < 20060301){
						pstmt2.setString(6, "51300");
				}else{
						pstmt2.setString(6, "81300");
				}
			}else if(ad_bean.getAcct_code().equals("00003")){//�������
				if(AddUtil.parseInt(ad_bean.getWrite_dt()) < 20060301){
					if(ad_bean.getDept_code().equals("500") || ad_bean.getDept_code().equals("400")){//������,������
						pstmt2.setString(6, "51200");
					}else{
						pstmt2.setString(6, "81200");
					}
				}else{
						pstmt2.setString(6, "81200");
				}
			}else if(ad_bean.getAcct_code().equals("00004")){//����������
				if(AddUtil.parseInt(ad_bean.getWrite_dt()) < 20060301){
						pstmt2.setString(6, "54000");
				}else if(AddUtil.parseInt(ad_bean.getWrite_dt()) > 20060301 && AddUtil.parseInt(ad_bean.getWrite_dt()) < 20080101){
						pstmt2.setString(6, "85800");
				}else{
						pstmt2.setString(6, "45800");
				}
			}else if(ad_bean.getAcct_code().equals("00005")){//���������
				if(AddUtil.parseInt(ad_bean.getWrite_dt()) < 20060301){
						pstmt2.setString(6, "53900");
				}else if(AddUtil.parseInt(ad_bean.getWrite_dt()) > 20060301 && AddUtil.parseInt(ad_bean.getWrite_dt()) < 20080101){
						pstmt2.setString(6, "85700");
				}else{
						pstmt2.setString(6, "45700");
				}
			}else if(ad_bean.getAcct_code().equals("00006")){//��������
				if(AddUtil.parseInt(ad_bean.getWrite_dt()) < 20080101){
						pstmt2.setString(6, "85600");
				}else{
						pstmt2.setString(6, "45600");
				}

			}else if(ad_bean.getAcct_code().equals("00007")){//�繫��ǰ��
						pstmt2.setString(6, "83000");   // 82900->83000 20160509
			}else if(ad_bean.getAcct_code().equals("00008")){//�Ҹ�ǰ��
						pstmt2.setString(6, "83000");
			}else if(ad_bean.getAcct_code().equals("00009")){//��ź�
						pstmt2.setString(6, "81400");
			}else if(ad_bean.getAcct_code().equals("00010")){//�����μ��
				if(AddUtil.parseInt(ad_bean.getWrite_dt()) < 20060301){
						pstmt2.setString(6, "52600");
				}else{
						pstmt2.setString(6, "82600");
				}
			}else if(ad_bean.getAcct_code().equals("00011")){//���޼�����
				if(AddUtil.parseInt(ad_bean.getWrite_dt()) < 20060301){
						pstmt2.setString(6, "54100");
				}else{
						pstmt2.setString(6, "83100");
				}
			}else if(ad_bean.getAcct_code().equals("00012")){//��ǰ
						pstmt2.setString(6, "21200");
			}else if(ad_bean.getAcct_code().equals("00013")){//���ޱ�
						pstmt2.setString(6, "13100");
			}else if(ad_bean.getAcct_code().equals("00014")){//�����Ʒú�
						pstmt2.setString(6, "82500");			
			}else if(ad_bean.getAcct_code().equals("00015")){//���ݰ�����
						pstmt2.setString(6, "46300");		
			}else if(ad_bean.getAcct_code().equals("00016")){//�뿩�������
						pstmt2.setString(6, "21700");		
			}else if(ad_bean.getAcct_code().equals("00017")){//�����������
						pstmt2.setString(6, "21900");
			}else if(ad_bean.getAcct_code().equals("00018")){//��ݺ�
						pstmt2.setString(6, "46400");	
			}else if(ad_bean.getAcct_code().equals("00019")){//������� 20111117 ���������� 81900->������� 81200
						pstmt2.setString(6, "81200");					
			}
			//----------------------------------------------------------

			//(1)�ڵ屸��
			if(ad_bean.getAcct_code().equals("00012")){			//��ǰ
				pstmt2.setString(7, "A01");//�μ��ڵ�
			}else if(ad_bean.getAcct_code().equals("00013")){	//���ޱ�
				pstmt2.setString(7, "A07");//�ŷ�ó
			}else if(ad_bean.getAcct_code().equals("00016")||ad_bean.getAcct_code().equals("00017")){	//�뿩������� �����������
				pstmt2.setString(7, "A07");//�ŷ�ó
			}else{												//�׿�
				pstmt2.setString(7, "A09");//�ͼӺμ�
			}

			//(2,3,4)
			if(ad_bean.getAcct_code().equals("00013")){			//���ޱ�
				pstmt2.setString(8, "F19");//�߻�����
				pstmt2.setString(9, "A19");//��ǥ��ȣ
				pstmt2.setString(10, "A05");//ǥ������
			}else if(ad_bean.getAcct_code().equals("00016")||ad_bean.getAcct_code().equals("00017")){	//�뿩������� �����������
					pstmt2.setString(8, "A19");//��ǥ��ȣ
					pstmt2.setString(9, "A13");//������Ʈ
					pstmt2.setString(10, "A05");//ǥ������
			}else{												//�׿�
				pstmt2.setString(8, "A13");//������Ʈ
				pstmt2.setString(9, "A17");//�����
				pstmt2.setString(10, "A07");//�ŷ�ó
			}

			//(5,6)
			if(ad_bean.getAcct_code().equals("00004") || ad_bean.getAcct_code().equals("00005") || ad_bean.getAcct_code().equals("00006")){//����������,���������,��������
				pstmt2.setString(11, "S01");//ǰ��
				pstmt2.setString(12, "A05");//ǥ������
			}else if(ad_bean.getAcct_code().equals("00002")){	//�����
				pstmt2.setString(11, "T01");//��������
				pstmt2.setString(12, "A05");//ǥ������
			}else if(ad_bean.getAcct_code().equals("00013")){	//���ޱ�
				pstmt2.setString(11, "");
				pstmt2.setString(12, "");
			}else if(ad_bean.getAcct_code().equals("00016")||ad_bean.getAcct_code().equals("00017")){	//�뿩������� �����������
					pstmt2.setString(11, "");
					pstmt2.setString(12, "");
			}else{												//�׿�
				pstmt2.setString(11, "A05");//ǥ������
				pstmt2.setString(12, "");
			}

			//�ڵ尪
			if(ad_bean.getAcct_code().equals("00013")){//���ޱ�
				pstmt2.setString(13, ad_bean.getVen_code().trim());//�ŷ�ó
				pstmt2.setString(14, "");//�߻�����
				pstmt2.setString(15, "");//��ǥ��ȣ
				pstmt2.setString(16, "");//ǥ������
			}else if(ad_bean.getAcct_code().equals("00016")||ad_bean.getAcct_code().equals("00017")){	//�뿩������� �����������
					pstmt2.setString(13, ad_bean.getVen_code().trim());//�ŷ�ó
					pstmt2.setString(14, "");//��ǥ��ȣ
					pstmt2.setString(15, "");//������Ʈ
					pstmt2.setString(16, "");//ǥ������
			}else{
				pstmt2.setString(13, ad_bean.getDept_code().trim());//�ͼӺμ�
				pstmt2.setString(14, "");//������Ʈ
				pstmt2.setString(15, ad_bean.getSa_code().trim());//�����
				pstmt2.setString(16, ad_bean.getVen_code().trim());//�ŷ�ó
			}

			if(ad_bean.getAcct_code().equals("00004") || ad_bean.getAcct_code().equals("00005") || ad_bean.getAcct_code().equals("00006")){//����������,���������,��������
				pstmt2.setString(17, ad_bean.getItem_code().trim());//ǰ��
				pstmt2.setString(18, "");//ǥ������
			}else if(ad_bean.getAcct_code().equals("00002")){//�����
				if(ad_bean.getAmt2() > 0){
					if(ad_bean.getTax_yn().equals("Y"))		pstmt2.setString(17, "21");//��������
					else									pstmt2.setString(17, "27");//��������
				}else{
					pstmt2.setString(17, "27");//��������
				}
				pstmt2.setString(18, "");//ǥ������
			}else{//�׿�
				pstmt2.setString(17, "");//ǥ������
				pstmt2.setString(18, "");
			}

			//�ڵ峻��
			if(ad_bean.getAcct_code().equals("00013")){//���ޱ�
				pstmt2.setString(19, ad_bean.getFirm_nm().trim());//�ŷ�ó
				pstmt2.setString(20, ad_bean.getAcct_dt().trim());//�߻�����
				pstmt2.setString(21, "");//��ǥ��ȣ
				pstmt2.setString(22, ad_bean.getAcct_cont().trim());//ǥ������
			}else if(ad_bean.getAcct_code().equals("00016")||ad_bean.getAcct_code().equals("00017")){	//�뿩������� �����������
					pstmt2.setString(19, ad_bean.getFirm_nm().trim());//�ŷ�ó
					pstmt2.setString(20, "");//��ǥ��ȣ
					pstmt2.setString(21, "");//������Ʈ
					pstmt2.setString(22, ad_bean.getAcct_cont().trim());//ǥ������
			}else{
				pstmt2.setString(19, ad_bean.getDept_name().trim());//�ͼӺμ�
				pstmt2.setString(20, "");//������Ʈ
				pstmt2.setString(21, ad_bean.getKname().trim());//�����
				pstmt2.setString(22, ad_bean.getFirm_nm().trim());//�ŷ�ó
			}

			if(ad_bean.getAcct_code().equals("00004") || ad_bean.getAcct_code().equals("00005") || ad_bean.getAcct_code().equals("00006")){//����������,���������,��������
				pstmt2.setString(23, ad_bean.getItem_name().trim());//ǰ��
				pstmt2.setString(24, ad_bean.getAcct_cont().trim());//ǥ������
			}else if(ad_bean.getAcct_code().equals("00002")){//�����
				pstmt2.setString(23, "�ſ�ī�����");//��������
				pstmt2.setString(24, ad_bean.getAcct_cont().trim());//ǥ������
			}else if(ad_bean.getAcct_code().equals("00013")){//���ޱ�
				pstmt2.setString(23, "");
				pstmt2.setString(24, "");
			}else if(ad_bean.getAcct_code().equals("00016")||ad_bean.getAcct_code().equals("00017")){	//�뿩������� �����������
					pstmt2.setString(23, "");
					pstmt2.setString(24, "");
			}else{//�׿�
				pstmt2.setString(23, ad_bean.getAcct_cont().trim());//ǥ������
				pstmt2.setString(24, "");
			}

			pstmt2.setString(25, ad_bean.getInsert_id().trim());
			pstmt2.executeUpdate();
			   
            pstmt2.close();
            con1.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[NeoErpUDatabase:insertCardAutoDocu_step2]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt2 != null) pstmt2.close();
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return flag;
    }
*/

    /**
     *	[3�ܰ�] �����ޱ� �ڵ���ǥ ����
     */
     /*
    public boolean insertCardAutoDocu_step3(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt3 = null;
        ResultSet rs = null;
        String query3 = "";
		boolean flag = true;
                
		//�����ޱ�
		query3 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+	//(WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '4', 0, ?, '25300',"+				//(CR_AMT)
				" 'A07', 'A19', 'F47', 'A13', 'A05',"+					//�ŷ�ó, ��ǥ��ȣ, �ſ�ī���ȣ, project, ǥ������
				"    '',    '',	   '',	  '',    '',"+
				"     ?,	'',     ?,    '',    '',"+					//�ŷ�ó, �ſ�ī���ȣ
				"    '',	'',    '',    '',    '',"+
				"     ?,	'',     ?,    '',     substrb(?, 1, 98),"+					//�ŷ�ó, �ſ�ī���ȣ, ǥ������
				"    '',	'',    '',    '',    '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";					//(INSERT_ID)

	   try{

            con1.setAutoCommit(false);

			//�뺯-�����ޱ�(25300)------------------------------------------------------------------------------------
			pstmt3 = con1.prepareStatement(query3);
			pstmt3.setString(1, ad_bean.getWrite_dt().trim());
			pstmt3.setInt   (2, ad_bean.getData_no());
			pstmt3.setInt	(3, 2);
			pstmt3.setString(4, ad_bean.getNode_code().trim());
			pstmt3.setInt   (5, ad_bean.getAmt()+ad_bean.getAmt2());
			pstmt3.setString(6, ad_bean.getCom_code().trim());
			pstmt3.setString(7, ad_bean.getCardno().trim());
			pstmt3.setString(8, ad_bean.getCom_name().trim());
			pstmt3.setString(9, ad_bean.getCard_name().trim());
			pstmt3.setString(10, ad_bean.getAcct_cont().trim());
			pstmt3.setString(11, ad_bean.getInsert_id().trim());
			pstmt3.executeUpdate();

		    pstmt3.close();
            con1.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[NeoErpUDatabase:insertCardAutoDocu]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt3 != null) pstmt3.close();
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return flag;
    }
*/

    /**
     *	[4�ܰ�] �ΰ�����ޱ�+���� �ڵ���ǥ ����
     */
     /*
    public boolean insertCardAutoDocu_step4(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
        String query4 = "";
        String query5 = "";
		boolean flag = true;                

		//�ΰ�����ޱ�
		query4 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+	//(WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '3', ?, 0, '13500',"+				//(DR_AMT)
				" 'A07', 'T01', 'F19', 'T03', 'A05',"+					//�ŷ�ó, ��������, �߻�����, ����ǥ�ؾ�, ����
				"    '',    '',	   '',	  '',    '',"+
				"     ?,     ?,    '',    '',    '0',"+					//�ŷ�ó, ��������
				"    '',	'',    '',    '',    '',"+
				"     ?,     ?, replace(?,'-',''), ?,  substrb(?, 1, 98),"+		//�ŷ�ó, ��������, �߻�����, ����ǥ�ؾ�, ����
				"    '',	'',    '',    '',    '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";					//INSERT_ID

		query5 =" insert into taxrela"+
				" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,"+
				" DEPT_CODE, NODE_CODE, C_CODE, BAL_DATE, VEN_TYPE,"+
				" TAX_GU, GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO,"+
				" GONG_AMT2, BUL_GUBUN, CARDNO)"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1,"+					//(WRITE_DATE, DATA_NO, DATA_LINE)
				" '200', ?, '1000', replace(?,'-',''), ?,"+				//(NODE_CODE, BAL_DATE, VEN_TYPE)
				" ?, ?, ?, ?, ?,"+									//(GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO) : tax_gu=11��������,27ī�����
				" 0, '', ? )";											//(CARDNO)

	   try{

            con1.setAutoCommit(false);

				//�뺯-�ΰ�����ޱ�(13500)------------------------------------------------------------------------------------
	            pstmt4 = con1.prepareStatement(query4);
				pstmt4.setString(1, ad_bean.getWrite_dt().trim());
				pstmt4.setInt   (2, ad_bean.getData_no());
				pstmt4.setInt	(3, 3);
				pstmt4.setString(4, ad_bean.getNode_code().trim());
				pstmt4.setInt   (5, ad_bean.getAmt2());
				pstmt4.setString(6, ad_bean.getVen_code().trim());
				if(ad_bean.getTax_yn().equals("Y"))		pstmt4.setString(7, "21");
				else									pstmt4.setString(7, "27");	
				pstmt4.setString(8, ad_bean.getFirm_nm().trim());
				if(ad_bean.getTax_yn().equals("Y"))		pstmt4.setString(9, "����(����)");
				else									pstmt4.setString(9, "ī��(����)");	
				pstmt4.setString(10, ad_bean.getAcct_dt().trim());
				pstmt4.setInt   (11, ad_bean.getAmt());
				pstmt4.setString(12, ad_bean.getAcct_cont().trim());
				pstmt4.setString(13, ad_bean.getInsert_id().trim());
				pstmt4.executeUpdate();

				//�ΰ���
				pstmt5 = con1.prepareStatement(query5);
				pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
				pstmt5.setInt	(2,  ad_bean.getData_no());
				pstmt5.setInt	(3,  3);
				pstmt5.setString(4,  ad_bean.getNode_code().trim());
				pstmt5.setString(5,  ad_bean.getWrite_dt().trim());
				pstmt5.setString(6,  ad_bean.getVen_type().trim());
				if(ad_bean.getTax_yn().equals("Y"))		pstmt5.setString(7,  "21");
				else									pstmt5.setString(7,  "27");
				pstmt5.setInt   (8,  ad_bean.getAmt());
				pstmt5.setInt   (9,  ad_bean.getAmt2());
				pstmt5.setString(10,  ad_bean.getVen_code().trim());
				pstmt5.setString(11,  ad_bean.getS_idno().trim());
				pstmt5.setString(12,  ad_bean.getCardno().trim());
				pstmt5.executeUpdate();

			pstmt4.close();
            pstmt5.close();
            con1.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[NeoErpUDatabase:insertCardAutoDocu_step4]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt4 != null) pstmt4.close();
                if(pstmt5 != null) pstmt5.close();
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return flag;
    }
*/

	/**
     * �뿩�� �Ա�ó�� ��ȸ : con_fee/fee_pay_u.jsp
     */
    public BillMngBean getFeeBillCase(String m_id, String l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		BillMngBean bean = new BillMngBean();        
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";        
		query = " select /*+  merge(a) */ a.client_id, d.r_site, cc.car_no, c.firm_nm, b.fee_bank,"+
				"        decode(e.tax_type,'1',c.ven_code,nvl(d.ven_code,c.ven_code)) ven_code"+
				" from   cont_n_view a, fee b, client c, client_site d, cont e, car_reg cc \n"+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id=c.client_id and a.client_id=d.client_id(+) and a.R_SITE=d.SEQ(+) and a.rent_l_cd=e.rent_l_cd"+
				"        and a.car_mng_id = cc.car_mng_id(+)  and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'";

		try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){
				bean.setCar_no(rs.getString("CAR_NO"));
			    bean.setFirm_nm(rs.getString("FIRM_NM").trim());
			    bean.setFee_bank(rs.getString("FEE_BANK"));
				bean.setClient_id(rs.getString("CLIENT_ID"));
				bean.setSite_id(rs.getString("R_SITE"));
				bean.setVen_code(rs.getString("VEN_CODE"));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[NeoErpUDatabase:getFeeBillCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

     /**
     *	�߰��� �޸޴�� ���ݰ�꼭 ��� 
     */
    public String insertCarPurAmtAc1AutoDocu(AutoDocuBean ad_bean, ContPurBean pur) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        ResultSet rs = null;

        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
		int data_line = 1;
		String row_id = "";
		String table = "fi_adocu";

	   try{

            con1.setAutoCommit(false);

			//ó����ȣ �̱�
			query1 =" select 'AU' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001') as row_id "+
					" from   "+table+" "+					
					" WHERE  ROW_ID LIKE 'AU'|| replace(?,'-','')|| '%'   ";

			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getWrite_dt().trim());
			pstmt1.setString(2, ad_bean.getWrite_dt().trim());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();
			}
			rs.close();
			pstmt1.close();			


			//�뿩������� (����) 21700 21900 : A03 A05 A06 �μ� ������Ʈ �ŷ�ó
			query2 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT, NO_DOCU, NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, CD_PARTNER, NM_NOTE "+												//3
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '1', ?, "+ad_bean.getAmt()+", "+
					"        '3', '"+ad_bean.getVen_code().trim()+"', substrb('"+ad_bean.getAcct_cont()+"', 1, 98) "+
					" ) ";	

			pstmt2 = con1.prepareStatement(query2);
			if(ad_bean.getCar_st().equals("1")){
				pstmt2.setString(1, "21700");
			}else {
				pstmt2.setString(1, "21900");
			}
			pstmt2.executeUpdate();			
		   	pstmt2.close();
		
			data_line++;

			
			//�ΰ�����ޱ� (����) 13500 A06 C14 B21 C05 C01 A01 A08 D18 �ŷ�ó�ڵ� �������� �߻����� ����ǥ�ؾ�, ������Ϲ�ȣ, �ͼӻ����, �ſ�ī��, �����ڻ��ǥ
			query3 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+												//3
					"        DT_START, CD_BIZAREA, AM_TAXSTD, AM_ADDTAX, TP_TAX, NO_COMPANY, CD_MNG, "+		//7  �ΰ�������
					"        NO_ASSET, YN_ISS "+
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '"+row_id+""+data_line+"', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '1', '13500', "+ad_bean.getAmt2()+", "+
					"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+"', 1, 98), "+
					"        replace('"+ad_bean.getWrite_dt()+"','-','') , 'S101', "+ad_bean.getAmt()+",  "+ad_bean.getAmt2()+",  '21', '"+ad_bean.getS_idno()+"',  '"+row_id+""+data_line+"', "+  
					"        '"+row_id+""+data_line+"', '2' "+
					" ) ";	

			pstmt3 = con1.prepareStatement(query3);		
			pstmt3.executeUpdate();		
            pstmt3.close();


			//20120827 �����ڻ�����������̺� �߰�
			//�����ڻ��������
			query3 =" insert into fi_adocu_asset ( "+
					"        CD_COMPANY, NO_ASSET, NO_LINE, "+			//3
					"        NO_TAX, DT_PUR, ST_ASSET, "+				//3
					"	     NM_ITEM, QT_ASSET, AM_PUR, AM_TAX "+			//4
					" ) values( "+
					"        '1000', '"+row_id+""+data_line+"', 1, "+
					"	     '"+row_id+""+data_line+"', replace('"+ad_bean.getWrite_dt()+"','-',''), '4', "+
					"	     '"+ad_bean.getNm_item()+"', 1, "+ad_bean.getAmt()+",  "+ad_bean.getAmt2()+" "+
					" ) ";	

			pstmt3 = con1.prepareStatement(query3);		
			pstmt3.executeUpdate();		
            pstmt3.close();


			data_line++;

			//�����ޱ�
			query4 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
					"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt3()+", "+
					"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+"', 1, 98), '' "+
					" ) ";	

			pstmt4 = con1.prepareStatement(query4);
			pstmt4.executeUpdate();	
			pstmt4.close();

            con1.commit();
			

		}catch(Exception se){
            try{
				System.out.println("[NeoErpUDatabase:insertCarPurAmtAc1AutoDocu]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
                if(pstmt4 != null) pstmt4.close();
				if(con1 != null)   con1.close();
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return row_id;
    }

     /**
     *	�߰��� �߰������� ���ݰ�꼭 ��� 
     */
    public String insertCarPurAmtAc2AutoDocu(AutoDocuBean ad_bean, ContPurBean pur) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        ResultSet rs = null;

        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
		int data_line = 1;
		String row_id = "";
		String table = "fi_adocu";

	   try{

            con1.setAutoCommit(false);

			//ó����ȣ �̱�
			query1 =" select 'AU' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001') as row_id "+
					" from   "+table+" "+					
					" WHERE  ROW_ID LIKE 'AU'|| replace(?,'-','')|| '%'   ";

			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getWrite_dt().trim());
			pstmt1.setString(2, ad_bean.getWrite_dt().trim());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();
			}
			rs.close();
			pstmt1.close();			


			//���ݼ����� (����)
			query2 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT, NO_DOCU, NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, CD_PARTNER, NM_NOTE "+												//3
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '1', '83100', "+ad_bean.getAmt()+", "+
					"        '3', '"+ad_bean.getVen_code().trim()+"', substrb('"+ad_bean.getAcct_cont()+"', 1, 98) "+
					" ) ";	

			pstmt2 = con1.prepareStatement(query2);
			pstmt2.executeUpdate();			
		   	pstmt2.close();
		
			data_line++;

			
			//�ΰ�����ޱ� (����) 13500 A06 C14 B21 C05 C01 A01 A08 D18 �ŷ�ó�ڵ� �������� �߻����� ����ǥ�ؾ�, ������Ϲ�ȣ, �ͼӻ����, �ſ�ī��, �����ڻ��ǥ
			query3 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+				//7
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+		//8
					"        TP_GUBUN, CD_PARTNER, NM_NOTE, "+												//3
					"        DT_START, CD_BIZAREA, AM_TAXSTD, AM_ADDTAX, TP_TAX, NO_COMPANY, CD_MNG, "+		//7  �ΰ�������
					"        NO_ASSET, YN_ISS "+
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '"+row_id+""+data_line+"', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '1', '13500', "+ad_bean.getAmt2()+", "+
					"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+"', 1, 98), "+
					"        replace('"+ad_bean.getWrite_dt()+"','-','') , 'S101', "+ad_bean.getAmt()+",  "+ad_bean.getAmt2()+",  '21', '"+ad_bean.getS_idno()+"',  '"+row_id+""+data_line+"', "+  
					"        '', "+ 
					"	     '2' "+
					" ) ";	

			pstmt3 = con1.prepareStatement(query3);		
			pstmt3.executeUpdate();		
            pstmt3.close();

			data_line++;

			//�����ޱ�
			query4 =" insert into "+table+" ( "+
					"        ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT,  NO_DOCU, NO_DOLINE, "+
					"        CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT, "+
					"        TP_GUBUN, CD_PARTNER, NM_NOTE, CD_CARD "+
					" ) values( "+
					"        '"+row_id+"', '"+data_line+"', '*', 'S101', '200', '"+row_id+"', "+data_line+", "+
					"        '1000', '"+ad_bean.getInsert_id()+"', '11', replace('"+ad_bean.getWrite_dt()+"','-',''),  '1',  '2', '25300', "+ad_bean.getAmt3()+", "+
					"        '3',  '"+ad_bean.getVen_code().trim()+"',  substrb('"+ad_bean.getAcct_cont()+"', 1, 98), '' "+
					" ) ";	

			pstmt4 = con1.prepareStatement(query4);
			pstmt4.executeUpdate();	
			pstmt4.close();

            con1.commit();
			

		}catch(Exception se){
            try{
				System.out.println("[NeoErpUDatabase:insertCarPurAmtAc2AutoDocu]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
                if(pstmt4 != null) pstmt4.close();
				if(con1 != null)   con1.close();
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return row_id;
    }
    
    /**
    *	�������ڰ�꼭 ��ü ��ǥ
    */
   public String insertBuyTaxAutoDocu(String write_date, Vector vt) throws DatabaseException, DataSourceEmptyException{
       Connection con  = connMgr.getConnection(DATA_SOURCE);	//acar
       Connection con1 = connMgr.getConnection(DATA_SOURCE1);	//neom

       if(con == null)
           throw new DataSourceEmptyException("Can't get Connection !!");
       if(con1 == null)
           throw new DataSourceEmptyException("Can't get Connection !!");

       PreparedStatement pstmt1 = null;
       PreparedStatement pstmt2 = null;
       ResultSet rs = null;

       String query = "";
       String query2 = "";

		String row_id = "";
		String table = "fi_adocu";	
		String dept_code = "200";

	   try{

           con.setAutoCommit(false);
           con1.setAutoCommit(false);

			//ó����ȣ �̱�
			query =" select 'AN' || replace(?,'-','') ||  nvl(ltrim(to_char(to_number(max(substr(row_id,11,5))+1), '00000')), '00001') as row_id "+
					" from   "+table+" "+
					"  WHERE ROW_ID LIKE 'AN'|| replace(?,'-','') ||'%' ";     

			pstmt1 = con1.prepareStatement(query);
			pstmt1.setString(1, write_date);
			pstmt1.setString(2, write_date);
			rs = pstmt1.executeQuery();
			if(rs.next()){
				row_id = rs.getString(1).trim();
			}
			rs.close();
			pstmt1.close();	
			 
			query2 =" insert into "+table+" ( "+
					"                                   ROW_ID, ROW_NO, NO_TAX, CD_PC, CD_WDEPT, NO_DOCU, NO_DOLINE,\r\n"
					+ "              					CD_COMPANY, ID_WRITE, CD_DOCU, DT_ACCT, ST_DOCU, TP_DRCR, CD_ACCT, AMT,\r\n"
					+ "              					CD_PARTNER, NM_PARTNER, TP_JOB, CLS_JOB, ADS_HD, NM_CEO,\r\n"
					+ "              					DT_START, AM_TAXSTD, AM_ADDTAX, TP_TAX, NO_COMPANY,\r\n"
					+ "              					NM_NOTE, CD_BIZAREA, CD_DEPT, CD_CC,\r\n"
					+ "              					NO_CASH, ST_MUTUAL, CD_CARD, NO_DEPOSIT, CD_BANK, CD_EMPLOY,\r\n"
					+ "              					CD_MNG, TP_DOCU, NO_ACCT, TP_GUBUN, DTS_INSERT, ID_INSERT "+
					" ) values( "+
					"                                   ?, ?, ?, ?, ?, ?, ?,\r\n"
					+ "              					?, ?, ?, replace(?,'-',''), ?, ?, ?, ?,\r\n"
					+ "              					?, ?, ?, ?, ?, ?,\r\n"
					+ "              					?, ?, ?, ?, ?,\r\n"
					+ "              					?, ?, ?, ?,\r\n"
					+ "              					?, ?, ?, ?, ?, ?,\r\n"
					+ "              					?, ?, ?, ?, TO_CHAR(SYSDATE,'YYYYMMDD'), ? "+
					" ) ";	
				

			pstmt2 = con1.prepareStatement(query2);

			for(int i = 0 ; i < vt.size() ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				dept_code = String.valueOf(ht.get("DEPT_CODE"));	
				if ( dept_code.equals("") || dept_code.equals("null") || AddUtil.lengthb(dept_code) > 4 ) {
				    dept_code = "200";	
				}
				//--Ÿ�ý��۹�ȣ, Ÿ�ý��۶��ι�ȣ, ���ݰ�꼭��ȣ, ȸ�����, �ۼ��μ�, ��ǥ��ȣ, ���ι�ȣ, 1-7
				pstmt2.setString(1, row_id);
				pstmt2.setString(2, String.valueOf(i+1));
				pstmt2.setString(3, row_id+""+String.valueOf(i+1));
				pstmt2.setString(4, "S101");
				pstmt2.setString(5, dept_code);
				pstmt2.setString(6, row_id);
				pstmt2.setInt   (7, i+1);
				//--ȸ���ڵ�, �ۼ����, ��ǥ����(CD_DOCU) : 11 �Ϲ�, ȸ������, ���ο���, ���뱸��, �����ڵ�, �ݾ�, 8-15
				pstmt2.setString(8, "1000");
				pstmt2.setString(9, String.valueOf(ht.get("INSERT_ID")));
				pstmt2.setString(10, "11");
				pstmt2.setString(11, String.valueOf(ht.get("WRITE_DATE")));
				pstmt2.setString(12, "1");
				if(String.valueOf(ht.get("AMT_GUBUN")).equals("3")) pstmt2.setString(13, "1");
				if(String.valueOf(ht.get("AMT_GUBUN")).equals("4")) pstmt2.setString(13, "2");
				pstmt2.setString(14, String.valueOf(ht.get("ACCT_CODE")));
				pstmt2.setInt   (15, AddUtil.parseDigit(String.valueOf(ht.get("DR_AMT")))+AddUtil.parseDigit(String.valueOf(ht.get("CR_AMT"))));
				//--�ŷ�ó�ڵ�, �ŷ�ó��, ����, ����, �ּ�, ��ǥ��, 16-21
				pstmt2.setString(16, String.valueOf(ht.get("VEN_CODE"))); //�ŷ�ó�ڵ�
				pstmt2.setString(17, "");
				pstmt2.setString(18, "");
				pstmt2.setString(19, "");
				pstmt2.setString(20, "");
				pstmt2.setString(21, "");
				//--������, ����ǥ�ؾ�, ����, ��������, ����ڵ�Ϲ�ȣ, 22-26
				pstmt2.setString(22, String.valueOf(ht.get("DT_START"))); //�߻�����
				pstmt2.setString(23, String.valueOf(ht.get("AM_TAXSTD"))); //����ǥ��
				pstmt2.setString(24, "0"); //����
				pstmt2.setString(25, String.valueOf(ht.get("TP_TAX"))); //��������
				pstmt2.setString(26, String.valueOf(ht.get("NO_COMPANY"))); //����ڹ�ȣ
				//--����, �ͼӻ����, �μ�, �ڽ�Ʈ����, 27-30
				pstmt2.setString(27, String.valueOf(ht.get("NM_NOTE"))); //����
				pstmt2.setString(28, String.valueOf(ht.get("CD_BIZAREA"))); //�ͼӻ����
				pstmt2.setString(29, ""); //�μ�
				pstmt2.setString(30, ""); //�ڽ�Ʈ����
				//--���ݿ�������ȣ, �Ұ�������, �ſ�ī���ȣ, �����ݰ���, �������, ���, 31-36
				pstmt2.setString(31, ""); 
				pstmt2.setString(32, ""); 
				pstmt2.setString(33, ""); 
				pstmt2.setString(34, ""); 
				pstmt2.setString(35, ""); 
				pstmt2.setString(36, ""); 
				//--���ݰ�꼭��ȣ, ��ǥó�����, ȸ����ι�ȣ, ��ǥ����(��ü��ǥ)
				pstmt2.setString(37, ""); 
				pstmt2.setString(38, "N"); 
				pstmt2.setInt   (39, 0); 
				pstmt2.setString(40, "3"); 
				pstmt2.setString(41, String.valueOf(ht.get("INSERT_ID")));
				
				pstmt2.executeUpdate();
				
			}

			pstmt2.close();

           con.commit();
           con1.commit();

		}catch(Exception se){
           try{
				row_id = "";
				System.out.println("[NeoErpUDatabase:insertBuyTaxAutoDocu]"+se);
				System.out.println("[NeoErpUDatabase:insertBuyTaxAutoDocu row_id=]"+row_id);
               con.rollback();
               con1.rollback();
           }catch(SQLException _ignored){}
             throw new DatabaseException("exception");
       }finally{
           try{
               con.setAutoCommit(true);
               con1.setAutoCommit(true);
               if(rs != null) rs.close();
				if(pstmt1 != null) pstmt1.close();
               if(pstmt2 != null) pstmt2.close();
           }catch(SQLException _ignored){}
           connMgr.freeConnection(DATA_SOURCE, con);
           connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
       }
       return row_id;
   }    

}