/**
 * 주요차종 관리
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2006. 4. 14
 * @ last modify date : 
 */
package acar.estimate_mng;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;

public class EstiJuyoDatabase {

    private static EstiJuyoDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized EstiJuyoDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new EstiJuyoDatabase();
        return instance;
    }
    
    private EstiJuyoDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

    /**
	 *	주요차종 리스트
	 */
	public Vector getJuyoCars(String code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT /*+ rule */ a.est_id, a.est_tel seq, a.car_comp_id, a.car_cd, a.car_id, a.car_seq, f.car_nm, e.car_name, e.auto_yn, e.diesel_yn, a.o_1, "+
				"	   a.est_id rb36_id, a.fee_s_amt rb36_amt, "+
				"	   b.est_id rs36_id, b.fee_s_amt rs36_amt, "+
				"	   c.est_id lb36_id, c.fee_s_amt lb36_amt, "+
				"	   d.est_id ls36_id, d.fee_s_amt ls36_amt /n  "+
				" FROM "+
				"	 (select * from estimate where nvl(est_ssn,'Y')='Y' and est_type='J' and est_nm='rb36' and (car_id,car_seq,reg_dt) in (select car_id, car_seq, max(reg_dt) reg_dt from estimate where est_type='J' and est_nm='rb36' group by car_id, car_seq )) a, /n"+
				"	 (select * from estimate where nvl(est_ssn,'Y')='Y' and est_type='J' and est_nm='rs36' and (car_id,car_seq,reg_dt) in (select car_id, car_seq, max(reg_dt) reg_dt from estimate where est_type='J' and est_nm='rs36' group by car_id, car_seq )) b, /n"+
				"	 (select * from estimate where nvl(est_ssn,'Y')='Y' and est_type='J' and est_nm='lb36' and (car_id,car_seq,reg_dt) in (select car_id, car_seq, max(reg_dt) reg_dt from estimate where est_type='J' and est_nm='lb36' group by car_id, car_seq )) c, /n"+
				"	 (select * from estimate where nvl(est_ssn,'Y')='Y' and est_type='J' and est_nm='ls36' and (car_id,car_seq,reg_dt) in (select car_id, car_seq, max(reg_dt) reg_dt from estimate where est_type='J' and est_nm='ls36' group by car_id, car_seq )) d, /n"+
				"	 car_nm e, car_mng f "+
				" WHERE a.car_id = b.car_id and a.car_seq = b.car_seq "+
				" AND b.car_id = c.car_id and b.car_seq = c.car_seq "+
				" AND c.car_id = d.car_id and c.car_seq = d.car_seq "+
				" AND d.car_id = e.car_id and d.car_seq = e.car_seq "+
				" AND e.car_comp_id= f.car_comp_id and e.car_cd = f.code ";
		

		if(code.equals("")){

		}else if(code.equals("0001")){
			query += " AND a.car_comp_id = '0001' ";
		}else if(code.equals("0002")){
			query += " AND a.car_comp_id = '0002' ";
		}else if(code.equals("0003")){
			query += " AND a.car_comp_id = '0003' ";
		}else if(code.equals("0004")){
			query += " AND a.car_comp_id = '0004' ";
		}else if(code.equals("0005")){
			query += " AND a.car_comp_id = '0005' ";
		}else if(code.equals("etc")){
			query += " AND a.car_comp_id > '0005' ";
		}else if(code.equals("hd_except")){
			query += " AND a.car_comp_id != '0001' ";
		}


		query += " ORDER BY to_number(a.est_tel) ";

		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCars]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	주요차종 리스트-FMS
	 */
	public Vector getJuyoCars(String code, String base_dt, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery ="";

		if(base_dt.equals("")){
			subQuery = " and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) "; 
		}else{
			subQuery = " and substr(reg_dt,0,8)='"+base_dt+"' ";
		}

		query = "SELECT /*+ rule */ a.est_id, a.est_tel seq, a.car_comp_id, a.car_cd, a.car_id, a.car_seq, a.opt, f.car_nm, e.car_name, e.auto_yn, e.diesel_yn, a.o_1, a.spr_yn, "+
				"	   a.est_id rb36_id, a.fee_s_amt rb36_amt, "+
				"	   b.est_id rs36_id, b.fee_s_amt rs36_amt, "+
				"	   c.est_id lb36_id, c.fee_s_amt lb36_amt, "+
				"	   d.est_id ls36_id, d.fee_s_amt ls36_amt,  "+
				"	   h.est_id lb36_id2, h.fee_s_amt lb36_amt2, "+
				"	   i.est_id ls36_id2, i.fee_s_amt ls36_amt2,  "+
				"		g.car_b_p as car_new_p, (g.car_b_p-a.car_amt) cng_amt, decode(g.car_b_p,a.car_amt,'-','변동') cng_st /n"+
				" FROM "+
				"    (select * from estimate where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36' "+subQuery+") a,  /n"+
				"	 (select * from estimate where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rs36' "+subQuery+") b, /n "+
				"	 (select * from estimate where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb36' "+subQuery+") c,  /n"+
				"	 (select * from estimate where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls36' "+subQuery+") d,  /n"+
				"	 (select * from estimate where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb362' "+subQuery+") h,  /n"+
				"	 (select * from estimate where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls362' "+subQuery+") i, /n"+
				"	 car_nm e, car_mng f, "+
				"	 (select car_comp_id, car_cd, car_id, car_seq, car_name, car_b_p, car_b_dt"+
				"		from car_nm"+
				"		where (car_comp_id, car_cd, car_id, car_b_dt) in"+
				"		(select car_comp_id, car_cd, car_id, max(car_b_dt) car_b_dt from car_nm group by car_comp_id, car_cd, car_id)) g /n"+
				" WHERE a.car_id = b.car_id    and a.car_seq = b.car_seq "+
				"   AND a.car_id = c.car_id    and a.car_seq = c.car_seq "+
				"   AND a.car_id = d.car_id    and a.car_seq = d.car_seq "+
				"   AND a.car_id = h.car_id(+) and a.car_seq = h.car_seq(+) "+
				"   AND a.car_id = i.car_id(+) and a.car_seq = i.car_seq(+) "+
				"   AND a.car_id = e.car_id    and a.car_seq = e.car_seq "+
				"   AND e.car_comp_id= f.car_comp_id and e.car_cd = f.code "+
				"   AND e.car_id = g.car_id(+) and e.car_seq=g.car_seq(+)";
		

		if(code.equals("")){

		}else if(code.equals("0001")){
			query += " AND a.car_comp_id = '0001' ";
		}else if(code.equals("0002")){
			query += " AND a.car_comp_id = '0002' ";
		}else if(code.equals("0003")){
			query += " AND a.car_comp_id = '0003' ";
		}else if(code.equals("0004")){
			query += " AND a.car_comp_id = '0004' ";
		}else if(code.equals("0005")){
			query += " AND a.car_comp_id = '0005' ";
		}else if(code.equals("etc")){
			query += " AND a.car_comp_id > '0005' ";
		}else if(code.equals("hd_except")){
			query += " AND a.car_comp_id != '0001' ";
		}

		if(!t_wd.equals("")){
			query += " AND f.car_nm||e.car_name like '%"+t_wd+"%' ";
		}


		query += " ORDER BY to_number(a.est_tel) ";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCars]"+e);
			System.out.println("[EstiJuyoDatabase:getJuyoCars]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	주요차종 리스트-FMS
	 */
	public Vector getJuyoCars_20090703(String code, String base_dt, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery ="";

		if(base_dt.equals("")){
			subQuery = " and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) "; 
		}else{
			subQuery = " and substr(reg_dt,0,8)='"+base_dt+"' ";
		}

		query = "SELECT /*+ rule */ nvl(a2.reg_dt,'') reg_dt, a.est_id, a.est_tel seq, a.car_comp_id, a.car_cd, a.car_id, a.car_seq, a.opt, f.car_nm, e.car_name, e.auto_yn, e.diesel_yn, (a.o_1+a.dc_amt) o_1, a.spr_yn, /n"+ //리스트에서는 DC 반영전 차량가격을 보여준다
				"	   a.est_id rb36_id, a.fee_s_amt rb36_amt, "+
				"	   b.est_id rs36_id, b.fee_s_amt rs36_amt, "+
				"	   c.est_id lb36_id, c.fee_s_amt lb36_amt, "+
				"	   d.est_id ls36_id, d.fee_s_amt ls36_amt,  "+
				"	   h.est_id lb36_id2, h.fee_s_amt lb36_amt2, "+
				"	   i.est_id ls36_id2, i.fee_s_amt ls36_amt2,  "+
				"		g.car_b_p as car_new_p, (g.car_b_p-a.car_amt) cng_amt, decode(g.car_b_p,a.car_amt,'-','변동') cng_st /n"+
				" FROM "+
				"    (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36' "+subQuery+") a, /n"+
				"	 (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rs36' "+subQuery+") b, /n"+
				"	 (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb36' "+subQuery+") c, /n"+
				"	 (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls36' "+subQuery+") d, /n"+
				"	 (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb362' "+subQuery+") h, /n"+
				"	 (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls362' "+subQuery+") i, /n "+
				"    (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36_f' "+subQuery+") a2, /n"+
				"	 car_nm e, car_mng f, "+
				"	 (select car_comp_id, car_cd, car_id, car_seq, car_name, car_b_p, car_b_dt"+
				"		from car_nm"+
				"		where (car_comp_id, car_cd, car_id, car_b_dt) in"+
				"		(select car_comp_id, car_cd, car_id, max(car_b_dt) car_b_dt from car_nm group by car_comp_id, car_cd, car_id)) g"+
				" WHERE a.car_id = b.car_id    and a.car_seq = b.car_seq "+
				"   AND a.car_id = c.car_id    and a.car_seq = c.car_seq "+
				"   AND a.car_id = d.car_id    and a.car_seq = d.car_seq "+
				"   AND a.car_id = h.car_id(+) and a.car_seq = h.car_seq(+) "+
				"   AND a.car_id = i.car_id(+) and a.car_seq = i.car_seq(+) "+
				"   AND a.car_id = a2.car_id(+) and a.car_seq = a2.car_seq(+) "+
				"   AND a.car_id = e.car_id    and a.car_seq = e.car_seq "+
				"   AND e.car_comp_id= f.car_comp_id and e.car_cd = f.code "+
				"   AND e.car_id = g.car_id(+) and e.car_seq=g.car_seq(+)";
		

		if(code.equals("")){

		}else if(code.equals("0001")){
			query += " AND a.car_comp_id = '0001' ";
		}else if(code.equals("0002")){
			query += " AND a.car_comp_id = '0002' ";
		}else if(code.equals("0003")){
			query += " AND a.car_comp_id = '0003' ";
		}else if(code.equals("0004")){
			query += " AND a.car_comp_id = '0004' ";
		}else if(code.equals("0005")){
			query += " AND a.car_comp_id = '0005' ";
		}else if(code.equals("etc")){
			query += " AND a.car_comp_id > '0005' ";
		}else if(code.equals("hd_except")){
			query += " AND a.car_comp_id != '0001' ";
		}

		if(!t_wd.equals("")){
			query += " AND f.car_nm||e.car_name like '%"+t_wd+"%' ";
		}


		query += " ORDER BY to_number(a.est_tel) ";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCars_20090703]"+e);
			System.out.println("[EstiJuyoDatabase:getJuyoCars_20090703]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	주요차종 리스트-FMS
	 */
	public Vector getJuyoCars_20090901(String code, String base_dt, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery ="";

		if(base_dt.equals("")){
			subQuery = " and (car_id,est_nm,est_id,reg_code) in (select car_id, est_nm, max(est_id) est_id, max(reg_code) reg_code from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) "; 
		}else{
			subQuery = " and substr(reg_dt,0,8)='"+base_dt+"' ";
		}

		query = "SELECT /*+ rule  */ \n"+
				"       a4.o82 as ro82, c4.o82 as lo82, a.reg_code, \n"+
				"       nvl(a.reg_dt,'') reg_dt, decode(a.rent_dt,to_char(sysdate,'YYYYMMDD'),'Y','N') rent_dt_st, \n"+
				"       a.est_id, a.est_tel seq, a.est_fax, a.car_comp_id, a.car_cd, a.car_id, a.car_seq, a.opt, f.car_nm, e.car_name, \n"+
				"       e.auto_yn, e.diesel_yn, (a.o_1+a.dc_amt) o_1, a.spr_yn, \n"+ //리스트에서는 DC 반영전 차량가격을 보여준다
				"	    decode(h2.jg_s,'1',a.est_id,a.est_id) rb36_id,   decode(h2.jg_s,'1',a.fee_s_amt,a.fee_s_amt) rb36_amt,  \n"+
				"	    decode(h2.jg_s,'1',b.est_id,b.est_id) rs36_id,   decode(h2.jg_s,'1',b.fee_s_amt,b.fee_s_amt) rs36_amt,   \n"+
				"	    decode(h2.jg_s,'1',c.est_id,c.est_id) lb36_id,   decode(h2.jg_s,'1',c.fee_s_amt,c.fee_s_amt) lb36_amt,  \n"+
				"	    decode(h2.jg_s,'1',d.est_id,d.est_id) ls36_id,   decode(h2.jg_s,'1',d.fee_s_amt,d.fee_s_amt) ls36_amt,   \n"+
				"	    decode(h2.jg_s,'1',h.est_id,h.est_id) lb36_id2,  decode(h2.jg_s,'1',h.fee_s_amt,h.fee_s_amt) lb36_amt2,  \n"+
				"	    decode(h2.jg_s,'1',i.est_id,i.est_id) ls36_id2,  decode(h2.jg_s,'1',i.fee_s_amt,i.fee_s_amt) ls36_amt2,  \n"+
				"	    e.jg_code, e.use_yn, g.car_b_p as car_new_p, \n"+
				"	    (g.car_b_p-a.car_amt) cng_amt, decode(g.car_b_p,a.car_amt,decode(g.car_seq,a.car_seq,'-','변동'),'변동') cng_st,  \n"+
				"       h2.jg_t, h2.jg_a,  \n"+		
				"       mc.rb36_amt as mc_rb36_amt, "+
				"       mc.rs36_amt as mc_rs36_amt, "+
				"       mc.lb36_amt as mc_lb36_amt, "+
				"       mc.ls36_amt as mc_ls36_amt, "+
				"       mc.lb36_amt2 as mc_lb36_amt2, "+
				"       mc.ls36_amt2 as mc_ls36_amt2  "+
				" FROM  \n"+
				"       ESTIMATE_HP a, \n"+
		        "       (select est_tel, max(reg_code) reg_code from estimate_hp where nvl(est_ssn,'Y')='Y' GROUP BY est_tel ) ma, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='rs36_f')  b, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='lb36_f')  c, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='ls36_f')  d, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='lb362_f') h, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='ls362_f') i, \n"+
				"	    car_nm e, car_mng f,  \n"+
				"	    ( select car_comp_id, car_cd, car_id, car_seq, car_name, car_b_p, car_b_dt  \n"+
				"	   	  from car_nm  \n"+
				"	   	  where use_yn='Y' and (car_comp_id, car_cd, car_id, car_b_dt) in (select car_comp_id, car_cd, car_id, max(car_b_dt) car_b_dt from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id)  \n"+
				"	    ) g, \n"+
				"	    ( select sh_code, jg_a, nvl(jg_s,'0') jg_s, jg_t  \n"+
				"		  from esti_jg_var  \n"+
				"		  where (sh_code, seq) in (select sh_code, max(seq) from esti_jg_var group by sh_code)  \n"+
				"	    ) h2,  \n"+
				"       esti_exam_hp a3, esti_compare_hp a4, \n"+
				"       esti_exam_hp c3, esti_compare_hp c4, \n"+
				"       main_car mc "+

				" WHERE "+
				"       a.est_type='J' and nvl(a.est_ssn,'Y')='Y' and a.est_nm='rb36_f' AND a.est_tel IS NOT null    \n"+
                "       AND a.est_tel=ma.est_tel AND a.reg_code=ma.reg_code    \n"+
                "       AND a.est_tel=b.est_tel(+) AND a.reg_code=b.reg_code(+) \n"+
                "       AND a.est_tel=c.est_tel(+) AND a.reg_code=c.reg_code(+) \n"+
                "       AND a.est_tel=d.est_tel(+) AND a.reg_code=d.reg_code(+) \n"+
                "       AND a.est_tel=h.est_tel(+) AND a.reg_code=h.reg_code(+) \n"+
                "       AND a.est_tel=i.est_tel(+) AND a.reg_code=i.reg_code(+) \n"+
				"       AND a.car_id = e.car_id and a.car_seq = e.car_seq AND a.car_comp_id= f.car_comp_id and a.car_cd = f.code  \n"+
				"       AND a.car_comp_id=g.car_comp_id(+) and a.car_cd=g.car_cd(+) and a.car_id=g.car_id(+)  \n"+
				"       AND e.jg_code=h2.sh_code  \n"+
				"       and a.est_id=a3.est_id  \n"+
				"       and a.est_id=a4.est_id  \n"+
				"       and c.est_id=c3.est_id  \n"+
				"       and c.est_id=c4.est_id  \n"+
				"       and a.est_tel=mc.seq(+)  \n"+
				"	";
		

		if(code.equals("")){

		}else if(code.equals("0001")){
			query += " AND a.car_comp_id = '0001' ";
		}else if(code.equals("0002")){
			query += " AND a.car_comp_id = '0002' ";
		}else if(code.equals("0003")){
			query += " AND a.car_comp_id = '0003' ";
		}else if(code.equals("0004")){
			query += " AND a.car_comp_id = '0004' ";
		}else if(code.equals("0005")){
			query += " AND a.car_comp_id = '0005' ";
		}else if(code.equals("0007")){
			query += " AND a.car_comp_id = '0007' ";
		}else if(code.equals("0013")){
			query += " AND a.car_comp_id = '0013' ";
		}else if(code.equals("0027")){
			query += " AND a.car_comp_id = '0027' ";
		}else if(code.equals("0018")){
			query += " AND a.car_comp_id = '0018' ";
		}else if(code.equals("0044")){
			query += " AND a.car_comp_id = '0044' ";
		}else if(code.equals("0011")){
			query += " AND a.car_comp_id = '0011' ";
		}else if(code.equals("etc")){
			query += " AND a.car_comp_id > '0005' ";
		}else if(code.equals("hd_except")){
			query += " AND a.car_comp_id != '0001' ";
		}else{
			if(!code.equals("")){	
				query += " AND a.car_comp_id = '"+code+"' ";
			}
		}

		if(!t_wd.equals("")){
			query += " AND f.car_nm||e.car_name||a.rent_dt||e.s_st like '%"+t_wd+"%' ";
		}


		query += " ORDER BY to_number(a.est_tel) ";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCars_20090901]"+e);
			System.out.println("[EstiJuyoDatabase:getJuyoCars_20090901]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


    /**
	 *	주요차종 사용안함으로 하기. 20060526. Yongsoon Kwon.
	 */
	public int all_no(String reg_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		String query = "";
		int cnt =0;

		query = "UPDATE estimate_hp SET est_ssn='N' WHERE est_type='J' and est_ssn='Y'";
		
		if(!reg_dt.equals("")) query += " and substr(reg_dt,0,8) = '"+reg_dt+"' " ;
		
		try {
			con.setAutoCommit(false);

		    pstmt = con.prepareStatement(query);
	    	cnt = pstmt.executeUpdate();

            pstmt.close();
			con.commit();
		} catch (Exception e) {
            try{
				System.out.println("[EstiJuyoDatabase:all_no]"+e);
                con.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		} finally {
			try{
				con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return cnt;
	}

    /**
	 *	주요차종 사용안함으로 하기. 20060526. Yongsoon Kwon.
	 */
	public int select_no(String car_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		String query = "";
		int cnt =0;

		query = "UPDATE estimate_hp SET est_ssn='N' WHERE est_type='J' and car_id = '"+car_id+"' " ;
		
		try {
			con.setAutoCommit(false);

		    pstmt = con.prepareStatement(query);
	    	cnt = pstmt.executeUpdate();

            pstmt.close();
			con.commit();
		} catch (Exception e) {
            try{
				System.out.println("[EstiJuyoDatabase:select_no]"+e);
                con.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		} finally {
			try{
				con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return cnt;
	}

    /**
	 *	주요차종 사용안함으로 하기. 20060526. Yongsoon Kwon.
	 */
	public int select_no(String car_id, String est_tel) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		String query = "";
		int cnt =0;

		query = "UPDATE estimate_hp SET est_ssn='N' WHERE est_type='J' and car_id = '"+car_id+"' and est_tel = '"+est_tel+"' " ;
		
		try {
			con.setAutoCommit(false);

		    pstmt = con.prepareStatement(query);
	    	cnt = pstmt.executeUpdate();

            pstmt.close();
			con.commit();
		} catch (Exception e) {
            try{
				System.out.println("[EstiJuyoDatabase:select_no]"+e);
                con.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		} finally {
			try{
				con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return cnt;
	}


    /**
	 *	견적일자 리스트 조회 20060526. Yongsoon Kwon.
	 */
	public Vector getReg_dtList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT distinct substr(reg_dt,0,8) base_dt FROM estimate_hp WHERE est_type='J' ORDER BY 1 DESC ";
		
		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiJuyoDatabase:getReg_dtList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	견적일자 리스트 조회 20060526. Yongsoon Kwon.
	 */
	public Vector getReg_dtListHp() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT distinct substr(reg_dt,0,8) base_dt FROM estimate_hp WHERE est_type='J' ORDER BY 1 DESC ";
		
		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiJuyoDatabase:getReg_dtListHp]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	모델별 주요차종 견적 이력 리스트
	 */
	public Vector getJuyoCarCase(String car_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*,\n"+
				" b.fee_s_amt as rb36_amt,\n"+
				" c.fee_s_amt as rs36_amt,\n"+
				" d.fee_s_amt as lb36_amt,\n"+
				" e.fee_s_amt as ls36_amt,\n"+
				" f.fee_s_amt as lb36_amt2,\n"+
				" g.fee_s_amt as ls36_amt2\n"+
				" from\n"+
				" (select car_id, reg_dt, max(car_seq) car_seq, max(car_amt) car_amt, max(opt) opt, max(opt_seq) opt_seq, max(opt_amt) opt_amt, max(o_1) o_1, max(ro_13) ro_13 from estimate where est_type='J' and car_id=? group by car_id, reg_dt) a,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate where est_type='J' and est_nm='rb36' and car_id=?) b,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate where est_type='J' and est_nm='rs36' and car_id=?) c,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate where est_type='J' and est_nm='lb36' and car_id=?) d,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate where est_type='J' and est_nm='ls36' and car_id=?) e,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate where est_type='J' and est_nm='lb362' and car_id=?) f,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate where est_type='J' and est_nm='ls362' and car_id=?) g\n"+
				" where\n"+
				" a.car_id=b.car_id        and a.reg_dt=b.reg_dt\n"+
				" and a.car_id=c.car_id    and a.reg_dt=c.reg_dt\n"+
				" and a.car_id=d.car_id    and a.reg_dt=d.reg_dt\n"+
				" and a.car_id=e.car_id    and a.reg_dt=e.reg_dt"+
				" and a.car_id=f.car_id(+) and a.reg_dt=f.reg_dt(+)"+
				" and a.car_id=g.car_id(+) and a.reg_dt=g.reg_dt(+)";
		
		query += " ORDER BY a.reg_dt desc";


		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString(1, car_id);
            pstmt.setString(2, car_id);
            pstmt.setString(3, car_id);
            pstmt.setString(4, car_id);
            pstmt.setString(5, car_id);
            pstmt.setString(6, car_id);
            pstmt.setString(7, car_id);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCarCase]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	모델별 주요차종 견적 이력 리스트
	 */
	public Vector getJuyoCarHpCase(String car_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*,\n"+
				" b.fee_s_amt as rb36_amt,\n"+
				" c.fee_s_amt as rs36_amt,\n"+
				" d.fee_s_amt as lb36_amt,\n"+
				" e.fee_s_amt as ls36_amt,\n"+
				" f.fee_s_amt as lb36_amt2,\n"+
				" g.fee_s_amt as ls36_amt2\n"+
				" from\n"+
				" (select car_id, reg_dt, max(car_seq) car_seq, max(car_amt) car_amt, max(opt) opt, max(opt_seq) opt_seq, max(opt_amt) opt_amt, max(o_1) o_1, max(ro_13) ro_13 from estimate_hp where est_type='J' and car_id=? group by car_id, reg_dt) a,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate_hp where est_type='J' and est_nm='rb36' and car_id=?) b,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate_hp where est_type='J' and est_nm='rs36' and car_id=?) c,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate_hp where est_type='J' and est_nm='lb36' and car_id=?) d,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate_hp where est_type='J' and est_nm='ls36' and car_id=?) e,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate_hp where est_type='J' and est_nm='lb362' and car_id=?) f,\n"+
				" (select car_id, reg_dt, fee_s_amt from estimate_hp where est_type='J' and est_nm='ls362' and car_id=?) g\n"+
				" where\n"+
				" a.car_id=b.car_id        and a.reg_dt=b.reg_dt\n"+
				" and a.car_id=c.car_id    and a.reg_dt=c.reg_dt\n"+
				" and a.car_id=d.car_id    and a.reg_dt=d.reg_dt\n"+
				" and a.car_id=e.car_id    and a.reg_dt=e.reg_dt"+
				" and a.car_id=f.car_id(+) and a.reg_dt=f.reg_dt(+)"+
				" and a.car_id=g.car_id(+) and a.reg_dt=g.reg_dt(+)";
		
		query += " ORDER BY a.reg_dt desc";


		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString(1, car_id);
            pstmt.setString(2, car_id);
            pstmt.setString(3, car_id);
            pstmt.setString(4, car_id);
            pstmt.setString(5, car_id);
            pstmt.setString(6, car_id);
            pstmt.setString(7, car_id);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCarHpCase]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	주요차종 월대여료 홈페이지 적용하기
	 */
	public int insertEstimateHp() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String query1 = "";
		String query2 = "";
		String query3 = "";
		int cnt =0;

		query1 = " delete from main_car";

		query2 = " SELECT  /*+  rule  */ \n"+
				"  a.est_tel seq,\n"+
				"  a.car_comp_id,\n"+
				"  f.car_nm,\n"+
				"  e.car_name,\n"+
				"  decode(e.auto_yn,'Y','오토',decode(instr(a.opt,'변속'),'','수동',0,decode(instr(a.opt,'DCT'),'','수동',0,'수동','오토'),'오토')) auto,\n"+
				"  decode(e.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') diesel,\n"+
				"  (a.o_1+a.dc_amt) o_1,\n"+//주요차종 리스트에서는 DC금액반영전 차량가격을 보여준다.
				"  a.A_B,\n"+
				"  a.est_id rb36_id,  a.fee_s_amt rb36_amt,\n"+
				"  b.est_id rs36_id,  b.fee_s_amt rs36_amt,\n"+
				"  c.est_id lb36_id,  c.fee_s_amt lb36_amt,\n"+
				"  d.est_id ls36_id,  d.fee_s_amt ls36_amt,\n"+
				"  h.est_id lb36_id2, h.fee_s_amt lb36_amt2,\n"+
				"  i.est_id ls36_id2, i.fee_s_amt ls36_amt2,\n"+
				"  j.car_cnt, to_char(sysdate,'YYYYMMDD') reg_dt\n"+
				"  FROM\n"+
				"      (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) a,\n"+
				"      (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rs36' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) b,\n"+
				"      (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb36' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) c,\n"+
				"      (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls36' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) d,\n"+
				"      (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb362' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) h,\n"+
				"      (select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls362' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) i,\n"+
				"      car_nm e, car_mng f,\n"+
				"      (select car_comp_id, car_cd, car_id, car_seq, car_name, car_b_p, car_b_dt from car_nm where (car_comp_id, car_cd, car_id, car_b_dt) in (select car_comp_id, car_cd, car_id, max(car_b_dt) car_b_dt from car_nm group by car_comp_id, car_cd, car_id)) g,\n"+
				"      (select car_comp_id, car_cd, count(*) car_cnt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) group by car_comp_id, car_cd ) j\n"+
				"  WHERE a.est_tel is not null and a.car_id = b.car_id and a.car_seq = b.car_seq\n"+
				"  AND b.car_id = c.car_id and b.car_seq = c.car_seq\n"+
				"  AND c.car_id = d.car_id and c.car_seq = d.car_seq\n"+
				"  AND b.car_id = h.car_id(+) and b.car_seq = h.car_seq(+)\n"+
				"  AND c.car_id = i.car_id(+) and c.car_seq = i.car_seq(+)\n"+
				"  AND d.car_id = e.car_id and d.car_seq = e.car_seq\n"+
				"  AND e.car_comp_id= f.car_comp_id and e.car_cd = f.code\n"+
				"  AND e.car_id = g.car_id AND e.car_seq = g.car_seq\n"+
				"  AND a.car_comp_id= j.car_comp_id and a.car_cd = j.car_cd";      	
		
		
		query3 = " INSERT INTO main_car "+
				" (SEQ, CAR_COMP_ID, CAR_NM, CAR_NAME, AUTO, DIESEL, O_1, A_B,"+
				"  RB36_ID, RB36_AMT, RS36_ID, RS36_AMT, LB36_ID, LB36_AMT, LS36_ID, LS36_AMT, LB36_ID2, LB36_AMT2, LS36_ID2, LS36_AMT2,"+ 
				"  CAR_CNT, REG_DT) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try {
			con.setAutoCommit(false);

			//기존데이타 삭제
		    pstmt1 = con.prepareStatement(query1);
	    	cnt = pstmt1.executeUpdate();

			//적용데이타 조회
		    pstmt2 = con.prepareStatement(query2);
	    	rs = pstmt2.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				//적용

	            pstmt3 = con.prepareStatement(query3);
	            pstmt3.setString(1,  String.valueOf(ht.get("SEQ")));
				pstmt3.setString(2,  String.valueOf(ht.get("CAR_COMP_ID")));
	            pstmt3.setString(3,  String.valueOf(ht.get("CAR_NM")));
	            pstmt3.setString(4,  String.valueOf(ht.get("CAR_NAME")));
				pstmt3.setString(5,  String.valueOf(ht.get("AUTO")));
				pstmt3.setString(6,  String.valueOf(ht.get("DIESEL")));
				pstmt3.setInt   (7,  AddUtil.parseInt((String)ht.get("O_1")));
	            pstmt3.setString(8,  String.valueOf(ht.get("A_B")));
	            pstmt3.setString(9,  String.valueOf(ht.get("RB36_ID")));
	            pstmt3.setInt   (10, AddUtil.parseInt((String)ht.get("RB36_AMT")));
	            pstmt3.setString(11, String.valueOf(ht.get("RS36_ID")));
	            pstmt3.setInt   (12, AddUtil.parseInt((String)ht.get("RS36_AMT")));
	            pstmt3.setString(13, String.valueOf(ht.get("LB36_ID")));
	            pstmt3.setInt   (14, AddUtil.parseInt((String)ht.get("LB36_AMT")));
	            pstmt3.setString(15, String.valueOf(ht.get("LS36_ID")));
	            pstmt3.setInt   (16, AddUtil.parseInt((String)ht.get("LS36_AMT")));
	            pstmt3.setString(17, String.valueOf(ht.get("LB36_ID2")));
	            pstmt3.setInt   (18, AddUtil.parseInt((String)ht.get("LB36_AMT2")));
	            pstmt3.setString(19, String.valueOf(ht.get("LS36_ID2")));
	            pstmt3.setInt   (20, AddUtil.parseInt((String)ht.get("LS36_AMT2")));
	            pstmt3.setInt   (21, AddUtil.parseInt((String)ht.get("CAR_CNT")));
	            pstmt3.setString(22, String.valueOf(ht.get("REG_DT")));
				cnt = pstmt3.executeUpdate();
				pstmt3.close();
			}

			rs.close();
            pstmt1.close();
            pstmt2.close();
			con.commit();

		} catch (Exception e) {
            try{
				System.out.println("[EstiJuyoDatabase:insertEstimateHp]"+e);
				System.out.println("[EstiJuyoDatabase:insertEstimateHp]"+query2);
                con.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		} finally {
			try{
				con.setAutoCommit(true);
                if(rs != null) rs.close();
				if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return cnt;
	}

    /**
	 *	주요차종 월대여료 홈페이지 적용하기
	 */
	public int insertEstimateHp_20090901() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String query1 = "";
		String query2 = "";
		String query3 = "";
		int cnt =0;

		query1 = " delete from main_car";

		query2 = " SELECT  /*+  rule  */ \n"+
				"         a.est_tel seq,\n"+
				"         a.car_comp_id,\n"+
				"         f.car_nm,\n"+
				"         e.car_name,\n"+
				"         decode(e.auto_yn,'Y','오토',decode(instr(a.opt,'변속'),'','수동',0,decode(instr(a.opt,'DCT'),'','수동',0,'수동','오토'),'오토')) auto,\n"+
				"         decode(e.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') diesel,\n"+
				"         (a.o_1+a.dc_amt) o_1,\n"+//주요차종 리스트에서는 DC금액반영전 차량가격을 보여준다.
				"         a.A_B,\n"+

				"         decode(h.jg_s,'1',a.est_id,a.est_id) rb36_id,  decode(h.jg_s,'1',a.fee_s_amt,a.fee_s_amt) rb36_amt,\n"+
				"         decode(h.jg_s,'1',b.est_id,b.est_id) rs36_id,  decode(h.jg_s,'1',b.fee_s_amt,b.fee_s_amt) rs36_amt,\n"+
				"         decode(h.jg_s,'1',c.est_id,c.est_id) lb36_id,  decode(h.jg_s,'1',c.fee_s_amt,c.fee_s_amt) lb36_amt,\n"+
				"         decode(h.jg_s,'1',d.est_id,d.est_id) ls36_id,  decode(h.jg_s,'1',d.fee_s_amt,d.fee_s_amt) ls36_amt,\n"+
				"         decode(h.jg_s,'1',h.est_id,h.est_id) lb36_id2, decode(h.jg_s,'1',h.fee_s_amt,h.fee_s_amt) lb36_amt2,\n"+
				"         decode(h.jg_s,'1',i.est_id,i.est_id) ls36_id2, decode(h.jg_s,'1',i.fee_s_amt,i.fee_s_amt) ls36_amt2,\n"+

				"         j.car_cnt, to_char(sysdate,'YYYYMMDD') reg_dt,\n"+

				"         a24.est_id as rb24_id,  a24.fee_s_amt as rb24_amt, \n"+
				"         b24.est_id as rs24_id,  b24.fee_s_amt as rs24_amt, \n"+
				"         c24.est_id as lb24_id,  c24.fee_s_amt as lb24_amt, \n"+
				"         d24.est_id as ls24_id,  d24.fee_s_amt as ls24_amt, \n"+
				"         h24.est_id as lb24_id2, h24.fee_s_amt as lb24_amt2, \n"+
				"         i24.est_id as ls24_id2, i24.fee_s_amt as ls24_amt2, \n"+

				"         h.com_nm, decode(substr(e.jg_code,1,1),'1','경승용','2','소형승용','3','중형승용','4','대형승용','5','5인승짚','6','7~8인승','7','9~10인승','8','승합','9','화물','') car_kind, e.jg_code"+

				"  FROM\n"+

				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) a,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rs36_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) b,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb36_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) c,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls36_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) d,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb362_f' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) h,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls362_f' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) i,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36_1'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) a2,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rs36_1'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) b2,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb36_1'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) c2,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls36_1'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) d2,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb362_1' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) h2,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls362_1' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) i2,\n"+

				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb24_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) a24,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rs24_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) b24,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb24_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) c24,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls24_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) d24,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb242_f' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) h24,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls242_f' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) i24,\n"+

				"         car_nm e, car_mng f,\n"+
				"         ( select car_comp_id, car_cd, car_id, car_seq, car_name, car_b_p, car_b_dt "+
				"	        from   car_nm "+
				"	        where  (car_comp_id, car_cd, car_id, car_b_dt) in (select car_comp_id, car_cd, car_id, max(car_b_dt) car_b_dt from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id)"+
				"	      ) g,\n"+
				"         ( select car_comp_id, car_cd, count(*) car_cnt "+
				"	        from   estimate_hp "+
				"	        where  est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36_f' "+
				"	               and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) "+
				"	        group by car_comp_id, car_cd "+
				"	      ) j, \n"+
				"	      ( select sh_code, jg_a, nvl(jg_s,'0') jg_s, com_nm "+
				"		    from   esti_jg_var"+
				"		    where  (sh_code, seq) in (select sh_code, max(seq) from esti_jg_var group by sh_code)"+
				"	      ) h"+
				"  WHERE  a.est_tel is not null "+
				"         AND a.car_id = b.car_id and a.car_seq = b.car_seq\n"+
				"         AND a.car_id = c.car_id and a.car_seq = c.car_seq\n"+
				"         AND a.car_id = d.car_id and a.car_seq = d.car_seq\n"+
				"         AND a.car_id = h.car_id and a.car_seq = h.car_seq\n"+
				"         AND a.car_id = i.car_id and a.car_seq = i.car_seq\n"+

				"         AND a.car_id = a2.car_id(+) and a.car_seq = a2.car_seq(+)\n"+
				"         AND a.car_id = b2.car_id(+) and a.car_seq = b2.car_seq(+)\n"+
				"         AND a.car_id = c2.car_id(+) and a.car_seq = c2.car_seq(+)\n"+
				"         AND a.car_id = d2.car_id(+) and a.car_seq = d2.car_seq(+)\n"+
				"         AND a.car_id = h2.car_id(+) and a.car_seq = h2.car_seq(+)\n"+
				"         AND a.car_id = i2.car_id(+) and a.car_seq = i2.car_seq(+)\n"+

				"         AND a.car_id = a24.car_id(+) and a.car_seq = a24.car_seq(+)\n"+
				"         AND a.car_id = b24.car_id(+) and a.car_seq = b24.car_seq(+)\n"+
				"         AND a.car_id = c24.car_id(+) and a.car_seq = c24.car_seq(+)\n"+
				"         AND a.car_id = d24.car_id(+) and a.car_seq = d24.car_seq(+)\n"+
				"         AND a.car_id = h24.car_id(+) and a.car_seq = h24.car_seq(+)\n"+
				"         AND a.car_id = i24.car_id(+) and a.car_seq = i24.car_seq(+)\n"+

				"         AND d.car_id = e.car_id and d.car_seq = e.car_seq\n"+
				"         AND e.car_comp_id= f.car_comp_id and e.car_cd = f.code\n"+
				"         AND e.car_id = g.car_id(+) AND e.car_seq = g.car_seq(+)\n"+
				"         AND a.car_comp_id= j.car_comp_id and a.car_cd = j.car_cd"+
				"         AND e.jg_code=h.sh_code"+
				"  ";      
				
		
		query3 = " INSERT INTO main_car "+
				"         ( SEQ, CAR_COMP_ID, CAR_NM, CAR_NAME, AUTO, DIESEL, O_1, A_B,"+
				"           RB36_ID, RB36_AMT, RS36_ID, RS36_AMT, LB36_ID, LB36_AMT, LS36_ID, LS36_AMT, LB36_ID2, LB36_AMT2, LS36_ID2, LS36_AMT2,"+ 
				"           CAR_CNT, REG_DT, "+
				"           RB24_ID, RB24_AMT, RS24_ID, RS24_AMT, LB24_ID, LB24_AMT, LS24_ID, LS24_AMT, LB24_ID2, LB24_AMT2, LS24_ID2, LS24_AMT2,"+ 
				"           CAR_KIND, COM_NM, JG_CODE "+
			    "         ) values "+
			    "         ( ?, ?, ?, ?, ?, ?, ?, ?, "+
			    "           ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
			    "           ?, ?, "+
			    "           ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"           ?, ?, ? "+
			    "         )";

		try {
			con.setAutoCommit(false);

			//기존데이타 삭제
		    pstmt1 = con.prepareStatement(query1);
	    	cnt = pstmt1.executeUpdate();

			//적용데이타 조회
		    pstmt2 = con.prepareStatement(query2);
	    	rs = pstmt2.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				//적용

	            pstmt3 = con.prepareStatement(query3);
	            pstmt3.setString(1,  String.valueOf(ht.get("SEQ")));
				pstmt3.setString(2,  String.valueOf(ht.get("CAR_COMP_ID")));
	            pstmt3.setString(3,  String.valueOf(ht.get("CAR_NM")));
	            pstmt3.setString(4,  String.valueOf(ht.get("CAR_NAME")));
				pstmt3.setString(5,  String.valueOf(ht.get("AUTO")));
				pstmt3.setString(6,  String.valueOf(ht.get("DIESEL")));
				pstmt3.setInt   (7,  AddUtil.parseInt((String)ht.get("O_1")));
	            pstmt3.setString(8,  String.valueOf(ht.get("A_B")));
	            pstmt3.setString(9,  String.valueOf(ht.get("RB36_ID")));
	            pstmt3.setInt   (10, AddUtil.parseInt((String)ht.get("RB36_AMT")));
	            pstmt3.setString(11, String.valueOf(ht.get("RS36_ID")));
	            pstmt3.setInt   (12, AddUtil.parseInt((String)ht.get("RS36_AMT")));
	            pstmt3.setString(13, String.valueOf(ht.get("LB36_ID")));
	            pstmt3.setInt   (14, AddUtil.parseInt((String)ht.get("LB36_AMT")));
	            pstmt3.setString(15, String.valueOf(ht.get("LS36_ID")));
	            pstmt3.setInt   (16, AddUtil.parseInt((String)ht.get("LS36_AMT")));
	            pstmt3.setString(17, String.valueOf(ht.get("LB36_ID2")));
	            pstmt3.setInt   (18, AddUtil.parseInt((String)ht.get("LB36_AMT2")));
	            pstmt3.setString(19, String.valueOf(ht.get("LS36_ID2")));
	            pstmt3.setInt   (20, AddUtil.parseInt((String)ht.get("LS36_AMT2")));
	            pstmt3.setInt   (21, AddUtil.parseInt((String)ht.get("CAR_CNT")));
	            pstmt3.setString(22, String.valueOf(ht.get("REG_DT")));

	            pstmt3.setString(23,  String.valueOf(ht.get("RB24_ID")));
	            pstmt3.setInt   (24, AddUtil.parseInt((String)ht.get("RB24_AMT")));
	            pstmt3.setString(25, String.valueOf(ht.get("RS24_ID")));
	            pstmt3.setInt   (26, AddUtil.parseInt((String)ht.get("RS24_AMT")));
	            pstmt3.setString(27, String.valueOf(ht.get("LB24_ID")));
	            pstmt3.setInt   (28, AddUtil.parseInt((String)ht.get("LB24_AMT")));
	            pstmt3.setString(29, String.valueOf(ht.get("LS24_ID")));
	            pstmt3.setInt   (30, AddUtil.parseInt((String)ht.get("LS24_AMT")));
	            pstmt3.setString(31, String.valueOf(ht.get("LB24_ID2")));
	            pstmt3.setInt   (32, AddUtil.parseInt((String)ht.get("LB24_AMT2")));
	            pstmt3.setString(33, String.valueOf(ht.get("LS24_ID2")));
	            pstmt3.setInt   (34, AddUtil.parseInt((String)ht.get("LS24_AMT2")));
	            pstmt3.setString(35,  String.valueOf(ht.get("CAR_KIND")));
	            pstmt3.setString(36,  String.valueOf(ht.get("COM_NM")));
	            pstmt3.setString(37,  String.valueOf(ht.get("JG_CODE")));

				cnt = pstmt3.executeUpdate();
				pstmt3.close();
			}

			rs.close();
            pstmt1.close();
            pstmt2.close();
			con.commit();

		} catch (Exception e) {
            try{
				System.out.println("[EstiJuyoDatabase:insertEstimateHp_20090901]"+e);
				System.out.println("[EstiJuyoDatabase:insertEstimateHp_20090901]"+query2);
                con.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		} finally {
			try{
				con.setAutoCommit(true);
                if(rs != null) rs.close();
				if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return cnt;
	}

    /**
	 *	주요차종 월대여료 홈페이지 적용하기 : 12개월추가
	 */
	public int insertEstimateHp_20110331() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		String query1 = "";
		String query2 = "";
		String query3 = "";
		int cnt =0;

		query1 = " delete from main_car";

		
		query2 = " SELECT  /*+rule  */ \n"+
				"         a.est_tel seq,\n"+
				"         a.car_comp_id,\n"+
				"         f.car_nm,\n"+
				"         e.car_name, e.dpm, \n"+
				"         decode(e.auto_yn,'Y','오토',decode(instr(a.opt,'변속'),'','수동',0,decode(instr(a.opt,'DCT'),'','수동',0,'수동','오토'),'오토')) auto,\n"+
				"         decode(e.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') diesel,\n"+
				"         (a.o_1+a.dc_amt) o_1,\n"+//주요차종 리스트에서는 DC금액반영전 차량가격을 보여준다.
				"         a.A_B,\n"+

				"         decode(h.jg_s,'1',a.est_id,a.est_id) rb36_id,  decode(h.jg_s,'1',a.fee_s_amt,a.fee_s_amt) rb36_amt,\n"+
				"         decode(h.jg_s,'1',b.est_id,b.est_id) rs36_id,  decode(h.jg_s,'1',b.fee_s_amt,b.fee_s_amt) rs36_amt,\n"+
				"         decode(h.jg_s,'1',c.est_id,c.est_id) lb36_id,  decode(h.jg_s,'1',c.fee_s_amt,c.fee_s_amt) lb36_amt,\n"+
				"         decode(h.jg_s,'1',d.est_id,d.est_id) ls36_id,  decode(h.jg_s,'1',d.fee_s_amt,d.fee_s_amt) ls36_amt,\n"+
				"         decode(h.jg_s,'1',h.est_id,h.est_id) lb36_id2, decode(h.jg_s,'1',h.fee_s_amt,h.fee_s_amt) lb36_amt2,\n"+
				"         decode(h.jg_s,'1',i.est_id,i.est_id) ls36_id2, decode(h.jg_s,'1',i.fee_s_amt,i.fee_s_amt) ls36_amt2,\n"+

				"         j.car_cnt, to_char(sysdate,'YYYYMMDD') reg_dt,\n"+

				"         a24.est_id as rb24_id,  a24.fee_s_amt as rb24_amt, \n"+
				"         b24.est_id as rs24_id,  b24.fee_s_amt as rs24_amt, \n"+
				"         c24.est_id as lb24_id,  c24.fee_s_amt as lb24_amt, \n"+
				"         d24.est_id as ls24_id,  d24.fee_s_amt as ls24_amt, \n"+
				"         h24.est_id as lb24_id2, h24.fee_s_amt as lb24_amt2, \n"+
				"         i24.est_id as ls24_id2, i24.fee_s_amt as ls24_amt2, \n"+

				"         a12.est_id as rb12_id,  a12.fee_s_amt as rb12_amt, \n"+
				"         b12.est_id as rs12_id,  b12.fee_s_amt as rs12_amt, \n"+
				"         c12.est_id as lb12_id,  c12.fee_s_amt as lb12_amt, \n"+
				"         d12.est_id as ls12_id,  d12.fee_s_amt as ls12_amt, \n"+
				"         h12.est_id as lb12_id2, h12.fee_s_amt as lb12_amt2, \n"+
				"         i12.est_id as ls12_id2, i12.fee_s_amt as ls12_amt2, \n"+

				"         h.com_nm, decode(substr(e.jg_code,1,1),'1','경승용','2','소형승용','3','중형승용','4','대형승용','5','5인승짚','6','7~8인승','7','9~10인승','8','승합','9','화물','') car_kind, e.jg_code"+

				"  FROM\n"+

				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) a,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rs36_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) b,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb36_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) c,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls36_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) d,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb362_f' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) h,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls362_f' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) i,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36_1'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) a2,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rs36_1'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) b2,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb36_1'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) c2,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls36_1'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) d2,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb362_1' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) h2,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls362_1' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) i2,\n"+

				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb24_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) a24,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rs24_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) b24,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb24_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) c24,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls24_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) d24,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb242_f' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) h24,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls242_f' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) i24,\n"+

				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb12_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) a12,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rs12_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) b12,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb12_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) c12,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls12_f'  and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) d12,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='lb122_f' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) h12,\n"+
				"         ( select * from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='ls122_f' and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) ) i12,\n"+

				"         car_nm e, car_mng f,\n"+
				"         ( select car_comp_id, car_cd, car_id, car_seq, car_name, car_b_p, car_b_dt "+
				"	        from   car_nm "+
				"	        where  (car_comp_id, car_cd, car_id, car_b_dt) in (select car_comp_id, car_cd, car_id, max(car_b_dt) car_b_dt from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id)"+
				"	      ) g,\n"+
				"         ( select car_comp_id, car_cd, count(*) car_cnt "+
				"	        from   estimate_hp "+
				"	        where  est_type='J' and nvl(est_ssn,'Y')='Y' and est_nm='rb36_f' "+
				"	               and (car_id,est_nm,est_id,reg_dt) in (select car_id, est_nm, max(est_id) est_id, max(reg_dt) reg_dt from estimate_hp where est_type='J' and nvl(est_ssn,'Y')='Y' group by car_id, est_nm ) "+
				"	        group by car_comp_id, car_cd "+
				"	      ) j, \n"+
				"	      ( select sh_code, jg_a, nvl(jg_s,'0') jg_s, com_nm "+
				"		    from   esti_jg_var"+
				"		    where  (sh_code, seq) in (select sh_code, max(seq) from esti_jg_var group by sh_code)"+
				"	      ) h"+
				"  WHERE  a.est_tel is not null "+
				"         AND a.car_id = b.car_id and a.car_seq = b.car_seq\n"+
				"         AND a.car_id = c.car_id and a.car_seq = c.car_seq\n"+
				"         AND a.car_id = d.car_id and a.car_seq = d.car_seq\n"+
				"         AND a.car_id = h.car_id and a.car_seq = h.car_seq\n"+
				"         AND a.car_id = i.car_id and a.car_seq = i.car_seq\n"+

				"         AND a.car_id = a2.car_id(+) and a.car_seq = a2.car_seq(+)\n"+
				"         AND a.car_id = b2.car_id(+) and a.car_seq = b2.car_seq(+)\n"+
				"         AND a.car_id = c2.car_id(+) and a.car_seq = c2.car_seq(+)\n"+
				"         AND a.car_id = d2.car_id(+) and a.car_seq = d2.car_seq(+)\n"+
				"         AND a.car_id = h2.car_id(+) and a.car_seq = h2.car_seq(+)\n"+
				"         AND a.car_id = i2.car_id(+) and a.car_seq = i2.car_seq(+)\n"+

				"         AND a.car_id = a24.car_id(+) and a.car_seq = a24.car_seq(+)\n"+
				"         AND a.car_id = b24.car_id(+) and a.car_seq = b24.car_seq(+)\n"+
				"         AND a.car_id = c24.car_id(+) and a.car_seq = c24.car_seq(+)\n"+
				"         AND a.car_id = d24.car_id(+) and a.car_seq = d24.car_seq(+)\n"+
				"         AND a.car_id = h24.car_id(+) and a.car_seq = h24.car_seq(+)\n"+
				"         AND a.car_id = i24.car_id(+) and a.car_seq = i24.car_seq(+)\n"+

				"         AND a.car_id = a12.car_id(+) and a.car_seq = a12.car_seq(+)\n"+
				"         AND a.car_id = b12.car_id(+) and a.car_seq = b12.car_seq(+)\n"+
				"         AND a.car_id = c12.car_id(+) and a.car_seq = c12.car_seq(+)\n"+
				"         AND a.car_id = d12.car_id(+) and a.car_seq = d12.car_seq(+)\n"+
				"         AND a.car_id = h12.car_id(+) and a.car_seq = h12.car_seq(+)\n"+
				"         AND a.car_id = i12.car_id(+) and a.car_seq = i12.car_seq(+)\n"+

				"         AND d.car_id = e.car_id and d.car_seq = e.car_seq\n"+
				"         AND e.car_comp_id= f.car_comp_id and e.car_cd = f.code\n"+
				"         AND e.car_id = g.car_id(+) AND e.car_seq = g.car_seq(+)\n"+
				"         AND a.car_comp_id= j.car_comp_id and a.car_cd = j.car_cd"+
				"         AND e.jg_code=h.sh_code"+
				"  ";      
				
		
		query3 = " INSERT INTO main_car "+
				"         ( SEQ, CAR_COMP_ID, CAR_NM, CAR_NAME, AUTO, DIESEL, O_1, A_B,"+
				"           RB36_ID, RB36_AMT, RS36_ID, RS36_AMT, LB36_ID, LB36_AMT, LS36_ID, LS36_AMT, LB36_ID2, LB36_AMT2, LS36_ID2, LS36_AMT2,"+ 
				"           CAR_CNT, REG_DT, "+
				"           RB24_ID, RB24_AMT, RS24_ID, RS24_AMT, LB24_ID, LB24_AMT, LS24_ID, LS24_AMT, LB24_ID2, LB24_AMT2, LS24_ID2, LS24_AMT2,"+ 
				"           RB12_ID, RB12_AMT, RS12_ID, RS12_AMT, LB12_ID, LB12_AMT, LS12_ID, LS12_AMT, LB12_ID2, LB12_AMT2, LS12_ID2, LS12_AMT2,"+ 
				"           CAR_KIND, COM_NM, JG_CODE, DPM "+
			    "         ) values "+
			    "         ( ?, ?, ?, ?, ?, ?, ?, ?, "+
			    "           ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
			    "           ?, ?, "+
			    "           ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
			    "           ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"           ?, ?, ?, ?  "+
			    "         )";

		try {
			con.setAutoCommit(false);

			//기존데이타 삭제
		    pstmt1 = con.prepareStatement(query1);
	    	cnt = pstmt1.executeUpdate();

			//적용데이타 조회
		    pstmt2 = con.prepareStatement(query2);
	    	rs = pstmt2.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				//적용

	            pstmt3 = con.prepareStatement(query3);
	            pstmt3.setString(1,  String.valueOf(ht.get("SEQ")));
				pstmt3.setString(2,  String.valueOf(ht.get("CAR_COMP_ID")));
	            pstmt3.setString(3,  String.valueOf(ht.get("CAR_NM")));
	            pstmt3.setString(4,  String.valueOf(ht.get("CAR_NAME")));
				pstmt3.setString(5,  String.valueOf(ht.get("AUTO")));
				pstmt3.setString(6,  String.valueOf(ht.get("DIESEL")));
				pstmt3.setInt   (7,  AddUtil.parseInt((String)ht.get("O_1")));
	            pstmt3.setString(8,  String.valueOf(ht.get("A_B")));
	            pstmt3.setString(9,  String.valueOf(ht.get("RB36_ID")));
	            pstmt3.setInt   (10, AddUtil.parseInt((String)ht.get("RB36_AMT")));
	            pstmt3.setString(11, String.valueOf(ht.get("RS36_ID")));
	            pstmt3.setInt   (12, AddUtil.parseInt((String)ht.get("RS36_AMT")));
	            pstmt3.setString(13, String.valueOf(ht.get("LB36_ID")));
	            pstmt3.setInt   (14, AddUtil.parseInt((String)ht.get("LB36_AMT")));
	            pstmt3.setString(15, String.valueOf(ht.get("LS36_ID")));
	            pstmt3.setInt   (16, AddUtil.parseInt((String)ht.get("LS36_AMT")));
	            pstmt3.setString(17, String.valueOf(ht.get("LB36_ID2")));
	            pstmt3.setInt   (18, AddUtil.parseInt((String)ht.get("LB36_AMT2")));
	            pstmt3.setString(19, String.valueOf(ht.get("LS36_ID2")));
	            pstmt3.setInt   (20, AddUtil.parseInt((String)ht.get("LS36_AMT2")));
	            pstmt3.setInt   (21, AddUtil.parseInt((String)ht.get("CAR_CNT")));
	            pstmt3.setString(22, String.valueOf(ht.get("REG_DT")));

	            pstmt3.setString(23,  String.valueOf(ht.get("RB24_ID")));
	            pstmt3.setInt   (24, AddUtil.parseInt((String)ht.get("RB24_AMT")));
	            pstmt3.setString(25, String.valueOf(ht.get("RS24_ID")));
	            pstmt3.setInt   (26, AddUtil.parseInt((String)ht.get("RS24_AMT")));
	            pstmt3.setString(27, String.valueOf(ht.get("LB24_ID")));
	            pstmt3.setInt   (28, AddUtil.parseInt((String)ht.get("LB24_AMT")));
	            pstmt3.setString(29, String.valueOf(ht.get("LS24_ID")));
	            pstmt3.setInt   (30, AddUtil.parseInt((String)ht.get("LS24_AMT")));
	            pstmt3.setString(31, String.valueOf(ht.get("LB24_ID2")));
	            pstmt3.setInt   (32, AddUtil.parseInt((String)ht.get("LB24_AMT2")));
	            pstmt3.setString(33, String.valueOf(ht.get("LS24_ID2")));
	            pstmt3.setInt   (34, AddUtil.parseInt((String)ht.get("LS24_AMT2")));

	            pstmt3.setString(35,  String.valueOf(ht.get("RB12_ID")));
	            pstmt3.setInt   (36, AddUtil.parseInt((String)ht.get("RB12_AMT")));
	            pstmt3.setString(37, String.valueOf(ht.get("RS12_ID")));
	            pstmt3.setInt   (38, AddUtil.parseInt((String)ht.get("RS12_AMT")));
	            pstmt3.setString(39, String.valueOf(ht.get("LB12_ID")));
	            pstmt3.setInt   (40, AddUtil.parseInt((String)ht.get("LB12_AMT")));
	            pstmt3.setString(41, String.valueOf(ht.get("LS12_ID")));
	            pstmt3.setInt   (42, AddUtil.parseInt((String)ht.get("LS12_AMT")));
	            pstmt3.setString(43, String.valueOf(ht.get("LB12_ID2")));
	            pstmt3.setInt   (44, AddUtil.parseInt((String)ht.get("LB12_AMT2")));
	            pstmt3.setString(45, String.valueOf(ht.get("LS12_ID2")));
	            pstmt3.setInt   (46, AddUtil.parseInt((String)ht.get("LS12_AMT2")));

	            pstmt3.setString(47, String.valueOf(ht.get("CAR_KIND")));
	            pstmt3.setString(48, String.valueOf(ht.get("COM_NM")));
	            pstmt3.setString(49, String.valueOf(ht.get("JG_CODE")));
	            pstmt3.setInt   (50, AddUtil.parseInt((String)ht.get("DPM")));

				cnt = pstmt3.executeUpdate();
				pstmt3.close();
			}

			rs.close();
            pstmt1.close();
            pstmt2.close();
			con.commit();

		} catch (Exception e) {
            try{
				System.out.println("[EstiJuyoDatabase:insertEstimateHp_20110331]"+e);
				System.out.println("[EstiJuyoDatabase:insertEstimateHp_20110331]"+query2);
                con.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
		} finally {
			try{
				con.setAutoCommit(true);
                if(rs != null) rs.close();
				if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return cnt;
	}

    /**
	 *	주요차종 리스트
	 */
	public Vector getJuyoCars2(String code, int mode) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//2007년1월25일 변경 : main_car 테이블에 데이타를 고정시켜 가져옴---------------------------------

		query = "select * from main_car";

		if(code.equals("")){

		}else if(code.equals("0001")){
			query += " where car_comp_id = '0001' ";
		}else if(code.equals("0002")){
			query += " where car_comp_id = '0002' ";
		}else if(code.equals("0003")){
			query += " where car_comp_id = '0003' ";
		}else if(code.equals("0004")){
			query += " where car_comp_id = '0004' ";
		}else if(code.equals("0005")){
			query += " where car_comp_id = '0005' ";
		}else if(code.equals("etc")){
			query += " where car_comp_id > '0005' ";
		}else if(code.equals("hd_except")){
			query += " where car_comp_id != '0001' ";
		}

		//렌트기본식,렌트일반식
		if(mode == 1)			query += " and rb36_amt > -1";
		//리스기본식-보험포함/미포함
		if(mode == 2)			query += " and lb36_amt > -1";

		query += " ORDER BY to_number(seq) ";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiDatabase:getJuyoCars2]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			return vt;
		}
	}

    /**
	 *	주요차종 리스트 20100430
	 */
	public Vector getJuyoCars2(String code, String code2, String mode) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = "select * from main_car where o_1>0";

		//제조사
		if(code.equals("0001")){				query += " and car_comp_id = '0001' ";
		}else if(code.equals("0002")){			query += " and car_comp_id = '0002' ";
		}else if(code.equals("0003")){			query += " and car_comp_id = '0003' ";
		}else if(code.equals("0004")){			query += " and car_comp_id = '0004' ";
		}else if(code.equals("0005")){			query += " and car_comp_id = '0005' ";
		}else if(code.equals("etc")){			query += " and car_comp_id > '0005' ";
		}else if(code.equals("sdss")){			query += " and car_comp_id in ('0003','0004','0005') ";
		}else if(code.equals("hd_except")){		query += " and car_comp_id > '0001' ";
		}

		if(code2.equals("12")){					query += " and car_kind in ('경승용', '소형승용') and DIESEL <> 'LPG'";
		}else if(code2.equals("3")){			query += " and car_kind =   '중형승용' ";
		}else if(code2.equals("3O")){			query += " and car_kind =   '중형승용' and DIESEL <> 'LPG'";
		}else if(code2.equals("3L")){			query += " and car_kind in ('중형승용','소형승용') and DIESEL = 'LPG'";
		}else if(code2.equals("4")){			query += " and car_kind =   '대형승용' ";
		}else if(code2.equals("4O")){			query += " and car_kind =   '대형승용' and DIESEL <> 'LPG'";
		}else if(code2.equals("4L")){			query += " and car_kind =   '대형승용' and DIESEL = 'LPG'";
		}else if(code2.equals("8")){			query += " and car_kind not in ('경승용','소형승용','중형승용','대형승용','승합','화물') ";//RV
		}else if(code2.equals("9")){			query += " and car_kind in ('승합','화물') ";//승합/화물
		}

		//렌트기본식,렌트일반식
		if(mode.equals("1"))			query += " and rb36_amt > -1 and (rb36_amt+rs36_amt) >0";
		//리스기본식-보험포함/미포함
		if(mode.equals("2"))			query += " and lb36_amt > -1";


		query += " order by  jg_code, decode(diesel,'휘발유',1,'경유',2,3), car_nm, o_1 ";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiDatabase:getJuyoCars2]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			return vt;
		}
	}


    /**
	 *	모델별 주요차종 견적 이력 리스트
	 */
	public Vector getJuyoCarHpCase_20090901(String car_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*,\n"+

				" decode(n.s_st,'100',b2.fee_s_amt,'409',b2.fee_s_amt,'101',b2.fee_s_amt,'102',b2.fee_s_amt,'301',b2.fee_s_amt,'302',b2.fee_s_amt,b.fee_s_amt) as rb36_amt,	\n"+
				" decode(n.s_st,'100',c2.fee_s_amt,'409',c2.fee_s_amt,'101',c2.fee_s_amt,'102',c2.fee_s_amt,'301',c2.fee_s_amt,'302',c2.fee_s_amt,c.fee_s_amt) as rs36_amt,	\n"+
				" decode(n.s_st,'100',d2.fee_s_amt,'409',d2.fee_s_amt,'101',d2.fee_s_amt,'102',d2.fee_s_amt,'301',d2.fee_s_amt,'302',d2.fee_s_amt,d.fee_s_amt) as lb36_amt,	\n"+
				" decode(n.s_st,'100',e2.fee_s_amt,'409',e2.fee_s_amt,'101',e2.fee_s_amt,'102',e2.fee_s_amt,'301',e2.fee_s_amt,'302',e2.fee_s_amt,e.fee_s_amt) as ls36_amt,	\n"+
				" decode(n.s_st,'100',f2.fee_s_amt,'409',f2.fee_s_amt,'101',f2.fee_s_amt,'102',f2.fee_s_amt,'301',f2.fee_s_amt,'302',f2.fee_s_amt,f.fee_s_amt) as lb36_amt2,	\n"+
				" decode(n.s_st,'100',g2.fee_s_amt,'409',g2.fee_s_amt,'101',g2.fee_s_amt,'102',g2.fee_s_amt,'301',g2.fee_s_amt,'302',g2.fee_s_amt,g.fee_s_amt) as ls36_amt2,	\n"+

				" decode(n.s_st,'100',b2.dc_amt,'409',b2.fee_s_amt,'101',b2.dc_amt,'102',b2.dc_amt,'301',b2.dc_amt,'302',b2.dc_amt,b.dc_amt) as rb36_dc_amt,	\n"+
				" decode(n.s_st,'100',c2.dc_amt,'409',c2.fee_s_amt,'101',c2.dc_amt,'102',c2.dc_amt,'301',c2.dc_amt,'302',c2.dc_amt,c.dc_amt) as rs36_dc_amt,	\n"+
				" decode(n.s_st,'100',d2.dc_amt,'409',d2.fee_s_amt,'101',d2.dc_amt,'102',d2.dc_amt,'301',d2.dc_amt,'302',d2.dc_amt,d.dc_amt) as lb36_dc_amt,	\n"+
				" decode(n.s_st,'100',e2.dc_amt,'409',e2.fee_s_amt,'101',e2.dc_amt,'102',e2.dc_amt,'301',e2.dc_amt,'302',e2.dc_amt,e.dc_amt) as ls36_dc_amt,	\n"+
				" decode(n.s_st,'100',f2.dc_amt,'409',f2.fee_s_amt,'101',f2.dc_amt,'102',f2.dc_amt,'301',f2.dc_amt,'302',f2.dc_amt,f.dc_amt) as lb36_dc_amt2,	\n"+
				" decode(n.s_st,'100',g2.dc_amt,'409',g2.fee_s_amt,'101',g2.dc_amt,'102',g2.dc_amt,'301',g2.dc_amt,'302',g2.dc_amt,g.dc_amt) as ls36_dc_amt2,	\n"+

				" decode(n.s_st,'100',b2.cls_per,'409',b2.fee_s_amt,'101',b2.cls_per,'102',b2.cls_per,'301',b2.cls_per,'302',b2.cls_per,b.cls_per) as rb36_cls_per,	\n"+
				" decode(n.s_st,'100',c2.cls_per,'409',c2.fee_s_amt,'101',c2.cls_per,'102',c2.cls_per,'301',c2.cls_per,'302',c2.cls_per,c.cls_per) as rs36_cls_per,	\n"+
				" decode(n.s_st,'100',d2.cls_per,'409',d2.fee_s_amt,'101',d2.cls_per,'102',d2.cls_per,'301',d2.cls_per,'302',d2.cls_per,d.cls_per) as lb36_cls_per,	\n"+
				" decode(n.s_st,'100',e2.cls_per,'409',e2.fee_s_amt,'101',e2.cls_per,'102',e2.cls_per,'301',e2.cls_per,'302',e2.cls_per,e.cls_per) as ls36_cls_per,	\n"+
				" decode(n.s_st,'100',f2.cls_per,'409',f2.fee_s_amt,'101',f2.cls_per,'102',f2.cls_per,'301',f2.cls_per,'302',f2.cls_per,f.cls_per) as lb36_cls_per2,	\n"+
				" decode(n.s_st,'100',g2.cls_per,'409',g2.fee_s_amt,'101',g2.cls_per,'102',g2.cls_per,'301',g2.cls_per,'302',g2.cls_per,g.cls_per) as ls36_cls_per2,	\n"+

				" decode(n.s_st,'100',b2.est_id,'409',b2.fee_s_amt,'101',b2.est_id,'102',b2.est_id,'301',b2.est_id,'302',b2.est_id,b.est_id) as rb36_id,	\n"+
				" decode(n.s_st,'100',c2.est_id,'409',c2.fee_s_amt,'101',c2.est_id,'102',c2.est_id,'301',c2.est_id,'302',c2.est_id,c.est_id) as rs36id,	\n"+
				" decode(n.s_st,'100',d2.est_id,'409',d2.fee_s_amt,'101',d2.est_id,'102',d2.est_id,'301',d2.est_id,'302',d2.est_id,d.est_id) as lb36_id,	\n"+
				" decode(n.s_st,'100',e2.est_id,'409',e2.fee_s_amt,'101',e2.est_id,'102',e2.est_id,'301',e2.est_id,'302',e2.est_id,e.est_id) as ls36_id,	\n"+
				" decode(n.s_st,'100',f2.est_id,'409',f2.fee_s_amt,'101',f2.est_id,'102',f2.est_id,'301',f2.est_id,'302',f2.est_id,f.est_id) as lb36_id2,	\n"+
				" decode(n.s_st,'100',g2.est_id,'409',g2.fee_s_amt,'101',g2.est_id,'102',g2.est_id,'301',g2.est_id,'302',g2.est_id,g.est_id) as ls36_id2	\n"+

				" from\n"+

				" (select car_id, reg_dt, reg_code, max(car_seq) car_seq, max(car_amt) car_amt, max(opt) opt, max(opt_seq) opt_seq, max(opt_amt) opt_amt, max(o_1) o_1, max(dc_amt) dc_amt, max(ro_13) ro_13 from estimate_hp where est_type='J' and est_nm like '%36%_f%' and car_id=? group by car_id, reg_dt, reg_code) a,\n"+

				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='rb36_f'  ) b,\n"+
				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='rs36_f'  ) c,\n"+
				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='lb36_f'  ) d,\n"+
				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='ls36_f'  ) e,\n"+
				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='lb362_f' ) f,\n"+
				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='ls362_f' ) g,\n"+

				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='rb36_f'  ) b2,\n"+
				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='rs36_f'  ) c2,\n"+
				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='lb36_f'  ) d2,\n"+
				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='ls36_f'  ) e2,\n"+
				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='lb362_f' ) f2,\n"+
				" (select est_id, car_id, reg_dt, reg_code, fee_s_amt, cls_per, dc_amt from estimate_hp where car_id=? and est_nm='ls362_f' ) g2,\n"+

				" car_nm n "+

				" where\n"+
				" a.car_id=b.car_id         and a.reg_dt=b.reg_dt   and a.reg_code=b.reg_code  "+
				" and a.car_id=c.car_id     and a.reg_dt=c.reg_dt   and a.reg_code=c.reg_code  "+
				" and a.car_id=d.car_id     and a.reg_dt=d.reg_dt   and a.reg_code=d.reg_code  "+
				" and a.car_id=e.car_id     and a.reg_dt=e.reg_dt   and a.reg_code=e.reg_code  "+
				" and a.car_id=f.car_id     and a.reg_dt=f.reg_dt   and a.reg_code=f.reg_code  "+
				" and a.car_id=g.car_id     and a.reg_dt=g.reg_dt   and a.reg_code=g.reg_code  "+
				" and a.car_id=b2.car_id(+)    and a.reg_dt=b2.reg_dt(+)  and a.reg_code=b2.reg_code(+) "+
				" and a.car_id=c2.car_id(+)    and a.reg_dt=c2.reg_dt(+)  and a.reg_code=c2.reg_code(+) "+
				" and a.car_id=d2.car_id(+)    and a.reg_dt=d2.reg_dt(+)  and a.reg_code=d2.reg_code(+) "+
				" and a.car_id=e2.car_id(+)    and a.reg_dt=e2.reg_dt(+)  and a.reg_code=e2.reg_code(+) "+
				" and a.car_id=f2.car_id(+)    and a.reg_dt=f2.reg_dt(+)  and a.reg_code=f2.reg_code(+) "+
				" and a.car_id=g2.car_id(+)    and a.reg_dt=g2.reg_dt(+)  and a.reg_code=g2.reg_code(+) "+
				" and a.car_id=n.car_id		and a.car_seq=n.car_seq"+		
				" ";
		
		query += " ORDER BY a.reg_dt desc, a.reg_code desc";


		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString(1, car_id);
            pstmt.setString(2, car_id);
            pstmt.setString(3, car_id);
            pstmt.setString(4, car_id);
            pstmt.setString(5, car_id);
            pstmt.setString(6, car_id);
            pstmt.setString(7, car_id);
            pstmt.setString(8, car_id);
            pstmt.setString(9, car_id);
            pstmt.setString(10, car_id);
            pstmt.setString(11, car_id);
            pstmt.setString(12, car_id);
            pstmt.setString(13, car_id);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCarHpCase_20090901]"+e);
			System.out.println("[EstiJuyoDatabase:getJuyoCarHpCase_20090901]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	모델별 주요차종 견적 이력 리스트
	 */
	public Vector getJuyoCarHpCase_20150112(String car_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select est_ssn, car_id, reg_dt, reg_code, set_code, "+
				"        max(car_seq) car_seq, max(car_amt) car_amt, max(opt) opt, max(opt_seq) opt_seq, max(opt_amt) opt_amt, max(o_1) o_1, max(dc_amt) dc_amt, max(ro_13) ro_13, "+
			    "        MAX(DECODE(a_a,'11',dc_amt)) dc_amt_1, MAX(DECODE(a_a,'21',dc_amt)) dc_amt_2, "+
			    "        MAX(DECODE(a_a,'11',dc)) dc_1, MAX(DECODE(a_a,'21',dc)) dc_2, "+
				"        max(agree_dist) agree_dist "+
			    " from   estimate_hp "+
			    " where  car_id=? and est_nm like '%36%_f%' and est_id not like 'EV%'"+
			    " group by est_ssn, car_id, reg_dt, reg_code, set_code \n"+
		        " ORDER BY est_ssn desc, reg_dt desc, reg_code desc";


		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString(1, car_id);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCarHpCase_20150112]"+e);
			System.out.println("[EstiJuyoDatabase:getJuyoCarHpCase_20150112]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

    /**
	 *	모델별 주요차종 견적 이력 리스트
	 */
	public Hashtable getJuyoCarHpCaseList_20150112(String reg_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT reg_code,  "+

				"        MAX(DECODE(est_nm,'rb60_f',ro_13))      rb60_ro_13, "+
				"        MAX(DECODE(est_nm,'rs60_f',ro_13))      rs60_ro_13, "+
				"        MAX(DECODE(est_nm,'lb60_f',ro_13))      lb60_ro_13, "+
				"        MAX(DECODE(est_nm,'ls60_f',ro_13))      ls60_ro_13, "+
				"        MAX(DECODE(est_nm,'lb602_f',ro_13))     lb602_ro_13, "+
				"        MAX(DECODE(est_nm,'ls602_f',ro_13))     ls602_ro_13, "+    
				"        MAX(DECODE(est_nm,'rb60_f',fee_s_amt))  rb60_amt, "+
				"        MAX(DECODE(est_nm,'rs60_f',fee_s_amt))  rs60_amt, "+
				"        MAX(DECODE(est_nm,'lb60_f',fee_s_amt))  lb60_amt, "+
				"        MAX(DECODE(est_nm,'ls60_f',fee_s_amt))  ls60_amt, "+
				"        MAX(DECODE(est_nm,'lb602_f',fee_s_amt)) lb602_amt, "+
				"        MAX(DECODE(est_nm,'ls602_f',fee_s_amt)) ls602_amt, "+
				"        MAX(DECODE(est_nm,'rb60_f',cls_per))    rb60_cls_per, "+
				"        MAX(DECODE(est_nm,'rs60_f',cls_per))    rs60_cls_per, "+
				"        MAX(DECODE(est_nm,'lb60_f',cls_per))    lb60_cls_per, "+
				"        MAX(DECODE(est_nm,'ls60_f',cls_per))    ls60_cls_per, "+
				"        MAX(DECODE(est_nm,'lb602_f',cls_per))   lb602_cls_per, "+
				"        MAX(DECODE(est_nm,'ls602_f',cls_per))   ls602_cls_per, "+

				"        MAX(DECODE(est_nm,'rb54_f',ro_13))      rb54_ro_13, "+
				"        MAX(DECODE(est_nm,'rs54_f',ro_13))      rs54_ro_13, "+
				"        MAX(DECODE(est_nm,'rb54_f',fee_s_amt))  rb54_amt, "+
				"        MAX(DECODE(est_nm,'rs54_f',fee_s_amt))  rs54_amt, "+
				"        MAX(DECODE(est_nm,'rb54_f',cls_per))    rb54_cls_per, "+
				"        MAX(DECODE(est_nm,'rs54_f',cls_per))    rs54_cls_per, "+
				
				"        MAX(DECODE(est_nm,'rb48_f',ro_13))      rb48_ro_13, "+
				"        MAX(DECODE(est_nm,'rs48_f',ro_13))      rs48_ro_13, "+
				"        MAX(DECODE(est_nm,'lb48_f',ro_13))      lb48_ro_13, "+
				"        MAX(DECODE(est_nm,'ls48_f',ro_13))      ls48_ro_13, "+
				"        MAX(DECODE(est_nm,'lb482_f',ro_13))     lb482_ro_13, "+
				"        MAX(DECODE(est_nm,'ls482_f',ro_13))     ls482_ro_13, "+    
				"        MAX(DECODE(est_nm,'rb48_f',fee_s_amt))  rb48_amt, "+
				"        MAX(DECODE(est_nm,'rs48_f',fee_s_amt))  rs48_amt, "+
				"        MAX(DECODE(est_nm,'lb48_f',fee_s_amt))  lb48_amt, "+
				"        MAX(DECODE(est_nm,'ls48_f',fee_s_amt))  ls48_amt, "+
				"        MAX(DECODE(est_nm,'lb482_f',fee_s_amt)) lb482_amt, "+
				"        MAX(DECODE(est_nm,'ls482_f',fee_s_amt)) ls482_amt, "+
				"        MAX(DECODE(est_nm,'rb48_f',cls_per))    rb48_cls_per, "+
				"        MAX(DECODE(est_nm,'rs48_f',cls_per))    rs48_cls_per, "+
				"        MAX(DECODE(est_nm,'lb48_f',cls_per))    lb48_cls_per, "+
				"        MAX(DECODE(est_nm,'ls48_f',cls_per))    ls48_cls_per, "+
				"        MAX(DECODE(est_nm,'lb482_f',cls_per))   lb482_cls_per, "+
				"        MAX(DECODE(est_nm,'ls482_f',cls_per))   ls482_cls_per, "+

				"        MAX(DECODE(est_nm,'rb36_f',ro_13))      rb36_ro_13, "+
				"        MAX(DECODE(est_nm,'rs36_f',ro_13))      rs36_ro_13, "+
				"        MAX(DECODE(est_nm,'lb36_f',ro_13))      lb36_ro_13, "+
				"        MAX(DECODE(est_nm,'ls36_f',ro_13))      ls36_ro_13, "+
				"        MAX(DECODE(est_nm,'lb362_f',ro_13))     lb362_ro_13, "+
				"        MAX(DECODE(est_nm,'ls362_f',ro_13))     ls362_ro_13, "+    
				"        MAX(DECODE(est_nm,'rb36_f',fee_s_amt))  rb36_amt, "+
				"        MAX(DECODE(est_nm,'rs36_f',fee_s_amt))  rs36_amt, "+
				"        MAX(DECODE(est_nm,'lb36_f',fee_s_amt))  lb36_amt, "+
				"        MAX(DECODE(est_nm,'ls36_f',fee_s_amt))  ls36_amt, "+
				"        MAX(DECODE(est_nm,'lb362_f',fee_s_amt)) lb362_amt, "+
				"        MAX(DECODE(est_nm,'ls362_f',fee_s_amt)) ls362_amt, "+
				"        MAX(DECODE(est_nm,'rb36_f',cls_per))    rb36_cls_per, "+
				"        MAX(DECODE(est_nm,'rs36_f',cls_per))    rs36_cls_per, "+
				"        MAX(DECODE(est_nm,'lb36_f',cls_per))    lb36_cls_per, "+
				"        MAX(DECODE(est_nm,'ls36_f',cls_per))    ls36_cls_per, "+
				"        MAX(DECODE(est_nm,'lb362_f',cls_per))   lb362_cls_per, "+
				"        MAX(DECODE(est_nm,'ls362_f',cls_per))   ls362_cls_per, "+
       
				"        MAX(DECODE(est_nm,'rb24_f',ro_13))      rb24_ro_13, "+
				"        MAX(DECODE(est_nm,'rs24_f',ro_13))      rs24_ro_13, "+
				"        MAX(DECODE(est_nm,'lb24_f',ro_13))      lb24_ro_13, "+
				"        MAX(DECODE(est_nm,'ls24_f',ro_13))      ls24_ro_13, "+
				"        MAX(DECODE(est_nm,'lb242_f',ro_13))     lb242_ro_13, "+
				"        MAX(DECODE(est_nm,'ls242_f',ro_13))     ls242_ro_13, "+    
				"        MAX(DECODE(est_nm,'rb24_f',fee_s_amt))  rb24_amt, "+
				"        MAX(DECODE(est_nm,'rs24_f',fee_s_amt))  rs24_amt, "+
				"        MAX(DECODE(est_nm,'lb24_f',fee_s_amt))  lb24_amt, "+
				"        MAX(DECODE(est_nm,'ls24_f',fee_s_amt))  ls24_amt, "+
				"        MAX(DECODE(est_nm,'lb242_f',fee_s_amt)) lb242_amt, "+
				"        MAX(DECODE(est_nm,'ls242_f',fee_s_amt)) ls242_amt, "+
				"        MAX(DECODE(est_nm,'rb24_f',cls_per))    rb24_cls_per, "+
				"        MAX(DECODE(est_nm,'rs24_f',cls_per))    rs24_cls_per, "+
				"        MAX(DECODE(est_nm,'lb24_f',cls_per))    lb24_cls_per, "+
				"        MAX(DECODE(est_nm,'ls24_f',cls_per))    ls24_cls_per, "+
				"        MAX(DECODE(est_nm,'lb242_f',cls_per))   lb242_cls_per, "+
				"        MAX(DECODE(est_nm,'ls242_f',cls_per))   ls242_cls_per, "+      
    
				"        MAX(DECODE(est_nm,'rb12_f',ro_13))      rb12_ro_13, "+
				"        MAX(DECODE(est_nm,'rs12_f',ro_13))      rs12_ro_13, "+
				"        MAX(DECODE(est_nm,'lb12_f',ro_13))      lb12_ro_13, "+
				"        MAX(DECODE(est_nm,'ls12_f',ro_13))      ls12_ro_13, "+
				"        MAX(DECODE(est_nm,'lb122_f',ro_13))     lb122_ro_13, "+
				"        MAX(DECODE(est_nm,'ls122_f',ro_13))     ls122_ro_13, "+    
				"        MAX(DECODE(est_nm,'rb12_f',fee_s_amt))  rb12_amt, "+
				"        MAX(DECODE(est_nm,'rs12_f',fee_s_amt))  rs12_amt, "+
				"        MAX(DECODE(est_nm,'lb12_f',fee_s_amt))  lb12_amt, "+
				"        MAX(DECODE(est_nm,'ls12_f',fee_s_amt))  ls12_amt, "+
				"        MAX(DECODE(est_nm,'lb122_f',fee_s_amt)) lb122_amt, "+
				"        MAX(DECODE(est_nm,'ls122_f',fee_s_amt)) ls122_amt, "+
				"        MAX(DECODE(est_nm,'rb12_f',cls_per))    rb12_cls_per, "+
				"        MAX(DECODE(est_nm,'rs12_f',cls_per))    rs12_cls_per, "+
				"        MAX(DECODE(est_nm,'lb12_f',cls_per))    lb12_cls_per, "+
				"        MAX(DECODE(est_nm,'ls12_f',cls_per))    ls12_cls_per, "+
				"        MAX(DECODE(est_nm,'lb122_f',cls_per))   lb122_cls_per, "+
				"        MAX(DECODE(est_nm,'ls122_f',cls_per))   ls122_cls_per, "+      
            
				"        COUNT(*) cnt "+
				" FROM   ESTIMATE_HP "+
				" WHERE  reg_code=? AND est_st='1' "+
				" GROUP BY reg_code";


		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString(1, reg_code);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCarHpCase_20150112]"+e);
			System.out.println("[EstiJuyoDatabase:getJuyoCarHpCase_20150112]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

    /**
	 *	주요차종 인기차량 리스트
	 */
	public Vector getJuyoHotCars() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select f.car_nm, e.car_name, e.auto_yn, e.diesel_yn, a.* \n"+
				" from \n"+
				"        ( select car_comp_id, car_cd, car_id, car_seq, \n"+
				"                 max(est_fax) est_fax, \n"+
				"                 max(o_1) o_1, \n"+
				"                 min(decode(est_nm,'rb48_f',fee_s_amt)) rb_fee_s_amt, \n"+
				"                 min(decode(est_nm,'rb48_f',est_id)) rb_est_id, \n"+
				"                 min(case when car_comp_id > '0005' then decode(est_nm,'lb482_f',fee_s_amt) else decode(est_nm,'lb48_f',fee_s_amt) end) lb_fee_s_amt, \n"+
				"                 min(case when car_comp_id > '0005' then decode(est_nm,'lb482_f',est_id) else decode(est_nm,'lb48_f',est_id) end) lb_est_id \n"+
				"          from   estimate_hp \n"+
				"          where  est_ssn='Y' and est_fax is not null and est_nm in ('rb48_f','lb48_f','lb482_f') \n"+
				"          group by car_comp_id, car_cd, car_id, car_seq "+
				"        ) a, \n"+
				"        car_nm e, car_mng f \n"+
				" where  a.car_id = e.car_id and a.car_seq = e.car_seq AND a.car_comp_id= f.car_comp_id and a.car_cd = f.code \n"+
				" order by a.est_fax  \n"+
				"	";
		
		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiJuyoDatabase:getJuyoHotCars]"+e);
			System.out.println("[EstiJuyoDatabase:getJuyoHotCars]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/**
     * 프로시져 호출
     */
    public String call_sp_esti_hp_upload() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_HP_UPLOAD}";


	    try{

			//주요차종 홈페이지적용 프로시저 호출
			cstmt = con.prepareCall(query1);		
			cstmt.execute();
			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_hp_upload]"+se);
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
	 *	주요차종 리스트-FMS
	 */
	public Vector getJuyoCars_201512(String code, String base_dt, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT \n"+
				"       a4.o82 as ro82, c4.o82 as lo82, a.reg_code, \n"+
				"       nvl(a.reg_dt,'') reg_dt, decode(a.rent_dt,to_char(sysdate,'YYYYMMDD'),'Y','N') rent_dt_st, \n"+
				"       a.est_id, a.est_tel seq, a.est_fax, a.car_comp_id, a.car_cd, a.car_id, a.car_seq, a.opt, f.car_nm, e.car_name, \n"+
				"       e.auto_yn, e.diesel_yn, (a.o_1+a.dc_amt+nvl(a.tax_dc_amt,0)) o_1, a.dc_amt, a.dc, a.spr_yn, a.print_type, \n"+ //리스트에서는 DC 반영전 차량가격을 보여준다
				"	    decode(h2.jg_s,'1',a.est_id,a.est_id) rb36_id,   decode(h2.jg_s,'1',a.fee_s_amt,a.fee_s_amt) rb36_amt,  \n"+
				"	    decode(h2.jg_s,'1',b.est_id,b.est_id) rs36_id,   decode(h2.jg_s,'1',b.fee_s_amt,b.fee_s_amt) rs36_amt,   \n"+
				"	    decode(h2.jg_s,'1',c.est_id,c.est_id) lb36_id,   decode(h2.jg_s,'1',c.fee_s_amt,c.fee_s_amt) lb36_amt,  \n"+
				"	    decode(h2.jg_s,'1',d.est_id,d.est_id) ls36_id,   decode(h2.jg_s,'1',d.fee_s_amt,d.fee_s_amt) ls36_amt,   \n"+
				"	    decode(h2.jg_s,'1',h.est_id,h.est_id) lb36_id2,  decode(h2.jg_s,'1',h.fee_s_amt,h.fee_s_amt) lb36_amt2,  \n"+
				"	    decode(h2.jg_s,'1',i.est_id,i.est_id) ls36_id2,  decode(h2.jg_s,'1',i.fee_s_amt,i.fee_s_amt) ls36_amt2,  \n"+
				"	    e.jg_code, e.use_yn, g.car_b_p as car_new_p, e.car_b, \n"+
				"	    (g.car_b_p-a.car_amt) cng_amt, decode(g.car_b_p,a.car_amt,decode(g.car_seq,a.car_seq,'-','변동'),'변동') cng_st,  \n"+
				"       h2.jg_t, h2.jg_a,  \n"+		
				"       mc.rb36_amt as mc_rb36_amt, "+
				"       mc.rs36_amt as mc_rs36_amt, "+
				"       mc.lb36_amt as mc_lb36_amt, "+
				"       mc.ls36_amt as mc_ls36_amt, "+
				"       mc.lb36_amt2 as mc_lb36_amt2, "+
				"       mc.ls36_amt2 as mc_ls36_amt2  "+
				" FROM  \n"+
				"       ESTIMATE_HP a, \n"+
		        "       (select est_tel, min(set_code||reg_code) reg_code, max(nvl(set_code,'0')) set_code from estimate_hp where nvl(est_ssn,'Y')='Y' GROUP BY est_tel) ma, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='rs36_f' and nvl(est_ssn,'Y')='Y')  b, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='lb36_f' and nvl(est_ssn,'Y')='Y')  c, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='ls36_f' and nvl(est_ssn,'Y')='Y')  d, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='lb362_f' and nvl(est_ssn,'Y')='Y') h, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='ls362_f' and nvl(est_ssn,'Y')='Y') i, \n"+
				"	    car_nm e, car_mng f,  \n"+
				"	    ( select car_comp_id, car_cd, car_id, car_seq, car_name, car_b_p, car_b_dt  \n"+
				"	   	  from car_nm  \n"+
				"	   	  where use_yn='Y' and (car_comp_id, car_cd, car_id, car_b_dt) in (select car_comp_id, car_cd, car_id, max(car_b_dt) car_b_dt from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id)  \n"+
				"	    ) g, \n"+
				"	    ( select sh_code, jg_a, nvl(jg_s,'0') jg_s, jg_t  \n"+
				"		  from esti_jg_var  \n"+
				"		  where (sh_code, seq) in (select sh_code, max(seq) from esti_jg_var group by sh_code)  \n"+
				"	    ) h2,  \n"+
				"       esti_exam_hp a3, esti_compare_hp a4, \n"+
				"       esti_exam_hp c3, esti_compare_hp c4, \n"+
				"       main_car mc "+

				" WHERE "+
				"       a.est_type='J' and nvl(a.est_ssn,'Y')='Y' and a.est_nm='rb36_f' AND a.est_tel IS NOT null    \n"+
                "       AND a.est_tel=ma.est_tel AND a.set_code||a.reg_code=ma.reg_code \n"+
                "       AND a.est_tel=b.est_tel(+) AND a.reg_code=b.reg_code(+) \n"+
                "       AND a.est_tel=c.est_tel(+) AND a.reg_code=c.reg_code(+) \n"+
                "       AND a.est_tel=d.est_tel(+) AND a.reg_code=d.reg_code(+) \n"+
                "       AND a.est_tel=h.est_tel(+) AND a.reg_code=h.reg_code(+) \n"+
                "       AND a.est_tel=i.est_tel(+) AND a.reg_code=i.reg_code(+) \n"+
				"       AND a.car_id = e.car_id and a.car_seq = e.car_seq AND a.car_comp_id= f.car_comp_id and a.car_cd = f.code  \n"+
				"       AND a.car_comp_id=g.car_comp_id(+) and a.car_cd=g.car_cd(+) and a.car_id=g.car_id(+)  \n"+
				"       AND e.jg_code=h2.sh_code  \n"+
				"       and a.est_id=a3.est_id  \n"+
				"       and a.est_id=a4.est_id  \n"+
				"       and c.est_id=c3.est_id  \n"+
				"       and c.est_id=c4.est_id  \n"+
				"       and a.est_tel=mc.seq(+) and a.agree_dist=mc.agree_dist(+) \n"+
				"	";
		

		if(code.equals("")){

		}else if(code.equals("0001")){
			query += " AND a.car_comp_id = '0001' ";
		}else if(code.equals("0002")){
			query += " AND a.car_comp_id = '0002' ";
		}else if(code.equals("0003")){
			query += " AND a.car_comp_id = '0003' ";
		}else if(code.equals("0004")){
			query += " AND a.car_comp_id = '0004' ";
		}else if(code.equals("0005")){
			query += " AND a.car_comp_id = '0005' ";
		}else if(code.equals("0007")){
			query += " AND a.car_comp_id = '0007' ";
		}else if(code.equals("0013")){
			query += " AND a.car_comp_id = '0013' ";
		}else if(code.equals("0027")){
			query += " AND a.car_comp_id = '0027' ";
		}else if(code.equals("0018")){
			query += " AND a.car_comp_id = '0018' ";
		}else if(code.equals("0044")){
			query += " AND a.car_comp_id = '0044' ";
		}else if(code.equals("0011")){
			query += " AND a.car_comp_id = '0011' ";
		}else if(code.equals("etc")){
			query += " AND a.car_comp_id > '0005' ";
		}else if(code.equals("hd_except")){
			query += " AND a.car_comp_id != '0001' ";
		}else{
			if(!code.equals("")){	
				query += " AND a.car_comp_id = '"+code+"' ";
			}
		}

		if(!t_wd.equals("")){
			query += " AND f.car_nm||e.car_name||a.rent_dt||e.s_st like '%"+t_wd+"%' ";
		}


		query += " ORDER BY to_number(a.est_tel) ";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCars_201512]"+e);
			System.out.println("[EstiJuyoDatabase:getJuyoCars_201512]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

















    /**
	 *	주요차종 리스트-FMS
	 */
	public Vector getJuyoCars_201905(String code, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT \n"+
				"       a4.o82 as ro82, c4.o82 as lo82, a.reg_code, \n"+
				"       nvl(a.reg_dt,'') reg_dt, decode(a.rent_dt,to_char(sysdate,'YYYYMMDD'),'Y','N') rent_dt_st, \n"+
				"       a.est_id, a.est_tel seq, a.est_fax, a.car_comp_id, a.car_cd, a.car_id, a.car_seq, a.opt, f.car_nm, e.car_name, \n"+
				"       e.auto_yn, e.diesel_yn, (a.o_1+a.dc_amt+nvl(a.tax_dc_amt,0)) o_1, a.dc_amt, a.dc, a.spr_yn, a.print_type, \n"+ //리스트에서는 DC 반영전 차량가격을 보여준다
				"	    decode(h2.jg_s,'1',a.est_id,a.est_id) rb36_id,   decode(h2.jg_s,'1',a.fee_s_amt,a.fee_s_amt) rb36_amt,  \n"+
				"	    decode(h2.jg_s,'1',b.est_id,b.est_id) rs36_id,   decode(h2.jg_s,'1',b.fee_s_amt,b.fee_s_amt) rs36_amt,   \n"+
				"	    decode(h2.jg_s,'1',c.est_id,c.est_id) lb36_id,   decode(h2.jg_s,'1',c.fee_s_amt,c.fee_s_amt) lb36_amt,  \n"+
				"	    decode(h2.jg_s,'1',d.est_id,d.est_id) ls36_id,   decode(h2.jg_s,'1',d.fee_s_amt,d.fee_s_amt) ls36_amt,   \n"+
				"	    decode(h2.jg_s,'1',h.est_id,h.est_id) lb36_id2,  decode(h2.jg_s,'1',h.fee_s_amt,h.fee_s_amt) lb36_amt2,  \n"+
				"	    decode(h2.jg_s,'1',i.est_id,i.est_id) ls36_id2,  decode(h2.jg_s,'1',i.fee_s_amt,i.fee_s_amt) ls36_amt2,  \n"+
				"	    e.jg_code, e.use_yn, g.car_b_p as car_new_p, e.car_b, \n"+
				"	    (g.car_b_p-a.car_amt) cng_amt, decode(g.car_b_p,a.car_amt,decode(g.car_seq,a.car_seq,'-','변동'),'변동') cng_st,  \n"+
				"       h2.jg_t, h2.jg_a,  \n"+		
				"       mc.rb36_amt as mc_rb36_amt, "+
				"       mc.rs36_amt as mc_rs36_amt, "+
				"       mc.lb36_amt as mc_lb36_amt, "+
				"       mc.ls36_amt as mc_ls36_amt, "+
				"       mc.lb36_amt2 as mc_lb36_amt2, "+
				"       mc.ls36_amt2 as mc_ls36_amt2  "+
				" FROM  \n"+
				"       ESTIMATE_HP a, \n"+
		        "       (select est_tel, min(set_code||reg_code) reg_code, max(nvl(set_code,'0')) set_code from estimate_hp where nvl(est_ssn,'Y')='Y' GROUP BY est_tel) ma, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='rs36_f' and nvl(est_ssn,'Y')='Y')  b, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='lb36_f' and nvl(est_ssn,'Y')='Y')  c, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='ls36_f' and nvl(est_ssn,'Y')='Y')  d, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='lb362_f' and nvl(est_ssn,'Y')='Y') h, \n"+
		        "       (SELECT * FROM ESTIMATE_HP WHERE est_nm='ls362_f' and nvl(est_ssn,'Y')='Y') i, \n"+
				"	    car_nm e, car_mng f,  \n"+
				"	    ( select car_comp_id, car_cd, car_id, car_seq, car_name, car_b_p, car_b_dt  \n"+
				"	   	  from car_nm  \n"+
				"	   	  where use_yn='Y' and (car_comp_id, car_cd, car_id, car_b_dt) in (select car_comp_id, car_cd, car_id, max(car_b_dt) car_b_dt from car_nm where use_yn='Y' group by car_comp_id, car_cd, car_id)  \n"+
				"	    ) g, \n"+
				"	    ( select sh_code, jg_a, nvl(jg_s,'0') jg_s, jg_t  \n"+
				"		  from esti_jg_var  \n"+
				"		  where (sh_code, seq) in (select sh_code, max(seq) from esti_jg_var group by sh_code)  \n"+
				"	    ) h2,  \n"+
				"       esti_exam_hp a3, esti_compare_hp a4, \n"+
				"       esti_exam_hp c3, esti_compare_hp c4, \n"+
				"       main_car mc "+

				" WHERE "+
				"       a.est_type='J' and nvl(a.est_ssn,'Y')='Y' and a.est_nm='rb36_f' AND a.est_tel IS NOT null    \n"+
                "       AND a.est_tel=ma.est_tel AND a.set_code||a.reg_code=ma.reg_code \n"+ //최소 reg_code => 약정주행거리 20000
                "       AND a.est_tel=b.est_tel(+) AND a.reg_code=b.reg_code(+) \n"+
                "       AND a.est_tel=c.est_tel(+) AND a.reg_code=c.reg_code(+) \n"+
                "       AND a.est_tel=d.est_tel(+) AND a.reg_code=d.reg_code(+) \n"+
                "       AND a.est_tel=h.est_tel(+) AND a.reg_code=h.reg_code(+) \n"+
                "       AND a.est_tel=i.est_tel(+) AND a.reg_code=i.reg_code(+) \n"+
				"       AND a.car_id = e.car_id and a.car_seq = e.car_seq AND a.car_comp_id= f.car_comp_id and a.car_cd = f.code  \n"+
				"       AND a.car_comp_id=g.car_comp_id(+) and a.car_cd=g.car_cd(+) and a.car_id=g.car_id(+)  \n"+
				"       AND e.jg_code=h2.sh_code  \n"+
				"       and a.est_id=a3.est_id  \n"+
				"       and a.est_id=a4.est_id  \n"+
				"       and c.est_id=c3.est_id  \n"+
				"       and c.est_id=c4.est_id  \n"+
				"       and a.est_tel=mc.seq(+) and a.agree_dist=mc.agree_dist(+) \n"+
				"	";
		

		if(code.equals("")){

		}else if(code.equals("0001")){
			query += " AND a.car_comp_id = '0001' ";
		}else if(code.equals("0002")){
			query += " AND a.car_comp_id = '0002' ";
		}else if(code.equals("0003")){
			query += " AND a.car_comp_id = '0003' ";
		}else if(code.equals("0004")){
			query += " AND a.car_comp_id = '0004' ";
		}else if(code.equals("0005")){
			query += " AND a.car_comp_id = '0005' ";
		}else if(code.equals("0007")){
			query += " AND a.car_comp_id = '0007' ";
		}else if(code.equals("0013")){
			query += " AND a.car_comp_id = '0013' ";
		}else if(code.equals("0027")){
			query += " AND a.car_comp_id = '0027' ";
		}else if(code.equals("0018")){
			query += " AND a.car_comp_id = '0018' ";
		}else if(code.equals("0044")){
			query += " AND a.car_comp_id = '0044' ";
		}else if(code.equals("0011")){
			query += " AND a.car_comp_id = '0011' ";
		}else if(code.equals("etc")){
			query += " AND a.car_comp_id > '0005' ";
		}else if(code.equals("hd_except")){
			query += " AND a.car_comp_id != '0001' ";
		}else{
			if(!code.equals("")){	
				query += " AND a.car_comp_id = '"+code+"' ";
			}
		}

		if(!t_wd.equals("")){
			query += " AND f.car_nm||e.car_name||a.rent_dt||e.s_st like '%"+t_wd+"%' ";
		}


		query += " ORDER BY to_number(a.est_tel) ";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiJuyoDatabase:getJuyoCars_201905]"+e);
			System.out.println("[EstiJuyoDatabase:getJuyoCars_201905]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	
}
