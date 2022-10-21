/*
 * 특소세관리
 */
package acar.con_tax;

import java.util.*;
import java.sql.*;
import acar.util.*;
//import java.text.*;
//import acar.common.*;
//import acar.account.*;
import acar.database.DBConnectionManager;
//import acar.exception.DataSourceEmptyException;
//import acar.exception.UnknownDataException;
//import acar.exception.DatabaseException;

public class TaxDatabase {

	private Connection conn = null;
	public static TaxDatabase aim_db;
	
	public static TaxDatabase getInstance()
	{
		if(TaxDatabase.aim_db == null)
			TaxDatabase.aim_db = new TaxDatabase();
		return TaxDatabase.aim_db;	
	}	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
			{
	        	conn = connMgr.getConnection("acar");				
	        }
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


	// 특소세 관리 ----------------------------------------------------------------------------------------------

	/**
	 *	지출현황 - 특소세 납부처리를 위한 리스트
	 */
	public Vector getTaxPayRegList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select  \n"+
				"        b.rent_mng_id, b.rent_l_cd, b.car_mng_id, a.seq, b.firm_nm,"+
				"        b.use_yn, d.car_no, d.car_nm, cn.car_name, a.tax_rate, "+
				"        nvl(a.spe_tax_amt,0) spe_tax_amt, nvl(a.edu_tax_amt,0) edu_tax_amt, nvl((a.spe_tax_amt+a.edu_tax_amt),0) as amt, "+
				"        nvl(a.rtn_amt,0) rtn_amt,"+
				"        d.dpm, nvl(a.car_fs_amt,0) car_fs_amt, nvl(a.sur_rate,0) sur_rate, nvl(a.sur_amt,0) sur_amt, "+
				"        decode(a.tax_st,'1','장기대여','2','매각','3','용도변경','4','폐차','-') tax_st,"+
				"        decode(a.pay_dt,'','0','1') pay_yn, b.dlv_dt,"+
				"        decode(f.rent_start_dt, '', '', substr(f.rent_start_dt, 1, 4) || '-' || substr(f.rent_start_dt, 5, 2) || '-'||substr(f.rent_start_dt, 7, 2)) rent_start_dt,"+
				"        decode(a.pay_dt, '', '', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt,"+
				"        decode(a.est_dt, '', '', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				"        decode(a.rtn_dt, '', '', substr(a.rtn_dt, 1, 4) || '-' || substr(a.rtn_dt, 5, 2) || '-'||substr(a.rtn_dt, 7, 2)) rtn_dt,"+
				"        decode(a.tax_come_dt, '', decode(s.cont_dt, '', decode(t.opt_dt, '', t.cls_dt, substr(t.opt_dt, 1, 4) || '-' || substr(t.opt_dt, 5, 2) || '-'||substr(t.opt_dt, 7, 2)), substr(s.cont_dt, 1, 4) || '-' || substr(s.cont_dt, 5, 2) || '-'||substr(s.cont_dt, 7, 2)),"+
				"        substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt \n"+
				" from   cont_n_view b, car_reg d, car_tax a, car_etc e, fee f, sui s, cls_cont t, car_nm cn,   \n"+
				"        (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) h,  \n"+
				"        (select car_mng_id from car_tax group by car_mng_id) i \n"+
				" where  b.rent_l_cd=h.rent_l_cd  \n"+
				"        and b.car_mng_id=d.car_mng_id "+
				"        and b.car_mng_id=a.car_mng_id(+)"+
				"        and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				"        and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_st='1'"+
				"        and b.car_mng_id=s.car_mng_id(+) "+
				"        and b.rent_mng_id=t.rent_mng_id(+) and b.rent_l_cd=t.rent_l_cd(+)"+
				"        and b.car_mng_id=i.car_mng_id(+) "+
				"	and e.car_id=cn.car_id(+)  and    e.car_seq=cn.car_seq(+) \n"+
				"        and decode(t.cls_st,'',b.dlv_dt,'9999-99-99') > '2002-01-01'"+
				"        and f.rent_st='1' and b.car_st<>'3' and nvl(e.bae4,'0') in ('0','1','5') "+
				"        and cn.car_name not like '%9인승%' "+
				"        and cn.car_name not like '%12인승%'";

   
    if(gubun3.equals("1"))  query += " and a.car_mng_id is null and decode(t.cls_st,'',b.dlv_dt,'9999-99-99') > '2002-01-01' and nvl(d.first_car_no,d.car_no) like '%허%'";
    if(gubun3.equals("2"))  query += " and a.car_mng_id is not null";
    if(gubun3.equals("3"))  query += " and i.car_mng_id is null";
      
	if(gubun4.equals("1"))		query += " and decode(a.tax_st,'', decode(t.cls_st, '6','2', '8','2', '9','4', '1'), a.tax_st) ='1'";
	if(gubun4.equals("2"))		query += " and decode(a.tax_st,'', decode(t.cls_st, '6','2', '8','2', '9','4', '1'), a.tax_st) ='2'";
	if(gubun4.equals("3"))		query += " and decode(a.tax_st,'', decode(t.cls_st, '6','2', '8','2', '9','4', '1'), a.tax_st) ='3'";
	if(gubun4.equals("4"))		query += " and decode(a.tax_st,'', decode(t.cls_st, '6','2', '8','2', '9','4', '1'), a.tax_st) ='4'";
		

		/*검색조건*/			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(d.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("5"))	query += " and (a.spe_tax_amt+a.edu_tax_amt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and d.car_nm||cn.car_name like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		query += " order by b.firm_nm "+sort+", a.est_dt, a.pay_dt";

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
			System.out.println("[TaxDatabase:getTaxPayRegList]"+ e);
			System.out.println("[TaxDatabase:getTaxPayRegList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	
	/**
	 *	지출현황 - 특소세 납부처리를 위한 리스트
	 */
	public Vector getTaxPayList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select "+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.seq, b.firm_nm,"+
				"        b.use_yn, d.car_no, d.car_nm, cn.car_name, a.tax_rate, "+
				"        a.spe_tax_amt, a.edu_tax_amt, (a.spe_tax_amt+a.edu_tax_amt) as amt, nvl(a.rtn_amt,0) rtn_amt,"+
				"        d.dpm, a.car_fs_amt, a.sur_rate, a.sur_amt, decode(a.tax_st,'1','장기대여','2','매각', '3','용도변경', '4','폐차') tax_st,"+
				"        decode(a.pay_dt,'','0','1') pay_yn, b.dlv_dt,"+
				"        decode(f.rent_start_dt, '', '', substr(f.rent_start_dt, 1, 4) || '-' || substr(f.rent_start_dt, 5, 2) || '-'||substr(f.rent_start_dt, 7, 2)) rent_start_dt,"+
				"        decode(a.pay_dt, '', '', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt,"+
				"        decode(a.est_dt, '', '', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				"        decode(a.rtn_dt, '', '', substr(a.rtn_dt, 1, 4) || '-' || substr(a.rtn_dt, 5, 2) || '-'||substr(a.rtn_dt, 7, 2)) rtn_dt,"+
				"        decode(a.tax_come_dt, '', '', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt"+
				" from   car_tax a, cont_n_view b, car_reg d, car_etc e, fee f , car_nm cn \n"+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and b.car_mng_id=d.car_mng_id and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				"        and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1'"+
			        	"	and e.car_id=cn.car_id(+)  and    e.car_seq=cn.car_seq(+) ";
				

		/*상세조회&&세부조회*/

		//당월-납부
		if(gubun2.equals("1")){			query += " and a.est_dt like to_char(sysdate,'YYYYMM')||'%'";
		//기간-납부
		}else if(gubun2.equals("4")){	
			if(!st_dt.equals("") && !end_dt.equals("")){
				query += " and a.est_dt BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')";
			}else if(!st_dt.equals("") && end_dt.equals("")){
				st_dt = AddUtil.replace(st_dt, "-", "");
				query += " and a.est_dt like '"+st_dt+"%'";
			}
		}
	
		if(gubun4.equals("1"))			query += " and nvl(a.tax_st,'0') ='1'";
		else if(gubun4.equals("2"))		query += " and nvl(a.tax_st,'0') ='2'";
		

		/*검색조건*/			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(b.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("5"))	query += " and (a.spe_tax_amt+a.edu_tax_amt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and d.car_nm||cn.car_name like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/
		if(sort_gubun.equals("0"))		query += " order by a.pay_dt "+sort+", tax_st desc, d.dpm desc, b.rent_start_dt";
		else if(sort_gubun.equals("1"))	query += " order by b.firm_nm "+sort+", a.est_dt, a.pay_dt";
		else if(sort_gubun.equals("3"))	query += " order by a.spe_tax_amt "+sort+", a.est_dt, b.firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by d.car_no "+sort+",  b.firm_nm, a.est_dt";

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
			System.out.println("[TaxDatabase:getTaxPayList]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 납부예정 처리를 위한 리스트
	 */
	public Vector getTaxEstList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String est_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		if(est_mon.equals("")) est_mon = "0";
		query = " select  "+
				"        a.seq, b.use_yn, decode(a.rent_l_cd,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				"        b.firm_nm, d.car_no, d.car_nm, c.car_name, d.dpm, (e.car_fs_amt-e.dc_cs_amt) car_fs_amt, b.dlv_dt, e.bae4, h.cls_st,"+
				"        to_char(months_between(decode(b.use_yn,'N',TO_DATE(h.cls_dt, 'YYYY-MM-DD'), sysdate), TO_DATE(b.rent_start_dt, 'YYYY-MM-DD')), 99) rent_mon,"+
				"        decode(a.tax_st,'1','장기대여','2','매각', '3','용도변경', '4','폐차','',decode(h.cls_st, '6','매각','8','매각','9','폐차','장기대여')) tax_st,"+
				"        a.sur_rate, a.sur_amt, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt, (a.spe_tax_amt+a.edu_tax_amt) as amt, nvl(a.rtn_amt,0) rtn_amt,"+
				"        decode(f.rent_start_dt, '', '-', substr(f.rent_start_dt, 1, 4) || '-' || substr(f.rent_start_dt, 5, 2) || '-'||substr(f.rent_start_dt, 7, 2)) rent_start_dt,"+
				"        decode(a.pay_dt, '', '-', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt,"+
				"        decode(a.est_dt, '', '-', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				"        decode(a.rtn_dt, '', '-', substr(a.rtn_dt, 1, 4) || '-' || substr(a.rtn_dt, 5, 2) || '-'||substr(a.rtn_dt, 7, 2)) rtn_dt,"+
				"        decode(a.tax_come_dt, '', '-', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt,"+
				"        decode(s.migr_dt, '', decode(h.opt_dt, '', h.cls_dt, substr(h.opt_dt, 1, 4) || '-' || substr(h.opt_dt, 5, 2) || '-'||substr(h.opt_dt, 7, 2)), substr(s.migr_dt, 1, 4) || '-' || substr(s.migr_dt, 5, 2) || '-'||substr(s.migr_dt, 7, 2)) cont_dt,"+
		        "        h.cls_dt,"+
				"        decode(nvl(f.rent_start_dt,b.rent_start_dt), '','', to_char(add_months(to_date(f.rent_start_dt, 'YYYYMMDD'),6),'YYYY-MM-DD')) rent_start_dt_6mon"+
				" from   car_tax a, cont_n_view b, car_nm c, car_reg d, car_etc e, sui s, fee f,  \n"+
				"        (select car_mng_id from car_tax where pay_amt>0) g, cls_cont h,"+
				"        (select rent_mng_id, max(cls_dt) cls_dt from cls_cont where substr(rent_l_cd,8,1)<>'S' group by rent_mng_id) i"+
				" where  b.rent_mng_id=a.rent_mng_id(+) and b.rent_l_cd=a.rent_l_cd(+)"+
				"        and e.car_id=c.car_id and e.car_seq=c.car_seq "+
				"        and b.car_mng_id=d.car_mng_id and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+			
				"        and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and b.car_mng_id=s.car_mng_id(+)"+
				"        and f.rent_st='1' and b.car_st<>'3' and nvl(e.bae4,'0') in ('0','1','5') and c.dpm > '800' and c.s_st<>'101' and to_number(c.s_st) < '601' "+
				"        and decode(b.cls_st,'',b.dlv_dt,'9999-99-99') > '2002-01-01'"+
				"        and b.car_mng_id=g.car_mng_id(+) and g.car_mng_id is null"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+)"+
				"        and b.rent_mng_id=i.rent_mng_id(+) and a.est_dt is null"+
				"        and nvl(d.first_car_no,d.car_no) like '%허%'"+
				"        and (to_char(sysdate,'YYYY')-substr(b.dlv_dt,1,4))<5";//5년이내

		/*상세조회&&세부조회*/

		//당월-예정
		if(gubun2.equals("1")){			query += " and ( (substr(b.rent_start_dt,1,7) <= to_char(add_months(nvl(to_date(h.cls_dt,'YYYY-MM-DD'),sysdate), -7), 'YYYY-MM') and nvl(h.cls_st,'0') not in ('6','8') and b.client_id not in ('000228'))"+// and b.cls_dt is null
													" or (decode(s.migr_dt, '-',substr(h.cls_dt,1,7), '', substr(h.cls_dt,1,7), substr(s.migr_dt,1,4)||'-'||substr(s.migr_dt,5,2)) <= to_char(add_months(sysdate, -1), 'YYYY-MM') and nvl(h.cls_st,'0') in ('6','8')))";
		//기간-예정
		}else if(gubun2.equals("4")){	query += " and ( (substr(b.rent_start_dt,1,7) = to_char(add_months(nvl(to_date(h.cls_dt,'YYYY-MM-DD'),sysdate), -7+"+est_mon+"), 'YYYY-MM') and nvl(h.cls_st,'0') not in ('6','8') and b.client_id not in ('000228') and h.cls_dt is null)"+
													" or (decode(s.migr_dt, '-',substr(h.cls_dt,1,7), '', substr(h.cls_dt,1,7), substr(s.migr_dt,1,4)||'-'||substr(s.migr_dt,5,2)) = to_char(add_months(sysdate, -1+"+est_mon+"), 'YYYY-MM') and nvl(h.cls_st,'0') in ('6','8')))";
		}
	
		if(gubun4.equals("1"))			query += " and decode(a.tax_st,'1','장기대여','2','매각', '3','용도변경', '4','폐차','',decode(b.cls_st, '6','매각','8','매각','9','폐차','장기대여')) = '장기대여'";
		else if(gubun4.equals("2"))		query += " and decode(a.tax_st,'1','장기대여','2','매각', '3','용도변경', '4','폐차','',decode(b.cls_st, '6','매각','8','매각','9','폐차','장기대여')) = '매각'";


		/*검색조건*/		
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(b.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and d.car_nm||c.car_name like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/
		if(sort_gubun.equals("0"))		query += " order by tax_st desc, d.dpm desc, b.dlv_dt "+sort+", b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by tax_st desc, d.dpm desc, b.firm_nm "+sort;
		else if(sort_gubun.equals("2"))	query += " order by tax_st desc, d.dpm "+sort+", b.dlv_dt";
		else if(sort_gubun.equals("3"))	query += " order by tax_st desc, d.dpm desc, b.rent_start_dt "+sort+", b.firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by tax_st desc, d.dpm desc, d.car_no "+sort+",  b.firm_nm";

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
			System.out.println("[TaxDatabase:getTaxEstList]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 납부예정 처리를 위한 리스트
	 */
	public Vector getTaxEstList2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String est_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		if(est_mon.equals("")) est_mon = "0";

		query = " select a.seq, b.use_yn, decode(a.rent_l_cd,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" b.firm_nm, d.car_no, j.car_nm, c.car_name, d.dpm, (e.car_fs_amt-e.dc_cs_amt) car_fs_amt, b.dlv_dt, e.bae4, h.cls_st,"+
				" to_char(months_between(decode(b.use_yn,'N',TO_DATE(h.cls_dt, 'YYYY-MM-DD'), sysdate), TO_DATE(b.rent_start_dt, 'YYYY-MM-DD')), 99) rent_mon,"+
				" decode(a.tax_st,'1','장기대여','2','매각', '3','용도변경', '4','폐차','',decode(h.cls_st, '6','매각','8','매각','9','폐차','장기대여')) tax_st,"+
				" a.sur_rate, a.sur_amt, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt, (a.spe_tax_amt+a.edu_tax_amt) as amt, nvl(a.rtn_amt,0) rtn_amt,"+
				" decode(f.rent_start_dt, '', '-', substr(f.rent_start_dt, 1, 4) || '-' || substr(f.rent_start_dt, 5, 2) || '-'||substr(f.rent_start_dt, 7, 2)) rent_start_dt,"+
				" decode(a.pay_dt, '', '-', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt,"+
				" decode(a.est_dt, '', '-', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				" decode(a.rtn_dt, '', '-', substr(a.rtn_dt, 1, 4) || '-' || substr(a.rtn_dt, 5, 2) || '-'||substr(a.rtn_dt, 7, 2)) rtn_dt,"+
				" decode(a.tax_come_dt, '', '-', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt,"+
				" decode(s.migr_dt, '', decode(h.opt_dt, '', h.cls_dt, substr(h.opt_dt, 1, 4) || '-' || substr(h.opt_dt, 5, 2) || '-'||substr(h.opt_dt, 7, 2)), substr(s.migr_dt, 1, 4) || '-' || substr(s.migr_dt, 5, 2) || '-'||substr(s.migr_dt, 7, 2)) cont_dt,"+
		        " h.cls_dt,"+
				" decode(nvl(f.rent_start_dt,b.rent_start_dt), '','', to_char(add_months(to_date(f.rent_start_dt, 'YYYYMMDD'),12),'YYYY-MM-DD')) rent_start_dt_6mon"+
				" from car_tax a, cont_n_view b, car_nm c, car_reg d, car_etc e, sui s, fee f, (select car_mng_id from car_tax where pay_amt>0) g, cls_cont h,"+
				" (select rent_mng_id, max(cls_dt) cls_dt from cls_cont where substr(rent_l_cd,8,1)<>'S' group by rent_mng_id) i, car_mng j"+
				" where b.rent_mng_id=a.rent_mng_id(+) and b.rent_l_cd=a.rent_l_cd(+)"+
				" and e.car_id=c.car_id(+) and e.car_seq=c.car_seq(+) and c.car_comp_id=j.car_comp_id and c.car_cd=j.code"+
				" and b.car_mng_id=d.car_mng_id and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and b.car_mng_id=s.car_mng_id(+)"+
				" and f.rent_st='1' and b.car_st<>'3' and nvl(e.bae4,'0') in ('0','1','5') and d.dpm > 800"+
				" and c.s_st not in ('100','409','101','601','602','700','701','702','801','802','803','811','821')"+
				" and decode(h.cls_st,'',b.dlv_dt,'9999-99-99') > '2002-01-01'"+
				" and b.car_mng_id=g.car_mng_id(+) and g.car_mng_id is null"+
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+)"+
				" and b.rent_mng_id=i.rent_mng_id(+) and a.est_dt is null"+
				" and nvl(d.first_car_no,d.car_no) like '%허%'";


		/*상세조회&&세부조회*/

		//당월-예정
		if(gubun2.equals("1")){			query += " and ( (substr(f.rent_start_dt,1,6) <= to_char(add_months(nvl(to_date(h.cls_dt,'YYYY-MM-DD'),sysdate), -13), 'YYYYMM') and nvl(h.cls_st,'0') not in ('6','8') and b.client_id not in ('000228'))"+// and b.cls_dt is null
													" or (decode(s.migr_dt, '-',substr(h.cls_dt,1,7), '', substr(h.cls_dt,1,7), substr(s.migr_dt,1,4)||'-'||substr(s.migr_dt,5,2)) <= to_char(add_months(sysdate, -1), 'YYYY-MM') and nvl(h.cls_st,'0') in ('6','8')))";
		//기간-예정
		}else if(gubun2.equals("4")){	query += " and ( (f.rent_start_dt like to_char(add_months(nvl(to_date(h.cls_dt,'YYYY-MM-DD'),sysdate), -13+"+est_mon+"), 'YYYYMM')||'%' and nvl(h.cls_st,'0') not in ('6','8') and b.client_id not in ('000228'))"+// and b.cls_dt is null
													" or (decode(s.migr_dt, '-',substr(h.cls_dt,1,7), '', substr(h.cls_dt,1,7), substr(s.migr_dt,1,4)||'-'||substr(s.migr_dt,5,2)) = to_char(add_months(sysdate, -1+"+est_mon+"), 'YYYY-MM') and nvl(h.cls_st,'0') in ('6','8')))";
		}
	
		if(gubun4.equals("1"))			query += " and decode(a.tax_st,'1','장기대여','2','매각', '3','용도변경', '4','폐차','',decode(h.cls_st, '6','매각','8','매각','9','폐차','장기대여')) = '장기대여'";
		else if(gubun4.equals("2"))		query += " and decode(a.tax_st,'1','장기대여','2','매각', '3','용도변경', '4','폐차','',decode(h.cls_st, '6','매각','8','매각','9','폐차','장기대여')) = '매각'";


		/*검색조건*/		
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(d.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and j.car_nm||c.car_name like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/
		if(sort_gubun.equals("0"))		query += " order by tax_st desc, d.dpm desc, decode(a.tax_st,'1','1','2','2','',decode(h.cls_st, '6','2','8','2','1')), decode(a.tax_st,'1',to_char(add_months(to_date(f.rent_start_dt, 'YYYYMMDD'),12),'YYYYMMDD'),'2',s.migr_dt,'',decode(h.cls_st, '6',s.migr_dt,'8',s.migr_dt,to_char(add_months(to_date(f.rent_start_dt, 'YYYYMMDD'),12),'YYYYMMDD'))), b.dlv_dt "+sort+", b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by tax_st desc, d.dpm desc, b.firm_nm "+sort;
		else if(sort_gubun.equals("2"))	query += " order by tax_st desc, d.dpm "+sort+", b.dlv_dt";
		else if(sort_gubun.equals("3"))	query += " order by tax_st desc, d.dpm desc, b.rent_start_dt "+sort+", b.firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by tax_st desc, d.dpm desc, d.car_no "+sort+",  b.firm_nm";

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
			System.out.println("[TaxDatabase:getTaxEstList2]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 납부예정 처리를 위한 리스트
	 */
	public Vector getTaxEstList3(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String est_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		if(est_mon.equals("")) est_mon = "0";

		query = " select"+
				" b.use_yn, decode(a.car_mng_id,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" g.firm_nm, g.client_nm, d.first_car_no, d.car_no, d.car_nm, c.car_name, d.dpm, (e.car_fs_amt-e.dc_cs_amt) car_fs_amt, b.dlv_dt, e.bae4,"+
				" to_char(months_between(sysdate, TO_DATE(f.rent_start_dt, 'YYYYMMDD')), 99) rent_mon,"+
				" to_char(months_between(sysdate, TO_DATE(b.dlv_dt, 'YYYYMMDD'))/12,99) dlv_mon,"+
				" '장기대여' tax_st, f.rent_start_dt, to_char(to_date(f.rent_start_dt,'YYYYMMDD')+366,'YYYYMMDD') rent_12mon,"+
				" to_char(add_months(f.rent_start_dt,13),'YYYYMMDD') base_dt, '' migr_dt, h.cls_dt, '' cls_st"+
				" from cont b, car_reg d, car_etc e, fee f, car_nm c, (select car_mng_id from car_tax group by car_mng_id) a, client g, cls_cont h"+
				" where b.car_st<>'2'"+//nvl(b.use_yn,'Y')='Y' and 
				" and d.dpm > 1000 and d.taking_p < 9 and c.car_name not like '%9인승%'"+
				" and c.s_st < '600'"+//and c.s_st not in ('401','402') 
				" and b.dlv_dt > '20020101' and f.rent_start_dt > '20051231'"+
				" and nvl(d.first_car_no,d.car_no) like '%허%'"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_st='1' and f.rent_start_dt is not null"+
				" and e.car_id=c.CAR_ID and e.car_seq=c.car_seq"+
				" and b.car_mng_id=a.car_mng_id(+) and a.car_mng_id is null"+
				" and b.client_id=g.client_id"+
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+)"+
				" union all"+
				" select"+
				" b.use_yn, decode(a.car_mng_id,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" g.firm_nm, g.client_nm, d.first_car_no, d.car_no, d.car_nm, c.car_name, d.dpm, (e.car_fs_amt-e.dc_cs_amt) car_fs_amt, b.dlv_dt, e.bae4,"+
				" to_char(months_between(sysdate, TO_DATE(f.rent_start_dt, 'YYYYMMDD')), 99) rent_mon,"+
				" to_char(months_between(TO_DATE(i.migr_dt, 'YYYYMMDD'), TO_DATE(b.dlv_dt, 'YYYYMMDD'))/12,99) dlv_mon,"+
				" '매각' tax_st, f.rent_start_dt, i.migr_dt as rent_12mon,"+
				" to_char(add_months(i.migr_dt,2),'YYYYMMDD') base_dt, i.migr_dt, h.cls_dt, h.cls_st"+
				" from cont b, car_reg d, car_etc e, fee f, car_nm c, (select car_mng_id from car_tax group by car_mng_id) a, client g, cls_cont h, sui i"+
				" where nvl(b.use_yn,'Y')='N'"+
				" and h.cls_st in ('6','8')"+
				" and d.dpm > 1000 and d.taking_p < 9 and c.car_name not like '%9인승%'"+
				" and c.s_st < '600'"+//and c.s_st not in ('401','402') 
				" and b.dlv_dt > '20020101'"+
				" and nvl(d.first_car_no,d.car_no) like '%허%'"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_st='1'"+
				" and e.car_id=c.CAR_ID and e.car_seq=c.car_seq"+
				" and b.car_mng_id=a.car_mng_id(+) and a.car_mng_id is null"+
				" and b.client_id=g.client_id"+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd"+
				" and b.car_mng_id=i.car_mng_id";


		String query2 = " select * from ("+query+") where dlv_mon < 5";


		/*상세조회&&세부조회*/

		//당월-예정
		if(gubun2.equals("1"))			query2 += " and substr(base_dt,1,6) <= nvl(to_char(add_months(cls_dt,1),'YYYYMM') ,to_char(sysdate,'YYYYMM'))";
		//기간-예정
		else if(gubun2.equals("4"))		query2 += " and base_dt like to_char(add_months(sysdate, -1+"+est_mon+"), 'YYYYMM')||'%'";
		
	
		if(gubun4.equals("1"))			query2 += " and tax_st = '장기대여'";
		else if(gubun4.equals("2"))		query2 += " and tax_st = '매각'";


		/*검색조건*/		
		if(s_kd.equals("1"))		query2 += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query2 += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query2 += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query2 += " and (nvl(car_no, '') like '%"+t_wd+"%' or nvl(first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("6"))	query2 += " and substr(rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query2 += " and car_nm||car_name like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/
		if(sort_gubun.equals("0"))		query2 += " order by tax_st desc, rent_12mon desc, dpm desc, dlv_dt "+sort+", firm_nm";
		else if(sort_gubun.equals("1"))	query2 += " order by tax_st desc, dpm desc, firm_nm "+sort;
		else if(sort_gubun.equals("2"))	query2 += " order by tax_st desc, dpm "+sort+", rent_12mon desc, dlv_dt";
		else if(sort_gubun.equals("3"))	query2 += " order by tax_st desc, dpm desc, rent_start_dt "+sort+", firm_nm";
		else if(sort_gubun.equals("5"))	query2 += " order by tax_st desc, dpm desc, car_no "+sort+",  firm_nm";

		try {
			pstmt = conn.prepareStatement(query2);
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
			System.out.println("[TaxDatabase:getTaxEstList3]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 납부예정 처리를 위한 리스트
	 */
	public Vector getTaxEstList4(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String est_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		if(est_mon.equals("")) est_mon = "0";

		query = " select"+
				" b.use_yn, decode(a.car_mng_id,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" g.firm_nm, g.client_nm, d.first_car_no, d.car_no, d.car_nm, c.car_name, d.dpm, (e.car_fs_amt-e.dc_cs_amt) car_fs_amt, b.dlv_dt, e.bae4,"+
				" to_char(trunc(months_between(sysdate, TO_DATE(f.rent_start_dt, 'YYYYMMDD')), 0),99) rent_mon,"+
				" to_char(trunc(months_between(sysdate, TO_DATE(b.dlv_dt, 'YYYYMMDD'))/12, 0),99) dlv_mon,"+
				" '장기대여' tax_st, f.rent_start_dt, to_char(to_date(f.rent_start_dt,'YYYYMMDD')+366,'YYYYMMDD') rent_12mon,"+
				" to_char(add_months(f.rent_start_dt,13),'YYYYMMDD') base_dt, '' migr_dt, h.cls_dt, '' cls_st, '' cha_dt"+
				" from cont b, car_reg d, car_etc e, fee f, car_nm c, (select car_mng_id from car_tax group by car_mng_id) a, client g, cls_cont h"+
				" where b.car_st<>'2'"+//nvl(b.use_yn,'Y')='Y' and 
				" and d.dpm > 1000 and d.taking_p < 9 and c.car_name not like '%9인승%'"+
				" and c.s_st < '600'"+//and c.s_st not in ('401','402') 
				" and b.dlv_dt > '20020101' and f.rent_start_dt > '20051231'"+
				" and nvl(d.first_car_no,d.car_no) like '%허%'"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_st='1' and f.rent_start_dt is not null"+
				" and e.car_id=c.CAR_ID and e.car_seq=c.car_seq"+
				" and b.car_mng_id=a.car_mng_id(+) and a.car_mng_id is null"+
				" and b.client_id=g.client_id"+
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+)"+
				" union all\n"+
				" select"+
				" b.use_yn, decode(a.car_mng_id,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" g.firm_nm, g.client_nm, d.first_car_no, d.car_no, d.car_nm, c.car_name, d.dpm, (e.car_fs_amt-e.dc_cs_amt) car_fs_amt, b.dlv_dt, e.bae4,"+
				" to_char(trunc(months_between(sysdate, TO_DATE(f.rent_start_dt, 'YYYYMMDD')), 0),99) rent_mon,"+
//				" to_char(trunc(months_between(TO_DATE(ch.cha_dt, 'YYYYMMDD'), TO_DATE(b.dlv_dt, 'YYYYMMDD'))/12, 0),99) dlv_mon,"+
				" to_char(trunc(months_between(nvl(TO_DATE(i.migr_dt, 'YYYYMMDD'),sysdate), TO_DATE(b.dlv_dt, 'YYYYMMDD'))/12, 0),99) dlv_mon,"+
				" '용도변경' tax_st, f.rent_start_dt, ch.cha_dt as rent_12mon,"+
				" to_char(add_months(ch.cha_dt,2),'YYYYMMDD') base_dt, '' migr_dt, h.cls_dt, 'c' cls_st, ch.cha_dt cha_dt"+
				" from cont b, car_reg d, car_etc e, fee f, car_nm c, (select car_mng_id from car_tax group by car_mng_id) a, client g, cls_cont h, sui i,"+
				"	   (select car_mng_id, min(cha_dt) cha_dt from car_change where cha_cau='2' group by car_mng_id) ch"+
				" where b.car_st<>'2' and (e.car_cs_amt+e.opt_cs_amt+e.clr_cs_amt)!=e.car_fs_amt"+
				" and d.car_use='2' and d.dpm > 1000 and d.taking_p < 9 and c.car_name not like '%9인승%'"+
				" and c.s_st < '600'"+
				" and b.dlv_dt > '20020101' and f.rent_start_dt > '20041231'"+
				" and nvl(d.first_car_no,d.car_no) like '%허%'"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_st='1' and f.rent_start_dt is not null"+
				" and e.car_id=c.CAR_ID and e.car_seq=c.car_seq"+
				" and b.car_mng_id=a.car_mng_id(+) and a.car_mng_id is null"+
				" and b.client_id=g.client_id"+
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+)"+
			    " and d.car_mng_id=ch.car_mng_id\n"+
				" and b.car_mng_id=i.car_mng_id(+)\n"+
				" union all"+
				" select"+
				" b.use_yn, decode(a.car_mng_id,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" g.firm_nm, g.client_nm, d.first_car_no, d.car_no, d.car_nm, c.car_name, d.dpm, (e.car_fs_amt-e.dc_cs_amt) car_fs_amt, b.dlv_dt, e.bae4,"+
				" to_char(trunc(months_between(sysdate, TO_DATE(f.rent_start_dt, 'YYYYMMDD')),  0),99) rent_mon,"+
				" to_char(trunc(months_between(TO_DATE(i.migr_dt, 'YYYYMMDD'), TO_DATE(b.dlv_dt, 'YYYYMMDD'))/12, 0),99) dlv_mon,"+
				" '매각' tax_st, f.rent_start_dt, i.migr_dt as rent_12mon,"+
				" to_char(add_months(i.migr_dt,2),'YYYYMMDD') base_dt, i.migr_dt, h.cls_dt, h.cls_st, '' cha_dt"+
				" from cont b, car_reg d, car_etc e, fee f, car_nm c, (select car_mng_id from car_tax group by car_mng_id) a, client g, cls_cont h, sui i"+
				" where nvl(b.use_yn,'Y')='N'"+
				" and h.cls_st in ('6','8')"+
				" and d.dpm > 1000 and d.taking_p < 9 and c.car_name not like '%9인승%'"+
				" and c.s_st < '600'"+//and c.s_st not in ('401','402') 
				" and b.dlv_dt > '20020101'"+
				" and nvl(d.first_car_no,d.car_no) like '%허%'"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_st='1'"+
				" and e.car_id=c.CAR_ID and e.car_seq=c.car_seq"+
				" and b.car_mng_id=a.car_mng_id(+) and a.car_mng_id is null"+
				" and b.client_id=g.client_id"+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd"+
				" and b.car_mng_id=i.car_mng_id";


		String query2 = " select * from ("+query+") where dlv_mon < 5";


		/*상세조회&&세부조회*/

		//당월-예정
		if(gubun2.equals("1"))			query2 += " and substr(base_dt,1,6) <= nvl(to_char(add_months(cls_dt,1),'YYYYMM') ,to_char(sysdate,'YYYYMM'))";
		//기간-예정
		else if(gubun2.equals("4"))		query2 += " and base_dt like to_char(add_months(sysdate, -1+"+est_mon+"), 'YYYYMM')||'%'";
		
	
		if(gubun4.equals("1"))			query2 += " and tax_st = '장기대여'";
		else if(gubun4.equals("2"))		query2 += " and tax_st = '매각'";


		/*검색조건*/		
		if(s_kd.equals("1"))		query2 += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query2 += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query2 += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query2 += " and (nvl(car_no, '') like '%"+t_wd+"%' or nvl(first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("6"))	query2 += " and substr(rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query2 += " and car_nm||car_name like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/
		if(sort_gubun.equals("0"))		query2 += " order by tax_st desc, rent_12mon desc, dpm desc, dlv_dt "+sort+", firm_nm";
		else if(sort_gubun.equals("1"))	query2 += " order by tax_st desc, dpm desc, firm_nm "+sort;
		else if(sort_gubun.equals("2"))	query2 += " order by tax_st desc, dpm "+sort+", rent_12mon desc, dlv_dt";
		else if(sort_gubun.equals("3"))	query2 += " order by tax_st desc, dpm desc, rent_start_dt "+sort+", firm_nm";
		else if(sort_gubun.equals("5"))	query2 += " order by tax_st desc, dpm desc, car_no "+sort+",  firm_nm";

		try {
			pstmt = conn.prepareStatement(query2);
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
			System.out.println("[TaxDatabase:getTaxEstList4]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 납부예정 처리를 위한 리스트
	 */
	public Vector getTaxEstList5(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String est_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		if(est_mon.equals("")) est_mon = "0";

		query = " "+
				" select"+
				" b.use_yn, decode(a.car_mng_id,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" g.firm_nm, g.client_nm, d.first_car_no, d.car_no, d.car_nm, c.car_name, d.dpm, "+
				" case when e.CAR_ORIGIN = '2' AND d.IMPORT_CAR_AMT > 0 then (d.IMPORT_CAR_AMT+d.IMPORT_TAX_AMT) else (e.car_fs_amt-e.dc_cs_amt) end car_fs_amt, "+
				" b.dlv_dt, e.bae4,"+
			    " to_char(trunc(months_between(sysdate, TO_DATE(DECODE(y.rent_l_cd,'',f.rent_start_dt,y.cls_dt), 'YYYYMMDD')), 0),99) rent_mon,"+
				" to_char(trunc(months_between(nvl(TO_DATE(h.cls_dt, 'YYYYMMDD'),sysdate), TO_DATE(nvl(b.dlv_dt,d.init_reg_dt), 'YYYYMMDD'))/12,0),99) dlv_mon,"+
				" '장기대여' tax_st, f.rent_start_dt, "+
			    " to_char(to_date(DECODE(y.rent_l_cd,'',f.rent_start_dt,y.cls_dt),'YYYYMMDD')+decode(substr(DECODE(y.rent_l_cd,'',f.rent_start_dt,y.cls_dt),7,2),29,365,366),'YYYYMMDD') rent_12mon, "+
				" to_char(add_months(DECODE(y.rent_l_cd,'',f.rent_start_dt,y.cls_dt),12)+1,'YYYYMMDD') base_dt, "+
				" '' migr_dt, h.cls_dt, '' cls_st, '' cha_dt"+
				" from cont b, car_reg d, car_etc e, fee f, car_nm c, (select car_mng_id from car_tax group by car_mng_id) a, client g, cls_cont h, sui i,"+
			    "      (SELECT * FROM CLS_CONT WHERE cls_st IN ('4','5')) y "+
				" where  "+
				" nvl(b.use_yn,'Y')='Y' "+
				" and d.dpm > 1000 "+
				" and d.taking_p < 9 "+
			    " and c.car_name not like '%9인승%'"+
				" and c.s_st < '600'"+
				" AND INSTR(nvl(d.first_car_no,d.car_no),'허')+INSTR(nvl(d.first_car_no,d.car_no),'호')+INSTR(nvl(d.first_car_no,d.car_no),'하') >0"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_st='1' and f.rent_start_dt is not null"+
				" and e.car_id=c.CAR_ID and e.car_seq=c.car_seq"+
				" and b.car_mng_id=a.car_mng_id(+) and a.car_mng_id is null"+
				" and b.client_id=g.client_id"+
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+)\n"+
				" and b.car_mng_id=i.car_mng_id(+) and i.car_mng_id is null\n"+
			    " AND b.rent_mng_id=y.rent_mng_id(+) AND b.reg_dt=y.reg_dt(+) \n"+

				" union all\n"+

				" select"+
				" b.use_yn, decode(a.car_mng_id,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" g.firm_nm, g.client_nm, d.first_car_no, d.car_no, d.car_nm, c.car_name, d.dpm, "+
				" case when e.CAR_ORIGIN = '2' AND d.IMPORT_CAR_AMT > 0 then (d.IMPORT_CAR_AMT+d.IMPORT_TAX_AMT) else (e.car_fs_amt-e.dc_cs_amt) end car_fs_amt, "+
				" b.dlv_dt, e.bae4,"+
				" to_char(trunc(months_between(sysdate, TO_DATE(f.rent_start_dt, 'YYYYMMDD')), 0),99) rent_mon,"+
				" to_char(trunc(months_between(sysdate, TO_DATE(nvl(b.dlv_dt,d.init_reg_dt), 'YYYYMMDD'))/12, 0),99) dlv_mon,"+
				" '용도변경' tax_st, f.rent_start_dt, ch.cha_dt as rent_12mon,"+
				" to_char(add_months(ch.cha_dt,0),'YYYYMMDD') base_dt, '' migr_dt, h.cls_dt, 'c' cls_st, ch.cha_dt cha_dt"+
				" from cont b, car_reg d, car_etc e, fee f, car_nm c, (select car_mng_id from car_tax group by car_mng_id) a, client g, cls_cont h, sui i,"+
				"	   (select car_mng_id, min(cha_dt) cha_dt from car_change where cha_cau='2' group by car_mng_id) ch"+
				" where b.car_st<>'2' and nvl(b.use_yn,'Y')='Y'"+
				" and (e.car_cs_amt+e.opt_cs_amt+e.clr_cs_amt)<>e.car_fs_amt"+
				" and d.car_use='2' "+
				" and d.dpm > 1000 "+
				" and d.taking_p < 9 "+
				" and c.car_name not like '%9인승%'"+
				" and c.s_st < '600'"+
				" AND INSTR(nvl(d.first_car_no,d.car_no),'허')+INSTR(nvl(d.first_car_no,d.car_no),'호')+INSTR(nvl(d.first_car_no,d.car_no),'하') >0"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_start_dt is not null"+
				" and e.car_id=c.CAR_ID and e.car_seq=c.car_seq"+
				" and b.car_mng_id=a.car_mng_id(+) and a.car_mng_id is null"+
				" and b.client_id=g.client_id"+
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+)"+
			    " and d.car_mng_id=ch.car_mng_id\n"+
				" and b.car_mng_id=i.car_mng_id(+)\n"+
				" and ch.cha_dt between f.rent_start_dt and f.rent_end_dt"+

				" union all\n"+

				" select"+
				" b.use_yn, decode(a.car_mng_id,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" g.firm_nm, g.client_nm, d.first_car_no, d.car_no, d.car_nm, c.car_name, d.dpm, "+
				" case when e.CAR_ORIGIN = '2' AND d.IMPORT_CAR_AMT > 0 then (d.IMPORT_CAR_AMT+d.IMPORT_TAX_AMT) else (e.car_fs_amt-e.dc_cs_amt) end car_fs_amt, "+
				" b.dlv_dt, e.bae4,"+
                " to_char(trunc(months_between(sysdate, TO_DATE(f.rent_start_dt, 'YYYYMMDD')),0),99) rent_mon,"+
				" to_char(trunc(months_between(TO_DATE(i.migr_dt, 'YYYYMMDD'), TO_DATE(nvl(b.dlv_dt,d.init_reg_dt), 'YYYYMMDD'))/12,0),99) dlv_mon,"+
				" '매각' tax_st, f.rent_start_dt, i.migr_dt as rent_12mon,"+
				" to_char(add_months(i.migr_dt,0),'YYYYMMDD') base_dt, i.migr_dt, h.cls_dt, h.cls_st, '' cha_dt"+
				" from cont b, car_reg d, car_etc e, fee f, car_nm c, (select car_mng_id from car_tax group by car_mng_id) a, client g, cls_cont h, sui i"+
				" where nvl(b.use_yn,'Y')='N'"+
				" and h.cls_st in ('6','8')"+
				" and d.dpm > 1000 "+
				" and d.taking_p < 9 "+
				" and c.car_name not like '%9인승%'"+
				" and c.s_st < '600'"+
				" AND INSTR(nvl(d.first_car_no,d.car_no),'허')+INSTR(nvl(d.first_car_no,d.car_no),'호')+INSTR(nvl(d.first_car_no,d.car_no),'하') >0"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_st='1'"+
				" and e.car_id=c.CAR_ID and e.car_seq=c.car_seq"+
				" and b.car_mng_id=a.car_mng_id(+) and a.car_mng_id is null"+
				" and b.client_id=g.client_id"+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd"+
				" and b.car_mng_id=i.car_mng_id\n"+
/*
				" union all\n"+
				" select"+
				" b.use_yn, decode(a.car_mng_id,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" g.firm_nm, g.client_nm, d.first_car_no, d.car_no, d.car_nm, c.car_name, d.dpm, (e.car_fs_amt-e.dc_cs_amt) car_fs_amt, b.dlv_dt, e.bae4,"+
                " to_char(trunc(months_between(sysdate, TO_DATE(f.rent_start_dt, 'YYYYMMDD')),0),99) rent_mon,"+
				" to_char(trunc(months_between(TO_DATE(h.cls_dt, 'YYYYMMDD'), TO_DATE(nvl(b.dlv_dt,d.init_reg_dt), 'YYYYMMDD'))/12,0),99) dlv_mon,"+
				" '폐차' tax_st, f.rent_start_dt, h.cls_dt as rent_12mon,"+
				" to_char(add_months(h.cls_dt,0),'YYYYMMDD') base_dt, '' migr_dt, h.cls_dt, h.cls_st, '' cha_dt"+
				" from cont b, car_reg d, car_etc e, fee f, car_nm c, (select car_mng_id from car_tax group by car_mng_id) a, client g, cls_cont h"+
				" where nvl(b.use_yn,'Y')='N'"+
				" and h.cls_st in ('9')"+
				" and d.dpm > 1000 and d.taking_p < 9 and c.car_name not like '%9인승%'"+
				" and c.s_st < '600'"+//and c.s_st not in ('401','402') 
				" and nvl(d.first_car_no,d.car_no) like '%허%'"+
				" and b.car_mng_id=d.car_mng_id"+
				" and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_st='1'"+
				" and e.car_id=c.CAR_ID and e.car_seq=c.car_seq"+
				" and b.car_mng_id=a.car_mng_id(+) and a.car_mng_id is null"+
				" and b.client_id=g.client_id"+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd"+
*/
				" ";


		String query2 = " select * from ("+query+") where dlv_mon < 5 and rent_12mon <= to_char(sysdate,'YYYYMMDD')";


		/*상세조회&&세부조회*/

		//당월-예정
		if(gubun2.equals("1"))			query2 += " and substr(base_dt,1,6) <= to_char(add_months(sysdate, -1), 'YYYYMM')";

		//기간-예정
		else if(gubun2.equals("4"))		query2 += " and base_dt like to_char(add_months(sysdate, -1+"+est_mon+"), 'YYYYMM')||'%'";
		
	
		if(gubun4.equals("1"))			query2 += " and tax_st = '장기대여'";
		else if(gubun4.equals("2"))		query2 += " and tax_st = '매각'";
		else if(gubun4.equals("3"))		query2 += " and tax_st = '용도변경'";
		else if(gubun4.equals("4"))		query2 += " and tax_st = '폐차'";


		/*검색조건*/		
		if(s_kd.equals("1"))		query2 += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query2 += " and nvl(client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query2 += " and upper(rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query2 += " and (nvl(car_no, '') like '%"+t_wd+"%' or nvl(first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("6"))	query2 += " and substr(rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query2 += " and car_nm||car_name like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/
		if(sort_gubun.equals("0"))		query2 += " order by tax_st desc, rent_12mon desc, dpm desc, dlv_dt "+sort+", firm_nm";
		else if(sort_gubun.equals("1"))	query2 += " order by tax_st desc, dpm desc, firm_nm "+sort;
		else if(sort_gubun.equals("2"))	query2 += " order by tax_st desc, dpm "+sort+", rent_12mon desc, dlv_dt";
		else if(sort_gubun.equals("3"))	query2 += " order by tax_st desc, dpm desc, rent_start_dt "+sort+", firm_nm";
		else if(sort_gubun.equals("5"))	query2 += " order by tax_st desc, dpm desc, car_no "+sort+",  firm_nm";
		else if(sort_gubun.equals("6"))	query2 += " order by tax_st desc, rent_12mon";


		try {
			pstmt = conn.prepareStatement(query2);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

//			System.out.println(query2);

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
			System.out.println("[TaxDatabase:getTaxEstList5]"+ e);
			System.out.println("[TaxDatabase:getTaxEstList5]"+ query2);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 납부예정 처리를 위한 리스트
	 */
	public Vector getTaxStatList(String s_est_y, String s_brch)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";

		if(!s_brch.equals("")) where = "substr(rent_l_cd,1,2)='"+s_brch+"' and";

		query = " select nvl(a.cnt,0) as r_cnt, nvl(a.amt,0) as r_amt, nvl(b.cnt,0) as m_cnt, nvl(b.amt,0) as m_amt,"+
				" nvl(a.cnt,0)+nvl(b.cnt,0) as t_cnt, nvl(a.amt,0)+nvl(b.amt,0) as t_amt,"+
				" decode(c.pay_mon,'','',substr(c.pay_mon,1,4)||'년 '||substr(c.pay_mon,5,2)||'월') pay_mon, c.pay_mon as pay_ym"+
				" from "+
				" ( select '대여' gubun, substr(est_dt,1,6) pay_mon, count(*) cnt, sum(pay_amt) amt from car_tax where "+where+" tax_st='1' group by substr(est_dt,1,6) ) a,"+//cls_man_st is null
				" ( select '매각' gubun, substr(est_dt,1,6) pay_mon, count(*) cnt, sum(pay_amt) amt from car_tax where "+where+" tax_st='2' group by substr(est_dt,1,6) ) b,"+//cls_man_st is not null 
				" ( select '' gubun, substr(rent_dt,1,6) pay_mon from cont group by substr(rent_dt,1,6) ) c"+ 
				" where c.pay_mon=a.pay_mon(+) and c.pay_mon=b.pay_mon(+)";

		if(!s_est_y.equals("")) query += " and c.pay_mon like '%"+s_est_y+"%'";

		query += " order by pay_mon";

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
			System.out.println("[TaxDatabase:getTaxStatList]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	/**
	 *	지출현황 - 특소세 납부 처리를 위한 리스트 --> 엑셀파일
	 */
	public Vector getTaxExcelList1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String dpm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = ""; 

		query = " select "+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.seq, b.firm_nm,"+
				"        b.use_yn, d.car_no, d.car_num, decode(a.tax_st,'1',d.car_no,'2',decode(d.car_no,d.first_car_no,'&nbsp;',d.car_no)) car_no2, d.first_car_no, "+
				"        d.car_nm, cn.car_name, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt, (a.spe_tax_amt+a.edu_tax_amt) as amt, nvl(a.rtn_amt,0) rtn_amt,"+
				"        d.dpm, "+
				"        a.car_fs_amt, a.bk_122, a.ch_327, "+
				"        a.sur_rate, a.sur_amt, decode(a.tax_st,'1','장기대여','2','매각','3','용도변경','4','폐차') tax_st,"+
				"        decode(a.pay_dt,'','0','1') pay_yn, "+
				"        replace(b.dlv_dt,'-','') as dlv_dt, d.init_reg_dt, "+
				"        decode(f.rent_start_dt, '', '', substr(f.rent_start_dt, 1, 4) || '-' || substr(f.rent_start_dt, 5, 2) || '-'||substr(f.rent_start_dt, 7, 2)) rent_start_dt,"+
				"        decode(a.pay_dt, '', '', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt,"+
				"        decode(a.est_dt, '', '', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				"        decode(a.rtn_dt, '', '', substr(a.rtn_dt, 1, 4) || '-' || substr(a.rtn_dt, 5, 2) || '-'||substr(a.rtn_dt, 7, 2)) rtn_dt,"+
				"        decode(a.tax_come_dt, '', '', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt, "+
//				"        decode(g.cls_st,'4',g.cls_dt,'5',nvl(h.rent_suc_dt,g.cls_dt),CASE WHEN d.init_reg_dt > f.rent_start_dt THEN d.init_reg_dt ELSE f.rent_start_dt end) rent_start_dt2 "+
			    "        DECODE(g.rent_l_cd,'',CASE WHEN d.init_reg_dt > DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) THEN d.init_reg_dt ELSE DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) end,g.cls_dt) AS rent_start_dt2, "+
                "        a.use_cng_dt, i.jg_w, (NVL(d.IMPORT_CAR_AMT,0)+NVL(d.IMPORT_TAX_AMT,0)) import_amt, "+
                "        CASE WHEN i.jg_w IN ('1','2') AND a.car_fs_amt<>(NVL(d.IMPORT_CAR_AMT,0)+NVL(d.IMPORT_TAX_AMT,0)) THEN 'X' ELSE '' END import_chk  "+
				" from   car_tax a, cont_n_view b, car_reg d, car_etc e, fee f, (select * from cls_cont where cls_st in ('4','5')) g, cont_etc h , car_nm cn, TAECHA j, "+
                "        (SELECT a.* FROM esti_jg_var a, (SELECT sh_code, MAX(seq) seq FROM esti_jg_var GROUP BY sh_code) b WHERE a.sh_code=b.sh_code AND a.seq=b.seq) i "+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and b.car_mng_id=d.car_mng_id "+
				"	     and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				"	     and e.car_id=cn.car_id and e.car_seq=cn.car_seq "+
				"        and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd "+
				"        and f.rent_st='1' and nvl(a.cls_man_st,'0') in ('0','1')"+
				"        and b.rent_mng_id=g.rent_mng_id(+) and b.reg_dt=g.reg_dt(+) "+
				"        and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd "+				
				"        and b.rent_mng_id=j.rent_mng_id(+) and b.rent_l_cd=j.rent_l_cd(+) and nvl(j.no,'0')='0' "+				
                "        AND cn.jg_code=i.sh_code "+
				" ";

		if(gubun5.equals("1"))			query += " and a.pay_dt is null";
		else if(gubun5.equals("2"))		query += " and a.pay_dt is not null";

		//당월-납부
		if(gubun2.equals("1")){			query += " and a.est_dt like to_char(sysdate,'YYYYMM')||'%'";
		//기간-납부
		}else if(gubun2.equals("4")){	
			if(!st_dt.equals("") && !end_dt.equals("")){
				query += " and a.est_dt BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')";
			}else if(!st_dt.equals("") && end_dt.equals("")){
				st_dt = AddUtil.replace(st_dt, "-", "");
				query += " and a.est_dt like '"+st_dt+"%'";
			}
		}
	
		if(gubun4.equals("1"))			query += " and nvl(a.tax_st,'0') ='1'";
		else if(gubun4.equals("2"))		query += " and nvl(a.tax_st,'0') ='2'";
		else if(gubun4.equals("3"))		query += " and nvl(a.tax_st,'0') ='3'";
		else if(gubun4.equals("4"))		query += " and nvl(a.tax_st,'0') ='4'";
		
		if(dpm.equals("1"))			query += " and to_number(nvl(d.dpm,0)) <= 1500";
		else if(dpm.equals("2"))	query += " and to_number(d.dpm)> 1501 and d.dpm <= 2000";
		else if(dpm.equals("3"))	query += " and to_number(d.dpm) > 2001 ";

		/*검색조건*/			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(d.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("5"))	query += " and (a.spe_tax_amt+a.edu_tax_amt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and d.car_nm||cn.car_name like '%"+t_wd+"%'\n";

		query += " order by b.dlv_dt, a.car_mng_id ";

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
			System.out.println("[TaxDatabase:getTaxExcelList1]"+ e);
			System.out.println("[TaxDatabase:getTaxExcelList1]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 예정 처리를 위한 리스트 --> 엑셀파일
	 */
	public Vector getTaxExcelList2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String dpm, String est_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select  "+
				"        a.seq, b.use_yn, decode(a.rent_l_cd,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				"        b.firm_nm, d.car_no, decode(d.car_no,d.first_car_no,'&nbsp;',d.car_no) car_no2, d.first_car_no, d.car_nm, c.car_name, d.dpm, "+
				"        (e.car_fs_amt-e.dc_cs_amt) car_fs_amt, "+
				"        b.dlv_dt, e.bae4, h.cls_st,"+
				"        to_char(months_between(decode(b.use_yn,'N',TO_DATE(h.cls_dt, 'YYYY-MM-DD'), sysdate), TO_DATE(b.rent_start_dt, 'YYYY-MM-DD')), 99) rent_mon,"+
				"        decode(a.tax_st,'1','장기대여','2','매각','3','용도변경', '4','폐차', '',decode(h.cls_st, '6','매각','8','매각','장기대여')) tax_st,"+
				"        a.sur_rate, a.sur_amt, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt, (a.spe_tax_amt+a.edu_tax_amt) as amt, nvl(a.rtn_amt,0) rtn_amt,"+
				"        decode(f.rent_start_dt, '', '-', substr(f.rent_start_dt, 1, 4) || '-' || substr(f.rent_start_dt, 5, 2) || '-'||substr(f.rent_start_dt, 7, 2)) rent_start_dt,"+
				"        decode(a.pay_dt, '', '-', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt,"+
				"        decode(a.est_dt, '', '-', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				"        decode(a.rtn_dt, '', '-', substr(a.rtn_dt, 1, 4) || '-' || substr(a.rtn_dt, 5, 2) || '-'||substr(a.rtn_dt, 7, 2)) rtn_dt,"+
				"        decode(a.tax_come_dt, '', '-', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt,"+
				"        decode(s.cont_dt, '', decode(h.opt_dt, '', b.cls_dt, substr(h.opt_dt, 1, 4) || '-' || substr(h.opt_dt, 5, 2) || '-'||substr(h.opt_dt, 7, 2)), substr(s.cont_dt, 1, 4) || '-' || substr(s.cont_dt, 5, 2) || '-'||substr(s.cont_dt, 7, 2)) cont_dt,"+
				"        decode(i.cls_dt, '', nvl(h.cls_dt,'-'), substr(i.cls_dt, 1, 4) || '-' || substr(i.cls_dt, 5, 2) || '-'||substr(i.cls_dt, 7, 2)) cls_dt,"+
				"        decode(nvl(f.rent_start_dt,b.rent_start_dt), '','', to_char(add_months(to_date(f.rent_start_dt, 'YYYYMMDD'),6),'YYYY-MM-DD')) rent_start_dt_6mon"+
				" from   car_tax a, cont_n_view b, car_nm c, car_reg d, car_etc e, sui s, fee f, (select car_mng_id from car_tax where pay_amt>0) g, cls_cont h,"+
				"        (select rent_mng_id, max(cls_dt) cls_dt from cls_cont where substr(rent_l_cd,8,1)<>'S' group by rent_mng_id) i, car_mng j"+
				" where  b.rent_mng_id=a.rent_mng_id(+) and b.rent_l_cd=a.rent_l_cd(+)"+
				"        and e.car_id=c.car_id(+) and e.car_seq=c.car_seq(+) and c.car_comp_id=j.car_comp_id and c.car_cd=j.code"+
				"        and b.car_mng_id=d.car_mng_id and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				"        and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and b.car_mng_id=s.car_mng_id(+)"+
				"        and f.rent_st='1' and b.car_st<>'3' and nvl(e.bae4,'0') in ('0','1','5') and c.dpm > '800' and c.s_st<>'101' and to_number(c.s_st) < '601' "+
				"        and decode(h.cls_st,'',b.dlv_dt,'9999-99-99') > '2002-01-01'"+
				"        and b.car_mng_id=g.car_mng_id(+) and g.car_mng_id is null"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+)"+
				"        and b.rent_mng_id=i.rent_mng_id(+) and a.est_dt is null"+
				"        and nvl(d.first_car_no,d.car_no) like '%허%'"+
				"        and (to_char(sysdate,'YYYY')-substr(b.dlv_dt,1,4))<5";//5년이내


		//당월-예정
		if(gubun2.equals("1")){			query += " and ( (substr(b.rent_start_dt,1,7) <= to_char(add_months(nvl(to_date(h.cls_dt,'YYYY-MM-DD'),sysdate), -7), 'YYYY-MM') and nvl(h.cls_st,'0') not in ('6','8') and b.client_id not in ('000228'))"+// and b.cls_dt is null
													" or (decode(s.migr_dt, '-',substr(h.cls_dt,1,7), '', substr(h.cls_dt,1,7), substr(s.migr_dt,1,4)||'-'||substr(s.migr_dt,5,2)) <= to_char(add_months(sysdate, -1), 'YYYY-MM') and nvl(h.cls_st,'0') in ('6','8')))";
		//기간-예정
		}else if(gubun2.equals("4")){	query += " and ( (substr(b.rent_start_dt,1,7) = to_char(add_months(nvl(to_date(h.cls_dt,'YYYY-MM-DD'),sysdate), -7+"+est_mon+"), 'YYYY-MM') and nvl(h.cls_st,'0') not in ('6','8') and b.client_id not in ('000228') and h.cls_dt is null)"+
													" or (decode(s.migr_dt, '-',substr(b.cls_dt,1,7), '', substr(h.cls_dt,1,7), substr(s.migr_dt,1,4)||'-'||substr(s.migr_dt,5,2)) = to_char(add_months(sysdate, -1+"+est_mon+"), 'YYYY-MM') and nvl(h.cls_st,'0') in ('6','8')))";
		}

		if(gubun4.equals("1"))			query += " and decode(a.tax_st,'1','장기대여','2','매각', '3','용도변경', '4','폐차', '',decode(b.cls_st, '6','매각','8','매각','장기대여')) = '장기대여'";
		else if(gubun4.equals("2"))		query += " and decode(a.tax_st,'1','장기대여','2','매각','3','용도변경', '4','폐차', '',decode(b.cls_st, '6','매각','8','매각','장기대여')) = '매각'";


		if(dpm.equals("1"))			query += " and nvl(d.dpm,'0') BETWEEN '0' and '1500'";
		else if(dpm.equals("2"))	query += " and nvl(d.dpm,'0') BETWEEN '1501' and '2000'";
		else if(dpm.equals("3"))	query += " and nvl(d.dpm,'0') BETWEEN '2001' and '9999'";

		/*검색조건*/		
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(d.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and nvl(d.car_nm, '') like '%"+t_wd+"%'\n";


		query += " order by b.dlv_dt";

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
			System.out.println("[TaxDatabase:getTaxExcelList2]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 예정 처리를 위한 리스트 --> 엑셀파일
	 */
	public Vector getTaxExcelList22(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String dpm, String est_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select  a.seq, b.use_yn, decode(a.rent_l_cd,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id,"+
				" b.firm_nm, d.car_no, decode(d.car_no,d.first_car_no,'&nbsp;',d.car_no) car_no2, d.first_car_no, j.car_nm, c.car_name, d.dpm, (e.car_fs_amt-e.dc_cs_amt) car_fs_amt, b.dlv_dt, e.bae4, h.cls_st,"+
				" to_char(months_between(decode(b.use_yn,'N',TO_DATE(h.cls_dt, 'YYYY-MM-DD'), sysdate), TO_DATE(b.rent_start_dt, 'YYYY-MM-DD')), 99) rent_mon,"+
				" decode(a.tax_st,'1','장기대여','2','매각','3','용도변경', '4','폐차', '',decode(h.cls_st, '6','매각','8','매각','장기대여')) tax_st,"+
				" a.sur_rate, a.sur_amt, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt, (a.spe_tax_amt+a.edu_tax_amt) as amt, nvl(a.rtn_amt,0) rtn_amt,"+
				" decode(f.rent_start_dt, '', '-', substr(f.rent_start_dt, 1, 4) || '-' || substr(f.rent_start_dt, 5, 2) || '-'||substr(f.rent_start_dt, 7, 2)) rent_start_dt,"+
				" decode(a.pay_dt, '', '-', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt,"+
				" decode(a.est_dt, '', '-', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				" decode(a.rtn_dt, '', '-', substr(a.rtn_dt, 1, 4) || '-' || substr(a.rtn_dt, 5, 2) || '-'||substr(a.rtn_dt, 7, 2)) rtn_dt,"+
				" decode(a.tax_come_dt, '', '-', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt,"+
				" decode(s.cont_dt, '', decode(h.opt_dt, '', h.cls_dt, substr(h.opt_dt, 1, 4) || '-' || substr(h.opt_dt, 5, 2) || '-'||substr(h.opt_dt, 7, 2)), substr(s.cont_dt, 1, 4) || '-' || substr(s.cont_dt, 5, 2) || '-'||substr(s.cont_dt, 7, 2)) cont_dt,"+
				" decode(i.cls_dt, '', nvl(h.cls_dt,'-'), substr(i.cls_dt, 1, 4) || '-' || substr(i.cls_dt, 5, 2) || '-'||substr(i.cls_dt, 7, 2)) cls_dt,"+
				" decode(nvl(f.rent_start_dt,b.rent_start_dt), '','', to_char(add_months(to_date(f.rent_start_dt, 'YYYYMMDD'),6),'YYYY-MM-DD')) rent_start_dt_6mon"+
				" from car_tax a, cont_n_view b, car_nm c, car_reg d, car_etc e, sui s, fee f, (select car_mng_id from car_tax where pay_amt>0) g, cls_cont h,"+
				" (select rent_mng_id, max(cls_dt) cls_dt from cls_cont where substr(rent_l_cd,8,1)<>'S' group by rent_mng_id) i, car_mng j"+
				" where b.rent_mng_id=a.rent_mng_id(+) and b.rent_l_cd=a.rent_l_cd(+)"+
				" and e.car_id=c.car_id(+) and e.car_seq=c.car_seq and c.car_comp_id=j.car_comp_id and c.car_cd=j.code"+
				" and b.car_mng_id=d.car_mng_id and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and b.car_mng_id=s.car_mng_id(+)"+
				" and f.rent_st='1' and b.car_st<>'3' and nvl(e.bae4,'0') in ('0','1','5') and c.dpm > '800' and c.s_st<>'101' and to_number(c.s_st) < '601' "+
				" and decode(h.cls_st,'',b.dlv_dt,'9999-99-99') > '2002-01-01'"+
				" and b.car_mng_id=g.car_mng_id(+) and g.car_mng_id is null"+
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+)"+
				" and b.rent_mng_id=i.rent_mng_id(+) and a.est_dt is null"+
				" and nvl(d.first_car_no,d.car_no) like '%허%'"+
				" and (to_char(sysdate,'YYYY')-substr(b.dlv_dt,1,4))<5";

		//당월-예정
		if(gubun2.equals("1")){			query += " and ( (substr(f.rent_start_dt,1,6) <= to_char(add_months(nvl(to_date(h.cls_dt,'YYYY-MM-DD'),sysdate), -7), 'YYYYMM') and nvl(h.cls_st,'0') not in ('6','8') and b.client_id not in ('000228') and h.cls_dt is null)"+//
													" or (decode(s.migr_dt, '-',substr(h.cls_dt,1,7), '', substr(h.cls_dt,1,7), substr(s.migr_dt,1,4)||'-'||substr(s.migr_dt,5,2)) <= to_char(add_months(sysdate, -1), 'YYYY-MM') and nvl(h.cls_st,'0') in ('6','8')))";
		//기간-예정
		}else if(gubun2.equals("4")){	query += " and ( (f.rent_start_dt like to_char(add_months(nvl(to_date(h.cls_dt,'YYYY-MM-DD'),sysdate), -7+"+est_mon+"), 'YYYYMM')||'%' and nvl(h.cls_st,'0') not in ('6','8') and b.client_id not in ('000228') and h.cls_dt is null)"+
													" or (decode(s.migr_dt, '-',substr(h.cls_dt,1,7), '', substr(h.cls_dt,1,7), substr(s.migr_dt,1,4)||'-'||substr(s.migr_dt,5,2)) = to_char(add_months(sysdate, -1+"+est_mon+"), 'YYYY-MM') and nvl(h.cls_st,'0') in ('6','8')))";
		}

		if(gubun4.equals("1"))			query += " and decode(a.tax_st,'1','장기대여','2','매각','3','용도변경', '4','폐차', '',decode(b.cls_st, '6','매각','8','매각','장기대여')) = '장기대여'";
		else if(gubun4.equals("2"))		query += " and decode(a.tax_st,'1','장기대여','2','매각','3','용도변경', '4','폐차', '',decode(b.cls_st, '6','매각','8','매각','장기대여')) = '매각'";

		if(dpm.equals("1"))			query += " and nvl(d.dpm,'0') BETWEEN '0' and '1500'";
		else if(dpm.equals("2"))	query += " and nvl(d.dpm,'0') BETWEEN '1501' and '2000'";
		else if(dpm.equals("3"))	query += " and nvl(d.dpm,'0') BETWEEN '2001' and '9999'";

		/*검색조건*/		
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(b.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and nvl(d.car_nm, '') like '%"+t_wd+"%'\n";


		query += " order by b.dlv_dt";

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
			System.out.println("[TaxDatabase:getTaxExcelList22]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	/**
	 *	지출현황 - 특소세 스케줄 등록처리를 위한 리스트
	 */
	public Vector getTaxScdList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  a.seq, b.use_yn, decode(a.rent_l_cd,'','N','Y') reg_yn, b.rent_mng_id, b.rent_l_cd, b.car_mng_id, "+
				" nvl(a.car_fs_amt,case when e.CAR_ORIGIN = '2' AND d.IMPORT_CAR_AMT > 0 then (d.IMPORT_CAR_AMT+d.IMPORT_TAX_AMT) else (e.car_fs_amt-e.dc_cs_amt) end) car_fs_amt,"+
				" b.firm_nm,  d.car_no, i.car_nm, c.car_name, d.dpm, b.dlv_dt, e.bae4, h.cls_st, nvl(h.cls_dt,'-') cls_dt,"+
				" to_char(months_between(decode(b.use_yn,'N',TO_DATE(h.cls_dt, 'YYYY-MM-DD'), sysdate), TO_DATE(f.rent_start_dt, 'YYYY-MM-DD')), 99) rent_mon,"+
				" decode(f.rent_start_dt, '', '-', substr(f.rent_start_dt, 1, 4) || '-' || substr(f.rent_start_dt, 5, 2) || '-'||substr(f.rent_start_dt, 7, 2)) rent_start_dt,"+
				" decode(s.migr_dt, '', decode(s.cont_dt, '', decode(h.opt_dt, '', h.cls_dt, substr(h.opt_dt, 1, 4) || '-' || substr(h.opt_dt, 5, 2) || '-'||substr(h.opt_dt, 7, 2)), substr(s.cont_dt, 1, 4) || '-' || substr(s.cont_dt, 5, 2) || '-'||substr(s.cont_dt, 7, 2)), substr(s.migr_dt, 1, 4) || '-' || substr(s.migr_dt, 5, 2) || '-'||substr(s.migr_dt, 7, 2)) cont_dt, "+
			    "        DECODE(y.rent_l_cd,'',CASE WHEN d.init_reg_dt > DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) THEN d.init_reg_dt ELSE DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) end,y.cls_dt) AS rent_start_dt2 "+
				" from car_tax a, cont_n_view b, car_nm c, car_reg d, car_etc e, fee f, sui s, cls_cont h, car_mng i, (SELECT * FROM CLS_CONT WHERE cls_st IN ('4','5')) y, TAECHA j  "+
				" where b.rent_mng_id=a.rent_mng_id(+) and b.rent_l_cd=a.rent_l_cd(+)"+
				" and e.car_id=c.car_id(+) and e.car_seq=c.car_seq and c.car_comp_id=i.car_comp_id and c.car_cd=i.code"+
				" and b.car_mng_id=d.car_mng_id and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd"+
				" and b.car_mng_id=s.car_mng_id(+)"+
				" and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+)"+
				" and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd and f.rent_st='1'"+
				" AND b.rent_mng_id=y.rent_mng_id(+) AND b.reg_dt=y.reg_dt(+) "+
				" and b.rent_mng_id=j.rent_mng_id(+) and b.rent_l_cd=j.rent_l_cd(+) and nvl(j.no,'0')='0' "+
				" ";


		/*상세조회&&세부조회*/

		//출고일자-전체
		if(gubun2.equals("4") && gubun3.equals("1")){	query += " and b.dlv_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//출고일자-등록
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and b.dlv_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.rent_l_cd is not null";
		//출고일자-미등록
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and b.dlv_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.rent_l_cd is null";
		//대여개시일-전체
		}else if(gubun2.equals("7") && gubun3.equals("1")){	query += " and b.rent_start_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//대여개시일-등록
		}else if(gubun2.equals("7") && gubun3.equals("2")){	query += " and b.rent_start_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.rent_l_cd is not null";
		//대여개시일-미등록
		}else if(gubun2.equals("7") && gubun3.equals("3")){	query += " and b.rent_start_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.rent_l_cd is null";
		//해지일-전체
		}else if(gubun2.equals("8") && gubun3.equals("1")){	query += " and h.cls_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//해지일-등록
		}else if(gubun2.equals("8") && gubun3.equals("2")){	query += " and h.cls_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.rent_l_cd is not null";
		//해지일-미등록
		}else if(gubun2.equals("8") && gubun3.equals("3")){	query += " and h.cls_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.rent_l_cd is null";
		//검색-등록
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.rent_l_cd is not null";
		//검색-미등록
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.rent_l_cd is null";
		}
	
		
		if(gubun4.equals("1"))			query += " and decode(a.tax_st, '1','장기대여', '2','매각', '3','용도변경', '4','폐차', '',decode(h.cls_st, '6','매각','8','매각','장기대여')) = '장기대여'";
		else if(gubun4.equals("2"))		query += " and decode(a.tax_st, '1','장기대여', '2','매각', '3','용도변경', '4','폐차', '',decode(h.cls_st, '6','매각','8','매각','장기대여')) = '매각'";

		/*검색조건*/
		t_wd = t_wd.trim();

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
			else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(d.first_car_no, '') like '%"+t_wd+"%')\n";
			else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("9"))	query += " and i.car_nm||c.car_name like '%"+t_wd+"%'\n";
		}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, b.dlv_dt "+sort+", b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort;
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, d.dpm "+sort+", b.dlv_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, b.rent_start_dt "+sort+", b.firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, d.car_no "+sort+",  b.firm_nm";

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
			System.out.println("[TaxDatabase:getTaxScdList]"+ e);
			System.out.println("[TaxDatabase:getTaxScdList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 등록시 필요 정보
	 */
	public Hashtable getTaxScdInfo(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select b.DPM, case when c.CAR_ORIGIN = '2' AND b.IMPORT_CAR_AMT > 0 then (b.IMPORT_CAR_AMT+b.IMPORT_TAX_AMT) else (c.car_fs_amt-c.dc_cs_amt) end CAR_FS_AMT"+
				" from cont a, car_reg b, car_etc c "+
				" where a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
				" and a.car_mng_id=b.car_mng_id"+
				" and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				ht.put("DPM", rs.getString(1));
				ht.put("CAR_FS_AMT", rs.getString(2));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxScdInfo]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	세율 가져오기
	 */
	public String getTaxRate(String tax_nm, String dpm, String dlv_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String tax_rate = "";
		String dpm_st = "3";
		String query = "";

		if(tax_nm.equals("특소세")){
			query = " select a.tax_rate from"+
					" tax_rate a, (select tax_nm, dpm, max(tax_st_dt) tax_st_dt from tax_rate WHERE tax_st_dt <= replace('"+dlv_dt+"', '-', '') group by tax_nm, dpm) b"+
					" where a.tax_nm=b.tax_nm and a.dpm=b.dpm and a.tax_st_dt=b.tax_st_dt"+
					" and a.tax_nm='"+tax_nm+"'";
		}else{
			query = " select a.tax_rate from"+
					" tax_rate a, (select tax_nm, dpm, max(tax_st_dt) tax_st_dt from tax_rate group by tax_nm, dpm) b"+
					" where a.tax_nm=b.tax_nm and a.dpm=b.dpm and a.tax_st_dt=b.tax_st_dt"+
					" and a.tax_nm='"+tax_nm+"'";
		}

		if(!dpm.equals("")){
			if(AddUtil.parseInt(dpm) > 0 && AddUtil.parseInt(dpm) <= 1500)		dpm_st = "1";
			if(AddUtil.parseInt(dpm) > 1500 && AddUtil.parseInt(dpm) <= 2000)	dpm_st = "2";
			if(AddUtil.parseInt(dpm) > 2000)									dpm_st = "3";

			query += " and a.dpm='"+dpm_st+"'";
		}


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				tax_rate = rs.getString(1).trim();
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxRate]"+ e);
			System.out.println("[TaxDatabase:getTaxRate]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tax_rate;
		}
	}

	/**
	 *	세율 가져오기
	 */
	public String getTaxRate(String tax_nm, String dpm, String cls_st, String come_dt, String cont_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String tax_rate = "";
		String dpm_st = "3";
		String query = "";

		query = " select a.tax_rate from tax_rate a"+
				" where a.tax_nm='"+tax_nm+"'";

		if(cls_st.equals(""))	query += " and replace('"+come_dt+"', '-', '') between a.tax_st_dt and nvl(a.tax_ed_dt,'99999999')";
		else 					query += " and replace('"+cont_dt+"', '-', '') between a.tax_st_dt and nvl(a.tax_ed_dt,'99999999')";

		if(!dpm.equals("")){
			if(Integer.parseInt(dpm) > 0 && Integer.parseInt(dpm) <= 1500)		dpm_st = "1";
			if(Integer.parseInt(dpm) > 1500 && Integer.parseInt(dpm) <= 2000)	dpm_st = "2";
			if(Integer.parseInt(dpm) > 2000)									dpm_st = "3";

			query += " and a.dpm='"+dpm_st+"'";
		}


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				tax_rate = rs.getString(1).trim();
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxRate]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tax_rate;
		}
	}

	/**
	 *	특소세 납부차량 대수 가져오기
	 */
	public int getTaxPayCarCnt(String gubun, String year, String kds)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";
		query = " select count(*) from cont a, car_reg b, car_tax c"+
				" where a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+//a.use_yn='Y' and 
				" and substr(b.init_reg_dt,1,4) = '"+year+"' and car_kd in ("+kds+") ";

		if(gubun.equals("S")) query += " and substr(b.car_no, 5,1) ='허'";
		if(gubun.equals("L")) query += " and substr(b.car_no, 5,1)<>'허'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxPayCarCnt]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	세율 가져오기
	 */
	public String getSurRate(String dlv_dt, String cls_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		String sur_rate = "";
		int now_year = AddUtil.getDate2(1);		//현재년도
		int now_mon = AddUtil.getDate2(2)-1;	//현재전월

//		if(cls_st.equals("") && Integer.parseInt(AddUtil.ChangeString(dlv_dt)) >= 20030101){
			now_mon = 0;	
//		}
		int dlv_year = 0;
		int dlf_year = 0;

		String query2 = "select trunc((to_date(to_char(sysdate,'YYYY'),'YYYY')-to_date(substr(replace('"+dlv_dt+"','-',''),1,4),'YYYY'))/365,0) from dual";
		
		String query = "";
		query = " select tax_rate from"+
				" tax_rate a, (select tax_nm, dpm, max(tax_st_dt) tax_st_dt from tax_rate group by tax_nm, dpm, rate_st1, rate_st2) b"+
				" where a.tax_nm=b.tax_nm and a.dpm=b.dpm and a.tax_st_dt=b.tax_st_dt"+
				" and a.tax_nm='잔가율' and a.rate_st1=? and a.rate_st2=?";

		try {

			pstmt2 = conn.prepareStatement(query2);
    		rs2 = pstmt2.executeQuery();
			if(rs2.next()){			
				dlf_year = rs2.getInt(1);
			}

			if(dlv_dt.length() == 10){
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, Integer.toString(dlf_year+1));
				pstmt.setString(2, Integer.toString(now_mon));
	    		rs = pstmt.executeQuery();
				if(rs.next()){			
					sur_rate = rs.getString(1).trim();
				}
			}
			rs.close();
			pstmt.close();
			rs2.close();
			pstmt2.close();

		} catch (Exception e) {
			System.out.println("[TaxDatabase:getSurRate]"+ e);
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return sur_rate;
		}
	}

	/**
	 *	세율 가져오기
	 */
	public String getSurRate(String dlv_y, String migr_y, String cls_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		String sur_rate = "";
		int now_year = AddUtil.getDate2(1);		//현재년도
		int now_mon = AddUtil.getDate2(2)-1;	//현재전월

		//경과월이 아닌 경과년으로 계산이 바뀜	
//		if(cls_st.equals("") && Integer.parseInt(AddUtil.ChangeString(dlv_dt)) >= 20030101){
		now_mon = 0;	
//		}

		int dlv_year = 0;
		int dlf_year = 0;

		String s_year = "to_char(sysdate,'YYYY')";

		if(!migr_y.equals("")) s_year = "'"+migr_y+"'";

		String query2 = "select trunc((to_date("+s_year+",'YYYY')-to_date('"+dlv_y+"','YYYY'))/365,0) from dual";
		
		String query = "";
		query = " select tax_rate from"+
				" tax_rate a, (select tax_nm, dpm, max(tax_st_dt) tax_st_dt from tax_rate group by tax_nm, dpm, rate_st1, rate_st2) b"+
				" where a.tax_nm=b.tax_nm and a.dpm=b.dpm and a.tax_st_dt=b.tax_st_dt"+
				" and a.tax_nm='잔가율' and a.rate_st1=? and a.rate_st2=?";


		try {

			pstmt2 = conn.prepareStatement(query2);
    		rs2 = pstmt2.executeQuery();
			if(rs2.next()){			
				dlf_year = rs2.getInt(1);
			}

			pstmt = conn.prepareStatement(query);
			if((dlf_year+1) > 6){
				pstmt.setString(1, "6");
			}else{
				pstmt.setString(1, Integer.toString(dlf_year+1));
			}
			pstmt.setString(2, Integer.toString(now_mon));
    		rs = pstmt.executeQuery();
			if(rs.next()){			
				sur_rate = rs.getString(1).trim();
			}
			rs.close();
			pstmt.close();
			rs2.close();
			pstmt2.close();

		} catch (Exception e) {
			System.out.println("[TaxDatabase:getSurRate]"+ e);
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return sur_rate;
		}
	}

	/**
	 *	세율 가져오기
	 */
	public String getSurRate2(String dlv_dt, String migr_dt, String cls_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		String sur_rate = "";
		int now_year = AddUtil.getDate2(1);		//현재년도
		int now_mon = AddUtil.getDate2(2)-1;	//현재전월

		//경과월이 아닌 경과년으로 계산이 바뀜	
//		if(cls_st.equals("") && Integer.parseInt(AddUtil.ChangeString(dlv_dt)) >= 20030101){
		now_mon = 0;	
//		}

		int dlv_year = 0;
		int dlf_year = 0;

		String s_dt = "to_char(sysdate,'YYYYMMDD')";

		if(!migr_dt.equals("") && !migr_dt.equals(" ")) s_dt = "'"+migr_dt+"'";

		String query2 = "select trunc((to_date(replace("+s_dt+",'-',''),'YYYYMMDD')-to_date(replace('"+dlv_dt+"','-',''),'YYYYMMDD'))/365,0) from dual";
		
		String query = "";
		query = " select tax_rate from"+
				" tax_rate a, (select tax_nm, dpm, max(tax_st_dt) tax_st_dt from tax_rate group by tax_nm, dpm, rate_st1, rate_st2) b"+
				" where a.tax_nm=b.tax_nm and a.dpm=b.dpm and a.tax_st_dt=b.tax_st_dt"+
				" and a.tax_nm='잔가율' and a.rate_st1=? and a.rate_st2=?";


		try {

			if(!dlv_dt.equals("")){

				pstmt2 = conn.prepareStatement(query2);
				rs2 = pstmt2.executeQuery();
				if(rs2.next()){			
					dlf_year = rs2.getInt(1);
				}

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, Integer.toString(dlf_year+1));
				pstmt.setString(2, Integer.toString(now_mon));
				rs = pstmt.executeQuery();
				if(rs.next()){			
					sur_rate = rs.getString(1).trim();
				}
			}
			rs.close();
			pstmt.close();
			rs2.close();
			pstmt2.close();

		} catch (Exception e) {
			System.out.println("[TaxDatabase:getSurRate2]"+ e);
			System.out.println("[TaxDatabase:getSurRate2]"+ query2);
			System.out.println("[TaxDatabase:getSurRate2]"+ query);
			System.out.println("[TaxDatabase:getSurRate2]rate_st1="+ Integer.toString(dlf_year+1));
			System.out.println("[TaxDatabase:getSurRate2]rate_st2="+ Integer.toString(now_mon));
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return sur_rate;
		}
	}

	/**
	 *	출고경과년도 가져오기
	 */
	public int getDlv_year(String dlv_dt)
	{
		getConnection();
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		int dlv_year = 0;

//		String query2 = "select trunc((to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(replace('"+dlv_dt+"','-',''),'YYYYMMDD'))/365,0) from dual";
		String query2 = "select trunc((to_date(to_char(sysdate,'YYYY'),'YYYY')-to_date(substr(replace('"+dlv_dt+"','-',''),1,4),'YYYY'))/365,0) from dual";
		
		try {

			pstmt2 = conn.prepareStatement(query2);
    		rs2 = pstmt2.executeQuery();
			if(rs2.next()){			
				dlv_year = rs2.getInt(1);
			}
			rs2.close();
			pstmt2.close();

		} catch (Exception e) {
			System.out.println("[TaxDatabase:getDlv_year]"+ e);
		} finally {
			try{
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return dlv_year;
		}
	}


	/**
	 *	지출현황 - 특소세 수정화면
	 */
	public TaxScdBean getTaxScdCase(String m_id, String l_cd, String car_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxScdBean bean = new TaxScdBean();
		String query = "";
		query = " select rent_mng_id, rent_l_cd, seq, car_mng_id, sur_rate, sur_amt, tax_rate, spe_tax_amt, edu_tax_amt,"+
		 		" DECODE(est_dt, '', ' ', SUBSTR(est_dt, 1, 4)||'-'||SUBSTR(est_dt, 5, 2)||'-'||SUBSTR(est_dt, 7, 2)) est_dt,"+
		 		" DECODE(pay_dt, '', ' ', SUBSTR(pay_dt, 1, 4)||'-'||SUBSTR(pay_dt, 5, 2)||'-'||SUBSTR(pay_dt, 7, 2)) pay_dt,"+
				" pay_amt, update_dt, update_id, nvl(cls_man_st,' ') cls_man_st, tax_st, tax_apply, rtn_cau, car_fs_amt,"+
		 		" DECODE(tax_come_dt, '', '', SUBSTR(tax_come_dt, 1, 4)||'-'||SUBSTR(tax_come_dt, 5, 2)||'-'||SUBSTR(tax_come_dt, 7, 2)) tax_come_dt"+
				" from car_tax"+
				" where car_mng_id='"+car_id+"'";//rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' and 

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				bean.setRent_mng_id(rs.getString("rent_mng_id")==null?"":rs.getString("rent_mng_id").trim());
				bean.setRent_l_cd(rs.getString("rent_l_cd")==null?"":rs.getString("rent_l_cd").trim());
				bean.setSeq(rs.getString("seq")==null?"":rs.getString("seq").trim());
				bean.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id").trim());
				bean.setSur_rate(rs.getString("sur_rate")==null?"":rs.getString("sur_rate").trim());
				bean.setSur_amt(rs.getInt("sur_amt"));
				bean.setTax_rate(rs.getString("tax_rate")==null?"":rs.getString("tax_rate").trim());
				bean.setSpe_tax_amt(rs.getInt("spe_tax_amt"));
				bean.setEdu_tax_amt(rs.getInt("edu_tax_amt"));
				bean.setEst_dt(rs.getString("est_dt")==null?"":rs.getString("est_dt").trim());
				bean.setPay_dt(rs.getString("pay_dt")==null?"":rs.getString("pay_dt").trim());
				bean.setPay_amt(rs.getInt("pay_amt"));
				bean.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));
				bean.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				bean.setCls_man_st(rs.getString("cls_man_st")==null?"":rs.getString("cls_man_st").trim());
				bean.setTax_st(rs.getString("tax_st")==null?"":rs.getString("tax_st"));
				bean.setTax_apply(rs.getString("tax_apply")==null?"":rs.getString("tax_apply"));
				bean.setRtn_cau(rs.getString("rtn_cau")==null?"":rs.getString("rtn_cau").trim());
				bean.setCar_fs_amt(rs.getInt("car_fs_amt"));
				bean.setTax_come_dt(rs.getString("tax_come_dt")==null?"":rs.getString("tax_come_dt").trim());

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxScdCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	/**
	 * 특소세 INSERT
	 */
	public boolean insertTax(TaxScdBean bean)
	{
		getConnection();
		boolean flag = true;
		String query =  " insert into car_tax "+
						" ( rent_mng_id, rent_l_cd, seq, car_mng_id,"+
						"   sur_rate, sur_amt, tax_rate, spe_tax_amt, edu_tax_amt, est_dt, pay_dt, pay_amt,"+
						"   reg_dt, reg_id, update_dt, update_id, cls_man_st, rtn_dt, rtn_amt,"+
						"   tax_st, tax_apply, tax_come_dt, rtn_cau, car_fs_amt, est_dt2 "+
						" ) values "+
						" ( ?, ?, '00', ?, ?, ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), ?,"+
						"   to_char(sysdate,'YYYYMMDD'), ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?,"+
						"   ?, ?, replace(?, '-', ''), ?, ?, replace(?, '-', '') "+
						" )";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getRent_mng_id().trim());
			pstmt.setString(2,  bean.getRent_l_cd().trim());
			pstmt.setString(3,  bean.getCar_mng_id().trim());
			pstmt.setString(4,  bean.getSur_rate().trim());
		    pstmt.setInt   (5,  bean.getSur_amt());
			pstmt.setString(6,  bean.getTax_rate().trim());
		    pstmt.setInt   (7,  bean.getSpe_tax_amt());
		    pstmt.setInt   (8,  bean.getEdu_tax_amt());
			pstmt.setString(9,  bean.getEst_dt().trim());
			pstmt.setString(10, bean.getPay_dt().trim());
		    pstmt.setInt   (11, bean.getPay_amt());
		    pstmt.setString(12, bean.getReg_id());
		    pstmt.setString(13, bean.getReg_id());
		    pstmt.setString(14, bean.getCls_man_st());
			pstmt.setString(15, bean.getRtn_dt().trim());
		    pstmt.setInt   (16, bean.getRtn_amt());
		    pstmt.setString(17, bean.getTax_st());
		    pstmt.setString(18, bean.getTax_apply());
		    pstmt.setString(19, bean.getTax_come_dt().trim());
			pstmt.setString(20, bean.getRtn_cau().trim());
		    pstmt.setInt   (21, bean.getCar_fs_amt());
			pstmt.setString(22, bean.getEst_dt2().trim());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[TaxDatabase:insertTax]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 * 특소세 UPDATE
	 */
	public boolean updateTax(TaxScdBean bean)
	{
		getConnection();
		boolean flag = true;
		String query =  " update car_tax set"+
						" sur_rate=?, sur_amt=?, tax_rate=?, spe_tax_amt=?, edu_tax_amt=?,"+
						" est_dt=replace(?, '-', ''), pay_dt=replace(?, '-', ''), pay_amt=?,"+
						" update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?, cls_man_st=?,"+
						" rtn_dt=replace(?, '-', ''), rtn_amt=?,"+
						" tax_st=?, tax_apply=?, tax_come_dt=replace(?, '-', ''), rtn_cau=?, car_fs_amt=?"+
						" where rent_mng_id=? and rent_l_cd=? and car_mng_id=?";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getSur_rate().trim());
		    pstmt.setInt(2, bean.getSur_amt());
			pstmt.setString(3, bean.getTax_rate().trim());
		    pstmt.setInt(4, bean.getSpe_tax_amt());
		    pstmt.setInt(5, bean.getEdu_tax_amt());
			pstmt.setString(6, bean.getEst_dt().trim());
			pstmt.setString(7, bean.getPay_dt().trim());
		    pstmt.setInt(8, bean.getPay_amt());
		    pstmt.setString(9, bean.getUpdate_id());
		    pstmt.setString(10, bean.getCls_man_st());
			pstmt.setString(11, bean.getRtn_dt().trim());
		    pstmt.setInt(12, bean.getRtn_amt());
			pstmt.setString(13, bean.getTax_st().trim());
			pstmt.setString(14, bean.getTax_apply().trim());
			pstmt.setString(15, bean.getTax_come_dt().trim());
			pstmt.setString(16, bean.getRtn_cau().trim());
		    pstmt.setInt(17, bean.getCar_fs_amt());
			pstmt.setString(18, bean.getRent_mng_id().trim());
			pstmt.setString(19, bean.getRent_l_cd().trim());
			pstmt.setString(20, bean.getCar_mng_id().trim());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[TaxDatabase:updateTax]"+ e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}


	//재계약 등록 : 할부
	public Hashtable getAllotByCase(String m_id, String l_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select"+
				" L.client_id, C.brch_id, nvl(L.firm_nm, L.client_nm) FIRM_NM, nvl(L.enp_no, TEXT_DECRYPT(l.ssn, 'pw' ) ) ENP_NO, N.car_name, C.car_st, "+
				" R.car_no, decode(R.first_car_no, R.car_no,'-', R.first_car_no) first_car_no, R.car_nm, R.dpm, F.con_mon, decode(F.rent_way, '1','일반식', '2','맞춤식') rent_way,"+
			    " ((E.car_cs_amt+E.car_cv_amt)+(E.opt_cs_amt+E.opt_cv_amt)+(E.clr_cs_amt+E.clr_cv_amt)-(E.dc_cs_amt+E.dc_cv_amt)-(E.tax_dc_s_amt+E.tax_dc_v_amt)) car_c_amt,"+
				" ((E.car_fs_amt+E.car_fv_amt)-(E.dc_cs_amt+E.dc_cv_amt)) car_f_amt,"+
				" (F.fee_s_amt+F.fee_v_amt) fee_amt,"+
				" ((F.fee_s_amt+F.fee_v_amt)*F.con_mon) tot_fee_amt,"+
				" F.grt_amt_s as grt_amt,"+
				" (F.pp_s_amt+F.pp_v_amt) pp_amt,"+
				" (F.ifee_s_amt+F.ifee_v_amt) ifee_amt,"+
				" (F.grt_amt_s+(F.pp_s_amt+F.pp_v_amt)+(F.ifee_s_amt+F.ifee_v_amt)) tot_pre_amt,"+
				" decode(R.init_reg_dt, '', '', substr(R.init_reg_dt, 1, 4) || '-' || substr(R.init_reg_dt, 5, 2) || '-'||substr(R.init_reg_dt, 7, 2)) init_reg_dt,"+
				" decode(C.dlv_dt, '', '', substr(C.dlv_dt, 1, 4) || '-' || substr(C.dlv_dt, 5, 2) || '-'||substr(C.dlv_dt, 7, 2)) dlv_dt,"+
				" decode(P.dlv_con_dt, '', '', substr(P.dlv_con_dt, 1, 4) || '-' || substr(P.dlv_con_dt, 5, 2) || '-'||substr(P.dlv_con_dt, 7, 2)) dlv_con_dt,"+
				" decode(F.rent_start_dt, '', '', substr(F.rent_start_dt, 1, 4) || '-' || substr(F.rent_start_dt, 5, 2) || '-'||substr(F.rent_start_dt, 7, 2)) rent_start_dt,"+
				" decode(F.rent_end_dt, '', '', substr(F.rent_end_dt, 1, 4) || '-' || substr(F.rent_end_dt, 5, 2) || '-'||substr(F.rent_end_dt, 7, 2)) rent_end_dt,"+
				" decode(S.cls_dt, '', '', substr(S.cls_dt, 1, 4) || '-' || substr(S.cls_dt, 5, 2) || '-'||substr(S.cls_dt, 7, 2)) cls_dt,"+
				" decode(C.rent_start_dt, '', ' ', substr(C.rent_start_dt, 1, 4) || '-' || substr(C.rent_start_dt, 5, 2) || '-'||substr(C.rent_start_dt, 7, 2)) c_rent_start_dt,"+
				" decode(C.rent_end_dt, '', ' ', substr(C.rent_end_dt, 1, 4) || '-' || substr(C.rent_end_dt, 5, 2) || '-'||substr(C.rent_end_dt, 7, 2)) c_rent_end_dt,"+
				" decode(U.cont_dt, '', ' ', substr(U.cont_dt, 1, 4) || '-' || substr(U.cont_dt, 5, 2) || '-'||substr(U.cont_dt, 7, 2)) cont_dt,"+
				" decode(U.migr_dt, '', ' ', substr(U.migr_dt, 1, 4) || '-' || substr(U.migr_dt, 5, 2) || '-'||substr(U.migr_dt, 7, 2)) migr_dt,"+
				" decode(F.rent_start_dt, '','', to_char(add_months(to_date(F.rent_start_dt, 'YYYYMMDD'),12),'YYYY-MM-DD')) tax_come_dt, "+
				" to_char(trunc(months_between(nvl(TO_DATE(S.cls_dt, 'YYYYMMDD'),sysdate), TO_DATE(nvl(C.dlv_dt,R.init_reg_dt), 'YYYYMMDD'))/12,0),99) dlv_mon "+ 
				" from client L, car_reg R, car_etc E, Fee F, cont C, car_nm N, car_pur P, cls_cont S, sui U"+
				" where "+
				" C.client_id=L.client_id and F.rent_st='1' and"+
				" C.car_mng_id=R.car_mng_id(+) and"+
				" C.rent_mng_id=E.rent_mng_id and C.rent_l_cd=E.rent_l_cd and"+
				" C.rent_mng_id=F.rent_mng_id and C.rent_l_cd=F.rent_l_cd and"+
				" C.rent_mng_id=P.rent_mng_id and C.rent_l_cd=P.rent_l_cd and"+
				" C.rent_mng_id=S.rent_mng_id(+) and C.rent_l_cd=S.rent_l_cd(+) and"+
				" C.car_mng_id=U.car_mng_id(+) and"+
				" E.car_id=N.car_id(+) and"+
				" C.rent_mng_id = '"+m_id+"' and C.rent_l_cd = '"+l_cd+"'";
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getContDebt]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}	


	// 세율관리 -------------------------------------------------------------------------------------------------

	// 세율관리 리스트 조회
	public Vector getTaxRateList(String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select * from tax_rate order by tax_nm, tax_st_dt, dpm, rate_st1, rate_st2";
			
//		if(s_kd.equals("1"))		query += " and nvl(firm_nm, '') like '%"+t_wd+"%'\n";			
//		else if(s_kd.equals("2"))	query += " and nvl(c.client_nm, '') like '%"+t_wd+"%'\n";

		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			while(rs.next())
			{				
				TaxRateBean bean = new TaxRateBean();
				bean.setTax_nm(rs.getString("tax_nm")==null?"":rs.getString("tax_nm"));
				bean.setDpm(rs.getString("dpm")==null?"":rs.getString("dpm"));
				bean.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));
				bean.setReg_id(rs.getString("reg_id")==null?"":rs.getString("reg_id"));
				bean.setTax_st_dt(rs.getString("tax_st_dt")==null?"":rs.getString("tax_st_dt"));
				bean.setTax_rate(rs.getString("tax_rate")==null?"":rs.getString("tax_rate"));
				bean.setRate_st1(rs.getString("rate_st1")==null?"":rs.getString("rate_st1"));
				bean.setRate_st2(rs.getString("rate_st2")==null?"":rs.getString("rate_st2"));
				vt.add(bean);	
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxRateList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 세율관리 INSERT
	 */
	public boolean insertTaxRate(TaxRateBean bean)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into tax_rate values"+
						" (?, ?, replace(?, '-', ''), ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, '')";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getTax_nm().trim());
			pstmt.setString(2, bean.getDpm().trim());
			pstmt.setString(3, bean.getTax_st_dt().trim());
			pstmt.setString(4, bean.getTax_rate().trim());
		    pstmt.setString(5, bean.getReg_id().trim());
		    pstmt.setString(6, bean.getRate_st1().trim());
		    pstmt.setString(7, bean.getRate_st2().trim());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[TaxDatabase:insertTaxRate]"+ e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
	
	/**
	 * 세율관리 UPDATE
	 */
	public boolean updateTaxRate(TaxRateBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "update tax_rate set"+
							" TAX_RATE = ?,"+
							" RATE_ST1 = ?,"+
							" RATE_ST2 = ?,"+
							" REG_DT = to_char(sysdate,'YYYYMMDD'),"+
							" REG_ID = ?"+
							" where TAX_NM = ? and DPM=? and TAX_ST_DT=replace(?, '-', '')";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getTax_rate().trim());
			pstmt.setString(2, bean.getRate_st1().trim());
			pstmt.setString(3, bean.getRate_st2().trim());
		    pstmt.setString(4, bean.getReg_id().trim());
			pstmt.setString(5, bean.getTax_nm().trim());
			pstmt.setString(6, bean.getDpm().trim());
			pstmt.setString(7, bean.getTax_st_dt().trim());
		    pstmt.executeUpdate();
			pstmt.close();
		   	conn.commit();
	  	} catch (Exception e) {
			System.out.println("[TaxDatabase:updateTaxRate]"+ e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	지정날짜로 부터 몇개월 전 날자 조회
	 */
	public String getViewYM(String cur_date, int day, String format)
	{
		getConnection();
            
		String query = "select to_char(add_months(to_date('"+ cur_date +"', '"+format+"'),-"+ day +"),'"+format+"')  from dual";
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtn = "";
		try {
			    pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			while(rs.next())
			{				
				 rtn = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getViewYM]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException ignore){}
			closeConnection();
			return rtn;
		}
	}	
	
	/**
	 *	차량관리번호로 특소세 납부체크
	 */
	public int getTaxRegCount(String car_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";
		
		query = " select count(*) from car_tax where car_mng_id = '"+car_id+"'";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				count = rs.getInt(1);
			}
			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxRegCount]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	

	/**
	 *	특소세엑셀확인
	 */
	public TaxScdBean getTaxScdExcelChk(String init_reg_dt, String car_num, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxScdBean bean = new TaxScdBean();
		String query = "";
		query = " select a.rent_mng_id, a.rent_l_cd, a.seq, a.car_mng_id, a.sur_rate, a.sur_amt, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt,"+
		 		" DECODE(a.est_dt, '', ' ', SUBSTR(a.est_dt, 1, 4)||'-'||SUBSTR(a.est_dt, 5, 2)||'-'||SUBSTR(a.est_dt, 7, 2)) est_dt,"+
		 		" DECODE(a.pay_dt, '', ' ', SUBSTR(a.pay_dt, 1, 4)||'-'||SUBSTR(a.pay_dt, 5, 2)||'-'||SUBSTR(a.pay_dt, 7, 2)) pay_dt,"+
				" a.pay_amt, a.update_dt, a.update_id, nvl(a.cls_man_st,' ') cls_man_st, a.tax_st, a.tax_apply, a.rtn_cau, (b.car_fs_amt+b.car_fv_amt) car_f_amt, a.car_fs_amt,"+
		 		" DECODE(a.tax_come_dt, '', '', SUBSTR(a.tax_come_dt, 1, 4)||'-'||SUBSTR(a.tax_come_dt, 5, 2)||'-'||SUBSTR(tax_come_dt, 7, 2)) tax_come_dt,"+
				" c.init_reg_dt, c.car_num"+
				" from car_tax a, car_etc b, car_reg c"+
				" where a.car_mng_id = (select a.car_mng_id from car_reg a, cont b where a.car_mng_id=b.car_mng_id "+
				" "; 
		
		if(!init_reg_dt.equals("")) query += " and a.init_reg_dt='"+init_reg_dt+"' ";
		
		if(!car_num.equals(""))		query += " and a.car_num like '%"+car_num+"' ";

		if(!car_no.equals(""))		query += " and a.first_car_no='"+car_no+"' ";
			
		query += " group by a.car_mng_id)";
		
		query += " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=c.car_mng_id";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				bean.setRent_mng_id(rs.getString("rent_mng_id")==null?"":rs.getString("rent_mng_id").trim());
				bean.setRent_l_cd(rs.getString("rent_l_cd")==null?"":rs.getString("rent_l_cd").trim());
				bean.setSeq(rs.getString("seq")==null?"":rs.getString("seq").trim());
				bean.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id").trim());
				bean.setSur_rate(rs.getString("sur_rate")==null?"":rs.getString("sur_rate").trim());
				bean.setSur_amt(rs.getInt("sur_amt"));
				bean.setTax_rate(rs.getString("tax_rate")==null?"":rs.getString("tax_rate").trim());
				bean.setSpe_tax_amt(rs.getInt("spe_tax_amt"));
				bean.setEdu_tax_amt(rs.getInt("edu_tax_amt"));
				bean.setEst_dt(rs.getString("est_dt")==null?"":rs.getString("est_dt").trim());
				bean.setPay_dt(rs.getString("pay_dt")==null?"":rs.getString("pay_dt").trim());
				bean.setPay_amt(rs.getInt("pay_amt"));
				bean.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));
				bean.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				bean.setCls_man_st(rs.getString("cls_man_st")==null?"":rs.getString("cls_man_st").trim());
				bean.setTax_st(rs.getString("tax_st")==null?"":rs.getString("tax_st"));
				bean.setTax_apply(rs.getString("tax_apply")==null?"":rs.getString("tax_apply"));
				bean.setRtn_cau(rs.getString("rtn_cau")==null?"":rs.getString("rtn_cau").trim());
				bean.setCar_fs_amt(rs.getInt("car_fs_amt"));
				bean.setTax_come_dt(rs.getString("tax_come_dt")==null?"":rs.getString("tax_come_dt").trim());
				bean.setInit_reg_dt(rs.getString("init_reg_dt")==null?"":rs.getString("init_reg_dt").trim());
				bean.setCar_num(rs.getString("car_num")==null?"":rs.getString("car_num").trim());

			}
			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxScdExcelChk]"+ e);
			System.out.println("[TaxDatabase:getTaxScdExcelChk]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	/**
	 *	특소세엑셀확인
	 */
	public TaxScdBean getTaxScdExcelChk2(String init_reg_dt, String car_num, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxScdBean bean = new TaxScdBean();
		String query = "";
		query = " select a.rent_mng_id, a.rent_l_cd, a.seq, a.car_mng_id, a.sur_rate, a.sur_amt, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt,"+
		 		" DECODE(a.est_dt, '', ' ', SUBSTR(a.est_dt, 1, 4)||'-'||SUBSTR(a.est_dt, 5, 2)||'-'||SUBSTR(a.est_dt, 7, 2)) est_dt,"+
		 		" DECODE(a.pay_dt, '', ' ', SUBSTR(a.pay_dt, 1, 4)||'-'||SUBSTR(a.pay_dt, 5, 2)||'-'||SUBSTR(a.pay_dt, 7, 2)) pay_dt,"+
				" a.pay_amt, a.update_dt, a.update_id, nvl(a.cls_man_st,' ') cls_man_st, a.tax_st, a.tax_apply, a.rtn_cau, (b.car_fs_amt+b.car_fv_amt) car_f_amt, a.car_fs_amt,"+
		 		" DECODE(a.tax_come_dt, '', '', SUBSTR(a.tax_come_dt, 1, 4)||'-'||SUBSTR(a.tax_come_dt, 5, 2)||'-'||SUBSTR(tax_come_dt, 7, 2)) tax_come_dt,"+
				" c.init_reg_dt, c.car_num"+
				" from car_tax a, car_etc b, car_reg c"+
				" where a.car_mng_id = (select a.car_mng_id from car_reg a, cont b where a.first_car_no='"+car_no+"' and substr(a.init_reg_dt,1,6)=substr('"+init_reg_dt+"',1,6) and a.car_mng_id=b.car_mng_id group by a.car_mng_id)"+
			    " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=c.car_mng_id";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				bean.setRent_mng_id(rs.getString("rent_mng_id")==null?"":rs.getString("rent_mng_id").trim());
				bean.setRent_l_cd(rs.getString("rent_l_cd")==null?"":rs.getString("rent_l_cd").trim());
				bean.setSeq(rs.getString("seq")==null?"":rs.getString("seq").trim());
				bean.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id").trim());
				bean.setSur_rate(rs.getString("sur_rate")==null?"":rs.getString("sur_rate").trim());
				bean.setSur_amt(rs.getInt("sur_amt"));
				bean.setTax_rate(rs.getString("tax_rate")==null?"":rs.getString("tax_rate").trim());
				bean.setSpe_tax_amt(rs.getInt("spe_tax_amt"));
				bean.setEdu_tax_amt(rs.getInt("edu_tax_amt"));
				bean.setEst_dt(rs.getString("est_dt")==null?"":rs.getString("est_dt").trim());
				bean.setPay_dt(rs.getString("pay_dt")==null?"":rs.getString("pay_dt").trim());
				bean.setPay_amt(rs.getInt("pay_amt"));
				bean.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));
				bean.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				bean.setCls_man_st(rs.getString("cls_man_st")==null?"":rs.getString("cls_man_st").trim());
				bean.setTax_st(rs.getString("tax_st")==null?"":rs.getString("tax_st"));
				bean.setTax_apply(rs.getString("tax_apply")==null?"":rs.getString("tax_apply"));
				bean.setRtn_cau(rs.getString("rtn_cau")==null?"":rs.getString("rtn_cau").trim());
				bean.setCar_fs_amt(rs.getInt("car_fs_amt"));
				bean.setTax_come_dt(rs.getString("tax_come_dt")==null?"":rs.getString("tax_come_dt").trim());
				bean.setInit_reg_dt(rs.getString("init_reg_dt")==null?"":rs.getString("init_reg_dt").trim());
				bean.setCar_num(rs.getString("car_num")==null?"":rs.getString("car_num").trim());

			}
			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxScdExcelChk2]"+ e);
			System.out.println("[TaxDatabase:getTaxScdExcelChk2]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	/**
	 *	특소세엑셀확인
	 */
	public TaxScdBean getTaxScdExcelChk3(String init_reg_dt, String car_num, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxScdBean bean = new TaxScdBean();
		String query = "";
		query = " select a.rent_mng_id, a.rent_l_cd, a.seq, a.car_mng_id, a.sur_rate, a.sur_amt, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt,"+
		 		" DECODE(a.est_dt, '', ' ', SUBSTR(a.est_dt, 1, 4)||'-'||SUBSTR(a.est_dt, 5, 2)||'-'||SUBSTR(a.est_dt, 7, 2)) est_dt,"+
		 		" DECODE(a.pay_dt, '', ' ', SUBSTR(a.pay_dt, 1, 4)||'-'||SUBSTR(a.pay_dt, 5, 2)||'-'||SUBSTR(a.pay_dt, 7, 2)) pay_dt,"+
				" a.pay_amt, a.update_dt, a.update_id, nvl(a.cls_man_st,' ') cls_man_st, a.tax_st, a.tax_apply, a.rtn_cau, (b.car_fs_amt+b.car_fv_amt) car_f_amt, a.car_fs_amt,"+
		 		" DECODE(a.tax_come_dt, '', '', SUBSTR(a.tax_come_dt, 1, 4)||'-'||SUBSTR(a.tax_come_dt, 5, 2)||'-'||SUBSTR(tax_come_dt, 7, 2)) tax_come_dt,"+
				" c.init_reg_dt, c.car_num"+
				" from car_tax a, car_etc b, car_reg c"+
				" where a.car_mng_id = (select a.car_mng_id from car_reg a, cont b where a.car_no||' '||a.first_car_no like '%"+car_no+"%' and a.car_num like '%"+car_num+"' and a.car_mng_id=b.car_mng_id group by a.car_mng_id)"+
			    " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=c.car_mng_id";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				bean.setRent_mng_id(rs.getString("rent_mng_id")==null?"":rs.getString("rent_mng_id").trim());
				bean.setRent_l_cd(rs.getString("rent_l_cd")==null?"":rs.getString("rent_l_cd").trim());
				bean.setSeq(rs.getString("seq")==null?"":rs.getString("seq").trim());
				bean.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id").trim());
				bean.setSur_rate(rs.getString("sur_rate")==null?"":rs.getString("sur_rate").trim());
				bean.setSur_amt(rs.getInt("sur_amt"));
				bean.setTax_rate(rs.getString("tax_rate")==null?"":rs.getString("tax_rate").trim());
				bean.setSpe_tax_amt(rs.getInt("spe_tax_amt"));
				bean.setEdu_tax_amt(rs.getInt("edu_tax_amt"));
				bean.setEst_dt(rs.getString("est_dt")==null?"":rs.getString("est_dt").trim());
				bean.setPay_dt(rs.getString("pay_dt")==null?"":rs.getString("pay_dt").trim());
				bean.setPay_amt(rs.getInt("pay_amt"));
				bean.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));
				bean.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				bean.setCls_man_st(rs.getString("cls_man_st")==null?"":rs.getString("cls_man_st").trim());
				bean.setTax_st(rs.getString("tax_st")==null?"":rs.getString("tax_st"));
				bean.setTax_apply(rs.getString("tax_apply")==null?"":rs.getString("tax_apply"));
				bean.setRtn_cau(rs.getString("rtn_cau")==null?"":rs.getString("rtn_cau").trim());
				bean.setCar_fs_amt(rs.getInt("car_fs_amt"));
				bean.setTax_come_dt(rs.getString("tax_come_dt")==null?"":rs.getString("tax_come_dt").trim());
				bean.setInit_reg_dt(rs.getString("init_reg_dt")==null?"":rs.getString("init_reg_dt").trim());
				bean.setCar_num(rs.getString("car_num")==null?"":rs.getString("car_num").trim());

			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxScdExcelChk3]"+ e);
			System.out.println("[TaxDatabase:getTaxScdExcelChk3]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	/**
	 *	특소세엑셀확인
	 */
	public TaxScdBean getTaxScdExcelChk4(String init_reg_dt, String car_num, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxScdBean bean = new TaxScdBean();
		String query = "";
		query = " select a.rent_mng_id, a.rent_l_cd, a.seq, a.car_mng_id, a.sur_rate, a.sur_amt, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt,"+
		 		" DECODE(a.est_dt, '', ' ', SUBSTR(a.est_dt, 1, 4)||'-'||SUBSTR(a.est_dt, 5, 2)||'-'||SUBSTR(a.est_dt, 7, 2)) est_dt,"+
		 		" DECODE(a.pay_dt, '', ' ', SUBSTR(a.pay_dt, 1, 4)||'-'||SUBSTR(a.pay_dt, 5, 2)||'-'||SUBSTR(a.pay_dt, 7, 2)) pay_dt,"+
				" a.pay_amt, a.update_dt, a.update_id, nvl(a.cls_man_st,' ') cls_man_st, a.tax_st, a.tax_apply, a.rtn_cau, (b.car_fs_amt+b.car_fv_amt) car_f_amt, a.car_fs_amt,"+
		 		" DECODE(a.tax_come_dt, '', '', SUBSTR(a.tax_come_dt, 1, 4)||'-'||SUBSTR(a.tax_come_dt, 5, 2)||'-'||SUBSTR(tax_come_dt, 7, 2)) tax_come_dt,"+
				" c.init_reg_dt, c.car_num"+
				" from car_tax a, car_etc b, car_reg c"+
				" where a.car_mng_id = (select a.car_mng_id from car_reg a, cont b where a.first_car_no='"+car_no+"' and substr(a.init_reg_dt,1,4)=substr('"+init_reg_dt+"',1,4) and a.car_mng_id=b.car_mng_id group by a.car_mng_id)"+
			    " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=c.car_mng_id";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				bean.setRent_mng_id(rs.getString("rent_mng_id")==null?"":rs.getString("rent_mng_id").trim());
				bean.setRent_l_cd(rs.getString("rent_l_cd")==null?"":rs.getString("rent_l_cd").trim());
				bean.setSeq(rs.getString("seq")==null?"":rs.getString("seq").trim());
				bean.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id").trim());
				bean.setSur_rate(rs.getString("sur_rate")==null?"":rs.getString("sur_rate").trim());
				bean.setSur_amt(rs.getInt("sur_amt"));
				bean.setTax_rate(rs.getString("tax_rate")==null?"":rs.getString("tax_rate").trim());
				bean.setSpe_tax_amt(rs.getInt("spe_tax_amt"));
				bean.setEdu_tax_amt(rs.getInt("edu_tax_amt"));
				bean.setEst_dt(rs.getString("est_dt")==null?"":rs.getString("est_dt").trim());
				bean.setPay_dt(rs.getString("pay_dt")==null?"":rs.getString("pay_dt").trim());
				bean.setPay_amt(rs.getInt("pay_amt"));
				bean.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));
				bean.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				bean.setCls_man_st(rs.getString("cls_man_st")==null?"":rs.getString("cls_man_st").trim());
				bean.setTax_st(rs.getString("tax_st")==null?"":rs.getString("tax_st"));
				bean.setTax_apply(rs.getString("tax_apply")==null?"":rs.getString("tax_apply"));
				bean.setRtn_cau(rs.getString("rtn_cau")==null?"":rs.getString("rtn_cau").trim());
				bean.setCar_fs_amt(rs.getInt("car_fs_amt"));
				bean.setTax_come_dt(rs.getString("tax_come_dt")==null?"":rs.getString("tax_come_dt").trim());
				bean.setInit_reg_dt(rs.getString("init_reg_dt")==null?"":rs.getString("init_reg_dt").trim());
				bean.setCar_num(rs.getString("car_num")==null?"":rs.getString("car_num").trim());

			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxScdExcelChk4]"+ e);
			System.out.println("[TaxDatabase:getTaxScdExcelChk4]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	/**
	 *	특소세엑셀확인
	 */
	public TaxScdBean getTaxScdExcelChk5(String init_reg_dt, String car_num, String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TaxScdBean bean = new TaxScdBean();
		String query = "";
		query = " select a.rent_mng_id, a.rent_l_cd, a.seq, a.car_mng_id, a.sur_rate, a.sur_amt, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt,"+
		 		" DECODE(a.est_dt, '', ' ', SUBSTR(a.est_dt, 1, 4)||'-'||SUBSTR(a.est_dt, 5, 2)||'-'||SUBSTR(a.est_dt, 7, 2)) est_dt,"+
		 		" DECODE(a.pay_dt, '', ' ', SUBSTR(a.pay_dt, 1, 4)||'-'||SUBSTR(a.pay_dt, 5, 2)||'-'||SUBSTR(a.pay_dt, 7, 2)) pay_dt,"+
				" a.pay_amt, a.update_dt, a.update_id, nvl(a.cls_man_st,' ') cls_man_st, a.tax_st, a.tax_apply, a.rtn_cau, (b.car_fs_amt+b.car_fv_amt) car_f_amt, a.car_fs_amt,"+
		 		" DECODE(a.tax_come_dt, '', '', SUBSTR(a.tax_come_dt, 1, 4)||'-'||SUBSTR(a.tax_come_dt, 5, 2)||'-'||SUBSTR(tax_come_dt, 7, 2)) tax_come_dt,"+
				" c.init_reg_dt, c.car_num"+
				" from car_tax a, car_etc b, car_reg c"+
				" where a.car_mng_id = (select a.car_mng_id from car_reg a, cont b where a.car_num='"+car_num+"' and a.car_mng_id=b.car_mng_id group by a.car_mng_id)"+
			    " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=c.car_mng_id";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){			
				bean.setRent_mng_id(rs.getString("rent_mng_id")==null?"":rs.getString("rent_mng_id").trim());
				bean.setRent_l_cd(rs.getString("rent_l_cd")==null?"":rs.getString("rent_l_cd").trim());
				bean.setSeq(rs.getString("seq")==null?"":rs.getString("seq").trim());
				bean.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id").trim());
				bean.setSur_rate(rs.getString("sur_rate")==null?"":rs.getString("sur_rate").trim());
				bean.setSur_amt(rs.getInt("sur_amt"));
				bean.setTax_rate(rs.getString("tax_rate")==null?"":rs.getString("tax_rate").trim());
				bean.setSpe_tax_amt(rs.getInt("spe_tax_amt"));
				bean.setEdu_tax_amt(rs.getInt("edu_tax_amt"));
				bean.setEst_dt(rs.getString("est_dt")==null?"":rs.getString("est_dt").trim());
				bean.setPay_dt(rs.getString("pay_dt")==null?"":rs.getString("pay_dt").trim());
				bean.setPay_amt(rs.getInt("pay_amt"));
				bean.setUpdate_dt(rs.getString("update_dt")==null?"":rs.getString("update_dt"));
				bean.setUpdate_id(rs.getString("update_id")==null?"":rs.getString("update_id"));
				bean.setCls_man_st(rs.getString("cls_man_st")==null?"":rs.getString("cls_man_st").trim());
				bean.setTax_st(rs.getString("tax_st")==null?"":rs.getString("tax_st"));
				bean.setTax_apply(rs.getString("tax_apply")==null?"":rs.getString("tax_apply"));
				bean.setRtn_cau(rs.getString("rtn_cau")==null?"":rs.getString("rtn_cau").trim());
				bean.setCar_fs_amt(rs.getInt("car_fs_amt"));
				bean.setTax_come_dt(rs.getString("tax_come_dt")==null?"":rs.getString("tax_come_dt").trim());
				bean.setInit_reg_dt(rs.getString("init_reg_dt")==null?"":rs.getString("init_reg_dt").trim());
				bean.setCar_num(rs.getString("car_num")==null?"":rs.getString("car_num").trim());

			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TaxDatabase:getTaxScdExcelChk4]"+ e);
			System.out.println("[TaxDatabase:getTaxScdExcelChk4]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

	/**
	 *	특소세엑셀확인 자동차코드가져오기
	 */
	public String getCarIdExcelChk(String init_reg_dt, String car_num, String car_no)
	{
		getConnection();
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		String car_mng_id = "";

		String query2 = "select a.car_mng_id from car_reg a, cont b where a.first_car_no='"+car_no+"' and substr(a.init_reg_dt,1,6)=substr('"+init_reg_dt+"',1,6) and a.car_mng_id=b.car_mng_id group by a.car_mng_id";
		
		try {

			pstmt2 = conn.prepareStatement(query2);
    		rs2 = pstmt2.executeQuery();
			if(rs2.next()){			
				car_mng_id = rs2.getString(1);
			}
			rs2.close();
            pstmt2.close();

		} catch (Exception e) {
			System.out.println("[TaxDatabase:getCarIdExcelChk]"+ e);
		} finally {
			try{
                if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return car_mng_id;
		}
	}


	/**
	 *	세율 가져오기
	 */
	public String getSurRate200812(String dlv_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sur_rate = "";		
		String query = "";


		query = " select tax_rate "+
				" from   tax_rate a, (select tax_nm, dpm, rate_st1, rate_st2, max(tax_st_dt) tax_st_dt from tax_rate group by tax_nm, dpm, rate_st1, rate_st2) b"+
				" where  a.tax_nm=b.tax_nm and a.dpm=b.dpm and a.rate_st1=b.rate_st1 and a.rate_st2=b.rate_st2 and a.tax_st_dt=b.tax_st_dt"+
				"        and a.tax_nm='잔가율' "+
				"        and a.rate_st2='0' "+
				"        and a.rate_st1='"+dlv_year+"' "+
				"	";


		try {

			pstmt = conn.prepareStatement(query);
    		rs = pstmt.executeQuery();
			if(rs.next()){			
				sur_rate = rs.getString(1).trim();
			}
			rs.close();
            pstmt.close();

		} catch (Exception e) {
			System.out.println("[TaxDatabase:getSurRate200812]"+ e);
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sur_rate;
		}
	}

	/**
	 *	지출현황 - 특소세 납부처리를 위한 리스트
	 */
	public Vector getTaxPayList2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.seq, b.firm_nm,"+
				" b.use_yn, d.car_no, d.car_num, g.car_nm, c.car_name, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt, (a.spe_tax_amt+a.edu_tax_amt) as amt, nvl(a.rtn_amt,0) rtn_amt,"+
				" d.dpm, a.car_fs_amt, a.sur_rate, a.sur_amt, decode(a.tax_st,'1','장기대여','2','매각','3','용도변경','4','폐차') tax_st,"+
				" decode(a.pay_dt,'','0','1') pay_yn, b.dlv_dt, d.init_reg_dt, "+
				" decode(f.rent_start_dt, '', '', substr(f.rent_start_dt, 1, 4) || '-' || substr(f.rent_start_dt, 5, 2) || '-'||substr(f.rent_start_dt, 7, 2)) rent_start_dt,"+
				" decode(a.pay_dt, '', '', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt,"+
				" decode(a.est_dt, '', '', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				" decode(a.rtn_dt, '', '', substr(a.rtn_dt, 1, 4) || '-' || substr(a.rtn_dt, 5, 2) || '-'||substr(a.rtn_dt, 7, 2)) rtn_dt,"+
				" decode(a.tax_come_dt, '', '', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt,"+
			    " DECODE(y.rent_l_cd,'',CASE WHEN d.init_reg_dt > DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) THEN d.init_reg_dt ELSE DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) end,y.cls_dt) AS rent_start_dt2, "+
				" a.bk_122, a.ch_327, a.tax_dc_amt "+
				" from   car_tax a, cont_n_view b, car_nm c, car_reg d, car_etc e, fee f, car_mng g, (SELECT * FROM CLS_CONT WHERE cls_st IN ('4','5')) y, TAECHA j "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and e.car_id=c.car_id(+) and e.car_seq=c.car_seq and c.car_comp_id=g.car_comp_id and c.car_cd=g.code"+
				" and b.car_mng_id=d.car_mng_id and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1'"+
				" AND b.rent_mng_id=y.rent_mng_id(+) AND b.reg_dt=y.reg_dt(+) "+
				" and b.rent_mng_id=j.rent_mng_id(+) and b.rent_l_cd=j.rent_l_cd(+) and nvl(j.no,'0')='0' "+
				" ";		


		if(gubun5.equals("1"))			query += " and a.pay_dt is null";
		else if(gubun5.equals("2"))		query += " and a.pay_dt is not null";

		/*상세조회&&세부조회*/

		//당월-납부
		if(gubun2.equals("1")){			query += " and a.est_dt like to_char(sysdate,'YYYYMM')||'%'";
		}else if(gubun2.equals("4")){	
			if(!st_dt.equals("") && !end_dt.equals("")){
				query += " and a.est_dt BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')"; 
			}else if(!st_dt.equals("") && end_dt.equals("")){
				st_dt = AddUtil.replace(st_dt, "-", "");
			query += " and a.est_dt like '"+st_dt+"%'";
			}
		}
	
		if(gubun4.equals("1"))			query += " and nvl(a.tax_st,'0') ='1'";
		else if(gubun4.equals("2"))		query += " and nvl(a.tax_st,'0') ='2'";
		else if(gubun4.equals("3"))		query += " and nvl(a.tax_st,'0') ='3'";
		else if(gubun4.equals("4"))		query += " and nvl(a.tax_st,'0') ='4'";
		

		/*검색조건*/			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(d.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("5"))	query += " and (a.spe_tax_amt+a.edu_tax_amt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and g.car_nm||c.car_name like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/
		if(sort_gubun.equals("0"))		query += " order by a.pay_dt "+sort+", tax_st desc, d.dpm desc, b.rent_start_dt";
		else if(sort_gubun.equals("1"))	query += " order by b.firm_nm "+sort+", a.est_dt, a.pay_dt";
		else if(sort_gubun.equals("3"))	query += " order by a.spe_tax_amt "+sort+", a.est_dt, b.firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by d.car_no "+sort+",  b.firm_nm, a.est_dt";


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
			System.out.println("[TaxDatabase:getTaxPayList]"+ e);
			System.out.println("[TaxDatabase:getTaxPayList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 납부예정 처리를 위한 리스트
	 */
	public Vector getTaxStatList2(String s_est_y)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";


		query = " select \n"+
				" substr(est_dt,1,6) dt, \n"+
				" max(substr(tax_come_dt,1,6)) dt2, \n"+
				" substr(est_dt2,1,6) dt3, \n"+
				" max(est_dt) est_dt, \n"+
				" count(car_mng_id) cnt0, \n"+
				" count(decode(tax_st,'1',car_mng_id)) cnt1, \n"+
				" count(decode(tax_st,'2',car_mng_id)) cnt2, \n"+
				" count(decode(tax_st,'3',car_mng_id)) cnt3, \n"+
				" count(decode(tax_st,'4',car_mng_id)) cnt4, \n"+
				" count(decode(pay_dt,'',car_mng_id)) cnt5, \n"+
				" count(decode(pay_dt,'','',car_mng_id)) cnt6, \n"+
				" sum  (pay_amt) amt0, \n"+
				" sum  (decode(tax_st,'1',pay_amt)) amt1, \n"+
				" sum  (decode(tax_st,'2',pay_amt)) amt2, \n"+
				" sum  (decode(tax_st,'3',pay_amt)) amt3, \n"+
				" sum  (decode(tax_st,'4',pay_amt)) amt4, \n"+
				" sum  (decode(pay_dt,'',pay_amt)) amt5, \n"+
				" sum  (decode(pay_dt,'','',pay_amt)) amt6 \n"+
				" from car_tax \n"+
				" where est_dt like '"+s_est_y+"%' \n"+
				" group by substr(est_dt,1,6), substr(est_dt2,1,6) order by substr(est_dt,1,6)";


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
			System.out.println("[TaxDatabase:getTaxStatList2]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 특소세 UPDATE
	 */
	public boolean updateTaxAllPay(String est_dt, String pay_dt)
	{
		getConnection();
		boolean flag = true;
		String query =  " update car_tax set"+
						" pay_dt=replace(?, '-', '')"+
						" where est_dt=replace(?, '-', '')";

		PreparedStatement pstmt = null;
		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, pay_dt.trim());
			pstmt.setString(2, est_dt.trim());
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[TaxDatabase:updateTaxAllPay]"+ e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	지출현황 - 특소세 납부처리를 위한 리스트
	 */
	public Vector getTaxMngList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select  a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.seq, b.firm_nm,"+
				" b.use_yn, d.car_no, d.car_num, g.car_nm, c.car_name, a.tax_rate, a.spe_tax_amt, a.edu_tax_amt, (a.spe_tax_amt+a.edu_tax_amt) as amt, nvl(a.rtn_amt,0) rtn_amt,"+
				" d.dpm, a.car_fs_amt, a.sur_rate, a.sur_amt, decode(a.tax_st,'1','장기대여','2','매각','3','용도변경','4','폐차') tax_st,"+
				" decode(a.pay_dt,'','0','1') pay_yn, b.dlv_dt,"+
				" decode(f.rent_start_dt, '', '', substr(f.rent_start_dt, 1, 4) || '-' || substr(f.rent_start_dt, 5, 2) || '-'||substr(f.rent_start_dt, 7, 2)) rent_start_dt,"+
				" decode(a.pay_dt, '', '', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt,"+
				" decode(a.est_dt, '', '', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				" decode(a.rtn_dt, '', '', substr(a.rtn_dt, 1, 4) || '-' || substr(a.rtn_dt, 5, 2) || '-'||substr(a.rtn_dt, 7, 2)) rtn_dt,"+
				" decode(a.tax_come_dt, '', '', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt"+
				" from car_tax a, cont_n_view b, car_nm c, car_reg d, car_etc e, fee f, car_mng g "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and e.car_id=c.car_id(+) and e.car_seq=c.car_seq and c.car_comp_id=g.car_comp_id and c.car_cd=g.code"+
				" and b.car_mng_id=d.car_mng_id and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' "+
				" ";


		if(gubun4.equals("1"))			query += " and a.pay_dt is null";
		else if(gubun4.equals("2"))		query += " and a.pay_dt is not null";

		if(gubun3.equals("1"))			query += " and nvl(a.tax_st,'0') ='1'";
		else if(gubun3.equals("2"))		query += " and nvl(a.tax_st,'0') ='2'";
		else if(gubun3.equals("3"))		query += " and nvl(a.tax_st,'0') ='3'";
		else if(gubun3.equals("4"))		query += " and nvl(a.tax_st,'0') ='4'";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		String dt3 = "";

		dt1 = "substr(nvl(a.pay_dt,a.est_dt2),1,6)";
		dt2 = "substr(nvl(a.pay_dt,a.est_dt2),1,4)";
		dt3 = "nvl(a.pay_dt,a.est_dt2)";

		if(gubun1.equals("1")){
			dt1 = "substr(a.tax_come_dt,1,6)";
			dt2 = "substr(a.tax_come_dt,1,4)";
			dt3 = "a.tax_come_dt";
		}else if(gubun1.equals("3")){
			dt1 = "substr(a.est_dt,1,6)";
			dt2 = "substr(a.est_dt,1,4)";
			dt3 = "a.est_dt";
		}

		//년도별
		if(gubun2.equals("1")){			query += " and "+dt3+" like '"+gubun5+"%'";
		//분기별
		}else if(gubun2.equals("2")){			
			if(gubun6.equals("1"))	query += " and "+dt3+" between '"+gubun5+"0101' and '"+gubun5+"0331' \n";
			if(gubun6.equals("2"))	query += " and "+dt3+" between '"+gubun5+"0401' and '"+gubun5+"0630' \n";
			if(gubun6.equals("3"))	query += " and "+dt3+" between '"+gubun5+"0701' and '"+gubun5+"0930' \n";
			if(gubun6.equals("4"))	query += " and "+dt3+" between '"+gubun5+"1001' and '"+gubun5+"1231' \n";
		//월별
		}else if(gubun2.equals("3")){
			query += " and "+dt3+" like '"+gubun5+gubun7+"%' \n";
		//기간
		}else if(gubun2.equals("4")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt3+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt3+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		/*검색조건*/			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm||b.client_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("3"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(d.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("3"))	query += " and (nvl(d.car_num, '') like '%"+t_wd+"%' \n";
		else if(s_kd.equals("5"))	query += " and g.car_nm||c.car_name like '%"+t_wd+"%'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/
		if(sort_gubun.equals("6"))		query += " order by a.pay_dt "+sort+", tax_st desc, d.dpm desc, b.rent_start_dt";
		else if(sort_gubun.equals("1"))	query += " order by b.firm_nm "+sort+", a.est_dt, a.pay_dt";
		else if(sort_gubun.equals("2"))	query += " order by d.car_no "+sort+",  b.firm_nm, a.est_dt";
		else if(sort_gubun.equals("3"))	query += " order by d.car_num "+sort+",  b.firm_nm, a.est_dt";
		else if(sort_gubun.equals("4"))	query += " order by a.spe_tax_amt "+sort+", a.est_dt, b.firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by a.est_dt "+sort+", tax_st desc, d.dpm desc, b.rent_start_dt";

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
			System.out.println("[TaxDatabase:getTaxMngList]"+ e);
			System.out.println("[TaxDatabase:getTaxMngList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}

	/**
	 *	지출현황 - 특소세 납부 처리를 위한 리스트 --> 엑셀파일
	 */
	public Vector getTaxExcelList1_1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc, String dpm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select TO_CHAR( ADD_MONTHS( decode(g.cls_st,'4',g.cls_dt,'5',nvl(h.rent_suc_dt,g.cls_dt),f.rent_start_dt),12), 'YYYYMMDD') AS rent_start_dt_year,"+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.seq, b.firm_nm, a.sur_amt AS 과세표준, a.spe_tax_amt AS 산출개별소비세,a.edu_tax_amt AS 산출교육세,"+
				"        b.use_yn, d.car_no, d.car_num, decode(a.tax_st,'1',d.car_no,'2',decode(d.car_no,d.first_car_no,'&nbsp;',d.car_no)) car_no2, d.first_car_no, "+
				"        d.car_nm, cn.car_name, (a.tax_rate * 100) AS tax_rate,  a.spe_tax_amt, a.edu_tax_amt, (a.spe_tax_amt+a.edu_tax_amt) as amt, nvl(a.rtn_amt,0) rtn_amt,"+
				"        d.dpm, (a.sur_rate * 10) AS sur_rate, a.sur_amt, decode(a.tax_st,'1','장기대여','2','매각','3','용도변경','4','폐차') tax_st,"+
				"		a.car_fs_amt, b.dlv_dt, "+
				"        decode(a.pay_dt,'','0','1') pay_yn, decode(a.import_dt,'',d.INIT_REG_DT,a.import_dt) init_reg_dt,d.INIT_REG_DT AS 반입일자, to_char(ADD_MONTHS(d.INIT_REG_DT, 12),'YYYYMMDD') AS 용도변경일자2, to_char(ADD_MONTHS(d.INIT_REG_DT, 12),'YYYYMMDD') AS 반출일자2, "+
				"	CASE "+
		        "		WHEN SUBSTR(d.INIT_REG_DT,1,4) <= '2012' "+
	            "		THEN to_char(ADD_MONTHS(decode(g.cls_st,'4',g.cls_dt,'5',nvl(h.rent_suc_dt,g.cls_dt),f.rent_start_dt), 12),'YYYYMMDD')   "+
		        "		WHEN SUBSTR(d.INIT_REG_DT,1,4) >= '2014' "+
	            "		THEN CASE WHEN a.use_cng_dt is not null then a.use_cng_dt when a.use_cng_dt is null and d.init_reg_dt > decode(g.cls_st,'4',g.cls_dt,'5',nvl(h.rent_suc_dt,g.cls_dt),f.rent_start_dt) THEN d.init_reg_dt ELSE decode(g.cls_st,'4',g.cls_dt,'5',nvl(h.rent_suc_dt,g.cls_dt),f.rent_start_dt) END    "+
				"		ELSE to_char(ADD_MONTHS(d.INIT_REG_DT, 12),'YYYYMMDD') "+
				"		END AS 용도변경일자, "+
				"	CASE "+
				"		WHEN SUBSTR(d.INIT_REG_DT,1,4) <= '2012' "+
				"		THEN to_char(ADD_MONTHS(decode(g.cls_st,'4',g.cls_dt,'5',nvl(h.rent_suc_dt,g.cls_dt),f.rent_start_dt), 12),'YYYYMMDD')  "+
		        "		WHEN SUBSTR(d.INIT_REG_DT,1,4) >= '2014' "+
	            "		THEN CASE WHEN d.init_reg_dt > f.rent_start_dt THEN d.init_reg_dt ELSE f.rent_start_dt END    "+
				"		ELSE to_char(ADD_MONTHS(d.INIT_REG_DT, 12),'YYYYMMDD') "+
				"	END AS 반출일자,"+
				"		decode(a.use_cng_dt,'',DECODE(g.rent_l_cd,'', CASE WHEN d.init_reg_dt > DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) THEN d.init_reg_dt ELSE DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) END,g.cls_dt),a.use_cng_dt) AS rent_start_dt, "+
				"        decode(a.pay_dt, '', '', substr(a.pay_dt, 1, 4) || '-' || substr(a.pay_dt, 5, 2) || '-'||substr(a.pay_dt, 7, 2)) pay_dt,"+
				"        decode(a.est_dt, '', '', substr(a.est_dt, 1, 4) || '-' || substr(a.est_dt, 5, 2) || '-'||substr(a.est_dt, 7, 2)) est_dt,"+
				"        decode(a.rtn_dt, '', '', substr(a.rtn_dt, 1, 4) || '-' || substr(a.rtn_dt, 5, 2) || '-'||substr(a.rtn_dt, 7, 2)) rtn_dt,"+
				"        decode(a.tax_come_dt, '', '', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt, "+
				"        decode(g.cls_st,'4',g.cls_dt,'5',nvl(h.rent_suc_dt,g.cls_dt),f.rent_start_dt) rent_start_dt2 "+
				" from   car_tax a, cont_n_view b, car_reg d, car_etc e, fee f, (select * from cls_cont where cls_st in ('4','5')) g, cont_etc h , car_nm cn, TAECHA j  "+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and b.car_mng_id=d.car_mng_id and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				"	and e.car_id=cn.car_id(+)  and    e.car_seq=cn.car_seq(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd "+
				"        and f.rent_st='1' and nvl(a.cls_man_st,'0') in ('0','1')"+
				"        and b.rent_mng_id=g.rent_mng_id(+) and b.reg_dt=g.reg_dt(+) "+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_mng_id=j.rent_mng_id(+) and b.rent_l_cd=j.rent_l_cd(+) and nvl(j.no,'0')='0' "+				
				" ";

		if(gubun5.equals("1"))			query += " and a.pay_dt is null";
		else if(gubun5.equals("2"))		query += " and a.pay_dt is not null";

		//당월-납부
		if(gubun2.equals("1")){			query += " and a.est_dt like to_char(sysdate,'YYYYMM')||'%'";
		//기간-납부
		}else if(gubun2.equals("4")){	
			if(!st_dt.equals("") && !end_dt.equals("")){
				query += " and a.est_dt BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')";
			}else if(!st_dt.equals("") && end_dt.equals("")){
				st_dt = AddUtil.replace(st_dt, "-", "");
				query += " and a.est_dt like '"+st_dt+"%'";
			}
		}
	
		if(gubun4.equals("1"))			query += " and nvl(a.tax_st,'0') ='1'";
		else if(gubun4.equals("2"))		query += " and nvl(a.tax_st,'0') ='2'";
		else if(gubun4.equals("3"))		query += " and nvl(a.tax_st,'0') ='3'";
		else if(gubun4.equals("4"))		query += " and nvl(a.tax_st,'0') ='4'";
		
		if(dpm.equals("1"))			query += " and to_number(nvl(d.dpm,0)) <= 1500";
		else if(dpm.equals("2"))	query += " and to_number(d.dpm)> 1501 and d.dpm <= 2000 and a.car_mng_id not in ('010649','012704','013255') "; 
		else if(dpm.equals("3"))	query += " and to_number(d.dpm) > 2001 and a.car_mng_id not in ('017129','014880')  ";
		else if(dpm.equals("4"))	query += " and to_number(d.dpm) > 2001 and a.car_mng_id = '000000' ";

		/*검색조건*/			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(d.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("5"))	query += " and (a.spe_tax_amt+a.edu_tax_amt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and d.car_nm||cn.car_name like '%"+t_wd+"%'\n";

		query += " order by b.dlv_dt";

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
			System.out.println("[TaxDatabase:getTaxExcelList1]"+ e);
			System.out.println("[TaxDatabase:getTaxExcelList1]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}


   /**
	 *	업무용 승용차 관련비용 명세서 - etc:하이패스등 
	 */
	public Vector getCostCarList( String st_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "	select a.user_id, u.user_nm,  c.car_no, c.car_nm, decode( c.car_use, '1', '렌트', '리스') car_use,  a.insur_yn,   \n "+
			      	 " a.tot_dist, a.work_dist, a.asset_amt, a.fee_amt , a.a_fee_amt , \n  "+
			       "  a.oil_amt, a.insur_amt, a.service_amt, a.tax_amt, a.etc_amt, a.rent_month , a.rent_start_dt , a.rent_end_dt \n "+
			       "  from car_cost a, car_reg c , users u  \n  "+
			       "  where a.car_mng_id = c.car_mng_id  and  year='" + st_year + "' " +
			       "  and  a.user_id = u.user_id  \n  "+
			       " order by a.user_id, a.car_mng_id ";
                       
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
			System.out.println("[TaxDatabase:getCostCarList]"+ e);
			System.out.println("[TaxDatabase:getCostCarList]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	
	/*
	 *	  업무용 승용차 비용명세서 프로시져 호출
	*/
	public String call_sp_car_cost(String s_year)
	{
    	getConnection();
    	
    	String query = "{CALL P_CAR_COST (?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_year);
			cstmt.registerOutParameter( 2, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(2); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[TaxDatabase:call_sp_car_cost]\n"+e);
			e.printStackTrace();//call_sp_car_cost
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	/**
	 *	지출현황 - 특소세 납부 처리를 위한 리스트 --> 엑셀파일 20170713 수정
	 */
	public Vector getTaxExcelList_e2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null; 
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select d.car_no, d.car_num, a.car_fs_amt, a.bk_122, a.ch_327, "+
				"        decode(a.tax_come_dt, '', '', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt, "+
			    "        decode(a.import_dt,'',d.INIT_REG_DT,a.import_dt) init_reg_dt, "+
				"		 decode(a.use_cng_dt,'',DECODE(g.rent_l_cd,'', CASE WHEN d.init_reg_dt > DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) THEN d.init_reg_dt ELSE DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) END,g.cls_dt),a.use_cng_dt) AS rent_start_dt, "+
				"        case when i.jg_g_7 is null and d.dpm <= 2000 then '51042' "+
			    "             when i.jg_g_7 is null and d.dpm > 2001  then '51041' "+
				"             when i.jg_g_7='3' then '51047' "+
				"             when i.jg_g_7='4' then '51048' "+
				"             when i.jg_g_7 in ('1','2') and d.dpm <= 2000 then '51046' "+
				"             when i.jg_g_7 in ('1','2') and d.dpm >  2001 then '51045' "+
				"             else '51041' end tax_code "+
				" from   car_tax a, cont_n_view b, car_reg d, car_etc e, fee f, "+
				"        (select * from cls_cont where cls_st in ('4','5')) g, "+
				"        cont_etc h , car_nm cn, TAECHA j,  "+
                "        (SELECT a.* FROM esti_jg_var a, (SELECT sh_code, MAX(seq) seq FROM esti_jg_var GROUP BY sh_code) b WHERE a.sh_code=b.sh_code AND a.seq=b.seq) i "+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and b.car_mng_id=d.car_mng_id and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				"	     and e.car_id=cn.car_id and e.car_seq=cn.car_seq \n"+
				"        and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd "+
				"        and f.rent_st='1' and nvl(a.cls_man_st,'0') in ('0','1')"+
				"        and b.rent_mng_id=g.rent_mng_id(+) and b.reg_dt=g.reg_dt(+) "+
				"        and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd "+
				"        and b.rent_mng_id=j.rent_mng_id(+) and b.rent_l_cd=j.rent_l_cd(+) and nvl(j.no,'0')='0' "+				
				"        and cn.jg_code=i.sh_code "+
				" ";

		if(gubun5.equals("1"))			query += " and a.pay_dt is null";
		else if(gubun5.equals("2"))		query += " and a.pay_dt is not null";

		//당월-납부
		if(gubun2.equals("1")){			query += " and a.est_dt like to_char(sysdate,'YYYYMM')||'%'";
		//기간-납부
		}else if(gubun2.equals("4")){	
			if(!st_dt.equals("") && !end_dt.equals("")){
				query += " and a.est_dt BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '')";
			}else if(!st_dt.equals("") && end_dt.equals("")){
				st_dt = AddUtil.replace(st_dt, "-", "");
				query += " and a.est_dt like '"+st_dt+"%'";
			}
		}
	
		if(gubun4.equals("1"))			query += " and nvl(a.tax_st,'0') ='1'";
		else if(gubun4.equals("2"))		query += " and nvl(a.tax_st,'0') ='2'";
		else if(gubun4.equals("3"))		query += " and nvl(a.tax_st,'0') ='3'";
		else if(gubun4.equals("4"))		query += " and nvl(a.tax_st,'0') ='4'";
		
		/*검색조건*/			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and (nvl(d.car_no, '') like '%"+t_wd+"%' or nvl(d.first_car_no, '') like '%"+t_wd+"%')\n";
		else if(s_kd.equals("5"))	query += " and (a.spe_tax_amt+a.edu_tax_amt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and substr(b.rent_l_cd,1,2) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and d.car_nm||cn.car_name like '%"+t_wd+"%'\n";

		query += " order by case when d.dpm > 2001 then 1 when d.dpm > 1501 and d.dpm <= 2000 then 2 else 3 end, b.dlv_dt, a.car_mng_id";


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
			System.out.println("[TaxDatabase:getTaxExcelList_e2]"+ e);
			System.out.println("[TaxDatabase:getTaxExcelList_e2]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	//국세청요청자료 - 과세물품 총판매(반출)명세서
	public Vector getTaxExcelList_e3(String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null; 
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select '과세출고' st1, '과세 반출' st2,    \r\n" + 
				"				        decode(a.tax_come_dt, '', '', substr(a.tax_come_dt, 1, 4) || '-' || substr(a.tax_come_dt, 5, 2) || '-'||substr(a.tax_come_dt, 7, 2)) tax_come_dt,\r\n" + 
				"                d.car_no, \r\n" + 
				"                '대' st3,\r\n" + 
				"                d.car_num, \r\n" + 
				"                '1' st4,\r\n" + 
				"                a.car_fs_amt, a.sur_amt, a.tax_rate, a.spe_tax_amt, a.bk_122, a.ch_327, a.edu_tax_amt, 	\r\n" + 
				"                decode(a.import_dt,'',d.INIT_REG_DT,a.import_dt) init_reg_dt, \r\n" + 
				"						    decode(a.use_cng_dt,'',DECODE(g.rent_l_cd,'', CASE WHEN d.init_reg_dt > DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) THEN d.init_reg_dt ELSE DECODE(b.car_mng_id,j.car_mng_id,j.car_rent_st,f.rent_start_dt) END,g.cls_dt),a.use_cng_dt) AS rent_start_dt, 						        				        \r\n" + 
				"                a.pay_dt \r\n" + 
				"				 from   car_tax a, cont_n_view b, car_reg d, car_etc e, fee f, \r\n" + 
				"				        (select * from cls_cont where cls_st in ('4','5')) g, \r\n" + 
				"				        cont_etc h , car_nm cn, TAECHA j,  \r\n" + 
				"                        (SELECT a.* FROM esti_jg_var a, (SELECT sh_code, MAX(seq) seq FROM esti_jg_var GROUP BY sh_code) b WHERE a.sh_code=b.sh_code AND a.seq=b.seq) i \r\n" + 
				"				 where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\r\n" + 
				"				        and b.car_mng_id=d.car_mng_id and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\r\n" + 
				"					     and e.car_id=cn.car_id and e.car_seq=cn.car_seq\r\n" + 
				"				        and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \r\n" + 
				"				        and f.rent_st='1' and nvl(a.cls_man_st,'0') in ('0','1')\r\n" + 
				"				        and b.rent_mng_id=g.rent_mng_id(+) and b.reg_dt=g.reg_dt(+) \r\n" + 
				"				        and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd \r\n" + 
				"				        and b.rent_mng_id=j.rent_mng_id(+) and b.rent_l_cd=j.rent_l_cd(+) and nvl(j.no,'0')='0' \r\n" + 
				"				        and cn.jg_code=i.sh_code\r\n" + 
				"                and a.pay_dt BETWEEN replace('"+st_dt+"', '-', '') AND replace('"+end_dt+"', '-', '') "+
				" order by 3";

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
			System.out.println("[TaxDatabase:getTaxExcelList_e3]"+ e);
			System.out.println("[TaxDatabase:getTaxExcelList_e3]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	
	


}
