package acar.condition;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Hashtable;
import java.util.Vector;

import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
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
	 * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	
	/**
     * 현황 리스트 ( 2001/12/28 ) - Kim JungTae
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
			bean.setCar_jnm(results.getString("CAR_JNM"));					//차종명
		    bean.setCar_name(results.getString("CAR_NAME"));					//차명
		    bean.setRent_start_dt(results.getString("RENT_START_DT"));				//대여개시일
		    bean.setRent_end_dt(results.getString("RENT_END_DT"));					//대여종료일
		    bean.setReg_ext_dt(results.getString("REG_EXT_DT"));					//등록예정일
		    bean.setRpt_no(results.getString("RPT_NO"));						//계출번호
		    bean.setCpt_cd(results.getString("CPT_CD"));						//은행코드
		    bean.setBank_nm(results.getString("BANK_NM"));						//은행명
		    bean.setIn_emp_id(results.getString("IN_EMP_ID"));
		    bean.setIn_emp_nm(results.getString("IN_EMP_NM"));
		    bean.setIn_car_off_nm(results.getString("IN_CAR_OFF_NM"));
		    bean.setIn_car_off_tel(results.getString("IN_CAR_OFF_TEL"));
		    bean.setOut_emp_id(results.getString("OUT_EMP_ID"));
		    bean.setOut_emp_nm(results.getString("OUT_EMP_NM"));
		    bean.setOut_car_off_nm(results.getString("OUT_CAR_OFF_NM"));
		    bean.setOut_car_off_tel(results.getString("OUT_CAR_OFF_TEL"));
		    bean.setOut_car_off_fax(results.getString("OUT_CAR_OFF_FAX"));		//출고영업소 팩스번호 추가(2017.12.07)
		    bean.setBus_st(results.getString("BUS_ST"));
		    bean.setEmp_nm(results.getString("EMP_NM"));
		    bean.setPur_pay_dt(results.getString("PUR_PAY_DT"));
		    bean.setCar_ext(results.getString("CAR_EXT"));
			bean.setDelay_cont(results.getString("delay_cont"));
			bean.setPur_req_dt(results.getString("PUR_REQ_DT"));

			bean.setCar_off_name1(results.getString("CAR_OFF_NAME1"));
			bean.setCar_off_name2(results.getString("CAR_OFF_NAME2"));
			bean.setEngine_nm(results.getString("ENGINE_NM"));
			
			bean.setMaint_st_dt(results.getString("MAINT_ST_DT"));
			bean.setMaint_end_dt(results.getString("MAINT_END_DT"));
			bean.setCar_end_dt(results.getString("CAR_END_DT"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 지점통계 ( 2001/12/28 ) - Kim JungTae
     */
    private BranchCondBean makeBranchCondBean(ResultSet results) throws DatabaseException {

        try {
            BranchCondBean bean = new BranchCondBean();
		   
		    bean.setBr_id(results.getString("BR_ID"));
		    bean.setBr_nm(results.getString("BR_NM"));
		    bean.setCont_cnt(results.getInt("CONT_CNT"));
		    bean.setRent_way_s(results.getInt("RENT_WAY_S"));
		    bean.setRent_way_m(results.getInt("RENT_WAY_M"));
		    bean.setRent_way_b(results.getInt("RENT_WAY_B"));
		    bean.setCon_mon_12(results.getInt("CON_MON_12"));
		    bean.setCon_mon_24(results.getInt("CON_MON_24"));
		    bean.setCon_mon_36(results.getInt("CON_MON_36"));
		    bean.setCon_mon_48(results.getInt("CON_MON_48"));
		    bean.setCon_mon_etc(results.getInt("CON_MON_ETC"));
		    bean.setUn_dlv_cnt(results.getInt("UN_DLV_CNT"));
		    bean.setDlv_cnt(results.getInt("DLV_CNT"));
		    bean.setUn_reg_cnt(results.getInt("UN_REG_CNT"));
		    bean.setReg_cnt(results.getInt("REG_CNT"));						
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 중도해지 현황 리스트 ( 2001/12/28 ) - Kim JungTae
     */
    private ClsCondBean makeClsCondBean(ResultSet results) throws DatabaseException {

        try {
            ClsCondBean bean = new ClsCondBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));				//계약관리ID
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//계약코드
		    bean.setClient_id(results.getString("CLIENT_ID"));
		    bean.setClient_nm(results.getString("CLIENT_NM"));
		    bean.setFirm_nm(results.getString("FIRM_NM"));
		    bean.setCar_no(results.getString("CAR_NO"));
		    bean.setCls_st(results.getString("CLS_ST"));
		    bean.setTerm_yn(results.getString("TERM_YN"));
		    bean.setCls_dt(results.getString("CLS_DT"));
		    bean.setReg_id(results.getString("REG_ID"));
		    bean.setReg_nm(results.getString("REG_NM"));
		    bean.setCls_cau(results.getString("CLS_CAU"));
			bean.setCar_name(results.getString("CAR_NAME"));
		    		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}
	/**
     * 중도해지 현황 리스트
     */
    private ClsCondBean makeClsCondBean2(ResultSet results) throws DatabaseException {

        try {
            ClsCondBean bean = new ClsCondBean();

		    bean.setCls_st(results.getString("CLS_ST"));
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//계약코드
		    bean.setFirm_nm(results.getString("FIRM_NM"));
		    bean.setClient_nm(results.getString("CLIENT_NM"));
		    bean.setCls_dt(results.getString("CLS_DT"));
		    bean.setCls_cau(results.getString("CLS_CAU"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_name(results.getString("CAR_NM"));
		    bean.setReg_nm(results.getString("USER_NM"));	    		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
     * 등록 현황 조회 ( 2002/1/3 ) - Kim JungTae
     */
    public ConditionBean [] getRegCondAll(String gubun,String dt,String ref_dt1,String ref_dt2,String br_id, String fn_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        String sub_query1 = "";
        String sub_query2 = "";
        String dt_query = "";
        String strfn= "";
        String strfd = "";
        String query = "";
        
		/* 등록, 미등록, 출고, 미출고*/
       
        if(gubun.equals("1")){
        	if(dt.equals("1")){
	        	sub_query = "and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt,\n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt,\n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt,\n";
	        }
        }else if(gubun.equals("2")){
        	if(dt.equals("1")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt=to_char(sysdate,'YYYYMMDD')\n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt like to_char(sysdate,'YYYYMM')||'%'\n";
			}else if(dt.equals("4")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%'\n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
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
	        	sub_query = "and a.car_mng_id is not null and b.init_reg_dt like to_char(sysdate,'YYYYMM')||'%'\n";
	        }else if(dt.equals("4")){
	        	sub_query = "and a.car_mng_id is not null and b.init_reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%'\n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.car_mng_id is not null and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
	        }
        }else{
        	query = "";
        }
               
        if (!fn_id.equals("0")) {
        	strfn=fn_id.substring(1);
        	strfd=fn_id.substring(0,1);
        	if (strfd.equals("1")) { 
        		sub_query2="and c.firm_nm like '%" + strfn + "%' ";
        	}else {
        		sub_query2="and h.car_name like '%" + strfn + "%' ";
        	}
        }
        
              
        
        
        query = "select a.bus_st, '' emp_nm, '' as car_off_name1, '' as car_off_name2, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
      		+ "         nvl(ec.nm,ec2.nm) car_ext, \n" 
			+ "         c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
			+ "         b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "         d.rent_st as R_ST, d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "         decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
			+ "         g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, o.car_nm as CAR_JNM,\n"//
			+ "         k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.15)
			+ "         i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT, \n"
			+ "         f.delay_cont, f.pur_req_dt, decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
			+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt \n"
			+ "  from   cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng o,\n"//--, code j
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n"
			+ "           where a.agnt_st='1'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) k,\n" 
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n" 
			+ "           where a.agnt_st='2'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) l,\n"
			+ "         ( select code,nm\n"
			+ "           from code\n"
			+ "           where c_st = '0003'\n"
			+ "           and code <> '0000' "
			+ "         ) m,\n"
			+ "         (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) p, "
			+ "         (select * from code where c_st='0032') ec, "
			+ "         (select * from code where c_st='0032') ec2 "
			+ "where    a.rent_mng_id like '%'\n"
			+ "         and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.car_gu='1' and a.brch_id like '%" + br_id + "'\n"
			+ sub_query2
			+ sub_query
			+ "         and a.car_mng_id = b.car_mng_id(+)\n"
			+ "         and a.client_id = c.client_id\n"
			+ "         and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "         and a.bus_id = e.user_id\n"
			+ "         and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "         and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=o.car_comp_id(+) and h.car_cd=o.code(+)\n"
			+ "         and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+)\n"
			+ "         and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
			+ "         and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "         and i.cpt_cd = m.code(+) "
			+ "         and d.rent_mng_id = p.rent_mng_id and d.rent_l_cd = p.rent_l_cd and d.rent_st=p.rent_st\n"
			+ "         and b.car_ext = ec.nm_cd(+)\n"
			+ "         and g.car_ext = ec2.nm_cd(+)\n"
			+ "order by \n"
			+ sub_query1
			+ "         b.init_reg_dt, d.rent_start_dt, c.firm_nm\n";

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

    // 중고차포함 - 20161226
    public ConditionBean [] getRegCondAll1(String gubun,String dt,String ref_dt1,String ref_dt2,String br_id, String fn_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        String sub_query1 = "";
        String sub_query2 = "";
        String dt_query = "";
        String strfn= "";
        String strfd = "";
        String query = "";
        
		/* 등록, 미등록, 출고, 미출고*/   
    
      	if(dt.equals("1")){
        	sub_query   = "and a.car_mng_id is not null and   b.init_reg_dt=to_char(sysdate,'YYYYMMDD')   \n";
        	sub_query1  = "and a.car_mng_id is not null and   b.acq_ex_dt=to_char(sysdate,'YYYYMMDD')   \n";
        }else if(dt.equals("2")){
        	sub_query   = " and a.car_mng_id is not null and  b.init_reg_dt like to_char(sysdate,'YYYYMM')||'%'  \n";
        	sub_query1  = " and a.car_mng_id is not null and  b.acq_ex_dt like to_char(sysdate,'YYYYMM')||'%'  \n";       
        }else if(dt.equals("4")){
        	sub_query   = "and a.car_mng_id is not null and b.init_reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%'\n";
        	sub_query1  = "and a.car_mng_id is not null and b.acq_ex_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%'\n";
        }else if(dt.equals("3")){
        	sub_query   = "and a.car_mng_id is not null and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
        	sub_query1  = "and a.car_mng_id is not null and b.acq_ex_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
       }
           
        query = "select '1' car_off_name1, b.car_use, a.bus_st, '' emp_nm,  '' as car_off_name2, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
			+ "         nvl(ec.nm,ec2.nm) car_ext, \n" 
			+ "         c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
			+ "         b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "         d.rent_st as R_ST, d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "         decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
			+ "         g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, o.car_nm as CAR_JNM,\n"//
			+ "         k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.07)
			+ "         i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT, \n"
			+ "         f.delay_cont, f.pur_req_dt, decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
			+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt \n"						
			+ "  from   cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng o, \n"	
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n"
			+ "           where a.agnt_st='1'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) k,\n" 
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm, c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n" 
			+ "           where a.agnt_st='2'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) l,\n"
			+ "         ( select code,nm\n"
			+ "           from code\n"
			+ "           where c_st = '0003'\n"
			+ "           and code <> '0000' "
			+ "         ) m,\n"
			+ "         (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) p, "
			+ "         (select * from code where c_st='0032') ec, "
			+ "         (select * from code WHERE c_st='0032') ec2 "
			+ "where    nvl(a.use_yn,'Y')='Y' and a.car_gu='1' and a.brch_id like '%" + br_id + "'\n"
			+ sub_query
			+ "         and a.car_mng_id = b.car_mng_id(+)\n"
			+ "         and a.client_id = c.client_id \n"
			+ "         and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "         and a.bus_id = e.user_id\n"
			+ "         and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "         and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=o.car_comp_id(+) and h.car_cd=o.code(+)\n"
			+ "         and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+)\n"
			+ "         and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
			+ "         and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "         and i.cpt_cd = m.code(+) "
			+ "         and d.rent_mng_id = p.rent_mng_id and d.rent_l_cd = p.rent_l_cd and d.rent_st=p.rent_st\n"			
			+ "         and b.car_ext = ec.nm_cd(+)\n"
			+ "         and g.car_ext = ec2.nm_cd(+)\n"	
			+ " union all \n"			
			+ "	select '9' car_off_name1, b.car_use, a.bus_st, '' emp_nm,  '' as car_off_name2, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, \n"
			+ "         substr(co.sh_base_dt,1,4)||'-'||substr(co.sh_base_dt,5,2)||'-'||substr(co.sh_base_dt,7,2) as DLV_DT, \n"
			+ "         a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
      		+ "         nvl(ec.nm,ec2.nm) car_ext, \n" 
			+ "         c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
			+ "         b.car_mng_id as CAR_MNG_ID, \n"
			+ "         substr(b.acq_ex_dt,1,4)||'-'||substr(b.acq_ex_dt,5,2)||'-'||substr(b.acq_ex_dt,7,2) as INIT_REG_DT, \n"
			+ "         decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "         d.rent_st as R_ST, d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "         decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
			+ "         g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, o.car_nm as CAR_JNM,\n"//
			+ "         k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.07)
			+ "         i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT, \n"
			+ "         f.delay_cont, f.pur_req_dt, decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
			+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt \n"			
			+ "  from   cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng o, \n"
			+ "        ( select rent_mng_id, rent_l_cd, sh_base_dt from commi  where agnt_st = '6' ) co , \n"
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n"
			+ "           where a.agnt_st='5'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) k,\n" 
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n" 
			+ "           where a.agnt_st='6'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) l,\n"
			+ "         ( select code,nm\n"
			+ "           from code\n"
			+ "           where c_st = '0003'\n"
			+ "           and code <> '0000' "
			+ "         ) m,\n"
			+ "         (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) p, "
			+ "         (select * from code where c_st='0032') ec, "
			+ "         (select * from code WHERE c_st='0032') ec2 "
			+ "where    a.rent_mng_id = co.rent_mng_id and a.rent_l_cd = co.rent_l_cd \n"
			+ "         and a.car_gu='2' and a.brch_id like '%" + br_id + "'\n"
			+ sub_query1
			+ "         and a.car_mng_id = b.car_mng_id(+)\n"
			+ "         and a.client_id = c.client_id \n"
			+ "         and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "         and a.bus_id = e.user_id\n"
			+ "         and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "         and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=o.car_comp_id(+) and h.car_cd=o.code(+)\n"
			+ "         and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+)\n"
			+ "         and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
			+ "         and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "         and i.cpt_cd = m.code(+) "
			+ "         and d.rent_mng_id = p.rent_mng_id and d.rent_l_cd = p.rent_l_cd and d.rent_st=p.rent_st\n"
			+ "         and b.car_ext = ec.nm_cd(+)\n"
			+ "         and g.car_ext = ec2.nm_cd(+)\n"
			+ "order by \n"
			+ "           1 asc, init_reg_dt, 2, car_no, rent_start_dt \n";


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

    // 중고차포함 - 20161226
    public ConditionBean [] getRegCondAll1(String gubun,String dt,String ref_dt1,String ref_dt2,String br_id, String fn_id, String sort) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        String sub_query1 = "";
        String sub_query2 = "";
        String dt_query = "";
        String strfn= "";
        String strfd = "";
        String query = "";
        
      	if(dt.equals("1")){
        	sub_query  = "and b.init_reg_dt=to_char(sysdate,'YYYYMMDD')   \n";
        	sub_query1 = "and b.acq_ex_dt=to_char(sysdate,'YYYYMMDD')   \n";
        }else if(dt.equals("2")){
        	sub_query  = " and b.init_reg_dt like to_char(sysdate,'YYYYMM')||'%'  \n";
        	sub_query1 = " and b.acq_ex_dt like to_char(sysdate,'YYYYMM')||'%'  \n";       
        }else if(dt.equals("4")){
        	sub_query  = "and b.init_reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%'\n";
        	sub_query1 = "and b.acq_ex_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%'\n";
        }else if(dt.equals("3")){
        	sub_query  = "and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
        	sub_query1 = "and b.acq_ex_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
       }
      	
      	if(!br_id.equals("")){
      		sub_query  += " and a.brch_id like '%" + br_id + "'\n";
        	sub_query1 += " and a.brch_id like '%" + br_id + "'\n";
      	}
           
        query = "select '1' car_off_name1, b.car_use, a.bus_st, '' emp_nm,  '' as car_off_name2, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
      		+ "         ec.nm car_ext, \n" 
			+ "         c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
			+ "         b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "         d.rent_st as R_ST, d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "         decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
			+ "         g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, o.car_nm as CAR_JNM,\n"//
			+ "         k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.07)
			+ "         i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT, \n"
			+ "         f.delay_cont, f.pur_req_dt, decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
			+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt "
			+ "  from   cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng o, \n"	
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n"
			+ "           where a.agnt_st='1'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) k,\n" 
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm, c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n" 
			+ "           where a.agnt_st='2'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) l,\n"
			+ "         ( select code,nm\n"
			+ "           from code\n"
			+ "           where c_st = '0003'\n"
			+ "           and code <> '0000' "
			+ "         ) m,\n"
			+ "         (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) p, "
			+ "         (select * from code where c_st='0032') ec "
			+ "where    nvl(a.use_yn,'Y')='Y' and a.car_gu='1' \n"
			+ sub_query
			+ "         and a.car_mng_id = b.car_mng_id \n"
			+ "         and a.client_id = c.client_id \n"
			+ "         and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "         and a.bus_id = e.user_id\n"
			+ "         and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "         and g.car_id = h.car_id and g.car_seq=h.car_seq and h.car_comp_id=o.car_comp_id and h.car_cd=o.code \n"
			+ "         and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
			+ "         and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
			+ "         and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "         and i.cpt_cd = m.code(+) "
			+ "         and d.rent_mng_id = p.rent_mng_id and d.rent_l_cd = p.rent_l_cd and d.rent_st=p.rent_st\n"			
			+ "         and b.car_ext = ec.nm_cd \n"
			+ " ";
        
        if(gubun.equals("Y")) {
        	
        	query += " union all \n"			
			+ "	select '9' car_off_name1, b.car_use, a.bus_st, '' emp_nm,  '' as car_off_name2, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, \n"
			+ "         substr(co.sh_base_dt,1,4)||'-'||substr(co.sh_base_dt,5,2)||'-'||substr(co.sh_base_dt,7,2) as DLV_DT, \n"
			+ "         a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
			+ "         ec.nm car_ext, \n" 	 
			+ "         c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
			+ "         b.car_mng_id as CAR_MNG_ID, \n"
			+ "         substr(b.acq_ex_dt,1,4)||'-'||substr(b.acq_ex_dt,5,2)||'-'||substr(b.acq_ex_dt,7,2) as INIT_REG_DT, \n"
			+ "         decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "         d.rent_st as R_ST, d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "         decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
			+ "         g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, o.car_nm as CAR_JNM,\n"//
			+ "         k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.07)
			+ "         i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT, \n"
			+ "         f.delay_cont, f.pur_req_dt, decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
			+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt "
			+ "  from   cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng o, \n"
			+ "        ( select rent_mng_id, rent_l_cd, sh_base_dt from commi  where agnt_st = '6' ) co , \n"
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n"
			+ "           where a.agnt_st='5'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) k,\n" 
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n" 
			+ "           where a.agnt_st='6'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) l,\n"
			+ "         ( select code,nm\n"
			+ "           from code\n"
			+ "           where c_st = '0003'\n"
			+ "           and code <> '0000' "
			+ "         ) m,\n"
			+ "         (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) p, "
			+ "         (select * from code where c_st='0032') ec "
			+ "where    a.rent_mng_id = co.rent_mng_id and a.rent_l_cd = co.rent_l_cd \n"
			+ "         and a.car_gu='2' \n"
			+ "         and b.car_ext = ec.nm_cd \n"
			+ sub_query1
			+ "         and a.car_mng_id = b.car_mng_id \n"
			+ "         and a.client_id = c.client_id \n"
			+ "         and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "         and a.bus_id = e.user_id\n"
			+ "         and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "         and g.car_id = h.car_id and g.car_seq=h.car_seq and h.car_comp_id=o.car_comp_id and h.car_cd=o.code \n"
			+ "         and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd \n"
			+ "         and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
			+ "         and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "         and i.cpt_cd = m.code(+) "
			+ "         and d.rent_mng_id = p.rent_mng_id and d.rent_l_cd = p.rent_l_cd and d.rent_st=p.rent_st\n";
			
        }

        
			if(sort.equals("1"))		query += " order by  1 asc, init_reg_dt, 2, car_no, rent_start_dt";
			else if(sort.equals("2"))	query += " order by car_use asc , car_no asc";
			else if(sort.equals("3"))	query += " order by OUT_CAR_OFF_NM";
				
		
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
     * 등록 현황 조회 ( 2003/3/3 )
     */
    public ConditionBean [] getRegCondAll2(String gubun,String dt,String ref_dt1,String ref_dt2,String br_id, String fn_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        String sub_query1 = "";
        String sub_query2 = "";
        String dt_query = "";
        String strfn= "";
        String strfd = "";
        String query = "";
        
        /* 등록, 미등록, 출고, 미출고*/
       
        if(gubun.equals("1")){
        	if(dt.equals("1")){
	        	sub_query = "and a.car_mng_id is null and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt, a.rent_dt, \n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.car_mng_id is null and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt,\n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.car_mng_id is null and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt,\n";
	        }
        }else if(gubun.equals("2")){
        	if(dt.equals("1")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt=to_char(sysdate,'YYYYMMDD')\n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt like to_char(sysdate,'YYYYMM')||'%'\n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
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
	        	sub_query = "and a.car_mng_id is not null and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
	        }
        }else{
        	query = "";
        }
               
        if (!fn_id.equals("0")) {
	        	strfn=fn_id.substring(1);
	        	strfd=fn_id.substring(0,1);
	        	if (strfd.equals("1")) { 
	        		sub_query2="and c.firm_nm like '%" + strfn + "%' ";
	        	} else if (strfd.equals("3")) { 
	        		sub_query2="and pc.nm like '%" + strfn + "%' ";	
				} else if (strfd.equals("4")) { 
	        		sub_query2="and l.car_off_nm like '%" + strfn + "%' ";	
				} else if (strfd.equals("5")) { 
					if(strfn.equals("에이전트")) {
						sub_query2 += " and e.dept_id='1000' ";
					}else {	
						sub_query2="and e.user_nm like '%" + strfn + "%' ";
					}	
	        	}else {
	        		sub_query2="and o.car_nm||h.car_name like '%" + strfn + "%' ";
	        	}
        }
              
        
        query = "select a.bus_st, '' emp_nm, k.nm as car_off_name1, l.nm as car_off_name2, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
       	+ "nvl(ec.nm,ec2.nm) car_ext, \n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_st as R_ST, d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, o.car_nm as CAR_JNM,\n"//
		+ "k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.15)
		+ "i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT,\n"
		+ "f.delay_cont, f.pur_req_dt, \n"
		+ "decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
		+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt \n"		
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng o,\n"
		+ "(select * from code where c_st='0001' and code<>'0000') pc, \n" 
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax, d.nm \n"
		+ "from commi a, car_off_emp b, car_off c, (SELECT * FROM CODE WHERE c_st = '0001' ) d \n"
		+ "where a.agnt_st='1'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id AND c.CAR_COMP_ID=d.CODE ) k,\n" 
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax, d.nm \n"
		+ "from commi a, car_off_emp b, car_off c, (SELECT * FROM CODE WHERE c_st = '0001' ) d\n" 
		+ "where a.agnt_st='2'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id AND c.CAR_COMP_ID=d.CODE ) l,\n"
		+ "(select code,nm\n"
		+ "from code\n"
		+ "where c_st = '0003'\n"
		+ "and code <> '0000') m,\n"
		+ "(select * from code where c_st='0032') ec, "
		+ "(select * from code WHERE c_st='0032') ec2 "
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.car_gu='1' and a.brch_id like '%" + br_id + "'\n"
		+ sub_query2
		+ sub_query
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq and h.car_comp_id=o.car_comp_id and h.car_cd=o.code\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and h.car_comp_id=pc.code(+) \n"
		+ "and b.car_ext = ec.nm_cd(+)\n"
		+ "and g.car_ext = ec2.nm_cd(+)\n"
		+ "and i.cpt_cd = m.code(+) order by \n"
		+ sub_query1
		+ " b.init_reg_dt, c.firm_nm\n";

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
	 * 등록현황 통계
	 * - 20030827 렌트리스별일반식 맞춤식기본식 수정
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
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt like to_char(sysdate,'YYYYMM')||'%'\n";
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
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng n,\n"
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax\n"
		+ "from commi a, car_off_emp b, car_off c \n"
		+ "where a.agnt_st='1'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) k,\n" 
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax\n"
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
		+ "and g.car_id = h.car_id and g.car_seq = h.car_seq and h.car_comp_id = n.car_comp_id and h.car_cd = n.code\n"
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
        
    
    /**
     * 계약 현황 조회 ( 2002/1/3 ) - Kim JungTae
     */
    public ConditionBean [] getRentCondAll(String dt,String ref_dt1,String ref_dt2, String gubun2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        
        String query = "";


		if(gubun2.equals("1")){        
			/* 기간 */
			if(dt.equals("1")){
				sub_query = "and a.rent_dt=to_char(sysdate,'YYYYMMDD')\n";
			}else if(dt.equals("2")){
				sub_query = "and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'\n";
			}else if(dt.equals("3")){
				sub_query = "and a.rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
			}else{
				sub_query = "";
			}
		}else{
			if(dt.equals("1")){
				sub_query = "and a.rent_start_dt=to_char(sysdate,'YYYYMMDD')\n";
			}else if(dt.equals("2")){
				sub_query = "and a.rent_start_dt like to_char(sysdate,'YYYYMM')||'%'\n";
			}else if(dt.equals("3")){
				sub_query = "and a.rent_start_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
			}else{
				sub_query = "";
			}
		}

        
        query = "select a.bus_st, '' emp_nm, '' as car_off_name1, '' as car_off_name2, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
       	+ "nvl(ec.nm,ec2.nm) car_ext, \n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, n.car_nm CAR_JNM, h.car_name as CAR_NAME,\n"//
		+ "k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.15)"
		+ "i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT, f.delay_cont, f.pur_req_dt, \n"
		+ "decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
		+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt \n"		
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng n,\n"
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax\n"
		+ "from commi a, car_off_emp b, car_off c \n"
		+ "where a.agnt_st='1'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) k,\n" 
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax\n"
		+ "from commi a, car_off_emp b, car_off c\n" 
		+ "where a.agnt_st='2'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) l,\n"
		+ "(select code,nm\n"
		+ "from code\n"
		+ "where c_st = '0003'\n"
		+ "and code <> '0000') m,\n"
		+ "and (select * from code where c_st='0032') ec,\n"
		+ "and (select * from code WHERE c_st='0032') ec2 \n"
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.brch_id like '%'\n"
		+ sub_query
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id "
		+ "and g.car_seq = h.car_seq "
		+ "and h.car_comp_id = n.car_comp_id "
		+ "and h.car_cd = n.code "
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and i.cpt_cd = m.code(+) and a.car_st in ('1','3') \n"
        + "and b.car_ext = ec.nm_cd(+) \n"
        + "and g.car_ext = ec2.nm_cd(+) \n";

		if(gubun2.equals("1"))	query += "order by a.rent_dt, b.init_reg_dt, a.dlv_dt, a.rent_dt, c.firm_nm";
		else					query += "order by a.rent_start_dt, a.dlv_dt, a.rent_dt, c.firm_nm";

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
     * 계약 현황 조회 ( 2002/1/3 ) - Kim JungTae
     */
    public ConditionBean [] getRentCondAll(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4, String sort) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        
        String query = "";


		if(gubun2.equals("1")){        
			/* 기간 */
			if(dt.equals("1")){
				sub_query = "and a.rent_dt=to_char(sysdate,'YYYYMMDD')\n";
			}else if(dt.equals("2")){
				sub_query = "and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'\n";
			}else if(dt.equals("3")){
				sub_query = "and a.rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
			}else{
				sub_query = "";
			}
		}else{
			if(dt.equals("1")){
				sub_query = "and a.rent_start_dt=to_char(sysdate,'YYYYMMDD')\n";
			}else if(dt.equals("2")){
				sub_query = "and a.rent_start_dt like to_char(sysdate,'YYYYMM')||'%'\n";
			}else if(dt.equals("3")){
				sub_query = "and a.rent_start_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
			}else{
				sub_query = "";
			}
		}

		if(gubun3.equals("1") && !gubun4.equals("")) sub_query += " and a.bus_id='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) sub_query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) sub_query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";

        
        query = "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
		+ "'' emp_nm, decode(a.bus_st,'1','인터넷','2','영업사원','3','기존업체소개','4','catalog발송','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st,\n"
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
       	+ "nvl(ec.nm, ec2.nm) car_ext, \n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, n.car_nm CAR_JNM, h.car_name as CAR_NAME,\n"//
		+ "k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.15)
		+ "i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT, \n"
		+ "f.delay_cont, f.pur_req_dt, decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
		+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt \n"		
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng n,\n"
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax\n"
		+ "from commi a, car_off_emp b, car_off c \n"
		+ "where a.agnt_st='1'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) k,\n" 
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax\n"
		+ "from commi a, car_off_emp b, car_off c\n" 
		+ "where a.agnt_st='2'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) l,\n"
		+ "(select code,nm\n"
		+ "from code\n"
		+ "where c_st = '0003'\n"
		+ "and code <> '0000') m,\n"
		+ "(select * from code where c_st='0032') ec,\n"
		+ "(select * from code WHERE c_st='0032') ec2\n"
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.brch_id like '%'\n"
		+ sub_query
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id "
		+ "and g.car_seq = h.car_seq "
		+ "and h.car_comp_id = n.car_comp_id "
		+ "and h.car_cd = n.code "
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and i.cpt_cd = m.code(+) and a.car_st in ('1','3') \n"
        + "and b.car_ext = ec.nm_cd(+) and g.car_ext = ec2.nm_cd(+)\n";

		if(sort.equals("1"))		query += "order by a.rent_dt, b.init_reg_dt, a.dlv_dt, a.rent_start_dt, c.firm_nm";
		else if(sort.equals("2"))	query += "order by a.rent_start_dt, a.dlv_dt, a.rent_dt, c.firm_nm";
		else if(sort.equals("3"))	query += "order by c.firm_nm, a.rent_dt, b.init_reg_dt, a.dlv_dt, a.rent_start_dt";
		else if(sort.equals("4"))	query += "order by a.bus_id, a.rent_dt, a.rent_start_dt, c.firm_nm";
		else if(sort.equals("5"))	query += "order by a.bus_st, a.rent_dt, a.rent_start_dt, c.firm_nm";
		else if(sort.equals("6"))	query += "order by k.emp_nm, a.rent_dt, a.rent_start_dt, c.firm_nm";

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
     * 계약현황 통계
	 * - 20030827 렌트리스별일반식 맞춤식기본식 수정
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
       
        if(dt.equals("1")){
        	sub_query = "and a.rent_dt=to_char(sysdate,'YYYYMMDD')\n";
        }else if(dt.equals("2")){
        	sub_query = "and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        }else if(dt.equals("3")){
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
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng n,\n"
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
		+ "from commi a, car_off_emp b, car_off c \n"
		+ "where a.agnt_st='1'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) k,\n" 
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
		+ "from commi a, car_off_emp b, car_off c\n" 
		+ "where a.agnt_st='2'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) l,\n"
		+ "(select code,nm\n"
		+ "from code\n"
		+ "where c_st = '0003'\n"
		+ "and code <> '0000') m\n"
		+ ", (select a.rent_mng_id, a.rent_l_cd, b.rent_way from cont a, fee b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+ sub_query +" and a.car_st = '1' and b.rent_st='1' ) n "
		+ ", (select a.rent_mng_id, a.rent_l_cd, b.rent_way from cont a, fee b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+ sub_query +" and a.car_st = '3' and b.rent_st='1' ) o "
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.brch_id like '%'\n"
		+ sub_query
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id and g.car_seq = h.car_seq and h.car_comp_id = n.car_comp_id and h.car_cd = n.code\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = n.rent_mng_id(+) and a.rent_l_cd = n.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = o.rent_mng_id(+) and a.rent_l_cd = o.rent_l_cd(+)\n"
		+ "and i.cpt_cd = m.code(+) and a.car_st in ('1','3')\n";

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
     * 계약현황 통계
	 * - 20030827 렌트리스별일반식 맞춤식기본식 수정
     */
    public String [] getRentCondSta(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String val [] = new String[20];
		String sub_query = "";
         
        String query = "";
        
		if(gubun2.equals("1")){        
			/* 기간 */
			if(dt.equals("1")){
				sub_query = "and a.rent_dt=to_char(sysdate,'YYYYMMDD')\n";
			}else if(dt.equals("2")){
				sub_query = "and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'\n";
			}else if(dt.equals("3")){
				sub_query = "and a.rent_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
			}else{
				sub_query = "";
			}
		}else{
			if(dt.equals("1")){
				sub_query = "and a.rent_start_dt=to_char(sysdate,'YYYYMMDD')\n";
			}else if(dt.equals("2")){
				sub_query = "and a.rent_start_dt like to_char(sysdate,'YYYYMM')||'%' \n";
			}else if(dt.equals("3")){
				sub_query = "and a.rent_start_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
			}else{
				sub_query = "";
			}
		}

		if(gubun3.equals("1") && !gubun4.equals("")) sub_query += " and a.bus_id='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) sub_query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) sub_query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";

        
        query = "select nvl(sum(decode(n.rent_way,'1',1,0)),0) as rent_way1,"+
				" nvl(sum(decode(n.rent_way,'2',1,0)),0) as rent_way2,"+
				" nvl(sum(decode(n.rent_way,'3',1,0)),0) as rent_way3,"+
				" nvl(sum(decode(o.rent_way,'1',1,0)),0) as rent_way4,"+
				" nvl(sum(decode(o.rent_way,'2',1,0)),0) as rent_way5,"+
				" nvl(sum(decode(o.rent_way,'3',1,0)),0) as rent_way6,"+
				" nvl(sum(decode(d.con_mon,'12',1,0)),0) as con_mon_12,"+
				" nvl(sum(decode(d.con_mon,'24',1,0)),0) as con_mon_24,"+
				" nvl(sum(decode(d.con_mon,'36',1,0)),0) as con_mon_36,"+
				" nvl(sum(decode(d.con_mon,'48',1,0)),0) as con_mon_48,"+
				" nvl(sum(decode(d.con_mon,'12',0,'24',0,'36',0,'48',0,1)),0) as con_mon_etc,"+
				" nvl(sum(fee_s_amt),0) as fee_s_amt,"+
				" nvl(sum(fee_v_amt),0) as fee_v_amt,"+
				" nvl(sum(fee_s_amt)+sum(fee_v_amt),0) as to_fee_amt,"+
				" nvl(sum(decode(a.bus_st,'1',1,0)),0) as bus_st1,"+
				" nvl(sum(decode(a.bus_st,'2',1,0)),0) as bus_st2,"+
				" nvl(sum(decode(a.bus_st,'3',1,0)),0) as bus_st3,"+
				" nvl(sum(decode(a.bus_st,'4',1,0)),0) as bus_st4,"+
				" nvl(sum(decode(a.bus_st,'5',1,0)),0) as bus_st5,"+
				" nvl(sum(decode(a.bus_st,'6',1,0)),0) as bus_st6,"+
			    " nvl(sum(decode(a.bus_st,'7',1,0)),0) as bus_st7"+
				"\n"
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng n,\n"
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax\n"
		+ "from commi a, car_off_emp b, car_off c \n"
		+ "where a.agnt_st='1'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) k,\n" 
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax\n"
		+ "from commi a, car_off_emp b, car_off c\n" 
		+ "where a.agnt_st='2'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) l,\n"
		+ "(select code,nm\n"
		+ "from code\n"
		+ "where c_st = '0003'\n"
		+ "and code <> '0000') m\n"
		+ ", (select a.rent_mng_id, a.rent_l_cd, b.rent_way from cont a, fee b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+ sub_query +" and a.car_st = '1' and b.rent_st='1' ) n "
		+ ", (select a.rent_mng_id, a.rent_l_cd, b.rent_way from cont a, fee b where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+ sub_query +" and a.car_st = '3' and b.rent_st='1' ) o "
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.brch_id like '%'\n"
		+ sub_query
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id and g.car_seq = h.car_seq and h.car_comp_id = n.car_comp_id and h.car_cd = n.code\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = n.rent_mng_id(+) and a.rent_l_cd = n.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = o.rent_mng_id(+) and a.rent_l_cd = o.rent_l_cd(+)\n"
		+ "and i.cpt_cd = m.code(+) and a.car_st in ('1','3')\n";

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

                val [14] = rs.getString(15);
                val [15] = rs.getString(16);
                val [16] = rs.getString(17);
                val [17] = rs.getString(18);
                val [18] = rs.getString(19);
                val [19] = rs.getString(20);

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
     * 지점별 등록현황 통계
     */
    public BranchCondBean [] getBranchCondSta(String dt,String ref_dt1,String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String val [] = new String[10];
		String sub_query = "";
        String query = "";
        
        
        if(dt.equals("1"))
        {
        	sub_query = " and decode(d.rent_st,'1',a.rent_dt,d.rent_dt) = to_char(sysdate,'YYYYMMDD') ";
        }else if(dt.equals("2")){
        	sub_query = " and decode(d.rent_st,'1',a.rent_dt,d.rent_dt) like to_char(sysdate,'YYYYMM')||'%' ";
        }else if(dt.equals("3")){
        	sub_query = " and decode(d.rent_st,'1',a.rent_dt,d.rent_dt) between '" + ref_dt1 + "' and '" + ref_dt2 + "' ";
        }
        
        query = " select c.br_id as BR_ID,h.br_nm as BR_NM,nvl(count(a.rent_mng_id),0) as CONT_CNT,"+
				"        nvl(sum(decode(d.rent_way,'1',1,0)),0) as RENT_WAY_S,"+
				"        nvl(sum(decode(d.rent_way,'2',1,0)),0) as RENT_WAY_M,"+
				"        nvl(sum(decode(d.rent_way,'3',1,0)),0) as RENT_WAY_B,"+
				"        nvl(sum(decode(d.con_mon,'12',1,0)),0) as CON_MON_12,"+
				"        nvl(sum(decode(d.con_mon,'24',1,0)),0) as CON_MON_24,"+
				"        nvl(sum(decode(d.con_mon,'36',1,0)),0) as CON_MON_36,"+
				"        nvl(sum(decode(d.con_mon,'48',1,0)),0) as CON_MON_48,"+
				"        nvl(sum(decode(d.con_mon,'12',0,'24',0,'36',0,'48',0,1)),0) as CON_MON_etc,"+
				"        nvl(sum(decode(b.init_reg_dt,null,0,1)),0) as REG_CNT,"+
				"        nvl(sum(decode(b.init_reg_dt,null,1,0)),0) as UN_REG_CNT,"+
				"        nvl(sum(decode(a.dlv_dt,null,0,1)),0) as DLV_CNT,"+
				"        nvl(sum(decode(a.dlv_dt,null,1,0)),0) as UN_DLV_CNT\n"+
				" from   cont a, car_reg b, fee d, branch h, users c\n"+
				" where  a.rent_mng_id like '%'\n"+
				"        and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.client_id not in ('000228','000231') and a.brch_id like '%'\n"+
		                 sub_query+
				"        and a.car_mng_id = b.car_mng_id(+)\n"+
		        "        and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"+
				"        and a.bus_id = c.user_id\n"+
				"        and c.br_id = h.br_id\n"+
		        " group by c.br_id, h.br_nm\n"+
				" union all\n"+
		        " select '' as BR_ID,'합계' as BR_NM,nvl(count(a.rent_mng_id),0) as CONT_CNT,"+
				"        nvl(sum(decode(d.rent_way,'1',1,0)),0) as RENT_WAY_S,"+
				"        nvl(sum(decode(d.rent_way,'2',1,0)),0) as RENT_WAY_M,"+
				"        nvl(sum(decode(d.rent_way,'3',1,0)),0) as RENT_WAY_B,"+
				"        nvl(sum(decode(d.con_mon,'12',1,0)),0) as CON_MON_12,"+
				"		 nvl(sum(decode(d.con_mon,'24',1,0)),0) as CON_MON_24,"+
				"	     nvl(sum(decode(d.con_mon,'36',1,0)),0) as CON_MON_36,"+
				"	     nvl(sum(decode(d.con_mon,'48',1,0)),0) as CON_MON_48,"+
				"	     nvl(sum(decode(d.con_mon,'12',0,'24',0,'36',0,'48',0,1)),0) as CON_MON_etc,"+
				"	     nvl(sum(decode(b.init_reg_dt,null,0,1)),0) as REG_CNT,"+
				"	     nvl(sum(decode(b.init_reg_dt,null,1,0)),0) as UN_REG_CNT,"+
				"	     nvl(sum(decode(a.dlv_dt,null,0,1)),0) as DLV_CNT,"+
				"	     nvl(sum(decode(a.dlv_dt,null,1,0)),0) as UN_DLV_CNT\n"+
				" from cont a, car_reg b, fee d, branch h, users c\n"+
				" where a.rent_mng_id like '%'\n"+
				"        and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.client_id not in ('000228','000231') and a.brch_id like '%'\n"+
				         sub_query+
				"        and a.car_mng_id = b.car_mng_id(+)\n"+
				"        and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"+
				"        and a.bus_id = c.user_id\n"+
				"        and c.br_id = h.br_id\n";

        Collection<BranchCondBean> col = new ArrayList<BranchCondBean>();

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeBranchCondBean(rs));
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
        return (BranchCondBean[])col.toArray(new BranchCondBean[0]);
    }
    /**
     * 중도해지 현황 조회 ( 2002/1/3 ) - Kim JungTae
     */
    public ClsCondBean [] getClsCondAll(String dt,String ref_dt1,String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        
        String query = "";
        
        /* 기간 */
        if(dt.equals("1")){
        	sub_query = "and a.cls_dt=to_char(sysdate,'YYYYMMDD') \n";
        }else if(dt.equals("2")){
        	sub_query = "and a.cls_dt like to_char(sysdate,'YYYYMM')||'%' \n";
        }else if(dt.equals("3")){
        	sub_query = "and a.cls_dt between '" + ref_dt1 + "' and '" + ref_dt2 + "' \n";
        }else{
        	sub_query = "";
        }
        
        query = "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd RENT_L_CD, a.cls_st CLS_ST, a.term_yn TERM_YN,a.cls_dt CLS_DT,a.reg_id REG_ID, e.user_nm REG_NM,a.cls_cau CLS_CAU, b.client_id CLIENT_ID,c.car_no CAR_NO, d.client_nm CLIENT_NM, d.firm_nm FIRM_NM, g.car_name CAR_NAME\n"
				+ "from cls_cont a, cont b, car_reg c, client d,car_etc f, car_nm g, users e\n"
				+ "where  a.rent_mng_id = b.rent_mng_id\n"
				+ "and a.rent_l_cd = b.rent_l_cd\n"
				+ "and b.bus_id2 = e.user_id\n"
				+ sub_query
				+ "and b.client_id = d.client_id\n"
				+ "and b.car_mng_id = c.car_mng_id(+)\n"
				+ "and a.rent_mng_id = f.rent_mng_id\n"
				+ "and a.rent_l_cd = f.rent_l_cd\n"
				+ "and f.car_id = g.car_id(+) order by a.cls_st\n";

        Collection<ClsCondBean> col = new ArrayList<ClsCondBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeClsCondBean(rs));
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
        return (ClsCondBean[])col.toArray(new ClsCondBean[0]);
    }

    /**
     * 중도해지 현황 조회
     */
    public ClsCondBean [] getClsCondAll2(String dt,String ref_dt1,String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;     
        String query = "";
               
		query = " select a.cls_st, a.rent_l_cd, b.firm_nm, b.client_nm, a.cls_dt, a.cls_cau, cr.car_nm, cr.car_no, c.user_nm"+
				" from cls_cont a, cont_n_view b, users c, car_reg cr \n"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				" and b.bus_id2=c.user_id and b.car_mng_id = cr.car_mng_id(+) and a.cls_st not in ('14') ";  //월렌트해지는 일단 제외
		
        /* 기간 */
        if(dt.equals("1"))        	query += " and a.cls_dt=to_char(sysdate,'YYYYMMDD') \n";
        else if(dt.equals("2"))		query += " and a.cls_dt like to_char(sysdate,'YYYYMM')||'%' \n";
        else if(dt.equals("3"))		query += " and a.cls_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') \n";

		query += " order by a.cls_st, a.cls_dt ";
			
        Collection<ClsCondBean> col = new ArrayList<ClsCondBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
				col.add(makeClsCondBean2(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[ConditionDatabase:getClsCondAll2]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (ClsCondBean[])col.toArray(new ClsCondBean[0]);
    }

 /**
     * 중도해지 현황 조회
     */
    public ClsCondBean [] getClsCondAll2_new(String dt,String ref_dt1,String ref_dt2, String gubun2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;     
        String query = "";
               
		query = " select a.cls_st, a.rent_l_cd, b.firm_nm, b.client_nm, a.cls_dt, a.cls_cau, cr.car_nm, cr.car_no, c.user_nm"+
				" from cls_cont a, cont_n_view b, users c, car_reg cr \n"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				" and b.bus_id2=c.user_id and b.car_mng_id = cr.car_mng_id(+) and a.cls_st not in ('14') ";  //월렌트해지는 일단 제외
		
        /* 기간 */
        if(dt.equals("1"))        	query += " and a.cls_dt=to_char(sysdate,'YYYYMMDD')\n";
        else if(dt.equals("2"))		query += " and a.cls_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        else if(dt.equals("3"))		query += " and a.cls_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
        else if(dt.equals("4"))		query += " and a.cls_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' \n";  //전월
            
         if(gubun2.equals("1"))		query += " and b.car_st = '" + gubun2 + "'\n";
         if(gubun2.equals("3"))		query += " and b.car_st =  '" + gubun2  + "' \n";
         
         query += " order by a.cls_st, a.cls_dt ";

        Collection<ClsCondBean> col = new ArrayList<ClsCondBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
				col.add(makeClsCondBean2(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[ConditionDatabase:getClsCondAll2_new]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (ClsCondBean[])col.toArray(new ClsCondBean[0]);
    }
    
    /**
     * 중도해지 현황 조회
     */
    public ClsCondBean [] getClsCondAll2_new(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;     
        String query = "";
               
		query = " select a.cls_st, a.rent_l_cd, b.firm_nm, b.client_nm, a.cls_dt, a.cls_cau, cr.car_nm, cr.car_no, c.user_nm"+
				" from cls_cont a, cont_n_view b, users c, car_reg cr \n"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				" and b.bus_id2=c.user_id and b.car_mng_id = cr.car_mng_id(+) and a.cls_st not in ('14') ";  //월렌트해지는 일단 제외
		
        /* 기간 */
        if(dt.equals("1"))        	query += " and a.cls_dt=to_char(sysdate,'YYYYMMDD')\n";
        else if(dt.equals("2"))		query += " and a.cls_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        else if(dt.equals("3"))		query += " and a.cls_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
        else if(dt.equals("4"))		query += " and a.cls_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' \n";  //전월
            
         if(gubun2.equals("1"))		query += " and b.car_st = '" + gubun2 + "'\n";
         if(gubun2.equals("3"))		query += " and b.car_st =  '" + gubun2  + "' \n";
         
         if(gubun3.equals("9"))		query += " and a.cls_st =  '" + gubun3  + "' \n";  //폐차 확인 - 결산시 체크용
        
         
         query += " order by a.cls_st, a.cls_dt ";

     //    System.out.println("query=" + query);
         
        Collection<ClsCondBean> col = new ArrayList<ClsCondBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
				col.add(makeClsCondBean2(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[ConditionDatabase:getClsCondAll2_new]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (ClsCondBean[])col.toArray(new ClsCondBean[0]);
    }
    
    /**
     * 중도해지 통계
     */
    public String [] getClsCondSta(String dt,String ref_dt1,String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String val [] = new String[5];
		String sub_query = "";
         
        String query = "";
        
        /* 기간 */
        if(dt.equals("1")){
        	sub_query = "and a.cls_dt=to_char(sysdate,'YYYYMMDD') \n";
        }else if(dt.equals("2")){
        	sub_query = "and a.cls_dt like to_char(sysdate,'YYYYMM')||'%' \n";
        }else if(dt.equals("3")){
        	sub_query = "and a.cls_dt between '" + ref_dt1 + "' and '" + ref_dt2 + "'\n";
        }else{
        	sub_query = "";
        }
        
        query = "select nvl(sum(decode(a.cls_st,'1',1,0)),0),nvl(sum(decode(a.cls_st,'2',1,0)),0),nvl(sum(decode(a.cls_st,'3',1,0)),0),nvl(sum(decode(a.cls_st,'4',1,0)),0),nvl(sum(decode(a.cls_st,'5',1,0)),0)\n"
				+ "from cls_cont a, cont b, car_reg c, client d,car_etc f, car_nm g, users e\n"
				+ "where  a.rent_mng_id = b.rent_mng_id\n"
				+ "and a.rent_l_cd = b.rent_l_cd\n"
				+ "and a.reg_id = e.user_id\n"
				+ sub_query
				+ "and b.client_id = d.client_id\n"
				+ "and b.car_mng_id = c.car_mng_id(+)\n"
				+ "and a.rent_mng_id = f.rent_mng_id\n"
				+ "and a.rent_l_cd = f.rent_l_cd\n"
				+ "and f.car_id = g.car_id(+) order by a.cls_st\n";

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){
                val [0] = rs.getString(1);
                val [1] = rs.getString(2);
                val [2] = rs.getString(3);
                val [3] = rs.getString(4);
                val [4] = rs.getString(5);
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
     * 중도해지 통계
     */
    public String [] getClsCondSta2(String dt,String ref_dt1,String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;        
        String val [] = new String[10];
        String query = "";
               
		query = " select  "+
				" nvl(sum(decode(a.cls_st,'1',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'2',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'3',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'4',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'5',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'6',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'7',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'8',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'9',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'10',1,0)),0)"+
				" from cls_cont a, cont_n_view b, users c"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.bus_id2=c.user_id";
		
        /* 기간 */
        if(dt.equals("1"))        	query += " and a.cls_dt=to_char(sysdate,'YYYYMMDD')\n";
        else if(dt.equals("2"))		query += " and a.cls_dt like to_char(sysdate,'YYYYMM')||'%' \n";
        else if(dt.equals("3"))		query += " and a.cls_dt between '" + ref_dt1 + "' and '" + ref_dt2 + "'\n";
        
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
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[ConditionDatabase:getClsCondSta2]"+se);
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
     * 중도해지 통계
     */
    public String [] getClsCondSta2_new(String dt,String ref_dt1,String ref_dt2, String gubun2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;        
        String val [] = new String[10];
        String query = "";
               
		query = " select  "+
				" nvl(sum(decode(a.cls_st,'1',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'2',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'3',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'4',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'5',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'6',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'7',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'8',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'9',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'10',1,0)),0)"+
				" from cls_cont a, cont_n_view b, users c"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.bus_id2=c.user_id";
		
        /* 기간 */
        if(dt.equals("1"))        	query += " and a.cls_dt=to_char(sysdate,'YYYYMMDD')\n";
        else if(dt.equals("2"))		query += " and a.cls_dt like to_char(sysdate,'YYYYMM')||'%'\n";
        else if(dt.equals("3"))		query += " and a.cls_dt between '" + ref_dt1 + "' and '" + ref_dt2 + "'\n";
        else if(dt.equals("4"))		query += " and a.cls_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' \n";  //전월
        
         if(gubun2.equals("1"))		query += " and b.car_st = '" + gubun2 + "'\n";
         if(gubun2.equals("3"))		query += " and b.car_st =  '" + gubun2  + "'\n";

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
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[ConditionDatabase:getClsCondSta2_new]"+se);
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
     * 계약 만료 현황 조회 ( 2002/1/3 ) - Kim JungTae
     */
    public ConditionBean [] getRentEndCondAll(String dt,String ref_dt1,String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        
        String query = "";
        
        /* 기간 */
        if(dt.equals("1")){
        	sub_query = "and a.rent_end_dt=to_char(sysdate,'YYYYMMDD')\n";
        }else if(dt.equals("2")){
        	sub_query = "and a.rent_end_dt like to_char(sysdate,'YYYYMM')||'%' \n";
        }else if(dt.equals("3")){
        	sub_query = "and a.rent_end_dt between '" + ref_dt1 + "' and '" + ref_dt2 + "'\n";
        }else{
        	sub_query = "";
        }
        
        
        
        query = "select a.bus_st, '' emp_nm, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.bus_id2 as BUS_ID, e.user_nm as BUS_NM,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
        + " nvl(ec.nm,ec2.nm) car_ext, \n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_st as R_ST,d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(a.rent_end_dt,null,'',substr(a.rent_end_dt,1,4)||'-'||substr(a.rent_end_dt,5,2)||'-'||substr(a.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, o.car_nm as CAR_JNM,\n"//
		+ "k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.15)
		+ "i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT, \n"
		+ "f.delay_cont, f.pur_req_dt, decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
		+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt \n"		
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng o,\n"
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
		+ "from commi a, car_off_emp b, car_off c \n"
		+ "where a.agnt_st='1'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) k,\n" 
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
		+ "from commi a, car_off_emp b, car_off c\n" 
		+ "where a.agnt_st='2'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id) l,\n"
		+ "(select code,nm\n"
		+ "from code\n"
		+ "where c_st = '0003'\n"
		+ "and code <> '0000') m,\n"
		+ "(select * from code where c_st='0032') ec,\n"
		+ "(select * from code WHERE c_st='0032') ec2\n"
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.brch_id like '%'\n"
		+ sub_query
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id2 = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq and h.car_comp_id=o.car_comp_id and h.car_cd=o.code\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and b.car_ext = ec.nm_cd(+) and g.car_ext = ec2.nm_cd(+)\n"
		+ "and i.cpt_cd = m.code(+) order by d.RENT_END_DT, c.firm_nm\n";

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
     * 계약 현황 조회
     */
    public Vector getRentCondAll_20070424(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4, String sort) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//계약일
		if(gubun2.equals("1")){     
			if(dt.equals("1"))								dt_query = " and nvl(b.rent_dt,a.rent_dt)="+s_dt1+"\n";
			else if(dt.equals("2"))							dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt2+"||'%' \n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and nvl(b.rent_dt,a.rent_dt) "+s_dt3+"\n";
			
		//대여개시일
		}else{				
			if(dt.equals("1"))								dt_query = "and b.rent_start_dt="+s_dt1+"\n";
			else if(dt.equals("2"))							dt_query = "and b.rent_start_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = "and b.rent_start_dt "+s_dt3+"\n";
		}
        
        query = " select\n"+
				" a.rent_mng_id, a.rent_l_cd, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, b.rent_start_dt, c.firm_nm, c.client_nm, g.car_nm, f.car_name,\n"+
				" a.dlv_dt, d.init_reg_dt, i.nm as cpt_nm, b.con_mon,\n"+
				" decode(a.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st,\n"+
				" decode(a.rent_st,'1','신규','2','연장','3','대차','4','증차','5','연장','6','재리스','7','재리스') rent_st,\n"+
				" decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
				" decode(a.bus_st,'1','인터넷','2','영업사원','3','기존업체소개','4','카달로그발송','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st,\n"+
				" j.emp_nm, jj.emp_nm as chul_nm, k.user_nm as bus_nm, l.user_nm as bus_nm2, decode(m.user_nm,l.user_nm,'',m.user_nm) as mng_nm\n"+
				" from cont a, fee b, client c, car_reg d, car_etc e, car_nm f, car_mng g, allot h,\n"+
				"      (select * from code where c_st='0003') i,\n"+
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='1' and a.emp_id=b.emp_id ) j,\n"+
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='2' and a.emp_id=b.emp_id ) jj,\n"+
				"      users k, users l, users m\n"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2','5') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				dt_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd\n"+
				" and h.cpt_cd=i.code(+)\n"+
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+)\n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+)\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)\n"+
				" and a.mng_id=m.user_id(+)";

		if(gubun3.equals("1") && !gubun4.equals("")) query += " and decode(b.rent_st,'1',a.bus_id,b.ext_agnt)='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";

		if(sort.equals("1"))		query += " order by nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("2"))	query += " order by b.rent_start_dt";
		else if(sort.equals("3"))	query += " order by c.firm_nm, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("4"))	query += " order by a.bus_id, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("5"))	query += " order by a.bus_st, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("6"))	query += " order by j.emp_nm, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("7"))	query += " order by decode(a.rent_st,'2',1,'5',2,'6',3,'7',4,'3',5,'4',6,'1',7), nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("8"))	query += " order by to_number(b.con_mon)";

        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentCondAll_20070424]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
    /**
     * 계약 현황 조회
     */
    public Vector getRentCondAll_20071025(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4, String sort) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//계약일
		if(gubun2.equals("1")){     
			if(dt.equals("1"))								dt_query = " and nvl(b.rent_dt,a.rent_dt)="+s_dt1+"\n";
			else if(dt.equals("2"))							dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt2+"||'%'\n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and nvl(b.rent_dt,a.rent_dt) "+s_dt3+"\n";
			
		//대여개시일
		}else{				
			if(dt.equals("1"))								dt_query = "and b.rent_start_dt="+s_dt1+"\n";
			else if(dt.equals("2"))							dt_query = "and b.rent_start_dt like "+s_dt2+"||'%' \n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = "and b.rent_start_dt "+s_dt3+"\n";
		}
        
        query = " select\n"+
				" a.rent_mng_id, a.rent_l_cd, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, b.rent_start_dt, c.firm_nm, c.client_nm, g.car_nm, f.car_name,\n"+
				" a.dlv_dt, d.init_reg_dt, i.nm as cpt_nm, b.con_mon,\n"+
				" decode(b.rent_st,'1','','연장') ext_st, \n"+
				" decode(nvl(a.car_gu,a.reg_id),'1','신차','0','재리스','2','중고차') car_gu, \n"+
				" decode(a.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st,\n"+
				" decode(a.rent_st,'1','신규','2','연장','3','대차','4','증차','5','연장','6','재리스','7','재리스') rent_st,\n"+
				" decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
				" decode(a.bus_st,'1','인터넷','2','영업사원','3','기존업체소개','4','카달로그발송','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st,\n"+
				" j.emp_nm, jj.emp_nm as chul_nm, k.user_nm as bus_nm, l.user_nm as bus_nm2, decode(m.user_nm,l.user_nm,'',m.user_nm) as mng_nm, z.ins_com_id\n"+
				" from cont a, fee b, client c, car_reg d, car_etc e, car_nm f, car_mng g, allot h,\n"+
				"      (select * from code where c_st='0003') i,\n"+
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='1' and a.emp_id=b.emp_id ) j,\n"+
				"      (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where agnt_st='2' and a.emp_id=b.emp_id ) jj,\n"+
				"      users k, users l, users m,\n"+
				"      (select car_mng_id, ins_com_id from insur where ins_sts='1' and ins_exp_dt > to_char(sysdate,'YYYYMMDD')) z"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2','5') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				dt_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd\n"+
				" and h.cpt_cd=i.code(+)\n"+
				" and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+)\n"+
				" and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+)\n"+
				" and nvl(b.ext_agnt,a.bus_id)=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)\n"+
				" and a.mng_id=m.user_id(+)"+
				" and a.car_mng_id=z.car_mng_id(+)"+
				" AND c.firm_nm NOT LIKE '%아마존카%' ";

		if(gubun3.equals("1") && !gubun4.equals("")) query += " and k.user_nm='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) query += " and l.user_nm='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) query += " and m.user_nm='"+gubun4+"'";

		if(sort.equals("1"))		query += " order by nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("2"))	query += " order by b.rent_start_dt";
		else if(sort.equals("3"))	query += " order by c.firm_nm, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("4"))	query += " order by a.bus_id, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("5"))	query += " order by a.bus_st, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("6"))	query += " order by j.emp_nm, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("7"))	query += " order by a.use_yn desc, decode(b.rent_st,'1',1,2) desc, decode(nvl(a.car_gu,a.reg_id),'0','1','2','2','1','3'), a.rent_st desc, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("8"))	query += " order by to_number(b.con_mon)";

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

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
            stmt.close();
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentCondAll_20071025]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
     * 계약현황 통계
     */
    public String [] getRentCondSta_20070424(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String val [] = new String[30];
        String query = "";
		String dt_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//계약일
		if(gubun2.equals("1")){     
			if(dt.equals("1"))				dt_query = " and nvl(b.rent_dt,a.rent_dt)="+s_dt1+"\n";
			else if(dt.equals("2"))			dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt2+"||'%'\n";
			else if(dt.equals("3"))			dt_query = " and nvl(b.rent_dt,a.rent_dt) "+s_dt3+"\n";
			
		//대여개시일
		}else{				
			if(dt.equals("1"))				dt_query = "and b.rent_start_dt="+s_dt1+"\n";
			else if(dt.equals("2"))			dt_query = "and b.rent_start_dt like "+s_dt2+"||'%'\n";
			else if(dt.equals("3"))			dt_query = "and b.rent_start_dt "+s_dt3+"\n";
		}

        query = " select\n"+
				" nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'1',1,0),0)),0) as rent_way1,\n"+
				" nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'2',1,0),0)),0) as rent_way2,\n"+
				" nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'3',1,0),0)),0) as rent_way3,\n"+
				" nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'1',1,0),0)),0) as rent_way4,\n"+
				" nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'2',1,0),0)),0) as rent_way5,\n"+
				" nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'3',1,0),0)),0) as rent_way6,\n"+
				" nvl(sum(decode(b.con_mon,'48',1,0)),0) as con_mon1,\n"+
				" nvl(sum(decode(b.con_mon,'36',1,0)),0) as con_mon2,\n"+
				" nvl(sum(decode(b.con_mon,'24',1,0)),0) as con_mon3,\n"+
				" nvl(sum(decode(b.con_mon,'12',1,0)),0) as con_mon4,\n"+
				" nvl(sum(decode(b.con_mon,'48',0,'36',0,'24',0,'12',0,1)),0) as con_mon5,\n"+
				" nvl(sum(b.fee_s_amt),0) fee_s_amt,\n"+
				" nvl(sum(b.fee_v_amt),0) fee_v_amt,\n"+
				" nvl(sum(b.fee_s_amt+b.fee_v_amt),0) fee_amt,\n"+
				" nvl(sum(decode(a.bus_st,'1',1,0)),0) as bus_st1,\n"+
				" nvl(sum(decode(a.bus_st,'2',1,0)),0) as bus_st2,\n"+
				" nvl(sum(decode(a.bus_st,'3',1,0)),0) as bus_st3,\n"+
				" nvl(sum(decode(a.bus_st,'4',1,0)),0) as bus_st4,\n"+
				" nvl(sum(decode(a.bus_st,'5',1,0)),0) as bus_st5,\n"+
				" nvl(sum(decode(a.bus_st,'6',1,0)),0) as bus_st6,\n"+
				" nvl(sum(decode(a.bus_st,'7',1,0)),0) as bus_st7,\n"+
				" nvl(sum(decode(a.rent_st,'1',1,0)),0) as rent_st1,\n"+
				" nvl(sum(decode(a.rent_st,'2',1,0)),0) as rent_st2,\n"+
				" nvl(sum(decode(a.rent_st,'3',1,0)),0) as rent_st3,\n"+
				" nvl(sum(decode(a.rent_st,'4',1,0)),0) as rent_st4,\n"+
				" nvl(sum(decode(a.rent_st,'5',1,0)),0) as rent_st5,\n"+
				" nvl(sum(decode(a.rent_st,'6',1,0)),0) as rent_st6,\n"+
				" nvl(sum(decode(a.rent_st,'7',1,0)),0) as rent_st7\n"+
				" from cont a, fee b"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2','5') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				dt_query ;

		if(gubun3.equals("1") && !gubun4.equals("")) query += " and decode(b.rent_st,'1',a.bus_id,b.ext_agnt)='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";

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

                val [14] = rs.getString(15);
                val [15] = rs.getString(16);
                val [16] = rs.getString(17);
                val [17] = rs.getString(18);
                val [18] = rs.getString(19);
                val [19] = rs.getString(20);

                val [20] = rs.getString(21);
                val [21] = rs.getString(22);
                val [22] = rs.getString(23);
                val [23] = rs.getString(24);
                val [24] = rs.getString(25);
                val [25] = rs.getString(26);
                val [26] = rs.getString(27);

			}
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentCondSta_20070424]\n"+se);
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
     * 계약현황 통계
     */
    public String [] getRentCondSta_20071025(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String val [] = new String[31];
        String query = "";
		String dt_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//계약일
		if(gubun2.equals("1")){     
			if(dt.equals("1"))				dt_query = " and nvl(b.rent_dt,a.rent_dt)="+s_dt1+"\n";
			else if(dt.equals("2"))			dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt2+"||'%'\n";
			else if(dt.equals("3"))			dt_query = " and nvl(b.rent_dt,a.rent_dt) "+s_dt3+"\n";
			
		//대여개시일
		}else{				
			if(dt.equals("1"))				dt_query = "and b.rent_start_dt="+s_dt1+"\n";
			else if(dt.equals("2"))			dt_query = "and b.rent_start_dt like "+s_dt2+"||'%'\n";
			else if(dt.equals("3"))			dt_query = "and b.rent_start_dt "+s_dt3+"\n";
		}

        query = " select\n"+
				" nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'1',1,0),0)),0) as rent_way1,\n"+
				" nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'2',1,0),0)),0) as rent_way2,\n"+
				" nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'3',1,0),0)),0) as rent_way3,\n"+
				" nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'1',1,0),0)),0) as rent_way4,\n"+
				" nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'2',1,0),0)),0) as rent_way5,\n"+
				" nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'3',1,0),0)),0) as rent_way6,\n"+
				" nvl(sum(decode(b.con_mon,'48',1,0)),0) as con_mon1,\n"+
				" nvl(sum(decode(b.con_mon,'36',1,0)),0) as con_mon2,\n"+
				" nvl(sum(decode(b.con_mon,'24',1,0)),0) as con_mon3,\n"+
				" nvl(sum(decode(b.con_mon,'12',1,0)),0) as con_mon4,\n"+
				" nvl(sum(decode(b.con_mon,'48',0,'36',0,'24',0,'12',0,1)),0) as con_mon5,\n"+
				" nvl(sum(b.fee_s_amt),0) fee_s_amt,\n"+
				" nvl(sum(b.fee_v_amt),0) fee_v_amt,\n"+
				" nvl(sum(b.fee_s_amt+b.fee_v_amt),0) fee_amt,\n"+
				//영업구분별
				" nvl(sum(decode(a.bus_st,'1',1,0)),0) as bus_st1,\n"+
				" nvl(sum(decode(a.bus_st,'2',1,0)),0) as bus_st2,\n"+
				" nvl(sum(decode(a.bus_st,'3',1,0)),0) as bus_st3,\n"+
				" nvl(sum(decode(a.bus_st,'4',1,0)),0) as bus_st4,\n"+
				" nvl(sum(decode(a.bus_st,'5',1,0)),0) as bus_st5,\n"+
				" nvl(sum(decode(a.bus_st,'6',1,0)),0) as bus_st6,\n"+
				" nvl(sum(decode(a.bus_st,'7',1,0)),0) as bus_st7,\n"+
				//계약구분별
				" nvl(sum(decode(b.rent_st,'1',0,1)),0) as rent_st1,\n"+
				" nvl(sum(decode(b.rent_st,'1',decode(nvl(a.car_gu,a.reg_id),'1',decode(decode(a.rent_st,'3','3','4','4','1'),'1',1,0)))),0) as rent_st2,\n"+
				" nvl(sum(decode(b.rent_st,'1',decode(nvl(a.car_gu,a.reg_id),'1',decode(decode(a.rent_st,'3','3','4','4','1'),'3',1,0)))),0) as rent_st3,\n"+
				" nvl(sum(decode(b.rent_st,'1',decode(nvl(a.car_gu,a.reg_id),'1',decode(decode(a.rent_st,'3','3','4','4','1'),'4',1,0)))),0) as rent_st4,\n"+
				" nvl(sum(decode(b.rent_st,'1',decode(nvl(a.car_gu,a.reg_id),'0',decode(decode(a.rent_st,'3','3','4','4','1'),'1',1,0)))),0) as rent_st5,\n"+
				" nvl(sum(decode(b.rent_st,'1',decode(nvl(a.car_gu,a.reg_id),'0',decode(decode(a.rent_st,'3','3','4','4','1'),'3',1,0)))),0) as rent_st6,\n"+
				" nvl(sum(decode(b.rent_st,'1',decode(nvl(a.car_gu,a.reg_id),'0',decode(decode(a.rent_st,'3','3','4','4','1'),'4',1,0)))),0) as rent_st7\n"+
				" from cont a, fee b, (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) c"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2','5') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and a.client_id <> '000228' \n"+ /*and a.client_id <> '000228' 추가 20130115 */
				dt_query ;

		if(gubun3.equals("1") && !gubun4.equals("")) query += " and decode(b.rent_st,'1',a.bus_id,b.ext_agnt)='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){
				//rent_way	
                val [0] = rs.getString(1);
                val [1] = rs.getString(2);
                val [2] = rs.getString(3);
                val [3] = rs.getString(4);
                val [4] = rs.getString(5);
                val [5] = rs.getString(6);
				//con_mon
                val [6] = rs.getString(7);
                val [7] = rs.getString(8);
                val [8] = rs.getString(9);
                val [9] = rs.getString(10);
                val [10] = rs.getString(11);
				//fee_s_amt
				val [11] = rs.getString(12);
				val [12] = rs.getString(13);
				val [13] = rs.getString(14);
				//bus_st
                val [14] = rs.getString(15);
                val [15] = rs.getString(16);
                val [16] = rs.getString(17);
                val [17] = rs.getString(18);
                val [18] = rs.getString(19);
                val [19] = rs.getString(20);
				val [20] = rs.getString(21);
				//rent_st
                val [21] = rs.getString(22);
                val [22] = rs.getString(23);
                val [23] = rs.getString(24);
                val [24] = rs.getString(25);
                val [25] = rs.getString(26);
                val [26] = rs.getString(27);
                val [27] = rs.getString(28);

			}
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentCondSta_20071025]\n"+se);
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
     * 계약만료예정현황 조회 
     */
    public Vector getRentEndCondAll(String dt,String ref_dt1,String ref_dt2, String gubun3, String gubun4 ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";     
		String sub_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
		String s_dt4 = "between to_char(sysdate,'YYYYMM')||'01' and TO_CHAR(ADD_MONTHS(SYSDATE,+1),'YYYYMM')||'31' "; //당월~익월
		String s_dt5 = "between to_char(sysdate,'YYYYMM')||'01' and TO_CHAR(ADD_MONTHS(SYSDATE,+2),'YYYYMM')||'31' "; //당월~익익월 

		if(dt.equals("1"))				dt_query = " and b.rent_end_dt like "+s_dt2+"||'%'\n";
		else if(dt.equals("2"))			dt_query = " and ( b.rent_end_dt like "+s_dt2+"||'%' or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
		else if(dt.equals("3"))			dt_query = " and ( b.rent_end_dt "+s_dt3+" or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
		else if(dt.equals("4"))			dt_query = " and ( b.rent_end_dt "+s_dt4+" or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
		else if(dt.equals("5"))			dt_query = " and ( b.rent_end_dt "+s_dt5+" or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
		
		if(gubun3.equals("1") && !gubun4.equals("")) sub_query += " and k.user_nm='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) sub_query += " and l.user_nm='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) sub_query += " and nvl(j2.user_nm,l.user_nm)='"+gubun4+"'";
		if(gubun3.equals("4") && !gubun4.equals("")) sub_query += " and j.user_nm='"+gubun4+"'";

/*		
		query = " select  \n"+
				" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, c.firm_nm,\n"+
				" decode(a.car_st,'4','월렌트',decode(h.rent_way,'1','일반식','2','맞춤식','3','기본식')) rent_way,\n"+
				" decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st, \n"+
				" b.con_mon, b.rent_start_dt, b.rent_end_dt,\n"+
				" g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\n"+
				" a.bus_id, a.bus_id2, k.user_nm as bus_nm, l.user_nm as bus_nm2, sf.fee_est_dt, j.user_nm as re_bus_nm, "+
				" to_char(i.reg_dt,'YYYYMMDD') end_cont_mm_dt,   i.content as end_cont_mm_content, \n"+
				" to_char(i2.reg_dt,'YYYYMMDD') end_cont_mm_dt2, i2.content as end_cont_mm_content2, \n"+
				" trunc(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')) dly_day, \n"+
				" trunc((h.fee_s_amt+h.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
				" decode(es.fee_opt_amt,0,nvl(es.o_1,0),es.fee_opt_amt) as o_1, decode(o.rent_l_cd,'','N','Y') cls_reg_yn, \n"+
				" decode(cc.rent_l_cd,'','','해지반납') call_in_st, n.emp_nm, "+
				" d.car_end_dt, decode(d.car_end_yn,'Y','연장종료','') car_end_yn, d.fuel_kd, f.car_comp_id "+
				" from cont a, \n"+
				"     (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) b,\n"+
				"     (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee where bill_yn='Y' group by rent_mng_id, rent_l_cd) sf,\n"+
				"     client c, car_reg d, car_etc e, car_nm f, car_mng g,\n"+
				"     users k, users l, \n"+
				//2개월이내 i
				"     (select i.rent_mng_id, i.rent_l_cd, i.re_bus_id, i.reg_dt, i.content from end_cont_mm i, (select ia.rent_mng_id, ia.rent_l_cd, max(ia.seq) seq from end_cont_mm ia, cont ib where ia.rent_l_cd=ib.rent_l_cd and ia.reg_dt >= TO_date(ib.rent_end_dt,'YYYYMMDD')-60 group by ia.rent_mng_id, ia.rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i , \n"+
                //2개월이상 i2
				"     (select i.rent_mng_id, i.rent_l_cd, i.re_bus_id, i.reg_dt, i.content from end_cont_mm i, (select ia.rent_mng_id, ia.rent_l_cd, max(ia.seq) seq from end_cont_mm ia, cont ib where ia.rent_l_cd=ib.rent_l_cd and ia.reg_dt <  TO_date(ib.rent_end_dt,'YYYYMMDD')-60 group by ia.rent_mng_id, ia.rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i2 , \n"+
				"	  users j, users j2, fee h, \n"+
				"     (select rent_mng_id, rent_l_cd, rent_st, fee_opt_amt, o_1 from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) es, \n"+
				"     cls_etc o,  \n"+
				"     (select rent_mng_id, rent_l_cd from car_call_in where in_st='3' and out_dt is null ) cc, "+
				"     (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where a.agnt_st='1' and a.emp_id=b.emp_id ) n "+		
				" where a.use_yn='Y' and a.car_st in ('1','3') \n"+ 
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				" and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+)\n"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.re_bus_id=j.user_id(+) and a.mng_id=j2.user_id(+) \n"+
				" and a.rent_mng_id=i2.rent_mng_id(+) and a.rent_l_cd=i2.rent_l_cd(+) \n"+
				dt_query +
				sub_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id "+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \n"+
				" and b.rent_mng_id=es.rent_mng_id(+) and b.rent_l_cd=es.rent_l_cd(+) and b.rent_st=es.rent_st(+) \n"+
				" and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \n"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+						
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+						
				" order by b.rent_end_dt";
*/
		
		query = " select  \r\n"
				+ "				 case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end r_end_dt, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, c.firm_nm,\r\n"
				+ "				 decode(a.car_st,'4','월렌트',decode(h.rent_way,'1','일반식','2','맞춤식','3','기본식')) rent_way,\r\n"
				+ "				 decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st, \r\n"
				+ "				 b.con_mon, b.rent_start_dt, b.rent_end_dt,\r\n"
				+ "				 g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\r\n"
				+ "				 a.bus_id, a.bus_id2, k.user_nm as bus_nm, l.user_nm as bus_nm2, sf.fee_est_dt, j.user_nm as re_bus_nm, \r\n"
				+ "				 CASE WHEN i.reg_dt >= TO_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')-60 THEN to_char(i.reg_dt,'YYYYMMDD') ELSE '' END end_cont_mm_dt, \r\n"
				+ "				 CASE WHEN i.reg_dt < TO_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')-60 THEN to_char(i.reg_dt,'YYYYMMDD') ELSE '' END end_cont_mm_dt2, \r\n"
				+ "              i.content as end_cont_mm_content, i.cnt AS end_cont_mm_cnt, \r\n"
				+ "				 trunc(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')) dly_day, \r\n"
				+ "				 trunc((h.fee_s_amt+h.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \r\n"
				+ "              decode(es.fee_opt_amt,0,nvl(es.o_1,0),es.fee_opt_amt) as o_1, decode(o.rent_l_cd,'','N','Y') cls_reg_yn, \r\n"
				+ "				 decode(cc.rent_l_cd,'','','해지반납') call_in_st, n.emp_nm, \r\n"
				+ "				 d.car_end_dt, decode(d.car_end_yn,'Y','연장종료','') car_end_yn, d.fuel_kd, f.car_comp_id \r\n"
				+ "from          cont a, \r\n"
				+ "				 (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) b,\r\n"
				+ "				 (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee where bill_yn='Y' group by rent_mng_id, rent_l_cd) sf,\r\n"
				+ "				 client c, car_reg d, car_etc e, car_nm f, car_mng g,\r\n"
				+ "				 users k, users l, \r\n"
				+ "              (SELECT mm.*, mm2.cnt FROM end_cont_mm mm, (SELECT rent_mng_id, rent_l_cd, MAX(seq) seq, COUNT(0) cnt FROM end_cont_mm GROUP BY rent_mng_id, rent_l_cd) mm2 WHERE mm.rent_mng_id=mm2.rent_mng_id AND mm.rent_l_cd=mm.rent_l_cd AND mm.seq=mm2.seq) i,\r\n"
				+ "				 users j, users j2, fee h, \r\n"
				+ "              (select rent_mng_id, rent_l_cd, rent_st, fee_opt_amt, o_1 from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) es, \r\n"				
				+ "				 cls_etc o,  \r\n"
				+ "				 (select rent_mng_id, rent_l_cd from car_call_in where in_st='3' and out_dt is null ) cc, \r\n"
				+ "				 (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where a.agnt_st='1' and a.emp_id=b.emp_id ) n \r\n"
				+ "where         a.use_yn='Y' and a.car_st in ('1','3')   \r\n"
				+ "				 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\r\n"
				+ "				 and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+)\r\n"
				+ "				 and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) \r\n"
				+ "              and i.re_bus_id=j.user_id(+) \r\n"
				+ "              and a.mng_id=j2.user_id(+) \r\n"
				+ "				 and a.client_id=c.client_id\r\n"
				+ "				 and a.car_mng_id=d.car_mng_id\r\n"
				+ "				 and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\r\n"
				+ "				 and e.car_id=f.car_id and e.car_seq=f.car_seq\r\n"
				+ "				 and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\r\n"
				+ "				 and a.bus_id=k.user_id\r\n"
				+ "				 and a.bus_id2=l.user_id \r\n"
				+ "				 and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \r\n"
				+ "              and b.rent_mng_id=es.rent_mng_id(+) and b.rent_l_cd=es.rent_l_cd(+) and b.rent_st=es.rent_st(+) \n"				
				+ "				 and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \r\n"
				+ "				 and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)\r\n"
				+ "				 and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"
				+ dt_query 
				+ sub_query 
				+ "order by 1 ";
		
		
		
        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentEndCondAll]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 계약만료예정현황 조회
     */
    public Vector getRentEndCondAll_20070424_B(String dt,String ref_dt1,String ref_dt2, String gubun3, String gubun4 ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";     
		String sub_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		if(dt.equals("1"))				dt_query = " and b.rent_end_dt like "+s_dt2+"||'%'\n";
		else if(dt.equals("2"))			dt_query = " and ( b.rent_end_dt like "+s_dt2+"||'%' or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
		else if(dt.equals("3"))			dt_query = " and ( b.rent_end_dt "+s_dt3+" or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
			  
		if(gubun3.equals("1") && !gubun4.equals("")) sub_query += " and a.bus_id='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) sub_query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) sub_query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";
		if(gubun3.equals("4") && !gubun4.equals("")) sub_query += " and i.re_bus_id='"+gubun4+"'";

	        
        query = " select   \n"+
				" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, c.firm_nm,\n"+
				" decode(a.car_st,'4','월렌트',decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식')) rent_way,\n"+
				" decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st, \n"+
				" b.con_mon, b.rent_start_dt, b.rent_end_dt,\n"+
				" g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\n"+
				" a.bus_id, a.bus_id2, k.user_nm as bus_nm, l.user_nm as bus_nm2, sf.fee_est_dt, j.user_nm as re_bus_nm, to_char(i.reg_dt,'YYYYMMDD') end_cont_mm_dt, \n"+
				" trunc(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')) dly_day, \n"+
				" trunc((h.fee_s_amt+h.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
				" decode(es.fee_opt_amt,0,nvl(es.o_1,0),es.fee_opt_amt) as o_1, decode(o.rent_l_cd,'','N','Y') cls_reg_yn, \n"+
				" decode(cc.rent_l_cd,'','','해지반납') call_in_st, n.emp_nm, fe.con_day, "+
				" d.car_end_dt, decode(d.car_end_yn,'Y','연장종료','') car_end_yn "+
				" from cont a, \n"+
				"     (select  rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(rent_way) rent_way, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee where rent_end_dt is not null group by rent_mng_id, rent_l_cd) b,\n"+
				"     (select  rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee group by rent_mng_id, rent_l_cd) sf,\n"+
				"     client c, car_reg d, car_etc e, car_nm f, car_mng g,\n"+
				"     users k, users l, \n"+
				"     (select i.* from end_cont_mm i,(select rent_mng_id, rent_l_cd, max(seq) seq from end_cont_mm group by rent_mng_id, rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i , \n"+
				"	  users j, fee h, \n"+
				"     (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) es, \n"+
				"     cls_etc o,  \n"+
	            //차량해지반납
				"     (select * from car_call_in where in_st='3' and out_dt is null ) cc, "+
				"     (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where a.agnt_st='1' and a.emp_id=b.emp_id ) n, "+
				"     fee_etc fe "+		
				" where nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') \n"+ //월렌트 계약만료예정현황은 별도로 한다.
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				" and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+)\n"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.re_bus_id=j.user_id(+) \n"+
				dt_query +
				sub_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)"+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \n"+
				" and b.rent_mng_id=es.rent_mng_id(+) and b.rent_l_cd=es.rent_l_cd(+) and b.rent_st=es.rent_st(+) \n"+
				" and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \n"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+						
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+						
				" and b.rent_mng_id=fe.rent_mng_id(+) and b.rent_l_cd=fe.rent_l_cd(+) and b.rent_st=fe.rent_st(+) \n"+
				" order by b.rent_end_dt";
        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentEndCondAll_20070424_B]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


	 /**
     * 계약 현황 조회 - 대출신청용 (신차용만 조회)
     */
    public Vector getLoanCondAll(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4, String sort) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt4 = "to_char( add_months(sysdate, -1),'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

        
        // 출고예정일
        if(gubun2.equals("1")){     
			if(dt.equals("2"))								dt_query = " and nvl(p.dlv_est_dt,a.rent_dt) like "+s_dt2+"||'%'\n";
			else	if(dt.equals("4"))						dt_query = " and nvl(p.dlv_est_dt,a.rent_dt) like "+s_dt4+"||'%'\n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and nvl(p.dlv_est_dt,a.rent_dt) "+s_dt3+"\n";
		}
		
        query = " select\n"+
				" a.rent_mng_id, a.rent_l_cd, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, b.rent_start_dt, c.firm_nm, g.car_nm, \n"+
				" d.car_no,  b.con_mon, nvl(d.car_mng_id, '0') car_mng_id, decode(p.dlv_est_dt,null,'',substr(p.dlv_est_dt,1,4)||'-'||substr(p.dlv_est_dt,5,2)||'-'||substr(p.dlv_est_dt,7,2)) dlv_est_dt, \n"+
				" nvl(e.car_fs_amt, 0) + nvl(e.car_fv_amt, 0) - nvl(e.dc_cs_amt, 0)  - nvl(e.dc_cv_amt, 0)  + nvl(e.sd_cs_amt, 0)  + nvl(e.sd_cv_amt, 0) as car_amt, \n"+
		        " nvl(b.fee_s_amt, 0) + nvl(b.fee_v_amt,0) as fee_amt, ( nvl(b.fee_s_amt, 0) + nvl(b.fee_v_amt,0))*to_number(b.con_mon) as tot_fee_amt, \n"+
				" k.user_nm as bus_nm, l.user_nm as bus_nm2, decode(m.user_nm,l.user_nm,'',m.user_nm) as mng_nm, p.rpt_no ,p.cpt_cd \n"+
				" from cont a, fee b, client c, car_reg d, car_etc e, car_nm f, car_mng g, car_pur p, allot h,\n"+
				" (  select * from fine_doc_list where doc_id like '%총무%' ) fd, \n"+
				"      users k, users l, users m\n"+
				" where nvl(a.use_yn,'Y') ='Y' and a.car_st not in ('2','5')  and a.car_gu = '1' and a.rent_st in ( '1', '3', '4') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				dt_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd\n"+
				" and ( h.lend_id is null or h.lend_no is null )\n"+
				" and a.rent_mng_id=fd.rent_mng_id(+) and a.rent_l_cd=fd.rent_l_cd(+) \n"+
				" and fd.doc_id is null \n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)\n"+
				" and a.mng_id=m.user_id(+)";

		if(gubun3.equals("1") && !gubun4.equals("")) query += " and decode(b.rent_st,'1',a.bus_id,b.ext_agnt)='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";

		if(sort.equals("1"))		query += " order by nvl(p.dlv_est_dt,a.rent_dt)";
		else if(sort.equals("2"))	query += " order by b.rent_start_dt";
		else if(sort.equals("3"))	query += " order by c.firm_nm, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("4"))	query += " order by a.bus_id, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("5"))	query += " order by a.bus_st, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("6"))	query += " order by j.emp_nm, nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("7"))	query += " order by decode(a.rent_st,'2',1,'5',2,'6',3,'7',4,'3',5,'4',6,'1',7), nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("8"))	query += " order by to_number(b.con_mon)";

        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getLoanCondAll]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
    
    
    //대출관련 조회 - 팝업 엑셀 리스트2 (선택리스트)
	public Hashtable getLoanListExcel(String ch_m_id, String ch_l_cd, String ch_c_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
	
		query = " select\n"+
				" d.car_use, a.rent_mng_id, a.rent_l_cd, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, c.firm_nm,  g.car_nm, \n"+
				" d.car_no,  b.con_mon, nvl(d.car_mng_id,'0') car_mng_id, a.car_st, \n"+
				" nvl(e.car_fs_amt, 0) + nvl(e.car_fv_amt, 0) - nvl(e.dc_cs_amt, 0)  - nvl(e.dc_cv_amt, 0)  + nvl(e.sd_cs_amt, 0)  + nvl(e.sd_cv_amt, 0) as car_amt, \n"+
				" nvl(e.car_fs_amt, 0) - nvl(e.dc_cs_amt, 0)  + nvl(e.sd_cs_amt, 0) as car_s_amt, \n"+
				" nvl(e.car_fs_amt, 0) + nvl(e.car_fv_amt, 0)  as car_f_amt, \n"+ //차량가격 
				" nvl(e.dc_cs_amt, 0) + nvl(e.dc_cv_amt, 0)  as car_dc_amt, \n"+ //dc가격
				" nvl(e.ecar_pur_sub_amt, 0)  as ecar_pur_amt, \n"+ //구매보조금 
		        " nvl(b.fee_s_amt, 0) + nvl(b.fee_v_amt,0) as fee_amt, ( nvl(b.fee_s_amt, 0) + nvl(b.fee_v_amt,0))*to_number(b.con_mon) as tot_fee_amt, \n"+
				" k.user_nm as bus_nm, l.user_nm as bus_nm2, decode(m.user_nm,l.user_nm,'',m.user_nm) as mng_nm\n"+
				" from cont a, fee b, client c, car_reg d, car_etc e, car_nm f, car_mng g, allot h,\n"+
				"      users k, users l, users m\n"+
				" where nvl(a.use_yn, 'Y' ) ='Y' and a.car_st not in ('2','5')  and a.car_gu = '1' and a.rent_st in ( '1', '3', '4') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)\n"+
				" and a.mng_id=m.user_id(+)\n"+
				" and a.rent_mng_id = '"+ch_m_id+"'"+
				" and a.rent_l_cd = '"+ch_l_cd+"'";
		
		if (!ch_c_id.equals("0")) {
			query = query + " and a.car_mng_id = '"+ch_c_id+"'";
		}

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
			System.out.println("[ConditionDatabase:getLoanListExcel]\n"+e);
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
	
	  /**
     * 계약 현황 조회 ii
     */
    public Vector getRentCondAll_type2(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4, String sort) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//계약일
		if(gubun2.equals("1")){     
			if(dt.equals("1"))								dt_query = " and nvl(b.rent_dt,a.rent_dt)="+s_dt1+"\n";
			else if(dt.equals("2"))							dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt2+"||'%'\n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and nvl(b.rent_dt,a.rent_dt) "+s_dt3+"\n";
			
		//대여개시일
		}else{				
			if(dt.equals("1"))								dt_query = "and b.rent_start_dt="+s_dt1+"\n";
			else if(dt.equals("2"))							dt_query = "and b.rent_start_dt like "+s_dt2+"||'%'\n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = "and b.rent_start_dt "+s_dt3+"\n";
		}
        
        query = " select \n"+
				"        a.rent_mng_id, a.rent_l_cd, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, b.rent_start_dt, c.firm_nm, c.client_nm, cm.car_nm, cn.car_name,\n"+
				"        a.dlv_dt, d.init_reg_dt,  b.con_mon, (b.fee_s_amt + b.fee_v_amt) fee_amt, nvl(fe.sh_amt, 0) sh_amt,  \n"+
				"        nvl(e.car_cs_amt, 0) + nvl(e.car_cv_amt, 0) + nvl(e.opt_cs_amt, 0)  + nvl(e.opt_cv_amt, 0) + nvl(e.clr_cs_amt, 0)  + nvl(e.clr_cv_amt, 0) - nvl(e.tax_dc_s_amt,0) - nvl(e.tax_dc_v_amt,0) as car_amt,\n"+
				"        nvl(b.grt_amt_s,0) grt_amt_s, (nvl(b.pp_s_amt,0) + nvl(b.pp_v_amt,0)) pp_amt, (nvl(b.ifee_s_amt,0) + nvl(b.ifee_v_amt,0)) ifee_amt, \n"+
			    "        (b.OPT_S_AMT+b.OPT_v_amt) opt_amt, \n"+
				"        decode(b.rent_st,'1','','연장') ext_st, \n"+
				"        decode(a.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st,\n"+
				"        decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
				"        k.user_nm as bus_nm, l.user_nm as bus_nm2, decode(m.user_nm,l.user_nm,'',m.user_nm) as mng_nm, \n"+
				"        decode(b.rent_st,'1',decode(nvl(a.car_gu,a.reg_id),'1','신차','0','재리스','2','중고차'),'연장') car_gu, "+
				"        fe.agree_dist, g.b_agree_dist, DECODE(nvl(g.b_agree_dist,0),0,0,nvl(fe.agree_dist,0)-nvl(g.b_agree_dist,0)) cha_agree_dist, "+
				"        decode(e.tint_b_yn,'Y','블랙박스 ')||decode(e.tint_s_yn,'Y','전면썬팅 ')||decode(e.tint_n_yn,'Y','내비게이션 ') tint_bsn_yn, "+
				"        e.tint_b_yn, e.tint_s_yn, e.tint_n_yn, b.dc_ra, "+
				"        decode(a.rent_st,'1','신규','2','연장','3','대차','4','증차','5','연장','6','재리스','7','재리스') rent_st, "+
				"        decode(fe.return_select,'0','선택형','1','반납형') return_select, "+
				"		 ce.dir_pur_commi_yn, cn.jg_code \n"+
				" from   cont_n_view a, fee b, fee_etc fe, client c, car_reg d, car_etc e,  car_nm cn, car_mng cm, \n"+
				"        users k, users l, users m, estimate g, cont_etc ce \n"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2' , '4' , '5' )  and a.client_id not in ('000228','000231')\n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				"        and a.rent_mng_id=fe.rent_mng_id(+) and a.rent_l_cd=fe.rent_l_cd(+)\n"+			
				"        and a.fee_rent_st = fe.rent_st(+)\n"+
				dt_query +
				"        and a.client_id=c.client_id\n"+
				"        and a.car_mng_id=d.car_mng_id(+)\n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				"	     and e.car_id=cn.car_id  and  e.car_seq=cn.car_seq and cn.car_comp_id=cm.car_comp_id and cn.car_cd=cm.code \n"+
				"        and a.bus_id=k.user_id \n"+
				"        and a.bus_id2=l.user_id(+)\n"+
				"        and a.mng_id=m.user_id(+)"+
				"        and fe.bc_est_id=g.est_id"+
				"		 and a.rent_l_cd = ce.rent_l_cd and a.rent_mng_id = ce.rent_mng_id	\n"+
				" ";

		if(gubun3.equals("1")) query += " and nvl(a.car_gu,a.reg_id)='1' and b.rent_st = '1' ";
		if(gubun3.equals("2")) query += " and nvl(a.car_gu,a.reg_id)='0' and b.rent_st = '1'";
		if(gubun3.equals("3")) query += " and b.rent_st > '1'";

		if(!gubun4.equals("")) query += " and a.car_st = '"+gubun4+"'";
		
		if(sort.equals("1"))		query += " order by nvl(b.rent_dt,a.rent_dt) desc";
		else if(sort.equals("2"))	query += " order by b.rent_start_dt desc ";
		else if(sort.equals("7"))	query += " order by d.init_reg_dt desc  ";
		else if(sort.equals("8"))	query += " order by to_number(b.con_mon)";

        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentCondAll_type2]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
     * 계약 현황 20081119
     */
    public Vector getRentCondStatList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "", main_content = "";
		String dt1 = "", dt2 = "", dt3 = "", where1 = "", where2 = "", where3 = "", query1 = "", query2 = "", query3 = "";

		//계약일||개시일|| 출고일
		if(gubun1.equals("1")){
			dt1 = "substr(decode(b.rent_st,'1',a.rent_dt,b.rent_dt),1,6)";
			dt2 = "substr(decode(b.rent_st,'1',a.rent_dt,b.rent_dt),1,4)";
			dt3 = "decode(b.rent_st,'1',a.rent_dt,b.rent_dt)";
		}else if(gubun1.equals("2")){
			dt1 = "substr(b.rent_start_dt,1,6)";
			dt2 = "substr(b.rent_start_dt,1,4)";
			dt3 = "b.rent_start_dt";
		}else if(gubun1.equals("4")){
			dt1 = "substr(a.dlv_dt,1,6)";
			dt2 = "substr(a.dlv_dt,1,4)";
			dt3 = "a.dlv_dt";
		}

		//월별||년별
		if(!gubun3.equals("")){
			where1 = " and "+dt3+" like '"+gubun2+""+gubun3+"%'";
			where2 = " and "+dt3+" like to_char(add_months(to_date('"+gubun2+""+gubun3+"','YYYYMM'),-1),'YYYYMM')||'%' ";
			where3 = " and "+dt3+" like to_char(add_months(to_date('"+gubun2+""+gubun3+"','YYYYMM'),-12),'YYYYMM')||'%' ";
		}else{
			where1 = " and "+dt3+" like '"+gubun2+"%'";
			where2 = " and "+dt3+" like to_char(add_months(to_date('"+gubun2+"','YYYY'),-12),'YYYY')||'%' ";
			where3 = " and "+dt3+" like to_char(add_months(to_date('"+gubun2+"','YYYY'),-24),'YYYY')||'%' ";				
		}

		if(!gubun4.equals("")){
			if(gubun4.equals("S1")){
				where1 += " and a.brch_id in ('S1','K1','K2')";
				where2 += " and a.brch_id in ('S1','K1','K2')";
				where3 += " and a.brch_id in ('S1','K1','K2')";
			}else if(gubun4.equals("B1")){
				where1 += " and a.brch_id in ('B1','N1')";
				where2 += " and a.brch_id in ('B1','N1')";
				where3 += " and a.brch_id in ('B1','N1')";
			}else{
				where1 += " and a.brch_id = '"+gubun4+"'";
				where2 += " and a.brch_id = '"+gubun4+"'";
				where3 += " and a.brch_id = '"+gubun4+"'";
			}
		}


		if(!t_wd.equals("") && !s_kd.equals("")){
			if(s_kd.equals("1")){
				where1 += " and decode(b.rent_st,'1',a.bus_id,b.ext_agnt) = '"+t_wd+"'";
				where2 += " and decode(b.rent_st,'1',a.bus_id,b.ext_agnt) = '"+t_wd+"'";
				where3 += " and decode(b.rent_st,'1',a.bus_id,b.ext_agnt) = '"+t_wd+"'";
			}else if(s_kd.equals("2")){
				where1 += " and a.bus_id2 = '"+t_wd+"'";
				where2 += " and a.bus_id2 = '"+t_wd+"'";
				where3 += " and a.bus_id2 = '"+t_wd+"'";
			}else if(s_kd.equals("3")){
				where1 += " and nvl(a.mng_id,a.bus_id2) = '"+t_wd+"'";
				where2 += " and nvl(a.mng_id,a.bus_id2) = '"+t_wd+"'";
				where3 += " and nvl(a.mng_id,a.bus_id2) = '"+t_wd+"'";
			}
		}


		main_content = " select "+
				" count(decode(a.car_st,'1',a.rent_l_cd)) r_cont,"+
				" count(decode(a.car_st,'1',decode(b.rent_st||a.car_gu,'11',a.rent_l_cd))) rb_cont,"+
				" count(decode(a.car_st,'1',case when b.con_mon < 6 then a.rent_l_cd else '' end)) r_5,"+
				" count(decode(a.car_st,'1',case when b.con_mon < 12 AND b.con_mon >= 6 then a.rent_l_cd else '' end)) r_6,"+
				" count(decode(a.car_st,'1',decode(b.con_mon,'12',a.rent_l_cd))) r_12,"+
				" count(decode(a.car_st,'1',decode(b.con_mon,'24',a.rent_l_cd))) r_24,"+
				" count(decode(a.car_st,'1',decode(b.con_mon,'36',a.rent_l_cd))) r_36,"+
				" count(decode(a.car_st,'1',decode(b.con_mon,'48',a.rent_l_cd))) r_48,"+
				" count(decode(a.car_st,'1',decode(b.con_mon,'60',a.rent_l_cd))) r_60,"+
				" count(decode(a.car_st,'1',decode(b.con_mon,'12','','24','','36','','48','','60','',case when b.con_mon > 12 then a.rent_l_cd else '' end))) r_99,"+
				" count(decode(a.car_st,'1',decode(b.rent_way,'1',a.rent_l_cd))) r_s,"+
				" count(decode(a.car_st,'1',decode(b.rent_way,'1','',a.rent_l_cd))) r_b,"+
				" sum  (decode(a.car_st,'1',b.fee_s_amt)) r_mfee,"+
				" sum  (decode(a.car_st,'1',(b.fee_s_amt*b.con_mon)+b.ifee_s_amt+b.pp_s_amt)) r_tfee,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'6', decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) r_bus1,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'3', decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) r_bus2,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'1', decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) r_bus3,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'5', decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) r_bus4,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'4', decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) r_bus5,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'2', decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) r_bus6,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'7', decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) r_bus7,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'8', decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) r_bus9,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'2', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd))))) r_bus61,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'2', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd))))) r_bus62,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'2', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd))))) r_bus63,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'7', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd))))) r_bus71,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'7', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd))))) r_bus72,"+
				" count(decode(a.car_st,'1',decode(a.bus_st,'7', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd))))) r_bus73,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1',decode(a.car_gu,'1',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd))))) r_rent11,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1',decode(a.car_gu,'1',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd))))) r_rent12,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1',decode(a.car_gu,'1',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd))))) r_rent13,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1',decode(a.car_gu,'0',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd))))) r_rent21,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1',decode(a.car_gu,'0',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd))))) r_rent22,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1',decode(a.car_gu,'0',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd))))) r_rent23,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1',decode(a.car_gu,'2',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd))))) r_rent31,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1',decode(a.car_gu,'2',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd))))) r_rent32,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1',decode(a.car_gu,'2',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd))))) r_rent33,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1','',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd)))) r_rent41,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1','',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd)))) r_rent42,"+
				" count(decode(a.car_st,'1',decode(b.rent_st,'1','',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd)))) r_rent43,"+
				" count(decode(a.car_st,'3',a.rent_l_cd)) l_cont,"+
				" count(decode(a.car_st,'3',decode(b.rent_st||a.car_gu,'11',a.rent_l_cd))) lb_cont,"+
				" count(decode(a.car_st,'3',case when b.con_mon < 6 then a.rent_l_cd else '' end)) l_5,"+
				" count(decode(a.car_st,'3',case when b.con_mon < 12 AND b.con_mon >= 6 then a.rent_l_cd else '' end)) l_6,"+
				" count(decode(a.car_st,'3',decode(b.con_mon,'12',a.rent_l_cd))) l_12,"+
				" count(decode(a.car_st,'3',decode(b.con_mon,'24',a.rent_l_cd))) l_24,"+
				" count(decode(a.car_st,'3',decode(b.con_mon,'36',a.rent_l_cd))) l_36,"+
				" count(decode(a.car_st,'3',decode(b.con_mon,'48',a.rent_l_cd))) l_48,"+
				" count(decode(a.car_st,'3',decode(b.con_mon,'60',a.rent_l_cd))) l_60,"+
				" count(decode(a.car_st,'3',decode(b.con_mon,'12','','24','','36','','48','','60','',case when b.con_mon > 12 then a.rent_l_cd else '' end))) l_99,"+
				" count(decode(a.car_st,'3',decode(b.rent_way,'1',a.rent_l_cd))) l_s,"+
				" count(decode(a.car_st,'3',decode(b.rent_way,'1','',a.rent_l_cd))) l_b,"+
				" sum  (decode(a.car_st,'3',b.fee_s_amt)) l_mfee,"+
				" sum  (decode(a.car_st,'3',(b.fee_s_amt*b.con_mon)+b.ifee_s_amt+b.pp_s_amt)) l_tfee,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'6',decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) l_bus1,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'3',decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) l_bus2,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'1',decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) l_bus3,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'5',decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) l_bus4,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'4',decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) l_bus5,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'2',decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) l_bus6,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'7',decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) l_bus7,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'8',decode(b.rent_st||a.car_gu,'11',a.rent_l_cd)))) l_bus9,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'2', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd))))) l_bus61,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'2', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd))))) l_bus62,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'2', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd))))) l_bus63,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'7', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd))))) l_bus71,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'7', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd))))) l_bus72,"+
				" count(decode(a.car_st,'3',decode(a.bus_st,'7', decode(b.rent_st||a.car_gu,'11',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd))))) l_bus73,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1',decode(a.car_gu,'1',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd))))) l_rent11,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1',decode(a.car_gu,'1',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd))))) l_rent12,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1',decode(a.car_gu,'1',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd))))) l_rent13,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1',decode(a.car_gu,'0',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd))))) l_rent21,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1',decode(a.car_gu,'0',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd))))) l_rent22,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1',decode(a.car_gu,'0',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd))))) l_rent23,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1',decode(a.car_gu,'2',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd))))) l_rent31,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1',decode(a.car_gu,'2',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd))))) l_rent32,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1',decode(a.car_gu,'2',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd))))) l_rent33,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1','',decode(decode(a.rent_st,'4','4','3','3','1'),'1',a.rent_l_cd)))) l_rent41,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1','',decode(decode(a.rent_st,'4','4','3','3','1'),'4',a.rent_l_cd)))) l_rent42,"+
				" count(decode(a.car_st,'3',decode(b.rent_st,'1','',decode(decode(a.rent_st,'4','4','3','3','1'),'3',a.rent_l_cd)))) l_rent43";

		if(gubun1.equals("3")){
			main_content += " from cont a, fee b, cls_cont c, users e, users f, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) b2"+
				" where"+
				" a.car_st in ('1','3') and a.client_id not in ('000228','000231')"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') not in ('7','10')"+
				" and a.bus_id=e.user_id(+) and b.ext_agnt=f.user_id(+)"+
				" and b.rent_mng_id=b2.rent_mng_id and b.rent_l_cd=b2.rent_l_cd and b.rent_st=b2.rent_st "+	
				" ";
		}else{
			main_content += " from cont a, fee b, cls_cont c, cls_cont d, users e, users f, fee_etc h, (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) g "+
				" where"+
				" a.car_st in ('1','3') and a.client_id not in ('000228','000231')"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and nvl(c.cls_st,'0') not in ('7','10')"+
				" and a.rent_mng_id=d.rent_mng_id(+) and a.reg_dt=d.reg_dt(+) "+
				" and a.bus_id=e.user_id(+) and b.ext_agnt=f.user_id(+)"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=g.rent_mng_id(+) and a.reg_dt=g.reg_dt(+) \n"+
				"        and case when g.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),g.reg_dt)  then '' else g.rent_l_cd end is null \n"+
				" ";
		}

		
		if(gubun1.equals("3")){
				where1 = " and nvl(a.use_yn,'Y')= 'Y'";
				where2 = " and nvl(a.use_yn,'Y')= 'Y'";
				where3 = " and nvl(a.use_yn,'Y')= 'Y'";			
		}

		query1= " "+main_content+" "+" "+where1;
		query2= " "+main_content+" "+" "+where2;
		query3= " "+main_content+" "+" "+where3;



		query = " "+
				"		select a.*, "+
				"		a.r_5+a.l_5 as t_5, a.r_6+a.l_6 as t_6, a.r_12+a.l_12 as t_12, a.r_24+a.l_24 as t_24, a.r_36+a.l_36 as t_36, a.r_48+a.l_48 as t_48, a.r_60+a.l_60 as t_60, a.r_99+a.l_99 as t_99, "+
				"		a.r_cont+a.l_cont as t_cont, a.rb_cont+a.lb_cont as tb_cont, "+
				"		a.r_s+a.l_s as t_s, a.r_b+a.l_b as t_b, nvl(a.r_mfee,0)+nvl(a.l_mfee,0) as t_mfee, nvl(a.r_tfee,0)+nvl(a.l_tfee,0) as t_tfee, "+
				"		a.r_bus1+a.l_bus1 as t_bus1, a.r_bus2+a.l_bus2 as t_bus2, a.r_bus3+a.l_bus3 as t_bus3, a.r_bus4+a.l_bus4 as t_bus4, "+
				"		a.r_bus5+a.l_bus5 as t_bus5, a.r_bus6+a.l_bus6 as t_bus6, a.r_bus7+a.l_bus7 as t_bus7, a.r_bus9+a.l_bus9 as t_bus9, "+
				"		a.r_bus61+a.l_bus61 as t_bus61, a.r_bus62+a.l_bus62 as t_bus62, a.r_bus63+a.l_bus63 as t_bus63, "+
				"		a.r_bus71+a.l_bus71 as t_bus71, a.r_bus72+a.l_bus72 as t_bus72, a.r_bus73+a.l_bus73 as t_bus73, "+
				"		a.r_rent11+a.l_rent11 as t_rent11, a.r_rent12+a.l_rent12 as t_rent12, a.r_rent13+a.l_rent13 as t_rent13, "+
				"		a.r_rent21+a.l_rent21 as t_rent21, a.r_rent22+a.l_rent22 as t_rent22, a.r_rent23+a.l_rent23 as t_rent23, "+
				"		a.r_rent31+a.l_rent31 as t_rent31, a.r_rent32+a.l_rent32 as t_rent32, a.r_rent33+a.l_rent33 as t_rent33, "+
				"		a.r_rent41+a.l_rent41 as t_rent41, a.r_rent42+a.l_rent42 as t_rent42, a.r_rent43+a.l_rent43 as t_rent43, "+
				"		0 hr_5, 0 hr_6, 0 hr_12, 0 hr_24, 0 hr_36, 0 hr_48, 0 hr_60, 0 hr_99, 0 hr_cont, 0 hr_s, 0 hr_b, 0 hr_mfee, 0 hr_tfee, "+
				"		0 hr_bus1, 0 hr_bus2, 0 hr_bus3, 0 hr_bus4, 0 hr_bus5, 0 hr_bus6, 0 hr_bus7, 0 hr_bus8, 0 hr_bus9, "+
				"       0 hr_bus61, 0 hr_bus62, 0 hr_bus63, "+
				"       0 hr_bus71, 0 hr_bus72, 0 hr_bus73, "+
				"		0 hr_rent11, 0 hr_rent12, 0 hr_rent13, 0 hr_rent21, 0 hr_rent22, 0 hr_rent23, "+
				"		0 hr_rent31, 0 hr_rent32, 0 hr_rent33, 0 hr_rent41, 0 hr_rent42, 0 hr_rent43, "+
				"		0 hl_5, 0 hl_6, 0 hl_12, 0 hl_24, 0 hl_36, 0 hl_48, 0 hl_60, 0 hl_99, 0 hl_cont, 0 hl_s, 0 hl_b, 0 hl_mfee, 0 hl_tfee, "+
				"		0 hl_bus1, 0 hl_bus2, 0 hl_bus3, 0 hl_bus4, 0 hl_bus5, 0 hl_bus6, 0 hl_bus7, 0 hl_bus8, 0 hl_bus9, "+
				"       0 hl_bus61, 0 hl_bus62, 0 hl_bus63, "+
				"       0 hl_bus71, 0 hl_bus72, 0 hl_bus73, "+
				"		0 hl_rent11, 0 hl_rent12, 0 hl_rent13, 0 hl_rent21, 0 hl_rent22, 0 hl_rent23, "+
				"		0 hl_rent31, 0 hl_rent32, 0 hl_rent33, 0 hl_rent41, 0 hl_rent42, 0 hl_rent43, "+
				"		0 hr_rent51, 0 hr_rent52, 0 hr_rent53, 0 hl_rent51, 0 hl_rent52, 0 hl_rent53 "+
				"		from ("+main_content+" "+" "+where1+") a "+
				"		union all "+
				"		select a.*, "+
				"		a.r_5+a.l_5 as t_5, a.r_6+a.l_6 as t_6, a.r_12+a.l_12 as t_12, a.r_24+a.l_24 as t_24, a.r_36+a.l_36 as t_36, a.r_48+a.l_48 as t_48, a.r_60+a.l_60 as t_60, a.r_99+a.l_99 as t_99, "+
				"		a.r_cont+a.l_cont as t_cont, a.rb_cont+a.lb_cont as tb_cont, "+
				"		a.r_s+a.l_s as t_s, a.r_b+a.l_b as t_b, nvl(a.r_mfee,0)+nvl(a.l_mfee,0) as t_mfee, nvl(a.r_tfee,0)+nvl(a.l_tfee,0) as t_tfee, "+
				"		a.r_bus1+a.l_bus1 as t_bus1, a.r_bus2+a.l_bus2 as t_bus2, a.r_bus3+a.l_bus3 as t_bus3, a.r_bus4+a.l_bus4 as t_bus4, "+
				"		a.r_bus5+a.l_bus5 as t_bus5, a.r_bus6+a.l_bus6 as t_bus6, a.r_bus7+a.l_bus7 as t_bus7, a.r_bus9+a.l_bus9 as t_bus9, "+
				"		a.r_bus61+a.l_bus61 as t_bus61, a.r_bus62+a.l_bus62 as t_bus62, a.r_bus63+a.l_bus63 as t_bus63, "+
				"		a.r_bus71+a.l_bus71 as t_bus71, a.r_bus72+a.l_bus72 as t_bus72, a.r_bus73+a.l_bus73 as t_bus73, "+
				"		a.r_rent11+a.l_rent11 as t_rent11, a.r_rent12+a.l_rent12 as t_rent12, a.r_rent13+a.l_rent13 as t_rent13, "+
				"		a.r_rent21+a.l_rent21 as t_rent21, a.r_rent22+a.l_rent22 as t_rent22, a.r_rent23+a.l_rent23 as t_rent23, "+
				"		a.r_rent31+a.l_rent31 as t_rent31, a.r_rent32+a.l_rent32 as t_rent32, a.r_rent33+a.l_rent33 as t_rent33, "+
				"		a.r_rent41+a.l_rent41 as t_rent41, a.r_rent42+a.l_rent42 as t_rent42, a.r_rent43+a.l_rent43 as t_rent43, "+
				"		trunc(decode(a.r_5,0,0,b.r_5/a.r_5)*100,0) as hr_5, trunc(decode(a.r_6,0,0,b.r_6/a.r_6)*100,0) as hr_6,  "+
				"		trunc(decode(a.r_12,0,0,b.r_12/a.r_12)*100,0) as hr_12, trunc(decode(a.r_24,0,0,b.r_24/a.r_24)*100,0) as hr_24, trunc(decode(a.r_36,0,0,b.r_36/a.r_36)*100,0) as hr_36, "+
				"		trunc(decode(a.r_48,0,0,b.r_48/a.r_48)*100,0) as hr_48, trunc(decode(a.r_60,0,0,b.r_60/a.r_60)*100,0) as hr_60, trunc(decode(a.r_99,0,0,b.r_99/a.r_99)*100,0) as hr_99, trunc(decode(a.r_cont,0,0,b.r_cont/a.r_cont)*100,0) as hr_cont, "+
				"		trunc(decode(a.r_s,0,0,b.r_s/a.r_s)*100,0) as hr_s,     trunc(decode(a.r_b,0,0,b.r_b/a.r_b)*100,0) as hr_b,     trunc(decode(a.r_mfee,0,0,b.r_mfee/a.r_mfee)*100,0) as hr_mfee, trunc(decode(a.r_tfee,0,0,b.r_tfee/a.r_tfee)*100,0) as hr_tfee, "+
				"		trunc(decode(a.r_bus1,0,0,b.r_bus1/a.r_bus1)*100,0) as hr_bus1, trunc(decode(a.r_bus2,0,0,b.r_bus2/a.r_bus2)*100,0) as hr_bus2, "+
				"		trunc(decode(a.r_bus3,0,0,b.r_bus3/a.r_bus3)*100,0) as hr_bus3, trunc(decode(a.r_bus4,0,0,b.r_bus4/a.r_bus4)*100,0) as hr_bus4, "+
				"		trunc(decode(a.r_bus5,0,0,b.r_bus5/a.r_bus5)*100,0) as hr_bus5, trunc(decode(a.r_bus6,0,0,b.r_bus6/a.r_bus6)*100,0) as hr_bus6, "+
				"       trunc(decode(a.r_bus7,0,0,b.r_bus7/a.r_bus7)*100,0) as hr_bus7, 0 hr_bus8, trunc(decode(a.r_bus9,0,0,b.r_bus9/a.r_bus9)*100,0) as hr_bus9, "+
				"       trunc(decode(a.r_bus61,0,0,b.r_bus61/a.r_bus61)*100,0) as hr_bus61,"+
				"       trunc(decode(a.r_bus62,0,0,b.r_bus62/a.r_bus62)*100,0) as hr_bus62,"+
				"       trunc(decode(a.r_bus63,0,0,b.r_bus63/a.r_bus63)*100,0) as hr_bus63,"+
				"       trunc(decode(a.r_bus71,0,0,b.r_bus71/a.r_bus71)*100,0) as hr_bus71,"+
				"       trunc(decode(a.r_bus72,0,0,b.r_bus72/a.r_bus72)*100,0) as hr_bus72,"+
				"       trunc(decode(a.r_bus73,0,0,b.r_bus73/a.r_bus73)*100,0) as hr_bus73,"+
				"		trunc(decode(a.r_rent11,0,0,b.r_rent11/a.r_rent11)*100,0) as hr_rent11, trunc(decode(a.r_rent12,0,0,b.r_rent12/a.r_rent12)*100,0) as hr_rent12, "+
				"		trunc(decode(a.r_rent13,0,0,b.r_rent13/a.r_rent13)*100,0) as hr_rent13, trunc(decode(a.r_rent21,0,0,b.r_rent21/a.r_rent21)*100,0) as hr_rent21, "+
				"		trunc(decode(a.r_rent22,0,0,b.r_rent22/a.r_rent22)*100,0) as hr_rent22, trunc(decode(a.r_rent23,0,0,b.r_rent23/a.r_rent23)*100,0) as hr_rent23, "+
				"		trunc(decode(a.r_rent31,0,0,b.r_rent31/a.r_rent31)*100,0) as hr_rent31, trunc(decode(a.r_rent32,0,0,b.r_rent32/a.r_rent32)*100,0) as hr_rent32, "+
				"		trunc(decode(a.r_rent33,0,0,b.r_rent33/a.r_rent33)*100,0) as hr_rent33, trunc(decode(a.r_rent41,0,0,b.r_rent41/a.r_rent41)*100,0) as hr_rent41, "+
				"		trunc(decode(a.r_rent42,0,0,b.r_rent42/a.r_rent42)*100,0) as hr_rent42, trunc(decode(a.r_rent43,0,0,b.r_rent43/a.r_rent43)*100,0) as hr_rent43, "+
				"		trunc(decode(a.l_5,0,0,b.l_5/a.l_5)*100,0) as hl_5, trunc(decode(a.l_6,0,0,b.l_6/a.l_6)*100,0) as hl_6,  "+
				"		trunc(decode(a.l_12,0,0,b.l_12/a.l_12)*100,0) as hl_12, trunc(decode(a.l_24,0,0,b.l_24/a.l_24)*100,0) as hl_24, trunc(decode(a.l_36,0,0,b.l_36/a.l_36)*100,0) as hl_36, "+
				"		trunc(decode(a.l_48,0,0,b.l_48/a.l_48)*100,0) as hl_48, trunc(decode(a.l_60,0,0,b.l_60/a.l_60)*100,0) as hl_60, trunc(decode(a.l_99,0,0,b.l_99/a.l_99)*100,0) as hl_99, trunc(decode(a.l_cont,0,0,b.l_cont/a.l_cont)*100,0) as hl_cont, "+
				"		trunc(decode(a.l_s,0,0,b.l_s/a.l_s)*100,0) as hl_s,     trunc(decode(a.l_b,0,0,b.l_b/a.l_b)*100,0) as hl_b,     trunc(decode(a.l_mfee,0,0,b.l_mfee/a.l_mfee)*100,0) as hl_mfee, trunc(decode(a.l_tfee,0,0,b.l_tfee/a.l_tfee)*100,0) as hl_tfee, "+
				"		trunc(decode(a.l_bus1,0,0,b.l_bus1/a.l_bus1)*100,0) as hl_bus1, trunc(decode(a.l_bus2,0,0,b.l_bus2/a.l_bus2)*100,0) as hl_bus2, "+
				"		trunc(decode(a.l_bus3,0,0,b.l_bus3/a.l_bus3)*100,0) as hl_bus3, trunc(decode(a.l_bus4,0,0,b.l_bus4/a.l_bus4)*100,0) as hl_bus4, "+
				"		trunc(decode(a.l_bus5,0,0,b.l_bus5/a.l_bus5)*100,0) as hl_bus5, trunc(decode(a.l_bus6,0,0,b.l_bus6/a.l_bus6)*100,0) as hl_bus6, "+
				"       trunc(decode(a.l_bus7,0,0,b.l_bus7/a.l_bus7)*100,0) as hl_bus7, 0 hl_bus8, trunc(decode(a.l_bus9,0,0,b.l_bus9/a.l_bus9)*100,0) as hl_bus9, "+
				"       trunc(decode(a.l_bus61,0,0,b.l_bus61/a.l_bus61)*100,0) as hl_bus61,"+
				"       trunc(decode(a.l_bus62,0,0,b.l_bus62/a.l_bus62)*100,0) as hl_bus62,"+
				"       trunc(decode(a.l_bus63,0,0,b.l_bus63/a.l_bus63)*100,0) as hl_bus63,"+
				"       trunc(decode(a.l_bus71,0,0,b.l_bus71/a.l_bus71)*100,0) as hl_bus71,"+
				"       trunc(decode(a.l_bus72,0,0,b.l_bus72/a.l_bus72)*100,0) as hl_bus72,"+
				"       trunc(decode(a.l_bus73,0,0,b.l_bus73/a.l_bus73)*100,0) as hl_bus73,"+
				"		trunc(decode(a.l_rent11,0,0,b.l_rent11/a.l_rent11)*100,0) as hl_rent11, trunc(decode(a.l_rent12,0,0,b.l_rent12/a.l_rent12)*100,0) as hl_rent12, "+
				"		trunc(decode(a.l_rent13,0,0,b.l_rent13/a.l_rent13)*100,0) as hl_rent13, trunc(decode(a.l_rent21,0,0,b.l_rent21/a.l_rent21)*100,0) as hl_rent21, "+
				"		trunc(decode(a.l_rent22,0,0,b.l_rent22/a.l_rent22)*100,0) as hl_rent22, trunc(decode(a.l_rent23,0,0,b.l_rent23/a.l_rent23)*100,0) as hl_rent23, "+
				"		trunc(decode(a.l_rent31,0,0,b.l_rent31/a.l_rent31)*100,0) as hl_rent31, trunc(decode(a.l_rent32,0,0,b.l_rent32/a.l_rent32)*100,0) as hl_rent32, "+
				"		trunc(decode(a.l_rent33,0,0,b.l_rent33/a.l_rent33)*100,0) as hl_rent33, trunc(decode(a.l_rent41,0,0,b.l_rent41/a.l_rent41)*100,0) as hl_rent41, "+
				"		trunc(decode(a.l_rent42,0,0,b.l_rent42/a.l_rent42)*100,0) as hl_rent42, trunc(decode(a.l_rent43,0,0,b.l_rent43/a.l_rent43)*100,0) as hl_rent43, "+				
				"		trunc(decode((a.r_rent11+a.r_rent21+a.r_rent31+a.r_rent41),0,0,(b.r_rent11+b.r_rent21+b.r_rent31+b.r_rent41)/(a.r_rent11+a.r_rent21+a.r_rent31+a.r_rent41))*100,0) hr_rent51,"+
				"		trunc(decode((a.r_rent12+a.r_rent22+a.r_rent32+a.r_rent42),0,0,(b.r_rent12+b.r_rent22+b.r_rent32+b.r_rent42)/(a.r_rent12+a.r_rent22+a.r_rent32+a.r_rent42))*100,0) hr_rent52,"+
				"		trunc(decode((a.r_rent13+a.r_rent23+a.r_rent33+a.r_rent43),0,0,(b.r_rent13+b.r_rent23+b.r_rent33+b.r_rent43)/(a.r_rent13+a.r_rent23+a.r_rent33+a.r_rent43))*100,0) hr_rent53,"+
				"		trunc(decode((a.l_rent11+a.l_rent21+a.l_rent31+a.l_rent41),0,0,(b.l_rent11+b.l_rent21+b.l_rent31+b.l_rent41)/(a.l_rent11+a.l_rent21+a.l_rent31+a.l_rent41))*100,0) hl_rent51,"+
				"		trunc(decode((a.l_rent12+a.l_rent22+a.l_rent32+a.l_rent42),0,0,(b.l_rent12+b.l_rent22+b.l_rent32+b.l_rent42)/(a.l_rent12+a.l_rent22+a.l_rent32+a.l_rent42))*100,0) hl_rent52,"+
				"		trunc(decode((a.l_rent13+a.l_rent23+a.l_rent33+a.l_rent43),0,0,(b.l_rent13+b.l_rent23+b.l_rent33+b.l_rent43)/(a.l_rent13+a.l_rent23+a.l_rent33+a.l_rent43))*100,0) hl_rent53"+
				"		from ("+main_content+" "+" "+where2+") a, ("+main_content+" "+" "+where1+") b "+//
				"		union all "+
				"		select a.*, "+
				"		a.r_5+a.l_5 as t_5, a.r_6+a.l_6 as t_6, a.r_12+a.l_12 as t_12, a.r_24+a.l_24 as t_24, a.r_36+a.l_36 as t_36, a.r_48+a.l_48 as t_48, a.r_60+a.l_60 as t_60, "+
				"		a.r_99+a.l_99 as t_99, a.r_cont+a.l_cont as t_cont, a.rb_cont+a.lb_cont as tb_cont, "+
				"		a.r_s+a.l_s as t_s, a.r_b+a.l_b as t_b, nvl(a.r_mfee,0)+nvl(a.l_mfee,0) as t_mfee, nvl(a.r_tfee,0)+nvl(a.l_tfee,0) as t_tfee, "+
				"		a.r_bus1+a.l_bus1 as t_bus1, a.r_bus2+a.l_bus2 as t_bus2, a.r_bus3+a.l_bus3 as t_bus3, a.r_bus4+a.l_bus4 as t_bus4, "+
				"		a.r_bus5+a.l_bus5 as t_bus5, a.r_bus6+a.l_bus6 as t_bus6, a.r_bus7+a.l_bus7 as t_bus7, a.r_bus9+a.l_bus9 as t_bus9, "+
				"		a.r_bus61+a.l_bus61 as t_bus61, a.r_bus62+a.l_bus62 as t_bus62, a.r_bus63+a.l_bus63 as t_bus63, "+
				"		a.r_bus71+a.l_bus71 as t_bus71, a.r_bus72+a.l_bus72 as t_bus72, a.r_bus73+a.l_bus73 as t_bus73, "+
				"		a.r_rent11+a.l_rent11 as t_rent11, a.r_rent12+a.l_rent12 as t_rent12, a.r_rent13+a.l_rent13 as t_rent13, "+
				"		a.r_rent21+a.l_rent21 as t_rent21, a.r_rent22+a.l_rent22 as t_rent22, a.r_rent23+a.l_rent23 as t_rent23, "+
				"		a.r_rent31+a.l_rent31 as t_rent31, a.r_rent32+a.l_rent32 as t_rent32, a.r_rent33+a.l_rent33 as t_rent33, "+
				"		a.r_rent41+a.l_rent41 as t_rent41, a.r_rent42+a.l_rent42 as t_rent42, a.r_rent43+a.l_rent43 as t_rent43, "+
				"		trunc(decode(a.r_5,0,0,b.r_5/a.r_5)*100,0) as hr_5, trunc(decode(a.r_6,0,0,b.r_6/a.r_6)*100,0) as hr_6,  "+
				"		trunc(decode(a.r_12,0,0,b.r_12/a.r_12)*100,0) as hr_12, trunc(decode(a.r_24,0,0,b.r_24/a.r_24)*100,0) as hr_24, trunc(decode(a.r_36,0,0,b.r_36/a.r_36)*100,0) as hr_36, "+
				"		trunc(decode(a.r_48,0,0,b.r_48/a.r_48)*100,0) as hr_48, trunc(decode(a.r_60,0,0,b.r_60/a.r_60)*100,0) as hr_60, trunc(decode(a.r_99,0,0,b.r_99/a.r_99)*100,0) as hr_99, trunc(decode(a.r_cont,0,0,b.r_cont/a.r_cont)*100,0) as hr_cont, "+
				"		trunc(decode(a.r_s,0,0,b.r_s/a.r_s)*100,0) as hr_s,     trunc(decode(a.r_b,0,0,b.r_b/a.r_b)*100,0) as hr_b,     trunc(decode(a.r_mfee,0,0,b.r_mfee/a.r_mfee)*100,0) as hr_mfee, trunc(decode(a.r_tfee,0,0,b.r_tfee/a.r_tfee)*100,0) as hr_tfee, "+
				"		trunc(decode(a.r_bus1,0,0,b.r_bus1/a.r_bus1)*100,0) as hr_bus1, trunc(decode(a.r_bus2,0,0,b.r_bus2/a.r_bus2)*100,0) as hr_bus2, "+
				"		trunc(decode(a.r_bus3,0,0,b.r_bus3/a.r_bus3)*100,0) as hr_bus3, trunc(decode(a.r_bus4,0,0,b.r_bus4/a.r_bus4)*100,0) as hr_bus4, "+
				"		trunc(decode(a.r_bus5,0,0,b.r_bus5/a.r_bus5)*100,0) as hr_bus5, trunc(decode(a.r_bus6,0,0,b.r_bus6/a.r_bus6)*100,0) as hr_bus6, "+
				"	    trunc(decode(a.r_bus7,0,0,b.r_bus7/a.r_bus7)*100,0) as hr_bus7, 0 hr_bus8, trunc(decode(a.r_bus9,0,0,b.r_bus9/a.r_bus9)*100,0) as hr_bus9, "+
				"       trunc(decode(a.r_bus61,0,0,b.r_bus61/a.r_bus61)*100,0) as hr_bus61,"+
				"       trunc(decode(a.r_bus62,0,0,b.r_bus62/a.r_bus62)*100,0) as hr_bus62,"+
				"       trunc(decode(a.r_bus63,0,0,b.r_bus63/a.r_bus63)*100,0) as hr_bus63,"+
				"       trunc(decode(a.r_bus71,0,0,b.r_bus71/a.r_bus71)*100,0) as hr_bus71,"+
				"       trunc(decode(a.r_bus72,0,0,b.r_bus72/a.r_bus72)*100,0) as hr_bus72,"+
				"       trunc(decode(a.r_bus73,0,0,b.r_bus73/a.r_bus73)*100,0) as hr_bus73,"+
				"		trunc(decode(a.r_rent11,0,0,b.r_rent11/a.r_rent11)*100,0) as hr_rent11, trunc(decode(a.r_rent12,0,0,b.r_rent12/a.r_rent12)*100,0) as hr_rent12, "+
				"		trunc(decode(a.r_rent13,0,0,b.r_rent13/a.r_rent13)*100,0) as hr_rent13, trunc(decode(a.r_rent21,0,0,b.r_rent21/a.r_rent21)*100,0) as hr_rent21, "+
				"		trunc(decode(a.r_rent22,0,0,b.r_rent22/a.r_rent22)*100,0) as hr_rent22, trunc(decode(a.r_rent23,0,0,b.r_rent23/a.r_rent23)*100,0) as hr_rent23, "+
				"		trunc(decode(a.r_rent31,0,0,b.r_rent31/a.r_rent31)*100,0) as hr_rent31, trunc(decode(a.r_rent32,0,0,b.r_rent32/a.r_rent32)*100,0) as hr_rent32, "+
				"		trunc(decode(a.r_rent33,0,0,b.r_rent33/a.r_rent33)*100,0) as hr_rent33, trunc(decode(a.r_rent41,0,0,b.r_rent41/a.r_rent41)*100,0) as hr_rent41, "+
				"		trunc(decode(a.r_rent42,0,0,b.r_rent42/a.r_rent42)*100,0) as hr_rent42, trunc(decode(a.r_rent43,0,0,b.r_rent43/a.r_rent43)*100,0) as hr_rent43, "+
				"		trunc(decode(a.l_5,0,0,b.l_5/a.l_5)*100,0) as hl_5, trunc(decode(a.l_6,0,0,b.l_6/a.l_6)*100,0) as hl_6,  "+
				"		trunc(decode(a.l_12,0,0,b.l_12/a.l_12)*100,0) as hl_12, trunc(decode(a.l_24,0,0,b.l_24/a.l_24)*100,0) as hl_24, trunc(decode(a.l_36,0,0,b.l_36/a.l_36)*100,0) as hl_36, "+
				"		trunc(decode(a.l_48,0,0,b.l_48/a.l_48)*100,0) as hl_48, trunc(decode(a.l_60,0,0,b.l_60/a.l_60)*100,0) as hl_60, trunc(decode(a.l_99,0,0,b.l_99/a.l_99)*100,0) as hl_99, trunc(decode(a.l_cont,0,0,b.l_cont/a.l_cont)*100,0) as hl_cont, "+
				"		trunc(decode(a.l_s,0,0,b.l_s/a.l_s)*100,0) as hl_s,     trunc(decode(a.l_b,0,0,b.l_b/a.l_b)*100,0) as hl_b,     trunc(decode(a.l_mfee,0,0,b.l_mfee/a.l_mfee)*100,0) as hl_mfee, trunc(decode(a.l_tfee,0,0,b.l_tfee/a.l_tfee)*100,0) as hl_tfee, "+
				"		trunc(decode(a.l_bus1,0,0,b.l_bus1/a.l_bus1)*100,0) as hl_bus1, trunc(decode(a.l_bus2,0,0,b.l_bus2/a.l_bus2)*100,0) as hl_bus2, "+
				"		trunc(decode(a.l_bus3,0,0,b.l_bus3/a.l_bus3)*100,0) as hl_bus3, trunc(decode(a.l_bus4,0,0,b.l_bus4/a.l_bus4)*100,0) as hl_bus4, "+
				"		trunc(decode(a.l_bus5,0,0,b.l_bus5/a.l_bus5)*100,0) as hl_bus5, trunc(decode(a.l_bus6,0,0,b.l_bus6/a.l_bus6)*100,0) as hl_bus6, "+
				"		trunc(decode(a.l_bus7,0,0,b.l_bus7/a.l_bus7)*100,0) as hl_bus7, 0 hl_bus8, trunc(decode(a.l_bus9,0,0,b.l_bus9/a.l_bus9)*100,0) as hl_bus9, "+
				"       trunc(decode(a.l_bus61,0,0,b.l_bus61/a.l_bus61)*100,0) as hl_bus61,"+
				"       trunc(decode(a.l_bus62,0,0,b.l_bus62/a.l_bus62)*100,0) as hl_bus62,"+
				"       trunc(decode(a.l_bus63,0,0,b.l_bus63/a.l_bus63)*100,0) as hl_bus63,"+
				"       trunc(decode(a.l_bus71,0,0,b.l_bus61/a.l_bus71)*100,0) as hl_bus71,"+
				"       trunc(decode(a.l_bus72,0,0,b.l_bus62/a.l_bus72)*100,0) as hl_bus72,"+
				"       trunc(decode(a.l_bus73,0,0,b.l_bus63/a.l_bus73)*100,0) as hl_bus73,"+
				"		trunc(decode(a.l_rent11,0,0,b.l_rent11/a.l_rent11)*100,0) as hl_rent11, trunc(decode(a.l_rent12,0,0,b.l_rent12/a.l_rent12)*100,0) as hl_rent12, "+
				"		trunc(decode(a.l_rent13,0,0,b.l_rent13/a.l_rent13)*100,0) as hl_rent13, trunc(decode(a.l_rent21,0,0,b.l_rent21/a.l_rent21)*100,0) as hl_rent21, "+
				"		trunc(decode(a.l_rent22,0,0,b.l_rent22/a.l_rent22)*100,0) as hl_rent22, trunc(decode(a.l_rent23,0,0,b.l_rent23/a.l_rent23)*100,0) as hl_rent23, "+
				"		trunc(decode(a.l_rent31,0,0,b.l_rent31/a.l_rent31)*100,0) as hl_rent31, trunc(decode(a.l_rent32,0,0,b.l_rent32/a.l_rent32)*100,0) as hl_rent32, "+
				"		trunc(decode(a.l_rent33,0,0,b.l_rent33/a.l_rent33)*100,0) as hl_rent33, trunc(decode(a.l_rent41,0,0,b.l_rent41/a.l_rent41)*100,0) as hl_rent41, "+
				"		trunc(decode(a.l_rent42,0,0,b.l_rent42/a.l_rent42)*100,0) as hl_rent42, trunc(decode(a.l_rent43,0,0,b.l_rent43/a.l_rent43)*100,0) as hl_rent43, "+				
				"		trunc(decode((a.r_rent11+a.r_rent21+a.r_rent31+a.r_rent41),0,0,(b.r_rent11+b.r_rent21+b.r_rent31+b.r_rent41)/(a.r_rent11+a.r_rent21+a.r_rent31+a.r_rent41))*100,0) hr_rent51,"+
				"		trunc(decode((a.r_rent12+a.r_rent22+a.r_rent32+a.r_rent42),0,0,(b.r_rent12+b.r_rent22+b.r_rent32+b.r_rent42)/(a.r_rent12+a.r_rent22+a.r_rent32+a.r_rent42))*100,0) hr_rent52,"+
				"		trunc(decode((a.r_rent13+a.r_rent23+a.r_rent33+a.r_rent43),0,0,(b.r_rent13+b.r_rent23+b.r_rent33+b.r_rent43)/(a.r_rent13+a.r_rent23+a.r_rent33+a.r_rent43))*100,0) hr_rent53,"+
				"		trunc(decode((a.l_rent11+a.l_rent21+a.l_rent31+a.l_rent41),0,0,(b.l_rent11+b.l_rent21+b.l_rent31+b.l_rent41)/(a.l_rent11+a.l_rent21+a.l_rent31+a.l_rent41))*100,0) hl_rent51,"+
				"		trunc(decode((a.l_rent12+a.l_rent22+a.l_rent32+a.l_rent42),0,0,(b.l_rent12+b.l_rent22+b.l_rent32+b.l_rent42)/(a.l_rent12+a.l_rent22+a.l_rent32+a.l_rent42))*100,0) hl_rent52,"+
				"		trunc(decode((a.l_rent13+a.l_rent23+a.l_rent33+a.l_rent43),0,0,(b.l_rent13+b.l_rent23+b.l_rent33+b.l_rent43)/(a.l_rent13+a.l_rent23+a.l_rent33+a.l_rent43))*100,0) hl_rent53"+
				"		from ("+main_content+" "+" "+where3+") a, ("+main_content+" "+" "+where1+") b "+//
				"";

		String r_query = " select "+
						 " r_cont, rb_cont, r_5, r_6, r_12, r_24, r_36, r_48, r_60, r_99, r_s, r_b, r_mfee, r_tfee, r_bus1, r_bus2, r_bus3, r_bus4, r_bus5, r_bus6, r_bus7, r_bus9, r_bus61, r_bus62, r_bus63, r_bus71, r_bus72, r_bus73, (r_bus1+r_bus2+r_bus3+r_bus4+r_bus5+r_bus6+r_bus7+r_bus9) as r_bus8,r_rent11,r_rent12,r_rent13,(r_rent11+r_rent12+r_rent13) as r_rent14,r_rent21,r_rent22,r_rent23,(r_rent21+r_rent22+r_rent23) as r_rent24,r_rent31,r_rent32,r_rent33,(r_rent31+r_rent32+r_rent33)as r_rent34,r_rent41,r_rent42,r_rent43,(r_rent41+r_rent42+r_rent43)as r_rent44,(r_rent11+r_rent21+r_rent31+r_rent41)as r_rent51,(r_rent12+r_rent22+r_rent32+r_rent42)as r_rent52,(r_rent13+r_rent23+r_rent33+r_rent43)as r_rent53,"+
						 " l_cont, lb_cont, l_5, l_6, l_12, l_24, l_36, l_48, l_60, l_99, l_s, l_b, l_mfee, l_tfee, l_bus1, l_bus2, l_bus3, l_bus4, l_bus5, l_bus6, l_bus7, l_bus9, l_bus61, l_bus62, l_bus63, l_bus71, l_bus72, l_bus73, (l_bus1+l_bus2+l_bus3+l_bus4+l_bus5+l_bus6+l_bus7+l_bus9) as l_bus8,l_rent11,l_rent12,l_rent13,(l_rent11+l_rent12+l_rent13) as l_rent14,l_rent21,l_rent22,l_rent23,(l_rent21+l_rent22+l_rent23) as l_rent24,l_rent31,l_rent32,l_rent33,(l_rent31+l_rent32+l_rent33)as l_rent34,l_rent41,l_rent42,l_rent43,(l_rent41+l_rent42+l_rent43)as l_rent44,(l_rent11+l_rent21+l_rent31+l_rent41)as l_rent51,(l_rent12+l_rent22+l_rent32+l_rent42)as l_rent52,(l_rent13+l_rent23+l_rent33+l_rent43)as l_rent53,"+
						 " t_cont, tb_cont, t_5, t_6, t_12, t_24, t_36, t_48, t_60, t_99, t_s, t_b, t_mfee, t_tfee, t_bus1, t_bus2, t_bus3, t_bus4, t_bus5, t_bus6, t_bus7, t_bus9, t_bus61, t_bus62, t_bus63, t_bus71, t_bus72, t_bus73, (t_bus1+t_bus2+t_bus3+t_bus4+t_bus5+t_bus6+t_bus7+t_bus9) as t_bus8,t_rent11,t_rent12,t_rent13,(t_rent11+t_rent12+t_rent13) as t_rent14,t_rent21,t_rent22,t_rent23,(t_rent21+t_rent22+t_rent23) as t_rent24,t_rent31,t_rent32,t_rent33,(t_rent31+t_rent32+t_rent33)as t_rent34,t_rent41,t_rent42,t_rent43,(t_rent41+t_rent42+t_rent43)as t_rent44,(t_rent11+t_rent21+t_rent31+t_rent41)as t_rent51,(t_rent12+t_rent22+t_rent32+t_rent42)as t_rent52,(t_rent13+t_rent23+t_rent33+t_rent43)as t_rent53,"+
						 " hr_cont,         hr_5,hr_6,hr_12,hr_24,hr_36,hr_48,hr_60,hr_99,hr_s,hr_b,hr_mfee,hr_tfee,hr_bus1,hr_bus2,hr_bus3,hr_bus4,hr_bus5,hr_bus6,hr_bus7,hr_bus9,hr_bus61,hr_bus62,hr_bus63,hr_bus71,hr_bus72,hr_bus73,hr_bus8, hr_rent11,hr_rent12,hr_rent13,hr_rent21,hr_rent22,hr_rent23,hr_rent31,hr_rent32,hr_rent33,hr_rent41,hr_rent42,hr_rent43,hr_rent51,hr_rent52,hr_rent53,"+
						 " hl_cont,         hl_5,hl_6,hl_12,hl_24,hl_36,hl_48,hl_60,hl_99,hl_s,hl_b,hl_mfee,hl_tfee,hl_bus1,hl_bus2,hl_bus3,hl_bus4,hl_bus5,hl_bus6,hl_bus7,hl_bus9,hl_bus61,hl_bus62,hl_bus63,hl_bus71,hl_bus72,hl_bus73,hl_bus8, hl_rent11,hl_rent12,hl_rent13,hl_rent21,hl_rent22,hl_rent23,hl_rent31,hl_rent32,hl_rent33,hl_rent41,hl_rent42,hl_rent43,hl_rent51,hl_rent52,hl_rent53"+
						 " from ("+query+")";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(r_query);
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentCondStatList]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


	/**
	 *	임의연장조회-담당자별업무추진현황
	 */
	public Hashtable getFeeImList2(String rent_mng_id, String rent_l_cd, String rent_st ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query =  "";

		query = " select\n"+
				" a.rent_mng_id, a.rent_l_cd, c.firm_nm,\n"+
				" decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
				" b.con_mon, b.rent_start_dt, b.rent_end_dt,\n"+
				" g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\n"+
				" k.user_nm as bus_nm, l.user_nm as bus_nm2, nvl(sf.fee_est_dt,'') fee_est_dt, j.user_nm as re_bus_nm \n"+
				" from cont a, \n"+
				"     (select rent_mng_id, rent_l_cd, sum(con_mon) con_mon, min(rent_way) rent_way, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee where rent_end_dt is not null group by rent_mng_id, rent_l_cd) b,\n"+
				"     (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee group by rent_mng_id, rent_l_cd) sf,\n"+
				"     client c, car_reg d, car_etc e, car_nm f, car_mng g,\n"+
				"     users k, users l, end_cont i, users j\n"+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2','5') \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				" and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+)\n"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.re_bus_id=j.user_id(+) \n"+
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)"+
				" and a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' "+
				" order by b.rent_end_dt";

		if(!rent_st.equals(""))		query += " and a.rent_st='"+rent_st+"' ";

		try {
			 stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
            rs.close();
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[ConditionDatabase:getFeeImList2]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(stmt != null)		stmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return ht;
		}
	}
	
		
	 /**
     * 해지 현황 조회
     */
    public ClsCondBean [] getClsCondAll2(String gubun,String ref_dt1,String ref_dt2, String gubun3, String gubun4, String gubun5, String bm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;     
        String query = "";
               
		query = " select a.cls_st, a.rent_l_cd, b.firm_nm, b.client_nm, a.cls_dt, a.cls_cau, cr.car_nm, cr.car_no, c.user_nm \n"+
				" from cls_cont a, cont_n_view b, users c , car_reg cr \n"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.cls_st in ( '1','2', '8' )  and b.car_mng_id = cr.car_mng_id ";			
		
		   /* 기간 */        
        query += " and a.cls_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
        
		// 최초영업자/관리담당자  조회시
		if(gubun.equals("2")){
			 if ( bm.equals("1") ) {
				  query +=" and b.bus_id=c.user_id ";
				  /* 부서 구분 */
			      query += " and c.dept_id  = '" + gubun3 + "'" ;	        
			      /*담당자 구분 */
			      if(!gubun4.equals("")) query += " and b.bus_id = '"+ gubun4+ "'";		
			 } else {
			 	  query +=" and b.mng_id=c.user_id ";
				  /* 부서 구분 */
			      query += " and c.dept_id  = '" + gubun3 + "'" ;	        
			      /*담당자 구분 */
			      if(!gubun4.equals("")) query += " and b.mng_id = '"+ gubun4+ "'";	
			 }	      
			
		} else {
				 query +=" and b.bus_id2=c.user_id ";
						
		       /* 신차, 재리스, 연장 구분 */
		        query += " and decode(b.fee_rent_st, '1', decode(b.car_gu, '0', '2', '1') , '9') = '" + gubun3 + "'" ;	        
		        /*렌트, 리스 구분 */
		        if(!gubun4.equals("")) query += " and b.car_st = '"+ gubun4+ "'";
		}        
        
        /* 일반식, 기본식 구분 */
		if(!gubun5.equals("")) query += " and b.rent_way_cd = '"+ gubun5+ "'";
	 	
		query += " order by a.cls_st, a.cls_dt ";
			
        Collection<ClsCondBean> col = new ArrayList<ClsCondBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
				col.add(makeClsCondBean2(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[ConditionDatabase:getClsCondAll2]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (ClsCondBean[])col.toArray(new ClsCondBean[0]);
    }
	

     /**
     * 차량조회 - 메이커 & 차종(리콜관련 해당 차량  조회)
     */
    public Vector getLoanCondAll(String dt,String ref_dt1,String ref_dt2, String gubun2, String car_comp_id, String code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

        
        // 출고예정일
      if(gubun2.equals("1")){     
		if(dt.equals("2"))								dt_query = " and nvl(a.dlv_dt,a.rent_dt) like "+s_dt2+"||'%'\n";
		else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and nvl(a.dlv_dt,a.rent_dt) "+s_dt3+"\n";
       }
		
        query = " select\n"+
				" a.rent_mng_id, a.rent_l_cd, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, b.rent_start_dt, c.firm_nm, g.car_nm,  d.car_num,  \n"+
				" d.car_no, d.car_mng_id,  l.user_nm as bus_nm2, m.user_nm as mng_nm, \n"+
				" j.nm as rent_way_nm, \n"+
				" i.nm as fuel_kd  \n"+
				" from cont a, fee b, client c, car_reg d, car_etc e, car_nm f, car_mng g,  users l, users m, \n"+
				"      (select rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_l_cd) fl, \n"+
				"      (select * from code where c_st='0039') i, "+
				"      (select * from code where c_st='0005') j  "+				
        		" where nvl(a.use_yn,'Y') ='Y'  \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				" and b.rent_l_cd = fl.rent_l_cd  and    b.rent_st = fl.rent_st  \n"+
				dt_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+				
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+	
				" and f.car_comp_id = '"+ car_comp_id + "' and  f.car_cd like '%"+code + "%'   \n" + 
				" and a.bus_id2=l.user_id(+)\n"+
				" and a.mng_id=m.user_id(+) \n"+
				" and d.fuel_kd=i.nm_cd \n"+
				" and b.rent_way=j.nm_cd \n"+
				" ";

		query += " order by m.user_nm, c.firm_nm, nvl(a.dlv_dt,a.rent_dt)";


        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getLoanCondAll]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }	
	
      //리콜관련 조회 - 
     public Hashtable getRecallListExcel(String ch_m_id, String ch_l_cd, String ch_c_id) throws DatabaseException, DataSourceEmptyException
     {
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		
		query = " select\n"+
				" d.car_use, a.rent_mng_id, a.rent_l_cd, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, c.firm_nm,  g.car_nm,  d.car_num,  \n"+
				" d.car_no, d.car_mng_id,  l.user_nm as bus_nm2, m.user_nm as mng_nm, decode(b.rent_way, '1', '일반식', '2', '맞춤식', '3', '기본식', '보유차') as rent_way_nm , a.mng_id \n"+		    		
				" from cont a, fee b, client c, car_reg d, car_etc e, car_nm f, car_mng g,  users l, users m, \n"+
				 " (select rent_l_cd,  max(to_number(rent_st)) rent_st  from   fee      group by rent_l_cd) fl \n"+
				" where nvl(a.use_yn, 'Y' ) ='Y'  \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				"  and b.rent_l_cd = fl.rent_l_cd  and    b.rent_st = fl.rent_st  \n"+
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+			
				" and a.bus_id2=l.user_id(+)\n"+
				" and a.mng_id=m.user_id(+)\n"+
				" and a.rent_mng_id = '"+ch_m_id+"'"+
				" and a.rent_l_cd = '"+ch_l_cd+"'";
		
		if (!ch_c_id.equals("0")) {
			query = query + " and a.car_mng_id = '"+ch_c_id+"'";
		}

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
			System.out.println("[ConditionDatabase:getRecallListExcel]\n"+e);
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

    /**
     * 영업소별계약현황
     */
    public Vector getBrCondStatList(String mode, String br_id, String gubun1, String gubun2, String st_dt, String end_dt ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String b_query = "";
		String query = "";
	        
		b_query = " select "+
				  "        a.rent_l_cd, decode(b.rent_st,'1',decode(i.dept_id,'1000','S1',a.brch_id),i.br_id) as brch_id, i.dept_id, i.loan_st, \n"+
 			      "        decode(i.dept_id,'1000','7',DECODE(DECODE(b.rent_st,'1',a.bus_st,'1'),'7','7','2','2','1')) bus_st, "+
				  "        b.rent_way, "+
				  "        DECODE(b.con_mon,'12','12','24','24','36','36','48','48','00') con_mon "+
				  " from   cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				  "        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f, users i \n"+
				  " where  decode(b.rent_st,'1',decode(i.dept_id,'1000','S1',a.brch_id),i.br_id)='"+br_id+"' and a.car_st not in ('2','4','5') and a.client_id not in ('000228')  \n";

		
		if(gubun2.equals("1"))			b_query += " and a.car_gu='1' and b.rent_st='1'";
		if(gubun2.equals("2"))			b_query += " and a.car_gu='0' and b.rent_st='1'";
		if(gubun2.equals("3"))			b_query += " and b.rent_st<>'1'";

		if(gubun1.equals("1"))			b_query += " and DECODE(b.rent_st,'1',a.rent_dt,b.rent_dt)=to_char(sysdate,'YYYYMMDD')";
		if(gubun1.equals("2"))			b_query += " and DECODE(b.rent_st,'1',a.rent_dt,b.rent_dt)=to_char(sysdate-1,'YYYYMMDD')";
		if(gubun1.equals("3"))			b_query += " and DECODE(b.rent_st,'1',a.rent_dt,b.rent_dt)=to_char(sysdate-2,'YYYYMMDD')";
		if(gubun1.equals("4"))			b_query += " and DECODE(b.rent_st,'1',a.rent_dt,b.rent_dt) like to_char(sysdate,'YYYYMM')||'%' ";
		if(gubun1.equals("5"))			b_query += " and DECODE(b.rent_st,'1',a.rent_dt,b.rent_dt) like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' ";
		if(gubun1.equals("6"))			b_query += " and DECODE(b.rent_st,'1',a.rent_dt,b.rent_dt) like TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||'%' ";
		if(gubun1.equals("7")){	
			if(!st_dt.equals("") && end_dt.equals(""))		b_query += " and DECODE(b.rent_st,'1',a.rent_dt,b.rent_dt) like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals(""))		b_query += " and DECODE(b.rent_st,'1',a.rent_dt,b.rent_dt) between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				"        and decode(b.rent_st,'1',a.bus_id,nvl(b.ext_agnt,a.bus_id))=i.user_id "+
				" ";				

		
		query = " SELECT bus_st, "+
				"        DECODE(bus_st,'1','자체영업','2','영업사원','7','에이전트') bus_st_nm, "+
				"        COUNT(DECODE(rent_way||con_mon,'112',rent_l_cd)) cnt1, "+
				"        COUNT(DECODE(rent_way||con_mon,'124',rent_l_cd)) cnt2, "+
				"        COUNT(DECODE(rent_way||con_mon,'136',rent_l_cd)) cnt3, "+
				"        COUNT(DECODE(rent_way||con_mon,'148',rent_l_cd)) cnt4, "+
				"        COUNT(DECODE(rent_way||con_mon,'100',rent_l_cd)) cnt5, "+
				"        COUNT(DECODE(rent_way,'1',rent_l_cd)) cnt6, "+
				"        COUNT(DECODE(rent_way||con_mon,'312',rent_l_cd)) cnt7, "+
				"        COUNT(DECODE(rent_way||con_mon,'324',rent_l_cd)) cnt8, "+
				"        COUNT(DECODE(rent_way||con_mon,'336',rent_l_cd)) cnt9, "+
				"        COUNT(DECODE(rent_way||con_mon,'348',rent_l_cd)) cnt10, "+
				"        COUNT(DECODE(rent_way||con_mon,'300',rent_l_cd)) cnt11, "+
				"        COUNT(DECODE(rent_way,'3',rent_l_cd)) cnt12, "+
				"        COUNT(DECODE(con_mon,'12',rent_l_cd)) cnt13, "+
				"        COUNT(DECODE(con_mon,'24',rent_l_cd)) cnt14, "+
				"        COUNT(DECODE(con_mon,'36',rent_l_cd)) cnt15, "+
				"        COUNT(DECODE(con_mon,'48',rent_l_cd)) cnt16, "+
				"        COUNT(DECODE(con_mon,'00',rent_l_cd)) cnt17, "+
				"        COUNT(*) cnt18 "+
				" FROM "+
				"        ("+b_query+") "+
			    " GROUP BY bus_st "+
                " ORDER BY DECODE(bus_st,'1',1,'2',2,'7',3) "+
				" ";

		if(mode.equals("dept_cont")){
			query = " SELECT  "+
					"        count(DECODE(loan_st,'','', rent_l_cd)) l_cnt0, "+
					"        count(DECODE(loan_st,'2',rent_l_cd)) l_cnt1, "+
					"        count(DECODE(loan_st,'1',rent_l_cd)) l_cnt2, "+
					"        count(DECODE(loan_st,'', rent_l_cd)) l_cnt3  "+   
					" FROM "+
					"        ("+b_query+") "+
					" where dept_id not in ('1000','1999')"+
				    " ";
		}

		if(mode.equals("dept_user")){
			query = " SELECT  "+
					"        count(DECODE(loan_st,'','', user_id)) u_cnt0, "+
					"        count(DECODE(loan_st,'2',user_id)) u_cnt1, "+
					"        count(DECODE(loan_st,'1',user_id)) u_cnt2, "+
					"        count(DECODE(loan_st,'', user_id)) u_cnt3  "+   
					" FROM   users "+
					" where  br_id='"+br_id+"' and dept_id not in ('1000','1999','8888','9999') and use_yn='Y' AND user_pos NOT IN ('대표이사','팀장') "+ 
				    " ";
		}


        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getBrCondStatList]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 월렌트 계약만료예정현황 조회
     */
    public Vector getRentEndCondRmAll(String dt,String ref_dt1,String ref_dt2, String gubun3, String gubun4 ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";     
		String sub_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//20131230 스케줄기준 10일이내만 보여주는 것으로 수정
		dt_query = " and case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end < to_char(sysdate+10,'YYYYMMDD') \n";

			  
		if(gubun3.equals("1") && !gubun4.equals("")) sub_query += " and a.bus_id='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) sub_query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) sub_query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";
		if(gubun3.equals("4") && !gubun4.equals("")) sub_query += " and i.re_bus_id='"+gubun4+"'";

	        
        query = " select   \n"+
				" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, c.firm_nm,\n"+
				" decode(a.car_st,'4','월렌트',decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식')) rent_way,\n"+
				" decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st, \n"+
				" b.con_mon, b.rent_start_dt, b.rent_end_dt,\n"+
				" g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\n"+
				" a.bus_id, a.bus_id2, k.user_nm as bus_nm, l.user_nm as bus_nm2, l2.user_nm as mng_nm, sf.fee_est_dt, j.user_nm as re_bus_nm, to_char(i.reg_dt,'YYYYMMDD') end_cont_mm_dt, i.content as end_cont_mm_content, \n"+
				" sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD') dly_day, \n"+
				" trunc((h.fee_s_amt+h.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
				" decode(es.fee_opt_amt,0,nvl(es.o_1,0),es.fee_opt_amt) as o_1, decode(o.rent_l_cd,'','N','Y') cls_reg_yn, \n"+
				" decode(cc.rent_l_cd,'','','해지반납') call_in_st, n.emp_nm, fe.con_day, "+
				" d.car_end_dt, decode(d.car_end_yn,'Y','연장종료','') car_end_yn "+
				" from cont a, \n"+
				"     (select  rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(rent_way) rent_way, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee where rent_end_dt is not null group by rent_mng_id, rent_l_cd) b,\n"+
				"     (select  rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee group by rent_mng_id, rent_l_cd) sf,\n"+
				"     client c, car_reg d, car_etc e, car_nm f, car_mng g,\n"+
				"     users k, users l, users l2, \n"+
				"     (select i.* from end_cont_mm i,(select rent_mng_id, rent_l_cd, max(seq) seq from end_cont_mm group by rent_mng_id, rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i , \n"+
				"	  users j, fee h, \n"+
				"     (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) es, \n"+
				"     cls_etc o,  \n"+
	            //차량해지반납
				"     (select * from car_call_in where in_st='3' and out_dt is null ) cc, "+
				"     (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where a.agnt_st='1' and a.emp_id=b.emp_id ) n, "+
				"     fee_etc fe "+		
				" where nvl(a.use_yn,'Y')='Y' and a.car_st='4'\n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				" and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+)\n"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.re_bus_id=j.user_id(+) \n"+
				dt_query +
				sub_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id"+
				" and a.mng_id=l2.user_id"+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \n"+
				" and b.rent_mng_id=es.rent_mng_id(+) and b.rent_l_cd=es.rent_l_cd(+) and b.rent_st=es.rent_st(+) \n"+
				" and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \n"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+						
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+						
				" and b.rent_mng_id=fe.rent_mng_id(+) and b.rent_l_cd=fe.rent_l_cd(+) and b.rent_st=fe.rent_st(+) \n"+
				" order by sf.fee_est_dt ";
        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentEndCondRmAll]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }    
    
    /**
     * 월렌트 계약만료예정현황 조회2
     */
    public Vector getRentEndCondRmAll(String dt,String ref_dt1,String ref_dt2, String gubun3, String gubun4,String gubun5, String t_wd ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";     
		String sub_query = "";        
	        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

			
		if(dt.equals("1"))			dt_query = " and case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end < to_char(sysdate+10,'YYYYMMDD') \n";
		else if(dt.equals("2"))		dt_query = " and case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end "+s_dt3+" \n";
			  
		if(gubun3.equals("1") && !gubun4.equals("")) sub_query += " and a.bus_id='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) sub_query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) sub_query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";
		if(gubun3.equals("4") && !gubun4.equals("")) sub_query += " and i.re_bus_id='"+gubun4+"'";
		if(gubun5.equals("1") && !t_wd.equals(""))   sub_query += " and d.car_no like '%"+t_wd+"%'";

        query = " select \n"+
				" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, c.firm_nm, \n"+
				" b.rent_start_dt, b.rent_end_dt,\n"+
				" g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\n"+
				" k.user_nm as bus_nm, l2.user_nm as mng_nm, l2.user_id as mng_id, "+
				" sf.fee_est_dt, j.user_nm as re_bus_nm, "+
				" to_char(i.reg_dt,'YYYYMMDD') end_cont_mm_dt, i.content as end_cont_mm_content, \n"+
				" to_char(i2.reg_dt,'YYYYMMDD') end_cont_mm_dt2, i2.content as end_cont_mm_content2, \n"+
				" d.car_end_dt, decode(d.car_end_yn,'Y','연장종료','') car_end_yn, sf.dly_count, d.fuel_kd, f.car_comp_id "+
				" from cont a, \n"+
				"     (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) b,\n"+
				"     (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt, "+
				"             COUNT(CASE when rc_dt IS NULL AND r_fee_est_dt <TO_CHAR(SYSDATE,'YYYYMMDD') THEN rent_l_cd ELSE '' end) dly_count "+
				"       from  scd_fee where bill_yn='Y' group by rent_mng_id, rent_l_cd) sf,\n"+
				"     client c, car_reg d, car_etc e, car_nm f, car_mng g,\n"+
				"     users k, users l2, \n"+

				//10일이내 i
				"     (select i.rent_mng_id, i.rent_l_cd, i.re_bus_id, i.reg_dt, i.content from end_cont_mm i, (select ia.rent_mng_id, ia.rent_l_cd, max(ia.seq) seq from end_cont_mm ia, (select rent_l_cd, max(use_e_dt) rent_end_dt from scd_fee group by rent_l_cd) ib where ia.rent_l_cd=ib.rent_l_cd and ia.reg_dt >= TO_date(ib.rent_end_dt,'YYYYMMDD')-10 group by ia.rent_mng_id, ia.rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i , \n"+
                //10일이상 i2
				"     (select i.rent_mng_id, i.rent_l_cd, i.re_bus_id, i.reg_dt, i.content from end_cont_mm i, (select ia.rent_mng_id, ia.rent_l_cd, max(ia.seq) seq from end_cont_mm ia, (select rent_l_cd, max(use_e_dt) rent_end_dt from scd_fee group by rent_l_cd) ib where ia.rent_l_cd=ib.rent_l_cd and ia.reg_dt <  TO_date(ib.rent_end_dt,'YYYYMMDD')-10 group by ia.rent_mng_id, ia.rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i2 , \n"+

				"	  users j "+		
				" where a.use_yn='Y' and a.car_st='4' \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" and a.rent_mng_id=sf.rent_mng_id and a.rent_l_cd=sf.rent_l_cd \n"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) "+
				" and a.rent_mng_id=i2.rent_mng_id(+) and a.rent_l_cd=i2.rent_l_cd(+) "+
				" and i.re_bus_id=j.user_id(+) \n"+
				dt_query +
				sub_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id \n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.mng_id=l2.user_id"+
				" order by sf.fee_est_dt ";

        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentEndCondRmAll]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 월렌트 계약만료예정현황 조회2
     */
    public Vector getRentEndCondRmAll_B(String dt,String ref_dt1,String ref_dt2, String gubun3, String gubun4,String gubun5, String t_wd ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";     
		String sub_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
			
		//20131230 스케줄기준 10일이내만 보여주는 것으로 수정
		if(dt.equals("1"))			dt_query = " and case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end < to_char(sysdate+10,'YYYYMMDD') \n";
		//기간 조회시 계약만료일, 스케쥴 중 큰값을 기준으로 기간 조회하도록 수정
		else if(dt.equals("2"))		dt_query = " and (case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end "+s_dt3+")\n";
			  
		if(gubun3.equals("1") && !gubun4.equals("")) sub_query += " and a.bus_id='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) sub_query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) sub_query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";
		if(gubun3.equals("4") && !gubun4.equals("")) sub_query += " and i.re_bus_id='"+gubun4+"'";
		if(gubun5.equals("1") && !t_wd.equals("")) sub_query += " and d.car_no like '%"+t_wd+"%'";

	        
        query = " select   \n"+
				" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, c.firm_nm,\n"+
				" decode(a.car_st,'4','월렌트',decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식')) rent_way,\n"+
				" decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st, \n"+
				" b.con_mon, b.rent_start_dt, b.rent_end_dt,\n"+
				" g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\n"+
				" a.bus_id, a.bus_id2, k.user_nm as bus_nm, l.user_nm as bus_nm2, l2.user_nm as mng_nm, sf.fee_est_dt, j.user_nm as re_bus_nm, to_char(i.reg_dt,'YYYYMMDD') end_cont_mm_dt, i.content as end_cont_mm_content, \n"+
				" l2.user_id as mng_id, \n"+	// <--관리담당자 id값 추가(2017.11.02)
				" sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD') dly_day, \n"+
				" trunc((h.fee_s_amt+h.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
				" decode(es.fee_opt_amt,0,nvl(es.o_1,0),es.fee_opt_amt) as o_1, decode(o.rent_l_cd,'','N','Y') cls_reg_yn, \n"+
				" decode(cc.rent_l_cd,'','','해지반납') call_in_st, n.emp_nm, fe.con_day, "+
				" d.car_end_dt, decode(d.car_end_yn,'Y','연장종료','') car_end_yn, sf.dly_count "+
				" from cont a, \n"+
				"     (select  rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(rent_way) rent_way, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee where rent_end_dt is not null group by rent_mng_id, rent_l_cd) b,\n"+
				"     (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt, sum(case when decode(bill_yn, 'Y', 'T', 'F') = 'T' and (case when r_fee_est_dt < TO_CHAR(SYSDATE,'YYYYMMDD') THEN 'T' ELSE 'F' END) = 'T' AND DECODE(rc_dt, NULL, 'T', 'F') = 'T' THEN 1 ELSE 0 END) dly_count "+
				"       from scd_fee group by rent_mng_id, rent_l_cd) sf,\n"+
				"     client c, car_reg d, car_etc e, car_nm f, car_mng g,\n"+
				"     users k, users l, users l2, \n"+
				"     (select i.* from end_cont_mm i,(select rent_mng_id, rent_l_cd, max(seq) seq from end_cont_mm group by rent_mng_id, rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i , \n"+
				"	  users j, fee h, \n"+
				"     (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) es, \n"+
				"     cls_etc o,  \n"+
	            //차량해지반납
				"     (select * from car_call_in where in_st='3' and out_dt is null ) cc, "+
				"     (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where a.agnt_st='1' and a.emp_id=b.emp_id ) n, "+
				"     fee_etc fe "+		
				" where nvl(a.use_yn,'Y')='Y' and a.car_st='4'\n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				" and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+)\n"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.re_bus_id=j.user_id(+) \n"+
				dt_query +
				sub_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id"+
				" and a.mng_id=l2.user_id"+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \n"+
				" and b.rent_mng_id=es.rent_mng_id(+) and b.rent_l_cd=es.rent_l_cd(+) and b.rent_st=es.rent_st(+) \n"+
				" and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \n"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+						
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+						
				" and b.rent_mng_id=fe.rent_mng_id(+) and b.rent_l_cd=fe.rent_l_cd(+) and b.rent_st=fe.rent_st(+) \n"+
				" order by sf.fee_est_dt ";
        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentEndCondRmAll_B]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


	/**
     * 연도별 해지건수 카운트 리스트
     */
    public Vector getClsCondList(String dt, String st_year, String ref_dt1, String ref_dt2, String gubun1, String gubun2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String gubun1_query = "";
		String gubun2_query = "";
		String dt_query = "";


		//기간
        if(dt.equals("1"))        	dt_query += " and substr(a.cls_dt,1,4)= '"+st_year+"'\n";
        else if(dt.equals(""))		dt_query += " and substr(a.cls_dt,1,4)=to_char(sysdate,'YYYY')\n";
        else if(dt.equals("3"))		dt_query += " and a.cls_dt between '" + ref_dt1 + "' and '" + ref_dt2 + "'\n";
        
		//렌트, 리스
		if(gubun2.equals(""))		gubun2_query += " /* and b.car_st IN ('1','3') */ \n";
		if(gubun2.equals("1"))		gubun2_query += " and b.car_st =  '" + gubun2  + "'\n";
		if(gubun2.equals("2"))		gubun2_query += " and b.car_st =  '" + gubun2  + "'\n";
		
		//중도해약 계산서발행여부
		if(gubun1.equals(""))		gubun1_query += " /* and c.tax_chk3 IN ('N','Y') */ \n";
		if(gubun1.equals("Y"))		gubun1_query += " and c.tax_chk3 =  'Y' \n";
		if(gubun1.equals("N"))		gubun1_query += " and c.tax_chk3 =  'N' \n";

			query = "	SELECT DECODE(d.car_use, '1','렌트', '2','리스', DECODE(b.car_st,'1','렌트', '3','리스' )) AS 구분, "+
					"	SUBSTR(a.cls_dt,1,4)||'년 '||SUBSTR(a.cls_dt,5,2)||'월' AS 년월, "+
					"	nvl(sum(decode(a.cls_st,'1',1,0)),0) AS 계약만료, "+
					"	nvl(sum(decode(a.cls_st,'2',1,0)),0) AS 중도해지, "+
					"	nvl(sum(decode(a.cls_st,'3',1,0)),0) AS 영업소변경, "+
					"	nvl(sum(decode(a.cls_st,'4',1,0)),0) AS 차종변경, "+
					"	nvl(sum(decode(a.cls_st,'5',1,0)),0) AS 계약승계, "+
					"	nvl(sum(decode(a.cls_st,'6',1,0)),0) AS 매각, "+
					"	nvl(sum(decode(a.cls_st,'7',1,0)),0) AS 출고전해지, "+
					"	nvl(sum(decode(a.cls_st,'8',1,0)),0) AS 매입옵션, "+
					"	nvl(sum(decode(a.cls_st,'9',1,0)),0) AS 폐차, "+
					"	nvl(sum(decode(a.cls_st,'10',1,0)),0) AS 개시전해지 "+
					"	FROM cls_cont a, cont_n_view b, cls_etc c, car_reg d "+
					"	WHERE a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "+
					"	AND a.rent_l_cd=c.rent_l_cd(+) AND a.rent_mng_id=c.rent_mng_id(+) and b.car_mng_id = d.car_mng_id(+) "+

					dt_query +
					gubun2_query +
					gubun1_query +

					"	GROUP BY DECODE(d.car_use, '1','렌트', '2','리스', DECODE(b.car_st,'1','렌트', '3','리스' )), SUBSTR(a.cls_dt,1,4)||'년 '||SUBSTR(a.cls_dt,5,2)||'월' ";

			query +=	"	ORDER BY 구분, 년월";




        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getClsCondList]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }	


	/**
     * 등록 현황 조회 ( 2003/3/3 ) - agent
     */

  public ConditionBean [] getRegCondAll(String gubun,String dt,String ref_dt1,String ref_dt2,String br_id, String fn_id, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        String sub_query1 = "";
        String sub_query2 = "";
        String dt_query = "";
        String strfn= "";
        String strfd = "";
        String query = "";
        
        /* 등록, 미등록, 출고, 미출고*/
       
        if(gubun.equals("1")){
        	if(dt.equals("1")){
	        	sub_query = "and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt,\n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt,\n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt,\n";
	        }
        }else if(gubun.equals("2")){
        	if(dt.equals("1")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt=to_char(sysdate,'YYYYMMDD')\n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt like to_char(sysdate,'YYYYMM')||'%' \n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
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
	        	sub_query = "and a.car_mng_id is not null and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
	        }
        }else{
        	query = "";
        }
               
        if (!fn_id.equals("0")) {
        	strfn=fn_id.substring(1);
        	strfd=fn_id.substring(0,1);
        	if (strfd.equals("1")) { 
        		sub_query2="and c.firm_nm like '%" + strfn + "%' ";
        	}else {
        		sub_query2="and h.car_name like '%" + strfn + "%' ";
        	}
        }
        
              
        
        
        query = "select a.bus_st, '' emp_nm, '' as car_off_name1, '' as car_off_name2, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
      		+ "         nvl(ec.nm, ec2.nm) car_ext, \n" 
			+ "         c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
			+ "         b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
			+ "         d.rent_st as R_ST, d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
			+ "         decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
			+ "         g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, o.car_nm as CAR_JNM,\n"//
			+ "         k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.15)
			+ "         i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT, \n"
			+ "         f.delay_cont, f.pur_req_dt, decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
			+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt \n"			
			+ "  from   cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng o,\n"
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n"
			+ "           where a.agnt_st='1'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) k,\n" 
			+ "         ( select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax \n"
			+ "           from commi a, car_off_emp b, car_off c \n" 
			+ "           where a.agnt_st='2'\n"
			+ "           and a.emp_id=b.emp_id\n"
			+ "           and b.car_off_id=c.car_off_id"
			+ "         ) l,\n"
			+ "         ( select code,nm\n"
			+ "           from code\n"
			+ "           where c_st = '0003'\n"
			+ "           and code <> '0000' "
			+ "         ) m,\n"
			+ "         (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) p, "
			+ "         (select * from code where c_st='0032') ec, "
			+ "         (select * from code WHERE c_st='0032') ec2  "
			+ "where    a.rent_mng_id like '%'\n"
			+ "         and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.car_gu='1' and a.brch_id like '%" + br_id + "'\n"
			+ sub_query2
			+ sub_query
			+ "         and a.car_mng_id = b.car_mng_id(+)\n"
			+ "         and a.client_id = c.client_id\n"
			+ "         and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
			+ "         and a.bus_id = e.user_id\n"
			+ "         and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
			+ "         and g.car_id = h.car_id(+) and g.car_seq=h.car_seq(+) and h.car_comp_id=o.car_comp_id(+) and h.car_cd=o.code(+)\n"
			+ "         and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+)\n"
			+ "         and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
			+ "         and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
			+ "         and i.cpt_cd = m.code(+) "
			+ "         and b.car_ext = ec.nm_cd(+) and g.car_ext = ec2.nm_cd(+) "
			+ "         and d.rent_mng_id = p.rent_mng_id and d.rent_l_cd = p.rent_l_cd and d.rent_st=p.rent_st AND e.DEPT_ID = '1000' AND a.BUS_ID = '"+user_id+"'  \n"
			+ "order by \n"
			+ sub_query1
			+ "         b.init_reg_dt, d.rent_start_dt, c.firm_nm\n";

        Collection col = new ArrayList();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeConditionBean(rs));
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
        return (ConditionBean[])col.toArray(new ConditionBean[0]);
    }



    public ConditionBean [] getRegCondAll2(String gubun,String dt,String ref_dt1,String ref_dt2,String br_id, String fn_id, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String sub_query = "";
        String sub_query1 = "";
        String sub_query2 = "";
        String dt_query = "";
        String strfn= "";
        String strfd = "";
        String query = "";
        
        /* 등록, 미등록, 출고, 미출고*/
       
        if(gubun.equals("1")){
        	if(dt.equals("1")){
	        	sub_query = "and a.car_mng_id is null and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt, a.rent_dt, \n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.car_mng_id is null and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt,\n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.car_mng_id is null and a.dlv_dt is null \n";
	        	sub_query1 = "f.dlv_est_dt, a.dlv_dt,\n";
	        }
        }else if(gubun.equals("2")){
        	if(dt.equals("1")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt=to_char(sysdate,'YYYYMMDD')\n";
	        }else if(dt.equals("2")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt like to_char(sysdate,'YYYYMM')||'%' \n";
	        }else if(dt.equals("3")){
	        	sub_query = "and a.dlv_dt is not null and a.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
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
	        	sub_query = "and a.car_mng_id is not null and b.init_reg_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";
	        }
        }else{
        	query = "";
        }
               
        if (!fn_id.equals("0")) {
	        	strfn=fn_id.substring(1);
	        	strfd=fn_id.substring(0,1);
	        	if (strfd.equals("1")) { 
	        		sub_query2="and c.firm_nm like '%" + strfn + "%' ";
	        	} else if (strfd.equals("3")) { 
	        		sub_query2="and pc.nm like '%" + strfn + "%' ";	
	        	}else {
	        		sub_query2="and o.car_nm||h.car_name like '%" + strfn + "%' ";
	        	}
        }
              
        
        query = "select a.bus_st, '' emp_nm, k.nm as car_off_name1, l.nm as car_off_name2, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.bus_id as BUS_ID, e.user_nm as BUS_NM,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
       	+ "nvl(ec.nm, ec2.nm) car_ext, \n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_st as R_ST, d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "decode(f.dlv_est_dt,null,'',substr(f.dlv_est_dt,1,4)||'-'||substr(f.dlv_est_dt,5,2)||'-'||substr(f.dlv_est_dt,7,2)) as DLV_EST_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, o.car_nm as CAR_JNM,\n"//
		+ "k.emp_id as IN_EMP_ID, k.emp_nm as IN_EMP_NM,k.car_off_nm as IN_CAR_OFF_NM, k.car_off_tel as IN_CAR_OFF_TEL, l.emp_id as OUT_EMP_ID, l.emp_nm as OUT_EMP_NM,l.car_off_nm as OUT_CAR_OFF_NM, l.car_off_tel as OUT_CAR_OFF_TEL, l.car_off_fax as OUT_CAR_OFF_FAX,\n"		// <--출고영업소 팩스번호 추가(2017.12.15)
		+ "i.cpt_cd as CPT_CD,m.nm as BANK_NM, decode(f.pur_pay_dt,null,'',substr(f.pur_pay_dt,1,4)||'-'||substr(f.pur_pay_dt,5,2)||'-'||substr(f.pur_pay_dt,7,2)) as PUR_PAY_DT,\n"
		+ "f.delay_cont, f.pur_req_dt, decode(h.diesel_yn,'Y','경유','1','휘발유','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소') as engine_nm, \n"
		+ "         b.maint_st_dt, b.maint_end_dt, b.car_end_dt \n"		
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng o,\n"
		+ "(select * from code where c_st='0001' and code<>'0000') pc, \n" //--제조사관련
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax, d.nm \n"
		+ "from commi a, car_off_emp b, car_off c, (SELECT * FROM CODE WHERE c_st = '0001' ) d \n"
		+ "where a.agnt_st='1'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id AND c.CAR_COMP_ID=d.CODE ) k,\n" 
		+ "(select a.rent_mng_id,a.rent_l_cd,a.emp_id,a.agnt_st,b.emp_nm, b.car_off_id, c.car_off_nm,c.car_off_tel, c.car_off_fax, d.nm \n"
		+ "from commi a, car_off_emp b, car_off c, (SELECT * FROM CODE WHERE c_st = '0001' ) d\n" 
		+ "where a.agnt_st='2'\n"
		+ "and a.emp_id=b.emp_id\n"
		+ "and b.car_off_id=c.car_off_id AND c.CAR_COMP_ID=d.CODE ) l,\n"
		+ "(select code,nm\n"
		+ "from code\n"
		+ "where c_st = '0003'\n"
		+ "and code <> '0000') m, \n"
		+ "(select * from code where c_st='0032') ec, \n"
		+ "(select * from code WHERE c_st='0032') ec2 \n"
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like '%' and nvl(a.use_yn,'Y')='Y' and a.car_gu='1' and a.brch_id like '%" + br_id + "'\n"
		+ sub_query2
		+ sub_query
		+ "and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and d.rent_st='1' and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq and h.car_comp_id=o.car_comp_id and h.car_cd=o.code\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n"
		+ "and a.rent_mng_id = k.rent_mng_id(+) and a.rent_l_cd = k.rent_l_cd(+)\n"
		+ "and a.rent_mng_id = l.rent_mng_id(+) and a.rent_l_cd = l.rent_l_cd(+)\n"
		+ "and h.car_comp_id=pc.code(+) \n"
		+ "and b.car_ext = ec.nm_cd(+) and g.car_ext = ec2.nm_cd(+) \n"
		+ "and i.cpt_cd = m.code(+) and e.dept_id = '1000' AND a.bus_id = '"+user_id+"' order by \n"
		+ sub_query1
		+ " b.init_reg_dt, c.firm_nm\n";

        Collection col = new ArrayList();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makeConditionBean(rs));
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
        return (ConditionBean[])col.toArray(new ConditionBean[0]);
    }

/**
     * 계약만료예정현황 조회
     */
    public Vector getRentEndCondAll_20070424(String dt,String ref_dt1,String ref_dt2, String gubun3, String gubun4, String bus_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";     
		String sub_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		if(dt.equals("1"))				dt_query = " and b.rent_end_dt="+s_dt1+"\n";
		else if(dt.equals("2"))			dt_query = " and ( b.rent_end_dt like "+s_dt2+"||'%' or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
		else if(dt.equals("3"))			dt_query = " and ( b.rent_end_dt "+s_dt3+" or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";

			  
		if(gubun3.equals("1") && !gubun4.equals("")) sub_query += " and a.bus_id='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) sub_query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) sub_query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";
		if(gubun3.equals("4") && !gubun4.equals("")) sub_query += " and i.re_bus_id='"+gubun4+"'";

	        
        query = " select  \n"+
				" a.rent_mng_id, a.rent_l_cd, c.firm_nm,\n"+
				" decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
				" decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st, \n"+
				" b.con_mon, b.rent_start_dt, b.rent_end_dt,\n"+
				" g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\n"+
				" a.bus_id, a.bus_id2, k.user_nm as bus_nm, l.user_nm as bus_nm2, sf.fee_est_dt, j.user_nm as re_bus_nm, \n"+
				" sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD') dly_day, \n"+
				" trunc((h.fee_s_amt+h.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
				" decode(es.fee_opt_amt,0,nvl(es.o_1,0),es.fee_opt_amt) as o_1, decode(o.rent_l_cd,'','N','Y') cls_reg_yn, \n"+
				" decode(cc.rent_l_cd,'','','해지반납') call_in_st, n.emp_nm "+
				" from cont a, \n"+
				"     (select  rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(rent_way) rent_way, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee where rent_end_dt is not null group by rent_mng_id, rent_l_cd) b,\n"+
				"     (select  rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee group by rent_mng_id, rent_l_cd) sf,\n"+
				"     client c, car_reg d, car_etc e, car_nm f, car_mng g,\n"+
				"     users k, users l, \n"+
				"     (select i.* from end_cont_mm i,(select rent_mng_id, rent_l_cd, max(seq) seq from end_cont_mm group by rent_mng_id, rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i , \n"+
				"	  users j, fee h, \n"+
				"     (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) es, \n"+
				"     cls_etc o,  \n"+
	            //차량해지반납
				"     (select * from car_call_in where in_st='3' and out_dt is null ) cc, "+
				"     (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where a.agnt_st='1' and a.emp_id=b.emp_id ) n "+
				" where nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2')  and a.bus_id = '"+bus_id + "' \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				" and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+)\n"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.re_bus_id=j.user_id(+) \n"+
				dt_query +
				sub_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id(+)\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id(+)"+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \n"+
				" and b.rent_mng_id=es.rent_mng_id(+) and b.rent_l_cd=es.rent_l_cd(+) and b.rent_st=es.rent_st(+) \n"+
				" and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \n"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+						
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+						
				" order by b.rent_end_dt";
        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentEndCondAll_20070424]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

 /**
     * 해지 현황 조회
     */
    public ClsCondBean [] getClsCondAll2(String dt,String ref_dt1,String ref_dt2, String bus_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;     
        String query = "";
               
		query = " select a.cls_st, a.rent_l_cd, c.firm_nm, c.client_nm, a.cls_dt, a.cls_cau, cr.car_nm, cr.car_no, c.user_nm"+
				" from cls_cont a, cont b, car_reg cr, client c , users c \n"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"  and  b.car_mng_id = cr.car_mng_id and b.client_id = c.client_id \n"+
				" and b.bus_id=c.user_id and b.bus_id = '"+bus_id + "'";
				
		
        /* 기간 */
        if(dt.equals("1"))        	query += " and a.cls_dt=to_char(sysdate,'YYYYMMDD')\n";
        else if(dt.equals("2"))		query += " and a.cls_dt like to_char(sysdate,'YYYYMM')||'%' \n";
        else if(dt.equals("3"))		query += " and a.cls_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')\n";

		query += " order by a.cls_st, a.cls_dt ";
			
        Collection col = new ArrayList();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
				col.add(makeClsCondBean2(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[ConditionDatabase:getClsCondAll2]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (ClsCondBean[])col.toArray(new ClsCondBean[0]);
    }


	  /**
     * 중도해지 통계
     */
    public String [] getClsCondSta2(String dt,String ref_dt1,String ref_dt2, String bus_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;        
        String val [] = new String[10];
        String query = "";
               
		query = " select "+
				" nvl(sum(decode(a.cls_st,'1',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'2',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'3',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'4',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'5',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'6',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'7',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'8',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'9',1,0)),0),"+
				" nvl(sum(decode(a.cls_st,'10',1,0)),0)"+
				" from cls_cont a, cont b, users c"+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.bus_id2=c.user_id and b.bus_id = '"+bus_id + "' ";
		
        /* 기간 */
        if(dt.equals("1"))        	query += " and a.cls_dt=to_char(sysdate,'YYYYMMDD')\n";
        else if(dt.equals("2"))		query += " and a.cls_dt like to_char(sysdate,'YYYYMM')||'%' \n";
        else if(dt.equals("3"))		query += " and a.cls_dt between '" + ref_dt1 + "' and '" + ref_dt2 + "'\n";
        
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
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[ConditionDatabase:getClsCondSta2]"+se);
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
     * 계약현황 리스트
     */
    public Vector getRentCondAll_type2(String dt,String ref_dt1,String ref_dt2, String gubun2, String gubun3, String gubun4, String sort, String ck_acar_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		//계약일    
      	if(gubun2.equals("1")){     
			if(dt.equals("1"))								dt_query = " and nvl(b.rent_dt,a.rent_dt)="+s_dt1+"\n";
			else if(dt.equals("2"))							dt_query = " and nvl(b.rent_dt,a.rent_dt) like "+s_dt2+"||'%'\n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = " and nvl(b.rent_dt,a.rent_dt) "+s_dt3+"\n";
			
		//대여개시일
		}else{				
			if(dt.equals("1"))								dt_query = "and b.rent_start_dt="+s_dt1+"\n";
			else if(dt.equals("2"))							dt_query = "and b.rent_start_dt like "+s_dt2+"||'%'\n";
			else if(dt.equals("3") && !ref_dt1.equals(""))	dt_query = "and b.rent_start_dt "+s_dt3+"\n";
		} 
		
        query = " select  \n"+
				"        a.rent_mng_id, a.rent_l_cd, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, b.rent_start_dt, c.firm_nm, c.client_nm, cm.car_nm, cn.car_name,\n"+
				"        a.dlv_dt, d.init_reg_dt,  b.con_mon, (b.fee_s_amt + b.fee_v_amt) fee_amt, nvl(fe.sh_amt, 0) sh_amt,  \n"+
				"        nvl(e.car_cs_amt, 0) + nvl(e.car_cv_amt, 0) + nvl(e.opt_cs_amt, 0)  + nvl(e.opt_cv_amt, 0) + nvl(e.clr_cs_amt, 0)  + nvl(e.clr_cv_amt, 0) - nvl(e.tax_dc_s_amt,0) - nvl(e.tax_dc_v_amt,0) as car_amt,\n"+
				"        nvl(b.grt_amt_s,0) grt_amt_s, (nvl(b.pp_s_amt,0) + nvl(b.pp_v_amt,0)) pp_amt, (nvl(b.ifee_s_amt,0) + nvl(b.ifee_v_amt,0)) ifee_amt, \n"+		
				"        decode(b.rent_st,'1','','연장') ext_st, \n"+
				"        decode(nvl(a.car_gu,a.reg_id),'1','신차','0','재리스','2','중고차') car_gu, \n"+
				"        decode(a.car_st,'1','렌트','2','예비차','3','리스','5','업무대여') car_st,\n"+	
				"        k.user_nm as bus_nm, l.user_nm as bus_nm2, decode(m.user_nm,l.user_nm,'',m.user_nm) as mng_nm, b.dc_ra, a.rent_way,  \n"+								
				"        decode(a.rent_st,'1','신규','2','연장','3','대차','4','증차','5','연장','6','재리스','7','재리스') rent_st "+
				" from   cont_n_view a, fee b, fee_etc fe, client c, car_reg d, car_etc e,  car_nm cn, car_mng cm, \n"+
				"        users k, users l, users m \n"+
				" where  a.bus_id='"+ck_acar_id+"'  and  nvl(a.use_yn,'Y')='Y' and a.car_st not in ('2' , '5' )  and a.client_id not in ('000228','000231')\n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				"        and a.rent_mng_id=fe.rent_mng_id(+) and a.rent_l_cd=fe.rent_l_cd(+)\n"+			
				"        and a.fee_rent_st = fe.rent_st(+)\n"+
				dt_query +
				"       and a.client_id=c.client_id  and a.car_mng_id=d.car_mng_id(+)\n"+
				"       and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				"	     and e.car_id=cn.car_id  and  e.car_seq=cn.car_seq and cn.car_comp_id=cm.car_comp_id and cn.car_cd=cm.code \n"+
				"        and a.bus_id=k.user_id \n"+
				"        and a.bus_id2=l.user_id(+)\n"+
				"        and a.mng_id=m.user_id(+)"+				
				" ";

		if(gubun3.equals("1")) query += " and nvl(a.car_gu,a.reg_id)='1' and b.rent_st = '1' ";
		if(gubun3.equals("2")) query += " and nvl(a.car_gu,a.reg_id)='0' and b.rent_st = '1'";
		if(gubun3.equals("3")) query += " and b.rent_st > '1'";
		
		if(sort.equals("1"))		query += " order by nvl(b.rent_dt,a.rent_dt)";
		else if(sort.equals("2"))	query += " order by b.rent_start_dt";
		else if(sort.equals("7"))	query += " order by d.init_reg_dt ";
		else if(sort.equals("8"))	query += " order by to_number(b.con_mon)";

        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentCondAll_type2]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


/**
     * 연도별 해지건수 카운트 리스트
     */
    public Vector getFeeEndEstList() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		  Vector vt = new Vector();
        String query = "";
        
        
       	query = "	 select yy ,  \n  "+
						 " sum(decode(mm, '01', cnt, 0)) cnt1, \n  "+
						 "  sum(decode(mm, '02', cnt, 0)) cnt2, \n  "+
						 "  sum(decode(mm, '03', cnt, 0)) cnt3, \n  "+
						 "  sum(decode(mm, '04', cnt, 0)) cnt4, \n  "+
						 "  sum(decode(mm, '05', cnt, 0)) cnt5, \n  "+
						 "  sum(decode(mm, '06', cnt, 0)) cnt6, \n  "+
						 "  sum(decode(mm, '07', cnt, 0)) cnt7, \n  "+
						 "  sum(decode(mm, '08', cnt, 0)) cnt8, \n  "+
						 "  sum(decode(mm, '09', cnt, 0)) cnt9, \n  "+
						 "  sum(decode(mm, '10', cnt, 0)) cnt10, \n  "+
						 "  sum(decode(mm, '11', cnt, 0)) cnt11, \n  "+
						 "  sum(decode(mm, '12', cnt, 0)) cnt12  \n  "+
						 "  from (	 "+		 		 
						 " select substr(replace(rent_end_dt, '-', '') , 1, 4) yy ,   "+
						 "   substr(replace(rent_end_dt, '-', '') , 5, 2) mm ,  "+
						 "   count(0)  cnt   "+
						 " from cont_n_view a, cls_cont b  "+
						 " where replace(rent_end_dt, '-', '') > '20091231'  and client_id not in ( '000228')   "+
						 "    and a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)  "+
						 "    and nvl(b.cls_st, '0' ) not in ( '4', '5')   "+
						 " group by substr(replace(rent_end_dt, '-', '') , 1, 4),  substr(replace(rent_end_dt, '-', '') , 5, 2)   "+
						 " ) a   "+
						" group by yy		 "+				 
						" order by 1 ";

        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getFeeEndEstList]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }	
	
	/**
     * 계약만료예정현황 조회
     */
    public Vector getRentEndCondAll(String dt,String ref_dt1,String ref_dt2, String gubun3, String gubun4, String bus_id, String sa_code ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";     
		String sub_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		if(dt.equals("1"))				dt_query = " and b.rent_end_dt="+s_dt1+"\n";
		else if(dt.equals("2"))			dt_query = " and ( b.rent_end_dt like "+s_dt2+"||'%' or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
		else if(dt.equals("3"))			dt_query = " and ( b.rent_end_dt "+s_dt3+" or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
			  
		if(gubun3.equals("1") && !gubun4.equals("")) sub_query += " and a.bus_id='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) sub_query += " and a.bus_id2='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) sub_query += " and nvl(a.mng_id,a.bus_id2)='"+gubun4+"'";
		if(gubun3.equals("4") && !gubun4.equals("")) sub_query += " and i.re_bus_id='"+gubun4+"'";

	        
        query = " select  \n"+
				" a.rent_mng_id, a.rent_l_cd, c.firm_nm,\n"+
				" decode(b.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,\n"+
				" decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st, \n"+
				"        decode(nvl(a.car_gu,a.reg_id),'1','신차','0','재리스','2','중고차','3','월렌트') car_gu, \n"+
				" b.con_mon, b.rent_start_dt, b.rent_end_dt,\n"+
				" g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\n"+
				" a.bus_id, a.bus_id2, k.user_nm as bus_nm, l.user_nm as bus_nm2, sf.fee_est_dt, j.user_nm as re_bus_nm, \n"+
				" sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD') dly_day, \n"+
				" trunc((h.fee_s_amt+h.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
				" decode(es.fee_opt_amt,0,nvl(es.o_1,0),es.fee_opt_amt) as o_1, decode(o.rent_l_cd,'','N','Y') cls_reg_yn, \n"+
				" decode(cc.rent_l_cd,'','','해지반납') call_in_st, n.emp_nm, "+
				" decode(k3.dept_id,'',k.dept_id,k3.dept_id) dept_id, "+
				" p2.f_rent_mon, TO_CHAR(ADD_MONTHS(nvl(p2.rent_start_dt,sysdate),50)-1,'YYYYMMDD') add_mon50_dt "+

				" from  cont a, \n"+
				"       (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(rent_way) rent_way, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee where rent_end_dt is not null group by rent_mng_id, rent_l_cd) b,\n"+
				"       (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee group by rent_mng_id, rent_l_cd) sf,\n"+
				"       client c, car_reg d, car_etc e, car_nm f, car_mng g,\n"+
				"       users k, users l, \n"+
				"       (select i.* from end_cont_mm i,(select rent_mng_id, rent_l_cd, max(seq) seq from end_cont_mm group by rent_mng_id, rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i , \n"+
				"	    users j, fee h, \n"+
				"       (select * from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) es, \n"+
				"       cls_etc o,  \n"+
	            //차량해지반납
				"       (select * from car_call_in where in_st='3' and out_dt is null ) cc, "+
				"       (select a.rent_mng_id, a.rent_l_cd, b.emp_id, b.emp_nm from commi a, car_off_emp b where a.agnt_st='1' and a.emp_id=b.emp_id ) n, cont_etc m, "+

                "        (SELECT client_id, min(rent_dt) rent_dt, min(rent_start_dt) rent_start_dt, NVL(trunc(months_between(sysdate, TO_DATE(min(rent_start_dt), 'YYYYMMDD')),0),0) f_rent_mon FROM CONT where bus_id='"+bus_id+"' and client_id<>'000228' GROUP BY client_id) p, \n"+
                "        (SELECT client_id, min(rent_dt) rent_dt, min(rent_start_dt) rent_start_dt, NVL(trunc(months_between(sysdate, TO_DATE(min(rent_start_dt), 'YYYYMMDD')),0),0) f_rent_mon FROM CONT GROUP BY client_id) p2, \n"+
				"        fee d2, cont a2, users k3 \n"+

				" where a.use_yn='Y' and a.car_st in ('1','3')  \n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+) \n"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) \n"+
				" and i.re_bus_id=j.user_id(+) \n"+
				dt_query +
				sub_query +
				" and a.client_id=c.client_id \n"+
				" and a.car_mng_id=d.car_mng_id \n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq \n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code \n"+
				" and a.bus_id=k.user_id \n"+
				" and a.bus_id2=l.user_id \n"+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \n"+
				" and b.rent_mng_id=es.rent_mng_id(+) and b.rent_l_cd=es.rent_l_cd(+) and b.rent_st=es.rent_st(+) \n"+
				" and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \n"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+						
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+						
					"        and a.rent_mng_id=m.rent_mng_id and a.rent_l_cd=m.rent_l_cd \n"+
					"        and a.client_id=p.client_id(+) \n"+
					"        and a.client_id=p2.client_id \n"+
					"        and m.rent_suc_m_id=d2.rent_mng_id(+) and m.rent_suc_l_cd=d2.rent_l_cd(+) and m.suc_rent_st=d2.rent_st(+) \n"+
					"        and m.rent_suc_m_id=a2.rent_mng_id(+) and m.rent_suc_l_cd=a2.rent_l_cd(+) \n"+
                    "        and a2.bus_id=k3.user_id(+) "+ 
				    "        and ( a2.bus_id='"+bus_id+"' or d2.ext_agnt='"+bus_id+"' or (p.client_id is not null and a.rent_dt >= p.rent_dt) or n.emp_id ='"+sa_code+"' or h.ext_agnt='"+bus_id+"' or a.bus_id='"+bus_id+"' ) "+
				" order by b.rent_end_dt";
        try{
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



        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentEndCondAll]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 계약만료예정현황 조회
     */
    public Vector getRentEndCondAllAgent(String dt,String ref_dt1,String ref_dt2, String gubun3, String gubun4, String bus_id, String sa_code ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String dt_query = "";     
		String sub_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";

		if(dt.equals("1"))				dt_query = " and b.rent_end_dt like "+s_dt2+"||'%' \n";
		else if(dt.equals("2"))			dt_query = " and ( b.rent_end_dt like "+s_dt2+"||'%' or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
		else if(dt.equals("3"))			dt_query = " and ( b.rent_end_dt "+s_dt3+" or b.rent_end_dt < to_char(sysdate,'YYYYMMDD'))\n";
	        
/*		
		query = " select  \n"+
				" a.rent_mng_id, a.rent_l_cd, a.car_mng_id, c.firm_nm,\n"+
				" decode(a.car_st,'4','월렌트',decode(h.rent_way,'1','일반식','2','맞춤식','3','기본식')) rent_way,\n"+
				" decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st, \n"+
				" b.con_mon, b.rent_start_dt, b.rent_end_dt,\n"+
				" g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\n"+
				" a.bus_id, a.bus_id2, k.user_nm as bus_nm, l.user_nm as bus_nm2, sf.fee_est_dt, j.user_nm as re_bus_nm, "+
				" to_char(i.reg_dt,'YYYYMMDD') end_cont_mm_dt, i.content as end_cont_mm_content, \n"+
				" to_char(i2.reg_dt,'YYYYMMDD') end_cont_mm_dt2, i2.content as end_cont_mm_content2, \n"+
				" trunc(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')) dly_day, \n"+
				" trunc((h.fee_s_amt+h.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \n"+
				" decode(es.fee_opt_amt,0,nvl(es.o_1,0),es.fee_opt_amt) as o_1, decode(o.rent_l_cd,'','N','Y') cls_reg_yn, \n"+
				" decode(cc.rent_l_cd,'','','해지반납') call_in_st, n.emp_nm, "+
				" d.car_end_dt, decode(d.car_end_yn,'Y','연장종료','') car_end_yn, d.fuel_kd "+
				" from cont a, \n"+
				"     (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) b,\n"+
				"     (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee where bill_yn='Y' group by rent_mng_id, rent_l_cd) sf,\n"+
				"     client c, car_reg d, car_etc e, car_nm f, car_mng g,\n"+
				"     users k, users l, \n"+
				//2개월이내 i
				"     (select i.rent_mng_id, i.rent_l_cd, i.re_bus_id, i.reg_dt, i.content from end_cont_mm i, (select ia.rent_mng_id, ia.rent_l_cd, max(ia.seq) seq from end_cont_mm ia, cont ib where ia.rent_l_cd=ib.rent_l_cd and ia.reg_dt >= TO_date(ib.rent_end_dt,'YYYYMMDD')-60 group by ia.rent_mng_id, ia.rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i , \n"+
                //2개월이상 i2
				"     (select i.rent_mng_id, i.rent_l_cd, i.re_bus_id, i.reg_dt, i.content from end_cont_mm i, (select ia.rent_mng_id, ia.rent_l_cd, max(ia.seq) seq from end_cont_mm ia, cont ib where ia.rent_l_cd=ib.rent_l_cd and ia.reg_dt <  TO_date(ib.rent_end_dt,'YYYYMMDD')-60 group by ia.rent_mng_id, ia.rent_l_cd ) ii  where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) i2 , \n"+
				"	  users j, fee h, \n"+
				"     (select rent_mng_id, rent_l_cd, rent_st, fee_opt_amt, o_1 from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) es, \n"+
				"     cls_etc o,  \n"+
				"     (select rent_mng_id, rent_l_cd from car_call_in where in_st='3' and out_dt is null ) cc, "+
				"     (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where a.agnt_st='1' and a.emp_id=b.emp_id ) n "+		
				" where a.use_yn='Y' and a.car_st in ('1','3') and a.agent_users like '%"+bus_id+"/%'\n"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
				" and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+)\n"+
				" and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and i.re_bus_id=j.user_id(+) \n"+
				" and a.rent_mng_id=i2.rent_mng_id(+) and a.rent_l_cd=i2.rent_l_cd(+) \n"+
				dt_query +
				sub_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id\n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq\n"+
				" and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"+
				" and a.bus_id=k.user_id\n"+
				" and a.bus_id2=l.user_id "+
				" and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \n"+
				" and b.rent_mng_id=es.rent_mng_id(+) and b.rent_l_cd=es.rent_l_cd(+) and b.rent_st=es.rent_st(+) \n"+
				" and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \n"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)"+						
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+						
				" order by b.rent_end_dt";
*/		
		query = " select  \r\n"
				+ "				 case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end r_end_dt, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, c.firm_nm,\r\n"
				+ "				 decode(a.car_st,'4','월렌트',decode(h.rent_way,'1','일반식','2','맞춤식','3','기본식')) rent_way,\r\n"
				+ "				 decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st, \r\n"
				+ "				 b.con_mon, b.rent_start_dt, b.rent_end_dt,\r\n"
				+ "				 g.car_nm, f.car_name, d.car_no, d.init_reg_dt,\r\n"
				+ "				 a.bus_id, a.bus_id2, k.user_nm as bus_nm, l.user_nm as bus_nm2, sf.fee_est_dt, j.user_nm as re_bus_nm, \r\n"
				+ "				 CASE WHEN i.reg_dt >= TO_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')-60 THEN to_char(i.reg_dt,'YYYYMMDD') ELSE '' END end_cont_mm_dt, \r\n"
				+ "				 CASE WHEN i.reg_dt < TO_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')-60 THEN to_char(i.reg_dt,'YYYYMMDD') ELSE '' END end_cont_mm_dt2, \r\n"
				+ "              i.content as end_cont_mm_content, i.cnt AS end_cont_mm_cnt, \r\n"
				+ "				 trunc(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')) dly_day, \r\n"
				+ "				 trunc((h.fee_s_amt+h.fee_v_amt)/30*to_number(sysdate-to_date(case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt else sf.fee_est_dt end,'YYYYMMDD')),0) dly_amt, \r\n"
				+ "              decode(es.fee_opt_amt,0,nvl(es.o_1,0),es.fee_opt_amt) as o_1, decode(o.rent_l_cd,'','N','Y') cls_reg_yn, \r\n"
				+ "				 decode(cc.rent_l_cd,'','','해지반납') call_in_st, n.emp_nm, \r\n"
				+ "				 d.car_end_dt, decode(d.car_end_yn,'Y','연장종료','') car_end_yn, d.fuel_kd, f.car_comp_id \r\n"
				+ "from          cont a, \r\n"
				+ "				 (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) b,\r\n"
				+ "				 (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee where bill_yn='Y' group by rent_mng_id, rent_l_cd) sf,\r\n"
				+ "				 client c, car_reg d, car_etc e, car_nm f, car_mng g,\r\n"
				+ "				 users k, users l, \r\n"
				+ "              (SELECT mm.*, mm2.cnt FROM end_cont_mm mm, (SELECT rent_mng_id, rent_l_cd, MAX(seq) seq, COUNT(0) cnt FROM end_cont_mm GROUP BY rent_mng_id, rent_l_cd) mm2 WHERE mm.rent_mng_id=mm2.rent_mng_id AND mm.rent_l_cd=mm.rent_l_cd AND mm.seq=mm2.seq) i,\r\n"
				+ "				 users j, users j2, fee h, \r\n"
				+ "              (select rent_mng_id, rent_l_cd, rent_st, fee_opt_amt, o_1 from estimate_sh where est_from='car_janga' and rent_dt=to_char(sysdate,'YYYYMMDD')) es, \r\n"				
				+ "				 cls_etc o,  \r\n"
				+ "				 (select rent_mng_id, rent_l_cd from car_call_in where in_st='3' and out_dt is null ) cc, \r\n"
				+ "				 (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where a.agnt_st='1' and a.emp_id=b.emp_id ) n \r\n"
				+ "where         a.use_yn='Y' and a.car_st in ('1','3') and a.agent_users like '%"+bus_id+"%' \r\n"
				+ "				 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\r\n"
				+ "				 and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+)\r\n"
				+ "				 and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) \r\n"
				+ "              and i.re_bus_id=j.user_id(+) \r\n"
				+ "              and a.mng_id=j2.user_id(+) \r\n"
				+ "				 and a.client_id=c.client_id\r\n"
				+ "				 and a.car_mng_id=d.car_mng_id\r\n"
				+ "				 and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd\r\n"
				+ "				 and e.car_id=f.car_id and e.car_seq=f.car_seq\r\n"
				+ "				 and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\r\n"
				+ "				 and a.bus_id=k.user_id\r\n"
				+ "				 and a.bus_id2=l.user_id \r\n"
				+ "				 and b.rent_mng_id=h.rent_mng_id and b.rent_l_cd=h.rent_l_cd and b.rent_st=h.rent_st \r\n"
				+ "              and b.rent_mng_id=es.rent_mng_id(+) and b.rent_l_cd=es.rent_l_cd(+) and b.rent_st=es.rent_st(+) \n"				
				+ "				 and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \r\n"
				+ "				 and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)\r\n"
				+ "				 and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"
				+ dt_query 
				+ sub_query 
				+ "order by 1 ";		

        try{
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
        }catch(SQLException se){
			 System.out.println("[ConditionDatabase:getRentEndCondAll]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    public String [] getClsCondCar(String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;        
        String val [] = new String[2];
        String query = "";
             
        query = " select a.car_gu, nvl(b.fuel_kd, 'XX') fuel_kd from cont a, car_Reg b where a.rent_l_cd = '"+rent_l_cd + "' and a.car_mng_id = b.car_mng_id(+) ";
	        
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){
                val [0] = rs.getString(1);
                val [1] = rs.getString(2);              
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[ConditionDatabase:getClsCondCar()]"+se);
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
