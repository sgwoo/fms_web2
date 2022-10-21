package acar.ars_card;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class ArsCardDatabase
{

	private Connection conn = null;
	public static ArsCardDatabase db;
	

	public static ArsCardDatabase getInstance()
	{
		if(ArsCardDatabase.db == null)
			ArsCardDatabase.db = new ArsCardDatabase();
		return ArsCardDatabase.db;
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


	public String insertArsCard(ArsCardBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String ars_code = "";

		String query =  " insert into ars_card "+
						"           ( ars_code, client_id, reg_id, reg_dt, buyr_name, buyr_tel2, buyr_mail, "+
						"             good_name, good_cont, good_mny, card_kind, card_no, card_y_mm, card_y_yy, quota, settle_mny, card_fee, "+
						"             exempt_yn, exempt_cau, ars_content, card_per, ars_step, app_st, settle_mny_1, settle_mny_2, m_card_fee, "+
						"             bus_nm, mng_nm "+
						"           ) values "+
						"           ( ?, ?, ?, SYSDATE, ?, ?, ?, "+
						"             ?, ?, ?, ?, REPLACE(REPLACE(?,' ',''),'-',''), ?, ?, ?, ?, ?,"+
						"             ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						"             ?, ? "+
						"           ) ";

		String qry_id = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(ars_code,9,4))+1), '0000')), '0001') ars_code "+
						" from   ars_card "+
						" where  substr(ars_code,1,8)=to_char(sysdate,'YYYYMMDD')";


		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			while(rs.next())
			{
				ars_code = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			conn.commit();
		}catch(Exception e){					
	        try{
				System.out.println("[ArsCardDatabase:insertArsCard]"+e);
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
			
			if(bean.getArs_code().equals("")){
				pstmt2.setString(1,  ars_code.trim()		    );
			}else{
				pstmt2.setString(1,  bean.getArs_code ().trim());
				ars_code = bean.getArs_code();
			}
			pstmt2.setString(2,  bean.getClient_id    ());
			pstmt2.setString(3,  bean.getReg_id       ());
			pstmt2.setString(4,  bean.getBuyr_name    ());
			pstmt2.setString(5,  bean.getBuyr_tel2    ());
			pstmt2.setString(6,  bean.getBuyr_mail    ());
			pstmt2.setString(7,  bean.getGood_name    ());
			pstmt2.setString(8 , bean.getGood_cont    ());
			pstmt2.setInt   (9,  bean.getGood_mny     ());
			pstmt2.setString(10, bean.getCard_kind    ());
			pstmt2.setString(11, bean.getCard_no      ());
			pstmt2.setString(12, bean.getCard_y_mm    ());
			pstmt2.setString(13, bean.getCard_y_yy    ());
			pstmt2.setString(14, bean.getQuota        ());
			pstmt2.setInt   (15, bean.getSettle_mny   ());
			pstmt2.setInt   (16, bean.getCard_fee     ());
			pstmt2.setString(17, bean.getExempt_yn    ());
			pstmt2.setString(18, bean.getExempt_cau   ());
			pstmt2.setString(19, bean.getArs_content  ());
			pstmt2.setString(20, bean.getCard_per     ());
			pstmt2.setString(21, bean.getArs_step     ());
			pstmt2.setString(22, bean.getApp_st	      ());
			pstmt2.setInt   (23, bean.getSettle_mny_1 ());
			pstmt2.setInt   (24, bean.getSettle_mny_2 ());
			pstmt2.setInt   (25, bean.getM_card_fee   ());
			pstmt2.setString(26, bean.getBus_nm	      ());
			pstmt2.setString(27, bean.getMng_nm	      ());
			pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ArsCardDatabase:insertArsCard]\n"+e);
			e.printStackTrace();
	  		flag = false;
			ars_code = "";
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return ars_code;
		}
	}

	public boolean updateArsCard(ArsCardBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update ars_card set "+
                        "        buyr_name = ?, "+
                        "        buyr_tel2 = ?, "+
                        "        buyr_mail = ?, "+
                        "        good_name = ?, "+
                        "        good_cont = ?, "+
                        "        good_mny  = ?, "+
                        "        card_kind = ?, "+
                        "        card_no   = ?, "+
                        "        card_y_mm = ?, "+
                        "        card_y_yy = ?, "+
                        "        quota	   = ?, "+
                        "        settle_mny= ?, "+
                        "        card_fee  = ?, "+
                        "        exempt_cau= ?, "+
                        "        app_st    = ?  "+
						" where  ars_code	= ?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);	
			pstmt.setString(1,  bean.getBuyr_name    ());
			pstmt.setString(2,  bean.getBuyr_tel2    ());
			pstmt.setString(3,  bean.getBuyr_mail    ());
			pstmt.setString(4,  bean.getGood_name    ());
			pstmt.setString(5 , bean.getGood_cont    ());
			pstmt.setInt   (6,  bean.getGood_mny     ());
			pstmt.setString(7,  bean.getCard_kind    ());
			pstmt.setString(8,  bean.getCard_no      ());
			pstmt.setString(9,  bean.getCard_y_mm    ());
			pstmt.setString(10, bean.getCard_y_yy    ());
			pstmt.setString(11, bean.getQuota        ());
			pstmt.setInt   (12, bean.getSettle_mny   ());
			pstmt.setInt   (13, bean.getCard_fee     ());
			pstmt.setString(14, bean.getExempt_cau   ());
			pstmt.setString(15, bean.getApp_st		 ());
			pstmt.setString(16, bean.getArs_code	 ());
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ArsCardDatabase:updateArsCard]\n"+e);
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

	public boolean updateArsCardApp(String ars_code, String app_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		
//		String query =  " delete from ars_card "+
//						" where  ars_code	= ?";

		String query =  " update ars_card set app_id = '"+app_id+"', app_dt = sysdate where  ars_code	= '"+ars_code+"'";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);	
			//pstmt.setString(1,  bean.getApp_id  	());
			//pstmt.setString(2,  bean.getArs_code	());
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ArsCardDatabase:updateArsCardApp]\n"+e);
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
	
	public boolean updateArsCardCancel(String ars_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		
		String query =  " update ars_card set cancel_dt = to_char(sysdate,'YYYYMMDD') where  ars_code	= '"+ars_code+"'";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);	
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ArsCardDatabase:updateArsCardCancel]\n"+e);
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
	
	public boolean updateArsStep(String ars_code, String ars_step)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		
		String query =  " update ars_card set ars_step = '"+ars_step+"' where ars_code = '"+ars_code+"'";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);	
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ArsCardDatabase:updateArsStep]\n"+e);
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

	public boolean deleteArsCard(String ars_code)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " DELETE FROM ARS_CARD WHERE ars_code= ? and app_dt is null ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1,  ars_code);
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
		}catch(Exception e){
			System.out.println("[ArsCardDatabase:deleteArsCard]\n"+e);
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

	//한건 조회
	public ArsCardBean getArsCard(String ars_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArsCardBean bean = new ArsCardBean();
		String query = "";
		query = " select * from ars_card where ars_code = '"+ars_code+"' ";

		try{
			pstmt = conn.prepareStatement(query);			
		   	rs = pstmt.executeQuery();
		   	
			if(rs.next())
			{
				bean.setArs_code     (rs.getString("ars_code")		==null?"":rs.getString("ars_code"));
				bean.setClient_id    (rs.getString("client_id")		==null?"":rs.getString("client_id"));
				bean.setReg_dt       (rs.getString("reg_dt")		==null?"":rs.getString("reg_dt"));	
				bean.setReg_id       (rs.getString("reg_id")		==null?"":rs.getString("reg_id"));
	 			bean.setBuyr_name    (rs.getString("buyr_name")		==null?"":rs.getString("buyr_name"));	
	 			bean.setBuyr_tel2    (rs.getString("buyr_tel2")		==null?"":rs.getString("buyr_tel2"));	
				bean.setBuyr_mail    (rs.getString("buyr_mail")		==null?"":rs.getString("buyr_mail"));
				bean.setGood_name    (rs.getString("good_name")		==null?"":rs.getString("good_name"));
				bean.setGood_cont    (rs.getString("good_cont")		==null?"":rs.getString("good_cont"));
				bean.setGood_mny     (rs.getInt   ("good_mny"));
				bean.setCard_kind    (rs.getString("card_kind")		==null?"":rs.getString("card_kind"));	
				bean.setCard_no      (rs.getString("card_no")		==null?"":rs.getString("card_no"));
				bean.setCard_y_mm    (rs.getString("card_y_mm")		==null?"":rs.getString("card_y_mm"));
				bean.setCard_y_yy    (rs.getString("card_y_yy")		==null?"":rs.getString("card_y_yy"));
				bean.setQuota        (rs.getString("quota")			==null?"":rs.getString("quota"));
				bean.setApp_id       (rs.getString("app_id")		==null?"":rs.getString("app_id"));
				bean.setApp_dt       (rs.getString("app_dt")		==null?"":rs.getString("app_dt"));
				bean.setApp_st       (rs.getString("app_st")		==null?"":rs.getString("app_st"));
				bean.setSettle_mny   (rs.getInt   ("settle_mny"));
				bean.setCard_fee     (rs.getInt   ("card_fee"));
				bean.setExempt_yn    (rs.getString("exempt_yn")		==null?"":rs.getString("exempt_yn"));
				bean.setExempt_cau   (rs.getString("exempt_cau")	==null?"":rs.getString("exempt_cau"));
				bean.setArs_content  (rs.getString("ars_content")	==null?"":rs.getString("ars_content"));
				bean.setCard_per     (rs.getString("card_per")		==null?"":rs.getString("card_per"));
				bean.setArs_step     (rs.getString("ars_step")		==null?"":rs.getString("ars_step"));
				bean.setSettle_mny_1 (rs.getInt   ("settle_mny_1"));
				bean.setSettle_mny_2 (rs.getInt   ("settle_mny_2"));
				bean.setM_card_fee   (rs.getInt   ("m_card_fee"));
				bean.setBus_nm       (rs.getString("bus_nm")		==null?"":rs.getString("bus_nm"));
				bean.setMng_nm       (rs.getString("mng_nm")		==null?"":rs.getString("mng_nm"));
				bean.setCancel_dt    (rs.getString("cancel_dt")		==null?"":rs.getString("cancel_dt"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ArsCardDatabase:getArsCard]\n"+e);
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


	//미지급현황 리스트 조회
	public Vector getArsCardMngList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT c.doc_no, b.user_nm, decode(a.app_dt,'','대기','결제완료') st_nm, decode(a.app_st,'3','SMS결제','ARS수기') app_st_nm, to_char(a.reg_dt,'YYYYMMDD') reg_dt, a.* , nvl(d.ip_dt, '-') ip_dt  \n"+
				" FROM   ARS_CARD a, USERS b, (select doc_no, doc_id from doc_settle where doc_st='35') c ,   \n"+
				"   (select b.incom_dt ip_dt, a.* from incom a, incom_item b where a.ip_method ='2' and a.jung_type ='6' and a.card_cd = '13' and a.incom_dt = b.item_dt and a.incom_seq = b.item_seq ) d   \n"+
				" WHERE  a.reg_id=b.user_id(+) and a.ars_code=c.doc_id(+) \n"+
				" and    to_char(a.app_dt, 'yyyymmdd') = d.incom_dt(+) and a.approvalno = d.approvalno(+) \n"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		//대기
		if(gubun3.equals("2")){
			query += " and a.app_dt is null "; 
		}else{
			dt1 = "to_char(a.reg_dt,'YYYYMM')";
			dt2 = "to_char(a.reg_dt,'YYYYMMDD')";

			if(gubun4.equals("2")){
				dt1 = "to_char(a.app_dt,'YYYYMM')";
				dt2 = "to_char(a.app_dt,'YYYYMMDD')";
			}


			if(gubun1.equals("2"))							query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
			else if(gubun1.equals("1"))						query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			else if(gubun1.equals("4"))						query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";//전일
			else if(gubun1.equals("3")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			if(gubun3.equals("3"))	query += " and a.app_dt is not null "; 
		}

		//카드종류
		if(!gubun2.equals(""))	query += " and a.card_kind = '"+gubun2+"'"; 

		if(s_kd.equals("1"))	what = "a.buyr_name";
		if(s_kd.equals("2"))	what = "a.good_mny";	
		if(s_kd.equals("3"))	what = "a.good_name";	
		if(s_kd.equals("4"))	what = "a.good_cont";	
		if(s_kd.equals("5"))	what = "b.user_nm";

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like '%"+t_wd+"%' ";
		}	

		query += " order by a.ars_code";

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
			System.out.println("[ArsCardDatabase:getArsCardMngList]\n"+e);
			System.out.println("[ArsCardDatabase:getArsCardMngList]\n"+query);
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
	
	//payMethod, goodsName, goodsAmt, cardNo
	public boolean updateArsCardReq(String ars_code, String resultMsg, String status, String transSeq, String approvalNo, String payMethod, String buyerName, String goodsName, String goodsAmt, String cardNo)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		CallableStatement cstmt = null;
		
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		
		String query =  " update ars_card set "+
                        "        req_resultmsg = ?, trans_seq = ?, approvalNo = ?, app_id='SYSTEM', app_dt=sysdate "+
						" where  ('"+ars_code+"' = 'acar'||ars_code) or (ars_code='"+ars_code+"')";
		
		if(payMethod.equals("02")) {
			query =  " update ars_card set "+
                    "        req_resultmsg = ?, trans_seq = ?, approvalNo = ?, app_id='SYSTEM', app_dt=sysdate "+
					" where  instr(buyr_name,?)>0 and instr(good_name,?)>0 and good_mny=? and SUBSTR(REPLACE(REPLACE(card_no,' ',''),'-',''),1,6)||'******'||SUBSTR(REPLACE(REPLACE(card_no,' ',''),'-',''),13,4)=? ";
			
		}
		
		String query3 =" select ars_code from ars_card "+
				" where  instr(buyr_name,?)>0 and instr(good_name,?)>0 and good_mny=? and SUBSTR(REPLACE(REPLACE(card_no,' ',''),'-',''),1,6)||'******'||SUBSTR(REPLACE(REPLACE(card_no,' ',''),'-',''),13,4)=?";
		
    	String query2 = "{CALL P_COOL_MSG ('ars_card', ?, ?, ?)}";
		String sResult = "";
		
		try
		{
			
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			if(payMethod.equals("02")) {
				pstmt.setString(1,  resultMsg);
				pstmt.setString(2,  transSeq);
				pstmt.setString(3,  approvalNo);
				pstmt.setString(4,  buyerName);
				pstmt.setString(5,  goodsName);
				pstmt.setInt(6,  AddUtil.parseInt(goodsAmt));
				pstmt.setString(7,  cardNo);				
			}else {
				pstmt.setString(1,  resultMsg);
				pstmt.setString(2,  transSeq);
				pstmt.setString(3,  approvalNo);
			}
			pstmt.executeUpdate();			
			pstmt.close();
			
			if(payMethod.equals("02")) {
				pstmt2 = conn.prepareStatement(query3);
				pstmt2.setString(1,  buyerName);
				pstmt2.setString(2,  goodsName);
				pstmt2.setInt(3,  AddUtil.parseInt(goodsAmt));
				pstmt2.setString(4,  cardNo);			
				rs = pstmt2.executeQuery();
				if(rs.next())
				{
					ars_code = rs.getString(1)==null?"":rs.getString(1);
				}
				rs.close();
				pstmt2.close();
			}	
			
			cstmt = conn.prepareCall(query2);			
			cstmt.setString(1, ars_code);
			cstmt.setString(2, resultMsg);					
			cstmt.setString(3, status);
			cstmt.execute();
			cstmt.close();		

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[ArsCardDatabase:updateArsCardReq]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
	            if(cstmt != null)	cstmt.close();
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	//당일자 고객 중복 청구분
	public Vector getArsCardClientList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT c.doc_no, b.user_nm, decode(a.app_dt,'','대기','결제완료') st_nm, decode(a.app_st,'3','SMS결제','ARS수기') app_st_nm, to_char(a.reg_dt,'YYYYMMDD') s_reg_dt, a.* \n"+
				" FROM   ARS_CARD a, USERS b, (select doc_no, doc_id from doc_settle where doc_st='35') c \n"+
				" WHERE  to_char(a.reg_dt,'YYYYMMDD') >= to_char(sysdate-1,'YYYYMMDD')||'%' and a.client_id='"+client_id+"' and a.reg_id=b.user_id(+) and a.ars_code=c.doc_id(+) \n"+
				" ";

		query += " order by a.ars_code";

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
			System.out.println("[ArsCardDatabase:getArsCardClientList]\n"+e);
			System.out.println("[ArsCardDatabase:getArsCardClientList]\n"+query);
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