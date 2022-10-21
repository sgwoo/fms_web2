/**
 * 견적서관리
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2002. 3. 4
 * @ last modify date : 
 */
package acar.estimate_mng;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;

public class EstiDatabase {

    private static EstiDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
    private final String DATA_SOURCE1 = "hpg"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized EstiDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new EstiDatabase();
        return instance;
    }
    
    private EstiDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }


    /**
	 *	소분류 코드 리스트()
	 */
	public Vector getSearchCode(String a_c, String m_st) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from CODE where c_st='0008'";

		if(a_c.equals("승용")){
			if(m_st.equals("일반형 승용"))			query += " and nm like '%승용%' and nm not like '%LPG%' and nm not like '%수입%'";
			else if(m_st.equals("리무진"))			query += " and nm like '%리무진%'";
			else if(m_st.equals("일반형 승용 LPG"))	query += " and nm like '%LPG%'";
			else if(m_st.equals("5인승 짚"))			query += " and nm like '%짚%'";
			else if(m_st.equals("7~8인승"))			query += " and nm like '%7%'";
			else if(m_st.equals("9~10인승"))		query += " and nm like '%9%'";
		}else if(a_c.equals("승합")){
			query += " and nm like '%11%'";
		}else if(a_c.equals("화물")){
			query += " and nm like '%톤%'";
		}

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
			System.out.println("[EstiDatabase:getSearchCode]"+e);
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
	 *	중고차 잔가 코드 리스트 20050913. Yongsoon Kwon.
	 */
	public Vector getEstiShVarList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from esti_sh_var b "+
				" where seq = (select max(seq) from esti_sh_var a where a.sh_code=b.sh_code ) "+
				" order by 1,2 ";

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
			System.out.println("[EstiDatabase:getEstiShVarList]"+e);
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
	 *	중고차 잔가 코드 리스트 20070330
	 */
	public Vector getEstiJgVarList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from esti_jg_var b "+
				" where reg_dt = (select max(reg_dt) from esti_jg_var) "+
				" order by sh_code, seq ";



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
			System.out.println("[EstiDatabase:getEstiJgVarList]"+e);
			System.out.println("[EstiDatabase:getEstiJgVarList]"+query);
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


	//견적관리----------------------------------------------------------------------------------------------------------------


	/**
	 *	모델,옵션,색상,할인 가격 리스트() - 옵션정렬변경(2018.06.15)
	 */
	public Vector getCarSubList(String idx, String car_comp_id, String car_cd, String car_id, String car_seq, String a_a) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(idx.equals("1")){//모델
			query = " select a.car_id as id, a.car_seq as seq, a.car_name as nm, a.car_b_p as amt, a.car_b_p2, a.s_st, a.car_b, "+
					"        a.jg_code, b.jg_2, b.jg_3, a.car_b_dt as b_dt, b.jg_f, b.jg_g, nvl(b.jg_w,'0') jg_w, nvl(b.jg_h,'0') jg_h, nvl(b.jg_i,'0') jg_i, a.etc, a.car_y_form, b.jg_b, '' jg_opt_st, b.jg_g_7, a.hp_yn, a.end_dt, a.jg_tuix_st, "+
					"        a.lkas_yn, a.ldws_yn, a.aeb_yn, a.fcw_yn, a.etc2, a.duty_free_opt, round(a.car_b_p/(1+b.jg_3)) as duty_free_amt, round(a.car_b_p/(1+b.jg_3),-4) as hyundai_duty_free_amt, a.garnish_yn, a.hook_yn, b.jg_g_15 "+
					" from   car_nm a, esti_jg_var b, (select sh_code, max(seq) seq from esti_jg_var group by sh_code) c"+
					" where  nvl(a.use_yn,'Y')='Y'"+
					"        and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.car_b_dt>='20040101'"+
					"        and a.jg_code=b.sh_code and b.sh_code=c.sh_code and b.seq=c.seq";

			if(a_a.equals("1")) query += " and a.car_name not like '%LPG%'";
			if(a_a.equals("2")) query += " and a.car_name not like '%12인승%' and a.car_name not like '%11인승%'";

			query += " order by a.JG_CODE, DECODE(a.duty_free_opt, '1',1, '0',2, 3), AMT ASC, a.car_b_dt desc, a.jg_code, a.car_b_p";
		}else if(idx.equals("3_1")){ //색상에 차종 별 비고 내용 나오게 하기 20161107 조경숙
		    query =  " select a.car_id as id, a.car_seq as seq, a.car_name as nm, a.car_b_p as amt, a.s_st, a.car_b, "+
                    "        a.jg_code, b.jg_2, b.jg_3, a.car_b_dt as b_dt, b.jg_f, b.jg_g, nvl(b.jg_w,'0') jg_w, nvl(b.jg_h,'0') jg_h, nvl(b.jg_i,'0') jg_i, a.etc, a.car_y_form, b.jg_b, '' jg_opt_st, b.jg_g_7, a.hp_yn, a.jg_tuix_st, "+
                    "        a.lkas_yn, a.ldws_yn, a.aeb_yn, a.fcw_yn, a.etc2, a.duty_free_opt, a.garnish_yn, a.hook_yn "+
                    " from   car_nm a, esti_jg_var b, (select sh_code, max(seq) seq from esti_jg_var group by sh_code) c"+
                    " where  nvl(a.est_yn,'Y')='Y'"+
                    "        and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.car_b_dt>='20040101' and car_id = '"+car_id+"'"+ 
                    "        and a.jg_code=b.sh_code and b.sh_code=c.sh_code and b.seq=c.seq";
		    
		}else if(idx.equals("1_2")){//모델
			query = " select a.car_id as id, a.car_seq as seq, a.car_name as nm, a.car_b_p as amt, a.s_st, a.car_b, "+
					"        a.jg_code, b.jg_2, b.jg_3, a.car_b_dt as b_dt, b.jg_f, b.jg_g, nvl(b.jg_w,'0') jg_w, nvl(b.jg_h,'0') jg_h, nvl(b.jg_i,'0') jg_i, a.etc, a.car_y_form, b.jg_b, '' jg_opt_st, b.jg_g_7, a.hp_yn, a.jg_tuix_st, "+
					"        a.lkas_yn, a.ldws_yn, a.aeb_yn, a.fcw_yn, a.etc2, a.duty_free_opt, a.garnish_yn, a.hook_yn "+
					" from   car_nm a, esti_jg_var b, (select sh_code, max(seq) seq from esti_jg_var group by sh_code) c"+
					" where  nvl(a.est_yn,'Y')='Y'"+
					"        and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.car_b_dt>='20040101'"+
					"        and a.jg_code=b.sh_code and b.sh_code=c.sh_code and b.seq=c.seq";

			if(a_a.equals("1")) query += " and a.car_name not like '%LPG%'";
			if(a_a.equals("2")) query += " and a.car_name not like '%12인승%' and a.car_name not like '%11인승%'";

			query += " order by a.jg_code, a.car_b_p";

		}else if(idx.equals("2")){//옵션
			query = " select a.car_s_seq as id, a.car_u_seq as seq, a.car_s as nm, a.car_s_p as amt, '' s_st, '' car_b, "+
					"        '' jg_code, '' jg_2, '' jg_3, a.car_s_dt as b_dt, '' jg_f, '' jg_g, '' jg_w, '' jg_h, '' jg_i, a.opt_b as etc, '' car_y_form, '' jg_b, a.jg_opt_st, '' jg_g_7, a.jg_tuix_st, "+
					"        a.lkas_yn, a.ldws_yn, a.aeb_yn, a.fcw_yn, a.car_rank, a.jg_opt_yn, a.garnish_yn, a.hook_yn, "+
					" decode(instr(a.car_s, '필수선택'), 0, 1, 0) is_necessary, decode(instr(a.car_s, '[선택]'), 0, 1, 0) is_optional " +	// 필수선택 여부 추가. 필수면 0, 아니면 1. // [선택] 포함 여부 포함 0, 미포함 1.
					" from   car_opt a"+ 
					" where  "+ 
					"        nvl(a.use_yn,'Y')='Y' and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.car_id='"+car_id+"' and a.car_u_seq='"+car_seq+"' and a.car_s_dt>='20040101'";

			// query += " order by decode(a.jg_tuix_st,'Y',1,0), a.car_s_p";
			query += " ORDER BY is_necessary, TO_NUMBER(car_rank) ASC";
			
		}else if(idx.equals("2_1")){//옵션선택시 차종의 첨단안전사양 확인
			query = " select a.car_id as id, a.car_seq as seq, a.car_name as nm, a.car_b_p as amt, a.car_b_p2, a.s_st, a.car_b, "+
					"        a.jg_code, b.jg_2, b.jg_3, a.car_b_dt as b_dt, b.jg_f, b.jg_g, nvl(b.jg_w,'0') jg_w, nvl(b.jg_h,'0') jg_h, nvl(b.jg_i,'0') jg_i, a.etc, a.car_y_form, b.jg_b, '' jg_opt_st, b.jg_g_7, a.hp_yn, a.end_dt, a.jg_tuix_st, "+
					"        a.lkas_yn, a.ldws_yn, a.aeb_yn, a.fcw_yn, a.etc2, a.duty_free_opt, round(a.car_b_p/(1+b.jg_3)) as duty_free_amt, round(a.car_b_p/(1+b.jg_3),-4) as hyundai_duty_free_amt, a.garnish_yn, a.hook_yn "+
					" from   car_nm a, esti_jg_var b, (select sh_code, max(seq) seq from esti_jg_var group by sh_code) c"+
					" where  nvl(a.use_yn,'Y')='Y'"+
					"        and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.car_id='"+car_id+"' and a.car_seq = '"+car_seq+"' and a.car_b_dt>='20040101'"+
					"        and a.jg_code=b.sh_code and b.sh_code=c.sh_code and b.seq=c.seq";
			
			if(a_a.equals("1")) query += " and a.car_name not like '%LPG%'";
			if(a_a.equals("2")) query += " and a.car_name not like '%12인승%' and a.car_name not like '%11인승%'";

			query += " order by a.JG_CODE, DECODE(a.duty_free_opt, '1',1, '0',2, 3), AMT ASC, a.car_b_dt desc, a.jg_code, a.car_b_p";
		//}else if(idx.equals("3")){//색상
		//	query = " select a.car_c_seq as id, a.car_u_seq as seq, a.car_c as nm, a.car_c_p as amt, '' s_st, '' car_b, "+
		//			"        '' jg_code, '' jg_2, a.car_c_dt as b_dt, '' jg_f, '' jg_g, '' jg_w, '' jg_h, '' jg_i, a.etc, '' car_y_form, '' jg_b, a.jg_opt_st, '' jg_g_7 "+
		//			" from   car_col a "+ 
		//			" where  "+
		//			"        a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.car_c_dt>='20040101' and a.use_yn='Y' and nvl(a.col_st,'1')='1' ";
		//		
		//	query += " order by a.car_c_p, a.car_c ";
		}else if(idx.equals("3")){//색상(트림별 색상 선택하여 보여지는 것으로 변경, 성승현-20170215)
				query = " select a.car_c_seq as id, a.car_u_seq as seq, a.car_c as nm, a.car_c_p as amt, '' s_st, '' car_b, \n"+
						"       '' jg_code, '' jg_2, '' jg_3, a.car_c_dt as b_dt, '' jg_f, '' jg_g, '' jg_w, '' jg_h, '' jg_i, a.etc, '' car_y_form, '' jg_b, a.jg_opt_st, '' jg_g_7, t.car_u_seq, t.car_c_seq, '' jg_tuix_st, \n"+
						"       '' lkas_yn, '' ldws_yn, '' aeb_yn, '' fcw_yn, '' hook_yn \n"+
						" from   car_col_trim t, car_col a \n"+ 
						" where  t.car_comp_id=a.car_comp_id AND t.car_cd=a.car_cd AND t.CAR_U_SEQ=a.CAR_U_SEQ AND t.CAR_C_SEQ=a.CAR_C_SEQ \n"+
						"        and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' AND t.car_id='"+car_id+"' and a.car_c_dt>='20040101' and a.use_yn='Y' and nvl(a.col_st,'1')='1' ";
					
				query += " order by a.car_c_p, a.car_c ";
		}else if(idx.equals("3_in")){//내장색상
			query = " select a.car_c_seq as id, a.car_u_seq as seq, a.car_c as nm, a.car_c_p as amt, '' s_st, '' car_b, "+
					"        '' jg_code, '' jg_2, '' jg_3, a.car_c_dt as b_dt, '' jg_f, '' jg_g, '' jg_w, '' jg_h, '' jg_i, a.etc, '' car_y_form, '' jg_b, a.jg_opt_st, '' jg_g_7 "+
					" from   car_col a "+ 
					" where  "+
					"        a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.car_c_dt>='20040101' and a.use_yn='Y' and nvl(a.col_st,'1')='2' ";

			query += " order by a.car_c_p, a.car_c ";
			
		}else if(idx.equals("3_gar")){//가니쉬색상
			query = " select a.car_c_seq as id, a.car_u_seq as seq, a.car_c as nm, a.car_c_p as amt, '' s_st, '' car_b, "+
					"        '' jg_code, '' jg_2, '' jg_3, a.car_c_dt as b_dt, '' jg_f, '' jg_g, '' jg_w, '' jg_h, '' jg_i, a.etc, '' car_y_form, '' jg_b, a.jg_opt_st, '' jg_g_7 "+
					" from   car_col a "+ 
					" where  "+
					"        a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.car_c_dt>='20040101' and a.use_yn='Y' and nvl(a.col_st,'1')='3' ";
			
			query += " order by a.car_c_p, a.car_c ";

		}else if(idx.equals("4")){//dc
			query = " SELECT a.car_b_dt, a.car_d_seq, a.car_d_dt, a.car_d_p, a.car_d_per, a.car_d_p2, a.car_d_per2, a.ls_yn, a.car_d, a.car_d_per_b, a.car_d_per_b2, a.car_d_dt2, '' etc, '' car_y_form, '' jg_b, '' jg_opt_st \n"+
					" 		 , a.car_d_etc, a.esti_d_etc "+	//dc비고 추가(2018.01.23)
					" FROM   CAR_DC a, CAR_NM b "+
					" WHERE  a.car_comp_id='"+car_comp_id+"' AND a.car_cd='"+car_cd+"'  \n"+
					"        AND a.car_comp_id=b.car_comp_id AND a.car_cd=b.car_cd AND a.car_b_dt=b.car_b_dt \n"+
					"        AND b.car_id='"+car_id+"' AND b.car_seq='"+car_seq+"' \n"+
					"        and a.car_d_dt like to_char(sysdate,'YYYYMM')||'%' "+
					"        and nvl(a.car_d_dt2,to_char(sysdate,'YYYYMMDD')) >= to_char(sysdate,'YYYYMMDD') "+
					//"        AND ROWNUM = 1 "+
					" order by a.car_d_p, a.car_d_dt desc, a.car_d_seq "+
					" ";
		}else if(idx.equals("4_2")){//dc

			query = " SELECT a.car_b_dt, a.car_d_seq, a.car_d_dt, a.car_d_p, a.car_d_per, a.car_d_p2, a.car_d_per2, a.ls_yn, a.car_d, a.car_d_per_b, a.car_d_per_b2, a.car_d_dt2, '' etc, '' car_y_form, '' jg_b, '' jg_opt_st \n"+
					" 		 , a.car_d_etc, a.esti_d_etc "+	//dc비고 추가(2018.01.23)			
					" FROM   CAR_DC a, "+
					"        (select car_comp_id, car_cd, max(car_d_dt) car_d_dt, max(car_d_seq) car_d_seq from car_dc WHERE SUBSTR(car_d_dt,1,6) >=TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') group by car_comp_id, car_cd) c \n"+
					" WHERE  a.car_comp_id='"+car_comp_id+"' AND a.car_cd='"+car_cd+"'  \n"+
					"        and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_d_dt=c.car_d_dt and a.car_d_seq=c.car_d_seq "+
					" order by a.car_d_dt desc, a.car_d_seq "+
					" ";
		}else if(idx.equals("5")){ //비용
		    
		    query = " select CAR_COMP_ID, CAR_CD, CAR_K_DT, CAR_K_SEQ, ENGINE, CAR_K, CAR_K_ETC \n"+
	                " from   CAR_KM \n"+
	                " WHERE  car_comp_id = '"+car_comp_id+"' \n"+
	                "   AND  car_cd = '"+car_cd+"' AND USE_YN ='Y' \n"+
	                " ORDER BY CAR_K_SEQ";
		}
		
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
            //System.out.println("[EstiDatabase:getCarSubList]"+query);

		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getCarSubList]"+e);
			System.out.println("[EstiDatabase:getCarSubList]"+query);
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
	 *	해당 차종의 소분류 조회
	 */
	public String getA_e(String car_comp_id, String car_cd, String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String a_e = "";
		String query = "";

		query = " select s_st from car_nm where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_id='"+car_id+"' and car_seq='"+car_seq+"'";

		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){				
				a_e = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getA_e]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return a_e;
	}

	/**
	 *	공통/차종 변수 한개 조회
	 */
	public String getVar(String gubun, String var, String a_a, String a_e) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String str = "";
		String query = "";

		if(gubun.equals("comm")){
			query = " select "+var+" from esti_comm_var where a_a='"+a_a+"' and seq = (select max(seq) from esti_comm_var where a_a='"+a_a+"')";
		}else{
			query = " select "+var+" from esti_car_var where a_a='"+a_a+"' and a_e='"+a_e+"' and seq = (select max(seq) from esti_car_var where a_a='"+a_a+"' and a_e='"+a_e+"')";
		}

		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){				
				str = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();


		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getVar]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return str;
	}

	/**
	 *	공통/차종 계산결과 조회
	 */
	public String getVarData(String est_id, String var, String data1) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String str = "";
		String query = "";


		if(var.equals("o_3")){//특소세전차량가
			query = " select to_char(o_1/(1+"+data1+"/100),99999999) from estimate where est_id='"+est_id+"'";
		}else{
			query = " select o_1 from estimate where est_id='"+est_id+"'";
		}

		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){				
				str = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getVarData]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return str;
	}


	/**
	 *	계산변수 조회
	 */
	public String getEstiSikVarCase(String a_a, String seq, String var_cd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String str = "";
		String query = "";

        query = " select var_sik from esti_sik_var where a_a='"+a_a+"' and var_cd='"+var_cd+"'";


		if(seq.equals("")){
			query += " and seq = (select max(seq) from esti_sik_var where a_a='"+a_a+"' and var_cd='"+var_cd+"')";
		}else{
			query += " and seq = '"+seq+"'";
		}

		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){				
				str = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getVarData]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return str;
	}
	
	/**
	 *	해당 차종의 소분류 조회
	 */
	public String getJg_b(String car_comp_id, String car_cd, String car_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String jg_b = "";
		String query = "";
		
		query = " SELECT " +  
						" b.jg_b " +
					" FROM CAR_NM a, ESTI_JG_VAR b, (select sh_code, max(seq) seq from ESTI_JG_VAR group by sh_code) c " +
					" WHERE " +
						" nvl(a.use_yn,'Y')='Y' " +
						" and a.car_comp_id = '" + car_comp_id + "' " +
						" and a.car_cd = '" + car_cd + "' " +
						" and a.car_id = '" + car_id + "' " +
						" and a.car_b_dt>='20040101' " +
						" and a.jg_code=b.sh_code and b.sh_code=c.sh_code and b.seq=c.seq ";

		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){				
				jg_b = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getJg_b]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return jg_b;
	}


    /**
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateList(String gubun1, String gubun2, String gubun3, String gubun4, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				" decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun"+
				" from estimate a, car_mng b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e"+//
				" where a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				" and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+)"+
				" and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id and nvl(a.job,'org')='org' and nvl(a.use_yn,'Y')='Y'";


		if(gubun1.equals("1")) query += " and a.est_type='F' and nvl(a.job,'org')='org' ";
		if(gubun1.equals("2")) query += " and a.est_type='W'";
		if(gubun1.equals("3")) query += " and a.talk_tel is not null";	
		if(gubun1.equals("4")) query += " and a.est_type='M'";		
		if(gubun1.equals("5")) query += " and a.est_type='J'";		
		if(gubun1.equals("6")) query += " and a.est_type='L' and nvl(a.job,'org')='org'";		
		
		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
		
		if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
		if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5")) query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("2")) query += " and a.reg_id = '"+t_wd+"'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("4")) query += " and e.user_id = '"+t_wd+"'";
		}

		if(esti_m.equals("1")) query += " and e.user_id is not null ";
		else if(esti_m.equals("2"))	query += " and e.user_id is null ";


		if(esti_m_dt.equals("1"))		query += " and e.reg_dt like to_char(sysdate,'YYYYMM')||'%' ";
		else if(esti_m_dt.equals("2"))	query += " and e.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' ";
		else if(esti_m_dt.equals("3"))	query += " and e.reg_dt between replace('"+esti_m_s_dt+"','-','') and replace('"+esti_m_e_dt+"','-','') ";

		query += " order by a.est_id desc";


        Collection<EstimateBean> col = new ArrayList<EstimateBean>();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
			    bean.setCtr_s_amt(rs.getString("CTR_S_AMT")==null?0:Integer.parseInt(rs.getString("CTR_S_AMT")));
				bean.setCtr_v_amt(rs.getString("CTR_V_AMT")==null?0:Integer.parseInt(rs.getString("CTR_V_AMT")));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
				bean.setSet_code(rs.getString("set_code"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setPrint_type(rs.getString("print_type"));
				bean.setCompare_yn(rs.getString("compare_yn"));
				bean.setIn_col			(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn			(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));

				col.add(bean);



            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }



    /**
     * 견적관리 전체조회 - 회원별
     */
    public EstimateBean [] getEstimateList(String gubun1, String MEMBER_ID) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select a.*, b.car_nm, c.car_name from estimate a, car_mng b, car_nm c"+
				" where a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				" and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id and nvl(a.use_yn,'Y')='Y'";

		if(gubun1.equals("1")) query += " and a.est_type='F'";
		if(gubun1.equals("2")) query += " and a.est_type='W'";

		if(!MEMBER_ID.equals("")) query += " and reg_id='"+MEMBER_ID+"'";

		query += " order by a.reg_dt desc";

        Collection<EstimateBean> col = new ArrayList<EstimateBean>();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }


    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateCase(String est_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate where est_id='"+est_id+"' union " + 
        			" select * from estimate_cu where est_id='"+est_id+"'";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
	            bean.setOpt_amt_m(rs.getInt("OPT_AMT_M"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));
	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_per(rs.getFloat("CLS_PER"));
				bean.setCtr_cls_per(rs.getFloat("CTR_CLS_PER"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setReg_code(rs.getString("REG_CODE"));
				bean.setRent_mng_id		(rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd		(rs.getString("RENT_L_CD"));
				bean.setRent_st			(rs.getString("RENT_ST"));
				bean.setIns_per			(rs.getString("INS_PER"));
				bean.setDoc_type		(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setDir_pur_commi_yn		(rs.getString("DIR_PUR_COMMI_YN")==null?"":rs.getString("DIR_PUR_COMMI_YN"));
				bean.setVali_type		(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
	            bean.setOpt_chk			(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt		(rs.getInt("FEE_OPT_AMT"));
				bean.setSet_code		(rs.getString("SET_CODE"));
				bean.setGi_per			(rs.getFloat("GI_PER"));
				bean.setEst_email		(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setCaroff_emp_yn	(rs.getString("caroff_emp_yn")==null?"":rs.getString("caroff_emp_yn"));
				bean.setPrint_type		(rs.getString("print_type")==null?"":rs.getString("print_type"));
			    bean.setCtr_s_amt		(rs.getInt("CTR_S_AMT"));
				bean.setCtr_v_amt		(rs.getInt("CTR_V_AMT"));
				bean.setUse_yn			(rs.getString("USE_YN"));
				bean.setCompare_yn		(rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setB_agree_dist	(rs.getInt("B_AGREE_DIST"));
				bean.setB_o_13			(rs.getFloat("B_O_13"));
				bean.setLoc_st			(rs.getString("LOC_ST")==null?"":rs.getString("LOC_ST"));
				bean.setTint_b_yn		(rs.getString("tint_b_yn")==null?"":rs.getString("tint_b_yn"));
				bean.setTint_s_yn		(rs.getString("tint_s_yn")==null?"":rs.getString("tint_s_yn"));				
				bean.setTint_sn_yn		(rs.getString("tint_sn_yn")==null?"":rs.getString("tint_sn_yn"));				
				bean.setTint_ps_yn		(rs.getString("tint_ps_yn")==null?"":rs.getString("tint_ps_yn"));		// 고급썬팅
				bean.setTint_ps_nm		(rs.getString("tint_ps_nm")==null?"":rs.getString("tint_ps_nm"));		// 고급썬팅 내용
				bean.setTint_ps_amt		(rs.getInt("tint_ps_amt"));												// 고급썬팅 추가금액(공급가)
				bean.setTint_ps_st		(rs.getString("tint_ps_st")==null?"":rs.getString("tint_ps_st"));		// 고급썬팅 선택값				
				bean.setTint_n_yn		(rs.getString("tint_n_yn")==null?"":rs.getString("tint_n_yn"));
				bean.setTint_bn_yn		(rs.getString("tint_bn_yn")==null?"":rs.getString("tint_bn_yn"));
				bean.setNew_license_plate		(rs.getString("new_license_plate")==null?"":rs.getString("new_license_plate"));
				bean.setTint_cons_yn		(rs.getString("tint_cons_yn")==null?"":rs.getString("tint_cons_yn"));		// 추가탁송료 선택
				bean.setTint_cons_amt	(rs.getInt("tint_cons_amt"));												// 추가탁송료(금액)				
				bean.setIn_col			(rs.getString("in_col")==null?"":rs.getString("in_col"));				
				bean.setBus_yn			(rs.getString("bus_yn")==null?"":rs.getString("bus_yn"));
				bean.setBus_cau			(rs.getString("bus_cau")==null?"":rs.getString("bus_cau"));
				bean.setInsurant		(rs.getString("insurant")==null?"":rs.getString("insurant"));
				bean.setBus_cau_dt		(rs.getString("bus_cau_dt")==null?"":rs.getString("bus_cau_dt"));
				bean.setCha_st_dt		(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist			(rs.getInt("B_DIST"));
				bean.setJg_opt_st		(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st		(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setMax_use_mon		(rs.getString("MAX_USE_MON")==null?"":rs.getString("MAX_USE_MON"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag		(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setLkas_yn			(rs.getString("LKAS_YN")==null?"":rs.getString("LKAS_YN"));
				bean.setLdws_yn			(rs.getString("LDWS_YN")==null?"":rs.getString("LDWS_YN"));
				bean.setAeb_yn			(rs.getString("AEB_YN")==null?"":rs.getString("AEB_YN"));
				bean.setFcw_yn			(rs.getString("FCW_YN")==null?"":rs.getString("FCW_YN"));								
												
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setAccid_serv_amt1	(rs.getString("ACCID_SERV_AMT1")==null?0:Integer.parseInt(rs.getString("ACCID_SERV_AMT1")));
				bean.setAccid_serv_amt2	(rs.getString("ACCID_SERV_AMT2")==null?0:Integer.parseInt(rs.getString("ACCID_SERV_AMT2")));
				bean.setAccid_serv_zero	(rs.getString("ACCID_SERV_ZERO")==null?"":rs.getString("ACCID_SERV_ZERO"));
				bean.setTint_eb_yn		(rs.getString("tint_eb_yn")==null?"":rs.getString("tint_eb_yn"));
				bean.setEtc				(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setBigo			(rs.getString("bigo")==null?"":rs.getString("bigo"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				
				bean.setImport_pur_st		(rs.getString("import_pur_st")==null?"":rs.getString("import_pur_st"));
				bean.setCar_b_p2		(rs.getInt("car_b_p2"));
				bean.setR_dc_amt		(rs.getInt("r_dc_amt"));
				bean.setL_dc_amt		(rs.getInt("l_dc_amt"));
				bean.setR_card_amt		(rs.getInt("r_card_amt"));
				bean.setL_card_amt		(rs.getInt("l_card_amt"));
				bean.setR_cash_back		(rs.getInt("r_cash_back"));
				bean.setL_cash_back		(rs.getInt("l_cash_back"));
				bean.setR_bank_amt		(rs.getInt("r_bank_amt"));
				bean.setL_bank_amt		(rs.getInt("l_bank_amt"));
				
				bean.setGi_grade(rs.getString("GI_GRADE")==null?"":rs.getString("GI_GRADE"));	
				bean.setInfo_st(rs.getString("INFO_ST")==null?"":rs.getString("INFO_ST"));	
				
				bean.setGarnish_col(rs.getString("GARNISH_COL")==null?"":rs.getString("GARNISH_COL"));
				bean.setGarnish_yn(rs.getString("GARNISH_YN")==null?"":rs.getString("GARNISH_YN"));
				bean.setHook_yn(rs.getString("HOOK_YN")==null?"":rs.getString("HOOK_YN"));
				
				bean.setEst_type		(rs.getString("est_type")==null?"":rs.getString("est_type"));
				
				bean.setBr_to_st			(rs.getString("BR_TO_ST")==null?"":rs.getString("BR_TO_ST"));
				bean.setBr_to				(rs.getString("BR_TO")==null?"":rs.getString("BR_TO"));
				bean.setBr_from			(rs.getString("BR_FROM")==null?"":rs.getString("BR_FROM"));
				
				bean.setLegal_yn		(rs.getString("LEGAL_YN")==null?"":rs.getString("LEGAL_YN"));
				bean.setEsti_d_etc		(rs.getString("ESTI_D_ETC")==null?"":rs.getString("ESTI_D_ETC"));
				
				bean.setRtn_run_amt(rs.getString("rtn_run_amt")==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));
				bean.setCng_dt		(rs.getString("cng_dt")==null?"":rs.getString("cng_dt"));
				
			}
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateCase(String reg_code, String job) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate where reg_code='"+reg_code+"'";
		
		if(!job.equals("")) query += " and job='"+job+"' ";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));
	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_per(rs.getFloat("CLS_PER"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setReg_code(rs.getString("REG_CODE"));
				bean.setRent_mng_id		(rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd		(rs.getString("RENT_L_CD"));
				bean.setRent_st			(rs.getString("RENT_ST"));
				bean.setDoc_type		(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setVali_type		(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
	            bean.setOpt_chk			(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt		(rs.getInt("FEE_OPT_AMT"));
				bean.setSet_code		(rs.getString("SET_CODE"));
				bean.setGi_per			(rs.getFloat("GI_PER"));
				bean.setEst_email		(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setCaroff_emp_yn	(rs.getString("caroff_emp_yn")==null?"":rs.getString("caroff_emp_yn"));
				bean.setPrint_type		(rs.getString("print_type")==null?"":rs.getString("print_type"));
			    bean.setCtr_s_amt		(rs.getInt("CTR_S_AMT"));
				bean.setCtr_v_amt		(rs.getInt("CTR_V_AMT"));
				bean.setCompare_yn		(rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setB_agree_dist	(rs.getInt("B_AGREE_DIST"));
				bean.setB_o_13			(rs.getFloat("B_O_13"));
				bean.setLoc_st			(rs.getString("LOC_ST")==null?"":rs.getString("LOC_ST"));
				bean.setTint_b_yn		(rs.getString("tint_b_yn")==null?"":rs.getString("tint_b_yn"));
				bean.setTint_s_yn		(rs.getString("tint_s_yn")==null?"":rs.getString("tint_s_yn"));
				bean.setTint_n_yn		(rs.getString("tint_n_yn")==null?"":rs.getString("tint_n_yn"));
				bean.setTint_bn_yn		(rs.getString("tint_bn_yn")==null?"":rs.getString("tint_bn_yn"));
				bean.setNew_license_plate		(rs.getString("new_license_plate")==null?"":rs.getString("new_license_plate"));
				bean.setTint_cons_yn		(rs.getString("tint_cons_yn")==null?"":rs.getString("tint_cons_yn"));		// 추가탁송료 선택
				bean.setTint_cons_amt	(rs.getInt("tint_cons_amt"));												// 추가탁송료(금액)
				bean.setIn_col			(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setGarnish_col		(rs.getString("GARNISH_COL")==null?"":rs.getString("GARNISH_COL"));
				bean.setBus_yn			(rs.getString("bus_yn")==null?"":rs.getString("bus_yn"));
				bean.setBus_cau			(rs.getString("bus_cau")==null?"":rs.getString("bus_cau"));
				bean.setBus_cau_dt		(rs.getString("bus_cau_dt")==null?"":rs.getString("bus_cau_dt"));
				bean.setCha_st_dt		(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist			(rs.getInt("B_DIST"));
				bean.setJg_opt_st		(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st		(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setMax_use_mon		(rs.getString("MAX_USE_MON")==null?"":rs.getString("MAX_USE_MON"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag		(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setTint_eb_yn		(rs.getString("tint_eb_yn")==null?"":rs.getString("tint_eb_yn"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				
				bean.setImport_pur_st		(rs.getString("import_pur_st")==null?"":rs.getString("import_pur_st"));
				bean.setCar_b_p2		(rs.getInt("car_b_p2"));
				bean.setR_dc_amt		(rs.getInt("r_dc_amt"));
				bean.setL_dc_amt		(rs.getInt("l_dc_amt"));
				bean.setR_card_amt		(rs.getInt("r_card_amt"));
				bean.setL_card_amt		(rs.getInt("l_card_amt"));
				bean.setR_cash_back		(rs.getInt("r_cash_back"));
				bean.setL_cash_back		(rs.getInt("l_cash_back"));
				bean.setR_bank_amt		(rs.getInt("r_bank_amt"));
				bean.setL_bank_amt		(rs.getInt("l_bank_amt"));
				
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				
				bean.setRtn_run_amt(rs.getString("rtn_run_amt")==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));

            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateHpCase(String est_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate_hp where est_id='"+est_id+"' union " +
        	" select * from estimate_cu where est_id='"+est_id+"'";


        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));

		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
	            bean.setOpt_amt_m(rs.getInt("OPT_AMT_M"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));

		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));

				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));

	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));

				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));

	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setCls_per(rs.getFloat("CLS_PER"));

				bean.setReg_code(rs.getString("REG_CODE"));
				bean.setIns_per	(rs.getString("INS_PER")==null?"":rs.getString("INS_PER"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setDoc_type	(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setVali_type	(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
	            bean.setOpt_chk		(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt	(rs.getInt("FEE_OPT_AMT"));

				bean.setGi_per		(rs.getFloat("GI_PER"));
				bean.setSet_code	(rs.getString("SET_CODE"));				
				bean.setEst_email	(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setEst_type	(rs.getString("est_type")==null?"":rs.getString("est_type"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));

				bean.setB_agree_dist(rs.getInt("B_AGREE_DIST"));
				bean.setB_o_13		(rs.getFloat("B_O_13"));
				bean.setLoc_st		(rs.getString("LOC_ST")==null?"":rs.getString("LOC_ST"));
				bean.setTint_b_yn	(rs.getString("tint_b_yn")==null?"":rs.getString("tint_b_yn"));
				bean.setTint_s_yn	(rs.getString("tint_s_yn")==null?"":rs.getString("tint_s_yn"));
				bean.setTint_sn_yn	(rs.getString("tint_sn_yn")==null?"":rs.getString("tint_sn_yn"));
				bean.setTint_n_yn	(rs.getString("tint_n_yn")==null?"":rs.getString("tint_n_yn"));
				bean.setTint_bn_yn	(rs.getString("tint_bn_yn")==null?"":rs.getString("tint_bn_yn"));
				bean.setNew_license_plate		(rs.getString("new_license_plate")==null?"":rs.getString("new_license_plate"));
				bean.setTint_cons_yn		(rs.getString("tint_cons_yn")==null?"":rs.getString("tint_cons_yn"));		// 추가탁송료 선택
				bean.setTint_cons_amt	(rs.getInt("tint_cons_amt"));												// 추가탁송료(금액)
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setGarnish_col		(rs.getString("GARNISH_COL")==null?"":rs.getString("GARNISH_COL"));

				bean.setCha_st_dt	(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist		(rs.getInt("B_DIST"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st	(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setMax_use_mon	(rs.getString("MAX_USE_MON")==null?"":rs.getString("MAX_USE_MON"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setTint_eb_yn		(rs.getString("tint_eb_yn")==null?"":rs.getString("tint_eb_yn"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				bean.setEtc				(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setEsti_d_etc		(rs.getString("esti_d_etc")==null?"":rs.getString("esti_d_etc"));
				
				bean.setRtn_run_amt(rs.getString("rtn_run_amt")==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));

            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateHpCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateHpCase(String est_id, String est_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate_hp where reg_code in (select reg_code from estimate_hp where est_id='"+est_id+"') and est_nm='"+est_nm+"' ";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));
	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setCls_per(rs.getFloat("CLS_PER"));
				bean.setReg_code(rs.getString("REG_CODE"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setDoc_type	(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setVali_type	(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
	            bean.setOpt_chk		(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt	(rs.getInt("FEE_OPT_AMT"));
				bean.setSet_code	(rs.getString("SET_CODE"));
				bean.setGi_per		(rs.getFloat("GI_PER"));
				bean.setEst_email	(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setGarnish_col		(rs.getString("GARNISH_COL")==null?"":rs.getString("GARNISH_COL"));
				bean.setCha_st_dt	(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist		(rs.getInt("B_DIST"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st	(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setMax_use_mon	(rs.getString("MAX_USE_MON")==null?"":rs.getString("MAX_USE_MON"));
				bean.setEst_type	(rs.getString("est_type")==null?"":rs.getString("est_type"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				
				bean.setRtn_run_amt(rs.getString("rtn_run_amt")==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));

            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateHpCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateShCase(String est_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate_sh where est_id='"+est_id+"' UNION select * from estimate_cu where est_id='"+ est_id + "'";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));
	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_per(rs.getFloat("CLS_PER"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setDoc_type	(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setVali_type	(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
				bean.setReg_code	(rs.getString("reg_code")==null?"":rs.getString("reg_code"));
	            bean.setOpt_chk		(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt	(rs.getInt("FEE_OPT_AMT"));
				bean.setSet_code	(rs.getString("SET_CODE"));
				bean.setGi_per		(rs.getFloat("GI_PER"));
				bean.setEst_email	(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setCha_st_dt	(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist		(rs.getInt("B_DIST"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st	(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setMax_use_mon	(rs.getString("MAX_USE_MON")==null?"":rs.getString("MAX_USE_MON"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				bean.setBr_from			(rs.getString("br_from")==null?"":rs.getString("br_from"));
				bean.setBr_to				(rs.getString("br_to")==null?"":rs.getString("br_to"));
				bean.setBr_to_st			(rs.getString("br_to_st")==null?"":rs.getString("br_to_st"));
				
				bean.setRtn_run_amt(rs.getString("rtn_run_amt")==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));

			}
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateShCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateAgree(EstimateBean b_bean, String est_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate where est_nm='"+est_nm+"' and est_tel='"+b_bean.getEst_tel()+"' and reg_dt='"+b_bean.getReg_dt()+"' and rent_dt='"+b_bean.getRent_dt()+"' and est_ssn='Y'";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));
	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_per(rs.getFloat("CLS_PER"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setDoc_type	(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setVali_type	(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
	            bean.setOpt_chk		(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt	(rs.getInt("FEE_OPT_AMT"));
				bean.setSet_code	(rs.getString("SET_CODE"));
				bean.setGi_per		(rs.getFloat("GI_PER"));
				bean.setEst_email	(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setCha_st_dt	(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist		(rs.getInt("B_DIST"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st	(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setMax_use_mon	(rs.getString("MAX_USE_MON")==null?"":rs.getString("MAX_USE_MON"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				
				bean.setRtn_run_amt(rs.getString("rtn_run_amt")==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));

            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateAgree]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
     * 견적서관리번호 생성
     */
    public String getNextEst_id(String est_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		String n_est_id = "";

		query = " SELECT to_char(sysdate,'YYMM')||'"+est_st+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001') ID"+
				" FROM ESTIMATE "+
				" where est_id like to_char(sysdate,'YYMM')||'%' and est_id like '%"+est_st+"%'";
		   
       try{
            con.setAutoCommit(false);

            //est_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	n_est_id = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
            try{
			System.out.println("[EstiDatabase:getNextEst_id]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return n_est_id;
    }
    
    /**
     * esti_d_etc
    */
    public String getCar_dc_etc(String car_comp_id, String car_cd, String car_d_seq, String car_id, String car_seq, String rent_dt) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
    	ResultSet rs = null; 
    	String query = "";
    	String esti_d_etc = "";
    	
    	query = 
    			" SELECT " +
    			" 		a.esti_d_etc " +
				" FROM " +
    			" 		CAR_DC a, CAR_NM b "+
				" WHERE " +
    			" 		a.car_comp_id='"+car_comp_id+"' " +
				"		AND a.car_cd='"+car_cd+"' " +
    			"		AND a.car_d_seq='"+car_d_seq+"' " +
				" 		AND a.car_comp_id=b.car_comp_id " +
				" 		AND a.car_cd=b.car_cd " +
				" 		AND a.car_b_dt=b.car_b_dt " +
				"       AND b.car_id='"+car_id+"' AND b.car_seq='"+car_seq+"' " +
				"       AND a.car_d_dt like to_char('"+rent_dt+"', 'YYYYMM')||'%' " +
				"       AND nvl(a.car_d_dt2, to_char('"+rent_dt+"', 'YYYYMMDD')) >= to_char('"+rent_dt+"', 'YYYYMMDD') " +
				" order by a.car_d_p, a.car_d_dt desc, a.car_d_seq ";
    	
    	try{
    		con.setAutoCommit(false);
    		
    		//est_id 생성
    		stmt = con.createStatement();
    		rs = stmt.executeQuery(query);
    		if(rs.next())
    			esti_d_etc = rs.getString(1)==null?"":rs.getString(1);
    		rs.close();
    		stmt.close();
    		
    	}catch(SQLException se){
    		try{
    			System.out.println("[EstiDatabase:getNextEst_id]"+se);
    			con.rollback();
    		}catch(SQLException _ignored){}
    		throw new DatabaseException("exception");
    	}finally{
    		try{
    			con.setAutoCommit(true);
    			if(rs != null) rs.close();
    			if(stmt != null) stmt.close();
    		}catch(SQLException _ignored){}
    		connMgr.freeConnection(DATA_SOURCE, con);
    		con = null;
    	}
    	return esti_d_etc;
    }
	
	/**
     * 견적서관리번호 생성
     */
    public String getNextEst_id_Hp(String est_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		String n_est_id = "";

		query = " SELECT to_char(sysdate,'YYMM')||'"+est_st+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001') ID"+
				" FROM ESTIMATE_HP "+
				" where est_id like to_char(sysdate,'YYMM')||'%' and est_id like '%"+est_st+"%'";
		   
       try{
            con.setAutoCommit(false);

            //est_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	n_est_id = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
            try{
			System.out.println("[EstiDatabase:getNextEst_id_Hp]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return n_est_id;
    }

	/**
     * 견적서관리번호 생성
     */
    public String getNextEst_id_Sh(String est_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		String n_est_id = "";

		query = " SELECT to_char(sysdate,'YYMM')||'"+est_st+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001') ID"+
				" FROM ESTIMATE_SH "+
				" where est_id like to_char(sysdate,'YYMM')||'%' and est_id like '%"+est_st+"%'";
		   
       try{
            con.setAutoCommit(false);

            //est_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	n_est_id = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
            try{
			System.out.println("[EstiDatabase:getNextEst_id_Sh]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return n_est_id;
    }

	/**
     * 견적서관리번호 생성 및 견적등록
     */
    public void getNextEst_id_InsertEsti(String est_st, String mgr_nm, String mgr_ssn, String reg_id, String reg_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
        String query = "";
		int count = 0;
		   
        query = " INSERT INTO ESTIMATE"+
				" (est_id, mgr_nm, mgr_ssn, reg_id, reg_dt)"+
				" SELECT to_char(sysdate,'YYMM')||'"+est_st+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001'), ?, ?, ?, ?"+
				" FROM ESTIMATE "+
				" where est_id like to_char(sysdate,'YYMM')||'%' and est_id like '%"+est_st+"%'";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, mgr_nm);
            pstmt.setString(2, mgr_ssn);
            pstmt.setString(3, reg_id);
            pstmt.setString(4, reg_dt);
			count = pstmt.executeUpdate();            
            pstmt.close();

		}catch(SQLException se){
            try{
			System.out.println("[EstiDatabase:getNextEst_id_InsertEsti]"+se);
			System.out.println("[EstiDatabase:getNextEst_id_InsertEsti]"+query);
			System.out.println("[EstiDatabase:getNextEst_id_InsertEsti]"+mgr_nm);
			System.out.println("[EstiDatabase:getNextEst_id_InsertEsti]"+mgr_ssn);
			System.out.println("[EstiDatabase:getNextEst_id_InsertEsti]"+reg_id);
			System.out.println("[EstiDatabase:getNextEst_id_InsertEsti]"+reg_dt);
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

	/**
     * 견적서관리번호 생성 및 견적등록 코드가져오기
     */
    public String getSecondEst_id(String est_st, String mgr_nm, String mgr_ssn, String reg_id, String reg_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		String n_est_id = "";
		   
        query = " SELECT est_id"+
				" FROM ESTIMATE "+
				" where est_id like '%"+est_st+"%' and mgr_nm='"+mgr_nm+"' and mgr_ssn='"+mgr_ssn+"' and reg_id='"+reg_id+"' and reg_dt='"+reg_dt+"'";

       try{
            con.setAutoCommit(false);

            //est_id 생성

            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	n_est_id = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
            try{
			System.out.println("[EstiDatabase:getSecondEst_id]"+se);
			System.out.println("[EstiDatabase:getSecondEst_id]"+query);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return n_est_id;
    }


	/**
     * 견적서관리 등록.
     */
    public int insertEstimate(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{

        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
    	Statement stmt = null;
        ResultSet rs = null;
    	Statement stmt2 = null;
        ResultSet rs2 = null;
        String query = "";
		String reg_dt = Util.getLoginTime();
        int count = 0;
		int id_chk = 0;

		String query3 = "select count(0) from estimate where est_id='"+bean.getEst_id()+"'";

		String query4 = " SELECT to_char(sysdate,'YYMM')||'"+bean.getEst_id().substring(4,5)+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001') ID"+
						" FROM ESTIMATE "+
						" where est_id like to_char(sysdate,'YYMM')||'%' and est_id like '%"+bean.getEst_id().substring(4,5)+"%'";

        query = " INSERT INTO ESTIMATE"+
				" (est_id, est_nm, est_ssn, est_tel, est_fax, car_comp_id, car_cd, car_id, car_seq, car_amt,"+
				"  opt, opt_seq, opt_amt, col, col_seq, col_amt, dc, dc_seq, dc_amt, o_1,"+
				"  a_a, a_b, a_h, pp_st, pp_per, rg_8, ins_age, ins_dj, ro_13, g_10,"+
				"  gi_amt, gi_fee, gtr_amt, pp_s_amt, pp_v_amt, ifee_s_amt, ifee_v_amt, fee_s_amt, fee_v_amt, reg_id,"+
				"  reg_dt, pp_amt, ins_good, car_ja, lpg_yn, gi_yn, ro_13_amt, rg_8_amt, fee_dc_per, spr_yn, "+
				"  rent_dt, o_11, lpg_kit, est_st, est_from, today_dist, mgr_nm, mgr_ssn, o_13, udt_st, agree_dist, over_run_amt, "+
				"  reg_code, rent_mng_id, rent_l_cd, rent_st, ins_per, job, one_self, doc_type, vali_type, opt_chk, fee_opt_amt, gi_per, set_code, update_id, talk_tel, "+
				"  est_email, est_type, caroff_emp_yn, print_type, ctr_s_amt, ctr_v_amt, compare_yn, b_agree_dist, b_o_13, loc_st, "+
				"  tint_b_yn, tint_s_yn, tint_ps_yn, tint_ps_nm, tint_ps_amt, tint_n_yn, spe_dc_per, "+
			    "  in_col, accid_serv_amt1, accid_serv_amt2, accid_serv_zero, insurant, cha_st_dt, b_dist, jg_opt_st, jg_col_st, "+
				"  tax_dc_amt, ecar_loc_st, eco_e_tag, ecar_pur_sub_amt, ecar_pur_sub_st, conti_rat, driver_add_amt, pp_ment_yn, tot_dt, jg_tuix_st, jg_tuix_opt_st, "+
			    "  lkas_yn, ldws_yn, aeb_yn, fcw_yn, ev_yn, "+
				"  damdang_nm, damdang_m_tel, bus_st, com_emp_yn, tint_eb_yn, tint_ps_st, etc, bigo, return_select, hcar_loc_st, eh_code, ecar_pur_sub_yn, "+
				"  import_pur_st, car_b_p2, r_dc_amt, l_dc_amt, r_card_amt, l_card_amt, r_cash_back, l_cash_back, r_bank_amt, l_bank_amt, dir_pur_commi_yn, opt_amt_m, gi_grade, garnish_col, garnish_yn, tint_bn_yn, hook_yn, "+
				"  new_license_plate, tint_cons_yn, tint_cons_amt, br_to, br_from, legal_yn, br_to_st, info_st, esti_d_etc, tint_sn_yn, rtn_run_amt, rtn_run_amt_yn, cng_dt, top_cng_yn )"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, 0, 0, ?, ?, ?, ?,"+
			    "   ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, replace(?,'-',''), ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, replace(?,'-',''), ?, ?, "+
				"   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " +
		        "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?,'-',''), ? )";
           
		String query2 = " update estimate set est_ssn='N' "+
						" where (est_id like '%J%' or est_type='J') and nvl(est_ssn,'Y')='Y' and est_nm=? and car_comp_id=? and car_cd=? and car_id=?  ";

		String query5 = " insert into esti_compare ( EST_ID ) values ( ? ) ";
		String query6 = " insert into esti_exam ( EST_ID ) values ( ? ) ";
		
	   try{
		   con.setAutoCommit(false);


            //est_id 체크
            stmt = con.createStatement();
            rs = stmt.executeQuery(query3);
            if(rs.next())
            	id_chk = rs.getInt(1);
            rs.close();
      		stmt.close();

			if(id_chk > 0){
	            //est_id 생성
		        stmt2 = con.createStatement();
			    rs2 = stmt2.executeQuery(query4);
	            if(rs2.next()){
		        	bean.setEst_id(rs2.getString(1)==null?"":rs2.getString(1));
				}
			    rs2.close();
      			stmt2.close();
			}


			//주요차종월대여료일때
			String est_nm = bean.getEst_nm().trim();
			if(est_nm.equals("rb36") || est_nm.equals("rs36") || est_nm.equals("lb36") || est_nm.equals("ls36") || est_nm.equals("lb362") || est_nm.equals("ls362")){
	            pstmt2 = con.prepareStatement(query2);
		        pstmt2.setString(1, bean.getEst_nm().trim());
			    pstmt2.setString(2, bean.getCar_comp_id().trim());
	            pstmt2.setString(3, bean.getCar_cd().trim());
		        pstmt2.setString(4, bean.getCar_id().trim());
				count = pstmt2.executeUpdate();
				pstmt2.close();
			}

			if(bean.getReg_dt().equals("")){
				bean.setReg_dt(reg_dt.substring(0,12));
			}else{
				bean.setReg_dt(bean.getReg_dt().substring(0,12));					
			}

			if(bean.getRent_dt().equals("")){		
				bean.setRent_dt(bean.getReg_dt().substring(0,8));
			}

            pstmt = con.prepareStatement(query);
            pstmt.setString(1,  bean.getEst_id().trim()		);
            pstmt.setString(2,  bean.getEst_nm().trim()		);
            pstmt.setString(3,  bean.getEst_ssn().trim()	);
            pstmt.setString(4,  bean.getEst_tel().trim()	);
            pstmt.setString(5,  bean.getEst_fax().trim()	);
            pstmt.setString(6,  bean.getCar_comp_id().trim());
            pstmt.setString(7,  bean.getCar_cd().trim()		);
            pstmt.setString(8,  bean.getCar_id().trim()		);
            pstmt.setString(9,  bean.getCar_seq().trim()	);
            pstmt.setInt   (10, bean.getCar_amt()			);
            pstmt.setString(11, bean.getOpt().trim()		);
            pstmt.setString(12, bean.getOpt_seq().trim()	);
            pstmt.setInt   (13, bean.getOpt_amt()			);
            pstmt.setString(14, bean.getCol().trim()		);
            pstmt.setString(15, bean.getCol_seq().trim()	);
            pstmt.setInt   (16, bean.getCol_amt()			);
            pstmt.setString(17, bean.getDc().trim()			);
            pstmt.setString(18, bean.getDc_seq().trim()		);
            pstmt.setInt   (19, bean.getDc_amt()			);
            pstmt.setInt   (20, bean.getO_1()				);
            pstmt.setString(21, bean.getA_a().trim()		);
            pstmt.setString(22, bean.getA_b().trim()		);
            pstmt.setString(23, bean.getA_h().trim()		);
            pstmt.setString(24, bean.getPp_st().trim()		);
            pstmt.setFloat (25, bean.getPp_per()			);
            pstmt.setFloat (26, bean.getRg_8()				);
            pstmt.setString(27, bean.getIns_age().trim()	);
            pstmt.setString(28, bean.getIns_dj().trim()		);
            pstmt.setFloat (29, bean.getRo_13()				);
			pstmt.setInt   (30, bean.getG_10()				);
            pstmt.setInt   (31, bean.getGi_amt()			);
            pstmt.setInt   (32, bean.getGi_fee()			);
            pstmt.setInt   (33, bean.getGtr_amt()			);
            pstmt.setInt   (34, bean.getPp_s_amt()			);
			pstmt.setInt   (35, bean.getPp_v_amt()			);
            pstmt.setInt   (36, bean.getIfee_s_amt()		);
            pstmt.setInt   (37, bean.getIfee_v_amt()		);
            pstmt.setInt   (38, bean.getFee_s_amt()			);
            pstmt.setInt   (39, bean.getFee_v_amt()			);
            pstmt.setString(40, bean.getReg_id().trim()		);
            pstmt.setString(41, bean.getReg_dt().trim()		);
			pstmt.setInt   (42, bean.getPp_amt()			);
			pstmt.setString(43, bean.getIns_good().trim()	);
            pstmt.setInt   (44, bean.getCar_ja()			);
			pstmt.setString(45, bean.getLpg_yn().trim()		);
			pstmt.setString(46, bean.getGi_yn().trim()		);
            pstmt.setInt   (47, bean.getRo_13_amt()			);
            pstmt.setInt   (48, bean.getRg_8_amt()			);
            pstmt.setFloat (49, bean.getFee_dc_per()		);
			pstmt.setString(50, bean.getSpr_yn().trim()		);
			pstmt.setString(51, bean.getRent_dt().trim()	);
            pstmt.setFloat (52, bean.getO_11()				);
			pstmt.setString(53, bean.getLpg_kit().trim()	);
            pstmt.setString(54, bean.getEst_st().trim()		);
            pstmt.setString(55, bean.getEst_from().trim()	);
            pstmt.setInt   (56, bean.getToday_dist()		);
            pstmt.setString(57, bean.getMgr_nm().trim()		);
            pstmt.setString(58, bean.getMgr_ssn().trim()	);
            pstmt.setFloat (59, bean.getO_13()				);
            pstmt.setString(60, bean.getUdt_st().trim()		);
            pstmt.setInt   (61, bean.getAgree_dist()		);
            pstmt.setInt   (62, bean.getOver_run_amt()		);
			pstmt.setString(63, bean.getReg_code().trim()	);
            pstmt.setString(64, bean.getRent_mng_id().trim());
            pstmt.setString(65, bean.getRent_l_cd().trim()	);
            pstmt.setString(66, bean.getRent_st().trim()	);
            pstmt.setString(67, bean.getIns_per().trim()	);
            pstmt.setString(68, bean.getJob().trim()		);
            pstmt.setString(69, bean.getOne_self().trim()	);
            pstmt.setString(70, bean.getDoc_type().trim()	);
			pstmt.setString(71, bean.getVali_type().trim()	);
            pstmt.setString(72, bean.getOpt_chk().trim()	);
            pstmt.setInt   (73, bean.getFee_opt_amt()		);
			pstmt.setFloat (74, bean.getGi_per()			);
			pstmt.setString(75, bean.getSet_code().trim()	);
			pstmt.setString(76, bean.getUpdate_id().trim()	);
			pstmt.setString(77, bean.getTalk_tel().trim()	);
			pstmt.setString(78, bean.getEst_email().trim()	);
			pstmt.setString(79, bean.getEst_type().trim()	);
			pstmt.setString(80, bean.getCaroff_emp_yn().trim());
			pstmt.setString(81, bean.getPrint_type().trim()	);
			pstmt.setString(82, bean.getCompare_yn().trim()	);
			pstmt.setInt   (83, bean.getB_agree_dist()		);
			pstmt.setFloat (84, bean.getB_o_13()			);
			pstmt.setString(85, bean.getLoc_st().trim()		);
			pstmt.setString(86, bean.getTint_b_yn().trim()	);
			pstmt.setString(87, bean.getTint_s_yn().trim()	);
			pstmt.setString(88, bean.getTint_ps_yn().trim()	);			// 고급썬팅
			pstmt.setString(89, bean.getTint_ps_nm().trim()	);			// 고급썬팅 내용
			pstmt.setInt   (90, bean.getTint_ps_amt()		);			// 고급썬팅 추가금액(공급가)
			pstmt.setString(91, bean.getTint_n_yn().trim()	);
			pstmt.setFloat (92, bean.getSpe_dc_per()		);
			pstmt.setString(93, bean.getIn_col().trim()		);
			pstmt.setInt   (94, bean.getAccid_serv_amt1()	);
			pstmt.setInt   (95, bean.getAccid_serv_amt2()	);
			pstmt.setString(96, bean.getAccid_serv_zero().trim());
            pstmt.setString(97, bean.getInsurant().trim()	);
			pstmt.setString(98, bean.getCha_st_dt().trim()	);
			pstmt.setInt   (99, bean.getB_dist()			);
			pstmt.setString(100, bean.getJg_opt_st().trim()	);
			pstmt.setString(101, bean.getJg_col_st().trim()	);
			pstmt.setInt   (102, bean.getTax_dc_amt()		);
			pstmt.setString(103,bean.getEcar_loc_st().trim());
			pstmt.setString(104,bean.getEco_e_tag().trim()	);
			pstmt.setInt   (105,bean.getEcar_pur_sub_amt()	);
			pstmt.setString(106,bean.getEcar_pur_sub_st().trim());
			pstmt.setString(107,bean.getConti_rat()         );
			pstmt.setInt   (108,bean.getDriver_add_amt()	);
			pstmt.setString(109,bean.getPp_ment_yn()        );
			pstmt.setString(110,bean.getTot_dt()		    );
			pstmt.setString(111,bean.getJg_tuix_st()	    );
			pstmt.setString(112,bean.getJg_tuix_opt_st()    );
			pstmt.setString(113,bean.getLkas_yn()   	    );
			pstmt.setString(114,bean.getLdws_yn()  		    );
			pstmt.setString(115,bean.getAeb_yn()   		    );
			pstmt.setString(116,bean.getFcw_yn()   		    );
			pstmt.setString(117,bean.getEv_yn()  		    );
			pstmt.setString(118,bean.getDamdang_nm()	    );
			pstmt.setString(119,bean.getDamdang_m_tel()	    );
			pstmt.setString(120,bean.getBus_st()		    );
			pstmt.setString(121,bean.getCom_emp_yn()	    );
			pstmt.setString(122,bean.getTint_eb_yn().trim() );
			pstmt.setString(123,bean.getTint_ps_st().trim() );
			pstmt.setString(124,bean.getEtc().trim()		);
			pstmt.setString(125,bean.getBigo().trim()		);
			pstmt.setString(126,bean.getReturn_select().trim());
			pstmt.setString(127,bean.getHcar_loc_st().trim());
			pstmt.setString(128,bean.getEh_code().trim());
			pstmt.setString(129,bean.getEcar_pur_sub_yn().trim());
			
			pstmt.setString(130,bean.getImport_pur_st().trim());
			pstmt.setInt   (131,bean.getCar_b_p2()	);
			pstmt.setInt   (132,bean.getR_dc_amt()	);
			pstmt.setInt   (133,bean.getL_dc_amt()	);
			pstmt.setInt   (134,bean.getR_card_amt()	);
			pstmt.setInt   (135,bean.getL_card_amt()	);
			pstmt.setInt   (136,bean.getR_cash_back()	);
			pstmt.setInt   (137,bean.getL_cash_back()	);
			pstmt.setInt   (138,bean.getR_bank_amt()	);
			pstmt.setInt   (139,bean.getL_bank_amt()	);
			
			pstmt.setString(140,bean.getDir_pur_commi_yn());
			pstmt.setInt   (141,bean.getOpt_amt_m());
			
			pstmt.setString(142,bean.getGi_grade().trim());
			
			pstmt.setString(143,bean.getGarnish_col().trim());
			pstmt.setString(144,bean.getGarnish_yn().trim());
			
			pstmt.setString(145,bean.getTint_bn_yn().trim());

			pstmt.setString(146,bean.getHook_yn().trim());
			
			pstmt.setString(147,bean.getNew_license_plate().trim());
			pstmt.setString(148,bean.getTint_cons_yn().trim());
			pstmt.setInt   (149,bean.getTint_cons_amt()	);			
			pstmt.setString(150,bean.getBr_to().trim());
			pstmt.setString(151,bean.getBr_from().trim());			
			pstmt.setString(152,bean.getLegal_yn().trim());			
			pstmt.setString(153,bean.getBr_to_st().trim());			
			pstmt.setString(154,bean.getInfo_st().trim());
			pstmt.setString(155,bean.getEsti_d_etc().trim());
			pstmt.setString(156, bean.getTint_sn_yn().trim());
			pstmt.setInt   (157, bean.getRtn_run_amt());
			pstmt.setString(158, bean.getRtn_run_amt_yn());
			pstmt.setString(159, bean.getCng_dt().trim());
			pstmt.setString(160, bean.getTop_cng_yn().trim());

			count = pstmt.executeUpdate();
            pstmt.close();

            pstmt3 = con.prepareStatement(query5);
	        pstmt3.setString(1, bean.getEst_id().trim());
			count = pstmt3.executeUpdate();
			pstmt3.close();

            pstmt4 = con.prepareStatement(query6);
	        pstmt4.setString(1, bean.getEst_id().trim());
			count = pstmt4.executeUpdate();
			pstmt4.close();
            

			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstimate]"+se);

				System.out.println("[1,  bean.getEst_id().trim()		]"+bean.getEst_id().trim()			);
				System.out.println("[2,  bean.getEst_nm().trim()		]"+bean.getEst_nm().trim()			);
				System.out.println("[3,  bean.getEst_ssn().trim()		]"+bean.getEst_ssn().trim()			);
				System.out.println("[4,  bean.getEst_tel().trim()		]"+bean.getEst_tel().trim()			);
				System.out.println("[5,  bean.getEst_fax().trim()		]"+bean.getEst_fax().trim()			);
				System.out.println("[6,  bean.getCar_comp_id().trim()	]"+bean.getCar_comp_id().trim()		);
				System.out.println("[7,  bean.getCar_cd().trim()		]"+bean.getCar_cd().trim()			);
				System.out.println("[8,  bean.getCar_id().trim()		]"+bean.getCar_id().trim()			);
				System.out.println("[9,  bean.getCar_seq().trim()		]"+bean.getCar_seq().trim()			);
				System.out.println("[10, bean.getCar_amt()				]"+bean.getCar_amt()				);
				System.out.println("[11, bean.getOpt().trim()			]"+bean.getOpt().trim()				);
				System.out.println("[12, bean.getOpt_seq().trim()		]"+bean.getOpt_seq().trim()			);
				System.out.println("[13, bean.getOpt_amt()				]"+bean.getOpt_amt()				);
				System.out.println("[14, bean.getCol().trim()			]"+bean.getCol().trim()				);
				System.out.println("[15, bean.getCol_seq().trim()		]"+bean.getCol_seq().trim()			);
				System.out.println("[16, bean.getCol_amt()				]"+bean.getCol_amt()				);
				System.out.println("[17, bean.getDc().trim()			]"+bean.getDc().trim()				);
				System.out.println("[18, bean.getDc_seq().trim()		]"+bean.getDc_seq().trim()			);
				System.out.println("[19, bean.getDc_amt()				]"+bean.getDc_amt()					);
				System.out.println("[20, bean.getO_1()					]"+bean.getO_1()					);
				System.out.println("[21, bean.getA_a().trim()			]"+bean.getA_a().trim()				);
				System.out.println("[22, bean.getA_b().trim()			]"+bean.getA_b().trim()				);
				System.out.println("[23, bean.getA_h().trim()			]"+bean.getA_h().trim()				);
				System.out.println("[24, bean.getPp_st().trim()			]"+bean.getPp_st().trim()			);
				System.out.println("[25, bean.getPp_per()				]"+bean.getPp_per()					);
				System.out.println("[26, bean.getRg_8()					]"+bean.getRg_8()					);
				System.out.println("[27, bean.getIns_age().trim()		]"+bean.getIns_age().trim()			);
				System.out.println("[28, bean.getIns_dj().trim()		]"+bean.getIns_dj().trim()			);
				System.out.println("[29, bean.getRo_13()				]"+bean.getRo_13()					);
				System.out.println("[30, bean.getG_10()					]"+bean.getG_10()					);
				System.out.println("[31, bean.getGi_amt()				]"+bean.getGi_amt()					);
				System.out.println("[32, bean.getGi_fee()				]"+bean.getGi_fee()					);
				System.out.println("[33, bean.getGtr_amt()				]"+bean.getGtr_amt()				);
				System.out.println("[34, bean.getPp_s_amt()				]"+bean.getPp_s_amt()				);
				System.out.println("[35, bean.getPp_v_amt()				]"+bean.getPp_v_amt()				);
				System.out.println("[36, bean.getIfee_s_amt()			]"+bean.getIfee_s_amt()				);
				System.out.println("[37, bean.getIfee_v_amt()			]"+bean.getIfee_v_amt()				);
				System.out.println("[38, bean.getFee_s_amt()			]"+bean.getFee_s_amt()				);
				System.out.println("[39, bean.getFee_v_amt()			]"+bean.getFee_v_amt()				);
				System.out.println("[40, bean.getReg_id().trim()		]"+bean.getReg_id().trim()			);
				System.out.println("[41, bean.getReg_dt().trim()		]"+bean.getReg_dt().trim()			);
				System.out.println("[42, bean.getPp_amt()				]"+bean.getPp_amt()					);
				System.out.println("[43, bean.getIns_good().trim()		]"+bean.getIns_good().trim()		);
				System.out.println("[44, bean.getCar_ja()				]"+bean.getCar_ja()					);
				System.out.println("[45, bean.getLpg_yn().trim()		]"+bean.getLpg_yn().trim()			);
				System.out.println("[46, bean.getGi_yn().trim()			]"+bean.getGi_yn().trim()			);
				System.out.println("[47, bean.getRo_13_amt()			]"+bean.getRo_13_amt()				);
				System.out.println("[48, bean.getRg_8_amt()				]"+bean.getRg_8_amt()				);
				System.out.println("[49, bean.getFee_dc_per()			]"+bean.getFee_dc_per()				);
				System.out.println("[50, bean.getSpr_yn().trim()		]"+bean.getSpr_yn().trim()			);
				System.out.println("[51, bean.getRent_dt().trim()		]"+bean.getRent_dt().trim()			);
				System.out.println("[52, bean.getO_11()					]"+bean.getO_11()					);
				System.out.println("[53, bean.getLpg_kit().trim()		]"+bean.getLpg_kit().trim()			);
				System.out.println("[54, bean.getEst_st().trim()		]"+bean.getEst_st().trim()			);
				System.out.println("[55, bean.getEst_from().trim()		]"+bean.getEst_from().trim()		);
				System.out.println("[56, bean.getToday_dist()			]"+bean.getToday_dist()				);
				System.out.println("[57, bean.getMgr_nm().trim()		]"+bean.getMgr_nm().trim()			);
				System.out.println("[58, bean.getMgr_ssn().trim()		]"+bean.getMgr_ssn().trim()			);
				System.out.println("[59, bean.getO_13()					]"+bean.getO_13()					);
				System.out.println("[60, bean.getUdt_st().trim()		]"+bean.getUdt_st().trim()			);
				System.out.println("[61, bean.getAgree_dist()			]"+bean.getAgree_dist()				);
				System.out.println("[62, bean.getOver_run_amt()			]"+bean.getOver_run_amt()			);
				System.out.println("[63, bean.getReg_code().trim()		]"+bean.getReg_code().trim()		);
				System.out.println("[64, bean.getRent_mng_id().trim()	]"+bean.getRent_mng_id().trim()		);
				System.out.println("[65, bean.getRent_l_cd().trim()		]"+bean.getRent_l_cd().trim()		);
				System.out.println("[66, bean.getRent_st().trim()		]"+bean.getRent_st().trim()			);
				System.out.println("[67, bean.getIns_per().trim()		]"+bean.getIns_per().trim()			);
				System.out.println("[68, bean.getJob().trim()			]"+bean.getJob().trim()				);
				System.out.println("[69, bean.getOne_self().trim()		]"+bean.getOne_self().trim()		);
				System.out.println("[70, bean.getDoc_type().trim()		]"+bean.getDoc_type().trim()		);
				System.out.println("[71, bean.getVali_type().trim()		]"+bean.getVali_type().trim()		);
				System.out.println("[72, bean.getOpt_chk().trim()		]"+bean.getOpt_chk().trim()			);
				System.out.println("[73, bean.getFee_opt_amt()			]"+bean.getFee_opt_amt()			);
				System.out.println("[74, bean.getGi_per()				]"+bean.getGi_per()					);
				System.out.println("[75, bean.getSet_code().trim()		]"+bean.getSet_code().trim()		);
				System.out.println("[76, bean.getUpdate_id().trim()		]"+bean.getUpdate_id().trim()		);
				System.out.println("[77, bean.getTalk_tel().trim()		]"+bean.getTalk_tel().trim()		);
				System.out.println("[78, bean.getEst_email().trim()		]"+bean.getEst_email().trim()		);
				System.out.println("[79, bean.getEst_type().trim()		]"+bean.getEst_type().trim()		);
				System.out.println("[80, bean.getCaroff_emp_yn().trim()	]"+bean.getCaroff_emp_yn().trim()	);
				
				System.out.println("[140, bean.getDir_pur_commi_yn()	]"+bean.getDir_pur_commi_yn()	);
				System.out.println("[141, bean.getOpt_amt_m()	]"+bean.getOpt_amt_m()	);
				
				System.out.println("[142, bean.getGi_grade()	]"+bean.getGi_grade()	);
				
				System.out.println("[143, bean.bean.getGarnish_col()	]"+bean.getGarnish_col()	);
				System.out.println("[144, bean.bean.getGarnish_yn()	]"+bean.getGarnish_yn()	);
				System.out.println("[145, bean.bean.getTint_bn_yn()	]"+bean.getTint_bn_yn()	);
				System.out.println("[146, bean.bean.getHook_yn()	]"+bean.getHook_yn()	);
				
				System.out.println("[147, bean.bean.getNew_license_plate()	]"+bean.getNew_license_plate()	);
				System.out.println("[148, bean.bean.getTint_cons_yn()	]"+bean.getTint_cons_yn()	);
				System.out.println("[149, bean.bean.getTint_cons_amt()	]"+bean.getTint_cons_amt()	);
				
				System.out.println("[150, bean.bean.getBr_to()	]"+bean.getBr_to()	);
				System.out.println("[151, bean.bean.getBr_from()	]"+bean.getBr_from()	);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                if(pstmt2 != null)	pstmt2.close();
                if(pstmt3 != null)	pstmt3.close();
                if(pstmt4 != null)	pstmt4.close();
                if(rs != null)		rs.close();
                if(stmt != null)	stmt.close();
                if(rs2 != null)		rs2.close();
                if(stmt2 != null)	stmt2.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
     * 견적서관리 등록.
     */
    public int insertEstimateHp(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
    	Statement stmt = null;
        ResultSet rs = null;
    	Statement stmt2 = null;
        ResultSet rs2 = null;
        String query = "";
		String reg_dt = Util.getLoginTime();
        int count = 0;
		int id_chk = 0;

		String query3 = "select count(0) from estimate_hp where est_id='"+bean.getEst_id()+"'";

		String query4 = " SELECT to_char(sysdate,'YYMM')||'"+bean.getEst_id().substring(4,5)+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001') ID"+
						" FROM estimate_hp "+
						" where est_id like to_char(sysdate,'YYMM')||'%' and est_id like '%"+bean.getEst_id().substring(4,5)+"%'";


        query = " INSERT INTO estimate_hp"+ 
				" (est_id, est_nm, est_ssn, est_tel, est_fax, car_comp_id, car_cd, car_id, car_seq, car_amt,"+
				"  opt, opt_seq, opt_amt, col, col_seq, col_amt, dc, dc_seq, dc_amt, esti_d_etc, o_1,"+
				"  a_a, a_b, a_h, pp_st, pp_per, rg_8, ins_age, ins_dj, ro_13, g_10,"+
				"  gi_amt, gi_fee, gtr_amt, pp_s_amt, pp_v_amt, ifee_s_amt, ifee_v_amt, fee_s_amt, fee_v_amt, reg_id,"+
				"  reg_dt, pp_amt, ins_good, car_ja, lpg_yn, gi_yn, ro_13_amt, rg_8_amt, fee_dc_per, spr_yn, "+
				"  rent_dt, o_11, lpg_kit, est_st, est_from, today_dist, mgr_nm, mgr_ssn, o_13, udt_st, agree_dist, over_run_amt, "+
				"  reg_code, doc_type, vali_type, ins_per, est_type, b_agree_dist, b_o_13, loc_st, tint_b_yn, tint_s_yn, tint_n_yn, job, jg_opt_st, jg_col_st, set_code, "+
				"  tax_dc_amt, ecar_loc_st, eco_e_tag, ecar_pur_sub_amt, ecar_pur_sub_st, conti_rat, jg_tuix_st, jg_tuix_opt_st, tint_eb_yn, return_select, hcar_loc_st, print_type, "+
				"  lkas_yn, ldws_yn, aeb_yn, fcw_yn, hook_yn, etc, tint_bn_yn, new_license_plate, tint_cons_yn, tint_cons_amt, rtn_run_amt "+
				"  )"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
			    "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"	?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
			    "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )";
           
		String query2 = " update estimate_hp set est_ssn='N' "+
						" where (est_id like '%J%' or est_type='J') and nvl(est_ssn,'Y')='Y' and est_nm=? and car_comp_id=? and car_cd=? and car_id=?  ";

	   try{
		   con.setAutoCommit(false);


            //est_id 체크
            stmt = con.createStatement();
            rs = stmt.executeQuery(query3);
            if(rs.next())
            	id_chk = rs.getInt(1);
            rs.close();
      		stmt.close();

			if(id_chk > 0){
	            //est_id 생성
		        stmt2 = con.createStatement();
			    rs2 = stmt2.executeQuery(query4);
	            if(rs2.next())
		        	bean.setEst_id(rs2.getString(1)==null?"":rs2.getString(1));
			    rs2.close();
      			stmt2.close();
			}


			//주요차종월대여료일때
			String est_nm = bean.getEst_nm().trim();
			if(est_nm.equals("rb36") || est_nm.equals("rs36") || est_nm.equals("lb36") || est_nm.equals("ls36") || est_nm.equals("lb362") || est_nm.equals("ls362")){
	            pstmt2 = con.prepareStatement(query2);
		        pstmt2.setString(1, bean.getEst_nm().trim());
			    pstmt2.setString(2, bean.getCar_comp_id().trim());
	            pstmt2.setString(3, bean.getCar_cd().trim());
		        pstmt2.setString(4, bean.getCar_id().trim());
				count = pstmt2.executeUpdate();
				pstmt2.close();
			}

			if(bean.getReg_dt().equals("")){
				bean.setReg_dt(reg_dt.substring(0,12));
			}else{
				bean.setReg_dt(bean.getReg_dt().substring(0,12));					
			}

			if(bean.getRent_dt().equals("")){		
				bean.setRent_dt(bean.getReg_dt().substring(0,8));
			}

            pstmt = con.prepareStatement(query);
            pstmt.setString(1,  bean.getEst_id().trim()		);
            pstmt.setString(2,  bean.getEst_nm().trim()		);
            pstmt.setString(3,  bean.getEst_ssn().trim()	);
            pstmt.setString(4,  bean.getEst_tel().trim()	);
            pstmt.setString(5,  bean.getEst_fax().trim()	);
            pstmt.setString(6,  bean.getCar_comp_id().trim());
            pstmt.setString(7,  bean.getCar_cd().trim()		);
            pstmt.setString(8,  bean.getCar_id().trim()		);
            pstmt.setString(9,  bean.getCar_seq().trim()	);
            pstmt.setInt   (10, bean.getCar_amt()			);
            pstmt.setString(11, bean.getOpt().trim()		);
            pstmt.setString(12, bean.getOpt_seq().trim()	);
            pstmt.setInt   (13, bean.getOpt_amt()			);
            pstmt.setString(14, bean.getCol().trim()		);
            pstmt.setString(15, bean.getCol_seq().trim()	);
            pstmt.setInt   (16, bean.getCol_amt()			);
            pstmt.setString(17, bean.getDc().trim()			);
            pstmt.setString(18, bean.getDc_seq().trim()		);
            pstmt.setInt   (19, bean.getDc_amt()			);
            pstmt.setString(20, bean.getEsti_d_etc().trim()	);
            pstmt.setInt   (21, bean.getO_1()				);
            pstmt.setString(22, bean.getA_a().trim()		);
            pstmt.setString(23, bean.getA_b().trim()		);
            pstmt.setString(24, bean.getA_h().trim()		);
            pstmt.setString(25, bean.getPp_st().trim()		);
            pstmt.setFloat (26, bean.getPp_per()			);
            pstmt.setFloat (27, bean.getRg_8()				);
            pstmt.setString(28, bean.getIns_age().trim()	);
            pstmt.setString(29, bean.getIns_dj().trim()		);
            pstmt.setFloat (30, bean.getRo_13()				);
			pstmt.setInt   (31, bean.getG_10()				);
            pstmt.setInt   (32, bean.getGi_amt()			);
            pstmt.setInt   (33, bean.getGi_fee()			);
            pstmt.setInt   (34, bean.getGtr_amt()			);
            pstmt.setInt   (35, bean.getPp_s_amt()			);
			pstmt.setInt   (36, bean.getPp_v_amt()			);
            pstmt.setInt   (37, bean.getIfee_s_amt()		);
            pstmt.setInt   (38, bean.getIfee_v_amt()		);
            pstmt.setInt   (39, bean.getFee_s_amt()			);
            pstmt.setInt   (40, bean.getFee_v_amt()			);
            pstmt.setString(41, bean.getReg_id().trim()		);
            pstmt.setString(42, bean.getReg_dt().trim()		);
			pstmt.setInt   (43, bean.getPp_amt()			);
			pstmt.setString(44, bean.getIns_good().trim()	);
            pstmt.setInt   (45, bean.getCar_ja()			);
			pstmt.setString(46, bean.getLpg_yn().trim()		);
			pstmt.setString(47, bean.getGi_yn().trim()		);
            pstmt.setInt   (48, bean.getRo_13_amt()			);
            pstmt.setInt   (49, bean.getRg_8_amt()			);
            pstmt.setFloat (50, bean.getFee_dc_per()		);
			pstmt.setString(51, bean.getSpr_yn().trim()		);
			pstmt.setString(52, bean.getRent_dt().trim()	);
            pstmt.setFloat (53, bean.getO_11()				);
			pstmt.setString(54, bean.getLpg_kit().trim()	);
            pstmt.setString(55, bean.getEst_st().trim()		);
            pstmt.setString(56, bean.getEst_from().trim()	);
            pstmt.setInt   (57, bean.getToday_dist()		);
            pstmt.setString(58, bean.getMgr_nm().trim()		);
            pstmt.setString(59, bean.getMgr_ssn().trim()	);
            pstmt.setFloat (60, bean.getO_13()				);
            pstmt.setString(61, bean.getUdt_st().trim()		);
            pstmt.setInt   (62, bean.getAgree_dist()		);
            pstmt.setInt   (63, bean.getOver_run_amt()		);
			pstmt.setString(64, bean.getReg_code().trim()	);
            pstmt.setString(65, bean.getDoc_type().trim()	);
			pstmt.setString(66, bean.getVali_type().trim()	);
			pstmt.setString(67, bean.getIns_per().trim()	);
			pstmt.setString(68, bean.getEst_type().trim()	);
			pstmt.setInt   (69, bean.getB_agree_dist()		);
			pstmt.setFloat (70, bean.getB_o_13()			);
			pstmt.setString(71, bean.getLoc_st().trim()		);
			pstmt.setString(72, bean.getTint_b_yn().trim()	);
			pstmt.setString(73, bean.getTint_s_yn().trim()	);
			pstmt.setString(74, bean.getTint_n_yn().trim()	);
			pstmt.setString(75, bean.getJob().trim()		);
			pstmt.setString(76, bean.getJg_opt_st().trim()	);
			pstmt.setString(77, bean.getJg_col_st().trim()	);
			pstmt.setString(78, bean.getSet_code().trim()	);
			pstmt.setInt   (79, bean.getTax_dc_amt()		);
			pstmt.setString(80, bean.getEcar_loc_st().trim());
			pstmt.setString(81, bean.getEco_e_tag().trim());
			pstmt.setInt   (82, bean.getEcar_pur_sub_amt()	);
			pstmt.setString(83, bean.getEcar_pur_sub_st().trim());
			pstmt.setString(84, bean.getConti_rat());
			pstmt.setString(85, bean.getJg_tuix_st().trim()	);
			pstmt.setString(86, bean.getJg_tuix_opt_st().trim());
			pstmt.setString(87, bean.getTint_eb_yn().trim()	);
			pstmt.setString(88, bean.getReturn_select().trim());
			pstmt.setString(89, bean.getHcar_loc_st().trim());
			pstmt.setString(90, bean.getPrint_type().trim());
			pstmt.setString(91, bean.getLkas_yn()   	    );
			pstmt.setString(92, bean.getLdws_yn()  	    );
			pstmt.setString(93, bean.getAeb_yn()   		    );
			pstmt.setString(94, bean.getFcw_yn()   		    );
			pstmt.setString(95, bean.getHook_yn() 		    );
			pstmt.setString(96, bean.getEtc()   			    );			
			pstmt.setString(97, bean.getTint_bn_yn().trim()    );	
			pstmt.setString(98, bean.getNew_license_plate().trim());
			pstmt.setString(99, bean.getTint_cons_yn().trim());
			pstmt.setInt   (100, bean.getTint_cons_amt()	);
			pstmt.setInt   (101, bean.getRtn_run_amt()		);
			
			count = pstmt.executeUpdate();
            
            pstmt.close();
			con.commit();
			
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstimateHp]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                if(pstmt2 != null)	pstmt2.close();
                if(rs != null)		rs.close();
                if(stmt != null)	stmt.close();
                if(rs2 != null)		rs2.close();
                if(stmt2 != null)	stmt2.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
     * 견적서관리 등록.
     */
    public int insertEstimateSh(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
    	Statement stmt2 = null;
        ResultSet rs2 = null;
        String query = "";
		String reg_dt = Util.getLoginTime();
        int count = 0;
		int id_chk = 0;

		String query3 = "select count(0) from estimate_sh where est_id='"+bean.getEst_id()+"'";

		String query4 = " SELECT to_char(sysdate,'YYMM')||'"+bean.getEst_id().substring(4,5)+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001') ID"+
						" FROM estimate_sh "+
						" where est_id like to_char(sysdate,'YYMM')||'%' and est_id like '%"+bean.getEst_id().substring(4,5)+"%'";


        query = " INSERT INTO estimate_sh"+
				" (est_id, est_nm, est_ssn, est_tel, est_fax, car_comp_id, car_cd, car_id, car_seq, car_amt,"+
				"  opt, opt_seq, opt_amt, col, col_seq, col_amt, dc, dc_seq, dc_amt, o_1,"+
				"  a_a, a_b, a_h, pp_st, pp_per, rg_8, ins_age, ins_dj, ro_13, g_10,"+
				"  gi_amt, gi_fee, gtr_amt, pp_s_amt, pp_v_amt, ifee_s_amt, ifee_v_amt, fee_s_amt, fee_v_amt, reg_id,"+
				"  reg_dt, pp_amt, ins_good, car_ja, lpg_yn, gi_yn, ro_13_amt, rg_8_amt, fee_dc_per, spr_yn, "+
				"  rent_dt, o_11, lpg_kit, est_st, est_from, today_dist, mgr_nm, mgr_ssn, o_13, udt_st, agree_dist, over_run_amt, doc_type, vali_type, est_type, b_agree_dist, b_o_13, loc_st, "+
				"  tint_b_yn, tint_s_yn, tint_n_yn, cha_st_dt, b_dist, jg_opt_st, jg_col_st, "+
				"  tax_dc_amt, ecar_loc_st, eco_e_tag, ecar_pur_sub_amt, ecar_pur_sub_st, jg_tuix_st, jg_tuix_opt_st, tint_eb_yn, return_select, hcar_loc_st, "+
				"  lkas_yn, ldws_yn, aeb_yn, fcw_yn, hook_yn, tint_bn_yn, new_license_plate, tint_cons_yn, tint_cons_amt, rtn_run_amt  )"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,"+
				"   replace(?,'-',''), ?, ?, ?, ?,   ?, ?, ?, ?, ?,"+
				"   replace(?,'-',''), ?, ?, ?, ?,   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, "+
			    "   ?, ?, ?, ?, ?,   ?, replace(?,'-',''), ?, ?, ?, "+
				"	?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, "+
			    "   ?, ?, ?, ?, ?,   ?, ?, ?, ?, ? )";
           

	   try{
		   con.setAutoCommit(false);


            //est_id 체크
            stmt = con.createStatement();
            rs = stmt.executeQuery(query3);
            if(rs.next())
            	id_chk = rs.getInt(1);
            rs.close();
      		stmt.close();

			if(id_chk > 0){
	            //est_id 생성
		        stmt2 = con.createStatement();
			    rs2 = stmt2.executeQuery(query4);
	            if(rs2.next())
		        	bean.setEst_id(rs2.getString(1)==null?"":rs2.getString(1));
			    rs2.close();
      			stmt2.close();
			}



			if(bean.getReg_dt().equals("")){
				bean.setReg_dt(reg_dt.substring(0,12));
			}else{
				bean.setReg_dt(bean.getReg_dt().substring(0,12));					
			}

			if(bean.getRent_dt().equals("")){		
				bean.setRent_dt(bean.getReg_dt().substring(0,8));
			}

            pstmt = con.prepareStatement(query);
            pstmt.setString(1,  bean.getEst_id().trim()		);
            pstmt.setString(2,  bean.getEst_nm().trim()		);
            pstmt.setString(3,  bean.getEst_ssn().trim()	);
            pstmt.setString(4,  bean.getEst_tel().trim()	);
            pstmt.setString(5,  bean.getEst_fax().trim()	);
            pstmt.setString(6,  bean.getCar_comp_id().trim());
            pstmt.setString(7,  bean.getCar_cd().trim()		);
            pstmt.setString(8,  bean.getCar_id().trim()		);
            pstmt.setString(9,  bean.getCar_seq().trim()	);
            pstmt.setInt   (10, bean.getCar_amt()			);
            pstmt.setString(11, bean.getOpt().trim()		);
            pstmt.setString(12, bean.getOpt_seq().trim()	);
            pstmt.setInt   (13, bean.getOpt_amt()			);
            pstmt.setString(14, bean.getCol().trim()		);
            pstmt.setString(15, bean.getCol_seq().trim()	);
            pstmt.setInt   (16, bean.getCol_amt()			);
            pstmt.setString(17, bean.getDc().trim()			);
            pstmt.setString(18, bean.getDc_seq().trim()		);
            pstmt.setInt   (19, bean.getDc_amt()			);
            pstmt.setInt   (20, bean.getO_1()				);
            pstmt.setString(21, bean.getA_a().trim()		);
            pstmt.setString(22, bean.getA_b().trim()		);
            pstmt.setString(23, bean.getA_h().trim()		);
            pstmt.setString(24, bean.getPp_st().trim()		);
            pstmt.setFloat (25, bean.getPp_per()			);
            pstmt.setFloat (26, bean.getRg_8()				);
            pstmt.setString(27, bean.getIns_age().trim()	);
            pstmt.setString(28, bean.getIns_dj().trim()		);
            pstmt.setFloat (29, bean.getRo_13()				);
			pstmt.setInt   (30, bean.getG_10()				);
            pstmt.setInt   (31, bean.getGi_amt()			);
            pstmt.setInt   (32, bean.getGi_fee()			);
            pstmt.setInt   (33, bean.getGtr_amt()			);
            pstmt.setInt   (34, bean.getPp_s_amt()			);
			pstmt.setInt   (35, bean.getPp_v_amt()			);
            pstmt.setInt   (36, bean.getIfee_s_amt()		);
            pstmt.setInt   (37, bean.getIfee_v_amt()		);
            pstmt.setInt   (38, bean.getFee_s_amt()			);
            pstmt.setInt   (39, bean.getFee_v_amt()			);
            pstmt.setString(40, bean.getReg_id().trim()		);
            pstmt.setString(41, bean.getReg_dt().trim()		);
			pstmt.setInt   (42, bean.getPp_amt()			);
			pstmt.setString(43, bean.getIns_good().trim()	);
            pstmt.setInt   (44, bean.getCar_ja()			);
			pstmt.setString(45, bean.getLpg_yn().trim()		);
			pstmt.setString(46, bean.getGi_yn().trim()		);
            pstmt.setInt   (47, bean.getRo_13_amt()			);
            pstmt.setInt   (48, bean.getRg_8_amt()			);
            pstmt.setFloat (49, bean.getFee_dc_per()		);
			pstmt.setString(50, bean.getSpr_yn().trim()		);
			pstmt.setString(51, bean.getRent_dt().trim()	);
            pstmt.setFloat (52, bean.getO_11()				);
			pstmt.setString(53, bean.getLpg_kit().trim()	);
            pstmt.setString(54, bean.getEst_st().trim()		);
            pstmt.setString(55, bean.getEst_from().trim()	);
            pstmt.setInt   (56, bean.getToday_dist()		);
            pstmt.setString(57, bean.getMgr_nm().trim()		);
            pstmt.setString(58, bean.getMgr_ssn().trim()	);
            pstmt.setFloat (59, bean.getO_13()				);
            pstmt.setString(60, bean.getUdt_st().trim()		);
            pstmt.setInt   (61, bean.getAgree_dist()		);
            pstmt.setInt   (62, bean.getOver_run_amt()		);
            pstmt.setString(63, bean.getDoc_type().trim()	);
			pstmt.setString(64, bean.getVali_type().trim()	);
			pstmt.setString(65, bean.getEst_type().trim()	);
			pstmt.setInt   (66, bean.getB_agree_dist()		);
			pstmt.setFloat (67, bean.getB_o_13()			);
			pstmt.setString(68, bean.getLoc_st().trim()		);
			pstmt.setString(69, bean.getTint_b_yn().trim()	);
			pstmt.setString(70, bean.getTint_s_yn().trim()	);
			pstmt.setString(71, bean.getTint_n_yn().trim()	);
            pstmt.setString(72, bean.getCha_st_dt().trim()	);
            pstmt.setInt   (73, bean.getB_dist()			);
            pstmt.setString(74, bean.getJg_opt_st().trim()	);
            pstmt.setString(75, bean.getJg_col_st().trim()	);
			pstmt.setInt   (76, bean.getTax_dc_amt()		);
			pstmt.setString(77, bean.getEcar_loc_st().trim());
			pstmt.setString(78, bean.getEco_e_tag().trim());
			pstmt.setInt   (79, bean.getEcar_pur_sub_amt()	);
			pstmt.setString(80, bean.getEcar_pur_sub_st().trim());
            pstmt.setString(81, bean.getJg_tuix_st().trim()	);
            pstmt.setString(82, bean.getJg_tuix_opt_st().trim()	);
			pstmt.setString(83, bean.getTint_eb_yn().trim()	);
			pstmt.setString(84, bean.getReturn_select().trim());
			pstmt.setString(85, bean.getHcar_loc_st().trim());
			pstmt.setString(86, bean.getLkas_yn()   	    );
			pstmt.setString(87, bean.getLdws_yn()  		    );
			pstmt.setString(88, bean.getAeb_yn()   		    );
			pstmt.setString(89, bean.getFcw_yn()   		    );
			pstmt.setString(90, bean.getHook_yn()   		    );
			pstmt.setString(91, bean.getTint_bn_yn().trim()    );		
			pstmt.setString(92, bean.getNew_license_plate().trim());
			pstmt.setString(93, bean.getTint_cons_yn().trim());
			pstmt.setInt   (94, bean.getTint_cons_amt()	);
			pstmt.setInt   (95, bean.getRtn_run_amt()		);

			count = pstmt.executeUpdate();
            
            pstmt.close();
			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstimateSh]"+se);

				System.out.println("[1,  bean.getEst_id().trim()		]"+bean.getEst_id().trim()			);
				System.out.println("[2,  bean.getEst_nm().trim()		]"+bean.getEst_nm().trim()			);
				System.out.println("[3,  bean.getEst_ssn().trim()		]"+bean.getEst_ssn().trim()			);
				System.out.println("[4,  bean.getEst_tel().trim()		]"+bean.getEst_tel().trim()			);
				System.out.println("[5,  bean.getEst_fax().trim()		]"+bean.getEst_fax().trim()			);
				System.out.println("[6,  bean.getCar_comp_id().trim()	]"+bean.getCar_comp_id().trim()		);
				System.out.println("[7,  bean.getCar_cd().trim()		]"+bean.getCar_cd().trim()			);
				System.out.println("[8,  bean.getCar_id().trim()		]"+bean.getCar_id().trim()			);
				System.out.println("[9,  bean.getCar_seq().trim()		]"+bean.getCar_seq().trim()			);
				System.out.println("[10, bean.getCar_amt()				]"+bean.getCar_amt()				);
				System.out.println("[11, bean.getOpt().trim()			]"+bean.getOpt().trim()				);
				System.out.println("[12, bean.getOpt_seq().trim()		]"+bean.getOpt_seq().trim()			);
				System.out.println("[13, bean.getOpt_amt()				]"+bean.getOpt_amt()				);
				System.out.println("[14, bean.getCol().trim()			]"+bean.getCol().trim()				);
				System.out.println("[15, bean.getCol_seq().trim()		]"+bean.getCol_seq().trim()			);
				System.out.println("[16, bean.getCol_amt()				]"+bean.getCol_amt()				);
				System.out.println("[17, bean.getDc().trim()			]"+bean.getDc().trim()				);
				System.out.println("[18, bean.getDc_seq().trim()		]"+bean.getDc_seq().trim()			);
				System.out.println("[19, bean.getDc_amt()				]"+bean.getDc_amt()					);
				System.out.println("[20, bean.getO_1()					]"+bean.getO_1()					);
				System.out.println("[21, bean.getA_a().trim()			]"+bean.getA_a().trim()				);
				System.out.println("[22, bean.getA_b().trim()			]"+bean.getA_b().trim()				);
				System.out.println("[23, bean.getA_h().trim()			]"+bean.getA_h().trim()				);
				System.out.println("[24, bean.getPp_st().trim()			]"+bean.getPp_st().trim()			);
				System.out.println("[25, bean.getPp_per()				]"+bean.getPp_per()					);
				System.out.println("[26, bean.getRg_8()					]"+bean.getRg_8()					);
				System.out.println("[27, bean.getIns_age().trim()		]"+bean.getIns_age().trim()			);
				System.out.println("[28, bean.getIns_dj().trim()		]"+bean.getIns_dj().trim()			);
				System.out.println("[29, bean.getRo_13()				]"+bean.getRo_13()					);
				System.out.println("[30, bean.getG_10()					]"+bean.getG_10()					);
				System.out.println("[31, bean.getGi_amt()				]"+bean.getGi_amt()					);
				System.out.println("[32, bean.getGi_fee()				]"+bean.getGi_fee()					);
				System.out.println("[33, bean.getGtr_amt()				]"+bean.getGtr_amt()				);
				System.out.println("[34, bean.getPp_s_amt()				]"+bean.getPp_s_amt()				);
				System.out.println("[35, bean.getPp_v_amt()				]"+bean.getPp_v_amt()				);
				System.out.println("[36, bean.getIfee_s_amt()			]"+bean.getIfee_s_amt()				);
				System.out.println("[37, bean.getIfee_v_amt()			]"+bean.getIfee_v_amt()				);
				System.out.println("[38, bean.getFee_s_amt()			]"+bean.getFee_s_amt()				);
				System.out.println("[39, bean.getFee_v_amt()			]"+bean.getFee_v_amt()				);
				System.out.println("[40, bean.getReg_id().trim()		]"+bean.getReg_id().trim()			);
				System.out.println("[41, bean.getReg_dt().trim()		]"+bean.getReg_dt().trim()			);
				System.out.println("[42, bean.getPp_amt()				]"+bean.getPp_amt()					);
				System.out.println("[43, bean.getIns_good().trim()		]"+bean.getIns_good().trim()		);
				System.out.println("[44, bean.getCar_ja()				]"+bean.getCar_ja()					);
				System.out.println("[45, bean.getLpg_yn().trim()		]"+bean.getLpg_yn().trim()			);
				System.out.println("[46, bean.getGi_yn().trim()			]"+bean.getGi_yn().trim()			);
				System.out.println("[47, bean.getRo_13_amt()			]"+bean.getRo_13_amt()				);
				System.out.println("[48, bean.getRg_8_amt()				]"+bean.getRg_8_amt()				);
				System.out.println("[49, bean.getFee_dc_per()			]"+bean.getFee_dc_per()				);
				System.out.println("[50, bean.getSpr_yn().trim()		]"+bean.getSpr_yn().trim()			);
				System.out.println("[51, bean.getRent_dt().trim()		]"+bean.getRent_dt().trim()			);
				System.out.println("[52, bean.getO_11()					]"+bean.getO_11()					);
				System.out.println("[53, bean.getLpg_kit().trim()		]"+bean.getLpg_kit().trim()			);
				System.out.println("[54, bean.getEst_st().trim()		]"+bean.getEst_st().trim()			);
				System.out.println("[55, bean.getEst_from().trim()		]"+bean.getEst_from().trim()		);
				System.out.println("[56, bean.getToday_dist()			]"+bean.getToday_dist()				);
				System.out.println("[57, bean.getMgr_nm().trim()		]"+bean.getMgr_nm().trim()			);
				System.out.println("[58, bean.getMgr_ssn().trim()		]"+bean.getMgr_ssn().trim()			);
				System.out.println("[59, bean.getO_13()					]"+bean.getO_13()					);
				System.out.println("[60, bean.getUdt_st().trim()		]"+bean.getUdt_st().trim()			);
				System.out.println("[61, bean.getAgree_dist()			]"+bean.getAgree_dist()				);
				System.out.println("[62, bean.getOver_run_amt()			]"+bean.getOver_run_amt()			);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                if(rs != null)		rs.close();
                if(stmt != null)	stmt.close();
                if(rs2 != null)		rs2.close();
                if(stmt2 != null)	stmt2.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
     * 견적서관리 등록.
     */
    public String insertEstimate2(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
    	Statement stmt2 = null;
        ResultSet rs2 = null;
        String query = "";
		String reg_dt = Util.getLoginTime();
        int count = 0;
		int id_chk = 0;

		String query3 = "select count(0) from estimate where est_id='"+bean.getEst_id()+"'";

		String query4 = " SELECT to_char(sysdate,'YYMM')||'"+bean.getEst_id().substring(4,5)+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001') ID"+
						" FROM ESTIMATE "+
						" where est_id like to_char(sysdate,'YYMM')||'"+bean.getEst_id().substring(4,5)+"%'"; 


        query = " INSERT INTO ESTIMATE"+
				" (est_id, est_nm, est_ssn, est_tel, est_fax, car_comp_id, car_cd, car_id, car_seq, car_amt,"+
				"  opt, opt_seq, opt_amt, col, col_seq, col_amt, dc, dc_seq, dc_amt, o_1,"+
				"  a_a, a_b, a_h, pp_st, pp_per, rg_8, ins_age, ins_dj, ro_13, g_10,"+
				"  gi_amt, gi_fee, gtr_amt, pp_s_amt, pp_v_amt, ifee_s_amt, ifee_v_amt, fee_s_amt, fee_v_amt, reg_id,"+
				"  reg_dt, pp_amt, ins_good, car_ja, lpg_yn, gi_yn, ro_13_amt, rg_8_amt, fee_dc_per, spr_yn, "+
				"  rent_dt, o_11, lpg_kit, est_st, est_from, today_dist, mgr_nm, mgr_ssn, udt_st, agree_dist, over_run_amt, doc_type, vali_type, est_type, b_agree_dist, b_o_13, loc_st, "+
				"  tint_b_yn, tint_s_yn, tint_n_yn, cha_st_dt, b_dist, jg_opt_st, jg_col_st, "+
				"  tax_dc_amt, ecar_loc_st, eco_e_tag, ecar_pur_sub_amt, ecar_pur_sub_st, jg_tuix_st, jg_tuix_opt_st, "+
				"  damdang_nm, damdang_m_tel, bus_st, tint_eb_yn, return_select, hcar_loc_st, "+
				"  lkas_yn, ldws_yn, aeb_yn, fcw_yn, hook_yn, tint_bn_yn, new_license_plate, tint_cons_yn, tint_cons_amt, rtn_run_amt )"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
			    "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"	?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "+
				" )";
           

	   try{
		   con.setAutoCommit(false);


            //est_id 체크
            stmt = con.createStatement();
            rs = stmt.executeQuery(query3);
            if(rs.next())
            	id_chk = rs.getInt(1);
            rs.close();
      		stmt.close();

			if(id_chk > 0){
	            //est_id 생성
		        stmt2 = con.createStatement();
			    rs2 = stmt2.executeQuery(query4);
	            if(rs2.next()){
		        	bean.setEst_id(rs2.getString(1)==null?"":rs2.getString(1));
				}
				System.out.println("[EstiDatabase:insertEstimate2=중복체크 est_id 생성]"+rs2.getString(1));
				rs2.close();
      			stmt2.close();
			}

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getEst_id().trim());
            pstmt.setString(2, bean.getEst_nm().trim());
            pstmt.setString(3, bean.getEst_ssn().trim());
            pstmt.setString(4, bean.getEst_tel().trim());
            pstmt.setString(5, bean.getEst_fax().trim());
            pstmt.setString(6, bean.getCar_comp_id().trim());
            pstmt.setString(7, bean.getCar_cd().trim());
            pstmt.setString(8, bean.getCar_id().trim());
            pstmt.setString(9, bean.getCar_seq().trim());
            pstmt.setInt   (10, bean.getCar_amt());
            pstmt.setString(11, bean.getOpt().trim());
            pstmt.setString(12, bean.getOpt_seq().trim());
            pstmt.setInt   (13, bean.getOpt_amt());
            pstmt.setString(14, bean.getCol().trim());
            pstmt.setString(15, bean.getCol_seq().trim());
            pstmt.setInt   (16, bean.getCol_amt());
            pstmt.setString(17, bean.getDc().trim());
            pstmt.setString(18, bean.getDc_seq().trim());
            pstmt.setInt   (19, bean.getDc_amt());
            pstmt.setInt   (20, bean.getO_1());
            pstmt.setString(21, bean.getA_a().trim());
            pstmt.setString(22, bean.getA_b().trim());
            pstmt.setString(23, bean.getA_h().trim());
            pstmt.setString(24, bean.getPp_st().trim());
            pstmt.setFloat (25, bean.getPp_per());
            pstmt.setFloat (26, bean.getRg_8());
            pstmt.setString(27, bean.getIns_age().trim());
            pstmt.setString(28, bean.getIns_dj().trim());
            pstmt.setFloat (29, bean.getRo_13());
			pstmt.setInt   (30, bean.getG_10());
            pstmt.setInt   (31, bean.getGi_amt());
            pstmt.setInt   (32, bean.getGi_fee());
            pstmt.setInt   (33, bean.getGtr_amt());
            pstmt.setInt   (34, bean.getPp_s_amt());
			pstmt.setInt   (35, bean.getPp_v_amt());
            pstmt.setInt   (36, bean.getIfee_s_amt());
            pstmt.setInt   (37, bean.getIfee_v_amt());
            pstmt.setInt   (38, bean.getFee_s_amt());
            pstmt.setInt   (39, bean.getFee_v_amt());
            pstmt.setString(40, bean.getReg_id().trim());
			if(bean.getReg_dt().equals("")){
	            pstmt.setString(41, reg_dt.substring(0,12));		
				bean.setReg_dt(reg_dt.substring(0,12));
			}else{
	            pstmt.setString(41, bean.getReg_dt().substring(0,12));
			}
            pstmt.setInt   (42, bean.getPp_amt());
			pstmt.setString(43, bean.getIns_good().trim());
            pstmt.setInt   (44, bean.getCar_ja());
			pstmt.setString(45, bean.getLpg_yn().trim());
			pstmt.setString(46, bean.getGi_yn().trim());
            pstmt.setInt   (47, bean.getRo_13_amt());
            pstmt.setInt   (48, bean.getRg_8_amt());
            pstmt.setFloat (49, bean.getFee_dc_per());
			pstmt.setString(50, bean.getSpr_yn().trim());
			if(bean.getRent_dt().equals("")){			
				pstmt.setString(51, bean.getReg_dt().substring(0,8));
			}else{
				pstmt.setString(51, bean.getRent_dt().trim());
			}
            pstmt.setFloat (52, bean.getO_11());
			pstmt.setString(53, bean.getLpg_kit().trim());
            pstmt.setString(54, bean.getEst_st().trim());
            pstmt.setString(55, bean.getEst_from().trim());
            pstmt.setInt   (56, bean.getToday_dist());
            pstmt.setString(57, bean.getMgr_nm().trim());
            pstmt.setString(58, bean.getMgr_ssn().trim());
            pstmt.setString(59, bean.getUdt_st().trim());
            pstmt.setInt   (60, bean.getAgree_dist());
            pstmt.setInt   (61, bean.getOver_run_amt());
            pstmt.setString(62, bean.getDoc_type().trim()	);
			pstmt.setString(63, bean.getVali_type().trim()	);
			pstmt.setString(64, bean.getEst_type().trim());
			pstmt.setInt   (65, bean.getB_agree_dist()		);
			pstmt.setFloat (66, bean.getB_o_13()			);
			pstmt.setString(67, bean.getLoc_st().trim()		);
			pstmt.setString(68, bean.getTint_b_yn().trim()	);
			pstmt.setString(69, bean.getTint_s_yn().trim()	);
			pstmt.setString(70, bean.getTint_n_yn().trim()	);
            pstmt.setString(71, bean.getCha_st_dt().trim()	);
            pstmt.setInt   (72, bean.getB_dist			());
            pstmt.setString(73, bean.getJg_opt_st().trim()	);
			pstmt.setString(74, bean.getJg_col_st().trim()	);
			pstmt.setInt   (75, bean.getTax_dc_amt()		);
			pstmt.setString(76, bean.getEcar_loc_st().trim());
			pstmt.setString(77, bean.getEco_e_tag().trim());
			pstmt.setInt   (78, bean.getEcar_pur_sub_amt()	);
			pstmt.setString(79, bean.getEcar_pur_sub_st().trim());
			pstmt.setString(80, bean.getJg_tuix_st().trim()	);
			pstmt.setString(81, bean.getJg_tuix_opt_st().trim()	);
			pstmt.setString(82,bean.getDamdang_nm()	   );
			pstmt.setString(83,bean.getDamdang_m_tel()	   );
			pstmt.setString(84,bean.getBus_st()		   );
			pstmt.setString(85, bean.getTint_eb_yn().trim()	);
			pstmt.setString(86, bean.getReturn_select().trim());
			pstmt.setString(87, bean.getHcar_loc_st().trim());
			pstmt.setString(88, bean.getLkas_yn()   	    );
			pstmt.setString(89, bean.getLdws_yn()  		    );
			pstmt.setString(90, bean.getAeb_yn()   		    );
			pstmt.setString(91, bean.getFcw_yn()   		    );
			pstmt.setString(92, bean.getHook_yn() 		    );
			pstmt.setString(93, bean.getTint_bn_yn().trim()   		    );
			pstmt.setString(94, bean.getNew_license_plate().trim());
			pstmt.setString(95, bean.getTint_cons_yn().trim());
			pstmt.setInt   (96, bean.getTint_cons_amt()	);
			pstmt.setInt   (97, bean.getRtn_run_amt());

			count = pstmt.executeUpdate();
            
            pstmt.close();
			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstimate2]"+se);
				System.out.println("[bean.getEst_id		()]"+bean.getEst_id		());
				System.out.println("[bean.getReg_id		()]"+bean.getReg_id		());
				System.out.println("[bean.getMgr_nm		()]"+bean.getMgr_nm		());
				System.out.println("[bean.getMgr_ssn	()]"+bean.getMgr_ssn	());
				System.out.println("[bean.getEst_from	()]"+bean.getEst_from	());
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                if(rs != null)		rs.close();
                if(stmt != null)	stmt.close();
                if(rs2 != null)		rs2.close();
                if(stmt2 != null)	stmt2.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean.getEst_id();
    }

	/**
     * 견적서관리 등록.
     */
    public String insertEstimate2Sh(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
    	Statement stmt2 = null;
        ResultSet rs2 = null;
        String query = "";
		String reg_dt = Util.getLoginTime();
        int count = 0;
		int id_chk = 0;

		String query3 = "select count(0) from estimate_sh where est_id='"+bean.getEst_id()+"'";

		String query4 = " SELECT to_char(sysdate,'YYMM')||'"+bean.getEst_id().substring(4,5)+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001') ID"+
						" FROM estimate_sh "+
						" where est_id like to_char(sysdate,'YYMM')||'%' and est_id like '%"+bean.getEst_id().substring(4,5)+"%'";


        query = " INSERT INTO estimate_sh"+
				" (est_id, est_nm, est_ssn, est_tel, est_fax, car_comp_id, car_cd, car_id, car_seq, car_amt,"+
				"  opt, opt_seq, opt_amt, col, col_seq, col_amt, dc, dc_seq, dc_amt, o_1,"+
				"  a_a, a_b, a_h, pp_st, pp_per, rg_8, ins_age, ins_dj, ro_13, g_10,"+
				"  gi_amt, gi_fee, gtr_amt, pp_s_amt, pp_v_amt, ifee_s_amt, ifee_v_amt, fee_s_amt, fee_v_amt, reg_id,"+
				"  reg_dt, pp_amt, ins_good, car_ja, lpg_yn, gi_yn, ro_13_amt, rg_8_amt, fee_dc_per, spr_yn, "+
				"  rent_dt, o_11, lpg_kit, est_st, est_from, today_dist, mgr_nm, mgr_ssn, udt_st, agree_dist, over_run_amt, doc_type, vali_type, est_type, b_agree_dist, b_o_13, loc_st, "+
				"  tint_b_yn, tint_s_yn, tint_n_yn, cha_st_dt, b_dist, jg_opt_st, jg_col_st, "+
				"  tax_dc_amt, ecar_loc_st, eco_e_tag, ecar_pur_sub_amt, ecar_pur_sub_st, jg_tuix_st, jg_tuix_opt_st, tint_eb_yn, return_select, hcar_loc_st, "+
				"  lkas_yn, ldws_yn, aeb_yn, fcw_yn, hook_yn, tint_bn_yn, new_license_plate, tint_cons_yn, tint_cons_amt, rtn_run_amt )"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
			    "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"	?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
			    "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )";
           

	   try{
		   con.setAutoCommit(false);


            //est_id 체크
            stmt = con.createStatement();
            rs = stmt.executeQuery(query3);
            if(rs.next())
            	id_chk = rs.getInt(1);
            rs.close();
      		stmt.close();

			if(id_chk > 0){
	            //est_id 생성
		        stmt2 = con.createStatement();
			    rs2 = stmt2.executeQuery(query4);
	            if(rs2.next()){
		        	bean.setEst_id(rs2.getString(1)==null?"":rs2.getString(1));
				}
				System.out.println("[EstiDatabase:insertEstimate2Sh=중복체크 est_id 생성]"+rs2.getString(1));
				rs2.close();
      			stmt2.close();
			}

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getEst_id().trim());
            pstmt.setString(2, bean.getEst_nm().trim());
            pstmt.setString(3, bean.getEst_ssn().trim());
            pstmt.setString(4, bean.getEst_tel().trim());
            pstmt.setString(5, bean.getEst_fax().trim());
            pstmt.setString(6, bean.getCar_comp_id().trim());
            pstmt.setString(7, bean.getCar_cd().trim());
            pstmt.setString(8, bean.getCar_id().trim());
            pstmt.setString(9, bean.getCar_seq().trim());
            pstmt.setInt   (10, bean.getCar_amt());
            pstmt.setString(11, bean.getOpt().trim());
            pstmt.setString(12, bean.getOpt_seq().trim());
            pstmt.setInt   (13, bean.getOpt_amt());
            pstmt.setString(14, bean.getCol().trim());
            pstmt.setString(15, bean.getCol_seq().trim());
            pstmt.setInt   (16, bean.getCol_amt());
            pstmt.setString(17, bean.getDc().trim());
            pstmt.setString(18, bean.getDc_seq().trim());
            pstmt.setInt   (19, bean.getDc_amt());
            pstmt.setInt   (20, bean.getO_1());
            pstmt.setString(21, bean.getA_a().trim());
            pstmt.setString(22, bean.getA_b().trim());
            pstmt.setString(23, bean.getA_h().trim());
            pstmt.setString(24, bean.getPp_st().trim());
            pstmt.setFloat (25, bean.getPp_per());
            pstmt.setFloat (26, bean.getRg_8());
            pstmt.setString(27, bean.getIns_age().trim());
            pstmt.setString(28, bean.getIns_dj().trim());
            pstmt.setFloat (29, bean.getRo_13());
			pstmt.setInt   (30, bean.getG_10());
            pstmt.setInt   (31, bean.getGi_amt());
            pstmt.setInt   (32, bean.getGi_fee());
            pstmt.setInt   (33, bean.getGtr_amt());
            pstmt.setInt   (34, bean.getPp_s_amt());
			pstmt.setInt   (35, bean.getPp_v_amt());
            pstmt.setInt   (36, bean.getIfee_s_amt());
            pstmt.setInt   (37, bean.getIfee_v_amt());
            pstmt.setInt   (38, bean.getFee_s_amt());
            pstmt.setInt   (39, bean.getFee_v_amt());
            pstmt.setString(40, bean.getReg_id().trim());
			if(bean.getReg_dt().equals("")){
	            pstmt.setString(41, reg_dt.substring(0,12));		
				bean.setReg_dt(reg_dt.substring(0,12));
			}else{
	            pstmt.setString(41, bean.getReg_dt().substring(0,12));
			}
            pstmt.setInt   (42, bean.getPp_amt());
			pstmt.setString(43, bean.getIns_good().trim());
            pstmt.setInt   (44, bean.getCar_ja());
			pstmt.setString(45, bean.getLpg_yn().trim());
			pstmt.setString(46, bean.getGi_yn().trim());
            pstmt.setInt   (47, bean.getRo_13_amt());
            pstmt.setInt   (48, bean.getRg_8_amt());
            pstmt.setFloat (49, bean.getFee_dc_per());
			pstmt.setString(50, bean.getSpr_yn().trim());
			if(bean.getRent_dt().equals("")){			
				pstmt.setString(51, bean.getReg_dt().substring(0,8));
			}else{
				pstmt.setString(51, bean.getRent_dt().trim());
			}
            pstmt.setFloat (52, bean.getO_11());
			pstmt.setString(53, bean.getLpg_kit().trim());
            pstmt.setString(54, bean.getEst_st().trim());
            pstmt.setString(55, bean.getEst_from().trim());
            pstmt.setInt   (56, bean.getToday_dist());
            pstmt.setString(57, bean.getMgr_nm().trim());
            pstmt.setString(58, bean.getMgr_ssn().trim());
            pstmt.setString(59, bean.getUdt_st().trim());
            pstmt.setInt   (60, bean.getAgree_dist());
            pstmt.setInt   (61, bean.getOver_run_amt());
            pstmt.setString(62, bean.getDoc_type().trim()	);
			pstmt.setString(63, bean.getVali_type().trim()	);
			pstmt.setString(64, bean.getEst_type().trim());
			pstmt.setInt   (65, bean.getB_agree_dist()		);
			pstmt.setFloat (66, bean.getB_o_13()			);
			pstmt.setString(67, bean.getLoc_st().trim()		);
			pstmt.setString(68, bean.getTint_b_yn().trim()	);
			pstmt.setString(69, bean.getTint_s_yn().trim()	);
			pstmt.setString(70, bean.getTint_n_yn().trim()	);
			pstmt.setString(71, bean.getCha_st_dt().trim());
			pstmt.setInt   (72, bean.getB_dist()		);
			pstmt.setString(73, bean.getJg_opt_st().trim());
			pstmt.setString(74, bean.getJg_col_st().trim());
			pstmt.setInt   (75, bean.getTax_dc_amt()		);
			pstmt.setString(76, bean.getEcar_loc_st().trim());
			pstmt.setString(77, bean.getEco_e_tag().trim());
			pstmt.setInt   (78, bean.getEcar_pur_sub_amt()	);
			pstmt.setString(79, bean.getEcar_pur_sub_st().trim());
			pstmt.setString(80, bean.getJg_tuix_st().trim());
			pstmt.setString(81, bean.getJg_tuix_opt_st().trim());
			pstmt.setString(82, bean.getTint_eb_yn().trim()	);
			pstmt.setString(83, bean.getReturn_select().trim());
			pstmt.setString(84, bean.getHcar_loc_st().trim());
			pstmt.setString(85, bean.getLkas_yn()   	    );
			pstmt.setString(86, bean.getLdws_yn()  		);
			pstmt.setString(87, bean.getAeb_yn()   		    );
			pstmt.setString(88, bean.getFcw_yn()   		    );
			pstmt.setString(89, bean.getHook_yn()   		);
			pstmt.setString(90, bean.getTint_bn_yn().trim()   	    );
			pstmt.setString(91, bean.getNew_license_plate().trim());
			pstmt.setString(92, bean.getTint_cons_yn().trim());
			pstmt.setInt   (93, bean.getTint_cons_amt()	);
			pstmt.setInt   (94, bean.getRtn_run_amt());

			count = pstmt.executeUpdate();
            
            pstmt.close();
			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstimate2Sh]"+se);
				System.out.println("[bean.getEst_id		()]"+bean.getEst_id		());
				System.out.println("[bean.getReg_id		()]"+bean.getReg_id		());
				System.out.println("[bean.getMgr_nm		()]"+bean.getMgr_nm		());
				System.out.println("[bean.getMgr_ssn	()]"+bean.getMgr_ssn	());
				System.out.println("[bean.getEst_from	()]"+bean.getEst_from	());
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                if(rs != null)		rs.close();
                if(stmt != null)	stmt.close();
                if(rs2 != null)		rs2.close();
                if(stmt2 != null)	stmt2.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean.getEst_id();
    }


    /**
     * 견적관리 수정.
     */
    public int updateEstimate(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE ESTIMATE SET"+
				"  est_nm=?, est_ssn=?, est_tel=?, est_fax=?, car_comp_id=?, car_cd=?, car_id=?, car_seq=?, car_amt=?,"+
				"  opt=?, opt_seq=?, opt_amt=?, col=?, col_seq=?, col_amt=?, dc=?, dc_seq=?, dc_amt=?, o_1=?,"+
				"  a_a=?, a_b=?, a_h=?, pp_st=?, pp_per=?, rg_8=?, ins_age=?, ins_dj=?, ro_13=?, g_10=?,"+
				"  gi_amt=?, gi_fee=?, gtr_amt=?, pp_s_amt=?, pp_v_amt=?, ifee_s_amt=?, ifee_v_amt=?, fee_s_amt=?, fee_v_amt=?, update_id=?,"+
				"  update_dt=to_char(sysdate,'YYYYMMDD'), pp_amt=?, ins_good=?, car_ja=?, lpg_yn=?, gi_yn=?, ro_13_amt=?, rg_8_amt=?,"+
				"  talk_tel=?, fee_dc_per=?, spr_yn=?, mgr_nm=?, mgr_ssn=?, job=?, o_13=?, over_run_amt=?, udt_st=?, reg_id=?, "+
				"  doc_type=?, vali_type=?, opt_chk=?, cls_per=?, est_email=?, caroff_emp_yn=?, ctr_s_amt=?, ctr_v_amt=?, compare_yn=?, "+
				"  agree_dist=?, ctr_cls_per=?, pp_ment_yn=?, tot_dt=replace(?,'-',''), damdang_nm=?, damdang_m_tel=?, bus_st=?, com_emp_yn=?, dir_pur_commi_yn=?, gi_grade=?, info_st=?, rtn_run_amt=? "+
				" WHERE est_id=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  

            pstmt.setString(1, bean.getEst_nm().trim());
            pstmt.setString(2, bean.getEst_ssn().trim());
            pstmt.setString(3, bean.getEst_tel().trim());
            pstmt.setString(4, bean.getEst_fax().trim());
            pstmt.setString(5, bean.getCar_comp_id().trim());
            pstmt.setString(6, bean.getCar_cd().trim());
            pstmt.setString(7, bean.getCar_id().trim());
            pstmt.setString(8, bean.getCar_seq().trim());
            pstmt.setInt   (9, bean.getCar_amt());
            pstmt.setString(10, bean.getOpt().trim());
            pstmt.setString(11, bean.getOpt_seq().trim());
            pstmt.setInt   (12, bean.getOpt_amt());
            pstmt.setString(13, bean.getCol().trim());
            pstmt.setString(14, bean.getCol_seq().trim());
            pstmt.setInt   (15, bean.getCol_amt());
            pstmt.setString(16, bean.getDc().trim());
            pstmt.setString(17, bean.getDc_seq().trim());
            pstmt.setInt   (18, bean.getDc_amt());
            pstmt.setInt   (19, bean.getO_1());
            pstmt.setString(20, bean.getA_a().trim());
            pstmt.setString(21, bean.getA_b().trim());
            pstmt.setString(22, bean.getA_h().trim());
            pstmt.setString(23, bean.getPp_st().trim());
            pstmt.setFloat (24, bean.getPp_per());
            pstmt.setFloat (25, bean.getRg_8());
            pstmt.setString(26, bean.getIns_age().trim());
            pstmt.setString(27, bean.getIns_dj().trim());
            pstmt.setFloat (28, bean.getRo_13());
			pstmt.setInt   (29, bean.getG_10());
            pstmt.setInt   (30, bean.getGi_amt());
            pstmt.setInt   (31, bean.getGi_fee());
            pstmt.setInt   (32, bean.getGtr_amt());
            pstmt.setInt   (33, bean.getPp_s_amt());
			pstmt.setInt   (34, bean.getPp_v_amt());
            pstmt.setInt   (35, bean.getIfee_s_amt());
            pstmt.setInt   (36, bean.getIfee_v_amt());
            pstmt.setInt   (37, bean.getFee_s_amt());
            pstmt.setInt   (38, bean.getFee_v_amt());
            pstmt.setString(39, bean.getUpdate_id().trim());
            pstmt.setInt   (40, bean.getPp_amt());
            pstmt.setString(41, bean.getIns_good().trim());
            pstmt.setInt   (42, bean.getCar_ja());
            pstmt.setString(43, bean.getLpg_yn().trim());
            pstmt.setString(44, bean.getGi_yn().trim());
            pstmt.setInt   (45, bean.getRo_13_amt());
            pstmt.setInt   (46, bean.getRg_8_amt());
            pstmt.setString(47, bean.getTalk_tel().trim());
            pstmt.setFloat (48, bean.getFee_dc_per());
            pstmt.setString(49, bean.getSpr_yn().trim());
            pstmt.setString(50, bean.getMgr_nm().trim());
            pstmt.setString(51, bean.getMgr_ssn().trim());
            pstmt.setString(52, bean.getJob().trim());
            pstmt.setFloat (53, bean.getO_13());
            pstmt.setInt   (54, bean.getOver_run_amt());
            pstmt.setString(55, bean.getUdt_st().trim());
            pstmt.setString(56, bean.getReg_id().trim());
			pstmt.setString(57, bean.getDoc_type().trim());
			pstmt.setString(58, bean.getVali_type().trim());
			pstmt.setString(59, bean.getOpt_chk().trim());
            pstmt.setFloat (60, bean.getCls_per());
			pstmt.setString(61, bean.getEst_email().trim());
			pstmt.setString(62, bean.getCaroff_emp_yn().trim());
            pstmt.setInt   (63, bean.getCtr_s_amt());
			pstmt.setInt   (64, bean.getCtr_v_amt());
			pstmt.setString(65, bean.getCompare_yn().trim());
			pstmt.setInt   (66, bean.getAgree_dist());
			pstmt.setFloat (67, bean.getCtr_cls_per());
			pstmt.setString(68, bean.getPp_ment_yn().trim());
			pstmt.setString(69, bean.getTot_dt().trim());
			pstmt.setString(70, bean.getDamdang_nm()	   );
			pstmt.setString(71, bean.getDamdang_m_tel() );
			pstmt.setString(72, bean.getBus_st()		   );
			pstmt.setString(73, bean.getCom_emp_yn()		   );
			pstmt.setString(74, bean.getDir_pur_commi_yn()		   );
			pstmt.setString(75, bean.getGi_grade()		   );
			pstmt.setString(76, bean.getInfo_st()		   );
			pstmt.setInt   (77, bean.getRtn_run_amt());
            pstmt.setString(78, bean.getEst_id().trim());
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateEstimate]"+se);
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

    /**
     * 견적관리 수정.
     */
    public int updateEstimateHp(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE ESTIMATE_HP SET"+
				"  est_nm=?, est_ssn=?, est_tel=?, est_fax=?, car_comp_id=?, car_cd=?, car_id=?, car_seq=?, car_amt=?,"+
				"  opt=?, opt_seq=?, opt_amt=?, col=?, col_seq=?, col_amt=?, dc=?, dc_seq=?, dc_amt=?, o_1=?,"+
				"  a_a=?, a_b=?, a_h=?, pp_st=?, pp_per=?, rg_8=?, ins_age=?, ins_dj=?, ro_13=?, g_10=?,"+
				"  gi_amt=?, gi_fee=?, gtr_amt=?, pp_s_amt=?, pp_v_amt=?, ifee_s_amt=?, ifee_v_amt=?, fee_s_amt=?, fee_v_amt=?, update_id=?,"+
				"  update_dt=to_char(sysdate,'YYYYMMDD'), pp_amt=?, ins_good=?, car_ja=?, lpg_yn=?, gi_yn=?, ro_13_amt=?, rg_8_amt=?,"+
				"  talk_tel=?, fee_dc_per=?, spr_yn=?, mgr_nm=?, mgr_ssn=?, job=?, o_13=?, over_run_amt=?, udt_st=?, reg_id=?, doc_type=?, vali_type=?, rtn_run_amt=?"+
				" WHERE est_id=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  

            pstmt.setString(1, bean.getEst_nm().trim());
            pstmt.setString(2, bean.getEst_ssn().trim());
            pstmt.setString(3, bean.getEst_tel().trim());
            pstmt.setString(4, bean.getEst_fax().trim());
            pstmt.setString(5, bean.getCar_comp_id().trim());
            pstmt.setString(6, bean.getCar_cd().trim());
            pstmt.setString(7, bean.getCar_id().trim());
            pstmt.setString(8, bean.getCar_seq().trim());
            pstmt.setInt   (9, bean.getCar_amt());
            pstmt.setString(10, bean.getOpt().trim());
            pstmt.setString(11, bean.getOpt_seq().trim());
            pstmt.setInt   (12, bean.getOpt_amt());
            pstmt.setString(13, bean.getCol().trim());
            pstmt.setString(14, bean.getCol_seq().trim());
            pstmt.setInt   (15, bean.getCol_amt());
            pstmt.setString(16, bean.getDc().trim());
            pstmt.setString(17, bean.getDc_seq().trim());
            pstmt.setInt   (18, bean.getDc_amt());
            pstmt.setInt   (19, bean.getO_1());
            pstmt.setString(20, bean.getA_a().trim());
            pstmt.setString(21, bean.getA_b().trim());
            pstmt.setString(22, bean.getA_h().trim());
            pstmt.setString(23, bean.getPp_st().trim());
            pstmt.setFloat (24, bean.getPp_per());
            pstmt.setFloat (25, bean.getRg_8());
            pstmt.setString(26, bean.getIns_age().trim());
            pstmt.setString(27, bean.getIns_dj().trim());
            pstmt.setFloat (28, bean.getRo_13());
			pstmt.setInt   (29, bean.getG_10());
            pstmt.setInt   (30, bean.getGi_amt());
            pstmt.setInt   (31, bean.getGi_fee());
            pstmt.setInt   (32, bean.getGtr_amt());
            pstmt.setInt   (33, bean.getPp_s_amt());
			pstmt.setInt   (34, bean.getPp_v_amt());
            pstmt.setInt   (35, bean.getIfee_s_amt());
            pstmt.setInt   (36, bean.getIfee_v_amt());
            pstmt.setInt   (37, bean.getFee_s_amt());
            pstmt.setInt   (38, bean.getFee_v_amt());
            pstmt.setString(39, bean.getReg_id().trim());
            pstmt.setInt   (40, bean.getPp_amt());
            pstmt.setString(41, bean.getIns_good().trim());
            pstmt.setInt   (42, bean.getCar_ja());
            pstmt.setString(43, bean.getLpg_yn().trim());
            pstmt.setString(44, bean.getGi_yn().trim());
            pstmt.setInt   (45, bean.getRo_13_amt());
            pstmt.setInt   (46, bean.getRg_8_amt());
            pstmt.setString(47, bean.getTalk_tel().trim());
            pstmt.setFloat (48, bean.getFee_dc_per());
            pstmt.setString(49, bean.getSpr_yn().trim());
            pstmt.setString(50, bean.getMgr_nm().trim());
            pstmt.setString(51, bean.getMgr_ssn().trim());
            pstmt.setString(52, bean.getJob().trim());
            pstmt.setFloat (53, bean.getO_13());
            pstmt.setInt   (54, bean.getOver_run_amt());
            pstmt.setString(55, bean.getUdt_st().trim());
            pstmt.setString(56, bean.getReg_id().trim());
			pstmt.setString(57, bean.getDoc_type().trim());
			pstmt.setString(58, bean.getVali_type().trim());
			pstmt.setInt   (59, bean.getRtn_run_amt());
            pstmt.setString(60, bean.getEst_id().trim());
            

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateEstimateHp]"+se);
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

    /**
     * 견적관리 수정.
     */
    public int updateEstimateSh(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE ESTIMATE_SH SET"+
				"  est_nm=?, est_ssn=?, est_tel=?, est_fax=?, car_comp_id=?, car_cd=?, car_id=?, car_seq=?, car_amt=?,"+
				"  opt=?, opt_seq=?, opt_amt=?, col=?, col_seq=?, col_amt=?, dc=?, dc_seq=?, dc_amt=?, o_1=?,"+
				"  a_a=?, a_b=?, a_h=?, pp_st=?, pp_per=?, rg_8=?, ins_age=?, ins_dj=?, ro_13=?, g_10=?,"+
				"  gi_amt=?, gi_fee=?, gtr_amt=?, pp_s_amt=?, pp_v_amt=?, ifee_s_amt=?, ifee_v_amt=?, fee_s_amt=?, fee_v_amt=?, update_id=?,"+
				"  update_dt=to_char(sysdate,'YYYYMMDD'), pp_amt=?, ins_good=?, car_ja=?, lpg_yn=?, gi_yn=?, ro_13_amt=?, rg_8_amt=?,"+
				"  talk_tel=?, fee_dc_per=?, spr_yn=?, mgr_nm=?, mgr_ssn=?, job=?, o_13=?, over_run_amt=?, udt_st=?, reg_id=?, doc_type=?, vali_type=?, rtn_run_amt=? "+
				" WHERE est_id=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  

            pstmt.setString(1, bean.getEst_nm().trim());
            pstmt.setString(2, bean.getEst_ssn().trim());
            pstmt.setString(3, bean.getEst_tel().trim());
            pstmt.setString(4, bean.getEst_fax().trim());
            pstmt.setString(5, bean.getCar_comp_id().trim());
            pstmt.setString(6, bean.getCar_cd().trim());
            pstmt.setString(7, bean.getCar_id().trim());
            pstmt.setString(8, bean.getCar_seq().trim());
            pstmt.setInt   (9, bean.getCar_amt());
            pstmt.setString(10, bean.getOpt().trim());
            pstmt.setString(11, bean.getOpt_seq().trim());
            pstmt.setInt   (12, bean.getOpt_amt());
            pstmt.setString(13, bean.getCol().trim());
            pstmt.setString(14, bean.getCol_seq().trim());
            pstmt.setInt   (15, bean.getCol_amt());
            pstmt.setString(16, bean.getDc().trim());
            pstmt.setString(17, bean.getDc_seq().trim());
            pstmt.setInt   (18, bean.getDc_amt());
            pstmt.setInt   (19, bean.getO_1());
            pstmt.setString(20, bean.getA_a().trim());
            pstmt.setString(21, bean.getA_b().trim());
            pstmt.setString(22, bean.getA_h().trim());
            pstmt.setString(23, bean.getPp_st().trim());
            pstmt.setFloat (24, bean.getPp_per());
            pstmt.setFloat (25, bean.getRg_8());
            pstmt.setString(26, bean.getIns_age().trim());
            pstmt.setString(27, bean.getIns_dj().trim());
            pstmt.setFloat (28, bean.getRo_13());
			pstmt.setInt   (29, bean.getG_10());
            pstmt.setInt   (30, bean.getGi_amt());
            pstmt.setInt   (31, bean.getGi_fee());
            pstmt.setInt   (32, bean.getGtr_amt());
            pstmt.setInt   (33, bean.getPp_s_amt());
			pstmt.setInt   (34, bean.getPp_v_amt());
            pstmt.setInt   (35, bean.getIfee_s_amt());
            pstmt.setInt   (36, bean.getIfee_v_amt());
            pstmt.setInt   (37, bean.getFee_s_amt());
            pstmt.setInt   (38, bean.getFee_v_amt());
            pstmt.setString(39, bean.getReg_id().trim());
            pstmt.setInt   (40, bean.getPp_amt());
            pstmt.setString(41, bean.getIns_good().trim());
            pstmt.setInt   (42, bean.getCar_ja());
            pstmt.setString(43, bean.getLpg_yn().trim());
            pstmt.setString(44, bean.getGi_yn().trim());
            pstmt.setInt   (45, bean.getRo_13_amt());
            pstmt.setInt   (46, bean.getRg_8_amt());
            pstmt.setString(47, bean.getTalk_tel().trim());
            pstmt.setFloat (48, bean.getFee_dc_per());
            pstmt.setString(49, bean.getSpr_yn().trim());
            pstmt.setString(50, bean.getMgr_nm().trim());
            pstmt.setString(51, bean.getMgr_ssn().trim());
            pstmt.setString(52, bean.getJob().trim());
            pstmt.setFloat (53, bean.getO_13());
            pstmt.setInt   (54, bean.getOver_run_amt());
            pstmt.setString(55, bean.getUdt_st().trim());
            pstmt.setString(56, bean.getReg_id().trim());
			pstmt.setString(57, bean.getDoc_type().trim());
			pstmt.setString(58, bean.getVali_type().trim());
			pstmt.setInt   (59, bean.getOver_run_amt());
            pstmt.setString(60, bean.getEst_id().trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateEstimateSh]"+se);
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

    /**
     * 견적관리 삭제.
     */
    public int deleteEstimate(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                

		query = " update ESTIMATE set use_yn='N' WHERE est_id=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            pstmt.setString(1, bean.getEst_id().trim());
            count = pstmt.executeUpdate();             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:deleteEstimate]"+se);
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

    /**
     * 견적관리 삭제.
     */
    public int deleteEstimateHp(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " DELETE FROM ESTIMATE_HP WHERE est_id=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            pstmt.setString(1, bean.getEst_id().trim());
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:deleteEstimateHp]"+se);
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


	//공통변수관리----------------------------------------------------------------------------------------------------------------


    /**
     * 공통변수 전체조회
     */
    public EstiCommVarBean [] getEstiCommVarList(String gubun1, String gubun2, String gubun3) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from esti_comm_var where a_a='"+gubun1+"'";
		query += " order by a_j desc";

        Collection<EstiCommVarBean> col = new ArrayList<EstiCommVarBean>();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstiCommVarBean bean = new EstiCommVarBean();
				bean.setA_a(rs.getString("A_A"));
			    bean.setSeq(rs.getString("SEQ"));
			    bean.setA_f(rs.getFloat("A_F"));
			    bean.setA_g_1(rs.getInt("A_G_1"));
				bean.setA_g_2(rs.getInt("A_G_2"));
			    bean.setA_g_3(rs.getInt("A_G_3"));
			    bean.setA_g_4(rs.getInt("A_G_4"));
			    bean.setA_j(rs.getString("A_J"));
			    bean.setO_8_1(rs.getFloat("O_8_1"));
				bean.setO_8_2(rs.getFloat("O_8_2"));
			    bean.setO_9_1(rs.getInt("O_9_1"));
			    bean.setO_9_2(rs.getInt("O_9_2"));
			    bean.setO_10(rs.getFloat("O_10"));
				bean.setO_12(rs.getFloat("O_12"));
				bean.setO_e(rs.getString("O_E"));
			    bean.setOa_b(rs.getInt("OA_B"));
	   			bean.setOa_c(rs.getFloat("OA_C"));
				bean.setG_1(rs.getInt("G_1"));
	   			bean.setG_3(rs.getFloat("G_3"));
	   			bean.setG_5(rs.getFloat("G_5"));
	   			bean.setG_8(rs.getFloat("G_8"));
	   			bean.setG_9_1(rs.getFloat("G_9_1"));
	   			bean.setG_9_2(rs.getFloat("G_9_2"));
	   			bean.setG_9_3(rs.getFloat("G_9_3"));
			    bean.setG_10(rs.getInt("G_10"));
	   			bean.setG_11_1(rs.getFloat("G_11_1"));
	   			bean.setG_11_2(rs.getFloat("G_11_2"));
	   			bean.setG_11_3(rs.getFloat("G_11_3"));
			    bean.setCompanys(rs.getString("COMPANYS"));
			    bean.setQuiry_nm(rs.getString("QUIRY_NM"));
			    bean.setQuiry_tel(rs.getString("QUIRY_TEL"));
	   			bean.setOa_f(rs.getFloat("OA_F"));
	   			bean.setOa_g(rs.getFloat("OA_G"));
			    bean.setEcar_tax	(rs.getInt("ECAR_TAX"));
				bean.setEcar_0_yn	(rs.getString("ECAR_0_YN"));
				bean.setEcar_1_yn	(rs.getString("ECAR_1_YN"));
				bean.setEcar_2_yn	(rs.getString("ECAR_2_YN"));
				bean.setEcar_3_yn	(rs.getString("ECAR_3_YN"));
				bean.setEcar_4_yn	(rs.getString("ECAR_4_YN"));
				bean.setEcar_5_yn	(rs.getString("ECAR_5_YN"));
				bean.setEcar_6_yn	(rs.getString("ECAR_6_YN"));
				bean.setEcar_7_yn	(rs.getString("ECAR_7_YN"));
				bean.setEcar_8_yn	(rs.getString("ECAR_8_YN"));
				bean.setEcar_9_yn	(rs.getString("ECAR_9_YN"));
				bean.setEcar_10_yn	(rs.getString("ECAR_10_YN"));
			    bean.setEcar_0_amt	(rs.getInt("ECAR_0_AMT"));
				bean.setEcar_1_amt	(rs.getInt("ECAR_1_AMT"));
				bean.setEcar_2_amt	(rs.getInt("ECAR_2_AMT"));
				bean.setEcar_3_amt	(rs.getInt("ECAR_3_AMT"));
				bean.setEcar_4_amt	(rs.getInt("ECAR_4_AMT"));
				bean.setEcar_5_amt	(rs.getInt("ECAR_5_AMT"));
				bean.setEcar_6_amt	(rs.getInt("ECAR_6_AMT"));
				bean.setEcar_7_amt	(rs.getInt("ECAR_7_AMT"));
				bean.setEcar_8_amt	(rs.getInt("ECAR_8_AMT"));
				bean.setEcar_9_amt	(rs.getInt("ECAR_9_AMT"));
				bean.setEcar_10_amt	(rs.getInt("ECAR_10_AMT"));
				bean.setEcar_bat_cost(rs.getInt("ECAR_BAT_COST"));
			    bean.setHcar_0_amt	(rs.getInt("HCAR_0_AMT"));
				bean.setHcar_1_amt	(rs.getInt("HCAR_1_AMT"));
				bean.setHcar_2_amt	(rs.getInt("HCAR_2_AMT"));
				bean.setHcar_3_amt	(rs.getInt("HCAR_3_AMT"));
				bean.setHcar_4_amt	(rs.getInt("HCAR_4_AMT"));
				bean.setHcar_5_amt	(rs.getInt("HCAR_5_AMT"));
				bean.setHcar_6_amt	(rs.getInt("HCAR_6_AMT"));
				bean.setHcar_7_amt	(rs.getInt("HCAR_7_AMT"));
				bean.setHcar_8_amt	(rs.getInt("HCAR_8_AMT"));
				bean.setHcar_9_amt	(rs.getInt("HCAR_9_AMT"));
				bean.setHcar_cost	(rs.getInt("HCAR_COST"));
			    bean.setCar_maint_amt1	(rs.getInt("CAR_MAINT_AMT1"));
				bean.setCar_maint_amt2	(rs.getInt("CAR_MAINT_AMT2"));
				bean.setCar_maint_amt3	(rs.getInt("CAR_MAINT_AMT3"));
				bean.setTint_b_amt		(rs.getInt("TINT_B_AMT"));
				bean.setTint_s_amt		(rs.getInt("TINT_S_AMT"));
				bean.setTint_n_amt		(rs.getInt("TINT_N_AMT"));
				bean.setTint_eb_amt		(rs.getInt("TINT_EB_AMT"));
				bean.setTint_bn_amt		(rs.getInt("TINT_BN_AMT"));
				bean.setLegal_amt		(rs.getInt("LEGAL_AMT"));
				bean.setCar_maint_amt4	(rs.getInt("CAR_MAINT_AMT4"));
				

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiCommVarList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstiCommVarBean[])col.toArray(new EstiCommVarBean[0]);
    }
	
	/**
     * 공통변수 조회-리스트에서
     */
    public EstiCommVarBean getEstiCommVarCase(String gubun1, String gubun2, String gubun3) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiCommVarBean bean = new EstiCommVarBean();
        String query = "";
        
        query = " select * from esti_comm_var where a_a='"+gubun1+"'";


		if(gubun3.equals("")){
			query += " and seq = (select max(seq) from esti_comm_var where a_a='"+gubun1+"')";
		}else{
			query += " and a_j = replace('"+gubun3+"', '-', '')";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setA_a(rs.getString("A_A"));
			    bean.setSeq(rs.getString("SEQ"));
			    bean.setA_f(rs.getFloat("A_F"));
			    bean.setA_g_1(rs.getInt("A_G_1"));
				bean.setA_g_2(rs.getInt("A_G_2"));
			    bean.setA_g_3(rs.getInt("A_G_3"));
			    bean.setA_g_4(rs.getInt("A_G_4"));
			    bean.setA_g_5(rs.getInt("A_G_5"));
				bean.setA_g_6(rs.getInt("A_G_6"));
				bean.setA_g_7(rs.getInt("A_G_7"));
			    bean.setA_j(rs.getString("A_J"));
			    bean.setO_8_1(rs.getFloat("O_8_1"));
				bean.setO_8_2(rs.getFloat("O_8_2"));
			    bean.setO_9_1(rs.getInt("O_9_1"));
			    bean.setO_9_2(rs.getInt("O_9_2"));
			    bean.setO_10(rs.getFloat("O_10"));
				bean.setO_12(rs.getFloat("O_12"));
				bean.setO_e(rs.getString("O_E"));
			    bean.setOa_b(rs.getInt("OA_B"));
	   			bean.setOa_c(rs.getFloat("OA_C"));
				bean.setG_1(rs.getInt("G_1"));
	   			bean.setG_3(rs.getFloat("G_3"));
	   			bean.setG_5(rs.getFloat("G_5"));
	   			bean.setG_8(rs.getFloat("G_8"));
	   			bean.setG_9_1(rs.getFloat("G_9_1"));
	   			bean.setG_9_2(rs.getFloat("G_9_2"));
	   			bean.setG_9_3(rs.getFloat("G_9_3"));
	   			bean.setG_9_4(rs.getFloat("G_9_4"));
				bean.setG_9_5(rs.getFloat("G_9_5"));
				bean.setG_9_6(rs.getFloat("G_9_6"));
				bean.setG_9_7(rs.getFloat("G_9_7"));	//2005.3.25. 개월수정리 추가
				bean.setG_10(rs.getInt("G_10"));
	   			bean.setG_11_1(rs.getFloat("G_11_1"));
	   			bean.setG_11_2(rs.getFloat("G_11_2"));
	   			bean.setG_11_3(rs.getFloat("G_11_3"));
	   			bean.setG_11_4(rs.getFloat("G_11_4"));
				bean.setG_11_5(rs.getFloat("G_11_5"));
				bean.setG_11_6(rs.getFloat("G_11_6"));
				bean.setG_11_7(rs.getFloat("G_11_7"));	//2005.3.25. 개월수정리 추가
				bean.setCompanys(rs.getString("COMPANYS"));
			    bean.setQuiry_nm(rs.getString("QUIRY_NM"));
			    bean.setQuiry_tel(rs.getString("QUIRY_TEL"));
	   			bean.setOa_f(rs.getFloat("OA_F"));
	   			bean.setOa_g(rs.getFloat("OA_G"));
	   			bean.setOa_h(rs.getFloat("OA_H"));
				bean.setA_f_w(rs.getFloat("A_F_W"));	//우량기업 적용이자율 20030325.
			    bean.setA_g_1_w(rs.getInt("A_G_1_W"));	//우량기업 10만원당 월할부금.12개월
				bean.setA_g_2_w(rs.getInt("A_G_2_W"));	//우량기업 10만원당 월할부금.18개월
			    bean.setA_g_3_w(rs.getInt("A_G_3_W"));	//우량기업 10만원당 월할부금.24개월
			    bean.setA_g_4_w(rs.getInt("A_G_4_W"));	//우량기업 10만원당 월할부금.30개월
			    bean.setA_g_5_w(rs.getInt("A_G_5_W"));	//우량기업 10만원당 월할부금.36개월
				bean.setA_g_6_w(rs.getInt("A_G_6_W"));	//우량기업 10만원당 월할부금.42개월
				bean.setA_g_7_w(rs.getInt("A_G_7_W"));	//우량기업 10만원당 월할부금.48개월
				bean.setG_9_11_w(rs.getFloat("G_9_11_W"));	//우량기업 적용마진. 2005.3.25. 기본식,일반식,개월수 상관없이.
				//20050511 초우량기업 추가.
				bean.setA_f_uw(rs.getFloat("A_F_UW"));	//적용이자율
			    bean.setA_g_1_uw(rs.getInt("A_G_1_UW"));	//10만원당 월할부금.12개월
				bean.setA_g_2_uw(rs.getInt("A_G_2_UW"));	//10만원당 월할부금.18개월
			    bean.setA_g_3_uw(rs.getInt("A_G_3_UW"));	//10만원당 월할부금.24개월
			    bean.setA_g_4_uw(rs.getInt("A_G_4_UW"));	//10만원당 월할부금.30개월
			    bean.setA_g_5_uw(rs.getInt("A_G_5_UW"));	//10만원당 월할부금.36개월
				bean.setA_g_6_uw(rs.getInt("A_G_6_UW"));	//10만원당 월할부금.42개월
				bean.setA_g_7_uw(rs.getInt("A_G_7_UW"));	//10만원당 월할부금.48개월
				bean.setG_9_11_uw(rs.getFloat("G_9_11_UW"));	//목표마진
				//20050823
				bean.setG_11_w(rs.getFloat("G_11_W"));
				bean.setG_11_uw(rs.getFloat("G_11_UW"));
				//20070323, 잔가공통변수
				bean.setJg_c_1(rs.getFloat("JG_C_1"));
				bean.setJg_c_2(rs.getFloat("JG_C_2"));
				bean.setJg_c_3(rs.getFloat("JG_C_3"));
				bean.setJg_c_4(rs.getFloat("JG_C_4"));
				bean.setJg_c_5(rs.getFloat("JG_C_5"));
				bean.setJg_c_6(rs.getFloat("JG_C_6"));
				bean.setJg_c_a(rs.getInt  ("JG_C_a"));
				bean.setJg_c_b(rs.getInt  ("JG_C_b"));
				bean.setJg_c_c(rs.getFloat("JG_C_c"));
				bean.setJg_c_d(rs.getFloat("JG_C_d"));
			    bean.setO_9_3(rs.getInt("O_9_3"));
			    bean.setO_9_4(rs.getInt("O_9_4"));
			    bean.setO_9_5(rs.getInt("O_9_5"));
			    bean.setO_9_7(rs.getInt("O_9_7"));
				bean.setO_9_8(rs.getInt("O_9_8"));
			    bean.setO_8_3(rs.getFloat("O_8_3"));
				bean.setO_8_4(rs.getFloat("O_8_4"));
				bean.setO_8_5(rs.getFloat("O_8_5"));
				bean.setO_8_7(rs.getFloat("O_8_7"));
				bean.setO_8_8(rs.getFloat("O_8_8"));
				//20080715, 재리스 잔가공통변수
				bean.setJg_c_71(rs.getInt  ("JG_C_71"));
				bean.setJg_c_72(rs.getInt  ("JG_C_72"));
				bean.setJg_c_73(rs.getInt  ("JG_C_73"));
				bean.setJg_c_81(rs.getFloat("JG_C_81"));
				bean.setJg_c_82(rs.getFloat("JG_C_82"));
				bean.setJg_c_9(rs.getFloat("JG_C_9"));
				bean.setJg_c_10(rs.getFloat("JG_C_10"));
				bean.setJg_c_11(rs.getFloat("JG_C_11"));
				//20080716 재리스공통변수
				bean.setSh_c_a	(rs.getFloat("SH_C_A"));
				bean.setSh_c_b1	(rs.getFloat("SH_C_B1"));
				bean.setSh_c_b2	(rs.getFloat("SH_C_B2"));
				bean.setSh_c_d1	(rs.getFloat("SH_C_D1"));
				bean.setSh_c_d2	(rs.getFloat("SH_C_D2"));
				bean.setA_m_1	(rs.getFloat("A_M_1"));
				bean.setA_m_2	(rs.getFloat("A_M_2"));
				bean.setSh_p_1	(rs.getInt  ("SH_P_1"));
				bean.setSh_p_2	(rs.getFloat("SH_P_2"));
				bean.setBc_s_i	(rs.getFloat("BC_S_I"));
				//20090811 위약금율산출
				bean.setAx_n	(rs.getFloat("AX_N"));
				bean.setAx_n_c	(rs.getFloat("AX_N_C"));
				bean.setAx_p	(rs.getInt  ("AX_P"));
				bean.setAx_q	(rs.getFloat("AX_Q"));
				bean.setAx_r_1	(rs.getFloat("AX_R_1"));
				bean.setAx_r_2	(rs.getFloat("AX_R_2"));
				bean.setJg_c_32	(rs.getFloat("JG_C_32"));
	   			bean.setK_su_1	(rs.getFloat("K_SU_1"));
	   			bean.setK_su_2	(rs.getFloat("K_SU_2"));
	   			bean.setA_cb_1	(rs.getFloat("A_CB_1"));
				//20150508 사고수리비 관련
				bean.setAccid_a(rs.getFloat("ACCID_A"));
				bean.setAccid_b(rs.getFloat("ACCID_B"));
				bean.setAccid_c(rs.getFloat("ACCID_C"));
				bean.setAccid_d(rs.getFloat("ACCID_D"));
				bean.setAccid_e(rs.getFloat("ACCID_E"));
				bean.setAccid_f(rs.getFloat("ACCID_F"));
				bean.setAccid_g(rs.getFloat("ACCID_G"));
				bean.setAccid_h(rs.getFloat("ACCID_H"));
				bean.setAccid_j(rs.getFloat("ACCID_J"));
				bean.setAccid_k(rs.getFloat("ACCID_K"));
				bean.setAccid_m(rs.getFloat("ACCID_M"));
				bean.setAccid_n(rs.getFloat("ACCID_N"));
				bean.setSh_c_k	(rs.getFloat("SH_C_K"));
				bean.setSh_c_m	(rs.getFloat("SH_C_M"));
				bean.setJg_c_12(rs.getFloat("JG_C_12"));
			    bean.setEcar_tax	(rs.getInt("ECAR_TAX"));
				bean.setEcar_0_yn	(rs.getString("ECAR_0_YN"));
				bean.setEcar_1_yn	(rs.getString("ECAR_1_YN"));
				bean.setEcar_2_yn	(rs.getString("ECAR_2_YN"));
				bean.setEcar_3_yn	(rs.getString("ECAR_3_YN"));
				bean.setEcar_4_yn	(rs.getString("ECAR_4_YN"));
				bean.setEcar_5_yn	(rs.getString("ECAR_5_YN"));
				bean.setEcar_6_yn	(rs.getString("ECAR_6_YN"));
				bean.setEcar_7_yn	(rs.getString("ECAR_7_YN"));
				bean.setEcar_8_yn	(rs.getString("ECAR_8_YN"));
				bean.setEcar_9_yn	(rs.getString("ECAR_9_YN"));
				bean.setEcar_10_yn	(rs.getString("ECAR_10_YN"));
			    bean.setEcar_0_amt	(rs.getInt("ECAR_0_AMT"));
				bean.setEcar_1_amt	(rs.getInt("ECAR_1_AMT"));
				bean.setEcar_2_amt	(rs.getInt("ECAR_2_AMT"));
				bean.setEcar_3_amt	(rs.getInt("ECAR_3_AMT"));
				bean.setEcar_4_amt	(rs.getInt("ECAR_4_AMT"));
				bean.setEcar_5_amt	(rs.getInt("ECAR_5_AMT"));
				bean.setEcar_6_amt	(rs.getInt("ECAR_6_AMT"));
				bean.setEcar_7_amt	(rs.getInt("ECAR_7_AMT"));
				bean.setEcar_8_amt	(rs.getInt("ECAR_8_AMT"));
				bean.setEcar_9_amt	(rs.getInt("ECAR_9_AMT"));
				bean.setEcar_10_amt	(rs.getInt("ECAR_10_AMT"));
				bean.setEcar_bat_cost(rs.getInt("ECAR_BAT_COST"));
				bean.setSh_a_m_1	(rs.getFloat("SH_A_M_1"));
				bean.setSh_a_m_2	(rs.getFloat("SH_A_M_2"));
			    bean.setHcar_0_amt	(rs.getInt("HCAR_0_AMT"));
				bean.setHcar_1_amt	(rs.getInt("HCAR_1_AMT"));
				bean.setHcar_2_amt	(rs.getInt("HCAR_2_AMT"));
				bean.setHcar_3_amt	(rs.getInt("HCAR_3_AMT"));
				bean.setHcar_4_amt	(rs.getInt("HCAR_4_AMT"));
				bean.setHcar_5_amt	(rs.getInt("HCAR_5_AMT"));
				bean.setHcar_6_amt	(rs.getInt("HCAR_6_AMT"));
				bean.setHcar_7_amt	(rs.getInt("HCAR_7_AMT"));
				bean.setHcar_8_amt	(rs.getInt("HCAR_8_AMT"));
				bean.setHcar_9_amt	(rs.getInt("HCAR_9_AMT"));
				bean.setHcar_cost	(rs.getInt("HCAR_COST"));
				//기타변수 추가
				bean.setA_y_1(rs.getFloat("A_Y_1"));
				bean.setA_y_2(rs.getFloat("A_Y_2"));
				bean.setA_y_3(rs.getFloat("A_Y_3"));
				bean.setA_y_4(rs.getFloat("A_Y_4"));
				bean.setA_y_5(rs.getFloat("A_Y_5"));
				bean.setA_y_6(rs.getFloat("A_Y_6"));
				
				bean.setA_f_2(rs.getFloat("A_F_2"));
				bean.setA_f_3(rs.getFloat("A_F_3"));
			    bean.setOa_extra(rs.getFloat("OA_EXTRA"));
			    bean.setOa_g_1(rs.getFloat("OA_G_1"));
				bean.setOa_g_2(rs.getFloat("OA_G_2"));
			    bean.setOa_g_3(rs.getFloat("OA_G_3"));
			    bean.setOa_g_4(rs.getFloat("OA_G_4"));
			    bean.setOa_g_5(rs.getFloat("OA_G_5"));
				bean.setOa_g_6(rs.getFloat("OA_G_6"));
				bean.setOa_g_7(rs.getFloat("OA_G_7"));
				
				bean.setBr_cons_00	(rs.getInt("BR_CONS_00"));
				bean.setBr_cons_01	(rs.getInt("BR_CONS_01"));
				bean.setBr_cons_02	(rs.getInt("BR_CONS_02"));
				bean.setBr_cons_03	(rs.getInt("BR_CONS_03"));
				bean.setBr_cons_04	(rs.getInt("BR_CONS_04"));
				bean.setBr_cons_10	(rs.getInt("BR_CONS_10"));
				bean.setBr_cons_11	(rs.getInt("BR_CONS_11"));
				bean.setBr_cons_12	(rs.getInt("BR_CONS_12"));
				bean.setBr_cons_13	(rs.getInt("BR_CONS_13"));
				bean.setBr_cons_14	(rs.getInt("BR_CONS_14"));
				bean.setBr_cons_20	(rs.getInt("BR_CONS_20"));
				bean.setBr_cons_21	(rs.getInt("BR_CONS_21"));
				bean.setBr_cons_22	(rs.getInt("BR_CONS_22"));
				bean.setBr_cons_23	(rs.getInt("BR_CONS_23"));
				bean.setBr_cons_24	(rs.getInt("BR_CONS_24"));
				bean.setBr_cons_30	(rs.getInt("BR_CONS_30"));
				bean.setBr_cons_31	(rs.getInt("BR_CONS_31"));
				bean.setBr_cons_32	(rs.getInt("BR_CONS_32"));
				bean.setBr_cons_33	(rs.getInt("BR_CONS_33"));
				bean.setBr_cons_34	(rs.getInt("BR_CONS_34"));
				bean.setBr_cons_40	(rs.getInt("BR_CONS_40"));
				bean.setBr_cons_41	(rs.getInt("BR_CONS_41"));
				bean.setBr_cons_42	(rs.getInt("BR_CONS_42"));
				bean.setBr_cons_43	(rs.getInt("BR_CONS_43"));
				bean.setBr_cons_44	(rs.getInt("BR_CONS_44"));

			    bean.setCar_maint_amt1	(rs.getInt("CAR_MAINT_AMT1"));
				bean.setCar_maint_amt2	(rs.getInt("CAR_MAINT_AMT2"));
				bean.setCar_maint_amt3	(rs.getInt("CAR_MAINT_AMT3"));
				bean.setTint_b_amt		(rs.getInt("TINT_B_AMT"));
				bean.setTint_s_amt		(rs.getInt("TINT_S_AMT"));
				bean.setTint_n_amt		(rs.getInt("TINT_N_AMT"));
				bean.setTint_eb_amt		(rs.getInt("TINT_EB_AMT"));
				bean.setTint_bn_amt		(rs.getInt("TINT_BN_AMT"));
				bean.setLegal_amt		(rs.getInt("LEGAL_AMT"));
				bean.setCar_maint_amt4	(rs.getInt("CAR_MAINT_AMT4"));
				

            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiCommVarCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 공통변수 조회-세부내용
     */
    public EstiCommVarBean getEstiCommVarCase(String a_a, String seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiCommVarBean bean = new EstiCommVarBean();
        String query = "";
        
        query = " select * from esti_comm_var where a_a='"+a_a+"'";

		if(seq.equals("")){
			query += " and seq = (select max(seq) from esti_comm_var where a_a='"+a_a+"')";
		}else{
			query += " and lpad(seq,3,'00')=lpad('"+seq+"',3,'00')";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            if(rs.next()){
				bean.setA_a(rs.getString("A_A"));
			    bean.setSeq(rs.getString("SEQ"));
			    bean.setA_f(rs.getFloat("A_F"));
			    bean.setA_g_1(rs.getInt("A_G_1"));	//36개월
				bean.setA_g_2(rs.getInt("A_G_2"));	//24개월
			    bean.setA_g_3(rs.getInt("A_G_3"));	//18개월
			    bean.setA_g_4(rs.getInt("A_G_4"));	//12개월
			    bean.setA_g_5(rs.getInt("A_G_5"));	//42개월	   			
				bean.setA_g_6(rs.getInt("A_G_6"));	//30개월
				bean.setA_g_7(rs.getInt("A_G_7"));	//48개월.
			    bean.setA_j(rs.getString("A_J"));
			    bean.setO_8_1(rs.getFloat("O_8_1"));
				bean.setO_8_2(rs.getFloat("O_8_2"));
			    bean.setO_9_1(rs.getInt("O_9_1"));
			    bean.setO_9_2(rs.getInt("O_9_2"));
			    bean.setO_10(rs.getFloat("O_10"));
				bean.setO_12(rs.getFloat("O_12"));
			    bean.setO_e(rs.getString("O_E"));
			    bean.setOa_b(rs.getInt("OA_B"));
	   			bean.setOa_c(rs.getFloat("OA_C"));
			    bean.setG_1(rs.getInt("G_1"));
	   			bean.setG_3(rs.getFloat("G_3"));
	   			bean.setG_5(rs.getFloat("G_5"));
	   			bean.setG_8(rs.getFloat("G_8"));
	   			bean.setG_9_1(rs.getFloat("G_9_1"));
	   			bean.setG_9_2(rs.getFloat("G_9_2"));
	   			bean.setG_9_3(rs.getFloat("G_9_3"));
				bean.setG_9_4(rs.getFloat("G_9_4"));
				bean.setG_9_5(rs.getFloat("G_9_5"));
				bean.setG_9_6(rs.getFloat("G_9_6"));
				bean.setG_9_7(rs.getFloat("G_9_7"));	//2005.3.25. 개월수정리 추가
			    bean.setG_10(rs.getInt("G_10"));
	   			bean.setG_11_1(rs.getFloat("G_11_1"));
	   			bean.setG_11_2(rs.getFloat("G_11_2"));
	   			bean.setG_11_3(rs.getFloat("G_11_3"));
				bean.setG_11_4(rs.getFloat("G_11_4"));
				bean.setG_11_5(rs.getFloat("G_11_5"));
				bean.setG_11_6(rs.getFloat("G_11_6"));
				bean.setG_11_7(rs.getFloat("G_11_7"));	//2005.3.25. 개월수정리 추가
			    bean.setCompanys(rs.getString("COMPANYS"));
			    bean.setQuiry_nm(rs.getString("QUIRY_NM"));
			    bean.setQuiry_tel(rs.getString("QUIRY_TEL"));
	   			bean.setOa_f(rs.getFloat("OA_F"));
	   			bean.setOa_g(rs.getFloat("OA_G"));
	   			bean.setOa_h(rs.getFloat("OA_H"));
				bean.setA_f_w(rs.getFloat("A_F_W"));	//우량기업 적용이자율 20030325.
			    bean.setA_g_1_w(rs.getInt("A_G_1_W"));	//우량기업 10만원당 월할부금.12개월
				bean.setA_g_2_w(rs.getInt("A_G_2_W"));	//우량기업 10만원당 월할부금.18개월
			    bean.setA_g_3_w(rs.getInt("A_G_3_W"));	//우량기업 10만원당 월할부금.24개월
			    bean.setA_g_4_w(rs.getInt("A_G_4_W"));	//우량기업 10만원당 월할부금.30개월
			    bean.setA_g_5_w(rs.getInt("A_G_5_W"));	//우량기업 10만원당 월할부금.36개월
				bean.setA_g_6_w(rs.getInt("A_G_6_W"));	//우량기업 10만원당 월할부금.42개월
				bean.setA_g_7_w(rs.getInt("A_G_7_W"));	//우량기업 10만원당 월할부금.48개월
				bean.setG_9_11_w(rs.getFloat("G_9_11_W"));	//우량기업 적용마진. 2005.3.25. 기본식,일반식,개월수 상관없이.
				//20050511 초우량기업 추가.
				bean.setA_f_uw(rs.getFloat("A_F_UW"));	//적용이자율
			    bean.setA_g_1_uw(rs.getInt("A_G_1_UW"));	//10만원당 월할부금.12개월
				bean.setA_g_2_uw(rs.getInt("A_G_2_UW"));	//10만원당 월할부금.18개월
			    bean.setA_g_3_uw(rs.getInt("A_G_3_UW"));	//10만원당 월할부금.24개월
			    bean.setA_g_4_uw(rs.getInt("A_G_4_UW"));	//10만원당 월할부금.30개월
			    bean.setA_g_5_uw(rs.getInt("A_G_5_UW"));	//10만원당 월할부금.36개월
				bean.setA_g_6_uw(rs.getInt("A_G_6_UW"));	//10만원당 월할부금.42개월
				bean.setA_g_7_uw(rs.getInt("A_G_7_UW"));	//10만원당 월할부금.48개월
				bean.setG_9_11_uw(rs.getFloat("G_9_11_UW"));	//목표마진
				//20050823
				bean.setG_11_w(rs.getFloat("G_11_W"));
				bean.setG_11_uw(rs.getFloat("G_11_UW"));
				//20070323, 잔가공통변수
				bean.setJg_c_1(rs.getFloat("JG_C_1"));
				bean.setJg_c_2(rs.getFloat("JG_C_2"));
				bean.setJg_c_3(rs.getFloat("JG_C_3"));
				bean.setJg_c_4(rs.getFloat("JG_C_4"));
				bean.setJg_c_5(rs.getFloat("JG_C_5"));
				bean.setJg_c_6(rs.getFloat("JG_C_6"));
				bean.setJg_c_a(rs.getInt  ("JG_C_a"));
				bean.setJg_c_b(rs.getInt  ("JG_C_b"));
				bean.setJg_c_c(rs.getFloat("JG_C_c"));
				bean.setJg_c_d(rs.getFloat("JG_C_d"));
			    bean.setO_9_3(rs.getInt("O_9_3"));
			    bean.setO_9_4(rs.getInt("O_9_4"));
			    bean.setO_9_5(rs.getInt("O_9_5"));
				bean.setO_9_7(rs.getInt("O_9_7"));
				bean.setO_9_8(rs.getInt("O_9_8"));
			    bean.setO_8_3(rs.getFloat("O_8_3"));
				bean.setO_8_4(rs.getFloat("O_8_4"));
				bean.setO_8_5(rs.getFloat("O_8_5"));
				bean.setO_8_7(rs.getFloat("O_8_7"));
				bean.setO_8_8(rs.getFloat("O_8_8"));
				//20080715, 재리스 잔가공통변수
				bean.setJg_c_71	(rs.getInt  ("JG_C_71"));
				bean.setJg_c_72	(rs.getInt  ("JG_C_72"));
				bean.setJg_c_73	(rs.getInt  ("JG_C_73"));
				bean.setJg_c_81	(rs.getFloat("JG_C_81"));
				bean.setJg_c_82	(rs.getFloat("JG_C_82"));
				bean.setJg_c_9	(rs.getFloat("JG_C_9"));
				bean.setJg_c_10	(rs.getFloat("JG_C_10"));
				bean.setJg_c_11	(rs.getFloat("JG_C_11"));
				//20080716 재리스공통변수
				bean.setSh_c_a	(rs.getFloat("SH_C_A"));
				bean.setSh_c_b1	(rs.getFloat("SH_C_B1"));
				bean.setSh_c_b2	(rs.getFloat("SH_C_B2"));
				bean.setSh_c_d1	(rs.getFloat("SH_C_D1"));
				bean.setSh_c_d2	(rs.getFloat("SH_C_D2"));
				bean.setA_m_1	(rs.getFloat("A_M_1"));
				bean.setA_m_2	(rs.getFloat("A_M_2"));
				bean.setSh_p_1	(rs.getInt  ("SH_P_1"));
				bean.setSh_p_2	(rs.getFloat("SH_P_2"));
				bean.setBc_s_i	(rs.getFloat("BC_S_I"));
				//20090811 위약금율산출
				bean.setAx_n	(rs.getFloat("AX_N"));
				bean.setAx_n_c	(rs.getFloat("AX_N_C"));
				bean.setAx_p	(rs.getInt  ("AX_P"));
				bean.setAx_q	(rs.getFloat("AX_Q"));
				bean.setAx_r_1	(rs.getFloat("AX_R_1"));
				bean.setAx_r_2	(rs.getFloat("AX_R_2"));
				bean.setJg_c_32	(rs.getFloat("JG_C_32"));
	   			bean.setK_su_1	(rs.getFloat("K_SU_1"));
	   			bean.setK_su_2	(rs.getFloat("K_SU_2"));
	   			bean.setA_cb_1	(rs.getFloat("A_CB_1"));
				//20150508 사고수리비 관련
				bean.setAccid_a(rs.getFloat("ACCID_A"));
				bean.setAccid_b(rs.getFloat("ACCID_B"));
				bean.setAccid_c(rs.getFloat("ACCID_C"));
				bean.setAccid_d(rs.getFloat("ACCID_D"));
				bean.setAccid_e(rs.getFloat("ACCID_E"));
				bean.setAccid_f(rs.getFloat("ACCID_F"));
				bean.setAccid_g(rs.getFloat("ACCID_G"));
				bean.setAccid_h(rs.getFloat("ACCID_H"));
				bean.setAccid_j(rs.getFloat("ACCID_J"));
				bean.setAccid_k(rs.getFloat("ACCID_K"));
				bean.setAccid_m(rs.getFloat("ACCID_M"));
				bean.setAccid_n(rs.getFloat("ACCID_N"));
				bean.setSh_c_k	(rs.getFloat("SH_C_K"));
				bean.setSh_c_m	(rs.getFloat("SH_C_M"));
				bean.setJg_c_12(rs.getFloat("JG_C_12"));
			    bean.setEcar_tax	(rs.getInt("ECAR_TAX"));
				bean.setEcar_0_yn	(rs.getString("ECAR_0_YN"));
				bean.setEcar_1_yn	(rs.getString("ECAR_1_YN"));
				bean.setEcar_2_yn	(rs.getString("ECAR_2_YN"));
				bean.setEcar_3_yn	(rs.getString("ECAR_3_YN"));
				bean.setEcar_4_yn	(rs.getString("ECAR_4_YN"));
				bean.setEcar_5_yn	(rs.getString("ECAR_5_YN"));
				bean.setEcar_6_yn	(rs.getString("ECAR_6_YN"));
				bean.setEcar_7_yn	(rs.getString("ECAR_7_YN"));
				bean.setEcar_8_yn	(rs.getString("ECAR_8_YN"));
				bean.setEcar_9_yn	(rs.getString("ECAR_9_YN"));
				bean.setEcar_10_yn	(rs.getString("ECAR_10_YN"));
			    bean.setEcar_0_amt	(rs.getInt("ECAR_0_AMT"));
				bean.setEcar_1_amt	(rs.getInt("ECAR_1_AMT"));
				bean.setEcar_2_amt	(rs.getInt("ECAR_2_AMT"));
				bean.setEcar_3_amt	(rs.getInt("ECAR_3_AMT"));
				bean.setEcar_4_amt	(rs.getInt("ECAR_4_AMT"));
				bean.setEcar_5_amt	(rs.getInt("ECAR_5_AMT"));
				bean.setEcar_6_amt	(rs.getInt("ECAR_6_AMT"));
				bean.setEcar_7_amt	(rs.getInt("ECAR_7_AMT"));
				bean.setEcar_8_amt	(rs.getInt("ECAR_8_AMT"));
				bean.setEcar_9_amt	(rs.getInt("ECAR_9_AMT"));
				bean.setEcar_10_amt	(rs.getInt("ECAR_10_AMT"));
				bean.setEcar_bat_cost(rs.getInt("ECAR_BAT_COST"));
				bean.setSh_a_m_1	(rs.getFloat("SH_A_M_1"));
				bean.setSh_a_m_2	(rs.getFloat("SH_A_M_2"));
			    bean.setHcar_0_amt	(rs.getInt("HCAR_0_AMT"));
				bean.setHcar_1_amt	(rs.getInt("HCAR_1_AMT"));
				bean.setHcar_2_amt	(rs.getInt("HCAR_2_AMT"));
				bean.setHcar_3_amt	(rs.getInt("HCAR_3_AMT"));
				bean.setHcar_4_amt	(rs.getInt("HCAR_4_AMT"));
				bean.setHcar_5_amt	(rs.getInt("HCAR_5_AMT"));
				bean.setHcar_6_amt	(rs.getInt("HCAR_6_AMT"));
				bean.setHcar_7_amt	(rs.getInt("HCAR_7_AMT"));
				bean.setHcar_8_amt	(rs.getInt("HCAR_8_AMT"));
				bean.setHcar_9_amt	(rs.getInt("HCAR_9_AMT"));
				bean.setHcar_cost	(rs.getInt("HCAR_COST"));
				//기타변수 추가
				bean.setA_y_1(rs.getFloat("A_Y_1"));
				bean.setA_y_2(rs.getFloat("A_Y_2"));
				bean.setA_y_3(rs.getFloat("A_Y_3"));
				bean.setA_y_4(rs.getFloat("A_Y_4"));
				bean.setA_y_5(rs.getFloat("A_Y_5"));
				bean.setA_y_6(rs.getFloat("A_Y_6"));
				
				bean.setA_f_2(rs.getFloat("A_F_2"));
				bean.setA_f_3(rs.getFloat("A_F_3"));
			    bean.setOa_extra(rs.getFloat("OA_EXTRA"));
			    bean.setOa_g_1(rs.getFloat("OA_G_1"));
				bean.setOa_g_2(rs.getFloat("OA_G_2"));
			    bean.setOa_g_3(rs.getFloat("OA_G_3"));
			    bean.setOa_g_4(rs.getFloat("OA_G_4"));
			    bean.setOa_g_5(rs.getFloat("OA_G_5"));
				bean.setOa_g_6(rs.getFloat("OA_G_6"));
				bean.setOa_g_7(rs.getFloat("OA_G_7"));	
				
				bean.setBr_cons_00	(rs.getInt("BR_CONS_00"));
				bean.setBr_cons_01	(rs.getInt("BR_CONS_01"));
				bean.setBr_cons_02	(rs.getInt("BR_CONS_02"));
				bean.setBr_cons_03	(rs.getInt("BR_CONS_03"));
				bean.setBr_cons_04	(rs.getInt("BR_CONS_04"));
				bean.setBr_cons_10	(rs.getInt("BR_CONS_10"));
				bean.setBr_cons_11	(rs.getInt("BR_CONS_11"));
				bean.setBr_cons_12	(rs.getInt("BR_CONS_12"));
				bean.setBr_cons_13	(rs.getInt("BR_CONS_13"));
				bean.setBr_cons_14	(rs.getInt("BR_CONS_14"));
				bean.setBr_cons_20	(rs.getInt("BR_CONS_20"));
				bean.setBr_cons_21	(rs.getInt("BR_CONS_21"));
				bean.setBr_cons_22	(rs.getInt("BR_CONS_22"));
				bean.setBr_cons_23	(rs.getInt("BR_CONS_23"));
				bean.setBr_cons_24	(rs.getInt("BR_CONS_24"));
				bean.setBr_cons_30	(rs.getInt("BR_CONS_30"));
				bean.setBr_cons_31	(rs.getInt("BR_CONS_31"));
				bean.setBr_cons_32	(rs.getInt("BR_CONS_32"));
				bean.setBr_cons_33	(rs.getInt("BR_CONS_33"));
				bean.setBr_cons_34	(rs.getInt("BR_CONS_34"));
				bean.setBr_cons_40	(rs.getInt("BR_CONS_40"));
				bean.setBr_cons_41	(rs.getInt("BR_CONS_41"));
				bean.setBr_cons_42	(rs.getInt("BR_CONS_42"));
				bean.setBr_cons_43	(rs.getInt("BR_CONS_43"));
				bean.setBr_cons_44	(rs.getInt("BR_CONS_44"));		
				
			    bean.setCar_maint_amt1	(rs.getInt("CAR_MAINT_AMT1"));
				bean.setCar_maint_amt2	(rs.getInt("CAR_MAINT_AMT2"));
				bean.setCar_maint_amt3	(rs.getInt("CAR_MAINT_AMT3"));
				bean.setTint_b_amt		(rs.getInt("TINT_B_AMT"));
				bean.setTint_s_amt		(rs.getInt("TINT_S_AMT"));
				bean.setTint_n_amt		(rs.getInt("TINT_N_AMT"));
				bean.setTint_eb_amt		(rs.getInt("TINT_EB_AMT"));
				bean.setTint_bn_amt		(rs.getInt("TINT_BN_AMT"));
				bean.setLegal_amt		(rs.getInt("LEGAL_AMT"));
				bean.setCar_maint_amt4	(rs.getInt("CAR_MAINT_AMT4"));
				

            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiCommVarCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
     * 공통변수 등록.
     */
    public String insertEstiCommVar(EstiCommVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
        String query1 = "";
		String query2 = "";
		String seq = "";
        int count = 0;

		query1 = " SELECT nvl(lpad(max(to_number(SEQ))+1,3,'00'),'001') FROM ESTI_COMM_VAR where a_a='"+bean.getA_a().trim()+"' ";
			
        query2 = " INSERT INTO ESTI_COMM_VAR"+
				" (a_a, seq, a_f, a_g_1, a_g_2, a_g_3, a_g_4, a_j, o_8_1, o_8_2,"+
				"  o_9_1, o_9_2, o_10, o_12, o_e, oa_b, oa_c, g_1, g_3, g_5,"+
				"  g_8, g_9_1, g_9_2, g_9_3, g_9_4, g_9_5, g_9_6, g_9_7, g_10, g_11_1, "+
				"  g_11_2, g_11_3, g_11_4, g_11_5, g_11_6, g_11_7, companys, quiry_nm, quiry_tel, oa_f, "+
				"  oa_g, oa_h, a_g_5, a_g_6, a_g_7, "+
				"  a_f_w, a_g_1_w, a_g_2_w, a_g_3_w, a_g_4_w, a_g_5_w, a_g_6_w, a_g_7_w, g_9_11_w, "+			//우량기업추가 20050325
				"  a_f_uw, a_g_1_uw, a_g_2_uw, a_g_3_uw, a_g_4_uw, a_g_5_uw, a_g_6_uw, a_g_7_uw, g_9_11_uw, "+	//초우량기업추가 20050511
				"  g_11_w, g_11_uw,"+//우량,초우량 일반식추가. 기존것은 기본식으로 20050823
				"  jg_c_1, jg_c_2, jg_c_3, jg_c_4, jg_c_5, jg_c_6, jg_c_a, jg_c_b, jg_c_c, jg_c_d, "+//20070323 잔가공통변수 추가
				"  o_8_3, o_8_4, o_8_5, o_9_3, o_9_4, o_9_5, "+
				"  jg_c_71, jg_c_72, jg_c_73, jg_c_81, jg_c_82, jg_c_9, jg_c_10, jg_c_11, "+
				"  sh_c_a, sh_c_b1, sh_c_b2, sh_c_d1, sh_c_d2, a_m_1, a_m_2, sh_p_1, sh_p_2, bc_s_i, "+
				"  ax_n, ax_n_c, ax_p, ax_q, ax_r_1, ax_r_2, jg_c_32, o_8_7, o_9_7, o_8_8, o_9_8, "+
				"  k_su_1, k_su_2, a_cb_1, "+
                "  accid_a, accid_b, accid_c, accid_d, accid_e, accid_f, accid_g, accid_h, accid_j, accid_k, accid_m, accid_n, "+ 
                "  sh_c_k, sh_c_m, jg_c_12,  "+  
				"  ecar_tax, "+
                "  ecar_0_yn, ecar_1_yn, ecar_2_yn, ecar_3_yn, ecar_4_yn, ecar_5_yn, ecar_6_yn, ecar_7_yn, ecar_8_yn, ecar_9_yn, "+
                "  ecar_0_amt, ecar_1_amt, ecar_2_amt, ecar_3_amt, ecar_4_amt, ecar_5_amt, ecar_6_amt, ecar_7_amt, ecar_8_amt, ecar_9_amt, "+
                "  ecar_bat_cost, sh_a_m_1, sh_a_m_2, "+
                "  hcar_0_amt, hcar_1_amt, hcar_2_amt, hcar_3_amt, hcar_4_amt, hcar_5_amt, hcar_6_amt, hcar_7_amt, hcar_8_amt, hcar_9_amt, hcar_cost, "+
                "  a_y_1, a_y_2, a_y_3, a_y_4, a_y_5, a_y_6, "+
                "  a_f_2, oa_extra, oa_g_1, oa_g_2, oa_g_3, oa_g_4, oa_g_5, oa_g_6, oa_g_7, "+
                "  br_cons_00, br_cons_01, br_cons_02, br_cons_03, br_cons_04, "+
                "  br_cons_10, br_cons_11, br_cons_12, br_cons_13, br_cons_14, "+
                "  br_cons_20, br_cons_21, br_cons_22, br_cons_23, br_cons_24, "+
                "  br_cons_30, br_cons_31, br_cons_32, br_cons_33, br_cons_34, "+
                "  br_cons_40, br_cons_41, br_cons_42, br_cons_43, br_cons_44, "+
                "  ecar_10_yn, ecar_10_amt, car_maint_amt1, car_maint_amt2, car_maint_amt3, tint_b_amt, tint_s_amt, tint_n_amt, tint_eb_amt, tint_bn_amt, legal_amt, car_maint_amt4,  "+
                "  a_f_3 "+
				" ) "+	
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, replace(?,'-',''), ?, ?,"+
				"   ?, ?, ?, ?, replace(?,'-',''), ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"	?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"	?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"	?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"	?, ?, ?, "+
                "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
                "   ?, ?, ?, "+ 
				"   ?, "+	
                "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
                "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?,  "+	
                "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
                "   ?, ?, ?, ?, ?, ?, "+
                "   ?, ?, ?, ?, ?, ?, ?, ?, ?, "+                
                "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
                "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
                "   ? "+
				" )";
           
       try{
            con.setAutoCommit(false);

            //seq 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query1);
            if(rs.next())
            	seq = rs.getString(1);
            rs.close();
      		stmt.close();

            pstmt = con.prepareStatement(query2);
            pstmt.setString(1, bean.getA_a().trim());
            pstmt.setString(2, seq.trim());
            pstmt.setFloat(3, bean.getA_f());
            pstmt.setInt   (4, bean.getA_g_1());
            pstmt.setInt   (5, bean.getA_g_2());
            pstmt.setInt   (6, bean.getA_g_3());
            pstmt.setInt   (7, bean.getA_g_4());
            pstmt.setString(8, bean.getA_j().trim());
            pstmt.setFloat (9, bean.getO_8_1());
            pstmt.setFloat (10, bean.getO_8_2());
            pstmt.setInt   (11, bean.getO_9_1());
            pstmt.setInt   (12, bean.getO_9_2());
            pstmt.setFloat (13, bean.getO_10());
            pstmt.setFloat (14, bean.getO_12());
            pstmt.setString(15, bean.getO_e().trim());
            pstmt.setInt   (16, bean.getOa_b());
            pstmt.setFloat (17, bean.getOa_c());
			pstmt.setInt   (18, bean.getG_1());
            pstmt.setFloat (19, bean.getG_3());
            pstmt.setFloat (20, bean.getG_5());
            pstmt.setFloat (21, bean.getG_8());
            pstmt.setFloat (22, bean.getG_9_1());
            pstmt.setFloat (23, bean.getG_9_2());
            pstmt.setFloat (24, bean.getG_9_3());
            pstmt.setFloat (25, bean.getG_9_4());
			pstmt.setFloat (26, bean.getG_9_5());
			pstmt.setFloat (27, bean.getG_9_6());
			pstmt.setFloat (28, bean.getG_9_7());
            pstmt.setInt   (29, bean.getG_10());			
            pstmt.setFloat (30, bean.getG_11_1());
            pstmt.setFloat (31, bean.getG_11_2());
            pstmt.setFloat (32, bean.getG_11_3());
            pstmt.setFloat (33, bean.getG_11_4());
			pstmt.setFloat (34, bean.getG_11_5());
			pstmt.setFloat (35, bean.getG_11_6());
			pstmt.setFloat (36, bean.getG_11_7());
			pstmt.setString(37, bean.getCompanys().trim());
            pstmt.setString(38, bean.getQuiry_nm().trim());
            pstmt.setString(39, bean.getQuiry_tel().trim());
            pstmt.setFloat (40, bean.getOa_f());
            pstmt.setFloat (41, bean.getOa_g());
            pstmt.setFloat (42, bean.getOa_h());
            pstmt.setInt   (43, bean.getA_g_5());
			pstmt.setInt   (44, bean.getA_g_6());
			pstmt.setInt   (45, bean.getA_g_7());
			//우량기업
			pstmt.setFloat (46, bean.getA_f_w());
			pstmt.setInt   (47, bean.getA_g_1_w());
            pstmt.setInt   (48, bean.getA_g_2_w());
            pstmt.setInt   (49, bean.getA_g_3_w());
            pstmt.setInt   (50, bean.getA_g_4_w());
			pstmt.setInt   (51, bean.getA_g_5_w());
			pstmt.setInt   (52, bean.getA_g_6_w());
			pstmt.setInt   (53, bean.getA_g_7_w());
			pstmt.setFloat (54, bean.getG_9_11_w());
			//초우량기업
			pstmt.setFloat (55, bean.getA_f_uw());
			pstmt.setInt   (56, bean.getA_g_1_uw());
            pstmt.setInt   (57, bean.getA_g_2_uw());
            pstmt.setInt   (58, bean.getA_g_3_uw());
            pstmt.setInt   (59, bean.getA_g_4_uw());
			pstmt.setInt   (60, bean.getA_g_5_uw());
			pstmt.setInt   (61, bean.getA_g_6_uw());
			pstmt.setInt   (62, bean.getA_g_7_uw());
			pstmt.setFloat (63, bean.getG_9_11_uw());
			//우량,초우량 일반식추가.기존것은 기본식. 적용(목표)마진 20050823
			pstmt.setFloat (64, bean.getG_11_w());
			pstmt.setFloat (65, bean.getG_11_uw());
			//20070323 잔가공통변수 추가
			pstmt.setFloat (66, bean.getJg_c_1());
			pstmt.setFloat (67, bean.getJg_c_2());
			pstmt.setFloat (68, bean.getJg_c_3());
			pstmt.setFloat (69, bean.getJg_c_4());
			pstmt.setFloat (70, bean.getJg_c_5());
			pstmt.setFloat (71, bean.getJg_c_6());
			pstmt.setInt   (72, bean.getJg_c_a());
			pstmt.setInt   (73, bean.getJg_c_b());
			pstmt.setFloat (74, bean.getJg_c_c());
			pstmt.setFloat (75, bean.getJg_c_d());
			//20080108 지역별변수추가
            pstmt.setFloat (76, bean.getO_8_3());
            pstmt.setFloat (77, bean.getO_8_4());
            pstmt.setFloat (78, bean.getO_8_5());
            pstmt.setInt   (79, bean.getO_9_3());
            pstmt.setInt   (80, bean.getO_9_4());
            pstmt.setInt   (81, bean.getO_9_5());
			//20080715
			pstmt.setInt   (82, bean.getJg_c_71());
			pstmt.setInt   (83, bean.getJg_c_72());
			pstmt.setInt   (84, bean.getJg_c_73());
			pstmt.setFloat (85, bean.getJg_c_81());
			pstmt.setFloat (86, bean.getJg_c_82());
			pstmt.setFloat (87, bean.getJg_c_9());
			pstmt.setFloat (88, bean.getJg_c_10());
			pstmt.setFloat (89, bean.getJg_c_11());

			pstmt.setFloat (90, bean.getSh_c_a());
			pstmt.setFloat (91, bean.getSh_c_b1());
			pstmt.setFloat (92, bean.getSh_c_b2());
			pstmt.setFloat (93, bean.getSh_c_d1());
			pstmt.setFloat (94, bean.getSh_c_d2());
			pstmt.setFloat (95, bean.getA_m_1());
			pstmt.setFloat (96, bean.getA_m_2());
			pstmt.setInt   (97, bean.getSh_p_1());
			pstmt.setFloat (98, bean.getSh_p_2());
			pstmt.setFloat (99, bean.getBc_s_i());
			pstmt.setFloat (100, bean.getAx_n());
			pstmt.setFloat (101, bean.getAx_n_c());
			pstmt.setInt   (102, bean.getAx_p());
			pstmt.setFloat (103, bean.getAx_q());
			pstmt.setFloat (104, bean.getAx_r_1());
			pstmt.setFloat (105, bean.getAx_r_2());
			pstmt.setFloat (106, bean.getJg_c_32());
            pstmt.setFloat (107, bean.getO_8_7());
            pstmt.setInt   (108, bean.getO_9_7());
            pstmt.setFloat (109, bean.getO_8_8());
            pstmt.setInt   (110, bean.getO_9_8());
   			pstmt.setFloat (111, bean.getK_su_1());
   			pstmt.setFloat (112, bean.getK_su_2());
   			pstmt.setFloat (113, bean.getA_cb_1());

			pstmt.setFloat (114, bean.getAccid_a());
			pstmt.setFloat (115, bean.getAccid_b());
			pstmt.setFloat (116, bean.getAccid_c());
			pstmt.setFloat (117, bean.getAccid_d());
			pstmt.setFloat (118, bean.getAccid_e());
			pstmt.setFloat (119, bean.getAccid_f());
			pstmt.setFloat (120, bean.getAccid_g());
			pstmt.setFloat (121, bean.getAccid_h());
			pstmt.setFloat (122, bean.getAccid_j());
			pstmt.setFloat (123, bean.getAccid_k());
			pstmt.setFloat (124, bean.getAccid_m());
			pstmt.setFloat (125, bean.getAccid_n());
			pstmt.setFloat (126, bean.getSh_c_k());
			pstmt.setFloat (127, bean.getSh_c_m());
			pstmt.setFloat (128, bean.getJg_c_12());
			pstmt.setInt   (129, bean.getEcar_tax());
			pstmt.setString(130, bean.getEcar_0_yn().trim());
			pstmt.setString(131, bean.getEcar_1_yn().trim());
			pstmt.setString(132, bean.getEcar_2_yn().trim());
			pstmt.setString(133, bean.getEcar_3_yn().trim());
			pstmt.setString(134, bean.getEcar_4_yn().trim());
			pstmt.setString(135, bean.getEcar_5_yn().trim());
			pstmt.setString(136, bean.getEcar_6_yn().trim());
			pstmt.setString(137, bean.getEcar_7_yn().trim());
			pstmt.setString(138, bean.getEcar_8_yn().trim());
			pstmt.setString(139, bean.getEcar_9_yn().trim());
			pstmt.setInt   (140, bean.getEcar_0_amt());
			pstmt.setInt   (141, bean.getEcar_1_amt());
			pstmt.setInt   (142, bean.getEcar_2_amt());
			pstmt.setInt   (143, bean.getEcar_3_amt());
			pstmt.setInt   (144, bean.getEcar_4_amt());
			pstmt.setInt   (145, bean.getEcar_5_amt());
			pstmt.setInt   (146, bean.getEcar_6_amt());
			pstmt.setInt   (147, bean.getEcar_7_amt());
			pstmt.setInt   (148, bean.getEcar_8_amt());
			pstmt.setInt   (149, bean.getEcar_9_amt());
			pstmt.setInt   (150, bean.getEcar_bat_cost());
			pstmt.setFloat (151, bean.getSh_a_m_1());
			pstmt.setFloat (152, bean.getSh_a_m_2());
			pstmt.setInt   (153, bean.getHcar_0_amt());
			pstmt.setInt   (154, bean.getHcar_1_amt());
			pstmt.setInt   (155, bean.getHcar_2_amt());
			pstmt.setInt   (156, bean.getHcar_3_amt());
			pstmt.setInt   (157, bean.getHcar_4_amt());
			pstmt.setInt   (158, bean.getHcar_5_amt());
			pstmt.setInt   (159, bean.getHcar_6_amt());
			pstmt.setInt   (160, bean.getHcar_7_amt());
			pstmt.setInt   (161, bean.getHcar_8_amt());
			pstmt.setInt   (162, bean.getHcar_9_amt());
			pstmt.setInt   (163, bean.getHcar_cost());			
			pstmt.setFloat(164, bean.getA_y_1());
			pstmt.setFloat(165, bean.getA_y_2());
			pstmt.setFloat(166, bean.getA_y_3());
			pstmt.setFloat(167, bean.getA_y_4());
			pstmt.setFloat(168, bean.getA_y_5());
			pstmt.setFloat(169, bean.getA_y_6());
			
			pstmt.setFloat(170, bean.getA_f_2());
			pstmt.setFloat(171, bean.getOa_extra());
			pstmt.setFloat(172, bean.getOa_g_1());
            pstmt.setFloat(173, bean.getOa_g_2());
            pstmt.setFloat(174, bean.getOa_g_3());
            pstmt.setFloat(175, bean.getOa_g_4());
			pstmt.setFloat(176, bean.getOa_g_5());
			pstmt.setFloat(177, bean.getOa_g_6());
			pstmt.setFloat(178, bean.getOa_g_7());
			
			pstmt.setInt   (179, bean.getBr_cons_00());			
			pstmt.setInt   (180, bean.getBr_cons_01());
			pstmt.setInt   (181, bean.getBr_cons_02());
			pstmt.setInt   (182, bean.getBr_cons_03());
			pstmt.setInt   (183, bean.getBr_cons_04());
			
			pstmt.setInt   (184, bean.getBr_cons_10());			
			pstmt.setInt   (185, bean.getBr_cons_11());
			pstmt.setInt   (186, bean.getBr_cons_12());
			pstmt.setInt   (187, bean.getBr_cons_13());
			pstmt.setInt   (188, bean.getBr_cons_14());
			
			pstmt.setInt   (189, bean.getBr_cons_20());			
			pstmt.setInt   (190, bean.getBr_cons_21());
			pstmt.setInt   (191, bean.getBr_cons_22());
			pstmt.setInt   (192, bean.getBr_cons_23());
			pstmt.setInt   (193, bean.getBr_cons_24());
			
			pstmt.setInt   (194, bean.getBr_cons_30());			
			pstmt.setInt   (195, bean.getBr_cons_31());
			pstmt.setInt   (196, bean.getBr_cons_32());
			pstmt.setInt   (197, bean.getBr_cons_33());
			pstmt.setInt   (198, bean.getBr_cons_34());
			
			pstmt.setInt   (199, bean.getBr_cons_40());			
			pstmt.setInt   (200, bean.getBr_cons_41());
			pstmt.setInt   (201, bean.getBr_cons_42());
			pstmt.setInt   (202, bean.getBr_cons_43());
			pstmt.setInt   (203, bean.getBr_cons_44());
			
			pstmt.setString(204, bean.getEcar_10_yn().trim());
			pstmt.setInt   (205, bean.getEcar_10_amt());
			
			pstmt.setInt   (206, bean.getCar_maint_amt1	());			
			pstmt.setInt   (207, bean.getCar_maint_amt2	());
			pstmt.setInt   (208, bean.getCar_maint_amt3	());
			pstmt.setInt   (209, bean.getTint_b_amt		());
			pstmt.setInt   (210, bean.getTint_s_amt		());
			pstmt.setInt   (211, bean.getTint_n_amt		());
			pstmt.setInt   (212, bean.getTint_eb_amt	());
			pstmt.setInt   (213, bean.getTint_bn_amt	());
			pstmt.setInt   (214, bean.getLegal_amt		());
			pstmt.setInt   (215, bean.getCar_maint_amt4	());
			pstmt.setFloat (216, bean.getA_f_3());

			count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstiCommVar]"+se);
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
        return seq;
    }

    /**
     * 공통변수 수정.
     */
    public int updateEstiCommVar(EstiCommVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = ""; 
        int count = 0;
                
        query = " UPDATE ESTI_COMM_VAR SET"+
				" a_f=?, a_g_1=?, a_g_2=?, a_g_3=?, a_g_4=?, a_j=replace(?,'-',''), o_8_1=?, o_8_2=?,"+
				" o_9_1=?, o_9_2=?, o_10=?, o_12=?, o_e=replace(?,'-',''), oa_b=?, oa_c=?, g_1=?, g_3=?, g_5=?,"+
				" g_8=?, g_9_1=?, g_9_2=?, g_9_3=?, g_9_4=?, g_9_5=?, g_9_6=?, g_9_7=?, g_10=?, g_11_1=?, "+
				" g_11_2=?, g_11_3=?, g_11_4=?, g_11_5=?, g_11_6=?, g_11_7=?, companys=?, quiry_nm=?, quiry_tel=?, oa_f=?, "+
				" oa_g=?, oa_h=?, a_g_5=?, a_g_6=?, a_g_7=?, "+
				" a_f_w=?, a_g_1_w=?, a_g_2_w=?, a_g_3_w=?, a_g_4_w=?, a_g_5_w=?, a_g_6_w=?, a_g_7_w=?, g_9_11_w=?, "+			//우량기업추가
				" a_f_uw=?, a_g_1_uw=?, a_g_2_uw=?, a_g_3_uw=?, a_g_4_uw=?, a_g_5_uw=?, a_g_6_uw=?, a_g_7_uw=?, g_9_11_uw=?, "+	//초우량기업추가 20050511.
				" g_11_w=?, g_11_uw=?, "+	//20050823 우량,초우량 일반식추가. 기존것은 기본식으로.
				" jg_c_1=?, jg_c_2=?, jg_c_3=?, jg_c_4=?, jg_c_5=?, jg_c_6=?, jg_c_a=?, jg_c_b=?, jg_c_c=?, jg_c_d=?,"+//20070323 잔가공통변수 추가
				" o_8_3=?, o_8_4=?, o_8_5=?, o_9_3=?, o_9_4=?, o_9_5=?,"+
				" jg_c_71=?, jg_c_72=?, jg_c_73=?, jg_c_81=?, jg_c_82=?, jg_c_9=?, jg_c_10=?, jg_c_11=?,"+
				" sh_c_a=?, sh_c_b1=?, sh_c_b2=?, sh_c_d1=?, sh_c_d2=?, a_m_1=?, a_m_2=?, sh_p_1=?, sh_p_2=?, bc_s_i=?, "+
				" ax_n=?, ax_n_c=?, ax_p=?, ax_q=?, ax_r_1=?, ax_r_2=?, jg_c_32=?, o_8_7=?, o_9_7=?, o_8_8=?, o_9_8=?,	"+
	            " k_su_1=?, k_su_2=?, a_cb_1=?, "+
                " accid_a=?, accid_b=?, accid_c=?, accid_d=?, accid_e=?, accid_f=?, accid_g=?, accid_h=?, accid_j=?, accid_k=?, accid_m=?, accid_n=?, "+ 
				" sh_c_k=?, sh_c_m=?, jg_c_12=?,  "+	 
				" ecar_tax=?, "+	
				" ecar_0_yn=?, ecar_1_yn=?, ecar_2_yn=?, ecar_3_yn=?, ecar_4_yn=?, ecar_5_yn=?, ecar_6_yn=?, ecar_7_yn=?, ecar_8_yn=?, ecar_9_yn=?, "+	
				" ecar_0_amt=?, ecar_1_amt=?, ecar_2_amt=?, ecar_3_amt=?, ecar_4_amt=?, ecar_5_amt=?, ecar_6_amt=?, ecar_7_amt=?, ecar_8_amt=?, ecar_9_amt=?, "+	
                " ecar_bat_cost=?, sh_a_m_1=?, sh_a_m_2=?, "+ 
				" hcar_0_amt=?, hcar_1_amt=?, hcar_2_amt=?, hcar_3_amt=?, hcar_4_amt=?, hcar_5_amt=?, hcar_6_amt=?, hcar_7_amt=?, hcar_8_amt=?, hcar_9_amt=?, hcar_cost=?, "+	
				" a_y_1=?, a_y_2=?, a_y_3=?, a_y_4=?, a_y_5=?, a_y_6=?, "+
				" a_f_2=?, oa_extra=?, oa_g_1=?, oa_g_2=?, oa_g_3=?, oa_g_4=?, oa_g_5=?, oa_g_6=?, oa_g_7=?, "+
				" br_cons_00=?, br_cons_01=?, br_cons_02=?, br_cons_03=?, br_cons_04=?, "+
				" br_cons_10=?, br_cons_11=?, br_cons_12=?, br_cons_13=?, br_cons_14=?, "+
				" br_cons_20=?, br_cons_21=?, br_cons_22=?, br_cons_23=?, br_cons_24=?, "+
				" br_cons_30=?, br_cons_31=?, br_cons_32=?, br_cons_33=?, br_cons_34=?, "+
				" br_cons_40=?, br_cons_41=?, br_cons_42=?, br_cons_43=?, br_cons_44=?, "+
				" ecar_10_yn=?, ecar_10_amt=?,  "+
				" car_maint_amt1=?, car_maint_amt2=?, car_maint_amt3=?, tint_b_amt=?, tint_s_amt=?, tint_n_amt=?, tint_eb_amt=?, tint_bn_amt=?, legal_amt=?, car_maint_amt4=?, a_f_3=? "+
				
				" WHERE a_a=? AND seq=? \n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            pstmt.setFloat (1, bean.getA_f());
            pstmt.setInt   (2, bean.getA_g_1());
            pstmt.setInt   (3, bean.getA_g_2());
            pstmt.setInt   (4, bean.getA_g_3());
            pstmt.setInt   (5, bean.getA_g_4());
            pstmt.setString(6, bean.getA_j().trim());
            pstmt.setFloat (7, bean.getO_8_1());
            pstmt.setFloat (8, bean.getO_8_2());
            pstmt.setInt   (9, bean.getO_9_1());
            pstmt.setInt   (10, bean.getO_9_2());
            pstmt.setFloat (11, bean.getO_10());
            pstmt.setFloat (12, bean.getO_12());
            pstmt.setString(13, bean.getO_e().trim());
            pstmt.setInt   (14, bean.getOa_b());
            pstmt.setFloat (15, bean.getOa_c());
			pstmt.setInt   (16, bean.getG_1());
            pstmt.setFloat (17, bean.getG_3());
            pstmt.setFloat (18, bean.getG_5());
            pstmt.setFloat (19, bean.getG_8());
            pstmt.setFloat (20, bean.getG_9_1());
            pstmt.setFloat (21, bean.getG_9_2());
            pstmt.setFloat (22, bean.getG_9_3());
            pstmt.setFloat (23, bean.getG_9_4());
			pstmt.setFloat (24, bean.getG_9_5());
			pstmt.setFloat (25, bean.getG_9_6());
			pstmt.setFloat (26, bean.getG_9_7());
			pstmt.setInt   (27, bean.getG_10());			
            pstmt.setFloat (28, bean.getG_11_1());
            pstmt.setFloat (29, bean.getG_11_2());
            pstmt.setFloat (30, bean.getG_11_3());
            pstmt.setFloat (31, bean.getG_11_4());
			pstmt.setFloat (32, bean.getG_11_5());
			pstmt.setFloat (33, bean.getG_11_6());
			pstmt.setFloat (34, bean.getG_11_7());
			pstmt.setString(35, bean.getCompanys().trim());
            pstmt.setString(36, bean.getQuiry_nm().trim());
            pstmt.setString(37, bean.getQuiry_tel().trim());
            pstmt.setFloat (38, bean.getOa_f());
            pstmt.setFloat (39, bean.getOa_g());
            pstmt.setFloat (40, bean.getOa_h());
            pstmt.setInt   (41, bean.getA_g_5());
			pstmt.setInt   (42, bean.getA_g_6());
			pstmt.setInt   (43, bean.getA_g_7());
			//우량기업
            pstmt.setFloat (44, bean.getA_f_w());
            pstmt.setInt   (45, bean.getA_g_1_w());
            pstmt.setInt   (46, bean.getA_g_2_w());
            pstmt.setInt   (47, bean.getA_g_3_w());
            pstmt.setInt   (48, bean.getA_g_4_w());
			pstmt.setInt   (49, bean.getA_g_5_w());
			pstmt.setInt   (50, bean.getA_g_6_w());
			pstmt.setInt   (51, bean.getA_g_7_w());
			pstmt.setFloat (52, bean.getG_9_11_w());
			//초우량기업
            pstmt.setFloat (53, bean.getA_f_uw());
            pstmt.setInt   (54, bean.getA_g_1_uw());
            pstmt.setInt   (55, bean.getA_g_2_uw());
            pstmt.setInt   (56, bean.getA_g_3_uw());
            pstmt.setInt   (57, bean.getA_g_4_uw());
			pstmt.setInt   (58, bean.getA_g_5_uw());
			pstmt.setInt   (59, bean.getA_g_6_uw());
			pstmt.setInt   (60, bean.getA_g_7_uw());
			pstmt.setFloat (61, bean.getG_9_11_uw());
			//20050823 우량,초우량 일반식추가. 기존것은 기본식으로.
			pstmt.setFloat (62, bean.getG_11_w());
			pstmt.setFloat (63, bean.getG_11_uw());
			//20070323 잔가공통변수 추가
			pstmt.setFloat (64, bean.getJg_c_1());
			pstmt.setFloat (65, bean.getJg_c_2());
			pstmt.setFloat (66, bean.getJg_c_3());
			pstmt.setFloat (67, bean.getJg_c_4());
			pstmt.setFloat (68, bean.getJg_c_5());
			pstmt.setFloat (69, bean.getJg_c_6());
			pstmt.setInt   (70, bean.getJg_c_a());
			pstmt.setInt   (71, bean.getJg_c_b());
			pstmt.setFloat (72, bean.getJg_c_c());
			pstmt.setFloat (73, bean.getJg_c_d());
			//20080108 지역별 변수 추가
            pstmt.setFloat (74, bean.getO_8_3());
            pstmt.setFloat (75, bean.getO_8_4());
            pstmt.setFloat (76, bean.getO_8_5());
            pstmt.setInt   (77, bean.getO_9_3());
            pstmt.setInt   (78, bean.getO_9_4());
            pstmt.setInt   (79, bean.getO_9_5());
			//20080715
			pstmt.setInt   (80, bean.getJg_c_71());
			pstmt.setInt   (81, bean.getJg_c_72());
			pstmt.setInt   (82, bean.getJg_c_73());
			pstmt.setFloat (83, bean.getJg_c_81());
			pstmt.setFloat (84, bean.getJg_c_82());
			pstmt.setFloat (85, bean.getJg_c_9());
			pstmt.setFloat (86, bean.getJg_c_10());
			pstmt.setFloat (87, bean.getJg_c_11());
			//20080716
			pstmt.setFloat (88, bean.getSh_c_a());
			pstmt.setFloat (89, bean.getSh_c_b1());
			pstmt.setFloat (90, bean.getSh_c_b2());
			pstmt.setFloat (91, bean.getSh_c_d1());
			pstmt.setFloat (92, bean.getSh_c_d2());
			pstmt.setFloat (93, bean.getA_m_1());
			pstmt.setFloat (94, bean.getA_m_2());
			pstmt.setInt   (95, bean.getSh_p_1());
			pstmt.setFloat (96, bean.getSh_p_2());
			pstmt.setFloat (97, bean.getBc_s_i());
			pstmt.setFloat (98, bean.getAx_n());
			pstmt.setFloat (99, bean.getAx_n_c());
			pstmt.setInt   (100, bean.getAx_p());
			pstmt.setFloat (101, bean.getAx_q());
			pstmt.setFloat (102, bean.getAx_r_1());
			pstmt.setFloat (103, bean.getAx_r_2());
			pstmt.setFloat (104, bean.getJg_c_32());
            pstmt.setFloat (105, bean.getO_8_7());
            pstmt.setInt   (106, bean.getO_9_7());
            pstmt.setFloat (107, bean.getO_8_8());
            pstmt.setInt   (108, bean.getO_9_8());
			pstmt.setFloat (109, bean.getK_su_1());
			pstmt.setFloat (110, bean.getK_su_2());
			pstmt.setFloat (111, bean.getA_cb_1());
			pstmt.setFloat (112, bean.getAccid_a());
			pstmt.setFloat (113, bean.getAccid_b());
			pstmt.setFloat (114, bean.getAccid_c());
			pstmt.setFloat (115, bean.getAccid_d());
			pstmt.setFloat (116, bean.getAccid_e());
			pstmt.setFloat (117, bean.getAccid_f());
			pstmt.setFloat (118, bean.getAccid_g());
			pstmt.setFloat (119, bean.getAccid_h());
			pstmt.setFloat (120, bean.getAccid_j());
			pstmt.setFloat (121, bean.getAccid_k());
			pstmt.setFloat (122, bean.getAccid_m());
			pstmt.setFloat (123, bean.getAccid_n());
			pstmt.setFloat (124, bean.getSh_c_k());
			pstmt.setFloat (125, bean.getSh_c_m());
			pstmt.setFloat (126, bean.getJg_c_12());
			pstmt.setInt   (127, bean.getEcar_tax());
			pstmt.setString(128, bean.getEcar_0_yn().trim());
			pstmt.setString(129, bean.getEcar_1_yn().trim());
			pstmt.setString(130, bean.getEcar_2_yn().trim());
			pstmt.setString(131, bean.getEcar_3_yn().trim());
			pstmt.setString(132, bean.getEcar_4_yn().trim());
			pstmt.setString(133, bean.getEcar_5_yn().trim());
			pstmt.setString(134, bean.getEcar_6_yn().trim());
			pstmt.setString(135, bean.getEcar_7_yn().trim());
			pstmt.setString(136, bean.getEcar_8_yn().trim());
			pstmt.setString(137, bean.getEcar_9_yn().trim());
			pstmt.setInt   (138, bean.getEcar_0_amt());
			pstmt.setInt   (139, bean.getEcar_1_amt());
			pstmt.setInt   (140, bean.getEcar_2_amt());
			pstmt.setInt   (141, bean.getEcar_3_amt());
			pstmt.setInt   (142, bean.getEcar_4_amt());
			pstmt.setInt   (143, bean.getEcar_5_amt());
			pstmt.setInt   (144, bean.getEcar_6_amt());
			pstmt.setInt   (145, bean.getEcar_7_amt());
			pstmt.setInt   (146, bean.getEcar_8_amt());
			pstmt.setInt   (147, bean.getEcar_9_amt());
			pstmt.setInt   (148, bean.getEcar_bat_cost());
			pstmt.setFloat (149, bean.getSh_a_m_1());
			pstmt.setFloat (150, bean.getSh_a_m_2());
			pstmt.setInt   (151, bean.getHcar_0_amt());
			pstmt.setInt   (152, bean.getHcar_1_amt());
			pstmt.setInt   (153, bean.getHcar_2_amt());
			pstmt.setInt   (154, bean.getHcar_3_amt());
			pstmt.setInt   (155, bean.getHcar_4_amt());
			pstmt.setInt   (156, bean.getHcar_5_amt());
			pstmt.setInt   (157, bean.getHcar_6_amt());
			pstmt.setInt   (158, bean.getHcar_7_amt());
			pstmt.setInt   (159, bean.getHcar_8_amt());
			pstmt.setInt   (160, bean.getHcar_9_amt());
			pstmt.setInt   (161, bean.getHcar_cost());
			//첨단안전사양
			pstmt.setFloat(162, bean.getA_y_1());
			pstmt.setFloat(163, bean.getA_y_2());
			pstmt.setFloat(164, bean.getA_y_3());
			pstmt.setFloat(165, bean.getA_y_4());
			pstmt.setFloat(166, bean.getA_y_5());
			pstmt.setFloat(167, bean.getA_y_6());
			
			pstmt.setFloat(168, bean.getA_f_2());
			pstmt.setFloat(169, bean.getOa_extra());
			pstmt.setFloat(170, bean.getOa_g_1());
            pstmt.setFloat(171, bean.getOa_g_2());
            pstmt.setFloat(172, bean.getOa_g_3());
            pstmt.setFloat(173, bean.getOa_g_4());
			pstmt.setFloat(174, bean.getOa_g_5());
			pstmt.setFloat(175, bean.getOa_g_6());
			pstmt.setFloat(176, bean.getOa_g_7());
			
			pstmt.setInt   (177, bean.getBr_cons_00());			
			pstmt.setInt   (178, bean.getBr_cons_01());
			pstmt.setInt   (179, bean.getBr_cons_02());
			pstmt.setInt   (180, bean.getBr_cons_03());
			pstmt.setInt   (181, bean.getBr_cons_04());
			
			pstmt.setInt   (182, bean.getBr_cons_10());			
			pstmt.setInt   (183, bean.getBr_cons_11());
			pstmt.setInt   (184, bean.getBr_cons_12());
			pstmt.setInt   (185, bean.getBr_cons_13());
			pstmt.setInt   (186, bean.getBr_cons_14());
			
			pstmt.setInt   (187, bean.getBr_cons_20());			
			pstmt.setInt   (188, bean.getBr_cons_21());
			pstmt.setInt   (189, bean.getBr_cons_22());
			pstmt.setInt   (190, bean.getBr_cons_23());
			pstmt.setInt   (191, bean.getBr_cons_24());
			
			pstmt.setInt   (192, bean.getBr_cons_30());			
			pstmt.setInt   (193, bean.getBr_cons_31());
			pstmt.setInt   (194, bean.getBr_cons_32());
			pstmt.setInt   (195, bean.getBr_cons_33());
			pstmt.setInt   (196, bean.getBr_cons_34());
			
			pstmt.setInt   (197, bean.getBr_cons_40());			
			pstmt.setInt   (198, bean.getBr_cons_41());
			pstmt.setInt   (199, bean.getBr_cons_42());
			pstmt.setInt   (200, bean.getBr_cons_43());
			pstmt.setInt   (201, bean.getBr_cons_44());
			
			pstmt.setString(202, bean.getEcar_10_yn().trim());
			pstmt.setInt   (203, bean.getEcar_10_amt());
			
			pstmt.setInt   (204, bean.getCar_maint_amt1	());			
			pstmt.setInt   (205, bean.getCar_maint_amt2	());
			pstmt.setInt   (206, bean.getCar_maint_amt3	());
			pstmt.setInt   (207, bean.getTint_b_amt		());
			pstmt.setInt   (208, bean.getTint_s_amt		());
			pstmt.setInt   (209, bean.getTint_n_amt		());
			pstmt.setInt   (210, bean.getTint_eb_amt	());
			pstmt.setInt   (211, bean.getTint_bn_amt	());
			pstmt.setInt   (212, bean.getLegal_amt		());
			pstmt.setInt   (213, bean.getCar_maint_amt4	());
			pstmt.setFloat (214, bean.getA_f_3());
			
			pstmt.setString(215, bean.getA_a().trim());
			pstmt.setString(216, bean.getSeq().trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateEstiCommVar]"+se);
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



	//차종변수 관리----------------------------------------------------------------------------------------------------------------

    /**
     * 차종변수 전체조회
     */
    public EstiCarVarBean [] getEstiCarVarList(String gubun1, String gubun2, String gubun3) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from esti_car_var where a_a='"+gubun1+"' and to_number(a_e)<900";


		if(gubun3.equals("")){
//			query += " and seq = (select max(seq) from esti_car_var where a_a='"+gubun1+"')";
			query += " and a_j = (select max(a_j) from esti_car_var where a_a='"+gubun1+"')";
		}else{
			query += " and a_j = replace('"+gubun3+"', '-', '')";
		}

		query += " order by to_number(decode(a_e,'112','101.5','409','399.5',a_e))";

        Collection<EstiCarVarBean> col = new ArrayList<EstiCarVarBean>();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstiCarVarBean bean = new EstiCarVarBean();
				bean.setA_e			(rs.getString("A_E"));
				bean.setA_a			(rs.getString("A_A"));
			    bean.setSeq			(rs.getString("SEQ"));
			    bean.setA_c			(rs.getString("A_C"));
			    bean.setM_st		(rs.getString("M_ST"));
			    bean.setS_sd		(rs.getString("S_SD"));
			    bean.setCars		(rs.getString("CARS"));
			    bean.setA_j			(rs.getString("A_J"));
			    bean.setS_f			(rs.getFloat("S_F"));
				bean.setO_2			(rs.getFloat("O_2"));
			    bean.setO_3			(rs.getInt("O_3"));
				bean.setO_4			(rs.getInt("O_4"));
				bean.setO_5			(rs.getFloat("O_5"));
				bean.setO_6			(rs.getFloat("O_6"));
				bean.setO_7			(rs.getFloat("O_7"));
				bean.setO_11		(rs.getFloat("O_11"));
				bean.setO_13_1		(rs.getFloat("O_13_1"));
				bean.setO_13_2		(rs.getFloat("O_13_2"));
				bean.setO_13_3		(rs.getFloat("O_13_3"));
				bean.setO_13_4		(rs.getFloat("O_13_4"));
				bean.setO_13_5		(rs.getFloat("O_13_5"));
				bean.setO_13_6		(rs.getFloat("O_13_6"));
				bean.setO_13_7		(rs.getFloat("O_13_7"));
				bean.setO_14		(rs.getInt("O_14"));
				bean.setO_15		(rs.getInt("O_15"));
				bean.setO_a			(rs.getInt("O_A"));
				bean.setO_b			(rs.getInt("O_B"));
				bean.setO_c			(rs.getInt("O_C"));
				bean.setO_d			(rs.getInt("O_D"));
				bean.setOa_d		(rs.getInt("OA_D"));
				bean.setG_2			(rs.getInt("G_2"));
				bean.setG_4			(rs.getFloat("G_4"));
				bean.setG_6			(rs.getInt("G_6"));
				bean.setG_7			(rs.getInt("G_7"));
				bean.setOa_e_1		(rs.getInt("OA_E_1"));
				bean.setOa_e_2		(rs.getInt("OA_E_2"));
				bean.setOa_e_3		(rs.getInt("OA_E_3"));
				bean.setOa_e_4		(rs.getInt("OA_E_4"));
				bean.setOa_e_5		(rs.getInt("OA_E_5"));
				bean.setOa_e_6		(rs.getInt("OA_E_6"));
				bean.setOa_e_7		(rs.getInt("OA_E_7"));
				bean.setO_6_1		(rs.getFloat("O_6_1"));
				bean.setO_6_2_1		(rs.getFloat("O_6_2_1"));
				bean.setO_6_2_2		(rs.getFloat("O_6_2_2"));
				bean.setO_6_3		(rs.getFloat("O_6_3"));
				bean.setO_6_4		(rs.getFloat("O_6_4"));
				bean.setO_6_5		(rs.getFloat("O_6_5"));
				bean.setO_6_7		(rs.getFloat("O_6_7"));
				bean.setO_6_8		(rs.getFloat("O_6_8"));
				bean.setO_e			(rs.getFloat("O_E"));
				bean.setO_f			(rs.getFloat("O_F"));
				bean.setO_g			(rs.getFloat("O_G"));
				bean.setSh_o_6_1	(rs.getFloat("SH_O_6_1"));
				bean.setSh_o_6_2_1	(rs.getFloat("SH_O_6_2_1"));
				bean.setSh_o_6_2_2	(rs.getFloat("SH_O_6_2_2"));
				bean.setSh_o_6_3	(rs.getFloat("SH_O_6_3"));
				bean.setSh_o_6_4	(rs.getFloat("SH_O_6_4"));
				bean.setSh_o_6_5	(rs.getFloat("SH_O_6_5"));
				bean.setSh_o_6_7	(rs.getFloat("SH_O_6_7"));
				bean.setSh_o_6_8	(rs.getFloat("SH_O_6_8"));
				bean.setG_2_c		(rs.getInt("G_2_C"));
				bean.setG_3			(rs.getFloat("G_3"));
				bean.setG_3_c		(rs.getFloat("G_3_C"));
				bean.setG_4_b		(rs.getFloat("G_4_B"));
				bean.setG_5			(rs.getFloat("G_5"));
				bean.setG_5_b		(rs.getFloat("G_5_B"));
				bean.setK_tu		(rs.getFloat("K_TU"));
				bean.setK_tu_b		(rs.getFloat("K_TU_B"));
				bean.setK_pu		(rs.getInt("K_PU"));
				bean.setK_pu_b		(rs.getInt("K_PU_B"));
				bean.setO_5_c		(rs.getFloat("O_5_C"));
				bean.setK_gin		(rs.getInt("K_GIN"));
				bean.setSh_g_2		(rs.getInt("SH_G_2"));


				col.add(bean);
            }
            rs.close();
            pstmt.close();



        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiCarVarList]"+se);
			System.out.println("[EstiDatabase:getEstiCarVarList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstiCarVarBean[])col.toArray(new EstiCarVarBean[0]);
    }


    /**
	 *	차종변수별 리스트
	 */
	public Vector getEstiCarVarList(String gubun1, String gubun2, String gubun3, String var_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " select a_a, a_e, seq, "+var_nm+" as value from esti_car_var where a_a='"+gubun1+"' and to_number(a_e)<900";


		if(gubun3.equals("")){
			query += " and seq = (select max(seq) from esti_comm_var where a_a='"+gubun1+"')";
		}else{
			query += " and a_j = replace('"+gubun3+"', '-', '')";
		}

		query += " order by to_number(decode(a_e,'112','101.5','409','399.5',a_e))";

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
			System.out.println("[EstiDatabase:getEstiCarVarList:Vector]"+e);
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
     * 차종변수 조회-세부내용
     */
    public EstiCarVarBean getEstiCarVarCase(String a_e, String a_a, String seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiCarVarBean bean = new EstiCarVarBean();
        String query = "";
        
        query = " select * from esti_car_var where a_e='"+a_e+"' and a_a='"+a_a+"'";
		
		
		if(seq.equals("")){
			query += " and seq = (select max(seq) from esti_car_var where a_e='"+a_e+"' and a_a='"+a_a+"')";
		}else{
			query += " and lpad(seq,3,'00')=lpad('"+seq+"',3,'00')";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setA_e			(rs.getString("A_E"));
				bean.setA_a			(rs.getString("A_A"));
			    bean.setSeq			(rs.getString("SEQ"));
			    bean.setA_c			(rs.getString("A_C"));
			    bean.setM_st		(rs.getString("M_ST"));
			    bean.setS_sd		(rs.getString("S_SD"));
			    bean.setCars		(rs.getString("CARS"));
			    bean.setA_j			(rs.getString("A_J"));
			    bean.setS_f			(rs.getFloat("S_F"));
				bean.setO_2			(rs.getFloat("O_2"));
			    bean.setO_3			(rs.getInt("O_3"));
				bean.setO_4			(rs.getInt("O_4"));
				bean.setO_5			(rs.getFloat("O_5"));
				bean.setO_6			(rs.getFloat("O_6"));
				bean.setO_7			(rs.getFloat("O_7"));
				bean.setO_11		(rs.getFloat("O_11"));
				bean.setO_13_1		(rs.getFloat("O_13_1"));
				bean.setO_13_2		(rs.getFloat("O_13_2"));
				bean.setO_13_3		(rs.getFloat("O_13_3"));
				bean.setO_14		(rs.getInt("O_14"));
				bean.setO_15		(rs.getInt("O_15"));
				bean.setO_a			(rs.getInt("O_A"));
				bean.setO_b			(rs.getInt("O_B"));
				bean.setO_c			(rs.getInt("O_C"));
				bean.setO_d			(rs.getInt("O_D"));
				bean.setOa_d		(rs.getInt("OA_D"));
				bean.setG_2			(rs.getInt("G_2"));
				bean.setG_4			(rs.getFloat("G_4"));
				bean.setG_6			(rs.getInt("G_6"));
				bean.setG_7			(rs.getInt("G_7"));
				bean.setOa_e_1		(rs.getInt("OA_E_1"));
				bean.setOa_e_2		(rs.getInt("OA_E_2"));
				bean.setOa_e_3		(rs.getInt("OA_E_3"));
				bean.setOa_e_4		(rs.getInt("OA_E_4"));
				bean.setOa_e_5		(rs.getInt("OA_E_5"));
				bean.setOa_e_6		(rs.getInt("OA_E_6"));
				bean.setOa_e_7		(rs.getInt("OA_E_7"));
				bean.setO_13_4		(rs.getFloat("O_13_4"));
				bean.setO_13_5		(rs.getFloat("O_13_5"));
				bean.setO_13_6		(rs.getFloat("O_13_6"));
				bean.setO_13_7		(rs.getFloat("O_13_7"));
				bean.setO_6_1		(rs.getFloat("O_6_1"));
				bean.setO_6_2_1		(rs.getFloat("O_6_2_1"));
				bean.setO_6_2_2		(rs.getFloat("O_6_2_2"));
				bean.setO_6_3		(rs.getFloat("O_6_3"));
				bean.setO_6_4		(rs.getFloat("O_6_4"));
				bean.setO_6_5		(rs.getFloat("O_6_5"));
				bean.setO_6_7		(rs.getFloat("O_6_7"));
				bean.setO_6_8		(rs.getFloat("O_6_8"));
				bean.setO_e			(rs.getFloat("O_E"));
				bean.setO_f			(rs.getFloat("O_F"));
				bean.setO_g			(rs.getFloat("O_G"));
				bean.setSh_o_6_1	(rs.getFloat("SH_O_6_1"));
				bean.setSh_o_6_2_1	(rs.getFloat("SH_O_6_2_1"));
				bean.setSh_o_6_2_2	(rs.getFloat("SH_O_6_2_2"));
				bean.setSh_o_6_3	(rs.getFloat("SH_O_6_3"));
				bean.setSh_o_6_4	(rs.getFloat("SH_O_6_4"));
				bean.setSh_o_6_5	(rs.getFloat("SH_O_6_5"));
				bean.setSh_o_6_7	(rs.getFloat("SH_O_6_7"));
				bean.setSh_o_6_8	(rs.getFloat("SH_O_6_8"));
				bean.setG_2_c		(rs.getInt("G_2_C"));
				bean.setG_3			(rs.getFloat("G_3"));
				bean.setG_3_c		(rs.getFloat("G_3_C"));
				bean.setG_4_b		(rs.getFloat("G_4_B"));
				bean.setG_5			(rs.getFloat("G_5"));
				bean.setG_5_b		(rs.getFloat("G_5_B"));
				bean.setK_tu		(rs.getFloat("K_TU"));
				bean.setK_tu_b		(rs.getFloat("K_TU_B"));
				bean.setK_pu		(rs.getInt("K_PU"));
				bean.setK_pu_b		(rs.getInt("K_PU_B"));
				bean.setO_5_c		(rs.getFloat("O_5_C"));
				bean.setK_gin		(rs.getInt("K_GIN"));
				bean.setSh_g_2		(rs.getInt("SH_G_2"));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiCarVarCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 차종변수 조회-세부내용
     */
    public EstiCarVarBean getEstiCarVarCase(String a_e, String a_a, String seq, String a_j) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiCarVarBean bean = new EstiCarVarBean();
        String query = "";
        
        query = " select * from esti_car_var where a_e='"+a_e+"' and a_a='"+a_a+"'";
		
		if(a_j.equals("")){
			if(seq.equals("")){
				query += " and seq = (select max(seq) from esti_car_var where a_e='"+a_e+"' and a_a='"+a_a+"')";
			}else{
				query += " and lpad(seq,3,'00')=lpad('"+seq+"',3,'00')";
			}
		}else{
				query += " and a_j=replace('"+a_j+"','-','')";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setA_e			(rs.getString("A_E"));
				bean.setA_a			(rs.getString("A_A"));
			    bean.setSeq			(rs.getString("SEQ"));
			    bean.setA_c			(rs.getString("A_C"));
			    bean.setM_st		(rs.getString("M_ST"));
			    bean.setS_sd		(rs.getString("S_SD"));
			    bean.setCars		(rs.getString("CARS"));
			    bean.setA_j			(rs.getString("A_J"));
			    bean.setS_f			(rs.getFloat("S_F"));
				bean.setO_2			(rs.getFloat("O_2"));
			    bean.setO_3			(rs.getInt("O_3"));
				bean.setO_4			(rs.getInt("O_4"));
				bean.setO_5			(rs.getFloat("O_5"));
				bean.setO_6			(rs.getFloat("O_6"));
				bean.setO_7			(rs.getFloat("O_7"));
				bean.setO_11		(rs.getFloat("O_11"));
				bean.setO_13_1		(rs.getFloat("O_13_1"));
				bean.setO_13_2		(rs.getFloat("O_13_2"));
				bean.setO_13_3		(rs.getFloat("O_13_3"));
				bean.setO_14		(rs.getInt("O_14"));
				bean.setO_15		(rs.getInt("O_15"));
				bean.setO_a			(rs.getInt("O_A"));
				bean.setO_b			(rs.getInt("O_B"));
				bean.setO_c			(rs.getInt("O_C"));
				bean.setO_d			(rs.getInt("O_D"));
				bean.setOa_d		(rs.getInt("OA_D"));
				bean.setG_2			(rs.getInt("G_2"));
				bean.setG_4			(rs.getFloat("G_4"));
				bean.setG_6			(rs.getInt("G_6"));
				bean.setG_7			(rs.getInt("G_7"));
				bean.setOa_e_1		(rs.getInt("OA_E_1"));
				bean.setOa_e_2		(rs.getInt("OA_E_2"));
				bean.setOa_e_3		(rs.getInt("OA_E_3"));
				bean.setOa_e_4		(rs.getInt("OA_E_4"));
				bean.setOa_e_5		(rs.getInt("OA_E_5"));
				bean.setOa_e_6		(rs.getInt("OA_E_6"));
				bean.setOa_e_7		(rs.getInt("OA_E_7"));
				bean.setO_13_4		(rs.getFloat("O_13_4"));
				bean.setO_13_5		(rs.getFloat("O_13_5"));
				bean.setO_13_6		(rs.getFloat("O_13_6"));
				bean.setO_13_7		(rs.getFloat("O_13_7"));
				bean.setO_6_1		(rs.getFloat("O_6_1"));
				bean.setO_6_2_1		(rs.getFloat("O_6_2_1"));
				bean.setO_6_2_2		(rs.getFloat("O_6_2_2"));
				bean.setO_6_3		(rs.getFloat("O_6_3"));
				bean.setO_6_4		(rs.getFloat("O_6_4"));
				bean.setO_6_5		(rs.getFloat("O_6_5"));
				bean.setO_6_7		(rs.getFloat("O_6_7"));
				bean.setO_6_8		(rs.getFloat("O_6_8"));
				bean.setO_e			(rs.getFloat("O_E"));
				bean.setO_f			(rs.getFloat("O_F"));
				bean.setO_g			(rs.getFloat("O_G"));
				bean.setSh_o_6_1	(rs.getFloat("SH_O_6_1"));
				bean.setSh_o_6_2_1	(rs.getFloat("SH_O_6_2_1"));
				bean.setSh_o_6_2_2	(rs.getFloat("SH_O_6_2_2"));
				bean.setSh_o_6_3	(rs.getFloat("SH_O_6_3"));
				bean.setSh_o_6_4	(rs.getFloat("SH_O_6_4"));
				bean.setSh_o_6_5	(rs.getFloat("SH_O_6_5"));
				bean.setSh_o_6_7	(rs.getFloat("SH_O_6_7"));
				bean.setSh_o_6_8	(rs.getFloat("SH_O_6_8"));
				bean.setG_2_c		(rs.getInt("G_2_C"));
				bean.setG_3			(rs.getFloat("G_3"));
				bean.setG_3_c		(rs.getFloat("G_3_C"));
				bean.setG_4_b		(rs.getFloat("G_4_B"));
				bean.setG_5			(rs.getFloat("G_5"));
				bean.setG_5_b		(rs.getFloat("G_5_B"));
				bean.setK_tu		(rs.getFloat("K_TU"));
				bean.setK_tu_b		(rs.getFloat("K_TU_B"));
				bean.setK_pu		(rs.getInt("K_PU"));
				bean.setK_pu_b		(rs.getInt("K_PU_B"));
				bean.setO_5_c		(rs.getFloat("O_5_C"));
				bean.setK_gin		(rs.getInt("K_GIN"));
				bean.setSh_g_2		(rs.getInt("SH_G_2"));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiCarVarCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
     * 차종변수 열 등록.
     */
    public String insertEstiCarVar(EstiCarVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
        String query1 = "";
		String query2 = "";
		String seq = "";
        int count = 0;

		query1 = " SELECT nvl(lpad(max(to_number(SEQ))+1,3,'00'),'001') FROM ESTI_CAR_VAR where a_e='"+bean.getA_e().trim()+"' and a_a='"+bean.getA_a().trim()+"'";
			
        query2 = " INSERT INTO ESTI_CAR_VAR"+
				" (a_e, a_a, seq, a_c, m_st, s_sd, cars, a_j, s_f, o_2,"+
				"  o_3, o_4, o_5, o_6, o_7, o_11, o_13_1, o_13_2, o_13_3, o_14,"+
				"  o_15, o_a, o_b, o_c, o_d, oa_d, g_2, g_4, g_6, g_7, oa_e_1, oa_e_2, oa_e_3, oa_e_4, oa_e_5, oa_e_6, oa_e_7, o_13_4, o_13_5, o_13_6, o_13_7,"+
				"  o_6_1, o_6_2_1, o_6_2_2, o_6_3, o_6_4, o_6_5, o_e, o_f, o_g, "+
				"  sh_o_6_1, sh_o_6_2_1, sh_o_6_2_2, sh_o_6_3, sh_o_6_4, sh_o_6_5, o_6_7, sh_o_6_7, o_6_8, sh_o_6_8, "+
				"  g_2_c, g_3, g_3_c, g_4_b, g_5, g_5_b, k_tu, k_tu_b, k_pu, k_pu_b, o_5_c, k_gin, sh_g_2 "+
				"  )"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, replace(?,'-',''), ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"	?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "+
				" )";
           
       try{
            con.setAutoCommit(false);

            //seq 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query1);
            if(rs.next())
            	seq = rs.getString(1);
            rs.close();
      		stmt.close();

            pstmt = con.prepareStatement(query2);
            pstmt.setString(1, bean.getA_e().trim());
			pstmt.setString(2, bean.getA_a().trim());
            pstmt.setString(3, seq.trim());
            pstmt.setString(4, bean.getA_c().trim());
			pstmt.setString(5, bean.getM_st().trim());
			pstmt.setString(6, bean.getS_sd().trim());
			pstmt.setString(7, bean.getCars().trim());
            pstmt.setString(8, bean.getA_j().trim());
            pstmt.setFloat (9, bean.getS_f());
            pstmt.setFloat (10, bean.getO_2());
            pstmt.setInt   (11, bean.getO_3());
            pstmt.setInt   (12, bean.getO_4());
            pstmt.setFloat (13, bean.getO_5());
            pstmt.setFloat (14, bean.getO_6());
            pstmt.setFloat (15, bean.getO_7());
            pstmt.setFloat (16, bean.getO_11());
            pstmt.setFloat (17, bean.getO_13_1());
            pstmt.setFloat (18, bean.getO_13_2());
            pstmt.setFloat (19, bean.getO_13_3());
            pstmt.setInt   (20, bean.getO_14());
            pstmt.setInt   (21, bean.getO_15());
            pstmt.setInt   (22, bean.getO_a());
            pstmt.setInt   (23, bean.getO_b());
            pstmt.setInt   (24, bean.getO_c());
            pstmt.setInt   (25, bean.getO_d());
            pstmt.setInt   (26, bean.getOa_d());
            pstmt.setInt   (27, bean.getG_2());
            pstmt.setFloat (28, bean.getG_4());
            pstmt.setInt   (29, bean.getG_6());
            pstmt.setInt   (30, bean.getG_7());
            pstmt.setInt   (31, bean.getOa_e_1());
            pstmt.setInt   (32, bean.getOa_e_2());
			pstmt.setInt   (33, bean.getOa_e_3());
			pstmt.setInt   (34, bean.getOa_e_4());
			pstmt.setInt   (35, bean.getOa_e_5());
			pstmt.setInt   (36, bean.getOa_e_6());
			pstmt.setInt   (37, bean.getOa_e_7());
            pstmt.setFloat (38, bean.getO_13_4());
			pstmt.setFloat (39, bean.getO_13_5());
			pstmt.setFloat (40, bean.getO_13_6());
			pstmt.setFloat (41, bean.getO_13_7());
            pstmt.setFloat (42, bean.getO_6_1());
            pstmt.setFloat (43, bean.getO_6_2_1());
            pstmt.setFloat (44, bean.getO_6_2_2());
            pstmt.setFloat (45, bean.getO_6_3());
            pstmt.setFloat (46, bean.getO_6_4());
            pstmt.setFloat (47, bean.getO_6_5());
            pstmt.setFloat (48, bean.getO_e());
            pstmt.setFloat (49, bean.getO_f());
            pstmt.setFloat (50, bean.getO_g());
            pstmt.setFloat (51, bean.getSh_o_6_1());
            pstmt.setFloat (52, bean.getSh_o_6_2_1());
            pstmt.setFloat (53, bean.getSh_o_6_2_2());
            pstmt.setFloat (54, bean.getSh_o_6_3());
            pstmt.setFloat (55, bean.getSh_o_6_4());
            pstmt.setFloat (56, bean.getSh_o_6_5());
            pstmt.setFloat (57, bean.getO_6_7());
            pstmt.setFloat (58, bean.getSh_o_6_7());
            pstmt.setFloat (59, bean.getO_6_8());
            pstmt.setFloat (60, bean.getSh_o_6_8());
			pstmt.setInt   (61, bean.getG_2_c		());
            pstmt.setFloat (62, bean.getG_3			());
			pstmt.setFloat (63, bean.getG_3_c		());
			pstmt.setFloat (64, bean.getG_4_b		());
			pstmt.setFloat (65, bean.getG_5			());
            pstmt.setFloat (66, bean.getG_5_b		());
            pstmt.setFloat (67, bean.getK_tu		());
            pstmt.setFloat (68, bean.getK_tu_b		());
            pstmt.setInt   (69, bean.getK_pu		());
            pstmt.setInt   (70, bean.getK_pu_b		());
			pstmt.setFloat (71, bean.getO_5_c		());
			pstmt.setInt   (72, bean.getK_gin		());
			pstmt.setInt   (73, bean.getSh_g_2		());


			count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstiCarVar]"+se);
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
        return seq;
    }

    /**
     * 차종변수 열 수정.
     */
    public int updateEstiCarVar(EstiCarVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE ESTI_CAR_VAR SET"+
				" a_c=?, m_st=?, s_sd=?, cars=?, a_j=replace(?,'-',''), s_f=?, o_2=?,"+
				" o_3=?, o_4=?, o_5=?, o_6=?, o_7=?, o_11=?, o_13_1=?, o_13_2=?, o_13_3=?, o_14=?,"+
				" o_15=?, o_a=?, o_b=?, o_c=?, o_d=?, oa_d=?, g_2=?, g_4=?, g_6=?, g_7=?, oa_e_1=?, oa_e_2=?, oa_e_3=?, oa_e_4=?, oa_e_5=?, oa_e_6=?, oa_e_7=?, "+
				" o_13_4=?, o_13_5=?, o_13_6=?, o_13_7=?"+
				" WHERE a_e=? AND a_a=? AND seq=?\n";
           
	   try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            pstmt.setString(1, bean.getA_c().trim());
			pstmt.setString(2, bean.getM_st().trim());
			pstmt.setString(3, bean.getS_sd().trim());
			pstmt.setString(4, bean.getCars().trim());
            pstmt.setString(5, bean.getA_j().trim());
            pstmt.setFloat (6, bean.getS_f());
            pstmt.setFloat (7, bean.getO_2());
            pstmt.setInt   (8, bean.getO_3());
            pstmt.setInt   (9, bean.getO_4());
            pstmt.setFloat (10, bean.getO_5());
            pstmt.setFloat (11, bean.getO_6());
            pstmt.setFloat (12, bean.getO_7());
            pstmt.setFloat (13, bean.getO_11());
            pstmt.setFloat (14, bean.getO_13_1());
            pstmt.setFloat (15, bean.getO_13_2());
            pstmt.setFloat (16, bean.getO_13_3());
            pstmt.setInt   (17, bean.getO_14());
            pstmt.setInt   (18, bean.getO_15());
            pstmt.setInt   (19, bean.getO_a());
            pstmt.setInt   (20, bean.getO_b());
            pstmt.setInt   (21, bean.getO_c());
            pstmt.setInt   (22, bean.getO_d());
            pstmt.setInt   (23, bean.getOa_d());
            pstmt.setInt   (24, bean.getG_2());
            pstmt.setFloat (25, bean.getG_4());
            pstmt.setInt   (26, bean.getG_6());
            pstmt.setInt   (27, bean.getG_7());
            pstmt.setInt   (28, bean.getOa_e_1());
            pstmt.setInt   (29, bean.getOa_e_2());
			pstmt.setInt   (30, bean.getOa_e_3());
			pstmt.setInt   (31, bean.getOa_e_4());
			pstmt.setInt   (32, bean.getOa_e_5());
			pstmt.setInt   (33, bean.getOa_e_6());
			pstmt.setInt   (34, bean.getOa_e_7());
            pstmt.setFloat (35, bean.getO_13_4());
			pstmt.setFloat (36, bean.getO_13_5());
			pstmt.setFloat (37, bean.getO_13_6());
			pstmt.setFloat (38, bean.getO_13_7());
            pstmt.setString(39, bean.getA_e().trim());
			pstmt.setString(40, bean.getA_a().trim());
            pstmt.setString(41, bean.getSeq().trim());
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateEstiCarVar]"+se);
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

    /**
     * 차종변수별 행 수정 
     */
    public int updateEstiCarVarList(String var_cd, String var, String value, String d_type) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

		if(d_type.equals("f")){
			query = "update esti_car_var set "+var_cd+"="+AddUtil.parseFloat(value)+" where a_a='"+var.substring(0,1)+"' and seq='"+var.substring(1,4)+"' and a_e='"+var.substring(4)+"'";
		}else if(d_type.equals("i")){
			query = "update esti_car_var set "+var_cd+"="+AddUtil.parseDigit(value)+" where a_a='"+var.substring(0,1)+"' and seq='"+var.substring(1,4)+"' and a_e='"+var.substring(4)+"'";
		}else{
			query = "update esti_car_var set "+var_cd+"="+value+"                     where a_a='"+var.substring(0,1)+"' and seq='"+var.substring(1,4)+"' and a_e='"+var.substring(4)+"'";
		}

	   try{
            con.setAutoCommit(false);                        
            pstmt = con.prepareStatement(query);  
            count = pstmt.executeUpdate();             
            pstmt.close();
            con.commit();
        }catch(SQLException se){
            try{
			System.out.println("[EstiDatabase:updateEstiCarVarList]"+se);
			System.out.println("[EstiDatabase:updateEstiCarVarList]"+query);
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


	//계산식변수 관리----------------------------------------------------------------------------------------------------------------


    /**
     * 계산식변수 전체조회
     */
    public EstiSikVarBean [] getEstiSikVarList(String gubun1, String gubun2, String gubun3) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select a.* from esti_sik_var a"+
				" where a.seq = (select max(seq) from esti_sik_var where var_cd=a.var_cd)"+
				" and substr(a.var_cd,1,3) not in ('bus','dly','fin','ins', 'ban') "+
				" order by a.var_cd";

        Collection<EstiSikVarBean> col = new ArrayList<EstiSikVarBean>();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstiSikVarBean bean = new EstiSikVarBean();
				bean.setA_a(rs.getString("A_A"));
			    bean.setSeq(rs.getString("SEQ"));
			    bean.setVar_cd(rs.getString("VAR_CD"));
			    bean.setVar_nm(rs.getString("VAR_NM"));
			    bean.setVar_sik(rs.getString("VAR_SIK"));
			    bean.setA_j(rs.getString("A_J"));
				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiSikVarList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstiSikVarBean[])col.toArray(new EstiSikVarBean[0]);
    }

    /**
     * 계산식변수 전체조회
     */
    public EstiSikVarBean [] getEstiSikVarList(String var_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from esti_sik_var";

		if(!var_cd.equals("")) query += " where var_cd like '%"+var_cd+"%'";

		if(var_cd.equals("dly1_bus") || var_cd.equals("dly2_bus"))			query += " order by TO_NUMBER(SUBSTR(var_cd,9))";
		else																query += " order by var_cd";
	
        Collection<EstiSikVarBean> col = new ArrayList<EstiSikVarBean>();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstiSikVarBean bean = new EstiSikVarBean();
				bean.setA_a(rs.getString("A_A"));
			    bean.setSeq(rs.getString("SEQ"));
			    bean.setVar_cd(rs.getString("VAR_CD"));
			    bean.setVar_nm(rs.getString("VAR_NM"));
			    bean.setVar_sik(rs.getString("VAR_SIK"));
			    bean.setA_j(rs.getString("A_J"));
				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiSikVarList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstiSikVarBean[])col.toArray(new EstiSikVarBean[0]);
    }
	
	/**
     * 계산식변수 조회-리스트에서
     */
    public EstiSikVarBean getEstiSikVarList2(String gubun1, String gubun2, String gubun3) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiSikVarBean bean = new EstiSikVarBean();
        String query = "";
        
        query = " select * from esti_sik_var where a_a='1'";


		if(gubun3.equals("")){
			query += " and seq = (select max(seq) from esti_sik_var where a_a='1')";
		}else{
			query += " and a_j = replace('"+gubun3+"', '-', '')";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setA_a(rs.getString("A_A"));
			    bean.setSeq(rs.getString("SEQ"));
			    bean.setVar_cd(rs.getString("VAR_CD"));
			    bean.setVar_nm(rs.getString("VAR_NM"));
			    bean.setVar_sik(rs.getString("VAR_SIK"));
			    bean.setA_j(rs.getString("A_J"));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiSikVarList2]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 계산식변수 조회-세부내용
     */
    public EstiSikVarBean getEstiSikVarCase(String a_a, String seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiSikVarBean bean = new EstiSikVarBean();
        String query = "";
        
        query = " select * from esti_sik_var where a_a='"+a_a+"'";

		if(seq.equals("")){
			query += " and seq = (select max(seq) from esti_sik_var where a_a='"+a_a+"')";
		}else{
			query += " and seq='"+seq+"'";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            if(rs.next()){
				bean.setA_a(rs.getString("A_A"));
			    bean.setSeq(rs.getString("SEQ"));
			    bean.setVar_cd(rs.getString("VAR_CD"));
			    bean.setVar_nm(rs.getString("VAR_NM"));
			    bean.setVar_sik(rs.getString("VAR_SIK"));
			    bean.setA_j(rs.getString("A_J"));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiSikVarCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 계산식변수 조회-세부내용
     */
    public EstiSikVarBean getEstiSikVarCaseDly(String a_a, String seq, String var_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiSikVarBean bean = new EstiSikVarBean();
        String query = "";
        
        query = " select * from esti_sik_var where a_a='"+a_a+"' and var_cd='"+var_cd+"'";

		if(seq.equals("")){
			query += " and seq = (select max(seq) from esti_sik_var where a_a='"+a_a+"')";
		}else{
			query += " and seq='"+seq+"'";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            if(rs.next()){
				bean.setA_a(rs.getString("A_A"));
			    bean.setSeq(rs.getString("SEQ"));
			    bean.setVar_cd(rs.getString("VAR_CD"));
			    bean.setVar_nm(rs.getString("VAR_NM"));
			    bean.setVar_sik(rs.getString("VAR_SIK"));
			    bean.setA_j(rs.getString("A_J"));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiSikVarCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
     * 계산식변수 등록.
     */
    public String insertEstiSikVar(EstiSikVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
        String query1 = "";
		String query2 = "";
		String seq = "";
        int count = 0;

		query1 = " SELECT nvl(lpad(max(to_number(SEQ))+1,2,'0'),'01') FROM ESTI_SIK_VAR ";
			
        query2 = " INSERT INTO ESTI_SIK_VAR"+
				" (a_a, seq, var_cd, var_nm, var_sik, a_j)"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, replace(?,'-',''))";
           
       try{
            con.setAutoCommit(false);

            //seq 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query1);
            if(rs.next())
            	seq = rs.getString(1);
            rs.close();
      		stmt.close();

            pstmt = con.prepareStatement(query2);
            pstmt.setString(1, bean.getA_a().trim());
            pstmt.setString(2, seq.trim());
            pstmt.setString(3, bean.getVar_cd().trim());
            pstmt.setString(4, bean.getVar_nm().trim());
            pstmt.setString(5, bean.getVar_sik().trim());
			pstmt.setString(6, bean.getA_j().trim());

			count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstiSikVar]"+se);
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
        return seq;
    }

    /**
     * 계산식변수 수정.
     */
    public int updateEstiSikVar(EstiSikVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE ESTI_SIK_VAR SET"+
				" var_nm=?, var_sik=?, a_j=replace(?,'-','')"+
				" WHERE a_a=? AND seq=? AND var_cd=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query); 
            pstmt.setString(1, bean.getVar_nm().trim());
            pstmt.setString(2, bean.getVar_sik().trim());
			pstmt.setString(3, bean.getA_j().trim());
            pstmt.setString(4, bean.getA_a().trim());
            pstmt.setString(5, bean.getSeq().trim());
            pstmt.setString(6, bean.getVar_cd().trim());
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateEstiSikVar]"+se);
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


	//견적메모----------------------------------------------------------------------------------------------------------

	/**
     * 견적서 메모 ( 2001/12/28 ) - Kim JungTae
     */
    private EstiMBean makeEstiMBean(ResultSet results) throws DatabaseException {

        try {
            EstiMBean bean = new EstiMBean();

			bean.setEst_id(results.getString("EST_ID"));
		    bean.setUser_id(results.getString("USER_ID"));
		    bean.setSeq_no(results.getInt("SEQ_NO"));
		    bean.setSub(results.getString("SUB"));
		    bean.setNote(results.getString("NOTE"));
		    bean.setReg_dt(results.getString("REG_DT"));
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

	/**
     * 견적서 메모 전체조회
     */
    public EstiMBean [] getEstiMAll(String est_id, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = "select EST_ID, USER_ID, SEQ_NO, SUB, NOTE, REG_DT\n"
				+ "from esti_m\n"
				+ "where est_id=? order by seq_no desc \n";// and user_id=?

        Collection<EstiMBean> col = new ArrayList<EstiMBean>();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, est_id);
//    		pstmt.setString(2, user_id);
    		
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){
				col.add(makeEstiMBean(rs));
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
        return (EstiMBean[])col.toArray(new EstiMBean[0]);
    }

	//견적서 메모 등록
    public int insertEstiM(EstiMBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        int seq_no = 0;
        int count = 0;
                
        query="insert into esti_m(EST_ID, USER_ID, SEQ_NO, SUB, NOTE, REG_DT, GUBUN)\n"
			+ "values(?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDDHH24MI'), ? )\n";


        //견적별로 mas(seq_no)를 구해야 함
        query1="select nvl(max(seq_no)+1,1) from esti_m where est_id=? ";



        try{
            con.setAutoCommit(false);

            pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, bean.getEst_id());
        //    pstmt1.setString(2, bean.getUser_id().trim());            
			rs = pstmt1.executeQuery();
            if(rs.next())
			{
				seq_no = rs.getInt(1);
            }
            rs.close();
            pstmt1.close();
			
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, bean.getEst_id	());
			pstmt.setString(2, bean.getUser_id	().trim());
			pstmt.setInt   (3, seq_no             );
			pstmt.setString(4, bean.getSub		().trim());
			pstmt.setString(5, bean.getNote		().trim());
			pstmt.setString(6, bean.getGubun	().trim());		           
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception e){
            try{
                con.rollback();
            }catch(SQLException se){
            	System.out.println("[EstiDatabase:insertEstiM]"+ se);
				System.out.println("[bean.getEst_id		()]"+ bean.getEst_id	());
				System.out.println("[bean.getUser_id	()]"+ bean.getUser_id	());
				System.out.println("[seq_no               ]"+ seq_no              );
				System.out.println("[bean.getSub		()]"+ bean.getSub		());
				System.out.println("[bean.getNote		()]"+ bean.getNote		());
				System.out.println("[bean.getGubun		()]"+ bean.getGubun		());
            }
            throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }


	//아마존카 홈페이지 데이타베이스-----------------------------------------------------------------------------------


	/**
     * 해당 차량 잔가율 계산하기. 20050823.
	 *	- 20051011 차령0개월잔가율 변경 0.85-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.05,0) janga0 --> 0.84-(0.6-(d.janga24/100))*0.5-decode(d.jeep_yn,'Y',0.04,0) janga0
     */
    public float getJanga(String car_id, String car_seq, String a_b, String lpg_yn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		float janga = 0;

		query = " select ROUND(POWER((janga24/100)/(0.84-(0.6-(janga24/100))*0.5-decode(jeep_yn,'Y',0.04,0)), "+a_b+"/24)*(0.84-(0.6-(janga24/100))*0.5-decode(jeep_yn,'Y',0.04,0)) "+
				" 	   		*(1-0.04-0.04*("+a_b+"/12)),2)-DECODE(svn_nn_yn,'Y',0.03,0)-DECODE('"+lpg_yn+"','1',0.01+ROUND(("+a_b+"/12)*0.01,2), 0) esti_janga "+
				" from esti_sh_var a, car_nm n  "+
				" where seq = (select max(seq) from esti_sh_var b where a.sh_code=b.sh_code) "+
				" and a.sh_code= n.sh_code(+) "+
				" and n.car_id = '"+car_id+"' and n.car_seq='"+car_seq+"' ";
		   
       try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())	janga = rs.getFloat(1);
            rs.close();
      		stmt.close();
		}catch(SQLException se){
            System.out.println("[EstiDatabase:getJanga]"+se);
            throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return janga;
    }
	/**
     * 해당 차량 잔가율 계산하기. 20070316
	 *	
     */
    public float getJanga(String est_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		float janga = 0;

		query = " select"+
				" ROUND(((decode(CO24,1,(CO15*CO14+(CO16*CO14*CO17)+(CO18*CO14*CO19)),(CO15*CO14+(CO21*CO14*CO22)))/(CF11/10000))+CO29)*(1+CO36/36*CH10)+CO33+CO35,3)/CO37 as CO38"+
				" from"+
				"     ("+
				"     select"+
				"           a.*, "+
				"           (CO10+POWER((CO8-CO10)/(CO6-CO10),CH10/24)*(CO6-CO10))*(1+CO11/36*CH10) as CO12,"+
				"           ROUND(((CO10+POWER((CO8-CO10)/(CO6-CO10),CH10/24)*(CO6-CO10))*(1+CO11/36*CH10)*CO13),3) CO14"+
				"     from"+
				"         ("+
				"         select"+
				"         jg_1 as CO2,"+
				"         jg_c_1/100 as CO3,"+
				"         jg_2 as CO4,"+
				"         jg_3 as CO5,"+
				"         jg_c_1/100*(1+nvl(jg_2,0)*jg_3)+(jg_1-0.6*(1+nvl(jg_2,0)*jg_3))*0.5 as CO6,"+
				"         jg_c_2 as CO7,"+
				"         jg_1*(1+jg_c_2/100) as CO8,"+
				"         jg_4 as CO9,"+
				"         jg_1*(1+jg_c_2/100)*jg_4 as CO10,"+
				"         jg_5 as CO11,"+
				"         jg_6 as CO13,"+
				"         jg_7 as CO15,"+
				"         (CF7+CF10)/10000-jg_7 as CO16,"+
				"         decode(sign((CF7+CF10)/10000-jg_7),1,jg_8, 1) as CO17,"+
				"         (CF8+CF9)/10000 as CO18,"+
				"         decode(sign((CF8+CF9)/10000), 1,jg_9, 1) as CO19,"+
				"         (CF11/10000-jg_7) as CO21,"+
				" 		  decode(sign(CF11/10000-jg_7), 1,jg_10, 1) as CO22,"+
				"         jg_11 as CO24,"+
				"         jg_c_3/100 as CO27,"+
				"         to_date(CH8,'YYYYMMDD')-to_date(substr(CH8,1,4)-1||'1231','YYYYMMDD') CO28,"+
				"         (jg_c_3/100)*((to_date(CH8,'YYYYMMDD')-to_date(substr(CH8,1,4)-1||'1231','YYYYMMDD'))/365-0.5) as CO29,"+
				"         jg_c_4/100 as CO31,"+
				"         jg_c_5/100 as CO32,"+
				"         decode(CH12,1,(jg_c_4+(CH10/12)*jg_c_5)/100, 0) as CO33,"+
				"         jg_c_6/100 AS CO34,"+
				"         decode(sign(CH10-36),1,(CH10-36)/12*jg_c_6,0)/100 as CO35,"+
				"         jg_12 as CO36,"+
				"         jg_13 as CO37,"+
				"         CF11, CH8, CH10"+
				"         from"+
				"             (select a.car_amt as CF7, a.opt_amt as CF8, a.col_amt as CF9, -a.dc_amt as CF10, a.o_1 as CF11,"+
				"                 b.jg_code CH6, nvl(a.rent_dt,decode(est_type,'J',to_char(sysdate,'YYYYMMDD'),substr(a.reg_dt,1,8))) CH8, a.a_b as CH10, a.lpg_yn as CH12"+
				"              from estimate a, car_nm b where a.est_id='"+est_id+"' and a.car_id=b.car_id and a.car_seq=b.car_seq) a,"+
				"             esti_jg_var b,"+
				"             (select * from esti_comm_var where a_a='1' and seq=(select max(seq) from esti_comm_var where a_a='1')) c"+
				"         where a.CH6=b.sh_code"+
				"         ) a"+
				"     )";
		   
       try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())	janga = rs.getFloat(1);
            rs.close();
      		stmt.close();
		}catch(SQLException se){
            System.out.println("[EstiDatabase:getJanga]"+se);
            throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return janga;
    }
	/**
     * 해당 차량 잔가율 계산하기. 20070316 - 신차견적시 최대잔가율 조회
	 *	
     */
    public float getJanga(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		float janga = 0;

		query = " select"+
				" ROUND(((decode(CO24,1,(CO15*CO14+(CO16*CO14*CO17)+(CO18*CO14*CO19)),(CO15*CO14+(CO21*CO14*CO22)))/(CF11/10000))+CO29)*(1+CO36/36*CH10)+CO33+CO35,3)/CO37 as CO38"+
				" from"+
				"     ("+
				"     select"+
				"           a.*, "+
				"           (CO10+POWER((CO8-CO10)/(CO6-CO10),CH10/24)*(CO6-CO10))*(1+CO11/36*CH10) as CO12,"+
				"           ROUND(((CO10+POWER((CO8-CO10)/(CO6-CO10),CH10/24)*(CO6-CO10))*(1+CO11/36*CH10)*CO13),3) CO14"+
				"     from"+
				"         ("+
				"         select"+
				"         jg_1 as CO2,"+
				"         jg_c_1/100 as CO3,"+
				"         jg_2 as CO4,"+
				"         jg_3 as CO5,"+
				"         jg_c_1/100*(1+nvl(jg_2,0)*jg_3)+(jg_1-0.6*(1+nvl(jg_2,0)*jg_3))*0.5 as CO6,"+
				"         jg_c_2 as CO7,"+
				"         jg_1*(1+jg_c_2/100) as CO8,"+
//				"         jg_4 as CO9,"+
				"         decode('"+bean.getEst_tel()+"','0',jg_4,(jg_4*0)) as CO9,"+
				"         jg_1*(1+jg_c_2/100)*decode('"+bean.getEst_tel()+"','0',jg_4,(jg_4*0)) as CO10,"+
				"         jg_5 as CO11,"+
				"         jg_6 as CO13,"+
				"         jg_7 as CO15,"+
				"         (CF7+CF10)/10000-jg_7 as CO16,"+
				"         decode(sign((CF7+CF10)/10000-jg_7),1,jg_8, 1) as CO17,"+
				"         (CF8+CF9)/10000 as CO18,"+
				"         decode(sign((CF8+CF9)/10000), 1,jg_9, 1) as CO19,"+
				"         (CF11/10000-jg_7) as CO21,"+
				" 		  decode(sign(CF11/10000-jg_7), 1,jg_10, 1) as CO22,"+
				"         jg_11 as CO24,"+
				"         jg_c_3/100 as CO27,"+
				"         to_date(CH8,'YYYYMMDD')-to_date(substr(CH8,1,4)-1||'1231','YYYYMMDD') CO28,"+
				"         (jg_c_3/100)*((to_date(CH8,'YYYYMMDD')-to_date(substr(CH8,1,4)-1||'1231','YYYYMMDD'))/365-0.5) as CO29,"+
				"         jg_c_4/100 as CO31,"+
				"         jg_c_5/100 as CO32,"+
				"         decode(CH12,1,(jg_c_4+(CH10/12)*jg_c_5)/100, 0) as CO33,"+
				"         jg_c_6/100 AS CO34,"+
				"         decode(sign(CH10-36),1,(CH10-36)/12*jg_c_6,0)/100 as CO35,"+
				"         jg_12 as CO36,"+
				"         jg_13 as CO37,"+
				"         CF11, CH8, CH10"+
				"         from"+
				"             (select "+bean.getCar_amt()+" as CF7, "+bean.getOpt_amt()+" as CF8, "+bean.getCol_amt()+" as CF9, -"+bean.getDc_amt()+" as CF10, "+bean.getO_1()+" as CF11,"+
				"                 b.jg_code CH6, to_char(sysdate,'YYYYMMDD') CH8, '"+bean.getA_b()+"' as CH10, '"+bean.getLpg_yn()+"' as CH12"+
				"              from car_nm b where b.car_id='"+bean.getCar_id()+"' and b.car_seq='"+bean.getCar_seq()+"') a,"+
				"             (select a.* from esti_jg_var a, (select sh_code, max(seq) seq from esti_jg_var group by sh_code) b where a.sh_code=b.sh_code and a.seq=b.seq) b,"+
				"             (select * from esti_comm_var where a_a='1' and seq=(select max(seq) from esti_comm_var where a_a='1')) c"+
				"         where a.CH6=b.sh_code"+
				"         ) a"+
				"     )";
		   
	   try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())	janga = rs.getFloat(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
            System.out.println("[EstiDatabase:getJanga]"+se);
            System.out.println("[EstiDatabase:getJanga]"+query);
            throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return janga;
    }

	/**
     * 해당 차량 lpg장착금액 가져오기. 20050830.
     */
    public int getLpg_amt(String sh_code, int dpm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		int lpg_amt = 0;

		if(dpm>3500){
			query = " SELECT lpg_amt+nvl(lpg_add_amt,0) lpg_amt FROM esti_sh_var WHERE sh_code = '"+sh_code+"' AND lpg_ga_yn='Y' AND seq = (select max(seq) from esti_sh_var where sh_code='"+sh_code+"' ) ";
		}else{
			query = " SELECT lpg_amt FROM esti_sh_var WHERE sh_code = '"+sh_code+"' AND lpg_ga_yn='Y' AND seq = (select max(seq) from esti_sh_var where sh_code='"+sh_code+"' ) ";
		}
		   
       try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())	lpg_amt = rs.getInt(1);
            rs.close();
      		stmt.close();
		}catch(SQLException se){
            System.out.println("[EstiDatabase:getLpg_amt]"+se);
            throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return lpg_amt;
    }
	/**
     * 해당 차량 실탁송료 가져오기. 20060214.
     */
    public int getTaksong_amt(String sh_code, String a_h) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		int taksong_amt = 0;

		if(a_h.equals("1")||a_h.equals("2")){
			query = " SELECT nvl(taksong_se,0) taksong_amt FROM esti_sh_var WHERE sh_code = '"+sh_code+"' AND seq = (select max(seq) from esti_sh_var where sh_code='"+sh_code+"' ) ";
		}else{
			query = " SELECT nvl(taksong_bu,0) taksong_amt FROM esti_sh_var WHERE sh_code = '"+sh_code+"' AND seq = (select max(seq) from esti_sh_var where sh_code='"+sh_code+"' ) ";
		}
		   
       try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())	taksong_amt = rs.getInt(1);
            rs.close();
      		stmt.close();
		}catch(SQLException se){
            System.out.println("[EstiDatabase:getLpg_amt]"+se);
            throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return taksong_amt;
    }
	/**
     * 해당 차량 적용이자율 가져오기. 20060418.
     */
    public float getA_f(String sh_code, String month) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		float a_f = 0f;

		query = " SELECT ";
		//개월에 따른 적용이자율 구하기
		if(month.equals("36"))								query += " af_m36 ";
		else if(month.equals("12")|| month.equals("24"))	query += " af_m12_24 ";
		else if(month.equals("48")|| month.equals("60"))	query += " af_m48_60 ";

		query += " a_f FROM esti_sh_var WHERE sh_code = '"+sh_code+"' AND seq = (select max(seq) from esti_sh_var where sh_code='"+sh_code+"' ) ";
		   
       try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())	a_f = rs.getFloat(1);
            rs.close();
      		stmt.close();
		}catch(SQLException se){
            System.out.println("[EstiDatabase:getA_f]"+se);
            throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return a_f;
    }

	//인포메일러 d-mail 발송 20060425-----------------------------------------------------------------------------------------------

	//d-mail 발송 한건 등록
	public boolean insertDEmail(tax.DmailBean bean, String sdate, String tdate) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO im_dmail_info_7"+
				" ( seqidx, subject, sql, reject_slist_idx, block_group_idx, mailfrom, mailto, replyto, errorsto, html,"+//1
				"   encoding, charset, sdate, tdate, duration_set, click_set, site_set, atc_set, gubun, rname,"+//2
				"   mtype, u_idx, g_idx, msgflag, content, gubun2 , qry"+//3
				" ) VALUES"+
				" ( IM_SEQ_DMAIL_INFO_7.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, to_char(sysdate,'YYYYMMDDhh24miss'), to_char(sysdate"+tdate+",'YYYYMMDDhh24miss'), ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?,  ?"+
				" )";

		try 
		{
			con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
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
			pstmt.setString	(23,	bean.getGubun2			()); 
			pstmt.setString	(24,		bean.getSql				()); 

			pstmt.executeUpdate();
			pstmt.close();
			con.commit();
																 
	  	} catch (Exception e) {
            try{
				System.out.println("[EstiDatabase:insertDEmail]"+e);
                con.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
		} finally {
			try{
				if ( pstmt != null )	pstmt.close();
				con.setAutoCommit(true);
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return flag;
		}
	}


	//차종별잔가변수 관리----------------------------------------------------------------------------------------------------------------

    /**
     * 차종별잔가변수 조회-세부내용
     */
    public EstiShVarBean getEstiShVarCase(String sh_code, String seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiShVarBean bean = new EstiShVarBean();
        String query = "";
        
        query = " select * from esti_sh_var where sh_code='"+sh_code+"'";

		if(seq.equals("")){
			query += " and seq = (select max(seq) from esti_sh_var where sh_code='"+sh_code+"')";
		}else{
			query += " and seq='"+seq+"'";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            if(rs.next()){
				bean.setSh_code		(rs.getString(1));
			    bean.setSeq			(rs.getString(2));
			    bean.setCars		(rs.getString(3));
			    bean.setJanga24		(rs.getFloat (4));
			    bean.setJeep_yn		(rs.getString(5));
			    bean.setRentcar		(rs.getString(6));
				bean.setSvn_nn_yn	(rs.getString(7));
			    bean.setLpg_ga_yn	(rs.getString(8));
			    bean.setLpg_amt		(rs.getInt   (9));
			    bean.setLpg_add_amt	(rs.getInt   (10));
			    bean.setReg_dt		(rs.getString(11));
			    bean.setTaksong_se	(rs.getInt   (12));
				bean.setTaksong_bu	(rs.getInt   (13));
			    bean.setAf_m12_24	(rs.getFloat (14));
			    bean.setAf_m36		(rs.getFloat (15));
			    bean.setAf_m48_60	(rs.getFloat (16));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiShVarCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }


	/**
     * 차종별잔가변수 등록.
     */
    public String insertEstiShVar(EstiShVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
        String query1 = "";
		String query2 = "";
		String seq = "";
        int count = 0;

		query1 = " SELECT nvl(lpad(max(to_number(SEQ))+1,2,'0'),'01') FROM ESTI_SH_VAR WHERE sh_code='"+bean.getSh_code()+"'";
			
        query2 = " INSERT INTO ESTI_SH_VAR"+
				" (sh_code, seq, cars, janga24, jeep_yn, rentcar, svn_nn_yn,"+
				"  lpg_ga_yn, lpg_amt, lpg_add_amt, reg_dt,"+
				"  taksong_se, taksong_bu, af_m12_24, af_m36, af_m48_60)"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?,'-',''), ?, ?, ?, ?, ?)";
           
       try{
            con.setAutoCommit(false);

            //seq 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query1);
            if(rs.next())
            	seq = rs.getString(1);
            rs.close();
      		stmt.close();

            pstmt = con.prepareStatement(query2);
            pstmt.setString	(1,  bean.getSh_code	());
            pstmt.setString	(2,  seq				  );
            pstmt.setString	(3,  bean.getCars		());
            pstmt.setFloat	(4,  bean.getJanga24	());
            pstmt.setString	(5,  bean.getJeep_yn	());
			pstmt.setString	(6,  bean.getRentcar	());
            pstmt.setString	(7,  bean.getSvn_nn_yn	());
            pstmt.setString	(8,  bean.getLpg_ga_yn	());
            pstmt.setInt	(9,  bean.getLpg_amt	());
            pstmt.setInt	(10, bean.getLpg_add_amt());
            pstmt.setString	(11, bean.getReg_dt		());
			pstmt.setInt	(12, bean.getTaksong_se	());
            pstmt.setInt	(13, bean.getTaksong_bu	());
            pstmt.setFloat	(14, bean.getAf_m12_24	());
            pstmt.setFloat	(15, bean.getAf_m36		());
            pstmt.setFloat	(16, bean.getAf_m48_60	());

			count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstiShVar]"+se);
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
        return seq;
    }

    /**
     * 차종별 잔가변수 수정.
     */
    public int updateEstiShVar(EstiShVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE ESTI_SH_VAR SET\n"+
				" cars=?, janga24=?, jeep_yn=?, rentcar=?, svn_nn_yn=?,\n"+
				" lpg_ga_yn=?, lpg_amt=?, lpg_add_amt=?, reg_dt=replace(?,'-',''),\n"+
				" taksong_se=?, taksong_bu=?, af_m12_24=?, af_m36=?, af_m48_60=?\n"+
				" WHERE sh_code=? AND seq=?";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query); 

            pstmt.setString	(1,   bean.getCars			());
            pstmt.setFloat	(2,   bean.getJanga24		());
            pstmt.setString	(3,   bean.getJeep_yn		());
			pstmt.setString	(4,   bean.getRentcar		());
            pstmt.setString	(5,   bean.getSvn_nn_yn		());
            pstmt.setString	(6,   bean.getLpg_ga_yn		());
            pstmt.setInt	(7,   bean.getLpg_amt		());
            pstmt.setInt	(8,   bean.getLpg_add_amt	());
            pstmt.setString	(9,   bean.getReg_dt		());
			pstmt.setInt	(10,  bean.getTaksong_se	());
            pstmt.setInt	(11,  bean.getTaksong_bu	());
            pstmt.setFloat	(12,  bean.getAf_m12_24		());
            pstmt.setFloat	(13,  bean.getAf_m36		());
            pstmt.setFloat	(14,  bean.getAf_m48_60		());
            pstmt.setString	(15,  bean.getSh_code		());
            pstmt.setString	(16,  bean.getSeq			());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateEstiShVar]"+se);
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

    /**
	 *	차종별 중고차 잔가 이력
	 */
	public Vector getEstiShVarList(String sh_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from esti_sh_var b where sh_code=? "+
				" order by seq ";

		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString	(1, sh_code);
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
			System.out.println("[EstiDatabase:getEstiShVarList(String sh_code)]"+e);
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
	 *	차종별 중고차 잔가 이력
	 */
	public Vector getEstiJgVarList(String sh_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from esti_jg_var b where sh_code=? "+
				" order by seq ";

		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString	(1, sh_code);
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
			System.out.println("[EstiDatabase:getEstiJgVarList(String sh_code)]"+e);
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
	 *	차종별 중고차 특소세 리스트
	 */
	public Vector getSpTaxList(String sh_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from sp_tax b where sh_code=? "+
				" order by tax_st_dt ";

		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString	(1, sh_code);
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
			System.out.println("[EstiDatabase:getSpTaxList(String sh_code)]"+e);
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
	 *	차종별 중고차 특소세 기준일자 리스트
	 */
	public Vector getSpTaxDtList(String sh_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select tax_st_dt, max(tax_end_dt) tax_end_dt from sp_tax";
		
		if(!sh_code.equals("")) query += " where sh_code like '%"+sh_code+"%'";

		query += " group by tax_st_dt order by tax_st_dt";

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
			System.out.println("[EstiDatabase:getSpTaxDtList(String sh_code)]"+e);
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
     * 차종별잔가변수 등록.
     */
    public int insertSpTax(String sh_code, String seq, String tax_st_dt, String tax_end_dt, String sp_tax) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
		String query = "";
		String query2 = "";
        int count = 0;

		query2 = " update sp_tax set tax_end_dt =to_char(to_date(replace('"+tax_st_dt+"','-',''),'YYYYMMDD')-1,'YYYYMMDD')"+
				 " where sh_code='"+sh_code+"' and seq = (select max(seq) from sp_tax where sh_code='"+sh_code+"')";

		query = " INSERT INTO SP_TAX"+
				" (sh_code, seq, tax_st_dt, tax_end_dt, sp_tax)"+
				" values \n"+
	            " ( ?, ?, replace(?,'-',''), replace(?,'-',''), ?)";
           

       try{
            con.setAutoCommit(false);

            //마지막 특소세 기준일자 변경
            pstmt2 = con.prepareStatement(query2);
			count = pstmt2.executeUpdate();
            pstmt2.close();

	        pstmt = con.prepareStatement(query);
	        pstmt.setString	(1,  sh_code	);
		    pstmt.setString	(2,  seq		);
			pstmt.setString	(3,  tax_st_dt	);
            pstmt.setString	(4,  tax_end_dt);
			pstmt.setFloat	(5,  AddUtil.parseFloat(sp_tax));
			count = pstmt.executeUpdate();
			
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertSpTax]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
     * 차종별잔가변수 등록.
     */
    public int deleteEstiShVar(String sh_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt2 = null;
		String query = "";
		String query2 = "";
        int count = 0;

		query = " delete from esti_sh_var where sh_code=?";

		query2 = " delete from sp_tax where sh_code=?";

       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
	        pstmt.setString	(1,  sh_code	);
			count = pstmt.executeUpdate();
            pstmt.close();

            pstmt2 = con.prepareStatement(query2);
	        pstmt2.setString	(1,  sh_code	);
			count = pstmt2.executeUpdate();
            pstmt2.close();
			
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:deleteEstiShVar]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
     * 차종별잔가변수 등록2.
     */
    public String insertEstiJgVar(EstiJgVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
        String query1 = "";
		String query2 = "";
		String seq = "";
        int count = 0;

		query1 = " SELECT nvl(lpad(max(to_number(SEQ))+1,3,'0'),'001') FROM ESTI_JG_VAR WHERE sh_code='"+bean.getSh_code()+"'";
			
        query2 = " INSERT INTO ESTI_JG_VAR"+
				" (sh_code, seq, com_nm, cars,"+
				"  jg_1, jg_2, jg_3, jg_4, jg_5, jg_6, jg_7, jg_8, jg_9, jg_10, jg_11, jg_12, jg_13,"+
				"  jg_a, jg_b, jg_c, jg_d1, jg_d2, jg_e, jg_f, jg_g, jg_h, jg_i, jg_j1, jg_j2, jg_j3, new_yn, jg_d3, app_dt, jg_k, jg_l, jg_e1,"+
				"  jg_st1, jg_st2, jg_st3, jg_st4, jg_st5, jg_st6, jg_st7, jg_st8, jg_e_d, jg_e_e, jg_e_g, jg_st9, jg_q, jg_st10, jg_r, jg_s, jg_t, jg_u, jg_14, "+
				"  jg_3_1, jg_st11, jg_st12, jg_st13, jg_st14, jg_5_1, jg_v, jg_st15, jg_w, jg_x, jg_y, jg_z, jg_d4, jg_d5, jg_g_1, jg_g_2, jg_g_3, jg_15, jg_g_4, "+
				"  jg_g_5, jg_st16, jg_g_6, jg_st17, jg_st18, reg_dt, jg_st19, jg_g_7, jg_g_8, jg_g_9, jg_g_10, jg_g_11, jg_g_12, "+
				"  jg_g_13, jg_d6, jg_d7, jg_d8, jg_d9, jg_d10, jg_g_14, jg_g_15, jg_g_16, jg_g_17, jg_g_18, jg_g_19, jg_g_20, jg_g_21, jg_g_22, jg_g_23, "+	
				"  jg_g_24, jg_g_25, jg_g_26, jg_g_27, jg_g_28, jg_g_29, jg_g_30, jg_g_31, jg_g_32, jg_g_33, jg_st20, jg_st21, "+		//jg_g_18 ~jg_g_33 추가(20180528)	
				"  jg_g_34, jg_g_35, jg_g_36, jg_g_38, jg_g_39, jg_g_40, jg_g_41, jg_g_42, jg_g_43, jg_g_44, jg_st22, jg_st23, jg_g_45, jg_g_46 "+		//jg_g_34, jg_g_35 추가(20190625)	// jg_g_38, jg_g_39, jg_g_40, jg_g_41, jg_g_42 추가(20210215)	// jg_g_43 추가(20210225) // jg_g_46 추가(20220110) 
				" )"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
	            "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
	            "   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, replace(?, '-', ''), ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "+
				" )";
           
       try{
            con.setAutoCommit(false);

            //seq 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query1);
            if(rs.next())
            	seq = rs.getString(1);
            rs.close();
      		stmt.close();

            pstmt = con.prepareStatement(query2);
            pstmt.setString(1,  bean.getSh_code().trim());
            pstmt.setString(2,  seq			  );
            pstmt.setString(3,  bean.getCom_nm	().trim());
            pstmt.setString(4,  bean.getCars 	().trim());
            pstmt.setFloat (5,  bean.getJg_1 	());
			pstmt.setString(6,  bean.getJg_2 	().trim());
            pstmt.setFloat (7,  bean.getJg_3 	());
            pstmt.setFloat (8,  bean.getJg_4 	());
            pstmt.setFloat (9,  bean.getJg_5 	());
            pstmt.setFloat (10, bean.getJg_6 	());
            pstmt.setInt   (11, bean.getJg_7 	());
			pstmt.setFloat (12, bean.getJg_8 	());
            pstmt.setFloat (13, bean.getJg_9 	());
            pstmt.setFloat (14, bean.getJg_10 	());
            pstmt.setFloat (15, bean.getJg_11 	());
            pstmt.setFloat (16, bean.getJg_12 	());
            pstmt.setString(17, bean.getJg_13 	().trim());
            pstmt.setString(18, bean.getJg_a 	().trim());
            pstmt.setString(19, bean.getJg_b 	().trim());
            pstmt.setInt   (20, bean.getJg_c 	());
            pstmt.setInt   (21, bean.getJg_d1 	());
			pstmt.setInt   (22, bean.getJg_d2 	());
            pstmt.setString(23, bean.getJg_e 	().trim());
            pstmt.setFloat (24, bean.getJg_f 	());
            pstmt.setFloat (25, bean.getJg_g 	());
            pstmt.setString(26, bean.getJg_h 	().trim());
            pstmt.setString(27, bean.getJg_i 	().trim());
            pstmt.setFloat (28, bean.getJg_j1 	());
            pstmt.setFloat (29, bean.getJg_j2 	());
            pstmt.setFloat (30, bean.getJg_j3 	());
            pstmt.setString(31, bean.getNew_yn	().trim());
			pstmt.setInt   (32, bean.getJg_d3 	());
            pstmt.setString(33, bean.getApp_dt 	().trim());
            pstmt.setString(34, bean.getJg_k 	().trim());
            pstmt.setFloat (35, bean.getJg_l 	());
			pstmt.setInt   (36, bean.getJg_e1 	());
            pstmt.setFloat (37, bean.getJg_st1 	());
            pstmt.setFloat (38, bean.getJg_st2	());
            pstmt.setFloat (39, bean.getJg_st3 	());
            pstmt.setFloat (40, bean.getJg_st4	());
            pstmt.setFloat (41, bean.getJg_st5 	());
            pstmt.setFloat (42, bean.getJg_st6	());
            pstmt.setFloat (43, bean.getJg_st7 	());
            pstmt.setFloat (44, bean.getJg_st8	());
            pstmt.setFloat (45, bean.getJg_e_d	());
            pstmt.setFloat (46, bean.getJg_e_e	());
            pstmt.setInt   (47, bean.getJg_e_g	());
            pstmt.setFloat (48, bean.getJg_st9	());
            pstmt.setString(49, bean.getJg_q 	().trim());
            pstmt.setFloat (50, bean.getJg_st10 ());
            pstmt.setString(51, bean.getJg_r 	().trim());
            pstmt.setString(52, bean.getJg_s 	().trim());
            pstmt.setString(53, bean.getJg_t 	().trim());
			pstmt.setFloat (54, bean.getJg_u	());
			pstmt.setFloat (55, bean.getJg_14	());
			pstmt.setFloat (56, bean.getJg_3_1 	());
            pstmt.setFloat (57, bean.getJg_st11 ());
            pstmt.setFloat (58, bean.getJg_st12	());
            pstmt.setFloat (59, bean.getJg_st13 ());
            pstmt.setFloat (60, bean.getJg_st14	());
			pstmt.setFloat (61, bean.getJg_5_1 	());
			pstmt.setString(62, bean.getJg_v 	().trim());
			pstmt.setFloat (63, bean.getJg_st15	());
			pstmt.setString(64, bean.getJg_w 	().trim());
			pstmt.setFloat (65, bean.getJg_x	());
			pstmt.setFloat (66, bean.getJg_y	());
			pstmt.setFloat (67, bean.getJg_z	());
            pstmt.setInt   (68, bean.getJg_d4 	());
			pstmt.setInt   (69, bean.getJg_d5 	());
			pstmt.setFloat (70, bean.getJg_g_1	());
			pstmt.setFloat (71, bean.getJg_g_2	());
			pstmt.setFloat (72, bean.getJg_g_3	());
			pstmt.setFloat (73, bean.getJg_15	());
			pstmt.setFloat (74, bean.getJg_g_4	());
			pstmt.setFloat (75, bean.getJg_g_5	());
			pstmt.setFloat (76, bean.getJg_st16	());
			pstmt.setFloat (77, bean.getJg_g_6	());
			pstmt.setFloat (78, bean.getJg_st17	());
			pstmt.setFloat (79, bean.getJg_st18	());
            pstmt.setString(80, bean.getReg_dt	().trim());
			pstmt.setFloat (81, bean.getJg_st19	());
			pstmt.setString(82, bean.getJg_g_7 	().trim());
			pstmt.setString(83, bean.getJg_g_8 	().trim());
			pstmt.setString(84, bean.getJg_g_9 	().trim());
			pstmt.setFloat (85, bean.getJg_g_10	());
			pstmt.setFloat (86, bean.getJg_g_11	());
			pstmt.setFloat (87, bean.getJg_g_12	());
			pstmt.setFloat (88, bean.getJg_g_13	());
            pstmt.setInt   (89, bean.getJg_d6 	());
			pstmt.setInt   (90, bean.getJg_d7 	());
            pstmt.setInt   (91, bean.getJg_d8 	());
			pstmt.setInt   (92, bean.getJg_d9 	());
            pstmt.setInt   (93, bean.getJg_d10 	());
			pstmt.setFloat (94, bean.getJg_g_14	());
            pstmt.setInt   (95, bean.getJg_g_15	());
            pstmt.setString(96, bean.getJg_g_16	().trim());
            pstmt.setInt   (97, bean.getJg_g_17	());
            pstmt.setString(98, bean.getJg_g_18	().trim());	//jg_g_18 ~jg_g_33 추가(20180528)
            pstmt.setInt   (99, bean.getJg_g_19	());
            pstmt.setInt   (100,bean.getJg_g_20	());
            pstmt.setString(101,bean.getJg_g_21	().trim());
            pstmt.setInt   (102,bean.getJg_g_22	());
            pstmt.setInt   (103,bean.getJg_g_23	());
            pstmt.setInt   (104,bean.getJg_g_24	());
            pstmt.setFloat (105,bean.getJg_g_25	());
            pstmt.setString(106,bean.getJg_g_26	().trim());
            pstmt.setInt   (107,bean.getJg_g_27	());
            pstmt.setInt   (108,bean.getJg_g_28	());
            pstmt.setInt   (109,bean.getJg_g_29	());
            pstmt.setFloat (110,bean.getJg_g_30	());
            pstmt.setFloat (111,bean.getJg_g_31	());
            pstmt.setFloat (112,bean.getJg_g_32	());
            pstmt.setFloat (113,bean.getJg_g_33	());
            pstmt.setFloat (114,bean.getJg_st20 ());
            pstmt.setFloat (115,bean.getJg_st21 ());
            pstmt.setInt   (116,bean.getJg_g_34	());
            pstmt.setInt   (117,bean.getJg_g_35	());
            pstmt.setString(118,bean.getJg_g_36	().trim());
            pstmt.setInt(119,bean.getJg_g_38	());
            pstmt.setInt(120,bean.getJg_g_39());
            pstmt.setInt(121,bean.getJg_g_40	());
            pstmt.setInt(122,bean.getJg_g_41());
            pstmt.setInt(123,bean.getJg_g_42());
            pstmt.setInt(124,bean.getJg_g_43());
            pstmt.setInt(125,bean.getJg_g_44());
            pstmt.setFloat (126,bean.getJg_st22 ());
            pstmt.setFloat (127,bean.getJg_st23 ());
            pstmt.setFloat (128,bean.getJg_g_45 ());
            pstmt.setInt(129,bean.getJg_g_46());


			count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstiJgVar]"+se);
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
        return seq;
    }
    
    /**
     * 차종별잔가변수 등록 batchTest.
     */
    public String insertEstiJgVar2(EstiJgVarBean bean) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	PreparedStatement pstmt = null;
    	Statement stmt = null;
    	ResultSet rs = null;
    	String query1 = "";
    	String query2 = "";
    	String seq = "";
    	int count = 0;
    	
    	query1 = " SELECT nvl(lpad(max(to_number(SEQ))+1,3,'0'),'001') FROM ESTI_JG_VAR WHERE sh_code='"+bean.getSh_code()+"'";
    	
    	query2 = " INSERT INTO ESTI_JG_VAR"+
    			" (sh_code, seq, com_nm, cars,"+
    			"  jg_1, jg_2, jg_3, jg_4, jg_5, jg_6, jg_7, jg_8, jg_9, jg_10, jg_11, jg_12, jg_13,"+
    			"  jg_a, jg_b, jg_c, jg_d1, jg_d2, jg_e, jg_f, jg_g, jg_h, jg_i, jg_j1, jg_j2, jg_j3, new_yn, jg_d3, app_dt, jg_k, jg_l, jg_e1,"+
    			"  jg_st1, jg_st2, jg_st3, jg_st4, jg_st5, jg_st6, jg_st7, jg_st8, jg_e_d, jg_e_e, jg_e_g, jg_st9, jg_q, jg_st10, jg_r, jg_s, jg_t, jg_u, jg_14, "+
    			"  jg_3_1, jg_st11, jg_st12, jg_st13, jg_st14, jg_5_1, jg_v, jg_st15, jg_w, jg_x, jg_y, jg_z, jg_d4, jg_d5, jg_g_1, jg_g_2, jg_g_3, jg_15, jg_g_4, "+
    			"  jg_g_5, jg_st16, jg_g_6, jg_st17, jg_st18, reg_dt, jg_st19, jg_g_7, jg_g_8, jg_g_9, jg_g_10, jg_g_11, jg_g_12, "+
    			"  jg_g_13, jg_d6, jg_d7, jg_d8, jg_d9, jg_d10, jg_g_14, jg_g_15, jg_g_16, jg_g_17, jg_g_18, jg_g_19, jg_g_20, jg_g_21, jg_g_22, jg_g_23, "+	
    			"  jg_g_24, jg_g_25, jg_g_26, jg_g_27, jg_g_28, jg_g_29, jg_g_30, jg_g_31, jg_g_32, jg_g_33, jg_st20, jg_st21, "+		//jg_g_18 ~jg_g_33 추가(20180528)	
    			"  jg_g_34, jg_g_35, jg_g_36, jg_st22, jg_st23 "+		//jg_g_34, jg_g_35 추가(20190625)	
    			" )"+
    			" values \n"+
    			" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
    			"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
    			"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
    			"   ?, ?, replace(?, '-', ''), ?, ?, ?, "+
    			"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
    			"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
    			"   ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, "+
    			"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
    			"   ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
    			"   ?, ?, ?, ?, ? "+
    			" )";
    	
    	try{
    		con.setAutoCommit(false);
    		
    		//seq 생성
    		stmt = con.createStatement();
    		rs = stmt.executeQuery(query1);
    		if(rs.next())
    			seq = rs.getString(1);
    		rs.close();
    		stmt.close();
    		
    		pstmt = con.prepareStatement(query2);
    		
    		pstmt.setString(1,  bean.getSh_code().trim());
    		pstmt.setString(2,  seq			  );
    		pstmt.setString(3,  bean.getCom_nm	().trim());
    		pstmt.setString(4,  bean.getCars 	().trim());
    		pstmt.setFloat (5,  bean.getJg_1 	());
    		pstmt.setString(6,  bean.getJg_2 	().trim());
    		pstmt.setFloat (7,  bean.getJg_3 	());
    		pstmt.setFloat (8,  bean.getJg_4 	());
    		pstmt.setFloat (9,  bean.getJg_5 	());
    		pstmt.setFloat (10, bean.getJg_6 	());
    		pstmt.setInt   (11, bean.getJg_7 	());
    		pstmt.setFloat (12, bean.getJg_8 	());
    		pstmt.setFloat (13, bean.getJg_9 	());
    		pstmt.setFloat (14, bean.getJg_10 	());
    		pstmt.setFloat (15, bean.getJg_11 	());
    		pstmt.setFloat (16, bean.getJg_12 	());
    		pstmt.setString(17, bean.getJg_13 	().trim());
    		pstmt.setString(18, bean.getJg_a 	().trim());
    		pstmt.setString(19, bean.getJg_b 	().trim());
    		pstmt.setInt   (20, bean.getJg_c 	());
    		pstmt.setInt   (21, bean.getJg_d1 	());
    		pstmt.setInt   (22, bean.getJg_d2 	());
    		pstmt.setString(23, bean.getJg_e 	().trim());
    		pstmt.setFloat (24, bean.getJg_f 	());
    		pstmt.setFloat (25, bean.getJg_g 	());
    		pstmt.setString(26, bean.getJg_h 	().trim());
    		pstmt.setString(27, bean.getJg_i 	().trim());
    		pstmt.setFloat (28, bean.getJg_j1 	());
    		pstmt.setFloat (29, bean.getJg_j2 	());
    		pstmt.setFloat (30, bean.getJg_j3 	());
    		pstmt.setString(31, bean.getNew_yn	().trim());
    		pstmt.setInt   (32, bean.getJg_d3 	());
    		pstmt.setString(33, bean.getApp_dt 	().trim());
    		pstmt.setString(34, bean.getJg_k 	().trim());
    		pstmt.setFloat (35, bean.getJg_l 	());
    		pstmt.setInt   (36, bean.getJg_e1 	());
    		pstmt.setFloat (37, bean.getJg_st1 	());
    		pstmt.setFloat (38, bean.getJg_st2	());
    		pstmt.setFloat (39, bean.getJg_st3 	());
    		pstmt.setFloat (40, bean.getJg_st4	());
    		pstmt.setFloat (41, bean.getJg_st5 	());
    		pstmt.setFloat (42, bean.getJg_st6	());
    		pstmt.setFloat (43, bean.getJg_st7 	());
    		pstmt.setFloat (44, bean.getJg_st8	());
    		pstmt.setFloat (45, bean.getJg_e_d	());
    		pstmt.setFloat (46, bean.getJg_e_e	());
    		pstmt.setInt   (47, bean.getJg_e_g	());
    		pstmt.setFloat (48, bean.getJg_st9	());
    		pstmt.setString(49, bean.getJg_q 	().trim());
    		pstmt.setFloat (50, bean.getJg_st10 ());
    		pstmt.setString(51, bean.getJg_r 	().trim());
    		pstmt.setString(52, bean.getJg_s 	().trim());
    		pstmt.setString(53, bean.getJg_t 	().trim());
    		pstmt.setFloat (54, bean.getJg_u	());
    		pstmt.setFloat (55, bean.getJg_14	());
    		pstmt.setFloat (56, bean.getJg_3_1 	());
    		pstmt.setFloat (57, bean.getJg_st11 ());
    		pstmt.setFloat (58, bean.getJg_st12	());
    		pstmt.setFloat (59, bean.getJg_st13 ());
    		pstmt.setFloat (60, bean.getJg_st14	());
    		pstmt.setFloat (61, bean.getJg_5_1 	());
    		pstmt.setString(62, bean.getJg_v 	().trim());
    		pstmt.setFloat (63, bean.getJg_st15	());
    		pstmt.setString(64, bean.getJg_w 	().trim());
    		pstmt.setFloat (65, bean.getJg_x	());
    		pstmt.setFloat (66, bean.getJg_y	());
    		pstmt.setFloat (67, bean.getJg_z	());
    		pstmt.setInt   (68, bean.getJg_d4 	());
    		pstmt.setInt   (69, bean.getJg_d5 	());
    		pstmt.setFloat (70, bean.getJg_g_1	());
    		pstmt.setFloat (71, bean.getJg_g_2	());
    		pstmt.setFloat (72, bean.getJg_g_3	());
    		pstmt.setFloat (73, bean.getJg_15	());
    		pstmt.setFloat (74, bean.getJg_g_4	());
    		pstmt.setFloat (75, bean.getJg_g_5	());
    		pstmt.setFloat (76, bean.getJg_st16	());
    		pstmt.setFloat (77, bean.getJg_g_6	());
    		pstmt.setFloat (78, bean.getJg_st17	());
    		pstmt.setFloat (79, bean.getJg_st18	());
    		pstmt.setString(80, bean.getReg_dt	().trim());
    		pstmt.setFloat (81, bean.getJg_st19	());
    		pstmt.setString(82, bean.getJg_g_7 	().trim());
    		pstmt.setString(83, bean.getJg_g_8 	().trim());
    		pstmt.setString(84, bean.getJg_g_9 	().trim());
    		pstmt.setFloat (85, bean.getJg_g_10	());
    		pstmt.setFloat (86, bean.getJg_g_11	());
    		pstmt.setFloat (87, bean.getJg_g_12	());
    		pstmt.setFloat (88, bean.getJg_g_13	());
    		pstmt.setInt   (89, bean.getJg_d6 	());
    		pstmt.setInt   (90, bean.getJg_d7 	());
    		pstmt.setInt   (91, bean.getJg_d8 	());
    		pstmt.setInt   (92, bean.getJg_d9 	());
    		pstmt.setInt   (93, bean.getJg_d10 	());
    		pstmt.setFloat (94, bean.getJg_g_14	());
    		pstmt.setInt   (95, bean.getJg_g_15	());
    		pstmt.setString(96, bean.getJg_g_16	().trim());
    		pstmt.setInt   (97, bean.getJg_g_17	());
    		pstmt.setString(98, bean.getJg_g_18	().trim());	//jg_g_18 ~jg_g_33 추가(20180528)
    		pstmt.setInt   (99, bean.getJg_g_19	());
    		pstmt.setInt   (100,bean.getJg_g_20	());
    		pstmt.setString(101,bean.getJg_g_21	().trim());
    		pstmt.setInt   (102,bean.getJg_g_22	());
    		pstmt.setInt   (103,bean.getJg_g_23	());
    		pstmt.setInt   (104,bean.getJg_g_24	());
    		pstmt.setFloat (105,bean.getJg_g_25	());
    		pstmt.setString(106,bean.getJg_g_26	().trim());
    		pstmt.setInt   (107,bean.getJg_g_27	());
    		pstmt.setInt   (108,bean.getJg_g_28	());
    		pstmt.setInt   (109,bean.getJg_g_29	());
    		pstmt.setFloat (110,bean.getJg_g_30	());
    		pstmt.setFloat (111,bean.getJg_g_31	());
    		pstmt.setFloat (112,bean.getJg_g_32	());
    		pstmt.setFloat (113,bean.getJg_g_33	());
    		pstmt.setFloat (114,bean.getJg_st20 ());
    		pstmt.setFloat (115,bean.getJg_st21 ());
    		pstmt.setInt   (116,bean.getJg_g_34	());
    		pstmt.setInt   (117,bean.getJg_g_35	());
    		pstmt.setString(118,bean.getJg_g_36	().trim());
    		pstmt.setFloat (119,bean.getJg_st22 ());
    		pstmt.setFloat (120,bean.getJg_st23 ());
    		
    		
    		pstmt.addBatch();
    		pstmt.clearParameters();
    		
    		//count = pstmt.executeUpdate();
    		pstmt.executeBatch();
    		
    		pstmt.close();
    		con.commit();
    		
    	}catch(Exception se){
    		try{
    			System.out.println("[EstiDatabase:insertEstiJgVar2]"+se);
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
    	return seq;
    }

    /**
     * 차종별잔가변수 조회-세부내용
     */
    public EstiJgVarBean getEstiJgVarCase(String sh_code, String reg_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs2 = null;
        PreparedStatement pstmt3 = null;
        ResultSet rs3 = null;
        EstiJgVarBean bean = new EstiJgVarBean();
        String query = "";
        
        query = " select * from esti_jg_var where sh_code='"+sh_code+"'";

		if(reg_dt.equals("")){
			query += " and seq = (select max(seq) from esti_jg_var where sh_code='"+sh_code+"')";
		}else{
			query += " and reg_dt=replace('"+reg_dt+"','-','') ";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            if(rs.next()){
				bean.setSh_code	(rs.getString(1));
			    bean.setSeq		(rs.getString(2));
			    bean.setCom_nm	(rs.getString(3));
			    bean.setCars 	(rs.getString(4));
			    bean.setJg_1 	(rs.getFloat (5));
			    bean.setJg_2 	(rs.getString(6));
				bean.setJg_3 	(rs.getFloat (7));
			    bean.setJg_4 	(rs.getFloat (8));
			    bean.setJg_5 	(rs.getFloat (9));
			    bean.setJg_6 	(rs.getFloat (10));
			    bean.setJg_7 	(rs.getInt   (11));
			    bean.setJg_8 	(rs.getFloat (12));
				bean.setJg_9 	(rs.getFloat (13));
			    bean.setJg_10 	(rs.getFloat (14));
			    bean.setJg_11 	(rs.getFloat (15));
			    bean.setJg_12 	(rs.getFloat (16));
				bean.setJg_13 	(rs.getString(17));
			    bean.setJg_a 	(rs.getString(18));
			    bean.setJg_b 	(rs.getString(19));
			    bean.setJg_c 	(rs.getInt   (20));
			    bean.setJg_d1 	(rs.getInt   (21));
			    bean.setJg_d2 	(rs.getInt   (22));
				bean.setJg_e 	(rs.getString(23));
			    bean.setJg_f 	(rs.getFloat (24));
			    bean.setJg_g 	(rs.getFloat (25));
			    bean.setJg_h 	(rs.getString(26));
			    bean.setJg_i 	(rs.getString(27));
			    bean.setJg_j1 	(rs.getFloat(28));
				bean.setJg_j2 	(rs.getFloat(29));
			    bean.setJg_j3 	(rs.getFloat(30));
			    bean.setReg_dt 	(rs.getString(31));
				bean.setNew_yn 	(rs.getString(32));
			    bean.setJg_d3 	(rs.getInt   (33));
			    bean.setApp_dt 	(rs.getString(36));
			    bean.setJg_k 	(rs.getString(35));
			    bean.setJg_l 	(rs.getFloat (34));
			    bean.setJg_e1 	(rs.getInt   (37));
			    bean.setJg_st1 	(rs.getFloat (38));
			    bean.setJg_st2 	(rs.getFloat (39));
			    bean.setJg_st3 	(rs.getFloat (40));
			    bean.setJg_st4 	(rs.getFloat (41));
			    bean.setJg_st5 	(rs.getFloat (42));
			    bean.setJg_st6 	(rs.getFloat (43));
			    bean.setJg_st7 	(rs.getFloat (44));
			    bean.setJg_st8 	(rs.getFloat (45));
			    bean.setJg_e_d 	(rs.getFloat (46));
			    bean.setJg_e_e 	(rs.getFloat (47));
			    bean.setJg_e_g 	(rs.getInt   (48));
			    bean.setJg_st9 	(rs.getFloat (49));
				bean.setJg_q 	(rs.getString(50));
			    bean.setJg_st10 (rs.getFloat (51));
				bean.setJg_r 	(rs.getString(52));
				bean.setJg_s 	(rs.getString(53));
				bean.setJg_t 	(rs.getString(54));
			    bean.setJg_u 	(rs.getFloat (55));
			    bean.setJg_14 	(rs.getFloat (56));
				bean.setJg_3_1 	(rs.getFloat (57));
			    bean.setJg_st11 (rs.getFloat (58));
			    bean.setJg_st12 (rs.getFloat (59));
			    bean.setJg_st13 (rs.getFloat (60));
			    bean.setJg_st14 (rs.getFloat (61));
				bean.setJg_5_1 	(rs.getFloat (62));
				bean.setJg_v 	(rs.getString(63));
				bean.setJg_st15 (rs.getFloat (64));
				bean.setJg_w 	(rs.getString(65));
				bean.setJg_x	(rs.getFloat (66));
				bean.setJg_y	(rs.getFloat (67));
				bean.setJg_z	(rs.getFloat (68));
			    bean.setJg_d4 	(rs.getInt   (69));
			    bean.setJg_d5 	(rs.getInt   (70));
				bean.setJg_g_1	(rs.getFloat (71));
				bean.setJg_g_2	(rs.getFloat (72));
				bean.setJg_g_3	(rs.getFloat (73));
				bean.setJg_15 	(rs.getFloat (74));
				bean.setJg_g_4	(rs.getFloat (75));
				bean.setJg_g_5	(rs.getFloat (76));
				bean.setJg_st16 (rs.getFloat (77));
				bean.setJg_g_6	(rs.getFloat (78));
				bean.setJg_st17 (rs.getFloat (79));
				bean.setJg_st18 (rs.getFloat (80));
				bean.setJg_st19 (rs.getFloat (81));
				bean.setJg_g_7 	(rs.getString(82));
				bean.setJg_g_8 	(rs.getString(83));
				bean.setJg_g_9 	(rs.getString(84));
				bean.setJg_g_10 (rs.getFloat (85));
				bean.setJg_g_11 (rs.getFloat (86));
				bean.setJg_g_12 (rs.getFloat (87));
				bean.setJg_g_13 (rs.getFloat (88));
			    bean.setJg_d6 	(rs.getInt   (89));
			    bean.setJg_d7 	(rs.getInt   (90));
				bean.setJg_d8 	(rs.getInt   (91));
				bean.setJg_d9 	(rs.getInt   (92));
				bean.setJg_d10 	(rs.getInt   (93));
				bean.setJg_g_14 (rs.getFloat (94));
				bean.setJg_g_15	(rs.getInt   (95));
				bean.setJg_g_16 (rs.getString(96));
				bean.setJg_g_17	(rs.getInt   (97));
				bean.setJg_g_18	(rs.getString(98));		//jg_g_18 ~jg_g_33 추가(20180528)
				bean.setJg_g_19	(rs.getInt   (99));
				bean.setJg_g_20	(rs.getInt   (100));
				bean.setJg_g_21	(rs.getString(101));
				bean.setJg_g_22	(rs.getInt   (102));
				bean.setJg_g_23	(rs.getInt   (103));
				bean.setJg_g_24	(rs.getInt   (104));
				bean.setJg_g_25	(rs.getFloat (105));
				bean.setJg_g_26	(rs.getString(106));
				bean.setJg_g_27	(rs.getInt   (107));
				bean.setJg_g_28	(rs.getInt   (108));
				bean.setJg_g_29	(rs.getInt   (109));
				bean.setJg_g_30	(rs.getFloat (110));
				bean.setJg_g_31	(rs.getFloat (111));
				bean.setJg_g_32	(rs.getFloat (112));
				bean.setJg_g_33	(rs.getFloat (113));
			    bean.setJg_st20 (rs.getFloat (114));
			    bean.setJg_st21 (rs.getFloat (115));
				bean.setJg_g_34	(rs.getInt   (116));
				bean.setJg_g_35	(rs.getInt   (117));
				bean.setJg_g_36	(rs.getString(118));
				bean.setJg_st22 (rs.getFloat (119));
				bean.setJg_st23 (rs.getFloat (120));
				bean.setJg_g_38(rs.getInt(121));
				bean.setJg_g_39(rs.getInt(122));
				bean.setJg_g_40(rs.getInt(123));
				bean.setJg_g_41(rs.getInt(124));
				bean.setJg_g_42(rs.getInt(125));
				bean.setJg_g_43(rs.getInt(126));
				bean.setJg_g_44(rs.getInt(127));
				bean.setJg_g_45(rs.getFloat(128));
				bean.setJg_g_46(rs.getInt(129));

			}else{
				//없으면.. 	
				//기준일자보다 작은 변수등록일이 없다면 최초 등록일자의 데이타를 가져온다..
				query = " select count(0) cnt from esti_jg_var where sh_code='"+sh_code+"' and reg_dt<='"+reg_dt+"'";
				pstmt3 = con.prepareStatement(query);  		    		
	    		rs3 = pstmt3.executeQuery();
				int count = 0;
		        if(rs3.next()){
					count = rs3.getInt("cnt");
				}
				rs3.close();
				pstmt3.close();
				//최초등록분을 가져온다.
				if(count ==0){
					query = " select * from esti_jg_var where sh_code='"+sh_code+"'";
					query += " and seq = (select min(seq) from esti_jg_var where sh_code='"+sh_code+"')";
					pstmt2 = con.prepareStatement(query);  		    		
					rs2 = pstmt2.executeQuery();
					if(rs2.next()){
						bean.setSh_code	(rs2.getString(1));
					    bean.setSeq		(rs2.getString(2));
					    bean.setCom_nm	(rs2.getString(3));
					    bean.setCars 	(rs2.getString(4));
					    bean.setJg_1 	(rs2.getFloat (5));
					    bean.setJg_2 	(rs2.getString(6));
						bean.setJg_3 	(rs2.getFloat (7));
					    bean.setJg_4 	(rs2.getFloat (8));
					    bean.setJg_5 	(rs2.getFloat (9));
					    bean.setJg_6 	(rs2.getFloat (10));
					    bean.setJg_7 	(rs2.getInt   (11));
					    bean.setJg_8 	(rs2.getFloat (12));
						bean.setJg_9 	(rs2.getFloat (13));
					    bean.setJg_10 	(rs2.getFloat (14));
					    bean.setJg_11 	(rs2.getFloat (15));
					    bean.setJg_12 	(rs2.getFloat (16));
						bean.setJg_13 	(rs2.getString(17));
					    bean.setJg_a 	(rs2.getString(18));
					    bean.setJg_b 	(rs2.getString(19));
					    bean.setJg_c 	(rs2.getInt   (20));
					    bean.setJg_d1 	(rs2.getInt   (21));
					    bean.setJg_d2 	(rs2.getInt   (22));
						bean.setJg_e 	(rs2.getString(23));
					    bean.setJg_f 	(rs2.getFloat (24));
					    bean.setJg_g 	(rs2.getFloat (25));
					    bean.setJg_h 	(rs2.getString(26));
					    bean.setJg_i 	(rs2.getString(27));
					    bean.setJg_j1 	(rs2.getFloat(28));
						bean.setJg_j2 	(rs2.getFloat(29));
					    bean.setJg_j3 	(rs2.getFloat(30));
					    bean.setReg_dt 	(rs2.getString(31));
						bean.setNew_yn 	(rs2.getString(32));
					    bean.setJg_d3 	(rs2.getInt   (33));
					    bean.setApp_dt 	(rs2.getString(36));
					    bean.setJg_k 	(rs2.getString(35));
					    bean.setJg_l 	(rs2.getFloat (34));
					    bean.setJg_e1 	(rs2.getInt   (37));
					    bean.setJg_st1 	(rs2.getFloat (38));
					    bean.setJg_st2 	(rs2.getFloat (39));
					    bean.setJg_st3 	(rs2.getFloat (40));
					    bean.setJg_st4 	(rs2.getFloat (41));
					    bean.setJg_st5 	(rs2.getFloat (42));
					    bean.setJg_st6 	(rs2.getFloat (43));
					    bean.setJg_st7 	(rs2.getFloat (44));
					    bean.setJg_st8 	(rs2.getFloat (45));
					    bean.setJg_e_d 	(rs2.getFloat (46));
					    bean.setJg_e_e 	(rs2.getFloat (47));
					    bean.setJg_e_g 	(rs2.getInt   (48));
					    bean.setJg_st9 	(rs2.getFloat (49));
						bean.setJg_q 	(rs2.getString(50));
					    bean.setJg_st10 (rs2.getFloat (51));
						bean.setJg_r 	(rs2.getString(52));
						bean.setJg_s 	(rs2.getString(53));
						bean.setJg_t 	(rs2.getString(54));
					    bean.setJg_u 	(rs2.getFloat (55));
					    bean.setJg_14 	(rs2.getFloat (56));
						bean.setJg_3_1 	(rs2.getFloat (57));
					    bean.setJg_st11 (rs2.getFloat (58));
					    bean.setJg_st12 (rs2.getFloat (59));
					    bean.setJg_st13 (rs2.getFloat (60));
					    bean.setJg_st14 (rs2.getFloat (61));
						bean.setJg_5_1 	(rs2.getFloat (62));
						bean.setJg_v 	(rs2.getString(63));
						bean.setJg_st15 (rs2.getFloat (64));	
						bean.setJg_w 	(rs2.getString(65));
						bean.setJg_x	(rs2.getFloat (66));
						bean.setJg_y	(rs2.getFloat (67));
						bean.setJg_z	(rs2.getFloat (68));
					    bean.setJg_d4 	(rs2.getInt   (69));
					    bean.setJg_d5 	(rs2.getInt   (70));
						bean.setJg_g_1	(rs2.getFloat (71));
						bean.setJg_g_2	(rs2.getFloat (72));
						bean.setJg_g_3	(rs2.getFloat (73));
						bean.setJg_15 	(rs2.getFloat (74));
						bean.setJg_g_4	(rs2.getFloat (75));
						bean.setJg_g_5	(rs2.getFloat (76));
						bean.setJg_st16 (rs2.getFloat (77));
						bean.setJg_g_6	(rs2.getFloat (78));
						bean.setJg_st17 (rs2.getFloat (79));
						bean.setJg_st18 (rs2.getFloat (80));
						bean.setJg_st19 (rs2.getFloat (81));
						bean.setJg_g_7 	(rs2.getString(82));
						bean.setJg_g_8 	(rs2.getString(83));
						bean.setJg_g_9 	(rs2.getString(84));
						bean.setJg_g_10 (rs2.getFloat (85));
						bean.setJg_g_11 (rs2.getFloat (86));
						bean.setJg_g_12 (rs2.getFloat (87));
						bean.setJg_g_13 (rs2.getFloat (88));
					    bean.setJg_d6 	(rs.getInt   (89));
					    bean.setJg_d7 	(rs.getInt   (90));
						bean.setJg_d8 	(rs.getInt   (91));
						bean.setJg_d9 	(rs.getInt   (92));
						bean.setJg_d10 	(rs.getInt   (93));
						bean.setJg_g_14 (rs.getFloat (94));
						bean.setJg_g_15	(rs.getInt   (95));
						bean.setJg_g_16 (rs.getString(96));
						bean.setJg_g_17	(rs.getInt   (97));						
						bean.setJg_g_18	(rs.getString(98));		//jg_g_18 ~jg_g_33 추가(20180528)
						bean.setJg_g_19	(rs.getInt   (99));
						bean.setJg_g_20	(rs.getInt   (100));
						bean.setJg_g_21	(rs.getString(101));
						bean.setJg_g_22	(rs.getInt   (102));
						bean.setJg_g_23	(rs.getInt   (103));
						bean.setJg_g_24	(rs.getInt   (104));
						bean.setJg_g_25	(rs.getFloat (105));
						bean.setJg_g_26	(rs.getString(106));
						bean.setJg_g_27	(rs.getInt   (107));
						bean.setJg_g_28	(rs.getInt   (108));
						bean.setJg_g_29	(rs.getInt   (109));
						bean.setJg_g_30	(rs.getFloat (110));
						bean.setJg_g_31	(rs.getFloat (111));
						bean.setJg_g_32	(rs.getFloat (112));
						bean.setJg_g_33	(rs.getFloat (113));
					    bean.setJg_st20 (rs.getFloat (114));
					    bean.setJg_st21 (rs.getFloat (115));
					    bean.setJg_g_34	(rs.getInt   (116));
						bean.setJg_g_35	(rs.getInt   (117));
						bean.setJg_g_36	(rs.getString(118));
						bean.setJg_st22 (rs.getFloat (119));
						bean.setJg_st23 (rs.getFloat (120));
						bean.setJg_g_38(rs.getInt(121));
						bean.setJg_g_39(rs.getInt(122));
						bean.setJg_g_40(rs.getInt(123));
						bean.setJg_g_41(rs.getInt(124));
						bean.setJg_g_42(rs.getInt(125));
						bean.setJg_g_43(rs.getInt(126));

					}
					rs2.close();
					pstmt2.close();
				}
			}
            rs.close();
            pstmt.close();
		}catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiJgVarCase]"+se);
			System.out.println("[EstiDatabase:getEstiJgVarCase]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
                if(rs2 != null ) rs2.close();
                if(pstmt2 != null) pstmt2.close();
                if(rs3 != null ) rs3.close();
                if(pstmt3 != null) pstmt3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	//스페셜견적----------------------------------------------------------------------------------

	/**
     * 견적서관리 등록.
     */
      public int insertEstiSpe(EstiSpeBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

        query = " INSERT INTO ESTI_SPE"+
				" (est_id, est_st, est_nm, est_ssn, est_tel, est_agnt, est_bus, est_year, car_nm, etc, est_area, reg_dt, est_fax, car_nm2, car_nm3, est_email, client_yn)"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   to_char(sysdate,'YYYYMMDDHH24MI'), ?, ?, ?, ?, ?)";
           
	   try{
		   con.setAutoCommit(false);

			if(bean.getEst_id().equals("") || bean.getEst_st().equals("") || bean.getEst_nm().equals("")){

				System.out.println("[EstiDatabase:insertEstiSpe] 필수값이 없습니다.");
				System.out.println("[bean.getEst_id().trim()	]"+bean.getEst_id().trim()		);
				System.out.println("[bean.getEst_st().trim()	]"+bean.getEst_st().trim()		);
				System.out.println("[bean.getEst_nm().trim()	]"+bean.getEst_nm().trim()		);

			}else{

				pstmt = con.prepareStatement(query);

	            pstmt.setString(1,  bean.getEst_id().trim()		);
				pstmt.setString(2,  bean.getEst_st().trim()		);
				pstmt.setString(3,  bean.getEst_nm().trim()		);
				pstmt.setString(4,  bean.getEst_ssn().trim()	);
				pstmt.setString(5,  bean.getEst_tel().trim()	);
				pstmt.setString(6,  bean.getEst_agnt().trim()	);
				pstmt.setString(7,  bean.getEst_bus().trim()	);
				pstmt.setString(8,  bean.getEst_year().trim()	);
				pstmt.setString(9,  bean.getCar_nm().trim()		);
				pstmt.setString(10, bean.getEtc().trim()		);
				pstmt.setString(11, bean.getEst_area().trim()	);
				pstmt.setString(12, bean.getEst_fax().trim()	);
				pstmt.setString(13, bean.getCar_nm2().trim()	);
				pstmt.setString(14, bean.getCar_nm3().trim()	);
				pstmt.setString(15, bean.getEst_email().trim()	);
				pstmt.setString(16, bean.getClient_yn().trim()	);

				count = pstmt.executeUpdate();
				pstmt.close();
			}
            
            
			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstiSpe]"+se);

				System.out.println("[bean.getEst_id().trim()	]"+bean.getEst_id().trim()		);
				System.out.println("[bean.getEst_st().trim()	]"+bean.getEst_st().trim()		);
				System.out.println("[bean.getEst_nm().trim()	]"+bean.getEst_nm().trim()		);
				System.out.println("[bean.getEst_ssn().trim()	]"+bean.getEst_ssn().trim()		);
				System.out.println("[bean.getEst_tel().trim()	]"+bean.getEst_tel().trim()		);
				System.out.println("[bean.getEst_agnt().trim()	]"+bean.getEst_agnt().trim()	);
				System.out.println("[bean.getEst_bus().trim()	]"+bean.getEst_bus().trim()		);
				System.out.println("[bean.getEst_year().trim()	]"+bean.getEst_year().trim()	);
				System.out.println("[bean.getCar_nm().trim()	]"+bean.getCar_nm().trim()		);
				System.out.println("[bean.getEtc().trim()		]"+bean.getEtc().trim()			);
				System.out.println("[bean.getEst_area().trim()	]"+bean.getEst_area().trim()	);
				System.out.println("[bean.getEst_fax().trim()	]"+bean.getEst_fax().trim()		);
				System.out.println("[bean.getCar_nm2().trim()	]"+bean.getCar_nm2().trim()		);
				System.out.println("[bean.getCar_nm3().trim()	]"+bean.getCar_nm3().trim()		);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null) pstmt.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    /**
     * 스페셜견적관리 전체조회
     */
    public EstiSpeBean [] getEstiSpeList(String gubun1, String gubun2, String gubun3, String gubun4, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt, String branch) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        //est_st 구분 : '1'-홈페이지 사업자, '2'-홈페이지 개인, '9'-홈페이지 사전예약, 'B'-모바일 사업자, 'P'-모바일 개인, 'M'-월렌트 사업자, 'N'-월렌트개인
		query = " select a.*, case when b.reg_dt is null and t.reg_dt is null and e.reg_dt is null then '1' else '2' end  so,   \n" + 
				"  SUBSTR(est_area, 0,2) as est_area2, SUBSTR(est_area, 4,5) as county , b.note as b_note, b.reg_dt as b_reg_dt, \n" +
				"  t.user_id t_user_id, t.reg_dt t_reg_dt, t.note t_note, e.reg_dt as m_reg_dt, e.note as rent_yn, e.user_id as m_user_id,  " +
				"  decode(a.est_id,'S','스페셜견적','U','중고차리스') est_gubun  \n" +				
				"  from esti_spe a, "+
				"	   (select est_id, max(seq_no) seq_no from esti_m where nvl(gubun, 'A') in ( 'A' ) group by est_id) d, esti_m e,   \n" +
				"	   (select a.est_id, a.user_id, a.reg_dt, a.note  from esti_m a , ( select est_id, min(seq_no) seq_no from esti_m where nvl(gubun, 'A') in ( 'A', '0')  group by est_id ) b "+	
				"                     where  a.est_id = b.est_id and a.seq_no = b.seq_no and nvl(a.gubun, 'A')  in ( 'A' , '0') ) t ,  \n"+	
				"           (select est_id, note, reg_dt from esti_m where  gubun in ( '1' ,'2', '3' ) ) b, users f   \n";		

	//	if(esti_m.equals("1")){
	//		query +=" , (select est_id, note, reg_dt from esti_m where  gubun in ( '1' ,'2', '3' ) ) b, users f ";
	//	}else if(esti_m.equals("1")){
	//		query +=" , (select est_id, note, reg_dt from esti_m where  gubun in ( '1' , '3' ) ) b, users f ";
	//	}else{
	//		query +=" , (select est_id, note, reg_dt from esti_m where  gubun in ( '1' ,'2', '3' ) ) b, users f ";
	//	}

		query +=" where "+
				" a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and a.est_id=t.est_id(+) and a.est_id=b.est_id(+)  and t.user_id = f.user_id (+)  \n";		 

		//if(gubun2.equals(""))	query += "and a.est_st in ('1','2','B','P','M','N','PM1','PM2','PM3','PS1','PS2','PS3','PJ1','PJ2','PJ3','MSB','MSP','MJB','MJP','MMB','MMP')";
		if(gubun2.equals(""))   query += "and a.est_st in ('1','2','B','P','M','N','PS1','PS2','PS3','PJ1','PJ2','PJ3','MSB','MSP','MJB','MJP','MMB','MMP' , 'MS1','MS2','MS3','MJ1','MJ2','MJ3', 'PE9', 'PH9', 'ME9', 'MH9', 'PC4', 'MO4', 'ARS')";
		if(gubun2.equals("1"))	query += "and a.est_st in ('1','2','B','P','PS1','PS2','PS3','PJ1','PJ2','PJ3','MSB','MSP','MJB','MJP', 'MS1','MS2','MS3','MJ1','MJ2','MJ3')";
		if(gubun2.equals("2"))	query += "and a.est_st in ('M','N','PM1','PM2','PM3','MMB','MMP')";
		if(gubun2.equals("3"))	query += "and a.est_st in ('1','2','PS1','PS2','PS3','PJ1','PJ2','PJ3','PM1','PM2','PM3')";
		if(gubun2.equals("4"))	query += "and a.est_st in ('B','P','MSB','MSP','MJB','MJP','MMB','MMP')";
		if(gubun2.equals("5"))	query += "and a.est_st in ('PS1','PS2','PS3')";
		if(gubun2.equals("6"))	query += "and a.est_st in ('PJ1','PJ2','PJ3')";
		if(gubun2.equals("7"))	query += "and a.est_st in ('PM1','PM2','PM3')";
		if(gubun2.equals("8"))	query += "and a.est_st in ('MSB','MSP')";
		if(gubun2.equals("9"))	query += "and a.est_st in ('MJB','MJP')";
		if(gubun2.equals("10"))	query += "and a.est_st in ('MMB','MMP')";
		if(gubun2.equals("15"))	query += "and a.est_st in ('PE9', 'PH9', 'ME9', 'MH9')";
		if(gubun2.equals("20"))	query += "and a.est_st in ('PC4', 'MO4')";
		if(gubun2.equals("99"))	query += "and a.est_st in ('ARS')";

		//상담여부
//		if(esti_m.equals("1"))		query += " and t.reg_dt IS not null ";
//		else if(esti_m.equals("2"))	query += " and t.reg_dt IS null ";

		//상세조회 + 상담여부
		if(esti_m.equals("")){ //상담여부 전체
			if(gubun4.equals("1")) query += " AND (a.reg_dt like to_char(sysdate,'YYYYMM')||'%' OR a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' AND t.note IS NULL AND b.note IS null AND e.note IS null  )  ";
			if(gubun4.equals("2")) query += " and a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
			if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
			if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			if(gubun4.equals("5")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
		}else if(esti_m.equals("1")){ //상담여부 = 완료
			if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%' and t.reg_dt IS not null ";
			if(gubun4.equals("2")) query += " and a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' and t.reg_dt IS not null ";
			if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','') and t.reg_dt IS not null ";
			if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' and t.reg_dt IS not null ";
			if(gubun4.equals("5")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%' and t.reg_dt IS not null ";
		}else if(esti_m.equals("2")){ //상담여부 = 미상담
			if(gubun4.equals("1")) query += " AND ( a.reg_dt like to_char(sysdate,'YYYYMM')||'%' OR a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%') and t.reg_dt IS null ";
			if(gubun4.equals("2")) query += " and a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' and t.reg_dt IS null ";
			if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','') and t.reg_dt IS null ";
			if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' and t.reg_dt IS null ";
			if(gubun4.equals("5")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%' and t.reg_dt IS null ";
		}


		if(!gubun3.equals("")){
			if(gubun3.equals("1"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' ) = 'S1' ";									
			if(gubun3.equals("2"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'B1' ";
			if(gubun3.equals("3"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'D1' ";
			if(gubun3.equals("4"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'S2' ";
			if(gubun3.equals("5"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'J1' ";
			if(gubun3.equals("6"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'G1' ";
			if(gubun3.equals("7"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'I1' ";
			if(gubun3.equals("8"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'K3' ";
			if(gubun3.equals("9"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'S5' ";
			if(gubun3.equals("10"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'S6' ";
		}

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and a.car_nm like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("4")) query += " and e.user_id = '"+t_wd+"'";
			if(s_kd.equals("5")) query += " and decode(f.br_id,'S1','본사','B1','부산','D1','대전','S2','강남','J1','광주','G1','대구','I1','인천','K3','수원','U1','울산','S5','강북','S6','송파') = '"+t_wd+"'";
		}

		//영업지점별 검색 기능 추가
		if(!branch.equals("")){
			query += "  AND CASE WHEN SUBSTR(est_area, 0,2) in '서울' THEN \n" +
					 "  (CASE WHEN SUBSTR(est_area, 4,5) IN '강남구' OR SUBSTR(est_area, 4,5) IN '서초구' OR SUBSTR(est_area, 4,5) IN '성동구' OR SUBSTR(est_area, 4,5) IN '강남' THEN '강남' \n" +
					 "  WHEN SUBSTR(est_area, 4,5) IN '종로구' OR SUBSTR(est_area, 4,5) IN '동대문구' OR SUBSTR(est_area, 4,5) IN '중구' OR SUBSTR(est_area, 4,5) IN '용산구' \n" +
				  	 "  OR SUBSTR(est_area, 4,5) IN '중랑구' OR SUBSTR(est_area, 4,5) IN '노원구' OR SUBSTR(est_area, 4,5) IN '성북구' OR SUBSTR(est_area, 4,5) IN '서대문구' \n" +
					 "  OR SUBSTR(est_area, 4,5) IN '은평구' OR SUBSTR(est_area, 4,5) IN '도봉구' OR SUBSTR(est_area, 4,5) IN '강북구' OR SUBSTR(est_area, 4,5) IN '광화문' THEN '강북' \n" +
					 "  WHEN SUBSTR(est_area, 4,5) IN '송파구' OR SUBSTR(est_area, 4,5) IN '강동구' OR SUBSTR(est_area, 4,5) IN '광진구' OR SUBSTR(est_area, 4,5) IN '송파' THEN '송파' ELSE '본사' end) \n" +
					 "  WHEN SUBSTR(est_area, 0,2) in '인천' THEN '인천' \n" +
					 "  WHEN SUBSTR(est_area, 0,2) in '수원' THEN '수원' \n" +
					 "  WHEN SUBSTR(est_area, 0,2) in '경기' THEN \n" +
					 "  (CASE WHEN SUBSTR(est_area, 4,5) IN '과천시' THEN '강남' \n" +
					 "  WHEN SUBSTR(est_area, 4,5) IN '김포시' OR SUBSTR(est_area, 4,5) IN '부천시' OR SUBSTR(est_area, 4,5) IN '시흥시' THEN '인천' \n" +
					 "  WHEN SUBSTR(est_area, 4,5) IN '군포시' OR SUBSTR(est_area, 4,5) IN '수원시' OR SUBSTR(est_area, 4,5) IN '안산시' OR SUBSTR(est_area, 4,5) IN '안성시' \n" +
					 "  OR SUBSTR(est_area, 4,5) IN '여주군' OR SUBSTR(est_area, 4,5) IN '오산시' OR SUBSTR(est_area, 4,5) IN '용인시' OR SUBSTR(est_area, 4,5) IN '의왕시' \n" +
					 "  OR SUBSTR(est_area, 4,5) IN '이천시' OR SUBSTR(est_area, 4,5) IN '평택시' OR SUBSTR(est_area, 4,5) IN '화성시' THEN '수원' \n" +
					 "  WHEN SUBSTR(est_area, 4,5) IN '가평군' OR SUBSTR(est_area, 4,5) IN '성남시' OR SUBSTR(est_area, 4,5) IN '하남시' OR SUBSTR(est_area, 4,5) IN '광주시' \n" +
					 "  OR SUBSTR(est_area, 4,5) IN '남양주시' OR SUBSTR(est_area, 4,5) IN '양평군' OR SUBSTR(est_area, 4,5) IN '구리시' THEN '송파' \n" +
					 "  WHEN SUBSTR(est_area, 4,5) IN '동두천시' OR SUBSTR(est_area, 4,5) IN '양주시' OR SUBSTR(est_area, 4,5) IN '연천군' OR SUBSTR(est_area, 4,5) IN '의정부시' \n" +
					 "  OR SUBSTR(est_area, 4,5) IN '포천시' THEN '강북' ELSE '본사' end) \n" +
					 "  WHEN SUBSTR(est_area, 0,2) in '강원' THEN \n" +
					 "  (CASE WHEN SUBSTR(est_area, 4,5) IN '춘천시' OR SUBSTR(est_area, 4,5) IN '양구군' OR SUBSTR(est_area, 4,5) IN '철원군' OR SUBSTR(est_area, 4,5) IN '화천군' \n" +
					 "  OR SUBSTR(est_area, 4,5) IN '홍천군' OR SUBSTR(est_area, 4,5) IN '인제군' OR SUBSTR(est_area, 4,5) IN '고성군' OR SUBSTR(est_area, 4,5) IN '속초시' \n" +
					 "  OR SUBSTR(est_area, 4,5) IN '양양군' THEN '송파' ELSE '수원' end) \n" +
					 "  WHEN SUBSTR(est_area, 0,2) in '경남'  OR SUBSTR(est_area, 0,2) in '부산' OR SUBSTR(est_area, 0,2) in '울산' THEN '부산' \n" +
					 "  WHEN SUBSTR(est_area, 0,2) in '전남'  OR SUBSTR(est_area, 0,2) in '광주' OR SUBSTR(est_area, 0,2) in '제주' OR SUBSTR(est_area, 0,2) in '전북' THEN '광주' \n" +
					 "  WHEN SUBSTR(est_area, 0,2) in '대구'  OR SUBSTR(est_area, 0,2) in '경북' THEN '대구' \n" +
					 "  WHEN SUBSTR(est_area, 0,2) in '충남'  OR SUBSTR(est_area, 0,2) in '충북' OR SUBSTR(est_area, 0,2) in '대전' OR SUBSTR(est_area, 0,2) in '세종' THEN '대전' \n" +
					 "  END \n"; 	
			if(branch.equals("강남"))		query += "='강남'";
			if(branch.equals("강북"))		query += "='강북'";
			if(branch.equals("광주"))		query += "='광주'";
			if(branch.equals("대구"))		query += "='대구'";
			if(branch.equals("대전"))		query += "='대전'";
			if(branch.equals("본사"))		query += "='본사'";
			if(branch.equals("부산"))		query += "='부산'";
			if(branch.equals("송파"))		query += "='송파'";
			if(branch.equals("수원"))		query += "='수원'";
			if(branch.equals("인천"))		query += "='인천'";
			
		}
		
		query += " order by so asc,  a.reg_dt desc";
        
        Collection<EstiSpeBean> col = new ArrayList<EstiSpeBean>();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstiSpeBean bean = new EstiSpeBean();
				bean.setEst_id		(rs.getString("EST_ID"));
				bean.setEst_st		(rs.getString("EST_ST"));
	            bean.setEst_nm		(rs.getString("EST_NM"));
		        bean.setEst_ssn		(rs.getString("EST_SSN"));
			    bean.setEst_tel		(rs.getString("EST_TEL"));
			    bean.setEst_fax		(rs.getString("EST_FAX"));
				bean.setEst_agnt	(rs.getString("EST_AGNT"));
	            bean.setEst_bus		(rs.getString("EST_BUS"));
		        bean.setEst_year	(rs.getString("EST_YEAR"));
			    bean.setCar_nm		(rs.getString("CAR_NM"));
				bean.setEtc			(rs.getString("ETC"));
				bean.setReg_dt		(rs.getString("REG_DT"));
		        bean.setM_user_id	(rs.getString("m_user_id"));
		        bean.setM_reg_dt	(rs.getString("m_reg_dt"));
		        bean.setRent_yn		(rs.getString("RENT_YN"));
		        bean.setEst_area	(rs.getString("EST_AREA2"));
		        bean.setEst_gubun	(rs.getString("EST_GUBUN"));
				bean.setCar_nm2		(rs.getString("CAR_NM2"));
				bean.setCar_nm3		(rs.getString("CAR_NM3"));
				
				bean.setT_user_id	(rs.getString("t_user_id"));
				 bean.setT_reg_dt	(rs.getString("t_reg_dt"));
		        bean.setT_note		(rs.getString("t_note"));
		     
		        bean.setB_note		(rs.getString("b_note"));
		        bean.setB_reg_dt	(rs.getString("b_reg_dt"));
		        bean.setClient_yn	(rs.getString("CLIENT_YN"));
		        bean.setCounty		(rs.getString("COUNTY"));
		     
				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiSpeList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstiSpeBean[])col.toArray(new EstiSpeBean[0]);
    }
    
    /**
     * 스페셜견적관리 전체조회
     */
    public EstiSpeBean [] getEstiSpeList2(String gubun1, String gubun2, String gubun3, String gubun4, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt, String branch, String bus_user_id) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	String query = "";
    	//est_st 구분 : '1'-홈페이지 사업자, '2'-홈페이지 개인, '9'-홈페이지 사전예약, 'B'-모바일 사업자, 'P'-모바일 개인, 'M'-월렌트 사업자, 'N'-월렌트개인
    	query = " select a.*, case when b.reg_dt is null and t.reg_dt is null and e.reg_dt is null then '1' else '2' end  so,   \n" + 
    			"  SUBSTR(est_area, 0,2) as est_area2, SUBSTR(est_area, 4,5) as county , b.note as b_note, b.reg_dt as b_reg_dt, b.user_id as b_user_id, \n" +
    			"  t.user_id t_user_id, t.reg_dt t_reg_dt, t.note t_note, e.reg_dt as m_reg_dt, e.note as rent_yn, e.user_id as m_user_id,  " +
    			"  decode(a.est_id,'S','스페셜견적','U','중고차리스') est_gubun  \n" +				
    			"  from esti_spe a, "+
    			"	   (select est_id, max(seq_no) seq_no from esti_m where nvl(gubun, 'A') in ( 'A' ) group by est_id) d, esti_m e,   \n" +
    			"	   (select a.est_id, a.user_id, a.reg_dt, a.note  from esti_m a , ( select est_id, min(seq_no) seq_no from esti_m where nvl(gubun, 'A') in ( 'A', '0')  group by est_id ) b "+	
    			"                     where  a.est_id = b.est_id and a.seq_no = b.seq_no and nvl(a.gubun, 'A')  in ( 'A' , '0') ) t ,  \n"+	
    			"           (select est_id, note, reg_dt, user_id from esti_m where  gubun in ( '1' ,'2', '3' ) ) b, users f   \n";		
    	
    	//	if(esti_m.equals("1")){
    	//		query +=" , (select est_id, note, reg_dt from esti_m where  gubun in ( '1' ,'2', '3' ) ) b, users f ";
    	//	}else if(esti_m.equals("1")){
    	//		query +=" , (select est_id, note, reg_dt from esti_m where  gubun in ( '1' , '3' ) ) b, users f ";
    	//	}else{
    	//		query +=" , (select est_id, note, reg_dt from esti_m where  gubun in ( '1' ,'2', '3' ) ) b, users f ";
    	//	}
    	
    	query +=" where "+
    			" a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and a.est_id=t.est_id(+) and a.est_id=b.est_id(+)  and t.user_id = f.user_id (+)  \n";		 
    	
    	//if(gubun2.equals(""))	query += "and a.est_st in ('1','2','B','P','M','N','PM1','PM2','PM3','PS1','PS2','PS3','PJ1','PJ2','PJ3','MSB','MSP','MJB','MJP','MMB','MMP')";
    	//전체
    	if(gubun2.equals(""))   query += "and a.est_st in ('1','2','B','P','M','N','PS1','PS2','PS3','PJ1','PJ2','PJ3','MSB','MSP','MJB','MJP','MMB','MMP' , 'MS1','MS2','MS3','MJ1','MJ2','MJ3', 'PE9', 'PH9', 'ME9', 'MH9', 'PC4', 'MO4', 'ARS')";    	
    	//신차/재리스(PC/모바일)
    	if(gubun2.equals("1"))	query += "and a.est_st in ('1','2','B','P','PS1','PS2','PS3','PJ1','PJ2','PJ3','MSB','MSP','MJB','MJP', 'MS1','MS2','MS3','MJ1','MJ2','MJ3')";
    	/*
    	if(gubun2.equals("2"))	query += "and a.est_st in ('M','N','PM1','PM2','PM3','MMB','MMP')";    	
    	if(gubun2.equals("3"))	query += "and a.est_st in ('1','2','PS1','PS2','PS3','PJ1','PJ2','PJ3','PM1','PM2','PM3')";
    	if(gubun2.equals("4"))	query += "and a.est_st in ('B','P','MSB','MSP','MJB','MJP','MMB','MMP')";
    	if(gubun2.equals("5"))	query += "and a.est_st in ('PS1','PS2','PS3')";
    	if(gubun2.equals("6"))	query += "and a.est_st in ('PJ1','PJ2','PJ3')";
    	if(gubun2.equals("7"))	query += "and a.est_st in ('PM1','PM2','PM3')";
    	if(gubun2.equals("8"))	query += "and a.est_st in ('MSB','MSP')";
    	if(gubun2.equals("9"))	query += "and a.est_st in ('MJB','MJP')";
    	*/
    	//월렌트(모바일)    	
    	if(gubun2.equals("10"))	query += "and a.est_st in ('MMB','MMP')";
    	//친환경차사전예약
    	if(gubun2.equals("15"))	query += "and a.est_st in ('PE9', 'PH9', 'ME9', 'MH9')";
    	//간편상담
    	if(gubun2.equals("20"))	query += "and a.est_st in ('PC4', 'MO4')";
    	//ARS상담신청
    	if(gubun2.equals("99"))	query += "and a.est_st in ('ARS')";
    	    	
    	//상세조회 + 상담여부
    	if(esti_m.equals("")){ //상담여부 전체
    		if(gubun4.equals("1")) query += " AND (a.reg_dt like to_char(sysdate,'YYYYMM')||'%' OR a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' AND t.note IS NULL AND b.note IS null AND e.note IS null  )  ";
    		if(gubun4.equals("2")) query += " and a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
    		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
    		if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
    		if(gubun4.equals("5")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
    	}else if(esti_m.equals("1")){ //상담여부 = 완료
    		if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%' and t.reg_dt IS not null ";
    		if(gubun4.equals("2")) query += " and a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' and t.reg_dt IS not null ";
    		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','') and t.reg_dt IS not null ";
    		if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' and t.reg_dt IS not null ";
    		if(gubun4.equals("5")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%' and t.reg_dt IS not null ";
    	}else if(esti_m.equals("2")){ //상담여부 = 미상담
    		if(gubun4.equals("1")) query += " AND ( a.reg_dt like to_char(sysdate,'YYYYMM')||'%' OR a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%') and t.reg_dt IS null ";
    		if(gubun4.equals("2")) query += " and a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' and t.reg_dt IS null ";
    		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','') and t.reg_dt IS null ";
    		if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' and t.reg_dt IS null ";
    		if(gubun4.equals("5")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%' and t.reg_dt IS null ";
    	}
    	
    	
    	if(!gubun3.equals("")){
    		if(gubun3.equals("1"))	query += " AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' ) = 'S1' ";									
    		if(gubun3.equals("2"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'B1' ";
    		if(gubun3.equals("3"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'D1' ";
    		if(gubun3.equals("4"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'S2' ";
    		if(gubun3.equals("5"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'J1' ";
    		if(gubun3.equals("6"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'G1' ";
    		if(gubun3.equals("7"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'I1' ";
    		if(gubun3.equals("8"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'K3' ";
    		if(gubun3.equals("9"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'S5' ";
    		if(gubun3.equals("10"))	query += "  AND DECODE(a.EST_AREA, '서울/강서구','S1','서울/관악구','S1','서울/구로구','S1','서울/금천구','S1','서울/동작구','S1','서울/마포구','S1','서울/서대문구','S5','서울/양천구','S1','서울/영등포구','S1','서울/용산구','S5','서울/은평구','S5','서울/강북구','S5','서울/노원구','S5','서울/도봉구','S5','서울/성북구','S5','서울/종로구','S5','서울/중구','S5' ,'서울/강남구','S2','서울/강동구','S6','서울/광진구','S6','서울/동대문구','S5','서울/서초구','S2','서울/성동구','S2','서울/송파구','S6','서울/중랑구','S5' ,'경기/고양시','S1','경기/광명시','S1','경기/안양시','S1','경기/파주시','S1','경기/가평군','S6','경기/구리시','S6','경기/남양주시','S6','경기/동두천시','S5','경기/양주시','S5','경기/양평군','S6','경기/연천군','S5','경기/의정부시','S5','경기/포천시','S5' ,'경기/과천시','S2','경기/광주시','S6','경기/성남시','S6','경기/하남시','S6' ,'경기/김포시','I1','경기/부천시','I1','경기/시흥시','I1' ,'경기/군포시','K3','경기/수원시','K3','경기/안산시','K3','경기/안성시','K3','경기/여주군','K3','경기/오산시','K3','경기/용인시','K3','경기/의왕시','K3','경기/이천시','K3','경기/평택시','K3','경기/화성시','K3' ,'강원/철원군','S6','강원/화천군','S6','강원/춘천시','S6','강원/양구군','S6','강원/홍천군','S6','강원/인제군','S6','강원/고성군','S6','강원/속초시','S6','강원/양양군','S6','강원/원주시','K3','강원/횡선군','K3','강원/평창군','K3','강원/강릉시','K3','강원/영월군','K3','강원/정선군','K3','강원/동해시','K3','강원/삼척시','K3','강원/태백시','K3' ,'인천/중구','I1','인천/동구','I1','인천/남구','I1','인천/연수구','I1','인천/남동구','I1','인천/부평구','I1','인천/계양구','I1','인천/서구','I1','인천/강화군','I1','인천/옹진군','I1' ,'부산/중구','B1','부산/서구','B1','부산/동구','B1','부산/영도구','B1','부산/부산진구','B1','부산/동래구','B1','부산/남구','B1','부산/북구','B1','부산/해운대구','B1','부산/사하구','B1','부산/금정구','B1','부산/강서구','B1','부산/연제구','B1','부산/수영구','B1','부산/사상구','B1','부산/기장군','B1' ,'울산/중구','B1','울산/남구','B1','울산/북구','B1','울산/동구','B1','울산/울주군','B1' ,'경남/창원시','B1','경남/진주시','B1','경남/통영시','B1','경남/사천시','B1','경남/김해시','B1','경남/밀양시','B1','경남/거제시','B1','경남/양산시','B1','경남/의령군','B1' ,'경남/함안군','B1','경남/창녕군','B1','경남/고성군','B1','경남/남해군','B1','경남/하동군','B1','경남/산청군','B1','경남/함양군','B1','경남/거창군','B1','경남/합천군','B1' ,'경남/마산시','B1','경남/울산시','B1','경남/진해시','B1','제주/제주시','J1','제주/서귀포시','J1','제주/남제주군','J1','제주/북제주군','J1' ,'광주/동구','J1','광주/서구','J1','광주/남구','J1','광주/북구','J1','광주/광산구','J1' ,'전북/전주시','J1','전북/군산시','J1','전북/익산시','J1','전북/정읍시','J1' ,'전북/남원시','J1','전북/김제시','J1','전북/완주군','J1','전북/진안군','J1','전북/무주군','J1','전북/장수군','J1','전북/임실군','J1','전북/순창군','J1','전북/고창군','J1','전북/부안군','J1' ,'전남/목포시','J1','전남/여수시','J1','전남/순천시','J1','전남/나주시','J1','전남/광양시','J1','전남/담양군','J1','전남/곡성군','J1','전남/구례군','J1','전남/고흥군','J1','전남/보성군','J1' ,'전남/화순군','J1','전남/장흥군','J1','전남/강진군','J1','전남/해남군','J1','전남/영암군','J1','전남/무안군','J1','전남/함평군','J1','전남/영광군','J1','전남/장성군','J1','전남/완도군','J1' ,'전남/진도군','J1','전남/신안군','J1' ,'대구/중구','G1','대구/동구','G1','대구/서구','G1','대구/남구','G1','대구/북구','G1','대구/수성구','G1','대구/달서구','G1','대구/달성군','G1' ,'경북/포항시','G1','경북/경주시','G1','경북/안동시','G1','경북/구미시','G1','경북/영주시','G1','경북/영천시','G1','경북/상주시','G1','경북/문경시','G1','경북/경산시','G1','경북/군위군','G1' ,'경북/의성군','G1','경북/청송군','G1','경북/영양군','G1','경북/영억군','G1','경북/청도군','G1','경북/고령군','G1','경북/성주군','G1','경북/칠곡군','G1','경북/예천군','G1','경북/봉화군','G1' ,'경북/울진군','G1','경북/울릉군','G1' ,'경북/김천시','D1' ,'대전/동구','D1','대전/중구','D1','대전/서구','D1','대전/유성구','D1','대전/대덕구','D1' ,'충북/청주시','D1','충북/충주시','D1' ,'충북/제천시','D1','충북/청원군','D1','충북/보은군','D1','충북/옥천군','D1','충북/영동군','D1','충북/증평군','D1','충북/진천군','D1','충북/괴산군','D1','충북/음성군','D1','충북/단양군','D1' ,'충남/천안시','D1','충남/공주시','D1','충남/보령시','D1','충남/아산시','D1','충남/서산시','D1','충남/논산시','D1','충남/계룡시','D1','충남/당진시','D1','충남/금산군','D1','충남/부여군','D1' ,'충남/서천군','D1','충남/청양군','D1','충남/홍성군','D1','충남/예산군','D1','충남/태안군','D1','세종/세종특별자치시','D1' )  = 'S6' ";
    	}
    	
    	if(!t_wd.equals("")){
    		if(s_kd.equals("1")) query += " and a.car_nm like '%"+t_wd+"%'";
    		if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
    		if(s_kd.equals("4")) query += " and e.user_id = '"+t_wd+"'";
    		if(s_kd.equals("5")) query += " and decode(f.br_id,'S1','본사','B1','부산','D1','대전','S2','강남','J1','광주','G1','대구','I1','인천','K3','수원','U1','울산','S5','강북','S6','송파') = '"+t_wd+"'";
    	}
    	
    	//영업지점별 검색 기능 추가
    	if(!branch.equals("")){
    		query += "  AND CASE WHEN SUBSTR(est_area, 0,2) in '서울' THEN \n" +
    				"  (CASE WHEN SUBSTR(est_area, 4,5) IN '강남구' OR SUBSTR(est_area, 4,5) IN '서초구' OR SUBSTR(est_area, 4,5) IN '성동구' OR SUBSTR(est_area, 4,5) IN '강남' THEN '강남' \n" +
    				"  WHEN SUBSTR(est_area, 4,5) IN '종로구' OR SUBSTR(est_area, 4,5) IN '동대문구' OR SUBSTR(est_area, 4,5) IN '중구' OR SUBSTR(est_area, 4,5) IN '용산구' \n" +
    				"  OR SUBSTR(est_area, 4,5) IN '중랑구' OR SUBSTR(est_area, 4,5) IN '노원구' OR SUBSTR(est_area, 4,5) IN '성북구' OR SUBSTR(est_area, 4,5) IN '서대문구' \n" +
    				"  OR SUBSTR(est_area, 4,5) IN '은평구' OR SUBSTR(est_area, 4,5) IN '도봉구' OR SUBSTR(est_area, 4,5) IN '강북구' OR SUBSTR(est_area, 4,5) IN '광화문' THEN '강북' \n" +
    				"  WHEN SUBSTR(est_area, 4,5) IN '송파구' OR SUBSTR(est_area, 4,5) IN '강동구' OR SUBSTR(est_area, 4,5) IN '광진구' OR SUBSTR(est_area, 4,5) IN '송파' THEN '송파' ELSE '본사' end) \n" +
    				"  WHEN SUBSTR(est_area, 0,2) in '인천' THEN '인천' \n" +
    				"  WHEN SUBSTR(est_area, 0,2) in '수원' THEN '수원' \n" +
    				"  WHEN SUBSTR(est_area, 0,2) in '경기' THEN \n" +
    				"  (CASE WHEN SUBSTR(est_area, 4,5) IN '과천시' THEN '강남' \n" +
    				"  WHEN SUBSTR(est_area, 4,5) IN '김포시' OR SUBSTR(est_area, 4,5) IN '부천시' OR SUBSTR(est_area, 4,5) IN '시흥시' THEN '인천' \n" +
    				"  WHEN SUBSTR(est_area, 4,5) IN '군포시' OR SUBSTR(est_area, 4,5) IN '수원시' OR SUBSTR(est_area, 4,5) IN '안산시' OR SUBSTR(est_area, 4,5) IN '안성시' \n" +
    				"  OR SUBSTR(est_area, 4,5) IN '여주군' OR SUBSTR(est_area, 4,5) IN '오산시' OR SUBSTR(est_area, 4,5) IN '용인시' OR SUBSTR(est_area, 4,5) IN '의왕시' \n" +
    				"  OR SUBSTR(est_area, 4,5) IN '이천시' OR SUBSTR(est_area, 4,5) IN '평택시' OR SUBSTR(est_area, 4,5) IN '화성시' THEN '수원' \n" +
    				"  WHEN SUBSTR(est_area, 4,5) IN '가평군' OR SUBSTR(est_area, 4,5) IN '성남시' OR SUBSTR(est_area, 4,5) IN '하남시' OR SUBSTR(est_area, 4,5) IN '광주시' \n" +
    				"  OR SUBSTR(est_area, 4,5) IN '남양주시' OR SUBSTR(est_area, 4,5) IN '양평군' OR SUBSTR(est_area, 4,5) IN '구리시' THEN '송파' \n" +
    				"  WHEN SUBSTR(est_area, 4,5) IN '동두천시' OR SUBSTR(est_area, 4,5) IN '양주시' OR SUBSTR(est_area, 4,5) IN '연천군' OR SUBSTR(est_area, 4,5) IN '의정부시' \n" +
    				"  OR SUBSTR(est_area, 4,5) IN '포천시' THEN '강북' ELSE '본사' end) \n" +
    				"  WHEN SUBSTR(est_area, 0,2) in '강원' THEN \n" +
    				"  (CASE WHEN SUBSTR(est_area, 4,5) IN '춘천시' OR SUBSTR(est_area, 4,5) IN '양구군' OR SUBSTR(est_area, 4,5) IN '철원군' OR SUBSTR(est_area, 4,5) IN '화천군' \n" +
    				"  OR SUBSTR(est_area, 4,5) IN '홍천군' OR SUBSTR(est_area, 4,5) IN '인제군' OR SUBSTR(est_area, 4,5) IN '고성군' OR SUBSTR(est_area, 4,5) IN '속초시' \n" +
    				"  OR SUBSTR(est_area, 4,5) IN '양양군' THEN '송파' ELSE '수원' end) \n" +
    				"  WHEN SUBSTR(est_area, 0,2) in '경남'  OR SUBSTR(est_area, 0,2) in '부산' OR SUBSTR(est_area, 0,2) in '울산' THEN '부산' \n" +
    				"  WHEN SUBSTR(est_area, 0,2) in '전남'  OR SUBSTR(est_area, 0,2) in '광주' OR SUBSTR(est_area, 0,2) in '제주' OR SUBSTR(est_area, 0,2) in '전북' THEN '광주' \n" +
    				"  WHEN SUBSTR(est_area, 0,2) in '대구'  OR SUBSTR(est_area, 0,2) in '경북' THEN '대구' \n" +
    				"  WHEN SUBSTR(est_area, 0,2) in '충남'  OR SUBSTR(est_area, 0,2) in '충북' OR SUBSTR(est_area, 0,2) in '대전' OR SUBSTR(est_area, 0,2) in '세종' THEN '대전' \n" +
    				"  END \n"; 	
    		if(branch.equals("강남"))		query += "='강남'";
    		if(branch.equals("강북"))		query += "='강북'";
    		if(branch.equals("광주"))		query += "='광주'";
    		if(branch.equals("대구"))		query += "='대구'";
    		if(branch.equals("대전"))		query += "='대전'";
    		if(branch.equals("본사"))		query += "='본사'";
    		if(branch.equals("부산"))		query += "='부산'";
    		if(branch.equals("송파"))		query += "='송파'";
    		if(branch.equals("수원"))		query += "='수원'";
    		if(branch.equals("인천"))		query += "='인천'";
    		
    	}
    	
    	//통화작성자
    	if (!bus_user_id.equals("")) {
    		query += " and  (t.user_id = '"+bus_user_id+"' OR e.user_id = '"+bus_user_id+"' OR b.user_id = '"+bus_user_id+"') ";
    	}
    	
    	query += " order by so asc,  a.reg_dt desc";
    	
    	Collection<EstiSpeBean> col = new ArrayList<EstiSpeBean>();
    	try{
    		pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
    		while(rs.next()){
    			EstiSpeBean bean = new EstiSpeBean();
    			bean.setEst_id		(rs.getString("EST_ID"));
    			bean.setEst_st		(rs.getString("EST_ST"));
    			bean.setEst_nm		(rs.getString("EST_NM"));
    			bean.setEst_ssn		(rs.getString("EST_SSN"));
    			bean.setEst_tel		(rs.getString("EST_TEL"));
    			bean.setEst_fax		(rs.getString("EST_FAX"));
    			bean.setEst_agnt	(rs.getString("EST_AGNT"));
    			bean.setEst_bus		(rs.getString("EST_BUS"));
    			bean.setEst_year	(rs.getString("EST_YEAR"));
    			bean.setCar_nm		(rs.getString("CAR_NM"));
    			bean.setEtc			(rs.getString("ETC"));
    			bean.setReg_dt		(rs.getString("REG_DT"));
    			bean.setM_user_id	(rs.getString("m_user_id"));
    			bean.setM_reg_dt	(rs.getString("m_reg_dt"));
    			bean.setRent_yn		(rs.getString("RENT_YN"));
    			bean.setEst_area	(rs.getString("EST_AREA2"));
    			bean.setEst_gubun	(rs.getString("EST_GUBUN"));
    			bean.setCar_nm2		(rs.getString("CAR_NM2"));
    			bean.setCar_nm3		(rs.getString("CAR_NM3"));
    			
    			bean.setT_user_id	(rs.getString("t_user_id"));
    			bean.setT_reg_dt	(rs.getString("t_reg_dt"));
    			bean.setT_note		(rs.getString("t_note"));
    			
    			bean.setB_note		(rs.getString("b_note"));
    			bean.setB_reg_dt	(rs.getString("b_reg_dt"));
    			bean.setClient_yn	(rs.getString("CLIENT_YN"));
    			bean.setCounty		(rs.getString("COUNTY"));
    			
    			col.add(bean);
    		}
    		rs.close();
    		pstmt.close();
    	}catch(SQLException se){
    		System.out.println("[EstiDatabase:getEstiSpeList]"+se);
    		throw new DatabaseException();
    	}finally{
    		try{
    			if(rs != null ) rs.close();
    			if(pstmt != null) pstmt.close();
    		}catch(SQLException _ignored){}
    		connMgr.freeConnection(DATA_SOURCE, con);
    		con = null;
    	}
    	return (EstiSpeBean[])col.toArray(new EstiSpeBean[0]);
    }

    /**
     * 스페셜견적서관리 조회-리스트에서
     */
    public EstiSpeBean getEstiSpeCase(String est_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiSpeBean bean = new EstiSpeBean();
        String query = "";
        
        query = " select * from esti_spe where est_id='"+est_id+"'";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id			(rs.getString("EST_ID"));
				bean.setEst_st			(rs.getString("EST_ST"));
	            bean.setEst_nm			(rs.getString("EST_NM"));
		        bean.setEst_ssn			(rs.getString("EST_SSN"));
				bean.setEst_agnt		(rs.getString("EST_AGNT"));
			    bean.setEst_tel			(rs.getString("EST_TEL"));
	            bean.setEst_bus			(rs.getString("EST_BUS"));
		        bean.setEst_year		(rs.getString("EST_YEAR"));
			    bean.setCar_nm			(rs.getString("CAR_NM"));
				bean.setEtc				(rs.getString("ETC"));
				bean.setReg_dt			(rs.getString("REG_DT"));
				bean.setEst_area		(rs.getString("EST_AREA"));
			    bean.setEst_fax			(rs.getString("EST_FAX"));
				bean.setCar_nm2			(rs.getString("CAR_NM2"));
				bean.setCar_nm3			(rs.getString("CAR_NM3"));
				bean.setReg_id			(rs.getString("REG_ID"));
				bean.setEst_email		(rs.getString("EST_EMAIL"));
				bean.setClient_yn		(rs.getString("CLIENT_YN"));
				bean.setZipcode			(rs.getString("ZIPCODE"));
				bean.setAddr1			(rs.getString("ADDR1"));
			    bean.setAddr2			(rs.getString("ADDR2"));
				bean.setAccount			(rs.getString("ACCOUNT"));
				bean.setBank			(rs.getString("BANK"));
				bean.setDriver_year		(rs.getString("DRIVER_YEAR"));
				bean.setUrgen_tel		(rs.getString("URGEN_TEL"));
				bean.setEst_comp_ceo	(rs.getString("est_comp_ceo"));
				bean.setEst_comp_tel	(rs.getString("est_comp_tel"));
				bean.setEst_comp_cel	(rs.getString("est_comp_cel"));
				bean.setCar_use_addr1	(rs.getString("CAR_USE_ADDR1"));	//차량이용지주소1 추가(2018.03.13)
				bean.setCar_use_addr2	(rs.getString("CAR_USE_ADDR2"));	//차량이용지주소2 추가(2018.03.13)
				bean.setBr_from			(rs.getString("BR_FROM"));
				bean.setBr_to_st			(rs.getString("BR_TO_ST"));
				bean.setBr_to				(rs.getString("BR_TO"));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiSpeCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
     * 스페셜견적서관리번호 생성
     */
    public String getNextEst_id_S(String est_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		String n_est_id = "";

		query = " SELECT to_char(sysdate,'YYMM')||'"+est_st+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001') ID"+
				" FROM ESTI_SPE "+
				" where est_id like to_char(sysdate,'YYMM')||'%' and est_id like '%"+est_st+"%'";
		   
       try{
           

            //est_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	n_est_id = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
			System.out.println("[EstiDatabase:getNextEst_id_S]"+se);
            throw new DatabaseException();
        }finally{
            try{
           
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return n_est_id;
    }

	/**
     * 스페셜견적 대기건수
     */
    public int getSpeEstiCnt() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		int cnt = 0;
		   
		query = " select count(0)"+
				" from esti_spe a, (select est_id, max(seq_no) seq_no from esti_m where nvl(gubun, 'O') not in ('X' ) group by est_id) d, esti_m e"+
				" where "+
				" a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and e.est_id is null and e.gubun is null and a.est_st in ('1','2','B','P','M','N','PS1','PS2','PS3','PJ1','PJ2','PJ3','MSB','MSP','MJB','MJP','MMB','MMP','MS1','MS2','MS3','MJ1','MJ2','MJ3', 'PE9', 'PH9', 'ME9', 'MH9', 'PC4', 'MO4', 'ARS')";
				//" a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and e.est_id is null and e.gubun is null and a.est_st in ('1','2','B','P','M','N','PS1','PS2','PS3','PJ1','PJ2','PJ3','MSB','MSP','MJB','MJP','MMP','PE9','PH9','ME9','MH9')"

       try{
          

            //est_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	cnt = rs.getInt(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
          //  try{
			System.out.println("[EstiDatabase:getSpeEstiCnt]"+se);
             throw new DatabaseException();
       //     }catch(SQLException _ignored){}
       //       throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return cnt;
    }
    
    /**
     * 스페셜견적 ARS 대기건수
     */
    public int getSpeEstiArsCnt() throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
    	ResultSet rs = null;
    	String query = "";
    	int cnt = 0;
    	
    	query = " select count(0)"+
    			" from esti_spe a, (select est_id, max(seq_no) seq_no from esti_m where nvl(gubun, 'O') not in ('X' ) group by est_id) d, esti_m e"+
    			" where "+
    			" a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and e.est_id is null and e.gubun is null and a.est_st in ('ARS')";
    	
    	try{
    		
    		//est_id 생성
    		stmt = con.createStatement();
    		rs = stmt.executeQuery(query);
    		if(rs.next())
    			cnt = rs.getInt(1);
    		rs.close();
    		stmt.close();
    		
    	}catch(SQLException se){
    		//  try{
    		System.out.println("[EstiDatabase:getSpeEstiArsCnt]"+se);
    		throw new DatabaseException();
    		//     }catch(SQLException _ignored){}
    		//       throw new DatabaseException("exception");
    	}finally{
    		try{
    			
    			if(rs != null) rs.close();
    			if(stmt != null) stmt.close();
    		}catch(SQLException _ignored){}
    		connMgr.freeConnection(DATA_SOURCE, con);
    		con = null;
    	}
    	return cnt;
    }

	/**
	 *	계산식 조회
	 */
	public Hashtable getEstiSikVar() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable rtn = new Hashtable();
		String query = "";
		String hashtableName = "";

        query = " select a.VAR_CD, a.VAR_SIK, a.VAR_NM"+
				" from esti_sik_var a, (select a_a, var_cd, max(seq) seq from esti_sik_var group by a_a, var_cd) b"+
				" where a.a_a=b.a_a and a.var_cd=b.var_cd and a.seq=b.seq";

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
					 if(columnName.equals("VAR_CD")) hashtableName = rs.getString(columnName);
				}
				rtn.put(hashtableName, ht);
			}

			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getEstiSikVar]"+e);
			System.out.println("[EstiDatabase:getEstiSikVar]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rtn;
	}

	/**
	 *	모델,옵션,색상,할인 가격 리스트()
	 */
	public Vector getCarSubListLcRent(String idx, String car_comp_id, String car_cd, String car_id, String car_seq, String a_a, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(idx.equals("1") || idx.equals("")){//모델
		/*
			query = " select a.car_id as id, a.car_seq as seq, a.car_name as nm, a.car_b_p as amt, a.s_st, a.car_b, a.car_b_dt as base_dt"+
					" from car_nm a, (select car_id, max(car_seq) car_seq from car_nm group by car_id) b"+//
					" where a.use_yn='Y' and a.car_b_p>0 and a.car_id=b.car_id and a.car_seq=b.car_seq"+// (+)
					" and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"'";// and a.car_b_dt > to_char(sysdate-365,'YYYYMMDD')
		*/
			query = " select a.car_id as id, a.car_seq as seq, a.car_name as nm, a.car_b_p as amt, a.s_st, a.car_b, a.car_b_dt as base_dt, a.dpm, a.etc, a.car_y_form, '' jg_opt_st, a.auto_yn, a.end_dt, a.jg_tuix_st, "+
					"        a.lkas_yn, a.ldws_yn, a.aeb_yn, a.fcw_yn, a.duty_free_opt, a.garnish_yn, a.hook_yn "+					
					" from car_nm a"+//
					" where a.use_yn='Y' and a.car_b_p>0"+
					" and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"'";

			if(a_a.equals("1")) query += " and a.car_name not like '%LPG%'";
			if(a_a.equals("2")) query += " and a.car_name not like '%12인승%' and a.car_name not like '%11인승%'";

			if(!t_wd.equals("")) query += " and a.car_name||a.car_b_p like '%"+t_wd+"%'";

			query += " order by a.JG_CODE, DECODE(a.duty_free_opt, '1',1, '0',2, 3), AMT ASC, a.car_b_dt desc, a.car_name, a.car_id";

		}else if(idx.equals("2")){//옵션
			query = " select a.car_s_seq as id, a.car_u_seq as seq, a.car_s as nm, a.car_s_p as amt, '' s_st, '' car_b, a.car_s_dt as base_dt, a.opt_b as etc, '' car_y_form, a.jg_opt_st, '' auto_yn, a.jg_tuix_st, "+
					"        a.lkas_yn, a.ldws_yn, a.aeb_yn, a.fcw_yn, a.jg_opt_yn, a.garnish_yn, a.hook_yn "+
					" from car_opt a"+
					" where"+
					" nvl(a.use_yn,'Y')='Y' and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.car_id='"+car_id+"' and a.car_u_seq='"+car_seq+"'";

			if(!t_wd.equals("")) query += " and a.car_s||a.car_s_p like '%"+t_wd+"%'";

			// query += " order by decode(a.jg_tuix_st,'Y',1,0), a.car_s_p";
			query += " ORDER BY TO_NUMBER(car_rank) ASC";

		}else if(idx.equals("3")){//외장색상
			query = " select a.car_c_seq as id, a.car_u_seq as seq, a.car_c as nm, a.car_c_p as amt, '' s_st, '' car_b, a.car_c_dt as base_dt, a.etc, '' car_y_form, a.jg_opt_st, '' auto_yn, '' jg_tuix_st "+
					" from car_col a"+
					" where "+
					" a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.use_yn='Y' and nvl(a.col_st,'1')='1' ";

			if(!t_wd.equals("")) query += " and a.car_c||a.car_c_p like '%"+t_wd+"%'";

			query += " order by a.car_c_p, a.car_c";

		}else if(idx.equals("3_in")){//내장색상
			query = " select a.car_c_seq as id, a.car_u_seq as seq, a.car_c as nm, a.car_c_p as amt, '' s_st, '' car_b, a.car_c_dt as base_dt, a.etc, '' car_y_form, a.jg_opt_st, '' auto_yn "+
					" from car_col a"+
					" where "+
					" a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.use_yn='Y' and nvl(a.col_st,'1')='2' ";

			if(!t_wd.equals("")) query += " and a.car_c||a.car_c_p like '%"+t_wd+"%'";

			query += " order by to_number(a.car_c_seq)";
			
		}else if(idx.equals("3_gar")){//가니쉬색상
			query = " select a.car_c_seq as id, a.car_u_seq as seq, a.car_c as nm, a.car_c_p as amt, '' s_st, '' car_b, a.car_c_dt as base_dt, a.etc, '' car_y_form, a.jg_opt_st, '' auto_yn "+
					" from car_col a"+
					" where "+
					" a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.use_yn='Y' and nvl(a.col_st,'1')='3' ";
			
			if(!t_wd.equals("")) query += " and a.car_c||a.car_c_p like '%"+t_wd+"%'";
			
			query += " order by to_number(a.car_c_seq)";

		}else if(idx.equals("4")){//dc
			query = " select car_d_seq as id, '' as seq, car_d as nm, car_d_p as amt, '' s_st, '' car_b, '' etc, '' car_y_form, '' jg_opt_st, '' auto_yn from car_dc where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_d_st<=to_char(sysdate,'YYYYMMDD') and car_d_et>=to_char(sysdate,'YYYYMMDD') ";
		}else if(idx.equals("5")){ //연비
		    query = " select car_cd, engine, car_k_seq, car_k, car_k_etc from car_km where car_comp_id ='" + car_comp_id + "' and car_cd ="+ car_cd + " and use_yn = 'Y'";
		}
		
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
            // System.out.println("[EstiDatabase:getCarSubListLcRent]"+query);
		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getCarSubListLcRent]"+e);
			System.out.println("[EstiDatabase:getCarSubListLcRent]"+query);
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
	 *	계약견적일때 실 영업수당 조회
	 */
	public String getComm_r_rt(String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String comm_r_rt = "";
		String query = "";

        query = " select to_char(nvl(comm_r_rt,0)) from commi where rent_l_cd='"+rent_l_cd+"' and agnt_st ='1' and comm_r_rt is not null ";

		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				comm_r_rt = rs.getString(1)==null?"":rs.getString(1);
			}

			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getComm_r_rt]"+e);
			System.out.println("[EstiDatabase:getComm_r_rt]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return comm_r_rt;
	}

	/**
	 *	차종별 중고차 특소세 리스트
	 */
	public String getSpTax(String sh_code, String when) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sp_tax = "";
		String query = "";

		query = " select sp_tax from sp_tax b where sh_code=? and replace(?,'-','') between tax_st_dt and tax_end_dt";

		try {
		    pstmt = con.prepareStatement(query);
            pstmt.setString	(1, sh_code);
            pstmt.setString	(2, when);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				 sp_tax = rs.getString(1);
			}

			rs.close();
            pstmt.close();
			System.out.println("[EstiDatabase:getSpTax]"+query);
			System.out.println("[EstiDatabase:getSpTax]"+sh_code);
			System.out.println("[EstiDatabase:getSpTax]"+when);
		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getSpTax]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sp_tax;
	}

	/**
     * 차종별잔가변수 등록2.
     */
    public void updateEstiJgVarJ123() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		PreparedStatement pstmt6 = null;
		PreparedStatement pstmt7 = null;
		PreparedStatement pstmt8 = null;
		PreparedStatement pstmt9 = null;
        String query = "";
        String query1 = "";
        String query2 = "";
        String query3 = "";
        int count = 0;

           
		try{
            con.setAutoCommit(false);


			//할부이자율(12/24개월,36개월,48개월)
			query = " update ESTI_JG_VAR set jg_j1=0.0795, jg_j2=0.0795, jg_j3=0.0795 where reg_dt=to_char(sysdate,'YYYYMMDD') and jg_j1=0.08 ";
            pstmt = con.prepareStatement(query);
			count = pstmt.executeUpdate();             
            pstmt.close();

			query = " update ESTI_JG_VAR set jg_j1=0.0895, jg_j2=0.0895, jg_j3=0.0895  WHERE reg_dt=to_char(sysdate,'YYYYMMDD') AND jg_j1=0.09 ";
            pstmt2 = con.prepareStatement(query);
			count = pstmt2.executeUpdate();             
            pstmt2.close();



			//카드리베이트율
			query1 = " update ESTI_JG_VAR set jg_u=0.0166 where reg_dt=to_char(sysdate,'YYYYMMDD') and jg_u=0.017";
            pstmt3 = con.prepareStatement(query1);
			count = pstmt3.executeUpdate();             
            pstmt3.close();



			//기본특소세율
			query2 = " update ESTI_JG_VAR set jg_3=0.0455 where reg_dt=to_char(sysdate,'YYYYMMDD') and jg_3=0.046";
            pstmt4 = con.prepareStatement(query2);
			count = pstmt4.executeUpdate();             
            pstmt4.close();

			query2 = " update ESTI_JG_VAR set jg_3=0.0845 where reg_dt=to_char(sysdate,'YYYYMMDD') and jg_3=0.084";
            pstmt5 = con.prepareStatement(query2);
			count = pstmt5.executeUpdate();             
            pstmt5.close();



			//특소세2,3
			query3 = " update ESTI_JG_VAR set jg_st2=0.1365, jg_st3=0.0975 where reg_dt=to_char(sysdate,'YYYYMMDD') and jg_st1=0.195";
            pstmt6 = con.prepareStatement(query3);
			count = pstmt6.executeUpdate();             
            pstmt6.close();

			//특소세9
			query3 = " update ESTI_JG_VAR set jg_st9=0.0455 where reg_dt=to_char(sysdate,'YYYYMMDD') and jg_st9=0.046";
            pstmt7 = con.prepareStatement(query3);
			count = pstmt7.executeUpdate();             
            pstmt7.close();

			//특소세15 (2012-09-11 중간삽입)
			query3 = " update ESTI_JG_VAR set jg_st15=0.0455 where reg_dt=to_char(sysdate,'YYYYMMDD') and jg_st15=0.046";
            pstmt8 = con.prepareStatement(query3);
			count = pstmt8.executeUpdate();             
            pstmt8.close();

			query3 = " update ESTI_JG_VAR set jg_st15=0.0845 where reg_dt=to_char(sysdate,'YYYYMMDD') and jg_st15=0.084";
            pstmt9 = con.prepareStatement(query3);
			count = pstmt9.executeUpdate();             
            pstmt9.close();


			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateEstiJgVarJ123]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(pstmt != null)  pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				if(pstmt3 != null) pstmt3.close();
				if(pstmt4 != null) pstmt4.close();
				if(pstmt5 != null) pstmt5.close();
				if(pstmt6 != null) pstmt6.close();
				if(pstmt7 != null) pstmt7.close();
				if(pstmt8 != null) pstmt8.close();
				if(pstmt9 != null) pstmt9.close();

            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

	/**
	 *	모델,옵션,색상,할인 가격 리스트()
	 */
	public Vector getCarSubListLcRentOldCar(String idx, String car_comp_id, String car_cd, String car_id, String car_seq, String a_a, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(idx.equals("1") || idx.equals("")){//모델
		/*
			query = " select a.car_id as id, a.car_seq as seq, a.car_name as nm, a.car_b_p as amt, a.s_st, a.car_b, a.car_b_dt as base_dt"+
					" from car_nm a, (select car_id, max(car_seq) car_seq from car_nm group by car_id) b"+//
					" where a.use_yn='Y' and a.car_b_p>0 and a.car_id=b.car_id and a.car_seq=b.car_seq"+// (+)
					" and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"'";// and a.car_b_dt > to_char(sysdate-365,'YYYYMMDD')
		*/
			query = " select a.car_id as id, a.car_seq as seq, a.car_name as nm, a.car_b_p as amt, a.s_st, a.car_b, a.car_b_dt as base_dt, a.dpm, a.etc, a.car_y_form, '' jg_opt_st, a.auto_yn, a.end_dt, a.jg_tuix_st, a.lkas_yn, a.ldws_yn, a.aeb_yn, a.fcw_yn, a.hook_yn "+
					" from car_nm a"+//
					" where a.car_b_p>0"+
					" and a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"'";

//			if(a_a.equals("1")) query += " and a.car_name not like '%LPG%'";
//			if(a_a.equals("2")) query += " and a.car_name not like '%12인승%' and a.car_name not like '%11인승%'";

			if(!t_wd.equals("")) query += " and a.car_name||a.car_b_p like '%"+t_wd+"%'";

			query += " order by a.car_b_dt desc, a.car_name, a.car_id";

		}else if(idx.equals("2")){//옵션
			query = " select a.car_s_seq as id, a.car_u_seq as seq, a.car_s as nm, a.car_s_p as amt, '' s_st, '' car_b, a.car_s_dt as base_dt, a.opt_b as etc, '' car_y_form, a.jg_opt_st, '' auto_yn, a.jg_tuix_st, a.lkas_yn, a.ldws_yn, a.aeb_yn, a.fcw_yn, a.hook_yn "+
					" from car_opt a"+
					" where"+
					" a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"' and a.car_id='"+car_id+"' and a.car_u_seq='"+car_seq+"'";

			if(!t_wd.equals("")) query += " and a.car_s||a.car_s_p like '%"+t_wd+"%'";

			query += " order by decode(a.jg_tuix_st,'Y',1,0), a.car_s_p";

		}else if(idx.equals("3")){//색상
			query = " select a.car_c_seq as id, a.car_u_seq as seq, a.car_c as nm, a.car_c_p as amt, '' s_st, '' car_b, a.car_c_dt as base_dt, a.etc, '' car_y_form, a.jg_opt_st, '' auto_yn, '' jg_tuix_st "+
					" from car_col a"+
					" where "+
					" a.car_comp_id='"+car_comp_id+"' and a.car_cd='"+car_cd+"'";

			if(!t_wd.equals("")) query += " and a.car_c||a.car_c_p like '%"+t_wd+"%'";

		}else if(idx.equals("4")){//dc
			query = " select car_d_seq as id, '' as seq, car_d as nm, car_d_p as amt, '' s_st, '' car_b, '' etc, '' car_y_form, '' jg_opt_st, '' auto_yn from car_dc where car_comp_id='"+car_comp_id+"' and car_cd='"+car_cd+"' and car_d_st<=to_char(sysdate,'YYYYMMDD') and car_d_et>=to_char(sysdate,'YYYYMMDD') ";
		}

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
			System.out.println("[EstiDatabase:LcRentOldCar]"+e);
			System.out.println("[EstiDatabase:getCarSubListLcRentOldCar]"+query);
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
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateUsedCarList(String gubun1, String gubun2, String gubun3, String gubun4, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				" decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','U','중고차리스') est_gubun"+
				" from estimate a, car_mng b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e"+//
				" where a.est_st='3' and a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				" and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+)"+
				" and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id";


		if(gubun1.equals("1")) query += " and a.est_type='F'";
		if(gubun1.equals("2")) query += " and a.est_type='W'";
		if(gubun1.equals("3")) query += " and talk_tel is not null";	
		if(gubun1.equals("4")) query += " and a.est_type='M'";		
		if(gubun1.equals("5")) query += " and a.est_type='J'";		
		if(gubun1.equals("6")) query += " and a.est_type='U'";		

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
		
		if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("2")) query += " and a.reg_id = '"+t_wd+"'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("4")) query += " and e.user_id = '"+t_wd+"'";
		}

		if(esti_m.equals("1")) query += " and e.user_id is not null ";
		else if(esti_m.equals("2"))	query += " and e.user_id is null ";


		if(esti_m_dt.equals("1"))		query += " and e.reg_dt like to_char(sysdate,'YYYYMM')||'%' ";
		else if(esti_m_dt.equals("2"))	query += " and e.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' ";
		else if(esti_m_dt.equals("3"))	query += " and e.reg_dt between replace('"+esti_m_s_dt+"','-','') and replace('"+esti_m_e_dt+"','-','') ";

		query += " order by a.est_id desc";


        Collection<EstimateBean> col = new ArrayList<EstimateBean>();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateUsedCarList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateCaseCmp(String rent_l_cd, String rent_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate where est_id in (select max(est_id) est_id from estimate where est_type='L' and reg_id='"+rent_l_cd+"' and nvl(est_from,'rent') <>'cmp'";

		if(!rent_dt.equals("")) query += " and rent_dt='"+rent_dt+"'";

		query += " ) ";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));
	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_per(rs.getFloat("CLS_PER"));
				bean.setCtr_cls_per(rs.getFloat("CTR_CLS_PER"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setReg_code(rs.getString("REG_CODE"));
				bean.setRent_mng_id	(rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd	(rs.getString("RENT_L_CD"));
				bean.setRent_st		(rs.getString("RENT_ST"));
				bean.setDoc_type	(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setVali_type	(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
	            bean.setOpt_chk		(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt	(rs.getInt("FEE_OPT_AMT"));
				bean.setSet_code	(rs.getString("SET_CODE"));
				bean.setGi_per		(rs.getFloat("GI_PER"));
				bean.setEst_email	(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setGarnish_col		(rs.getString("GARNISH_COL")==null?"":rs.getString("GARNISH_COL"));
				bean.setCha_st_dt	(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist		(rs.getInt("B_DIST"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st	(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				bean.setRtn_run_amt		(rs.getString("rtn_run_amt")		==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));
			
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateCaseCmp]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
     * 계약관리번호 조회
     */
    public String getRent_mng_id(String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		String rent_mng_id = "";

		query = " select rent_mng_id from cont where rent_l_cd=replace('"+rent_l_cd+"',' ','') ";
		   
       try{
            con.setAutoCommit(false);

            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	rent_mng_id = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
            try{
			System.out.println("[EstiDatabase:getRent_mng_id]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return rent_mng_id;
    }

    /**
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateShList(String gubun1, String gubun2, String gubun3, String gubun4, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_no, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				" decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','연장계약','S','재리스차량') est_gubun"+
				" from estimate a, car_reg b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e"+//
				" where a.mgr_nm=b.car_mng_id and a.car_id=c.car_id(+) and a.car_seq=c.car_seq(+) "+
				" and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and nvl(a.use_yn,'Y')='Y'"+
				" ";


		if(gubun1.equals("7")) query += " and a.est_type='S'";		
		if(gubun1.equals("8")) query += " and a.est_type='L' and a.rent_st>'1'";		

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";

		if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_no||b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("2")) query += " and a.reg_id = '"+t_wd+"'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("4")) query += " and e.user_id = '"+t_wd+"'";
		}

		if(esti_m.equals("1"))		query += " and e.user_id is not null ";
		else if(esti_m.equals("2"))	query += " and e.user_id is null ";


		if(esti_m_dt.equals("1"))		query += " and e.reg_dt like to_char(sysdate,'YYYYMM')||'%' ";
		else if(esti_m_dt.equals("2"))	query += " and e.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' ";
		else if(esti_m_dt.equals("3"))	query += " and e.reg_dt between replace('"+esti_m_s_dt+"','-','') and replace('"+esti_m_e_dt+"','-','') ";

		query += " order by a.est_id desc";


        Collection<EstimateBean> col = new ArrayList<EstimateBean>();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
		        bean.setMgr_nm(rs.getString("CAR_NO"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag		(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateShList]"+se);
			System.out.println("[EstiDatabase:getEstimateShList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

	/**
	 *	업무대여 견
	 */

	public Vector getEstimateShEmpCarList(String gubun1, String gubun2, String gubun3, String gubun4, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.est_id, a.a_a, a.a_b, a.rent_dt, a.o_1, a.fee_s_amt, a.today_dist, (a.fee_s_amt+a.fee_v_amt) as fee_amt, \n"+
				"        b.car_no, b.car_nm, c.user_nm, b.init_reg_dt, b.dpm, (a.today_dist-d.today_dist) last_mon_dist, e.avg_dist, "+
				"        substr(f.deli_dt,1,8) deli_dt,"+
//				"        decode(a.rent_dt,substr(f.deli_dt,1,8),0,round(a.today_dist/(to_date(a.rent_dt,'YYYYMMDD')-to_date(b.init_reg_dt,'YYYYMMDD'))*(to_date(a.rent_dt,'YYYYMMDD')-to_date(substr(f.deli_dt,1,8),'YYYYMMDD')))) as AVERAGE_DIST1,"+
//				"        decode(a.rent_dt,substr(f.deli_dt,1,8),round(a.today_dist/(to_date(a.rent_dt,'YYYYMMDD')-to_date(b.init_reg_dt,'YYYYMMDD'))*30)) as AVERAGE_DIST2"+
				"        round(a.today_dist/(to_date(a.rent_dt,'YYYYMMDD')-to_date(b.init_reg_dt,'YYYYMMDD'))*30) as AVERAGE_DIST"+
				" from   estimate_sh a, car_reg b, users c,"+
				"        /*전월대비주행거리증감치*/"+
				"        (select est_nm, est_ssn, today_dist, to_char(add_months(to_date(est_tel,'YYYYMM'),1),'YYYYMM') est_dt  \n"+
				"         from   estimate_sh "+
				"         where  est_from ='emp_car' and est_fax='Y') d, "+
				"        /*월평균주행거리*/"+
				"        (select est_nm, est_ssn, trunc(decode(count(0),1,0,(max(today_dist)-min(today_dist))/(count(0)-1)),0) avg_dist \n"+
                "         from   estimate_sh "+
				"         where  est_from ='emp_car' and est_fax='Y' "+
				"         group by est_nm, est_ssn) e, "+
				"        (select * from rent_cont where use_st not in ('1','5')) f"+
				" where  a.est_from ='emp_car' and a.est_fax='Y'"+
				"        and a.est_ssn=b.car_mng_id"+
				"        and a.est_nm=c.user_id"+
				"        and a.est_nm=d.est_nm(+) and a.est_ssn=d.est_ssn(+) and a.est_tel=d.est_dt(+)"+
				"        and a.est_nm=e.est_nm(+) and a.est_ssn=e.est_ssn(+) "+
				"        and a.est_nm=f.cust_id(+) and a.est_ssn=f.car_mng_id(+) "+
				"        and a.rent_dt between substr(f.deli_dt,1,8) and decode(f.ret_dt,'',to_char(sysdate,'YYYYMMDD'),substr(f.ret_dt,1,8))"+
				" ";

		if(!s_dt.equals("") && e_dt.equals(""))			query += " and a.est_tel like '"+s_dt+"%'";
		else if(!s_dt.equals("") && !e_dt.equals(""))	query += " and a.est_tel='"+s_dt+""+e_dt+"'";


		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and c.user_nm like '%"+t_wd+"%'";
		}

		query += " order by a.rent_dt, c.user_id, a.est_id";

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
			System.out.println("[EstiDatabase:getEstimateShEmpCarList]"+e);
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
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateShEmpList(String gubun1, String gubun2, String gubun3, String gubun4, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_nm, d.car_name, c.user_nm "+
				" from estimate_sh a, car_reg b, users c, car_nm d"+//
				" where a.est_from ='emp_car' "+
				" and a.est_nm=b.car_mng_id"+
				" and a.est_nm=c.user_id and a.car_id=d.car_id(+) and a.car_seq=d.car_seq(+) "+
				" ";

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
		

		if(gubun4.equals("1")) query += " and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " and a.rent_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("3")) query += " and a.rent_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||d.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("2")) query += " and a.reg_id = '"+t_wd+"'";
			if(s_kd.equals("3")) query += " and c.user_nm like '%"+t_wd+"%'";
		}

		query += " order by a.rent_dt, a.est_id";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("USER_NM"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("RENT_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag		(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));				
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));		

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateShEmpList]"+se);
			System.out.println("[EstiDatabase:getEstimateShEmpList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

	/**
     * 프로시져 호출
     */
    public String call_sp_esti_janga(String reg_code, String jg_b_dt, String em_a_j, String ea_a_j, String est_table) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_JANGA     (?,?,?,?,?)}";


	    try{

			//신차잔가계산 프로시저 호출
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.setString(2, jg_b_dt);
			cstmt.setString(3, em_a_j);
			cstmt.setString(4, ea_a_j);
			cstmt.setString(5, est_table);
			cstmt.execute();

			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_janga]"+se);
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
     * 프로시져 호출
     */
    public String call_sp_esti_feeamt(String reg_code, String jg_b_dt, String em_a_j, String ea_a_j, String est_table) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_FEEAMT     (?,?,?,?,?)}";


	    try{

			//신차잔가계산 프로시저 호출
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.setString(2, jg_b_dt);
			cstmt.setString(3, em_a_j);
			cstmt.setString(4, ea_a_j);
			cstmt.setString(5, est_table);
			cstmt.execute();

			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_feeamt]"+se);
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
     * 프로시져 호출
     */
    public String call_sp_esti_clsper(String reg_code, String jg_b_dt, String em_a_j, String ea_a_j, String est_table) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_CLSPER     (?,?,?,?,?)}";


	    try{

			//신차잔가계산 프로시저 호출
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.setString(2, jg_b_dt);
			cstmt.setString(3, em_a_j);
			cstmt.setString(4, ea_a_j);
			cstmt.setString(5, est_table);
			cstmt.execute();

			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_clsper]"+se);
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
     * 프로시져 호출
     */
    public String call_sp_esti_runamt(String reg_code, String jg_b_dt, String em_a_j, String ea_a_j, String est_table) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_RUNAMT     (?,?,?,?,?)}";


	    try{

			//신차잔가계산 프로시저 호출
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.setString(2, jg_b_dt);
			cstmt.setString(3, em_a_j);
			cstmt.setString(4, ea_a_j);
			cstmt.setString(5, est_table);
			cstmt.execute();

			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_runamt]"+se);
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
     * 프로시져 호출
     */
    public String call_sp_esti_reg_hp2() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_REG_HP2}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);				
			cstmt.execute();
			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_hp2]"+se);
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
     * 프로시져 호출
     */
    public String call_sp_esti_reg_hp(String est_tel) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_REG_HP(?)}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, est_tel);
			cstmt.execute();
            cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_hp]"+se);
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

			//주요차종 견적등록 프로시저 호출
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
	 *	reg_code 견적리스트
	 */
	public Vector getEstiMateRegCodeList(String reg_code, String esti_table, String car_mng_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		if(esti_table.equals("estimate_hp")){

			query = " select 'estimate_hp' as t_st, t.est_nm as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate_hp t, esti_compare_hp p, esti_exam_hp x    "+
					" where   t.reg_code='"+reg_code+"' "+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
//					"         and t.est_nm like '%36_%'"+
//					"         AND t.mgr_ssn IS NULL  "+
					" order by decode(t.mgr_ssn,'',0,1), t.est_id";	
			
		}else if(esti_table.equals("estimate_sh")){

			query = " select 'estimate_sh' as t_st, t.mgr_ssn as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate_sh t, esti_compare_sh p, esti_exam_sh x    "+
					" where   t.reg_code='"+reg_code+"' and t.mgr_nm='"+car_mng_id+"'"+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
					"         and t.fee_s_amt>0 "+
//					"         and t.a_b in ('12','24','36')"+
					" order by t.est_id";			
		}else{

			query = " select 'estimate' as t_st, t.job as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate t, esti_compare p, esti_exam x    "+
					" where   t.reg_code='"+reg_code+"' "+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
					" order by t.est_id";

		}

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
			System.out.println("[EstiDatabase:getEstiMateRegCodeList(String reg_code)]"+e);
			System.out.println("[EstiDatabase:getEstiMateRegCodeList(String reg_code)]"+query);
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
	 *	reg_code 견적리스트
	 */
	public Vector getEstiMateRegCodeCaseList(String reg_code, String esti_table, String car_mng_id, String est_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		if(esti_table.equals("estimate_hp")){

			query = " select 'estimate_hp' as t_st, t.est_nm as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate_hp t, esti_compare_hp p, esti_exam_hp x    "+
					" where   t.reg_code='"+reg_code+"' "+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
					"         and t.est_nm||t.mgr_ssn like '%"+est_nm+"%'"+
					" order by decode(t.mgr_ssn,'',0,1), t.est_id";	
			
		}else if(esti_table.equals("estimate_sh")){

			query = " select 'estimate_sh' as t_st, t.mgr_ssn as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate_sh t, esti_compare_sh p, esti_exam_sh x    "+
					" where   t.reg_code='"+reg_code+"' and t.mgr_nm='"+car_mng_id+"'"+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
					"         and t.fee_s_amt>0 "+
//					"         and t.a_b in ('12','24','36')"+
					" order by t.est_id";			
		}else{

			query = " select 'estimate' as t_st, t.job as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate t, esti_compare p, esti_exam x    "+
					" where   t.reg_code='"+reg_code+"' "+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
					" order by t.est_id";

		}

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
			System.out.println("[EstiDatabase:getEstiMateRegCodeCaseList(String reg_code)]"+e);
			System.out.println("[EstiDatabase:getEstiMateRegCodeCaseList(String reg_code)]"+query);
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
	 *	reg_code 견적리스트
	 */
	public Vector getEstiMateResultCaramtList(String esti_table, String est_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		if(esti_table.equals("estimate_hp")){

			query = " select 'estimate_hp' as t_st, t.est_nm as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate_hp t, esti_compare_hp p, esti_exam_hp x    "+
					" where   t.est_id='"+est_id+"' "+
					"         and t.est_id=p.est_id(+) and t.est_id=x.est_id(+) ";

			
		}else if(esti_table.equals("estimate_sh")){

			query = " select 'estimate_sh' as t_st, t.mgr_ssn as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate_sh t, esti_compare_sh p, esti_exam_sh x    "+
					" where   t.est_id='"+est_id+"' "+
					"         and t.est_id=p.est_id(+) and t.est_id=x.est_id(+) ";

		}else{

			query = " select 'estimate' as t_st, t.job as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate t, esti_compare p, esti_exam x    "+
					" where   t.est_id='"+est_id+"' "+
					"         and t.est_id=p.est_id(+) and t.est_id=x.est_id(+) ";


		}

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
			System.out.println("[EstiDatabase:getEstiMateResultCaramtList(String esti_table, String est_id)]"+e);
			System.out.println("[EstiDatabase:getEstiMateResultCaramtList(String esti_table, String est_id)]"+query);
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
	 *	reg_code 견적리스트
	 */
	public Vector getEstiMateRegCodeListRm(String reg_code, String esti_table, String car_mng_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


			
		if(esti_table.equals("estimate_sh")){

			query = " select 'estimate_sh' as t_st, t.mgr_ssn as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate_sh t, esti_compare_sh p, esti_exam_sh x    "+
					" where   t.reg_code='"+reg_code+"' and t.mgr_nm='"+car_mng_id+"' and t.mgr_ssn='rm1' "+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
					"         and t.fee_s_amt>0 "+
					" order by t.est_id";			
		}else{

			query = " select 'estimate' as t_st, t.job as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate t, esti_compare p, esti_exam x    "+
					" where   t.reg_code='"+reg_code+"' and t.mgr_ssn='rm1' "+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
					" order by t.est_id";

		}

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
			System.out.println("[EstiDatabase:getEstiMateRegCodeListRm(String reg_code, String esti_table, String car_mng_id)]"+e);
			System.out.println("[EstiDatabase:getEstiMateRegCodeListRm(String reg_code, String esti_table, String car_mng_id)]"+query);
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
	 *	영업사원 조회
	 */
	public Vector getEmpSubList(String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select emp_nm as est_nm, emp_ssn AS est_ssn, emp_m_tel as est_tel,  reg_dt, emp_email AS est_email \n"+
				" from   car_off_emp \n"+
				" where  emp_nm||emp_m_tel||emp_h_tel||emp_email like '%"+t_wd+"%' "+
				" order by emp_nm";


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
			System.out.println("[EstiDatabase:getEmpSubList]"+e);
			System.out.println("[EstiDatabase:getEmpSubList]"+query);
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
    public String call_sp_esti_reg_sh(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		CallableStatement cstmt2 = null;
		CallableStatement cstmt3 = null;
		CallableStatement cstmt4 = null;
		String sResult = "";

		Random random = new Random();

		String set_code = AddUtil.getDate(4)+""+car_mng_id+""+random.nextInt(100)+""+random.nextInt(100)+""+random.nextInt(100);
        
    	String query1 = "{CALL P_ESTI_REG_SH(?, ?, ?)}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);		
			cstmt.setString(1, car_mng_id);			
			cstmt.setString(2, set_code);			
			cstmt.setInt   (3, 20000);			
			cstmt.execute();
			cstmt.close();

			//주요차종 견적등록 프로시저 호출
			cstmt2 = con.prepareCall(query1);		
			cstmt2.setString(1, car_mng_id);			
			cstmt2.setString(2, set_code);			
			cstmt2.setInt   (3, 30000);			
			cstmt2.execute();
			cstmt2.close();

			//주요차종 견적등록 프로시저 호출
			cstmt3 = con.prepareCall(query1);		
			cstmt3.setString(1, car_mng_id);			
			cstmt3.setString(2, set_code);			
			cstmt3.setInt   (3, 40000);			
			cstmt3.execute();
			cstmt3.close();
			
			//주요차종 견적등록 프로시저 호출
			cstmt4 = con.prepareCall(query1);		
			cstmt4.setString(1, car_mng_id);			
			cstmt4.setString(2, set_code);			
			cstmt4.setInt   (3, 10000);			
			cstmt4.execute();
			cstmt4.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh] car_mng_id="+car_mng_id);
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh] set_code="+set_code);
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null)	cstmt.close();
				if(cstmt2 != null)	cstmt2.close();
				if(cstmt3 != null)	cstmt3.close();
				if(cstmt4 != null)	cstmt4.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }

	/**
     * 프로시져 호출
     */
    public String call_sp_esti_re_reg_sh(String reg_code, String jg_b_dt, String em_a_j, String ea_a_j) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		CallableStatement cstmt2 = null;
		CallableStatement cstmt3 = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_SH_CAR_AMT(?,?,?,?)}";
    	String query2 = "{CALL P_ESTI_SH_FEEAMT (?,?,?,?)}";
    	String query3 = "{CALL P_ESTI_SH_UPLOAD (?,?,?,?)}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);	
			cstmt.setString(1, reg_code);
			cstmt.setString(2, jg_b_dt);
			cstmt.setString(3, em_a_j);
			cstmt.setString(4, ea_a_j);
			cstmt.execute();
			cstmt.close();

			cstmt2 = con.prepareCall(query2);	
			cstmt2.setString(1, reg_code);
			cstmt2.setString(2, jg_b_dt);
			cstmt2.setString(3, em_a_j);
			cstmt2.setString(4, ea_a_j);
			cstmt2.execute();
			cstmt2.close();

			cstmt3 = con.prepareCall(query3);	
			cstmt3.setString(1, reg_code);
			cstmt3.setString(2, jg_b_dt);
			cstmt3.setString(3, em_a_j);
			cstmt3.setString(4, ea_a_j);
			cstmt3.execute();

			cstmt3.close();

			System.out.println("[EstiDatabase:call_sp_esti_re_reg_sh]"+reg_code);
        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_re_reg_sh]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null)	cstmt.close();
                if(cstmt2 != null)	cstmt2.close();
                if(cstmt3 != null)	cstmt3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }

	/**
     * 프로시져 호출
     */
    public String call_sp_esti_reg_sh_case(String reg_code, String jg_b_dt, String em_a_j, String ea_a_j) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		CallableStatement cstmt2 = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_SH_CAR_AMT(?,?,?,?)}";
    	String query2 = "{CALL P_ESTI_SH_FEEAMT (?,?,?,?)}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);	
			cstmt.setString(1, reg_code);
			cstmt.setString(2, jg_b_dt);
			cstmt.setString(3, em_a_j);
			cstmt.setString(4, ea_a_j);
			cstmt.execute();
			cstmt.close();

			cstmt2 = con.prepareCall(query2);	
			cstmt2.setString(1, reg_code);
			cstmt2.setString(2, jg_b_dt);
			cstmt2.setString(3, em_a_j);
			cstmt2.setString(4, ea_a_j);
			cstmt2.execute();
			cstmt2.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh_case]"+se);
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh_case]"+reg_code);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null)	cstmt.close();
                if(cstmt2 != null)	cstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }

    /**
     * 계약별 견적관리조회
     */
    public EstimateBean [] getEstimateContList(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				" decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun, a.reg_code"+
				" from estimate a, car_mng b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e"+
				" where a.rent_mng_id=? and a.rent_l_cd=? and a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				" and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+)"+
				" and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id and nvl(a.job,'org') in ('org','t')";

		query += " order by a.rent_st, a.est_id";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  	
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
		        bean.setRent_st(rs.getString("rent_st"));
				bean.setReg_code(rs.getString("reg_code"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag		(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));				
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));				

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateContList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
     * 계약별 견적관리조회
     */
    public EstimateBean [] getEstimateContList(String rent_mng_id, String rent_l_cd, String mode) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_nm, c.car_name, "+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun, a.reg_code, "+
				"        f.user_nm, substr(a.reg_dt,1,8) reg_dt2 "+
				" from   estimate a, car_mng b, car_nm c, users f "+
				" where  a.rent_mng_id=? and a.rent_l_cd=? and nvl(a.job,'org') in ('org','t') and nvl(a.use_yn,'Y')='Y' "+
			    "        and a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq "+
				"        and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id "+
				"        and decode(a.reg_id,a.rent_l_cd,a.est_tel,nvl(a.reg_id,a.update_id))=f.user_id(+) ";

		if(mode.equals("연장견적")) query += " and a.mgr_ssn='연장견적'";

		query += " order by a.rent_st, a.est_id";
		
        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  	
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
			    bean.setCtr_s_amt(rs.getInt("CTR_S_AMT"));
				bean.setCtr_v_amt(rs.getInt("CTR_V_AMT"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT2"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("user_nm"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setEst_gubun(rs.getString("est_gubun"));
		        bean.setRent_st(rs.getString("rent_st"));
				bean.setReg_code(rs.getString("reg_code"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				bean.setAgree_dist		(rs.getString("agree_dist")==null?0:Integer.parseInt(rs.getString("agree_dist")));
				

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateContList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }


	/**
	 *	일반대차 견
	 */

	public Vector getEstimateShResCarList(String gubun1, String gubun2, String gubun3, String gubun4, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.est_id, a.a_a, a.a_b, a.rent_dt, a.o_1, a.fee_s_amt, round(a.fee_s_amt/30,-3) day_s_amt, a.today_dist, (a.fee_s_amt+a.fee_v_amt) as fee_amt, \n"+
				"        b.car_no, b.car_nm, b.init_reg_dt, b.dpm, (a.today_dist-d.today_dist) last_mon_dist, e.avg_dist, "+
				"        round(a.today_dist/(to_date(a.rent_dt,'YYYYMMDD')-to_date(b.init_reg_dt,'YYYYMMDD'))*30) as AVERAGE_DIST"+
				" from   estimate_sh a, car_reg b, "+
				"        /*전월대비주행거리증감치*/"+
				"        (select est_nm, est_ssn, today_dist, to_char(add_months(to_date(est_tel,'YYYYMM'),1),'YYYYMM') est_dt  \n"+
				"         from   estimate_sh "+
				"         where  est_from ='res_car' and est_fax='Y') d, "+
				"        /*월평균주행거리*/"+
				"        (select est_nm, est_ssn, trunc(decode(count(0),1,0,(max(today_dist)-min(today_dist))/(count(0)-1)),0) avg_dist \n"+
                "         from   estimate_sh "+
				"         where  est_from ='res_car' and est_fax='Y' "+
				"         group by est_nm, est_ssn) e "+
				" where  a.est_from ='res_car' and a.est_fax='Y'"+
				"        and a.est_ssn=b.car_mng_id"+
				"        and a.est_nm=d.est_nm(+) and a.est_ssn=d.est_ssn(+) and a.est_tel=d.est_dt(+)"+
				"        and a.est_nm=e.est_nm(+) and a.est_ssn=e.est_ssn(+) "+
				" ";

		if(!s_dt.equals("") && e_dt.equals(""))			query += " and a.est_tel like '"+s_dt+"%'";
		else if(!s_dt.equals("") && !e_dt.equals(""))	query += " and a.est_tel='"+s_dt+""+e_dt+"'";


		if(!t_wd.equals("")){
			if(s_kd.equals("3"))		t_wd = AddUtil.replace(t_wd,"-","");

			if(s_kd.equals("1")) query += " and b.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("2")) query += " and b.car_nm like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and b.init_reg_dt like '"+t_wd+"%'";
		}

		query += " order by a.rent_dt, a.est_id";

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
			System.out.println("[EstiDatabase:getEstimateShResCarList]"+e);
			System.out.println("[EstiDatabase:getEstimateShResCarList]"+query);
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
    public String call_sp_esti_reg_sh_res3() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_REG_SH_RES3}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);		
			cstmt.execute();
			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh_res3]"+se);
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
     * 프로시져 호출
     */
    public String call_sp_esti_reg_res_sh(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_REG_RES_SH('', ?)}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);		
			cstmt.setString(1, car_mng_id);			
			cstmt.execute();
			cstmt.close();

			System.out.println("[EstiDatabase:call_sp_esti_reg_res_sh]"+car_mng_id);
        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_res_sh]"+se);
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
     * 프로시져 호출
     */
    public String call_sp_esti_reg_sh_amor() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_REG_SH_AMOR}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);		
			cstmt.execute();
			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh_amor]"+se);
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
     * 고객상담요청 등록.
     */
    public int insertEstiGst(EstiSpeBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

        query = " INSERT INTO ESTI_SPE"+
				" (est_id, est_st, est_nm, est_ssn, est_tel, est_agnt, est_bus, est_year, car_nm, etc, est_area, reg_dt, reg_id)"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   to_char(sysdate,'YYYYMMDDHH24MI'), ?)";
           
	   try{
		   con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);

            pstmt.setString(1, bean.getEst_id().trim());
            pstmt.setString(2, bean.getEst_st().trim());
            pstmt.setString(3, bean.getEst_nm().trim());
            pstmt.setString(4, bean.getEst_ssn().trim());
            pstmt.setString(5, bean.getEst_tel().trim());
            pstmt.setString(6, bean.getEst_agnt().trim());
            pstmt.setString(7, bean.getEst_bus().trim());
            pstmt.setString(8, bean.getEst_year().trim());
            pstmt.setString(9, bean.getCar_nm().trim());
            pstmt.setString(10, bean.getEtc().trim());
            pstmt.setString(11, bean.getEst_area().trim());
            pstmt.setString(12, bean.getReg_id().trim());

			count = pstmt.executeUpdate();
            
            pstmt.close();
			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstiSpe]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null) pstmt.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
     * 고객상담요청관리번호 생성
     */
    public String getNextEst_id_G(String est_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		String n_est_id = "";

		query = " SELECT to_char(sysdate,'YYMM')||'"+est_st+"'||nvl(ltrim(to_char(to_number(max(substr(est_id, 6, 10))+1), '00000')), '00001') ID"+
				" FROM ESTI_SPE "+
				" where est_id like to_char(sysdate,'YYMM')||'%' and est_id like '%"+est_st+"%'";
		   
       try{
           

            //est_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	n_est_id = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
       //     try{
			System.out.println("[EstiDatabase:getNextEst_id_S]"+se);
            throw new DatabaseException();
        //    }catch(SQLException _ignored){}
        //      throw new DatabaseException("exception");
        }finally{
            try{
           
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return n_est_id;
    }

/****************************************************************************************/
/****************************************************************************************/
 /**
 * 고객상담요청관리 전체조회
 */
    public EstiSpeBean [] getEstiGuestList(String gubun1, String gubun2, String gubun3, String gubun4, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.note as b_note, b.reg_dt as b_reg_dt, \n"+
				" t.user_id t_user_id, t.reg_dt t_reg_dt, t.note t_note, e.reg_dt as m_reg_dt, e.note as rent_yn, e.user_id as m_user_id, "+
				" decode(a.est_id,'S','스페셜견적','U','중고차리스', 'G','고객상담요청') est_gubun, d.user_id as s_user_id"+
				" from esti_spe a, "+
				"	   (select est_id, user_id, max(seq_no) seq_no from esti_m where nvl(gubun, 'A') in ( 'A' )  group by est_id, user_id) d, esti_m e,"+	
				"	   (select a.est_id, a.user_id, a.reg_dt, a.note  from esti_m a , ( select est_id, min(seq_no) seq_no from esti_m where nvl(gubun, 'A') in ( 'A', '0')  group by est_id ) b \n"+	
				"           where  a.est_id = b.est_id and a.seq_no = b.seq_no and nvl(a.gubun, 'A')  in ( 'A' , '0') ) t,  "+		
				"	   (select est_id, note, reg_dt from esti_m where  gubun in ( '1' , '2' ,'3') ) b "+
				" where "+
				" a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and a.est_id=b.est_id(+)  and a.est_id=t.est_id(+) and a.est_st = '3' ";

		if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " and a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		 
		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";

		if(esti_m.equals("1"))		query += " and e.user_id is not null ";
		else if(esti_m.equals("2"))	query += " and e.user_id is null ";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and a.car_nm like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("4")) query += " and e.user_id = '"+t_wd+"'";
		}

		query += " order by a.reg_dt desc";
		


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstiSpeBean bean = new EstiSpeBean();
				bean.setEst_id		(rs.getString("EST_ID"));
				bean.setEst_st		(rs.getString("EST_ST"));
	            bean.setEst_nm		(rs.getString("EST_NM"));
		        bean.setEst_ssn		(rs.getString("EST_SSN"));
			    bean.setEst_tel		(rs.getString("EST_TEL"));
			    bean.setEst_fax		(rs.getString("EST_FAX"));
				bean.setEst_agnt	(rs.getString("EST_AGNT"));
	            bean.setEst_bus		(rs.getString("EST_BUS"));
		        bean.setEst_year	(rs.getString("EST_YEAR"));
			    bean.setCar_nm		(rs.getString("CAR_NM"));
				bean.setEtc			(rs.getString("ETC"));
				bean.setReg_dt		(rs.getString("REG_DT"));
		        bean.setM_user_id	(rs.getString("m_user_id"));
		        bean.setM_reg_dt	(rs.getString("m_reg_dt"));
		        bean.setRent_yn		(rs.getString("RENT_YN"));
		        bean.setEst_area	(rs.getString("EST_AREA"));
		        bean.setEst_gubun	(rs.getString("EST_GUBUN"));
				bean.setCar_nm2		(rs.getString("CAR_NM2"));
				bean.setCar_nm3		(rs.getString("CAR_NM3"));
				bean.setReg_id		(rs.getString("REG_ID"));
				
				bean.setT_user_id	(rs.getString("t_user_id"));
		        bean.setT_reg_dt	(rs.getString("t_reg_dt"));
		        bean.setT_note		(rs.getString("t_note"));
		     
		        bean.setB_note		(rs.getString("b_note"));
		        bean.setB_reg_dt	(rs.getString("b_reg_dt"));
				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiGuestList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstiSpeBean[])col.toArray(new EstiSpeBean[0]);
    }


/**
     * 고객상담요청 대기건수
     */
    public int getGustEstiCnt() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		int cnt = 0;
		   
		query = " select count(0)"+
				" from esti_spe a, (select est_id, max(seq_no) seq_no from esti_m  where nvl(gubun, '0' ) not in ('X' ) group by est_id) d, esti_m e"+
				" where "+
				" a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and e.est_id is null and e.gubun is null and e.gubun is null and a.est_st ='3'";


	   try{
          

            //est_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	cnt = rs.getInt(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
			System.out.println("[EstiDatabase:getGustEstiCnt]"+se);
             throw new DatabaseException();
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return cnt;
    }


	/**
	 *	기존견적고객찾기
	 */
	public Vector getCustSubList(String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email, "+
				"        substr(a.reg_cont,1,8) reg_dt, substr(a.reg_cont,13) reg_id, "+
				"        substr(a.reg_cont2,1,8) reg_dt2, substr(a.reg_cont2,13) reg_id2, "+
				"        b.user_nm, "+
				"        b2.user_nm as user_nm2, "+
			    "        '1' doc_type, c.reg_dt as max_reg_dt, c.spr_yn as max_spr_yn \n"+
				" from   ( \n"+
				"         select replace(a.est_nm,' ','') est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email, max(a.est_id) est_id, "+
				"                max(a.reg_dt||a.reg_id) reg_cont, \n"+ 
				"                min(a.reg_dt||a.reg_id) reg_cont2 \n"+ 
				"         from   estimate a \n"+
				"         where  "+
			    "                substr(a.reg_dt,1,8) >= TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD') \n"+
				"                and nvl(a.est_tel,' ') not in ('계산값적용') \n"+
				"                and nvl(a.est_from,' ') not like 'lc_%' \n"+
				"                and nvl(a.est_from,' ') not like 'cmp%' \n"+
				"                and nvl(a.est_from,' ') <> 'main_car' and nvl(a.est_from,' ') not like 'off_ls%' \n"+
				"                and substr(a.est_nm,1,4) not in ('rs36','rb36','ls36','lb36') and nvl(a.use_yn,'Y')='Y' \n"+
		        "                and ( REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+t_wd+"%',' ',''),'(주)',''),'주식회사','') \n"+
				"                      OR REPLACE(REPLACE(a.est_ssn,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_tel,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_fax,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_email,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                    ) \n"+
				"         group by replace(a.est_nm,' ',''), a.est_ssn, a.est_tel, a.est_fax, a.est_email \n"+
				"        ) a, USERS b, USERS b2, estimate c "+
				" WHERE substr(a.reg_cont,13)=b.user_id(+) and substr(a.reg_cont2,13)=b2.user_id(+) and a.est_id=c.est_id(+) \n"+
				" order by a.est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email ";


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
			System.out.println("[EstiDatabase:getCustSubList]"+e);
			System.out.println("[EstiDatabase:getCustSubList]"+query);
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
	 *	기존견적고객찾기
	 */
	public Vector getCustSubJudgeList(String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email, "+
				"        substr(a.reg_cont,1,8) reg_dt, substr(a.reg_cont,13) reg_id, "+
				"        substr(a.reg_cont2,1,8) reg_dt2, substr(a.reg_cont2,13) reg_id2, "+
				"        b.user_nm, "+
				"        b2.user_nm as user_nm2, "+
			    "        '1' doc_type, c.reg_dt as max_reg_dt, c.spr_yn as max_spr_yn \n"+
				" from   ( \n"+
				"         select replace(a.est_nm,' ','') est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email, max(a.est_id) est_id, "+
				"                max(a.reg_dt||a.reg_id) reg_cont, \n"+ 
				"                min(a.reg_dt||a.reg_id) reg_cont2 \n"+ 
				"         from   estimate a \n"+
				"         where  "+
			    "                substr(a.reg_dt,1,8) >= TO_CHAR(ADD_MONTHS(SYSDATE,-6),'YYYYMMDD') \n"+
				"                and nvl(a.est_tel,' ') not in ('계산값적용') \n"+
				"                and nvl(a.est_from,' ') not like 'lc_%' \n"+
				"                and nvl(a.est_from,' ') not like 'cmp%' \n"+
				"                and nvl(a.est_from,' ') <> 'main_car' and nvl(a.est_from,' ') not like 'off_ls%' \n"+
				"                and substr(a.est_nm,1,4) not in ('rs36','rb36','ls36','lb36') and nvl(a.use_yn,'Y')='Y' \n"+
		        "                and ( REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+t_wd+"%',' ',''),'(주)',''),'주식회사','') \n"+
				"                      OR REPLACE(REPLACE(a.est_ssn,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_tel,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_fax,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_email,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                    ) \n"+
				"         group by replace(a.est_nm,' ',''), a.est_ssn, a.est_tel, a.est_fax, a.est_email \n"+
				"        ) a, USERS b, USERS b2, estimate c "+
				" WHERE substr(a.reg_cont,13)=b.user_id(+) and substr(a.reg_cont2,13)=b2.user_id(+) and a.est_id=c.est_id(+) \n"+
				" order by a.est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email ";


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
			System.out.println("[EstiDatabase:getCustSubJudgeList]"+e);
			System.out.println("[EstiDatabase:ggetCustSubJudgeList]"+query);
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
	 *	기존견적고객찾기
	 */
	public Vector getCustSubListOld(String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email, "+
				"        substr(a.reg_cont,1,8) reg_dt, substr(a.reg_cont,13) reg_id, "+
				"        substr(a.reg_cont2,1,8) reg_dt2, substr(a.reg_cont2,13) reg_id2, "+
				"        b.user_nm, "+
				"        b2.user_nm as user_nm2, "+
			    "        '1' doc_type \n"+
				" from   ( \n"+
				"         select replace(a.est_nm,' ','') est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email, "+
				"                max(a.reg_dt||a.reg_id) reg_cont, \n"+ 
				"                min(a.reg_dt||a.reg_id) reg_cont2 \n"+ 
				"         from   estimate a \n"+
				"         where   \n"+
		        "                ( REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+t_wd+"%',' ',''),'(주)',''),'주식회사','') \n"+
				"                      OR REPLACE(REPLACE(a.est_ssn,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_tel,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_fax,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_email,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                    ) \n"+
				"                and nvl(a.est_tel,' ') not in ('계산값적용') \n"+
				"                and nvl(a.est_from,' ') not like 'lc_%' \n"+
				"                and nvl(a.est_from,' ') not like 'cmp%' \n"+
				"                and nvl(a.est_from,' ') <> 'main_car' \n"+
				"                and substr(a.est_nm,1,4) not in ('rs36','rb36','ls36','lb36') and nvl(a.use_yn,'Y')='Y' \n"+
				"         group by replace(a.est_nm,' ',''), a.est_ssn, a.est_tel, a.est_fax, a.est_email \n"+
				"        ) a, USERS b, USERS b2 "+
				" WHERE substr(a.reg_cont,13)=b.user_id(+) and substr(a.reg_cont2,13)=b2.user_id(+)  \n"+
				" order by a.est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email ";


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
			System.out.println("[EstiDatabase:getCustSubListOld]"+e);
			System.out.println("[EstiDatabase:getCustSubListOld]"+query);
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
	 *	스폐셜견적고객찾기
	 */
	public Vector getSpeCustSubList(String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from \n"+
				" ( \n"+
				" select a.est_st, replace(a.est_nm,' ','') est_nm, a.est_ssn, a.est_tel, a.est_fax, decode(a.est_st,'1','1','2','3') doc_type, a.est_email, max(substr(a.reg_dt,1,8)) reg_dt \n"+
				" from   esti_spe a \n"+
				" where  "+
		        "                ( REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+t_wd+"%',' ',''),'(주)',''),'주식회사','') \n"+
				"                      OR REPLACE(REPLACE(a.est_ssn,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_tel,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_fax,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_email,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                    ) \n"+
				" group by a.est_st, replace(a.est_nm,' ',''), a.est_ssn, a.est_tel, a.est_fax, decode(a.est_st,'1','1','2','3'), a.est_email \n"+
				" ) \n"+
				" order by reg_dt";


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
			System.out.println("[EstiDatabase:getSpeCustSubList]"+e);
			System.out.println("[EstiDatabase:getSpeCustSubList]"+query);
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
	 *	기존견적고객조회
	 */
	public Vector getLcCustSubList(String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select client_id, firm_nm as est_nm, decode(client_nm,firm_nm,'',client_nm) client_nm, nvl(enp_no,TEXT_DECRYPT(ssn, 'pw' )) as est_ssn, o_tel as est_tel, fax as est_fax, reg_dt, decode(client_st,'1','1','2','3','2') doc_type, con_agnt_email AS est_email \n"+
				" from   client \n"+
				" where  "+
				"        ( REPLACE(REPLACE(REPLACE(firm_nm||client_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+t_wd+"%',' ',''),'(주)',''),'주식회사','') \n"+
				"          OR enp_no||TEXT_DECRYPT(ssn, 'pw' ) like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(o_tel||m_tel,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(fax,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(con_agnt_email,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				" ) "+
				" order by firm_nm";


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
			System.out.println("[EstiDatabase:getLcCustSubList]"+e);
			System.out.println("[EstiDatabase:getLcCustSubList]"+query);
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
	 *	다중견적 개별건조회
	 */
	public Vector getABTypeEstIds(String set_code, String est_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from estimate where set_code='"+set_code+"' and est_id<>'"+est_id+"' and job='org' and a_a IS NOT NULL order by est_id";


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
			System.out.println("[EstiDatabase:getABTypeEstIds]"+e);
			System.out.println("[EstiDatabase:getABTypeEstIds]"+query);
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
	 *	다중견적 개별건조회
	 */
	public Vector getABTypeEstIds2(String set_code, String est_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from estimate where set_code='"+set_code+"' and job='org' and a_a IS NOT NULL order by est_id";


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
			System.out.println("[EstiDatabase:getABTypeEstIds]"+e);
			System.out.println("[EstiDatabase:getABTypeEstIds]"+query);
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
	
	//전기차,수소차 견적한벌 가져오기(estimate_hp) 20190214
	public Vector getABTypeEstIds3(String est_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT * FROM ESTIMATE_HP WHERE EH_CODE IN (SELECT EH_CODE FROM ESTIMATE_HP WHERE EST_ID='"+est_id+"') ORDER BY RETURN_SELECT";


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
			System.out.println("[EstiDatabase:getABTypeEstIds3]"+e);
			System.out.println("[EstiDatabase:getABTypeEstIds3]"+query);
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
	
	//전기차 수소차 스마트견적관리 > 비교견적 기본식
	public Vector getABTypeEstIds4(String set_code, String est_id, String eh_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT * FROM estimate_cu WHERE eh_code = '"+ eh_code +"' AND job='org' ORDER BY return_select ";

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
			System.out.println("[EstiDatabase:getABTypeEstIds4]"+e);
			System.out.println("[EstiDatabase:getABTypeEstIds4]"+query);
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
	
	//전기차 수소차 스마트견적관리 > 비교견적 일반식
	public Vector getABTypeEstIds5(String set_code, String est_id, String eh_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT * FROM estimate_cu WHERE est_id = '"+ est_id +"' AND job='org' ORDER BY return_select ";

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
			System.out.println("[EstiDatabase:getABTypeEstIds5]"+e);
			System.out.println("[EstiDatabase:getABTypeEstIds5]"+query);
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
     * 견적서묶음 등록.
     */     
    public int insertEstiPack(EstiPackBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

        query = " INSERT INTO ESTI_PACK"+
				" (pack_id, seq, est_id, est_table, pack_st, reg_id, reg_dt, memo)"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, sysdate, ?)";
           
	   try{
		   con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);

            pstmt.setString(1,  bean.getPack_id		());
            pstmt.setInt   (2,  bean.getSeq			());
            pstmt.setString(3,  bean.getEst_id		());
            pstmt.setString(4,  bean.getEst_table	());
            pstmt.setString(5,  bean.getPack_st		());
            pstmt.setString(6,  bean.getReg_id		());
			pstmt.setString(7,  bean.getMemo		());
    
			count = pstmt.executeUpdate();
            
            pstmt.close();
			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstiPack]"+se);

				System.out.println("[bean.getPack_id	()]"+bean.getPack_id	());
				System.out.println("[bean.getSeq		()]"+bean.getSeq		());
				System.out.println("[bean.getEst_id		()]"+bean.getEst_id		());
				System.out.println("[bean.getEst_table	()]"+bean.getEst_table	());
				System.out.println("[bean.getPack_st	()]"+bean.getPack_st	());
				System.out.println("[bean.getReg_id		()]"+bean.getReg_id		());

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null) pstmt.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
	 *	변수기준일자
	 */
	public String getVar_b_dt(String var_st, String rent_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String b_dt = "";

		String query =  " SELECT max(reg_dt) b_dt FROM   esti_jg_var where reg_dt <= replace('"+rent_dt+"','-','') ";// and reg_dt <= to_char(sysdate,'YYYYMMDD')

		if(var_st.equals("em"))	query =  " SELECT max(a_j) b_dt FROM   esti_comm_var  where a_a='1' and a_j <= replace('"+rent_dt+"','-','') ";//and a_j <= to_char(sysdate,'YYYYMMDD') 
		if(var_st.equals("ea"))	query =  " SELECT max(a_j) b_dt FROM   esti_car_var   where a_a='1' and a_j <= replace('"+rent_dt+"','-','') group by a_a having count(0) >40 ";//and a_j <= to_char(sysdate,'YYYYMMDD')


		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 b_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getVar_b_dt]"+e);
			System.out.println("[EstiDatabase:getVar_b_dt]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return b_dt;
	}
	
	/**
	 *	변수기준일자 - 최근일자
	 */
	public String getVar_b_dt_Chk(String var_st, String a_a, String rent_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String b_dt = "";

		String query =  " SELECT max(reg_dt) b_dt FROM   esti_jg_var";

		if(var_st.equals("em"))	query =  " SELECT max(a_j) b_dt FROM   esti_comm_var  where a_a='"+a_a+"' "; 
		if(var_st.equals("ea"))	query =  " SELECT max(a_j) b_dt FROM   esti_car_var   where a_a='"+a_a+"' ";


		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 b_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getVar_b_dt_Chk]"+e);
			System.out.println("[EstiDatabase:getVar_b_dt_Chk]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return b_dt;
	}	

	/**
	 *	변수기준일자
	 */
	public String getVar_b_dt(String sh_code, String var_st, String rent_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String b_dt = "";

		String query =  " SELECT max(reg_dt) b_dt FROM   esti_jg_var where reg_dt <= replace('"+rent_dt+"','-','') ";

		if(var_st.equals("jg"))	query += " and sh_code='"+sh_code+"'";
		if(var_st.equals("em"))	query =  " SELECT max(a_j) b_dt FROM   esti_comm_var  where a_a='1' and a_j <= replace('"+rent_dt+"','-','') ";
		if(var_st.equals("ea"))	query =  " SELECT max(a_j) b_dt FROM   esti_car_var   where a_a='1' and a_j <= replace('"+rent_dt+"','-','') group by a_a having count(0) >40 ";
		if(var_st.equals("dc"))	query =  " SELECT max(car_d_dt) b_dt FROM car_dc where car_comp_id||car_cd='"+sh_code+"' and car_d_dt like substr(replace('"+rent_dt+"','-',''),1,6)||'%' and car_d_dt <= replace('"+rent_dt+"','-','') and replace(car_d,' ','') like '%판매자정상조건%' ";


		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 b_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getVar_b_dt]"+e);
			System.out.println("[EstiDatabase:getVar_b_dt]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return b_dt;
	}

	/**
	 *	변수기준일자
	 */
	public String getDc_b_dt(String sh_code, String var_st, String rent_dt, String car_b_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String b_dt = "";

		String query =  " SELECT max(car_d_dt) b_dt FROM car_dc where car_comp_id||car_cd='"+sh_code+"' and car_b_dt='"+car_b_dt+"' and car_d_dt like substr(replace('"+rent_dt+"','-',''),1,6)||'%' and car_d_dt <= replace('"+rent_dt+"','-','') and replace(car_d,' ','') like '%판매자정상조건%' ";


		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 b_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getDc_b_dt]"+e);
			System.out.println("[EstiDatabase:getDc_b_dt]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return b_dt;
	}

	/**
	 *	변수 일련번호
	 */
	public String getVar_seq(String var_st, String rent_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String seq = "";

		String query =  " SELECT max(seq) seq FROM   esti_jg_var where reg_dt <= replace('"+rent_dt+"','-','') ";

		if(var_st.equals("em"))	query =  " SELECT max(seq) seq FROM   esti_comm_var  where a_a='1' and a_j <= replace('"+rent_dt+"','-','') ";
		if(var_st.equals("ea"))	query =  " SELECT max(seq) seq FROM   esti_car_var   where a_a='1' and a_j <= replace('"+rent_dt+"','-','') group by a_a having count(0) >40 ";


		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getVar_seq]"+e);
			System.out.println("[EstiDatabase:getVar_seq]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return seq;
	}

    /**
     * 스페셜견적관리 전체조회
     */
    public EstimateBean [] getEstiSpeCarList(String est_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select b.car_no as est_nm, c.nm as est_ssn, e.car_nm, d.car_name, a.* \n"+
				" from   esti_spe_car a, car_reg b, \n"+
				"        (select * from code where c_st='0001' and code<>'0000') c, \n"+
				"        car_nm d, car_mng e \n"+
				" where  est_id='"+est_id+"'  \n"+
				"        and a.car_mng_id=b.car_mng_id(+) \n"+
				"        and a.car_comp_id=c.code(+) \n"+
				"        and a.car_id=d.car_id(+) and a.car_seq=d.car_seq(+) \n"+
				"        and a.car_comp_id=e.car_comp_id(+) and a.car_cd=e.code(+) \n"+
				" ";

		query += " order by seq";

        
        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_nm		(rs.getString("EST_NM"));
				bean.setEst_ssn		(rs.getString("EST_SSN"));
				bean.setCar_nm		(rs.getString("CAR_NM"));
				bean.setCar_name	(rs.getString("CAR_NAME"));
				bean.setEst_id		(rs.getString("EST_ID"));
	            bean.setSeq			(rs.getInt("SEQ"));
	            bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_id		(rs.getString("CAR_ID"));
				bean.setCar_seq		(rs.getString("CAR_SEQ"));
	            bean.setCar_amt		(rs.getInt("CAR_AMT"));
		        bean.setOpt			(rs.getString("OPT"));
			    bean.setOpt_seq		(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt		(rs.getInt("OPT_AMT"));
		        bean.setCol			(rs.getString("COL"));
			    bean.setCol_seq		(rs.getString("COL_SEQ"));
				bean.setCol_amt		(rs.getInt("COL_AMT"));
	            bean.setO_1			(rs.getInt("O_1"));
		        bean.setA_a			(rs.getString("A_A"));
			    bean.setA_b			(rs.getString("A_B"));
	            bean.setCar_mng_id	(rs.getString("CAR_MNG_ID"));		     
		        bean.setIn_col		(rs.getString("IN_COL"));
				bean.setAgree_dist	(rs.getInt("AGREE_DIST"));
				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiSpeCarList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateSpeCarCase(String est_id, String seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select a.est_id, a.est_nm, a.est_ssn, a.est_tel, a.est_fax, \n"+
				"        b.seq, b.car_comp_id, b.car_cd, b.car_id, b.car_seq, b.car_amt, \n"+
				"        b.opt, b.opt_seq, b.opt_amt, b.col, b.col_seq, b.col_amt, b.o_1, \n"+
				"        b.a_a, b.a_b, b.car_mng_id, a.est_email, "+
				"        case when a.est_st in ('1','PS1','PJ1','PM1','B','MSB','MJB','MMB') then '1' "+
				"             when a.est_st in ('2','PS2','PJ2','PM2','PS3','PJ3','PM3','P','MSP','MJP','MMP') then '3' "+
				"        else '3' end doc_type, "+
				"        a.EST_AGNT AS mgr_nm, \n"+
				"        b.agree_dist, b.in_col, b.jg_opt_st, b.jg_col_st, nvl(c.reg_code,'') reg_code, b.garnish_col  "+
				" from   esti_spe a, esti_spe_car b, sh_res c \n"+
				" where  a.est_id='"+est_id+"' and a.est_id=b.est_id(+) and a.est_id=c.est_id(+)  ";

		if(!seq.equals("")) query += " and b.seq='"+seq+"'";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id		(rs.getString("EST_ID"));
	            bean.setEst_nm		(rs.getString("EST_NM"));
		        bean.setEst_ssn		(rs.getString("EST_SSN"));
			    bean.setEst_tel		(rs.getString("EST_TEL"));
				bean.setEst_fax		(rs.getString("EST_FAX"));
	            bean.setCar_comp_id	(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd		(rs.getString("CAR_CD"));
			    bean.setCar_id		(rs.getString("CAR_ID"));
				bean.setCar_seq		(rs.getString("CAR_SEQ"));
	            bean.setCar_amt		(rs.getInt("CAR_AMT"));
		        bean.setOpt			(rs.getString("OPT"));
			    bean.setOpt_seq		(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt		(rs.getInt("OPT_AMT"));
		        bean.setCol			(rs.getString("COL"));
			    bean.setCol_seq		(rs.getString("COL_SEQ"));
				bean.setCol_amt		(rs.getInt("COL_AMT"));
	            bean.setO_1			(rs.getInt("O_1"));
		        bean.setA_a			(rs.getString("A_A"));
			    bean.setA_b			(rs.getString("A_B"));
				bean.setCar_mng_id	(rs.getString("CAR_MNG_ID"));
				bean.setEst_email	(rs.getString("EST_EMAIL"));
				bean.setDoc_type	(rs.getString("DOC_TYPE"));
				bean.setMgr_nm		(rs.getString("MGR_NM"));
				bean.setAgree_dist	(rs.getInt("AGREE_DIST"));
				bean.setIn_col		(rs.getString("IN_COL")==null?"":rs.getString("IN_COL"));
				bean.setGarnish_col		(rs.getString("GARNISH_COL")==null?"":rs.getString("GARNISH_COL"));
				bean.setJg_opt_st	(rs.getString("JG_OPT_ST")==null?"":rs.getString("JG_OPT_ST"));
				bean.setJg_col_st	(rs.getString("JG_COL_ST")==null?"":rs.getString("JG_COL_ST"));
				bean.setReg_code	(rs.getString("REG_CODE")==null?"":rs.getString("REG_CODE"));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateSpeCarCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 차종별잔가변수 조회-세부내용
     */
    public EstiJgVarBean getEstiJgVarDtCase(String sh_code, String reg_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiJgVarBean bean = new EstiJgVarBean();
        String query = "";
        
        query = " select * from esti_jg_var where sh_code='"+sh_code+"'";

		if(reg_dt.equals("")){
			query += " and seq = (select max(seq) from esti_jg_var where sh_code='"+sh_code+"')";
		}else{
			query += " and reg_dt='"+reg_dt+"'";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            if(rs.next()){
				bean.setSh_code	(rs.getString(1));
			    bean.setSeq		(rs.getString(2));
			    bean.setCom_nm	(rs.getString(3));
			    bean.setCars 	(rs.getString(4));
			    bean.setJg_1 	(rs.getFloat (5));
			    bean.setJg_2 	(rs.getString(6));
				bean.setJg_3 	(rs.getFloat (7));
			    bean.setJg_4 	(rs.getFloat (8));
			    bean.setJg_5 	(rs.getFloat (9));
			    bean.setJg_6 	(rs.getFloat (10));
			    bean.setJg_7 	(rs.getInt   (11));
			    bean.setJg_8 	(rs.getFloat (12));
				bean.setJg_9 	(rs.getFloat (13));
			    bean.setJg_10 	(rs.getFloat (14));
			    bean.setJg_11 	(rs.getFloat (15));
			    bean.setJg_12 	(rs.getFloat (16));
				bean.setJg_13 	(rs.getString(17));
			    bean.setJg_a 	(rs.getString(18));
			    bean.setJg_b 	(rs.getString(19));
			    bean.setJg_c 	(rs.getInt   (20));
			    bean.setJg_d1 	(rs.getInt   (21));
			    bean.setJg_d2 	(rs.getInt   (22));
				bean.setJg_e 	(rs.getString(23));
			    bean.setJg_f 	(rs.getFloat (24));
			    bean.setJg_g 	(rs.getFloat (25));
			    bean.setJg_h 	(rs.getString(26));
			    bean.setJg_i 	(rs.getString(27));
			    bean.setJg_j1 	(rs.getFloat(28));
				bean.setJg_j2 	(rs.getFloat(29));
			    bean.setJg_j3 	(rs.getFloat(30));
			    bean.setReg_dt 	(rs.getString(31));
				bean.setNew_yn 	(rs.getString(32));
			    bean.setJg_d3 	(rs.getInt   (33));
			    bean.setApp_dt 	(rs.getString(36));
			    bean.setJg_k 	(rs.getString(35));
			    bean.setJg_l 	(rs.getFloat (34));
			    bean.setJg_e1 	(rs.getInt   (37));
			    bean.setJg_st1 	(rs.getFloat (38));
			    bean.setJg_st2 	(rs.getFloat (39));
			    bean.setJg_st3 	(rs.getFloat (40));
			    bean.setJg_st4 	(rs.getFloat (41));
			    bean.setJg_st5 	(rs.getFloat (42));
			    bean.setJg_st6 	(rs.getFloat (43));
			    bean.setJg_st7 	(rs.getFloat (44));
			    bean.setJg_st8 	(rs.getFloat (45));
			    bean.setJg_e_d 	(rs.getFloat (46));
			    bean.setJg_e_e 	(rs.getFloat (47));
			    bean.setJg_e_g 	(rs.getInt   (48));
			    bean.setJg_st9 	(rs.getFloat (49));
				bean.setJg_q 	(rs.getString(50));
			    bean.setJg_st10 (rs.getFloat (51));
				bean.setJg_r 	(rs.getString(52));
				bean.setJg_s 	(rs.getString(53));
				bean.setJg_t 	(rs.getString(54));
			    bean.setJg_u 	(rs.getFloat (55));
			    bean.setJg_14 	(rs.getFloat (56));
				bean.setJg_3_1 	(rs.getFloat (57));
			    bean.setJg_st11 (rs.getFloat (58));
			    bean.setJg_st12 (rs.getFloat (59));
			    bean.setJg_st13 (rs.getFloat (60));
			    bean.setJg_st14 (rs.getFloat (61));
				bean.setJg_5_1 	(rs.getFloat (62));
				bean.setJg_v 	(rs.getString(63));
				bean.setJg_st15 (rs.getFloat (64));
				bean.setJg_w 	(rs.getString(65));
				bean.setJg_x	(rs.getFloat (66));
				bean.setJg_y	(rs.getFloat (67));
				bean.setJg_z	(rs.getFloat (68));
			    bean.setJg_d4 	(rs.getInt   (69));
			    bean.setJg_d5 	(rs.getInt   (70));
				bean.setJg_g_1	(rs.getFloat (71));
				bean.setJg_g_2	(rs.getFloat (72));
				bean.setJg_g_3	(rs.getFloat (73));
				bean.setJg_15 	(rs.getFloat (74));
				bean.setJg_g_4	(rs.getFloat (75));
				bean.setJg_g_5	(rs.getFloat (76));
				bean.setJg_st16 (rs.getFloat (77));
				bean.setJg_g_6	(rs.getFloat (78));
				bean.setJg_st17 (rs.getFloat (79));
				bean.setJg_st18 (rs.getFloat (80));
				bean.setJg_st19 (rs.getFloat (81));
				bean.setJg_g_7 	(rs.getString(82));
				bean.setJg_g_8 	(rs.getString(83));
				bean.setJg_g_9 	(rs.getString(84));
				bean.setJg_g_10 (rs.getFloat (85));
				bean.setJg_g_11 (rs.getFloat (86));
				bean.setJg_g_12 (rs.getFloat (87));
				bean.setJg_g_13 (rs.getFloat (88));
			    bean.setJg_d6 	(rs.getInt   (89));
			    bean.setJg_d7 	(rs.getInt   (90));
				bean.setJg_d8 	(rs.getInt   (91));
				bean.setJg_d9 	(rs.getInt   (92));
				bean.setJg_d10 	(rs.getInt   (93));
				bean.setJg_g_14 (rs.getFloat (94));
				bean.setJg_g_15	(rs.getInt   (95));
				bean.setJg_g_16 (rs.getString(96));
				bean.setJg_g_17	(rs.getInt   (97));
				bean.setJg_g_18	(rs.getString(98));		//jg_g_18 ~jg_g_33 추가(20180528)
				bean.setJg_g_19	(rs.getInt   (99));
				bean.setJg_g_20	(rs.getInt   (100));
				bean.setJg_g_21	(rs.getString(101));
				bean.setJg_g_22	(rs.getInt   (102));
				bean.setJg_g_23	(rs.getInt   (103));
				bean.setJg_g_24	(rs.getInt   (104));
				bean.setJg_g_25	(rs.getFloat (105));
				bean.setJg_g_26	(rs.getString(106));
				bean.setJg_g_27	(rs.getInt   (107));
				bean.setJg_g_28	(rs.getInt   (108));
				bean.setJg_g_29	(rs.getInt   (109));
				bean.setJg_g_30	(rs.getFloat (110));
				bean.setJg_g_31	(rs.getFloat (111));
				bean.setJg_g_32	(rs.getFloat (112));
				bean.setJg_g_33	(rs.getFloat (113));
			    bean.setJg_st20 (rs.getFloat (114));
			    bean.setJg_st21 (rs.getFloat (115));
			    bean.setJg_g_34	(rs.getInt   (116));
				bean.setJg_g_35	(rs.getInt   (117));
				bean.setJg_g_36	(rs.getString(118));
				bean.setJg_st22 (rs.getFloat (119));
				bean.setJg_st23 (rs.getFloat (120));
				bean.setJg_g_38(rs.getInt(121));
				bean.setJg_g_39(rs.getInt(122));
				bean.setJg_g_40(rs.getInt(123));
				bean.setJg_g_41(rs.getInt(124));
				bean.setJg_g_42(rs.getInt(125));
				bean.setJg_g_43(rs.getInt(126));
				bean.setJg_g_44(rs.getInt(127));
				bean.setJg_g_45(rs.getFloat(128));
				bean.setJg_g_46(rs.getInt(129));

			}
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiJgVarCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun, "+
				"        decode(f.a_g,'','견적중지','견적') est_check "+
				" from estimate a, car_mng b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e, esti_exam f "+
				" where a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				" and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+)"+
				" and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id and nvl(a.job,'org')='org' "+
				" and a.est_id=f.est_id ";


		if(gubun1.equals("1")) query += " and a.est_type='F' and nvl(a.job,'org')='org' and nvl(a.use_yn,'Y')='Y' ";
		if(gubun1.equals("2")) query += " and a.est_type='W' and nvl(a.use_yn,'Y')='Y'";
		if(gubun1.equals("3")) query += " and a.talk_tel is not null and nvl(a.use_yn,'Y')='Y'";	
		if(gubun1.equals("4")) query += " and a.est_type='M' and nvl(a.use_yn,'Y')='Y'";		
		if(gubun1.equals("5")) query += " and a.est_type='J' and nvl(a.use_yn,'Y')='Y'";		
		if(gubun1.equals("6")) query += " and a.est_type='L' and nvl(a.job,'org')='org' and nvl(a.use_yn,'Y')='Y'";		
		if(gubun1.equals("7")) query += " and a.est_type='F' and nvl(a.job,'org')='org' and nvl(a.use_yn,'Y')='N' ";

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
		

		if(gubun4.equals(""))  query += " and a.reg_dt >= TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD') ";
		if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("3")) query += " and a.reg_dt >= TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD') and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
		if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5")) query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";

		if(!gubun5.equals("")) query += " and a.reg_id = '"+gubun5+"'";
		if(!gubun6.equals("")) query += " and e.user_id = '"+gubun6+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm||a.mgr_nm like '%"+t_wd+"%'";
			if(s_kd.equals("5")) query += " and a.est_id = '"+t_wd+"'";
			if(s_kd.equals("6")) query += " and replace(a.est_ssn,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("7")) query += " and replace(a.est_tel||a.est_fax,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
			if(s_kd.equals("9")) query += " and a.damdang_nm||a.damdang_m_tel like '%"+t_wd+"%'";
		}

		if(esti_m.equals("1")) query += " and e.user_id is not null ";
		else if(esti_m.equals("2"))	query += " and e.user_id is null ";


		if(esti_m_dt.equals("1"))		query += " and e.reg_dt like to_char(sysdate,'YYYYMM')||'%' ";
		else if(esti_m_dt.equals("2"))	query += " and e.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' ";
		else if(esti_m_dt.equals("3"))	query += " and e.reg_dt between replace('"+esti_m_s_dt+"','-','') and replace('"+esti_m_e_dt+"','-','') ";

		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
				bean.setSet_code(rs.getString("set_code"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setEst_check(rs.getString("est_check"));
				bean.setPrint_type(rs.getString("print_type"));
			    bean.setCtr_s_amt(rs.getString("CTR_S_AMT")==null?0:Integer.parseInt(rs.getString("CTR_S_AMT")));
				bean.setCtr_v_amt(rs.getString("CTR_V_AMT")==null?0:Integer.parseInt(rs.getString("CTR_V_AMT")));
				bean.setUse_yn(rs.getString("use_yn"));
				bean.setMgr_nm(rs.getString("mgr_nm"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setDamdang_nm		(rs.getString("damdang_nm")==null?"":rs.getString("damdang_nm"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateList]"+se);
			System.out.println("[EstiDatabase:getEstimateList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }
    
    /**
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateList2(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun, "+
				"        decode(f.a_g,'','견적중지','견적') est_check "+
				" from estimate a, car_mng b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e, esti_exam f "+
				" where a.rent_dt < TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD') and a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				" and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+)"+
				" and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id and nvl(a.job,'org')='org' "+
				" and a.est_id=f.est_id ";

		if(gubun1.equals("1")) query += " and a.est_type='F' and nvl(a.job,'org')='org' and nvl(a.use_yn,'Y')='Y' ";

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
		

		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";

		if(!gubun5.equals("")) query += " and a.reg_id = '"+gubun5+"'";
		if(!gubun6.equals("")) query += " and e.user_id = '"+gubun6+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm||a.mgr_nm like '%"+t_wd+"%'";
			if(s_kd.equals("5")) query += " and a.est_id = '"+t_wd+"'";
			if(s_kd.equals("6")) query += " and replace(a.est_ssn,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("7")) query += " and replace(a.est_tel||a.est_fax,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
		}

		query += " order by a.est_id desc";
		

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
				bean.setSet_code(rs.getString("set_code"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setEst_check(rs.getString("est_check"));
				bean.setPrint_type(rs.getString("print_type"));
			    bean.setCtr_s_amt(rs.getString("CTR_S_AMT")==null?0:Integer.parseInt(rs.getString("CTR_S_AMT")));
				bean.setCtr_v_amt(rs.getString("CTR_V_AMT")==null?0:Integer.parseInt(rs.getString("CTR_V_AMT")));
				bean.setUse_yn(rs.getString("use_yn"));
				bean.setMgr_nm(rs.getString("mgr_nm"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setDamdang_nm		(rs.getString("damdang_nm")==null?"":rs.getString("damdang_nm"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateList2]"+se);
			System.out.println("[EstiDatabase:getEstimateList2]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }    

    /**
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateShList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_no, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','연장계약','S','재리스차량') est_gubun, "+
				"        decode(a.fee_s_amt,'0','견적중지','견적') est_check "+
				" from estimate a, car_reg b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e, esti_exam f"+
				" where a.mgr_nm=b.car_mng_id and a.car_id=c.car_id and a.car_seq=c.car_seq "+
				" and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and nvl(a.est_from,'car')<>'rm_car'"+
				" and a.est_id=f.est_id(+) "+
				" ";


		if(gubun1.equals("7")) query += " and a.est_type='S' and nvl(a.use_yn,'Y')='Y'";		
		if(gubun1.equals("8")) query += " and a.est_type='L' and a.rent_st>'1' and nvl(a.use_yn,'Y')='Y'";		
		if(gubun1.equals("9")) query += " and a.est_type='S' and nvl(a.use_yn,'Y')='N'";		

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
		

		if(gubun4.equals("1")) query += " and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " and a.rent_dt=to_char(sysdate,'YYYYMMDD')";
		if(gubun4.equals("3")) query += " and a.rent_dt >= TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD') and a.rent_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
		if(gubun4.equals("4")) query += " and a.rent_dt=to_char(sysdate-1,'YYYYMMDD')";
		if(gubun4.equals("5")) query += " and a.rent_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		
		if(!gubun5.equals("")) query += " and a.reg_id = '"+gubun5+"'";
		if(!gubun6.equals("")) query += " and e.user_id = '"+gubun6+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_no||b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("5")) query += " and a.est_id = '"+t_wd+"'";
			if(s_kd.equals("6")) query += " and replace(a.est_ssn,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("7")) query += " and replace(a.est_tel||a.est_fax,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
		}

		if(esti_m.equals("1"))		query += " and e.user_id is not null ";
		else if(esti_m.equals("2"))	query += " and e.user_id is null ";


		if(esti_m_dt.equals("1"))		query += " and e.reg_dt like to_char(sysdate,'YYYYMM')||'%' ";
		else if(esti_m_dt.equals("2"))	query += " and e.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' ";
		else if(esti_m_dt.equals("3"))	query += " and e.reg_dt between replace('"+esti_m_s_dt+"','-','') and replace('"+esti_m_e_dt+"','-','') ";

		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
		        bean.setMgr_nm(rs.getString("CAR_NO"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setEst_check(rs.getString("EST_CHECK"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateShList]"+se);
			System.out.println("[EstiDatabase:getEstimateShList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
     * 월렌트 견적관리 전체조회
     */
    public EstimateBean [] getEstimateRmList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_no, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				" decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','연장계약','S','월렌트차량') est_gubun"+
				" from estimate a, car_reg b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e"+//
				" where a.est_from = 'rm_car' and a.mgr_nm=b.car_mng_id and nvl(a.use_yn,'Y')='Y'"+
				" and a.car_id=c.car_id and a.car_seq=c.car_seq "+
				" and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+)"+
				" ";

		if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%' ";
		if(gubun4.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
		if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5")) query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		

		if(!gubun5.equals("")) query += " and a.reg_id = '"+gubun5+"'";
		if(!gubun6.equals("")) query += " and e.user_id = '"+gubun6+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("2")) query += " and b.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("5")) query += " and a.est_id = '"+t_wd+"'";
			if(s_kd.equals("6")) query += " and replace(a.est_ssn,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("7")) query += " and replace(a.est_tel||a.est_fax,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
		}

		if(esti_m.equals("1"))		query += " and e.user_id is not null ";
		else if(esti_m.equals("2"))	query += " and e.user_id is null ";


		if(esti_m_dt.equals("1"))		query += " and e.reg_dt like to_char(sysdate,'YYYYMM')||'%' ";
		else if(esti_m_dt.equals("2"))	query += " and e.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' ";
		else if(esti_m_dt.equals("3"))	query += " and e.reg_dt between replace('"+esti_m_s_dt+"','-','') and replace('"+esti_m_e_dt+"','-','') ";

		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
		        bean.setMgr_nm(rs.getString("CAR_NO"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateRmList]"+se);
			System.out.println("[EstiDatabase:getEstimateRmList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
	 *	월렌트 견적관리 전체조회
	 */
	public Vector getEstimateRmCarList(String table_st, String car_mng_id, String days) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_dt, a.est_id, a.o_1, a.ro_13, a.fee_s_amt, a.fee_v_amt, (a.fee_s_amt+a.fee_v_amt) fee_amt, a.today_dist, \n"+   
				"        b.o_b, b.o_d, b.o_e, b.o_f, b.o_g, b.o_r, b.o_s, b.o_u, b.o_v, b.o_w, b.o_x, b.o_y \n"+   
				" FROM   ESTIMATE_"+table_st+" a, ESTI_EXAM_"+table_st+" b  \n"+   
				" WHERE  a.rent_dt > to_char(sysdate-"+days+",'YYYYMMDD') and a.mgr_nm='"+car_mng_id+"' AND a.mgr_ssn='rm1' "+   
				"        AND a.est_id=b.est_id \n"+   
				" ORDER BY 1 ";

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
			System.out.println("[EstiDatabase:getEstimateRmCarList(String table_st, String car_mng_id)]"+e);
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
	 *	월렌트 견적관리 전체조회
	 */
	public Vector getEstimateRmCarContList(String car_mng_id, String st_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "SELECT '출고지연' st, est_id, rent_dt, rent_l_cd, today_dist, agree_dist, o_1, gtr_amt, (pp_s_amt+pp_v_amt) pp_amt, (ifee_s_amt+ifee_v_amt) ifee_amt, car_ja, fee_s_amt, fee_v_amt, (fee_s_amt+fee_v_amt) fee_amt, nvl(tae_rent_fee_cls,0) tae_rent_fee_cls \r\n" + 
				"FROM estimate WHERE mgr_nm='"+car_mng_id+"' AND est_from='tae_car' "+
				"     AND rent_dt BETWEEN to_char(to_date('"+st_dt+"','YYYYMMDD')-20,'YYYYMMDD') and to_char(to_date('"+st_dt+"','YYYYMMDD')+10,'YYYYMMDD')\r\n" + 
				"UNION all         \r\n" + 
				"SELECT '월렌트' st, est_id, rent_dt, rent_l_cd, today_dist, agree_dist, o_1, gtr_amt, (pp_s_amt+pp_v_amt) pp_amt, (ifee_s_amt+ifee_v_amt) ifee_amt, car_ja, fee_s_amt, fee_v_amt, (fee_s_amt+fee_v_amt) fee_amt, 0 tae_rent_fee_cls \r\n" + 
				"FROM estimate_sh WHERE mgr_nm='"+car_mng_id+"' AND mgr_ssn='rm1' "+
				"     AND rent_dt BETWEEN to_char(to_date('"+st_dt+"','YYYYMMDD')-20,'YYYYMMDD') and to_char(to_date('"+st_dt+"','YYYYMMDD')+10,'YYYYMMDD')\r\n" + 
				"ORDER BY 2";

		
		
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
			System.out.println("[EstiDatabase:getEstimateRmCarContList(String table_st, String car_mng_id)]"+e);
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
     * 월렌트견적서
     */     
    public int insertEstiRm(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

        query = " INSERT INTO ESTI_RM"+
				" (est_id, months, days, tot_rm, tot_rm1, per, navi_yn)"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?)";
           
	   try{
		   con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);

            pstmt.setString(1,  bean.getEst_id		());
            pstmt.setString(2,  bean.getMonths		());
            pstmt.setString(3,  bean.getDays		());
            pstmt.setString(4,  bean.getTot_rm		());
            pstmt.setString(5,  bean.getTot_rm1		());
            pstmt.setString(6,  bean.getPer			());
            pstmt.setString(7,  bean.getNavi_yn		());
    
			count = pstmt.executeUpdate();
            
            pstmt.close();
			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstiRm]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null) pstmt.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstiRmCase(String est_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from esti_rm where est_id='"+est_id+"'";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id		(rs.getString("EST_ID"));
	            bean.setMonths		(rs.getString("MONTHS"));
		        bean.setDays		(rs.getString("DAYS"));
			    bean.setTot_rm		(rs.getString("TOT_RM"));
				bean.setTot_rm1		(rs.getString("TOT_RM1"));
		        bean.setPer			(rs.getString("PER"));
			    bean.setNavi_yn		(rs.getString("NAVI_YN")==null?"":rs.getString("NAVI_YN"));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiRmCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
	 *	견적 아마존카 기존거래업체 여부 (본인거 제외)
	 */
	public Vector getEstimateCustRentCheck(String est_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_dt, b.firm_nm, a.bus_id, a.bus_id2, a.mng_id, "+
				"        c.user_nm as bus_nm,  c.user_m_tel as bus_m_tel,  c.user_pos as bus_pos, "+
				"        d.user_nm as bus_nm2, d.user_m_tel as bus_m_tel2, d.user_pos as bus_pos2 \n"+
				" FROM   CONT a, CLIENT b, USERS c, USERS d \n"+
				" WHERE  NVL(a.use_yn,'Y')='Y' AND a.car_st<>'2' and a.rent_l_cd not like 'RM%' \n"+
				"        AND a.client_id=b.client_id \n"+
				"        AND REPLACE(REPLACE(REPLACE(b.firm_nm,' ',''),'(주)',''),'주식회사','') = REPLACE(REPLACE(REPLACE('"+est_nm+"',' ',''),'(주)',''),'주식회사','') \n"+
				"        AND a.BUS_ID=c.user_id \n"+
				"        AND a.bus_id2=d.user_id \n"+
				" ORDER BY a.rent_dt desc, a.rent_mng_id desc ";

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
			System.out.println("[EstiDatabase:getEstimateCustRentCheck]"+e);
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
	 *	견적 아마존카 기존거래업체 여부 (본인거 제외)
	 */
	public Vector getEstimateCustRentCheck(String est_nm, String est_ssn, String est_tel) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_dt, b.firm_nm, a.bus_id, a.bus_id2, a.mng_id, "+
				"        c.user_nm as bus_nm,  c.user_m_tel as bus_m_tel,  c.user_pos as bus_pos, "+
				"        d.user_nm as bus_nm2, d.user_m_tel as bus_m_tel2, d.user_pos as bus_pos2 \n"+
				" FROM   CONT a, CLIENT b, USERS c, USERS d \n"+
				" WHERE  NVL(a.use_yn,'Y')='Y' AND a.car_st<>'2' and a.rent_l_cd not like 'RM%' \n"+
				"        AND a.client_id=b.client_id \n"+
				"        AND ( REPLACE(REPLACE(REPLACE(b.firm_nm,' ',''),'(주)',''),'주식회사','') = REPLACE(REPLACE(REPLACE('"+est_nm+"',' ',''),'(주)',''),'주식회사','') \n"+
			    " ";

		if(!est_ssn.equals(""))	query +=" OR b.enp_no||b.ssn like REPLACE(REPLACE('%"+est_ssn+"%',' ',''),'-','') ";
		if(!est_tel.equals(""))	query +=" OR REPLACE(REPLACE(b.o_tel||b.m_tel,' ',''),'-','') like REPLACE(REPLACE('%"+est_tel+"%',' ',''),'-','') ";

		query +=" ) ";

		query +="        AND a.BUS_ID=c.user_id \n"+
				"        AND a.bus_id2=d.user_id \n"+
			    " ";

		query +=" ORDER BY a.rent_dt desc, a.rent_mng_id desc ";

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
			System.out.println("[EstiDatabase:getEstimateCustRentCheck(String est_nm, String est_ssn, String est_tel)]"+e);
			System.out.println("[EstiDatabase:getEstimateCustRentCheck(String est_nm, String est_ssn, String est_tel)]"+query);
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
	 *	견적 아마존카 기존거래업체 여부 (본인거 제외)
	 */
	public Vector getEstimateCustRentCheck(String est_nm, String est_ssn, String est_tel, String est_fax, String est_email) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT  "+
					" 	a.rent_dt, b.firm_nm, b.client_nm, a.bus_id, a.bus_id2, a.mng_id, "+
					"   c.user_nm as bus_nm, c.user_m_tel as bus_m_tel, c.user_pos as bus_pos, "+
					"   d.user_nm as bus_nm2, d.user_m_tel as bus_m_tel2, d.user_pos as bus_pos2 \n"+
					" FROM \n"+
					" 	CONT a, CLIENT b, USERS c, USERS d \n"+
					" WHERE \n"+
					" 	NVL(a.use_yn,'Y')='Y' AND a.car_st<>'2' and a.rent_l_cd not like 'RM%' \n"+
					"   AND a.client_id=b.client_id \n"+
					"   AND \n"+
					"   ( \n ";
		
		query += "		REPLACE(REPLACE(REPLACE(b.firm_nm||b.client_nm, ' ', ''), '(주)', ''), '주식회사', '') like REPLACE(REPLACE(REPLACE('%"+est_nm+"%', ' ', ''), '(주)', ''), '주식회사', '') \n";

		if (!est_ssn.equals("")) {
			query += " OR b.enp_no||b.ssn like REPLACE(REPLACE('%"+est_ssn+"%', ' ', ''), '-', '') ";
		}
		if (!est_tel.equals("")) {
			//query += " OR REPLACE(REPLACE(b.o_tel||b.m_tel, ' ', ''), '-', '') = REPLACE(REPLACE('"+est_tel+"', ' ', ''), '-', '') ";
			query += " AND " +
						  " ( " +
							  " REPLACE(REPLACE(b.o_tel, ' ', ''), '-', '') LIKE REPLACE(REPLACE('%"+est_tel+"%', ' ', ''), '-', '') " +
							  " OR " +
							  " REPLACE(REPLACE(b.m_tel, ' ', ''), '-', '') LIKE REPLACE(REPLACE('%"+est_tel+"%', ' ', ''), '-', '') " +
						  " ) ";
		}
		if (!est_fax.equals("")) {
			query += " OR REPLACE(REPLACE(b.fax, ' ', ''), '-', '') = REPLACE(REPLACE('"+est_fax+"', ' ', ''), '-', '') ";
		}
		if (!est_email.equals("")) {
			query += " OR REPLACE(REPLACE(b.con_agnt_email, ' ', ''), '-', '') = REPLACE(REPLACE('"+est_email+"', ' ', ''), '-', '') ";
		}

		query += "	) ";

		query += " AND a.bus_id=c.user_id \n"+
					  " AND a.bus_id2=d.user_id \n"+
					  " ORDER BY a.rent_dt desc, a.rent_mng_id desc ";
		
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
			System.out.println("[EstiDatabase:getEstimateCustRentCheck(String est_nm, String est_ssn, String est_tel)]"+e);
			System.out.println("[EstiDatabase:getEstimateCustRentCheck(String est_nm, String est_ssn, String est_tel)]"+query);
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
	 *	견적 최근30일이내 견적여부 (본인거 제외)
	 */
	public Vector getEstimateCustEstCheck(String gubun1, String est_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_dt, a.est_nm, a.reg_id, b.user_nm, b.user_m_tel, b.user_pos \n"+
				" FROM   ESTIMATE a, USERS b \n"+
				" WHERE  a.rent_dt >= TO_CHAR(sysdate-30,'YYYYMMDD') and a.fee_s_amt >0 \n"+
				"        AND a.reg_id=b.user_id  and nvl(a.use_yn,'Y')='Y' \n"+
		        "        AND  REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') = REPLACE(REPLACE(REPLACE('"+est_nm+"',' ',''),'(주)',''),'주식회사','') \n"+
				"        ";

		if(gubun1.equals("1")) query += " and a.est_type='F' and nvl(a.job,'org')='org' ";
		if(gubun1.equals("2")) query += " and a.est_type='W'";
		if(gubun1.equals("3")) query += " and a.talk_tel is not null";	
		if(gubun1.equals("4")) query += " and a.est_type='M'";		
		if(gubun1.equals("5")) query += " and a.est_type='J'";		
		if(gubun1.equals("6")) query += " and a.est_type='L' and nvl(a.job,'org')='org'";		

		//재리스
		if(gubun1.equals("7")) query += " and a.est_type='S' and nvl(a.est_from,'car')<>'rm_car'";		

		query += " ORDER BY a.rent_dt desc, a.reg_dt desc, a.reg_code desc ";

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
			System.out.println("[EstiDatabase:getEstimateCustEstCheck]"+e);
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
	 *	견적 최근30일이내 견적여부 (본인거 제외)
	 */
	public Vector getEstimateCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_dt, a.est_nm, a.reg_id, b.user_nm, b.user_m_tel, b.user_pos \n"+
				" FROM   ESTIMATE a, USERS b \n"+
				" WHERE  a.rent_dt >= TO_CHAR(sysdate-30,'YYYYMMDD') and a.fee_s_amt >0 \n"+
				"        AND a.reg_id=b.user_id  and nvl(a.use_yn,'Y')='Y' \n"+
		        "        and ( REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') = REPLACE(REPLACE(REPLACE('"+est_nm+"',' ',''),'(주)',''),'주식회사','') \n"+
			    " ";

		if(!est_ssn.equals(""))	query +=" OR REPLACE(REPLACE(a.est_ssn,' ',''),'-','') like REPLACE(REPLACE('%"+est_ssn+"%',' ',''),'-','') ";
		if(!est_tel.equals(""))	query +=" OR REPLACE(REPLACE(a.est_tel,' ',''),'-','') like REPLACE(REPLACE('%"+est_tel+"%',' ',''),'-','') ";

		query +=" ) ";


		if(gubun1.equals("1")) query += " and a.est_type='F' and nvl(a.job,'org')='org' ";
		if(gubun1.equals("2")) query += " and a.est_type='W'";
		if(gubun1.equals("3")) query += " and a.talk_tel is not null";	
		if(gubun1.equals("4")) query += " and a.est_type='M'";		
		if(gubun1.equals("5")) query += " and a.est_type='J'";		
		if(gubun1.equals("6")) query += " and a.est_type='L' and nvl(a.job,'org')='org'";		

		//재리스
		if(gubun1.equals("7")) query += " and a.est_type='S' and nvl(a.est_from,'car')<>'rm_car'";		

		query += " ORDER BY a.rent_dt desc, a.reg_dt desc, a.reg_code desc ";

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
			System.out.println("[EstiDatabase:getEstimateCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel)]"+e);
			System.out.println("[EstiDatabase:getEstimateCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel)]"+query);
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
	 *	견적 최근30일이내 견적여부 (본인거 제외)
	 */
	public Vector getEstimateCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel, String est_fax, String est_email) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	//	query = " SELECT a.rent_dt, a.est_nm, a.reg_id, b.user_nm, b.user_m_tel, b.user_pos \n"+
		query = " SELECT a.rent_dt, a.est_nm, a.reg_id, b.user_nm, b.user_m_tel, b.user_pos, a.reg_dt \n"+
				" FROM   ESTIMATE a, USERS b \n"+
				" WHERE  a.rent_dt >= TO_CHAR(sysdate-30,'YYYYMMDD') and a.fee_s_amt >0 \n"+
				"        AND a.reg_id=b.user_id  and nvl(a.use_yn,'Y')='Y' \n"+
		        "        and ( REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') = REPLACE(REPLACE(REPLACE('"+est_nm+"',' ',''),'(주)',''),'주식회사','') \n"+
			    " ";

		if(!est_ssn.equals(""))		query +=" OR REPLACE(REPLACE(a.est_ssn,' ',''),'-','') = REPLACE(REPLACE('"+est_ssn+"',' ',''),'-','') ";
		if(!est_tel.equals(""))		query +=" OR REPLACE(REPLACE(a.est_tel,' ',''),'-','') = REPLACE(REPLACE('"+est_tel+"',' ',''),'-','') ";
		if(!est_fax.equals(""))		query +=" OR REPLACE(REPLACE(a.est_fax,' ',''),'-','') = REPLACE(REPLACE('"+est_fax+"',' ',''),'-','') ";
		if(!est_email.equals(""))	query +=" OR REPLACE(REPLACE(a.est_email,' ',''),'-','') = REPLACE(REPLACE('"+est_email+"',' ',''),'-','') ";

		query +=" ) ";

		if(gubun1.equals("1")) query += " and a.est_type='F' and nvl(a.job,'org')='org' ";
		if(gubun1.equals("2")) query += " and a.est_type='W'";
		if(gubun1.equals("3")) query += " and a.talk_tel is not null";	
		if(gubun1.equals("4")) query += " and a.est_type='M'";		
		if(gubun1.equals("5")) query += " and a.est_type='J'";		
		if(gubun1.equals("6")) query += " and a.est_type='L' and nvl(a.job,'org')='org'";		

		//재리스
		if(gubun1.equals("7")) query += " and a.est_type='S' and nvl(a.est_from,'car')<>'rm_car'";		

		query += " ORDER BY a.rent_dt desc, a.reg_dt desc, a.reg_code desc ";

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
			System.out.println("[EstiDatabase:getEstimateCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel)]"+e);
			System.out.println("[EstiDatabase:getEstimateCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel)]"+query);
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
	 *	스마트견적 최근7일이내 견적여부 (본인거 제외)
	 */
	public Vector getEstimateSpeCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel, String est_fax, String est_email) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		query = " select SUBSTR(a.reg_dt,1,8) rent_dt, a.est_nm, f.user_id as reg_id, f.user_nm, f.user_m_tel, f.user_pos \n"+
				" from   esti_spe a, (SELECT est_id, max(car_mng_id) car_mng_id FROM ESTI_SPE_CAR GROUP BY est_id) b, \n"+
				"	     ( select a.est_id, a.user_id, a.reg_dt, a.note \n"+
                "          from   esti_m a , ( select est_id, min(seq_no) seq_no from esti_m group by est_id ) b \n"+
			    "	       where  a.est_id = b.est_id and a.seq_no = b.seq_no \n"+
                "        ) t, \n"+
                "        users f \n"+
                " WHERE  SUBSTR(a.reg_dt,1,8) >= TO_CHAR(sysdate-7,'YYYYMMDD') \n"+
                "        AND a.est_id=b.est_id(+) \n"+
             	"	     and a.est_id=t.est_id(+) and t.user_id=f.user_id(+) \n"+
		        "        and ( REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') = REPLACE(REPLACE(REPLACE('"+est_nm+"',' ',''),'(주)',''),'주식회사','') \n"+
			    " ";

		if(!est_ssn.equals(""))		query +=" OR REPLACE(REPLACE(a.est_ssn,' ',''),'-','') = REPLACE(REPLACE('"+est_ssn+"',' ',''),'-','') ";
		if(!est_tel.equals(""))		query +=" OR REPLACE(REPLACE(a.est_tel,' ',''),'-','') = REPLACE(REPLACE('"+est_tel+"',' ',''),'-','') ";
		if(!est_fax.equals(""))		query +=" OR REPLACE(REPLACE(a.est_fax,' ',''),'-','') = REPLACE(REPLACE('"+est_fax+"',' ',''),'-','') ";
		if(!est_email.equals(""))	query +=" OR REPLACE(REPLACE(a.est_email,' ',''),'-','') = REPLACE(REPLACE('"+est_email+"',' ',''),'-','') ";

		query +=" ) ";

		//신차
	//	if(gubun1.equals("1")) query += " and b.car_mng_id is null and a.etc not like '%월렌트%' ";
		if(gubun1.equals("1")) query += " and b.car_mng_id is null and (a.etc is null or a.etc not like '%월렌트%') ";

		//재리스
	//	if(gubun1.equals("7")) query += " and b.car_mng_id is not null and a.etc not like '%월렌트%' ";
		if(gubun1.equals("7")) query += " and b.car_mng_id is not null and (a.etc is null or a.etc not like '%월렌트%') ";

		query += " ORDER BY a.reg_dt desc ";

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
			System.out.println("[EstiDatabase:getEstimateSpeCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel)]"+e);
			System.out.println("[EstiDatabase:getEstimateSpeCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel)]"+query);
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
     * 견적관리 전체조회 - 신차
     */
    public EstimateBean [] getEstimateFmsList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.reg_dt b_dt, a.*, b.car_nm, c.car_name, "+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun, "+
				"        decode(f.a_g,'','견적중지','견적') est_check, e.user_nm as reg_nm "+
				" from   estimate a, car_mng b, car_nm c, esti_exam f, users e "+
				" where  ";

		if(gubun4.equals(""))  query += " a.rent_dt >= TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD')";
		if(gubun4.equals("1")) query += " a.rent_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " a.rent_dt=to_char(sysdate,'YYYYMMDD')";
		if(gubun4.equals("3")) query += " a.rent_dt >= TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD') and a.rent_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
		if(gubun4.equals("4")) query += " a.rent_dt=to_char(sysdate-1,'YYYYMMDD')";
		if(gubun4.equals("5")) query += " a.rent_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";

		query += "       and a.est_type='F' and a.job='org' "+
				"        and a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				"        and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id "+
				"        and a.est_id=f.est_id and a.reg_id=e.user_id ";


		if(gubun1.equals("1")) query += " and nvl(a.use_yn,'Y')='Y' ";
		if(gubun1.equals("7")) query += " and nvl(a.use_yn,'Y')='N' ";

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";

		if(!gubun5.equals("")) query += " and e.user_nm = '"+gubun5+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm||a.mgr_nm like '%"+t_wd+"%'";
			if(s_kd.equals("5")) query += " and a.est_id = '"+t_wd+"'";
			if(s_kd.equals("6")) query += " and replace(a.est_ssn,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("7")) query += " and replace(a.est_tel||a.est_fax,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
			if(s_kd.equals("9")) query += " and a.damdang_nm like '%"+t_wd+"%'";
		}

		//query += " AND a.A_A IS NOT null ";
		query += " order by 1 desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setEst_gubun(rs.getString("est_gubun"));
				bean.setSet_code(rs.getString("set_code"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setEst_check(rs.getString("est_check"));
				bean.setPrint_type(rs.getString("print_type"));
			    bean.setCtr_s_amt(rs.getString("CTR_S_AMT")==null?0:Integer.parseInt(rs.getString("CTR_S_AMT")));
				bean.setCtr_v_amt(rs.getString("CTR_V_AMT")==null?0:Integer.parseInt(rs.getString("CTR_V_AMT")));
				bean.setUse_yn(rs.getString("use_yn"));
				bean.setMgr_nm(rs.getString("mgr_nm"));
		        bean.setReg_nm(rs.getString("reg_nm"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setDamdang_nm		(rs.getString("damdang_nm")==null?"":rs.getString("damdang_nm"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));


				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateFmsList]"+se);
			System.out.println("[EstiDatabase:getEstimateFmsList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateFmsList2(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        

		query = " select a.*, b.car_nm, c.car_name, "+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun, "+
				"        decode(f.a_g,'','견적중지','견적') est_check, e.user_nm as reg_nm "+
				" from   estimate a, car_mng b, car_nm c, esti_exam f, users e "+
				" where  a.rent_dt < TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD') and a.est_type='F' and nvl(a.job,'org')='org' "+
				"        and a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				"        and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id "+
				"        and a.est_id=f.est_id and a.reg_id=e.user_id ";


		if(gubun1.equals("1")) query += " and nvl(a.use_yn,'Y')='Y' ";
		if(gubun1.equals("7")) query += " and nvl(a.use_yn,'Y')='N' ";

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
		

		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";

		if(!gubun5.equals("")) query += " and e.user_nm = '"+gubun5+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm||a.mgr_nm like '%"+t_wd+"%'";
			if(s_kd.equals("5")) query += " and a.est_id = '"+t_wd+"'";
			if(s_kd.equals("6")) query += " and replace(a.est_ssn,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("7")) query += " and replace(a.est_tel||a.est_fax,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
		}

		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setEst_gubun(rs.getString("est_gubun"));
				bean.setSet_code(rs.getString("set_code"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setEst_check(rs.getString("est_check"));
				bean.setPrint_type(rs.getString("print_type"));
			    bean.setCtr_s_amt(rs.getString("CTR_S_AMT")==null?0:Integer.parseInt(rs.getString("CTR_S_AMT")));
				bean.setCtr_v_amt(rs.getString("CTR_V_AMT")==null?0:Integer.parseInt(rs.getString("CTR_V_AMT")));
				bean.setUse_yn(rs.getString("use_yn"));
				bean.setMgr_nm(rs.getString("mgr_nm"));
				bean.setReg_nm(rs.getString("reg_nm"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));


				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateFmsList2]"+se);
			System.out.println("[EstiDatabase:getEstimateFmsList2]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateFmsShList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_no, b.car_nm, c.car_name, "+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','연장계약','S','재리스차량') est_gubun, "+
				"        decode(a.fee_s_amt,'0','견적중지','견적') est_check, e.user_nm as reg_nm "+
				" from   estimate a, car_reg b, car_nm c, users e "+
				" where  ";

		if(gubun4.equals("1")) query += " a.rent_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " a.rent_dt=to_char(sysdate,'YYYYMMDD')";
		if(gubun4.equals("3")) query += " a.rent_dt >= TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD') and a.rent_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
		if(gubun4.equals("4")) query += " a.rent_dt=to_char(sysdate-1,'YYYYMMDD')";
		if(gubun4.equals("5")) query += " a.rent_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";

		
		query += "        and a.est_type = 'S' and nvl(a.est_from,'car')<>'rm_car' "+
				"         and a.mgr_nm=b.car_mng_id and a.car_id=c.car_id and a.car_seq=c.car_seq "+
				"         and a.reg_id=e.user_id  "+
				" ";

		if(gubun1.equals("7")) query += " and nvl(a.use_yn,'Y')='Y'";		
		if(gubun1.equals("9")) query += " and nvl(a.use_yn,'Y')='N'";		

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
		

		if(!gubun5.equals("")) query += " and e.user_nm = '"+gubun5+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("2")) query += " and b.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("5")) query += " and a.est_id = '"+t_wd+"'";
			if(s_kd.equals("6")) query += " and replace(a.est_ssn,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("7")) query += " and replace(a.est_tel||a.est_fax,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
		}


		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setEst_gubun(rs.getString("est_gubun"));
		        bean.setMgr_nm(rs.getString("CAR_NO"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setEst_check(rs.getString("EST_CHECK"));
				bean.setReg_nm(rs.getString("reg_nm"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateFmsShList]"+se);
			System.out.println("[EstiDatabase:getEstimateFmsShList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateFmsShList2(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_no, b.car_nm, c.car_name, "+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','연장계약','S','재리스차량') est_gubun, "+
				"        decode(a.fee_s_amt,'0','견적중지','견적') est_check, e.user_nm as reg_nm "+
				" from   estimate a, car_reg b, car_nm c, users e "+
				" where  a.rent_dt < TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD') ";

		if(gubun4.equals("3")) query += " and a.rent_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";


		query += "        and a.est_type in ('L','S') and nvl(a.est_from,'car')<>'rm_car' "+
				"         and a.mgr_nm=b.car_mng_id and a.car_id=c.car_id and a.car_seq=c.car_seq "+
				"         and a.reg_id=e.user_id  "+
				" ";

		if(gubun1.equals("7")) query += " and nvl(a.use_yn,'Y')='Y'";		
		if(gubun1.equals("9")) query += " and nvl(a.use_yn,'Y')='N'";		

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
		

		if(!gubun5.equals("")) query += " and e.user_nm = '"+gubun5+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("2")) query += " and b.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("5")) query += " and a.est_id = '"+t_wd+"'";
			if(s_kd.equals("6")) query += " and replace(a.est_ssn,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("7")) query += " and replace(a.est_tel||a.est_fax,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
		}


		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setEst_gubun(rs.getString("est_gubun"));
		        bean.setMgr_nm(rs.getString("CAR_NO"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setEst_check(rs.getString("EST_CHECK"));
				bean.setReg_nm(rs.getString("reg_nm"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateFmsShList2]"+se);
			System.out.println("[EstiDatabase:getEstimateFmsShList2]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

	/**
     * 월렌트견적 대기건수
     */

    public int getMrentEstiCnt() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		int cnt = 0;
		   
		query = " select count(0)"+
				" from esti_spe a, (select est_id, max(seq_no) seq_no from esti_m where nvl(gubun, 'O') not in ('X' ) group by est_id) d, esti_m e"+
				" where "+
				" a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and e.est_id is null and e.gubun is null and a.est_st in ('N','M','PM1','PM2','MMB','MMP')  ";


       try{
          

            //est_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	cnt = rs.getInt(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
			System.out.println("[EstiDatabase:getMrentEstiCnt]"+se);
			System.out.println("[EstiDatabase:getMrentEstiCnt]"+query);
             throw new DatabaseException();
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return cnt;
    }


    /**
     * 모바일 월렌트견적 대기건수
     */

    public int getMobileMrentEstiCnt() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        int cnt = 0;
           
        query = " select count(0)"+
                " from esti_spe a, (select est_id, max(seq_no) seq_no from esti_m where nvl(gubun, 'O') not in ('X' ) group by est_id) d, esti_m e"+
                " where "+
                " a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and e.est_id is null and e.gubun is null and a.est_st in ('N','M','MMB','MMP')  ";


       try{
          

            //est_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
                cnt = rs.getInt(1);
            rs.close();
            stmt.close();

        }catch(SQLException se){
            System.out.println("[EstiDatabase:getMrentEstiCnt]"+se);
            System.out.println("[EstiDatabase:getMrentEstiCnt]"+query);
             throw new DatabaseException();
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            con = null;
        }
        return cnt;
    }

    
    /**
     * PC월렌트차량예약 대기건수(담당자 미지정)
     */

    public int getPCMrentEstiCnt() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        int cnt = 0;
           
        query = " select count(0)"+
                " from sh_res "+
                " where "+
                " est_id is not null and damdang_id is null and use_yn='Y' ";


       try{
          

            //est_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
                cnt = rs.getInt(1);
            rs.close();
            stmt.close();

        }catch(SQLException se){
            System.out.println("[EstiDatabase:getMrentEstiCnt]"+se);
            System.out.println("[EstiDatabase:getMrentEstiCnt]"+query);
             throw new DatabaseException();
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            con = null;
        }
        return cnt;
    }

    
    
	/**
     * 프로시져 호출
     */
    public String call_sp_esti_reg_sh_res(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_REG_SH_RES(?, ?)}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);		
			cstmt.setString(1, "");			
			cstmt.setString(2, car_mng_id);			
			cstmt.execute();
			cstmt.close();

			System.out.println("[EstiDatabase:call_sp_esti_reg_sh_res]"+car_mng_id);
        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh_res]"+se);
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
     * 견적관리 수정.
     */
    public int updateEstimateBus(EstimateBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE ESTIMATE SET"+
				"  bus_yn=?, bus_cau=?, "+
				"  bus_cau_dt= decode(bus_cau_dt,'',sysdate,bus_cau_dt) "+
				" WHERE est_id=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  

			pstmt.setString(1, bean.getBus_yn().trim());
			pstmt.setString(2, bean.getBus_cau().trim());
            pstmt.setString(3, bean.getEst_id().trim());

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateEstimateBus]"+se);
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

/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/

	/**
	 *	재리스차량정보
	 */
	public Hashtable getBase(String car_mng_id, String rent_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		if(rent_dt.trim().equals("null"))					rent_dt = "to_char(sysdate,'YYYYMMDD')";
		if(AddUtil.replace(rent_dt," ","").equals("null"))	rent_dt = "to_char(sysdate,'YYYYMMDD')";
		if(!rent_dt.equals("to_char(sysdate,'YYYYMMDD')"))	rent_dt = "'"+rent_dt+"'";

		String query =  " select "+
						"        b.rent_mng_id, b.rent_l_cd, b.dlv_dt, a.car_mng_id, a.car_no, 'XXX'||substr(a.car_no,-4) car_no_x, "+
						"        to_char(to_date("+rent_dt+",'yyyymmdd')-365,'yyyymmdd') before_one_year, a.init_reg_dt, a.secondhand_dt, a.fuel_kd, a.park, c.lpg_yn, c.lpg_price, "+
						"        d.car_comp_id, d.code, e.car_id, e.car_seq, d.car_nm||' '||e.car_name CAR_NAME, "+
						"        c.car_cs_amt+c.car_cv_amt CAR_AMT, c.opt, c.opt_cs_amt+c.opt_cv_amt OPT_AMT, c.colo, c.clr_cs_amt+c.clr_cv_amt CLR_AMT, "+
						"        nvl(c.tax_dc_s_amt,0)-nvl(c.tax_dc_v_amt,0) tax_dc_amt, "+
						"        (c.car_cs_amt+c.car_cv_amt+c.opt_cs_amt+c.opt_cv_amt+c.clr_cs_amt+c.clr_cv_amt-nvl(c.tax_dc_s_amt,0)-nvl(c.tax_dc_v_amt,0)) o_1, "+
						"        vt.tot_dist, vt.tot_dt as serv_dt, "+
						"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date("+rent_dt+",'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,"+
						"        e.jg_code, e.s_st, e.sh_code, a.car_use, a.car_ext"+
						" from car_reg a, cont b, car_etc c, car_mng d, car_nm e, "+
						"      (select distinct a.car_mng_id, a.tot_dt, a.tot_dist "+
						"		from   v_dist a, (select car_mng_id, max(tot_dt||tot_dist) tot from v_dist where tot_dt<="+rent_dt+" group by car_mng_id) b "+
						"       where  a.car_mng_id=b.car_mng_id "+
						"              and a.tot_dt<="+rent_dt+" "+
						"              and a.tot_dt||a.tot_dist=b.tot)  vt, "+//v_tot_dist vt
						"      (select a.car_mng_id CAR_MNG_ID, a.serv_dt SERV_DT, a.tot_dist TOT_DIST  from service a where a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where car_mng_id = a.car_mng_id)) i, "+
						"      (select car_mng_id, max(rent_mng_id||rent_l_cd) max_rent from cont where car_st<>'4' group by car_mng_id) b2  "+
						" where a.car_mng_id='"+car_mng_id+"' "+
						"        and a.car_mng_id = b.car_mng_id "+
						"        and b.rent_mng_id = c.rent_mng_id "+
						"        and b.rent_l_cd = c.rent_l_cd "+
						"        and c.car_id = e.car_id and c.car_seq = e.car_seq "+
						"        and d.car_comp_id = e.car_comp_id and d.code = e.car_cd "+
						"        and a.car_mng_id = vt.car_mng_id(+) "+
						"        and a.car_mng_id = i.car_mng_id(+) "+
						"        and b.car_mng_id = b2.car_mng_id and b.rent_mng_id||b.rent_l_cd=b2.max_rent"+
						" ";

		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiDatabase:getBase]"+e);
			System.out.println("[EstiDatabase:getBase]"+query);
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
     * 견적관리 전체조회
     */
    public EstimateBean [] getNewCarEstimateList(String user_id, String s_yy, String s_mm, String s_dd, String gubun4, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		String search_dt = "";

        
		query = " select a.*, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun, f.user_nm, "+
				"        decode(g.a_g,'','견적중지','견적') est_check "+
				" from   estimate a, car_mng b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e, users f, esti_exam g  "+//
				" where  a.est_type='F' and a.reg_id=decode('"+user_id+"','',a.reg_id,'"+user_id+"') and job ='org'"+
				"        and a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				"        and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+)"+
				"        and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id"+
				"        and a.reg_id=f.user_id(+)"	+
				"        and a.est_id=g.est_id ";

		search_dt = "a.reg_dt";

		if(gubun4.equals("")){
			if(!s_yy.equals("") && !s_mm.equals(""))	query += " and "+search_dt+" like '%"+s_yy+s_mm+s_dd+"%'";
			if(!s_yy.equals("") && s_mm.equals(""))		query += " and "+search_dt+" like '%"+s_yy+"%'";
		}else{
			if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun4.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
			if(gubun4.equals("5")) query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		}

		if(!t_wd.equals("")){
			query += " and a.est_nm like '%"+t_wd+"%'";
		}

		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("USER_NM"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
				bean.setEst_check(rs.getString("est_check"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getNewCarEstimateList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

	 /**
     * 재리스 견적관리 전체조회
     */
    public EstimateBean [] getShCarEstimateList(String user_id, String s_yy, String s_mm, String s_dd, String gubun4, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		String search_dt = "";

        
		query = " select a.*, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun, f.user_nm"+
				" from   estimate a, car_mng b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e, users f "+//
				" where  a.est_type='S' and a.reg_id=decode('"+user_id+"','',a.reg_id,'"+user_id+"') "+//and job ='org'
				"        and a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				"        and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+)"+
				"        and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id"+
				"        and a.reg_id=f.user_id(+)"	;

		search_dt = "a.reg_dt";

		if(gubun4.equals("")){
			if(!s_yy.equals("") && !s_mm.equals(""))	query += " and "+search_dt+" like '%"+s_yy+s_mm+s_dd+"%'";
			if(!s_yy.equals("") && s_mm.equals(""))		query += " and "+search_dt+" like '%"+s_yy+"%'";
		}else{
			if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun4.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
			if(gubun4.equals("5")) query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		}

		if(!t_wd.equals("")){
			query += " and a.est_nm like '%"+t_wd+"%'";
		}

		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("USER_NM"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getShCarEstimateList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
     * 연장 견적관리 전체조회
     */
    public EstimateBean [] getExtCarEstimateList(String user_id, String s_yy, String s_mm, String s_dd, String gubun4, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
		String search_dt = "";

        
		query = " select a.*, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun, f.user_nm"+
				" from   estimate a, car_mng b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e, users f "+//
				" where  a.est_type='L' and a.mgr_ssn='연장견적' and a.reg_id=decode('"+user_id+"','',a.reg_id,'"+user_id+"') "+//and job ='org'
				"        and a.car_comp_id=b.car_comp_id and a.car_cd=b.code and a.car_seq=c.car_seq"+
				"        and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+)"+
				"        and a.car_comp_id=c.car_comp_id and a.car_cd=c.car_cd and a.car_id=c.car_id"+
				"        and a.reg_id=f.user_id(+)"	;

		search_dt = "a.reg_dt";

		if(gubun4.equals("")){
			if(!s_yy.equals("") && !s_mm.equals(""))	query += " and "+search_dt+" like '%"+s_yy+s_mm+s_dd+"%'";
			if(!s_yy.equals("") && s_mm.equals(""))		query += " and "+search_dt+" like '%"+s_yy+"%'";
		}else{
			if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun4.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
			if(gubun4.equals("5")) query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		}

		if(!t_wd.equals("")){
			query += " and a.est_nm like '%"+t_wd+"%'";
		}


		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("USER_NM"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getExtCarEstimateList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

/**
	 *	재리스차량정보
	 */
	public Hashtable getShBase(String car_mng_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query =  " select * from sh_base where car_mng_id=?"+
						" ";


		try {
		    pstmt = con.prepareStatement(query);
			pstmt.setString(1,car_mng_id);
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
			System.out.println("[EstiDatabase:getShBase]"+e);
			System.out.println("[EstiDatabase:getShBase]"+query);
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
     *  재리스차량기본정보 등록
     */
    public int insertShBase(Hashtable ht) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

		query = " insert into sh_base "+
				" ( CAR_MNG_ID, REG_ID, REG_DT, CAR_COMP_ID, CAR_CD, CAR_ID, CAR_SEQ, S_ST, JG_CODE, CAR_NO,"+
				"   CAR_NAME, OPT, COL, CAR_AMT, OPT_AMT, COL_AMT, O_L, CAR_USE, CAR_EXT,"+
				"   LPG_YN, DLV_DT, INIT_REG_DT, SECONDHAND_DT, BEFORE_ONE_YEAR, SERV_DT, TOT_DIST, PARK, TODAY_DIST, SH_CODE"+
				" ) values "+
				" ( ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?,   ?, ?, ?, ?,"+
				"   ?, replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), replace(?,'-',''),   replace(?,'-',''), ?, ?, ?, ?"+
				" ) ";

	   try{
		   con.setAutoCommit(false);

			if(!String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
				pstmt = con.prepareStatement(query);
				pstmt.setString(1,  String.valueOf(ht.get("CAR_MNG_ID"))					);
				pstmt.setString(2,  String.valueOf(ht.get("REG_ID"))						);
				pstmt.setString(3,  String.valueOf(ht.get("CAR_COMP_ID"))					);
				pstmt.setString(4,  String.valueOf(ht.get("CODE"))							);
				pstmt.setString(5,  String.valueOf(ht.get("CAR_ID"))						);
				pstmt.setString(6,  String.valueOf(ht.get("CAR_SEQ"))						);
				pstmt.setString(7,  String.valueOf(ht.get("S_ST"))							);
				pstmt.setString(8,  String.valueOf(ht.get("JG_CODE"))						);
				pstmt.setString(9,  String.valueOf(ht.get("CAR_NO"))						);
				pstmt.setString(10, String.valueOf(ht.get("CAR_NAME"))						);
				pstmt.setString(11, String.valueOf(ht.get("OPT"))							);
				pstmt.setString(12, String.valueOf(ht.get("COLO"))							);
				pstmt.setInt   (13, AddUtil.parseInt(String.valueOf(ht.get("CAR_AMT")))		);
				pstmt.setInt   (14, AddUtil.parseInt(String.valueOf(ht.get("OPT_AMT")))		);
				pstmt.setInt   (15, AddUtil.parseInt(String.valueOf(ht.get("CLR_AMT")))		);
				pstmt.setInt   (16, AddUtil.parseInt(String.valueOf(ht.get("O_1")))			);
				pstmt.setString(17, String.valueOf(ht.get("CAR_USE"))						);
				pstmt.setString(18, String.valueOf(ht.get("CAR_EXT"))						);
				pstmt.setString(19, String.valueOf(ht.get("LPG_YN"))						);
				pstmt.setString(20, String.valueOf(ht.get("DLV_DT"))						);
				pstmt.setString(21, String.valueOf(ht.get("INIT_REG_DT"))					);
				pstmt.setString(22, String.valueOf(ht.get("SECONDHAND_DT"))					);
				pstmt.setString(23, String.valueOf(ht.get("BEFORE_ONE_YEAR"))				);
				pstmt.setString(24, String.valueOf(ht.get("SERV_DT"))						);
				pstmt.setInt   (25, AddUtil.parseInt(String.valueOf(ht.get("TOT_DIST")))	);
				pstmt.setString(26, String.valueOf(ht.get("PARK"))							);
				pstmt.setInt   (27, AddUtil.parseInt(String.valueOf(ht.get("TODAY_DIST")))	);
				pstmt.setString(28, String.valueOf(ht.get("SH_CODE"))						);
				count = pstmt.executeUpdate();
				pstmt.close();
			}

			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertShBase]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }


	/**
     *  재리스차량기본정보 수정
     */
    public int updateShBase(Hashtable ht) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;

		query = " update sh_base set "+
				" SECONDHAND_DT		=replace(?,'-',''), "+
				" BEFORE_ONE_YEAR	=replace(?,'-',''), "+
				" SERV_DT			=replace(?,'-',''), "+
				" TOT_DIST			=?, "+
				" TODAY_DIST		=?, "+
				" PARK				=?,"+
				" CAR_NO			=?, "+
				" CAR_USE			=?, "+
				" CAR_EXT			=?, "+
				" JG_CODE			=?, "+
				" COL				=? "+
				" where car_mng_id=? ";

	   try{
		   con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, String.valueOf(ht.get("SECONDHAND_DT")));
			pstmt.setString(2, String.valueOf(ht.get("BEFORE_ONE_YEAR")));
			pstmt.setString(3, String.valueOf(ht.get("SERV_DT")));
			pstmt.setInt   (4, AddUtil.parseInt(String.valueOf(ht.get("TOT_DIST"))));
			pstmt.setInt   (5, AddUtil.parseInt(String.valueOf(ht.get("TODAY_DIST"))));
			pstmt.setString(6, String.valueOf(ht.get("PARK")));
			pstmt.setString(7, String.valueOf(ht.get("CAR_NO")));
			pstmt.setString(8, String.valueOf(ht.get("CAR_USE")));
			pstmt.setString(9, String.valueOf(ht.get("CAR_EXT")));
			pstmt.setString(10, String.valueOf(ht.get("JG_CODE")));
			pstmt.setString(11, String.valueOf(ht.get("COLO")));
			pstmt.setString(12, String.valueOf(ht.get("CAR_MNG_ID")));
			count = pstmt.executeUpdate();
			pstmt.close();

			con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateShBase]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
				con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
	 *	기존견적고객찾기
	 */
	public Vector getCustSubList(String t_wd, String ck_acar_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email, "+
				"        substr(a.reg_cont,1,8) reg_dt, substr(a.reg_cont,13) reg_id, "+
				"        substr(a.reg_cont2,1,8) reg_dt2, substr(a.reg_cont2,13) reg_id2, "+
				"        b.user_nm, "+
				"        b2.user_nm as user_nm2, "+
			    "        '1' doc_type, c.reg_dt as max_reg_dt, c.spr_yn as max_spr_yn \n"+
				" from   ( \n"+
				"         select replace(a.est_nm,' ','') est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email, max(a.est_id) est_id, "+
				"                max(a.reg_dt||a.reg_id) reg_cont, \n"+ 
				"                min(a.reg_dt||a.reg_id) reg_cont2 \n"+ 
				"         from   estimate a \n"+
				"         where  "+
			    "                a.reg_id='"+ck_acar_id+"' \n"+
				"                and substr(a.reg_dt,1,4) >= (to_char(sysdate,'YYYY')-2) \n"+
				"                and nvl(a.est_tel,' ') not in ('계산값적용') \n"+
				"                and nvl(a.est_from,' ') not like 'lc_%' \n"+
				"                and nvl(a.est_from,' ') not like 'cmp%' \n"+
				"                and nvl(a.est_from,' ') <> 'main_car' and nvl(a.est_from,' ') not like 'off_ls%'  \n"+
				"                and substr(a.est_nm,1,4) not in ('rs36','rb36','ls36','lb36') and nvl(a.use_yn,'Y')='Y' \n"+
		        "                and ( REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+t_wd+"%',' ',''),'(주)',''),'주식회사','') \n"+
				"                      OR REPLACE(REPLACE(a.est_ssn,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_tel,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_fax,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                      OR REPLACE(REPLACE(a.est_email,' ',''),'-','') like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') \n"+
				"                    ) \n"+
//				"                replace(a.est_nm,' ','')||a.est_ssn||a.est_tel||a.est_fax||a.est_email like '%"+t_wd+"%' "+
				"         group by replace(a.est_nm,' ',''), a.est_ssn, a.est_tel, a.est_fax, a.est_email \n"+
				"        ) a, USERS b, USERS b2, estimate c "+
				" WHERE substr(a.reg_cont,13)=b.user_id(+) and substr(a.reg_cont2,13)=b2.user_id(+) and a.est_id=c.est_id(+)  \n"+
				" order by a.est_nm, a.est_ssn, a.est_tel, a.est_fax, a.est_email ";
/*
		query = " select * from \n"+
				" ( \n"+
				" select replace(a.est_nm,' ','') est_nm, a.est_ssn, a.est_tel, a.est_fax, a.doc_type, a.est_email, max(substr(a.reg_dt,1,8)) reg_dt \n"+
				" from   estimate a \n"+
				" where  a.reg_id='"+ck_acar_id+"' and replace(a.est_nm,' ','')||a.est_ssn||a.est_tel||a.est_fax||a.est_email like '%"+t_wd+"%' "+
				"        and substr(a.reg_dt,1,4) >= (to_char(sysdate,'YYYY')-2) \n"+
//				"        and length(a.est_tel) not in (6) \n"+
				"        and nvl(a.est_tel,' ') not in ('계산값적용') \n"+
				"        and nvl(a.est_from,' ') not like 'lc_%' \n"+
				"        and nvl(a.est_from,' ') not like 'cmp%' \n"+
				"        and nvl(a.est_from,' ') <> 'main_car' \n"+
				"        and substr(a.est_nm,1,4) not in ('rs36','rb36','ls36','lb36') \n"+
				" group by replace(a.est_nm,' ',''), a.est_ssn, a.est_tel, a.est_fax, a.doc_type, a.est_email  \n"+
				" ) \n"+
				" order by reg_dt";
*/

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
			System.out.println("[EstiDatabase:getCustSubList]"+e);
			System.out.println("[EstiDatabase:getCustSubList]"+query);
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
	 *	기존견적고객조회
	 */
	public Vector getLcCustSubList(String t_wd, String ck_acar_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select client_id, firm_nm as est_nm, nvl(enp_no,ssn) as est_ssn, o_tel as est_tel, fax as est_fax, reg_dt, decode(client_st,'1','1','2','3','2') doc_type, con_agnt_email AS est_email \n"+
				" from   client \n"+
				" where  client_id in (select client_id from cont where bus_id='"+ck_acar_id+"' group by client_id) "+
				"        and ( REPLACE(REPLACE(REPLACE(firm_nm||client_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+t_wd+"%',' ',''),'(주)',''),'주식회사','') \n"+
				"          OR enp_no||TEXT_DECRYPT(ssn, 'pw' ) like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(o_tel||m_tel,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(fax,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(con_agnt_email,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				" ) "+
				" order by firm_nm";


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
			System.out.println("[EstiDatabase:getLcCustSubList]"+e);
			System.out.println("[EstiDatabase:getLcCustSubList]"+query);
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
	 *	견적결과변수정보
	 */
	public Hashtable getEstimateResultVar(String est_id, String est_table) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " select * from "+est_table+" where est_id=? ";


		try {
		    pstmt = con.prepareStatement(query);
			pstmt.setString(1,est_id);
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
			System.out.println("[EstiDatabase:getEstimateResultVar]"+e);
			System.out.println("[EstiDatabase:getEstimateResultVar]"+query);
			System.out.println("[EstiDatabase:getEstimateResultVar]"+est_id);
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
     * 프로시져 호출
     */
    public String call_sp_esti_reg_sh_case_base(String rent_dt, String car_mng_id, String reg_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_SH_BASE(?,?,?)}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);	
			cstmt.setString(1, rent_dt);
			cstmt.setString(2, car_mng_id);
			cstmt.setString(3, reg_id);
			cstmt.execute();

			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh_case_base]"+se);
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
	 *	기존견적고객조회2
	 */
	public String getSearchEstIdTaeSh(String car_mng_id, String a_a, String o_1, String today_dist, String rent_dt, String reg_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String est_id = "";

		String query =  " select min(a.est_id) est_id from estimate_sh a, esti_compare_sh b where a.est_type='S' and a.est_id=b.est_id and a.fee_s_amt>0 "+
						" and a.mgr_nm = '"+car_mng_id+"' "+
						" and a.a_a = '"+a_a+"' "+
						" and a.o_1	= "+o_1+" "+
						" and a.rent_dt	= '"+rent_dt+"' "+
						" ";

		if(!reg_code.equals(""))	query += " and a.reg_code	= "+reg_code+" ";
		if(!today_dist.equals("0"))	query += " and a.today_dist	= "+today_dist+" ";


		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 est_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getSearchEstIdTaeSh]"+e);
			System.out.println("[EstiDatabase:getSearchEstIdTaeSh]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return est_id;
	}

	/**
	 *	기존견적고객조회
	 */
	public String getSearchEstIdSh(String car_mng_id, String a_a, String a_b, String o_1, String today_dist, String rent_dt, String amt, String reg_code) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String est_id = "";

		String query =  " select a.est_id from estimate_sh a, esti_compare_sh b where a.est_type='S' and a.est_id=b.est_id"+
						" and a.mgr_nm = '"+car_mng_id+"' "+
						" and a.a_a = '"+a_a+"' "+
						" and a.a_b = '"+a_b+"' "+
						" and a.o_1	= "+o_1+" "+
						" and a.rent_dt	= '"+rent_dt+"' "+
						" and a.fee_s_amt = "+amt+" "+
						" ";

		if(!reg_code.equals(""))	query += " and a.reg_code	= "+reg_code+" ";
		if(!today_dist.equals("0"))	query += " and a.today_dist	= "+today_dist+" ";


		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 est_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();


		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getSearchEstIdSh]"+e);
			System.out.println("[EstiDatabase:getSearchEstIdSh]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return est_id;
	}

	/**
     * 차종별잔가변수-색상 및 사양 잔가조정
     */
    public int insertEstiJgOptVar(EstiJgVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		String query2 = "";
        int count = 0;
			
        query2 = " INSERT INTO ESTI_JG_OPT_VAR "+
				" (sh_code, seq, jg_opt_st, jg_opt_1, jg_opt_2, jg_opt_3, jg_opt_4, jg_opt_5, jg_opt_6, jg_opt_7, reg_dt, jg_opt_8, jg_opt_9 "+
				" )"+
				" values \n"+
	            " ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ? "+
				" )";
           
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query2);
            pstmt.setString(1,  bean.getSh_code		().trim());
            pstmt.setString(2,  bean.getSeq 		());
            pstmt.setString(3,  bean.getJg_opt_st	().trim());
            pstmt.setString(4,  bean.getJg_opt_1	().trim());
            pstmt.setFloat (5,  bean.getJg_opt_2 	());
			pstmt.setFloat (6,  bean.getJg_opt_3 	());
            pstmt.setFloat (7,  bean.getJg_opt_4 	());
            pstmt.setFloat (8,  bean.getJg_opt_5 	());
            pstmt.setFloat (9,  bean.getJg_opt_6 	());
            pstmt.setFloat (10, bean.getJg_opt_7 	());
            pstmt.setString(11, bean.getReg_dt		().trim());
            pstmt.setString(12, bean.getJg_opt_8	().trim());
            pstmt.setString(13, bean.getJg_opt_9	().trim());

			count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertEstiJgOptVar]"+se);
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

	/**
	 *	차종변수 조정잔가 비고설명문
	 */
	public String getEstiJgOptVarJgOpt8(String sh_code, String seq, String jg_opt_st) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String jg_opt_8 = "";

		String query =  " SELECT jg_opt_8 FROM esti_jg_opt_var where sh_code='"+sh_code+"' and seq='"+seq+"' and jg_opt_st='"+jg_opt_st+"' ";



		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 jg_opt_8 = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getEstiJgOptVarJgOpt8]"+e);
			System.out.println("[EstiDatabase:getEstiJgOptVarJgOpt8]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return jg_opt_8;
	}

	/**
	 *	차종변수 조정잔가 비고설명문
	 */
	public String getEstiJgOptVarJgOpt9(String sh_code, String seq, String jg_opt_st) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String jg_opt_9 = "";

		String query =  " SELECT jg_opt_9 FROM esti_jg_opt_var where sh_code='"+sh_code+"' and seq='"+seq+"' and jg_opt_st='"+jg_opt_st+"' ";



		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 jg_opt_9 = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getEstiJgOptVarJgOpt9]"+e);
			System.out.println("[EstiDatabase:getEstiJgOptVarJgOpt9]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return jg_opt_9;
	}

    /**
     * 차종별잔가변수 조회-세부내용
     */
    public EstiJgVarBean getEstiJgOptVarCase(String sh_code, String seq, String jg_opt_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstiJgVarBean bean = new EstiJgVarBean();
        String query = "";
        
        query = " select * from esti_jg_opt_var where sh_code='"+sh_code+"' and seq='"+seq+"' and jg_opt_st='"+jg_opt_st+"' ";


        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            if(rs.next()){
				bean.setSh_code		(rs.getString("sh_code"));
			    bean.setSeq			(rs.getString("seq"));
				bean.setJg_opt_st 	(rs.getString("jg_opt_st"));
				bean.setReg_dt	 	(rs.getString("reg_dt"));
				bean.setJg_opt_1 	(rs.getString("jg_opt_1"));
				bean.setJg_opt_2	(rs.getFloat ("jg_opt_2"));
				bean.setJg_opt_3	(rs.getFloat ("jg_opt_3"));
				bean.setJg_opt_4	(rs.getFloat ("jg_opt_4"));
			    bean.setJg_opt_5 	(rs.getFloat ("jg_opt_5"));
			    bean.setJg_opt_6 	(rs.getFloat ("jg_opt_6"));
				bean.setJg_opt_7	(rs.getFloat ("jg_opt_7"));
				bean.setJg_opt_8	(rs.getString("jg_opt_8"));
			}
            rs.close();
            pstmt.close();
		}catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiJgOptVarCase]"+se);
			System.out.println("[EstiDatabase:getEstiJgOptVarCase]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
     * 프로시져 호출
     */
    public String call_sp_esti_reg_hp(String est_tel, String set_code, int agree_dist) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_REG_HP(?,?,?)}";


	    try{

			//주요차종 견적등록 프로시저 호출
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, est_tel);
			cstmt.setString(2, set_code);
			cstmt.setInt   (3, agree_dist);
			cstmt.execute();
			cstmt.close();


        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_hp]"+se);
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
	 *	견적 최근7일이내 견적여부 (본인거 제외)
	 */
	public Vector getEstimateSpeCustEstCheck(String gubun1, String est_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select SUBSTR(a.reg_dt,1,8) rent_dt, a.est_nm, f.user_id as reg_id, f.user_nm, f.user_m_tel, f.user_pos \n"+
				" from   esti_spe a, (SELECT est_id, max(car_mng_id) car_mng_id FROM ESTI_SPE_CAR GROUP BY est_id) b, \n"+
				"	     ( select a.est_id, a.user_id, a.reg_dt, a.note \n"+
                "          from   esti_m a , ( select est_id, min(seq_no) seq_no from esti_m group by est_id ) b \n"+
			    "	       where  a.est_id = b.est_id and a.seq_no = b.seq_no \n"+
                "        ) t, \n"+
                "        users f \n"+
                " WHERE  SUBSTR(a.reg_dt,1,8) >= TO_CHAR(sysdate-7,'YYYYMMDD') \n"+
                "        AND a.est_id=b.est_id(+) \n"+
             	"	     and a.est_id=t.est_id(+) and t.user_id=f.user_id(+) \n"+
		        "        and REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') = REPLACE(REPLACE(REPLACE('"+est_nm+"',' ',''),'(주)',''),'주식회사','') \n"+
			    " ";

		//재리스
	//	if(gubun1.equals("7")) query += " and b.car_mng_id is not null and a.etc not like '%월렌트%' ";
		if(gubun1.equals("7")) query += " and b.car_mng_id is not null and (a.etc is null or a.etc not like '%월렌트%') ";

		query += " ORDER BY a.reg_dt desc ";


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
			System.out.println("[EstiDatabase:getEstimateSpeCustEstCheck]"+e);
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
	 *	스마트견적 최근30일이내 견적여부 (본인거 제외)
	 */
	public Vector getEstimateSpeCustEstCheck2(String gubun1, String est_nm, String est_ssn, String est_tel, String est_fax, String est_email) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		query = " select SUBSTR(a.reg_dt,1,8) rent_dt, a.est_nm, f.user_id as reg_id, f.user_nm, f.user_m_tel, f.user_pos, a.reg_dt \n"+
				" from   esti_spe a, (SELECT est_id, max(car_mng_id) car_mng_id FROM ESTI_SPE_CAR GROUP BY est_id) b, \n"+
				"	     ( select a.est_id, a.user_id, a.reg_dt, a.note \n"+
                "          from   esti_m a , ( select est_id, min(seq_no) seq_no from esti_m group by est_id ) b \n"+
			    "	       where  a.est_id = b.est_id and a.seq_no = b.seq_no \n"+
                "        ) t, \n"+
                "        users f \n"+
                " WHERE  SUBSTR(a.reg_dt,1,8) >= TO_CHAR(sysdate-30,'YYYYMMDD') \n"+
                "        AND a.est_id=b.est_id(+) \n"+
             	"	     and a.est_id=t.est_id(+) and t.user_id=f.user_id(+) \n"+
		        "        and ( REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') = REPLACE(REPLACE(REPLACE('"+est_nm+"',' ',''),'(주)',''),'주식회사','') \n"+
			    " ";

		if(!est_ssn.equals(""))		query +=" OR REPLACE(REPLACE(a.est_ssn,' ',''),'-','') = REPLACE(REPLACE('"+est_ssn+"',' ',''),'-','') ";
		if(!est_tel.equals(""))		query +=" OR REPLACE(REPLACE(a.est_tel,' ',''),'-','') = REPLACE(REPLACE('"+est_tel+"',' ',''),'-','') ";
		if(!est_fax.equals(""))		query +=" OR REPLACE(REPLACE(a.est_fax,' ',''),'-','') = REPLACE(REPLACE('"+est_fax+"',' ',''),'-','') ";
		if(!est_email.equals(""))	query +=" OR REPLACE(REPLACE(a.est_email,' ',''),'-','') = REPLACE(REPLACE('"+est_email+"',' ',''),'-','') ";

		query +=" ) ";

		//신차
	//	if(gubun1.equals("1")) query += " and b.car_mng_id is null and a.etc not like '%월렌트%' ";
		if(gubun1.equals("1")) query += " and b.car_mng_id is null and (a.etc is null or a.etc not like '%월렌트%') ";

		//재리스
	//	if(gubun1.equals("7")) query += " and b.car_mng_id is not null and a.etc not like '%월렌트%' ";
		if(gubun1.equals("7")) query += " and b.car_mng_id is not null and (a.etc is null or a.etc not like '%월렌트%') ";

		query += " ORDER BY a.reg_dt desc ";

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
			System.out.println("[EstiDatabase:getEstimateSpeCustEstCheck2(String gubun1, String est_nm, String est_ssn, String est_tel)]"+e);
			System.out.println("[EstiDatabase:getEstimateSpeCustEstCheck2(String gubun1, String est_nm, String est_ssn, String est_tel)]"+query);
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

  /*************************    mobile   ***********************************/
  /**
     * 스페셜견적관리 전체조회
     */
    public EstiSpeBean [] getEstiSpeList(String gubun1, String gubun2, String gubun3,  String s_yy, String s_mm, String email) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
       String search_dt = "";
       	String order = "";
       	
		query = " select a.*, e.user_id as m_user_id, e.reg_dt as m_reg_dt, decode(b.est_id,'','','성사') rent_yn"+
				" from esti_spe a, "+
				"	   (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e,"+
				"	   (select est_id from esti_m where note='16' or note like '%계약체결%' group by est_id) b"+
				" where "+
				" a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+) and a.est_id=b.est_id(+) ";

		if(gubun1.equals("1")){		
			search_dt = "substr(a.reg_dt, 1, 8) ";
			order = " a.reg_dt ";
		}
			
		if(gubun2.equals("4")){
			if(!s_yy.equals("") && !s_mm.equals(""))	query += " and "+order+" between '"+s_yy+"' and '"+s_mm+"'";
			if(!s_yy.equals("") && s_mm.equals(""))		query += " and "+order+" like '%"+s_yy+"%'";
		}
		
	    query += " and a.est_email like '%"+email+"%'";   //email
	 
		query += " order by "+order+" desc ";
		
	
        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstiSpeBean bean = new EstiSpeBean();
				bean.setEst_id	(rs.getString("EST_ID"));
				bean.setEst_st	(rs.getString("EST_ST"));
	            bean.setEst_nm	(rs.getString("EST_NM"));
		        bean.setEst_ssn	(rs.getString("EST_SSN"));
			    bean.setEst_tel	(rs.getString("EST_TEL"));
				bean.setEst_agnt(rs.getString("EST_AGNT"));
	            bean.setEst_bus	(rs.getString("EST_BUS"));
		        bean.setEst_year(rs.getString("EST_YEAR"));
			    bean.setCar_nm	(rs.getString("CAR_NM"));
				bean.setEtc		(rs.getString("ETC"));
				bean.setReg_dt	(rs.getString("REG_DT"));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setRent_yn	(rs.getString("RENT_YN"));
		        bean.setEst_area	(rs.getString("EST_AREA"));
		      
			col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstiSpeList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstiSpeBean[])col.toArray(new EstiSpeBean[0]);
    }


	/**
     * 스마트견적신청시 기존고객인지 체크검사 
     */
    public String Searchest_ssn(String est_ssn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		String client_id = "";

		query = " SELECT client_id FROM CLIENT WHERE enp_no = replace('"+est_ssn+"','-','') ";

       try{
            con.setAutoCommit(false);

            //client_id 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	client_id = rs.getString(1)==null?"":rs.getString(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
            try{
			System.out.println("[EstiDatabase:Searchest_ssn]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return client_id;
    }

    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateShRmCase(String car_mng_id, String reg_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate_sh where mgr_nm='"+car_mng_id+"' and mgr_ssn='rm1' and reg_code='"+reg_code+"' ";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));
	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_per(rs.getFloat("CLS_PER"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setDoc_type	(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setVali_type	(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
				bean.setReg_code	(rs.getString("reg_code")==null?"":rs.getString("reg_code"));
	            bean.setOpt_chk		(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt	(rs.getInt("FEE_OPT_AMT"));
				bean.setSet_code	(rs.getString("SET_CODE"));
				bean.setGi_per		(rs.getFloat("GI_PER"));
				bean.setEst_email	(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setCha_st_dt	(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist		(rs.getInt("B_DIST"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st	(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setMax_use_mon	(rs.getString("MAX_USE_MON")==null?"":rs.getString("MAX_USE_MON"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				bean.setRtn_run_amt		(rs.getString("rtn_run_amt")		==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));


			}
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateShCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
    
    public int updateDamdangId(String userId, String estId) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        int count = 0;
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        String query = "";
        
        query = " update sh_res SET DAMDANG_ID = '" + userId + "' WHERE EST_ID = '" + estId + "'";
        
        try {
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
            pstmt.close();

        }catch(SQLException se){
            try{
            System.out.println("[EstiDatabase:updateDamdangId]"+userId);
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
   
    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateCuCase(String est_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate_cu where est_id='"+est_id+"'";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
	            bean.setOpt_amt_m(rs.getInt("OPT_AMT_M"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));
	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_per(rs.getFloat("CLS_PER"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setReg_code(rs.getString("REG_CODE"));
				bean.setRent_mng_id	(rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd	(rs.getString("RENT_L_CD"));
				bean.setRent_st		(rs.getString("RENT_ST"));
				bean.setIns_per		(rs.getString("INS_PER"));
				bean.setDoc_type	(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setVali_type	(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
	            bean.setOpt_chk		(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt	(rs.getInt("FEE_OPT_AMT"));
				bean.setSet_code	(rs.getString("SET_CODE"));
				bean.setGi_per		(rs.getFloat("GI_PER"));
				bean.setEst_email	(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setCaroff_emp_yn(rs.getString("caroff_emp_yn")==null?"":rs.getString("caroff_emp_yn"));
				bean.setPrint_type	(rs.getString("print_type")==null?"":rs.getString("print_type"));
			    bean.setCtr_s_amt	(rs.getInt("CTR_S_AMT"));
				bean.setCtr_v_amt	(rs.getInt("CTR_V_AMT"));
				bean.setUse_yn		(rs.getString("USE_YN"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setB_agree_dist(rs.getInt("B_AGREE_DIST"));
				bean.setB_o_13		(rs.getFloat("B_O_13"));
				bean.setLoc_st		(rs.getString("LOC_ST")==null?"":rs.getString("LOC_ST"));
				bean.setTint_b_yn	(rs.getString("tint_b_yn")==null?"":rs.getString("tint_b_yn"));
				bean.setTint_s_yn	(rs.getString("tint_s_yn")==null?"":rs.getString("tint_s_yn"));
				bean.setTint_sn_yn	(rs.getString("tint_sn_yn")==null?"":rs.getString("tint_sn_yn"));
				bean.setTint_n_yn	(rs.getString("tint_n_yn")==null?"":rs.getString("tint_n_yn"));
				bean.setTint_bn_yn	(rs.getString("tint_bn_yn")==null?"":rs.getString("tint_bn_yn"));
				bean.setNew_license_plate		(rs.getString("NEW_LICENSE_PLATE")==null?"":rs.getString("NEW_LICENSE_PLATE"));
				bean.setTint_cons_yn		(rs.getString("TINT_CONS_YN")==null?"":rs.getString("TINT_CONS_YN"));
			    bean.setTint_cons_amt	(rs.getInt("TINT_CONS_AMT"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setGarnish_col		(rs.getString("GARNISH_COL")==null?"":rs.getString("GARNISH_COL"));
				bean.setBus_yn		(rs.getString("bus_yn")==null?"":rs.getString("bus_yn"));
				bean.setBus_cau		(rs.getString("bus_cau")==null?"":rs.getString("bus_cau"));
				bean.setInsurant	(rs.getString("insurant")==null?"":rs.getString("insurant"));
				bean.setBus_cau_dt	(rs.getString("bus_cau_dt")==null?"":rs.getString("bus_cau_dt"));
				bean.setCha_st_dt	(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist		(rs.getInt("B_DIST"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st	(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setMax_use_mon	(rs.getString("MAX_USE_MON")==null?"":rs.getString("MAX_USE_MON"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setTint_eb_yn		(rs.getString("tint_eb_yn")==null?"":rs.getString("tint_eb_yn"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setEh_code		(rs.getString("eh_code")==null?"":rs.getString("eh_code"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				bean.setBr_to			(rs.getString("br_to")==null?"":rs.getString("br_to"));
				bean.setBr_to_st		(rs.getString("br_to_st")==null?"":rs.getString("br_to_st"));
				bean.setBr_from		(rs.getString("br_from")==null?"":rs.getString("br_from"));
				bean.setRtn_run_amt		(rs.getString("rtn_run_amt")		==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateCuCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }	

    /**
     * 견적서관리 조회-리스트에서
     */
    public EstimateBean getEstimateCuRmCase(String car_mng_id, String reg_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate_cu where mgr_nm='"+car_mng_id+"' and mgr_ssn='rm1' and reg_code='"+reg_code+"' ";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));
	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_per(rs.getFloat("CLS_PER"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setDoc_type	(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setVali_type	(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
				bean.setReg_code	(rs.getString("reg_code")==null?"":rs.getString("reg_code"));
	            bean.setOpt_chk		(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt	(rs.getInt("FEE_OPT_AMT"));
				bean.setSet_code	(rs.getString("SET_CODE"));
				bean.setGi_per		(rs.getFloat("GI_PER"));
				bean.setEst_email	(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setCha_st_dt	(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist		(rs.getInt("B_DIST"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st	(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setMax_use_mon	(rs.getString("MAX_USE_MON")==null?"":rs.getString("MAX_USE_MON"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				bean.setBr_to			(rs.getString("br_to")==null?"":rs.getString("br_to"));
				bean.setBr_to_st		(rs.getString("br_to_st")==null?"":rs.getString("br_to_st"));
				bean.setBr_from		(rs.getString("br_from")==null?"":rs.getString("br_from"));
				bean.setRtn_run_amt		(rs.getString("rtn_run_amt")		==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));


			}
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateCuRmCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
    

    /**
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateHpCustomerList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select a.*, b.car_no, d.car_nm, c.car_name, "+
                "        decode(a.est_type,'F','신차','W','홈페이지','M','고객FMS','J','주요차종','L','연장계약','S','재리스') est_gubun,  " +
                "        decode(a.fee_s_amt,'0','견적중지','견적') est_check "+
                " from   estimate_cu a, car_reg b, car_nm c, car_mng d "+
                " where  NVL(job,'org') = 'org'  ";

        if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
        if(gubun4.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
        if(gubun4.equals("3")) query += " and a.reg_dt like  >= TO_CHAR(ADD_MONTHS(SYSDATE,-3),'YYYYMMDD') and a.reg_dt like  between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
        
        if(gubun4.equals("4")) query += " and a.reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD'), -1), 'YYYYMM')||'%'";
        if(gubun4.equals("5")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";

        query +="         and a.mgr_nm=b.car_mng_id (+) and a.car_id=c.car_id and a.car_seq=c.car_seq "+
                "         and c.car_comp_id = d.car_comp_id and c.car_cd = d.code ";
        
        if(gubun1.equals("F")) query += " and a.est_type = 'F' ";       
        if(gubun1.equals("S")) query += " and a.est_type = 'S' ";

        if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
        

        if(!t_wd.equals("")){
            if(s_kd.equals("1")) query += " and d.car_nm||c.car_name like '%"+t_wd+"%'";
            if(s_kd.equals("2")) query += " and b.car_no like '%"+t_wd+"%'";
            if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
        }

        query += " order by a.reg_dt desc";

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);                    
            rs = pstmt.executeQuery();
            while(rs.next()){
                EstimateBean bean = new EstimateBean();
                bean.setEst_id(rs.getString("EST_ID"));
                bean.setEst_nm(rs.getString("EST_NM"));
                bean.setEst_ssn(rs.getString("EST_SSN"));
                bean.setEst_tel(rs.getString("EST_TEL"));
                bean.setEst_fax(rs.getString("EST_FAX"));
                bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
                bean.setCar_cd(rs.getString("CAR_CD"));
                bean.setCar_id(rs.getString("CAR_ID"));
                bean.setCar_seq(rs.getString("CAR_SEQ"));
                bean.setCar_amt(rs.getInt("CAR_AMT"));
                bean.setOpt(rs.getString("OPT"));
                bean.setOpt_seq(rs.getString("OPT_SEQ"));
                bean.setOpt_amt(rs.getInt("OPT_AMT"));
                bean.setCol(rs.getString("COL"));
                bean.setCol_seq(rs.getString("COL_SEQ"));
                bean.setCol_amt(rs.getInt("COL_AMT"));
                bean.setDc(rs.getString("DC"));
                bean.setDc_seq(rs.getString("DC_SEQ"));
                bean.setDc_amt(rs.getInt("DC_AMT"));
                bean.setO_1(rs.getInt("O_1"));
                bean.setA_a(rs.getString("A_A"));
                bean.setA_b(rs.getString("A_B"));
                bean.setA_h(rs.getString("A_H"));
                bean.setPp_st(rs.getString("PP_ST"));
                bean.setPp_amt(rs.getInt("PP_AMT"));
                bean.setPp_per(rs.getInt("PP_PER"));
                bean.setRg_8(rs.getFloat("RG_8"));
                bean.setIns_age(rs.getString("INS_AGE"));
                bean.setIns_dj(rs.getString("INS_DJ"));
                bean.setRo_13(rs.getFloat("RO_13"));
                bean.setG_10(rs.getInt("G_10"));
                bean.setGi_amt(rs.getInt("GI_AMT"));
                bean.setGi_fee(rs.getInt("GI_FEE"));
                bean.setGtr_amt(rs.getInt("GTR_AMT"));
                bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
                bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
                bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
                bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
                bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
                bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
                bean.setIns_good(rs.getString("INS_GOOD"));
                bean.setReg_id(rs.getString("REG_ID"));
                bean.setReg_dt(rs.getString("REG_DT"));
                bean.setCar_ja(rs.getInt("CAR_JA"));
                bean.setLpg_yn(rs.getString("LPG_YN"));
                bean.setGi_yn(rs.getString("GI_YN"));
                bean.setCar_nm(rs.getString("CAR_NM"));
                bean.setCar_name(rs.getString("CAR_NAME"));
                bean.setTalk_tel(rs.getString("TALK_TEL"));
                bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
                bean.setEst_gubun(rs.getString("est_gubun"));
                bean.setMgr_nm(rs.getString("CAR_NO"));
                bean.setToday_dist(rs.getInt("TODAY_DIST"));
                bean.setEst_email(rs.getString("EST_EMAIL"));
                bean.setEst_check(rs.getString("EST_CHECK"));
                //bean.setReg_nm(rs.getString("reg_nm"));
                bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
                bean.setIn_col      (rs.getString("in_col")==null?"":rs.getString("in_col"));
                bean.setSpr_yn(rs.getString("SPR_YN"));
                bean.setTax_dc_amt      (rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
                bean.setEcar_loc_st     (rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
                bean.setEco_e_tag	     (rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
                bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
                bean.setEcar_pur_sub_st (rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
                bean.setConti_rat       (rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
                bean.setDriver_add_amt  (rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));

                col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
            System.out.println("[EstiDatabase:getEstimateFmsShList]"+se);
            System.out.println("[EstiDatabase:getEstimateFmsShList]"+query);
             throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
            con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
	 *	연장견적 최근30일이내 견적여부 (본인거 제외)
	 */
	public Vector getEstimateContEstCheck(String rent_mng_id, String rent_l_cd, String rent_st) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.reg_dt, a.rent_dt, a.est_nm, a.reg_id, b.user_nm, b.user_m_tel, b.user_pos \n"+
				" FROM   ESTIMATE a, USERS b \n"+
				" WHERE  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.rent_st='"+rent_st+"' "+
				"        and a.fee_s_amt >0 \n"+
				"        AND a.reg_id=b.user_id  and nvl(a.use_yn,'Y')='Y' \n"+
			    " ";

		query += " ORDER BY a.rent_dt desc, a.reg_dt desc, a.reg_code desc ";

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
			System.out.println("[EstiDatabase:getEstimateContEstCheck(String rent_mng_id, String rent_l_cd, String rent_st)]"+e);
			System.out.println("[EstiDatabase:getEstimateContEstCheck(String rent_mng_id, String rent_l_cd, String rent_st)]"+query);
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
     * 프로시져 호출 call_sp_esti_reg_sh_offls(reg_code, rent_dt, car_mng_id, today_dist);
     */
    public String call_sp_esti_reg_sh_offls(String reg_code, String rent_dt, String car_mng_id, String today_dist) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
		
    	String query1 = "{CALL P_ESTI_REG_SH_OFFLS(?, ?, ?, ?)}";

	    try{

			//경매낙찰현황 실낙찰금액 프로시저 호출
			cstmt = con.prepareCall(query1);		
			cstmt.setString(1, reg_code);			
			cstmt.setString(2, rent_dt);			
			cstmt.setString(3, car_mng_id);			
			cstmt.setString(4, today_dist);			
			cstmt.execute();
			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh_offls] car_mng_id="+car_mng_id);
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh_offls] reg_code="+reg_code);
			System.out.println("[EstiDatabase:call_sp_esti_reg_sh_offls]"+se);
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
	 *	reg_code 견적리스트
	 */
	public Vector getEstiMateResultCaramtList(String esti_table, String car_mng_id, String rent_dt, String today_dist) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		if(esti_table.equals("estimate_sh")){

			query = " select 'estimate_sh' as t_st, t.mgr_ssn as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate_sh t, esti_compare_sh p, esti_exam_sh x    "+
					" where   t.mgr_nm='"+car_mng_id+"' and t.rent_dt='"+rent_dt+"' and t.today_dist="+today_dist+" "+
					"         and t.est_id=p.est_id(+) and t.est_id=x.est_id(+) order by t.reg_dt ";

		}else{

			query = " select 'estimate' as t_st, t.job as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate t, esti_compare p, esti_exam x    "+
					" where   t.mgr_nm='"+car_mng_id+"' and t.rent_dt='"+rent_dt+"' and t.today_dist="+today_dist+" "+
					"         and t.est_id=p.est_id(+) and t.est_id=x.est_id(+) order by t.reg_dt ";


		}

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
			System.out.println("[EstiDatabase:getEstiMateResultCaramtList(String esti_table, String est_id)]"+e);
			System.out.println("[EstiDatabase:getEstiMateResultCaramtList(String esti_table, String est_id)]"+query);
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
	 *	금액변환
	 */
	public int getTruncAmt(int t_amt, String t_per, String t_type, String t_number) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int r_amt = 0;


		String query =  " SELECT "+t_type+"("+t_amt+"*"+t_per+","+t_number+") amt FROM dual ";



		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 r_amt = rs.getInt(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getTruncAmt]"+e);
			System.out.println("[EstiDatabase:getTruncAmt]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return r_amt;
	}

	//d-mail 발송 한건 등록
	public boolean insertDEmailEnc3(String gubun, String gubun2, String fileinfo, String content) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;

		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;

			
		String query1 = " select max(seqidx) from  IM_DMAIL_INFO_7 where gubun='"+gubun+"'";

		if(!gubun2.equals(""))	query1 += " and gubun2='"+gubun2+"'";




		query = " INSERT INTO im_enc_dmail_7 ( idx, seqidx, fileinfo, content ) VALUES "+
				" ( (SELECT nvl(max(idx)+1,1) FROM IM_ENC_DMAIL_7 ), ?, ?, ? ) ";


		try 
		{
			con.setAutoCommit(false);

			pstmt1 = con.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt = con.prepareStatement(query);

			pstmt.setInt   	(1,		seqidx	); 
			pstmt.setString	(2,		fileinfo); 
			pstmt.setString	(3,		content); 
			pstmt.executeUpdate();	
			pstmt.close();

			con.commit();
																 
	  	} catch (Exception e) {
            try{
				System.out.println("[EstiDatabase:insertDEmailEnc3]"+e);

                con.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
		} finally {
			try{
				if ( pstmt != null )	pstmt.close();
				con.setAutoCommit(true);
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return flag;
		}
	}

	//d-mail 발송 한건 등록
	public boolean insertDEmail4(tax.DmailBean bean, String sdate, String tdate) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO im_dmail_info_8"+
				" ( seqidx, subject, sql, reject_slist_idx, block_group_idx, mailfrom, mailto, replyto, errorsto, html,"+//1
				"   encoding, charset, sdate, tdate, duration_set, click_set, site_set, atc_set, gubun, rname,"+//2
				"   mtype, u_idx, g_idx, msgflag, content, qry "+//3
				" ) VALUES"+
				" ( IM_SEQ_DMAIL_INFO_8.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, to_char(sysdate,'YYYYMMDDhh24miss'), to_char(sysdate"+tdate+",'YYYYMMDDhh24miss'), ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ? , ? "+
				" )";

		//sdate=to_char(sysdate+0.05,'YYYYMMDDhh24miss') => 현재시간으로 부터 1시간후에 발송시작
		//tdate=to_char(sysdate+6.05,'YYYYMMDDhh24miss') => sdate 포함 7일이 수신확인종료시간

		try 
		{
			con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
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
			pstmt.setString	(23,		bean.getSql				()); 
			pstmt.executeUpdate();
			con.commit();
																 
	  	} catch (Exception e) {
            try{
				System.out.println("[EstiDatabase:insertDEmail4]"+e);
				System.out.println("[EstiDatabase:insertDEmail4-gubun]"+bean.getGubun()+"2번쿼리");
                con.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
		} finally {
			try{
				if ( pstmt != null )	pstmt.close();
				con.setAutoCommit(true);
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return flag;
		}
	}

	/**
	 *	메일패키지 테이블이름 가져오기
	 */
	public String getEstiPackEstTableNm(String pack_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String est_talbe = "estimate";

		String query =  " SELECT est_table FROM esti_pack where pack_id = '"+pack_id+"' and seq = 1 ";



		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				 est_talbe = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getEstiPackEstTableNm]"+e);
			System.out.println("[EstiDatabase:getEstiPackEstTableNm]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return est_talbe;
	}

    /**
	 *	견적서 묶음리스트
	 */
	public Vector getEstiPackList(String pack_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select e.nm as car_comp_nm, g.car_no, c.car_nm, d.car_name, f.nm as good_nm, a.pack_st, \n"+
				"        decode(b.o_1,b.car_amt+b.opt_amt+b.col_amt-b.dc_amt-nvl(b.tax_dc_amt,0),'1','0') car_gu, \n"+
				"        b.*, a.memo, a.seq \n"+
				" from   esti_pack a, estimate b, car_mng c, car_nm d, car_reg g, \n"+
				"        (select * from code where c_st='0001' and code<>'0000') e, \n"+
				"        (select * from code where c_st='0009' and code<>'0000') f \n"+
				" where  a.pack_id='"+pack_id+"' \n"+
				"        and a.est_id=b.est_id \n"+
				"        and b.car_comp_id=c.car_comp_id and b.car_cd=c.code \n"+
				"        and b.car_id=d.car_id and b.car_seq=d.car_seq \n"+
				"        and b.car_comp_id=e.code \n"+
				"        and b.a_a=f.nm_cd and b.mgr_nm=g.car_mng_id(+)  \n"+
				" order by e.nm, c.car_nm, d.car_name, f.nm, b.a_b, a.seq";

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
			System.out.println("[EstiDatabase:getEstiPackList]"+e);
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
	 *	견적서 묶음리스트
	 */
	public Vector getEstiPackList(String pack_id, String est_table) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select e.nm as car_comp_nm, g.car_no, c.car_nm, d.car_name, f.nm as good_nm, a.pack_st, \n"+
				"        decode(b.o_1,b.car_amt+b.opt_amt+b.col_amt-b.dc_amt-nvl(b.tax_dc_amt,0),'1','0') car_gu, \n"+
				"        b.*, a.memo, a.seq, a.est_id \n"+
				" from   esti_pack a, "+est_table+" b, car_mng c, car_nm d, car_reg g, \n"+
				"        (select * from code where c_st='0001' and code<>'0000') e, \n"+
				"        (select * from code where c_st='0009' and code<>'0000') f \n"+
				" where  a.pack_id='"+pack_id+"' \n"+
				"        and a.est_id=b.est_id \n"+
				"        and b.car_comp_id=c.car_comp_id and b.car_cd=c.code \n"+
				"        and b.car_id=d.car_id and b.car_seq=d.car_seq \n"+
				"        and b.car_comp_id=e.code \n"+
				"        and b.a_a=f.nm_cd and b.mgr_nm=g.car_mng_id(+)  \n"+
				" ";

		if(est_table.equals("estimate")){

		query += " union all";
		query += " select e.nm as car_comp_nm, g.car_no, c.car_nm, d.car_name, f.nm as good_nm, a.pack_st, \n"+
				"        decode(b.o_1,b.car_amt+b.opt_amt+b.col_amt-b.dc_amt-nvl(b.tax_dc_amt,0),'1','0') car_gu, \n"+
				"        b.*, a.memo, a.seq, a.est_id \n"+
				" from   esti_pack a, estimate_cu b, car_mng c, car_nm d, car_reg g, \n"+
				"        (select * from code where c_st='0001' and code<>'0000') e, \n"+
				"        (select * from code where c_st='0009' and code<>'0000') f \n"+
				" where  a.pack_id='"+pack_id+"' \n"+
				"        and a.est_id=b.est_id \n"+
				"        and b.car_comp_id=c.car_comp_id and b.car_cd=c.code \n"+
				"        and b.car_id=d.car_id and b.car_seq=d.car_seq \n"+
				"        and b.car_comp_id=e.code \n"+
				"        and b.a_a=f.nm_cd and b.mgr_nm=g.car_mng_id(+)  \n"+
				" ";
		}

		query += " order by 1, 3, 4, 5";

//System.out.println("[EstiDatabase:getEstiPackList]"+query);

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
			System.out.println("[EstiDatabase:getEstiPackList]"+e);
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
     * 견적서관리 조회-리스트에서 //통합(estimate, estimate_hp, estimate_sh, estimate_cu)
     */
    public EstimateBean getEstimateAllCase(String est_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        EstimateBean bean = new EstimateBean();
        String query = "";
        
        query = " select * from estimate where est_id='"+est_id+"' union " + 
        		" select * from estimate_hp where est_id='"+est_id+"' union" +
        		" select * from estimate_sh where est_id='"+est_id+"' union" +
        		" select * from estimate_cu where est_id='"+est_id+"'";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
				bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setRo_13_amt(rs.getInt("RO_13_AMT"));
				bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setMgr_nm(rs.getString("MGR_NM"));
				bean.setMgr_ssn(rs.getString("MGR_SSN"));
				bean.setJob(rs.getString("JOB"));
				bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setLpg_kit(rs.getString("LPG_KIT"));
				bean.setEst_st(rs.getString("EST_ST"));
	            bean.setEst_from(rs.getString("EST_FROM"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setO_13(rs.getFloat("O_13"));
				bean.setUdt_st(rs.getString("UDT_ST"));
				bean.setAgree_dist(rs.getInt("AGREE_DIST"));
				bean.setOver_run_amt(rs.getInt("OVER_RUN_AMT"));
				bean.setOver_run_day(rs.getInt("OVER_RUN_DAY"));
				bean.setOver_serv_amt(rs.getInt("OVER_SERV_AMT"));
				bean.setCls_per(rs.getFloat("CLS_PER"));
				bean.setCtr_cls_per(rs.getFloat("CTR_CLS_PER"));
				bean.setCls_n_per(rs.getFloat("CLS_N_PER"));
				bean.setReg_code(rs.getString("REG_CODE"));
				bean.setRent_mng_id	(rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd	(rs.getString("RENT_L_CD"));
				bean.setRent_st		(rs.getString("RENT_ST"));
				bean.setIns_per		(rs.getString("INS_PER"));
				bean.setDoc_type	(rs.getString("DOC_TYPE")==null?"":rs.getString("DOC_TYPE"));
				bean.setVali_type	(rs.getString("VALI_TYPE")==null?"":rs.getString("VALI_TYPE"));
	            bean.setOpt_chk		(rs.getString("OPT_CHK")==null?"":rs.getString("OPT_CHK"));
				bean.setFee_opt_amt	(rs.getInt("FEE_OPT_AMT"));
				bean.setSet_code	(rs.getString("SET_CODE"));
				bean.setGi_per		(rs.getFloat("GI_PER"));
				bean.setEst_email	(rs.getString("est_email")==null?"":rs.getString("est_email"));
				bean.setCaroff_emp_yn(rs.getString("caroff_emp_yn")==null?"":rs.getString("caroff_emp_yn"));
				bean.setPrint_type	(rs.getString("print_type")==null?"":rs.getString("print_type"));
			    bean.setCtr_s_amt	(rs.getInt("CTR_S_AMT"));
				bean.setCtr_v_amt	(rs.getInt("CTR_V_AMT"));
				bean.setUse_yn		(rs.getString("USE_YN"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setB_agree_dist(rs.getInt("B_AGREE_DIST"));
				bean.setB_o_13		(rs.getFloat("B_O_13"));
				bean.setLoc_st		(rs.getString("LOC_ST")==null?"":rs.getString("LOC_ST"));
				bean.setTint_b_yn	(rs.getString("tint_b_yn")==null?"":rs.getString("tint_b_yn"));
				bean.setTint_s_yn	(rs.getString("tint_s_yn")==null?"":rs.getString("tint_s_yn"));
				bean.setTint_n_yn	(rs.getString("tint_n_yn")==null?"":rs.getString("tint_n_yn"));
				bean.setTint_bn_yn	(rs.getString("tint_bn_yn")==null?"":rs.getString("tint_bn_yn"));
				bean.setNew_license_plate  	(rs.getString("NEW_LICENSE_PLATE")==null?"":rs.getString("NEW_LICENSE_PLATE"));
				bean.setTint_cons_yn  	(rs.getString("TINT_CONS_YN")==null?"":rs.getString("TINT_CONS_YN"));
				bean.setTint_cons_amt	(rs.getInt("TINT_CONS_AMT"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setBus_yn		(rs.getString("bus_yn")==null?"":rs.getString("bus_yn"));
				bean.setBus_cau		(rs.getString("bus_cau")==null?"":rs.getString("bus_cau"));
				bean.setInsurant	(rs.getString("insurant")==null?"":rs.getString("insurant"));
				bean.setBus_cau_dt	(rs.getString("bus_cau_dt")==null?"":rs.getString("bus_cau_dt"));
				bean.setCha_st_dt	(rs.getString("cha_st_dt")==null?"":rs.getString("cha_st_dt"));
				bean.setB_dist		(rs.getInt("B_DIST"));
				bean.setJg_opt_st	(rs.getString("jg_opt_st")==null?"":rs.getString("jg_opt_st"));
				bean.setJg_col_st	(rs.getString("jg_col_st")==null?"":rs.getString("jg_col_st"));
				bean.setMax_use_mon	(rs.getString("MAX_USE_MON")==null?"":rs.getString("MAX_USE_MON"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setJg_tuix_st		(rs.getString("JG_TUIX_ST")==null?"":rs.getString("JG_TUIX_ST"));
				bean.setJg_tuix_opt_st	(rs.getString("JG_TUIX_OPT_ST")==null?"":rs.getString("JG_TUIX_OPT_ST"));
				bean.setDamdang_nm		(rs.getString("DAMDANG_NM")==null?"":rs.getString("DAMDANG_NM"));
				bean.setDamdang_m_tel	(rs.getString("DAMDANG_M_TEL")==null?"":rs.getString("DAMDANG_M_TEL"));
				bean.setBus_st			(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				bean.setCom_emp_yn		(rs.getString("COM_EMP_YN")==null?"":rs.getString("COM_EMP_YN"));
				bean.setTint_eb_yn		(rs.getString("tint_eb_yn")==null?"":rs.getString("tint_eb_yn"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				bean.setRtn_run_amt		(rs.getString("rtn_run_amt")		==null?0:Integer.parseInt(rs.getString("rtn_run_amt")));
				bean.setRtn_run_amt_yn		(rs.getString("rtn_run_amt_yn")==null?"":rs.getString("rtn_run_amt_yn"));
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
    
    /**
     * 심병호(개발자)
     * 2017-11-07
     * 영업관리 > 견적관리 > 신차견적서관리 > 하단 > 견적결과 > 견적서 > 보기 > 단산 차종인 경우 01 대여차량 하단에 단산 차량 관련 문구 추가를 위한 메서드
     */
    public String getEndDtEstimate(String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String result = "";
        
        query = " select end_dt from car_nm where car_id='"+car_id+"' and car_seq='"+car_seq+"'";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();

            if(rs.next()){
				result = rs.getString("end_dt")==null?"":rs.getString("end_dt");
            }

            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEndDtEstimate]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return result;
    }
    
    /**
	 *	견적 최근 or 스마트견적요청일 기준 30일이내 견적여부 (본인거 제외) (7) (2018.05.17)
	 */
	public Vector getEstimateCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel, String est_fax, String est_email, String reg_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		if(reg_dt.equals("")){	sub_query += " AND a.rent_dt >= TO_CHAR(sysdate-30,'YYYYMMDD') \n";		}
		else{					sub_query += " AND a.rent_dt >= TO_CHAR(TO_DATE('"+reg_dt+"','YYYYMMDD')-30,'YYYYMMDD') AND a.rent_dt <= TO_CHAR(TO_DATE('"+reg_dt+"','YYYYMMDD')+10,'YYYYMMDD')\n";		}
	
		query = " SELECT a.rent_dt, a.est_nm, a.reg_id, b.user_nm, b.user_m_tel, b.user_pos, a.reg_dt, \n"+
		        "  		 TO_CHAR(TO_DATE(a.reg_dt,'YYYYMMDDHH24MI'),'YYYY-MM-DD HH24:MI') as reg_dt2, \n	"+
				
		        "  		 DECODE(REPLACE(REPLACE(a.est_ssn,' ',''),'-',''),'','N',REPLACE(REPLACE('"+est_ssn+"',' ',''),'-',''),'Y','')AS ssn_yn, \n	"+
		        "  		 DECODE(REPLACE(REPLACE(a.est_tel,' ',''),'-',''),'','N',REPLACE(REPLACE('"+est_tel+"',' ',''),'-',''),'Y','')AS tel_yn, \n	"+
		        "  		 DECODE(REPLACE(REPLACE(a.est_fax,' ',''),'-',''),'','N',REPLACE(REPLACE('"+est_fax+"',' ',''),'-',''),'Y','')AS fax_yn, \n	"+
		        "  		 DECODE(REPLACE(REPLACE(a.est_email,' ',''),'-',''),'','N',REPLACE(REPLACE('"+est_email+"',' ',''),'-',''),'Y','')AS email_yn \n	"+
		        
				" FROM   ESTIMATE a, USERS b \n"+
				" WHERE  1=1 "+ sub_query +
				"		 AND a.fee_s_amt >0 \n"+
				"        AND a.reg_id=b.user_id  and nvl(a.use_yn,'Y')='Y' \n"+
		        "        and ( REPLACE(REPLACE(REPLACE(a.est_nm,' ',''),'(주)',''),'주식회사','') = REPLACE(REPLACE(REPLACE('"+est_nm+"',' ',''),'(주)',''),'주식회사','') \n"+
			    " ";

		if(!est_ssn.equals(""))		query +=" OR REPLACE(REPLACE(a.est_ssn,' ',''),'-','') = REPLACE(REPLACE('"+est_ssn+"',' ',''),'-','') ";
		if(!est_tel.equals(""))		query +=" OR REPLACE(REPLACE(a.est_tel,' ',''),'-','') = REPLACE(REPLACE('"+est_tel+"',' ',''),'-','') ";
		if(!est_fax.equals(""))		query +=" OR REPLACE(REPLACE(a.est_fax,' ',''),'-','') = REPLACE(REPLACE('"+est_fax+"',' ',''),'-','') ";
		if(!est_email.equals(""))	query +=" OR REPLACE(REPLACE(a.est_email,' ',''),'-','') = REPLACE(REPLACE('"+est_email+"',' ',''),'-','') ";

		query +=" ) ";


		if(gubun1.equals("1")) query += " and a.est_type='F' and nvl(a.job,'org')='org' ";
		if(gubun1.equals("2")) query += " and a.est_type='W'";
		if(gubun1.equals("3")) query += " and a.talk_tel is not null";	
		if(gubun1.equals("4")) query += " and a.est_type='M'";		
		if(gubun1.equals("5")) query += " and a.est_type='J'";		
		if(gubun1.equals("6")) query += " and a.est_type='L' and nvl(a.job,'org')='org'";		

		//재리스
		if(gubun1.equals("7")) query += " and a.est_type='S' and nvl(a.est_from,'car')<>'rm_car'";		

		query += " ORDER BY a.rent_dt desc, a.reg_dt desc, a.reg_code desc ";
		
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
			System.out.println("[EstiDatabase:getEstimateCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel, String est_fax, String est_email, String reg_dt)]"+e);
			System.out.println("[EstiDatabase:getEstimateCustEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel, String est_fax, String est_email, String reg_dt)]"+query);
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
	
	//재리스 견적 조회하기(기존소스 있으나 이메일 전송을 위해 따로 분리)(20180806)
	public Hashtable getEstimateSh(String est_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();		

		String query =  " SELECT * FROM ESTIMATE_SH WHERE EST_ID='"+est_id+"'";
						
		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiDatabase:getEstimateSh]"+e);
			System.out.println("[EstiDatabase:getEstimateSh]"+query);
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
     * 프로시져 호출
     */
    public String call_sp_esti_reg_ev(String reg_code, String jg_b_dt, String em_a_j, String ea_a_j, String est_table) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_ESTI_REG_EV     (?,?,?,?,?)}";


	    try{

			//신차잔가계산 프로시저 호출
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.setString(2, jg_b_dt);
			cstmt.setString(3, em_a_j);
			cstmt.setString(4, ea_a_j);
			cstmt.setString(5, est_table);
			cstmt.execute();

			cstmt.close();

        }catch(SQLException se){
			System.out.println("[EstiDatabase:call_sp_esti_reg_ev]"+se);
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
	 *	사전계약 여부 (본인거 제외)
	 */
	public Vector getEstimatePurPreEstCheck(String gubun1, String est_nm, String est_ssn, String est_tel, String est_fax, String est_email) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		query = " SELECT to_char(b.reg_dt,'YYYYMMDD') reg_dt, b.firm_nm, a.car_nm, b.memo, b.bus_nm, e.user_pos, e.user_m_tel  \n"+
				" FROM   car_pur_com_pre a, cont c, car_pur_com_pre_res b, (SELECT * FROM users WHERE use_yn='Y' AND (loan_st IS NOT NULL OR dept_id='1000')) e \n"+
				" WHERE  a.seq=b.seq and a.rent_l_cd=c.rent_l_cd(+) and a.use_yn='Y' AND c.dlv_dt IS NULL AND b.cls_dt IS NULL AND b.bus_nm=e.user_nm(+) \n"+
		        "        and ( REPLACE(REPLACE(REPLACE(b.firm_nm,' ',''),'(주)',''),'주식회사','') = REPLACE(REPLACE(REPLACE('"+est_nm+"',' ',''),'(주)',''),'주식회사','') \n"+
			    " ";

		if(!est_tel.equals(""))		query +=" OR REPLACE(REPLACE(b.cust_tel,' ',''),'-','') = REPLACE(REPLACE('"+est_tel+"',' ',''),'-','') ";

		query +=" ) ";

		query += " ORDER BY b.reg_dt desc ";

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
	//		System.out.println("[EstiDatabase:getEstimatePurPreEstCheck]"+query);
		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getEstimatePurPreEstCheck]"+e);
			System.out.println("[EstiDatabase:getEstimatePurPreEstCheck]"+query);
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
	 *	reg_code 견적리스트
	 */
	public Vector getEstiMateEstidCase(String est_id, String esti_table) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		if(esti_table.equals("estimate_hp")){

			query = " select 'estimate_hp' as t_st, t.est_nm as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate_hp t, esti_compare_hp p, esti_exam_hp x    "+
					" where   t.est_id='"+est_id+"' "+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
					" order by decode(t.mgr_ssn,'',0,1), t.est_id";	
			
		}else if(esti_table.equals("estimate_sh")){

			query = " select 'estimate_sh' as t_st, t.mgr_ssn as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate_sh t, esti_compare_sh p, esti_exam_sh x    "+
					" where   t.est_id='"+est_id+"' "+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
					"         and t.fee_s_amt>0 "+
					" order by t.est_id";			
		}else{

			query = " select 'estimate' as t_st, t.job as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate t, esti_compare p, esti_exam x    "+
					" where   t.est_id='"+est_id+"' "+
					"         and t.est_id=p.est_id and t.est_id=x.est_id "+
					" order by t.est_id";

		}

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
			System.out.println("[EstiDatabase:getEstiMateEstidCase(String est_id)]"+e);
			System.out.println("[EstiDatabase:getEstiMateEstidCase(String est_id)]"+query);
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
     * 연장 견적관리 전체조회
     */
    public EstimateBean [] getEstimateFmsExtList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_no, b.car_nm, c.car_name, "+
				"        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','연장계약','S','재리스차량') est_gubun, "+
				"        decode(a.fee_s_amt,'0','견적중지','견적') est_check, e.user_nm as reg_nm "+
				" from   estimate a, car_reg b, car_nm c, users e "+
				" where  ";

		
		if(gubun4.equals("1")) query += " a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' ";
		if(gubun4.equals("4")) query += " a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("3")) query += " a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
		if(gubun4.equals("5")) query += " a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";


		query += "        and a.est_type = 'L' and a.est_from='lc_renew' and a.est_st='2' and a.mgr_ssn='연장견적' "+
				"         and a.mgr_nm=b.car_mng_id and a.car_id=c.car_id and a.car_seq=c.car_seq "+
				"         and a.reg_id=e.user_id  "+
				" ";

		if(gubun1.equals("7")) query += " and nvl(a.use_yn,'Y')='Y'";		
		if(gubun1.equals("9")) query += " and nvl(a.use_yn,'Y')='N'";		

		if(!gubun2.equals("")) query += " and a.a_a like '"+gubun2+"%'";
		if(!gubun3.equals("")) query += " and a.a_a like '%"+gubun3+"'";
		

		if(!gubun5.equals("")) query += " and e.user_nm = '"+gubun5+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("2")) query += " and b.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("5")) query += " and a.est_id = '"+t_wd+"'";
			if(s_kd.equals("6")) query += " and replace(a.est_ssn,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("7")) query += " and replace(a.est_tel||a.est_fax,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
		}


		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setEst_gubun(rs.getString("est_gubun"));
		        bean.setMgr_nm(rs.getString("CAR_NO"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setEst_check(rs.getString("EST_CHECK"));
				bean.setReg_nm(rs.getString("reg_nm"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));
				bean.setRent_dt			(rs.getString("rent_dt")==null?"":rs.getString("rent_dt"));

				col.add(bean);
            }
            rs.close();
            pstmt.close();
            
			
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateFmsExtList]"+se);
			System.out.println("[EstiDatabase:getEstimateFmsExtList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }
    
    // 견적등록 코드가져오기 20191021
    public String getEst_id(String rent_l_cd) throws DatabaseException, DataSourceEmptyException {
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String est_id = "";
		String query = "";

		query = " SELECT est_id FROM estimate WHERE rent_l_cd='" + rent_l_cd + "' AND JOB = 'org' " + // --AND JOB = 'org' 
                	" UNION " +
                	" SELECT est_id FROM estimate_cu WHERE rent_l_cd='" + rent_l_cd + "' AND JOB = 'org' " ;//--AND JOB = 'org';    1555378007587

		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){				
				est_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
            pstmt.close();

		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getEst_id]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return est_id;
	}

    /**
	 *	견적변수일자리스트
	 */
	public Vector getEstiBaseDtList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " SELECT 'em' AS st, a_j AS b_dt FROM esti_comm_var GROUP BY a_j\r\n" + 
        		"UNION all\r\n" + 
        		"SELECT 'ea' AS st, a_j AS b_dt FROM esti_car_var GROUP BY a_j\r\n" + 
        		"UNION all\r\n" + 
        		"SELECT 'ej' AS st, reg_dt AS b_dt FROM esti_jg_var GROUP BY reg_dt\r\n" + 
        		"ORDER BY 2 DESC  ";


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
			System.out.println("[EstiDatabase:getEstiBaseDtList]"+e);
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
     * 견적관리 전체조회
     */
    public EstimateBean [] getEstimateRentDcList(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null; 
        String query = "";
        
		query = " select a.*, b.car_nm, c.car_name, \r\n" + 
				"				        decode(a.est_type,'F','FMS','W','홈페이지','M','고객FMS','J','주요차종','L','장기대여','S','재리스차량') est_gubun, \r\n" + 
				"				        decode(f.a_g,'','견적중지','견적') est_check, e.user_nm as reg_nm \r\n" + 
				"				 from   cont d, car_etc g, estimate a, car_mng b, car_nm c, esti_exam f, users e, fee h \r\n" + 
				"				 WHERE  d.rent_mng_id='"+rent_mng_id+"' and d.rent_l_cd='"+rent_l_cd+"' \r\n" + 
				"         AND d.rent_mng_id=g.rent_mng_id AND d.rent_l_cd=g.rent_l_cd\r\n" + 
				"         AND g.car_id=a.car_id AND g.car_seq=a.car_seq\r\n" + 
				"         AND g.car_id=c.car_id AND g.car_seq=c.car_seq\r\n" + 
				"         AND a.car_comp_id=b.car_comp_id AND a.car_cd=b.code\r\n" + 
				"         AND a.EST_ID=f.est_id\r\n" + 
				"         AND a.reg_id=e.user_id \r\n" + 
				"         AND d.rent_mng_id=h.rent_mng_id AND d.rent_l_cd=h.rent_l_cd and h.rent_st='1' \r\n" +				
				"         AND a.reg_dt BETWEEN TO_CHAR(TO_DATE(d.rent_dt,'YYYYMMDD')-30,'YYYYMMDD') AND TO_CHAR(TO_DATE(d.rent_dt,'YYYYMMDD')+10,'YYYYMMDD')\r\n" + 
				"         AND d.BUS_ID=a.reg_id "+
				"         and h.con_mon=a.a_b "+
				"         and a.rg_8_amt=h.grt_amt_s "+
				"         AND a.rent_l_cd IS NULL AND a.job='org' \r\n" + 
				"         ORDER BY a.reg_dt  ";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
	            bean.setRg_8_amt(rs.getInt("RG_8_AMT"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
				bean.setO_11(rs.getFloat("O_11"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
		        bean.setRent_dt(rs.getString("RENT_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setEst_gubun(rs.getString("est_gubun"));
				bean.setSet_code(rs.getString("set_code"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setEst_check(rs.getString("est_check"));
				bean.setPrint_type(rs.getString("print_type"));
			    bean.setCtr_s_amt(rs.getString("CTR_S_AMT")==null?0:Integer.parseInt(rs.getString("CTR_S_AMT")));
				bean.setCtr_v_amt(rs.getString("CTR_V_AMT")==null?0:Integer.parseInt(rs.getString("CTR_V_AMT")));
				bean.setUse_yn(rs.getString("use_yn"));
				bean.setMgr_nm(rs.getString("mgr_nm"));
		        bean.setReg_nm(rs.getString("reg_nm"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setDamdang_nm		(rs.getString("damdang_nm")==null?"":rs.getString("damdang_nm"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));


				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateRentDcList]"+se);
			System.out.println("[EstiDatabase:getEstimateRentDcList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }	
    
    /**
     * 출고대차 견적관리 전체조회
     */
    public EstimateBean [] getEstimateTaeList(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_dt, String e_dt, String s_kd, String t_wd, String esti_m, String esti_m_dt, String esti_m_s_dt, String esti_m_e_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = " select a.*, b.car_no, b.car_nm, c.car_name, e.user_id as m_user_id, e.reg_dt as m_reg_dt,"+
				" '출고전대차' est_gubun"+
				" from estimate a, car_reg b, car_nm c, (select est_id, max(seq_no) seq_no from esti_m group by est_id) d, esti_m e"+
				" where a.est_from = 'tae_car' and a.mgr_nm=b.car_mng_id and nvl(a.use_yn,'Y')='Y'"+
				" and a.car_id=c.car_id and a.car_seq=c.car_seq "+
				" and a.est_id=d.est_id(+) and d.est_id=e.est_id(+) and d.seq_no=e.seq_no(+)"+
				" ";

		if(gubun4.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun4.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun4.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
		if(gubun4.equals("4")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun4.equals("5")) query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		

		if(!gubun5.equals("")) query += " and a.reg_id = '"+gubun5+"'";
		if(!gubun6.equals("")) query += " and e.user_id = '"+gubun6+"'";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and b.car_nm||c.car_name like '%"+t_wd+"%'";
			if(s_kd.equals("2")) query += " and b.car_no like '%"+t_wd+"%'";
			if(s_kd.equals("3")) query += " and a.est_nm like '%"+t_wd+"%'";
			if(s_kd.equals("5")) query += " and a.est_id = '"+t_wd+"'";
			if(s_kd.equals("6")) query += " and replace(a.est_ssn,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("7")) query += " and replace(a.est_tel||a.est_fax,'-','') like replace('%"+t_wd+"%','-','')";
			if(s_kd.equals("8")) query += " and a.est_email like '%"+t_wd+"%'";
		}

		if(esti_m.equals("1"))		query += " and e.user_id is not null ";
		else if(esti_m.equals("2"))	query += " and e.user_id is null ";


		if(esti_m_dt.equals("1"))		query += " and e.reg_dt like to_char(sysdate,'YYYYMM')||'%' ";
		else if(esti_m_dt.equals("2"))	query += " and e.reg_dt like to_char(sysdate,'YYYYMMDD')||'%' ";
		else if(esti_m_dt.equals("3"))	query += " and e.reg_dt between replace('"+esti_m_s_dt+"','-','') and replace('"+esti_m_e_dt+"','-','') ";

		query += " order by a.est_id desc";


        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            while(rs.next()){
				EstimateBean bean = new EstimateBean();
				bean.setEst_id(rs.getString("EST_ID"));
	            bean.setEst_nm(rs.getString("EST_NM"));
		        bean.setEst_ssn(rs.getString("EST_SSN"));
			    bean.setEst_tel(rs.getString("EST_TEL"));
				bean.setEst_fax(rs.getString("EST_FAX"));
	            bean.setCar_comp_id(rs.getString("CAR_COMP_ID"));
		        bean.setCar_cd(rs.getString("CAR_CD"));
			    bean.setCar_id(rs.getString("CAR_ID"));
				bean.setCar_seq(rs.getString("CAR_SEQ"));
	            bean.setCar_amt(rs.getInt("CAR_AMT"));
		        bean.setOpt(rs.getString("OPT"));
			    bean.setOpt_seq(rs.getString("OPT_SEQ"));
	            bean.setOpt_amt(rs.getInt("OPT_AMT"));
		        bean.setCol(rs.getString("COL"));
			    bean.setCol_seq(rs.getString("COL_SEQ"));
				bean.setCol_amt(rs.getInt("COL_AMT"));
	            bean.setDc(rs.getString("DC"));
		        bean.setDc_seq(rs.getString("DC_SEQ"));
			    bean.setDc_amt(rs.getInt("DC_AMT"));
	            bean.setO_1(rs.getInt("O_1"));
		        bean.setA_a(rs.getString("A_A"));
			    bean.setA_b(rs.getString("A_B"));
	            bean.setA_h(rs.getString("A_H"));
		        bean.setPp_st(rs.getString("PP_ST"));
			    bean.setPp_amt(rs.getInt("PP_AMT"));
			    bean.setPp_per(rs.getInt("PP_PER"));
	            bean.setRg_8(rs.getFloat("RG_8"));
		        bean.setIns_age(rs.getString("INS_AGE"));
			    bean.setIns_dj(rs.getString("INS_DJ"));
				bean.setRo_13(rs.getFloat("RO_13"));
				bean.setG_10(rs.getInt("G_10"));
		        bean.setGi_amt(rs.getInt("GI_AMT"));
			    bean.setGi_fee(rs.getInt("GI_FEE"));
	            bean.setGtr_amt(rs.getInt("GTR_AMT"));
		        bean.setPp_s_amt(rs.getInt("PP_S_AMT"));
				bean.setPp_v_amt(rs.getInt("PP_V_AMT"));
	            bean.setIfee_s_amt(rs.getInt("IFEE_S_AMT"));
		        bean.setIfee_v_amt(rs.getInt("IFEE_V_AMT"));
			    bean.setFee_s_amt(rs.getInt("FEE_S_AMT"));
				bean.setFee_v_amt(rs.getInt("FEE_V_AMT"));
				bean.setIns_good(rs.getString("INS_GOOD"));
		        bean.setReg_id(rs.getString("REG_ID"));
		        bean.setReg_dt(rs.getString("REG_DT"));
				bean.setCar_ja(rs.getInt("CAR_JA"));
		        bean.setLpg_yn(rs.getString("LPG_YN"));
		        bean.setGi_yn(rs.getString("GI_YN"));
		        bean.setCar_nm(rs.getString("CAR_NM"));
		        bean.setCar_name(rs.getString("CAR_NAME"));
		        bean.setTalk_tel(rs.getString("TALK_TEL"));
				bean.setFee_dc_per(rs.getString("FEE_DC_PER")==null?0:AddUtil.parseFloat(rs.getString("FEE_DC_PER")));
		        bean.setM_user_id(rs.getString("m_user_id"));
		        bean.setM_reg_dt(rs.getString("m_reg_dt"));
		        bean.setEst_gubun(rs.getString("est_gubun"));
		        bean.setMgr_nm(rs.getString("CAR_NO"));
				bean.setToday_dist(rs.getInt("TODAY_DIST"));
				bean.setEst_email(rs.getString("EST_EMAIL"));
				bean.setCompare_yn  (rs.getString("compare_yn")==null?"":rs.getString("compare_yn"));
				bean.setIn_col		(rs.getString("in_col")==null?"":rs.getString("in_col"));
				bean.setSpr_yn(rs.getString("SPR_YN"));
				bean.setTax_dc_amt		(rs.getString("TAX_DC_AMT")==null?0:Integer.parseInt(rs.getString("TAX_DC_AMT")));
				bean.setEcar_loc_st		(rs.getString("ECAR_LOC_ST")==null?"":rs.getString("ECAR_LOC_ST"));
				bean.setEco_e_tag			(rs.getString("ECO_E_TAG")==null?"":rs.getString("ECO_E_TAG"));
				bean.setEcar_pur_sub_amt(rs.getString("ECAR_PUR_SUB_AMT")==null?0:Integer.parseInt(rs.getString("ECAR_PUR_SUB_AMT")));
				bean.setEcar_pur_sub_st	(rs.getString("ECAR_PUR_SUB_ST")==null?"":rs.getString("ECAR_PUR_SUB_ST"));
				bean.setConti_rat		(rs.getString("CONTI_RAT")==null?"":rs.getString("CONTI_RAT"));
				bean.setDriver_add_amt	(rs.getString("DRIVER_ADD_AMT")==null?0:Integer.parseInt(rs.getString("DRIVER_ADD_AMT")));
				bean.setPp_ment_yn		(rs.getString("PP_MENT_YN")==null?"N":rs.getString("PP_MENT_YN"));
				bean.setTot_dt			(rs.getString("TOT_DT")==null?"":rs.getString("TOT_DT"));
				bean.setReturn_select	(rs.getString("return_select")==null?"":rs.getString("return_select"));
				bean.setHcar_loc_st		(rs.getString("hcar_loc_st")==null?"":rs.getString("hcar_loc_st"));
				bean.setLkas_yn			(rs.getString("lkas_yn")==null?"":rs.getString("lkas_yn"));
				bean.setLdws_yn			(rs.getString("ldws_yn")==null?"":rs.getString("ldws_yn"));
				bean.setAeb_yn			(rs.getString("aeb_yn")==null?"":rs.getString("aeb_yn"));
				bean.setFcw_yn			(rs.getString("fcw_yn")==null?"":rs.getString("fcw_yn"));
				bean.setHook_yn			(rs.getString("hook_yn")==null?"":rs.getString("hook_yn"));

				col.add(bean);
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[EstiDatabase:getEstimateTaeList]"+se);
			System.out.println("[EstiDatabase:getEstimateTaeList]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (EstimateBean[])col.toArray(new EstimateBean[0]);
    }

    /**
	 *	reg_code 견적리스트
	 */
	public Vector getEstiMateResultOfflsCaramtList(String car_mng_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = " select 'estimate' as t_st, t.job as gubun, t.est_id as r_est_id, t.*, p.*, x.* "+
					" from    estimate t, esti_compare p, esti_exam x    "+
					" where   t.mgr_nm='"+car_mng_id+"' and est_from='off_ls' "+
					"         and t.est_id=p.est_id(+) and t.est_id=x.est_id(+) order by t.reg_dt ";


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
			System.out.println("[EstiDatabase:getEstiMateResultOfflsCaramtList]"+e);
			System.out.println("[EstiDatabase:getEstiMateResultOfflsCaramtList]"+query);
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
	
	public Vector getEstiJgVarCarList(String car_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from esti_jg_var b "+
				" where cars like '%"+car_nm+"%' AND jg_13='1' and reg_dt = (select max(reg_dt) from esti_jg_var) "+
				" order by sh_code, seq ";

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
			System.out.println("[EstiDatabase:getEstiJgVarCarList(String car_comp_id, String car_nm)]"+e);
			System.out.println("[EstiDatabase:getEstiJgVarCarList(String car_comp_id, String car_nm)]"+query);
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
	
	public Vector getEstiJgVarCarAllList(String car_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from esti_jg_var b "+
				" where cars like '%"+car_nm+"%' and reg_dt = (select max(reg_dt) from esti_jg_var) "+
				" order by sh_code, seq ";

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
			System.out.println("[EstiDatabase:getEstiJgVarCarAllList(String car_comp_id, String car_nm)]"+e);
			System.out.println("[EstiDatabase:getEstiJgVarCarAllList(String car_comp_id, String car_nm)]"+query);
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
	 *	출고전대차 견적관리 전체조회
	 */
	public Vector getEstimateTaeCarContList(String car_mng_id, String st_dt) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "SELECT '출고지연' st, est_id, rent_dt, rent_l_cd, today_dist, agree_dist, o_1, gtr_amt, (pp_s_amt+pp_v_amt) pp_amt, (ifee_s_amt+ifee_v_amt) ifee_amt, car_ja, fee_s_amt, fee_v_amt, (fee_s_amt+fee_v_amt) fee_amt, nvl(tae_rent_fee_cls,0) tae_rent_fee_cls \r\n" + 
				"FROM estimate WHERE mgr_nm='"+car_mng_id+"' AND est_from='tae_car' "+
				"     AND rent_dt BETWEEN to_char(to_date('"+st_dt+"','YYYYMMDD')-20,'YYYYMMDD') and to_char(to_date('"+st_dt+"','YYYYMMDD')+10,'YYYYMMDD')\r\n" + 
				"ORDER BY 2";

		
		
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
			System.out.println("[EstiDatabase:getEstimateTaeCarContList(String table_st, String car_mng_id)]"+e);
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
	
    public int getMainCarCnt(String est_tel) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        int esti_chk = 0;
        
		query = " SELECT COUNT(0) from estimate_hp where  est_tel='"+est_tel+"' AND nvl(est_ssn,'Y')='Y' AND job='org' and est_type='J' ";
				   
       try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())	esti_chk = rs.getInt(1);
            rs.close();
      		stmt.close();
		}catch(SQLException se){
            System.out.println("[EstiDatabase:getLpg_amt]"+se);
            throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return esti_chk;
    }
	
    /**
     * 신차개시후 약정운행거리 변경 계산횟수
     */
    public int getNewCarRentEstiReCnt(String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
        ResultSet rs = null;
        String query = "";
		int cnt = 0;
		   
		query = " select count(0) from estimate where rent_l_cd='"+rent_l_cd+"' and rent_st='1' and est_from='lc_b_u_re' and job='org' and reg_dt >= '20210601' ";

	   try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	cnt = rs.getInt(1);
            rs.close();
      		stmt.close();

		}catch(SQLException se){
			System.out.println("[EstiDatabase:getNewCarRentEstiReCnt]"+se);
             throw new DatabaseException();
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return cnt;
    }
    
	/**
	 *	기존견적고객조회
	 */
	public Vector getLcCustSprSubList(String car_gu, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.rent_dt, b.spr_kd, a.client_id, a.firm_nm as est_nm, nvl(a.enp_no,substr(TEXT_DECRYPT(a.ssn, 'pw' ),1,7)) as est_ssn, a.o_tel as est_tel, a.fax as est_fax, a.reg_dt, decode(a.client_st,'1','1','2','3','2') doc_type, a.con_agnt_email AS est_email \n"+
				" from   client a, \n"+
				"        cont b, (SELECT client_id, MAX(rent_mng_id) rent_mng_id FROM cont WHERE car_st IN ('1','3') AND car_gu='"+car_gu+"' GROUP BY client_id) c \n"+
				" where  "+
				"        ( REPLACE(REPLACE(REPLACE(a.firm_nm||a.client_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+t_wd+"%',' ',''),'(주)',''),'주식회사','') \n"+
				"          OR a.enp_no||TEXT_DECRYPT(a.ssn, 'pw' ) like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(a.o_tel||a.m_tel,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(a.fax,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(a.con_agnt_email,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				"        ) "+
				"        and a.client_id=b.client_id and b.client_id=c.client_id AND b.rent_mng_id=c.rent_mng_id "+
				" order by a.firm_nm";


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
			System.out.println("[EstiDatabase:getLcCustSprSubList]"+e);
			System.out.println("[EstiDatabase:getLcCustSprSubList]"+query);
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
	 *	기존견적고객조회
	 */
	public Hashtable getLcCustSprSubCase(String car_gu, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select b.rent_dt, b.spr_kd, a.client_id, a.firm_nm as est_nm, nvl(a.enp_no,substr(TEXT_DECRYPT(a.ssn, 'pw' ),1,7)) as est_ssn, a.o_tel as est_tel, a.fax as est_fax, a.reg_dt, decode(a.client_st,'1','1','2','3','2') doc_type, a.con_agnt_email AS est_email \n"+
				" from   client a, \n"+
				"        cont b, (SELECT client_id, MAX(rent_mng_id) rent_mng_id FROM cont WHERE car_st IN ('1','3') AND car_gu='"+car_gu+"' GROUP BY client_id) c \n"+
				" where  "+
				"        a.client_id='"+t_wd+"' and a.client_id=b.client_id and b.client_id=c.client_id AND b.rent_mng_id=c.rent_mng_id "+
				" order by a.firm_nm";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiDatabase:getLcCustSprSubCase]"+e);
			System.out.println("[EstiDatabase:getLcCustSprSubCase]"+query);
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
	 *	기존견적고객조회
	 */
	public Vector getLcCustSprSubList(String car_gu, String t_wd, String ck_acar_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.rent_dt, b.spr_kd, a.client_id, a.firm_nm as est_nm, nvl(a.enp_no,substr(TEXT_DECRYPT(a.ssn, 'pw' ),1,7)) as est_ssn, a.o_tel as est_tel, a.fax as est_fax, a.reg_dt, decode(a.client_st,'1','1','2','3','2') doc_type, a.con_agnt_email AS est_email \n"+
				" from   client a, \n"+
				"        cont b, (SELECT client_id, MAX(rent_mng_id) rent_mng_id FROM cont WHERE use_yn='Y' and car_st IN ('1','3') AND car_gu='"+car_gu+"' GROUP BY client_id) c \n"+
				" where  a.client_id in (select client_id from cont where bus_id='"+ck_acar_id+"' group by client_id) "+
				"        and ( REPLACE(REPLACE(REPLACE(a.firm_nm||a.client_nm,' ',''),'(주)',''),'주식회사','') like REPLACE(REPLACE(REPLACE('%"+t_wd+"%',' ',''),'(주)',''),'주식회사','') \n"+
				"          OR a.enp_no||TEXT_DECRYPT(a.ssn, 'pw' ) like REPLACE(REPLACE('%"+t_wd+"%',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(a.o_tel||a.m_tel,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(a.fax,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				"          OR REPLACE(REPLACE(a.con_agnt_email,' ',''),'-','') = REPLACE(REPLACE('"+t_wd+"',' ',''),'-','') "+
				"        ) "+
				"        and a.client_id=b.client_id(+) and b.client_id=c.client_id(+) and b.rent_mng_id=c.rent_mng_id(+) "+
				" order by a.firm_nm";
		
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
			System.out.println("[EstiDatabase:getLcCustSprSubList]"+e);
			System.out.println("[EstiDatabase:getLcCustSprSubList]"+query);
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
	 *	견적점검리스트
	 */
	public Vector getEstimateAllList(String gubun1, String gubun2, String gubun3, String s_dt, String e_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select '1' st, a.reg_dt b_dt, a.*, b.car_no, b.car_nm, c.car_name "+
				" from estimate a, car_reg b, car_nm c, cont d, car_reg e, users f "+
				" where 1=1 ";

		if(gubun1.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun1.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		if(gubun1.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
		if(gubun1.equals("4")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
		if(gubun1.equals("5")) query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		if(gubun1.equals("6")) query += " and a.reg_dt like to_char(sysdate,'YYYY')||'%'";
		
		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and (b.car_no   = '"+t_wd+"' or e.car_no='"+t_wd+"')";
			if(s_kd.equals("2")) query += " and a.rent_l_cd = '"+t_wd+"'";
			if(s_kd.equals("3")) query += " and a.est_id    = '"+t_wd+"'";
			if(s_kd.equals("4")) query += " and f.user_nm    = '"+t_wd+"'";
		}

		query +=" and a.mgr_nm=b.car_mng_id(+) and (b.car_no is not null or a.job='org') "+
				" and a.car_id=c.car_id and a.car_seq=c.car_seq and a.rent_l_cd=d.rent_l_cd(+) and d.car_mng_id=e.car_mng_id(+) and a.reg_id=f.user_id "+				
				" ";
		
		if(gubun2.equals("Y")) {
			query += " union all "+
					" select '2' st, a.reg_dt b_dt, a.*, b.car_no, b.car_nm, c.car_name "+
					" from estimate_sh a, car_reg b, car_nm c "+
					" where 1=1 ";

			if(gubun1.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun1.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			if(gubun1.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
			if(gubun1.equals("4")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
			if(gubun1.equals("5")) query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
			if(gubun1.equals("6")) query += " and a.reg_dt like to_char(sysdate,'YYYY')||'%'";
			
			if(!t_wd.equals("")){
				if(s_kd.equals("1")) query += " and b.car_no   = '"+t_wd+"' ";
				if(s_kd.equals("3")) query += " and a.est_id    = '"+t_wd+"'";
			}

			query +=" and a.mgr_nm=b.car_mng_id "+
					" and a.car_id=c.car_id and a.car_seq=c.car_seq "+				
					" ";			
		}
		
		if(gubun3.equals("Y")) {
			query += " union all "+
					" select '3' st, a.reg_dt b_dt, a.*, b.car_no, b.car_nm, c.car_name "+
					" from estimate_cu a, car_reg b, car_nm c "+
					" where 1=1 ";

			if(gubun1.equals("1")) query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'";
			if(gubun1.equals("2")) query += " and a.reg_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			if(gubun1.equals("3")) query += " and a.reg_dt between replace('"+s_dt+"','-','') and replace('"+e_dt+"','-','')";
			if(gubun1.equals("4")) query += " and a.reg_dt like to_char(sysdate-1,'YYYYMMDD')||'%'";
			if(gubun1.equals("5")) query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
			if(gubun1.equals("6")) query += " and a.reg_dt like to_char(sysdate,'YYYY')||'%'";
			
			if(!t_wd.equals("")){
				if(s_kd.equals("1")) query += " and b.car_no   = '"+t_wd+"' ";
				if(s_kd.equals("3")) query += " and a.est_id    = '"+t_wd+"'";
			}

			query +=" and a.mgr_nm=b.car_mng_id "+
					" and a.car_id=c.car_id and a.car_seq=c.car_seq "+				
					" ";			
		}		

		query += " order by 2";
		
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
			System.out.println("[EstiDatabase:getEstimateAllList]"+e);
			System.out.println("[EstiDatabase:getEstimateAllList]"+query);
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
	 *	reg_code 견적리스트
	 */
	public Hashtable getEstiMateSelectResult(String est_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select  '1' st, t.est_nm as gubun, t.est_id as r_est_id, t.*, p.*, x.*, a.jg_code "+
				" from    estimate t, esti_compare p, esti_exam x, car_nm a    "+
				" where   t.est_id='"+est_id+"' "+
				"         and t.est_id=p.est_id(+) and t.est_id=x.est_id(+) and t.car_id=a.car_id and t.car_seq=a.car_seq ";


		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiDatabase:getEstiMateSelectResult(String est_id)]"+e);
			System.out.println("[EstiDatabase:getEstiMateSelectResult(String est_id)]"+query);
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
	
	public Hashtable getEstiMateSelectResultSh(String est_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select  '2' st, t.est_nm as gubun, t.est_id as r_est_id, t.*, p.*, x.*, a.jg_code "+
				" from    estimate_sh t, esti_compare_sh p, esti_exam_sh x, car_nm a    "+
				" where   t.est_id='"+est_id+"' "+
				"         and t.est_id=p.est_id(+) and t.est_id=x.est_id(+) and t.car_id=a.car_id and t.car_seq=a.car_seq ";

		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiDatabase:getEstiMateSelectResultSh(String est_id)]"+e);
			System.out.println("[EstiDatabase:getEstiMateSelectResultSh(String est_id)]"+query);
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
	
	public Hashtable getEstiMateSelectResultCu(String est_id) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select  '3' st, t.est_nm as gubun, t.est_id as r_est_id, t.*, p.*, x.*, a.jg_code "+
				" from    estimate_cu t, esti_compare_cu p, esti_exam_cu x, car_nm a    "+
				" where   t.est_id='"+est_id+"' "+
				"         and t.est_id=p.est_id(+) and t.est_id=x.est_id(+) and t.car_id=a.car_id and t.car_seq=a.car_seq ";

		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[EstiDatabase:getEstiMateSelectResultCu(String est_id)]"+e);
			System.out.println("[EstiDatabase:getEstiMateSelectResultCu(String est_id)]"+query);
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
	
	public int updateOffDemandVar(String save_dt, String var_id, String var_nm, String var_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE stat_rent_month_var SET"+
				" var_cd=? "+
				" WHERE save_dt=? AND var_id=? \n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query); 
            if(var_id.equals("demand_sc2.s_amt")) {
            	pstmt.setString(1, AddUtil.replace(var_cd, ",", "").trim());
            }else {
            	pstmt.setString(1, var_cd.trim());
            }            
            pstmt.setString(2, save_dt.trim());
			pstmt.setString(3, var_id.trim());
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:updateOffDemandVar]"+se);
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
	
	public int insertOffDemandVar(String save_dt, String var_id, String var_nm, String var_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " insert into stat_rent_month_var (save_dt, var_id, var_nm, var_cd) VALUES (replace(?,'-',''), ?, ?, ?) ";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, save_dt.trim());
            pstmt.setString(2, var_id.trim());
            pstmt.setString(3, var_nm.trim());
            if(var_id.equals("demand_sc2.s_amt")) {
            	pstmt.setString(4, AddUtil.replace(var_cd, ",", "").trim());
            }else {
            	pstmt.setString(4, var_cd.trim());
            }	
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[EstiDatabase:insertOffDemandVar]"+se);
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
	
	// 정부 보조금 조회
	public String getBk_128(String car_id, String car_seq) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String bk_128 = "";

		String query =  " SELECT c.BK_128 FROM car_nm a, estimate b, esti_exam c " +
							"	WHERE a.car_id = b.car_id AND a.car_seq = b.car_seq AND b.est_id = c.est_id " +
							"	AND a.car_id = " + car_id + " AND a.car_seq = " + car_seq + " ";	


		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{				
				bk_128 = rs.getString(1) == null ? "" : rs.getString(1);
			}
			rs.close();
            pstmt.close();



		} catch (SQLException e) {
			System.out.println("[EstiDatabase:getBk_128]"+e);
			System.out.println("[EstiDatabase:getBk_128]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return bk_128;
	}
	
	
}
