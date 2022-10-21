package tax;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.fee.*;

public class ScdMngDatabase
{
	private Connection conn = null;
	public static ScdMngDatabase db;
	
	public static ScdMngDatabase getInstance()
	{
		if(ScdMngDatabase.db == null)
			ScdMngDatabase.db = new ScdMngDatabase();
		return ScdMngDatabase.db;	
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("acar");
	    }catch(Exception e){
	    	System.out.println(" i can't get a connection........");
	    }
	}
	
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("acar", conn);
			conn = null;
		}		
	}

	/**
	 *	발행스케줄관리 : 거래처상세내용 - 상단(계약,고객,차량,대여사항)
	 */	
	public LongRentBean getScdMngLongRentInfo(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		LongRentBean bean = new LongRentBean();
		String query = "";

		query = " select"+ 
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, a.bus_id2, a.p_zip, a.p_addr, a.tax_agnt, a.use_yn,"+ 
				"        decode(a.tax_type, '2','지점','3','현장','본사') tax_type,"+ 
				"        a.car_st, a.car_gu as car_type, nvl(b.car_no,k.car_no) car_no, nvl(b.car_nm,k.car_nm) car_nm, "+
				"        decode(nvl(b.car_use,k.car_use),'',decode(a.car_st,'1','1','3','2','1'),nvl(b.car_use,k.car_use)) car_use, "+
				"        b.init_reg_dt, i.car_name, "+ 
				"        c.firm_nm, c.client_nm, d.r_site as site_nm,"+ 
				"        decode(c.print_st,'3',d.ven_code,c.ven_code) ven_code,"+ 
				"        decode(c.print_st,'2','거래처통합','3','지점통합','4','현장통합','계약건별') print_st,"+ 
				"        e.cms_bank, e.cms_start_dt, e.cms_end_dt, e.cms_day,"+ 
				"        f.con_mon, f.fee_amt, f.rent_start_dt, f.rent_end_dt,"+ 
				"        j.rent_way, j.leave_day, j.prv_mon_yn, nvl(j.br_id,'S1') br_id, nvl(g.br_nm,'본사') br_nm, i.jg_code, i.s_st, c.M_TEL "+ 
				" from   cont a, car_reg b, client c, client_site d, cms_mng e,"+ 
				"        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, "+
				"                sum(fee_s_amt+fee_v_amt) fee_amt, sum(con_mon) con_mon, min(nvl(rent_start_dt,'00000000')) rent_start_dt, max(nvl(rent_end_dt,'99999999')) rent_end_dt "+
				"         from fee group by rent_mng_id, rent_l_cd) f,"+ 
				"        branch g, car_etc h, car_nm i, fee j,"+
				"        (select aa.*, bb.car_nm, bb.car_use from taecha aa, car_reg bb where aa.no='0' and aa.car_mng_id=bb.car_mng_id) k"+ 
				" where "+ 
				"        a.rent_l_cd='"+rent_l_cd+"' and a.car_mng_id=b.car_mng_id(+)"+ 
				"        and a.client_id=c.client_id"+ 
				"        and a.client_id=d.client_id(+) and a.r_site=d.seq(+)"+ 
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+ 
				"        and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd"+
				"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd"+
				"        and h.car_id=i.car_id and h.car_seq=i.car_seq"+
				"        and f.rent_mng_id=j.rent_mng_id and f.rent_l_cd=j.rent_l_cd and f.rent_st=j.rent_st"+
				"        and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+)"+
				"        and nvl(j.br_id,'S1')=g.br_id(+)"+
				" ";

		if(!rent_mng_id.equals("")) query += " and a.rent_mng_id='"+rent_mng_id+"'";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setRent_mng_id		(rs.getString("rent_mng_id"		)==null?"":rs.getString("rent_mng_id"	));
				bean.setRent_l_cd		(rs.getString("rent_l_cd"		)==null?"":rs.getString("rent_l_cd"		));
				bean.setCar_mng_id		(rs.getString("car_mng_id"		)==null?"":rs.getString("car_mng_id"	));
				bean.setClient_id		(rs.getString("client_id"		)==null?"":rs.getString("client_id"		));
				bean.setSite_id			(rs.getString("site_id"			)==null?"":rs.getString("site_id"		));
				bean.setCar_type		(rs.getString("car_type"		)==null?"":rs.getString("car_type"		));
				bean.setBr_id			(rs.getString("br_id"			)==null?"":rs.getString("br_id"			));
				bean.setBus_id2			(rs.getString("bus_id2"			)==null?"":rs.getString("bus_id2"		));
				bean.setP_zip			(rs.getString("p_zip"			)==null?"":rs.getString("p_zip"			));
				bean.setP_addr			(rs.getString("p_addr"			)==null?"":rs.getString("p_addr"		));
				bean.setUse_yn			(rs.getString("use_yn"			)==null?"":rs.getString("use_yn"		));
				bean.setTax_agnt		(rs.getString("tax_agnt"		)==null?"":rs.getString("tax_agnt"		));
				bean.setTax_type		(rs.getString("tax_type"		)==null?"":rs.getString("tax_type"		));
				bean.setCar_no			(rs.getString("car_no"			)==null?"":rs.getString("car_no"		));
				bean.setCar_nm			(rs.getString("car_nm"			)==null?"":rs.getString("car_nm"		));
				bean.setCar_name		(rs.getString("car_name"		)==null?"":rs.getString("car_name"		));
				bean.setInit_reg_dt		(rs.getString("init_reg_dt"		)==null?"":rs.getString("init_reg_dt"	));
				bean.setFirm_nm			(rs.getString("firm_nm"			)==null?"":rs.getString("firm_nm"		));
				bean.setClient_nm		(rs.getString("client_nm"		)==null?"":rs.getString("client_nm"		));
				bean.setSite_nm			(rs.getString("site_nm"			)==null?"":rs.getString("site_nm"		));
				bean.setVen_code		(rs.getString("ven_code"		)==null?"":rs.getString("ven_code"		));
				bean.setPrint_st		(rs.getString("print_st"		)==null?"":rs.getString("print_st"		));
				bean.setRent_way		(rs.getString("rent_way"		)==null?"":rs.getString("rent_way"		));
				bean.setCon_mon			(rs.getString("con_mon"			)==null?"":rs.getString("con_mon"		));
				bean.setRent_start_dt	(rs.getString("rent_start_dt"	)==null?"":rs.getString("rent_start_dt"	));
				bean.setRent_end_dt		(rs.getString("rent_end_dt"		)==null?"":rs.getString("rent_end_dt"	));
				bean.setLeave_day		(rs.getString("leave_day"		)==null?"":rs.getString("leave_day"		));
				bean.setPrv_mon_yn		(rs.getString("prv_mon_yn"		)==null?"":rs.getString("prv_mon_yn"	));
				bean.setBr_nm			(rs.getString("br_nm"			)==null?"":rs.getString("br_nm"			));
				bean.setCms_bank		(rs.getString("cms_bank"		)==null?"":rs.getString("cms_bank"		));
				bean.setCms_start_dt	(rs.getString("cms_start_dt"	)==null?"":rs.getString("cms_start_dt"	));
				bean.setCms_end_dt		(rs.getString("cms_end_dt"		)==null?"":rs.getString("cms_end_dt"	));
				bean.setCms_day			(rs.getString("cms_day"			)==null?"":rs.getString("cms_day"		));
				bean.setFee_amt			(rs.getInt   ("fee_amt"			));
				bean.setCar_use			(rs.getString("car_use"			)==null?"":rs.getString("car_use"		));
				bean.setJg_code			(rs.getString("jg_code"			)==null?"":rs.getString("jg_code"		));
				bean.setS_st			(rs.getString("s_st"			)==null?"":rs.getString("s_st"			));
				bean.setCar_st			(rs.getString("car_st"			)==null?"":rs.getString("car_st"		));
				bean.setM_tel			(rs.getString("m_tel"			)==null?"":rs.getString("m_tel"		));
				
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getScdMngLongRentInfo]\n"+e);
			System.out.println("[ScdMngDatabase:getScdMngLongRentInfo]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}		
	}

	/**
	 *	거래처상세부분 rent_mng_id별 rent_l_cd 갯수
	 */
	public Vector getScdFeeChk(String rent_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select rent_mng_id, rent_l_cd, count(0) from scd_fee where rent_mng_id='"+rent_mng_id+"' group by rent_mng_id, rent_l_cd ";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getScdFeeChk]\n"+e);
			System.out.println("[ScdMngDatabase:getScdFeeChk]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	개별발행- 계약별 발행스케줄
	 */
	public Vector getFeeScd1(String rent_mng_id, String rent_l_cd, String mode)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.rent_mng_id, a.rent_l_cd, a.rent_st, a.fee_tm, a.tm_st1, a.tm_st2, a.fee_est_dt, a.fee_s_amt, a.fee_v_amt, a.rc_dt, a.req_dt,"+
				" b.tax_dt, b.reg_dt, b.print_dt, c.cng_dt, c.cng_cau"+
				" from scd_fee a, tax b, tax_cng c, (select tax_no, max(seq) seq from tax_cng group by tax_no) d"+
				" where a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.fee_tm(+)"+
				" and b.tax_no=c.tax_no(+) and c.tax_no=d.tax_no(+) and c.seq=d.seq(+)"+
				" and nvl(a.bill_yn,'Y')='Y' and a.tm_st1='0' and a.rent_mng_id='"+rent_mng_id+"'";												

		if(mode.equals("")) query += " and a.rent_l_cd='"+rent_l_cd+"'";

		query += " order by a.r_fee_est_dt";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setRc_dt(rs.getString("RC_DT")==null?"":rs.getString("RC_DT"));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setTax_dt(rs.getString("TAX_DT")==null?"":rs.getString("TAX_DT"));
				fee_scd.setR_req_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				fee_scd.setPrint_dt(rs.getString("PRINT_DT")==null?"":rs.getString("PRINT_DT"));
				fee_scd.setCng_dt(rs.getString("CNG_DT")==null?"":rs.getString("CNG_DT"));
				fee_scd.setCng_cau(rs.getString("CNG_CAU")==null?"":rs.getString("CNG_CAU"));

				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getFeeScd1]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScd1]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( stmt != null )		stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	통합발행- 계약별 발행스케줄
	 */
	public Vector getFeeScd2(String rent_mng_id, String rent_l_cd, String mode)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.rent_mng_id, a.rent_l_cd, a.fee_tm, a.tm_st1, a.tm_st2, a.fee_est_dt, a.fee_s_amt, a.fee_v_amt, a.req_dt,"+
				" c.tax_dt as ext_dt, c.tax_dt as print_dt, '' cng_dt, '' cng_cau"+
				" from scd_fee a, cont b,"+
				" (select client_id, seq, substr(tax_dt,1,6) tax_ym, max(tax_dt) tax_dt from tax group by client_id, seq, substr(tax_dt,1,6)) c"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.client_id=c.client_id(+) and b.r_site=c.seq(+)"+
				" and nvl(a.bill_yn,'Y')='Y' and a.tm_st1='0' and a.rent_mng_id='"+rent_mng_id+"'";												

		if(mode.equals("")) query += " and a.rent_l_cd='"+rent_l_cd+"'";

		query += " order by a.r_fee_est_dt";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);    	
			while(rs.next())
			{
				FeeScdBean fee_scd = new FeeScdBean();
				fee_scd.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee_scd.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee_scd.setFee_tm(rs.getString("FEE_TM")==null?"":rs.getString("FEE_TM"));
				fee_scd.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee_scd.setTm_st1(rs.getString("TM_ST1")==null?"":rs.getString("TM_ST1"));
				fee_scd.setTm_st2(rs.getString("TM_ST2")==null?"":rs.getString("TM_ST2"));
				fee_scd.setFee_est_dt(rs.getString("FEE_EST_DT")==null?"":rs.getString("FEE_EST_DT"));
				fee_scd.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee_scd.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee_scd.setReq_dt(rs.getString("REQ_DT")==null?"":rs.getString("REQ_DT"));
				fee_scd.setExt_dt(rs.getString("EXT_DT")==null?"":rs.getString("EXT_DT"));
				fee_scd.setPrint_dt(rs.getString("PRINT_DT")==null?"":rs.getString("PRINT_DT"));
				fee_scd.setCng_dt(rs.getString("CNG_DT")==null?"":rs.getString("CNG_DT"));
				fee_scd.setCng_cau(rs.getString("CNG_CAU")==null?"":rs.getString("CNG_CAU"));

				vt.add(fee_scd);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getFeeScd2]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScd2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( stmt != null )		stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}



	/**
	 *	발행스케줄관리 - 발행작업스케줄
	 */
	public Vector getFeeScdTaxScd(String s_br, String gubun, String tm_gubun, String client_id, String site_id, String rent_mng_id, String rent_l_cd, String car_mng_id, String year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";

		base_query = "  select \n"+
					 "  a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, a.rent_mng_id, a.rent_l_cd, \n"+
					 "  a.rent_st, a.fee_tm, a.tm_st1, a.tm_st2, a.fee_est_dt, a.r_fee_est_dt, a.req_dt, a.r_req_dt, a.fee_s_amt, a.fee_v_amt, a.fee_amt, a.rc_yn, a.dly_days,\n"+
					 "  a.use_s_dt, a.use_e_dt, a.tax_out_dt, a.pay_cng_dt, a.pay_cng_cau, decode(substr(a.pay_cng_cau,1,4),'임의연장','Y','N') im_yn, \n"+
					 "  decode(c.rent_l_cd,'',nvl(b.reg_dt,b.tax_dt),nvl(c.reg_dt,c.tax_dt)) reg_dt,\n"+
					 "  decode(c.rent_l_cd,'',b.tax_dt,c.tax_dt) tax_dt, \n"+
					 "  decode(c.rent_l_cd,'',b.print_dt,c.print_dt) print_dt, \n"+
					 "  decode(c.rent_l_cd,'',b.tax_no,c.tax_no) tax_no,"+				 
					 "  decode(c.rent_l_cd,'',b.item_supply,c.tax_supply) tax_supply,\n"+
					 "  decode(c.rent_l_cd,'',b.item_value,c.tax_value) tax_value, \n"+
					 "  decode(c.rent_l_cd,'',b.item_amt,c.tax_supply+c.tax_value) tax_amt \n"+
					 "  from \n"+
					 "  ( select /*+ index(cont CONT_PK  ) */ a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, b.rent_mng_id, b.rent_l_cd,\n"+
					 "  	b.rent_st, b.fee_tm, b.tm_st1, b.tm_st2, b.fee_est_dt, b.r_fee_est_dt, b.req_dt, b.r_req_dt, b.fee_s_amt, b.fee_v_amt, (b.fee_s_amt+b.fee_v_amt) fee_amt,\n"+
					 "		b.rc_yn, b.dly_days, b.use_s_dt, b.use_e_dt, b.tax_out_dt, b.pay_cng_dt, b.pay_cng_cau \n"+
					 "  	from cont a, scd_fee b \n"+
					 "  	where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.bill_yn,'Y')='Y' and b.tm_st1='0') a,\n"+ // and a.use_yn='Y'
					 "  	"+
					 "  ( select  /*+ leading(a b) use_nl(a b)*/ b.rent_l_cd, b.tm, a.reg_dt, a.tax_dt, a.print_dt, a.tax_no, b.item_supply, b.item_value, (b.item_supply+b.item_value) item_amt \n"+
					 "  	from tax a, tax_item_list b \n"+
					 "  	where a.item_id=b.item_id and b.item_g='대여료' and a.tax_st='O' ) b,\n"+
					 "  (select  rent_l_cd, fee_tm, max(tax_no) tax_no, max(tax_dt) tax_dt, max(reg_dt) reg_dt, max(print_dt) print_dt,\n"+
					 "		max(tax_supply) tax_supply, max(tax_value) tax_value from tax where tax_g='대여료' and tax_st<>'C' group by rent_l_cd, fee_tm) c \n"+
					 "  where \n"+
					 "  a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.tm(+) \n"+
					 "  and a.rent_l_cd=c.rent_l_cd(+) and a.fee_tm=c.fee_tm(+) \n";

		if(!s_br.equals(""))	 base_query += " and brch_id like '"+s_br+"%'";

		//출고지연
		if(tm_gubun.equals("0")) base_query += " and a.tm_st2='2'";
		//신차대여
		if(!tm_gubun.equals("0") && !tm_gubun.equals("")) base_query += " and a.rent_st='"+tm_gubun+"' and a.tm_st2<>'2'";

		base_query += "  order by a.req_dt";

		if(gubun.equals("1") || gubun.equals("2")){
			query = " select \n"+
					" r_req_dt, max(nvl(reg_dt,tax_dt)) reg_dt, \n"+
					" min(r_fee_est_dt) s_fee_est_dt, max(r_fee_est_dt) e_fee_est_dt, \n"+
					" count(rent_l_cd) a_cnt, count(tax_no) y_cnt,\n"+
					" sum(tax_supply+tax_value) tax_amt, sum(fee_s_amt+fee_v_amt) fee_amt \n"+
					" from ( "+base_query+" ) where fee_amt >0 ";

			//거래처별
			if(gubun.equals("1") && !client_id.equals(""))							query += " and client_id='"+client_id+"'";
			//지점/현장별
			if(gubun.equals("2") && !client_id.equals("") && !site_id.equals(""))	query += " and client_id='"+client_id+"' and r_site='"+site_id+"'";

			//년도
			if(!year.equals(""))													query += " and r_req_dt like '"+year+"%'";

			query += " group by r_req_dt";

		}else{
			query = " select * from ( "+base_query+" ) where fee_amt >0";

			//계약별
			if(gubun.equals("3") && !rent_l_cd.equals(""))							query += " and rent_l_cd='"+rent_l_cd+"'";
			if(gubun.equals("3") && !rent_mng_id.equals(""))						query += " and rent_mng_id='"+rent_mng_id+"'";
			//차량별
			if(gubun.equals("4") && !car_mng_id.equals(""))							query += " and car_mng_id='"+car_mng_id+"'";

			//년도
			if(!year.equals(""))													query += " and req_dt like '"+year+"%'";

			query += " order by to_number(fee_tm), fee_est_dt";

		}


		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScdTaxScd]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScdTaxScd]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	발행스케줄관리 - 발행작업스케줄
	 */
	public Vector getFeeScdTaxScd(String s_br, String gubun, String tm_gubun, String client_id, String site_id, String rent_mng_id, String rent_l_cd, String car_mng_id, String year, String rent_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";

		base_query = "  select \n"+
					 "         a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, a.rent_mng_id, a.rent_l_cd, \n"+
					 "         a.rent_st, a.fee_tm, a.tm_st1, a.tm_st2, a.fee_est_dt, a.r_fee_est_dt, a.req_dt, a.r_req_dt, a.fee_s_amt, a.fee_v_amt, a.fee_amt, a.rc_yn, a.dly_days, \n"+
					 "         a.use_s_dt, a.use_e_dt, a.tax_out_dt, a.rent_seq, a.bill_yn, a.pay_cng_dt, a.pay_cng_cau, decode(substr(a.pay_cng_cau,1,4),'임의연장','Y','N') im_yn, \n"+

					 "         b.reg_dt, b.tax_dt, b.print_dt, b.tax_no, b.item_dt, b.item_id, b.tax_est_dt \n"+	

					 "  from \n"+
					 "        ( select /*+ index(cont CONT_PK  ) */ a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, b.rent_mng_id, b.rent_l_cd, \n"+
					 "  	           b.rent_st, b.fee_tm, b.tm_st1, b.tm_st2, b.fee_est_dt, b.r_fee_est_dt, b.req_dt, b.r_req_dt, b.fee_s_amt, b.fee_v_amt, (b.fee_s_amt+b.fee_v_amt) fee_amt, \n"+
					 "		           b.rc_yn, b.dly_days, b.use_s_dt, b.use_e_dt, b.tax_out_dt, b.rent_seq, b.bill_yn, b.pay_cng_dt, b.pay_cng_cau \n"+
					 "  	    from   cont a, scd_fee b \n"+
					 "  	    where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.tm_st1='0'\n"+// and a.use_yn='Y' and nvl(b.bill_yn,'Y')='Y' 
					 "  	  ) a, \n"+

							  //20110215 거래명세서&세금계산서
					 "        ( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm, sum(item_supply) fee_s_amt, \n"+
					 "                 max(b.item_id) item_id, max(b.item_dt) item_dt, max(b.tax_est_dt) tax_est_dt, \n"+
					 "                 decode(sum(c.tax_supply),0,'',max(c.tax_no)) tax_no, "+
					 "		           decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.reg_dt)) reg_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.print_dt)) print_dt \n"+
					 "          from   tax_item_list a, tax_item b, tax c \n"+
					 "          where  a.gubun='1' \n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id(+) and nvl(c.tax_st,'O')<>'C' and nvl(b.use_yn,'Y')='Y' \n"+
					 "          group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm \n"+
					 "          having sum(a.item_supply)>0"+
					 "	      ) b \n"+

					 "  where \n"+
					 "         a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.fee_tm(+) and a.rent_st=b.rent_st(+) and a.rent_seq=b.rent_seq(+)\n"+// and a.fee_s_amt=b.fee_s_amt(+)
					 " ";

		if(!s_br.equals(""))	 base_query += " and brch_id like '"+s_br+"%'";

		//출고지연
		if(tm_gubun.equals("0")) base_query += " and a.tm_st2='2'";
		//신차대여
		if(!tm_gubun.equals("0") && !tm_gubun.equals("")) base_query += " and a.rent_st='"+tm_gubun+"' and a.tm_st2<>'2'";

		if(!rent_seq.equals(""))	 base_query += " and nvl(a.rent_seq,'1')='"+rent_seq+"'";

		base_query += "  order by a.req_dt";

		if(gubun.equals("1") || gubun.equals("2")){
			query = " select \n"+
					" r_req_dt, max(nvl(reg_dt,tax_dt)) reg_dt, \n"+
					" min(r_fee_est_dt) s_fee_est_dt, max(r_fee_est_dt) e_fee_est_dt, \n"+
					" count(rent_l_cd) a_cnt, count(tax_no) y_cnt, \n"+
					" sum(tax_supply+tax_value) tax_amt, sum(fee_s_amt+fee_v_amt) fee_amt \n"+
					" from ( "+base_query+" ) where rent_l_cd is not null ";

			//거래처별
			if(gubun.equals("1") && !client_id.equals(""))							query += " and client_id='"+client_id+"'";
			//지점/현장별
			if(gubun.equals("2") && !client_id.equals("") && !site_id.equals(""))	query += " and client_id='"+client_id+"' and r_site='"+site_id+"'";

			//년도
			if(!year.equals(""))													query += " and r_req_dt like '"+year+"%'";

			query += " group by r_req_dt";

		}else{
			query = " select * from ( "+base_query+" ) where rent_l_cd is not null ";

			//계약별
			if(gubun.equals("3") && !rent_l_cd.equals(""))							query += " and rent_l_cd='"+rent_l_cd+"'";
			if(gubun.equals("3") && !rent_mng_id.equals(""))						query += " and rent_mng_id='"+rent_mng_id+"'";
			//차량별
			if(gubun.equals("4") && !car_mng_id.equals(""))							query += " and car_mng_id='"+car_mng_id+"'";

			//년도
			if(!year.equals(""))													query += " and req_dt like '"+year+"%'";

			query += " order by to_number(fee_tm), fee_est_dt";

		}


		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScdTaxScd]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScdTaxScd]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}


	/**
	 *	지점별 대여료 발행 스케줄 쿼리 - 기발행스케줄
	 */
	public Vector getFeeScdSiteY(String client_id, String site_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, b.item_cnt, (a.tax_supply+a.tax_value) as tax_amt, a.tax_dt as req_dt, a.tax_dt as print_dt, '' cng_dt"+
				" from tax a, (select item_id, count(0) as item_cnt from tax_item_list group by item_id) b"+
				" where a.item_id=b.item_id(+)"+
				" and a.client_id='"+client_id+"' and a.seq='"+site_id+"' order by a.tax_dt";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScd]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScd]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	/**
	 *	지점별 대여료 발행 스케줄 쿼리 - 기발행스케줄
	 */
	public Vector getFeeScdSiteN(String client_id, String site_id, String max_tax_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, b.item_cnt, (a.tax_supply+a.tax_value) as tax_amt, a.tax_dt as req_dt, a.tax_dt as print_dt, '' cng_dt"+
				" from tax a, (select item_id, count(0) as item_cnt from tax_item_list group by item_id) b"+
				" where a.item_id=b.item_id(+)"+
				" and a.client_id='"+client_id+"' and a.seq='"+site_id+"' order by a.tax_dt";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScd]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScd]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	미발행현황
	 */
	public Vector getFeeScdNoTax(String s_br, String year, String month, String s_kd, String t_wd1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";

		base_query = "  select \n"+
					 "  a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, a.rent_mng_id, a.rent_l_cd, a.cls_st, a.cls_dt, e.rent_l_cd as stop_l_cd,"+
					 "  a.fee_tm, a.rent_st, a.rent_seq, a.tm_st1, a.tm_st2, a.fee_est_dt, a.req_dt, a.tax_out_dt, a.fee_s_amt, a.fee_v_amt, a.fee_amt, a.rc_yn, a.dly_days,"+
					 "  decode(c.rent_l_cd,'',nvl(b.reg_dt,b.tax_dt),nvl(c.reg_dt,c.tax_dt)) reg_dt,"+
					 "  decode(c.rent_l_cd,'',b.tax_dt,c.tax_dt) tax_dt,"+
					 "  decode(c.rent_l_cd,'',b.print_dt,c.print_dt) print_dt,"+
					 "  decode(c.rent_l_cd,'',b.tax_no,c.tax_no) tax_no,"+				 
					 "  decode(c.rent_l_cd,'',b.item_supply,c.tax_supply) tax_supply,"+
					 "  decode(c.rent_l_cd,'',b.item_value,c.tax_value) tax_value,"+
					 "  decode(c.rent_l_cd,'',b.item_amt,c.tax_supply+c.tax_value) tax_amt, \n"+
					 "  decode(a.fee_amt,e2.rc_amt,'수금') rc_yn_nm, e.seq"+	
					 "  from  \n"+
					 "  ( select /*+ index(cont CONT_PK  ) */ a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, b.rent_mng_id, b.rent_l_cd, c.cls_st, c.cls_dt, "+
					 "  	b.rent_st, b.fee_tm, b.tm_st1, b.tm_st2, b.rent_seq, b.fee_est_dt, b.req_dt, b.tax_out_dt, b.fee_s_amt, b.fee_v_amt, (b.fee_s_amt+b.fee_v_amt) fee_amt, b.rc_yn, b.dly_days"+
					 "  	from cont a, scd_fee b, cls_cont c "+
					 "  	where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.bill_yn,'Y')='Y' and b.tm_st1='0' "+
					 "            and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+)) a, \n"+
					 "  	"+
					 "  ( select  /*+ leading(a b) use_nl(a b)*/  b.rent_l_cd, b.tm, a.reg_dt, a.tax_dt, a.print_dt, a.tax_no, b.item_supply, b.item_value, (b.item_supply+b.item_value) item_amt"+
					 "  	from tax a, tax_item_list b"+
					 "  	where a.item_id=b.item_id and b.item_g='대여료' ) b, \n"+
					 "  tax c, \n"+
					 "  ( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),stop_e_dt) > to_char(sysdate,'YYYYMMDD')) e, \n"+
					 "  ( select rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, sum(rc_amt) rc_amt from scd_fee where rc_yn='1' group by rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq ) e2 \n"+
					 "  where  \n"+
					 "  a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.tm(+) "+
					 "  and a.rent_l_cd=c.rent_l_cd(+) and a.fee_tm=c.fee_tm(+) "+
					 "  and a.rent_mng_id=e2.rent_mng_id(+) and a.rent_l_cd=e2.rent_l_cd(+) and a.fee_tm=e2.fee_tm(+) and a.rent_st=e2.rent_st(+) and a.rent_seq=e2.rent_seq(+) \n"+
					 "  and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) "+
					 "  and decode(e.rent_l_cd,'','',decode(a.fee_amt,e2.rc_amt,''),e.rent_l_cd) is null \n"+
					 "  and a.rent_l_cd not in ('B108HXBL00011','S106HU3L00014')  \n"+
					 "  order by a.req_dt";

		query = " select decode(a.cls_st,'8','매입옵션','2','중도해지','1','계약만료','4','차종변경','5','계약승계','',decode(a.stop_l_cd,'','','발행중지'),'해지') as use_yn, \n"+
				" a.brch_id, a.rent_mng_id, a.rent_l_cd, a.client_id, decode(c.print_st,'2','거래처통합','3','지점통합','4','현장통합','계약건별') print_st, c.firm_nm, \n"+
				" b.car_no, b.car_nm, f.car_name, a.rent_st, a.rent_seq, a.fee_tm, a.fee_est_dt, a.req_dt, a.tax_out_dt, a.fee_s_amt, a.fee_v_amt, a.fee_amt, g.dly_cnt, a.rc_yn_nm, a.seq \n"+
				" from \n"+
				"	( "+base_query+" ) a, car_reg b, client c, car_etc e, car_nm f, \n"+
				"	( select rent_mng_id, rent_l_cd, count(0) dly_cnt from scd_fee"+
				"	  where nvl(bill_yn,'Y')='Y' and tm_st1='0' and rc_yn='0' and fee_est_dt < to_char(sysdate,'YYYYMMDD') and dly_days > 0 group by rent_mng_id, rent_l_cd) g \n"+
				" where a.use_yn='Y' and a.tax_no is null  \n "+
				" and a.car_mng_id=b.car_mng_id and a.client_id=c.client_id \n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq \n"+
				" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+)  \n";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%' \n";

		if(!year.equals(""))	query += " and a.req_dt like '"+year+"%' \n";

		if(!month.equals(""))	query += " and a.req_dt like '"+year+""+month+"%' \n";

		String search = "";
		if(s_kd.equals("1"))		search = "c.firm_nm";
		else if(s_kd.equals("2"))	search = "a.rent_l_cd";
		else if(s_kd.equals("3"))	search = "b.car_no";

		if(!t_wd1.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%' \n";

		if(t_wd1.equals("") && !month.equals("")){
			query += " and a.req_dt < to_char(sysdate,'YYYYMMDD')";
		}


		query += " order by a.cls_st, a.stop_l_cd, a.client_id, a.req_dt";




		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScdTaxScd]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScdTaxScd]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	발행중지현황
	 */
	public Vector getFeeScdStopTax(String s_br, String year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";

		base_query = "  select"+
					 "  a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, a.rent_mng_id, a.rent_l_cd,"+
					 "  a.rent_st, a.fee_tm, a.tm_st1, a.tm_st2, a.fee_est_dt, a.req_dt, a.fee_s_amt, a.fee_v_amt, a.fee_amt, a.rc_yn, a.dly_days,"+
					 "  decode(c.rent_l_cd,'',nvl(b.reg_dt,b.tax_dt),nvl(c.reg_dt,c.tax_dt)) reg_dt,"+
					 "  decode(c.rent_l_cd,'',b.tax_dt,c.tax_dt) tax_dt,"+
					 "  decode(c.rent_l_cd,'',b.print_dt,c.print_dt) print_dt,"+
					 "  decode(c.rent_l_cd,'',b.tax_no,c.tax_no) tax_no,"+				 
					 "  decode(c.rent_l_cd,'',b.item_supply,c.tax_supply) tax_supply,"+
					 "  decode(c.rent_l_cd,'',b.item_value,c.tax_value) tax_value,"+
					 "  decode(c.rent_l_cd,'',b.item_amt,c.tax_supply+c.tax_value) tax_amt,"+
					 "  e.stop_st, e.stop_cau, e.seq as stop_seq"+
					 "  from "+
					 "  ( select a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, b.rent_mng_id, b.rent_l_cd,"+
					 "  	b.rent_st, b.fee_tm, b.tm_st1, b.tm_st2, b.fee_est_dt, b.req_dt, b.fee_s_amt, b.fee_v_amt, (b.fee_s_amt+b.fee_v_amt) fee_amt, b.rc_yn, b.dly_days"+
					 "  	from cont a, scd_fee b "+
					 "  	where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.bill_yn,'Y')='Y' and b.tm_st1='0') a,"+
					 "  	"+
					 "  ( select b.rent_l_cd, b.tm, a.reg_dt, a.tax_dt, a.print_dt, a.tax_no, b.item_supply, b.item_value, (b.item_supply+b.item_value) item_amt"+
					 "  	from tax a, tax_item_list b"+
					 "  	where a.item_id=b.item_id and b.item_g='대여료' ) b,"+
					 "  tax c,"+
					 "  ( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),stop_e_dt) > to_char(sysdate,'YYYYMMDD')) e"+
					 "  where "+
					 "  a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.tm(+) "+
					 "  and a.rent_l_cd=c.rent_l_cd(+) and a.fee_tm=c.fee_tm(+) "+
					 "  and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
					 "  order by a.req_dt";

		query = " select "+
				" a.brch_id, a.rent_mng_id, a.rent_l_cd, a.client_id, decode(c.print_st,'2','거래처통합','3','지점통합','4','현장통합','계약건별') print_st, c.firm_nm,"+
				" b.car_no, b.car_nm, f.car_name, a.fee_tm, a.fee_est_dt, a.req_dt, a.fee_s_amt, a.fee_v_amt, a.fee_amt, g.dly_cnt,"+
				" decode(a.stop_st,'1','연체','고객요청') stop_st, a.stop_cau, a.stop_seq"+
				" from"+
				" ( "+base_query+" ) a, car_reg b, client c, car_etc e, car_nm f,"+
				" ( select rent_mng_id, rent_l_cd, count(0) dly_cnt from scd_fee"+
				"	where nvl(bill_yn,'Y')='Y' and tm_st1='0' and rc_yn='0' and fee_est_dt < to_char(sysdate,'YYYYMMDD') and dly_days > 0 group by rent_mng_id, rent_l_cd) g"+
				" where a.use_yn='Y' and a.tax_no is null"+
				" and a.car_mng_id=b.car_mng_id and a.client_id=c.client_id"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq"+
				" and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) ";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";

		if(!year.equals(""))	query += " and a.req_dt like '"+year+"%'";

		query += " order by a.req_dt";




		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScdStopTax]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScdStopTax]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	수시발행 - 선수금 스케줄
	 */
	public Vector getGrtScdList(String s_br, String client_id, String tax_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.brch_id, nvl(d.car_no,'미등록') car_no, nvl(d.car_nm,g.car_nm) car_nm, a.car_mng_id, a.rent_dt, b.rent_start_dt, h.firm_nm, h.client_id, i.seq as site_id, \n"+
				"        decode(b.ifee_s_amt,0,0,decode(b.fee_s_amt,0,0,((b.ifee_s_amt+b.ifee_v_amt)/(b.fee_s_amt+b.fee_v_amt)))) ifee_tm,  \n"+
				"        decode(c.ext_st,'1','선납금','2','개시대여료','5','승계수수료') pp_st_nm,  \n"+
				"        b.pere_r_mth, b.pere_r_mth, (c.ext_s_amt+c.ext_v_amt) pp_amt, nvl(a.use_yn,'Y') use_yn, \n"+
				"        k.suc_rent_st, k.rent_suc_dt, k.rent_suc_pp_yn, k.pp_suc_o_amt, k.pp_suc_r_amt, k.rent_suc_ifee_yn, k.ifee_suc_o_amt, k.ifee_suc_r_amt, k.n_mon, k.n_day, \n"+
				"        decode(nvl(k.pp_suc_r_amt,0),0,0,round(k.pp_suc_r_amt/1.1)) pp_suc_s_amt, decode(nvl(k.pp_suc_r_amt,0),0,0,k.pp_suc_r_amt-round(k.pp_suc_r_amt/1.1)) pp_suc_v_amt, \n"+
				"        decode(nvl(k.ifee_suc_r_amt,0),0,0,round(k.ifee_suc_r_amt/1.1)) ifee_suc_s_amt, decode(nvl(k.ifee_suc_r_amt,0),0,0,k.ifee_suc_r_amt-round(k.ifee_suc_r_amt/1.1)) ifee_suc_v_amt, \n"+
				"        c.*  \n"+				
				" from   cont a, fee b, scd_ext c, car_reg d, car_etc e, car_nm f, car_mng g, client h, client_site i,  \n"+
				"        (select a.rent_l_cd, a.gubun, a.tm from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st<>'C' and a.gubun in ('3','2','4','14') group by a.rent_l_cd, a.gubun, a.tm having sum(a.item_supply)>0 ) j, \n"+ //2 보증금, 3 선납금, 4 개시대여료, 14 승계수수료 
				"        (select * from cls_cont where cls_st in ('4','5')) l, cont_etc k, \n"+	
                "        (SELECT rent_mng_id, rent_l_cd FROM scd_fee WHERE tm_st2='4' and bill_yn='Y' GROUP BY rent_mng_id, rent_l_cd) n \n"+
				" where  decode(c.ext_st,'5','Y',nvl(a.use_yn,'Y'))='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
				"        and c.ext_st in ('1','2','5') and c.ext_v_amt <> 0  \n"+
				"        and ((k.rent_suc_dt IS NULL AND c.ext_tm='1') OR (k.rent_suc_dt IS NOT NULL AND k.rent_suc_dt<=c.ext_est_dt)) \n"+
				"        and a.car_mng_id=d.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code \n"+
				"        and a.client_id=h.client_id and a.client_id=i.client_id(+) and a.r_site=i.seq(+) \n"+
				"        and c.rent_l_cd=j.rent_l_cd(+) and decode(c.ext_st,'1','3','2','4','5','14')=j.gubun(+) and c.rent_st=j.tm(+) \n"+
				"        and a.rent_mng_id=l.rent_mng_id(+) and a.reg_dt=l.reg_dt(+) \n"+
				"        and a.rent_mng_id=k.rent_mng_id and a.rent_l_cd=k.rent_l_cd \n"+
				"        and (c.ext_st='5' or decode(l.rent_l_cd,'',nvl(c.ext_est_dt,a.rent_dt),nvl(k.rent_suc_dt,l.cls_dt))<=nvl(c.ext_est_dt,a.rent_dt)) \n"+
                "        AND a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+) \n"+
                "        AND DECODE(c.ext_st,'1',DECODE(n.rent_mng_id,'','Y','N'),'Y')='Y' \n"+
				"        and decode(c.ext_st,'1',nvl(b.pp_chk,'1'),'1') <> '0' "+ //선납금 매월균등발행은 안함.		 
				" ";


		if(!s_br.equals(""))		query += " and a.brch_id like '"+s_br+"%'";

		if(!client_id.equals(""))	query += " and a.client_id='"+client_id+"'";

		if(tax_yn.equals("N"))		query += " and j.rent_l_cd is null ";//and k.pp_st is null

		//이전데이타 일괄정리
		query += " and nvl(nvl(c.ext_est_dt,c.ext_pay_dt),to_char(sysdate,'YYYYMMDD')) > '20201231'";

		//별도처리
		query += " and a.rent_l_cd not in ('S111HTLR00160','S415HHGR00101','S415HHGR00079')";

		//별도처리2
		query += " and c.rent_l_cd||c.rent_st||c.ext_st not in ('I114KK7L0016315')";

		query += " order by nvl(c.ext_est_dt,c.ext_pay_dt) desc";

		try {
				pstmt = conn.prepareStatement(query);
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

	//		System.out.println("[ScdMngDatabase:getGrtScdList]\n"+query);
			
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getGrtScdList]\n"+e);
			System.out.println("[ScdMngDatabase:getGrtScdList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	/**
	 *	수시발행 - 선수금 스케줄
	 */
	public Vector getGrtScdList(String s_br, String client_id, String tax_yn, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.brch_id, nvl(d.car_no,'미등록') car_no, nvl(d.car_nm,g.car_nm) car_nm, a.car_mng_id, a.rent_dt, b.rent_start_dt, h.firm_nm, h.client_id, i.seq as site_id, \n"+
				"        decode(b.ifee_s_amt,0,0,decode(b.fee_s_amt,0,0,((b.ifee_s_amt+b.ifee_v_amt)/(b.fee_s_amt+b.fee_v_amt)))) ifee_tm,  \n"+
				"        decode(c.ext_st,'1','선납금','2','개시대여료','5','승계수수료') pp_st_nm,  \n"+
				"        b.pere_r_mth, b.pere_r_mth, (c.ext_s_amt+c.ext_v_amt) pp_amt, nvl(a.use_yn,'Y') use_yn, \n"+
				"        k.suc_rent_st, k.rent_suc_dt, k.rent_suc_pp_yn, k.pp_suc_o_amt, k.pp_suc_r_amt, k.rent_suc_ifee_yn, k.ifee_suc_o_amt, k.ifee_suc_r_amt, k.n_mon, k.n_day, \n"+
				"        decode(nvl(k.pp_suc_r_amt,0),0,0,round(k.pp_suc_r_amt/1.1)) pp_suc_s_amt, decode(nvl(k.pp_suc_r_amt,0),0,0,k.pp_suc_r_amt-round(k.pp_suc_r_amt/1.1)) pp_suc_v_amt, \n"+
				"        decode(nvl(k.ifee_suc_r_amt,0),0,0,round(k.ifee_suc_r_amt/1.1)) ifee_suc_s_amt, decode(nvl(k.ifee_suc_r_amt,0),0,0,k.ifee_suc_r_amt-round(k.ifee_suc_r_amt/1.1)) ifee_suc_v_amt, \n"+
				"        c.*  \n"+				
				" from   cont a, fee b, scd_ext c, car_reg d, car_etc e, car_nm f, car_mng g, client h, client_site i,  \n"+
				"        (select a.rent_l_cd, a.gubun, a.tm from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st<>'C' and a.gubun in ('3','2','4','14') group by a.rent_l_cd, a.gubun, a.tm having sum(a.item_supply)>0 ) j, \n"+ //2 보증금, 3 선납금, 4 개시대여료, 14 승계수수료 
				"        (select * from cls_cont where cls_st in ('4','5')) l, cont_etc k, \n"+	
                "        (SELECT rent_mng_id, rent_l_cd FROM scd_fee WHERE tm_st2='4' and bill_yn='Y' GROUP BY rent_mng_id, rent_l_cd) n \n"+
				" where  decode(c.ext_st,'5','Y',nvl(a.use_yn,'Y'))='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
				"        and c.ext_st in ('1','2','5') and c.ext_v_amt <> 0  \n"+
				"        and ((k.rent_suc_dt IS NULL AND c.ext_tm='1') OR (k.rent_suc_dt IS NOT NULL AND k.rent_suc_dt<=c.ext_est_dt)) \n"+
				"        and a.car_mng_id=d.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code \n"+
				"        and a.client_id=h.client_id and a.client_id=i.client_id(+) and a.r_site=i.seq(+) \n"+
				"        and c.rent_l_cd=j.rent_l_cd(+) and decode(c.ext_st,'1','3','2','4','5','14')=j.gubun(+) and c.rent_st=j.tm(+) \n"+
				"        and a.rent_mng_id=l.rent_mng_id(+) and a.reg_dt=l.reg_dt(+) \n"+
				"        and a.rent_mng_id=k.rent_mng_id and a.rent_l_cd=k.rent_l_cd \n"+
				"        and (c.ext_st='5' or decode(l.rent_l_cd,'',nvl(c.ext_est_dt,a.rent_dt),nvl(k.rent_suc_dt,l.cls_dt))<=nvl(c.ext_est_dt,a.rent_dt)) \n"+
                "        AND a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+) \n"+
                "        AND DECODE(c.ext_st,'1',DECODE(n.rent_mng_id,'','Y','N'),'Y')='Y' \n"+
				"        and decode(c.ext_st,'1',nvl(b.pp_chk,'1'),'1') <> '0' "+ //선납금 매월균등발행은 안함.		 
				" ";


		if(!s_br.equals(""))		query += " and a.brch_id like '"+s_br+"%'";
		
		if(gubun2.equals("1")||gubun2.equals("2")||gubun2.equals("5"))		query += " and c.ext_st = '"+gubun2+"'";

		if(!client_id.equals(""))	query += " and a.client_id='"+client_id+"'";

		if(tax_yn.equals("N"))		query += " and j.rent_l_cd is null ";//and k.pp_st is null

		//이전데이타 일괄정리
		query += " and nvl(nvl(c.ext_est_dt,c.ext_pay_dt),to_char(sysdate,'YYYYMMDD')) > '20191231'";
		query += " and nvl(nvl(k.rent_suc_dt,b.rent_start_dt),to_char(sysdate,'YYYYMMDD')) > '20191231'";

		//별도처리
		query += " and a.rent_l_cd not in ('S111HTLR00160','S415HHGR00101','S415HHGR00079')";

		//별도처리2
		query += " and c.rent_l_cd||c.rent_st||c.ext_st not in ('I114KK7L0016315')";

		query += " order by nvl(c.ext_est_dt,c.ext_pay_dt) desc";

		try {
				pstmt = conn.prepareStatement(query);
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

	//		System.out.println("[ScdMngDatabase:getGrtScdList]\n"+query);
			
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getGrtScdList]\n"+e);
			System.out.println("[ScdMngDatabase:getGrtScdList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 *	수시발행 - 선수금 스케줄
	 */
	public Vector getGrtScdContList(String pp_nm, String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.brch_id, nvl(d.car_no,'미등록') car_no, nvl(d.car_nm,g.car_nm) car_nm, a.car_mng_id, a.rent_dt, b.rent_start_dt, h.firm_nm, h.client_id, i.seq as site_id, \n"+
				"        decode(b.ifee_s_amt,0,0,decode(b.fee_s_amt,0,0,((b.ifee_s_amt+b.ifee_v_amt)/(b.fee_s_amt+b.fee_v_amt)))) ifee_tm,  \n"+
				"        decode(c.ext_st,'1','선납금','2','개시대여료','5','승계수수료') pp_st_nm,  \n"+
				"        b.pere_r_mth, b.pere_r_mth, (c.ext_s_amt+c.ext_v_amt) pp_amt, nvl(a.use_yn,'Y') use_yn, \n"+
				"        k.suc_rent_st, k.rent_suc_dt, k.rent_suc_pp_yn, k.pp_suc_o_amt, k.pp_suc_r_amt, k.rent_suc_ifee_yn, k.ifee_suc_o_amt, k.ifee_suc_r_amt, k.n_mon, k.n_day, \n"+
				"        decode(nvl(k.pp_suc_r_amt,0),0,0,round(k.pp_suc_r_amt/1.1)) pp_suc_s_amt, decode(nvl(k.pp_suc_r_amt,0),0,0,k.pp_suc_r_amt-round(k.pp_suc_r_amt/1.1)) pp_suc_v_amt, \n"+
				"        decode(nvl(k.ifee_suc_r_amt,0),0,0,round(k.ifee_suc_r_amt/1.1)) ifee_suc_s_amt, decode(nvl(k.ifee_suc_r_amt,0),0,0,k.ifee_suc_r_amt-round(k.ifee_suc_r_amt/1.1)) ifee_suc_v_amt, \n"+
				"        c.*  \n"+
				" from   cont a, fee b, scd_ext c, car_reg d, car_etc e, car_nm f, car_mng g, client h, client_site i,  \n"+
				"        (select a.rent_l_cd, a.gubun, a.tm from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st<>'C' and a.gubun in ('3','2','4','14') group by a.rent_l_cd, a.gubun, a.tm having sum(a.item_supply)>0 ) j, \n"+ //2 보증금, 3 선납금, 4 개시대여료, 14 승계수수료 
				"        (select * from cls_cont where cls_st in ('4','5')) l, cont_etc k, \n"+	
                "        (SELECT rent_mng_id, rent_l_cd FROM scd_fee WHERE tm_st2='4' and bill_yn='Y' GROUP BY rent_mng_id, rent_l_cd) n \n"+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' \n"+
                "        and decode(c.ext_st,'5','Y',nvl(a.use_yn,'Y'))='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
				"        and ((k.rent_suc_dt IS NULL AND c.ext_tm='1') OR (k.rent_suc_dt IS NOT NULL AND k.rent_suc_dt<=c.ext_est_dt)) \n"+
				"        and a.car_mng_id=d.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code \n"+
				"        and a.client_id=h.client_id and a.client_id=i.client_id(+) and a.r_site=i.seq(+) \n"+
				"        and c.rent_l_cd=j.rent_l_cd(+) and decode(c.ext_st,'1','3','2','4','5','14')=j.gubun(+) and c.rent_st=j.tm(+) \n"+
				"        and a.rent_mng_id=l.rent_mng_id(+) and a.reg_dt=l.reg_dt(+) \n"+
				"        and a.rent_mng_id=k.rent_mng_id and a.rent_l_cd=k.rent_l_cd \n"+
				"        and (c.ext_st='5' or decode(l.rent_l_cd,'',nvl(c.ext_est_dt,a.rent_dt),nvl(k.rent_suc_dt,l.cls_dt))<=nvl(c.ext_est_dt,a.rent_dt)) \n"+
                "        AND a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+) \n"+
                "        AND DECODE(c.ext_st,'1',DECODE(n.rent_mng_id,'','Y','N'),'Y')='Y' \n"+
				"        and decode(c.ext_st,'1',nvl(b.pp_chk,'1'),'1') <> '0' "+ //선납금 매월균등발행은 안함.		
                "        and decode(c.ext_st,'1','선납금','2','개시대여료','5','승계수수료')='"+pp_nm+"' \n"+
				" ";


		try {
				pstmt = conn.prepareStatement(query);
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

	//		System.out.println("[ScdMngDatabase:getGrtScdContList]\n"+query);
			
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getGrtScdContList]\n"+e);
			System.out.println("[ScdMngDatabase:getGrtScdContList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	/**
	 *	수시발행 - 선수금 스케줄
	 */
	public Vector getGrtScdContList(String rent_mng_id, String rent_l_cd, String rent_st, String ext_st, String ext_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.brch_id, nvl(d.car_no,'미등록') car_no, nvl(d.car_nm,g.car_nm) car_nm, a.car_mng_id, a.rent_dt, b.rent_start_dt, h.firm_nm, h.client_id, i.seq as site_id, \n"+
				"        decode(b.ifee_s_amt,0,0,decode(b.fee_s_amt,0,0,((b.ifee_s_amt+b.ifee_v_amt)/(b.fee_s_amt+b.fee_v_amt)))) ifee_tm,  \n"+
				"        decode(c.ext_st,'1','선납금','2','개시대여료','5','승계수수료') pp_st_nm,  \n"+
				"        b.pere_r_mth, b.pere_r_mth, (c.ext_s_amt+c.ext_v_amt) pp_amt, nvl(a.use_yn,'Y') use_yn, \n"+
				"        k.suc_rent_st, k.rent_suc_dt, k.rent_suc_pp_yn, k.pp_suc_o_amt, k.pp_suc_r_amt, k.rent_suc_ifee_yn, k.ifee_suc_o_amt, k.ifee_suc_r_amt, k.n_mon, k.n_day, \n"+
				"        decode(nvl(k.pp_suc_r_amt,0),0,0,round(k.pp_suc_r_amt/1.1)) pp_suc_s_amt, decode(nvl(k.pp_suc_r_amt,0),0,0,k.pp_suc_r_amt-round(k.pp_suc_r_amt/1.1)) pp_suc_v_amt, \n"+
				"        decode(nvl(k.ifee_suc_r_amt,0),0,0,round(k.ifee_suc_r_amt/1.1)) ifee_suc_s_amt, decode(nvl(k.ifee_suc_r_amt,0),0,0,k.ifee_suc_r_amt-round(k.ifee_suc_r_amt/1.1)) ifee_suc_v_amt, \n"+
				"        c.*  \n"+
				" from   cont a, fee b, scd_ext c, car_reg d, car_etc e, car_nm f, car_mng g, client h, client_site i,  \n"+
				"        (select a.rent_l_cd, a.gubun, a.tm from tax_item_list a, tax b where a.rent_l_cd='"+rent_l_cd+"' and a.item_id=b.item_id and b.tax_st<>'C' and a.gubun in ('3','2','4','14') group by a.rent_l_cd, a.gubun, a.tm having sum(a.item_supply)>0 ) j, \n"+ //2 보증금, 3 선납금, 4 개시대여료, 14 승계수수료 
				"        (select * from cls_cont where cls_st in ('4','5')) l, cont_etc k, \n"+	
                "        (SELECT rent_mng_id, rent_l_cd FROM scd_fee WHERE tm_st2='4' and bill_yn='Y' GROUP BY rent_mng_id, rent_l_cd) n \n"+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' \n"+
                "        and decode(c.ext_st,'5','Y',nvl(a.use_yn,'Y'))='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st \n"+
                "        and c.rent_st='"+rent_st+"' and c.ext_st='"+ext_st+"' and c.ext_tm='"+ext_tm+"' \n"+
				"        and ((k.rent_suc_dt IS NULL AND c.ext_tm='1') OR (k.rent_suc_dt IS NOT NULL AND k.rent_suc_dt<=c.ext_est_dt)) \n"+
				"        and a.car_mng_id=d.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code \n"+
				"        and a.client_id=h.client_id and a.client_id=i.client_id(+) and a.r_site=i.seq(+) \n"+
				"        and c.rent_l_cd=j.rent_l_cd(+) and decode(c.ext_st,'1','3','2','4','5','14')=j.gubun(+) and c.rent_st=j.tm(+) \n"+
				"        and a.rent_mng_id=l.rent_mng_id(+) and a.reg_dt=l.reg_dt(+) \n"+
				"        and a.rent_mng_id=k.rent_mng_id and a.rent_l_cd=k.rent_l_cd \n"+
				"        and (c.ext_st='5' or decode(l.rent_l_cd,'',nvl(c.ext_est_dt,a.rent_dt),nvl(k.rent_suc_dt,l.cls_dt))<=nvl(c.ext_est_dt,a.rent_dt)) \n"+
                "        AND a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+) \n"+
                "        AND DECODE(c.ext_st,'1',DECODE(n.rent_mng_id,'','Y','N'),'Y')='Y' \n"+
				"        and decode(c.ext_st,'1',nvl(b.pp_chk,'1'),'1') <> '0' "+ //선납금 매월균등발행은 안함.		
				" ";


		try {
				pstmt = conn.prepareStatement(query);
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

	//		System.out.println("[ScdMngDatabase:getGrtScdContList]\n"+query);
			
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getGrtScdContList]\n"+e);
			System.out.println("[ScdMngDatabase:getGrtScdContList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
	 *	수시발행 - 단기대여 스케줄
	 */
	public Vector getSRentScdList(String s_br, String client_id, String tax_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//단기대여,보험대차,(구)월렌트

		query = " select"+
				"        b.pay_dt as dt1, b.est_dt as dt2, b.*, a.brch_id, a.car_mng_id, a.cust_st,"+
				"        decode(a.cust_st,'1',c.client_id,d.user_id) client_id, decode(a.cust_st,'1',c.firm_nm,d.user_nm) firm_nm,"+
				"        decode(a.rent_st,'1','단기대여','9','보험대차','12','월렌트','2','정비대차') rent_st_nm, a.rent_st, e.car_no, e.car_nm, a.deli_dt, a.ret_dt,"+
				"        decode(b.rent_st,'1','예약금','2','선수대여료','3','대여료','4','정산금','5','연장대여료') scd_rent_st_nm, "+
				"        (b.rent_s_amt+b.rent_v_amt) rent_amt, b.rent_st as scd_rent_st "+
				" from   rent_cont a, scd_rent b, client c, users d, car_reg e,"+
				"        (select a.rent_l_cd, a.rent_st, a.tm, MAX(b.tax_dt) tax_dt, SUM(a.item_supply) rent_s_amt from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st<>'C' and a.gubun in ('9','10','16','17') group by a.rent_l_cd, a.rent_st, a.tm) f"+
				" where  a.rent_st<>'2' and a.use_st not in ('5') and a.rent_s_cd=b.rent_s_cd "+
				"        and a.rent_st||nvl(b.paid_st,'1') not in ('122') "+ //월렌트신용카드는 제외
				"        and a.rent_st||nvl(b.rent_st,'1') not in ('126','127') "+ //월렌트보증금, 월렌트연체이자는 제외
				"        and a.cust_id=c.client_id(+)"+
				"        and a.cust_id=d.user_id(+)"+
				"        and a.car_mng_id=e.car_mng_id"+
				"        and b.rent_s_amt<>0 and nvl(b.bill_yn,'Y')='Y'"+
				"        and b.rent_s_cd=f.rent_l_cd(+) and b.tm=f.tm(+) and b.rent_st=f.rent_st(+) and b.rent_s_amt=f.rent_s_amt(+) "+
				"        and b.rent_v_amt<>0 "+ //부가세 있을때만
				" ";

		if(!s_br.equals(""))		query += " and a.brch_id like '"+s_br+"%'";

		if(!client_id.equals(""))	query += " and decode(a.cust_st,'1',c.client_id,d.user_id)='"+client_id+"'";

		if(tax_yn.equals("N"))		query += " and f.rent_l_cd is null";

		//이전데이타 일괄정리		
		query += " and nvl(b.est_dt,'99999999') > '20201231' and a.rent_s_cd not in ('016342','026237','028413')";
		

		//정비대차

		query += " union all "+
				" select"+
				"        b.pay_dt as dt1, b.est_dt as dt2, b.*, a.brch_id, a.car_mng_id, a.cust_st,"+
				"        decode(a.cust_st,'1',c.client_id,d.user_id) client_id, decode(a.cust_st,'1',c.firm_nm,d.user_nm) firm_nm,"+
				"        decode(a.rent_st,'1','단기대여','9','보험대차','12','월렌트','2','정비대차') rent_st_nm, a.rent_st, e.car_no, e.car_nm, a.deli_dt, a.ret_dt,"+
				"        decode(b.rent_st,'1','예약금','2','선수대여료','3','대여료','4','정산금','5','연장대여료') scd_rent_st_nm, "+
				"        (b.rent_s_amt+b.rent_v_amt) rent_amt, b.rent_st as scd_rent_st "+
				" from   rent_cont a, scd_rent b, client c, users d, car_reg e,"+
				"        (select a.rent_l_cd, a.rent_st, a.tm, MAX(b.tax_dt) tax_dt, SUM(a.item_supply) rent_s_amt from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st<>'C' and a.gubun in ('9','10','16','17') group by a.rent_l_cd, a.rent_st, a.tm) f"+
				" where  a.rent_st='2' and a.use_st not in ('5') and a.rent_s_cd=b.rent_s_cd "+
				"        and a.cust_id=c.client_id(+)"+
				"        and a.cust_id=d.user_id(+)"+
				"        and a.car_mng_id=e.car_mng_id"+
				"        and b.rent_s_amt<>0 and nvl(b.bill_yn,'Y')='Y'"+
				"        and b.rent_s_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+) "+
				"        and b.rent_v_amt<>0 "+ //부가세 있을때만
				" ";

		if(!s_br.equals(""))		query += " and a.brch_id like '"+s_br+"%'";

		if(!client_id.equals(""))	query += " and decode(a.cust_st,'1',c.client_id,d.user_id)='"+client_id+"'";

		if(tax_yn.equals("N"))		query += " and f.rent_l_cd is null";



		query += " order by 1 desc, 2 desc";

		try {
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getSRentScdList]\n"+e);
			System.out.println("[ScdMngDatabase:getSRentScdList]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	수시발행 - 매각 스케줄
	 */
	public Vector getOfflsScdList(String s_br, String client_id, String pay_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.car_no, b.car_nm, b.off_ls, nvl(c.firm_nm,a.sui_nm) firm_nm, c.client_nm, \n"+
				" decode(i.car_mng_id,'',decode(instr(c.firm_nm||a.relation,'매매'),0,decode(c.client_st,'1','법인','개인'),'매매업자'),'거래처') client_st_nm, \n"+
				" decode(e.car_mng_id,'',decode(i.car_mng_id,'','임의계약','매입옵션'),'경매') offls_st_nm, \n"+
				" g.actn_id, decode(e.car_mng_id,'','',h.firm_nm) as actn_nm,  text_decrypt(a.ssn, 'pw') ssn,   text_decrypt(a.car_ssn, 'pw') car_ssn,  a.* \n"+
				" from sui a, car_reg b, client c,  \n"+
				"	   (select car_mng_id, max(seq) seq from auction where actn_st='4' group by car_mng_id) e, \n"+
				"	   apprsl g, client h,  \n"+
				"      (select a.car_mng_id, SUM(b.tax_supply) tax_supply from tax_item_list a, tax b WHERE a.gubun='6' and a.item_id=b.item_id and b.tax_st<>'C' GROUP BY a.car_mng_id HAVING SUM(b.tax_supply)>0) j, \n"+
				"	   (select a.car_mng_id from cont a, cls_cont b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.cls_st='8') i, \n"+
				"      (select a.car_mng_id, SUM(a.tax_supply) tax_supply from tax a where a.tax_st<>'C' and a.tax_g like '%매각%' GROUP BY a.car_mng_id HAVING SUM(a.tax_supply)>0) k \n"+
				" where a.car_mng_id=b.car_mng_id \n"+
				" and b.off_ls in ('0','4','5','6') and b.car_mng_id not in ('008975')  \n"+  //008975:수출- 계산서 발행안함.(자산은 폐차로 처리)
				" and a.client_id=c.client_id(+) \n"+
				" and a.car_mng_id=e.car_mng_id(+) \n"+
				" and a.car_mng_id=g.car_mng_id(+) \n"+
				" and g.actn_id=h.client_id(+) \n"+
				" and a.mm_pr > 0  \n"+  //매각액이 0보다 큰것
				" and a.car_mng_id=i.car_mng_id(+) \n"+
				" and a.car_mng_id=j.car_mng_id(+) and j.car_mng_id is null \n"+
				" and a.car_mng_id=k.car_mng_id(+) \n";


		if(!client_id.equals(""))	query += " and a.client_id='"+client_id+"'";

		if(pay_yn.equals("N"))		query += " and k.car_mng_id is null";

		//이전데이타 일괄정리
		query += " and nvl(a.cont_dt,'99999999') > '20201231'";


		query += " order by a.cont_dt";

		try {

				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getOfflsScdList]\n"+e);
			System.out.println("[ScdMngDatabase:getOfflsScdList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	수시발행 - 기타(차량수리비) 스케줄 - 통합발행되는 경우도 있음 :tax-> tax_item_list로 수정 2009-09-14
	 */
	public Vector getAccidServScdList(String s_br, String client_id, String tax_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" '면책금' st_nm, c.brch_id, c.r_site as site_id,"+
				" decode(a.rent_s_cd,'',d.client_id,j.client_id) client_id, "+
				" decode(a.rent_s_cd,'',d.firm_nm,j.firm_nm) firm_nm,"+
				" e.car_no, e.car_nm, a.accid_dt, f.off_nm,"+
				" b.*"+
				" from service b, accident a, cont c, client d, car_reg e, serv_off f,"+
							  //20110330 거래명세서&세금계산서
					 "        ( select a.rent_l_cd, a.car_mng_id, a.tm, sum(item_supply+item_value) item_amt, \n"+
					 "                 min(b.item_id) item_id, min(b.item_dt) item_dt, min(b.tax_est_dt) tax_est_dt, \n"+
					 "                 min(c.tax_no) tax_no, min(c.tax_dt) tax_dt, min(c.reg_dt) reg_dt, min(c.print_dt) print_dt \n"+
					 "          from   tax_item_list a, tax_item b, tax c \n"+
					 "          where  a.gubun='7' \n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id and nvl(c.tax_st,'O')<>'C' \n"+
					 "          group by a.rent_l_cd, a.car_mng_id, a.tm \n"+
					 "	      ) k, \n"+
				" rent_cont i, client j"+
				" where b.car_mng_id=a.car_mng_id(+) and b.accid_id=a.accid_id(+) and nvl(b.bill_doc_yn,'1')='1'"+
				" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
				" and c.client_id=d.client_id"+
				" and b.car_mng_id=e.car_mng_id(+)"+
				" and b.serv_id=f.off_id(+)"+
				" and a.rent_s_cd=i.rent_s_cd(+) and i.cust_id=j.client_id(+)"+
				" and b.cust_amt <>0 and nvl(b.no_dft_yn,'N')<>'Y' and nvl(b.bill_yn,'Y')='Y'"+
				" and b.rent_l_cd=k.rent_l_cd(+) and b.serv_id=k.tm(+) and b.car_mng_id=k.car_mng_id(+) and b.cust_amt=k.item_amt(+)";//


		if(!s_br.equals(""))		query += " and c.brch_id like '"+s_br+"%'";

		if(!client_id.equals(""))	query += " and decode(a.rent_s_cd,'',d.client_id,j.client_id)='"+client_id+"'";

		if(tax_yn.equals("N"))		query += " and k.tm is null";

		//이전데이타 일괄정리
		query += " and a.accid_dt > '20201231'";

		//직접발행분 제외
		query += " and b.rent_l_cd||b.serv_id not in ('S110HYFR00397000001','B106KNPL00002000002','S107DTLS00050000001','S108YCHR00034000026','S108YCHR00034000024','D108SL5S00063000001','S110KK5R00082000002','S112KK7R00048000002','S111HYFR00365000006')";

		//타시스템발행 제외
		query += " and decode(a.rent_s_cd,'',nvl(d.print_st,'0'),nvl(j.print_st,'0'))<>'9'";

                  //두바이카 정보제공 면책금은 하단으로 
		query += " order by  decode(b.car_mng_id||b.accid_id  , '005938014279' , 1, 0) ,  a.accid_dt, b.cust_req_dt";

		try {
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getAccidServScdList]\n"+e);
			System.out.println("[ScdMngDatabase:getAccidServScdList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	수시발행 - 대차료 스케줄
	 */
	public Vector getMyAccidLScdList(String s_br, String client_id, String tax_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" decode(b.req_gu,'1','휴차료','2','대차료') st_nm, c.rent_mng_id, c.rent_l_cd, c.brch_id, d.client_id, c.r_site as site_id, d.firm_nm, e.car_no, e.car_nm,"+
				" a.accid_dt, f.ot_ins, f.ot_num, decode(a.accid_st,'1','피해자','2','가해자','3','쌍방','4','운행자차','5','사고자차') accid_st,"+
				" b.*, b.car_no as d_car_no, b.car_nm as d_car_nm"+
				" from accident a, my_accid b, cont c, client d, car_reg e, ot_accid f, "+
				" (select sub_c_id, accid_id from rent_cont where rent_st='3' group by sub_c_id, accid_id) g, car_reg h,"+
				" (select * from tax_item_list where gubun in ('11','12')) k"+
				" where b.req_st<>'0' and b.req_gu='2' and b.req_amt <>0 and b.pay_amt=0"+
				" and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id"+
				" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
				" and c.client_id=d.client_id"+
				" and a.car_mng_id=e.car_mng_id(+)"+
				" and a.car_mng_id=f.car_mng_id(+) and a.accid_id=f.accid_id(+)"+
				" and a.car_mng_id=g.sub_c_id(+) and a.accid_id=g.accid_id(+)"+
				" and g.sub_c_id=h.car_mng_id(+)"+	
				" and a.car_mng_id=k.car_mng_id(+) and a.accid_id=k.tm(+)";

		if(!s_br.equals(""))		query += " and c.brch_id like '"+s_br+"%'";

		if(!client_id.equals(""))	query += " and c.client_id='"+client_id+"'";

		if(tax_yn.equals("N"))		query += " and k.car_mng_id is null ";

		//이전데이타 일괄정리
		query += " and b.req_dt>'20051130'";

		query += " order by b.req_dt desc";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getMyAccidLScdList]\n"+e);
			System.out.println("[ScdMngDatabase:getMyAccidLScdList]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	수시발행 - 대차료 스케줄
	 */
	public Vector getMyAccidLScdTaxList(String s_br, String client_id, String tax_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" decode(b.req_gu,'1','휴차료','2','대차료') st_nm, c.rent_mng_id, c.rent_l_cd, c.brch_id, "+
				" decode(c.car_st,'2','보유차','') rent_cont_st, "+
				" decode(a.rent_s_cd, '',d.client_id, decode(g2.cust_st,'1',d2.client_id,u.user_id)) client_id, "+
				" decode(a.rent_s_cd, '',c.r_site) as site_id, "+
				" decode(a.rent_s_cd, '',d.firm_nm, decode(g2.cust_st,'1',d2.firm_nm,u.user_nm)) firm_nm, a.rent_s_cd, g2.cust_st, "+
				" e.car_no, e.car_nm, \n"+
				" a.accid_dt,  "+
				" decode(a.accid_st,'1','피해자','2','가해자','3','쌍방','4','운행자차','5','사고자차') accid_st, \n"+
				" b.*, (b.mc_s_amt+b.mc_v_amt) mc_amt, b.car_no as d_car_no, b.car_nm as d_car_nm, h2.ext_pay_amt-nvl(i.tax_amt,0) as ext_pay_amt, h2.ext_pay_dt \n"+
				" from accident a, my_accid b, cont c, client d, car_reg e, \n"+
				"      (select sub_c_id, accid_id from rent_cont where rent_st='3' group by sub_c_id, accid_id) g, car_reg h, \n"+
				"      (select * from tax_item_list where gubun in ('11','12')) k, \n"+
				"      (select a.car_mng_id, a.fee_tm, b.rent_seq, sum(a.tax_supply+a.tax_value) tax_amt "+
				"       from   tax a, tax_item_list b "+
				"       where  a.gubun in ('11','12') and a.tax_st<>'C' and a.item_id=b.item_id "+
				"       group by a.car_mng_id, a.fee_tm, b.rent_seq "+
		        "      ) i, \n"+
				"      (select car_mng_id, tm, rent_seq, max(reg_code) reg_code from tax_item_list group by car_mng_id, tm, rent_seq) j, \n"+
				"      rent_cont g2, client d2, users u, "+
				"      (select b.car_mng_id, a.ext_id, sum(a.ext_pay_amt) ext_pay_amt, max(ext_pay_dt) ext_pay_dt "+
				"       from   scd_ext a, cont b "+
				"       where  a.ext_st='6' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				"       group by b.car_mng_id, a.ext_id "+
				"      ) h2 "+
				" where b.mc_s_amt <>0"+
				" and nvl(b.pay_gu,'0')<>'1' \n"+
				" and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id \n"+
				" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				" and c.client_id=d.client_id \n"+
				" and a.car_mng_id=e.car_mng_id(+)\n"+
				" and a.car_mng_id=g.sub_c_id(+) and a.accid_id=g.accid_id(+)\n"+
				" and g.sub_c_id=h.car_mng_id(+)\n"+	
				" and b.car_mng_id=k.car_mng_id and b.accid_id=k.tm and b.seq_no=k.rent_seq\n"+
				" and b.car_mng_id=i.car_mng_id(+) and b.accid_id=i.fee_tm(+) and b.seq_no=i.rent_seq(+) \n"+
				" and k.car_mng_id=j.car_mng_id and k.tm=j.tm and k.rent_seq=j.rent_seq and k.reg_code=j.reg_code\n"+
				" and a.rent_s_cd=g2.rent_s_cd(+)"+
				" and g2.cust_id=d2.client_id(+) and g2.cust_id=u.user_id(+) "+		
				" and b.car_mng_id=h2.car_mng_id and b.accid_id||b.seq_no=h2.ext_id and h2.ext_pay_amt > 0 "+		
                " and a.car_mng_id||a.accid_id not in ('009462016585')"+ 
                " and nvl(b.ins_com,'보험사') <>'가해자' "+
				" ";

		if(!s_br.equals(""))		query += " and c.brch_id like '"+s_br+"%'";

		if(!client_id.equals(""))	query += " and c.client_id='"+client_id+"'";

		if(tax_yn.equals("N"))		query += " and (i.car_mng_id is null or nvl(i.tax_amt,0) < h2.ext_pay_amt) AND CASE WHEN c.car_st ='2' AND g.accid_id IS NULL and b.accid_id is null THEN 'N' ELSE 'Y' END ='Y' ";


		//이전데이타 일괄정리(20130423)
		query += " and nvl(b.pay_dt,b.req_dt)>='20130101'";

		query += " order by h2.ext_pay_dt desc, b.pay_dt, b.req_dt desc";

		try {
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getMyAccidLScdTaxList]\n"+e);
			System.out.println("[ScdMngDatabase:getMyAccidLScdTaxList]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	수시발행 - 휴차료 스케줄
	 */
	public Vector getMyAccidRScdList(String s_br, String client_id, String tax_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" '휴차료' st_nm, c.rent_mng_id, c.rent_l_cd, c.brch_id, d.client_id, c.r_site as site_id, d.firm_nm, e.car_no, e.car_nm,"+
				" a.accid_dt, f.ot_ins, f.ot_num, decode(a.accid_st,'1','피해자','2','가해자','3','쌍방','4','운행자차','5','사고자차') accid_st,"+
				" b.*, b.car_no as d_car_no, b.car_nm as d_car_nm"+
				" from accident a, my_accid b, cont c, client d, car_reg e, ot_accid f, "+
				" (select sub_c_id, accid_id from rent_cont where rent_st='3' group by sub_c_id, accid_id) g, car_reg h,"+
				" (select * from tax_item_list where gubun in ('11','12')) k"+
				" where b.req_st<>'0' and b.req_gu='1' and b.req_amt <>0 and b.pay_amt=0 "+
				" and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id"+
				" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
				" and c.client_id=d.client_id"+
				" and a.car_mng_id=e.car_mng_id(+)"+
				" and a.car_mng_id=f.car_mng_id and a.accid_id=f.accid_id"+
				" and a.car_mng_id=g.sub_c_id(+) and a.accid_id=g.accid_id(+)"+
				" and g.sub_c_id=h.car_mng_id(+)"+	
				" and a.rent_l_cd=k.rent_l_cd(+) and a.car_mng_id=k.car_mng_id(+) and a.accid_id=k.tm(+)";

		if(!s_br.equals(""))		query += " and c.brch_id like '"+s_br+"%'";

		if(!client_id.equals(""))	query += " and c.client_id='"+client_id+"'";

		if(tax_yn.equals("N"))		query += " and k.car_mng_id is null ";

		//이전데이타 일괄정리
		query += "  and req_dt>'20101231'";

		query += " order by b.req_dt desc";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getMyAccidRScdList]\n"+e);
			System.out.println("[ScdMngDatabase:getMyAccidRScdList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	수시발행 - 중도해지 스케줄
	 */
	public Vector getClsContScdList(String s_br, String rent_l_cd, String tax_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" '해지정산' st_nm, c.rent_l_cd, c.brch_id, d.client_id, c.r_site as site_id, d.firm_nm, e.car_no, e.car_nm,"+
				" a.*"+
				" from cls_cont a, cont c, client d, car_reg e,"+
				" (select aa.* from tax aa where aa.tax_st='O' and aa.tax_g like '%해지%위약금%' and aa.tax_supply <> 0) k"+
				" where a.cls_st in ('1','2') and  a.fdft_amt2 > 0 "+
				" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
				" and c.client_id=d.client_id"+
				" and c.car_mng_id=e.car_mng_id(+)"+
				" and c.client_id=k.client_id(+) and c.rent_l_cd=k.rent_l_cd(+) and k.rent_l_cd is null";

		if(!s_br.equals(""))		query += " and c.brch_id like '"+s_br+"%'";

		if(!rent_l_cd.equals(""))	query += " and c.rent_l_cd='"+rent_l_cd+"'";

		//이전데이타 일괄정리
		query += " and a.cls_dt > '20201231'";

		query += " order by a.cls_dt desc";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getClsContScdList]\n"+e);
			System.out.println("[ScdMngDatabase:getClsContScdList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	수시발행 - 업무대여 스케줄
	 */
	public Vector getUserRentScdList(String s_br, String tax_dt, String tax_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"        '업무대여' st_nm, b.user_id, b.user_nm, TEXT_DECRYPT(b.user_ssn, 'pw' ) user_ssn, c.br_nm, d.nm, b.user_pos, f.car_mng_id, f.car_no, f.car_nm, f.car_use, "+
				"        case when to_date(b.enter_dt,'YYYYMMDD') < to_date('"+tax_dt+"01','YYYYMMDD')  then 100000 else "+
                "                  trunc(100000/30*(to_date('"+tax_dt+"'||to_char(last_day(to_date('"+tax_dt+"01','YYYYMMDD')),'DD'),'YYYYMMDD')-to_date(b.enter_dt,'YYYYMMDD')+1),-3) "+
                "        end amt "+
				" from"+
				"        ( select cust_id, max(rent_s_cd) rent_s_cd "+
				"          from   rent_cont where rent_st='4' and cust_st='4' and use_st <>'5' "+
				"          and    substr(deli_dt,0,6) <= '"+tax_dt+"' and substr(nvl(ret_dt,'"+tax_dt+"'),0,6) >= '"+tax_dt+"'  "+ 
				"          group by cust_id"+
				"        ) a,"+
				"        users b, branch c, (select * from code where c_st='0002') d, rent_cont e, car_reg f,"+
				"        (select * from tax where gubun='13' and tax_st<>'C' and substr(tax_dt,0,6) = '"+tax_dt+"') g,"+
				"        (select * from us_me_w where w_nm like '%차량등록%') w, " +
				"        (select user_id from us_me_w where w_nm like '%지점장%' AND w_st='solo' GROUP BY user_id) w2 " +
				" where  a.cust_id=b.user_id and b.br_id=c.br_id and b.dept_id=d.code"+
				" AND    b.user_pos NOT IN ('대표이사') "+
				" and    a.rent_s_cd=e.rent_s_cd and a.cust_id=e.cust_id and e.cust_st='4'"+
				" and    e.car_mng_id=f.car_mng_id"+
				" and    b.user_id=g.client_id(+) and g.client_id is null"+
				" and    b.user_id=w.user_id(+)"+
				" and    b.user_id=w2.user_id(+)"+
				" ";

		if(!s_br.equals(""))		query += " and b.br_id like '"+s_br+"%'";

		query += " order by decode(b.br_id,'S1',1,'B1',2,'S2',3),"+
				" decode(b.dept_id,'0004',1,2), b.dept_id,"+
				" decode(b.user_pos,'과장','1','대리','2','사원','3','0'),"+
				" b.enter_dt";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getUserRentScdList]\n"+e);
			System.out.println("[ScdMngDatabase:getUserRentScdList]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}


	/**
	 *	매출취소 - 매출취소를 위한 발행 리스트
	 */
	public Vector getTaxCancelList(String s_br, String client_id, String rent_l_cd, String tax_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, (a.tax_supply+a.tax_value) tax_amt, b.cnt"+
				" from tax a, (select item_id, count(0) cnt from tax_item_list group by item_id) b"+
				" where a.m_tax_no is null";

		if(!s_br.equals(""))		query += " and a.branch_g like '"+s_br+"%'";

		if(rent_l_cd.equals(""))	query += " and a.client_id='"+client_id+"'";
		else						query += " and a.rent_l_cd='"+rent_l_cd+"'";

		if(!tax_st.equals(""))		query += " and a.tax_st='"+tax_st+"'";

		if(tax_st.equals("O"))		query += " and a.tax_supply > 0";

		query += " and a.item_id=b.item_id(+)";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxCancelList]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxCancelList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	거래명세서변경 - 거래명세서변경를 위한 발행 리스트
	 */
	public Vector getTaxCngList(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" b.firm_nm, (a.tax_supply+a.tax_value) tax_amt, a.*"+
				" from tax a, client b, cont c, car_reg d"+
				" where a.tax_st='O' and a.m_tax_no is null"+
				" and a.client_id=b.client_id"+
				" and a.rent_l_cd=c.rent_l_cd(+)"+
				" and c.car_mng_id=d.car_mng_id(+)";

		if(!s_br.equals(""))	query += " and a.branch_g like '"+s_br+"%'";

		if(s_kd.equals("1"))		query += " and a.tax_no='"+t_wd+"'";
		if(s_kd.equals("2"))		query += " and a.firm_nm='"+t_wd+"'";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getTaxCngList]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxCngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	세금계산서 보관함 리스트 조회
	 */
	public Vector getTaxMngList(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        nvl(a.recconame,decode(a.gubun,'13',g.user_nm,b.firm_nm)) firm_nm, \n"+
				"        substr(nvl(a.recconame,decode(a.gubun,'13',g.user_nm,b.firm_nm)),1,15) firm_nm2, \n"+
				"        nvl(a.reccoceo,decode(a.gubun,'13','-',b.client_nm)) client_nm, \n"+
				"        nvl(a.reccoregno,decode(a.gubun,'13',TEXT_DECRYPT(g.user_ssn, 'pw' ) , decode(a.tax_type,'1',b.enp_no,'2',nvl(TEXT_DECRYPT(f.enp_no, 'pw' )  ,b.enp_no)))) enp_no, \n"+
			    "        nvl(a.reccossn,decode(a.gubun,'13',TEXT_DECRYPT(g.user_ssn, 'pw' ), TEXT_DECRYPT(b.ssn, 'pw' ))) ssn,  \n"+
				"        (a.tax_supply+a.tax_value) tax_amt, a.*,\n"+
				"        substr(a.mail_dt,1,12) mail_dt, h.pubcode, decode(j.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','66','공급자발행취소요청','99','발급취소','11','중복데이타','12','ID불일치','13','인증서불일치','14','기타에러',decode(a.resseq,'','','대기')) status, \n"+
				"        sign(to_date('20060430','YYYYMMDD')-to_date(tax_dt,'YYYYMMDD')) ebill_yn,\n"+
				"        a.gubun, b.etax_not_cau, k.user_nm as bus_nm2, l.stime, b.con_agnt_email as con_agnt_email2, b.con_agnt_m_tel as con_agnt_m_tel2 \n"+
				" from   tax a, (select * from tax_item_list where item_seq=1) n,  \n"+
				"        client b, cont c, car_reg d, (select * from scd_fee where tm_st1='0') e, client_site f, users g,  \n"+
				"        saleebill h, eb_status i, \n"+
				"        ( select a.pubcode, a.status, rownum seq  \n"+
				"          from   eb_history a, (select pubcode, max(statusdate||status) statusdate from eb_history where status not in ('11','14') group by pubcode) b  \n"+
				"          where  a.status not in ('11','14') and a.pubcode=b.pubcode and a.statusdate||a.status=b.statusdate  \n"+
				"        ) j,\n"+
				"        users k, \n"+
				"        ( select a.tax_no, decode(c.gubun,'',b.gubun,c.gubun) gubun, decode(c.gubun,'',b.email,c.email) email, decode(c.gubun,'',b.stime,c.stime) stime \n"+
				"	       from   \n"+
				"	              ( select a.tax_no, a.con_agnt_email, b.reg_code \n"+
				"	                from   tax a, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) b \n"+
				"	                where  a.item_id=b.item_id(+) \n"+
				"	              ) a,\n"+
				"	              (select a.gubun, b.email, max(b.stime) stime from im_dmail_info_2 a, im_dmail_result_2 b where a.seqidx=b.dmidx group by a.gubun, b.email) b,\n"+
				"	              (select a.gubun, b.email, max(b.stime) stime from im_dmail_info_2 a, im_dmail_result_2 b where a.seqidx=b.dmidx group by a.gubun, b.email) c \n"+
				"	       where  a.reg_code=b.gubun(+) and a.con_agnt_email=b.email(+) \n"+
				"	              and a.tax_no=c.gubun(+)  and a.con_agnt_email=c.email(+) \n"+
				"	              and nvl(c.gubun,b.gubun) is not null  \n"+
				"        ) l  \n"+
				"  \n"+
				" where \n"+
				"        a.item_id=n.item_id(+)"+
				"        and a.client_id=b.client_id(+)\n"+
				"        and a.rent_l_cd=c.rent_l_cd(+) \n"+
				"        and c.car_mng_id=d.car_mng_id(+) \n"+
				"        and a.client_id=g.user_id(+) \n"+
				"        and n.rent_l_cd=e.rent_l_cd(+) and n.tm=e.fee_tm(+) and n.rent_st=e.rent_st(+) and n.rent_seq=e.rent_seq(+)\n"+
				"        and a.client_id=f.client_id(+) and a.seq=f.seq(+) \n"+
				"        and a.resseq=h.resseq(+) and h.pubcode=i.pubcode(+) and h.pubcode=j.pubcode(+) and nvl(c.bus_id2,c.bus_id)=k.user_id(+) and a.tax_no=l.tax_no(+) \n"+
				" ";

		if(!s_br.equals(""))	query += " and a.branch_g like '"+s_br+"%' \n";


			//기간구분
			if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.tax_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n";
			if(gubun1.equals("2") && !st_dt.equals(""))		query += " and nvl(a.reg_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n";
			if(gubun1.equals("3") && !st_dt.equals(""))		query += " and nvl(a.print_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n";
			if(gubun1.equals("4") && !st_dt.equals(""))		query += " and e.r_req_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n";

			//발행구분
			if(chk1.equals("1"))		query += " and a.tax_g like '대여료%' and a.tax_st='O' \n";
			if(chk1.equals("2"))		query += " and a.tax_g not like '대여료%' and a.tax_st='O' \n";
			if(chk1.equals("3"))		query += " and (a.tax_st='M' or a.m_tax_no is not null) \n";
			if(chk1.equals("4"))		query += " and a.tax_st='C' \n";
			if(chk1.equals("5"))		query += " and a.tax_st='O' \n";

			//품목구분
			if(chk2.equals("1"))		query += " and a.tax_g like '대여료%' \n";
			if(chk2.equals("2"))		query += " and substr(a.tax_g,1,3) in ('선납금','개시대','대차료') \n";
			if(chk2.equals("4"))		query += " and a.tax_g like 'Self%' \n";
			if(chk2.equals("5"))		query += " and a.tax_g like '보험대차%' \n";
			if(chk2.equals("6"))		query += " and a.tax_g like '차량매각%' \n";
			if(chk2.equals("7"))		query += " and a.tax_g like '차량수리%' \n";
			if(chk2.equals("8"))		query += " and substr(a.tax_g,1,3) in ('사고대','휴차료','대차료') \n";
			if(chk2.equals("9"))		query += " and a.tax_bigo like '%중도해지%' \n";

			//출력여부
			if(chk3.equals("1"))		query += " and a.print_dt is not null \n";
			if(chk3.equals("2"))		query += " and a.print_dt is null \n";

			//자동전표
			if(chk4.equals("1"))		query += " and a.autodocu_write_date is not null \n";
			if(chk4.equals("2"))		query += " and a.autodocu_write_date is null \n";

			//전자세금계산서
			
			if(chk5.equals("Y"))			query += " and a.resseq is not null \n";
			else if(chk5.equals("N"))		query += " and a.resseq is null \n";
			else if(chk5.equals("9"))		query += " ";
			else{ 
				if(!chk5.equals("0"))		query += " and j.status='"+chk5+"' \n";
			}

			//이메일
			if(chk6.equals("P"))			query += " and a.resseq is null \n";
			if(chk6.equals("Y"))			query += " and l.stime is not null \n";
			else if(chk6.equals("N"))		query += " and l.stime is null and b.etax_not_cau is null and a.con_agnt_email is not null and a.print_dt is null \n";
			else if(chk6.equals("NOT"))		query += " and l.stime is null and b.etax_not_cau is not null \n";
			else if(chk6.equals("NO"))		query += " and l.stime is null and b.etax_not_cau is null and b.con_agnt_email is null \n";


			String search = "";
			if(s_kd.equals("1"))		search = "nvl(a.recconame,decode(a.gubun,'13',g.user_nm,b.firm_nm))";
			else if(s_kd.equals("2"))	search = "a.rent_l_cd";
			else if(s_kd.equals("3"))	search = "d.car_no";
			else if(s_kd.equals("4"))	search = "decode(a.gubun,'13', TEXT_DECRYPT(g.user_ssn, 'pw' )  , decode(a.tax_type,'1',b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' )  ,'2', TEXT_DECRYPT(f.enp_no, 'pw' )   ))";
			else if(s_kd.equals("5"))	search = "a.tax_no";
			else if(s_kd.equals("6"))	search = "a.tax_g||a.tax_bigo";
			else if(s_kd.equals("7"))	search = "c.bus_id2";
			else if(s_kd.equals("8"))	search = "b.etax_not_cau";

			if(!search.equals("")){
				if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%') \n";
				if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%' \n";
			}


		if(sort.equals("1"))		query += " order by nvl(a.recconame,decode(a.gubun,'13',g.user_nm,b.firm_nm)) "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by d.car_no "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' )) "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.tax_no "+asc;
		if(sort.equals("5"))		query += " order by a.tax_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by a.reg_dt "+asc+", a.tax_no";
		if(sort.equals("7"))		query += " order by a.print_dt "+asc+", a.tax_no";
		if(sort.equals("8"))		query += " order by c.bus_id2 "+asc+", a.tax_no";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxMngList]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	세금계산서 발행현황 리스트 조회
	 */
	public Vector getTaxStatList(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ leading (A J L) index(a TAX_IDX2)  index(b CLIENT_PK)  */ "+
				" decode(a.gubun,'13',g.user_nm,b.firm_nm) firm_nm,"+
				" substr(decode(a.gubun,'13',g.user_nm,b.firm_nm),1,15) firm_nm2,"+
				" decode(a.gubun,'13','-',b.client_nm) client_nm,"+		
				" decode(a.gubun,'13',TEXT_DECRYPT(g.user_ssn, 'pw' ), decode(a.tax_type,'1',b.enp_no,'2',TEXT_DECRYPT(f.enp_no, 'pw' ) )) enp_no, TEXT_DECRYPT(b.ssn, 'pw' ) ssn, (a.tax_supply+a.tax_value) tax_amt, a.*,"+
				" substr(a.mail_dt,1,12) mail_dt, h.pubcode, decode(j.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','66','공급자발행취소요청','99','발급취소','11','중복데이타','12','ID불일치','13','인증서불일치','14','기타에러',decode(a.resseq,'','','대기')) status,"+
				" sign(to_date('20060430','YYYYMMDD')-to_date(tax_dt,'YYYYMMDD')) ebill_yn,"+
				" b.etax_not_cau, k.user_nm as bus_nm2, l.stime, b.con_agnt_email as con_agnt_email2, b.con_agnt_m_tel as con_agnt_m_tel2"+
				" from tax a, client b, cont c, car_reg d, (select * from scd_fee where tm_st1='0') e, client_site f, users g,"+
				" saleebill h, eb_status i,"+
				" (select a.pubcode, a.status from eb_history a, (select /*+ index(eb_history EB_HISTORY_IDX1 ) */ pubcode, max(statusdate) statusdate from eb_history where status<>'11' group by pubcode) b where a.status<>'11' and a.pubcode=b.pubcode and a.statusdate=b.statusdate) j,\n"+
				" users k,"+
				" (select /*+ leading(A B C) */  a.tax_no, decode(c.gubun,'',b.gubun,c.gubun) gubun, decode(c.gubun,'',b.email,c.email) email, decode(c.gubun,'',b.stime,c.stime) stime"+
				"	from"+
				"	    ( select a.tax_no, a.con_agnt_email, b.reg_code"+
				"	      from tax a, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) b"+
				"	      where a.item_id=b.item_id"+
				"	    ) a,"+
				"	   (select a.gubun, b.email, max(b.stime) stime from im_dmail_info_2 a, im_dmail_result_2 b where a.seqidx=b.dmidx group by a.gubun, b.email) b,"+
				"	   (select a.gubun, b.email, max(b.stime) stime from im_dmail_info_2 a, im_dmail_result_2 b where a.seqidx=b.dmidx group by a.gubun, b.email) c"+
				"	where a.reg_code=b.gubun(+) and a.con_agnt_email=b.email(+)"+
				"	and a.tax_no=c.gubun(+)  and a.con_agnt_email=c.email(+)"+
				"	and nvl(c.gubun,b.gubun) is not null) l"+
				" where"+
				" a.client_id=b.client_id"+
				" and a.rent_l_cd=c.rent_l_cd(+)"+
				" and c.car_mng_id=d.car_mng_id(+)"+
				" and a.client_id=g.user_id(+)"+
				" and a.rent_l_cd=e.rent_l_cd(+) and a.fee_tm=e.fee_tm(+)"+
				" and a.client_id=f.client_id(+) and a.seq=f.seq(+)"+
				" and a.resseq=h.resseq(+) and h.pubcode=i.pubcode(+) and h.pubcode=j.pubcode(+)"+
				" and nvl(c.bus_id2,c.bus_id)=k.user_id(+) and a.tax_no=l.tax_no(+)";

		if(!s_br.equals(""))	query += " and k.br_id like '"+s_br+"%'";

			//기간구분
			if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.tax_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("2") && !st_dt.equals(""))		query += " and nvl(a.reg_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("4") && !st_dt.equals(""))		query += " and e.r_req_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(chk1.equals("5"))		query += " and a.tax_st='O'";

			//전자세금계산서
			if(chk5.equals("Y"))			query += " and a.resseq is not null";
			else{ 
				if(!chk5.equals("0"))		query += " and j.status='"+chk5+"'";
			}

			String search = "";
			if(s_kd.equals("1"))		search = "decode(a.gubun,'13',g.user_nm,b.firm_nm)";
			else if(s_kd.equals("2"))	search = "a.rent_l_cd";
			else if(s_kd.equals("3"))	search = "d.car_no";
			else if(s_kd.equals("4"))	search = "decode(a.gubun,'13',TEXT_DECRYPT(g.user_ssn, 'pw' ), decode(a.tax_type,'1',b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ),'2',TEXT_DECRYPT(f.enp_no, 'pw' ) ))";
			else if(s_kd.equals("5"))	search = "a.tax_no";
			else if(s_kd.equals("6"))	search = "a.tax_g||a.tax_bigo";
			else if(s_kd.equals("7"))	search = "c.bus_id2";
			else if(s_kd.equals("8"))	search = "b.etax_not_cau";

			if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
			if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";


		if(sort.equals("1"))		query += " order by b.firm_nm "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by d.car_no "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' )) "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.tax_no "+asc;
		if(sort.equals("5"))		query += " order by a.tax_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by a.reg_dt "+asc+", a.tax_no";
		if(sort.equals("7"))		query += " order by a.print_dt "+asc+", a.tax_no";
		if(sort.equals("8"))		query += " order by c.bus_id2 "+asc+", b.firm_nm, a.tax_no";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxStatList]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxStatList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	세금계산서 발행현황 리스트 조회
	 */
	public Vector getTaxStatListFms(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" decode(a.gubun,'13',d.user_nm, decode(a.tax_type,'2',c.r_site,b.firm_nm)) firm_nm,"+
				" decode(a.gubun,'13',d.user_ssn,decode(a.tax_type,'2',TEXT_DECRYPT(c.enp_no, 'pw' ) ,nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' ) ))) enp_no,"+
				" (a.tax_supply+a.tax_value) tax_amt,"+
				" decode(a.unity_chk,'0',a.rent_l_cd,'통합발행') unity, e.bus_nm2,"+
				" nvl(g.stime,h.stime) stime, o.statusdate, o.status,"+
				" decode(o.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','66','공급자발행취소요청','99','발급취소','11','중복데이타','12','ID불일치','13','인증서불일치','14','기타에러',decode(a.resseq,'','','대기')) status_nm,"+
				" a.*"+
				" from tax a, client b, client_site c, users d,"+
				" (select a.item_id, max(c.user_nm) bus_nm2, max(b.bus_id2) bus_id2 from tax_item_list a, cont b, users c"+
				"         where a.rent_l_cd=b.rent_l_cd and b.bus_id2=c.user_id group by a.item_id) e,"+
				" (select a.tax_no, a.con_agnt_email, b.reg_code from tax a, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) b"+
				"         where a.item_id=b.item_id) f,"+
				" (select a.gubun, max(b.stime) stime from im_dmail_info_2 a, im_dmail_result_2 b"+
				"         where a.seqidx=b.dmidx group by a.gubun) g,"+
				" (select a.gubun, b.email, max(b.stime) stime from im_dmail_info_2 a, im_dmail_result_2 b"+
				"         where a.seqidx=b.dmidx group by a.gubun, b.email) h,"+
				" saleebill i,"+
				" (select a.resseq, a.pubcode, max(b.statusdate) statusdate from saleebill a, eb_history b"+
				"         where a.pubcode=b.pubcode group by a.resseq, a.pubcode) j,"+
				" eb_history o"+
				" where"+
				" a.client_id=b.client_id"+
				" and a.client_id=c.client_id(+) and a.seq=c.seq(+) "+
				" and a.client_id=d.user_id(+)"+
				" and a.item_id=e.item_id(+)"+
				" and a.tax_no=f.tax_no(+)"+
				" and a.tax_no=g.gubun(+)"+
				" and f.reg_code=h.gubun(+) and f.con_agnt_email=h.email(+)"+
				" and a.resseq=i.resseq(+)"+
				" and i.pubcode=j.pubcode(+)"+
				" and j.statusdate=o.statusdate(+)";

		if(!s_br.equals(""))	query += " and a.branch_g like '"+s_br+"%'";


			//기간구분
			if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.tax_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("2") && !st_dt.equals(""))		query += " and nvl(a.reg_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("3") && !st_dt.equals(""))		query += " and nvl(a.print_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(chk1.equals("5"))		query += " and a.tax_st='O'";

			//전자세금계산서
			if(chk5.equals("Y"))			query += " and a.resseq is not null";
			else{ 
				if(!chk5.equals("0"))		query += " and o.status='"+chk5+"'";
			}

			//우편발송
			if(chk6.equals("P"))			query += " and a.resseq is null";
			else if(chk6.equals("NOT"))		query += " and a.resseq is null and b.etax_not_cau is not null";
			else if(chk6.equals("NO"))		query += " and a.resseq is null and b.etax_not_cau is null and b.con_agnt_email is null";
			else if(chk6.equals("N"))		query += " and a.resseq is null and b.etax_not_cau is null and b.con_agnt_email is not null";


			String search = "";
			if(s_kd.equals("1"))		search = "decode(a.gubun,'13',d.user_nm, decode(a.tax_type,'2',c.r_site,b.firm_nm))";
			else if(s_kd.equals("2"))	search = "a.rent_l_cd";
			else if(s_kd.equals("3"))	search = "a.tax_bigo";
			else if(s_kd.equals("4"))	search = "decode(a.gubun,'13',g.user_ssn, decode(a.tax_type,'1',b.enp_no||b.ssn,'2',f.enp_no))";
			else if(s_kd.equals("5"))	search = "a.tax_no";
			else if(s_kd.equals("6"))	search = "a.tax_g||a.tax_bigo";
			else if(s_kd.equals("7"))	search = "e.bus_id2";
			else if(s_kd.equals("8"))	search = "b.etax_not_cau";

			if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
			if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";


		if(sort.equals("1"))		query += " order by decode(a.gubun,'13',d.user_nm, decode(a.tax_type,'2',c.r_site,b.firm_nm)) "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by a.tax_bigo "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by decode(a.gubun,'13',g.user_ssn, decode(a.tax_type,'1',b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ) ,'2',f.enp_no)) "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.tax_no "+asc;
		if(sort.equals("5"))		query += " order by a.tax_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by a.reg_dt "+asc+", a.tax_no";
		if(sort.equals("7"))		query += " order by a.print_dt "+asc+", a.tax_no";
		if(sort.equals("8"))		query += " order by e.bus_id2 "+asc+", b.firm_nm, a.tax_no";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxStatListFms]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	세금계산서 발행현황 리스트 조회
	 */
	public Hashtable getTaxStat(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String query2 = "";


		query = " select /*+ leading (A J L) index(a TAX_IDX2)  index(b CLIENT_PK)  */ "+
				" decode(a.gubun,'13',g.user_nm,b.firm_nm) firm_nm,"+
				" substr(decode(a.gubun,'13',g.user_nm,b.firm_nm),1,15) firm_nm2,"+
				" decode(a.gubun,'13','-',b.client_nm) client_nm,"+
				" decode(a.gubun,'13', TEXT_DECRYPT(g.user_ssn, 'pw' ) , decode(a.tax_type,'1',b.enp_no,'2', TEXT_DECRYPT(f.enp_no, 'pw' ) )) enp_no, b.ssn, (a.tax_supply+a.tax_value) tax_amt, a.*,"+
				" substr(a.mail_dt,1,12) mail_dt, h.pubcode, decode(j.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','66','공급자발행취소요청','99','발급취소','11','중복데이타','12','ID불일치','13','인증서불일치','14','기타에러',decode(a.resseq,'','','대기')) status,"+
				" sign(to_date('20060430','YYYYMMDD')-to_date(tax_dt,'YYYYMMDD')) ebill_yn,"+
				" b.etax_not_cau, k.user_nm as bus_nm2, l.stime, b.con_agnt_email as con_agnt_email2, b.con_agnt_m_tel as con_agnt_m_tel2"+
				" from tax a, client b, cont c, car_reg d, (select * from scd_fee where tm_st1='0') e, client_site f, users g,"+
				" saleebill h, eb_status i,"+
				" (select a.pubcode, a.status from eb_history a, (select /*+ index(eb_history EB_HISTORY_IDX1 ) */ pubcode, max(statusdate) statusdate from eb_history where status<>'11' group by pubcode) b where a.status<>'11' and a.pubcode=b.pubcode and a.statusdate=b.statusdate) j,\n"+
				" users k,"+
				" (select /*+ leading(A B C) */ a.tax_no, decode(c.gubun,'',b.gubun,c.gubun) gubun, decode(c.gubun,'',b.email,c.email) email, decode(c.gubun,'',b.stime,c.stime) stime"+
				"	from"+
				"	    ( select a.tax_no, a.con_agnt_email, b.reg_code"+
				"	      from tax a, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) b"+
				"	      where a.item_id=b.item_id"+
				"	    ) a,"+
				"	   (select a.gubun, b.email, max(b.stime) stime from im_dmail_info_2 a, im_dmail_result_2 b where a.seqidx=b.dmidx group by a.gubun, b.email) b,"+
				"	   (select a.gubun, b.email, max(b.stime) stime from im_dmail_info_2 a, im_dmail_result_2 b where a.seqidx=b.dmidx group by a.gubun, b.email) c"+
				"	where a.reg_code=b.gubun(+) and a.con_agnt_email=b.email(+)"+
				"	and a.tax_no=c.gubun(+)  and a.con_agnt_email=c.email(+)"+
				"	and nvl(c.gubun,b.gubun) is not null) l"+
				" where"+
				" a.client_id=b.client_id"+
				" and a.rent_l_cd=c.rent_l_cd(+)"+
				" and c.car_mng_id=d.car_mng_id(+)"+
				" and a.client_id=g.user_id(+)"+
				" and a.rent_l_cd=e.rent_l_cd(+) and a.fee_tm=e.fee_tm(+)"+
				" and a.client_id=f.client_id(+) and a.seq=f.seq(+)"+
				" and a.resseq=h.resseq(+) and h.pubcode=i.pubcode(+) and h.pubcode=j.pubcode(+) and nvl(c.bus_id2,c.bus_id)=k.user_id(+) and a.tax_no=l.tax_no(+)";

		if(!s_br.equals(""))	query += " and a.branch_g like '"+s_br+"%'";

			//기간구분
			if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.tax_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("2") && !st_dt.equals(""))		query += " and nvl(a.reg_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("3") && !st_dt.equals(""))		query += " and nvl(a.print_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("4") && !st_dt.equals(""))		query += " and e.r_req_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(chk1.equals("5"))		query += " and a.tax_st='O'";

		query2 =" select "+
				" count(0) t_cnt,"+
				" count(decode(resseq,'','',tax_no)) e_cnt,"+
				" count(decode(resseq,'','',decode(status,'수신자승인',tax_no))) e_cnt1,"+
				" count(decode(resseq,'','',decode(status,'수신자미확인',tax_no))) e_cnt2,"+
				" count(decode(resseq,'','',decode(status,'수신자미승인',tax_no))) e_cnt3,"+
				" count(decode(resseq,'','',decode(status,'수신거부',tax_no))) e_cnt4,"+
				" count(decode(resseq,'','',decode(status,'수신자발행취소요청',tax_no))) e_cnt5,"+
				" count(decode(resseq,'','',decode(status,'발급취소',tax_no))) e_cnt6,"+
				" count(decode(resseq,'',tax_no)) p_cnt,"+
				" count(decode(resseq,'',decode(etax_not_cau,'','',tax_no))) p_cnt1,"+
				" count(decode(resseq,'',decode(etax_not_cau,'',decode(con_agnt_email2,'',tax_no)))) p_cnt2,"+
				" count(decode(resseq,'',decode(etax_not_cau,'',decode(con_agnt_email2,'','',tax_no)))) p_cnt3"+
				" from ( "+query+" )";

		try {
				pstmt = conn.prepareStatement(query2);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxStat]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxStat]\n"+query2);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	세금계산서 보관함 리스트 조회
	 */
	public Vector getTaxMngListExcel(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" c.p_zip, decode(a.gubun,'13',g.user_nm,b.firm_nm) firm_nm"+
				" from tax a, client b, cont c, car_reg d, (select * from scd_fee where tm_st1='0') e, client_site f, users g"+
				" where"+
				" a.client_id=b.client_id"+
				" and a.rent_l_cd=c.rent_l_cd(+)"+
				" and c.car_mng_id=d.car_mng_id(+)"+
				" and a.client_id=g.user_id(+)"+
				" and a.rent_l_cd=e.rent_l_cd(+) and a.fee_tm=e.fee_tm(+)"+
				" and a.client_id=f.client_id(+) and a.seq=f.seq(+) and nvl(a.gubun,'1')<>'13'";

		if(!s_br.equals(""))	query += " and a.branch_g like '"+s_br+"%'";


			//기간구분
			if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.tax_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("2") && !st_dt.equals(""))		query += " and nvl(a.reg_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("3") && !st_dt.equals(""))		query += " and nvl(a.print_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("4") && !st_dt.equals(""))		query += " and e.r_req_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			//발행구분
			if(chk1.equals("1"))		query += " and a.tax_g like '대여료%' and a.tax_st='O'";
			if(chk1.equals("2"))		query += " and a.tax_g not like '대여료%' and a.tax_st='O'";
			if(chk1.equals("3"))		query += " and (a.tax_st='M' or a.m_tax_no is not null)";
			if(chk1.equals("4"))		query += " and a.tax_st='C'";

			//품목구분
			if(chk2.equals("1"))		query += " and a.tax_g like '대여료%'";
			if(chk2.equals("2"))		query += " and substr(a.tax_g,1,3) in ('선납금','개시대','대차료')";
			if(chk2.equals("4"))		query += " and a.tax_g like 'Self%'";
			if(chk2.equals("5"))		query += " and a.tax_g like '보험대차%'";
			if(chk2.equals("6"))		query += " and a.tax_g like '차량매각%'";
			if(chk2.equals("7"))		query += " and a.tax_g like '차량수리%'";
			if(chk2.equals("8"))		query += " and substr(a.tax_g,1,3) in ('사고대','휴차료','대차료')";
			if(chk2.equals("9"))		query += " and a.tax_bigo like '%중도해지%'";

			//출력여부
			if(chk3.equals("1"))		query += " and a.print_dt is not null";
			if(chk3.equals("2"))		query += " and a.print_dt is null";


			String search = "";
			if(s_kd.equals("1"))		search = "b.firm_nm";
			else if(s_kd.equals("2"))	search = "a.rent_l_cd";
			else if(s_kd.equals("3"))	search = "d.car_no";
			else if(s_kd.equals("4"))	search = "b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ) ";
			else if(s_kd.equals("5"))	search = "a.tax_no";
			else if(s_kd.equals("6"))	search = "a.tax_g||a.tax_bigo";

			if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
			if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";


		if(sort.equals("1"))		query += " order by b.firm_nm "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by c.car_no "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' ) ) "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.tax_no "+asc;
		if(sort.equals("5"))		query += " order by a.tax_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by a.reg_dt "+asc+", a.tax_no";
		if(sort.equals("7"))		query += " order by a.print_dt "+asc+", a.tax_no";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxMngListExcel]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxMngListExcel]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	세금계산서 합계표 리스트 조회
	 */
	public Vector getTaxHapList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String orderby1 = "decode(nvl(a.reccoregnotype,decode(length(nvl(a.reccoregno,a.reccossn)),10,'01','02')),'01','1','2')";
		String orderby2 = "decode(nvl(a.reccoregno,a.reccossn),'',decode(a.gubun,'13', TEXT_DECRYPT(u.user_ssn, 'pw' )  , decode(nvl(a.tax_type,'1'),'1',nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' ) ),nvl( TEXT_DECRYPT(c.enp_no, 'pw' ) ,nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' ) )))),'0000000000',a.reccossn,nvl(a.reccoregno,a.reccossn))";

		query = " select \n"+
				"        "+orderby1+" client_st,  \n"+
				"        "+orderby2+" enp_no, \n";

		if(gubun4.equals("3")){
			query += "       nvl(a.recconame,decode(a.gubun,'13',u.user_nm, decode(nvl(a.tax_type,'1'),'1',b.firm_nm, c.r_site))) firm_nm,  \n"+
					"        a.client_id, \n"+
					"        1 cnt, a.tax_supply, a.tax_value, a.tax_no as min_tax \n";
		}else{
			query += "        min(nvl(a.recconame,decode(a.gubun,'13',u.user_nm, decode(nvl(a.tax_type,'1'),'1',b.firm_nm, c.r_site)))) firm_nm,  \n"+
					"        min(a.client_id) client_id, \n"+
					"        count(a.tax_no) cnt, sum(a.tax_supply) tax_supply, sum(a.tax_value) tax_value, min(a.tax_no) min_tax \n";
		}

		query += " from   tax a, client b, client_site c, users u,  \n"+
				"        saleebill h, eb_status i, \n"+
				"        ( select a.pubcode, a.status \n"+
				"          from   eb_history a, \n"+
				"                 (select pubcode, MAX(statusdate||decode(status,'99',0,'30',1,status) ) statusdate from eb_history where status not in ('11','14') group by pubcode) b \n"+
				"          where  a.status not in ('11','14') and a.pubcode=b.pubcode and a.statusdate||decode(a.status,'99',0,'30',1,a.status)=b.statusdate \n"+
				"         ) j\n"+
				" where nvl(a.tax_st,'O')<>'C' "+
				" ";

		if(!s_br.equals(""))		query += " and a.branch_g like '"+s_br+"%' \n";

		if(!gubun1.equals("") && gubun2.equals("") && gubun3.equals("")) query += " and a.tax_dt like '"+gubun1+"%' \n";

		if(!gubun1.equals("") && !gubun2.equals("") && gubun3.equals("")){
			if(gubun2.equals("1"))	query += " and a.tax_dt between '"+gubun1+"0101' and '"+gubun1+"0331' \n";
			if(gubun2.equals("2"))	query += " and a.tax_dt between '"+gubun1+"0401' and '"+gubun1+"0630' \n";
			if(gubun2.equals("3"))	query += " and a.tax_dt between '"+gubun1+"0701' and '"+gubun1+"0930' \n";
			if(gubun2.equals("4"))	query += " and a.tax_dt between '"+gubun1+"1001' and '"+gubun1+"1231' \n";
		}

		query +=	" and a.client_id=b.client_id(+) and a.client_id=c.client_id(+) and a.seq=c.seq(+) \n"+
					" and a.resseq=h.resseq(+) and h.pubcode=i.pubcode(+) and h.pubcode=j.pubcode(+) \n"+
					" and a.client_id=u.user_id(+) \n"+
					" ";


		if(!gubun1.equals("") && !gubun2.equals("") && !gubun3.equals("")) query += " and a.tax_dt like '"+gubun1+gubun3+"%' \n";

		if(gubun4.equals("1"))		query += " and decode(j.status,'99','',a.resseq) is not null \n";
		if(gubun4.equals("2"))		query += " and decode(j.status,'99','',a.resseq) is null \n";


		if(!t_wd1.equals("")){
			if(s_kd.equals("1"))	query += " and b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ) || TEXT_DECRYPT(u.user_ssn, 'pw' )   like '%"+t_wd1+"%' \n";
		}

		if(gubun4.equals("3")){
			query += " order by decode("+orderby1+",2,'9','1'), "+orderby2+", a.tax_supply desc, a.tax_no ";
		}else{
			query += " group by "+orderby1+", "+orderby2+" \n"+
					 " order by decode("+orderby1+",2,'9','1'), "+orderby2+", max(a.tax_supply) desc ";
		}



		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getTaxHapList]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxHapList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	세금계산서 합계표 리스트 현황
	 */
	public Vector getTaxHapStat(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" b.client_st, decode(nvl(a.tax_type,'1'),'1',nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' ) ), TEXT_DECRYPT(c.enp_no, 'pw' )  ) enp_no,"+
				" min(decode(nvl(a.tax_type,'1'),'1',b.firm_nm,c.r_site)) firm_nm, min(b.client_id) client_id,"+
				" count(a.tax_no) cnt, sum(a.tax_supply) tax_supply, sum(a.tax_value) tax_value"+
				" from tax a, client b, client_site c"+
				" where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.seq=c.seq(+)"+
				" and nvl(a.tax_st,'O')<>'C'";

		if(!s_br.equals(""))		query += " and a.branch_g like '"+s_br+"%'";

		if(!gubun1.equals("") && gubun2.equals("") && gubun3.equals("")) query += " and a.tax_dt like '"+gubun1+"%'";

		if(!gubun1.equals("") && !gubun2.equals("") && gubun3.equals("")){
			if(gubun2.equals("1"))	query += " and a.tax_dt between '"+gubun1+"0101' and '"+gubun1+"0331'";
			if(gubun2.equals("2"))	query += " and a.tax_dt between '"+gubun1+"0401' and '"+gubun1+"0630'";
			if(gubun2.equals("3"))	query += " and a.tax_dt between '"+gubun1+"0701' and '"+gubun1+"0930'";
			if(gubun2.equals("4"))	query += " and a.tax_dt between '"+gubun1+"1001' and '"+gubun1+"1231'";
		}

		if(!gubun1.equals("") && !gubun2.equals("") && !gubun3.equals("")) query += " and a.tax_dt like '"+gubun1+gubun3+"%'";
		if(!gubun1.equals("") && gubun2.equals("") && !gubun3.equals(""))  query += " and a.tax_dt like '"+gubun1+gubun3+"%'";

		query += " group by b.client_st, decode(nvl(a.tax_type,'1'),'1',nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' ) ), TEXT_DECRYPT(c.enp_no, 'pw' )  )";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getTaxHapStat]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxHapStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	거래명세서 보관함 리스트 조회
	 */
	public Vector getItemMngList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"        b.firm_nm, b.client_nm, b.enp_no, TEXT_DECRYPT(b.ssn, 'pw' ) ssn, "+
				"        decode(decode(a.seq,'',c.tax_type,'2'), '2', decode(TEXT_DECRYPT(g.enp_no, 'pw' ) , '', decode(b.client_st,'2',TEXT_DECRYPT(b.ssn, 'pw' ),b.enp_no),TEXT_DECRYPT(g.enp_no, 'pw' )), decode(b.client_st,'2',TEXT_DECRYPT(b.ssn, 'pw' ),b.enp_no)) reccoregno, "+
				"        decode(decode(a.seq,'',c.tax_type,'2'), '2', decode(g.r_site,   '', b.firm_nm,  g.r_site ),  b.firm_nm ) recconame, "+
				"        to_char(f.reg_dt,'YYYY-MM-DD') reg_dt, to_char(f.reg_dt,'YYYYMMDD') reg_dt2, "+
				"        f.gubun, f.tm, f.item_g, f.item_car_no, f.item_car_nm, f.item_supply, f.item_value, (f.item_supply+f.item_value) item_amt,"+
				"        a.*, e.tax_st, e.doctype "+
				" from tax_item a, tax e, tax_item_list f, client b, cont c, car_reg d, client_site g "+
				" where"+
				" a.item_id=e.item_id(+)"+
				" and a.item_id=f.item_id(+)"+
				" and a.client_id=b.client_id"+
				" and f.rent_l_cd=c.rent_l_cd(+)"+
				" and f.car_mng_id=d.car_mng_id(+)"+
				" and a.client_id=g.client_id(+) and a.seq=g.seq(+) "+
				" ";

		if(!s_br.equals(""))	query += " and e.branch_g like '"+s_br+"%'";


		//기간구분
		if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.item_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("2") && !st_dt.equals(""))		query += " and to_char(f.reg_dt,'YYYYMMDD') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";



		String search = "";
		if(s_kd.equals("1"))		search = "b.firm_nm";
		else if(s_kd.equals("2"))	search = "c.rent_l_cd";
		else if(s_kd.equals("3"))	search = "d.car_no";
		else if(s_kd.equals("4"))	search = "b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' )";
		else if(s_kd.equals("5"))	search = "a.item_id";
		else if(s_kd.equals("6"))	search = "f.item_g";
		else						search = "b.firm_nm";

		if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
		if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";


		if(sort.equals("1"))		query += " order by b.firm_nm "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by d.car_no "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' )) "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.item_id "+asc;
		if(sort.equals("5"))		query += " order by a.item_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by f.reg_dt "+asc+", a.tax_no";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getItemMngList]\n"+e);
			System.out.println("[ScdMngDatabase:getItemMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	트러스빌 리스트 조회
	 */
	public Vector getTrusbillList(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" h.*, a.tax_st, decode(a.tax_no,'','X','FMS') tax_yn,"+
				" decode(j.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','66','공급자발행취소요청','99','발급취소','11','중복데이타','12','ID불일치','13','인증서불일치','14','기타에러',decode(a.resseq,'','','대기')) status"+
				" from "+
				" saleebill h, "+
				" (select a.pubcode, a.status from eb_history a, (select pubcode, max(statusdate) statusdate from eb_history where status<>'11' group by pubcode) b where a.status<>'11' and a.pubcode=b.pubcode and a.statusdate=b.statusdate) j, tax a\n"+
				" where"+
				" h.pubcode=j.pubcode(+) and h.resseq=a.resseq(+)";


			//기간구분
			if(gubun1.equals("1") && !st_dt.equals(""))		query += " and h.pubdate between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";


			String search = "";
			if(s_kd.equals("1"))		search = "h.recconame";

			if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
			if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";


		if(sort.equals("1"))		query += " order by h.recconame "+asc+", h.taxsnum1";
		if(sort.equals("4"))		query += " order by h.taxsnum1 "+asc;
		if(sort.equals("5"))		query += " order by h.pubdate "+asc+", h.taxsnum1";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTrusbillList]\n"+e);
			System.out.println("[ScdMngDatabase:getTrusbillList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	대여료스케줄 사용기간 일괄변경 조회 리스트-동일조건
	 */
	public Vector getFeeScdListUseDtNOAll()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.rent_mng_id, a.rent_l_cd, b.rent_st, e.firm_nm, f.car_no, "+
				" nvl(b.fee_pay_tm, decode(b.ifee_s_amt, 0,b.con_mon, b.con_mon-(b.ifee_s_amt/b.fee_s_amt))) fee_pay_tm,"+
				" (b.fee_s_amt+b.fee_v_amt) fee_amt, b.fee_s_amt, c.fee_s_amt as fee_s_amt1, d.fee_s_amt as fee_s_amt2,"+
				" b.rent_start_dt, b.rent_end_dt, c.use_s_dt, c.use_e_dt, d.use_s_dt as use_s_dt2, d.use_e_dt as use_e_dt2"+
				" from cont a, fee b, client e, car_reg f,"+
				" (select * from scd_fee where fee_tm='1' and tm_st1='0') c,"+
				" (select * from scd_fee where fee_tm='2' and tm_st1='0') d,"+
				" (select * from scd_fee where fee_tm='3' and tm_st1='0') g,"+
				" (select rent_l_cd, max(fee_tm) fee_tm from scd_fee where tm_st1='0' group by rent_l_cd) h, scd_fee i"+
				" where"+
				" a.rent_l_cd=b.rent_l_cd"+
				" and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st"+
				" and b.rent_l_cd=d.rent_l_cd and b.rent_st=d.rent_st"+
				" and b.rent_l_cd=g.rent_l_cd and b.rent_st=g.rent_st"+
				" and b.rent_l_cd=h.rent_l_cd and h.rent_l_cd=i.rent_l_cd and h.fee_tm=i.fee_tm"+
				" and a.client_id=e.client_id"+
				" and a.car_mng_id=f.car_mng_id(+)"+
				" and a.use_yn='Y' and a.car_st<>'2'"+
				" and c.use_s_dt is not null and c.use_e_dt is not null"+
				" and d.use_s_dt is null and d.use_e_dt is null"+
				" and g.use_s_dt is null and g.use_e_dt is null"+
				" and b.fee_s_amt=c.fee_s_amt"+
				" and b.fee_s_amt=d.fee_s_amt"+
				" and b.fee_s_amt=g.fee_s_amt"+
				" and b.fee_s_amt=i.fee_s_amt"+
				" and b.rent_start_dt=c.use_s_dt"+
				" and b.rent_st='1'"+
				" and c.use_e_dt=to_char(add_months(to_date(c.use_s_dt,'YYYYMMDD'),1)-1,'YYYYMMDD')"+
				" and e.firm_nm<>'(주)인에이블월드와이드'"+
				" and b.rent_end_dt > '20051117' and b.rent_start_dt not like '%31' and b.rent_start_dt not like '%30' and b.rent_start_dt not like '%0228'"+
				" order by b.rent_start_dt desc";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScdListUseDtNOAll]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScdListUseDtNOAll]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	대여료스케줄 사용기간 일괄변경 조회 리스트- 조건없이 사용기간 없는것 출력
	 */
	public Vector getFeeScdListUseDtNOAll2()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.rent_mng_id, a.rent_l_cd, b.rent_st, e.firm_nm, f.car_no, "+
				" nvl(b.fee_pay_tm, decode(b.ifee_s_amt, 0,b.con_mon, b.con_mon-(b.ifee_s_amt/b.fee_s_amt))) fee_pay_tm,"+
				" (b.fee_s_amt+b.fee_v_amt) fee_amt, b.fee_s_amt,"+
				" b.rent_start_dt, b.rent_end_dt"+
				" from cont a, fee b, client e, car_reg f,"+
				" (select rent_l_cd from scd_fee where tm_st1='0' and use_s_dt is null group by rent_l_cd) c"+
				" where"+
				" a.rent_l_cd=b.rent_l_cd"+
				" and a.rent_l_cd=c.rent_l_cd"+
				" and a.client_id=e.client_id"+
				" and a.car_mng_id=f.car_mng_id(+)"+
				" and a.use_yn='Y' and a.car_st<>'2'"+
				" and b.rent_st='1'"+
				" order by b.rent_start_dt desc";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScdListUseDtNOAll2]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScdListUseDtNOAll2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자세금계산서 트러스빌 건별 이력
	 */
	public Vector getEbHistoryList_2010(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.pubcode, c.STATUSDATE, c.REASON, "+
				"        decode(c.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','66','공급자발행취소요청','99','발급취소','11','중복데이타','12','ID불일치','13','인증서불일치','14','기타에러','') status_nm "+
				" from   saleebill b, eb_history c"+
				" where  b.taxsnum1='"+tax_no+"' and b.pubcode=c.pubcode"+
				" order by c.STATUSDATE"+
				" ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getEbHistoryList_2010]\n"+e);
			System.out.println("[ScdMngDatabase:getEbHistoryList_2010]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자세금계산서 트러스빌 건별 이력
	 */
	public Vector getEbNtsHistoryList_2010(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        d.nts_stat, d.nts_result, d.nts_datetime, d.nts_msg, e.nts_result_cont,"+
				"        decode(d.nts_stat,'20','전송중','30','전송성공','40','전송실패','') nts_stat_nm, b.nts_issueid"+
				" from   saleebill b, eb_nts_hist d, "+
				"        EB_NTS_RESULT_CODE e"+
				" where  b.taxsnum1='"+tax_no+"' "+
				"        and b.pubcode=d.pubcode and b.nts_issueid=d.nts_issueid(+) "+
				"        and d.nts_result=e.nts_result(+)"+
				" order by d.nts_datetime"+
				" ";


		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getEbNtsHistoryList_2010]\n"+e);
			System.out.println("[ScdMngDatabase:getEbNtsHistoryList_2010]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자세금계산서 트러스빌 건별 이력
	 */
	public Vector getEbHistoryList(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.*,"+
				" decode(c.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','66','공급자발행취소요청','99','발급취소','11','중복데이타','12','ID불일치','13','인증서불일치','14','기타에러','') status_nm"+
				" from tax a, saleebill b, eb_history c"+
				" where a.resseq=b.resseq and b.pubcode=c.pubcode "+
				" and a.tax_no='"+tax_no+"'";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getEbHistoryList]\n"+e);
			System.out.println("[ScdMngDatabase:getEbHistoryList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자세금계산서 이메일발송 건별 이력
	 */
	public Vector getMailHistoryList(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.*, decode(ocnt,'1','수신','미수신') ocnt_nm, decode(a.errcode,'','발송중','114','정상발송','100','정상발송','101','정상발송','실패-'||a.code_st2) msgflag_nm "+
				" from   "+
				"        ("+
				//구버전
				"          select c.*, b.msgflag, d.code_st2 "+
				"          from   tax a, im_dmail_info_2 b, im_dmail_result_2 c, IM_DMAIL_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.tax_no=b.gubun and b.seqidx=c.dmidx(+) and c.ERRCODE=d.CODE_ID(+)"+
				"          union all"+
				"          select c.*, b.msgflag, d.code_st2 "+
				"          from   tax a, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) d, im_dmail_info_2 b, im_dmail_result_2 c, IM_DMAIL_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.item_id=d.item_id and d.reg_code=b.gubun and a.con_agnt_email=substr(b.sql,5) "+
				"                 and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				"          union all"+
				"          select c.*, b.msgflag, d.code_st2 "+
				"          from   tax a, tax_item d, im_dmail_info_2 b, im_dmail_result_2 c, IM_DMAIL_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.item_id=d.item_id and d.tax_code=b.gubun and a.con_agnt_email=substr(b.sql,5) "+
				"                 and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				"          union all"+
				//신버전
				"          select c.*, b.msgflag, d.send as code_st2 "+
				"          from   tax a, im_dmail_info_6 b, im_dmail_result_6 c, IM_DMAIL_J_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.tax_no=b.gubun and b.seqidx=c.dmidx(+) and c.ERRCODE=d.CODE_ID(+)"+
				"          union all"+
				"          select c.*, b.msgflag, d.send as code_st2 "+
				"          from   tax a, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) d, im_dmail_info_6 b, im_dmail_result_6 c, IM_DMAIL_J_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.item_id=d.item_id and d.reg_code=b.gubun and a.con_agnt_email=substr(b.sql,5) "+
				"                 and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				"          union all"+
				"          select c.*, b.msgflag, d.send as code_st2 "+
				"          from   tax a, tax_item d, im_dmail_info_6 b, im_dmail_result_6 c, IM_DMAIL_J_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.item_id=d.item_id and d.tax_code=b.gubun and a.con_agnt_email=substr(b.sql,5) "+
				"                 and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				" ) a"+
				" order by stime";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getMailHistoryList]\n"+e);
			System.out.println("[ScdMngDatabase:getMailHistoryList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자세금계산서 이메일발송 건별 이력
	 */
	public String getMailHistoryMax(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String content = "";


		query = " select b.content from"+
				" ("+
				"  select max(seqidx) seqidx from"+
				"  ("+
				"   select b.seqidx from tax a, im_dmail_info_2 b, im_dmail_result_2 c"+
				"   where a.tax_no='"+tax_no+"' and a.tax_no=b.gubun and b.seqidx=c.dmidx(+)"+
				"   union all"+
				"   select b.seqidx from tax a, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) d, im_dmail_info_2 b, im_dmail_result_2 c"+
				"   where a.tax_no='"+tax_no+"' and a.item_id=d.item_id and d.reg_code=b.gubun and b.seqidx=c.dmidx(+) and a.con_agnt_email=c.email"+
				"   )"+
				" )a, im_dmail_info_2 b"+
				" where a.seqidx=b.seqidx";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				//Clob 불러오기
				StringBuffer output = new StringBuffer();
				Reader input = rs.getCharacterStream("content");
				char[] buffer = new char[1024];
				int byteRead;
				while((byteRead=input.read(buffer,0,1024))!=-1){
					output.append(buffer,0,byteRead);
				}
				input.close();
				content = output.toString(); 
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getMailHistoryMax]\n"+e);
			System.out.println("[ScdMngDatabase:getMailHistoryMax]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return content;
		}
	}

	/**
	 *	발행스케줄관리 - 발행작업스케줄
	 */
	public Vector getFeeScdClient(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query =		 "  select "+
					 "         a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, a.rent_mng_id, a.rent_l_cd,"+
					 "         a.rent_st, a.rent_seq, a.fee_tm, a.tm_st1, a.tm_st2, a.fee_est_dt, a.r_fee_est_dt, a.req_dt, a.r_req_dt, "+
				     "         a.fee_s_amt, a.fee_v_amt, a.fee_amt, a.rc_yn, a.dly_days, a.pay_cng_dt, a.pay_cng_cau,"+
					 "         a.use_s_dt, a.use_e_dt, a.tax_out_dt,"+
					 "         nvl(d.car_no,a.rent_l_cd) car_no, d.car_nm"+
					 "  from "+
					 "         ( select a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, a.reg_dt, b.rent_mng_id, b.rent_l_cd,"+
					 "  	            b.rent_st, b.rent_seq, b.fee_tm, b.tm_st1, b.tm_st2, b.fee_est_dt, b.r_fee_est_dt, b.req_dt, b.r_req_dt, "+
					 "                  b.fee_s_amt, b.fee_v_amt, (b.fee_s_amt+b.fee_v_amt) fee_amt,"+
					 "		            b.rc_yn, b.dly_days, b.use_s_dt, b.use_e_dt, b.tax_out_dt, b.pay_cng_dt, b.pay_cng_cau"+
					 "  	     from   cont a, scd_fee b "+
					 "  	     where  a.client_id='"+client_id+"' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.bill_yn='Y' and b.tm_st1='0' "+
					 "         ) a, "+
					 "         car_reg d"+
					 "  where "+
					 "         a.client_id='"+client_id+"'"+
					 "         and a.fee_est_dt between to_char(add_months(sysdate,-1),'YYYYMMDD') and to_char(add_months(sysdate,3),'YYYYMMDD')"+
					 "         and a.car_mng_id=d.car_mng_id(+)"+	
					 "  order by a.r_req_dt, a.req_dt, a.reg_dt, a.rent_mng_id, a.r_fee_est_dt";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScdClient]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScdClient]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	발행스케줄관리 - 발행작업스케줄
	 */
	public Vector getFeeScdClient(String client_id, String fee_est_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query =		 "  select "+
					 "         a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, a.rent_mng_id, a.rent_l_cd,"+
					 "         a.rent_st, a.rent_seq, a.fee_tm, a.tm_st1, a.tm_st2, a.fee_est_dt, a.r_fee_est_dt, a.req_dt, a.r_req_dt, "+
				     "         a.fee_s_amt, a.fee_v_amt, a.fee_amt, a.rc_yn, a.dly_days, a.pay_cng_dt, a.pay_cng_cau, "+
					 "         a.use_s_dt, a.use_e_dt, a.tax_out_dt, b.item_dt, "+
					 "         b.reg_dt, b.tax_dt, b.print_dt, b.tax_no, "+
					 "         nvl(d.car_no,a.rent_l_cd) car_no, d.car_nm"+
					 "  from "+
					 "         ( select a.brch_id, a.client_id, a.r_site, a.car_mng_id, a.use_yn, b.rent_mng_id, b.rent_l_cd,"+
					 "  	            b.rent_st, b.rent_seq, b.fee_tm, b.tm_st1, b.tm_st2, b.fee_est_dt, b.r_fee_est_dt, b.req_dt, b.r_req_dt, "+
					 "                  b.fee_s_amt, b.fee_v_amt, (b.fee_s_amt+b.fee_v_amt) fee_amt,"+
					 "		            b.rc_yn, b.dly_days, b.use_s_dt, b.use_e_dt, b.tax_out_dt, b.pay_cng_dt, b.pay_cng_cau"+
					 "  	     from   cont a, scd_fee b "+
					 "  	     where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.bill_yn,'Y')='Y' and b.tm_st1='0'"+
					 "         ) a, "+
							  //20110215 거래명세서&세금계산서
					 "        ( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm, sum(item_supply) fee_s_amt, \n"+
					 "                 max(b.item_id) item_id, max(b.item_dt) item_dt, max(b.tax_est_dt) tax_est_dt, \n"+
					 "                 decode(sum(c.tax_supply),0,'',max(c.tax_no)) tax_no, "+
					 "		           decode(sum(c.tax_supply),0,'',max(c.tax_dt)) tax_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.reg_dt)) reg_dt, "+
					 "	               decode(sum(c.tax_supply),0,'',max(c.print_dt)) print_dt \n"+
					 "          from   tax_item_list a, tax_item b, tax c \n"+
					 "          where  a.gubun='1' \n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id(+) and nvl(c.tax_st,'O')<>'C' and nvl(b.use_yn,'Y')='Y' \n"+
					 "          group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm \n"+
					 "          having sum(a.item_supply)>0"+
					 "	      ) b, \n"+
					 "         car_reg d"+
					 "  where "+
					 "         a.client_id='"+client_id+"'"+
					 "         and substr(a.fee_est_dt,1,6) >= substr('"+fee_est_dt+"',1,6)"+
					 "         and a.rent_l_cd=b.rent_l_cd(+) and a.fee_tm=b.fee_tm(+) and a.rent_st=b.rent_st(+) and a.rent_seq=b.rent_seq(+)\n"+
					 "         and a.car_mng_id=d.car_mng_id(+)"+	
					 "  order by a.rent_seq, a.client_id, nvl(a.r_site,'99'), a.fee_est_dt, a.req_dt, a.tax_out_dt ";

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScdClient]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScdClient]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	미승인관리 리스트 조회
	 */
	public Vector getTaxNotAppList(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" decode(a.gubun,'13',g.user_nm,b.firm_nm) firm_nm,"+
				" substr(decode(a.gubun,'13',g.user_nm,b.firm_nm),1,15) firm_nm2,"+
				" decode(a.gubun,'13','-',b.client_nm) client_nm,"+
				" decode(a.gubun,'13',TEXT_DECRYPT(g.user_ssn, 'pw' ) , decode(a.tax_type,'1',b.enp_no,'2', TEXT_DECRYPT(f.enp_no, 'pw' ) )) enp_no,  TEXT_DECRYPT(b.ssn, 'pw' ) ssn, (a.tax_supply+a.tax_value) tax_amt, a.*,"+
				" substr(a.mail_dt,1,12) mail_dt, h.pubcode, decode(j.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','66','공급자발행취소요청','99','발급취소','11','중복데이타','12','ID불일치','13','인증서불일치','14','기타에러',decode(a.resseq,'','','대기')) status,"+
				" sign(to_date('20060430','YYYYMMDD')-to_date(tax_dt,'YYYYMMDD')) ebill_yn,"+
				" b.etax_not_cau, k.user_nm as bus_nm2, b.con_agnt_email as con_agnt_email2, b.con_agnt_m_tel as con_agnt_m_tel2,"+
				" m.cng_cau, m.cng_dt"+
				" from tax a, client b, cont c, car_reg d, client_site f, users g,"+
				" saleebill h, eb_status i,"+
				" (select a.pubcode, a.status from eb_history a, (select pubcode, max(statusdate) statusdate from eb_history where status<>'11' group by pubcode) b where a.status<>'11' and a.pubcode=b.pubcode and a.statusdate=b.statusdate) j,\n"+
				" users k,"+
				" tax_cng m, (select tax_no, max(seq) seq from tax_cng where cng_st='app_n' group by tax_no) n "+
				" where a.app_yn='N' "+
				" and a.client_id=b.client_id"+
				" and a.rent_l_cd=c.rent_l_cd(+)"+
				" and c.car_mng_id=d.car_mng_id(+)"+
				" and a.client_id=g.user_id(+)"+
				" and a.client_id=f.client_id(+) and a.seq=f.seq(+)"+
				" and a.resseq=h.resseq(+) and h.pubcode=i.pubcode(+) and h.pubcode=j.pubcode(+) and nvl(c.bus_id2,c.bus_id)=k.user_id(+)"+
				" and a.tax_no=m.tax_no(+) and m.tax_no=n.tax_no(+) and m.seq=n.seq(+)";

		//기간구분
		if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.tax_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("2") && !st_dt.equals(""))		query += " and nvl(a.reg_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("3") && !st_dt.equals(""))		query += " and m.cng_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		String search = "";
		if(s_kd.equals("1"))		search = "decode(a.gubun,'13',g.user_nm,b.firm_nm)";
		else if(s_kd.equals("2"))	search = "a.rent_l_cd";
		else if(s_kd.equals("3"))	search = "d.car_no";
		else if(s_kd.equals("4"))	search = "decode(a.gubun,'13',TEXT_DECRYPT(g.user_ssn, 'pw' ), decode(a.tax_type,'1',b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ),'2',TEXT_DECRYPT(f.enp_no, 'pw' )))";
		else if(s_kd.equals("5"))	search = "a.tax_no";
		else if(s_kd.equals("6"))	search = "a.tax_g||a.tax_bigo";
		else if(s_kd.equals("7"))	search = "c.bus_id2";
		else if(s_kd.equals("8"))	search = "b.etax_not_cau";

		if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
		if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";
 

		if(sort.equals("1"))		query += " order by b.firm_nm "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by c.car_no "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' )) "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.tax_no "+asc;
		if(sort.equals("5"))		query += " order by a.tax_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by a.reg_dt "+asc+", a.tax_no";
		if(sort.equals("7"))		query += " order by a.print_dt "+asc+", a.tax_no";
		if(sort.equals("8"))		query += " order by c.bus_id2 "+asc+", a.tax_no";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxNotAppList]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxNotAppList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	미승인관리 리스트 조회
	 */
	public Vector getTaxAppList(String client_id, String app_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select (a.tax_supply+a.tax_value) as tax_amt, m.cng_cau, m.cng_dt, nvl(a.app_yn,'Y') app_yn2, a.*"+
				" from tax a, saleebill h, eb_status i,"+
				" (select a.pubcode, a.status from eb_history a, (select pubcode, max(statusdate) statusdate from eb_history where status<>'11' group by pubcode) b where a.status<>'11' and a.pubcode=b.pubcode and a.statusdate=b.statusdate) j,\n"+
				" tax_cng m, (select tax_no, max(seq) seq from tax_cng where cng_st='app_n' group by tax_no) n "+
				" where "+
				" a.resseq=h.resseq and h.pubcode=i.pubcode and h.pubcode=j.pubcode"+
				" and a.tax_no=m.tax_no(+) and m.tax_no=n.tax_no(+) and m.seq=n.seq(+)"+
				" and a.client_id=? ";

		if(app_yn.equals("Y"))	query += " and nvl(a.app_yn,'Y')='Y' and j.status in ('30','35')";
		else					query += " and nvl(a.app_yn,'Y')='N'";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		client_id);

	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxAppList]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxAppList]\n"+query);
			System.out.println("[ScdMngDatabase:getTaxAppList]\n"+client_id);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	세금계산서 보관함 리스트 조회 - 승인요청문자 일괄보내기
	 */
	public Vector getTaxSmsList(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" substr(b.firm_nm,1,15) firm_nm, a.CON_AGNT_M_TEL, min(a.tax_dt) tax_dt, count(0) cnt"+
				" from tax a, client b, cont c, car_reg d, (select * from scd_fee where tm_st1='0') e, client_site f, users g,"+
				" saleebill h, eb_status i,"+
				" (select a.pubcode, a.status from eb_history a, (select pubcode, max(statusdate) statusdate from eb_history where status<>'11' group by pubcode) b where a.status<>'11' and a.pubcode=b.pubcode and a.statusdate=b.statusdate) j,\n"+
				" users k"+
				" where"+
				" a.client_id=b.client_id"+
				" and a.rent_l_cd=c.rent_l_cd(+)"+
				" and c.car_mng_id=d.car_mng_id(+)"+
				" and a.client_id=g.user_id(+)"+
				" and a.rent_l_cd=e.rent_l_cd(+) and a.fee_tm=e.fee_tm(+)"+
				" and a.client_id=f.client_id(+) and a.seq=f.seq(+)"+
				" and a.resseq=h.resseq(+) and h.pubcode=i.pubcode(+) and h.pubcode=j.pubcode(+) and nvl(c.bus_id2,c.bus_id)=k.user_id(+)";

		if(!s_br.equals(""))	query += " and a.branch_g like '"+s_br+"%'";


			//기간구분
			if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.tax_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("2") && !st_dt.equals(""))		query += " and nvl(a.reg_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("3") && !st_dt.equals(""))		query += " and nvl(a.print_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			if(gubun1.equals("4") && !st_dt.equals(""))		query += " and e.r_req_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			String search = "";
			if(s_kd.equals("1"))		search = "decode(a.gubun,'13',g.user_nm,b.firm_nm)";
			else if(s_kd.equals("2"))	search = "a.rent_l_cd";
			else if(s_kd.equals("3"))	search = "d.car_no";
			else if(s_kd.equals("4"))	search = "decode(a.gubun,'13', TEXT_DECRYPT(g.user_ssn, 'pw' )  , decode(a.tax_type,'1',b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ),'2', TEXT_DECRYPT(f.enp_no, 'pw' ) ))";
			else if(s_kd.equals("5"))	search = "a.tax_no";
			else if(s_kd.equals("6"))	search = "a.tax_g||a.tax_bigo";
			else if(s_kd.equals("7"))	search = "c.bus_id2";
			else if(s_kd.equals("8"))	search = "b.etax_not_cau";

			if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
			if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";

		query += " and nvl(a.app_yn,'Y')='Y' and a.tax_st='O' and a.CON_AGNT_M_TEL is not null  and j.status in ('30','35')"+
				 " group by substr(b.firm_nm,1,15), a.CON_AGNT_M_TEL";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxSmsList]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxSmsList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	입금표 보관함 리스트 조회
	 */
	public Vector getPayMngList(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        decode(j.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','66','공급자발행취소요청','99','발급취소','11','중복데이타','12','ID불일치','13','인증서불일치','14','기타에러', '', '대기') status,"+
				"        a.*"+
				" from payebill a, "+ //branch b,
				" (select a.pubcode, a.status from eb_history a, (select pubcode, max(statusdate) statusdate from eb_history where status<>'11' group by pubcode) b where a.status<>'11' and a.pubcode=b.pubcode and a.statusdate=b.statusdate) j\n"+
				" where"+
				" a.pubcode=j.pubcode(+) "; //and a.coregno=b.br_ent_no and a.coaddr=b.br_addr

		//if(!s_br.equals(""))	query += " and b.br_id = '"+s_br+"'";


		//기간구분
		if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.pubdate between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		String search = "";
		if(s_kd.equals("1"))		search = "a.recconame";
		else if(s_kd.equals("4"))	search = "a.reccoregno";

		if(!search.equals("") && !t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
		if(!search.equals("") && !t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";


		if(sort.equals("1"))		query += " order by a.recconame "+asc+"";
		if(sort.equals("3"))		query += " order by a.reccoregno "+asc+"";
		if(sort.equals("5"))		query += " order by a.pubdate "+asc+"";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
    			
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getPayMngList]\n"+e);
			System.out.println("[ScdMngDatabase:getPayMngList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	수시발행 - 중도해지 스케줄
	 */
	public Vector getClsContScdListNew(String s_br, String rent_l_cd, String tax_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = "  select a.st_nm, a.cls_dt, a.rent_l_cd, a.rent_mng_id, a.rent_l_cd, a.brch_id, a.client_id, a.site_id, a.firm_nm, a.car_no, a.car_nm, \n"+
				"		  nvl(dfee_amt_s, nfee_amt) dfee_amt_s , nvl(dfee_amt_v, trunc(nfee_amt*0.1)) dfee_amt_v, \n"+
				"		  nvl(dft_amt_s, dft_amt)  dft_amt_s , nvl(dft_amt_v, trunc(dft_amt*0.1)) dft_amt_v, \n"+
				"		  nvl(etc_amt_s, etc_amt)  etc_amt_s , nvl(etc_amt_v, trunc(etc_amt*0.1)) etc_amt_v, \n"+
				"		  nvl(etc2_amt_s, etc2_amt) etc2_amt_s , nvl(etc2_amt_v, trunc(etc2_amt*0.1)) etc2_amt_v, \n"+
				"		  nvl(etc4_amt_s, etc4_amt) etc4_amt_s , nvl(etc4_amt_v, trunc(etc4_amt*0.1)) etc4_amt_v  \n"+	       
				"		  from ( \n"+
				"		 select	 '해지정산' st_nm, a.cls_dt, a.rent_mng_id, c.rent_l_cd, c.brch_id, d.client_id, c.r_site as site_id, d.firm_nm, e.car_no, e.car_nm,  \n"+
				"				 ct.dfee_amt_s - ct.r_dfee_amt_s  as dfee_amt_s, \n"+
				"				 ct.dft_amt_s  - ct.r_dft_amt_s   as dft_amt_s, \n"+
				"				 ct.etc_amt_s  - ct.r_etc_amt_s   as etc_amt_s, \n"+
				"				 ct.etc2_amt_s - ct.r_etc2_amt_s  as etc2_amt_s, \n"+
				"				 ct.etc4_amt_s - ct.r_etc4_amt_s  as etc4_amt_s, \n"+
				"				 ct.dfee_amt_v - ct.r_dfee_amt_v  as dfee_amt_v, \n"+
				"				 ct.dft_amt_v  - ct.r_dft_amt_v   as dft_amt_v, \n"+
				"				 ct.etc_amt_v  - ct.r_etc_amt_v   as etc_amt_v, \n"+
				"				 ct.etc2_amt_v - ct.r_etc2_amt_v  as etc2_amt_v, \n"+
				"				 ct.etc4_amt_v - ct.r_etc4_amt_v  as etc4_amt_v, \n"+
				"				 a.nfee_amt, a.dft_amt, a.etc_amt, a.etc2_amt, a.etc4_amt \n"+
				"					 from cls_cont a, cont c, client d, car_reg e,  \n"+
				"					 (select aa.* from tax aa where aa.tax_st='O' and aa.tax_g like '%해지%위약금%' and aa.tax_supply <> 0) k ,  \n"+
				"					 (select rent_mng_id, rent_l_cd,  \n"+
				"	                      sum(decode(seq_no, 1, nvl(dfee_amt_s,0), 0)) as dfee_amt_s, sum(decode(seq_no, 1, nvl(dft_amt_s,0), 0))    as dft_amt_s, \n"+
				"	                      sum(decode(seq_no, 1, nvl(etc_amt_s,0) , 0)) as etc_amt_s,  sum(decode(seq_no, 1, nvl(etc2_amt_s,0), 0))   as etc2_amt_s, \n"+ 
				"	                      sum(decode(seq_no, 1, nvl(etc4_amt_s,0), 0)) as etc4_amt_s, \n"+
				"	                      sum(decode(seq_no, 1, nvl(dfee_amt_v,0), 0)) as dfee_amt_v, sum(decode(seq_no, 1, nvl(dft_amt_v,0), 0))    as dft_amt_v, \n"+
				"	                      sum(decode(seq_no, 1, nvl(etc_amt_v,0), 0))  as etc_amt_v,  sum(decode(seq_no, 1, nvl(etc2_amt_v,0), 0))   as etc2_amt_v, \n"+ 
				"	                      sum(decode(seq_no, 1, nvl(etc4_amt_v,0), 0)) as etc4_amt_v, \n"+
				"	                      sum(decode(tax_r_chk3, 'Y', nvl(r_dfee_amt_s,0), 0)) as r_dfee_amt_s,  sum(decode(tax_r_chk4, 'Y', nvl(r_dft_amt_s,0), 0))  as r_dft_amt_s, \n"+
				"	                      sum(decode(tax_r_chk5, 'Y', nvl(r_etc_amt_s,0), 0))  as r_etc_amt_s,   sum(decode(tax_r_chk6, 'Y', nvl(r_etc2_amt_s,0), 0)) as r_etc2_amt_s, \n"+
				"	                      sum(decode(tax_r_chk7, 'Y', nvl(r_etc4_amt_s,0), 0)) as r_etc4_amt_s, \n"+
				"	                      sum(decode(tax_r_chk3, 'Y', nvl(r_dfee_amt_v,0), 0)) as r_dfee_amt_v,  sum(decode(tax_r_chk4, 'Y', nvl(r_dft_amt_v,0), 0))  as r_dft_amt_v, \n"+
				"	                      sum(decode(tax_r_chk5, 'Y', nvl(r_etc_amt_v,0), 0))  as r_etc_amt_v,   sum(decode(tax_r_chk6, 'Y', nvl(r_etc2_amt_v,0), 0)) as r_etc2_amt_v, \n"+
				"	                      sum(decode(tax_r_chk7, 'Y', nvl(r_etc4_amt_v,0), 0)) as r_etc4_amt_v \n"+
				"	                      from cls_etc_tax  \n"+
				"	                      group by rent_mng_id, rent_l_cd   ) ct \n"+	  	 			 
				"					 where a.cls_st in ('1','2')  and a.fdft_amt2 > 0 \n"+
				"					 and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  \n"+
				"					 and a.rent_mng_id=ct.rent_mng_id and a.rent_l_cd=ct.rent_l_cd  \n"+
				"					 and c.client_id=d.client_id  \n"+
				"					 and c.car_mng_id=e.car_mng_id(+)  \n"+
				"					 and c.client_id=k.client_id(+) and c.rent_l_cd=k.rent_l_cd(+) and k.rent_l_cd is null  \n"+
				"				     and a.cls_dt > '20121231'  ) a \n"+
				"			where 	( nvl(a.dfee_amt_s, 1)  + nvl(a.dft_amt_s, 1) +   nvl(a.etc_amt_s, 1) + nvl(a.etc2_amt_s, 1) + nvl(a.etc4_amt_s,1) ) > 0 \n"+
				"			     order by a.cls_dt desc ";
		     

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getClsContScdListNew]\n"+e);
			System.out.println("[ScdMngDatabase:getClsContScdListNew]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자세금계산서 이메일발송 건별 이력
	 */
	public Vector getTaxItemMailHistoryList(String item_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.*, decode(ocnt,'1','수신','미수신') ocnt_nm, decode(a.errcode,'','발송중','114','정상발송','100','정상발송','101','정상발송','0','','실패-'||a.code_st2) msgflag_nm from"+
				" ("+
			    //구버전
				" select c.*, b.msgflag, d.code_st2 "+
				" from tax_item a, im_dmail_info_2 b, im_dmail_result_2 c, IM_DMAIL_ERRCODE d"+
				" where a.item_id='"+item_id+"' and a.item_id=b.gubun and b.seqidx=c.dmidx(+) and c.ERRCODE=d.CODE_ID(+)"+
				" union all"+
				" select c.*, b.msgflag, d.code_st2 "+
				" from tax_item a, client a2, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) d, im_dmail_info_2 b, im_dmail_result_2 c, IM_DMAIL_ERRCODE d"+
				" where a.item_id='"+item_id+"' and a.seq is null "+
				"       and a.client_id=a2.client_id "+
				"       and a.item_id=d.item_id and d.reg_code=b.gubun and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				"       and nvl(a2.con_agnt_email,'ebill@amazoncar.co.kr')=c.email "+
				" union all"+
				" select c.*, b.msgflag, d.code_st2 "+
				" from tax_item a, client_site a2, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) d, im_dmail_info_2 b, im_dmail_result_2 c, IM_DMAIL_ERRCODE d"+
				" where a.item_id='"+item_id+"' and a.seq is not null "+
				"       and a.client_id=a2.client_id and a.seq=a2.seq"+
				"       and a.item_id=d.item_id and d.reg_code=b.gubun and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				"       and nvl(a2.agnt_email,'ebill@amazoncar.co.kr')=c.email "+
				" union all"+
                //신버전
				" select c.*, b.msgflag, d.send as code_st2 "+
				" from tax_item a, im_dmail_info_6 b, im_dmail_result_6 c, IM_DMAIL_J_ERRCODE d"+
				" where a.item_id='"+item_id+"' and a.item_id=b.gubun and b.seqidx=c.dmidx(+) and c.ERRCODE=d.CODE_ID(+)"+
				" union all"+
				" select c.*, b.msgflag, d.send as code_st2 "+
				" from tax_item a, client a2, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) d, im_dmail_info_6 b, im_dmail_result_6 c, IM_DMAIL_J_ERRCODE d"+
				" where a.item_id='"+item_id+"' and a.seq is null "+
				"       and a.client_id=a2.client_id "+
				"       and a.item_id=d.item_id and d.reg_code=b.gubun and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				"       and nvl(a2.con_agnt_email,'ebill@amazoncar.co.kr')=c.email "+
				" union all"+
				" select c.*, b.msgflag, d.send as code_st2 "+
				" from tax_item a, client_site a2, (select item_id, max(reg_code) reg_code from tax_item_list group by item_id) d, im_dmail_info_6 b, im_dmail_result_6 c, IM_DMAIL_J_ERRCODE d"+
				" where a.item_id='"+item_id+"' and a.seq is not null "+
				"       and a.client_id=a2.client_id and a.seq=a2.seq"+
				"       and a.item_id=d.item_id and d.reg_code=b.gubun and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				"       and nvl(a2.agnt_email,'ebill@amazoncar.co.kr')=c.email "+
				" ) a"+
				" order by stime";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxItemMailHistoryList]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxItemMailHistoryList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	세금계산서 보관함 리스트 조회
	 */
	public Vector getTaxMngList_2010(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String chk7, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select  /*+ leading(A C H) use_nl(a c h)  index(c CONT_IDX8)  index(h SALEEBILL_PK) index(i EB_STATUS_PK) */   \n"+
				"    	  NVL( a.recconame , decode( a.gubun , '13' , g.user_nm , b.firm_nm ) ) firm_nm , \n"+
				"	       SUBSTR( NVL( a.recconame , decode( a.gubun , '13' , g.user_nm , b.firm_nm ) ) , 1 , 15 ) firm_nm2 , \n"+
				"	       NVL( a.reccoceo , decode( a.gubun , '13' , '-' , b.client_nm ) ) client_nm , \n"+
				"	       NVL( a.reccoregno , decode( a.gubun , '13' , TEXT_DECRYPT(g.user_ssn, 'pw' )  , decode( a.tax_type , '1' , b.enp_no , '2' , NVL( TEXT_DECRYPT(f.enp_no , 'pw' ) , b.enp_no ) ) ) ) enp_no , \n"+
				"	       NVL( a.reccossn , decode( a.gubun , '13' ,  TEXT_DECRYPT(g.user_ssn, 'pw' ),  TEXT_DECRYPT(b.ssn, 'pw' )) ) ssn , \n"+
				"	       ( a.tax_supply+a.tax_value ) tax_amt ,     a.* , \n"+
				"	       SUBSTR( a.mail_dt , 1 , 12 ) mail_dt ,   h.pubcode , \n"+
				"	       decode( j.status , '25' , '수신자미등록' , '30' , '수신자미확인' , '35' , '수신자미승인' , '50' , '수신자승인' , '60' , '수신거부' , '65' , '수신자발행취소요청' , '66' , '공급자발행취소요청' , '99' , '발급취소' , '11' , '중복데이타' , '12' , 'ID불일치' , '13' , '인증서불일치' , '14' , '기타에러' , decode( a.resseq , '' , '' , '대기' ) ) status , \n"+
				"	       SIGN( TO_DATE( '20060430' , 'YYYYMMDD' ) - TO_DATE( tax_dt , 'YYYYMMDD' ) ) ebill_yn , \n"+
				"	       a.gubun ,      b.etax_not_cau , k.user_nm AS bus_nm2 ,  NVL( l2.stime , l.stime ) stime , \n"+
				"	       b.con_agnt_email AS con_agnt_email2 ,  b.con_agnt_m_tel AS con_agnt_m_tel2 , "+
				"	       decode( a.tax_st , 'O' , '정상' , 'C' , '발급취소' , 'M' , '매출취소' ) tax_st_nm , \n"+
				"	       decode( a.doctype , '01' , '기재사항정정' , '02' , '공급가액변동' , '03' , '환입' , '04' , '계약해제' , '06','이중발급', '' ) doctype_nm , "+
				"	       decode( a.unity_chk , '1' , '[통합]' , '' ) unity_chk_nm , m.nts_msg ,  m.nts_result ,   m.nts_result_cont \n"+
				" FROM  tax a , "+
				"	       ( "+
				"	        SELECT /*+ index(tax_item_list TAX_ITEM_LIST_IDX3  ) */ "+
				"	               * "+
				"	        FROM   tax_item_list "+
				"	        WHERE  item_seq=1 "+
				"	       ) n , "+
				"	       client b , "+
				"	       cont c , "+
				"	       car_reg d , "+
				"	       ( "+
				"	        SELECT /*+ index(scd_fee SCD_FEE_IDX4)*/ "+
				"	               * "+
				"	        FROM   scd_fee "+
				"	        WHERE  tm_st1='0' "+
				"	       ) e , "+
				"	       client_site f , "+
				"	       users g , "+
				"	       saleebill h , "+
				"	       eb_status i , "+
				"	       ( "+
				"	        SELECT  "+
				"	               a.pubcode , "+
				"	               a.status "+
				"	        FROM   amazoncar.tax t1 , "+
				"	               amazoncar.saleebill t2 , "+
				"	               amazoncar.eb_history a , "+
				"	               ( "+
				"	                SELECT /*+ leading(t1 t2 a) use_nl(t1 t2 a) */ "+
				"	                       a.pubcode , "+
				"	                       MAX( a.statusdate||a.status ) statusdate "+
				"	                FROM   amazoncar.eb_history a "+
				"	                WHERE  status NOT IN ( '11' ) "+
				"	                GROUP  BY a.pubcode "+
				"	               ) b "+
				"	        WHERE  decode('"+gubun1+"','2',t1.reg_dt,t1.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"	        AND    t1.resseq=t2.resseq "+
				"	        AND    t2.pubcode = a.pubcode "+
				"	        AND    a.status NOT IN ( '11' ) "+
				"	        AND    a.pubcode=b.pubcode "+
				"	        AND    a.statusdate||a.status=b.statusdate "+
				"	       ) j , "+
				"	       amazoncar.users k , "+
				"	       ( "+
				"	        SELECT /*+ no_merge(b) use_hash(a b) */ "+
				"	               a.tax_no , "+
				"	               b.gubun , "+
				"	               b.email , "+
				"	               b.stime "+
				"	        FROM   ( "+
				"	                SELECT /*+ leading(a b c) use_nl(a b c)*/ "+
				"	                       a.client_id , "+
				"	                       a.recconame , "+
				"	                       a.tax_no , "+
				"	                       a.con_agnt_email , "+
				"	                       NVL( b.tax_code , c.reg_code ) tax_code "+
				"	                FROM   amazoncar.tax a , "+
				"	                       amazoncar.tax_item b , "+
				"	                       ( "+
				"	                        SELECT item_id , "+ 
				"	                               reg_code "+
				"	                        FROM   amazoncar.tax_item_list "+
				"	                        WHERE  item_seq=1 "+
				"	                       ) c "+
				"	                WHERE  a.item_id=b.item_id "+
				"	                AND    a.item_id=c.item_id "+ 
				"	                AND    decode('"+gubun1+"','2',a.reg_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"	               ) a , "+
				"	               ( "+
				"	                SELECT /*+ leading(t1) */ "+
				"	                       a.gubun , "+
				"	                       a.mailto , "+
				"	                       b.email , "+
				"	                       SUBSTR( a.sql , 5 ) SQL , "+
				"	                       a.gubun2 , "+
				"	                       MAX( b.stime ) stime "+
				"	                FROM   amazoncar.im_dmail_info_2 a , "+
				"	                       amazoncar.im_dmail_result_2 b "+
				"	                WHERE  a.seqidx=b.dmidx "+
				"	                GROUP  BY a.gubun , "+
				"	                       a.mailto , "+
				"	                       b.email , "+
				"	                       SUBSTR( a.sql , 5 ) , "+
				"	                       a.gubun2 "+
				"	               ) b "+
				"	        WHERE  a.tax_code=b.gubun "+
				"	        AND    a.con_agnt_email=b.email "+
				"	        AND    INSTR( b.mailto , a.recconame ) >0 "+
				"	        AND    a.client_id=nvl( b.gubun2 , a.client_id ) "+
				"	       ) l , "+
				"	       ( "+
				"	        SELECT /*+ no_merge(b) use_hash(a b) */ "+
				"	               a.tax_no , "+
				"	               b.gubun , "+
				"	               b.email , "+
				"	               b.stime "+
				"	        FROM   ( "+
				"	                SELECT /*+ leading(a b c) use_nl(a b c)*/ "+
				"	                       a.recconame , "+
				"	                       a.tax_no , "+
				"	                       a.con_agnt_email  "+
				"	                FROM   amazoncar.tax a , "+
				"	                       amazoncar.tax_item b , "+
				"	                       ( "+
				"	                        SELECT item_id , "+
				"	                               reg_code "+
				"	                        FROM   amazoncar.tax_item_list "+
				"	                        WHERE  item_seq=1 "+
				"	                       ) c "+
				"	                WHERE  a.item_id=b.item_id "+
				"	                AND    a.item_id=c.item_id "+
				"	                AND    decode('"+gubun1+"','2',a.reg_dt,a.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"	               ) a , "+
				"	               ( "+
				"	                SELECT /*+ leading(t1 a b)  use_nl(t1 a b)*/ "+
				"	                       a.gubun , "+
				"	                       a.mailto , "+
				"	                       b.email , "+
				"	                       SUBSTR( a.sql , 5 ) SQL , "+
				"	                       MAX( b.stime ) stime  "+
				"	                FROM   amazoncar.im_dmail_info_2 a , "+
				"	                       amazoncar.im_dmail_result_2 b "+
				"	                WHERE  a.seqidx=b.dmidx "+
				"	                GROUP  BY a.gubun , "+
				"	                       a.mailto , "+
				"	                       b.email , "+
				"	                       SUBSTR( a.sql , 5 ) "+
				"	               ) b "+
				"	        WHERE  a.tax_no=b.gubun "+
				"	        AND    a.con_agnt_email=b.email "+
				"	        AND    INSTR( b.mailto , a.recconame ) >0 "+
				"	       ) l2 , "+
				"	       ( "+
				"	        SELECT /*+ use_nl(t1 t2 a) index(a)*/ "+
				"	               a.pubcode , "+
				"	               a.nts_issueid , "+
				"	               a.nts_seq , "+
				"	               a.nts_stat , "+
				"	               a.nts_result , "+
				"	               a.nts_msg , "+
				"	               c.nts_result_cont "+
				"	        FROM   amazoncar.tax t1 , "+
				"	               amazoncar.saleebill t2 , "+
				"	               amazoncar.eb_nts_hist a , "+
				"	               ( "+
				"	                SELECT a.pubcode , "+
				"	                       MAX( a.nts_issueid||a.nts_seq ) nts_seq "+
				"	                FROM   amazoncar.eb_nts_hist a "+
				"	                GROUP  BY a.pubcode "+
				"	               ) b , "+
				"	               amazoncar.eb_nts_result_code c "+
				"	        WHERE  decode('"+gubun1+"','2',t1.reg_dt,t1.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"	        AND    t1.resseq=t2.resseq "+
				"	        AND    t2.pubcode = a.pubcode "+
				"	        AND    a.pubcode=b.pubcode "+
				"	        AND    a.nts_issueid||a.nts_seq=b.nts_seq "+
				"	        AND    a.nts_result=c.nts_result( + ) "+
				"	       ) m "+
				"	WHERE  a.item_id=n.item_id( + ) \n"+
				"	AND    a.client_id=b.client_id( + ) \n"+
				"	AND    a.rent_l_cd=c.rent_l_cd( + ) \n"+
				"	AND    c.car_mng_id=d.car_mng_id( + ) \n"+
				"	AND    a.client_id=g.user_id( + ) \n"+
				"	AND    n.rent_l_cd=e.rent_l_cd( + ) \n"+
				"	AND    n.tm=e.fee_tm( + ) \n"+
				"	AND    n.rent_st=e.rent_st( + ) \n"+
				"	AND    n.rent_seq=e.rent_seq( + ) \n"+
				"	AND    a.client_id=f.client_id( + ) \n"+
				"	AND    a.seq=f.seq( + ) \n"+
				"	AND    a.resseq=h.resseq( + ) \n"+
				"	AND    h.pubcode=i.pubcode( + ) \n"+
				"	AND    h.pubcode=j.pubcode( + ) \n"+
				"	AND    NVL( c.bus_id2 , c.bus_id ) =k.user_id( + ) \n"+
				"	AND    a.tax_no=l.tax_no( + ) \n"+
				"	AND    a.tax_no=l2.tax_no( + ) \n"+
				"	AND    h.pubcode=m.pubcode( + ) \n"+
				"	AND    decode('"+gubun1+"','2',a.reg_dt,a.tax_dt)  between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n";
											
			//발행구분
			if(chk1.equals("1"))		query += " and a.tax_g like '대여료%' and a.tax_st='O'";
			if(chk1.equals("2"))		query += " and a.tax_g not like '대여료%' and a.tax_st='O'";
			if(chk1.equals("3"))		query += " and (a.tax_st='M' or a.m_tax_no is not null)";
			if(chk1.equals("4"))		query += " and a.tax_st='C'";
			if(chk1.equals("5"))		query += " and a.tax_st='O'";
			if(chk1.equals("6"))		query += " and a.doctype is not null";

			//품목구분
			if(chk2.equals("1"))		query += " and a.tax_g like '대여료%'";
			if(chk2.equals("2"))		query += " and substr(a.tax_g,1,3) in ('선납금','개시대','대차료')";
			if(chk2.equals("4"))		query += " and a.tax_g like 'Self%'";
			if(chk2.equals("5"))		query += " and a.tax_g like '보험대차%'";
			if(chk2.equals("6"))		query += " and a.tax_g like '%매각%'";
			if(chk2.equals("7"))		query += " and a.tax_g like '차량수리%'";
			if(chk2.equals("8"))		query += " and substr(a.tax_g,1,3) in ('사고대','휴차료','대차료')";
			if(chk2.equals("9"))		query += " and a.tax_bigo like '%해지%'";
			if(chk2.equals("10"))		query += " and a.gubun is null";

			//출력여부
			if(chk3.equals("1"))		query += " and a.print_dt is not null";
			if(chk3.equals("2"))		query += " and a.print_dt is null";

			//자동전표
			if(chk4.equals("1"))		query += " and a.autodocu_write_date is not null";
			if(chk4.equals("2"))		query += " and a.autodocu_write_date is null";

			String search = "";
			if(s_kd.equals("1"))		search = "nvl(a.recconame,decode(a.gubun,'13',g.user_nm,b.firm_nm))";
			else if(s_kd.equals("2"))	search = "a.rent_l_cd";
			else if(s_kd.equals("3"))	search = "d.car_no";
			else if(s_kd.equals("4"))	search = "decode(a.gubun,'13', TEXT_DECRYPT(g.user_ssn, 'pw' ), decode(a.tax_type,'1',b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ),'2', TEXT_DECRYPT(f.enp_no, 'pw' ) ))";
			else if(s_kd.equals("5"))	search = "a.tax_no";
			else if(s_kd.equals("6"))	search = "a.tax_g||a.tax_bigo";
			else if(s_kd.equals("7"))	search = "c.bus_id2";
			else if(s_kd.equals("8"))	search = "b.etax_not_cau";
			else if(s_kd.equals("9"))	search = "h.pubcode";
			else if(s_kd.equals("10"))	search = "a.con_agnt_email";

			if(s_kd.equals("10") && t_wd1.equals("") && t_wd2.equals("")){
				query += " and a.con_agnt_email is null";
			}else{
				if(!search.equals("")){
					if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
					if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";
				}
			}


		if(sort.equals("1"))		query += " order by nvl(a.recconame,decode(a.gubun,'13',g.user_nm,b.firm_nm)) "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by d.car_no "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' )) "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.tax_no "+asc;
		if(sort.equals("5"))		query += " order by a.tax_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by a.reg_dt "+asc+", a.tax_no";
		if(sort.equals("7"))		query += " order by a.print_dt "+asc+", a.tax_no";
		if(sort.equals("8"))		query += " order by c.bus_id2 "+asc+", a.tax_no";

		
		
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxMngList_2010]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxMngList_2010]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자세금계산서 국세청 처리상태 체크
	 */
	public int getEb_nts_hist_chk(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0) cnt"+
				" from   tax a, saleebill b, eb_nts_hist d"+
				" where  a.tax_no='"+tax_no+"' "+
				"        and a.resseq=b.resseq and b.pubcode=d.pubcode and b.nts_issueid=d.nts_issueid and d.nts_stat<>'40' "+
				"  ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	    		
    	
			if(rs.next())
			{								
				 count = rs.getInt("cnt");
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getEb_nts_hist_chk]\n"+e);
			System.out.println("[ScdMngDatabase:getEb_nts_hist_chk]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	전자세금계산서 처리상태 체크
	 */
	public int getEb_status_chk(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0) cnt"+
				" from   EB_STATUS"+
				" where  pubcode in (select pubcode from saleebill where taxsnum1='"+tax_no+"' )"+
				"  ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	    		
    	
			if(rs.next())
			{								
				 count = rs.getInt("cnt");
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getEb_status_chk]\n"+e);
			System.out.println("[ScdMngDatabase:getEb_status_chk]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	세금계산서 발행일자 조회
	 */
	public String getScdTaxDt(String gubun, String rent_l_cd, String rent_st, String rent_seq, String tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String tax_dt = "";
		String query = "";

		query = " select c.tax_dt"+
				" from   tax_item_list a, tax c"+
				" where  a.rent_l_cd='"+rent_l_cd+"' and a.tm='"+tm+"' and a.gubun='"+gubun+"' "+
				" and    a.item_id=c.item_id and c.tax_st='O' and c.doctype is null ";

		if(!rent_st.equals(""))			query += " and a.rent_st='"+rent_st+"'";
		if(!rent_seq.equals(""))		query += " and a.rent_seq='"+rent_seq+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	    		
    	

			if(rs.next())
			{								
				 tax_dt = rs.getString("tax_dt");
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getScdTaxDt]\n"+e);
			System.out.println("[ScdMngDatabase:getScdTaxDt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tax_dt;
		}
	}

	/**
	 *	세금계산서 보관함 리스트 조회
	 */
	public Vector getTaxMngList_201006(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String chk7, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select  /*+ leading(A C H) use_nl(a c h)  index(c CONT_IDX8)  index(h SALEEBILL_PK) index(i EB_STATUS_PK) */ \n"+
				"    	   NVL( a.recconame , decode( a.gubun , '13' , g.user_nm , b.firm_nm ) ) firm_nm , \n"+
				"	       SUBSTR( NVL( a.recconame , decode( a.gubun , '13' , g.user_nm , b.firm_nm ) ) , 1 , 15 ) firm_nm2 , \n"+
				"	       NVL( a.reccoceo , decode( a.gubun , '13' , '-' , b.client_nm ) ) client_nm , \n"+
				"	       NVL( a.reccoregno , decode( a.gubun , '13' , TEXT_DECRYPT(g.user_ssn, 'pw' )  , decode( a.tax_type , '1' , b.enp_no , '2' , NVL( TEXT_DECRYPT(f.enp_no , 'pw' )  , b.enp_no ) ) ) ) enp_no , \n"+
				"	       NVL( a.reccossn , decode( a.gubun , '13' , TEXT_DECRYPT(g.user_ssn, 'pw' ) , TEXT_DECRYPT(b.ssn, 'pw' ) ) ) ssn , \n"+
				"	       ( a.tax_supply+a.tax_value ) tax_amt ,     a.* , \n"+
				"	       SUBSTR( a.mail_dt , 1 , 12 ) mail_dt ,   h.pubcode , \n"+
				"	       decode( j.status , '25' , '수신자미등록' , '30' , '수신자미확인' , '35' , '수신자미승인' , '50' , '수신자승인' , '60' , '수신거부' , '65' , '수신자발행취소요청' , '66' , '공급자발행취소요청' , '99' , '발급취소' , '11' , '중복데이타' , '12' , 'ID불일치' , '13' , '인증서불일치' , '14' , '기타에러' , decode( a.resseq , '' , '' , '대기' ) ) status , \n"+
				"	       SIGN( TO_DATE( '20060430' , 'YYYYMMDD' ) - TO_DATE( tax_dt , 'YYYYMMDD' ) ) ebill_yn , \n"+
				"	       a.gubun ,      b.etax_not_cau , k.user_nm AS bus_nm2 ,  \n"+
				"	       b.con_agnt_email AS con_agnt_email2 ,  b.con_agnt_m_tel AS con_agnt_m_tel2 , "+
				"	       decode( a.tax_st , 'O' , decode(a.doctype,'','정상','수정') , 'C' , '발급취소' , 'M' , '매출취소' ) tax_st_nm , \n"+
				"	       decode( a.doctype , '01' , '기재사항정정' , '02' , '공급가액변동' , '03' , '환입' , '04' , '계약해제' , '06','이중발급', '' ) doctype_nm , "+
				"	       decode( a.unity_chk , '1' , '[통합]' , '' ) unity_chk_nm, nvl(b.tm_print_yn,'Y') tm_print_yn \n"+
				" FROM   tax a , "+
				"	       ( "+
				"	        SELECT /*+ index(tax_item_list TAX_ITEM_LIST_IDX3  ) */ "+
				"	               * "+
				"	        FROM   tax_item_list "+
				"	        WHERE  item_seq=1 "+
				"	       ) n , \n "+
				"	       client b , "+
				"	       cont c , "+
				"	       car_reg d , "+
				"	       client_site f , "+
				"	       users g , "+
				"	       saleebill h , "+
				"	       eb_status i , \n "+
				"	       ( "+
				"	        SELECT /*+ use_nl(t1 t2 a) */ "+
				"	               a.pubcode , "+
				"	               a.status "+
				"	        FROM   amazoncar.tax t1 , "+
				"	               amazoncar.saleebill t2 , "+
				"	               amazoncar.eb_history a , "+
				"	               ( "+
				"	                SELECT  "+
				"	                       a.pubcode , "+
				"	                       MAX( a.statusdate||decode(a.status,'99',0,'30',1,a.status) ) statusdate "+
				"	                FROM   amazoncar.eb_history a "+
				"	                WHERE  status NOT IN ( '11' ) "+
				"	                GROUP  BY a.pubcode "+
				"	               ) b "+
				"	        WHERE  decode('"+gubun1+"','2',t1.reg_dt,t1.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"	        AND    t1.resseq=t2.resseq "+
				"	        AND    t2.pubcode = a.pubcode "+
				"	        AND    a.status NOT IN ( '11' ) "+
				"	        AND    a.pubcode=b.pubcode "+
				"	        AND    a.statusdate||decode(a.status,'99',0,'30',1,a.status)=b.statusdate "+
				"	       ) j , \n"+
				"	       amazoncar.users k, \n "+
				"	       (select /*+ index(scd_fee SCD_FEE_IDX4)*/ * from amazoncar.scd_fee where tm_st1='0') l \n "+
				"	WHERE  a.item_id=n.item_id( + ) \n"+
				"	AND    a.client_id=b.client_id( + ) \n"+
				"	AND    a.rent_l_cd=c.rent_l_cd( + ) \n"+
				"	AND    c.car_mng_id=d.car_mng_id( + ) \n"+
				"	AND    a.client_id=g.user_id( + ) \n"+
				"	AND    a.client_id=f.client_id( + ) \n"+
				"	AND    a.seq=f.seq( + ) \n"+
				"	AND    a.resseq=h.resseq( + ) \n"+
				"	AND    h.pubcode=i.pubcode( + ) \n"+
				"	AND    h.pubcode=j.pubcode( + ) \n"+
				"	AND    NVL( c.bus_id2 , c.bus_id ) =k.user_id( + ) \n"+
				"	AND    n.rent_l_cd=l.rent_l_cd( + ) \n"+
				"	AND    n.rent_st=l.rent_st( + ) \n"+
				"	AND    n.rent_seq=l.rent_seq( + ) \n"+
				"	AND    n.tm=l.fee_tm( + ) \n"+
				"	AND    decode('"+gubun1+"','2',a.reg_dt,a.tax_dt)  between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n";

								

			//발행구분
			if(chk1.equals("1"))		query += " and a.tax_st='O' and a.doctype is null";
			if(chk1.equals("2"))		query += " and a.tax_st='O' and a.doctype is not null";
			if(chk1.equals("4"))		query += " and a.tax_st='C'";

			String search = "";
			if(s_kd.equals("1"))		search = "nvl(a.recconame,decode(a.gubun,'13',g.user_nm,b.firm_nm))";
			else if(s_kd.equals("2"))	search = "a.rent_l_cd";
			else if(s_kd.equals("3"))	search = "d.car_no";
			else if(s_kd.equals("4"))	search = "decode(a.gubun,'13',TEXT_DECRYPT(g.user_ssn, 'pw' ), decode(a.tax_type,'1',b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ),'2', TEXT_DECRYPT(f.enp_no, 'pw' ) ))";
			else if(s_kd.equals("5"))	search = "a.tax_no";
			else if(s_kd.equals("6"))	search = "a.tax_g||a.tax_bigo";
			else if(s_kd.equals("7"))	search = "c.bus_id2";
			else if(s_kd.equals("8"))	search = "b.etax_not_cau";
			else if(s_kd.equals("9"))	search = "h.pubcode";
			else if(s_kd.equals("10"))	search = "a.con_agnt_email";
			else if(s_kd.equals("11"))	search = "l.tm_st2";
			else if(s_kd.equals("12"))	search = "h.nts_issueid";
			else if(s_kd.equals("13"))	search = "b.firm_nm";
			else if(s_kd.equals("14"))	search = "n.reg_code";
			

			if(s_kd.equals("10") && t_wd1.equals("") && t_wd2.equals("")){
				query += " and a.con_agnt_email is null";
			}else if(s_kd.equals("11")){
				query += " and l.tm_st2='3'";
			}else if(s_kd.equals("12")){
					query += " and  "+search+" like replace('%"+t_wd1+"%','-','')";
			}else{
				if(!search.equals("")){
					if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
					if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";
				}
			}


		if(sort.equals("1"))		query += " order by nvl(a.recconame,decode(a.gubun,'13',g.user_nm,b.firm_nm)) "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by d.car_no "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' )) "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.tax_no "+asc;
		if(sort.equals("5"))		query += " order by a.tax_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by a.reg_dt "+asc+", a.tax_no";
		if(sort.equals("7"))		query += " order by a.print_dt "+asc+", a.tax_no";
		if(sort.equals("8"))		query += " order by c.bus_id2 "+asc+", a.tax_no";

		
		
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
    			
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxMngList_201006]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxMngList_201006]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}


	/**
	 *	세금계산서 보관함 리스트 조회
	 */
	public Vector getTaxMngList_201401(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String chk7, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		String search_dt2 = "a.tax_dt";
		if(gubun1.equals("2")) search_dt2 = "a.reg_dt";
		
		query = " select  \n"+
				"    	   a.recconame as firm_nm , \n"+
				"	       SUBSTR( a.recconame , 1 , 15 ) as firm_nm2 , \n"+
				"	       a.reccoceo as client_nm , \n"+
				"	       a.reccoregno as enp_no , \n"+
				"	       a.reccossn as ssn , \n"+
				"	       ( a.tax_supply+a.tax_value ) tax_amt, a.* , \n"+
				"	       h.pubcode , \n"+
				"	       decode( j.status , '25' , '수신자미등록' , '30' , '수신자미확인' , '35' , '수신자미승인' , '50' , '수신자승인' , '60' , '수신거부' , '65' , '수신자발행취소요청' , '66' , '공급자발행취소요청' , '99' , '발급취소' , '11' , '중복데이타' , '12' , 'ID불일치' , '13' , '인증서불일치' , '14' , '기타에러' , decode( a.resseq , '' , '' , '대기' ) ) status , \n"+
				"	       decode( a.tax_st , 'O' , decode(a.doctype,'','정상','수정') , 'C' , '발급취소' , 'M' , '매출취소' ) tax_st_nm , \n"+
				"	       decode( a.doctype , '01' , '기재사항정정' , '02' , '공급가액변동' , '03' , '환입' , '04' , '계약해제' , '06','이중발급', '' ) doctype_nm , "+
				"	       decode( a.unity_chk , '1' , '[통합]' , '' ) unity_chk_nm, nvl(b.tm_print_yn,'Y') tm_print_yn \n"+
				" FROM     amazoncar.tax a , "+
				"	       amazoncar.client b , "+
				"	       amazoncar.saleebill h , "+
				"	       ( "+
				"	        SELECT "+
				"	               a.pubcode, "+
				"	               a.status "+
				"	        FROM   amazoncar.eb_history a , "+
				"	               ( "+
				"                    SELECT  \n"+
                "                           pubcode, MAX( statusdate||status ) KEEP( DENSE_RANK FIRST ORDER BY pubcode, statusdate DESC, decode(status,'99',0,'30',1,status) DESC) AS seq \n"+
                "                    FROM   EB_HISTORY  \n"+
				"	                 WHERE  status <>  '11'  "+
                "                    GROUP BY pubcode \n"+
				"	               ) b "+
				"	        WHERE  a.status <>  '11'  "+
				"	        AND    a.pubcode=b.pubcode "+
				"	        AND    a.statusdate||status=b.seq "+
				"	       ) j  \n"+
				"	WHERE  a.tax_dt >= '20130101' \n"+
				"	AND    "+search_dt2+"  between '"+st_dt+"' and '"+end_dt+"' \n"+
				"	and    a.client_id=b.client_id(+) \n"+
				"	AND    a.resseq=h.resseq( + ) \n"+
				"	AND    h.pubcode=j.pubcode( + ) \n"+
                " ";

								

			//발행구분
			if(chk1.equals("1"))		query += " and a.tax_st='O' and a.doctype is null";
			if(chk1.equals("2"))		query += " and a.tax_st='O' and a.doctype is not null";
			if(chk1.equals("3"))		query += " and a.tax_st='C'";

			String search = "";
			if(s_kd.equals("1"))		search = "a.recconame";
			else if(s_kd.equals("2"))	search = "a.rent_l_cd";
			else if(s_kd.equals("3"))	search = "a.car_no";
			else if(s_kd.equals("4"))	search = "a.reccoregno";
			else if(s_kd.equals("5"))	search = "a.tax_no";
			else if(s_kd.equals("6"))	search = "a.tax_g||a.tax_bigo";
			else if(s_kd.equals("9"))	search = "h.pubcode";
			else if(s_kd.equals("10"))	search = "a.con_agnt_email";
			else if(s_kd.equals("12"))	search = "h.nts_issueid";
			else if(s_kd.equals("13"))	search = "decode(a.gubun,'13',a.recconame,b.firm_nm)";
			

			if(s_kd.equals("10") && t_wd1.equals("") && t_wd2.equals("")){
				query += " and a.con_agnt_email is null";
			}else if(s_kd.equals("12")){
					query += " and  "+search+" like replace('%"+t_wd1+"%','-','')";
			}else{
				if(!search.equals("")){
					if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
					if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";
				}
			}


		if(sort.equals("1"))		query += " order by a.recconame "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by a.car_no "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by a.reccoregno "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.tax_no "+asc;
		if(sort.equals("5"))		query += " order by a.tax_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by a.reg_dt "+asc+", a.tax_no";
		if(sort.equals("7"))		query += " order by a.print_dt "+asc+", a.tax_no";


		
		
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
    			
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxMngList_201401]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxMngList_201401]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	세금계산서 보관함 리스트 조회
	 */
	public Vector getTaxMngList2010(String s_br, String chk1, String chk2, String chk3, String chk4, String chk5, String chk6, String chk7, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select  \n"+
				"    	   NVL( a.recconame , decode( a.gubun , '13' , g.user_nm , b.firm_nm ) ) firm_nm , \n"+
				"	       SUBSTR( NVL( a.recconame , decode( a.gubun , '13' , g.user_nm , b.firm_nm ) ) , 1 , 15 ) firm_nm2 , \n"+
				"	       NVL( a.reccoceo , decode( a.gubun , '13' , '-' , b.client_nm ) ) client_nm , \n"+
				"	       NVL( a.reccoregno , decode( a.gubun , '13' , TEXT_DECRYPT(g.user_ssn, 'pw' ) , decode( a.tax_type , '1' , b.enp_no , '2' , NVL(  TEXT_DECRYPT(f.enp_no, 'pw' )  , b.enp_no ) ) ) ) enp_no , \n"+
				"	       NVL( a.reccossn , decode( a.gubun , '13' ,  TEXT_DECRYPT(g.user_ssn, 'pw' ) ,  TEXT_DECRYPT(b.ssn, 'pw' ) ) ) ssn , \n"+
				"	       ( a.tax_supply+a.tax_value ) tax_amt ,     a.* , \n"+
				"	       h.pubcode , \n"+
				"	       decode( j.status , '25' , '수신자미등록' , '30' , '수신자미확인' , '35' , '수신자미승인' , '50' , '수신자승인' , '60' , '수신거부' , '65' , '수신자발행취소요청' , '66' , '공급자발행취소요청' , '99' , '발급취소' , '11' , '중복데이타' , '12' , 'ID불일치' , '13' , '인증서불일치' , '14' , '기타에러' , decode( a.resseq , '' , '' , '대기' ) ) status , \n"+
				"	       decode( a.tax_st , 'O' , decode(a.doctype,'','정상','수정') , 'C' , '발급취소' , 'M' , '매출취소' ) tax_st_nm , \n"+
				"	       decode( a.doctype , '01' , '기재사항정정' , '02' , '공급가액변동' , '03' , '환입' , '04' , '계약해제' , '06','이중발급', '' ) doctype_nm , "+
				"	       decode( a.unity_chk , '1' , '[통합]' , '' ) unity_chk_nm, nvl(b.tm_print_yn,'Y') tm_print_yn \n"+
				" FROM     tax_"+gubun2+" a , "+
				"	       client b , "+
				"	       client_site f , "+
				"	       users g , "+
				"	       saleebill_"+gubun2+" h , "+
				"	       ( "+
				"	        SELECT /*+ use_nl(t1 t2 a) */ "+
				"	               a.pubcode , "+
				"	               a.status "+
				"	        FROM   tax_"+gubun2+" t1 , "+
				"	               saleebill_"+gubun2+" t2 , "+
				"	               eb_history a , "+
				"	               ( "+
				"	                SELECT  "+
				"	                       a.pubcode , "+
				"	                       MAX( a.statusdate||decode(a.status,'99',0,'30',1,a.status) ) statusdate "+
				"	                FROM   amazoncar.eb_history a "+
				"	                WHERE  status NOT IN ( '11' ) "+
				"	                GROUP  BY a.pubcode "+
				"	               ) b "+
				"	        WHERE  decode('"+gubun1+"','2',t1.reg_dt,t1.tax_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"	        AND    t1.resseq=t2.resseq "+
				"	        AND    t2.pubcode = a.pubcode "+
				"	        AND    a.status NOT IN ( '11' ) "+
				"	        AND    a.pubcode=b.pubcode "+
				"	        AND    a.statusdate||decode(a.status,'99',0,'30',1,a.status)=b.statusdate "+
				"	       ) j  \n"+
				"	WHERE  \n"+ //2010년이전
				"	       decode('"+gubun1+"','2',a.reg_dt,a.tax_dt)  between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') \n"+
				"	AND    a.client_id=b.client_id( + ) \n"+
				"	AND    a.client_id=g.user_id( + ) \n"+
				"	AND    a.client_id=f.client_id( + ) \n"+
				"	AND    a.seq=f.seq( + ) \n"+
				"	AND    a.resseq=h.resseq( + ) \n"+
				"	AND    h.pubcode=j.pubcode( + ) \n"+
				"	";

								

			//발행구분
			if(chk1.equals("1"))		query += " and a.tax_st='O' and a.doctype is null";
			if(chk1.equals("2"))		query += " and a.tax_st='O' and a.doctype is not null";
			if(chk1.equals("4"))		query += " and a.tax_st='C'";

			String search = "";
			if(s_kd.equals("1"))		search = "nvl(a.recconame,decode(a.gubun,'13',g.user_nm,b.firm_nm))";
			else if(s_kd.equals("2"))	search = "a.rent_l_cd";
			else if(s_kd.equals("3"))	search = "a.car_no";
			else if(s_kd.equals("4"))	search = "decode(a.gubun,'13',TEXT_DECRYPT(g.user_ssn, 'pw' ), decode(a.tax_type,'1',b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ),'2', TEXT_DECRYPT(f.enp_no, 'pw' ) ))";
			else if(s_kd.equals("5"))	search = "a.tax_no";
			else if(s_kd.equals("6"))	search = "a.tax_g||a.tax_bigo";
			else if(s_kd.equals("10"))	search = "a.con_agnt_email";
			else if(s_kd.equals("12"))	search = "h.nts_issueid";
			else if(s_kd.equals("13"))	search = "b.firm_nm";
			

			if(s_kd.equals("10") && t_wd1.equals("") && t_wd2.equals("")){
				query += " and a.con_agnt_email is null";
			}else if(s_kd.equals("12")){
					query += " and  "+search+" like replace('%"+t_wd1+"%','-','')";
			}else{
				if(!search.equals("")){
					if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
					if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";
				}
			}


		if(sort.equals("1"))		query += " order by nvl(a.recconame,decode(a.gubun,'13',g.user_nm,b.firm_nm)) "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by a.car_no "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by nvl(b.enp_no,TEXT_DECRYPT(b.ssn, 'pw' )) "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.tax_no "+asc;
		if(sort.equals("5"))		query += " order by a.tax_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by a.reg_dt "+asc+", a.tax_no";
		if(sort.equals("7"))		query += " order by a.print_dt "+asc+", a.tax_no";

		
		
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
    			
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTaxMngList2010]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxMngList2010]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	거래명세서 발행현황
	 */
	public Vector getTodayActStat(String gubun, String reg_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String s_dt = "";

		if(reg_dt.equals(""))	s_dt = "to_char(sysdate,'YYYYMMDD')";
		else					s_dt = "replace('"+reg_dt+"','-','')";
		

		if(gubun.equals("tax")){
			query = " select a.tax_code as gubun, count(0) cnt "+
					" from   tax_item a, tax b, client c "+
					" where  a.item_id=b.item_id "+
					" and    b.reg_dt= "+ s_dt +
					" and    b.gubun='1' "+
					" and    b.client_id=c.client_id "+
					" and    nvl(c.tax_mail_yn,'Y')='Y' "+
					" group by a.tax_code "+
					" order by a.tax_code ";				
		}else{
			query = " select a.reg_code as gubun, count(0) cnt "+
					" from   tax_item_list a, tax_item b, client c "+
					" where  to_char(a.reg_dt,'YYYYMMDD')= "+ s_dt +
					" and    a.gubun='1' "+
					" and    a.item_id=b.item_id "+
					" and    b.client_id=c.client_id "+
					" and    nvl(c.item_mail_yn,'Y')='Y' "+
					" group by a.reg_code "+
					" order by a.reg_code ";
		}
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();   	
    			
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getTodayActStat]\n"+e);
			System.out.println("[ScdMngDatabase:getTodayActStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	거래명세서 중복발행현황 리스트 조회
	 */
	public Vector getItemOverlapList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" b.firm_nm, b.client_nm, b.enp_no, TEXT_DECRYPT(b.ssn, 'pw' ) ssn,"+
				" to_char(f.reg_dt,'YYYY-MM-DD') reg_dt, to_char(f.reg_dt,'YYYYMMDD') reg_dt2, f.gubun, f.rent_l_cd, f.tm, f.item_g, f.item_car_no, f.item_supply, f.item_value, (f.item_supply+f.item_value) item_amt,"+
				" a.*"+
				" from tax_item a, tax_item_list f, tax e, client b, cont c, car_reg d, scd_fee g"+
				" where"+
				" a.item_dt >= '20130101' "+
				" and nvl(a.use_yn,'Y')='Y' "+
				" and a.item_id=f.item_id"+
				" and f.gubun='1' "+
				" and a.item_id=e.item_id(+)"+
				" and a.client_id=b.client_id"+
				" and f.rent_l_cd=c.rent_l_cd"+
				" and c.car_mng_id=d.car_mng_id(+)"+
				" and f.rent_l_cd=g.rent_l_cd and f.tm=g.fee_tm and f.rent_seq=g.rent_seq"+
				" and g.tm_st1='0' "+
				" and f.rent_st<>g.rent_st "+
				" and f.rent_l_cd||f.tm not in ('S107HRTR0010337') "+
				" ";

		if(!s_br.equals(""))	query += " and e.branch_g like '"+s_br+"%'";


		//기간구분
		if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.item_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("2") && !st_dt.equals(""))		query += " and to_char(f.reg_dt,'YYYYMMDD') between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";



		String search = "";
		if(s_kd.equals("1"))		search = "b.firm_nm";
		else if(s_kd.equals("2"))	search = "c.rent_l_cd";
		else if(s_kd.equals("3"))	search = "d.car_no";
		else if(s_kd.equals("4"))	search = "b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' ) ";
		else if(s_kd.equals("5"))	search = "a.item_id";
		else if(s_kd.equals("6"))	search = "a.item_g";

		if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
		if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";


		if(sort.equals("1"))		query += " order by b.firm_nm "+asc+", a.tax_no";
		if(sort.equals("2"))		query += " order by c.car_no "+asc+", a.tax_no";
		if(sort.equals("3"))		query += " order by nvl(b.enp_no, TEXT_DECRYPT(b.ssn, 'pw' )) "+asc+", a.tax_no";
		if(sort.equals("4"))		query += " order by a.item_id "+asc;
		if(sort.equals("5"))		query += " order by a.item_dt "+asc+", a.tax_no";
		if(sort.equals("6"))		query += " order by f.reg_dt "+asc+", a.tax_no";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getItemOverlapList]\n"+e);
			System.out.println("[ScdMngDatabase:getItemOverlapList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	거래명세서 중복발행현황 리스트 조회
	 */
	public Vector getItemOverlapSubList1(String rent_l_cd, String tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.use_yn, c.recconame, c.tax_dt, b.client_id, b.item_dt, b.item_hap_num, to_char(a.reg_dt,'YYYYMMDD') rag_dt2, a.* "+
				" from   tax_item_list a, tax_item b, tax c "+
				" where  a.gubun='1' and a.rent_l_cd='"+rent_l_cd+"' and a.tm='"+tm+"' and a.item_id=b.item_id and a.item_id=c.item_id(+)"+
				" order by a.item_id";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getItemOverlapSubList1]\n"+e);
			System.out.println("[ScdMngDatabase:getItemOverlapSubList1]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	거래명세서 중복발행현황 리스트 조회
	 */
	public Vector getItemOverlapSubList2(String rent_l_cd, String tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, (fee_s_amt+fee_v_amt) fee_amt from scd_fee a where a.rent_l_cd='"+rent_l_cd+"' and a.fee_tm='"+tm+"' and a.tm_st1='0' order by rent_st";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getItemOverlapSubList2]\n"+e);
			System.out.println("[ScdMngDatabase:getItemOverlapSubList2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	중간회차 미발행현황
	 */
	public Vector getFeeScdHoleTax()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct \n"+
				"        f.firm_nm, \n"+
				"        decode(d.cls_st,'1','계약만료','2','중도해지','3','영업소변경','4','차종변경','5','계약승계','6','매각','8','매입옵션') cls_st, \n"+
				"        d.cls_dt, \n"+
				"        a.rent_l_cd, a.fee_est_dt, a.tax_out_dt, \n"+
				"        b.fee_tm m_fee_tm, a.fee_tm, c.fee_tm p_fee_tm, bb.tax_dt m_tax_dt, aa.tax_dt, cc.tax_dt p_tax_dt \n"+
				" from   scd_fee a, \n"+
				"        (select * from scd_fee where tm_st1='0' and bill_yn='Y') b, \n"+
				"        (select * from scd_fee where tm_st1='0' and bill_yn='Y') c, \n"+
				"        (select a.tax_dt, b.rent_l_cd, b.tm from tax a, tax_item_list b where a.tax_st='O' and a.gubun='1' and a.item_id=b.item_id) aa, \n"+
				"        (select a.tax_dt, b.rent_l_cd, b.tm from tax a, tax_item_list b where a.tax_st='O' and a.gubun='1' and a.item_id=b.item_id) bb, \n"+
				"        (select a.tax_dt, b.rent_l_cd, b.tm from tax a, tax_item_list b where a.tax_st='O' and a.gubun='1' and a.item_id=b.item_id) cc, \n"+
				"        cls_cont d, cont e, client f \n"+
				" where \n"+
				"       a.tm_st1='0' and a.bill_yn='Y' and a.fee_s_amt>0 \n"+
				" and   a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.fee_tm=b.fee_tm-1 \n"+
				" and   a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.fee_tm=c.fee_tm+1 \n"+
				" and   a.rent_l_cd=aa.rent_l_cd(+) and a.fee_tm=aa.tm(+) \n"+
				" and   b.rent_l_cd=bb.rent_l_cd(+) and b.fee_tm=bb.tm(+) \n"+
				" and   c.rent_l_cd=cc.rent_l_cd(+) and c.fee_tm=cc.tm(+) \n"+
				" and   bb.TAX_DT is not null and cc.tax_dt is not null and aa.tax_dt is null \n"+
				" and   a.fee_est_dt > '20121231' \n"+
				" and   a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \n"+
				" and   a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				" and   e.client_id=f.client_id \n"+
				" and   a.rent_l_cd||a.fee_tm not in ('S104KJHR0000815','K104KOPL0002915')\n"+
				" order by a.fee_est_dt";


		try {
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getFeeScdHoleTax]\n"+e);
			System.out.println("[ScdMngDatabase:getFeeScdHoleTax]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	수시발행 - 대차료 스케줄
	 */
	public Hashtable getMyAccidLScdTaxPay(String car_mng_id, String accid_id, String seq_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select b.car_mng_id, a.ext_id, sum(a.ext_pay_amt) ext_pay_amt, max(a.ext_pay_dt) ext_pay_dt "+
				"       from   scd_ext a, cont b "+
				"       where  a.ext_st='6' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				"       and b.car_mng_id='"+car_mng_id+"' and a.ext_id ='"+accid_id+""+seq_no+"' "+
				" GROUP BY b.car_mng_id, a.ext_id ";

		try {
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getMyAccidLScdTaxPay]\n"+e);
			System.out.println("[ScdMngDatabase:getMyAccidLScdTaxPay]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	수시발행 - 대차료 스케줄
	 */
	public Hashtable getMyAccidLScdTax(String car_mng_id, String accid_id, String seq_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.car_mng_id, a.fee_tm, b.rent_seq, sum(a.tax_supply+a.tax_value) tax_amt, max(a.tax_dt) tax_dt "+
				"       from   tax a, tax_item_list b "+
				"       where  a.gubun in ('11','12') and a.tax_st<>'C' and a.item_id=b.item_id "+
				"       and a.car_mng_id='"+car_mng_id+"' and a.fee_tm||b.rent_seq ='"+accid_id+""+seq_no+"' "+
				"       group by a.car_mng_id, a.fee_tm, b.rent_seq ";

		try {
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getMyAccidLScdTax]\n"+e);
			System.out.println("[ScdMngDatabase:getMyAccidLScdTax]\n"+query);
			e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	전자세금계산서 국세청 처리상태 체크
	 */
	public int getEb_nts_hist_chk(String tax_no, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0) cnt"+
				" from   tax_"+gubun2+" a, saleebill_"+gubun2+" b, eb_nts_hist d"+
				" where  a.tax_no='"+tax_no+"' "+
				"        and a.resseq=b.resseq and b.pubcode=d.pubcode and b.nts_issueid=d.nts_issueid and d.nts_stat<>'40' "+
				"  ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	    		
    	
			if(rs.next())
			{								
				 count = rs.getInt("cnt");
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getEb_nts_hist_chk(String tax_no, String gubun2)]\n"+e);
			System.out.println("[ScdMngDatabase:getEb_nts_hist_chk(String tax_no, String gubun2)]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	전자세금계산서 처리상태 체크
	 */
	public int getEb_status_chk(String tax_no, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0) cnt"+
				" from   EB_STATUS"+
				" where  pubcode in (select pubcode from saleebill_"+gubun2+" where taxsnum1='"+tax_no+"' )"+
				"  ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	    		
    	
			if(rs.next())
			{								
				 count = rs.getInt("cnt");
			}

			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getEb_status_chk(String tax_no, String gubun2)]\n"+e);
			System.out.println("[ScdMngDatabase:getEb_status_chk(String tax_no, String gubun2)]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	전자세금계산서 이메일발송 건별 이력
	 */
	public Vector getMailHistoryList(String tax_no, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.*, decode(ocnt,'1','수신','미수신') ocnt_nm, decode(a.errcode,'','발송중','114','정상발송','100','정상발송','101','정상발송','실패-'||a.code_st2) msgflag_nm "+
				" from   "+
				"        ("+
				//구버전
				"          select c.*, b.msgflag, d.code_st2 "+
				"          from   tax_"+gubun2+" a, im_dmail_info_2 b, im_dmail_result_2 c, IM_DMAIL_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.tax_no=b.gubun and b.seqidx=c.dmidx(+) and c.ERRCODE=d.CODE_ID(+)"+
				"          union all"+
				"          select c.*, b.msgflag, d.code_st2 "+
				"          from   tax_"+gubun2+" a, (select item_id, max(reg_code) reg_code from tax_item_list_"+gubun2+" group by item_id) d, im_dmail_info_2 b, im_dmail_result_2 c, IM_DMAIL_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.item_id=d.item_id and d.reg_code=b.gubun and a.con_agnt_email=substr(b.sql,5) "+
				"                 and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				"          union all"+
				"          select c.*, b.msgflag, d.code_st2 "+
				"          from   tax_"+gubun2+" a, tax_item_"+gubun2+" d, im_dmail_info_2 b, im_dmail_result_2 c, IM_DMAIL_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.item_id=d.item_id and d.tax_code=b.gubun and a.con_agnt_email=substr(b.sql,5) "+
				"                 and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				"          union all"+
				//신버전
				"          select c.*, b.msgflag, d.send as code_st2 "+
				"          from   tax_"+gubun2+" a, im_dmail_info_6 b, im_dmail_result_6 c, IM_DMAIL_J_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.tax_no=b.gubun and b.seqidx=c.dmidx(+) and c.ERRCODE=d.CODE_ID(+)"+
				"          union all"+
				"          select c.*, b.msgflag, d.send as code_st2 "+
				"          from   tax_"+gubun2+" a, (select item_id, max(reg_code) reg_code from tax_item_list_"+gubun2+" group by item_id) d, im_dmail_info_6 b, im_dmail_result_6 c, IM_DMAIL_J_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.item_id=d.item_id and d.reg_code=b.gubun and a.con_agnt_email=substr(b.sql,5) "+
				"                 and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				"          union all"+
				"          select c.*, b.msgflag, d.send as code_st2 "+
				"          from   tax_"+gubun2+" a, tax_item_"+gubun2+" d, im_dmail_info_6 b, im_dmail_result_6 c, IM_DMAIL_J_ERRCODE d"+
				"          where  a.tax_no='"+tax_no+"' "+
				"                 and a.item_id=d.item_id and d.tax_code=b.gubun and a.con_agnt_email=substr(b.sql,5) "+
				"                 and b.seqidx=c.dmidx and c.ERRCODE=d.CODE_ID(+)"+
				" ) a"+
				" order by stime";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getMailHistoryList(String tax_no, String gubun2)]\n"+e);
			System.out.println("[ScdMngDatabase:getMailHistoryList(String tax_no, String gubun2)]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자세금계산서 트러스빌 건별 이력
	 */
	public Vector getEbHistoryList_2010(String tax_no, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.pubcode, c.STATUSDATE, c.REASON, "+
				"        decode(c.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','66','공급자발행취소요청','99','발급취소','11','중복데이타','12','ID불일치','13','인증서불일치','14','기타에러','') status_nm "+
				" from   saleebill_"+gubun2+" b, eb_history c"+
				" where  b.taxsnum1='"+tax_no+"' and b.pubcode=c.pubcode"+
				" order by c.STATUSDATE"+
				" ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getEbHistoryList_2010(String tax_no, String gubun2)]\n"+e);
			System.out.println("[ScdMngDatabase:getEbHistoryList_2010(String tax_no, String gubun2)]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	전자세금계산서 트러스빌 건별 이력
	 */
	public Vector getEbNtsHistoryList_2010(String tax_no, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        d.nts_stat, d.nts_result, d.nts_datetime, d.nts_msg, e.nts_result_cont,"+
				"        decode(d.nts_stat,'20','전송중','30','전송성공','40','전송실패','') nts_stat_nm, b.nts_issueid"+
				" from   saleebill_"+gubun2+" b, eb_nts_hist d, "+
				"        EB_NTS_RESULT_CODE e"+
				" where  b.taxsnum1='"+tax_no+"' "+
				"        and b.pubcode=d.pubcode and b.nts_issueid=d.nts_issueid(+) "+
				"        and d.nts_result=e.nts_result(+)"+
				" order by d.nts_datetime"+
				" ";


		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getEbNtsHistoryList_2010(String tax_no, String gubun2)]\n"+e);
			System.out.println("[ScdMngDatabase:getEbNtsHistoryList_2010(String tax_no, String gubun2)]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	세금계산서 합계표 리스트 조회
	 */
	public Vector getTaxHapList_2018(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String orderby1 = "decode(a.reccoregnotype,'01','1','2')";
		String orderby2 = "decode(replace(a.reccoregno,' ',''),'9999999999999',a.reccossn,a.reccoregno)";

		query = " select \n"+
				"        "+orderby1+" client_st,  \n"+
				"        "+orderby2+" enp_no, \n";

		if(gubun4.equals("3")){
			query += "       a.recconame firm_nm,  \n"+
					"        a.client_id, \n"+
					"        1 cnt, a.tax_supply, a.tax_value, a.tax_no as min_tax \n";
		}else{
			query += "       min(a.recconame) firm_nm,  \n"+
					"        min(a.client_id) client_id, \n"+
					"        count(a.tax_no) cnt, sum(a.tax_supply) tax_supply, sum(a.tax_value) tax_value, min(a.tax_no) min_tax \n";
		}

		query += " from   tax a\n"+
				"  where  nvl(a.tax_st,'O')<>'C' "+
				" ";

		if(!gubun1.equals("") && gubun2.equals("") && gubun3.equals("")) query += " and a.tax_dt like '"+gubun1+"%' \n";

		if(!gubun1.equals("") && !gubun2.equals("") && gubun3.equals("")){
			if(gubun2.equals("1"))	query += " and a.tax_dt between '"+gubun1+"0101' and '"+gubun1+"0331' \n";
			if(gubun2.equals("2"))	query += " and a.tax_dt between '"+gubun1+"0401' and '"+gubun1+"0630' \n";
			if(gubun2.equals("3"))	query += " and a.tax_dt between '"+gubun1+"0701' and '"+gubun1+"0930' \n";
			if(gubun2.equals("4"))	query += " and a.tax_dt between '"+gubun1+"1001' and '"+gubun1+"1231' \n";
		}

		if(!gubun1.equals("") && !gubun2.equals("") && !gubun3.equals("")) query += " and a.tax_dt like '"+gubun1+gubun3+"%' \n";

		if(!s_br.equals(""))		query += " and a.branch_g like '"+s_br+"%' \n";

		if(gubun4.equals("1"))		query += " and a.resseq is not null \n";
		if(gubun4.equals("2"))		query += " and a.resseq is null \n";

		if(gubun4.equals("3")){
			query += " order by decode("+orderby1+",2,'9','1'), "+orderby2+", a.tax_supply desc, a.tax_no ";
		}else{
			query += " group by "+orderby1+", "+orderby2+" \n"+
					 " order by decode("+orderby1+",2,'9','1'), "+orderby2+", max(a.tax_supply) desc ";
		}

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[ScdMngDatabase:getTaxHapList]\n"+e);
			System.out.println("[ScdMngDatabase:getTaxHapList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	//세금계산서 청구/영수용 금액 fetch(20191101)
	public Vector getGrtScdList2(String rent_l_cd, String rent_mng_id, String rent_st, String rent_seq, String ext_st, String ext_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from scd_ext where rent_l_cd='"+rent_l_cd+"' and rent_mng_id='"+rent_mng_id+"' "+
					 " 										 and rent_st='"+rent_st+"' and rent_seq='"+rent_seq+"'"+
					 "										 and ext_st='"+ext_st+"' and ext_id='"+ext_id+"'"+			
					 " ";
		query += " order by ext_tm asc ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();			
		} catch (SQLException e) {
			System.out.println("[ScdMngDatabase:getGrtScdList2]\n"+e);
			System.out.println("[ScdMngDatabase:getGrtScdList2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

}