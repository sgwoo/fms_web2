/*
 * 자동차등록
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.forfeit_mng;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.common.*;
import acar.account.*;
import acar.client.ClientBean;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class ForfeitDatabase {

    private static ForfeitDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized ForfeitDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new ForfeitDatabase();
        return instance;
    }
    
    private ForfeitDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	/**
     * 과태료,범칙금
     */
    private FineBean makeFineBean(ResultSet results) throws DatabaseException {

        try {
            FineBean bean = new FineBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					//자동차관리번호
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));			//계약관리번호
			bean.setRent_l_cd(results.getString("RENT_L_CD"));			//계약번호
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setFine_st(results.getString("FINE_ST"));
			bean.setCar_name(results.getString("CAR_NAME"));
			bean.setSeq_no(results.getInt("SEQ_NO"));					//SEQ_NO
			bean.setCall_nm(results.getString("CALL_NM"));				//통화자
			bean.setTel(results.getString("TEL"));					//전화번호
			bean.setFax(results.getString("FAX"));					//팩스
			bean.setVio_dt(results.getString("VIO_DT"));				//위반일시
			bean.setVio_dt_view(results.getString("VIO_DT_VIEW"));
			bean.setVio_pla(results.getString("VIO_PLA"));				//위반장소
			bean.setVio_cont(results.getString("VIO_CONT"));			//위반내용
			bean.setPaid_st(results.getString("PAID_ST"));				//납부구분
			bean.setRec_dt(results.getString("REC_DT"));				//영수일자
			bean.setPaid_end_dt(results.getString("PAID_END_DT"));			//납부기한
			bean.setPaid_amt(results.getInt("PAID_AMT"));				//납부금액
			bean.setProxy_dt(results.getString("PROXY_DT"));			//대납일자
			bean.setPol_sta(results.getString("POL_STA"));				//경찰서
			bean.setPaid_no(results.getString("PAID_NO"));				//납부고지서번호
			bean.setFault_st(results.getString("FAULT_ST"));			//과실구분
			bean.setDem_dt(results.getString("DEM_DT"));				//청구일자
			bean.setColl_dt(results.getString("COLL_DT"));				//수금일자
			bean.setRec_plan_dt(results.getString("REC_PLAN_DT"));			//입금예정일
			bean.setNote(results.getString("NOTE"));				//특이사항
		    
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
		    bean.setCar_nm(results.getString("CAR_NM"));
		    bean.setRent_start_dt(results.getString("RENT_START_DT"));				//대여개시일
		    bean.setRent_end_dt(results.getString("RENT_END_DT"));					//대여종료일
		    bean.setReg_ext_dt(results.getString("REG_EXT_DT"));					//등록예정일
		    bean.setRpt_no(results.getString("RPT_NO"));						//계출번호
		    bean.setCpt_cd(results.getString("CPT_CD"));						//은행코드
		    bean.setScan_file(results.getString("SCAN_FILE"));						//은행코드
		    //bean.setBank_nm(results.getString("BANK_NM"));						//은행명
		    bean.setBr_id(results.getString("BRCH_ID"));						//
		    bean.setCar_doc_no(results.getString("CAR_DOC_NO"));						//
		    bean.setFine_mm(results.getString("FINE_MM"));						//
		    bean.setBus_id2(results.getString("BUS_ID2"));						//
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}
	/**
     * 과태료,범칙금 통화 ( 2001/12/28 ) - Kim JungTae
     */
    private FineCallBean makeFineCallBean(ResultSet results) throws DatabaseException {

        try {
            FineCallBean bean = new FineCallBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));					//계약관리ID
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//계약코드
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));					//자동차관리ID
		    bean.setCar_no(results.getString("CAR_NO"));						//차량번호
		    bean.setCall_dt(results.getString("CALL_DT"));						//통화일
		    bean.setCall_cont(results.getString("CALL_CONT"));					//통화내용
		    bean.setReg_nm(results.getString("REG_NM"));						//등록자
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}	

	/**
     * 과태료, 범칙금 개별조회.
     */
	public RentListBean getCarRent( String car_mng_id, String rent_mng_id, String rent_l_cd ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        RentListBean rlb = new RentListBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        
        String query = "";
        
        query = "select a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
		+ "i.cpt_cd as CPT_CD, a.scan_file, b.car_doc_no, a.fine_mm, a.bus_id2\n"//,j.nm as BANK_NM
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j\n"//--, code j
		+ "where a.rent_mng_id = '" + rent_mng_id + "'\n"
		+ "and a.rent_l_cd = '" + rent_l_cd + "' \n"//and nvl(a.use_yn,'Y')='Y'
		+ "and a.car_mng_id = b.car_mng_id and b.car_mng_id = '" + car_mng_id + "'\n"
		+ "and a.client_id = c.client_id \n"
		+ "and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+) and g.car_seq=h.car_seq and h.car_comp_id=j.car_comp_id and h.car_cd=j.code(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n";
		//+ "and j.c_st = '0003'\n"
		//+ "and j.code <> '0000'\n"
		//+ "and i.cpt_cd = j.code(+)\n"

//System.out.println("getCar_Rent(: "+query);

 //       Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            //pstmt.setString(1, c_st.trim());

            rs = pstmt.executeQuery(query);

            if (rs.next())
            {
                rlb = makeRegListBean(rs);
            }
            //else
               // throw new UnknownDataException("Could not find Appcode # " + rent_l_cd );
            
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return rlb;
    }
    /**
     * 과태료 범칙금 등록시 계약 조회 ( 2002/1/10 ) - Kim JungTae
     */
    public RentListBean [] getCarRentListAll( String gubun, String rent_l_cd, String firm_nm, String car_no ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        
        String query = "";
        
        query = "select a.brch_id, a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, decode(a.rent_dt,null,'',substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2)) as RENT_DT, decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as DLV_DT, a.client_id as CLIENT_ID,a.reg_id as REG_ID,\n" 
        + "c.client_nm as CLIENT_NM, c.firm_nm as FIRM_NM,c.o_tel as O_TEL,c.fax as FAX,e.br_id as BR_ID,\n" 
		+ "b.car_mng_id as CAR_MNG_ID, decode(b.init_reg_dt,null,'미등록',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, decode(b.init_reg_dt,null,'id','ud') as REG_GUBUN, b.car_no as CAR_NO, b.car_num as CAR_NUM,\n"
		+ "d.rent_way as RENT_WAY,d.con_mon as CON_MON, decode(d.rent_start_dt,null,'',substr(d.rent_start_dt,1,4)||'-'||substr(d.rent_start_dt,5,2)||'-'||substr(d.rent_start_dt,7,2)) as RENT_START_DT, decode(d.rent_end_dt,null,'',substr(d.rent_end_dt,1,4)||'-'||substr(d.rent_end_dt,5,2)||'-'||substr(d.rent_end_dt,7,2)) as RENT_END_DT,\n"
		+ "g.car_id as CAR_ID, g.imm_amt as IMM_AMT, decode(f.reg_ext_dt,null,'',substr(f.reg_ext_dt,1,4)||'-'||substr(f.reg_ext_dt,5,2)||'-'||substr(f.reg_ext_dt,7,2)) as REG_EXT_DT, f.rpt_no as RPT_NO, h.car_name as CAR_NAME, j.car_nm as CAR_NM,\n"//
		+ "i.cpt_cd as CPT_CD, a.scan_file, b.car_doc_no, a.fine_mm, a.bus_id2\n"//,j.nm as BANK_NM
		+ "from cont a, car_reg b, client c, fee d, users e, car_pur f, car_etc g, allot i, car_nm h, car_mng j\n"//--, code j
		+ "where a.rent_mng_id like '%'\n"
		+ "and a.rent_l_cd like upper('%" + rent_l_cd + "%')\n"// and nvl(a.use_yn,'Y')='Y'
		+ "and a.car_mng_id = b.car_mng_id and b.car_no like '%" + car_no + "%'\n"
		+ "and a.client_id = c.client_id and (c.firm_nm like '%" + firm_nm + "%' or c.client_nm like '%%') \n"
		+ "and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+) and h.car_cd=j.code(+)\n"
//		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n";
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd and h.car_comp_id = j.car_comp_id(+)\n";
		//+ "and j.c_st = '0003'\n"
		//+ "and j.code <> '0000'\n"
		//+ "and i.cpt_cd = j.code(+)\n"
        Collection<RentListBean> col = new ArrayList<RentListBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				col.add(makeRegListBean(rs));
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }
    /**
     * 납부고지서번호 중복 체크.
     */
    public int getPaidNo( String paid_no ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		Statement stmt = null;
        ResultSet rs = null;
        int count = 0;
        String query = "";
        
        query = "select count(paid_no) from fine where paid_no='" + paid_no + "'\n";

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	count = rs.getInt(1);

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
        return count;
    }
    /**
     * 과태료, 범칙금 통화기록 조회.
     */
	public FineCallBean getFineCall( String car_mng_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        FineCallBean fcb = new FineCallBean();
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "select car_mng_id as CAR_MNG_ID,car_no CAR_NO,rent_mng_id RENT_MNG_ID,rent_l_cd RENT_L_CD, nvl(call_dt, to_char(sysdate,'YYYYMMDD')) CALL_DT,call_cont CALL_CONT,reg_nm REG_NM\n"
				+ "from fine_call where car_mng_id='" + car_mng_id + "'\n";


        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            if (rs.next())
                fcb = makeFineCallBean(rs);
            /*else
                throw new UnknownDataException("Could not find Appcode # " + car_mng_id );
            */
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
        return fcb;
    }
    /**
     * 과태료, 범칙금 조회.
     */
    public FineBean [] getForfeitAll(String yr, String st, String f_st, String gubun, String gubun_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String car_mng_id = "";
        String rent_mng_id = "";
        String coll_st = "";
        String car_no = "";
		String firm_nm = "";
		String rent_l_cd = "";
		String paid_no = "";
		String car_name = "";
		String vio_dt = "";
		String vio_pla = "";
		
		String ch = null;
    	try
    	{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
    		ch = sdf.format(d);
    	} catch(Exception dfdf) { }
	
		if(!yr.equals(""))
		{
			if(yr.equals(ch.trim()))
			{
				if(st.equals("1"))
				{
					coll_st = "and a.coll_dt is not null and substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY'))\n";
				}else if(st.equals("2")){
					coll_st = "and a.coll_dt is null\n";
				}else{
					coll_st = "and (a.coll_dt is null or substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY')))\n";
				}
			}else{
				//if(st.equals("1"))
				//{
					coll_st = "and a.coll_dt is not null and substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY'))\n";
				//}else if(st.equals("2")){
				//	coll_st = "and a.coll_dt is null\n";
				//}else if(st.equals("0")){
				//	coll_st = "";
				//}
			}
		}else{
			coll_st = "and (a.coll_dt is null or substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY')))\n";
		}

		if(gubun.equals("car_no"))
		{
			car_no = gubun_nm;
		}else if(gubun.equals("firm_nm")){
			firm_nm = gubun_nm;
		}else if(gubun.equals("rent_l_cd")){
			rent_l_cd = gubun_nm;
		}else if(gubun.equals("paid_no")){
			paid_no = gubun_nm;
		}else if(gubun.equals("car_name")){
			car_name = gubun_nm;
		}else if(gubun.equals("vio_dt")){
			vio_dt = gubun_nm;
		}else if(gubun.equals("vio_pla")){
			vio_pla = gubun_nm;
		}
        
        String query = "";
        
        query = "select b.car_no as CAR_NO,c.client_id as CLIENT_ID,d.firm_nm as FIRM_NM,d.client_nm as CLIENT_NM,e.car_id as CAR_ID,f.car_name as CAR_NAME,a.seq_no as SEQ_NO,a.car_mng_id as CAR_MNG_ID,a.rent_mng_id as RENT_MNG_ID,a.rent_l_cd as RENT_L_CD,a.fine_st as FINE_ST,a.call_nm as CALL_NM,a.tel as TEL,a.fax as FAX,decode(a.vio_dt,null,'',substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분') as VIO_DT_VIEW,a.vio_dt as VIO_DT,a.vio_pla as VIO_PLA,a.vio_cont as VIO_CONT,a.paid_st as PAID_ST,decode(a.rec_dt,null,'',substr(a.rec_dt,1,4)||'-'||substr(a.rec_dt,5,2)||'-'||substr(a.rec_dt,7,2)) as REC_DT,decode(a.paid_end_dt,null,'',substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2)) as PAID_END_DT,a.paid_amt as PAID_AMT,decode(a.proxy_dt,null,'',substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2)) as PROXY_DT,a.pol_sta as POL_STA,a.paid_no as PAID_NO,a.fault_st as FAULT_ST,decode(a.dem_dt,null,'',substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2)) as DEM_DT,decode(a.coll_dt,null,'',substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2)) as COLL_DT,decode(a.rec_plan_dt,null,'',substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2)) as REC_PLAN_DT,a.note as NOTE\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id like '%" + car_mng_id + "%' and a.rent_mng_id like '%" + rent_mng_id + "%' and a.rent_l_cd like upper('%" + rent_l_cd + "%') and a.paid_no like '%" + paid_no + "%' and a.vio_dt like '%" + vio_dt + "%' and a.vio_pla like '%" + vio_pla + "%' and a.fault_st='" + f_st + "'\n"
				+ coll_st
				+ "and a.car_mng_id=b.car_mng_id and b.car_no like '%" + car_no + "%'\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id and (d.firm_nm like '%" + firm_nm + "%' or d.client_nm like '%%')\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and nvl(f.car_name, ' ') like '%" + car_name + "%'\n";
                //+ "and a.paid_st = '3'\n";
	
        Collection col = new ArrayList<FineBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeFineBean(rs));
 
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
        return (FineBean[])col.toArray(new FineBean[0]);
    }

    /**
     * 과태료, 범칙금 조회.
     */
    public FineBean [] getForfeitAll2(String yr, String st, String f_st, String gubun, String gubun_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;

        String query = "";
        
        query = " select"+
				" b.car_no, c.client_id, d.firm_nm, d.client_nm, e.car_id, f.car_name,"+
				" a.seq_no, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, a.fine_st, a.call_nm, a.tel, a.fax,"+
				" decode(a.vio_dt, null,'', substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분') as VIO_DT_VIEW,"+
				" a.vio_dt, a.vio_pla, a.vio_cont, a.paid_st, "+
				" decode(a.rec_dt, null,'', substr(a.rec_dt,1,4)||'-'||substr(a.rec_dt,5,2)||'-'||substr(a.rec_dt,7,2)) as REC_DT,"+
				" decode(a.paid_end_dt, null,'', substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2)) as PAID_END_DT,"+
				" a.paid_amt, "+
				" decode(a.proxy_dt, null,'', substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2)) as PROXY_DT,"+
				" a.pol_sta, a.paid_no, a.fault_st, "+
				" decode(a.dem_dt, null,'', substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2)) as DEM_DT,"+
				" decode(a.coll_dt, null,'', substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2)) as COLL_DT,"+
				" decode(a.rec_plan_dt, null,'', substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2)) as REC_PLAN_DT,"+
				" a.note\n"+
				" from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"+
				" where"+
				" a.car_mng_id=b.car_mng_id and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd"+
				" and c.client_id = d.client_id and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd"+
				" and e.car_id = f.car_id(+) and substr(a.vio_dt,1,4)=nvl('"+ yr+"', to_char(sysdate,'YYYY'))";

		if(st.equals("1")){			query += " and a.coll_dt is not null";	
		}else if(st.equals("2")){	query += " and a.coll_dt is null";	
		}

		if(f_st.equals("1")){		query += " and a.fault_st='1'";
		}else if(f_st.equals("2")){	query += " and a.fault_st='2'";
		}

		if(!gubun.equals(""))		query += " and "+gubun+" like '%"+gubun_nm+"%'";
        
	
        Collection<FineBean> col = new ArrayList<FineBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeFineBean(rs));
 
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
        return (FineBean[])col.toArray(new FineBean[0]);
    }

	/**
     * 과태료, 범칙금 개별조회(car_mng_id, rent_mng_id).
     */
    public FineBean getForfeitDetail(int seq_no, String car_mng_id, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        FineBean fb = new FineBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "select b.car_no as CAR_NO,c.client_id as CLIENT_ID,d.firm_nm as FIRM_NM,d.client_nm as CLIENT_NM,e.car_id as CAR_ID,f.car_name as CAR_NAME,a.seq_no as SEQ_NO,a.car_mng_id as CAR_MNG_ID,a.rent_mng_id as RENT_MNG_ID,a.rent_l_cd as RENT_L_CD,a.fine_st as FINE_ST,a.call_nm as CALL_NM,a.tel as TEL,a.fax as FAX,decode(a.vio_dt,null,'',substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시 '||substr(a.vio_dt,11,2)||'분') as VIO_DT_VIEW,a.vio_dt as VIO_DT,a.vio_pla as VIO_PLA,a.vio_cont as VIO_CONT,a.paid_st as PAID_ST,decode(a.rec_dt,null,'',substr(a.rec_dt,1,4)||'-'||substr(a.rec_dt,5,2)||'-'||substr(a.rec_dt,7,2)) as REC_DT,decode(a.paid_end_dt,null,'',substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2)) as PAID_END_DT,a.paid_amt as PAID_AMT,decode(a.proxy_dt,null,'',substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2)) as PROXY_DT,a.pol_sta as POL_STA,a.paid_no as PAID_NO,a.fault_st as FAULT_ST,decode(a.dem_dt,null,'',substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2)) as DEM_DT,decode(a.coll_dt,null,'',substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2)) as COLL_DT,decode(a.rec_plan_dt,null,'',substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2)) as REC_PLAN_DT,a.note as NOTE\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.seq_no=" + seq_no + " and a.car_mng_id='" + car_mng_id + "' and a.rent_mng_id='" + rent_mng_id + "' and a.rent_l_cd='" + rent_l_cd + "'\n"
				+ "and a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n";

        try{
            pstmt = con.prepareStatement(query);
            pstmt.setInt(1, seq_no);
            pstmt.setString(2, car_mng_id.trim());
            pstmt.setString(3, rent_mng_id.trim());
            pstmt.setString(4, rent_l_cd.trim());

            rs = pstmt.executeQuery(query);

            if (rs.next())
            {
                fb = makeFineBean(rs);
            }
            //else
               // throw new UnknownDataException("Could not find Appcode # " + rent_l_cd );
            
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return fb;
    }
    /**
     * 과태료, 범칙금 세부조회(car_mng_id, rent_mng_id).
     */
    public FineBean [] getForfeitDetailAll(String car_mng_id, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "select b.car_no as CAR_NO,c.client_id as CLIENT_ID,d.firm_nm as FIRM_NM,d.client_nm as CLIENT_NM,e.car_id as CAR_ID,f.car_name as CAR_NAME,a.seq_no as SEQ_NO,a.car_mng_id as CAR_MNG_ID,a.rent_mng_id as RENT_MNG_ID,a.rent_l_cd as RENT_L_CD,a.fine_st as FINE_ST,a.call_nm as CALL_NM,a.tel as TEL,a.fax as FAX,decode(a.vio_dt,null,'',substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분') as VIO_DT_VIEW,a.vio_dt as VIO_DT,a.vio_pla as VIO_PLA,a.vio_cont as VIO_CONT,a.paid_st as PAID_ST,decode(a.rec_dt,null,'',substr(a.rec_dt,1,4)||'-'||substr(a.rec_dt,5,2)||'-'||substr(a.rec_dt,7,2)) as REC_DT,decode(a.paid_end_dt,null,'',substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2)) as PAID_END_DT,a.paid_amt as PAID_AMT,decode(a.proxy_dt,null,'',substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2)) as PROXY_DT,a.pol_sta as POL_STA,a.paid_no as PAID_NO,a.fault_st as FAULT_ST,decode(a.dem_dt,null,'',substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2)) as DEM_DT,decode(a.coll_dt,null,'',substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2)) as COLL_DT,decode(a.rec_plan_dt,null,'',substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2)) as REC_PLAN_DT,a.note as NOTE\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id='" + car_mng_id + "' and a.rent_mng_id='" + rent_mng_id + "'\n"
				+ "and a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n";

        Collection<FineBean> col = new ArrayList<FineBean>();
        
        try{
           	stmt = con.createStatement();

            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeFineBean(rs));
 
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
        return (FineBean[])col.toArray(new FineBean[0]);
    }
    /**
     * 과태료, 범칙금 세부조회(rent_mng_id, rent_l_cd).
     */
    public FineBean [] getForfeitDetailAll(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "select b.car_no as CAR_NO,c.client_id as CLIENT_ID,d.firm_nm as FIRM_NM,d.client_nm as CLIENT_NM,e.car_id as CAR_ID,f.car_name as CAR_NAME,a.seq_no as SEQ_NO,a.car_mng_id as CAR_MNG_ID,a.rent_mng_id as RENT_MNG_ID,a.rent_l_cd as RENT_L_CD,a.fine_st as FINE_ST,a.call_nm as CALL_NM,a.tel as TEL,a.fax as FAX,decode(a.vio_dt,null,'',substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분') as VIO_DT_VIEW,a.vio_dt as VIO_DT,a.vio_pla as VIO_PLA,a.vio_cont as VIO_CONT,a.paid_st as PAID_ST,decode(a.rec_dt,null,'',substr(a.rec_dt,1,4)||'-'||substr(a.rec_dt,5,2)||'-'||substr(a.rec_dt,7,2)) as REC_DT,decode(a.paid_end_dt,null,'',substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2)) as PAID_END_DT,a.paid_amt as PAID_AMT,decode(a.proxy_dt,null,'',substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2)) as PROXY_DT,a.pol_sta as POL_STA,a.paid_no as PAID_NO,a.fault_st as FAULT_ST,decode(a.dem_dt,null,'',substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2)) as DEM_DT,decode(a.coll_dt,null,'',substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2)) as COLL_DT,decode(a.rec_plan_dt,null,'',substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2)) as REC_PLAN_DT,a.note as NOTE\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id like '%' and a.rent_mng_id='" + rent_mng_id + "' and a.rent_l_cd='" + rent_l_cd + "'\n"
				+ "and a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n";
	
        Collection<FineBean> col = new ArrayList<FineBean>();
        
        try{
           	stmt = con.createStatement();

            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeFineBean(rs));
 
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
        return (FineBean[])col.toArray(new FineBean[0]);
    }
    /**
     * 과태료, 범칙금 전체통계.
     */
    public String [] getForfeitState(String yr) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String [] val = new String[6];
        
        query = "select a.not_cnt as NOT_CNT,a.not_amt as NOT_AMT,b.is_cnt IS_CNT,b.is_amt as IS_AMT,a.not_cnt+b.is_cnt as TOT_CNT,a.not_amt+b.is_amt as TOT_AMT\n" 
				+ "from (select decode(nvl(?,to_char(sysdate,'YYYY')),to_char(sysdate,'YYYY'),count(paid_amt),0) as not_cnt, decode(nvl(?,to_char(sysdate,'YYYY')),to_char(sysdate,'YYYY'),nvl(sum(paid_amt),0),0) as not_amt from fine where coll_dt is null and paid_st in ('1','3') and fault_st='1') a,\n"
				+ "(select count(paid_amt) as is_cnt, nvl(sum(paid_amt),0) as is_amt from fine where coll_dt is not null and paid_st='3' and fault_st='1' and substr(coll_dt,1,4)=nvl(?,to_char(sysdate,'YYYY'))) b\n";
        try{
           	pstmt = con.prepareStatement(query);
           	pstmt.setString(1, yr);
           	pstmt.setString(2, yr);
           	pstmt.setString(3, yr);  
            rs = pstmt.executeQuery();
            if(rs.next()){
                val [0] = rs.getString(1);
                val [1] = rs.getString(2);
                val [2] = rs.getString(3);
                val [3] = rs.getString(4);
                val [4] = rs.getString(5);
                val [5] = rs.getString(6);
            }
            
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return val;
    }
    /**
     * 과태료, 범칙금 조건통계
     */
    public String [] getForfeitConSta(String yr,String st, String f_st, String gubun, String gubun_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String car_mng_id = "";
        String rent_mng_id = "";
        String coll_st = "";
        String car_no = "";
		String firm_nm = "";
		String rent_l_cd = "";
		String paid_no = "";
		String car_name = "";
		String vio_dt = "";
		String vio_pla = "";
		String ch = null;
		String val [] = new String[18];
    	try
    	{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
    		ch = sdf.format(d);
    	} catch(Exception dfdf) { }
	
		if(!yr.equals(""))
		{
			if(yr.equals(ch.trim()))
			{
				if(st.equals("1"))
				{
					coll_st = "and a.coll_dt is not null and substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY'))\n";
				}else if(st.equals("2")){
					coll_st = "and a.coll_dt is null\n";
				}else{
					coll_st = "and (a.coll_dt is null or substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY')))\n";
				}
			}else{
				//if(st.equals("1"))
				//{
					coll_st = "and a.coll_dt is not null and substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY'))\n";
				//}else if(st.equals("2")){
				//	coll_st = "and a.coll_dt is null\n";
				//}else if(st.equals("0")){
				//	coll_st = "";
				//}
			}
			
		}else{
			coll_st = "and (a.coll_dt is null or substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY')))\n";
		}

		if(gubun.equals("car_no"))
		{
			car_no = gubun_nm;
		}else if(gubun.equals("firm_nm")){
			firm_nm = gubun_nm;
		}else if(gubun.equals("rent_l_cd")){
			rent_l_cd = gubun_nm;
		}else if(gubun.equals("paid_no")){
			paid_no = gubun_nm;
		}else if(gubun.equals("car_name")){
			car_name = gubun_nm;
		}else if(gubun.equals("vio_dt")){
			vio_dt = gubun_nm;
		}else if(gubun.equals("vio_pla")){
			vio_pla = gubun_nm;
		}
        
        String query = "";
        query = "select decode('"+f_st+"','2','0',o.not_cnt) as NOT_CNT1,decode('"+f_st+"','2','0',o.not_amt) as NOT_AMT1,p.is_cnt as IS_CNT1,decode('"+f_st+"','2','0',p.is_amt) as IS_AMT1,decode('"+f_st+"','2','0',o.not_cnt+p.is_cnt) as TOT_CNT1,decode('"+f_st+"','2','0',o.not_amt+p.is_amt) as TOT_AMT1,decode('"+f_st+"','2','0',q.not_cnt) as NOT_CNT2,decode('"+f_st+"','2','0',q.not_amt) as NOT_AMT2,decode('"+f_st+"','2','0',r.is_cnt) as IS_CNT2,decode('"+f_st+"','2','0',r.is_amt) as IS_AMT2,decode('"+f_st+"','2','0',q.not_cnt+r.is_cnt) as TOT_CNT2,decode('"+f_st+"','2','0',q.not_amt+r.is_amt) as TOT_AMT2,decode('"+f_st+"','2','0',s.not_cnt) as NOT_CNT3,decode('"+f_st+"','2','0',s.not_amt) as NOT_AMT3,decode('"+f_st+"','2','0',t.is_cnt) as IS_CNT3,decode('"+f_st+"','2','0',t.is_amt) as IS_AMT3,decode('"+f_st+"','2','0',s.not_cnt+t.is_cnt) as TOT_CNT3,decode('"+f_st+"','2',0,s.not_amt+t.is_amt) as TOT_AMT3\n" 
				+ "from (select decode(nvl('"+yr+"',to_char(sysdate,'YYYY')),to_char(sysdate,'YYYY'), decode('"+st+"','1',0,count(a.seq_no)),0) as not_cnt, decode(nvl('"+yr+"',to_char(sysdate,'YYYY')),to_char(sysdate,'YYYY'),decode('"+st+"','1',0,nvl(sum(a.paid_amt),0)),0) as not_amt\n"
						+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
						+ "where a.car_mng_id like '%" + car_mng_id + "%' and a.rent_mng_id like '%" + rent_mng_id + "%' and a.rent_l_cd like upper('%" + rent_l_cd + "%') and a.paid_no like '%" + paid_no + "%' and a.vio_dt like '%" + vio_dt + "%' and a.vio_pla like '%" + vio_pla + "%' and a.fault_st='" + f_st + "'\n"
						+ "and fine_st='1' and a.coll_dt is null and a.paid_st in ('1','3')\n"
						+ "and a.car_mng_id=b.car_mng_id and b.car_no like '%" + car_no + "%'\n"
						+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
						+ "and c.client_id = d.client_id and d.firm_nm like '%" + firm_nm + "%'\n"
						+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
						+ "and e.car_id = f.car_id(+) and nvl(f.car_name, ' ') like '%" + car_name + "%') o,\n"
						+ "(select decode('"+st+"','2',0,count(a.seq_no)) as is_cnt, decode('"+st+"','2',0,nvl(sum(a.paid_amt),0)) as is_amt\n"
						+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
						+ "where a.car_mng_id like '%" + car_mng_id + "%' and a.rent_mng_id like '%" + rent_mng_id + "%' and a.rent_l_cd like upper('%" + rent_l_cd + "%') and a.paid_no like '%" + paid_no + "%' and a.vio_dt like '%" + vio_dt + "%' and a.vio_pla like '%" + vio_pla + "%' and a.fault_st='" + f_st + "'\n"
						+ "and a.fine_st='1' and a.coll_dt is not null and substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY')) and a.paid_st ='3'\n"
						+ "and a.car_mng_id=b.car_mng_id and b.car_no like '%" + car_no + "%'\n"
						+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
						+ "and c.client_id = d.client_id and d.firm_nm like '%" + firm_nm + "%'\n"
						+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
						+ "and e.car_id = f.car_id(+) and nvl(f.car_name, ' ') like '%" + car_name + "%') p,\n"
						+ "(select decode(nvl('"+yr+"',to_char(sysdate,'YYYY')),to_char(sysdate,'YYYY'), decode('"+st+"','1',0,count(a.seq_no)),0) as not_cnt, decode(nvl('"+yr+"',to_char(sysdate,'YYYY')),to_char(sysdate,'YYYY'),decode('"+st+"','1',0,nvl(sum(a.paid_amt),0)),0) as not_amt\n"
						+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
						+ "where a.car_mng_id like '%" + car_mng_id + "%' and a.rent_mng_id like '%" + rent_mng_id + "%' and a.rent_l_cd like upper('%" + rent_l_cd + "%') and a.paid_no like '%" + paid_no + "%' and a.vio_dt like '%" + vio_dt + "%' and a.vio_pla like '%" + vio_pla + "%' and a.fault_st='" + f_st + "'\n"
						+ "and fine_st='2' and a.coll_dt is null and a.paid_st in ('1','3')\n"
						+ "and a.car_mng_id=b.car_mng_id and b.car_no like '%" + car_no + "%'\n"
						+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
						+ "and c.client_id = d.client_id and d.firm_nm like '%" + firm_nm + "%'\n"
						+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
						+ "and e.car_id = f.car_id(+) and nvl(f.car_name, ' ') like '%" + car_name + "%') q,\n"
						+ "(select decode('"+st+"','2',0,count(a.seq_no)) as is_cnt, decode('"+st+"','2',0,nvl(sum(a.paid_amt),0)) as is_amt\n"
						+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
						+ "where a.car_mng_id like '%" + car_mng_id + "%' and a.rent_mng_id like '%" + rent_mng_id + "%' and a.rent_l_cd like upper('%" + rent_l_cd + "%') and a.paid_no like '%" + paid_no + "%' and a.vio_dt like '%" + vio_dt + "%' and a.vio_pla like '%" + vio_pla + "%' and a.fault_st='" + f_st + "'\n"
						+ "and a.fine_st='2' and a.coll_dt is not null and substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY')) and a.paid_st ='3'\n"
						+ "and a.car_mng_id=b.car_mng_id and b.car_no like '%" + car_no + "%'\n"
						+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
						+ "and c.client_id = d.client_id and d.firm_nm like '%" + firm_nm + "%'\n"
						+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
						+ "and e.car_id = f.car_id(+) and nvl(f.car_name, ' ') like '%" + car_name + "%') r,\n"
						+ "(select decode(nvl('"+yr+"',to_char(sysdate,'YYYY')),to_char(sysdate,'YYYY'), decode('"+st+"','1',0,count(a.seq_no)),0) as not_cnt, decode(nvl('"+yr+"',to_char(sysdate,'YYYY')),to_char(sysdate,'YYYY'),decode('"+st+"','1',0,nvl(sum(a.paid_amt),0)),0) as not_amt\n"
						+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
						+ "where a.car_mng_id like '%" + car_mng_id + "%' and a.rent_mng_id like '%" + rent_mng_id + "%' and a.rent_l_cd like upper('%" + rent_l_cd + "%') and a.paid_no like '%" + paid_no + "%' and a.vio_dt like '%" + vio_dt + "%' and a.vio_pla like '%" + vio_pla + "%' and a.fault_st='" + f_st + "'\n"
						+ "and a.coll_dt is null and a.paid_st in ('1','3')\n"
						+ "and a.car_mng_id=b.car_mng_id and b.car_no like '%" + car_no + "%'\n"
						+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
						+ "and c.client_id = d.client_id and d.firm_nm like '%" + firm_nm + "%'\n"
						+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
						+ "and e.car_id = f.car_id(+) and nvl(f.car_name, ' ') like '%" + car_name + "%') s,\n"
						+ "(select decode('"+st+"','2',0,count(a.seq_no)) as is_cnt, decode('"+st+"','2',0,nvl(sum(a.paid_amt),0)) as is_amt\n"
						+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
						+ "where a.car_mng_id like '%" + car_mng_id + "%' and a.rent_mng_id like '%" + rent_mng_id + "%' and a.rent_l_cd like upper('%" + rent_l_cd + "%') and a.paid_no like '%" + paid_no + "%' and a.vio_dt like '%" + vio_dt + "%' and a.vio_pla like '%" + vio_pla + "%' and a.fault_st='" + f_st + "'\n"
						+ "and a.coll_dt is not null and substr(a.coll_dt,1,4)=nvl('" + yr +"',to_char(sysdate,'YYYY')) and a.paid_st ='3'\n"
						+ "and a.car_mng_id=b.car_mng_id and b.car_no like '%" + car_no + "%'\n"
						+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
						+ "and c.client_id = d.client_id and d.firm_nm like '%" + firm_nm + "%'\n"
						+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
						+ "and e.car_id = f.car_id(+) and nvl(f.car_name, ' ') like '%" + car_name + "%') t\n";


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
     * 과태료 범칙금 등록
     */
    public int insertForfeit(FineBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String seqQuery = "";
        String car_mng_id = "";
        String rent_mng_id = "";
        String rent_l_cd = "";
        int seq_no = 0;
        int count = 0;
        car_mng_id = bean.getCar_mng_id().trim();
        rent_mng_id = bean.getRent_mng_id().trim();
        rent_l_cd = bean.getRent_l_cd().trim();
                
        seqQuery = "select nvl(max(SEQ_NO)+1,1) from fine where car_mng_id='" + car_mng_id +"' and rent_mng_id='" + rent_mng_id +"' and rent_l_cd='" + rent_l_cd +"'\n";
        query="INSERT INTO FINE(SEQ_NO,CAR_MNG_ID,RENT_MNG_ID,RENT_L_CD,FINE_ST,CALL_NM,TEL,FAX,VIO_DT,VIO_PLA,VIO_CONT,PAID_ST,REC_DT,PAID_END_DT,PAID_AMT,PROXY_DT,POL_STA,PAID_NO,FAULT_ST,DEM_DT,COLL_DT,REC_PLAN_DT,NOTE)\n"
            + "values(?,?,?,?,?,?,?,?,replace(?,'-',''),?,?,?,replace(?,'-',''),replace(?,'-',''),replace(?,',',''),replace(?,'-',''),?,?,?,replace(?,'-',''),replace(?,'-',''),replace(?,'-',''),?)\n";
            
       try{
            con.setAutoCommit(false);

            stmt = con.createStatement();
            rs = stmt.executeQuery(seqQuery);
            if(rs.next())
            	seq_no = rs.getInt(1);
            rs.close();
			stmt.close();


            pstmt = con.prepareStatement(query);

            pstmt.setInt(1, seq_no);
            pstmt.setString(2, car_mng_id);
            pstmt.setString(3, rent_mng_id);
            pstmt.setString(4, rent_l_cd);
            pstmt.setString(5, bean.getFine_st().trim());
            pstmt.setString(6, bean.getCall_nm().trim());
            pstmt.setString(7, bean.getTel().trim());
            pstmt.setString(8, bean.getFax().trim());
            pstmt.setString(9, bean.getVio_dt().trim());
            pstmt.setString(10, bean.getVio_pla().trim());
            pstmt.setString(11, bean.getVio_cont().trim());
            pstmt.setString(12, bean.getPaid_st().trim());
            pstmt.setString(13, bean.getRec_dt().trim());
            pstmt.setString(14, bean.getPaid_end_dt().trim());
            pstmt.setInt(15, bean.getPaid_amt());
            pstmt.setString(16, bean.getProxy_dt().trim());
            pstmt.setString(17, bean.getPol_sta().trim());
            pstmt.setString(18, bean.getPaid_no().trim());
            pstmt.setString(19, bean.getFault_st().trim());
            pstmt.setString(20, bean.getDem_dt().trim());
            pstmt.setString(21, bean.getColl_dt().trim());
            pstmt.setString(22, bean.getRec_plan_dt().trim());
            pstmt.setString(23, bean.getNote().trim());
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[ForfeitDatabase:insertForfeit]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return seq_no;
    }
    
    /**
     * 과태료,범칙금 수정.
     */
    public int updateForfeit(FineBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        String rent_mng_id = "";
        String rent_l_cd = "";
        int seq_no = 0;
        int count = 0;
        seq_no = bean.getSeq_no();
        car_mng_id = bean.getCar_mng_id().trim();
        rent_mng_id = bean.getRent_mng_id().trim();
        rent_l_cd = bean.getRent_l_cd().trim();
 		
 		                
        query="update fine set FINE_ST=?,CALL_NM=?,TEL=?,FAX=?,VIO_DT=replace(?,'-',''),VIO_PLA=?,VIO_CONT=?,PAID_ST=?,REC_DT=replace(?,'-',''),PAID_END_DT=replace(?,'-',''),PAID_AMT=replace(?,',',''),PROXY_DT=replace(?,'-',''),POL_STA=?,PAID_NO=?,FAULT_ST=?,DEM_DT=replace(?,'-',''),COLL_DT=replace(?,'-',''),REC_PLAN_DT=replace(?,'-',''),NOTE=?\n"
				+ "where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";
         
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, bean.getFine_st().trim());
            pstmt.setString(2, bean.getCall_nm().trim());
            pstmt.setString(3, bean.getTel().trim());
            pstmt.setString(4, bean.getFax().trim());
            pstmt.setString(5, bean.getVio_dt().trim());
            pstmt.setString(6, bean.getVio_pla().trim());
            pstmt.setString(7, bean.getVio_cont().trim());
            pstmt.setString(8, bean.getPaid_st().trim());
            pstmt.setString(9, bean.getRec_dt().trim());
            pstmt.setString(10, bean.getPaid_end_dt().trim());
            pstmt.setInt(11, bean.getPaid_amt());
            pstmt.setString(12, bean.getProxy_dt().trim());
            pstmt.setString(13, bean.getPol_sta().trim());
            pstmt.setString(14, bean.getPaid_no().trim());
            pstmt.setString(15, bean.getFault_st().trim());
            pstmt.setString(16, bean.getDem_dt().trim());
            pstmt.setString(17, bean.getColl_dt().trim());
            pstmt.setString(18, bean.getRec_plan_dt().trim());
            pstmt.setString(19, bean.getNote().trim());
            pstmt.setInt(20, seq_no);
            pstmt.setString(21, car_mng_id);
            pstmt.setString(22, rent_mng_id);
            pstmt.setString(23, rent_l_cd);
            
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
    
    public int deleteForfeit(FineBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        String rent_mng_id = "";
        String rent_l_cd = "";
        int seq_no = 0;
        int count = 0;
        seq_no = bean.getSeq_no();
        car_mng_id = bean.getCar_mng_id().trim();
        rent_mng_id = bean.getRent_mng_id().trim();
        rent_l_cd = bean.getRent_l_cd().trim();
 		
 		                
        query = " delete from fine where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";
         
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);
            
            pstmt.setInt(1, seq_no);
            pstmt.setString(2, car_mng_id);
            pstmt.setString(3, rent_mng_id);
            pstmt.setString(4, rent_l_cd);
            
            pstmt.executeUpdate();

			pstmt.close();
            con.commit();

        }catch(Exception se){
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
		count=2;
        return count;
    }
    
    /**
     * 과태료,범칙금 통화기록.
     */
    public int updateFineCall(FineCallBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
        
                
        query="update fine_call set CAR_NO=?,RENT_MNG_ID=?,RENT_L_CD=?,CALL_DT=?,CALL_CONT=?,REG_NM=?\n"
				+ "where car_mng_id=?";
            
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, bean.getCar_no().trim());
            pstmt.setString(2, bean.getRent_mng_id().trim());
            pstmt.setString(3, bean.getRent_l_cd().trim());
            pstmt.setString(4, bean.getCall_dt().trim());
            pstmt.setString(5, bean.getCall_cont().trim());
            pstmt.setString(6, bean.getReg_nm().trim());
            pstmt.setString(7, bean.getCar_mng_id().trim());
                        
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
    
    public void insertFine(Map<String, Object> param) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null) throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
//        ResultSet rs = null;
        
        String gubun = (String) param.get("gubun");
        String car_no  = (String) param.get("car_no");
        String gov_nm  = (String) param.get("gov_nm");
        String paid_no = (String) param.get("paid_no");
        String vio_pla = (String) param.get("vio_pla");
        String vio_cont  = (String) param.get("vio_cont");
        int paid_amt = (int) param.get("paid_amt");
        String obj_end_dt  = (String) param.get("obj_end_dt");
        String paid_end_dt = (String) param.get("paid_end_dt");
        String vio_dt = (String) param.get("vio_dt");
        String file_name = (String) param.get("file_name");
        String save_folder = (String) param.get("save_folder");
        
        
        String query = "";
        
        query = "insert into fine_temp (seq, gubun, car_no, gov_nm, paid_no, vio_dt, vio_pla, vio_cont, paid_amt, obj_end_dt, paid_end_dt, file_name, save_folder, reg_dt)\r\n" + 
        		" values(FINE_SEQ.NEXTVAL,'"+gubun+"', '"+car_no+"', '"+gov_nm+"', '"+paid_no+"', '"+vio_dt+"', '"+vio_pla+"', '"+vio_cont+"', '"+paid_amt+"', '"+obj_end_dt+"', '"+paid_end_dt+"', '"+file_name+"', '"+save_folder+"',SYSDATE )";
        
        try{
            con.setAutoCommit(false);
            stmt = con.createStatement();
            pstmt = con.prepareStatement(query);
            
            pstmt.executeUpdate();
            pstmt.close();
            con.commit();
            System.out.println(query);
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
    }
    
    public void insertFine3(Map<String, Object> param) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null) throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	PreparedStatement pstmt = null;
    	Statement stmt = null;
    	ResultSet rs = null;
//        ResultSet rs = null;
    	
    	String gubun = (String) param.get("gubun");
    	String car_no  = (String) param.get("car_no");
    	String gov_nm  = (String) param.get("gov_nm");
    	String paid_no = (String) param.get("paid_no");
    	String vio_pla = (String) param.get("vio_pla");
    	String vio_cont  = (String) param.get("vio_cont");
    	int paid_amt = (int) param.get("paid_amt");
    	String obj_end_dt  = (String) param.get("obj_end_dt");
    	String paid_end_dt = (String) param.get("paid_end_dt");
    	String vio_dt = (String) param.get("vio_dt");
    	String file_name = (String) param.get("file_name");
    	String save_folder = (String) param.get("save_folder");
    	
    	
    	String query = "";
    	
    	query = "insert into fine_temp3 (seq, gubun, car_no, gov_nm, paid_no, vio_dt, vio_pla, vio_cont, paid_amt, obj_end_dt, paid_end_dt, file_name, save_folder, reg_dt)\r\n" + 
    			" values(FINE_SEQ.NEXTVAL,'"+gubun+"', '"+car_no+"', '"+gov_nm+"', '"+paid_no+"', '"+vio_dt+"', '"+vio_pla+"', '"+vio_cont+"', '"+paid_amt+"', '"+obj_end_dt+"', '"+paid_end_dt+"', '"+file_name+"', '"+save_folder+"',SYSDATE )";
    	
    	try{
    		con.setAutoCommit(false);
    		stmt = con.createStatement();
    		pstmt = con.prepareStatement(query);
    		
    		pstmt.executeUpdate();
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
    }
    
    public Vector getFineOcrList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
						
		String query = "";

		query = "SELECT SEQ, CAR_NO, GOV_NM, PAID_NO\r\n" + 
				"         , VIO_DT, VIO_PLA, VIO_CONT, PAID_AMT, OBJ_END_DT\r\n" + 
				"         , PAID_END_DT, FILE_NAME, FILE_SIZE, FILE_TYPE, SAVE_FILE\r\n" + 
				"         , SAVE_FOLDER, REG_DT, REG_YN\r\n" + 
				"         , (CASE WHEN GUBUN = '1' THEN '주정차 위반'\r\n" + 
				"                 WHEN GUBUN = '2' THEN '버스 전용 차로 위반'\r\n" + 
				"                 WHEN GUBUN = '3' THEN '장애인 주차 구역 위반' ELSE '' END) AS GUBUN\r\n" + 
				"      FROM FINE_TEMP\r\n" + 
				"      WHERE REG_YN = 'N'";
		
		String dt1 = "to_char(reg_dt,'YYYYMM')";
		String dt2 = "to_char(reg_dt,'YYYYMMDD')";
		
		if(gubun1.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
		else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('%"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		else if(gubun1.equals("4"))		query += " and "+dt1+" = to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')";
		
		if(t_wd == null || t_wd.isEmpty()) {
			
		} else {
			if(s_kd.equals("4")) query += " and car_no = '"+t_wd+"'";
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
			System.out.println(query);
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
    
    public Vector getFineOcrDelList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String del_yn) throws DatabaseException, DataSourceEmptyException
    {
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	Statement stmt = null;
    	ResultSet rs = null;
    	Vector vt = new Vector();
    	
    	String query = "";
    	
    	query = "SELECT SEQ, CAR_NO, GOV_NM, PAID_NO\r\n" + 
    			"         , VIO_DT, VIO_PLA, VIO_CONT, PAID_AMT, OBJ_END_DT\r\n" + 
    			"         , PAID_END_DT, FILE_NAME, FILE_SIZE, FILE_TYPE, SAVE_FILE\r\n" + 
    			"         , SAVE_FOLDER, REG_DT, REG_YN\r\n" + 
    			"         , (CASE WHEN GUBUN = '1' THEN '주정차 위반'\r\n" + 
    			"                 WHEN GUBUN = '2' THEN '버스 전용 차로 위반'\r\n" + 
    			"                 WHEN GUBUN = '3' THEN '장애인 주차 구역 위반' ELSE '' END) AS GUBUN\r\n" + 
    			"      FROM FINE_TEMP\r\n" + 
    			"      WHERE REG_YN = 'Y' AND DEL_YN = 'Y' AND DEL_YN2 = '"+del_yn+"'";
    	
    	String dt1 = "to_char(reg_dt,'YYYYMM')";
    	String dt2 = "to_char(reg_dt,'YYYYMMDD')";
    	
    	if(gubun1.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
    	else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
    	else if(gubun1.equals("2")){
    		if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('%"+st_dt+"%', '-','')";
    		if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
    	}
    	else if(gubun1.equals("4"))		query += " and "+dt1+" = to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')";
    	
    	if(t_wd == null || t_wd.isEmpty()) {
    		
    	} else {
    		if(s_kd.equals("4")) query += " and car_no = '"+t_wd+"'";
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
    		System.out.println(query);
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
    
    public Vector getFineOcrStatList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String del_yn) throws DatabaseException, DataSourceEmptyException
    {
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	Statement stmt = null;
    	ResultSet rs = null;
    	Vector vt = new Vector();
    	
    	String query = "";
    	
    	query = "SELECT A.*, B.FIRM_NM, B.EMAIL\r\n" + 
    			"  FROM(\r\n" + 
    			"			SELECT A.SEQ_NO, A.CAR_MNG_ID, A.RENT_MNG_ID, A.RENT_L_CD, A.FINE_ST\r\n" + 
    			"			     , A.CALL_NM, A.TEL, A.FAX, A.VIO_PLA, A.VIO_CONT\r\n" + 
    			"			     , A.PAID_ST, A.REC_DT, A.PAID_END_DT, A.PAID_AMT, A.PROXY_DT\r\n" + 
    			"			     , A.POL_STA, A.PAID_NO, A.FAULT_ST, A.DEM_DT, A.COLL_DT\r\n" + 
    			"			     , A.REC_PLAN_DT, A.NOTE, A.NO_PAID_YN, A.NO_PAID_CAU, A.UPDATE_ID\r\n" + 
    			"			     , A.UPDATE_DT, A.REG_ID, A.REG_DT, A.DLY_DAYS, A.DLY_AMT\r\n" + 
    			"			     , A.FAULT_NM, A.EXT_DT, A.EXT_ID, A.OBJ_DT1, A.OBJ_DT2, A.OBJ_DT3\r\n" + 
    			"			     , A.BILL_DOC_YN, A.FAULT_AMT, A.BILL_MON, A.VAT_YN, A.TAX_YN\r\n" + 
    			"			     , A.F_DEM_DT, A.E_DEM_DT, A.BUSI_ST, A.RENT_S_CD, A.NOTICE_DT\r\n" + 
    			"			     , A.OBJ_END_DT, A.BILL_YN, A.MNG_ID, A.FILE_NAME, A.REG_CODE\r\n" + 
    			"			     , A.FILE_TYPE, A.INCOM_DT, A.INCOM_SEQ, A.FILE_NAME2, A.FILE_TYPE2\r\n" + 
    			"			     , A.PROXY_EST_DT, A.DMIDX, A.FINE_GB, A.PAID_AMT2, A.RENT_ST\r\n" + 
    			"			     , A.RE_REG_DT, A.RE_REG_ID, A.VIO_ST, A.EMAIL_YN , B.CAR_NO\r\n" +
    			"				 , (SELECT GOV_NM FROM FINE_GOV AA WHERE A.POL_STA = AA.GOV_ID) AS GOV_NM \r\n" +																
    			"				 , TO_CHAR(TO_DATE(A.VIO_DT, 'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS') AS VIO_DT, A.EMAIL_CMPLT_YN \r\n" +																
    			"			  FROM FINE A, CAR_REG B\r\n" + 
    			"			 WHERE A.CAR_MNG_ID = B.CAR_MNG_ID \r\n" + 
    			"			   AND A.NOTE = '과태료 OCR 등록'\r\n" + 
    			"      ) A,  (SELECT a.rent_mng_id, a.rent_l_cd, a.client_id, a.r_site, a.car_mng_id,\r\n" + 
    			"			       nvl(decode(a.r_site, '', h.firm_nm, decode(a.tax_type, '2', g.r_site, h.firm_nm ) ), '고객') firm_nm,\r\n" + 
    			"				   decode( m.mgr_email , '', decode(a.r_site, '', h.con_agnt_email, decode(a.tax_type, '2', g.agnt_email, h.con_agnt_email) ), NULL, decode(a.r_site, '', h.con_agnt_email, decode(a.tax_type, '2', g.agnt_email, h.con_agnt_email) ), m.mgr_email ) email\r\n" + 
    			"			  FROM\r\n" + 
    			"				cont a, client h, client_site g,\r\n" + 
    			"				(\r\n" + 
    			"				SELECT\r\n" + 
    			"					rent_mng_id,\r\n" + 
    			"					rent_l_cd,\r\n" + 
    			"					MIN(mgr_id) AS MGR_ID,\r\n" + 
    			"					MIN(mgr_email) KEEP (DENSE_RANK FIRST\r\n" + 
    			"				ORDER BY\r\n" + 
    			"					MGR_ID) AS MGR_EMAIL\r\n" + 
    			"				FROM\r\n" + 
    			"					car_mgr\r\n" + 
    			"				WHERE\r\n" + 
    			"					rent_mng_id = ''\r\n" + 
    			"					AND rent_l_cd = ''\r\n" + 
    			"					AND REGEXP_LIKE(mgr_email, '.+@.+')\r\n" + 
    			"				GROUP BY\r\n" + 
    			"					RENT_MNG_ID,\r\n" + 
    			"					RENT_L_CD ) m\r\n" + 
    			"			WHERE\r\n" + 
    			"				a.use_yn = 'Y'\r\n" + 
    			"				AND a.client_id = h.client_id\r\n" + 
    			"				AND a.r_site = g.seq(+)\r\n" + 
    			"				AND a.client_id = g.client_id(+)\r\n" + 
    			"				AND a.rent_mng_id = m.rent_mng_id(+)\r\n" + 
    			"				AND a.rent_l_cd = m.rent_l_cd(+)) B\r\n" + 
    			"		WHERE A.CAR_MNG_ID = B.CAR_MNG_ID(+)\r\n" + 
    			"		  AND A.RENT_MNG_ID = B.RENT_MNG_ID(+)\r\n" + 
    			"		  AND A.RENT_L_CD = B.RENT_L_CD(+)";
    	
    	String dt1 = "to_char(TO_DATE(a.reg_dt,'YYYYMMDD'),'YYYYMM')";
    	String dt2 = "to_char(TO_DATE(a.reg_dt,'YYYYMMDD'),'YYYYMMDD')";
    	
    	if(gubun1.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
    	else if(gubun1.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
    	else if(gubun1.equals("2")){
    		if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('%"+st_dt+"%', '-','')";
    		if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
    	}
    	else if(gubun1.equals("4"))		query += " and "+dt1+" = to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')";
    	if(gubun2.equals("N")) {
    		query += " and email_cmplt_yn = 'N'";
    	} else {
    		query += " and email_cmplt_yn = 'Y'";
    	}
    	if(t_wd == null || t_wd.isEmpty()) {
    		
    	} else {
    		if(s_kd.equals("4")) query += " and a.car_no = '"+t_wd+"'";
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
    		System.out.println(query);
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
    
//    public Vector getFineOcr(String paid_no, String car_no) throws DatabaseException, DataSourceEmptyException
//	{
//        Connection con = connMgr.getConnection(DATA_SOURCE);
//		if(con == null)
//            throw new DataSourceEmptyException("Can't get Connection !!");
//
//		Statement stmt = null;
//		ResultSet rs = null;
//		Vector vt = new Vector();
//						
//		String query = "";
//		query = "SELECT A.*\r\n" + 
//				"	  FROM(\r\n" + 
//				"	 	  SELECT ROWNUM AS NUM, SEQ ,GUBUN, CAR_NO, GOV_NM, PAID_NO, VIO_DT, VIO_PLA, VIO_CONT, PAID_AMT, OBJ_END_DT, PAID_END_DT, FILE_NAME, FILE_SIZE, FILE_TYPE, SAVE_FILE, SAVE_FOLDER, REG_DT, REG_YN \r\n" + 
//				"			FROM FINE_TEMP \r\n" + 
//				"			WHERE PAID_NO = '"+paid_no+"' \r\n" + 
//				"			  AND CAR_NO = '"+car_no+"' \r\n" + 
//				"		  ) A WHERE NUM = 1";
//
//		try {
//			System.out.println(query);
//			
//			stmt = con.createStatement();
//	    	rs = stmt.executeQuery(query);
//    		ResultSetMetaData rsmd = rs.getMetaData();    
//    		 
//			while(rs.next())
//			{				
//				Hashtable ht = new Hashtable();
//				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
//				{
//					 String columnName = rsmd.getColumnName(pos);
//					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
//				}
//				vt.add(ht);	
//			}
//			rs.close();
//            stmt.close();
//
//		} catch (SQLException e) {
//			System.out.println(query);
//			throw new DatabaseException();
//		} finally {
//			try{
//				if(rs != null )		rs.close();
//				if(stmt != null)	stmt.close();
//			}catch(Exception ignore){}
//            connMgr.freeConnection(DATA_SOURCE, con);
//			con = null;
//		}
//		return vt;
//	}
//    
    public FineOcrBean getFineOcr(String paid_no, String car_no, String seq) throws DatabaseException, DataSourceEmptyException
    {
    	Connection con = connMgr.getConnection(DATA_SOURCE);
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		FineOcrBean fine = new FineOcrBean();
		
		String where = "WHERE SEQ ='"+seq+"'";
		
		if(car_no == null || car_no.isEmpty()) {
		} else {
			where += "AND CAR_NO = '"+car_no+"'";
		}
		
		if(paid_no == null || paid_no.isEmpty()) {
		} else {
			where += "AND REPLACE(REPLACE(REPLACE(PAID_NO, CHR(13), ''), CHR(10), ''),' ','') = REPLACE(REPLACE(REPLACE('"+paid_no+"', CHR(13), ''), CHR(10), ''),' ','')";
		}
		
		String query = "";
		query = "SELECT A.*\r\n" + 
				"		  FROM(\r\n" + 
				"		 		SELECT A.*\r\n" + 
				"					 ,(CASE WHEN OBJ_END_DT_LENGTH = 6  AND IS_DATE('20'||OBJ_END_DT_TEMP,'YYYYMMDD') = 1 THEN TO_CHAR(TO_DATE('20'||OBJ_END_DT_TEMP,'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 7  AND IS_DATE('2'||OBJ_END_DT_TEMP,'YYYYMMDD') = 1 THEN TO_CHAR(TO_DATE('2'||OBJ_END_DT_TEMP,'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 8  AND IS_DATE(OBJ_END_DT_TEMP,'YYYYMMDD') = 1 THEN TO_CHAR(TO_DATE(OBJ_END_DT_TEMP,'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 9  AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 10 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 11 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 12 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 13 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 14 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 15 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 16 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 17 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 18 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 20 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN OBJ_END_DT_LENGTH = 32 AND IS_DATE(SUBSTR(OBJ_END_DT_TEMP,-8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(OBJ_END_DT_TEMP,-8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					   ELSE '' END) AS OBJ_END_DT_2\r\n" + 
				"					 ,(CASE \r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 6  AND IS_DATE('20'||PAID_END_DT_TEMP,'YYYYMMDD') = 1 THEN TO_CHAR(TO_DATE('20'||PAID_END_DT_TEMP,'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 7  AND IS_DATE('2'||PAID_END_DT_TEMP,'YYYYMMDD') = 1 THEN TO_CHAR(TO_DATE('2'||PAID_END_DT_TEMP,'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 8  AND IS_DATE(PAID_END_DT_TEMP,'YYYYMMDD') = 1 THEN TO_CHAR(TO_DATE(PAID_END_DT_TEMP,'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 9  AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 10 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 11 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 12 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 13 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 14 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 15 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 16 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 17 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 18 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 19 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 24 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,-8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,-8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN PAID_END_DT_LENGTH = 32 AND IS_DATE(SUBSTR(PAID_END_DT_TEMP,-8),'YYYYMMDD') = 1 THEN  TO_CHAR(TO_DATE(SUBSTR(PAID_END_DT_TEMP,-8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					   ELSE '' END) AS PAID_END_DT_2\r\n" + 
				"					 ,(CASE WHEN VIO_DT_LENGTH = 8  AND IS_DATE(VIO_DT_TEMP,'YYYYMMDD') = 1 THEN TO_CHAR(TO_DATE(VIO_DT_TEMP,'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN VIO_DT_LENGTH = 10 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,8),'YYYYMMDDHH24MI') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					        WHEN VIO_DT_LENGTH = 11 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,8),'YYYYMMDDHH24MI') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,8),'YYYYMMDD'),'YYYY-MM-DD')\r\n" + 
				"					 		WHEN VIO_DT_LENGTH = 12 AND IS_DATE(VIO_DT_TEMP,'YYYYMMDDHH24MI') = 1 THEN TO_CHAR(TO_DATE(VIO_DT_TEMP,'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')\r\n" + 
				"					        WHEN VIO_DT_LENGTH = 13 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,12),'YYYY-MM-DD HH24:MI') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,12),'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI')\r\n" + 
				"					        WHEN VIO_DT_LENGTH = 14 AND IS_DATE(VIO_DT_TEMP,'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(VIO_DT_TEMP,'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
				"					        WHEN VIO_DT_LENGTH >= 15 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"		/*			        WHEN VIO_DT_LENGTH = 16 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 17 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 18 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 19 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 20 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 21 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 22 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 23 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 24 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 25 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 26 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 27 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 28 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')\r\n" + 
//				"					        WHEN VIO_DT_LENGTH = 30 AND IS_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS') = 1 THEN TO_CHAR(TO_DATE(SUBSTR(VIO_DT_TEMP,1,14),'YYYYMMDDHH24MISS'),'YYYY-MM-DD HH24:MI:SS')*/\r\n" + 
				"					   ELSE '' END) AS VIO_DT_2\r\n" + 
				"				  FROM(\r\n" + 
				"				 		SELECT SEQ, CAR_NO, GOV_NM, PAID_NO\r\n" + 
				"						         , VIO_DT, VIO_PLA, VIO_CONT, PAID_AMT, OBJ_END_DT, PAID_END_DT\r\n" + 
				"						         , FILE_NAME, FILE_SIZE, FILE_TYPE, SAVE_FILE\r\n" + 
				"						         , SAVE_FOLDER, REG_DT, REG_YN, GUBUN AS GUBUN_TYPE \r\n" + 
				"						         , (CASE WHEN GUBUN = '1' THEN '주정차 위반'\r\n" + 
				"						                 WHEN GUBUN = '2' THEN '버스 전용 차로 위반'\r\n" + 
				"						                 WHEN GUBUN = '3' THEN '장애인 주차 구역 위반' ELSE '' END) AS GUBUN\r\n" + 
				"						    	 , REGEXP_REPLACE(VIO_DT, '[^0-9]') AS VIO_DT_TEMP\r\n" + 
				"						    	 , REGEXP_REPLACE(OBJ_END_DT, '[^0-9]') AS OBJ_END_DT_TEMP\r\n" + 
				"						    	 , REGEXP_REPLACE(PAID_END_DT, '[^0-9]') AS PAID_END_DT_TEMP\r\n" + 
				"						    	 , LENGTH(REGEXP_REPLACE(VIO_DT, '[^0-9]')) AS VIO_DT_LENGTH\r\n" + 
				"						    	 , LENGTH(REGEXP_REPLACE(OBJ_END_DT, '[^0-9]')) AS OBJ_END_DT_LENGTH\r\n" + 
				"						    	 , LENGTH(REGEXP_REPLACE(PAID_END_DT, '[^0-9]')) AS PAID_END_DT_LENGTH\r\n" + 
				"						    	 , TRIM(PAID_NO)\r\n" + 
				"						   FROM FINE_TEMP\r\n" + 
										   where +
				"					  ) A WHERE 1=1\r\n" + 
				"			  ) A WHERE 1=1";
		
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
	
		while(rs.next())
		{
			fine.setSeq		(rs.getString("SEQ")==null? 0:Integer.parseInt(rs.getString("SEQ")));
			fine.setGubun	(rs.getString("GUBUN")==null?"":rs.getString("GUBUN"));
			fine.setCar_no	(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
			fine.setGov_nm	(rs.getString("GOV_NM")==null?"":rs.getString("GOV_NM"));
			fine.setPaid_no	(rs.getString("PAID_NO")==null?"":rs.getString("PAID_NO"));
			fine.setVio_dt	(rs.getString("VIO_DT")==null?"":rs.getString("VIO_DT"));
			fine.setVio_dt_2	(rs.getString("VIO_DT_2")==null?"":rs.getString("VIO_DT_2"));
			fine.setVio_pla	(rs.getString("VIO_PLA")==null?"":rs.getString("VIO_PLA"));
			fine.setVio_cont(rs.getString("VIO_CONT")==null?"":rs.getString("VIO_CONT"));
			fine.setPaid_amt	(rs.getString("PAID_AMT")==null? 0:Integer.parseInt(rs.getString("PAID_AMT")));
			fine.setObj_end_dt	(rs.getString("OBJ_END_DT")==null?"":rs.getString("OBJ_END_DT"));
			fine.setPaid_end_dt	(rs.getString("PAID_END_DT")==null?"":rs.getString("PAID_END_DT"));
			fine.setObj_end_dt_2	(rs.getString("OBJ_END_DT_2")==null?"":rs.getString("OBJ_END_DT_2"));
			fine.setPaid_end_dt_2	(rs.getString("PAID_END_DT_2")==null?"":rs.getString("PAID_END_DT_2"));
			fine.setGubun_type	(rs.getString("GUBUN_TYPE")==null?"":rs.getString("GUBUN_TYPE"));
			
		}
		rs.close();
		stmt.close();
		
	} catch (SQLException e) {
		System.out.println("[AddClientDatabase:getClient]\n"+e);
  		e.printStackTrace();
  		fine = null;
	} finally {
				try{
					if(rs != null )		rs.close();
					if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
		    connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return fine;
    }

}
