/**
 * 지출
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.stat_inc;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.common.*;
import acar.account.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class StatIncDatabase {

    private static StatIncDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized StatIncDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new StatIncDatabase();
        return instance;
    }
    
    private StatIncDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    /**
     * 특정 레코드를 Bean에 저장하여 Bean을 리턴하는 메소드
     */
	
	/**
     * 수금
     */
    private StatIncScdBean makeStatIncScdBean(ResultSet results) throws DatabaseException {

        try {
            StatIncScdBean bean = new StatIncScdBean();

		    bean.setSt(results.getString("ST"));
		    bean.setGubun(results.getString("GUBUN"));
		    bean.setPay_st(results.getString("PAY_ST"));
		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
		    bean.setClient_id(results.getString("CLIENT_ID"));
		    bean.setFirm_nm(results.getString("FIRM_NM"));
		    bean.setClient_nm(results.getString("CLIENT_NM"));
		    bean.setCar_no(results.getString("CAR_NO"));
		    bean.setCar_nm(results.getString("CAR_NM"));
		    bean.setBrch_id(results.getString("BRCH_ID"));
			bean.setTm(results.getString("TM"));
		    bean.setS_amt(results.getInt("S_AMT"));
		    bean.setV_amt(results.getInt("V_AMT"));
		    bean.setAmt(results.getInt("AMT"));
		    bean.setPay_amt(results.getInt("AMT"));
		    bean.setI_est_dt(results.getString("I_EST_DT"));
		    bean.setEst_dt(results.getString("EST_DT"));
			bean.setPay_dt(results.getString("PAY_DT"));
			bean.setSeq_no(results.getString("SEQ_NO"));
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
     * 지출 ( 2002/01/16 ) - Kim JungTae
     */
    private StatIncBean makeStatIncBean(ResultSet results) throws DatabaseException {

        try {
            StatIncBean bean = new StatIncBean();

		    bean.setName(results.getString("NAME"));
		    bean.setTm(results.getString("TM"));
		    bean.setTm_nm(results.getString("TM_NM"));
		    bean.setGubun(results.getString("GUBUN"));
		    bean.setD_gubun(results.getString("D_GUBUN"));
		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));
		    bean.setClient_nm(results.getString("CLIENT_NM"));
		    bean.setFirm_nm(results.getString("FIRM_NM"));
		    bean.setCar_name(results.getString("CAR_NAME"));
		    bean.setCar_no(results.getString("CAR_NO"));
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));
		    bean.setT_amt(results.getString("T_AMT"));
		    bean.setS_amt(results.getString("S_AMT"));
		    bean.setV_amt(results.getString("V_AMT"));
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

	// 수금스케줄  리스트 조회
	public Vector getStatIncList(String br_id, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select * from stat_inc_view where bill_yn = 'Y' ";

		//당일
		if(gubun2.equals("2")){			query += " and nvl(est_dt, pay_dt) = to_char(SYSDATE, 'YYYY-MM-DD')";		}
		//기간
		else{							query += " and nvl(est_dt, pay_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	}

		//대여료
		if(gubun1.equals("1")){			query += " and st='1'";		}
		//선수금
		else if(gubun1.equals("2")){	query += " and st='2'";		}
		//과태료
		else if(gubun1.equals("3")){	query += " and st='3'";		}
		//면책금
		else if(gubun1.equals("4")){	query += " and st='4'";		}
		//휴/대차료
		else if(gubun1.equals("5")){	query += " and st='5'";		}
		//중도해지금
		else if(gubun1.equals("6")){	query += " and st='6'";		}
		//전체
		else{
		}

		//로그인 영업소별
		if(!br_id.equals("S1") && !br_id.equals(""))			query += " and brch_id='"+br_id+"'";
	
		//수금
		if(gubun3.equals("1")){			query += " and pay_st='수금'";		}
		//미수금
		else if(gubun3.equals("2")){	query += " and pay_st='미수금'";	}
		//전체
		else{ }

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
			System.out.println("[StatIncDatabase:getStatIncList]\n"+e);
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

	
	// 수금스케줄 리스트 통계 조회
	public Vector getStatIncListStat(String br_id, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String sub_query = " select * from stat_inc_view ";

		//당일
		if(gubun2.equals("2")){			sub_query += " where nvl(est_dt, pay_dt) = to_char(SYSDATE, 'YYYY-MM-DD')";		}
		//기간
		else{							sub_query += " where nvl(est_dt, pay_dt) BETWEEN '"+st_dt+"' AND '"+end_dt+"'";	}

		//대여료
		if(gubun1.equals("1")){			sub_query += " and st='1'";		}
		//선수금
		else if(gubun1.equals("2")){	sub_query += " and st='2'";		}
		//과태료
		else if(gubun1.equals("3")){	sub_query += " and st='3'";		}
		//면책금
		else if(gubun1.equals("4")){	sub_query += " and st='4'";		}
		//휴/대차료
		else if(gubun1.equals("5")){	sub_query += " and st='5'";		}
		//중도해지금
		else if(gubun1.equals("6")){	sub_query += " and st='6'";		}
		//전체
		else{
		}

		//로그인 영업소별
		if(!br_id.equals("S1") && !br_id.equals(""))			sub_query += " and brch_id='"+br_id+"'";
	
		//수금
		if(gubun3.equals("1")){			sub_query += " and pay_st='수금'";		}
		//미수금
		else if(gubun3.equals("2")){	sub_query += " and pay_st='미수금'";	}
		//전체
		else{ }

		String query = "";
		query = " select '계획' gubun, a.*, b.*, c.*, d.*, e.*, f.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where st='2' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where st='1' ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where st='3' ) c,\n"+
					" ( select count(*) tot_su4, nvl(sum(amt),0) tot_amt4 from ("+sub_query+") where st='4' ) d,\n"+
					" ( select count(*) tot_su5, nvl(sum(amt),0) tot_amt5 from ("+sub_query+") where st='5' ) e,\n"+	
					" ( select count(*) tot_su6, nvl(sum(amt),0) tot_amt6 from ("+sub_query+") where st='6' ) f\n"+
				" union all\n"+								
				" select '수금' gubun, a.*, b.*, c.*, d.*, e.*, f.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where st='2' and pay_st='수금' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where st='1' and pay_st='수금' ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where st='3' and pay_st='수금' ) c,\n"+
					" ( select count(*) tot_su4, nvl(sum(amt),0) tot_amt4 from ("+sub_query+") where st='4' and pay_st='수금' ) d,\n"+
					" ( select count(*) tot_su5, nvl(sum(amt),0) tot_amt5 from ("+sub_query+") where st='5' and pay_st='수금' ) e,\n"+	
					" ( select count(*) tot_su6, nvl(sum(amt),0) tot_amt6 from ("+sub_query+") where st='6' and pay_st='수금' ) f\n"+
				" union all\n"+				
				" select '미수금' gubun, a.*, b.*, c.*, d.*, e.*, f.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(amt),0) tot_amt1 from ("+sub_query+") where st='2' and pay_st='미수금' ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(amt),0) tot_amt2 from ("+sub_query+") where st='1' and pay_st='미수금' ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(amt),0) tot_amt3 from ("+sub_query+") where st='3' and pay_st='미수금' ) c,\n"+
					" ( select count(*) tot_su4, nvl(sum(amt),0) tot_amt4 from ("+sub_query+") where st='4' and pay_st='미수금' ) d,\n"+
					" ( select count(*) tot_su5, nvl(sum(amt),0) tot_amt5 from ("+sub_query+") where st='5' and pay_st='미수금' ) e,\n"+	
					" ( select count(*) tot_su6, nvl(sum(amt),0) tot_amt6 from ("+sub_query+") where st='6' and pay_st='미수금' ) f";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{
				IncomingBean inc = new IncomingBean();
				inc.setGubun(rs.getString(1));
				inc.setTot_su1(rs.getInt(2));
				inc.setTot_amt1(rs.getInt(3));
				inc.setTot_su2(rs.getInt(4));
				inc.setTot_amt2(rs.getInt(5));
				inc.setTot_su3(rs.getInt(6));
				inc.setTot_amt3(rs.getInt(7));
				inc.setTot_su4(rs.getInt(8));
				inc.setTot_amt4(rs.getInt(9));
				inc.setTot_su5(rs.getInt(10));
				inc.setTot_amt5(rs.getInt(11));
				inc.setTot_su6(rs.getInt(12));
				inc.setTot_amt6(rs.getInt(13));
				vt.add(inc);
			}
			rs.close();
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[StatIncDatabase:getStatIncListStat]\n"+e);
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

	/**
     * 수금처리 내용 : inc_pop.jsp
     */
    public StatIncScdBean  getStatIncCase(String gubun, String rent_mng_id, String rent_l_cd, String car_mng_id, String seq_no, String rent_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        StatIncScdBean sisb = new StatIncScdBean();
		PreparedStatement pstmt = null;
        ResultSet rs = null;
                
        String query = " select * from stat_inc_view where gubun=? and rent_mng_id=? and rent_l_cd=? and car_mng_id=? and seq_no=? and rent_st=? ";
                   
        try{
			pstmt = con.prepareStatement(query);
    		pstmt.setString(1, gubun);
    		pstmt.setString(2, rent_mng_id);
    		pstmt.setString(3, rent_l_cd);
    		pstmt.setString(4, car_mng_id);
    		pstmt.setString(5, seq_no);
    		pstmt.setString(6, rent_st);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
               sisb = makeStatIncScdBean(rs);
			}
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sisb;
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
		+ "and a.rent_l_cd = upper('" + rent_l_cd + "') and nvl(a.use_yn,'Y')='Y'\n"
		+ "and b.car_mng_id='" + car_mng_id + "' and a.car_mng_id = b.car_mng_id(+)\n"
		+ "and a.client_id = c.client_id\n"
		+ "and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd\n"
		+ "and a.bus_id = e.user_id\n"
		+ "and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd\n"
		+ "and g.car_id = h.car_id(+)\n"
		+ "and a.rent_mng_id = i.rent_mng_id and a.rent_l_cd = i.rent_l_cd\n";

        Collection col = new ArrayList();
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
	public StatIncBean getExpProc(String name, String gubun, String d_gubun, String rent_mng_id, String rent_l_cd, String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        StatIncBean seb = new StatIncBean();
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
				+ "f.car_name,b.car_no,a.car_mng_id,a.paid_amt as amt,a.rec_plan_dt as plan_dt,a.coll_dt as coll_dt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id='" + car_mng_id + "' and a.car_mng_id=b.car_mng_id \n"
				+ "and a.rent_mng_id='" + rent_mng_id + "' and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd='" + rent_l_cd + "' and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id \n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)) x\n";
			}else if(name.equals("보험료")){
				query = "select x.name as Name, x.gubun||' 회' as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
				+ "from (\n"
				+ "select '보험료' as name, a.ins_tm, a.ins_st,\n"
				+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
				+ "f.car_name,b.car_no,a.car_mng_id, a.pay_amt, a.ins_est_dt, a.pay_dt \n"
				+ "from scd_ins a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id='" + car_mng_id + "' and a.ins_tm='" + gubun + "' and a.ins_st='" + d_gubun + "' and a.car_mng_id=b.car_mng_id \n"
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id \n"
				+ "and c.rent_mng_id='" + rent_mng_id + ", and c.rent_l_cd='" + rent_l_cd + "' and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)) x\n";
			}else if(name.equals("취득세")){
				query = "select x.name as Name, x.gubun||' 회' as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
				+ "from (\n"
				+ "select '취득세' as name, '구분' as gubun, '세부구분' as d_gubun,\n"
				+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
				+ "f.car_name,a.car_no,a.car_mng_id,a.acq_acq,a.acq_f_dt,a.acq_ex_dt \n"
				+ "from car_reg a, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id='" + car_mng_id + "' and a.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id \n"
				+ "and c.rent_mng_id='" + rent_mng_id + "' and c.rent_l_cd='" + rent_l_cd + "' and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)) x\n";
			}else if(name.equals("할부금")){
				query = "select x.name as Name, x.gubun||' 회' as GUBUN,x.d_gubun D_GUBUN,x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD,x.client_nm CLIENT_NM,x.firm_nm FIRM_NM,x.car_name CAR_NAME,x.car_no CAR_NO,x.car_mng_id CAR_MNG_ID,x.amt AMT,substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2) PLAN_DT,decode(x.coll_dt,null,'미지출',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT\n"
				+ "from (\n"
				+ "select '할부금' as name, a.alt_tm as gubun, '구분' as d_gubun,\n"
				+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
				+ "f.car_name,b.car_no,a.car_mng_id,a.alt_int,a.alt_est_dt,pay_dt \n"
				+ "from scd_alt_case a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where  a.car_mng_id='" + car_mng_id + "' and a.alt_tm='" + gubun + "' and a.car_mng_id=b.car_mng_id\n"
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and c.rent_mng_id='" + rent_mng_id + "' and c.rent_l_cd='" + rent_l_cd + "' and c.rent_mng_id = e.rent_mng_id and c.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)) x\n";
			}
				
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
                seb = makeStatIncBean(rs);
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
     *  수금 전체조회.
     */
	public StatIncBean [] getIncAll(String gubun, String gubun_nm,String st, String dt, String ref_dt1, String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;

        String query = "";
		String all="";
		if(gubun.equals("")) all = "union all\n";

		query = "select replace(x.name,' ','') as Name, replace(x.tm,' ','') as TM, replace(x.tm_nm,' ','') as TM_NM, "
				+ "replace(x.gubun,' ','') as GUBUN, replace(x.d_gubun,' ','') D_GUBUN, x.rent_mng_id RENT_MNG_ID,x.rent_l_cd RENT_L_CD, "
				+ "x.client_nm CLIENT_NM, x.firm_nm FIRM_NM, x.car_name CAR_NAME, x.car_no CAR_NO, x.car_mng_id CAR_MNG_ID, "
				+ "x.s_amt as S_AMT, x.v_amt as V_AMT, x.t_amt T_AMT, "
				+ "decode(x.plan_dt, '','', substr(x.plan_dt,1,4)||'-'||substr(x.plan_dt,5,2)||'-'||substr(x.plan_dt,7,2)) PLAN_DT, "
				+ "decode(x.coll_dt,null,'미수금',substr(x.coll_dt,1,4)||'-'||substr(x.coll_dt,5,2)||'-'||substr(x.coll_dt,7,2)) COLL_DT, "
				+ "substr(x.ref_dt,1,4)||'-'||substr(x.ref_dt,5,2)||'-'||substr(x.ref_dt,7,2) REF_DT\n"
				+ "from (\n";

		if(gubun.equals("") || gubun.equals("fine")){
			query+= "select decode(a.fine_st,'1','과태료','2','범칙금') as name,to_char(a.seq_no) as tm, '' as tm_nm, '' as gubun, '세부구분' as d_gubun,\n"
					+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
					+ "f.car_name,b.car_no,a.car_mng_id,'' as s_amt,'' as v_amt,a.paid_amt as t_amt,a.rec_plan_dt as plan_dt,a.coll_dt as coll_dt, a.coll_dt as ref_dt\n"
					+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
					+ "where a.car_mng_id=b.car_mng_id \n"
					+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
					+ "and c.client_id = d.client_id \n"
					+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
					+ "and e.car_id = f.car_id(+)\n"
					+ all;
		}

		if(gubun.equals("") || gubun.equals("fee")){
			query += "select '대여료' as name,a.fee_tm as tm,decode(a.tm_st1,'0',a.fee_tm||' 회',a.fee_tm||' 회 잔액') as tm_nm, a.rent_st as gubun, a.tm_st1 as d_gubun,\n"
					+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
					+ "f.car_name,b.car_no,b.car_mng_id,to_char(a.fee_s_amt) as s_amt,to_char(fee_v_amt) as v_amt,a.rc_amt as t_amt,\n"
					+ "a.fee_est_dt as plan_dt,a.rc_dt as coll_dt, a.fee_est_dt as ref_dt\n"
					+ "from scd_fee a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
					+ "where a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and b.car_mng_id=c.car_mng_id\n"
					+ "and c.client_id = d.client_id\n"
					+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
					+ "and e.car_id = f.car_id(+)\n"
					+ all;
		}

		if(gubun.equals("") || gubun.equals("pre")){
			query += "select decode(a.pp_st,'0','보증금','1','선납금','2','개시대여료') as name,a.pp_tm as tm,a.pp_tm||' 회' as tm_nm, a.rent_st as gubun, '' as d_gubun,\n"
					+ "c.rent_mng_id, c.rent_l_cd, d.client_nm, d.firm_nm,\n"
					+ "f.car_name,b.car_no,b.car_mng_id,to_char(a.pp_s_amt) as s_amt,to_char(pp_v_amt) as v_amt,a.pp_pay_amt as t_amt,\n"
					+ "a.pp_est_dt as plan_dt,a.pp_pay_dt as coll_dt, a.pp_pay_dt as ref_dt\n"
					+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
					+ "where a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
					+ "and c.client_id = d.client_id\n"
					+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
					+ "and e.car_id = f.car_id(+)\n";
		}

		query+= ") x";
       
        if(dt.equals("2"))		query += " where x.ref_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";        	
	    else					query += " where x.ref_dt = to_char(sysdate,'YYYYMMDD') ";

		if(st.equals("1"))     	query += " and x.coll_dt is not null ";
        else if(st.equals("2"))	query += " and x.coll_dt is null ";

		query+= "order by x.name, x.firm_nm, to_number(x.tm),x.plan_dt\n";

        Collection<StatIncBean> col = new ArrayList<StatIncBean>();
        try{

            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next())
            {
               col.add(makeStatIncBean(rs));
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
        return (StatIncBean[])col.toArray(new StatIncBean[0]);
    }
    /**
     * 수금 통계
     */
    /* 
    public String [] getIncConSta(String gubun, String gubun_nm,String st, String dt, String ref_dt1, String ref_dt2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String val [] = new String[36];
		String stPre = "";
		String stFee = "";
		String stFine = "";
		
        String dtPre = "";
        String dtFee = "";
        String dtFine = "";
        String query = "";
        
        if(st.equals("1"))
        {
        	stPre = " and a.pp_pay_dt is not null ";
        	stFee = " and a.rc_dt is not null ";
        	stFine = " and a.coll_dt is not null ";
        }else if(st.equals("2"))
        {
        	stPre = " and a.pp_pay_dt is null ";
        	stFee = " and a.rc_dt is null ";
        	stFine = " and a.coll_dt is null ";
        }else{
        	stPre = "";
        	stFee = "";
        	stFine = "";
        } 
        
        if(dt.equals("2"))
        {
	       	dtPre = " and a.pp_pay_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
	       	dtFee = " and a.fee_est_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
	       	dtFine = " and a.coll_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','') ";
        }else{
        	dtPre = " and a.pp_pay_dt = to_char(sysdate,'YYYYMMDD') ";
        	dtFee = " and a.fee_est_dt = to_char(sysdate,'YYYYMMDD') ";
        	dtFine = " and a.coll_dt = to_char(sysdate,'YYYYMMDD') ";
        }
    	
        if(gubun.equals(""))
        {
        query = "select pre0.is_cnt,pre0.is_amt,pre0.not_cnt,pre0.not_amt,pre0.t_cnt,pre0.t_amt,pre1.is_cnt,pre1.is_amt,pre1.not_cnt,pre1.not_amt,pre1.t_cnt,pre1.t_amt,pre2.is_cnt,pre2.is_amt,pre2.not_cnt,pre2.not_amt,pre2.t_cnt,pre2.t_amt,fee.is_cnt,fee.is_amt,fee.not_cnt,fee.not_amt,fee.t_cnt,fee.t_amt,fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,pre0.is_cnt+pre1.is_cnt+pre2.is_cnt+fee.is_cnt+fine.is_cnt,pre0.is_amt+pre1.is_amt+pre2.is_amt+fee.is_amt+fine.is_amt,pre0.not_cnt+pre1.not_cnt+pre2.not_cnt+fee.not_cnt+fine.not_cnt,pre0.not_amt+pre1.not_amt+pre2.not_amt+fee.not_amt+fine.not_amt,pre0.t_cnt+pre1.t_cnt+pre2.t_cnt+fee.t_cnt+fine.t_cnt,pre0.t_amt+pre1.t_amt+pre2.t_amt+fee.t_amt+fine.t_amt\n"
				+ "from\n"
				+ "--보증금\n"
				+ "(select \n"
				+ "nvl(sum(nvl2(a.pp_pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0) as is_amt,nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as not_amt,nvl(sum(nvl2(a.pp_pay_dt,1,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as t_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='0' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre0,\n"
				+ "--선납금\n"
				+ "(select \n"
				+ "nvl(sum(nvl2(a.pp_pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0) as is_amt,nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as not_amt,nvl(sum(nvl2(a.pp_pay_dt,1,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as t_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='1' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre1,\n"
				+ "--초기대여료\n"
				+ "(select \n"
				+ "nvl(sum(nvl2(a.pp_pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0) as is_amt,nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as not_amt,nvl(sum(nvl2(a.pp_pay_dt,1,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as t_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='2' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre2,\n"
				+ "--대여료\n"
				+ "(select \n"
				+ "nvl(sum(nvl2(a.rc_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.rc_dt,a.rc_amt,0)),0) as is_amt,nvl(sum(nvl2(a.rc_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.rc_dt,0,a.fee_s_amt+a.fee_v_amt)),0) as not_amt,nvl(sum(nvl2(a.rc_dt,1,0)),0)+nvl(sum(nvl2(a.rc_dt,0,1)),0) as t_cnt,nvl(sum(nvl2(a.rc_dt,a.rc_amt,0)),0)+nvl(sum(nvl2(a.rc_dt,0,a.fee_s_amt+a.fee_v_amt)),0) as t_amt\n"
				+ "from scd_fee a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd \n"
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ stFee
				+ dtFee +" ) fee,\n"
				+ "--과태료/범칙금\n"
				+ "(select \n"
				+ "nvl(sum(nvl2(a.coll_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.coll_dt,a.paid_amt,0)),0) as is_amt,nvl(sum(nvl2(a.coll_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.coll_dt,0,a.paid_amt)),0) as not_amt,nvl(sum(nvl2(a.coll_dt,1,0)),0)+nvl(sum(nvl2(a.coll_dt,0,1)),0) as t_cnt,nvl(sum(nvl2(a.coll_dt,a.paid_amt,0)),0)+nvl(sum(nvl2(a.coll_dt,0,a.paid_amt)),0) as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ stFine
				+ dtFine +" ) fine\n";
		}else if(gubun.equals("pre")){
		query = "select pre0.is_cnt,pre0.is_amt,pre0.not_cnt,pre0.not_amt,pre0.t_cnt,pre0.t_amt,pre1.is_cnt,pre1.is_amt,pre1.not_cnt,pre1.not_amt,pre1.t_cnt,pre1.t_amt,pre2.is_cnt,pre2.is_amt,pre2.not_cnt,pre2.not_amt,pre2.t_cnt,pre2.t_amt,fee.is_cnt,fee.is_amt,fee.not_cnt,fee.not_amt,fee.t_cnt,fee.t_amt,fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,pre0.is_cnt+pre1.is_cnt+pre2.is_cnt+fee.is_cnt+fine.is_cnt,pre0.is_amt+pre1.is_amt+pre2.is_amt+fee.is_amt+fine.is_amt,pre0.not_cnt+pre1.not_cnt+pre2.not_cnt+fee.not_cnt+fine.not_cnt,pre0.not_amt+pre1.not_amt+pre2.not_amt+fee.not_amt+fine.not_amt,pre0.t_cnt+pre1.t_cnt+pre2.t_cnt+fee.t_cnt+fine.t_cnt,pre0.t_amt+pre1.t_amt+pre2.t_amt+fee.t_amt+fine.t_amt\n"
				+ "from\n"
				+ "--보증금\n"
				+ "(select \n"
				+ "nvl(sum(nvl2(a.pp_pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0) as is_amt,nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as not_amt,nvl(sum(nvl2(a.pp_pay_dt,1,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as t_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='0' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre0,\n"
				+ "--선납금\n"
				+ "(select \n"
				+ "nvl(sum(nvl2(a.pp_pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0) as is_amt,nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as not_amt,nvl(sum(nvl2(a.pp_pay_dt,1,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as t_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='1' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre1,\n"
				+ "--초기대여료\n"
				+ "(select \n"
				+ "nvl(sum(nvl2(a.pp_pay_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0) as is_amt,nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as not_amt,nvl(sum(nvl2(a.pp_pay_dt,1,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,1)),0) as t_cnt,nvl(sum(nvl2(a.pp_pay_dt,a.pp_pay_amt,0)),0)+nvl(sum(nvl2(a.pp_pay_dt,0,a.pp_pay_amt)),0) as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='2' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre2,\n"
				+ "--대여료\n"
				+ "(select \n"
				+ "nvl(min(0),0) as is_cnt,0 as is_amt,0 as not_cnt,0 as not_amt,0 as t_cnt,0 as t_amt\n"
				+ "from scd_fee a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd \n"
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ stFee
				+ dtFee +" ) fee,\n"
				+ "--과태료/범칙금\n"
				+ "(select \n"
				+ "nvl(min(0),0) as is_cnt,0 as is_amt,0 as not_cnt,0 as not_amt,0 as t_cnt,0 as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ stFine
				+ dtFine +" ) fine\n";
		}else if(gubun.equals("fee")){
		query = "select pre0.is_cnt,pre0.is_amt,pre0.not_cnt,pre0.not_amt,pre0.t_cnt,pre0.t_amt,pre1.is_cnt,pre1.is_amt,pre1.not_cnt,pre1.not_amt,pre1.t_cnt,pre1.t_amt,pre2.is_cnt,pre2.is_amt,pre2.not_cnt,pre2.not_amt,pre2.t_cnt,pre2.t_amt,fee.is_cnt,fee.is_amt,fee.not_cnt,fee.not_amt,fee.t_cnt,fee.t_amt,fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,pre0.is_cnt+pre1.is_cnt+pre2.is_cnt+fee.is_cnt+fine.is_cnt,pre0.is_amt+pre1.is_amt+pre2.is_amt+fee.is_amt+fine.is_amt,pre0.not_cnt+pre1.not_cnt+pre2.not_cnt+fee.not_cnt+fine.not_cnt,pre0.not_amt+pre1.not_amt+pre2.not_amt+fee.not_amt+fine.not_amt,pre0.t_cnt+pre1.t_cnt+pre2.t_cnt+fee.t_cnt+fine.t_cnt,pre0.t_amt+pre1.t_amt+pre2.t_amt+fee.t_amt+fine.t_amt\n"
				+ "from\n"
				+ "--보증금\n"
				+ "(select \n"
				+ "nvl(min(0),0) as is_cnt,0 as is_amt,0 as not_cnt,0 as not_amt,0 as t_cnt,0 as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='0' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre0,\n"
				+ "--선납금\n"
				+ "(select \n"
				+ "nvl(min(0),0) as is_cnt,0 as is_amt,0 as not_cnt,0 as not_amt,0 as t_cnt,0 as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='1' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre1,\n"
				+ "--초기대여료\n"
				+ "(select \n"
				+ "nvl(min(0),0) as is_cnt,0 as is_amt,0 as not_cnt,0 as not_amt,0 as t_cnt,0 as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='2' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre2,\n"
				+ "--대여료\n"
				+ "(select \n"
				+ "nvl(sum(nvl2(a.rc_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.rc_dt,a.rc_amt,0)),0) as is_amt,nvl(sum(nvl2(a.rc_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.rc_dt,0,a.fee_s_amt+a.fee_v_amt)),0) as not_amt,nvl(sum(nvl2(a.rc_dt,1,0)),0)+nvl(sum(nvl2(a.rc_dt,0,1)),0) as t_cnt,nvl(sum(nvl2(a.rc_dt,a.rc_amt,0)),0)+nvl(sum(nvl2(a.rc_dt,0,a.fee_s_amt+a.fee_v_amt)),0) as t_amt\n"
				+ "from scd_fee a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd \n"
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ stFee
				+ dtFee +" ) fee,\n"
				+ "--과태료/범칙금\n"
				+ "(select \n"
				+ "nvl(min(0),0) as is_cnt,0 as is_amt,0 as not_cnt,0 as not_amt,0 as t_cnt,0 as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ stFine
				+ dtFine +" ) fine\n";
		}else if(gubun.equals("fine")){
		query = "select pre0.is_cnt,pre0.is_amt,pre0.not_cnt,pre0.not_amt,pre0.t_cnt,pre0.t_amt,pre1.is_cnt,pre1.is_amt,pre1.not_cnt,pre1.not_amt,pre1.t_cnt,pre1.t_amt,pre2.is_cnt,pre2.is_amt,pre2.not_cnt,pre2.not_amt,pre2.t_cnt,pre2.t_amt,fee.is_cnt,fee.is_amt,fee.not_cnt,fee.not_amt,fee.t_cnt,fee.t_amt,fine.is_cnt,fine.is_amt,fine.not_cnt,fine.not_amt,fine.t_cnt,fine.t_amt,pre0.is_cnt+pre1.is_cnt+pre2.is_cnt+fee.is_cnt+fine.is_cnt,pre0.is_amt+pre1.is_amt+pre2.is_amt+fee.is_amt+fine.is_amt,pre0.not_cnt+pre1.not_cnt+pre2.not_cnt+fee.not_cnt+fine.not_cnt,pre0.not_amt+pre1.not_amt+pre2.not_amt+fee.not_amt+fine.not_amt,pre0.t_cnt+pre1.t_cnt+pre2.t_cnt+fee.t_cnt+fine.t_cnt,pre0.t_amt+pre1.t_amt+pre2.t_amt+fee.t_amt+fine.t_amt\n"
				+ "from\n"
				+ "--보증금\n"
				+ "(select \n"
				+ "nvl(min(0),0) as is_cnt,0 as is_amt,0 as not_cnt,0 as not_amt,0 as t_cnt,0 as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='0' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre0,\n"
				+ "--선납금\n"
				+ "(select \n"
				+ "nvl(min(0),0) as is_cnt,0 as is_amt,0 as not_cnt,0 as not_amt,0 as t_cnt,0 as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='1' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre1,\n"
				+ "--초기대여료\n"
				+ "(select \n"
				+ "nvl(min(0),0) as is_cnt,0 as is_amt,0 as not_cnt,0 as not_amt,0 as t_cnt,0 as t_amt\n"
				+ "from scd_pre a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.pp_st='2' and a.pp_pay_dt is not null and a.rent_mng_id = c.rent_mng_id \n"
				+ "and a.rent_l_cd= c.rent_l_cd and b.car_mng_id(+)=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ dtPre +" ) pre2,\n"
				+ "--대여료\n"
				+ "(select \n"
				+ "nvl(min(0),0) as is_cnt,0 as is_amt,0 as not_cnt,0 as not_amt,0 as t_cnt,0 as t_amt\n"
				+ "from scd_fee a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd \n"
				+ "and b.car_mng_id=c.car_mng_id\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ stFee
				+ dtFee +" ) fee,\n"
				+ "--과태료/범칙금\n"
				+ "(select \n"
				+ "nvl(sum(nvl2(a.coll_dt,1,0)),0) as is_cnt,nvl(sum(nvl2(a.coll_dt,a.paid_amt,0)),0) as is_amt,nvl(sum(nvl2(a.coll_dt,0,1)),0) as not_cnt,nvl(sum(nvl2(a.coll_dt,0,a.paid_amt)),0) as not_amt,nvl(sum(nvl2(a.coll_dt,1,0)),0)+nvl(sum(nvl2(a.coll_dt,0,1)),0) as t_cnt,nvl(sum(nvl2(a.coll_dt,a.paid_amt,0)),0)+nvl(sum(nvl2(a.coll_dt,0,a.paid_amt)),0) as t_amt\n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f\n"
				+ "where a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+)\n"
				+ stFine
				+ dtFine +" ) fine\n";
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
                val [30] = rs.getString(31);
                val [31] = rs.getString(32);
                val [32] = rs.getString(33);
                val [33] = rs.getString(34);
                val [34] = rs.getString(35);
                val [35] = rs.getString(36);
                
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
   */ 
}
