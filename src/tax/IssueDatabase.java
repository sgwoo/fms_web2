package tax;

import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;

public class IssueDatabase
{
	private Connection conn = null;
	public static IssueDatabase db;
	
	public static IssueDatabase getInstance()
	{
		if(IssueDatabase.db == null)
			IssueDatabase.db = new IssueDatabase();
		return IssueDatabase.db;	
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
	 *	정기발행-개별발행 :계약건별 일괄발행리스트
	 *  
	 */	
	public Vector getIssue1List(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select \n"+
				"        decode(t.cls_st,'8','매입옵션','2','중도해지','1','계약만료','4','차종변경','5','계약승계','',decode(g.rent_l_cd,'','','발행중지'),'해지') as use_yn, \n"+
				"        t.cls_st, a.brch_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, \n"+
				"        nvl(m.firm_nm,b.firm_nm) firm_nm, d.r_site as site_nm, c.car_no, c.car_nm, \n"+
				"        e.rent_st, e.rent_seq, e.fee_tm, e.fee_s_amt, e.fee_v_amt, (e.fee_s_amt+e.fee_v_amt) fee_amt, \n"+
				"        e.fee_est_dt, e.r_fee_est_dt, e.req_dt, e.r_req_dt r_req_dt, e.tax_out_dt \n"+
				" from   cont a, client b, car_reg c, client_site d, scd_fee e, cls_cont t, \n"+
				"        (select * from tax where tax_st<>'C' and m_tax_no is null and (tax_g like '대여료%' or gubun='1')) f, \n"+
				"        (select a.* from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st='O' and a.gubun='1') h, \n"+
				"        (select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD')) g, \n"+
				"        (select a.*, decode(a.r_site,'',b.firm_nm, c.r_site) firm_nm, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)) m, \n"+
				"        (select rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, sum(rc_amt) rc_amt from scd_fee where rc_yn='1' group by rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq ) e2 \n"+
				" where \n"+
				" a.client_id=b.client_id and nvl(b.print_st,'1')='1' \n"+
				" and a.client_id=d.client_id(+) and a.r_site=d.seq(+) \n"+
				" and a.car_mng_id=c.car_mng_id(+) \n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.tm_st1='0' \n"+
				" and e.rent_l_cd=f.rent_l_cd(+) and e.fee_tm=f.fee_tm(+) \n"+
				" and e.rent_l_cd=h.rent_l_cd(+) and e.fee_tm=h.tm(+) \n"+
				" and f.rent_l_cd is null and h.rent_l_cd is null \n"+
				" and e.rent_mng_id=e2.rent_mng_id(+) and e.rent_l_cd=e2.rent_l_cd(+) and e.fee_tm=e2.fee_tm(+) and e.rent_st=e2.rent_st(+) and e.rent_seq=e2.rent_seq(+) \n"+
				" and e.rent_mng_id=g.rent_mng_id(+) and e.rent_l_cd=g.rent_l_cd(+) and e.rent_seq=g.rent_seq(+) "+
				" and decode(e.fee_s_amt+e.fee_v_amt,e2.rc_amt,'',g.rent_l_cd) is null \n"+
				" and e.rent_mng_id=m.rent_mng_id(+) and e.rent_l_cd=m.rent_l_cd(+) and e.rent_st=m.rent_st(+) and e.rent_seq=m.rent_seq(+) \n"+
				" and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) \n"+
				" and nvl(e.bill_yn,'Y')='Y' and e.fee_est_dt > '20051001'"+
				" and a.rent_l_cd not in ('B108HXBL00011','S106HU3L00014', 'B109HTGR00059')"+
				" and a.rent_l_cd not in ('S108HTLR00184','D107KGCL00007','B106HTLR00012','S107SL5R00039','S105HB4R00035','S104HVFL00058','K102HVTR00012','S105HTGL00052','S106YNCR00021','K100HVFR00037','S106HJML00007','S107HTLR00092','S107HABR00013','S105HTLR00001')"+ //20101230 (구)대여료개별정기발행분 정리
		        " and e.rent_l_cd||e.fee_tm not in ('S108HTGL000451','S108HRFL000471')"+//20101230 (구)대여료개별정기발행분 정리
				" and nvl(t.cls_st,'0') in ('0','3','4','5','6','7','9','10','14','15')  \n"+
				" ";

		//전자세금계산서 법인의무화에 따른 세금일자 변경관련
		query += " and e.tax_out_dt <= to_char(sysdate,'YYYYMMDD')";

		if(!s_br.equals(""))		query += " and a.brch_id like '"+s_br+"%'";

		//기간구분
		if(gubun1.equals("1") && !st_dt.equals(""))		query += " and (e.r_req_dt<replace('"+st_dt+"','-','') or e.r_req_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-',''))";
		if(gubun1.equals("2") && !st_dt.equals(""))		query += " and e.r_fee_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
		if(gubun1.equals("3") && !st_dt.equals(""))		query += " and e.tax_out_dt   between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";

		String search = "";
		if(s_kd.equals("1"))		search = "nvl(m.firm_nm,b.firm_nm)";
		else if(s_kd.equals("2"))	search = "a.rent_l_cd";
		else if(s_kd.equals("3"))	search = "c.car_no";

		if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
		if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";

		query += " order by t.cls_st, g.rent_l_cd, decode(g.rent_l_cd,'','0',e.fee_est_dt), ";

		if(sort.equals("1"))		query += " nvl(m.firm_nm,b.firm_nm) "+asc;
		if(sort.equals("2"))		query += " c.car_no "+asc;
		if(sort.equals("3"))		query += " e.r_req_dt "+asc+", nvl(m.firm_nm,b.firm_nm)";
		if(sort.equals("4"))		query += " e.fee_est_dt "+asc+", nvl(m.firm_nm,b.firm_nm)";

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
			System.out.println("[IssueDatabase:getIssue1List]\n"+e);
			System.out.println("[IssueDatabase:getIssue1List]\n"+query);
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
	 *	정기발행-개별발행 :계약건별 일괄발행리스트
	 *  20071128 수정 : 분할청구건 적용
	 */	
	public Vector getIssue1ListClient(String client_id, String site_id, String r_req_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select /*+ leading(A) use_nl(a) index(b CLIENT_PK ) */  \n"+
				"        a.brch_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, b.firm_nm, d.r_site as site_nm, c.car_no, c.car_nm, \n"+
				"        e.rent_st, e.fee_tm, e.fee_s_amt, e.fee_v_amt, (e.fee_s_amt+e.fee_v_amt) fee_amt, e.fee_est_dt, e.r_fee_est_dt, e.req_dt, e.r_req_dt r_req_dt, e.tax_out_dt \n"+
				" from   cont a, client b, car_reg c, client_site d, scd_fee e, cls_cont l, cls_etc te, \n"+
				"        ( select a.* from tax_item_list a, tax b, tax c, tax_item d where a.item_id=b.item_id and a.gubun='1' and b.doctype is null and b.tax_no=c.m_tax_no(+) and decode(c.doctype,'04','C',b.tax_st)='O' and a.item_id=d.item_id and nvl(d.use_yn,'Y')='Y') f, \n"+
				"        ( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD')) g, \n"+
				"        ( select a.*, decode(a.r_site,'',b.firm_nm, c.r_site) firm_nm, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)) m \n"+
				" where \n"+
				" a.client_id=b.client_id"+
				" and a.client_id=d.client_id(+) and a.r_site=d.seq(+)"+
				" and a.car_mng_id=c.car_mng_id(+) "+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				" and e.rent_l_cd=f.rent_l_cd(+) and e.fee_tm=f.tm(+) and e.rent_st=f.rent_st(+) and e.rent_seq=f.rent_seq(+) and f.rent_l_cd is null"+
				" and e.rent_mng_id=g.rent_mng_id(+) and e.rent_l_cd=g.rent_l_cd(+) and e.rent_seq=g.rent_seq(+) and g.rent_l_cd is null"+
				" and e.rent_mng_id=m.rent_mng_id(+) and e.rent_l_cd=m.rent_l_cd(+) and e.rent_st=m.rent_st(+) and e.rent_seq=m.rent_seq(+)"+
				" and nvl(e.bill_yn,'Y')='Y' "+
				" and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+) "+//and nvl(l.cls_st,'0') not in ('1','2','8')
				" and a.rent_mng_id=te.rent_mng_id(+) and a.rent_l_cd=te.rent_l_cd(+) "+
				"	     and (nvl(l.cls_st,'0') in ('0','3','4','5','6','7','9','10','14','15') or (l.cls_st in ('1','2') and te.match='Y')) \n"+
				" and decode(e.tm_st2,'4','1','3',decode(b.im_print_st,'Y',nvl(b.print_st,'1'),'1'),nvl(b.print_st,'1')) in ('2','3','4') \n"+ //건별발행 혹은 임의연장
				" and nvl(m.client_id,a.client_id)='"+client_id+"' and e.r_req_dt=replace('"+r_req_dt+"','-','')";


		//발행구분
		if(site_id.equals("00")){	query += " and decode(m.r_site,'',decode(b.print_st,'2','00',decode(a.tax_type,'2',nvl(a.r_site,'00'),'00')),m.r_site)='00'";
		
		}else{
					if(!site_id.equals(""))	query += " and nvl(m.r_site,a.r_site)='"+site_id+"'";
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
			System.out.println("[IssueDatabase:getIssue1ListClient]\n"+e);
			System.out.println("[IssueDatabase:getIssue1ListClient]\n"+query);
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
	 *	정기발행-개별발행 :계약건별 일괄발행리스트
	 *  20071128 수정 : 분할청구건 적용
	 */	
	public Vector getIssue1ListClient(String client_id, String site_id, String r_req_dt, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select /*+ leading(A) use_nl(a) index(b CLIENT_PK ) */  "+
				" a.brch_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, b.firm_nm, d.r_site as site_nm, c.car_no, c.car_nm,"+
				" e.rent_st, e.fee_tm, e.fee_s_amt, e.fee_v_amt, (e.fee_s_amt+e.fee_v_amt) fee_amt, e.fee_est_dt, e.r_fee_est_dt, e.req_dt, e.r_req_dt r_req_dt, e.tax_out_dt"+
				" from cont a, client b, car_reg c, client_site d, scd_fee e, cls_cont l, cls_etc te, car_etc j, car_nm k,"+
				"        /*기발행계산서*/( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm, sum(a.ITEM_SUPPLY) fee_s_amt from tax_item_list a, tax_item b, tax c where a.gubun='1' and nvl(b.use_yn,'Y')='Y' and c.tax_st<>'C' and a.item_id=b.item_id and a.item_id=c.item_id group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm having sum(a.item_supply) >0 ) f, "+
				"        /*기발행청구서*/( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm, sum(a.ITEM_SUPPLY) fee_s_amt from tax_item_list a, tax_item b, tax c where a.gubun='1' and nvl(b.use_yn,'Y')='Y' and nvl(c.tax_st,'O')<>'C' and a.item_id=b.item_id and a.item_id=c.item_id(+) group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm having sum(a.item_supply) >0) h, "+
				"      ( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD')) g,"+
				"      ( select a.*, decode(a.r_site,'',b.firm_nm, c.r_site) firm_nm, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)) m "+
				" where"+
				" a.client_id=b.client_id"+
				" and a.client_id=d.client_id(+) and a.r_site=d.seq(+)"+
				" and a.car_mng_id=c.car_mng_id(+) "+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.tm_st1='0'"+
				" and e.rent_l_cd=h.rent_l_cd(+) and e.fee_tm=h.tm(+) and e.rent_st=h.rent_st(+) and e.rent_seq=h.rent_seq(+) and h.rent_l_cd is null"+
				" and e.rent_l_cd=f.rent_l_cd(+) and e.fee_tm=f.tm(+) and e.rent_st=f.rent_st(+) and e.rent_seq=f.rent_seq(+) and f.rent_l_cd is null"+
				" and e.rent_mng_id=g.rent_mng_id(+) and e.rent_l_cd=g.rent_l_cd(+) and e.rent_seq=g.rent_seq(+) and g.rent_l_cd is null"+
				" and e.rent_mng_id=m.rent_mng_id(+) and e.rent_l_cd=m.rent_l_cd(+) and e.rent_st=m.rent_st(+) and e.rent_seq=m.rent_seq(+)"+
				" and nvl(e.bill_yn,'Y')='Y' "+
				" and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+) "+//and nvl(l.cls_st,'0') not in ('1','2','8')
				" and a.rent_mng_id=te.rent_mng_id(+) and a.rent_l_cd=te.rent_l_cd(+) "+
				"	     and (nvl(l.cls_st,'0') in ('0','3','4','5','6','7','9','10','14','15') or (l.cls_st in ('1','2') and te.match='Y')) \n"+
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+) \n"+
				" and j.car_id=k.car_id(+) and j.car_seq=k.car_seq(+) \n"+
				" and decode(e.tm_st2,'4','1','3',decode(b.im_print_st,'Y',nvl(b.print_st,'1'),'1'),nvl(b.print_st,'1')) in ('2','3','4') \n"+ //건별발행 혹은 임의연장
				" and nvl(m.client_id,a.client_id)='"+client_id+"' and e.req_dt=replace('"+r_req_dt+"','-','') "+
				" and case when nvl(b.print_car_st, '0') = '1' and k.s_st in ('100','101','409','601','602','700','701','702','801','802','803','811','812','821') then 1 else 0 end ='"+s_st+"'"+		
				" ";


		//발행구분
		if(site_id.equals("00")){	query += " and decode(m.r_site,'',decode(b.print_st,'2','00',decode(a.tax_type,'2',nvl(a.r_site,'00'),'00')),m.r_site)='00'";
		
		}else{
					if(!site_id.equals(""))	query += " and nvl(m.r_site,a.r_site)='"+site_id+"'";
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
			System.out.println("[IssueDatabase:getIssue1ListClient]\n"+e);
			System.out.println("[IssueDatabase:getIssue1ListClient]\n"+query);
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
	 *	정기발행-개별발행 :계약건별 일괄발행리스트
	 *  20071128 수정 : 분할청구건 적용
	 */	
	public Vector getIssue1ListClient(String client_id, String site_id, String r_req_dt, String tax_out_dt, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		query = " select /*+ leading(A) use_nl(a) index(b CLIENT_PK ) */  "+
				" a.brch_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, b.firm_nm, d.r_site as site_nm, c.car_no, c.car_nm,"+
				" e.rent_st, e.fee_tm, e.fee_s_amt, e.fee_v_amt, (e.fee_s_amt+e.fee_v_amt) fee_amt, e.fee_est_dt, e.r_fee_est_dt, e.req_dt, e.r_req_dt r_req_dt, e.tax_out_dt"+
				" from cont a, client b, car_reg c, client_site d, scd_fee e, cls_cont l, cls_etc te, car_etc j, car_nm k,"+
				"        /*기발행계산서*/( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm, sum(a.ITEM_SUPPLY) fee_s_amt from tax_item_list a, tax_item b, tax c where a.gubun='1' and nvl(b.use_yn,'Y')='Y' and c.tax_st<>'C' and a.item_id=b.item_id and a.item_id=c.item_id group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm having sum(a.item_supply) >0 ) f, "+
				"        /*기발행청구서*/( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm, sum(a.ITEM_SUPPLY) fee_s_amt from tax_item_list a, tax_item b, tax c where a.gubun='1' and nvl(b.use_yn,'Y')='Y' and nvl(c.tax_st,'O')<>'C' and a.item_id=b.item_id and a.item_id=c.item_id(+) group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm having sum(a.item_supply) >0) h, "+
				"      ( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD')) g,"+
				"      ( select a.*, decode(a.r_site,'',b.firm_nm, c.r_site) firm_nm, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)) m "+
				" where"+
				" a.client_id=b.client_id"+
				" and a.client_id=d.client_id(+) and a.r_site=d.seq(+)"+
				" and a.car_mng_id=c.car_mng_id(+) "+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.tm_st1='0'"+
				" and e.rent_l_cd=h.rent_l_cd(+) and e.fee_tm=h.tm(+) and e.rent_st=h.rent_st(+) and e.rent_seq=h.rent_seq(+) and h.rent_l_cd is null"+
				" and e.rent_l_cd=f.rent_l_cd(+) and e.fee_tm=f.tm(+) and e.rent_st=f.rent_st(+) and e.rent_seq=f.rent_seq(+) and f.rent_l_cd is null"+
				" and e.rent_mng_id=g.rent_mng_id(+) and e.rent_l_cd=g.rent_l_cd(+) and e.rent_seq=g.rent_seq(+) and g.rent_l_cd is null"+
				" and e.rent_mng_id=m.rent_mng_id(+) and e.rent_l_cd=m.rent_l_cd(+) and e.rent_st=m.rent_st(+) and e.rent_seq=m.rent_seq(+)"+
				" and nvl(e.bill_yn,'Y')='Y' "+
				" and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+)  "+ //and nvl(l.cls_st,'0') not in ('1','2','8')
				" and a.rent_mng_id=te.rent_mng_id(+) and a.rent_l_cd=te.rent_l_cd(+)  "+ 
				"	     and (nvl(l.cls_st,'0') in ('0','3','4','5','6','7','9','10','14','15') or (l.cls_st in ('1','2') and te.match='Y')) \n"+
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+) \n"+
				" and j.car_id=k.car_id(+) and j.car_seq=k.car_seq(+) \n"+
				" and decode(e.tm_st2,'4','1','3',decode(b.im_print_st,'Y',nvl(b.print_st,'1'),'1'),nvl(b.print_st,'1')) in ('2','3','4') \n"+ //건별발행 혹은 임의연장
				" and nvl(m.client_id,a.client_id)='"+client_id+"' and e.req_dt=replace('"+r_req_dt+"','-','') and e.tax_out_dt=replace('"+tax_out_dt+"','-','') "+
				" and case when nvl(b.print_car_st, '0') = '1' and k.s_st in ('100','101','409','601','602','700','701','702','801','802','803','811','812','821') then 1 else 0 end ='"+s_st+"'"+		
				" ";


		//발행구분
		if(site_id.equals("00")){	query += " and decode(m.r_site,'',decode(b.print_st,'2','00',decode(a.tax_type,'2',nvl(a.r_site,'00'),'00')),m.r_site)='00'";
		
		}else{
					if(!site_id.equals(""))	query += " and nvl(m.r_site,a.r_site)='"+site_id+"'";
		}
		
		query += " order by a.reg_dt, a.rent_mng_id, e.fee_est_dt, e.fee_tm ";
		

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
			System.out.println("[IssueDatabase:getIssue1ListClient]\n"+e);
			System.out.println("[IssueDatabase:getIssue1ListClient]\n"+query);
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
	 *	정기발행-통합발행  :계약건별 일괄발행리스트
	 *  
	 */	
	public Vector getIssue2List(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		String group_item1 = "nvl(m.client_id,a.client_id)";
		String group_item2 = "decode(b.print_st,'2','00',decode(nvl(m.r_site,a.r_site),'','00',nvl(m.r_site,a.r_site)))";
		String group_item3 = "nvl(d.r_req_dt,d.r_fee_est_dt)";

		query = " select /*+ leading(A) use_nl(a) index(b CLIENT_PK ) */  "+
				" a.use_yn, "+group_item1+" client_id, "+group_item2+" site_id, "+group_item3+" r_req_dt, count(0) cnt, "+
				" min(nvl(m.firm_nm,b.firm_nm)) firm_nm, min(nvl(c.r_site,'-')) site_nm, min(nvl(b.print_st,'1')) print_st,"+
				" sum(d.fee_s_amt) fee_s_amt, sum(d.fee_v_amt) fee_v_amt, sum(d.fee_s_amt+d.fee_v_amt) fee_amt, min(nvl(d.tax_out_dt,d.fee_est_dt)) tax_out_dt"+
				" from cont a, client b, client_site c, scd_fee d, car_reg e, cls_cont t,"+
				"  (select a.* from tax_item_list a, tax b where a.item_id=b.item_id and b.tax_st='O' and a.gubun='1') f,"+
				"  (select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD')) g,"+
				"  (select a.*, decode(a.r_site,'',b.firm_nm, c.r_site) firm_nm, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)) m,"+
				"  (select rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, sum(rc_amt) rc_amt from scd_fee where rc_yn='1' group by rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq ) e2"+
				" where"+
				" a.client_id=b.client_id"+
				" and a.client_id=c.client_id(+) and a.r_site=c.seq(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.tm_st1='0'"+
				" and a.car_mng_id=e.car_mng_id(+)"+
				" and d.rent_l_cd=f.rent_l_cd(+) and d.fee_tm=f.tm(+) and d.rent_st=f.rent_st(+) and d.rent_seq=f.rent_seq(+) and f.rent_l_cd is null"+
				" and d.rent_mng_id=e2.rent_mng_id(+) and d.rent_l_cd=e2.rent_l_cd(+) and d.fee_tm=e2.fee_tm(+) and d.rent_st=e2.rent_st(+) and d.rent_seq=e2.rent_seq(+) \n"+
				" and d.rent_mng_id=g.rent_mng_id(+) and d.rent_l_cd=g.rent_l_cd(+) and d.rent_seq=g.rent_seq(+) and decode(d.fee_s_amt+d.fee_v_amt,e2.rc_amt,'',g.rent_l_cd) is null"+
				" and nvl(b.print_st,'1') in ('2', '3', '4') "+
				" and d.rent_mng_id=m.rent_mng_id(+) and d.rent_l_cd=m.rent_l_cd(+) and d.rent_st=m.rent_st(+) and d.rent_seq=m.rent_seq(+)"+
				" and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) "+
				" and nvl(d.bill_yn,'Y')='Y' and d.tm_st1='0' and d.fee_est_dt > '20051001'"+
				" and nvl(t.cls_st,'0') in ('0','3','4','5','6','7','9','10','14','15')  \n"+
				" ";

		//전자세금계산서 법인의무화에 따른 세금일자 변경관련
		query += " and d.tax_out_dt <= to_char(sysdate,'YYYYMMDD')";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";

		//기간구분
		if(gubun1.equals("1") && !st_dt.equals("") && !end_dt.equals(""))		query += " and d.r_req_dt     between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("2") && !st_dt.equals("") && !end_dt.equals(""))		query += " and d.r_fee_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
		if(gubun1.equals("3") && !st_dt.equals("") && !end_dt.equals(""))		query += " and d.tax_out_dt   between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		//발행구분
		if(!chk1.equals(""))		query += " and b.print_st='"+chk1+"'";

		String search = "";
		if(s_kd.equals("1"))		search = "nvl(m.firm_nm,b.firm_nm)";
		else if(s_kd.equals("2"))	search = "a.rent_l_cd";
		else if(s_kd.equals("3"))	search = "e.car_no";

		if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
		if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";

		query += " group by a.use_yn, "+group_item1+", "+group_item2+", "+group_item3+" ";

		if(sort.equals("1"))		query += " order by min(nvl(m.firm_nm,b.firm_nm)) "+asc+", min(nvl(m.r_site,a.r_site)) ";

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
			System.out.println("[IssueDatabase:getIssue2List]\n"+e);
			System.out.println("[IssueDatabase:getIssue2List]\n"+query);
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

	public String getItemIdNext()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String item_id = "";
		String query = "";

	/* 중복방지 - 20200630	
	   query = " select to_char(sysdate,'YYYY-MM')||'-'||nvl(ltrim(to_char(to_number(max(substr(item_id,9,5))+1), '00000')), '00001') item_id"+
				" from tax_item_list "+
				//" where substr(item_id,1,8)=to_char(sysdate,'YYYY-MM')||'-'";
		        " where item_id LIKE to_char(sysdate,'YYYY-MM')||'-%' "; */
		
		query = " select to_char(sysdate,'YYYY-MM')||'-'||ltrim(to_char(ITEM_LIST_SEQ.nextval, '00000')) item_id "+
				" from dual ";
			//	" from tax_item_list where rownum = 1 ";
		//	   " where item_id LIKE to_char(sysdate,'YYYY-MM')||'-%' ";  

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				item_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getItemIdNext]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return item_id;
		}		
	}

	public String getItemIdNext(String tax_out_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String item_id = "";
		String query = "";
		String tax_dt = "";
		int len=tax_out_dt.length();
		if(len == 8){
			tax_dt = "to_char(to_date('"+tax_out_dt+"','YYYYMMDD'),'YYYY-MM')";
		}else if(len == 10){
			tax_dt = "to_char(to_date('"+tax_out_dt+"','YYYY-MM-DD'),'YYYY-MM')";
		}
		
		//시쿼스가 들어가니 무조건 현재로 한다. 
		tax_dt = "to_char(sysdate,'YYYY-MM')";

		/*  중복방지 - sequence 교체 - 20200630
		query = " select "+tax_dt+"||'-'||nvl(ltrim(to_char(to_number(max(substr(item_id,9,5))+1), '00000')), '00001') item_id"+
				" from tax_item_list "+
				//" where substr(item_id,1,8)="+tax_dt+"||'-'";
				" where item_id LIKE "+tax_dt+"||'-%' "; */
		
		query = " select "+tax_dt+"||'-'||ltrim(to_char(ITEM_LIST_SEQ.nextval, '00000')) item_id "+
			    " from dual ";
			//	" from tax_item_list where rownum = 1  ";
				//" where substr(item_id,1,8)="+tax_dt+"||'-'";
			//	" where item_id LIKE "+tax_dt+"||'-%' ";
		
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				item_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getItemIdNext]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return item_id;
		}		
	}

	public String getTaxNoNext()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String item_id = "";
		String query = "";
		
/*  20200630 tax_no sequence 로
		query = " select to_char(sysdate,'YY')||'-'||nvl(ltrim(to_char(to_number(max(to_number(substr(tax_no,4)))+1), '0000000')), '0000001') tax_no"+
				" from tax "+
				//" where substr(tax_no,1,3)=to_char(sysdate,'YY')||'-'";
		        " where tax_no LIKE to_char(sysdate,'YY')||'-%' "; */
		
		query = " select to_char(sysdate,'YY')||'-'||ltrim(to_char(TAX_SEQ.nextval, '0000000')) tax_no "+
				" from dual ";
		//		" from tax where rownum = 1	 ";				
			//	   " where tax_no LIKE to_char(sysdate,'YY')||'-%' "; 

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				item_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getItemIdNext]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return item_id;
		}		
	}

	public String getTaxNoNext(String tax_out_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String item_id = "";
		String query = "";
		String tax_dt = "";

		int len=tax_out_dt.length();
		if(len == 8){
			tax_dt = "to_char(to_date('"+tax_out_dt+"','YYYYMMDD'),'YY')";
		}else if(len == 10){
			tax_dt = "to_char(to_date('"+tax_out_dt+"','YYYY-MM-DD'),'YY')";
		}
		if(tax_dt.equals("")) tax_dt = "to_char(sysdate,'YY')";
/*  tax_no sequence 20200630 수정 
		query = " select "+tax_dt+"||'-'||nvl(ltrim(to_char(to_number(max(to_number(substr(tax_no,4)))+1), '0000000')), '0000001') tax_no"+
				" from tax "+
				//" where substr(tax_no,1,3)="+tax_dt+"||'-'";
		        " where tax_no LIKE "+tax_dt+"||'-%' "; 
*/		
		
		query = " select "+tax_dt+"||'-'||ltrim(to_char(TAX_SEQ.nextval, '0000000')) tax_no "+
		        " from dual ";
		//		" from tax where  rownum = 1	 ";			
		//		" where tax_no LIKE "+tax_dt+"||'-%' ";
		
		
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				item_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxNoNext]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return item_id;
		}		
	}

	public int getTaxCngSeqNext(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int seq = 0;
		String query = "";

		query = " select"+
				" nvl(max(seq)+1,1) seq"+
				" from tax_cng where tax_no=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		tax_no);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				seq = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxCngSeqNext]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}		
	}

	//0단계 : (통합발행) 선택리스트의 스케줄 조회
	public Vector getIssue2FeeScdList(String client_id, String site_id, String r_req_dt, String tax_out_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector(); 
		String query = "";

		query = " select /*+ leading(a) merge(c) */ "+
				"        decode(c.tm_st2,'2',k.car_no, b.car_no)  car_no, "+
				"        decode(c.tm_st2,'2',k.car_nm, b.car_nm)  car_nm, "+
				"        decode(c.tm_st2,'2',k.car_use,b.car_use) car_use, "+
				"        decode(c.tm_st2,'2',k.car_mng_id,b.car_mng_id) car_mng_id, "+
				"        c.use_s_dt, c.use_e_dt, c.fee_s_amt, c.fee_v_amt, c.rent_l_cd, c.fee_tm, c.req_dt, c.tax_out_dt, c.rent_st, c.rent_seq, c.tm_st2, d.fine_cnt, e.serv_cnt"+
				" from   cont a, car_reg b, scd_fee c, client i,"+
				"        /*과태료    d*/( select rent_l_cd,  count(0) fine_cnt from fine where tax_yn='1' and nvl(dem_dt,coll_dt) like substr('"+tax_out_dt+"',1,4)||'%' and bill_mon=substr('"+tax_out_dt+"',5,2) group by rent_l_cd ) d,"+
				"        /*면책금    e*/( select rent_l_cd,  count(0) serv_cnt from service where bill_doc_yn='2' and nvl(cust_req_dt,cust_pay_dt) like substr('"+tax_out_dt+"',1,4)||'%' and bill_mon=substr('"+tax_out_dt+"',5,2) group by rent_l_cd ) e,"+
				"        /*발행중지  g*/( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD') ) g,"+
				"        /*분할청구  m*/( select a.*, b.firm_nm, c.r_site as site_nm, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+) ) m, "+
				"        /*출고전대차k*/( select aa.*, bb.car_nm, bb.car_use from taecha aa, car_reg bb where aa.car_mng_id=bb.car_mng_id ) k, "+ 
				"        /*청구서확인f*/( select a.rent_l_cd, a.tm, a.rent_st, a.rent_seq \n"+
				"                         from   tax_item c, tax_item_list a, tax b \n"+
				"                         where  c.client_id='"+client_id+"' and nvl(c.use_yn,'Y')='Y' \n"+
				"                                and c.item_id=a.item_id and a.gubun='1' \n"+
				"                         		 and a.item_id=b.item_id(+) and b.item_id is null \n"+
				"                         group by a.rent_l_cd, a.tm, a.rent_st, a.rent_seq "+
				"	                    ) f, "+
				"        /*계산서확인j*/( select a.rent_l_cd, a.tm, a.rent_st, a.rent_seq \n"+
				"                         from   tax_item c, tax_item_list a, tax b \n"+
				"                         where  c.client_id='"+client_id+"' and nvl(c.use_yn,'Y')='Y' \n"+
				"                                and c.item_id=a.item_id and a.gubun='1' \n"+
				"                         		 and a.item_id=b.item_id and b.tax_st='O' and b.doctype is null \n"+
				"                         group by a.rent_l_cd, a.tm, a.rent_st, a.rent_seq \n"+
				"	                    ) j, cls_cont l, cls_etc te "+
				" where a.car_mng_id=b.car_mng_id(+)"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
				"        and c.tm_st1='0' "+
				"        and nvl(c.bill_yn,'Y')='Y'"+
				"        and a.rent_l_cd=d.rent_l_cd(+)"+
				"        and a.rent_l_cd=e.rent_l_cd(+)"+
				"        and c.rent_mng_id=g.rent_mng_id(+) and c.rent_l_cd=g.rent_l_cd(+) and c.rent_seq=g.rent_seq(+) and g.rent_l_cd is null"+
				"        and a.client_id=i.client_id"+
				"        and c.rent_mng_id=m.rent_mng_id(+) and c.rent_l_cd=m.rent_l_cd(+) and c.rent_st=m.rent_st(+) and c.rent_seq=m.rent_seq(+)"+
				"        and c.rent_mng_id=k.rent_mng_id(+) and c.rent_l_cd=k.rent_l_cd(+) and c.taecha_no=k.no(+)"+
				"        and c.rent_l_cd=f.rent_l_cd(+) and c.fee_tm=f.tm(+) and c.rent_st=f.rent_st(+) and c.rent_seq=f.rent_seq(+) and f.rent_l_cd is null"+
				"        and c.rent_l_cd=j.rent_l_cd(+) and c.fee_tm=j.tm(+) and c.rent_st=j.rent_st(+) and c.rent_seq=j.rent_seq(+) and j.rent_l_cd is null"+
				"        and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+) "+ //and nvl(l.cls_st,'0') not in ('1','2','8')
				"        and a.rent_mng_id=te.rent_mng_id(+) and a.rent_l_cd=te.rent_l_cd(+) "+
				"	     and (nvl(l.cls_st,'0') in ('0','3','4','5','6','7','9','10','14','15') or (l.cls_st in ('1','2') and te.match='Y')) \n"+
				" 		 and decode(c.tm_st2,'4','1','3',decode(i.im_print_st,'Y',nvl(i.print_st,'1'),'1'),nvl(i.print_st,'1')) in ('2','3','4') \n"+ //건별발행 혹은 임의연장
				"        and nvl(m.client_id,a.client_id)='"+client_id+"' and nvl(c.r_req_dt,c.r_fee_est_dt)=replace('"+r_req_dt+"','-','')";

		//발행구분
		if(site_id.equals("00")){	query += " and decode(m.r_site,'',decode(i.print_st,'2','00',decode(a.tax_type,'2',nvl(a.r_site,'00'),'00')),m.r_site)='00'";
		
		}else{
			if(!site_id.equals(""))	query += " and nvl(m.r_site,a.r_site)='"+site_id+"'";
		}

		query += " order by a.reg_dt, a.rent_mng_id";

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
			System.out.println("[IssueDatabase:getIssue2FeeScdList]\n"+e);
			System.out.println("[IssueDatabase:getIssue2FeeScdList]\n"+query);
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

	//0단계 : (통합발행) 선택리스트의 스케줄 조회
	public Vector getIssue2FeeScdList(String client_id, String site_id, String r_req_dt, String tax_out_dt, String s_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ leading(a) merge(c) */ "+
				"        decode(c.tm_st2,'2',k.car_no, b.car_no)  car_no, "+
				"        decode(c.tm_st2,'2',k.car_nm, b.car_nm)  car_nm, "+
				"        decode(c.tm_st2,'2',k.car_use,b.car_use) car_use, "+
				"        decode(c.tm_st2,'2',k.car_mng_id,b.car_mng_id) car_mng_id, "+
				"        c.use_s_dt, c.use_e_dt, c.fee_s_amt, c.fee_v_amt, c.rent_l_cd, c.fee_tm, c.req_dt, c.tax_out_dt, c.rent_st, c.rent_seq, d.fine_cnt, e.serv_cnt, nvl(c.etc,'') etc, c.taecha_no "+
				" from   cont a, car_reg b, scd_fee c, client i, car_etc jj, car_nm kk,"+
				"        /*과태료    d*/( select rent_l_cd,  count(0) fine_cnt from fine where tax_yn='1' and nvl(dem_dt,coll_dt) like substr('"+tax_out_dt+"',1,4)||'%' and bill_mon=substr('"+tax_out_dt+"',5,2) group by rent_l_cd ) d,"+
				"        /*면책금    e*/( select rent_l_cd,  count(0) serv_cnt from service where bill_doc_yn='2' and nvl(cust_req_dt,cust_pay_dt) like substr('"+tax_out_dt+"',1,4)||'%' and bill_mon=substr('"+tax_out_dt+"',5,2) group by rent_l_cd ) e,"+
				"        /*발행중지  g*/( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD') ) g,"+
				"        /*분할청구  m*/( select a.*, b.firm_nm, c.r_site as site_nm, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+) ) m, "+
				"        /*출고전대차k*/( select aa.*, bb.car_nm, bb.car_use from taecha aa, car_reg bb where aa.car_mng_id=bb.car_mng_id ) k, "+ 
				"        /*청구서확인f*/( select a.rent_l_cd, a.tm, a.rent_st, a.rent_seq, sum(a.ITEM_SUPPLY) fee_s_amt \n"+
				"                         from   tax_item c, tax_item_list a, tax b \n"+
				"                         where  c.client_id='"+client_id+"' and nvl(c.use_yn,'Y')='Y' \n"+
				"                                and c.item_id=a.item_id and a.gubun='1' \n"+
				"                         		 and a.item_id=b.item_id(+) and b.item_id is null \n"+
				"                         group by a.rent_l_cd, a.tm, a.rent_st, a.rent_seq "+
                "                         having sum(a.item_supply) >0 "+
				"	                    ) f, "+
				"        /*계산서확인j*/( select a.rent_l_cd, a.tm, a.rent_st, a.rent_seq, sum(a.ITEM_SUPPLY) fee_s_amt \n"+
				"                         from   tax_item c, tax_item_list a, tax b \n"+
				"                         where  c.client_id='"+client_id+"' and nvl(c.use_yn,'Y')='Y' \n"+
				"                                and c.item_id=a.item_id and a.gubun='1' \n"+
				"                         		 and a.item_id=b.item_id and b.tax_st<>'C'  \n"+
				"                         group by a.rent_l_cd, a.tm, a.rent_st, a.rent_seq \n"+
                "                         having sum(a.item_supply) >0 "+
				"	                    ) j, cls_cont l, cls_etc te "+
				" where a.car_mng_id=b.car_mng_id(+)"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd "+
				"        and c.tm_st1='0' "+
				"        and nvl(c.bill_yn,'Y')='Y'"+
				"        and a.rent_l_cd=d.rent_l_cd(+)"+
				"        and a.rent_l_cd=e.rent_l_cd(+)"+
				"        and c.rent_mng_id=g.rent_mng_id(+) and c.rent_l_cd=g.rent_l_cd(+) and c.rent_seq=g.rent_seq(+) and g.rent_l_cd is null"+
				"        and a.client_id=i.client_id"+
				"	     and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"+
				"        and jj.car_id=kk.car_id(+) and jj.car_seq=kk.car_seq(+) \n"+
				"        and c.rent_mng_id=m.rent_mng_id(+) and c.rent_l_cd=m.rent_l_cd(+) and c.rent_st=m.rent_st(+) and c.rent_seq=m.rent_seq(+)"+
				"        and c.rent_mng_id=k.rent_mng_id(+) and c.rent_l_cd=k.rent_l_cd(+) and c.taecha_no=k.no(+)"+
				"        and c.rent_l_cd=f.rent_l_cd(+) and c.fee_tm=f.tm(+) and c.rent_st=f.rent_st(+) and c.rent_seq=f.rent_seq(+) and f.rent_l_cd is null"+
				"        and c.rent_l_cd=j.rent_l_cd(+) and c.fee_tm=j.tm(+) and c.rent_st=j.rent_st(+) and c.rent_seq=j.rent_seq(+) and j.rent_l_cd is null"+
				"        and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+) "+ //and nvl(l.cls_st,'0') not in ('1','2','8')
				"        and a.rent_mng_id=te.rent_mng_id(+) and a.rent_l_cd=te.rent_l_cd(+) "+
				"	     and (nvl(l.cls_st,'0') in ('0','3','4','5','6','7','9','10','14','15') or (l.cls_st in ('1','2') and te.match='Y')) \n"+
				" 		 and decode(c.tm_st2,'4','1','3',decode(i.im_print_st,'Y',nvl(i.print_st,'1'),'1'),nvl(i.print_st,'1')) in ('2','3','4') \n"+ //건별발행 혹은 임의연장
				"        and nvl(m.client_id,a.client_id)='"+client_id+"' and nvl(c.req_dt,c.r_fee_est_dt)=replace('"+r_req_dt+"','-','') and nvl(c.tax_out_dt,c.r_fee_est_dt)=replace('"+tax_out_dt+"','-','')"+
				"        and case when nvl(i.print_car_st, '0') = '1' and kk.s_st in ('100','101','409','601','602','700','701','702','801','802','803','811','812','821') then 1 else 0 end ='"+s_st+"' "+
				" ";

		//발행구분
		if(site_id.equals("00")){	
									query += " and decode(m.r_site,'',decode(i.print_st,'2','00',decode(a.tax_type,'2',nvl(a.r_site,'00'),'00')),m.r_site)='00'";
		
		}else{
			if(!site_id.equals(""))	query += " and nvl(m.r_site,a.r_site)='"+site_id+"'";
		}

		query += " order by a.reg_dt, a.rent_mng_id, c.fee_est_dt, c.fee_tm";

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
			System.out.println("[IssueDatabase:getIssue2FeeScdList]\n"+e);
			System.out.println("[IssueDatabase:getIssue2FeeScdList]\n"+query);
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

	//0-1단계 : (통합/개별발행) 선택리스트의 과태료 조회
	public Vector getFineTaxList(String car_mng_id, String rent_l_cd, String tax_out_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select seq_no, paid_amt, (paid_amt*0.1) paid_v_amt, decode(busi_st,'2','정비비','과태료') busi_st,"+
				" nvl2(vio_dt,substr(vio_dt,1,4)||'-'||substr(vio_dt,5,2)||'-'||substr(vio_dt,7,2),'') vio_dt"+
				" from fine"+
				" where car_mng_id='"+car_mng_id+"' and rent_l_cd='"+rent_l_cd+"' and tax_yn='1'"+
				" and nvl(dem_dt,coll_dt) like substr('"+tax_out_dt+"',1,4)||'%' and bill_mon=substr('"+tax_out_dt+"',5,2)";

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
			System.out.println("[IssueDatabase:getFineTaxList]\n"+e);
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

	//0-2단계 : (통합/개별발행) 선택리스트의 면책금 조회
	public Vector getServiceTaxList(String car_mng_id, String rent_l_cd, String tax_out_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select serv_id, cust_amt, (cust_amt/1.1) cust_s_amt, (cust_amt-(cust_amt/1.1)) cust_v_amt,"+
				" nvl2(serv_dt,substr(serv_dt,1,4)||'-'||substr(serv_dt,5,2)||'-'||substr(serv_dt,7,2),'') serv_dt"+
				" from service"+
				" where car_mng_id='"+car_mng_id+"' and rent_l_cd='"+rent_l_cd+"' and bill_doc_yn='2'"+
				" and nvl(cust_req_dt,cust_pay_dt) like substr('"+tax_out_dt+"',1,4)||'%' and bill_mon=substr('"+tax_out_dt+"',5,2)";

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
			System.out.println("[IssueDatabase:getServiceTaxList]\n"+e);
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

	//1단계 : 거래명세서 리스트 한건 등록
	//20071128 수정 : rent_st, rent_seq 추가
	public boolean insertTaxItemList(TaxItemListBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		String item_seq = "";
							
		query = " INSERT INTO tax_item_list"+
				" ( item_id, item_seq, item_g, item_car_no, item_car_nm, item_dt1, item_dt2, item_supply, item_value, "+
				"   rent_l_cd, car_mng_id, tm, gubun, reg_dt, reg_id, reg_code, rent_st, rent_seq, car_use, item_dt, etc ) VALUES "+
				" ( ?, ?, ?, ?, ?, substr(replace(replace(?, '0000', ''), '-', ''),1,8), substr(replace(replace(?, '0000', ''), '-', ''),1,8), ?, ?, "+
				"   ?, ?, ?, ?, sysdate, ?, ?, ?, ?, ?, replace(replace(?, '0000', ''), '-', ''), ? "+
				" )";

		try 
		{
			conn.setAutoCommit(false);
					
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getItem_id		());
			pstmt.setInt	(2,		bean.getItem_seq	());
			pstmt.setString	(3,		bean.getItem_g		());
			pstmt.setString	(4,		bean.getItem_car_no	());
			pstmt.setString	(5,		bean.getItem_car_nm	());
			pstmt.setString	(6,		bean.getItem_dt1	());
			pstmt.setString	(7,		bean.getItem_dt2	());
			pstmt.setInt	(8,		bean.getItem_supply	());
			pstmt.setInt	(9,		bean.getItem_value	());
			pstmt.setString	(10,	bean.getRent_l_cd	());
			pstmt.setString	(11,	bean.getCar_mng_id	());
			pstmt.setString	(12,	bean.getTm			());
			pstmt.setString	(13,	bean.getGubun		());
			pstmt.setString	(14,	bean.getReg_id		());
			pstmt.setString	(15,	bean.getReg_code	());
			pstmt.setString	(16,	bean.getRent_st		());
			pstmt.setString	(17,	bean.getRent_seq	());
			pstmt.setString	(18,	bean.getCar_use		());
			pstmt.setString	(19,	bean.getItem_dt		());
			pstmt.setString	(20,	bean.getEtc			());

			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertTaxItemList]\n"+e);
			System.out.println("[bean.getItem_id	()]\n"+bean.getItem_id		());
			System.out.println("[bean.getItem_seq	()]\n"+bean.getItem_seq		());
	    	System.out.println("[bean.getItem_car_no()]\n"+bean.getItem_car_no	());
			System.out.println("[bean.getRent_l_cd	()]\n"+bean.getRent_l_cd	());
			System.out.println("[bean.getCar_mng_id	()]\n"+bean.getCar_mng_id	());
			System.out.println("[bean.getReg_code	()]\n"+bean.getReg_code		());
			System.out.println("[bean.getItem_dt	()]\n"+bean.getItem_dt		());
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	2단계 : 거래명세서 리스트 조회
	 *  20071128 수정 : 분할청구
	 */	
	public Vector getTaxItemList(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.item_id, "+
				"        min(nvl(m.client_id,b.client_id)) client_id, "+
				"        min(decode(e.print_st,'2','',decode(m.client_id,'',decode(b.tax_type,'2',b.r_site,'1',''),m.r_site))) site_id, "+
				"        min(nvl(a.item_dt,nvl(c.tax_out_dt,c.fee_est_dt))) item_dt, "+
				"        min(c.tax_out_dt) tax_est_dt, "+
				"        sum(a.item_supply+a.item_value) item_hap_num, "+
				"        min(d.user_nm) item_man"+
				" from   tax_item_list a, cont b, scd_fee c, users d, client e, fee_rtn m"+
				" where  a.rent_l_cd=b.rent_l_cd "+
				"        and a.rent_l_cd=c.rent_l_cd and a.rent_st=c.rent_st and a.rent_seq=c.rent_seq and a.tm=c.fee_tm and c.tm_st1='0'"+
				"        and c.rent_mng_id=m.rent_mng_id(+) and c.rent_l_cd=m.rent_l_cd(+) and c.rent_st=m.rent_st(+) and c.rent_seq=m.rent_seq(+)"+
				"        and a.reg_id=d.user_id"+
				"        and b.client_id=e.client_id"+
				"        and a.reg_code='"+reg_code+"' "+
				" group by a.item_id";

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
			System.out.println("[IssueDatabase:getTaxItemList]\n"+e);
			System.out.println("[IssueDatabase:getTaxItemList]\n"+query);
	  		e.printStackTrace();
			
			deleteTaxAll(reg_code);
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
	 *	2단계(2-2) : 거래명세서 리스트 조회
	 *  
	 */	
	public Vector getTaxItemListSusi(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.item_id,"+
				"        sum(a.item_supply+a.item_value) item_hap_num, min(d.user_nm) item_man, "+
				"        min(a.item_dt) item_dt, count(0) item_cnt "+
				" from tax_item_list a, users d "+
				" where "+
				" a.reg_id=d.user_id(+)"+
				" and a.reg_code='"+reg_code+"' group by a.item_id";

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
			System.out.println("[IssueDatabase:getTaxItemList]\n"+e);
	  		e.printStackTrace();
			
			deleteTaxAll(reg_code);
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
	 *	2단계(2-3) : 거래명세서 리스트 조회
	 *  
	 */	
	public Vector getTaxItemListSusiSRent(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.item_id, min(b.cust_id) client_id, '' site_id, "+
				" sum(a.item_supply+a.item_value) item_hap_num, min(d.user_nm) item_man"+
				" from tax_item_list a, rent_cont b, users d "+
				" where a.rent_l_cd=b.rent_s_cd "+
				" and a.reg_id=d.user_id(+)"+
				" and a.reg_code='"+reg_code+"' group by a.item_id";

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
			System.out.println("[IssueDatabase:getTaxItemList]\n"+e);
	  		e.printStackTrace();
			
			deleteTaxAll(reg_code);
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
	 *	2단계(2-4) : 거래명세서 리스트 조회
	 *  
	 */	
	public Vector getTaxItemListSusiOffLs(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.item_id, min(b.client_id) client_id, '' site_id, "+
				" sum(a.item_supply+a.item_value) item_hap_num, min(d.user_nm) item_man"+
				" from tax_item_list a, sui b, users d "+
				" where a.car_mng_id=b.car_mng_id "+
				" and a.reg_id=d.user_id(+)"+
				" and a.reg_code='"+reg_code+"' group by a.item_id";

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
			System.out.println("[IssueDatabase:getTaxItemList]\n"+e);
	  		e.printStackTrace();
			
			deleteTaxAll(reg_code);
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
	 *	2단계(2-5) : 거래명세서 리스트 조회
	 *  
	 */	
	public Vector getTaxItemListSusiServ(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.item_id,"+
				" sum(a.item_supply+a.item_value) item_hap_num, min(d.user_nm) item_man"+
				" from tax_item_list a, users d "+
				" where "+
				" a.reg_id=d.user_id(+)"+
				" and a.reg_code='"+reg_code+"' group by a.item_id";

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
			System.out.println("[IssueDatabase:getTaxItemList]\n"+e);
	  		e.printStackTrace();
			
			deleteTaxAll(reg_code);
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
	 *	2-6단계 : 거래명세서 리스트 item_id 한건 조회
	 *  
	 */	
	public Vector getTaxItemListCase(String item_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from tax_item_list where item_id=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	item_id);
	    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{			
				TaxItemListBean bean = new TaxItemListBean();
				bean.setItem_id		(rs.getString(1));
				bean.setItem_seq	(rs.getInt(2));
				bean.setItem_g		(rs.getString(3));
				bean.setItem_car_no	(rs.getString(4));
				bean.setItem_car_nm	(rs.getString(5));
				bean.setItem_dt1	(rs.getString(6));
				bean.setItem_dt2	(rs.getString(7));
				bean.setItem_supply	(rs.getInt(8));
				bean.setItem_value	(rs.getInt(9));
				bean.setRent_l_cd	(rs.getString(10));
				bean.setCar_mng_id	(rs.getString(11));
				bean.setTm			(rs.getString(12));
				bean.setGubun		(rs.getString(13));
				bean.setReg_id		(rs.getString(14));
				bean.setReg_dt		(rs.getString(15));
				bean.setReg_code	(rs.getString(16));
				bean.setRent_st		(rs.getString(17));
				bean.setRent_seq	(rs.getString(18));
				bean.setCar_use		(rs.getString(19));
				bean.setItem_dt		(rs.getString(20));
				bean.setEtc			(rs.getString(21));
				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemListCase(String item_id)]\n"+e);
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

	//3단계 : 거래명세서 한건 등록
	public boolean insertTaxItem(TaxItemBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO tax_item"+
				" ( item_id, client_id, seq, item_dt, tax_id, item_hap_str, item_hap_num, item_man, tax_est_dt, tax_code, use_yn, cust_st, etax_item_st , tax_item_etc "+
				"    ) VALUES"+
				" ( ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ? ,? )";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getItem_id		());
			pstmt.setString	(2,		bean.getClient_id	());
			pstmt.setString	(3,		bean.getSeq			());
			pstmt.setString	(4,		bean.getItem_dt		());
			pstmt.setString	(5,		bean.getTax_id		());
			pstmt.setString	(6,		bean.getItem_hap_str());
			pstmt.setInt	(7,		bean.getItem_hap_num());
			pstmt.setString	(8,		bean.getItem_man	());
			pstmt.setString	(9,		bean.getTax_est_dt	());
			pstmt.setString	(10,	bean.getTax_code	());
			pstmt.setString	(11,	bean.getUse_yn		());
			pstmt.setString	(12,	bean.getCust_st		());
			pstmt.setString	(13,	bean.getEtax_item_st());
			pstmt.setString	(14,	bean.getTax_item_etc());

			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertTaxItem(TaxItemBean bean)]\n"+e);

			System.out.println("[bean.getItem_id		()]\n"+bean.getItem_id		());
			System.out.println("[bean.getClient_id		()]\n"+bean.getClient_id	());
			System.out.println("[bean.getSeq			()]\n"+bean.getSeq			());
			System.out.println("[bean.getItem_dt		()]\n"+bean.getItem_dt		());
			System.out.println("[bean.getTax_id			()]\n"+bean.getTax_id		());
			System.out.println("[bean.getItem_hap_str	()]\n"+bean.getItem_hap_str	());
			System.out.println("[bean.getItem_hap_num	()]\n"+bean.getItem_hap_num	());
			System.out.println("[bean.getItem_man		()]\n"+bean.getItem_man		());
			System.out.println("[bean.getTax_est_dt		()]\n"+bean.getTax_est_dt	());
			System.out.println("[bean.getTax_code		()]\n"+bean.getTax_code		());
			System.out.println("[bean.getUse_yn			()]\n"+bean.getUse_yn		());
			System.out.println("[bean.getCust_st		()]\n"+bean.getCust_st		());
			System.out.println("[bean.getEtax_item_st	()]\n"+bean.getEtax_item_st	());

			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	4단계 : 거래명세서 조회
	 *  
	 */	
	public Vector getTaxItem(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        g.r_site as site_nm, b.rent_l_cd, h.client_st, a.client_id, a.item_dt, b.tm, b.car_mng_id, nvl(c.br_id,'S1') br_id,"+//nvl(c.br_id,substr(b.rent_l_cd,1,2))
				"        e.item_supply as tax_supply, e.item_value as tax_value, a.item_id, b.item_car_no as car_no,"+
				"        nvl(a.seq,'') seq, b.item_car_nm as car_nm, nvl(d.tax_out_dt,d.fee_est_dt) tax_dt, e.cnt, e.gubun, "+
				"	     nvl(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')),'1') tax_type, "+

				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', nvl(h.con_agnt_nm,h.client_nm),nvl(g.agnt_nm,h.con_agnt_nm)      ) agnt_nm,    "+
				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_email,              nvl(g.agnt_email,h.con_agnt_email)) agnt_email, "+
				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_m_tel,              nvl(g.agnt_m_tel,h.con_agnt_m_tel)) agnt_m_tel, "+
				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_dept,               nvl(g.agnt_dept ,h.con_agnt_dept) ) agnt_dept,  "+
				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_title,              nvl(g.agnt_title,h.con_agnt_title)) agnt_title, "+

				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.tel,      '', h.o_tel,   g.tel    ), nvl(h.o_tel,h.h_tel)) rectel,    "+
				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(TEXT_DECRYPT(g.enp_no, 'pw' ),   '', decode(h.client_st,'2',TEXT_DECRYPT(h.ssn, 'pw' ) ,h.enp_no), TEXT_DECRYPT(g.enp_no, 'pw' ) ),   decode(h.client_st,'2',TEXT_DECRYPT(h.ssn, 'pw' ),h.enp_no)) reccoregno, "+
				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.site_jang,'', decode(h.client_st,'2','',h.client_nm),g.site_jang),decode(h.client_st,'2','',h.client_nm)) reccoceo,   "+
				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.r_site,   '', h.firm_nm, g.r_site ), h.firm_nm ) recconame,           "+
				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.addr,     '', h.o_addr,  g.addr   ), h.o_addr  ) reccoaddr,           "+
				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', g.bus_cdt, h.bus_cdt ) reccobiztype,        "+
				"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', g.bus_itm, h.bus_itm ) reccobizsub,         "+

				"        substr(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.r_site,   '',h.firm_nm, g.r_site), h.firm_nm ),1,30) recconame2,    "+
				"        substr(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.site_jang,'', decode(h.client_st,'2','',h.client_nm),g.site_jang),decode(h.client_st,'2','',h.client_nm)),1,20) reccoceo2,    "+
				"        substr(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', g.bus_cdt, h.bus_cdt ),1,20) reccobiztype2, "+
				"        substr(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', g.bus_itm, h.bus_itm ),1,20) reccobizsub2,  "+

				"        h.app_yn, h.bigo_yn"+
				" from   tax_item a, tax_item_list b, client_site g,"+
				"        (select item_id, count(item_seq) cnt, max(gubun) gubun, sum(item_supply) item_supply, sum(item_value) item_value from tax_item_list where reg_code='"+reg_code+"' group by item_id) e,"+
				"        fee c, scd_fee d, cont f, client h,"+
				"        tax t "+		
				" where  a.item_id=e.item_id"+
				"        and b.rent_l_cd=c.rent_l_cd and c.rent_st='1'"+
				"        and b.rent_l_cd=d.rent_l_cd(+) and b.tm=d.fee_tm(+) and b.rent_st=d.rent_st(+) and b.rent_seq=d.rent_seq(+) and d.tm_st1='0'"+
				"        and b.rent_l_cd=f.rent_l_cd"+
				"        and a.client_id=g.client_id(+) and a.seq=g.seq(+)"+
				"        and a.client_id=h.client_id(+)"+
				"        and a.item_id=b.item_id "+
				"        and a.item_id=t.item_id(+) and t.tax_no is null"+
				" 	     and b.reg_code='"+reg_code+"' and b.item_seq=1";

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
			System.out.println("[IssueDatabase:getTaxItem]\n"+e);
	  		e.printStackTrace();
			
			deleteTaxAll(reg_code);
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
	 *	4-1단계 : 거래명세서 조회
	 *  
	 */	
	public Vector getTaxItemSusi(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        b.rent_l_cd, a.client_id, a.item_dt, b.tm, b.car_mng_id,"+
				"        e.item_supply as tax_supply, e.item_value as tax_value, a.item_id, b.item_car_no as car_no,"+
				"        nvl(a.seq,'') seq, b.item_car_nm as car_nm, e.cnt, e.gubun, "+

				"        decode(decode(a.seq,'',f.tax_type,'2'), '2', decode(g.tel,      '', h.o_tel,   g.tel    ), nvl(h.o_tel,h.h_tel)) rectel,    "+
				"        decode(decode(a.seq,'',f.tax_type,'2'), '2', decode(TEXT_DECRYPT(g.enp_no, 'pw' ),   '', decode(h.client_st,'2',TEXT_DECRYPT(h.ssn, 'pw' ),h.enp_no),TEXT_DECRYPT(g.enp_no, 'pw' ) ),   decode(h.client_st,'2',TEXT_DECRYPT(h.ssn, 'pw' ),h.enp_no)) reccoregno, "+
				"        decode(decode(a.seq,'',f.tax_type,'2'), '2', decode(g.site_jang,'', h.client_nm,g.site_jang),h.client_nm) reccoceo,   "+
				"        decode(decode(a.seq,'',f.tax_type,'2'), '2', decode(g.r_site,   '', h.firm_nm, g.r_site ), h.firm_nm ) recconame,           "+
				"        decode(decode(a.seq,'',f.tax_type,'2'), '2', decode(g.addr,     '', h.o_addr,  g.addr   ), h.o_addr  ) reccoaddr,           "+
				"        decode(decode(a.seq,'',f.tax_type,'2'), '2', g.bus_cdt, h.bus_cdt ) reccobiztype,        "+
				"        decode(decode(a.seq,'',f.tax_type,'2'), '2', g.bus_itm, h.bus_itm ) reccobizsub,         "+
		
				"        substr(decode(decode(a.seq,'',f.tax_type,'2'), '2', decode(g.r_site,   '',h.firm_nm, g.r_site), h.firm_nm ),1,30) recconame2,    "+
				"        substr(decode(decode(a.seq,'',f.tax_type,'2'), '2', decode(g.site_jang,'', h.client_nm,g.site_jang),h.client_nm),1,20) reccoceo2,    "+
				"        substr(decode(decode(a.seq,'',f.tax_type,'2'), '2', g.bus_cdt, h.bus_cdt ),1,20) reccobiztype2, "+
				"        substr(decode(decode(a.seq,'',f.tax_type,'2'), '2', g.bus_itm, h.bus_itm ),1,20) reccobizsub2,   "+

				"        h.bigo_yn, h.bigo_value1, h.bigo_value2, h.pubform, nvl(h.nationality,'1') nationality "+

				" from   tax_item a, tax_item_list b, client_site g,"+
				"        (select item_id, count(item_seq) cnt, min(gubun) gubun, sum(item_supply) item_supply, sum(item_value) item_value from tax_item_list where reg_code='"+reg_code+"' group by item_id) e,"+
				"        cont f, client h"+
				" where  a.item_id=e.item_id"+
				"        and a.item_id=b.item_id "+
				"        and a.client_id=g.client_id(+) and a.seq=g.seq(+)"+
				"        and b.rent_l_cd=f.rent_l_cd(+)"+
				"        and a.client_id=h.client_id(+)"+
				"        and b.reg_code='"+reg_code+"' and b.item_seq=1";

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
			System.out.println("[IssueDatabase:getTaxItem]\n"+e);
	  		e.printStackTrace();
			
			deleteTaxAll(reg_code);
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
	 *	4-2단계 : 거래명세서 한건 조회
	 *  
	 */	
	public TaxItemBean getTaxItemCase(String item_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxItemBean bean = new TaxItemBean();
		String query = "";

		query = " select * from tax_item where item_id=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	item_id);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setItem_id			(rs.getString(1));
				bean.setClient_id		(rs.getString(2));
				bean.setSeq				(rs.getString(3));
				bean.setItem_dt			(rs.getString(4));
				bean.setTax_id			(rs.getString(5));
				bean.setItem_hap_str	(rs.getString(6));
				bean.setItem_hap_num	(rs.getInt(7));
				bean.setItem_man		(rs.getString(8));
				bean.setTax_code		(rs.getString(9));
				bean.setTax_est_dt		(rs.getString(10));
				bean.setTax_no			(rs.getString(11));
				bean.setUse_yn			(rs.getString(12));
				bean.setCancel_dt		(rs.getString(13));
				bean.setCancel_cont		(rs.getString(14));
				bean.setCust_st			(rs.getString(15));
				bean.setEtax_item_st	(rs.getString(16));
				bean.setTax_item_etc	(rs.getString(17));

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemCase(String item_id)]\n"+e);
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


	//5단계 : 세금계산서 한건 등록
	public boolean insertTax(TaxBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO tax"+
				" ( rent_l_cd, client_id, tax_dt, fee_tm, car_mng_id, unity_chk, branch_g, tax_g, "+
				"   tax_supply, tax_value, tax_id, item_id, tax_bigo, seq, tax_no, car_nm, car_no, "+
				"   reg_dt, reg_id, print_dt, print_id, tax_st, tax_type, gubun, "+
				"	con_agnt_nm, con_agnt_dept, con_agnt_title, con_agnt_email, con_agnt_m_tel, app_yn, branch_g2, "+
				"   rectel, reccoregno, recconame, reccoceo, reccoaddr, reccobiztype, reccobizsub, reccossn, taxregno, reccoregnotype, "+
				"   doctype, m_tax_no, cust_st, pubform, reccotaxregno, org_nts_issueid, ven_code, "+
				"	con_agnt_nm2, con_agnt_dept2, con_agnt_title2, con_agnt_email2, con_agnt_m_tel2 "+
				" ) VALUES"+
				" ( ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, replace(?, '-', ''), ?, ?, "+
				"   ?, replace(?, '-', ''), ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ? "+
			    " )";

		try 
		{

			conn.setAutoCommit(false);

			if(AddUtil.lengthb(bean.getRecCoName()) >70){
				bean.setRecCoName(AddUtil.substringb(bean.getRecCoName(),70));
			}

			if(AddUtil.lengthb(bean.getRecCoCeo()) >30){
				bean.setRecCoCeo(AddUtil.substringb(bean.getRecCoCeo(),30));
			}

			if(AddUtil.lengthb(bean.getRecCoBizType()) >40){
				bean.setRecCoBizType(AddUtil.substringb(bean.getRecCoBizType(),40));
			}

			if(AddUtil.lengthb(bean.getRecCoBizSub()) >40){
				bean.setRecCoBizSub(AddUtil.substringb(bean.getRecCoBizSub(),40));
			}

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getRent_l_cd		());
			pstmt.setString	(2,		bean.getClient_id		());
			pstmt.setString	(3,		bean.getTax_dt			());
			pstmt.setString	(4,		bean.getFee_tm			());
			pstmt.setString	(5,		bean.getCar_mng_id		());
			pstmt.setString	(6,		bean.getUnity_chk		());
			pstmt.setString	(7,		bean.getBranch_g		());
			pstmt.setString	(8,		bean.getTax_g			());
			pstmt.setInt	(9,		bean.getTax_supply		());
			pstmt.setInt	(10,	bean.getTax_value		());
			pstmt.setString	(11,	bean.getTax_id			());
			pstmt.setString	(12,	bean.getItem_id			());
			pstmt.setString	(13,	bean.getTax_bigo		());
			pstmt.setString	(14,	bean.getSeq				());
			pstmt.setString	(15,	bean.getTax_no			());
			pstmt.setString	(16,	bean.getCar_nm			());
			pstmt.setString	(17,	bean.getCar_no			());
			pstmt.setString	(18,	bean.getReg_id			());
			pstmt.setString	(19,	bean.getPrint_dt		());
			pstmt.setString	(20,	bean.getPrint_id		());
			pstmt.setString	(21,	bean.getTax_st			());
			pstmt.setString	(22,	bean.getTax_type		());
			pstmt.setString	(23,	bean.getGubun			());
			pstmt.setString	(24,	bean.getCon_agnt_nm		());
			pstmt.setString	(25,	bean.getCon_agnt_dept	());
			pstmt.setString	(26,	bean.getCon_agnt_title	());
			pstmt.setString	(27,	bean.getCon_agnt_email	());
			pstmt.setString	(28,	bean.getCon_agnt_m_tel	());
			pstmt.setString	(29,	bean.getApp_yn			());
			pstmt.setString	(30,	bean.getBranch_g2		());
			pstmt.setString	(31,	bean.getRecTel			());
			pstmt.setString	(32,	bean.getRecCoRegNo		());
			pstmt.setString	(33,	bean.getRecCoName		());
			pstmt.setString	(34,	bean.getRecCoCeo		());
			pstmt.setString	(35,	bean.getRecCoAddr		());
			pstmt.setString	(36,	bean.getRecCoBizType	());
			pstmt.setString	(37,	bean.getRecCoBizSub		());
			pstmt.setString	(38,	bean.getRecCoSsn		());
			pstmt.setString	(39,	bean.getTaxregno		());
			pstmt.setString	(40,	bean.getReccoregnotype	());
			pstmt.setString	(41,	bean.getDoctype			());
			pstmt.setString	(42,	bean.getM_tax_no		());
			pstmt.setString	(43,	bean.getCust_st			());
			pstmt.setString	(44,	bean.getPubForm			());
			pstmt.setString	(45,	bean.getRecCoTaxRegNo	());
			pstmt.setString	(46,	bean.getOrg_nts_issueid	());
			pstmt.setString	(47,	bean.getVen_code		());
			pstmt.setString	(48,	bean.getCon_agnt_nm2	());
			pstmt.setString	(49,	bean.getCon_agnt_dept2	());
			pstmt.setString	(50,	bean.getCon_agnt_title2	());
			pstmt.setString	(51,	bean.getCon_agnt_email2	());
			pstmt.setString	(52,	bean.getCon_agnt_m_tel2	());

			pstmt.executeUpdate();
			pstmt.close();
				
			conn.commit();	

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertTax]\n"+e);

			System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd		());
			System.out.println("[bean.getClient_id		()]\n"+bean.getClient_id		());
			System.out.println("[bean.getTax_dt			()]\n"+bean.getTax_dt			());
			System.out.println("[bean.getFee_tm			()]\n"+bean.getFee_tm			());
			System.out.println("[bean.getCar_mng_id		()]\n"+bean.getCar_mng_id		());
			System.out.println("[bean.getUnity_chk		()]\n"+bean.getUnity_chk		());
			System.out.println("[bean.getBranch_g		()]\n"+bean.getBranch_g			());
			System.out.println("[bean.getTax_g			()]\n"+bean.getTax_g			());
			System.out.println("[bean.getTax_supply		()]\n"+bean.getTax_supply		());
			System.out.println("[bean.getTax_value		()]\n"+bean.getTax_value		());
			System.out.println("[bean.getTax_id			()]\n"+bean.getTax_id			());
			System.out.println("[bean.getItem_id		()]\n"+bean.getItem_id			());
			System.out.println("[bean.getTax_bigo		()]\n"+bean.getTax_bigo			());
			System.out.println("[bean.getSeq			()]\n"+bean.getSeq				());
			System.out.println("[bean.getTax_no			()]\n"+bean.getTax_no			());
			System.out.println("[bean.getCar_nm			()]\n"+bean.getCar_nm			());
			System.out.println("[bean.getCar_no			()]\n"+bean.getCar_no			());
			System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id			());
			System.out.println("[bean.getPrint_dt		()]\n"+bean.getPrint_dt			());
			System.out.println("[bean.getPrint_id		()]\n"+bean.getPrint_id			());
			System.out.println("[bean.getTax_st			()]\n"+bean.getTax_st			());
			System.out.println("[bean.getTax_type		()]\n"+bean.getTax_type			());
			System.out.println("[bean.getGubun			()]\n"+bean.getGubun			());
			System.out.println("[bean.getCon_agnt_nm	()]\n"+bean.getCon_agnt_nm		());
			System.out.println("[bean.getCon_agnt_dept	()]\n"+bean.getCon_agnt_dept	());
			System.out.println("[bean.getCon_agnt_title	()]\n"+bean.getCon_agnt_title	());
			System.out.println("[bean.getCon_agnt_email	()]\n"+bean.getCon_agnt_email	());
			System.out.println("[bean.getCon_agnt_m_tel	()]\n"+bean.getCon_agnt_m_tel	());
			System.out.println("[bean.getApp_yn			()]\n"+bean.getApp_yn			());
			System.out.println("[bean.getBranch_g2		()]\n"+bean.getBranch_g2		());
			System.out.println("[bean.getRecTel			()]\n"+bean.getRecTel			());
			System.out.println("[bean.getRecCoRegNo		()]\n"+bean.getRecCoRegNo		());
			System.out.println("[bean.getRecCoName		()]\n"+bean.getRecCoName		());
			System.out.println("[bean.getRecCoCeo		()]\n"+bean.getRecCoCeo			());
			System.out.println("[bean.getRecCoAddr		()]\n"+bean.getRecCoAddr		());
			System.out.println("[bean.getRecCoBizType	()]\n"+bean.getRecCoBizType		());
			System.out.println("[bean.getRecCoBizSub	()]\n"+bean.getRecCoBizSub		());
			System.out.println("[bean.getRecCoSsn		()]\n"+bean.getRecCoSsn			());
			System.out.println("[bean.getTaxregno		()]\n"+bean.getTaxregno			());
			System.out.println("[bean.getReccoregnotype	()]\n"+bean.getReccoregnotype	());
			System.out.println("[bean.getCust_st		()]\n"+bean.getCust_st			());
			System.out.println("[bean.getPubForm		()]\n"+bean.getPubForm			());
			System.out.println("[bean.getRecCoTaxRegNo	()]\n"+bean.getRecCoTaxRegNo	());

			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	6단계 : 세금계산서 조회
	 *  
	 */	
	public Vector getTax(String min_tax_no, String max_tax_no, String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" e.client_st,"+
				" decode(a.tax_type,'1',e.ven_code,'2',nvl(f.ven_code,e.ven_code)) ven_code,"+
				" decode(a.tax_type,'1',e.enp_no,  '2',nvl(TEXT_DECRYPT(f.enp_no, 'pw' )  ,e.enp_no))     enp_no,"+
				" decode(a.tax_type,'1',e.firm_nm, '2',nvl(f.r_site,e.firm_nm))    firm_nm,"+
				" TEXT_DECRYPT(e.ssn, 'pw' )  ssn, a.*,"+
				" d.item_car_no, c.cnt,"+
				" g.sum_s_amt1, g.sum_s_amt2, g.sum_v_amt1, g.sum_v_amt2"+
				" from tax a, tax_item b,"+
				" (select item_id, count(0) cnt from tax_item_list where reg_code='"+reg_code+"' group by item_id) c,"+
				" tax_item_list d, client e, client_site f,"+
				" (select item_id, min(item_seq) item_seq, "+
				"		sum(decode(nvl(car_use,'1'),'1', item_supply)) sum_s_amt1, "+
				"		sum(decode(nvl(car_use,'1'),'2', item_supply)) sum_s_amt2, "+
				"		sum(decode(nvl(car_use,'1'),'1', item_value))  sum_v_amt1, "+
				"		sum(decode(nvl(car_use,'1'),'2', item_value))  sum_v_amt2  "+
				"  from tax_item_list group by item_id) g"+
				" where a.item_id=b.item_id and a.item_id=c.item_id "+
				" and a.item_id=d.item_id "+
				" and d.item_id=g.item_id and d.item_seq=g.item_seq"+
				" and a.client_id=e.client_id and a.client_id=f.client_id(+) and a.seq=f.seq(+)"+
				" and a.autodocu_write_date is null and a.item_id is not null";

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
			System.out.println("[IssueDatabase:getTax]\n"+e);
	  		e.printStackTrace();
			
			deleteTaxAll(reg_code);
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
	 *	6단계 : 세금계산서 조회
	 *  
	 */	
	public Vector getTax2(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" e.client_st,"+
				" decode(a.tax_type,'1',e.ven_code,'2',nvl(f.ven_code,e.ven_code)) ven_code,"+
				" decode(a.tax_type,'1',e.enp_no,  '2',nvl( TEXT_DECRYPT(f.enp_no, 'pw' )  ,e.enp_no))     enp_no,"+
				" decode(a.tax_type,'1',e.firm_nm, '2',nvl(f.r_site,e.firm_nm))    firm_nm,"+
				" TEXT_DECRYPT(e.ssn, 'pw' )  ssn, a.*,"+
				" d.item_car_no, "+
				" g.sum_s_amt1, g.sum_s_amt2, g.sum_v_amt1, g.sum_v_amt2"+
				" from tax a, tax_item b,"+
				" tax_item_list d, client e, client_site f,"+
				" (select item_id, min(item_seq) item_seq, "+
				"		sum(decode(nvl(car_use,'1'),'1', item_supply)) sum_s_amt1, "+
				"		sum(decode(nvl(car_use,'1'),'2', item_supply)) sum_s_amt2, "+
				"		sum(decode(nvl(car_use,'1'),'1', item_value))  sum_v_amt1, "+
				"		sum(decode(nvl(car_use,'1'),'2', item_value))  sum_v_amt2  "+
				"  from tax_item_list group by item_id) g"+
				" where a.tax_no='"+tax_no+"' and a.item_id=b.item_id "+
				" and a.item_id=d.item_id "+
				" and d.item_id=g.item_id and d.item_seq=g.item_seq"+
				" and a.client_id=e.client_id and a.client_id=f.client_id(+) and a.seq=f.seq(+)"+
				" and a.item_id is not null";

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
			System.out.println("[IssueDatabase:getTax2]\n"+e);
			System.out.println("[IssueDatabase:getTax2]\n"+query);
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
	 *	6-1단계 : 세금계산서 조회(매출취소를 위한)
	 *  
	 */	
	public TaxBean getTax(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		tax.TaxBean bean = new TaxBean();
		String query = "";

		query = " select rent_l_cd, client_id, tax_dt, fee_tm, car_mng_id,"+
				"        nvl(unity_chk,'0') unity_chk, branch_g, tax_g, tax_supply, tax_value,"+
				"        tax_id, item_id, tax_bigo, seq, tax_no,"+
				"        car_nm, car_no, reg_dt, reg_id, print_dt,"+
				"        print_id, autodocu_write_date, autodocu_data_no, nvl(tax_st,'O') tax_st, m_tax_no,"+
				"        tax_type, gubun, resseq, mail_dt,"+
				"        con_agnt_nm, con_agnt_dept, con_agnt_title, con_agnt_email, con_agnt_m_tel, branch_g2,"+
				"        rectel, reccoregno, recconame, reccoceo, reccoaddr, reccobiztype, reccobizsub, reccossn, taxregno, reccoregnotype, "+
				"        doctype, pubform, reccotaxregno, etax_item_st, "+
				"        con_agnt_nm2, con_agnt_dept2, con_agnt_title2, con_agnt_email2, con_agnt_m_tel2, ven_code "+
				" from tax where tax_no=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	tax_no);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{			
				bean.setRent_l_cd		(rs.getString(1));
				bean.setClient_id		(rs.getString(2));
				bean.setTax_dt			(rs.getString(3));
				bean.setFee_tm			(rs.getString(4));
				bean.setCar_mng_id		(rs.getString(5));
				bean.setUnity_chk		(rs.getString(6));
				bean.setBranch_g		(rs.getString(7));
				bean.setTax_g			(rs.getString(8));
				bean.setTax_supply		(rs.getInt(9));
				bean.setTax_value		(rs.getInt(10));
				bean.setTax_id			(rs.getString(11));
				bean.setItem_id			(rs.getString(12));
				bean.setTax_bigo		(rs.getString(13));
				bean.setSeq				(rs.getString(14));
				bean.setTax_no			(rs.getString(15));
				bean.setCar_nm			(rs.getString(16));
				bean.setCar_no			(rs.getString(17));
				bean.setReg_dt			(rs.getString(18));
				bean.setReg_id			(rs.getString(19));
				bean.setPrint_dt		(rs.getString(20));
				bean.setPrint_id		(rs.getString(21));
				bean.setAutodocu_write_date(rs.getString(22));
				bean.setAutodocu_data_no(rs.getString(23));
				bean.setTax_st			(rs.getString(24));
				bean.setM_tax_no		(rs.getString(25));
				bean.setTax_type		(rs.getString(26));
				bean.setGubun			(rs.getString(27));
				bean.setResseq			(rs.getString(28));
				bean.setMail_dt			(rs.getString(29));
				bean.setCon_agnt_nm		(rs.getString(30));
				bean.setCon_agnt_dept	(rs.getString(31));
				bean.setCon_agnt_title	(rs.getString(32));
				bean.setCon_agnt_email	(rs.getString(33));
				bean.setCon_agnt_m_tel	(rs.getString(34));
				bean.setBranch_g2		(rs.getString(35));
				bean.setRecTel			(rs.getString(36));
				bean.setRecCoRegNo		(rs.getString(37));
				bean.setRecCoName		(rs.getString(38));
				bean.setRecCoCeo		(rs.getString(39));
				bean.setRecCoAddr		(rs.getString(40));
				bean.setRecCoBizType	(rs.getString(41));
				bean.setRecCoBizSub		(rs.getString(42));
				bean.setRecCoSsn		(rs.getString(43));
				bean.setTaxregno		(rs.getString(44));
				bean.setReccoregnotype	(rs.getString(45));
				bean.setDoctype			(rs.getString(46));
				bean.setPubForm			(rs.getString(47));
				bean.setRecCoTaxRegNo	(rs.getString(48));
				bean.setEtax_item_st	(rs.getString(49));
				bean.setCon_agnt_nm2	(rs.getString(50));
				bean.setCon_agnt_dept2	(rs.getString(51));
				bean.setCon_agnt_title2	(rs.getString(52));
				bean.setCon_agnt_email2	(rs.getString(53));
				bean.setCon_agnt_m_tel2	(rs.getString(54));
				bean.setVen_code	    (rs.getString(55));


			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTax(String tax_no)]\n"+e);
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
	 *	6-1-1단계 : 세금계산서 조회(매출취소를 위한)
	 *  
	 */	
	public TaxBean getTax_itemId(String item_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		tax.TaxBean bean = new TaxBean();
		String query = "";

		query = " select rent_l_cd, client_id, tax_dt, fee_tm, car_mng_id,"+
				" nvl(unity_chk,'0') unity_chk, branch_g, tax_g, tax_supply, tax_value,"+
				" tax_id, item_id, tax_bigo, seq, tax_no,"+
				" car_nm, car_no, reg_dt, reg_id, print_dt,"+
				" print_id, autodocu_write_date, autodocu_data_no, nvl(tax_st,'O') tax_st, m_tax_no,"+
				" tax_type, resseq, branch_g2, pubform, recconame"+
				" from tax where item_id=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	item_id);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{			
				bean.setRent_l_cd		(rs.getString(1));
				bean.setClient_id		(rs.getString(2));
				bean.setTax_dt			(rs.getString(3));
				bean.setFee_tm			(rs.getString(4));
				bean.setCar_mng_id		(rs.getString(5));
				bean.setUnity_chk		(rs.getString(6));
				bean.setBranch_g		(rs.getString(7));
				bean.setTax_g			(rs.getString(8));
				bean.setTax_supply		(rs.getInt(9));
				bean.setTax_value		(rs.getInt(10));
				bean.setTax_id			(rs.getString(11));
				bean.setItem_id			(rs.getString(12));
				bean.setTax_bigo		(rs.getString(13));
				bean.setSeq				(rs.getString(14));
				bean.setTax_no			(rs.getString(15));
				bean.setCar_nm			(rs.getString(16));
				bean.setCar_no			(rs.getString(17));
				bean.setReg_dt			(rs.getString(18));
				bean.setReg_id			(rs.getString(19));
				bean.setPrint_dt		(rs.getString(20));
				bean.setPrint_id		(rs.getString(21));
				bean.setAutodocu_write_date(rs.getString(22));
				bean.setAutodocu_data_no(rs.getString(23));
				bean.setTax_st			(rs.getString(24));
				bean.setM_tax_no		(rs.getString(25));
				bean.setTax_type		(rs.getString(26));
				bean.setResseq			(rs.getString(27));
				bean.setBranch_g2		(rs.getString(28));
				bean.setPubForm			(rs.getString(29));
				bean.setRecCoName		(rs.getString(30));

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTax_itemId(String tax_no)]\n"+e);
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
	 *	6-1-2단계 : 세금계산서 조회(매출취소를 위한)
	 *  
	 */	
	public TaxBean getTax_accid(String rent_l_cd, String car_mng_id, String accid_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		tax.TaxBean bean = new TaxBean();
		String query = "";

		query = " select rent_l_cd, client_id, tax_dt, fee_tm, car_mng_id,"+
				" nvl(unity_chk,'0') unity_chk, branch_g, tax_g, tax_supply, tax_value,"+
				" tax_id, item_id, tax_bigo, seq, tax_no,"+
				" car_nm, car_no, reg_dt, reg_id, print_dt,"+
				" print_id, autodocu_write_date, autodocu_data_no, nvl(tax_st,'O') tax_st, m_tax_no,"+
				" tax_type, branch_g2"+
				" from tax where fee_tm='"+accid_id+"'";

		if(rent_l_cd.equals(""))	query += " and rent_l_cd='"+rent_l_cd+"'";
		if(car_mng_id.equals(""))	query += " and car_mng_id='"+car_mng_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{			
				bean.setRent_l_cd		(rs.getString(1));
				bean.setClient_id		(rs.getString(2));
				bean.setTax_dt			(rs.getString(3));
				bean.setFee_tm			(rs.getString(4));
				bean.setCar_mng_id		(rs.getString(5));
				bean.setUnity_chk		(rs.getString(6));
				bean.setBranch_g		(rs.getString(7));
				bean.setTax_g			(rs.getString(8));
				bean.setTax_supply		(rs.getInt(9));
				bean.setTax_value		(rs.getInt(10));
				bean.setTax_id			(rs.getString(11));
				bean.setItem_id			(rs.getString(12));
				bean.setTax_bigo		(rs.getString(13));
				bean.setSeq				(rs.getString(14));
				bean.setTax_no			(rs.getString(15));
				bean.setCar_nm			(rs.getString(16));
				bean.setCar_no			(rs.getString(17));
				bean.setReg_dt			(rs.getString(18));
				bean.setReg_id			(rs.getString(19));
				bean.setPrint_dt		(rs.getString(20));
				bean.setPrint_id		(rs.getString(21));
				bean.setAutodocu_write_date(rs.getString(22));
				bean.setAutodocu_data_no(rs.getString(23));
				bean.setTax_st			(rs.getString(24));
				bean.setM_tax_no		(rs.getString(25));
				bean.setTax_type		(rs.getString(26));
				bean.setBranch_g2		(rs.getString(27));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTax_accid(String rent_l_cd, String car_mng_id, String accid_id)]\n"+e);
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
	 *	6-1-2단계 : 세금계산서 조회(매출취소를 위한)
	 *  
	 */	
	public TaxBean getTax_accid(String rent_l_cd, String car_mng_id, String accid_id, String seq_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		tax.TaxBean bean = new TaxBean();
		String query = "";

		query = " select a.rent_l_cd, a.client_id, a.tax_dt, a.fee_tm, a.car_mng_id,"+
				" nvl(a.unity_chk,'0') unity_chk, a.branch_g, a.tax_g, a.tax_supply, a.tax_value,"+
				" a.tax_id, a.item_id, a.tax_bigo, a.seq, a.tax_no,"+
				" a.car_nm, a.car_no, a.reg_dt, a.reg_id, a.print_dt,"+
				" a.print_id, a.autodocu_write_date, a.autodocu_data_no, nvl(a.tax_st,'O') tax_st, a.m_tax_no,"+
				" a.tax_type, a.resseq, a.branch_g2"+
				" from tax a, tax_item_list b "+
				" where a.tax_st='O' and a.fee_tm='"+accid_id+"' and a.item_id=b.item_id(+)";

		if(rent_l_cd.equals(""))	query += " and a.rent_l_cd='"+rent_l_cd+"'";
		if(car_mng_id.equals(""))	query += " and a.car_mng_id='"+car_mng_id+"'";
		if(seq_no.equals(""))		query += " and b.rent_seq='"+seq_no+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{			
				bean.setRent_l_cd		(rs.getString(1));
				bean.setClient_id		(rs.getString(2));
				bean.setTax_dt			(rs.getString(3));
				bean.setFee_tm			(rs.getString(4));
				bean.setCar_mng_id		(rs.getString(5));
				bean.setUnity_chk		(rs.getString(6));
				bean.setBranch_g		(rs.getString(7));
				bean.setTax_g			(rs.getString(8));
				bean.setTax_supply		(rs.getInt(9));
				bean.setTax_value		(rs.getInt(10));
				bean.setTax_id			(rs.getString(11));
				bean.setItem_id			(rs.getString(12));
				bean.setTax_bigo		(rs.getString(13));
				bean.setSeq				(rs.getString(14));
				bean.setTax_no			(rs.getString(15));
				bean.setCar_nm			(rs.getString(16));
				bean.setCar_no			(rs.getString(17));
				bean.setReg_dt			(rs.getString(18));
				bean.setReg_id			(rs.getString(19));
				bean.setPrint_dt		(rs.getString(20));
				bean.setPrint_id		(rs.getString(21));
				bean.setAutodocu_write_date(rs.getString(22));
				bean.setAutodocu_data_no(rs.getString(23));
				bean.setTax_st			(rs.getString(24));
				bean.setM_tax_no		(rs.getString(25));
				bean.setTax_type		(rs.getString(26));
				bean.setResseq			(rs.getString(27));
				bean.setBranch_g2		(rs.getString(28));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTax_accid(String rent_l_cd, String car_mng_id, String accid_id)]\n"+e);
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
	 *	6-2단계 : 세금계산서 조회
	 *  
	 */	
	public Hashtable getTaxHt(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select * from tax where tax_no=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	tax_no);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTax]\n"+e);
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
	 *	6단계 : 세금계산서 조회
	 *  
	 */	
	public Hashtable getTaxClient(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select "+
				" e.client_st, e.ven_code, TEXT_DECRYPT(e.ssn, 'pw' )  ssn, e.enp_no, e.firm_nm, a.*"+
				" from tax a, client e, client_site f"+
				" where a.tax_no=?"+
				" and a.client_id=e.client_id and a.client_id=f.client_id(+) and a.seq=f.seq(+)";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	tax_no);
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
			System.out.println("[IssueDatabase:getTaxClient]\n"+e);
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

	//7단계 : 세금계산서 자동전표 등록
	public boolean updateTaxAutodocu(String tax_no, int data_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE tax SET"+
				" autodocu_write_date=tax_dt, autodocu_data_no='"+data_no+"' "+
				" WHERE tax_no='"+tax_no+"'";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxAutodocu]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
		//7단계 : 세금계산서 자동전표 등록 (입금처리시 계산서 발행)
	public boolean updateTaxAutodocu(String tax_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE tax SET"+
				" autodocu_write_date=tax_dt "+
				" WHERE tax_no='"+tax_no+"'";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxAutodocu]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	8단계 : 기 작성된 세금계산서의 자동전표 삭제를 위한 조회
	 *  
	 */	
	public Vector getTaxAutoD(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" e.ven_code, TEXT_DECRYPT(e.ssn, 'pw' )  ssn, e.enp_no, e.firm_nm, a.*,"+
				" d.item_car_no, c.cnt"+
				" from tax a, tax_item b,"+
				" (select item_id, count(0) cnt from tax_item_list where reg_code='"+reg_code+"' group by item_id) c, tax_item_list d, client e, client_site f"+
				" where a.item_id=b.item_id and a.item_id=c.item_id and a.item_id=d.item_id and d.item_seq='1'"+
				" and a.client_id=e.client_id and a.client_id=f.client_id(+) and a.seq=f.seq(+)"+
				" and a.autodocu_write_date is not null";

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
			System.out.println("[IssueDatabase:getTaxAutoD]\n"+e);
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

	//9단계 : 발행도중 에러 발생시 기작성분 삭제
	public boolean deleteTaxAll(String reg_code)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		String query1 = "";
		String query2 = "";
		String query3 = "";
			
		query1 = " DELETE FROM tax				WHERE item_id in (SELECT item_id FROM tax_item_list WHERE reg_code=?)";
		query2 = " DELETE FROM tax_item			WHERE item_id in (SELECT item_id FROM tax_item_list WHERE reg_code=?)";
		query3 = " DELETE FROM tax_item_list	WHERE reg_code=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString	(1,		reg_code);
			pstmt1.executeUpdate();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString	(1,		reg_code);
			pstmt2.executeUpdate();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString	(1,		reg_code);
			pstmt3.executeUpdate();
			pstmt3.close();
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:deleteTaxAll]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt1 != null )	pstmt1.close();
				if ( pstmt2 != null )	pstmt2.close();
				if ( pstmt3 != null )	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//9-2단계 : 발행도중 에러 발생시 기작성분 삭제
	public boolean deleteTax(String tax_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query1 = "";
			
		query1 = " DELETE FROM tax	WHERE tax_no=?";

		try 
		{
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query1);
			pstmt.setString	(1,		tax_no);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:deleteTax]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//10단계 : 매출취소 등 세금계산서 변경내역 등록
	public boolean insertTaxCng(TaxCngBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO tax_cng"+
				" ( tax_no, seq, cng_cau, cng_dt, cng_id, cng_st"+
				"    ) VALUES"+
				" ( ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?)";

		try 
		{
			conn.setAutoCommit(false);	

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getTax_no		());
			pstmt.setInt	(2,		bean.getSeq			());
			pstmt.setString	(3,		bean.getCng_cau		());
			pstmt.setString	(4,		bean.getCng_id		());
			pstmt.setString	(5,		bean.getCng_st		());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertTaxCng]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//11단계 : 원본계산서에 매출취소계산서번호 입력
	public boolean updateTaxCancel(String o_tax_no, String m_tax_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update tax set m_tax_no=? where tax_no=?";

		try 
		{
			conn.setAutoCommit(false);		

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		m_tax_no);
			pstmt.setString	(2,		o_tax_no);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxCancel]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
	  		
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//12단계 : 원본계산서에 발행취소 사태 입력
	public boolean updateTaxRegCancel(String tax_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update tax set tax_st='C' where tax_no=?";

		try 
		{
			conn.setAutoCommit(false);	
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		tax_no);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxRegCancel]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//12단계 : 원본계산서에 발행취소 사태 입력
	public boolean updateTaxRegCancel2(String tax_no, String item_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		String query = "";
		String query2 = "";
			
		query  = " update tax      set tax_st='C' where tax_no=?";

		query2 = " update tax_item set use_yn='N' where item_id=?";

		try 
		{
			conn.setAutoCommit(false);	
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		tax_no);
			pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString	(1,		item_id);
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxRegCancel2]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
				if ( pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	13단계 : 세금계산서 변경 조회
	 *  
	 */	
	public TaxCngBean getTaxCng(String tax_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxCngBean bean = new TaxCngBean();
		String query = "";

		query = " select * from tax_cng where tax_no=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	tax_no);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setTax_no	(rs.getString(1));
				bean.setSeq		(rs.getInt(2));
				bean.setCng_cau	(rs.getString(3));
				bean.setCng_dt	(rs.getString(4));
				bean.setCng_id	(rs.getString(5));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxCng(String tax_no)]\n"+e);
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

	//14단계 : 원본계산서에 품목 수정
	public boolean updateTaxG(String tax_no, String tax_g)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update tax set tax_g=? where tax_no=?";

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		tax_g);
			pstmt.setString	(2,		tax_no);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxG]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//14단계 : 원본계산서에 품목 수정
	public boolean updateTaxG(String tax_no, String tax_g, String tax_dt)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update tax set tax_g=?, tax_dt=? where tax_no=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		tax_g);
			pstmt.setString	(2,		tax_dt);
			pstmt.setString	(3,		tax_no);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxG]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//관리자모드에서 수정-------------------------------------------------------------------------------------

	//세금계산서 한건 수정
	public boolean updateTax(TaxBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE tax SET "+
				"        tax_dt			=replace(?, '-', ''), "+
				"        branch_g		=?,		"+
				"        tax_g			=?,		"+
				"        tax_supply		=?,		"+
				"        tax_value		=?,		"+
				"        tax_bigo		=?,		"+
				"        branch_g2		=?,		"+
				"        con_agnt_nm	=?,		"+
				"        rectel			=?,		"+
			    "        reccoregno		=replace(?, '-', ''),  "+
				"		 recconame		=?,		"+
				"        reccoceo		=?,		"+
				"        reccoaddr		=?,		"+
				"        reccobiztype	=?,		"+
				"        reccobizsub	=?,		"+
			    "        reccossn		=replace(?, '-', ''),  "+
				"        pubform		=?,		"+
				"        reccoregnotype =?,		"+		
			    "        reccotaxregno	=replace(?, '-', ''),   "+
				"        ven_code = ? "+
				" WHERE  tax_no=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getTax_dt			().trim());
			pstmt.setString	(2,		bean.getBranch_g		().trim());
			pstmt.setString	(3,		bean.getTax_g			().trim());
			pstmt.setInt	(4,		bean.getTax_supply		());
			pstmt.setInt	(5,		bean.getTax_value		());
			pstmt.setString	(6,		bean.getTax_bigo		().trim());
			pstmt.setString	(7,		bean.getBranch_g2		().trim());
			pstmt.setString	(8,		bean.getCon_agnt_nm		().trim());
			pstmt.setString	(9,		bean.getRecTel			().trim());
			pstmt.setString	(10,	bean.getRecCoRegNo		().trim());
			pstmt.setString	(11,	bean.getRecCoName		());
			pstmt.setString	(12,	bean.getRecCoCeo		());
			pstmt.setString	(13,	bean.getRecCoAddr		());
			pstmt.setString	(14,	bean.getRecCoBizType	());
			pstmt.setString	(15,	bean.getRecCoBizSub		());
			pstmt.setString	(16,	bean.getRecCoSsn		().trim());
			pstmt.setString	(17,	bean.getPubForm			());
			pstmt.setString	(18,	bean.getReccoregnotype	());
			pstmt.setString	(19,	bean.getRecCoTaxRegNo	().trim());
			pstmt.setString	(20,	bean.getVen_code		());
			pstmt.setString	(21,	bean.getTax_no			());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTax]\n"+e);

			System.out.println("[bean.getTax_dt			()]\n"+bean.getTax_dt			());
			System.out.println("[bean.getBranch_g		()]\n"+bean.getBranch_g			());
			System.out.println("[bean.getTax_g			()]\n"+bean.getTax_g			());
			System.out.println("[bean.getTax_supply		()]\n"+bean.getTax_supply		());
			System.out.println("[bean.getTax_value		()]\n"+bean.getTax_value		());
			System.out.println("[bean.getTax_bigo		()]\n"+bean.getTax_bigo			());
			System.out.println("[bean.getBranch_g2		()]\n"+bean.getBranch_g2		());
			System.out.println("[bean.getCon_agnt_nm	()]\n"+bean.getCon_agnt_nm		());
			System.out.println("[bean.getRecTel			()]\n"+bean.getRecTel			());
			System.out.println("[bean.getRecCoRegNo		()]\n"+bean.getRecCoRegNo		());
			System.out.println("[bean.getRecCoName		()]\n"+bean.getRecCoName		());
			System.out.println("[bean.getRecCoCeo		()]\n"+bean.getRecCoCeo			());
			System.out.println("[bean.getRecCoAddr		()]\n"+bean.getRecCoAddr		());
			System.out.println("[bean.getRecCoBizType	()]\n"+bean.getRecCoBizType		());
			System.out.println("[bean.getRecCoBizSub	()]\n"+bean.getRecCoBizSub		());
			System.out.println("[bean.getRecCoSsn		()]\n"+bean.getRecCoSsn			());
			System.out.println("[bean.getPubForm		()]\n"+bean.getPubForm			());
			System.out.println("[bean.getReccoregnotype	()]\n"+bean.getReccoregnotype	());
			System.out.println("[bean.getTax_no			()]\n"+bean.getTax_no			());

			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//거래명세서 한건 수정
	public boolean updateTaxItem(TaxItemBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE tax_item SET"+
				"   item_dt			=replace(?, '-', ''), "+
				"   item_hap_str	=?, "+
				"   item_hap_num	=?, "+
				"   item_man		=?, "+
				"   tax_est_dt		=replace(?, '-', ''), "+
				"   tax_code		=?,  "+
				"   use_yn			=?,  "+
				"   tax_item_etc			=?  "+
				" WHERE item_id=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getItem_dt		());
			pstmt.setString	(2,		bean.getItem_hap_str());
			pstmt.setInt	(3,		bean.getItem_hap_num());
			pstmt.setString	(4,		bean.getItem_man	());
			pstmt.setString	(5,		bean.getTax_est_dt	());
			pstmt.setString	(6,		bean.getTax_code	());
			pstmt.setString	(7,		bean.getUse_yn		());
			pstmt.setString	(8,		bean.getTax_item_etc ());
			pstmt.setString	(9,		bean.getItem_id		());
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
					
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxItem]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//거래명세서 리스트 한건 수정
	public boolean updateTaxItemList(TaxItemListBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE tax_item_list SET"+
				"   item_g=?, item_car_no=?, item_car_nm=?,"+
				"   item_dt1=replace(?, '-', ''), item_dt2=replace(?, '-', ''), item_supply=?, item_value=?, etc=?"+
				" WHERE item_id=? and item_seq=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getItem_g		());
			pstmt.setString	(2,		bean.getItem_car_no	());
			pstmt.setString	(3,		bean.getItem_car_nm	());
			pstmt.setString	(4,		bean.getItem_dt1	());
			pstmt.setString	(5,		bean.getItem_dt2	());
			pstmt.setInt	(6,		bean.getItem_supply	());
			pstmt.setInt	(7,		bean.getItem_value	());
			pstmt.setString	(8,		bean.getEtc			());
			pstmt.setString	(9,		bean.getItem_id		());
			pstmt.setInt	(10,	bean.getItem_seq	());

			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxItemList]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//거래명세서 리스트 한건 삭제
	public boolean deleteTaxItemList(TaxItemListBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " DELETE FROM tax_item_list"+
				" WHERE item_id=? and item_seq=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getItem_id		());
			pstmt.setInt	(2,		bean.getItem_seq	());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:deleteTaxItemList]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	거래명세서 리스트 한건 조회
	 *  
	 */	
	public TaxItemListBean getTaxItemListCase(String item_id, String item_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxItemListBean bean = new TaxItemListBean();
		String query = "";

		query = " select * from tax_item_list where item_id=? and item_seq=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	item_id);
			pstmt.setString	(2,	item_seq);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setItem_id		(rs.getString(1));
				bean.setItem_seq	(rs.getInt(2));
				bean.setItem_g		(rs.getString(3));
				bean.setItem_car_no	(rs.getString(4));
				bean.setItem_car_nm	(rs.getString(5));
				bean.setItem_dt1	(rs.getString(6));
				bean.setItem_dt2	(rs.getString(7));
				bean.setItem_supply	(rs.getInt(8));
				bean.setItem_value	(rs.getInt(9));
				bean.setRent_l_cd	(rs.getString(10));
				bean.setCar_mng_id	(rs.getString(11));
				bean.setTm			(rs.getString(12));
				bean.setGubun		(rs.getString(13));
				bean.setReg_dt		(rs.getString(14));
				bean.setReg_id		(rs.getString(15));
				bean.setReg_code	(rs.getString(16));
				bean.setRent_st		(rs.getString(17));
				bean.setRent_seq	(rs.getString(18));
				bean.setCar_use		(rs.getString(19));
				bean.setItem_dt		(rs.getString(20));
				bean.setEtc			(rs.getString(21));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemListCase(String item_id, String item_seq)]\n"+e);
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

	//실발행일자 변환하기-------------------------------------------------------------------------------------------------------------------
	/**
	 *	계약건별 일괄발행 :계약건별 일괄발행리스트
	 *  
	 */	
	public Vector getFeeScd(String date)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from scd_fee where req_dt like '"+date+"%' and req_dt=r_req_dt order by req_dt";

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
			System.out.println("[IssueDatabase:getFeeScd]\n"+e);
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
	 *	계약건별 일괄발행 :계약건별 일괄발행리스트
	 *  
	 */	
	public Vector getFeeScd(String date1, String date2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from scd_fee where req_dt between replace('"+date1+"', '-', '') and replace('"+date2+"', '-', '') and req_dt=r_req_dt order by req_dt";

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
			System.out.println("[IssueDatabase:getFeeScd]\n"+e);
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
	 *	계약건별 일괄발행 :계약건별 일괄발행리스트
	 *  
	 */	
	public Vector getFeeScdReqDt(String date1, String date2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select req_dt from scd_fee where req_dt between replace('"+date1+"', '-', '') and replace('"+date2+"', '-', '') and req_dt=r_req_dt group by req_dt order by req_dt";

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
			System.out.println("[IssueDatabase:getFeeScd]\n"+e);
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
	 *	연장회차 삭제 : 한회차 대여료 delete /con_fee/ext_scd_i_a.jsp
	 */
	public void updateR_req_dt(String m_id, String l_cd, String fee_tm, String tm_st1, String r_req_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query1 = " update scd_fee set req_dt=replace(?, '-', '')"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and FEE_TM=? and tm_st1=?";
		try {
				conn.setAutoCommit(false);
				
				pstmt1 = conn.prepareStatement(query1);
				pstmt1.setString(1 , r_req_dt);
				pstmt1.setString(2 , m_id);
				pstmt1.setString(3 , l_cd);
				pstmt1.setString(4 , fee_tm);
				pstmt1.setString(5 , tm_st1);
				pstmt1.executeUpdate();	
				pstmt1.close();
				conn.commit();	    

	  	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:updateR_req_dt]\n"+e);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
		}			
	}
	
	
	/**
	 *	연장회차 삭제 : 한회차 대여료 delete /con_fee/ext_scd_i_a.jsp
	 */
	public void updateR_req_dt(String req_dt, String r_req_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;

		String query1 = " update scd_fee set req_dt=replace(?, '-', '')"+
						" where req_dt=?";
		try {
				conn.setAutoCommit(false);
				
				pstmt1 = conn.prepareStatement(query1);
				pstmt1.setString(1 , r_req_dt);
				pstmt1.setString(2 , req_dt);
				pstmt1.executeUpdate();	
				pstmt1.close();
				conn.commit();	    

	 	} catch (Exception e) {
            try{
					System.out.println("[IssueDatabase:updateR_req_dt]\n"+e);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
		}			
	}
	

	//트러스빌 전자세금계산서 도입------------------------------------------------------------------------------------------------


	/**
	 *	세금계산서 조회
	 */	
	public Vector getTaxEBill(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" f.item_id, f.cnt, a.tax_no, a.tax_dt, a.tax_bigo, a.tax_supply, a.tax_value,"+
				" substr(a.tax_dt,5,4) tax_mmdd, a.tax_g, d.client_st,"+
				" c.user_nm, c.user_email, c.user_h_tel,"+
				" b.br_ent_no, b.br_nm, b.br_own_nm, b.br_addr, b.br_sta, b.br_item,"+

				" decode(a.con_agnt_nm,   '', decode(a.tax_type,'2',decode(e.agnt_nm,   '',d.con_agnt_nm,   e.agnt_nm   ),d.con_agnt_nm       ),a.con_agnt_nm   ) agnt_nm,"+
				" decode(a.con_agnt_email,'', decode(a.tax_type,'2',decode(e.agnt_email,'',d.con_agnt_email,e.agnt_email),d.con_agnt_email    ),a.con_agnt_email) agnt_email,"+

				" decode(a.con_agnt_m_tel,'', decode(a.tax_type,'2',decode(e.tel,       '',d.o_tel,         e.tel       ),nvl(d.o_tel,d.h_tel)),a.con_agnt_m_tel) tel,"+
				" decode(a.tax_type,'2',decode(TEXT_DECRYPT(e.enp_no, 'pw' ) ,  '',decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ) ,d.ENP_NO), TEXT_DECRYPT(e.enp_no, 'pw' )),   decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ),d.ENP_NO)) enp_no,"+
				" decode(a.tax_type,'2',decode(e.site_jang,'',decode(d.client_st,'2','',d.client_nm),e.site_jang),decode(d.client_st,'2','',d.client_nm)) client_nm,"+
				" decode(a.tax_type,'2',decode(e.r_site,   '',d.firm_nm, e.r_site), d.firm_nm ) firm_nm,"+
				" decode(a.tax_type,'2',decode(e.addr,     '',d.o_addr,  e.addr),   d.o_addr  ) addr,"+
				" decode(a.tax_type,'2',e.bus_cdt, d.bus_cdt ) bus_cdt,"+
				" decode(a.tax_type,'2',e.bus_itm, d.bus_itm ) bus_itm,"+
				" substr(decode(a.tax_type,'2', decode(e.r_site,   '',d.firm_nm, e.r_site), d.firm_nm ),1,20) firm_nm2,"+
				" substr(decode(a.tax_type,'2', e.bus_cdt, d.bus_cdt ),1,20) bus_cdt2,"+
				" substr(decode(a.tax_type,'2', e.bus_itm, d.bus_itm ),1,15) bus_itm2,"+

				" a.rectel, a.reccoregno, a.recconame, a.reccoceo, a.reccoaddr, a.reccobiztype, a.reccobizsub "+

				" from tax a, branch b, users c, client d, client_site e, "+
				" (select item_id, count(0) cnt from tax_item_list where reg_code='"+reg_code+"' group by item_id) f"+
				" where"+
				" a.tax_st<>'C' and d.etax_not_cau is null and nvl(e.agnt_email,d.con_agnt_email) is not null"+
				" and a.branch_g=b.br_id"+
				" and a.reg_id=c.user_id"+
				" and a.client_id=d.client_id"+
				" and a.client_id=e.client_id(+) and a.seq=e.seq(+)"+
				" and a.item_id=f.item_id and a.resseq is null"+
				" order by d.firm_nm";

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
			System.out.println("[IssueDatabase:getTaxEBill]\n"+e);
	  		e.printStackTrace();
			
			deleteTaxAll(reg_code);
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	public String getResSeqNext()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String resseq = "";
		String query = "";

		query = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(resseq,9,7))+1), '0000000')), '0000001') resseq"+
				" from saleEBill "+
				" where substr(resseq,1,8)=to_char(sysdate,'YYYYMMDD')";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				resseq = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getResSeqNext]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return resseq;
		}		
	}

	public String getSeqIdNext(String table, String head)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String seqid = "";
		String query = "";

		query = " select '"+head+"'||to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(seqID,11,5))+1), '00000')), '00001') seqID"+
				" from "+table+" "+
				" where substr(seqID,3,8)=to_char(sysdate,'YYYYMMDD')";


		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				seqid = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getSeqIdNext]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seqid;
		}		
	}

	//전자세금계산서 한건 등록
	public boolean insertSaleEBill(SaleEBillBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO saleebill"+
				" ( resseq, doctype, doccode, customs, refcoregno, refconame, taxsnum1, taxsnum2, taxsnum3, docattr,"+//1
				"   origin, pubdate, systemcode, pubtype, pubform, bookno1, bookno2, remarks, memid, memname,"+//2
				"   email, tel, coregno, coname, coceo, coaddr, cobiztype, cobizsub, vidcheck, recmemid,"+//3
				"   recmemname, recemail, rectel, reccoregno, recconame, reccoceo, reccoaddr, reccobiztype, reccobizsub, supprice,"+//4
				"   tax, cash, cheque, bill, outstand, itemdate1, itemname1, itemtype1, itemqyt1, itemprice1,"+//5
				"	itemsupprice1, itemtax1, itemremarks1, itemdate2, itemname2, itemtype2, itemqyt2, itemprice2, itemsupprice2, itemtax2,"+//6
				"	itemremarks2, itemdate3, itemname3, itemtype3, itemqyt3, itemprice3, itemsupprice3, itemtax3, itemremarks3, itemdate4,"+//7
				"	itemname4, itemtype4, itemqyt4, itemprice4, itemsupprice4, itemtax4, itemremarks4, pubkind, loadstatus, pubcode,"+//8
				"   pubstatus"+//9
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?)";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getResSeq       ());
			pstmt.setString	(2,		bean.getDocType      ());
			pstmt.setString	(3,		bean.getDocCode      ());
			pstmt.setString	(4,		bean.getCustoms      ());
			pstmt.setString	(5,		bean.getRefCoRegNo   ());
			pstmt.setString	(6,		bean.getRefCoName    ());
			pstmt.setString	(7,		bean.getTaxSNum1     ());
			pstmt.setString	(8,		bean.getTaxSNum2     ());
			pstmt.setString (9,		bean.getTaxSNum3     ());
			pstmt.setString (10,	bean.getDocAttr      ());
			pstmt.setString	(11,	bean.getOrigin       ());
			pstmt.setString	(12,	bean.getPubDate      ());
			pstmt.setString	(13,	bean.getSystemCode   ());
			pstmt.setString	(14,	bean.getPubType      ());
			pstmt.setString	(15,	bean.getPubForm      ());
			pstmt.setString	(16,	bean.getBookNo1      ());
			pstmt.setString	(17,	bean.getBookNo2      ());
			pstmt.setString	(18,	bean.getRemarks      ());
			pstmt.setString	(19,	bean.getMemID        ());
			pstmt.setString (20,	bean.getMemName      ());
			pstmt.setString	(21,	bean.getEmail        ());
			pstmt.setString	(22,	bean.getTel          ());
			pstmt.setString	(23,	bean.getCoRegNo      ());
			pstmt.setString	(24,	bean.getCoName       ());
			pstmt.setString	(25,	bean.getCoCeo        ());
			pstmt.setString	(26,	bean.getCoAddr       ());
			pstmt.setString	(27,	bean.getCoBizType    ());
			pstmt.setString	(28,	bean.getCoBizSub     ());
			pstmt.setString	(29,	bean.getVidCheck     ());
			pstmt.setString (30,	bean.getRecMemID     ());
			pstmt.setString	(31,	bean.getRecMemName   ());
			pstmt.setString	(32,	bean.getRecEMail     ());
			pstmt.setString	(33,	bean.getRecTel       ());
			pstmt.setString	(34,	bean.getRecCoRegNo   ());
			pstmt.setString	(35,	bean.getRecCoName    ());
			pstmt.setString	(36,	bean.getRecCoCeo     ());
			pstmt.setString	(37,	bean.getRecCoAddr    ());
			pstmt.setString	(38,	bean.getRecCoBizType ());
			pstmt.setString	(39,	bean.getRecCoBizSub  ());
			pstmt.setInt    (40,	bean.getSupPrice     ());
			pstmt.setInt   	(41,	bean.getTax          ());
			pstmt.setInt   	(42,	bean.getCash         ());
			pstmt.setInt   	(43,	bean.getCheque       ());
			pstmt.setInt   	(44,	bean.getBill         ());
			pstmt.setInt   	(45,	bean.getOutstand     ());
			pstmt.setString	(46,	bean.getItemDate1    ());
			pstmt.setString	(47,	bean.getItemName1    ());
			pstmt.setString	(48,	bean.getItemType1    ());
			pstmt.setInt   	(49,	bean.getItemQyt1     ());
			pstmt.setInt    (50,	bean.getItemPrice1   ());
			pstmt.setInt   	(51,	bean.getItemSupPrice1());
			pstmt.setInt   	(52,	bean.getItemTax1     ());
			pstmt.setString	(53,	bean.getItemRemarks1 ());
			pstmt.setString	(54,	bean.getItemDate2    ());
			pstmt.setString	(55,	bean.getItemName2    ());
			pstmt.setString	(56,	bean.getItemType2    ());
			pstmt.setInt   	(57,	bean.getItemQyt2     ());
			pstmt.setInt   	(58,	bean.getItemPrice2   ());
			pstmt.setInt   	(59,	bean.getItemSupPrice2());
			pstmt.setInt    (60,	bean.getItemTax2     ());
			pstmt.setString	(61,	bean.getItemRemarks2 ());
			pstmt.setString	(62,	bean.getItemDate3    ());
			pstmt.setString	(63,	bean.getItemName3    ());
			pstmt.setString	(64,	bean.getItemType3    ());
			pstmt.setInt   	(65,	bean.getItemQyt3     ());
			pstmt.setInt   	(66,	bean.getItemPrice3   ());
			pstmt.setInt   	(67,	bean.getItemSupPrice3());
			pstmt.setInt   	(68,	bean.getItemTax3     ());
			pstmt.setString	(69,	bean.getItemRemarks3 ());
			pstmt.setString (70,	bean.getItemDate4    ());
			pstmt.setString	(71,	bean.getItemName4    ());
			pstmt.setString	(72,	bean.getItemType4    ());
			pstmt.setInt   	(73,	bean.getItemQyt4     ());
			pstmt.setInt   	(74,	bean.getItemPrice4   ());
			pstmt.setInt   	(75,	bean.getItemSupPrice4());
			pstmt.setInt   	(76,	bean.getItemTax4     ());
			pstmt.setString	(77,	bean.getItemRemarks4 ());
			pstmt.setString	(78,	bean.getPubKind      ());
			pstmt.setInt   	(79,	bean.getLoadStatus   ());
			pstmt.setString (80,	bean.getPubCode      ());
			pstmt.setString	(81,	bean.getPubStatus    ());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertSaleEBill]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//전자세금계산서 한건 등록
	public boolean insertSaleEBillCase(String resseq, String tax_no, String br_ent_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt_s = null;
		PreparedStatement pstmt_s2 = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		SaleEBillBean bean = new SaleEBillBean();
		String query = ""; 
		String query2 = ""; 
		String query3 = ""; 
		String query4 = "";

		query = " select"+
				" a.tax_no, a.tax_dt, a.tax_bigo, a.tax_supply, a.tax_value,"+
				" substr(a.tax_dt,5,4) tax_mmdd, a.tax_g, d.client_st,"+
				" c.user_nm, 'tax@amazoncar.co.kr' user_email, '02-392-4243' user_h_tel,"+
				" b.br_ent_no, b.br_nm, b.br_own_nm, b.br_addr, b.br_sta, b.br_item,"+
				" decode(a.gubun,'13',f.user_m_tel,decode(a.tax_type,'2',e.tel,nvl(d.o_tel,nvl(d.h_tel,d.m_tel)))) tel,"+
				" decode(a.gubun,'13',  TEXT_DECRYPT(f.user_ssn, 'pw' )  ,decode(a.tax_type,'2',decode(TEXT_DECRYPT(e.enp_no, 'pw' ) ,'',decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ) ,d.ENP_NO), TEXT_DECRYPT(e.enp_no, 'pw' )),decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ),d.ENP_NO))) enp_no,"+
				" substr(decode(a.gubun,'13',f.user_nm,decode(a.tax_type,'2',decode(e.r_site,'',d.firm_nm,e.r_site),d.firm_nm)),1,20) firm_nm,"+
				" decode(a.gubun,'13','',decode(a.tax_type,'2',decode(e.site_jang,'',decode(d.client_st,'2','',d.client_nm),e.site_jang),decode(d.client_st,'2','',d.client_nm))) client_nm,"+
				" decode(a.gubun,'13',f.addr,decode(a.tax_type,'2',decode(e.addr,'',d.o_addr,e.addr),d.o_addr)) addr,"+
				" substr(decode(a.gubun,'13','',decode(a.tax_type,'2',e.bus_cdt,d.BUS_CDT)),1,20) bus_cdt,"+
				" substr(decode(a.gubun,'13','',decode(a.tax_type,'2',e.bus_cdt,d.bus_itm)),1,15) bus_itm,"+
				" decode(a.gubun,'13','',decode(a.tax_type,'2',decode(e.agnt_nm,'',d.con_agnt_nm,e.agnt_nm),d.con_agnt_nm)) agnt_nm,"+
				" decode(a.gubun,'13',f.user_email,decode(a.tax_type,'2',decode(e.agnt_email,'',d.con_agnt_email,e.agnt_email),d.con_agnt_email)) agnt_email, "+
				" a.gubun, nvl(a.doctype,'') doctype "+
				" from tax a, branch b, users c, client d, client_site e, users f"+
				" where"+
				" a.tax_no='"+tax_no+"'"+
				" and a.branch_g=b.br_id"+
				" and a.reg_id=c.user_id"+
				" and a.client_id=d.client_id(+)"+
				" and a.client_id=e.client_id(+) and a.seq=e.seq(+) and a.client_id=f.user_id(+)";


		query2 = " INSERT INTO saleebill"+
				" ( resseq, doctype, doccode, customs, refcoregno, refconame, taxsnum1, taxsnum2, taxsnum3, docattr,"+//1
				"   origin, pubdate, systemcode, pubtype, pubform, bookno1, bookno2, remarks, memid, memname,"+//2
				"   email, tel, coregno, coname, coceo, coaddr, cobiztype, cobizsub, vidcheck, recmemid,"+//3
				"   recmemname, recemail, rectel, reccoregno, recconame, reccoceo, reccoaddr, reccobiztype, reccobizsub, supprice,"+//4
				"   tax, cash, cheque, bill, outstand, itemdate1, itemname1, itemtype1, itemqyt1, itemprice1,"+//5
				"	itemsupprice1, itemtax1, itemremarks1, itemdate2, itemname2, itemtype2, itemqyt2, itemprice2, itemsupprice2, itemtax2,"+//6
				"	itemremarks2, itemdate3, itemname3, itemtype3, itemqyt3, itemprice3, itemsupprice3, itemtax3, itemremarks3, itemdate4,"+//7
				"	itemname4, itemtype4, itemqyt4, itemprice4, itemsupprice4, itemtax4, itemremarks4, pubkind, loadstatus, pubcode,"+//8
				"   pubstatus,"+
				"	EBILLKIND, TAXSNUM, REMARKS2, REMARKS3, MEMDEPTNAME, COTAXREGNO, RECMEMDEPTNAME, "+//1
				"	RECMEMID2, RECMEMDEPTNAME2, RECMEMNAME2, RECEMAIL2, RECTEL2, "+//2
				"	RECCOREGNOTYPE, RECCOTAXREGNO, BROKERMEMID, BROKERMEMDEPTNAME, BROKERMEMNAME, "+//3
				"	BROKEREMAIL, BROKERTEL, BROKERCOREGNO, BROKERCOTAXREGNO, BROKERCONAME, BROKERCOCEO, "+//4
				"	BROKERCOADDR, BROKERCOBIZTYPE, BROKERCOBIZSUB, SMS, NTS_ISSUEID "+//5
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, "+
				"	?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ? "+
				"	)";

		query3 = " select * from tax_item_list where item_id in (select item_id from tax where tax_no='"+tax_no+"')";

		query4 = " INSERT INTO itemlist"+
				" ( seqid, detailseqid, itemdate, itemname, itemtype, itemqty, itemprice, itemsupprice, itemtax, itemremarks"+
				" ) VALUES"+
				" ( ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?"+
				"   )";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt_s = conn.prepareStatement(query);
	    	rs = pstmt_s.executeQuery();
    	
			if(rs.next())
			{		
				bean.setResSeq				(resseq);
				bean.setDocType				(rs.getString("DOCTYPE"));
				bean.setDocCode				("02");
				bean.setCustoms				("T");
				if(rs.getString("BR_ENT_NO").equals(br_ent_no)){
					bean.setRefCoRegNo		("");
					bean.setRefCoName		("");
				}else{
					bean.setRefCoRegNo		("");
					bean.setRefCoName		("");
				}
				bean.setTaxSNum1			(rs.getString("TAX_NO"));
				bean.setTaxSNum2			("");
				bean.setTaxSNum3			("");
				bean.setDocAttr				("N");
				bean.setOrigin				("");
				bean.setPubDate				(rs.getString("TAX_DT"));
				bean.setSystemCode			("KF");
				bean.setPubType				("S");
				bean.setPubForm				("D");
				bean.setBookNo1				("");
				bean.setBookNo2				("");
				bean.setMemID				("amazoncar11");
				bean.setMemName				(rs.getString("USER_NM"));
				bean.setEmail				(rs.getString("USER_EMAIL"));
				bean.setTel					(rs.getString("USER_H_TEL"));
				bean.setCoRegNo				(rs.getString("BR_ENT_NO"));
				bean.setCoName				("(주)아마존카");
				bean.setCoCeo				(rs.getString("BR_OWN_NM"));
				bean.setCoAddr				(rs.getString("BR_ADDR"));
				bean.setCoBizType			(rs.getString("BR_STA"));
				bean.setCoBizSub			(rs.getString("BR_ITEM"));
				bean.setVidCheck			("");
				bean.setRecMemID			("");
				bean.setRecMemName			(rs.getString("AGNT_NM"));
				bean.setRecEMail			(rs.getString("AGNT_EMAIL"));
				bean.setRecTel				(rs.getString("TEL"));
				if(rs.getString("ENP_NO").length() == 13){
					bean.setRecCoRegNo		(rs.getString("ENP_NO"));
				}else{
					bean.setRecCoRegNo		(rs.getString("ENP_NO"));
				}
				bean.setRecCoName			(rs.getString("FIRM_NM"));
				bean.setRecCoCeo			(rs.getString("CLIENT_NM"));
				bean.setRecCoAddr			(rs.getString("ADDR"));
				bean.setRecCoBizType		(rs.getString("BUS_CDT"));
				bean.setRecCoBizSub			(rs.getString("BUS_ITM"));
				bean.setSupPrice			(rs.getInt("TAX_SUPPLY"));
				bean.setTax					(rs.getInt("TAX_VALUE"));
				bean.setCash				(0);
				bean.setCheque				(0);
				bean.setBill				(0);
				bean.setOutstand			(0);
				bean.setItemDate1			("");
				bean.setItemName1			("");
				bean.setItemType1			("");
				bean.setItemQyt1			(0);
				bean.setItemPrice1			(0);
				bean.setItemSupPrice1		(0);
				bean.setItemTax1			(0);
				bean.setItemRemarks1		("");
				bean.setItemDate2			("");
				bean.setItemName2			("");
				bean.setItemType2			("");
				bean.setItemQyt2			(0);
				bean.setItemPrice2			(0);
				bean.setItemSupPrice2		(0);
				bean.setItemTax2			(0);
				bean.setItemRemarks2		("");
				bean.setItemDate3			("");
				bean.setItemName3			("");
				bean.setItemType3			("");
				bean.setItemQyt3			(0);
				bean.setItemPrice3			(0);
				bean.setItemSupPrice3		(0);
				bean.setItemTax3			(0);
				bean.setItemRemarks3		("");
				bean.setItemDate4			("");
				bean.setItemName4			("");
				bean.setItemType4			("");
				bean.setItemQyt4			(0);
				bean.setItemPrice4			(0);
				bean.setItemSupPrice4		(0);
				bean.setItemTax4			(0);
				bean.setItemRemarks4		("");
				bean.setPubKind				("N");
				bean.setLoadStatus			(0);
				bean.setPubCode				("");
				bean.setPubStatus			("");
				bean.setGubun				(rs.getString("GUBUN"));  //해지정산 후 세금계산서는 15
				bean.setEBillkind			(1);
				bean.setTaxSNum				(rs.getString("TAX_NO"));
				bean.setRemarks2			("");
				bean.setRemarks3			("");
				bean.setMemDeptName			("총무팀");
				bean.setCoTaxRegNo			(rs.getString("TAXREGNO"));
				bean.setRecMemDeptName		("");
				bean.setRecMemId2			("");
				bean.setRecMemDeptName2		("");
				bean.setRecMemName2			("");
				bean.setRecEMail2			("");
				bean.setRecTel2				("");
				bean.setRecCoRegNoType		("01");
				if(rs.getString("ENP_NO").length() == 13){
					bean.setRecCoRegNoType		("02");
				}
				bean.setRecCoTaxRegNo		("");
				bean.setBrokerMemId			("");
				bean.setBrokerMemDeptName	("");
				bean.setBrokerMemName		("");
				bean.setBrokerEMail			("");
				bean.setBrokerTel			("");
				bean.setBrokerCoRegNo		("");
				bean.setBrokerCoTaxRegNo	("");
				bean.setBrokerCoName		("");
				bean.setBrokerCeo			("");
				bean.setBrokerAddr			("");
				bean.setBrokerBizType		("");
				bean.setBrokerBizSub		("");
				bean.setSms					("");
				bean.setNts_IssueId			("");
			}
			rs.close();
			pstmt_s.close();
			
			if(!bean.getResSeq().equals("")){
				pstmt = conn.prepareStatement(query2);

				pstmt.setString	(1,		bean.getResSeq       ());
				pstmt.setString	(2,		bean.getDocType      ());
				pstmt.setString	(3,		bean.getDocCode      ());
				pstmt.setString	(4,		bean.getCustoms      ());
				pstmt.setString	(5,		bean.getRefCoRegNo   ());
				pstmt.setString	(6,		bean.getRefCoName    ());
				pstmt.setString	(7,		bean.getTaxSNum1     ());
				pstmt.setString	(8,		bean.getTaxSNum2     ());
				pstmt.setString (9,		bean.getTaxSNum3     ());
				pstmt.setString (10,	bean.getDocAttr      ());
				pstmt.setString	(11,	bean.getOrigin       ());
				pstmt.setString	(12,	bean.getPubDate      ());
				pstmt.setString	(13,	bean.getSystemCode   ());
				pstmt.setString	(14,	bean.getPubType      ());
				pstmt.setString	(15,	bean.getPubForm      ());
				pstmt.setString	(16,	bean.getBookNo1      ());
				pstmt.setString	(17,	bean.getBookNo2      ());
				pstmt.setString	(18,	bean.getRemarks      ());
				pstmt.setString	(19,	bean.getMemID        ());
				pstmt.setString (20,	bean.getMemName      ());
				pstmt.setString	(21,	bean.getEmail        ());
				pstmt.setString	(22,	bean.getTel          ());
				pstmt.setString	(23,	bean.getCoRegNo      ());
				pstmt.setString	(24,	bean.getCoName       ());
				pstmt.setString	(25,	bean.getCoCeo        ());
				pstmt.setString	(26,	bean.getCoAddr       ());
				pstmt.setString	(27,	bean.getCoBizType    ());
				pstmt.setString	(28,	bean.getCoBizSub     ());
				pstmt.setString	(29,	bean.getVidCheck     ());
				pstmt.setString (30,	bean.getRecMemID     ());
				pstmt.setString	(31,	bean.getRecMemName   ());  //공급받는자 e-mail 계산서
			
				if( bean.getGubun().equals("15") ){
					pstmt.setString	(32,	bean.getRecEMail     ());  //공급받는자 e-mail			
				} else {				
					pstmt.setString	(32,	"");  //공급받는자 e-mail
				}
				pstmt.setString	(33,	bean.getRecTel       ());
				pstmt.setString	(34,	bean.getRecCoRegNo   ());
				pstmt.setString	(35,	bean.getRecCoName    ());
				pstmt.setString	(36,	bean.getRecCoCeo     ());
				pstmt.setString	(37,	bean.getRecCoAddr    ());
				pstmt.setString	(38,	bean.getRecCoBizType ());
				pstmt.setString	(39,	bean.getRecCoBizSub  ());
				pstmt.setInt    (40,	bean.getSupPrice     ());
				pstmt.setInt   	(41,	bean.getTax          ());
				pstmt.setInt   	(42,	bean.getCash         ());
				pstmt.setInt   	(43,	bean.getCheque       ());
				pstmt.setInt   	(44,	bean.getBill         ());
				pstmt.setInt   	(45,	bean.getOutstand     ());
				pstmt.setString	(46,	bean.getItemDate1    ());
				pstmt.setString	(47,	bean.getItemName1    ());
				pstmt.setString	(48,	bean.getItemType1    ());
				pstmt.setInt   	(49,	bean.getItemQyt1     ());
				pstmt.setInt    (50,	bean.getItemPrice1   ());
				pstmt.setInt   	(51,	bean.getItemSupPrice1());
				pstmt.setInt   	(52,	bean.getItemTax1     ());
				pstmt.setString	(53,	bean.getItemRemarks1 ());
				pstmt.setString	(54,	bean.getItemDate2    ());
				pstmt.setString	(55,	bean.getItemName2    ());
				pstmt.setString	(56,	bean.getItemType2    ());
				pstmt.setInt   	(57,	bean.getItemQyt2     ());
				pstmt.setInt   	(58,	bean.getItemPrice2   ());
				pstmt.setInt   	(59,	bean.getItemSupPrice2());
				pstmt.setInt    (60,	bean.getItemTax2     ());
				pstmt.setString	(61,	bean.getItemRemarks2 ());
				pstmt.setString	(62,	bean.getItemDate3    ());
				pstmt.setString	(63,	bean.getItemName3    ());
				pstmt.setString	(64,	bean.getItemType3    ());
				pstmt.setInt   	(65,	bean.getItemQyt3     ());
				pstmt.setInt   	(66,	bean.getItemPrice3   ());
				pstmt.setInt   	(67,	bean.getItemSupPrice3());
				pstmt.setInt   	(68,	bean.getItemTax3     ());
				pstmt.setString	(69,	bean.getItemRemarks3 ());
				pstmt.setString (70,	bean.getItemDate4    ());
				pstmt.setString	(71,	bean.getItemName4    ());
				pstmt.setString	(72,	bean.getItemType4    ());
				pstmt.setInt   	(73,	bean.getItemQyt4     ());
				pstmt.setInt   	(74,	bean.getItemPrice4   ());
				pstmt.setInt   	(75,	bean.getItemSupPrice4());
				pstmt.setInt   	(76,	bean.getItemTax4     ());
				pstmt.setString	(77,	bean.getItemRemarks4 ());
				pstmt.setString	(78,	bean.getPubKind      ());
				pstmt.setInt   	(79,	bean.getLoadStatus   ());
				pstmt.setString (80,	bean.getPubCode      ());
				pstmt.setString	(81,	bean.getPubStatus    ());

				pstmt.setInt   	(82,	bean.getEBillkind			());
				pstmt.setString (83,	bean.getTaxSNum				());
				pstmt.setString	(84,	bean.getRemarks2			());
				pstmt.setString	(85,	bean.getRemarks3			());
				pstmt.setString	(86,	bean.getMemDeptName			());
				pstmt.setString	(87,	bean.getCoTaxRegNo			());
				pstmt.setString	(88,	bean.getRecMemDeptName		());
				pstmt.setString	(89,	bean.getRecMemId2			());
				pstmt.setString (90,	bean.getRecMemDeptName2		());
				pstmt.setString	(91,	bean.getRecMemName2			());
				pstmt.setString	(92,	bean.getRecEMail2			());
				pstmt.setString	(93,	bean.getRecTel2				());
				pstmt.setString	(94,	bean.getRecCoRegNoType		());
				pstmt.setString	(95,	bean.getRecCoTaxRegNo		());
				pstmt.setString	(96,	bean.getBrokerMemId			());
				pstmt.setString	(97,	bean.getBrokerMemDeptName	());
				pstmt.setString	(98,	bean.getBrokerMemName		());
				pstmt.setString	(99,	bean.getBrokerEMail			());
				pstmt.setString (100,	bean.getBrokerTel			());
				pstmt.setString	(101,	bean.getBrokerCoRegNo		());
				pstmt.setString	(102,	bean.getBrokerCoTaxRegNo	());
				pstmt.setString	(103,	bean.getBrokerCoName		());
				pstmt.setString	(104,	bean.getBrokerCeo			());
				pstmt.setString	(105,	bean.getBrokerAddr			());
				pstmt.setString	(106,	bean.getBrokerBizType		());
				pstmt.setString	(107,	bean.getBrokerBizSub		());
				pstmt.setString	(108,	bean.getSms					());
				pstmt.setString	(109,	bean.getNts_IssueId			());

				pstmt.executeUpdate();
				pstmt.close();


				//tax_item
				pstmt_s2 = conn.prepareStatement(query3);
				rs2 = pstmt_s2.executeQuery();
    	
				while(rs2.next())
				{		
					bean.setItemSeqId			(rs2.getString("ITEM_ID")+""+rs2.getString("ITEM_SEQ"));
					bean.setResSeq				(resseq);
					bean.setItemDate1			(rs2.getString("ITEM_DT1"));
					bean.setItemName1			(rs2.getString("ITEM_G")+" "+rs2.getString("ITEM_CAR_NO")+" "+rs2.getString("ITEM_CAR_NM"));
					bean.setItemType1			("");
					bean.setItemQyt1			(1);
					bean.setItemPrice1			(0);
					bean.setItemSupPrice1		(rs2.getInt("ITEM_SUPPLY"));
					bean.setItemTax1			(rs2.getInt("ITEM_VALUE"));
					bean.setItemRemarks1		(rs2.getString("ITEM_DT1")+"~"+rs2.getString("ITEM_DT2"));

					pstmt2 = conn.prepareStatement(query4);	
					pstmt2.setString	(1,		bean.getItemSeqId			());
					pstmt2.setString	(2,		bean.getResSeq				());
					pstmt2.setString	(3,		bean.getItemDate1			());
					pstmt2.setString	(4,		bean.getItemName1			());
					pstmt2.setString	(5,		bean.getItemType1			());
					pstmt2.setInt   	(6,		bean.getItemQyt1			());
					pstmt2.setInt    (7,		bean.getItemPrice1			());
					pstmt2.setInt   	(8,		bean.getItemSupPrice1		());
					pstmt2.setInt   	(9,		bean.getItemTax1			());
					pstmt2.setString	(10,	bean.getItemRemarks1		());
					pstmt2.executeUpdate();
					pstmt2.close();

				}
				rs2.close();
				pstmt_s2.close();
			}
			
			conn.commit();
			
			updateTaxEBillSeq(bean.getTaxSNum1(), bean.getResSeq());

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertSaleEBillCase]\n"+e);
			System.out.println("[IssueDatabase:insertSaleEBillCase]\n"+query);
			System.out.println("[IssueDatabase:insertSaleEBillCase]\n"+resseq);
			System.out.println("[IssueDatabase:insertSaleEBillCase]\n"+tax_no);
			System.out.println("[IssueDatabase:insertSaleEBillCase]\n"+br_ent_no);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( rs != null )		rs.close();
				if ( rs2 != null )		rs2.close();
				if ( pstmt_s != null )	pstmt_s.close();
				if ( pstmt_s2 != null )	pstmt_s2.close();
				if ( pstmt != null )	pstmt.close();
				if ( pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//전자세금계산서 한건 등록
	public boolean insertSaleEBillCase2(String resseq, String tax_no, String br_ent_no, String tax_bigo_t)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt_s = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt_s2 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		SaleEBillBean bean = new SaleEBillBean();
		String query = ""; 
		String query2 = ""; 
		String query3 = ""; 
		String query4 = "";

		query = " select"+
				" a.tax_no, a.tax_dt, a.tax_bigo, a.tax_supply, a.tax_value,"+
				" substr(a.tax_dt,5,4) tax_mmdd, a.tax_g, d.client_st,"+
				" c.user_nm, 'tax@amazoncar.co.kr' user_email, '02-392-4243' user_h_tel,"+
				" b.br_ent_no, b.br_nm, b.br_own_nm, b.br_addr, b.br_sta, b.br_item,"+
				" decode(a.gubun,'13',f.user_m_tel,decode(a.tax_type,'2',e.tel,nvl(d.o_tel,nvl(d.h_tel,d.m_tel)))) tel,"+
				" decode(a.gubun,'13',  TEXT_DECRYPT(f.user_ssn, 'pw' )  ,decode(a.tax_type,'2',decode(TEXT_DECRYPT(e.enp_no, 'pw' ) ,'',decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ) ,d.ENP_NO), TEXT_DECRYPT(e.enp_no, 'pw' )),decode(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw' ),d.ENP_NO))) enp_no,"+
				" substr(decode(a.gubun,'13',f.user_nm,decode(a.tax_type,'2',decode(e.r_site,'',d.firm_nm,e.r_site),d.firm_nm)),1,20) firm_nm,"+
				" decode(a.gubun,'13','',decode(a.tax_type,'2',decode(e.site_jang,'',decode(d.client_st,'2','',d.client_nm),e.site_jang),decode(d.client_st,'2','',d.client_nm))) client_nm,"+
				" decode(a.gubun,'13',f.addr,decode(a.tax_type,'2',decode(e.addr,'',d.o_addr,e.addr),d.o_addr)) addr,"+
				" substr(decode(a.gubun,'13','',decode(a.tax_type,'2',e.bus_cdt,d.BUS_CDT)),1,20) bus_cdt,"+
				" substr(decode(a.gubun,'13','',decode(a.tax_type,'2',e.bus_itm,d.bus_itm)),1,15) bus_itm,"+
				" decode(a.gubun,'13','',decode(a.tax_type,'2',decode(e.agnt_nm,'',d.con_agnt_nm,e.agnt_nm),d.con_agnt_nm)) agnt_nm,"+
				" decode(a.gubun,'13',f.user_email,decode(a.tax_type,'2',decode(e.agnt_email,'',d.con_agnt_email,e.agnt_email),d.con_agnt_email)) agnt_email, "+
				" a.gubun, nvl(a.doctype,'') doctype "+
				" from tax a, branch b, users c, client d, client_site e, users f"+
				" where"+
				" a.tax_no='"+tax_no+"'"+
				" and a.branch_g=b.br_id"+
				" and a.reg_id=c.user_id"+
				" and a.client_id=d.client_id"+
				" and a.client_id=e.client_id(+) and a.seq=e.seq(+) and a.client_id=f.user_id(+)";

		query2 = " INSERT INTO saleebill"+
				" ( resseq, doctype, doccode, customs, refcoregno, refconame, taxsnum1, taxsnum2, taxsnum3, docattr,"+//1
				"   origin, pubdate, systemcode, pubtype, pubform, bookno1, bookno2, remarks, memid, memname,"+//2
				"   email, tel, coregno, coname, coceo, coaddr, cobiztype, cobizsub, vidcheck, recmemid,"+//3
				"   recmemname, recemail, rectel, reccoregno, recconame, reccoceo, reccoaddr, reccobiztype, reccobizsub, supprice,"+//4
				"   tax, cash, cheque, bill, outstand, itemdate1, itemname1, itemtype1, itemqyt1, itemprice1,"+//5
				"	itemsupprice1, itemtax1, itemremarks1, itemdate2, itemname2, itemtype2, itemqyt2, itemprice2, itemsupprice2, itemtax2,"+//6
				"	itemremarks2, itemdate3, itemname3, itemtype3, itemqyt3, itemprice3, itemsupprice3, itemtax3, itemremarks3, itemdate4,"+//7
				"	itemname4, itemtype4, itemqyt4, itemprice4, itemsupprice4, itemtax4, itemremarks4, pubkind, loadstatus, pubcode,"+//8
				"   pubstatus,"+
				"	EBILLKIND, TAXSNUM, REMARKS2, REMARKS3, MEMDEPTNAME, COTAXREGNO, RECMEMDEPTNAME, "+//1
				"	RECMEMID2, RECMEMDEPTNAME2, RECMEMNAME2, RECEMAIL2, RECTEL2, "+//2
				"	RECCOREGNOTYPE, RECCOTAXREGNO, BROKERMEMID, BROKERMEMDEPTNAME, BROKERMEMNAME, "+//3
				"	BROKEREMAIL, BROKERTEL, BROKERCOREGNO, BROKERCOTAXREGNO, BROKERCONAME, BROKERCOCEO, "+//4
				"	BROKERCOADDR, BROKERCOBIZTYPE, BROKERCOBIZSUB, SMS, NTS_ISSUEID "+//5
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, "+
				"	?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ? "+
				"	)";

		query3 = " select * from tax_item_list where item_id in (select item_id from tax where tax_no='"+tax_no+"')";

		query4 = " INSERT INTO itemlist"+
				" ( seqid, detailseqid, itemdate, itemname, itemtype, itemqty, itemprice, itemsupprice, itemtax, itemremarks"+
				" ) VALUES"+
				" ( ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?"+
				"   )";


		try 
		{
			conn.setAutoCommit(false);
			
			pstmt_s = conn.prepareStatement(query);
	    	rs = pstmt_s.executeQuery();
    	
			if(rs.next())
			{		
				bean.setResSeq(resseq);
				bean.setDocType				(rs.getString("DOCTYPE"));
				bean.setDocCode				("02");
				bean.setCustoms				("T");
				if(rs.getString("BR_ENT_NO").equals(br_ent_no)){
					bean.setRefCoRegNo		("");
					bean.setRefCoName		("");
				}else{
					bean.setRefCoRegNo		("");
					bean.setRefCoName		("");
				}
				bean.setTaxSNum1			(rs.getString("TAX_NO"));
				bean.setTaxSNum2			("");
				bean.setTaxSNum3			("");
				bean.setDocAttr				("N");
				bean.setOrigin				("");
				bean.setPubDate				(rs.getString("TAX_DT"));
				bean.setSystemCode			("KF");
				bean.setPubType				("S");
				bean.setPubForm				("D");
				bean.setBookNo1				("");
				bean.setBookNo2				("");
				bean.setMemID				("amazoncar11");
				bean.setMemName				(rs.getString("USER_NM"));
				bean.setEmail				(rs.getString("USER_EMAIL"));
				bean.setTel					(rs.getString("USER_H_TEL"));
				bean.setCoRegNo				(rs.getString("BR_ENT_NO"));
				bean.setCoName				("(주)아마존카");
				bean.setCoCeo				(rs.getString("BR_OWN_NM"));
				bean.setCoAddr				(rs.getString("BR_ADDR"));
				bean.setCoBizType			(rs.getString("BR_STA"));
				bean.setCoBizSub			(rs.getString("BR_ITEM"));
				bean.setVidCheck			("");
				bean.setRecMemID			("");
				bean.setRecMemName			(rs.getString("AGNT_NM"));
				bean.setRecEMail			(rs.getString("AGNT_EMAIL"));
				bean.setRecTel				(rs.getString("TEL"));
				if(rs.getString("ENP_NO").length() == 13){
					bean.setRecCoRegNo		(rs.getString("ENP_NO"));
				}else{
					bean.setRecCoRegNo		(rs.getString("ENP_NO"));
				}
				bean.setRecCoName			(rs.getString("FIRM_NM"));
				bean.setRecCoCeo			(rs.getString("CLIENT_NM"));
				bean.setRecCoAddr			(rs.getString("ADDR"));
				bean.setRecCoBizType		(rs.getString("BUS_CDT"));
				bean.setRecCoBizSub			(rs.getString("BUS_ITM"));
				bean.setSupPrice			(rs.getInt("TAX_SUPPLY"));
				bean.setTax					(rs.getInt("TAX_VALUE"));
				bean.setCash				(0);
				bean.setCheque				(0);
				bean.setBill				(0);
				bean.setOutstand			(0);
				bean.setItemDate1			("");
				bean.setItemName1			("");
				bean.setItemType1			("");
				bean.setItemQyt1			(0);
				bean.setItemPrice1			(0);
				bean.setItemSupPrice1		(0);
				bean.setItemTax1			(0);
				bean.setItemRemarks1		("");
				bean.setItemDate2			("");
				bean.setItemName2			("");
				bean.setItemType2			("");
				bean.setItemQyt2			(0);
				bean.setItemPrice2			(0);
				bean.setItemSupPrice2		(0);
				bean.setItemTax2			(0);
				bean.setItemRemarks2		("");
				bean.setItemDate3			("");
				bean.setItemName3			("");
				bean.setItemType3			("");
				bean.setItemQyt3			(0);
				bean.setItemPrice3			(0);
				bean.setItemSupPrice3		(0);
				bean.setItemTax3			(0);
				bean.setItemRemarks3		("");
				bean.setItemDate4			("");
				bean.setItemName4			("");
				bean.setItemType4			("");
				bean.setItemQyt4			(0);
				bean.setItemPrice4			(0);
				bean.setItemSupPrice4		(0);
				bean.setItemTax4			(0);
				bean.setItemRemarks4		("");
				bean.setPubKind				("N");
				bean.setLoadStatus			(0);
				bean.setPubCode				("");
				bean.setPubStatus			("");
				bean.setGubun				(rs.getString("GUBUN"));  //해지정산 후 세금계산서는 15
				bean.setEBillkind			(1);
				bean.setTaxSNum				(rs.getString("TAX_NO"));
				bean.setRemarks2			("");
				bean.setRemarks3			("");
				bean.setMemDeptName			("총무팀");
				bean.setCoTaxRegNo			(rs.getString("TAXREGNO"));
				bean.setRecMemDeptName		("");
				bean.setRecMemId2			("");
				bean.setRecMemDeptName2		("");
				bean.setRecMemName2			("");
				bean.setRecEMail2			("");
				bean.setRecTel2				("");
				bean.setRecCoRegNoType		("01");
				if(rs.getString("ENP_NO").length() == 13){
					bean.setRecCoRegNoType		("02");
				}
				bean.setRecCoTaxRegNo		("");
				bean.setBrokerMemId			("");
				bean.setBrokerMemDeptName	("");
				bean.setBrokerMemName		("");
				bean.setBrokerEMail			("");
				bean.setBrokerTel			("");
				bean.setBrokerCoRegNo		("");
				bean.setBrokerCoTaxRegNo	("");
				bean.setBrokerCoName		("");
				bean.setBrokerCeo			("");
				bean.setBrokerAddr			("");
				bean.setBrokerBizType		("");
				bean.setBrokerBizSub		("");
				bean.setSms					("");
				bean.setNts_IssueId			("");
			}
			rs.close();
			pstmt_s.close();
			
			
			pstmt = conn.prepareStatement(query2);

			pstmt.setString	(1,		bean.getResSeq       ());
			pstmt.setString	(2,		bean.getDocType      ());
			pstmt.setString	(3,		bean.getDocCode      ());
			pstmt.setString	(4,		bean.getCustoms      ());
			pstmt.setString	(5,		bean.getRefCoRegNo   ());
			pstmt.setString	(6,		bean.getRefCoName    ());
			pstmt.setString	(7,		bean.getTaxSNum1     ());
			pstmt.setString	(8,		bean.getTaxSNum2     ());
			pstmt.setString (9,		bean.getTaxSNum3     ());
			pstmt.setString (10,	bean.getDocAttr      ());
			pstmt.setString	(11,	bean.getOrigin       ());
			pstmt.setString	(12,	bean.getPubDate      ());
			pstmt.setString	(13,	bean.getSystemCode   ());
			pstmt.setString	(14,	bean.getPubType      ());
			pstmt.setString	(15,	bean.getPubForm      ());
			pstmt.setString	(16,	bean.getBookNo1      ());
			pstmt.setString	(17,	bean.getBookNo2      ());
			pstmt.setString	(18,	tax_bigo_t			   );
			pstmt.setString	(19,	bean.getMemID        ());
			pstmt.setString (20,	bean.getMemName      ());
			pstmt.setString	(21,	bean.getEmail        ());
			pstmt.setString	(22,	bean.getTel          ());
			pstmt.setString	(23,	bean.getCoRegNo      ());
			pstmt.setString	(24,	bean.getCoName       ());
			pstmt.setString	(25,	bean.getCoCeo        ());
			pstmt.setString	(26,	bean.getCoAddr       ());
			pstmt.setString	(27,	bean.getCoBizType    ());
			pstmt.setString	(28,	bean.getCoBizSub     ());
			pstmt.setString	(29,	bean.getVidCheck     ());
			pstmt.setString (30,	bean.getRecMemID     ());
			pstmt.setString	(31,	bean.getRecMemName   ());  //공급받는자 e-mail 계산서
			
			if( bean.getGubun().equals("15") ){
				pstmt.setString	(32,	bean.getRecEMail     ());  //공급받는자 e-mail			
			} else {				
				pstmt.setString	(32,	"");  //공급받는자 e-mail
			}
			pstmt.setString	(33,	bean.getRecTel       ());
			pstmt.setString	(34,	bean.getRecCoRegNo   ());
			pstmt.setString	(35,	bean.getRecCoName    ());
			pstmt.setString	(36,	bean.getRecCoCeo     ());
			pstmt.setString	(37,	bean.getRecCoAddr    ());
			pstmt.setString	(38,	bean.getRecCoBizType ());
			pstmt.setString	(39,	bean.getRecCoBizSub  ());
			pstmt.setInt    (40,	bean.getSupPrice     ());
			pstmt.setInt   	(41,	bean.getTax          ());
			pstmt.setInt   	(42,	bean.getCash         ());
			pstmt.setInt   	(43,	bean.getCheque       ());
			pstmt.setInt   	(44,	bean.getBill         ());
			pstmt.setInt   	(45,	bean.getOutstand     ());
			pstmt.setString	(46,	bean.getItemDate1    ());
			pstmt.setString	(47,	bean.getItemName1    ());
			pstmt.setString	(48,	bean.getItemType1    ());
			pstmt.setInt   	(49,	bean.getItemQyt1     ());
			pstmt.setInt    (50,	bean.getItemPrice1   ());
			pstmt.setInt   	(51,	bean.getItemSupPrice1());
			pstmt.setInt   	(52,	bean.getItemTax1     ());
			pstmt.setString	(53,	bean.getItemRemarks1 ());
			pstmt.setString	(54,	bean.getItemDate2    ());
			pstmt.setString	(55,	bean.getItemName2    ());
			pstmt.setString	(56,	bean.getItemType2    ());
			pstmt.setInt   	(57,	bean.getItemQyt2     ());
			pstmt.setInt   	(58,	bean.getItemPrice2   ());
			pstmt.setInt   	(59,	bean.getItemSupPrice2());
			pstmt.setInt    (60,	bean.getItemTax2     ());
			pstmt.setString	(61,	bean.getItemRemarks2 ());
			pstmt.setString	(62,	bean.getItemDate3    ());
			pstmt.setString	(63,	bean.getItemName3    ());
			pstmt.setString	(64,	bean.getItemType3    ());
			pstmt.setInt   	(65,	bean.getItemQyt3     ());
			pstmt.setInt   	(66,	bean.getItemPrice3   ());
			pstmt.setInt   	(67,	bean.getItemSupPrice3());
			pstmt.setInt   	(68,	bean.getItemTax3     ());
			pstmt.setString	(69,	bean.getItemRemarks3 ());
			pstmt.setString (70,	bean.getItemDate4    ());
			pstmt.setString	(71,	bean.getItemName4    ());
			pstmt.setString	(72,	bean.getItemType4    ());
			pstmt.setInt   	(73,	bean.getItemQyt4     ());
			pstmt.setInt   	(74,	bean.getItemPrice4   ());
			pstmt.setInt   	(75,	bean.getItemSupPrice4());
			pstmt.setInt   	(76,	bean.getItemTax4     ());
			pstmt.setString	(77,	bean.getItemRemarks4 ());
			pstmt.setString	(78,	bean.getPubKind      ());
			pstmt.setInt   	(79,	bean.getLoadStatus   ());
			pstmt.setString (80,	bean.getPubCode      ());
			pstmt.setString	(81,	bean.getPubStatus    ());
			pstmt.setInt   	(82,	bean.getEBillkind			());
			pstmt.setString (83,	bean.getTaxSNum				());
			pstmt.setString	(84,	bean.getRemarks2			());
			pstmt.setString	(85,	bean.getRemarks3			());
			pstmt.setString	(86,	bean.getMemDeptName			());
			pstmt.setString	(87,	bean.getCoTaxRegNo			());
			pstmt.setString	(88,	bean.getRecMemDeptName		());
			pstmt.setString	(89,	bean.getRecMemId2			());
			pstmt.setString (90,	bean.getRecMemDeptName2		());
			pstmt.setString	(91,	bean.getRecMemName2			());
			pstmt.setString	(92,	bean.getRecEMail2			());
			pstmt.setString	(93,	bean.getRecTel2				());
			pstmt.setString	(94,	bean.getRecCoRegNoType		());
			pstmt.setString	(95,	bean.getRecCoTaxRegNo		());
			pstmt.setString	(96,	bean.getBrokerMemId			());
			pstmt.setString	(97,	bean.getBrokerMemDeptName	());
			pstmt.setString	(98,	bean.getBrokerMemName		());
			pstmt.setString	(99,	bean.getBrokerEMail			());
			pstmt.setString (100,	bean.getBrokerTel			());
			pstmt.setString	(101,	bean.getBrokerCoRegNo		());
			pstmt.setString	(102,	bean.getBrokerCoTaxRegNo	());
			pstmt.setString	(103,	bean.getBrokerCoName		());
			pstmt.setString	(104,	bean.getBrokerCeo			());
			pstmt.setString	(105,	bean.getBrokerAddr			());
			pstmt.setString	(106,	bean.getBrokerBizType		());
			pstmt.setString	(107,	bean.getBrokerBizSub		());
			pstmt.setString	(108,	bean.getSms					());
			pstmt.setString	(109,	bean.getNts_IssueId			());

			pstmt.executeUpdate();
			pstmt.close();
			
			//tax_item
			pstmt_s2 = conn.prepareStatement(query3);
	    	rs2 = pstmt_s2.executeQuery();
    	
			while(rs2.next())
			{		
				bean.setItemSeqId			(rs2.getString("ITEM_ID")+""+rs2.getString("ITEM_SEQ"));
				bean.setResSeq				(resseq);
				bean.setItemDate1			(rs2.getString("ITEM_DT1"));
				bean.setItemName1			(rs2.getString("ITEM_G")+" "+rs2.getString("ITEM_CAR_NO")+" "+rs2.getString("ITEM_CAR_NM"));
				bean.setItemType1			("");
				bean.setItemQyt1			(1);
				bean.setItemPrice1			(0);
				bean.setItemSupPrice1		(rs2.getInt("ITEM_SUPPLY"));
				bean.setItemTax1			(rs2.getInt("ITEM_VALUE"));
				bean.setItemRemarks1		(rs2.getString("ITEM_DT1")+"~"+rs2.getString("ITEM_DT2"));

				pstmt2 = conn.prepareStatement(query4);
				pstmt2.setString	(1,		bean.getItemSeqId			());
				pstmt2.setString	(2,		bean.getResSeq				());
				pstmt2.setString	(3,		bean.getItemDate1			());
				pstmt2.setString	(4,		bean.getItemName1			());
				pstmt2.setString	(5,		bean.getItemType1			());
				pstmt2.setInt   	(6,		bean.getItemQyt1			());
				pstmt2.setInt		(7,		bean.getItemPrice1			());
				pstmt2.setInt   	(8,		bean.getItemSupPrice1		());
				pstmt2.setInt   	(9,		bean.getItemTax1			());
				pstmt2.setString	(10,	bean.getItemRemarks1		());
				pstmt2.executeUpdate();
				pstmt2.close();

			}
			rs2.close();
			pstmt_s2.close();

			conn.commit();
			
			updateTaxEBillSeq(bean.getTaxSNum1(), bean.getResSeq());

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertSaleEBillCase2]\n"+e);
			System.out.println("[IssueDatabase:insertSaleEBillCase2]\n"+query);
			System.out.println("[IssueDatabase:insertSaleEBillCase2]\n"+resseq);
			System.out.println("[IssueDatabase:insertSaleEBillCase2]\n"+tax_no);
			System.out.println("[IssueDatabase:insertSaleEBillCase2]\n"+br_ent_no);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( rs != null )		rs.close();
				if ( pstmt_s != null )	pstmt_s.close();
				if ( pstmt != null )	pstmt.close();
				if ( rs2 != null )		rs2.close();
				if ( pstmt_s2 != null )	pstmt_s2.close();
				if ( pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	//세금계산서 트러스빌 생성 등록
	public boolean updateTaxEBillSeq(String tax_no, String ResSeq)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE tax SET"+
				" resseq='"+ResSeq+"' "+
				" WHERE tax_no='"+tax_no+"'";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxEBillSeq]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//세금계산서 매출취소시 트러스빌 발급취소 준비 업데이트
	public boolean updateEBillTaxCancel(String tax_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE saleEBill SET"+
				" docattr='D', loadstatus=0"+
				" WHERE resseq=(select resseq from tax where tax_no='"+tax_no+"')";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateEBillTaxCancel]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//세금계산서 내용 수정시 트러스빌 취소후 재발급 준비 업데이트
	public boolean updateSaleEBillTaxUpdate(SaleEBillBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE saleEBill SET"+
				"		docattr			='U',	"+
				"       loadstatus      =0,		"+
				"		pubdate			=replace(?, '-', ''),"+
				"		remarks			=?,		"+
				"		refcoregno		=?,		"+
				"		refconame		=?,		"+
				"		coregno			=?,		"+
				"		coname			=?,		"+
				"		coceo			=?,		"+
				"		coaddr			=?,		"+
				"		cobiztype		=?,		"+
				"		cobizsub		=?,		"+
				"		supprice		=?,		"+
				"		tax				=?,		"+
				"		recmemname		=substrb(?,1,30),		"+
				"		rectel			=?,						"+
				"		reccoregno		=replace(?, '-', ''),	"+
				"		recconame		=substrb(?,1,70),		"+
				"		reccoceo		=substrb(?,1,30),		"+
				"		reccoaddr		=substrb(?,1,150),		"+
				"		reccobiztype	=substrb(?,1,40),		"+
				"		reccobizsub		=substrb(?,1,40),		"+
				"       cotaxregno      =?,		"+
				"       reccotaxregno   =?,		"+
				"       reccoregnotype  =?,		"+
				"       pubform		    =?		"+


				" WHERE resseq=? and taxsnum1=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getPubDate			());
			pstmt.setString	(2,		bean.getRemarks			());
			pstmt.setString	(3,		bean.getRefCoRegNo		());
			pstmt.setString	(4,		bean.getRefCoName		());
			pstmt.setString	(5,		bean.getCoRegNo			());
			pstmt.setString	(6,		bean.getCoName			());
			pstmt.setString	(7,		bean.getCoCeo			());
			pstmt.setString	(8,		bean.getCoAddr			());
			pstmt.setString	(9,		bean.getCoBizType		());
			pstmt.setString	(10,	bean.getCoBizSub		());
			pstmt.setInt    (11,	bean.getSupPrice		());
			pstmt.setInt   	(12,	bean.getTax				());
			pstmt.setString	(13,	bean.getRecMemName		());
			pstmt.setString	(14,	bean.getRecTel			());
			pstmt.setString	(15,	bean.getRecCoRegNo		());
			pstmt.setString	(16,	bean.getRecCoName		());
			pstmt.setString	(17,	bean.getRecCoCeo		());
			pstmt.setString	(18,	bean.getRecCoAddr		());
			pstmt.setString	(19,	bean.getRecCoBizType	());
			pstmt.setString	(20,	bean.getRecCoBizSub		());
			pstmt.setString	(21,	bean.getCoTaxRegNo		());
			pstmt.setString	(22,	bean.getRecCoTaxRegNo	());
			pstmt.setString	(23,	bean.getRecCoRegNoType  ());
			pstmt.setString	(24,	bean.getPubForm			());
			pstmt.setString	(25,	bean.getResSeq			());
			pstmt.setString	(26,	bean.getTaxSNum1		());

			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateSaleEBillTaxUpdate]\n"+e);

			System.out.println("[bean.getPubDate		()]\n"+bean.getPubDate			());
			System.out.println("[bean.getRemarks		()]\n"+bean.getRemarks			());
			System.out.println("[bean.getRefCoRegNo		()]\n"+bean.getRefCoRegNo		());
			System.out.println("[bean.getRefCoName		()]\n"+bean.getRefCoName		());
			System.out.println("[bean.getCoRegNo		()]\n"+bean.getCoRegNo			());
			System.out.println("[bean.getCoName			()]\n"+bean.getCoName			());
			System.out.println("[bean.getCoCeo			()]\n"+bean.getCoCeo			());
			System.out.println("[bean.getCoAddr			()]\n"+bean.getCoAddr			());
			System.out.println("[bean.getCoBizType		()]\n"+bean.getCoBizType		());
			System.out.println("[bean.getCoBizSub		()]\n"+bean.getCoBizSub			());
			System.out.println("[bean.getSupPrice		()]\n"+bean.getSupPrice			());
			System.out.println("[bean.getTax			()]\n"+bean.getTax				());
			System.out.println("[bean.getRecMemName		()]\n"+bean.getRecMemName		());
			System.out.println("[bean.getRecTel			()]\n"+bean.getRecTel			());
			System.out.println("[bean.getRecCoRegNo		()]\n"+bean.getRecCoRegNo		());
			System.out.println("[bean.getRecCoName		()]\n"+bean.getRecCoName		());
			System.out.println("[bean.getRecCoCeo		()]\n"+bean.getRecCoCeo			());
			System.out.println("[bean.getRecCoAddr		()]\n"+bean.getRecCoAddr		());
			System.out.println("[bean.getRecCoBizType	()]\n"+bean.getRecCoBizType		());
			System.out.println("[bean.getRecCoBizSub	()]\n"+bean.getRecCoBizSub		());
			System.out.println("[bean.getCoTaxRegNo		()]\n"+bean.getCoTaxRegNo		());
			System.out.println("[bean.getRecCoTaxRegNo	()]\n"+bean.getRecCoTaxRegNo	());
			System.out.println("[bean.getRecCoRegNoType ()]\n"+bean.getRecCoRegNoType	());
			System.out.println("[bean.getPubForm		()]\n"+bean.getPubForm			());
			System.out.println("[bean.getResSeq			()]\n"+bean.getResSeq			());
			System.out.println("[bean.getTaxSNum1		()]\n"+bean.getTaxSNum1			());

			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//인포메일러 d-mail 발송------------------------------------------------------------------------------------------------

	/**
	 *	세금계산서 조회-
	 */	
	public Vector getTaxMailList(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select"+
						" a.con_agnt_email email,"+
						" decode(a.seq,'',b.firm_nm,decode(d.enp_no,'',b.firm_nm||' ')||d.r_site) name,"+
						" substr(decode(a.seq,'',b.firm_nm,decode(d.enp_no,'',b.firm_nm||' ')||d.r_site),1,15) name2,"+
						" nvl(a.con_agnt_m_tel,b.con_agnt_m_tel) m_tel,"+
						" nvl(a.con_agnt_nm,   b.con_agnt_nm)    agnt_nm,"+
						" a.client_id, a.seq,"+
						" a.reg_dt, a.tax_year, a.tax_mon, a.tax_cnt, to_char(sysdate,'YYYY-MM-DD') write_dt,"+
						" c.user_nm, c.user_h_tel,"+
						" nvl(a.con_agnt_nm,b.con_agnt_nm)||'님 '||replace(a.con_agnt_email,' ','')||'으로 '||a.tax_mon||'월 세금계산서 발행-아마존카' as msg "+ 
						" from"+
						" ("+
						" 	select a.client_id, a.seq, a.reg_id, "+
						" 	decode(a.reg_dt, '', '', substr(a.reg_dt, 1, 4) || '-' || substr(a.reg_dt, 5, 2) || '-'||substr(a.reg_dt, 7, 2)) reg_dt,"+
						" 	min(substr(a.tax_dt,1,4)) tax_year, min(substr(a.tax_dt,5,2)) tax_mon, count(a.tax_no) tax_cnt,"+
						"	min(a.con_agnt_nm) con_agnt_nm, min(a.con_agnt_email) con_agnt_email, min(a.con_agnt_m_tel) con_agnt_m_tel"+
						" 	from tax a, (select item_id from tax_item_list where reg_code='"+reg_code+"' group by item_id) b"+
						" 	where a.item_id=b.item_id and a.tax_st<>'C' and a.resseq is not null"+
						" 	group by a.client_id, a.seq, a.reg_dt, a.reg_id"+
						" ) a, client b, users c, client_site d"+
						" where a.client_id=b.client_id"+
						" and b.etax_not_cau is null and a.con_agnt_email is not null and a.con_agnt_email like '%@%' "+
						" and a.reg_id=c.user_id"+
						" and a.client_id=d.client_id(+) and a.seq=d.seq(+)";

		String query2 = " select email,name,name2,m_tel,agnt_nm,client_id,seq,reg_dt,tax_year,tax_mon,tax_cnt,write_dt,user_nm,user_h_tel,msg"+
						" from ("+query+")";


		try {
				pstmt = conn.prepareStatement(query2);
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
			System.out.println("[IssueDatabase:getTaxMailList]\n"+e);
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
	 *	세금계산서 조회-
	 */	
	public Hashtable getTaxMailCase(String gubun, String reg_code, String tax_no, String client_id, String site_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		//이메일폼
		String query1 =  " select "+
						" a.con_agnt_email email,"+
						" decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site) name,"+
						" substr(decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site),1,15) name2,"+
						" a.con_agnt_m_tel m_tel,"+
						" a.con_agnt_nm agnt_nm,"+
						" a.client_id, a.seq,"+
						" a.reg_dt, a.tax_year, a.tax_mon, a.tax_cnt, to_char(sysdate,'YYYY-MM-DD') write_dt,"+
						" c.user_nm, nvl(c.hot_tel,c.user_h_tel) as user_h_tel"+
						" from"+
						" ("+
						" 	select a.client_id, a.seq, a.reg_id, "+
						" 	decode(a.reg_dt, '', '', substr(a.reg_dt, 1, 4) || '-' || substr(a.reg_dt, 5, 2) || '-'||substr(a.reg_dt, 7, 2)) reg_dt,"+
						" 	min(substr(a.tax_dt,1,4)) tax_year, min(substr(a.tax_dt,5,2)) tax_mon, count(a.tax_no) tax_cnt,"+
						"	min(a.con_agnt_nm) con_agnt_nm, min(a.con_agnt_email) con_agnt_email, min(a.con_agnt_m_tel) con_agnt_m_tel"+
						" 	from tax a, (select item_id from tax_item_list where reg_code='"+reg_code+"' group by item_id) b"+
						" 	where a.client_id='"+client_id+"' and a.item_id=b.item_id and a.tax_st<>'C'";// and a.resseq is not null

		if(!site_id.equals("")) query1 += " and a.seq='"+site_id+"'";
		else					query1 += " and a.seq is null";

		query1 += 		" 	group by  a.client_id, a.seq, a.reg_dt, a.reg_id"+
						" ) a, client b, users c, client_site d"+
						" where a.client_id=b.client_id"+
						" and a.reg_id=c.user_id"+
						" and a.client_id=d.client_id(+) and a.seq=d.seq(+)";


		//개별발송
		String query2 =  " select"+
						" a.con_agnt_email email,"+
						" decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site) name,"+
						" substr(decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site),1,15) name2,"+
						" a.con_agnt_m_tel m_tel,"+
						" a.con_agnt_nm agnt_nm,"+
						" a.client_id, a.seq,"+
						" a.reg_dt, a.tax_year, a.tax_mon, a.tax_cnt, to_char(sysdate,'YYYY-MM-DD') write_dt,"+
						" c.user_nm, nvl(c.hot_tel,c.user_h_tel) as user_h_tel"+
						" from"+
						" ("+
						" 	select a.client_id, a.seq, a.reg_id, "+
						" 	decode(a.reg_dt, '', '', substr(a.reg_dt, 1, 4) || '-' || substr(a.reg_dt, 5, 2) || '-'||substr(a.reg_dt, 7, 2)) reg_dt,"+
						" 	min(substr(a.tax_dt,1,4)) tax_year, min(substr(a.tax_dt,5,2)) tax_mon, count(a.tax_no) tax_cnt,"+
						"	min(a.con_agnt_nm) con_agnt_nm, min(a.con_agnt_email) con_agnt_email, min(a.con_agnt_m_tel) con_agnt_m_tel"+
						" 	from tax a"+
						" 	where a.tax_no='"+tax_no+"'"+
						" 	group by a.client_id, a.seq, a.reg_dt, a.reg_id"+
						" ) a, client b, users c, client_site d"+
						" where a.client_id=b.client_id"+
						" and a.reg_id=c.user_id"+
						" and a.client_id=d.client_id(+) and a.seq=d.seq(+)";


		String query3 = " select email,name,name2,m_tel,agnt_nm,client_id,seq,reg_dt,tax_year,tax_mon,tax_cnt,write_dt,user_nm,user_h_tel";

		if(gubun.equals("1"))		query3 += " from ("+query1+")";
		else if(gubun.equals("2"))	query3 += " from ("+query2+")";


		try {
				pstmt = conn.prepareStatement(query3);
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
			System.out.println("[IssueDatabase:getTaxMailCase]\n"+e);
			System.out.println("[IssueDatabase:getTaxMailCase]\n"+query3);
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
	
	//d-mail 발송 한건 등록
	public boolean insertDEmail(DmailBean bean, String sdate, String tdate)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO im_dmail_info_6"+
				" ( seqidx, subject, sql, reject_slist_idx, block_group_idx, mailfrom, mailto, replyto, errorsto, html,"+//1
				"   encoding, charset, sdate, tdate, duration_set, click_set, site_set, atc_set, gubun, rname,"+//2
				"   mtype, u_idx, g_idx, msgflag, content, qry "+//3
				" ) VALUES"+
				" ( IM_SEQ_DMAIL_INFO_6.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, to_char(sysdate"+sdate+",'YYYYMMDDhh24miss'), to_char(sysdate+7,'YYYYMMDDhh24miss'), ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ? "+
				" )";

		//sdate=to_char(sysdate+0.05,'YYYYMMDDhh24miss') => 현재시간으로 부터 1시간후에 발송시작
		//tdate=to_char(sysdate+6.05,'YYYYMMDDhh24miss') => sdate 포함 7일이 수신확인종료시간

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getSubject			()); 
			pstmt.setString	(2,		bean.getSql				()); 
			pstmt.setInt   	(3,		bean.getReject_slist_idx()); 
			pstmt.setInt   	(4,		bean.getBlock_group_idx	()); 
			pstmt.setString	(5,		bean.getMailfrom		()); 
			pstmt.setString (6,		bean.getMailto			()); 
			pstmt.setString (7,		bean.getReplyto			()); 
			pstmt.setString	(8,		bean.getErrosto			()); 
			pstmt.setInt   	(9,		bean.getHtml			()); 
			pstmt.setInt   	(10,	bean.getEncoding		()); 
			pstmt.setString	(11,	bean.getCharset			()); 
			pstmt.setInt   	(12,	bean.getDuration_set	()); 
			pstmt.setInt   	(13,	bean.getClick_set		()); 
			pstmt.setInt   	(14,	bean.getSite_set		()); 
			pstmt.setInt    (15,	bean.getAtc_set			()); 
			pstmt.setString	(16,	bean.getGubun			()); 
			pstmt.setString	(17,	bean.getRname			()); 
			pstmt.setInt   	(18,	bean.getMtype       	()); 
			pstmt.setInt   	(19,	bean.getU_idx       	()); 
			pstmt.setInt   	(20,	bean.getG_idx			()); 
			pstmt.setInt   	(21,	bean.getMsgflag     	()); 
			pstmt.setString	(22,	bean.getContent			()); 
			pstmt.setString	(23,	bean.getSql				()); 
			pstmt.executeUpdate();	
			pstmt.close();
			conn.commit();													 
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertDEmail]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//d-mail 발송일자 세금계산서에 등록
	public boolean updateDmailDt(String reg_code, String mail_dt)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE tax SET"+
				" mail_dt=to_char(sysdate"+mail_dt+",'YYYYMMDDhh24miss')"+
				" where tax_no in"+
				"	(select a.tax_no"+
				"		from tax a, client b, client_site c"+
				"		where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.seq=c.seq(+)"+
				"		and a.item_id in (select item_id from tax_item_list where reg_code='"+reg_code+"')"+
				"		and a.tax_st='O'"+
				"		and nvl(b.etax_yn,'Y')='Y' and decode(a.tax_type,'1',b.con_agnt_email,c.agnt_email) is not null"+
				"	)";

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateDmailDt]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//d-mail 발송일자 세금계산서에 등록
	public boolean updateDmailDtCase(String tax_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE tax SET"+
				" mail_dt=to_char(sysdate+0.05,'YYYYMMDDhh24miss')"+
				" where tax_no ='"+tax_no+"'";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateDmailDtCase]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//세금계산서 한건 수정
	public boolean updateTax(TaxBean bean, String mail_dt)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE tax SET"+
				"   con_agnt_nm=?, con_agnt_dept=?, con_agnt_title=?, con_agnt_email=?, con_agnt_m_tel=replace(?, '-', ''),"+
				"   mail_dt=to_char(sysdate"+mail_dt+",'YYYYMMDDhh24miss'),"+
				"   con_agnt_nm2=?, con_agnt_email2=?, con_agnt_m_tel2=replace(?, '-', '') "+
				" WHERE tax_no=?";

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getCon_agnt_nm		());
			pstmt.setString	(2,		bean.getCon_agnt_dept	());
			pstmt.setString	(3,		bean.getCon_agnt_title	());
			pstmt.setString	(4,		bean.getCon_agnt_email	());
			pstmt.setString	(5,		bean.getCon_agnt_m_tel	());
			pstmt.setString	(6,		bean.getCon_agnt_nm2	());
			pstmt.setString	(7,		bean.getCon_agnt_email2	());
			pstmt.setString	(8,		bean.getCon_agnt_m_tel2	());
			pstmt.setString	(9,		bean.getTax_no			());

			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTax]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//SMS 문자 발송------------------------------------------------------------------------------------------------

	/**
	 *	세금계산서 조회
	 */	
	public Vector getTaxSmsList(String query)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

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
			System.out.println("[IssueDatabase:getTaxSmsList]\n"+e);
			System.out.println("[IssueDatabase:getTaxSmsList]\n"+query);
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

	//문자보내기
	public void insertsendMail(String sendphone, String sendname, String destphone, String destname, String tax_mon, String rqdate)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";
		String query2 = "";
		String cmid = "";
		String msg = destname+"님 "+tax_mon+"월 세금계산서가 발행되었습니다.-아마존카-";

		int i_msglen = AddUtil.lengthb(msg);		
		String msg_type = "0";		
		//80이상이면 장문자
		if(i_msglen>80) msg_type = "5";
			
		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ? ) ";

		//rqdate=to_char(sysdate+0.1,'YYYYMMDDhh24miss') => 현재시간(세금계산서작성시간)으로 부터 2시간후에 발송시작

		try 
		{
			conn.setAutoCommit(false);
			
			if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid				);
				pstmt.setString(2, sendphone.trim()	);
				pstmt.setString(3, sendname.trim()	);
				pstmt.setString(4, destphone.trim()	);
				pstmt.setString(5, destname.trim()	);
				pstmt.setString(6, msg_type		    );	//타입
				pstmt.setString(7, "아마존카"       );	//제목
				pstmt.setString(8, msg              );
				pstmt.executeUpdate();	
				pstmt.close();

			}

			conn.commit();							 
		
	  	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail]\n"+e);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if ( rs != null )		rs.close();
				if ( pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
		}			
	}
	
	//문자보내기
	public void insertsendMail(String sendphone, String sendname, String destphone, String destname, String tax_mon, String rqdate, String msg)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";
		String query2 = "";
		String cmid = "";

		int i_msglen = AddUtil.lengthb(msg);		
		String msg_type = "0";		
		//80이상이면 장문자
		if(i_msglen>80) msg_type = "5";
			
		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ? ) ";

		try 
		{
			conn.setAutoCommit(false);
		
			if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid				);
				pstmt.setString(2, sendphone.trim()	);
				pstmt.setString(3, sendname.trim()	);
				pstmt.setString(4, destphone.trim()	);
				pstmt.setString(5, destname.trim()	);
				pstmt.setString(6, msg_type         );
				pstmt.setString(7, "아마존카"       );
				pstmt.setString(8, msg              );
				pstmt.executeUpdate();	
				pstmt.close();

			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail]\n"+e);
				System.out.println("[sendphone]\n"+sendphone);
				System.out.println("[sendname ]\n"+sendname );
				System.out.println("[destphone]\n"+destphone);
				System.out.println("[destname ]\n"+destname );
				System.out.println("[msg      ]\n"+msg      );
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if ( rs != null )		rs.close();
				if ( pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
		}			
	}
															 
	//문자보내기
	public void insertsendMail2(String sendphone, String sendname, String destphone, String destname, String tax_mon, String rqdate, String msg)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";
		String query2 = "";
		String cmid = "";

		int i_msglen = AddUtil.lengthb(msg);		
		String msg_type = "0";		
		//80이상이면 장문자
		if(i_msglen>80) msg_type = "5";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";
			
		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid "+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ? ) ";

		try 
		{
			conn.setAutoCommit(false);
		
			if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid				);
				pstmt.setString(2, sendphone.trim()	);
				pstmt.setString(3, sendname.trim()	);
				pstmt.setString(4, destphone.trim()	);
				pstmt.setString(5, destname.trim()	);
				pstmt.setString(6, msg_type         );
				pstmt.setString(7, "아마존카"       );
				pstmt.setString(8, msg              );
				pstmt.executeUpdate();	
				pstmt.close();

			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail2]\n"+e);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if ( rs != null )		rs.close();
				if ( pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
		}			
	}
	
	//계산서 중복발행 체크
	public int getTaxMakeCheck(String rent_l_cd, String fee_tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = "";

		query = " select count(0) from tax_item_list a, tax b"+
				" where a.rent_l_cd=? and a.tm=? and a.gubun='1' and b.tax_st='O'"+
				" and a.item_id=b.item_id";

		try {

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_l_cd);
			pstmt.setString(2, fee_tm);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxMakeCheck(String rent_l_cd, String fee_tm)]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}		
	}

	//계산서 중복발행 체크
	public int getTaxMakeCheck2(String rent_l_cd, String fee_tm, String rent_st, String rent_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = "";

		query = " select count(0) "+
				" from   tax_item_list a, tax b, tax_item c "+
				" where  a.item_id=b.item_id "+
				"        and a.rent_l_cd=? and a.tm=? and a.rent_st=? and a.rent_seq=? "+
				"        and a.gubun='1' and b.tax_st<>'C'  "+
				"        and a.item_id=c.item_id and nvl(c.use_yn,'Y')='Y' "+
				" group by a.rent_l_cd, a.tm, a.rent_st, a.rent_seq "+
				" having sum(a.item_value) > 0"+
				" ";

		try {

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_l_cd);
			pstmt.setString(2, fee_tm);
			pstmt.setString(3, rent_st);
			pstmt.setString(4, rent_seq);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxMakeCheck2]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}		
	}


	
	//계산서 중복발행 체크 -거래명세서 check
	public int getTaxMakeCheck3(String rent_l_cd, String fee_tm, String rent_st, String rent_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = "";

	    query = " select count(0)  "+
				" from   tax_item_list a, tax_item b, (select * from tax where tax_st='O' )c "+
				" where  a.item_id=b.item_id and b.item_id=c.item_id(+) "+
				"        and a.rent_l_cd=? and a.tm=? and a.rent_st=? and a.rent_seq=? "+
				"        and a.gubun='1' and nvl(b.use_yn,'Y')='Y' and c.item_id is null "+
				" ";
	
		try {

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_l_cd);
			pstmt.setString(2, fee_tm);
			pstmt.setString(3, rent_st);
			pstmt.setString(4, rent_seq);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxMakeCheck3]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}		
	}
	
	//거래명세서 대여료스케줄 미청구분 확인
	public int getTaxMakeCheck4(String item_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = "";

	    query = " select count(0)  "+
				" from   tax_item_list a, scd_fee b "+
				" where  a.item_id='"+item_id+"' and a.gubun='1' "+
				"        and a.rent_l_cd=b.rent_l_cd and a.tm=b.fee_tm and a.rent_st=b.rent_st and a.rent_seq=b.rent_seq "+
				"        and nvl(b.bill_yn,'Y')='N' "+
				" ";
	
		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxMakeCheck4]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}		
	}

	//12단계 : 원본계산서에 발행취소 사태 입력
	public boolean updateTaxApp(String tax_no, String app_yn)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update tax set app_yn=? where tax_no=?";

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		app_yn);
			pstmt.setString	(2,		tax_no);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateTaxApp]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//12단계 : 거래처에 미승인관리 상태 입력
	public boolean updateClientApp(String client_id, String app_yn)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " update client set app_yn=? where client_id=?";

		try 
		{
			conn.setAutoCommit(false);
					
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		app_yn);
			pstmt.setString	(2,		client_id);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateClientApp]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//전자입금표 한건 등록
	public boolean insertPayEBill(SaleEBillBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		String query = "";
		String query2 = "";
			
		query = " INSERT INTO payebill"+
				" ( seqid, doccode, refcoregno, refconame, taxsnum1, taxsnum2, taxsnum3, docattr, pubdate, systemcode, "+
				"   remarks, memid, memname, email, tel, coregno, coname, coceo, coaddr, cobiztype,"+
				"	cobizsub, recmemid, recmemname, recemail, rectel, reccoregno, recconame, reccoceo, reccoaddr, reccobiztype,"+
				"	reccobizsub, supprice, tax, pubkind, loadstatus, pubcode, pubstatus, refmemid, dockind, ebillkind, client_id  "+
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?,"+
				"   ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?,"+
				"   ?, ?, substrb(?, 1, 18), ?, ?, replace(?, '-', ''), substrb(?, 1, 38), substrb(?, 1, 18), substrb(?,1,158),?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,?  "+
				" )";

		query2 = " INSERT INTO payebilllist"+
				" ( seqid, payebillseqid, itemdate, itemname, itemsupprice, itemtax, protype, prono "+
				" ) VALUES"+
				" ( ?, ?, replace(?, '-', ''), ?, ?, ?, '1', 1 "+
				" )";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getSeqID	     ());
			pstmt.setString	(2,		bean.getDocCode      ());
			pstmt.setString	(3,		bean.getRefCoRegNo   ());
			pstmt.setString	(4,		bean.getRefCoName    ());
			pstmt.setString	(5,		bean.getTaxSNum1     ());
			pstmt.setString	(6,		bean.getTaxSNum2     ());
			pstmt.setString (7,		bean.getTaxSNum3     ());
			pstmt.setString (8,	    bean.getDocAttr      ());
			pstmt.setString	(9,	    bean.getPubDate      ());
			pstmt.setString	(10,	bean.getSystemCode   ());
			pstmt.setString	(11,	bean.getRemarks      ());
			pstmt.setString	(12,	bean.getMemID        ());
			pstmt.setString (13,	bean.getMemName      ());
			pstmt.setString	(14,	bean.getEmail        ());
			pstmt.setString	(15,	bean.getTel          ());
			pstmt.setString	(16,	bean.getCoRegNo      ());
			pstmt.setString	(17,	bean.getCoName       ());
			pstmt.setString	(18,	bean.getCoCeo        ());
			pstmt.setString	(19,	bean.getCoAddr       ());
			pstmt.setString	(20,	bean.getCoBizType    ());
			pstmt.setString	(21,	bean.getCoBizSub     ());
			pstmt.setString (22,	bean.getRecMemID     ());
			pstmt.setString	(23,	bean.getRecMemName   ());
			pstmt.setString	(24,	bean.getRecEMail     ());
			pstmt.setString	(25,	bean.getRecTel       ());
			pstmt.setString	(26,	bean.getRecCoRegNo   ());
			pstmt.setString	(27,	bean.getRecCoName    ());
			pstmt.setString	(28,	bean.getRecCoCeo     ());
			pstmt.setString	(29,	bean.getRecCoAddr    ());
			pstmt.setString	(30,	bean.getRecCoBizType ());
			pstmt.setString	(31,	bean.getRecCoBizSub  ());
			pstmt.setInt    (32,	bean.getSupPrice     ());
			pstmt.setInt   	(33,	bean.getTax          ());
			pstmt.setString	(34,	bean.getPubKind      ());
			pstmt.setInt   	(35,	bean.getLoadStatus   ());
			pstmt.setString (36,	bean.getPubCode      ());
			pstmt.setString	(37,	bean.getPubStatus    ());
			pstmt.setString	(38,	bean.getRefMemId     ());
			pstmt.setString	(39,	bean.getDocKind      ());
			pstmt.setString	(40,	bean.getS_EbillKind  ());
			pstmt.setString	(41,	bean.getClient_id  ());
			pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString	(1,		bean.getSeqID	     ());
			pstmt2.setString	(2,		bean.getSeqID	     ());
			pstmt2.setString	(3,	    bean.getPubDate      ());
			pstmt2.setString	(4,		bean.getItemName1    ());
			pstmt2.setInt    (5,		bean.getSupPrice     ());
			pstmt2.setInt   	(6,		bean.getTax          ());
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertPayEBill]\n"+e);

			System.out.println("[IssueDatabase:insertPayEBill]bean.getSeqID	       ()"+bean.getSeqID	     ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getDocCode      ()"+bean.getDocCode      ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRefCoRegNo   ()"+bean.getRefCoRegNo   ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRefCoName    ()"+bean.getRefCoName    ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getTaxSNum1     ()"+bean.getTaxSNum1     ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getTaxSNum2     ()"+bean.getTaxSNum2     ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getTaxSNum3     ()"+bean.getTaxSNum3     ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getDocAttr      ()"+bean.getDocAttr      ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getPubDate      ()"+bean.getPubDate      ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getSystemCode   ()"+bean.getSystemCode   ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRemarks      ()"+bean.getRemarks      ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getMemID        ()"+bean.getMemID        ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getMemName      ()"+bean.getMemName      ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getEmail        ()"+bean.getEmail        ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getTel          ()"+bean.getTel          ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getCoRegNo      ()"+bean.getCoRegNo      ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getCoName       ()"+bean.getCoName       ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getCoCeo        ()"+bean.getCoCeo        ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getCoAddr       ()"+bean.getCoAddr       ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getCoBizType    ()"+bean.getCoBizType    ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getCoBizSub     ()"+bean.getCoBizSub     ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRecMemID     ()"+bean.getRecMemID     ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRecMemName   ()"+bean.getRecMemName   ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRecEMail     ()"+bean.getRecEMail     ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRecTel       ()"+bean.getRecTel       ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRecCoRegNo   ()"+bean.getRecCoRegNo   ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRecCoName    ()"+bean.getRecCoName    ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRecCoCeo     ()"+bean.getRecCoCeo     ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRecCoAddr    ()"+bean.getRecCoAddr    ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRecCoBizType ()"+bean.getRecCoBizType ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getRecCoBizSub  ()"+bean.getRecCoBizSub  ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getSupPrice     ()"+bean.getSupPrice     ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getTax          ()"+bean.getTax          ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getPubKind      ()"+bean.getPubKind      ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getLoadStatus   ()"+bean.getLoadStatus   ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getPubCode      ()"+bean.getPubCode      ());
			System.out.println("[IssueDatabase:insertPayEBill]bean.getPubStatus    ()"+bean.getPubStatus    ());

			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
				if ( pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	거래명세서 리스트 한건 조회
	 *  
	 */	
	public TaxItemListBean getTaxItemListMyAccid(String car_mng_id, String tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxItemListBean bean = new TaxItemListBean();
		String query = "";

		query = " select a.* from tax_item_list a, tax b where a.car_mng_id=? and a.tm=? "+
				"          and a.reg_code=(select max(reg_code) from tax_item_list where car_mng_id=? and tm=?)"+
				"          and a.item_id=b.item_id(+) and nvl(b.tax_st,'O')='O'";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	car_mng_id);
			pstmt.setString	(2,	tm);
			pstmt.setString	(3,	car_mng_id);
			pstmt.setString	(4,	tm);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setItem_id		(rs.getString(1));
				bean.setItem_seq	(rs.getInt(2));
				bean.setItem_g		(rs.getString(3));
				bean.setItem_car_no	(rs.getString(4));
				bean.setItem_car_nm	(rs.getString(5));
				bean.setItem_dt1	(rs.getString(6));
				bean.setItem_dt2	(rs.getString(7));
				bean.setItem_supply	(rs.getInt(8));
				bean.setItem_value	(rs.getInt(9));
				bean.setRent_l_cd	(rs.getString(10));
				bean.setCar_mng_id	(rs.getString(11));
				bean.setTm			(rs.getString(12));
				bean.setGubun		(rs.getString(13));
				bean.setReg_dt		(rs.getString(14));
				bean.setReg_id		(rs.getString(15));
				bean.setReg_code	(rs.getString(16));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemListMyAccid(String car_mng_id, String tm)]\n"+e);
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
	 *	거래명세서 리스트 한건 조회
	 *  
	 */	
	public TaxItemListBean getTaxItemListMyAccid(String car_mng_id, String tm, String rent_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxItemListBean bean = new TaxItemListBean();
		String query = "";

		query = " select a.* "+
				" from tax_item_list a "+
				" where a.car_mng_id=? and a.tm=? and nvl(a.rent_seq,'1')=?"+
				"          and a.reg_code=(select max(reg_code) from tax_item_list where car_mng_id=? and tm=? and nvl(rent_seq,'1')=?)"+
				" ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	car_mng_id);
			pstmt.setString	(2,	tm);
			pstmt.setString	(3,	rent_seq);
			pstmt.setString	(4,	car_mng_id);
			pstmt.setString	(5,	tm);
			pstmt.setString	(6,	rent_seq);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setItem_id		(rs.getString(1));
				bean.setItem_seq	(rs.getInt(2));
				bean.setItem_g		(rs.getString(3));
				bean.setItem_car_no	(rs.getString(4));
				bean.setItem_car_nm	(rs.getString(5));
				bean.setItem_dt1	(rs.getString(6));
				bean.setItem_dt2	(rs.getString(7));
				bean.setItem_supply	(rs.getInt(8));
				bean.setItem_value	(rs.getInt(9));
				bean.setRent_l_cd	(rs.getString(10));
				bean.setCar_mng_id	(rs.getString(11));
				bean.setTm			(rs.getString(12));
				bean.setGubun		(rs.getString(13));
				bean.setReg_dt		(rs.getString(14));
				bean.setReg_id		(rs.getString(15));
				bean.setReg_code	(rs.getString(16));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemListMyAccid(String car_mng_id, String tm)]\n"+e);
			System.out.println("[IssueDatabase:getTaxItemListMyAccid(String car_mng_id, String tm)]\n"+query);
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

	public TaxItemListBean getTaxItemListMyAccid(String car_mng_id, String tm, String rent_seq, int ins_req_amt)//c_id, accid_id, seq_no, ma_bean.getIns_req_amt()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxItemListBean bean = new TaxItemListBean();
		String query = "";

		query = " select a.* "+
				" from tax_item_list a, tax_item b "+
				" where a.car_mng_id=? and a.tm=? and nvl(a.rent_seq,'1')=? and (a.item_supply+a.item_value)=?"+
				"          and a.reg_code=(select max(reg_code) from tax_item_list where car_mng_id=? and tm=? and nvl(rent_seq,'1')=? and (item_supply+item_value)=?)"+
				" and a.item_id=b.item_id and nvl(b.use_yn,'Y')='Y'";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	car_mng_id);
			pstmt.setString	(2,	tm);
			pstmt.setString	(3,	rent_seq);
			pstmt.setInt	(4,	ins_req_amt);
			pstmt.setString	(5,	car_mng_id);
			pstmt.setString	(6,	tm);
			pstmt.setString	(7,	rent_seq);
			pstmt.setInt	(8,	ins_req_amt);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setItem_id		(rs.getString(1));
				bean.setItem_seq	(rs.getInt(2));
				bean.setItem_g		(rs.getString(3));
				bean.setItem_car_no	(rs.getString(4));
				bean.setItem_car_nm	(rs.getString(5));
				bean.setItem_dt1	(rs.getString(6));
				bean.setItem_dt2	(rs.getString(7));
				bean.setItem_supply	(rs.getInt(8));
				bean.setItem_value	(rs.getInt(9));
				bean.setRent_l_cd	(rs.getString(10));
				bean.setCar_mng_id	(rs.getString(11));
				bean.setTm			(rs.getString(12));
				bean.setGubun		(rs.getString(13));
				bean.setReg_dt		(rs.getString(14));
				bean.setReg_id		(rs.getString(15));
				bean.setReg_code	(rs.getString(16));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemListMyAccid(String car_mng_id, String tm)]\n"+e);
			System.out.println("[IssueDatabase:getTaxItemListMyAccid(String car_mng_id, String tm)]\n"+query);
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


	//집금입금내역 한건 등록
	public boolean insertPayIncom(PayBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		
				
		query = " INSERT INTO INCOM_EBILL"+
				" ( RENT_MNG_ID, RENT_L_CD, GUBUN, PAY_DT, PAY_AMT, CLIENT_ID, SEQID, USER_ID, USER_DT  "+
				" ) VALUES"+
				" ( ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ? , to_char(sysdate,'YYYYMMdd') "+
				"  )";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getRent_mng_id	 ());
			pstmt.setString	(2,		bean.getRent_l_cd    ());
			pstmt.setString	(3,		bean.getGubun  		 ());
			pstmt.setString	(4,		bean.getPay_dt    	 ());
			pstmt.setInt    (5,		bean.getPay_amt      ());
			pstmt.setString	(6,		bean.getClient_id    ());
			pstmt.setString (7,		bean.getSeqid        ());
			pstmt.setString (8,	    bean.getReg_id       ());
				
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertPayIncom]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	정기청구-개별 :계약건별 일괄발행리스트
	 *  
	 */	
	public Vector getIssue1ItemList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+

				"        decode(e.fee_s_amt+e.fee_v_amt,e2.rc_amt,'수금',decode(t.cls_st,'8','매입옵션','2','중도해지','1','계약만료','4','차종변경','5','계약승계','',decode(g.rent_l_cd,'',decode(e.tm_st2,'3','임의연장',''),'발행중지'),'해지')) as use_yn, \n"+
				"        t.cls_st, a.brch_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, \n"+
				"        nvl(m.enp_no,decode(b.client_st,'2',TEXT_DECRYPT(b.ssn, 'pw' ) ,b.enp_no)) enp_no, \n"+
				"	     nvl(m.firm_nm,b.firm_nm) firm_nm, \n"+
				" 	     d.r_site as site_nm, c.car_no, c.car_nm, \n"+
				"        e.rent_st, e.rent_seq, e.fee_tm, e.fee_s_amt, e.fee_v_amt, (e.fee_s_amt+e.fee_v_amt) fee_amt, e.fee_est_dt, e.r_fee_est_dt, \n"+
				"        e.req_dt, e.r_req_dt as r_req_dt, e.tax_out_dt, e2.rc_dt, e.tm_st2, decode(e.rc_dt,'','미수금',decode(e.fee_s_amt+e.fee_v_amt,e2.rc_amt,'','잔액')) rc_st, \n"+
				"        decode(a.car_st,'4','(월렌트)','') as rm_st "+		

				" from   cont a, client b, car_reg c, client_site d, scd_fee e, cls_cont t, cls_etc te, cont_etc i, \n"+

				"        /*기발행분체크*/ (select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm as fee_tm, sum(item_supply) as fee_s_amt from tax_item_list a, tax_item b, tax c where a.gubun='1' and a.item_id=b.item_id and nvl(b.use_yn,'Y')='Y' and a.item_id=c.item_id(+) and nvl(c.tax_st,'O')<>'C' group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm having sum(item_supply)<>0) f, \n"+

				"        /*발행중지여부*/( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD') ) g, \n"+
				"        /*분할청구업체*/( select a.*, decode(a.r_site,'',decode(b.client_st,'2',TEXT_DECRYPT(b.ssn, 'pw' ) ,b.enp_no), TEXT_DECRYPT(c.enp_no, 'pw' )) enp_no, decode(a.r_site,'',b.firm_nm, c.r_site) firm_nm, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+) ) m, \n"+
				"        /*대여료수금시*/( select rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, max(rc_dt) rc_dt, sum(rc_amt) rc_amt from scd_fee where rc_yn='1' group by rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq ) e2 \n"+

				" where \n"+
				"        a.client_id=b.client_id \n"+
				" 		 and decode(a.car_st,'4','1',decode(e.tm_st2,'4','1','3',decode(b.im_print_st,'Y',nvl(b.print_st,'1'),'1'),nvl(b.print_st,'1')))='1' \n"+ //건별발행 혹은 임의연장
				"        and a.car_mng_id=c.car_mng_id(+) \n"+ //출고지연스케줄일 경우 신차등록전일수도 있음.
				"        and a.client_id=d.client_id(+) and a.r_site=d.seq(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.tm_st1='0' \n"+
				"        and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) "+
				"        and a.rent_mng_id=te.rent_mng_id(+) and a.rent_l_cd=te.rent_l_cd(+) "+
				"	     and (nvl(t.cls_st,'0') in ('0','3','4','5','6','7','9','10','14','15')  or (t.cls_st in ('1','2') and te.match='Y')) \n"+
				"        and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) \n"+
				"        and e.rent_l_cd=f.rent_l_cd(+) and e.fee_tm=f.fee_tm(+) and e.rent_st=f.rent_st(+) and e.rent_seq=f.rent_seq(+) \n"+
				"	     and f.rent_l_cd is null \n"+
				"        and e.rent_mng_id=e2.rent_mng_id(+) and e.rent_l_cd=e2.rent_l_cd(+) and e.fee_tm=e2.fee_tm(+) and e.rent_st=e2.rent_st(+) and e.rent_seq=e2.rent_seq(+) \n"+
				"        and e.rent_mng_id=g.rent_mng_id(+) and e.rent_l_cd=g.rent_l_cd(+) and e.rent_seq=g.rent_seq(+) "+
				"	     and g.rent_l_cd is null \n"+
				"        and e.rent_mng_id=m.rent_mng_id(+) and e.rent_l_cd=m.rent_l_cd(+) and e.rent_st=m.rent_st(+) and e.rent_seq=m.rent_seq(+) \n"+
				"        and nvl(e.bill_yn,'Y')='Y' and e.fee_est_dt > '20051001' and e.fee_s_amt>0  \n"+
				"        and nvl(i.ele_tax_st,'1') ='1' \n"+ //당사시스템 사용업체
				"        and nvl(b.print_st,'1') <> '9' \n"+ //타시스템발행 제외
				"        and e.rent_l_cd||e.fee_tm <>'S110HXBL0003932' \n "+//특정회차 제외
				"	";

		//2010년세금일자부터
		query += " and e.tax_out_dt > '20091231' \n";


		if(!s_br.equals(""))		query += " and a.brch_id like '"+s_br+"%' \n";

		//기간구분
		if(gubun1.equals("1") && !st_dt.equals(""))		query += " and (decode(e.fee_s_amt+e.fee_v_amt,e2.rc_amt,decode(a.car_st,'4',e2.rc_dt,to_char(sysdate,'YYYYMMDD')),to_char(sysdate,'YYYYMMDD'))>replace('"+st_dt+"','-','') or decode(e.fee_s_amt+e.fee_v_amt,e2.rc_amt,decode(a.car_st,'4',e2.rc_dt,e.r_req_dt),e.r_req_dt)<replace('"+st_dt+"','-','') or decode(e.fee_s_amt+e.fee_v_amt,e2.rc_amt,decode(a.car_st,'4',e2.rc_dt,e.r_req_dt),e.r_req_dt) between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')) \n";

		String search = "";
		if(s_kd.equals("1"))		search = "nvl(m.firm_nm,b.firm_nm)";
		else if(s_kd.equals("2"))	search = "a.rent_l_cd";
		else if(s_kd.equals("3"))	search = "c.car_no";

		if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%') \n";
		if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%' \n";

		query += " order by decode(a.car_st,'4',decode(e.rc_dt,'','3',decode(e.fee_s_amt+e.fee_v_amt,e.rc_amt,'1','2')),0), decode(e.tm_st2,'3',0,1), t.cls_st, g.rent_l_cd, decode(g.rent_l_cd,'','0',e.fee_est_dt), ";

		if(sort.equals("1"))		query += " nvl(m.firm_nm,b.firm_nm) "+asc+", e.use_s_dt ";
		if(sort.equals("2"))		query += " c.car_no "+asc+", e.use_s_dt ";
		if(sort.equals("3"))		query += " e.r_req_dt "+asc+", nvl(m.firm_nm,b.firm_nm), e.use_s_dt ";
		if(sort.equals("4"))		query += " e.fee_est_dt "+asc+", nvl(m.firm_nm,b.firm_nm), e.use_s_dt ";

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
			System.out.println("[IssueDatabase:getIssue1ItemList]\n"+e);
			System.out.println("[IssueDatabase:getIssue1ItemList]\n"+query);
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
	 *	정기발행-개별발행 :계약건별 일괄발행리스트
	 *  
	 */	
	public Vector getIssue1TaxList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select /*+ leading(A B G H ) index(a TAX_ITEM_IDX3) index(b TAX_ITEM_LIST_PK) index(g CONT_IDX8) index(h CLS_CONT_IDX4) */ a.*, \n"+
                "        decode(a.seq,'',e.firm_nm,f.r_site) firm_nm, \n"+
                "        b.item_car_no||decode(d.cnt,1,'',' 외'||(d.cnt-1)||'건') as tax_bigo, \n"+
                "        d.item_supply, d.item_value, d.cnt, d.cls_cnt, d.stop_cnt, b.reg_id, \n"+
				"        decode(g.car_st,'4','(월렌트)','') rm_st "+
                " from   tax_item a, tax_item_list b, "+
                "        ( select aa.item_id, \n"+
                "                 count(aa.item_seq)  cnt, \n"+
                "                 min(aa.item_seq)    item_seq, \n"+
                "                 min(aa.gubun)       gubun, \n"+
                "                 sum(aa.item_supply) item_supply, \n"+
                "                 sum(aa.item_value)  item_value, \n"+
				"                 count(decode(bb.bill_yn,'N',bb.rent_l_cd)) cls_cnt,\n"+
				"                 count(decode(g.rent_l_cd,'','',g.rent_l_cd)) stop_cnt \n"+
                "          from   tax_item_list aa, scd_fee bb, tax_item cc, \n"+
				"                 /*발행중지여부*/( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD') ) g \n"+
                "          where  nvl(aa.gubun,'1')='1'  \n"+
				"                 and aa.rent_l_cd=bb.rent_l_cd and aa.tm=bb.fee_tm and aa.rent_st=bb.rent_st and aa.rent_seq=bb.rent_seq and bb.tm_st1='0' \n"+
				"                 and bb.rent_mng_id=g.rent_mng_id(+) and bb.rent_l_cd=g.rent_l_cd(+) and bb.rent_seq=g.rent_seq(+) \n"+// and g.rent_l_cd is null
				"                 and aa.item_id=cc.item_id and nvl(cc.use_yn,'Y')='Y' "+
				"                 ";

		if(s_kd.equals("2") && !t_wd1.equals("") && t_wd2.equals(""))		query += " and aa.rent_l_cd like '"+t_wd1+"'";
		if(s_kd.equals("3") && !t_wd1.equals("") && t_wd2.equals(""))		query += " and aa.item_car_no like '"+t_wd1+"'";

		if(s_kd.equals("2") && !t_wd1.equals("") && !t_wd2.equals(""))		query += " and (aa.rent_l_cd like '%"+t_wd1+"%' or aa.rent_l_cd like '%"+t_wd2+"%')";
		if(s_kd.equals("3") && !t_wd1.equals("") && !t_wd2.equals(""))		query += " and (aa.item_car_no like '%"+t_wd1+"%' or aa.item_car_no like '%"+t_wd2+"%')";

		query +="          group by aa.item_id \n"+
                "        ) d, \n"+
				"        tax c, \n"+
                "        client e, client_site f, cont g, cls_cont h, \n"+
				"        ( select a.item_id, count(0) cnt \n"+
				"          from tax_item_list a, scd_fee b\n"+
				"          where a.gubun='1' and b.bill_yn='Y' and a.rent_l_cd=b.rent_l_cd and a.tm=b.fee_tm and a.rent_st=b.rent_st and a.rent_seq=b.rent_seq \n"+
				"          group by a.item_id having count(0)>0) d2 \n"+
                " where  a.tax_est_dt is not null and a.tax_no is null \n"+
                "        and a.item_id=b.item_id and b.gubun='1' \n"+
                "        and b.item_id=d.item_id and b.item_seq=d.item_seq\n"+
                "        and a.item_id=c.item_id(+) and c.tax_no is null \n"+
                "        and a.client_id=e.client_id \n"+
                "        and a.client_id=f.client_id(+) and a.seq=f.seq(+) \n"+
				"        and b.rent_l_cd=g.rent_l_cd  \n"+
                "        and b.rent_l_cd=h.rent_l_cd(+) \n"+
				"        and nvl(a.use_yn,'Y')='Y'\n"+
				"        and b.ITEM_SUPPLY>0 \n"+
                "        and a.item_id=d2.item_id \n"+
			    "        and b.rent_l_cd<>'S106HTGL00011' "+
				"        and a.client_id<>'001803' "+
				"        and a.client_id<>'022660' "+
				" ";

		if(!s_br.equals(""))		query += " and g.brch_id like '"+s_br+"%'";

		//기간구분
		if(gubun1.equals("1") && !st_dt.equals(""))		query += " and a.item_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";//발행예정일
		if(gubun1.equals("3") && !st_dt.equals(""))		query += " and (a.tax_est_dt < replace('"+st_dt+"','-','') or a.tax_est_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-',''))";//세금일자(예정일)

		String search = "";
		if(s_kd.equals("1"))		search = "decode(a.seq,'',e.firm_nm,f.r_site)";
		if(s_kd.equals("4"))		search = "a.item_id";

		if(s_kd.equals("5"))		query += " and d.stop_cnt>0";
		if(s_kd.equals("6"))		query += " and d.cls_cnt>0";

		if(s_kd.equals("1") || s_kd.equals("4")){
			if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
			if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";
		}	

		query += " order by ";

		if(sort.equals("1"))		query += " decode(a.seq,'',e.firm_nm,f.r_site) "+asc;
		if(sort.equals("3"))		query += " a.item_dt "+asc+", decode(a.seq,'',e.firm_nm,f.r_site)";
		if(sort.equals("4"))		query += " a.tax_est_dt "+asc+", decode(a.seq,'',e.firm_nm,f.r_site)";
		if(sort.equals("5"))		query += " a.item_id "+asc+", decode(a.seq,'',e.firm_nm,f.r_site)";

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
			System.out.println("[IssueDatabase:getIssue1TaxList]\n"+e);
			System.out.println("[IssueDatabase:getIssue1TaxList]\n"+query);
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

	//이미 발행한 청구서 중복체크하기
	public int getTaxItemMakeCheck(String rent_l_cd, String fee_tm, String rent_st, String rent_seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = "";

		query = " select count(0) "+
				" from   tax_item_list a, tax_item c, tax b  "+
				" where   "+
				"        a.rent_l_cd=? and a.tm=? and a.rent_st=? and a.rent_seq=? "+
				"        and a.gubun='1' "+
				"        and a.item_id=c.item_id and nvl(c.use_yn,'Y')='Y' "+
				"        and a.item_id=b.item_id(+)  and nvl(b.tax_st,'O')<>'C' "+
				" group by a.rent_l_cd, a.tm, a.rent_st, a.rent_seq "+
				" having sum(a.item_value) > 0"+
				" ";

		try {

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_l_cd);
			pstmt.setString(2, fee_tm);
			pstmt.setString(3, rent_st);
			pstmt.setString(4, rent_seq);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxMakeCheck]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}		
	}

	/**
	 *	정기발행-통합발행  :계약건별 일괄발행리스트
	 *  
	 */	
	public Vector getIssue2ItemList(String s_br, String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String group_item1 = "nvl(m.client_id,a.client_id)";
		String group_item2 = "decode(m.r_site,'',decode(b.print_st,'2','00',decode(a.tax_type,'2',nvl(a.r_site,'00'),'00')),m.r_site)";
		String group_item3 = "nvl(d.req_dt,d.r_fee_est_dt)";
		String group_item4 = "nvl(d.tax_out_dt,d.fee_est_dt)";
		String group_item5 = "case when nvl(b.print_car_st, '0') = '1' and k.s_st in ('100','101','409','601','602','700','701','702','801','802','803','811','821') then 1 else 0 end";

		query = " select \n"+
				"        a.use_yn, decode(a.car_st,'4','(월렌트)','') rm_st,  \n"+
				"        "+group_item1+" client_id,  \n"+
				"        "+group_item2+" site_id,  \n"+
				"        "+group_item3+" r_req_dt,  \n"+
				"        "+group_item4+" tax_out_dt,  \n"+
				"        "+group_item5+" s_st,  \n"+
				"        count(0) cnt, \n"+
				"        min(nvl(m.firm_nm,b.firm_nm)) firm_nm, min(nvl(c.r_site,'-')) site_nm, min(nvl(b.print_st,'1')) print_st, \n"+
				"        sum(d.fee_s_amt) fee_s_amt, sum(d.fee_v_amt) fee_v_amt, sum(d.fee_s_amt+d.fee_v_amt) fee_amt \n"+

				" from   cont a, client b, client_site c, scd_fee d, car_reg e, cls_cont t, cls_etc te, car_etc j, car_nm k, \n"+

				"        /*기발행계산서*/( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm, sum(a.ITEM_SUPPLY) fee_s_amt from tax_item_list a, tax_item b, tax c where a.gubun='1' and nvl(b.use_yn,'Y')='Y' and c.tax_st<>'C' and a.item_id=b.item_id and a.item_id=c.item_id group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm having sum(a.item_supply) >0 ) f, "+
				"        /*기발행청구서*/( select a.rent_l_cd, a.rent_st, a.rent_seq, a.tm, sum(a.ITEM_SUPPLY) fee_s_amt from tax_item_list a, tax_item b, tax c where a.gubun='1' and nvl(b.use_yn,'Y')='Y' and nvl(c.tax_st,'O')<>'C' and a.item_id=b.item_id and a.item_id=c.item_id(+) group by a.rent_l_cd, a.rent_st, a.rent_seq, a.tm having sum(a.item_supply) >0) h, "+

				"        /*발행중지여부*/( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD') ) g, \n"+
				"        /*분할청구여부*/( select a.*, decode(a.r_site,'',b.firm_nm, c.r_site) firm_nm, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+) ) m, \n"+
				"        /*대여료수금시*/( select rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, sum(rc_amt) rc_amt from scd_fee where rc_yn='1' group by rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq ) e2 \n"+

				" where \n"+
				"        a.client_id=b.client_id \n"+
				"        and a.client_id=c.client_id(+) and a.r_site=c.seq(+) \n"+
				"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.tm_st1='0' \n"+
				"        and a.car_mng_id=e.car_mng_id(+) \n"+
				"        and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=te.rent_mng_id(+) and a.rent_l_cd=te.rent_l_cd(+) \n"+
				"	     and (nvl(t.cls_st,'0') in ('0','3','4','5','6','7','9','10','14','15') or (t.cls_st in ('1','2') and te.match='Y')) \n"+
				"	     and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+) \n"+
				"        and j.car_id=k.car_id(+) and j.car_seq=k.car_seq(+) \n"+

				"        and d.rent_l_cd=f.rent_l_cd(+) and d.fee_tm=f.tm(+) and d.rent_st=f.rent_st(+) and d.rent_seq=f.rent_seq(+) and f.rent_l_cd is null \n"+
				"        and d.rent_l_cd=h.rent_l_cd(+) and d.fee_tm=h.tm(+) and d.rent_st=h.rent_st(+) and d.rent_seq=h.rent_seq(+) and h.rent_l_cd is null \n"+

				"        and d.rent_mng_id=g.rent_mng_id(+) and d.rent_l_cd=g.rent_l_cd(+) and d.rent_seq=g.rent_seq(+) \n"+
				"        and d.rent_mng_id=m.rent_mng_id(+) and d.rent_l_cd=m.rent_l_cd(+) and d.rent_st=m.rent_st(+) and d.rent_seq=m.rent_seq(+) \n"+
				"        and d.rent_mng_id=e2.rent_mng_id(+) and d.rent_l_cd=e2.rent_l_cd(+) and d.fee_tm=e2.fee_tm(+) and d.rent_st=e2.rent_st(+) and d.rent_seq=e2.rent_seq(+) \n"+
				"        and g.rent_l_cd is null  \n"+
				"        and nvl(d.bill_yn,'Y')='Y' and d.tm_st1='0' and d.fee_est_dt > '20051001' and d.fee_s_amt>0 \n"+
				"        and nvl(b.print_st,'1') <> '9' \n"+ //타시스템발행 제외
				" 		 and decode(a.car_st,'4','1',decode(d.tm_st2,'4','1','3',decode(b.im_print_st,'Y',nvl(b.print_st,'1'),'1'),nvl(b.print_st,'1'))) in ( '2', '3', '4') \n"+ //건별발행 제외
				"        and d.rent_l_cd||d.fee_tm <> 'S112HNER000201' \n "+//특정회차 제외
				" "	;

		query += " and d.tax_out_dt > '20091231' \n"; 

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%' \n";

		//기간구분
		if(gubun1.equals("1") && !st_dt.equals("") && !end_dt.equals(""))		query += " and (d.r_req_dt<replace('"+st_dt+"','-','') or d.r_req_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')) \n";


		//발행구분
		if(!chk1.equals(""))		query += " and b.print_st='"+chk1+"' \n";

		String search = "";
		if(s_kd.equals("1"))		search = "nvl(m.firm_nm,b.firm_nm)";
		else if(s_kd.equals("2"))	search = "a.rent_l_cd";
		else if(s_kd.equals("3"))	search = "e.car_no";

		if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%') \n";
		if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%' \n";

		query += " group by a.use_yn, decode(a.car_st,'4','(월렌트)',''), \n "+group_item1+", \n "+group_item2+", \n "+group_item3+", \n "+group_item4+", \n "+group_item5+"  \n";

		if(sort.equals("1"))		query += " order by min(nvl(m.firm_nm,b.firm_nm)) "+asc+", min(nvl(m.r_site,a.r_site)) ";

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
			System.out.println("[IssueDatabase:getIssue2ItemList]\n"+e);
			System.out.println("[IssueDatabase:getIssue2ItemList]\n"+query);
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
     * 프로시져 호출
     */
    public String call_sp_tax_ebill(String user_nm, String regcode) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
		String query1 = "{CALL P_TAX_EBILL_NEOE     (?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, regcode);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:call_sp_tax_ebill]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	/**
     * 프로시져 호출
     */
    public String call_sp_tax_ebill_etc(String user_nm, String regcode) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
		String query1 = "{CALL P_TAX_EBILL_ETC_NEOE     (?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, regcode);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:call_sp_tax_ebill_etc]\n"+e);
			System.out.println("[IssueDatabase:call_sp_tax_ebill_etc]\n"+user_nm);
			System.out.println("[IssueDatabase:call_sp_tax_ebill_etc]\n"+regcode);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	/**
     * 프로시져 호출
     */
    public String call_sp_tax_ebill_cls(String user_nm, String regcode) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_TAX_EBILL_CLS     (?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, regcode);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:call_sp_tax_ebill_cls]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	/**
     * 프로시져 호출
     */
    public String call_sp_tax_ebill_itemmail(String gubun, String user_nm, String regcode, String item_id, String agnt_nm, String agnt_email, String agnt_tel) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_TAX_EBILL_ITEMMAIL     (?,?,?,?,?,?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, gubun);
			cstmt.setString(2, user_nm);
			cstmt.setString(3, regcode);
			cstmt.setString(4, item_id);
			cstmt.setString(5, agnt_nm);
			cstmt.setString(6, agnt_email);
			cstmt.setString(7, agnt_tel);
			cstmt.registerOutParameter(8, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(8); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:call_sp_tax_ebill_itemmail]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	/**
     * 프로시져 호출
     */
    public String call_sp_tax_ebill_taxmail(String gubun, String user_nm, String taxcode, String tax_no) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_TAX_EBILL_TAXMAIL     (?,?,?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, gubun);
			cstmt.setString(2, user_nm);
			cstmt.setString(3, taxcode);
			cstmt.setString(4, tax_no);
			cstmt.registerOutParameter(5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:call_sp_tax_ebill_taxmail]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	/**
     * 프로시져 호출
     */
    public String call_sp_tax_ebill_taxsms(String gubun, String user_nm, String taxcode, String tax_no) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_TAX_EBILL_TAXSMS     (?,?,?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, gubun);
			cstmt.setString(2, user_nm);
			cstmt.setString(3, taxcode);
			cstmt.setString(4, tax_no);
			cstmt.registerOutParameter(5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:call_sp_tax_ebill_taxsms]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	/**
     * 프로시져 호출
     */
    public String call_sp_tax_ebill_autodocu(String user_nm, String tax_no) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_TAX_EBILL_NEOE_ADOCU     (?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, tax_no);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:call_sp_tax_ebill_autodocu]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	/**
     * 프로시져 호출
     */
    public String call_sp_tax_ebill_etc_autodocu(String user_nm, String tax_no) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_TAX_EBILL_ETC_NEOE_ADOCU     (?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, tax_no);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:call_sp_tax_ebill_etc_autodocu]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	/**
	 *	세금계산서 조회-
	 */	
	public Hashtable getTaxItemMailCase(String gubun, String reg_code, String item_id, String client_id, String site_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		//이메일폼
		String query1 = " select "+
						"        decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site) name,"+
						"        substr(decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site),1,15) name2,"+
						"        a.client_id, a.seq,"+
						"        a.item_dt, a.tax_year, a.tax_mon, a.tax_cnt, to_char(sysdate,'YYYY-MM-DD') write_dt,"+
						"        c.user_nm, nvl(c.hot_tel,c.user_h_tel) as user_h_tel, a.rent_l_cd"+
						" from"+
						"        ("+
						" 	       select a.client_id, a.seq, a.item_dt, a.item_man, "+
						" 	              min(substr(a.tax_est_dt,1,4)) tax_year, "+
						"                 min(substr(a.tax_est_dt,5,2)) tax_mon, "+
						"                 min(c.rent_l_cd) rent_l_cd, "+
						"                 count(a.item_id) tax_cnt"+
						" 	       from   tax_item a, (select item_id from tax_item_list where reg_code='"+reg_code+"' group by item_id) b, tax_item_list c"+
						" 	       where  a.client_id='"+client_id+"' and a.item_id=b.item_id and nvl(a.use_yn,'Y')='Y' and a.item_id=c.item_id and c.item_seq=1 ";

		if(!site_id.equals("")) query1 += " and a.seq='"+site_id+"'";
		else					query1 += " and a.seq is null";

		query1 += 		" 	       group by  a.client_id, a.seq, a.item_dt, a.item_man"+
						"        ) a, client b, users c, client_site d"+
						" where  a.client_id=b.client_id"+
						"        and a.item_man=c.user_nm"+
						"        and a.client_id=d.client_id(+) and a.seq=d.seq(+)";


		//개별발송
		String query2 = " select "+
						"        decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site) name,"+
						"        substr(decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site),1,15) name2,"+
						"        a.client_id, a.seq,"+
						"        a.item_dt, a.tax_year, a.tax_mon, a.tax_cnt, to_char(sysdate,'YYYY-MM-DD') write_dt,"+
						"        c.user_nm, nvl(c.hot_tel,c.user_h_tel) as user_h_tel, a.rent_l_cd"+
						" from"+
						"        ("+
						" 	       select a.client_id, a.seq, a.item_dt, a.item_man, "+
						" 	              min(substr(a.tax_est_dt,1,4)) tax_year, "+
						"                 min(substr(a.tax_est_dt,5,2)) tax_mon, "+
						"                 min(c.rent_l_cd) rent_l_cd, "+
						"                 count(a.item_id) tax_cnt"+
						" 	       from   tax_item a, tax_item_list c"+
						" 	       where  a.item_id='"+item_id+"' and a.item_id=c.item_id and c.item_seq=1"+
						" 	       group by a.client_id, a.seq, a.item_dt, a.item_man"+
						"        ) a, client b, users c, client_site d"+
						" where a.client_id=b.client_id"+
						"        and a.item_man=c.user_nm"+
						"        and a.client_id=d.client_id(+) and a.seq=d.seq(+)";


		String query3 = " select name,name2,client_id,seq,item_dt,tax_year,tax_mon,tax_cnt,write_dt,user_nm,user_h_tel,rent_l_cd";

		if(gubun.equals("1"))		query3 += " from ("+query1+")";
		else if(gubun.equals("2"))	query3 += " from ("+query2+")";


		try {
				pstmt = conn.prepareStatement(query3);
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
			System.out.println("[IssueDatabase:getTaxItemMailCase]\n"+e);
			System.out.println("[IssueDatabase:getTaxItemMailCase]\n"+query3);
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
	 *	2-6단계 : 거래명세서 리스트 item_id 한건 조회
	 *  
	 */	
	public Vector getTaxItemScdListCase(String item_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.item_id, a.item_seq, a.item_g, a.item_car_no, a.item_car_nm, a.item_dt1, a.item_dt2, a.item_supply, a.item_value, "+
				"        a.rent_l_cd, a.car_mng_id, a.tm, a.gubun, a.reg_id, a.reg_dt, a.reg_code, "+
				"        nvl(b.r_fee_est_dt,a.item_dt2) r_fee_est_dt, bill_yn, a.rent_st, a.rent_seq, a.car_use, a.item_dt, a.etc "+
				" from   tax_item_list a, scd_fee b "+
				" where  a.item_id=? "+
				"        and a.rent_l_cd=b.rent_l_cd(+) and a.rent_st=b.rent_st(+) and a.rent_seq=b.rent_seq(+) and a.tm=b.fee_tm(+) and nvl(b.tm_st1,'0')='0'";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	item_id);
	    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{			
				TaxItemListBean bean = new TaxItemListBean();
				bean.setItem_id			(rs.getString(1));
				bean.setItem_seq		(rs.getInt(2));
				bean.setItem_g			(rs.getString(3));
				bean.setItem_car_no		(rs.getString(4));
				bean.setItem_car_nm		(rs.getString(5));
				bean.setItem_dt1		(rs.getString(6));
				bean.setItem_dt2		(rs.getString(7));
				bean.setItem_supply		(rs.getInt(8));
				bean.setItem_value		(rs.getInt(9));
				bean.setRent_l_cd		(rs.getString(10));
				bean.setCar_mng_id		(rs.getString(11));
				bean.setTm				(rs.getString(12));
				bean.setGubun			(rs.getString(13));
				bean.setReg_id			(rs.getString(14));
				bean.setReg_dt			(rs.getString(15));
				bean.setReg_code		(rs.getString(16));
				bean.setR_fee_est_dt	(rs.getString(17));
				bean.setBill_yn			(rs.getString(18));
				bean.setRent_st			(rs.getString(19));
				bean.setRent_seq		(rs.getString(20));
				bean.setCar_use			(rs.getString(21));
				bean.setItem_dt			(rs.getString(22));
				bean.setEtc				(rs.getString(23));
				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemScdListCase(String item_id)]\n"+e);
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

	//9-2단계 : 발행도중 에러 발생시 기작성분 삭제
	public boolean deleteTaxItem(String item_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		String query1 = "";
		String query2 = "";
			
		query1 = " DELETE FROM tax_item	WHERE item_id=?";

		query2 = " DELETE FROM tax_item_list WHERE item_id=?";

		try 
		{
			conn.setAutoCommit(false);	

			pstmt = conn.prepareStatement(query1);
			pstmt.setString	(1,		item_id);
			pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString	(1,		item_id);
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:deleteTaxItem]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
				if ( pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//세금계산서 내용 수정시 트러스빌 취소후 재발급 준비 업데이트
	public boolean updateSaleEBillTaxItemUpdate(SaleEBillBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " UPDATE itemlist SET"+
				"		itemdate		=replace(?, '-', ''),	"+
				"       itemname		=?,		"+
				"		itemsupprice	=?,		"+
				"		itemtax			=?,		"+
				"		itemremarks		=?		"+
				" WHERE seqid=? and detailseqid=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getItemDate1    ());
			pstmt.setString	(2,		bean.getItemName1    ());
			pstmt.setInt   	(3,		bean.getItemSupPrice1());
			pstmt.setInt   	(4,		bean.getItemTax1     ());
			pstmt.setString	(5,		bean.getItemRemarks1 ());
			pstmt.setString	(6,		bean.getItemSeqId     ());
			pstmt.setString	(7,		bean.getResSeq	    ());

			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateSaleEBillTaxItemUpdate]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//거래명세서 리스트 한건 삭제
	public boolean deleteSaleEBillTaxItem(SaleEBillBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " DELETE FROM itemlist"+
				" WHERE seqid=? and detailseqid=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getItemSeqId	());
			pstmt.setString	(2,		bean.getResSeq		());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
				
	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:deleteSaleEBillTaxItem]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//전자세금계산서-상품리스트 한건 등록
	public boolean insertSaleEBillItem(SaleEBillBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO itemlist"+
				" ( seqid, detailseqid, itemdate, itemname, itemtype, itemqty, itemprice, itemsupprice, itemtax, itemremarks"+
				" ) VALUES"+
				" ( ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?"+
				"   )";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getItemSeqId			());
			pstmt.setString	(2,		bean.getResSeq				());
			pstmt.setString	(3,		bean.getItemDate1			());
			pstmt.setString	(4,		bean.getItemName1			());
			pstmt.setString	(5,		bean.getItemType1			());
			pstmt.setInt   	(6,		bean.getItemQyt1			());
			pstmt.setInt    (7,		bean.getItemPrice1			());
			pstmt.setInt   	(8,		bean.getItemSupPrice1		());
			pstmt.setInt   	(9,		bean.getItemTax1			());
			pstmt.setString	(10,	bean.getItemRemarks1		());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:insertSaleEBillItem]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//9단계 : 발행도중 에러 발생시 기작성분 삭제
	public boolean CancelTaxCode(String tax_code)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt1 = null;
		String query1 = "";
			
		query1 = " update tax_item set tax_code='' where tax_code=?";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString	(1,		tax_code);
			pstmt1.executeUpdate();
			pstmt1.close();
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:CancelTaxCode]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt1 != null )	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	세금계산서 조회-
	 */	
	public Hashtable getTaxMailCase2(String gubun, String tax_code, String tax_no, String client_id, String site_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		//이메일폼
		String query1 =  " select "+
						" a.con_agnt_email email,"+
						" decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site) name,"+
						" substr(decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site),1,15) name2,"+
						" a.con_agnt_m_tel m_tel,"+
						" a.con_agnt_nm agnt_nm,"+
						" a.client_id, a.seq,"+
						" a.reg_dt, a.tax_year, a.tax_mon, a.tax_cnt, to_char(sysdate,'YYYY-MM-DD') write_dt,"+
						" c.user_nm, nvl(c.hot_tel,c.user_h_tel) as user_h_tel"+
						" from"+
						" ("+
						" 	select a.client_id, a.seq, a.reg_id, "+
						" 	decode(a.reg_dt, '', '', substr(a.reg_dt, 1, 4) || '-' || substr(a.reg_dt, 5, 2) || '-'||substr(a.reg_dt, 7, 2)) reg_dt,"+
						" 	min(substr(a.tax_dt,1,4)) tax_year, min(substr(a.tax_dt,5,2)) tax_mon, count(a.tax_no) tax_cnt,"+
						"	min(a.con_agnt_nm) con_agnt_nm, min(a.con_agnt_email) con_agnt_email, min(a.con_agnt_m_tel) con_agnt_m_tel"+
						" 	from tax a, (select item_id from tax_item where tax_code='"+tax_code+"' group by item_id) b"+
						" 	where a.client_id='"+client_id+"' and a.item_id=b.item_id and a.tax_st<>'C'";// and a.resseq is not null

		if(!site_id.equals("")) query1 += " and a.seq='"+site_id+"'";
		else					query1 += " and a.seq is null";

		query1 += 		" 	group by  a.client_id, a.seq, a.reg_dt, a.reg_id"+
						" ) a, client b, users c, client_site d"+
						" where a.client_id=b.client_id"+
						" and a.reg_id=c.user_id"+
						" and a.client_id=d.client_id(+) and a.seq=d.seq(+)";


		//개별발송
		String query2 =  " select"+
						" a.con_agnt_email email,"+
						" decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site) name,"+
						" substr(decode(a.seq,'',b.firm_nm,decode(d.site_st,'2',b.firm_nm||' ')||d.r_site),1,15) name2,"+
						" a.con_agnt_m_tel m_tel,"+
						" a.con_agnt_nm agnt_nm,"+
						" a.client_id, a.seq,"+
						" a.reg_dt, a.tax_year, a.tax_mon, a.tax_cnt, to_char(sysdate,'YYYY-MM-DD') write_dt,"+
						" c.user_nm, c.user_h_tel"+
						" from"+
						" ("+
						" 	select a.client_id, a.seq, a.reg_id, "+
						" 	decode(a.reg_dt, '', '', substr(a.reg_dt, 1, 4) || '-' || substr(a.reg_dt, 5, 2) || '-'||substr(a.reg_dt, 7, 2)) reg_dt,"+
						" 	min(substr(a.tax_dt,1,4)) tax_year, min(substr(a.tax_dt,5,2)) tax_mon, count(a.tax_no) tax_cnt,"+
						"	min(a.con_agnt_nm) con_agnt_nm, min(a.con_agnt_email) con_agnt_email, min(a.con_agnt_m_tel) con_agnt_m_tel"+
						" 	from tax a"+
						" 	where a.tax_no='"+tax_no+"'"+
						" 	group by a.client_id, a.seq, a.reg_dt, a.reg_id"+
						" ) a, client b, users c, client_site d"+
						" where a.client_id=b.client_id"+
						" and a.reg_id=c.user_id"+
						" and a.client_id=d.client_id(+) and a.seq=d.seq(+)";


		String query3 = " select email,name,name2,m_tel,agnt_nm,client_id,seq,reg_dt,tax_year,tax_mon,tax_cnt,write_dt,user_nm,user_h_tel";

		if(gubun.equals("1"))		query3 += " from ("+query1+")";
		else if(gubun.equals("2"))	query3 += " from ("+query2+")";


		try {
				pstmt = conn.prepareStatement(query3);
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
			System.out.println("[IssueDatabase:getTaxMailCase2]\n"+e);
			System.out.println("[IssueDatabase:getTaxMailCase2]\n"+query3);
			System.out.println("[IssueDatabase:getTaxMailCase2]\n"+gubun);
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

	//문자보내기
	public void insertsendMail_V5(String sendphone, String sendname, String destphone, String destname, String tax_mon, String rqdate, String msg)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";			
		String cmid = "";
		String query2 = "";

		int i_msglen = AddUtil.lengthb(msg);		
		String msg_type = "0";		
		//80이상이면 장문자
		if(i_msglen>80) msg_type = "5";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ?) ";

		try 
		{
			conn.setAutoCommit(false);
		
			if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid		);
				pstmt.setString(2, sendphone.trim());
				pstmt.setString(3, sendname.trim() );
				pstmt.setString(4, destphone.trim());
				pstmt.setString(5, destname.trim() );
				pstmt.setString(6, msg_type        );
				pstmt.setString(7, "아마존카"      );
				pstmt.setString(8, msg.trim()      );
				pstmt.executeUpdate();	
				pstmt.close();
			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail_V5]\n"+e);
				System.out.println("[sendphone]\n"+sendphone);
				System.out.println("[sendname ]\n"+sendname );
				System.out.println("[destphone]\n"+destphone);
				System.out.println("[destname ]\n"+destname );
				System.out.println("[msg      ]\n"+msg      );
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	//문자보내기
	public void insertsendMail_V5_req(String sendphone, String sendname, String destphone, String destname, String req_time, String rqdate, String msg)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";			
		String cmid = "";
		String query2 = "";

		int i_msglen = AddUtil.lengthb(msg);		
		String msg_type = "0";		
		//80이상이면 장문자
		if(i_msglen>80) msg_type = "5";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc1 ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), to_date(to_char(to_date('"+req_time+"','YYYYMMDDhh24miss')"+rqdate+",'YYYYMMDDhh24miss')), 0, ?, ?, ?, 'req') ";

		try 
		{
			conn.setAutoCommit(false);
		
			if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid		       );
				pstmt.setString(2, sendphone.trim());
				pstmt.setString(3, sendname.trim() );
				pstmt.setString(4, destphone.trim());
				pstmt.setString(5, destname.trim() );
				pstmt.setString(6, msg_type        );
				pstmt.setString(7, "아마존카"      );
				pstmt.setString(8, msg.trim()      );
				pstmt.executeUpdate();	
				pstmt.close();
			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail_V5_req]\n"+e);
				System.out.println("[sendphone]\n"+sendphone);
				System.out.println("[sendname ]\n"+sendname );
				System.out.println("[destphone]\n"+destphone);
				System.out.println("[destname ]\n"+destname );
				System.out.println("[msg      ]\n"+msg      );
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	//문자보내기
	public void insertsendMail_V5(String sendphone, String sendname, String destphone, String destname, String tax_mon, String rqdate, String msg_type, String msg_subject, String msg)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";			
		String cmid = "";
		String query2 = "";

		int i_msglen = AddUtil.lengthb(msg);				
		//80이상이면 장문자
		if(i_msglen>80 && msg_type.equals("1")) msg_type = "5";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ?) ";

		try 
		{
			conn.setAutoCommit(false);
		
			if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid				);
				pstmt.setString(2, sendphone.trim()	);
				pstmt.setString(3, sendname.trim()	);
				pstmt.setString(4, destphone.trim()	);
				pstmt.setString(5, destname.trim()	);
				pstmt.setString(6, msg_type			);
				pstmt.setString(7, msg_subject.trim());
				pstmt.setString(8, msg.trim()		);
				pstmt.executeUpdate();	
				pstmt.close();
			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail_V5]\n"+e);
				System.out.println("[sendphone	]\n"+sendphone	);
				System.out.println("[sendname	]\n"+sendname	);
				System.out.println("[destphone	]\n"+destphone	);
				System.out.println("[destname	]\n"+destname	);
				System.out.println("[msg_type	]\n"+msg_type	);
				System.out.println("[msg_subject]\n"+msg_subject);
				System.out.println("[msg		]\n"+msg		);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	//문자보내기
	public void insertsendMail_V5_H(String sendphone, String sendname, String destphone, String destname, String tax_mon, String rqdate, String msg_type, String msg_subject, String msg, String rent_l_cd, String client_id, String user_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";			
		String cmid = "";
		String query2 = "";

		int i_msglen = AddUtil.lengthb(msg);				
		//80이상이면 장문자
		if(i_msglen>80 && msg_type.equals("1")) msg_type = "5";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc2, etc3, etc4 ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), to_date(substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ?, ?, ?, ?) ";

		try 
		{
			conn.setAutoCommit(false);
		
			if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid				);
				pstmt.setString(2, sendphone.trim()	);
				pstmt.setString(3, sendname.trim()	);
				pstmt.setString(4, destphone.trim()	);
				pstmt.setString(5, destname.trim()	);
				pstmt.setString(6, msg_type			);
				pstmt.setString(7, msg_subject.trim());
				pstmt.setString(8, msg.trim()		);
				pstmt.setString(9, rent_l_cd		);
				pstmt.setString(10,client_id		);
				pstmt.setString(11,user_id			);
				pstmt.executeUpdate();	
				pstmt.close();
			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail_V5]\n"+e);
				System.out.println("[sendphone	]\n"+sendphone	);
				System.out.println("[sendname	]\n"+sendname	);
				System.out.println("[destphone	]\n"+destphone	);
				System.out.println("[destname	]\n"+destname	);
				System.out.println("[msg_type	]\n"+msg_type	);
				System.out.println("[msg_subject]\n"+msg_subject);
				System.out.println("[msg		]\n"+msg		);
				System.out.println("[rent_l_cd	]\n"+rent_l_cd	);
				System.out.println("[client_id	]\n"+client_id	);
				System.out.println("[user_id	]\n"+user_id	);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	//문자보내기
	public void insertsendMail_V5_H(String sendphone, String sendname, String destphone, String destname, String tax_mon, String rqdate, String msg_type, String msg_subject, String msg, String rent_l_cd, String client_id, String user_id, String dest_gubun)
	{	 
		/*
		System.out.println("sendphone >>> " + sendphone);
		System.out.println("sendname >>> " + sendname);
		System.out.println("destphone >>> " + destphone);
		System.out.println("destname >>> " + destname);
		System.out.println("tax_mon >>> " + tax_mon);
		System.out.println("rqdate >>> " + rqdate);
		System.out.println("msg_type >>> " + msg_type);
		System.out.println("msg_subject >>> " + msg_subject);
		System.out.println("msg >>> " + msg);
		System.out.println("rent_l_cd >>> " + rent_l_cd);
		System.out.println("client_id >>> " + client_id);
		System.out.println("user_id >>> " + user_id);
		System.out.println("dest_gubun >>> " + dest_gubun);
		*/
		
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";			
		String cmid = "";
		String query2 = "";

		int i_msglen = AddUtil.lengthb(msg);				
		//80이상이면 장문자
		if(i_msglen>80 && msg_type.equals("1")) msg_type = "5";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc2, etc3, etc4, etc5 ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ?, ?, ?, ?, ?) ";


		try 
		{
			conn.setAutoCommit(false);
		
			if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid				);
				pstmt.setString(2, sendphone.trim()	);
				pstmt.setString(3, sendname.trim()	);
				pstmt.setString(4, destphone.trim()	);
				pstmt.setString(5, destname.trim()	);
				pstmt.setString(6, msg_type			);
				pstmt.setString(7, msg_subject.trim());
				pstmt.setString(8, msg.trim()		);
				pstmt.setString(9, rent_l_cd		);
				pstmt.setString(10,client_id		);
				pstmt.setString(11,user_id			);
				pstmt.setString(12,dest_gubun		);
				pstmt.executeUpdate();	
				pstmt.close();
			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail_V5]\n"+e);
				System.out.println("[sendphone	]\n"+sendphone	);
				System.out.println("[sendname	]\n"+sendname	);
				System.out.println("[destphone	]\n"+destphone	);
				System.out.println("[destname	]\n"+destname	);
				System.out.println("[msg_type	]\n"+msg_type	);
				System.out.println("[msg_subject]\n"+msg_subject);
				System.out.println("[msg		]\n"+msg		);
				System.out.println("[rent_l_cd	]\n"+rent_l_cd	);
				System.out.println("[client_id	]\n"+client_id	);
				System.out.println("[user_id	]\n"+user_id	);
				System.out.println("[dest_gubun	]\n"+dest_gubun	);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	//문자보내기
	public void insertsendMail_V5_req(String sendphone, String sendname, String destphone, String destname, String req_time, String rqdate, String msg_type, String msg_subject, String msg)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";			
		String cmid = "";
		String query2 = "";

		int i_msglen = AddUtil.lengthb(msg);				
		//80이상이면 장문자
		if(i_msglen>80 && msg_type.equals("1")) msg_type = "5";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc1 ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), to_date(to_char(to_date('"+req_time+"','YYYYMMDDhh24miss')"+rqdate+",'YYYYMMDDhh24miss')), 0, ?, ?, ?, 'req') ";

		try 
		{
			conn.setAutoCommit(false);
		
			if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid				);
				pstmt.setString(2, sendphone.trim()	);
				pstmt.setString(3, sendname.trim()	);
				pstmt.setString(4, destphone.trim()	);
				pstmt.setString(5, destname.trim()	);
				pstmt.setString(6, msg_type			);
				pstmt.setString(7, msg_subject.trim());
				pstmt.setString(8, msg.trim()		);
				pstmt.executeUpdate();	
				pstmt.close();
			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail_V5_req]\n"+e);
				System.out.println("[sendphone	]\n"+sendphone	);
				System.out.println("[sendname	]\n"+sendname	);
				System.out.println("[destphone	]\n"+destphone	);
				System.out.println("[destname	]\n"+destname	);
				System.out.println("[msg_type	]\n"+msg_type	);
				System.out.println("[msg_subject]\n"+msg_subject);
				System.out.println("[msg		]\n"+msg		);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	//문자보내기
	public void insertsendMail_V5_req_H(String sendphone, String sendname, String destphone, String destname, String req_time, String rqdate, String msg_type, String msg_subject, String msg, String rent_l_cd, String client_id, String user_id, String dest_gubun)
	{
		
		System.out.println("insertsendMail_V5_req_H >>> " );
			
		System.out.println("sendphone >>> " + sendphone);
		System.out.println("sendname >>> " + sendname);
		System.out.println("destphone >>> " + destphone);
		System.out.println("destname >>> " + destname);

		System.out.println("rqdate >>> " + rqdate);
		System.out.println("msg_type >>> " + msg_type);
		System.out.println("msg_subject >>> " + msg_subject);
		System.out.println("msg >>> " + msg);
		System.out.println("rent_l_cd >>> " + rent_l_cd);
		System.out.println("client_id >>> " + client_id);
		System.out.println("user_id >>> " + user_id);
		System.out.println("dest_gubun >>> " + dest_gubun);
		
		
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";			
		String cmid = "";
		String query2 = "";

		int i_msglen = AddUtil.lengthb(msg);				
		//80이상이면 장문자
		if(i_msglen>80 && msg_type.equals("1")) msg_type = "5";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc1, etc2, etc3, etc4, etc5 ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), to_date(to_char(to_date('"+req_time+"','YYYYMMDDhh24miss')"+rqdate+",'YYYYMMDDhh24miss')), 0, ?, ?, ?, 'req', ?, ?, ?, ?) ";

		try 
		{
			conn.setAutoCommit(false);
		
			if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid				);
				pstmt.setString(2, sendphone.trim()	);
				pstmt.setString(3, sendname.trim()	);
				pstmt.setString(4, destphone.trim()	);
				pstmt.setString(5, destname.trim()	);
				pstmt.setString(6, msg_type			);
				pstmt.setString(7, msg_subject.trim());
				pstmt.setString(8, msg.trim()		);
				pstmt.setString(9, rent_l_cd		);
				pstmt.setString(10,client_id		);
				pstmt.setString(11,user_id			);
				pstmt.setString(12,dest_gubun		);
				pstmt.executeUpdate();	
				pstmt.close();
			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail_V5_req]\n"+e);
				System.out.println("[sendphone	]\n"+sendphone	);
				System.out.println("[sendname	]\n"+sendname	);
				System.out.println("[destphone	]\n"+destphone	);
				System.out.println("[destname	]\n"+destname	);
				System.out.println("[msg_type	]\n"+msg_type	);
				System.out.println("[msg_subject]\n"+msg_subject);
				System.out.println("[msg		]\n"+msg		);
				System.out.println("[rent_l_cd	]\n"+rent_l_cd	);
				System.out.println("[client_id	]\n"+client_id	);
				System.out.println("[user_id	]\n"+user_id	);
				System.out.println("[dest_gubun	]\n"+dest_gubun	);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	/**
	 *	세금계산서 조회-
	 */	
	public Vector getCP_TaxEbillItemMail(String reg_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select "+
						"        reg_code, client_id, seq, reccoregno,				"+
                		"        agnt_email,										"+
                		"        replace(agnt_m_tel, '-', '') agnt_m_tel,			"+
                		"        min(recconame) recconame,							"+
                		"        substrb(min(recconame),1,20) recconame2,			"+
                		"        min(agnt_nm) agnt_nm,								"+
                		"        min(decode(car_st,'4',item_dt,tax_est_dt)) tax_dt,							"+
						"        substr(min(decode(car_st,'4',item_dt,tax_est_dt)),1,4) tax_year,				"+
						"        substr(min(decode(car_st,'4',item_dt,tax_est_dt)),5,2) tax_mon,				"+
                		"        count(0) cnt										"+  
         		        " from "+
         		        "        ( "+
                		"          select "+
                       	"                 a.client_id, a.seq, b.reg_code, f.car_st, "+
                       	"                 a.item_dt, a.tax_est_dt, "+
                       	"                 decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', nvl(h.con_agnt_nm,h.client_nm),nvl(g.agnt_nm,h.con_agnt_nm)      ) agnt_nm, "+
                       	"                 decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_email,              nvl(g.agnt_email,h.con_agnt_email)) agnt_email, "+
                       	"                 decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_m_tel,              nvl(g.agnt_m_tel,h.con_agnt_m_tel)) agnt_m_tel, "+
                       	"                 decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_dept,               nvl(g.agnt_dept ,h.con_agnt_dept) ) agnt_dept, "+
                       	"                 decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_title,              nvl(g.agnt_title,h.con_agnt_title)) agnt_title, "+
                       	"                 decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.tel,      '', h.o_tel,   g.tel    ), nvl(h.o_tel,h.h_tel)) rectel, "+
                       	"                 decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(TEXT_DECRYPT(g.enp_no, 'pw' ) ,   '', decode(h.client_st,'2',TEXT_DECRYPT(h.ssn, 'pw' ) ,h.enp_no),TEXT_DECRYPT(g.enp_no, 'pw' )),   decode(h.client_st,'2',TEXT_DECRYPT(h.ssn, 'pw' ),h.enp_no)) reccoregno, "+
                       	"                 decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.site_jang,'', decode(h.client_st,'2','',h.client_nm),g.site_jang),decode(h.client_st,'2','',h.client_nm)) reccoceo, "+
                       	"                 decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.r_site,   '', h.firm_nm,  g.r_site ),  h.firm_nm ) recconame "+
                		"          from   tax_item a, tax_item_list b, "+
                       	"                 client h, client_site g, "+
                       	"                 cont f "+
                		"          where  b.reg_code='"+reg_code+"' "+
                       	"                 and b.gubun='1' "+
                       	"                 and a.item_id=b.item_id "+
                       	"                 and a.client_id=h.client_id "+
                       	"                 and a.client_id=g.client_id(+) and a.seq=g.seq(+) "+
                       	"                 and b.rent_l_cd=f.rent_l_cd and b.car_mng_id=f.car_mng_id "+
                       	"                 and nvl(h.item_mail_yn,'Y')='Y' "+
         		        "        ) "+
         				" group by reg_code, client_id, seq, reccoregno, agnt_email, agnt_m_tel";


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
			System.out.println("[IssueDatabase:getCP_TaxEbillItemMail]\n"+e);
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
	 *	세금계산서 조회-
	 */	
	public Vector getCP_TaxEbill(String tax_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query =  " select "+
						"        a.tax_est_dt as tax_dt, "+
                		"        g.r_site as site_nm, h.client_st, "+
                		"        a.client_id, a.item_dt, "+
                		"        b.rent_l_cd, b.tm, b.car_mng_id, b.rent_st, b.rent_seq, e.rent_seq as max_rent_seq, "+
                		"        nvl(c.br_id,'S1') br_id, nvl(i.taxregno,'') taxregno, "+
                		"        i2.br_ent_no, i2.br_own_nm, i2.br_addr, i2.br_item, i2.br_sta, "+
                		"        e.item_supply as tax_supply, e.item_value as tax_value, a.item_id, "+
                		"        nvl(e.sum_s_amt1,0) sum_s_amt1, nvl(e.sum_s_amt2,0) sum_s_amt2, "+
                		"        nvl(e.sum_v_amt1,0) sum_v_amt1, nvl(e.sum_v_amt2,0) sum_v_amt2, "+
                		"        b.item_car_no as car_no, b.item_car_nm as car_nm, b.item_g, "+
                		"        nvl(a.seq,'') seq, "+
	            		"        e.cnt, e.gubun, "+
                		"        nvl(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')),'1') tax_type, "+
                		"        substrb(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', nvl(h.con_agnt_nm,h.client_nm),nvl(g.agnt_nm,h.con_agnt_nm)      ),1,30) agnt_nm, "+
                		"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_email,                      nvl(g.agnt_email,h.con_agnt_email)) agnt_email, "+
                		"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_m_tel,                      nvl(g.agnt_m_tel,h.con_agnt_m_tel)) agnt_m_tel, "+
                		"        substrb(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_dept,               nvl(g.agnt_dept ,h.con_agnt_dept) ),1,30) agnt_dept, "+
                		"        substrb(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '1', h.con_agnt_title,              nvl(g.agnt_title,h.con_agnt_title)),1,20) agnt_title, "+
                		"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.tel,      '', h.o_tel,   g.tel    ), nvl(h.o_tel,h.h_tel)) rectel, "+
                    	"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(TEXT_DECRYPT(g.enp_no, 'pw' ) ,   '', decode(h.client_st,'2',TEXT_DECRYPT(h.ssn, 'pw' ) ,h.enp_no),TEXT_DECRYPT(g.enp_no, 'pw' )),   decode(h.client_st,'2',TEXT_DECRYPT(h.ssn, 'pw' ),h.enp_no)) reccoregno, "+
                		"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.site_jang,'', h.client_nm,g.site_jang),h.client_nm) reccoceo, "+
                		"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.r_site,   '', h.firm_nm,  g.r_site ),  h.firm_nm ) recconame, "+
                		"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.addr,     '', h.o_addr,   g.addr   ),  h.o_addr  ) reccoaddr, "+
                		"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', g.bus_cdt,  h.bus_cdt ) reccobiztype, "+
                		"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', g.bus_itm,  h.bus_itm ) reccobizsub, "+
                		"        decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.ven_code, '', h.ven_code, g.ven_code), h.ven_code) ven_code, "+
                		"        substrb(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.r_site,   '',h.firm_nm, g.r_site), h.firm_nm ),1,70) recconame2, "+
                		"        substrb(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', decode(g.site_jang,'', h.client_nm,g.site_jang),h.client_nm),1,30) reccoceo2, "+
                		"        substrb(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', g.bus_cdt, h.bus_cdt ),1,40) reccobiztype2, "+
                		"        substrb(decode(decode(b.rent_seq,'1',f.tax_type,decode(a.seq,'',f.tax_type,'2')), '2', g.bus_itm, h.bus_itm ),1,40) reccobizsub2, "+
                		"        h.app_yn, h.bigo_yn, "+
                		"        decode(to_char(b.reg_dt,'YYYYMMDD'),to_char(sysdate,'YYYYMMDD'),'','기발행') doc_st "+
         		        " from   tax_item a, tax_item_list b, "+
                		"        ( select item_id, "+
                        "                 count(item_seq)  cnt, "+
                        "                 max(gubun)       gubun, "+
                        "                 max(rent_seq)    rent_seq, "+
                        "                 sum(item_supply) item_supply, "+
                        "                 sum(item_value)  item_value, "+
						"                 sum(decode(nvl(car_use,'1'),'1', item_supply)) sum_s_amt1, "+
						"                 sum(decode(nvl(car_use,'1'),'2', item_supply)) sum_s_amt2, "+
						"                 sum(decode(nvl(car_use,'1'),'1', item_value))  sum_v_amt1, "+
						"                 sum(decode(nvl(car_use,'1'),'2', item_value))  sum_v_amt2 "+
                  		"          from   tax_item_list "+
                  		"          where  gubun='1' "+
                  		"          group by item_id "+
                		"        ) e, "+
                		"        client h, client_site g, "+
                		"        scd_fee d, fee c, cont f, "+
                		"        branch i, branch i2, "+
                		"        (select * from tax where tax_st<>'C') t "+
        				" where  a.tax_code='"+tax_code+"' "+
                		"        and nvl(a.use_yn,'Y')='Y' "+
                		"        and a.item_id=b.item_id and b.item_seq=1 "+
                		"        and a.item_id=e.item_id "+
                		"        and a.client_id=h.client_id "+
                		"        and a.client_id=g.client_id(+) and a.seq=g.seq(+) "+
                		"        and b.rent_l_cd=d.rent_l_cd and b.tm=d.fee_tm and b.rent_st=d.rent_st and b.rent_seq=d.rent_seq and d.tm_st1='0' "+
                		"        and d.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st "+
                		"        and c.rent_mng_id=f.rent_mng_id and c.rent_l_cd=f.rent_l_cd "+
	            		"        and c.br_id=i.br_id "+
	            		"        and 'S1'=i2.br_id "+
                		"        and a.item_id=t.item_id(+) "+
                		"        and t.tax_no is null";


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
			System.out.println("[IssueDatabase:getCP_TaxEbill]\n"+e);
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

	//문자보내기
	public void updatesendMail_V5_req(String cmid, String destphone, String destname, String req_time, String msg)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "";
			

        query=" update ums_data set "+
				"      dest_phone=replace(?,'-',''), dest_name=?, request_time=?, msg_body=? "
            + " where  "+
				"      cmid=? and status=0";


		try 
		{
			conn.setAutoCommit(false);
		
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, destphone.trim()	);
				pstmt.setString(2, destname.trim()	);
				pstmt.setString(3, req_time			);
				pstmt.setString(4, msg.trim()		);
				pstmt.setString(5, cmid				);
				pstmt.executeUpdate();	
				pstmt.close();

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:updatesendMail_V5_req]\n"+e);
				System.out.println("[destphone]\n"+destphone);
				System.out.println("[destname ]\n"+destname );
				System.out.println("[msg      ]\n"+msg      );
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	/**
	 *	거래명세서 리스트 한건 조회
	 *  
	 */	
	public TaxItemListBean getTaxItemListScdFeeCase(String item_id, String rent_l_cd, String tm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxItemListBean bean = new TaxItemListBean();
		String query = "";

		query = " select * from tax_item_list where item_id=? and rent_l_cd=? and tm=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	item_id);
			pstmt.setString	(2,	rent_l_cd);
			pstmt.setString	(3,	tm);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setItem_id		(rs.getString(1));
				bean.setItem_seq	(rs.getInt(2));
				bean.setItem_g		(rs.getString(3));
				bean.setItem_car_no	(rs.getString(4));
				bean.setItem_car_nm	(rs.getString(5));
				bean.setItem_dt1	(rs.getString(6));
				bean.setItem_dt2	(rs.getString(7));
				bean.setItem_supply	(rs.getInt(8));
				bean.setItem_value	(rs.getInt(9));
				bean.setRent_l_cd	(rs.getString(10));
				bean.setCar_mng_id	(rs.getString(11));
				bean.setTm			(rs.getString(12));
				bean.setGubun		(rs.getString(13));
				bean.setReg_dt		(rs.getString(14));
				bean.setReg_id		(rs.getString(15));
				bean.setReg_code	(rs.getString(16));
				bean.setRent_st		(rs.getString(17));
				bean.setRent_seq	(rs.getString(18));
				bean.setCar_use		(rs.getString(19));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemListCase(String item_id, String rent_l_cd, String tm)]\n"+e);
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
	 *	정기청구-개별 :계약건별 일괄발행리스트
	 *  
	 */	
	public Vector getIssue1TaxItemSearchList(String firm_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+

				"        decode(e.fee_s_amt+e.fee_v_amt,e2.rc_amt,'수금',decode(t.cls_st,'8','매입옵션','2','중도해지','1','계약만료','4','차종변경','5','계약승계','',decode(g.rent_l_cd,'','','발행중지'),'해지')) as use_yn, \n"+
				"        t.cls_st, a.brch_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, \n"+
				"        nvl(m.firm_nm,b.firm_nm) firm_nm, d.r_site as site_nm, c.car_no, c.car_nm, \n"+
				"        e.rent_st, e.rent_seq, e.fee_tm, e.fee_s_amt, e.fee_v_amt, (e.fee_s_amt+e.fee_v_amt) fee_amt, e.fee_est_dt, e.r_fee_est_dt, e.use_s_dt, e.use_e_dt, \n"+
				"        e.req_dt, e.r_req_dt as r_req_dt, e.tax_out_dt, c.car_use \n"+

				" from   cont a, client b, car_reg c, client_site d, scd_fee e, cls_cont t, cont_etc i, \n"+

				"        /*기발행계산서*/( select a.* from tax_item_list a, (select a.* from tax a, tax b where a.doctype is null and a.tax_no=b.m_tax_no(+) and decode(b.doctype,'04','C',a.tax_st)<>'C') b where a.ITEM_SUPPLY>0 and a.gubun='1' and a.item_id=b.item_id and b.m_tax_no is null ) f, \n"+
				"        /*기발행청구서*/( select a.* from tax_item_list a, (select a.* from tax a, tax b where a.doctype is null and a.tax_no=b.m_tax_no(+) and decode(b.doctype,'04','C',a.tax_st)<>'C') b, tax_item c, tax d where a.ITEM_SUPPLY>0 and a.gubun='1' and a.item_id=b.item_id(+) and a.item_id=c.item_id and nvl(c.use_yn,'Y')='Y' and b.tax_no is null and c.tax_no=d.m_tax_no(+) and nvl(d.doctype,'00')<>'04') h, \n"+

				"        /*발행중지여부*/( select * from scd_fee_stop where decode(stop_st,'1',nvl(cancel_dt,'99999999'),nvl(stop_e_dt,cancel_dt)) > to_char(sysdate,'YYYYMMDD') ) g, \n"+
				"        /*분할청구업체*/( select a.*, decode(a.r_site,'',b.firm_nm, c.r_site) firm_nm, b.client_nm, c.site_jang from fee_rtn a, client b, client_site c where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+) ) m, \n"+
				"        /*대여료수금시*/( select rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq, sum(rc_amt) rc_amt from scd_fee where rc_yn='1' group by rent_mng_id, rent_l_cd, fee_tm, rent_st, rent_seq ) e2 \n"+

				" where \n"+
				"        a.client_id=b.client_id "+
				"	     and nvl(b.print_st,'1')<>'9' \n"+ //타시스템발행외
				"        and a.car_mng_id=c.car_mng_id(+) \n"+ //출고지연스케줄일 경우 신차등록전일수도 있음.
				"        and a.client_id=d.client_id(+) and a.r_site=d.seq(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.tm_st1='0' \n"+
				"        and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) "+
				"	     and nvl(t.cls_st,'0') in ('0','3','4','5','6','7','9','10','14','15')  \n"+
				"        and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) \n"+
				"        and e.rent_l_cd=f.rent_l_cd(+) and e.fee_tm=f.tm(+) and f.rent_l_cd is null \n"+
				"        and e.rent_l_cd=h.rent_l_cd(+) and e.fee_tm=h.tm(+) and h.rent_l_cd is null \n"+
				"        and e.rent_mng_id=e2.rent_mng_id(+) and e.rent_l_cd=e2.rent_l_cd(+) and e.fee_tm=e2.fee_tm(+) and e.rent_st=e2.rent_st(+) and e.rent_seq=e2.rent_seq(+) \n"+
				"        and e.rent_mng_id=g.rent_mng_id(+) and e.rent_l_cd=g.rent_l_cd(+) and e.rent_seq=g.rent_seq(+) and decode(e.fee_s_amt+e.fee_v_amt,e2.rc_amt,'',g.rent_l_cd) is null \n"+
				"        and e.rent_mng_id=m.rent_mng_id(+) and e.rent_l_cd=m.rent_l_cd(+) and e.rent_st=m.rent_st(+) and e.rent_seq=m.rent_seq(+) \n"+
				"        and nvl(e.bill_yn,'Y')='Y' and e.fee_est_dt > '20051001' and e.fee_s_amt>0 "+
				"        and nvl(i.ele_tax_st,'1') ='1'"+ //당사시스템 사용업체
				"        and a.rent_l_cd not in ('B108HXBL00011','S106HU3L00014', 'B109HTGR00059')"+//별도시스템 사용업체
				"        and a.rent_l_cd not in ('S107SL5R00035','S105HRFL00013','S105HJML00011')"+//해지로 미대상
				"	";

		//2010년세금일자부터
		query += " and e.tax_out_dt > '20091231'";


		if(!firm_nm.equals(""))		query += " and b.firm_nm like '%"+firm_nm+"%'";

		query += " and e.r_req_dt<=to_char(sysdate,'YYYYMMDD')";


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
			System.out.println("[IssueDatabase:getIssue1TaxItemSearchList]\n"+e);
			System.out.println("[IssueDatabase:getIssue1TaxItemSearchList]\n"+query);
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
	 *	정기청구-개별 :계약건별 일괄발행리스트
	 *  
	 */	
	public Vector getIssue1TaxItemClsSearchList(String firm_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+

				"        decode(t.cls_st,'8','매입옵션','2','중도해지','1','계약만료','4','차종변경','5','계약승계','') as use_yn, \n"+
				"        t.cls_st, a.brch_id, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.r_site as site_id, \n"+
				"        b.firm_nm, d.r_site as site_nm, c.car_no, c.car_nm, c.car_use, t.cls_dt \n"+

				" from   cont a, client b, car_reg c, client_site d, cls_cont t, cont_etc i \n"+

				" where \n"+
				"        a.client_id=b.client_id "+
				"	     and nvl(b.print_st,'1')<>'9' \n"+ //타시스템발행외
				"        and a.car_mng_id=c.car_mng_id(+) \n"+ //출고지연스케줄일 경우 신차등록전일수도 있음.
				"        and a.client_id=d.client_id(+) and a.r_site=d.seq(+) \n"+
				"        and a.rent_mng_id=t.rent_mng_id and a.rent_l_cd=t.rent_l_cd and t.cls_st in ('1','2')\n"+
				"        and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) \n"+
				"        and nvl(i.ele_tax_st,'1') ='1'"+ //당사시스템 사용업체
				"        and a.rent_l_cd not in ('B108HXBL00011','S106HU3L00014', 'B109HTGR00059')"+//별도시스템 사용업체
				"        and a.rent_l_cd not in ('S107SL5R00035','S105HRFL00013','S105HJML00011')"+//해지로 미대상
				"	";

		//2010년해지일자부터
		query += " and t.cls_dt > '20091231'";


		if(!firm_nm.equals(""))		query += " and b.firm_nm like '%"+firm_nm+"%'";

		query += " and t.cls_dt>=to_char(sysdate-60,'YYYYMMDD')";


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
			System.out.println("[IssueDatabase:getIssue1TaxItemClsSearchList]\n"+e);
			System.out.println("[IssueDatabase:getIssue1TaxItemClsSearchList]\n"+query);
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
	 *	대여료정기발행에 면책금 추가분 조회
	 *  
	 */	
	public Vector getIssue1TaxItemServSearchList(String firm_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        c.use_yn, \n"+
				"        b.serv_id, b.accid_id, c.brch_id, b.rent_mng_id, b.rent_l_cd, b.car_mng_id, decode(a.rent_s_cd,'',d.client_id,j.client_id) client_id, '' site_id, \n"+
				"        decode(a.rent_s_cd,'',d.firm_nm,j.firm_nm) firm_nm, '' site_nm, e.car_no, e.car_nm, e.car_use, \n"+
				"        b.serv_dt, g.ext_s_amt, g.ext_v_amt, (g.ext_s_amt+g.ext_v_amt) ext_amt, g.ext_est_dt \n"+
				" from   service b, accident a, cont c, client d, car_reg e, serv_off f, \n"+

							  //20110330 거래명세서&세금계산서
					 "        ( select a.rent_l_cd, a.car_mng_id, a.tm, sum(item_supply+item_value) item_amt, \n"+
					 "                 min(b.item_id) item_id, min(b.item_dt) item_dt, min(b.tax_est_dt) tax_est_dt, \n"+
					 "                 min(c.tax_no) tax_no, min(c.tax_dt) tax_dt, min(c.reg_dt) reg_dt, min(c.print_dt) print_dt \n"+
					 "          from   tax_item_list a, tax_item b, tax c \n"+
					 "          where  a.gubun='7' \n"+
					 "                 and a.item_id=b.item_id and a.item_id=c.item_id and nvl(c.tax_st,'O')<>'C' \n"+
					 "          group by a.rent_l_cd, a.car_mng_id, a.tm \n"+
					 "	      ) k, \n"+

				"        rent_cont i, client j, \n"+
				"        (select * from scd_ext where ext_st='3' and ext_tm='1') g  \n"+
				" where  b.car_mng_id=a.car_mng_id(+) and b.accid_id=a.accid_id(+) and nvl(b.bill_doc_yn,'1')='1' \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and b.car_mng_id=e.car_mng_id(+) \n"+
				"        and b.serv_id=f.off_id(+) \n"+
				"        and a.rent_s_cd=i.rent_s_cd(+) and i.cust_id=j.client_id(+) \n"+
				"        and b.cust_amt <>0 and nvl(b.no_dft_yn,'N')<>'Y' and nvl(b.bill_yn,'Y')='Y' \n"+
				"        and b.rent_l_cd=k.rent_l_cd(+) and b.serv_id=k.tm(+) and b.car_mng_id=k.car_mng_id(+) and b.cust_amt=k.item_amt(+)"+
				"        and b.rent_mng_id=g.rent_mng_id and b.rent_l_cd=g.rent_l_cd and b.serv_id=g.ext_id \n"+
				" ";

		//20100631 청구분부터
		query += " and b.cust_req_dt > '20100631'";

		if(!firm_nm.equals(""))		query += " and decode(a.rent_s_cd,'',d.firm_nm,j.firm_nm) like '%"+firm_nm+"%'";

		query += " and nvl(b.serv_dt,b.reg_dt)>=to_char(sysdate-100,'YYYYMMDD')";


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
			System.out.println("[IssueDatabase:getIssue1TaxItemServSearchList]\n"+e);
			System.out.println("[IssueDatabase:getIssue1TaxItemServSearchList]\n"+query);
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

	//문자보내기
	public void deletesendMail_V5_req(String cmid)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "";
			

        query=" delete from ums_data where cmid=? and status=0";


		try 
		{
			conn.setAutoCommit(false);
		
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid		);
				pstmt.executeUpdate();	
				pstmt.close();

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:deletesendMail_V5_req]\n"+e);
				System.out.println("[cmid     ]\n"+cmid);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	public TaxItemListBean getTaxItemListServM(String car_mng_id, String tm, int cust_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxItemListBean bean = new TaxItemListBean();
		String query = "";

		query = " select a.* "+
				" from   tax_item_list a "+
				" where  a.gubun='7' and a.car_mng_id=? and a.tm=? and a.item_supply+a.item_value=? "+
				" and    a.reg_code=(select max(reg_code) from tax_item_list where car_mng_id=? and tm=? and item_supply+item_value=?) "+
				" ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	car_mng_id);
			pstmt.setString	(2,	tm);
			pstmt.setInt	(3,	cust_amt);
			pstmt.setString	(4,	car_mng_id);
			pstmt.setString	(5,	tm);
			pstmt.setInt	(6,	cust_amt);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setItem_id		(rs.getString(1));
				bean.setItem_seq	(rs.getInt(2));
				bean.setItem_g		(rs.getString(3));
				bean.setItem_car_no	(rs.getString(4));
				bean.setItem_car_nm	(rs.getString(5));
				bean.setItem_dt1	(rs.getString(6));
				bean.setItem_dt2	(rs.getString(7));
				bean.setItem_supply	(rs.getInt(8));
				bean.setItem_value	(rs.getInt(9));
				bean.setRent_l_cd	(rs.getString(10));
				bean.setCar_mng_id	(rs.getString(11));
				bean.setTm			(rs.getString(12));
				bean.setGubun		(rs.getString(13));
				bean.setReg_dt		(rs.getString(14));
				bean.setReg_id		(rs.getString(15));
				bean.setReg_code	(rs.getString(16));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemListServM(String car_mng_id, String tm, int cust_amt)]\n"+e);
			System.out.println("[IssueDatabase:getTaxItemListServM(String car_mng_id, String tm, int cust_amt)]\n"+query);
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

	//비고변동값 변화
	public void updateClientBigoValue2Add(String client_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "";
			

        query = " update client set bigo_value2=bigo_value2+1 where client_id=?";


		try 
		{
			conn.setAutoCommit(false);
		
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
				pstmt.executeUpdate();	
				pstmt.close();

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:updateClientBigoValue2Add]\n"+e);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}


	public TaxItemListBean getTaxItemListCls(String rent_l_cd, String item_g )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxItemListBean bean = new TaxItemListBean();
		String query = "";

		query = " select a.* "+
				" from   tax_item_list a "+
				" where  a.gubun='15' and  a.rent_l_cd = ? and a.item_g=?  "+
				" and    a.reg_code=(select max(reg_code) from tax_item_list where rent_l_cd=? and item_g=? ) "+
				" ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	rent_l_cd);
			pstmt.setString	(2,	item_g);		
			pstmt.setString	(3,	rent_l_cd);
			pstmt.setString	(4,	item_g);
			
	    		rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setItem_id		(rs.getString(1));
				bean.setItem_seq	(rs.getInt(2));
				bean.setItem_g		(rs.getString(3));
				bean.setItem_car_no	(rs.getString(4));
				bean.setItem_car_nm	(rs.getString(5));
				bean.setItem_dt1	(rs.getString(6));
				bean.setItem_dt2	(rs.getString(7));
				bean.setItem_supply	(rs.getInt(8));
				bean.setItem_value	(rs.getInt(9));
				bean.setRent_l_cd	(rs.getString(10));
				bean.setCar_mng_id	(rs.getString(11));
				bean.setTm			(rs.getString(12));
				bean.setGubun		(rs.getString(13));
				bean.setReg_dt		(rs.getString(14));
				bean.setReg_id		(rs.getString(15));
				bean.setReg_code	(rs.getString(16));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemListCls(String car_mng_id, String tm, int cust_amt)]\n"+e);
			System.out.println("[IssueDatabase:getTaxItemListCls(String car_mng_id, String tm, int cust_amt)]\n"+query);
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

	//문자보내기
	public void insertsendMail_V5_H2(String sendphone, String sendname, String destphone, String destname, String tax_mon, String rqdate, String msg_type, String msg_subject, String msg, String rent_l_cd, String client_id, String user_id, String dest_gubun, String check, String bus_id, String score)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String query = "";			
		String cmid = "";
		String query2 = "";
		String query3 = "";

		int i_msglen = AddUtil.lengthb(msg);				
		//80이상이면 장문자
		if(i_msglen>80 && msg_type.equals("1")) msg_type = "5";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc2, etc3, etc4, etc5 ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ?, ?, ?, ?, ?) ";

        query3 = " INSERT INTO CREDIT_SCORE "+
				 " ( cmid, UMID, dest_phone, dest_name, status, msg_type, subject, msg_body, BUS_ID, SCORE, MMS_GB, REG_ID, REG_DT) "
               + " VALUES "+
				 " ( ?, 0, replace(?,'-',''), substr(?,1,10), 0, ?, ?, ?, ?, ?, ?, ?, sysdate) ";
		
		try 
		{
			conn.setAutoCommit(false);
		
			if(check.equals("")){
				if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

					pstmt2 = conn.prepareStatement(query2);
					rs = pstmt2.executeQuery();
		
					if(rs.next())
					{				
						cmid = rs.getString(1);
					}
					rs.close();
					pstmt2.close();

					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, cmid				);
					pstmt.setString(2, sendphone.trim()	);
					pstmt.setString(3, sendname.trim()	);
					pstmt.setString(4, destphone.trim()	);
					pstmt.setString(5, destname.trim()	);
					pstmt.setString(6, msg_type			);
					pstmt.setString(7, msg_subject.trim());
					pstmt.setString(8, msg.trim()		);
					pstmt.setString(9, rent_l_cd		);
					pstmt.setString(10,client_id		);
					pstmt.setString(11,user_id			);
					pstmt.setString(12,dest_gubun		);
					pstmt.executeUpdate();	
					pstmt.close();

					pstmt3 = conn.prepareStatement(query3);
					pstmt3.setString(1, cmid				);
					pstmt3.setString(2, destphone.trim()	);
					pstmt3.setString(3, destname.trim()	);
					pstmt3.setString(4, msg_type			);
					pstmt3.setString(5, msg_subject.trim());
					pstmt3.setString(6, msg.trim()		);
					pstmt3.setString(7, bus_id.trim()		);
					pstmt3.setString(8,score.trim()		);
					pstmt3.setString(9,check.trim()		);
					pstmt3.setString(10,user_id			);
					pstmt3.executeUpdate();	
					pstmt3.close();

				}
			}else{

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt3 = conn.prepareStatement(query3);
				pstmt3.setString(1, cmid				);
				pstmt3.setString(2, destphone.trim()	);
				pstmt3.setString(3, destname.trim()	);
				pstmt3.setString(4, msg_type			);
				pstmt3.setString(5, msg_subject.trim());
				pstmt3.setString(6, msg.trim()		);
				pstmt3.setString(7, bus_id.trim()		);
				pstmt3.setString(8, score.trim()		);
				pstmt3.setString(9,check.trim()		);
				pstmt3.setString(10,user_id			);
				pstmt3.executeUpdate();	
				pstmt3.close();

			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail_V5]\n"+e);
				System.out.println("[sendphone	]\n"+sendphone	);
				System.out.println("[sendname	]\n"+sendname	);
				System.out.println("[destphone	]\n"+destphone	);
				System.out.println("[destname	]\n"+destname	);
				System.out.println("[msg_type	]\n"+msg_type	);
				System.out.println("[msg_subject]\n"+msg_subject);
				System.out.println("[msg		]\n"+msg		);
				System.out.println("[rent_l_cd	]\n"+rent_l_cd	);
				System.out.println("[client_id	]\n"+client_id	);
				System.out.println("[user_id	]\n"+user_id	);
				System.out.println("[dest_gubun	]\n"+dest_gubun	);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt3 != null)	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	//문자보내기
	public void insertsendMail_V5_H2(String sendphone, String sendname, String destphone, String destname, String tax_mon, String rqdate, String msg_type, String msg_subject, String msg, String rent_l_cd, String client_id, String user_id, String dest_gubun, String check, String bus_id, String score, String score2, String key_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String query = "";			
		String cmid = "";
		String query2 = "";
		String query3 = "";

		int i_msglen = AddUtil.lengthb(msg);				
		//80이상이면 장문자
		if(i_msglen>80 && msg_type.equals("1")) msg_type = "5";

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  cmid like to_char(sysdate,'YYYYMMDDhh24miss')||'%'";

        query = " INSERT INTO ums_data ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc2, etc3, etc4, etc5 ) "+
                "        VALUES        ( ?||uds_seq.NEXTVAL, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ?, ?, ?, ?, ?) ";

        query3 = " INSERT INTO CREDIT_SCORE "+
				 " ( cmid, UMID, dest_phone, dest_name, status, msg_type, subject, msg_body, BUS_ID, SCORE, SCORE2, MMS_GB, REG_ID, REG_DT, key_no) "
               + " VALUES "+
				 " ( ?, 0, replace(?,'-',''), ?, 0, ?, ?, ?, ?, ?, ?, ?, ?, sysdate, ?) ";

		try 
		{
			conn.setAutoCommit(false);
		
			if(check.equals("")){
				if(!msg.equals("") && !destphone.equals("") && !destphone.equals("-") ){

					pstmt2 = conn.prepareStatement(query2);
					rs = pstmt2.executeQuery();
		
					if(rs.next())
					{				
						cmid = rs.getString(1);
					}
					rs.close();
					pstmt2.close();

					pstmt = conn.prepareStatement(query);
					pstmt.setString(1, cmid				);
					pstmt.setString(2, sendphone.trim()	);
					pstmt.setString(3, sendname.trim()	);
					pstmt.setString(4, destphone.trim()	);
					pstmt.setString(5, destname.trim()	);
					pstmt.setString(6, msg_type			);
					pstmt.setString(7, msg_subject.trim());
					pstmt.setString(8, msg.trim()		);
					pstmt.setString(9, rent_l_cd		);
					pstmt.setString(10,client_id		);
					pstmt.setString(11,user_id			);
					pstmt.setString(12,dest_gubun.trim()		);
					pstmt.executeUpdate();	
					pstmt.close();

					pstmt3 = conn.prepareStatement(query3);
					pstmt3.setString(1, cmid				);
					pstmt3.setString(2, destphone.trim()	);
					pstmt3.setString(3, destname.trim()	);
					pstmt3.setString(4, msg_type			);
					pstmt3.setString(5, msg_subject.trim());
					pstmt3.setString(6, msg.trim()		);
					pstmt3.setString(7, bus_id.trim()		);
					pstmt3.setString(8,score.trim()		);
					pstmt3.setString(9,score2.trim()		);
					pstmt3.setString(10,check.trim()		);
					pstmt3.setString(11,user_id			);
					pstmt3.executeUpdate();	
					pstmt3.close();

				}
			}else{

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt3 = conn.prepareStatement(query3);
				pstmt3.setString(1, cmid				);
				pstmt3.setString(2, dest_gubun.trim()	);
				pstmt3.setString(3, destname.trim()	);
				pstmt3.setString(4, msg_type			);
				pstmt3.setString(5, msg_subject.trim());
				pstmt3.setString(6, msg.trim()		);
				pstmt3.setString(7, bus_id.trim()		);
				pstmt3.setString(8, score.trim()		);
				pstmt3.setString(9, score2.trim()		);
				pstmt3.setString(10,check.trim()		);
				pstmt3.setString(11,user_id			);
				pstmt3.setString(12,key_no			);
				pstmt3.executeUpdate();	
				pstmt3.close();

			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:insertsendMail_V5]\n"+e);
				System.out.println("[IssueDatabase:insertsendMail_V5]\n"+e);
				System.out.println("[sendphone	]\n"+sendphone	);
				System.out.println("[sendname	]\n"+sendname	);
				System.out.println("[destphone	]\n"+destphone	);
				System.out.println("[destname	]\n"+destname	);
				System.out.println("[msg_type	]\n"+msg_type	);
				System.out.println("[msg_subject]\n"+msg_subject);
				System.out.println("[msg		]\n"+msg		);
				System.out.println("[rent_l_cd	]\n"+rent_l_cd	);
				System.out.println("[client_id	]\n"+client_id	);
				System.out.println("[user_id	]\n"+user_id	);
				System.out.println("[dest_gubun	]\n"+dest_gubun	);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt3 != null)	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
		}			
	}


//신용조회 문자 보낸 내용 수정./의뢰자, 신용등급
	public void updatesendMail_V5_H2(String cmid, String user_id, String bus_id, String score, String score2, String destname, String msg)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "";
			

        query=" update credit_score set "+
				"      reg_dt=sysdate, reg_id=?, bus_id=?, score=?, score2=?, DEST_NAME = ?, msg_body = ?  " +
	            " where   cmid=? ";


		try 
		{
			conn.setAutoCommit(false);
		
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, user_id.trim()	);
				pstmt.setString(2, bus_id.trim()	);
				pstmt.setString(3, score.trim()		);
				pstmt.setString(4, score2.trim()		);
				pstmt.setString(5, destname.trim()		);
				pstmt.setString(6, msg.trim()		);
				pstmt.setString(7, cmid				);

				pstmt.executeUpdate();	
				pstmt.close();

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[IssueDatabase:updatesendMail_V5_H2]\n"+e);
				System.out.println("[user_id]\n"+user_id);
				System.out.println("[bus_id ]\n"+bus_id );
				System.out.println("[score      ]\n"+score      );
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}

	/**
	 *	2-6단계 : 거래명세서 리스트 item_id 한건 조회
	 *  
	 */	
	public Vector getTaxItemKiCase(String item_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from tax_item_ki where item_id=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	item_id);
	    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{			
				TaxItemKiBean bean = new TaxItemKiBean();
				bean.setItem_id			(rs.getString(1));
				bean.setItem_ki_seq		(rs.getInt   (2));
				bean.setItem_ki_g		(rs.getString(3));
				bean.setItem_ki_app		(rs.getString(4));
				bean.setItem_ki_pr		(rs.getInt   (5));
				bean.setItem_ki_bigo	(rs.getString(6));
				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemKiCase(String item_id)]\n"+e);
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

	public String getOrgNtsIssueid(String resseq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String nts_issueid = "";
		String query = "";

		query = " SELECT DECODE(b.pubcode,'',a.NTS_ISSUEID,b.NTS_ISSUEID) AS NTS_ISSUEID "+
                " FROM   SALEEBILL a, (SELECT pubcode, max(nts_issueid) nts_issueid FROM EB_NTS_HIST WHERE nts_stat='30' GROUP BY pubcode) b  "+
                " WHERE  a.resseq='"+resseq+"' AND a.pubcode=b.pubcode(+)  "+
			    " ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				nts_issueid = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getOrgNtsIssueid]\n"+e);
	  		e.printStackTrace();
			
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return nts_issueid;
		}		
	}


/**
	 *	6-1단계 : 세금계산서 조회(매출취소를 위한)
	 *  
	 */	
	public TaxBean getTax(String tax_no, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		tax.TaxBean bean = new TaxBean();
		String query = "";

		query = " select rent_l_cd, client_id, tax_dt, fee_tm, car_mng_id,"+
				"        nvl(unity_chk,'0') unity_chk, branch_g, tax_g, tax_supply, tax_value,"+
				"        tax_id, item_id, tax_bigo, seq, tax_no,"+
				"        car_nm, car_no, reg_dt, reg_id, print_dt,"+
				"        print_id, autodocu_write_date, autodocu_data_no, nvl(tax_st,'O') tax_st, m_tax_no,"+
				"        tax_type, gubun, resseq, mail_dt,"+
				"        con_agnt_nm, con_agnt_dept, con_agnt_title, con_agnt_email, con_agnt_m_tel, branch_g2,"+
				"        rectel, reccoregno, recconame, reccoceo, reccoaddr, reccobiztype, reccobizsub, reccossn, taxregno, reccoregnotype, "+
				"        doctype, pubform, reccotaxregno, etax_item_st, "+
				"        con_agnt_nm2, con_agnt_dept2, con_agnt_title2, con_agnt_email2, con_agnt_m_tel2 "+
				" from tax_"+gubun2+" where tax_no=?";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	tax_no);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{			
				bean.setRent_l_cd		(rs.getString(1));
				bean.setClient_id		(rs.getString(2));
				bean.setTax_dt			(rs.getString(3));
				bean.setFee_tm			(rs.getString(4));
				bean.setCar_mng_id		(rs.getString(5));
				bean.setUnity_chk		(rs.getString(6));
				bean.setBranch_g		(rs.getString(7));
				bean.setTax_g			(rs.getString(8));
				bean.setTax_supply		(rs.getInt(9));
				bean.setTax_value		(rs.getInt(10));
				bean.setTax_id			(rs.getString(11));
				bean.setItem_id			(rs.getString(12));
				bean.setTax_bigo		(rs.getString(13));
				bean.setSeq				(rs.getString(14));
				bean.setTax_no			(rs.getString(15));
				bean.setCar_nm			(rs.getString(16));
				bean.setCar_no			(rs.getString(17));
				bean.setReg_dt			(rs.getString(18));
				bean.setReg_id			(rs.getString(19));
				bean.setPrint_dt		(rs.getString(20));
				bean.setPrint_id		(rs.getString(21));
				bean.setAutodocu_write_date(rs.getString(22));
				bean.setAutodocu_data_no(rs.getString(23));
				bean.setTax_st			(rs.getString(24));
				bean.setM_tax_no		(rs.getString(25));
				bean.setTax_type		(rs.getString(26));
				bean.setGubun			(rs.getString(27));
				bean.setResseq			(rs.getString(28));
				bean.setMail_dt			(rs.getString(29));
				bean.setCon_agnt_nm		(rs.getString(30));
				bean.setCon_agnt_dept	(rs.getString(31));
				bean.setCon_agnt_title	(rs.getString(32));
				bean.setCon_agnt_email	(rs.getString(33));
				bean.setCon_agnt_m_tel	(rs.getString(34));
				bean.setBranch_g2		(rs.getString(35));
				bean.setRecTel			(rs.getString(36));
				bean.setRecCoRegNo		(rs.getString(37));
				bean.setRecCoName		(rs.getString(38));
				bean.setRecCoCeo		(rs.getString(39));
				bean.setRecCoAddr		(rs.getString(40));
				bean.setRecCoBizType	(rs.getString(41));
				bean.setRecCoBizSub		(rs.getString(42));
				bean.setRecCoSsn		(rs.getString(43));
				bean.setTaxregno		(rs.getString(44));
				bean.setReccoregnotype	(rs.getString(45));
				bean.setDoctype			(rs.getString(46));
				bean.setPubForm			(rs.getString(47));
				bean.setRecCoTaxRegNo	(rs.getString(48));
				bean.setEtax_item_st	(rs.getString(49));
				bean.setCon_agnt_nm2	(rs.getString(50));
				bean.setCon_agnt_dept2	(rs.getString(51));
				bean.setCon_agnt_title2	(rs.getString(52));
				bean.setCon_agnt_email2	(rs.getString(53));
				bean.setCon_agnt_m_tel2	(rs.getString(54));


			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTax(String tax_no, String gubun2)]\n"+e);
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
	 *	4-2단계 : 거래명세서 한건 조회
	 *  
	 */	
	public TaxItemBean getTaxItemCase(String item_id, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxItemBean bean = new TaxItemBean();
		String query = "";

		query = " select * from tax_item_"+gubun2+" where item_id=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	item_id);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{			
				bean.setItem_id			(rs.getString(1));
				bean.setClient_id		(rs.getString(2));
				bean.setSeq				(rs.getString(3));
				bean.setItem_dt			(rs.getString(4));
				bean.setTax_id			(rs.getString(5));
				bean.setItem_hap_str	(rs.getString(6));
				bean.setItem_hap_num	(rs.getInt(7));
				bean.setItem_man		(rs.getString(8));
				bean.setTax_code		(rs.getString(9));
				bean.setTax_est_dt		(rs.getString(10));
				bean.setTax_no			(rs.getString(11));
				bean.setUse_yn			(rs.getString(12));
				bean.setCancel_dt		(rs.getString(13));
				bean.setCancel_cont		(rs.getString(14));
				bean.setCust_st			(rs.getString(15));
				bean.setEtax_item_st	(rs.getString(16));
				bean.setTax_item_etc	(rs.getString(17));

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemCase(String item_id, String gubun2)]\n"+e);
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
	 *	2-6단계 : 거래명세서 리스트 item_id 한건 조회
	 *  
	 */	
	public Vector getTaxItemListCase2010(String item_id, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from tax_item_list_"+gubun2+" where item_id=? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	item_id);
	    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{			
				TaxItemListBean bean = new TaxItemListBean();
				bean.setItem_id		(rs.getString(1));
				bean.setItem_seq	(rs.getInt(2));
				bean.setItem_g		(rs.getString(3));
				bean.setItem_car_no	(rs.getString(4));
				bean.setItem_car_nm	(rs.getString(5));
				bean.setItem_dt1	(rs.getString(6));
				bean.setItem_dt2	(rs.getString(7));
				bean.setItem_supply	(rs.getInt(8));
				bean.setItem_value	(rs.getInt(9));
				bean.setRent_l_cd	(rs.getString(10));
				bean.setCar_mng_id	(rs.getString(11));
				bean.setTm			(rs.getString(12));
				bean.setGubun		(rs.getString(13));
				bean.setReg_id		(rs.getString(14));
				bean.setReg_dt		(rs.getString(15));
				bean.setReg_code	(rs.getString(16));
				bean.setRent_st		(rs.getString(17));
				bean.setRent_seq	(rs.getString(18));
				bean.setCar_use		(rs.getString(19));
				bean.setItem_dt		(rs.getString(20));
				bean.setEtc			(rs.getString(21));
				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getTaxItemListCase(String item_id, String gubun2)]\n"+e);
			System.out.println("[IssueDatabase:getTaxItemListCase(String item_id, String gubun2)]gubun2=\n"+gubun2);
			System.out.println("[IssueDatabase:getTaxItemListCase(String item_id, String gubun2)]item_id=\n"+item_id);
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

	//면책금 거래명세서 입금계좌번호 출력여부
	public String getServicePaidType(String car_mng_id, String serv_id)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String tax_no = "";
                
		query = " SELECT nvl(paid_type,'2')  FROM service WHERE car_mng_id='"+car_mng_id+"' AND serv_id='"+serv_id+"'";
		
        try{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
			    tax_no = rs.getString(1);
            }
			rs.close();
			pstmt.close();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:getServicePaidType]\n"+e);
			System.out.println("[IssueDatabase:getServicePaidType]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tax_no;
		}
    }
	
	//사고대차 상태에서 사고발생시 거래명세서에 원 계약자의 정보로 업데이트(20181217)
	public boolean updateClient_idInTax_item(String rent_s_cd, String item_id)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs1 = null;
		Hashtable ht1 = new Hashtable();
		String client_id = "";
		String query1 = " SELECT a.client_id FROM cont a, rent_cont b WHERE a.rent_l_cd = b.sub_l_cd AND b.rent_s_cd = ?";	
		String query2 = " UPDATE TAX_ITEM \n "+
						"	 SET client_id = ? \n "+
						"	 WHERE item_id = ? ";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString	(1,		rent_s_cd);
			
			rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{				
				client_id = rs1.getString(1);
			}
			ResultSetMetaData rsmd1 = rs1.getMetaData();
			
			for(int pos =1; pos <= rsmd1.getColumnCount();pos++)
			{
				 String columnName = rsmd1.getColumnName(pos);
				 ht1.put(columnName, client_id);
			}
			rs1.close();
			pstmt1.close();
			
			if(!client_id.equals("")){
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setString	(1,		client_id);
				pstmt2.setString	(2,		item_id);
				pstmt2.executeUpdate();
				pstmt2.close();
			}else{
				flag = false;
			}
			
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[IssueDatabase:updateClient_idInTax_item]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt1 != null )	pstmt1.close();
				if ( pstmt2 != null )	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public Vector getItemListCase(String resseq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select itemdate, itemname, itemsupprice, itemtax, itemremarks from itemlist where detailseqid=? ORDER BY seqid ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	resseq);
	    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{			
				TaxItemListBean bean = new TaxItemListBean();
				bean.setItem_g		(rs.getString("itemname")); 
				bean.setItem_supply	(rs.getInt("itemsupprice"));
				bean.setItem_value	(rs.getInt("itemtax"));
				bean.setItem_dt		(rs.getString("itemdate"));
				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[IssueDatabase:getItemListCase(String item_id)]\n"+e);
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
