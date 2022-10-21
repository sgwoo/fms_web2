package acar.bill_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class BillMngDatabase
{
	private static BillMngDatabase instance;
	private Connection conn = null;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar";
    private final String DATA_SOURCE1 = "neom"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
	//public static synchronized BillMngDatabase getInstance() throws DatabaseException {
		public static synchronized BillMngDatabase getInstance() {
        if (instance == null)
            instance = new BillMngDatabase();
        return instance;
    }
    
    //private BillMngDatabase() throws DatabaseException {
    	private BillMngDatabase()  {
        connMgr = DBConnectionManager.getInstance();
    }
	
	
	/** 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드********************************************/
	
	/**
     * 중도해지 현황 리스트 ( 2001/12/28 ) - Kim JungTae
     */
    
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

	public String getValidDt(String dt) throws DatabaseException, DataSourceEmptyException
	{	
		Connection conn = connMgr.getConnection(DATA_SOURCE);
		if(conn == null)
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
						" '일', to_char(to_date(?, 'YYYY-MM-DD')-1, 'YYYY-MM-DD'), 'N')"+
						" from dual";
			try{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, sysdate);
				pstmt.setString(2, sysdate);
		    	rs = pstmt.executeQuery();
				while(rs.next())
				{
					rtnStr = rs.getString(1)==null?"":rs.getString(1);
				}

				if(!rtnStr.equals("N"))	/* 일요일인경우 하루를 더해준다 */
					sysdate = rtnStr;

				c_sysdate = sysdate;

				if(!c_sysdate.equals(sysdate))	/* 요일체크로 리턴된 날짜가 원래의 날짜와 다르다면 */
					sysdate = c_sysdate;
				else
					s_flag = true;
			
				if(s_flag && h_flag)	return sysdate;

				query = "select decode(count(*), 0, 'N', to_char(to_date(?, 'YYYY-MM-DD')-1, 'YYYY-MM-DD')) "+
					" from holiday "+
					" where hday = replace(?, '-', '')";

				while(!flag)
				{
					pstmt1 = conn.prepareStatement(query);
					pstmt1.setString(1, sysdate);
					pstmt1.setString(2, sysdate);
			    	rs = pstmt1.executeQuery();
					while(rs.next())
					{
						rtnStr = rs.getString(1)==null?"":rs.getString(1);
					}
					if(!rtnStr.equals("N"))	sysdate = rtnStr;		/* 휴일인경우 하루를 더하고 다시 한번 휴일인지 확인 */
					else					flag = true;		/*  휴일이 아닌경우 loop를 빠져나온다. */
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
					rs.close();
					pstmt.close();
					pstmt1.close();
				}catch(Exception ignore){}
				connMgr.freeConnection(DATA_SOURCE, conn);
				conn = null;
			}
			if(!c_sysdate.equals(sysdate))	/*휴일테크로 리턴된 날짜가 원래의 날짜와 다르다면 */
				sysdate = c_sysdate;
			else
				h_flag = true;
		}
		return sysdate;
	}
	
	/**
	 *	args로 넘어온 날짜가 휴일인경우 하루씩 더해서 가장 가까운 평일날짜를 리턴
	 */
	
	private String checkHday(String dt)
	{
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
				if(!rtnStr.equals("N"))	sysdate = rtnStr;		/* 휴일인경우 하루를 더하고 다시 한번 휴일인지 확인 */
				else					flag = true;		/*  휴일이 아닌경우 loop를 빠져나온다. */
			}
		}catch (SQLException e)
		{
	  		e.printStackTrace();
		}
		finally
		{
			try
			{
				rs.close();
				pstmt.close();
			}catch(Exception ignore){}
			return sysdate;
		}
	}
	/**
     * 계약 현황 조회 ( 2002/1/3 ) - Kim JungTae
     */
    public BillMngBean [] getBillAll(String dt,String ref_dt1,String ref_dt2, String gubun, String gubun_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        String sh_query = "";
        String gubun_query = "";        
        String query = "";
        
        /* 기간 */
        if(dt.equals("1")){
        	sub_query = "and f.fee_est_dt=to_char(sysdate,'YYYYMMDD')\n";
        	sh_query = "where hday=to_char(sysdate,'YYYYMMDD')\n";
        }else if(dt.equals("2")){
        	sub_query = "and f.fee_est_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        	sh_query = "where hday like to_char(sysdate,'YYYYMM')||'%'\n";
        }else if(dt.equals("3")){
        	sub_query = "and f.fee_est_dt like to_char(sysdate,'YYYY')||'%'\n";
        	sh_query = "where hday like to_char(sysdate,'YYYY')||'%'\n";
        }else if(dt.equals("4")){
        	sub_query = "and f.fee_est_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
        	sh_query = "where hday between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
        }else{
        	sub_query = "";
        }

        if(gubun.equals("firm_nm"))
        {
        	gubun_query = "and c.firm_nm like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("client_nm")){
        	gubun_query = "and c.client_nm like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("bus_itm")){
        	gubun_query = "and c.bus_itm like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("bus_cdt")){
        	gubun_query = "and c.bus_cdt like '%" + gubun_nm + "%'\n";
        }else if(gubun.equals("enp_no")){
        	gubun_query = "and c.enp_no like '%" + gubun_nm + "%'\n";
        }else{
        	gubun_query = "";
        }
        
		query = "select	a.tax_kd as TAX_KD, a.brch_id as BRCH_ID,a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD,a.client_id as CLIENT_ID,a.car_no as CAR_NO,a.ven_code as VEN_CODE,a.client_st as CLIENT_ST,a.bus_cdt as BUS_CDT, a.bus_itm as BUS_ITM,a.enp_no as ENP_NO,a.client_nm as CLIENT_NM, a.firm_nm as FIRM_NM,a.rent_st as RENT_ST,a.fee_tm as FEE_TM, a.tm_st1 as TM_ST1, a.fee_s_amt as FEE_S_AMT, a.fee_v_amt as FEE_V_AMT,a.fee_s_amt+a.fee_v_amt as FEE_T_AMT,a.reg_dt as REG_DT,a.tax_gubun as TAX_GUBUN,to_char(nvl(b.dx, a.dt),'YYYY-MM-DD') FEE_EST_DT\n"
				+ "from (select '1' as TAX_KD, a.brch_id as BRCH_ID,a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD,a.client_id as CLIENT_ID,b.car_no as CAR_NO,h.ven_code as VEN_CODE,decode(c.client_st,'1','0','1') as CLIENT_ST,c.bus_cdt as BUS_CDT, c.bus_itm as BUS_ITM,decode(c.client_st,'1',c.enp_no,c.ssn) as ENP_NO,c.client_nm as CLIENT_NM, nvl(c.firm_nm,c.client_nm) as FIRM_NM,f.rent_st as RENT_ST,f.fee_est_dt as dt,f.fee_tm as FEE_TM, f.tm_st1 as TM_ST1, f.fee_s_amt as FEE_S_AMT, f.fee_v_amt as FEE_V_AMT,f.fee_s_amt+f.fee_v_amt as FEE_T_AMT,nvl2(g.reg_dt,substr(g.reg_dt,1,4)||'-'||substr(g.reg_dt,5,2)||'-'||substr(g.reg_dt,7,2),'') as REG_DT,nvl2(g.tax_id,'발행','미발행') as TAX_GUBUN\n"
				+ "from cont a, car_reg b, client c, fee d, scd_fee f, tax g, dzais.vendor h\n"
				+ "where a.rent_mng_id like '%' and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.brch_id like '%' and a.car_mng_id = b.car_mng_id(+) and a.client_id = c.client_id\n"
				+ gubun_query
				+ "and h.ven_name = nvl(c.firm_nm,c.client_nm) and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and d.rent_mng_id = f.rent_mng_id and d.rent_l_cd = f.rent_l_cd and d.rent_st = f.rent_st\n"
				+ sub_query
				+ "and f.tm_st1='0' and f.rent_mng_id = g.rent_mng_id(+) and f.rent_l_cd = g.rent_l_cd(+) and f.rent_st = g.rent_st(+) and f.fee_tm = g.fee_tm(+) and f.tm_st1 = g.tm_st1(+) ) a,\n"
				+ "(select a.dt from_dt,b.dt to_dt,decode(mod(a.rnum, 2), 1, to_date(null), a.dt - 1) dx\n" 
				+ "from (select rownum rnum, to_date(dt, 'yyyymmdd') dt \n"
				+ "from ((select '00010101' dt from dual) UNION (select to_char(to_date(hday, 'yyyymmdd')+1, 'yyyymmdd') dt from shday a\n"
				+ sh_query
				+ "minus select hday from shday a\n"
				+ sh_query
				+ ") UNION (select dt from (select hday as dt from shday a\n"
				+ sh_query
				+ "minus select to_char(to_date(hday, 'yyyymmdd')+1, 'yyyymmdd') dt from shday a\n"
				+ sh_query
				+ ")))) a,\n"
				+ "(select rownum rnum, to_date(dt, 'yyyymmdd') dt	from ((select to_char(to_date(hday, 'yyyymmdd')-1, 'yyyymmdd') dt from shday a\n"
				+ sh_query
				+ "minus select hday from shday a\n"
				+ sh_query
				+ ") UNION	(select dt from	(select hday as dt from shday a\n"
				+ sh_query
				+ "minus select to_char(to_date(hday, 'yyyymmdd')-1, 'yyyymmdd') dt from shday a\n"
				+ sh_query
				+ ")) UNION (select '99991231' from dual))) b where	a.rnum = b.rnum) b\n"
				+ "where	to_date(a.dt, 'yyyymmdd') between b.from_dt and b.to_dt\n"
				+ "order by a.firm_nm, a.rent_mng_id, a.rent_l_cd,to_number(a.fee_tm), to_number(a.tm_st1)\n";

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

    /**
     *	세금계산서 등록 
     */
    public int insertTax(TaxBean [] tb_r, String neom) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        if(con1 == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmtr = null;
        PreparedStatement pstmta_1 = null;
        PreparedStatement pstmta_2 = null;
        PreparedStatement pstmta_3 = null;
        PreparedStatement pstmt2 = null;
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

		n_queryr = "select nvl(max(data_no)+1,1) from autodocu where write_date=replace(?,'-','')";

		n_querya_1 = "insert into autodocu(DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE, DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE, CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10, CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10, CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10, INSERT_ID, INSERT_DATE, MODIFY_ID, MODIFY_DATE)\n"
					+ "values('21',replace(?,'-',''),?,1,1,'200',?,'1000','','0','11','3','3',?,0,'10800','A07','A01','A13','A19','A05','','','','','',?,'','','','0','','','','','',?,'','','',?,'','','','','','2000007',to_char(sysdate,'YYYYMMDD'),'','')";

		n_querya_2 = "insert into autodocu(DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE, DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE, CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10, CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10, CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10, INSERT_ID, INSERT_DATE, MODIFY_ID, MODIFY_DATE)\n"
					+ "values('21',replace(?,'-',''),?,2,1,'200',?,'1000','','0','11','3','4',0,?,'41200','A09','A13','A17','A07','A05','','','','','','','','',?,'','','','','','','','','',?,?,'','','','','','2000007',to_char(sysdate,'YYYYMMDD'),'','')";

		n_querya_3 = "insert into autodocu(DATA_GUBUN, WRITE_DATE, DATA_NO, DATA_LINE, DATA_SLIP, DEPT_CODE, NODE_CODE, C_CODE, DATA_CODE, DOCU_STAT, DOCU_TYPE, DOCU_GUBUN, AMT_GUBUN, DR_AMT, CR_AMT, ACCT_CODE, CHECK_CODE1, CHECK_CODE2, CHECK_CODE3, CHECK_CODE4, CHECK_CODE5, CHECK_CODE6, CHECK_CODE7, CHECK_CODE8, CHECK_CODE9, CHECK_CODE10, CHECKD_CODE1, CHECKD_CODE2, CHECKD_CODE3, CHECKD_CODE4, CHECKD_CODE5, CHECKD_CODE6, CHECKD_CODE7, CHECKD_CODE8, CHECKD_CODE9, CHECKD_CODE10, CHECKD_NAME1, CHECKD_NAME2, CHECKD_NAME3, CHECKD_NAME4, CHECKD_NAME5, CHECKD_NAME6, CHECKD_NAME7, CHECKD_NAME8, CHECKD_NAME9, CHECKD_NAME10, INSERT_ID, INSERT_DATE, MODIFY_ID, MODIFY_DATE)\n"
					+ "values('21',replace(?,'-',''),?,3,1,'200',?,'1000','','0','11','3','4',0,?,'25500','A07','T01','F19','T03','F45','A05','','','','',?,'11','','','',?,'','','','',?,'과세(매출)',replace(?,'-',''),?,'',?,'','','','','2000007',to_char(sysdate,'YYYYMMDD'),'','')";
        
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
	                pstmt.setInt(9, tb.getSup_amt());
	                pstmt.setInt(10, tb.getAdd_amt());
	                pstmt.setInt(11, tb.getTot_amt());
	                
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

					/*합계*/
					pstmta_1.setString(1, tb.getIss_dt().trim());
					pstmta_1.setInt(2, data_no);
					pstmta_1.setString(3, tb.getBrch_id().trim()+"01");
					pstmta_1.setInt(4, tb.getTot_amt());
					pstmta_1.setString(5, tb.getVen_code().trim());
					pstmta_1.setString(6, tb.getFirm_nm().trim());
					pstmta_1.setString(7, "대여료(" + tb.getFee_tm().trim() + "회차 " + tb.getCar_no().trim() + " " + tb.getFirm_nm().trim() + ")");
	
	                pstmta_1.executeUpdate();
	                
	                pstmta_2.setString(1, tb.getIss_dt().trim());
					pstmta_2.setInt(2, data_no);
					pstmta_2.setString(3, tb.getBrch_id().trim()+"01");
					pstmta_2.setInt(4, tb.getSup_amt());
					pstmta_2.setString(5, tb.getVen_code().trim());
					pstmta_2.setString(6, tb.getFirm_nm().trim());
					pstmta_2.setString(7, "대여료(" + tb.getFee_tm().trim() + "회차 " + tb.getCar_no().trim() + " " + tb.getFirm_nm().trim() + ")");
	
	                pstmta_2.executeUpdate();
	               
	                pstmta_3.setString(1, tb.getIss_dt().trim());
					pstmta_3.setInt(2, data_no);
					pstmta_3.setString(3, tb.getBrch_id().trim()+"01");
					pstmta_3.setInt(4, tb.getAdd_amt());
					pstmta_3.setString(5, tb.getVen_code().trim());
					pstmta_3.setString(6, "0");
					pstmta_3.setString(7, tb.getFirm_nm().trim());
					pstmta_3.setString(8, tb.getIss_dt().trim());
					pstmta_3.setInt(9, tb.getSup_amt());
					pstmta_3.setString(10, "대여료(" + tb.getFee_tm().trim() + "회차 " + tb.getCar_no().trim() + " " + tb.getFirm_nm().trim() + ")");
	
	                pstmta_3.executeUpdate();
	                
	                pstmt2.setString(1, tb.getIss_dt().trim());
					pstmt2.setInt(2, data_no);
					pstmt2.setString(3, tb.getBrch_id().trim()+"01");
					pstmt2.setString(4, tb.getIss_dt().trim());
					pstmt2.setString(5, tb.getClient_st().trim());//법인0,개인1
					pstmt2.setInt(6, tb.getSup_amt());
					pstmt2.setInt(7, tb.getAdd_amt());
					pstmt2.setString(8, tb.getVen_code().trim());//회사관리코드
					pstmt2.setString(9, tb.getEnp_no().trim());// 법인_사업자번호,개인_주님등록번호

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
	                pstmt.setInt(9, tb.getSup_amt());
	                pstmt.setInt(10, tb.getAdd_amt());
	                pstmt.setInt(11, tb.getTot_amt());
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
	                	
	                	neom_iss_dt = tb.getIss_dt().trim();
				        neom_brch_id = tb.getBrch_id().trim();
				        neom_ven_code = tb.getVen_code().trim();
				        neom_firm_nm = tb.getFirm_nm();
				        neom_enp_no = tb.getEnp_no();
				        neom_client_st = tb.getClient_st();
				    }
        
	                count = pstmt.executeUpdate()+count;
	                
	            }

	            pstmta_1 = con1.prepareStatement(n_querya_1);
	            pstmta_2 = con1.prepareStatement(n_querya_2);
	            pstmta_3 = con1.prepareStatement(n_querya_3);
	            pstmt2 = con1.prepareStatement(n_query2);
			   
                
				/*합계*/
				pstmta_1.setString(1, neom_iss_dt.trim());
				pstmta_1.setInt(2, data_no);
				pstmta_1.setString(3, neom_brch_id.trim()+"01");
				pstmta_1.setInt(4, neom_tot_amt);
				pstmta_1.setString(5, neom_ven_code.trim());
				pstmta_1.setString(6, neom_firm_nm.trim());
				pstmta_1.setString(7, "대여료(" + neom_car_no.trim().substring(1) + " " + neom_firm_nm.trim() + ")");

                pstmta_1.executeUpdate();
                
                pstmta_2.setString(1, neom_iss_dt.trim());
				pstmta_2.setInt(2, data_no);
				pstmta_2.setString(3, neom_brch_id.trim()+"01");
				pstmta_2.setInt(4, neom_sup_amt);
				pstmta_2.setString(5, neom_ven_code.trim());
				pstmta_2.setString(6, neom_firm_nm.trim());
				pstmta_2.setString(7, "대여료(" + neom_car_no.trim().substring(1) + " " + neom_firm_nm.trim() + ")");

                pstmta_2.executeUpdate();
               
                pstmta_3.setString(1, neom_iss_dt.trim());
				pstmta_3.setInt(2, data_no);
				pstmta_3.setString(3, neom_brch_id.trim()+"01");
				pstmta_3.setInt(4, neom_add_amt);
				pstmta_3.setString(5, neom_ven_code.trim());
				pstmta_3.setString(6, "0");
				pstmta_3.setString(7, neom_firm_nm.trim());
				pstmta_3.setString(8, neom_iss_dt.trim());
				pstmta_3.setInt(9, neom_sup_amt);
				pstmta_3.setString(10, "대여료(" + neom_car_no.trim().substring(1) + " " + neom_firm_nm.trim() + ")");

                pstmta_3.executeUpdate();
                
                pstmt2.setString(1, neom_iss_dt.trim());
				pstmt2.setInt(2, data_no);
				pstmt2.setString(3, neom_brch_id.trim()+"01");
				pstmt2.setString(4, neom_iss_dt.trim());
				pstmt2.setString(5, neom_client_st.trim());//법인0,개인1
				pstmt2.setInt(6, neom_sup_amt);
				pstmt2.setInt(7, neom_add_amt);
				pstmt2.setString(8, neom_ven_code.trim());//회사관리코드
				pstmt2.setString(9, neom_enp_no.trim());// 법인_사업자번호,개인_주님등록번호

                pstmt2.executeUpdate();
	

	            pstmta_1.close();
	            pstmta_2.close();
	            pstmta_3.close();
	            pstmt2.close();
	            pstmt.close();
	            con.commit();
	            con1.commit();
        	}
        }catch(SQLException se){
            try{
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
                if(pstmtr != null) pstmtr.close();
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
}
