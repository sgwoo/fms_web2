package acar.mng_exp;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;

public class GenExpDatabase
{
	private Connection conn = null;
	public static GenExpDatabase db;
	
	public static GenExpDatabase getInstance()
	{
		if(GenExpDatabase.db == null)
			GenExpDatabase.db = new GenExpDatabase();
		return GenExpDatabase.db;
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("acar");				
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
	
	//지출현황-----------------------------------------------------------------------------------------------


	//기타비용 납부 리스트 조회 : exp_sc_in.jsp
	public Vector getExpList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "a.est_dt";

		query = " select  "+
				"        b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.use_yn,  b.firm_nm, c.car_no, c.car_nm, cn.car_name, e.migr_dt, c.init_reg_dt,"+
				"        a.exp_st, decode(a.exp_st,'0','자동차등록비','9','취득세','8','할부비용','7','설정비용','6','말소비용','1','검사비','2','환경개선부담금','3','자동차세') gubun,"+
				"        a.amt, decode(a.pay_dt, '','0','1') pay_yn, "+
				"        DECODE(a.est_dt,'','',SUBSTR(a.est_dt,1,4)||'-'||SUBSTR(a.est_dt,5,2)||'-'||SUBSTR(a.est_dt,7,2)) as est_dt,"+
				"        DECODE(a.pay_dt,'','',SUBSTR(a.est_dt,1,4)||'-'||SUBSTR(a.pay_dt,5,2)||'-'||SUBSTR(a.pay_dt,7,2)) as pay_dt"+
				" from   exp_view a, cont_n_view b, sui e,  car_reg c,  car_etc g, car_nm cn, code d \n"+
				" where  d.c_st = '0032' and a.car_mng_id=b.car_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=e.car_mng_id(+)"+
				"	and a.car_mng_id = c.car_mng_id  and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) and c.car_ext = d.nm_cd ";
				

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.pay_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and "+est_dt+" like to_char(sysdate,'YYYYMM')||'%' and a.pay_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+est_dt+" = to_char(sysdate,'YYYYMMDD') and a.pay_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and "+est_dt+" <= to_char(sysdate,'YYYYMMDD')";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and "+est_dt+" <= to_char(sysdate,'YYYYMMDD') and a.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+est_dt+" <= to_char(sysdate,'YYYYMMDD') and a.pay_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and "+est_dt+" < to_char(sysdate,'YYYYMMDD')";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and "+est_dt+" < to_char(sysdate,'YYYYMMDD') and a.pay_dt = to_char(sysdate,'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+est_dt+" < to_char(sysdate,'YYYYMMDD') and a.pay_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+est_dt+" BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.pay_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','') and a.pay_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+est_dt+" BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','') and a.pay_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.pay_dt is not null";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.pay_dt is null";
		}
	
		if(!gubun4.equals(""))		query += " and a.exp_st='"+gubun4+"'";
		
		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and nvl(a.amt, 0) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.car_ext, '')||d.nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("99"))	query += " and b.car_mng_id = '"+t_wd+"'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.exp_st "+sort+", a.est_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.est_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.est_dt "+sort+", a.exp_st, b.firm_nm";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.amt "+sort+", a.exp_st, b.firm_nm";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, c.car_no "+sort+", b.firm_nm";		

		

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[GenExpDatabase:getExpList]"+ e);
			System.out.println("[GenExpDatabase:getExpList]"+ query);
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
	 *	일반지출 INSERT
	 */

	public boolean insertGenExp(GenExpBean exp)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into GEN_EXP (EXP_ST, CAR_MNG_ID, EXP_ETC, EXP_AMT, EXP_EST_DT, EXP_DT, EXP_START_DT, EXP_END_DT, CAR_EXT, CAR_NO) values"+
						" (?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), ?, ?)";
						
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  exp.getExp_st().trim()		);
			pstmt.setString(2,  exp.getCar_mng_id().trim()	);
			pstmt.setString(3,  exp.getExp_etc().trim()		);
			pstmt.setInt   (4,  exp.getExp_amt()			);
			pstmt.setString(5,  exp.getExp_est_dt().trim()	);
			pstmt.setString(6,  exp.getExp_dt().trim()		);
			pstmt.setString(7,  exp.getExp_start_dt().trim());
			pstmt.setString(8,  exp.getExp_end_dt().trim()	);
			pstmt.setString(9,  exp.getCar_ext().trim()		);
			pstmt.setString(10, exp.getCar_no().trim()		);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[GenExpDatabase:insertGenExp]"+e);
			System.out.println("[exp.getExp_st().trim()		]"+exp.getExp_st().trim()		);
			System.out.println("[exp.getCar_mng_id().trim()	]"+exp.getCar_mng_id().trim()	);
			System.out.println("[exp.getExp_est_dt().trim()	]"+exp.getExp_est_dt().trim()	);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
	
	/**
	 *	일반지출 UPDATE
	 */
	public boolean updateGenExp(GenExpBean exp)
	{
		getConnection();
		boolean flag = true;
		String query = "update GEN_EXP set"+
								" EXP_ETC = ?,"+
								" EXP_AMT = ?,"+
								" EXP_DT = replace(?, '-', ''),"+
								" EXP_START_DT = replace(?, '-', ''),"+
								" EXP_END_DT = replace(?, '-', ''),"+
								" RTN_CAU = ?,"+
								" RTN_CAU_DT = replace(?, '-', ''),"+
								" RTN_EST_AMT = ?,"+
								" RTN_AMT = ?,"+
								" RTN_DT = replace(?, '-', ''),"+
								" EXP_EST_DT = replace(?, '-', ''),"+
								" CAR_EXT = ?,"+
								" CAR_NO = ?,"+
								" RTN_REQ_DT = replace(?, '-', ''),"+
								" EXP_GUBUN = ?,"+
								" EXP_GITA = ?"+
								" where EXP_ST = ? and CAR_MNG_ID = ? and EXP_EST_DT = replace(?, '-', '')";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  exp.getExp_etc());
			pstmt.setInt(2,  exp.getExp_amt());
			pstmt.setString(3,  exp.getExp_dt());

			pstmt.setString(4,  exp.getExp_start_dt());
			pstmt.setString(5,  exp.getExp_end_dt());
			pstmt.setString(6,  exp.getRtn_cau());
			pstmt.setString(7,  exp.getRtn_cau_dt());
			pstmt.setInt(8,		exp.getRtn_est_amt());
			pstmt.setInt(9,		exp.getRtn_amt());
			pstmt.setString(10, exp.getRtn_dt());
			pstmt.setString(11,  exp.getExp_est_dt());
			pstmt.setString(12,  exp.getCar_ext());
			pstmt.setString(13,  exp.getCar_no());
			pstmt.setString(14,  exp.getRtn_req_dt());

			pstmt.setString(15,  exp.getExp_gubun());
			pstmt.setString(16,  exp.getExp_gita());

			pstmt.setString(17,  exp.getExp_st());
			pstmt.setString(18,  exp.getCar_mng_id());
			pstmt.setString(19,  exp.getExp_est_dt());

			pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();
		    	
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	취득세 지출처리
	 */
	public boolean updateGenExp(String car_mng_id, String exp_dt, String pay_dt)
	{
		getConnection();
		boolean flag = true;
		String query = "update CAR_REG set "+
								pay_dt+ " = replace(?, '-', '')"+
								" where CAR_MNG_ID = ?";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  exp_dt);
			pstmt.setString(2,  car_mng_id);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[GenExpDatabase:updateGenExp(exp_st)]"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
	
	/**
	 *	일반지출 DELETE
	 */
	public boolean deleteGenExp(String exp_st, String car_mng_id)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from GEN_EXP where EXP_ST = ? and CAR_MNG_ID = ?";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, exp_st);
			pstmt.setString(2, car_mng_id);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}	

	/**
	 * 일반지출 SELECT
	 *	exp_st = 1, 2, 3:일반지출 / 0 : 자동차등록비, 9:취득세
	 */
	public GenExpBean getGenExp(String car_mng_id, String exp_st, String est_dt)
	{
		getConnection();
		GenExpBean exp = new GenExpBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";		
		query = " select a.exp_st, a.car_mng_id, c.exp_etc, a.amt as exp_amt,"+
				" cr.car_no, cr.car_nm, b.firm_nm, b.client_nm, b.rent_mng_id, b.rent_l_cd, "+
				" DECODE(a.est_dt,'','',SUBSTR(a.est_dt,1,4)||'-'||SUBSTR(a.est_dt,5,2)||'-'||SUBSTR(a.est_dt,7,2)) as exp_est_dt,"+
				" DECODE(a.pay_dt,'','',SUBSTR(a.est_dt,1,4)||'-'||SUBSTR(a.pay_dt,5,2)||'-'||SUBSTR(a.pay_dt,7,2)) as exp_dt,"+
				" c.exp_start_dt, c.exp_end_dt, c.rtn_cau, c.rtn_cau_dt, c.rtn_est_amt, c.rtn_amt, c.rtn_dt, c.rtn_req_dt, b.car_st , cr.car_use, nvl(c.car_ext,cr.car_ext) car_ext, c.car_no as exp_car_no"+
				" from exp_view a, cont_n_view b, gen_exp c , car_reg cr \n"+
				" where a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id"+
				" and a.car_mng_id = cr.car_mng_id    \n"+                       	
				" and a.car_mng_id=c.car_mng_id(+) and a.exp_st=c.exp_st(+) and a.est_dt=c.exp_est_dt(+)"+
				" and a.car_mng_id='"+car_mng_id+"' and a.exp_st='"+exp_st+"' and a.est_dt=replace('"+est_dt+"', '-', '')";


		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				exp.setExp_st(rs.getString("EXP_ST")==null?"":rs.getString("EXP_ST"));
				exp.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				exp.setExp_etc(rs.getString("EXP_ETC")==null?"":rs.getString("EXP_ETC"));
				exp.setExp_amt(rs.getInt("EXP_AMT"));
				exp.setExp_est_dt(rs.getString("EXP_EST_DT")==null?"":rs.getString("EXP_EST_DT"));
				exp.setExp_dt(rs.getString("EXP_DT")==null?"":rs.getString("EXP_DT"));				
				exp.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
				exp.setCar_nm(rs.getString("CAR_NM")==null?"":rs.getString("CAR_NM"));
				exp.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				exp.setClient_nm(rs.getString("CLIENT_NM")==null?"":rs.getString("CLIENT_NM"));
				exp.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				exp.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));

				exp.setExp_start_dt	(rs.getString("EXP_START_DT")==null?"":rs.getString("EXP_START_DT"));
				exp.setExp_end_dt	(rs.getString("EXP_END_DT")==null?"":rs.getString("EXP_END_DT"));
				exp.setRtn_cau		(rs.getString("RTN_CAU")==null?"":rs.getString("RTN_CAU"));
				exp.setRtn_cau_dt	(rs.getString("RTN_CAU_DT")==null?"":rs.getString("RTN_CAU_DT"));
				exp.setRtn_est_amt	(rs.getInt("RTN_EST_AMT"));
				exp.setRtn_amt		(rs.getInt("RTN_AMT"));				
				exp.setRtn_dt		(rs.getString("RTN_DT")==null?"":rs.getString("RTN_DT"));
				exp.setCar_st		(rs.getString("CAR_ST")==null?"":rs.getString("CAR_ST"));
				exp.setCar_use		(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				exp.setCar_ext		(rs.getString("CAR_EXT")==null?"":rs.getString("CAR_EXT"));
				exp.setExp_car_no	(rs.getString("EXP_CAR_NO")==null?"":rs.getString("EXP_CAR_NO"));		
				exp.setRtn_req_dt	(rs.getString("RTN_REQ_DT")==null?"":rs.getString("RTN_REQ_DT"));				
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[GenExpDatabase:getGenExp]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return exp;
		}
	}


	/**
	 *	리스트
	 *	pay_st - 0: 전체, 1:지출 , 2: 미지출
	 *	est_st - 0: 당월, 1:기간
	 *	st_dt - 시작일
	 *	end_dt - 종료일
	 *	s_kd - 0: 전체, 1:계약코드, 2:차량번호, 3:상호, 4:계약자	, 5:지출구분 (0:자동차등록비, 9:취득세, 1:검사비, 2:자동차환경개선부담금, 3:자동차세)
	 *	t_wd 
	 */
	public Vector getExpList(String pay_st, String est_st, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " SELECT exp_st_nm, exp_st, firm_nm, client_nm, CAR_NM, car_no, amt, rent_l_cd, gen_exp, car_mng_id,\n"+
								" decode(est_dt, '', '', substr(est_dt, 1, 4)||'-'||substr(est_dt, 5, 2)||'-'||substr(est_dt, 7, 2)) est_dt,"+
								" decode(pay_dt, '', '', substr(pay_dt, 1, 4)||'-'||substr(pay_dt, 5, 2)||'-'||substr(pay_dt, 7, 2)) pay_dt"+
						" FROM\n"+
						" (\n"+
						" SELECT '자동차등록비' exp_st_nm, '0' exp_st, NVL(L.firm_nm, L.client_nm) firm_nm, L.client_nm client_nm, R.CAR_NM CAR_NM, R.car_no car_no, C.rent_l_cd rent_l_cd,\n"+
							   " (R.loan_s_amt + R.reg_amt + R.no_m_amt + R.stamp_amt + R.etc) amt, R.init_reg_dt est_dt, R.reg_pay_dt pay_dt, 0 gen_exp, R.car_mng_id car_mng_id\n"+
						" FROM CAR_REG R, CONT C, CLIENT L, (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) M\n"+
						" WHERE R.car_mng_id = C.car_mng_id AND C.rent_l_cd = M.rent_l_cd AND\n"+
							  " C.client_id = L.client_id\n"+
						" UNION ALL\n"+
						" SELECT '취득세' exp_st_nm, '9' exp_st, NVL(L.firm_nm, L.client_nm) firm_nm, L.client_nm client_nm, R.CAR_NM CAR_NM, R.car_no car_no, C.rent_l_cd rent_l_cd,\n"+
							   	  " R.acq_amt amt, R.acq_f_dt est_dt, R.acq_ex_dt  pay_dt, 0 gen_exp, R.car_mng_id car_mng_id\n"+
						" FROM CAR_REG R, CONT C, CLIENT L, (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) M\n"+
						" WHERE R.car_mng_id = C.car_mng_id AND C.rent_l_cd = M.rent_l_cd AND\n"+
							  " C.client_id = L.client_id\n"+
						" UNION ALL\n"+
						" SELECT DECODE(G.exp_st, '1', '검사비', '2', '환경개선부담금', '3', '자동차세', '') exp_st_nm, G.exp_st exp_st,\n"+
							    " NVL(L.firm_nm, L.client_nm) firm_nm, L.client_nm client_nm, R.CAR_NM CAR_NM, R.car_no car_no, C.rent_l_cd rent_l_cd,\n"+
								" G.exp_amt amt, G.exp_est_dt est_dt, G.exp_dt pay_dt, 1 gen_exp, R.car_mng_id car_mng_id\n"+
						" FROM CAR_REG R, CONT C, CLIENT L, GEN_EXP G, (select max(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) M\n"+
						" WHERE R.car_mng_id = C.car_mng_id AND C.rent_l_cd = M.rent_l_cd AND\n"+
							  " C.client_id = L.client_id AND\n"+
							  " G.car_mng_id = R.car_mng_id\n"+
						" )\n"+
						" WHERE amt != 0\n";
		if(pay_st.equals("1"))		query += " and pay_dt IS NOT NULL";	//지출
		else if(pay_st.equals("2"))	query += " and pay_dt IS NULL";		//미지출
		
		if(est_st.equals("0"))		query += " and SUBSTR(est_dt, 1, 6) LIKE to_char(sysdate,'YYYYMM')||'%'";	//당월
		else if(est_st.equals("1"))	query += " and est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";				//기간

		if(s_kd.equals("1"))		query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')";
		else if(s_kd.equals("2"))	query += " and car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and nvl(firm_nm, client_nm) like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and client_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and exp_st = '"+t_wd+"'";
		
		query += " order by nvl(firm_nm, client_nm)";
	   
		try {
				pstmt = conn.prepareStatement(query);
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
	 *	통계
	 *	pay_st - 0: 전체, 1:지출 , 2: 미지출
	 *	est_st - 0: 당월, 1:기간
	 *	st_dt - 시작일
	 *	end_dt - 종료일
	 *	s_kd - 0: 전체, 1:계약코드, 2:차량번호, 3:상호, 4:계약자	, 5:지출구분 (0:자동차등록비, 9:취득세, 1:검사비, 2:자동차환경개선부담금, 3:자동차세)
	 *	t_wd 
	 */
	public Hashtable getExpStat(String pay_st, String est_st, String st_dt, String end_dt, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " SELECT NVL(MAX(reg_amt), 0) reg_amt, NVL(MAX(exp_amt1), 0) exp_amt1, NVL(MAX(exp_amt2), 0) exp_amt2,  NVL(MAX(exp_amt3), 0) exp_amt3,\n"+
							   	" NVL(MAX(reg_cnt), 0) reg_cnt, NVL(MAX(exp_cnt1), 0) exp_cnt1, NVL(MAX(exp_cnt2), 0) exp_cnt2, NVL(MAX(exp_cnt3), 0) exp_cnt3\n"+
						" FROM\n"+
						" (\n"+
							" SELECT SUM(reg_amt) reg_amt, SUM(exp_amt1) exp_amt1, SUM(exp_amt2) exp_amt2, SUM(exp_amt3) exp_amt3, \n"+
							   		" SUM(reg_cnt) reg_cnt,  SUM(exp_cnt1) exp_cnt1, SUM(exp_cnt2) exp_cnt2, SUM(exp_cnt3) exp_cnt3, exp_st1\n"+
							" FROM\n"+
							" (\n"+
								" SELECT reg_amt, exp_amt1, exp_amt2, exp_amt3, exp_st1, reg_cnt, exp_cnt1, exp_cnt2, exp_cnt3\n"+
								" FROM\n"+
								" (\n"+
									" (\n"+
										" SELECT  (R.loan_s_amt + R.reg_amt + R.no_m_amt + R.stamp_amt + R.etc) reg_amt, 0 exp_amt1, 0 exp_amt2, 0 exp_amt3, '0' exp_st, R.init_reg_dt est_dt, R.reg_pay_dt pay_dt,\n"+
												" C.rent_l_cd rent_l_cd, R.car_no car_no, NVL(L.firm_nm, L.client_nm) firm_nm, L.client_nm client_nm, '0' exp_st1, 1 reg_cnt, 0 exp_cnt1, 0 exp_cnt2, 0 exp_cnt3 \n"+
										" FROM CAR_REG R, CONT C, CLIENT L\n"+
										" WHERE R.car_mng_id = C.car_mng_id AND\n"+
								  				" C.client_id = L.client_id AND\n"+
								  				" (R.loan_s_amt + R.reg_amt + R.no_m_amt + R.stamp_amt + R.etc) != 0\n"+
								  	" )\n"+
									" UNION ALL\n"+
									" (\n"+
										" SELECT  R.acq_amt reg_amt, 0 exp_amt1, 0 exp_amt2, 0 exp_amt3, '9' exp_st,  R.acq_f_dt est_dt, R.acq_ex_dt  pay_dt,\n"+
												  " C.rent_l_cd rent_l_cd, R.car_no car_no, NVL(L.firm_nm, L.client_nm) firm_nm, L.client_nm client_nm, '0' exp_st1, 1 reg_cnt, 0 exp_cnt1, 0 exp_cnt2, 0 exp_cnt3\n"+
										" FROM CAR_REG R, CONT C, CLIENT L\n"+
										" WHERE R.car_mng_id = C.car_mng_id AND\n"+
										  " C.client_id = L.client_id AND\n"+
										  " R.acq_amt != 0\n"+
									" )\n"+
									" UNION ALL\n"+
									" (\n"+
										" SELECT 0 reg_amt, G.exp_amt exp_amt1, 0 exp_amt2, 0 exp_amt3, '1' exp_st, G.exp_est_dt est_dt, G.exp_dt pay_dt,\n"+
													  " C.rent_l_cd rent_l_cd, R.car_no car_no, NVL(L.firm_nm, L.client_nm) firm_nm, L.client_nm client_nm, '1' exp_st1, 0 reg_cnt, 1 exp_cnt1, 0 exp_cnt2, 0 exp_cnt3\n"+
										" FROM CAR_REG R, CONT C, CLIENT L, GEN_EXP G\n"+
										" WHERE R.car_mng_id = C.car_mng_id AND\n"+
										  " C.client_id = L.client_id AND\n"+
										  " G.car_mng_id = R.car_mng_id AND\n"+
										  " G.exp_st = '1' AND  G.exp_amt != 0\n"+
									" )\n"+
									" UNION ALL\n"+
									" (\n"+
										" SELECT 0 reg_amt,  0 exp_amt1, G.exp_amt exp_amt2, 0 exp_amt3, '2' exp_st, G.exp_est_dt est_dt, G.exp_dt pay_dt,\n"+
													  " C.rent_l_cd rent_l_cd, R.car_no car_no, NVL(L.firm_nm, L.client_nm) firm_nm, L.client_nm client_nm, '2' exp_st1, 0 reg_cnt, 0 exp_cnt1, 1 exp_cnt2, 0 exp_cnt3\n"+
										" FROM CAR_REG R, CONT C, CLIENT L, GEN_EXP G\n"+
										" WHERE R.car_mng_id = C.car_mng_id AND\n"+
										  " C.client_id = L.client_id AND\n"+
										  " G.car_mng_id = R.car_mng_id AND\n"+
										  " G.exp_st = '2' AND  G.exp_amt != 0\n"+
									" )\n"+
									" UNION ALL\n"+
									" (\n"+
										" SELECT 0 reg_amt, 0 exp_amt1, 0 exp_amt2, G.exp_amt exp_amt3, '3' exp_st, G.exp_est_dt est_dt, G.exp_dt pay_dt,\n"+
													  " C.rent_l_cd rent_l_cd, R.car_no car_no, NVL(L.firm_nm, L.client_nm) firm_nm, L.client_nm client_nm, '3' exp_st1, 0 reg_cnt, 0 exp_cnt1, 0 exp_cnt2, 1 exp_cnt3\n"+
										" FROM CAR_REG R, CONT C, CLIENT L, GEN_EXP G\n"+
										" WHERE R.car_mng_id = C.car_mng_id AND\n"+
										  " C.client_id = L.client_id AND\n"+
										  " G.car_mng_id = R.car_mng_id AND\n"+
										  " G.exp_st = '3'  AND  G.exp_amt != 0\n"+
									" )\n"+
								" )\n";
		if(pay_st.equals("0"))		query += " where exp_st = exp_st";	//지출
		if(pay_st.equals("1"))		query += " where pay_dt IS NOT NULL";	//지출
		else if(pay_st.equals("2"))	query += " where pay_dt IS NULL";		//미지출
		
		if(est_st.equals("0"))		query += " and SUBSTR(est_dt, 1, 6) LIKE to_char(sysdate,'YYYYMM')||'%'";	//당월
		else if(est_st.equals("1"))	query += " and est_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";				//기간

		if(s_kd.equals("1"))		query += " and upper(rent_l_cd) like upper('%"+t_wd+"%')";
		else if(s_kd.equals("2"))	query += " and car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and nvl(firm_nm, client_nm) like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and client_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and exp_st = '"+t_wd+"'";
		query += " )\n"+
				" GROUP BY exp_st1 order BY exp_st1\n"+
				" )\n";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
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
			pstmt.close();
		} catch (SQLException e) {
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
	 * 차량리스트
	 *	s_kd - 0: 전체, 1:차량번호, 2:차명
	 *	t_wd 
	 */
	public Vector getCarList(String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " SELECT  R.car_mng_id car_mng_id, R.car_no car_no, R.CAR_NM, CN.CAR_NAME,"+
					   "        L.firm_nm,  L.client_nm "+ 
					   " FROM   CAR_REG R, CONT_N_VIEW C, CLIENT L, car_etc g, car_nm cn \n"+
					   " WHERE  R.car_mng_id = C.car_mng_id "+
					   "        AND L.client_id = C.client_id"+
					   "	and  c.rent_mng_id = g.rent_mng_id(+)  and c.rent_l_cd = g.rent_l_cd(+)  \n"+
                       			"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
    						  
	  	if(s_kd.equals("1"))		query += " AND R.CAR_NO LIKE '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " AND R.CAR_NM LIKE '%"+t_wd+"%'";
		
		query += " order by r.car_mng_id";

		try {
				pstmt = conn.prepareStatement(query);
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

	//차량번호로 차량관리번호 가져가기
	public String getCarMngID(String exp_st, String car_no, String exp_est_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt_ch = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs_ch = null;
		String car_mng_id = "";
		int count = 0;

		String query	= " SELECT a.car_mng_id from car_reg a, cont b where nvl(b.use_yn,'Y')='Y' and a.car_mng_id=b.car_mng_id and a.car_no='"+car_no+"'";

		String query2	= " SELECT car_mng_id from car_reg where car_no='"+car_no+"'";
		
		String query_ch = " SELECT count(0) from gen_exp where exp_st=? and car_mng_id=? and exp_est_dt=replace(?, '-', '')";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();    	
			if(rs.next()){				
				car_mng_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			if(car_mng_id.equals("")){
				pstmt2 = conn.prepareStatement(query2);
		    	rs2 = pstmt2.executeQuery();    	
				if(rs2.next()){				
					car_mng_id = rs2.getString(1);
				}
				rs2.close();
				pstmt2.close();
			}

			pstmt_ch = conn.prepareStatement(query_ch);
			pstmt_ch.setString(1, exp_st);
			pstmt_ch.setString(2, car_mng_id);
			pstmt_ch.setString(3, exp_est_dt);
	    	rs_ch = pstmt_ch.executeQuery();    
			if(rs_ch.next()){				
				count = rs_ch.getInt(1);
			}
			rs_ch.close();
			pstmt_ch.close();

			if(!car_mng_id.equals("") && count != 0) car_mng_id = "N";

		} catch (SQLException e) {
			System.out.println("[GenExpDatabase:getCarMngID]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
                if(rs2 != null )		rs2.close();
                if(pstmt2 != null)		pstmt2.close();
                if(rs_ch != null )		rs_ch.close();
                if(pstmt_ch != null)	pstmt_ch.close();
			}catch(Exception ignore){}
			closeConnection();
			return car_mng_id;
		}
	}	


	//차량번호로 차량관리번호 가져가기
	public Hashtable getCarMngID(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = " SELECT a.car_mng_id, b.rent_mng_id, b.rent_l_cd from car_reg a, cont b where a.car_no='"+car_no.trim()+"' and nvl(b.use_yn,'Y')='Y' and a.car_mng_id=b.car_mng_id";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[GenExpDatabase:getCarMngID]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	//차량번호, 대출계약번호로 차량관리번호 가져가기
	public Hashtable getCarMngID(String car_no, String lend_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		int count = 0;

		String query = " SELECT a.car_mng_id, b.rent_mng_id, b.rent_l_cd "+
					   " from   cont b, car_reg a, allot c "+
					   " where  nvl(b.use_yn,'Y')='Y' and b.car_mng_id=a.car_mng_id and b.rent_l_cd=c.rent_l_cd "+
					   "	    and (a.car_no='"+car_no.trim()+"' or c.lend_no='"+lend_no.trim()+"') ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[GenExpDatabase:getCarMngID]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	//환급자동차세관리-----------------------------------------------------------------------------------------------


	//환급자동차세 리스트
	public Vector getCarExpList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query1 = "";
		String query2 = "";
		String filed =  " exp_gubun, exp_gita, nm exp_gov, "+
						" nvl(car_ext,car_ext2) car_ext, car_no as exp_car_no, car_no2 as car_no, first_car_no, exp_st, car_mng_id, "+
						" exp_etc, nvl(exp_amt,0) exp_amt, exp_est_dt, exp_dt, exp_start_dt, exp_end_dt, rtn_st, "+
						" nvl(decode(rtn_cau,'1','용도변경','2','매각','3','폐차','4','말소'),rtn_cau2) rtn_cau, nvl(rtn_cau_dt,rtn_cau_dt2) rtn_cau_dt, "+
						" decode(rtn_est_amt,0,rtn_est_amt2,'',rtn_est_amt2,rtn_est_amt) rtn_est_amt, nvl(rtn_amt,0) rtn_amt, rtn_dt, no_use_day, rtn_req_dt, "+
						" rtn_est_amt as req_rtn_amt, rtn_est_amt2 as account_rtn_amt";


		query = " select "+filed+" from ("+
					" select c.car_ext as car_ext2, c.car_no as car_no2, c.first_car_no, a.*, '1' rtn_st, '용도변경' rtn_cau2, b.cha_dt as rtn_cau_dt2,"+
					" trunc( a.exp_amt * (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(b.cha_dt,'YYYYMMDD')+1) / (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(a.exp_start_dt,'YYYYMMDD')+1),-1 ) rtn_est_amt2,"+
					" (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(b.cha_dt,'YYYYMMDD')+1) as no_use_day, f.nm"+
					" from gen_exp a, car_change b, car_reg c, sui d, (select car_mng_id from gen_exp where exp_st='3' and substr(exp_dt,1,6)='1231') e, code f"+
					" where "+
					" a.exp_st='3' and a.exp_dt is not null and a.exp_end_dt is not null and a.exp_end_dt > b.cha_dt and nvl(c.off_ls,'0')='0'  and f.c_st= '0032' "+
					" and nvl(a.car_ext,c.car_ext) = f.nm_cd "+//		
					" and a.car_mng_id=b.car_mng_id and b.cha_cau='2'"+//		" --6월이후 용도변경 발생"+
					" and a.exp_dt < b.cha_dt"+ //20110215 납부일자가 사유발생일자보다 작아야 한다.
					" and a.car_mng_id=c.car_mng_id"+
					" and b.cha_dt between a.exp_start_dt and a.exp_end_dt"+
					" and a.car_mng_id=d.car_mng_id(+) "+
					" and d.migr_dt is null"+
					" and a.car_mng_id=e.car_mng_id(+) and e.car_mng_id is null"+
					" and a.exp_start_dt<>b.cha_dt"+

					" union all"+
					" select  d.car_ext as car_ext2, d.car_no as car_no2, d.first_car_no,  a.*, '2' rtn_st, '매각' rtn_cau2, b.migr_dt as rtn_cau_dt2,"+
					" trunc( a.exp_amt * (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(b.migr_dt,'YYYYMMDD')+1) / (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(a.exp_start_dt,'YYYYMMDD')+1),-1 ) rtn_est_amt2,"+
					" (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(b.migr_dt,'YYYYMMDD')+1) as no_use_day, f.nm"+
					" from gen_exp a, sui b, (select * from car_change where cha_cau='2') c, car_reg d, code f"+
					" where "+
					" a.exp_st='3' and a.exp_dt is not null and a.exp_end_dt is not null and a.exp_end_dt > b.migr_dt and f.c_st= '0032' "+
					" and nvl(a.car_ext,d.car_ext) = f.nm_cd "+
					" and a.car_mng_id=b.car_mng_id "+
					" and a.car_mng_id=c.car_mng_id(+)"+
					" and a.car_mng_id=d.car_mng_id"+
					" and nvl(b.migr_dt,b.cont_dt) between a.exp_start_dt and a.exp_end_dt"+

					" union all"+
					" select  d.car_ext as car_ext2, d.car_no as car_no2, d.first_car_no,  a.*, '3' rtn_st, '폐차' rtn_cau2, c.cls_dt as rtn_cau_dt2,"+
					" trunc( a.exp_amt * (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(c.cls_dt,'YYYYMMDD')+1) / (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(a.exp_start_dt,'YYYYMMDD')+1),-1 ) rtn_est_amt2,"+
					" (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(c.cls_dt,'YYYYMMDD')+1) as no_use_day, f.nm"+
					" from gen_exp a, cont b, cls_cont c, car_reg d, code f"+
					" where "+
					" a.exp_st='3' and a.exp_dt is not null and a.exp_end_dt is not null and f.c_st= '0032' "+
					" and nvl(a.car_ext,d.car_ext) = f.nm_cd"+
					" and a.car_mng_id=b.car_mng_id"+
					" and b.rent_l_cd=c.rent_l_cd and c.cls_st='9'"+
					" and a.car_mng_id=d.car_mng_id"+
					" and c.cls_dt between a.exp_start_dt and a.exp_end_dt and a.exp_end_dt > c.cls_dt"+

					" union all"+
					" select  d.car_ext as car_ext2, d.car_no as car_no2, d.first_car_no,  a.*, '4' rtn_st, '말소' rtn_cau2, c.cls_dt as rtn_cau_dt2,"+
					" trunc( a.exp_amt * (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(c.cls_dt,'YYYYMMDD')+1) / (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(a.exp_start_dt,'YYYYMMDD')+1),-1 ) rtn_est_amt2,"+
					" (to_date(a.exp_end_dt,'YYYYMMDD')-to_date(c.cls_dt,'YYYYMMDD')+1) as no_use_day, f.nm"+
					" from gen_exp a, cont b, cls_cont c, car_reg d, code f"+
					" where "+
					" a.exp_st='3' and a.exp_dt is not null and a.exp_end_dt is not null and f.c_st= '0032'" +
					" and nvl(a.car_ext,d.car_ext) = f.nm_cd"+
					" and a.car_mng_id=b.car_mng_id"+
					" and b.rent_l_cd=c.rent_l_cd and c.cls_st='15'"+
					" and a.car_mng_id=d.car_mng_id"+
					" and c.cls_dt between a.exp_start_dt and a.exp_end_dt and a.exp_end_dt > c.cls_dt"+
				") where substr(rtn_cau_dt2,5,4) <= '1231' and rtn_cau_dt2 > '20101231'";//11월30일까지유효 20061231

		if(gubun4.equals("1"))			query += " and rtn_cau2 = '용도변경'";
		else if(gubun4.equals("2"))		query += " and rtn_cau2 = '매각'";
		else if(gubun4.equals("3"))		query += " and rtn_cau2 = '폐차'";
		else if(gubun4.equals("4"))		query += " and rtn_cau2 = '말소'";
		
		if(gubun3.equals("2")){
			query += " and rtn_dt is not null";
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and rtn_dt BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and rtn_dt like '"+st_dt+"%'";
		}else{
			if(gubun3.equals("3"))							query += " and rtn_dt is null";
			if(!st_dt.equals("") && !end_dt.equals(""))		query += " and nvl(rtn_cau_dt,rtn_cau_dt2) BETWEEN replace('"+st_dt+"','-','') AND replace('"+end_dt+"','-','')";
			if(!st_dt.equals("") && end_dt.equals(""))		query += " and nvl(rtn_cau_dt,rtn_cau_dt2) like '%"+st_dt+"%'";
		}

		


		/*검색조건*/	
		
		if(!t_wd.equals("")){

			if(s_kd.equals("4"))		query += " and car_no||' '||first_car_no||' '||car_no2 like '%"+t_wd+"%'\n";	
			if(s_kd.equals("5"))		query += " and nm like '%"+t_wd+"%'\n";	
			if(s_kd.equals("99"))		query += " and car_mng_id = '"+t_wd+"'\n";	

		}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("1"))		query += " order by car_ext, nvl(rtn_cau_dt,rtn_cau_dt2) "+sort+"";
		else if(sort_gubun.equals("2"))	query += " order by car_ext, rtn_dt "+sort+"";
		else if(sort_gubun.equals("3"))	query += " order by car_ext, car_no "+sort+"";
		else if(sort_gubun.equals("4"))	query += " order by car_ext, decode(rtn_cau2,'용도변경',1,'매각',2,'폐차',3) "+sort+", nvl(rtn_cau_dt,rtn_cau_dt2)";
		else if(sort_gubun.equals("5"))	query += " order by car_ext, rtn_amt "+sort+"";
		else if(sort_gubun.equals("6"))	query += " order by car_ext, rtn_est_amt "+sort+"";
		

		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[GenExpDatabase:getCarExpList]"+ e);
			System.out.println("[GenExpDatabase:getCarExpList]"+ query);
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

	//자동차세 납부 리스트 : register_gen_id.jsp
	public Vector getExpList(String br_id, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String est_dt = "a.est_dt";

		query = " select "+
				"        b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.use_yn, b.firm_nm, c.car_no, c.car_nm, cn.car_name, e.migr_dt,"+
				"        a.exp_st, decode(a.exp_st,'0','자동차등록비','9','취득세','8','할부비용','7','설정비용','6','말소비용','1','검사비','2','환경개선부담금','3','자동차세') gubun,"+
				"        aa.amt, decode(aa.pay_dt, '','0','1') pay_yn, "+
				"        DECODE(a.exp_start_dt,'','',SUBSTR(a.exp_start_dt,1,4)||'-'||SUBSTR(a.exp_start_dt,5,2)||'-'||SUBSTR(a.exp_start_dt,7,2)) as start_dt,"+
				"        DECODE(a.exp_end_dt,'','',SUBSTR(a.exp_end_dt,1,4)||'-'||SUBSTR(a.exp_end_dt,5,2)||'-'||SUBSTR(a.exp_end_dt,7,2)) as end_dt,"+
				"        DECODE(a.exp_est_dt,'','',SUBSTR(a.exp_est_dt,1,4)||'-'||SUBSTR(a.exp_est_dt,5,2)||'-'||SUBSTR(a.exp_est_dt,7,2)) as est_dt,"+
				"        DECODE(aa.pay_dt,'','',SUBSTR(aa.pay_dt,1,4)||'-'||SUBSTR(aa.pay_dt,5,2)||'-'||SUBSTR(aa.pay_dt,7,2)) as pay_dt"+
				" from   gen_exp a,  exp_view aa, cont_n_view b, sui e , car_reg c,  car_etc g, car_nm cn \n"+
				" where  a.car_mng_id = aa.car_mng_id and a.exp_st = aa.exp_st and a.exp_est_dt = aa.est_dt"+
				"        and a.car_mng_id=b.car_mng_id and aa.rent_l_cd=b.rent_l_cd and aa.car_mng_id=e.car_mng_id(+)"+
				"	and a.car_mng_id = c.car_mng_id  and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
				

		/*상세조회&&세부조회*/
	
		if(!gubun4.equals(""))		query += " and a.exp_st='"+gubun4+"'";
		
		
		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and nvl(a.amt, 0) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("9"))	query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("99"))	query += " and b.car_mng_id = '"+t_wd+"'\n";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.exp_st "+sort+", a.exp_est_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.exp_est_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.exp_est_dt "+sort+", a.exp_st, b.firn_nm";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.amt "+sort+", a.exp_st, b.firm_nm";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, c.car_no "+sort+", b.firm_nm";		


		try {
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[GenExpDatabase:getExpList]"+ e);
			System.out.println("[GenExpDatabase:getExpList]"+ query);
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
	 *	일괄지출처리 - 자동차세
	 */
	public boolean updateAllGenExpPay(String exp_st, String exp_est_dt, String exp_dt)
	{
		getConnection();
		boolean flag = true;
		String query =  " update gen_exp set "+
						"		exp_dt = replace(?, '-', '')"+
						" where exp_st=? and exp_est_dt=replace(?, '-', '') and exp_dt is null";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  exp_dt);
			pstmt.setString(2,  exp_st);
			pstmt.setString(3,  exp_est_dt);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[GenExpDatabase:updateAllGenExpPay]"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	일괄지출처리 - 환경개선부담금
	 */
	public boolean updateAllGenExpPay2(String exp_st, String exp_est_dt, String exp_dt)
	{
		getConnection();
		boolean flag = true;
		String query =  " update gen_exp set "+
						"		exp_dt = replace(?, '-', '')"+
						" where exp_st=? and exp_est_dt=replace(?, '-', '') and exp_dt is null";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  exp_dt);
			pstmt.setString(2,  exp_st);
			pstmt.setString(3,  exp_est_dt);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[GenExpDatabase:updateAllGenExpPay]"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}


	/**
	 * 세입과오납환부청구처 접수시 자동차세 조회
	 */
	public GenExpBean getGenExpRtnDoc(String exp_st, String car_no, String exp_year)
	{
		getConnection();
		GenExpBean exp = new GenExpBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";		
		query = " select  a.exp_st, a.car_mng_id, c.exp_etc, a.amt as exp_amt,"+
				" cr.car_no, cr.car_nm, b.firm_nm, b.client_nm, b.rent_mng_id, b.rent_l_cd, "+
				" DECODE(a.est_dt,'','',SUBSTR(a.est_dt,1,4)||'-'||SUBSTR(a.est_dt,5,2)||'-'||SUBSTR(a.est_dt,7,2)) as exp_est_dt,"+
				" DECODE(a.pay_dt,'','',SUBSTR(a.est_dt,1,4)||'-'||SUBSTR(a.pay_dt,5,2)||'-'||SUBSTR(a.pay_dt,7,2)) as exp_dt,"+
				" c.exp_start_dt, c.exp_end_dt, c.rtn_cau, c.rtn_cau_dt, c.rtn_est_amt, c.rtn_amt, c.rtn_dt, c.rtn_req_dt, b.car_st , cr.car_use, nvl(c.car_ext,cr.car_ext) car_ext, c.car_no as exp_car_no"+
				" from exp_view a, cont_n_view b, gen_exp c, car_reg cr "+
				" where c.exp_st='"+exp_st+"' and c.exp_end_dt like '"+exp_year+"%' and c.car_no = '"+car_no+"'"+
				" and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id and a.car_mng_id = cr.car_mng_id(+) \n"+
				" and a.car_mng_id=c.car_mng_id(+) and a.exp_st=c.exp_st(+) and a.est_dt=c.exp_est_dt(+)"+
				"";
		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				exp.setExp_st(rs.getString("EXP_ST")==null?"":rs.getString("EXP_ST"));
				exp.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				exp.setExp_etc(rs.getString("EXP_ETC")==null?"":rs.getString("EXP_ETC"));
				exp.setExp_amt(rs.getInt("EXP_AMT"));
				exp.setExp_est_dt(rs.getString("EXP_EST_DT")==null?"":rs.getString("EXP_EST_DT"));
				exp.setExp_dt(rs.getString("EXP_DT")==null?"":rs.getString("EXP_DT"));				
				exp.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
				exp.setCar_nm(rs.getString("CAR_NM")==null?"":rs.getString("CAR_NM"));
				exp.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				exp.setClient_nm(rs.getString("CLIENT_NM")==null?"":rs.getString("CLIENT_NM"));
				exp.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				exp.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));

				exp.setExp_start_dt	(rs.getString("EXP_START_DT")==null?"":rs.getString("EXP_START_DT"));
				exp.setExp_end_dt	(rs.getString("EXP_END_DT")==null?"":rs.getString("EXP_END_DT"));
				exp.setRtn_cau		(rs.getString("RTN_CAU")==null?"":rs.getString("RTN_CAU"));
				exp.setRtn_cau_dt	(rs.getString("RTN_CAU_DT")==null?"":rs.getString("RTN_CAU_DT"));
				exp.setRtn_est_amt	(rs.getInt("RTN_EST_AMT"));
				exp.setRtn_amt		(rs.getInt("RTN_AMT"));				
				exp.setRtn_dt		(rs.getString("RTN_DT")==null?"":rs.getString("RTN_DT"));
				exp.setCar_st		(rs.getString("CAR_ST")==null?"":rs.getString("CAR_ST"));
				exp.setCar_use		(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				exp.setCar_ext		(rs.getString("CAR_EXT")==null?"":rs.getString("CAR_EXT"));
				exp.setExp_car_no	(rs.getString("EXP_CAR_NO")==null?"":rs.getString("EXP_CAR_NO"));		
				exp.setRtn_req_dt	(rs.getString("RTN_REQ_DT")==null?"":rs.getString("RTN_REQ_DT"));				
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[GenExpDatabase:getGenExpRtnDoc]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return exp;
		}
	}

	//차량번호로 차량관리번호 가져가기
	public String getCarMngIDSui(String exp_st, String car_no, String exp_est_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt_ch = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs_ch = null;
		String car_mng_id = "";
		int count = 0;

		String query	= " select a.*"+
							" from car_change a, car_reg b, sui c, (select car_mng_id, max(cha_dt) cha_dt from car_change group by car_mng_id) d"+
							" where a.car_no='"+car_no+"'"+
							" and a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id"+
							" and c.car_mng_id=d.car_mng_id"+
							" and c.cont_dt like substr('"+exp_est_dt+"',1,4)||'%'"+
							" and c.cont_dt like substr(d.cha_dt,1,6)||'%'";

		String query2	= " select a.*"+
							" from car_change a, car_reg b, (select car_mng_id from car_change where cha_dt like substr('"+exp_est_dt+"',1,4)||'%' and cha_cau_sub like '%매각%' group by car_mng_id) d"+
							" where a.car_no='"+car_no+"'"+
							" and a.car_mng_id=b.car_mng_id "+
							" and a.car_mng_id=d.car_mng_id";
	
		String query_ch = " SELECT count(0) from gen_exp where exp_st=? and car_mng_id=? and exp_est_dt=replace(?, '-', '')";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();    	
			if(rs.next()){				
				car_mng_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();

			if(car_mng_id.equals("")){
				pstmt2 = conn.prepareStatement(query2);
		    	rs2 = pstmt2.executeQuery();    	
				if(rs2.next()){				
					car_mng_id = rs2.getString(1);
				}
				rs2.close();
				pstmt2.close();
			}

			pstmt_ch = conn.prepareStatement(query_ch);
			pstmt_ch.setString(1, exp_st);
			pstmt_ch.setString(2, car_mng_id);
			pstmt_ch.setString(3, exp_est_dt);
	    	rs_ch = pstmt_ch.executeQuery();    
			if(rs_ch.next()){				
				count = rs_ch.getInt(1);
			}
			rs_ch.close();
			pstmt_ch.close();

			if(!car_mng_id.equals("") && count != 0) car_mng_id = "N";

		} catch (SQLException e) {
			System.out.println("[GenExpDatabase:getCarMngIDSui]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
                if(rs2 != null )		rs2.close();
                if(pstmt2 != null)		pstmt2.close();
                if(rs_ch != null )		rs_ch.close();
                if(pstmt_ch != null)	pstmt_ch.close();
			}catch(Exception ignore){}
			closeConnection();
			return car_mng_id;
		}
	}	

	//차량번호로 차량관리번호 가져가기
	public String getCarMngIDExpAmt(String exp_st, String car_no, String exp_est_dt, int exp_amt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String car_mng_id = "N";
		int count = 0;
	
		String query = " SELECT car_mng_id from gen_exp where exp_st=? and car_no=? and exp_est_dt=replace(?, '-', '') and exp_amt=?";

		try {

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, exp_st);
			pstmt.setString(2, car_no);
			pstmt.setString(3, exp_est_dt);
			pstmt.setInt   (4, exp_amt);
	    	rs = pstmt.executeQuery();    	
			if(rs.next()){				
				car_mng_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[GenExpDatabase:getCarMngIDExpAmt]"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return car_mng_id;
		}
	}	




	//차량번호로 차량관리번호 가져가기
	public Hashtable getGenExpListExcel(String car_no, String car_ext, String car_mng_id, String exp_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;
		String query ="";

		query = " select"+
				" a.car_mng_id, a.exp_st,a .exp_est_dt, a.exp_dt, "+
				" a.car_no, b.car_nm, b.init_reg_dt,"+ 
				" decode(e.cha_dt,'','',e.cha_dt||'[용도변경]-'||e.cha_cau_sub) cha_cont,"+
				" decode(c.migr_dt,'','',c.migr_dt||'[매각]-'||d.firm_nm) sui_cont"+
				" from gen_exp a, car_reg b, sui c, client d, car_change e, car_change f, "+
				"	(select car_mng_id from cont where use_yn='Y' and car_st<>'2') g"+
				" where a.exp_st='3' and substr(a.exp_end_dt,5,4)='1231' and a.rtn_est_amt>0 and a.rtn_amt=0 and a.rtn_req_dt is null and a.rtn_dt is null and a.exp_est_dt<>a.exp_end_dt"+
				" and a.car_mng_id=b.car_mng_id"+
				" and a.car_mng_id=c.car_mng_id(+)"+
				" and c.client_id=d.client_id(+)"+
				" and a.car_mng_id=e.car_mng_id(+) and a.rtn_cau_dt=e.cha_dt(+)"+
				" and e.car_mng_id=f.car_mng_id(+) and e.cha_seq-1=f.cha_seq(+)"+
				" and a.car_mng_id=g.car_mng_id(+)"+
				" and a.car_no='"+car_no+"' and a.car_ext='"+car_ext+"' and a.car_mng_id='"+car_mng_id+"' and a.exp_dt='"+exp_dt+"' ";

		query += " order by a.rtn_cau, a.rtn_cau_dt";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[GenExpDatabase:getGenExpListExcel]"+e);
			System.out.println("[GenExpDatabase:getGenExpListExcel]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}


//과태료 공문 인쇄여부 출력
	public void changeRtn_req_dt(String car_no, String car_ext, String car_mng_id, String exp_dt)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " update gen_exp set rtn_req_dt=to_char(sysdate,'YYYYMMDD') where car_no=? and car_ext=? and car_mng_id=? and exp_dt=? ";

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		car_no.trim()	 );
			pstmt.setString	(2,		car_ext.trim()	 );
			pstmt.setString	(3,		car_mng_id.trim()	 );
			pstmt.setString	(4,		exp_dt.trim()	 );
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		
		 }catch(Exception se){
           try{
				System.out.println("[GenExpDatabase:changeRtn_req_dt]"+se);
				System.out.println("1: "+car_no.trim());
				System.out.println("2: "+car_ext.trim());
				System.out.println("3: "+car_mng_id.trim());
				System.out.println("4: "+exp_dt.trim());
				se.printStackTrace();
				flag = false;
                conn.rollback();
            }catch(SQLException _ignored){}
       
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
		}
	}



/**
	 *	일반지출 UPDATE
	 */
	public boolean updateGenExp2(GenExpBean exp)
	{
		getConnection();
		boolean flag = true;
		String query = "update GEN_EXP set"+
								" RTN_AMT = ?,"+
								" RTN_DT = replace(?, '-', '')"+
								" where EXP_ST = ? and CAR_MNG_ID = ? and substr(EXP_EST_DT, 0,4) = ? ";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1,		exp.getRtn_amt());
			pstmt.setString(2, exp.getRtn_dt());
			pstmt.setString(3,  exp.getExp_st());
			pstmt.setString(4,  exp.getCar_mng_id());
			pstmt.setString(5,  exp.getExp_est_dt());

			pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();
		    	
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}



}

