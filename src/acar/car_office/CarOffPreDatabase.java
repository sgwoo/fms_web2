package acar.car_office;

import java.sql.*;
import java.util.*;
import acar.database.*;


public class CarOffPreDatabase
{
	private Connection conn = null;
	public static CarOffPreDatabase db;
	
	public static CarOffPreDatabase getInstance()
	{
		if(CarOffPreDatabase.db == null)
			CarOffPreDatabase.db = new CarOffPreDatabase();
		return CarOffPreDatabase.db;
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
	    	System.out.println("I can't get a connection........");
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



	public CarOffPreBean getCarOffPreComConNo(String com_con_no)
	{
		getConnection();

		CarOffPreBean bean = new CarOffPreBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, "+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, "+
				"        b.r_seq, b.reg_id, b.reg_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt, a.req_dt, "+
				"		 a.pre_out_yn, a.eco_yn, a.garnish_col, a.agent_view_yn, a.bus_self_yn, a.q_reg_dt "+
				" FROM   car_pur_com_pre a, "+
				"        (select a.* from car_pur_com_pre_res a, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null  group by seq) b where a.cls_dt IS NULL AND a.seq=b.seq and a.r_seq=b.r_seq) b "+
				" WHERE  a.com_con_no=? and a.use_yn='Y' and a.seq=b.seq(+) ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, com_con_no);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setSeq				(rs.getInt(1));
				bean.setCar_off_nm		(rs.getString(2));
				bean.setCom_con_no		(rs.getString(3));
				bean.setCar_nm			(rs.getString(4));
				bean.setOpt				(rs.getString(5));
				bean.setColo			(rs.getString(6));
				bean.setCar_amt			(rs.getInt(7));	
				bean.setCon_amt			(rs.getInt(8));	
				bean.setCon_pay_dt		(rs.getString(9));
				bean.setDlv_est_dt		(rs.getString(10));
				bean.setEtc				(rs.getString(11));
				bean.setUse_yn			(rs.getString(12));
				bean.setCls_dt			(rs.getString(13));
				bean.setRent_l_cd		(rs.getString(14));
				bean.setR_seq			(rs.getInt(15));				
				bean.setReg_id			(rs.getString(16));
				bean.setReg_dt			(rs.getString(17));
				bean.setBus_nm			(rs.getString(18));
				bean.setFirm_nm			(rs.getString(19));
				bean.setAddr			(rs.getString(20));
				bean.setRes_cls_dt		(rs.getString(21));
				bean.setReq_dt			(rs.getString(22));	//요청일자 추가(20181108)
				bean.setPre_out_yn		(rs.getString(23));	//즉시출고 추가(20190305)
				bean.setEco_yn			(rs.getString(24));	//친환경차여부(20191114)
				bean.setGarnish_col		(rs.getString(25));
				bean.setAgent_view_yn	(rs.getString(26));
				bean.setBus_self_yn		(rs.getString(27));
				bean.setQ_reg_dt		(rs.getString(28));
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:getCarOffPreComConNo]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreComConNo]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}

	public CarOffPreBean getCarOffPreSeq(String seq)
	{
		getConnection();

		CarOffPreBean bean = new CarOffPreBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, "+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, "+
				"        b.r_seq, b.reg_id, b.reg_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt, a.in_col, to_char(a.req_dt, 'yyyy-mm-dd hh24:mi:ss') req_dt, b.cust_tel, b.memo, "+
				"		 a.pre_out_yn, a.eco_yn, a.garnish_col, a.agent_view_yn, a.bus_self_yn, a.q_reg_dt, a.con_bank, a.con_acc_no, a.con_acc_nm, a.con_est_dt, a.trf_st0, a.acc_st0  "+
				" FROM   car_pur_com_pre a, "+
				"        (select a.* from car_pur_com_pre_res a, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null group by seq) b where a.cls_dt IS NULL AND a.seq=b.seq and a.r_seq=b.r_seq) b "+
				" WHERE  a.seq=? and a.seq=b.seq(+) ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, seq);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setSeq				(rs.getInt(1));
				bean.setCar_off_nm		(rs.getString(2));
				bean.setCom_con_no		(rs.getString(3));
				bean.setCar_nm			(rs.getString(4));
				bean.setOpt				(rs.getString(5));
				bean.setColo			(rs.getString(6));
				bean.setCar_amt			(rs.getInt(7));	
				bean.setCon_amt			(rs.getInt(8));	
				bean.setCon_pay_dt		(rs.getString(9));
				bean.setDlv_est_dt		(rs.getString(10));
				bean.setEtc				(rs.getString(11));
				bean.setUse_yn			(rs.getString(12));
				bean.setCls_dt			(rs.getString(13));
				bean.setRent_l_cd		(rs.getString(14));
				bean.setR_seq			(rs.getInt(15));				
				bean.setReg_id			(rs.getString(16));
				bean.setReg_dt			(rs.getString(17));
				bean.setBus_nm			(rs.getString(18));
				bean.setFirm_nm			(rs.getString(19));
				bean.setAddr			(rs.getString(20));
				bean.setRes_cls_dt		(rs.getString(21));
				bean.setIn_col			(rs.getString(22));
				bean.setReq_dt			(rs.getString(23));	//요청일자 추가(20181108)
				bean.setCust_tel		(rs.getString(24));
				bean.setMemo			(rs.getString(25));
				bean.setPre_out_yn		(rs.getString(26));	//즉시출고 추가(20190305)
				bean.setEco_yn			(rs.getString(27));	//엔진구분 추가(20191127)
				bean.setGarnish_col		(rs.getString(28));
				bean.setAgent_view_yn	(rs.getString(29));
				bean.setBus_self_yn		(rs.getString(30));
				bean.setQ_reg_dt		(rs.getString(31));
				bean.setCon_bank		(rs.getString(32));
				bean.setCon_acc_no		(rs.getString(33));
				bean.setCon_acc_nm		(rs.getString(34));
				bean.setCon_est_dt		(rs.getString(35));
				bean.setTrf_st0			(rs.getString(36));
				bean.setAcc_st0			(rs.getString(37));
				
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:getCarOffPreSeq]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreSeq]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}
	
	public CarOffPreBean getCarOffPreSeq(String seq, String r_seq)
	{
		getConnection();

		CarOffPreBean bean = new CarOffPreBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, "+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, "+
				"        b.r_seq, b.reg_id, b.reg_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt, a.in_col, to_char(a.req_dt, 'yyyy-mm-dd hh24:mi:ss') req_dt, b.cust_tel, b.memo, "+
				"		 a.pre_out_yn, a.eco_yn, a.garnish_col, a.agent_view_yn, a.bus_self_yn, a.q_reg_dt, a.con_bank, a.con_acc_no, a.con_acc_nm, a.con_est_dt, a.trf_st0, a.acc_st0  "+
				" FROM   car_pur_com_pre a, car_pur_com_pre_res b "+				
				" WHERE  a.seq=? and a.seq=b.seq and b.r_seq=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, seq);
			pstmt.setString(2, r_seq);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setSeq				(rs.getInt(1));
				bean.setCar_off_nm		(rs.getString(2));
				bean.setCom_con_no		(rs.getString(3));
				bean.setCar_nm			(rs.getString(4));
				bean.setOpt				(rs.getString(5));
				bean.setColo			(rs.getString(6));
				bean.setCar_amt			(rs.getInt(7));	
				bean.setCon_amt			(rs.getInt(8));	
				bean.setCon_pay_dt		(rs.getString(9));
				bean.setDlv_est_dt		(rs.getString(10));
				bean.setEtc				(rs.getString(11));
				bean.setUse_yn			(rs.getString(12));
				bean.setCls_dt			(rs.getString(13));
				bean.setRent_l_cd		(rs.getString(14));
				bean.setR_seq			(rs.getInt(15));				
				bean.setReg_id			(rs.getString(16));
				bean.setReg_dt			(rs.getString(17));
				bean.setBus_nm			(rs.getString(18));
				bean.setFirm_nm			(rs.getString(19));
				bean.setAddr			(rs.getString(20));
				bean.setRes_cls_dt		(rs.getString(21));
				bean.setIn_col			(rs.getString(22));
				bean.setReq_dt			(rs.getString(23));	//요청일자 추가(20181108)
				bean.setCust_tel		(rs.getString(24));
				bean.setMemo			(rs.getString(25));
				bean.setPre_out_yn		(rs.getString(26));	//즉시출고 추가(20190305)
				bean.setEco_yn			(rs.getString(27));	//엔진구분 추가(20191127)
				bean.setGarnish_col		(rs.getString(28));
				bean.setAgent_view_yn	(rs.getString(29));
				bean.setBus_self_yn		(rs.getString(30));
				bean.setQ_reg_dt		(rs.getString(31));
				bean.setCon_bank		(rs.getString(32));
				bean.setCon_acc_no		(rs.getString(33));
				bean.setCon_acc_nm		(rs.getString(34));
				bean.setCon_est_dt		(rs.getString(35));
				bean.setTrf_st0			(rs.getString(36));
				bean.setAcc_st0			(rs.getString(37));
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:getCarOffPreSeq]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreSeq]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}
	

	public boolean insertCarOffPre(CarOffPreBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query = "";
		String query2 = "";
		int seq = 0;

		String seq_query = " select CAR_PUR_COM_PRE_SEQ.nextval from dual ";
			
		query = " INSERT INTO car_pur_com_pre "+
				" (seq, car_off_nm, com_con_no, car_nm, opt, colo, car_amt, con_amt, con_pay_dt, dlv_est_dt, etc, use_yn, "+
				"  rent_l_cd, reg_dt, in_col, req_dt, eco_yn, garnish_col, agent_view_yn, bus_self_yn, q_reg_dt, "+
				"  con_bank, con_acc_no, con_acc_nm, con_est_dt, trf_st0, acc_st0, car_off_id ) VALUES"+
				" ( ?, ?, ?, ?, ?,   ?, ?, ?, replace(?,'-',''), replace(?,'-',''), ?, ?, "+
				"   ?, sysdate, ?, TO_DATE(?,'YYYY-MM-DD HH24:MI:SS'), ?, ?, ?, ?, decode(?,'Y',sysdate,''), "+
				"   ?, ?, ?, replace(?,'-',''), ?, ?, ? )";

		query2= " INSERT INTO car_pur_com_pre_res "+
				" (seq, r_seq, reg_id, reg_dt, bus_nm, firm_nm, addr) VALUES"+
				" ( ?, 1, ?, sysdate, ?, ?, ?)";

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(seq_query);
	    	rs = pstmt1.executeQuery();
	    	if(rs.next())
	    		seq=rs.getInt(1);
			rs.close();
            pstmt1.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setInt	(1,	seq				);
			pstmt.setString	(2,	bean.getCar_off_nm		()	);
			pstmt.setString	(3,	bean.getCom_con_no		().trim()	);
			pstmt.setString	(4,	bean.getCar_nm			()	);
			pstmt.setString	(5,	bean.getOpt				()	);
			pstmt.setString	(6,	bean.getColo			()	);
			pstmt.setInt	(7,	bean.getCar_amt			()	);
			pstmt.setInt	(8,	bean.getCon_amt			()	);
			pstmt.setString	(9,	bean.getCon_pay_dt		()	);
			pstmt.setString	(10,bean.getDlv_est_dt		()	);
			pstmt.setString	(11,bean.getEtc				()	);
			pstmt.setString	(12,bean.getUse_yn			()	);
			pstmt.setString	(13,bean.getRent_l_cd		()	);
			pstmt.setString	(14,bean.getIn_col			()	);
			pstmt.setString	(15,bean.getReq_dt			()	);
			pstmt.setString	(16,bean.getEco_yn			()	);
			pstmt.setString	(17,bean.getGarnish_col		()	);
			pstmt.setString	(18,bean.getAgent_view_yn	()	);
			pstmt.setString	(19,bean.getBus_self_yn		()	);
			pstmt.setString	(20,bean.getQ_reg_dt		()	);
			pstmt.setString	(21,bean.getCon_bank		()	);
			pstmt.setString	(22,bean.getCon_acc_no		()	);
			pstmt.setString	(23,bean.getCon_acc_nm		()	);
			pstmt.setString	(24,bean.getCon_est_dt		()	);
			pstmt.setString	(25,bean.getTrf_st0			()	);
			pstmt.setString	(26,bean.getAcc_st0			()	);
			pstmt.setString	(27,bean.getCar_off_id		()	);
			
			pstmt.executeUpdate();
			pstmt.close();

			if(!bean.getBus_nm().equals("")){
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setInt	(1,	seq				);
				pstmt2.setString(2,	bean.getReg_id			()	);
				pstmt2.setString(3,	bean.getBus_nm			()	);
				pstmt2.setString(4,	bean.getFirm_nm			()	);
				pstmt2.setString(5,	bean.getAddr			()	);
				pstmt2.executeUpdate();
				pstmt2.close();
			}

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:insertCarOffPre]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean insertCarOffPreRes(CarOffPreBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String query = "";
		int r_seq = 0;

		String seq_query = " select nvl(max(r_seq)+1,1) from car_pur_com_pre_res where seq=? ";
			
		query= " INSERT INTO car_pur_com_pre_res "+
				" (seq, r_seq, reg_id, reg_dt, bus_nm, firm_nm, addr, cust_tel, memo, bus_tel, cust_q) VALUES"+
				" ( ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, ?)";

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(seq_query);
			pstmt1.setInt	(1,	bean.getSeq());
	    	rs = pstmt1.executeQuery();
	    	if(rs.next())
	    		r_seq=rs.getInt(1);
			rs.close();
            pstmt1.close();
			
			pstmt = conn.prepareStatement(query);
			pstmt.setInt	(1,	bean.getSeq()				);
			pstmt.setInt	(2,	r_seq						);
			pstmt.setString (3,	bean.getReg_id			()	);
			pstmt.setString (4,	bean.getBus_nm			()	);
			pstmt.setString (5,	bean.getFirm_nm			()	);
			pstmt.setString	(6,	bean.getAddr			()	);
			pstmt.setString (7,	bean.getCust_tel		()	);
			pstmt.setString	(8,	bean.getMemo			()	);
			pstmt.setString (9,	bean.getBus_tel			()	);
			pstmt.setString (10,bean.getCust_q			()	);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:insertCarOffPreRes]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean updateCarOffPreResCls(int seq, int r_seq)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE car_pur_com_pre_res SET cls_dt	= to_char(sysdate,'YYYYMMDD') WHERE seq=? and r_seq=?";
					
		try 
		{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.setInt 	(1,		seq		);
			pstmt.setInt 	(2,		r_seq	);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updateCarOffPreResCls]\n"+e);
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
	
	public boolean updateCarOffPreResConfirm(int seq, int r_seq)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE car_pur_com_pre_res SET confirm_dt	= to_char(sysdate,'YYYYMMDD') WHERE seq=? and r_seq=?";
					
		try 
		{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.setInt 	(1,		seq		);
			pstmt.setInt 	(2,		r_seq	);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updateCarOffPreResConfirm]\n"+e);
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

	public boolean updateCarOffPreCls(int seq)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE car_pur_com_pre SET cls_dt	= to_char(sysdate,'YYYYMMDD'), use_yn='N' WHERE seq=?";
					
		try 
		{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.setInt 	(1,		seq		);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updateCarOffPreCls]\n"+e);
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

	public boolean updateCarOffPreRes(CarOffPreBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE car_pur_com_pre_res SET bus_nm=?, firm_nm=?, addr=?, cust_tel=?, memo=?, bus_tel=? WHERE seq=? and r_seq=?";
					
		try 
		{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.setString 	(1,	bean.getBus_nm()	);
			pstmt.setString 	(2,	bean.getFirm_nm()	);
			pstmt.setString		(3,	bean.getAddr()		);
			pstmt.setString 	(4,	bean.getCust_tel()	);
			pstmt.setString		(5,	bean.getMemo()		);			
			pstmt.setString		(6,	bean.getBus_tel()	);
			pstmt.setInt		(7,	bean.getSeq()		);
			pstmt.setInt		(8,	bean.getR_seq()		);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updateCarOffPreRes]\n"+e);
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

	public boolean updateCarOffPre(CarOffPreBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE car_pur_com_pre SET com_con_no=?, car_nm=?, opt=?, colo=?, in_col=?, car_amt=?, con_amt=?, con_pay_dt=replace(?,'-',''), dlv_est_dt=replace(?,'-',''), etc=?, rent_l_cd=?, "+
				"        pre_out_yn=?, eco_yn=?, req_dt=TO_DATE(?, 'YYYY-MM-DD HH24:MI:SS'), garnish_col=?, agent_view_yn=?, bus_self_yn=?, "+
				"        con_bank=?, con_acc_no=?, con_acc_nm=?, con_est_dt=replace(?,'-',''), trf_st0=?, acc_st0=? "+	
				" WHERE seq=? ";
					
		try 
		{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	bean.getCom_con_no().trim()		);
			pstmt.setString	(2,	bean.getCar_nm()			);
			pstmt.setString	(3,	bean.getOpt()				);
			pstmt.setString	(4,	bean.getColo()				);
			pstmt.setString	(5,	bean.getIn_col()			);
			pstmt.setInt	(6,	bean.getCar_amt()			);
			pstmt.setInt	(7,	bean.getCon_amt()			);
			pstmt.setString	(8,	bean.getCon_pay_dt()		);
			pstmt.setString	(9, bean.getDlv_est_dt()		);
			pstmt.setString	(10,bean.getEtc()				);
			pstmt.setString	(11,bean.getRent_l_cd()			);
			pstmt.setString	(12,bean.getPre_out_yn()		);	//즉시출고 추가(20190305)
			pstmt.setString	(13,bean.getEco_yn()			);	//친환경차여부(20191114)
			pstmt.setString	(14,bean.getReq_dt()			);
			pstmt.setString	(15,bean.getGarnish_col()		);
			pstmt.setString	(16,bean.getAgent_view_yn()		);
			pstmt.setString	(17,bean.getBus_self_yn()		);
			pstmt.setString	(18,bean.getCon_bank()			);
			pstmt.setString	(19,bean.getCon_acc_no()		);
			pstmt.setString	(20,bean.getCon_acc_nm()		);
			pstmt.setString	(21,bean.getCon_est_dt()		);
			pstmt.setString	(22,bean.getTrf_st0()			);
			pstmt.setString	(23,bean.getAcc_st0()			);
			pstmt.setInt	(24,bean.getSeq()				);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updateCarOffPre]\n"+e);
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
	
	public boolean updateCarOffPreQ(CarOffPreBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE car_pur_com_pre SET q_reg_dt=decode(?,'Y',sysdate,'') "+	
				" WHERE seq=? ";
					
		try 
		{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,bean.getQ_reg_dt()	);
			pstmt.setInt	(2,bean.getSeq()		);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updateCarOffPreQ]\n"+e);
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

	public Vector getCarOffPreList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, a.in_col, a.garnish_col, \n"+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, a.reg_dt,  \n"+
				"        b.r_seq, b.reg_id, to_char(b.reg_dt,'YYYYMMDD') as res_reg_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt,  \n"+
				"        c.dlv_dt, a.req_dt "+
				" FROM   car_pur_com_pre a, cont c, \n"+
				"        (select a.* from car_pur_com_pre_res a, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null group by seq) b where a.cls_dt IS NULL AND a.seq=b.seq and a.r_seq=b.r_seq) b  \n"+
				" WHERE  a.seq=b.seq(+) and a.rent_l_cd=c.rent_l_cd(+) \n";
		
		if(!gubun3.equals(""))		query += " and a.car_off_nm='"+gubun3+"' \n";
		
		if(!gubun4.equals(""))		query += " and a.car_nm like '%"+gubun4+"%' \n";
		
		if(gubun5.equals("Y"))		query += " and a.use_yn='Y' and c.dlv_dt is null \n";
		if(gubun5.equals("Y1"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is not null  \n"; //진행-계약
		if(gubun5.equals("Y2"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is null \n"; //대기
		if(gubun5.equals("Y3"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is not null \n"; //예약
		if(gubun5.equals("N"))		query += " and a.use_yn='N' \n";
		if(gubun5.equals("P"))		query += " and c.dlv_dt is not null \n";
		
		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		if(gubun1.equals("1")){
			dt1 = "to_char(a.reg_dt,'YYYYMM')";
			dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
		}else if(gubun1.equals("2")){
			dt1 = "substr(a.dlv_est_dt,1,6)";
			dt2 = "a.dlv_est_dt";
		}else if(gubun1.equals("3")){
			dt1 = "substr(a.cls_dt,1,6)";
			dt2 = "a.cls_dt";
		}else if(gubun1.equals("4")){
			dt1 = "to_char(a.req_dt,'YYYYMM')";
			dt2 = "to_char(a.req_dt,'YYYYMMDD')";
		}
		
		//당일
		if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		//전일
		else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
		//당월
		else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		//기간
		else if(gubun2.equals("4")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		
		if(s_kd.equals("1"))	what = "upper(a.com_con_no)";	
		if(s_kd.equals("2"))	what = "a.opt";	
		if(s_kd.equals("3"))	what = "a.colo||a.in_col||a.garnish_col";		
		if(s_kd.equals("4"))	what = "b.bus_nm";	
		if(s_kd.equals("5"))	what = "b.firm_nm";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){	query += " and "+what+" like upper('%"+t_wd+"%') ";		}
			else{					query += " and "+what+" like '%"+t_wd+"%' ";			}	
		}
		
		if(sort.equals("1"))		query += " order by a.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("2"))		query += " order by a.dlv_est_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("3"))		query += " order by a.com_con_no ";
		if(sort.equals("4"))		query += " order by a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)	{
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:getCarOffPreList]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreList]\n"+query);
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
	
	public Vector getCarOffPreList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt,
								   String opt1, String opt2, String opt3, String opt4, String opt5, String opt6, String opt7, String e_opt1, String e_opt2, String e_opt3, String e_opt4, String e_opt5, String e_opt6, String e_opt7)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, a.in_col, a.garnish_col, \n"+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, a.reg_dt,  \n"+
				"        b.r_seq, b.reg_id, to_char(b.reg_dt,'YYYYMMDD') as res_reg_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt,  \n"+
				"        c.dlv_dt, a.req_dt, b.cust_tel, b.memo, "+ //고객연락처,메모 추가(20181205)
				"		 DECODE(a.use_yn, 'N','취소',DECODE(c.dlv_dt,'',DECODE(a.rent_l_cd, '',DECODE(b.bus_nm, '','대기','예약'),'계약'),'출고')) AS status \n"+	//진행구분추가(20181119)
				" FROM   car_pur_com_pre a, cont c, \n"+
				"        (select a.* from car_pur_com_pre_res a, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null group by seq) b where a.cls_dt IS NULL AND a.seq=b.seq and a.r_seq=b.r_seq) b  \n"+
				" WHERE  a.seq=b.seq(+) and a.rent_l_cd=c.rent_l_cd(+) \n";

		if(!gubun3.equals(""))		query += " and a.car_off_nm='"+gubun3+"' \n";

		if(!gubun4.equals(""))		query += " and upper(a.car_nm) like upper('%"+gubun4+"%') \n";

		if(gubun5.equals("Y"))		query += " and a.use_yn='Y' and c.dlv_dt is null \n";
		if(gubun5.equals("Y1"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is not null  \n"; //진행-계약
		if(gubun5.equals("Y2"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is null \n"; //대기
		if(gubun5.equals("Y3"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is not null \n"; //예약
		if(gubun5.equals("N"))		query += " and a.use_yn='N' \n";
		if(gubun5.equals("P"))		query += " and c.dlv_dt is not null \n";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1 = "to_char(a.reg_dt,'YYYYMM')";
			dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
		}else if(gubun1.equals("2")){
			dt1 = "substr(a.dlv_est_dt,1,6)";
			dt2 = "a.dlv_est_dt";
		}else if(gubun1.equals("3")){
			dt1 = "substr(a.cls_dt,1,6)";
			dt2 = "a.cls_dt";
		}else if(gubun1.equals("4")){
			dt1 = "to_char(a.req_dt,'YYYYMM')";
			dt2 = "to_char(a.req_dt,'YYYYMMDD')";
		}else if(gubun1.equals("5")){	//예약일 추가(20181123)
			dt1 = "to_char(b.reg_dt,'YYYYMM')";
			dt2 = "to_char(b.reg_dt,'YYYYMMDD')";
		}

		//당일
		if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		//전일
		else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
		//당월
		else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		//기간
		else if(gubun2.equals("4")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))	what = "upper(a.com_con_no)";	
		if(s_kd.equals("2"))	what = "a.opt";	
		if(s_kd.equals("3"))	what = "a.colo||a.in_col||a.garnish_col";		
		if(s_kd.equals("4"))	what = "b.bus_nm";	
		if(s_kd.equals("5"))	what = "b.firm_nm";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){	query += " and "+what+" like upper('%"+t_wd+"%') ";		}
			else{					query += " and "+what+" like '%"+t_wd+"%' ";			}	
		}
		
		//사양은 키워드 5개까지 검색되게(20181108)
		if(!opt1.equals("")||!opt2.equals("")||!opt3.equals("")||!opt4.equals("")||!opt5.equals("")||!opt6.equals("")||!opt7.equals("")){
			if(!opt1.equals("")){	query += "and upper(a.opt) like upper('%"+opt1+"%') ";		}
			if(!opt2.equals("")){	query += "and upper(a.opt) like upper('%"+opt2+"%') ";		}
			if(!opt3.equals("")){	query += "and upper(a.opt) like upper('%"+opt3+"%') ";		}
			if(!opt4.equals("")){	query += "and upper(a.opt) like upper('%"+opt4+"%') ";		}
			if(!opt5.equals("")){	query += "and upper(a.opt) like upper('%"+opt5+"%') ";		}
			if(!opt6.equals("")){	query += "and upper(a.opt) like upper('%"+opt6+"%') ";		}
			if(!opt7.equals("")){	query += "and upper(a.opt) like upper('%"+opt7+"%') ";		}
		}
		//사양제외 검색추가(5개까지)(20181112)
		if(!e_opt1.equals("")||!e_opt2.equals("")||!e_opt3.equals("")||!e_opt4.equals("")||!e_opt5.equals("")||!e_opt6.equals("")||!e_opt7.equals("")){
			if(!e_opt1.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt1+"%') ";		}
			if(!e_opt2.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt2+"%') ";		}
			if(!e_opt3.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt3+"%') ";		}
			if(!e_opt4.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt4+"%') ";		}
			if(!e_opt5.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt5+"%') ";		}
			if(!e_opt6.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt6+"%') ";		}
			if(!e_opt7.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt7+"%') ";		}
		}
		
//		if(!user_nm.equals("")){	//에이전트인 경우는 본인예약+예약자 미지정만 보이게 처리(20181127)
//			query += "	and (b.bus_nm = '"+user_nm+"' or b.bus_nm is null)	";
//		}
		
		if(sort.equals("1"))		query += " order by a.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("2"))		query += " order by a.dlv_est_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("3"))		query += " order by a.com_con_no ";
		if(sort.equals("4"))		query += " order by a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("5"))		query += " order by b.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";	//예약일 추가(20181123)
				
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
			System.out.println("[CarOffPreDatabase:getCarOffPreList]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreList]\n"+query);
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
	
	//사전계약관리 리스트(20190307 현재 주로 사용)
	public Vector getCarOffPreList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, 
								   String st_dt, String end_dt, String opt1, String opt2, String opt3, String opt4, String opt5, String opt6, String opt7, 
								   String e_opt1, String e_opt2, String e_opt3, String e_opt4, String e_opt5, String e_opt6, String e_opt7, String user_nm)
	{								// ^^ 22
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, a.in_col, a.garnish_col,  \n"+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, a.reg_dt,  \n"+
				"        b.r_seq, b.reg_id, to_char(b.reg_dt,'YYYYMMDD') as res_reg_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt,  \n"+
				"        c.dlv_dt, a.req_dt, b.cust_tel, b.memo, "+ //고객연락처,메모 추가(20181205)
				"		 DECODE(a.use_yn, 'N','취소',DECODE(c.dlv_dt,'',DECODE(a.rent_l_cd, '',DECODE(b.bus_nm, '','대기','예약'),'계약'),'출고')) AS status, \n"+	//진행구분추가(20181119)
				"		 a.pre_out_yn, \n "+	//즉시출고 추가(20190305)
				"		 CASE WHEN a.car_nm LIKE '%블루컬러팩%' OR a.in_col LIKE '%블루컬러팩%' THEN '블루컬러팩'	ELSE '' END  AS blue_col \n "+	//블루컬러팩여부 (20190307)
				" FROM   car_pur_com_pre a, cont c, \n"+
				"        (select a.* from car_pur_com_pre_res a, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null group by seq) b where a.cls_dt IS NULL AND a.seq=b.seq and a.r_seq=b.r_seq) b  \n"+
				" WHERE  a.seq=b.seq(+) and a.rent_l_cd=c.rent_l_cd(+) \n";

		if(!gubun3.equals(""))		query += " and a.car_off_nm='"+gubun3+"' \n";

		if(!gubun4.equals(""))		query += " and upper(a.car_nm) like upper('%"+gubun4+"%') \n";

		if(gubun5.equals("Y"))		query += " and a.use_yn='Y' and c.dlv_dt is null \n";
		if(gubun5.equals("Y1"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is not null  \n"; //진행-계약
		if(gubun5.equals("Y2"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is null \n"; //대기
		if(gubun5.equals("Y3"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is not null \n"; //예약
		if(gubun5.equals("Y4"))		query += " and a.use_yn='Y' and a.pre_out_yn='Y' \n"; //즉시출고 추가(20190305)
		if(gubun5.equals("N"))		query += " and a.use_yn='N' \n";
		if(gubun5.equals("P"))		query += " and c.dlv_dt is not null \n";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1 = "to_char(a.reg_dt,'YYYYMM')";
			dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
		}else if(gubun1.equals("2")){
			dt1 = "substr(a.dlv_est_dt,1,6)";
			dt2 = "a.dlv_est_dt";
		}else if(gubun1.equals("3")){
			dt1 = "substr(a.cls_dt,1,6)";
			dt2 = "a.cls_dt";
		}else if(gubun1.equals("4")){
			dt1 = "to_char(a.req_dt,'YYYYMM')";
			dt2 = "to_char(a.req_dt,'YYYYMMDD')";
		}else if(gubun1.equals("5")){	//예약일 추가(20181123)
			dt1 = "to_char(b.reg_dt,'YYYYMM')";
			dt2 = "to_char(b.reg_dt,'YYYYMMDD')";
		}

		//당일
		if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		//전일
		else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
		//당월
		else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		//기간
		else if(gubun2.equals("4")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))	what = "upper(a.com_con_no)";	
		if(s_kd.equals("2"))	what = "a.opt";	
		if(s_kd.equals("3"))	what = "a.colo||a.in_col||a.garnish_col";		
		if(s_kd.equals("4"))	what = "b.bus_nm";	
		if(s_kd.equals("5"))	what = "b.firm_nm";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){	query += " and "+what+" like upper('%"+t_wd+"%') ";		}
			else{					query += " and "+what+" like '%"+t_wd+"%' ";			}	
		}
		
		//사양은 키워드 5개까지 검색되게(20181108)
		if(!opt1.equals("")||!opt2.equals("")||!opt3.equals("")||!opt4.equals("")||!opt5.equals("")||!opt6.equals("")||!opt7.equals("")){
			if(!opt1.equals("")){	query += "and upper(a.opt) like upper('%"+opt1+"%') ";		}
			if(!opt2.equals("")){	query += "and upper(a.opt) like upper('%"+opt2+"%') ";		}
			if(!opt3.equals("")){	query += "and upper(a.opt) like upper('%"+opt3+"%') ";		}
			if(!opt4.equals("")){	query += "and upper(a.opt) like upper('%"+opt4+"%') ";		}
			if(!opt5.equals("")){	query += "and upper(a.opt) like upper('%"+opt5+"%') ";		}
			if(!opt6.equals("")){	query += "and upper(a.opt) like upper('%"+opt6+"%') ";		}
			if(!opt7.equals("")){	query += "and upper(a.opt) like upper('%"+opt7+"%') ";		}
		}
		//사양제외 검색추가(5개까지)(20181112)
		if(!e_opt1.equals("")||!e_opt2.equals("")||!e_opt3.equals("")||!e_opt4.equals("")||!e_opt5.equals("")||!e_opt6.equals("")||!e_opt7.equals("")){
			if(!e_opt1.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt1+"%') ";		}
			if(!e_opt2.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt2+"%') ";		}
			if(!e_opt3.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt3+"%') ";		}
			if(!e_opt4.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt4+"%') ";		}
			if(!e_opt5.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt5+"%') ";		}
			if(!e_opt6.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt6+"%') ";		}
			if(!e_opt7.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt7+"%') ";		}
		}
		
		//에이전트인 경우는 본인예약+예약자 미지정만 보이게 처리(20181127)
		if(!user_nm.equals("")){	query += "	and (b.bus_nm = '"+user_nm+"' or b.bus_nm is null)	";	}
		
		if(sort.equals("1"))		query += " order by a.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("2"))		query += " order by a.dlv_est_dt, a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("3"))		query += " order by a.com_con_no ";
		if(sort.equals("4"))		query += " order by a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("5"))		query += " order by b.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";	//예약일 추가(20181123)
		if(sort.equals("6"))		query += " order by a.pre_out_yn, a.car_off_nm, a.com_con_no, a.car_nm ";	//즉시출고(20190308)
		
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
			System.out.println("[CarOffPreDatabase:getCarOffPreList]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreList]\n"+query);
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
	
	//사전계약관리 리스트(20191114 현재 주로 사용)
	public Vector getCarOffPreList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, 
			String st_dt, String end_dt, String opt1, String opt2, String opt3, String opt4, String opt5, String opt6, String opt7, String e_opt1, 
			String e_opt2, String e_opt3, String e_opt4, String e_opt5, String e_opt6, String e_opt7, String user_nm, String eco_yn, String car_nm2, String car_nm3)
	{								// ^^ 22
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, a.in_col, a.garnish_col, \n"+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, a.reg_dt,  \n"+
				"        b.r_seq, b.reg_id, to_char(b.reg_dt,'YYYYMMDD') as res_reg_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt,  \n"+
				"        c.dlv_dt, a.req_dt, b.cust_tel, b.memo, "+ //고객연락처,메모 추가(20181205)
				"		 DECODE(a.use_yn, 'N','취소',DECODE(c.dlv_dt,'',DECODE(a.rent_l_cd, '',DECODE(b.bus_nm, '','대기','예약'),'계약'),'출고')) AS status, \n"+	//진행구분추가(20181119)
				"		 a.pre_out_yn, \n "+	//즉시출고 추가(20190305)
				"		 CASE WHEN a.car_nm LIKE '%블루컬러팩%' OR a.in_col LIKE '%블루컬러팩%' THEN '블루컬러팩'	ELSE '' END  AS blue_col, \n "+	//블루컬러팩여부 (20190307)
				"		 a.eco_yn, a.agent_view_yn, a.bus_self_yn, a.q_reg_dt, a.con_bank, a.con_acc_no, a.con_acc_nm, a.con_est_dt, a.trf_st0, a.acc_st0 \n "+	//엔진구분 추가(20191122)
				" FROM   car_pur_com_pre a, cont c, \n"+
				"        (select a.* from car_pur_com_pre_res a, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null group by seq) b where a.cls_dt IS NULL AND a.seq=b.seq and a.r_seq=b.r_seq) b  \n"+
				" WHERE  a.seq=b.seq(+) and a.rent_l_cd=c.rent_l_cd(+) \n";
		
		if(!gubun3.equals(""))		query += " and a.car_off_nm='"+gubun3+"' \n";
		
		if(!gubun4.equals(""))		query += " and upper(a.car_nm) like upper('%"+gubun4+"%') \n";
		if(!car_nm2.equals(""))		query += " and upper(a.car_nm) like upper('%"+car_nm2+"%') \n";
		if(!car_nm3.equals(""))		query += " and upper(a.car_nm) like upper('%"+car_nm3+"%') \n";
		
		if(gubun5.equals("Y"))		query += " and a.use_yn='Y' and c.dlv_dt is null \n";
		if(gubun5.equals("Y1"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is not null  \n"; //진행-계약
		if(gubun5.equals("Y2"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is null \n"; //대기
		if(gubun5.equals("Y3"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is not null \n"; //예약
		if(gubun5.equals("Y4"))		query += " and a.use_yn='Y' and a.pre_out_yn='Y' \n"; //즉시출고 추가(20190305)
		if(gubun5.equals("N"))		query += " and a.use_yn='N' \n";
		if(gubun5.equals("P"))		query += " and c.dlv_dt is not null \n";
		
		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		if(gubun1.equals("1")){
			dt1 = "to_char(a.reg_dt,'YYYYMM')";
			dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
		}else if(gubun1.equals("2")){
			dt1 = "substr(a.dlv_est_dt,1,6)";
			dt2 = "a.dlv_est_dt";
		}else if(gubun1.equals("3")){
			dt1 = "substr(a.cls_dt,1,6)";
			dt2 = "a.cls_dt";
		}else if(gubun1.equals("4")){
			dt1 = "to_char(a.req_dt,'YYYYMM')";
			dt2 = "to_char(a.req_dt,'YYYYMMDD')";
		}else if(gubun1.equals("5")){	//예약일 추가(20181123)
			dt1 = "to_char(b.reg_dt,'YYYYMM')";
			dt2 = "to_char(b.reg_dt,'YYYYMMDD')";
		}
		
		//당일
		if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		//전일
		else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
		//당월
		else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		//기간
		else if(gubun2.equals("4")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		
		if(s_kd.equals("1"))	what = "upper(a.com_con_no)";	
		if(s_kd.equals("2"))	what = "a.opt";	
		if(s_kd.equals("3"))	what = "a.colo||a.in_col||a.garnish_col";		
		if(s_kd.equals("4"))	what = "b.bus_nm";	
		if(s_kd.equals("5"))	what = "b.firm_nm";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){	query += " and "+what+" like upper('%"+t_wd+"%') ";		}
			else{					query += " and "+what+" like '%"+t_wd+"%' ";			}	
		}
		
		//사양은 키워드 5개까지 검색되게(20181108)
		if(!opt1.equals("")||!opt2.equals("")||!opt3.equals("")||!opt4.equals("")||!opt5.equals("")||!opt6.equals("")||!opt7.equals("")){
			if(!opt1.equals("")){	query += "and upper(a.opt) like upper('%"+opt1+"%') ";		}
			if(!opt2.equals("")){	query += "and upper(a.opt) like upper('%"+opt2+"%') ";		}
			if(!opt3.equals("")){	query += "and upper(a.opt) like upper('%"+opt3+"%') ";		}
			if(!opt4.equals("")){	query += "and upper(a.opt) like upper('%"+opt4+"%') ";		}
			if(!opt5.equals("")){	query += "and upper(a.opt) like upper('%"+opt5+"%') ";		}
			if(!opt6.equals("")){	query += "and upper(a.opt) like upper('%"+opt6+"%') ";		}
			if(!opt7.equals("")){	query += "and upper(a.opt) like upper('%"+opt7+"%') ";		}
		}
		//사양제외 검색추가(5개까지)(20181112)
		if(!e_opt1.equals("")||!e_opt2.equals("")||!e_opt3.equals("")||!e_opt4.equals("")||!e_opt5.equals("")||!e_opt6.equals("")||!e_opt7.equals("")){
			if(!e_opt1.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt1+"%') ";		}
			if(!e_opt2.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt2+"%') ";		}
			if(!e_opt3.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt3+"%') ";		}
			if(!e_opt4.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt4+"%') ";		}
			if(!e_opt5.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt5+"%') ";		}
			if(!e_opt6.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt6+"%') ";		}
			if(!e_opt7.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt7+"%') ";		}
		}
		
		//에이전트인 경우는 본인예약+예약자 미지정만 보이게 처리(20181127)
		if(!user_nm.equals("")){	query += "	and (b.bus_nm = '"+user_nm+"' or b.bus_nm is null)	";	}
		
		if (!eco_yn.equals("")) {
			query += " AND a.ECO_YN='"+eco_yn+"' \n";
		}
		
		if(sort.equals("1"))		query += " order by a.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("2"))		query += " order by a.dlv_est_dt, a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("3"))		query += " order by a.com_con_no ";
		if(sort.equals("4"))		query += " order by a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("5"))		query += " order by b.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";	//예약일 추가(20181123)
		if(sort.equals("6"))		query += " order by a.pre_out_yn, a.car_off_nm, a.com_con_no, a.car_nm ";	//즉시출고(20190308)
		
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
			System.out.println("[CarOffPreDatabase:getCarOffPreList]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreList]\n"+query);
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
	
	//사전계약관리 리스트(20210201 추가)
	public Vector getCarOffPreList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, 
			String st_dt, String end_dt, String opt1, String opt2, String opt3, String opt4, String opt5, String opt6, String opt7, String e_opt1, 
			String e_opt2, String e_opt3, String e_opt4, String e_opt5, String e_opt6, String e_opt7, String user_nm, String eco_yn, String dept_id, String car_nm2, String car_nm3)
	{								// ^^ 22
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, a.in_col, a.garnish_col, \n"+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, a.reg_dt,  \n"+
				"        b.r_seq, b.reg_id, to_char(b.reg_dt,'YYYYMMDD') as res_reg_dt, nvl2(b.res_end_dt, b.res_end_dt, '') as res_end_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt,  \n"+
				"        c.dlv_dt, a.req_dt, b.cust_tel, b.memo, b.cust_q, "+ //고객연락처,메모 추가(20181205)
				"		 DECODE(a.use_yn, 'N','취소',DECODE(c.dlv_dt,'',DECODE(a.rent_l_cd, '',DECODE(b.bus_nm, '','대기','예약'),'계약'),'출고')) AS status, \n"+	//진행구분추가(20181119)
				"		 a.pre_out_yn, \n "+	//즉시출고 추가(20190305)
				"		 CASE WHEN a.car_nm LIKE '%블루컬러팩%' OR a.in_col LIKE '%블루컬러팩%' THEN '블루컬러팩'	ELSE '' END  AS blue_col, \n "+	//블루컬러팩여부 (20190307)
				"		 a.eco_yn, a.agent_view_yn, a.bus_self_yn, a.q_reg_dt, '' as bus_nm2 \n "+	//엔진구분 추가(20191122)
				//"        (SELECT bus_nm FROM car_pur_com_pre_res z, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null group by seq) y WHERE z.seq = a.seq AND z.seq = y.seq AND z.cls_dt IS NULL AND z.r_seq != y.r_seq ) AS bus_nm2 \n" + 	// 2순위 예약자명
				" FROM   car_pur_com_pre a, cont c, \n"+
				"        (select a.* from car_pur_com_pre_res a, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null group by seq) b where a.cls_dt IS NULL AND a.seq=b.seq and a.r_seq=b.r_seq) b  \n"+
				" WHERE  a.seq=b.seq(+) and a.rent_l_cd=c.rent_l_cd(+) \n";
		
		if(dept_id.equals("1000")) query += "and a.car_off_nm NOT IN ('총신대', '사직', '한강', '총신대역대리점') "; // 에이전트의 경우 현대차 대리점 차량 미표시 2021.02.01.
		
		if(!gubun3.equals(""))		query += " and a.car_off_nm='"+gubun3+"' \n";
		
		if(!gubun4.equals(""))		query += " and upper(a.car_nm) like upper('%"+gubun4+"%') \n";
		if(!car_nm2.equals(""))		query += " and upper(a.car_nm) like upper('%"+car_nm2+"%') \n";
		if(!car_nm3.equals(""))		query += " and upper(a.car_nm) like upper('%"+car_nm3+"%') \n";
		
		if(gubun5.equals("Y"))		query += " and a.use_yn='Y' and c.dlv_dt is null \n";
		if(gubun5.equals("Y1"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is not null  \n"; //진행-계약
		if(gubun5.equals("Y2"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is null \n"; //대기
		if(gubun5.equals("Y3"))		query += " and a.use_yn='Y' and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is not null \n"; //예약
		if(gubun5.equals("Y4"))		query += " and a.use_yn='Y' and a.pre_out_yn='Y' \n"; //즉시출고 추가(20190305)
		if(gubun5.equals("N"))		query += " and a.use_yn='N' \n";
		if(gubun5.equals("P"))		query += " and c.dlv_dt is not null \n";
		
		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		if(gubun1.equals("1")){
			dt1 = "to_char(a.reg_dt,'YYYYMM')";
			dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
		}else if(gubun1.equals("2")){
			dt1 = "substr(a.dlv_est_dt,1,6)";
			dt2 = "a.dlv_est_dt";
		}else if(gubun1.equals("3")){
			dt1 = "substr(a.cls_dt,1,6)";
			dt2 = "a.cls_dt";
		}else if(gubun1.equals("4")){
			dt1 = "to_char(a.req_dt,'YYYYMM')";
			dt2 = "to_char(a.req_dt,'YYYYMMDD')";
		}else if(gubun1.equals("5")){	//예약일 추가(20181123)
			dt1 = "to_char(b.reg_dt,'YYYYMM')";
			dt2 = "to_char(b.reg_dt,'YYYYMMDD')";
		}
		
		//당일
		if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		//전일
		else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
		//당월
		else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		//기간
		else if(gubun2.equals("4")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		
		if(s_kd.equals("1"))	what = "upper(a.com_con_no)";	
		if(s_kd.equals("2"))	what = "a.opt";	
		if(s_kd.equals("3"))	what = "a.colo||a.in_col||a.garnish_col";		
		if(s_kd.equals("4"))	what = "b.bus_nm";	
		if(s_kd.equals("5"))	what = "b.firm_nm";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){	query += " and "+what+" like upper('%"+t_wd+"%') ";		}
			else{					query += " and "+what+" like '%"+t_wd+"%' ";			}	
		}
		
		//사양은 키워드 5개까지 검색되게(20181108)
		if(!opt1.equals("")||!opt2.equals("")||!opt3.equals("")||!opt4.equals("")||!opt5.equals("")||!opt6.equals("")||!opt7.equals("")){
			if(!opt1.equals("")){	query += "and upper(a.opt) like upper('%"+opt1+"%') ";		}
			if(!opt2.equals("")){	query += "and upper(a.opt) like upper('%"+opt2+"%') ";		}
			if(!opt3.equals("")){	query += "and upper(a.opt) like upper('%"+opt3+"%') ";		}
			if(!opt4.equals("")){	query += "and upper(a.opt) like upper('%"+opt4+"%') ";		}
			if(!opt5.equals("")){	query += "and upper(a.opt) like upper('%"+opt5+"%') ";		}
			if(!opt6.equals("")){	query += "and upper(a.opt) like upper('%"+opt6+"%') ";		}
			if(!opt7.equals("")){	query += "and upper(a.opt) like upper('%"+opt7+"%') ";		}
		}
		//사양제외 검색추가(5개까지)(20181112)
		if(!e_opt1.equals("")||!e_opt2.equals("")||!e_opt3.equals("")||!e_opt4.equals("")||!e_opt5.equals("")||!e_opt6.equals("")||!e_opt7.equals("")){
			if(!e_opt1.equals("")){	query += "and ( upper(a.opt) not like upper('%"+e_opt1+"%') OR a.opt IS NULL ) ";		}
			if(!e_opt2.equals("")){	query += "and ( upper(a.opt) not like upper('%"+e_opt2+"%') OR a.opt IS NULL ) ";		}
			if(!e_opt3.equals("")){	query += "and ( upper(a.opt) not like upper('%"+e_opt3+"%') OR a.opt IS NULL ) ";		}
			if(!e_opt4.equals("")){	query += "and ( upper(a.opt) not like upper('%"+e_opt4+"%') OR a.opt IS NULL ) ";		}
			if(!e_opt5.equals("")){	query += "and ( upper(a.opt) not like upper('%"+e_opt5+"%') OR a.opt IS NULL ) ";		}
			if(!e_opt6.equals("")){	query += "and ( upper(a.opt) not like upper('%"+e_opt6+"%') OR a.opt IS NULL ) ";		}
			if(!e_opt7.equals("")){	query += "and ( upper(a.opt) not like upper('%"+e_opt7+"%') OR a.opt IS NULL ) ";		}
		}
		
		//에이전트인 경우는 본인예약+예약자 미지정만 보이게 처리(20181127)
		// 에이전트도 모든 건 노출
//		if(!user_nm.equals("")){	query += "	and (b.bus_nm = '"+user_nm+"' or b.bus_nm is null)	";	}
		
		if (!eco_yn.equals("")) {
			query += " AND a.ECO_YN='"+eco_yn+"' \n";
		}
		
		if(sort.equals("1"))		query += " order by a.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("2"))		query += " order by a.dlv_est_dt, a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("3"))		query += " order by a.com_con_no ";
		if(sort.equals("4"))		query += " order by a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("5"))		query += " order by b.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";	//예약일 추가(20181123)
		if(sort.equals("6"))		query += " order by a.pre_out_yn, a.car_off_nm, a.com_con_no, a.car_nm ";	//즉시출고(20190308)
		
		
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
			System.out.println("[CarOffPreDatabase:getCarOffPreList]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreList]\n"+query);
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
	

	
	//사전계약관리- 출고예정+본인 차량보기 리스트 (20190307)
	public Vector getDirectCarOffPreList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, 
								   String st_dt, String end_dt, String opt1, String opt2, String opt3, String opt4, String opt5, String opt6, String opt7, String e_opt1, 
								   String e_opt2, String e_opt3, String e_opt4, String e_opt5, String e_opt6, String e_opt7, String user_nm, String ready_car, String car_nm2, String car_nm3)
	{								// ^^ 22
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query 		= "";

		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, a.in_col, a.garnish_col, \n"+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, a.reg_dt,  \n"+
				"        b.r_seq, b.reg_id, to_char(b.reg_dt,'YYYYMMDD') as res_reg_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt,  \n"+
				"        c.dlv_dt, a.req_dt, b.cust_tel, b.memo, "+ //고객연락처,메모 추가(20181205)
				"		 DECODE(a.use_yn, 'N','취소',DECODE(c.dlv_dt,'',DECODE(a.rent_l_cd, '',DECODE(b.bus_nm, '','대기','예약'),'계약'),'출고')) AS status, \n"+	//진행구분추가(20181119)
				"		 a.pre_out_yn, \n "+	//즉시출고 추가(20190305)
				"		 CASE WHEN a.car_nm LIKE '%블루컬러팩%' OR a.in_col LIKE '%블루컬러팩%' THEN '블루컬러팩'	ELSE '' END  AS blue_col, \n "+	//블루컬러팩여부 (20190307)
				"		 a.eco_yn \n "+
				"   FROM   car_pur_com_pre a, cont c, \n"+
				"          (select a.* from car_pur_com_pre_res a, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null group by seq) b where a.cls_dt IS NULL AND a.seq=b.seq and a.r_seq=b.r_seq) b  \n"+
				"   WHERE  a.seq=b.seq(+) and a.rent_l_cd=c.rent_l_cd(+) \n";
		
		//출고예정일이 있으면서 진행구분이 대기
		if(ready_car.equals("1"))	query += " AND a.dlv_est_dt IS NOT NULL AND a.use_yn='Y' AND c.dlv_dt IS NULL AND a.rent_l_cd IS NULL AND b.bus_nm IS NULL \n ";
		//출고예정일이 있는 본인 예약/계약 건
		if(ready_car.equals("2"))	query += " AND a.dlv_est_dt IS NOT NULL and a.use_yn='Y' and c.dlv_dt is null and b.bus_nm = '"+user_nm+"' \n ";
		//출고예정일이 없는 본인 예약/계약 건
		if(ready_car.equals("3"))	query += " AND a.dlv_est_dt IS NULL and a.use_yn='Y' and c.dlv_dt is null and b.bus_nm = '"+user_nm+"' \n ";
		//출고예정일이 있는 타인 예약/계약 건
		if(ready_car.equals("4"))	query += " AND a.dlv_est_dt IS NOT NULL and a.use_yn='Y' and c.dlv_dt is null and b.bus_nm NOT IN('"+user_nm+"') \n ";
		
		if(!gubun3.equals(""))		query += " and a.car_off_nm='"+gubun3+"' \n";
		if(!gubun4.equals(""))		query += " and upper(a.car_nm) like upper('%"+gubun4+"%') \n";
		if(!car_nm2.equals(""))		query += " and upper(a.car_nm) like upper('%"+car_nm2+"%') \n";
		if(!car_nm3.equals(""))		query += " and upper(a.car_nm) like upper('%"+car_nm3+"%') \n";
		
		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1 = "to_char(a.reg_dt,'YYYYMM')";
			dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
		}else if(gubun1.equals("2")){
			dt1 = "substr(a.dlv_est_dt,1,6)";
			dt2 = "a.dlv_est_dt";
		}else if(gubun1.equals("3")){
			dt1 = "substr(a.cls_dt,1,6)";
			dt2 = "a.cls_dt";
		}else if(gubun1.equals("4")){
			dt1 = "to_char(a.req_dt,'YYYYMM')";
			dt2 = "to_char(a.req_dt,'YYYYMMDD')";
		}else if(gubun1.equals("5")){	//예약일 추가(20181123)
			dt1 = "to_char(b.reg_dt,'YYYYMM')";
			dt2 = "to_char(b.reg_dt,'YYYYMMDD')";
		}

		//당일
		if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		//전일
		else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
		//당월
		else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		//기간
		else if(gubun2.equals("4")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))	what = "upper(a.com_con_no)";	
		if(s_kd.equals("2"))	what = "a.opt";	
		if(s_kd.equals("3"))	what = "a.colo||a.in_col||a.garnish_col";		
		if(s_kd.equals("4"))	what = "b.bus_nm";	
		if(s_kd.equals("5"))	what = "b.firm_nm";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){	query += " and "+what+" like upper('%"+t_wd+"%') ";		}
			else{					query += " and "+what+" like '%"+t_wd+"%' ";			}	
		}
		
		//사양은 키워드 5개까지 검색되게(20181108)
		if(!opt1.equals("")||!opt2.equals("")||!opt3.equals("")||!opt4.equals("")||!opt5.equals("")||!opt6.equals("")||!opt7.equals("")){
			if(!opt1.equals("")){	query += "and upper(a.opt) like upper('%"+opt1+"%') ";		}
			if(!opt2.equals("")){	query += "and upper(a.opt) like upper('%"+opt2+"%') ";		}
			if(!opt3.equals("")){	query += "and upper(a.opt) like upper('%"+opt3+"%') ";		}
			if(!opt4.equals("")){	query += "and upper(a.opt) like upper('%"+opt4+"%') ";		}
			if(!opt5.equals("")){	query += "and upper(a.opt) like upper('%"+opt5+"%') ";		}
			if(!opt6.equals("")){	query += "and upper(a.opt) like upper('%"+opt6+"%') ";		}
			if(!opt7.equals("")){	query += "and upper(a.opt) like upper('%"+opt7+"%') ";		}
		}
		//사양제외 검색추가(5개까지)(20181112)
		if(!e_opt1.equals("")||!e_opt2.equals("")||!e_opt3.equals("")||!e_opt4.equals("")||!e_opt5.equals("")||!e_opt6.equals("")||!e_opt7.equals("")){
			if(!e_opt1.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt1+"%') ";		}
			if(!e_opt2.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt2+"%') ";		}
			if(!e_opt3.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt3+"%') ";		}
			if(!e_opt4.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt4+"%') ";		}
			if(!e_opt5.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt5+"%') ";		}
			if(!e_opt6.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt6+"%') ";		}
			if(!e_opt7.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt7+"%') ";		}
		}
				
		if(sort.equals("1"))		query += " order by a.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("2"))		query += " order by a.dlv_est_dt, a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("3"))		query += " order by a.com_con_no ";
		if(sort.equals("4"))		query += " order by a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("5"))		query += " order by b.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";	//예약일 추가(20181123)
		if(sort.equals("6"))		query += " order by a.pre_out_yn, b.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";	//예약일 추가(20181123)
				
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
			System.out.println("[CarOffPreDatabase:getDirectCarOffPreList]\n"+e);
			System.out.println("[CarOffPreDatabase:getDirectCarOffPreList]\n"+query);
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
	
	//사전계약관리- 출고예정+본인 차량보기 리스트 (20191114)
	public Vector getDirectCarOffPreList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, 
			String st_dt, String end_dt, String opt1, String opt2, String opt3, String opt4, String opt5, String opt6, String opt7, String e_opt1, 
			String e_opt2, String e_opt3, String e_opt4, String e_opt5, String e_opt6, String e_opt7, String user_nm, String ready_car, String eco_yn, String dept_id, String car_nm2, String car_nm3)
	{								// ^^ 23
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query 		= ""; 
		String r_query 		= "";
		
		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, a.in_col, a.garnish_col, \n"+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, a.reg_dt,  \n"+
				"        b.r_seq, b.reg_id, to_char(b.reg_dt,'YYYYMMDD') as res_reg_dt, b.res_end_dt as res_end_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt,  \n"+
				"        c.dlv_dt, a.req_dt, b.cust_tel, b.memo, b.cust_q, "+ //고객연락처,메모 추가(20181205)
				"		 DECODE(a.use_yn, 'N','취소',DECODE(c.dlv_dt,'',DECODE(a.rent_l_cd, '',DECODE(b.bus_nm, '','대기','예약'),'계약'),'출고')) AS status, \n"+	//진행구분추가(20181119)
				"		 a.pre_out_yn, \n "+	//즉시출고 추가(20190305)
				"		 CASE WHEN a.car_nm LIKE '%블루컬러팩%' OR a.in_col LIKE '%블루컬러팩%' THEN '블루컬러팩'	ELSE '' END  AS blue_col,  \n "+	//블루컬러팩여부 (20190307)
				"		 a.eco_yn, a.agent_view_yn, a.bus_self_yn, a.q_reg_dt, '' as bus_nm2 \n "+	//친환경차여부20191114
				//"        (SELECT bus_nm FROM car_pur_com_pre_res z, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null group by seq) y WHERE z.seq = a.seq AND z.seq = y.seq AND z.cls_dt IS NULL AND z.r_seq != y.r_seq ) AS bus_nm2 \n" + 	// 2순위 예약자명
				"   FROM   car_pur_com_pre a, cont c, \n"+
				"          (select a.* from car_pur_com_pre_res a, (select seq, min(r_seq) r_seq from car_pur_com_pre_res WHERE cls_dt IS NULL group by seq) b where a.cls_dt IS NULL AND a.seq=b.seq AND a.r_seq=b.r_seq) b  \n"+
				"   WHERE  a.seq=b.seq(+) and a.rent_l_cd=c.rent_l_cd(+)\n";
		
		//if(dept_id.equals("1000")) query += "and a.car_off_nm NOT IN ('총신대', '사직', '한강', '총신대역대리점') "; // 에이전트의 경우 현대차 대리점 차량 미표시 2021.08.25.
		
		//출고예정일이 있으면서 진행구분이 대기
		if(ready_car.equals("1"))	query += " AND a.dlv_est_dt IS NOT NULL AND a.use_yn='Y' AND c.dlv_dt IS NULL AND a.rent_l_cd IS NULL AND b.bus_nm IS NULL \n ";
		//출고예정일이 있는 본인 예약/계약 건
		if(ready_car.equals("2"))	query += " AND a.dlv_est_dt IS NOT NULL and a.use_yn='Y' and c.dlv_dt is null and b.bus_nm = '"+user_nm+"' \n ";
		//출고예정일이 없는 본인 예약/계약 건
		if(ready_car.equals("3"))	query += " AND a.dlv_est_dt IS NULL and a.use_yn='Y' and c.dlv_dt is null and b.bus_nm = '"+user_nm+"' \n ";
		//출고예정일이 있는 타인 예약/계약 건
		if(ready_car.equals("4"))	query += " AND a.dlv_est_dt IS NOT NULL and a.use_yn='Y' and c.dlv_dt is null and b.bus_nm NOT IN('"+user_nm+"') \n ";
		
		if(!gubun3.equals(""))		query += " and a.car_off_nm='"+gubun3+"' \n";
		if(!gubun4.equals(""))		query += " and upper(a.car_nm) like upper('%"+gubun4+"%') \n";
		if(!car_nm2.equals(""))		query += " and upper(a.car_nm) like upper('%"+car_nm2+"%') \n";
		if(!car_nm3.equals(""))		query += " and upper(a.car_nm) like upper('%"+car_nm3+"%') \n";
				
		if (!eco_yn.equals("")) {
			query += " AND a.ECO_YN='"+eco_yn+"' \n";
		}
		
		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		if(gubun1.equals("1")){
			dt1 = "to_char(a.reg_dt,'YYYYMM')";
			dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
		}else if(gubun1.equals("2")){
			dt1 = "substr(a.dlv_est_dt,1,6)";
			dt2 = "a.dlv_est_dt";
		}else if(gubun1.equals("3")){
			dt1 = "substr(a.cls_dt,1,6)";
			dt2 = "a.cls_dt";
		}else if(gubun1.equals("4")){
			dt1 = "to_char(a.req_dt,'YYYYMM')";
			dt2 = "to_char(a.req_dt,'YYYYMMDD')";
		}else if(gubun1.equals("5")){	//예약일 추가(20181123)
			dt1 = "to_char(b.reg_dt,'YYYYMM')";
			dt2 = "to_char(b.reg_dt,'YYYYMMDD')";
		}
		
		//당일
		if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		//전일
		else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
		//당월
		else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		//기간
		else if(gubun2.equals("4")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		
		if(s_kd.equals("1"))	what = "upper(a.com_con_no)";	
		if(s_kd.equals("2"))	what = "a.opt";	
		if(s_kd.equals("3"))	what = "a.colo||a.in_col||a.garnish_col";		
		if(s_kd.equals("4"))	what = "b.bus_nm";	
		if(s_kd.equals("5"))	what = "b.firm_nm";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){	query += " and "+what+" like upper('%"+t_wd+"%') ";		}
			else{					query += " and "+what+" like '%"+t_wd+"%' ";			}	
		}
		
		//사양은 키워드 5개까지 검색되게(20181108)
		if(!opt1.equals("")||!opt2.equals("")||!opt3.equals("")||!opt4.equals("")||!opt5.equals("")||!opt6.equals("")||!opt7.equals("")){
			if(!opt1.equals("")){	query += "and upper(a.opt) like upper('%"+opt1+"%') ";		}
			if(!opt2.equals("")){	query += "and upper(a.opt) like upper('%"+opt2+"%') ";		}
			if(!opt3.equals("")){	query += "and upper(a.opt) like upper('%"+opt3+"%') ";		}
			if(!opt4.equals("")){	query += "and upper(a.opt) like upper('%"+opt4+"%') ";		}
			if(!opt5.equals("")){	query += "and upper(a.opt) like upper('%"+opt5+"%') ";		}
			if(!opt6.equals("")){	query += "and upper(a.opt) like upper('%"+opt6+"%') ";		}
			if(!opt7.equals("")){	query += "and upper(a.opt) like upper('%"+opt7+"%') ";		}
		}
		//사양제외 검색추가(5개까지)(20181112)
		if(!e_opt1.equals("")||!e_opt2.equals("")||!e_opt3.equals("")||!e_opt4.equals("")||!e_opt5.equals("")||!e_opt6.equals("")||!e_opt7.equals("")){
			if(!e_opt1.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt1+"%') ";		}
			if(!e_opt2.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt2+"%') ";		}
			if(!e_opt3.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt3+"%') ";		}
			if(!e_opt4.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt4+"%') ";		}
			if(!e_opt5.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt5+"%') ";		}
			if(!e_opt6.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt6+"%') ";		}
			if(!e_opt7.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt7+"%') ";		}
		}

		if(sort.equals("1"))		query += " order by a.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("2"))		query += " order by a.dlv_est_dt, a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("3"))		query += " order by a.com_con_no ";
		if(sort.equals("4"))		query += " order by a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("5"))		query += " order by b.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";	//예약일 추가(20181123)
		if(sort.equals("6"))		query += " order by a.pre_out_yn, b.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";	//예약일 추가(20181123)
		
		
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
			System.out.println("[CarOffPreDatabase:getDirectCarOffPreList]\n"+e);
			System.out.println("[CarOffPreDatabase:getDirectCarOffPreList]\n"+query);
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
	
	//사전계약관리 - 출고예정+본인 차량보기 20220701 - 에이전트
	public Vector getDirectReadyCarOffPreList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, 
			String st_dt, String end_dt, String opt1, String opt2, String opt3, String opt4, String opt5, String opt6, String opt7, String e_opt1, 
			String e_opt2, String e_opt3, String e_opt4, String e_opt5, String e_opt6, String e_opt7, String user_nm, String ready_car, String eco_yn, String dept_id, String car_nm2, String car_nm3)
	{								// ^^ 23
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT case when '"+ready_car+"'='Y' and a.dlv_est_dt IS NOT NULL AND a.rent_l_cd IS NULL AND b.bus_nm IS NULL then 1 \n"+      //출고예정일이 있으면서 진행구분이 대기
				"             when '"+ready_car+"'='Y' and a.dlv_est_dt IS NOT NULL and b.bus_nm = '"+user_nm+"' then 2 \n"+                      //출고예정일이 있는 본인 예약/계약 건
				"             when '"+ready_car+"'='Y' and a.dlv_est_dt IS NULL and b.bus_nm = '"+user_nm+"' then 3 else 4 end st, \n"+   //출고예정일이 없는 본인 예약/계약 건
				"        a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, a.in_col, a.garnish_col, \n"+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, a.reg_dt,  \n"+
				"        b.r_seq, b.reg_id, to_char(b.reg_dt,'YYYYMMDD') as res_reg_dt, b.res_end_dt as res_end_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt as res_cls_dt,  \n"+
				"        c.dlv_dt, a.req_dt, b.cust_tel, b.memo, b.cust_q, "+
				"		 DECODE(a.use_yn, 'N','취소',DECODE(c.dlv_dt,'',DECODE(a.rent_l_cd, '',DECODE(b.bus_nm, '','대기','예약'),'계약'),'출고')) AS status, \n"+
				"		 a.pre_out_yn, \n "+
				"		 CASE WHEN a.car_nm LIKE '%블루컬러팩%' OR a.in_col LIKE '%블루컬러팩%' THEN '블루컬러팩'	ELSE '' END  AS blue_col,  \n "+
				"		 a.eco_yn, a.agent_view_yn, a.bus_self_yn, a.q_reg_dt, '' as bus_nm2  \n "+
				//"        (SELECT bus_nm FROM car_pur_com_pre_res z, (select seq, min(r_seq) r_seq from car_pur_com_pre_res where cls_dt is null group by seq) y WHERE z.seq = a.seq AND z.seq = y.seq AND z.cls_dt IS NULL AND z.r_seq != y.r_seq ) AS bus_nm2 \n" +
				" FROM   car_pur_com_pre a, cont c, \n"+
				"        (select a.* from car_pur_com_pre_res a, (select seq, min(r_seq) r_seq from car_pur_com_pre_res WHERE cls_dt IS NULL group by seq) b where a.cls_dt IS NULL AND a.seq=b.seq AND a.r_seq=b.r_seq) b \n"+
				" WHERE  a.use_yn='Y' and a.agent_view_yn='Y' \n"+ //유효건, 에이전트보기분
				"        AND a.seq=b.seq(+) and a.rent_l_cd=c.rent_l_cd(+) AND c.dlv_dt IS NULL \n"+
				" ";
		
		if(ready_car.equals("Y")) 	query += " and (b.bus_nm='"+user_nm+"' or (a.dlv_est_dt IS NOT NULL AND a.rent_l_cd IS NULL AND b.bus_nm IS NULL) )";

		if(gubun5.equals("Y"))		query += " and c.dlv_dt is null \n";
		if(gubun5.equals("Y1"))		query += " and c.dlv_dt is null and a.rent_l_cd is not null  \n"; //진행-계약
		if(gubun5.equals("Y2"))		query += " and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is null \n"; //대기
		if(gubun5.equals("Y3"))		query += " and c.dlv_dt is null and a.rent_l_cd is null and b.bus_nm is not null \n"; //예약
		if(gubun5.equals("Y4"))		query += " and a.pre_out_yn='Y' \n"; //즉시출고 추가(20190305)
		if(gubun5.equals("P"))		query += " and c.dlv_dt is not null \n";
		
		if(dept_id.equals("1000")) 	query += " and a.car_off_nm NOT IN ('총신대', '사직', '한강', '총신대역대리점') "; // 에이전트의 경우 현대차 대리점 차량 미표시 2021.08.25.
		if(dept_id.equals("1000")) 	query += " and a.q_reg_dt is null "; // Q 상태에서는 안보임
		
		if(!gubun3.equals(""))		query += " and a.car_off_nm='"+gubun3+"' \n";
		if(!gubun4.equals(""))		query += " and upper(a.car_nm) like upper('%"+gubun4+"%') \n";
		if(!car_nm2.equals(""))		query += " and upper(a.car_nm) like upper('%"+car_nm2+"%') \n";
		if(!car_nm3.equals(""))		query += " and upper(a.car_nm) like upper('%"+car_nm3+"%') \n";
				
		if (!eco_yn.equals("")) {
			query += " AND a.ECO_YN='"+eco_yn+"' \n";
		}

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		if(gubun1.equals("1")){
			dt1 = "to_char(a.reg_dt,'YYYYMM')";
			dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
		}else if(gubun1.equals("2")){
			dt1 = "substr(a.dlv_est_dt,1,6)";
			dt2 = "a.dlv_est_dt";
		}else if(gubun1.equals("3")){
			dt1 = "substr(a.cls_dt,1,6)";
			dt2 = "a.cls_dt";
		}else if(gubun1.equals("4")){
			dt1 = "to_char(a.req_dt,'YYYYMM')";
			dt2 = "to_char(a.req_dt,'YYYYMMDD')";
		}else if(gubun1.equals("5")){	//예약일 추가(20181123)
			dt1 = "to_char(b.reg_dt,'YYYYMM')";
			dt2 = "to_char(b.reg_dt,'YYYYMMDD')";
		}
		
		//당일
		if(gubun2.equals("1"))				query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		//전일
		else if(gubun2.equals("2"))			query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";		
		//당월
		else if(gubun2.equals("3"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		//기간
		else if(gubun2.equals("4")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		
		if(s_kd.equals("1"))	what = "upper(a.com_con_no)";	
		if(s_kd.equals("2"))	what = "a.opt";	
		if(s_kd.equals("3"))	what = "a.colo||a.in_col||a.garnish_col";		
		if(s_kd.equals("4"))	what = "b.bus_nm";	
		if(s_kd.equals("5"))	what = "b.firm_nm";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){	query += " and "+what+" like upper('%"+t_wd+"%') ";		}
			else{					query += " and "+what+" like '%"+t_wd+"%' ";			}	
		}
		
		//사양은 키워드 5개까지 검색되게(20181108)
		if(!opt1.equals("")||!opt2.equals("")||!opt3.equals("")||!opt4.equals("")||!opt5.equals("")||!opt6.equals("")||!opt7.equals("")){
			if(!opt1.equals("")){	query += "and upper(a.opt) like upper('%"+opt1+"%') ";		}
			if(!opt2.equals("")){	query += "and upper(a.opt) like upper('%"+opt2+"%') ";		}
			if(!opt3.equals("")){	query += "and upper(a.opt) like upper('%"+opt3+"%') ";		}
			if(!opt4.equals("")){	query += "and upper(a.opt) like upper('%"+opt4+"%') ";		}
			if(!opt5.equals("")){	query += "and upper(a.opt) like upper('%"+opt5+"%') ";		}
			if(!opt6.equals("")){	query += "and upper(a.opt) like upper('%"+opt6+"%') ";		}
			if(!opt7.equals("")){	query += "and upper(a.opt) like upper('%"+opt7+"%') ";		}
		}
		//사양제외 검색추가(5개까지)(20181112)
		if(!e_opt1.equals("")||!e_opt2.equals("")||!e_opt3.equals("")||!e_opt4.equals("")||!e_opt5.equals("")||!e_opt6.equals("")||!e_opt7.equals("")){
			if(!e_opt1.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt1+"%') ";		}
			if(!e_opt2.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt2+"%') ";		}
			if(!e_opt3.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt3+"%') ";		}
			if(!e_opt4.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt4+"%') ";		}
			if(!e_opt5.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt5+"%') ";		}
			if(!e_opt6.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt6+"%') ";		}
			if(!e_opt7.equals("")){	query += "and upper(a.opt) not like upper('%"+e_opt7+"%') ";		}
		}
		
		if(sort.equals("1"))		query += " order by 1, a.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("2"))		query += " order by 1, a.dlv_est_dt, a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("3"))		query += " order by 1, a.com_con_no ";
		if(sort.equals("4"))		query += " order by 1, a.req_dt, a.car_off_nm, a.com_con_no, a.car_nm ";
		if(sort.equals("5"))		query += " order by 1, b.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";	//예약일 추가(20181123)
		if(sort.equals("6"))		query += " order by 1, a.pre_out_yn, b.reg_dt, a.car_off_nm, a.com_con_no, a.car_nm ";	//예약일 추가(20181123)
		
		
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
			System.out.println("[CarOffPreDatabase:getDirectReadyCarOffPreList]\n"+e);
			System.out.println("[CarOffPreDatabase:getDirectReadyCarOffPreList]\n"+query);
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

	public Vector getCarOffPreSeqResList(String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.r_seq, b.reg_id, to_char(b.reg_dt, 'yyyy-mm-dd hh24:mi:ss') reg_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt, b.cust_tel, b.memo, \n"+
				"        b.res_st_dt, b.res_end_dt, b.add_cnt, b.confirm_dt, b.bus_tel, a.user_nm, a.dept_id, b.cust_q, b.res_st_date, b.res_end_date, b.etc \n"+
				" FROM   car_pur_com_pre_res b, users a  \n"+
				" WHERE  b.seq="+seq+" and b.reg_id=a.user_id(+) order by b.r_seq \n";

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
			System.out.println("[CarOffPreDatabase:getCarOffPreSeqResList]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreSeqResList]\n"+query);
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
	
	public Vector getCarOffPreSeqResUseList(String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.r_seq, b.reg_id, to_char(b.reg_dt, 'yyyy-mm-dd hh24:mi:ss') reg_dt, b.bus_nm, b.firm_nm, b.addr, b.cls_dt, b.cust_tel, b.memo, \n"+
				"        b.res_st_dt, b.res_end_dt, b.add_cnt, b.confirm_dt, b.bus_tel, a.user_nm, a.dept_id, b.cust_q, b.res_st_date, b.res_end_date \n"+
				" FROM   car_pur_com_pre_res b, users a  \n"+
				" WHERE  b.seq="+seq+" and b.cls_dt is null and b.reg_id=a.user_id(+) order by b.r_seq \n";

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
			System.out.println("[CarOffPreDatabase:getCarOffPreSeqResList]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreSeqResList]\n"+query);
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

	public Vector getSearchCont(String car_off_nm, String com_con_no, String car_nm, String bus_nm, String firm_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_l_cd, a.rent_dt, i.car_off_nm, f.rpt_no, e.car_nm, d.car_name, c.opt, c.colo, c.in_col, c.garnish_col, j.user_nm, b.firm_nm, a.reg_step  \n"+
				" FROM   cont a, client b, car_etc c, car_nm d, car_mng e, car_pur f, commi g, car_off_emp h, car_off i, users j \n"+
				" WHERE  nvl(a.use_yn,'Y')='Y' and a.dlv_dt is null and a.client_id=b.client_id \n"+ 
				"        AND a.rent_mng_id=c.RENT_mng_id AND a.rent_l_cd=c.rent_l_cd \n"+
				"        AND c.car_id=d.car_id AND c.car_seq=d.car_seq \n"+
				"        AND d.car_comp_id=e.car_comp_id AND d.car_cd=e.code \n"+
				"        AND a.rent_mng_id=f.rent_mng_id AND a.RENT_L_CD=f.rent_l_cd \n"+
				"        AND a.rent_mng_id=g.rent_mng_id AND a.RENT_L_CD=g.rent_l_cd AND g.agnt_st='2' \n"+ 
				"        AND g.emp_id=h.emp_id AND h.car_off_id=i.CAR_OFF_id \n"+
				"        AND a.BUS_ID=j.user_id \n"+
				" ";

		if(!car_off_nm.equals(""))	query += " AND i.car_off_nm like '%"+car_off_nm+"%' ";
        if(!com_con_no.equals(""))	query += " AND f.rpt_no LIKE '%"+com_con_no+"%' ";
        if(!car_nm.equals(""))		query += " AND replace(e.car_nm||d.car_name,' ','') LIKE '%'||replace('"+car_nm+"',' ','')||'%' ";
        if(!bus_nm.equals(""))		query += " AND j.user_nm LIKE '%"+bus_nm+"%' ";
        if(!firm_nm.equals(""))		query += " AND b.firm_nm LIKE '%"+firm_nm+"%' ";

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
			System.out.println("[CarOffPreDatabase:getSearchCont]\n"+e);
			System.out.println("[CarOffPreDatabase:getSearchCont]\n"+query);
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

	public Vector getSearchSucCont(String rent_l_cd, String car_off_nm, String car_nm, String opt, String colo, String bus_nm, String firm_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_mng_id, a.rent_l_cd, a.rent_dt, i.car_off_nm, f.rpt_no, e.car_nm, d.car_name, c.opt, c.colo, c.in_col, c.garnish_col, j.user_nm, b.firm_nm  \n"+
				" FROM   cont a, client b, car_etc c, car_nm d, car_mng e, car_pur f, commi g, car_off_emp h, car_off i, users j, (select * from car_pur_com where nvl(use_yn,'Y')<>'N') k \n"+
				" WHERE  a.rent_l_cd<>'"+rent_l_cd+"' and nvl(a.use_yn,'Y')='Y' and a.dlv_dt is null and a.client_id=b.client_id \n"+ 
				"        AND a.rent_mng_id=c.RENT_mng_id AND a.rent_l_cd=c.rent_l_cd \n"+
				"        AND c.car_id=d.car_id AND c.car_seq=d.car_seq \n"+
				"        AND d.car_comp_id=e.car_comp_id AND d.car_cd=e.code \n"+
				"        AND a.rent_mng_id=f.rent_mng_id AND a.RENT_L_CD=f.rent_l_cd \n"+
				"        AND a.rent_mng_id=g.rent_mng_id AND a.RENT_L_CD=g.rent_l_cd AND g.agnt_st='2' \n"+ 
				"        AND g.emp_id=h.emp_id AND h.car_off_id=i.CAR_OFF_id \n"+
				"        AND a.BUS_ID=j.user_id \n"+
				"        AND a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+) and k.rent_l_cd is null \n"+
				" ";

		if(!car_off_nm.equals(""))	query += " AND i.car_off_nm like '%"+car_off_nm+"%' ";
        if(!car_nm.equals(""))		query += " AND replace(e.car_nm||d.car_name,' ','') LIKE '%'||replace('"+car_nm+"',' ','')||'%' ";
        if(!opt.equals(""))			query += " AND replace(c.opt,' ','') LIKE '%'||replace('"+opt+"',' ','')||'%' ";
        if(!colo.equals(""))		query += " AND replace(c.colo||'/'||c.in_col||'/'||c.garnish_col,' ','') LIKE '%'||replace('"+colo+"',' ','')||'%' ";
        if(!bus_nm.equals(""))		query += " AND j.user_nm LIKE '%"+bus_nm+"%' ";
        if(!firm_nm.equals(""))		query += " AND b.firm_nm LIKE '%"+firm_nm+"%' ";

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
		//	System.out.println("[CarOffPreDatabase:getSearchCont]\n"+query);
		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:getSearchCont]\n"+e);
			System.out.println("[CarOffPreDatabase:getSearchCont]\n"+query);
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

	//즉시출고 여부 업데이트(20190305)
	public boolean updatePreOutYn(CarOffPreBean bean){
		
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;

		query = " UPDATE car_pur_com_pre SET pre_out_yn=? "+
				"  WHERE seq=?";
		try{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	bean.getPre_out_yn()	);
			pstmt.setInt	(2, bean.getSeq()			);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updatePreOutYn]\n"+e);
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

	public boolean updateCarOffPreRevive(int seq)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE car_pur_com_pre SET cls_dt	= '', use_yn='Y' WHERE seq=?";
					
		try 
		{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.setInt 	(1,		seq		);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updateCarOffPreRevive]\n"+e);
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

	//자체출고에서 사전계약연동 확인	
	public CarOffPreBean getCarOffPreRent(String rent_l_cd)
	{
		getConnection();

		CarOffPreBean bean = new CarOffPreBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, "+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.rent_l_cd, a.con_bank, a.con_acc_no, a.con_acc_nm, a.con_est_dt, a.trf_st0, a.acc_st0  "+
				" FROM   car_pur_com_pre a "+
				" WHERE  a.use_yn='Y' AND a.rent_l_cd=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_l_cd);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setSeq				(rs.getInt(1));
				bean.setCar_off_nm		(rs.getString(2));
				bean.setCom_con_no		(rs.getString(3));
				bean.setCar_nm			(rs.getString(4));
				bean.setOpt				(rs.getString(5));
				bean.setColo			(rs.getString(6));
				bean.setCar_amt			(rs.getInt(7));	
				bean.setCon_amt			(rs.getInt(8));	
				bean.setCon_pay_dt		(rs.getString(9));
				bean.setDlv_est_dt		(rs.getString(10));
				bean.setEtc				(rs.getString(11));
				bean.setRent_l_cd		(rs.getString(12));
				bean.setCon_bank		(rs.getString(13));
				bean.setCon_acc_no		(rs.getString(14));
				bean.setCon_acc_nm		(rs.getString(15));
				bean.setCon_est_dt		(rs.getString(16));
				bean.setTrf_st0			(rs.getString(17));
				bean.setAcc_st0			(rs.getString(18));
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:getCarOffPreRent]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreRent]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}	

	//전기차충전기신청건 등록   
	public boolean insertRegEcarCharger(EcarChargerBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int r_seq = 0;		
			
		query= " INSERT INTO ecar_charger "+
					" (rent_l_cd, rent_mng_id, client_id, car_mng_id, reg_id, reg_dt, chg_type, inst_off, inst_zip, inst_loc, pay_way, chg_prop, subsi_form_yn, doc_yn, use_yn, etc_inst_off) VALUES"+
					" ( ?, ?, ?, ?, ?, sysdate, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,	bean.getRent_l_cd			()	);
			pstmt.setString	(2,	bean.getRent_mng_id		()	);
			pstmt.setString (3,	bean.getClient_id				()	);
			pstmt.setString (4,	bean.getCar_mng_id			()	);
			pstmt.setString (5,	bean.getReg_id					()	);
			pstmt.setString	(6,	bean.getChg_type				()	);
			pstmt.setString (7,	bean.getInst_off				()	);
			pstmt.setString	(8,	bean.getInst_zip				()	);
			pstmt.setString	(9,	bean.getInst_loc				()	);
			pstmt.setString	(10,	bean.getPay_way				()	);
			pstmt.setString	(11,	bean.getChg_prop			()	);
			pstmt.setString	(12,	bean.getSubsi_form_yn		()	);
			pstmt.setString	(13,	bean.getDoc_yn				()	);
			pstmt.setString	(14,	bean.getUse_yn				()	);
			pstmt.setString	(15,	bean.getEtc_inst_off			()	);
			
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:insertRegEcarCharger]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs != null)	rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	//전기차 충전기 신청 리스트(02190429)
	public Vector getRegEcarChargerList(String s_kd, String t_wd, String sort, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT a.*, b.firm_nm, c.user_nm as acar_nm, d.car_no, d.car_num, d.car_nm,  \n"+
					 "				DECODE(a.subsi_form_yn,'Y',DECODE(a.doc_yn,'Y','완료','처리중'),'처리중') AS stat  \n"+
					 "    FROM ecar_charger a, client b, users c, car_reg d  \n"+
					 "    WHERE a.client_id = b.client_id  \n"+
					 "         AND a.reg_id = c.user_id "+ 
					 "		   AND a.car_mng_id = d.car_mng_id(+) \n"+
					 "		   AND a.use_yn = 'Y' \n"+
					 "";
		if(!t_wd.equals("")){
			if(s_kd.equals("1")){			query += "	AND b.firm_nm like '%"+t_wd+"%'";						}	//상호
			else if(s_kd.equals("2")){	query += "	AND d.car_no like '%"+t_wd+"%'";							}	//차량번호
			else if(s_kd.equals("3")){	query += "	AND d.car_nm like '%"+t_wd+"%'";							}	//차명
			else if(s_kd.equals("4")){	query += "	AND a.etc_inst_off like UPPER('%"+t_wd+"%')";		}	//설치업체
		}
		
		if(!gubun1.equals("")){
			if(gubun1.equals("1")){			query += "	AND a.chg_type = '1'	";		}	//이동형
			else if(gubun1.equals("2")){	query += "	AND a.chg_type = '2'	";		}	//고정형
		}
		
		if(!gubun2.equals("")){		
			if(gubun2.equals("1")){			query += "	AND ( a.subsi_form_yn IS NULL OR a.doc_yn IS NULL )	";				}	//처리중
			else if(gubun2.equals("2")){	query += "	AND ( a.subsi_form_yn = 'Y' AND a.doc_yn = 'Y' )	";						}	//완료
		}
		
		if(!user_id.equals("")){		query += "	AND a.reg_id = '"+user_id+"'";			}	
		
		if(sort.equals("1")){				query += " ORDER BY DECODE(a.subsi_form_yn,'',DECODE(a.doc_yn,'','1','Y','2'),'Y',DECODE(a.doc_yn,'','3','Y','4')), a.reg_dt desc";		}
		else if(sort.equals("2")){		query += " ORDER BY a.reg_dt desc";			}
		
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:getRegEcarChargerList]\n"+e);
			System.out.println("[CarOffPreDatabase:getRegEcarChargerList]\n"+query);
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
	
	//전기차 충전기 신청 1건(02190429)
	public EcarChargerBean getEcarChargerOne(String rent_l_cd, String rent_mng_id)
	{
		getConnection();

		EcarChargerBean bean = new EcarChargerBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT RENT_L_CD, RENT_MNG_ID, CLIENT_ID, CAR_MNG_ID, REG_ID, REG_DT, CHG_TYPE, INST_OFF, INST_ZIP, \n"+
				  	 "				INST_LOC, PAY_WAY, CHG_PROP, SUBSI_FORM_YN, DOC_YN, USE_YN, ETC_INST_OFF \n"+
				  	 "	  FROM ECAR_CHARGER WHERE RENT_L_CD = '"+rent_l_cd+"' AND USE_YN = 'Y' \n";
		if(!rent_mng_id.equals("")){		query +=	" AND RENT_MNG_ID = '"+rent_mng_id+"'";				}

		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setRent_l_cd			(rs.getString(1));				
				bean.setRent_mng_id		(rs.getString(2));
				bean.setClient_id				(rs.getString(3));
				bean.setCar_mng_id			(rs.getString(4));
				bean.setReg_id					(rs.getString(5));
				bean.setReg_dt					(rs.getString(6));
				bean.setChg_type				(rs.getString(7));	
				bean.setInst_off				(rs.getString(8));	
				bean.setInst_zip				(rs.getString(9));
				bean.setInst_loc				(rs.getString(10));
				bean.setPay_way				(rs.getString(11));
				bean.setChg_prop				(rs.getString(12));
				bean.setSubsi_form_yn		(rs.getString(13));
				bean.setDoc_yn				(rs.getString(14));
				bean.setUse_yn				(rs.getString(15));				
				bean.setEtc_inst_off			(rs.getString(16));
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:getEcarChargerOne]\n"+e);
			System.out.println("[CarOffPreDatabase:getEcarChargerOne]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}
	
	//전기차충전기 신청건 1건 수정
	public boolean updateEcarChargerBean(EcarChargerBean bean)
	{
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE ECAR_CHARGER SET chg_type	= ?, inst_off=?, inst_zip=?, inst_loc=?, pay_way=?, chg_prop=?, etc_inst_off=?  WHERE rent_l_cd=? and rent_mng_id=? and use_yn = 'Y' ";
					
		try{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.setString 	(1,		bean.getChg_type()			);
			pstmt.setString 	(2,		bean.getInst_off()				);
			pstmt.setString 	(3,		bean.getInst_zip()			);
			pstmt.setString 	(4,		bean.getInst_loc()			);
			pstmt.setString 	(5,		bean.getPay_way()			);
			pstmt.setString 	(6,		bean.getChg_prop()			);
			pstmt.setString 	(7,		bean.getEtc_inst_off()		);
			pstmt.setString 	(8,		bean.getRent_l_cd()			);
			pstmt.setString 	(9,		bean.getRent_mng_id()	);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updateEcarChargerBean()]\n"+e);
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
	
	//전기차 충전기 신청내역 삭제
	public boolean deleteEcarChargerOne(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE ECAR_CHARGER SET USE_YN = 'D' WHERE RENT_L_CD = '"+rent_l_cd+"' AND USE_YN = 'Y' ";
					
		try 
		{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:deleteEcarChargerOne(]\n"+e);
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
	
	//전기차 충전기 신청 보조금신청서, 완료서류 수정
	public boolean updateEcarChargerDocYn(String rent_l_cd, String subsi_form_yn, String doc_yn)
	{
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
			
		query = " UPDATE ECAR_CHARGER SET SUBSI_FORM_YN='"+subsi_form_yn+"', DOC_YN='"+doc_yn+"' WHERE RENT_L_CD = '"+rent_l_cd+"' AND USE_YN = 'Y' ";
					
		try 
		{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updateEcarChargerDocYn()]\n"+e);
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
	
	//사전계약 취소 복구(진행중으로) (20190923)
	public boolean updateCarOffPreClsRestore(int seq){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		boolean flag = true;
		
		query = " UPDATE car_pur_com_pre SET cls_dt	= '', use_yn='Y' WHERE seq=?";
					
		try{
			conn.setAutoCommit(false);				
			pstmt = conn.prepareStatement(query);
			pstmt.setInt 	(1,		seq		);
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();			
	  	} catch (Exception e) {
			System.out.println("[CarOffPreDatabase:updateCarOffPreClsRestore]\n"+e);
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
	
	//차종코드, 차명, 차종 가져오기 -  계약4단계등록시 사전계약관리 담당자에게 메세지 발송할 차종을 fetch (20190927)
	public Vector getCarInfoForMsg(String jg_codes){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " SELECT DISTINCT a.car_nm, c.jg_code   \n"+
					 "	  FROM car_mng a, code b, car_nm c  \n"+
					 "    WHERE  a.car_comp_id=c.car_comp_id and a.code=c.car_cd  \n"+
					 "			AND a.car_comp_id=b.code and b.c_st = '0001'  \n"+
					 "         AND c.jg_code IN (" + jg_codes + ") \n"+
					 "			ORDER BY c.jg_code, a.car_nm ASC  ";
		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:getCarInfoForMsg]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarInfoForMsg]\n"+query);
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
	
	public CarOffPreBean getCarOffPreCont(String rent_l_cd)
	{
		getConnection();

		CarOffPreBean bean = new CarOffPreBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.seq, a.car_off_nm, a.com_con_no, a.car_nm, a.opt, a.colo, "+
				"        a.car_amt, a.con_amt, a.con_pay_dt, a.dlv_est_dt, a.etc, a.use_yn, a.cls_dt, a.rent_l_cd, "+
				"        a.in_col, to_char(a.req_dt, 'yyyy-mm-dd hh24:mi:ss') req_dt, "+
				"		 a.pre_out_yn, a.eco_yn, a.garnish_col "+
				" FROM   car_pur_com_pre a "+				
				" WHERE  a.rent_l_cd=? and a.use_yn='Y' ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_l_cd);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setSeq				(rs.getInt(1));
				bean.setCar_off_nm		(rs.getString(2));
				bean.setCom_con_no		(rs.getString(3));
				bean.setCar_nm			(rs.getString(4));
				bean.setOpt				(rs.getString(5));
				bean.setColo			(rs.getString(6));
				bean.setCar_amt			(rs.getInt(7));	
				bean.setCon_amt			(rs.getInt(8));	
				bean.setCon_pay_dt		(rs.getString(9));
				bean.setDlv_est_dt		(rs.getString(10));
				bean.setEtc				(rs.getString(11));
				bean.setUse_yn			(rs.getString(12));
				bean.setCls_dt			(rs.getString(13));
				bean.setRent_l_cd		(rs.getString(14));				
				bean.setIn_col			(rs.getString(15));
				bean.setReq_dt			(rs.getString(16));
				bean.setPre_out_yn		(rs.getString(17));
				bean.setEco_yn			(rs.getString(18));
				bean.setGarnish_col		(rs.getString(19));
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:getCarOffPreCont]\n"+e);
			System.out.println("[CarOffPreDatabase:getCarOffPreCont]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}	
	
	/**
     * 프로시져 호출
     */
	public String call_sp_com_pre_res_dire(String gubun, int seq, int r_seq)
	{
    	getConnection();

    	String query = "{CALL P_COM_PRE_RES_DIRE(?, ?, ?, ?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.setString(1, gubun);
			cstmt.setInt(2, seq);
			cstmt.setInt(3, r_seq);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();

			sResult = cstmt.getString(4); // 결과값

			cstmt.close();


		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:call_sp_sh_res_dire_dtset]\n"+e);
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
     * 프로시져 호출
     */
	public String call_sp_com_pre_pur_auto(String com_con_no)
	{
    	getConnection();

    	String query = "{CALL P_COM_PRE_PUR_AUTO(?, ?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.setString(1, com_con_no);
			cstmt.registerOutParameter( 2, java.sql.Types.VARCHAR );
			cstmt.execute();

			sResult = cstmt.getString(2); // 결과값

			cstmt.close();


		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:call_sp_com_pre_pur_auto]\n"+e);
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
     * 프로시져 호출
     */
	public String call_sp_com_pre_sys_cont(String com_con_no)
	{
    	getConnection();

    	String query = "{CALL P_COM_PRE_SYS_CONT(?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.setString(1, com_con_no);			
			cstmt.execute();
			cstmt.close();


		} catch (SQLException e) {
			System.out.println("[CarOffPreDatabase:call_sp_com_pre_sys_cont]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
}

