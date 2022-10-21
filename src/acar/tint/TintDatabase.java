package acar.tint;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class TintDatabase
{
	private Connection conn = null;
	public static TintDatabase db;
	
	public static TintDatabase getInstance()
	{
		if(TintDatabase.db == null)
			TintDatabase.db = new TintDatabase();
		return TintDatabase.db;
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

	//한건 조회
	public TintBean getTint(String tint_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TintBean bean = new TintBean();
		String query = "";
		query = " select * from tint where tint_no = ?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, tint_no);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setTint_no			(rs.getString("tint_no")		==null?"":rs.getString("tint_no"));
				bean.setTint_st			(rs.getString("tint_st")		==null?"":rs.getString("tint_st"));
	 			bean.setOff_id			(rs.getString("off_id")			==null?"":rs.getString("off_id"));	
	 			bean.setOff_nm			(rs.getString("off_nm")			==null?"":rs.getString("off_nm"));	
				bean.setCar_mng_id		(rs.getString("car_mng_id")		==null?"":rs.getString("car_mng_id"));
				bean.setRent_mng_id		(rs.getString("rent_mng_id")	==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd		(rs.getString("rent_l_cd")		==null?"":rs.getString("rent_l_cd"));
				bean.setClient_id		(rs.getString("client_id")		==null?"":rs.getString("client_id"));
				bean.setCar_no			(rs.getString("car_no")			==null?"":rs.getString("car_no"));	
				bean.setCar_nm			(rs.getString("car_nm")			==null?"":rs.getString("car_nm"));
				bean.setCar_num			(rs.getString("car_num")		==null?"":rs.getString("car_num"));
				bean.setFilm_st			(rs.getString("film_st")		==null?"":rs.getString("film_st"));
				bean.setSun_per			(rs.getInt   ("sun_per"));
				bean.setCleaner_st		(rs.getString("cleaner_st")		==null?"":rs.getString("cleaner_st"));
				bean.setCleaner_add		(rs.getString("cleaner_add")	==null?"":rs.getString("cleaner_add"));
				bean.setNavi_nm			(rs.getString("navi_nm")		==null?"":rs.getString("navi_nm"));
				bean.setNavi_est_amt	(rs.getInt   ("navi_est_amt"));
				bean.setOther			(rs.getString("other")			==null?"":rs.getString("other"));
				bean.setEtc				(rs.getString("etc")			==null?"":rs.getString("etc"));
				bean.setTint_amt		(rs.getInt   ("tint_amt"));
				bean.setCleaner_amt		(rs.getInt   ("cleaner_amt"));
				bean.setNavi_amt		(rs.getInt   ("navi_amt"));
				bean.setOther_amt		(rs.getInt   ("other_amt"));
				bean.setTot_amt			(rs.getInt   ("tot_amt"));
				bean.setSup_est_dt		(rs.getString("sup_est_dt")		==null?"":rs.getString("sup_est_dt"));	
				bean.setSup_dt			(rs.getString("sup_dt")			==null?"":rs.getString("sup_dt"));
				bean.setConf_dt			(rs.getString("conf_dt")		==null?"":rs.getString("conf_dt"));
				bean.setReq_dt			(rs.getString("req_dt")			==null?"":rs.getString("req_dt"));
				bean.setPay_dt			(rs.getString("pay_dt")			==null?"":rs.getString("pay_dt"));
				bean.setReq_code		(rs.getString("req_code")		==null?"":rs.getString("req_code"));	
				bean.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));	
				bean.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));	
				bean.setA_amt			(rs.getInt   ("a_amt"));
				bean.setE_amt			(rs.getInt   ("e_amt"));
				bean.setC_amt			(rs.getInt   ("c_amt"));
				bean.setE_sub_amt1		(rs.getInt   ("e_sub_amt1"));
				bean.setE_sub_amt2		(rs.getInt   ("e_sub_amt2"));
				bean.setC_sub_amt1		(rs.getInt   ("c_sub_amt1"));
				bean.setC_sub_amt2		(rs.getInt   ("c_sub_amt2"));

				bean.setA_tint_amt		(rs.getInt   ("a_tint_amt"));
				bean.setA_cleaner_amt	(rs.getInt   ("a_cleaner_amt"));
				bean.setA_navi_amt		(rs.getInt   ("a_navi_amt"));
				bean.setA_other_amt		(rs.getInt   ("a_other_amt"));
				bean.setE_tint_amt		(rs.getInt   ("e_tint_amt"));
				bean.setE_cleaner_amt	(rs.getInt   ("e_cleaner_amt"));
				bean.setE_navi_amt		(rs.getInt   ("e_navi_amt"));
				bean.setE_other_amt		(rs.getInt   ("e_other_amt"));
				bean.setC_tint_amt		(rs.getInt   ("c_tint_amt"));
				bean.setC_cleaner_amt	(rs.getInt   ("c_cleaner_amt"));
				bean.setC_navi_amt		(rs.getInt   ("c_navi_amt"));
				bean.setC_other_amt		(rs.getInt   ("c_other_amt"));
				bean.setTint_cau		(rs.getString("tint_cau")		==null?"":rs.getString("tint_cau"));
				bean.setBlackbox_yn		(rs.getString("blackbox_yn")	==null?"":rs.getString("blackbox_yn"));
				bean.setBlackbox_nm		(rs.getString("blackbox_nm")	==null?"":rs.getString("blackbox_nm"));
				bean.setBlackbox_amt 	(rs.getInt   ("blackbox_amt"));
				bean.setBlackbox_img	(rs.getString("blackbox_img")	==null?"":rs.getString("blackbox_img"));
				bean.setBlackbox_img2	(rs.getString("blackbox_img2")	==null?"":rs.getString("blackbox_img2"));


			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TintDatabase:getTint(String tint_no)]\n"+e);
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

	//한건 조회
	public TintBean getTint(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TintBean bean = new TintBean();
		String query = "";
		query = " select * from tint where rent_mng_id = ? and rent_l_cd = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setTint_no			(rs.getString("tint_no")		==null?"":rs.getString("tint_no"));
				bean.setTint_st			(rs.getString("tint_st")		==null?"":rs.getString("tint_st"));
	 			bean.setOff_id			(rs.getString("off_id")			==null?"":rs.getString("off_id"));	
	 			bean.setOff_nm			(rs.getString("off_nm")			==null?"":rs.getString("off_nm"));	
				bean.setCar_mng_id		(rs.getString("car_mng_id")		==null?"":rs.getString("car_mng_id"));
				bean.setRent_mng_id		(rs.getString("rent_mng_id")	==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd		(rs.getString("rent_l_cd")		==null?"":rs.getString("rent_l_cd"));
				bean.setClient_id		(rs.getString("client_id")		==null?"":rs.getString("client_id"));
				bean.setCar_no			(rs.getString("car_no")			==null?"":rs.getString("car_no"));	
				bean.setCar_nm			(rs.getString("car_nm")			==null?"":rs.getString("car_nm"));
				bean.setCar_num			(rs.getString("car_num")		==null?"":rs.getString("car_num"));
				bean.setFilm_st			(rs.getString("film_st")		==null?"":rs.getString("film_st"));
				bean.setSun_per			(rs.getInt   ("sun_per"));
				bean.setCleaner_st		(rs.getString("cleaner_st")		==null?"":rs.getString("cleaner_st"));
				bean.setCleaner_add		(rs.getString("cleaner_add")	==null?"":rs.getString("cleaner_add"));
				bean.setNavi_nm			(rs.getString("navi_nm")		==null?"":rs.getString("navi_nm"));
				bean.setNavi_est_amt	(rs.getInt   ("navi_est_amt"));
				bean.setOther			(rs.getString("other")			==null?"":rs.getString("other"));
				bean.setEtc				(rs.getString("etc")			==null?"":rs.getString("etc"));
				bean.setTint_amt		(rs.getInt   ("tint_amt"));
				bean.setCleaner_amt		(rs.getInt   ("cleaner_amt"));
				bean.setNavi_amt		(rs.getInt   ("navi_amt"));
				bean.setOther_amt		(rs.getInt   ("other_amt"));
				bean.setTot_amt			(rs.getInt   ("tot_amt"));
				bean.setSup_est_dt		(rs.getString("sup_est_dt")		==null?"":rs.getString("sup_est_dt"));	
				bean.setSup_dt			(rs.getString("sup_dt")			==null?"":rs.getString("sup_dt"));
				bean.setConf_dt			(rs.getString("conf_dt")		==null?"":rs.getString("conf_dt"));
				bean.setReq_dt			(rs.getString("req_dt")			==null?"":rs.getString("req_dt"));
				bean.setPay_dt			(rs.getString("pay_dt")			==null?"":rs.getString("pay_dt"));
				bean.setReq_code		(rs.getString("req_code")		==null?"":rs.getString("req_code"));	
				bean.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));	
				bean.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));										
				bean.setA_amt			(rs.getInt   ("a_amt"));
				bean.setE_amt			(rs.getInt   ("e_amt"));
				bean.setC_amt			(rs.getInt   ("c_amt"));
				bean.setE_sub_amt1		(rs.getInt   ("e_sub_amt1"));
				bean.setE_sub_amt2		(rs.getInt   ("e_sub_amt2"));
				bean.setC_sub_amt1		(rs.getInt   ("c_sub_amt1"));
				bean.setC_sub_amt2		(rs.getInt   ("c_sub_amt2"));
				bean.setA_tint_amt		(rs.getInt   ("a_tint_amt"));
				bean.setA_cleaner_amt	(rs.getInt   ("a_cleaner_amt"));
				bean.setA_navi_amt		(rs.getInt   ("a_navi_amt"));
				bean.setA_other_amt		(rs.getInt   ("a_other_amt"));
				bean.setE_tint_amt		(rs.getInt   ("e_tint_amt"));
				bean.setE_cleaner_amt	(rs.getInt   ("e_cleaner_amt"));
				bean.setE_navi_amt		(rs.getInt   ("e_navi_amt"));
				bean.setE_other_amt		(rs.getInt   ("e_other_amt"));
				bean.setC_tint_amt		(rs.getInt   ("c_tint_amt"));
				bean.setC_cleaner_amt	(rs.getInt   ("c_cleaner_amt"));
				bean.setC_navi_amt		(rs.getInt   ("c_navi_amt"));
				bean.setC_other_amt		(rs.getInt   ("c_other_amt"));
				bean.setTint_cau		(rs.getString("tint_cau")		==null?"":rs.getString("tint_cau"));
				bean.setBlackbox_yn		(rs.getString("blackbox_yn")	==null?"":rs.getString("blackbox_yn"));
				bean.setBlackbox_nm		(rs.getString("blackbox_nm")	==null?"":rs.getString("blackbox_nm"));
				bean.setBlackbox_amt 	(rs.getInt   ("blackbox_amt"));
				bean.setBlackbox_img	(rs.getString("blackbox_img")	==null?"":rs.getString("blackbox_img"));
				bean.setBlackbox_img2	(rs.getString("blackbox_img2")	==null?"":rs.getString("blackbox_img2"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TintDatabase:getTint(String rent_mng_id, String rent_l_cd)]\n"+e);
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

	//한건 조회
	public TintBean getTint(String rent_mng_id, String rent_l_cd, String tint_cau)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TintBean bean = new TintBean();
		String query = "";
		query = " select * from tint where rent_mng_id = ? and rent_l_cd = ? ";

		if(!tint_cau.equals("")) query += " and tint_cau='"+tint_cau+"'";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setTint_no			(rs.getString("tint_no")		==null?"":rs.getString("tint_no"));
				bean.setTint_st			(rs.getString("tint_st")		==null?"":rs.getString("tint_st"));
	 			bean.setOff_id			(rs.getString("off_id")			==null?"":rs.getString("off_id"));	
	 			bean.setOff_nm			(rs.getString("off_nm")			==null?"":rs.getString("off_nm"));	
				bean.setCar_mng_id		(rs.getString("car_mng_id")		==null?"":rs.getString("car_mng_id"));
				bean.setRent_mng_id		(rs.getString("rent_mng_id")	==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd		(rs.getString("rent_l_cd")		==null?"":rs.getString("rent_l_cd"));
				bean.setClient_id		(rs.getString("client_id")		==null?"":rs.getString("client_id"));
				bean.setCar_no			(rs.getString("car_no")			==null?"":rs.getString("car_no"));	
				bean.setCar_nm			(rs.getString("car_nm")			==null?"":rs.getString("car_nm"));
				bean.setCar_num			(rs.getString("car_num")		==null?"":rs.getString("car_num"));
				bean.setFilm_st			(rs.getString("film_st")		==null?"":rs.getString("film_st"));
				bean.setSun_per			(rs.getInt   ("sun_per"));
				bean.setCleaner_st		(rs.getString("cleaner_st")		==null?"":rs.getString("cleaner_st"));
				bean.setCleaner_add		(rs.getString("cleaner_add")	==null?"":rs.getString("cleaner_add"));
				bean.setNavi_nm			(rs.getString("navi_nm")		==null?"":rs.getString("navi_nm"));
				bean.setNavi_est_amt	(rs.getInt   ("navi_est_amt"));
				bean.setOther			(rs.getString("other")			==null?"":rs.getString("other"));
				bean.setEtc				(rs.getString("etc")			==null?"":rs.getString("etc"));
				bean.setTint_amt		(rs.getInt   ("tint_amt"));
				bean.setCleaner_amt		(rs.getInt   ("cleaner_amt"));
				bean.setNavi_amt		(rs.getInt   ("navi_amt"));
				bean.setOther_amt		(rs.getInt   ("other_amt"));
				bean.setTot_amt			(rs.getInt   ("tot_amt"));
				bean.setSup_est_dt		(rs.getString("sup_est_dt")		==null?"":rs.getString("sup_est_dt"));	
				bean.setSup_dt			(rs.getString("sup_dt")			==null?"":rs.getString("sup_dt"));
				bean.setConf_dt			(rs.getString("conf_dt")		==null?"":rs.getString("conf_dt"));
				bean.setReq_dt			(rs.getString("req_dt")			==null?"":rs.getString("req_dt"));
				bean.setPay_dt			(rs.getString("pay_dt")			==null?"":rs.getString("pay_dt"));
				bean.setReq_code		(rs.getString("req_code")		==null?"":rs.getString("req_code"));	
				bean.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));	
				bean.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));										
				bean.setA_amt			(rs.getInt   ("a_amt"));
				bean.setE_amt			(rs.getInt   ("e_amt"));
				bean.setC_amt			(rs.getInt   ("c_amt"));
				bean.setE_sub_amt1		(rs.getInt   ("e_sub_amt1"));
				bean.setE_sub_amt2		(rs.getInt   ("e_sub_amt2"));
				bean.setC_sub_amt1		(rs.getInt   ("c_sub_amt1"));
				bean.setC_sub_amt2		(rs.getInt   ("c_sub_amt2"));
				bean.setA_tint_amt		(rs.getInt   ("a_tint_amt"));
				bean.setA_cleaner_amt	(rs.getInt   ("a_cleaner_amt"));
				bean.setA_navi_amt		(rs.getInt   ("a_navi_amt"));
				bean.setA_other_amt		(rs.getInt   ("a_other_amt"));
				bean.setE_tint_amt		(rs.getInt   ("e_tint_amt"));
				bean.setE_cleaner_amt	(rs.getInt   ("e_cleaner_amt"));
				bean.setE_navi_amt		(rs.getInt   ("e_navi_amt"));
				bean.setE_other_amt		(rs.getInt   ("e_other_amt"));
				bean.setC_tint_amt		(rs.getInt   ("c_tint_amt"));
				bean.setC_cleaner_amt	(rs.getInt   ("c_cleaner_amt"));
				bean.setC_navi_amt		(rs.getInt   ("c_navi_amt"));
				bean.setC_other_amt		(rs.getInt   ("c_other_amt"));
				bean.setTint_cau		(rs.getString("tint_cau")		==null?"":rs.getString("tint_cau"));
				bean.setBlackbox_yn		(rs.getString("blackbox_yn")	==null?"":rs.getString("blackbox_yn"));
				bean.setBlackbox_nm		(rs.getString("blackbox_nm")	==null?"":rs.getString("blackbox_nm"));
				bean.setBlackbox_amt 	(rs.getInt   ("blackbox_amt"));
				bean.setBlackbox_img	(rs.getString("blackbox_img")	==null?"":rs.getString("blackbox_img"));
				bean.setBlackbox_img2	(rs.getString("blackbox_img2")	==null?"":rs.getString("blackbox_img2"));


			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TintDatabase:getTint(String rent_mng_id, String rent_l_cd)]\n"+e);
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

	public String insertTint(TintBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String tint_no = "";
		String query =  " insert into tint "+
						" ( tint_no, off_id, off_nm, car_mng_id, rent_mng_id, rent_l_cd, client_id, car_no, car_nm, car_num, "+
						"   film_st, sun_per, cleaner_st, cleaner_add, navi_nm, navi_est_amt, other, etc, tint_amt, cleaner_amt, "+
						"   navi_amt, other_amt, tot_amt, sup_est_dt, sup_dt, conf_dt, req_dt, pay_dt, req_code, reg_id, reg_dt, tint_st, tint_cau, "+
			            "   blackbox_yn, blackbox_nm, blackbox_amt, blackbox_img "+
						" ) values "+
						" ( ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?,					"+
						"   ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?,					"+
						"   ?, ?, ?, replace(?,'-',''), replace(?,'-',''),    replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), ?, ?, replace(?,'-',''), ?, ?, "+
				        "   ?, ?, ?, ? "+
						" )";

		String qry_id = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(tint_no,9,4))+1), '0000')), '0001') tint_no"+
						" from tint "+
						" where substr(tint_no,1,8)=to_char(sysdate,'YYYYMMDD')";


		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			if(rs.next())
			{
				tint_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			conn.commit();
		}catch(Exception e){					
	        try{
				System.out.println("[TintDatabase:insertTint]"+e);
	            conn.rollback();
				e.printStackTrace();	
				flag = false;
	        }catch(SQLException _ignored){}
		}finally{
			try{
                if(rs != null )		rs.close();
	            if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
		}

		try
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);
			
			pstmt2.setString(1,  tint_no				  );
			pstmt2.setString(2,  bean.getOff_id			());
			pstmt2.setString(3,  bean.getOff_nm			());
			pstmt2.setString(4,  bean.getCar_mng_id		());
			pstmt2.setString(5,  bean.getRent_mng_id	());
			pstmt2.setString(6,  bean.getRent_l_cd		());
			pstmt2.setString(7,  bean.getClient_id		());
			pstmt2.setString(8,  bean.getCar_no			().trim());
			pstmt2.setString(9,  bean.getCar_nm			());
			pstmt2.setString(10, bean.getCar_num		());
			pstmt2.setString(11, bean.getFilm_st		());
			pstmt2.setInt   (12, bean.getSun_per		());
			pstmt2.setString(13, bean.getCleaner_st		());
			pstmt2.setString(14, bean.getCleaner_add	());
			pstmt2.setString(15, bean.getNavi_nm		());
			pstmt2.setInt   (16, bean.getNavi_est_amt	());
			pstmt2.setString(17, bean.getOther			());
			pstmt2.setString(18, bean.getEtc			());
			pstmt2.setInt   (19, bean.getTint_amt		());
			pstmt2.setInt   (20, bean.getCleaner_amt	());
			pstmt2.setInt   (21, bean.getNavi_amt		());
			pstmt2.setInt   (22, bean.getOther_amt		());
			pstmt2.setInt   (23, bean.getTot_amt		());
			pstmt2.setString(24, bean.getSup_est_dt		());
			pstmt2.setString(25, bean.getSup_dt			());
			pstmt2.setString(26, bean.getConf_dt		());
			pstmt2.setString(27, bean.getReq_dt			());
			pstmt2.setString(28, bean.getPay_dt			());
			pstmt2.setString(29, bean.getReq_code		());
			pstmt2.setString(30, bean.getReg_id			());
			pstmt2.setString(31, bean.getReg_dt			());
			pstmt2.setString(32, bean.getTint_st		());
			pstmt2.setString(33, bean.getTint_cau		());
			pstmt2.setString(34, bean.getBlackbox_yn	());
			pstmt2.setString(35, bean.getBlackbox_nm	());
			pstmt2.setInt   (36, bean.getBlackbox_amt	());
			pstmt2.setString(37, bean.getBlackbox_img	());


			pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:insertTint]\n"+e);
			System.out.println("[ bean.getReg_id		()]\n"+ bean.getReg_id		());
			e.printStackTrace();
	  		flag = false;
			tint_no = "";
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return tint_no;
		}
	}

	public boolean updateTint(TintBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update tint set "+
						"	OFF_ID       	= ?, "+
						"	OFF_NM       	= ?, "+
						"	CAR_MNG_ID   	= ?, "+
						"	RENT_MNG_ID  	= ?, "+
						"	RENT_L_CD    	= ?, "+
						"	CLIENT_ID    	= ?, "+
						"	CAR_NO       	= ?, "+
						"	CAR_NM       	= ?, "+
						"	CAR_NUM      	= replace(?,'-',''), "+
						"	FILM_ST      	= ?, "+
						"	SUN_PER      	= ?, "+
						"	CLEANER_ST   	= ?, "+
						"	CLEANER_ADD  	= ?, "+
						"	NAVI_NM      	= ?, "+
						"	NAVI_EST_AMT 	= ?, "+
						"	OTHER        	= ?, "+
						"	ETC          	= ?, "+
						"	TINT_AMT     	= ?, "+
						"	CLEANER_AMT  	= ?, "+
						"	NAVI_AMT     	= ?, "+
						"	OTHER_AMT    	= ?, "+
						"	TOT_AMT      	= ?, "+
						"	SUP_EST_DT   	= replace(replace(?,' ',''),'-',''), "+
						"	SUP_DT       	= replace(replace(?,' ',''),'-',''), "+
						"	CONF_DT      	= replace(?,'-',''), "+
						"	REQ_DT       	= replace(?,'-',''), "+
						"	PAY_DT       	= replace(?,'-',''), "+
						"	REQ_CODE     	= ?, "+
						"	A_AMT  			= ?, "+
						"	E_AMT  			= ?, "+
						"	C_AMT  			= ?, "+
						"	E_SUB_AMT1		= ?, "+
						"	E_SUB_AMT2		= ?, "+
						"	C_SUB_AMT1		= ?, "+
						"	C_SUB_AMT2		= ?, "+
						"	TINT_ST     	= ?, "+
						"	A_TINT_AMT     	= ?, "+
						"	A_CLEANER_AMT  	= ?, "+
						"	A_NAVI_AMT     	= ?, "+
						"	A_OTHER_AMT    	= ?, "+
						"	E_TINT_AMT     	= ?, "+
						"	E_CLEANER_AMT  	= ?, "+
						"	E_NAVI_AMT     	= ?, "+
						"	E_OTHER_AMT    	= ?, "+
						"	C_TINT_AMT     	= ?, "+
						"	C_CLEANER_AMT  	= ?, "+
						"	C_NAVI_AMT     	= ?, "+
						"	C_OTHER_AMT    	= ?, "+
						"	TINT_CAU     	= ?, "+
			            "   blackbox_yn		= ?, "+
			            "   blackbox_nm		= ?, "+
			            "   blackbox_amt	= ?  "+
						" where tint_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  bean.getOff_id			());
			pstmt.setString(2,  bean.getOff_nm			());
			pstmt.setString(3,  bean.getCar_mng_id		());
			pstmt.setString(4,  bean.getRent_mng_id		());
			pstmt.setString(5,  bean.getRent_l_cd		());
			pstmt.setString(6,  bean.getClient_id		());
			pstmt.setString(7,  bean.getCar_no			());
			pstmt.setString(8,  bean.getCar_nm			());
			pstmt.setString(9,  bean.getCar_num			());
			pstmt.setString(10, bean.getFilm_st			());
			pstmt.setInt   (11, bean.getSun_per			());
			pstmt.setString(12, bean.getCleaner_st		());
			pstmt.setString(13, bean.getCleaner_add		());
			pstmt.setString(14, bean.getNavi_nm			());
			pstmt.setInt   (15, bean.getNavi_est_amt	());
			pstmt.setString(16, bean.getOther			());
			pstmt.setString(17, bean.getEtc				());
			pstmt.setInt   (18, bean.getTint_amt		());
			pstmt.setInt   (19, bean.getCleaner_amt		());
			pstmt.setInt   (20, bean.getNavi_amt		());
			pstmt.setInt   (21, bean.getOther_amt		());
			pstmt.setInt   (22, bean.getTot_amt			());
			pstmt.setString(23, bean.getSup_est_dt		());
			pstmt.setString(24, bean.getSup_dt			());
			pstmt.setString(25, bean.getConf_dt			());
			pstmt.setString(26, bean.getReq_dt			());
			pstmt.setString(27, bean.getPay_dt			());
			pstmt.setString(28, bean.getReq_code		());
			pstmt.setInt   (29, bean.getA_amt			());
			pstmt.setInt   (30, bean.getE_amt			());
			pstmt.setInt   (31, bean.getC_amt			());
			pstmt.setInt   (32, bean.getE_sub_amt1		());
			pstmt.setInt   (33, bean.getE_sub_amt2		());
			pstmt.setInt   (34, bean.getC_sub_amt1		());
			pstmt.setInt   (35, bean.getC_sub_amt2		());
			pstmt.setString(36, bean.getTint_st			());

			pstmt.setInt   (37, bean.getA_tint_amt		());
			pstmt.setInt   (38, bean.getA_cleaner_amt	());
			pstmt.setInt   (39, bean.getA_navi_amt		());
			pstmt.setInt   (40, bean.getA_other_amt		());
			pstmt.setInt   (41, bean.getE_tint_amt		());
			pstmt.setInt   (42, bean.getE_cleaner_amt	());
			pstmt.setInt   (43, bean.getE_navi_amt		());
			pstmt.setInt   (44, bean.getE_other_amt		());
			pstmt.setInt   (45, bean.getC_tint_amt		());
			pstmt.setInt   (46, bean.getC_cleaner_amt	());
			pstmt.setInt   (47, bean.getC_navi_amt		());
			pstmt.setInt   (48, bean.getC_other_amt		());
			pstmt.setString(49, bean.getTint_cau		());

			pstmt.setString(50, bean.getBlackbox_yn		());
			pstmt.setString(51, bean.getBlackbox_nm		());
			pstmt.setInt   (52, bean.getBlackbox_amt	());

			pstmt.setString(53, bean.getTint_no			());

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:updateTint]\n"+e);
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

	//납품관리 리스트 조회
	public Vector getRentTintList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" decode(a.tint_st,'1',b.firm_nm,a.etc) firm_nm, c.user_nm, e.colo, j.dept_id, j.user_nm as reg_nm,"+
				" nvl(a.car_num,f.car_num) car_num2,"+
				" nvl(a.car_nm,h.car_nm) car_nm2,"+
				" nvl(a.car_no,l.car_no) car_no2,"+
				" f.rpt_no, f.dlv_est_dt, e.reg_est_dt, l.init_reg_dt, n.use_yn, decode(a.cleaner_st,'1','있음','2','없음') CLEANER_ST_nm, decode(a.blackbox_yn,'Y','장착','3','배송(광주)','4','배송(대전)','') blackbox_yn_nm, "+
				" a.*, "+
				" decode(f.com_tint,'1','썬팅','2','브랜드키트','') com_tint_nm, "+
				" decode(f.com_film_st,'1','루마','2','모비스','3','SKC','4','3M','') com_film_st_nm, "+
				" decode(a.film_st,'1','일반','2','3M','3','루마','') film_st_nm, "+
				" decode(e.tint_b_yn,'Y','블랙박스')||decode(e.tint_s_yn,'Y','전면썬팅')||decode(e.tint_n_yn,'Y','내비게이션') tint_bsn_yn "+
				" from"+
				" tint a, client b, users c, branch d, car_etc e, car_pur f, car_nm g, car_mng h, "+
				" (select * from doc_settle where doc_st='6') i, users j, branch k, car_reg l, cont n"+
				" where a.client_id=b.client_id(+)"+
				" and a.reg_id=c.user_id(+)"+
				" and c.br_id=d.br_id(+)"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				" and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				" and e.car_id=g.car_id(+) and e.car_seq=g.car_seq(+)"+
				" and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				" and a.tint_no=i.doc_id(+) and i.doc_no is null"+
				" and a.reg_id=j.user_id(+)"+
				" and j.br_id=k.br_id(+)"+
				" and a.car_mng_id=l.car_mng_id(+)"+
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				" and nvl(a.reg_dt,'99999999') > '20080912' "+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}else if(gubun3.equals("3")){
			dt1		= "substr(f.dlv_est_dt,1,6)";
			dt2		= "f.dlv_est_dt";
		}else if(gubun3.equals("4")){
			dt1		= "substr(e.reg_est_dt,1,6)";
			dt2		= "e.reg_est_dt";
		}else{
			dt1		= "substr(a.sup_est_dt,1,6)";
			dt2		= "a.sup_est_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals("") && !gubun1.equals("미지정"))	{
			if(gubun1.equals("스마일탁송")||gubun1.equals("스마일TS")){
				query += " and a.off_id = '010255' ";
			} else {
				query += " and a.off_nm='"+gubun1+"'";
			}
		}

		if(gubun1.equals("미지정"))	query += " and a.off_nm is null ";

		if(s_kd.equals("1"))	what = "upper(nvl(j.br_id||k.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(j.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(nvl(a.car_nm,l.car_nm), ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(nvl(a.car_num,f.car_num), ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(decode(a.tint_st,'1',b.firm_nm,a.etc), ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(a.blackbox_yn, ' '))";	

		if(s_kd.equals("6"))	t_wd = "Y";
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by decode(j.dept_id,'1000',1,2), a.off_nm, decode(j.br_id,'S1',1,'B1',2,'D1',3,'G1',4,'J1',5)";	
		if(sort.equals("2"))	query += " order by decode(j.dept_id,'1000',1,2), a.off_nm, j.user_nm";	
		if(sort.equals("3"))	query += " order by decode(j.dept_id,'1000',1,2), a.off_nm, nvl(a.car_nm,l.car_nm)";	
		if(sort.equals("4"))	query += " order by decode(j.dept_id,'1000',1,2), a.off_nm, nvl(a.car_num,f.car_num)";	
		if(sort.equals("5"))	query += " order by decode(j.dept_id,'1000',1,2), a.off_nm, decode(a.tint_st,'1',b.firm_nm,a.etc)";
		if(sort.equals("6"))	query += " order by decode(j.dept_id,'1000',1,2), a.off_nm, a.reg_dt";	
		if(sort.equals("7"))	query += " order by decode(j.dept_id,'1000',1,2), a.off_nm, a.sup_est_dt";	
		if(sort.equals("8"))	query += " order by decode(j.dept_id,'1000',1,2), a.off_nm, f.dlv_est_dt";	
		if(sort.equals("9"))	query += " order by decode(j.dept_id,'1000',1,2), a.off_nm, e.reg_est_dt";	

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
			System.out.println("[TintDatabase:getRentTintList]\n"+e);
			System.out.println("[TintDatabase:getRentTintList]\n"+query);
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

	//납품관리 차대번호 없는 리스트 조회
	public Vector getTintCarNumNotList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+//차대번호
				" a.tint_no, a.rent_mng_id, a.rent_l_cd, "+
				" b.client_id, b.car_mng_id, c.car_no, c.car_nm, nvl(c.car_num,d.car_num) car_num"+
				" from tint a, cont b, car_reg c, car_pur d"+
				" where"+
				" nvl(a.tint_st,'1')='1' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.car_mng_id=c.car_mng_id(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"+
				" and a.car_num is null and c.car_mng_id is null and d.car_num is not null"+
				" union all"+
				" select"+//차량등록건
				" a.tint_no, a.rent_mng_id, a.rent_l_cd, "+
				" b.client_id, b.car_mng_id, c.car_no, c.car_nm, nvl(c.car_num,d.car_num) car_num"+
				" from tint a, cont b, car_reg c, car_pur d"+
				" where"+
				" nvl(a.tint_st,'1')='1'  and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.car_mng_id=c.car_mng_id"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"+
				" and a.car_mng_id is null and c.car_mng_id is not null"+
				" union all"+
				" select"+//고객
				" a.tint_no, a.rent_mng_id, a.rent_l_cd, "+
				" b.client_id, b.car_mng_id, c.car_no, c.car_nm, nvl(c.car_num,d.car_num) car_num"+
				" from tint a, cont b, car_reg c, car_pur d"+
				" where"+
				" nvl(a.tint_st,'1')='1'  and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.car_mng_id=c.car_mng_id(+)"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"+
				" and a.client_id is null and b.client_id is not null"+
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
			System.out.println("[TintDatabase:getTintCarNumNotList]\n"+e);
			System.out.println("[TintDatabase:getTintCarNumNotList]\n"+query);
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

	public boolean updateTintCarNumNotList(String tint_no, String car_mng_id, String client_id, String car_no, String car_nm, String car_num)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update tint set "+
						" car_mng_id	= ?, "+
						" client_id		= ?, "+
						" car_no		= ?, "+
						" car_nm		= ?, "+
						" car_num		= ?  "+
						" where tint_no = ? ";
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, client_id);
			pstmt.setString(3, car_no);
			pstmt.setString(4, car_nm);
			pstmt.setString(5, car_num);
			pstmt.setString(6, tint_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[TintDatabase:updateTintCarNumNotList]\n"+e);

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

	//납품진형현황 리스트 조회
	public Vector getTintIngList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.rent_dt, a.dlv_dt, a.use_yn, "+
				" c.init_reg_dt, nvl(c.car_no,d.est_car_no) car_no, nvl(c.car_num,d.car_num) car_num, d.dlv_est_dt, d.rpt_no, "+
				" e.firm_nm, f.colo, nvl(j.sun_per,f.sun_per) sun_per, f.reg_est_dt, h.car_nm, "+
				" i.dept_id, i.user_nm as bus_nm, q.br_nm,"+
				" j.tint_st, j.etc, j.reg_id, j.reg_dt, j.tint_no, j.off_id, j.off_nm, decode(j.cleaner_st,'1','기본',j.cleaner_add) cleaner_st, j.navi_nm, j.other, j.sup_est_dt, "+
				" decode(d.com_tint,'1','썬팅','2','브랜드키트','') com_tint_nm, "+
				" decode(d.com_film_st,'1','루마','2','모비스','3','SKC','4','3M','') com_film_st_nm, "+
				" decode(j.film_st,'1','일반','2','3M','3','루마','') film_st_nm, decode(j.cleaner_st,'1','있음','2','없음') CLEANER_ST_nm, decode(j.blackbox_yn,'Y','장착','배송(광주)','4','배송(대전)','') blackbox_yn_nm, j.blackbox_img, j.blackbox_img2, "+
				" decode(f.tint_b_yn,'Y','블랙박스')||decode(f.tint_s_yn,'Y','전면썬팅')||decode(f.tint_n_yn,'Y','내비게이션') tint_bsn_yn "+
				" from tint j, cont a, car_reg c, car_pur d, client e, car_etc f, car_nm g, car_mng h, users i, branch q,"+
				" (select * from doc_settle where doc_st='6') k"+
				" where"+
				" j.rent_mng_id=a.rent_mng_id(+) and j.rent_l_cd=a.rent_l_cd(+)"+
				" and j.car_mng_id=c.car_mng_id(+)"+
				" and j.rent_mng_id=d.rent_mng_id(+) and j.rent_l_cd=d.rent_l_cd(+)"+
				" and j.client_id=e.client_id(+)"+
				" and j.rent_mng_id=f.rent_mng_id(+) and j.rent_l_cd=f.rent_l_cd(+)"+
				" and f.car_id=g.car_id(+) and f.car_seq=g.car_seq(+) and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				" and j.reg_id=i.user_id and i.br_id=q.br_id"+
				" and j.tint_no=k.doc_id and k.doc_bit='2'"+
				" and j.REQ_CODE is null ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(j.reg_dt,1,6)";
			dt2		= "j.reg_dt";
		}else if(gubun3.equals("3")){
			dt1		= "to_char(k.user_dt2,'YYYYMM')";
			dt2		= "to_char(k.user_dt2,'YYYYMMDD')";
		}else if(gubun3.equals("4")){
			dt1		= "substr(c.init_reg_dt,1,6)";
			dt2		= "c.init_reg_dt";
		}else{
			dt1		= "substr(j.sup_est_dt,1,6)";
			dt2		= "j.sup_est_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals(""))	query += " and j.off_nm='"+gubun1+"'";

		if(s_kd.equals("1"))	what = "q.br_id||q.br_nm";	
		if(s_kd.equals("2"))	what = "i.user_nm";	
		if(s_kd.equals("3"))	what = "nvl(j.car_nm,c.car_nm)";	
		if(s_kd.equals("4"))	what = "nvl(j.car_num,c.car_num)";	
		if(s_kd.equals("5"))	what = "decode(j.tint_st,'1',e.firm_nm,j.etc)";
		if(s_kd.equals("6"))	what = "j.blackbox_yn";	
		
		if(s_kd.equals("6"))	t_wd = "Y";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by decode(i.dept_id,'1000',1,2), j.off_nm, decode(q.br_id,'S1',1,'B1',2,'D1',3,'G1',4,'J1',5)";	
		if(sort.equals("2"))	query += " order by decode(i.dept_id,'1000',1,2), j.off_nm, i.user_nm";	
		if(sort.equals("3"))	query += " order by decode(i.dept_id,'1000',1,2), j.off_nm, nvl(j.car_nm,c.car_nm)";	
		if(sort.equals("4"))	query += " order by decode(i.dept_id,'1000',1,2), j.off_nm, nvl(j.car_num,c.car_num)";	
		if(sort.equals("5"))	query += " order by decode(i.dept_id,'1000',1,2), j.off_nm, decode(j.tint_st,'1',e.firm_nm,j.etc)";
		if(sort.equals("6"))	query += " order by decode(i.dept_id,'1000',1,2), j.off_nm, j.reg_dt";	
		if(sort.equals("7"))	query += " order by decode(i.dept_id,'1000',1,2), j.off_nm, j.sup_est_dt";	
		if(sort.equals("8"))	query += " order by decode(i.dept_id,'1000',1,2), j.off_nm, k.user_dt2";	
		if(sort.equals("9"))	query += " order by decode(i.dept_id,'1000',1,2), j.off_nm, c.init_reg_dt";	

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
			System.out.println("[TintDatabase:getTintIngList]\n"+e);
			System.out.println("[TintDatabase:getTintIngList]\n"+query);
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

	//납품마감현황 리스트 조회
	public Vector getTintSettleList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.rent_dt, a.dlv_dt, "+
				" c.init_reg_dt, nvl(c.car_no,d.est_car_no) car_no, nvl(c.car_num,d.car_num) car_num, d.dlv_est_dt, "+
				" e.firm_nm, f.colo, nvl(j.sun_per,f.sun_per) sun_per, f.reg_est_dt, h.car_nm, "+
				" i.user_nm as bus_nm, q.br_nm,"+
				" j.tint_st, j.etc, j.reg_id, j.reg_dt, j.tint_no, j.off_id, j.off_nm, decode(j.cleaner_st,'1','기본',j.cleaner_add) cleaner_st, j.navi_nm, j.other, j.sup_est_dt, "+
				" j.sup_dt, j.tint_amt, j.cleaner_amt, j.navi_amt, j.other_amt, j.tot_amt, substr(k.user_dt3,1,8) user_dt3, j.blackbox_amt "+
				" from tint j, cont a, car_reg c, car_pur d, client e, car_etc f, car_nm g, car_mng h, users i, branch q,"+
				" (select * from doc_settle where doc_st='6') k"+
				" where"+
				" j.rent_mng_id=a.rent_mng_id(+) and j.rent_l_cd=a.rent_l_cd(+)"+
				" and j.car_mng_id=c.car_mng_id(+)"+
				" and j.rent_mng_id=d.rent_mng_id(+) and j.rent_l_cd=d.rent_l_cd(+)"+
				" and j.client_id=e.client_id(+)"+
				" and j.rent_mng_id=f.rent_mng_id(+) and j.rent_l_cd=f.rent_l_cd(+)"+
				" and f.car_id=g.car_id(+) and f.car_seq=g.car_seq(+) and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				" and j.reg_id=i.user_id and i.br_id=q.br_id"+
				" and j.tint_no=k.doc_id and k.doc_bit='3'"+
				" and decode(j.tot_amt,0,decode(j.off_nm,'다옴방',1,0),j.tot_amt) > 0 "+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(j.sup_dt,1,6)";
			dt2		= "j.sup_dt";
		}else if(gubun3.equals("2")){
			dt1		= "to_char(k.user_dt3,'YYYYMM')";
			dt2		= "to_char(k.user_dt3,'YYYYMMDD')";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals(""))	query += " and j.off_nm='"+gubun1+"'";

		if(s_kd.equals("1"))	what = "q.br_id||q.br_nm";	
		if(s_kd.equals("2"))	what = "i.user_nm";	
		if(s_kd.equals("3"))	what = "nvl(j.car_nm,c.car_nm)";	
		if(s_kd.equals("4"))	what = "nvl(j.car_num,c.car_num)";	
		if(s_kd.equals("5"))	what = "decode(j.tint_st,'1',e.firm_nm,j.etc)";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by j.off_nm, q.br_id";	
		if(sort.equals("2"))	query += " order by j.off_nm, i.user_nm";	
		if(sort.equals("3"))	query += " order by j.off_nm, nvl(j.car_nm,c.car_nm)";	
		if(sort.equals("4"))	query += " order by j.off_nm, nvl(j.car_num,c.car_num)";	
		if(sort.equals("5"))	query += " order by j.off_nm, decode(j.tint_st,'1',e.firm_nm,j.etc)";
		if(sort.equals("6"))	query += " order by j.off_nm, j.reg_dt";	
		if(sort.equals("7"))	query += " order by j.off_nm, j.sup_est_dt";	
		if(sort.equals("8"))	query += " order by j.off_nm, j.sup_dt";	
		if(sort.equals("9"))	query += " order by j.off_nm, k.user_dt3";	

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
			System.out.println("[TintDatabase:getTintSettleList]\n"+e);
			System.out.println("[TintDatabase:getTintSettleList]\n"+query);
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

	public boolean updateTintReq(String tint_no, String req_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update tint set req_code=? where tint_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  req_code);
			pstmt.setString(2,  tint_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:updateTintReq]\n"+e);
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

	public boolean updateTintReqDt(String tint_no, String req_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update tint set req_dt=replace(?,'-','') where tint_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  req_dt);
			pstmt.setString(2,  tint_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:updateTintReq]\n"+e);
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


	//청구서작성 리스트 조회
	public Vector getTintReqTarget(String user_id, String req_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" b.user_id1"+
				" from tint a, (select * from doc_settle where doc_st='6') b"+
				" where a.tint_no=b.doc_id and a.req_dt=to_char(sysdate,'YYYYMMDD') and a.conf_dt is null and b.user_id2='"+user_id+"' and a.req_code='"+req_code+"'"+
				" group by b.user_id1 order by b.user_id1";

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
			System.out.println("[TintDatabase:getTintReqTarget]\n"+e);
			System.out.println("[TintDatabase:getTintReqTarget]\n"+query);
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

	//납품확인현황 리스트 조회
	public Vector getTintConfList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.rent_dt, a.dlv_dt, "+
				" c.init_reg_dt, nvl(c.car_no,d.est_car_no) car_no, nvl(c.car_num,d.car_num) car_num, d.dlv_est_dt, "+
				" e.firm_nm, f.colo, nvl(j.sun_per,f.sun_per) sun_per, f.reg_est_dt, h.car_nm, "+
				" i.user_nm as bus_nm, q.br_nm,"+
				" j.tint_st, j.etc, j.reg_id, j.reg_dt, j.tint_no, j.off_id, j.off_nm, decode(j.cleaner_st,'1','기본',j.cleaner_add) cleaner_st, j.navi_nm, j.other, j.sup_est_dt, "+
				" j.req_dt, j.sup_dt, j.tint_amt, j.cleaner_amt, j.navi_amt, j.other_amt, j.tot_amt, j.blackbox_amt, "+
				" to_char(k.user_dt3,'YYYYMMDD') user_dt3, to_char(k.user_dt4,'YYYYMMDD') user_dt4"+
				" from tint j, cont a, car_reg c, car_pur d, client e, car_etc f, car_nm g, car_mng h, users i, branch q,"+
				" (select * from doc_settle where doc_st='6') k"+
				" where"+
				" j.rent_mng_id=a.rent_mng_id(+) and j.rent_l_cd=a.rent_l_cd(+)"+
				" and j.car_mng_id=c.car_mng_id(+)"+
				" and j.rent_mng_id=d.rent_mng_id(+) and j.rent_l_cd=d.rent_l_cd(+)"+
				" and j.client_id=e.client_id(+)"+
				" and j.rent_mng_id=f.rent_mng_id(+) and j.rent_l_cd=f.rent_l_cd(+)"+
				" and f.car_id=g.car_id(+) and f.car_seq=g.car_seq(+) and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				" and j.reg_id=i.user_id and i.br_id=q.br_id"+
				" and j.tint_no=k.doc_id and k.doc_bit='4' and j.conf_dt is null"+
				" and decode(j.tot_amt,0,decode(j.off_nm,'다옴방',1,0),j.tot_amt) > 0 "+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(j.reg_dt,1,6)";
			dt2		= "j.reg_dt";
		}else if(gubun3.equals("3")){
			dt1		= "substr(j.sup_dt,1,6)";
			dt2		= "j.sup_dt";
		}else if(gubun3.equals("4")){
			dt1		= "to_char(k.user_dt3,'YYYYMM')";
			dt2		= "to_char(k.user_dt3,'YYYYMMDD')";
		}else{
			dt1		= "substr(j.sup_est_dt,1,6)";
			dt2		= "j.sup_est_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals(""))	query += " and j.off_nm='"+gubun1+"'";

		if(s_kd.equals("1"))	what = "q.br_id||q.br_nm";	
		if(s_kd.equals("2"))	what = "i.user_nm";	
		if(s_kd.equals("3"))	what = "nvl(j.car_nm,c.car_nm)";	
		if(s_kd.equals("4"))	what = "nvl(j.car_num,c.car_num)";	
		if(s_kd.equals("5"))	what = "decode(j.tint_st,'1',e.firm_nm,j.etc)";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by j.off_nm, q.br_id";	
		if(sort.equals("2"))	query += " order by j.off_nm, i.user_nm";	
		if(sort.equals("3"))	query += " order by j.off_nm, nvl(j.car_nm,c.car_nm)";	
		if(sort.equals("4"))	query += " order by j.off_nm, nvl(j.car_num,c.car_num)";	
		if(sort.equals("5"))	query += " order by j.off_nm, decode(j.tint_st,'1',e.firm_nm,j.etc)";
		if(sort.equals("6"))	query += " order by j.off_nm, j.reg_dt";	
		if(sort.equals("7"))	query += " order by j.off_nm, j.sup_est_dt";	
		if(sort.equals("8"))	query += " order by j.off_nm, j.sup_dt";	
		if(sort.equals("9"))	query += " order by j.off_nm, k.user_dt3";	

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
			System.out.println("[TintDatabase:getTintConfList]\n"+e);
			System.out.println("[TintDatabase:getTintConfList]\n"+query);
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

	//납품청구현황 리스트 조회
	public Vector getTintReqDocList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.rent_dt, a.dlv_dt, "+
				" c.init_reg_dt, nvl(c.car_no,d.est_car_no) car_no, nvl(c.car_num,d.car_num) car_num, d.dlv_est_dt, "+
				" e.firm_nm, f.colo, nvl(j.sun_per,f.sun_per) sun_per, f.reg_est_dt, h.car_nm, "+
				" i.user_nm as bus_nm, q.br_nm,"+
				" j.tint_st, j.etc, j.reg_id, j.reg_dt, j.tint_no, j.off_id, j.off_nm, decode(j.cleaner_st,'1','기본',j.cleaner_add) cleaner_st, j.navi_nm, j.other, j.sup_est_dt, "+
				" j.sup_dt, j.tint_amt, j.cleaner_amt, j.navi_amt, j.other_amt, j.tot_amt, j.blackbox_amt, substr(k.user_dt3,1,8) user_dt3,"+
				" decode(j.conf_dt,'','미확인','확인') conf_st_nm, decode(k.user_dt6,'','미확인','확인') conf_st_nm2"+
				" from tint j, cont a, car_reg c, car_pur d, client e, car_etc f, car_nm g, car_mng h, users i, branch q,"+
				" (select * from doc_settle where doc_st ='6') k"+
				" where"+
				" j.rent_mng_id=a.rent_mng_id(+) and j.rent_l_cd=a.rent_l_cd(+)"+
				" and j.car_mng_id=c.car_mng_id(+)"+
				" and j.rent_mng_id=d.rent_mng_id(+) and j.rent_l_cd=d.rent_l_cd(+)"+
				" and j.client_id=e.client_id(+)"+
				" and j.rent_mng_id=f.rent_mng_id(+) and j.rent_l_cd=f.rent_l_cd(+)"+
				" and f.car_id=g.car_id(+) and f.car_seq=g.car_seq(+) and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				" and j.reg_id=i.user_id and i.br_id=q.br_id"+
				" and j.tint_no=k.doc_id and k.doc_bit in ('4','5','6') and k.doc_step='2'"+
				" and decode(j.tot_amt,0,decode(j.off_nm,'다옴방',1,0),j.tot_amt) > 0 "+
				" ";

				String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(j.reg_dt,1,6)";
			dt2		= "j.reg_dt";
		}else if(gubun3.equals("3")){
			dt1		= "substr(j.sup_dt,1,6)";
			dt2		= "j.sup_dt";
		}else if(gubun3.equals("4")){
			dt1		= "to_char(k.user_dt3,'YYYYMM')";
			dt2		= "to_char(k.user_dt3,'YYYYMMDD')";
		}else{
			dt1		= "substr(j.sup_est_dt,1,6)";
			dt2		= "j.sup_est_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals(""))	query += " and j.off_nm='"+gubun1+"'";

		if(s_kd.equals("1"))	what = "q.br_id||q.br_nm";	
		if(s_kd.equals("2"))	what = "i.user_nm";	
		if(s_kd.equals("3"))	what = "nvl(j.car_nm,c.car_nm)";	
		if(s_kd.equals("4"))	what = "nvl(j.car_num,c.car_num)";	
		if(s_kd.equals("5"))	what = "decode(j.tint_st,'1',e.firm_nm,j.etc)";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by j.off_nm, q.br_id";	
		if(sort.equals("2"))	query += " order by j.off_nm, i.user_nm";	
		if(sort.equals("3"))	query += " order by j.off_nm, nvl(j.car_nm,c.car_nm)";	
		if(sort.equals("4"))	query += " order by j.off_nm, nvl(j.car_num,c.car_num)";	
		if(sort.equals("5"))	query += " order by j.off_nm, decode(j.tint_st,'1',e.firm_nm,j.etc)";
		if(sort.equals("6"))	query += " order by j.off_nm, j.reg_dt";	
		if(sort.equals("7"))	query += " order by j.off_nm, j.sup_est_dt";	
		if(sort.equals("8"))	query += " order by j.off_nm, j.sup_dt";	
		if(sort.equals("9"))	query += " order by j.off_nm, k.user_dt3";

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
			System.out.println("[TintDatabase:getTintReqDocList]\n"+e);
			System.out.println("[TintDatabase:getTintReqDocList]\n"+query);
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

	//문서처리 리스트 조회
	public Vector getTintReqDocList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select"+
				" f.doc_id as req_code, a.off_id, a.req_dt, decode(a.off_nm,'다옴방','S1',c.br_id) br_id, min(a.off_nm) off_nm, count(a.tint_no) cnt, min(substr(a.sup_dt,1,8)) min_dt, max(substr(a.sup_dt,1,8)) max_dt, "+
				" sum(a.tint_amt) tint_amt, sum(a.cleaner_amt) cleaner_amt, sum(a.navi_amt) navi_amt, sum(other_amt) other_amt, sum(a.tot_amt) tot_amt, sum(a.blackbox_amt) blackbox_amt,"+
				" sum(a.a_amt) a_amt, sum(a.e_amt) e_amt, sum(a.c_amt) c_amt"+
				" from tint a, doc_settle b, users c, branch e, (select * from doc_settle where doc_st='7') f"+
				" where a.tint_no=b.doc_id(+) and b.doc_st='6' and b.user_id6=c.user_id(+) and c.br_id=e.br_id(+) and a.req_code=f.doc_id(+)"+
				" and a.req_dt is not null and a.conf_dt is not null and a.pay_dt is null and b.user_dt6 is not null";

		if(gubun1.equals("1"))							sub_query += " and a.req_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and a.req_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		sub_query += " group by a.off_id, a.req_dt, decode(a.off_nm,'다옴방','S1',c.br_id), f.doc_id";

		query = " select"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='7') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and a.br_id=e.br_id(+)"+
				" and nvl(b.doc_step,'1') <> '3' ";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("6"))	what = "a.req_dt";

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			else					query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	

		query += " order by a.off_id, a.req_dt, a.br_id";


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
			System.out.println("[TintDatabase:getTintReqDocList]\n"+e);
			System.out.println("[TintDatabase:getTintReqDocList]\n"+query);
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

	public boolean updateTintConf(String tint_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update tint set conf_dt=sysdate where tint_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  tint_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:updateTintConf]\n"+e);
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

	//미지급현황 리스트 조회
	public Vector getTintNotPayOffList(String off_id, String req_dt, String br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, h.firm_nm, decode(f.bus_st, '1','','2','영업사원','3','','4','','5','','6','','7','에이젼트') bus_st_nm "+
				" from tint a, doc_settle b, users c, users d, branch e, users g, cont f, client h"+
				" where a.tint_no=b.doc_id(+) and b.doc_st='6' "+
				" and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and b.user_id7=g.user_id(+) and g.br_id=e.br_id(+) "+
				" and b.user_dt2 is not null "+
				" and b.user_dt3 is not null "+
				" and a.req_dt is not null and a.pay_dt is null and a.conf_dt is not null and b.user_dt6 is not null"+
				" and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.client_id=h.client_id(+)"+
				" and a.off_id='"+off_id+"' and a.req_dt=replace('"+req_dt+"','-','')"+// and decode(a.off_nm,'다옴방','S1',g.br_id)='"+br_id+"'
				" order by a.sup_est_dt";

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
			System.out.println("[TintDatabase:getTintNotPayOffList]\n"+e);
			System.out.println("[TintDatabase:getTintNotPayOffList]\n"+query);
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

	//청구서작성 리스트 조회
	public Vector getTintReqDocList(String req_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, h.firm_nm, decode(f.bus_st, '1','','2','영업사원','3','','4','','5','','6','','7','에이젼트') bus_st_nm"+
				" from tint a, (select * from doc_settle where doc_st='6' AND doc_step='3') b, users c, users d, branch e, "+
				" (select * from doc_settle where doc_st='7') g, cont f, client h"+
				" where a.tint_no=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and c.br_id=e.br_id(+) and a.req_code=g.doc_id"+
				" and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.client_id=h.client_id(+)"+
				" and a.req_dt is not null and a.conf_dt is not null and g.doc_id='"+req_code+"'";//and a.pay_dt is null 

		query += " order by a.off_id, a.sup_est_dt";

			
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
			System.out.println("[TintDatabase:getTintReqDocList]\n"+e);
			System.out.println("[TintDatabase:getTintReqDocList]\n"+query);
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

	public boolean deleteTint(String tint_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;

		String query1	=  " delete from tint where tint_no=?";
		String query2	=  " delete from doc_settle where doc_st='6' and doc_id=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);		
			pstmt.setString(1,  tint_no);
			pstmt.executeUpdate();	
			pstmt.close();
			
			pstmt2 = conn.prepareStatement(query2);		
			pstmt2.setString(1,  tint_no);
			pstmt2.executeUpdate();	
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:deleteTint]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//납품비용미지급현황 리스트 조회
	public Vector getTintNonPayList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select"+
				" f.doc_id as req_code, a.off_id, a.req_dt, decode(a.off_nm,'다옴방','S1',c.br_id) br_id, min(a.off_nm) off_nm, count(a.tint_no) cnt, min(substr(a.sup_dt,1,8)) min_dt, max(substr(a.sup_dt,1,8)) max_dt, "+
				" sum(a.tint_amt) tint_amt, sum(a.cleaner_amt) cleaner_amt, sum(a.navi_amt) navi_amt, sum(other_amt) other_amt, sum(a.tot_amt) tot_amt, sum(a.blackbox_amt) blackbox_amt,"+
				" sum(a.a_amt) a_amt, sum(a.e_amt) e_amt, sum(a.c_amt) c_amt, "+
				" sum(a.e_sub_amt1) e_sub_amt1, sum(a.e_sub_amt2) e_sub_amt2, sum(a.c_sub_amt1) c_sub_amt1, sum(a.c_sub_amt2) c_sub_amt2"+
				" from tint a, (select * from doc_settle where doc_st='6' AND doc_step='3') b, users c, branch e, (select * from doc_settle where doc_st='7') f"+
				" where a.tint_no=b.doc_id and b.user_id6=c.user_id and c.br_id=e.br_id and a.req_code=f.doc_id"+
				" and a.req_dt is not null and a.conf_dt is not null and a.pay_dt is null";


		sub_query += " group by a.off_id, a.req_dt, decode(a.off_nm,'다옴방','S1',c.br_id), f.doc_id";

		query = " select"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='7') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id and b.user_id1=c.user_id and b.user_id2=d.user_id(+) and a.br_id=e.br_id"+
				" and nvl(b.doc_step,'1') = '3' ";

		if(gubun2.equals("1"))							sub_query += " and a.req_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))						sub_query += " and a.req_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and a.req_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}


		String search = "";
		String what = "";

		if(!gubun1.equals(""))	query += " and a.off_nm='"+gubun1+"'";

		if(s_kd.equals("1"))	what = "upper(nvl(a.br_id||e.br_nm, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
		}	

		if(sort.equals("1"))	query += " order by a.off_nm, decode(a.br_id,'S1',1,'B1',2,'D1',3,'G1',4,'J1',5)";	
		if(sort.equals("10"))	query += " order by a.off_nm, a.req_dt";


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
			System.out.println("[TintDatabase:getTintNonPayList]\n"+e);
			System.out.println("[TintDatabase:getTintNonPayList]\n"+query);
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

	//납품비용급현황 리스트 조회
	public Vector getTintPayList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select"+
				" a.req_code, a.off_id, a.req_dt, a.pay_dt, decode(a.off_nm,'다옴방','S1',c.br_id) br_id, min(a.off_nm) off_nm, count(a.tint_no) cnt, min(substr(a.sup_dt,1,8)) min_dt, max(substr(a.sup_dt,1,8)) max_dt, "+
				" sum(a.tint_amt) tint_amt, sum(a.cleaner_amt) cleaner_amt, sum(a.navi_amt) navi_amt, sum(other_amt) other_amt, sum(a.tot_amt) tot_amt, sum(a.blackbox_amt) blackbox_amt,"+
				" sum(a.a_amt) a_amt, sum(a.e_amt) e_amt, sum(a.c_amt) c_amt, "+
				" sum(a.e_sub_amt1) e_sub_amt1, sum(a.e_sub_amt2) e_sub_amt2, sum(a.c_sub_amt1) c_sub_amt1, sum(a.c_sub_amt2) c_sub_amt2"+
				" from tint a, (select * from doc_settle where doc_st='6' AND doc_step='3') b, users c, branch e, (select * from doc_settle where doc_st='7') f"+
				" where a.tint_no=b.doc_id and b.user_id6=c.user_id and c.br_id=e.br_id and a.req_code=f.doc_id"+
				" and a.req_dt is not null and a.conf_dt is not null and a.pay_dt is not null";

		if(gubun2.equals("1"))							sub_query += " and a.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))						sub_query += " and a.pay_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and a.pay_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and a.pay_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		sub_query += " group by a.req_code, a.off_id, a.req_dt, decode(a.off_nm,'다옴방','S1',c.br_id), a.pay_dt";

		query = " select"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='7') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id and b.user_id1=c.user_id and b.user_id2=d.user_id(+) and a.br_id=e.br_id"+
				" and nvl(b.doc_step,'1') = '3' ";



		String search = "";
		String what = "";

		if(!gubun1.equals(""))	query += " and a.off_nm='"+gubun1+"'";

		if(s_kd.equals("1"))	what = "upper(nvl(a.br_id||e.br_nm, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1"))	query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
		}else{

		}	

		if(sort.equals("1"))	query += " order by a.off_nm, decode(a.br_id,'S1',1,'B1',2,'D1',3,'G1',4,'J1',5)";	
		if(sort.equals("10"))	query += " order by a.off_nm, a.pay_dt";
		

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
			System.out.println("[TintDatabase:getTintPayList]\n"+e);
			System.out.println("[TintDatabase:getTintPayList]\n"+query);
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

	//납품관리 리스트 조회
	public Vector getTintMngList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" decode(a.tint_st,'1',b.firm_nm,a.etc) firm_nm, c.user_nm, e.colo, j.user_nm as reg_nm,"+
				" nvl(a.car_num,f.car_num) car_num2,"+
				" nvl(a.car_nm,h.car_nm) car_nm2,"+
				" nvl(a.car_no,l.car_no) car_no2,"+
				" a.*, "+
				" decode(f.com_tint,'1','썬팅','2','브랜드키트','') com_tint_nm, "+
				" decode(f.com_film_st,'1','루마','2','모비스','3','SKC','4','3M','') com_film_st_nm, "+
				" decode(a.film_st,'1','일반','2','3M','3','루마','') film_st_nm, f.rpt_no, decode(a.cleaner_st,'1','있음','2','없음') CLEANER_ST_nm, decode(a.blackbox_yn,'Y','있음','배송(광주)','4','배송(대전)','') BLACKBOX_YN_NM, "+
				" decode(e.tint_b_yn,'Y','블랙박스')||decode(e.tint_s_yn,'Y','전면썬팅')||decode(e.tint_n_yn,'Y','내비게이션') tint_bsn_yn "+
				" from"+
				" tint a, client b, users c, branch d, car_etc e, car_pur f, car_nm g, car_mng h, "+
				" (select * from doc_settle where doc_st='6') i, users j, branch k, car_reg l"+
				" where a.client_id=b.client_id(+)"+
				" and a.reg_id=c.user_id(+)"+
				" and c.br_id=d.br_id(+)"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				" and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				" and e.car_id=g.car_id(+) and e.car_seq=g.car_seq(+)"+
				" and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				" and a.tint_no=i.doc_id(+)"+
				" and a.reg_id=j.user_id(+)"+
				" and j.br_id=k.br_id(+)"+
				" and a.car_mng_id=l.car_mng_id(+)"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}else if(gubun3.equals("3")){
			dt1		= "to_char(i.user_dt2,'YYYYMM')";
			dt2		= "to_char(i.user_dt2,'YYYYMMDD')";
		}else if(gubun3.equals("4")){
			dt1		= "substr(l.init_reg_dt,1,6)";
			dt2		= "l.init_reg_dt";
		}else if(gubun3.equals("5")){
			dt1		= "substr(a.req_dt,1,6)";
			dt2		= "a.req_dt";
		}else if(gubun3.equals("6")){
			dt1		= "substr(a.pay_dt,1,6)";
			dt2		= "a.pay_dt";
		}else{
			dt1		= "substr(a.sup_est_dt,1,6)";
			dt2		= "a.sup_est_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals(""))	query += " and a.off_nm='"+gubun1+"'";

		if(s_kd.equals("1"))	what = "j.br_id||k.br_nm";	
		if(s_kd.equals("2"))	what = "j.user_nm";	
		if(s_kd.equals("3"))	what = "nvl(a.car_nm,l.car_nm)";	
		if(s_kd.equals("4"))	what = "nvl(a.car_num,f.car_num)";	
		if(s_kd.equals("5"))	what = "decode(a.tint_st,'1',b.firm_nm,a.etc)";
		if(s_kd.equals("6"))	what = "a.tint_no";	
		if(s_kd.equals("7"))	what = "a.rent_l_cd";	
		if(s_kd.equals("8"))	what = "l.car_no";	
		if(s_kd.equals("9"))	what = "a.blackbox_yn";	

		if(s_kd.equals("9"))	t_wd = "Y";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by a.off_nm, j.br_id";	
		if(sort.equals("2"))	query += " order by a.off_nm, j.user_nm";	
		if(sort.equals("3"))	query += " order by a.off_nm, nvl(a.car_nm,l.car_nm)";	
		if(sort.equals("4"))	query += " order by a.off_nm, nvl(a.car_num,f.car_num)";	
		if(sort.equals("5"))	query += " order by a.off_nm, decode(a.tint_st,'1',b.firm_nm,a.etc)";
		if(sort.equals("6"))	query += " order by a.off_nm, a.reg_dt";	
		if(sort.equals("7"))	query += " order by a.off_nm, a.sup_est_dt";	
		if(sort.equals("8"))	query += " order by a.off_nm, i.user_dt2";	
		if(sort.equals("9"))	query += " order by a.off_nm, l.init_reg_dt";	
		if(sort.equals("10"))	query += " order by a.off_nm, a.req_dt";	
		if(sort.equals("11"))	query += " order by a.off_nm, a.pay_dt";	


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
			System.out.println("[TintDatabase:getTintMngList]\n"+e);
			System.out.println("[TintDatabase:getTintMngList]\n"+query);
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

	//월별 업체별 탁송료 현황
	public Vector getTintReqStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(to_char(b.user_dt1,'YYYYMMDD'),1,6) ym,"+

				" count(a.tint_no) cnt0,"+
				" sum(a.tot_amt) amt0,"+

				" count(decode(a.off_nm,'다옴방',a.tint_no)) cnt1,"+
				" sum(decode(a.off_nm,'다옴방',a.tot_amt)) amt1,"+

				" count(decode(a.off_nm,'유림카랜드',a.tint_no)) cnt2,"+
				" sum(decode(a.off_nm,'유림카랜드',a.tot_amt)) amt2,"+

				" count(decode(a.off_nm,'웰스킨천연가죽',a.tint_no)) cnt3,"+
				" sum(decode(a.off_nm,'웰스킨천연가죽',a.tot_amt)) amt3,"+

				" count(decode(c.br_id,'S1',a.tint_no)) cnt4,"+
				" sum(decode(c.br_id,'S1',a.tot_amt)) amt4,"+

				" count(decode(c.br_id,'B1',a.tint_no)) cnt5,"+
				" sum(decode(c.br_id,'B1',a.tot_amt)) amt5,"+

				" count(decode(c.br_id,'D1',a.tint_no)) cnt6,"+
				" sum(decode(c.br_id,'D1',a.tot_amt)) amt6"+

				" from tint a, doc_settle b, users c"+
				" where a.tint_no=b.doc_id and b.doc_st='6' and b.user_id1=c.user_id"+
				" ";

		if(!brch_id.equals(""))		query += " and c.br_id = '"+brch_id+"'";

		if(!gubun1.equals(""))		query += " and a.sup_est_dt like '"+gubun1+"%'";

		query += " group by substr(to_char(b.user_dt1,'YYYYMMDD'),1,6) order by substr(to_char(b.user_dt1,'YYYYMMDD'),1,6)";

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
			
			System.out.println("[TintDatabase:getTintReqStat]"+ e);
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

	//월별 업체별 탁송료 현황
	public Vector getTintPayStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.pay_dt,1,6) ym,"+

				" count(a.tint_no) cnt0,"+
				" sum(a.tot_amt) amt0,"+

				" count(decode(a.off_nm,'다옴방',a.tint_no)) cnt1,"+
				" sum(decode(a.off_nm,'다옴방',a.tot_amt)) amt1,"+

				" count(decode(a.off_nm,'유림카랜드',a.tint_no)) cnt2,"+
				" sum(decode(a.off_nm,'유림카랜드',a.tot_amt)) amt2,"+

				" count(decode(a.off_nm,'웰스킨천연가죽',a.tint_no)) cnt3,"+
				" sum(decode(a.off_nm,'웰스킨천연가죽',a.tot_amt)) amt3,"+

				" count(decode(c.br_id,'S1',a.tint_no)) cnt4,"+
				" sum(decode(c.br_id,'S1',a.tot_amt)) amt4,"+

				" count(decode(c.br_id,'B1',a.tint_no)) cnt5,"+
				" sum(decode(c.br_id,'B1',a.tot_amt)) amt5,"+

				" count(decode(c.br_id,'D1',a.tint_no)) cnt6,"+
				" sum(decode(c.br_id,'D1',a.tot_amt)) amt6"+

				" from tint a, doc_settle b, users c"+
				" where a.tint_no=b.doc_id and b.doc_st='6' and b.user_id1=c.user_id and a.pay_dt is not null"+
				" ";

		if(!brch_id.equals(""))		query += " and c.br_id = '"+brch_id+"'";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

		query += " group by substr(a.pay_dt,1,6) ";

		query += " union all";

		query += " select"+
				" '예정' ym,"+

				" count(a.tint_no) cnt0,"+
				" sum(a.tot_amt) amt0,"+

				" count(decode(a.off_nm,'다옴방',a.tint_no)) cnt1,"+
				" sum(decode(a.off_nm,'다옴방',a.tot_amt)) amt1,"+

				" count(decode(a.off_nm,'유림카랜드',a.tint_no)) cnt2,"+
				" sum(decode(a.off_nm,'유림카랜드',a.tot_amt)) amt2,"+

				" count(decode(a.off_nm,'웰스킨천연가죽',a.tint_no)) cnt3,"+
				" sum(decode(a.off_nm,'웰스킨천연가죽',a.tot_amt)) amt3,"+

				" count(decode(c.br_id,'S1',a.tint_no)) cnt4,"+
				" sum(decode(c.br_id,'S1',a.tot_amt)) amt4,"+

				" count(decode(c.br_id,'B1',a.tint_no)) cnt5,"+
				" sum(decode(c.br_id,'B1',a.tot_amt)) amt5,"+

				" count(decode(c.br_id,'D1',a.tint_no)) cnt6,"+
				" sum(decode(c.br_id,'D1',a.tot_amt)) amt6"+

				" from tint a, doc_settle b, users c"+
				" where a.tint_no=b.doc_id and b.doc_st='6' and b.user_id1=c.user_id and a.pay_dt is null"+
				" ";
		if(!brch_id.equals(""))		query += " and c.br_id = '"+brch_id+"'";

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
			
			System.out.println("[TintDatabase:getTintPayStat]"+ e);
			System.out.println("[TintDatabase:getTintPayStat]"+ query);
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

	//사원별 탁송료 현황
	public Vector getTintReqUserStat(String brch_id, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" d.nm, c.user_nm, c.user_id, "+

				" count(a.tint_no) cnt0,"+	
				" count(decode(to_char(b.user_dt1,'MM'),'01',a.tint_no)) cnt1,"+
				" count(decode(to_char(b.user_dt1,'MM'),'02',a.tint_no)) cnt2,"+
				" count(decode(to_char(b.user_dt1,'MM'),'03',a.tint_no)) cnt3,"+
				" count(decode(to_char(b.user_dt1,'MM'),'04',a.tint_no)) cnt4,"+
				" count(decode(to_char(b.user_dt1,'MM'),'05',a.tint_no)) cnt5,"+
				" count(decode(to_char(b.user_dt1,'MM'),'06',a.tint_no)) cnt6,"+
				" count(decode(to_char(b.user_dt1,'MM'),'07',a.tint_no)) cnt7,"+
				" count(decode(to_char(b.user_dt1,'MM'),'08',a.tint_no)) cnt8,"+
				" count(decode(to_char(b.user_dt1,'MM'),'09',a.tint_no)) cnt9,"+
				" count(decode(to_char(b.user_dt1,'MM'),'10',a.tint_no)) cnt10,"+
				" count(decode(to_char(b.user_dt1,'MM'),'11',a.tint_no)) cnt11,"+
				" count(decode(to_char(b.user_dt1,'MM'),'12',a.tint_no)) cnt12"+

				" from tint a, doc_settle b, users c, (select * from code where c_st='0002' and code<>'0000') d"+
				" where a.tint_no=b.doc_id and b.doc_st='6' and b.user_id1=c.user_id and c.dept_id=d.code"+
				" ";

		if(!brch_id.equals(""))		query += " and c.br_id = '"+brch_id+"'";

		if(!gubun1.equals(""))		query += " and to_char(b.user_dt1,'YYYYMMDD') like '%"+gubun1+"%'";

		query += " group by d.nm, c.user_nm, c.user_id";

		query += " order by count(a.tint_no) desc";

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
			
			System.out.println("[TintDatabase:getTintReqUserStat]"+ e);
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

	//계약별 납품관리 리스트 조회
	public Vector getTints(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from tint where rent_mng_id=? and rent_l_cd=?";

		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
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
			System.out.println("[TintDatabase:getTints]\n"+e);
			System.out.println("[TintDatabase:getTints]\n"+query);
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

	//납품청구현황 리스트 조회
	public Vector getTintReqDocSmsConfList(String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";

		sub_query = " select"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.rent_dt, a.dlv_dt, "+
				" c.init_reg_dt, nvl(c.car_no,d.est_car_no) car_no, nvl(c.car_num,d.car_num) car_num, d.dlv_est_dt, "+
				" e.firm_nm, f.colo, nvl(j.sun_per,f.sun_per) sun_per, f.reg_est_dt, h.car_nm, "+
				" i.user_nm as bus_nm, q.br_nm,"+
				" j.tint_st, j.etc, j.reg_id, j.reg_dt, j.tint_no, j.off_id, j.off_nm, decode(j.cleaner_st,'1','기본',j.cleaner_add) cleaner_st, j.navi_nm, j.other, j.sup_est_dt, "+
				" j.sup_dt, j.tint_amt, j.cleaner_amt, j.navi_amt, j.other_amt, j.tot_amt, substr(k.user_dt3,1,8) user_dt3,"+
				" decode(j.conf_dt,'','미확인','확인') conf_st_nm, decode(k.user_dt6,'','미확인','확인') conf_st_nm2, k.user_id1, k.user_id2"+
				" from tint j, cont a, car_reg c, car_pur d, client e, car_etc f, car_nm g, car_mng h, users i, branch q,"+
				" (select * from doc_settle where doc_st ='6') k"+
				" where"+
				" j.rent_mng_id=a.rent_mng_id(+) and j.rent_l_cd=a.rent_l_cd(+)"+
				" and j.car_mng_id=c.car_mng_id(+)"+
				" and j.rent_mng_id=d.rent_mng_id(+) and j.rent_l_cd=d.rent_l_cd(+)"+
				" and j.client_id=e.client_id(+)"+
				" and j.rent_mng_id=f.rent_mng_id(+) and j.rent_l_cd=f.rent_l_cd(+)"+
				" and f.car_id=g.car_id(+) and f.car_seq=g.car_seq(+) and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				" and j.reg_id=i.user_id and i.br_id=q.br_id"+
				" and j.tint_no=k.doc_id and k.doc_bit in ('4','5','6') and k.doc_step='2' and j.conf_dt is null"+
				" and decode(j.tot_amt,0,decode(j.off_nm,'다옴방',1,0),j.tot_amt) > 0 "+
				" ";

		if(!gubun1.equals(""))	sub_query += " and j.off_nm='"+gubun1+"'";

		query = " select off_nm, user_id2, user_id1 from ( "+sub_query+" ) group by off_nm, user_id2, user_id1";

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
			System.out.println("[TintDatabase:getTintReqDocSmsConfList]\n"+e);
			System.out.println("[TintDatabase:getTintReqDocSmsConfList]\n"+query);
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

	//납품청구현황 리스트 조회
	public Hashtable getUseLcCont(String car_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.*, c.car_no, c.car_nm, e.car_name, c.car_y_form, b.colo, d.firm_nm, e.car_b, b.opt, decode(b.hipass_yn,'Y','있음','N','없음','') hipass_yn "+
				" from cont a, car_reg c, car_etc b, client d, car_nm e "+
				" where"+
				" a.car_mng_id=c.car_mng_id(+) and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id=d.client_id"+
				" and b.car_id=e.car_id and b.car_seq=e.car_seq "+
				" ";

		if(!car_mng_id.equals(""))	query += " and a.car_mng_id='"+car_mng_id+"'";

		if(rent_l_cd.equals(""))	query += " and nvl(a.use_yn,'Y')='Y'";
		else						query += " and a.rent_l_cd='"+rent_l_cd+"'";

		try {
								
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[TintDatabase:getUseLcCont]\n"+e);
			System.out.println("[TintDatabase:getUseLcCont]\n"+query);
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

	//월별 업체별 탁송료 현황
	public Vector getTintOffStat(String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.pay_dt,1,6) ym,"+

				" count(a.tint_no) cnt0,"+
				" sum(a.tot_amt) amt0,"+

				" count(decode(a.off_nm,'다옴방',a.tint_no)) cnt1,"+
				" sum(decode(a.off_nm,'다옴방',a.tot_amt)) amt1,"+

				" count(decode(a.off_nm,'유림카랜드',a.tint_no)) cnt2,"+
				" sum(decode(a.off_nm,'유림카랜드',a.tot_amt)) amt2,"+

				" count(decode(a.off_nm,'웰스킨천연가죽',a.tint_no)) cnt3,"+
				" sum(decode(a.off_nm,'웰스킨천연가죽',a.tot_amt)) amt3,"+

				" count(decode(a.off_nm,'아시아나상사',a.tint_no)) cnt4,"+
				" sum(decode(a.off_nm,'아시아나상사',a.tot_amt)) amt4"+


				" from tint a, doc_settle b, users c"+
				" where a.tint_no=b.doc_id and b.doc_st='6' and b.user_id1=c.user_id"+
                "        AND a.pay_dt <= TO_CHAR(SYSDATE,'YYYYMMDD') and a.tot_amt >0 "+ 
				" ";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

		query += " group by substr(a.pay_dt,1,6) order by substr(a.pay_dt,1,6)";

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
			
			System.out.println("[TintDatabase:getTintOffStat]"+ e);
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

	//월별 업체별 탁송료 현황
	public Vector getTintBrStat(String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" substr(a.pay_dt,1,6) ym,"+

				" count(a.tint_no) cnt0,"+
				" sum(a.tot_amt) amt0,"+

				" count(decode(c.br_id,'S1',a.tint_no)) cnt1,"+
				" sum(decode(c.br_id,'S1',a.tot_amt)) amt1,"+

				" count(decode(c.br_id,'S2',a.tint_no)) cnt2,"+
				" sum(decode(c.br_id,'S2',a.tot_amt)) amt2,"+

				" count(decode(c.br_id,'J1',a.tint_no)) cnt3,"+
				" sum(decode(c.br_id,'J1',a.tot_amt)) amt3,"+

				" count(decode(c.br_id,'G1',a.tint_no)) cnt4,"+
				" sum(decode(c.br_id,'G1',a.tot_amt)) amt4,"+

				" count(decode(c.br_id,'D1',a.tint_no)) cnt5,"+
				" sum(decode(c.br_id,'D1',a.tot_amt)) amt5,"+

				" count(decode(c.br_id,'B1',a.tint_no)) cnt6,"+
				" sum(decode(c.br_id,'B1',a.tot_amt)) amt6,"+

				" count(decode(c.br_id,'K3',a.tint_no)) cnt7,"+
				" sum(decode(c.br_id,'K3',a.tot_amt)) amt7,"+

				" count(decode(c.br_id,'I1',a.tint_no)) cnt8,"+
				" sum(decode(c.br_id,'I1',a.tot_amt)) amt8"+

				" from tint a, doc_settle b, users c"+
				" where a.tint_no=b.doc_id and b.doc_st='6' and b.user_id1=c.user_id"+
                "        AND a.pay_dt <= TO_CHAR(SYSDATE,'YYYYMMDD') and a.tot_amt >0 "+ 
				" ";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

		query += " group by substr(a.pay_dt,1,6) order by substr(a.pay_dt,1,6)";

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
			
			System.out.println("[TintDatabase:getTintBrStat]"+ e);
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

	//사원별 탁송료 현황
	public Vector getTintUserStat(String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select"+
				" d.nm, c.user_nm, c.user_id, "+

				" count(a.tint_no) cnt0,"+	
				" count(decode(substr(a.pay_dt,5,2),'01',a.tint_no)) cnt1,"+
				" count(decode(substr(a.pay_dt,5,2),'02',a.tint_no)) cnt2,"+
				" count(decode(substr(a.pay_dt,5,2),'03',a.tint_no)) cnt3,"+
				" count(decode(substr(a.pay_dt,5,2),'04',a.tint_no)) cnt4,"+
				" count(decode(substr(a.pay_dt,5,2),'05',a.tint_no)) cnt5,"+
				" count(decode(substr(a.pay_dt,5,2),'06',a.tint_no)) cnt6,"+
				" count(decode(substr(a.pay_dt,5,2),'07',a.tint_no)) cnt7,"+
				" count(decode(substr(a.pay_dt,5,2),'08',a.tint_no)) cnt8,"+
				" count(decode(substr(a.pay_dt,5,2),'09',a.tint_no)) cnt9,"+
				" count(decode(substr(a.pay_dt,5,2),'10',a.tint_no)) cnt10,"+
				" count(decode(substr(a.pay_dt,5,2),'11',a.tint_no)) cnt11,"+
				" count(decode(substr(a.pay_dt,5,2),'12',a.tint_no)) cnt12"+

				" from tint a, doc_settle b, users c, (select * from code where c_st='0002' and code<>'0000') d"+
				" where a.tint_no=b.doc_id and b.doc_st='6' and b.user_id1=c.user_id and c.dept_id=d.code"+
                "        AND a.pay_dt <= TO_CHAR(SYSDATE,'YYYYMMDD') and a.tot_amt >0 "+ 
				" ";

		if(!gubun1.equals(""))		query += " and a.pay_dt like '"+gubun1+"%'";

		query += " group by d.nm, c.user_nm, c.user_id";

		query += " order by count(a.tint_no) desc";

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
			
			System.out.println("[TintDatabase:getTintReqUserStat]"+ e);
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

	//용품-블랙박스사진
	public String getInsurBlackboxImg(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String blackbox_img = "";
					
		query = " select max(b.blackbox_img) from cont a, tint b where a.car_mng_id='"+car_mng_id+"' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				blackbox_img = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			
			System.out.println("[TintDatabase:getInsurBlackboxImg]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
                		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return blackbox_img;
		}
	}	

	//용품-블랙박스사진
	public Hashtable getInsurBlackboxImgs(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.rent_l_cd, max(b.blackbox_img) blackbox_img, max(b.blackbox_img2) blackbox_img2 from cont a, tint b where a.car_mng_id='"+car_mng_id+"' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd group by a.rent_l_cd ";


		try {
								
			pstmt = conn.prepareStatement(query);
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
			System.out.println("[TintDatabase:getInsurBlackboxImgs]\n"+e);
			System.out.println("[TintDatabase:getInsurBlackboxImgs]\n"+query);
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
	*	off_id 조회
	*/
	public Hashtable getSearchOff_id(String sid_no){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " SELECT off_id from serv_off  WHERE nvl(off_type, '1') = '3' and ent_no=?"+
						" ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,sid_no);
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
		}catch(Exception e){
			System.out.println("[TintDatabase:getSearchOff_id]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return ht;
		}
	}



	//NEW TINT ----------------------------------------------------------------------------------------


	//한건 조회
	public TintBean getCarTint(String rent_mng_id, String rent_l_cd, String tint_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TintBean bean = new TintBean();
		String query = "";

		query = " select * from car_tint where rent_mng_id = ? and rent_l_cd = ? and tint_st=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, tint_st);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setTint_no			(rs.getString("tint_no")		==null?"":rs.getString("tint_no"));
				bean.setTint_st			(rs.getString("tint_st")		==null?"":rs.getString("tint_st"));
	 			bean.setOff_id			(rs.getString("off_id")			==null?"":rs.getString("off_id"));	
	 			bean.setOff_nm			(rs.getString("off_nm")			==null?"":rs.getString("off_nm"));	
				bean.setCar_mng_id		(rs.getString("car_mng_id")		==null?"":rs.getString("car_mng_id"));
				bean.setRent_mng_id		(rs.getString("rent_mng_id")	==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd		(rs.getString("rent_l_cd")		==null?"":rs.getString("rent_l_cd"));
				bean.setClient_id		(rs.getString("client_id")		==null?"":rs.getString("client_id"));
				bean.setCar_no			(rs.getString("car_no")			==null?"":rs.getString("car_no"));	
				bean.setCar_nm			(rs.getString("car_nm")			==null?"":rs.getString("car_nm"));
				bean.setCar_num			(rs.getString("car_num")		==null?"":rs.getString("car_num"));
				bean.setFilm_st			(rs.getString("film_st")		==null?"":rs.getString("film_st"));
				bean.setSun_per			(rs.getInt   ("sun_per"));
				bean.setEtc				(rs.getString("etc")			==null?"":rs.getString("etc"));
				bean.setTint_amt		(rs.getInt   ("tint_amt"));
				bean.setSup_est_dt		(rs.getString("sup_est_dt")		==null?"":rs.getString("sup_est_dt"));	
				bean.setSup_dt			(rs.getString("sup_dt")			==null?"":rs.getString("sup_dt"));
				bean.setConf_dt			(rs.getString("conf_dt")		==null?"":rs.getString("conf_dt"));
				bean.setReq_dt			(rs.getString("req_dt")			==null?"":rs.getString("req_dt"));
				bean.setPay_dt			(rs.getString("pay_dt")			==null?"":rs.getString("pay_dt"));
				bean.setReq_code		(rs.getString("req_code")		==null?"":rs.getString("req_code"));	
				bean.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));	
				bean.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));										
				bean.setTint_yn   		(rs.getString("tint_yn")		==null?"":rs.getString("tint_yn"));
				bean.setModel_st  		(rs.getString("model_st")		==null?"":rs.getString("model_st"));
				bean.setChannel_st		(rs.getString("channel_st")		==null?"":rs.getString("channel_st"));
				bean.setCom_nm    		(rs.getString("com_nm")			==null?"":rs.getString("com_nm"));
				bean.setModel_nm  		(rs.getString("model_nm")		==null?"":rs.getString("model_nm"));	
				bean.setSerial_no 		(rs.getString("serial_no")		==null?"":rs.getString("serial_no"));
				bean.setCost_st   		(rs.getString("cost_st")		==null?"":rs.getString("cost_st"));
				bean.setEst_st    		(rs.getString("est_st")			==null?"":rs.getString("est_st"));
				bean.setEst_m_amt 		(rs.getInt   ("est_m_amt"));
				bean.setTint_su 		(rs.getInt   ("tint_su"));
				bean.setDoc_code   		(rs.getString("doc_code")			==null?"":rs.getString("doc_code"));
				bean.setR_tint_amt		(rs.getInt   ("r_tint_amt"));
				bean.setModel_id  		(rs.getString("model_id")		==null?"":rs.getString("model_id"));
				bean.setReg_st			(rs.getString("reg_st")			==null?"":rs.getString("reg_st"));
				bean.setB_tint_amt		(rs.getInt   ("b_tint_amt"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TintDatabase:getCarTint(String rent_mng_id, String rent_l_cd, String tint_st)]\n"+e);
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

	//한건 조회
	public TintBean getCarTint(String tint_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TintBean bean = new TintBean();
		String query = "";

		query = " select * from car_tint where tint_no = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, tint_no);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setTint_no			(rs.getString("tint_no")		==null?"":rs.getString("tint_no"));
				bean.setTint_st			(rs.getString("tint_st")		==null?"":rs.getString("tint_st"));
	 			bean.setOff_id			(rs.getString("off_id")			==null?"":rs.getString("off_id"));	
	 			bean.setOff_nm			(rs.getString("off_nm")			==null?"":rs.getString("off_nm"));	
				bean.setCar_mng_id		(rs.getString("car_mng_id")		==null?"":rs.getString("car_mng_id"));
				bean.setRent_mng_id		(rs.getString("rent_mng_id")	==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd		(rs.getString("rent_l_cd")		==null?"":rs.getString("rent_l_cd"));
				bean.setClient_id		(rs.getString("client_id")		==null?"":rs.getString("client_id"));
				bean.setCar_no			(rs.getString("car_no")			==null?"":rs.getString("car_no"));	
				bean.setCar_nm			(rs.getString("car_nm")			==null?"":rs.getString("car_nm"));
				bean.setCar_num			(rs.getString("car_num")		==null?"":rs.getString("car_num"));
				bean.setFilm_st			(rs.getString("film_st")		==null?"":rs.getString("film_st"));
				bean.setSun_per			(rs.getInt   ("sun_per"));
				bean.setEtc				(rs.getString("etc")			==null?"":rs.getString("etc"));
				bean.setTint_amt		(rs.getInt   ("tint_amt"));
				bean.setSup_est_dt		(rs.getString("sup_est_dt")		==null?"":rs.getString("sup_est_dt"));	
				bean.setSup_dt			(rs.getString("sup_dt")			==null?"":rs.getString("sup_dt"));
				bean.setConf_dt			(rs.getString("conf_dt")		==null?"":rs.getString("conf_dt"));
				bean.setReq_dt			(rs.getString("req_dt")			==null?"":rs.getString("req_dt"));
				bean.setPay_dt			(rs.getString("pay_dt")			==null?"":rs.getString("pay_dt"));
				bean.setReq_code		(rs.getString("req_code")		==null?"":rs.getString("req_code"));	
				bean.setReg_id			(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));	
				bean.setReg_dt			(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));										
				bean.setTint_yn   		(rs.getString("tint_yn")		==null?"":rs.getString("tint_yn"));
				bean.setModel_st  		(rs.getString("model_st")		==null?"":rs.getString("model_st"));
				bean.setChannel_st		(rs.getString("channel_st")		==null?"":rs.getString("channel_st"));
				bean.setCom_nm    		(rs.getString("com_nm")			==null?"":rs.getString("com_nm"));
				bean.setModel_nm  		(rs.getString("model_nm")		==null?"":rs.getString("model_nm"));	
				bean.setSerial_no 		(rs.getString("serial_no")		==null?"":rs.getString("serial_no"));
				bean.setCost_st   		(rs.getString("cost_st")		==null?"":rs.getString("cost_st"));
				bean.setEst_st    		(rs.getString("est_st")			==null?"":rs.getString("est_st"));
				bean.setEst_m_amt 		(rs.getInt   ("est_m_amt"));
				bean.setTint_su 		(rs.getInt   ("tint_su"));
				bean.setDoc_code   		(rs.getString("doc_code")			==null?"":rs.getString("doc_code"));
				bean.setR_tint_amt		(rs.getInt   ("r_tint_amt"));
				bean.setModel_id  		(rs.getString("model_id")		==null?"":rs.getString("model_id"));
				bean.setReg_st			(rs.getString("reg_st")			==null?"":rs.getString("reg_st"));
				bean.setB_tint_amt		(rs.getInt   ("b_tint_amt"));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TintDatabase:getCarTint(String tint_no)]\n"+e);
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

	public String insertCarTint(TintBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String tint_no = "";
		String query =  " insert into car_tint "+
						" ( tint_no, off_id, off_nm, car_mng_id, rent_mng_id, rent_l_cd, client_id, car_no, car_nm, car_num, "+
						"   film_st, sun_per, etc, tint_amt, "+
						"   sup_est_dt, sup_dt, conf_dt, req_dt, pay_dt, req_code, reg_id, reg_dt, tint_st, tint_yn, "+
			            "   model_st, channel_st, com_nm, model_nm, serial_no, cost_st, est_st, est_m_amt, tint_su, doc_code, r_tint_amt, model_id, reg_st, b_tint_amt  "+
						" ) values "+
						" ( ?, ?, ?, ?, ?,    ?, ?, ?, ?, ?,	"+
						"   ?, ?, ?, ?, 		                "+
						"   replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), replace(?,'-',''), ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, "+
				        "   ?, ?, ?, upper(?), ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "+
						" )";

		String qry_id = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(tint_no,9,4))+1), '0000')), '0001') tint_no"+
						" from   car_tint "+
						" where substr(tint_no,1,8)=to_char(sysdate,'YYYYMMDD')";


		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			if(rs.next())
			{
				tint_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			conn.commit();
		}catch(Exception e){					
	        try{
				System.out.println("[TintDatabase:insertCarTint]"+e);
	            conn.rollback();
				e.printStackTrace();	
				flag = false;
	        }catch(SQLException _ignored){}
		}finally{
			try{
                if(rs != null )		rs.close();
	            if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
		}

		try
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);
			
			pstmt2.setString(1,  tint_no				  );
			pstmt2.setString(2,  bean.getOff_id			());
			pstmt2.setString(3,  bean.getOff_nm			());
			pstmt2.setString(4,  bean.getCar_mng_id		());
			pstmt2.setString(5,  bean.getRent_mng_id	());
			pstmt2.setString(6,  bean.getRent_l_cd		());
			pstmt2.setString(7,  bean.getClient_id		());
			pstmt2.setString(8,  bean.getCar_no			());
			pstmt2.setString(9,  bean.getCar_nm			());
			pstmt2.setString(10, bean.getCar_num		());
			pstmt2.setString(11, bean.getFilm_st		());
			pstmt2.setInt   (12, bean.getSun_per		());
			pstmt2.setString(13, bean.getEtc			());
			pstmt2.setInt   (14, bean.getTint_amt		());
			pstmt2.setString(15, bean.getSup_est_dt		());
			pstmt2.setString(16, bean.getSup_dt			());
			pstmt2.setString(17, bean.getConf_dt		());
			pstmt2.setString(18, bean.getReq_dt			());
			pstmt2.setString(19, bean.getPay_dt			());
			pstmt2.setString(20, bean.getReq_code		());
			pstmt2.setString(21, bean.getReg_id			());
			pstmt2.setString(22, bean.getTint_st		());
			pstmt2.setString(23, bean.getTint_yn		());
			pstmt2.setString(24, bean.getModel_st  		());
			pstmt2.setString(25, bean.getChannel_st		());
			pstmt2.setString(26, bean.getCom_nm    		());
			pstmt2.setString(27, bean.getModel_nm  		());
			pstmt2.setString(28, bean.getSerial_no 		());
			pstmt2.setString(29, bean.getCost_st   		());
			pstmt2.setString(30, bean.getEst_st    		());
			pstmt2.setInt   (31, bean.getEst_m_amt 		());
			pstmt2.setInt   (32, bean.getTint_su 		());
			pstmt2.setString(33, bean.getDoc_code		());
			pstmt2.setInt   (34, bean.getR_tint_amt		());
			pstmt2.setString(35, bean.getModel_id  		());
			pstmt2.setString(36, bean.getReg_st  		());
			pstmt2.setInt   (37, bean.getB_tint_amt		());

			pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:insertCarTint]\n"+e);
			System.out.println("[ bean.getReg_id		()]\n"+ bean.getReg_id		());
			e.printStackTrace();
	  		flag = false;
			tint_no = "";
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return tint_no;
		}
	}

	public boolean updateCarTint(TintBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_tint set "+
						"	OFF_ID       	= ?, "+
						"	OFF_NM       	= ?, "+
						"	CAR_MNG_ID   	= ?, "+
						"	RENT_MNG_ID  	= ?, "+
						"	RENT_L_CD    	= ?, "+
						"	CLIENT_ID    	= ?, "+
						"	CAR_NO       	= ?, "+
						"	CAR_NM       	= ?, "+
						"	CAR_NUM      	= replace(?,'-',''), "+
						"	FILM_ST      	= ?, "+
						"	SUN_PER      	= ?, "+
						"	ETC          	= ?, "+
						"	TINT_AMT     	= ?, "+
						"	SUP_EST_DT   	= replace(replace(?,' ',''),'-',''), "+
						"	SUP_DT       	= replace(replace(?,' ',''),'-',''), "+
						"	CONF_DT      	= replace(?,'-',''), "+
						"	REQ_DT       	= replace(?,'-',''), "+
						"	PAY_DT       	= replace(?,'-',''), "+
						"	TINT_ST     	= ?, "+
						"	TINT_YN     	= ?, "+
						"	model_st  		= ?, "+
						"	channel_st		= ?, "+
						"	com_nm    		= ?, "+
						"	model_nm  		= upper(?), "+
						"	serial_no 		= ?, "+
						"	cost_st   		= ?, "+
						"	est_st    		= ?, "+
						"	est_m_amt 		= ?, "+
						"	tint_su			= ?, "+
						"	r_TINT_AMT     	= ?, "+
						"	model_id     	= ?  "+
						" where tint_no=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  bean.getOff_id			());
			pstmt.setString(2,  bean.getOff_nm			());
			pstmt.setString(3,  bean.getCar_mng_id		());
			pstmt.setString(4,  bean.getRent_mng_id		());
			pstmt.setString(5,  bean.getRent_l_cd		());
			pstmt.setString(6,  bean.getClient_id		());
			pstmt.setString(7,  bean.getCar_no			());
			pstmt.setString(8,  bean.getCar_nm			());
			pstmt.setString(9,  bean.getCar_num			());
			pstmt.setString(10, bean.getFilm_st			());
			pstmt.setInt   (11, bean.getSun_per			());
			pstmt.setString(12, bean.getEtc				());
			pstmt.setInt   (13, bean.getTint_amt		());
			pstmt.setString(14, bean.getSup_est_dt		());
			pstmt.setString(15, bean.getSup_dt			());
			pstmt.setString(16, bean.getConf_dt			());
			pstmt.setString(17, bean.getReq_dt			());
			pstmt.setString(18, bean.getPay_dt			());
			pstmt.setString(19, bean.getTint_st			());
			pstmt.setString(20, bean.getTint_yn			());
			pstmt.setString(21, bean.getModel_st  		());
			pstmt.setString(22, bean.getChannel_st		());
			pstmt.setString(23, bean.getCom_nm    		());
			pstmt.setString(24, bean.getModel_nm  		());
			pstmt.setString(25, bean.getSerial_no 		());
			pstmt.setString(26, bean.getCost_st   		());
			pstmt.setString(27, bean.getEst_st    		());
			pstmt.setInt   (28, bean.getEst_m_amt 		());
			pstmt.setInt   (29, bean.getTint_su 		());
			pstmt.setInt   (30, bean.getR_tint_amt		());
			pstmt.setString(31, bean.getModel_id  		());
			pstmt.setString(32, bean.getTint_no			());

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:updateCarTint]\n"+e);
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

	public boolean updateCarTintDocCode(String tint_no, String doc_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_tint set doc_code= ? where tint_no=? and req_code is null ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  doc_code);
			pstmt.setString(2,  tint_no);

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:updateCarTintDocCode]\n"+e);
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

	public boolean updateCarTintReqCode(String tint_no, String req_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_tint set req_code= ? where tint_no=?  "; //and req_code is null

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  req_code);
			pstmt.setString(2,  tint_no);

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:updateCarTintReqCode]\n"+e);
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

	public boolean updateCarTintConf(String tint_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_tint set conf_dt=to_char(sysdate,'YYYYMMDD') where tint_no=? and conf_dt is null ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  tint_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:updateCarTintConf]\n"+e);
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

	public boolean updateCarTintReqDt(String tint_no, String req_dt)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_tint set req_dt=replace(?,'-','') where tint_no=? and req_dt is null ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  req_dt);
			pstmt.setString(2,  tint_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:updateCarTintReqDt]\n"+e);
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
	
	// 일련번호 수정
	public boolean updateCarTintSerialno(String tint_no, String serial_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update car_tint set serial_no = ? where tint_no=?";

		try
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);		
			pstmt.setString(1,  serial_no);
			pstmt.setString(2,  tint_no);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:updateCarTintSerialno]\n"+e);
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

	public boolean deleteCarTint(String tint_no)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query1	=  " delete from car_tint where tint_no=? and doc_code is null ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);		
			pstmt.setString(1,  tint_no);
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TintDatabase:deleteCarTint]\n"+e);
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


	//용품미수신현황 리스트 조회
	public Vector getCarTintWList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"       decode(c.dept_id,'1000',1,2) st, decode(a.rent_l_cd,'','',b.firm_nm) firm_nm, c.user_nm, e.colo, c.dept_id, "+
				"       nvl(f.car_num,l.car_num) car_num2,"+
				"       nvl(h.car_nm,l.car_nm) car_nm2,"+
				"       l.car_no car_no2,"+
				"       f.rpt_no, f.dlv_est_dt, e.reg_est_dt, l.init_reg_dt, n.use_yn, "+
				"       decode(f.com_tint,'1','썬팅','2','브랜드키트','') com_tint_nm, "+
				"       decode(f.com_film_st,'1','루마','2','모비스','3','SKC','4','3M','') com_film_st_nm, "+
				"       a.* "+
				" from "+
				"       (SELECT reg_st, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
				"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'),'7',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'),'8',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
				"               MIN(DECODE(tint_st,'1',sun_per)) s1_sun_per, "+
				"               MIN(DECODE(tint_st,'2',sun_per)) s2_sun_per, "+
				"               min(sup_est_dt) sup_est_dt, MIN(reg_dt) reg_dt, MIN(reg_id) reg_id, "+
				"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"               SUM(tint_su) tint_su "+
				"        FROM   CAR_TINT "+
				"        WHERE  tint_yn='Y' and doc_code IS NULL "+
				"               and off_nm not in ('고객장착','수입차') "+
				"        GROUP BY reg_st, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
				"	    ) a, "+
				"       cont n, client b, users c, branch d, car_etc e, car_pur f, car_nm g, car_mng h, "+
				"       car_reg l, cls_cont i "+
				" where "+
				"       a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				"       and n.client_id=b.client_id(+)"+
				"       and a.reg_id=c.user_id(+)"+
				"       and c.br_id=d.br_id(+)"+
				"       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				"       and e.car_id=g.car_id(+) and e.car_seq=g.car_seq(+)"+
				"       and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				"       and n.car_mng_id=l.car_mng_id(+)"+
				"       and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and nvl(i.cls_st,'0')<>'7' "+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}else{
			dt1		= "substr(a.sup_est_dt,1,6)";
			dt2		= "a.sup_est_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("6"))		query += " and "+dt2+" > to_char(sysdate-7,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals("") && !gubun1.equals("미지정"))	{
			if(gubun1.equals("스마일탁송")||gubun1.equals("스마일TS")){
				query += " and a.off_id = '010255' ";
			} else {
				query += " and a.off_nm='"+gubun1+"'";
			}
		}
			
		if(gubun1.equals("미지정"))	query += " and a.off_nm is null ";

		if(s_kd.equals("1"))	what = "d.br_id||d.br_nm";	
		if(s_kd.equals("2"))	what = "c.user_nm";	
		if(s_kd.equals("3"))	what = "nvl(h.car_nm,l.car_nm)";	
		if(s_kd.equals("4"))	what = "nvl(f.car_num,l.car_num)";	
		if(s_kd.equals("5"))	what = "decode(a.rent_l_cd,'','',b.firm_nm)";
		if(s_kd.equals("6"))	what = "a.b_yn";	

		if(s_kd.equals("6"))	t_wd = "Y";
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by 1, a.off_nm, c.br_id";	
		if(sort.equals("2"))	query += " order by 1, a.off_nm, c.user_nm";	
		if(sort.equals("3"))	query += " order by 1, a.off_nm, nvl(h.car_nm,l.car_nm)";	
		if(sort.equals("4"))	query += " order by 1, a.off_nm, nvl(f.car_num,l.car_num)";	
		if(sort.equals("5"))	query += " order by 1, a.off_nm, decode(a.rent_l_cd,'','',b.firm_nm)";
		if(sort.equals("6"))	query += " order by 1, a.off_nm, a.reg_dt";	
		if(sort.equals("7"))	query += " order by 1, a.off_nm, a.sup_est_dt";	
		if(sort.equals("8"))	query += " order by 1, a.off_nm, f.dlv_est_dt";	
		if(sort.equals("9"))	query += " order by 1, a.off_nm, e.reg_est_dt";	
		
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
			System.out.println("[TintDatabase:getCarTintWList]\n"+e);
			System.out.println("[TintDatabase:getCarTintWList]\n"+query);
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

	//용품미정산현황 리스트 조회
	public Vector getCarTintIList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"       decode(c.dept_id,'1000',1,2) st, decode(a.rent_l_cd,'','',b.firm_nm) firm_nm, c.user_nm, e.colo, c.dept_id, "+
				"       nvl(f.car_num,l.car_num) car_num2,"+
				"       nvl(h.car_nm,l.car_nm) car_nm2,"+
				"       l.car_no car_no2,"+
				"       f.rpt_no, f.dlv_est_dt, e.reg_est_dt, l.init_reg_dt, n.use_yn, "+
				"       decode(f.com_tint,'1','썬팅','2','브랜드키트','') com_tint_nm, "+
				"       decode(f.com_film_st,'1','루마','2','모비스','3','SKC','4','3M','') com_film_st_nm, "+
				"       i.doc_no, "+
				"       a.* "+
				" from "+
				"       (SELECT doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
				"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
				"               MIN(DECODE(tint_st,'1',sun_per)) s1_sun_per, "+
				"               MIN(DECODE(tint_st,'2',sun_per)) s2_sun_per, "+
				"               min(sup_est_dt) sup_est_dt, MIN(reg_dt) reg_dt, MIN(reg_id) reg_id, "+
				"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"               SUM(tint_su) tint_su "+
				"        FROM   CAR_TINT "+
				"        WHERE  tint_yn='Y' and doc_code > 0 "+
				"        GROUP BY doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
				"	    ) a, "+
				"       (select * from doc_settle where doc_st='6' and doc_bit='2' and user_dt2 is not null and user_dt3 is null )  i, "+
				"       cont n, client b, users c, branch d, car_etc e, car_pur f, car_nm g, car_mng h, "+
				"       car_reg l "+
				" where "+
				"       a.doc_code=i.doc_id "+
				"       and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				"       and n.client_id=b.client_id(+)"+
				"       and i.user_id1=c.user_id(+)"+
				"       and c.br_id=d.br_id(+)"+
				"       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				"       and e.car_id=g.car_id(+) and e.car_seq=g.car_seq(+)"+
				"       and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				"       and n.car_mng_id=l.car_mng_id(+)"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}else{
			dt1		= "substr(a.sup_est_dt,1,6)";
			dt2		= "a.sup_est_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("6"))		query += " and "+dt2+" > to_char(sysdate-7,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals("") && !gubun1.equals("미지정"))	{
			if(gubun1.equals("스마일탁송")||gubun1.equals("스마일TS")){
				query += " and a.off_id = '010255' ";
			} else {
				query += " and a.off_nm='"+gubun1+"'";
			}
		}
		
		if(gubun1.equals("미지정"))	query += " and a.off_nm is null ";

		if(s_kd.equals("1"))	what = "d.br_id||d.br_nm";	
		if(s_kd.equals("2"))	what = "c.user_nm";	
		if(s_kd.equals("3"))	what = "nvl(h.car_nm,l.car_nm)";	
		if(s_kd.equals("4"))	what = "nvl(f.car_num,l.car_num)";	
		if(s_kd.equals("5"))	what = "decode(a.rent_l_cd,'','',b.firm_nm)";
		if(s_kd.equals("6"))	what = "a.b_yn";	

		if(s_kd.equals("6"))	t_wd = "Y";
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by 1, a.off_nm, c.br_id";	
		if(sort.equals("2"))	query += " order by 1, a.off_nm, c.user_nm";	
		if(sort.equals("3"))	query += " order by 1, a.off_nm, nvl(h.car_nm,l.car_nm)";	
		if(sort.equals("4"))	query += " order by 1, a.off_nm, nvl(f.car_num,l.car_num)";	
		if(sort.equals("5"))	query += " order by 1, a.off_nm, decode(a.rent_l_cd,'','',b.firm_nm)";
		if(sort.equals("6"))	query += " order by 1, a.off_nm, a.reg_dt";	
		if(sort.equals("7"))	query += " order by 1, a.off_nm, a.sup_est_dt";	
		if(sort.equals("8"))	query += " order by 1, a.off_nm, f.dlv_est_dt";	
		if(sort.equals("9"))	query += " order by 1, a.off_nm, e.reg_est_dt";	

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
			System.out.println("[TintDatabase:getCarTintIList]\n"+e);
			System.out.println("[TintDatabase:getCarTintIList]\n"+query);
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

	//용품미청구현황 리스트 조회
	public Vector getCarTintSList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"       decode(c.dept_id,'1000',1,2) st, decode(a.rent_l_cd,'','',b.firm_nm) firm_nm, c.user_nm, e.colo, c.dept_id, "+
				"       nvl(f.car_num,l.car_num) car_num2,"+
				"       nvl(h.car_nm,l.car_nm) car_nm2,"+
				"       l.car_no car_no2,"+
				"       f.rpt_no, f.dlv_est_dt, e.reg_est_dt, l.init_reg_dt, n.use_yn, "+
				"       decode(f.com_tint,'1','썬팅','2','브랜드키트','') com_tint_nm, "+
				"       decode(f.com_film_st,'1','루마','2','모비스','3','SKC','4','3M','') com_film_st_nm, "+
				"       i.doc_no, "+
				"       a.* "+
				" from "+
				"       (SELECT doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
				"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
				"               sum(DECODE(tint_st,'1',nvl(r_tint_amt,0))) s1_amt, "+
				"               sum(DECODE(tint_st,'2',nvl(r_tint_amt,0))) s2_amt, "+
				"               sum(DECODE(tint_st,'3',nvl(r_tint_amt,0))) b_amt, "+
				"               sum(DECODE(tint_st,'4',nvl(r_tint_amt,0))) n_amt, "+
				"               sum(DECODE(tint_st,'5',nvl(r_tint_amt,0))) e_amt,  "+
				"               sum(DECODE(tint_st,'6',nvl(r_tint_amt,0))) ev_amt,  "+			//이동형충전기(2018.04.12)
				"               sum(nvl(r_tint_amt,0)) tot_amt,  "+
				"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(reg_id) reg_id, "+
				"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"               SUM(tint_su) tint_su "+
				"        FROM   CAR_TINT "+
				"        WHERE  tint_yn='Y' and doc_code > 0 "+
				"        GROUP BY doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
				"	    ) a, "+
				"       (select * from doc_settle where doc_st='6' and doc_bit='3' and user_dt3 is not null and user_dt4 is null)  i, "+
				"       cont n, client b, users c, branch d, car_etc e, car_pur f, car_nm g, car_mng h, "+
				"       car_reg l "+
				" where "+
				"       decode(a.tot_amt,0,decode(a.off_nm,'다옴방',1,0),a.tot_amt) > 0 "+
				"       and a.doc_code=i.doc_id "+
				"       and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				"       and n.client_id=b.client_id(+)"+
				"       and i.user_id1=c.user_id(+)"+
				"       and c.br_id=d.br_id(+)"+
				"       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				"       and e.car_id=g.car_id(+) and e.car_seq=g.car_seq(+)"+
				"       and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				"       and n.car_mng_id=l.car_mng_id(+)"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}else{
			dt1		= "substr(a.sup_dt,1,6)";
			dt2		= "a.sup_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("6"))		query += " and "+dt2+" > to_char(sysdate-7,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals("") && !gubun1.equals("미지정"))	{
			if(gubun1.equals("스마일탁송")||gubun1.equals("스마일TS")){
				query += " and a.off_id = '010255' ";
			} else {
				query += " and a.off_nm='"+gubun1+"'";
			}
		}
		
		if(gubun1.equals("미지정"))	query += " and a.off_nm is null ";

		if(s_kd.equals("1"))	what = "d.br_id||d.br_nm";	
		if(s_kd.equals("2"))	what = "c.user_nm";	
		if(s_kd.equals("3"))	what = "nvl(h.car_nm,l.car_nm)";	
		if(s_kd.equals("4"))	what = "nvl(f.car_num,l.car_num)";	
		if(s_kd.equals("5"))	what = "decode(a.rent_l_cd,'','',b.firm_nm)";
		if(s_kd.equals("6"))	what = "a.b_yn";	

		if(s_kd.equals("6"))	t_wd = "Y";
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by 1, a.off_nm, c.br_id";	
		if(sort.equals("2"))	query += " order by 1, a.off_nm, c.user_nm";	
		if(sort.equals("3"))	query += " order by 1, a.off_nm, nvl(h.car_nm,l.car_nm)";	
		if(sort.equals("4"))	query += " order by 1, a.off_nm, nvl(f.car_num,l.car_num)";	
		if(sort.equals("5"))	query += " order by 1, a.off_nm, decode(a.rent_l_cd,'','',b.firm_nm)";
		if(sort.equals("7"))	query += " order by 1, a.off_nm, a.sup_dt";	

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
			System.out.println("[TintDatabase:getCarTintSList]\n"+e);
			System.out.println("[TintDatabase:getCarTintSList]\n"+query);
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

	//용품미확인현황 리스트 조회
	public Vector getCarTintCList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"       decode(c.dept_id,'1000',1,2) st, decode(a.rent_l_cd,'','',b.firm_nm) firm_nm, c.user_nm, e.colo, c.dept_id, "+
				"       nvl(f.car_num,l.car_num) car_num2,"+
				"       nvl(h.car_nm,l.car_nm) car_nm2,"+
				"       l.car_no car_no2,"+
				"       f.rpt_no, f.dlv_est_dt, e.reg_est_dt, l.init_reg_dt, n.use_yn, "+
				"       decode(f.com_tint,'1','썬팅','2','브랜드키트','') com_tint_nm, "+
				"       decode(f.com_film_st,'1','루마','2','모비스','3','SKC','4','3M','') com_film_st_nm, "+
				"       i.doc_no, "+
				"       a.* "+
				" from "+
				"       (SELECT doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
				"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)	
				"               sum(DECODE(tint_st,'1',nvl(r_tint_amt,0))) s1_amt, "+
				"               sum(DECODE(tint_st,'2',nvl(r_tint_amt,0))) s2_amt, "+
				"               sum(DECODE(tint_st,'3',nvl(r_tint_amt,0))) b_amt, "+
				"               sum(DECODE(tint_st,'4',nvl(r_tint_amt,0))) n_amt, "+
				"               sum(DECODE(tint_st,'5',nvl(r_tint_amt,0))) e_amt,  "+
				"               sum(DECODE(tint_st,'6',nvl(r_tint_amt,0))) ev_amt,  "+			//이동형충전기(2018.04.12)
				"               sum(nvl(r_tint_amt,0)) tot_amt,  "+
				"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(reg_id) reg_id, "+
				"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"               SUM(tint_su) tint_su "+
				"        FROM   CAR_TINT "+
				"        WHERE  tint_yn='Y' and doc_code > 0 "+
				"        GROUP BY doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
				"	    ) a, "+
				"       (select * from doc_settle where doc_st='6' and doc_bit='4' and user_dt4 is not null and user_dt5 is null and doc_step<>'3')  i, "+
				"       cont n, client b, users c, branch d, car_etc e, car_pur f, car_nm g, car_mng h, "+
				"       car_reg l "+
				" where "+
				"       decode(a.tot_amt,0,decode(a.off_nm,'다옴방',1,0),a.tot_amt) > 0 "+
				"       and a.doc_code=i.doc_id "+
				"       and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				"       and n.client_id=b.client_id(+)"+
				"       and i.user_id1=c.user_id(+)"+
				"       and c.br_id=d.br_id(+)"+
				"       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				"       and e.car_id=g.car_id(+) and e.car_seq=g.car_seq(+)"+
				"       and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				"       and n.car_mng_id=l.car_mng_id(+)"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}else{
			dt1		= "substr(a.sup_dt,1,6)";
			dt2		= "a.sup_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("6"))		query += " and "+dt2+" > to_char(sysdate-7,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals("") && !gubun1.equals("미지정"))	{
			if(gubun1.equals("스마일탁송")||gubun1.equals("스마일TS")){
				query += " and a.off_id = '010255' ";
			} else {
				query += " and a.off_nm='"+gubun1+"'";
			}
		}
		
		if(gubun1.equals("미지정"))	query += " and a.off_nm is null ";

		if(s_kd.equals("1"))	what = "d.br_id||d.br_nm";	
		if(s_kd.equals("2"))	what = "c.user_nm";	
		if(s_kd.equals("3"))	what = "nvl(h.car_nm,l.car_nm)";	
		if(s_kd.equals("4"))	what = "nvl(f.car_num,l.car_num)";	
		if(s_kd.equals("5"))	what = "decode(a.rent_l_cd,'','',b.firm_nm)";
		if(s_kd.equals("6"))	what = "a.b_yn";	

		if(s_kd.equals("6"))	t_wd = "Y";
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by 1, a.off_nm, c.br_id";	
		if(sort.equals("2"))	query += " order by 1, a.off_nm, c.user_nm";	
		if(sort.equals("3"))	query += " order by 1, a.off_nm, nvl(h.car_nm,l.car_nm)";	
		if(sort.equals("4"))	query += " order by 1, a.off_nm, nvl(f.car_num,l.car_num)";	
		if(sort.equals("5"))	query += " order by 1, a.off_nm, decode(a.rent_l_cd,'','',b.firm_nm)";
		if(sort.equals("7"))	query += " order by 1, a.off_nm, a.sup_dt";	

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
			System.out.println("[TintDatabase:getCarTintCList]\n"+e);
			System.out.println("[TintDatabase:getCarTintCList]\n"+query);
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

	//용품미확인현황 확인요청 담당자 리스트 조회
	public Vector getCarTintCSmsList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"       a.off_nm, i.user_id1 "+
				" from "+
				"       (SELECT doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
				"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
				"               sum(DECODE(tint_st,'1',nvl(r_tint_amt,0))) s1_amt, "+
				"               sum(DECODE(tint_st,'2',nvl(r_tint_amt,0))) s2_amt, "+
				"               sum(DECODE(tint_st,'3',nvl(r_tint_amt,0))) b_amt, "+
				"               sum(DECODE(tint_st,'4',nvl(r_tint_amt,0))) n_amt, "+
				"               sum(DECODE(tint_st,'5',nvl(r_tint_amt,0))) e_amt,  "+
				"               sum(DECODE(tint_st,'6',nvl(r_tint_amt,0))) ev_amt,  "+			//이동형충전기(2018.04.12)
				"               sum(nvl(r_tint_amt,0)) tot_amt,  "+
				"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(reg_id) reg_id, "+
				"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"               SUM(tint_su) tint_su "+
				"        FROM   CAR_TINT "+
				"        WHERE  tint_yn='Y' and doc_code > 0 and off_nm is not null "+
				"        and off_id not in ('010613') "+ //젤존코리아 대량구입 제외
				"        GROUP BY doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
				"	    ) a, "+
				"       (select * from doc_settle where doc_st='6' and doc_bit > '3')  i "+
				" where "+
				"       decode(a.tot_amt,0,decode(a.off_nm,'다옴방',1,0),a.tot_amt) > 0 "+
				"       and a.doc_code=i.doc_id "+
			    "       and i.user_dt5 is null "+
                " group by a.off_nm, i.user_id1  "+
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
			System.out.println("[TintDatabase:getCarTintCSmsList]\n"+e);
			System.out.println("[TintDatabase:getCarTintCSmsList]\n"+query);
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
	
	//용품미확인현황 확인요청 담당자 리스트 조회2
	public Vector getCarTintCSmsList2(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"       a.off_nm, i.user_id1, n.agent_emp_id, COUNT(*) un_count "+
				" from "+
				"       (SELECT doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
				"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
				"               sum(DECODE(tint_st,'1',nvl(r_tint_amt,0))) s1_amt, "+
				"               sum(DECODE(tint_st,'2',nvl(r_tint_amt,0))) s2_amt, "+
				"               sum(DECODE(tint_st,'3',nvl(r_tint_amt,0))) b_amt, "+
				"               sum(DECODE(tint_st,'4',nvl(r_tint_amt,0))) n_amt, "+
				"               sum(DECODE(tint_st,'5',nvl(r_tint_amt,0))) e_amt,  "+
				"               sum(DECODE(tint_st,'6',nvl(r_tint_amt,0))) ev_amt,  "+			//이동형충전기(2018.04.12)
				"               sum(nvl(r_tint_amt,0)) tot_amt,  "+
				"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(conf_dt) conf_dt, MIN(reg_id) reg_id, "+
				"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"               SUM(tint_su) tint_su "+
				"        FROM   CAR_TINT "+
				"        WHERE  tint_yn='Y' and doc_code > 0 "+
				"	  	   AND  off_id not in ('010613')"+
				"        GROUP BY doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
				"	    ) a, "+
				"       (select * from doc_settle where doc_st='6' and doc_bit in ('4','5','6') and doc_step='2' and user_dt4 is not null )  i, "+
				"       cont n, client b, users c, branch d, car_etc e, car_pur f, car_nm g, car_mng h, "+
				"       car_reg l "+
				" where "+
				"       decode(a.tot_amt,0,decode(a.off_nm,'다옴방',1,0),a.tot_amt) > 0 "+
				"       and a.doc_code=i.doc_id "+
				"		and i.user_dt5 is null "+	//미확인 인경우만 메세지
				"       and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				"       and n.client_id=b.client_id(+)"+
				"       and i.user_id1=c.user_id(+)"+
				"       and c.br_id=d.br_id(+)"+
				"       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				"       and e.car_id=g.car_id(+) and e.car_seq=g.car_seq(+)"+
				"       and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				"       and n.car_mng_id=l.car_mng_id(+)"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}else{
			dt1		= "substr(a.sup_dt,1,6)";
			dt2		= "a.sup_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("6"))		query += " and "+dt2+" > to_char(sysdate-7,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals("") && !gubun1.equals("미지정"))	{
			if(gubun1.equals("스마일탁송")||gubun1.equals("스마일TS")){
				query += " and a.off_id = '010255' ";
			} else {
				query += " and a.off_nm='"+gubun1+"'";
			}
		}
		
		if(gubun1.equals("미지정"))	query += " and a.off_nm is null ";

		if(s_kd.equals("1"))	what = "upper(nvl(d.br_id||d.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(nvl(h.car_nm,l.car_nm), ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(nvl(f.car_num,l.car_num), ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(decode(a.rent_l_cd,'','',b.firm_nm), ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(a.b_yn, ' '))";	

		if(s_kd.equals("6"))	t_wd = "Y";
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}
		
		query += " GROUP BY a.off_nm, i.user_id1, n.agent_emp_id ";
		
//System.out.println("query : " + query);
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
			System.out.println("[TintDatabase:getCarTintCSmsList2]\n"+e);
			System.out.println("[TintDatabase:getCarTintCSmsList2]\n"+query);
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

	//용품청구현황 리스트 조회
	public Vector getCarTintRList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"       decode(a.rent_l_cd,'','',b.firm_nm) firm_nm, c.user_nm, e.colo, c.dept_id, "+
				"       nvl(f.car_num,l.car_num) car_num2,"+
				"       nvl(h.car_nm,l.car_nm) car_nm2,"+
				"       l.car_no car_no2,"+
				"       f.rpt_no, f.dlv_est_dt, e.reg_est_dt, l.init_reg_dt, n.use_yn, "+
				"       decode(f.com_tint,'1','썬팅','2','브랜드키트','') com_tint_nm, "+
				"       decode(f.com_film_st,'1','루마','2','모비스','3','SKC','4','3M','') com_film_st_nm, "+
				"       i.doc_no, decode(i.user_dt5,'','미확인','확인') conf_st_nm, decode(i.user_dt6,'','미확인','확인') conf_st_nm2, "+
				"       a.* "+
				" from "+
				"       (SELECT doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
				"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
				"               sum(DECODE(tint_st,'1',nvl(r_tint_amt,0))) s1_amt, "+
				"               sum(DECODE(tint_st,'2',nvl(r_tint_amt,0))) s2_amt, "+
				"               sum(DECODE(tint_st,'3',nvl(r_tint_amt,0))) b_amt, "+
				"               sum(DECODE(tint_st,'4',nvl(r_tint_amt,0))) n_amt, "+
				"               sum(DECODE(tint_st,'5',nvl(r_tint_amt,0))) e_amt,  "+
				"               sum(DECODE(tint_st,'6',nvl(r_tint_amt,0))) ev_amt,  "+			//이동형충전기(2018.04.12)
				"               sum(nvl(r_tint_amt,0)) tot_amt,  "+
				"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(conf_dt) conf_dt, MIN(reg_id) reg_id, "+
				"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"               SUM(tint_su) tint_su "+
				"        FROM   CAR_TINT "+
				"        WHERE  tint_yn='Y' and doc_code > 0 "+
				"        GROUP BY doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
				"	    ) a, "+
				"       (select * from doc_settle where doc_st='6' and doc_bit in ('4','5','6') and doc_step='2' and user_dt4 is not null )  i, "+
				"       cont n, client b, users c, branch d, car_etc e, car_pur f, car_nm g, car_mng h, "+
				"       car_reg l "+
				" where "+
				"       decode(a.tot_amt,0,decode(a.off_nm,'다옴방',1,0),a.tot_amt) > 0 "+
				"       and a.doc_code=i.doc_id "+
				"       and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				"       and n.client_id=b.client_id(+)"+
				"       and i.user_id1=c.user_id(+)"+
				"       and c.br_id=d.br_id(+)"+
				"       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				"       and e.car_id=g.car_id(+) and e.car_seq=g.car_seq(+)"+
				"       and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				"       and n.car_mng_id=l.car_mng_id(+)"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}else{
			dt1		= "substr(a.sup_dt,1,6)";
			dt2		= "a.sup_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("6"))		query += " and "+dt2+" > to_char(sysdate-7,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals("") && !gubun1.equals("미지정"))	{
			if(gubun1.equals("스마일탁송")||gubun1.equals("스마일TS")){
				query += " and a.off_id = '010255' ";
			} else {
				query += " and a.off_nm='"+gubun1+"'";
			}
		}
		
		if(gubun1.equals("미지정"))	query += " and a.off_nm is null ";

		if(s_kd.equals("1"))	what = "upper(nvl(d.br_id||d.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(nvl(h.car_nm,l.car_nm), ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(nvl(f.car_num,l.car_num), ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(decode(a.rent_l_cd,'','',b.firm_nm), ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(a.b_yn, ' '))";	

		if(s_kd.equals("6"))	t_wd = "Y";
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, decode(c.br_id,'S1',1,'B1',2,'D1',3,'G1',4,'J1',5)";	
		if(sort.equals("2"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, c.user_nm";	
		if(sort.equals("3"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, nvl(h.car_nm,l.car_nm)";	
		if(sort.equals("4"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, nvl(f.car_num,l.car_num)";	
		if(sort.equals("5"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, decode(a.rent_l_cd,'','',b.firm_nm)";
		if(sort.equals("7"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, a.sup_dt";	

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
			System.out.println("[TintDatabase:getCarTintRList]\n"+e);
			System.out.println("[TintDatabase:getCarTintRList]\n"+query);
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

	//문서처리 리스트 조회
	public Vector getCarTintDList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select"+
					"        f.doc_id as req_code, a.off_id, a.req_dt, decode(a.off_nm,'다옴방','S1',c.br_id) br_id, "+
					"        min(a.off_nm) off_nm, count(a.tint_no) cnt, "+
					"        min(substr(a.sup_dt,1,8)) min_dt, max(substr(a.sup_dt,1,8)) max_dt, "+
					"        sum(a.s1_amt) s1_amt, "+
					"        sum(a.s2_amt) s2_amt, "+
					"        sum(a.b_amt) b_amt, "+
					"        sum(a.n_amt) n_amt, "+
					"        sum(a.e_amt) e_amt,  "+
					"        sum(a.ev_amt) ev_amt,  "+		//이동형충전기(2018.04.12)
					"        sum(tot_amt) tot_amt  "+
					" from   "+
					"       ("+
					"         SELECT req_code, doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
					"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
					"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
					"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
					"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
					"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
					"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
					"               sum(DECODE(tint_st,'1',nvl(r_tint_amt,0))) s1_amt, "+
					"               sum(DECODE(tint_st,'2',nvl(r_tint_amt,0))) s2_amt, "+
					"               sum(DECODE(tint_st,'3',nvl(r_tint_amt,0))) b_amt, "+
					"               sum(DECODE(tint_st,'4',nvl(r_tint_amt,0))) n_amt, "+
					"               sum(DECODE(tint_st,'5',nvl(r_tint_amt,0))) e_amt,  "+
					"               sum(DECODE(tint_st,'6',nvl(r_tint_amt,0))) ev_amt,  "+			//이동형충전기(2018.04.12)
					"               sum(nvl(r_tint_amt,0)) tot_amt,  "+
					"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(conf_dt) conf_dt, MIN(req_dt) req_dt, MIN(reg_id) reg_id, "+
					"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
					"               SUM(tint_su) tint_su "+
					"        FROM   CAR_TINT "+
					"        WHERE  tint_yn='Y' and doc_code > 0 "+
				    "               and req_dt is not null and pay_dt is null and conf_dt is not null "+
					"        GROUP BY req_code, doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
					"	    ) a, "+
					"        (select * from doc_settle where doc_st='6') b, users c, branch e, (select * from doc_settle where doc_st='7') f "+
					" where  a.doc_code=b.doc_id and b.user_id6=c.user_id(+) and c.br_id=e.br_id(+) and a.req_code=f.doc_id(+) "+
					"        and b.user_dt6 is not null";

		if(gubun1.equals("1"))							sub_query += " and a.req_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and a.req_dt like replace('"+st_dt+"%', '-','')||'%'";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		sub_query += " group by a.off_id, a.req_dt, decode(a.off_nm,'다옴방','S1',c.br_id), f.doc_id";

		query = " select"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='7') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and a.br_id=e.br_id(+)"+
				" and nvl(b.doc_step,'1') <> '3' ";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("6"))	what = "a.req_dt";

		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6")) {
				query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			} else if(s_kd.equals("2")) {
				if(t_wd.equals("스마일탁송")||t_wd.equals("스마일TS")){
					query += " and a.off_id = '010255' ";
				} else  {
					query += " and "+what+" like upper('%"+t_wd+"%') ";
				}		
			} else {
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}	
		}	

		query += " order by a.off_id, a.req_dt, a.br_id";


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
			System.out.println("[TintDatabase:getCarTintDList]\n"+e);
			System.out.println("[TintDatabase:getCarTintDList]\n"+query);
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

	//용품비용미지급현황 리스트 조회
	public Vector getCarTintNList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select"+
					"        f.doc_id as req_code, a.off_id, a.req_dt, decode(a.off_nm,'다옴방','S1',c.br_id) br_id, "+
					"        min(a.off_nm) off_nm, count(a.tint_no) cnt, "+
					"        min(substr(a.sup_dt,1,8)) min_dt, max(substr(a.sup_dt,1,8)) max_dt, "+
					"        sum(a.s1_amt) s1_amt, "+
					"        sum(a.s2_amt) s2_amt, "+
					"        sum(a.b_amt) b_amt, "+
					"        sum(a.n_amt) n_amt, "+
					"        sum(a.e_amt) e_amt,  "+
					"        sum(a.ev_amt) ev_amt,  "+		//이동형충전기(2018.04.12)
					"        sum(tot_amt) tot_amt  "+
					" from   "+
					"       (SELECT req_code, doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
					"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
					"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
					"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
					"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
					"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
					"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
					"               sum(DECODE(tint_st,'1',nvl(r_tint_amt,0))) s1_amt, "+
					"               sum(DECODE(tint_st,'2',nvl(r_tint_amt,0))) s2_amt, "+
					"               sum(DECODE(tint_st,'3',nvl(r_tint_amt,0))) b_amt, "+
					"               sum(DECODE(tint_st,'4',nvl(r_tint_amt,0))) n_amt, "+
					"               sum(DECODE(tint_st,'5',nvl(r_tint_amt,0))) e_amt,  "+
					"               sum(DECODE(tint_st,'6',nvl(r_tint_amt,0))) ev_amt,  "+			//이동형충전기(2018.04.12)
					"               sum(nvl(r_tint_amt,0)) tot_amt,  "+
					"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(conf_dt) conf_dt, MIN(req_dt) req_dt, MIN(reg_id) reg_id, "+
					"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
					"               SUM(tint_su) tint_su "+
					"        FROM   CAR_TINT "+
					"        WHERE  tint_yn='Y' and doc_code > 0 "+
				    "               and req_dt is not null and pay_dt is null and conf_dt is not null "+
					"        GROUP BY req_code, doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
					"	    ) a, "+
					"        (select * from doc_settle where doc_st='6') b, users c, branch e, (select * from doc_settle where doc_st='7' and doc_step='3') f "+
					" where  a.doc_code=b.doc_id and b.user_id6=c.user_id(+) and c.br_id=e.br_id(+) and a.req_code=f.doc_id "+
					" ";

		if(gubun1.equals("1"))							sub_query += " and a.req_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and a.req_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		sub_query += " group by a.off_id, a.req_dt, decode(a.off_nm,'다옴방','S1',c.br_id), f.doc_id";

		query = " select"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='7') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id and b.user_id1=c.user_id and b.user_id2=d.user_id(+) and a.br_id=e.br_id(+)"+
				" ";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("6"))	what = "a.req_dt";
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6")) {
				query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			} else if(s_kd.equals("2")) {
				if(t_wd.equals("스마일탁송")||t_wd.equals("스마일TS")){
					query += " and a.off_id = '010255' ";
				} else  {
					query += " and "+what+" like upper('%"+t_wd+"%') ";
				}		
			} else {
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}	
		}	

		query += " order by a.off_id, a.req_dt, a.br_id";


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
			System.out.println("[TintDatabase:getCarTintNList]\n"+e);
			System.out.println("[TintDatabase:getCarTintNList]\n"+query);
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

	//용품비용지급현황 리스트 조회
	public Vector getCarTintPList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query = "";
		String query = "";

		sub_query = " select"+
					"        f.doc_id as req_code, a.off_id, a.req_dt, a.pay_dt, decode(a.off_nm,'다옴방','S1',c.br_id) br_id, "+
					"        min(a.off_nm) off_nm, count(a.tint_no) cnt, "+
					"        min(substr(a.sup_dt,1,8)) min_dt, max(substr(a.sup_dt,1,8)) max_dt, "+
					"        sum(a.s1_amt) s1_amt, "+
					"        sum(a.s2_amt) s2_amt, "+
					"        sum(a.b_amt) b_amt, "+
					"        sum(a.n_amt) n_amt, "+
					"        sum(a.e_amt) e_amt,  "+
					"        sum(a.ev_amt) ev_amt,  "+			//이동형충전기(2018.04.12)
					"        sum(tot_amt) tot_amt  "+
					" from   "+
					"       (SELECT req_code, doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
					"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
					"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
					"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
					"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
					"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
					"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
					"               sum(DECODE(tint_st,'1',nvl(r_tint_amt,0))) s1_amt, "+
					"               sum(DECODE(tint_st,'2',nvl(r_tint_amt,0))) s2_amt, "+
					"               sum(DECODE(tint_st,'3',nvl(r_tint_amt,0))) b_amt, "+
					"               sum(DECODE(tint_st,'4',nvl(r_tint_amt,0))) n_amt, "+
					"               sum(DECODE(tint_st,'5',nvl(r_tint_amt,0))) e_amt,  "+
					"               sum(DECODE(tint_st,'6',nvl(r_tint_amt,0))) ev_amt,  "+			//이동형충전기(2018.04.12)
					"               sum(nvl(r_tint_amt,0)) tot_amt,  "+
					"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(conf_dt) conf_dt, MIN(req_dt) req_dt, MIN(pay_dt) pay_dt, MIN(reg_id) reg_id, "+
					"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
					"               SUM(tint_su) tint_su "+
					"        FROM   CAR_TINT "+
					"        WHERE  tint_yn='Y' and doc_code > 0 "+
				    "               and req_dt is not null and pay_dt is not null and conf_dt is not null "+
					"        GROUP BY req_code, doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
					"	    ) a, "+
					"        (select * from doc_settle where doc_st='6') b, users c, branch e, (select * from doc_settle where doc_st='7' and doc_step='3') f "+
					" where  a.doc_code=b.doc_id and b.user_id6=c.user_id(+) and c.br_id=e.br_id(+) and a.req_code=f.doc_id "+
					" ";

		if(gubun1.equals("1"))							sub_query += " and a.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and a.pay_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and a.pay_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		sub_query += " group by a.off_id, a.req_dt, a.pay_dt, decode(a.off_nm,'다옴방','S1',c.br_id), f.doc_id";

		query = " select"+
				" a.*, b.user_id1, b.user_id2, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, b.doc_no, e.br_nm"+
				" from ("+sub_query+") a, (select * from doc_settle where doc_st='7') b, users c, users d, branch e"+
				" where a.req_code=b.doc_id and b.user_id1=c.user_id and b.user_id2=d.user_id(+) and a.br_id=e.br_id(+)"+
				" ";

		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.br_id||e.br_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.off_nm, ' '))";	
		if(s_kd.equals("6"))	what = "a.req_dt";

			
	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("6")) {
				query += " and "+what+" like replace('%"+t_wd+"%', '-','')";
			} else if(s_kd.equals("2")) {
				if(t_wd.equals("스마일탁송")||t_wd.equals("스마일TS")){
					query += " and a.off_id = '010255' ";
				} else  {
					query += " and "+what+" like upper('%"+t_wd+"%') ";
				}		
			} else {
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}	
		}	

		query += " order by a.off_id, a.req_dt, a.br_id";


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
			System.out.println("[TintDatabase:getCarTintPList]\n"+e);
			System.out.println("[TintDatabase:getCarTintPList]\n"+query);
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

	//용품미정산현황 리스트 조회
	public Vector getCarTintMList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"       decode(a.rent_l_cd,'','',b.firm_nm) firm_nm, c.user_nm, e.colo, c.dept_id, "+
				"       nvl(f.car_num,l.car_num) car_num2,"+
				"       nvl(h.car_nm,l.car_nm) car_nm2,"+
				"       l.car_no car_no2,"+
				"       f.rpt_no, f.dlv_est_dt, e.reg_est_dt, l.init_reg_dt, n.use_yn, "+
				"       decode(f.com_tint,'1','썬팅','2','브랜드키트','') com_tint_nm, "+
				"       decode(f.com_film_st,'1','루마','2','모비스','3','SKC','4','3M','') com_film_st_nm, "+
				"       i.doc_no, i.doc_bit, "+
				"       a.* "+
				" from "+
				"       (SELECT doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
				"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
				"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(reg_id) reg_id, MIN(req_dt) req_dt, MIN(pay_dt) pay_dt, "+
				"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"               SUM(tint_su) tint_su "+
				"        FROM   CAR_TINT "+
			    "        where  tint_yn='Y' "+
				"        GROUP BY doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
				"	    ) a, "+
				"       (select * from doc_settle where doc_st='6')  i, "+
				"       cont n, client b, users c, branch d, car_etc e, car_pur f, car_nm g, car_mng h, "+
				"       car_reg l "+
				" where "+
				"       a.doc_code=i.doc_id(+) "+
				"       and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				"       and n.client_id=b.client_id(+)"+
				"       and i.user_id1=c.user_id(+)"+
				"       and c.br_id=d.br_id(+)"+
				"       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				"       and e.car_id=g.car_id(+) and e.car_seq=g.car_seq(+)"+
				"       and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+)"+
				"       and n.car_mng_id=l.car_mng_id(+)"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.reg_dt,1,6)";
			dt2		= "a.reg_dt";
		}else if(gubun3.equals("3")){
			dt1		= "substr(a.sup_dt,1,6)";
			dt2		= "a.sup_dt";
		}else if(gubun3.equals("4")){
			dt1		= "substr(a.req_dt,1,6)";
			dt2		= "a.req_dt";
		}else if(gubun3.equals("5")){
			dt1		= "substr(a.pay_dt,1,6)";
			dt2		= "a.pay_dt";
		}else{
			dt1		= "substr(a.sup_est_dt,1,6)";
			dt2		= "a.sup_est_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("4"))		query += " and "+dt2+" like to_char(sysdate+1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(sysdate-1,'YYYYMMDD')||'%'";
		else if(gubun2.equals("6"))		query += " and "+dt2+" > to_char(sysdate-7,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun1.equals("") && !gubun1.equals("미지정"))	{
			if(gubun1.equals("스마일탁송")||gubun1.equals("스마일TS")){
				query += " and a.off_id = '010255' ";
			} else {
				query += " and a.off_nm='"+gubun1+"'";
			}
		}
		
		if(gubun1.equals("미지정"))	query += " and a.off_nm is null ";

		if(s_kd.equals("1"))	what = "upper(nvl(d.br_id||d.br_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(nvl(h.car_nm,l.car_nm), ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(nvl(f.car_num,l.car_num), ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(decode(a.rent_l_cd,'','',b.firm_nm), ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(a.b_yn, ' '))";	

		if(s_kd.equals("6"))	t_wd = "Y";
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(sort.equals("1"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, decode(c.br_id,'S1',1,'B1',2,'D1',3,'G1',4,'J1',5)";	
		if(sort.equals("2"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, c.user_nm";	
		if(sort.equals("3"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, nvl(h.car_nm,l.car_nm)";	
		if(sort.equals("4"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, nvl(f.car_num,l.car_num)";	
		if(sort.equals("5"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, decode(a.rent_l_cd,'','',b.firm_nm)";
		if(sort.equals("6"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, a.reg_dt";	
		if(sort.equals("7"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, a.sup_est_dt";	
		if(sort.equals("8"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, f.dlv_est_dt";	
		if(sort.equals("9"))	query += " order by decode(c.dept_id,'1000',1,2), a.off_nm, e.reg_est_dt";	

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
			System.out.println("[TintDatabase:getCarTintMList]\n"+e);
			System.out.println("[TintDatabase:getCarTintMList]\n"+query);
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

	//미확인요청메시지 전송대상조회
	public Vector getCarTintReqTarget(String user_id, String req_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        b.user_id1, c.agent_emp_id "+
				" from   car_tint a, (select * from doc_settle where doc_st='6') b, cont c "+
				" where  a.req_code='"+req_code+"' and a.doc_code=b.doc_id and a.conf_dt is null and b.user_id2='"+user_id+"' and a.rent_l_cd=c.rent_l_cd(+) "+
				" group by b.user_id1, c.agent_emp_id order by b.user_id1";

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
			System.out.println("[TintDatabase:getCarTintReqTarget]\n"+e);
			System.out.println("[TintDatabase:getCarTintReqTarget]\n"+query);
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

	//용품비용문서 리스트 조회
	public Vector getCarTintNotPayOffList(String off_id, String req_dt, String br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, h.firm_nm, decode(f.bus_st, '1','','2','영업사원','3','','4','','5','','6','','7','에이젼트') bus_st_nm, i.car_no, i.car_nm "+
				" from   "+
				"       (SELECT doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
				"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
				"               sum(DECODE(tint_st,'1',nvl(r_tint_amt,0))) s1_amt, "+
				"               sum(DECODE(tint_st,'2',nvl(r_tint_amt,0))) s2_amt, "+
				"               sum(DECODE(tint_st,'3',nvl(r_tint_amt,0))) b_amt, "+
				"               sum(DECODE(tint_st,'4',nvl(r_tint_amt,0))) n_amt, "+
				"               sum(DECODE(tint_st,'5',nvl(r_tint_amt,0))) e_amt,  "+
				"               sum(DECODE(tint_st,'6',nvl(r_tint_amt,0))) ev_amt,  "+			//이동형충전기(2018.04.12)
				"               sum(nvl(r_tint_amt,0)) tot_amt,  "+
				"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(conf_dt) conf_dt, MIN(reg_id) reg_id, "+
				"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"               SUM(tint_su) tint_su "+
				"        FROM   CAR_TINT "+
				"        WHERE  tint_yn='Y' and doc_code > 0 "+
				"               and off_id='"+off_id+"' and req_dt=replace('"+req_dt+"','-','')"+
			    "               and req_dt is not null and pay_dt is null and conf_dt is not null "+
				"        GROUP BY doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
				"	    ) a, "+
			    "        (select * from doc_settle where doc_st='6') b, users c, users d, branch e, users g, cont f, client h, car_reg i "+
				" where  "+
				"        a.doc_code=b.doc_id "+
				"        and b.user_id1=c.user_id and b.user_id2=d.user_id and b.user_id7=g.user_id(+) and g.br_id=e.br_id(+) "+
				"        and b.user_dt2 is not null "+
				"        and b.user_dt3 is not null "+
				"        and b.user_dt6 is not null"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.client_id=h.client_id(+) and f.car_mng_id=i.car_mng_id(+) "+
				" order by a.sup_est_dt";

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
			System.out.println("[TintDatabase:getCarTintNotPayOffList]\n"+e);
			System.out.println("[TintDatabase:getCarTintNotPayOffList]\n"+query);
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

	//청구서작성 리스트 조회
	public Vector getCarTintReqDocList(String req_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"        a.*, c.user_nm as user_nm1, d.user_nm as user_nm2, b.user_dt1, b.user_dt2, h.firm_nm, decode(f.bus_st, '1','','2','영업사원','3','','4','','5','','6','','7','에이젼트') bus_st_nm, i.car_no, i.car_nm "+
				" from   "+
				"       (SELECT req_code, doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no,  "+
				"               MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"               MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"               MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"               MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"               MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn,  "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
				"               sum(DECODE(tint_st,'1',nvl(r_tint_amt,0))) s1_amt, "+
				"               sum(DECODE(tint_st,'2',nvl(r_tint_amt,0))) s2_amt, "+
				"               sum(DECODE(tint_st,'3',nvl(r_tint_amt,0))) b_amt, "+
				"               sum(DECODE(tint_st,'4',nvl(r_tint_amt,0))) n_amt, "+
				"               sum(DECODE(tint_st,'5',nvl(r_tint_amt,0))) e_amt,  "+
				"               sum(DECODE(tint_st,'6',nvl(r_tint_amt,0))) ev_amt,  "+			//이동형충전기(2018.04.12)
				"               sum(nvl(r_tint_amt,0)) tot_amt,  "+
				"               min(sup_est_dt) sup_est_dt, min(sup_dt) sup_dt, MIN(reg_dt) reg_dt, MIN(conf_dt) conf_dt, MIN(req_dt) req_dt, MIN(reg_id) reg_id, "+
				"               MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"               SUM(tint_su) tint_su "+
				"        FROM   CAR_TINT "+
				"        WHERE  tint_yn='Y' and req_code='"+req_code+"' and doc_code > 0 "+
			    "               and req_dt is not null and conf_dt is not null "+
				"        GROUP BY req_code, doc_code, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0')  "+
				"	    ) a, "+
				"        (select * from doc_settle where doc_st='6' AND doc_step='3') b, "+
				"        (select * from doc_settle where doc_st='7') g, "+
				"        users c, users d, branch e, "+
				"        cont f, client h, car_reg i "+
				" where  a.req_code='"+req_code+"' "+
				"        and a.doc_code=b.doc_id and b.user_id1=c.user_id and b.user_id2=d.user_id and c.br_id=e.br_id "+
				"        and a.req_code=g.doc_id"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and f.client_id=h.client_id(+) and f.car_mng_id=i.car_mng_id(+) "+
				" ";

		query += " order by a.off_id, a.sup_est_dt";

			
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
			System.out.println("[TintDatabase:getCarTintReqDocList]\n"+e);
			System.out.println("[TintDatabase:getCarTintReqDocList]\n"+query);
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

	//블랙박스파일생성 리스트
	public Vector getCarTintInsBlackFileList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort, String rent_or_lease, String con_f)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				"       a.tint_no, a.rent_mng_id, a.rent_l_cd, a.com_nm, a.model_nm, a.serial_no, a.sup_dt, a.com_nm, a.model_nm, a.serial_no, "+
				"       l.car_no, l.car_nm, l.car_num, l.init_reg_dt, z.con_f_nm, z.ins_start_dt, z.blackbox_yn, z.ins_com_id, z.ins_com_nm, " +
				"		z.blackbox_nm, z.blackbox_no, z.car_mng_id, z.ins_st, "+
				"       h2.attach_file_type1, h2.attach_file_seq1, "+
				"       h2.attach_file_type2, h2.attach_file_seq2, "+
				"       h2.file_reg_dt, n.bus_id, n.car_st, b.user_nm as bus_nm, e.client_st  "+
				" from "+
			    //용품 
				"       (SELECT tint_no, rent_mng_id, rent_l_cd, com_nm, model_nm, serial_no, substr(sup_dt,1,8) sup_dt "+
				"        FROM   CAR_TINT "+
				"        WHERE  tint_st='3' and tint_yn='Y'"+
				"       ) a, "+
				"       cont n, car_reg l, users b, client e,"+
				//보험
				"       (select a.car_mng_id, a.ins_start_dt, a.blackbox_yn, a.ins_com_id, c.ins_com_nm, a.blackbox_nm, a.blackbox_amt, a.blackbox_no, a.blackbox_dt, a.con_f_nm, a.ins_st "+
				"        from   insur a, ins_cls b, ins_com c  "+
				"        where  a.car_mng_id = b.car_mng_id(+) and a.ins_st = b.ins_st(+) and a.ins_com_id=c.ins_com_id "+
				"               and  to_char(sysdate,'YYYYMMDD')  between to_char(to_date(a.ins_start_dt) + 1 , 'yyyymmdd')  and decode(b.car_mng_id, null, a.ins_exp_dt, b.exp_dt)  "+
				"       ) z, \n"+
				//사진
				"       (select SUBSTR(content_seq,1,12) tint_no, "+
				"	            max(decode(substr(content_seq,13),'1',file_type)) attach_file_type1, max(decode(substr(content_seq,13),'1',seq)) attach_file_seq1, "+
				"	            max(decode(substr(content_seq,13),'2',file_type)) attach_file_type2, max(decode(substr(content_seq,13),'2',seq)) attach_file_seq2, "+
				"	            TO_CHAR(MAX(reg_date),'YYYYMMDD') file_reg_dt "+
				"	     from   ACAR_ATTACH_FILE "+
				"	     where  ISDELETED='N' and content_code='TINT' "+
				"	     group by SUBSTR(content_seq,1,12) "+
				"	    ) h2 "+
				" where "+
				"       a.rent_mng_id=n.rent_mng_id and a.rent_l_cd=n.rent_l_cd "+
				"       and n.car_mng_id=l.car_mng_id(+) "+
				"       and n.car_mng_id=z.car_mng_id(+) "+
				"       and n.bus_id=b.user_id "+
				"       and a.tint_no=h2.tint_no(+) "+
				"       and n.client_id=e.client_id "+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("1")){
			dt1		= "substr(a.sup_dt,1,6)";
			dt2		= "a.sup_dt";
		}else if(gubun3.equals("2")){
			dt1		= "substr(z.ins_start_dt,1,6)";
			dt2		= "z.ins_start_dt";
		}else if(gubun3.equals("3")){
			dt1		= "substr(l.init_reg_dt,1,6)";
			dt2		= "l.init_reg_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate+1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("6"))		query += " and "+dt2+" > to_char(sysdate-7,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}


		if(s_kd.equals("1"))	what = "upper(nvl(z.ins_com_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(l.car_no, ' '))";	
		if(s_kd.equals("1") || s_kd.equals("2")){
			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}	
		}
		if(s_kd.equals("3")){
				query += " and a.serial_no is null ";
		}
		
		if(rent_or_lease.equals("2")){ // 렌트
			query += " and n.car_st = '1' ";
		} else if(rent_or_lease.equals("3")){ // 리스
			query += " and n.car_st = '3' ";
		}
		
		if(con_f.equals("2")){ // 피보험자 아마존카
			query += " and z.con_f_nm like '%아마존카%' ";
		} else if(con_f.equals("3")){ // 피보험자 고객
			query += " and z.con_f_nm not like '%아마존카%' ";
		}
		
		if(sort.equals("1"))	query += " order by a.sup_dt desc";	
		if(sort.equals("2"))	query += " order by z.ins_com_nm, a.sup_dt desc";	

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
			System.out.println("[TintDatabase:getCarTintInsBlackFileList]\n"+e);
			System.out.println("[TintDatabase:getCarTintInsBlackFileList]\n"+query);
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


	//블랙박스파일조회 리스트
	public Hashtable getCarTintInsBlackFileList(String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select"+
				"       a.tint_no, a.rent_mng_id, a.rent_l_cd, a.com_nm, a.model_nm, a.serial_no, a.sup_dt, "+
				"       l.car_no, l.car_nm, l.car_num, z.ins_start_dt, z.blackbox_yn, z.ins_com_id, z.ins_com_nm,  "+
				"       h2.attach_file_type1, h2.attach_file_seq1, "+
				"       h2.attach_file_type2, h2.attach_file_seq2, "+
				"       h2.file_reg_dt, n.bus_id, b.user_nm as bus_nm  "+
				" from "+
				"       (SELECT tint_no, rent_mng_id, rent_l_cd, com_nm, model_nm, serial_no, substr(sup_dt,1,8) sup_dt FROM CAR_TINT WHERE  tint_st='3' and tint_yn='Y') a, "+
				"       cont n, car_reg l, users b, "+
				"       ( select a.car_mng_id, a.ins_start_dt, a.blackbox_yn, a.ins_com_id, c.ins_com_nm  from insur a, ins_cls b, ins_com c  where  a.car_mng_id = b.car_mng_id(+) and a.ins_st = b.ins_st(+) and a.ins_com_id=c.ins_com_id and  to_char(sysdate,'YYYYMMDD')  between to_char(to_date(a.ins_start_dt,'yyyymmdd') + 1 , 'yyyymmdd')  and decode(b.car_mng_id, null, a.ins_exp_dt, b.exp_dt)  ) z, \n"+
				//사진
				"       (select SUBSTR(content_seq,1,12) tint_no, "+
				"	            max(decode(substr(content_seq,13),'1',file_type)) attach_file_type1, max(decode(substr(content_seq,13),'1',seq)) attach_file_seq1, "+
				"	            max(decode(substr(content_seq,13),'2',file_type)) attach_file_type2, max(decode(substr(content_seq,13),'2',seq)) attach_file_seq2, "+
				"	            TO_CHAR(MAX(reg_date),'YYYYMMDD') file_reg_dt "+
				"	     from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='TINT' group by SUBSTR(content_seq,1,12)) h2 "+
				" where "+
				"       a.rent_mng_id=n.rent_mng_id and a.rent_l_cd=n.rent_l_cd "+
				"       and n.car_mng_id=l.car_mng_id(+) "+
				"       and n.car_mng_id=z.car_mng_id(+) "+
				"       and n.bus_id=b.user_id "+
				"       and a.tint_no=h2.tint_no(+) "+
				" ";
		query += "and upper(nvl(l.car_no, ' ')) like upper('%"+t_wd+"%') ";

		try {
								
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[TintDatabase:getCarTintInsBlackFileList]\n"+e);
			System.out.println("[TintDatabase:getCarTintInsBlackFileList]\n"+query);
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
	
	//용품점 문자 메세지 일괄 송신 위한 수신인 fetch(2017.11.28)
	public Hashtable getUserInfoForSendSMS(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select"+
				"       c.user_id AS rece_id1, c.user_nm AS rece_nm1, "+
				"		y.user_id AS rece_id2, y.user_nm AS rece_nm2, "+	//본사차량등록자	
//				"       n.mng_id AS rece_id2, x.user_nm AS rece_nm2,  "+	//관리담당자
				"       n.agent_emp_id AS rece_id4, z.emp_nm as rece_nm4, z.emp_m_tel AS rece_tel4, "+
				"       decode(f.udt_st,'1','본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점','') udt_st, "+
				"       nvl(h.car_nm,l.car_nm) car_nm,  "+
				"       l.car_no car_no, f.rpt_no, a.off_nm, a.rent_mng_id, a.rent_l_cd ,b.client_nm  "+
				" from "+
				"       (SELECT reg_st, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') tint_type, min(tint_no) tint_no, "+
				"       		MIN(DECODE(tint_st,'1',DECODE(tint_yn,'Y','Y'))) s1_yn, "+
				"       		MIN(DECODE(tint_st,'2',DECODE(tint_yn,'Y','Y'))) s2_yn, "+
				"      		    MIN(DECODE(tint_st,'3',DECODE(tint_yn,'Y','Y'))) b_yn, "+
				"	            MIN(DECODE(tint_st,'4',DECODE(tint_yn,'Y','Y'))) n_yn, "+
				"	            MIN(DECODE(tint_st,'5',DECODE(tint_yn,'Y','Y'))) e_yn, "+
				"               MIN(DECODE(tint_st,'6',DECODE(tint_yn,'Y','Y'))) ev_yn,  "+		//이동형충전기(2018.04.12)
				"	            MIN(DECODE(tint_st,'1',sun_per)) s1_sun_per, "+
				"	    		MIN(DECODE(tint_st,'2',sun_per)) s2_sun_per, "+
				"	    		min(sup_est_dt) sup_est_dt, MIN(reg_dt) reg_dt, MIN(reg_id) reg_id, "+
				"	    		MIN(com_nm||' '||model_nm||' '||tint_su||'개 - '||etc) com_model_nm, "+
				"	    		SUM(tint_su) tint_su "+
				"	       FROM  CAR_TINT "+
				"	       WHERE tint_yn='Y' and doc_code IS NULL "+
				"	    	 and off_nm not in ('고객장착','수입차') "+
				"	       GROUP BY reg_st, off_id, off_nm, rent_mng_id, rent_l_cd, client_id, decode(rent_l_cd,'',tint_no,'0') "+
				"	     ) a, "+
				"		(SELECT a.user_id , a.user_nm FROM users a, us_me_w b WHERE a.user_id = b.user_id AND b.w_nm = '차량등록자' AND b.w_st = 'solo') y,	"+	//차량등록자 조회 위해 추가
				"	      cont n, client b, users c, branch d, car_etc e, car_pur f, car_nm g, car_mng h, car_reg l, cls_cont i, car_off_emp z, users x "+
				" where "+
				"       a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+) "+
				"       and n.client_id=b.client_id(+) "+
				"       and a.reg_id=c.user_id(+) "+
				"       and c.br_id=d.br_id(+) "+
				"       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) "+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) "+
				"       and e.car_id=g.car_id(+) and e.car_seq=g.car_seq(+) "+
				"       and g.car_comp_id=h.car_comp_id(+) and g.car_cd=h.code(+) "+
				"       and n.car_mng_id=l.car_mng_id(+) "+
				"       and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and nvl(i.cls_st,'0')<>'7' "+
				"       and n.agent_emp_id =z.emp_id(+) "+
				"       and n.mng_id =x.user_id "+
				"       AND a.rent_l_cd = '"+ rent_l_cd +"'";

		try {					
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[TintDatabase:getUserInfoForSendSMS]\n"+e);
			System.out.println("[TintDatabase:getUserInfoForSendSMS]\n"+query);
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
	
	//용품점 문자 메세지 일괄 송신 위한 지점 당직자 fetch(2017.11.28)
	public Hashtable getWorkerInfoForSendSMS(String curY, String curM, String curD, String watch_type)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT a.member_id5, b.user_nm as member_nm5, a.member_id6, c.user_nm as member_nm6 "+
				"   FROM sch_watch a, users b, users c "+
				"  WHERE 1=1 " +
				"    AND a.member_id5 = b.user_id " +
				"    AND a.member_id6 = c.user_id " +
				"    AND a.start_year = '"+ curY +"'" +
				"    AND a.start_mon  = '"+ curM +"'" +
				"    AND a.start_day  = '"+ curD +"'" +
				"    AND a.watch_type = '"+ watch_type +"'" ;
		try {					
				pstmt = conn.prepareStatement(query);
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
			System.out.println("[TintDatabase:getWorkerInfoForSendSMS]\n"+e);
			System.out.println("[TintDatabase:getWorkerInfoForSendSMS]\n"+query);
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

}