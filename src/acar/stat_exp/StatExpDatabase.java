/**
 * 지출
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.stat_exp;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.common.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class StatExpDatabase {

    private static StatExpDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized StatExpDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new StatExpDatabase();
        return instance;
    }
    
    private StatExpDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	
	/**
     * 지출 ( 2002/01/16 ) - Kim JungTae
     */
    private StatExpBean makeStatExpBean(ResultSet results) throws DatabaseException {

        try {
            StatExpBean bean = new StatExpBean();

		    bean.setName(results.getString("NAME"));
		    bean.setGubun(results.getString("GUBUN"));
		    bean.setD_gubun(results.getString("D_GUBUN"));
		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));
		    bean.setClient_nm(results.getString("CLIENT_NM"));
		    bean.setFirm_nm(results.getString("FIRM_NM"));
		    bean.setCar_nm(results.getString("CAR_NM"));
		    bean.setCar_name(results.getString("CAR_NAME"));
		    bean.setCar_no(results.getString("CAR_NO"));
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
		    bean.setAmt(results.getString("AMT"));
		    bean.setPlan_dt(results.getString("PLAN_DT"));
		    bean.setColl_dt(results.getString("COLL_DT"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 자동차 등록 리스트 ( 2001/12/28 ) - Kim JungTae
     */
    private RentListBean makeRegListBean(ResultSet results) throws DatabaseException {

        try {
            RentListBean bean = new RentListBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));					//계약관리ID
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//계약코드
		    bean.setRent_dt(results.getString("RENT_DT"));					//계약일자
		    bean.setDlv_dt(results.getString("DLV_DT"));					//출고일자
		    bean.setClient_id(results.getString("CLIENT_ID"));					//고객ID
		    bean.setClient_nm(results.getString("CLIENT_NM"));					//고객 대표자명
		    bean.setFirm_nm(results.getString("FIRM_NM"));						//상호
		    bean.setO_tel(results.getString("O_TEL"));						//사무실전화
		    bean.setFax(results.getString("FAX"));						//FAX
		    bean.setBr_id(results.getString("BR_ID"));						//
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));					//자동차관리ID
		    bean.setInit_reg_dt(results.getString("INIT_REG_DT"));					//최초등록일
		    bean.setReg_gubun(results.getString("REG_GUBUN"));					//최초등록일
		    bean.setCar_no(results.getString("CAR_NO"));						//차량번호
		    bean.setCar_num(results.getString("CAR_NUM"));						//차대번호
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
		    //bean.setBank_nm(results.getString("BANK_NM"));						//은행명
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 계약사항, 자동차 등록 리스트 조회 ( 2002/1/3 ) - Kim JungTae
     */
    public RentListBean  getInsReg(String car_mng_id, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        RentListBean rlb = new RentListBean();
        Statement stmt = null;
        ResultSet rs = null;
                
        String query = "";
        
           
        query = "select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME,\n"//
		+ "i.cpt_cd as CPT_CD\n"
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h\n"
		+ "where a.rent_mng_id ='" + rent_mng_id +"'\n"
		+ "and a.rent_l_cd = upper('" + rent_l_cd + "')\n"
		+ "and b.car_mng_id='" + car_mng_id + "' and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n";

  //      Collection col = new ArrayList();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
                rlb = makeRegListBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + car_mng_id );
                
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
        return rlb;
    }
	/**
     * 과태료, 범칙금 개별조회.
     */
	public StatExpBean getExpProc(String name, String gubun, String d_gubun, String rent_mng_id, String rent_l_cd, String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        StatExpBean seb = new StatExpBean();
        Statement stmt = null;
        ResultSet rs = null;

        String stQuery = "";
        String dtQuery = "";
        String query = "";
        
        if(name.equals("과태료/범칙금"))
        {
        query = "select x.name as Name, x.gubun||' 회' as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
				+ "from (\n"
				+ "select '과태료/범칙금' as name, a.seq_no as gubun, '세부구분' as d_gubun,\n"
				+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
				+ "g.car_nm, f.car_name,b.car_no,a.car_mng_id,a.paid_amt as amt,a.paid_end_dt as plan_dt,a.proxy_dt as coll_dt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f, car_mng g\n"
				+ "where a.car_mng_id='" + car_mng_id + "' and a.car_mng_id=b.car_mng_id \n"
				+ "and a.rent_mng_id='" + rent_mng_id + "' and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd='" + rent_l_cd + "' and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id \n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code) x\n";
		}else if(name.equals("보험료")){
			query = "select x.name as Name, x.gubun||' 회' as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
			+ "from (\n"
			+ "select '보험료' as name, a.ins_tm, a.ins_st,\n"
			+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
			+ "g.car_nm, f.car_name,b.car_no,a.car_mng_id, a.pay_amt, a.ins_est_dt, a.pay_dt \n"
			+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f, car_mng g\n"
			+ "where  a.car_mng_id='" + car_mng_id + "' and a.ins_tm='" + gubun + "' and a.ins_st='" + d_gubun + "' and a.car_mng_id=b.car_mng_id \n"
			+ "and b.car_mng_id=c.car_mng_id\n"
			+ "and c.client_id = d.client_id \n"
			+ "and c.rent_mng_id='" + rent_mng_id + ", and c.rent_l_cd='" + rent_l_cd + "' and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
			+ "and e.car_id = f.car_id(+) and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code) x\n";
		}else if(name.equals("취득세")){
			query = "select x.name as Name, x.gubun||' 회' as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
			+ "from (\n"
			+ "select '취득세' as name,'구분' as gubun, '세부구분' as d_gubun,\n"
			+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
			+ "g.car_nm,f.car_name,a.car_no,a.car_mng_id,a.acq_acq,a.acq_f_dt,a.acq_ex_dt \n"
			+ "from car_reg a, cont c, client d, car_etc e, car_nm f, car_mng g\n"
			+ "where  a.car_mng_id='" + car_mng_id + "' and a.car_mng_id=c.car_mng_id\n"
			+ "and c.client_id = d.client_id \n"
			+ "and c.rent_mng_id='" + rent_mng_id + "' and c.rent_l_cd='" + rent_l_cd + "' and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
			+ "and e.car_id = f.car_id(+) and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code) x\n";
		}else if(name.equals("할부금")){
			query = "select x.name as Name, x.gubun||' 회' as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
			+ "from (\n"
			+ "select '할부금' as name, a.alt_tm as gubun, '구분' as d_gubun,\n"
			+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
			+ "g.car_nm,f.car_name,b.car_no,a.car_mng_id,a.alt_int,a.alt_est_dt,pay_dt \n"
			+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f, car_mng g\n"
			+ "where  a.car_mng_id='" + car_mng_id + "' and a.alt_tm='" + gubun + "' and a.car_mng_id=b.car_mng_id\n"
			+ "and b.car_mng_id=c.car_mng_id\n"
			+ "and c.client_id = d.client_id\n"
			+ "and c.rent_mng_id='" + rent_mng_id + "' and c.rent_l_cd='" + rent_l_cd + "' and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
			+ "and e.car_id = f.car_id(+) and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code) x\n";
		}
				


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
                seb = makeStatExpBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + car_mng_id );
                        
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
        return seb;
    }

	/**
     * 과태료, 범칙금 전체조회.
     */
	public StatExpBean [] getExpAll(String gubun, String gubun_nm,String st, String dt, String ref_dt1, String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;

        String stQuery = "";
        String dtQuery = "";
        String query = "";
        
        if(st.equals("1"))
        {
        	stQuery = " and x.coll_dt is not null ";

        }else if(st.equals("2"))
        {
        	stQuery = " and x.coll_dt is null ";
        }else{
        	stQuery = " ";
        } 
        
        if(dt.equals("2"))
        {
	       	dtQuery = " where x.plan_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
        	
        }else{
        	dtQuery = " where x.plan_dt = to_char(sysdate,'YYYYMMDD') ";
        }
        
        if(gubun.equals("fine"))
        {
        query = "select replace(x.name,' ','') as Name,replace(x.gubun,' ','') as GUBUN,replace(x.d_gubun,' ','') D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
				+ "from (\n"
				+ "select decode(a.fine_st,'1','과태료','2','범칙금') as name, to_char(a.seq_no) as gubun, '세부구분' as d_gubun,\n"
				+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
				+ "'' car_nm, f.car_name,b.car_no,a.car_mng_id,a.paid_amt as amt,a.paid_end_dt as plan_dt,a.proxy_dt as coll_dt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id \n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id \n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)) x\n"
				+ dtQuery
				+ stQuery
				+ "order by x.name, x.firm_nm, x.car_mng_id,x.rent_mng_id,x.gubun\n";
		}else if(gubun.equals("ins")){
			query = "select replace(x.name,' ','') as Name, x.gubun as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
			+ "from (\n"
			+ "select '보험료' as name, a.ins_tm||'회' as gubun, a.ins_st as d_gubun,\n"
			+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
			+ "'' car_nm, f.car_name,b.car_no,a.car_mng_id, a.pay_amt as amt, a.ins_est_dt as plan_dt, a.pay_dt as coll_dt \n"
			+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
			+ "where  a.car_mng_id=b.car_mng_id \n"
			+ "and b.car_mng_id=c.car_mng_id\n"
			+ "and c.client_id = d.client_id \n"
			+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
			+ "and e.car_id = f.car_id(+)) x\n"
			+ dtQuery
			+ stQuery
			+ "order by x.name, x.firm_nm, x.car_mng_id,x.rent_mng_id,x.gubun\n";
		}else if(gubun.equals("acq")){
			query = "select replace(x.name,' ','') as Name, x.gubun as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
			+ "from (\n"
			+ "select '취득세' as name, '구분' as gubun, '세부구분' as d_gubun,\n"
			+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
			+ "'' car_nm, f.car_name,a.car_no,a.car_mng_id,a.acq_acq as amt,a.acq_f_dt as plan_dt,a.acq_ex_dt as coll_dt \n"
			+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
			+ "where  a.car_mng_id=c.car_mng_id\n"
			+ "and c.client_id = d.client_id \n"
			+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
			+ "and e.car_id = f.car_id(+)) x\n"
			+ dtQuery
			+ stQuery
			+ "order by x.name, x.firm_nm, x.car_mng_id,x.rent_mng_id,x.gubun\n";
		}else if(gubun.equals("alt")){
			query = "select replace(x.name,' ','') as Name, x.gubun as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
			+ "from (\n"
			+ "select '할부금' as name, a.alt_tm||'회' as gubun, '구분' as d_gubun,\n"
			+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
			+ "'' car_nm, f.car_name,b.car_no,a.car_mng_id,a.alt_int+a.alt_prn as amt,a.alt_est_dt as plan_dt, a.pay_dt as coll_dt \n"
			+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
			+ "where  a.car_mng_id=b.car_mng_id\n"
			+ "and b.car_mng_id=c.car_mng_id\n"
			+ "and c.client_id = d.client_id\n"
			+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
			+ "and e.car_id = f.car_id(+) \n"
			+ "union all\n"
 			+ "SELECT '할부금' as name, S.alt_tm||'회' as gubun, '구분' as d_gubun, \n"
 			+ "C.rent_mng_id rent_mng_id, decode(D.CODE,'0000','', B.LEND_ID ) rent_l_cd, \n"
 			+ "decode(D.CODE,'0000','','') client_nm, \n"
 			+ "decode(D.CODE,'0000','','') firm_nm, \n"
 			+ "decode(D.CODE,'0000','','') car_name, \n"
 			+ "decode(D.CODE,'0000','','') car_no, \n"
 			+ "decode(D.CODE,'0000','','') car_mng_id,\n"
 			+ "S.alt_prn_amt+S.alt_int_amt, s.alt_est_dt, S.pay_dt \n"
 			+ "FROM CONT C, CAR_REG R, CAR_BANK N, LEND_BANK B , SCD_BANK S, CLIENT L, CODE D \n"
 			+ "WHERE  R.car_mng_id = N.car_mng_id AND \n"
 			+ "C.car_mng_id = R.car_mng_id AND \n"
 			+ "N.lend_id = B.lend_id AND \n"
 			+ "B.lend_id = S.lend_id AND \n"
 			+ "C.client_id = L.client_id AND \n"
 			+ "D.c_st = '0003' AND D.CODE <> '0000' AND \n"
 			+ "D.CODE = B.cont_bn) x\n"
			+ dtQuery
			+ stQuery
			+ "order by x.name, x.firm_nm, x.car_mng_id,x.rent_mng_id,x.gubun\n";
		}else{
			query = "select x.name as Name, x.gubun as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
			+ "from (\n"
			+ "select decode(a.fine_st,'1','과태료','2','범칙금') as name, to_char(a.seq_no) as gubun, '세부구분' as d_gubun,\n"
			+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
			+ "'' car_nm, f.car_name,b.car_no,a.car_mng_id,a.paid_amt as amt,a.paid_end_dt as plan_dt,a.proxy_dt as coll_dt\n"
			+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
			+ "where a.car_mng_id=b.car_mng_id \n"
			+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
			+ "and c.client_id = d.client_id \n"
			+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
			+ "and e.car_id = f.car_id(+)\n"
			+ "union all\n"
			+ "select '보험료' as name, a.ins_tm||'회', a.ins_st,\n"
			+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
			+ "'' car_nm, f.car_name,b.car_no,a.car_mng_id, a.pay_amt, a.ins_est_dt, a.pay_dt \n"
			+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
			+ "where  a.car_mng_id=b.car_mng_id \n"
			+ "and b.car_mng_id=c.car_mng_id\n"
			+ "and c.client_id = d.client_id \n"
			+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
			+ "and e.car_id = f.car_id(+) \n"
			+ "union all\n"
			+ "select '취득세' as name,'구분' as gubun, '세부구분' as d_gubun,\n"
			+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
			+ "'' car_nm, f.car_name,a.car_no,a.car_mng_id,a.acq_acq,a.acq_f_dt,a.acq_ex_dt \n"
			+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
			+ "where  a.car_mng_id=c.car_mng_id\n"
			+ "and c.client_id = d.client_id \n"
			+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
			+ "and e.car_id = f.car_id(+)\n"
			+ "union all\n"
			+ "select '할부금' as name, a.alt_tm||'회' as gubun, '구분' as d_gubun,\n"
			+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
			+ "'' car_nm, f.car_name,b.car_no,a.car_mng_id,a.alt_int+a.alt_prn,a.alt_est_dt, a.pay_dt \n"
			+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
			+ "where  a.car_mng_id=b.car_mng_id\n"
			+ "and b.car_mng_id=c.car_mng_id\n"
			+ "and c.client_id = d.client_id\n"
			+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
			+ "and e.car_id = f.car_id(+)\n"
			+ "union all\n"
 			+ "SELECT '할부금' as name, S.alt_tm||'회' as gubun, '구분' as d_gubun, \n"
 			+ "C.rent_mng_id rent_mng_id, decode(D.CODE,'0000','', B.LEND_ID ) rent_l_cd, \n"
 			+ "decode(D.CODE,'0000','','') client_nm, \n"
 			+ "decode(D.CODE,'0000','','') firm_nm, \n"
 			+ "'' car_nm, decode(D.CODE,'0000','','') car_name, \n"
 			+ "decode(D.CODE,'0000','','') car_no, \n"
 			+ "decode(D.CODE,'0000','','') car_mng_id,\n"
 			+ "S.alt_prn_amt+S.alt_int_amt, s.alt_est_dt, S.pay_dt \n"
 			+ "FROM CONT C, CAR_REG R, CAR_BANK N, LEND_BANK B , SCD_BANK S, CLIENT L, CODE D \n"
 			+ "WHERE  R.car_mng_id = N.car_mng_id AND \n"
 			+ "C.car_mng_id = R.car_mng_id AND \n"
 			+ "N.lend_id = B.lend_id AND \n"
 			+ "B.lend_id = S.lend_id AND \n"
 			+ "C.client_id = L.client_id AND \n"
 			+ "D.c_st = '0003' AND D.CODE <> '0000' AND \n"
 			+ "D.CODE = B.cont_bn) x\n"
 			+ dtQuery
			+ stQuery
			+ "order by x.name, x.firm_nm, x.car_mng_id,x.rent_mng_id,x.gubun\n";
		}
        Collection<StatExpBean> col = new ArrayList<StatExpBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next())
            {
               col.add(makeStatExpBean(rs));
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
        return (StatExpBean[])col.toArray(new StatExpBean[0]);
    }

	/**
     * 과태료, 범칙금 전체조회.
     */
	public StatExpBean [] getExpAll2(String br_id, String gubun, String gubun_nm,String st, String dt, String ref_dt1, String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;

        String stQuery = "";
        String dtQuery = "";
        String query = "";
        
        /*출  금*/if(st.equals("1")){		stQuery = " and x.coll_dt is not null ";
        /*미출금*/}else if(st.equals("2")){	stQuery = " and x.coll_dt is null ";
				  }else{	        		stQuery = " ";
                  } 

		if(gubun.equals("alt")){
	        /*기  간*/if(dt.equals("2")){		dtQuery = " where x.plan_dt between '"+ref_dt1+"' and '"+ ref_dt2+"'";        	
		    /*당  일*/}else{					dtQuery = " where x.plan_dt = to_char(sysdate,'YYYY-MM-DD') ";
					  }
		}else{
	        /*기  간*/if(dt.equals("2")){		dtQuery = " where x.plan_dt between replace('"+ref_dt1+"','-','') and replace('"+ ref_dt2+"','-','') ";        	
		    /*당  일*/}else{					dtQuery = " where x.plan_dt = to_char(sysdate,'YYYYMMDD') ";
					  }
		}

        
        if(gubun.equals("fine")){
	        query = "select replace(x.name,' ','') as Name,replace(x.gubun,' ','') as GUBUN,replace(x.d_gubun,' ','') D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_nm, x.car_name,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
					+ "from (\n"
					+ "select decode(a.fine_st,'1','과태료','2','범칙금') as name, to_char(a.seq_no) as gubun, '세부구분' as d_gubun,\n"
					+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
					+ "g.car_nm,f.car_name,b.car_no,a.car_mng_id,a.paid_amt as amt,a.paid_end_dt as plan_dt,a.proxy_dt as coll_dt\n"
					+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f, car_mng g\n"
					+ "where a.car_mng_id=b.car_mng_id \n"
					+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
					+ "and c.client_id = d.client_id \n"
					+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
					+" and a.paid_st <> '2' and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y'"//추가
				  + "and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code) x\n"
					+ dtQuery
					+ stQuery
					+ "order by x.name, x.firm_nm, x.car_mng_id,x.rent_mng_id,x.gubun\n";
		}else if(gubun.equals("ins")){
			query = "select replace(x.name,' ','') as Name, x.gubun as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_nm, x.car_name,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
					+ "from (\n"
					+ "select '보험료' as name, a.ins_tm||'회' as gubun, a.ins_st as d_gubun,\n"
					+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
					+ "g.car_nm,f.car_name,b.car_no,a.car_mng_id, a.pay_amt as amt, a.ins_est_dt as plan_dt, a.pay_dt as coll_dt \n"
					+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f, car_mng g\n"
					+ "where  a.car_mng_id=b.car_mng_id \n"
					+ "and b.car_mng_id=c.car_mng_id\n"
					+ "and c.client_id = d.client_id \n"
					+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				  + "and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code) x\n"
					+ dtQuery
					+ stQuery
					+ "order by x.name, x.firm_nm, x.car_mng_id,x.rent_mng_id,x.gubun\n";
		}else if(gubun.equals("acq")){
			query = "select replace(x.name,' ','') as Name, x.gubun as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_nm, x.car_name,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
					+ "from (\n"
					+ "select '취득세' as name, '구분' as gubun, '세부구분' as d_gubun,\n"
					+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
					+ "g.car_nm,f.car_name,a.car_no,a.car_mng_id,a.acq_acq as amt,a.acq_f_dt as plan_dt,a.acq_ex_dt as coll_dt \n"
					+ "from car_reg a, cont c, client d, car_etc e, car_nm f, car_mng g\n"
					+ "where  a.car_mng_id=c.car_mng_id\n"
					+ "and c.client_id = d.client_id \n"
					+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				  + "and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code) x\n"					
					+ dtQuery
					+ stQuery
					+ "order by x.name, x.firm_nm, x.car_mng_id,x.rent_mng_id,x.gubun\n";
		}else if(gubun.equals("alt")){
			query = "select replace(x.name,' ','') as Name, x.gubun as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,d.car_nm,c.car_name,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT, x.plan_dt, x.coll_dt\n"
					+ "from (\n"
					+ "select '할부금' as name, alt_tm||'회' as gubun, '구분' as d_gubun,\n"
					+ "rent_mng_id, rent_l_cd, client_nm, firm_nm,\n"
					+ "car_no, car_mng_id, alt_int+alt_prn as amt, r_alt_est_dt as plan_dt, decode(pay_dt,'-','미지출',pay_dt) as coll_dt \n"
					+ "from debt_pay_view) x, cont_n_view b, car_etc g,  car_nm c, car_mng d\n"
				          + "where x.rent_mng_id=b.rent_mng_id(+) and x.rent_l_cd=b.rent_l_cd(+)\n"
				          + " 	and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+)  \n"
                       			+  "   and g.car_id=c.car_id(+)  and    g.car_seq=c.car_seq(+)   \n"
 				         + "     and c.car_comp_id=d.car_comp_id(+) and c.car_cd=d.code(+)\n"
					+ dtQuery
					+ stQuery
					+ "order by x.name, x.firm_nm, x.car_mng_id,x.rent_mng_id,x.gubun\n";
		}else{
			query = "select x.name as Name, x.gubun as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_nm, x.car_name,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
					+ "from (\n"
						+ "select decode(a.fine_st,'1','과태료','2','범칙금') as name, to_char(a.seq_no) as gubun, '세부구분' as d_gubun,\n"
						+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
						+ "g.car_nm,f.car_name,b.car_no,a.car_mng_id,a.paid_amt as amt,a.paid_end_dt as plan_dt,a.proxy_dt as coll_dt\n"
						+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f, car_mng g\n"
						+ "where a.car_mng_id=b.car_mng_id \n"
						+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
						+ "and c.client_id = d.client_id \n"
						+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
						+ "and e.car_id = f.car_id(+)\n"
				    + "and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"
						+" and a.paid_st <> '2' and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y'"//추가
					+ "union all\n"
						+ "select '보험료' as name, a.ins_tm||'회', a.ins_st,\n"
						+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
						+ "g.car_nm,f.car_name,b.car_no,a.car_mng_id, a.pay_amt, a.ins_est_dt, a.pay_dt \n"
						+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f, car_mng g\n"
						+ "where  a.car_mng_id=b.car_mng_id \n"
						+ "and b.car_mng_id=c.car_mng_id\n"
						+ "and c.client_id = d.client_id \n"
						+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				    + "and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"
					+ "union all\n"
						+ "select '취득세' as name,'구분' as gubun, '세부구분' as d_gubun,\n"
						+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
						+ "g.car_nm,f.car_name,a.car_no,a.car_mng_id,a.acq_acq,a.acq_f_dt,a.acq_ex_dt \n"
						+ "from car_reg a, cont c, client d, car_etc e, car_nm f, car_mng g\n"
						+ "where  a.car_mng_id=c.car_mng_id\n"
						+ "and c.client_id = d.client_id \n"
						+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				    + "and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"
					+ "union all\n"
						+ "select '할부금' as name, a.alt_tm||'회' as gubun, '구분' as d_gubun,\n"
						+ "a.rent_mng_id, a.rent_l_cd, a.client_nm, a.firm_nm,\n"
						+ "a.car_nm, a.car_nm as car_name, a.car_no, a.car_mng_id, a.alt_int+a.alt_prn, replace(a.r_alt_est_dt,'-','') as plan_dt, replace(a.pay_dt,'-','') as coll_dt \n"
						+ "from debt_pay_view a\n"
						+ ") x\n"
		 			+ dtQuery
					+ stQuery
					+ "order by x.name, x.firm_nm, x.car_mng_id,x.rent_mng_id,x.gubun\n";
		}
        Collection<StatExpBean> col = new ArrayList<StatExpBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next())
            {
               col.add(makeStatExpBean(rs));
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
        return (StatExpBean[])col.toArray(new StatExpBean[0]);
    }

    /**
     * 지출 통계
     */
    public String [] getExpConSta(String gubun, String gubun_nm,String st, String dt, String ref_dt1, String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String val [] = new String[30];
		String stAlt = "";
		String stIns = "";
		String stFine = "";
		String stAcq = "";
		
		String stAlt_b = "";
		String dtAlt_b = "";
		
        String dtAlt = "";
        String dtIns = "";
        String dtFine = "";
        String dtAcq = "";
        String query = "";
        
        if(st.equals("1"))
        {
        	stAlt = " and a.pay_dt is not null ";
        	stIns = " and a.pay_dt is not null ";
        	stFine = " and a.proxy_dt is not null ";
        	stAcq = " and a.acq_ex_dt is not null ";
        	
        	stAlt_b = " and s.pay_dt is not null ";
        	

        }else if(st.equals("2"))
        {
        	stAlt = " and a.pay_dt is null ";
        	stIns = " and a.pay_dt is null ";
        	stFine = " and a.proxy_dt is null ";
        	stAcq = " and a.acq_ex_dt is null ";
        	
        	stAlt_b = " and s.pay_dt is null ";
        	
        }else{
        	stAlt = "";
        	stIns = "";
        	stFine = "";
        	stAcq = "";
        	
        	stAlt_b = "";
        } 
        
        if(dt.equals("2"))
        {
	       	dtAlt = " and a.alt_est_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
	       	dtIns = " and a.ins_est_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
	       	dtFine = " and a.paid_end_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
	       	dtAcq = " and a.acq_f_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
	       	
	       	dtAlt_b = " and s.alt_est_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
        }else{
        	dtAlt = " and a.alt_est_dt = to_char(sysdate,'YYYYMMDD') ";
        	dtIns = " and a.ins_est_dt = to_char(sysdate,'YYYYMMDD') ";
        	dtFine = " and a.paid_end_dt = to_char(sysdate,'YYYYMMDD') ";
        	dtAcq = " and a.acq_f_dt = to_char(sysdate,'YYYYMMDD') ";
        	
        	dtAlt_b = " and s.alt_est_dt = to_char(sysdate,'YYYYMMDD') ";
        }
    	
        if(gubun.equals(""))
        {
        query = "select fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,\n"
				+ "ins.is_cnt,ins.is_amt,ins.not_cnt,ins.not_amt,ins.t_cnt,ins.t_amt,\n"
				+ "acq.is_cnt,acq.is_amt,acq.not_cnt,acq.not_amt,acq.t_cnt,acq.t_amt,\n"
				+ "alt.is_cnt,alt.is_amt,alt.not_cnt,alt.not_amt,alt.t_cnt,alt.t_amt,\n"
				+ "fine.is_cnt+ins.is_cnt+acq.is_cnt+alt.is_cnt,\n"
				+ "fine.is_amt+ins.is_amt+acq.is_amt+alt.is_amt,\n"
				+ "fine.not_cnt+ins.not_cnt+acq.not_cnt+alt.not_cnt,\n"
				+ "fine.not_amt+ins.not_amt+acq.not_amt+alt.not_amt,\n"
				+ "fine.t_cnt+ins.t_cnt+acq.t_cnt+alt.t_cnt,\n"
				+ "fine.t_amt+ins.t_amt+acq.t_amt+alt.t_amt\n"
				+ "from\n"
				+ "--할부금\n"
				+ "(select (x.is_cnt+g.is_cnt) as is_cnt, (x.is_amt+g.is_amt) as is_amt, (x.not_cnt+g.not_cnt) as not_cnt, \n"
				+ "(x.not_amt+g.not_amt) as not_amt, (x.t_cnt+g.t_cnt) as t_cnt, (x.t_amt+g.t_amt) as t_amt \n"
				+ "from ( \n"
				+ "select nvl(sum(nvl2(a.pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pay_dt,a.alt_int+a.alt_prn,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pay_dt,0,a.alt_int+a.alt_prn)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,1,0)),0)+nvl(sum(nvl2(a.pay_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,a.alt_int+a.alt_prn,0)),0)+nvl(sum(nvl2(a.pay_dt,0,a.alt_int+a.alt_prn)),0) as t_amt\n"
				+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stAlt
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAlt + " ) g, \n"
				+ "(select nvl(sum(nvl2(s.pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(s.pay_dt,s.alt_int_amt+s.alt_prn_amt,0)),0) as is_amt, \n"
				+ "nvl(sum(nvl2(s.pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(s.pay_dt,0,s.alt_int_amt+s.alt_prn_amt)),0) as not_amt, \n"
				+ "nvl(sum(nvl2(s.pay_dt,1,0)),0)+nvl(sum(nvl2(s.pay_dt,0,1)),0) as t_cnt, \n"
				+ "nvl(sum(nvl2(s.pay_dt,s.alt_int_amt+s.alt_prn_amt,0)),0)+nvl(sum(nvl2(s.pay_dt,0,s.alt_int_amt+s.alt_prn_amt)),0) as t_amt \n"
				+ "from CONT C, CAR_REG R, CAR_BANK N, LEND_BANK B , BANK_SCHE S, CLIENT L, CODE D \n"
				+ "WHERE R.car_mng_id = N.car_mng_id \n"
				+ stAlt_b
				+ "and N.lend_id = B.lend_id AND \n"
				+ "B.lend_id = S.lend_id AND \n"
				+ "C.client_id = L.client_id AND \n"
				+ "D.c_st = '0003' AND D.CODE <> '0000' AND \n"
				+ "D.CODE = B.cont_bn \n"
				+ dtAlt_b + ") x \n"
				+ ") alt,\n"
				+ "--보험료\n"
				+ "(select nvl(sum(nvl2(a.pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pay_dt,a.pay_amt,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pay_dt,0,a.pay_amt)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,1,0)),0)+nvl(sum(nvl2(a.pay_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,a.pay_amt,0)),0)+nvl(sum(nvl2(a.pay_dt,0,a.pay_amt)),0) as t_amt\n"
				+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stIns
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtIns + " ) ins,\n"
				+ "--과태료\n"
				+ "(select nvl(sum(nvl2(a.proxy_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.proxy_dt,a.paid_amt,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.proxy_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.proxy_dt,0,a.paid_amt)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.proxy_dt,1,0)),0)+nvl(sum(nvl2(a.proxy_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.proxy_dt,a.paid_amt,0)),0)+nvl(sum(nvl2(a.proxy_dt,0,a.paid_amt)),0) as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ stFine
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+" and a.paid_st <> '2' and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y'"//추가
				+ dtFine + " ) fine,\n"
				+ "--취득세\n"
				+ "(select nvl(sum(nvl2(a.acq_ex_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.acq_ex_dt,a.acq_acq,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.acq_ex_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.acq_ex_dt,0,a.acq_acq)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.acq_ex_dt,1,0)),0)+nvl(sum(nvl2(a.acq_ex_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.acq_ex_dt,a.acq_acq,0)),0)+nvl(sum(nvl2(a.acq_ex_dt,0,a.acq_acq)),0) as t_amt\n"
				+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=c.car_mng_id\n"
				+ stAcq
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAcq + " ) acq\n";
		}else if(gubun.equals("alt")){
		query = "select fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,\n"
				+ "ins.is_cnt,ins.is_amt,ins.not_cnt,ins.not_amt,ins.t_cnt,ins.t_amt,\n"
				+ "acq.is_cnt,acq.is_amt,acq.not_cnt,acq.not_amt,acq.t_cnt,acq.t_amt,\n"
				+ "alt.is_cnt,alt.is_amt,alt.not_cnt,alt.not_amt,alt.t_cnt,alt.t_amt,\n"
				+ "fine.is_cnt+ins.is_cnt+acq.is_cnt+alt.is_cnt,\n"
				+ "fine.is_amt+ins.is_amt+acq.is_amt+alt.is_amt,\n"
				+ "fine.not_cnt+ins.not_cnt+acq.not_cnt+alt.not_cnt,\n"
				+ "fine.not_amt+ins.not_amt+acq.not_amt+alt.not_amt,\n"
				+ "fine.t_cnt+ins.t_cnt+acq.t_cnt+alt.t_cnt,\n"
				+ "fine.t_amt+ins.t_amt+acq.t_amt+alt.t_amt\n"
				+ "from\n"
				+ "--할부금\n"
				+ "(select nvl(sum(nvl2(a.pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pay_dt,a.alt_int+a.alt_prn,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pay_dt,0,a.alt_int+a.alt_prn)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,1,0)),0)+nvl(sum(nvl2(a.pay_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,a.alt_int+a.alt_prn,0)),0)+nvl(sum(nvl2(a.pay_dt,0,a.alt_int+a.alt_prn)),0) as t_amt\n"
				+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stAlt
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAlt + " ) alt,\n"
				+ "--보험료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n" 
				+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stIns
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtIns + " ) ins,\n"
				+ "--과태료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ stFine
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtFine + " ) fine,\n"
				+ "--취득세\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=c.car_mng_id\n"
				+ stAcq
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAcq + " ) acq\n";
		}else if(gubun.equals("ins")){
		query = "select fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,\n"
				+ "ins.is_cnt,ins.is_amt,ins.not_cnt,ins.not_amt,ins.t_cnt,ins.t_amt,\n"
				+ "acq.is_cnt,acq.is_amt,acq.not_cnt,acq.not_amt,acq.t_cnt,acq.t_amt,\n"
				+ "alt.is_cnt,alt.is_amt,alt.not_cnt,alt.not_amt,alt.t_cnt,alt.t_amt,\n"
				+ "fine.is_cnt+ins.is_cnt+acq.is_cnt+alt.is_cnt,\n"
				+ "fine.is_amt+ins.is_amt+acq.is_amt+alt.is_amt,\n"
				+ "fine.not_cnt+ins.not_cnt+acq.not_cnt+alt.not_cnt,\n"
				+ "fine.not_amt+ins.not_amt+acq.not_amt+alt.not_amt,\n"
				+ "fine.t_cnt+ins.t_cnt+acq.t_cnt+alt.t_cnt,\n"
				+ "fine.t_amt+ins.t_amt+acq.t_amt+alt.t_amt\n"
				+ "from\n"
				+ "--할부금\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stAlt
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAlt + " ) alt,\n"
				+ "--보험료\n"
				+ "(select nvl(sum(nvl2(a.pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pay_dt,a.pay_amt,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pay_dt,0,a.pay_amt)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,1,0)),0)+nvl(sum(nvl2(a.pay_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,a.pay_amt,0)),0)+nvl(sum(nvl2(a.pay_dt,0,a.pay_amt)),0) as t_amt\n"
				+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stIns
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtIns + " ) ins,\n"
				+ "--과태료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ stFine
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtFine + " ) fine,\n"
				+ "--취득세\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=c.car_mng_id\n"
				+ stAcq
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAcq + " ) acq\n";
		}else if(gubun.equals("fine")){
		query = "select fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,\n"
				+ "ins.is_cnt,ins.is_amt,ins.not_cnt,ins.not_amt,ins.t_cnt,ins.t_amt,\n"
				+ "acq.is_cnt,acq.is_amt,acq.not_cnt,acq.not_amt,acq.t_cnt,acq.t_amt,\n"
				+ "alt.is_cnt,alt.is_amt,alt.not_cnt,alt.not_amt,alt.t_cnt,alt.t_amt,\n"
				+ "fine.is_cnt+ins.is_cnt+acq.is_cnt+alt.is_cnt,\n"
				+ "fine.is_amt+ins.is_amt+acq.is_amt+alt.is_amt,\n"
				+ "fine.not_cnt+ins.not_cnt+acq.not_cnt+alt.not_cnt,\n"
				+ "fine.not_amt+ins.not_amt+acq.not_amt+alt.not_amt,\n"
				+ "fine.t_cnt+ins.t_cnt+acq.t_cnt+alt.t_cnt,\n"
				+ "fine.t_amt+ins.t_amt+acq.t_amt+alt.t_amt\n"
				+ "from\n"
				+ "--할부금\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stAlt
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAlt + " ) alt,\n"
				+ "--보험료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stIns
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtIns + " ) ins,\n"
				+ "--과태료\n"
				+ "(select nvl(sum(nvl2(a.proxy_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.proxy_dt,a.paid_amt,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.proxy_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.proxy_dt,0,a.paid_amt)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.proxy_dt,1,0)),0)+nvl(sum(nvl2(a.proxy_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.proxy_dt,a.paid_amt,0)),0)+nvl(sum(nvl2(a.proxy_dt,0,a.paid_amt)),0) as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ stFine
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+" and a.paid_st <> '2' and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y'"//추가
				+ dtFine + " ) fine,\n"
				+ "--취득세\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=c.car_mng_id\n"
				+ stAcq
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAcq + " ) acq\n";
		}else if(gubun.equals("acq")){
		query = "select fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,\n"
				+ "ins.is_cnt,ins.is_amt,ins.not_cnt,ins.not_amt,ins.t_cnt,ins.t_amt,\n"
				+ "acq.is_cnt,acq.is_amt,acq.not_cnt,acq.not_amt,acq.t_cnt,acq.t_amt,\n"
				+ "alt.is_cnt,alt.is_amt,alt.not_cnt,alt.not_amt,alt.t_cnt,alt.t_amt,\n"
				+ "fine.is_cnt+ins.is_cnt+acq.is_cnt+alt.is_cnt,\n"
				+ "fine.is_amt+ins.is_amt+acq.is_amt+alt.is_amt,\n"
				+ "fine.not_cnt+ins.not_cnt+acq.not_cnt+alt.not_cnt,\n"
				+ "fine.not_amt+ins.not_amt+acq.not_amt+alt.not_amt,\n"
				+ "fine.t_cnt+ins.t_cnt+acq.t_cnt+alt.t_cnt,\n"
				+ "fine.t_amt+ins.t_amt+acq.t_amt+alt.t_amt\n"
				+ "from\n"
				+ "--할부금\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stAlt
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAlt + " ) alt,\n"
				+ "--보험료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stIns
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtIns + " ) ins,\n"
				+ "--과태료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ stFine
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtFine + " ) fine,\n"
				+ "--취득세\n"
				+ "(select nvl(sum(nvl2(a.acq_ex_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.acq_ex_dt,a.acq_acq,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.acq_ex_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.acq_ex_dt,0,a.acq_acq)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.acq_ex_dt,1,0)),0)+nvl(sum(nvl2(a.acq_ex_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.acq_ex_dt,a.acq_acq,0)),0)+nvl(sum(nvl2(a.acq_ex_dt,0,a.acq_acq)),0) as t_amt\n"
				+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=c.car_mng_id\n"
				+ stAcq
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAcq + " ) acq\n";
		}
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
                val [27] = rs.getString(28);
                val [28] = rs.getString(29);
                val [29] = rs.getString(30);
                
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
     * 지출 통계
     */
    public String [] getExpConSta2(String gubun, String gubun_nm,String st, String dt, String ref_dt1, String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String val [] = new String[30];
		String stAlt = "";
		String stIns = "";
		String stFine = "";
		String stAcq = "";
			
        String dtAlt = "";
        String dtIns = "";
        String dtFine = "";
        String dtAcq = "";
        String query = "";
        
        if(st.equals("1")){
        	stAlt = " and pay_dt is not null ";
        	stIns = " and a.pay_dt is not null ";
        	stFine = " and a.proxy_dt is not null ";
        	stAcq = " and a.acq_ex_dt is not null ";        	
        }else if(st.equals("2")){
        	stAlt = " and pay_dt is null ";
        	stIns = " and a.pay_dt is null ";
        	stFine = " and a.proxy_dt is null ";
        	stAcq = " and a.acq_ex_dt is null ";        	
        }else{
        	stAlt = "";
        	stIns = "";
        	stFine = "";
        	stAcq = "";        	
        } 
        
        if(dt.equals("2")){
	       	dtAlt = " and r_alt_est_dt between '" + ref_dt1 + "' and '" + ref_dt2 + "'";
	       	dtIns = " and a.ins_est_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
	       	dtFine = " and a.paid_end_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
	       	dtAcq = " and a.acq_f_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";	       	
        }else{
        	dtAlt = " and r_alt_est_dt = to_char(sysdate,'YYYY-MM-DD') ";
        	dtIns = " and a.ins_est_dt = to_char(sysdate,'YYYYMMDD') ";
        	dtFine = " and a.paid_end_dt = to_char(sysdate,'YYYYMMDD') ";
        	dtAcq = " and a.acq_f_dt = to_char(sysdate,'YYYYMMDD') ";        	
        }
    	
        if(gubun.equals(""))
        {
        query = "select fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,\n"
				+ "ins.is_cnt,ins.is_amt,ins.not_cnt,ins.not_amt,ins.t_cnt,ins.t_amt,\n"
				+ "acq.is_cnt,acq.is_amt,acq.not_cnt,acq.not_amt,acq.t_cnt,acq.t_amt,\n"
				+ "alt.is_cnt,alt.is_amt,alt.not_cnt,alt.not_amt,alt.t_cnt,alt.t_amt,\n"
				+ "fine.is_cnt+ins.is_cnt+acq.is_cnt+alt.is_cnt,\n"
				+ "fine.is_amt+ins.is_amt+acq.is_amt+alt.is_amt,\n"
				+ "fine.not_cnt+ins.not_cnt+acq.not_cnt+alt.not_cnt,\n"
				+ "fine.not_amt+ins.not_amt+acq.not_amt+alt.not_amt,\n"
				+ "fine.t_cnt+ins.t_cnt+acq.t_cnt+alt.t_cnt,\n"
				+ "fine.t_amt+ins.t_amt+acq.t_amt+alt.t_amt\n"
				+ "from\n"
					+ "--할부금\n"
					+ "(select g.is_cnt, g.is_amt, g.not_cnt, \n"
					+ "g.not_amt, g.t_cnt, g.t_amt\n"
					+ "from ( \n"
						+ "select nvl(sum(nvl2(replace(pay_dt,'-',''), 1, 0)),0) as is_cnt, nvl(sum(nvl2(replace(pay_dt,'-',''), alt_int+alt_prn, 0)),0) as is_amt,\n"
						+ "nvl(sum(nvl2(replace(pay_dt,'-',''), 0, 1)),0) as not_cnt, nvl(sum(nvl2(replace(pay_dt,'-',''), 0, alt_int+alt_prn)),0) as not_amt,\n"
						+ "nvl(sum(nvl2(replace(pay_dt,'-',''), 1, 0)),0)+nvl(sum(nvl2(replace(pay_dt,'-',''), 0, 1)),0) as t_cnt,\n"
						+ "nvl(sum(nvl2(replace(pay_dt,'-',''), alt_int+alt_prn,0)),0)+nvl(sum(nvl2(replace(pay_dt,'-',''), 0, alt_int+alt_prn)),0) as t_amt\n"
						+ "from debt_pay_view\n"
						+ "where rent_l_cd=rent_l_cd\n"
						+ stAlt
						+ dtAlt + " ) g\n"
					+ ") alt,\n"
					+ "--보험료\n"
					+ "(select nvl(sum(nvl2(a.pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pay_dt,a.pay_amt,0)),0) as is_amt,\n"
					+ "nvl(sum(nvl2(a.pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pay_dt,0,a.pay_amt)),0) as not_amt,\n"
					+ "nvl(sum(nvl2(a.pay_dt,1,0)),0)+nvl(sum(nvl2(a.pay_dt,0,1)),0) as t_cnt,\n"
					+ "nvl(sum(nvl2(a.pay_dt,a.pay_amt,0)),0)+nvl(sum(nvl2(a.pay_dt,0,a.pay_amt)),0) as t_amt\n"
					+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
					+ "where  a.car_mng_id=b.car_mng_id\n"
					+ stIns
					+ "and b.car_mng_id=c.car_mng_id\n"
					+ "and c.client_id = d.client_id\n"
					+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
					+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
					+ dtIns + " ) ins,\n"
					+ "--과태료\n"
					+ "(select nvl(sum(nvl2(a.proxy_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.proxy_dt,a.paid_amt,0)),0) as is_amt,\n"
					+ "nvl(sum(nvl2(a.proxy_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.proxy_dt,0,a.paid_amt)),0) as not_amt,\n"
					+ "nvl(sum(nvl2(a.proxy_dt,1,0)),0)+nvl(sum(nvl2(a.proxy_dt,0,1)),0) as t_cnt,\n"
					+ "nvl(sum(nvl2(a.proxy_dt,a.paid_amt,0)),0)+nvl(sum(nvl2(a.proxy_dt,0,a.paid_amt)),0) as t_amt\n"
					+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
					+ "where a.car_mng_id=b.car_mng_id\n"
					+ stFine
					+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
					+ "and c.client_id = d.client_id\n"
					+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
					+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+) \n"
					+" and a.paid_st <> '2' and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y'"//추가
					+ dtFine + " ) fine,\n"
					+ "--취득세\n"
					+ "(select nvl(sum(nvl2(a.acq_ex_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.acq_ex_dt,a.acq_acq,0)),0) as is_amt,\n"
					+ "nvl(sum(nvl2(a.acq_ex_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.acq_ex_dt,0,a.acq_acq)),0) as not_amt,\n"
					+ "nvl(sum(nvl2(a.acq_ex_dt,1,0)),0)+nvl(sum(nvl2(a.acq_ex_dt,0,1)),0) as t_cnt,\n"
					+ "nvl(sum(nvl2(a.acq_ex_dt,a.acq_acq,0)),0)+nvl(sum(nvl2(a.acq_ex_dt,0,a.acq_acq)),0) as t_amt\n"
					+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
					+ "where  a.car_mng_id=c.car_mng_id\n"
					+ stAcq
					+ "and c.client_id = d.client_id\n"
					+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
					+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
					+ dtAcq + " ) acq\n";
		}else if(gubun.equals("alt")){
		query = "select fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,\n"
				+ "ins.is_cnt,ins.is_amt,ins.not_cnt,ins.not_amt,ins.t_cnt,ins.t_amt,\n"
				+ "acq.is_cnt,acq.is_amt,acq.not_cnt,acq.not_amt,acq.t_cnt,acq.t_amt,\n"
				+ "alt.is_cnt,alt.is_amt,alt.not_cnt,alt.not_amt,alt.t_cnt,alt.t_amt,\n"
				+ "fine.is_cnt+ins.is_cnt+acq.is_cnt+alt.is_cnt,\n"
				+ "fine.is_amt+ins.is_amt+acq.is_amt+alt.is_amt,\n"
				+ "fine.not_cnt+ins.not_cnt+acq.not_cnt+alt.not_cnt,\n"
				+ "fine.not_amt+ins.not_amt+acq.not_amt+alt.not_amt,\n"
				+ "fine.t_cnt+ins.t_cnt+acq.t_cnt+alt.t_cnt,\n"
				+ "fine.t_amt+ins.t_amt+acq.t_amt+alt.t_amt\n"
				+ "from\n"
				+ "--할부금\n"
				+ "(select nvl(sum(nvl2(replace(pay_dt,'-',''),1,0)),0) as is_cnt,nvl(sum(nvl2(replace(pay_dt,'-',''),alt_int+alt_prn,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(replace(pay_dt,'-',''),0,1)),0) as not_cnt,nvl(sum(nvl2(replace(pay_dt,'-',''),0,alt_int+alt_prn)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(replace(pay_dt,'-',''),1,0)),0)+nvl(sum(nvl2(replace(pay_dt,'-',''),0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(replace(pay_dt,'-',''),alt_int+alt_prn,0)),0)+nvl(sum(nvl2(replace(pay_dt,'-',''),0,alt_int+alt_prn)),0) as t_amt\n"
				+ "from debt_pay_view\n"
				+ "where rent_l_cd=rent_l_cd\n"
				+ stAlt
				+ dtAlt + " ) alt,\n"
				+ "--보험료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n" 
				+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stIns
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtIns + " ) ins,\n"
				+ "--과태료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ stFine
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtFine + " ) fine,\n"
				+ "--취득세\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=c.car_mng_id\n"
				+ stAcq
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtAcq + " ) acq\n";
		}else if(gubun.equals("ins")){
		query = "select fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,\n"
				+ "ins.is_cnt,ins.is_amt,ins.not_cnt,ins.not_amt,ins.t_cnt,ins.t_amt,\n"
				+ "acq.is_cnt,acq.is_amt,acq.not_cnt,acq.not_amt,acq.t_cnt,acq.t_amt,\n"
				+ "alt.is_cnt,alt.is_amt,alt.not_cnt,alt.not_amt,alt.t_cnt,alt.t_amt,\n"
				+ "fine.is_cnt+ins.is_cnt+acq.is_cnt+alt.is_cnt,\n"
				+ "fine.is_amt+ins.is_amt+acq.is_amt+alt.is_amt,\n"
				+ "fine.not_cnt+ins.not_cnt+acq.not_cnt+alt.not_cnt,\n"
				+ "fine.not_amt+ins.not_amt+acq.not_amt+alt.not_amt,\n"
				+ "fine.t_cnt+ins.t_cnt+acq.t_cnt+alt.t_cnt,\n"
				+ "fine.t_amt+ins.t_amt+acq.t_amt+alt.t_amt\n"
				+ "from\n"
				+ "--할부금\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stAlt
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtAlt + " ) alt,\n"
				+ "--보험료\n"
				+ "(select nvl(sum(nvl2(a.pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pay_dt,a.pay_amt,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pay_dt,0,a.pay_amt)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,1,0)),0)+nvl(sum(nvl2(a.pay_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.pay_dt,a.pay_amt,0)),0)+nvl(sum(nvl2(a.pay_dt,0,a.pay_amt)),0) as t_amt\n"
				+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stIns
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtIns + " ) ins,\n"
				+ "--과태료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ stFine
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtFine + " ) fine,\n"
				+ "--취득세\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=c.car_mng_id\n"
				+ stAcq
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtAcq + " ) acq\n";
		}else if(gubun.equals("fine")){
		query = "select fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,\n"
				+ "ins.is_cnt,ins.is_amt,ins.not_cnt,ins.not_amt,ins.t_cnt,ins.t_amt,\n"
				+ "acq.is_cnt,acq.is_amt,acq.not_cnt,acq.not_amt,acq.t_cnt,acq.t_amt,\n"
				+ "alt.is_cnt,alt.is_amt,alt.not_cnt,alt.not_amt,alt.t_cnt,alt.t_amt,\n"
				+ "fine.is_cnt+ins.is_cnt+acq.is_cnt+alt.is_cnt,\n"
				+ "fine.is_amt+ins.is_amt+acq.is_amt+alt.is_amt,\n"
				+ "fine.not_cnt+ins.not_cnt+acq.not_cnt+alt.not_cnt,\n"
				+ "fine.not_amt+ins.not_amt+acq.not_amt+alt.not_amt,\n"
				+ "fine.t_cnt+ins.t_cnt+acq.t_cnt+alt.t_cnt,\n"
				+ "fine.t_amt+ins.t_amt+acq.t_amt+alt.t_amt\n"
				+ "from\n"
				+ "--할부금\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stAlt
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtAlt + " ) alt,\n"
				+ "--보험료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stIns
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtIns + " ) ins,\n"
				+ "--과태료\n"
				+ "(select nvl(sum(nvl2(a.proxy_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.proxy_dt,a.paid_amt,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.proxy_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.proxy_dt,0,a.paid_amt)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.proxy_dt,1,0)),0)+nvl(sum(nvl2(a.proxy_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.proxy_dt,a.paid_amt,0)),0)+nvl(sum(nvl2(a.proxy_dt,0,a.paid_amt)),0) as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ stFine
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+" and a.paid_st <> '2' and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y'"//추가
				+ dtFine + " ) fine,\n"
				+ "--취득세\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=c.car_mng_id\n"
				+ stAcq
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAcq + " ) acq\n";
		}else if(gubun.equals("acq")){
		query = "select fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,\n"
				+ "ins.is_cnt,ins.is_amt,ins.not_cnt,ins.not_amt,ins.t_cnt,ins.t_amt,\n"
				+ "acq.is_cnt,acq.is_amt,acq.not_cnt,acq.not_amt,acq.t_cnt,acq.t_amt,\n"
				+ "alt.is_cnt,alt.is_amt,alt.not_cnt,alt.not_amt,alt.t_cnt,alt.t_amt,\n"
				+ "fine.is_cnt+ins.is_cnt+acq.is_cnt+alt.is_cnt,\n"
				+ "fine.is_amt+ins.is_amt+acq.is_amt+alt.is_amt,\n"
				+ "fine.not_cnt+ins.not_cnt+acq.not_cnt+alt.not_cnt,\n"
				+ "fine.not_amt+ins.not_amt+acq.not_amt+alt.not_amt,\n"
				+ "fine.t_cnt+ins.t_cnt+acq.t_cnt+alt.t_cnt,\n"
				+ "fine.t_amt+ins.t_amt+acq.t_amt+alt.t_amt\n"
				+ "from\n"
				+ "--할부금\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stAlt
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAlt + " ) alt,\n"
				+ "--보험료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=b.car_mng_id\n"
				+ stIns
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtIns + " ) ins,\n"
				+ "--과태료\n"
				+ "(select nvl(min(0),0) as is_cnt,0 as is_amt,\n"
				+ "0 as not_cnt,0 as not_amt,\n"
				+ "0 as t_cnt,\n"
				+ "0 as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ stFine
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtFine + " ) fine,\n"
				+ "--취득세\n"
				+ "(select nvl(sum(nvl2(a.acq_ex_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.acq_ex_dt,a.acq_acq,0)),0) as is_amt,\n"
				+ "nvl(sum(nvl2(a.acq_ex_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.acq_ex_dt,0,a.acq_acq)),0) as not_amt,\n"
				+ "nvl(sum(nvl2(a.acq_ex_dt,1,0)),0)+nvl(sum(nvl2(a.acq_ex_dt,0,1)),0) as t_cnt,\n"
				+ "nvl(sum(nvl2(a.acq_ex_dt,a.acq_acq,0)),0)+nvl(sum(nvl2(a.acq_ex_dt,0,a.acq_acq)),0) as t_amt\n"
				+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id=c.car_mng_id\n"
				+ stAcq
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and  e.car_seq = f.car_seq(+)\n"
				+ dtAcq + " ) acq\n";
		}
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
                val [27] = rs.getString(28);
                val [28] = rs.getString(29);
                val [29] = rs.getString(30);
                
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
     * 보험지출처리
     */
    public int updateExpInsProc(String car_mng_id, String ins_st, String ins_tm, String pay_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
        
                
        query="update scd_ins set PAY_YN=?,PAY_DT=replace(?,'-','')\n"
				+ "where car_mng_id=? and ins_st=? and ins_tm=?";
            
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, "1");
            pstmt.setString(2, pay_dt.trim());
            pstmt.setString(3, car_mng_id.trim());
            pstmt.setString(4, ins_st.trim());
            pstmt.setString(5, ins_tm.trim());
                        
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
	}
	/**
     * 자동차등록 취득세 지출처리.
     */
    public int updateExpAcqProc(String car_mng_id, String acq_ex_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query="UPDATE CAR_REG\n"
        		+ "SET ACQ_EX_DT=replace(?,'-','')\n"
			+ "WHERE CAR_MNG_ID=?\n";
           
       try{
            con.setAutoCommit(false);
            
            pstmt = con.prepareStatement(query);
            
			pstmt.setString(1, acq_ex_dt.trim());
			pstmt.setString(2, car_mng_id.trim());
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
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
}
