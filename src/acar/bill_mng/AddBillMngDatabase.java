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

public class AddBillMngDatabase
{
	private static AddBillMngDatabase instance;
	private Connection conn = null;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE = "acar";
    private final String DATA_SOURCE1 = "neom"; 
    private final String DATA_SOURCE2 = "neom_b"; 
 
	public static synchronized AddBillMngDatabase getInstance() {
        if (instance == null)
            instance = new AddBillMngDatabase();
        return instance;
    }
    
   	private AddBillMngDatabase()  {
        connMgr = DBConnectionManager.getInstance();
    }
	
	
	/** Ư�� ���ڵ带 Bean�� �����Ͽ� Bean�� �����ϴ� �޼ҵ�********************************************/
	
  
    private BillMngBean makeBillMngBean(ResultSet results) throws DatabaseException {

        try {
            BillMngBean bean = new BillMngBean();

			bean.setTax_kd(results.getString("TAX_KD"));
			bean.setBrch_id(results.getString("BRCH_ID"));
		    bean.setCar_no(results.getString("CAR_NO"));
		    bean.setVen_code(results.getString("VEN_CODE"));
		    bean.setClient_st(results.getString("CLIENT_ST"));
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));
		    bean.setRent_st(results.getString("RENT_ST"));
		    bean.setClient_id(results.getString("CLIENT_ID"));
		    bean.setBus_cdt(results.getString("BUS_CDT"));
		    bean.setBus_itm(results.getString("BUS_ITM"));
		    bean.setEnp_no(results.getString("ENP_NO"));
		    bean.setClient_nm(results.getString("CLIENT_NM"));
		    bean.setFirm_nm(results.getString("FIRM_NM"));
		    bean.setFee_est_dt(results.getString("FEE_EST_DT"));
		    bean.setReg_dt(results.getString("REG_DT"));
		    bean.setFee_tm(results.getString("FEE_TM"));
		    bean.setTm_st1(results.getString("TM_ST1"));
		    bean.setFee_s_amt(results.getString("FEE_S_AMT"));
		    bean.setFee_v_amt(results.getString("FEE_V_AMT"));
		    bean.setFee_t_amt(results.getString("FEE_T_AMT"));
		    bean.setTax_gubun(results.getString("TAX_GUBUN"));
		    		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

		//���ݰ�꼭 ��ȸ ---------------------------------------------------------------------------------------

	/**
     * ��� ��Ȳ ��ȸ : bill_mng/bill_sc_in.jsp
     */
    public BillMngBean [] getBillAll(String gubun1, String gubun2, String st_dt, String end_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        String sh_query = "";
        String gubun_query = "";        
        String query = "";
        
        /* �Ⱓ */
        if(gubun2.equals("1")){ //����
        	sub_query	= " and f.fee_est_dt=to_char(sysdate,'YYYYMMDD')\n";
        	sh_query	= " where hday=to_char(sysdate,'YYYYMMDD')\n";
        }else if(gubun2.equals("2")){//���
        	sub_query	= " and f.fee_est_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        	sh_query	= " where hday like to_char(sysdate,'YYYYMM')||'%'\n";
        }else if(gubun2.equals("3")){//����
        	sub_query	= " and f.fee_est_dt like to_char(sysdate,'YYYY')||'%'\n";
        	sh_query	= " where hday like to_char(sysdate,'YYYY')||'%'\n";
        }else if(gubun2.equals("4")){//Ư���Ⱓ
        	sub_query	= " and f.fee_est_dt between replace('" + st_dt + "','-','') and replace('" + end_dt + "','-','')\n";
        	sh_query	= " where hday between replace('" + st_dt + "','-','') and replace('" + end_dt + "','-','')\n";
        }else{
        	sub_query = "";
        }

		//�˻�����
        if(s_kd.equals("firm_nm")){	       		gubun_query = "and c.firm_nm like '%" + t_wd + "%'\n";
        }else if(s_kd.equals("client_nm")){		gubun_query = "and c.client_nm like '%" + t_wd + "%'\n";
        }else if(s_kd.equals("bus_itm")){		gubun_query = "and c.bus_itm like '%" + t_wd + "%'\n";
        }else if(s_kd.equals("bus_cdt")){		gubun_query = "and c.bus_cdt like '%" + t_wd + "%'\n";
        }else if(s_kd.equals("enp_no")){		gubun_query = "and c.enp_no like '%" + t_wd + "%'\n";
        }else{	        						gubun_query = "";
        }
        
		query = " select"+
				" a.tax_kd, a.brch_id, a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_no, "+
				" a.ven_code, a.client_st, a.bus_cdt, a.bus_itm, a.enp_no, a.client_nm, a.firm_nm, a.rent_st,"+
				" a.fee_tm, a.tm_st1, a.fee_s_amt, a.fee_v_amt, a.fee_s_amt+a.fee_v_amt as FEE_T_AMT,"+
				" a.reg_dt, a.tax_gubun, a.fee_est_dt\n"+
				" from"+
					" ( select"+
					"	'1' as TAX_KD, a.brch_id, a.rent_mng_id, a.rent_l_cd, a.client_id, b.car_no,"+
					"	h.ven_code, decode(c.client_st,'1','0','1') as CLIENT_ST, c.bus_cdt, c.bus_itm,"+
					"	decode(c.client_st,'1',c.enp_no,c.ssn) as ENP_NO, c.client_nm, nvl(c.firm_nm,c.client_nm) as FIRM_NM,"+
					"	f.rent_st, f.r_fee_est_dt as fee_est_dt, f.fee_tm, f.tm_st1, f.fee_s_amt, f.fee_v_amt,"+
					"	f.fee_s_amt+f.fee_v_amt as FEE_T_AMT,"+
					"	nvl2(g.reg_dt,substr(g.reg_dt,1,4)||'-'||substr(g.reg_dt,5,2)||'-'||substr(g.reg_dt,7,2),'') as REG_DT,nvl2(g.tax_id,'����','�̹���') as TAX_GUBUN\n"+
					"	from cont a, car_reg b, client c, fee d, scd_fee f, tax g, dzais.vendor h\n"+
					"	where"+
					"	a.car_mng_id = b.car_mng_id(+) and a.client_id = c.client_id\n"+
					"	and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd"+
					"	and d.rent_mng_id = f.rent_mng_id and d.rent_l_cd = f.rent_l_cd and d.rent_st = f.rent_st\n"+
					"	and nvl(a.use_yn,'Y')='Y'"+
					"	and d.rent_st='1' and f.tm_st1='0'"+
					"	and h.ven_name = nvl(c.firm_nm,c.client_nm)"+
					"	and f.rent_mng_id = g.rent_mng_id(+) and f.rent_l_cd = g.rent_l_cd(+) and f.rent_st = g.rent_st(+)"+
					"	and f.fee_tm = g.fee_tm(+) and f.tm_st1 = g.tm_st1(+)"
					+ gubun_query
					+ sub_query+//����ȸ
					" ) a"+
				" order by a.firm_nm, a.rent_mng_id, a.rent_l_cd, to_number(a.fee_tm), to_number(a.tm_st1)\n";

		Collection<BillMngBean> col = new ArrayList<BillMngBean>();

		try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
				col.add(makeBillMngBean(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[AddBillMngDatabase:getBillAll]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (BillMngBean[])col.toArray(new BillMngBean[0]);
    }

	
	public String getValidDt(String dt) throws DatabaseException, DataSourceEmptyException
	{	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		String sysdate = dt;
		boolean s_flag = false;
		boolean h_flag = false;
		String c_sysdate = "";
		String c_hol = "";

		while((!s_flag) || (!h_flag))
		{
			boolean flag = false;
			String query;
			PreparedStatement pstmt = null;
			PreparedStatement pstmt1 = null;
			ResultSet rs = null;
			String rtnStr = "";
						
			query = "select decode(to_char(to_date(?, 'YYYY-MM-DD'), 'DY'),"+
						" '��', to_char(to_date(?, 'YYYY-MM-DD')-1, 'YYYY-MM-DD'), 'N')"+
						" from dual";
			try{
				pstmt = con.prepareStatement(query);
				pstmt.setString(1, sysdate);
				pstmt.setString(2, sysdate);
		    	rs = pstmt.executeQuery();
				while(rs.next())
				{
					rtnStr = rs.getString(1)==null?"":rs.getString(1);
				}

				if(!rtnStr.equals("N"))	/* �Ͽ����ΰ�� �Ϸ縦 �����ش� */
					sysdate = rtnStr;

				c_sysdate = sysdate;

				if(!c_sysdate.equals(sysdate))	/* ����üũ�� ���ϵ� ��¥�� ������ ��¥�� �ٸ��ٸ� */
					sysdate = c_sysdate;
				else
					s_flag = true;
			
				if(s_flag && h_flag)	return sysdate;

				query = "select decode(count(*), 0, 'N', to_char(to_date(?, 'YYYY-MM-DD')-1, 'YYYY-MM-DD')) "+
					" from holiday "+
					" where hday = replace(?, '-', '')";

				while(!flag)
				{
					pstmt1 = con.prepareStatement(query);
					pstmt1.setString(1, sysdate);
					pstmt1.setString(2, sysdate);
			    	rs = pstmt1.executeQuery();
					while(rs.next())
					{
						rtnStr = rs.getString(1)==null?"":rs.getString(1);
					}
					if(!rtnStr.equals("N"))	sysdate = rtnStr;		/* �����ΰ�� �Ϸ縦 ���ϰ� �ٽ� �ѹ� �������� Ȯ�� */
					else					flag = true;		/*  ������ �ƴѰ�� loop�� �������´�. */
				}
				
				c_sysdate = sysdate;
			}catch (SQLException e)
			{
		  		e.printStackTrace();
			}
			finally
			{
				try
				{
	                if(rs != null )		rs.close();
		            if(pstmt != null)	pstmt.close();
		            if(pstmt1 != null)	pstmt1.close();
				}catch(Exception ignore){}
				connMgr.freeConnection(DATA_SOURCE, con);
				con = null;
			}
			if(!c_sysdate.equals(sysdate))	/*������ũ�� ���ϵ� ��¥�� ������ ��¥�� �ٸ��ٸ� */
				sysdate = c_sysdate;
			else
				h_flag = true;
		}
		return sysdate;
	}
	
	/**
	 *	args�� �Ѿ�� ��¥�� �����ΰ�� �Ϸ羿 ���ؼ� ���� ����� ���ϳ�¥�� ����
	 */
	
	private String checkHday(String dt) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);	
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		boolean flag = false;
		String sysdate = dt;
		String query;
		String rStr;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";

		query = "select decode(count(*), 0, 'N', to_char(to_date(?, 'YYYY-MM-DD')+1, 'YYYY-MM-DD')) "+
				" from holiday "+
				" where hday = replace(?, '-', '')";
		try
		{
			while(!flag)
			{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, sysdate);
				pstmt.setString(2, sysdate);
		    	rs = pstmt.executeQuery();
				while(rs.next())
				{
					rtnStr = rs.getString(1)==null?"":rs.getString(1);
				}
				if(!rtnStr.equals("N"))	sysdate = rtnStr;		/* �����ΰ�� �Ϸ縦 ���ϰ� �ٽ� �ѹ� �������� Ȯ�� */
				else					flag = true;			/*  ������ �ƴѰ�� loop�� �������´�. */
			}
		}catch (SQLException e)
		{
	  		e.printStackTrace();
		}
		finally
		{
			try
			{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, conn);
			conn = null;
		}
		return sysdate;
	}

    /**
     *	���ݰ�꼭 ��� 
     */
    public int insertTax(TaxBean [] tb_r, String neom) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmtr = null;
        PreparedStatement pstmta_1 = null;
        PreparedStatement pstmta_2 = null;
        PreparedStatement pstmta_3 = null;
        ResultSet rs = null;
        String query = "";
        String n_queryr = "";
        String n_querya_1 = "";
        String n_querya_2 = "";
        String n_querya_3 = "";
        String n_query2 = "";
        String car_no_list = "";
        String neom_iss_dt = "";
        String neom_brch_id = "";
        String neom_ven_code = "";
        String neom_firm_nm = "";
        String neom_car_no = "";
        String neom_enp_no = "";
        String neom_client_st = "";
        int neom_sup_amt = 0;
        int neom_add_amt = 0;
        int neom_tot_amt = 0;
        int count = 0;
        int data_no = 0;
                
        query="INSERT INTO TAX(TAX_ID,RENT_MNG_ID,RENT_L_CD,FEE_TM,RENT_ST,TM_ST1,EXCH_ID,ITEM_ST,REG_DT,ISS_DT,SUP_AMT,ADD_AMT,TOT_AMT)\n"
        	+ "SELECT nvl(lpad(max(TAX_ID)+1,6,'0'),'000001'),?,?,?,?,?,?,?,to_char(sysdate,'YYYYMMDD'),replace(?,'-',''),?,?,?\n"
        	+ "FROM TAX";

		n_queryr = "select nvl(max(data_no)+1,1) from autodocu where data_gubun = '21' and write_date=replace(?,'-','')";

		n_querya_1 = "insert into autodocu(DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE, DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE, CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10, CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10, CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10, INSERT_ID, INSERT_DATE, MODIFY_ID, MODIFY_DATE)\n"
					+ "values('21',replace(?,'-',''),?,1,1,'200',?,'1000','','0','11','3','3',?,0,'10800','A07','A01','A13','A19','A05','','','','','',?,'','','','0','','','','','',?,'','','',?,'','','','','','2000007',to_char(sysdate,'YYYYMMDD'),'','')";

		n_querya_2 = "insert into autodocu(DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE, DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE, CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10, CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10, CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10, INSERT_ID, INSERT_DATE, MODIFY_ID, MODIFY_DATE)\n"
					+ "values('21',replace(?,'-',''),?,2,1,'200',?,'1000','','0','11','3','4',0,?,'41200','A09','A13','A17','A07','A05','','','','','','','','',?,'','','','','','','','','',?,?,'','','','','','2000007',to_char(sysdate,'YYYYMMDD'),'','')";

		n_querya_3 = "insert into autodocu(DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE, DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE, CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10, CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10, CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10, INSERT_ID, INSERT_DATE, MODIFY_ID, MODIFY_DATE)\n"
					+ "values('21',replace(?,'-',''),?,3,1,'200',?,'1000','','0','11','3','4',0,?,'25500','A07','T01','F19','T03','F45','A05','','','','',?,'11','','','',?,'','','','',?,'����(����)',replace(?,'-',''),?,'',?,'','','','','2000007',to_char(sysdate,'YYYYMMDD'),'','')";
        
        n_query2 = "insert into taxrela(DATA_GUBUN,WRITE_DATE,DATA_NO,DATA_LINE,DATA_SLIP,DEPT_CODE,NODE_CODE,C_CODE,BAL_DATE,VEN_TYPE,TAX_GU,GONG_AMT,TAX_VAT,VEN_CODE,S_IDNO,GONG_AMT2,BUL_GUBUN)\n"
					+ "values('21',replace(?,'-',''),?,3,1,'200',?,'1000',replace(?,'-',''),?,'11',?,?,?,?,0,'')";

       try{
            con.setAutoCommit(false);
			con1.setAutoCommit(false);

            if(neom.equals("one"))
            {
	            pstmt = con.prepareStatement(query);
	
	            for(int i=0; i<tb_r.length; i++){
	                TaxBean tb = new TaxBean();
					tb = tb_r[i];
					neom_sup_amt += tb.getSup_amt();
					neom_add_amt += tb.getAdd_amt();
					neom_tot_amt += tb.getTot_amt();
	                pstmt.setString(1, tb.getRent_mng_id().trim());
	                pstmt.setString(2, tb.getRent_l_cd().trim());
	                pstmt.setString(3, tb.getFee_tm().trim());
	                pstmt.setString(4, tb.getRent_st().trim());
	                pstmt.setString(5, tb.getTm_st1().trim());
	                pstmt.setString(6, tb.getExch_id().trim());
	                pstmt.setString(7, tb.getItem_st().trim());
	                pstmt.setString(8, tb.getIss_dt().trim());
	                pstmt.setInt   (9, tb.getSup_amt());
	                pstmt.setInt   (10, tb.getAdd_amt());
	                pstmt.setInt   (11, tb.getTot_amt());
	                
	                count = pstmt.executeUpdate()+count;
	                
	            }
	           
	            pstmta_1 = con1.prepareStatement(n_querya_1);
	            pstmta_2 = con1.prepareStatement(n_querya_2);
	            pstmta_3 = con1.prepareStatement(n_querya_3);
	            pstmt2 = con1.prepareStatement(n_query2);

			    for(int i=0; i<tb_r.length; i++){
	                TaxBean tb = new TaxBean();
					tb = tb_r[i];
	
					pstmtr = con1.prepareStatement(n_queryr);
					pstmtr.setString(1, tb.getIss_dt().trim());
					rs = pstmtr.executeQuery();
					if(rs.next())
					{
						data_no = Util.parseInt(rs.getString(1).trim());
					}

					rs.close();
					pstmtr.close();

					/*�հ�*/
					pstmta_1.setString(1, tb.getIss_dt().trim());
					pstmta_1.setInt   (2, data_no);
					pstmta_1.setString(3, tb.getBrch_id().trim()+"01");
					pstmta_1.setInt   (4, tb.getTot_amt());
					pstmta_1.setString(5, tb.getVen_code().trim());
					pstmta_1.setString(6, tb.getFirm_nm().trim());
					pstmta_1.setString(7, "�뿩��(" + tb.getFee_tm().trim() + "ȸ�� " + tb.getCar_no().trim() + " " + tb.getFirm_nm().trim() + ")");
	
	                pstmta_1.executeUpdate();
	                
	                pstmta_2.setString(1, tb.getIss_dt().trim());
					pstmta_2.setInt   (2, data_no);
					pstmta_2.setString(3, tb.getBrch_id().trim()+"01");
					pstmta_2.setInt   (4, tb.getSup_amt());
					pstmta_2.setString(5, tb.getVen_code().trim());
					pstmta_2.setString(6, tb.getFirm_nm().trim());
					pstmta_2.setString(7, "�뿩��(" + tb.getFee_tm().trim() + "ȸ�� " + tb.getCar_no().trim() + " " + tb.getFirm_nm().trim() + ")");
	
	                pstmta_2.executeUpdate();
	               
	                pstmta_3.setString(1, tb.getIss_dt().trim());
					pstmta_3.setInt   (2, data_no);
					pstmta_3.setString(3, tb.getBrch_id().trim()+"01");
					pstmta_3.setInt   (4, tb.getAdd_amt());
					pstmta_3.setString(5, tb.getVen_code().trim());
					pstmta_3.setString(6, "0");
					pstmta_3.setString(7, tb.getFirm_nm().trim());
					pstmta_3.setString(8, tb.getIss_dt().trim());
					pstmta_3.setInt   (9, tb.getSup_amt());
					pstmta_3.setString(10, "�뿩��(" + tb.getFee_tm().trim() + "ȸ�� " + tb.getCar_no().trim() + " " + tb.getFirm_nm().trim() + ")");
	
	                pstmta_3.executeUpdate();
	                
	                pstmt2.setString(1, tb.getIss_dt().trim());
					pstmt2.setInt   (2, data_no);
					pstmt2.setString(3, tb.getBrch_id().trim()+"01");
					pstmt2.setString(4, tb.getIss_dt().trim());
					pstmt2.setString(5, tb.getClient_st().trim());//����0,����1
					pstmt2.setInt   (6, tb.getSup_amt());
					pstmt2.setInt   (7, tb.getAdd_amt());
					pstmt2.setString(8, tb.getVen_code().trim());//ȸ������ڵ�
					pstmt2.setString(9, tb.getEnp_no().trim());// ����_����ڹ�ȣ,����_�ִԵ�Ϲ�ȣ

	                pstmt2.executeUpdate();
	
	            }
	            pstmta_1.close();
	            pstmta_2.close();
	            pstmta_3.close();
	            pstmt2.close();
	            pstmt.close();
	            con.commit();
	            con1.commit();
        	}else if(neom.equals("sum")){
        		pstmt = con.prepareStatement(query);
	
	            for(int i=0; i<tb_r.length; i++){
	                TaxBean tb = new TaxBean();
					tb = tb_r[i];
					neom_sup_amt += tb.getSup_amt();
					neom_add_amt += tb.getAdd_amt();
					neom_tot_amt += tb.getTot_amt();
					
					if(!tb.getCar_no().equals(""))
					{
					neom_car_no += "," + tb.getCar_no();
					}
	                
	                pstmt.setString(1, tb.getRent_mng_id().trim());
	                pstmt.setString(2, tb.getRent_l_cd().trim());
	                pstmt.setString(3, tb.getFee_tm().trim());
	                pstmt.setString(4, tb.getRent_st().trim());
	                pstmt.setString(5, tb.getTm_st1().trim());
	                pstmt.setString(6, tb.getExch_id().trim());
	                pstmt.setString(7, tb.getItem_st().trim());
	                pstmt.setString(8, tb.getIss_dt().trim());
	                pstmt.setInt   (9, tb.getSup_amt());
	                pstmt.setInt   (10, tb.getAdd_amt());
	                pstmt.setInt   (11, tb.getTot_amt());
	                if(i==0)
	                {
	                	pstmtr = con1.prepareStatement(n_queryr);
						pstmtr.setString(1, tb.getIss_dt().trim());
						rs = pstmtr.executeQuery();
						if(rs.next())
						{
							data_no = Util.parseInt(rs.getString(1).trim());
						}
						rs.close();
						pstmtr.close();
	                	
	                	neom_iss_dt		= tb.getIss_dt().trim();
				        neom_brch_id	= tb.getBrch_id().trim();
				        neom_ven_code	= tb.getVen_code().trim();
				        neom_firm_nm	= tb.getFirm_nm();
				        neom_enp_no		= tb.getEnp_no();
				        neom_client_st	= tb.getClient_st();
				    }
        
	                count = pstmt.executeUpdate()+count;
	                
	            }

	            pstmta_1 = con1.prepareStatement(n_querya_1);
	            pstmta_2 = con1.prepareStatement(n_querya_2);
	            pstmta_3 = con1.prepareStatement(n_querya_3);
	            pstmt2 = con1.prepareStatement(n_query2);
			   
                
				/*�հ�*/
				pstmta_1.setString(1, neom_iss_dt.trim());
				pstmta_1.setInt   (2, data_no);
				pstmta_1.setString(3, neom_brch_id.trim()+"01");
				pstmta_1.setInt   (4, neom_tot_amt);
				pstmta_1.setString(5, neom_ven_code.trim());
				pstmta_1.setString(6, neom_firm_nm.trim());
				pstmta_1.setString(7, "�뿩��(" + neom_car_no.trim().substring(1) + " " + neom_firm_nm.trim() + ")");

                pstmta_1.executeUpdate();
                
                pstmta_2.setString(1, neom_iss_dt.trim());
				pstmta_2.setInt   (2, data_no);
				pstmta_2.setString(3, neom_brch_id.trim()+"01");
				pstmta_2.setInt   (4, neom_sup_amt);
				pstmta_2.setString(5, neom_ven_code.trim());
				pstmta_2.setString(6, neom_firm_nm.trim());
				pstmta_2.setString(7, "�뿩��(" + neom_car_no.trim().substring(1) + " " + neom_firm_nm.trim() + ")");

                pstmta_2.executeUpdate();
               
                pstmta_3.setString(1, neom_iss_dt.trim());
				pstmta_3.setInt   (2, data_no);
				pstmta_3.setString(3, neom_brch_id.trim()+"01");
				pstmta_3.setInt   (4, neom_add_amt);
				pstmta_3.setString(5, neom_ven_code.trim());
				pstmta_3.setString(6, "0");
				pstmta_3.setString(7, neom_firm_nm.trim());
				pstmta_3.setString(8, neom_iss_dt.trim());
				pstmta_3.setInt   (9, neom_sup_amt);
				pstmta_3.setString(10, "�뿩��(" + neom_car_no.trim().substring(1) + " " + neom_firm_nm.trim() + ")");

                pstmta_3.executeUpdate();
                
                pstmt2.setString(1, neom_iss_dt.trim());
				pstmt2.setInt   (2, data_no);
				pstmt2.setString(3, neom_brch_id.trim()+"01");
				pstmt2.setString(4, neom_iss_dt.trim());
				pstmt2.setString(5, neom_client_st.trim());//����0,����1
				pstmt2.setInt   (6, neom_sup_amt);
				pstmt2.setInt   (7, neom_add_amt);
				pstmt2.setString(8, neom_ven_code.trim());//ȸ������ڵ�
				pstmt2.setString(9, neom_enp_no.trim());// ����_����ڹ�ȣ,����_�ִԵ�Ϲ�ȣ

                pstmt2.executeUpdate();
	

	            pstmta_1.close();
	            pstmta_2.close();
	            pstmta_3.close();
	            pstmt2.close();
	            pstmt.close();
	            con.commit();
	            con1.commit();
        	}
        }catch(Exception se){
            try{
                con.rollback();
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(rs != null)		 rs.close();
                if(pstmt != null)	 pstmt.close();
                if(pstmt2 != null)	 pstmt2.close();
                if(pstmtr != null)	 pstmtr.close();
                if(pstmta_1 != null) pstmta_1.close();
                if(pstmta_2 != null) pstmta_2.close();
                if(pstmta_3 != null) pstmta_3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
        }
        return count;
    }
	// �뿩�� �ڵ���ǥ ó�� ---------------------------------------------------------------------------------

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
		query = " select /*+  merge(a) */ a.client_id, d.r_site, cc.car_no, c.firm_nm,  b.fee_bank,"+
				"        decode(e.tax_type,'1',c.ven_code,nvl(d.ven_code,c.ven_code)) ven_code"+
				" from   cont_n_view a, fee b, client c, client_site d, cont e, car_reg cc \n"+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id=c.client_id and a.client_id=d.client_id(+) and a.R_SITE=d.SEQ(+) and a.rent_l_cd=e.rent_l_cd \n "+
				"      and a.car_mng_id = cc.car_mng_id(+) "+
				"        and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'";

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
			System.out.println("[AddBillMngDatabase:getFeeBillCase]"+se);
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
     * �׿���-���ฮ��Ʈ
     */
    public CodeBean [] getCodeAll() throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT c_code as C_ST, checkd_code as CODE, checkd_name as NM, checkd_name as NM_CD"+
        		" FROM checkd"+//dzais.
        		" where check_code='A03' and c_code = '1000'"+
				" order by decode(checkd_name, '����','1', '�ϳ�','2', '����','3', '9'), checkd_name";

        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
	            CodeBean bean = new CodeBean();
	            bean.setC_st(rs.getString("C_ST"));					//�ڵ�з�
			    bean.setCode(rs.getString("CODE"));					//�ڵ�(����������)
			    bean.setNm_cd(rs.getString("NM_CD"));					//����ڵ��
				bean.setNm(rs.getString("NM"));						//��Ī
				col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AddBillMngDatabase:getCodeAll]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (CodeBean[])col.toArray(new CodeBean[0]);
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
        
        query = " SELECT deposit_name, deposit_no"+
        		" FROM depositma"+//dzais.
        		" where bank_code='"+bank_code+"' AND node_code='S101' "+// order by deposit_no
				" order by decode(deposit_name, '�����������(8623)','1', '9'), deposit_no";
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
			System.out.println("[AddBillMngDatabase:getDepositList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return vt;
    }


      /**
     *	�뿩�� ���ݰ�꼭 ��� 
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
                
		query1 =" select nvl(max(data_no)+1,1) from autodocu where data_gubun ='21' and write_date=replace(?,'-','')";

		//���뿹��
		query2 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 1, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '3', ?, 0, '10300',"+//4
				" 'A03', 'F05', 'F10', 'A05', '',  '', '', '', '', '',"+
				" ?, ?, '', '0', '',  '', '', '', '', '',"+//5,6,
				" ?, ?, '', ?, '',  '', '', '', '', '',"+//7,8,9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10
	
		//�ܻ�����
		query3 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '10800',"+//4
				" 'A07', 'A01', 'A13', 'A19', 'A05',"+
				" '', '', '', '', '',"+
				" ?,  '', '', '', '0',"+
				" '', '', '', '', '',"+//5,
				" ?,  '', '0', '', ?,"+
				" '', '', '', '', '',"+//6,7
				" ?, to_char(sysdate,'YYYYMMDD') )";//8

		//������
		query4 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '25900',"+//4
				" 'A07', 'F19', 'A19', 'A05', '',"+
				" '', '', '', '', '',"+
				" ?,  '', '', '0', '',"+
				" '', '', '', '', '',"+//5,
				" ?,  replace(?,'-',''), '', ?, '',"+
				" '', '', '', '', '',"+//6,7
				" ?, to_char(sysdate,'YYYYMMDD') )";//8

		//���뿩������
		query5 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '31100',"+//4
				" 'A07', 'A05', '', '', '',"+
				" '', '', '', '', '',"+
				" ?,  '', '', '', '',"+
				" '', '', '', '', '',"+//5,
				" ?,  ?, '', '', '',"+
				" '', '', '', '', '',"+//6,7
				" ?, to_char(sysdate,'YYYYMMDD') )";//8
				
			//��Ʈ�����������
		query6 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '41400',"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05',"+
				" '', '', '', '', '',"+  
				" '',  '', '', '000131', '',"+
				" '', '', '', '', '',"+
				" '',  '', '', '�Ƹ���ī',?,"+ //5
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//6		
				
				//���������������
		query7 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '41800',"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05',"+
				" '', '', '', '', '',"+  
				" '',  '', '', '000131', '',"+
				" '', '', '', '', '',"+
				" '',  '', '', '�Ƹ���ī',?,"+ //5
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//6	
				
					//������
		query8 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '93000',"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05',"+
				" '', '', '', '', '',"+  
				" '',  '', '', ?, '',"+ //5
				" '', '', '', '', '',"+
				" '',  '', '', ?, ?,"+ //6, 7
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8							

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);

			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getAcct_dt().trim());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt1.close();			

			//����-���뿹��(10300)
			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1, ad_bean.getAcct_dt().trim());
			pstmt2.setInt   (2, data_no);
			pstmt2.setString(3, ad_bean.getNode_code().trim());
			pstmt2.setInt   (4, ad_bean.getAmt());
			pstmt2.setString(5, ad_bean.getBank_code().trim());
			pstmt2.setString(6, ad_bean.getDeposit_no().trim());
			pstmt2.setString(7, ad_bean.getBank_name().trim());
			pstmt2.setString(8, ad_bean.getDeposit_no().trim());
			pstmt2.setString(9, ad_bean.getAcct_cont().trim());
			pstmt2.setString(10, ad_bean.getInsert_id().trim());
			pstmt2.executeUpdate();


			//�뺯-�ܻ�����
			if(ad_bean.getAcct_code().equals("10800")){		
				
				pstmt3 = con1.prepareStatement(query3);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, ad_bean.getNode_code().trim());
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getVen_code().trim());
				pstmt3.setString(6, ad_bean.getFirm_nm().trim());
				pstmt3.setString(7, ad_bean.getAcct_cont().trim());
				pstmt3.setString(8, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();

			//������
			}else if(ad_bean.getAcct_code().equals("25900")){

	            pstmt3 = con1.prepareStatement(query4);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim()		);
				pstmt3.setInt   (2, data_no							);
				pstmt3.setString(3, ad_bean.getNode_code().trim()	);
				pstmt3.setInt   (4, ad_bean.getAmt()				);
				pstmt3.setString(5, ad_bean.getVen_code().trim()	);
				pstmt3.setString(6, ad_bean.getFirm_nm().trim()		);
				pstmt3.setString(7, ad_bean.getAcct_dt().trim()		);
				pstmt3.setString(8, ad_bean.getAcct_cont().trim()	);
				pstmt3.setString(9, ad_bean.getInsert_id().trim()	);
				pstmt3.executeUpdate();

			//���뿩������
			}else if(ad_bean.getAcct_code().equals("31100")){

	            pstmt3 = con1.prepareStatement(query5);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, ad_bean.getNode_code().trim());
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getVen_code().trim());
				pstmt3.setString(6, ad_bean.getFirm_nm().trim());
				pstmt3.setString(7, ad_bean.getAcct_cont().trim());
				pstmt3.setString(8, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();

			//��Ʈ�����������
			}else if(ad_bean.getAcct_code().equals("41400")){

	            pstmt3 = con1.prepareStatement(query6);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, ad_bean.getNode_code().trim());
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getAcct_cont().trim());
				pstmt3.setString(6, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();
				
			//���������������
			}else if(ad_bean.getAcct_code().equals("41800")){

	            pstmt3 = con1.prepareStatement(query7);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, ad_bean.getNode_code().trim());
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getAcct_cont().trim());
				pstmt3.setString(6, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();		
			
						//������ - ���·�, ��ü����
			}else if(ad_bean.getAcct_code().equals("93000")){

	            pstmt3 = con1.prepareStatement(query8);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, ad_bean.getNode_code().trim());
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getVen_code().trim());
				pstmt3.setString(6, ad_bean.getFirm_nm().trim());
				pstmt3.setString(7, ad_bean.getAcct_cont().trim());
				pstmt3.setString(8, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();		
			}	
			

            pstmt2.close();
            pstmt3.close();
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertFeeAutoDocu]"+se);
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

// �Һα� �ڵ���ǥ ó�� ---------------------------------------------------------------------------------

	/**
     * �׿���-��ü����Ʈ
     */
    public CodeBean [] getCodeAll(String cpt_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
        
		if (cpt_nm.length() > 14)	cpt_nm = cpt_nm.substring(0,14);

        query = " SELECT c_code as C_ST, ven_code as CODE, ven_name as NM, ven_name as NM_CD, s_idno as APP_ST"+
        		" FROM vendor"+//dzais.
        		" where c_code = '1000' and ven_name like '%"+cpt_nm+"%' order by ven_name";

        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
	            CodeBean bean = new CodeBean();
	            bean.setC_st(rs.getString("C_ST"));					//�ڵ�з�
			    bean.setCode(rs.getString("CODE"));					//�ڵ�(����������)
			    bean.setNm_cd(rs.getString("NM_CD"));				//����ڵ��
				bean.setNm(rs.getString("NM"));						//��Ī
				bean.setApp_st(rs.getString("APP_ST"));				//��Ÿ
				col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AddBillMngDatabase:getCodeAll]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }

	/**
     * �׿���-��ü����Ʈ
     */
    public CodeBean [] getCodeAll(String cpt_nm, String car_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		if(car_no.length() > 6)		car_no = car_no.substring(5);
        
		if (cpt_nm.length() > 14)	cpt_nm = cpt_nm.substring(0,14);

        query = " SELECT c_code as C_ST, ven_code as CODE, ven_name as NM, ven_name as NM_CD"+
        		" FROM vendor"+//dzais.
        		" where c_code = '1000' and ven_name like '%"+cpt_nm+"%"+car_no+"%' order by ven_name";


        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);

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
			System.out.println("[AddBillMngDatabase:getCodeAll]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }

    /**
     *	�Һα� ���ݰ�꼭 ��� 
     */
    public int insertDebtAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
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
        ResultSet rs = null;

        String query = "";
        String query1_1 = "";
        String query1_2 = "";
        String query1_3 = "";
        String query2 = "";
        String query3 = "";

        int count = 0;
        int data_no = 0;
		String table = "autodocu";
//		String table = "test_autodocu";
                
		query =" select nvl(max(data_no)+1,1) from "+table+" where data_gubun = '53' and write_date=replace(?,'-','')";

	
		//�ܱ����Ա�-����
		query1_1 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, 1, 1, '200', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, '26000',"+//4
				" 'A07', 'F01', 'F19', 'F21', 'A19',"+
				" 'A05', '', '', '', '',"+
				" ?,  '', '', '', '',"+//5
				" '0', '', '', '', '',"+
				" ?,  '', replace(?,'-',''), '', '',"+//6,7
				" ?, '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9

		//����������ä-����
		query1_2 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, 1, 1, '200', ?, '1000',"+//1,2,3 =>1������
				" '', '0', '11', '3', '3', ?, 0, '26400',"+//4
				" 'A07', 'F19', 'A13', 'A05', '',"+
				" '', '', '', '', '',"+
				" ?,  '', '', '0', '',"+//5
				" '', '', '', '', '',"+
				" ?, replace(?,'-',''), '0', ?, '',"+//6,7,8
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//9

		//������Ա�-����
		query1_3 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, 1, 1, '200', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, '29300',"+//4
				" 'A07', 'F01', 'F19', 'F21', 'A19',"+
				" 'A05', '', '', '', '',"+
				" ?,  '', '', '', '',"+//5
				" '0', '', '', '', '',"+
				" ?,  '', replace(?,'-',''), '', '',"+//6,7
				" ?, '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9

		//���ں��-����
		query2 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3 =>2������
				" '', '0', '11', '3', '3', ?, 0, '93100',"+//4 93100->54400->86100->93100
				" 'A09', 'A13', 'A17', 'A07', 'A05',"+
				" '', '', '', '', '',"+
				" '',  '', '', ?, '0',"+//5
				" '', '', '', '', '',"+
				" '', '0', '', ?, ?,"+//6,7
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8

		//���뿹��-�뺯
		query3 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, 3, 1, '200', ?, '1000',"+//1,2,3 =>3������
				" '', '0', '11', '3', '4', 0, ?, '10300',"+//4
				" 'A03', 'F05', 'F10', 'A05', '',  '', '', '', '', '',"+
				" ?, ?, '', '0', '',  '', '', '', '', '',"+//5,6,
				" ?, ?, '', ?, '',  '', '', '', '', '',"+//7,8,9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);

			//ó����ȣ �̱�
			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, ad_bean.getAcct_dt().trim());
			rs = pstmt.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt.close();	


			//����-�ܱ����Ա�
			if(ad_bean.getAcct_code().equals("26000")){			                 
				pstmt1 = con1.prepareStatement(query1_1);
				pstmt1.setString(1, ad_bean.getAcct_dt().trim());
				pstmt1.setInt   (2, data_no);
				pstmt1.setString(3, ad_bean.getNode_code().trim());
				pstmt1.setInt   (4, ad_bean.getAmt2());
				pstmt1.setString(5, ad_bean.getVen_code().trim());
				pstmt1.setString(6, ad_bean.getFirm_nm().trim());
				pstmt1.setString(7, ad_bean.getAcct_dt().trim());
				pstmt1.setString(8, ad_bean.getAcct_cont().trim());
				pstmt1.setString(9, ad_bean.getInsert_id().trim());
				pstmt1.executeUpdate();
			//����-������Ա�
			}else if(ad_bean.getAcct_code().equals("29300")){			                 
				pstmt1 = con1.prepareStatement(query1_3);
				pstmt1.setString(1, ad_bean.getAcct_dt().trim());
				pstmt1.setInt   (2, data_no);
				pstmt1.setString(3, ad_bean.getNode_code().trim());
				pstmt1.setInt   (4, ad_bean.getAmt2());
				pstmt1.setString(5, ad_bean.getVen_code().trim());
				pstmt1.setString(6, ad_bean.getFirm_nm().trim());
				pstmt1.setString(7, ad_bean.getAcct_dt().trim());
				pstmt1.setString(8, ad_bean.getAcct_cont().trim());
				pstmt1.setString(9, ad_bean.getInsert_id().trim());
				pstmt1.executeUpdate();
			}else{//����������ä(26400)
	            pstmt1 = con1.prepareStatement(query1_2);
				pstmt1.setString(1, ad_bean.getAcct_dt().trim());
				pstmt1.setInt   (2, data_no);
				pstmt1.setString(3, ad_bean.getNode_code().trim());
				pstmt1.setInt   (4, ad_bean.getAmt2());
				pstmt1.setString(5, ad_bean.getVen_code().trim());
				pstmt1.setString(6, ad_bean.getFirm_nm().trim());
				pstmt1.setString(7, ad_bean.getAcct_dt().trim());
				pstmt1.setString(8, ad_bean.getAcct_cont().trim());
				pstmt1.setString(9, ad_bean.getInsert_id().trim());
				pstmt1.executeUpdate();
			}

			//����-���ں��(93100)
			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1, ad_bean.getAcct_dt().trim());
			pstmt2.setInt   (2, data_no);
			pstmt2.setString(3, ad_bean.getNode_code().trim());
			pstmt2.setInt   (4, ad_bean.getAmt3());
			pstmt2.setString(5, ad_bean.getVen_code().trim());
			pstmt2.setString(6, ad_bean.getFirm_nm().trim());;
			pstmt2.setString(7, ad_bean.getAcct_cont().trim()+"-�Һα�����");
			pstmt2.setString(8, ad_bean.getInsert_id().trim());
			pstmt2.executeUpdate();

			//�뺯-���뿹��(10300)
			pstmt3 = con1.prepareStatement(query3);
			pstmt3.setString(1, ad_bean.getAcct_dt().trim());
			pstmt3.setInt   (2, data_no);
			pstmt3.setString(3, ad_bean.getNode_code().trim());
			pstmt3.setInt   (4, ad_bean.getAmt());
			pstmt3.setString(5, ad_bean.getBank_code().trim());
			pstmt3.setString(6, ad_bean.getDeposit_no().trim());
			pstmt3.setString(7, ad_bean.getBank_name().trim());
			pstmt3.setString(8, ad_bean.getDeposit_no().trim());
			pstmt3.setString(9, ad_bean.getAcct_cont().trim());
			pstmt3.setString(10, ad_bean.getInsert_id().trim());
			pstmt3.executeUpdate();

            pstmt1.close();
            pstmt2.close();
            pstmt3.close();
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertDebtAutoDocu]"+se);
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
        String query7 = "";
        String query8 = "";
        String query9 = "";
        
        String alt_amt ="";
        String car_no = "";
        
        String car_ext = "";
        String item_code = "";
        String car_use = "";
        String node_code = "";
        String ven_code = "";
        String acct_code = "";
        String firm_name = "";
        
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
		String table = "autodocu";
                
		query =" select nvl(max(data_no)+1,1) from "+table+" where data_gubun = '53' and write_date=replace(?,'-','')";

	
		//����/�뿩�������-����
		query1 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, ?,"+//4
				" 'A07', 'A19', 'A13', 'A05', '', '', '', '', '', '',"+
				" ?,  '', '', '0', '', '', '', '', '', '',"+
				" ?,  '', '0', ?, '', '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9
					

		//����/�뿩�������-����
	/*	
		query2 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>2������
				" '', '0', '11', '3', '3', ?, 0, ?,"+//4 93100->54400->86100->93100
				" 'A07', 'A19', 'A13', 'A05', '', '', '', '', '', '',"+
				" ?,  '', '', '0', '', '', '', '', '', '',"+
				" ?,  '', '0', ?, '', '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//8
	*/
				
		//���ݰ�������-����
		query3 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>2������
				" '', '0', '11', '3', '3', ?, 0, '46300',"+//4  81700->46300
				" 'A09', 'A13', 'A07', 'A05', '', '', '', '', '', '',"+
				" '',  '', ?, '0', '', '', '', '', '', '',"+
				" '', '0', ?, ?, '', '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8		
				
			
				
		//���������-����
		query4 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>2������
				" '', '0', '11', '3', '3', ?, 0, '45510',"+//4 93100->54400->86100->93100->85700->45700->45510
				" 'A09', 'A13', 'A17', 'A07', 'S01', 'A05', '', '', '', '',"+
				" '',  '', '', ?, ?, '0', '', '', '', '',"+
				" '', '0', '', ?, ?, ?, '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8		
				
			
			//��ȣ�Ǵ� �����ޱ�-���� -��õ����� ��� ��ȣ�� �ŷ�ó - 000059
		query4_1 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>2������
				" '', '0', '11', '3', '3', ?, 0, '13400',"+//4 93100->54400->86100->93100->85700->45700
				" 'A09', 'A17', 'F19', 'A19', 'A07', 'A05', '', '', '', '',"+
				"  '', '', '', '', ?, '0', '', '', '', '',"+
				" '', '','', '', ?, ?, '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8		
					
				
		//���޼�����-����
		query5 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>2������
				" '', '0', '11', '3', '3', ?, 0, '83100',"+//4 93100->54400->86100->93100
				" 'A09', 'A13', 'A17', 'A07', 'A05', '', '', '', '', '',"+
				" '',  '', '', ?, '0', '', '', '', '', '',"+
				" '', '0', '', ?, ?, '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8		
				

		//���ޱ�-�뺯
		query6 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>3������
				" '', '0', '11', '3', '4', 0, ?, '14200',"+//4
				" 'A17', 'F19', 'A05', '', '',  '', '', '', '', '',"+
				" '2002015', '', '0', '', '',  '', '', '', '', '',"+//5,6,
				" '���ǻ�', replace(?,'-',''), ?, '', '',  '', '', '', '', '',"+//7,8,9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10
				
		//������-�뺯
		query7 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>3������
				" '', '0', '11', '3', '4', 0, ?, ?,"+//4
				" 'A05', '', '', '', '',  '', '', '', '', '',"+
				" '0', '', '', '', '',  '', '', '', '', '',"+//5,6,
				" ?, '', '', '', '',  '', '', '', '', '',"+//7,8,9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10		
				
		//���뿹��-�뺯
		query8 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>3������
				" '', '0', '11', '3', '4', 0, ?, '10300',"+//4
				" 'A03', 'F05', 'F10', 'A05', '',  '', '', '', '', '',"+
				" ?, ?, '', '0', '',  '', '', '', '', '',"+//5,6,
				" ?, ?, '', ?, '',  '', '', '', '', '',"+//7,8,9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10				
	
				
		//������ - �뺯
		query9 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '4', 0, ?, '25300',"+//4
				" 'A07', 'A19', 'F47', 'A13', 'A05', '', '', '', '', '',"+
				" ?, '', '',  '', '0', '', '', '', '', '', "+
				" ?, '', '', '0', ?, '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9			
										

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);
         
          
          	//car_no �Ľ� : car_no^car_ext^car_use
           car_no = ad_bean.getItem_name().trim();
           
           StringTokenizer token1 = new StringTokenizer(car_no,"^");
				
		   while(token1.hasMoreTokens()) {
				
				item_code = token1.nextToken().trim();	//�ڵ�����ȣ
				car_ext = token1.nextToken().trim();	//�������
				car_use = token1.nextToken().trim();	//�����뵵
			}	
                        
            //������ϰ������� ���� ���� - ������ -> ���ޱ�
            if ( car_ext.equals("1") || car_ext.equals("2") || car_ext.equals("6") ) {
            	node_code = "S101";
            	ven_code = "029846";
            	acct_code = "14200";  // ���ޱ�            	
            }else if ( car_ext.equals("7")  || car_ext.equals("8") ) {  //��õ���
            	node_code = "S101";
            	ven_code = "006110";
            	acct_code = "14200";  // ���ޱ�                        		
            }else if  ( car_ext.equals("5") ) {
               	node_code = "D101";	
               	ven_code = "607081"; 
               	acct_code = "14200";   //���� ���ޱ�
            }else if  ( car_ext.equals("3") ) { //�λ�
               	node_code = "B101";	
               	ven_code = "601514";  
               	acct_code = "14200";   //�λ� ������ 	
            }else {
            	node_code = "B101";	    //����
            	ven_code = "601458"; 	
            	acct_code = "14200"; //�λ� ���ޱ� 	
            }	
            
            firm_name = getCodeByNm("ven", ven_code); 
            
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
			rs = pstmt.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt.close();	
			
			//��ϼ�
			if ( amt1 > 0 ) {				
			//	System.out.println("1");
				//����-����/�뿩�������	()		    
				i++;     
				pstmt1 = con1.prepareStatement(query1);
				pstmt1.setString(1, ad_bean.getAcct_dt().trim());
				pstmt1.setInt   (2, data_no);
				pstmt1.setInt	(3, i);
				pstmt1.setString(4, node_code);
				pstmt1.setInt   (5, amt1);
				if (car_use.equals("1") ) {
					pstmt1.setString(6, "21700");
				}
				else {
					pstmt1.setString(6, "21900");
				}
				pstmt1.setString(7, ven_code);
				pstmt1.setString(8, firm_name);
				pstmt1.setString(9, "��ϼ� - " + item_code + " " + ad_bean.getCom_name().trim());
				pstmt1.setString(10, ad_bean.getInsert_id().trim());
				pstmt1.executeUpdate();
			    pstmt1.close();
			}		
						
			//��漼				
			if ( amt7 > 0 ) {				
			//	System.out.println("1");
				//����-����/�뿩�������	()		    
				i++;     
				pstmt7 = con1.prepareStatement(query1);
				pstmt7.setString(1, ad_bean.getAcct_dt().trim());
				pstmt7.setInt   (2, data_no);
				pstmt7.setInt	(3, i);
				pstmt7.setString(4, node_code);
				pstmt7.setInt   (5, amt7);
				if (car_use.equals("1") ) {
					pstmt7.setString(6, "21700");
				}
				else {
					pstmt7.setString(6, "21900");
				}
				pstmt7.setString(7, ven_code);
				pstmt7.setString(8, firm_name);
				pstmt7.setString(9, "��漼 - " + item_code + " " + ad_bean.getCom_name().trim());
				pstmt7.setString(10, ad_bean.getInsert_id().trim());
				pstmt7.executeUpdate();
			    pstmt7.close();
			}		
				
			//���԰�ä				
			if ( amt2 > 0 ) {			
				//����-����/�뿩�������
				i++; 	
			//	System.out.println("2");	
				pstmt2 = con1.prepareStatement(query1);
				pstmt2.setString(1, ad_bean.getAcct_dt().trim());
				pstmt2.setInt   (2, data_no);
				pstmt2.setInt	(3, i);
				pstmt2.setString(4, node_code);
				pstmt2.setInt   (5, amt2);
				if (car_use.equals("1") ) {
					pstmt2.setString(6, "21700");
				}
				else {
					pstmt2.setString(6, "21900");
				}
				pstmt2.setString(7, ven_code);
				pstmt2.setString(8, firm_name);
				pstmt2.setString(9, "���԰�ä - " + item_code + " " + ad_bean.getCom_name().trim());
				pstmt2.setString(10, ad_bean.getInsert_id().trim());
				pstmt2.executeUpdate();
				pstmt2.close();
			}
			
						 				
				//����-���ݰ�������(81700)
			i++; 	
		//	System.out.println("3");	
			pstmt3 = con1.prepareStatement(query3);
			pstmt3.setString(1, ad_bean.getAcct_dt().trim());
			pstmt3.setInt   (2, data_no);
			pstmt3.setInt	(3, i);
			pstmt3.setString(4, node_code);
			pstmt3.setInt   (5, amt3);
			pstmt3.setString(6, ven_code);
			pstmt3.setString(7, firm_name);
			pstmt3.setString(8, "������ - " + item_code + " " + ad_bean.getCom_name().trim());
			pstmt3.setString(9, ad_bean.getInsert_id().trim());
			pstmt3.executeUpdate();			
			
			if ( amt4 > 0 ) {						
				//����-���������(85700)
				i++; 
			//	System.out.println("4");
			 // ��õ��Ͻ� ��ȣ�Ǵ�� �����ޱ� 
			       if (	ven_code.equals("006110") ) {
			       	
			       		pstmt4 = con1.prepareStatement(query4_1);
					pstmt4.setString(1, ad_bean.getAcct_dt().trim());
					pstmt4.setInt   (2, data_no);
					pstmt4.setInt	(3, i);
					pstmt4.setString(4, node_code);
					pstmt4.setInt   (5, amt4);
					pstmt4.setString(6,  "000059");		
					pstmt4.setString(7, "���ڼ����ڵ���");					
					pstmt4.setString(8, "��ȣ�Ǵ� - " + item_code + " " + ad_bean.getCom_name().trim());
					pstmt4.setString(9, ad_bean.getInsert_id().trim());
					pstmt4.executeUpdate();
					pstmt4.close();	     	
			       			       	
			    }  else {
						
					pstmt4 = con1.prepareStatement(query4);
					pstmt4.setString(1, ad_bean.getAcct_dt().trim());
					pstmt4.setInt   (2, data_no);
					pstmt4.setInt	(3, i);
					pstmt4.setString(4, node_code);
					pstmt4.setInt   (5, amt4);
					pstmt4.setString(6, ven_code);
					if (car_use.equals("1") ) {
						pstmt4.setString(7, "��00001");
					}
					else {
						pstmt4.setString(7, "����00001");
					}
					pstmt4.setString(8, firm_name);
					pstmt4.setString(9, item_code);
					pstmt4.setString(10, "��ȣ�Ǵ� - " + item_code + " " + ad_bean.getCom_name().trim());
					pstmt4.setString(11, ad_bean.getInsert_id().trim());
					pstmt4.executeUpdate();
					pstmt4.close();	
			    }		
			}		
			
			if ( amt5 > 0 ) {		
					
				//����-���޼�����(83100)
				i++; 
			//	System.out.println("5");
				pstmt5 = con1.prepareStatement(query5);
				pstmt5.setString(1, ad_bean.getAcct_dt().trim());
				pstmt5.setInt   (2, data_no);
				pstmt5.setInt	(3, i);
				pstmt5.setString(4, node_code);
				pstmt5.setInt   (5, amt5);
				pstmt5.setString(6,  ven_code);
				pstmt5.setString(7, firm_name);
				pstmt5.setString(8, "��ϴ�������� - " + item_code + " " + ad_bean.getCom_name().trim());
				pstmt5.setString(9, ad_bean.getInsert_id().trim());
				pstmt5.executeUpdate();	
				pstmt5.close();			
		        }
						
			//�뺯-���ޱ�(14200/ ������)
			i++; 
						
			if	(ad_bean.getInsert_id().trim().equals("2007007")) {		//����		
				System.out.println( "����=" + ad_bean.getInsert_id().trim() );	    
		//	if (node_code.equals("D101")) {		//����	
				pstmt6 = con1.prepareStatement(query9);
				pstmt6.setString(1, ad_bean.getAcct_dt().trim());
				pstmt6.setInt   (2, data_no);
				pstmt6.setInt	(3, i);
				pstmt6.setString(4, node_code);
				pstmt6.setInt   (5, amt6);
			  	pstmt6.setString(6, ven_code);
			         pstmt6.setString(7, firm_name);
				pstmt6.setString(8, " ������� - " + item_code + " " + ad_bean.getCom_name().trim());
				pstmt6.setString(9, ad_bean.getInsert_id().trim());
				pstmt6.executeUpdate();
		//		pstmt6 = con1.prepareStatement(query6);
		//		pstmt6.setString(1, ad_bean.getAcct_dt().trim());
		//		pstmt6.setInt   (2, data_no);
		//		pstmt6.setInt	(3, i);
		//		pstmt6.setString(4, node_code);
		//		pstmt6.setInt   (5, amt6);
		//		pstmt6.setString(6, ad_bean.getAcct_dt().trim());
		//		pstmt6.setString(7, " �����񼱱ޱ� ���� - " + item_code + " " + ad_bean.getCom_name().trim());
		//		pstmt6.setString(8, ad_bean.getInsert_id().trim());
		//		pstmt6.executeUpdate();		
			} else if (ad_bean.getInsert_id().trim().equals("2005008") || ad_bean.getInsert_id().trim().equals("2009009")  ) {	//�λ�	
			//	System.out.println( "�λ�=" + ad_bean.getInsert_id().trim() );	
		//	} else if (node_code.equals("B101")) {		//�λ�	
				pstmt6 = con1.prepareStatement(query9);
				pstmt6.setString(1, ad_bean.getAcct_dt().trim());
				pstmt6.setInt   (2, data_no);
				pstmt6.setInt	(3, i);
				pstmt6.setString(4, node_code);
				pstmt6.setInt   (5, amt6);
			    pstmt6.setString(6, ven_code);
			    pstmt6.setString(7, firm_name);
			    pstmt6.setString(8, " ������� - " + item_code + " " + ad_bean.getCom_name().trim());
				pstmt6.setString(9, ad_bean.getInsert_id().trim());
				pstmt6.executeUpdate();		
			//	pstmt6 = con1.prepareStatement(query6);
			//	pstmt6.setString(1, ad_bean.getAcct_dt().trim());
			//	pstmt6.setInt   (2, data_no);
			//	pstmt6.setInt	(3, i);
			//	pstmt6.setString(4, node_code);
			//	pstmt6.setInt   (5, amt6);
			//	pstmt6.setString(6, ad_bean.getAcct_dt().trim());
			//	pstmt6.setString(7, " �����񼱱ޱ� ���� - " + item_code + " " + ad_bean.getCom_name().trim());
			//	pstmt6.setString(8, ad_bean.getInsert_id().trim());
			//	pstmt6.executeUpdate();	
			} else {				
				pstmt6 = con1.prepareStatement(query6);
				pstmt6.setString(1, ad_bean.getAcct_dt().trim());
				pstmt6.setInt   (2, data_no);
				pstmt6.setInt	(3, i);
				pstmt6.setString(4, node_code);
				pstmt6.setInt   (5, amt6);
				pstmt6.setString(6, ad_bean.getAcct_dt().trim());
				pstmt6.setString(7, " �����񼱱ޱ� ���� - " + item_code + " " + ad_bean.getCom_name().trim());
				pstmt6.setString(8, ad_bean.getInsert_id().trim());
				pstmt6.executeUpdate();	
			}
        
            pstmt3.close();            
            pstmt6.close();
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertCarRegAutoDocu]"+se);
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
     *	�ڵ������� ��ǥ
     */
    public int insertCarServiceAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

     	PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;   
      
        String query = "";
        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
             
        String alt_amt ="";
    
        String node_code = "";
        
        int amt1=0;
        int amt2=0;
        int amt3=0;
			
        int count = 0;
        int i = 0;
		String table = "autodocu";
                
		query =" select nvl(max(data_line),0) from "+table+" where data_gubun= '51' and write_date=replace(?,'-','') and data_no = ? ";
	
				
		//���������-����
		query1 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '400', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, ?,"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05', '', '', '', '', '',"+
				" '', '', ?,  ?, '0', '', '', '', '', '', "+
				" '', '0', ?, ?, ?, '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9
				
				
		//������ǰ -	����
		query2 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '400', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, ?,"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05', '', '', '', '', '',"+
				" '', '', ?,  ?, '0', '', '', '', '', '', "+
				" '', '0', ?, ?, ?, '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9
				

		//���ޱ�(�ΰ���)-����
		query3 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '400', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, '13100',"+//4
				" 'A07', 'F19', 'A19', 'A05', '', '', '', '', '', '',"+
				" ?, '', '',  '0', '', '', '', '', '', '', "+
				" ?, replace(?,'-',''), '', ?, '', '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9
				
				
		//������ - �뺯
		query4 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '400', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '4', 0, ?, '25300',"+//4
				" 'A07', 'A19', 'F47', 'A13', 'A05', '', '', '', '', '',"+
				" ?, '', '',  '', '0', '', '', '', '', '', "+
				" ?, '', '', '0', ?, '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);
            
             
            	   	//ó������ �̱�
			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, ad_bean.getAcct_dt().trim());
			pstmt.setInt   (2, ad_bean.getData_no());
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				i = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt.close(); 
                        
           	node_code = "S101";
          
            //�ݾ� �Ľ�
           alt_amt= ad_bean.getAcct_cont().trim();
                  
           StringTokenizer token = new StringTokenizer(alt_amt,"^");
				
		   while(token.hasMoreTokens()) {
				
				amt1 = Integer.parseInt(token.nextToken().trim());	//����   ����+��ǰ 
				amt2 = Integer.parseInt(token.nextToken().trim());	//��ǰ   ������
				amt3 = Integer.parseInt(token.nextToken().trim());	//��å�� ��å��
						
			}		
			
			if ( ad_bean.getVen_type().equals("F"))  {  //����
				
				if ( amt1 != 0 ) {
					
				//	System.out.println("1" + amt1);
					//����-������ �ִ� ���	- ������ ���̳ʽ��ΰ�쵵 �ִ��� 20110107		    
					i++;     
					pstmt1 = con1.prepareStatement(query1);
					pstmt1.setString(1, ad_bean.getAcct_dt().trim());
					pstmt1.setInt   (2, ad_bean.getData_no());
					pstmt1.setInt	(3, i);
					pstmt1.setString(4, node_code);
					pstmt1.setInt   (5, amt1);
					//20211116 �������� ������������� 45510 �ϳ��� ���� 
					if (amt3 > 0) { //85600->45600 (20080812)->45510 (20211116)
						pstmt1.setString(6, "45510");
					} else {  //85700->45700->45510 (20211116)
						pstmt1.setString(6, "45510");
					}
					pstmt1.setString(7, ad_bean.getSa_code());
					pstmt1.setString(8, ad_bean.getVen_code());
					pstmt1.setString(9, ad_bean.getKname());
					pstmt1.setString(10, ad_bean.getFirm_nm());
					pstmt1.setString(11, ad_bean.getCom_name().trim());
					pstmt1.setString(12, ad_bean.getInsert_id().trim());
					pstmt1.executeUpdate();
				    pstmt1.close();
				}		
			
				if ( amt2 > 0 ) {
				
			//		System.out.println("2");
					//����-��ǰ�� �ִ� ���			    
					i++;     
					pstmt2 = con1.prepareStatement(query2);
					pstmt2.setString(1, ad_bean.getAcct_dt().trim());
					pstmt2.setInt   (2, ad_bean.getData_no());
					pstmt2.setInt	(3, i);
					pstmt2.setString(4, node_code);
					pstmt2.setInt   (5, amt2);
					//20211116 �������� ������������� 45510 �ϳ��� ���� : 46000->45510
					pstmt2.setString(6, "45510"); //86200->46000 20080812 ��������
					pstmt2.setString(7, ad_bean.getSa_code());
					pstmt2.setString(8, ad_bean.getVen_code());
					pstmt2.setString(9, ad_bean.getKname());
					pstmt2.setString(10, ad_bean.getFirm_nm());
					pstmt2.setString(11, ad_bean.getCom_name().trim());
					pstmt2.setString(12, ad_bean.getInsert_id().trim());
					pstmt2.executeUpdate();
				    pstmt2.close();
				}		
			} else {
				          
	        	if ( amt1 > 0 ) {
								
					//����- vat		���ޱ�	    
					i++;     
					pstmt1 = con1.prepareStatement(query3);
					pstmt1.setString(1, ad_bean.getAcct_dt().trim());
					pstmt1.setInt   (2, ad_bean.getData_no());
					pstmt1.setInt	(3, i);
					pstmt1.setString(4, node_code);
					pstmt1.setInt   (5, amt1);
					pstmt1.setString(6, ad_bean.getVen_code());
					pstmt1.setString(7, ad_bean.getFirm_nm());
					pstmt1.setString(8, ad_bean.getAcct_dt().trim());
					pstmt1.setString(9, ad_bean.getCom_name().trim()+ "  �ΰ���");
					pstmt1.setString(10, ad_bean.getInsert_id().trim());
				
					pstmt1.executeUpdate();
				
				    pstmt1.close();
				}		
				
				if ( amt2 > 0 ) {
					
				//	System.out.println("4");
					//�뺯-���� �Ѱ� :������		    
					i++;     
					pstmt2 = con1.prepareStatement(query4);
					pstmt2.setString(1, ad_bean.getAcct_dt().trim());
					pstmt2.setInt   (2, ad_bean.getData_no());
					pstmt2.setInt	(3, i);
					pstmt2.setString(4, node_code);
					pstmt2.setInt   (5, amt2);
				    pstmt2.setString(6, ad_bean.getVen_code());
				    pstmt2.setString(7, ad_bean.getFirm_nm());
					pstmt2.setString(8, ad_bean.getCom_name().trim());
					pstmt2.setString(9, ad_bean.getInsert_id().trim());
					pstmt2.executeUpdate();
				    pstmt2.close();
				}		
		
			}
      
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertCarServiceAutoDocu]"+se);
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
         
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
        }
        return count;
    }


	 /**
     *	��漼 ��ǥ
     */
 
    public int insertCarAcqAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
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
        ResultSet rs = null;

        String query = "";
        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
        String query5 = "";
        String query6 = "";
        
        String alt_amt ="";
        String car_no = "";
        
        String car_ext = "";
        String item_code = "";
        String car_use = "";
        String node_code = "";
        String ven_code= "";
        String acct_code= "";
        String firm_name="";
        
        int amt1=0;
        int amt2=0;
        int amt3=0;
        int amt4=0;
        int amt5=0;
        int amt6=0;

        int count = 0;
        int data_no = 0;
		String table = "autodocu";
                
		query =" select nvl(max(data_no)+1,1) from "+table+" where data_gubun = '53' and write_date=replace(?,'-','')";

	
		//����/�뿩�������-����
		query1 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, 1, 1, '200', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, ?,"+//4
				" 'A01', 'A13', 'A07', 'A05', '', '', '', '', '', '',"+
				" '',  '', ?, '0', '', '', '', '', '', '',"+
				" '',  '0', ?, ?, '', '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9
		
			
	
		//���뿹��-�뺯
		query2 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3 =>3������
				" '', '0', '11', '3', '4', 0, ?, '10300',"+//4
				" 'A03', 'F05', 'F10', 'A05', '',  '', '', '', '', '',"+
				" ?, ?, '', '0', '',  '', '', '', '', '',"+//5,6,
				" ?, ?, '', ?, '',  '', '', '', '', '',"+//7,8,9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10
				
			//������-�뺯
		query3 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3 =>3������
				" '', '0', '11', '3', '4', 0, ?, ?,"+//4
				" 'A05', '', '', '', '',  '', '', '', '', '',"+
				" '0', '', '', '', '',  '', '', '', '', '',"+//5,6,
				" ?, '', '', '', '',  '', '', '', '', '',"+//7,8,9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10		

	 try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);


		  	//ó����ȣ �̱�
			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, ad_bean.getAcct_dt().trim());
			rs = pstmt.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt.close();	

			//car_no �Ľ� : car_no^car_ext^car_use
           car_no = ad_bean.getItem_name().trim();
           
           StringTokenizer token1 = new StringTokenizer(car_no,"^");
				
		   while(token1.hasMoreTokens()) {
				
				item_code = token1.nextToken().trim();	//�ڵ�����ȣ
				car_ext = token1.nextToken().trim();	//�������
				car_use = token1.nextToken().trim();	//�����뵵
			}	
            
            if ( car_ext.equals("1") || car_ext.equals("2")  || car_ext.equals("6") ) {
            	node_code = "S101";
            	ven_code = "000454";
            	acct_code = "10300";
             }else if ( car_ext.equals("7") ) {  //��õ���
            	node_code = "S101";
            	ven_code = "006110";
            	acct_code = "14200";  // ���ޱ�             
            }else if  ( car_ext.equals("5") ) {
               	node_code = "D101";	
               	ven_code = "102115"; 
               	acct_code = "14900";
            }else if  ( car_ext.equals("3") ) { //�λ�
               	node_code = "B101";	
               	ven_code = "601514"; 
               	acct_code = "15000";   	
            }else {
            	node_code = "B101";	    //����
            	ven_code = "601458"; 	
            	acct_code = "15000";
            }	
            
            firm_name = getCodeByNm("ven", ven_code);
            
				
			//����-�뿩���� 
			pstmt2 = con1.prepareStatement(query1);
			pstmt2.setString(1, ad_bean.getAcct_dt().trim());
			pstmt2.setInt   (2, data_no);
			pstmt2.setString(3, node_code);
			pstmt2.setInt   (4, ad_bean.getAmt());
			pstmt2.setString(5, ad_bean.getAcct_code().trim());
			pstmt2.setString(6, ven_code);
		//	pstmt2.setString(7, ad_bean.getFirm_nm().trim());
			pstmt2.setString(7, firm_name);
			pstmt2.setString(8, ad_bean.getAcct_cont().trim());
			pstmt2.setString(9, ad_bean.getInsert_id().trim());
			pstmt2.executeUpdate();
  
		//�뺯-���뿹��(10300)/������(15000)/������(14900) - ����/�λ굵 ���뿹������
		
			if (node_code.equals("D101")) {		//����
				pstmt3 = con1.prepareStatement(query2);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, node_code);
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, "710");
				pstmt3.setString(6, "310177-01-013023");
				pstmt3.setString(7, "��ü��");
				pstmt3.setString(8, "310177-01-013023");
				pstmt3.setString(9, ad_bean.getAcct_cont().trim()+ " ���� " );
				pstmt3.setString(10, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();
			} else if (node_code.equals("B101")) {		//�λ�	
				pstmt3 = con1.prepareStatement(query2);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, node_code);
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, "320");
				pstmt3.setString(6, "316-13-000119-8");
				pstmt3.setString(7, "�λ�");
				pstmt3.setString(8, "316-13-000119-8");
				pstmt3.setString(9, ad_bean.getAcct_cont().trim()+ " ���� " );
				pstmt3.setString(10, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();
			} else {
				pstmt3 = con1.prepareStatement(query2);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, node_code);
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getBank_code().trim());
				pstmt3.setString(6, ad_bean.getDeposit_no().trim());
				pstmt3.setString(7, ad_bean.getBank_name().trim());
				pstmt3.setString(8, ad_bean.getDeposit_no().trim());
				pstmt3.setString(9, ad_bean.getAcct_cont().trim()+ " ���� " );
				pstmt3.setString(10, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();
			}
			
            pstmt2.close();
            pstmt3.close();
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertCarAcqAutoDocu]"+se);
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
        
	
		// ���ݰ�꼭 ���� ---------------------------------------------------------------------------------

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
        
        query = " SELECT * FROM vendor WHERE ven_code='"+ven_code+"'";

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
			System.out.println("[AddBillMngDatabase:getVendorCase]"+se);
			System.out.println("[AddBillMngDatabase:getVendorCase]"+query);
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
     * �׿���-�ŷ�ó �ڵ� ��ȸ
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
        
        query1 = " SELECT ven_code FROM vendor WHERE s_idno='"+enp_no+"'";
        query2 = " SELECT ven_code FROM vendor WHERE id_no='"+ssn+"'";

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
//			 System.out.println("[AddBillMngDatabase:getVenCode]"+query1);
//			 System.out.println("[AddBillMngDatabase:getVenCode]"+query2);
        }catch(SQLException se){
			 System.out.println("[AddBillMngDatabase:getVenCode]"+se);
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
     * �׿���-�ŷ�ó �ڵ� ��ȸ
     */
    public String getVenCode2(String ssn, String enp_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1); //neom
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
        
        query1 = " SELECT ven_code FROM vendor WHERE s_idno='"+enp_no+"'";


		try{
            pstmt = con1.prepareStatement(query1);
            rs = pstmt.executeQuery(query1);

            if(rs.next()){                
				ven_code = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
            pstmt.close();


//			 System.out.println("[AddBillMngDatabase:getVenCode]"+query1);
//			 System.out.println("[AddBillMngDatabase:getVenCode]"+query2);
        }catch(SQLException se){
			 System.out.println("[AddBillMngDatabase:getVenCode2]"+se);
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
     * �׿���-�ŷ�ó �ڵ� ��ȸ
     */
    public void getVenCode(String client_id, String ssn, String enp_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs2 = null;        
        PreparedStatement pstmt3 = null;
        String query1 = "", query2 = "", query3 = "";
		String ven_code = "";
		String ven_code2 = "";
        
        query1 = " SELECT ven_code FROM vendor WHERE s_idno='"+enp_no+"'";
        query2 = " SELECT ven_code FROM vendor WHERE id_no='"+ssn+"'";
        query3 = " UPDATE client SET ven_code=? WHERE client_id=?";

		try{
			con.setAutoCommit(false);
			con1.setAutoCommit(false);

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

			if(ven_code.equals("")){
				ven_code = ven_code2;
			}

			pstmt3 = con.prepareStatement(query3);
			pstmt3.setString(1, ven_code);
			pstmt3.setString(2, client_id);
			pstmt3.executeUpdate();
			pstmt3.close();	
			
			con.commit();
			con1.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddBillMngDatabase:getVenCode]"+se);
                con.rollback();
                con1.rollback();
            }catch(SQLException _ignored){}
			 throw new DatabaseException();
        }finally{
            try{
				con.setAutoCommit(true);
				con1.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
                if(pstmt3 != null)	pstmt3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			con1 = null;
        }
    }


    /**
     *	���ݰ�꼭 �ܻ����� ���ݰ�꼭 ��� 
     */
    public int insertTaxAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
        PreparedStatement pstmt6 = null;
        PreparedStatement pstmt7 = null;
        ResultSet rs = null;

        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
        String query5 = "";
        String query6 = "";
        String query7 = "";		

        int count = 0;
        int data_no = 0;
		int data_line = 1;
                
		query1 =" select nvl(max(data_no)+1,1) from autodocu where data_gubun = '21' and write_date=replace(?,'-','')";

		//�ܻ�����
		query2 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '3', ?, 0, '10800',"+//4
				" 'A07', 'A01', 'A13', 'A19', 'A05',"+
				" '', '', '', '', '',"+
				" ?,  '', '', '', '0',"+//5
				" '', '', '', '', '',"+
				" ?,  '', '', '', ?,"+//6,7
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8

		//�뿩�������
		query3 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '41200',"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05',"+
				" '', '', '', '', '',"+
				" '',  '', '', ?, '0',"+//5
				" '', '', '', '', '',"+
				" '', '', '', ?, ?,"+//6,7
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8

		//��Ʈ-�뿩�������
		query6 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3-data_line �߰�
				" '', '0', '11', '3', '4', 0, ?, '41200',"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05',"+
				" '', '', '', '', '',"+
				" '',  '', '', ?, '0',"+//5
				" '', '', '', '', '',"+
				" '', '', '', ?, ?,"+//6,7
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8

		//����-�뿩�������
		query7 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3-data_line �߰�
				" '', '0', '11', '3', '4', 0, ?, '41700',"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05',"+
				" '', '', '', '', '',"+
				" '',  '', '', ?, '0',"+//5
				" '', '', '', '', '',"+
				" '', '', '', ?, ?,"+//6,7
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8

		//�ΰ�����ޱ�
		query4 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3-data_line �߰�
				" '', '0', '11', '3', '4', 0, ?, '25500',"+//4
				" 'A07', 'T01', 'F19', 'T03', 'F45',"+
				" 'A05', '', '', '', '',"+
				" ?, '11', '', '', '',"+//5
				" '0', '', '', '', '',"+
				" ?, '����(����)', replace(?,'-',''), ?, '',"+//6,7,8
				" ?, '', '', '', '',"+//9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10	

		//taxrela
		query5 =" insert into taxrela"+
				" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,"+
				" DEPT_CODE, NODE_CODE, C_CODE, BAL_DATE, VEN_TYPE,"+
				" TAX_GU, GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO,"+
				" GONG_AMT2, BUL_GUBUN)"+
				" values("+
				" '21', replace(?,'-',''), ?, ?, 1,"+//2
				" '200', ?, '1000', replace(?,'-',''), ?,"+//5
				" '11', ?, ?, ?, ?,"+//9
				" 0, '' )";

	   try{

            con1.setAutoCommit(false);

			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getWrite_dt().trim());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt1.close();			

			//����-�ܻ�����(10800)
			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1, ad_bean.getWrite_dt().trim());
			pstmt2.setInt   (2, data_no);
			pstmt2.setInt   (3, data_line);
			pstmt2.setString(4, ad_bean.getNode_code().trim());
			pstmt2.setInt   (5, ad_bean.getAmt()+ad_bean.getAmt2());
			pstmt2.setString(6, ad_bean.getVen_code().trim());
			pstmt2.setString(7, ad_bean.getFirm_nm().trim());
			pstmt2.setString(8, ad_bean.getAcct_cont().trim());
			pstmt2.setString(9, ad_bean.getInsert_id().trim());
			pstmt2.executeUpdate();
			pstmt2.close();			

			data_line++;

			//�뺯-�뿩�������(41200)
			/*
			pstmt3 = con.prepareStatement(query3);
			pstmt3.setString(1, ad_bean.getWrite_dt().trim());
			pstmt3.setInt   (2, data_no);
			pstmt3.setInt   (3, 2);
			pstmt3.setString(4, ad_bean.getNode_code().trim());
			pstmt3.setInt   (5, ad_bean.getAmt());
			pstmt3.setString(6, ad_bean.getVen_code().trim());
			pstmt3.setString(7, ad_bean.getFirm_nm().trim());
			pstmt3.setString(8, ad_bean.getAcct_cont().trim());
			pstmt3.setString(9, ad_bean.getInsert_id().trim());
			pstmt3.executeUpdate();
			pstmt3.close();			
			*/

			if(ad_bean.getAmt3() >0){
				//�뺯-��Ʈ�뿩�������(41200)
				pstmt6 = con1.prepareStatement(query6);
				pstmt6.setString(1, ad_bean.getWrite_dt().trim());
				pstmt6.setInt   (2, data_no);
				pstmt6.setInt   (3, data_line);
				pstmt6.setString(4, ad_bean.getNode_code().trim());
				pstmt6.setInt   (5, ad_bean.getAmt3());
				pstmt6.setString(6, ad_bean.getVen_code().trim());
				pstmt6.setString(7, ad_bean.getFirm_nm().trim());
				pstmt6.setString(8, ad_bean.getAcct_cont().trim());
				pstmt6.setString(9, ad_bean.getInsert_id().trim());
				pstmt6.executeUpdate();
				pstmt6.close();		

				data_line++;
			}

			if(ad_bean.getAmt5() >0){
				//�뺯-�����뿩�������(41700)
				pstmt7 = con1.prepareStatement(query7);
				pstmt7.setString(1, ad_bean.getWrite_dt().trim());
				pstmt7.setInt   (2, data_no);
				pstmt7.setInt   (3, data_line);
				pstmt7.setString(4, ad_bean.getNode_code().trim());
				pstmt7.setInt   (5, ad_bean.getAmt5());
				pstmt7.setString(6, ad_bean.getVen_code().trim());
				pstmt7.setString(7, ad_bean.getFirm_nm().trim());
				pstmt7.setString(8, ad_bean.getAcct_cont().trim());
				pstmt7.setString(9, ad_bean.getInsert_id().trim());
				pstmt7.executeUpdate();
				pstmt7.close();			
				data_line++;
			}


			//�뺯-�ΰ���ȯ�ޱ�(25500)
            pstmt4 = con1.prepareStatement(query4);
			pstmt4.setString(1, ad_bean.getWrite_dt().trim());
			pstmt4.setInt   (2, data_no);
			pstmt4.setInt   (3, data_line);
			pstmt4.setString(4, ad_bean.getNode_code().trim());
			pstmt4.setInt   (5, ad_bean.getAmt2());
			pstmt4.setString(6, ad_bean.getVen_code().trim());
			pstmt4.setString(7, ad_bean.getFirm_nm().trim());
			pstmt4.setString(8, ad_bean.getAcct_dt().trim());
			pstmt4.setInt   (9, ad_bean.getAmt());
			pstmt4.setString(10, ad_bean.getAcct_cont().trim());
			pstmt4.setString(11, ad_bean.getInsert_id().trim());
			pstmt4.executeUpdate();
            pstmt4.close();

			//�ΰ���
			pstmt5 = con1.prepareStatement(query5);
			pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
			pstmt5.setInt   (2,  data_no);
			pstmt5.setInt   (3,  data_line);
			pstmt5.setString(4,  ad_bean.getNode_code().trim());
			pstmt5.setString(5,  ad_bean.getWrite_dt().trim());
			pstmt5.setString(6,  ad_bean.getVen_type().trim());
			pstmt5.setInt   (7,  ad_bean.getAmt());
			pstmt5.setInt   (8,  ad_bean.getAmt2());
			pstmt5.setString(9,  ad_bean.getVen_code().trim());
			pstmt5.setString(10, ad_bean.getS_idno().trim());
			pstmt5.executeUpdate();
			pstmt5.close();			

            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				data_no = 0;
				System.out.println("[AddBillMngDatabase:insertTaxAutoDocu]"+se);
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
                if(pstmt5 != null) pstmt5.close();
                if(pstmt6 != null) pstmt6.close();
                if(pstmt7 != null) pstmt7.close();
				if(con1 != null)	   con1.close();
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return data_no;
    }

    /**
     *	���ݰ�꼭 �ܻ����� ���ݰ�꼭 �ΰ��� ��� 
     */
    public void insertTaxrela(String insert_date, String insert_id) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
//        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;

        String query1 = "";
        String query2 = "";

        int count = 0;
        int data_no = 0;
                
		query1 =" select a.data_gubun, a.write_date, a.data_no, b.data_line, a.data_slip,"+
				" a.dept_code, a.node_code, a.c_code, a.write_date as bal_date,"+
				" decode(c.s_idno,'','1','0') ven_type, '11' tax_gu,"+
				" a.cr_amt as gong_amt, b.cr_amt as tax_vat,"+
				" b.checkd_code1 as ven_code, nvl(c.s_idno,c.id_no) s_idno, 0 gong_amt2, '' bul_gubun"+
				" from"+
				" (select * from autodocu where insert_date=? and insert_id=? and data_line='2') a,"+
				" (select * from autodocu where insert_date=? and insert_id=? and data_line='3') b,"+
				" vendor c, taxrela d"+
				" where a.write_date=b.write_date and a.data_no=b.data_no and b.checkd_code1=c.ven_code"+
				" and a.write_date=d.write_date(+) and a.data_no=d.data_no(+) and d.write_date is null";

		query2 =" insert into taxrela"+
				" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,"+
				" DEPT_CODE, NODE_CODE, C_CODE, BAL_DATE, VEN_TYPE,"+
				" TAX_GU, GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO,"+
				" GONG_AMT2, BUL_GUBUN)"+
				" values("+
				" ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?,"+
				" ?, ? )";

	   try{

            con1.setAutoCommit(false);

			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, insert_date);
			pstmt1.setString(2, insert_id);
			pstmt1.setString(3, insert_date);
			pstmt1.setString(4, insert_id);
			rs = pstmt1.executeQuery();
			while(rs.next()){
				pstmt2 = con1.prepareStatement(query2);
				pstmt2.setString(1,  rs.getString(1));
				pstmt2.setString(2,  rs.getString(2));
				pstmt2.setInt   (3,  rs.getInt(3));
				pstmt2.setInt   (4,  rs.getInt(4));
				pstmt2.setInt   (5,  rs.getInt(5));
				pstmt2.setString(6,  rs.getString(6));
				pstmt2.setString(7,  rs.getString(7));
				pstmt2.setString(8,  rs.getString(8));
				pstmt2.setString(9,  rs.getString(9));
				pstmt2.setString(10, rs.getString(10));
				pstmt2.setString(11, rs.getString(11));
				pstmt2.setInt   (12, rs.getInt(12));
				pstmt2.setInt   (13, rs.getInt(13));
				pstmt2.setString(14, rs.getString(14));
				pstmt2.setString(15, rs.getString(15));
				pstmt2.setInt   (16, rs.getInt(16));
				pstmt2.setString(17, rs.getString(17));
				pstmt2.executeUpdate();
				pstmt2.close();			
			}
			rs.close();
			pstmt1.close();			

            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				data_no = 0;
				System.out.println("[AddBillMngDatabase:insertTaxrela]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con1.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
    }

      /**
     *	���ݰ�꼭 �ܻ����� ���ݰ�꼭 �ڵ���ǥ ����
     */
    public int deleteTaxAutoDocu(String write_date, String data_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
//        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query =" delete from autodocu where write_date='"+write_date+"' and data_no="+data_no+"";

	   try{

            con1.setAutoCommit(false);

            pstmt = con1.prepareStatement(query);
			pstmt.executeUpdate();
            pstmt.close();

            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:deleteTaxAutoDocu]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con1.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return count;
    }

	
	// ����ī�����  ---------------------------------------------------------------------------------


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

	        query = " SELECT cardno as code, card_name as name, card_sdate, replace(card_edate,' ','') card_edate, etc FROM cardmana";

			if(!t_wd.equals("")) query += " where cardno||card_name like '%"+t_wd+"%'";  
	
			query += " order by card_name";

		}else if(s_kd.equals("item")){//ǰ��

	        query = " SELECT cd_item as code, nm_item as name FROM v_item";

			if(!t_wd.equals("")) query += " where nm_item like '%"+t_wd+"%'";  
	
			query += " order by nm_item";

		}else if(s_kd.equals("ven")){//�ŷ�ó

			query = " SELECT ven_code as code, ven_name as name, s_idno, id_no FROM vendor";

			if(!t_wd.equals("")) query += " where ven_name like '%"+t_wd+"%'";  
	
			query += " order by ven_name";

		}else if(s_kd.equals("depositma")){//���¹�ȣ

			query = " SELECT deposit_no as code, deposit_name as name FROM depositma";

			if(!t_wd.equals("")) query += " where deposit_name like '%"+t_wd+"%'";  
	
			query += " order by deposit_name";

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
			System.out.println("[AddBillMngDatabase:getCodeSearch]"+se);
			System.out.println("[AddBillMngDatabase:getCodeSearch]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return vt;
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

        query = " SELECT c_code as C_ST, ven_code as CODE, ven_name as NM, nvl(s_idno,id_no) as NM_CD"+
        		" FROM vendor"+//dzais.
        		" where c_code = '1000'";
				
//		if (s_kd.equals("1")) query += " and ven_name like '%"+t_wd+"%'";
//		if (s_kd.equals("2")) query += " and s_idno||id_no like '%"+t_wd+"%'";

		query += " and ven_name||s_idno||id_no like '%"+t_wd+"%'";

		query += " order by ven_name";

        Collection<CodeBean> col = new ArrayList<CodeBean>();
        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);

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
			System.out.println("[AddBillMngDatabase:getCodeAllVen]"+se);
			System.out.println("[AddBillMngDatabase:getCodeAllVen]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (CodeBean[])col.toArray(new CodeBean[0]);
    }

	/**
     * �׿���-��ü����Ʈ
     */
    public TradeBean [] getTradeList(String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
        
		if (t_wd.length() > 14)	t_wd = t_wd.substring(0,14);

        query = " SELECT * "+
        		" FROM vendor"+//dzais.
        		" where c_code = '1000'";
				
		query += " and ven_name||s_idno||id_no like '%"+t_wd+"%'";

		query += " order by ven_name";

        Collection<TradeBean> col = new ArrayList<TradeBean>();
        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
	            TradeBean bean = new TradeBean();

	            bean.setCust_code	(rs.getString("VEN_CODE"));
			    bean.setCust_name	(rs.getString("VEN_NAME"));
			    bean.setS_idno		(rs.getString("S_IDNO"));
				bean.setId_no		(rs.getString("ID_NO"));
	            bean.setDname		(rs.getString("DNAME"));
			    bean.setMail_no		(rs.getString("MAIL_NO"));
			    bean.setS_address	(rs.getString("S_ADDRESS"));
			    bean.setMd_gubun	(rs.getString("MD_GUBUN"));

				col.add(bean); 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AddBillMngDatabase:getTradeList]"+se);
			System.out.println("[AddBillMngDatabase:getTradeList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return (TradeBean[])col.toArray(new TradeBean[0]);
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
        
        query = " SELECT nvl(s_idno,id_no) enp_no"+
        		" FROM vendor"+//dzais.
        		" where c_code = '1000' and ven_code='"+ven_code+"'";
				
        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            if(rs.next()){                
				enp_no = rs.getString("enp_no")==null?"":rs.getString("enp_no");
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AddBillMngDatabase:getVendorEnpNo]"+se);
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
        
        query = " SELECT a.*, b.dept_name"+
        		" FROM v_perinfo a, v_deptcode b"+//dzais.
        		" where a.dept_code=b.dept_code and a.c_code = '1000' and a.kname='"+user_nm+"'";
				
        try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);
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
			System.out.println("[AddBillMngDatabase:getPerinfoDept]"+se);
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
     *	ī����ǥ �����ޱ� �ڵ���ǥ ����
     */
     /*
    public int insertCardAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
//        Connection con = connMgr.getConnection(DATA_SOURCE1);//neom
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
        Connection con1 = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
        PreparedStatement pstmt6 = null;
        ResultSet rs = null;

        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
        String query5 = "";
        String query6 = "";

        int count = 0;
        int data_no = 0;
                
		query1 =" select nvl(max(data_no)+1,1) from autodocu where write_date=replace(?,'-','')";

		//�������
		query2 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+ //(WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '4', 0, ?, ?,"+					//(CR_AMT, ACCT_CODE)
				"  ?,  ?,  ?,  ?,  ?,"+									//(CHECK_CODE1 ~CHECK_CODE5)
				"  ?, '', '', '', '',"+									//(CHECK_CODE6 ~CHECK_CODE10)
				"  ?,  ?,  ?,  ?,  ?,"+									//(CHECKD_CODE1~CHECKD_CODE5)
				"  ?, '', '', '', '',"+									//(CHECKD_CODE6~CHECKD_CODE10)
				"  ?,  ?,  ?,  ?,  ?,"+									//(CHECKD_NAME1~CHECKD_NAME5)
				"  ?, '', '', '', '',"+									//(CHECKD_NAME6~CHECKD_NAME10)
				" ?, to_char(sysdate,'YYYYMMDD') )";					//(INSERT_ID)

		//�����ޱ�
		query3 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+	//(WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '3', ?, 0, '25300',"+				//(DR_AMT)
				" 'A07', 'A19', 'F47', 'A13', 'A05',"+					//�ŷ�ó, ��ǥ��ȣ, �ſ�ī���ȣ, project, ǥ������
				"    '',    '',	   '',	  '',    '',"+
				"     ?,	'',     ?,    '',    '',"+					//�ŷ�ó, �ſ�ī���ȣ
				"    '',	'',    '',    '',    '',"+
				"     ?,	'',     ?,    '',     ?,"+					//�ŷ�ó, �ſ�ī���ȣ, ǥ������
				"    '',	'',    '',    '',    '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";					//(INSERT_ID)

		//�ΰ�����ޱ�
		query4 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+	//(WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '4', 0, ?, '13500',"+				//(CR_AMT)
				" 'A07', 'T01', 'F19', 'T03', 'F45',"+					//�ŷ�ó, ��������, �߻�����, ����ǥ�ؾ�, ����
				"    '',    '',	   '',	  '',    '',"+
				"     ?,  '27',    '',    '',    '',"+					//�ŷ�ó, ��������
				"    '',	'',    '',    '',    '',"+
				"     ?, 'ī��(����)', replace(?,'-',''), ?, ?,"+		//�ŷ�ó, ��������, �߻�����, ����ǥ�ؾ�, ����
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
				" '27', ?, ?, ?, ?,"+									//(GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO) : tax_gu=11��������,27ī�����
				" 0, '', ? )";											//(CARDNO)

		query6 = "update card_doc set app_id=?, app_dt=sysdate, autodocu_write_date=?, autodocu_data_no=? where cardno=? and buy_id=?";


	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);

			//ó����ȣ �̱�
			pstmt1 = con.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getWrite_dt().trim());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt1.close();			


			//����-�������------------------------------------------------------------------------------------
			pstmt2 = con.prepareStatement(query2);
			pstmt2.setString(1, ad_bean.getWrite_dt().trim());
			pstmt2.setInt   (2, data_no);
			pstmt2.setInt	(3, 1);
			pstmt2.setString(4, ad_bean.getNode_code().trim());
			pstmt2.setInt   (5, ad_bean.getAmt());
			pstmt2.setString(6, ad_bean.getAcct_code().trim());
			pstmt2.setString(7, "A09");//�ͼӺμ�
			pstmt2.setString(8, "A13");//������Ʈ
			pstmt2.setString(9, "A17");//�����
			pstmt2.setString(10, "A07");//�ŷ�ó
			if(ad_bean.getAcct_code().equals("54000") || ad_bean.getAcct_code().equals("53900")){//����������,���������
				pstmt2.setString(11, "S01");//ǰ��
				pstmt2.setString(12, "A05");//ǥ������
			}else if(ad_bean.getAcct_code().equals("51300")){//�����
				pstmt2.setString(11, "T01");//��������
				pstmt2.setString(12, "A05");//ǥ������
			}else{//�׿�
				pstmt2.setString(11, "A05");//ǥ������
				pstmt2.setString(12, "");
			}
			pstmt2.setString(13, ad_bean.getDept_code().trim());//�ͼӺμ�
			pstmt2.setString(14, "");//������Ʈ
			pstmt2.setString(15, ad_bean.getSa_code().trim());//�����
			pstmt2.setString(16, ad_bean.getVen_code().trim());//�ŷ�ó
			if(ad_bean.getAcct_code().equals("54000") || ad_bean.getAcct_code().equals("53900")){//����������,���������
				pstmt2.setString(17, ad_bean.getItem_code().trim());//ǰ��
				pstmt2.setString(18, "");//ǥ������
			}else if(ad_bean.getAcct_code().equals("51300")){//�����
				pstmt2.setString(17, "27");//��������
				pstmt2.setString(18, "");//ǥ������
			}else{//�׿�
				pstmt2.setString(17, "");//ǥ������
				pstmt2.setString(18, "");
			}
			pstmt2.setString(19, ad_bean.getDept_name().trim());//�ͼӺμ�
			pstmt2.setString(20, "");//������Ʈ
			pstmt2.setString(21, ad_bean.getKname().trim());//�����
			pstmt2.setString(22, ad_bean.getFirm_nm().trim());//�ŷ�ó
			if(ad_bean.getAcct_code().equals("54000") || ad_bean.getAcct_code().equals("53900")){//����������,���������
				pstmt2.setString(23, ad_bean.getItem_name().trim());//ǰ��
				pstmt2.setString(24, ad_bean.getAcct_cont().trim());//ǥ������
			}else if(ad_bean.getAcct_code().equals("51300")){//�����
				pstmt2.setString(23, "�ſ�ī�����");//��������
				pstmt2.setString(24, ad_bean.getAcct_cont().trim());//ǥ������
			}else{//�׿�
				pstmt2.setString(23, ad_bean.getAcct_cont().trim());//ǥ������
				pstmt2.setString(24, "");
			}
			pstmt2.setString(25, ad_bean.getInsert_id().trim());
			pstmt2.executeUpdate();
			pstmt2.close();			


			//�뺯-�����ޱ�(25300)------------------------------------------------------------------------------------
			pstmt3 = con.prepareStatement(query3);
			pstmt3.setString(1, ad_bean.getWrite_dt().trim());
			pstmt3.setInt   (2, data_no);
			pstmt3.setInt	(3, 2);
			pstmt3.setString(4, ad_bean.getNode_code().trim());
			pstmt3.setInt   (5, ad_bean.getAmt()+ad_bean.getAmt2());
			pstmt3.setString(6, ad_bean.getVen_code().trim());
			pstmt3.setString(7, ad_bean.getCardno().trim());
			pstmt3.setString(8, ad_bean.getFirm_nm().trim());
			pstmt3.setString(9, ad_bean.getCard_name().trim());
			pstmt3.setString(10, ad_bean.getAcct_cont().trim());
			pstmt3.setString(11, ad_bean.getInsert_id().trim());
			pstmt3.executeUpdate();
			pstmt3.close();			


			//�뺯-�ΰ�����ޱ�(13500)------------------------------------------------------------------------------------
	            pstmt4 = con.prepareStatement(query4);
				pstmt4.setString(1, ad_bean.getWrite_dt().trim());
				pstmt4.setInt   (2, data_no);
				pstmt4.setInt	(3, 3);
				pstmt4.setString(4, ad_bean.getNode_code().trim());
				pstmt4.setInt   (5, ad_bean.getAmt2());
				pstmt4.setString(6, ad_bean.getVen_code().trim());
				pstmt4.setString(7, ad_bean.getFirm_nm().trim());
				pstmt4.setString(8, ad_bean.getAcct_dt().trim());
				pstmt4.setInt   (9, ad_bean.getAmt());
				pstmt4.setString(10, ad_bean.getAcct_cont().trim());
				pstmt4.setString(11, ad_bean.getInsert_id().trim());

			//�ΰ���
				pstmt5 = con.prepareStatement(query5);
				pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
				pstmt5.setInt	(2,  data_no);
				pstmt5.setInt	(3,  3);
				pstmt5.setString(4,  ad_bean.getNode_code().trim());
				pstmt5.setString(5,  ad_bean.getWrite_dt().trim());
				pstmt5.setString(6,  ad_bean.getVen_type().trim());
				pstmt5.setInt   (7,  ad_bean.getAmt());
				pstmt5.setInt   (8,  ad_bean.getAmt2());
				pstmt5.setString(9,  ad_bean.getVen_code().trim());
				pstmt5.setString(10,  ad_bean.getS_idno().trim());
				pstmt5.setString(11,  ad_bean.getCardno().trim());

			if(ad_bean.getAmt2() > 0){
				pstmt4.executeUpdate();
				pstmt5.executeUpdate();
			}
			pstmt4.close();
			pstmt5.close();

			pstmt6 = con1.prepareStatement(query6);
			pstmt6.setString(1, ad_bean.getInsert_id().trim());
			pstmt6.setString(2, ad_bean.getWrite_dt().trim());
			pstmt6.setString(3, String.valueOf(data_no));
			pstmt6.setString(4, ad_bean.getCardno().trim());
			pstmt6.setString(5, ad_bean.getBuy_id().trim());
			pstmt6.executeUpdate();
			pstmt6.close();			

            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				data_no = 0;
				System.out.println("[AddBillMngDatabase:insertCardAutoDocu]"+se);
                con.rollback();
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
                if(pstmt5 != null) pstmt5.close();
                if(pstmt6 != null) pstmt6.close();
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE, con1);
			con = null;
			con1 = null;
        }
        return data_no;
    }
    */
    
    
      /**
     *	[1�ܰ�] data_no ��������
     */
    public int insertAutoDocu_step1(String data_gubun, String exp_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query1 = "";
        int data_no = 0;
                
		query1 =" select nvl(max(data_no)+1,1) from autodocu where  data_gubun = ? and write_date=replace(?,'-','')";

	   try{
     
			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, data_gubun);
			pstmt1.setString(2, exp_dt);
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}

		    rs.close();
            pstmt1.close();
             
         }catch(SQLException se){
			System.out.println("[AddBillMngDatabase:insertAutoDocu_step1]"+se);
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
    
    
     /**
     *	[1�ܰ�] data_no ��������
     */
    public int insertAutoDocu_step1(String exp_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query1 = "";
        int data_no = 0;
                
		query1 =" select nvl(max(data_no)+1,1) from autodocu where  data_gubun = '51' and write_date=replace(?,'-','')";

	   try{
     
			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, exp_dt);
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}

		    rs.close();
            pstmt1.close();
             
         }catch(SQLException se){
			System.out.println("[AddBillMngDatabase:insertAutoDocu_step1]"+se);
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
    

    /**
     *	[1�ܰ�] data_no ��������
     */
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
			System.out.println("[AddBillMngDatabase:insertCardAutoDocu_step1]"+se);
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
           

    /**
     *	[2�ܰ�] ������� �ڵ���ǥ ����
     */
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
 					    //20211116 �������� ������������� 45510 �ϳ��� ���� : 45700->45510
						pstmt2.setString(6, "45510");
				}
			}else if(ad_bean.getAcct_code().equals("00006")){//��������
				if(AddUtil.parseInt(ad_bean.getWrite_dt()) < 20080101){
						pstmt2.setString(6, "85600");
				}else{
						//20211116 �������� ������������� 45510 �ϳ��� ���� : 45600->45510
						pstmt2.setString(6, "45510");
				}

			}else if(ad_bean.getAcct_code().equals("00007")){//�繫��ǰ��
						pstmt2.setString(6, "82900");
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
				System.out.println("[AddBillMngDatabase:insertCardAutoDocu_step2]"+se);
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

    /**
     *	[3�ܰ�] �����ޱ� �ڵ���ǥ ����
     */
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
				System.out.println("[AddBillMngDatabase:insertCardAutoDocu]"+se);
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

    /**
     *	[4�ܰ�] �ΰ�����ޱ�+���� �ڵ���ǥ ����
     */
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
				System.out.println("[AddBillMngDatabase:insertCardAutoDocu_step4]"+se);
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

    /**
     *	ī����ǥ �����ޱ� �ڵ���ǥ ����
     */
    public int deleteCardAutoDocu(String write_date, String data_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query =" delete from autodocu where data_gubun='51' and write_date='"+write_date+"' and data_no="+data_no+"";

	   try{

            con1.setAutoCommit(false);

            pstmt = con1.prepareStatement(query);
			pstmt.executeUpdate();

			pstmt.close();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:deleteCardAutoDocu]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con1.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return count;
    }

   /**
     *	�ŷ�ó�ڵ� ��ȸ�ϱ�
     */
    public String getCustCodeNext() throws DatabaseException, DataSourceEmptyException{
        Connection con2 = connMgr.getConnection(DATA_SOURCE2);//neom_b(base)

        if(con2 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String cust_code = "";
		String min_code = "100000";
		String max_code = "199999";
                
		query = " select "+
				" nvl(to_char(max(cust_code)+1),'100001')"+
//				" nvl(ltrim(to_char(to_number(max(cust_code)+1), '100000')), '100001')"+
				" from trade where cust_code between '"+min_code+"' and '"+max_code+"'";

	   try{
    
			//�ŷ�ó�ڵ� �̱�
			pstmt = con2.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next()){
				cust_code = rs.getString(1).trim();
			}

			rs.close();
            pstmt.close();
    
		 }catch(SQLException se){
				System.out.println("[AddBillMngDatabase:getCustCodeNext]"+se);
				 throw new DatabaseException();
	        }finally{
	            try{
	                if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
	            }catch(SQLException _ignored){}
	            connMgr.freeConnection(DATA_SOURCE2, con2);
				con2 = null;
	        }
	        return cust_code;
	    }
      
    /**
     *	�ŷ�ó (�ŷ�ó�ڵ�,����ڹ�ȣ) �ߺ�üũ�ϱ�
     */
    public int getTradeCheck(String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con2 = connMgr.getConnection(DATA_SOURCE2);//neom_b(base)

        if(con2 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
		query ="select count(*) from trade";
		
		if(!s_kd.equals(""))	query += " where "+s_kd+" = replace('"+t_wd+"','-','')";

	   try{

   
			pstmt = con2.prepareStatement(query);
			rs = pstmt.executeQuery();

			if(rs.next()){
				count = rs.getInt(1);
			}

			rs.close();
            pstmt.close();
    
		}catch(SQLException se){
				System.out.println("[AddBillMngDatabase:getTradeCheck]"+se);
				 throw new DatabaseException();
	        }finally{
	            try{
	                if(rs != null )		rs.close();
	                if(pstmt != null)	pstmt.close();
	            }catch(SQLException _ignored){}
	            connMgr.freeConnection(DATA_SOURCE2, con2);
				con2 = null;
	        }
	        return count;
	    }
	    
	
    /**
     *	�ŷ�ó ���
     */
    public boolean insertTrade(TradeBean t_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con2 = connMgr.getConnection(DATA_SOURCE2);//neom_b(base)

        if(con2 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
		boolean flag = true;

		String cust_code = getCustCodeNext();
                
		query =" insert into trade (C_CODE, CUST_CODE, CUST_NAME, CUST_SORT, CUST_TYPE,"+
				" S_IDNO, DNAME, MAIL_NO, S_ADDRESS, FTRAD_DATE, MD_GUBUN, ID_NO, UPTAE, JONG)\n"+
				" values("+
				" '1000', ?, ?, replace(replace(?,'(��)',''),'(��)',''), '2',"+
				" replace(?,'-',''), ?, replace(?,'-',''), ?, to_char(sysdate,'YYYYMMDD'), 'Y', replace(?,'-',''), ?, ?)";

	   try{

            con2.setAutoCommit(false);

			pstmt = con2.prepareStatement(query);
			pstmt.setString(1, cust_code			);
			pstmt.setString(2, AddUtil.substringb(t_bean.getCust_name(),30));
			pstmt.setString(3, AddUtil.substringb(t_bean.getCust_name(),30));
			pstmt.setString(4, t_bean.getS_idno()	);
			pstmt.setString(5, t_bean.getDname()	);
			pstmt.setString(6, t_bean.getMail_no()	);
			pstmt.setString(7, t_bean.getS_address());
			pstmt.setString(8, t_bean.getId_no()	);
			pstmt.setString(9, t_bean.getUptae()	);
			pstmt.setString(10,t_bean.getJong()		);
			pstmt.executeUpdate();
						
            pstmt.close();
            con2.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[AddBillMngDatabase:insertTrade]"+se);

				System.out.println("[AddBillMngDatabase:cust_code			 ]"+cust_code			 );
				System.out.println("[AddBillMngDatabase:t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[AddBillMngDatabase:t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[AddBillMngDatabase:t_bean.getS_idno()	 ]"+t_bean.getS_idno()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getDname()	 ]"+t_bean.getDname()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getMail_no()	 ]"+t_bean.getMail_no()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getS_address()]"+t_bean.getS_address());
				System.out.println("[AddBillMngDatabase:t_bean.getId_no()	 ]"+t_bean.getId_no()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getUptae()	 ]"+t_bean.getUptae()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getJong()	 ]"+t_bean.getJong()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getUser_id()	 ]"+t_bean.getUser_id()	 );

                con2.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con2.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE2, con2);
			con2 = null;
        }
        return flag;
    }

    /**
     *	�ŷ�ó ����
     */
    public boolean updateTrade(TradeBean t_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con2 = connMgr.getConnection(DATA_SOURCE2);//neom_b(base)

        if(con2 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
		boolean flag = true;
                
		query =" update trade set "+
				"       CUST_NAME	= ?, "+
				"       CUST_SORT	= replace(replace(?,'(��)',''),'(��)',''), "+
				"       DNAME		= ?, "+
				"       MAIL_NO		= replace(?,'-',''), "+
				"       S_ADDRESS	= ?, "+
				"       ID_NO		= replace(?,'-',''), "+
				"       S_IDNO		= replace(?,'-',''), "+
				"       DC_RMK		= ?, "+
				"       MD_GUBUN	= ?, "+
				"       Uptae		= ?, "+
				"       Jong		= ?  "+
				" where C_CODE='1000' and CUST_CODE=?";


	   try{

            con2.setAutoCommit(false);

			pstmt = con2.prepareStatement(query);
			pstmt.setString(1,  t_bean.getCust_name	());
			pstmt.setString(2,  t_bean.getCust_name	());
			pstmt.setString(3,  t_bean.getDname		());
			pstmt.setString(4,  t_bean.getMail_no	());
			pstmt.setString(5,  t_bean.getS_address	());
			pstmt.setString(6,  t_bean.getId_no		());
			pstmt.setString(7,  t_bean.getS_idno	());
			pstmt.setString(8,  t_bean.getDc_rmk	());
			pstmt.setString(9,  t_bean.getMd_gubun	());
			pstmt.setString(10,  t_bean.getUptae	());
			pstmt.setString(11, t_bean.getJong		());
			pstmt.setString(12, t_bean.getCust_code	());

			pstmt.executeUpdate();
   
            pstmt.close();
            con2.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[AddBillMngDatabase:updateTrade]"+se);
				System.out.println("[t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[t_bean.getDname()	]"+t_bean.getDname()	);
				System.out.println("[t_bean.getMail_no()	]"+t_bean.getMail_no()	);
				System.out.println("[t_bean.getS_address()]"+t_bean.getS_address());
				System.out.println("[t_bean.getId_no()	]"+t_bean.getId_no()	);
				System.out.println("[t_bean.getDc_rmk()	]"+t_bean.getDc_rmk()	);
				System.out.println("[t_bean.getMd_gubun()	]"+t_bean.getMd_gubun()	);
				System.out.println("[t_bean.getCust_code()]"+t_bean.getCust_code());
                con2.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con2.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE2, con2);
			con2 = null;
        }
        return flag;
    }

	//�ڵ���ǥ ��������-----------------------------------------------------------------------------------------------

	/**
     * �ڵ���ǥ ��ȸ
     */
    public Vector getAutodocuList(String write_date, String data_no, String data_gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        
        query = " select\n"+
				" a.data_gubun, a.write_date, a.data_no,\n"+
				" decode(a.data_gubun,'21','��������','51','��������','53','��Ÿ','54','����') gubun,\n"+
				" decode(min(b.data_no),'','N','Y') taxrela,\n"+
				" decode(a.data_gubun,'21',nvl(max(checkd_name5),max(checkd_name4)),'51',max(checkd_name5),'53',max(checkd_name4),'54',max(checkd_name4)) cont, \n"+
				" MIN(a.INSERT_ID) reg_id "+
				" from autodocu a, TAXRELA b where a.docu_stat='0'\n";

		if(!write_date.equals(""))		query += " and a.write_date	=replace('"+write_date+"','-','')";

		if(!data_no.equals(""))			query += " and a.data_no	='"+data_no+"'";
		if(!data_gubun.equals(""))		query += " and a.data_gubun	='"+data_gubun+"'";
		
		query += " and a.data_gubun in ('21','51','53','54') and a.data_gubun=b.data_gubun(+) and a.write_date=b.write_date(+) and a.data_no=b.data_no(+)\n";
		query += " group by a.data_gubun, a.write_date, a.data_no order by a.write_date, a.data_no, a.data_gubun ";
			    


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
			 System.out.println("[AddBillMngDatabase:getAutodocuList]"+se);
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
        
        query = " select\n"+
				" a.data_gubun, a.write_date, a.data_no, a.docu_stat, decode(a.docu_stat,'0','��ó��','1','ó��') stat_nm, \n"+
				" decode(a.data_gubun,'21','��������','51','��������','53','��Ÿ','54','����') gubun,\n"+
				" decode(min(b.data_no),'','N','Y') taxrela,\n"+
				" decode(a.data_gubun,'21',nvl(max(checkd_name5),max(checkd_name4)),'51',max(checkd_name5),'53',max(checkd_name4),'54',max(checkd_name4)) cont\n"+
				" from autodocu a, TAXRELA b "+
				" where a.data_gubun=b.data_gubun(+) and a.write_date=b.write_date(+) and a.data_no=b.data_no(+)"+
				"  ";

		if(!write_date.equals(""))		query += " and a.write_date	=replace('"+write_date+"','-','')";
		if(!data_no.equals(""))			query += " and a.data_no	='"+data_no+"'";
		if(!data_gubun.equals(""))		query += " and a.data_gubun	='"+data_gubun+"'";
		

		query += " group by a.data_gubun, a.write_date, a.data_no, a.docu_stat "+
				 " order by a.write_date, a.data_no, a.data_gubun, a.docu_stat";


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
			 System.out.println("[AddBillMngDatabase:getAutodocuPayList]"+se);
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
        PreparedStatement pstmt2 = null;
        String query1 = "";
        String query2 = "";
		boolean flag = true;
                
		query1 = " delete from autodocu where write_date=replace(?,'-','') and data_no=? and data_gubun=?";
		query2 = " delete from taxrela where write_date=replace(?,'-','') and data_no=? and data_gubun=?";

	   try{

            con1.setAutoCommit(false);

			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, write_date);
			pstmt1.setString(2, data_no);
			pstmt1.setString(3, data_gubun);
			pstmt1.executeUpdate();
			pstmt1.close();

			if(taxrela.equals("Y")){
				pstmt2 = con1.prepareStatement(query2);
				pstmt2.setString(1, write_date);
				pstmt2.setString(2, data_no);
				pstmt2.setString(3, data_gubun);
				pstmt2.executeUpdate();
				pstmt2.close();
			}

			
            con1.commit();
   //         pstmt1.close();
   //         pstmt2.close();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[AddBillMngDatabase:deleteAutodocu]"+se);
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
                con1.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return flag;
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

		if(s_kd.equals("cardno")){//�ſ�ī��

	        query = " SELECT card_name as name    FROM cardmana  where cardno = '"+t_wd+"'";  
	
		}else if(s_kd.equals("item")){//ǰ��

	        query = " SELECT nm_item as name      FROM v_item    where cd_item = '"+t_wd+"'";  
	
		}else if(s_kd.equals("ven")){//�ŷ�ó

			query = " SELECT ven_name as name     FROM vendor    where ven_code = '"+t_wd+"'";
	
		}else if(s_kd.equals("depositma")){//���¹�ȣ

			query = " SELECT deposit_name as name FROM depositma where deposit_no = '"+t_wd+"'";  
	
		}else if(s_kd.equals("bank")){//����

			query = " SELECT checkd_name as name  FROM checkd    where check_code='A03' and c_code = '1000' and checkd_code ='"+t_wd+"'";  
	
		}
        
	    try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            if(rs.next()){                
				nm = rs.getString(1)==null?"":rs.getString(1);
            }
            rs.close();
            pstmt.close();
            
        }catch(SQLException se){
			System.out.println("[AddBillMngDatabase:getCodeByNm]"+se);
			System.out.println("[AddBillMngDatabase:getCodeByNm]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return nm;
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
        
        query = " select count(*) from autodocu where data_gubun='"+data_gubun+"'";

		if(!write_date.equals(""))		query += " and write_date	=replace('"+write_date+"','-','')";
		if(!data_no.equals(""))			query += " and data_no		='"+data_no+"'";
		if(!data_line.equals(""))		query += " and data_line	='"+data_line+"'";
		if(cr_amt > 0)					query += " and cr_amt		="+cr_amt+"";
		if(!checkd_name4.equals(""))	query += " and checkd_name4	='"+checkd_name4+"'";
		
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
			 System.out.println("[AddBillMngDatabase:getAutodocuChk]"+se);
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
     *	�������� �ڵ���ǥ ��� 
     */
    public int insertCommiAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
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

        int count = 0;
        int data_no = 0;
        int data_line = 1;
		String table = "autodocu";

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);


		query =" select nvl(max(data_no)+1,1) from "+table+" where DATA_GUBUN='51' and write_date=replace(?,'-','')";

			//ó����ȣ �̱�
			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, ad_bean.getAcct_dt().trim());
			rs = pstmt.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt.close();	


			//��������(45500)-����
			query1 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
					" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
					" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
					" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
					" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
					" INSERT_ID, INSERT_DATE)\n"+
					" values("+
					" '51', replace(?,'-',''), ?, "+data_line+", 1, '200', ?, '1000',"+	//1=�߻�����,2=DATA_NO,3=NODE_CODE
					" '', '0', '11', '3', '3', ?, 0, '45500',"+				//4=�����ݾ� 85400->45500->83100->45500(20090323)
					" 'A09', 'A13', 'A17', 'A07', 'A05',"+
					" '',  '', '', '', '',"+
					" '',  '', '', '', '',"+
					" '0', '', '', '', '',"+
					" '',  '', '',  ?,  ?,"+								//5=�ŷ�ó��,6=����
					" '',  '', '', '', '',"+
					" ?, to_char(sysdate,'YYYYMMDD') )";					//7=�ۼ���

			//DATA_GUBUN = 53 -> �ڷᱸ��:��Ÿ(53)

			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getAcct_dt().trim());
			pstmt1.setInt   (2, data_no);
			pstmt1.setString(3, ad_bean.getNode_code().trim());
			pstmt1.setInt   (4, ad_bean.getAmt());
			pstmt1.setString(5, ad_bean.getFirm_nm().trim());
			pstmt1.setString(6, ad_bean.getAcct_cont().trim());
			pstmt1.setString(7, ad_bean.getInsert_id().trim());
			pstmt1.executeUpdate();

			data_line++;

			//������-�뺯 (�ҵ漼)
			query2 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
					" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
					" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
					" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
					" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
					" INSERT_ID, INSERT_DATE)\n"+
					" values("+
					" '51', replace(?,'-',''), ?, "+data_line+", 1, '200', ?, '1000',"+	//1=�߻�����,2=DATA_NO,3=NODE_CODE
					" '', '0', '11', '3', '4', 0, ?, '25400',"+				//4=�뺯�ݾ�
					" 'F19', 'A19', 'A07', 'A05', '',"+
					" '', '', '', '', '',"+
					" '', '', '001272', '', '',"+
					" '', '', '', '', '',"+
					" replace(?,'-',''), '', '������������', ?, '',"+		//5=�߻�����,6=�ŷ�ó,7=����
					" '', '', '', '', '',"+
					" ?, to_char(sysdate,'YYYYMMDD') )";					//8=�ۼ���

			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1, ad_bean.getAcct_dt().trim());
			pstmt2.setInt   (2, data_no);
			pstmt2.setString(3, ad_bean.getNode_code().trim());
			pstmt2.setInt   (4, ad_bean.getAmt2());
			pstmt2.setString(5, ad_bean.getAcct_dt().trim());
//			pstmt2.setString(6, ad_bean.getFirm_nm().trim());
			pstmt2.setString(6, "[�ҵ漼]"+ad_bean.getFirm_nm().trim()+" "+ad_bean.getAcct_cont().trim());
			pstmt2.setString(7, ad_bean.getInsert_id().trim());
			pstmt2.executeUpdate();

			data_line++;

			//������-�뺯 (�ҵ漼)
			query3 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
					" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
					" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
					" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
					" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
					" INSERT_ID, INSERT_DATE)\n"+
					" values("+
					" '51', replace(?,'-',''), ?, "+data_line+", 1, '200', ?, '1000',"+	//1=�߻�����,2=DATA_NO,3=NODE_CODE
					" '', '0', '11', '3', '4', 0, ?, '25400',"+				//4=�뺯�ݾ�
					" 'F19', 'A19', 'A07', 'A05', '',"+
					" '', '', '', '', '',"+
					" '', '', '001281', '', '',"+
					" '', '', '', '', '',"+
					" replace(?,'-',''), '', '��������û', ?, '',"+			//5=�߻�����,6=�ŷ�ó,7=����
					" '', '', '', '', '',"+
					" ?, to_char(sysdate,'YYYYMMDD') )";					//8=�ۼ���

			pstmt3 = con1.prepareStatement(query3);
			pstmt3.setString(1, ad_bean.getAcct_dt().trim());
			pstmt3.setInt   (2, data_no);
			pstmt3.setString(3, ad_bean.getNode_code().trim());
			pstmt3.setInt   (4, ad_bean.getAmt3());
			pstmt3.setString(5, ad_bean.getAcct_dt().trim());
//			pstmt3.setString(6, ad_bean.getFirm_nm().trim());
			pstmt3.setString(6, "[�ֹμ�]"+ad_bean.getFirm_nm().trim()+" "+ad_bean.getAcct_cont().trim());
			pstmt3.setString(7, ad_bean.getInsert_id().trim());
			pstmt3.executeUpdate();

			data_line++;

			if(ad_bean.getNode_code().equals("B101") && AddUtil.parseInt(AddUtil.replace(ad_bean.getAcct_dt(),"-","")) <= 20090631){
				//�λ����� ������-�뺯
				query4 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
						" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
						" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
						" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
						" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
						" INSERT_ID, INSERT_DATE)\n"+
						" values("+
						" '51', replace(?,'-',''), ?, "+data_line+", 1, '200', ?, '1000',"+	//1=�߻�����,2=DATA_NO,3=NODE_CODE
						" '', '0', '11', '3', '4', 0, ?, '15000',"+				//4=�뺯�ݾ�
						" 'A05', '', '', '', '',  '', '', '', '', '',"+
						" '0',   '', '', '', '',  '', '', '', '', '',"+			
						" ?,     '', '', '', '',  '', '', '', '', '',"+			//5=����
						" ?, to_char(sysdate,'YYYYMMDD') )";					//6=�ۼ���

				//�뺯-������(15000)
				pstmt4 = con1.prepareStatement(query4);
				pstmt4.setString(1, ad_bean.getAcct_dt().trim());
				pstmt4.setInt   (2, data_no);
				pstmt4.setString(3, ad_bean.getNode_code().trim());
				pstmt4.setInt   (4, ad_bean.getAmt4());
				pstmt4.setString(5, ad_bean.getAcct_cont().trim());
				pstmt4.setString(6, ad_bean.getInsert_id().trim());
				pstmt4.executeUpdate();

				data_line++;

			}else if(ad_bean.getNode_code().equals("D101") && AddUtil.parseInt(AddUtil.replace(ad_bean.getAcct_dt(),"-","")) <= 20090631){
				//�������� ������-�뺯
				query4 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
						" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
						" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
						" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
						" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
						" INSERT_ID, INSERT_DATE)\n"+
						" values("+
						" '51', replace(?,'-',''), ?, "+data_line+", 1, '200', ?, '1000',"+	//1=�߻�����,2=DATA_NO,3=NODE_CODE
						" '', '0', '11', '3', '4', 0, ?, '14900',"+				//4=�뺯�ݾ�
						" 'A05', '', '', '', '',  '', '', '', '', '',"+
						" '0',   '', '', '', '',  '', '', '', '', '',"+			
						" ?,     '', '', '', '',  '', '', '', '', '',"+			//5=����
						" ?, to_char(sysdate,'YYYYMMDD') )";					//6=�ۼ���

				//�뺯-������(14900)
				pstmt4 = con1.prepareStatement(query4);
				pstmt4.setString(1, ad_bean.getAcct_dt().trim());
				pstmt4.setInt   (2, data_no);
				pstmt4.setString(3, ad_bean.getNode_code().trim());
				pstmt4.setInt   (4, ad_bean.getAmt4());
				pstmt4.setString(5, ad_bean.getAcct_cont().trim());
				pstmt4.setString(6, ad_bean.getInsert_id().trim());
				pstmt4.executeUpdate();

				data_line++;

			}else{
				//���뿹��-�뺯
				query4 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
						" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
						" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
						" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
						" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
						" INSERT_ID, INSERT_DATE)\n"+
						" values("+
						" '51', replace(?,'-',''), ?, "+data_line+", 1, '200', ?, '1000',"+	//1=�߻�����,2=DATA_NO,3=NODE_CODE
						" '', '0', '11', '3', '4', 0, ?, '10300',"+				//4=�뺯�ݾ�
						" 'A03', 'F05', 'F10', 'A05', '',  '', '', '', '', '',"+
						" ?, ?, '', '0', '',  '', '', '', '', '',"+				//5=�����ڵ�,6=�����ڵ�,
						" ?, ?, '', ?, '',  '', '', '', '', '',"+				//7=�����,8=���¸�,9=����
						" ?, to_char(sysdate,'YYYYMMDD') )";					//10=�ۼ���

				//�뺯-���뿹��(10300)
				pstmt4 = con1.prepareStatement(query4);
				pstmt4.setString(1, ad_bean.getAcct_dt().trim());
				pstmt4.setInt   (2, data_no);
				pstmt4.setString(3, ad_bean.getNode_code().trim());
				pstmt4.setInt   (4, ad_bean.getAmt4());
				pstmt4.setString(5, ad_bean.getBank_code().trim());
				pstmt4.setString(6, ad_bean.getDeposit_no().trim());
				pstmt4.setString(7, ad_bean.getBank_name().trim());
				pstmt4.setString(8, ad_bean.getDeposit_no().trim());
				pstmt4.setString(9, ad_bean.getAcct_cont().trim());
				pstmt4.setString(10, ad_bean.getInsert_id().trim());
				pstmt4.executeUpdate();

				data_line++;

			}

			if(ad_bean.getAmt8()>0 && ad_bean.getAcct_cd4().equals("83100")){
				//���޼�����(�۱ݼ�����)-����
				query5 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
						" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
						" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
						" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
						" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
						" INSERT_ID, INSERT_DATE)\n"+
						" values("+
						" '51', replace(?,'-',''), ?, "+data_line+", 1, '200', ?, '1000',"+	//1=�߻�����,2=DATA_NO,3=NODE_CODE
						" '', '0', '11', '3', '3', ?, 0, '83100',"+				//4=�����ݾ�
						" 'A09', 'A13', 'A17', 'A07', 'A05',"+
						" '',  '', '', '', '',"+
						" '',  '', '', '', '',"+
						" '0', '', '', '', '',"+
						" '',  '', '',  ?,  ?,"+								//5=�ŷ�ó��,6=����
						" '',  '', '', '', '',"+
						" ?, to_char(sysdate,'YYYYMMDD') )";					//7=�ۼ���

				//DATA_GUBUN = 53 -> �ڷᱸ��:��Ÿ(53)

				pstmt5 = con1.prepareStatement(query5);
				pstmt5.setString(1, ad_bean.getAcct_dt().trim());
				pstmt5.setInt   (2, data_no);
				pstmt5.setString(3, ad_bean.getNode_code().trim());
				pstmt5.setInt   (4, ad_bean.getAmt8());
				pstmt5.setString(5, ad_bean.getFirm_nm().trim());
				pstmt5.setString(6, ad_bean.getAcct_cont().trim());
				pstmt5.setString(7, ad_bean.getInsert_id().trim());
				pstmt5.executeUpdate();
				pstmt5.close();

				data_line++;

			}

			//���İ���1 (-) ������
			if(ad_bean.getAmt5()<0 && ad_bean.getAcct_cd1().equals("25400")){
				query6 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
						" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
						" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
						" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
						" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
						" INSERT_ID, INSERT_DATE)\n"+
						" values("+
						" '51', replace(?,'-',''), ?, "+data_line+", 1, '200', ?, '1000',"+	//1=�߻�����,2=DATA_NO,3=NODE_CODE
						" '', '0', '11', '3', '4', 0, ?, '25400',"+				//4=�뺯�ݾ�
						" 'F19', 'A19', 'A07', 'A05', '',"+
						" '', '', '', '', '',"+
						" '', '', '', '', '',"+
						" '', '', '', '', '',"+
						" replace(?,'-',''), '', ?, ?, '',"+					//5=�߻�����,6=�ŷ�ó,7=����
						" '', '', '', '', '',"+
						" ?, to_char(sysdate,'YYYYMMDD') )";					//8=�ۼ���

				pstmt6 = con1.prepareStatement(query6);
				pstmt6.setString(1, ad_bean.getAcct_dt().trim());
				pstmt6.setInt   (2, data_no);
				pstmt6.setString(3, ad_bean.getNode_code().trim());
				pstmt6.setInt   (4, -ad_bean.getAmt5());
				pstmt6.setString(5, ad_bean.getAcct_dt().trim());
				pstmt6.setString(6, ad_bean.getFirm_nm().trim());
				pstmt6.setString(7, "[����]"+ad_bean.getAcct_cont1().trim()+" "+ad_bean.getAcct_cont().trim());
				pstmt6.setString(8, ad_bean.getInsert_id().trim());
				pstmt6.executeUpdate();
				pstmt6.close();

				data_line++;
			}

			//���İ���2 (-) ������
			if(ad_bean.getAmt6()<0 && ad_bean.getAcct_cd2().equals("25400")){
				query7 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
						" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
						" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
						" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
						" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
						" INSERT_ID, INSERT_DATE)\n"+
						" values("+
						" '51', replace(?,'-',''), ?, "+data_line+", 1, '200', ?, '1000',"+	//1=�߻�����,2=DATA_NO,3=NODE_CODE
						" '', '0', '11', '3', '4', 0, ?, '25400',"+				//4=�뺯�ݾ�
						" 'F19', 'A19', 'A07', 'A05', '',"+
						" '', '', '', '', '',"+
						" '', '', '', '', '',"+
						" '', '', '', '', '',"+
						" replace(?,'-',''), '', ?, ?, '',"+					//5=�߻�����,6=�ŷ�ó,7=����
						" '', '', '', '', '',"+
						" ?, to_char(sysdate,'YYYYMMDD') )";					//8=�ۼ���

				pstmt7 = con1.prepareStatement(query7);
				pstmt7.setString(1, ad_bean.getAcct_dt().trim());
				pstmt7.setInt   (2, data_no);
				pstmt7.setString(3, ad_bean.getNode_code().trim());
				pstmt7.setInt   (4, -ad_bean.getAmt6());
				pstmt7.setString(5, ad_bean.getAcct_dt().trim());
				pstmt7.setString(6, ad_bean.getFirm_nm().trim());
				pstmt7.setString(7, "[����]"+ad_bean.getAcct_cont2().trim()+" "+ad_bean.getAcct_cont().trim());
				pstmt7.setString(8, ad_bean.getInsert_id().trim());
				pstmt7.executeUpdate();
				pstmt7.close();

				data_line++;
			}

			//���İ���3 (-) ������
			if(ad_bean.getAmt7()<0 && ad_bean.getAcct_cd3().equals("25400")){
				query8 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
						" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
						" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
						" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
						" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
						" INSERT_ID, INSERT_DATE)\n"+
						" values("+
						" '51', replace(?,'-',''), ?, "+data_line+", 1, '200', ?, '1000',"+	//1=�߻�����,2=DATA_NO,3=NODE_CODE
						" '', '0', '11', '3', '4', 0, ?, '25400',"+				//4=�뺯�ݾ�
						" 'F19', 'A19', 'A07', 'A05', '',"+
						" '', '', '', '', '',"+
						" '', '', '', '', '',"+
						" '', '', '', '', '',"+
						" replace(?,'-',''), '', ?, ?, '',"+					//5=�߻�����,6=�ŷ�ó,7=����
						" '', '', '', '', '',"+
						" ?, to_char(sysdate,'YYYYMMDD') )";					//8=�ۼ���

				pstmt8 = con1.prepareStatement(query8);
				pstmt8.setString(1, ad_bean.getAcct_dt().trim());
				pstmt8.setInt   (2, data_no);
				pstmt8.setString(3, ad_bean.getNode_code().trim());
				pstmt8.setInt   (4, -ad_bean.getAmt7());
				pstmt8.setString(5, ad_bean.getAcct_dt().trim());
				pstmt8.setString(6, ad_bean.getFirm_nm().trim());
				pstmt8.setString(7, "[����]"+ad_bean.getAcct_cont3().trim()+" "+ad_bean.getAcct_cont().trim());
				pstmt8.setString(8, ad_bean.getInsert_id().trim());
				pstmt8.executeUpdate();
				pstmt8.close();

				data_line++;
			}

            pstmt1.close();
            pstmt2.close();
            pstmt3.close();
            pstmt4.close();
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertCommiAutoDocu]"+se);
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
        return data_no;
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
        
        PreparedStatement pstmt6 = null;  //�׿��� �ΰ���
   
        ResultSet rs = null;

        String query = "";
        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
              
        String query7 = ""; 
                
        String comm_amt ="";
        String car_no = "";
       
        String item_code = "";
                          
        int amt1=0;
        int amt2=0;
        int amt3=0;
        int amt4=0;
   
		int i = 0;
		
        int count = 0;
        int data_no = 0;
		String table = "autodocu";
                
		query =" select nvl(max(data_no)+1,1) from "+table+" where DATA_GUBUN='53' and write_date=replace(?,'-','')";

	
			//���޼�����-����
		query1 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>2������
				" '', '0', '11', '3', '3', ?, 0, '83100',"+//4 93100->54400->86100->93100
				" 'A09', 'A13', 'A17', 'A07', 'A05', '', '', '', '', '',"+
				" '',  '', '', ?, '0', '', '', '', '', '',"+
				" '', '0', '', ?, ?, '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8		
	
		//��ݺ�-����
		query2 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>2������
				" '', '0', '11', '3', '3', ?, 0, '46400',"+//4 93100->54400->86100->93100->82400->46400
				" 'A09', 'A13', 'A17', 'A07', 'A05', '', '', '', '', '',"+
				" '',  '', '', ?, '0', '', '', '', '', '',"+
				" '', '0', '', ?, ?, '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8		
				
	
			//�ΰ�����ޱ�
		query3 =" insert into  "+table+"  (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+	//(WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '3', ?, 0, '13500',"+				//(DR_AMT)
				" 'A07', 'T01', 'F19', 'T03', 'A05',  '',    '',	 '',	  '',    '',"+		//�ŷ�ó, ��������, �߻�����, ����ǥ�ؾ�, ����
				"     ?,     ?,    '',    '',    '0', '',	'',    '',    '',    '',"+				//�ŷ�ó, ��������
				"     ?,     ?, replace(?,'-',''), ?,  ?,  '',	'',    '',    '',    '',"+ 	//�ŷ�ó, ��������, �߻�����, ����ǥ�ؾ�, ����
				" ?, to_char(sysdate,'YYYYMMDD') )";					//INSERT_ID
				
				
						
		//������ - �뺯
		query4 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '4', 0, ?, '25300',"+//4
				" 'A07', 'A19', 'F47', 'A13', 'A05', '', '', '', '', '',"+
				" ?, '', '',  '', '0', '', '', '', '', '', "+
				" ?, '', '', '0', ?, '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9
						
		
		//taxrela
		query7 =" insert into taxrela"+
				" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,"+
				" DEPT_CODE, NODE_CODE, C_CODE, BAL_DATE, VEN_TYPE,"+
				" TAX_GU, GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO,"+
				" GONG_AMT2, BUL_GUBUN)"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1,				"+//1,2		(WRITE_DATE, DATA_NO)
				" '200', ?, '1000', replace(?,'-',''), ?,		"+//3,4,5	(NODE_CODE, BAL_DATE, VEN_TYPE)
				" '21', ?, ?, ?, ?,								"+//6,7,8,9	(GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO), TAX_GU=21 ��������? 
				" 0, '' )";
				
	
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
			rs = pstmt.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt.close();	

			
			if ( amt1 > 0 ) {
				
			//	System.out.println("1");
				//����-���޼�����	()		    
				i++;     
				pstmt1 = con1.prepareStatement(query1);
				pstmt1.setString(1, ad_bean.getAcct_dt().trim());
				pstmt1.setInt   (2, data_no);
				pstmt1.setInt	(3, i);
				pstmt1.setString(4, ad_bean.getNode_code());
				pstmt1.setInt   (5, amt1);
				pstmt1.setString(6, ad_bean.getVen_code());
				pstmt1.setString(7, ad_bean.getFirm_nm());
				pstmt1.setString(8, "����� ��Ź��ǰ�� ����. ��ǰ������ - " + ad_bean.getItem_name().trim());
				pstmt1.setString(9, ad_bean.getInsert_id().trim());
				pstmt1.executeUpdate();
			    pstmt1.close();
			}		
							
			if ( amt2 > 0 ) {			
				//����- ��ݺ�
				i++; 	
			//	System.out.println("2");	
				pstmt2 = con1.prepareStatement(query2);
				pstmt2.setString(1, ad_bean.getAcct_dt().trim());
				pstmt2.setInt   (2, data_no);
				pstmt2.setInt	(3, i);
				pstmt2.setString(4, ad_bean.getNode_code());
				pstmt2.setInt   (5, amt2);
				pstmt2.setString(6, ad_bean.getVen_code());
				pstmt2.setString(7, ad_bean.getFirm_nm());
				pstmt2.setString(8, "����� ��Ź��ǰ�� ����Ź�۴�� - " + ad_bean.getItem_name().trim());
				pstmt2.setString(9, ad_bean.getInsert_id().trim());
				pstmt2.executeUpdate();
				pstmt2.close();
			}
						 				
				//����-�ΰ�����ޱ�(13500)
			i++; 	
		//	System.out.println("3");	
			pstmt3 = con1.prepareStatement(query3);
			pstmt3.setString(1, ad_bean.getAcct_dt().trim());
			pstmt3.setInt   (2, data_no);
			pstmt3.setInt	(3, i);
			pstmt3.setString(4, ad_bean.getNode_code());
			pstmt3.setInt   (5, amt3);
			pstmt3.setString(6, ad_bean.getVen_code());
			pstmt3.setString(7, "21");
			pstmt3.setString(8, ad_bean.getFirm_nm());
			pstmt3.setString(9, "����(����)");
			pstmt3.setString(10, ad_bean.getAcct_dt().trim());
			pstmt3.setInt   (11, amt1 + amt2);	
			pstmt3.setString(12, "����� ��Ź��ǰ�� ����. ��ǰ������ - " + ad_bean.getItem_name().trim());
			pstmt3.setString(13, ad_bean.getInsert_id().trim());
			pstmt3.executeUpdate();
	
						
			pstmt6 = con1.prepareStatement(query7);
			pstmt6.setString(1,  ad_bean.getAcct_dt().trim());
			pstmt6.setInt   (2,  data_no);
			pstmt6.setInt	(3, i);
			pstmt6.setString(4,  ad_bean.getNode_code().trim());
			pstmt6.setString(5,  ad_bean.getAcct_dt().trim());
			pstmt6.setString(6,  "0");
			pstmt6.setInt   (7,  amt1 + amt2);
			pstmt6.setInt   (8,  amt3);
			pstmt6.setString(9,  ad_bean.getVen_code().trim());
			pstmt6.setString(10,  ad_bean.getS_idno().trim());
			pstmt6.executeUpdate();
					
	
				//�뺯-�����ޱ�(25300)
			i++; 
		//	System.out.println("4");
			pstmt4 = con1.prepareStatement(query4);
			pstmt4.setString(1, ad_bean.getAcct_dt().trim());
			pstmt4.setInt   (2, data_no);
			pstmt4.setInt	(3, i);
			pstmt4.setString(4, ad_bean.getNode_code());
			pstmt4.setInt   (5, amt4);
			pstmt4.setString(6, ad_bean.getVen_code());
			pstmt4.setString(7, ad_bean.getFirm_nm());
			pstmt4.setString(8, "����� ��Ź��ǰ�� ����. ��ǰ������ - " + ad_bean.getItem_name().trim());
			pstmt4.setString(9, ad_bean.getInsert_id().trim());
			pstmt4.executeUpdate();
			
									        
            pstmt3.close();
            pstmt4.close();
            pstmt6.close();
         
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertAssetCommRegAutoDocu]"+se);
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
                if(pstmt6 != null) pstmt6.close();
                            
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
        PreparedStatement pstmt6 = null;
      
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
                      
        String reg_amt ="";
        String car_no = "";
        String car_use = "";
        
        String item_code = "";
                          
        int amt1=0;
        int amt2=0;
        int amt3=0;
        int amt4=0;
        int amt5=0;
        int amt6=0;
        int amt7=0;
   
   		int m_amt7= 0;
   
		int i = 0;
		
        int count = 0;
        int data_no = 0;
		String table = "autodocu";
                
		query =" select nvl(max(data_no)+1,1) from "+table+" where DATA_GUBUN='53' and write_date=replace(?,'-','')";

	
	   	//���뿹�� - > ���������� ����
	   	/*
		query1 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3,4
				" '', '0', '11', '3', '3', ?, 0, '10300',"+//5
				" 'A03', 'F05', 'F10', 'A05', '',  '', '', '', '', '',"+
				" ?, ?, '', '0', '',  '', '', '', '', '',"+//6,7,
				" ?, ?, '', ?, '',  '', '', '', '', '',"+//8,9,10
				" ?, to_char(sysdate,'YYYYMMDD') )";//11
	*/
	
	       //������	- 20120105 ���� ������ ó��
		query1 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3,4
				" '', '0', '11', '3', '3', ?, 0, '25900',"+//5
				" 'A07', 'F19', 'A19', 'A05', '',  '', '', '', '', '',"+
				" ?, '', '', '', '',  '', '', '', '', '',"+//6,
				" ?, replace(?,'-',''), '', ?, '',  '', '', '', '', '',"+//7,8,9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10		
		
		//������ - ����
		query2 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, '25300',"+//4
				" 'A07', 'A19', 'F47', 'A13', 'A05', '', '', '', '', '',"+
				" ?, '', '',  '', '0', '', '', '', '', '', "+
				" ?, '', '', '0', ?, '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9
			
		
		//����/�뿩�������-�뺯
		query3 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3,4 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '4', 0, ?, ?,"+//5, 6,
				" 'A07', 'A19', 'A13', 'A05', '', '', '', '', '', '',"+
				" ?,  '', '', '0', '', '', '', '', '', '',"+ //7
				" ?,  '', '0', ?, '', '', '', '', '', '',"+//8, 9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10	
					
				
			//�ΰ���������
		query4 =" insert into  "+table+"  (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+	//1,2,3,4,
				" '', '0', '11', '3', '4', 0, ?, '25500',"+				//5
				" 'A07', 'T01', 'F19', 'T03', 'F45',  'A05',   '',	 '',	  '',    '',"+		//�ŷ�ó, ��������, �߻�����, ����ǥ�ؾ�, ����
				"  ?, '11', '', '', '', '0', '', '', '', '',"+ 	//6
				" ?, '����(����)', replace(?,'-',''), ?, '', ?, '', '', '', '',"+// 7, 8, 9, 10 
				" ?, to_char(sysdate,'YYYYMMDD') )";					//11
				
			
			//taxrela
		query8 =" insert into taxrela"+
				" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,"+
				" DEPT_CODE, NODE_CODE, C_CODE, BAL_DATE, VEN_TYPE,"+
				" TAX_GU, GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO,"+
				" GONG_AMT2, BUL_GUBUN, JEONJA_YN)"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1,"+//2
				" '200', ?, '1000', replace(?,'-',''), ?,"+//5
				" '11', ?, ?, ?, ?,"+//9
				" 0, '', '2' )";				
				
		
		//������ ���� -����
		query5 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3,4 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, ?,"+//5, 6,
				" 'A05', '', '', '', '', '', '', '', '', '',"+
				" '0',  '', '', '', '', '', '', '', '', '',"+ 
				" ?,  '', '', '', '', '', '', '', '', '',"+//7
				" ?, to_char(sysdate,'YYYYMMDD') )";//8
					
						
		//ó������ - �뺯
		query6 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3,4 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '4', 0, ?, ?,"+// 5, 6
				" 'A09', 'A13', 'A17', 'A07', 'A05', '', '', '', '', '',"+
				" '',  '', '', ?, '0', '', '', '', '', '',"+ //7
				" '', '0', '', ?, ?, '', '', '', '', '',"+ //8,9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10		
						
	  	//ó�мս� - ����
		query7 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '53', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',"+//1,2,3, 4 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, ?,"+//5, 6
				" 'A09', 'A13', 'A17', 'A07', 'A05', '', '', '', '', '',"+
				" '',  '', '', ?, '0', '', '', '', '', '',"+ //7
				" '', '0', '', ?, ?, '', '', '', '', '',"+ //8, 9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10		
				
		
	
	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);
                
                      
            //�ݾ� �Ľ�:�Աݾ� ^ ������� ^  ��氡�� ^ ����ǥ�� ^ �ΰ��������� ^ ������ ����� ^ó������(ó�мս�)
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
				
			}		
           
           	//ó����ȣ �̱�
			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, ad_bean.getAcct_dt().trim());
			rs = pstmt.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt.close();	
			
			if (amt7 < 0) {
				m_amt7 = amt7 * (-1);
			}	
							
	//		System.out.println("1");
					//����-���뿹��(10300)	    
	/*				
			i++;     
			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getAcct_dt().trim());
			pstmt1.setInt   (2, data_no);
			pstmt1.setInt	(3, i);
			pstmt1.setString(4, ad_bean.getNode_code());
			pstmt1.setInt   (5, amt1);
			pstmt1.setString(6, ad_bean.getBank_code().trim());
			pstmt1.setString(7, ad_bean.getDeposit_no().trim());
			pstmt1.setString(8, ad_bean.getBank_name().trim());
			pstmt1.setString(9, ad_bean.getDeposit_no().trim());
			pstmt1.setString(10, "�����Ű� - " + ad_bean.getItem_name().trim());
			pstmt1.setString(11, ad_bean.getInsert_id().trim());
			pstmt1.executeUpdate();
	*/		
			
			//����-������(25900)	    - 20120105 ����
			i++;     
			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getAcct_dt().trim());
			pstmt1.setInt   (2, data_no);
			pstmt1.setInt	(3, i);
			pstmt1.setString(4, ad_bean.getNode_code());
			pstmt1.setInt   (5, amt1);
			pstmt1.setString(6, ad_bean.getVen_code());
			pstmt1.setString(7, ad_bean.getFirm_nm());
			pstmt1.setString(8, ad_bean.getAcct_dt().trim());
			pstmt1.setString(9, "�����Ű� - " + ad_bean.getItem_name().trim());
			pstmt1.setString(10, ad_bean.getInsert_id().trim());
			pstmt1.executeUpdate();
		 
			
			if ( amt2 > 0) {			
				//����-�����ޱ�(25300)	  
				i++; 	
		//		System.out.println("2");	
				pstmt2 = con1.prepareStatement(query2);
				pstmt2.setString(1, ad_bean.getAcct_dt().trim());
				pstmt2.setInt   (2, data_no);
				pstmt2.setInt	(3, i);
				pstmt2.setString(4, ad_bean.getNode_code());
				pstmt2.setInt   (5, amt2);
				pstmt2.setString(6, ad_bean.getVen_code());
				pstmt2.setString(7, ad_bean.getFirm_nm());
				pstmt2.setString(8, "�����Ű� �������ǰ������� - " + ad_bean.getItem_name().trim());
				pstmt2.setString(9, ad_bean.getInsert_id().trim());
				pstmt2.executeUpdate();
			}
									 				
			//�뺯-����/�뿩�������	()		 
			i++; 	
	//		System.out.println("3");	
			pstmt3 = con1.prepareStatement(query3);
			pstmt3.setString(1, ad_bean.getAcct_dt().trim());
			pstmt3.setInt   (2, data_no);
			pstmt3.setInt	(3, i);
			pstmt3.setString(4, ad_bean.getNode_code());
			pstmt3.setInt   (5, amt3 );
			pstmt3.setString(6, ad_bean.getAcct_code());
			
		//	if (car_use.equals("1") ) {
		//		pstmt3.setString(6, "21900");
		//		}
		//	else {
		//		pstmt3.setString(6, "21700");
		//	}
		
			pstmt3.setString(7, "000131");
			pstmt3.setString(8, "�Ƹ���ī" );
			pstmt3.setString(9, "�����Ű� - " + ad_bean.getItem_name().trim());
			pstmt3.setString(10, ad_bean.getInsert_id().trim());
			pstmt3.executeUpdate();
			
								 				
			//�뺯-�ΰ���������(25500)
			i++; 	
	//		System.out.println("4");	
			pstmt4 = con1.prepareStatement(query4);
			pstmt4.setString(1, ad_bean.getAcct_dt().trim());
			pstmt4.setInt   (2, data_no);
			pstmt4.setInt	(3, i);
			pstmt4.setString(4, ad_bean.getNode_code());
			pstmt4.setInt   (5, amt5);
			pstmt4.setString(6, ad_bean.getVen_code2());
			pstmt4.setString(7, ad_bean.getFirm_nm2());
			pstmt4.setString(8, ad_bean.getAcct_dt().trim());
			pstmt4.setInt   (9, amt4);	
			pstmt4.setString(10, "�����Ű� - " + ad_bean.getItem_name().trim());
			pstmt4.setString(11, ad_bean.getInsert_id().trim());
			pstmt4.executeUpdate();
				 		    	
	   
		
			//����-����/�뿩������� �����󰢴����	()		 
			i++; 	
	//		System.out.println("5");	
			pstmt5 = con1.prepareStatement(query5);
			pstmt5.setString(1, ad_bean.getAcct_dt().trim());
			pstmt5.setInt   (2, data_no);
			pstmt5.setInt	(3, i);
			pstmt5.setString(4, ad_bean.getNode_code());
			pstmt5.setInt   (5, amt6);
			if (ad_bean.getAcct_code().equals("21900") ) {
				pstmt5.setString(6, "22000");
			}
			else {
				pstmt5.setString(6, "21800");
			}
			pstmt5.setString(7, "�����Ű� �����󰢴���� ��ü - " + ad_bean.getItem_name().trim());
			pstmt5.setString(8, ad_bean.getInsert_id().trim());
			pstmt5.executeUpdate();
			
			//ó������/�ս�
			i++; 
			if (amt7 > 0 ) {
				pstmt6 = con1.prepareStatement(query6);
							
			}
			else {
				pstmt6 = con1.prepareStatement(query7);
			}	
			
			pstmt6.setString(1, ad_bean.getAcct_dt().trim());
			pstmt6.setInt   (2, data_no);
			pstmt6.setInt	(3, i);
			pstmt6.setString(4, ad_bean.getNode_code());
					
			if (amt7 > 0 ) {
				if ( ad_bean.getAcct_code().equals("21900") ) {
					pstmt6.setString(6, "41500");
				} else {
					pstmt6.setString(6, "41300");
				}	
				pstmt6.setInt   (5, amt7);
				pstmt6.setString(9, "�����Ű� ó������ - " + ad_bean.getItem_name().trim());
			} else {
				if ( ad_bean.getAcct_code().equals("21900") ) {
					pstmt6.setString(6, "45400");
				} else {
					pstmt6.setString(6, "45300");
				}					
				pstmt6.setInt   (5, m_amt7 );
				pstmt6.setString(9, "�����Ű� ó�мս� - " + ad_bean.getItem_name().trim());
			}	
				
						
			pstmt6.setString(7, "000131");
			pstmt6.setString(8,  "�Ƹ���ī" );
			pstmt6.setString(10, ad_bean.getInsert_id().trim());
			pstmt6.executeUpdate();
	   
	    		//�ΰ���
	
			pstmt8 = con1.prepareStatement(query8);
			pstmt8.setString(1,  ad_bean.getAcct_dt().trim());
			pstmt8.setInt   (2,  data_no);
			pstmt8.setInt   (3,  4);
			pstmt8.setString(4,  ad_bean.getNode_code().trim());
			pstmt8.setString(5,  ad_bean.getAcct_dt().trim());
			pstmt8.setString(6,  ad_bean.getVen_type().trim());
			pstmt8.setInt   (7,   amt4);	
			pstmt8.setInt   (8,   amt5);	
			pstmt8.setString(9,  ad_bean.getVen_code2().trim());
			pstmt8.setString(10,  ad_bean.getS_idno().trim());
		
	    	pstmt8.executeUpdate();
			    		    	
			pstmt1.close();
			pstmt2.close();								        
            pstmt3.close();
            pstmt4.close();
            pstmt5.close();
            pstmt6.close();
            pstmt8.close();
           
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
			//	System.out.println("�ΰ��� taxrela");	
	    	//	System.out.println("acct_dt="+ ad_bean.getAcct_dt().trim() + " :data_no = " + data_no + ": i = 4 : node_code= " +  ad_bean.getNode_code().trim() );
	    	//	System.out.println("ven_type = " + ad_bean.getVen_type().trim() + " : gong_amt =" + amt4 + ": tax_vat = "+ amt5 + ":ven_code = " + ad_bean.getVen_code2().trim() + ": s_idno = " + ad_bean.getS_idno().trim() );	
	    	//	System.out.println("query8="+ query8);
				System.out.println("[AddBillMngDatabase:insertAssetSaleRegAutoDocu]"+se);
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
                if(pstmt8 != null) pstmt8.close();
             
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
        }
        return count;
    }
    
     /**
     *	������� ���ݰ�꼭 ��� 
     */
    public int insertCarPurAmtAutoDocu(AutoDocuBean ad_bean, ContPurBean pur) throws DatabaseException, DataSourceEmptyException{
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
                
		query1 =" select nvl(max(data_no)+1,1) from autodocu where DATA_GUBUN='51' and write_date=replace(?,'-','')";

		//�뿩������� (����)
		query2 =" insert into autodocu ( "+
				" DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,     DEPT_CODE, NODE_CODE, C_CODE,"+	//8
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN,    DR_AMT, CR_AMT, ACCT_CODE,"+		//8
				" CHECK_CODE1, CHECKD_CODE1, CHECKD_NAME1, "+
				" CHECK_CODE2, CHECKD_CODE2, CHECKD_NAME2, "+
				" CHECK_CODE3, CHECKD_CODE3, CHECKD_NAME3, "+
				" CHECK_CODE4, CHECKD_CODE4, CHECKD_NAME4, "+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',		"+		//1,2,3,4	(WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '3', ?, 0, '21700',					"+		//5			(DR_AMT)
				" 'A01', '',  '',											"+		//�μ��ڵ�(A01)
				" 'A13', '',  '0',											"+		//������Ʈ(A13)
				" 'A07', ?,   ?,											"+		//�ŷ�ó(A07)	6,7
				" 'A05', '0', ?,											"+		//ǥ������(A05) 8
				" ?, to_char(sysdate,'YYYYMMDD')"+
				" )";


		//����������� (����)
		query3 =" insert into autodocu ( "+
				" DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,     DEPT_CODE, NODE_CODE, C_CODE,"+	//8
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN,    DR_AMT, CR_AMT, ACCT_CODE,"+		//8
				" CHECK_CODE1, CHECKD_CODE1, CHECKD_NAME1, "+
				" CHECK_CODE2, CHECKD_CODE2, CHECKD_NAME2, "+
				" CHECK_CODE3, CHECKD_CODE3, CHECKD_NAME3, "+
				" CHECK_CODE4, CHECKD_CODE4, CHECKD_NAME4, "+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '200', ?, '1000',		"+		//1,2,3,4	(WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '3', ?, 0, '21900',					"+		//5			(DR_AMT)
				" 'A07', ?,  ?,												"+		//�ŷ�ó(A07)	6,7
				" 'A19', '', '',											"+		//��ǥ��ȣ(A19)
				" 'A13', '', '0',											"+		//������Ʈ(A13)
				" 'A05', '', ?,												"+		//ǥ������(A05)	8
				" ?, to_char(sysdate,'YYYYMMDD')"+
				" )";


		//�ΰ�����ޱ� (����)
		query4 =" insert into autodocu ( "+
				" DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,	DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN,	DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECKD_CODE1, CHECKD_NAME1, "+
				" CHECK_CODE2, CHECKD_CODE2, CHECKD_NAME2, "+
				" CHECK_CODE3, CHECKD_CODE3, CHECKD_NAME3, "+
				" CHECK_CODE4, CHECKD_CODE4, CHECKD_NAME4, "+
				" CHECK_CODE5, CHECKD_CODE5, CHECKD_NAME5, "+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1,	'200', ?, '1000',		"+		//1,2,3,4	(WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '3', ?, 0, '13500',					"+		//5			(DR_AMT)
				" 'A07', ?,    ?,											"+		//�ŷ�ó(A07)		6,7
				" 'T01', '21', '����(����)',								"+		//��������(T01)
				" 'F19', '',   replace(?,'-',''),							"+		//�߻�����(F19)		8
				" 'T03', '',   ?,											"+		//����ǥ�ؾ�(T03)	9
				" 'A05', '0',  ?,											"+		//ǥ������(A05)		10
				" ?, to_char(sysdate,'YYYYMMDD')"+
				" )";

		//taxrela
		query7 =" insert into taxrela"+
				" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,"+
				" DEPT_CODE, NODE_CODE, C_CODE, BAL_DATE, VEN_TYPE,"+
				" TAX_GU, GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO,"+
				" GONG_AMT2, BUL_GUBUN)"+
				" values("+
				" '51', replace(?,'-',''), ?, 2, 1,				"+//1,2		(WRITE_DATE, DATA_NO)
				" '200', ?, '1000', replace(?,'-',''), ?,		"+//3,4,5	(NODE_CODE, BAL_DATE, VEN_TYPE)
				" '21', ?, ?, ?, ?,								"+//6,7,8,9	(GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO), TAX_GU=21 ��������? 
				" 0, '' )";


		//���ޱ�-�뺯
		query5 =" insert into autodocu ( "+
				" DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,	DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN,	DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECKD_CODE1, CHECKD_NAME1, "+
				" CHECK_CODE2, CHECKD_CODE2, CHECKD_NAME2, "+
				" CHECK_CODE3, CHECKD_CODE3, CHECKD_NAME3, "+
				" CHECK_CODE4, CHECKD_CODE4, CHECKD_NAME4, "+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1,	'200', ?, '1000',		"+		//1,2,3,4 (WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '4', 0, ?, '13100',					"+		//5
				" 'A07', ?,    ?,											"+		//�ŷ�ó(A07)		6,7
				" 'F19', '',   replace(?,'-',''),							"+		//�߻�����(F19)		8
				" 'A19', '', '',											"+		//��ǥ��ȣ(A19)
				" 'A05', '0',  ?,											"+		//ǥ������(A05)		9
				" ?, to_char(sysdate,'YYYYMMDD')"+
				" )";

		//�����ޱ�-�뺯
		query6 =" insert into autodocu ( "+
				" DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,	DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN,	DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECKD_CODE1, CHECKD_NAME1, "+
				" CHECK_CODE2, CHECKD_CODE2, CHECKD_NAME2, "+
				" CHECK_CODE3, CHECKD_CODE3, CHECKD_NAME3, "+
				" CHECK_CODE4, CHECKD_CODE4, CHECKD_NAME4, "+
				" CHECK_CODE5, CHECKD_CODE5, CHECKD_NAME5, "+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1,	'200', ?, '1000',		"+		//1,2,3,4 (WRITE_DATE, DATA_NO, DATA_LINE, NODE_CODE)
				" '', '0', '11', '3', '4', 0, ?, '25300',					"+		//5
				" 'A07', ?,    ?,											"+		//�ŷ�ó(A07)		6,7
				" 'A19', '', '',											"+		//��ǥ��ȣ(A19)
				" 'F47', ?,    ?,											"+		//�ſ�ī���ȣ(F47)
				" 'A13', '', '0',											"+		//������Ʈ(A13)
				" 'A05', '0',  ?,											"+		//ǥ������(A05)		8
				" ?, to_char(sysdate,'YYYYMMDD')"+
				" )";

		query8 =" select acct_code from pay_item where p_cd1=? and p_cd2=? and p_cd5=? and p_gubun='01'";

	   try{

            con1.setAutoCommit(false);
			con.setAutoCommit(false);

			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getWrite_dt().trim());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt1.close();			

			//����
			if(ad_bean.getCar_st().equals("1")){
				//-�뿩�������(21700)
				pstmt2 = con1.prepareStatement(query2);
			}else{
				//-�����������(21900)
				pstmt2 = con1.prepareStatement(query3);
			}
			pstmt2.setString(1,  ad_bean.getWrite_dt().trim());
			pstmt2.setInt   (2,  data_no);
			pstmt2.setInt   (3,  data_line);
			pstmt2.setString(4,  ad_bean.getNode_code().trim());
			pstmt2.setInt   (5,  ad_bean.getAmt());
			pstmt2.setString(6,  ad_bean.getVen_code().trim());
			pstmt2.setString(7,  ad_bean.getFirm_nm().trim());
			pstmt2.setString(8,  ad_bean.getAcct_cont().trim());
			pstmt2.setString(9,  ad_bean.getInsert_id().trim());
			pstmt2.executeUpdate();
			pstmt2.close();			

			data_line++;
			
			//����-�ΰ�����ޱ�(13500)
            pstmt3 = con1.prepareStatement(query4);
			pstmt3.setString(1,  ad_bean.getWrite_dt().trim());
			pstmt3.setInt   (2,  data_no);
			pstmt3.setInt   (3,  data_line);
			pstmt3.setString(4,  ad_bean.getNode_code().trim());
			pstmt3.setInt   (5,  ad_bean.getAmt2());
			pstmt3.setString(6,  ad_bean.getVen_code().trim());
			pstmt3.setString(7,  ad_bean.getFirm_nm().trim());
			pstmt3.setString(8,  ad_bean.getAcct_dt().trim());
			pstmt3.setInt   (9,  ad_bean.getAmt());
			pstmt3.setString(10, ad_bean.getAcct_cont().trim());
			pstmt3.setString(11, ad_bean.getInsert_id().trim());
			pstmt3.executeUpdate();
            pstmt3.close();

			data_line++;

			//���� �ִ�
			if(ad_bean.getAmt3() > 0){
				//�뺯-���ޱ�(13100)
		        pstmt4 = con1.prepareStatement(query5);
				pstmt4.setString(1,  ad_bean.getWrite_dt().trim());
				pstmt4.setInt   (2,  data_no);
				pstmt4.setInt   (3,  data_line);
				pstmt4.setString(4,  ad_bean.getNode_code().trim());
				pstmt4.setInt   (5,  ad_bean.getAmt3());
				pstmt4.setString(6,  ad_bean.getVen_code2().trim());
				pstmt4.setString(7,  ad_bean.getFirm_nm2().trim());
				pstmt4.setString(8,  ad_bean.getAcct_dt().trim());
				pstmt4.setString(9,  ad_bean.getAcct_cont().trim());
				pstmt4.setString(10, ad_bean.getInsert_id().trim());
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

				if( AddUtil.parseInt(AddUtil.replace(pur.getTrf_pay_dt1(),"-","")) >20111124){
					//�뺯-���ޱ�(13100)
					if(acct_code.equals("13100")){
					    pstmt4 = con1.prepareStatement(query5);
						pstmt4.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt4.setInt   (2,  data_no);
						pstmt4.setInt   (3,  data_line);
						pstmt4.setString(4,  ad_bean.getNode_code().trim());
						pstmt4.setInt   (5,  ad_bean.getAmt4());
						pstmt4.setString(6,  ad_bean.getVen_code4().trim());
						pstmt4.setString(7,  ad_bean.getFirm_nm4().trim());
						pstmt4.setString(8,  ad_bean.getAcct_dt().trim());
						pstmt4.setString(9,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						pstmt4.setString(10, ad_bean.getInsert_id().trim());
						pstmt4.executeUpdate();
					    pstmt4.close();
						data_line++;
					//�뺯-�����ޱ�(25300)
					}else{
					    pstmt5 = con1.prepareStatement(query6);
						pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt5.setInt   (2,  data_no);
						pstmt5.setInt   (3,  data_line);
						pstmt5.setString(4,  ad_bean.getNode_code().trim());
						pstmt5.setInt   (5,  ad_bean.getAmt4());
						if(pur.getTrf_st1().equals("3") || pur.getTrf_st1().equals("2") || pur.getTrf_st1().equals("7")){
							pstmt5.setString(6,  ad_bean.getVen_code4().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm4().trim());
							pstmt5.setString(8,  ad_bean.getCardno1().trim());
							pstmt5.setString(9,  ad_bean.getCardnm1().trim());
							pstmt5.setString(10,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						}else{
							pstmt5.setString(6,  ad_bean.getVen_code2().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm2().trim());
							pstmt5.setString(8,  "");
							pstmt5.setString(9,  "");
							pstmt5.setString(10,  ad_bean.getAcct_cont().trim());
						}
						pstmt5.setString(11,  ad_bean.getInsert_id().trim());
						pstmt5.executeUpdate();
					    pstmt5.close();
						data_line++;
					}
				}else{
					//�뺯-���ޱ�(13100)
					if(pur.getTrf_st1().equals("2") && AddUtil.parseInt(AddUtil.replace(pur.getTrf_pay_dt1(),"-","")) < AddUtil.parseInt(AddUtil.replace(ad_bean.getWrite_dt(),"-",""))){
					    pstmt4 = con1.prepareStatement(query5);
						pstmt4.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt4.setInt   (2,  data_no);
						pstmt4.setInt   (3,  data_line);
						pstmt4.setString(4,  ad_bean.getNode_code().trim());
						pstmt4.setInt   (5,  ad_bean.getAmt4());
						pstmt4.setString(6,  ad_bean.getVen_code4().trim());
						pstmt4.setString(7,  ad_bean.getFirm_nm4().trim());
						pstmt4.setString(8,  ad_bean.getAcct_dt().trim());
						pstmt4.setString(9,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						pstmt4.setString(10, ad_bean.getInsert_id().trim());
						pstmt4.executeUpdate();
					    pstmt4.close();
						data_line++;
					//�뺯-�����ޱ�(25300)
					}else{
					    pstmt5 = con1.prepareStatement(query6);
					    
						pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt5.setInt   (2,  data_no);
						pstmt5.setInt   (3,  data_line);
						pstmt5.setString(4,  ad_bean.getNode_code().trim());
						pstmt5.setInt   (5,  ad_bean.getAmt4());
						if(pur.getTrf_st1().equals("3") || pur.getTrf_st1().equals("2") || pur.getTrf_st1().equals("7")){
							pstmt5.setString(6,  ad_bean.getVen_code4().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm4().trim());
							pstmt5.setString(8,  ad_bean.getCardno1().trim());
							pstmt5.setString(9,  ad_bean.getCardnm1().trim());
							pstmt5.setString(10,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						}else{
							pstmt5.setString(6,  ad_bean.getVen_code2().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm2().trim());
							pstmt5.setString(8,  "");
							pstmt5.setString(9,  "");
							pstmt5.setString(10,  ad_bean.getAcct_cont().trim());
						}
						pstmt5.setString(11,  ad_bean.getInsert_id().trim());
						pstmt5.executeUpdate();
					    pstmt5.close();
						data_line++;
					}
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
				
				if( AddUtil.parseInt(AddUtil.replace(pur.getTrf_pay_dt2(),"-","")) >20111124){
					//�뺯-���ޱ�(13100)
					if(acct_code.equals("13100")){
					    pstmt4 = con1.prepareStatement(query5);
						pstmt4.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt4.setInt   (2,  data_no);
						pstmt4.setInt   (3,  data_line);
						pstmt4.setString(4,  ad_bean.getNode_code().trim());
						pstmt4.setInt   (5,  ad_bean.getAmt5());
						pstmt4.setString(6,  ad_bean.getVen_code5().trim());
						pstmt4.setString(7,  ad_bean.getFirm_nm5().trim());
						pstmt4.setString(8,  ad_bean.getAcct_dt().trim());
						pstmt4.setString(9,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						pstmt4.setString(10, ad_bean.getInsert_id().trim());
						pstmt4.executeUpdate();
					    pstmt4.close();
						data_line++;
					//�뺯-�����ޱ�(25300)
					}else{
					    pstmt5 = con1.prepareStatement(query6);
						pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt5.setInt   (2,  data_no);
						pstmt5.setInt   (3,  data_line);
						pstmt5.setString(4,  ad_bean.getNode_code().trim());
						pstmt5.setInt   (5,  ad_bean.getAmt5());
						if(pur.getTrf_st2().equals("3") || pur.getTrf_st2().equals("2") || pur.getTrf_st2().equals("7")){
							pstmt5.setString(6,  ad_bean.getVen_code5().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm5().trim());
							pstmt5.setString(8,  ad_bean.getCardno2().trim());
							pstmt5.setString(9,  ad_bean.getCardnm2().trim());
							pstmt5.setString(10,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						}else{
							pstmt5.setString(6,  ad_bean.getVen_code2().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm2().trim());
							pstmt5.setString(8,  "");
							pstmt5.setString(9,  "");
							pstmt5.setString(10,  ad_bean.getAcct_cont().trim());
						}
						pstmt5.setString(11,  ad_bean.getInsert_id().trim());
						pstmt5.executeUpdate();
					    pstmt5.close();
						data_line++;
					}
				}else{
					//�뺯-���ޱ�(13100)
					if(pur.getTrf_st2().equals("2") && AddUtil.parseInt(AddUtil.replace(pur.getTrf_pay_dt2(),"-","")) <= AddUtil.parseInt(AddUtil.replace(ad_bean.getWrite_dt(),"-",""))){
					    pstmt4 = con1.prepareStatement(query5);
						pstmt4.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt4.setInt   (2,  data_no);
						pstmt4.setInt   (3,  data_line);
						pstmt4.setString(4,  ad_bean.getNode_code().trim());
						pstmt4.setInt   (5,  ad_bean.getAmt5());
						pstmt4.setString(6,  ad_bean.getVen_code5().trim());
						pstmt4.setString(7,  ad_bean.getFirm_nm5().trim());
						pstmt4.setString(8,  ad_bean.getAcct_dt().trim());
						pstmt4.setString(9,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						pstmt4.setString(10, ad_bean.getInsert_id().trim());
						pstmt4.executeUpdate();
					    pstmt4.close();
						data_line++;
					//�뺯-�����ޱ�(25300)
					}else{
					    pstmt5 = con1.prepareStatement(query6);
						pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt5.setInt   (2,  data_no);
						pstmt5.setInt   (3,  data_line);
						pstmt5.setString(4,  ad_bean.getNode_code().trim());
						pstmt5.setInt   (5,  ad_bean.getAmt5());
						if(pur.getTrf_st2().equals("3") || pur.getTrf_st2().equals("2") || pur.getTrf_st2().equals("7")){
							pstmt5.setString(6,  ad_bean.getVen_code5().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm5().trim());
							pstmt5.setString(8,  ad_bean.getCardno2().trim());
							pstmt5.setString(9,  ad_bean.getCardnm2().trim());
							pstmt5.setString(10,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						}else{
							pstmt5.setString(6,  ad_bean.getVen_code2().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm2().trim());
							pstmt5.setString(8,  "");
							pstmt5.setString(9,  "");
							pstmt5.setString(10,  ad_bean.getAcct_cont().trim());
						}
						pstmt5.setString(11,  ad_bean.getInsert_id().trim());
						pstmt5.executeUpdate();
					    pstmt5.close();
						data_line++;
					}
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

				if( AddUtil.parseInt(AddUtil.replace(pur.getTrf_pay_dt3(),"-","")) >20111124){
					//�뺯-���ޱ�(13100)
					if(acct_code.equals("13100")){
					    pstmt4 = con1.prepareStatement(query5);
						pstmt4.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt4.setInt   (2,  data_no);
						pstmt4.setInt   (3,  data_line);
						pstmt4.setString(4,  ad_bean.getNode_code().trim());
						pstmt4.setInt   (5,  ad_bean.getAmt6());
						pstmt4.setString(6,  ad_bean.getVen_code6().trim());
						pstmt4.setString(7,  ad_bean.getFirm_nm6().trim());
						pstmt4.setString(8,  ad_bean.getAcct_dt().trim());
						pstmt4.setString(9,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						pstmt4.setString(10, ad_bean.getInsert_id().trim());
						pstmt4.executeUpdate();
					    pstmt4.close();
						data_line++;
					}else{
					    pstmt5 = con1.prepareStatement(query6);
						pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt5.setInt   (2,  data_no);
						pstmt5.setInt   (3,  data_line);
						pstmt5.setString(4,  ad_bean.getNode_code().trim());
						pstmt5.setInt   (5,  ad_bean.getAmt6());
						if(pur.getTrf_st3().equals("3") || pur.getTrf_st3().equals("2") || pur.getTrf_st3().equals("7")){
							pstmt5.setString(6,  ad_bean.getVen_code6().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm6().trim());
							pstmt5.setString(8,  ad_bean.getCardno3().trim());
							pstmt5.setString(9,  ad_bean.getCardnm3().trim());
							pstmt5.setString(10,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						}else{
							pstmt5.setString(6,  ad_bean.getVen_code2().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm2().trim());
							pstmt5.setString(8,  "");
							pstmt5.setString(9,  "");
							pstmt5.setString(10,  ad_bean.getAcct_cont().trim());
						}
						pstmt5.setString(11,  ad_bean.getInsert_id().trim());
						pstmt5.executeUpdate();
					    pstmt5.close();
						data_line++;
					}
				}else{
					//�뺯-���ޱ�(13100)
					if(pur.getTrf_st3().equals("2") && AddUtil.parseInt(AddUtil.replace(pur.getTrf_pay_dt3(),"-","")) <= AddUtil.parseInt(AddUtil.replace(ad_bean.getWrite_dt(),"-",""))){
					    pstmt4 = con1.prepareStatement(query5);
						pstmt4.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt4.setInt   (2,  data_no);
						pstmt4.setInt   (3,  data_line);
						pstmt4.setString(4,  ad_bean.getNode_code().trim());
						pstmt4.setInt   (5,  ad_bean.getAmt6());
						pstmt4.setString(6,  ad_bean.getVen_code6().trim());
						pstmt4.setString(7,  ad_bean.getFirm_nm6().trim());
						pstmt4.setString(8,  ad_bean.getAcct_dt().trim());
						pstmt4.setString(9,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						pstmt4.setString(10, ad_bean.getInsert_id().trim());
						pstmt4.executeUpdate();
					    pstmt4.close();
						data_line++;
					//�뺯-�����ޱ�(25300)
					}else{
					    pstmt5 = con1.prepareStatement(query6);
						pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt5.setInt   (2,  data_no);
						pstmt5.setInt   (3,  data_line);
						pstmt5.setString(4,  ad_bean.getNode_code().trim());
						pstmt5.setInt   (5,  ad_bean.getAmt6());
						if(pur.getTrf_st3().equals("3") || pur.getTrf_st3().equals("2") || pur.getTrf_st3().equals("7")){
							pstmt5.setString(6,  ad_bean.getVen_code6().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm6().trim());
							pstmt5.setString(8,  ad_bean.getCardno3().trim());
							pstmt5.setString(9,  ad_bean.getCardnm3().trim());
							pstmt5.setString(10,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						}else{
							pstmt5.setString(6,  ad_bean.getVen_code2().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm2().trim());
							pstmt5.setString(8,  "");
							pstmt5.setString(9,  "");
							pstmt5.setString(10,  ad_bean.getAcct_cont().trim());
						}
						pstmt5.setString(11,  ad_bean.getInsert_id().trim());
						pstmt5.executeUpdate();
					    pstmt5.close();
						data_line++;
					}
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

				if( AddUtil.parseInt(AddUtil.replace(pur.getTrf_pay_dt4(),"-","")) >20111124){
					//�뺯-���ޱ�(13100)
					if(acct_code.equals("13100")){
					    pstmt4 = con1.prepareStatement(query5);
						pstmt4.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt4.setInt   (2,  data_no);
						pstmt4.setInt   (3,  data_line);
						pstmt4.setString(4,  ad_bean.getNode_code().trim());
						pstmt4.setInt   (5,  ad_bean.getAmt7());
						pstmt4.setString(6,  ad_bean.getVen_code7().trim());
						pstmt4.setString(7,  ad_bean.getFirm_nm7().trim());
						pstmt4.setString(8,  ad_bean.getAcct_dt().trim());
						pstmt4.setString(9,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						pstmt4.setString(10, ad_bean.getInsert_id().trim());
						pstmt4.executeUpdate();
					    pstmt4.close();
						data_line++;
					//�뺯-�����ޱ�(25300)
					}else{
					    pstmt5 = con1.prepareStatement(query6);
						pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt5.setInt   (2,  data_no);
						pstmt5.setInt   (3,  data_line);
						pstmt5.setString(4,  ad_bean.getNode_code().trim());
						pstmt5.setInt   (5,  ad_bean.getAmt7());
						if(pur.getTrf_st4().equals("3") || pur.getTrf_st4().equals("2") || pur.getTrf_st4().equals("7")){
							pstmt5.setString(6,  ad_bean.getVen_code7().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm7().trim());
							pstmt5.setString(8,  ad_bean.getCardno4().trim());
							pstmt5.setString(9,  ad_bean.getCardnm4().trim());
							pstmt5.setString(10,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						}else{
							pstmt5.setString(6,  ad_bean.getVen_code2().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm2().trim());
							pstmt5.setString(8,  "");
							pstmt5.setString(9,  "");
							pstmt5.setString(10,  ad_bean.getAcct_cont().trim());
						}
						pstmt5.setString(11,  ad_bean.getInsert_id().trim());
						pstmt5.executeUpdate();
					    pstmt5.close();
						data_line++;
					}
				}else{
					//�뺯-���ޱ�(13100)
					if(pur.getTrf_st4().equals("2") && AddUtil.parseInt(AddUtil.replace(pur.getTrf_pay_dt4(),"-","")) <= AddUtil.parseInt(AddUtil.replace(ad_bean.getWrite_dt(),"-",""))){
					    pstmt4 = con1.prepareStatement(query5);
						pstmt4.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt4.setInt   (2,  data_no);
						pstmt4.setInt   (3,  data_line);
						pstmt4.setString(4,  ad_bean.getNode_code().trim());
						pstmt4.setInt   (5,  ad_bean.getAmt7());
						pstmt4.setString(6,  ad_bean.getVen_code7().trim());
						pstmt4.setString(7,  ad_bean.getFirm_nm7().trim());
						pstmt4.setString(8,  ad_bean.getAcct_dt().trim());
						pstmt4.setString(9,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						pstmt4.setString(10, ad_bean.getInsert_id().trim());
						pstmt4.executeUpdate();
					    pstmt4.close();
						data_line++;
					//�뺯-�����ޱ�(25300)
					}else{
					    pstmt5 = con1.prepareStatement(query6);
						pstmt5.setString(1,  ad_bean.getWrite_dt().trim());
						pstmt5.setInt   (2,  data_no);
						pstmt5.setInt   (3,  data_line);
						pstmt5.setString(4,  ad_bean.getNode_code().trim());
						pstmt5.setInt   (5,  ad_bean.getAmt7());
						if(pur.getTrf_st4().equals("3") || pur.getTrf_st4().equals("2") || pur.getTrf_st4().equals("7")){
							pstmt5.setString(6,  ad_bean.getVen_code7().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm7().trim());
							pstmt5.setString(8,  ad_bean.getCardno4().trim());
							pstmt5.setString(9,  ad_bean.getCardnm4().trim());
							pstmt5.setString(10,  trf_cont+":"+ad_bean.getAcct_cont().trim());
						}else{
							pstmt5.setString(6,  ad_bean.getVen_code2().trim());
							pstmt5.setString(7,  ad_bean.getFirm_nm2().trim());
							pstmt5.setString(8,  "");
							pstmt5.setString(9,  "");
							pstmt5.setString(10,  ad_bean.getAcct_cont().trim());
						}
						pstmt5.setString(11,  ad_bean.getInsert_id().trim());
						pstmt5.executeUpdate();
					    pstmt5.close();
						data_line++;
					}
				}
			}

			rs8.close();
			pstmt8.close();

			//�ΰ���(taxrela)
			pstmt6 = con1.prepareStatement(query7);
			pstmt6.setString(1,  ad_bean.getWrite_dt().trim());
			pstmt6.setInt   (2,  data_no);
			pstmt6.setString(3,  ad_bean.getNode_code().trim());
			pstmt6.setString(4,  ad_bean.getWrite_dt().trim());
			pstmt6.setString(5,  ad_bean.getVen_type().trim());
			pstmt6.setInt   (6,  ad_bean.getAmt());
			pstmt6.setInt   (7,  ad_bean.getAmt2());
			pstmt6.setString(8,  ad_bean.getVen_code().trim());
			pstmt6.setString(9,  ad_bean.getS_idno().trim());
			pstmt6.executeUpdate();
			pstmt6.close();			

            con1.commit();
			con.commit();

		}catch(Exception se){
            try{
				count = 1;
				data_no = 0;
				System.out.println("[AddBillMngDatabase:insertCarPurAmtAutoDocu]"+se);
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
        return data_no;
    }

     /**
     *	[���] ������Աݰ��� ����������ä�������� ��ü ��ǥ
     */
    public int insertDebtSettleAutoDocu(String write_date, Vector vt) throws DatabaseException, DataSourceEmptyException{
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

        int count = 0;
        int data_no = 0;
		String table = "autodocu";
                
		query =" select nvl(max(data_no)+1,1) from "+table+" where DATA_GUBUN='53' and write_date=replace(?,'-','')";

		query2 =" insert into "+table+" ( "+
				" DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values( "+
				" ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, to_char(sysdate,'YYYYMMDD') "+
				" ) ";	

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);

			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query);
			pstmt1.setString(1, write_date);
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt1.close();	


			for(int i = 0 ; i < vt.size() ; i++){

				Hashtable ht = (Hashtable)vt.elementAt(i);

				pstmt2 = con1.prepareStatement(query2);

				pstmt2.setString(1, String.valueOf(ht.get("DATA_GUBUN")));
				pstmt2.setString(2, String.valueOf(ht.get("WRITE_DATE")));
				pstmt2.setInt   (3, data_no);
				pstmt2.setInt   (4, AddUtil.parseDigit(String.valueOf(ht.get("DATA_LINE"))));
				pstmt2.setInt   (5, AddUtil.parseDigit(String.valueOf(ht.get("DATA_SLIP"))));
				pstmt2.setString(6, String.valueOf(ht.get("DEPT_CODE")));
				pstmt2.setString(7, String.valueOf(ht.get("NODE_CODE")));
				pstmt2.setString(8, String.valueOf(ht.get("C_CODE")));
				pstmt2.setString(9, String.valueOf(ht.get("DATA_CODE")));
				pstmt2.setString(10, String.valueOf(ht.get("DOCU_STAT")));
				pstmt2.setString(11, String.valueOf(ht.get("DOCU_TYPE")));
				pstmt2.setString(12, String.valueOf(ht.get("DOCU_GUBUN")));
				pstmt2.setString(13, String.valueOf(ht.get("AMT_GUBUN")));
				pstmt2.setInt   (14, AddUtil.parseDigit(String.valueOf(ht.get("DR_AMT"))));
				pstmt2.setInt   (15, AddUtil.parseDigit(String.valueOf(ht.get("CR_AMT"))));
				pstmt2.setString(16, String.valueOf(ht.get("ACCT_CODE")));
				pstmt2.setString(17, String.valueOf(ht.get("CHECK_CODE1")));
				pstmt2.setString(18, String.valueOf(ht.get("CHECK_CODE2")));
				pstmt2.setString(19, String.valueOf(ht.get("CHECK_CODE3")));
				pstmt2.setString(20, String.valueOf(ht.get("CHECK_CODE4")));
				pstmt2.setString(21, String.valueOf(ht.get("CHECK_CODE5")));
				pstmt2.setString(22, String.valueOf(ht.get("CHECK_CODE6")));
				pstmt2.setString(23, String.valueOf(ht.get("CHECK_CODE7")));
				pstmt2.setString(24, String.valueOf(ht.get("CHECK_CODE8")));
				pstmt2.setString(25, String.valueOf(ht.get("CHECK_CODE9")));
				pstmt2.setString(26, String.valueOf(ht.get("CHECK_CODE10")));
				pstmt2.setString(27, String.valueOf(ht.get("CHECKD_CODE1")));
				pstmt2.setString(28, String.valueOf(ht.get("CHECKD_CODE2")));
				pstmt2.setString(29, String.valueOf(ht.get("CHECKD_CODE3")));
				pstmt2.setString(30, String.valueOf(ht.get("CHECKD_CODE4")));
				pstmt2.setString(31, String.valueOf(ht.get("CHECKD_CODE5")));
				pstmt2.setString(32, String.valueOf(ht.get("CHECKD_CODE6")));
				pstmt2.setString(33, String.valueOf(ht.get("CHECKD_CODE7")));
				pstmt2.setString(34, String.valueOf(ht.get("CHECKD_CODE8")));
				pstmt2.setString(35, String.valueOf(ht.get("CHECKD_CODE9")));
				pstmt2.setString(36, String.valueOf(ht.get("CHECKD_CODE10")));
				pstmt2.setString(37, String.valueOf(ht.get("CHECKD_NAME1")));
				pstmt2.setString(38, String.valueOf(ht.get("CHECKD_NAME2")));
				pstmt2.setString(39, String.valueOf(ht.get("CHECKD_NAME3")));
				pstmt2.setString(40, String.valueOf(ht.get("CHECKD_NAME4")));
				pstmt2.setString(41, String.valueOf(ht.get("CHECKD_NAME5")));
				pstmt2.setString(42, String.valueOf(ht.get("CHECKD_NAME6")));
				pstmt2.setString(43, String.valueOf(ht.get("CHECKD_NAME7")));
				pstmt2.setString(44, String.valueOf(ht.get("CHECKD_NAME8")));
				pstmt2.setString(45, String.valueOf(ht.get("CHECKD_NAME9")));
				pstmt2.setString(46, String.valueOf(ht.get("CHECKD_NAME10")));
				pstmt2.setString(47, String.valueOf(ht.get("INSERT_ID")));
				
				pstmt2.executeUpdate();
				pstmt2.close();
			}


            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertDebtSettleAutoDocu]"+se);
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
        return count;
    }
    
    
    /**
    *	��ü ��ǥ
    */
    public int insertSettleAutoDocu(String write_date, String data_gubun, Vector vt) throws DatabaseException, DataSourceEmptyException{
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

        int count = 0;
        int data_no = 0;
		String table = "autodocu";
                
		query =" select nvl(max(data_no)+1,1) from "+table+" where data_gubun = ? and write_date=replace(?,'-','')";

		query2 =" insert into "+table+" ( "+
				" DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values( "+
				" ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, to_char(sysdate,'YYYYMMDD') "+
				" ) ";	

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);

			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query);
			pstmt1.setString(1, data_gubun);
			pstmt1.setString(2, write_date);
		
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt1.close();	


			for(int i = 0 ; i < vt.size() ; i++){

				Hashtable ht = (Hashtable)vt.elementAt(i);

				pstmt2 = con1.prepareStatement(query2);

				pstmt2.setString(1, String.valueOf(ht.get("DATA_GUBUN")));
				pstmt2.setString(2, String.valueOf(ht.get("WRITE_DATE")));
				pstmt2.setInt   (3, data_no);
				pstmt2.setInt   (4, AddUtil.parseDigit(String.valueOf(ht.get("DATA_LINE"))));
				pstmt2.setInt   (5, AddUtil.parseDigit(String.valueOf(ht.get("DATA_SLIP"))));
				pstmt2.setString(6, String.valueOf(ht.get("DEPT_CODE")));
				pstmt2.setString(7, String.valueOf(ht.get("NODE_CODE")));
				pstmt2.setString(8, String.valueOf(ht.get("C_CODE")));
				pstmt2.setString(9, String.valueOf(ht.get("DATA_CODE")));
				pstmt2.setString(10, String.valueOf(ht.get("DOCU_STAT")));
				pstmt2.setString(11, String.valueOf(ht.get("DOCU_TYPE")));
				pstmt2.setString(12, String.valueOf(ht.get("DOCU_GUBUN")));
				pstmt2.setString(13, String.valueOf(ht.get("AMT_GUBUN")));
				pstmt2.setInt   (14, AddUtil.parseDigit(String.valueOf(ht.get("DR_AMT"))));
				pstmt2.setInt   (15, AddUtil.parseDigit(String.valueOf(ht.get("CR_AMT"))));
				pstmt2.setString(16, String.valueOf(ht.get("ACCT_CODE")));
				pstmt2.setString(17, String.valueOf(ht.get("CHECK_CODE1")));
				pstmt2.setString(18, String.valueOf(ht.get("CHECK_CODE2")));
				pstmt2.setString(19, String.valueOf(ht.get("CHECK_CODE3")));
				pstmt2.setString(20, String.valueOf(ht.get("CHECK_CODE4")));
				pstmt2.setString(21, String.valueOf(ht.get("CHECK_CODE5")));
				pstmt2.setString(22, String.valueOf(ht.get("CHECK_CODE6")));
				pstmt2.setString(23, String.valueOf(ht.get("CHECK_CODE7")));
				pstmt2.setString(24, String.valueOf(ht.get("CHECK_CODE8")));
				pstmt2.setString(25, String.valueOf(ht.get("CHECK_CODE9")));
				pstmt2.setString(26, String.valueOf(ht.get("CHECK_CODE10")));
				pstmt2.setString(27, String.valueOf(ht.get("CHECKD_CODE1")));
				pstmt2.setString(28, String.valueOf(ht.get("CHECKD_CODE2")));
				pstmt2.setString(29, String.valueOf(ht.get("CHECKD_CODE3")));
				pstmt2.setString(30, String.valueOf(ht.get("CHECKD_CODE4")));
				pstmt2.setString(31, String.valueOf(ht.get("CHECKD_CODE5")));
				pstmt2.setString(32, String.valueOf(ht.get("CHECKD_CODE6")));
				pstmt2.setString(33, String.valueOf(ht.get("CHECKD_CODE7")));
				pstmt2.setString(34, String.valueOf(ht.get("CHECKD_CODE8")));
				pstmt2.setString(35, String.valueOf(ht.get("CHECKD_CODE9")));
				pstmt2.setString(36, String.valueOf(ht.get("CHECKD_CODE10")));
				pstmt2.setString(37, String.valueOf(ht.get("CHECKD_NAME1")));
				pstmt2.setString(38, String.valueOf(ht.get("CHECKD_NAME2")));
				pstmt2.setString(39, String.valueOf(ht.get("CHECKD_NAME3")));
				pstmt2.setString(40, String.valueOf(ht.get("CHECKD_NAME4")));
				pstmt2.setString(41, String.valueOf(ht.get("CHECKD_NAME5")));
				pstmt2.setString(42, String.valueOf(ht.get("CHECKD_NAME6")));
				pstmt2.setString(43, String.valueOf(ht.get("CHECKD_NAME7")));
				pstmt2.setString(44, String.valueOf(ht.get("CHECKD_NAME8")));
				pstmt2.setString(45, String.valueOf(ht.get("CHECKD_NAME9")));
				pstmt2.setString(46, String.valueOf(ht.get("CHECKD_NAME10")));
				pstmt2.setString(47, String.valueOf(ht.get("INSERT_ID")));

				pstmt2.executeUpdate();
				pstmt2.close();
			}


            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertDebtSettleAutoDocu]"+se);
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
        return count;
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
//				"        and a.deposit_name not like '%����%' "+
				"        and a.deposit_name not like '%����%' "+
//				"		 and a.deposit_no not in ('172-910009-79904')"+
				"		 and a.deposit_no not in ('221-181337-31-00031')"+
				" order by decode(b.checkd_name, '����','1', '�ϳ�','2', '����','3', '9'), b.checkd_name, a.deposit_no";

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
			System.out.println("[AddBillMngDatabase:getFeeDepositList]"+se);
			System.out.println("[AddBillMngDatabase:getFeeDepositList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
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
        Connection con1 = connMgr.getConnection(DATA_SOURCE1); //neom
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " select b.checkd_name, a.* "+
				" from   depositma a, checkd b "+
				" where  a.bank_code=b.checkd_code "+
				"        and b.check_code='A03' and b.c_code = '1000' "+
				"        and a.termi_date='00000000' "+
				"		 and a.deposit_no='"+deposit_no+"'";

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
			System.out.println("[AddBillMngDatabase:getFeeDepositCase]"+se);
			System.out.println("[AddBillMngDatabase:getFeeDepositCase]"+query);
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
     *	������� ��� �׿��� ��� 
     */
    public int insertClsAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
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
                
		query1 =" select nvl(max(data_no)+1,1) from autodocu where DATA_GUBUN='21' and write_date=replace(?,'-','')";

		//���뿹��
		query2 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 1, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '3', ?, 0, '10300',"+//4
				" 'A03', 'F05', 'F10', 'A05', '',  '', '', '', '', '',"+
				" ?, ?, '', '0', '',  '', '', '', '', '',"+//5,6,
				" ?, ?, '', ?, '',  '', '', '', '', '',"+//7,8,9
				" ?, to_char(sysdate,'YYYYMMDD') )";//10
	
		//�ܻ�����
		query3 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '10800',"+//4
				" 'A07', 'A01', 'A13', 'A19', 'A05',"+
				" '', '', '', '', '',"+
				" ?,  '', '', '', '0',"+
				" '', '', '', '', '',"+//5,
				" ?,  '', '0', '', ?,"+
				" '', '', '', '', '',"+//6,7
				" ?, to_char(sysdate,'YYYYMMDD') )";//8

		//������
		query4 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '25900',"+//4
				" 'A07', 'F19', 'A19', 'A05', '',"+
				" '', '', '', '', '',"+
				" ?,  '', '', '0', '',"+
				" '', '', '', '', '',"+//5,
				" ?,  replace(?,'-',''), '', ?, '',"+
				" '', '', '', '', '',"+//6,7
				" ?, to_char(sysdate,'YYYYMMDD') )";//8

		//���뿩������ - ����
		query5 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '3', ?, 0, '31100',"+//4
				" 'A07', 'A05', '', '', '',"+
				" '', '', '', '', '',"+
				" ?,  '', '', '', '',"+
				" '', '', '', '', '',"+//5,
				" ?,  ?, '', '', '',"+
				" '', '', '', '', '',"+//6,7
				" ?, to_char(sysdate,'YYYYMMDD') )";//8
				
			//��Ʈ�����������
		query6 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '41400',"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05',"+
				" '', '', '', '', '',"+  
				" '',  '', '', '000131', '',"+
				" '', '', '', '', '',"+
				" '',  '', '', '�Ƹ���ī',?,"+ //5
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//6		
				
				//���������������
		query7 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '41800',"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05',"+
				" '', '', '', '', '',"+  
				" '',  '', '', '000131', '',"+
				" '', '', '', '', '',"+
				" '',  '', '', '�Ƹ���ī',?,"+ //5
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//6	
				
					//������
		query8 =" insert into autodocu (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '21', replace(?,'-',''), ?, 2, 1, '200', ?, '1000',"+//1,2,3
				" '', '0', '11', '3', '4', 0, ?, '93000',"+//4
				" 'A09', 'A13', 'A17', 'A07', 'A05',"+
				" '', '', '', '', '',"+  
				" '',  '', '', ?, '',"+ //5
				" '', '', '', '', '',"+
				" '',  '', '', ?, ?,"+ //6, 7
				" '', '', '', '', '',"+
				" ?, to_char(sysdate,'YYYYMMDD') )";//8							

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);

			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query1);
			pstmt1.setString(1, ad_bean.getAcct_dt().trim());
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt1.close();			

			//����-���뿹��(10300)
			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1, ad_bean.getAcct_dt().trim());
			pstmt2.setInt   (2, data_no);
			pstmt2.setString(3, ad_bean.getNode_code().trim());
			pstmt2.setInt   (4, ad_bean.getAmt());
			pstmt2.setString(5, ad_bean.getBank_code().trim());
			pstmt2.setString(6, ad_bean.getDeposit_no().trim());
			pstmt2.setString(7, ad_bean.getBank_name().trim());
			pstmt2.setString(8, ad_bean.getDeposit_no().trim());
			pstmt2.setString(9, ad_bean.getAcct_cont().trim());
			pstmt2.setString(10, ad_bean.getInsert_id().trim());
			pstmt2.executeUpdate();


			//�뺯-�ܻ�����
			if(ad_bean.getAcct_code().equals("10800")){		
				
				pstmt3 = con1.prepareStatement(query3);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, ad_bean.getNode_code().trim());
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getVen_code().trim());
				pstmt3.setString(6, ad_bean.getFirm_nm().trim());
				pstmt3.setString(7, ad_bean.getAcct_cont().trim());
				pstmt3.setString(8, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();

			//������
			}else if(ad_bean.getAcct_code().equals("25900")){

	            pstmt3 = con1.prepareStatement(query4);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim()		);
				pstmt3.setInt   (2, data_no							);
				pstmt3.setString(3, ad_bean.getNode_code().trim()	);
				pstmt3.setInt   (4, ad_bean.getAmt()				);
				pstmt3.setString(5, ad_bean.getVen_code().trim()	);
				pstmt3.setString(6, ad_bean.getFirm_nm().trim()		);
				pstmt3.setString(7, ad_bean.getAcct_dt().trim()		);
				pstmt3.setString(8, ad_bean.getAcct_cont().trim()	);
				pstmt3.setString(9, ad_bean.getInsert_id().trim()	);
				pstmt3.executeUpdate();

			//���뿩������
			}else if(ad_bean.getAcct_code().equals("31100")){

	            pstmt3 = con1.prepareStatement(query5);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, ad_bean.getNode_code().trim());
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getVen_code().trim());
				pstmt3.setString(6, ad_bean.getFirm_nm().trim());
				pstmt3.setString(7, ad_bean.getAcct_cont().trim());
				pstmt3.setString(8, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();

			//��Ʈ�����������
			}else if(ad_bean.getAcct_code().equals("41400")){

	            pstmt3 = con1.prepareStatement(query6);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, ad_bean.getNode_code().trim());
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getAcct_cont().trim());
				pstmt3.setString(6, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();
				
			//���������������
			}else if(ad_bean.getAcct_code().equals("41800")){

	            pstmt3 = con1.prepareStatement(query7);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, ad_bean.getNode_code().trim());
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getAcct_cont().trim());
				pstmt3.setString(6, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();		
			
						//������ - ���·�, ��ü����
			}else if(ad_bean.getAcct_code().equals("93000")){

	            pstmt3 = con1.prepareStatement(query8);
				pstmt3.setString(1, ad_bean.getAcct_dt().trim());
				pstmt3.setInt   (2, data_no);
				pstmt3.setString(3, ad_bean.getNode_code().trim());
				pstmt3.setInt   (4, ad_bean.getAmt());
				pstmt3.setString(5, ad_bean.getVen_code().trim());
				pstmt3.setString(6, ad_bean.getFirm_nm().trim());
				pstmt3.setString(7, ad_bean.getAcct_cont().trim());
				pstmt3.setString(8, ad_bean.getInsert_id().trim());
				pstmt3.executeUpdate();		
			}	
			

            pstmt2.close();
            pstmt3.close();
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertClsAutoDocu]"+se);
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
     *	�ڵ���ǥ
     */
    public int insertSetAutoDocu(String write_date, String data_gubun, Vector vt) throws DatabaseException, DataSourceEmptyException{
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

        int count = 0;
        int data_no = 0;
		String table = "autodocu";
        
        query =" select nvl(max(data_no)+1,1) from "+table+" where data_gubun = ? and write_date=replace(?,'-','')";         
	

		query2 =" insert into "+table+" ( "+
				" DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values( "+
				" ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), "+
				" ?, to_char(sysdate,'YYYYMMDD') "+
				" ) ";	

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);
			
				//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query);
			pstmt1.setString(1, data_gubun);
			pstmt1.setString(2, write_date);
		
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt1.close();	
			
			for(int i = 0 ; i < vt.size() ; i++){

				Hashtable ht = (Hashtable)vt.elementAt(i);

				pstmt2 = con1.prepareStatement(query2);

				pstmt2.setString(1, String.valueOf(ht.get("DATA_GUBUN")));
				pstmt2.setString(2, String.valueOf(ht.get("WRITE_DATE")));
				pstmt2.setInt   (3, data_no);
				pstmt2.setInt   (4, AddUtil.parseDigit(String.valueOf(ht.get("DATA_LINE"))));
				pstmt2.setInt   (5, AddUtil.parseDigit(String.valueOf(ht.get("DATA_SLIP"))));
				pstmt2.setString(6, String.valueOf(ht.get("DEPT_CODE")));
				pstmt2.setString(7, String.valueOf(ht.get("NODE_CODE")));
				pstmt2.setString(8, String.valueOf(ht.get("C_CODE")));
				pstmt2.setString(9, String.valueOf(ht.get("DATA_CODE")));
				pstmt2.setString(10, String.valueOf(ht.get("DOCU_STAT")));
				pstmt2.setString(11, String.valueOf(ht.get("DOCU_TYPE")));
				pstmt2.setString(12, String.valueOf(ht.get("DOCU_GUBUN")));
				pstmt2.setString(13, String.valueOf(ht.get("AMT_GUBUN")));
				pstmt2.setInt   (14, AddUtil.parseDigit(String.valueOf(ht.get("DR_AMT"))));
				pstmt2.setInt   (15, AddUtil.parseDigit(String.valueOf(ht.get("CR_AMT"))));
				pstmt2.setString(16, String.valueOf(ht.get("ACCT_CODE")));
				pstmt2.setString(17, String.valueOf(ht.get("CHECK_CODE1")));
				pstmt2.setString(18, String.valueOf(ht.get("CHECK_CODE2")));
				pstmt2.setString(19, String.valueOf(ht.get("CHECK_CODE3")));
				pstmt2.setString(20, String.valueOf(ht.get("CHECK_CODE4")));
				pstmt2.setString(21, String.valueOf(ht.get("CHECK_CODE5")));
				pstmt2.setString(22, String.valueOf(ht.get("CHECK_CODE6")));
				pstmt2.setString(23, String.valueOf(ht.get("CHECK_CODE7")));
				pstmt2.setString(24, String.valueOf(ht.get("CHECK_CODE8")));
				pstmt2.setString(25, String.valueOf(ht.get("CHECK_CODE9")));
				pstmt2.setString(26, String.valueOf(ht.get("CHECK_CODE10")));
				pstmt2.setString(27, String.valueOf(ht.get("CHECKD_CODE1")));
				pstmt2.setString(28, String.valueOf(ht.get("CHECKD_CODE2")));
				pstmt2.setString(29, String.valueOf(ht.get("CHECKD_CODE3")));
				pstmt2.setString(30, String.valueOf(ht.get("CHECKD_CODE4")));
				pstmt2.setString(31, String.valueOf(ht.get("CHECKD_CODE5")));
				pstmt2.setString(32, String.valueOf(ht.get("CHECKD_CODE6")));
				pstmt2.setString(33, String.valueOf(ht.get("CHECKD_CODE7")));
				pstmt2.setString(34, String.valueOf(ht.get("CHECKD_CODE8")));
				pstmt2.setString(35, String.valueOf(ht.get("CHECKD_CODE9")));
				pstmt2.setString(36, String.valueOf(ht.get("CHECKD_CODE10")));
				pstmt2.setString(37, String.valueOf(ht.get("CHECKD_NAME1")));
				pstmt2.setString(38, String.valueOf(ht.get("CHECKD_NAME2")));
				pstmt2.setString(39, String.valueOf(ht.get("CHECKD_NAME3")));
				pstmt2.setString(40, String.valueOf(ht.get("CHECKD_NAME4")));
				pstmt2.setString(41, String.valueOf(ht.get("CHECKD_NAME5")));
				pstmt2.setString(42, String.valueOf(ht.get("CHECKD_NAME6")));
				pstmt2.setString(43, String.valueOf(ht.get("CHECKD_NAME7")));
				pstmt2.setString(44, String.valueOf(ht.get("CHECKD_NAME8")));
				pstmt2.setString(45, String.valueOf(ht.get("CHECKD_NAME9")));
				pstmt2.setString(46, String.valueOf(ht.get("CHECKD_NAME10")));
				pstmt2.setString(47, String.valueOf(ht.get("INSERT_ID")));

				pstmt2.executeUpdate();
				pstmt2.close();
			}

            con.commit();
            con1.commit();
  

		}catch(Exception se){
            try{
				data_no = 0;
				System.out.println("[AddBillMngDatabase:insertSetAutoDocu]"+se);
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
        return data_no;
    }

	  /**
     *	�ڵ���ǥ
     */
    public int insertSetAutoDocu(String write_date, Vector vt) throws DatabaseException, DataSourceEmptyException{
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

        int count = 0;
        int data_no = 0;
		String table = "autodocu";
                
		query =" select nvl(max(data_no)+1,1) from "+table+" where data_gubun = '21' and write_date=replace(?,'-','')";

		query2 =" insert into "+table+" ( "+
				" DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values( "+
				" ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), substrb(?, 1, 98), "+
				" ?, to_char(sysdate,'YYYYMMDD') "+
				" ) ";	

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);

			//ó����ȣ �̱�
			pstmt1 = con1.prepareStatement(query);
			pstmt1.setString(1, write_date);
			rs = pstmt1.executeQuery();
			if(rs.next()){
				data_no = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt1.close();	

			for(int i = 0 ; i < vt.size() ; i++){

				Hashtable ht = (Hashtable)vt.elementAt(i);

				pstmt2 = con1.prepareStatement(query2);

				pstmt2.setString(1, String.valueOf(ht.get("DATA_GUBUN")));
				pstmt2.setString(2, String.valueOf(ht.get("WRITE_DATE")));
				pstmt2.setInt   (3, data_no);
				pstmt2.setInt   (4, AddUtil.parseDigit(String.valueOf(ht.get("DATA_LINE"))));
				pstmt2.setInt   (5, AddUtil.parseDigit(String.valueOf(ht.get("DATA_SLIP"))));
				pstmt2.setString(6, String.valueOf(ht.get("DEPT_CODE")));
				pstmt2.setString(7, String.valueOf(ht.get("NODE_CODE")));
				pstmt2.setString(8, String.valueOf(ht.get("C_CODE")));
				pstmt2.setString(9, String.valueOf(ht.get("DATA_CODE")));
				pstmt2.setString(10, String.valueOf(ht.get("DOCU_STAT")));
				pstmt2.setString(11, String.valueOf(ht.get("DOCU_TYPE")));
				pstmt2.setString(12, String.valueOf(ht.get("DOCU_GUBUN")));
				pstmt2.setString(13, String.valueOf(ht.get("AMT_GUBUN")));
				pstmt2.setInt   (14, AddUtil.parseDigit(String.valueOf(ht.get("DR_AMT"))));
				pstmt2.setInt   (15, AddUtil.parseDigit(String.valueOf(ht.get("CR_AMT"))));
				pstmt2.setString(16, String.valueOf(ht.get("ACCT_CODE")));
				pstmt2.setString(17, String.valueOf(ht.get("CHECK_CODE1")));
				pstmt2.setString(18, String.valueOf(ht.get("CHECK_CODE2")));
				pstmt2.setString(19, String.valueOf(ht.get("CHECK_CODE3")));
				pstmt2.setString(20, String.valueOf(ht.get("CHECK_CODE4")));
				pstmt2.setString(21, String.valueOf(ht.get("CHECK_CODE5")));
				pstmt2.setString(22, String.valueOf(ht.get("CHECK_CODE6")));
				pstmt2.setString(23, String.valueOf(ht.get("CHECK_CODE7")));
				pstmt2.setString(24, String.valueOf(ht.get("CHECK_CODE8")));
				pstmt2.setString(25, String.valueOf(ht.get("CHECK_CODE9")));
				pstmt2.setString(26, String.valueOf(ht.get("CHECK_CODE10")));
				pstmt2.setString(27, String.valueOf(ht.get("CHECKD_CODE1")));
				pstmt2.setString(28, String.valueOf(ht.get("CHECKD_CODE2")));
				pstmt2.setString(29, String.valueOf(ht.get("CHECKD_CODE3")));
				pstmt2.setString(30, String.valueOf(ht.get("CHECKD_CODE4")));
				pstmt2.setString(31, String.valueOf(ht.get("CHECKD_CODE5")));
				pstmt2.setString(32, String.valueOf(ht.get("CHECKD_CODE6")));
				pstmt2.setString(33, String.valueOf(ht.get("CHECKD_CODE7")));
				pstmt2.setString(34, String.valueOf(ht.get("CHECKD_CODE8")));
				pstmt2.setString(35, String.valueOf(ht.get("CHECKD_CODE9")));
				pstmt2.setString(36, String.valueOf(ht.get("CHECKD_CODE10")));
				pstmt2.setString(37, String.valueOf(ht.get("CHECKD_NAME1")));
				pstmt2.setString(38, String.valueOf(ht.get("CHECKD_NAME2")));
				pstmt2.setString(39, String.valueOf(ht.get("CHECKD_NAME3")));
				pstmt2.setString(40, String.valueOf(ht.get("CHECKD_NAME4")));
				pstmt2.setString(41, String.valueOf(ht.get("CHECKD_NAME5")));
				pstmt2.setString(42, String.valueOf(ht.get("CHECKD_NAME6")));
				pstmt2.setString(43, String.valueOf(ht.get("CHECKD_NAME7")));
				pstmt2.setString(44, String.valueOf(ht.get("CHECKD_NAME8")));
				pstmt2.setString(45, String.valueOf(ht.get("CHECKD_NAME9")));
				pstmt2.setString(46, String.valueOf(ht.get("CHECKD_NAME10")));
				pstmt2.setString(47, String.valueOf(ht.get("INSERT_ID")));

				pstmt2.executeUpdate();
				pstmt2.close();
			}

            con.commit();
            con1.commit();
  

		}catch(Exception se){
            try{
				data_no = 0;
				System.out.println("[AddBillMngDatabase:insertSetAutoDocu]"+se);
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
        return data_no;
    }


    /* �ΰ��� vector */
 
    public int insertSetTaxDocu(String write_date, int data_no, Vector vt) throws DatabaseException, DataSourceEmptyException{
        Connection con  = connMgr.getConnection(DATA_SOURCE);	//acar
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);	//neom

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
       
        PreparedStatement pstmt2 = null;
           
        String query2 = "";

        int count = 0;
      		
		query2 =" insert into taxrela"+
				" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,"+
				" DEPT_CODE, NODE_CODE, C_CODE, BAL_DATE, VEN_TYPE,"+
				" TAX_GU, GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO,"+
				" GONG_AMT2, BUL_GUBUN, JEONJA_YN )"+
				" values("+
				" '21', replace(?,'-',''), ?, ?, 1,"+//2
				" ?, ?, '1000', replace(?,'-',''), ?,"+//5
				" ?, ?, ?, ?, ?,"+//9
				" ?, '', '2' )";
				
	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);

			for(int i = 0 ; i < vt.size() ; i++){

				Hashtable ht = (Hashtable)vt.elementAt(i);

				pstmt2 = con1.prepareStatement(query2);

				pstmt2.setString(1, String.valueOf(ht.get("WRITE_DATE")));
				pstmt2.setInt   (2, data_no);
				pstmt2.setInt   (3, AddUtil.parseDigit(String.valueOf(ht.get("DATA_LINE"))));
				pstmt2.setString(4, String.valueOf(ht.get("DEPT_CODE")));
				pstmt2.setString(5, String.valueOf(ht.get("NODE_CODE")));
				pstmt2.setString(6, String.valueOf(ht.get("BAL_DATE")));
				pstmt2.setString(7, String.valueOf(ht.get("VEN_TYPE")));
				pstmt2.setString(8, String.valueOf(ht.get("TAX_GU")));
				pstmt2.setInt   (9, AddUtil.parseDigit(String.valueOf(ht.get("GONG_AMT"))));
				pstmt2.setInt   (10, AddUtil.parseDigit(String.valueOf(ht.get("TAX_VAT"))));
				pstmt2.setString(11, String.valueOf(ht.get("VEN_CODE")));
				pstmt2.setString(12, String.valueOf(ht.get("S_IDNO")));
				pstmt2.setInt   (13, AddUtil.parseDigit(String.valueOf(ht.get("GONG_AMT2"))));
					
				pstmt2.executeUpdate();
				pstmt2.close();
			}

            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertSetTaxDocu]"+se);
                con.rollback();
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
        }
        return count;
    }
 
  /* �ΰ��� vector */
 
    public int insertSetTaxDocu(String write_date, String data_gubun, int data_no, Vector vt) throws DatabaseException, DataSourceEmptyException{
        Connection con  = connMgr.getConnection(DATA_SOURCE);	//acar
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);	//neom

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
       
        PreparedStatement pstmt2 = null;
           
        String query2 = "";

        int count = 0;
      		
		query2 =" insert into taxrela"+
				" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP,"+
				" DEPT_CODE, NODE_CODE, C_CODE, BAL_DATE, VEN_TYPE,"+
				" TAX_GU, GONG_AMT, TAX_VAT, VEN_CODE, S_IDNO,"+
				" GONG_AMT2, BUL_GUBUN, JEONJA_YN )"+
				" values("+
				" ?, replace(?,'-',''), ?, ?, 1,"+//2
				" ?, ?, '1000', replace(?,'-',''), ?,"+//5
				" ?, ?, ?, ?, ?,"+//9
				" ?, '', '2' )";
				
	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);

			for(int i = 0 ; i < vt.size() ; i++){

				Hashtable ht = (Hashtable)vt.elementAt(i);

				pstmt2 = con1.prepareStatement(query2);

				pstmt2.setString(1, data_gubun);
				pstmt2.setString(2, String.valueOf(ht.get("WRITE_DATE")));
				pstmt2.setInt   (3, data_no);
				pstmt2.setInt   (4, AddUtil.parseDigit(String.valueOf(ht.get("DATA_LINE"))));
				pstmt2.setString(5, String.valueOf(ht.get("DEPT_CODE")));
				pstmt2.setString(6, String.valueOf(ht.get("NODE_CODE")));
				pstmt2.setString(7, String.valueOf(ht.get("BAL_DATE")));
				pstmt2.setString(8, String.valueOf(ht.get("VEN_TYPE")));
				pstmt2.setString(9, String.valueOf(ht.get("TAX_GU")));
				pstmt2.setInt   (10, AddUtil.parseDigit(String.valueOf(ht.get("GONG_AMT"))));
				pstmt2.setInt   (11, AddUtil.parseDigit(String.valueOf(ht.get("TAX_VAT"))));
				pstmt2.setString(12, String.valueOf(ht.get("VEN_CODE")));
				pstmt2.setString(13, String.valueOf(ht.get("S_IDNO")));
				pstmt2.setInt   (14, AddUtil.parseDigit(String.valueOf(ht.get("GONG_AMT2"))));
					
				pstmt2.executeUpdate();
				pstmt2.close();
			}

            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertSetTaxDocu]"+se);
                con.rollback();
                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                con1.setAutoCommit(true);
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
        }
        return count;
    }
 
 
   /**
     *	�ŷ�ó (�ŷ�ó�ڵ�,����ڹ�ȣ) �ߺ�üũ�ϱ�
     */
    public Hashtable getTradeCase(String cust_code) throws DatabaseException, DataSourceEmptyException{
        Connection con2 = connMgr.getConnection(DATA_SOURCE2);//neom_b(base)

        if(con2 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Hashtable ht = new Hashtable();
        String query = "";
		
        query = " SELECT * FROM trade WHERE cust_code='"+cust_code+"'";

	   try{

            pstmt = con2.prepareStatement(query);
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
				System.out.println("[AddBillMngDatabase:getTradeCase]"+se);
				 throw new DatabaseException();
	    }finally{
			try{
				if(rs != null )		rs.close();
	            if(pstmt != null)	pstmt.close();
			}catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE2, con2);
			con2 = null;
		}
	    return ht;
    }

	/**
     * �׿���-��ü����Ʈ
     */
    public TradeBean [] getBaseTradeList(String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con2 = connMgr.getConnection(DATA_SOURCE2);//neom_b(base)
		if(con2 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
        
		if (t_wd.length() > 14)	t_wd = t_wd.substring(0,14);

        query = " SELECT * "+
        		" FROM trade"+//dzais.
        		" where c_code = '1000'";
				
		query += " and cust_name||s_idno||id_no||cust_code like '%"+t_wd+"%'";

		query += " order by cust_name";

        Collection col = new ArrayList();
        try{
            pstmt = con2.prepareStatement(query);
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
			System.out.println("[AddBillMngDatabase:getBaseTradeList]"+se);
			System.out.println("[AddBillMngDatabase:getBaseTradeList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE2, con2);
			con2 = null;
        }
        return (TradeBean[])col.toArray(new TradeBean[0]);
    }
	
	/**
     * �׿���-��ü����Ʈ
     */
    public TradeBean [] getBaseTradeSidnoSearchList(String s_kd, String t_wd, String t_wd2) throws DatabaseException, DataSourceEmptyException{
        Connection con2 = connMgr.getConnection(DATA_SOURCE2);//neom_b(base)
		if(con2 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
        
		if (t_wd.length() > 14)	t_wd = t_wd.substring(0,14);

        query = " SELECT * "+
        		" FROM trade"+//dzais.
        		" where c_code = '1000'";
				
		query += " and s_idno||cust_name like '%"+t_wd+"%'";

		if(!t_wd2.equals(""))  query += " and cust_name like '%"+t_wd2+"%'";

		query += " order by s_idno, cust_name";

        Collection col = new ArrayList();
        try{
            pstmt = con2.prepareStatement(query);
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
			System.out.println("[AddBillMngDatabase:getBaseTradeSidnoSearchList]"+se);
			System.out.println("[AddBillMngDatabase:getBaseTradeSidnoSearchList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE2, con2);
			con2 = null;
        }
        return (TradeBean[])col.toArray(new TradeBean[0]);
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
				System.out.println("[AddBillMngDatabase:insertTradeHis]"+se);

				System.out.println("[AddBillMngDatabase:t_bean.getCust_code()]"+t_bean.getCust_code());
				System.out.println("[AddBillMngDatabase:t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[AddBillMngDatabase:t_bean.getCust_name()]"+t_bean.getCust_name());
				System.out.println("[AddBillMngDatabase:t_bean.getS_idno()	 ]"+t_bean.getS_idno()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getDname()	 ]"+t_bean.getDname()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getMail_no()	 ]"+t_bean.getMail_no()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getS_address()]"+t_bean.getS_address());
				System.out.println("[AddBillMngDatabase:t_bean.getId_no()	 ]"+t_bean.getId_no()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getUptae()	 ]"+t_bean.getUptae()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getJong()	 ]"+t_bean.getJong()	 );
				System.out.println("[AddBillMngDatabase:t_bean.getUser_id()	 ]"+t_bean.getUser_id()	 );

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
				System.out.println("[AddBillMngDatabase:getTradeHisCase]"+se);
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
				System.out.println("[AddBillMngDatabase:getTradeHisRegIds]"+se);
				System.out.println("[AddBillMngDatabase:getTradeHisRegIds]"+query);
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
			System.out.println("[AddBillMngDatabase:getTradeHisList]"+se);
			System.out.println("[AddBillMngDatabase:getTradeHisList]"+query);
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
     * �׿���-�ŷ�ó �ڵ� ��ȸ
     */
    public String getCustCode(String s_idno) throws DatabaseException, DataSourceEmptyException{
        Connection con2 = connMgr.getConnection(DATA_SOURCE2);
		if(con2 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		String cust_code = "";
        
        query = " SELECT cust_code FROM trade WHERE s_idno='"+s_idno+"'";

		try{

            pstmt = con2.prepareStatement(query);
            rs = pstmt.executeQuery();

            if(rs.next()){                
				cust_code = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
            pstmt.close();


        }catch(SQLException se){
			 System.out.println("[AddBillMngDatabase:getCustCode]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE2, con2);
			con2 = null;
        }
        return cust_code;
    }

	/**
     * �׿���-�ŷ�ó �ڵ� ��ȸ
     */
    public String getCustCode2(String s_idno, String cust_name) throws DatabaseException, DataSourceEmptyException{
        Connection con2 = connMgr.getConnection(DATA_SOURCE2);
		if(con2 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		String cust_code = "";
        
        query = " SELECT cust_code FROM trade WHERE s_idno='"+s_idno+"' and cust_name='"+cust_name+"'";

		try{

            pstmt = con2.prepareStatement(query);
            rs = pstmt.executeQuery();

            if(rs.next()){                
				cust_code = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
            pstmt.close();


        }catch(SQLException se){
			 System.out.println("[AddBillMngDatabase:getCustCode2]"+se);
			 System.out.println("[AddBillMngDatabase:getCustCode2]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE2, con2);
			con2 = null;
        }
        return cust_code;
    }

	/**
     * �׿���-���� ��ȸ
     */
    public Hashtable getBankCase(String bank_code) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//dzais.
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " SELECT * FROM checkd where check_code='A03'  and c_code = '1000' and checkd_code='"+bank_code+"'";

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
			System.out.println("[AddBillMngDatabase:getBankCase]"+se);
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

    /* ī���� */
 
    public int insertCardmana(CardBean c_bean, Hashtable per, Hashtable br) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);	//neom

        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
       
        PreparedStatement pstmt2 = null;
           
        String query2 = "";

        int count = 0;
      		
		query2 =" insert into CARDMANA "+
				" ("+
				"        CARDNO, C_CODE, CARD_NAME, S_IDNO, CARD_TYPE, "+
			    "        CARD_GU, CARD_SDATE, CARD_EDATE, SA_CODE, ETC, "+
				"        CREDIT_COM, VEN_CODE, TERM_START, SETTING_MON, SETTING_DAY, "+
				"        DEPOSIT_NO, DEPT_CODE"+
				" )"+
				" values("+
				"        ?, '1000', ?, replace(?,'-',''), ?, "+
				"        ?, replace(?,'-',''), replace(?,'-',''), ?, ?, "+
				"        ?, ?, ?, ?, ?, "+
				"        ?, ? "+
				" )";

		String insert_id = String.valueOf(per.get("SA_CODE"));
		String dept_code = String.valueOf(per.get("DEPT_CODE"));
		String node_code = String.valueOf(per.get("NODE_CODE"));
		String br_idno	 = String.valueOf(br.get("BR_ENT_NO"));

				
	   try{

            con1.setAutoCommit(false);

			pstmt2 = con1.prepareStatement(query2);
			pstmt2.setString(1,  c_bean.getCardno		());
			pstmt2.setString(2,  c_bean.getCard_name	());
			pstmt2.setString(3,  br_idno				  );
			pstmt2.setString(4,  c_bean.getCard_type	());
			pstmt2.setString(5,  "1"                      );
			pstmt2.setString(6,  c_bean.getCard_sdate	());
			pstmt2.setString(7,  c_bean.getCard_edate	());
			pstmt2.setString(8,  insert_id                );
			pstmt2.setString(9,  AddUtil.substringb(c_bean.getEtc(),30));
			pstmt2.setString(10, ""                       );
			pstmt2.setString(11, c_bean.getCom_code		());
			pstmt2.setString(12, ""                       );
			pstmt2.setString(13, ""                       );
			pstmt2.setString(14, ""                       );
			pstmt2.setString(15, c_bean.getAcc_no		());
			pstmt2.setString(16, dept_code                );
				
			pstmt2.executeUpdate();
			pstmt2.close();

            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertCardmana]"+se);
				System.out.println("[c_bean.getCardno		()]"+c_bean.getCardno		());
				System.out.println("[c_bean.getCard_name	()]"+c_bean.getCard_name	());
				System.out.println("[br_idno				  ]"+br_idno				  );
				System.out.println("[c_bean.getCard_type	()]"+c_bean.getCard_type	());
				System.out.println("[c_bean.getCard_sdate	()]"+c_bean.getCard_sdate	());
				System.out.println("[c_bean.getCard_edate	()]"+c_bean.getCard_edate	());
				System.out.println("[insert_id                ]"+insert_id                );
				System.out.println("[c_bean.getEtc			()]"+c_bean.getEtc			());
				System.out.println("[c_bean.getCom_code		()]"+c_bean.getCom_code		());
				System.out.println("[c_bean.getAcc_no		()]"+c_bean.getAcc_no		());
				System.out.println("[dept_code                ]"+dept_code                );

                con1.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{

                con1.setAutoCommit(true);
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return count;
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
        
        query = " SELECT * FROM vendor  ";
		
		if(!ven_code.equals(""))	query += " WHERE ven_code='"+ven_code+"'";
		if(!s_idno.equals(""))		query += " WHERE s_idno=replace('"+s_idno+"','-','')";

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
			System.out.println("[AddBillMngDatabase:getVendorCaseS]"+se);
			System.out.println("[AddBillMngDatabase:getVendorCaseS]"+query);
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
	        query = " SELECT ven_code FROM vendor WHERE ven_name like '%"+cust_name+"%' and id_no='"+ssn+"'";
		}else{//����
	        query = " SELECT ven_code FROM vendor WHERE ven_name like '%"+cust_name+"%' and s_idno='"+enp_no+"'";
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
			 System.out.println("[AddBillMngDatabase:getVenCodeChk]"+se);
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
     * �׿���-���������̸�
     */
    public Hashtable getAcctCodeNm(String acct_code) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1); //neom
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " select acct_name, acct_name2 "+
				" from   acctcode "+
				" where  c_code = '1000' "+
				"		 and acct_code='"+acct_code+"'";

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
			System.out.println("[AddBillMngDatabase:getAcctCodeNm]"+se);
			System.out.println("[AddBillMngDatabase:getAcctCodeNm]"+query);
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
     *	�����̳� ȯ�� ��ǥ
     */
    public int insertFineAutoDocu(AutoDocuBean ad_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

     	PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs = null;   
      
        String query = "";
        String query1 = "";
        String query2 = "";
        String query3 = "";
        String query4 = "";
                        
        String node_code = "";
         	
        int count = 0;
        int i = 0;
        
		String table = "autodocu";
                
		query =" select nvl(max(data_line),0) from "+table+" where data_gubun= '51' and write_date=replace(?,'-','') and data_no = ? ";
	
				
		// ���·�-�뺯
		query1 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '400', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, '12400',"+//4
				" 'A07', 'S01', 'A05', '', '', '', '', '', '', '',"+
				" ?, '', '0',  '', '', '', '', '', '', '', "+
				" ?, '', ?, '', '', '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9
						
				
		//������ - ����
		query4 =" insert into "+table+" (DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE,"+
				" DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE,"+
				" CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10,"+
				" CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10,"+
				" CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10,"+
				" INSERT_ID, INSERT_DATE)\n"+
				" values("+
				" '51', replace(?,'-',''), ?, ?, 1, '400', ?, '1000',"+//1,2,3 =>�ڷᱸ��:��Ÿ(53), 1������
				" '', '0', '11', '3', '3', ?, 0, '25700',"+//4
				" 'A07', 'A19', 'A05', '', '', '', '', '', '', '',"+
				" ?, '', '0',  '', '', '', '', '', '', '', "+
				" ?, '', ?, '', '', '', '', '', '', '',"+//8
				" ?, to_char(sysdate,'YYYYMMDD') )";//9

	   try{

            con.setAutoCommit(false);
            con1.setAutoCommit(false);
            
             
            	   	//ó������ �̱�
			pstmt = con1.prepareStatement(query);
			pstmt.setString(1, ad_bean.getAcct_dt().trim());
			pstmt.setInt   (2, ad_bean.getData_no());
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				i = Util.parseInt(rs.getString(1).trim());
			}
			rs.close();
			pstmt.close(); 
                        
           	node_code = "S101";
                                			
			if ( ad_bean.getVen_type().equals("F"))  {  //����
				
				if ( ad_bean.getAmt() > 0 ) {
					
				
					//����-������ �ִ� ���	- ������ ���̳ʽ��ΰ�쵵 �ִ��� 20110107		    
					i++;     
					pstmt1 = con1.prepareStatement(query1);
					pstmt1.setString(1, ad_bean.getAcct_dt().trim());
					pstmt1.setInt   (2, ad_bean.getData_no());
					pstmt1.setInt	(3, i);
					pstmt1.setString(4, node_code);
					pstmt1.setInt   (5, ad_bean.getAmt()* (-1));	
					pstmt1.setString(6, ad_bean.getVen_code());				
					pstmt1.setString(7, ad_bean.getFirm_nm());
					pstmt1.setString(8, ad_bean.getAcct_cont().trim());
					pstmt1.setString(9, ad_bean.getInsert_id().trim());
					pstmt1.executeUpdate();
				    pstmt1.close();
				}		
			
			
			} else {
				         	        					
				if ( ad_bean.getAmt() > 0 ) {
					
					//����-������		    
					i++;     
					pstmt2 = con1.prepareStatement(query4);
					pstmt2.setString(1, ad_bean.getAcct_dt().trim());
					pstmt2.setInt   (2, ad_bean.getData_no());
					pstmt2.setInt	(3, i);
					pstmt2.setString(4, node_code);
					pstmt2.setInt   (5, ad_bean.getAmt());
				    pstmt2.setString(6, ad_bean.getVen_code());
				    pstmt2.setString(7, ad_bean.getFirm_nm());
					pstmt2.setString(8, ad_bean.getAcct_cont().trim());
					pstmt2.setString(9, ad_bean.getInsert_id().trim());
					pstmt2.executeUpdate();
				    pstmt2.close();
				}		
		
			}
      
            con.commit();
            con1.commit();

		}catch(Exception se){
            try{
				count = 1;
				System.out.println("[AddBillMngDatabase:insertFineAutoDocu]"+se);
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
         
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con = null;
			con1 = null;
        }
        return count;
    }
    
}
