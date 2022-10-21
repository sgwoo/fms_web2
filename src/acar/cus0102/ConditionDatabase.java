package acar.cus0102;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class ConditionDatabase
{
	private static ConditionDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
	//public static synchronized ConditionDatabase getInstance() throws DatabaseException {
		public static synchronized ConditionDatabase getInstance() {
        if (instance == null)
            instance = new ConditionDatabase();
        return instance;
    }
    
    //private ConditionDatabase() throws DatabaseException {
    	private ConditionDatabase()  {
        connMgr = DBConnectionManager.getInstance();
    }
	
	/**
	 * 현황 통계- 등록, 미등록, 출고, 미출고
	 * - 20030827 렌트리스별일반식맟춤식기본식 수정
     */
    public String [] getRegCondSta(String gubun,String dt,String ref_dt1,String ref_dt2,String br_id,String fn_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String val [] = new String[14];
		String sub_query = "";
        String dt_query = "";
        String sub_query2 = "";
        String strfn = "";
        
        String query = "";
        
        /* 등록(4), 미등록, 출고(2), 미출고(1)*/
        if(gubun.equals("1")){
        	if(dt.equals("1")){
	        	sub_query = "and a.car_mng_id is null and a.dlv_dt is null \n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.car_mng_id is null and a.dlv_dt is null \n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.car_mng_id is null and a.dlv_dt is null \n";
	        }
        }else if(gubun.equals("2")){
        	if(dt.equals("1")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt=to_char(sysdate,'YYYYMMDD')\n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt like to_char(sysdate,'YYYYMM')||'%' \n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt between '" + ref_dt1 + "' and '" + ref_dt2 + "'\n";
	        }
        }else if(gubun.equals("3")){
        	if(dt.equals("1")){
	        	sub_query = "and a.car_mng_id is null \n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.car_mng_id is null \n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.car_mng_id is null \n";
	        }
        }else if(gubun.equals("4")){
        	if(dt.equals("1")){
	        	sub_query = "and a.car_mng_id is not null and b.init_reg_dt=to_char(sysdate,'YYYYMMDD')\n";
	        }else if(dt.equals("2")){        
	        	sub_query = "and a.car_mng_id is not null and b.init_reg_dt like to_char(sysdate,'YYYYMM')||'%' \n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.car_mng_id is not null and b.init_reg_dt between " + ref_dt1 + " and " + ref_dt2 + "\n";
	        }
        }else{
        	query = "";
        }
        
        if (!fn_id.equals("0")) {
        	strfn=fn_id.substring(1);
        	if (fn_id.substring(0,1) == "1") { 
        		sub_query2="and c.firm_nm like '%" + strfn + "%' ";
        	}else {
        		sub_query2="and h.car_name like '%" + strfn + "%' ";
        	}
        }
        
        query = "select nvl(sum(decode(n.rent_way,'1',1,0)),0) as rent_way1, "
			+ " nvl(sum(decode(n.rent_way,'2',1,0)),0) as rent_way2, "
			+ " nvl(sum(decode(n.rent_way,'3',1,0)),0) as rent_way3, "
			+ " nvl(sum(decode(o.rent_way,'1',1,0)),0) as rent_way4, "
			+ " nvl(sum(decode(o.rent_way,'2',1,0)),0) as rent_way5, "
			+ " nvl(sum(decode(o.rent_way,'3',1,0)),0) as rent_way6, "
		+ " nvl(sum(decode(d.con_mon,'12',1,0)),0) as con_mon_12,nvl(sum(decode(d.con_mon,'24',1,0)),0) as con_mon_24,nvl(sum(decode(d.con_mon,'36',1,0)),0) as con_mon_36,nvl(sum(decode(d.con_mon,'48',1,0)),0) as con_mon_48,nvl(sum(decode(d.con_mon,'12',0,'24',0,'36',0,'48',0,1)),0) as con_mon_etc,nvl(sum(fee_s_amt),0) as fee_s_amt,nvl(sum(fee_v_amt),0) as fee_v_amt,nvl(sum(fee_s_amt)+sum(fee_v_amt),0) as to_fee_amt\n"
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h,\n"//--, code j
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
		+ "from commi a, car_off_emp b, car_off c \n"
		+ "where a.agnt_st='1'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) k,\n" 
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel\n"
		+ "from commi a, car_off_emp b, car_off c\n" 
		+ "where a.agnt_st='2'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) l,\n"
		+ "(select code,nm\n"
		+ "from code\n"
		+ "where c_st = '0003'\n"
		+ "and code <> '0000') m\n"
		+ ", (select a.rent_mng_id, a.rent_l_cd, d.rent_way from cont a, fee d, car_reg b where a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and a.car_mng_id = b.car_mng_id(+) "+ sub_query +" and a.car_st = '1' ) n "
		+ ", (select a.rent_mng_id, a.rent_l_cd, d.rent_way from cont a, fee d, car_reg b where a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and a.car_mng_id = b.car_mng_id(+) "+ sub_query +" and a.car_st = '3') o "
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.car_gu='1' and a.brch_id like '%" + br_id + "'\n"
		+ sub_query2
		+ sub_query
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = n.rent_mng_id(+) and a.rent_l_cd = n.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = o.rent_mng_id(+) and a.rent_l_cd = o.rent_l_cd(+)\n"
		+ "and i.cpt_cd = m.code(+)\n";
		
        Collection col = new ArrayList();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){
                val [0] = rs.getString(1);
                val [1] = rs.getString(2);
                val [2] = rs.getString(3);
                val [3] = rs.getString(4);
                val [4] = rs.getString(5);
                val [5] = rs.getString(6);
                val [6] = rs.getString(7);
                val [7] = rs.getString(8);
                val [8] = rs.getString(9);
                val [9] = rs.getString(10);
                val [10] = rs.getString(11);
				val [11] = rs.getString(12);
				val [12] = rs.getString(13);
				val [13] = rs.getString(14);
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
        return val;
    }

}