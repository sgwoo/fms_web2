package acar.client;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.common.*;
import acar.cont.*;

public class ClientDatabase
{
	private Connection conn = null;
	public static ClientDatabase db;
	
	public static ClientDatabase getInstance()
	{
		if(ClientDatabase.db == null)
			ClientDatabase.db = new ClientDatabase();
		return ClientDatabase.db;	
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

	public ClientBean getClient(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ClientBean client = new ClientBean();

		String query = " select CLIENT_ID, CLIENT_ST, CLIENT_NM, FIRM_NM,"+
						" substr( TEXT_DECRYPT(ssn, 'pw' ) , 1, 6) SSN1, substr( TEXT_DECRYPT(ssn, 'pw' ) , 7, 7) SSN2,"+
						" substr(ENP_NO, 1, 3) ENP_NO1, substr(ENP_NO, 4, 2) ENP_NO2, substr(ENP_NO, 6, 5)  ENP_NO3,"+
		 				" H_TEL, O_TEL, M_TEL, HOMEPAGE, FAX,"+
						"  BUS_CDT, BUS_ITM, HO_ADDR, HO_ZIP, O_ADDR, O_ZIP, COM_NM, DEPT, TITLE,"+
						"  CAR_USE, CON_AGNT_NM, CON_AGNT_O_TEL, CON_AGNT_M_TEL, CON_AGNT_FAX, CON_AGNT_EMAIL, CON_AGNT_DEPT,"+
						" CON_AGNT_TITLE, ETC from CLIENT where CLIENT_ID = ? ";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				client.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				client.setClient_st(rs.getString("CLIENT_ST")==null?"":rs.getString("CLIENT_ST"));
				client.setClient_nm(rs.getString("CLIENT_NM")==null?"":rs.getString("CLIENT_NM"));
				client.setFirm_nm(rs.getString("FIRM_NM")==null?"":rs.getString("FIRM_NM"));
				client.setSsn1(rs.getString("SSN1")==null?"":rs.getString("SSN1"));
				client.setSsn2(rs.getString("SSN2")==null?"":rs.getString("SSN2"));
				client.setEnp_no1(rs.getString("ENP_NO1")==null?"":rs.getString("ENP_NO1"));
				client.setEnp_no2(rs.getString("ENP_NO2")==null?"":rs.getString("ENP_NO2"));
				client.setEnp_no3(rs.getString("ENP_NO3")==null?"":rs.getString("ENP_NO3"));
				client.setH_tel(rs.getString("H_TEL")==null?"":rs.getString("H_TEL"));
				client.setO_tel(rs.getString("O_TEL")==null?"":rs.getString("O_TEL"));
				client.setM_tel(rs.getString("M_TEL")==null?"":rs.getString("M_TEL"));
				client.setHomepage(rs.getString("HOMEPAGE")==null?"":rs.getString("HOMEPAGE"));
				client.setFax(rs.getString("FAX")==null?"":rs.getString("FAX"));
				client.setBus_cdt(rs.getString("BUS_CDT")==null?"":rs.getString("BUS_CDT"));
				client.setBus_itm(rs.getString("BUS_ITM")==null?"":rs.getString("BUS_ITM"));
				client.setHo_addr(rs.getString("HO_ADDR")==null?"":rs.getString("HO_ADDR"));
				client.setHo_zip(rs.getString("HO_ZIP")==null?"":rs.getString("HO_ZIP"));
				client.setO_addr(rs.getString("O_ADDR")==null?"":rs.getString("O_ADDR"));
				client.setO_zip(rs.getString("O_ZIP")==null?"":rs.getString("O_ZIP"));
				client.setCom_nm(rs.getString("COM_NM")==null?"":rs.getString("COM_NM"));
				client.setDept(rs.getString("DEPT")==null?"":rs.getString("DEPT"));
				client.setTitle(rs.getString("TITLE")==null?"":rs.getString("TITLE"));
				client.setCar_use(rs.getString("CAR_USE")==null?"":rs.getString("CAR_USE"));
				client.setCon_agnt_nm(rs.getString("CON_AGNT_NM")==null?"":rs.getString("CON_AGNT_NM"));
				client.setCon_agnt_o_tel(rs.getString("CON_AGNT_O_TEL")==null?"":rs.getString("CON_AGNT_O_TEL"));
				client.setCon_agnt_m_tel(rs.getString("CON_AGNT_M_TEL")==null?"":rs.getString("CON_AGNT_M_TEL"));
				client.setCon_agnt_fax(rs.getString("CON_AGNT_FAX")==null?"":rs.getString("CON_AGNT_FAX"));
				client.setCon_agnt_email(rs.getString("CON_AGNT_EMAIL")==null?"":rs.getString("CON_AGNT_EMAIL"));
				client.setCon_agnt_dept(rs.getString("CON_AGNT_DEPT")==null?"":rs.getString("CON_AGNT_DEPT"));
				client.setCon_agnt_title(rs.getString("CON_AGNT_TITLE")==null?"":rs.getString("CON_AGNT_TITLE"));
				client.setEtc(rs.getString("ETC")==null?"":rs.getString("ETC"));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
	  		e.printStackTrace();
	  		client = null;
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return client;
		}
	}
	
	public ClientBean insertClient(ClientBean client)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String id_sql = " select ltrim(to_char(to_number(MAX(client_id))+1, '000000')) ID from CLIENT ";
		String c_id="";
		try{
				pstmt1 = conn.prepareStatement(id_sql);
		    	rs = pstmt1.executeQuery();
		    	if(rs.next())
		    	{
		    		c_id=rs.getString(1)==null?"":rs.getString(1);
		    	}
				rs.close();
				pstmt1.close();

		} catch (SQLException e) {
	  		e.printStackTrace();
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  	}
	  	
		if(c_id.equals(""))	c_id = "000001";
		client.setClient_id(c_id);
		
		String query = " insert into CLIENT ( CLIENT_ID, CLIENT_ST, CLIENT_NM, FIRM_NM, SSN, ENP_NO, H_TEL, O_TEL, M_TEL, "+
						" HOMEPAGE, FAX, BUS_CDT, BUS_ITM, HO_ADDR, HO_ZIP, O_ADDR, O_ZIP, COM_NM, DEPT, TITLE, CAR_USE, "+
						" CON_AGNT_NM, CON_AGNT_O_TEL, CON_AGNT_M_TEL, CON_AGNT_FAX, CON_AGNT_EMAIL, CON_AGNT_DEPT, "+
						" CON_AGNT_TITLE, ETC ) values ("+
						" ?, ?, ?, ?, TEXT_ENCRYPT(?, 'pw' ),  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client.getClient_id());
			pstmt.setString(2, client.getClient_st());
			pstmt.setString(3, client.getClient_nm());
			pstmt.setString(4, client.getFirm_nm());
			pstmt.setString(5, client.getSsn1()+client.getSsn2());
			pstmt.setString(6, client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			pstmt.setString(7, client.getH_tel());
			pstmt.setString(8, client.getO_tel());
			pstmt.setString(9, client.getM_tel());
			pstmt.setString(10, client.getHomepage());
			pstmt.setString(11, client.getFax());
			pstmt.setString(12, client.getBus_cdt());
			pstmt.setString(13, client.getBus_itm());
			pstmt.setString(14, client.getHo_addr());
			pstmt.setString(15, client.getHo_zip());
			pstmt.setString(16, client.getO_addr());
			pstmt.setString(17, client.getO_zip());
			pstmt.setString(18, client.getCom_nm());
			pstmt.setString(19, client.getDept());
			pstmt.setString(20, client.getTitle());
			pstmt.setString(21, client.getCar_use());
			pstmt.setString(22, client.getCon_agnt_nm());
			pstmt.setString(23, client.getCon_agnt_o_tel());
			pstmt.setString(24, client.getCon_agnt_m_tel());
			pstmt.setString(25, client.getCon_agnt_fax());
			pstmt.setString(26, client.getCon_agnt_email());
			pstmt.setString(27, client.getCon_agnt_dept());
			pstmt.setString(28, client.getCon_agnt_title());
			pstmt.setString(29, client.getEtc());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return client;
		}
	}
	
	public boolean updateClient(ClientBean client)
	{
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = " update CLIENT set "+
						" CLIENT_ST = ?, "+
						" CLIENT_NM = ?, "+
						" FIRM_NM = ?, "+
						" SSN = TEXT_ENCRYPT(?, 'pw' ), "+
						" ENP_NO = ?, "+
						" H_TEL = ?, "+
						" O_TEL = ?, "+
						" M_TEL = ?, "+
						" HOMEPAGE = ?, "+
						" FAX = ?, "+
						" BUS_CDT = ?, "+
						" BUS_ITM = ?, "+
						" HO_ADDR = ?, "+
						" HO_ZIP = ?, "+
						" O_ADDR = ?, "+
						" O_ZIP = ?, "+
						" COM_NM = ?, "+
						" DEPT = ?, "+
						" TITLE = ?, "+
						" CAR_USE = ?, "+
						" CON_AGNT_NM = ?, "+
						" CON_AGNT_O_TEL = ?, "+
						" CON_AGNT_M_TEL = ?, "+
						" CON_AGNT_FAX = ?, "+
						" CON_AGNT_EMAIL = ?, "+
						" CON_AGNT_DEPT = ?, "+
						" CON_AGNT_TITLE = ?, "+
						" ETC = ? "+
						" where CLIENT_ID = ?";
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client.getClient_st());
			pstmt.setString(2, client.getClient_nm());
			pstmt.setString(3, client.getFirm_nm());
			pstmt.setString(4, client.getSsn1()+client.getSsn2());
			pstmt.setString(5, client.getEnp_no1()+client.getEnp_no2()+client.getEnp_no3());
			pstmt.setString(6, client.getH_tel());
			pstmt.setString(7, client.getO_tel());
			pstmt.setString(8, client.getM_tel());
			pstmt.setString(9,  client.getHomepage());
			pstmt.setString(10, client.getFax());
			pstmt.setString(11, client.getBus_cdt());
			pstmt.setString(12, client.getBus_itm());
			pstmt.setString(13, client.getHo_addr());
			pstmt.setString(14, client.getHo_zip());
			pstmt.setString(15, client.getO_addr());
			pstmt.setString(16, client.getO_zip());
			pstmt.setString(17, client.getCom_nm());
			pstmt.setString(18, client.getDept());
			pstmt.setString(19, client.getTitle());
			pstmt.setString(20, client.getCar_use());
			pstmt.setString(21, client.getCon_agnt_nm());
			pstmt.setString(22, client.getCon_agnt_o_tel());
			pstmt.setString(23, client.getCon_agnt_m_tel());
			pstmt.setString(24, client.getCon_agnt_fax());
			pstmt.setString(25, client.getCon_agnt_email());
			pstmt.setString(26, client.getCon_agnt_dept());
			pstmt.setString(27, client.getCon_agnt_title());
			pstmt.setString(28, client.getEtc());
			pstmt.setString(29, client.getClient_id());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
		} catch (SQLException e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
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
	 *	gubun - 1:상호, 2:계약자명, 3: 전화번호, 4:휴대폰, 5: 주소
	 */
	public Vector getClientList(String gubun, String kwd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query +="select C.CLIENT_ID CLIENT_ID, C.CLIENT_ST CLIENT_ST, C.CLIENT_NM CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM,"+
				" decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '개인사업자(일반과세)', '4', '개인사업자(간이과세)', '5','개인사업자(면세사업자)') CLIENT_ST_NM,"+
				" C.CON_AGNT_NM CON_AGNT_NM, C.O_TEL O_TEL, C.M_TEL M_TEL, C.HOMEPAGE HOMEPAGE, "+
				" C.FAX FAX, C.O_ADDR O_ADDR "+
				"from client C ";
		
		if(gubun.equals("1"))			query += "where nvl(C.firm_nm, ' ') like '%"+kwd+"%'";
		else if(gubun.equals("2"))		query += "where nvl(C.client_nm, ' ') like '%"+kwd+"%'";
		else if(gubun.equals("3"))		query += "where nvl(C.o_tel, ' ')  like '%"+kwd+"%'";
		else if(gubun.equals("4"))		query += "where nvl(C.m_tel, ' ')  like '%"+kwd+"%'";
		else if(gubun.equals("5"))		query += "where nvl(C.o_addr, ' ')  like '%"+kwd+"%'";
		
		query += " order by C.firm_nm";
		
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
	 *	gubun - 1: 상호 2: 계약자, 3:담당자, 4: 전화번호, 5:휴대폰, 6:주소
	 *	asc - 1 : 내림차순, 0: 오름차순
	 */	
	public Vector getClientList2(String gubun, String kwd, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "select C.CLIENT_ID CLIENT_ID, C.CLIENT_ST CLIENT_ST, C.CLIENT_NM CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM,"+
							" decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '개인사업자(일반과세)', '4', '개인사업자(간이과세)') CLIENT_ST_NM,"+
							" C.CON_AGNT_NM CON_AGNT_NM, C.O_TEL O_TEL, C.M_TEL M_TEL, C.HOMEPAGE HOMEPAGE, "+
							" C.FAX FAX, C.O_ADDR O_ADDR "+
						"from client C ";
		if(gubun.equals("2"))		
			query += "where nvl(C.client_nm, ' ') like '%"+kwd+"%'"+
					" order by C.firm_nm";
		else if(gubun.equals("3"))		
			query += "where nvl(C.CON_AGNT_NM, ' ') like '%"+kwd+"%'"+
					" order by C.CON_AGNT_NM";
		else if(gubun.equals("4"))		
			query += "where nvl(C.o_tel, ' ')  like '%"+kwd+"%'"+
					" order by C.o_tel";
		else if(gubun.equals("5"))		
			query += "where nvl(C.m_tel, ' ')  like '%"+kwd+"%'"+
					" order by C.m_tel";
		else if(gubun.equals("6"))		
			query += "where nvl(C.o_addr, ' ')  like '%"+kwd+"%'"+
					" order by C.o_addr";
		else
			query += "where nvl(C.firm_nm, ' ') like '%"+kwd+"%'"+
					" order by nvl(C.firm_nm, C.client_nm)";

		if(asc.equals("0"))		query += " asc";
		else if(asc.equals("1"))	query += " desc";

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
	 *	gubun - 1:상호, 2:계약자명, 3: 전화번호, 4:휴대폰, 5: 주소
	 */
	public Hashtable getClientStat(String gubun, String kwd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " select max(c1) C1, max(c2) C2, max(c3) C3, max(c4) C4, max(c5) C5, (max(c1)+max(c2)+max(c3)+max(c4)+max(c5)) CT\n"+
						" from\n"+
						" (\n"+
							" select sum(c1) c1, sum(c2) c2, sum(c3) c3, sum(c4) c4, sum(c5) c5\n"+
							" from\n"+
							" (\n"+
								" select\n"+
									" C.client_st,\n"+
									" decode(C.client_st, '1', 1, 0) c1,\n"+	//'1', '법인', '2', '개인', '3', '개인사업자(일반과세)', '4', '개인사업자(간이과세), '5:개인사업자(면세)'
									" decode(C.client_st, '2', 1, 0) c2,\n"+	
									" decode(C.client_st, '3', 1, 0) c3,\n"+ 	
									" decode(C.client_st, '4', 1, 0) c4,\n"+
									" decode(C.client_st, '5', 1, 0) c5\n"+
								" from client C\n";

		query +=" )\n"+
				" group by client_st order by client_st\n"+
				" )";

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
	 *	고객별 계약리스트
	 */
	public Vector getContList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select st, firm_nm, rent_mng_id, rent_l_cd, car_mng_id, car_no, user_nm, user_nm2, user_nm3, rent_start_dt, rent_end_dt,\n"+
				"        is_run, is_run_num, rent_dt, CAR_NM, CAR_NAME, rent_way, r_site_seq, r_site, rent_st, grt_amt_s, decode(client_guar_st,'1','입보','2','면제') client_guar_st, enp_no \n"+
				" from   \n"+
				"        (\n"+
				"          SELECT '1' st, C.rent_mng_id RENT_MNG_ID, C.rent_l_cd RENT_L_CD, C.car_mng_id, R.car_no CAR_NO, U.user_nm USER_NM, U2.user_nm USER_NM2, U3.user_nm USER_NM3,\n"+
				"                 decode(F.rent_start_dt, '', '', substr(F.rent_start_dt, 1, 4)||'-'||substr(F.rent_start_dt, 5, 2)||'-'||substr(F.rent_start_dt, 7, 2)) RENT_START_DT,\n"+
				"                 decode(F.rent_end_dt, '', '', substr(F.rent_end_dt, 1, 4)||'-'||substr(F.rent_end_dt, 5, 2)||'-'||substr(F.rent_end_dt, 7, 2)) RENT_END_DT,\n"+ 
				"                 decode(C.use_yn, 'N', '해약', '','대기', decode(F.rent_start_dt, '', '신규', '대여')) IS_RUN, decode(C.use_yn, 'N', '2', decode(F.rent_start_dt, '', '1', '0')) IS_RUN_NUM,\n"+
				"                 decode(nvl(F.rent_dt,C.rent_dt), '', '', substr(nvl(F.rent_dt,C.rent_dt), 1, 4)||'-'||substr(nvl(F.rent_dt,C.rent_dt), 5, 2)||'-'||substr(nvl(F.rent_dt,C.rent_dt), 7, 2)) rent_dt,\n"+ 
				"                 M.CAR_NM, N.car_NAME, DECODE(F.rent_way, '1', '일반식', '2', '맞춤식', '3','기본식') rent_way, C.r_site as r_site_seq, S.r_site, F.rent_st, F.grt_amt_s, A.client_guar_st, L.enp_no, L.firm_nm \n"+
				"          FROM   CONT C, CLIENT L, CAR_REG R, FEE F, USERS U, USERS U2, USERS U3, "+
				"                 CAR_ETC E, CAR_NM N, CAR_MNG M, client_site S, cont_etc A "+
				"          WHERE  C.client_id =? "+
				"                 and C.client_id = L.client_id "+
				"                 and C.car_mng_id = R.car_mng_id(+) "+
				"                 and C.rent_l_cd = F.rent_l_cd and C.rent_mng_id = F.rent_mng_id "+
				"                 and C.bus_id = U.user_id "+
				"                 and C.bus_id2 = U2.user_id "+
				"                 and C.mng_id = U3.user_id "+
				"                 and C.rent_mng_id=E.rent_mng_id and C.rent_l_cd=E.rent_l_cd "+
				"                 and E.car_id=N.car_id and E.car_seq=N.car_seq "+
				"                 and N.car_comp_id=M.car_comp_id and N.car_cd=M.code "+
				"                 and C.client_id=S.client_id(+) and C.r_site=S.seq(+) "+
				"                 and C.rent_mng_id=A.rent_mng_id(+) and C.rent_l_cd=A.rent_l_cd(+) "+
				" union all "+
				"          SELECT '2' st, C.rent_mng_id RENT_MNG_ID, C.rent_l_cd RENT_L_CD, C.car_mng_id, R.car_no CAR_NO, U.user_nm USER_NM, U2.user_nm USER_NM2, U3.user_nm USER_NM3,\n"+
				"                 decode(F.rent_start_dt, '', '', substr(F.rent_start_dt, 1, 4)||'-'||substr(F.rent_start_dt, 5, 2)||'-'||substr(F.rent_start_dt, 7, 2)) RENT_START_DT,\n"+
				"                 decode(F.rent_end_dt, '', '', substr(F.rent_end_dt, 1, 4)||'-'||substr(F.rent_end_dt, 5, 2)||'-'||substr(F.rent_end_dt, 7, 2)) RENT_END_DT,\n"+ 
				"                 decode(C.use_yn, 'N', '해약', '','대기', decode(F.rent_start_dt, '', '신규', '대여')) IS_RUN, decode(C.use_yn, 'N', '2', decode(F.rent_start_dt, '', '1', '0')) IS_RUN_NUM,\n"+
				"                 decode(nvl(F.rent_dt,C.rent_dt), '', '', substr(nvl(F.rent_dt,C.rent_dt), 1, 4)||'-'||substr(nvl(F.rent_dt,C.rent_dt), 5, 2)||'-'||substr(nvl(F.rent_dt,C.rent_dt), 7, 2)) rent_dt,\n"+ 
				"                 M.CAR_NM, N.car_NAME, DECODE(F.rent_way, '1', '일반식', '2', '맞춤식', '3','기본식') rent_way, C.r_site as r_site_seq, S.r_site, F.rent_st, F.grt_amt_s, A.client_guar_st, L.enp_no, L.firm_nm \n"+
				"          FROM   CONT C, CLIENT L, CAR_REG R, FEE F, USERS U, USERS U2, USERS U3, "+
				"                 CAR_ETC E, CAR_NM N, CAR_MNG M, client_site S, cont_etc A "+
				"          WHERE  C.client_id<>? "+
				"                 and C.client_id = L.client_id and L.enp_no is not null and L.enp_no in (select enp_no from client where client_id=? and client_st<>'2')"+
				"                 and C.car_mng_id = R.car_mng_id(+) "+
				"                 and C.rent_l_cd = F.rent_l_cd and C.rent_mng_id = F.rent_mng_id "+
				"                 and C.bus_id = U.user_id "+
				"                 and C.bus_id2 = U2.user_id "+
				"                 and C.mng_id = U3.user_id "+
				"                 and C.rent_mng_id=E.rent_mng_id and C.rent_l_cd=E.rent_l_cd "+
				"                 and E.car_id=N.car_id and E.car_seq=N.car_seq "+
				"                 and N.car_comp_id=M.car_comp_id and N.car_cd=M.code "+
				"                 and C.client_id=S.client_id(+) and C.r_site=S.seq(+) "+
				"                 and C.rent_mng_id=A.rent_mng_id(+) and C.rent_l_cd=A.rent_l_cd(+) "+

				
				"        )\n"+
				" order by st, is_run_num, rent_dt desc";

//System.out.println("getCarList"+query);

		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
				pstmt.setString(2, client_id);
				pstmt.setString(3, client_id);
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
	 *	고객별 계약리스트
	 */
	public Vector getContArsList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select rent_mng_id, rent_l_cd, car_mng_id, car_no, user_nm, user_nm2, rent_start_dt, rent_end_dt,\n"+
				"        is_run, is_run_num, rent_dt, CAR_NM, CAR_NAME, rent_way, r_site, rent_st, grt_amt_s, decode(client_guar_st,'1','입보','2','면제') client_guar_st \n"+
				" from   \n"+
				"        (\n"+
				"          SELECT C.rent_mng_id RENT_MNG_ID, C.rent_l_cd RENT_L_CD, C.car_mng_id, R.car_no CAR_NO, U.user_nm USER_NM, U2.user_nm USER_NM2,\n"+
				"                 decode(B.rent_start_dt, '', '', substr(B.rent_start_dt, 1, 4)||'-'||substr(B.rent_start_dt, 5, 2)||'-'||substr(B.rent_start_dt, 7, 2)) RENT_START_DT,\n"+
				"                 decode(B.rent_end_dt, '', '', substr(B.rent_end_dt, 1, 4)||'-'||substr(B.rent_end_dt, 5, 2)||'-'||substr(B.rent_end_dt, 7, 2)) RENT_END_DT,\n"+ 
				"                 decode(C.use_yn, 'N', '해약', '','대기', decode(F.rent_start_dt, '', '신규', '대여')) IS_RUN, decode(C.use_yn, 'N', '2', decode(F.rent_start_dt, '', '1', '0')) IS_RUN_NUM,\n"+
				"                 decode(C.rent_dt, '', '', substr(C.rent_dt, 1, 4)||'-'||substr(C.rent_dt, 5, 2)||'-'||substr(C.rent_dt, 7, 2)) rent_dt,\n"+ 
				"                 M.CAR_NM, N.car_NAME, DECODE(F.rent_way, '1', '일반식', '2', '맞춤식', '3','기본식') rent_way, S.r_site, F.rent_st, F.grt_amt_s, A.client_guar_st \n"+
				"          FROM   CONT C, CLIENT L, CAR_REG R, FEE F, USERS U, USERS U2, "+
				"                 CAR_ETC E, CAR_NM N, CAR_MNG M, client_site S, cont_etc A, "+
				"                 (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) B "+
				"          WHERE  C.client_id =? "+
				"                 and C.client_id = L.client_id "+
				"                 and C.car_mng_id = R.car_mng_id(+) "+
				"                 and C.rent_l_cd = F.rent_l_cd and C.rent_mng_id = F.rent_mng_id "+
				"                 and C.bus_id = U.user_id "+
				"                 and C.bus_id2 = U2.user_id "+
				"                 and C.rent_mng_id=E.rent_mng_id and C.rent_l_cd=E.rent_l_cd "+
				"                 and E.car_id=N.car_id and E.car_seq=N.car_seq "+
				"                 and N.car_comp_id=M.car_comp_id and N.car_cd=M.code "+
				"                 and C.client_id=S.client_id(+) and C.r_site=S.seq(+) "+
				"                 and C.rent_mng_id=A.rent_mng_id(+) and C.rent_l_cd=A.rent_l_cd(+) "+
				"                 and F.rent_mng_id=B.rent_mng_id and F.rent_l_cd=B.rent_l_cd and F.rent_st=B.rent_st "+
				"          order by nvl(F.rent_dt,C.rent_dt), F.rent_start_dt"+
				"        )\n"+
				" order by is_run_num";

//System.out.println("getCarList"+query);

		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
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
	 *	고객별 월렌트 계약리스트
	 */
	public Vector getRMContList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT  /*+ RULE */ \n"+
				"        a.car_mng_id, a.rent_s_cd, a.rent_dt,  \n"+
				"        b.car_no, B.CAR_NM, \n"+
				"        substr(NVL(a.deli_dt,a.rent_start_dt),1,8) rent_start_dt, substr(NVL(a.ret_dt,a.rent_end_dt),1,8) rent_end_dt, a.rent_months, a.rent_days, \n"+
				"        c.user_nm, c2.user_nm as user_nm2, \n"+
				"        DECODE(a.use_st,'1','예약','2','배차','3','반차','4','정산','5','취소') use_st, \n"+
				"        a.etc \n"+
				" FROM   RENT_CONT a, CAR_REG b, USERS c, USERS c2 \n"+
				" WHERE  a.cust_id=? AND a.RENT_ST='12' \n"+
				"        AND a.car_mng_id=b.car_mng_id \n"+
				"        AND a.bus_id=c.user_id \n"+
				"        AND a.mng_id=c2.user_id(+) \n"+
				" order by a.rent_dt desc ";


		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
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
	 *	고객별 월렌트 계약리스트
	 */
	public Vector getOLContList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT /*+ RULE */ \n"+
				"        a.car_mng_id, a.cont_dt, a.mm_pr, a.migr_dt, a.migr_no, a.sui_st, c.DAMDANG_ID, \n"+
				"        b.car_no, B.CAR_NM, \n"+
				"        d.firm_nm, e.user_nm \n"+
				" FROM   SUI a, CAR_REG b, APPRSL c, CLIENT d, users e \n"+
				" WHERE  a.client_id=? \n"+
				"        AND a.car_mng_id=b.car_mng_id \n"+
				"        AND a.car_mng_id=c.car_mng_id(+) \n"+
				"        AND c.actn_id=d.client_id(+) \n"+
				"        AND c.DAMDANG_ID=e.user_id(+) "+
				" ORDER BY a.cont_dt desc ";


		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
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
	 *	고객별 계약리스트 2004.10.8. Yongsoon Kwon.
	 */
	public Vector getContList2(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select rent_mng_id, rent_l_cd, car_no, user_nm, rent_start_dt, rent_end_dt,\n"+
						" is_run, is_run_num, rent_dt, CAR_NM, CAR_NAME, rent_way\n"+
					"from\n"+
					"(\n"+
						"SELECT C.rent_mng_id RENT_MNG_ID, C.rent_l_cd RENT_L_CD, R.car_no CAR_NO, U.user_nm USER_NM,\n"+
								" decode(F.rent_start_dt, '', '', substr(F.rent_start_dt, 1, 4)||'-'||substr(F.rent_start_dt, 5, 2)||'-'||substr(F.rent_start_dt, 7, 2)) RENT_START_DT,\n"+
								" decode(F.rent_end_dt, '', '', substr(F.rent_end_dt, 1, 4)||'-'||substr(F.rent_end_dt, 5, 2)||'-'||substr(F.rent_end_dt, 7, 2)) RENT_END_DT,\n"+ 
								" decode(C.use_yn, 'N', '해약', decode(F.rent_start_dt, '', '신규', '대여')) IS_RUN, decode(C.use_yn, 'N', '2', decode(F.rent_start_dt, '', '1', '0')) IS_RUN_NUM,\n"+
								" decode(C.rent_dt, '', '', substr(C.rent_dt, 1, 4)||'-'||substr(C.rent_dt, 5, 2)||'-'||substr(C.rent_dt, 7, 2)) rent_dt,\n"+ 
								" M.CAR_NM, N.car_NAME, DECODE(F.rent_way, '1', '일반식', '2', '맞춤식', '3', '기본식') rent_way\n"+
						" FROM CONT C, CLIENT L, CAR_REG R, (select * from fee a where a.rent_st = (select max(b.rent_st) from fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd)) F, USERS U,"+
					  "      CAR_ETC E, CAR_NM N, CAR_MNG M"+
						" WHERE C.client_id = L.client_id AND"+
							  " C.car_mng_id = R.car_mng_id(+) AND"+
							  " C.rent_l_cd = F.rent_l_cd AND"+
							  " C.rent_mng_id = F.rent_mng_id AND"+
							  " C.bus_id = U.user_id AND"+
							  " C.rent_mng_id=E.rent_mng_id and C.rent_l_cd=E.rent_l_cd and E.car_id=N.car_id and E.car_seq=N.car_seq"+
							  " and N.car_comp_id=M.car_comp_id and N.car_cd=M.code and"+
							  " C.client_id =?"+
							  " order by C.rent_start_dt"+
					")\n"+
					"order by is_run_num";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
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
	 *	거래처메모INSERT
	 */
	public boolean insertClientMM(ClientMMBean c_mm)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String id_sql = " select nvl(ltrim(to_char(to_number(MAX(seq))+1, '0000')), '0001') ID from CLIENT_MM where CLIENT_ID=?";
		String seq="";
		String query = " insert into CLIENT_MM ( CLIENT_ID, REG_ID, CONTENT, REG_DT, SEQ ) values (?, ?, ?, replace(?, '-', ''), ?)";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(id_sql);
			pstmt.setString(1, c_mm.getClient_id());
		   	rs = pstmt.executeQuery();
		   	while(rs.next())
		   	{
		   		seq=rs.getString(1)==null?"":rs.getString(1);
		   	}
			rs.close();
			pstmt.close();

		    c_mm.setSeq(seq);

			pstmt1 = conn.prepareStatement(query);
			pstmt1.setString(1, c_mm.getClient_id());
			pstmt1.setString(2, c_mm.getReg_id());
			pstmt1.setString(3, c_mm.getContent());
			pstmt1.setString(4, c_mm.getReg_dt());
			pstmt1.setString(5, c_mm.getSeq());
		    pstmt1.executeUpdate();
			pstmt1.close();

			conn.commit();

		} catch (SQLException e) {
			flag = false;
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
	  		flag = false;
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	거래처별 메모 리스트
	 */
	public Vector getClientMMs(String client_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" CLIENT_ID, REG_ID, CONTENT, SEQ,"+
							" decode(REG_DT, '', '', substr(REG_DT, 1, 4)||'-'||substr(REG_DT, 5, 2)||'-'||substr(REG_DT, 7, 2)) REG_DT"+
							" from client_mm "+
							" where CLIENT_ID = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ClientMMBean c_mm = new ClientMMBean();
				c_mm.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				c_mm.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				c_mm.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				c_mm.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				c_mm.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				vt.add(c_mm);
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
	 *	고객 USER ID INSERT
	 */
	public boolean insertClientUser(ClientUserBean c_user)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " insert into CL_USER ( USER_ID, USER_PSD, CLIENT_ID ) values (?, ?, ?)";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_user.getUser_id());
			pstmt.setString(2, c_user.getUser_psd());
			pstmt.setString(3, c_user.getClient_id());
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (SQLException e) {
			flag = false;
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
	  		flag = false;
	  		e.printStackTrace();
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
	 *	고객 USER ID UPDATE
	 */
	public boolean updateClientUser(ClientUserBean c_user)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " update CL_USER set USER_ID = ?, USER_PSD = ?"+
						" where CLIENT_ID = ?";
		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_user.getUser_id());
			pstmt.setString(2, c_user.getUser_psd());
		    pstmt.setString(3, c_user.getClient_id());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (SQLException e) {
			flag = false;
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
	  		flag = false;
	  		e.printStackTrace();
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
	 *	고객 USER ID UPDATE
	 */
	public boolean deleteClientUser(String client_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = " delete from CL_USER"+
						" where CLIENT_ID = ?";
		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		    pstmt.setString(1, client_id);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (SQLException e) {
			flag = false;
	  		e.printStackTrace();
			conn.rollback();
	  	} catch (Exception e) {
	  		flag = false;
	  		e.printStackTrace();
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
	 *	고객 USER ID
	 */
	public ClientUserBean getClientUser(String client_id)
	{
		getConnection();
		ClientUserBean c_user = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select"+
							" rtrim(USER_ID) USER_ID, USER_PSD, CLIENT_ID"+
							" from CL_USER"+
							" where CLIENT_ID = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				c_user = new ClientUserBean();
				c_user.setUser_id(rs.getString("USER_ID")==null?"":rs.getString("USER_ID"));
				c_user.setUser_psd(rs.getString("USER_PSD")==null?"":rs.getString("USER_PSD"));
				c_user.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
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
			return c_user;
		}
	}	
}
