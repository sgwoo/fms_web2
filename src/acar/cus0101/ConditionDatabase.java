package acar.cus0101;

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
     * 계약현황 통계	- /acar/cus0101/cus0101_s_sc.jsp
	 * - 2003.11.13. 목. 렌트리스별일반식맟춤식기본식 수정
     */
    public String [] getRentCondSta(String dt,String ref_dt1,String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String val [] = new String[14];
		String sub_query = "";
         
        String query = "";
        
        /* 기간 */       
        if(dt.equals("1")){			//당월
        	sub_query = "and a.rent_dt like to_char(sysdate,'YYYYMM')||'%' \n";
        }else if(dt.equals("2")){	//당일
			sub_query = "and a.rent_dt=to_char(sysdate,'YYYYMMDD')\n";        	
        }else if(dt.equals("4")){	//기간
        	sub_query = "and a.rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
        }else{
        	sub_query = "";
        }
        
        query = "select nvl(sum(decode(n.rent_way,'1',1,0)),0) as rent_way1,"+
				" nvl(sum(decode(n.rent_way,'2',1,0)),0) as rent_way2,"+
				" nvl(sum(decode(n.rent_way,'3',1,0)),0) as rent_way3,"+
				" nvl(sum(decode(o.rent_way,'1',1,0)),0) as rent_way4,"+
				" nvl(sum(decode(o.rent_way,'2',1,0)),0) as rent_way5,"+
				" nvl(sum(decode(o.rent_way,'3',1,0)),0) as rent_way6,"+
				" nvl(sum(decode(d.con_mon,'12',1,0)),0) as con_mon_12,nvl(sum(decode(d.con_mon,'24',1,0)),0) as con_mon_24,nvl(sum(decode(d.con_mon,'36',1,0)),0) as con_mon_36,nvl(sum(decode(d.con_mon,'48',1,0)),0) as con_mon_48,nvl(sum(decode(d.con_mon,'12',0,'24',0,'36',0,'48',0,1)),0) as con_mon_etc, nvl(sum(fee_s_amt),0) as fee_s_amt,nvl(sum(fee_v_amt),0) as fee_v_amt,nvl(sum(fee_s_amt)+sum(fee_v_amt),0) as to_fee_amt\n"
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
		+ ", (select a.rent_mng_id, a.rent_l_cd, b.rent_way from cont a, fee b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+ sub_query +" and a.car_st = '1' ) n "
		+ ", (select a.rent_mng_id, a.rent_l_cd, b.rent_way from cont a, fee b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+ sub_query +" and a.car_st = '3') o "
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.brch_id like '%'\n"
		+ sub_query
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = n.rent_mng_id(+) and a.rent_l_cd = n.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = o.rent_mng_id(+) and a.rent_l_cd = o.rent_l_cd(+)\n"
		+ "and i.cpt_cd = m.code(+)\n";

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

    /**
     * 계약 현황 조회	 -/acar/cus0101/cus0101_s_sc_in.jsp
     */
    public ConditionBean [] getRentCondAll(String dt,String ref_dt1,String ref_dt2,String car_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
		String car_stQuery = "";
        
        String query = "";
         /* 기간 */       
        if(dt.equals("1")){			//당월
        	sub_query = "and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        }else if(dt.equals("2")){	//당일
			sub_query = "and a.rent_dt=to_char(sysdate,'YYYYMMDD')\n";        	
        }else if(dt.equals("4")){	//기간
        	sub_query = "and a.rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
        }else{
        	sub_query = "";
		}

		if(car_st.equals("13")){
			car_stQuery = " and a.car_st in ('1','3') ";
		}else if(car_st.equals("2")){
			car_stQuery = " and a.car_st = '2' ";
		}

        
        query = "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME,\n"//
		+ "k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL,\n"
		+ "i.cpt_cd as CPT_CD,m.nm as BANK_NM\n"
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
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.brch_id like '%'\n"
		+ sub_query
		+ car_stQuery
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and i.cpt_cd = m.code(+) "

		+ "order by b.init_reg_dt, a.dlv_dt, a.rent_dt, c.firm_nm\n";
		
        Collection<ConditionBean> col = new ArrayList<ConditionBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeConditionBean(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 System.out.println(se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (ConditionBean[])col.toArray(new ConditionBean[0]);
    }

	/**
     * 현황 리스트	-	this.getRentCondAll
     */
    private ConditionBean makeConditionBean(ResultSet results) throws DatabaseException {

        try {
            ConditionBean bean = new ConditionBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));					//계약관리ID
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//계약코드
		    bean.setRent_dt(results.getString("RENT_DT"));					//계약일자
		    bean.setDlv_dt(results.getString("DLV_DT"));					//출고일자
		    bean.setDlv_est_dt(results.getString("DLV_EST_DT"));
		    bean.setClient_id(results.getString("CLIENT_ID"));					//고객ID
		    bean.setClient_nm(results.getString("CLIENT_NM"));					//고객 대표자명
		    bean.setBus_id(results.getString("BUS_ID"));
		    bean.setBus_nm(results.getString("BUS_NM"));
		    bean.setFirm_nm(results.getString("FIRM_NM"));						//상호
		    bean.setO_tel(results.getString("O_TEL"));						//사무실전화
		    bean.setFax(results.getString("FAX"));						//FAX
		    bean.setBr_id(results.getString("BR_ID"));						//
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));					//자동차관리ID
		    bean.setInit_reg_dt(results.getString("INIT_REG_DT"));					//최초등록일
		    bean.setReg_gubun(results.getString("REG_GUBUN"));					//최초등록일
		    bean.setCar_no(results.getString("CAR_NO"));						//차량번호
		    bean.setCar_num(results.getString("CAR_NUM"));						//차대번호
		    bean.setR_st(results.getString("R_ST"));
		    bean.setRent_way(results.getString("RENT_WAY"));					//대여방식
		    bean.setCon_mon(results.getString("CON_MON"));						//대여개월
		    bean.setCar_id(results.getString("CAR_ID"));						//차명ID
		    bean.setImm_amt(results.getInt("IMM_AMT"));						//자차면책금
		    bean.setCar_name(results.getString("CAR_NAME"));					//차명
		    bean.setRent_start_dt(results.getString("RENT_START_DT"));				//대여개시일
		    bean.setRent_end_dt(results.getString("RENT_END_DT"));					//대여종료일
		    bean.setReg_ext_dt(results.getString("REG_EXT_DT"));					//등록예정일
		    bean.setRpt_no(results.getString("RPT_NO"));						//계출번호
		    bean.setCpt_cd(results.getString("CPT_CD"));						//은행코드
		    bean.setBank_nm(results.getString("BANK_NM"));						//은행명
		    bean.setIn_emp_id(results.getString("IN_EMP_ID"));
		    bean.setIn_emp_nm(results.getString("IN_EMP_NM"));
		    //bean.setIn_car_off_id(results.getString("IN_CAR_OFF_ID"));
		    bean.setIn_car_off_nm(results.getString("IN_CAR_OFF_NM"));
		    bean.setIn_car_off_tel(results.getString("IN_CAR_OFF_TEL"));
		    bean.setOut_emp_id(results.getString("OUT_EMP_ID"));
		    bean.setOut_emp_nm(results.getString("OUT_EMP_NM"));
		    //bean.setOut_car_off_id(results.getString("OUT_CAR_OFF_ID"));
		    bean.setOut_car_off_nm(results.getString("OUT_CAR_OFF_NM"));
		    bean.setOut_car_off_tel(results.getString("OUT_CAR_OFF_TEL"));
			//bean.setCls_dt(results.getString("CLS_DT"));
		    
            return bean;
        }catch (SQLException e) {
			System.out.println(e);
            throw new DatabaseException(e.getMessage());
        }

	}

}