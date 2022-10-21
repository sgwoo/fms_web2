package tax;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.common.*;
import acar.cont.*;

public class ClientMngDatabase 
{
	private Connection conn = null;
	public static ClientMngDatabase db;
	
	public static ClientMngDatabase getInstance()
	{
		if(ClientMngDatabase.db == null)
			ClientMngDatabase.db = new ClientMngDatabase();
		return ClientMngDatabase.db;	
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

	/**
	 *	거래처관리 : 거래처조회리스트
	 *  chk1(사업구분), chk2(법인구분), chk4(발행구분), chk3(거래구분)
	 */	
	public Vector getClientMngList(String chk1, String chk2, String chk3, String chk4, String gubun1, String gubun2, String gubun3, String gubun4, String s_kd, String t_wd1, String t_wd2, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";

		//본사
		query1 = " select "+
				 " a.client_id, decode(a.client_st,'1','법인','2','개인','개인사업자') client_st,"+
				 " decode(a.print_st,'2','거래처통합','3','지점통합','개별발행') print_st,"+
				 " '본사' site_st, "+	
				 " a.firm_nm, a.client_nm, a.enp_no,  TEXT_DECRYPT(a.ssn, 'pw' ) ssn, a.ven_code, nvl(a.update_dt,a.reg_dt) as update_dt, nvl(a.update_id,a.reg_id) update_id,"+
				 " b.cnt1, c.cnt2, d.cnt3"+
				 " from client a,"+
				 " (select client_id, count(rent_l_cd) cnt1 from cont      group by client_id) b,"+
				 " (select cust_id,   count(rent_s_cd) cnt2 from rent_cont where rent_st in ('1','9') and use_st<>'5' and cust_st='1' group by cust_id) c,"+
				 " (select client_id, count(car_mng_id) cnt3 from sui      group by client_id) d"+
				 " where"+
				 " a.client_id=b.client_id(+)"+
				 " and a.client_id=c.cust_id(+)"+
				 " and a.client_id=d.client_id(+)";

		query2 = " select"+ 
				 " a.client_id, decode(a.client_st,'1','법인','2','개인','개인사업자') client_st,"+ 
				 " '본사' client_type, decode(a.print_st,'2','거래처통합','3','지점통합','개별발행') print_st,"+ 
				 " decode(e.site_st,'1','지점','2','현장','현장') site_st,"+ 
				 " a.firm_nm||' '||e.r_site as firm_nm, e.site_jang as client_nm, e.enp_no, TEXT_DECRYPT(a.ssn, 'pw' ) ssn, "+ 
				 " e.ven_code, nvl(e.upd_dt,e.reg_dt) as update_dt, nvl(e.upd_id,e.reg_id) as update_id,"+ 
				 " b.cnt1, c.cnt2, d.cnt3"+ 
				 " from client a,"+ 
				 " (select client_id, r_site, count(rent_l_cd) cnt1 from cont      group by client_id, r_site) b,"+ 
				 " (select cust_id,           count(rent_s_cd) cnt2 from rent_cont where rent_st in ('1','9') and use_st<>'5' and cust_st='1' group by cust_id) c,"+ 
				 " (select client_id,         count(car_mng_id) cnt3 from sui      group by client_id) d, client_site e"+ 
				 " where"+ 
				 " e.client_id=b.client_id(+) and e.seq=b.r_site(+)"+ 
				 " and e.client_id=c.cust_id(+)"+ 
				 " and e.client_id=d.client_id(+)"+ 
				 " and e.client_id=a.client_id";
		
		
		if(chk2.equals("1"))		query = query1;
		else						query = query2;

		if(t_wd1.equals("") && t_wd2.equals("")){

			//사업구분
			if(chk1.equals("1"))		query += " and a.client_st='1'";
			if(chk1.equals("2"))		query += " and a.client_st='2'";
			if(chk1.equals("3"))		query += " and a.client_st not in ('1','2')";

			//발행구분
			if(chk3.equals("1"))		query += " and nvl(a.print_st,'1')='1'";		
			if(chk3.equals("2"))		query += " and a.print_st='2'";		
			if(chk3.equals("3"))		query += " and a.print_st='3'";		
			if(chk3.equals("4"))		query += " and a.print_st='4'";		

			//거래구분
			if(chk4.equals("1"))		query += " and b.cnt1 > 1";
			if(chk4.equals("2"))		query += " and c.cnt2 > 1";
			if(chk4.equals("3"))		query += " and d.cnt3 > 1";

		}else{

			String search = "";
			if(s_kd.equals("1"))		search = "a.firm_nm";
			else if(s_kd.equals("2"))	search = "a.client_nm";
			else if(s_kd.equals("3"))	search = "a.enp_no";
			else if(s_kd.equals("4"))	search = "a.ssn";
			else if(s_kd.equals("5"))	search = "a.bus_cdt";
			else if(s_kd.equals("6"))	search = "a.bus_itm";

			if(!t_wd1.equals("") && !t_wd2.equals(""))	query += " and ("+search+" like '%"+t_wd1+"%' or "+search+" like '%"+t_wd2+"%')";
			if(!t_wd1.equals("") && t_wd2.equals(""))	query += " and  "+search+" like '%"+t_wd1+"%'";

		}

		if(sort.equals("1"))		query += " order by replace(replace(replace(replace(replace(a.firm_nm,'(자)',''),'(합)',''),'(사)',''),'(유)',''),'(주)','') "+asc;
		if(sort.equals("2"))		query += " order by a.enp_no "+asc+", TEXT_DECRYPT(a.ssn, 'pw' ) "+asc;
		if(sort.equals("3"))		query += " order by a.o_zip "+asc;
		if(sort.equals("4"))		query += " order by nvl(nvl(a.update_dt,a.reg_dt),'00000000') desc";

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
			System.out.println("[ClientMngDatabase:getTaxClientList]\n"+e);
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
	 *	거래처관리 : 거래처조회리스트
	 */	
	public Vector getClientMngList(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";
		String where2 = "";

		if(s_br.equals(""))		where = " and nvl(brch_id,'"+s_br+"') like '%"+s_br+"%'";
		
		if(s_kd.equals("3") && !t_wd.equals(""))	where2 = " and rent_l_cd like '%"+t_wd+"%'";
		
		//본사
		query = " select "+
				 " a.client_id, decode(a.client_st,'1','법인','2','개인','개인사업자') client_st,"+
				 " decode(a.print_st,'2','거래처통합','3','지점통합','개별발행') print_st,"+
				 " '본사' site_st, "+	
				 " a.firm_nm, a.client_nm, a.enp_no, TEXT_DECRYPT(a.ssn, 'pw' )  ssn, a.m_tel, a.ven_code, nvl(a.update_dt,a.reg_dt) as update_dt, nvl(a.update_id,a.reg_id) update_id,"+
				 " b.cnt1, c.cnt2, d.cnt3"+
				 " from client a,  "+ //cont e,
				 " (select client_id, count(rent_l_cd) cnt1 from cont      where 1=1 "+where+" "+where2+" group by client_id) b,"+
				 " (select cust_id,   count(rent_s_cd) cnt2 from rent_cont where rent_st in ('1','9') and use_st<>'5' and cust_st='1' group by cust_id) c,"+
				 " (select client_id, count(car_mng_id) cnt3 from sui      group by client_id) d"+
				 " where"+
				 " a.client_id=b.client_id(+)"+
				 " and a.client_id=c.cust_id(+)"+
				 " and a.client_id=d.client_id(+)" +
				 //" and a.client_id = e.client_id(+) "+
				 " ";		

		String search = "a.firm_nm";
		if(s_kd.equals("1"))		search = "a.firm_nm ";
		else if(s_kd.equals("2"))	search = "a.client_nm ";
		//else if(s_kd.equals("3"))	search = "e.rent_l_cd ";  // 채권 회수에서 사용 

		if(!t_wd.equals("") && !s_kd.equals("3"))	query += " and  "+search+" like '%"+t_wd+"%'";

		query += " order by replace(replace(replace(replace(replace(a.firm_nm,'(자)',''),'(합)',''),'(사)',''),'(유)',''),'(주)','')";


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
			System.out.println("[ClientMngDatabase:getTaxClientList]\n"+e);
			System.out.println("[ClientMngDatabase:getTaxClientList]\n"+query);
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
	 *	거래처관리 : 거래처조회리스트
	 */	
	public Vector getRentListSearch(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select  a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm, c.car_num, a.rent_start_dt, a.rent_end_dt, d.cls_dt, a.car_st, a.bus_id2 \n"+
				" from cont_n_view a, car_reg c, cls_cont d , client e \n"+
				" where  a.car_mng_id = c.car_mng_id(+) and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+) and a.client_id = e.client_id ";
	
		if(s_kd.equals("1"))		query += " and a.car_st != '4' and a.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and a.car_st != '4' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and a.car_st != '4' and c.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and a.car_st != '4' and a.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and nvl(a.use_yn, 'Y') ='Y' and a.car_st = '4' and a.firm_nm like '%"+t_wd+"%'";  //월렌트 한정
		else if(s_kd.equals("6"))	query += " and nvl(a.use_yn, 'Y') ='Y' and a.car_st = '4' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 한정
		else if(s_kd.equals("7"))	query += " and nvl(a.use_yn, 'Y') ='Y' and a.firm_nm like '%"+t_wd+"%'";  //월렌트 포함
		else if(s_kd.equals("8"))	query += " and a.use_yn='Y' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 포함
		else if(s_kd.equals("9"))	query += " and  c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 포함
		else if(s_kd.equals("11"))	query += " and  e.enp_no like '%"+t_wd+"%'";    //월렌트 포함
		else						query += " and a.firm_nm like '%"+t_wd+"%'";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";

		query += " order by a.use_yn desc, a.rent_dt desc";


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
			System.out.println("[ClientMngDatabase:getRentListSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getRentListSearch]\n"+query);
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
	 *	거래처관리 : 거래처조회리스트
	 */	
	public Vector getRentListSearch(String s_br, String s_kd, String t_wd, String t_wd_chk)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select distinct a.client_id, a.firm_nm, a.client_nm "+
				" from cont_n_view a, car_reg b \n "+
				" where  a.car_mng_id = b.car_mng_id(+) ";
		//대한의사인 경우 한꺼번에 검색하도록		
		if (t_wd_chk.equals("Y") && t_wd.equals("대한의사") ) { 
			   query += " and a.client_id in ('002102', '001190', '001705', '001187')";
		} else {	
			if(s_kd.equals("1"))		query += " and a.firm_nm like '%"+t_wd+"%'";
			else if(s_kd.equals("2"))	query += " and b.car_no||' '||b.first_car_no like '%"+t_wd+"%'";
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
			System.out.println("[ClientMngDatabase:getRentListSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getRentListSearch]\n"+query);
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
	 *	거래처관리 : 거래처조회리스트
	 */	
	public Vector getRentListClientCngSearch(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm, c.car_num, a.rent_start_dt, a.rent_end_dt, d.cls_dt, a.car_st \n"+
				" from cont_n_view a, car_reg c, cls_cont d \n"+
				" where  a.car_mng_id = c.car_mng_id and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+) and a.rent_start_dt is not null and d.rent_l_cd is null ";
	
		if(s_kd.equals("1"))		query += " and a.car_st != '4' and a.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and a.car_st != '4' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and a.car_st != '4' and c.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and a.car_st != '4' and a.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.use_yn='Y' and a.car_st = '4' and a.firm_nm like '%"+t_wd+"%'";  //월렌트 한정
		else if(s_kd.equals("6"))	query += " and a.use_yn='Y' and a.car_st = '4' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 한정
		else if(s_kd.equals("7"))	query += " and a.use_yn='Y' and a.firm_nm like '%"+t_wd+"%'";  //월렌트 포함
		else if(s_kd.equals("8"))	query += " and a.use_yn='Y' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 포함
		else if(s_kd.equals("9"))	query += " and a.use_yn='N' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 포함
		else						query += " and a.firm_nm like '%"+t_wd+"%'";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";

		query += " order by a.use_yn desc, a.rent_dt desc";

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
			System.out.println("[ClientMngDatabase:getRentListClientCngSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getRentListClientCngSearch]\n"+query);
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
	 *	거래처관리 : 거래처상세내용 - 장기대여리스트
	 */	
	public Vector getClientMngLongRentCont(String client_id, String site_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" a.use_yn, a.rent_mng_id, a.rent_l_cd, a.client_id, a.r_site as site_id, a.bus_id2, e.user_nm, b.car_no, b.car_nm, g.car_name, "+
				" decode(c.rent_start_dt,'00000000','',c.rent_start_dt) rent_start_dt,"+
				" decode(c.rent_end_dt,'99999999','',c.rent_end_dt) rent_end_dt, "+
				" decode(h.rent_way, '1','일반식','2','맞춤식','3','기본식') rent_way,"+
				" c.con_mon, (h.fee_s_amt+h.fee_v_amt) as fee_amt, d.br_nm, a.p_zip, a.p_addr, a.tax_agnt,"+
				" decode(a.tax_type, '2','지점','3','현장','본사') tax_type"+
				" from cont a, car_reg b, branch d, users e, car_etc f, car_nm g, fee h,"+
				" (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(nvl(rent_start_dt,'00000000')) rent_start_dt, max(nvl(rent_end_dt,'99999999')) rent_end_dt from fee group by rent_mng_id, rent_l_cd) c"+
				" where a.client_id='"+client_id+"'"+
				" and a.car_mng_id=b.car_mng_id "+
				" and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd"+
				" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
				" and c.rent_mng_id=h.rent_mng_id and c.rent_l_cd=h.rent_l_cd and c.rent_st=h.rent_st"+	
				" and f.car_id=g.car_id and f.car_seq=g.car_seq"+
				" and h.br_id=d.br_id(+) and a.bus_id2=e.user_id";

		if(!site_id.equals("")) query += " and a.r_site='"+site_id+"'";

		query += " order by a.use_yn desc, decode(c.rent_start_dt,'00000000','',c.rent_start_dt) desc";
		
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
			System.out.println("[ClientMngDatabase:getClientMngLongRentCont]\n"+e);
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
	 *	거래처관리 : 거래처상세내용 - 거래처별 사업자등록증 이력조회
	 */	
	public Vector getClientMngEnpHList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	   	query =  " select client_id, seq, firm_nm, client_nm , TEXT_DECRYPT(ssn, 'pw' ) ssn, enp_no, "+
	   	     		 "    bus_cdt, bus_itm, ho_addr,  ho_zip, o_addr, o_zip, cng_dt, reg_id,  reg_dt, taxregno "+				
					   " from client_enp_h "+
					     " where CLIENT_ID = '"+client_id+"' ";
							      
		
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
			System.out.println("[ClientMngDatabase:getClientMngEnpHList]\n"+e);
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
	 *	거래처관리 : 거래처상세내용 - 거래처별 차량관계자
	 */	
	public Vector getClientMngCarMgrList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" b.car_no, c.rent_mng_id, c.rent_l_cd, "+
				" c.mgr_title as title1, c.mgr_nm as nm1, c.mgr_tel as tel1, c.mgr_m_tel as m_tel1,"+
				" d.mgr_title as title2, d.mgr_nm as nm2, d.mgr_tel as tel2, d.mgr_m_tel as m_tel2,"+
				" e.mgr_title as title3, e.mgr_nm as nm3, e.mgr_tel as tel3, e.mgr_m_tel as m_tel3"+
				" from cont a, car_reg b, "+
				" (select * from car_mgr where mgr_st='차량이용자') c,"+
				" (select * from car_mgr where mgr_st='차량관리자') d,"+
				" (select * from car_mgr where mgr_st='회계관리자') e"+
				" where a.use_yn='Y' and a.car_mng_id=b.car_mng_id"+
				" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				" and (c.mgr_nm is not null or d.mgr_nm is not null or e.mgr_nm is not null)"+
				" and a.client_id='"+client_id+"'"+
				" order by b.car_no";
		
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
			System.out.println("[ClientMngDatabase:getClientMngCarMgrList]\n"+e);
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
	 *	거래처별 사용본거지 리스트 : 계약연결
	 */
	public Vector getClientSites(String client_id)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";
	 
 	 	query = 	" select a.client_id, a.seq, a.r_site, a.reg_dt, a.reg_id, a.site_st, a.site_jang,  a.addr, a.zip,"+
						"   TEXT_DECRYPT(a.enp_no, 'pw' ) enp_no, a.bus_cdt, a.bus_itm, a.open_year, a.tel, a.fax, a.ven_code, a.taxregno, b.l_cnt "+
						" from client_site a, "+
						" (select client_id, r_site, count(0) l_cnt from cont where use_yn='Y' and car_mng_id is not null group by client_id, r_site) b"+
						" where a.client_id=b.client_id(+) and a.seq=b.r_site"+
						" and a.client_id=? ";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ClientSiteBean c_site = new ClientSiteBean();
				c_site.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				c_site.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				c_site.setR_site(rs.getString("R_SITE")==null?"":rs.getString("R_SITE"));
				c_site.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				c_site.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				c_site.setSite_st(rs.getString("site_st")==null?"":rs.getString("site_st"));
				c_site.setSite_jang(rs.getString("site_jang")==null?"":rs.getString("site_jang"));
				c_site.setEnp_no(rs.getString("enp_no")==null?"":rs.getString("enp_no"));
				c_site.setBus_cdt(rs.getString("bus_cdt")==null?"":rs.getString("bus_cdt"));
				c_site.setBus_itm(rs.getString("bus_itm")==null?"":rs.getString("bus_itm"));
				c_site.setOpen_year(rs.getString("open_year")==null?"":rs.getString("open_year"));
				c_site.setTel(rs.getString("tel")==null?"":rs.getString("tel"));
				c_site.setFax(rs.getString("fax")==null?"":rs.getString("fax"));
				c_site.setZip(rs.getString("zip")==null?"":rs.getString("zip"));
				c_site.setAddr(rs.getString("addr")==null?"":rs.getString("addr"));
				c_site.setVen_code(rs.getString("ven_code")==null?"":rs.getString("ven_code"));
				c_site.setL_cnt(rs.getInt("l_cnt"));
				c_site.setTaxregno(rs.getString("taxregno")==null?"":rs.getString("taxregno"));

				vt.add(c_site);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println(e);
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
	 *	거래처별 사용본거지 리스트 : 계약연결
	 */
	public Vector getClientSites(String client_id, String site_st)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";

		query = 	" select a.client_id, a.seq, a.r_site, a.reg_dt, a.reg_id, a.site_st, a.site_jang,  a.addr, a.zip,"+
						"   TEXT_DECRYPT(a.enp_no, 'pw' ) enp_no, a.bus_cdt, a.bus_itm, a.open_year, a.tel, a.fax, a.ven_code, a.taxregno "+
						" from client_site a "+
			        	" where a.client_id=? and a.site_st=? ";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, client_id);
				pstmt.setString(2, site_st);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				ClientSiteBean c_site = new ClientSiteBean();
				c_site.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				c_site.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				c_site.setR_site(rs.getString("R_SITE")==null?"":rs.getString("R_SITE"));
				c_site.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				c_site.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				c_site.setSite_st(rs.getString("site_st")==null?"":rs.getString("site_st"));
				c_site.setSite_jang(rs.getString("site_jang")==null?"":rs.getString("site_jang"));
				c_site.setEnp_no(rs.getString("enp_no")==null?"":rs.getString("enp_no"));
				c_site.setBus_cdt(rs.getString("bus_cdt")==null?"":rs.getString("bus_cdt"));
				c_site.setBus_itm(rs.getString("bus_itm")==null?"":rs.getString("bus_itm"));
				c_site.setOpen_year(rs.getString("open_year")==null?"":rs.getString("open_year"));
				c_site.setTel(rs.getString("tel")==null?"":rs.getString("tel"));
				c_site.setFax(rs.getString("fax")==null?"":rs.getString("fax"));
				c_site.setZip(rs.getString("zip")==null?"":rs.getString("zip"));
				c_site.setAddr(rs.getString("addr")==null?"":rs.getString("addr"));
				c_site.setVen_code(rs.getString("ven_code")==null?"":rs.getString("ven_code"));
				c_site.setTaxregno(rs.getString("taxregno")==null?"":rs.getString("taxregno"));

				vt.add(c_site);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println(e);
	  		e.printStackTrace();
			System.out.println(query);
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
	 *	거래처 본점/지점 조회리스트
	 */	
	public Vector getClientSiteSearch(String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select gubun, client_id, site_id, firm_nm, client_nm, nvl(enp_no,ssn) enp_no, o_addr, con_agnt_nm, con_agnt_email from "+
				" ("+
				"	select '본점' gubun, client_id, '' as site_id, firm_nm, client_nm, enp_no, TEXT_DECRYPT(ssn, 'pw' ) ssn, o_addr, con_agnt_nm, con_agnt_email from client"+
				"	union all "+
				"	select '지점' gubun, client_id, seq as site_id, r_site as firm_nm, site_jang as client_nm, enp_no, '' as ssn, addr as o_addr, agnt_nm con_agnt_nm, agnt_email con_agnt_email from client_site "+
				" )";
	
		if(s_kd.equals("1"))		query += " where upper(nvl(firm_nm||client_nm, ' ')) like upper('%"+t_wd+"%') order by decode(gubun,'본점',0,site_id)";

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
			System.out.println("[ClientMngDatabase:getClientSiteSearch]\n"+e);
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
	 * 자동차조회
	 */	
	public Vector getCarSearch(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select \n"+
				"        decode(a.use_yn,'N','해지','Y','대여','','대기') use_st, \n"+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.rent_start_dt, a.rent_end_dt, \n"+
				"        nvl(nvl(b.car_no,nvl(decode(a.car_st,'1',g.est_car_no),nvl(g.car_num,g.rpt_no))),a.rent_l_cd) car_no, e.car_name, f.car_nm, \n"+
				"        b.car_y_form, b.init_reg_dt, c.firm_nm, c.client_nm, d.colo, \n"+
				"        decode(substr(b.init_reg_dt, 1,6), '','신차','신차아님') as shin_car, \n"+
				"        decode( a.car_gu, '1', '신차','신차아님' ) AS car_gu, \n"+
				"        i.cls_dt, substrb(e.car_b,1,2000) car_b, "+
				"        d.opt, decode(d.hipass_yn,'Y','있음','N','없음','') hipass_yn, decode(fe.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way  \n"+
				" from   cont a, car_reg b, car_etc d, client c, car_nm e, car_mng f, car_pur g, sui h, cls_cont i ,  fee fe \n"+
				" where  a.car_mng_id=b.car_mng_id(+) \n"+
				"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				"        and a.rent_mng_id=fe.rent_mng_id and a.rent_l_cd=fe.rent_l_cd \n"+
				"        and a.client_id=c.client_id \n"+
				"        and d.car_id=e.car_id and d.car_seq=e.car_seq \n"+
				"        and e.car_comp_id=f.car_comp_id and e.car_cd=f.code \n"+
				"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
				"        and a.car_mng_id=h.car_mng_id(+)  \n"+	
				"        and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) \n"+
				" ";
	
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and nvl(b.car_no,g.est_car_no)||b.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and replace(upper(nvl(g.rpt_no, ' ')),'-','')  like replace(upper('%"+t_wd+"%'),'-','')";
		else if(s_kd.equals("4"))	query += " and nvl(b.car_num,g.car_num) like '%"+t_wd+"%'";
		else						query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";

		if(s_kd.equals("1"))		query += "\n order by c.firm_nm, b.car_no, a.rent_dt desc";
		else if(s_kd.equals("2"))	query += "\n order by b.car_no, a.rent_dt desc";
		else						query += "\n order by a.rent_dt desc";


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
			System.out.println("[ClientMngDatabase:getCarSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getCarSearch]\n"+query);
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
	 * 자동차조회
	 */	
	public Vector getCarResSearch(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select "+
				"        decode(a.use_st, '1','예약','2','배차','3','반차','4','정산') use_st_nm, "+
				"        decode(a.rent_st,'1','단기','2','정비','3','사고','9','보험','10','지연','4','업무','5','업무','6','정비','7','정비','8','수리','11','장기대기') rent_st_nm, "+
				"        b.car_no, b.car_nm, decode(a.cust_st,'1',c.firm_nm,'아마존카') firm_nm, "+
				"        substr(a.deli_dt,1,8) deli_dt, substr(a.ret_dt,1,8) ret_dt, d.user_nm, b2.car_no as car_no2,"+
				"        e.rent_mng_id, e.rent_l_cd, a.car_mng_id, c.client_id,  "+
				"        b.car_y_form, b.init_reg_dt, f.colo, decode(substr(b.init_reg_dt, 1,6), '','신차','신차아님') as shin_car, decode( e.car_gu, '1', '신차','신차아님' ) AS car_gu"+
				" from   rent_cont a, car_reg b, client c, users d, cont e, car_etc f, car_reg b2 "+
				" where  a.use_st in ('1','2','3','4') and a.rent_st not in ('4','5') "+
				" and   decode(a.rent_st, '10', to_char(sysdate,'YYYYMMDD'), decode(a.use_st, '1',a.reg_dt, '2',a.reg_dt, '3',to_char(sysdate,'YYYYMMDD'), '4',substr(a.ret_dt,1,8)) ) > to_char(sysdate-60,'YYYYMMDD') "+
				" and    a.car_mng_id=b.car_mng_id "+
				" and    a.cust_id=c.client_id(+) "+
				" and    a.bus_id=d.user_id "+
				" and    a.car_mng_id=e.car_mng_id and nvl(e.use_yn,'Y')='Y'"+
				" and    e.rent_mng_id=f.rent_mng_id and e.rent_l_cd=f.rent_l_cd"+
				" and    a.sub_c_id=b2.car_mng_id(+)"+
				" ";
	
		if(s_kd.equals("1"))		query += " and decode(a.cust_st,'1',c.firm_nm,'아마존카') like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and b.car_no||' '||b.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and b.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and d.user_nm like '%"+t_wd+"%'";


		if(s_kd.equals("1"))		query += " order by c.firm_nm, b.car_no";
		else if(s_kd.equals("2"))	query += " order by b.car_no";
		else if(s_kd.equals("4"))	query += " order by b.car_no";
		else						query += " order by a.use_st, a.rent_st, a.deli_dt";


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
			System.out.println("[ClientMngDatabase:getCarResSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getCarResSearch]\n"+query);
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
	 * 자동차조회
	 */	
	public Vector getCarResSearchAgent(String s_br, String s_kd, String t_wd, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select "+
				"        decode(a.use_st, '1','예약','2','배차','3','반차','4','정산') use_st_nm, "+
				"        decode(a.rent_st,'1','단기','2','정비','3','사고','9','보험','10','지연','4','업무','5','업무','6','정비','7','정비','8','수리','11','장기대기') rent_st_nm, "+
				"        b.car_no, b.car_nm, decode(a.cust_st,'1',c.firm_nm,'아마존카') firm_nm, "+
				"        substr(a.deli_dt,1,8) deli_dt, substr(a.ret_dt,1,8) ret_dt, d.user_nm, b2.car_no as car_no2,"+
				"        e.rent_mng_id, e.rent_l_cd, a.car_mng_id, c.client_id,  "+
				"        b.car_y_form, b.init_reg_dt, f.colo, decode(substr(b.init_reg_dt, 1,6), '','신차','신차아님') as shin_car, decode( e.car_gu, '1', '신차','신차아님' ) AS car_gu"+
				" from   rent_cont a, car_reg b, client c, users d, cont e, car_etc f, car_reg b2 "+
				" where  (a.reg_id='"+user_id+"' or a.bus_id='"+user_id+"') and a.use_st in ('1','2','3','4') and a.rent_st not in ('4','5') "+
				" and    decode(a.rent_st, '10', to_char(sysdate,'YYYYMMDD'), decode(a.use_st, '1',a.reg_dt, '2',a.reg_dt, '3',to_char(sysdate,'YYYYMMDD'), '4',substr(a.ret_dt,1,8)) ) > to_char(sysdate-60,'YYYYMMDD') "+
				" and    a.car_mng_id=b.car_mng_id "+
				" and    a.cust_id=c.client_id(+) "+
				" and    a.bus_id=d.user_id "+
				" and    a.car_mng_id=e.car_mng_id and nvl(e.use_yn,'Y')='Y'"+
				" and    e.rent_mng_id=f.rent_mng_id and e.rent_l_cd=f.rent_l_cd"+
				" and    a.sub_c_id=b2.car_mng_id(+)"+
				" ";
	
		if(s_kd.equals("1"))		query += " and decode(a.cust_st,'1',c.firm_nm,'아마존카') like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and b.car_no||' '||b.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and b.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and d.user_nm like '%"+t_wd+"%'";


		if(s_kd.equals("1"))		query += " order by c.firm_nm, b.car_no";
		else if(s_kd.equals("2"))	query += " order by b.car_no";
		else if(s_kd.equals("4"))	query += " order by b.car_no";
		else						query += " order by a.use_st, a.rent_st, a.deli_dt";


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
			System.out.println("[ClientMngDatabase:getCarResSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getCarResSearch]\n"+query);
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
	 *	거래처관리 : 거래처조회리스트
	 */	
	public Vector getRentListImSearch(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

        String query = "";
		String dt_query = "";     
		String sub_query = "";        

		String b_dt = "case when b.rent_end_dt > sf.fee_est_dt then b.rent_end_dt when sf.fee_est_dt is null then b.rent_end_dt else sf.fee_est_dt end";
		
		dt_query = " and to_char(sysdate,'YYYYMMDD') between to_char(to_date("+b_dt+",'YYYYMMDD')-40,'YYYYMMDD') and to_char(to_date("+b_dt+",'YYYYMMDD')+100,'YYYYMMDD')\n";

			 
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		sub_query += " and a.car_st <> '4' and nvl(c.firm_nm||c.client_nm,'') like '%"+t_wd+"%'";
			else if(s_kd.equals("2"))	sub_query += " and a.car_st <> '4' and d.car_no like '%"+t_wd+"%'";
			else if(s_kd.equals("3"))	sub_query += " and a.car_st <> '4' and d.car_num like '%"+t_wd+"%'";
			else if(s_kd.equals("4"))	sub_query += " and a.car_st <> '4' and a.rent_l_cd like '%"+t_wd+"%'";
			else if(s_kd.equals("5"))	sub_query += " and a.car_st = '4' and c.firm_nm like '%"+t_wd+"%'";  //월렌트 한정
			else if(s_kd.equals("6"))	sub_query += " and a.car_st = '4' and d.car_no like '%"+t_wd+"%'";
			else						sub_query += " and a.car_st <> '4' and nvl(c.firm_nm||c.client_nm,'') like '%"+t_wd+"%'";
		}
		
        query = " select  \n"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, c.firm_nm, c.client_nm, \n"+
				" b.rent_start_dt, b.rent_end_dt,\n"+
				" d.car_no, d.car_nm, \n"+
				" sf.fee_est_dt, \n"+
				" decode(o.rent_l_cd,'','','해지정산등록') cls_reg_y, decode(cc.rent_l_cd,'','','차량해지반납') car_callin_y "+
				" from  cont a, \n"+
				"       (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) b,\n"+
				"       (select rent_mng_id, rent_l_cd, max(use_e_dt) fee_est_dt from scd_fee where bill_yn='Y' group by rent_mng_id, rent_l_cd) sf,\n"+
				"       client c, car_reg d, \n"+
				"       cls_etc o, \n"+
				"       ( select  * from car_call_in where in_st='3' and out_dt is null ) cc "+
				" where a.use_yn='Y' and a.car_st<>'2' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_start_dt is not null \n"+
				" and a.rent_mng_id=sf.rent_mng_id(+) and a.rent_l_cd=sf.rent_l_cd(+)\n"+
				dt_query +
				sub_query +
				" and a.client_id=c.client_id\n"+
				" and a.car_mng_id=d.car_mng_id\n"+
				" and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+)  \n"+
				" and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)\n";	
					
			query+= " and o.rent_l_cd is null and cc.rent_l_cd is null ";
			
			query+= " order by b.rent_end_dt";

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
			System.out.println("[ClientMngDatabase:getRentListImSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getRentListImSearch]\n"+query);
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
	 *	거래처관리 : 개시전 차종변경 대상 리스트
	 */	
	public Vector getRentListCarCngSearch(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";


		query = " select a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm, c.car_num, a.rent_start_dt, a.rent_end_dt, d.cls_dt , a.rent_dt\n"+
				" from cont_n_view a, car_reg c, cls_cont d \n"+
				" where  a.car_mng_id = c.car_mng_id(+) and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+) ";
		
		query += " and a.rent_start_dt is null and nvl(a.use_yn,'Y')='Y' and a.car_st<>'2' and a.fee_rent_st='1' ";
		
		if(s_kd.equals("1"))		query += " and a.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and a.rent_l_cd like '%"+t_wd+"%'";
		else						query += " and a.firm_nm like '%"+t_wd+"%'";

		if(!s_br.equals(""))		query += " and a.brch_id like '"+s_br+"%'";

		query += " order by a.rent_dt";

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
			System.out.println("[ClientMngDatabase:getRentListCarCngSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getRentListCarCngSearch]\n"+query);
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
	 *	거래처관리 : 거래처조회리스트
	 */	
	public Vector getTaxClientsList(String item_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct * from ( "+
				" select  '본사' st, a.use_yn, a.rent_l_cd, a.client_id, a.r_site r_site_seq, b.client_st, \n"+
				"        b.firm_nm, b.client_nm, \n"+
				"        decode(b.client_st,'2','',b.enp_no) enp_no, decode(b.client_st,'2',TEXT_DECRYPT(b.ssn, 'pw' ), '') ssn, \n"+
				"        b.bus_cdt, b.bus_itm, b.o_addr, b.o_tel, \n"+
				"        b.con_agnt_nm, b.con_agnt_dept, b.con_agnt_title, \n"+
				"        b.con_agnt_m_tel, b.con_agnt_email \n"+
				" from   cont_n_view a, client b \n"+
				" where  a.client_id in (select client_id from tax_item where item_id='"+item_id+"') \n"+
				"        and a.car_st<>'2' \n"+
				"        and a.client_id=b.client_id \n"+
				" union all \n"+
				" select  '지점' st, a.use_yn, a.rent_l_cd, a.client_id, a.r_site r_site_seq, decode(length(b.enp_no),10,'1','2') client_st, \n"+
				"        b.r_site as firm_nm, b.site_jang as client_nm, \n"+
				"		 decode(length(TEXT_DECRYPT(b.enp_no, 'pw' )),10, TEXT_DECRYPT(b.enp_no, 'pw' ),'') enp_no,  \n"+
				"		 decode(length(TEXT_DECRYPT(b.enp_no, 'pw' )),10,'', TEXT_DECRYPT(b.enp_no, 'pw' )) ssn ,  \n"+				
				"        b.bus_cdt, b.bus_itm, b.addr o_addr, b.tel o_tel, \n"+
				"        b.agnt_nm as con_agnt_nm, b.agnt_dept as con_agnt_dept, b.agnt_title as con_agnt_title, \n"+
				"        b.agnt_m_tel as con_agnt_m_tel, b.agnt_email as con_agnt_email \n"+
				" from   cont_n_view a, client_site b \n"+
				" where  a.client_id in (select client_id from tax_item where item_id='"+item_id+"') \n"+
				"        and a.car_st<>'2' \n"+
				"        and a.client_id=b.client_id and a.r_site=b.seq \n"+
				"        and b.enp_no is not null \n"+
				" union all \n"+
		        " select  '본사' st, a.use_yn, a.rent_l_cd, c.client_id, '' r_site_seq, b.client_st, \n"+
				"        b.firm_nm, b.client_nm, \n"+
				"        decode(b.client_st,'2','',b.enp_no) enp_no, decode(b.client_st,'2',TEXT_DECRYPT(b.ssn, 'pw' ),'') ssn,  \n"+
				"        b.bus_cdt, b.bus_itm, b.o_addr, b.o_tel, \n"+
				"        b.con_agnt_nm, b.con_agnt_dept, b.con_agnt_title, \n"+
				"        b.con_agnt_m_tel, b.con_agnt_email \n"+
				" from   cont_n_view a, fee_rtn c, client b \n"+
				" where  a.client_id in (select client_id from tax_item where item_id='"+item_id+"') \n"+
				"        and a.car_st<>'2' \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=b.client_id \n"+
				" union all \n"+
				" select  '지점' st, a.use_yn, a.rent_l_cd, c.client_id, c.r_site r_site_seq, decode(length(b.enp_no),10,'1','2') client_st, \n"+
				"        b.r_site as firm_nm, b.site_jang as client_nm, \n"+
				"		 decode(length(TEXT_DECRYPT(b.enp_no, 'pw' )),10, TEXT_DECRYPT(b.enp_no, 'pw' ),'') enp_no,  \n"+
				"		 decode(length(TEXT_DECRYPT(b.enp_no, 'pw' )),10,'', TEXT_DECRYPT(b.enp_no, 'pw' )) ssn ,  \n"+				
				"        b.bus_cdt, b.bus_itm, b.addr o_addr, b.tel o_tel, \n"+
				"        b.agnt_nm as con_agnt_nm, b.agnt_dept as con_agnt_dept, b.agnt_title as con_agnt_title, \n"+
				"        b.agnt_m_tel as con_agnt_m_tel, b.agnt_email as con_agnt_email \n"+
				" from   cont_n_view a, fee_rtn c, client_site b \n"+
				" where  a.client_id in (select client_id from tax_item where item_id='"+item_id+"') \n"+
				"        and a.car_st<>'2' \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=b.client_id and c.r_site=b.seq \n"+
				"        and b.enp_no is not null \n"+
				" union all \n"+
				" select  '승계업체' st, b.use_yn, b.rent_l_cd, b.client_id, b.r_site r_site_seq, c.client_st, \n"+
				"        c.firm_nm, c.client_nm, \n"+
				"        decode(c.client_st,'2','',c.enp_no) enp_no, decode(c.client_st,'2',TEXT_DECRYPT(c.ssn, 'pw' ),'') ssn, \n"+
				"        c.bus_cdt, c.bus_itm, c.o_addr, c.o_tel, \n"+
				"        c.con_agnt_nm, c.con_agnt_dept, c.con_agnt_title, \n"+
				"        c.con_agnt_m_tel, c.con_agnt_email \n"+
                " FROM   CONT_ETC a, CONT b, CLIENT c  \n"+
                " WHERE  a.rent_suc_l_cd IN (SELECT rent_l_cd FROM TAX_ITEM_LIST WHERE item_id='"+item_id+"')  \n"+
                "        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
                "        AND b.client_id=c.client_id \n"+
				" union all \n"+
				" select  '지점' st, '' use_yn, '' rent_l_cd, b.client_id, '' r_site_seq, decode(length(b.enp_no),10,'1','2') client_st, \n"+
				"        b.r_site as firm_nm, b.site_jang as client_nm, \n"+
				"		 decode(length(TEXT_DECRYPT(b.enp_no, 'pw' )),10, TEXT_DECRYPT(b.enp_no, 'pw' ),'') enp_no,  \n"+
				"		 decode(length(TEXT_DECRYPT(b.enp_no, 'pw' )),10,'', TEXT_DECRYPT(b.enp_no, 'pw' )) ssn ,  \n"+				
				"        b.bus_cdt, b.bus_itm, b.addr o_addr, b.tel o_tel, \n"+
				"        b.agnt_nm as con_agnt_nm, b.agnt_dept as con_agnt_dept, b.agnt_title as con_agnt_title, \n"+
				"        b.agnt_m_tel as con_agnt_m_tel, b.agnt_email as con_agnt_email \n"+
				" from   client_site b  \n"+
				" where  b.client_id in (select client_id from tax_item where item_id='"+item_id+"') \n"+
				"        and b.enp_no is not null \n"+
				" ) ";



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
			System.out.println("[ClientMngDatabase:getTaxClientsList]\n"+e);
			System.out.println("[ClientMngDatabase:getTaxClientsList]\n"+query);
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
	 *	거래처관리 : 거래처조회리스트
	 */	
	public Vector getCarCngRentListSearch(String s_br, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

	    //신차 차량대금 미지급 계약만
		query = " select a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, "+
				"        a.firm_nm, a.client_nm, "+
				"        c.car_no, c.car_nm, c.car_num, a.rent_start_dt, a.rent_end_dt, d.cls_dt \n"+
				" from   cont_n_view a, car_reg c, cls_cont d, car_pur b \n"+
				" where  a.car_mng_id = c.car_mng_id(+) and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+)  and a.rent_start_dt='--' and a.car_mng_id is null and (a.use_yn is null or a.use_yn='Y') "+
				"        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.pur_pay_dt IS NULL ";
		
		if(s_kd.equals("1"))		query += " and a.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and a.rent_l_cd like '%"+t_wd+"%'";
		else						query += " and a.firm_nm like '%"+t_wd+"%'";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";

		query += " order by a.use_yn desc, a.rent_dt desc";

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
			System.out.println("[ClientMngDatabase:getCarCngRentListSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getCarCngRentListSearch]\n"+query);
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
	 *	거래처관리 : 거래처조회리스트 - agent
	 */	
	public Vector getRentListSearchA(String s_br, String s_kd, String t_wd, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

				
		query = " select a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, " +
		           " cr.car_no, cr.car_nm, cr.car_num, a.rent_start_dt, a.rent_end_dt, c.cls_dt "+
				" from cont_n_view a, client b , car_reg cr, cls_cont c "+
				" where  a.client_id= b.client_id and  a.car_mng_id=cr.car_mng_id(+) and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+)  ";
				
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm,b.client_nm) like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and cr.car_no||' '||cr.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and cr.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and a.rent_l_cd like '%"+t_wd+"%'";
		else						query += " and nvl(b.firm_nm,b.client_nm) like '%"+t_wd+"%'";

		if(!user_id.equals(""))	query += " and a.bus_id = '"+user_id+"'";
		
		query += " order by a.use_yn desc, a.rent_dt desc";

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
			System.out.println("[ClientMngDatabase:getRentListSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getRentListSearch]\n"+query);
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
	 *	거래처관리 : 거래처조회리스트
	 */	
	public Vector getCarCngRentListSearchA(String s_br, String s_kd, String t_wd, String user_id )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";
		
		query = " select a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, " +
		           " cr.car_no, cr.car_nm, cr.car_num, a.rent_start_dt, a.rent_end_dt, c.cls_dt "+
				" from cont_n_view a, client b , car_reg cr, cls_cont c "+
				" where  a.client_id= b.client_id and  a.car_mng_id=cr.car_mng_id(+) and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+)  and a.rent_start_dt='--' ";
					
	
		if(s_kd.equals("1"))		query += "  and nvl(b.firm_nm, b.client_nm) like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and cr.car_no||' '||cr.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and cr.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and a.rent_l_cd like '%"+t_wd+"%'";
		else						query += " and nvl(b.firm_nm,b.client_nm) like '%"+t_wd+"%'";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";
		if(!user_id.equals(""))	query += " and a.bus_id = '"+user_id+"' ";

		query += " order by a.use_yn desc, a.rent_dt desc";

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
			System.out.println("[ClientMngDatabase:getCarCngRentListSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getCarCngRentListSearch]\n"+query);
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
	 * 자동차조회
	 */	
	public Vector getCarSearch(String s_br, String s_kd, String t_wd, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select \n"+
				"        decode(a.use_yn,'N','해지','Y','대여','','대기') use_st, \n"+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.rent_start_dt, a.rent_end_dt, \n"+
				"        nvl(b.car_no,nvl(g.est_car_no,nvl(g.car_num,g.rpt_no))) car_no, e.car_name, f.car_nm, \n"+
				"        b.car_y_form, b.init_reg_dt, c.firm_nm, c.client_nm, d.colo, \n"+
				"        decode(substr(b.init_reg_dt, 1,6), '','신차','신차아님') as shin_car, \n"+
				"        decode( a.car_gu, '1', '신차','신차아님' ) AS car_gu, \n"+
				"        i.cls_dt, substrb(e.car_b,1,2000) car_b, "+
				"        d.opt, decode(d.hipass_yn,'Y','있음','N','없음','') hipass_yn \n"+
				" from   cont a, car_reg b, car_etc d, client c, car_nm e, car_mng f, car_pur g, sui h, cls_cont i, (select * from commi where agnt_st='1') g2, USERS h2  \n"+
				" where  a.car_mng_id=b.car_mng_id(+) \n"+
				"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				"        and a.client_id=c.client_id   \n"+   
				"        and d.car_id=e.car_id and d.car_seq=e.car_seq \n"+
				"        and e.car_comp_id=f.car_comp_id and e.car_cd=f.code \n"+
				"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
				"        and a.car_mng_id=h.car_mng_id(+)  \n"+	
				"        and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+)   \n"+
				"        and a.rent_mng_id=g2.rent_mng_id(+) and a.rent_l_cd=g2.rent_l_cd(+) "+
				"        and g2.emp_id=h2.sa_code(+) "+
				"        and (a.bus_id='"+user_id+"' or (g2.emp_id=h2.sa_code AND h2.user_id='"+user_id+"') or (a.car_st='2' and a.use_yn='Y')) "+   //에이전트 계약이거나, 영업사원이거나, 예비차만 조회
				" ";

		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and nvl(b.car_no,g.est_car_no)||b.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and replace(upper(nvl(g.rpt_no, ' ')),'-','')  like replace(upper('%"+t_wd+"%'),'-','')";
		else if(s_kd.equals("4"))	query += " and nvl(b.car_num,g.car_num) like '%"+t_wd+"%'";
		else						query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";

		if(s_kd.equals("1"))		query += "\n order by c.firm_nm, b.car_no, a.rent_dt desc";
		else if(s_kd.equals("2"))	query += "\n order by b.car_no, a.rent_dt desc";
		else						query += "\n order by a.rent_dt desc";


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
			System.out.println("[ClientMngDatabase:getCarSearch]\n"+e);
			System.out.println("[ClientMngDatabase:getCarSearch]\n"+query);
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
	 * 자동차조회
	 */	
	public Vector getCarSearchAgent(String s_kd, String t_wd, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";

		query = " SELECT a.st, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.rent_start_dt, a.rent_end_dt, a.agent_emp_id, i.emp_nm as agent_emp_nm, \n"+
                "        nvl(b.car_no,nvl(h.est_car_no,nvl(h.car_num,h.rpt_no))) car_no, b.init_reg_dt, \n"+
                "        c.firm_nm, \n"+
                "        f.CAR_NM, e.car_name, e.car_y_form, d.colo, substrb(e.car_b,1,2000) car_b, d.opt, d.hipass_yn, \n"+
				"        decode(substr(b.init_reg_dt, 1,6), '','신차','신차아님') as shin_car, \n"+
                "        decode( a.car_gu, '1', '신차','신차아님' ) AS car_gu, \n"+
                "        DECODE(a.st,'2',a.rent_end_dt,g.cls_dt) cls_dt \n"+
                " FROM  \n"+
			               //대여차량
                "        ( SELECT '1' AS st, car_gu, rent_mng_id, rent_l_cd, car_mng_id, client_id, rent_start_dt, rent_end_dt, agent_emp_id FROM CONT WHERE bus_id='"+user_id+"' \n"+
                "          UNION all \n"+
					       //출고지연차량
                "          SELECT '2' AS st, '0' car_gu, c.rent_mng_id, c.rent_l_cd, c.car_mng_id, a.client_id, b.car_rent_st as rent_start_dt, b.car_rent_et as rent_end_dt, a.agent_emp_id FROM CONT a, TAECHA b, CONT c WHERE a.BUS_ID='"+user_id+"' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.car_mng_id=c.car_mng_id AND c.car_st='2' \n"+
                "          UNION all \n"+
					       //출고지연대차차량
                "          SELECT '5' AS st, '0' car_gu, b.rent_mng_id, b.rent_l_cd, a.car_mng_id, a.cust_id as client_id, substr(a.rent_start_dt,1,8) as rent_start_dt, substr(a.rent_end_dt,1,8) as rent_end_dt, '' agent_emp_id FROM rent_cont a, cont b WHERE a.BUS_ID='"+user_id+"' AND a.car_mng_id=b.car_mng_id AND b.car_st='2' and b.use_yn='Y' \n"+
                "          UNION all \n"+
					       //대차계약원차량
                "          SELECT '3' AS st, c.car_gu, c.rent_mng_id, c.rent_l_cd, c.car_mng_id, c.client_id, c.rent_start_dt, c.rent_end_dt, a.agent_emp_id FROM CONT a, CONT_ETC b, CONT c WHERE a.BUS_ID='"+user_id+"' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.grt_suc_m_id=c.rent_mng_id AND b.grt_suc_l_cd=c.rent_l_cd \n"+
                "          UNION all \n"+
					       //영업사원계약 영업담당 차량
				"          SELECT '4' AS st, a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.rent_start_dt, a.rent_end_dt, a.agent_emp_id FROM CONT a, COMMI b, USERS c WHERE a.BUS_ID<>'"+user_id+"' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.agnt_st='1' AND b.emp_id=c.sa_code and c.user_id='"+user_id+"' \n"+
                "        ) a, \n"+
                "        CAR_REG b, CLIENT c, CAR_ETC d, CAR_NM e, CAR_MNG f, CLS_CONT g, CAR_PUR h, car_off_emp i \n"+
                " WHERE  a.car_mng_id=b.car_mng_id(+) \n"+
                "        AND a.client_id=c.client_id \n"+  
                "        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd AND d.car_id=e.car_id AND d.car_seq=e.car_seq AND e.car_comp_id=f.car_comp_id AND e.car_cd=F.CODE \n"+
                "        AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+) \n"+
                "        AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd \n"+
				"        and a.agent_emp_id=i.emp_id(+)"+
				" ";

		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and nvl(b.car_no,h.est_car_no)||b.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and replace(upper(nvl(h.rpt_no, ' ')),'-','')  like replace(upper('%"+t_wd+"%'),'-','')";
		else if(s_kd.equals("4"))	query += " and nvl(b.car_num,h.car_num) like '%"+t_wd+"%'";
		else						query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";


		if(s_kd.equals("1"))		query += "\n order by c.firm_nm, b.car_no, a.rent_start_dt desc";
		else if(s_kd.equals("2"))	query += "\n order by b.car_no, a.rent_start_dt desc";
		else						query += "\n order by a.rent_start_dt desc";

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
			System.out.println("[ClientMngDatabase:getCarSearchAgent]\n"+e);
			System.out.println("[ClientMngDatabase:getCarSearchAgent]\n"+query);
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
	 *	거래처관리 : 거래처조회리스트
	 */	
	public Vector getRentListClientCngSearch(String s_br, String s_kd, String t_wd, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

/*
		query = " select a.use_yn, a.rent_dt, a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm, c.car_num, a.rent_start_dt, a.rent_end_dt, d.cls_dt, a.car_st \n"+
				" from cont_n_view a, car_reg c, cls_cont d \n"+
				" where  a.bus_id='"+user_id+"' and a.car_mng_id = c.car_mng_id and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+) and a.rent_start_dt is not null and d.rent_l_cd is null ";
	
		if(s_kd.equals("1"))		query += " and a.car_st != '4' and a.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and a.car_st != '4' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and a.car_st != '4' and c.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and a.car_st != '4' and a.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.use_yn='Y' and a.car_st = '4' and a.firm_nm like '%"+t_wd+"%'";  //월렌트 한정
		else if(s_kd.equals("6"))	query += " and a.use_yn='Y' and a.car_st = '4' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 한정
		else if(s_kd.equals("7"))	query += " and a.use_yn='Y' and a.firm_nm like '%"+t_wd+"%'";  //월렌트 포함
		else if(s_kd.equals("8"))	query += " and a.use_yn='Y' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 포함
		else if(s_kd.equals("9"))	query += " and a.use_yn='N' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 포함
		else						query += " and a.firm_nm like '%"+t_wd+"%'";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";

		query += " union all ";
*/

		query = " select a.use_yn, a.rent_dt, a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, b.firm_nm, b.client_nm, c.car_no, c.car_nm, c.car_num, a.rent_start_dt, a.rent_end_dt, d.cls_dt, a.car_st \n"+
				" from cont a, client b, car_reg c, cls_cont d \n"+
				" where  (a.bus_id='"+user_id+"' or a.agent_users like '%"+user_id+"%') and a.client_id=b.client_id and a.car_mng_id = c.car_mng_id and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+) and a.rent_start_dt is not null and d.rent_l_cd is null ";
	
		if(s_kd.equals("1"))		query += " and a.car_st != '4' and b.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and a.car_st != '4' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and a.car_st != '4' and c.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and a.car_st != '4' and a.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.use_yn='Y' and a.car_st = '4' and b.firm_nm like '%"+t_wd+"%'";  //월렌트 한정
		else if(s_kd.equals("6"))	query += " and a.use_yn='Y' and a.car_st = '4' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 한정
		else if(s_kd.equals("7"))	query += " and a.use_yn='Y' and b.firm_nm like '%"+t_wd+"%'";  //월렌트 포함
		else if(s_kd.equals("8"))	query += " and a.use_yn='Y' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 포함
		else if(s_kd.equals("9"))	query += " and a.use_yn='N' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 포함
		else						query += " and b.firm_nm like '%"+t_wd+"%'";

		query += " union all ";

		query += " select a.use_yn, a.rent_dt, a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm, c.car_num, a.rent_start_dt, a.rent_end_dt, d.cls_dt, a.car_st \n"+
				" from fee b, cont_n_view a, car_reg c, cls_cont d \n"+
				" where  b.ext_agnt ='"+user_id+"' and b.rent_l_cd=a.RENT_L_CD AND b.rent_st<>a.fee_rent_st and a.car_mng_id = c.car_mng_id and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+) and a.rent_start_dt is not null and d.rent_l_cd is null ";
	
		if(s_kd.equals("1"))		query += " and a.car_st != '4' and a.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and a.car_st != '4' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and a.car_st != '4' and c.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and a.car_st != '4' and a.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.use_yn='Y' and a.car_st = '4' and a.firm_nm like '%"+t_wd+"%'";  //월렌트 한정
		else if(s_kd.equals("6"))	query += " and a.use_yn='Y' and a.car_st = '4' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 한정
		else if(s_kd.equals("7"))	query += " and a.use_yn='Y' and a.firm_nm like '%"+t_wd+"%'";  //월렌트 포함
		else if(s_kd.equals("8"))	query += " and a.use_yn='Y' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 포함
		else if(s_kd.equals("9"))	query += " and a.use_yn='N' and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";    //월렌트 포함
		else						query += " and a.firm_nm like '%"+t_wd+"%'";

		if(!s_br.equals(""))	query += " and a.brch_id like '"+s_br+"%'";

		query += " order by 1 desc, 2 desc";

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
		//	System.out.println("[ClientMngDatabase:getRentListClientCngSearch(String s_br, String s_kd, String t_wd, String user_id)]\n"+query);
		} catch (SQLException e) {
			System.out.println("[ClientMngDatabase:getRentListClientCngSearch(String s_br, String s_kd, String t_wd, String user_id)]\n"+e);
			System.out.println("[ClientMngDatabase:getRentListClientCngSearch(String s_br, String s_kd, String t_wd, String user_id)]\n"+query);
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

}
