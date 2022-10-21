
package acar.cms;

import java.io.*;
import java.sql.*;
import java.util.*;
//import acar.util.*;
//import java.text.*;
//import acar.database.*;
import acar.database.DBConnectionManager;
//import acar.exception.DataSourceEmptyException;
//import acar.exception.UnknownDataException;
//import acar.exception.DatabaseException;

public class CmsDatabase
{
	private Connection conn = null;
	public static CmsDatabase db;
	
	public static CmsDatabase getInstance()
	{
		if(CmsDatabase.db == null)
			CmsDatabase.db = new CmsDatabase();
		return CmsDatabase.db;
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


//환경설정
public Hashtable Cms_Config()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
	
		query =	" select * from comp ";

//System.out.println("[CmsDatabase:Cms_Config]\n"+query);			

		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
		  
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
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[CmsDatabase:Cms_Config]\n"+e);			
			System.out.println("[CmsDatabase:Cms_Config]\n"+query);			
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}	
	}

//CMS참가 은행관리
	public Vector Cms_banklist()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from bnk order by bcode ";

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
			System.out.println("[CmsDatabase:Cms_banklist]\n"+e);
			System.out.println("[CmsDatabase:Cms_banklist]\n"+query);
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

//CMS이체에러코드
	public Vector Cms_errorlist()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select * from err ";

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
			System.out.println("[CmsDatabase:Cms_banklist]\n"+e);
			System.out.println("[CmsDatabase:Cms_banklist]\n"+query);
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
	
		//CMS 고객 리스트 조회 (gubun - 1:상호, 2:계약번호)
	public Vector getCmsContList(String s_kd, String t_wd, String gubun4)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
	//	if(gubun4.equals("1"))			query += " where cbit  = '1' ";  //신규신청
//		else if(gubun4.equals("2"))		query += " where  it  = '2' ";  //승인완료
//		else if(gubun4.equals("3"))		query += " and cbit  = '3' ";  //해지신청
//		else if(gubun4.equals("4"))		query += "and cbit  = '4' ";  //해지완료
		
		query = " select  a.*,   b.bname, m.cms_start_dt, m.cms_amt ,  decode(a.cbit,'1','신규신청','2','승인완료','3', '해지신청', '4', '해지완료') cbit_nm \n "+ 
			     "  from cust a, bnk b , cms_mng m , \n "+
                                 " ( select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) mm \n "+
                                "   where a.cbit = '" + gubun4 + "' and a.cbnk = b.bcode and a.rent_mng_id = m.rent_mng_id(+) and a.rent_l_cd = m.rent_l_cd(+) \n"+
                                "      and m.rent_mng_id = mm.rent_mng_id and m.rent_l_cd = mm.rent_l_cd and m.seq = mm.seq  \n ";
/*
		query = " select  "+
				" a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id,"+
				" a.rent_dt, c.firm_nm, d.car_no, b.rent_start_dt,"+
				" decode(nvl(e.cnt,0),0,'-','생성') scd_yn,"+
				" decode(f.reg_st,'1','등록','2','해지','미등록') reg_st,"+
				" decode(a.use_yn,'Y','진행','N','해지','미결') use_st,"+
				" f.cms_day, f.cms_bank, f.cms_acc_no, f.cms_dep_nm,"+
				" decode(g.cbit,'1','신규','2','승인','3','해지신청','4','해지완료','7','임의해지','8','신고에러') cbit,"+
				" h.user_nm, h2.user_nm as reg_nm "+
				" from cont a, fee b, client c, car_reg d,"+
				" (select rent_mng_id, rent_l_cd, count(*) cnt from scd_fee group by rent_mng_id, rent_l_cd) e,"+
				" cms_mng f, cust g, users h, users h2"+
				" where a.car_st<>'2'"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1'"+
				" and (b.fee_pay_st='1' or f.app_dt is not null)"+
				" and a.client_id=c.client_id"+
				" and a.car_mng_id=d.car_mng_id(+)"+
				" and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)"+
				" and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)"+
				" and a.rent_l_cd=g.code(+)"+
				" and nvl(b.ext_agnt,a.bus_id)=h.user_id "+
				" and nvl(f.update_id,f.reg_id)=h2.user_id(+) "+
				" and a.rent_dt > '20071019'";
*/
		String search = "";
		String what = "";
	
		if(s_kd.equals("1"))	what = "upper(nvl(a.cname, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper(replace('%"+t_wd+"%','-','')) ";
		}	
				
		query += " order by a.cday, a.rent_mng_id";

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
			System.out.println("[CmsDatabase:getCmsContList]\n"+e);
			System.out.println("[CmsDatabase:getCmsContList]\n"+query);
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


  public static void write_text_test() {
   // TODO Auto-generated method stub
   File file1       =  new File("c:/testText1.txt");
   File file2       =  new File("c:/testText2.txt");
   FileWriter fileWriterTest   =  null;
   PrintWriter newLineTest    =  null;
   try{
    fileWriterTest     =  new FileWriter(file1);
    
    String text      =  "참 잘했어요";
    
    fileWriterTest.write(text);
    
    fileWriterTest.flush();
    //1번 방법
    
    newLineTest      =  new PrintWriter(file2);
    
    newLineTest.println(text);
    newLineTest.println(text);
    newLineTest.flush();
    //2번 방법 (한줄 개행이 됩니다.)
    
    // 남책임님이시면 차이점은 바로 아실거라고 생각되어 두가지 경우를 넣습니다.
    // 저는 보통 2번째를 사용했는데요... 어떤게 필요하실지 몰라서 두가지 소스를 다 넣습니다.
    
   }catch(Exception e){
    e.printStackTrace();
   }finally{
    try{
     if(fileWriterTest  != null){ fileWriterTest.close();}
     if(newLineTest   != null){ fileWriterTest.close();}
    }catch(Exception ee){
     ee.printStackTrace();
    }
    
   }
  }


/**
	 *	차량회수 insert
	 */
	public boolean insertCmsCng(CmsCngBean cr)
	{
		getConnection();
			
		PreparedStatement pstmt = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs1 = null;
			
		String bank_cd = "";
		
		boolean flag = true;
			
		String query3 = " select code from code "+
							" where c_st = '0003' and nm_cd ='"+cr.getCms_bank()+"'" ;
							
		String query = "insert into cms_cng ("+
							" RENT_MNG_ID, RENT_L_CD, req_id, req_dt, cms_bank, "+
							" cms_acc_no, cms_dep_nm, cms_dep_ssn, app_st , bank_cd, old_cms_bank, old_cms_acc_no , est_dt  ) values("+
						 	" ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?,"+   //4
						 	" replace(?, '-', '') , ?, ?, 'N' , ?, ?, replace(?, '-', ''), ?  )";  //6
				
		try 
		{
			conn.setAutoCommit(false);
		
			pstmt3 = conn.prepareStatement(query3);
			rs1 = pstmt3.executeQuery();
			if(rs1.next())	bank_cd = rs1.getString(1)==null?"":rs1.getString(1);
			rs1.close();   
			pstmt3.close();
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cr.getRent_mng_id());
			pstmt.setString(2, cr.getRent_l_cd());
			pstmt.setString(3, cr.getReq_id());
			pstmt.setString(4, cr.getCms_bank());
			pstmt.setString(5, cr.getCms_acc_no());
			pstmt.setString(6, cr.getCms_dep_nm());
			pstmt.setString(7, cr.getCms_dep_ssn());
			pstmt.setString(8, bank_cd);
			pstmt.setString(9, cr.getOld_cms_bank());
			pstmt.setString(10, cr.getOld_cms_acc_no());
			pstmt.setString(11, cr.getEst_dt());
		   pstmt.executeUpdate();
		   pstmt.close();
		   
			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				 if(rs1 != null )	rs1.close();
				if(pstmt3 != null)	pstmt3.close();
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
				
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}
		  	
		//자동이체 변경관련 첨부파일 등록 여부   - 동의서 등록 여부 
	public int  getCmsCngFileCnt(String rent_l_cd, String req_dt, String gubun)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		int cnt = 0;		
                 
       query = " select count(0) from acar_attach_file  \n"+
					  " 	 where substr(content_seq, 7, 13) =   '" + rent_l_cd + "'  and content_code = 'LC_SCAN' \n"+
				     "      and to_char(reg_date , 'yyyymmdd') = replace('"+ req_dt+ "' , '-', '')  and isdeleted = 'N' \n"+
				     "      and SUBSTR(content_seq,21) = '" + gubun + "'  " ;  
                 
		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next()){
				cnt = rs.getInt(1);
			}    
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}			
	}


  // 자동이체 리스트 조회 
	public Vector getCmsReqList(String s_kd, String t_wd, String gubun1, String andor)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.* ,  \n"+
				"  a.client_id, a.car_mng_id, a.rent_dt, a.firm_nm, c.car_no, c.car_nm, a.rent_start_dt, \n"+
				"  u.user_nm as bus_nm,  decode(b.app_st,'N','미처리','Y','처리',  '') app_st_nm \n"+			
				" from cms_cng b, users u,  car_reg c,  cont_n_view a \n"+			
				" where  b.rent_mng_id=a.RENT_MNG_ID and b.rent_l_cd=a.rent_l_cd \n"+
				" and  a.car_mng_id = c.car_mng_id(+) and b.req_id = u.user_id " ;
			
		if(s_kd.equals("1"))	query += " and nvl(a.firm_nm, ' ') like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and nvl(a.rent_l_cd, ' ') like '%"+t_wd+"%'";	
		if(s_kd.equals("3"))	query += " and nvl(c.car_no, ' ') like '%"+t_wd+"%'";	
		if(s_kd.equals("6"))	query += " and b.req_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";	
			 					
		if(s_kd.equals("5") ) {
			if ( !t_wd.equals("")) {
				query += " and b.req_dt like '"+t_wd+"%'";
			} else {
				query += " and  ( b.req_dt like to_char(sysdate,'YYYYMM')||'%'    or   b.app_st = 'N'   )  " ;		
			}	
		
		}
			
	   if( !andor.equals(""))		query += " and b.app_st='"+andor+"'";

	
		query += " order by b.app_st , b.req_dt desc , a.rent_dt, a.rent_start_dt ";

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
			System.out.println("[CmsDatabase:getCmsReqList]\n"+e);
			System.out.println("[CmsDatabase:getCmsReqList]\n"+query);
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
           
    public CmsCngBean getCmsCng(String rent_mng_id, String rent_l_cd , String req_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		CmsCngBean bean = new CmsCngBean();

		query =  " select * from cms_cng where rent_mng_id='"+rent_mng_id+ "' and rent_l_cd = '"+rent_l_cd + "' and req_dt = replace('"+req_dt + "', '-', '') ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();	
    			
			if(rs.next())
			{				
				
			   bean.setRent_mng_id		(rs.getString("rent_mng_id")		==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd		(rs.getString("rent_l_cd")		==null?"":rs.getString("rent_l_cd"));
				bean.setReq_dt		(rs.getString("req_dt")		==null?"":rs.getString("req_dt"));
				bean.setReq_id		(rs.getString("req_id")		==null?"":rs.getString("req_id"));
				bean.setCms_bank		(rs.getString("cms_bank")		==null?"":rs.getString("cms_bank"));
				bean.setCms_acc_no		(rs.getString("cms_acc_no")		==null?"":rs.getString("cms_acc_no"));
				bean.setCms_dep_nm		(rs.getString("cms_dep_nm")		==null?"":rs.getString("cms_dep_nm"));
				bean.setCms_dep_ssn		(rs.getString("cms_dep_ssn")		==null?"":rs.getString("cms_dep_ssn"));
				bean.setApp_dt		(rs.getString("app_dt")		==null?"":rs.getString("app_dt"));
				bean.setApp_id		(rs.getString("app_id")		==null?"":rs.getString("app_id"));
				bean.setApp_st		(rs.getString("app_st")		==null?"":rs.getString("app_st"));
				bean.setBank_cd	(rs.getString("bank_cd")		==null?"":rs.getString("bank_cd"));
				bean.setOld_cms_bank		(rs.getString("old_cms_bank")		==null?"":rs.getString("old_cms_bank"));
				bean.setOld_cms_acc_no		(rs.getString("old_cms_acc_no")		==null?"":rs.getString("old_cms_acc_no"));
				bean.setEst_dt		(rs.getString("est_dt")		==null?"":rs.getString("est_dt"));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CmsDatabase:getCmsCng]"+e);
			System.out.println("[CmsDatabase:getCmsCng]"+query);
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
	 
       
   //처리등록 updateCmsCngApp_st(rent_mng_id, rent_l_cd, req_dt, user_id, req_dt);
	public boolean updateCmsCngApp_st(String rent_mng_id, String rent_l_cd, String req_dt, String app_id, String app_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query =  " UPDATE cms_cng  SET "+
						" app_dt = replace( ? , '-', ''), app_id= ? , app_st = 'Y'  "+				
						" WHERE RENT_MNG_ID = ? AND RENT_L_CD = ? and req_dt = replace( ? , '-', '')  ";
		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1,  app_dt		);
			pstmt.setString(2,  app_id		);
			pstmt.setString(3,  rent_mng_id	);
			pstmt.setString(4,  rent_l_cd	);
			pstmt.setString(5,  req_dt	);
						
		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[CmsDatabase:updateCmsCngApp_st]\n"+e);
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
	  
	
	//  자동이체 변경관련 첨부파일 등록 여부   - 동의서 등록 여부  - 청구금액이 0인 경우 제외
	public String  getCmsFeeEst_dt(String rent_mng_id, String rent_l_cd )
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		String est_dt = "";		
                 
      query = " select nvl(min(r_fee_est_dt), '29991231' )   est_dt from scd_fee where rent_mng_id =   '" + rent_mng_id + "' and  rent_l_cd =    '" + rent_l_cd + "' and  rc_yn = '0' and fee_s_amt > 0 and bill_yn = 'Y' ";
             
		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
			if(rs.next()){
				est_dt = rs.getString(1);		
			}
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return est_dt;
		}			
	}


	public int delCmsCng(String rent_mng_id, String rent_l_cd , String req_dt){

		getConnection();

		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";
		            	
	 
      query=" delete from cms_cng where app_st = 'N' and rent_mng_id = '"+ rent_mng_id + "' and rent_l_cd = '" + rent_l_cd + "' and req_dt = replace('"+req_dt + "' , '-', '') " ;	

		try 
		{			
			conn.setAutoCommit(false);	
			pstmt = conn.prepareStatement(query);
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CmsDatabase:delCmsCng]\n"+e);
			System.out.println("[CmsDatabase:delCmsCng]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
	
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}	


	//자동이체 update
	public boolean updateCmsCng(CmsCngBean bean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		boolean flag = true;
		String query = "";
		String bank_cd = "";
		
		String query3 = " select code from code "+
							" where c_st = '0003' and nm_cd ='"+bean.getCms_bank()+"'" ;
							
		query = " update cms_cng set "+
				" REQ_ID=?, CMS_BANK=?, CMS_ACC_NO=replace(?, '-', ''), CMS_DEP_NM=?, CMS_DEP_SSN=?,"+   //5
				" OLD_CMS_BANK =?,  OLD_CMS_ACC_NO=replace(?, '-', '') , EST_DT=?,"+   //3
				"  APP_ST=?, APP_DT=replace(?, '-', ''), BANK_CD = ?, APP_ID=? "+   //4
				" where rent_mng_id=? and rent_l_cd=? and req_dt= replace(?, '-', '') ";  //3
		
		try{

			conn.setAutoCommit(false);
			
			pstmt3 = conn.prepareStatement(query3);
			rs = pstmt3.executeQuery();
			if(rs.next()){
				bank_cd = rs.getString(1)==null?"":rs.getString(1);				
			//	System.out.println("bank=" + bank_cd);	
				
			}
			rs.close();
			pstmt3.close();
						
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getReq_id());
			pstmt.setString(2, bean.getCms_bank());
			pstmt.setString(3, bean.getCms_acc_no());
			pstmt.setString(4, bean.getCms_dep_nm());
			pstmt.setString(5, bean.getCms_dep_ssn());
			pstmt.setString(6, bean.getOld_cms_bank());
			pstmt.setString(7, bean.getOld_cms_acc_no());
			pstmt.setString(8, bean.getEst_dt());
			pstmt.setString(9, bean.getApp_st());
			pstmt.setString(10, bean.getApp_dt());
			pstmt.setString(11, bank_cd);			
			pstmt.setString(12, bean.getApp_id());			
			pstmt.setString(13, bean.getRent_mng_id());	
			pstmt.setString(14, bean.getRent_l_cd());
			pstmt.setString(15, bean.getReq_dt());				
		    pstmt.executeUpdate();	
			pstmt.close();

			conn.commit();

		}catch(Exception e){
			System.out.println("[CmsDatabase:updateCmsCng]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(rs != null )		rs.close();
				if(pstmt3 != null)	pstmt3.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	
	
//
	public boolean insertCmsBnk(String bcode ,String bname, String c_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = "insert into bnk ("+
							" bcode, bname , c_code ) values("+
						 	" ?, ?, ?  )";  //6
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bcode);			
			pstmt.setString	(2,		bname);			
			pstmt.setString	(3,		c_code);			
		
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
  
  
  
  public boolean updateCmsBnk(String bcode ,String bname, String c_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		
		String query = "update bnk set "+
							" bname =? , c_code = ?  where bcode = ? ";  //6
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bname);			
			pstmt.setString	(2,		c_code);			
			pstmt.setString	(3,		bcode);			
		
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
	 
	 
		/*
	 *	장기대여계약 자동이체 스캔파일 동기화 호출
	*/
	public String call_sp_lc_rent_scanfile_syn3(String rent_l_cd, String cng_dt)
	{
    	getConnection();
    	
    	String query = "{CALL P_LC_RENT_SCANFILE_SYN3 (?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, rent_l_cd);
			cstmt.setString(2, cng_dt);
				
			cstmt.execute();
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CmsDatabase:call_sp_lc_rent_scanfile_syn3]\n"+e);
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
