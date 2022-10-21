package acar.out_car;


import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.car_office.*;
import acar.common.*;
import acar.util.*;
import card.CardStatBean;

public class OutCarDatabase
{
	private Connection conn = null;
	public static OutCarDatabase db;
	
	public static OutCarDatabase getInstance()
	{
		if(OutCarDatabase.db == null)
			OutCarDatabase.db = new OutCarDatabase();
		return OutCarDatabase.db;
	}	
	
 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
			{
	        	conn = connMgr.getConnection("acar");
	        }
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

	

	/*
	 *	계출현황-자체출고현황 마감 프로시져 호출
	*/
	public String call_out_car_magam(String s_day)
	{
    	getConnection();
    	
    	String query = "{CALL P_OUT_CAR_MAGAM (?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);

			cstmt.setString(1, s_day);
			cstmt.registerOutParameter( 2, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(2); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[OutCarDatabase:call_out_car_magam]\n"+e);
			System.out.println("[OutCarDatabase:call_out_car_magam]\n"+query);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	


	/**
	 *	마감일자조회
	 */
	public Vector getStatDebtList(String table_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query= " select"+
				" decode(save_dt, '', '', substr(save_dt, 1, 4)||'-'||substr(save_dt, 5, 2)||'-'||substr(save_dt, 7, 2)) as save_dt, "+
				" ADD_MONTHS(TO_DATE(decode(save_dt, '', '', substr(save_dt, 1, 4)||'-'||substr(save_dt, 5, 2)||'-'||substr(save_dt, 7, 2)),'YYYY-MM-DD'),-1) as save_dt2";

		if(table_nm.equals("OUT_CAR_MAGAM")) query += " , max(reg_dt) reg_dt ";

		query += " from "+table_nm+" ";
	
		// 날짜 제한 2007년 이전은 안보이게	
		query += " where (save_dt > to_char(sysdate,'YYYY')-2||'1231' or substr(save_dt,5,4)='1231')";

		query += " group by save_dt order by save_dt desc ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				Out_carBean sd = new Out_carBean();
				sd.setSave_dt(rs.getString(1));		
				sd.setSave_dt2(rs.getString(2));		
				if(table_nm.equals("OUT_CAR_MAGAM")){
					sd.setReg_dt(rs.getString(3));		
				}
				vt.add(sd);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[OutCarDatabase:getStatDebt]"+e);
			System.out.println("[OutCarDatabase:getStatDebt]"+query);
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
	 *	마감 리스트조회
	 */
public Vector Magam_ListSearch(String save_dt)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String park_in ="";

		
		query =	" SELECT substr(car_num, -6, 6) as CAR_NUM2, save_dt, rent_l_cd, rpt_no, car_num, CAR_NM, rent_dt, dlv_dt, init_reg_dt, dlv_off, bc_s_f, bc_s_f2  \n"+
				" from out_car_magam where save_dt = replace('"+save_dt+"', '-','') \n";
		query += " order by init_reg_dt ";
				



		try {
			stmt = conn.createStatement();
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
			System.out.println("[OutCarDatabase:Magam_ListSearch]"+e);
			System.out.println("[OutCarDatabase:Magam_ListSearch]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	

	/**
    *  자체출고현황 마감등록시 중복조회
    */
    public int getServiceCheck(String save_dt){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        String query = "";
        
		query = "SELECT count(0) "+
				"  FROM out_car_magam "+
				" WHERE SUBSTR(save_dt,0,6) =  TO_CHAR(ADD_MONTHS(TO_CHAR(TO_DATE(replace('"+save_dt+"','-',''),'YYYYMMDD'),'YYYYMMDD'),1),'YYYYMM')  ";

        try{
            pstmt = conn.prepareStatement(query);
    		rs = pstmt.executeQuery();

            if(rs.next()){                
				count = rs.getInt(1);
            }

			rs.close();
			pstmt.close();

        }catch(SQLException e){
			 System.out.println("[OutCarDatabase:getServiceCheck()]"+e);
			 System.out.println("[OutCarDatabase:getServiceCheck()]"+query);
			e.printStackTrace();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(Exception ignore){}

			closeConnection();
			return count;
        }        
    }

//자체출고현황
 public Vector getDlvStats_out(String s_kd, String t_wd, String dt, String t_st_dt, String t_end_dt, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String save_dt )
    {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select substr(a.car_num, -6, 6)as car_num2, A.user_nm, A.br_id, A.user_id, A.rpt_no, A.rent_l_cd, decode(A.rent_dt, '', '', substr(A.rent_dt, 1, 4)||'-'||substr(A.rent_dt, 5, 2)||'-'||substr(A.rent_dt, 7, 2)) rent_dt, nvl(A.firm_nm, A.client_nm) firm_nm, A.car_no car_no, A.car_nm car_nm, A.car_name car_name, A.car_num,"+
								" decode(A.dlv_dt, '', '', substr(A.dlv_dt, 1, 4)||'-'||substr(A.dlv_dt, 5, 2)||'-'||substr(A.dlv_dt, 7, 2)) dlv_dt,"+
								" decode(A.init_reg_dt, '', '미등록', substr(A.init_reg_dt, 1, 4)||'-'||substr(A.init_reg_dt, 5, 2)||'-'||substr(A.init_reg_dt, 7, 2)) init_reg_dt,"+
								" A.gds_yn gds_yn, a.lpg_yn lpg_yn, B.car_off_nm bus_off, C.car_off_nm dlv_off, B.emp_nm emp_nm, decode(A.one_self,'Y','자체출고') one_self, y.bc_s_f, trunc(y.bc_s_f * 1.1) AS bc_s_f_2 "+
						" from"+
						" ("+
							" select c.use_yn, C.rent_mng_id, C.rent_l_cd, C.rent_dt, nvl(L.firm_nm, L.client_nm) firm_nm, L.client_nm, R.car_no, M.car_nm, R.init_reg_dt, R.car_num,"+
									" C.dlv_dt, P.gds_yn, E.lpg_yn, M.car_nm||' '||N.car_name car_name, P.one_self, P.rpt_no, C.bus_id, J.user_nm, J.br_id, J.user_id"+
							" from cont C, client L, car_reg R, car_pur P, car_etc E, car_nm N, car_mng M, users J, (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st='5') S "+
							" ,(SELECT doc_id FROM doc_settle  WHERE doc_st='4' AND doc_step='3' ) d"+
							" where C.client_id = L.client_id and"+
									" C.car_mng_id = R.car_mng_id(+) and"+
								  	" C.rent_mng_id = P.rent_mng_id and"+
								  	" C.rent_l_cd = P.rent_l_cd and"+
								  	" C.rent_mng_id = E.rent_mng_id and"+
								  	" C.rent_l_cd = E.rent_l_cd AND J.user_id = C.bus_id and "+
								  	" E.car_id = N.car_id and E.car_seq = N.car_seq and N.car_comp_id = M.car_comp_id and N.car_cd = M.code "+
								  	" and C.rent_mng_id=S.rent_mng_id(+) and C.reg_dt=S.reg_dt(+) and S.rent_l_cd is null"+
								  	" and C.dlv_dt is not null AND C.rent_l_cd=d.doc_id AND m.CAR_COMP_ID <= '0005' "+	 
						" )A,"+
						" ("+
							" select M.rent_mng_id, M.rent_l_cd, M.emp_id, E.emp_nm, O.car_off_nm"+
							" from commi M, car_off_emp E, car_off O"+
							" where M.emp_id = E.emp_id and"+
									" M.agnt_st = '1' and"+
								  	" E.car_off_id = O.car_off_id"+
						" )B,"+
						" ("+
							" select M.rent_mng_id, M.rent_l_cd, M.emp_id, E.emp_nm, O.car_off_nm"+
							" from commi M, car_off_emp E, car_off O"+
							" where M.emp_id = E.emp_id and"+
									" M.agnt_st = '2' and m.emp_id<>'030849' and"+
									" E.car_off_id = O.car_off_id"+
						" )C, (select rent_mng_id, rent_l_cd, rent_st, bc_s_f from fee_etc where rent_st ='1') y "+
						" where A.rent_mng_id = B.rent_mng_id(+) and"+
								" A.rent_l_cd = B.rent_l_cd(+) and"+
							 	" A.rent_mng_id = C.rent_mng_id and"+
								" A.rent_l_cd = C.rent_l_cd and"+
								" A.rent_mng_id = y.rent_mng_id and"+
								" A.rent_l_cd = y.rent_l_cd and"+
           						" nvl(y.bc_s_f,0) > 0 and"+ 
								" A.one_self = 'Y' AND a.rent_l_cd NOT IN ('S112HGDR00029','S112KK5R00098')";//and nvl(a.use_yn,'Y') = 'Y' 

		if(!save_dt.equals("")&&gubun2.equals("")) {//자체출고현황 첫화면.
			query += "  AND ( a.init_reg_dt > replace('"+save_dt+"','-','') OR A.dlv_dt like to_char(sysdate,'YYYYMM')||'%' ) ";
		}else{//자체출고현황 조회검색 화면.
			if(gubun2.equals(""))  query +=" and A.dlv_dt like to_char(sysdate,'YYYYMM')||'%' and A.dlv_dt <= to_char(sysdate,'yyyymmdd')  ";

			if(gubun2.equals("2") && gubun3.equals("1"))	    query +=" and A.dlv_dt = to_char(sysdate-2,'YYYYMMDD') ";
			else if(gubun2.equals("2") && gubun3.equals("2"))	query +=" and A.dlv_dt = to_char(sysdate-1,'YYYYMMDD') ";
			else if(gubun2.equals("2") && gubun3.equals("3"))	query +=" and A.dlv_dt = to_char(sysdate,'YYYYMMDD') ";

			if(gubun2.equals("4"))	query +=" and A.dlv_dt like '"+gubun4+"%"+gubun5+"%'";
			if(gubun2.equals("5"))	query +=" and A.dlv_dt like '"+gubun6+"%'";
			if(gubun2.equals("6") && !t_st_dt.equals("") && !t_end_dt.equals("")) query +=" and A.dlv_dt between replace(" + t_st_dt + ",'-','') and replace(" + t_end_dt + ",'-','') ";

			if(gubun2.equals("9") && gubun3.equals("S1")) query += " and A.br_id = 'S1' ";
			else if(gubun2.equals("9") && gubun3.equals("B1")) query += " and A.br_id = 'B1' ";
			else if(gubun2.equals("9") && gubun3.equals("D1")) query += " and A.br_id = 'D1' ";
			else if(gubun2.equals("9") && gubun3.equals("S2")) query += " and A.br_id = 'S2' ";
			else if(gubun2.equals("9") && gubun3.equals("S3")) query += " and A.br_id = 'S3' ";
			else if(gubun2.equals("9") && gubun3.equals("S4")) query += " and A.br_id = 'S4' ";
			else if(gubun2.equals("9") && gubun3.equals("G1")) query += " and A.br_id = 'G1' ";
			else if(gubun2.equals("9") && gubun3.equals("J1")) query += " and A.br_id = 'J1' ";
			else if(gubun2.equals("9") && gubun3.equals("I1")) query += " and A.br_id = 'I1' ";
			else if(gubun2.equals("9") && gubun3.equals("K1")) query += " and A.br_id = 'K1' ";
			else if(gubun2.equals("9") && gubun3.equals("U1")) query += " and A.br_id = 'U1' ";

			if(gubun2.equals("10")) query += " and A.user_id = '"+gubun4+"' ";
			if(gubun2.equals("11")) query += " and nvl(C.car_off_nm, ' ') like '%"+gubun5+"%'";


			if(gubun6.equals("1")){ 
			}else if(gubun6.equals("2")){ 
				query +=" and A.dlv_dt = to_char(sysdate-1,'YYYYMMDD') ";
			}else if(gubun6.equals("3")){ 
				query +=" AND A.dlv_dt like to_char(add_months(sysdate,-1), 'YYYYMM')||'%' ";
			}else if(gubun6.equals("4")){ 
				query +=" and A.dlv_dt like to_char(sysdate,'YYYYMM')||'%' ";
			}else if(gubun6.equals("6") && !t_st_dt.equals("") && !t_end_dt.equals("")) {
				query +=" and A.dlv_dt between replace(" + t_st_dt + ",'-','') and replace(" + t_end_dt + ",'-','') ";
			}


			if(!t_wd.equals("")){
				query += " and A.firm_nm||A.client_nm||a.car_num like '%"+t_wd+"%' ";
			}

		}

		query += " order by  A.init_reg_dt, A.dlv_dt ";


		try
		{
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
			System.out.println("[OutCarDatabase:getDlvStats_out]\n"+e);
			System.out.println("[OutCarDatabase:getDlvStats_out]\n"+query);
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


//자체출고현황
 public Vector getDlvStats_outAB(String s_kd, String t_wd, String dt, String t_st_dt, String t_end_dt, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String save_dt )
    {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String month="";

		query = " select substr(a.car_num, -6, 6)as car_num2, A.user_nm, A.br_id, A.user_id, A.rpt_no, A.rent_l_cd, decode(A.rent_dt, '', '', substr(A.rent_dt, 1, 4)||'-'||substr(A.rent_dt, 5, 2)||'-'||substr(A.rent_dt, 7, 2)) rent_dt, nvl(A.firm_nm, A.client_nm) firm_nm, A.car_no car_no, A.car_nm car_nm, A.car_name car_name, A.car_num,"+
				" decode(A.dlv_dt, '', '', substr(A.dlv_dt, 1, 4)||'-'||substr(A.dlv_dt, 5, 2)||'-'||substr(A.dlv_dt, 7, 2)) dlv_dt,"+
				" decode(A.init_reg_dt, '', '미등록', substr(A.init_reg_dt, 1, 4)||'-'||substr(A.init_reg_dt, 5, 2)||'-'||substr(A.init_reg_dt, 7, 2)) init_reg_dt,"+
				" A.gds_yn gds_yn, a.lpg_yn lpg_yn, B.car_off_nm bus_off, C.car_off_nm dlv_off, B.emp_nm emp_nm, decode(A.one_self,'Y','자체출고') one_self, y.bc_s_f, trunc(y.bc_s_f * 1.1) AS bc_s_f_2 "+
				" from"+
				" ("+
				" select c.use_yn, C.rent_mng_id, C.rent_l_cd, C.rent_dt, nvl(L.firm_nm, L.client_nm) firm_nm, L.client_nm, R.car_no, M.car_nm, R.init_reg_dt, R.car_num,"+
				" C.dlv_dt, P.gds_yn, E.lpg_yn, M.car_nm||' '||N.car_name car_name, P.one_self, P.rpt_no, C.bus_id, J.user_nm, J.br_id, J.user_id"+
				" from cont C, client L, car_reg R, car_pur P, car_etc E, car_nm N, car_mng M, users J, (select * from cls_cont where cls_st='5') S "+
				" ,(SELECT /*+ index(doc_settle DOC_SETTLE_IDX2  ) */ * FROM doc_settle  WHERE doc_st='4' AND doc_step='3' ) d"+
				" where C.client_id = L.client_id and"+
				" C.car_mng_id = R.car_mng_id(+) and"+
				" C.rent_mng_id = P.rent_mng_id and"+
				" C.rent_l_cd = P.rent_l_cd and"+
				" C.rent_mng_id = E.rent_mng_id and"+
				" C.rent_l_cd = E.rent_l_cd AND J.user_id = C.bus_id and "+
				" E.car_id = N.car_id and E.car_seq = N.car_seq and N.car_comp_id = M.car_comp_id and N.car_cd = M.code "+
				" and C.rent_mng_id=S.rent_mng_id(+) and C.reg_dt=S.reg_dt(+) and S.rent_l_cd is null"+
				" and C.dlv_dt is not null and C.car_st <> '2'  AND C.rent_l_cd=d.doc_id AND m.CAR_COMP_ID <= '0005' "+	  
				" )A,"+
				" ("+
				" select M.rent_mng_id, M.rent_l_cd, M.emp_id, E.emp_nm, O.car_off_nm"+
				" from commi M, car_off_emp E, car_off O"+
				" where M.emp_id = E.emp_id and"+
				" M.agnt_st = '1' and"+
				" E.car_off_id = O.car_off_id"+
				" )B,"+
				" ("+
				" select M.rent_mng_id, M.rent_l_cd, M.emp_id, E.emp_nm, O.car_off_nm"+
				" from commi M, car_off_emp E, car_off O"+
				" where M.emp_id = E.emp_id and"+
				" M.agnt_st = '2' and m.emp_id<>'030849' and"+
				" E.car_off_id = O.car_off_id"+
				" )C, (select rent_mng_id, rent_l_cd, rent_st, bc_s_f from fee_etc where rent_st ='1') y  , OUT_CAR_MAGAM x"+
				" where A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_mng_id = C.rent_mng_id(+) and"+
				" A.rent_l_cd = C.rent_l_cd(+) and"+
				" A.rent_mng_id = y.rent_mng_id and"+
				" A.rent_l_cd = y.rent_l_cd AND A.rent_l_cd = x.rent_l_cd(+) and"+
  				" nvl(y.bc_s_f,0) > 0 and"+ 
				" A.one_self = 'Y' and nvl(a.use_yn,'Y') = 'Y' AND a.rent_l_cd NOT IN ('S112HGDR00029','S112KK5R00098')";

		if(gubun2.equals(""))  query +=" and x.save_dt like to_char(sysdate,'YYYYMM')||'%' and x.save_dt <= to_char(sysdate,'yyyymmdd')  ";

		if(gubun2.equals("2") && gubun3.equals("1"))	    query +=" and x.save_dt = to_char(sysdate-2,'YYYYMMDD') ";
		else if(gubun2.equals("2") && gubun3.equals("2"))	query +=" and x.save_dt = to_char(sysdate-1,'YYYYMMDD') ";
		else if(gubun2.equals("2") && gubun3.equals("3"))	query +=" and x.save_dt = to_char(sysdate,'YYYYMMDD') ";

		if(gubun2.equals("4"))	    query +=" and x.save_dt like '"+gubun4+"%"+gubun5+"%'";
		else if(gubun2.equals("5"))	query +=" and x.save_dt like '"+gubun6+"%'";
		else if(gubun2.equals("6")) query +=" and x.save_dt between replace(" + t_st_dt + ",'-','') and replace(" + t_end_dt + ",'-','') ";

		if(gubun2.equals("9") && gubun3.equals("S1")) query += " and A.br_id = 'S1' ";
		else if(gubun2.equals("9") && gubun3.equals("B1")) query += " and A.br_id = 'B1' ";
		else if(gubun2.equals("9") && gubun3.equals("D1")) query += " and A.br_id = 'D1' ";

		if(gubun2.equals("10")) query += " and A.user_id = '"+gubun4+"' ";
		if(gubun2.equals("11")) query += " and nvl(C.car_off_nm, ' ') like '%"+gubun5+"%'";


		if(gubun6.equals("1")){ 
		}else if(gubun6.equals("2")){ 
			query +=" and x.save_dt = to_char(sysdate-1,'YYYYMMDD') ";
		}else if(gubun6.equals("3")){ 
			query +=" AND x.save_dt like to_char(add_months(sysdate,-1), 'YYYYMM' )||'%' ";
		}else if(gubun6.equals("4")){ 
			query +=" and x.save_dt like to_char(sysdate,'YYYYMM')||'%' ";
		}

		query += " order by  A.init_reg_dt, A.dlv_dt ";

		try
		{
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
			System.out.println("[OutCarDatabase:getDlvStats_outAB]\n"+e);
			System.out.println("[OutCarDatabase:getDlvStats_outAB]\n"+query);
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
 
//자체출고현황
public Vector getDlvStats_outAB(String s_kd, String t_wd, String dt, String t_st_dt, String t_end_dt, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String save_dt )
   {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String month="";
		
		String sub_query = " and C.dlv_dt is not null and C.car_st <> '2' AND C.rent_l_cd=d.doc_id ";
		
		if(gubun7.equals("2")) {
			sub_query = " and C.car_st <> '2' and C.rent_l_cd=d.doc_id(+) ";
		}

		query = " select substr(a.car_num, -6, 6)as car_num2, A.user_nm, A.br_id, A.user_id, A.rpt_no, A.rent_l_cd, decode(A.rent_dt, '', '', substr(A.rent_dt, 1, 4)||'-'||substr(A.rent_dt, 5, 2)||'-'||substr(A.rent_dt, 7, 2)) rent_dt, nvl(A.firm_nm, A.client_nm) firm_nm, A.car_no car_no, A.car_nm car_nm, A.car_name car_name, A.car_num,"+
				" decode(A.dlv_dt, '', '', substr(A.dlv_dt, 1, 4)||'-'||substr(A.dlv_dt, 5, 2)||'-'||substr(A.dlv_dt, 7, 2)) dlv_dt,"+
				" decode(A.init_reg_dt, '', '미등록', substr(A.init_reg_dt, 1, 4)||'-'||substr(A.init_reg_dt, 5, 2)||'-'||substr(A.init_reg_dt, 7, 2)) init_reg_dt,"+
				" A.gds_yn gds_yn, a.lpg_yn lpg_yn, B.car_off_nm bus_off, C.car_off_nm dlv_off, B.emp_nm emp_nm, decode(A.one_self,'Y','자체출고') one_self, y.bc_s_f, trunc(y.bc_s_f * 1.1) AS bc_s_f_2 "+
				" from"+
				" ("+
				" select c.use_yn, C.rent_mng_id, C.rent_l_cd, C.rent_dt, nvl(L.firm_nm, L.client_nm) firm_nm, L.client_nm, R.car_no, M.car_nm, R.init_reg_dt, R.car_num,"+
				" C.dlv_dt, P.gds_yn, E.lpg_yn, M.car_nm||' '||N.car_name car_name, P.one_self, P.rpt_no, C.bus_id, J.user_nm, J.br_id, J.user_id"+
				" from cont C, client L, car_reg R, car_pur P, car_etc E, car_nm N, car_mng M, users J, (select * from cls_cont where cls_st='5') S "+
				" ,(SELECT /*+ index(doc_settle DOC_SETTLE_IDX2  ) */ * FROM doc_settle  WHERE doc_st='4' AND doc_step='3' ) d"+
				" where C.client_id = L.client_id and"+
				" C.car_mng_id = R.car_mng_id(+) and"+
				" C.rent_mng_id = P.rent_mng_id and"+
				" C.rent_l_cd = P.rent_l_cd and"+
				" C.rent_mng_id = E.rent_mng_id and"+
				" C.rent_l_cd = E.rent_l_cd AND J.user_id = C.bus_id and "+
				" E.car_id = N.car_id and E.car_seq = N.car_seq and N.car_comp_id = M.car_comp_id and N.car_cd = M.code "+
				" and C.rent_mng_id=S.rent_mng_id(+) and C.reg_dt=S.reg_dt(+) and S.rent_l_cd is null"+
				" AND m.CAR_COMP_ID <= '0005' "+	
			  	"  "+sub_query+				
				" )A,"+
				" ("+
				" select M.rent_mng_id, M.rent_l_cd, M.emp_id, E.emp_nm, O.car_off_nm"+
				" from commi M, car_off_emp E, car_off O"+
				" where M.emp_id = E.emp_id and"+
				" M.agnt_st = '1' and"+
				" E.car_off_id = O.car_off_id"+
				" )B,"+
				" ("+
				" select M.rent_mng_id, M.rent_l_cd, M.emp_id, E.emp_nm, O.car_off_nm"+
				" from commi M, car_off_emp E, car_off O"+
				" where M.emp_id = E.emp_id and"+
				" M.agnt_st = '2' and m.emp_id<>'030849' and"+
				" E.car_off_id = O.car_off_id"+
				" )C, (select rent_mng_id, rent_l_cd, rent_st, bc_s_f from fee_etc where rent_st ='1') y  , OUT_CAR_MAGAM x"+
				" where A.rent_mng_id = B.rent_mng_id(+) and"+
				" A.rent_l_cd = B.rent_l_cd(+) and"+
				" A.rent_mng_id = C.rent_mng_id(+) and"+
				" A.rent_l_cd = C.rent_l_cd(+) and"+
				" A.rent_mng_id = y.rent_mng_id and"+
				" A.rent_l_cd = y.rent_l_cd AND A.rent_l_cd = x.rent_l_cd(+) and"+
 				" nvl(y.bc_s_f,0) > 0 and"+ 
				" A.one_self = 'Y' and nvl(a.use_yn,'Y') = 'Y' AND a.rent_l_cd NOT IN ('S112HGDR00029','S112KK5R00098')";

		if(gubun2.equals(""))  query +=" and x.save_dt like to_char(sysdate,'YYYYMM')||'%' and x.save_dt <= to_char(sysdate,'yyyymmdd')  ";

		if(gubun2.equals("2") && gubun3.equals("1"))	    query +=" and x.save_dt = to_char(sysdate-2,'YYYYMMDD') ";
		else if(gubun2.equals("2") && gubun3.equals("2"))	query +=" and x.save_dt = to_char(sysdate-1,'YYYYMMDD') ";
		else if(gubun2.equals("2") && gubun3.equals("3"))	query +=" and x.save_dt = to_char(sysdate,'YYYYMMDD') ";

		if(gubun2.equals("4"))	    query +=" and x.save_dt like '"+gubun4+"%"+gubun5+"%'";
		else if(gubun2.equals("5"))	query +=" and x.save_dt like '"+gubun6+"%'";
		else if(gubun2.equals("6")) query +=" and x.save_dt between replace(" + t_st_dt + ",'-','') and replace(" + t_end_dt + ",'-','') ";

		if(gubun2.equals("9") && gubun3.equals("S1")) query += " and A.br_id = 'S1' ";
		else if(gubun2.equals("9") && gubun3.equals("B1")) query += " and A.br_id = 'B1' ";
		else if(gubun2.equals("9") && gubun3.equals("D1")) query += " and A.br_id = 'D1' ";

		if(gubun2.equals("10")) query += " and A.user_id = '"+gubun4+"' ";
		if(gubun2.equals("11")) query += " and C.car_off_nm like '%"+gubun5+"%'";


		if(gubun6.equals("1")){ 
		}else if(gubun6.equals("2")){ 
			query +=" and x.save_dt = to_char(sysdate-1,'YYYYMMDD') ";
		}else if(gubun6.equals("3")){ 
			query +=" AND x.save_dt like to_char(add_months(sysdate,-1), 'YYYYMM')||'%' ";
		}else if(gubun6.equals("4")){ 
			query +=" and x.save_dt like to_char(sysdate,'YYYYMM')||'%' ";
		}

		query += " order by  A.init_reg_dt, A.dlv_dt ";

		try
		{
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
			System.out.println("[OutCarDatabase:getDlvStats_outAB]\n"+e);
			System.out.println("[OutCarDatabase:getDlvStats_outAB]\n"+query);
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

//자체출고현황
public Vector getDlvStats_out(String s_kd, String t_wd, String dt, String t_st_dt, String t_end_dt, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String save_dt )
  {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = " and C.dlv_dt is not null AND C.rent_l_cd=d.doc_id ";
		
		if(gubun7.equals("2")) {
			sub_query = " and C.rent_l_cd=d.doc_id(+) and C.car_st <> '2' ";
		}

		query = " select substr(a.car_num, -6, 6)as car_num2, A.user_nm, A.br_id, A.user_id, A.rpt_no, A.rent_l_cd, decode(A.rent_dt, '', '', substr(A.rent_dt, 1, 4)||'-'||substr(A.rent_dt, 5, 2)||'-'||substr(A.rent_dt, 7, 2)) rent_dt, nvl(A.firm_nm, A.client_nm) firm_nm, A.car_no car_no, A.car_nm car_nm, A.car_name car_name, A.car_num,"+
								" decode(A.dlv_dt, '', '', substr(A.dlv_dt, 1, 4)||'-'||substr(A.dlv_dt, 5, 2)||'-'||substr(A.dlv_dt, 7, 2)) dlv_dt,"+
								" decode(A.init_reg_dt, '', '미등록', substr(A.init_reg_dt, 1, 4)||'-'||substr(A.init_reg_dt, 5, 2)||'-'||substr(A.init_reg_dt, 7, 2)) init_reg_dt,"+
								" A.gds_yn gds_yn, a.lpg_yn lpg_yn, B.car_off_nm bus_off, C.car_off_nm dlv_off, B.emp_nm emp_nm, decode(A.one_self,'Y','자체출고') one_self, y.bc_s_f, trunc(y.bc_s_f * 1.1) AS bc_s_f_2 "+
						" from"+
						" ("+
							" select c.use_yn, C.rent_mng_id, C.rent_l_cd, C.rent_dt, nvl(L.firm_nm, L.client_nm) firm_nm, L.client_nm, R.car_no, M.car_nm, R.init_reg_dt, R.car_num,"+
									" C.dlv_dt, P.gds_yn, E.lpg_yn, M.car_nm||' '||N.car_name car_name, P.one_self, P.rpt_no, C.bus_id, J.user_nm, J.br_id, J.user_id"+
							" from cont C, client L, car_reg R, car_pur P, car_etc E, car_nm N, car_mng M, users J, (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st='5') S "+
							" ,(SELECT doc_id FROM doc_settle  WHERE doc_st='4' AND doc_step='3' ) d"+
							" where C.client_id = L.client_id and"+
									" C.car_mng_id = R.car_mng_id(+) and"+
								  	" C.rent_mng_id = P.rent_mng_id and"+
								  	" C.rent_l_cd = P.rent_l_cd and"+
								  	" C.rent_mng_id = E.rent_mng_id and"+
								  	" C.rent_l_cd = E.rent_l_cd AND J.user_id = C.bus_id and "+
								  	" E.car_id = N.car_id and E.car_seq = N.car_seq and N.car_comp_id = M.car_comp_id and N.car_cd = M.code "+
								  	" and C.rent_mng_id=S.rent_mng_id(+) and C.reg_dt=S.reg_dt(+) and S.rent_l_cd is null"+
								  	" AND m.CAR_COMP_ID <= '0005' "+	
								  	"  "+sub_query+
						" )A,"+
						" ("+
							" select M.rent_mng_id, M.rent_l_cd, M.emp_id, E.emp_nm, O.car_off_nm"+
							" from commi M, car_off_emp E, car_off O"+
							" where M.emp_id = E.emp_id and"+
									" M.agnt_st = '1' and"+
								  	" E.car_off_id = O.car_off_id"+
						" )B,"+
						" ("+
							" select M.rent_mng_id, M.rent_l_cd, M.emp_id, E.emp_nm, O.car_off_nm"+
							" from commi M, car_off_emp E, car_off O"+
							" where M.emp_id = E.emp_id and"+
									" M.agnt_st = '2' and m.emp_id<>'030849' and"+
									" E.car_off_id = O.car_off_id"+
						" )C, (select rent_mng_id, rent_l_cd, rent_st, bc_s_f from fee_etc where rent_st ='1') y "+
						" where A.rent_mng_id = B.rent_mng_id(+) and"+
								" A.rent_l_cd = B.rent_l_cd(+) and"+
							 	" A.rent_mng_id = C.rent_mng_id and"+
								" A.rent_l_cd = C.rent_l_cd and"+
								" A.rent_mng_id = y.rent_mng_id and"+
								" A.rent_l_cd = y.rent_l_cd and"+
         						" nvl(y.bc_s_f,0) > 0 and"+ 
								" A.one_self = 'Y' AND a.rent_l_cd NOT IN ('S112HGDR00029','S112KK5R00098')"; 

		String s_base_dt = "A.dlv_dt";
		
		if(!save_dt.equals("")&&gubun2.equals("")) {//자체출고현황 첫화면.
			query += "  AND ( a.init_reg_dt > replace('"+save_dt+"','-','') OR A.dlv_dt like to_char(sysdate,'YYYYMM')||'%' ) ";
		}else{//자체출고현황 조회검색 화면.
								
			//계약일기준
			if(gubun7.equals("2")) {
				s_base_dt = "A.rent_dt";						
			}
			
			if(gubun2.equals(""))  query +=" and "+s_base_dt+" like to_char(sysdate,'YYYYMM')||'%' and "+s_base_dt+" <= to_char(sysdate,'yyyymmdd')  ";

			if(gubun2.equals("2") && gubun3.equals("1"))	    query +=" and "+s_base_dt+" = to_char(sysdate-2,'YYYYMMDD') ";
			else if(gubun2.equals("2") && gubun3.equals("2"))	query +=" and "+s_base_dt+" = to_char(sysdate-1,'YYYYMMDD') ";
			else if(gubun2.equals("2") && gubun3.equals("3"))	query +=" and "+s_base_dt+" = to_char(sysdate,'YYYYMMDD') ";

			if(gubun2.equals("4"))	query +=" and "+s_base_dt+" like '"+gubun4+"%"+gubun5+"%'";
			if(gubun2.equals("5"))	query +=" and "+s_base_dt+" like '"+gubun6+"%'";
			if(gubun2.equals("6") && !t_st_dt.equals("") && !t_end_dt.equals("")) query +=" and "+s_base_dt+" between replace(" + t_st_dt + ",'-','') and replace(" + t_end_dt + ",'-','') ";
			
			if(gubun6.equals("1")){ 
			}else if(gubun6.equals("2")){ 
				query +=" and "+s_base_dt+" = to_char(sysdate-1,'YYYYMMDD') ";
			}else if(gubun6.equals("3")){ 
				query +=" AND "+s_base_dt+" like to_char(add_months(sysdate,-1), 'YYYYMM' )||'%' ";
			}else if(gubun6.equals("4")){ 
				query +=" and "+s_base_dt+" like to_char(sysdate,'YYYYMM')||'%' ";
			}else if(gubun6.equals("6") && !t_st_dt.equals("") && !t_end_dt.equals("")) {
				query +=" and "+s_base_dt+" between replace(" + t_st_dt + ",'-','') and replace(" + t_end_dt + ",'-','') ";
			}			

			if(gubun2.equals("9") && gubun3.equals("S1"))      query += " and A.br_id = 'S1' ";
			else if(gubun2.equals("9") && gubun3.equals("B1")) query += " and A.br_id = 'B1' ";
			else if(gubun2.equals("9") && gubun3.equals("D1")) query += " and A.br_id = 'D1' ";
			else if(gubun2.equals("9") && gubun3.equals("S2")) query += " and A.br_id = 'S2' ";
			else if(gubun2.equals("9") && gubun3.equals("S3")) query += " and A.br_id = 'S3' ";
			else if(gubun2.equals("9") && gubun3.equals("S4")) query += " and A.br_id = 'S4' ";
			else if(gubun2.equals("9") && gubun3.equals("G1")) query += " and A.br_id = 'G1' ";
			else if(gubun2.equals("9") && gubun3.equals("J1")) query += " and A.br_id = 'J1' ";
			else if(gubun2.equals("9") && gubun3.equals("I1")) query += " and A.br_id = 'I1' ";
			else if(gubun2.equals("9") && gubun3.equals("K1")) query += " and A.br_id = 'K1' ";
			else if(gubun2.equals("9") && gubun3.equals("U1")) query += " and A.br_id = 'U1' ";

			if(gubun2.equals("10")) query += " and A.user_id = '"+gubun4+"' ";
			if(gubun2.equals("11")) query += " and C.car_off_nm like '%"+gubun5+"%'";

			if(!t_wd.equals("")){
				query += " and A.firm_nm||A.client_nm||a.car_num like '%"+t_wd+"%' ";
			}

		}

		query += " order by  A.init_reg_dt, "+s_base_dt+" ";


		try
		{
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
			System.out.println("[OutCarDatabase:getDlvStats_out]\n"+e);
			System.out.println("[OutCarDatabase:getDlvStats_out]\n"+query);
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

	//자체출고캐쉬백 home
	public Vector getCarCashBackBaseStat()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT car_comp_id, car_off_id, "+
				"        NVL(SUM(DECODE(SUBSTR(base_dt,1,6),to_char(add_months(sysdate,-1),'YYYYMM'),base_amt)),0) amt4, "+
				"        NVL(SUM(DECODE(SUBSTR(base_dt,1,6),TO_CHAR(SYSDATE,'YYYYMM'),               base_amt)),0) amt6, "+
				"        NVL(SUM(base_amt),0) amt8, "+
				"        NVL(SUM(DECODE(SUBSTR(base_dt,1,6),to_char(add_months(sysdate,-1),'YYYYMM'),incom_amt)),0) amt5, "+
				"        NVL(SUM(DECODE(SUBSTR(base_dt,1,6),TO_CHAR(SYSDATE,'YYYYMM'),               incom_amt)),0) amt7, "+
				"        NVL(SUM(incom_amt),0) amt9, "+
				"        NVL(SUM(base_amt),0)-NVL(SUM(incom_amt),0) amt10 "+
				" FROM   car_stat_base  "+
				" where  base_dt BETWEEN to_char(add_months(sysdate,-1),'YYYYMM')||'01' AND TO_CHAR(LAST_DAY(SYSDATE),'YYYYMMDD') and nvl(use_yn,'Y')<>'N' "+
				" GROUP BY car_comp_id, car_off_id "+
				" ORDER BY car_comp_id, car_off_id "+
				" ";

		try
		{
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
			System.out.println("[OutCarDatabase:getCarCashBackBaseStat]\n"+e);
			System.out.println("[OutCarDatabase:getCarCashBackBaseStat]\n"+query);
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
	
	//자체출고캐쉬백 home 리스트
	public Vector getCarCashBackBaseList(String st, String car_off_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		String s_dt_where = "";

		//전월
		if(st.equals("1") || st.equals("4") || st.equals("5")){
			s_dt_where = " and a.base_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' ";	
		//당월
		}else if(st.equals("2")||st.equals("6")||st.equals("7")){
			s_dt_where = " and a.base_dt like to_char(sysdate,'YYYYMM')||'%' ";
		}else{ 
			s_dt_where = " and a.base_dt BETWEEN to_char(add_months(sysdate,-1),'YYYYMM')||'01' AND TO_CHAR(LAST_DAY(SYSDATE),'YYYYMMDD') ";
		}

		//적립금액+손익
		if(st.equals("4")||st.equals("6")||st.equals("8")){
			s_dt_where += " and (base_amt+nvl(m_amt,0)) <> 0 ";
		//입금
		}else if(st.equals("5")||st.equals("7")||st.equals("9")){
			s_dt_where += " and nvl(incom_amt,0) > 0 ";
		//미입금
		}else if(st.equals("10")){
			s_dt_where += " and nvl(incom_amt,0) = 0 ";
		//연체분
		}else if(st.equals("11")){
			s_dt_where = " and a.base_dt >= '20210101' and nvl(a.incom_amt,0) = 0 and a.est_dt < TO_CHAR(SYSDATE,'YYYYMMDD')  ";//and a.base_dt < to_char(add_months(sysdate,-1),'YYYYMM')||'01'
		}

		query = " select a.*, b.car_no, b.car_nm, CASE when NVL(a.incom_amt,0)=0 AND a.est_dt < TO_CHAR(SYSDATE,'YYYYMMDD') THEN 'dlv' ELSE '' END dlv_st "+ 
				" from   car_stat_base a, car_reg b "+
				" where  a.car_off_id='"+car_off_id+"' "+s_dt_where+"  and nvl(a.use_yn,'Y')<>'N' and a.car_mng_id=b.car_mng_id "+
				" order by a.base_dt, a.base_bigo";
		
		try
		{
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
			System.out.println("[OutCarDatabase:getCarCashBackBaseList]\n"+e);
			System.out.println("[OutCarDatabase:getCarCashBackBaseList]\n"+query);
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
	
	//자체출고캐쉬백 일일현황
	public Vector getCarCashBackDayCd(String s_yy)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT car_off_id FROM car_stat_base WHERE base_dt > '20190531' and nvl(use_yn,'Y')<>'N' ";
		
		if(!s_yy.equals("")) {
			query += " and base_dt LIKE '"+s_yy+"%' ";
		}

		query += " GROUP BY car_comp_id, car_off_id order by car_comp_id, car_off_id ";

		try
		{
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
			System.out.println("[OutCarDatabase:getCarCashBackDayCd]\n"+e);
			System.out.println("[OutCarDatabase:getCarCashBackDayCd]\n"+query);
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
	
	//자체출고캐쉬백 일일현황
	public Vector getCarCashBackDayStat(String s_yy, String s_mm, String[] pre)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT base_dt, SUBSTR(base_dt,7,2) day, ";
						
		for(int i=0 ; i<pre.length ; i++){
			query += "   '"+pre[i]+"' car_off_id"+(i+1)+", ";
		}
		
		query +="        NVL(SUM(base_amt),0) amt0,  ";
		
		for(int i=0 ; i<pre.length ; i++){
			query += "   NVL(SUM(DECODE(car_off_id,'"+pre[i]+"',base_amt)),0) amt"+(i+1)+", ";
		}

		query +="        0 amt99 "+
				" FROM   car_stat_base "+
				" WHERE  base_dt LIKE '"+s_yy+""+s_mm+"%' and nvl(use_yn,'Y')<>'N' "+
				" GROUP BY base_dt "+
				" ORDER BY base_dt "+
				" ";
		
		try
		{
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
			System.out.println("[OutCarDatabase:getCarCashBackDayStat]\n"+e);
			System.out.println("[OutCarDatabase:getCarCashBackDayStat]\n"+query);
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
	
	//자체출고캐쉬백 일일현황 list 
		public Vector getCarCashBackDayList(String s_yy, String s_mm, String base_dt, String car_off_id)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			
			query = " select a.*, b.car_nm, b.car_no, b.car_num "+ 
					" from   car_stat_base a, car_reg b "+
					" where  a.car_mng_id=b.car_mng_id ";

			if(!car_off_id.equals("")){
				query += " and a.car_off_id='"+car_off_id+"' ";
			}
			
			if(base_dt.equals("")){
				query += " and a.base_dt like '"+s_yy+s_mm+"%' ";
			}else{
				query += " and a.base_dt=replace('"+base_dt+"','-','') ";
			}

			query += "       and nvl(a.use_yn,'Y')<>'N' "+
					" ";
			
			query += " order by a.base_dt, a.base_bigo ";
			
			try
			{
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
				System.out.println("[OutCarDatabase:getCarCashBackDayList]\n"+e);
				System.out.println("[OutCarDatabase:getCarCashBackDayList]\n"+query);
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
		 *	카드사용 한건 조회
		 *  
		 */	
		public OutStatBean getCarCashBackBase(int serial)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			OutStatBean bean = new OutStatBean();
			String query = "";

			query = " select serial, rent_mng_id, rent_l_cd, car_mng_id, car_off_id, ven_code, base_bigo, base_dt, base_amt, "+
			        "        est_dt, use_yn, update_id, update_dt, incom_dt, incom_seq, incom_amt, m_amt, bank_id, bank_nm, bank_no, car_comp_id, incom_bigo  "+
					" from   car_stat_base "+
					" where  serial=? ";

			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setInt	(1,	serial);
		    	rs = pstmt.executeQuery(); 
	    	
				if(rs.next())
				{			
					bean.setSerial		(rs.getInt(1));
					bean.setRent_mng_id	(rs.getString(2));
					bean.setRent_l_cd	(rs.getString(3));
					bean.setCar_mng_id	(rs.getString(4));
					bean.setCar_off_id	(rs.getString(5));
					bean.setVen_code	(rs.getString(6));
					bean.setBase_bigo	(rs.getString(7));
					bean.setBase_dt		(rs.getString(8));
					bean.setBase_amt	(rs.getInt(9));
					bean.setEst_dt		(rs.getString(10));
					bean.setUse_yn		(rs.getString(11));
					bean.setUpdate_id	(rs.getString(12));
					bean.setUpdate_dt	(rs.getString(13));
					bean.setIncom_dt	(rs.getString(14));
					bean.setIncom_seq	(rs.getString(15));
					bean.setIncom_amt	(rs.getInt(16));
					bean.setM_amt		(rs.getInt(17));
					bean.setBank_id		(rs.getString(18));
					bean.setBank_nm		(rs.getString(19));
					bean.setBank_no		(rs.getString(20));
					bean.setCar_comp_id	(rs.getString(21));
					bean.setIncom_bigo	(rs.getString(22));
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				System.out.println("[OutCarDatabase:getCarCashBackBase(String serial)]\n"+e);
				System.out.println("[OutCarDatabase:getCarCashBackBase(String serial)]serial="+serial);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return bean;
			}		
		}	
		
		//카드사용 한건 취소
		public boolean updateCarStatCancel(OutStatBean bean)
		{
			getConnection();

			boolean flag = true;
			PreparedStatement pstmt = null;
			String query = "";

			query = " update car_stat_base set "+
					"	use_yn='N', update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
					" where serial=? "+
					" ";

			try 
			{
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString (1,		bean.getUpdate_id	());
				pstmt.setInt   	(2,		bean.getSerial		());
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
					
		  	} catch (Exception e) {
				System.out.println("[OutCarDatabase:updateCarStatCancel(OutStatBean bean)]\n"+e);
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
		
		//카드사용 한건 수정
		public boolean updateCarStatBase(OutStatBean bean)
		{
			getConnection();

			boolean flag = true;
			PreparedStatement pstmt = null;
			String query = "";

			query = " update car_stat_base set "+
					"	use_yn='C', base_amt=?, incom_amt=?, m_amt=?, update_dt=to_char(sysdate,'YYYYMMDD'), update_id=? "+
					" where serial=? "+
					" ";

			try 
			{
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setLong  	(1,		bean.getBase_amt	());
				pstmt.setLong  	(2,		bean.getIncom_amt	());
				pstmt.setLong  	(3,		bean.getM_amt		());
				pstmt.setString (4,		bean.getUpdate_id	());
				pstmt.setInt   	(5,		bean.getSerial		());
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
					
		  	} catch (Exception e) {
				System.out.println("[OutCarDatabase:updateCarStatBase(OutStatBean bean)]\n"+e);
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
		 *	월간현황 조회
		 */	
		public Vector getCarMonStat(String gubun1, String st_dt, String end_dt)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String s_dt_where = "";

			if(gubun1.equals("1")){
				s_dt_where = " like to_char(sysdate,'YYYYMM')||'%' ";
			}else if(gubun1.equals("2")){
				s_dt_where = " like to_char(add_months(sysdate,-1),'YYYYMM')||'%' ";	
			}else if(gubun1.equals("3")){
				s_dt_where = " between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			} 

			query = " SELECT c.car_off_id, c.car_off_nm, nvl(a.amt1,0) amt1, nvl(b.amt2,0) amt2 "+
					" FROM   (SELECT a.car_off_id, c.car_off_nm FROM car_stat_base a, car_off c WHERE (a.base_dt "+s_dt_where+" or a.incom_dt "+s_dt_where+") and a.car_off_id=c.car_off_id GROUP BY a.car_off_id, c.car_off_nm) c, "+
					"        (SELECT car_off_id, SUM(base_amt)  amt1 FROM car_stat_base WHERE base_dt  "+s_dt_where+" AND nvl(use_yn,'Y')<>'N' GROUP BY car_off_id) a, "+
					"        (SELECT car_off_id, SUM(incom_amt) amt2 FROM car_stat_base where incom_dt "+s_dt_where+" AND nvl(use_yn,'Y')<>'N' GROUP BY car_off_id) b "+
					" WHERE  c.car_off_id=a.car_off_id(+) AND c.car_off_id=b.car_off_id(+) AND (NVL(a.amt1,0)+NVL(b.amt2,0)) >0 "+
					" order by a.amt1 desc "+
					" ";

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
				System.out.println("[OutCarDatabase:getCarMonStat]\n"+e);
				System.out.println("[OutCarDatabase:getCarMonStat]\n"+query);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}		
		}
		
		/**
		 *	카드사별수금현황
		 */	
		public Vector getCarPayStat(String car_off_id, String s_yy, String s_mm)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			String s_dt_where = " LIKE '"+s_yy+""+s_mm+"%'";
			
			query = " SELECT a.*, b.car_no, b.car_nm, substr(b.car_num,-6, 6) car_num, a.base_amt-nvl(a.incom_amt,0)-nvl(a.m_amt,0) dly_amt, -1*nvl(a.m_amt,0) m_amt2 "+
					" FROM   car_stat_base a, car_reg b "+
					" where  a.base_dt "+s_dt_where+" AND a.car_off_id='"+car_off_id+"' and nvl(a.use_yn,'Y')<>'N' and a.car_mng_id=b.car_mng_id "+
					" ORDER BY a.base_dt, a.est_dt, a.incom_dt "+
					" ";			

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
				System.out.println("[OutCarDatabase:getCarPayStatAn]\n"+e);
				System.out.println("[OutCarDatabase:getCarPayStatAn]\n"+query);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}		
		}	
		
		/**
		 *	카드사별수금현황
		 */	
		public Vector getCarPayStat(String car_off_id, String s_yy, String s_mm, String gubun1, String st_dt, String end_dt)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			String s_dt_where = " LIKE '"+s_yy+""+s_mm+"%'";
			
			if(gubun1.equals("2")){
				s_dt_where = " between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			}
			
			if(gubun1.equals("3")){
				s_dt_where = " < to_char(add_months(sysdate,-1),'YYYYMM')||'01' and a.base_dt > '20210101' AND incom_dt IS NULL";
			}
			
			if(!car_off_id.equals("")){
				s_dt_where += " AND a.car_off_id='"+car_off_id+"' "; 
			}
			
			query = " SELECT a.*, b.car_no, b.car_nm, substr(b.car_num,-6, 6) car_num, a.base_amt-nvl(a.incom_amt,0)-nvl(a.m_amt,0) dly_amt, -1*nvl(a.m_amt,0) m_amt2 "+
					" FROM   car_stat_base a, car_reg b "+
					" where  a.base_dt "+s_dt_where+" and nvl(a.use_yn,'Y')<>'N' and a.car_mng_id=b.car_mng_id "+
					" ORDER BY a.base_dt, a.est_dt, a.incom_dt "+
					" ";			

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
				System.out.println("[OutCarDatabase:getCarPayStatAn]\n"+e);
				System.out.println("[OutCarDatabase:getCarPayStatAn]\n"+query);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}		
		}			
		
		/**
		 *	입금원장(캐쉬백)
		 */	
		public Vector getCarIncomStat(String car_off_id, String s_dt, String s_sort)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query = " SELECT a.*, b.car_no, b.car_nm, substr(b.car_num,-6, 6) car_num, substr(b.car_num,-5, 5) car_num2, substr(b.car_num,-6, 5) car_num3 "+
					" FROM   car_stat_base a, car_reg b "+
					" WHERE  a.base_dt > '20190531' and nvl(a.use_yn,'Y')<>'N' and a.car_mng_id=b.car_mng_id and NVL(a.incom_amt,0)=0 AND a.car_off_id='"+car_off_id+"' "+
					"        and a.base_amt <> 0 "+
					" ";

			if(!s_dt.equals("")){
				query += " and a.est_dt like replace('"+s_dt+"','-','')||'%' ";
			}

			if(s_sort.equals("2")){
				query += " ORDER BY a.est_dt, a.base_amt, a.base_dt, a.serial ";
			}else{
				query += " ORDER BY a.est_dt, a.base_dt, a.serial ";
			}
			

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
				System.out.println("[OutCarDatabase:getCarIncomStat]\n"+e);
				System.out.println("[OutCarDatabase:getCarIncomStat]\n"+query);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}		
		}
		
		/**
		 *	입금표발행
		 */	
		public Vector getCarPayebillStat(String car_off_id, String s_dt, String s_sort)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query = " SELECT a.car_comp_id, a.car_off_id, b.car_off_nm, a.incom_dt, COUNT(0) cnt, SUM(a.incom_amt) incom_amt \r\n"
					+ "FROM   car_stat_base a, car_off b \r\n"
					+ "WHERE  a.seqid is null and a.car_off_id=b.car_off_id and b.one_self_yn='Y' \r\n"
					+ " ";
					
			if(!car_off_id.equals("")){
				query += " and a.car_off_id = '"+car_off_id+"' \r\n";
			}
					
			if(!s_dt.equals("")){
				query += " and a.incom_dt like replace('"+s_dt+"','-','')||'%' \r\n";
			}
			
			query += " GROUP BY a.car_comp_id, a.car_off_id, b.car_off_nm, a.incom_dt \r\n";

			if(s_sort.equals("1")){
				query += " ORDER BY a.incom_dt ";
			}else{
				query += " ORDER BY b.car_off_nm, a.incom_dt ";
			}
			

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
				System.out.println("[OutCarDatabase:getCarPayebillStat]\n"+e);
				System.out.println("[OutCarDatabase:getCarPayebillStat]\n"+query);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}		
		}		
		
		/**
		 *	입금표발행
		 */	
		public Vector getCarStatEbillcodeList(String ebill_code)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query = " SELECT a.car_comp_id, a.car_off_id, b.car_off_nm, a.incom_dt, COUNT(0) cnt, SUM(a.incom_amt) incom_amt, substr(MIN(a.base_dt),5,2) b_mon \r\n"
					+ "FROM   car_stat_base a, car_off b \r\n"
					+ "WHERE  a.ebill_code='"+ebill_code+"' and a.car_off_id=b.car_off_id and b.one_self_yn='Y'  \r\n"
					+ "GROUP BY a.car_comp_id, a.car_off_id, b.car_off_nm, a.incom_dt ";
					
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
				System.out.println("[OutCarDatabase:getCarStatEbillcodeList]\n"+e);
				System.out.println("[OutCarDatabase:getCarStatEbillcodeList]\n"+query);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}		
		}		
				
		//카드스케줄 한건 수정
		public boolean updateCarStatScd(OutStatBean bean)
		{
			getConnection();

			boolean flag = true;
			PreparedStatement pstmt = null;
			String query = "";

			query = " update car_stat_base set "+
					"	incom_dt=replace(?, '-', ''), incom_seq=?, incom_amt=?, m_amt=?, incom_bigo=?, bank_id=?, bank_nm=?, bank_no=? "+
					" where serial=? "+
					" ";

			try 
			{
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,		bean.getIncom_dt	());
				pstmt.setString	(2,		bean.getIncom_seq	());
				pstmt.setLong  	(3,		bean.getIncom_amt	());
				pstmt.setLong  	(4,		bean.getM_amt		());
				pstmt.setString	(5,		bean.getIncom_bigo	());
				pstmt.setString	(6,		bean.getBank_id		());
				pstmt.setString	(7,		bean.getBank_nm		());
				pstmt.setString	(8,		bean.getBank_no		());
				pstmt.setInt   	(9,		bean.getSerial		());
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
					
		  	} catch (Exception e) {
				System.out.println("[OutCarDatabase:updateCarStatScd(OutStatBean bean)]\n"+e);
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
		
		//카드스케줄 입금표처리 1단계
		public boolean updateCarStatEbillcode(String ch_off_id, String ch_incom_dt, String ebill_code)
		{
			getConnection();

			boolean flag = true;
			PreparedStatement pstmt = null;
			String query = "";

			query = " update car_stat_base set ebill_code=? where car_off_id=? and incom_dt=? ";

			try 
			{
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,		ebill_code);
				pstmt.setString	(2,		ch_off_id);
				pstmt.setString	(3,		ch_incom_dt);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
					
		  	} catch (Exception e) {
				System.out.println("[OutCarDatabase:updateCarStatEbillcode]\n"+e);
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
		
		//카드스케줄 입금표처리 2단계
		public boolean updateCarStatSeqid(String ch_off_id, String ch_incom_dt, String seqid)
		{
			getConnection();

			boolean flag = true;
			PreparedStatement pstmt = null;
			String query = "";

			query = " update car_stat_base set seqid=? where car_off_id=? and incom_dt=? ";

			try 
			{
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,		seqid);
				pstmt.setString	(2,		ch_off_id);
				pstmt.setString	(3,		ch_incom_dt);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
					
		  	} catch (Exception e) {
				System.out.println("[OutCarDatabase:updateCarStatSeqid]\n"+e);
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
		
		//자체출고캐쉬백 약정현황
				public Vector getCarCashBackContStat(String car_off_id)
				{
					getConnection();
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					Vector vt = new Vector();
					String query = "";
					String search_query = "";
					
					if(!car_off_id.equals("")) {
						search_query = " car_off_id = '"+car_off_id+"' and ";
					}else {
						search_query = " car_off_id <> '00600' and "; //오금역대리점 제외
					}
					
					query = " SELECT a.*, b.nm, c.car_off_nm, c.cashback_est_dt, c.cashback_per, nvl(d.po_agnt_nm,c.agnt_nm) po_agnt_nm, nvl(d.po_agnt_o_tel,c.agnt_m_tel) po_agnt_o_tel \r\n"
							+ "FROM   (\r\n"
							+ "         SELECT car_comp_id, car_off_id\r\n"
							+ "         FROM   car_stat_base  \r\n"
							+ "         where  "+search_query+" base_dt BETWEEN to_char(add_months(sysdate,-2),'YYYYMM')||'01' AND TO_CHAR(LAST_DAY(SYSDATE),'YYYYMMDD') and nvl(use_yn,'Y')<>'N' and base_amt>0 \r\n"
							+ "         GROUP BY car_comp_id, car_off_id\r\n"
							+ "       ) a, \r\n"
							+ "       code b, car_off c, \r\n"
							+ "       ( SELECT * FROM partner_office WHERE po_gubun='1') d\r\n"
							+ "WHERE  a.car_comp_id=b.code AND b.c_st='0001' AND b.code<>'0000'\r\n"
							+ "       AND a.car_off_id=c.car_off_id      \r\n"
							+ "       AND a.car_off_id=d.off_id(+)\r\n"
							+ "ORDER BY 1,3";

					try
					{
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
						System.out.println("[OutCarDatabase:getCarCashBackContStat]\n"+e);
						System.out.println("[OutCarDatabase:getCarCashBackContStat]\n"+query);
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
				
//				
		//자체출고캐쉬백 수금현황
		public Vector getCarCashBackBillStat(String car_off_id, String s_yy, String s_mm)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String search_query = "";
			String this_month = "";
			String last_month = "";
			
			if(!car_off_id.equals("")) {
				search_query = " car_off_id = '"+car_off_id+"' and ";
			}
			
			if(!s_yy.equals("") && !s_mm.equals("")) {
				this_month = s_yy+""+s_mm;
				last_month = "to_char(add_months(to_date('"+s_yy+""+s_mm+"','YYYYMM'),-1),'YYYYMM')";
			}else {
				this_month = "to_char(sysdate,'YYYYMM')";
				last_month = "to_char(add_months(sysdate,-1),'YYYYMM')";
			}
										
			query = " select a.*, b.nm, c.car_off_nm, c.cashback_est_dt, c.cashback_per, "+this_month+" as this_month, "+last_month+" as last_month from ("
					+ " SELECT car_comp_id, car_off_id, \r\n"
					+ "       NVL(COUNT(DECODE(st,'1',car_off_id)),0) cnt1, \r\n"
					+ "       NVL(SUM  (DECODE(st,'1',base_amt)),0) amt1,\r\n"
					+ "       NVL(COUNT(DECODE(st,'1',DECODE(incom_amt,0,'',car_off_id))),0) cnt2, \r\n"
					+ "       NVL(SUM  (DECODE(st,'1',DECODE(incom_amt,0,0,base_amt))),0) amt2,\r\n"
					+ "       NVL(COUNT(DECODE(st,'1',DECODE(incom_amt,0,car_off_id))),0) cnt3, \r\n"
					+ "       NVL(SUM  (DECODE(st,'1',DECODE(incom_amt,0,base_amt))),0) amt3,\r\n"
					+ "       NVL(COUNT(DECODE(st,'2',car_off_id)),0) cnt4, \r\n"
					+ "       NVL(SUM  (DECODE(st,'2',base_amt)),0) amt4,\r\n"
					+ "       NVL(COUNT(DECODE(st,'2',DECODE(incom_amt,0,'',car_off_id))),0) cnt5, \r\n"
					+ "       NVL(SUM  (DECODE(st,'2',DECODE(incom_amt,0,0,base_amt))),0) amt5,\r\n"
					+ "       NVL(COUNT(DECODE(st,'2',DECODE(incom_amt,0,car_off_id))),0) cnt6, \r\n"
					+ "       NVL(SUM  (DECODE(st,'2',DECODE(incom_amt,0,base_amt))),0) amt6,\r\n"
					+ "       NVL(COUNT(DECODE(st,'1',car_off_id,'2',car_off_id)),0) cnt7, \r\n"
					+ "       NVL(SUM  (DECODE(st,'1',base_amt,'2',base_amt)),0) amt7,\r\n"
					+ "       NVL(COUNT(DECODE(st,'1',DECODE(incom_amt,0,'',car_off_id),'2',DECODE(incom_amt,0,'',car_off_id))),0) cnt8, \r\n"
					+ "       NVL(SUM  (DECODE(st,'1',DECODE(incom_amt,0,0,base_amt),'2',DECODE(incom_amt,0,0,base_amt))),0) amt8,\r\n"
					+ "       NVL(COUNT(DECODE(st,'1',DECODE(incom_amt,0,car_off_id),'2',DECODE(incom_amt,0,car_off_id))),0) cnt9, \r\n"
					+ "       NVL(SUM  (DECODE(st,'1',DECODE(incom_amt,0,base_amt),'2',DECODE(incom_amt,0,base_amt))),0) amt9,\r\n"
					+ "       NVL(COUNT(DECODE(st,'3',car_off_id)),0) cnt10, \r\n"
					+ "       NVL(SUM  (DECODE(st,'3',base_amt)),0) amt10,\r\n"
					+ "       NVL(COUNT(DECODE(st,'3',DECODE(incom_amt,0,'',car_off_id))),0) cnt11, \r\n"
					+ "       NVL(SUM  (DECODE(st,'3',DECODE(incom_amt,0,0,base_amt))),0) amt11,\r\n"
					+ "       NVL(COUNT(DECODE(st,'3',DECODE(incom_amt,0,car_off_id))),0) cnt12, \r\n"
					+ "       NVL(SUM  (DECODE(st,'3',DECODE(incom_amt,0,base_amt))),0) amt12,\r\n"
					+ "       NVL(COUNT(DECODE(st,'4',car_off_id)),0) cnt13, \r\n"
					+ "       NVL(SUM  (DECODE(st,'4',base_amt)),0) amt13,\r\n"
					+ "       NVL(COUNT(DECODE(st,'4',DECODE(incom_amt,0,'',car_off_id))),0) cnt14, \r\n"
					+ "       NVL(SUM  (DECODE(st,'4',DECODE(incom_amt,0,0,base_amt))),0) amt14,\r\n"
					+ "       NVL(COUNT(DECODE(st,'4',DECODE(incom_amt,0,car_off_id))),0) cnt15, \r\n"
					+ "       NVL(SUM  (DECODE(st,'4',DECODE(incom_amt,0,base_amt))),0) amt15,\r\n"
					+ "       NVL(COUNT(DECODE(st,'3',car_off_id,'4',car_off_id)),0) cnt16, \r\n"
					+ "       NVL(SUM  (DECODE(st,'3',base_amt,'4',base_amt)),0) amt16,\r\n"
					+ "       NVL(COUNT(DECODE(st,'3',DECODE(incom_amt,0,'',car_off_id),'4',DECODE(incom_amt,0,'',car_off_id))),0) cnt17, \r\n"
					+ "       NVL(SUM  (DECODE(st,'3',DECODE(incom_amt,0,0,base_amt),'4',DECODE(incom_amt,0,0,base_amt))),0) amt17,\r\n"
					+ "       NVL(COUNT(DECODE(st,'3',DECODE(incom_amt,0,car_off_id),'4',DECODE(incom_amt,0,car_off_id))),0) cnt18, \r\n"
					+ "       NVL(SUM  (DECODE(st,'3',DECODE(incom_amt,0,base_amt),'4',DECODE(incom_amt,0,base_amt))),0) amt18,\r\n"
					+ "       NVL(COUNT(car_off_id),0) cnt19, \r\n"
					+ "       NVL(SUM  (base_amt),0) amt19,\r\n"
					+ "       NVL(COUNT(DECODE(incom_amt,0,'',car_off_id)),0) cnt20, \r\n"
					+ "       NVL(SUM  (DECODE(incom_amt,0,0,base_amt)),0) amt20,\r\n"
					+ "       NVL(COUNT(DECODE(incom_amt,0,car_off_id)),0) cnt21, \r\n"
					+ "       NVL(SUM  (DECODE(incom_amt,0,base_amt)),0) amt21,       \r\n"
					+ "       '' etc\r\n"
					+ "FROM \r\n"
					+ "       (\r\n"
					+ "         --전월이월-전월출고\r\n"
					+ "         SELECT '1' st, car_comp_id, car_off_id, base_amt, NVL(incom_amt,0) incom_amt FROM car_stat_base WHERE "+search_query+" base_dt LIKE "+last_month+"||'%' and nvl(use_yn,'Y')<>'N'\r\n"
					+ "         UNION all \r\n"
					+ "         --전월이월-연체\r\n"
					+ "         SELECT '2' st, car_comp_id, car_off_id, base_amt, NVL(incom_amt,0) incom_amt FROM car_stat_base WHERE "+search_query+" base_dt > '20210101' AND base_dt < "+last_month+"||'01' and nvl(use_yn,'Y')<>'N' AND incom_dt IS NULL\r\n"
					+ "         UNION all\r\n"
					+ "         --당월출고-당월수금\r\n"
					+ "         SELECT '3' st, car_comp_id, car_off_id, base_amt, NVL(incom_amt,0) incom_amt FROM car_stat_base WHERE "+search_query+" base_dt LIKE "+this_month+"||'%' and nvl(use_yn,'Y')<>'N' AND est_dt LIKE "+this_month+"||'%'\r\n"
					+ "         UNION all\r\n"
					+ "         --당월출고-익월수금\r\n"
					+ "         SELECT '4' st, car_comp_id, car_off_id, base_amt, NVL(incom_amt,0) incom_amt FROM car_stat_base WHERE "+search_query+" base_dt LIKE "+this_month+"||'%' and nvl(use_yn,'Y')<>'N' AND est_dt > "+this_month+"||'31'\r\n"
					+ "       )\r\n"					
					+ "GROUP BY car_comp_id, car_off_id\r\n"
					+ ") a, code b, car_off c "
					+ "WHERE  a.car_comp_id=b.code AND b.c_st='0001' AND b.code<>'0000'\r\n"
					+ "       AND a.car_off_id=c.car_off_id      \r\n"
					+ "ORDER BY a.car_comp_id, a.car_off_id";

			try
			{
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
				System.out.println("[OutCarDatabase:getCarCashBackBillStat]\n"+e);
				System.out.println("[OutCarDatabase:getCarCashBackBillStat]\n"+query);
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
		
		//자체출고캐쉬백 수금현황
		public Vector getCarCashBackBillStat(String car_off_id, String s_yy, String s_mm, String gubun1, String st_dt, String end_dt)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			
            String s_dt_where = " LIKE '"+s_yy+""+s_mm+"%'";
			
			if(gubun1.equals("2")){
				s_dt_where = " between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			}
			
			if(!car_off_id.equals("")){
				s_dt_where += " AND car_off_id='"+car_off_id+"' "; 
			}
						
			
			query = " SELECT a.car_comp_id, a.car_off_id, d.nm, e.car_off_nm, e.cashback_est_dt,\r\n"
					+ "       a.cnt1, a.amt1, a.cnt2, a.amt2, a.cnt3, a.amt3, \r\n"
					+ "       NVL(b.cnt4,0) cnt4, NVL(b.amt4,0) amt4, NVL(c.cnt5,0) cnt5, NVL(c.amt5,0) amt5\r\n"
					+ "FROM   (\r\n"
					+ "         SELECT car_comp_id, car_off_id,\r\n"
					+ "                NVL(COUNT(car_off_id),0) cnt1, \r\n"
					+ "                NVL(SUM  (base_amt),0) amt1,\r\n"
					+ "                NVL(COUNT(DECODE(incom_dt,'','',car_off_id)),0) cnt2, \r\n"
					+ "                NVL(SUM  (DECODE(incom_dt,'',0,base_amt)),0) amt2,\r\n"
					+ "                NVL(COUNT(DECODE(incom_dt,'',car_off_id)),0) cnt3, \r\n"
					+ "                NVL(SUM  (DECODE(incom_dt,'',base_amt)),0) amt3,\r\n"
					+ "                '' etc\r\n"
					+ "         FROM   car_stat_base \r\n"
					+ "         WHERE  base_dt "+s_dt_where+" and nvl(use_yn,'Y')<>'N'\r\n"
					+ "         GROUP BY car_comp_id, car_off_id\r\n"
					+ "       ) a,\r\n"
					+ "       (\r\n"
					+ "         SELECT car_comp_id, car_off_id, COUNT(car_off_id) cnt4, SUM(base_amt) amt4          \r\n"
					+ "         FROM   car_stat_base\r\n"
					+ "         WHERE  base_dt "+s_dt_where+" AND incom_dt IS NULL AND est_dt > to_char(SYSDATE,'YYYYMMDD') and nvl(use_yn,'Y')<>'N'\r\n"
					+ "         GROUP BY car_comp_id, car_off_id\r\n"
					+ "       ) b,\r\n"
					+ "       (\r\n"
					+ "         SELECT car_comp_id, car_off_id, COUNT(car_off_id) cnt5, SUM(base_amt) amt5                   \r\n"
					+ "         FROM   car_stat_base\r\n"
					+ "         WHERE  base_dt "+s_dt_where+" AND incom_dt IS NULL AND est_dt < to_char(SYSDATE,'YYYYMMDD') and nvl(use_yn,'Y')<>'N'\r\n"
					+ "         GROUP BY car_comp_id, car_off_id\r\n"
					+ "       ) c, \r\n"
					+ "       code d, car_off e \r\n"
					+ "WHERE  a.car_off_id=b.car_off_id(+) AND a.car_off_id=c.car_off_id(+)       \r\n"
					+ "       AND a.car_comp_id=d.code AND d.c_st='0001' AND d.code<>'0000'\r\n"
					+ "			 AND a.car_off_id=e.car_off_id \r\n"
					+ "ORDER BY a.car_comp_id, a.car_off_id";

			try
			{
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
				System.out.println("[OutCarDatabase:getCarCashBackBillStat]\n"+e);
				System.out.println("[OutCarDatabase:getCarCashBackBillStat]\n"+query);
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
		
		//자체출고캐쉬백 연체
		public Vector getCarCashBackDlyStat()
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			
			query = " SELECT a.*, d.nm, e.car_off_nm, e.cashback_est_dt, f.car_no, f.car_nm \r\n"
					+ "FROM   (\r\n"
					+ "         SELECT * \r\n"
					+ "         FROM   car_stat_base\r\n"
					+ "         WHERE  base_dt >= '20210101' AND incom_dt IS NULL AND est_dt < to_char(SYSDATE,'YYYYMMDD') and nvl(use_yn,'Y')<>'N'\r\n"
					+ "       ) a, \r\n"
					+ "       code d, car_off e, car_reg f  \r\n"
					+ "WHERE  a.car_comp_id=d.code AND d.c_st='0001' AND d.code<>'0000'\r\n"
					+ "			 AND a.car_off_id=e.car_off_id and a.car_mng_id=f.car_mng_id \r\n"
					+ "ORDER BY a.est_dt";

			try
			{
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
				System.out.println("[OutCarDatabase:getCarCashBackDlyStat]\n"+e);
				System.out.println("[OutCarDatabase:getCarCashBackDlyStat]\n"+query);
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
		 *	카드사별수금현황
		 */	
		public Vector getCarPayStat(String st, String car_off_id, String s_car_off_id, String s_yy, String s_mm, String gubun1, String st_dt, String end_dt)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String this_month = "";
			String last_month = "";
			String s_dt_where = " LIKE '"+s_yy+""+s_mm+"%'";
			
			if(gubun1.equals("2")){
				s_dt_where = " between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','') ";
			}
			
			//연체
			if(gubun1.equals("3")){
				query = " SELECT a.*, b.car_no, b.car_nm, substr(b.car_num,-6, 6) car_num, a.base_amt-nvl(a.incom_amt,0)-nvl(a.m_amt,0) dly_amt, -1*nvl(a.m_amt,0) m_amt2 "+
						" FROM   car_stat_base a, car_reg b "+
						" where  a.car_off_id='"+s_car_off_id+"' and nvl(a.use_yn,'Y')<>'N' and a.base_dt >= '20210101' AND a.incom_dt IS NULL AND a.est_dt < to_char(SYSDATE,'YYYYMMDD') and a.car_mng_id=b.car_mng_id "+
						" ";
				
				query += " and a.base_dt "+s_dt_where+" ";

				
			}else {
				
				query = " SELECT a.*, b.car_no, b.car_nm, substr(b.car_num,-6, 6) car_num, a.base_amt-nvl(a.incom_amt,0)-nvl(a.m_amt,0) dly_amt, -1*nvl(a.m_amt,0) m_amt2 "+
						" FROM   car_stat_base a, car_reg b "+
						" where  a.car_off_id='"+s_car_off_id+"' and nvl(a.use_yn,'Y')<>'N' and a.car_mng_id=b.car_mng_id "+
						" ";					
				
				//거래처별현황 
				if(gubun1.equals("1") && !car_off_id.equals("")){
					
					if(!s_yy.equals("") && !s_mm.equals("")) {
						this_month = s_yy+""+s_mm;
						last_month = "to_char(add_months(to_date('"+s_yy+""+s_mm+"','YYYYMM'),-1),'YYYYMM')";
					}else {
						this_month = "to_char(sysdate,'YYYYMM')";
						last_month = "to_char(add_months(sysdate,-1),'YYYYMM')";
					}
					
					//전월출고
					if(st.equals("1")){
						query += " AND a.base_dt like "+last_month+"||'%' ";						
					}else if(st.equals("2")){
						query += " AND a.base_dt like "+last_month+"||'%' and a.incom_dt is not null "; 
					}else if(st.equals("3")){
						query += " AND a.base_dt like "+last_month+"||'%' and a.incom_dt is null ";
					//연체	
					}else if(st.equals("4") || st.equals("5") || st.equals("6")){
						query += " AND a.base_dt >= '20210101' and a.base_dt < "+last_month+"||'01' AND a.est_dt < to_char(sysdate,'YYYYMMDD') and a.incom_dt is null ";
					//전월이월	
					}else if(st.equals("7")){
						query += " AND ( a.base_dt like "+last_month+"||'%' or (a.base_dt >= '20210101' and a.base_dt < "+last_month+"||'01' AND a.est_dt < to_char(sysdate,'YYYYMMDD') AND incom_dt IS NULL) )";
					}else if(st.equals("8")){
						query += " AND ( a.base_dt like "+last_month+"||'%' or (a.base_dt >= '20210101' and a.base_dt < "+last_month+"||'01' AND a.est_dt < to_char(sysdate,'YYYYMMDD') AND incom_dt IS NULL) ) and a.incom_dt is not null";
					}else if(st.equals("9")){
						query += " AND ( a.base_dt like "+last_month+"||'%' or (a.base_dt >= '20210101' and a.base_dt < "+last_month+"||'01' AND a.est_dt < to_char(sysdate,'YYYYMMDD') AND incom_dt IS NULL) ) and a.incom_dt is null";
					//당월수금	
					}else if(st.equals("10")){
						query += " AND a.base_dt like "+this_month+"||'%' AND a.est_dt like "+this_month+"||'%' ";		
					}else if(st.equals("11")){
						query += " AND a.base_dt like "+this_month+"||'%' AND a.est_dt like "+this_month+"||'%' and a.incom_dt is not null ";
					}else if(st.equals("12")){
						query += " AND a.base_dt like "+this_month+"||'%' AND a.est_dt like "+this_month+"||'%' and a.incom_dt is null ";
					//익월수금	
					}else if(st.equals("13")){
						query += " AND a.base_dt like "+this_month+"||'%' AND a.est_dt > "+this_month+"||'31' ";
					}else if(st.equals("14")){
						query += " AND a.base_dt like "+this_month+"||'%' AND a.est_dt > "+this_month+"||'31' and a.incom_dt is not null ";
					}else if(st.equals("15")){
						query += " AND a.base_dt like "+this_month+"||'%' AND a.est_dt > "+this_month+"||'31' and a.incom_dt is  null ";
					//소계	
					}else if(st.equals("16")){
						query += " AND a.base_dt like "+this_month+"||'%' ";
					}else if(st.equals("17")){
						query += " AND a.base_dt like "+this_month+"||'%' and a.incom_dt is not null";
					}else if(st.equals("18")){
						query += " AND a.base_dt like "+this_month+"||'%' and a.incom_dt is null ";
					//합계	
					}else if(st.equals("19")){
						query += " AND ( a.base_dt like "+last_month+"||'%' or a.base_dt like "+this_month+"||'%' or (a.base_dt >= '20210101' and a.base_dt < "+last_month+"||'01' AND a.est_dt < to_char(sysdate,'YYYYMMDD') AND incom_dt IS NULL) )";
					}else if(st.equals("20")){
						query += " AND ( a.base_dt like "+last_month+"||'%' or a.base_dt like "+this_month+"||'%' or (a.base_dt >= '20210101' and a.base_dt < "+last_month+"||'01' AND a.est_dt < to_char(sysdate,'YYYYMMDD') AND incom_dt IS NULL) ) and a.incom_dt is not null";
					}else if(st.equals("21")){
						query += " AND ( a.base_dt like "+last_month+"||'%' or a.base_dt like "+this_month+"||'%' or (a.base_dt >= '20210101' and a.base_dt < "+last_month+"||'01' AND a.est_dt < to_char(sysdate,'YYYYMMDD') AND incom_dt IS NULL) ) and a.incom_dt is null";
					}
				//통합현황	
				}else {
					
					if(st.equals("1") || st.equals("2") || st.equals("3") || st.equals("4")){
						query += " AND a.base_dt "+s_dt_where;
					}else {
						query += " and a.base_dt "+s_dt_where+" AND a.incom_dt IS NULL AND a.est_dt < to_char(SYSDATE,'YYYYMMDD') ";
					}
					
					if(st.equals("2")){
						query += " AND a.incom_dt is not null ";
					}else if(st.equals("3")){
						query += " AND a.incom_dt is null ";
					}else if(st.equals("4")){
						query += " AND a.est_dt > to_char(sysdate,'YYYYMMDD') ";
					}
				}
				
			}
			
			query += " ORDER BY a.base_dt, a.est_dt, a.incom_dt ";

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
				System.out.println("[OutCarDatabase:getCarPayStatAn]\n"+e);
				System.out.println("[OutCarDatabase:getCarPayStatAn]\n"+query);
		  		e.printStackTrace();
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}		
		}			

		//--------------------------------------------------------------------------------
		
}
