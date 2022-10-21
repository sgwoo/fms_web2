package acar.doc_settle;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

import acar.beans.AttachedFile;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;
import acar.util.AddUtil;

public class DocSettleDatabase
{
	private Connection conn = null;
	public static DocSettleDatabase db;
	
	public static DocSettleDatabase getInstance()
	{
		if(DocSettleDatabase.db == null)
			DocSettleDatabase.db = new DocSettleDatabase();
		return DocSettleDatabase.db;
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
	public DocSettleBean getDocSettle(String doc_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DocSettleBean bean = new DocSettleBean();
		String query = "";
		query = " select doc_no, doc_st, doc_id, sub, cont, etc, "+
				"        user_nm1,  user_id1,  user_dt1, "+
				" 		 user_nm2,  user_id2,  user_dt2, "+
		        "        user_nm3,  user_id3,  user_dt3, "+
		        "        user_nm4,  user_id4,  user_dt4, "+
		        "        user_nm5,  user_id5,  user_dt5, "+
		        "        user_nm6,  user_id6,  user_dt6, "+
		        "        user_nm7,  user_id7,  user_dt7, "+
		        "        user_nm8,  user_id8,  user_dt8, "+
		        "        user_nm9,  user_id9,  user_dt9, "+
		        "        user_nm10, user_id10, user_dt10, "+
				"        doc_bit, doc_step, nvl(doc_dt,to_char(user_dt1,'YYYYMMDD')) doc_dt, "+
				"        DECODE(doc_bit,'1',TO_CHAR(user_dt1,'YYYYMMDD'),'2',TO_CHAR(user_dt2,'YYYYMMDD'),TO_CHAR(SYSDATE,'YYYYMMDD')) end_dt "+
				" from   doc_settle where doc_no = ?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_no);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setDoc_no		(rs.getString("doc_no")==null?"":rs.getString("doc_no"));
				bean.setDoc_st		(rs.getString("doc_st")==null?"":rs.getString("doc_st"));
				bean.setDoc_id		(rs.getString("doc_id")==null?"":rs.getString("doc_id"));
				bean.setSub			(rs.getString("sub")==null?"":rs.getString("sub"));
				bean.setCont		(rs.getString("cont")==null?"":rs.getString("cont"));
				bean.setEtc			(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setUser_nm1	(rs.getString("user_nm1")==null?"":rs.getString("user_nm1"));	
				bean.setUser_id1	(rs.getString("user_id1")==null?"":rs.getString("user_id1"));
				bean.setUser_dt1	(rs.getString("user_dt1")==null?"":rs.getString("user_dt1"));
				bean.setUser_nm2	(rs.getString("user_nm2")==null?"":rs.getString("user_nm2"));	
				bean.setUser_id2	(rs.getString("user_id2")==null?"":rs.getString("user_id2"));
				bean.setUser_dt2	(rs.getString("user_dt2")==null?"":rs.getString("user_dt2"));
				bean.setUser_nm3	(rs.getString("user_nm3")==null?"":rs.getString("user_nm3"));	
				bean.setUser_id3	(rs.getString("user_id3")==null?"":rs.getString("user_id3"));
				bean.setUser_dt3	(rs.getString("user_dt3")==null?"":rs.getString("user_dt3"));
				bean.setUser_nm4	(rs.getString("user_nm4")==null?"":rs.getString("user_nm4"));	
				bean.setUser_id4	(rs.getString("user_id4")==null?"":rs.getString("user_id4"));
				bean.setUser_dt4	(rs.getString("user_dt4")==null?"":rs.getString("user_dt4"));
				bean.setUser_nm5	(rs.getString("user_nm5")==null?"":rs.getString("user_nm5"));	
				bean.setUser_id5	(rs.getString("user_id5")==null?"":rs.getString("user_id5"));
				bean.setUser_dt5	(rs.getString("user_dt5")==null?"":rs.getString("user_dt5"));
				bean.setUser_nm6	(rs.getString("user_nm6")==null?"":rs.getString("user_nm6"));	
				bean.setUser_id6	(rs.getString("user_id6")==null?"":rs.getString("user_id6"));
				bean.setUser_dt6	(rs.getString("user_dt6")==null?"":rs.getString("user_dt6"));
				bean.setUser_nm7	(rs.getString("user_nm7")==null?"":rs.getString("user_nm7"));	
				bean.setUser_id7	(rs.getString("user_id7")==null?"":rs.getString("user_id7"));
				bean.setUser_dt7	(rs.getString("user_dt7")==null?"":rs.getString("user_dt7"));
				bean.setUser_nm8	(rs.getString("user_nm8")==null?"":rs.getString("user_nm8"));	
				bean.setUser_id8	(rs.getString("user_id8")==null?"":rs.getString("user_id8"));
				bean.setUser_dt8	(rs.getString("user_dt8")==null?"":rs.getString("user_dt8"));
				bean.setUser_nm9	(rs.getString("user_nm9")==null?"":rs.getString("user_nm9"));	
				bean.setUser_id9	(rs.getString("user_id9")==null?"":rs.getString("user_id9"));
				bean.setUser_dt9	(rs.getString("user_dt9")==null?"":rs.getString("user_dt9"));
				bean.setUser_nm10	(rs.getString("user_nm10")==null?"":rs.getString("user_nm10"));	
				bean.setUser_id10	(rs.getString("user_id10")==null?"":rs.getString("user_id10"));
				bean.setUser_dt10	(rs.getString("user_dt10")==null?"":rs.getString("user_dt10"));
				bean.setDoc_bit		(rs.getString("doc_bit")==null?"":rs.getString("doc_bit"));
				bean.setDoc_step	(rs.getString("doc_step")==null?"":rs.getString("doc_step"));
				bean.setDoc_dt		(rs.getString("doc_dt")==null?"":rs.getString("doc_dt"));
				bean.setVar01		(rs.getString("end_dt")==null?"":rs.getString("end_dt"));
									
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[DocSettleDatabase:getDocSettle]\n"+e);
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
	public DocSettleBean getDocSettleCommi(String doc_st, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DocSettleBean bean = new DocSettleBean();
		String query = "";
		query = " select doc_no, doc_st, doc_id, sub, cont, etc, "+
				"        user_nm1, user_id1, user_dt1, "+
				"        user_nm2, user_id2, user_dt2, "+
				"        user_nm3, user_id3, user_dt3, "+
				"        user_nm4, user_id4, user_dt4, "+
				"        user_nm5, user_id5, user_dt5, "+
				"        user_nm6, user_id6, user_dt6, "+
				"        user_nm7, user_id7, user_dt7, "+
				"        user_nm8, user_id8, user_dt8, "+
				"        user_nm9, user_id9, user_dt9, "+
				"        user_nm10, user_id10, user_dt10, "+
				"        doc_bit, doc_step "+
				" from   doc_settle "+
				" where  doc_st=? and doc_id = ?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_st);
			pstmt.setString(2, rent_l_cd);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setDoc_no		(rs.getString("doc_no")==null?"":rs.getString("doc_no"));
				bean.setDoc_st		(rs.getString("doc_st")==null?"":rs.getString("doc_st"));
				bean.setDoc_id		(rs.getString("doc_id")==null?"":rs.getString("doc_id"));
				bean.setSub			(rs.getString("sub")==null?"":rs.getString("sub"));
				bean.setCont		(rs.getString("cont")==null?"":rs.getString("cont"));
				bean.setEtc			(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setUser_nm1	(rs.getString("user_nm1")==null?"":rs.getString("user_nm1"));	
				bean.setUser_id1	(rs.getString("user_id1")==null?"":rs.getString("user_id1"));
				bean.setUser_dt1	(rs.getString("user_dt1")==null?"":rs.getString("user_dt1"));
				bean.setUser_nm2	(rs.getString("user_nm2")==null?"":rs.getString("user_nm2"));	
				bean.setUser_id2	(rs.getString("user_id2")==null?"":rs.getString("user_id2"));
				bean.setUser_dt2	(rs.getString("user_dt2")==null?"":rs.getString("user_dt2"));
				bean.setUser_nm3	(rs.getString("user_nm3")==null?"":rs.getString("user_nm3"));	
				bean.setUser_id3	(rs.getString("user_id3")==null?"":rs.getString("user_id3"));
				bean.setUser_dt3	(rs.getString("user_dt3")==null?"":rs.getString("user_dt3"));
				bean.setUser_nm4	(rs.getString("user_nm4")==null?"":rs.getString("user_nm4"));	
				bean.setUser_id4	(rs.getString("user_id4")==null?"":rs.getString("user_id4"));
				bean.setUser_dt4	(rs.getString("user_dt4")==null?"":rs.getString("user_dt4"));
				bean.setUser_nm5	(rs.getString("user_nm5")==null?"":rs.getString("user_nm5"));	
				bean.setUser_id5	(rs.getString("user_id5")==null?"":rs.getString("user_id5"));
				bean.setUser_dt5	(rs.getString("user_dt5")==null?"":rs.getString("user_dt5"));
				bean.setUser_nm6	(rs.getString("user_nm6")==null?"":rs.getString("user_nm6"));	
				bean.setUser_id6	(rs.getString("user_id6")==null?"":rs.getString("user_id6"));
				bean.setUser_dt6	(rs.getString("user_dt6")==null?"":rs.getString("user_dt6"));
				bean.setUser_nm7	(rs.getString("user_nm7")==null?"":rs.getString("user_nm7"));	
				bean.setUser_id7	(rs.getString("user_id7")==null?"":rs.getString("user_id7"));
				bean.setUser_dt7	(rs.getString("user_dt7")==null?"":rs.getString("user_dt7"));
				bean.setUser_nm8	(rs.getString("user_nm8")==null?"":rs.getString("user_nm8"));	
				bean.setUser_id8	(rs.getString("user_id8")==null?"":rs.getString("user_id8"));
				bean.setUser_dt8	(rs.getString("user_dt8")==null?"":rs.getString("user_dt8"));
				bean.setUser_nm9	(rs.getString("user_nm9")==null?"":rs.getString("user_nm9"));	
				bean.setUser_id9	(rs.getString("user_id9")==null?"":rs.getString("user_id9"));
				bean.setUser_dt9	(rs.getString("user_dt9")==null?"":rs.getString("user_dt9"));
				bean.setUser_nm10	(rs.getString("user_nm10")==null?"":rs.getString("user_nm10"));	
				bean.setUser_id10	(rs.getString("user_id10")==null?"":rs.getString("user_id10"));
				bean.setUser_dt10	(rs.getString("user_dt10")==null?"":rs.getString("user_dt10"));
				bean.setDoc_bit		(rs.getString("doc_bit")==null?"":rs.getString("doc_bit"));
				bean.setDoc_step	(rs.getString("doc_step")==null?"":rs.getString("doc_step"));									
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[DocSettleDatabase:getDocSettleCommi]\n"+e);
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

	//영업수당문서처리관리 리스트 조회
	public Vector getDocSettleList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String start_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" a.*,"+
				" decode(a.doc_st,'1','영업수당','2','탁송의뢰','3','탁송료','4','차량출고','5','차량대금','6','용품의뢰','7','용품대금','8','특근신청','11','해지정산','21','연차신청', '22','연차취소', '31','출금기안','32','송금요청') doc_st_nm,"+
				" decode(a.doc_step,'3','완결','미결') doc_step_nm,"+
				" b.rent_mng_id, b.rent_l_cd, "+
				" decode(a.doc_st,'8','','21','','22','',nvl(c.firm_nm,f.firm_nm)) firm_nm, "+
				" decode(a.doc_st,'8','','21','','22','',nvl(d.car_no,e.car_no)) car_no, "+
				" decode(a.doc_st,'8','','21','','22','',nvl(d.car_nm,e.car_nm)) car_nm,"+
				" u1.user_nm  as nm1,"+
				" u2.user_nm  as nm2,"+
				" u3.user_nm  as nm3,"+
				" u4.user_nm  as nm4,"+
				" u5.user_nm  as nm5,"+
				" u6.user_nm  as nm6,"+
				" u7.user_nm  as nm7,"+
				" u8.user_nm  as nm8,"+
				" u9.user_nm  as nm9,"+
				" u10.user_nm as nm10"+
				" from doc_settle a, cont b, client c, car_reg d, consignment e, client f, "+
				"      users u1, users u2, users u3, users u4, users u5, users u6, users u7, users u8, users u9, users u10 "+
				" where"+
				" a.doc_id=b.rent_l_cd(+)"+
				" and a.doc_id=e.cons_no(+)"+
				" and b.client_id=c.client_id(+)"+
				" and e.client_id=f.client_id(+)"+
				" and b.car_mng_id=d.car_mng_id(+)"+
				" and a.user_id1=u1.user_id(+)"+
				" and a.user_id2=u2.user_id(+)"+
				" and a.user_id3=u3.user_id(+)"+
				" and a.user_id4=u4.user_id(+)"+
				" and a.user_id5=u5.user_id(+)"+
				" and a.user_id6=u6.user_id(+)"+
				" and a.user_id7=u7.user_id(+)"+
				" and a.user_id8=u8.user_id(+)"+
				" and a.user_id9=u9.user_id(+)"+
				" and a.user_id10=u10.user_id(+)";

		if(gubun1.equals("1"))			query += " and a.doc_no like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun1.equals("2"))		query += " and a.doc_no like to_char(sysdate,'YYYYMM')||'%'";

		if(gubun1.equals("3") && !start_dt.equals(""))		query += " and a.doc_no between '"+AddUtil.replace(start_dt,"-","")+"' and '"+AddUtil.replace(end_dt,"-","")+"'";		
		

		if(gubun2.equals("1"))			query += " and a.doc_step<>'3'";
		else if(gubun2.equals("2"))		query += " and a.doc_step='3'";

		if(!gubun3.equals(""))			query += " and a.doc_st='"+gubun3+"'";

			
		if(!s_kd.equals("") && !t_wd.equals("")){

			String what = "";

			if(s_kd.equals("1"))	what = "c.firm_nm";
			if(s_kd.equals("2"))	what = "b.rent_l_cd";	
			if(s_kd.equals("3"))	what = "d.car_no";
			if(s_kd.equals("4"))	what = "u1.user_nm";	
			if(s_kd.equals("5"))	what = "u2.user_nm||u3.user_nm||u4.user_nm||u5.user_nm||u6.user_nm||u7.user_nm||u8.user_nm||u9.user_nm||u10.user_nm";	
			
			if(!what.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}

		}	
		
		query += " order by a.doc_no desc";


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
			System.out.println("[DocSettleDatabase:getDocSettleList]\n"+e);
			System.out.println("[DocSettleDatabase:getDocSettleList]\n"+query);
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

	//영업수당문서처리관리 리스트 조회
	public Vector getDocSettleUserList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String start_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String search = "";
		String what = "";

		if(s_kd.equals("5"))	{
				
			if(gubun2.equals("1"))			search = " is null";
			else if(gubun2.equals("2"))		search = " is not null";

			search += " and b.user_nm ='"+t_wd+"'";

		
			if(!gubun3.equals(""))			search += " and a.doc_st='"+gubun3+"'";


			query = " select distinct "+
					" a.user_nm, a.doc_no, a.doc_st, a.doc_id, a.sub, a.cont, a.etc, a.doc_bit, a.doc_step,\n"+
					" a.user_nm1, a.user_nm2, a.user_nm3, a.user_nm4, a.user_nm5, a.user_nm6, a.user_nm7, a.user_nm8, a.user_nm9, a.user_nm10,\n"+
					" a.user_id1, a.user_id2, a.user_id3, a.user_id4, a.user_id5, a.user_id6, a.user_id7, a.user_id8, a.user_id9, a.user_id10,\n"+
					" substr(a.user_dt1,1,8) user_dt1, substr(a.user_dt2,1,8) user_dt2, substr(a.user_dt3,1,8) user_dt3, \n"+
					" substr(a.user_dt4,1,8) user_dt4, substr(a.user_dt5,1,8) user_dt5, substr(a.user_dt6,1,8) user_dt6, \n"+
					" substr(a.user_dt7,1,8) user_dt7, substr(a.user_dt8,1,8) user_dt8, substr(a.user_dt9,1,8) user_dt9, \n"+
					" substr(a.user_dt10,1,8) user_dt10, \n"+
					" decode(a.doc_st,'1','영업수당','2','탁송의뢰','3','탁송료','4','차량출고','5','차량대금','6','용품의뢰','7','용품대금','8','특근신청','11','해지정산','21','연차신청', '22','연차취소', '31','출금기안','32','송금요청') doc_st_nm,\n"+
					" decode(a.doc_step,'3','완결','미결') doc_step_nm,\n"+
					" b.rent_mng_id, b.rent_l_cd, g.cls_st, "+
					" nvl(c.firm_nm,decode(a.doc_st,'2',f.firm_nm)) firm_nm, "+
					" nvl(d.car_no,decode(a.doc_st,'2',e.car_no)) car_no, "+
					" nvl(d.car_nm,decode(a.doc_st,'2',e.car_nm)) car_nm \n"+
					" from \n"+
					" (\n"+
				    " select b.user_nm, a.user_dt1 as san_dt, a.* from doc_settle a, users b where a.user_dt1 "+search+" and a.user_id1=b.user_id\n"+
				    " union all \n"+
				    " select b.user_nm, a.user_dt2 as san_dt, a.* from doc_settle a, users b where a.user_dt2 "+search+" and a.user_id2=b.user_id\n"+
				    " union all \n"+
				    " select b.user_nm, a.user_dt3 as san_dt, a.* from doc_settle a, users b where a.user_dt3 "+search+" and a.user_id3=b.user_id\n"+
				    " union all \n"+
				    " select b.user_nm, a.user_dt4 as san_dt, a.* from doc_settle a, users b where a.user_dt4 "+search+" and a.user_id4=b.user_id\n"+
				    " union all \n"+
				    " select b.user_nm, a.user_dt5 as san_dt, a.* from doc_settle a, users b where a.user_dt5 "+search+" and a.user_id5=b.user_id\n"+
				    " union all \n"+
				    " select b.user_nm, a.user_dt6 as san_dt, a.* from doc_settle a, users b where a.user_dt6 "+search+" and a.user_id6=b.user_id\n"+
				    " union all \n"+
				    " select b.user_nm, a.user_dt7 as san_dt, a.* from doc_settle a, users b where a.user_dt7 "+search+" and a.user_id7=b.user_id\n"+
				    " union all \n"+
				    " select b.user_nm, a.user_dt8 as san_dt, a.* from doc_settle a, users b where a.user_dt8 "+search+" and a.user_id8=b.user_id\n"+
				    " union all \n"+
				    " select b.user_nm, a.user_dt9 as san_dt, a.* from doc_settle a, users b where a.user_dt9 "+search+" and a.user_id9=b.user_id\n"+
				    " union all \n"+
				    " select b.user_nm, a.user_dt10 as san_dt, a.* from doc_settle a, users b where a.user_dt10 "+search+" and a.user_id10=b.user_id\n"+
					" ) a, \n"+
					" cont b, client c, car_reg d, (select * from consignment where seq=1) e, client f, cls_cont g \n"+
					" where"+
					" a.doc_id=b.rent_l_cd(+) \n"+
					" and a.doc_id=e.cons_no(+) \n"+
					" and b.client_id=c.client_id(+) \n"+
					" and e.client_id=f.client_id(+) \n"+
					" and b.car_mng_id=d.car_mng_id(+) \n"+
					" and b.rent_mng_id=g.rent_mng_id(+) and b.rent_l_cd=g.rent_l_cd(+) "+
					" ";

			if(gubun2.equals("1")){
				query += " and a.doc_step<>'3'";

				if(gubun1.equals("1"))			query += " and a.doc_no like to_char(sysdate,'YYYYMMDD')||'%'";
				else if(gubun1.equals("2"))		query += " and a.doc_no like to_char(sysdate,'YYYYMM')||'%'";
	
				if(gubun1.equals("3") && !start_dt.equals(""))		query += " and substr(a.doc_no,1,8) between '"+AddUtil.replace(start_dt,"-","")+"' and '"+AddUtil.replace(end_dt,"-","")+"'";		
			}else{
				query += " and a.doc_step='3'";
				
				if(gubun1.equals("1"))			query += " and to_char(a.san_dt,'YYYYMMDD')=to_char(sysdate,'YYYYMMDD')";
				else if(gubun1.equals("2"))		query += " and to_char(a.san_dt,'YYYYMM')=to_char(sysdate,'YYYYMM')";
	
				if(gubun1.equals("3") && !start_dt.equals(""))		query += " and to_char(a.san_dt,'YYYYMMDD') between '"+AddUtil.replace(start_dt,"-","")+"' and '"+AddUtil.replace(end_dt,"-","")+"'";		
			}

		}else{

			query = " select distinct \n"+
					" a.doc_no, a.doc_st, a.doc_id, a.sub, a.cont, a.etc, a.doc_bit, a.doc_step, \n"+
					" a.user_nm1, a.user_id1, to_char(a.user_dt1,'YYYYMMDD') user_dt1, \n"+
					" a.user_nm2, a.user_id2, to_char(a.user_dt2,'YYYYMMDD') user_dt2, \n"+
					" a.user_nm3, a.user_id3, to_char(a.user_dt3,'YYYYMMDD') user_dt3, \n"+
					" a.user_nm4, a.user_id4, to_char(a.user_dt4,'YYYYMMDD') user_dt4, \n"+
					" a.user_nm5, a.user_id5, to_char(a.user_dt5,'YYYYMMDD') user_dt5, \n"+
					" a.user_nm6, a.user_id6, to_char(a.user_dt6,'YYYYMMDD') user_dt6, \n"+
					" a.user_nm7, a.user_id7, to_char(a.user_dt7,'YYYYMMDD') user_dt7, \n"+
					" a.user_nm8, a.user_id8, to_char(a.user_dt8,'YYYYMMDD') user_dt8, \n"+
					" a.user_nm9, a.user_id9, to_char(a.user_dt9,'YYYYMMDD') user_dt9, \n"+
					" a.user_nm10, a.user_id10, substr(a.user_dt10,1,8) user_dt10, \n"+
					" decode(a.doc_st,'1','영업수당','2','탁송의뢰','3','탁송료','4','차량출고','5','차량대금','6','용품의뢰','7','용품대금','8','특근신청','11','해지정산','21','연차신청', '22','연차취소', '31','출금기안','32','송금요청') doc_st_nm, \n"+
					" decode(a.doc_step,'3','완결','미결') doc_step_nm, \n"+
					" b.rent_mng_id, b.rent_l_cd, "+
					" nvl(c.firm_nm,decode(a.doc_st,'2',f.firm_nm)) firm_nm, "+
					" nvl(d.car_no,decode(a.doc_st,'2',e.car_no)) car_no, "+
					" nvl(d.car_nm,decode(a.doc_st,'2',e.car_nm)) car_nm, \n"+
					" u1.user_nm  as nm1, \n"+
					" u2.user_nm  as nm2, \n"+
					" u3.user_nm  as nm3, \n"+
					" u4.user_nm  as nm4, \n"+
					" u5.user_nm  as nm5, \n"+
					" u6.user_nm  as nm6, \n"+
					" u7.user_nm  as nm7, \n"+
					" u8.user_nm  as nm8, \n"+
					" u9.user_nm  as nm9, \n"+
					" u10.user_nm as nm10, '' cls_st \n"+
					" from doc_settle a, cont b, client c, car_reg d, (select * from consignment where seq=1) e, client f, \n"+
					"      users u1, users u2, users u3, users u4, users u5, users u6, users u7, users u8, users u9, users u10  \n"+
					" where \n"+
					" a.doc_id=b.rent_l_cd(+) \n"+
					" and a.doc_id=e.cons_no(+) \n"+
					" and b.client_id=c.client_id(+) \n"+
					" and e.client_id=f.client_id(+) \n"+
					" and b.car_mng_id=d.car_mng_id(+) \n"+
					" and a.user_id1=u1.user_id(+) \n"+
					" and a.user_id2=u2.user_id(+) \n"+
					" and a.user_id3=u3.user_id(+)\n"+
					" and a.user_id4=u4.user_id(+) \n"+
					" and a.user_id5=u5.user_id(+) \n"+
					" and a.user_id6=u6.user_id(+) \n"+
					" and a.user_id7=u7.user_id(+) \n"+
					" and a.user_id8=u8.user_id(+) \n"+
					" and a.user_id9=u9.user_id(+) \n"+
					" and a.user_id10=u10.user_id(+)";

			if(gubun1.equals("1"))			query += " and a.doc_no like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun1.equals("2"))		query += " and a.doc_no like to_char(sysdate,'YYYYMM')||'%'";

			if(gubun1.equals("3") && !start_dt.equals(""))		query += " and a.doc_no between '"+AddUtil.replace(start_dt,"-","")+"' and '"+AddUtil.replace(end_dt,"-","")+"'";		
		

			if(gubun2.equals("1"))			query += " and a.doc_step<>'3'";
			else if(gubun2.equals("2"))		query += " and a.doc_step='3'";

			if(!gubun3.equals(""))			query += " and a.doc_st='"+gubun3+"'";

			
			if(!s_kd.equals("") && !t_wd.equals("")){

				if(s_kd.equals("1"))	what = "c.firm_nm";
				if(s_kd.equals("2"))	what = "b.rent_l_cd";	
				if(s_kd.equals("3"))	what = "d.car_no";
				if(s_kd.equals("4"))	what = "u1.br_id";	
				if(s_kd.equals("6"))	what = "u1.user_nm";	

			
				if(!what.equals("")){
					query += " and "+what+" like upper('%"+t_wd+"%') ";
				}
			}

		}	
		
		query += " order by decode(a.doc_st, '1',1,'4',2,'5',3,'3',4,'2',5,'11',6,'8',7,'21',8, 9), a.doc_no desc";

	//	System.out.println("[DocSettleDatabase:getDocSettleUserList]\n"+query);
		
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
			System.out.println("[DocSettleDatabase:getDocSettleUserList]\n"+e);
			System.out.println("[DocSettleDatabase:getDocSettleUserList]\n"+query);
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

	//영업수당문서처리관리 리스트 조회
	public Vector getCommiDocList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//미등록
		if(gubun1.equals("0")){
			
			query = " select  \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id, \n"+
					"        a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, \n"+
					"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, \n"+
					"        h.commi, h.dlv_con_commi, h.dlv_tns_commi, h.agent_commi, 0 as proxy_commi, h.emp_acc_nm, h.sup_dt, h.comm_r_rt, h.req_dt, \n"+
					"        h.emp_id, j.emp_nm, \n"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st, \n"+
					"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2, \n"+
					"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st, \n"+
					"        decode(k.rent_l_cd,'','미생성','생성') scd_yn, nvl(h3.pic_cnt2,0) scan_cnt, l.*, \n"+
					"        '대기' as bit, \n"+
					"        p.one_self, p.pur_bus_st, decode(p.dlv_brch,'법인판촉팀','특','특판팀','특') dlv_brch, '' t_user_dt1 \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, \n"+
					"        (select rent_mng_id, rent_l_cd, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(ext_pay_amt) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(ext_pay_amt) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g, \n"+
					"        (select * from commi where agnt_st='1' and emp_id is not null) h, \n"+					
					"        car_off_emp j, \n"+
					"        (select rent_mng_id, rent_l_cd from scd_fee where tm_st2='0' group by rent_mng_id, rent_l_cd) k,  \n"+
					"        (select * from doc_settle where doc_st='1') l, users o, \n"+
					"        car_pur p, cont_etc r,  \n"+					
					"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, COUNT(DECODE(SUBSTR(content_seq,20),'11',0)) scan_doc_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LC_SCAN' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h3, "+
					"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5') ) y "+
					" where  a.car_st<>'2' and a.car_gu='1' and a.bus_st in ('2','7')  \n"+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
					"        and a.client_id=c.client_id \n"+
					"        and a.car_mng_id=d.car_mng_id(+) \n"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
					"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+)  \n"+
					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+					
					"        and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+) \n"+
					"        and h.emp_id=j.emp_id \n"+
					"        and a.rent_l_cd=l.doc_id(+) and l.doc_no is null \n"+
					"        and a.bus_id=o.user_id \n"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd  \n"+
					"        and a.rent_mng_id=r.rent_mng_id and a.rent_l_cd=r.rent_l_cd  \n"+
					"        and a.rent_mng_id=h3.rent_mng_id(+) and a.rent_l_cd=h3.rent_l_cd(+)"+
					"        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) and y.rent_l_cd is null "+ //계약승계,차종변경은 안보여줌
					" ";

			query += " and h.emp_id is not null and h.emp_id <>'000000' and ((r.bus_agnt_id is null and a.bus_st='7') or h.comm_r_rt>0 or p.dir_pur_yn='Y' or (p.one_self='Y' and a.rent_dt > '20130630' ))  \n";/*원래조건*/
			query += " and a.use_yn='Y' and a.rent_dt >= '20071101' \n";
			
		//결재중
		}else if(gubun1.equals("1")){
			query = " select  \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id, \n"+
					"        a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, \n"+
					"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, \n"+
					"        h.commi, h.dlv_con_commi, h.dlv_tns_commi, h.agent_commi, nvl(h2.commi,0) as proxy_commi, h.emp_acc_nm, h.sup_dt, h.comm_r_rt, h.req_dt, \n"+
					"        h.emp_id, j.emp_nm, \n"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st, \n"+
					"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2, \n"+
					"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st, \n"+
					"        decode(k.rent_l_cd,'','미생성','생성') scd_yn, nvl(h3.pic_cnt2,0) scan_cnt, l.*, \n"+
					"        decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit, \n"+
					"        p.one_self, p.pur_bus_st, decode(p.dlv_brch,'법인판촉팀','특','특판팀','특') dlv_brch, to_char(l.user_dt1,'YYYYMMDD') as t_user_dt1 \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, \n"+
					"        (select rent_mng_id, rent_l_cd, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(ext_pay_amt) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(ext_pay_amt) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g, \n"+
					"        (select * from commi where agnt_st='1' and emp_id is not null) h, \n"+
					"        (select rent_mng_id, rent_l_cd, commi from commi where agnt_st='4' and emp_id is not null) h2, \n"+
					"        car_off_emp j, \n"+
					"        (select rent_mng_id, rent_l_cd from scd_fee where tm_st2='0' group by rent_mng_id, rent_l_cd) k,  \n"+
					"        (select * from doc_settle where doc_st='1') l, users o, \n"+
					"        car_pur p, cont_etc r,  \n"+
					"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, COUNT(DECODE(SUBSTR(content_seq,20),'11',0)) scan_doc_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LC_SCAN' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h3 "+					
					" where  a.car_st<>'2' and a.car_gu='1' and a.bus_st in ('2','7')  \n"+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
					"        and a.client_id=c.client_id \n"+
					"        and a.car_mng_id=d.car_mng_id \n"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
					"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+)  \n"+
					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+
					"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+) \n"+
					"        and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+) \n"+
					"        and h.emp_id=j.emp_id \n"+
					"        and a.rent_l_cd=l.doc_id and l.doc_step<>'3' and h.sup_dt is null \n"+
					"        and a.bus_id=o.user_id \n"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd  \n"+					
					"        and a.rent_mng_id=r.rent_mng_id and a.rent_l_cd=r.rent_l_cd  \n"+
					"        and a.rent_mng_id=h3.rent_mng_id(+) and a.rent_l_cd=h3.rent_l_cd(+)"+
					" ";

		//결재완료	
		}else if(gubun1.equals("2")){	
			query = " select  \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id, \n"+
					"        a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, \n"+
					//"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, \n"+
					"        h.commi, h.dlv_con_commi, h.dlv_tns_commi, h.agent_commi, nvl(h2.commi,0) as proxy_commi, h.emp_acc_nm, h.sup_dt, h.comm_r_rt, h.req_dt, \n"+
					"        h.emp_id, j.emp_nm, \n"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st, \n"+
					//"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2, \n"+
					//"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st, \n"+
					//"        decode(k.rent_l_cd,'','미생성','생성') scd_yn, nvl(h3.pic_cnt2,0) scan_cnt, "+
					"        l.*, \n"+
					"        decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit, \n"+
					"        p.one_self, p.pur_bus_st, decode(p.dlv_brch,'법인판촉팀','특','특판팀','특') dlv_brch, to_char(l.user_dt1,'YYYYMMDD') as t_user_dt1 \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, "+
//					"        gua_ins f, \n"+
//					"        (select rent_mng_id, rent_l_cd, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(ext_pay_amt) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(ext_pay_amt) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g, \n"+
					"        (select * from commi where agnt_st='1' and emp_id is not null) h, \n"+
					"        (select rent_mng_id, rent_l_cd, commi from commi where agnt_st='4' and emp_id is not null) h2, \n"+
					"        car_off_emp j, \n"+
//					"        (select rent_mng_id, rent_l_cd from scd_fee where tm_st2='0' group by rent_mng_id, rent_l_cd) k,  \n"+
					"        (select * from doc_settle where doc_st='1') l, users o, \n"+
					"        car_pur p, cont_etc r  \n"+					
//					"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, COUNT(DECODE(SUBSTR(content_seq,20),'11',0)) scan_doc_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LC_SCAN' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h3 "+					
					" where  a.car_st<>'2' and a.car_gu='1' and a.bus_st in ('2','7')  \n"+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
					"        and a.client_id=c.client_id \n"+
					"        and a.car_mng_id=d.car_mng_id \n"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
//					"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+)  \n"+
//					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+
					"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+) \n"+
//					"        and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+) \n"+
					"        and h.emp_id=j.emp_id \n"+
					"        and a.rent_l_cd=l.doc_id and l.doc_step='3' \n"+
					"        and a.bus_id=o.user_id \n"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd  \n"+					
					"        and a.rent_mng_id=r.rent_mng_id and a.rent_l_cd=r.rent_l_cd  \n"+
//					"        and a.rent_mng_id=h3.rent_mng_id(+) and a.rent_l_cd=h3.rent_l_cd(+)"+
					" ";

		}
		
/*		
		query = " select  \n"+
				"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id, \n"+
				"        a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, \n"+
				"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, \n"+
				"        h.commi, h.dlv_con_commi, h.dlv_tns_commi, h.agent_commi, nvl(h2.commi,0) as proxy_commi, h.inc_per, h.emp_acc_nm, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, i.user_nm as bus_nm, \n"+
				"        h.emp_id, j.emp_nm, j.file_name1, j.file_name2, j.file_gubun1, j.file_gubun2, \n"+
				"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st, \n"+
				"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2, \n"+
				"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st, \n"+
				"        decode(k.rent_l_cd,'','미생성','생성') scd_yn, nvl(h3.pic_cnt2,0) scan_cnt, l.*, \n"+
				"        decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit, \n"+
				"        decode(q.rent_l_cd,'','미등록',decode(q.sup_dt,'','미정산','정산')) tint_sup_yn, p.one_self, p.pur_bus_st, decode(p.dlv_brch,'법인판촉팀','특','특판팀','특') dlv_brch, \n"+
				"        r.bus_agnt_id  "+
				" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, \n"+
				"        (select rent_mng_id, rent_l_cd, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(ext_pay_amt) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(ext_pay_amt) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g, \n"+
				"        (select * from commi where agnt_st='1' and emp_id is not null) h, \n"+
				"        (select rent_mng_id, rent_l_cd, commi from commi where agnt_st='4' and emp_id is not null) h2, \n"+
				"        users i, car_off_emp j, \n"+
				"        (select rent_mng_id, rent_l_cd from scd_fee where tm_st2='0' group by rent_mng_id, rent_l_cd) k,  \n"+
				"        (select * from doc_settle where doc_st='1') l, users o, \n"+
				"        car_pur p, cont_etc r,  \n"+
				"        (select rent_mng_id, rent_l_cd, min(sup_dt) sup_dt from tint group by rent_mng_id, rent_l_cd) q, "+
				"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, COUNT(DECODE(SUBSTR(content_seq,20),'11',0)) scan_doc_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LC_SCAN' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h3, "+
				"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5') ) y "+
				" where  a.car_st<>'2' and a.car_gu='1' and a.bus_st in ('2','7')  \n"+
				"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
				"        and a.client_id=c.client_id \n"+
				"        and a.car_mng_id=d.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+)  \n"+
				"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
				"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+
				"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+) \n"+
				"        and h.emp_id=j.emp_id \n"+
				"        and a.rent_l_cd=l.doc_id(+) \n"+
				"        and a.bus_id=o.user_id \n"+
				"        and l.user_id1=i.user_id(+) \n"+
				"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd  \n"+
				"        and a.rent_mng_id=q.rent_mng_id(+) and a.rent_l_cd=q.rent_l_cd(+)  \n"+
				"        and a.rent_mng_id=r.rent_mng_id and a.rent_l_cd=r.rent_l_cd  \n"+
				"        and a.rent_mng_id=h3.rent_mng_id(+) and a.rent_l_cd=h3.rent_l_cd(+)"+
				"        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) and y.rent_l_cd is null "+ //계약승계,차종변경은 안보여줌
				" ";
*/
		
		String what = "";

		if(s_kd.equals("1"))	what = "upper(c.firm_nm)";
		if(s_kd.equals("2"))	what = "a.rent_l_cd";	
		if(s_kd.equals("3"))	what = "d.car_no";
		if(s_kd.equals("4"))	what = "o.user_nm";	
		if(s_kd.equals("5"))	what = "j.emp_nm";	
		if(s_kd.equals("6"))	what = "h.emp_acc_nm";	
		if(s_kd.equals("7"))	what = "to_char(l.user_dt1,'YYYYMMDD')";	
		if(s_kd.equals("9"))	what = "j.emp_id";	

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){
				query += " and "+what+" like upper('%"+t_wd+"%')  \n";
			}else if(s_kd.equals("8")){
				query += " and (to_char(l.user_dt7,'YYYYMMDD') like '%"+t_wd+"%' OR to_char(l.user_dt8,'YYYYMMDD') like '%"+t_wd+"%') \n";
			}else{
				if(!what.equals(""))	query += " and "+what+" like '%"+t_wd+"%'  \n";
			}
		}else{

		}	

//		query += " and a.rent_dt >= '20071101' \n";
			
//		if(gubun1.equals("1"))			query += " and h.sup_dt is null and (l.doc_step is null OR l.doc_step<>'3') \n";//미결
//		else if(gubun1.equals("2"))		query += " and l.doc_step='3' \n";//결재

//		query += " and (a.use_yn='Y' or a.rent_l_cd in ('S618HGHR00027')) and h.emp_id is not null and h.emp_id <>'000000' and ((r.bus_agnt_id is null and a.bus_st='7') or h.comm_r_rt>0 or p.dir_pur_yn='Y' or (p.one_self='Y' and a.rent_dt > '20130630' ))  \n";/*원래조건*/
		
//		query += " order by l.doc_bit, h.sup_dt desc, o.user_nm, a.rent_dt, b.rent_start_dt, a.rent_mng_id";

		if(gubun1.equals("0")){
			query += " order by d.init_reg_dt, b.rent_start_dt";
		}else if(gubun1.equals("1")){
			query += " order by l.doc_bit, b.rent_start_dt";
		}else if(gubun1.equals("2")){
			query += " order by l.user_dt1 desc, b.rent_start_dt";
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
			System.out.println("[DocSettleDatabase:getCommiDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getCommiDocList]\n"+query);
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

	//출고문서처리관리 리스트 조회
	public Vector getCarPurDocList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id,"+
				"        a.dlv_dt, a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt,"+
				"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, "+
				"        p.rpt_no, p.dlv_con_dt, p.dlv_est_dt, p.con_amt, "+
				"        h.commi, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, pc.nm as car_comp_nm, i.user_nm as bus_nm, h.emp_id, j.emp_nm, k.car_off_nm,"+
				"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
				"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2,"+
				"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st,"+
				"        nvl(n.scan_cnt,0) scan_cnt, l.*, "+
				"        decode(l.doc_step,'1','기안','2','결재','3','완료','대기') bit, r.car_nm, p.con_est_dt, g.pp_pay_dt,"+
				"        decode(p.one_self,'Y','자체출고') one_self, decode(a.rent_st,'3','대차') cont_rent_st_nm, n2.scan_15_cnt, p.pur_pay_dt, p.jan_amt as car_est_amt, "+
				"        TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.rent_dt,'YYYYMMDD'))) delay_mon, p.delay_cont, p.dir_pur_yn "+
				" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, car_pur p,"+
				"        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) pp_pay_dt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(decode(ext_pay_dt,'',0,ext_pay_amt)) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(decode(ext_pay_dt,'',0,ext_pay_amt)) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g,"+
				"        (select  * from commi where agnt_st='2' and emp_id is not null) h,"+
				"        users i, car_off_emp j, car_off k, (select * from code where c_st='0001' and code<>'0000') pc,"+
				"        (select  * from doc_settle where doc_st='4') l, users o,"+
				"        (select rent_mng_id, rent_l_cd, count(*) scan_cnt from lc_scan group by rent_mng_id, rent_l_cd) n, "+
				"        (select rent_mng_id, rent_l_cd, count(*) scan_15_cnt from lc_scan where file_st='15' group by rent_mng_id, rent_l_cd) n2, "+
				"        car_nm q, car_mng r,"+
				"        (select * from cls_cont where cls_st in ('4','5')) s"+
				" where  nvl(a.use_yn,'Y')='Y' and a.car_st<>'2' and nvl(a.car_gu,a.reg_id)='1' "+
				"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
				"        and a.client_id=c.client_id"+
				"        and a.car_mng_id=d.car_mng_id(+)"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+) "+
				"        and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+)"+
				"        and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+)"+
				"        and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				"        and a.rent_mng_id=n2.rent_mng_id(+) and a.rent_l_cd=n2.rent_l_cd(+)"+
				"        and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+)"+
				"        and h.emp_id=j.emp_id(+)"+
				"        and j.car_off_id=k.car_off_id(+)"+
				"        and k.car_comp_id=pc.code(+)"+
				"        and a.rent_l_cd=l.doc_id(+)"+
				"        and a.bus_id=o.user_id(+)"+
				"        and l.user_id1=i.user_id(+)"+
				"        and e.car_id=q.car_id and e.car_seq=q.car_seq and q.car_comp_id=r.car_comp_id and q.car_cd=r.code"+
				"        and a.rent_mng_id=s.rent_mng_id(+) and a.reg_dt=s.reg_dt(+) and s.rent_l_cd is null"+
				"        and nvl(a.dlv_dt,'99999999') >= '20080707' "+
				"        and a.rent_l_cd not in ('B108HTLR00156','B108HTLR00157','B108HRTR00216','B108SS7L00019') "+
				"        and decode(q.car_comp_id,'0001','0001',h.emp_id) is not null "+
				" ";

		if(gubun1.equals("1"))			query += " and nvl(l.doc_step,'0')<>'3'";//미결
		else if(gubun1.equals("2"))		query += " and l.doc_step='3'";//결재

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(c.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(d.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(o.user_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(j.emp_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(a.rent_dt, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(r.car_nm, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(o.user_nm, ' '))";	
		if(s_kd.equals("9"))	what = "upper(nvl(replace(to_char(l.user_dt1,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("10"))	what = "upper(nvl(replace(to_char(l.user_dt5,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("11"))	what = "upper(nvl(p.dlv_brch, ' '))";	
		if(s_kd.equals("12"))	what = "upper(nvl(p.rpt_no, ' '))";	
		if(s_kd.equals("13"))	what = "upper(nvl( pc.nm, ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by p.con_est_dt, l.doc_step desc,  a.rent_dt, b.rent_start_dt, a.rent_mng_id";

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
			System.out.println("[DocSettleDatabase:getCarPurDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurDocList]\n"+query);
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

	//출고문서처리관리 리스트 조회
	public Vector getCarPurDocList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		//미등록
		if(gubun1.equals("0")) {
			query = " select  "+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id,"+
					"        a.dlv_dt, a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, b.con_mon, "+
					"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, "+
					"        p.rpt_no, p.dlv_con_dt, p.dlv_est_dt, p.con_amt, "+
					//"        p.pur_pay_dt, "+
					"        h.commi, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, pc.nm as car_comp_nm, i.user_nm as bus_nm, h.emp_id, j.emp_nm, k.car_off_nm,"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
					"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2,"+
					"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st,"+
					"        nvl(h2.pic_cnt2,0) scan_cnt, nvl(h2.scan_doc_cnt,0) scan_doc_cnt, nvl(h2.scan_doc_cnt2,0) scan_15_cnt, l.*, "+
					"        r.car_nm, g.pp_pay_dt, '대기' bit, "+
					//"        decode(l.doc_step,'1','기안','2','결재','3','완료','대기') bit, p.con_est_dt, "+
					"        decode(p.one_self,'Y','자체출고') one_self, decode(a.rent_st,'3','대차') cont_rent_st_nm, "+
					//"        p.pur_pay_dt, p.jan_amt as car_est_amt, "+
					"        TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.rent_dt,'YYYYMMDD'))) delay_mon, p.delay_cont, p.dir_pur_yn, p.off_nm, p.cons_st, p.dlv_ext, p.trf_amt5, p.cardno5, p.trf_pay_dt5, "+
					//"        n.app_dt, n.card_yn, n.gov_id, n.amt4, "+
					"        decode(p.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점','') udt_st , a.car_st \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, car_pur p,"+
					"        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) pp_pay_dt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(decode(ext_pay_dt,'',0,ext_pay_amt)) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(decode(ext_pay_dt,'',0,ext_pay_amt)) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g,"+
					"        (select rent_mng_id, rent_l_cd, emp_id, commi, sup_dt, comm_r_rt, req_dt from commi where agnt_st='2' and emp_id is not null) h,"+
					"        users i, car_off_emp j, car_off k, (select code, nm from code where c_st='0001' and code<>'0000') pc,"+
					"        (select * from doc_settle where doc_st='4') l, users o,"+
					"        car_nm q, car_mng r,"+
					"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5')) s, "+
					"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, "+
					"                COUNT(DECODE(SUBSTR(content_seq,20),'11',0,'117',0,'118',0)) scan_doc_cnt, "+
					"			     COUNT(DECODE(SUBSTR(content_seq,20),'115',0)) scan_doc_cnt2 "+
					"	      from ACAR_ATTACH_FILE where content_code='LC_SCAN' AND isdeleted='N' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h2 "+
					//"        (select b.gov_id, b.card_yn, b.app_dt, a.rent_mng_id, a.rent_l_cd, a.amt4 from fine_doc_list a, fine_doc b WHERE a.doc_id LIKE '총무%' and a.doc_id=b.doc_id ) n "+ 
					" where  a.car_st<>'2' and a.car_gu='1' and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null "+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
					"        and a.client_id=c.client_id"+
					"        and a.car_mng_id=d.car_mng_id(+)"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
					"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+) "+
					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd"+
					"        and h.emp_id=j.emp_id"+
					"        and j.car_off_id=k.car_off_id"+
					"        and k.car_comp_id=pc.code"+
					"        and a.rent_l_cd=l.doc_id(+) and l.doc_no is null "+
					"        and a.bus_id=o.user_id"+
					"        and l.user_id1=i.user_id(+)"+
					"        and e.car_id=q.car_id and e.car_seq=q.car_seq and q.car_comp_id=r.car_comp_id and q.car_cd=r.code"+
					"        and a.rent_mng_id=s.rent_mng_id(+) and a.reg_dt=s.reg_dt(+) and s.rent_l_cd is null"+
					"        and h.emp_id is not null "+
					"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+)"+
					//"        and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
					" ";
		//결재중	
		}else if(gubun1.equals("1")) {
			query = " select  "+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id,"+
					"        a.dlv_dt, a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, b.con_mon, "+
					"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, "+
					"        p.rpt_no, p.dlv_con_dt, p.dlv_est_dt, p.con_amt, p.pur_pay_dt, "+
					"        h.commi, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, pc.nm as car_comp_nm, i.user_nm as bus_nm, h.emp_id, j.emp_nm, k.car_off_nm,"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
					"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2,"+
					"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st,"+
					"        nvl(h2.pic_cnt2,0) scan_cnt, nvl(h2.scan_doc_cnt,0) scan_doc_cnt, nvl(h2.scan_doc_cnt2,0) scan_15_cnt, l.*, to_char(l.user_dt1,'YYYYMMDD') s_user_dt1, "+
					"        decode(l.doc_step,'1','기안','2','결재','3','완료','대기') bit, r.car_nm, p.con_est_dt, g.pp_pay_dt,"+
					"        decode(p.one_self,'Y','자체출고') one_self, decode(a.rent_st,'3','대차') cont_rent_st_nm, "+
					"        p.pur_pay_dt, p.jan_amt as car_est_amt, "+
					"        TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.rent_dt,'YYYYMMDD'))) delay_mon, p.delay_cont, p.dir_pur_yn, p.off_nm, p.cons_st, p.dlv_ext, p.trf_amt5, p.cardno5, p.trf_pay_dt5, "+
					"        n.app_dt, n.card_yn, n.gov_id, n.amt4, "+
					"        decode(p.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점','') udt_st , a.car_st \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, car_pur p,"+
					"        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) pp_pay_dt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(decode(ext_pay_dt,'',0,ext_pay_amt)) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(decode(ext_pay_dt,'',0,ext_pay_amt)) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g,"+
					"        (select rent_mng_id, rent_l_cd, emp_id, commi, sup_dt, comm_r_rt, req_dt from commi where agnt_st='2' and emp_id is not null) h,"+
					"        users i, car_off_emp j, car_off k, (select code, nm from code where c_st='0001' and code<>'0000') pc,"+
					"        (select * from doc_settle where doc_st='4') l, users o,"+
					"        car_nm q, car_mng r,"+
					"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5') and rent_l_cd not in ('D114HHGR00233')) s, "+
					"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, "+
					"                COUNT(DECODE(SUBSTR(content_seq,20),'11',0,'117',0,'118',0)) scan_doc_cnt, "+
					"			     COUNT(DECODE(SUBSTR(content_seq,20),'115',0)) scan_doc_cnt2 "+
					"	      from ACAR_ATTACH_FILE where content_code='LC_SCAN' AND isdeleted='N' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h2, "+
					"        (select b.gov_id, b.card_yn, b.app_dt, a.rent_mng_id, a.rent_l_cd, a.amt4 from fine_doc_list a, fine_doc b WHERE a.doc_id LIKE '총무%' and a.doc_id=b.doc_id ) n "+ 
					" where  a.car_st<>'2' and a.car_gu='1' and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is null "+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
					"        and a.client_id=c.client_id"+
					"        and a.car_mng_id=d.car_mng_id(+)"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
					"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+) "+
					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd"+
					"        and h.emp_id=j.emp_id"+
					"        and j.car_off_id=k.car_off_id"+
					"        and k.car_comp_id=pc.code"+
					"        and a.rent_l_cd=l.doc_id and l.doc_step<>'3' "+
					"        and a.bus_id=o.user_id"+
					"        and l.user_id1=i.user_id"+
					"        and e.car_id=q.car_id and e.car_seq=q.car_seq and q.car_comp_id=r.car_comp_id and q.car_cd=r.code"+
					"        and a.rent_mng_id=s.rent_mng_id(+) and a.reg_dt=s.reg_dt(+) and s.rent_l_cd is null"+
					"        and h.emp_id is not null "+					
					"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+)"+
					"        and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
					" ";
		//결재완료	
		}else {
			query = " select  "+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id,"+
					"        a.dlv_dt, a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, b.con_mon, "+
					//"        f.gi_st, f.gi_dt, "+
					//"        g.pp_amt, g.pay_amt, g.jan_amt, g.pp_pay_dt, "+
					"        p.rpt_no, p.dlv_con_dt, p.dlv_est_dt, p.con_amt, p.pur_pay_dt, "+
					"        h.commi, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, pc.nm as car_comp_nm, i.user_nm as bus_nm, h.emp_id, j.emp_nm, k.car_off_nm,"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
					//"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2,"+
					//"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st,"+
					//"        nvl(h2.pic_cnt2,0) scan_cnt, nvl(h2.scan_doc_cnt,0) scan_doc_cnt, nvl(h2.scan_doc_cnt2,0) scan_15_cnt, "+
					"        l.*, to_char(l.user_dt1,'YYYYMMDD') s_user_dt1, "+
					"        decode(l.doc_step,'1','기안','2','결재','3','완료','대기') bit, r.car_nm, p.con_est_dt, "+
					"        decode(p.one_self,'Y','자체출고') one_self, decode(a.rent_st,'3','대차') cont_rent_st_nm, "+
					"        p.pur_pay_dt, p.jan_amt as car_est_amt, "+
					//"        TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.rent_dt,'YYYYMMDD'))) delay_mon, p.delay_cont, "+
					"        p.dir_pur_yn, p.off_nm, p.cons_st, p.dlv_ext, p.trf_amt5, p.cardno5, p.trf_pay_dt5, "+
					"        n.app_dt, n.card_yn, n.gov_id, n.amt4, "+
					"        decode(p.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점','') udt_st , a.car_st \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, car_pur p,"+//gua_ins f, 
					//"        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) pp_pay_dt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(decode(ext_pay_dt,'',0,ext_pay_amt)) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(decode(ext_pay_dt,'',0,ext_pay_amt)) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g,"+
					"        (select rent_mng_id, rent_l_cd, emp_id, commi, sup_dt, comm_r_rt, req_dt from commi where agnt_st='2' and emp_id is not null) h,"+
					"        users i, car_off_emp j, car_off k, (select code, nm from code where c_st='0001' and code<>'0000') pc,"+
					"        (select * from doc_settle where doc_st='4') l, users o,"+
					"        car_nm q, car_mng r,"+
					"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5') and rent_l_cd not in ('D114HHGR00233')) s, "+
					//"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, "+
					//"                COUNT(DECODE(SUBSTR(content_seq,20),'11',0,'117',0,'118',0)) scan_doc_cnt, "+
					//"			     COUNT(DECODE(SUBSTR(content_seq,20),'115',0)) scan_doc_cnt2 "+
					//"	      from ACAR_ATTACH_FILE where content_code='LC_SCAN' AND isdeleted='N' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h2, "+
					"        (select b.gov_id, b.card_yn, b.app_dt, a.rent_mng_id, a.rent_l_cd, a.amt4 from fine_doc_list a, fine_doc b WHERE a.doc_id LIKE '총무%' and a.doc_id=b.doc_id ) n "+ 
					" where  a.car_st<>'2' and a.car_gu='1' "+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
					"        and a.client_id=c.client_id"+
					"        and a.car_mng_id=d.car_mng_id(+)"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
					//"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+) "+
					//"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd"+
					"        and h.emp_id=j.emp_id"+
					"        and j.car_off_id=k.car_off_id"+
					"        and k.car_comp_id=pc.code"+
					"        and a.rent_l_cd=l.doc_id"+
					"        and a.bus_id=o.user_id"+
					"        and l.user_id1=i.user_id"+
					"        and e.car_id=q.car_id and e.car_seq=q.car_seq and q.car_comp_id=r.car_comp_id and q.car_cd=r.code"+
					"        and a.rent_mng_id=s.rent_mng_id(+) and a.reg_dt=s.reg_dt(+) and s.rent_l_cd is null"+
					"        and l.doc_step='3' "+
					//"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+)"+
					"        and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
					" ";
			
			String what = "";
			String dt1 = "";
			String dt2 = "";

			dt1 = "to_char(l.user_dt5,'YYYYMM')";
			dt2 = "to_char(l.user_dt5,'YYYYMMDD')";

			if(gubun4.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
			else if(gubun4.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			else if(gubun4.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
			else if(gubun4.equals("5"))		query += " and "+dt1+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
			else if(gubun4.equals("2")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}
			
		}
/*
		query = " select  "+
				"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id,"+
				"        a.dlv_dt, a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, b.con_mon, "+
				"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, "+
				"        p.rpt_no, p.dlv_con_dt, p.dlv_est_dt, p.con_amt, p.pur_pay_dt, "+
				"        h.commi, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, pc.nm as car_comp_nm, i.user_nm as bus_nm, h.emp_id, j.emp_nm, k.car_off_nm,"+
				"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
				"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2,"+
				"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st,"+
				"        nvl(h2.pic_cnt2,0) scan_cnt, nvl(h2.scan_doc_cnt,0) scan_doc_cnt, nvl(h2.scan_doc_cnt2,0) scan_15_cnt, l.*, "+
				"        decode(l.doc_step,'1','기안','2','결재','3','완료','대기') bit, r.car_nm, p.con_est_dt, g.pp_pay_dt,"+
				"        decode(p.one_self,'Y','자체출고') one_self, decode(a.rent_st,'3','대차') cont_rent_st_nm, "+
				"        p.pur_pay_dt, p.jan_amt as car_est_amt, "+
				"        TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.rent_dt,'YYYYMMDD'))) delay_mon, p.delay_cont, p.dir_pur_yn, p.off_nm, p.cons_st, p.dlv_ext, p.trf_amt5, p.cardno5, p.trf_pay_dt5, "+
				"        n.app_dt, n.card_yn, n.gov_id, n.amt4, "+
				"        decode(p.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점','') udt_st , a.car_st \n"+
				" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, car_pur p,"+
				"        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) pp_pay_dt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(decode(ext_pay_dt,'',0,ext_pay_amt)) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(decode(ext_pay_dt,'',0,ext_pay_amt)) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g,"+
				"        (select rent_mng_id, rent_l_cd, emp_id, commi, sup_dt, comm_r_rt, req_dt from commi where agnt_st='2' and emp_id is not null) h,"+
				"        users i, car_off_emp j, car_off k, (select code, nm from code where c_st='0001' and code<>'0000') pc,"+
				"        (select * from doc_settle where doc_st='4') l, users o,"+
				"        car_nm q, car_mng r,"+
				"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5') and rent_l_cd not in ('D114HHGR00233')) s, "+
				"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, "+
				"                COUNT(DECODE(SUBSTR(content_seq,20),'11',0,'117',0,'118',0)) scan_doc_cnt, "+
				"			     COUNT(DECODE(SUBSTR(content_seq,20),'115',0)) scan_doc_cnt2 "+
				"	      from ACAR_ATTACH_FILE where content_code='LC_SCAN' AND isdeleted='N' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h2, "+
				"        (select b.gov_id, b.card_yn, b.app_dt, a.rent_mng_id, a.rent_l_cd, a.amt4 from fine_doc_list a, fine_doc b WHERE a.doc_id LIKE '총무%' and a.doc_id=b.doc_id ) n "+ 
				" where  a.car_st<>'2' and a.car_gu='1' "+
				"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
				"        and a.client_id=c.client_id"+
				"        and a.car_mng_id=d.car_mng_id(+)"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+) "+
				"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd"+
				"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd"+
				"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd"+
				"        and h.emp_id=j.emp_id"+
				"        and j.car_off_id=k.car_off_id"+
				"        and k.car_comp_id=pc.code"+
				"        and a.rent_l_cd=l.doc_id(+)"+
				"        and a.bus_id=o.user_id"+
				"        and l.user_id1=i.user_id(+)"+
				"        and e.car_id=q.car_id and e.car_seq=q.car_seq and q.car_comp_id=r.car_comp_id and q.car_cd=r.code"+
				"        and a.rent_mng_id=s.rent_mng_id(+) and a.reg_dt=s.reg_dt(+) and s.rent_l_cd is null"+
				"        and (a.dlv_dt >= '20080707' or a.dlv_dt is null ) "+
				"        and a.rent_l_cd not in ('B108HTLR00156','B108HTLR00157','B108HRTR00216','B108SS7L00019','S113KK5R00671') "+
				"        and (q.car_comp_id='0001' or h.emp_id is not null ) "+
				"        and decode(l.doc_step,'3','Y',nvl(a.use_yn,'Y'))='Y' "+
				"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+)"+
				"        and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+)"+
				" ";
*/

		if(gubun2.equals("1"))			query += " and q.car_comp_id = '0001' ";//현대자동차
		if(gubun2.equals("2"))			query += " and q.car_comp_id = '0002' ";//기아자동차
		if(gubun2.equals("3"))			query += " and q.car_comp_id > '0002' ";//기타자동차
		
		//if(gubun1.equals("1"))			query += " and (l.doc_step is null or l.doc_step<>'3')";//미결
		//else if(gubun1.equals("2"))		query += " and l.doc_step='3'";//결재

		String what = "";

		if(s_kd.equals("1"))	what = "upper(c.firm_nm)";
		if(s_kd.equals("2"))	what = "a.rent_l_cd";	
		if(s_kd.equals("3"))	what = "d.car_no";
		if(s_kd.equals("4"))	what = "o.user_nm";	
		if(s_kd.equals("5"))	what = "j.emp_nm";	
		if(s_kd.equals("6"))	what = "a.rent_dt";	
		if(s_kd.equals("7"))	what = "r.car_nm";	
		if(s_kd.equals("8"))	what = "o.user_nm";	
		if(s_kd.equals("9"))	what = "to_char(l.user_dt1,'YYYYMMDD')";	
		if(s_kd.equals("10"))	what = "to_char(l.user_dt5,'YYYYMMDD')";	
		if(s_kd.equals("11"))	what = "p.dlv_brch";	
		if(s_kd.equals("12"))	what = "upper(p.rpt_no)";	
		if(s_kd.equals("13"))	what = "pc.nm";	
		if(s_kd.equals("14"))	what = "p.pur_pay_dt";
		if(s_kd.equals("15"))	what = "p.con_est_dt";
		
		

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("4") && t_wd.equals("에이전트")) {
				query += " and o.dept_id='1000' ";
			}else {
				if(s_kd.equals("1") || s_kd.equals("12"))			query += " and "+what+" like upper('%"+t_wd+"%') ";
				else 												query += " and "+what+" like '%"+t_wd+"%' ";				
			}
		}else{

		}	
		
		query += " order by p.con_est_dt, l.doc_step desc,  a.rent_dt, b.rent_start_dt, a.rent_mng_id";

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
			System.out.println("[DocSettleDatabase:getCarPurDocList(String s_kd, String t_wd, String gubun1, String gubun2)]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurDocList(String s_kd, String t_wd, String gubun1, String gubun2)]\n"+query);
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

	
	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurPayDocList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        a.rent_mng_id, a.rent_l_cd, d.client_id, \n"+
				"        d.firm_nm, g.car_nm, b.dlv_dt, substr(a.dlv_est_dt,1,8) dlv_est_dt, a.con_est_dt, a.con_pay_dt, a.pur_est_dt, a.pur_pay_dt, a.rpt_no, \n"+
				"        decode(b.car_gu,'2',a.dlv_brch||'외',h1.car_off_nm) as dlv_brch, a.con_amt, a.jan_amt,\n"+
				"        decode(e.purc_gu,'0','면세','과세') purc_gu,\n"+
				"        (e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt-nvl(e.tax_dc_s_amt,0)-nvl(e.tax_dc_v_amt,0)) car_c_amt,\n"+
				"        (e.dc_cs_amt+e.dc_cv_amt) car_dc_amt,\n"+
				"        (e.sd_cs_amt+e.sd_cv_amt) car_sd_amt,\n"+
				"        (e.car_fs_amt+e.car_fv_amt+e.sd_cs_amt+e.sd_cv_amt-e.dc_cs_amt-e.dc_cv_amt) car_f_amt,\n"+
				"        decode(a.trf_st1,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st1, card_kind1, trf_amt1, trf_pay_dt1,\n"+
				"        decode(a.trf_st2,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st2, card_kind2, trf_amt2, trf_pay_dt2,\n"+
				"        decode(a.trf_st3,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st3, card_kind3, trf_amt3, trf_pay_dt3,\n"+
				"        decode(a.trf_st4,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st4, card_kind4, trf_amt4, trf_pay_dt4,\n"+
				"        decode(a.trf_st5,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st5, card_kind5, trf_amt5, trf_pay_dt5,\n"+
				"        (nvl(trf_amt1,0)+nvl(trf_amt2,0)+nvl(trf_amt3,0)+nvl(trf_amt4,0)) trf_amt,\n"+
				"        substr(h.doc_no,11,2) m_doc_no, h.doc_no, h.doc_step, h.user_id1, h.user_id2, h.user_dt1, h.user_dt2, \n"+
				"        decode(h.doc_step,'','대기','1','기안','2','결재중','3','결재완료') bit, i.user_nm,\n"+
				"        j.req_cnt, j.min_m_id, l.br_id, \n"+
				"        decode(a.acq_cng_yn,'Y','있음','N','없음') acq_cng_yn, a.cpt_cd, f.car_comp_id, \n"+
				"        k.grt_amt_s, (k.pp_s_amt+k.pp_v_amt+k.ifee_s_amt+k.ifee_v_amt) pp_ifee_amt, k.con_mon, \n"+
				"        decode(b.car_gu,'2','중고차','') car_gu, a.est_car_no \n"+
				" from   car_pur a, cont b, (select * from doc_settle where doc_st='4' and doc_step='3') c, client d, car_etc e, car_nm f, car_mng g, cls_cont t,\n"+
				"        (select * from doc_settle where doc_st='5') h, users i, users l, fee k, \n"+
				"        (select req_code, min(rent_mng_id) min_m_id, count(*) req_cnt from car_pur where req_code is not null group by req_code) j,\n"+
				"        (select a.rent_mng_id, a.rent_l_cd, b.*, c.car_off_nm, c.car_off_tel, c.bank, c.acc_no, c.acc_nm from commi a, car_off_emp b, car_off c where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id) h1 \n"+
				" where \n"+
				" a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" and a.rent_l_cd=c.doc_id \n"+
				" and b.client_id=d.client_id \n"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code \n"+
				" and a.req_code=h.doc_id(+) and b.bus_id=i.user_id(+) and a.req_code=j.req_code(+) and c.user_id1=l.user_id(+) \n"+
				" and a.rent_mng_id=h1.rent_mng_id(+) and a.rent_l_cd=h1.rent_l_cd(+) \n"+
				" and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) \n"+
				" and a.rent_mng_id=k.rent_mng_id and a.rent_l_cd=k.rent_l_cd and k.rent_st='1' \n"+
				" ";
			
		if(gubun1.equals("1"))			query += " and nvl(h.doc_step,'0')<>'3' and nvl(t.cls_st,'0')<>'7' ";//미결
		else if(gubun1.equals("2"))		query += " and h.doc_step='3'";//결재

		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("Y")){
			query += " and a.pur_pay_dt is not null";//지급
			dt1 = "substr(a.pur_pay_dt,1,6)";
			dt2 = "a.pur_pay_dt";
		}else if(gubun3.equals("N")){
			query += " and a.pur_pay_dt is null";//미지급
			dt1 = "substr(a.pur_est_dt,1,6)";
			dt2 = "a.pur_est_dt";
		}else if(gubun3.equals("D")){
			query += " and a.autodocu_data_no is null and a.pur_pay_dt >= '20110101'";//자동전표미발행분
			dt1 = "substr(a.pur_pay_dt,1,6)";
			dt2 = "a.pur_pay_dt";
		}else{
			dt1 = "substr(a.pur_est_dt,1,6)";
			dt2 = "a.pur_est_dt";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))	what = "upper(d.firm_nm)";
		if(s_kd.equals("2"))	what = "upper(a.rent_l_cd)";	
		if(s_kd.equals("4"))	what = "i.user_nm";	
		if(s_kd.equals("5"))	what = "decode(b.car_gu,'2',a.dlv_brch||'외',h1.car_off_nm)";	
		if(s_kd.equals("6"))	what = "g.car_nm";	
		if(s_kd.equals("7"))	what = "upper(a.rpt_no)";	

		if(s_kd.equals("99"))	what = "h.doc_no";	
			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1") || s_kd.equals("2") || s_kd.equals("7")) 			query += " and "+what+" like upper('%"+t_wd+"%') ";
			else																	query += " and "+what+" like '%"+t_wd+"%' ";
		}else{

		}	
		
		if(gubun3.equals("N")){//미지급
			query += " order by nvl(h.doc_step,'0') desc, nvl(h.doc_no,'0'), card_kind1, card_kind2, a.dlv_est_dt, a.pur_est_dt, c.user_dt4, d.firm_nm, g.car_nm";
		}else{//전체,지급
			query += " order by nvl(h.doc_step,'0') desc, a.pur_est_dt, a.dlv_est_dt, a.pur_est_dt, c.user_dt4, d.firm_nm, g.car_nm";				
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
			System.out.println("[DocSettleDatabase:getCarPurPayDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayDocList]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurPayDocAutoDocuList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  "+
				"		a.rent_mng_id, a.rent_l_cd, d.client_id,"+
				"		d.firm_nm, k.car_no, g.car_nm, nvl(b.dlv_dt,'미등록') dlv_dt, substr(a.dlv_est_dt,1,8) dlv_est_dt, a.con_est_dt, a.pur_est_dt, a.pur_pay_dt, a.dlv_ext, p.car_off_nm as dlv_brch, a.con_amt, a.jan_amt,"+
				"		 decode(e.purc_gu,'0','면세','과세') purc_gu,"+
				"		(e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt-nvl(e.tax_dc_s_amt,0)-nvl(e.tax_dc_v_amt,0)) car_c_amt,"+
				"		(e.dc_cs_amt+e.dc_cv_amt) car_dc_amt,"+
				"		(e.car_fs_amt+e.car_fv_amt+e.sd_cs_amt+e.sd_cv_amt-e.dc_cs_amt-e.dc_cv_amt) car_f_amt,"+
				"		decode(a.trf_st1,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st1, card_kind1, trf_amt1, trf_pay_dt1,"+
				"		decode(a.trf_st2,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st2, card_kind2, trf_amt2, trf_pay_dt2,"+
				"		decode(a.trf_st3,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st3, card_kind3, trf_amt3, trf_pay_dt3,"+
				"		decode(a.trf_st4,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st4, card_kind4, trf_amt4, trf_pay_dt4,"+
				"		(trf_amt1+trf_amt2+trf_amt3+trf_amt4) trf_amt,"+
				"		h.doc_no, h.doc_step, h.user_id1, h.user_id2, h.user_dt1, h.user_dt2, decode(h.doc_step,'','대기','1','기안','2','결재중','3','결재완료') bit, i.user_nm,"+
				"		j.req_cnt, j.min_m_id, l.br_id, k.init_reg_dt, e.car_amt_dt, n.file_name, n.file_path, n.file_type, a.rpt_no, f.car_comp_id, nvl(o.com_code,q.com_code) com_code, p.car_off_id, p.car_off_nm, p.ven_code,"+
				"		a.dlv_ext_ven_code, a.car_off_ven_code, a.card_com_ven_code,"+
			    "       c1.com_code as com_code1, c2.com_code as com_code2, c3.com_code as com_code3, c4.com_code as com_code4, nvl(e.car_tax_dt,b.dlv_dt) car_tax_dt "+
				" from car_pur a, cont b, (select * from doc_settle where doc_st='4' and doc_step='3') c, client d, car_etc e, car_nm f, car_mng g, car_reg k, cls_cont t,"+
				" (select * from doc_settle where doc_st='5') h, users i, users l,"+
				" (select req_code, min(rent_mng_id) min_m_id, count(*) req_cnt from car_pur where req_code is not null group by req_code) j,"+
				" (select * from lc_scan where file_st='10') n, card o, card q,"+
				" (select a.rent_mng_id, a.rent_l_cd, c.car_off_id, c.car_off_nm, c.ven_code from commi a, car_off_emp b, car_off c where a.agnt_st='2' and a.emp_id is not null and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id) p,"+
				" card c1, card c2, card c3, card c4"+
				" where a.autodocu_write_date is null "+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.rent_l_cd=c.doc_id"+
				" and b.client_id=d.client_id"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				" and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code"+
				" and a.req_code=h.doc_id and b.bus_id=i.user_id(+) and a.req_code=j.req_code(+) and c.user_id1=l.user_id(+) "+
				" and b.car_mng_id=k.car_mng_id(+)"+
				" and a.rent_mng_id=t.rent_mng_id(+) and a.rent_l_cd=t.rent_l_cd(+) and nvl(t.cls_st,'0')<>'7' "+
				" and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+) and a.cardno1=o.cardno(+) and a.cardno2=q.cardno(+)"+
				" and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd"+
				" and a.cardno1=c1.cardno(+)"+
				" and a.cardno2=c2.cardno(+)"+
				" and a.cardno3=c3.cardno(+)"+
				" and a.cardno4=c4.cardno(+)"+
				" and a.rent_l_cd not in ('S213KK5R00638')"+
				" ";
			
		if(gubun1.equals("1"))			query += " and nvl(h.doc_step,'0')<>'3'";//미결
		else if(gubun1.equals("2"))		query += " and h.doc_step='3'";//결재

		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("Y")){
			query += " and a.pur_pay_dt is not null and a.pur_pay_dt > '20101231'";//지급
			dt1 = "substr(a.pur_pay_dt,1,6)";
			dt2 = "a.pur_pay_dt";
		}else if(gubun3.equals("N")){
			query += " and a.pur_pay_dt is null";//미지급
			dt1 = "substr(a.pur_est_dt,1,6)";
			dt2 = "a.pur_est_dt";
		}else if(gubun3.equals("D")){
			query += " and a.autodocu_data_no is null and a.pur_pay_dt > '20101231'";//자동전표 미발행분
			dt1 = "substr(a.pur_pay_dt,1,6)";
			dt2 = "a.pur_pay_dt";
		}else{
			if(gubun1.equals("1")){
				dt1 = "to_char(nvl(h.user_dt1,c.user_dt5),'YYYYMM')";
				dt2 = "to_char(nvl(h.user_dt1,c.user_dt5),'YYYYMMDD')";		
			}else if(gubun1.equals("2")){
				dt1 = "to_char(h.user_dt2,'YYYYMM')";
				dt2 = "to_char(h.user_dt2,'YYYYMMDD')";
			}else{
				dt1 = "to_char(c.user_dt5,'YYYYMM')";
				dt2 = "to_char(c.user_dt5,'YYYYMMDD')";
			}
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(i.user_nm, ' '))";	

		if(s_kd.equals("99"))	what = "upper(nvl(h.doc_no, ' '))";	
			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by nvl(h.doc_step,'0') desc, k.init_reg_dt, k.car_use, k.car_no, a.dlv_est_dt, a.pur_est_dt, c.user_dt4, a.dlv_est_dt, d.firm_nm, g.car_nm";

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
			System.out.println("[DocSettleDatabase:getCarPurPayDocAutoDocuList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayDocAutoDocuList]\n"+query);
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

	

	//차량대금 지출문서관리 리스트 조회
	public Hashtable getCarPurPayDocCase(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select  "+
				"        a.rent_mng_id, a.rent_l_cd, d.client_id,"+
				"        d.firm_nm, g.car_nm, b.dlv_dt, a.dlv_est_dt, a.con_est_dt, a.pur_est_dt, a.dlv_brch, a.con_amt, a.jan_amt,"+
				"        decode(e.purc_gu,'0','면세','과세') purc_gu,"+
				"        (e.car_cs_amt+e.car_cv_amt+e.opt_cs_amt+e.opt_cv_amt+e.clr_cs_amt+e.clr_cv_amt-nvl(e.tax_dc_s_amt,0)-nvl(e.tax_dc_v_amt,0)) car_c_amt,"+
				"        (e.dc_cs_amt+e.dc_cv_amt) car_dc_amt,"+
				"        (e.car_fs_amt+e.car_fv_amt+e.sd_cs_amt+e.sd_cv_amt-e.dc_cs_amt-e.dc_cv_amt) car_f_amt,"+
				"        decode(a.trf_st1,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st1, card_kind1, trf_amt1,"+
				"        decode(a.trf_st2,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st2, card_kind2, trf_amt2,"+
				"        decode(a.trf_st3,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st3, card_kind3, trf_amt3,"+
				"        decode(a.trf_st4,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st4, card_kind4, trf_amt4,"+
				"        decode(a.trf_st5,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','7','카드할부') trf_st5, card_kind5, trf_amt5,"+
				"        (trf_amt1+trf_amt2+trf_amt3+trf_amt4) trf_amt,"+
				"        h.doc_no, h.user_id1, h.user_id2, h.user_dt1, h.user_dt2, decode(h.doc_step,'','대기','1','기안','2','결재중','3','결재완료') bit, i.user_nm, "+
				"        k.grt_amt_s, (k.pp_s_amt+k.pp_v_amt+k.ifee_s_amt+k.ifee_v_amt) pp_ifee_amt "+
				" from   car_pur a, cont b, (select * from doc_settle where doc_st='4' and doc_step='3') c, client d, car_etc e, car_nm f, car_mng g,"+
				"        (select * from doc_settle where doc_st='5') h, users i, fee k "+
				" where  a.rent_l_cd=?"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and a.rent_l_cd=c.doc_id"+
				"        and b.client_id=d.client_id"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				"        and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code"+
				"        and a.req_code=h.doc_id(+) and b.bus_id=i.user_id(+)"+
				"        and a.rent_mng_id=k.rent_mng_id and a.rent_l_cd=k.rent_l_cd and k.rent_st='1' "+			    
			    " ";

		try {
								
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_l_cd);
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
			System.out.println("[DocSettleDatabase:getCarPurPayDocCase]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayDocCase]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurPayCardStatList(String doc_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        a.*, "+
				"        b.com_name, b.limit_amt, b.pay_day, c.give_day, c.save_in_st, "+
				"        b.use_s_m, decode(b.use_s_day,'말',to_char(last_day(sysdate),'DD'),b.use_s_day) use_s_day, "+
				"        b.use_e_m, decode(b.use_e_day,'말',to_char(last_day(sysdate),'DD'),b.use_e_day) use_e_day, "+
				"        decode(b.mile_st,'1','현금','2','항공사') mile_st, b.mile_per, b.mile_amt, b.card_kind, "+
				"        decode(b.use_s_m,'-2','전전월','-1','전월','0','당월') sm_st,"+
				"        decode(b.use_e_m,'-2','전전월','-1','전월','0','당월') em_st,"+

                "        decode(b.card_kind_cd,'0011', f_getvalddt(a.pur_est_dt,nvl(c.give_day,4)), "+ //삼성카드 20151209 +1 익일지급 -> 20160217 +2 -> 20170712 +4
                "                           '0012', a.pur_est_dt, "+ //신한카드
				"                           '0016', f_getvalddt(a.pur_est_dt,nvl(c.give_day,3)), "+ //우리비씨
				"                           '0008', f_getvalddt(a.pur_est_dt,nvl(c.give_day,3)), "+ //부산비씨카드
				"                           '0001', f_getvalddt(a.pur_est_dt,nvl(c.give_day,2)), "+ //광주카드
				"                           '0002', f_getvalddt(a.pur_est_dt,nvl(c.give_day,2)), "+ //국민카드 당일->3일->2일
				"                           '0007', f_getvalddt(a.pur_est_dt,nvl(c.give_day,2)), "+ //롯데카드
				"                           '0017', f_getvalddt(a.pur_est_dt,nvl(c.give_day,3)), "+ //전북카드
				"                           '0022', TO_CHAR(TO_DATE(a.pur_est_dt,'YYYYMMDD')+decode(TO_CHAR(TO_DATE(a.pur_est_dt,'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), "+ //현대카드
				"                           '0009', '', "+ //블루멤버스카드
	  		    "        		                             decode(sign(b.use_e_day-substr(a.pur_est_dt,7,2)),-1,to_char(add_months(to_date(a.pur_est_dt,'YYYYMMDD'),2),'YYYYMM')||decode(length(b.pay_day),1,'0','')||b.pay_day,  \n"+
                "               		                                                                          to_char(add_months(to_date(a.pur_est_dt,'YYYYMMDD'),1),'YYYYMM')||decode(length(b.pay_day),1,'0','')||b.pay_day   \n"+
                "                                            ) \n"+
                "        ) pay_dt \n"+
				" from   "+
				"        ("+
				"          select pur_est_dt, card_kind, cardno, decode(trf_st,'2','선불','3','후불','5','포인트','7','카드할부') trf_st, count(0) cnt, sum(trf_amt) trf_amt"+
				"          from   "+
				"                 ("+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno from car_pur where req_code='"+doc_id+"' and trf_st1 in ('2','3','5')"+
				"                   union all"+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno from car_pur where req_code='"+doc_id+"' and trf_st2 in ('2','3','5')"+
				"                   union all"+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno from car_pur where req_code='"+doc_id+"' and trf_st3 in ('2','3','5')"+
				"                   union all"+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st4 as trf_st, trf_amt4 as trf_amt, card_kind4 as card_kind, cardno4 as cardno from car_pur where req_code='"+doc_id+"' and trf_st4 in ('2','3','5')"+
				"                 )"+
				"          group by pur_est_dt, card_kind, cardno, trf_st"+
				"        ) a, card b, card_cont c, (select cardno, max(seq) seq from card_cont group by cardno) d "+
				" where  a.cardno=b.cardno and b.cardno=c.cardno and c.cardno=d.cardno and c.seq=d.seq "+
				" ORDER BY b.card_st, b.card_kind, b.cardno";
			
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
			System.out.println("[DocSettleDatabase:getCarPurPayCardStatList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayCardStatList]\n"+query);
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
	
	//차량대금 지출문서관리 리스트 조회 - 카드할부
	public Vector getCarPurPayCardDebtStatList(String doc_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        b.com_name, b.card_kind, a.pur_est_dt, a.trf_st, sum(trf_amt) trf_amt "+
				" from   "+
				"        ("+
				"          select pur_est_dt, card_kind, cardno, decode(trf_st,'2','선불','3','후불','5','포인트','7','카드할부') trf_st, count(0) cnt, sum(trf_amt) trf_amt"+
				"          from   "+
				"                 ("+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno from car_pur where req_code='"+doc_id+"' and trf_st1 in ('7')"+
				"                   union all"+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno from car_pur where req_code='"+doc_id+"' and trf_st2 in ('7')"+
				"                   union all"+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno from car_pur where req_code='"+doc_id+"' and trf_st3 in ('7')"+
				"                   union all"+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st4 as trf_st, trf_amt4 as trf_amt, card_kind4 as card_kind, cardno4 as cardno from car_pur where req_code='"+doc_id+"' and trf_st4 in ('7')"+
				"                 )"+
				"          group by pur_est_dt, card_kind, cardno, trf_st"+
				"        ) a, card b, card_cont c, (select cardno, max(seq) seq from card_cont group by cardno) d "+
				" where  a.cardno=b.cardno and b.cardno=c.cardno and c.cardno=d.cardno and c.seq=d.seq "+
				" group by b.com_name, b.card_kind, a.pur_est_dt, a.trf_st "+
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
			System.out.println("[DocSettleDatabase:getCarPurPayCardDebtStatList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayCardDebtStatList]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public long getCarPurPayCardAmt(String cardno, String trf_st, String use_s_m, String use_s_day, String use_e_m, String use_e_day, String dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		long trf_amt = 0;
		String query = "";
		String date = "";
		String dt1 = "";
		String dt2 = "";

		dt = AddUtil.getDate();

		if(dt.length()==21) date = dt.substring(8,10);
		if(dt.length()==10) date = dt.substring(8,10);
		if(dt.length()==8)	date = dt.substring(6,8);

		if(AddUtil.parseInt(date) > AddUtil.parseInt(use_e_day)){
			dt1 = "to_char(add_months(sysdate, 0),'YYYYMM')||'"+AddUtil.addZero(use_s_day)+"'";
			dt2 = "to_char(add_months(sysdate, 1),'YYYYMM')||'"+AddUtil.addZero(use_e_day)+"'";
		}else{
			dt1 = "to_char(add_months(sysdate,-1),'YYYYMM')||'"+AddUtil.addZero(use_s_day)+"'";
			dt2 = "to_char(add_months(sysdate, 0),'YYYYMM')||'"+AddUtil.addZero(use_e_day)+"'";
		}

		query = "   select sum(trf_amt) trf_amt"+
				"   from"+
				"   ("+
				"      select trf_amt1 as trf_amt from car_pur where cardno1='"+cardno+"' and decode(trf_st1,'2','선불','3','후불','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) between "+dt1+" and "+dt2+" "+
				"      union all"+
				"      select trf_amt2 as trf_amt from car_pur where cardno2='"+cardno+"' and decode(trf_st2,'2','선불','3','후불','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) between "+dt1+" and "+dt2+" "+
				"      union all"+
				"      select trf_amt3 as trf_amt from car_pur where cardno3='"+cardno+"' and decode(trf_st3,'2','선불','3','후불','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) between "+dt1+" and "+dt2+" "+
				"      union all"+
				"      select trf_amt4 as trf_amt from car_pur where cardno4='"+cardno+"' and decode(trf_st4,'2','선불','3','후불','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) between "+dt1+" and "+dt2+" "+
				"   )"+
				"   ";

		
		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{
				trf_amt = rs.getLong(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[DocSettleDatabase:getCarPurPayCardAmt]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayCardAmt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return trf_amt;
		}		
	}

	//차량대금 지출문서관리 리스트 조회 - 당월누적거래금액
	public long getCarPurPayCardAmt(String cardno, String trf_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		long trf_amt = 0;
		String query = "";

		query = "   select sum(trf_amt) trf_amt"+
				"   from"+
				"   ("+
				"      select trf_amt1 as trf_amt from car_pur where cardno1='"+cardno+"' and decode(trf_st1,'2','선불','3','후불','5','포인트','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) like to_char(sysdate,'YYYYMM')||'%' "+
				"      union all"+
				"      select trf_amt2 as trf_amt from car_pur where cardno2='"+cardno+"' and decode(trf_st2,'2','선불','3','후불','5','포인트','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) like to_char(sysdate,'YYYYMM')||'%' "+
				"      union all"+
				"      select trf_amt3 as trf_amt from car_pur where cardno3='"+cardno+"' and decode(trf_st3,'2','선불','3','후불','5','포인트','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) like to_char(sysdate,'YYYYMM')||'%' "+
				"      union all"+
				"      select trf_amt4 as trf_amt from car_pur where cardno4='"+cardno+"' and decode(trf_st4,'2','선불','3','후불','5','포인트','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) like to_char(sysdate,'YYYYMM')||'%' "+
				"   )"+
				"   ";

		
		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
			{
				trf_amt = rs.getLong(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[DocSettleDatabase:getCarPurPayCardAmt]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayCardAmt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return trf_amt;
		}		
	}

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurPayList(String trf_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String t_wd = "('1','2','3','7','5')";

		if(trf_st.equals("현금"))			t_wd = "('1') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("선불카드"))		t_wd = "('2','3','7') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("후불카드"))		t_wd = "('2','3','7') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("대출"))			t_wd = "('4') and pur_est_dt=to_char(sysdate,'YYYYMMDD') ";
		if(trf_st.equals("포인트"))		t_wd = "('5') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("구매보조금"))	t_wd = "('6') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("카드할부"))		t_wd = "('7') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		

		query = " select a.gubun, a.rpt_no, a.rent_mng_id, a.rent_l_cd, a.dlv_brch, nvl(c.dlv_dt,a.dlv_est_dt) dlv_dt, a.req_code, a.pur_est_dt, "+
		        "        decode(a.trf_st,'1','현금','2','선불카드','3','후불카드','7','카드할부','5','포인트','6','구매보조금') trf_st, a.trf_amt, a.card_kind, a.cardno, "+
				" c.bus_id, d.firm_nm, g.car_nm, f.car_name, f.car_comp_id, h.emp_id, h.car_off_id, h.car_off_tel, h.bank, h.acc_no, h.acc_nm"+
				" from"+
				"   ("+
				"      select '1' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno from car_pur where trf_pay_dt1 is null and trf_st1 in "+t_wd+" "+
				"      union all"+
				"      select '2' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno from car_pur where trf_pay_dt2 is null and trf_st2 in "+t_wd+" "+
				"      union all"+
				"      select '3' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno from car_pur where trf_pay_dt3 is null and trf_st3 in "+t_wd+" "+
				"      union all"+
				"      select '4' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st4 as trf_st, trf_amt4 as trf_amt, card_kind4 as card_kind, cardno4 as cardno from car_pur where trf_pay_dt4 is null and trf_st4 in "+t_wd+" "+
				"      union all"+
				"      select '5' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st5 as trf_st, trf_amt5 as trf_amt, card_kind5 as card_kind, cardno5 as cardno from car_pur where trf_pay_dt5 is null and trf_st5 in "+t_wd+" "+
				"   ) a, "+
				"   (select * from doc_settle where doc_st='5' and doc_step='3') b, "+
				"   cont c, client d, car_etc e, car_nm f, car_mng g, users l,"+
				"   (select a.rent_mng_id, a.rent_l_cd, b.*, c.car_off_tel, c.bank, c.acc_no, c.acc_nm from commi a, car_off_emp b, car_off c where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id) h,"+
					"        (select a.car_mng_id from cont a, commi c \n"+
					"    where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and a.car_gu='2' and c.agnt_st = '6'   AND a.car_mng_id IS NOT NULL group by a.car_mng_id) ac \n"+ 
				" where a.trf_amt>0 and a.req_code=b.doc_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.client_id=d.client_id"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code"+
				" and c.bus_id=l.user_id and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+)"+
				" and c.car_mng_id=ac.car_mng_id(+) and ac.car_mng_id is null \n"+ //자산양수차 제외
				" and c.car_gu<>'2' "; //중고차구입제외

		query += " order by a.trf_st, a.dlv_brch, l.dept_id, a.trf_st, a.card_kind, a.cardno, d.firm_nm";
			
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
			System.out.println("[DocSettleDatabase:getCarPurPayList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayList]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurPayStat(String trf_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String t_wd = "('1','2','3','7','5')";

		if(trf_st.equals("현금"))			t_wd = "('1') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("선불카드"))		t_wd = "('2','3','7') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("후불카드"))		t_wd = "('2','3','7') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("대출"))			t_wd = "('4') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("포인트"))		t_wd = "('5') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("구매보조금"))	t_wd = "('6') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";
		if(trf_st.equals("카드할부"))		t_wd = "('7') and pur_est_dt=to_char(sysdate,'YYYYMMDD')";

		query = " select a.card_kind, a.cardno, decode(b.card_paid,'2','선불카드','3','후불카드','5','포인트','7','카드할부') card_paid, sum(a.trf_amt) trf_amt, min(b.card_edate) card_edate"+
				" from"+
				"   ("+
				"      select '1' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno from car_pur where req_code is not null and trf_pay_dt1 is null and trf_st1 in "+t_wd+" "+
				"      union all"+
				"      select '2' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno from car_pur where req_code is not null and trf_pay_dt2 is null and trf_st2 in "+t_wd+" "+
				"      union all"+
				"      select '3' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno from car_pur where req_code is not null and trf_pay_dt3 is null and trf_st3 in "+t_wd+" "+
				"      union all"+
				"      select '4' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st4 as trf_st, trf_amt4 as trf_amt, card_kind4 as card_kind, cardno4 as cardno from car_pur where req_code is not null and trf_pay_dt4 is null and trf_st4 in "+t_wd+" "+
				"      union all"+
				"      select '5' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st5 as trf_st, trf_amt5 as trf_amt, card_kind5 as card_kind, cardno5 as cardno from car_pur where req_code is not null and trf_pay_dt5 is null and trf_st5 in "+t_wd+" "+				
				"   ) a, card b "+
				" where a.trf_amt>0 and a.cardno=b.cardno";

		query += " group by a.card_kind, b.card_paid, a.cardno order by a.card_kind, a.cardno";
			
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
			System.out.println("[DocSettleDatabase:getCarPurPayStat]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayStat]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurPayDtList(String trf_st, String pur_pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String t_wd = "('1','2','3','7','5')";

		if(trf_st.equals("현금"))			t_wd = "('1')";
		if(trf_st.equals("선불카드"))		t_wd = "('2','3','7')";
		if(trf_st.equals("후불카드"))		t_wd = "('2','3','7')";
		if(trf_st.equals("대출"))			t_wd = "('4')";
		if(trf_st.equals("포인트"))		t_wd = "('5')";
		if(trf_st.equals("구매보조금"))	t_wd = "('6')";
		if(trf_st.equals("카드할부"))		t_wd = "('7')";

		query = " select a.gubun, a.rpt_no, a.rent_mng_id, a.rent_l_cd, a.dlv_brch, nvl(c.dlv_dt,a.dlv_est_dt) dlv_dt, a.req_code, a.pur_est_dt, decode(a.gubun,'5','임시운행보험료')||decode(a.trf_st,'1','현금','2','선불카드','3','후불카드','0','계약금','7','카드할부') trf_st, a.trf_amt, a.card_kind, a.cardno, "+
				" c.bus_id, d.firm_nm, g.car_nm, f.car_name, f.car_comp_id, h.emp_id, h.car_off_id, h.car_off_tel, h.bank, h.acc_no, h.acc_nm, i.car_no"+
				" from"+
				"   ("+
				" ";
		
//		if(trf_st.equals("현금")) {
			query += "      select '0' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, con_pay_dt as pur_est_dt, '0' as trf_st, con_amt as trf_amt, '-' as card_kind, '-' as cardno from car_pur where con_amt>0 and con_pay_dt = '"+AddUtil.replace(pur_pay_dt,"-","")+"' and nvl(trf_st0,'1') in "+t_wd+" "+ 
				"      union all"+
				" ";	
//		}				
		
		query += "      select '1' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno from car_pur where trf_pay_dt1 = replace('"+pur_pay_dt+"','-','') and trf_st1 in "+t_wd+" "+
				"      union all"+
				"      select '2' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno from car_pur where trf_pay_dt2 = replace('"+pur_pay_dt+"','-','') and trf_st2 in "+t_wd+" "+
				"      union all"+
				"      select '3' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno from car_pur where trf_pay_dt3 = replace('"+pur_pay_dt+"','-','') and trf_st3 in "+t_wd+" "+
				"      union all"+
				"      select '4' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st4 as trf_st, trf_amt4 as trf_amt, card_kind4 as card_kind, cardno4 as cardno from car_pur where trf_pay_dt4 = replace('"+pur_pay_dt+"','-','') and trf_st4 in "+t_wd+" "+
				" ";
		
//		if(trf_st.equals("현금")) {
			query += " union all"+
				"      select '5' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st5 as trf_st, trf_amt5 as trf_amt, card_kind5 as card_kind, cardno5 as cardno from car_pur where trf_pay_dt5 = replace('"+pur_pay_dt+"','-','') and trf_st5 in "+t_wd+" "+
					" ";
//		}		
		
		query += "   ) a, "+
				"   (select * from doc_settle where doc_st='5' and doc_step='3') b, cont c, client d, car_etc e, car_nm f, car_mng g, car_reg i, users l, "+
				"   (select a.rent_mng_id, a.rent_l_cd, b.*, c.car_off_tel, c.bank, c.acc_no, c.acc_nm from commi a, car_off_emp b, car_off c where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id) h"+
				" where a.req_code=b.doc_id and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.client_id=d.client_id"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code"+
				" and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+)"+
				" and c.car_mng_id=i.car_mng_id(+) and c.bus_id=l.user_id";

		query += " order by l.dept_id, d.firm_nm, a.rent_l_cd, a.trf_st, a.card_kind, a.cardno, d.firm_nm";
			
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
			System.out.println("[DocSettleDatabase:getCarPurPayDtList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayDtList]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurPayDtStat(String trf_st, String pur_pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String t_wd = "('1','2','3','7')";

		if(trf_st.equals("현금"))			t_wd = "('1')";
		if(trf_st.equals("선불카드"))		t_wd = "('2','3','7')";
		if(trf_st.equals("후불카드"))		t_wd = "('2','3','7')";
		if(trf_st.equals("대출"))			t_wd = "('4')";
		if(trf_st.equals("포인트"))		t_wd = "('5')";
		if(trf_st.equals("구매보조금"))	t_wd = "('6')";
		if(trf_st.equals("카드할부"))		t_wd = "('7')";

		query = " select a.trf_st, decode(a.card_kind,'-','계약금','','현금',a.card_kind) card_kind, a.cardno, sum(a.trf_amt) trf_amt, min(b.card_edate) card_edate, min(b.limit_amt) limit_amt"+
				" from"+
				"   ("+
				"      select '0' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, con_pay_dt as pur_est_dt, '0' as trf_st, con_amt as trf_amt, '-' as card_kind, '-' as cardno from car_pur where req_code is not null and con_amt>0 and con_pay_dt = '"+AddUtil.replace(pur_pay_dt,"-","")+"' and nvl(trf_st0,'1') in "+t_wd+" "+
				"      union all"+
				"      select '1' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno from car_pur where req_code is not null and trf_pay_dt1 = replace('"+pur_pay_dt+"','-','') and trf_st1 in "+t_wd+" "+
				"      union all"+
				"      select '2' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno from car_pur where req_code is not null and trf_pay_dt2 = replace('"+pur_pay_dt+"','-','') and trf_st2 in "+t_wd+" "+
				"      union all"+
				"      select '3' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno from car_pur where req_code is not null and trf_pay_dt3 = replace('"+pur_pay_dt+"','-','') and trf_st3 in "+t_wd+" "+
				"      union all"+
				"      select '4' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st4 as trf_st, trf_amt4 as trf_amt, card_kind4 as card_kind, cardno4 as cardno from car_pur where req_code is not null and trf_pay_dt4 = replace('"+pur_pay_dt+"','-','') and trf_st4 in "+t_wd+" "+
				"      union all"+
				"      select '5' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st5 as trf_st, trf_amt5 as trf_amt, card_kind5 as card_kind, cardno5 as cardno from car_pur where req_code is not null and trf_pay_dt5 = replace('"+pur_pay_dt+"','-','') and trf_st5 in "+t_wd+" "+
				"   ) a, card b "+
				" where a.cardno=b.cardno";

		query += " group by a.trf_st, a.card_kind, a.cardno order by a.trf_st, a.card_kind, a.cardno";
			
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
			System.out.println("[DocSettleDatabase:getCarPurPayDtStat]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayDtStat]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurBrchAccList(String car_off_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " "+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind1 as bank, a.cardno1 as acc_no, a.trf_cont1 as acc_nm, a.trf_pay_dt1  bas_dt, a.acc_st1 as acc_st from car_pur a, (select a.rent_l_cd, d.nm from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st1='1' and a.trf_amt1>0 and a.card_kind1 is not null and a.dlv_brch like '%"+car_off_nm+"%' and a.rent_l_cd=b.rent_l_cd \n"+
				" union all \n"+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind2 as bank, a.cardno2 as acc_no, a.trf_cont2 as acc_nm, a.trf_pay_dt2  bas_dt, a.acc_st2 as acc_st from car_pur a, (select a.rent_l_cd, d.nm from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st2='1' and a.trf_amt2>0 and a.card_kind2 is not null and a.dlv_brch like '%"+car_off_nm+"%' and a.rent_l_cd=b.rent_l_cd \n"+
				" union all \n"+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind3 as bank, a.cardno3 as acc_no, a.trf_cont3 as acc_nm, a.trf_pay_dt3  bas_dt, a.acc_st3 as acc_st from car_pur a, (select a.rent_l_cd, d.nm from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st3='1' and a.trf_amt3>0 and a.card_kind3 is not null and a.dlv_brch like '%"+car_off_nm+"%' and a.rent_l_cd=b.rent_l_cd \n"+
				" union all \n"+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind4 as bank, a.cardno4 as acc_no, a.trf_cont4 as acc_nm, a.trf_pay_dt4  bas_dt, a.acc_st4 as acc_st from car_pur a, (select a.rent_l_cd, d.nm from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st4='1' and a.trf_amt4>0 and a.card_kind4 is not null and a.dlv_brch like '%"+car_off_nm+"%' and a.rent_l_cd=b.rent_l_cd \n"+
				"  ";

		String query2 = " select st, car_comp_nm, car_off_nm, bank, acc_st, acc_no, acc_nm, max(bas_dt) bas_dt from ( "+query+" ) group by st, car_comp_nm, car_off_nm, bank, acc_st, acc_no, acc_nm order by st, car_comp_nm, car_off_nm, bas_dt desc";
		
		try {
								
			pstmt = conn.prepareStatement(query2);
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
			System.out.println("[DocSettleDatabase:getCarPurBrchAccList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurBrchAccList]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurBrchAccList2(String car_off_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " "+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind1 as bank, a.cardno1 as acc_no, a.trf_cont1 as acc_nm, a.trf_pay_dt1  bas_dt, a.acc_st1 as acc_st from car_pur a, (select a.rent_l_cd, d.nm, c.car_off_id from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st1='1' and a.trf_amt1>0 and a.card_kind1 is not null and a.dlv_brch like '%"+car_off_nm+"%' and a.rent_l_cd=b.rent_l_cd \n"+
				" union all \n"+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind2 as bank, a.cardno2 as acc_no, a.trf_cont2 as acc_nm, a.trf_pay_dt2  bas_dt, a.acc_st2 as acc_st from car_pur a, (select a.rent_l_cd, d.nm, c.car_off_id from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st2='1' and a.trf_amt2>0 and a.card_kind2 is not null and a.dlv_brch like '%"+car_off_nm+"%' and a.rent_l_cd=b.rent_l_cd \n"+
				" union all \n"+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind3 as bank, a.cardno3 as acc_no, a.trf_cont3 as acc_nm, a.trf_pay_dt3  bas_dt, a.acc_st3 as acc_st from car_pur a, (select a.rent_l_cd, d.nm, c.car_off_id from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st3='1' and a.trf_amt3>0 and a.card_kind3 is not null and a.dlv_brch like '%"+car_off_nm+"%' and a.rent_l_cd=b.rent_l_cd \n"+
				" union all \n"+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind4 as bank, a.cardno4 as acc_no, a.trf_cont4 as acc_nm, a.trf_pay_dt4  bas_dt, a.acc_st4 as acc_st from car_pur a, (select a.rent_l_cd, d.nm, c.car_off_id from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st4='1' and a.trf_amt4>0 and a.card_kind4 is not null and a.dlv_brch like '%"+car_off_nm+"%' and a.rent_l_cd=b.rent_l_cd \n"+
				"  ";


		String query2 = " select * from ( "+query+" ) order by bas_dt desc ";


			
		try {
								
			pstmt = conn.prepareStatement(query2);
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
			System.out.println("[DocSettleDatabase:getCarPurBrchAccList2]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurBrchAccList2]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurBrchAccList3(String car_off_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
		query = " "+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind1 as bank, a.cardno1 as acc_no, a.trf_cont1 as acc_nm, a.trf_pay_dt1  bas_dt, a.acc_st1 as acc_st from car_pur a, (select a.rent_l_cd, d.nm, c.car_off_id from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st1='1' and a.trf_amt1>0 and a.card_kind1 is not null and b.car_off_id = '"+car_off_id+"' and a.rent_l_cd=b.rent_l_cd \n"+
				" union all \n"+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind2 as bank, a.cardno2 as acc_no, a.trf_cont2 as acc_nm, a.trf_pay_dt2  bas_dt, a.acc_st2 as acc_st from car_pur a, (select a.rent_l_cd, d.nm, c.car_off_id from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st2='1' and a.trf_amt2>0 and a.card_kind2 is not null and b.car_off_id = '"+car_off_id+"' and a.rent_l_cd=b.rent_l_cd \n"+
				" union all \n"+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind3 as bank, a.cardno3 as acc_no, a.trf_cont3 as acc_nm, a.trf_pay_dt3  bas_dt, a.acc_st3 as acc_st from car_pur a, (select a.rent_l_cd, d.nm, c.car_off_id from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st3='1' and a.trf_amt3>0 and a.card_kind3 is not null and b.car_off_id = '"+car_off_id+"' and a.rent_l_cd=b.rent_l_cd \n"+
				" union all \n"+
				" select  '출고'   st, b.nm as car_comp_nm, a.dlv_brch as car_off_nm, a.card_kind4 as bank, a.cardno4 as acc_no, a.trf_cont4 as acc_nm, a.trf_pay_dt4  bas_dt, a.acc_st4 as acc_st from car_pur a, (select a.rent_l_cd, d.nm, c.car_off_id from commi a, car_off_emp b, car_off c, (select * from code where c_st='0001') d where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id and c.car_comp_id=d.code) b where a.trf_st4='1' and a.trf_amt4>0 and a.card_kind4 is not null and b.car_off_id = '"+car_off_id+"' and a.rent_l_cd=b.rent_l_cd \n"+
				"  ";

		String query2 = " select * from ( "+query+" ) order by 7 desc ";
			
		try {
								
			pstmt = conn.prepareStatement(query2);
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
			System.out.println("[DocSettleDatabase:getCarPurBrchAccList2]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurBrchAccList2]\n"+query);
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

	public boolean insertDocSettle(DocSettleBean doc)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1=null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String doc_no = "";
		String query =  " insert into doc_settle "+
						" ( doc_no, doc_st, doc_id, sub, cont, etc, doc_bit,"+
						"   user_nm1,  user_id1,  user_dt1, "+
						"   user_nm2,  user_id2,  "+
						"   user_nm3,  user_id3,  "+
						"   user_nm4,  user_id4,  "+
						"   user_nm5,  user_id5,  "+
						"   user_nm6,  user_id6,  "+
						"   user_nm7,  user_id7,  "+
						"   user_nm8,  user_id8,  "+
						"   user_nm9,  user_id9,  "+
						"   user_nm10, user_id10,  "+
						"   doc_step,  doc_dt  "+
						" ) values "+
						" ( ?, ?, ?, ?, ?, ?, ?,"+
						"   ?, ?, sysdate, "+
						"   ?, ?,    ?, ?,   ?, ?,   ?, ?,   ?, ?,   ?, ?,   ?, ?,   ?, ?,   ?, ?,  ?, replace(?,'-','') "+
						" )";

		String qry_id = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(doc_no,9,4))+1), '0000')), '0001') doc_no"+
						" from doc_settle "+
						" where substr(doc_no,1,8)=to_char(sysdate,'YYYYMMDD')";


		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			while(rs.next())
			{
				doc_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			
			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1,  doc_no);
			pstmt2.setString(2,  doc.getDoc_st());
			pstmt2.setString(3,  doc.getDoc_id());
			pstmt2.setString(4,  doc.getSub());
			pstmt2.setString(5,  doc.getCont());
			pstmt2.setString(6,  doc.getEtc());
			pstmt2.setString(7,  doc.getDoc_bit());
			pstmt2.setString(8,  doc.getUser_nm1());
			pstmt2.setString(9,  doc.getUser_id1());
			pstmt2.setString(10, doc.getUser_nm2());
			pstmt2.setString(11, doc.getUser_id2());
			pstmt2.setString(12, doc.getUser_nm3());
			pstmt2.setString(13, doc.getUser_id3());
			pstmt2.setString(14, doc.getUser_nm4());
			pstmt2.setString(15, doc.getUser_id4());
			pstmt2.setString(16, doc.getUser_nm5());
			pstmt2.setString(17, doc.getUser_id5());
			pstmt2.setString(18, doc.getUser_nm6());
			pstmt2.setString(19, doc.getUser_id6());
			pstmt2.setString(20, doc.getUser_nm7());
			pstmt2.setString(21, doc.getUser_id7());
			pstmt2.setString(22, doc.getUser_nm8());
			pstmt2.setString(23, doc.getUser_id8());
			pstmt2.setString(24, doc.getUser_nm9());
			pstmt2.setString(25, doc.getUser_id9());
			pstmt2.setString(26, doc.getUser_nm10());
			pstmt2.setString(27, doc.getUser_id10());
			pstmt2.setString(28, doc.getDoc_step());
			pstmt2.setString(29, doc.getDoc_dt());

			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[DocSettleDatabase:insertDocSettle]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				  if(rs != null)	rs.close();
				  if(pstmt1 != null)	pstmt1.close();
	          		  if(pstmt2 != null)	pstmt2.close();
				
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean insertDocSettle2(DocSettleBean doc)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1=null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String doc_no = "";
		String query =  " insert into doc_settle "+
						" ( doc_no, doc_st, doc_id, sub, cont, etc, doc_bit,"+
						"   user_nm1,  user_id1,  "+
						"   user_nm2,  user_id2,  "+
						"   user_nm3,  user_id3,  "+
						"   user_nm4,  user_id4,  "+
						"   user_nm5,  user_id5,  "+
						"   user_nm6,  user_id6,  "+
						"   user_nm7,  user_id7,  "+
						"   user_nm8,  user_id8,  "+
						"   user_nm9,  user_id9,  "+
						"   user_nm10, user_id10,  "+
						"   doc_step  "+
						" ) values "+
						" ( ?, ?, ?, ?, ?, ?, ?,"+
						"   ?, ?, "+
						"   ?, ?,    ?, ?,   ?, ?,   ?, ?,   ?, ?,   ?, ?,   ?, ?,   ?, ?,   ?, ?,  ?"+
						" )";

		String qry_id = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(doc_no,9,4))+1), '0000')), '0001') doc_no"+
						" from doc_settle "+
						" where substr(doc_no,1,8)=to_char(sysdate,'YYYYMMDD')";


		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			while(rs.next())
			{
				doc_no = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
	
			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1,  doc_no);
			pstmt2.setString(2,  doc.getDoc_st());
			pstmt2.setString(3,  doc.getDoc_id());
			pstmt2.setString(4,  doc.getSub());
			pstmt2.setString(5,  doc.getCont());
			pstmt2.setString(6,  doc.getEtc());
			pstmt2.setString(7,  doc.getDoc_bit());
			pstmt2.setString(8,  doc.getUser_nm1());
			pstmt2.setString(9,  doc.getUser_id1());
			pstmt2.setString(10, doc.getUser_nm2());
			pstmt2.setString(11, doc.getUser_id2());
			pstmt2.setString(12, doc.getUser_nm3());
			pstmt2.setString(13, doc.getUser_id3());
			pstmt2.setString(14, doc.getUser_nm4());
			pstmt2.setString(15, doc.getUser_id4());
			pstmt2.setString(16, doc.getUser_nm5());
			pstmt2.setString(17, doc.getUser_id5());
			pstmt2.setString(18, doc.getUser_nm6());
			pstmt2.setString(19, doc.getUser_id6());
			pstmt2.setString(20, doc.getUser_nm7());
			pstmt2.setString(21, doc.getUser_id7());
			pstmt2.setString(22, doc.getUser_nm8());
			pstmt2.setString(23, doc.getUser_id8());
			pstmt2.setString(24, doc.getUser_nm9());
			pstmt2.setString(25, doc.getUser_id9());
			pstmt2.setString(26, doc.getUser_nm10());
			pstmt2.setString(27, doc.getUser_id10());
			pstmt2.setString(28, doc.getDoc_step());

			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[DocSettleDatabase:insertDocSettle2]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				 if(rs != null)	rs.close();
				 if(pstmt1 != null)	pstmt1.close();
	         			 if(pstmt2 != null)	pstmt2.close();
				
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	public boolean updateDocSettle(String doc_no, String user_id, String doc_bit, String doc_step)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_bit=decode(doc_step,'3',doc_bit,?), doc_step=decode(doc_step,'3',doc_step,?), user_id"+doc_bit+"=?";
		if(!user_id.equals("XXXXXX")){	query += ",user_dt"+doc_bit+"=sysdate ";  }
		query += "	where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			if(!doc_bit.equals("")){
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, doc_bit);
				pstmt.setString(2, doc_step);
				pstmt.setString(3, user_id);
				pstmt.setString(4, doc_no);
			    pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettle]\n"+e);
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
	
	public boolean updateDocSettleCommiRe(String doc_no, String doc_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_bit=decode(user_id3,'XXXXXX','1','3'), doc_step='2', user_dt6='', user_dt7='', user_dt8='' where doc_no=? and doc_id=? and doc_st='1'";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_no);
			pstmt.setString(2, doc_id);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleCommiRe]\n"+e);
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
	
	public boolean updateDocSettleAfter(String doc_no, String user_id, String doc_bit, String doc_step, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set "
				/*+ "doc_bit=decode(doc_step,'3',doc_bit,?), "
				+ "doc_step=decode(doc_step,'3',doc_step,?), "
				+ "user_dt"+doc_bit+"=sysdate, "*/
				+ "user_nm5=?";
		query += "	where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			if(!doc_bit.equals("")){
				pstmt = conn.prepareStatement(query);
			/*	pstmt.setString(1, doc_bit);
				pstmt.setString(2, doc_step);*/
				pstmt.setString(1, gubun);
				pstmt.setString(2, doc_no);
			    pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettle]\n"+e);
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
	
	public boolean updateDocSettleAfterCom(String doc_no, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set "
				+ "user_id2=?,"
				+ "user_nm5=''";
		query += "	where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);
			pstmt.setString(2, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettle]\n"+e);
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


	public boolean updateDocSettleClr(String doc_no, String user_id, String doc_bit, String doc_step)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_bit=?, doc_step=?, user_dt6='' where doc_st = '2' and doc_no=?";


		try 
		{
			conn.setAutoCommit(false);

			if(!doc_bit.equals("")){
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, doc_bit);
				pstmt.setString(2, doc_step);
				pstmt.setString(3, doc_no);
			    pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleClr]\n"+e);
			System.out.println("[DocSettleDatabase:updateDocSettleClr]\n"+query);
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

	public boolean updateDocSettleNon(String doc_no, String user_id, String doc_bit, String doc_step)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_step=?  where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_step);
			pstmt.setString(2, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleNon]\n"+e);
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

	public boolean updateDocSettleDt(String doc_no, String user_id, String doc_bit, String doc_step, String doc_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_bit=?, doc_step=?, user_id"+doc_bit+"=?, user_dt"+doc_bit+"=to_date(?,'YYYY-MM-DD') where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_bit);
			pstmt.setString(2, doc_step);
			pstmt.setString(3, user_id);
			pstmt.setString(4, doc_dt);
			pstmt.setString(5, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleDt]\n"+e);
			System.out.println("[DocSettleDatabase:updateDocSettleDt]\n"+query);
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

	public boolean updateDocSettleDtNull(String doc_no, String doc_bit)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set user_dt"+doc_bit+"='' where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleDtNull]\n"+e);
			System.out.println("[DocSettleDatabase:updateDocSettleDtNull]\n"+query);
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

	public boolean updateDocSettleCng(String doc_no, String req_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set user_id1=?, user_id5=? where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, req_id);
			pstmt.setString(2, req_id);
			pstmt.setString(3, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleCng]\n"+e);
			System.out.println("[DocSettleDatabase:updateDocSettleCng]\n"+query);
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

	public boolean updateDocSettleOffCng(String doc_no, String off_user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set user_id2=?, user_id3=?, user_id4=? where doc_no=? and user_dt2 is null";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, off_user_id);
			pstmt.setString(2, off_user_id);
			pstmt.setString(3, off_user_id);
			pstmt.setString(4, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleOffCng]\n"+e);
			System.out.println("[DocSettleDatabase:updateDocSettleOffCng]\n"+query);
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

	public boolean updateDocSettleUserCng(String doc_no, String doc_bit, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set user_id"+doc_bit+"=? where doc_no=? and user_dt"+doc_bit+" is null";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);
			pstmt.setString(2, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleUserCng]\n"+e);
			System.out.println("[DocSettleDatabase:updateDocSettleUserCng]\n"+query);
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

	public boolean updateDocSettleCancel(String doc_no, String doc_bit, String doc_step)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_bit=?, doc_step=?, user_dt"+doc_bit+"='' where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_bit);
			pstmt.setString(2, doc_step);
			pstmt.setString(3, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleCancel]\n"+e);
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

	public boolean updateDocSettleCancel(String doc_no, String doc_step)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_step=? where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_step);
			pstmt.setString(2, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleCancel]\n"+e);
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
	
	public boolean updateDocSettleBitCancel(String doc_no, String doc_bit, String doc_step)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_bit=?, doc_step=? ";
		
		for(int i=1;i <= 10;i++){
			if(AddUtil.parseInt(doc_bit) < i){
				query += ", user_dt"+i+"=''";
			}
		}
		
		query += " where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_bit);
			pstmt.setString(2, doc_step);
			pstmt.setString(3, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleBitCancel]\n"+e);
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
	
	public boolean updateDocSettleDocBit(String doc_no, String doc_bit)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_bit=? ,  where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_bit);
			pstmt.setString(2, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleDocBit]\n"+e);
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


	public boolean updateDocSettleDocDt(String doc_no, String doc_bit, String doc_step)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_bit=?, doc_step=?, user_dt"+doc_bit+"= sysdate   where doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_bit);
			pstmt.setString(2, doc_step);
			pstmt.setString(3, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleDocDt]\n"+e);
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
	
	
	//영업사원 누적순위
	public String getCommiEmpRank(String emp_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String rk = "";

		query = " select rk from"+
				" ("+
				"		select emp_id, count(*), rank() over (order by count(*) desc) as rk"+
				"		from commi"+
				"		where agnt_st='1' and emp_id is not null and substr(sup_dt,1,4)<to_char(sysdate,'YYYY')"+
				"		group by emp_id"+
				" )"+
				" where emp_id='"+emp_id+"'";

		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				 rk = rs.getString("rk")==null?"":rs.getString("rk");
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[DocSettleDatabase:getCommiEmpRank]\n"+e);
			System.out.println("[DocSettleDatabase:getCommiEmpRank]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rk;
		}		
	}
	
	//해지정산처리관리 리스트 조회 - chk:1:계약해지  2:매입옵션, 3:월렌트
	public Vector getClsDocList(String s_kd, String t_wd, String gubun1, String andor, String chk)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  b.term_yn, \n"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, b.cls_dt,\n"+
				" a.rent_dt, a.firm_nm, c.car_no, c.car_doc_no, c.car_nm, a.rent_start_dt, \n"+
				" decode(i.dept_id,'0007','부산','0008','대전','') dept_nm, i.user_nm as bus_nm, \n"+
				" decode(a.use_yn,'Y','진행','N','해지','미결') use_st, b.cls_st, \n"+
				" decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' ,  '') cls_st_nm, \n"+
				" nvl(b.autodoc_yn, 'N') autodoc_yn , \n"+
				" decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit,"+
				" l.doc_no, l.doc_step, l.user_id1, l.user_id2, l.user_id3, l.user_id4, l.user_id5, l.user_dt1, l.user_dt2, l.user_dt3, l.user_dt4, l.user_dt5 , \n"+
				" a.use_yn, c.init_reg_dt , c.fuel_kd , b.opt_amt  \n"+
				" from cont_n_view a, cls_etc b, users i, users df,  car_reg c, cls_etc_more d ,  \n"+
				" (select * from doc_settle where doc_st='11') l \n"+
				" where a.car_st<>'2' \n"+
				" and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id = d.rent_mng_id and b.rent_l_cd = d.rent_l_cd  \n"+
				" and  a.car_mng_id = c.car_mng_id(+) "+ 
				" and a.rent_l_cd=l.doc_id(+) \n"+
				" and l.user_id1=i.user_id(+) \n"+	
				" and b.dft_saction_id=df.user_id(+) ";

		
				
		if(gubun1.equals("1"))			query += " and l.user_dt5 is null";//미결
		else if(gubun1.equals("2"))		query += " and l.user_dt5 is not null";//결재
	
		if(s_kd.equals("1"))	query += " and nvl(a.firm_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and nvl(a.rent_l_cd, ' ') like '%"+t_wd+"%'";	
		if(s_kd.equals("3"))	query += " and nvl(c.car_no, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("4"))	query += " and nvl(i.user_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("6"))	query += " and b.cls_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		if(s_kd.equals("7"))	query += " and nvl(df.user_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("8"))	query += " and to_char(l.user_dt1, 'yyyymmdd') like '"+t_wd+"%'";
		if(s_kd.equals("9"))	query += " and to_char(l.user_dt5, 'yyyymmdd') like '"+t_wd+"%'";
			 					
		if(s_kd.equals("5") && gubun1.equals("2") ) {
			if ( !t_wd.equals("")) {
				query += " and b.cls_dt like '"+t_wd+"%'";
			} else {
				//매입옵션인 경우 자산처리 안되있는 거 표시 
				if(  chk.equals("2") ) {
					 query += " and  ( b.cls_dt like to_char(sysdate,'YYYYMM')||'%'  or nvl(b.autodoc_yn, '1')  = '1'    )   " ;
			   } else {
			    	 query += " and  ( b.cls_dt like to_char(sysdate,'YYYYMM')||'%'  or nvl(b.autodoc_yn, '1')  = '1'    )  " ;
			  }		 
			}		
		}
		
		if (chk.equals("1"))     query += " and b.cls_st in ( '1', '2', '7', '10' ) ";
		if (chk.equals("2"))     query += " and b.cls_st in ( '8' ) ";  //매입옵션 
		if (chk.equals("3"))     query += " and b.cls_st in ( '14' ) ";
		
		if(andor.equals("1"))	query += " and b.cls_st = '1'";
		if(andor.equals("2"))	query += " and b.cls_st = '2'";	
		if(andor.equals("7"))	query += " and b.cls_st = '7'";	
		if(andor.equals("10"))	query += " and b.cls_st = '10'";	
		if(andor.equals("8"))	query += " and b.cls_st = '8'";
		if(andor.equals("14"))	query += " and b.cls_st = '14'";
		
		if(gubun1.equals("2"))	{  //결재인 경우 
			query += " order by b.cls_dt desc , a.rent_dt, a.rent_start_dt, a.rent_mng_id";
		} else {
			query += " order by l.user_dt3 asc , d.cms_after desc, l.doc_bit ,   b.cls_dt desc , a.rent_dt, a.rent_start_dt, a.rent_mng_id";
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
			System.out.println("[DocSettleDatabase:getClsDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getClsDocList]\n"+query);
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

	//해지정산처리관리 리스트 조회 - chk:1:계약해지  2:매입옵션, 3:월렌트
	public Vector getClsDocList(String s_kd, String t_wd, String gubun1, String andor, String chk,String st_dt,String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(a) */ b.term_yn, \n"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, b.cls_dt,\n"+
				" a.rent_dt, a.firm_nm, c.car_no, c.car_nm, a.rent_start_dt, \n"+
				" decode(i.dept_id,'0007','부산','0008','대전','') dept_nm, i.user_nm as bus_nm, \n"+
				" decode(a.use_yn,'Y','진행','N','해지','미결') use_st, b.cls_st, \n"+
				" decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' ,  '') cls_st_nm, \n"+
				" nvl(b.autodoc_yn, 'N') autodoc_yn , \n"+
				" decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit,"+
				" l.doc_no, l.doc_step, l.user_id1, l.user_id2, l.user_id3, l.user_id4, l.user_id5, l.user_dt1, l.user_dt2, l.user_dt3, l.user_dt4, l.user_dt5 , a.use_yn ,  c.fuel_kd  \n"+
				" from cont_n_view a, cls_etc b, users i, users df,  car_reg c, cls_etc_more d , \n"+
				" (select * from doc_settle where doc_st='11') l \n"+
				" where a.car_st<>'2' \n"+
				" and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id = d.rent_mng_id and b.rent_l_cd = d.rent_l_cd \n"+
				" and  a.car_mng_id = c.car_mng_id(+) "+ 
				" and a.rent_l_cd=l.doc_id(+) \n"+
				" and l.user_id1=i.user_id(+) \n"+
				" and b.dft_saction_id=df.user_id(+) ";

		
				
		if(gubun1.equals("1"))			query += " and l.user_dt5 is null";//미결
		else if(gubun1.equals("2"))		query += " and l.user_dt5 is not null";//결재
	
		if(s_kd.equals("1"))	query += " and nvl(a.firm_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and nvl(a.rent_l_cd, ' ') like '%"+t_wd+"%'";	
		if(s_kd.equals("3"))	query += " and nvl(c.car_no, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("4"))	query += " and nvl(i.user_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("6"))	query += " and b.cls_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		if(s_kd.equals("7"))	query += " and nvl(df.user_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("8"))	query += " and to_char(l.user_dt1, 'yyyymmdd') like '"+t_wd+"%'";
		if(s_kd.equals("9"))	query += " and to_char(l.user_dt5, 'yyyymmdd') like '"+t_wd+"%'";
			 					
		if(s_kd.equals("5") && gubun1.equals("2") ) {
			if ( !t_wd.equals("")) {
				query += " and b.cls_dt like '"+t_wd+"%'";
			} else {
				if ( chk.equals("2") ) {
					query += " and  b.cls_dt like to_char(sysdate, 'yyyy')||'%'" ;
				} else {	
					query += " and  ( b.cls_dt like to_char(sysdate,'YYYYMM')||'%' or nvl(b.autodoc_yn, '1')  = '1'    ) " ;
				}	
			}	
		
		}
		if(s_kd.equals("10")) {
				query += " AND to_char(l.user_dt1, 'yyyymmdd')  BETWEEN  '"+st_dt+"' AND   '"+end_dt+"'";		
		}
		if (chk.equals("1"))     query += " and b.cls_st in ( '1', '2', '7', '10' ) ";
		if (chk.equals("2"))     query += " and b.cls_st in ( '8' ) ";
		if (chk.equals("3"))     query += " and b.cls_st in ( '14' ) ";
		
		if(andor.equals("1"))	query += " and b.cls_st = '1'";
		if(andor.equals("2"))	query += " and b.cls_st = '2'";	
		if(andor.equals("7"))	query += " and b.cls_st = '7'";	
		if(andor.equals("10"))	query += " and b.cls_st = '10'";	
		if(andor.equals("8"))	query += " and b.cls_st = '8'";
		if(andor.equals("14"))	query += " and b.cls_st = '14'";
		
		if(gubun1.equals("2"))	{  //결재인 경우 
			query += " order by b.cls_dt desc , a.rent_dt, a.rent_start_dt, a.rent_mng_id";
		} else {
			query += " order by l.user_dt3 asc , d.cms_after desc, l.doc_bit ,   b.cls_dt desc , a.rent_dt, a.rent_start_dt, a.rent_mng_id";
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
			System.out.println("[DocSettleDatabase:getClsDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getClsDocList]\n"+query);
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

	//해지차량 임직원보험가입 리스트
	public Vector getClsDocListExcel(String s_kd, String t_wd, String gubun1,String st_dt,String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "  select c.car_no,f.INS_STS, f.INS_CON_NO,a.FIRM_NM, c.CAR_NM,g.CLIENT_ST,g.ENP_NO,TEXT_DECRYPT(g.ssn, 'pw' ) ssn,f.ins_start_dt,f.ins_exp_dt, decode(f.com_emp_yn,'Y','가입','N','미가입','') before_emp_yn,  \n"+
				"   i.firm_nm AS firm_nm2, j.COM_EMP_YN  \n"+
				"  from cont_n_view a, cls_etc b,  users df,  car_reg c,    \n"+ 
				"  (select * from doc_settle where doc_st='11') l,   \n"+
				"  insur f,  \n"+
				"  car_etc e, car_nm h, client g, ins_com ic,  \n"+
				"  (select * from cont where car_st in ('1','3') and nvl(use_yn,'Y')='Y') d, client i, cont_etc j ,(SELECT reco_dt,rent_mng_id,rent_l_cd FROM car_reco) k \n"+
				"  where a.car_st<>'2'  \n"+
				"  and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd   \n"+
				"  and  a.car_mng_id = c.car_mng_id(+)   \n"+
				"  AND a.rent_mng_id=k.rent_mng_id  \n"+
				"  AND a.rent_l_cd = k.rent_l_cd    \n"+
				"  AND f.ins_com_id=ic.ins_com_id(+)  \n"+
				"  and a.rent_l_cd=l.doc_id(+)   \n"+
				" and b.dft_saction_id=df.user_id(+)   \n"+
				" and c.car_mng_id=f.car_mng_id    \n "+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd    \n"+
				" and e.car_id=h.CAR_ID and e.car_seq=h.car_seq    \n"+
				" and a.client_id=g.client_id  \n"+
				" AND a.car_st IN ('1','3')  \n"+
				" AND b.cls_dt BETWEEN to_char(to_date(f.ins_start_dt,'YYYYMMDD')+1,'YYYYMMDD') AND f.ins_exp_dt  \n"+
				" and b.cls_st in ( '1', '2', '7', '10' ) "+
				" and a.car_mng_id=d.car_mng_id(+) and d.client_id=i.client_id(+)  "+
				" and d.rent_mng_id=j.rent_mng_id(+) and d.rent_l_cd=j.rent_l_cd(+)  "+
		        " and l.user_dt1 is not null";//결재
			 					
		if(s_kd.equals("5") && gubun1.equals("2") ) {
			if ( !t_wd.equals("")) {
				query += " and b.cls_dt like '"+t_wd+"%'";
			} 	
		}
		if(s_kd.equals("10")) {
				query += " AND to_char(l.user_dt1, 'yyyymmdd')  BETWEEN  '"+st_dt+"' AND   '"+end_dt+"'";		
		}
		
		query += " order by ic.ins_com_nm desc, l.user_dt1 asc ";

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
			System.out.println("[DocSettleDatabase:getClsDocListExcel]\n"+e);
			System.out.println("[DocSettleDatabase:getClsDocListExcel]\n"+query);
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

	//해지차량 임직원보험가입 리스트
	public Hashtable getClsDocExcel(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = "  select c.car_no, f.INS_STS, f.INS_CON_NO, a.FIRM_NM, c.CAR_NM, g.CLIENT_ST, decode(g.client_st,'2',  substr(TEXT_DECRYPT(g.ssn, 'pw' ),1,6),g.ENP_NO) enp_no, "+
				"         f.ins_com_id, f.car_mng_id, f.ins_st, f.ins_start_dt, f.ins_exp_dt, decode(f.com_emp_yn,'Y','가입','N','미가입','') before_emp_yn,  \n"+
				"         decode(f.FIRM_EMP_NM,'',i.firm_nm,f.FIRM_EMP_NM) AS firm_nm2,  \n"+
				"         DECODE(f.ENP_NO,'',decode(i.client_st,'2',substr(TEXT_DECRYPT(i.ssn, 'pw' ),1,6),i.ENP_NO),f.ENP_NO) AS enp_no2, j.COM_EMP_YN,  \n"+
				"         DECODE(f.age_scp,'2','26세이상','4','24세이상','1','21세이상','3','모든운전자','5','30세이상','6','35세이상','7','43세이상','8','48세이상','9','22세이상','10','38세이상','11','35세이상~49세이하') age_scp,  \n"+
				"         DECODE(f.vins_gcp_kd,'4','5천만원','3','1억원','6','5억원','7','2억원','8','3억원','그외') VINS_GCP_KD,  \n"+
				"         DECODE(j.rent_suc_dt,'',d.rent_start_dt,j.rent_suc_dt) AS rent_start_dt,cls_st  \n"+
				"  from   cont_n_view a, cls_etc b,  users df,  car_reg c,    \n"+ 
				"         (select * from doc_settle where doc_st='11') l,   \n"+
				"         insur f,  \n"+
				"         car_etc e, car_nm h, client g, ins_com ic,  \n"+
				"         cont d, client i, cont_etc j ,(SELECT reco_dt,rent_mng_id,rent_l_cd FROM car_reco) k \n"+
				"  where a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.car_st<>'2' and nvl(d.use_yn,'Y')='Y'  \n"+
				"  and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd   \n"+
				"  and  a.car_mng_id = c.car_mng_id(+)   \n"+
				"  AND a.rent_mng_id=k.rent_mng_id  \n"+
				"  AND a.rent_l_cd = k.rent_l_cd    \n"+
				"  AND f.ins_com_id=ic.ins_com_id(+)  \n"+
				"  and a.rent_l_cd=l.doc_id(+)   \n"+
				"  and b.dft_saction_id=df.user_id(+)   \n"+
				"  and c.car_mng_id=f.car_mng_id    \n "+
				"  and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd    \n"+
				"  and e.car_id=h.CAR_ID and e.car_seq=h.car_seq    \n"+
				"  and a.client_id=g.client_id  \n"+
				"  AND a.car_st IN ('1','3')  \n"+
				"  AND b.cls_dt BETWEEN to_char(to_date(f.ins_start_dt,'YYYYMMDD')+1,'YYYYMMDD') AND f.ins_exp_dt  \n"+
				"  and b.cls_st in ( '1', '2', '7', '10' ) "+
				"  and a.car_mng_id=d.car_mng_id(+) and d.client_id=i.client_id(+)  "+
				"  and d.rent_mng_id=j.rent_mng_id(+) and d.rent_l_cd=j.rent_l_cd(+)  "+
		        "  and l.user_dt1 is not null";
			 					
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
			System.out.println("[DocSettleDatabase:getClsDocExcel]\n"+e);
			System.out.println("[DocSettleDatabase:getClsDocExcel]\n"+query);
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

	public boolean deleteDocSettle(String doc_st, String doc_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " delete doc_settle where doc_st=? and doc_id=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_st);
			pstmt.setString(2, doc_id);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:deleteDocSettle]\n"+e);
			System.out.println("[DocSettleDatabase:deleteDocSettle]\n"+query);
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

	//계약조회
	public Hashtable getCont(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select * from cont where rent_l_cd='"+rent_l_cd+"' ";

		try 
		{
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
			System.out.println("[DocSettleDatabase:getCont]\n"+e);
			System.out.println("[DocSettleDatabase:getCont]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

/* 2009-02-17 Ryu Gill Sun  start*/

//한건 조회  
	public DocSettleBean getDocSettleOt(String doc_st, String doc_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DocSettleBean bean = new DocSettleBean();
		String query = "";
		query = " select * from doc_settle where doc_st=? and doc_id = ?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_st);
			pstmt.setString(2, doc_id);
		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setDoc_no		(rs.getString("doc_no")==null?"":rs.getString("doc_no"));
				bean.setDoc_st		(rs.getString("doc_st")==null?"":rs.getString("doc_st"));
				bean.setDoc_id		(rs.getString("doc_id")==null?"":rs.getString("doc_id"));
				bean.setSub			(rs.getString("sub")==null?"":rs.getString("sub"));
				bean.setCont		(rs.getString("cont")==null?"":rs.getString("cont"));
				bean.setEtc			(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setUser_nm1	(rs.getString("user_nm1")==null?"":rs.getString("user_nm1"));	
				bean.setUser_id1	(rs.getString("user_id1")==null?"":rs.getString("user_id1"));
				bean.setUser_dt1	(rs.getString("user_dt1")==null?"":rs.getString("user_dt1"));
				bean.setUser_nm2	(rs.getString("user_nm2")==null?"":rs.getString("user_nm2"));	
				bean.setUser_id2	(rs.getString("user_id2")==null?"":rs.getString("user_id2"));
				bean.setUser_dt2	(rs.getString("user_dt2")==null?"":rs.getString("user_dt2"));
				bean.setUser_nm3	(rs.getString("user_nm3")==null?"":rs.getString("user_nm3"));	
				bean.setUser_id3	(rs.getString("user_id3")==null?"":rs.getString("user_id3"));
				bean.setUser_dt3	(rs.getString("user_dt3")==null?"":rs.getString("user_dt3"));
				bean.setUser_nm4	(rs.getString("user_nm4")==null?"":rs.getString("user_nm4"));	
				bean.setUser_id4	(rs.getString("user_id4")==null?"":rs.getString("user_id4"));
				bean.setUser_dt4	(rs.getString("user_dt4")==null?"":rs.getString("user_dt4"));
				bean.setUser_nm5	(rs.getString("user_nm5")==null?"":rs.getString("user_nm5"));	
				bean.setUser_id5	(rs.getString("user_id5")==null?"":rs.getString("user_id5"));
				bean.setUser_dt5	(rs.getString("user_dt5")==null?"":rs.getString("user_dt5"));
				bean.setUser_nm6	(rs.getString("user_nm6")==null?"":rs.getString("user_nm6"));	
				bean.setUser_id6	(rs.getString("user_id6")==null?"":rs.getString("user_id6"));
				bean.setUser_dt6	(rs.getString("user_dt6")==null?"":rs.getString("user_dt6"));
				bean.setUser_nm7	(rs.getString("user_nm7")==null?"":rs.getString("user_nm7"));	
				bean.setUser_id7	(rs.getString("user_id7")==null?"":rs.getString("user_id7"));
				bean.setUser_dt7	(rs.getString("user_dt7")==null?"":rs.getString("user_dt7"));
				bean.setUser_nm8	(rs.getString("user_nm8")==null?"":rs.getString("user_nm8"));	
				bean.setUser_id8	(rs.getString("user_id8")==null?"":rs.getString("user_id8"));
				bean.setUser_dt8	(rs.getString("user_dt8")==null?"":rs.getString("user_dt8"));
				bean.setUser_nm9	(rs.getString("user_nm9")==null?"":rs.getString("user_nm9"));	
				bean.setUser_id9	(rs.getString("user_id9")==null?"":rs.getString("user_id9"));
				bean.setUser_dt9	(rs.getString("user_dt9")==null?"":rs.getString("user_dt9"));
				bean.setUser_nm10	(rs.getString("user_nm10")==null?"":rs.getString("user_nm10"));	
				bean.setUser_id10	(rs.getString("user_id10")==null?"":rs.getString("user_id10"));
				bean.setUser_dt10	(rs.getString("user_dt10")==null?"":rs.getString("user_dt10"));
				bean.setDoc_bit		(rs.getString("doc_bit")==null?"":rs.getString("doc_bit"));
				bean.setDoc_step	(rs.getString("doc_step")==null?"":rs.getString("doc_step"));									
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[DocSettleDatabase:getDocSettleOt]\n"+e);
			System.out.println("[DocSettleDatabase:getDocSettleOt]\n"+query);
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

public boolean updateDocSettleOt(String doc_id, String user_id, String doc_bit, String doc_step, String us_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set  \n"+
				" doc_bit=?, \n"+
				" doc_step=?, \n"+
				" user_id"+doc_bit+"=?, \n"+
				" user_dt"+doc_bit+"=sysdate \n"+
				" where doc_id=? and user_id1 = ?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_bit);
			pstmt.setString(2, doc_step);
			pstmt.setString(3, us_id);
			pstmt.setString(4, doc_id);
			pstmt.setString(5, user_id);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleOt]\n"+e);
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

//한건 조회
	public DocSettleBean getDocSettleOver_time(String doc_st, String doc_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DocSettleBean bean = new DocSettleBean();
		String query = "";
		query = " select * from doc_settle where doc_st=? and doc_id = ?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_st);
			pstmt.setString(2, doc_id);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setDoc_no		(rs.getString("doc_no")==null?"":rs.getString("doc_no"));
				bean.setDoc_st		(rs.getString("doc_st")==null?"":rs.getString("doc_st"));
				bean.setDoc_id		(rs.getString("doc_id")==null?"":rs.getString("doc_id"));
				bean.setSub			(rs.getString("sub")==null?"":rs.getString("sub"));
				bean.setCont		(rs.getString("cont")==null?"":rs.getString("cont"));
				bean.setEtc			(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setUser_nm1	(rs.getString("user_nm1")==null?"":rs.getString("user_nm1"));	
				bean.setUser_id1	(rs.getString("user_id1")==null?"":rs.getString("user_id1"));
				bean.setUser_dt1	(rs.getString("user_dt1")==null?"":rs.getString("user_dt1"));
				bean.setUser_nm2	(rs.getString("user_nm2")==null?"":rs.getString("user_nm2"));	
				bean.setUser_id2	(rs.getString("user_id2")==null?"":rs.getString("user_id2"));
				bean.setUser_dt2	(rs.getString("user_dt2")==null?"":rs.getString("user_dt2"));
				bean.setUser_nm3	(rs.getString("user_nm3")==null?"":rs.getString("user_nm3"));	
				bean.setUser_id3	(rs.getString("user_id3")==null?"":rs.getString("user_id3"));
				bean.setUser_dt3	(rs.getString("user_dt3")==null?"":rs.getString("user_dt3"));
				bean.setUser_nm4	(rs.getString("user_nm4")==null?"":rs.getString("user_nm4"));	
				bean.setUser_id4	(rs.getString("user_id4")==null?"":rs.getString("user_id4"));
				bean.setUser_dt4	(rs.getString("user_dt4")==null?"":rs.getString("user_dt4"));
				bean.setUser_nm5	(rs.getString("user_nm5")==null?"":rs.getString("user_nm5"));	
				bean.setUser_id5	(rs.getString("user_id5")==null?"":rs.getString("user_id5"));
				bean.setUser_dt5	(rs.getString("user_dt5")==null?"":rs.getString("user_dt5"));
				bean.setUser_nm6	(rs.getString("user_nm6")==null?"":rs.getString("user_nm6"));	
				bean.setUser_id6	(rs.getString("user_id6")==null?"":rs.getString("user_id6"));
				bean.setUser_dt6	(rs.getString("user_dt6")==null?"":rs.getString("user_dt6"));
				bean.setUser_nm7	(rs.getString("user_nm7")==null?"":rs.getString("user_nm7"));	
				bean.setUser_id7	(rs.getString("user_id7")==null?"":rs.getString("user_id7"));
				bean.setUser_dt7	(rs.getString("user_dt7")==null?"":rs.getString("user_dt7"));
				bean.setUser_nm8	(rs.getString("user_nm8")==null?"":rs.getString("user_nm8"));	
				bean.setUser_id8	(rs.getString("user_id8")==null?"":rs.getString("user_id8"));
				bean.setUser_dt8	(rs.getString("user_dt8")==null?"":rs.getString("user_dt8"));
				bean.setUser_nm9	(rs.getString("user_nm9")==null?"":rs.getString("user_nm9"));	
				bean.setUser_id9	(rs.getString("user_id9")==null?"":rs.getString("user_id9"));
				bean.setUser_dt9	(rs.getString("user_dt9")==null?"":rs.getString("user_dt9"));
				bean.setUser_nm10	(rs.getString("user_nm10")==null?"":rs.getString("user_nm10"));	
				bean.setUser_id10	(rs.getString("user_id10")==null?"":rs.getString("user_id10"));
				bean.setUser_dt10	(rs.getString("user_dt10")==null?"":rs.getString("user_dt10"));
				bean.setDoc_bit		(rs.getString("doc_bit")==null?"":rs.getString("doc_bit"));
				bean.setDoc_step	(rs.getString("doc_step")==null?"":rs.getString("doc_step"));									
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[DocSettleDatabase:getDocSettleOver_time]\n"+e);
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

/* 2009-02-17 Ryu Gill Sun  end*/	
/* 2009-03-25 Ryu Gill Sun  start*/	
/*팀장/부서장 결재*/
public boolean updateDocSettleOt2(String doc_id, String doc_bit, String doc_step, String us_id, String doc_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set \n"+
				" doc_bit=?, \n"+
				" doc_step=?, \n"+
				" user_id2=?, \n"+
				" user_dt2=sysdate \n"+
				" where doc_id=? and doc_st = ? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_bit);
			pstmt.setString(2, doc_step);
			pstmt.setString(3, us_id);
			pstmt.setString(4, doc_id);
			pstmt.setString(5, doc_st);

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleOt2]\n"+e);
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

/*총무팀장 결재*/
public boolean updateDocSettleOt3(String doc_id, String doc_bit, String doc_step, String us_id, String doc_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";


		query = " update doc_settle set \n"+
				" doc_bit=?, \n"+
				" doc_step=?, \n"+
				" user_id3=?, \n"+
				" user_dt3=sysdate \n"+
				" where doc_id=? and doc_st  = ? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_bit);
			pstmt.setString(2, doc_step);
			pstmt.setString(3, us_id);
			pstmt.setString(4, doc_id);
			pstmt.setString(5, doc_st);

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleOt3]\n"+e);
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



/*최종결재 - 인사담당*/
public boolean updateDocSettleOt7(String doc_id, String doc_bit, String doc_step, String us_id, String doc_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";


		query = " update doc_settle set \n"+
				" doc_bit=?, \n"+
				" doc_step=?, \n"+
				" user_id7=?, \n"+
				" user_dt7=sysdate \n"+
				" where doc_id=? and doc_st  = ? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_bit);
			pstmt.setString(2, doc_step);
			pstmt.setString(3, us_id);
			pstmt.setString(4, doc_id);
			pstmt.setString(5, doc_st);

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleOt7]\n"+e);
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


/* 2009-03-25 Ryu Gill Sun  end*/	

	public boolean Free_deleteDocSettle(String doc_st, String doc_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " delete from doc_settle where doc_st=? and doc_id=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_st);
			pstmt.setString(2, doc_id);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:Free_deleteDocSettle]\n"+e);
			System.out.println("[DocSettleDatabase:Free_deleteDocSettle]\n"+query);
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
	
	public boolean deleteDocSettle(String doc_st, String doc_id, String doc_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " delete from doc_settle where doc_st=? and doc_id=? and doc_no=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_st);
			pstmt.setString(2, doc_id);
			pstmt.setString(3, doc_no);
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:deleteDocSettle]\n"+e);
			System.out.println("[DocSettleDatabase:deleteDocSettle]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCommiEmpAccList(String emp_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select sup_dt, emp_acc_nm, rel, rec_incom_yn, rec_incom_st, emp_bank, emp_acc_no, rec_ssn, rec_zip, rec_addr, file_name1, file_name2, file_gubun1, file_gubun2 "+
				" from   commi "+
				" where  emp_id='"+emp_id+"' and commi >0 and rec_ssn is not null "+
				" order by sup_dt desc";
			
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
			System.out.println("[DocSettleDatabase:getCommiEmpAccList]\n"+e);
			System.out.println("[DocSettleDatabase:getCommiEmpAccList]\n"+query);
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

	//임의연장문서관리
	public Vector getFeeImDocList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.*, d.firm_nm, e.car_no, e.car_nm, \n"+
				"        decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        a.doc_no, a.user_id1, a.user_id2, a.user_id3, a.user_dt1, a.user_dt2, a.user_dt3,  \n"+
				"        f1.user_nm as user_nm1, f2.user_nm as user_nm2, f3.user_nm as user_nm3  \n"+
				" from   doc_settle a, fee_im b, cont c, client d, car_reg e, users f1, users f2, users f3  \n"+
				" where  a.doc_st='15'  and to_char(a.user_dt1,'YYYYMMDD')>'20100906' \n"+
				" and    a.doc_id=b.rent_l_cd||b.rent_st||b.im_seq  \n"+
				" and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd  \n"+
				" and    c.client_id=d.client_id  \n"+
				" and    c.car_mng_id=e.car_mng_id  \n"+
				" and    a.user_id1=f1.user_id  \n"+
				" and    a.user_id2=f2.user_id(+)  \n"+
				" and    a.user_id3=f3.user_id(+)  \n"+
				" ";

			
		if(gubun1.equals("1"))			query += " and a.doc_step<>'3'";//미결
		else if(gubun1.equals("2"))		query += " and a.doc_step='3'";//결재

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(c.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(f1.user_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(replace(to_char(a.user_dt1,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(replace(to_char(a.user_dt2,'YYYYMMDD'),'-',''), ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by a.doc_step, a.user_dt1";

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
			System.out.println("[DocSettleDatabase:getFeeImDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getFeeImDocList]\n"+query);
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

	//임의연장문서관리
	public Vector getFeeImStatList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.*, d.firm_nm, e.car_no, e.car_nm, \n"+
				"        decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        a.doc_no, a.user_id1, a.user_id2, a.user_id3, a.user_dt1, a.user_dt2, a.user_dt3,  \n"+
				"        f1.user_nm as user_nm1, f2.user_nm as user_nm2, f3.user_nm as user_nm3, \n"+
				"        decode(f.cls_st, '1','계약만료', '2','중도해약', '3','영업소변경', '4','차종변경', '5','계약승계', '6','매각', '7','출고전해지(신차)', '8','매입옵션', '9', '폐차', '10' , '개시전해지(재리스)') cls_st, \n"+
				"        f.cls_st, f.cls_dt, g.rent_st as max_rent_st, \n"+
				"        decode(b.rent_st,g.rent_st,'','연장') fee_st, \n"+
				"        g2.rent_start_dt fee_start_dt, g2.rent_end_dt as fee_end_dt, g2.rent_dt as fee_rent_dt, \n"+
				"        to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(b.rent_end_dt,'YYYYMMDD') d_days \n"+
				" from   doc_settle a, fee_im b, cont c, client d, car_reg e, users f1, users f2, users f3,  \n"+
				"        cls_cont f, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) g, fee g2, \n"+
				"        (select rent_mng_id, rent_l_cd, rent_st, max(im_seq) im_seq from fee_im group by rent_mng_id, rent_l_cd, rent_st) b2 \n"+
				" where  a.doc_st='15'  and to_char(a.user_dt1,'YYYYMMDD')>'20100906'  \n"+
				" and    a.doc_id=b.rent_l_cd||b.rent_st||b.im_seq  \n"+
				" and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd  \n"+
				" and    c.client_id=d.client_id  \n"+
				" and    c.car_mng_id=e.car_mng_id  \n"+
				" and    a.user_id1=f1.user_id  \n"+
				" and    a.user_id2=f2.user_id(+)  \n"+
				" and    a.user_id3=f3.user_id(+)  \n"+
				" and    c.rent_mng_id=f.rent_mng_id(+) and c.rent_l_cd=f.rent_l_cd(+) \n"+
				" and    c.rent_mng_id=g.rent_mng_id and c.rent_l_cd=g.rent_l_cd \n"+
				" and    g.rent_mng_id=g2.rent_mng_id and g.rent_l_cd=g2.rent_l_cd and g.rent_st=g2.rent_st \n"+
				" and    b.rent_mng_id=b2.rent_mng_id and b.rent_l_cd=b2.rent_l_cd and b.rent_st=b2.rent_st and b.im_seq=b2.im_seq \n"+
				" ";

			
		if(gubun1.equals("1"))			query += " and b.rent_st=g.rent_st and f.cls_dt is null";//진행// and b.rent_end_dt >= to_char(sysdate,'YYYYMMDD')
		else if(gubun1.equals("2"))		query += " and b.rent_st<>g.rent_st";//종결// or b.rent_end_dt < to_char(sysdate,'YYYYMMDD')
		else if(gubun1.equals("3"))		query += " and f.cls_dt is not null";//종결// or b.rent_end_dt < to_char(sysdate,'YYYYMMDD')

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(c.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(f1.user_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(replace(to_char(a.user_dt1,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(replace(to_char(a.user_dt2,'YYYYMMDD'),'-',''), ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by a.user_dt1, b.rent_end_dt";

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
			System.out.println("[DocSettleDatabase:getFeeImStatList]\n"+e);
			System.out.println("[DocSettleDatabase:getFeeImStatList]\n"+query);
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

	//사고처리결과문서관리 리스트 조회
	public Vector getAccidResultDocList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.accid_id, b.car_mng_id, b.rent_s_cd, b.rent_mng_id, b.rent_l_cd, b.our_fault_per , \n"+
				"        decode(e.cust_st,'1',d2.firm_nm,'4',f.user_nm,d1.firm_nm) firm_nm, \n"+
				"        b.accid_dt, \n"+
				"        b.accid_st, \n"+
				"        decode(b.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,  \n"+
				" 			 decode(e.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st, \n"+
				"        nvl(b.accid_addr,b.accid_cont) accid_addr, \n"+
				"        g.car_no, g.car_nm, \n"+
				"        h.pay_amt, \n"+
				"        decode(i.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        i.doc_no, i.doc_id, i.doc_step, i.doc_st, i.user_id1, i.user_id2, to_char(i.user_dt1,'YYYYMMDD') user_dt1, to_char(i.user_dt2,'YYYYMMDD') user_dt2, \n"+
				"        iu1.user_nm user_nm1, iu2.user_nm user_nm2, b2.user_nm as bus_nm2 , b.asset_st \n"+
				" from   accident b, cont c, client d1, rent_cont e, client d2, users f, \n"+
				"        car_reg g, \n"+
				"        (select a.rent_mng_id, a.rent_l_cd, b.car_mng_id, substr(a.ext_id,1,6) accid_id, sum(a.ext_pay_amt) pay_amt \n"+
				"         from   scd_ext a, cont b \n"+
				"         where  a.ext_st='6' \n"+
				"                and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"         group by a.rent_mng_id, a.rent_l_cd, b.car_mng_id, substr(a.ext_id,1,6) \n"+
				"        ) h, \n"+
				"        (select * from   doc_settle where  doc_st='45') i, \n"+
				"        users iu1, users iu2, users b2 \n"+
				" where  \n"+
				"        (substr(b.accid_dt,1,8)>'20101231' or i.doc_step is not null) \n"+
				"        and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d1.client_id \n"+
				"        and b.rent_s_cd=e.rent_s_cd(+) and b.car_mng_id=e.car_mng_id(+) \n"+
				"        and e.cust_id=d2.client_id(+) \n"+
				"        and e.cust_id=f.user_id(+) \n"+
				"        and b.car_mng_id=g.car_mng_id(+) \n"+
				"        and b.car_mng_id=h.car_mng_id(+) and b.accid_id=h.accid_id(+) \n"+
				"        and b.car_mng_id||b.accid_id=i.doc_id \n"+
				"        and i.user_id1=iu1.user_id(+) and i.user_id2=iu2.user_id(+) \n"+
				"        and c.bus_id2=b2.user_id "+
				" ";

		if(gubun1.equals("1"))			query += " and nvl(i.doc_step,'0')<>'3' and decode(b.settle_st, '1', b.settle_dt, to_char(sysdate,'YYYYMMDD')) > '20101231'";//미결
		else if(gubun1.equals("2"))		query += " and nvl(i.doc_step,'0')='3'";//결재
		else if(gubun1.equals("3"))		query += " and b.settle_st='1' and decode(b.settle_st, '1', b.settle_dt, to_char(sysdate,'YYYYMMDD')) > '20101231'";//종결처리


		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(decode(e.cust_st,'1',d2.firm_nm,'4',f.user_nm,d1.firm_nm), ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(g.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(b2.user_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(b.accid_dt, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(replace(to_char(i.user_dt1,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(replace(to_char(i.user_dt2,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(iu1.user_nm, ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by i.user_dt1 desc, b.accid_dt";

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
			System.out.println("[DocSettleDatabase:getAccidResultDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getAccidResultDocList]\n"+query);
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

	//소액채권대손처리요청 리스트
	public Vector getBadDebtDocList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.*, \n"+
				"        DECODE(c2.rent_s_cd,'','',c2.rent_s_cd) rent_s_cd, \n"+
				"        DECODE(c2.rent_s_cd,'',d.firm_nm,d2.firm_nm) firm_nm, \n"+
                "        DECODE(c2.rent_s_cd,'',e.car_mng_id,e2.car_mng_id) car_mng_id,  \n"+
                "        DECODE(c2.rent_s_cd,'',e.car_no,e2.car_no) car_no,  \n"+
                "        DECODE(c2.rent_s_cd,'',e.car_nm,e2.car_nm) car_nm,  \n"+
				"        decode(b.bad_debt_st,'1','채권추심','2','대손처리','3','기각') bad_debt_st_nm,  \n"+
				"        decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        a.doc_no, a.user_id1, a.user_id2, a.user_id3, a.user_dt1, a.user_dt2, a.user_dt3,  \n"+
				"        f1.user_nm as user_nm1, f2.user_nm as user_nm2, f3.user_nm as user_nm3, c.car_st  \n"+
				" from   doc_settle a, bad_debt_req b, cont c, client d, car_reg e, users f1, users f2, users f3, RENT_CONT c2, CLIENT d2, CAR_REG e2  \n"+
				" where  a.doc_st='46' \n"+
				" and    a.doc_id=b.rent_l_cd||b.seq  \n"+
				" and    b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd  \n"+
				" and    c.client_id=d.client_id  \n"+
				" and    c.car_mng_id=e.car_mng_id  \n"+
				" and    a.user_id1=f1.user_id  \n"+
				" and    a.user_id2=f2.user_id(+)  \n"+
				" and    a.user_id3=f3.user_id(+)  \n"+
			    " AND    b.rent_mng_id=c2.car_mng_id(+)  \n"+
                " AND    REPLACE(b.RENT_L_CD,'RM00000','')=c2.rent_s_cd(+)   \n"+
                " AND    c2.cust_id=d2.client_id(+)  \n"+
                " AND    c2.car_mng_id=e2.car_mng_id(+)  \n"+
				" ";

			
		if(gubun1.equals("1"))			query += " and a.doc_step<>'3'";//미결
		else if(gubun1.equals("2"))		query += " and a.doc_step='3'";//결재

		String what = "";

		if(s_kd.equals("1")||s_kd.equals(""))	what = "upper(nvl(DECODE(c2.rent_s_cd,'',d.firm_nm,d2.firm_nm), ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(DECODE(c2.rent_s_cd,'',e.car_no,e2.car_no), ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(f1.user_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(replace(to_char(a.user_dt1,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(replace(to_char(a.user_dt2,'YYYYMMDD'),'-',''), ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by a.doc_step, a.user_dt1";

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
			System.out.println("[DocSettleDatabase:getBadDebtDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getBadDebtDocList]\n"+query);
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

	//보험변경문서처리관리 리스트 조회
	public Vector getCarInsDocList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.doc_no, a.doc_id, a.doc_step, a.doc_bit, \n"+ 
				"        decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        a.user_id1, a.user_id2, a.user_id3, \n"+ 
				"        to_char(a.user_dt1,'YYYY-MM-DD') as user_dt1, a.user_dt2, a.user_dt3, \n"+ 
				"        u1.user_nm as user_nm1, u2.user_nm as user_nm2, u3.user_nm as user_nm3, \n"+
				"        g.nm as dept_nm, \n"+ 
				"        d.rent_mng_id, d.rent_l_cd, e.firm_nm, f.car_no, f.car_nm, \n"+ 
				"        b.ins_doc_st, b.ins_doc_no, b.car_mng_id, b.ins_st, c.cnt, \n"+ 
				"        decode(c.ch_item, '1','대물가입금액','2','자기신체사고가입금액(사망/장애)','3','무보험차상해특약','4','자기차량손해가입금액','5','연령변경','6','애니카특약','7','대물+자기신체사고가입금액', '8','차종변경','9','자기차량손해자기부담금', '13','기타','10','대인2가입금액', '11','차량대체', '12','자기신체사고가입금액(부상)','14','임직원한전운전특약','15','피보험자변경','16','고객피보험자 보험갱신','17','블랙박스','18','견인고리') ch_item, \n"+ 
				"        b.ch_etc as etc, b.reg_dt, b.ch_st \n"+ 
				" from   doc_settle a, ins_change_doc b, (select ins_doc_no, min(ch_tm) ch_tm, min(ch_item) ch_item, count(*) cnt from ins_change_doc_list group by ins_doc_no) c, \n"+ 
				"        users u1, users u2, users u3, \n"+ 
				"        cont d, client e, car_reg f, (select * from code where c_st='0002') g \n"+ 
				" where  a.doc_st='47' \n"+ 
				"        and a.doc_id=b.ins_doc_no \n"+ 
				"        and nvl(b.doc_st,'1')='1' \n"+
				"        and b.ins_doc_no=c.ins_doc_no \n"+ 
				"        and a.user_id1=u1.user_id \n"+ 
				"        and a.user_id2=u2.user_id(+) \n"+ 
				"        and a.user_id3=u3.user_id(+) \n"+ 
				"        and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd \n"+ 
				"        and d.client_id=e.client_id \n"+ 
				"        and d.car_mng_id=f.car_mng_id "+
				"        and u1.dept_id=g.code "+
				" ";

			
		if(gubun1.equals("1"))			query += " and nvl(a.doc_step,'0')<>'3'";//미결
		else if(gubun1.equals("2"))		query += " and a.doc_step='3'";//결재

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(f.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(f.car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(u1.user_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(replace(to_char(a.user_dt1,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(replace(to_char(a.user_dt3,'YYYYMMDD'),'-',''), ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by decode(a.user_dt1,'',1,0), a.user_dt1, b.reg_dt ";

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
			System.out.println("[DocSettleDatabase:getCarInsDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarInsDocList]\n"+query);
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

	//보험변경문서처리관리 리스트 조회
	public Vector getCarInsDocList(String s_kd, String t_wd, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.doc_no, a.doc_id, a.doc_step, a.doc_bit, h.ins_con_no , \n"+ 
				"        decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        a.user_id1, a.user_id2, a.user_id3,a.user_id4, a.user_nm5, \n"+ 
				"        to_char(a.user_dt1,'YYYY-MM-DD') as user_dt1, a.user_dt2, a.user_dt3, a.user_dt4, \n"+ 
				"        u1.user_nm as user_nm1, u2.user_nm as user_nm2, u3.user_nm as user_nm3, u5.user_nm as user_nm4, \n"+
				"        g.nm as dept_nm, \n"+ 
				"        d.rent_mng_id, d.rent_l_cd, e.firm_nm, f.car_no, f.car_nm, \n"+ 
				"        b.ins_doc_st, b.ins_doc_no, b.car_mng_id, b.ins_st, c.cnt, \n"+ 
				"        decode(c.ch_item, '1','대물가입금액','2','자기신체사고가입금액(사망/장애)','3','무보험차상해특약','4','자기차량손해가입금액','5','연령변경','6','애니카특약','7','대물+자기신체사고가입금액', '8','차종변경','9','자기차량손해자기부담금', '13','기타','10','대인2가입금액', '11','차량대체', '12','자기신체사고가입금액(부상)','14','임직원한전운전특약','15','피보험자변경','16','고객피보험자 보험갱신','17','블랙박스','18','견인고리') ch_item, \n"+ 
				"        b.ch_etc as etc, b.reg_dt, decode(b.ch_st,'1','반영','2','견적','3','복구') ch_st_nm, b.ch_st, u4.user_nm as reg_nm \n"+ 
				" from   doc_settle a, ins_change_doc b, (select ins_doc_no, min(ch_tm) ch_tm, min(ch_item) ch_item, count(*) cnt from ins_change_doc_list group by ins_doc_no) c, \n"+ 
				"        users u1, users u2, users u3, users u4, users u5, \n"+ 
				"        cont d, client e, car_reg f, (select * from code where c_st='0002') g , insur h  \n"+ 
				" where  a.doc_st='47' \n"+ 
				"        and a.doc_id=b.ins_doc_no \n"+ 
				"        and nvl(b.doc_st,'1')='1' \n"+
				"        and b.ins_doc_no=c.ins_doc_no \n"+ 
				"        and a.user_id1=u1.user_id \n"+ 
				"        and a.user_id2=u2.user_id(+) \n"+ 
				"        and a.user_id3=u3.user_id(+) \n"+ 
				"        and a.user_id4=u5.user_id(+) \n"+ 
				"        and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd \n"+ 
				"        and d.client_id=e.client_id \n"+ 
				"        and d.car_mng_id=f.car_mng_id "+
				"        and u1.dept_id=g.code "+
				"        and b.reg_id=u4.user_id "+
				"        and d.car_mng_id=h.car_mng_id "+
				"        and h.ins_sts = '1' "+
				" ";

		if(gubun2.equals("1")){

			query += " and b.ch_st='1'";//반영
			
			if(gubun1.equals("1"))			query += " and a.doc_step<>'3'";//미결
			else if(gubun1.equals("2"))		query += " and a.doc_step='3'";//결재

		}else if(gubun2.equals("2")){

			query += " and b.ch_st='2'";//견적

			if(gubun1.equals("1"))			query += " and b.reg_dt=to_char(sysdate,'YYYYMMDD')";//미결->당일자

		}else{

			if(gubun1.equals("1"))			query += " and (a.doc_step<>'3' or (b.ch_st='2' and b.reg_dt=to_char(sysdate,'YYYYMMDD')))";//미결
			else if(gubun1.equals("2"))		query += " and a.doc_step='3'";//결재

		}
		

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(f.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(f.car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(u1.user_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(replace(to_char(a.user_dt1,'YYYYMMDD'),'-',''), ' '))";			
		if(s_kd.equals("8"))	what = "upper(nvl(replace(b.reg_dt,'-',''), ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by decode(a.user_dt1,'',1,0), a.user_dt1, b.reg_dt ";

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
			System.out.println("[DocSettleDatabase:getCarInsDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarInsDocList]\n"+query);
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

	//보험변경문서처리관리 리스트 조회
	public Vector getCarInsDocEndList(String s_kd, String t_wd, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.doc_no, a.doc_id, a.doc_step, a.doc_bit, \n"+ 
				"        decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        a.user_id1, a.user_id2, a.user_id3, \n"+ 
				"        to_char(a.user_dt1,'YYYY-MM-DD') as user_dt1, a.user_dt2, a.user_dt3, \n"+ 
				"        u1.user_nm as user_nm1, u2.user_nm as user_nm2, u3.user_nm as user_nm3, \n"+
				"        g.nm as dept_nm, \n"+ 
				"        d.rent_mng_id, d.rent_l_cd, e.firm_nm, f.car_no, f.car_nm, \n"+ 
				"        b.ins_doc_st, b.ins_doc_no, b.car_mng_id, b.ins_st, c.cnt, \n"+ 
				"        decode(c.ch_item, '1','대물가입금액','2','자기신체사고가입금액(사망/장애)','3','무보험차상해특약','4','자기차량손해가입금액','5','연령변경','6','애니카특약','7','대물+자기신체사고가입금액', '8','차종변경','9','자기차량손해자기부담금', '13','기타','10','대인2가입금액', '11','차량대체', '12','자기신체사고가입금액(부상)','14','임직원한전운전특약','15','피보험자변경','16','고객피보험자 보험갱신','17','블랙박스','18','견인고리') ch_item, \n"+ 
				"        b.ch_etc as etc, b.reg_dt, decode(b.ch_st,'1','반영','2','견적') ch_st_nm, b.ch_st, u4.user_nm as reg_nm, b.ch_dt, b.ch_s_dt, b.ch_e_dt \n"+ 
				" from   doc_settle a, ins_change_doc b, (select ins_doc_no, min(ch_tm) ch_tm, min(ch_item) ch_item, count(*) cnt from ins_change_doc_list group by ins_doc_no) c, \n"+ 
				"        users u1, users u2, users u3, users u4, \n"+ 
				"        cont d, client e, car_reg f, (select * from code where c_st='0002') g \n"+ 
				" where  a.doc_st='47' and a.doc_step='3' \n"+ 
				"        and a.doc_id=b.ins_doc_no   \n"+ 
				"        and b.CH_E_DT is not null and nvl(b.ins_doc_st,'Y')='Y' and b.doc_st='1' AND b.ch_st='1' \n"+
				"        and b.ins_doc_no=c.ins_doc_no \n"+ 
				"        and a.user_id1=u1.user_id \n"+ 
				"        and a.user_id2=u2.user_id(+) \n"+ 
				"        and a.user_id3=u3.user_id(+) \n"+ 
				"        and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd \n"+ 
				"        and d.client_id=e.client_id \n"+ 
				"        and d.car_mng_id=f.car_mng_id "+
				"        and u1.dept_id=g.code "+
				"        and b.reg_id=u4.user_id "+
				" ";

			
		if(gubun1.equals("1"))			query += " and b.CH_E_DT >= TO_CHAR(SYSDATE,'YYYYMMDD') ";//예정
		else if(gubun1.equals("2"))		query += " and b.CH_E_DT <  TO_CHAR(SYSDATE,'YYYYMMDD') ";//만료



		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(f.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(f.car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(u1.user_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(replace(to_char(a.user_dt1,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(replace(to_char(a.user_dt3,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(replace(b.reg_dt,'-',''), ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by b.CH_E_DT";

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
			System.out.println("[DocSettleDatabase:getCarInsDocEndList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarInsDocEndList]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurPayEstDtList(String trf_st, String pur_pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String t_wd = "('2','3')";

		if(trf_st.equals("현금"))			t_wd = "('1')";
		if(trf_st.equals("선불카드"))		t_wd = "('2','3','7')";
		if(trf_st.equals("후불카드"))		t_wd = "('2','3','7')";
		if(trf_st.equals("대출"))			t_wd = "('4')";
		if(trf_st.equals("포인트"))		t_wd = "('5')";
		if(trf_st.equals("구매보조금"))	t_wd = "('6')";
		if(trf_st.equals("카드할부"))		t_wd = "('7')";

		query = " select a.gubun, a.rpt_no, a.rent_mng_id, a.rent_l_cd, a.dlv_brch, nvl(c.dlv_dt,a.dlv_est_dt) dlv_dt, a.req_code, a.pur_est_dt, decode(a.trf_st,'1','현금','2','선불카드','3','후불카드','4','대출','5','포인트','6','구매보조금','0','계약금','7','카드할부') trf_st, a.trf_amt, a.card_kind, a.cardno, "+
				" c.bus_id, d.firm_nm, g.car_nm, f.car_name, f.car_comp_id, h.emp_id, h.car_off_id, h.car_off_tel, h.bank, h.acc_no, h.acc_nm, i.car_no"+
				" from"+
				"   ("+
				"      select '1' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno from car_pur where nvl(trf_pay_dt1,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st1 in "+t_wd+" "+
				"      union all"+
				"      select '2' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno from car_pur where nvl(trf_pay_dt2,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st2 in "+t_wd+" "+
				"      union all"+
				"      select '3' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno from car_pur where nvl(trf_pay_dt3,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st3 in "+t_wd+" "+
				"      union all"+
				"      select '4' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st4 as trf_st, trf_amt4 as trf_amt, card_kind4 as card_kind, cardno4 as cardno from car_pur where nvl(trf_pay_dt4,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st4 in "+t_wd+" "+
				"   ) a, "+
				"   (select * from doc_settle where doc_st='5' and doc_step='3') b, cont c, client d, car_etc e, car_nm f, car_mng g, car_reg i, users l, "+
				"   (select a.rent_mng_id, a.rent_l_cd, b.*, c.car_off_tel, c.bank, c.acc_no, c.acc_nm from commi a, car_off_emp b, car_off c where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id) h"+
				" where a.req_code=b.doc_id(+) and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.client_id=d.client_id"+
				" and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code"+
				" and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+)"+
				" and c.car_mng_id=i.car_mng_id(+) and c.bus_id=l.user_id";

		query += " order by l.dept_id, d.firm_nm, a.rent_l_cd, a.trf_st, a.card_kind, a.cardno, d.firm_nm";
			
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
			System.out.println("[DocSettleDatabase:getCarPurPayEstDtList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayEstDtList]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurPayEstDtStat(String trf_st, String pur_pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String t_wd = "('1','2','3','7')";

		if(trf_st.equals("현금"))			t_wd = "('1')";
		if(trf_st.equals("선불카드"))		t_wd = "('2','3','7')";
		if(trf_st.equals("후불카드"))		t_wd = "('2','3','7')";
		if(trf_st.equals("대출"))			t_wd = "('4')";
		if(trf_st.equals("포인트"))		t_wd = "('5')";
		if(trf_st.equals("구매보조금"))	t_wd = "('6')";
		if(trf_st.equals("카드할부"))		t_wd = "('7')";

		query = " select a.trf_st, decode(a.card_kind,'-','계약금','','현금',a.card_kind) card_kind, a.cardno, sum(a.trf_amt) trf_amt, min(b.card_edate) card_edate, min(b.limit_amt) limit_amt "+
				" from"+
				"   ("+
				"      select '1' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno from car_pur where nvl(trf_pay_dt1,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st1 in "+t_wd+" "+
				"      union all"+
				"      select '2' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno from car_pur where nvl(trf_pay_dt2,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st2 in "+t_wd+" "+
				"      union all"+
				"      select '3' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno from car_pur where nvl(trf_pay_dt3,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st3 in "+t_wd+" "+
				"      union all"+
				"      select '4' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st4 as trf_st, trf_amt4 as trf_amt, card_kind4 as card_kind, cardno4 as cardno from car_pur where nvl(trf_pay_dt4,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st4 in "+t_wd+" "+
				"   ) a, card b "+
				" where a.cardno=b.cardno(+)";

		query += " group by a.trf_st, a.card_kind, a.cardno order by a.trf_st, a.card_kind, a.cardno";
			
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
			System.out.println("[DocSettleDatabase:getCarPurPayEstDtStat]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayEstDtStat]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회
	public Vector getCarPurPayEstDtStat(String pur_pay_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		query = " select "+
				"        a.*, "+
				"        b.com_name, b.limit_amt, b.pay_day, "+
				"        b.use_s_m, decode(b.use_s_day,'말',to_char(last_day(sysdate),'DD'),b.use_s_day) use_s_day, "+
				"        b.use_e_m, decode(b.use_e_day,'말',to_char(last_day(sysdate),'DD'),b.use_e_day) use_e_day, "+
				"        decode(b.mile_st,'1','현금','2','항공사') mile_st, b.mile_per, b.mile_amt, b.card_kind, "+
				"        decode(b.use_s_m,'-2','전전월','-1','전월','0','당월') sm_st,"+
				"        decode(b.use_e_m,'-2','전전월','-1','전월','0','당월') em_st,"+

                "        decode(b.card_kind_cd,'0011', f_getvalddt(a.pur_est_dt,nvl(c.give_day,4)), "+ //삼성카드 20151209 +1 익일지급 -> 20160217 +2 -> 20170712 +4
                "                           '0012', a.pur_est_dt, "+ //신한카드
				"                           '0016', f_getvalddt(a.pur_est_dt,nvl(c.give_day,3)), "+ //우리비씨
				"                           '0008', f_getvalddt(a.pur_est_dt,nvl(c.give_day,3)), "+ //부산비씨카드
				"                           '0001', f_getvalddt(a.pur_est_dt,nvl(c.give_day,2)), "+ //광주카드
				"                           '0002', f_getvalddt(a.pur_est_dt,nvl(c.give_day,2)), "+ //국민카드 당일->3일->2일
				"                           '0007', f_getvalddt(a.pur_est_dt,nvl(c.give_day,2)), "+ //롯데카드
				"                           '0017', f_getvalddt(a.pur_est_dt,nvl(c.give_day,3)), "+ //전북카드
				"                           '0022', TO_CHAR(TO_DATE(a.pur_est_dt,'YYYYMMDD')+decode(TO_CHAR(TO_DATE(a.pur_est_dt,'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), "+ //현대카드
	  		    "        		                             decode(sign(b.use_e_day-substr(a.pur_est_dt,7,2)),-1,to_char(add_months(to_date(a.pur_est_dt,'YYYYMMDD'),2),'YYYYMM')||decode(length(b.pay_day),1,'0','')||b.pay_day,  \n"+
                "               		                                                                          to_char(add_months(to_date(a.pur_est_dt,'YYYYMMDD'),1),'YYYYMM')||decode(length(b.pay_day),1,'0','')||b.pay_day   \n"+
                "                                            ) \n"+
                "        ) pay_dt \n"+
				" from   "+
				"        ("+
				"          select pur_est_dt, card_kind, cardno, decode(trf_st,'2','선불','3','후불','7','카드할부') trf_st, count(*) cnt, sum(trf_amt) trf_amt"+
				"          from   "+
				"                 ("+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno from car_pur where nvl(trf_pay_dt1,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st1 in ('2','3','7')"+
				"                   union all"+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno from car_pur where nvl(trf_pay_dt1,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st2 in ('2','3','7')"+
				"                   union all"+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno from car_pur where nvl(trf_pay_dt1,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st3 in ('2','3','7')"+
				"                   union all"+
				"                   select pur_est_dt, rent_l_cd, req_code, trf_st4 as trf_st, trf_amt4 as trf_amt, card_kind4 as card_kind, cardno4 as cardno from car_pur where nvl(trf_pay_dt1,nvl(pur_est_dt,con_est_dt)) = replace('"+pur_pay_dt+"','-','') and trf_st4 in ('2','3','7')"+
				"                 )"+
				"          group by pur_est_dt, card_kind, cardno, trf_st"+
				"        ) a, card b, card_cont c, (select cardno, max(seq) seq from card_cont group by cardno) d "+
				" where  a.cardno=b.cardno and b.cardno=c.cardno and c.cardno=d.cardno and c.seq=d.seq";
			
			
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
			System.out.println("[DocSettleDatabase:getCarPurPayEstDtStat]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayEstDtStat]\n"+query);
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

	//대여료변경문서처리관리 리스트 조회
	public Vector getFeeCngDocList(String s_kd, String t_wd, String gubun1)
	{ 
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.doc_no, a.doc_id, a.doc_step, a.doc_bit, \n"+ 
				"        decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        a.user_id1, a.user_id2, a.user_id3, \n"+ 
				"        to_char(a.user_dt1,'YYYY-MM-DD') as user_dt1, a.user_dt2, a.user_dt3, \n"+ 
				"        u1.user_nm as user_nm1, u2.user_nm as user_nm2, u3.user_nm as user_nm3, \n"+
				"        g.nm as dept_nm, \n"+ 
				"        d.rent_mng_id, d.rent_l_cd, e.firm_nm, f.car_no, f.car_nm, \n"+ 
				"        b.ins_doc_st, b.ins_doc_no, b.car_mng_id, b.ins_st, c.cnt, \n"+ 
				"        decode(c.ch_item, '1','대여상품','2','대여료할인','3','기타','4','추가운전자','5','약정운행거리','6','대여료입금예정일','7','맑은서울스티커발급','8','견인장치장착','9','보증금증감') ch_item, \n"+ 
				"        b.ch_etc as etc, b.reg_dt, u4.user_nm as reg_nm \n"+ 
				" from   doc_settle a, ins_change_doc b, (select ins_doc_no, min(ch_tm) ch_tm, min(ch_item) ch_item, count(*) cnt from ins_change_doc_list group by ins_doc_no) c, \n"+ 
				"        users u1, users u2, users u3, users u4, \n"+ 
				"        cont d, client e, car_reg f, (select * from code where c_st='0002') g \n"+ 
				" where  a.doc_st='48' \n"+ 
				"        and a.doc_id=b.ins_doc_no \n"+ 
				"        and nvl(b.doc_st,'1')='2' \n"+
				"        and b.ins_doc_no=c.ins_doc_no \n"+ 
				"        and a.user_id1=u1.user_id \n"+ 
				"        and a.user_id2=u2.user_id(+) \n"+ 
				"        and a.user_id2=u3.user_id(+) \n"+ 
				"        and b.reg_id=u4.user_id(+) \n"+ 
				"        and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd \n"+ 
				"        and d.client_id=e.client_id \n"+ 
				"        and d.car_mng_id=f.car_mng_id(+) "+
				"        and u1.dept_id=g.code "+
				" ";

			
		if(gubun1.equals("1"))			query += " and nvl(a.doc_step,'0')<>'3'";//미결
		else if(gubun1.equals("2"))		query += " and a.doc_step='3'";//결재

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(f.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(f.car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(u1.user_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(replace(to_char(a.user_dt1,'YYYYMMDD'),'-',''), ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(replace(to_char(a.user_dt2,'YYYYMMDD'),'-',''), ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by a.doc_no ";

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
			System.out.println("[DocSettleDatabase:getFeeCngDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getFeeCngDocList]\n"+query);
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

	//고소장접수요청 리스트 - 쿼리수정 
	public Vector getBadComplaintDocList(String s_kd, String t_wd, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.*, d.firm_nm, e.car_no, \r\n" + 
				"       decode(b.bad_st,'1','승인','2','보류','3','기각') bad_st_nm,  \r\n" + 
				"			 decode(b.car_call_yn,'Y','회수','N','미회수','') car_call_yn_nm,  \r\n" + 
				"			 decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \r\n" + 
				"			 a.doc_no, a.user_id1, a.user_id2, a.user_id3, a.user_dt1, a.user_dt2, a.user_dt3, a.user_dt4, \r\n" + 
				"       f1.user_nm as user_nm1, f2.user_nm as user_nm2, f3.user_nm as user_nm3, f4.user_nm as user_nm4,  \r\n" + 
				"			 TRUNC(decode(b.req_dt,'',0, months_between(to_date(nvl(b.id_cng_req_dt,to_char(sysdate,'YYYYMMDD')),'YYYYMMDD'), to_date(b.req_dt,'YYYYMMDD')))) req_mon \r\n" + 
				"FROM   doc_settle a, bad_complaint_req b, client d, users f1, users f2, users f3, users f4, bad_complaint_req_list bb, cont c, car_reg e\r\n" + 
				"WHERE  a.DOC_ST='49' \r\n" + 
				"       AND a.doc_id=b.client_id||b.seq \r\n" + 
				"       AND a.doc_id=bb.bad_comp_cd AND bb.seq='1'\r\n" + 
				"       AND b.client_id=d.client_id\r\n" + 
				"       and a.user_id1=f1.user_id  \r\n" + 
				"			 and a.user_id2=f2.user_id(+) \r\n" + 
				"			 and a.user_id3=f3.user_id(+) \r\n" + 
				"			 and a.user_id4=f4.user_id(+) \r\n" + 
				"       AND bb.rent_mng_id=c.rent_mng_id AND bb.rent_l_cd=c.rent_l_cd \r\n" + 
				"       AND c.car_mng_id=e.car_mng_id  \n"+
				" ";
			
		if(gubun1.equals("1"))			query += " and a.doc_step in ('1','2')";//미결
		else if(gubun1.equals("2"))		query += " and a.doc_step='3'";//결재

		String what = "";
		
		if(s_kd.equals("1")||s_kd.equals(""))	what = "d.firm_nm";
		if(s_kd.equals("2"))	what = "c.rent_l_cd";	
		if(s_kd.equals("3"))	what = "e.car_no";
		if(s_kd.equals("4"))	what = "f1.user_nm";	
		if(s_kd.equals("5"))	what = "replace(to_char(a.user_dt1,'YYYYMMDD'),'-','')";	
		if(s_kd.equals("6"))	what = "replace(to_char(a.user_dt2,'YYYYMMDD'),'-','')";	

			
		if(!what.equals("") && !t_wd.equals("")){
			if(s_kd.equals("2")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}else {
				query += " and "+what+" like '%"+t_wd+"%' ";
			}
		}	
		
		query += " order by b.reg_dt desc";

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
			System.out.println("[DocSettleDatabase:getBadComplaintDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getBadComplaintDocList]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회 - 당월누적거래금액
	public Hashtable getCarPurPayMonCardAmt(String cardno, String trf_st, String pur_est_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT "+
				"        card_kind, "+
				"        SUM(a.amt) t_amt, "+
				"        DECODE(card_kind,'삼성카드',SUM(a.amt),'신한카드',SUM(a.amt),SUM(DECODE(b.reqseq,'',0,amt))) amt1, "+	//기결재
				"        DECODE(card_kind,'삼성카드',0,'신한카드',0,SUM(DECODE(b.reqseq,'',amt,0))) amt2 "+				//미결재
				" FROM "+
				"        ( "+
				"          SELECT card_kind, card_pay_dt, SUM(amt) amt "+
				"          FROM   ( "+
				"                   select a.p_cd3, a.rent_mng_id, a.rent_l_cd, a.amt, NVL(a.pay_dt,a.pur_est_dt) pay_dt, c.card_kind, "+
				"                          decode(c.card_kind,'삼성카드',TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD')+4,'YYYYMMDD'), "+ //20151209 당일에서 익일로 변경 NVL(a.pay_dt,a.pur_est_dt) -> 20160217 +2 / 20170712 +2->+4
				"	                                          '신한카드',NVL(a.pay_dt,a.pur_est_dt), "+
				" 		                                      DECODE(c.cardno,  "+
				" 				                                              '4101-2099-9988-5475',TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD')+3,'YYYYMMDD'), "+
				"                                                             '4265-8691-0190-9612',TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD')+1,'YYYYMMDD'), "+
				"                                                             '9490-2200-0201-3706',TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD')+decode(TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), "+
				"                                                             '9490-2200-0201-3904',TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD')+decode(TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), "+
				"                                                             '9490-2200-0201-3805',TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD')+decode(TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), "+
				" 				                                              '9530-0128-0890-0679',TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD')+3,'YYYYMMDD'), "+
				" 				                                              '9530-0181-3014-3557',TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD')+3,'YYYYMMDD'), "+
				" 				                                              '5535-3109-0001-4982',TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD')+3,'YYYYMMDD'), "+				
				" 				                                              '5535-3109-0005-0853',TO_CHAR(TO_DATE(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD')+3,'YYYYMMDD'), "+				
				" 	  		            		                              decode(sign(c.use_e_day-substr(NVL(a.pay_dt,a.pur_est_dt),7,2)),-1,to_char(add_months(to_date(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD'),2),'YYYYMM')||decode(length(c.pay_day),1,'0','')||c.pay_day,   "+
				"                                		                                                                                         to_char(add_months(to_date(NVL(a.pay_dt,a.pur_est_dt),'YYYYMMDD'),1),'YYYYMM')||decode(length(c.pay_day),1,'0','')||c.pay_day    "+
				"                                                             )  "+
				"                                             ) "+
				"                          ) card_pay_dt "+
				"                   from "+
				"                           ( "+
				"                             select '1' p_st1, '1' p_cd3, rent_mng_id, rent_l_cd, trf_pay_dt1 AS pay_dt, pur_est_dt, trf_amt1 as amt from car_pur where cardno1='"+cardno+"' and decode(trf_st1,'2','선불','3','후불','5','포인트','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) like substr('"+pur_est_dt+"',1,6)||'%' and nvl(pur_pay_dt,pur_est_dt) <= '"+pur_est_dt+"' "+
				"                             union all "+
				"                             select '1' p_st1, '2' p_cd3, rent_mng_id, rent_l_cd, trf_pay_dt2 AS pay_dt, pur_est_dt, trf_amt2 as amt from car_pur where cardno2='"+cardno+"' and decode(trf_st2,'2','선불','3','후불','5','포인트','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) like substr('"+pur_est_dt+"',1,6)||'%' and nvl(pur_pay_dt,pur_est_dt) <= '"+pur_est_dt+"' "+
				"                             union all "+
				"                             select '1' p_st1, '3' p_cd3, rent_mng_id, rent_l_cd, trf_pay_dt3 AS pay_dt, pur_est_dt, trf_amt3 as amt from car_pur where cardno3='"+cardno+"' and decode(trf_st3,'2','선불','3','후불','5','포인트','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) like substr('"+pur_est_dt+"',1,6)||'%' and nvl(pur_pay_dt,pur_est_dt) <= '"+pur_est_dt+"' "+
				"                             union all "+
				"                             select '1' p_st1, '4' p_cd3, rent_mng_id, rent_l_cd, trf_pay_dt4 AS pay_dt, pur_est_dt, trf_amt4 as amt from car_pur where cardno4='"+cardno+"' and decode(trf_st4,'2','선불','3','후불','5','포인트','7','카드할부')='"+trf_st+"' and nvl(pur_pay_dt,pur_est_dt) like substr('"+pur_est_dt+"',1,6)||'%' and nvl(pur_pay_dt,pur_est_dt) <= '"+pur_est_dt+"' "+
				"                           ) a, "+
				"                           (SELECT * FROM CARD WHERE cardno='"+cardno+"') c "+
				"                 )  "+
				"          GROUP BY card_kind, card_pay_dt "+
				"        ) a,  "+
				" 	     (SELECT * FROM PAY_ITEM WHERE p_st1='44' AND p_cd2='"+cardno+"') b "+
				" WHERE  a.card_pay_dt=b.p_cd1(+) "+
				" GROUP BY a.card_kind "+
				"   ";

		
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
			System.out.println("[DocSettleDatabase:getCarPurPayMonCardAmt]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayMonCardAmt]\n"+query);
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

	public boolean insertDocSettleVar(DocSettleBean doc)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt2 = null;
		String query =  " insert into doc_settle_var "+
						" ( doc_no, seq, etc,"+
						"   var01, var02, var03, var04, var05, var06, var07, var08, var09, var10, "+
						"   var11, var12, var13, var14, var15, var16, var17, var18, var19, var20, "+
						"   var21, var22, var23, var24, var25, var26, var27, var28, var29, var30  "+
						" ) values "+
						" ( ?, ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  "+
						" )";

		try
		{
			conn.setAutoCommit(false);
			
			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1,  doc.getDoc_no());
			pstmt2.setInt   (2,  doc.getSeq());
			pstmt2.setString(3,  doc.getEtc());
			pstmt2.setString(4,  doc.getVar01());
			pstmt2.setString(5,  doc.getVar02());
			pstmt2.setString(6,  doc.getVar03());
			pstmt2.setString(7,  doc.getVar04());
			pstmt2.setString(8,  doc.getVar05());
			pstmt2.setString(9,  doc.getVar06());
			pstmt2.setString(10, doc.getVar07());
			pstmt2.setString(11, doc.getVar08());
			pstmt2.setString(12, doc.getVar09());
			pstmt2.setString(13, doc.getVar10());
			pstmt2.setString(14, doc.getVar11());
			pstmt2.setString(15, doc.getVar12());
			pstmt2.setString(16, doc.getVar13());
			pstmt2.setString(17, doc.getVar14());
			pstmt2.setString(18, doc.getVar15());
			pstmt2.setString(19, doc.getVar16());
			pstmt2.setString(20, doc.getVar17());
			pstmt2.setString(21, doc.getVar18());
			pstmt2.setString(22, doc.getVar19());
			pstmt2.setString(23, doc.getVar20());
			pstmt2.setString(24, doc.getVar21());
			pstmt2.setString(25, doc.getVar22());
			pstmt2.setString(26, doc.getVar23());
			pstmt2.setString(27, doc.getVar24());
			pstmt2.setString(28, doc.getVar25());
			pstmt2.setString(29, doc.getVar26());
			pstmt2.setString(30, doc.getVar27());
			pstmt2.setString(31, doc.getVar28());
			pstmt2.setString(32, doc.getVar29());
			pstmt2.setString(33, doc.getVar30());

			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[DocSettleDatabase:insertDocSettleVar]\n"+e);
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

	//스케줄생성요청문서관리
	public Vector getFeeScdDocList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.*, c.rent_mng_id, c.rent_l_cd, d.firm_nm, e.car_no, e.car_nm, (g.fee_s_amt+g.fee_v_amt) as fee_amt, (g.fee_s_amt+g.fee_v_amt-g.inv_s_amt-g.inv_v_amt) as cha_amt, nvl(g.dc_ra,0) dc_ra, g.fee_pay_tm, \n"+
				"        decode(b.var01,'1','납입일자정상','2','납입일자변경','3','업무협조') reg_type,  \n"+
				"        decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        a.doc_no, to_char(a.user_dt1,'YYYYMMDD') as reg_dt, a.user_id1, a.user_id2, a.user_id3, a.user_dt1, a.user_dt2, a.user_dt3,  \n"+
				"        f1.user_nm as user_nm1, f2.user_nm as user_nm2, f3.user_nm as user_nm3  \n"+
				" from   doc_settle a, doc_settle_var b, cont c, client d, car_reg e, users f1, users f2, users f3, fee g, branch h  \n"+
				" where  a.doc_st='16' \n"+ //and to_char(a.user_dt1,'YYYYMMDD')>'20141130' 
				" and    a.doc_no=b.doc_no  \n"+
				" and    a.doc_id=c.rent_l_cd  \n"+
				" and    c.client_id=d.client_id  \n"+
				" and    c.car_mng_id=e.car_mng_id  \n"+
				" and    a.user_id1=f1.user_id  \n"+
				" and    a.user_id2=f2.user_id(+)  \n"+
				" and    a.user_id3=f3.user_id(+)  \n"+
                " and    c.rent_mng_id=g.rent_mng_id and c.rent_l_cd=g.rent_l_cd and g.rent_st='1' "+
                " and    f1.br_id=h.br_id "+
				" ";

		String what = "";
		String dt1 = "";
		String dt2 = "";

		dt1 = "to_char(a.user_dt1,'YYYYMM')";
		dt2 = "to_char(a.user_dt1,'YYYYMMDD')";


		if(gubun2.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt1+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
			
		if(gubun1.equals("1"))			query += " and a.doc_step<>'3'";//미결
		else if(gubun1.equals("2"))		query += " and a.doc_step='3'";//결재


		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(c.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(f1.user_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(h.br_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(f2.user_nm, ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by a.doc_step, a.user_dt1";

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
			System.out.println("[DocSettleDatabase:getFeeScdDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getFeeScdDocList]\n"+query);
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

	//한건 조회
	public DocSettleBean getDocSettleVar(String doc_no, int seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DocSettleBean bean = new DocSettleBean();
		String query = "";
		query = " select doc_no, seq, etc, "+
				"        var01, var02, var03, var04, var05, var06, var07, var08, var09, var10, "+
				"        var11, var12, var13, var14, var15, var16, var17, var18, var19, var20, "+
				"        var21, var22, var23, var24, var25, var26, var27, var28, var29, var30  "+
				" from   doc_settle_var where doc_no = ? and seq = ?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, doc_no);
			pstmt.setInt   (2, seq);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setDoc_no		(rs.getString("doc_no")==null?"":rs.getString("doc_no"));
			    bean.setSeq			(rs.getString("seq")==null?0 :Integer.parseInt(rs.getString("seq")));
				bean.setEtc			(rs.getString("etc")==null?"":rs.getString("etc"));
				bean.setVar01		(rs.getString("var01")==null?"":rs.getString("var01"));	
				bean.setVar02		(rs.getString("var02")==null?"":rs.getString("var02"));
				bean.setVar03		(rs.getString("var03")==null?"":rs.getString("var03"));
				bean.setVar04		(rs.getString("var04")==null?"":rs.getString("var04"));	
				bean.setVar05		(rs.getString("var05")==null?"":rs.getString("var05"));
				bean.setVar06		(rs.getString("var06")==null?"":rs.getString("var06"));
				bean.setVar07		(rs.getString("var07")==null?"":rs.getString("var07"));	
				bean.setVar08		(rs.getString("var08")==null?"":rs.getString("var08"));
				bean.setVar09		(rs.getString("var09")==null?"":rs.getString("var09"));
				bean.setVar10		(rs.getString("var10")==null?"":rs.getString("var10"));
				bean.setVar11		(rs.getString("var11")==null?"":rs.getString("var11"));	
				bean.setVar12		(rs.getString("var12")==null?"":rs.getString("var12"));
				bean.setVar13		(rs.getString("var13")==null?"":rs.getString("var13"));
				bean.setVar14		(rs.getString("var14")==null?"":rs.getString("var14"));	
				bean.setVar15		(rs.getString("var15")==null?"":rs.getString("var15"));
				bean.setVar16		(rs.getString("var16")==null?"":rs.getString("var16"));
				bean.setVar17		(rs.getString("var17")==null?"":rs.getString("var17"));	
				bean.setVar18		(rs.getString("var18")==null?"":rs.getString("var18"));
				bean.setVar19		(rs.getString("var19")==null?"":rs.getString("var19"));
				bean.setVar20		(rs.getString("var20")==null?"":rs.getString("var20"));
				bean.setVar21		(rs.getString("var21")==null?"":rs.getString("var21"));	
				bean.setVar22		(rs.getString("var22")==null?"":rs.getString("var22"));
				bean.setVar23		(rs.getString("var23")==null?"":rs.getString("var23"));
				bean.setVar24		(rs.getString("var24")==null?"":rs.getString("var24"));	
				bean.setVar25		(rs.getString("var25")==null?"":rs.getString("var25"));
				bean.setVar26		(rs.getString("var26")==null?"":rs.getString("var26"));
				bean.setVar27		(rs.getString("var27")==null?"":rs.getString("var27"));	
				bean.setVar28		(rs.getString("var28")==null?"":rs.getString("var28"));
				bean.setVar29		(rs.getString("var29")==null?"":rs.getString("var29"));
				bean.setVar30		(rs.getString("var30")==null?"":rs.getString("var30"));
									
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[DocSettleDatabase:getDocSettleVar]\n"+e);
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

	public boolean updateDocSettleVarScdFeeDoc(DocSettleBean doc)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt2 = null;

		String query = " update doc_settle_var set etc=?, var19=?, var20=?, var21=?, var22=?  where doc_no=? and seq=? ";

		try
		{
			conn.setAutoCommit(false);
			
			pstmt2 = conn.prepareStatement(query);

			pstmt2.setString(1,  doc.getEtc());
			pstmt2.setString(2,  doc.getVar19());
			pstmt2.setString(3,  doc.getVar20());
			pstmt2.setString(4,  doc.getVar21());
			pstmt2.setString(5,  doc.getVar22());
			pstmt2.setString(6,  doc.getDoc_no());
			pstmt2.setInt   (7,  doc.getSeq());

			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[DocSettleDatabase:updateDocSettleVarScdFeeDoc]\n"+e);
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
	
	public boolean updateDocSettleVar(DocSettleBean doc)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt2 = null;

		String query = " update doc_settle_var set etc=?, var01=?, var02=?, var03=?, var04=?, var05=?, var06=?, var07=?, var08=?, var09=?  where doc_no=? and seq=? ";

		try
		{
			conn.setAutoCommit(false);
			
			pstmt2 = conn.prepareStatement(query);

			pstmt2.setString(1,  doc.getEtc());
			pstmt2.setString(2,  doc.getVar01());
			pstmt2.setString(3,  doc.getVar02());
			pstmt2.setString(4,  doc.getVar03());
			pstmt2.setString(5,  doc.getVar04());
			pstmt2.setString(6,  doc.getVar05());
			pstmt2.setString(7,  doc.getVar06());
			pstmt2.setString(8,  doc.getVar07());
			pstmt2.setString(9,  doc.getVar08());
			pstmt2.setString(10, doc.getVar09());
			pstmt2.setString(11, doc.getDoc_no());
			pstmt2.setInt   (12, doc.getSeq());

			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[DocSettleDatabase:updateDocSettleVar]\n"+e);
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

	//출고문서처리관리 리스트 조회 - agent
	public Vector getCarPurDocListA(String s_kd, String t_wd, String gubun1, String gubun3, String gubun4, String st_dt, String end_dt, String ck_acar_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		if(gubun1.equals("0")) {
			query = " select  "+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id,"+
					"        a.dlv_dt, a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt,"+
					"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, "+
					"        p.rpt_no, p.dlv_con_dt, p.dlv_est_dt, p.con_amt, p.pur_pay_dt, "+
					"        h.commi, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, pc.nm as car_comp_nm, i.user_nm as bus_nm, h.emp_id, j.emp_nm, k.car_off_nm,"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
					"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2,"+
					"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st,"+
					"        nvl(h2.pic_cnt2,0) scan_cnt, nvl(h2.scan_doc_cnt,0) scan_doc_cnt, nvl(h2.scan_doc_cnt2,0) scan_15_cnt, l.*, '' s_user_dt1, "+
					"        decode(l.doc_step,'1','기안','2','결재','3','완료','대기') bit, r.car_nm, p.con_est_dt, g.pp_pay_dt,"+
					"        decode(p.one_self,'Y','자체출고') one_self, decode(a.rent_st,'3','대차') cont_rent_st_nm, "+
					"        p.pur_pay_dt, p.jan_amt as car_est_amt, "+
					"        TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.rent_dt,'YYYYMMDD'))) delay_mon, p.delay_cont, p.dir_pur_yn, p.off_nm, p.cons_st, p.dlv_ext, "+
					"        decode(p.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점','') udt_st \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, car_pur p,"+
					"        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) pp_pay_dt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(decode(ext_pay_dt,'',0,ext_pay_amt)) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(decode(ext_pay_dt,'',0,ext_pay_amt)) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g,"+
					"        (select rent_mng_id, rent_l_cd, emp_id, commi, sup_dt, comm_r_rt, req_dt from commi where agnt_st='2' and emp_id is not null) h,"+
					"        users i, car_off_emp j, car_off k, (select code, nm from code where c_st='0001' and code<>'0000') pc,"+
					"        (select * from doc_settle where doc_st='4') l, users o,"+
					"        car_nm q, car_mng r,"+
					"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5')) s, "+
					"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, "+
					"                COUNT(DECODE(SUBSTR(content_seq,20),'11',0,'117',0,'118',0)) scan_doc_cnt, "+
					"			     COUNT(DECODE(SUBSTR(content_seq,20),'115',0)) scan_doc_cnt2 "+
					"	      from ACAR_ATTACH_FILE where content_code='LC_SCAN' AND isdeleted='N' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h2 "+
					" where  a.bus_id='"+ck_acar_id+"' and a.car_st<>'2' and a.car_gu='1' and a.car_mng_id is null and nvl(a.use_yn,'Y')='Y' "+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
					"        and a.client_id=c.client_id"+
					"        and a.car_mng_id=d.car_mng_id(+)"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
					"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+) "+
					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd"+
					"        and h.emp_id=j.emp_id"+
					"        and j.car_off_id=k.car_off_id"+
					"        and k.car_comp_id=pc.code"+
					"        and a.rent_l_cd=l.doc_id(+) and l.doc_no is null "+
					"        and a.bus_id=o.user_id"+
					"        and l.user_id1=i.user_id(+)"+
					"        and e.car_id=q.car_id and e.car_seq=q.car_seq and q.car_comp_id=r.car_comp_id and q.car_cd=r.code"+
					"        and a.rent_mng_id=s.rent_mng_id(+) and a.reg_dt=s.reg_dt(+) and s.rent_l_cd is null"+
					"        and h.emp_id is not null "+
					"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+)"+
					" ";
			
		}else if(gubun1.equals("1")) {
			query = " select  "+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id,"+
					"        a.dlv_dt, a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt,"+
					"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, "+
					"        p.rpt_no, p.dlv_con_dt, p.dlv_est_dt, p.con_amt, p.pur_pay_dt, "+
					"        h.commi, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, pc.nm as car_comp_nm, i.user_nm as bus_nm, h.emp_id, j.emp_nm, k.car_off_nm,"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
					"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2,"+
					"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st,"+
					"        nvl(h2.pic_cnt2,0) scan_cnt, nvl(h2.scan_doc_cnt,0) scan_doc_cnt, nvl(h2.scan_doc_cnt2,0) scan_15_cnt, l.*, to_char(l.user_dt1,'YYYYMMDD') s_user_dt1, "+
					"        decode(l.doc_step,'1','기안','2','결재','3','완료','대기') bit, r.car_nm, p.con_est_dt, g.pp_pay_dt,"+
					"        decode(p.one_self,'Y','자체출고') one_self, decode(a.rent_st,'3','대차') cont_rent_st_nm, "+
					"        p.pur_pay_dt, p.jan_amt as car_est_amt, "+
					"        TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.rent_dt,'YYYYMMDD'))) delay_mon, p.delay_cont, p.dir_pur_yn, p.off_nm, p.cons_st, p.dlv_ext, "+
					"        decode(p.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점','') udt_st \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, car_pur p,"+
					"        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) pp_pay_dt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(decode(ext_pay_dt,'',0,ext_pay_amt)) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(decode(ext_pay_dt,'',0,ext_pay_amt)) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g,"+
					"        (select rent_mng_id, rent_l_cd, emp_id, commi, sup_dt, comm_r_rt, req_dt from commi where agnt_st='2' and emp_id is not null) h,"+
					"        users i, car_off_emp j, car_off k, (select code, nm from code where c_st='0001' and code<>'0000') pc,"+
					"        (select * from doc_settle where doc_st='4') l, users o,"+
					"        car_nm q, car_mng r,"+
					"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5')) s, "+
					"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, "+
					"                COUNT(DECODE(SUBSTR(content_seq,20),'11',0,'117',0,'118',0)) scan_doc_cnt, "+
					"			     COUNT(DECODE(SUBSTR(content_seq,20),'115',0)) scan_doc_cnt2 "+
					"	      from ACAR_ATTACH_FILE where content_code='LC_SCAN' AND isdeleted='N' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h2 "+
					" where  a.bus_id='"+ck_acar_id+"' and a.car_st<>'2' and a.car_gu='1' and a.car_mng_id is null and nvl(a.use_yn,'Y')='Y' "+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
					"        and a.client_id=c.client_id"+
					"        and a.car_mng_id=d.car_mng_id(+)"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
					"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+) "+
					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd"+
					"        and h.emp_id=j.emp_id"+
					"        and j.car_off_id=k.car_off_id"+
					"        and k.car_comp_id=pc.code"+
					"        and a.rent_l_cd=l.doc_id"+
					"        and a.bus_id=o.user_id"+
					"        and l.user_id1=i.user_id"+
					"        and e.car_id=q.car_id and e.car_seq=q.car_seq and q.car_comp_id=r.car_comp_id and q.car_cd=r.code"+
					"        and a.rent_mng_id=s.rent_mng_id(+) and a.reg_dt=s.reg_dt(+) and s.rent_l_cd is null"+
					"        and h.emp_id is not null "+
					"        and l.doc_step<>'3' "+
					"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+)"+
					" ";
		}else {
			query = " select  "+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id,"+
					"        a.dlv_dt, a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt,"+
					//"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, g.pp_pay_dt, "+
					"        p.rpt_no, p.dlv_con_dt, p.dlv_est_dt, p.con_amt, p.pur_pay_dt, "+
					"        h.commi, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, pc.nm as car_comp_nm, i.user_nm as bus_nm, h.emp_id, j.emp_nm, k.car_off_nm,"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
					//"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2,"+
					//"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st,"+
					//"        nvl(h2.pic_cnt2,0) scan_cnt, nvl(h2.scan_doc_cnt,0) scan_doc_cnt, nvl(h2.scan_doc_cnt2,0) scan_15_cnt, "+
					"        l.*, to_char(l.user_dt1,'YYYYMMDD') s_user_dt1, "+
					"        decode(l.doc_step,'1','기안','2','결재','3','완료','대기') bit, r.car_nm, p.con_est_dt, "+
					"        decode(p.one_self,'Y','자체출고') one_self, decode(a.rent_st,'3','대차') cont_rent_st_nm, "+
					"        p.pur_pay_dt, p.jan_amt as car_est_amt, "+
					"        TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.rent_dt,'YYYYMMDD'))) delay_mon, p.delay_cont, p.dir_pur_yn, p.off_nm, p.cons_st, p.dlv_ext, "+
					"        decode(p.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점','') udt_st \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, car_pur p,"+ //gua_ins f, 
					//"        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) pp_pay_dt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(decode(ext_pay_dt,'',0,ext_pay_amt)) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(decode(ext_pay_dt,'',0,ext_pay_amt)) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g,"+
					"        (select rent_mng_id, rent_l_cd, emp_id, commi, sup_dt, comm_r_rt, req_dt from commi where agnt_st='2' and emp_id is not null) h,"+
					"        users i, car_off_emp j, car_off k, (select code, nm from code where c_st='0001' and code<>'0000') pc,"+
					"        (select * from doc_settle where doc_st='4') l, users o,"+
					"        car_nm q, car_mng r,"+
					"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5') and rent_l_cd not in ('D114HHGR00233')) s "+
					//"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, "+
					//"                COUNT(DECODE(SUBSTR(content_seq,20),'11',0,'117',0,'118',0)) scan_doc_cnt, "+
					//"			     COUNT(DECODE(SUBSTR(content_seq,20),'115',0)) scan_doc_cnt2 "+
					//"	      from ACAR_ATTACH_FILE where content_code='LC_SCAN' AND isdeleted='N' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h2 "+
					" where  a.bus_id='"+ck_acar_id+"' and a.car_st<>'2' and a.car_gu='1' "+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
					"        and a.client_id=c.client_id"+
					"        and a.car_mng_id=d.car_mng_id(+)"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
					//"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+) "+
					//"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd"+
					"        and h.emp_id=j.emp_id"+
					"        and j.car_off_id=k.car_off_id"+
					"        and k.car_comp_id=pc.code"+
					"        and a.rent_l_cd=l.doc_id"+
					"        and a.bus_id=o.user_id"+
					"        and l.user_id1=i.user_id"+
					"        and e.car_id=q.car_id and e.car_seq=q.car_seq and q.car_comp_id=r.car_comp_id and q.car_cd=r.code"+
					"        and a.rent_mng_id=s.rent_mng_id(+) and a.reg_dt=s.reg_dt(+) and s.rent_l_cd is null"+
					"        and l.doc_step='3' "+
					//"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+)"+
					" ";
			
			String what = "";
			String dt1 = "";
			String dt2 = "";

			dt1 = "to_char(l.user_dt5,'YYYYMM')";
			dt2 = "to_char(l.user_dt5,'YYYYMMDD')";

			if(gubun4.equals("1"))			query += " and "+dt1+" = to_char(sysdate,'YYYYMM')";
			else if(gubun4.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			else if(gubun4.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
			else if(gubun4.equals("5"))		query += " and "+dt1+" = to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')";
			else if(gubun4.equals("2")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}
		}
/*
		query = " select  "+
				"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id,"+
				"        a.dlv_dt, a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt,"+
				"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, "+
				"        p.rpt_no, p.dlv_con_dt, p.dlv_est_dt, p.con_amt, p.pur_pay_dt, "+
				"        h.commi, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, pc.nm as car_comp_nm, i.user_nm as bus_nm, h.emp_id, j.emp_nm, k.car_off_nm,"+
				"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
				"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2,"+
				"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st,"+
				"        nvl(h2.pic_cnt2,0) scan_cnt, nvl(h2.scan_doc_cnt,0) scan_doc_cnt, nvl(h2.scan_doc_cnt2,0) scan_15_cnt, l.*, "+
				"        decode(l.doc_step,'1','기안','2','결재','3','완료','대기') bit, r.car_nm, p.con_est_dt, g.pp_pay_dt,"+
				"        decode(p.one_self,'Y','자체출고') one_self, decode(a.rent_st,'3','대차') cont_rent_st_nm, "+
				"        p.pur_pay_dt, p.jan_amt as car_est_amt, "+
				"        TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.rent_dt,'YYYYMMDD'))) delay_mon, p.delay_cont, p.dir_pur_yn, p.off_nm, p.cons_st, p.dlv_ext, "+
				"        decode(p.udt_st,'1','서울본사','2','부산지점','3','대전지점','4','고객','5','대구지점','6','광주지점','') udt_st \n"+
				" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, car_pur p,"+
				"        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) pp_pay_dt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(decode(ext_pay_dt,'',0,ext_pay_amt)) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(decode(ext_pay_dt,'',0,ext_pay_amt)) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g,"+
				"        (select rent_mng_id, rent_l_cd, emp_id, commi, sup_dt, comm_r_rt, req_dt from commi where agnt_st='2' and emp_id is not null) h,"+
				"        users i, car_off_emp j, car_off k, (select code, nm from code where c_st='0001' and code<>'0000') pc,"+
				"        (select * from doc_settle where doc_st='4') l, users o,"+
				"        car_nm q, car_mng r,"+
				"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5') and rent_l_cd not in ('D114HHGR00233')) s, "+
				"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, "+
				"                COUNT(DECODE(SUBSTR(content_seq,20),'11',0,'117',0,'118',0)) scan_doc_cnt, "+
				"			     COUNT(DECODE(SUBSTR(content_seq,20),'115',0)) scan_doc_cnt2 "+
				"	      from ACAR_ATTACH_FILE where content_code='LC_SCAN' AND isdeleted='N' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h2 "+
				" where  a.bus_id='"+ck_acar_id+"' and a.car_st<>'2' and a.car_gu='1' "+
				"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
				"        and a.client_id=c.client_id"+
				"        and a.car_mng_id=d.car_mng_id(+)"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+) "+
				"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd"+
				"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd"+
				"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd"+
				"        and h.emp_id=j.emp_id"+
				"        and j.car_off_id=k.car_off_id"+
				"        and k.car_comp_id=pc.code"+
				"        and a.rent_l_cd=l.doc_id(+)"+
				"        and a.bus_id=o.user_id"+
				"        and l.user_id1=i.user_id(+)"+
				"        and e.car_id=q.car_id and e.car_seq=q.car_seq and q.car_comp_id=r.car_comp_id and q.car_cd=r.code"+
				"        and a.rent_mng_id=s.rent_mng_id(+) and a.reg_dt=s.reg_dt(+) and s.rent_l_cd is null"+
				"        and nvl(a.dlv_dt,'99999999') >= '20080707' "+
				"        and a.rent_l_cd not in ('B108HTLR00156','B108HTLR00157','B108HRTR00216','B108SS7L00019','S113KK5R00671') "+
				"        and decode(q.car_comp_id,'0001','0001',h.emp_id) is not null "+
				"        and decode(l.doc_step,'3','Y',nvl(a.use_yn,'Y'))='Y' "+
				"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+)"+
				" ";
*/
		
		//if(gubun1.equals("1"))			query += " and (l.doc_step is null or l.doc_step<>'3')";//미결
		//else if(gubun1.equals("2"))		query += " and l.doc_step='3'";//결재

		String what = "";

		if(s_kd.equals("1"))	what = "upper(c.firm_nm)";
		if(s_kd.equals("2"))	what = "a.rent_l_cd";	
		if(s_kd.equals("3"))	what = "d.car_no";
		if(s_kd.equals("4"))	what = "o.user_nm";	
		if(s_kd.equals("5"))	what = "j.emp_nm";	
		if(s_kd.equals("6"))	what = "a.rent_dt";	
		if(s_kd.equals("7"))	what = "r.car_nm";	
		if(s_kd.equals("8"))	what = "o.user_nm";	
		if(s_kd.equals("9"))	what = "to_char(l.user_dt1,'YYYYMMDD')";	
		if(s_kd.equals("10"))	what = "to_char(l.user_dt5,'YYYYMMDD')";	
		if(s_kd.equals("11"))	what = "p.dlv_brch";	
		if(s_kd.equals("12"))	what = "upper(p.rpt_no)";	
		if(s_kd.equals("13"))	what = "pc.nm";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1") || s_kd.equals("12"))			query += " and "+what+" like upper('%"+t_wd+"%') ";
			else 												query += " and "+what+" like '%"+t_wd+"%' ";
		}else{

		}	
		
		query += " order by p.con_est_dt, l.doc_step desc,  a.rent_dt, b.rent_start_dt, a.rent_mng_id";


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
			System.out.println("[DocSettleDatabase:getCarPurDocListgetCarPurDocList(String s_kd, String t_wd, String gubun1, String ck_acar_id)]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurDocListgetCarPurDocList(String s_kd, String t_wd, String gubun1, String ck_acar_id)]\n"+query);
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


	//해지정산처리관리 리스트 조회 - chk:1:계약해지  2:매입옵션 -   에이전트는 출고전해지만 조회가능
	public Vector getClsDocList(String s_kd, String t_wd, String gubun1, String andor, String chk, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  b.term_yn, \n"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, b.cls_dt,\n"+
				" a.rent_dt, c.firm_nm, cr.car_no, cr.car_nm, a.rent_start_dt, \n"+
				" decode(i.dept_id,'0007','부산','0008','대전','') dept_nm, i.user_nm as bus_nm, \n"+
				" decode(a.use_yn,'Y','진행','N','해지','미결') use_st, b.cls_st, \n"+
				" decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)', '') cls_st_nm, \n"+
				" nvl(b.autodoc_yn, 'N') autodoc_yn , \n"+
				" decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit,"+
				" l.doc_no, l.doc_step, l.user_id1, l.user_id2, l.user_id3, l.user_id4, l.user_id5, l.user_dt1, l.user_dt2, l.user_dt3, l.user_dt4, l.user_dt5  \n"+
				" from  cls_etc b, cont_n_view a, client c, users i, users df, car_reg cr ,  \n"+
				" (select * from doc_settle where doc_st='11') l \n"+
				" where a.car_st<>'2'   \n"+
				" and b.rent_mng_id=a.RENT_MNG_ID and b.rent_l_cd=a.rent_l_cd \n"+
			   " and a.client_id = c.client_id and a.car_mng_id = cr.car_mng_id(+) \n"+
				" and a.rent_l_cd=l.doc_id(+) \n"+
				" and l.user_id1=i.user_id(+) \n"+
				" and b.dft_saction_id=df.user_id(+) ";

		 if (!user_id.equals(""))  	query += " and  a.bus_id = '"+ user_id + "'  \n";
		 		
		if(gubun1.equals("1"))			query += " and l.user_dt5 is null";//미결
		else if(gubun1.equals("2"))		query += " and l.user_dt5 is not null";//결재
	
		if(s_kd.equals("1"))	query += " and nvl(c.firm_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and nvl(a.rent_l_cd, ' ') like '%"+t_wd+"%'";	
		if(s_kd.equals("3"))	query += " and nvl(cr.car_no, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("4"))	query += " and nvl(i.user_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("6"))	query += " and b.cls_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		if(s_kd.equals("7"))	query += " and nvl(df.user_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("8"))	query += " and to_char(l.user_dt1, 'yyyymmdd') like '"+t_wd+"%'";
		if(s_kd.equals("9"))	query += " and to_char(l.user_dt5, 'yyyymmdd') like '"+t_wd+"%'";
			 					
		if(s_kd.equals("5") && gubun1.equals("2") ) {
			if ( !t_wd.equals("")) {
				query += " and b.cls_dt like '"+t_wd+"%'";
			} else {
				if ( chk.equals("2") ) {
					query += " and  b.cls_dt like to_char(sysdate, 'yyyy')||'%'" ;
				} else {	
					query += " and  b.cls_dt like to_char(sysdate,'YYYYMM')||'%'" ;
				}	
			}	
		
		}
		if (chk.equals("1"))     query += " and b.cls_st in (  '7' ) ";
		if (chk.equals("2"))     query += " and b.cls_st in ( '8' ) ";
		
		if(andor.equals("1"))	query += " and b.cls_st = '1'";
		if(andor.equals("2"))	query += " and b.cls_st = '2'";	
		if(andor.equals("7"))	query += " and b.cls_st = '7'";	
		if(andor.equals("10"))	query += " and b.cls_st = '10'";	
		if(andor.equals("8"))	query += " and b.cls_st = '8'";
		
			
		query += " order by l.doc_bit, b.cls_dt desc , a.rent_dt, a.rent_start_dt, a.rent_mng_id";

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
			System.out.println("[DocSettleDatabase:getClsDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getClsDocList]\n"+query);
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

	//영업수당문서처리관리 리스트 조회 - agent
	public Vector getCommiDocList(String s_kd, String t_wd, String gubun1, String  user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		//미등록
		if(gubun1.equals("0")){
			
			query = " select  \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id, \n"+
					"        a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, \n"+
					"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, \n"+
					"        h.commi, h.dlv_con_commi, h.dlv_tns_commi, h.agent_commi, 0 as proxy_commi, h.emp_acc_nm, h.sup_dt, h.comm_r_rt, h.req_dt, \n"+
					"        h.emp_id, j.emp_nm, \n"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st, \n"+
					"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2, \n"+
					"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st, \n"+
					"        decode(k.rent_l_cd,'','미생성','생성') scd_yn, nvl(h3.pic_cnt2,0) scan_cnt, l.*, \n"+
					"        '대기' as bit, \n"+
					"        p.one_self, p.pur_bus_st, decode(p.dlv_brch,'법인판촉팀','특','특판팀','특') dlv_brch, '' t_user_dt1 \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, \n"+
					"        (select rent_mng_id, rent_l_cd, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(ext_pay_amt) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(ext_pay_amt) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g, \n"+
					"        (select * from commi where agnt_st='1' and emp_id is not null) h, \n"+					
					"        car_off_emp j, \n"+
					"        (select rent_mng_id, rent_l_cd from scd_fee where tm_st2='0' group by rent_mng_id, rent_l_cd) k,  \n"+
					"        (select * from doc_settle where doc_st='1') l, \n"+
					"        car_pur p, cont_etc r,  \n"+					
					"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, COUNT(DECODE(SUBSTR(content_seq,20),'11',0)) scan_doc_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LC_SCAN' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h3, "+
					"        (select rent_mng_id, rent_l_cd, reg_dt from cls_cont where cls_st in ('4','5') ) y "+
					" where  a.bus_id='"+ user_id + "' and a.car_st<>'2' and a.car_gu='1' and a.bus_st in ('2','7')  \n"+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
					"        and a.client_id=c.client_id \n"+
					"        and a.car_mng_id=d.car_mng_id(+) \n"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
					"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+)  \n"+
					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+					
					"        and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+) \n"+
					"        and h.emp_id=j.emp_id \n"+
					"        and a.rent_l_cd=l.doc_id(+) and l.doc_no is null \n"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd  \n"+
					"        and a.rent_mng_id=r.rent_mng_id and a.rent_l_cd=r.rent_l_cd  \n"+
					"        and a.rent_mng_id=h3.rent_mng_id(+) and a.rent_l_cd=h3.rent_l_cd(+)"+
					"        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) and y.rent_l_cd is null "+ //계약승계,차종변경은 안보여줌
					" ";

			query += " and h.emp_id is not null and h.emp_id <>'000000' and ((r.bus_agnt_id is null and a.bus_st='7') or h.comm_r_rt>0 or p.dir_pur_yn='Y' or (p.one_self='Y' and a.rent_dt > '20130630' ))  \n";/*원래조건*/
			query += " and a.use_yn='Y' and a.rent_dt >= '20071101' \n";
			
		//결재중
		}else if(gubun1.equals("1")){
			query = " select  \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id, \n"+
					"        a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, \n"+
					"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, \n"+
					"        h.commi, h.dlv_con_commi, h.dlv_tns_commi, h.agent_commi, nvl(h2.commi,0) as proxy_commi, h.emp_acc_nm, h.sup_dt, h.comm_r_rt, h.req_dt, \n"+
					"        h.emp_id, j.emp_nm, \n"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st, \n"+
					"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2, \n"+
					"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st, \n"+
					"        decode(k.rent_l_cd,'','미생성','생성') scd_yn, nvl(h3.pic_cnt2,0) scan_cnt, l.*, \n"+
					"        decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit, \n"+
					"        p.one_self, p.pur_bus_st, decode(p.dlv_brch,'법인판촉팀','특','특판팀','특') dlv_brch, to_char(l.user_dt1,'YYYYMMDD') as t_user_dt1 \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, gua_ins f, \n"+
					"        (select rent_mng_id, rent_l_cd, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(ext_pay_amt) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(ext_pay_amt) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g, \n"+
					"        (select * from commi where agnt_st='1' and emp_id is not null) h, \n"+
					"        (select rent_mng_id, rent_l_cd, commi from commi where agnt_st='4' and emp_id is not null) h2, \n"+
					"        car_off_emp j, \n"+
					"        (select rent_mng_id, rent_l_cd from scd_fee where tm_st2='0' group by rent_mng_id, rent_l_cd) k,  \n"+
					"        (select * from doc_settle where doc_st='1') l, users o, \n"+
					"        car_pur p, cont_etc r,  \n"+
					"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, COUNT(DECODE(SUBSTR(content_seq,20),'11',0)) scan_doc_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LC_SCAN' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h3 "+					
					" where  a.bus_id='"+ user_id + "' and a.car_st<>'2' and a.car_gu='1' and a.bus_st in ('2','7')  \n"+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
					"        and a.client_id=c.client_id \n"+
					"        and a.car_mng_id=d.car_mng_id \n"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
					"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+)  \n"+
					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+
					"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+) \n"+
					"        and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+) \n"+
					"        and h.emp_id=j.emp_id \n"+
					"        and a.rent_l_cd=l.doc_id and l.doc_step<>'3' and h.sup_dt is null \n"+
					"        and a.bus_id=o.user_id \n"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd  \n"+					
					"        and a.rent_mng_id=r.rent_mng_id and a.rent_l_cd=r.rent_l_cd  \n"+
					"        and a.rent_mng_id=h3.rent_mng_id(+) and a.rent_l_cd=h3.rent_l_cd(+)"+
					" ";

		//결재완료	
		}else if(gubun1.equals("2")){	
			query = " select  \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id, \n"+
					"        a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt, \n"+
					//"        f.gi_st, f.gi_dt, g.pp_amt, g.pay_amt, g.jan_amt, \n"+
					"        h.commi, h.dlv_con_commi, h.dlv_tns_commi, h.agent_commi, nvl(h2.commi,0) as proxy_commi, h.emp_acc_nm, h.sup_dt, h.comm_r_rt, h.req_dt, \n"+
					"        h.emp_id, j.emp_nm, \n"+
					"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st, \n"+
					//"        decode(f.gi_st,'1',decode(f.gi_dt,'','미가입','가입완료'),'면제') gi_st2, \n"+
					//"        decode(g.pp_amt,0,'면제','','면제',decode(g.pay_amt,0,'미입금',decode(g.jan_amt,0,'입금완료',decode(sign(g.jan_amt),-1,'입금완료','잔액')))) pp_st, \n"+
					//"        decode(k.rent_l_cd,'','미생성','생성') scd_yn, nvl(h3.pic_cnt2,0) scan_cnt, "+
					"        l.*, \n"+
					"        decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit, \n"+
					"        p.one_self, p.pur_bus_st, decode(p.dlv_brch,'법인판촉팀','특','특판팀','특') dlv_brch, to_char(l.user_dt1,'YYYYMMDD') as t_user_dt1 \n"+
					" from   cont a, fee b, client c, car_reg d, car_etc e, "+
//					"        gua_ins f, \n"+
//					"        (select rent_mng_id, rent_l_cd, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0)) pp_amt, sum(ext_pay_amt) pay_amt, sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt,0))-sum(ext_pay_amt) jan_amt from scd_ext where rent_st='1' and ext_st in ('0','1','2') group by rent_mng_id, rent_l_cd) g, \n"+
					"        (select * from commi where agnt_st='1' and emp_id is not null) h, \n"+
					"        (select rent_mng_id, rent_l_cd, commi from commi where agnt_st='4' and emp_id is not null) h2, \n"+
					"        car_off_emp j, \n"+
//					"        (select rent_mng_id, rent_l_cd from scd_fee where tm_st2='0' group by rent_mng_id, rent_l_cd) k,  \n"+
					"        (select * from doc_settle where doc_st='1') l, users o, \n"+
					"        car_pur p, cont_etc r  \n"+					
//					"        (select SUBSTR(content_seq,1,6) rent_mng_id, SUBSTR(content_seq,7,13) rent_l_cd, count(0) pic_cnt2, COUNT(DECODE(SUBSTR(content_seq,20),'11',0)) scan_doc_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='LC_SCAN' group by SUBSTR(content_seq,1,6), SUBSTR(content_seq,7,13)) h3 "+					
					" where  a.bus_id='"+ user_id + "' and a.car_st<>'2' and a.car_gu='1' and a.bus_st in ('2','7')  \n"+
					"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
					"        and a.client_id=c.client_id \n"+
					"        and a.car_mng_id=d.car_mng_id \n"+
					"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
//					"        and b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) and b.rent_st=f.rent_st(+)  \n"+
//					"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+
					"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+) \n"+
//					"        and a.rent_mng_id=k.rent_mng_id(+) and a.rent_l_cd=k.rent_l_cd(+) \n"+
					"        and h.emp_id=j.emp_id \n"+
					"        and a.rent_l_cd=l.doc_id and l.doc_step='3' \n"+
					"        and a.bus_id=o.user_id \n"+
					"        and a.rent_mng_id=p.rent_mng_id and a.rent_l_cd=p.rent_l_cd  \n"+					
					"        and a.rent_mng_id=r.rent_mng_id and a.rent_l_cd=r.rent_l_cd  \n"+
//					"        and a.rent_mng_id=h3.rent_mng_id(+) and a.rent_l_cd=h3.rent_l_cd(+)"+
					" ";

		}

		String what = "";

		if(s_kd.equals("1"))	what = "upper(c.firm_nm)";
		if(s_kd.equals("2"))	what = "a.rent_l_cd";	
		if(s_kd.equals("3"))	what = "d.car_no";	
		if(s_kd.equals("5"))	what = "j.emp_nm";	
		if(s_kd.equals("6"))	what = "h.emp_acc_nm";	
		
		
		if(s_kd.equals("7") && !gubun1.equals("0"))	what = "to_char(l.user_dt1,'YYYYMMDD')";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){
				query += " and "+what+" like upper('%"+t_wd+"%')  \n";
			}else if(s_kd.equals("8") && !gubun1.equals("0")){
				query += " and (to_char(l.user_dt7,'YYYYMMDD') like '%"+t_wd+"%' OR to_char(l.user_dt8,'YYYYMMDD') like '%"+t_wd+"%') \n";
			}else{
				if(!what.equals(""))	query += " and "+what+" like '%"+t_wd+"%'  \n";
			}
		}else{

		}	
		
		if(gubun1.equals("0")){
			query += " order by b.rent_start_dt";
		}else if(gubun1.equals("1")){
			query += " order by l.doc_bit, b.rent_start_dt";
		}else if(gubun1.equals("2")){
			query += " order by l.user_dt1 desc, b.rent_start_dt";
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
			System.out.println("[DocSettleDatabase:getCommiDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getCommiDocList]\n"+query);
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

	
	//보증보험 리스트 조회 - chk:1:계약해지  2:매입옵션, 3:월렌트 - 93:보증보험  
	public Vector getClsGurDocList(String s_kd, String t_wd, String gubun1, String andor, String chk)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \n"+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, b.req_dt, d.cls_dt, d.cls_st,\n"+
				" a.rent_dt, a.firm_nm, c.car_no, c.car_nm, a.rent_start_dt, \n"+
				" i.user_nm as bus_nm, b.req_amt,  g.gi_amt, \n"+
				" decode(a.use_yn,'Y','진행','N','해지','미결') use_st, \n"+
				" decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit,"+
				" l.doc_no, l.doc_step, l.user_id1, l.user_id2, l.user_dt1, l.user_dt2 \n"+
				" from cont_n_view a, cls_guar b, users i,  car_reg c,  cls_cont d , gua_ins g, \n"+
				" (select * from doc_settle where doc_st='93') l \n"+
				" where a.car_st<>'2' \n"+
				" and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd \n"+
				" and a.rent_mng_id=d.RENT_MNG_ID and a.rent_l_cd=d.rent_l_cd \n"+
				" and a.rent_mng_id=g.RENT_MNG_ID and a.rent_l_cd=g.rent_l_cd  and a.fee_rent_st = g.rent_st \n"+
				" and  a.car_mng_id = c.car_mng_id(+) "+ 
				" and a.rent_l_cd=l.doc_id(+) \n"+
				" and l.user_id1=i.user_id(+)  ";

						
		if(gubun1.equals("1"))			query += " and l.user_dt2 is null";//미결
		else if(gubun1.equals("2"))		query += " and l.user_dt2 is not null";//결재
	
		if(s_kd.equals("1"))	query += " and nvl(a.firm_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and nvl(a.rent_l_cd, ' ') like '%"+t_wd+"%'";	
		if(s_kd.equals("3"))	query += " and nvl(c.car_no, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("4"))	query += " and nvl(i.user_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("8"))	query += " and to_char(l.user_dt1, 'yyyymmdd') like '"+t_wd+"%'";
		if(s_kd.equals("9"))	query += " and to_char(l.user_dt2, 'yyyymmdd') like '"+t_wd+"%'";
			 					
		if(s_kd.equals("5") && gubun1.equals("2") ) {
			if ( !t_wd.equals("")) {
				query += " and b.req_dt like '"+t_wd+"%'";
			} else {
				if ( chk.equals("2") ) {
					query += " and  b.req_dt like to_char(sysdate, 'yyyy')||'%'" ;
				} else {	
					query += " and  b.req_dt like to_char(sysdate,'YYYYMM')||'%'" ;
				}	
			}	
		
		}
				
		query += " order by l.doc_bit, b.req_dt desc , a.rent_dt, a.rent_start_dt, a.rent_mng_id";

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
			System.out.println("[DocSettleDatabase:getClsGurDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getClsGurDocList]\n"+query);
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

	public boolean deleteDocSettleLcStart(String doc_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query1 = "";
		String query2 = "";
		String query3 = "";

		query1 = " delete doc_settle     where doc_no=? ";
		query2 = " delete doc_settle_var where doc_no=? ";
		query3 = " delete scd_fee_est    where doc_no=? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, doc_no);
		    pstmt.executeUpdate();

			pstmt = conn.prepareStatement(query2);
			pstmt.setString(1, doc_no);
		    pstmt.executeUpdate();

			pstmt = conn.prepareStatement(query3);
			pstmt.setString(1, doc_no);
		    pstmt.executeUpdate();

			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:deleteDocSettleLcStart]\n"+e);
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

	//중고차 결재문서처리관리 리스트 조회
	public Vector getCarPurAcDocList(String s_kd, String t_wd, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  "+
				"        a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, a.bus_id,"+
				"        a.dlv_dt, a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt,"+
				"        p.est_car_no, p.dlv_con_dt, p.dlv_est_dt, p.con_amt, p.pur_pay_dt, "+
				"        h.commi, h.sup_dt, h.comm_r_rt, h.req_dt, decode(nvl(i.dept_id,o.dept_id),'0007','부산','0008','대전','') dept_nm, "+
				"        pc.nm as car_comp_nm, i.user_nm as bus_nm, h.emp_id, j.emp_nm, k.car_off_nm, k2.car_off_nm as dealer_nm, "+
				"        decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
				"        l.*, "+
				"        decode(l.doc_step,'1','기안','2','결재','3','완료','대기') bit, r.car_nm, p.con_est_dt, "+
				"        decode(p.one_self,'Y','자체출고') one_self, decode(a.rent_st,'3','대차') cont_rent_st_nm, p.pur_pay_dt, p.jan_amt as car_est_amt, "+
				"        TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.rent_dt,'YYYYMMDD'))) delay_mon, p.delay_cont, p.dir_pur_yn, p.off_nm, p.cons_st, p.dlv_ext "+
				" from   cont a, fee b, client c, car_reg d, car_etc e, car_pur p,"+
				"        (select * from commi where agnt_st='6' and emp_id is not null) h,"+
				"        (select * from commi where agnt_st='5' and emp_id is not null) h2,"+
				"        users i, car_off_emp j, car_off_emp j2, car_off k, car_off k2, (select * from code where c_st='0001' and code<>'0000') pc,"+
				"        (select * from doc_settle where doc_st='4') l, users o,"+
				"        car_nm q, car_mng r"+
				" where  a.car_st='2' and a.car_gu='2' "+
				"        and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
				"        and a.client_id=c.client_id"+
				"        and a.car_mng_id=d.car_mng_id(+)"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				"        and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+)"+
				"        and a.rent_mng_id=h2.rent_mng_id(+) and a.rent_l_cd=h2.rent_l_cd(+)"+
				"        and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+)"+
				"        and h.emp_id=j.emp_id(+)"+
				"        and h2.emp_id=j2.emp_id(+)"+
				"        and j.car_off_id=k.car_off_id(+)"+
				"        and j2.car_off_id=k2.car_off_id(+)"+
				"        and q.car_comp_id=pc.code(+)"+
				"        and a.rent_l_cd=l.doc_id(+)"+
				"        and a.bus_id=o.user_id(+)"+
				"        and l.user_id1=i.user_id(+)"+
				"        and e.car_id=q.car_id and e.car_seq=q.car_seq and q.car_comp_id=r.car_comp_id and q.car_cd=r.code"+
				"        and a.rent_l_cd not in ('S108UA4L00002','S108UA4L00001') "+
				"        and h.emp_id is not null "+
				" ";


		if(gubun2.equals("1"))			query += " and q.car_comp_id = '0001' ";//현대자동차
		if(gubun2.equals("2"))			query += " and q.car_comp_id = '0002' ";//기아자동차
		if(gubun2.equals("3"))			query += " and q.car_comp_id > '0002' ";//기타자동차
		
		if(gubun1.equals("1"))			query += " and (l.doc_step is null or l.doc_step<>'3')";//미결
		else if(gubun1.equals("2"))		query += " and l.doc_step='3'";//결재

		String what = "";

		if(s_kd.equals("1"))	what = "upper(c.firm_nm)";
		if(s_kd.equals("2"))	what = "a.rent_l_cd";	
		if(s_kd.equals("3"))	what = "d.car_no";
		if(s_kd.equals("4"))	what = "o.user_nm";	
		if(s_kd.equals("5"))	what = "j.emp_nm";	
		if(s_kd.equals("6"))	what = "a.rent_dt";	
		if(s_kd.equals("7"))	what = "r.car_nm";	
		if(s_kd.equals("8"))	what = "o.user_nm";	
		if(s_kd.equals("9"))	what = "to_char(l.user_dt1,'YYYYMMDD')";	
		if(s_kd.equals("10"))	what = "to_char(l.user_dt5,'YYYYMMDD')";	
		if(s_kd.equals("11"))	what = "p.dlv_brch";	
		if(s_kd.equals("12"))	what = "p.est_car_no";	
		if(s_kd.equals("13"))	what = "pc.nm";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1") || s_kd.equals("12"))			query += " and "+what+" like upper('%"+t_wd+"%') ";
			if(s_kd.equals("9") || s_kd.equals("10"))			query += " and "+what+" like REPLACE('"+t_wd+"','-','')||'%' ";
			else 												query += " and "+what+" like '%"+t_wd+"%' ";
		}else{

		}	
		
		query += " order by p.con_est_dt, l.doc_step desc,  a.rent_dt, b.rent_start_dt, a.rent_mng_id";

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
			System.out.println("[DocSettleDatabase:getCarPurAcDocList(String s_kd, String t_wd, String gubun1, String gubun2)]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurAcDocList(String s_kd, String t_wd, String gubun1, String gubun2)]\n"+query);
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

	//중고차대금 지출문서관리 리스트 조회
	public Vector getCarPurPayDocAutoDocuAcList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  "+
				"		a.rent_mng_id, a.rent_l_cd, d.client_id,"+
				"		d.firm_nm, k.car_no, k.init_reg_dt, g.car_nm, a.con_est_dt, a.pur_est_dt, a.pur_pay_dt, "+
				"		'매매금액' trf_st1, card_kind1, trf_amt1, trf_pay_dt1,"+
				"		'중개수수료' trf_st2, card_kind2, trf_amt2, trf_pay_dt2,"+
				"		e.sh_init_reg_dt, a.est_car_no, f.car_comp_id, "+
				"       p.car_off_id as car_off_id1, p.car_off_nm as car_off_nm1, p.ven_code as ven_code1, p.sh_base_dt as sh_base_dt1, p.file_gubun1 as sh_base_dt3, "+
				"       p2.car_off_id as car_off_id2, p2.car_off_nm as car_off_nm2, p2.ven_code as ven_code2, p2.sh_base_dt as sh_base_dt2 "+
				" from  car_pur a, cont b, (select * from doc_settle where doc_st='4' and doc_step='3') c, client d, car_etc e, car_nm f, car_mng g, car_reg k, "+
				"       (select * from doc_settle where doc_st='5') h, users i, users l,"+
				"       (select a.rent_mng_id, a.rent_l_cd, c.car_off_id, c.car_off_nm, c.ven_code, a.sh_base_dt, a.file_gubun1 from commi a, car_off_emp b, car_off c where a.agnt_st='5' and a.emp_id is not null and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id) p,"+
				"       (select a.rent_mng_id, a.rent_l_cd, c.car_off_id, c.car_off_nm, c.ven_code, a.sh_base_dt, a.file_gubun1 from commi a, car_off_emp b, car_off c where a.agnt_st='6' and a.emp_id is not null and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id) p2 "+
				" where "+
				"	    a.autodocu_write_date is null and "+
		        "       b.car_gu='2' "+
				"       and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"       and a.rent_l_cd=c.doc_id"+
				"       and b.client_id=d.client_id"+
				"       and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd"+
				"       and e.car_id=f.car_id and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code"+
				"       and a.req_code=h.doc_id and b.bus_id=i.user_id(+) and c.user_id1=l.user_id(+) "+
				"       and b.car_mng_id=k.car_mng_id(+)"+
				"       and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+)"+
				"       and a.rent_mng_id=p2.rent_mng_id and a.rent_l_cd=p2.rent_l_cd"+
				" ";
			
		if(gubun1.equals("1"))			query += " and nvl(h.doc_step,'0')<>'3'";//미결
		else if(gubun1.equals("2"))		query += " and h.doc_step='3'";//결재

		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun3.equals("Y")){
			query += " and a.pur_pay_dt is not null and a.pur_pay_dt > '20101231'";//지급
			dt1 = "substr(a.pur_pay_dt,1,6)";
			dt2 = "a.pur_pay_dt";
		}else if(gubun3.equals("N")){
			query += " and a.pur_pay_dt is null";//미지급
			dt1 = "substr(a.pur_est_dt,1,6)";
			dt2 = "a.pur_est_dt";
		}else if(gubun3.equals("D")){
			query += " and a.autodocu_data_no is null and a.pur_pay_dt > '20101231'";//자동전표 미발행분
			dt1 = "substr(a.pur_pay_dt,1,6)";
			dt2 = "a.pur_pay_dt";
		}else{
			if(gubun1.equals("1")){
				dt1 = "to_char(nvl(h.user_dt1,c.user_dt5),'YYYYMM')";
				dt2 = "to_char(nvl(h.user_dt1,c.user_dt5),'YYYYMMDD')";		
			}else if(gubun1.equals("2")){
				dt1 = "to_char(h.user_dt2,'YYYYMM')";
				dt2 = "to_char(h.user_dt2,'YYYYMMDD')";
			}else{
				dt1 = "to_char(c.user_dt5,'YYYYMM')";
				dt2 = "to_char(c.user_dt5,'YYYYMMDD')";
			}
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(i.user_nm, ' '))";	

		if(s_kd.equals("99"))	what = "upper(nvl(h.doc_no, ' '))";	
			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by nvl(h.doc_step,'0') desc, k.init_reg_dt, k.car_use, k.car_no, a.dlv_est_dt desc, a.pur_est_dt desc, c.user_dt4, a.dlv_est_dt desc, d.firm_nm, g.car_nm";


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
			System.out.println("[DocSettleDatabase:getCarPurPayDocAutoDocuAcList]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayDocAutoDocuAcList]\n"+query);
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

	//중고차대금 지출문서관리 리스트 조회
	public int getCarPurDlvBrchMonCnt(String car_comp_id, String dlv_brch, String dlv_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " SELECT COUNT(0) cnt "+
				" FROM   cont a, car_etc b, car_pur c, (SELECT doc_id FROM doc_settle WHERE doc_st='4' AND doc_step='3') d, car_nm e "+
				" WHERE  "+
				"        a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.RENT_L_CD "+
				"        AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.RENT_L_CD "+  
				"        AND b.car_id=e.car_id AND b.car_seq=e.car_seq "+
				"        AND e.car_comp_id='"+car_comp_id+"' "+
				"        AND c.dlv_brch='"+dlv_brch+"' "+
				"        AND c.pur_pay_dt LIKE '"+dlv_mon+"%' "+
				"        AND a.rent_l_cd=d.doc_id "+
				"        and a.car_st='1' "+
				" ";
			
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
			System.out.println("[DocSettleDatabase:getCarPurDlvBrchMonCnt]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurDlvBrchMonCnt]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}		
	}

	//승계업무수당문서처리관리 리스트 조회
	public Vector getSucCommiDocList(String s_kd, String t_wd, String gubun1, String  user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_mng_id, a.rent_l_cd, a.rent_suc_dt, e.firm_nm, f.car_no, b.bus_id, c.user_nm, g.ext_amt, DECODE(g.ext_amt,g.ext_pay_amt,g.ext_pay_dt) ext_pay_dt, \n"+
				"        to_char(l.user_dt1,'YYYYMMDD') user_dt1, l.user_dt3, l.user_dt6, l.user_dt7, l.user_dt8, \n"+
				"        l.user_id1, l.user_id3, l.user_id6, l.user_id7, l.user_id8, \n"+
				"        l.doc_no, l.doc_id, decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit \n"+
				" FROM   cont_etc a, cont b, users c, users c2, car_off_emp d, client e, car_reg f, \n"+
				"        (SELECT rent_mng_id, rent_l_cd, MAX(ext_pay_dt) ext_pay_dt, SUM(ext_pay_amt) ext_pay_amt, SUM(DECODE(ext_tm,'1',ext_s_amt+ext_v_amt)) ext_amt  \n"+
				"         FROM   scd_ext  \n"+
				"         WHERE  ext_st='5' GROUP BY rent_mng_id, rent_l_cd \n"+
				"        ) g, \n"+
				"        (select * from doc_settle where doc_st='1') l, \n"+
			    "        (select * from commi where agnt_st='7') h, fee i, fee_etc j \n"+
				" WHERE  nvl(a.rent_suc_exem_cau,'0')<>'5' \n"+
			    "        and a.rent_suc_dt between '20180627' and '20190311' "+			    
				"        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND b.BUS_ID=c.user_id  \n"+
				"        AND b.reg_id=c2.user_id and (c2.dept_id='1000' or c2.user_nm='고연미')  \n"+
				"        AND c.sa_code=d.emp_id \n"+
				"        AND b.client_id=e.client_id \n"+
				"        AND b.car_mng_id=f.car_mng_id \n"+
				"        AND a.rent_mng_id=g.rent_mng_id AND DECODE(a.rent_suc_commi_pay_st,'1',a.rent_suc_l_cd,a.rent_l_cd)=g.rent_l_cd AND a.rent_suc_commi=g.ext_amt \n"+
				"        AND g.ext_amt>0 AND g.ext_amt=g.ext_pay_amt \n"+
				"        AND a.rent_l_cd=l.doc_id(+) "+
				"        AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+) \n"+
				"        AND a.rent_mng_id=i.rent_mng_id AND a.rent_l_cd=i.rent_l_cd and a.suc_rent_st=i.rent_st \n"+
				"        AND a.rent_mng_id=j.rent_mng_id AND a.rent_l_cd=j.rent_l_cd and a.suc_rent_st=j.rent_st and j.bus_agnt_id is null \n"+
				"        and b.rent_l_cd not in ('S117HXBL00099','S119EE3L00090') \n"+
				" ";

		if(!user_id.equals("")) query += " and b.bus_id='"+ user_id + "' \n";
			
		if(gubun1.equals("1"))			query += " and h.sup_dt is null and (l.doc_step is null OR l.doc_step<>'3') \n";//미결
		else if(gubun1.equals("2"))		query += " and l.doc_step='3' \n";//결재

		String what = "";

		if(s_kd.equals("1"))	what = "upper(e.firm_nm)";
		if(s_kd.equals("2"))	what = "a.rent_l_cd";	
		if(s_kd.equals("3"))	what = "f.car_no";
		if(s_kd.equals("4"))	what = "c.user_nm";	
		if(s_kd.equals("5"))	what = "to_char(l.user_dt1,'YYYYMMDD')";	
		if(s_kd.equals("6"))	what = "to_char(l.user_dt8,'YYYYMMDD')";	

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("2")){
				query += " and "+what+" like upper('%"+t_wd+"%')  \n";
			}else if(s_kd.equals("6")){
				query += " and (to_char(l.user_dt7,'YYYYMMDD') like '%"+t_wd+"%' OR to_char(l.user_dt8,'YYYYMMDD') like '%"+t_wd+"%') \n";
			}else{
				if(!what.equals(""))	query += " and "+what+" like '%"+t_wd+"%'  \n";
			}
		}else{

		}	
		
		query = query + " union ALL "+
				" SELECT a.rent_mng_id, a.rent_l_cd, a.rent_suc_dt, e.firm_nm, f.car_no, b.bus_id, c.user_nm, g.ext_amt, DECODE(g.ext_amt,g.ext_pay_amt,g.ext_pay_dt) ext_pay_dt, \n"+
				"        to_char(l.user_dt1,'YYYYMMDD') user_dt1, l.user_dt3, l.user_dt6, l.user_dt7, l.user_dt8, \n"+
				"        l.user_id1, l.user_id3, l.user_id6, l.user_id7, l.user_id8, \n"+
				"        l.doc_no, l.doc_id, decode(l.doc_step,'1','기안','3','완료','2','결재','대기') bit \n"+
				" FROM   cont_etc a, cont b, users c, users c2, car_off_emp d, client e, car_reg f, \n"+
				"        (SELECT rent_mng_id, rent_l_cd, MAX(ext_pay_dt) ext_pay_dt, SUM(ext_pay_amt) ext_pay_amt, SUM(DECODE(ext_tm,'1',ext_s_amt+ext_v_amt)) ext_amt  \n"+
				"         FROM   scd_ext  \n"+
				"         WHERE  ext_st='5' GROUP BY rent_mng_id, rent_l_cd \n"+
				"        ) g, \n"+
				"        (select * from doc_settle where doc_st='1') l, \n"+
			    "        (select * from commi where agnt_st='7') h, fee i, fee_etc j \n"+
				" WHERE  a.rent_suc_dt > '20190311' and nvl(a.rent_suc_exem_cau,'0')<>'5' \n"+
				"        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
				"        AND b.BUS_ID=c.user_id  \n"+
				"        AND b.reg_id=c2.user_id and (c2.dept_id='1000' or c2.user_nm='고연미')  \n"+
				"        AND c.sa_code=d.emp_id \n"+
				"        AND b.client_id=e.client_id \n"+
				"        AND b.car_mng_id=f.car_mng_id \n"+
				"        AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd AND a.rent_suc_commi=g.ext_amt \n"+
				"        AND g.ext_amt>0 AND g.ext_amt=g.ext_pay_amt \n"+
				"        AND a.rent_l_cd=l.doc_id(+) "+
				"        AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+) \n"+
				"        AND a.rent_mng_id=i.rent_mng_id AND a.rent_l_cd=i.rent_l_cd and a.suc_rent_st=i.rent_st \n"+
				"        AND a.rent_mng_id=j.rent_mng_id AND a.rent_l_cd=j.rent_l_cd and a.suc_rent_st=j.rent_st and j.bus_agnt_id is null \n"+
				"        and b.rent_l_cd not in ('S117HXBL00099','S119EE3L00090') \n"+
				" ";

		if(!user_id.equals("")) query += " and b.bus_id='"+ user_id + "' \n";
			
		if(gubun1.equals("1"))			query += " and h.sup_dt is null and (l.doc_step is null OR l.doc_step<>'3') \n";//미결
		else if(gubun1.equals("2"))		query += " and l.doc_step='3' \n";//결재

		what = "";

		if(s_kd.equals("1"))	what = "upper(e.firm_nm)";
		if(s_kd.equals("2"))	what = "a.rent_l_cd";	
		if(s_kd.equals("3"))	what = "f.car_no";
		if(s_kd.equals("4"))	what = "c.user_nm";	
		if(s_kd.equals("5"))	what = "to_char(l.user_dt1,'YYYYMMDD')";	
		if(s_kd.equals("6"))	what = "to_char(l.user_dt8,'YYYYMMDD')";	

			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("2")){
				query += " and "+what+" like upper('%"+t_wd+"%')  \n";
			}else if(s_kd.equals("6")){
				query += " and (to_char(l.user_dt7,'YYYYMMDD') like '%"+t_wd+"%' OR to_char(l.user_dt8,'YYYYMMDD') like '%"+t_wd+"%') \n";
			}else{
				if(!what.equals(""))	query += " and "+what+" like '%"+t_wd+"%'  \n";
			}
		}else{

		}			
		
		query += " order by 3";

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
			System.out.println("[DocSettleDatabase:getSucCommiDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getSucCommiDocList]\n"+query);
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
	
		public boolean updateDocSettleCls(String doc_no, String user_id, String doc_bit, String doc_step)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update doc_settle set doc_bit=decode(doc_step,'3',doc_bit,?), doc_step=decode(doc_step,'3',doc_step,?), user_id"+doc_bit+"=?, user_dt"+doc_bit+"=sysdate where doc_no=?";
	

		try 
		{
			conn.setAutoCommit(false);

			if(!doc_bit.equals("")){
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, doc_bit);
				pstmt.setString(2, doc_step);
				pstmt.setString(3, user_id);
				pstmt.setString(4, doc_no);
			    pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:updateDocSettleCls]\n"+e);
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

	//계약변경문서처리관리 리스트 조회
	public Vector getContCngDocList(String s_kd, String t_wd, String gubun1, String ck_acar_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.doc_no, a.doc_id, a.doc_step, a.doc_bit, \n"+ 
				"        decode(a.doc_step,'1','기안','2','결재','3','완료','대기') bit,  \n"+
				"        a.user_id1, \n"+ 
				"        to_char(a.user_dt1,'YYYY-MM-DD') as user_dt1, \n"+ 
				"        u1.user_nm as user_nm1, \n"+
				"        g.nm as dept_nm, \n"+ 
				"        d.rent_mng_id, d.rent_l_cd, e.firm_nm, f.car_no, f.car_nm, \n"+ 
				"        b.ins_doc_st, b.ins_doc_no, b.car_mng_id, b.ins_st, c.cnt, \n"+ 
				"        c.ch_item, \n"+ 
				"        b.ch_etc as etc, b.reg_dt, u4.user_nm as reg_nm \n"+ 
				" from   doc_settle a, ins_change_doc b, (select ins_doc_no, min(ch_tm) ch_tm, min(ch_item) ch_item, count(*) cnt from ins_change_doc_list group by ins_doc_no) c, \n"+ 
				"        users u1, users u4, \n"+ 
				"        cont d, client e, car_reg f, (select * from code where c_st='0002') g \n"+ 
				" where  a.doc_st='42' \n"+ 
				"        and a.doc_id=b.ins_doc_no \n"+ 
				"        and b.doc_st='4' \n"+
				"        and b.ins_doc_no=c.ins_doc_no \n"+ 
				"        and a.user_id1=u1.user_id \n"+ 
				"        and b.reg_id=u4.user_id(+) \n"+ 
				"        and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd \n"+ 
				"        and d.client_id=e.client_id \n"+ 
				"        and d.car_mng_id=f.car_mng_id(+) "+
				"        and u1.dept_id=g.code "+
				" ";

		if(!ck_acar_id.equals(""))		query += " and b.reg_id='"+ck_acar_id+"'";
			
		if(gubun1.equals("1"))			query += " and nvl(a.doc_step,'0')<>'3'";//미결
		else if(gubun1.equals("2"))		query += " and a.doc_step='3'";//결재

		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(f.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(f.car_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(u1.user_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(replace(to_char(a.user_dt1,'YYYYMMDD'),'-',''), ' '))";	
			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		query += " order by a.doc_no ";

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
			System.out.println("[DocSettleDatabase:getContCngDocList]\n"+e);
			System.out.println("[DocSettleDatabase:getContCngDocList]\n"+query);
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

	//차량대금 지출문서관리 리스트 조회 - 당월누적거래금액
	public Hashtable getCarPurPayAmtStat(String trf_st, String pur_est_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT SUM(year_amt) year_amt, SUM(mon_amt) mon_amt\r\n" + 
				"FROM (\r\n" + 
				"SELECT trf_st1 AS trf_st, SUM(trf_amt1) year_amt, SUM(DECODE(SUBSTR(pur_pay_dt,1,6),substr(replace('"+pur_est_dt+"','-',''),1,6),trf_amt1)) mon_amt\r\n" + 
				"FROM   car_pur \r\n" + 
				"WHERE  trf_st1='"+trf_st+"' and trf_amt1 >0 AND pur_pay_dt LIKE substr('"+pur_est_dt+"',1,4)||'%'\r\n" + 
				"GROUP BY trf_st1\r\n" + 
				"UNION all\r\n" + 
				"SELECT trf_st2 AS trf_st, SUM(trf_amt2) year_amt, SUM(DECODE(SUBSTR(pur_pay_dt,1,6),substr(replace('"+pur_est_dt+"','-',''),1,6),trf_amt2)) mon_amt\r\n" + 
				"FROM   car_pur \r\n" + 
				"WHERE  trf_st2='"+trf_st+"' and trf_amt2 >0 AND pur_pay_dt LIKE substr('"+pur_est_dt+"',1,4)||'%'\r\n" + 
				"GROUP BY trf_st2\r\n" + 
				"UNION all\r\n" + 
				"SELECT trf_st3 AS trf_st, SUM(trf_amt3) year_amt, SUM(DECODE(SUBSTR(pur_pay_dt,1,6),substr(replace('"+pur_est_dt+"','-',''),1,6),trf_amt3)) mon_amt\r\n" + 
				"FROM   car_pur \r\n" + 
				"WHERE  trf_st3='"+trf_st+"' and trf_amt3 >0 AND pur_pay_dt LIKE substr('"+pur_est_dt+"',1,4)||'%'\r\n" + 
				"GROUP BY trf_st3\r\n" + 
				"UNION all\r\n" + 
				"SELECT trf_st4 AS trf_st, SUM(trf_amt4) year_amt, SUM(DECODE(SUBSTR(pur_pay_dt,1,6),substr(replace('"+pur_est_dt+"','-',''),1,6),trf_amt4)) mon_amt\r\n" + 
				"FROM   car_pur \r\n" + 
				"WHERE  trf_st4='"+trf_st+"' and trf_amt4 >0 AND pur_pay_dt LIKE substr('"+pur_est_dt+"',1,4)||'%'\r\n" + 
				"GROUP BY trf_st4\r\n" + 
				")  "+
				"   ";

		
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
			System.out.println("[DocSettleDatabase:getCarPurPayAmtStat]\n"+e);
			System.out.println("[DocSettleDatabase:getCarPurPayAmtStat]\n"+query);
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
	 * 과실 비율 미확정 소송 관리 리스트
	 * 제안함: 과실비율 미확정 소송 관리 메뉴 신설
	 * 2019.12.05.
	*/
	public Vector getFaultBadComplaintList(String s_kd, String t_wd, String gubun1){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "SELECT b.*, d.firm_nm, \n" 
		        + "	DECODE(b.suit_type, '1', '분쟁조정심의위원회', '2', '민사소송', 'N', '소송불가') suit_type_nm,  \n" 
		        + "	DECODE(a.doc_step, '1', '기안', '2', '결재', '3', '완료', '대기') bit,  \n" 
		        + "	e.car_no, g.rent_l_cd, g.rent_mng_id, g.accid_st, g.accid_dt ,  e.car_nm, \n"
		        + "	a.doc_no, a.user_id1, a.user_id2, a.user_id3, a.user_id4, a.user_id5, a.user_id6, a.user_dt1, a.user_dt2, a.user_dt3, a.user_dt4, a.user_dt5, a.user_dt6, \n" 
		        + "	f1.user_nm AS user_nm1, f2.user_nm AS user_nm2, f3.user_nm AS user_nm3, f4.user_nm AS user_nm4, f5.user_nm AS user_nm5, f6.user_nm AS user_nm6  \n" 
		        + " FROM  doc_settle a, accid_suit b, accident g, cont c, client d, car_reg e, users f1, users f2, users f3, users f4, users f5, users f6  \n" 
		        + " WHERE  a.doc_st = '43'  \n" 
		        + " AND  a.doc_id = b.car_mng_id || b.accid_id  \n" 
		        + " AND  b.car_mng_id = g.car_mng_id 	AND b.accid_id = g.accid_id \n" 
		        + " AND  g.rent_mng_id = c.rent_mng_id 	AND g.rent_l_cd = c.rent_l_cd  \n" 
		        + " AND  c.client_id = d.client_id  \n" 
		        + " AND  c.car_mng_id = e.car_mng_id  \n" 
		        + " AND  a.user_id1 = f1.user_id  \n" 
		        + " AND  a.user_id2 = f2.user_id(+)  \n" 
		        + " AND  a.user_id3 = f3.user_id(+)  \n" 
		        + " AND  a.user_id4 = f4.user_id(+) \n"
		        + " AND  a.user_id5 = f5.user_id(+) \n"
		        + " AND  a.user_id6 = f6.user_id(+) ";
		
		String what = "";
		
		if(s_kd.equals("1") || s_kd.equals(""))	what = "UPPER(NVL(d.firm_nm, ' '))";
		if(s_kd.equals("2"))								what = "UPPER(NVL(c.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))								what = "UPPER(NVL(e.car_no, ' '))";
		if(s_kd.equals("4"))								what = "UPPER(NVL(f1.user_nm, ' '))";	
		if(s_kd.equals("5"))								what = "UPPER(NVL(REPLACE(TO_CHAR(a.user_dt1,'YYYYMMDD'), '-' , ''), ' '))";	
		if(s_kd.equals("6"))								what = "UPPER(NVL(REPLACE(TO_CHAR(a.user_dt2,'YYYYMMDD'), '-', ''), ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")) query += " AND " + what + " LIKE UPPER('%" + t_wd + "%') \n";
		
		//gubun1: 2:결재완료 
		if (gubun1.equals("2")) {
			query += " AND a.doc_step = 3 \n";
		} else if (gubun1.equals("1")) {
			query += " AND a.doc_step <> 3 \n";
		}
		
		query += " ORDER BY a.doc_step, b.req_dt desc ";
		
	//	System.out.println("query="+query);
		
		try{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
	    	ResultSetMetaData rsmd = rs.getMetaData();
	    	
			while(rs.next()){
				Hashtable ht = new Hashtable();
				for(int pos = 1; pos <= rsmd.getColumnCount(); pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		} catch(SQLException e){
			System.out.println("[DocSettleDatabase: getFaultBadComplaintList]: "+e);
			System.out.println("[DocSettleDatabase: getFaultBadComplaintList]:\n"+query);
	  		e.printStackTrace();
		} finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			} catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	
	 public boolean deleteDocSettleAccidSuit(String c_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
			getConnection();
			PreparedStatement pstmt = null;
			boolean flag = true;
			String query = "";
			
			String doc_id = c_id+""+accid_id;
			query = " delete from doc_settle where doc_id=? and doc_st='43' ";
			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, doc_id);
			    pstmt.executeUpdate();
				pstmt.close();

				conn.commit();
			    
		  	} catch (Exception e) {
				System.out.println("[DocSettleDatabase:deleteDocSettleAccidSuit]\n"+e);
				System.out.println("[DocSettleDatabase:deleteDocSettleAccidSuit]\n"+query);
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
	
	public List<AttachedFile> getAcarAttachFileList(String contentCode, String contentSeq) throws DatabaseException, DataSourceEmptyException
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		List<AttachedFile> result = new ArrayList<AttachedFile>();
		
		query = " SELECT * "+
				" FROM   ACAR_ATTACH_FILE WHERE ISDELETED = 'N' "+
				" AND  content_code = ? "+
				" AND   content_seq like '%' || ? || '%' "+
				" ";

		query += " order by reg_date desc, seq desc ";


		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, contentCode);
    		pstmt.setString(2, contentSeq);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next()){
				AttachedFile bean = new AttachedFile();
	            HashMap<String, String> columnMap = new HashMap<String, String>();
	            ResultSetMetaData metaData = rs.getMetaData();
	            
	            for (int i = 0; i < metaData.getColumnCount() ; i++) {
					columnMap.put(metaData.getColumnName(i + 1), "");
				}            
	            
			    bean.setSeq			(columnMap.get("SEQ") 			!= null ? rs.getInt("SEQ") 			: 0 	);
			    bean.setContentCode	(columnMap.get("CONTENT_CODE")	!= null ? rs.getString("CONTENT_CODE")	: ""	);
			    bean.setContentSeq	(columnMap.get("CONTENT_SEQ")	!= null ? rs.getString("CONTENT_SEQ") 	: "0"	);
			    bean.setFileName	(columnMap.get("FILE_NAME")		!= null ? rs.getString("FILE_NAME")	: ""	);
			    bean.setFileSize	(columnMap.get("FILE_SIZE")		!= null ? rs.getLong("FILE_SIZE") 		: 0		);
			    bean.setFileType	(columnMap.get("FILE_TYPE")		!= null ? rs.getString("FILE_TYPE")	: ""	);
			    bean.setSaveFile	(columnMap.get("SAVE_FILE")		!= null ? rs.getString("SAVE_FILE")	: ""	);
			    bean.setSaveFolder	(columnMap.get("SAVE_FOLDER")	!= null ? rs.getString("SAVE_FOLDER")	: ""	);
			    bean.setRegUser		(columnMap.get("REG_USERSEQ")	!= null ? rs.getString("REG_USERSEQ")	: "0"	);
			    bean.setRegDate		(columnMap.get("REG_DATE") 		!= null ? rs.getString("REG_DATE")		: ""	);
				
			    result.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch(SQLException e){
			System.out.println("[DocSettleDatabase: getAcarAttachFileList]: "+e);
			System.out.println("[DocSettleDatabase: getAcarAttachFileList]:\n"+query);
	  		e.printStackTrace();
		} finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			} catch(Exception ignore){}
			closeConnection();
			return result;
		}

	} 
	
	public boolean deleteDocSettleLcIm(String doc_no, String doc_id)
	{
		getConnection();
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		boolean flag = true;
		
		String query1 = " delete doc_settle where doc_no='"+doc_no+"' ";
		String query2 = " delete fee_im where rent_l_cd||rent_st||im_seq='"+doc_id+"'";
		String query3 = " delete scd_fee where tm_st2='3' and pay_cng_cau LIKE '%"+doc_id+"%'";		

		try  
		{
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
		    pstmt1.executeUpdate();
		    
		    pstmt2 = conn.prepareStatement(query2);
		    pstmt2.executeUpdate();
		    
		    pstmt3 = conn.prepareStatement(query3);
		    pstmt3.executeUpdate();
		    
		    pstmt1.close();
		    pstmt2.close();
		    pstmt3.close();
		    
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[DocSettleDatabase:deleteDocSettleLcIm]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt1 != null)	pstmt1.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	//계약금,의무보험료 카드결재 요청 리스트
	public Vector getCarPurReqCardList()
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query = " SELECT a.con_amt_pay_req, a.rent_mng_id, a.rent_l_cd, a.rpt_no, e.com_con_no, a.dlv_brch, a.pur_est_dt, a.pur_pay_dt, \r\n"
					+ "       a.con_amt, a.con_est_dt, a.con_pay_dt, a.con_bank,\r\n"
					+ "       c.firm_nm, d.user_nm  \r\n"
					+ "FROM   car_pur a, cont b, client c, users d, car_pur_com_pre e \r\n"
					+ "where  a.trf_st0='3' AND TO_CHAR(a.con_amt_pay_req,'YYYYMMDD')=TO_CHAR(SYSDATE,'YYYYMMDD') \r\n"
					+ "--AND a.pur_pay_dt IS NULL AND a.pur_est_dt IS NULL\r\n"
					+ "AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd\r\n"
					+ "AND b.car_gu='1' AND (b.use_yn IS NULL OR b.use_yn='Y')\r\n"
					+ "AND b.client_id=c.client_id \r\n"
					+ "AND b.BUS_ID=d.user_id \r\n"
					+ "AND a.rent_l_cd=e.rent_l_cd(+) AND NVL(e.use_yn,'Y')='Y'\r\n"
					+ "ORDER BY 1"; 
				
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
				System.out.println("[DocSettleDatabase:getCarPurReqCardList]\n"+e);
				System.out.println("[DocSettleDatabase:getCarPurReqCardList]\n"+query);
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


