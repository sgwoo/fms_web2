package acar.cont;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.car_office.*;
import acar.common.*;

public class ContDatabase
{
	private Connection conn = null;
	public static ContDatabase db;
	
	public static ContDatabase getInstance()
	{
		if(ContDatabase.db == null)
			ContDatabase.db = new ContDatabase();
		return ContDatabase.db;	
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

	public Hashtable getCarRegFee(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " select CAR_MNG_ID, CAR_NO, CAR_NUM, LOAN_S_AMT, REG_AMT, ACQ_AMT, STAMP_AMT, ETC,"+
						" decode(INIT_REG_DT, '', '', substr(INIT_REG_DT, 1, 4) || '-' || substr(INIT_REG_DT, 5, 2) || '-'||substr(INIT_REG_DT, 7, 2)) INIT_REG_DT"+
						" from CAR_REG"+
						" where CAR_MNG_ID ="+
						" (select CAR_MNG_ID from CONT"+
						" where RENT_MNG_ID = ? and RENT_L_CD = ?)";
		try{	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mng_id);
			pstmt.setString(2, l_cd);
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
		}catch (SQLException e){
			System.out.println("[ContDatabase:getCarRegFee]\n"+e);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();			
			return ht;
		}
	}
	
	public ContBaseBean getContBase(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ContBaseBean base = new ContBaseBean();
		String query = "select Y.RENT_MNG_ID, Y.RENT_L_CD, Y.CLIENT_ID, Y.CAR_MNG_ID, Y.RENT_ST, Y.BUS_ST, Y.RENT_DT,\n"
					+ " Y.DLV_DT, nvl(Y.RENT_START_DT2, Y.RENT_START_DT) rent_start_dt, nvl(Y.RENT_END_DT2, Y.RENT_END_DT) rent_end_dt, X.BUS_ID, X.BUS_ID2, X.BUS_NM, Y.BRCH_ID, Y.NOTE, Y.MNG_ID, Z.MNG_ID2, Y.MNG_NM, Z.MNG_NM2, Y.REG_ID, \n"
					+ " Y.REG_DT, Y.CAR_ST, Y.R_SITE, Y.P_ZIP, Y.P_ADDR, Y.O_MAP, Y.USE_YN, Y.DEPT_ID, Y.car_no \n"
					+ " from"+
					" (\n"
						+ " select C.RENT_MNG_ID, C.RENT_L_CD, C.CLIENT_ID, C.CAR_MNG_ID, C.RENT_ST, C.BUS_ST, \n"
						+ " decode(C.RENT_DT, '', '', substr(C.RENT_DT, 1, 4) || '-' || substr(C.RENT_DT, 5, 2) || '-'||substr(C.RENT_DT, 7, 2)) RENT_DT, \n"
						+ " decode(C.DLV_DT, '', '', substr(C.DLV_DT, 1, 4) || '-' || substr(C.DLV_DT, 5, 2) || '-'||substr(C.DLV_DT, 7, 2)) DLV_DT, \n"
						+ " decode(C.RENT_START_DT, '', '', substr(C.RENT_START_DT, 1, 4) || '-' || substr(C.RENT_START_DT, 5, 2) || '-'||substr(C.RENT_START_DT, 7, 2)) RENT_START_DT2, \n"
						+ " decode(C.RENT_END_DT, '', '', substr(C.RENT_END_DT, 1, 4) || '-' || substr(C.RENT_END_DT, 5, 2) || '-'||substr(C.RENT_END_DT, 7, 2)) RENT_END_DT2, \n"
						+ " decode(F.RENT_START_DT, '', '', substr(F.RENT_START_DT, 1, 4) || '-' || substr(F.RENT_START_DT, 5, 2) || '-'||substr(F.RENT_START_DT, 7, 2)) RENT_START_DT, \n"
						+ " decode(F.RENT_END_DT, '', '', substr(F.RENT_END_DT, 1, 4) || '-' || substr(F.RENT_END_DT, 5, 2) || '-'||substr(F.RENT_END_DT, 7, 2)) RENT_END_DT, \n"
						+ " C.BUS_ID, C.BRCH_ID, C.NOTE, C.MNG_ID, decode(U.user_nm,null,'',U.user_nm) as MNG_NM, C.REG_ID, \n"
						+ " decode(C.REG_DT, '', '', substr(C.REG_DT, 1, 4) || '-' || substr(C.REG_DT, 5, 2) || '-'||substr(C.REG_DT, 7, 2)) REG_DT,\n"
						+ " C.CAR_ST, C.R_SITE, C.P_ZIP, C.P_ADDR, C.O_MAP, C.USE_YN, C.DEPT_ID, R.car_no \n"
						+ " from CONT C, fee F, users U, car_reg R\n"
						+ " where C.rent_mng_id = F.rent_mng_id\n"
						+ " and C.rent_l_cd = F.rent_l_cd \n"
						+ " and C.mng_id = U.user_id(+)\n"
						+ " and C.car_mng_id = R.car_mng_id\n"
						+ " and  C.RENT_MNG_ID = ? and C.RENT_L_CD = ? ) Y,\n"
					+ " ( select C.RENT_MNG_ID, C.RENT_L_CD,  C.MNG_ID2, decode(U.user_nm,null,'',U.user_nm) as MNG_NM2 \n"
						+ " from CONT C, fee F, users U \n"
						+ " where C.rent_mng_id = F.rent_mng_id \n"
						+ " and C.rent_l_cd = F.rent_l_cd \n"
						+ " and C.mng_id2 = U.user_id(+) \n"
						+ " and  C.RENT_MNG_ID = ? and C.RENT_L_CD = ? ) Z, \n"
					+ " ( select C.RENT_MNG_ID, C.RENT_L_CD,  C.BUS_ID, decode(U.user_nm,null,'',U.user_nm) as BUS_NM, C.BUS_ID2 \n"
						+ " from CONT C, fee F, users U\n"
						+ " where C.rent_mng_id = F.rent_mng_id\n"
						+ " and C.rent_l_cd = F.rent_l_cd \n"
						+ " and C.bus_id = U.user_id(+)\n"
						+ " and  C.RENT_MNG_ID = ? and C.RENT_L_CD = ? ) X \n"
					+ " where Y.RENT_L_CD = Z.RENT_L_CD and Y.RENT_L_CD = X.RENT_L_CD";

		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mng_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, mng_id);
			pstmt.setString(4, l_cd);
			pstmt.setString(5, mng_id);
			pstmt.setString(6, l_cd);

		   	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				base.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				base.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				base.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				base.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				base.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				base.setBus_st(rs.getString("BUS_ST")==null?"":rs.getString("BUS_ST"));
				base.setRent_dt(rs.getString("RENT_DT")==null?"":rs.getString("RENT_DT"));
				base.setDlv_dt(rs.getString("DLV_DT")==null?"":rs.getString("DLV_DT"));
				base.setRent_start_dt(rs.getString("RENT_START_DT")==null?"":rs.getString("RENT_START_DT"));
				base.setRent_end_dt(rs.getString("RENT_END_DT")==null?"":rs.getString("RENT_END_DT"));
				base.setNote(rs.getString("NOTE")==null?"":rs.getString("NOTE"));
				base.setBrch_id(rs.getString("BRCH_ID")==null?"":rs.getString("BRCH_ID"));
				base.setBus_id(rs.getString("BUS_ID")==null?"":rs.getString("BUS_ID"));
				base.setBus_id2(rs.getString("BUS_ID2")==null?"":rs.getString("BUS_ID2"));
				base.setBus_nm(rs.getString("BUS_NM")==null?"":rs.getString("BUS_NM"));
				base.setMng_id(rs.getString("MNG_ID")==null?"":rs.getString("MNG_ID"));
				base.setMng_id2(rs.getString("MNG_ID2")==null?"":rs.getString("MNG_ID2"));
				base.setMng_nm(rs.getString("MNG_NM")==null?"":rs.getString("MNG_NM"));
				base.setMng_nm2(rs.getString("MNG_NM2")==null?"":rs.getString("MNG_NM2"));
				base.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				base.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				base.setCar_st(rs.getString("CAR_ST")==null?"":rs.getString("CAR_ST"));
				base.setR_site(rs.getString("R_SITE")==null?"":rs.getString("R_SITE"));
				base.setP_zip(rs.getString("P_ZIP")==null?"":rs.getString("P_ZIP"));
				base.setP_addr(rs.getString("P_ADDR")==null?"":rs.getString("P_ADDR"));
				base.setO_map(rs.getString("O_MAP")==null?"":rs.getString("O_MAP"));
				base.setUse_yn(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				base.setDept_id(rs.getString("DEPT_ID")==null?"":rs.getString("DEPT_ID"));
				base.setCar_no(rs.getString("CAR_NO")==null?"":rs.getString("CAR_NO"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ContDatabase:getContBase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return base;
		}
	}
		
	/**
	 *	계약코드 앞의 7자리를 넘겨주면 뒷 6자리를 채워서 리턴
	 *	(영업소코드2자리+)연도2자리+자동차회사코드1자리+차량코드2자리	+ 일련번호
	 *		00				00		0				00				000000
	 */	
	private String getNextRent_l_cd(String rent_l_cd)
	{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = "select '"+rent_l_cd.substring(0, 7)+"'|| nvl(ltrim(to_char(to_number(max(substr(rent_l_cd, 8, 13))+1), '000000')), '000001') ID "+
						" from cont "+
						" where rent_l_cd like '%"+rent_l_cd.substring(2, 7)+"%'";
		try
		{	pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[ContDatabase:getNextRent_l_cd]\n"+e);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			return rtnStr;
		}			
	}

	private String getNextRent_mng_id()
	{
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = " select nvl(ltrim(to_char(to_number(MAX(rent_mng_id))+1, '000000')), '000001') ID from cont ";
		
		try
		{	pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[ContDatabase:getNextRent_mng_id]\n"+e);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			return rtnStr;
		}				
	}	
	
	public ContBaseBean insertContBase(ContBaseBean base)
	{
		getConnection();
		PreparedStatement pstmt = null;
		String rent_l_cd 	= "";
		String rent_mng_id 	= "";

		if(base.getRent_mng_id().equals(""))	base.setRent_mng_id(getNextRent_mng_id());
		/* 02년도 계약인 경우만 계약코드생성 method를 이용해 계약코드를 자동부여한다...<-- 기존계약 모두 입력한 후에 삭제되어야할 부분*/
		if(base.getRent_l_cd().substring(2, 4).equals("02"))
				base.setRent_l_cd(getNextRent_l_cd(base.getRent_l_cd().trim()));

		String query = " insert into CONT ( RENT_MNG_ID, RENT_L_CD, CLIENT_ID, CAR_MNG_ID, RENT_ST, BUS_ST, RENT_DT, "+
						" DLV_DT, BUS_ID, BRCH_ID, NOTE, MNG_ID, REG_DT, REG_ID, CAR_ST, R_SITE, P_ZIP, P_ADDR, "+
						" O_MAP, USE_YN ) values "+
						"(?, ?, ?, ?, ?, ?, replace (?, '-', ''), replace (?, '-', ''), ?, ?, ?, ?, "+
						" to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, ?, 'Y')";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, base.getRent_mng_id());
			pstmt.setString(2, base.getRent_l_cd());
			pstmt.setString(3, base.getClient_id());
			pstmt.setString(4, base.getCar_mng_id());
			pstmt.setString(5, base.getRent_st());
			pstmt.setString(6, base.getBus_st());
			
			pstmt.setString(7, base.getRent_dt());
			pstmt.setString(8, base.getDlv_dt());
//			pstmt.setString(9, base.getRent_start_dt());
			
			pstmt.setString(9, base.getBus_id());
			pstmt.setString(10, base.getBrch_id());
			pstmt.setString(11, base.getNote());
			pstmt.setString(12, base.getMng_id());
			pstmt.setString(13, base.getReg_id());
			pstmt.setString(14, base.getCar_st());
			
			pstmt.setString(15, base.getR_site());
			pstmt.setString(16, base.getP_zip());
			pstmt.setString(17, base.getP_addr());
			pstmt.setString(18, base.getO_map());
						
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		} catch (SQLException e) {
			System.out.println("[ContDatabase:insertContBase]\n"+e);
	  		e.printStackTrace();
	  		base = null;
			conn.rollback();
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:insertContBase]\n"+e);
	  		e.printStackTrace();
	  		base = null;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return base;
		}
	}
	
	/**
	 *	재계약기본 insert
	 */
	public boolean insertReContBase(ContBaseBean base)
	{
		boolean flag = true;
		getConnection();
		PreparedStatement pstmt = null;

		String query = " insert into CONT ( RENT_MNG_ID, RENT_L_CD, CLIENT_ID, CAR_MNG_ID, RENT_ST, BUS_ST, RENT_DT, "+
						" BUS_ID, BRCH_ID, NOTE, MNG_ID, REG_ID, REG_DT, CAR_ST, R_SITE, P_ZIP, P_ADDR, "+
						" O_MAP, USE_YN ) values "+
						"(?, ?, ?, ?, ?, ?, replace (?, '-', ''), replace (?, '-', ''), replace (?, '-', ''), ?, ?, ?, ?, ?, "+
						" to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?, 'Y')";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, base.getRent_mng_id());
			pstmt.setString(2, base.getRent_l_cd());
			pstmt.setString(3, base.getClient_id());
			pstmt.setString(4, base.getCar_mng_id());
			pstmt.setString(5, base.getRent_st());
			pstmt.setString(6, base.getBus_st());
			
			pstmt.setString(7, base.getRent_dt());
//			pstmt.setString(8, base.getDlv_dt());
//			pstmt.setString(9, base.getRent_start_dt());
			
			pstmt.setString(8, base.getBus_id());
			pstmt.setString(9, base.getBrch_id());
			pstmt.setString(10, base.getNote());
			pstmt.setString(11, base.getMng_id());
			pstmt.setString(12, base.getReg_id());
			pstmt.setString(13, base.getCar_st());
			
			pstmt.setString(14, base.getR_site());
			pstmt.setString(15, base.getP_zip());
			pstmt.setString(16, base.getP_addr());
			pstmt.setString(17, base.getO_map());
		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
		    	
		} catch (SQLException e) {
			System.out.println("[ContDatabase:insertReContBase]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:insertReContBase]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	/**
	 *	계약 기본 등록 후,  계약서에 관련된 5개의 테이블에 해당 계약의 Row를 만들어준다.
	 *	수정과 등록이 한꺼번에 진행되기 때문.
	 */
	public boolean insertContEtcRows(String m_id, String l_cd)
	{
		int flag = 0;
		CarMgrBean mgr1 = new CarMgrBean();
			mgr1.setRent_mng_id(m_id);
			mgr1.setRent_l_cd(l_cd);
			mgr1.setMgr_id("0");
			mgr1.setMgr_st("차량이용자");
			if(!insertCarMgr(mgr1))		flag += 1;
		CarMgrBean mgr2 = new CarMgrBean();
			mgr2.setRent_mng_id(m_id);
			mgr2.setRent_l_cd(l_cd);
			mgr2.setMgr_id("1");
			mgr2.setMgr_st("차량관리자");
			if(!insertCarMgr(mgr2))		flag += 1;
		CarMgrBean mgr3 = new CarMgrBean();
			mgr3.setRent_mng_id(m_id);
			mgr3.setRent_l_cd(l_cd);
			mgr3.setMgr_id("2");
			mgr3.setMgr_st("회계관리자");
			if(!insertCarMgr(mgr3))		flag += 1;
		ContPurBean pur = new ContPurBean();
			pur.setRent_mng_id(m_id);
			pur.setRent_l_cd(l_cd);
			if(!insertContPur(pur))		flag += 1;
		ContCarBean car = new ContCarBean();
			car.setRent_mng_id(m_id);
			car.setRent_l_cd(l_cd);
			if(!insertContCar(car))		flag += 1;
		ContFeeBean fee = new ContFeeBean();
			fee.setRent_mng_id(m_id);
			fee.setRent_l_cd(l_cd);
			fee.setRent_st("1");
			if(!insertContFee(fee))		flag += 1;
		ContDebtBean debt = new ContDebtBean();
			debt.setRent_mng_id(m_id);
			debt.setRent_l_cd(l_cd);
			if(!insertContDebt(debt))	flag += 1;

		if(flag == 0)	return true;
		else			return false;
	}
	
	/**
	 * 	재계약 기본 data 등록
	 *	
	 */
	public boolean insertReContEtcRows(String rent_mng_id, String old_rent_l_cd, String new_rent_l_cd)
	{
		int flag = 0;

		ContBaseBean base = getContBase(rent_mng_id, old_rent_l_cd);	/*계약기본*/
		base.setRent_l_cd(new_rent_l_cd);
		if(!insertReContBase(base))		flag += 1;

		Vector mgrs = getCarMgr(rent_mng_id, old_rent_l_cd);	//차량관리자
		int mgr_size = mgrs.size();
		for(int i = 0 ; i < mgr_size; i++)
		{
			CarMgrBean mgr = (CarMgrBean)mgrs.elementAt(i);
			mgr.setRent_l_cd(new_rent_l_cd);
			if(!insertCarMgr(mgr))		flag += 1;
		}

		ContPurBean pur = getContPur(rent_mng_id, old_rent_l_cd);	//차량구매
		pur.setRent_l_cd(new_rent_l_cd);
		if(!insertContPur(pur))		flag += 1;
		
		ContCarBean car = getContCar(rent_mng_id, old_rent_l_cd);	//차량기본
		car.setRent_l_cd(new_rent_l_cd);
		if(!insertContCar(car))		flag += 1;
		
		ContFeeBean fee1 = getContFee(rent_mng_id, old_rent_l_cd, "1");	//대여료
		fee1.setRent_l_cd(new_rent_l_cd);
		if(!insertContFee(fee1))		flag += 1;
		
		ContFeeBean fee2 = getContFee(rent_mng_id, old_rent_l_cd, "2");	//연장대여계약 있을경우
		if(!fee2.getRent_mng_id().equals(""))
		{
			fee2.setRent_l_cd(new_rent_l_cd);
			if(!insertContFee(fee2))		flag += 1;
		}
		
		ContDebtBean debt = getContDebt(rent_mng_id, old_rent_l_cd);	//할부
		debt.setRent_l_cd(new_rent_l_cd);
		if(!insertContDebt(debt))	flag += 1;

		Vector commis = getCommi(rent_mng_id, old_rent_l_cd);	//지급수수료
		int commi_size = commis.size();
		for(int i = 0 ; i < commi_size; i++)
		{
			CommiBean commi = (CommiBean)commis.elementAt(i);
			commi.setRent_l_cd(new_rent_l_cd);
			if(!insertCommi(commi))		flag += 1;
		}
		
		Vector cltrs = getCltrs(rent_mng_id, old_rent_l_cd);	//근저당설정내용
		int cltr_size = cltrs.size();
		for(int i = 0 ; i < cltr_size; i++)
		{
			CltrBean cltr = (CltrBean)cltrs.elementAt(i);
			cltr.setRent_l_cd(new_rent_l_cd);
			if(!insertCltr(cltr))		flag += 1;
		}
		
		if(flag == 0)	return true;
		else			return false;
	}	

	public boolean updateContBase(ContBaseBean base)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update CONT set "+
						" CLIENT_ID = ?,"+
						" CAR_MNG_ID = ?,"+
						" RENT_ST = ?,"+
						" BUS_ST = ?,"+
						" RENT_DT = replace (?, '-', ''),"+
						" DLV_DT = replace (?, '-', ''),"+
//						" RENT_START_DT = replace (?, '-', ''),"+
						" BUS_ID = ?,"+
						" BRCH_ID = ?,"+
						" NOTE = ?,"+
						" MNG_ID = ?,"+
						" REG_ID = ?,"+
						" REG_DT = replace (?, '-', ''),"+
						" CAR_ST = ?,"+
						" R_SITE = ?,"+
						" P_ZIP = ?,"+
						" P_ADDR = ?,"+
						" O_MAP = ?,"+
						" USE_YN = ?"+
						" where"+
						" RENT_MNG_ID = ? and"+
						" RENT_L_CD = ?";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, base.getClient_id());
			pstmt.setString(2, base.getCar_mng_id());
			pstmt.setString(3, base.getRent_st());
			pstmt.setString(4, base.getBus_st());
			pstmt.setString(5, base.getRent_dt());
			pstmt.setString(6, base.getDlv_dt());
			pstmt.setString(7,  base.getBus_id());
			pstmt.setString(8, base.getBrch_id());
			pstmt.setString(9, base.getNote());
			pstmt.setString(10, base.getMng_id());
			pstmt.setString(11, base.getReg_id());
			pstmt.setString(12, base.getReg_dt());
			pstmt.setString(13, base.getCar_st());
			pstmt.setString(14, base.getR_site());
			pstmt.setString(15, base.getP_zip());
			pstmt.setString(16, base.getP_addr());
			pstmt.setString(17, base.getO_map());
			pstmt.setString(18, base.getUse_yn());
			pstmt.setString(19, base.getRent_mng_id());
			pstmt.setString(20, base.getRent_l_cd());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
		} catch (SQLException e) {
			System.out.println("[ContDatabase:updateContBase]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:updateContBase]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
		
	public boolean insertCommi(CommiBean commi)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " insert into COMMI (RENT_MNG_ID, EMP_ID, RENT_L_CD, AGNT_ST, COMMI, INC_AMT,"+
						" RES_AMT, TOT_AMT, DIF_AMT, SUP_DT, REL) values"+
						"(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, commi.getRent_mng_id());
			pstmt.setString(2, commi.getEmp_id());
			pstmt.setString(3, commi.getRent_l_cd());
			pstmt.setString(4, commi.getAgnt_st());
			pstmt.setInt(5, commi.getCommi());
			pstmt.setInt(6, commi.getInc_amt());
			pstmt.setInt(7, commi.getRes_amt());
			pstmt.setInt(8, commi.getTot_amt());
			pstmt.setInt(9, commi.getDif_amt());
			pstmt.setString(10, commi.getSup_dt());
			pstmt.setString(11, commi.getRel());
		    pstmt.executeUpdate();
		    pstmt.close();
		   	conn.commit();
	  	}
	  	catch(Exception e)
	  	{
	  		System.out.println("[ContDatabase:insertCommi]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}finally{
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean deleteCommi(String m_id, String l_cd, String agnt_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " delete from COMMI where RENT_MNG_ID = ? and RENT_L_CD = ? and AGNT_ST = ? ";
		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, agnt_st);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:deleteCommi]\n"+e);
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
	
	public boolean updateCommi(CommiBean commi)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update COMMI set "+
						" EMP_ID = ?, "+
						" REL = ? "+						
						" where "+
						" RENT_MNG_ID = ? and RENT_L_CD = ? and AGNT_ST = ?";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, commi.getEmp_id());
			pstmt.setString(2, commi.getRel());
		    pstmt.setString(3, commi.getRent_mng_id());
			pstmt.setString(4, commi.getRent_l_cd());
			pstmt.setString(5, commi.getAgnt_st());
			
		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:updateCommi]\n"+e);
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

	public boolean insertCarMgr(CarMgrBean mgr)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1=null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = " insert into CAR_MGR (RENT_MNG_ID, RENT_L_CD, MGR_ID, MGR_ST, MGR_NM, MGR_DEPT, MGR_TITLE, MGR_TEL, MGR_M_TEL, MGR_EMAIL ) values "+
						"( ?, ?, ?, rtrim(?), ?, ?, ?, ?, ?, ? )";
		if(mgr.getMgr_id().equals(""))
		{
			try
			{
				String qry_id = "select nvl(ltrim(to_char(to_number(MAX(mgr_id))+1, '0')), '0') ID from CAR_MGR "+
								" where  RENT_MNG_ID = '"+ mgr.getRent_mng_id()+"' and RENT_L_CD = '"+ mgr.getRent_l_cd() +"'" ;
				pstmt1 = conn.prepareStatement(qry_id);
			   	rs = pstmt1.executeQuery();
				if(rs.next())
				{
					rtnStr = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
				pstmt1.close();
				mgr.setMgr_id(rtnStr);
			}catch(Exception e){	e.printStackTrace();	flag = false;
			}finally{
				try{
	                if(rs != null )		rs.close();
		            if(pstmt1 != null)	pstmt1.close();
				}catch(Exception ignore){}
			}
		}
		try
		{
			conn.setAutoCommit(false);
				
			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, mgr.getRent_mng_id());
			pstmt2.setString(2, mgr.getRent_l_cd());
			pstmt2.setString(3, mgr.getMgr_id());
			pstmt2.setString(4, mgr.getMgr_st());
			pstmt2.setString(5, mgr.getMgr_nm());
			pstmt2.setString(6, mgr.getMgr_dept());
			pstmt2.setString(7, mgr.getMgr_title());
			pstmt2.setString(8, mgr.getMgr_tel());
			pstmt2.setString(9, mgr.getMgr_m_tel());
			pstmt2.setString(10, mgr.getMgr_email());
		    pstmt2.executeUpdate();
			pstmt2.close();
		    
		    conn.commit();
		      
	  	}catch(Exception e){
	  		System.out.println("[ContDatabase:insertCarMgr]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
	            if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	public boolean delCarMgr(String m_id, String l_cd, String mgr_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " delete from CAR_MGR "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? and MGR_ID = ? ";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, mgr_id);
		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:delCarMgr]\n"+e);
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

	public boolean updateCarMgr(CarMgrBean mgr)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update CAR_MGR set "+
						" MGR_ST = rtrim(?), "+
						" MGR_NM = ?, "+
						" MGR_DEPT = ?, "+
						" MGR_TITLE = ?, "+
						" MGR_TEL = ?, "+
						" MGR_M_TEL = ?, "+
						" MGR_EMAIL = ? "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? and MGR_ID = ? ";
		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mgr.getMgr_st());
			pstmt.setString(2, mgr.getMgr_nm());
			pstmt.setString(3, mgr.getMgr_dept());
			pstmt.setString(4, mgr.getMgr_title());
			pstmt.setString(5, mgr.getMgr_tel());
			pstmt.setString(6, mgr.getMgr_m_tel());
			pstmt.setString(7, mgr.getMgr_email());
		    pstmt.setString(8, mgr.getRent_mng_id());
			pstmt.setString(9, mgr.getRent_l_cd());
			pstmt.setString(10,mgr.getMgr_id());
		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:updateCarMgr]\n"+e);
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
	 *	차량관리자 update(한 업체관련 계약 공통 차량관리자)
	 */
	public boolean updateCarMgrAll(String c_id, CarMgrBean mgr)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean flag = true;
		String query = "select rent_mng_id, rent_l_cd from cont where client_id = ?";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, c_id);
		    rs = pstmt.executeQuery();
		    
		    while(rs.next())
		    {
		    	mgr.setRent_mng_id(rs.getString("RENT_MNG_ID"));	
		    	mgr.setRent_l_cd(rs.getString("RENT_L_CD"));
				updateCarMgrAll_IN(mgr);
		    }
			rs.close();
			pstmt.close();
		    
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:updateCarMgrAll]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	/**
	 *	차량관리자 update ---> 내부 LOOP(한 업체관련 계약 공통 차량관리자)
	 */
	public boolean updateCarMgrAll_IN(CarMgrBean mgr)
	{
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update CAR_MGR set "+
							" MGR_ST = rtrim(?), "+
							" MGR_NM = ?, "+
							" MGR_DEPT = ?, "+
							" MGR_TITLE = ?, "+
							" MGR_TEL = ?, "+
							" MGR_M_TEL = ?, "+
							" MGR_EMAIL = ? "+
							" where RENT_MNG_ID = ? and RENT_L_CD = ? and MGR_ID = ? ";		
		try 
		{
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, mgr.getMgr_st());
				pstmt.setString(2, mgr.getMgr_nm());
				pstmt.setString(3, mgr.getMgr_dept());
				pstmt.setString(4, mgr.getMgr_title());
				pstmt.setString(5, mgr.getMgr_tel());
				pstmt.setString(6, mgr.getMgr_m_tel());
				pstmt.setString(7, mgr.getMgr_email());
			    pstmt.setString(8, mgr.getRent_mng_id());
				pstmt.setString(9, mgr.getRent_l_cd());
				pstmt.setString(10,mgr.getMgr_id());
			    pstmt.executeUpdate();
			    pstmt.close();
			     conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:updateCarMgrAll_IN]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			return flag;
		}
	}	
	
	public boolean insertContPur(ContPurBean pur)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " insert into CAR_PUR (RENT_MNG_ID, RENT_L_CD, RPT_NO, DLV_BRCH, REG_EXT_DT, DLV_CON_DT, DLV_EST_DT, "+
						" TMP_DRV_NO, GDS_YN, PUR_ST, CON_AMT, CON_PAY_DT, "+
						" TRF_AMT1, TRF_PAY_DT1, TRF_AMT2, TRF_PAY_DT2, TRF_AMT3, TRF_PAY_DT3, TRF_AMT4, TRF_PAY_DT4 ) values "+
						"( ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''),  "+
						" ?, ?, ?, ?, replace(?, '-', ''), "+
						" ?, replace(?, '-', ''), ?, replace(?, '-', ''), ?, replace(?, '-', ''), ?, replace(?, '-', ''))";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1 , pur.getRent_mng_id());
			pstmt.setString(2 , pur.getRent_l_cd());
			pstmt.setString(3 , pur.getRpt_no().trim());
			pstmt.setString(4 , pur.getDlv_brch());
			pstmt.setString(5 , pur.getReg_ext_dt());
			pstmt.setString(6 , pur.getDlv_con_dt());
			pstmt.setString(7 , pur.getDlv_est_dt());
			pstmt.setString(8 , pur.getTmp_drv_no());
			pstmt.setString(9 , pur.getGds_yn());
			pstmt.setString(10, pur.getPur_st());
			pstmt.setInt(11, pur.getCon_amt());
			pstmt.setString(12, pur.getCon_pay_dt());
			pstmt.setInt(13, pur.getTrf_amt1());
			pstmt.setString(14, pur.getTrf_pay_dt1());
			pstmt.setInt(15, pur.getTrf_amt2());
			pstmt.setString(16, pur.getTrf_pay_dt2());
			pstmt.setInt(17, pur.getTrf_amt3());
			pstmt.setString(18, pur.getTrf_pay_dt3());
			pstmt.setInt(19, pur.getTrf_amt4());
			pstmt.setString(20, pur.getTrf_pay_dt4());
		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
		     
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:insertContPur]\n"+e);
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
	
	public boolean updateContPur(ContPurBean pur)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update CAR_PUR set "+
							" RPT_NO = ?, "+
							" DLV_BRCH = ?, "+
							" REG_EXT_DT = replace(?, '-', ''),"+
							" DLV_CON_DT = replace(?, '-', ''),"+
							" DLV_EST_DT = replace(?, '-', ''),"+
							" TMP_DRV_NO = ?, "+
							" GDS_YN = ?, "+
							" PUR_ST = ?, "+
							" CON_AMT = ?, "+
							" CON_PAY_DT = replace(?, '-', ''), "+
							" TRF_AMT1 = ?, "+
							" TRF_PAY_DT1 = replace(?, '-', ''), "+
							" TRF_AMT2 = ?, "+
							" TRF_PAY_DT2 = replace(?, '-', ''), "+
							" TRF_AMT3 = ?, "+
							" TRF_PAY_DT3 = replace(?, '-', ''), "+
							" TRF_AMT4 = ?, "+
							" TRF_PAY_DT4 = replace(?, '-', '') "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? ";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, pur.getRpt_no().trim());
			pstmt.setString(2, pur.getDlv_brch());
			pstmt.setString(3, pur.getReg_ext_dt());
			pstmt.setString(4, pur.getDlv_con_dt());
			pstmt.setString(5, pur.getDlv_est_dt());
			pstmt.setString(6, pur.getTmp_drv_no());
			pstmt.setString(7, pur.getGds_yn());
			pstmt.setString(8, pur.getPur_st());
			pstmt.setInt(9, pur.getCon_amt());
			pstmt.setString(10, pur.getCon_pay_dt());
			pstmt.setInt(11, pur.getTrf_amt1());
			pstmt.setString(12, pur.getTrf_pay_dt1());
			pstmt.setInt(13, pur.getTrf_amt2());
			pstmt.setString(14, pur.getTrf_pay_dt2());
			pstmt.setInt(15, pur.getTrf_amt3());
			pstmt.setString(16, pur.getTrf_pay_dt3());
			pstmt.setInt(17, pur.getTrf_amt4());
			pstmt.setString(18, pur.getTrf_pay_dt4());
		    pstmt.setString(19, pur.getRent_mng_id());
			pstmt.setString(20, pur.getRent_l_cd());
			pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
		        
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:updateContPur]\n"+e);
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
	
	public boolean insertContCar(ContCarBean car)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " insert into CAR_ETC (RENT_MNG_ID, RENT_L_CD, CAR_ID, COLO, EX_GAS, IMM_AMT, OPT, LPG_YN, LPG_SETTER, "+
						" LPG_PRICE, LPG_PAY_DT, CAR_CS_AMT, CAR_CV_AMT, CAR_FS_AMT, CAR_FV_AMT, OPT_CS_AMT, OPT_CV_AMT, "+
						" OPT_FS_AMT, OPT_FV_AMT, CLR_CS_AMT, CLR_CV_AMT, CLR_FS_AMT, CLR_FV_AMT, SD_CS_AMT, SD_CV_AMT, "+
						" SD_FS_AMT, SD_FV_AMT, DC_CS_AMT, DC_CV_AMT, DC_FS_AMT, DC_FV_AMT ) values "+
						"( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car.getRent_mng_id());
			pstmt.setString(2, car.getRent_l_cd());
			pstmt.setString(3, car.getCar_id());
			pstmt.setString(4, car.getColo());
			pstmt.setString(5, car.getEx_gas());
			pstmt.setInt(6, car.getImm_amt());
			pstmt.setString(7, car.getOpt());
			pstmt.setString(8, car.getLpg_yn());
			pstmt.setString(9, car.getLpg_setter());
			pstmt.setInt(10, car.getLpg_price());
			pstmt.setString(11, car.getLpg_pay_dt());
			pstmt.setInt(12, car.getCar_cs_amt());
			pstmt.setInt(13, car.getCar_cv_amt());
			pstmt.setInt(14, car.getCar_fs_amt());
			pstmt.setInt(15, car.getCar_fv_amt());
			pstmt.setInt(16, car.getOpt_cs_amt());
			pstmt.setInt(17, car.getOpt_cv_amt());
			pstmt.setInt(18, car.getOpt_fs_amt());
			pstmt.setInt(19, car.getOpt_fv_amt());
			pstmt.setInt(20, car.getClr_cs_amt());
			pstmt.setInt(21, car.getClr_cv_amt());
			pstmt.setInt(22, car.getClr_fs_amt());
			pstmt.setInt(23, car.getClr_fv_amt());
			pstmt.setInt(24, car.getSd_cs_amt());
			pstmt.setInt(25, car.getSd_cv_amt());
			pstmt.setInt(26, car.getSd_fs_amt());
			pstmt.setInt(27, car.getSd_fv_amt());
			pstmt.setInt(28, car.getDc_cs_amt());
			pstmt.setInt(29, car.getDc_cv_amt());
			pstmt.setInt(30, car.getDc_fs_amt());
			pstmt.setInt(31, car.getDc_fv_amt());
		    pstmt.executeUpdate();
		    pstmt.close();
		     conn.commit();
		     
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:insertContCar]\n"+e);
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
	public boolean updateContCar(ContCarBean car)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update CAR_ETC set "+
						" CAR_ID = ?, "+
						" COLO= ?, "+
						" EX_GAS= ?, "+
						" IMM_AMT= ?, "+
						" OPT= ?, "+
						" LPG_YN= ?, "+
						" LPG_SETTER= ?, "+
						" LPG_PRICE= ?, "+
						" LPG_PAY_DT = replace(?, '-', ''), "+ 
						" CAR_CS_AMT = ?, "+ 
						" CAR_CV_AMT = ?, "+ 
						" CAR_FS_AMT = ?, "+ 
						" CAR_FV_AMT = ?, "+ 
						" OPT_CS_AMT = ?, "+ 
						" OPT_CV_AMT = ?, "+ 
						" OPT_FS_AMT = ?, "+ 
						" OPT_FV_AMT = ?, "+ 
						" CLR_CS_AMT = ?, "+ 
						" CLR_CV_AMT = ?, "+ 
						" CLR_FS_AMT = ?, "+ 
						" CLR_FV_AMT = ?, "+ 
						" SD_CS_AMT = ?, "+
						" SD_CV_AMT = ?, "+
						" SD_FS_AMT = ?, "+
						" SD_FV_AMT = ?, "+
						" DC_CS_AMT = ?, "+
						" DC_CV_AMT = ?, "+
						" DC_FS_AMT = ?, "+
						" DC_FV_AMT = ? "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? ";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car.getCar_id());
			pstmt.setString(2, car.getColo());
			pstmt.setString(3, car.getEx_gas());
			pstmt.setInt(4, car.getImm_amt());
			pstmt.setString(5, car.getOpt());
			pstmt.setString(6, car.getLpg_yn());
			pstmt.setString(7, car.getLpg_setter());
			pstmt.setInt(8, car.getLpg_price());
			pstmt.setString(9, car.getLpg_pay_dt());
			pstmt.setInt(10, car.getCar_cs_amt());
			pstmt.setInt(11, car.getCar_cv_amt());
			pstmt.setInt(12, car.getCar_fs_amt());
			pstmt.setInt(13, car.getCar_fv_amt());
			pstmt.setInt(14, car.getOpt_cs_amt());
			pstmt.setInt(15, car.getOpt_cv_amt());
			pstmt.setInt(16, car.getOpt_fs_amt());
			pstmt.setInt(17, car.getOpt_fv_amt());
			pstmt.setInt(18, car.getClr_cs_amt());
			pstmt.setInt(19, car.getClr_cv_amt());
			pstmt.setInt(20, car.getClr_fs_amt());
			pstmt.setInt(21, car.getClr_fv_amt());
			pstmt.setInt(22, car.getSd_cs_amt());
			pstmt.setInt(23, car.getSd_cv_amt());
			pstmt.setInt(24, car.getSd_fs_amt());
			pstmt.setInt(25, car.getSd_fv_amt());
			pstmt.setInt(26, car.getDc_cs_amt());
			pstmt.setInt(27, car.getDc_cv_amt());
			pstmt.setInt(28, car.getDc_fs_amt());
			pstmt.setInt(29, car.getDc_fv_amt());
			pstmt.setString(30, car.getRent_mng_id());
			pstmt.setString(31, car.getRent_l_cd());
		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:updateContCar]\n"+e);
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
	
	public boolean insertContFee(ContFeeBean fee)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " insert into FEE (RENT_MNG_ID, RENT_L_CD, RENT_ST, RENT_WAY, CAR_ST, CON_MON, "+
							" RENT_START_DT, RENT_END_DT, PRV_DLV_YN, PRV_CAR_MNG_ID, PRV_START_DT, PRV_END_DT, "+
							" GRT_AMT_S, GRT_ETC, GRT_EST_DT, GRT_PAY_YN, PP_S_AMT, PP_V_AMT, PP_ETC, PP_EST_DT, "+
							" PP_PAY_YN, IFEE_S_AMT, IFEE_V_AMT, IFEE_ETC, IFEE_EST_DT, IFEE_PAY_YN, INV_S_AMT, "+
							" INV_V_AMT, INV_ETC, OPT_S_AMT, OPT_V_AMT, OPT_YN, OPT_ETC, FEE_S_AMT, FEE_V_AMT, "+
							" FEE_ETC, FEE_ST, FEE_REQ_DAY, FEE_EST_DAY, FEE_BANK, FEE_PAY_ST, FEE_PAY_TM, "+
							" FEE_PAY_START_DT, FEE_PAY_END_DT, FEE_FST_DT, FEE_FST_AMT, FEE_CDT, EXT_AGNT, BR_ID, RC_DAY, NEXT_YN ) values "+
							"(?, ?, ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), ?, ?, "+
							" replace(?, '-', ''), replace(?, '-', ''), ?, ?, replace(?, '-', ''), ?, ?, ?, ?, replace(?, '-', ''), "+
							" ?, ?, ?, ?, replace(?, '-', ''), ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
							" ?, ?, replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), ?, ?, ?, ?, ?, ?)";
		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, fee.getRent_mng_id());
			pstmt.setString(2, fee.getRent_l_cd());
			pstmt.setString(3, fee.getRent_st());
			pstmt.setString(4, fee.getRent_way());
			pstmt.setString(5, fee.getCar_st());
			pstmt.setString(6, fee.getCon_mon());
			pstmt.setString(7, fee.getRent_start_dt());
			pstmt.setString(8, fee.getRent_end_dt());
			pstmt.setString(9, fee.getPrv_dlv_yn());
			pstmt.setString(10, fee.getPrv_car_mng_id());
			pstmt.setString(11, fee.getPrv_start_dt());
			pstmt.setString(12, fee.getPrv_end_dt());
			pstmt.setInt(13, fee.getGrt_amt_s());
			pstmt.setString(14, fee.getGrt_etc());
			pstmt.setString(15, fee.getGrt_est_dt());
			pstmt.setString(16, fee.getGrt_pay_yn());
			pstmt.setInt(17, fee.getPp_s_amt());
			pstmt.setInt(18, fee.getPp_v_amt());
			pstmt.setString(19, fee.getPp_etc());
			pstmt.setString(20, fee.getPp_est_dt());
			pstmt.setString(21, fee.getPp_pay_yn());
			pstmt.setInt(22, fee.getIfee_s_amt());
			pstmt.setInt(23, fee.getIfee_v_amt());
			pstmt.setString(24, fee.getIfee_etc());
			pstmt.setString(25, fee.getIfee_est_dt());
			pstmt.setString(26, fee.getIfee_pay_yn());
			pstmt.setInt(27, fee.getInv_s_amt());
			pstmt.setInt(28, fee.getInv_v_amt());
			pstmt.setString(29, fee.getInv_etc());
			pstmt.setInt(30, fee.getOpt_s_amt());
			pstmt.setInt(31, fee.getOpt_v_amt());
			pstmt.setString(32, fee.getOpt_yn());
			pstmt.setString(33, fee.getOpt_etc());
			pstmt.setInt(34, fee.getFee_s_amt());
			pstmt.setInt(35, fee.getFee_v_amt());
			pstmt.setString(36, fee.getFee_etc());
			pstmt.setString(37, fee.getFee_st());
			pstmt.setString(38, fee.getFee_req_day());
			pstmt.setString(39, fee.getFee_est_day());
			pstmt.setString(40, fee.getFee_bank());
			pstmt.setString(41, fee.getFee_pay_st());
			pstmt.setString(42, fee.getFee_pay_tm());
			pstmt.setString(43, fee.getFee_pay_start_dt());
			pstmt.setString(44, fee.getFee_pay_end_dt()); 
			pstmt.setString(45, fee.getFee_fst_dt());
			pstmt.setInt(46, fee.getFee_fst_amt());
			pstmt.setString(47, fee.getFee_cdt());
			pstmt.setString(48, fee.getExt_agnt());
			
			pstmt.setString(49, fee.getBr_id());
			pstmt.setString(50, fee.getRc_day());
			pstmt.setString(51, fee.getNext_yn());
		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:insertContFee]\n"+e);
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
	
	public boolean updateContFee(ContFeeBean fee)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update FEE set "+
						" RENT_WAY			= ?, "+
						" CAR_ST			= ?, "+
						" CON_MON			= ?, "+
						" RENT_START_DT		= replace(?, '-', ''),"+
						" RENT_END_DT		= replace(?, '-', ''), "+
						" PRV_DLV_YN		= ?, "+
						" PRV_CAR_MNG_ID	= ?, "+
						" PRV_START_DT		= replace(?, '-', ''), "+
						" PRV_END_DT		= replace(?, '-', ''), "+
						" GRT_AMT_S			= ?, "+
						" GRT_ETC			= ?, "+
						" GRT_EST_DT		= replace(?, '-', ''), "+
						" GRT_PAY_YN		= ?, "+
						" PP_S_AMT			= ?, "+
						" PP_V_AMT			= ?, "+
						" PP_ETC			= ?, "+
						" PP_EST_DT			= replace(?, '-', ''), "+
						" PP_PAY_YN			= ?, "+
						" IFEE_S_AMT		= ?, "+
						" IFEE_V_AMT		= ?, "+
						" IFEE_ETC			= ?, "+
						" IFEE_EST_DT		= replace(?, '-', ''), "+
						" IFEE_PAY_YN		= ?, "+
						" INV_S_AMT			= ?, "+
						" INV_V_AMT			= ?, "+
						" INV_ETC			= ?, "+
						" OPT_S_AMT			= ?, "+
						" OPT_V_AMT			= ?, "+
						" OPT_YN			= ?, "+
						" OPT_ETC			= ?, "+
						" FEE_S_AMT			= ?, "+
						" FEE_V_AMT			= ?, "+
						" FEE_ETC			= ?, "+
						" FEE_ST			= ?, "+
						" FEE_REQ_DAY		= ?, "+
						" FEE_EST_DAY		= ?, "+
						" FEE_BANK			= ?, "+
						" FEE_PAY_ST		= ?, "+
						" FEE_PAY_TM		= ?, "+
						" FEE_PAY_START_DT	= replace(?, '-', ''),"+ 
						" FEE_PAY_END_DT	= replace(?, '-', ''),"+
						" FEE_FST_DT		= replace(?, '-', ''),"+
						" FEE_FST_AMT		= ?, "+
						" FEE_CDT			= ?, "+
						" EXT_AGNT			= ?, "+
						" BR_ID				= ?, "+
						" RC_DAY			= ?, "+
						" NEXT_YN			= ?, "+
						" OPT_CHK			= ?, "+
						" FEE_SH			= ?, "+
						" PRV_MON_YN		= ?, "+
						" FEE_CHK			= ?, "+
						" OPT_PER			= ?, "+
						" RENT_DT			= replace(?, '-', ''),"+
						" GRT_SUC_YN		= ?, "+
						" IFEE_SUC_YN		= ?, "+
						" RENT_EST_DT		= replace(?, '-', ''),"+
						" LEAVE_DAY			= ?, "+
						" CLS_PER			= ?, "+
						" gur_per			= ?, "+     
						" gur_p_per			= ?, "+     
						" pere_per			= ?, "+     
						" pere_r_per		= ?, "+     
						" pere_mth			= ?, "+     
						" pere_r_mth		= ?, "+     
						" max_ja			= ?, "+     
						" app_ja			= ?, "+     
						" opt_st			= ?, "+     
						" dc_ra				= ?, "+     
						" bas_dt			= replace(?, '-', ''),"+
						" fee_sac_id		= ?, "+     
						" def_st			= ?, "+     
						" def_remark		= ?, "+     
						" def_sac_id		= ?, "+   
						" cls_r_per			= ?, "+   
						" ja_s_amt			= ?, "+   
						" ja_v_amt			= ?, "+  
						" credit_per  		= ?, "+   
						" credit_r_per		= ?, "+   			
						" credit_amt  		= ?, "+   
						" credit_r_amt		= ?, "+  
						" ja_r_s_amt		= ?, "+   
						" ja_r_v_amt		= ?, "+  	
						" rtn_st			= ? "+  	
						" where RENT_MNG_ID = ? and RENT_L_CD = ? and RENT_ST = ? ";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  fee.getRent_way()			);
			pstmt.setString(2,  fee.getCar_st()				);
			pstmt.setString(3,  fee.getCon_mon()			);
			pstmt.setString(4,  fee.getRent_start_dt()		);
			pstmt.setString(5,  fee.getRent_end_dt()		);			
			pstmt.setString(6,  fee.getPrv_dlv_yn()			);
			pstmt.setString(7,  fee.getPrv_car_mng_id()		);
			pstmt.setString(8,  fee.getPrv_start_dt()		);
			pstmt.setString(9,  fee.getPrv_end_dt()			);
			pstmt.setInt   (10, fee.getGrt_amt_s()			);			
			pstmt.setString(11, fee.getGrt_etc()			);
			pstmt.setString(12, fee.getGrt_est_dt()			);
			pstmt.setString(13, fee.getGrt_pay_yn()			);
			pstmt.setInt   (14, fee.getPp_s_amt()			);
			pstmt.setInt   (15, fee.getPp_v_amt()			);			
			pstmt.setString(16, fee.getPp_etc()				);
			pstmt.setString(17, fee.getPp_est_dt()			);
			pstmt.setString(18, fee.getPp_pay_yn()			);
			pstmt.setInt   (19, fee.getIfee_s_amt()			);
			pstmt.setInt   (20, fee.getIfee_v_amt()			);			
			pstmt.setString(21, fee.getIfee_etc()			);
			pstmt.setString(22, fee.getIfee_est_dt()		);
			pstmt.setString(23, fee.getIfee_pay_yn()		);
			pstmt.setInt   (24, fee.getInv_s_amt()			);
			pstmt.setInt   (25, fee.getInv_v_amt()			);			
			pstmt.setString(26, fee.getInv_etc()			);
			pstmt.setInt   (27, fee.getOpt_s_amt()			);
			pstmt.setInt   (28, fee.getOpt_v_amt()			);
			pstmt.setString(29, fee.getOpt_yn()				);
			pstmt.setString(30, fee.getOpt_etc()			);			
			pstmt.setInt   (31, fee.getFee_s_amt()			);
			pstmt.setInt   (32, fee.getFee_v_amt()			);
			pstmt.setString(33, fee.getFee_etc()			);
			pstmt.setString(34, fee.getFee_st()				);
			pstmt.setString(35, fee.getFee_req_day()		);			
			pstmt.setString(36, fee.getFee_est_day()		);
			pstmt.setString(37, fee.getFee_bank()			);
			pstmt.setString(38, fee.getFee_pay_st()			);
			pstmt.setString(39, fee.getFee_pay_tm()			);			
			pstmt.setString(40, fee.getFee_pay_start_dt()	);			
			pstmt.setString(41, fee.getFee_pay_end_dt()		); 
			pstmt.setString(42, fee.getFee_fst_dt()			);
			pstmt.setInt   (43, fee.getFee_fst_amt()		);
			pstmt.setString(44, fee.getFee_cdt()			);
			pstmt.setString(45, fee.getExt_agnt()			);			
			pstmt.setString(46, fee.getBr_id()				);
			pstmt.setString(47, fee.getRc_day()				);
			pstmt.setString(48, fee.getNext_yn()			);
			pstmt.setString(49, fee.getOpt_chk()			);
			pstmt.setString(50, fee.getFee_sh()				);												
			pstmt.setString(51, fee.getPrv_mon_yn()			);
			pstmt.setString(52, fee.getFee_chk()			);
			pstmt.setString(53, fee.getOpt_per()			);
			pstmt.setString(54, fee.getRent_dt()			);
			pstmt.setString(55, fee.getGrt_suc_yn()			);
			pstmt.setString(56, fee.getIfee_suc_yn()		);
			pstmt.setString(57, fee.getRent_est_dt()		);
			pstmt.setString(58, fee.getLeave_day()			);
			pstmt.setString(59, fee.getCls_per()			);
			pstmt.setFloat (60, fee.getGur_per			());
			pstmt.setFloat (61, fee.getGur_p_per		());			
			pstmt.setFloat (62, fee.getPere_per			());
			pstmt.setFloat (63, fee.getPere_r_per		());
			pstmt.setInt   (64, fee.getPere_mth			());
			pstmt.setInt   (65, fee.getPere_r_mth		());
			pstmt.setFloat (66, fee.getMax_ja			());			
			pstmt.setFloat (67, fee.getApp_ja			());
			pstmt.setString(68, fee.getOpt_st			());
			pstmt.setFloat (69, fee.getDc_ra			());
			pstmt.setString(70, fee.getBas_dt			());			
			pstmt.setString(71, fee.getFee_sac_id		());			
			pstmt.setString(72, fee.getDef_st			()); 
			pstmt.setString(73, fee.getDef_remark		());
			pstmt.setString(74, fee.getDef_sac_id		());
			pstmt.setFloat (75, fee.getCls_r_per		());	
			pstmt.setInt   (76, fee.getJa_s_amt			());
			pstmt.setInt   (77, fee.getJa_v_amt			());
			pstmt.setFloat (78, fee.getCredit_per  		());			
			pstmt.setFloat (79, fee.getCredit_r_per		());			
			pstmt.setInt   (80, fee.getCredit_amt  		());
			pstmt.setInt   (81, fee.getCredit_r_amt		());
			pstmt.setInt   (82, fee.getJa_r_s_amt		());
			pstmt.setInt   (83, fee.getJa_r_v_amt		());
			pstmt.setString(84, fee.getRtn_st			());
			pstmt.setString(85, fee.getRent_mng_id		());
			pstmt.setString(86, fee.getRent_l_cd		());
			pstmt.setString(87, fee.getRent_st			());				
		    pstmt.executeUpdate();
			pstmt.close();
		    conn.commit();
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:updateContFee]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	public boolean insertContDebt(ContDebtBean debt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " insert into ALLOT (RENT_MNG_ID, RENT_L_CD, ALLOT_ST, CPT_CD, LEND_INT, LEND_PRN, "+
						" ALT_FEE, RTN_TOT_AMT, LOAN_DEBTOR, RTN_CDT, RTN_WAY, RTN_EST_DT, LEND_NO, NTRL_FEE,  "+
						" STP_FEE, LEND_DT, LEND_INT_AMT, ALT_AMT, TOT_ALT_TM, ALT_START_DT, " +
						" ALT_END_DT, BOND_GET_ST, BOND_ST, LOAN_CON_NM, LOAN_CON_SSN, LOAN_CON_REL,  "+
						" LOAN_CON_TEL, LOAN_CON_ADDR, GRTR_NM1, GRTR_SSN1, GRTR_REL1, GRTR_TEL1, GRTR_ADDR1,  "+
						" GRTR_NM2, GRTR_SSN2, GRTR_REL2, GRTR_TEL2, GRTR_ADDR2, GRTR_NM3, GRTR_SSN3, " +
						" GRTR_REL3, GRTR_TEL3, GRTR_ADDR3, FST_PAY_DT, FST_PAY_AMT ) values ("+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " +
						" ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''), " +
						" replace(?, '-', ''), ?, ?, ?, ?, ?, ?, ?, ?, ?, " +
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, " +
						" ?, ?, ?, replace(?, '-', ''), ? )";
		try 
		{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, debt.getRent_mng_id());
			pstmt.setString(2, debt.getRent_l_cd());	
			pstmt.setString(3, debt.getAllot_st());
			pstmt.setString(4, debt.getCpt_cd());
			pstmt.setString(5, debt.getLend_int());
			pstmt.setInt(6, debt.getLend_prn());
			pstmt.setInt(7, debt.getAlt_fee());
			pstmt.setInt(8, debt.getRtn_tot_amt());
			pstmt.setString(9, debt.getLoan_debtor());
			pstmt.setString(10, debt.getRtn_cdt());
			pstmt.setString(11, debt.getRtn_way());
			pstmt.setString(12, debt.getRtn_est_dt());
			pstmt.setString(13, debt.getLend_no());
			pstmt.setInt(14, debt.getNtrl_fee());
			pstmt.setInt(15, debt.getStp_fee());
			pstmt.setString(16, debt.getLend_dt());
			pstmt.setInt(17, debt.getLend_int_amt());
			pstmt.setInt(18, debt.getAlt_amt());
			pstmt.setString(19, debt.getTot_alt_tm());
			pstmt.setString(20, debt.getAlt_start_dt());
			pstmt.setString(21, debt.getAlt_end_dt());
			pstmt.setString(22, debt.getBond_get_st());
			pstmt.setString(23, debt.getBond_st());
			pstmt.setString(24, debt.getLoan_con_nm());
			pstmt.setString(25, debt.getLoan_con_ssn());
			pstmt.setString(26, debt.getLoan_con_rel());
			pstmt.setString(27, debt.getLoan_con_tel());
			pstmt.setString(28, debt.getLoan_con_addr());
			pstmt.setString(29, debt.getGrtr_nm1());
			pstmt.setString(30, debt.getGrtr_ssn1());
			pstmt.setString(31, debt.getGrtr_rel1());
			pstmt.setString(32, debt.getGrtr_tel1());
			pstmt.setString(33, debt.getGrtr_addr1());
			pstmt.setString(34, debt.getGrtr_nm2());
			pstmt.setString(35, debt.getGrtr_ssn2());
			pstmt.setString(36, debt.getGrtr_rel2());
			pstmt.setString(37, debt.getGrtr_tel2());
			pstmt.setString(38, debt.getGrtr_addr2());
			pstmt.setString(39, debt.getGrtr_nm3());
			pstmt.setString(40, debt.getGrtr_ssn3());
			pstmt.setString(41, debt.getGrtr_rel3());
			pstmt.setString(42, debt.getGrtr_tel3());
			pstmt.setString(43, debt.getGrtr_addr3());
			pstmt.setString(44, debt.getFst_pay_dt());
			pstmt.setInt(45, debt.getFst_pay_amt());
		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:insertContDebt]\n"+e);
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
	
	public boolean updateContDebt(ContDebtBean debt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update ALLOT set "+
						" ALLOT_ST = ?, "+
						" CPT_CD = ?, "+
						" LEND_INT = ?, "+
						" LEND_PRN = ?, "+
						" ALT_FEE = ?, "+
						" RTN_TOT_AMT  = ?, "+
						" LOAN_DEBTOR = ?, "+
						" RTN_CDT = ?, "+
						" RTN_WAY = ?, "+
						" RTN_EST_DT = replace(?, '-', ''), "+
						" LEND_NO = ?, "+
						" NTRL_FEE = ?, "+
						" STP_FEE = ?, "+
						" LEND_DT = replace(?, '-', ''), "+
						" LEND_INT_AMT = ?, "+
						" ALT_AMT = ?, "+
						" TOT_ALT_TM = ?, "+
						" ALT_START_DT = replace(?, '-', ''), "+
						" ALT_END_DT = replace(?, '-', ''), "+
						" BOND_GET_ST = ?, "+
						" BOND_ST = ?, "+
						" LOAN_CON_NM = ?, "+
						" LOAN_CON_SSN = ?, "+
						" LOAN_CON_REL = ?, "+
						" LOAN_CON_TEL = ?, "+
						" LOAN_CON_ADDR = ?, "+
						" GRTR_NM1 = ?, "+
						" GRTR_SSN1 = ?, "+
						" GRTR_REL1 = ?, "+
						" GRTR_TEL1 = ?, "+
						" GRTR_ADDR1 = ?, "+
						" GRTR_NM2 = ?, "+
						" GRTR_SSN2 = ?, "+
						" GRTR_REL2 = ?, "+
						" GRTR_TEL2 = ?, "+
						" GRTR_ADDR2 = ?, "+
						" GRTR_NM3 = ?, "+
						" GRTR_SSN3 = ?, "+
						" GRTR_REL3 = ?, "+
						" GRTR_TEL3 = ?, "+
						" GRTR_ADDR3 = ?, "+
						" FST_PAY_DT = replace(?, '-', ''), "+
						" FST_PAY_AMT = ? "+
						" where RENT_MNG_ID  = ? and  RENT_L_CD = ?";

		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, debt.getAllot_st());
			pstmt.setString(2, debt.getCpt_cd());
			pstmt.setString(3, debt.getLend_int());
			pstmt.setInt(4, debt.getLend_prn());
			pstmt.setInt(5, debt.getAlt_fee());
			pstmt.setInt(6, debt.getRtn_tot_amt());
			pstmt.setString(7, debt.getLoan_debtor());
			pstmt.setString(8, debt.getRtn_cdt());
			pstmt.setString(9, debt.getRtn_way());
			pstmt.setString(10, debt.getRtn_est_dt());
			pstmt.setString(11, debt.getLend_no());
			pstmt.setInt(12, debt.getNtrl_fee());
			pstmt.setInt(13, debt.getStp_fee());
			pstmt.setString(14, debt.getLend_dt());
			pstmt.setInt(15, debt.getLend_int_amt());
			pstmt.setInt(16, debt.getAlt_amt());
			pstmt.setString(17, debt.getTot_alt_tm());
			pstmt.setString(18, debt.getAlt_start_dt());
			pstmt.setString(19, debt.getAlt_end_dt());
			pstmt.setString(20, debt.getBond_get_st());
			pstmt.setString(21, debt.getBond_get_st());
			pstmt.setString(22, debt.getLoan_con_nm());
			pstmt.setString(23, debt.getLoan_con_ssn());
			pstmt.setString(24, debt.getLoan_con_rel());
			pstmt.setString(25, debt.getLoan_con_tel());
			pstmt.setString(26, debt.getLoan_con_addr());
			pstmt.setString(27, debt.getGrtr_nm1());
			pstmt.setString(28, debt.getGrtr_ssn1());
			pstmt.setString(29, debt.getGrtr_rel1());
			pstmt.setString(30, debt.getGrtr_tel1());
			pstmt.setString(31, debt.getGrtr_addr1());
			pstmt.setString(32, debt.getGrtr_nm2());
			pstmt.setString(33, debt.getGrtr_ssn2());
			pstmt.setString(34, debt.getGrtr_rel2());
			pstmt.setString(35, debt.getGrtr_tel2());
			pstmt.setString(36, debt.getGrtr_addr2());
			pstmt.setString(37, debt.getGrtr_nm3());
			pstmt.setString(38, debt.getGrtr_ssn3());
			pstmt.setString(39, debt.getGrtr_rel3());
			pstmt.setString(40, debt.getGrtr_tel3());
			pstmt.setString(41, debt.getGrtr_addr3());
			pstmt.setString(42, debt.getFst_pay_dt());
			pstmt.setInt(43, debt.getFst_pay_amt());
			pstmt.setString(44, debt.getRent_mng_id());
			pstmt.setString(45, debt.getRent_l_cd());	

		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:updateContDebt]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	public boolean insertCltr(CltrBean cltr)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		boolean flag = true;
		ResultSet rs = null;
		String cltr_id = "";
		String query_id = "select nvl(ltrim(to_char(max(cltr_id)+1, '00')), '01') ID from cltr "+
							" where rent_mng_id ='"+cltr.getRent_mng_id()+"'"+
							" and rent_l_cd='"+cltr.getRent_l_cd()+"'" ;
		String query_i = " insert into CLTR ( RENT_MNG_ID, RENT_L_CD, CLTR_ID, CLTR_AMT, CLTR_PER_LOAN, CLTR_EXP_DT, "+
						" CLTR_SET_DT, REG_TAX, CLTR_FEE, CLTR_PAY_DT ) values ("+
						" ?, ?, ?, ?, ?, replace(?, '-', ''), replace(?, '-', ''), ?, ?, replace(?, '-', ''))";						
		
		try{
			pstmt1 = conn.prepareStatement(query_id);
			rs = pstmt1.executeQuery();
			while(rs.next())
			{
				cltr_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			
			conn.setAutoCommit(false);
				
			pstmt2 = conn.prepareStatement(query_i);
			pstmt2.setString(1, cltr.getRent_mng_id());	
			pstmt2.setString(2, cltr.getRent_l_cd());
			pstmt2.setString(3, cltr_id);
			pstmt2.setInt(4, cltr.getCltr_amt());
			pstmt2.setString(5, cltr.getCltr_per_loan());
			pstmt2.setString(6, cltr.getCltr_exp_dt());
			pstmt2.setString(7, cltr.getCltr_set_dt());
			pstmt2.setInt(8, cltr.getReg_tax());
			pstmt2.setInt(9, cltr.getCltr_fee());
			pstmt2.setString(10, cltr.getCltr_pay_dt());
		    pstmt2.executeUpdate();		
			pstmt2.close();
		    conn.commit();			
		}catch(SQLException e){
			System.out.println("[ContDatabase:insertCltr]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public boolean updateCltr(CltrBean cltr)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update CLTR set "+
						" CLTR_AMT = ?, "+
						" CLTR_PER_LOAN = ?, "+
						" CLTR_EXP_DT = replace(?, '-', ''), "+
						" CLTR_SET_DT = replace(?, '-', ''), "+
						" REG_TAX = ?, "+
						" CLTR_FEE = ?, "+
						" CLTR_PAY_DT = replace(?, '-', '') "+
						" where RENT_MNG_ID = ? and  RENT_L_CD = ? and CLTR_ID = ?";
		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, cltr.getCltr_amt());
			pstmt.setString(2, cltr.getCltr_per_loan());
			pstmt.setString(3, cltr.getCltr_exp_dt());
			pstmt.setString(4, cltr.getCltr_set_dt());
			pstmt.setInt(5, cltr.getReg_tax());
			pstmt.setInt(6, cltr.getCltr_fee());
			pstmt.setString(7, cltr.getCltr_pay_dt());
			pstmt.setString(8, cltr.getRent_mng_id());	
			pstmt.setString(9, cltr.getRent_l_cd());
			pstmt.setString(10, cltr.getCltr_id());
			
		    pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
	  	} catch (Exception e) {
	  		System.out.println("[ContDatabase:updateCltr]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	/**
	 *	지급수수료관련 사원 정보 query
	 */	
	public Hashtable getCommiNInfo(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;
		Hashtable rtn = new Hashtable();
		String qry_bus = "select o.car_comp_id COMP_ID, e.car_off_id CAR_OFF_ID, e.EMP_ID EMP_ID, e.EMP_NM NM,"+
						 " o.CAR_OFF_TEL O_TEL, e.EMP_M_TEL TEL, o.CAR_OFF_FAX FAX, e.EMP_POS POS,"+
						 " e.EMP_EMAIL EMP_EMAIL, 'BUS' AGNT_ST, c.REL REL, d.nm COM_NM, o.car_off_nm CAR_OFF_NM"+
						 " from car_off_emp e, car_off o, commi c, code d"+
						 " where "+
						 "	e.car_off_id = o.car_off_id and"+
						 "	c.emp_id = e.emp_id and"+
						 "	c.rent_mng_id = ? and"+
						 "	c.rent_l_cd = ? and"+
						 "	c.agnt_st = '1' and"+
						 "  d.code = o.car_comp_id and"+
 						 "  c_st = '0001'";
		String qry_dlv = "select o.car_comp_id COMP_ID, e.car_off_id CAR_OFF_ID, e.EMP_ID EMP_ID, e.EMP_NM NM,"+
						 " o.CAR_OFF_TEL O_TEL, e.EMP_M_TEL TEL, o.CAR_OFF_FAX FAX, e.EMP_POS POS,"+
						 " e.EMP_EMAIL EMP_EMAIL, 'BUS' AGNT_ST, c.REL REL, d.nm COM_NM, o.car_off_nm CAR_OFF_NM"+
						 " from car_off_emp e, car_off o, commi c, code d"+
						 " where"+
						 " e.car_off_id = o.car_off_id and"+
						 " c.emp_id = e.emp_id and"+
						 " c.rent_mng_id = ? and"+
						 "	c.rent_l_cd = ? and"+
						 "	c.agnt_st = '2' and"+
						 "  d.code = o.car_comp_id and"+
 						 "  c_st = '0001'";
		try{	
			pstmt1 = conn.prepareStatement(qry_bus);
			pstmt1.setString(1, mng_id);
			pstmt1.setString(2, l_cd);
		    rs1 = pstmt1.executeQuery();
	    	ResultSetMetaData rsmd1 = rs1.getMetaData();
	    	Hashtable ht1 = new Hashtable();
    	
			while(rs1.next())
			{				
				for(int pos =1; pos <= rsmd1.getColumnCount();pos++)
				{
					 String columnName = rsmd1.getColumnName(pos);
					 ht1.put(columnName, (rs1.getString(columnName))==null?"":rs1.getString(columnName));
				}
			}
			rs1.close();
			pstmt1.close();

			rtn.put("BUS", ht1);
			
			pstmt2 = conn.prepareStatement(qry_dlv);
			pstmt2.setString(1, mng_id);
			pstmt2.setString(2, l_cd);
		    rs2 = pstmt2.executeQuery();
	    	ResultSetMetaData rsmd2 = rs2.getMetaData();
	    	Hashtable ht2 = new Hashtable();
    	
			while(rs2.next())
			{				
				for(int pos =1; pos <= rsmd2.getColumnCount();pos++)
				{
					 String columnName = rsmd2.getColumnName(pos);
					 ht2.put(columnName, (rs2.getString(columnName))==null?"":rs2.getString(columnName));
				}
			}
			rs2.close();
			pstmt2.close();

			rtn.put("DLV", ht2);

		}catch (SQLException e){
			System.out.println("[ContDatabase:getCommiNInfo]\n"+e);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs1 != null )		rs1.close();
                if(pstmt1 != null)		pstmt1.close();
                if(rs2 != null )		rs2.close();
                if(pstmt2 != null)		pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();			
			return rtn;
		}		
	}
	
	/**
	 *	지급수수료 bean query
	 */	
	public Vector getCommi(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = " select RENT_MNG_ID, EMP_ID, RENT_L_CD, AGNT_ST, COMMI, INC_AMT, RES_AMT, TOT_AMT, DIF_AMT, SUP_DT, REL"+
						" from commi"+
						 " where RENT_MNG_ID = ? and RENT_L_CD = ?";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mng_id);
			pstmt.setString(2, l_cd);
		   	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				CommiBean commi = new CommiBean();
				commi.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				commi.setEmp_id(rs.getString("EMP_ID")==null?"":rs.getString("EMP_ID"));
				commi.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				commi.setAgnt_st(rs.getString("AGNT_ST")==null?"":rs.getString("AGNT_ST"));
				commi.setCommi(rs.getInt("COMMI"));
				commi.setInc_amt(rs.getInt("INC_AMT"));
				commi.setRes_amt(rs.getInt("RES_AMT"));
				commi.setTot_amt(rs.getInt("TOT_AMT"));
				commi.setDif_amt(rs.getInt("DIF_AMT"));
				commi.setSup_dt(rs.getString("SUP_DT")==null?"":rs.getString("SUP_DT"));
				commi.setRel(rs.getString("REL")==null?"":rs.getString("REL"));
				rtn.add(commi);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ContDatabase:getCommi]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtn;
		}					
	}	

	public Hashtable getCarOffEmpInfo(String emp_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = " select O.CAR_OFF_NM CAR_OFF_NM, C.NM COM_NM, E.EMP_ID EMP_ID, E.EMP_NM NM, "+
						" E.EMP_M_TEL TEL, E.EMP_POS POS, E.EMP_EMAIL, O.CAR_OFF_TEL O_TEL, O.CAR_OFF_FAX FAX  "+
						" from CAR_OFF_EMP E, CAR_OFF O, CODE C "+
						" where O.CAR_OFF_ID = E.CAR_OFF_ID and "+
							" C.CODE = O.CAR_COMP_ID and "+
							" C.C_ST = '0001' and "+
							" EMP_ID = ?";
		try{	
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, emp_id);
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
		}catch (SQLException e){
			System.out.println("[ContDatabase:getCarOffEmpInfo]\n"+e);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();			
			return ht;
		}		
	}


	public Vector getCarMgr(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = " select RENT_MNG_ID, RENT_L_CD, MGR_ID, rtrim(MGR_ST) MGR_ST, MGR_NM, MGR_DEPT, MGR_TITLE, MGR_TEL, MGR_M_TEL, MGR_EMAIL, MGR_ZIP, MGR_ADDR"+
						 " from CAR_MGR"+
						 " where RENT_MNG_ID = ? and RENT_L_CD = ?"+
						 " order by MGR_ID";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mng_id);
			pstmt.setString(2, l_cd);
		    rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				CarMgrBean car_mgr = new CarMgrBean();
				car_mgr.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				car_mgr.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));	
				car_mgr.setMgr_id(rs.getString("MGR_ID")==null?"":rs.getString("MGR_ID"));
				car_mgr.setMgr_st(rs.getString("MGR_ST")==null?"":rs.getString("MGR_ST"));
				car_mgr.setMgr_nm(rs.getString("MGR_NM")==null?"":rs.getString("MGR_NM"));
				car_mgr.setMgr_dept(rs.getString("MGR_DEPT")==null?"":rs.getString("MGR_DEPT"));
				car_mgr.setMgr_title(rs.getString("MGR_TITLE")==null?"":rs.getString("MGR_TITLE"));
				car_mgr.setMgr_tel(rs.getString("MGR_TEL")==null?"":rs.getString("MGR_TEL"));
				car_mgr.setMgr_m_tel(rs.getString("MGR_M_TEL")==null?"":rs.getString("MGR_M_TEL"));
				car_mgr.setMgr_email(rs.getString("MGR_EMAIL")==null?"":rs.getString("MGR_EMAIL"));
				car_mgr.setMgr_zip(rs.getString("MGR_ZIP")==null?"":rs.getString("MGR_ZIP"));
				car_mgr.setMgr_addr(rs.getString("MGR_ADDR")==null?"":rs.getString("MGR_ADDR"));
				rtn.add(car_mgr);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ContDatabase:getCarMgr]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtn;
		}			
	}
	
	public ContCarBean getContCar(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ContCarBean car = new ContCarBean();
		String query = " select RENT_MNG_ID, RENT_L_CD, CAR_ID, COLO, EX_GAS, IMM_AMT, OPT, LPG_YN, LPG_SETTER, LPG_PRICE,"+
						" decode(LPG_PAY_DT, '', '', substr(LPG_PAY_DT, 1, 4) || '-' || substr(LPG_PAY_DT, 5, 2) || '-'||substr(LPG_PAY_DT, 7, 2)) LPG_PAY_DT,"+
						" CAR_CS_AMT, CAR_CV_AMT, CAR_FS_AMT, CAR_FV_AMT, OPT_CS_AMT, OPT_CV_AMT, OPT_FS_AMT,"+
						" OPT_FV_AMT, CLR_CS_AMT, CLR_CV_AMT, CLR_FS_AMT, CLR_FV_AMT, SD_CS_AMT, SD_CV_AMT, SD_FS_AMT,"+
						" SD_FV_AMT, DC_CS_AMT, DC_CV_AMT, DC_FS_AMT, DC_FV_AMT"+
						 " from CAR_ETC"+
						 " where RENT_MNG_ID = ? and RENT_L_CD = ?";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mng_id);
			pstmt.setString(2, l_cd);
		   	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				car.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				car.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				car.setCar_id(rs.getString("CAR_ID")==null?"":rs.getString("CAR_ID"));
				car.setColo(rs.getString("COLO")==null?"":rs.getString("COLO"));
				car.setEx_gas(rs.getString("EX_GAS")==null?"":rs.getString("EX_GAS"));
				car.setImm_amt(rs.getString("IMM_AMT")==null?0:Integer.parseInt(rs.getString("IMM_AMT")));
				car.setOpt(rs.getString("OPT")==null?"":rs.getString("OPT"));
				car.setLpg_yn(rs.getString("LPG_YN")==null?"":rs.getString("LPG_YN"));
				car.setLpg_setter(rs.getString("LPG_SETTER")==null?"":rs.getString("LPG_SETTER"));
				car.setLpg_price(rs.getString("LPG_PRICE")==null?0:Integer.parseInt(rs.getString("LPG_PRICE")));
				car.setLpg_pay_dt(rs.getString("LPG_PAY_DT")==null?"":rs.getString("LPG_PAY_DT"));
				car.setCar_cs_amt(rs.getString("CAR_CS_AMT")==null?0:Integer.parseInt(rs.getString("CAR_CS_AMT")));
				car.setCar_cv_amt(rs.getString("CAR_CV_AMT")==null?0:Integer.parseInt(rs.getString("CAR_CV_AMT")));
				car.setCar_fs_amt(rs.getString("CAR_FS_AMT")==null?0:Integer.parseInt(rs.getString("CAR_FS_AMT")));
				car.setCar_fv_amt(rs.getString("CAR_FV_AMT")==null?0:Integer.parseInt(rs.getString("CAR_FV_AMT")));
				car.setOpt_cs_amt(rs.getString("OPT_CS_AMT")==null?0:Integer.parseInt(rs.getString("OPT_CS_AMT")));
				car.setOpt_cv_amt(rs.getString("OPT_CV_AMT")==null?0:Integer.parseInt(rs.getString("OPT_CV_AMT")));
				car.setOpt_fs_amt(rs.getString("OPT_FS_AMT")==null?0:Integer.parseInt(rs.getString("OPT_FS_AMT")));
				car.setOpt_fv_amt(rs.getString("OPT_FV_AMT")==null?0:Integer.parseInt(rs.getString("OPT_FV_AMT")));
				car.setClr_cs_amt(rs.getString("CLR_CS_AMT")==null?0:Integer.parseInt(rs.getString("CLR_CS_AMT")));
				car.setClr_cv_amt(rs.getString("CLR_CV_AMT")==null?0:Integer.parseInt(rs.getString("CLR_CV_AMT")));
				car.setClr_fs_amt(rs.getString("CLR_FS_AMT")==null?0:Integer.parseInt(rs.getString("CLR_FS_AMT")));
				car.setClr_fv_amt(rs.getString("CLR_FV_AMT")==null?0:Integer.parseInt(rs.getString("CLR_FV_AMT")));
				car.setSd_cs_amt(rs.getString("SD_CS_AMT")==null?0:Integer.parseInt(rs.getString("SD_CS_AMT")));
				car.setSd_cv_amt(rs.getString("SD_CV_AMT")==null?0:Integer.parseInt(rs.getString("SD_CV_AMT")));
				car.setSd_fs_amt(rs.getString("SD_FS_AMT")==null?0:Integer.parseInt(rs.getString("SD_FS_AMT")));
				car.setSd_fv_amt(rs.getString("SD_FV_AMT")==null?0:Integer.parseInt(rs.getString("SD_FV_AMT")));
				car.setDc_cs_amt(rs.getString("DC_CS_AMT")==null?0:Integer.parseInt(rs.getString("DC_CS_AMT")));
				car.setDc_cv_amt(rs.getString("DC_CV_AMT")==null?0:Integer.parseInt(rs.getString("DC_CV_AMT")));
				car.setDc_fs_amt(rs.getString("DC_FS_AMT")==null?0:Integer.parseInt(rs.getString("DC_FS_AMT")));
				car.setDc_fv_amt(rs.getString("DC_FV_AMT")==null?0:Integer.parseInt(rs.getString("DC_FV_AMT")));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ContDatabase:getContCar]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return car;
		}				
	}
	
	public Vector getCltrs(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select RENT_MNG_ID, RENT_L_CD, CLTR_ID, CLTR_AMT, CLTR_PER_LOAN, "+
						" decode(CLTR_EXP_DT, '', '', substr(CLTR_EXP_DT, 1, 4) || '-' || substr(CLTR_EXP_DT, 5, 2) || '-'||substr(CLTR_EXP_DT, 7, 2)) CLTR_EXP_DT,"+
						" decode(CLTR_SET_DT, '', '', substr(CLTR_SET_DT, 1, 4) || '-' || substr(CLTR_SET_DT, 5, 2) || '-'||substr(CLTR_SET_DT, 7, 2)) CLTR_SET_DT,"+
						" decode(CLTR_PAY_DT, '', '', substr(CLTR_PAY_DT, 1, 4) || '-' || substr(CLTR_PAY_DT, 5, 2) || '-'||substr(CLTR_PAY_DT, 7, 2)) CLTR_PAY_DT,"+
						" REG_TAX, CLTR_FEE "+
						 " from CLTR "+
						 " where RENT_MNG_ID = ? and RENT_L_CD = ? ";
		try{
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, mng_id);
				pstmt.setString(2, l_cd);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				CltrBean cltr = new CltrBean();
				cltr.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				cltr.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				cltr.setCltr_id(rs.getString("CLTR_ID")==null?"":rs.getString("CLTR_ID"));
				cltr.setCltr_amt(rs.getString("CLTR_AMT")==null?0:Integer.parseInt(rs.getString("CLTR_AMT")));
				cltr.setCltr_per_loan(rs.getString("CLTR_PER_LOAN")==null?"":rs.getString("CLTR_PER_LOAN"));
				cltr.setCltr_exp_dt(rs.getString("CLTR_EXP_DT")==null?"":rs.getString("CLTR_EXP_DT"));
				cltr.setCltr_set_dt(rs.getString("CLTR_SET_DT")==null?"":rs.getString("CLTR_SET_DT"));
				cltr.setReg_tax(rs.getString("REG_TAX")==null?0:Integer.parseInt(rs.getString("REG_TAX")));
				cltr.setCltr_fee(rs.getString("CLTR_FEE")==null?0:Integer.parseInt(rs.getString("CLTR_FEE")));
				cltr.setCltr_pay_dt(rs.getString("CLTR_PAY_DT")==null?"":rs.getString("CLTR_PAY_DT"));
				vt.add(cltr);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ContDatabase:getCltrs]\n"+e);
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

	public ContPurBean getContPur(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ContPurBean pur = new ContPurBean();
		String query = "";
		query = " select"+
				" P.RENT_MNG_ID, P.RENT_L_CD, P.RPT_NO, P.DLV_BRCH,"+
				" decode(P.REG_EXT_DT, '', '', substr(P.REG_EXT_DT, 1, 4) || '-' || substr(P.REG_EXT_DT, 5, 2) || '-'||substr(P.REG_EXT_DT, 7, 2)) REG_EXT_DT,"+
				" decode(P.DLV_CON_DT, '', '', substr(P.DLV_CON_DT, 1, 4) || '-' || substr(P.DLV_CON_DT, 5, 2) || '-'||substr(P.DLV_CON_DT, 7, 2)) DLV_CON_DT,"+
				" decode(P.DLV_EST_DT, '', '', substr(P.DLV_EST_DT, 1, 4) || '-' || substr(P.DLV_EST_DT, 5, 2) || '-'||substr(P.DLV_EST_DT, 7, 2)) DLV_EST_DT, substr(P.dlv_est_dt,9,2) dlv_est_h,"+
				" P.TMP_DRV_NO, P.GDS_YN, P.PUR_ST, P.CON_AMT,"+
				" decode(P.CON_PAY_DT, '', '', substr(P.CON_PAY_DT, 1, 4) || '-' || substr(P.CON_PAY_DT, 5, 2) || '-'||substr(P.CON_PAY_DT, 7, 2)) CON_PAY_DT,"+
				" P.TRF_AMT1,"+
				" decode(P.TRF_PAY_DT1, '', '', substr(P.TRF_PAY_DT1, 1, 4) || '-' || substr(P.TRF_PAY_DT1, 5, 2) || '-'||substr(P.TRF_PAY_DT1, 7, 2)) TRF_PAY_DT1,"+
				" P.TRF_AMT2,"+
				" decode(P.TRF_PAY_DT2, '', '', substr(P.TRF_PAY_DT2, 1, 4) || '-' || substr(P.TRF_PAY_DT2, 5, 2) || '-'||substr(P.TRF_PAY_DT2, 7, 2)) TRF_PAY_DT2,"+
				" P.TRF_AMT3,"+
				" decode(P.TRF_PAY_DT3, '', '', substr(P.TRF_PAY_DT3, 1, 4) || '-' || substr(P.TRF_PAY_DT3, 5, 2) || '-'||substr(P.TRF_PAY_DT3, 7, 2)) TRF_PAY_DT3,"+
				" P.TRF_AMT4,"+
				" decode(P.TRF_PAY_DT4, '', '', substr(P.TRF_PAY_DT4, 1, 4) || '-' || substr(P.TRF_PAY_DT4, 5, 2) || '-'||substr(P.TRF_PAY_DT4, 7, 2)) TRF_PAY_DT4,"+
				" decode(P.TMP_DRV_ST, '', '', substr(P.TMP_DRV_ST, 1, 4) || '-' || substr(P.TMP_DRV_ST, 5, 2) || '-'||substr(P.TMP_DRV_ST, 7, 2)) TMP_DRV_ST,"+
				" decode(P.TMP_DRV_ET, '', '', substr(P.TMP_DRV_ET, 1, 4) || '-' || substr(P.TMP_DRV_ET, 5, 2) || '-'||substr(P.TMP_DRV_ET, 7, 2)) TMP_DRV_ET,"+
				" decode(P.PUR_PAY_DT, '', '', substr(P.PUR_PAY_DT, 1, 4) || '-' || substr(P.PUR_PAY_DT, 5, 2) || '-'||substr(P.PUR_PAY_DT, 7, 2)) PUR_PAY_DT,"+
				" decode(C.DLV_DT, '', '', substr(C.DLV_DT, 1, 4) || '-' || substr(C.DLV_DT, 5, 2) || '-'||substr(C.DLV_DT, 7, 2)) DLV_CON_DT,"+
				" P.dlv_ext, P.udt_st, P.udt_est_dt, P.udt_dt, P.cons_st, P.off_id, P.off_nm, P.cons_amt1, P.cons_amt2, P.jan_amt, P.con_est_dt, P.rent_ext,"+
				" P.trf_st1, P.trf_st2, P.trf_st3, P.trf_st4, P.card_kind1, P.card_kind2, P.card_kind3, P.card_kind4, P.cardno1, P.cardno2, P.cardno3, P.cardno4,"+
				" P.trf_cont1, P.trf_cont2, P.trf_cont3, P.trf_cont4, P.pur_est_dt, P.est_car_no, P.car_num, P.req_code, "+
				" P.autodocu_write_date, P.autodocu_data_no, P.dlv_ext_ven_code, P.car_off_ven_code, P.card_com_ven_code, P.one_self, P.con_amt_cont, "+
				" P.acc_st1, P.acc_st2, P.acc_st3, P.acc_st4, P.con_bank, P.con_acc_no, P.con_acc_nm, P.acq_cng_yn, P.cpt_cd, "+
				" P.com_tint, P.com_film_st, P.com_tint_coupon_no, P.com_tint_coupon_dt, P.com_tint_coupon_pay_dt, P.com_tint_coupon_reg_id, P.delay_cont, "+
				" P.dir_pur_yn, P.pur_req_dt, P.pur_bus_st, P.pur_req_yn, P.pur_com_firm "+
				" from CAR_PUR P, cont C"+
				" where P.rent_mng_id = C.rent_mng_id and"+
				" P.rent_l_cd = C.rent_l_cd and"+
				" P.RENT_MNG_ID = ? and P.RENT_L_CD = ? ";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, mng_id);
				pstmt.setString(2, l_cd);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				pur.setRent_mng_id			(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				pur.setRent_l_cd			(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				pur.setRpt_no				(rs.getString("RPT_NO")==null?"":rs.getString("RPT_NO"));
				pur.setDlv_brch				(rs.getString("DLV_BRCH")==null?"":rs.getString("DLV_BRCH"));
				pur.setReg_ext_dt			(rs.getString("REG_EXT_DT")==null?"":rs.getString("REG_EXT_DT"));
				pur.setDlv_con_dt			(rs.getString("DLV_CON_DT")==null?"":rs.getString("DLV_CON_DT"));
				pur.setDlv_est_dt			(rs.getString("DLV_EST_DT")==null?"":rs.getString("DLV_EST_DT"));
				pur.setDlv_est_h			(rs.getString("DLV_EST_H")==null?"":rs.getString("DLV_EST_H"));
				pur.setTmp_drv_no			(rs.getString("TMP_DRV_NO")==null?"":rs.getString("TMP_DRV_NO"));
				pur.setGds_yn				(rs.getString("GDS_YN")==null?"":rs.getString("GDS_YN"));
				pur.setPur_st				(rs.getString("PUR_ST")==null?"":rs.getString("PUR_ST"));
				pur.setCon_amt				(rs.getString("CON_AMT")==null?0:Integer.parseInt(rs.getString("CON_AMT")));
				pur.setCon_pay_dt			(rs.getString("CON_PAY_DT")==null?"":rs.getString("CON_PAY_DT"));
				pur.setTrf_amt1				(rs.getString("TRF_AMT1")==null?0:Integer.parseInt(rs.getString("TRF_AMT1")));
				pur.setTrf_pay_dt1			(rs.getString("TRF_PAY_DT1")==null?"":rs.getString("TRF_PAY_DT1"));
				pur.setTrf_amt2				(rs.getString("TRF_AMT2")==null?0:Integer.parseInt(rs.getString("TRF_AMT2")));
				pur.setTrf_pay_dt2			(rs.getString("TRF_PAY_DT2")==null?"":rs.getString("TRF_PAY_DT2"));
				pur.setTrf_amt3				(rs.getString("TRF_AMT3")==null?0:Integer.parseInt(rs.getString("TRF_AMT3")));
				pur.setTrf_pay_dt3			(rs.getString("TRF_PAY_DT3")==null?"":rs.getString("TRF_PAY_DT3"));
				pur.setTrf_amt4				(rs.getString("TRF_AMT4")==null?0:Integer.parseInt(rs.getString("TRF_AMT4")));
				pur.setTrf_pay_dt4			(rs.getString("TRF_PAY_DT4")==null?"":rs.getString("TRF_PAY_DT4"));
				pur.setTmp_drv_st			(rs.getString("TMP_DRV_ST")==null?"":rs.getString("TMP_DRV_ST"));
				pur.setTmp_drv_et			(rs.getString("TMP_DRV_ET")==null?"":rs.getString("TMP_DRV_ET"));
				pur.setPur_pay_dt			(rs.getString("PUR_PAY_DT")==null?"":rs.getString("PUR_PAY_DT"));		
				pur.setDlv_ext				(rs.getString("dlv_ext")	==null?"":rs.getString("dlv_ext"));
				pur.setUdt_st				(rs.getString("udt_st")		==null?"":rs.getString("udt_st"));
				pur.setUdt_est_dt			(rs.getString("udt_est_dt")	==null?"":rs.getString("udt_est_dt"));
				pur.setUdt_dt				(rs.getString("udt_dt")		==null?"":rs.getString("udt_dt"));
				pur.setCons_st				(rs.getString("cons_st")	==null?"":rs.getString("cons_st"));
				pur.setOff_id				(rs.getString("off_id")		==null?"":rs.getString("off_id"));
				pur.setOff_nm				(rs.getString("off_nm")		==null?"":rs.getString("off_nm"));
				pur.setCons_amt1			(rs.getString("cons_amt1")	==null?0:Integer.parseInt(rs.getString("cons_amt1")));
				pur.setCons_amt2			(rs.getString("cons_amt2")	==null?0:Integer.parseInt(rs.getString("cons_amt2")));
				pur.setJan_amt				(rs.getString("jan_amt")	==null?0:Integer.parseInt(rs.getString("jan_amt")));
				pur.setCon_est_dt			(rs.getString("con_est_dt")	==null?"":rs.getString("con_est_dt"));
				pur.setRent_ext				(rs.getString("rent_ext")	==null?"":rs.getString("rent_ext"));
				pur.setTrf_st1				(rs.getString("trf_st1")==null?"":rs.getString("trf_st1"));
				pur.setTrf_st2				(rs.getString("trf_st2")==null?"":rs.getString("trf_st2"));
				pur.setTrf_st3				(rs.getString("trf_st3")==null?"":rs.getString("trf_st3"));		
				pur.setTrf_st4				(rs.getString("trf_st4")==null?"":rs.getString("trf_st4"));
				pur.setCard_kind1			(rs.getString("card_kind1")==null?"":rs.getString("card_kind1"));
				pur.setCard_kind2			(rs.getString("card_kind2")==null?"":rs.getString("card_kind2"));		
				pur.setCard_kind3			(rs.getString("card_kind3")==null?"":rs.getString("card_kind3"));
				pur.setCard_kind4			(rs.getString("card_kind4")==null?"":rs.getString("card_kind4"));
				pur.setCardno1				(rs.getString("cardno1")==null?"":rs.getString("cardno1"));		
				pur.setCardno2				(rs.getString("cardno2")==null?"":rs.getString("cardno2"));
				pur.setCardno3				(rs.getString("cardno3")==null?"":rs.getString("cardno3"));
				pur.setCardno4				(rs.getString("cardno4")==null?"":rs.getString("cardno4"));		
				pur.setTrf_cont1			(rs.getString("trf_cont1")==null?"":rs.getString("trf_cont1"));
				pur.setTrf_cont2			(rs.getString("trf_cont2")==null?"":rs.getString("trf_cont2"));
				pur.setTrf_cont3			(rs.getString("trf_cont3")==null?"":rs.getString("trf_cont3"));		
				pur.setTrf_cont4			(rs.getString("trf_cont4")==null?"":rs.getString("trf_cont4"));
				pur.setPur_est_dt			(rs.getString("pur_est_dt")==null?"":rs.getString("pur_est_dt"));	
				pur.setEst_car_no			(rs.getString("est_car_no")==null?"":rs.getString("est_car_no"));	
				pur.setCar_num				(rs.getString("car_num")==null?"":rs.getString("car_num"));	
				pur.setReq_code				(rs.getString("req_code")==null?"":rs.getString("req_code"));	
				pur.setAutodocu_write_date	(rs.getString("autodocu_write_date")==null?"":rs.getString("autodocu_write_date"));	
				pur.setAutodocu_data_no		(rs.getString("autodocu_data_no")==null?"":rs.getString("autodocu_data_no"));	
				pur.setDlv_ext_ven_code		(rs.getString("dlv_ext_ven_code")==null?"":rs.getString("dlv_ext_ven_code"));	
				pur.setCar_off_ven_code		(rs.getString("car_off_ven_code")==null?"":rs.getString("car_off_ven_code"));	
				pur.setCard_com_ven_code	(rs.getString("card_com_ven_code")==null?"":rs.getString("card_com_ven_code"));	
				pur.setOne_self				(rs.getString("one_self")==null?"":rs.getString("one_self"));	
				pur.setCon_amt_cont			(rs.getString("con_amt_cont")==null?"":rs.getString("con_amt_cont"));	
				pur.setAcc_st1				(rs.getString("acc_st1")==null?"":rs.getString("acc_st1"));
				pur.setAcc_st2				(rs.getString("acc_st2")==null?"":rs.getString("acc_st2"));
				pur.setAcc_st3				(rs.getString("acc_st3")==null?"":rs.getString("acc_st3"));		
				pur.setAcc_st4				(rs.getString("acc_st4")==null?"":rs.getString("acc_st4"));
				pur.setCon_bank				(rs.getString("con_bank")==null?"":rs.getString("con_bank"));
				pur.setCon_acc_no			(rs.getString("con_acc_no")==null?"":rs.getString("con_acc_no"));
				pur.setCon_acc_nm			(rs.getString("con_acc_nm")==null?"":rs.getString("con_acc_nm"));
				pur.setAcq_cng_yn			(rs.getString("acq_cng_yn")==null?"":rs.getString("acq_cng_yn"));
				pur.setCpt_cd				(rs.getString("cpt_cd")==null?"":rs.getString("cpt_cd"));
				pur.setCom_tint				(rs.getString("com_tint")==null?"":rs.getString("com_tint"));
				pur.setCom_film_st			(rs.getString("com_film_st")==null?"":rs.getString("com_film_st"));
				pur.setCom_tint_coupon_no	(rs.getString("com_tint_coupon_no")==null?"":rs.getString("com_tint_coupon_no"));		
				pur.setCom_tint_coupon_dt	(rs.getString("com_tint_coupon_dt")==null?"":rs.getString("com_tint_coupon_dt"));
				pur.setCom_tint_coupon_pay_dt	(rs.getString("com_tint_coupon_pay_dt")==null?"":rs.getString("com_tint_coupon_pay_dt"));
				pur.setCom_tint_coupon_reg_id	(rs.getString("com_tint_coupon_reg_id")==null?"":rs.getString("com_tint_coupon_reg_id"));
				pur.setDelay_cont			(rs.getString("delay_cont")==null?"":rs.getString("delay_cont"));
				pur.setDir_pur_yn			(rs.getString("dir_pur_yn")==null?"":rs.getString("dir_pur_yn"));
				pur.setPur_req_dt			(rs.getString("pur_req_dt")==null?"":rs.getString("pur_req_dt"));
				pur.setPur_bus_st			(rs.getString("pur_bus_st")==null?"":rs.getString("pur_bus_st"));
				pur.setPur_req_yn			(rs.getString("pur_req_yn")==null?"":rs.getString("pur_req_yn"));
				pur.setPur_com_firm			(rs.getString("pur_com_firm")==null?"":rs.getString("pur_com_firm"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ContDatabase:getContPur]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return pur;
		}				
	}
	
	/**
	 *	대여료 Bean 세팅
	 *  gubun - 1: 신규대여료, 2: 연장대여료
	 */
	public ContFeeBean getContFee(String mng_id, String l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ContFeeBean fee = new ContFeeBean();
		String query = " select RENT_MNG_ID, RENT_L_CD, RENT_ST, RENT_WAY, CAR_ST, CON_MON,"+
						" PRV_DLV_YN, PRV_CAR_MNG_ID,"+
						" decode(RENT_START_DT, '', '', substr(RENT_START_DT, 1, 4) || '-' || substr(RENT_START_DT, 5, 2) || '-'||substr(RENT_START_DT, 7, 2)) RENT_START_DT, "+
						" decode(RENT_END_DT, '', '', substr(RENT_END_DT, 1, 4) || '-' || substr(RENT_END_DT, 5, 2) || '-'||substr(RENT_END_DT, 7, 2)) RENT_END_DT, "+
						" decode(PRV_START_DT, '', '', substr(PRV_START_DT, 1, 4) || '-' || substr(PRV_START_DT, 5, 2) || '-'||substr(PRV_START_DT, 7, 2)) PRV_START_DT, "+
						" decode(PRV_END_DT, '', '', substr(PRV_END_DT, 1, 4) || '-' || substr(PRV_END_DT, 5, 2) || '-'||substr(PRV_END_DT, 7, 2)) PRV_END_DT, "+
						" GRT_AMT_S, GRT_ETC, "+
						" decode(GRT_EST_DT, '', '', substr(GRT_EST_DT, 1, 4) || '-' || substr(GRT_EST_DT, 5, 2) || '-'||substr(GRT_EST_DT, 7, 2)) GRT_EST_DT, "+
						" GRT_PAY_YN, PP_S_AMT, PP_V_AMT, PP_ETC, "+
						" decode(PP_EST_DT, '', '', substr(PP_EST_DT, 1, 4) || '-' || substr(PP_EST_DT, 5, 2) || '-'||substr(PP_EST_DT, 7, 2)) PP_EST_DT, "+
						" PP_PAY_YN, IFEE_S_AMT, IFEE_V_AMT, IFEE_ETC, "+
						" decode(IFEE_EST_DT, '', '', substr(IFEE_EST_DT, 1, 4) || '-' || substr(IFEE_EST_DT, 5, 2) || '-'||substr(IFEE_EST_DT, 7, 2)) IFEE_EST_DT, "+
						" IFEE_PAY_YN, INV_S_AMT, INV_V_AMT, INV_ETC, OPT_S_AMT, OPT_V_AMT, OPT_YN, OPT_ETC, "+
						" FEE_S_AMT, FEE_V_AMT, FEE_ETC, FEE_ST, FEE_REQ_DAY, FEE_EST_DAY, FEE_BANK, FEE_PAY_ST, "+
						" rtrim(FEE_PAY_TM) FEE_PAY_TM, FEE_FST_AMT, FEE_CDT, EXT_AGNT, "+
						" decode(FEE_PAY_START_DT, '', '', substr(FEE_PAY_START_DT, 1, 4) || '-' || substr(FEE_PAY_START_DT, 5, 2) || '-'||substr(FEE_PAY_START_DT, 7, 2)) FEE_PAY_START_DT, "+
						" decode(FEE_PAY_END_DT, '', '', substr(FEE_PAY_END_DT, 1, 4) || '-' || substr(FEE_PAY_END_DT, 5, 2) || '-'||substr(FEE_PAY_END_DT, 7, 2)) FEE_PAY_END_DT, "+
						" decode(FEE_FST_DT, '', '', substr(FEE_FST_DT, 1, 4) || '-' || substr(FEE_FST_DT, 5, 2) || '-'||substr(FEE_FST_DT, 7, 2)) FEE_FST_DT, "+
						" BR_ID, rtrim(RC_DAY) rc_day, NEXT_YN"+
						" from FEE "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? and RENT_ST = ?";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, mng_id);
				pstmt.setString(2, l_cd);
				pstmt.setString(3, rent_st);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				fee.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				fee.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				fee.setRent_st(rs.getString("RENT_ST")==null?"":rs.getString("RENT_ST"));
				fee.setRent_way(rs.getString("RENT_WAY")==null?"":rs.getString("RENT_WAY"));
				fee.setCar_st(rs.getString("CAR_ST")==null?"":rs.getString("CAR_ST"));
				fee.setCon_mon(rs.getString("CON_MON")==null?"":rs.getString("CON_MON"));
				fee.setRent_start_dt(rs.getString("RENT_START_DT")==null?"":rs.getString("RENT_START_DT"));
				fee.setRent_end_dt(rs.getString("RENT_END_DT")==null?"":rs.getString("RENT_END_DT"));
				fee.setPrv_dlv_yn(rs.getString("PRV_DLV_YN")==null?"":rs.getString("PRV_DLV_YN"));
				fee.setPrv_car_mng_id(rs.getString("PRV_CAR_MNG_ID")==null?"":rs.getString("PRV_CAR_MNG_ID"));
				fee.setPrv_start_dt(rs.getString("PRV_START_DT")==null?"":rs.getString("PRV_START_DT"));
				fee.setPrv_end_dt(rs.getString("PRV_END_DT")==null?"":rs.getString("PRV_END_DT"));
				fee.setGrt_amt_s(rs.getString("GRT_AMT_S")==null?0:Integer.parseInt(rs.getString("GRT_AMT_S")));
				fee.setGrt_etc(rs.getString("GRT_ETC")==null?"":rs.getString("GRT_ETC"));
				fee.setGrt_est_dt(rs.getString("GRT_EST_DT")==null?"":rs.getString("GRT_EST_DT"));
				fee.setGrt_pay_yn(rs.getString("GRT_PAY_YN")==null?"":rs.getString("GRT_PAY_YN"));
				fee.setPp_s_amt(rs.getString("PP_S_AMT")==null?0:Integer.parseInt(rs.getString("PP_S_AMT")));
				fee.setPp_v_amt(rs.getString("PP_V_AMT")==null?0:Integer.parseInt(rs.getString("PP_V_AMT")));
				fee.setPp_etc(rs.getString("PP_ETC")==null?"":rs.getString("PP_ETC"));
				fee.setPp_est_dt(rs.getString("PP_EST_DT")==null?"":rs.getString("PP_EST_DT"));
				fee.setPp_pay_yn(rs.getString("PP_PAY_YN")==null?"":rs.getString("PP_PAY_YN"));
				fee.setIfee_s_amt(rs.getString("IFEE_S_AMT")==null?0:Integer.parseInt(rs.getString("IFEE_S_AMT")));
				fee.setIfee_v_amt(rs.getString("IFEE_V_AMT")==null?0:Integer.parseInt(rs.getString("IFEE_V_AMT")));
				fee.setIfee_etc(rs.getString("IFEE_ETC")==null?"":rs.getString("IFEE_ETC"));
				fee.setIfee_est_dt(rs.getString("IFEE_EST_DT")==null?"":rs.getString("IFEE_EST_DT"));
				fee.setIfee_pay_yn(rs.getString("IFEE_PAY_YN")==null?"":rs.getString("IFEE_PAY_YN"));
				fee.setInv_s_amt(rs.getString("INV_S_AMT")==null?0:Integer.parseInt(rs.getString("INV_S_AMT")));
				fee.setInv_v_amt(rs.getString("INV_V_AMT")==null?0:Integer.parseInt(rs.getString("INV_V_AMT")));
				fee.setInv_etc(rs.getString("INV_ETC")==null?"":rs.getString("INV_ETC"));
				fee.setOpt_s_amt(rs.getString("OPT_S_AMT")==null?0:Integer.parseInt(rs.getString("OPT_S_AMT")));
				fee.setOpt_v_amt(rs.getString("OPT_V_AMT")==null?0:Integer.parseInt(rs.getString("OPT_V_AMT")));
				fee.setOpt_etc(rs.getString("OPT_ETC")==null?"":rs.getString("OPT_ETC"));
				fee.setOpt_yn(rs.getString("OPT_YN")==null?"":rs.getString("OPT_YN"));
				fee.setFee_s_amt(rs.getString("FEE_S_AMT")==null?0:Integer.parseInt(rs.getString("FEE_S_AMT")));
				fee.setFee_v_amt(rs.getString("FEE_V_AMT")==null?0:Integer.parseInt(rs.getString("FEE_V_AMT")));
				fee.setFee_etc(rs.getString("FEE_ETC")==null?"":rs.getString("FEE_ETC"));
				fee.setFee_st(rs.getString("FEE_ST")==null?"":rs.getString("FEE_ST"));
				fee.setFee_req_day(rs.getString("FEE_REQ_DAY")==null?"":rs.getString("FEE_REQ_DAY"));
				fee.setFee_est_day(rs.getString("FEE_EST_DAY")==null?"":rs.getString("FEE_EST_DAY"));
				fee.setFee_bank(rs.getString("FEE_BANK")==null?"":rs.getString("FEE_BANK"));
				fee.setFee_pay_st(rs.getString("FEE_PAY_ST")==null?"":rs.getString("FEE_PAY_ST"));
				fee.setFee_pay_tm(rs.getString("FEE_PAY_TM")==null?"":rs.getString("FEE_PAY_TM"));
				fee.setFee_pay_start_dt(rs.getString("FEE_PAY_START_DT")==null?"":rs.getString("FEE_PAY_START_DT"));
				fee.setFee_pay_end_dt(rs.getString("FEE_PAY_END_DT")==null?"":rs.getString("FEE_PAY_END_DT"));
				fee.setFee_fst_dt(rs.getString("FEE_FST_DT")==null?"":rs.getString("FEE_FST_DT"));
				fee.setFee_fst_amt(rs.getString("FEE_FST_AMT")==null?0:Integer.parseInt(rs.getString("FEE_FST_AMT")));
				fee.setFee_cdt(rs.getString("FEE_CDT")==null?"":rs.getString("FEE_CDT"));
				fee.setExt_agnt(rs.getString("EXT_AGNT")==null?"":rs.getString("EXT_AGNT"));
				fee.setBr_id(rs.getString("BR_ID")==null?"":rs.getString("BR_ID"));
				fee.setRc_day(rs.getString("RC_DAY")==null?"":rs.getString("RC_DAY"));
				fee.setNext_yn(rs.getString("NEXT_YN")==null?"":rs.getString("NEXT_YN"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ContDatabase:getContFee]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return fee;
		}
	}
	
	public ContDebtBean getContDebt(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ContDebtBean debt = new ContDebtBean();
		String query = " select RENT_MNG_ID, RENT_L_CD, ALLOT_ST, CPT_CD, LEND_INT, LEND_PRN, "+
						" ALT_FEE, RTN_TOT_AMT, LOAN_DEBTOR, RTN_CDT, RTN_WAY,  "+
						" rtrim(RTN_EST_DT) RTN_EST_DT, "+
						" LEND_NO, NTRL_FEE, STP_FEE, "+
						" decode(LEND_DT, '', '', substr(LEND_DT, 1, 4) || '-' || substr(LEND_DT, 5, 2) || '-'||substr(LEND_DT, 7, 2)) LEND_DT, "+
						" LEND_INT_AMT, ALT_AMT, TOT_ALT_TM, " +
						" decode(ALT_START_DT, '', '', substr(ALT_START_DT, 1, 4) || '-' || substr(ALT_START_DT, 5, 2) || '-'||substr(ALT_START_DT, 7, 2)) ALT_START_DT, "+
						" decode(ALT_END_DT, '', '', substr(ALT_END_DT, 1, 4) || '-' || substr(ALT_END_DT, 5, 2) || '-'||substr(ALT_END_DT, 7, 2)) ALT_END_DT, "+
						" BOND_GET_ST, BOND_ST, LOAN_CON_NM, LOAN_CON_SSN, LOAN_CON_REL, "+
						" LOAN_CON_TEL, LOAN_CON_ADDR, GRTR_NM1, GRTR_SSN1, GRTR_REL1, GRTR_TEL1, GRTR_ADDR1, "+
						" GRTR_NM2, GRTR_SSN2, GRTR_REL2, GRTR_TEL2, GRTR_ADDR2, GRTR_NM3, GRTR_SSN3, " +
						" GRTR_REL3, GRTR_TEL3, GRTR_ADDR3, "+
						" decode(FST_PAY_DT, '', '', substr(FST_PAY_DT, 1, 4) || '-' || substr(FST_PAY_DT, 5, 2) || '-'||substr(FST_PAY_DT, 7, 2)) FST_PAY_DT, "+
						" FST_PAY_AMT "+
						" from ALLOT "+
						 " where RENT_MNG_ID = ? and RENT_L_CD = ? ";
		try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, m_id);
				pstmt.setString(2, l_cd);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				debt.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				debt.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				debt.setAllot_st(rs.getString("ALLOT_ST")==null?"":rs.getString("ALLOT_ST"));	
				debt.setCpt_cd(rs.getString("CPT_CD")==null?"":rs.getString("CPT_CD"));	
				debt.setLend_int(rs.getString("LEND_INT")==null?"":rs.getString("LEND_INT"));	
				debt.setLend_prn(rs.getString("LEND_PRN")==null?0:Integer.parseInt(rs.getString("LEND_PRN")));			
				debt.setAlt_fee(rs.getString("ALT_FEE")==null?0:Integer.parseInt(rs.getString("ALT_FEE")));			
				debt.setRtn_tot_amt(rs.getString("RTN_TOT_AMT")==null?0:Integer.parseInt(rs.getString("RTN_TOT_AMT")));		
				debt.setLoan_debtor(rs.getString("LOAN_DEBTOR")==null?"":rs.getString("LOAN_DEBTOR"));
				debt.setRtn_cdt(rs.getString("RTN_CDT")==null?"":rs.getString("RTN_CDT"));	
				debt.setRtn_way(rs.getString("RTN_WAY")==null?"":rs.getString("RTN_WAY"));	
				debt.setRtn_est_dt(rs.getString("RTN_EST_DT")==null?"":rs.getString("RTN_EST_DT"));
				debt.setLend_no(rs.getString("LEND_NO")==null?"":rs.getString("LEND_NO"));			
				debt.setNtrl_fee(rs.getString("NTRL_FEE")==null?0:Integer.parseInt(rs.getString("NTRL_FEE")));			
				debt.setStp_fee(rs.getString("STP_FEE")==null?0:Integer.parseInt(rs.getString("STP_FEE")));			
				debt.setLend_dt(rs.getString("LEND_DT")==null?"":rs.getString("LEND_DT"));	
				debt.setLend_int_amt(rs.getString("LEND_INT_AMT")==null?0:Integer.parseInt(rs.getString("LEND_INT_AMT")));		
				debt.setAlt_amt(rs.getString("ALT_AMT")==null?0:Integer.parseInt(rs.getString("ALT_AMT")));			
				debt.setTot_alt_tm(rs.getString("TOT_ALT_TM")==null?"":rs.getString("TOT_ALT_TM"));
				debt.setAlt_start_dt(rs.getString("ALT_START_DT")==null?"":rs.getString("ALT_START_DT"));
				debt.setAlt_end_dt(rs.getString("ALT_END_DT")==null?"":rs.getString("ALT_END_DT"));
				debt.setBond_get_st(rs.getString("BOND_GET_ST")==null?"":rs.getString("BOND_GET_ST"));
				debt.setBond_st(rs.getString("BOND_ST")==null?"":rs.getString("BOND_ST"));	
				debt.setLoan_con_nm(rs.getString("LOAN_CON_NM")==null?"":rs.getString("LOAN_CON_NM"));
				debt.setLoan_con_ssn(rs.getString("LOAN_CON_SSN")==null?"":rs.getString("LOAN_CON_SSN"));
				debt.setLoan_con_rel(rs.getString("LOAN_CON_REL")==null?"":rs.getString("LOAN_CON_REL"));
				debt.setLoan_con_tel(rs.getString("LOAN_CON_TEL")==null?"":rs.getString("LOAN_CON_TEL"));
				debt.setLoan_con_addr(rs.getString("LOAN_CON_ADDR")==null?"":rs.getString("LOAN_CON_ADDR"));
				debt.setGrtr_nm1(rs.getString("GRTR_NM1")==null?"":rs.getString("GRTR_NM1"));	
				debt.setGrtr_ssn1(rs.getString("GRTR_SSN1")==null?"":rs.getString("GRTR_SSN1"));	
				debt.setGrtr_rel1(rs.getString("GRTR_REL1")==null?"":rs.getString("GRTR_REL1"));	
				debt.setGrtr_tel1(rs.getString("GRTR_TEL1")==null?"":rs.getString("GRTR_TEL1"));	
				debt.setGrtr_addr1(rs.getString("GRTR_ADDR1")==null?"":rs.getString("GRTR_ADDR1"));	
				debt.setGrtr_nm2(rs.getString("GRTR_NM2")==null?"":rs.getString("GRTR_NM2"));		
				debt.setGrtr_ssn2(rs.getString("GRTR_SSN2")==null?"":rs.getString("GRTR_SSN2"));	
				debt.setGrtr_rel2(rs.getString("GRTR_REL2")==null?"":rs.getString("GRTR_REL2"));	
				debt.setGrtr_tel2(rs.getString("GRTR_TEL2")==null?"":rs.getString("GRTR_TEL2"));	
				debt.setGrtr_addr2(rs.getString("GRTR_ADDR2")==null?"":rs.getString("GRTR_ADDR2"));	
				debt.setGrtr_nm3(rs.getString("GRTR_NM3")==null?"":rs.getString("GRTR_NM3"));		
				debt.setGrtr_ssn3(rs.getString("GRTR_SSN3")==null?"":rs.getString("GRTR_SSN3"));	
				debt.setGrtr_rel3(rs.getString("GRTR_REL3")==null?"":rs.getString("GRTR_REL3"));	
				debt.setGrtr_tel3(rs.getString("GRTR_TEL3")==null?"":rs.getString("GRTR_TEL3"));	
				debt.setGrtr_addr3(rs.getString("GRTR_ADDR3")==null?"":rs.getString("GRTR_ADDR3"));	
				debt.setFst_pay_dt(rs.getString("FST_PAY_DT")==null?"":rs.getString("FST_PAY_DT"));	
				debt.setFst_pay_amt(rs.getString("FST_PAY_AMT")==null?0:Integer.parseInt(rs.getString("FST_PAY_AMT")));		
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ContDatabase:getContDebt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return debt;
		}
	}	
	
	public String getCarCom(String car_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = "select CAR_COMP_ID from CAR_NM where CAR_ID=?";
		
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_id);
		   	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[ContDatabase:getCarCom]\n"+e);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtnStr;
		}							
	}
	
	public String getCarPrice(String m_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = "select "+
						" to_number(CAR_FS_AMT)+ to_number(CAR_FV_AMT)+ to_number(OPT_FS_AMT)+ to_number(OPT_FV_AMT)+ "+
						" to_number(CLR_FS_AMT)+ to_number(CLR_FV_AMT)+ to_number(SD_FS_AMT)+ to_number(SD_FV_AMT)+"+
						" to_number(DC_FS_AMT)+ to_number(DC_FV_AMT) tot_fv_amt "+
						" from car_etc "+
						" where "+
							" RENT_MNG_ID = ? and "+
							" RENT_L_CD = ?";
		
		try
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
		   	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[ContDatabase:getCarPrice]\n"+e);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtnStr;
		}	
	}
	
	public Vector getSpareCarList(String car_no, String car_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query =" select R.car_mng_id ID, R.car_no CAR_NO, R.car_nm CAR_ST, E.colo COL, E.opt OPT,"+
								" decode(R.init_reg_dt, '', '', substr(R.init_reg_dt, 1, 4) || '-' || substr(R.init_reg_dt, 5, 2) || '-'||substr(R.init_reg_dt, 7, 2)) REG_DT"+
						" from"+
						" (select car_mng_id, max(rent_mng_id) rent_mng_id"+
							 	  	" from cont"+
									" where car_mng_id is not null group by car_mng_id)A, cont C, car_reg R, car_etc E"+
						" where A.rent_mng_id = C.rent_mng_id and"+
							  " A.car_mng_id = C.car_mng_id and"+
							  " C.rent_mng_id = E.rent_mng_id and  C.rent_l_cd = E.rent_l_cd and"+
							  " C.car_mng_id = R.car_mng_id and"+
							  " C.car_st = '2' and  R.car_no like '%"+ car_no +"%' and"+
							  " R.car_nm like upper('%"+ car_st +"%')";				 
		
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
			System.out.println("[ContDatabase:getSpareCarList]\n"+e);
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
	 *	기존차량리스트
	 *	s_kd - 1:차량번호 , 2:차명
	 */
	public Vector getExistingCarList(String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select X.car_no CAR_NO, X.car_mng_id CAR_MNG_ID, X.rent_mng_id RENT_MNG_ID, X.rent_l_cd RENT_L_CD,"+
				" X.car_nm||N.car_name CAR_NM, N.car_comp_id CAR_COMP_ID, X.off_ls"+
				" from "+
				"	(select C.rent_mng_id rent_mng_id, max(C.rent_l_cd) rent_l_cd, max(C.car_mng_id) car_mng_id,"+
				"	max(R.car_no) car_no, max(R.car_nm) car_nm, max(R.off_ls) off_ls"+
				"	from"+
				"		(select car_mng_id, max(rent_mng_id) rent_mng_id from cont where car_mng_id is not null group by car_mng_id) A,"+
				"		cont C, car_reg R"+
				"	where A.rent_mng_id = C.rent_mng_id and A.car_mng_id = C.car_mng_id and A.car_mng_id = R.car_mng_id"+
				"	and nvl(C.use_yn,'Y')='Y' and C.car_st='2' and R.off_ls not in ('5','6')";

		if(s_kd.equals("1"))	query += " and R.car_no like '%"+t_wd+"%'";		

		query+= "   group by C.rent_mng_id) X,"+
				"	car_etc E, car_nm N"+
				" where	X.rent_mng_id = E.rent_mng_id and X.rent_l_cd = E.rent_l_cd and E.car_id = N.car_id(+)";

//		if(s_kd.equals("1"))		query += " and X.car_no like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and upper(X.car_nm) like upper('%"+t_wd+"%')";

		query += " order by X.car_no";


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
			System.out.println("[ContDatabase:getExistingCarList]\n"+e);
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
	 *	기존차량리스트
	 *	s_kd - 1:차량번호 , 2:차명, 3:자종코드
	 */
	public Vector getExistingCarList(String s_kd, String t_wd, String car_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select X.car_no CAR_NO, X.car_mng_id CAR_MNG_ID, X.rent_mng_id RENT_MNG_ID, X.rent_l_cd RENT_L_CD,"+
				" X.car_nm, N.car_name, N.car_comp_id CAR_COMP_ID, X.off_ls"+
				" from "+
				"	(select C.rent_mng_id rent_mng_id, max(C.rent_l_cd) rent_l_cd, max(C.car_mng_id) car_mng_id,"+
				"	max(R.car_no) car_no, max(R.car_nm) car_nm, max(R.off_ls) off_ls"+
				"	from"+
				"		(select car_mng_id, max(rent_mng_id) rent_mng_id from cont where car_mng_id is not null and nvl(use_yn,'Y')='Y' and car_st='2' group by car_mng_id) A,"+
				"		cont C, car_reg R"+
				"	where A.rent_mng_id = C.rent_mng_id and A.car_mng_id = C.car_mng_id and A.car_mng_id = R.car_mng_id"+
				"	and nvl(C.use_yn,'Y')='Y' and C.car_st='2' and R.off_ls not in ('5','6') group by C.rent_mng_id) X,"+
				"	car_etc E, car_nm N"+
				" where	X.rent_mng_id = E.rent_mng_id and X.rent_l_cd = E.rent_l_cd and E.car_id = N.car_id(+)";
		if(!car_cd.equals("")) query += " and N.car_cd='"+car_cd+"'";

		if(s_kd.equals("1"))		query += " and X.car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and upper(X.car_nm) like upper('%"+t_wd+"%')";


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
			System.out.println("[ContDatabase:getExistingCarList]\n"+e);
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
	 *	대여료 스케줄 생성 여부
	 *  gubun -  1: 신규대여료, 2: 연장대여료
	 */
	public String getFeeScdYn(String m_id, String l_cd, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = " select count(*) "+
						" from SCD_FEE "+
						" where rent_mng_id = ? and rent_l_cd = ? and rent_st = ?";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, gubun);
		   	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[ContDatabase:getFeeScdYn]\n"+e);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtnStr;
		}							
	}

	public String getCarMngId(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rtnStr = "";
		String query = " select car_mng_id from cont where rent_mng_id=? and rent_l_cd=?";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
		   	rs = pstmt.executeQuery();
			while(rs.next())
			{
				rtnStr = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[ContDatabase:getCarMngId]\n"+e);
	  		e.printStackTrace();
		}finally{
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtnStr;
		}			
	}
	
	public Vector getContList(String s_kd, String t_wd, String s_brch)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		
       	String query = " select "+
					 	" a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, "+
						" decode(a.rent_dt, '', '', substr(a.rent_dt, 1, 4) || '-' || substr(a.rent_dt, 5, 2) || '-'||substr(a.rent_dt, 7, 2)) RENT_DT, "+
						" decode(b.init_reg_dt,null,'미등록', substr(b.init_reg_dt, 1, 4) || '-' || substr(b.init_reg_dt, 5, 2) || '-'||substr(b.init_reg_dt, 7, 2)) as INIT_REG_DT,  "+
						" b.car_no as CAR_NO, b.car_num as CAR_NUM, "+
						" c.client_nm as CLIENT_NM, nvl(c.firm_nm, c.client_nm) as FIRM_NM, "+
						" decode(d.rent_way,'','미지정','1','일반식','2','맞춤식') as RENT_WAY, " + 
						" d.con_mon as CON_MON,  "+
						" decode(d.rent_start_dt, '', '', substr(d.rent_start_dt, 1, 4) || '-' || substr(d.rent_start_dt, 5, 2) || '-'||substr(d.rent_start_dt, 7, 2)) RENT_START_DT, "+						
						" decode(d.rent_end_dt, '', '', substr(d.rent_end_dt, 1, 4) || '-' || substr(d.rent_end_dt, 5, 2) || '-'||substr(d.rent_end_dt, 7, 2)) RENT_END_DT, "+
						" f.rpt_no as RPT_NO, i.cpt_cd as CPT_CD "+
					" from cont a, car_reg b, client c, fee d, car_pur f, allot i"+
					" where "+
						 " a.car_mng_id = b.car_mng_id(+) "+
						 " and a.client_id = c.client_id  "+
						 " and a.rent_mng_id = d.rent_mng_id(+) "+
						 " and a.rent_l_cd = d.rent_l_cd(+) "+
						 " and a.use_yn = 'Y'"+
						 " and d.rent_st <> '2' "+
						 " and a.rent_mng_id = f.rent_mng_id(+) "+
						 " and a.rent_l_cd = f.rent_l_cd(+) "+
						 " and a.rent_mng_id = i.rent_mng_id(+) "+
						 " and a.rent_l_cd = i.rent_l_cd(+)  "+
						 " and a.brch_id like '%"+ s_brch +"%'";

		if(s_kd.equals("1"))			query += " and upper(nvl(a.rent_l_cd, ' ')) like upper('%"+ t_wd +"%')";
		else if(s_kd.equals("2"))		query += " and nvl(a.rent_dt, ' ') like '%"+ t_wd +"%' ";
		else if(s_kd.equals("3"))		query += " and nvl(c.firm_nm, ' ') like '%"+ t_wd +"%' ";
		else if(s_kd.equals("4"))		query += " and nvl(c.client_nm, ' ') like '%"+ t_wd +"%' ";
		else if(s_kd.equals("5"))		query += " and nvl(b.car_no, ' ') like '%"+ t_wd +"%' ";
		else if(s_kd.equals("6"))		query += " and nvl(b.init_reg_dt, ' ') like '%"+ t_wd +"%' ";
		else if(s_kd.equals("7"))		query += " and nvl(b.car_num, ' ') like '%"+ t_wd +"%' ";
		else if(s_kd.equals("8"))		query += " and nvl(d.con_mon, ' ') like '%"+ t_wd +"%' ";
		else if(s_kd.equals("9"))		query += " and nvl(d.rent_start_dt, ' ') like '%"+ t_wd +"%' ";
		else if(s_kd.equals("10"))		query += " and nvl(i.cpt_cd, ' ') like '%"+ t_wd +"%' ";
		else if(s_kd.equals("11"))		query += " and nvl(d.rent_end_dt, ' ') like '%"+ t_wd +"%' ";
		
		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();

            while(rs.next())
            {
				RentListBean bean = new RentListBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setRent_dt(rs.getString("RENT_DT"));				//계약일자
			    bean.setClient_nm(rs.getString("CLIENT_NM"));			//고객 대표자명
			    bean.setFirm_nm(rs.getString("FIRM_NM"));				//상호
			    bean.setInit_reg_dt(rs.getString("INIT_REG_DT"));		//최초등록일
			    bean.setCar_no(rs.getString("CAR_NO"));					//차량번호
			    bean.setCar_num(rs.getString("CAR_NUM"));				//차대번호
			    bean.setRent_way(rs.getString("RENT_WAY"));				//대여방식
			    bean.setCon_mon(rs.getString("CON_MON"));				//대여개월
			    bean.setRent_start_dt(rs.getString("RENT_START_DT"));	//대여개시일
			    bean.setRent_end_dt(rs.getString("RENT_END_DT"));		//대여종료일
			    bean.setRpt_no(rs.getString("RPT_NO"));					//계출번호
			    bean.setCpt_cd(rs.getString("CPT_CD"));					//은행코드
			    
			    rtn.add(bean);
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ContDatabase:getContList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtn;
		}
    }

    /**
     * 계약출고현황
     * 1: 상호, 2: 차종, 3:출고일, 4:영업담당자, 5:출고지점
     */
    public Vector getDlvStats(String s_kd, String t_wd, String dt, String t_st_dt, String t_end_dt)
    {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select A.rent_l_cd, decode(A.rent_dt, '', '', substr(A.rent_dt, 1, 4)||'-'||substr(A.rent_dt, 5, 2)||'-'||substr(A.rent_dt, 7, 2)) rent_dt, nvl(A.firm_nm, A.client_nm) firm_nm, A.car_no car_no, A.car_nm car_nm, A.car_name car_name,"+
								" decode(A.dlv_dt, '', '', substr(A.dlv_dt, 1, 4)||'-'||substr(A.dlv_dt, 5, 2)||'-'||substr(A.dlv_dt, 7, 2)) dlv_dt,"+
								" decode(A.init_reg_dt, '', '미등록', substr(A.init_reg_dt, 1, 4)||'-'||substr(A.init_reg_dt, 5, 2)||'-'||substr(A.init_reg_dt, 7, 2)) init_reg_dt,"+
								" A.gds_yn gds_yn, a.lpg_yn lpg_yn, B.car_off_nm bus_off, C.car_off_nm dlv_off, B.emp_nm emp_nm"+
						" from"+
						" ("+
							" select C.rent_mng_id, C.rent_l_cd, C.rent_dt, nvl(L.firm_nm, L.client_nm) firm_nm, L.client_nm, R.car_no, R.car_nm, R.init_reg_dt, "+
									" C.dlv_dt, P.gds_yn, E.lpg_yn, M.car_nm||' '||N.car_name car_name"+
							" from cont C, client L, car_reg R, car_pur P, car_etc E, car_nm N, car_mng M "+
							" where C.client_id = L.client_id and"+
									" C.car_mng_id = R.car_mng_id(+) and"+
								  	" C.rent_mng_id = P.rent_mng_id and"+
								  	" C.rent_l_cd = P.rent_l_cd and"+
								  	" C.rent_mng_id = E.rent_mng_id and"+
								  	" C.rent_l_cd = E.rent_l_cd and"+
								  	" E.car_id = N.car_id and E.car_seq = N.car_seq and N.car_comp_id = M.car_comp_id and N.car_cd = M.code "+
								  	" and C.dlv_dt is not null"+	  
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
									" M.agnt_st = '2' and"+
									" E.car_off_id = O.car_off_id"+
						" )C"+
						" where A.rent_mng_id = B.rent_mng_id(+) and"+
								" A.rent_l_cd = B.rent_l_cd(+) and"+
							 	" A.rent_mng_id = C.rent_mng_id(+) and"+
								" A.rent_l_cd = C.rent_l_cd(+)";
		
		if(!t_wd.equals("")) {
			if(s_kd.equals("1"))		query += " and A.firm_nm like '%"+t_wd+"%'";
			else if(s_kd.equals("2"))	query += " and A.car_nm like '%"+t_wd+"%'";
			else if(s_kd.equals("3"))	query += " and A.dlv_dt like '"+t_wd+"%'";
			else if(s_kd.equals("4"))	query += " and B.emp_nm like '%"+t_wd+"%'";
			else if(s_kd.equals("5"))	query += " and C.car_off_nm like '%"+t_wd+"%'";
		}
		
		
		if(dt.equals("0"))  	 query +=" and a.dlv_dt like to_char(sysdate,'YYYYMM')||'%' and A.dlv_dt <= to_char(sysdate,'yyyymmdd') ";
		else if(dt.equals("1"))  query +=" and A.dlv_dt = to_char(sysdate,'YYYYMMDD') ";
		else if(dt.equals("2"))  query +=" and a.dlv_dt like to_char(sysdate,'YYYYMM')||'%' and A.dlv_dt <= to_char(sysdate,'yyyymmdd')  ";
		else if(dt.equals("3"))  query +=" and A.dlv_dt between replace(" + t_st_dt + ",'-','') and replace(" + t_end_dt + ",'-','') ";
		
		
		query += " order by A.dlv_dt, A.init_reg_dt ";
		
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
			System.out.println("[ContDatabase:getDlvStats]\n"+e);
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
}
