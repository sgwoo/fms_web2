package acar.im_email;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Vector;

import acar.database.DBConnectionManager;
import tax.DmailBean;
import tax.EDmailBean;


public class ImEmailDatabase
{
	private Connection conn = null;
	public static ImEmailDatabase db;
	
	public static ImEmailDatabase getInstance()
	{
		if(ImEmailDatabase.db == null)
			ImEmailDatabase.db = new ImEmailDatabase();
		return ImEmailDatabase.db;	
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

	//d-mail 발송 한건 등록
	public boolean insertDEmail(DmailBean bean, String table_num, String sdate, String tdate)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		if(table_num.equals("")) table_num = "8";
		if(table_num.equals("2")) table_num = "6";
		if(table_num.equals("3")) table_num = "7";
		if(table_num.equals("4")) table_num = "8";
		if(table_num.equals("5")) table_num = "9";
			
								
		query = " INSERT INTO im_dmail_info_"+table_num+""+
				" ( seqidx, subject, sql, reject_slist_idx, block_group_idx, mailfrom, mailto, replyto, errorsto, html,"+//1
				"   encoding, charset, sdate, tdate, duration_set, click_set, site_set, atc_set, gubun, rname,"+//2
				"   mtype, u_idx, g_idx, msgflag, content, gubun2, v_content, v_mailfrom, v_mailto , qry "+//3
				" ) VALUES"+
				" ( IM_SEQ_DMAIL_INFO_"+table_num+".nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, to_char(sysdate"+sdate+",'YYYYMMDDhh24miss'), to_char(sysdate+7,'YYYYMMDDhh24miss'), ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ? "+
				" )";

				//sdate : 발송일시
				//tdate : 트래픽수신일시 - 수신여부 확인 기간 설정
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
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
			pstmt.setString	(24,	bean.getV_content		()); 
			pstmt.setString	(25,	bean.getV_mailfrom		()); 
			pstmt.setString (26,	bean.getV_mailto		()); 
			pstmt.setString	(27,		bean.getSql				()); 
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertDEmail]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//d-mail 발송 한건 등록
	public int insertDEmail2(DmailBean bean, String table_num, String sdate, String tdate)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;
			
		if(table_num.equals("")) table_num = "8";
		if(table_num.equals("2")) table_num = "6";
		if(table_num.equals("3")) table_num = "7";
		if(table_num.equals("4")) table_num = "8";
		if(table_num.equals("5")) table_num = "9";
		

		String query1 = "select IM_SEQ_DMAIL_INFO_"+table_num+".nextval from im_dmail_info_"+table_num+"";

		query = " INSERT INTO im_dmail_info_"+table_num+""+
				" ( seqidx, subject, sql, reject_slist_idx, block_group_idx, mailfrom, mailto, replyto, errorsto, html,"+//1
				"   encoding, charset, sdate, tdate, duration_set, click_set, site_set, atc_set, gubun, rname,"+//2
				"   mtype, u_idx, g_idx, msgflag, content, v_content , qry "+//3
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, to_char(sysdate"+sdate+",'YYYYMMDDhh24miss'), to_char(sysdate+7,'YYYYMMDDhh24miss'), ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ?, ?, ? "+
				" )";

			

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setInt   	(1,		seqidx					  ); 
			pstmt.setString	(2,		bean.getSubject			()); 
			pstmt.setString	(3,		bean.getSql				()); 
			pstmt.setInt   	(4,		bean.getReject_slist_idx()); 
			pstmt.setInt   	(5,		bean.getBlock_group_idx	()); 
			pstmt.setString	(6,		bean.getMailfrom		()); 
			pstmt.setString (7,		bean.getMailto			()); 
			pstmt.setString (8,		bean.getReplyto			()); 
			pstmt.setString	(9,		bean.getErrosto			()); 
			pstmt.setInt   	(10,	bean.getHtml			()); 
			pstmt.setInt   	(11,	bean.getEncoding		()); 
			pstmt.setString	(12,	bean.getCharset			()); 
			pstmt.setInt   	(13,	bean.getDuration_set	()); 
			pstmt.setInt   	(14,	bean.getClick_set		()); 
			pstmt.setInt   	(15,	bean.getSite_set		()); 
			pstmt.setInt    (16,	bean.getAtc_set			()); 
			pstmt.setString	(17,	bean.getGubun			()); 
			pstmt.setString	(18,	bean.getRname			()); 
			pstmt.setInt   	(19,	bean.getMtype       	()); 
			pstmt.setInt   	(20,	bean.getU_idx       	()); 
			pstmt.setInt   	(21,	bean.getG_idx			()); 
			pstmt.setInt   	(22,	bean.getMsgflag     	()); 
			pstmt.setString	(23,	bean.getContent			()); 
			pstmt.setString	(24,	bean.getV_content		()); 
			pstmt.setString	(25,		bean.getSql				()); 
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertDEmail2]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seqidx;
		}
	}

//d-mail 발송 한건 등록
	public int insertDEmail3(DmailBean bean, String table_num, String sdate, String tdate, String car_mng_id, String rent_mng_id, String rent_l_cd, int seq_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;

		PreparedStatement pstmt2 = null;

		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;
			
		if(table_num.equals("")) table_num = "8";
		if(table_num.equals("2")) table_num = "6";
		if(table_num.equals("3")) table_num = "7";
		if(table_num.equals("4")) table_num = "8";
		if(table_num.equals("5")) table_num = "9";

		String query1 = "select IM_SEQ_DMAIL_INFO_"+table_num+".nextval from im_dmail_info_"+table_num+"";

		String query2 = " update fine set dmidx = ? where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";

		query = " INSERT INTO im_dmail_info_"+table_num+""+
				" ( seqidx, subject, sql, reject_slist_idx, block_group_idx, mailfrom, mailto, replyto, errorsto, html,"+//1
				"   encoding, charset, sdate, tdate, duration_set, click_set, site_set, atc_set, gubun, rname,"+//2
				"   mtype, u_idx, g_idx, msgflag, content, qry "+//3
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, to_char(sysdate"+sdate+",'YYYYMMDDhh24miss'), to_char(sysdate"+tdate+",'YYYYMMDDhh24miss'), ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ? , ? "+
				" )";

//System.out.println("[ImEmailDatabase:insertDEmail3]\n"+query1);
//System.out.println("[ImEmailDatabase:insertDEmail3]\n"+query2);
//System.out.println("[ImEmailDatabase:insertDEmail3]\n"+query3);

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(query2);            
            pstmt2.setInt	(1, seqidx		);
            pstmt2.setInt   (2, seq_no		);
            pstmt2.setString(3, car_mng_id	);
            pstmt2.setString(4, rent_mng_id	);
            pstmt2.setString(5, rent_l_cd	);            
            pstmt2.executeUpdate();             
            pstmt2.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setInt   	(1,		seqidx					  ); 
			pstmt.setString	(2,		bean.getSubject			()); 
			pstmt.setString	(3,		bean.getSql				()); 
			pstmt.setInt   	(4,		bean.getReject_slist_idx()); 
			pstmt.setInt   	(5,		bean.getBlock_group_idx	()); 
			pstmt.setString	(6,		bean.getMailfrom		()); 
			pstmt.setString (7,		bean.getMailto			()); 
			pstmt.setString (8,		bean.getReplyto			()); 
			pstmt.setString	(9,		bean.getErrosto			()); 
			pstmt.setInt   	(10,	bean.getHtml			()); 
			pstmt.setInt   	(11,	bean.getEncoding		()); 
			pstmt.setString	(12,	bean.getCharset			()); 
			pstmt.setInt   	(13,	bean.getDuration_set	()); 
			pstmt.setInt   	(14,	bean.getClick_set		()); 
			pstmt.setInt   	(15,	bean.getSite_set		()); 
			pstmt.setInt    (16,	bean.getAtc_set			()); 
			pstmt.setString	(17,	bean.getGubun			()); 
			pstmt.setString	(18,	bean.getRname			()); 
			pstmt.setInt   	(19,	bean.getMtype       	()); 
			pstmt.setInt   	(20,	bean.getU_idx       	()); 
			pstmt.setInt   	(21,	bean.getG_idx			()); 
			pstmt.setInt   	(22,	bean.getMsgflag     	()); 
			pstmt.setString	(23,	bean.getContent			()); 
			pstmt.setString	(24,		bean.getSql				()); 
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertDEmail3]\n"+e);
			System.out.println("[ImEmailDatabase:insertDEmail3]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt2 != null)		pstmt2.close();
				if(pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seqidx;
		}
	}

	/**
	 *	이메일발송 건별 이력
	 */
	public Vector getMailHistoryList(String table_num, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String table_num2 = ""; 

		if(table_num.equals(""))	table_num2 = "8";
		if(table_num.equals("2"))	table_num2 = "6";
		if(table_num.equals("3"))	table_num2 = "7";
		if(table_num.equals("4"))	table_num2 = "8";
		if(table_num.equals("5"))	table_num2 = "9";


		query = " select a.*, errcode_nm as msgflag_nm,"+
				" decode(substr(a.gubun,14), 'scd_fee','장기대여이용안내문', "+
		        "                            'scd_info','장기대여스케줄안내문', "+
				"                            'fms_info','고객FMS이용안내문', "+
			    "                            'car_info','차량관리안내문', "+
				"                            'car_sos','마스타자동차긴급출동안내문', "+
				"                            'cls_info','해지내역안내문', "+
				"                            'speedmate','스피드메이트안내문', "+
				"                            'fms_info','고객FMS이용안내문', "+
				"                            'commi','영업수당지급내역', "+
				"                            'cms_fine','미납통행료납부안내문', "+
				"                            'total_mail','서비스 통합 안내문', "+
				"                            'bank','통장 사본', "+
				"                            'bluemem','현대자동차 블루멤버스 안내문', "+
				"                            'receipt','과태료&통행료&주차요금 영수증발급기관<br>안내문', "+
				"                            'cls_est','해지정산 사전내역', "+
				"                            'bulk','업무용승용차 관련 안내문', "+
				"                            'pur_opt', '매입옵션안내문' "+
				" ) mail_type "+
				" from"+
				" ("+
				"          select '2' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.code_nm, c.code_st1, c.code_st2, c.note, c.r_st,  "+
				"                 decode(a.errcode,114,'정상발송',c.code_st2) errcode_nm,  "+
				"                 decode(nvl(a.ocnt,99),99,'대기',-1,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm  "+
				"          from   im_dmail_info_"+table_num+" b, im_dmail_result_"+table_num+" a, im_dmail_errcode c  "+
				"          where  b.gubun like '%"+gubun+"%' and b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) \n"+ 
                "          UNION all  "+
				"          select '6' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"                 decode(nvl(a.ocnt,99),99,'대기',0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm"+
				"          from   im_dmail_info_"+table_num2+" b, im_dmail_result_"+table_num2+" a, im_dmail_j_errcode c "+
				"          where  b.gubun like '%"+gubun+"%' and b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) \n"+ 
				" ) a"+
				" order by stime";
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getMailHistoryList]\n"+e);
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
	 *	이메일발송 건별 이력
	 */
	public Vector getFmsInfoMailNotSendList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select a.sql, c.rent_mng_id, c.rent_l_cd, substr(a.sql,5) mail, e.firm_nm, "+
                "        replace(a.subject,'장기대여','고객FMS') subject, "+
                "        replace(a.gubun,'scd_fee','fms_info') gubun "+
                " from   IM_DMAIL_INFO_8 a, "+
				"        cont c, (select * from commi where agnt_st='1') d, client e, "+
                "        (SELECT b.client_id "+
                "         FROM IM_DMAIL_INFO_8 a, cont b "+
                "         where substr(a.gubun,14) = 'fms_info' and substr(a.gubun,1,13)=b.rent_l_cd "+
                "         group by b.client_id "+
                "        ) b "+
                " where  substr(a.gubun,14) = 'scd_fee' "+
                "        and a.sdate > '20091231000000' "+
                "        and trunc(sysdate-to_date(substr(a.sdate,1,8),'YYYYMMDD'),0) > 7 "+
				"        and substr(a.gubun,1,13)=c.rent_l_cd and c.rent_dt > '20091231' and c.use_yn='Y' "+
				"        and c.rent_mng_id=d.rent_mng_id(+) and c.rent_l_cd=d.rent_l_cd(+) and d.emp_id is null"+
				"        and c.client_id=e.client_id"+
                "        and e.client_id=b.client_id(+) "+
                "        and b.client_id is null "+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getFmsInfoMailNotSendList]\n"+e);
			System.out.println("[ImEmailDatabase:getFmsInfoMailNotSendList]\n"+query);
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
	 *	청구서메일관리
	 */
	public Vector getFmsInfoMailPaySendList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";
		String search = "";
		String what = "";
		String dt4 = "b.sdate";

		if(gubun1.equals("2"))			where += " and "+dt4+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		where += " and "+dt4+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun1.equals("4"))		where += " and "+dt4+" like to_char(sysdate-1,'YYYYMMDD')||'%'";//전일
		else if(gubun1.equals("5"))		where += " and "+dt4+" like to_char(sysdate,'YYYY')||'%'";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	where += " and "+dt4+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) where += " and "+dt4+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query = " select * "+
				" from     \n"+
				"        ( \n"+
				"          select '2' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.code_nm, c.code_st1, c.code_st2, c.note, c.r_st,  "+
				"                 decode(a.errcode,114,'정상발송',c.code_st2) errcode_nm,  "+
				"                 decode(nvl(a.ocnt,99),99,'대기',-1,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm  "+
				"          from   im_dmail_info_2 b, im_dmail_result_2 a, im_dmail_errcode c  "+
				"          where  b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) \n"+ where +
                "          UNION all  "+
				"          select '6' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"                 decode(nvl(a.ocnt,99),99,'대기',0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm"+
				"          from   im_dmail_info_6 b, im_dmail_result_6 a, im_dmail_j_errcode c "+
				"          where  b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) \n"+ where +
				"        ) \n";

		if(gubun2.equals("1"))			query += " where ocnt=1";
		if(gubun2.equals("2"))			query += " where ocnt in ( -1, 0 ) ";
		if(gubun2.equals(""))			query += " where 1=1";

		if(gubun3.equals("1"))			query += " and code_st2='네트웍 에러'";
		if(gubun3.equals("2"))			query += " and code_st2='서버 에러'";
		if(gubun3.equals("3"))			query += " and code_st2='메일박스풀'";
		if(gubun3.equals("4"))			query += " and r_st='R'";

		if(s_kd.equals("1"))	what = "upper(nvl(sql, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(mailto, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(subject, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by dmidx"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getFmsInfoMailPaySendList]\n"+e);
			System.out.println("[ImEmailDatabase:getFmsInfoMailPaySendList]\n"+query);
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
	 *	견적서메일관리
	 */
	public Vector getFmsInfoMailEstiSendList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";
		String search = "";
		String what = "";
		String dt4 = "b.sdate";
		
		if(gubun1.equals("2"))			where += " and "+dt4+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		where += " and "+dt4+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun1.equals("4"))		where += " and "+dt4+" like to_char(sysdate-1,'YYYYMMDD')||'%'";//전일
		else if(gubun1.equals("5"))		where += " and "+dt4+" like to_char(sysdate,'YYYY')||'%'";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	where += " and "+dt4+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) where += " and "+dt4+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query = " select * "+
				" from     \n"+
				"        ( \n"+
				"          select '3' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.replyto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.code_nm, c.code_st1, c.code_st2, c.note, c.r_st,  "+
				"                 decode(a.errcode,114,'정상발송',c.code_st2) errcode_nm,  "+
				"                 decode(nvl(a.ocnt,99),99,'대기',-1,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm  "+
				"          from   im_dmail_info_3 b, im_dmail_result_3 a, im_dmail_errcode c  "+
				"          where  b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) \n"+ where +
                "          UNION all  "+
				"          select '7' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.replyto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"                 decode(nvl(a.ocnt,99),99,'대기',0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm"+
				"          from   im_dmail_info_7 b, im_dmail_result_7 a, im_dmail_j_errcode c "+
				"          where  b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) \n"+ where +
				"        ) \n";

		if(gubun2.equals("1"))			query += " where ocnt=1";
		if(gubun2.equals("2"))			query += " where ocnt in (-1 , 0) ";
		if(gubun2.equals(""))			query += " where 1=1";

		if(gubun3.equals("1"))			query += " and code_st2='네트웍 에러'";
		if(gubun3.equals("2"))			query += " and code_st2='서버 에러'";
		if(gubun3.equals("3"))			query += " and code_st2='메일박스풀'";
		if(gubun3.equals("4"))			query += " and r_st='R'";

		if(s_kd.equals("1"))	what = "upper(nvl(sql, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(mailto, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(subject, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(replyto, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by dmidx"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getFmsInfoMailEstiSendList]\n"+e);
			System.out.println("[ImEmailDatabase:getFmsInfoMailEstiSendList]\n"+query);
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
	 *	안내문메일관리
	 */
	public Vector getFmsInfoMailDocSendList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String where = "";
		String search = "";
		String what = "";
		String dt4 = "b.sdate";
		
		if(gubun1.equals("2"))			where += " and "+dt4+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		where += " and "+dt4+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun1.equals("4"))		where += " and "+dt4+" like to_char(sysdate-1,'YYYYMMDD')||'%'";//전일
		else if(gubun1.equals("5"))		where += " and "+dt4+" like to_char(sysdate,'YYYY')||'%'";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	where += " and "+dt4+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) where += " and "+dt4+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
 
		query = " select * "+
				" from     \n"+
				"        ( \n"+
				"          select '4' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.code_nm, c.code_st1, c.code_st2, c.note, c.r_st,  "+
				"                 decode(a.errcode,114,'정상발송',c.code_st2) errcode_nm,  "+
				"                 decode(nvl(a.ocnt,99),99,'대기',-1,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm  "+
				"          from   im_dmail_info_4 b, im_dmail_result_4 a, im_dmail_errcode c  "+
				"          where  b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) \n"+ where +
                "          UNION all  "+
				"          select '8' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"                 decode(nvl(a.ocnt,99),99,'대기',0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm"+
				"          from   im_dmail_info_8 b, im_dmail_result_8 a, im_dmail_j_errcode c "+
				"          where  b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) \n"+ where +
				"        ) \n";

		if(gubun2.equals("1"))			query += " where ocnt=1";
		if(gubun2.equals("2"))			query += " where ocnt in ( -1 , 0) ";
		if(gubun2.equals(""))			query += " where 1=1";

		if(gubun3.equals("1"))			query += " and code_st2='네트웍 에러'";
		if(gubun3.equals("2"))			query += " and code_st2='서버 에러'";
		if(gubun3.equals("3"))			query += " and code_st2='메일박스풀'";
		if(gubun3.equals("4"))			query += " and r_st='R'";

		if(gubun5.equals("1"))			query += " and gubun like '%fine%' ";
		if(gubun5.equals("2"))			query += " and gubun like '%insur' ";
		if(gubun5.equals("3"))			query += " and gubun like '%credit' ";
		if(gubun5.equals("4"))			query += " and gubun like '%pay%' ";
		if(gubun5.equals("5"))			query += " and gubun like '%fms_info' ";
		if(gubun5.equals("6"))			query += " and gubun like '%car_info' ";
		if(gubun5.equals("7"))			query += " and gubun like '%scd_fee' ";
		if(gubun5.equals("8"))			query += " and gubun like '%cls_info' ";
		if(gubun5.equals("9"))			query += " and gubun like '%car_sos' ";
		if(gubun5.equals("10"))			query += " and gubun like '%cms_fine' ";
		if(gubun5.equals("11"))			query += " and gubun like '%speedmate' ";
		if(gubun5.equals("12"))			query += " and gubun like '%blackbox' ";
		if(gubun5.equals("13"))			query += " and gubun like '%partner_mail' ";

		if(s_kd.equals("1"))	what = "upper(nvl(sql, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(mailto, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(subject, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by dmidx";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getFmsInfoMailDocSendList]\n"+e);
			System.out.println("[ImEmailDatabase:getFmsInfoMailDocSendList]\n"+query);
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
	 *	이메일발송 건별 이력
	 */
	public Vector getFmsInfoMailErrSendList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String where = "";
		String search = "";
		String what = "";
		String dt4 = "b.sdate";
		
		if(gubun1.equals("2"))			where += " and "+dt4+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		where += " and "+dt4+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun1.equals("4"))		where += " and "+dt4+" like to_char(sysdate-1,'YYYYMMDD')||'%'";//전일
		else if(gubun1.equals("5"))		where += " and "+dt4+" like to_char(sysdate,'YYYY')||'%'";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	where += " and "+dt4+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) where += " and "+dt4+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query = " select * "+
				" from     \n"+
				"        ( \n"+
				"          select '2' st, a.*, "+
				"                 b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"                 decode(a.ocnt,0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm"+
				"          from   im_dmail_result_6 a, im_dmail_info_6 b, im_dmail_j_errcode c "+
				"          where  a.errcode not in ('100', '101')  and a.dmidx=b.seqidx and a.errcode=c.code_id(+) \n"+ where +
				"          union all \n"+
				"          select '3' st, a.*, "+
				"                 b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"                 decode(a.ocnt,0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm"+
				"          from im_dmail_result_7 a, im_dmail_info_7 b, im_dmail_j_errcode c "+
				"          where a.errcode not in ('100', '101')  and a.dmidx=b.seqidx and a.errcode=c.code_id(+) \n"+ where +
				"          union all \n"+
				"          select '4' st, a.*, "+
				"                 b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"                 decode(a.ocnt,0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm"+
				"          from im_dmail_result_8 a, im_dmail_info_8 b, im_dmail_j_errcode c "+
				"          where a.errcode not in ('100', '101')  and a.dmidx=b.seqidx and a.errcode=c.code_id(+) \n"+ where +
				"        ) \n";

		if(gubun2.equals("1"))			query += " where st='2'";
		if(gubun2.equals("2"))			query += " where st='3'";
		if(gubun2.equals("3"))			query += " where st='4'";
		if(gubun2.equals(""))			query += " where st is not null ";


		if(gubun3.equals("1"))			query += " and code_st2='네트웍 에러'";
		if(gubun3.equals("2"))			query += " and code_st2='서버 에러'";
		if(gubun3.equals("3"))			query += " and code_st2='메일박스풀'";
		if(gubun3.equals("4"))			query += " and r_st='R'";

		if(s_kd.equals("1"))	what = "upper(nvl(sql, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(mailto, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(subject, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by sdate"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getFmsInfoMailErrSendList]\n"+e);
			System.out.println("[ImEmailDatabase:getFmsInfoMailErrSendList]\n"+query);
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
	 *	이메일발송 건별 이력
	 */
	public Hashtable getIm_dmail_info(String dmidx, String dm_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		if(dm_st.equals("")) dm_st = "8";
		if(dm_st.equals("2")) dm_st = "6";
		if(dm_st.equals("3")) dm_st = "7";
		if(dm_st.equals("4")) dm_st = "8";
		if(dm_st.equals("5")) dm_st = "9";

		query = " select subject, mailfrom, gubun, gubun2 from im_dmail_info_"+dm_st+" where seqidx = "+dmidx+" ";

		try {

			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getIm_dmail_info]\n"+e);
			System.out.println("[ImEmailDatabase:getIm_dmail_info]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	이메일발송 건별 이력
	 */
	public String getIm_dmail_content(String dmidx, String dm_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String content = "";
		String query = "";
        String f_content="";
        
		if(dm_st.equals("")) dm_st = "8";
		if(dm_st.equals("2")) dm_st = "6";
		if(dm_st.equals("3")) dm_st = "7";
		if(dm_st.equals("4")) dm_st = "8";
		if(dm_st.equals("5")) dm_st = "9";

		//LONG TYPE 처리  - 20191017
		
		if(dm_st.equals("6")) f_content = "replace(Get_Content_txt_im_dmail6(rowid),chr(10),null) content";
		if(dm_st.equals("7")) f_content = "replace(Get_Content_txt_im_dmail7(rowid),chr(10),null) content";
		if(dm_st.equals("8")) f_content = "replace(Get_Content_txt_im_dmail8(rowid),chr(10),null) content";
		if(dm_st.equals("9")) f_content = "replace(Get_Content_txt_im_dmail9(rowid),chr(10),null) content";
		
	//	query = " select  CONTENT from im_dmail_info_"+dm_st+" where seqidx = "+dmidx+" ";
		query = " select " + f_content + " from im_dmail_info_"+dm_st+" where seqidx = "+dmidx+" ";

		try {

			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				 content = rs.getString("CONTENT");
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getIm_dmail_content]\n"+e);
			System.out.println("[ImEmailDatabase:getIm_dmail_content]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return content;
		}
	}

	/**
	 *	이메일발송 건별 이력
	 */
	public String getIm_dmail_content_v(String dmidx, String dm_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String content = "";
		String query = "";
/*
		if(dm_st.equals("")) dm_st = "8";
		if(dm_st.equals("2")) dm_st = "6";
		if(dm_st.equals("3")) dm_st = "7";
		if(dm_st.equals("4")) dm_st = "8";
		if(dm_st.equals("5")) dm_st = "9";
*/
		query = " select V_CONTENT from im_dmail_info_"+dm_st+" where seqidx = "+dmidx+" ";

		try {

			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				 content = rs.getString("V_CONTENT");
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getIm_dmail_content_v]\n"+e);
			System.out.println("[ImEmailDatabase:getIm_dmail_content_v]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return content;
		}
	}

	//d-mail 발송 한건 등록
	public boolean insertReSendDEmail(String dmidx, String dm_st, String mailto, String content)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		
		if(dm_st.equals("2")) dm_st = "6";
		if(dm_st.equals("3")) dm_st = "7";
		if(dm_st.equals("4")) dm_st = "8";
		if(dm_st.equals("5")) dm_st = "9";
		
			
		query = " INSERT INTO im_dmail_info_"+dm_st+""+
				" ( seqidx, subject, sql, reject_slist_idx, block_group_idx, mailfrom, mailto, replyto, errorsto, html,"+//1
				"   encoding, charset, sdate, tdate, duration_set, click_set, site_set, atc_set, gubun, rname,"+//2
				"   mtype, u_idx, g_idx, msgflag, content, qry "+//3
				" ) VALUES"+
				" ( select IM_SEQ_DMAIL_INFO_"+dm_st+".nextval, subject, sql, 0, 0, mailfrom, "+mailto+", replyto, errorsto, html,"+//1
				"   encoding, charset, to_char(sysdate,'YYYYMMDDhh24miss'), to_char(sysdate,'YYYYMMDDhh24miss'), 1, 0, 0, 0, gubun, rname,"+//2
				"   0, 1, 1, 0, "+content+" , sql "+ 
				"   from im_dmail_info_"+dm_st+" where seqidx="+dmidx+" "+
				" )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertReSendDEmail]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	이메일발송중복 체크
	 */
	public int getFmsInfoMailNotSendChkList(String gubun, String title, String mail)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";


		query = " select count(*) as cnt from IM_DMAIL_INFO_8 where gubun like '%"+gubun+"%' and subject like '%"+title+"%' and sql like '%"+mail+"%'";

		try {

			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				count = rs.getInt("cnt");
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getFmsInfoMailNotSendChkList]\n"+e);
			System.out.println("[ImEmailDatabase:getFmsInfoMailNotSendChkList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	이메일발송중복 체크
	 */
	public int getFmsInfoMailTodayNotSendChkList(String title, String mail)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";


		query = " select count(*) as cnt from IM_DMAIL_INFO_8 where subject='"+title+"' and sql like '%"+mail+"%' and substr(sdate,1,8)=to_char(sysdate,'YYYYMMDD')";

		try {

			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				count = rs.getInt("cnt");
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getFmsInfoMailNotSendChkList]\n"+e);
			System.out.println("[ImEmailDatabase:getFmsInfoMailNotSendChkList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	/**
	 *	안내문메일관리-gubun
	 */
	public Vector getFmsInfoMailDocSendList(String gubun, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select '4' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"                 decode(a.ocnt,0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm"+
				"          from   im_dmail_result_8 a, im_dmail_info_8 b, im_dmail_j_errcode c "+
				" \n";

		if(!gubun.equals("") && gubun2.equals(""))			query += " where gubun='"+gubun+"' and ";

		if(gubun.equals("") && !gubun2.equals(""))			query += " where nvl(gubun2,'"+gubun2+"')='"+gubun2+"' and ";

		if(!gubun.equals("") && !gubun2.equals(""))			query += " where gubun='"+gubun+"' and nvl(gubun2,'"+gubun2+"')='"+gubun2+"' and ";

		if(gubun.equals("") && gubun2.equals(""))			query += " where substr(a.sdate,1,8)=to_char(sysdate,'YYYYMMDD') and ";


		query += " a.dmidx=b.seqidx and a.errcode=c.code_id(+)";
		query += " order by dmidx"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getFmsInfoMailDocSendList]\n"+e);
			System.out.println("[ImEmailDatabase:getFmsInfoMailDocSendList]\n"+query);
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
	 *	안내문메일관리
	 */
	public Vector getFmsInfoMailFineDocSendList(String firm_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * "+
				" from     \n"+
				"        ( \n"+
				"          select '4' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"                 decode(nvl(a.ocnt,99),99,'대기',0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm"+
				"          from   im_dmail_info_8 b, im_dmail_result_8 a, im_dmail_j_errcode c "+
				"          where  b.subject like '%"+firm_nm+"%과태료%' and b.seqidx=a.dmidx and a.errcode=c.code_id(+) \n"+
				"        ) \n";

		query += " order by dmidx"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getFmsInfoMailFineDocSendList]\n"+e);
			System.out.println("[ImEmailDatabase:getFmsInfoMailFineDocSendList]\n"+query);
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
	 *	이메일발송 건별 이력
	 */
	public int getMailRegCnt(String table_num, String gubun, String subject)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		if(table_num.equals("")) table_num = "8";
		if(table_num.equals("2")) table_num = "6";
		if(table_num.equals("3")) table_num = "7";
		if(table_num.equals("4")) table_num = "8";
		if(table_num.equals("5")) table_num = "9";


		query = " select count(*) from im_dmail_info_"+table_num+" where gubun = '"+gubun+"'";

		if(!subject.equals(""))	query += " and subject like '%"+subject+"%'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				 count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getMailRegCnt]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	public Hashtable MailChkTime(int dmidx)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		int count = 0;

		String query = " select '4' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, "+
				"               c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"               decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"               decode(nvl(a.ocnt,99),99,'대기',0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm"+
				"        from   im_dmail_result_8 a, im_dmail_info_8 b, im_dmail_j_errcode c "+
				"        where  a.dmidx=b.seqidx and a.errcode=c.code_id(+) AND substr( a.stime, 1, 4 ) = to_char( sysdate, 'YYYY' ) and a.dmidx = '"+dmidx+"'\n";

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
			System.out.println("[ImEmailDatabase:MailChkTime]"+e);
			System.out.println("[ImEmailDatabase:MailChkTime]"+query);
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

//첨부등록

	public int insertEDEmail(EDmailBean bean, String car_mng_id, String rent_mng_id, String rent_l_cd, int seq_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;

		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;
		int idx = 0;
			

		String query1 = "select dmidx from fine where seq_no='"+seq_no+"' and car_mng_id='"+car_mng_id.trim()+"' and rent_mng_id='"+rent_mng_id.trim()+"' and rent_l_cd='"+rent_l_cd.trim()+"' ";

		query = " INSERT INTO im_enc_dmail_8 ( idx, seqidx, fileinfo, content ) VALUES "+
				" ( (SELECT nvl(max(idx)+1,1) FROM IM_ENC_DMAIL_8 ), ?, ?, ? ) ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);

//			pstmt.setInt   	(1,		idx						  ); 
			pstmt.setInt   	(1,		seqidx	); 
			pstmt.setString	(2,		bean.getFileinfo		()); 
			pstmt.setString	(3,		bean.getContent			()); 
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertEDEmail]\n"+e);
			System.out.println("[ImEmailDatabase:insertEDEmail]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return idx;
		}
	}


//연차메일 첨부등록 테스트

	public int insertEDEmail_free(EDmailBean bean, String car_mng_id, String rent_mng_id, String rent_l_cd, int seq_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;

		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;
		int idx = 0;
			

		String query1 = "select dmidx from IM_DMAIL_INFO_7 where seq_no='"+seq_no+"' and car_mng_id='"+car_mng_id.trim()+"' and rent_mng_id='"+rent_mng_id.trim()+"' and rent_l_cd='"+rent_l_cd.trim()+"' ";

		query = " INSERT INTO im_enc_dmail_7 ( idx, seqidx, fileinfo, content ) VALUES "+
				" ( (SELECT nvl(max(idx)+1,1) FROM IM_ENC_DMAIL_7 ), ?, ?, ? ) ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);

//			pstmt.setInt   	(1,		idx						  ); 
			pstmt.setInt   	(1,		seqidx	); 
			pstmt.setString	(2,		bean.getFileinfo		()); 
			pstmt.setString	(3,		bean.getContent			()); 
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertEDEmail]\n"+e);
			System.out.println("[ImEmailDatabase:insertEDEmail]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return idx;
		}
	}

	//안내메일 첨부파일 등록
	public boolean insertDEmailEnc4(String gubun, String gubun2, String fileinfo, String content)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;

		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;
		int idx = 0;

			
		String query1 = " select max(seqidx) from IM_DMAIL_INFO_8 where gubun='"+gubun+"'";

		if(!gubun2.equals(""))	query1 += " and gubun2='"+gubun2+"'";




		query = " INSERT INTO im_enc_dmail_8 ( idx, seqidx, fileinfo, content, v_content ) VALUES "+
				" ( (SELECT nvl(max(idx)+1,1) FROM IM_ENC_DMAIL_8 ), ?, ?, ?, ? ) ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);

			pstmt.setInt   	(1,		seqidx	); 
			pstmt.setString	(2,		fileinfo); 
			pstmt.setString	(3,		content); 
			pstmt.setString	(4,		content); 
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertDEmailEnc4]\n"+e);
			System.out.println("[ImEmailDatabase:insertDEmailEnc4]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//안내메일 첨부파일 등록
	public boolean insertDEmailEnc(String table_num, String gubun, String gubun2, String fileinfo, String content)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;

		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;
		int idx = 0;

		if(table_num.equals("")) table_num = "8";
		if(table_num.equals("2")) table_num = "6";
		if(table_num.equals("3")) table_num = "7";
		if(table_num.equals("4")) table_num = "8";
		if(table_num.equals("5")) table_num = "9";
					
		String query1 = " select max(seqidx) from IM_DMAIL_INFO_"+table_num+" where gubun='"+gubun+"'";

		if(!gubun2.equals(""))	query1 += " and gubun2='"+gubun2+"'";

		query = " INSERT INTO im_enc_dmail_"+table_num+" ( idx, seqidx, fileinfo, content, v_content ) VALUES "+
				" ( (SELECT nvl(max(idx)+1,1) FROM IM_ENC_DMAIL_"+table_num+" ), ?, ?, ?, ? ) ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);

			pstmt.setInt   	(1,		seqidx	); 
			pstmt.setString	(2,		fileinfo); 
			pstmt.setString	(3,		content); 
			pstmt.setString	(4,		content); 
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertDEmailEnc]\n"+e);
			System.out.println("[ImEmailDatabase:insertDEmailEnc]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	//안내메일 첨부파일 등록
	public boolean insertDEmailEnc(String table_num, String gubun, String gubun2, String fileinfo, String content, String attach_seq)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;

		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;
		int idx = 0;

		if(table_num.equals("")) table_num = "8";
		if(table_num.equals("2")) table_num = "6";
		if(table_num.equals("3")) table_num = "7";
		if(table_num.equals("4")) table_num = "8";
		if(table_num.equals("5")) table_num = "9";
			
		String query1 = " select max(seqidx) from IM_DMAIL_INFO_"+table_num+" where gubun='"+gubun+"'";

		if(!gubun2.equals(""))	query1 += " and gubun2='"+gubun2+"'";

		query = " INSERT INTO im_enc_dmail_"+table_num+" ( idx, seqidx, fileinfo, content, v_content, attach_seq ) VALUES "+
				" ( (SELECT nvl(max(idx)+1,1) FROM IM_ENC_DMAIL_"+table_num+" ), ?, ?, ?, ?, ? ) ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);

			pstmt.setInt   	(1,		seqidx	); 
			pstmt.setString	(2,		fileinfo); 
			pstmt.setString	(3,		content); 
			pstmt.setString	(4,		content); 
			pstmt.setString	(5,		attach_seq); 
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertDEmailEnc]\n"+e);
			System.out.println("[ImEmailDatabase:insertDEmailEnc]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	안내문메일관리 - 메일 & 첨부파일 정보
	 */
	public Vector getImDmailEnc4List(String gubun, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.fileinfo, b.v_content AS file_content "+
				" from   IM_DMAIL_INFO_8 a, IM_ENC_DMAIL_8 b "+
				" where  a.gubun='"+gubun+"' and a.gubun2='"+gubun2+"' and b.seqidx=a.seqidx "+
				" order by b.idx desc ";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getImDmailEnc4List]\n"+e);
			System.out.println("[ImEmailDatabase:getImDmailEnc4List]\n"+query);
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
	 *	안내문메일관리 - 메일 & 첨부파일 정보
	 */
	public Vector getImDmailEncList(String table_num, String gubun, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(table_num.equals("")) table_num = "8";
		if(table_num.equals("2")) table_num = "6";
		if(table_num.equals("3")) table_num = "7";
		if(table_num.equals("4")) table_num = "8";
		if(table_num.equals("5")) table_num = "9";

		query = " select b.fileinfo, b.v_content AS file_content, b.attach_seq, b.filename "+
				" from   IM_DMAIL_INFO_"+table_num+" a, IM_ENC_DMAIL_"+table_num+" b "+
				" where  a.gubun='"+gubun+"' and a.gubun2='"+gubun2+"' and b.seqidx=a.seqidx "+
				" order by b.idx  "+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getImDmailEncList]\n"+e);
			System.out.println("[ImEmailDatabase:getImDmailEncList]\n"+query);
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
	 *	안내문메일관리 - 메일 & 첨부파일 정보 답변
	 */
	public Vector getImDmailEnc4ReList(String gubun, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.v_content "+
				" from   IM_DMAIL_INFO_8 a "+
				" where  a.gubun='"+gubun+"' and a.gubun2='"+gubun2+"'  "+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getImDmailEnc4ReList]\n"+e);
			System.out.println("[ImEmailDatabase:getImDmailEnc4ReList]\n"+query);
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
	 *	안내문메일관리 - 메일 & 첨부파일 정보 답변 한건
	 */
	public Hashtable getImDmailInfo4(String gubun, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.v_mailfrom, a.v_mailto, a.v_content, a.gubun, a.gubun2, a.mailfrom, a.mailto, a.replyto "+
				" from   IM_DMAIL_INFO_8 a "+
				" where  a.gubun='"+gubun+"' and a.gubun2='"+gubun2+"'  "+
				" ";

		try {

			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getImDmailInfo4]\n"+e);
			System.out.println("[ImEmailDatabase:getImDmailInfo4]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	안내문메일관리 - 메일 & 첨부파일 정보 답변 한건
	 */
	public Hashtable getImDmailInfo(String table_num, String gubun, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String r_table_num = "";

		if(table_num.equals(""))	r_table_num = "8";
		if(table_num.equals("2"))	r_table_num = "6";
		if(table_num.equals("3"))	r_table_num = "7";
		if(table_num.equals("4"))	r_table_num = "8";
		if(table_num.equals("5"))	r_table_num = "9";

		if(r_table_num.equals(""))	r_table_num = table_num;

		query = " select a.v_mailfrom, a.v_mailto, a.v_content, a.gubun, a.gubun2, a.mailfrom, a.mailto, a.replyto "+
				" from   IM_DMAIL_INFO_"+r_table_num+" a "+
				" where  a.gubun='"+gubun+"' and a.gubun2='"+gubun2+"'  "+
				" ";

		try {

			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getImDmailInfo]\n"+e);
			System.out.println("[ImEmailDatabase:getImDmailInfo]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	/**
	 *	연장계약서안내문메일 리스트
	 */
	public Vector getReNewMailList(String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT c.stime, a.v_mailfrom, a.v_mailto, "+
				"        decode(a.msgflag,'1',decode(c.errcode,114,'정상발송',d.code_st2),'발송중') msgflag_nm, "+
				"        decode(nvl(c.ocnt,99),99,'대기',0,'미수신','수신') ocnt_nm, "+
				"        c.otime, "+
				"        DECODE(b.v_content,'','미응답','응답') answer_yn, "+
				"        DECODE(INSTR(b.v_content,'answer1=Y'),'','','Y') AS answer1, "+
				"        DECODE(INSTR(b.v_content,'answer2=Y'),'','','Y') AS answer2, "+
				"        DECODE(INSTR(b.v_content,'answer3=Y'),'','','Y') AS answer3  "+
				" FROM   (SELECT * FROM IM_DMAIL_INFO_8 WHERE gubun='"+gubun+"' AND gubun2 LIKE '%newcar_doc' ) a,  "+
				"        (SELECT * FROM IM_DMAIL_INFO_8 WHERE gubun='"+gubun+"' AND gubun2 LIKE '%newcar_doc_re' ) b, "+
				"        im_dmail_result_8 c, im_dmail_errcode d  "+
				" WHERE  a.gubun=b.gubun(+) AND a.gubun2||'_re'=b.gubun2(+) "+
				"        and a.seqidx=c.dmidx(+) "+
				"        and c.errcode=d.code_id(+)  "+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getReNewMailList]\n"+e);
			System.out.println("[ImEmailDatabase:getReNewMailList]\n"+query);
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


//금융사 첨부파일 등록
	public int insertDEmailEnc96(String gubun, String fileinfo, String content)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;

		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;
		int idx = 0;
			

		String query1 = " select max(seqidx) from IM_DMAIL_INFO_8 where gubun='"+gubun+"'";

		query = " INSERT INTO im_enc_dmail_8 ( idx, seqidx, fileinfo, content ) VALUES "+
				" ( (SELECT nvl(max(idx)+1,1) FROM IM_ENC_DMAIL_8 ), ?, ?, ? ) ";


		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);

//			pstmt.setInt   	(1,		idx						  ); 
			pstmt.setInt   	(1,		seqidx	); 
			pstmt.setString	(2,		fileinfo		); 
			pstmt.setString	(3,		content			); 
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertDEmailEnc96]\n"+e);
			System.out.println("[ImEmailDatabase:insertDEmailEnc96]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return idx;
		}
	}


//d-mail 발송 한건 등록
	public int insertDEmail96(DmailBean bean, String table_num, String sdate, String tdate)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;
			
		if(table_num.equals("")) table_num = "8";
		if(table_num.equals("2")) table_num = "6";
		if(table_num.equals("3")) table_num = "7";
		if(table_num.equals("4")) table_num = "8";
		if(table_num.equals("5")) table_num = "9";

		String query1 = "select IM_SEQ_DMAIL_INFO_"+table_num+".nextval from im_dmail_info_"+table_num+"";


		query = " INSERT INTO im_dmail_info_"+table_num+""+
				" ( seqidx, subject, sql, reject_slist_idx, block_group_idx, mailfrom, mailto, replyto, errorsto, html,"+//1
				"   encoding, charset, sdate, tdate, duration_set, click_set, site_set, atc_set, gubun, rname,"+//2
				"   mtype, u_idx, g_idx, msgflag, content, qry "+//3
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, to_char(sysdate"+sdate+",'YYYYMMDDhh24miss'), to_char(sysdate"+tdate+",'YYYYMMDDhh24miss'), ?, ?, ?, ?, ?, ?,"+
				"   ?, ?, ?, ?, ? , ? "+
				" )";


		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setInt   	(1,		seqidx					  ); 
			pstmt.setString	(2,		bean.getSubject			()); 
			pstmt.setString	(3,		bean.getSql				()); 
			pstmt.setInt   	(4,		bean.getReject_slist_idx()); 
			pstmt.setInt   	(5,		bean.getBlock_group_idx	()); 
			pstmt.setString	(6,		bean.getMailfrom		()); 
			pstmt.setString (7,		bean.getMailto			()); 
			pstmt.setString (8,		bean.getReplyto			()); 
			pstmt.setString	(9,		bean.getErrosto			()); 
			pstmt.setInt   	(10,	bean.getHtml			()); 
			pstmt.setInt   	(11,	bean.getEncoding		()); 
			pstmt.setString	(12,	bean.getCharset			()); 
			pstmt.setInt   	(13,	bean.getDuration_set	()); 
			pstmt.setInt   	(14,	bean.getClick_set		()); 
			pstmt.setInt   	(15,	bean.getSite_set		()); 
			pstmt.setInt    (16,	bean.getAtc_set			()); 
			pstmt.setString	(17,	bean.getGubun			()); 
			pstmt.setString	(18,	bean.getRname			()); 
			pstmt.setInt   	(19,	bean.getMtype       	()); 
			pstmt.setInt   	(20,	bean.getU_idx       	()); 
			pstmt.setInt   	(21,	bean.getG_idx			()); 
			pstmt.setInt   	(22,	bean.getMsgflag     	()); 
			pstmt.setString	(23,	bean.getContent			()); 
			pstmt.setString	(24,		bean.getSql				()); 
			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertDEmail96]\n"+e);
			System.out.println("[ImEmailDatabase:insertDEmail96]\n"+query);
			System.out.println("[ImEmailDatabase:insertDEmail96]\n"+query1);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seqidx;
		}
	}

	/**
	 *	계약서안내문메일관리
	 */
	public Vector getReNewInfoMailDocSendList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String where = "";
		String search = "";
		String what = "";
		String dt4 = "b.sdate";
		
		if(gubun1.equals("2"))			where += " and "+dt4+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		where += " and "+dt4+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun1.equals("4"))		where += " and "+dt4+" like to_char(sysdate-1,'YYYYMMDD')||'%'";//전일
		else if(gubun1.equals("5"))		where += " and "+dt4+" like to_char(sysdate,'YYYY')||'%'";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	where += " and "+dt4+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) where += " and "+dt4+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query = " select * "+
				" from     \n"+
				"        ( \n"+
				"          select '5' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.code_nm, c.code_st1, c.code_st2, c.note, c.r_st,  "+
				"                 decode(a.errcode,114,'정상발송',c.code_st2) errcode_nm,  "+
				"                 decode(nvl(a.ocnt,99),99,'대기',-1,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm, DECODE(SUBSTR(b.gubun2,24),'_re','담당자','고객') to_type  "+
				"          from   im_dmail_info_5 b, im_dmail_result_5 a, im_dmail_errcode c  "+
				"          where  b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) \n"+ where +
                "          UNION all  "+
				"          select '9' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, b.gubun2,  "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm, "+
				"                 decode(nvl(a.ocnt,99),99,'대기',0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm, DECODE(SUBSTR(b.gubun2,24),'_re','담당자','고객') to_type "+
				"          from   im_dmail_info_9 b, im_dmail_result_9 a, im_dmail_j_errcode c "+
				"          where  b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) \n"+ where +
				"        ) \n";

		if(gubun2.equals("1"))			query += " where ocnt=1";
		if(gubun2.equals("2"))			query += " where ocnt=-1";
		if(gubun2.equals(""))			query += " where 1=1";

		if(gubun3.equals("1"))			query += " and code_st2='네트웍 에러'";
		if(gubun3.equals("2"))			query += " and code_st2='서버 에러'";
		if(gubun3.equals("3"))			query += " and code_st2='메일박스풀'";
		if(gubun3.equals("4"))			query += " and r_st='R'";

		//query += " and gubun2 not like '%newcar_doc_rec' ";

		if(gubun5.equals("1"))			query += " and gubun2 like '%newcar_doc' ";
		if(gubun5.equals("2"))			query += " and gubun2 like '%newcar_doc_re%' ";
		

		if(s_kd.equals("1"))	what = "upper(nvl(sql, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(mailto, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(subject, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by dmidx, stime, sdate"+
                " ";

//System.out.println("mail : "+query);

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getReNewInfoMailDocSendList]\n"+e);
			System.out.println("[ImEmailDatabase:getReNewInfoMailDocSendList]\n"+query);
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
	 *	계약서안내문메일관리
	 */
	public Vector getReNewInfoMailDocSendList(String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * "+
				" from     \n"+
				"        ( \n"+
				"          select '5' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.code_nm, c.code_st1, c.code_st2, c.note, c.r_st,  "+
				"                 decode(a.errcode,114,'정상발송',c.code_st2) errcode_nm,  "+
				"                 decode(nvl(a.ocnt,99),99,'대기',-1,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm, DECODE(SUBSTR(b.gubun2,24),'_re','담당자','고객') to_type  "+
				"          from   im_dmail_info_5 b, im_dmail_result_5 a, im_dmail_errcode c  "+
				"          where  b.gubun='"+gubun+"' and b.sql<>'SSV:dev@amazoncar.co.kr' and b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) "+
                "          UNION all  "+
				"          select '5' st, a.*, b.subject, substr(b.subject,1,45) subject2, b.sql, b.mailfrom, b.mailto, b.sdate, b.gubun, b.gubun2, "+
				"                 c.send as code_nm, c.send as code_st1, c.send as code_st2, c.note, c.ret_st as r_st, "+
				"                 decode(a.errcode,'100','전송성공','101','전송성공',c.send) errcode_nm,  "+
				"                 decode(nvl(a.ocnt,99),99,'대기',0,'미수신','수신') ocnt_nm, substr(b.mailto,2,instr(b.mailto,'<')-3) firm_nm, DECODE(SUBSTR(b.gubun2,24),'_re','담당자','고객') to_type  "+
				"          from   im_dmail_info_9 b, im_dmail_result_9 a, im_dmail_j_errcode c  "+
				"          where  b.gubun='"+gubun+"' and b.qry<>'SSV:dev@amazoncar.co.kr' and b.seqidx=a.dmidx(+) and a.errcode=c.code_id(+) "+
				"        ) \n";

		query += " order by dmidx"+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getReNewInfoMailDocSendList(String gubun)]\n"+e);
			System.out.println("[ImEmailDatabase:getReNewInfoMailDocSendList(String gubun)]\n"+query);
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

	//안내메일 첨부파일 등록
	public boolean insertDEmailEnc(String table_num, String gubun, String gubun2, String fileinfo, String content, String attach_seq, String filename)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;

		ResultSet rs1 = null;
		String query = "";
		int seqidx = 0;
		int idx = 0;

		if(table_num.equals("")) table_num = "8";
		if(table_num.equals("2")) table_num = "6";
		if(table_num.equals("3")) table_num = "7";
		if(table_num.equals("4")) table_num = "8";
		if(table_num.equals("5")) table_num = "9";
			
		String query1 = " select max(seqidx) from IM_DMAIL_INFO_"+table_num+" where gubun='"+gubun+"'";

		if(!gubun2.equals(""))	query1 += " and gubun2='"+gubun2+"'";


		query = " INSERT INTO im_enc_dmail_"+table_num+" ( idx, seqidx, fileinfo, content, v_content, attach_seq, filename ) VALUES "+
				" ( (SELECT nvl(max(idx)+1,1) FROM IM_ENC_DMAIL_"+table_num+" ), ?, ?, ?, ?, ?, ? ) ";

		if(table_num.equals("9")){

			query = " INSERT INTO im_enc_dmail_"+table_num+"_F ( idx, seqidx, fileinfo, content, v_content, attach_seq, filename ) VALUES "+
					" ( (SELECT nvl(max(idx)+1,1) FROM IM_ENC_DMAIL_"+table_num+"_F ), ?, ?, ?, ?, ?, ? ) ";

		}

		try 
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				seqidx = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);

			pstmt.setInt   	(1,		seqidx	); 

			if(table_num.equals("9")){
				pstmt.setString	(2,		""); 
				pstmt.setString	(3,		""); 
				pstmt.setString	(4,		content); 
				pstmt.setString	(5,		attach_seq); 
				pstmt.setString	(6,		filename); 
			}else{
				pstmt.setString	(2,		fileinfo); 
				pstmt.setString	(3,		content); 
				pstmt.setString	(4,		content); 
				pstmt.setString	(5,		attach_seq); 
				pstmt.setString	(6,		""); 
			}

			pstmt.executeUpdate();	
			pstmt.close();
			
			conn.commit();
																 
	  	} catch (Exception e) {
			System.out.println("[ImEmailDatabase:insertDEmailEnc]\n"+e);
			System.out.println("[ImEmailDatabase:insertDEmailEnc]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt != null )		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	안내문메일관리 - 메일 & 첨부파일 정보
	 */
	public Vector getImDmailEncListF(String table_num, String gubun, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(table_num.equals("")) table_num = "8";
		if(table_num.equals("2")) table_num = "6";
		if(table_num.equals("3")) table_num = "7";
		if(table_num.equals("4")) table_num = "8";
		if(table_num.equals("5")) table_num = "9";


		query = " select b.fileinfo, b.v_content AS file_content, b.attach_seq, b.filename, c.file_size , c.content_code  "+
				" from   IM_DMAIL_INFO_"+table_num+" a, IM_ENC_DMAIL_"+table_num+"_F b, ACAR_ATTACH_FILE c "+
				" where  a.gubun='"+gubun+"' and a.gubun2='"+gubun2+"' and b.seqidx=a.seqidx "+
			    "        and b.attach_seq=c.seq "+
				" order by b.idx  "+
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getImDmailEncListF]\n"+e);
			System.out.println("[ImEmailDatabase:getImDmailEncListF]\n"+query);
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

	//리콜 안내문 발송 위한 대상 리스트(20190104)
	public Vector getListForRecallMail(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String sort, String sort_fuel)
	{
		getConnection();
		PreparedStatement pstmt = null; 
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.client_id, a.rent_l_cd, a.rent_mng_id, a.car_mng_id, b.firm_nm, c.car_no, c.car_nm, \n"+
				" 		 d.car_id, d.car_seq, e.car_comp_id, e.car_cd, e.car_name, \n"+
				"        DECODE(c.dpm,'',e.dpm, c.dpm) AS dpm, \n"+
				"        DECODE(e.diesel_yn,'1','휘발유','Y','디젤','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소',e.diesel_yn)AS diesel_yn, \n"+
				"		 DECODE(a.car_gu,'2',d.sh_init_reg_dt, c.init_reg_dt) AS car_reg_dt , c.car_num \n"+
				"   FROM cont a, client b, car_reg c, car_etc d, car_nm e  \n"+
				"   WHERE a.client_id = b.client_id \n"+
				"     AND a.car_mng_id = c.car_mng_id(+) \n"+
				"     AND a.rent_l_cd = d.rent_l_cd AND a.rent_mng_id = d.rent_mng_id  \n"+
				"     AND d.car_id = e.car_id AND d.car_seq = e.car_seq \n"+ 
                "     AND a.use_yn = 'Y' \n";
		
		if(!gubun1.equals(""))		query += "	AND e.car_comp_id ='"+gubun1+"'";
		if(!gubun2.equals(""))		query += "	AND c.car_nm like UPPER('%"+gubun2+"%')";
		if(!gubun3.equals(""))		query += "	AND e.car_name like UPPER('%"+gubun3+"%')";
		if(!gubun4.equals(""))		query += "	AND e.diesel_yn ='"+gubun4+"'";
	
		if(!st_dt.equals("")&&!end_dt.equals(""))	  {	query += "AND DECODE(a.car_gu,'2',d.sh_init_reg_dt, c.init_reg_dt) between replace('"+st_dt+"', '-','') and replace('"+end_dt+"','-','')";		}
		else if(!st_dt.equals("")&&end_dt.equals("")){	query += "AND DECODE(a.car_gu,'2',d.sh_init_reg_dt, c.init_reg_dt) >= replace('"+st_dt+"', '-','')";		}
		else if(st_dt.equals("")&&!end_dt.equals("")){	query += "AND DECODE(a.car_gu,'2',d.sh_init_reg_dt, c.init_reg_dt) <= replace('"+end_dt+"', '-','')";		}
		
		//정렬
		if		(sort.equals("1")){	query += "ORDER BY DECODE(a.car_gu,'2',d.sh_init_reg_dt, c.init_reg_dt), b.firm_nm asc ";	}
		else if	(sort.equals("2")){	query += "ORDER BY b.firm_nm asc ";				}
		else if	(sort.equals("3")){
			if		(sort_fuel.equals("1")){	query += "ORDER BY decode(e.diesel_yn,'1','1','Y','2','2','3') ";	}
			else if	(sort_fuel.equals("Y")){	query += "ORDER BY decode(e.diesel_yn,'Y','1','1','2','2','3') ";	}
			else if	(sort_fuel.equals("2")){	query += "ORDER BY decode(e.diesel_yn,'2','1','1','2','Y','3') "; 	}
		}
		
		query +=	" ";		

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getListForRecallMail(]\n"+e);
			System.out.println("[ImEmailDatabase:getListForRecallMail(]\n"+query);
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
	
	//리콜 안내문 발송 위한 대상 리스트(20190104)
	public Vector getListForRecallMail(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String sort, String sort_fuel)
	{
		getConnection();
		PreparedStatement pstmt = null; 
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.client_id, a.rent_l_cd, a.rent_mng_id, a.car_mng_id, b.firm_nm, c.car_no, c.car_nm, \n"+
				" 		 d.car_id, d.car_seq, e.car_comp_id, e.car_cd, e.car_name, \n"+
				"        DECODE(c.dpm,'',e.dpm, c.dpm) AS dpm, \n"+
				"        DECODE(e.diesel_yn,'1','휘발유','Y','디젤','2','LPG','3','하이브리드','4','플러그하이브리드','5','전기','6','수소',e.diesel_yn) AS diesel_yn, \n"+
				"		 DECODE(a.car_gu,'2',d.sh_init_reg_dt, c.init_reg_dt) AS car_reg_dt , c.car_num \n"+
				"   FROM cont a, client b, car_reg c, car_etc d, car_nm e, temp_hightech f  \n"+
				"   WHERE a.client_id = b.client_id \n"+
				"     AND a.car_mng_id = c.car_mng_id \n"+
				"     AND a.rent_l_cd = d.rent_l_cd AND a.rent_mng_id = d.rent_mng_id  \n"+
				"     AND d.car_id = e.car_id AND d.car_seq = e.car_seq \n"+ 
				"     AND c.car_mng_id=f.car_mng_id AND c.car_no=f.car_no \n"+
                "     AND a.use_yn = 'Y' \n";
		
		if(!gubun1.equals(""))		query += "	AND e.car_comp_id ='"+gubun1+"'";
		if(!gubun2.equals(""))		query += "	AND c.car_nm like UPPER('%"+gubun2+"%')";
		if(!gubun3.equals(""))		query += "	AND e.car_name like UPPER('%"+gubun3+"%')";
		if(!gubun4.equals(""))		query += "	AND e.diesel_yn ='"+gubun4+"'";
	
		if(!st_dt.equals("")&&!end_dt.equals(""))	  {	query += "AND DECODE(a.car_gu,'2',d.sh_init_reg_dt, c.init_reg_dt) between replace('"+st_dt+"', '-','') and replace('"+end_dt+"','-','')";		}
		else if(!st_dt.equals("")&&end_dt.equals("")){	query += "AND DECODE(a.car_gu,'2',d.sh_init_reg_dt, c.init_reg_dt) >= replace('"+st_dt+"', '-','')";		}
		else if(st_dt.equals("")&&!end_dt.equals("")){	query += "AND DECODE(a.car_gu,'2',d.sh_init_reg_dt, c.init_reg_dt) <= replace('"+end_dt+"', '-','')";		}
		
		//사양검색
		if(!gubun5.equals("")) {
			if(gubun6.equals("1")) {
				query += " and (f.car_b LIKE '%"+gubun5+"%' OR f.car_s LIKE '%"+gubun5+"%' or f.opt_b LIKE '%"+gubun5+"%' OR f.car_b2 LIKE '%"+gubun5+"%' OR f.car_b3 LIKE '%"+gubun5+"%' OR f.car_b4 LIKE '%"+gubun5+"%' OR f.car_b5 LIKE '%"+gubun5+"%' OR f.car_b6 LIKE '%"+gubun5+"%' OR f.car_b7 LIKE '%"+gubun5+"%')";
			}else {
				query += " and (NVL(f.car_b,'-') NOT LIKE '%"+gubun5+"%' and NVL(f.car_s,'-') NOT LIKE '%"+gubun5+"%' and NVL(f.opt_b,'-') NOT LIKE '%"+gubun5+"%' and NVL(f.car_b2,'-') NOT LIKE '%"+gubun5+"%' and NVL(f.car_b3,'-') NOT LIKE '%"+gubun5+"%' and NVL(f.car_b4,'-') NOT LIKE '%"+gubun5+"%' and NVL(f.car_b5,'-') NOT LIKE '%"+gubun5+"%' and NVL(f.car_b6,'-') NOT LIKE '%"+gubun5+"%' and NVL(f.car_b7,'-') NOT LIKE '%"+gubun5+"%')";
			}			
		}
		
		//정렬
		if		(sort.equals("1")){	query += "ORDER BY DECODE(a.car_gu,'2',d.sh_init_reg_dt, c.init_reg_dt), b.firm_nm asc ";	}
		else if	(sort.equals("2")){	query += "ORDER BY b.firm_nm asc ";				}
		else if	(sort.equals("3")){
			if		(sort_fuel.equals("1")){	query += "ORDER BY decode(e.diesel_yn,'1','1','Y','2','2','3') ";	}
			else if	(sort_fuel.equals("Y")){	query += "ORDER BY decode(e.diesel_yn,'Y','1','1','2','2','3') ";	}
			else if	(sort_fuel.equals("2")){	query += "ORDER BY decode(e.diesel_yn,'2','1','1','2','Y','3') "; 	}
		}
		
		query +=	" ";		

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ImEmailDatabase:getListForRecallMail(]\n"+e);
			System.out.println("[ImEmailDatabase:getListForRecallMail(]\n"+query);
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
