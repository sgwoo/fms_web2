/*
 * 과태료/범칙금
 */
package acar.forfeit_mng;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.common.*;
//import acar.account.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class AddForfeitHanDatabase {

    private static AddForfeitHanDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized AddForfeitHanDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AddForfeitHanDatabase();
        return instance;
    }
    
    private AddForfeitHanDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }


	

	//한국도로공사 과태료 납부 스캔등록 리스트 
	public Vector getFineExpList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		//String standard_dt = "decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt)";
		
		String standard_dt = "decode(nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')), '',a.paid_end_dt, nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')))";

		String query = "";

		query = " select /*+  no_merge(b) */ \n"+
				"        a.FILE_NAME, a.FILE_NAME2, a.file_type2, a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm, '' scan_file, \n"+
				"        c.car_no, c.first_car_no, c.car_nm, cn.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				"        decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st, \n"+
				"        a.pol_sta, a.paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt, e.gov_nm, \n"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm) cust_nm, a.fault_nm \n"+
				" from   fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j , car_reg c,  car_etc gg, car_nm cn \n"+
				" where\n"+
				"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and b.car_mng_id = c.car_mng_id  and b.rent_mng_id = gg.rent_mng_id(+)  and b.rent_l_cd = gg.rent_l_cd(+)  \n"+
                       		"	and gg.car_id=cn.car_id(+)  and    gg.car_seq=cn.car_seq(+)   \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+
				"        and a.paid_amt > 0 and a.pol_sta=e.gov_id(+) AND a.pol_sta||e.gov_nm LIKE '%한국도로공사%' AND a.NOTE LIKE '%엑셀파일로%' ";

		/*상세조회&&세부조회*/


		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and substr(a.reg_dt,1,6) = to_char(SYSDATE, 'YYYYMM')";// and a.paid_st <> '2'
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr(a.reg_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is not null";// and a.paid_st <> '2'
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and substr(a.reg_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is null";// and a.paid_st <> '2'

		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and a.reg_dt = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and a.reg_dt = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and a.reg_dt = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";// and a.paid_st <> '2'
		
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and a.reg_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.reg_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and a.reg_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is null";

		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.proxy_dt is not null";
		//검색-미지출
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.proxy_dt is null";

		//접수일자
		}else if(gubun2.equals("7")){	query += " and a.rec_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		
		}

		/*검색조건*/
		if(!t_wd.equals("")){	
	
		if(s_kd.equals("1"))	query += " and nvl(c.car_no, '')||nvl(c.first_car_no, '') like '%"+t_wd+"%'\n";
		
	}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.vio_dt "+sort+", a.paid_end_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.vio_dt, a.paid_end_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.proxy_dt "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.proxy_dt, b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, c.car_no "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("6"))	query += " order by e.gov_nm "+sort+", a.rec_dt, c.car_no, b.firm_nm, a.paid_end_dt";



//System.out.println(query);
	
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
			System.out.println("[AddForfeitHanDatabase:getFineExpList]\n"+e);
			System.out.println("[AddForfeitHanDatabase:getFineExpList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}
	
	

	//과태료 리스트 조회(지출현황)
	public Vector getSFineList(String reg_id, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
			//String standard_dt = "decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt)";
		String standard_dt = "a.reg_dt "; //"decode(nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')), '',a.paid_end_dt, nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')))";
		String s_query = "";
		if(s_kd.equals("16")){
			s_query = " , (select user_id, user_nm from users where user_nm like '"+t_wd+"%') k";
		}		
		String query = "";
		query = " select /*+  no_merge(b) */ \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm, '' scan_file,\n"+
				"        c.car_no, c.first_car_no, c.car_nm, cn.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				"        decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st, \n"+
				"        a.pol_sta, a.paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt, e.gov_nm, \n"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm) cust_nm, a.fault_nm \n"+
				" from   fine a, cont_n_view b,  car_reg c,  car_etc gg, car_nm cn , fine_gov e, rent_cont g, client h, users i, rent_cust j "+s_query+"\n"+
				" where\n"+
				"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = gg.rent_mng_id(+)  and a.rent_l_cd = gg.rent_l_cd(+)  \n"+
                       		"	and gg.car_id=cn.car_id(+)  and    gg.car_seq=cn.car_seq(+) \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)  "+
				"        and a.paid_amt > 0 and a.pol_sta=e.gov_id(+) and a.reg_id = '"+reg_id+"' ";

		/*상세조회&&세부조회*/

//	if(!gubun2.equals("5")){
//System.out.println("g2: "+gubun2);
//System.out.println("g3: "+gubun3);
		if(gubun1.equals("1")){		query += " and e.gov_id <> '278' ";
		}

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM')";// and a.paid_st <> '2'
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is not null";// and a.paid_st <> '2'
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is null";// and a.paid_st <> '2'
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";// and a.paid_st <> '2'
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and (a.proxy_dt is null or a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.proxy_dt is not null";
		//검색-미지출
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.proxy_dt is null";
		//접수일자
		}else if(gubun2.equals("7")){	query += " and a.rec_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		}
//	}

		if(gubun4.equals("2"))			query += " and a.fault_st='1'";
		else if(gubun4.equals("3"))		query += " and a.fault_st='2'";
		else if(gubun4.equals("4"))		query += " and a.paid_st='2'";
		else if(gubun4.equals("5"))		query += " and a.paid_st='3'";
		else if(gubun4.equals("6"))		query += " and a.paid_st='1'";
		else if(gubun4.equals("7"))		query += " and a.paid_st='4'";
		else if(gubun4.equals("8"))		query += " and a.paid_st<>'1'";
		else if(gubun4.equals("9"))		query += " and a.fault_st='3'";
		else							query += "                     ";
		

		/*검색조건*/
	if(!t_wd.equals("")){	
		if(s_kd.equals("2"))		query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(c.car_no, '')||nvl(b.first_car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and nvl(a.mng_id, nvl(b.mng_id,b.bus_id2))= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.pol_sta||e.gov_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("14"))	query += " and nvl(a.rec_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("15"))	query += " and nvl(a.vio_cont, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("16"))	query += "  and a.FAULT_NM = k.user_id ";
		else						query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
	}
		
		
	//	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD')";


		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.vio_dt "+sort+", a.paid_end_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.vio_dt, a.paid_end_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.proxy_dt "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.proxy_dt, b.firm_nm, a.paid_end_dt";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, c.car_no "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("6"))	query += " order by e.gov_nm "+sort+", a.rec_dt, c.car_no, b.firm_nm, a.paid_end_dt";



//System.out.println("getSFineList: "+query);
	
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
			System.out.println("[AddForfeitHanDatabase:getSFineList]\n"+e);
			System.out.println("[AddForfeitHanDatabase:getSFineList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}


public Vector Moncount(String reg_id, String gubun1, String year, String mon) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt_query = "";

		if(!year.equals("") && !mon.equals("")){
			dt_query += " AND  substr(reg_dt, 1,4) = '"+year+"' AND  to_number(substr(reg_dt, 5,2)) = '"+mon+"' ";
		}else if(!year.equals("") && mon.equals("")){
			dt_query += " AND  substr(reg_dt, 1,4) = '"+year+"'  ";
		}else if(year.equals("") && !mon.equals("")){
			dt_query += " AND  to_number(substr(reg_dt, 5,2)) = '"+mon+"'  ";
		}else if(year.equals("") && mon.equals("")){
			dt_query += " ";
		}

		if(!gubun1.equals(""))		sub_query += " where reg_id ='"+gubun1+"' "; 
		else						sub_query += " where reg_id is not null ";

//		if(gubun1.equals("1"))		sub_query += " where reg_id in ('000155','000096') ";  //'000058',
//		else if(gubun1.equals("2"))	sub_query += " where reg_id in ( '000107')  "; //AND  substr(reg_dt, 1,4) = '"+year+"' AND  to_number(substr(reg_dt, 5,2)) = '"+mon+"'
		

		query = " select a.reg_dt,   sum(cnt1) cnt1, sum(cnt2) cnt2, sum(cnt3) cnt3, sum(cnt4) cnt4 \n"+
		              "  FROM    \n"+
			    "	 ( SELECT reg_dt,  COUNT(*) cnt1,  0 cnt2, 0 cnt3, 0 cnt4 FROM FINE   \n"+sub_query+dt_query+
			    "	 and  NVL(note,'-') not in ('한꺼번에 등록') AND NVL(note,'-') <> '경찰서 과태료 엑셀파일로 한꺼번에 등록'  GROUP BY reg_dt   \n"+
			    "	  union all  \n"+
			    "	  SELECT reg_dt,    0 cnt1, COUNT(*) cnt2, 0 cnt3, 0 cnt4  FROM FINE    \n"+sub_query+dt_query+
//			   "	  and pol_sta  in('278', '353', '455', '504', '389', '459', '486', '358', '347', '352','375','640','523','552','379') "+
				" AND NVL(note,'-') in ('한꺼번에 등록')  GROUP BY reg_dt    \n"+
			    "	  union all  \n"+
			    "	  SELECT reg_dt,    0 cnt1, 0 cnt2, 0 cnt3, cnt cnt4  FROM FINE_EX    \n"+sub_query+dt_query+
			    "	  union all  \n"+
			    "	  SELECT reg_dt,    0 cnt1, 0 cnt2, COUNT(*) cnt3, 0 cnt4  FROM FINE    \n"+sub_query+dt_query+
			   "	  AND pol_sta <> '278' AND note ='경찰서 과태료 엑셀파일로 한꺼번에 등록'  GROUP BY reg_dt  	  ) a  \n"+
			   "	group by a.reg_dt   \n"+
			  "	ORDER BY a.reg_dt  \n";


	
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
			System.out.println("[AddForfeitHanDatabase:Moncount]\n"+e);
			System.out.println("[AddForfeitHanDatabase:Moncount]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}


public Vector Yearcount(String reg_id, String gubun1, String year, String mon) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String dt_query = "";

		if(gubun1.equals("1"))		sub_query += " where reg_id in ('000155','000096') ";  //'000058',
		else if(gubun1.equals("2"))	sub_query += " where reg_id in ( '000107')  "; //AND  substr(reg_dt, 1,4) = '"+year+"' AND  to_number(substr(reg_dt, 5,2)) = '"+mon+"'
		

query = " SELECT NVL(SUBSTR(reg_dt, 1, 6), '총합계') reg_ym \n"+
		" , COUNT(CASE WHEN NVL(note, '-') NOT IN ( '한꺼번에 등록', '경찰서 과태료 엑셀파일로 한꺼번에 등록')THEN 1 END) cnt1 \n"+
		" , COUNT(CASE WHEN note = '한꺼번에 등록'AND pol_sta IN ('278','353','455','504','389','459','486','358','347', '352','375','640','523')THEN 1 END) cnt2 \n"+
		" , COUNT(CASE WHEN note = '경찰서 과태료 엑셀파일로 한꺼번에 등록'AND pol_sta <> '278'THEN 1 END) cnt3 \n"+
		" FROM fine \n"+sub_query+
		" AND reg_dt LIKE '"+year+"%' \n"+
		" GROUP BY ROLLUP(SUBSTR(reg_dt, 1, 6)) \n";

//System.out.println("Yearcount: "+query);
	
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
			System.out.println("[AddForfeitHanDatabase:Yearcount]\n"+e);
			System.out.println("[AddForfeitHanDatabase:Yearcount]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}

//과태료 리스트 일자별 조회
	public Vector getSFineListday(String reg_dt, String gov_id, String gubun1) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, nvl(b.firm_nm, b.client_nm) firm_nm, b.client_nm,  '' scan_file,\n"+
				"        c.car_no, c.first_car_no, c.car_nm, cn.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, \n"+
				"        decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st, \n"+
				"        a.pol_sta, a.paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st, \n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt, \n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt, \n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt, \n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt, \n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt, e.gov_nm, \n"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st, \n"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm) cust_nm, a.fault_nm, \n"+
				"        nvl(d.file_1_cnt,0) file_1_cnt, nvl(d.file_2_cnt,0) file_2_cnt \n"+
				" from   fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j, car_reg c,  car_etc gg, car_nm cn, \n"+
				"        (SELECT SUBSTR(content_seq,1,LENGTH(content_seq)-1) content_seq, \n"+ 
				"                COUNT(DECODE(SUBSTR(content_seq,LENGTH(content_seq)),'1',content_seq)) file_1_cnt, \n"+  
				"                COUNT(DECODE(SUBSTR(content_seq,LENGTH(content_seq)),'2',content_seq)) file_2_cnt  \n"+
				"         FROM   ACAR_ATTACH_FILE \n"+ 
				"         WHERE  content_code='FINE' AND isdeleted='N' \n"+ 
				"         GROUP BY SUBSTR(content_seq,1,LENGTH(content_seq)-1) \n"+
				"        ) d \n"+
				" where \n"+
				"        a.paid_amt > 0 and a.reg_dt = '"+reg_dt+"' ";

		if(!gubun1.equals(""))		query += " and  a.reg_id ='"+gubun1+"' ";

		if(gov_id.equals("278"))	query += " AND NVL( a.note,'-') IN ('한꺼번에 등록') "; 
		if(gov_id.equals("278N"))	query += " and a.pol_sta in ('278', '353', '455', '504', '389', '459', '486', '358', '347', '352','375','640','523') and a.paid_st ='1' ";
		if(gov_id.equals("police")) query += " and a.pol_sta <> '278' AND NVL(a.note,'-') ='경찰서 과태료 엑셀파일로 한꺼번에 등록' ";
		if(gov_id.equals(""))		query += " AND NVL(a.note,'-') not in ('경찰서 과태료 엑셀파일로 한꺼번에 등록', '한꺼번에 등록') ";

		query +="        and a.pol_sta=e.gov_id(+) and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	     and a.car_mng_id = c.car_mng_id and a.rent_mng_id = gg.rent_mng_id(+) and a.rent_l_cd = gg.rent_l_cd(+)  \n"+
               	"	     and gg.car_id=cn.car_id(+) and gg.car_seq=cn.car_seq(+)  \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)  "+
				"        and a.rent_mng_id||a.rent_l_cd||a.car_mng_id||a.seq_no=d.content_seq(+) "+
				" order by a.pol_sta, a.vio_dt ";
	
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
			System.out.println("[AddForfeitHanDatabase:getSFineListday]\n"+e);
			System.out.println("[AddForfeitHanDatabase:getSFineListday]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}



	//우체국방문 체크
	public Hashtable getFineCardDoc(String buydt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " SELECT NVL2(BUY_DT, 10000,0) amt FROM CARD_DOC WHERE cardno in('9410-8521-6708-3500','9410-8522-1179-1500','9410-8522-9226-7800') and buy_dt = '"+buydt+"' \n";

	//	System.out.println(query);

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddForfeitHanDatabase:getFineCardDoc]\n"+e);
			System.out.println("[AddForfeitHanDatabase:getFineCardDoc]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}




//도로공사 납부자 변경 건수 입력.
 public  int insertCNT_SU(String reg_dt, String cnt_su, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
		try{
        
	      query = " insert into fine_ex ( reg_dt, cnt, reg_id) values (replace('"+ reg_dt + "','-',''), '" + cnt_su + "',  '" + user_id + "')  ";

            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddForfeitHanDatabase:insertCNT_SU]"+se);
				System.out.println("[AddForfeitHanDatabase:insertCNT_SU]"+query);
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



//과태료 리스트 일자별 조회
	public Vector getSFineExcelListday(String s_kd, String st_dt, String end_dt, String gov_id ) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		


		query = " SELECT a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, a.rent_s_cd, e.firm_nm, a.paid_no, a.reg_id, a.reg_dt, "+
				"  b.car_no, d.scan_file, a.vio_dt, d.car_st, a.rent_s_cd, d.client_id,  a.VIO_PLA, a.PAID_AMT,  "+
				" nvl2(g.cust_id,'',NVL(d.P_ZIP,e.o_zip)) AS HO_ZIP, nvl2(g.cust_id,'',NVL(d.P_ADDR,e.o_addr)) AS HO_ADDR, NVL(e.O_TEL, e.M_TEL) HO_TEL "+
				"   FROM fine a, car_reg b, cont d ,  CLIENT e, RENT_CONT g  "+
				"  WHERE a.car_mng_id=b.car_mng_id AND a.RENT_S_CD = g.rent_s_cd(+) AND a.rent_mng_id=d.rent_mng_id  AND a.rent_l_cd=d.rent_l_cd AND d.CLIENT_ID = e.CLIENT_ID ";
		

		if(!gov_id.equals("doros")){  
			query += " and a.pol_sta = '"+gov_id+"' ";
		}else{
			query += " and a.pol_sta in ('278', '353', '455', '504', '389', '459', '486', '358', '347', '352','375','640','523') ";
		}

		if(s_kd.equals("1")){
			query += " and substr(a.reg_dt, 1, 6) = substr(to_char(sysdate,'YYYYMMDD'),1,6)";		
		}else if(s_kd.equals("3")){
			query += " and substr(a.reg_dt,1,6) = to_char(ADD_MONTHS(SYSDATE,-1), 'yyyymm')";		
		}else if(s_kd.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.reg_dt like replace('%"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.reg_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}


				query += " order by a.pol_sta, a.vio_dt ";

//System.out.println("getSFineExcelListday: "+query);
	
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
			System.out.println("[AddForfeitHanDatabase:getSFineExcelListday]\n"+e);
			System.out.println("[AddForfeitHanDatabase:getSFineExcelListday]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}

	public Vector SFineCostStat(String gubun1, String st_year, String st_mon) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String where_query1 = "";
		String where_query2 = "";

		if(!st_mon.equals("")){
			where_query1 += " like '"+st_year+""+st_mon+"%' ";
		}else{
			where_query1 += " like '"+st_year+"%' ";
		}
		
		where_query2 = where_query1;

		if(!gubun1.equals("")) {
			where_query1 += " and reg_id ='"+gubun1+"' "; 		
			where_query2 += " and decode(reg_id,'000107','000107','000155') ='"+gubun1+"' ";
		}
		
		
		base_query = " SELECT reg_dt, to_char(to_date(reg_dt,'YYYYMMDD'),'MM-DD (DY)','NLS_DATE_LANGUAGE=KOREAN') as t_reg_dt, \r\n" + 
				"               COUNT(DECODE(st,'수기등록',reg_dt)) cnt1, \r\n" + 
				"               COUNT(DECODE(st,'도로공사',reg_dt)) cnt2, \r\n" + 
				"               COUNT(DECODE(st,'경찰서',reg_dt)) cnt3, \r\n" + 
				"               COUNT(DECODE(st,'우편물',reg_dt)) cnt4,\r\n" + 
				"               COUNT(DECODE(st,'OCR',reg_dt)) cnt5,\r\n" + 
				"               COUNT(DECODE(st,'수기등록',reg_dt))*CASE WHEN reg_dt>'20191130' THEN 400 WHEN reg_dt >= '20120529' AND reg_dt<'20191201' THEN 350 ELSE 250 END amt1,\r\n" + 
				"               COUNT(DECODE(st,'도로공사',reg_dt))*150 amt2, \r\n" + 
				"               COUNT(DECODE(st,'경찰서',reg_dt))*100 amt3,\r\n" + 
				"               DECODE(COUNT(DECODE(st,'우편물',reg_dt)),0,0,10000) amt4\r\n" + 
				"        FROM \r\n" + 
				"               (\r\n" + 
				"                 SELECT '수기등록' st, reg_dt, reg_id FROM fine WHERE reg_dt "+where_query1+" AND NVL(note,'-') not in ('한꺼번에 등록') AND NVL(note,'-') <> '경찰서 과태료 엑셀파일로 한꺼번에 등록' \r\n" +  
				"                 UNION all           \r\n" + 
				"                 SELECT '도로공사' st, reg_dt, reg_id FROM fine WHERE reg_dt "+where_query1+" AND NVL(note,'-') in ('한꺼번에 등록')  \r\n" + 
				"                 UNION all\r\n" + 
				"                 SELECT '경찰서'  st, reg_dt, reg_id FROM fine WHERE reg_dt "+where_query1+" AND pol_sta <> '278' AND note ='경찰서 과태료 엑셀파일로 한꺼번에 등록'  \r\n" + 
				"                 UNION all  \r\n" + 
				"                 SELECT '우편물'  st, buy_dt AS reg_dt, reg_id FROM CARD_DOC WHERE buy_dt "+where_query2+" AND cardno in('9410-8521-6708-3500','9410-8522-1179-1500','9410-8522-9226-7800')\r\n" +
				"               )\r\n" + 
				"        GROUP BY reg_dt\r\n" + 
				"         \n";
		
		query = base_query + "order by reg_dt";
		
		if(st_mon.equals("")){
			query = "SELECT SUBSTR(reg_dt,1,6) reg_dt, to_char(to_date(SUBSTR(reg_dt,1,6),'YYYYMM'),'MM')||'월' as t_reg_dt, \r\n" + 
					"       SUM(cnt1) cnt1,\r\n" + 
					"       SUM(cnt2) cnt2,\r\n" + 
					"       SUM(cnt3) cnt3,\r\n" + 
					"       SUM(cnt4) cnt4,\r\n" + 
					"       SUM(amt1) amt1,\r\n" + 
					"       SUM(amt2) amt2,\r\n" + 
					"       SUM(amt3) amt3,\r\n" + 
					"       SUM(amt4) amt4\r\n" + 
					"FROM\r\n" + 
					"(    "+base_query+"   )\r\n"+
					"GROUP BY SUBSTR(reg_dt,1,6) \r\n" + 
					"ORDER BY SUBSTR(reg_dt,1,6) ";
		}

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
			System.out.println("[AddForfeitHanDatabase:SFineCostStat]\n"+e);
			System.out.println("[AddForfeitHanDatabase:SFineCostStat]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}
	
	public Vector SFineCostList(String gubun1, String st_year, String st_mon, String reg_dt, String st) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where_query1 = "";

		if(!st_mon.equals("")){
			where_query1 += " = '"+reg_dt+"' ";
		}else{
			where_query1 += " like '"+reg_dt+"%' ";
		}
		
		if(!gubun1.equals("")) {
			where_query1 += " and reg_id ='"+gubun1+"' "; 		
		}
		
		query = "  SELECT b.car_no, b.car_nm, e.gov_nm, c.user_nm, nvl(d.file_1_cnt,0) file_1_cnt, nvl(d.file_2_cnt,0) file_2_cnt, a.*\r\n" + 
				"        FROM \r\n" + 
				"               (\r\n" + 
				"                 SELECT '1' st, rent_mng_id||rent_l_cd||car_mng_id||seq_no as content_seq, car_mng_id, vio_dt, pol_sta, vio_cont, note, reg_dt, reg_id FROM fine WHERE reg_dt "+where_query1+"  AND NVL(note,'-') not in ('한꺼번에 등록') AND NVL(note,'-') <> '경찰서 과태료 엑셀파일로 한꺼번에 등록'\r\n" + 
				"                 UNION all\r\n" + 
				"                 SELECT '2' st, rent_mng_id||rent_l_cd||car_mng_id||seq_no as content_seq, car_mng_id, vio_dt, pol_sta, vio_cont, note, reg_dt, reg_id FROM fine WHERE reg_dt "+where_query1+"  AND NVL(note,'-') in ('한꺼번에 등록')  \r\n" + 
				"                 UNION all\r\n" + 
				"                 SELECT '3' st, rent_mng_id||rent_l_cd||car_mng_id||seq_no as content_seq, car_mng_id, vio_dt, pol_sta, vio_cont, note, reg_dt, reg_id FROM fine WHERE reg_dt "+where_query1+"  AND pol_sta <> '278' AND note ='경찰서 과태료 엑셀파일로 한꺼번에 등록'  \r\n" + 
				"               ) a,\r\n" + 
				"               car_reg b, fine_gov e, users c,\r\n" +
				"        (SELECT SUBSTR(content_seq,1,LENGTH(content_seq)-1) content_seq, \n"+ 
				"                COUNT(DECODE(SUBSTR(content_seq,LENGTH(content_seq)),'1',content_seq)) file_1_cnt, \n"+  
				"                COUNT(DECODE(SUBSTR(content_seq,LENGTH(content_seq)),'2',content_seq)) file_2_cnt  \n"+
				"         FROM   ACAR_ATTACH_FILE \n"+ 
				"         WHERE  content_code='FINE' AND isdeleted='N' \n"+ 
				"         GROUP BY SUBSTR(content_seq,1,LENGTH(content_seq)-1) \n"+
				"        ) d \n"+				
				"WHERE a.st='"+st+"' and a.car_mng_id=b.car_mng_id and a.pol_sta=e.gov_id(+) AND a.reg_id=c.user_id and a.content_seq=d.content_seq(+) \r\n" + 
				"order by a.reg_dt, a.st, a.vio_dt DESC  \n";
		

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
			System.out.println("[AddForfeitHanDatabase:SFineCostList]\n"+e);
			System.out.println("[AddForfeitHanDatabase:SFineCostList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}	

}
