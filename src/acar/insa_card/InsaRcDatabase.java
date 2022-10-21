package acar.insa_card;

import java.sql.*;
import java.util.*;

import acar.cont.ContGiInsBean;
import acar.database.*;
import acar.util.*;

public class InsaRcDatabase
{
	private Connection conn = null;
	public static InsaRcDatabase db;
	
	public static InsaRcDatabase getInstance()
	{
		if(InsaRcDatabase.db == null)
			InsaRcDatabase.db = new InsaRcDatabase();
		return InsaRcDatabase.db;
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
	
	//채용공고 시작--------------------------------------------------------------------------------------------------------------------------
	
	public List<Insa_Rc_InfoBean> selectInsaAll() throws SQLException{
		  //테이블 INSA_RC_INFO
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      List<Insa_Rc_InfoBean> res=new ArrayList<Insa_Rc_InfoBean>();
	      
	      String sql=
	            "  SELECT "
	               + "reg_id,"
	               + "rc_no,"
	               + "rc_cur_dt, "
	               + "rc_tot_capital,"
	               + "rc_tot_asset,"
	               + "rc_sales,"
	               + "rc_per_off,"
	               + "rc_per_off_per,"
	               + "rc_num_com,"
	               + "rc_busi_rank"
	               + " FROM INSA_RC_INFO ORDER BY RC_NO DESC " ;
	      
	      try {
	         pstm=conn.prepareStatement(sql); 
	         rs=pstm.executeQuery();
	         
	         while(rs.next()) {
	        	Insa_Rc_InfoBean tmp= new Insa_Rc_InfoBean();
	            tmp.setReg_id(rs.getString(1));
	            tmp.setRc_no(rs.getInt(2));
	            tmp.setRc_cur_dt(rs.getString(3));
	            tmp.setRc_tot_capital(rs.getInt(4));
	            tmp.setRc_tot_asset(rs.getInt(5));
	            tmp.setRc_sales(rs.getInt(6));
	            tmp.setRc_per_off(rs.getInt(7));
	            tmp.setRc_per_off_per(rs.getInt(8));
	            tmp.setRc_num_com(rs.getInt(9));
	            tmp.setRc_busi_rank(rs.getInt(10));

	            res.add(tmp);
	 
	         }
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	         rs.close();
	         pstm.close();
	         closeConnection();
	      }
	      return res;
	}
	
	public Insa_Rc_InfoBean InsaRcselectOne(int rc_no) throws SQLException {
		//테이블 INSA_RC_INFO
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      Insa_Rc_InfoBean res=new Insa_Rc_InfoBean();
	      
	      String sql=" SELECT * FROM INSA_RC_INFO WHERE RC_NO= ?";
	      
	      try {
	         pstm=conn.prepareStatement(sql);
	         pstm.setInt(1, rc_no);
	         rs=pstm.executeQuery();
	         
	         while(rs.next()) {
	            res.setReg_id(rs.getString(1));
	            res.setRc_no(rs.getInt(2));
	            res.setRc_cur_dt(rs.getString(3)==null?"":rs.getString(3));
	            res.setRc_tot_capital(rs.getInt(4));
	            res.setRc_tot_asset(rs.getInt(5));
	            res.setRc_sales(rs.getInt(6));
	            res.setRc_per_off(rs.getInt(7));
	            res.setRc_per_off_per(rs.getInt(8));
	            res.setRc_num_com(rs.getInt(9));
	            res.setRc_busi_rank(rs.getInt(10));
	         }
	         
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	    	  rs.close();
		      pstm.close();
		      closeConnection();
	      }
	      return res;
	}
	
	public int infoInsert(Insa_Rc_InfoBean infoBean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int res=0;
		
		String query = " insert into INSA_RC_INFO \n"+
				" (REG_ID,\r\n"
				+ "       RC_NO,\r\n"
				+ "       RC_CUR_DT,\r\n"
				+ "       RC_TOT_CAPITAL,\r\n"
				+ "       RC_TOT_ASSET,\r\n"
				+ "       RC_SALES,\r\n"
				+ "       RC_PER_OFF,\r\n"
				+ "       RC_PER_OFF_PER,\r\n"
				+ "       RC_NUM_COM,\r\n"
				+ "       RC_BUSI_RANK\n"+
				" ) values ("+
				" ?,?,?,?,?,?,?,?,?,?"+
				" )";	
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,infoBean.getReg_id());
			pstmt.setInt(2,infoBean.getRc_no());
			pstmt.setString(3,infoBean.getRc_cur_dt());
			pstmt.setInt(4,infoBean.getRc_tot_capital());
			pstmt.setInt(5, infoBean.getRc_tot_asset());
			pstmt.setInt(6, infoBean.getRc_sales());
			pstmt.setInt(7, infoBean.getRc_per_off());
			pstmt.setInt(8, infoBean.getRc_per_off_per());
			pstmt.setInt(9, infoBean.getRc_num_com());
	        pstmt.setInt(10, infoBean.getRc_busi_rank());		        						
		   	pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			res=1;
		    
	  	} catch (Exception e) {
			e.printStackTrace();
			res=0;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return res;
		}
	}	
	
	public int infoUpdate(Insa_Rc_InfoBean infoBean) throws SQLException {
	      getConnection();
	      PreparedStatement pstm=null;
	      int res=0;

	      String sql="UPDATE INSA_RC_INFO "
	      		+ "SET RC_CUR_DT=?, "
	      		+ " RC_TOT_CAPITAL=?, "
	      		+ " RC_TOT_ASSET=?, "
	      		+ " RC_SALES=?, "
	      		+ " RC_PER_OFF=?, "
	      		+ " RC_PER_OFF_PER=?, "
	      		+ " RC_NUM_COM=?, "
	      		+ " RC_BUSI_RANK=? "
	      		+ " WHERE RC_NO=? ";
	      
	      try {
	    	  conn.setAutoCommit(false);
	    	  
	         pstm=conn.prepareStatement(sql);
	         pstm.setString(1,infoBean.getRc_cur_dt());
	         pstm.setInt(2, infoBean.getRc_tot_capital());
	         pstm.setInt(3, infoBean.getRc_tot_asset());
	         pstm.setInt(4, infoBean.getRc_sales());
	         pstm.setInt(5, infoBean.getRc_per_off());
	         pstm.setInt(6, infoBean.getRc_per_off_per());
	         pstm.setInt(7, infoBean.getRc_num_com());
	         pstm.setInt(8, infoBean.getRc_busi_rank());
	         pstm.setInt(9, infoBean.getRc_no());
	         res=pstm.executeUpdate();
	         
	         if(res>0) {
	        	 conn.commit();
	         }
	      } catch (SQLException e) {
	         e.printStackTrace();
	         res = 0;
	     	 conn.rollback();
	      }finally {
	         pstm.close();
	         conn.setAutoCommit(true);
	      }
	      closeConnection();
	      return res;
	}
	
	
	public List<Insa_Rc_JobBean> selectInsaRcJobAll() throws SQLException{
		  //테이블 INSA_RC_INFO
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      List<Insa_Rc_JobBean> res=new ArrayList<Insa_Rc_JobBean>();
	      
	      String sql=
	            "  SELECT "
	               + "a.reg_id,"
	               + "a.rc_no,"
	               + "a.rc_job, "
	               + "a.rc_job_cont, b.rc_nm  "
	               + " FROM INSA_RC_JOB a, insa_rc_code b where a.rc_job = b.rc_code and b.rc_gubun = '1'  ORDER BY a. RC_NO " ;
	      
	      try {
	         pstm=conn.prepareStatement(sql); 
	         rs=pstm.executeQuery();
	         
	         while(rs.next()) {
	        	 Insa_Rc_JobBean tmp= new Insa_Rc_JobBean();
	            tmp.setReg_id(rs.getString(1));
	            tmp.setRc_no(rs.getInt(2));
	            tmp.setRc_job(rs.getString(3)==null?"":rs.getString(3));
	            tmp.setRc_job_cont(rs.getString(4)==null?"":rs.getString(4));
	            tmp.setRc_nm(rs.getString(5)==null?"":rs.getString(5));
	            res.add(tmp);
	 
	         }
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	         rs.close();
	         pstm.close();
	         closeConnection();
	      }
	      return res;
	}
		

	public Insa_Rc_JobBean InsaRcJobselectOne(int rc_no) throws SQLException {
		//테이블 INSA_RC_INFO
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      Insa_Rc_JobBean res=new Insa_Rc_JobBean();
	      
	      String sql=" SELECT * FROM INSA_RC_JOB WHERE RC_NO= ?";
	      
	      try {
	         pstm=conn.prepareStatement(sql);
	         pstm.setInt(1, rc_no);
	         rs=pstm.executeQuery();
	         
	         while(rs.next()) {
	            res.setReg_id(rs.getString(1));
	            res.setRc_no(rs.getInt(2));
	            res.setRc_job(rs.getString(3)==null?"":rs.getString(3));
	            res.setRc_job_cont(rs.getString(4)==null?"":rs.getString(4));	            
	         }
	         
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	    	  rs.close();
		      pstm.close();
		      closeConnection();
	      }
	      return res;
	}
	
	public Insa_Rc_JobBean InsaRcJobselectOne2(String rc_job) throws SQLException {
		//테이블 INSA_RC_INFO
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      Insa_Rc_JobBean res=new Insa_Rc_JobBean();
	      
	      String sql=" SELECT * FROM INSA_RC_JOB WHERE RC_JOB= ?";
	      
	      try {
	         pstm=conn.prepareStatement(sql);
	         pstm.setString(1, rc_job);
	         rs=pstm.executeQuery();
	         
	         while(rs.next()) {
	            res.setReg_id(rs.getString(1));
	            res.setRc_no(rs.getInt(2));
	            res.setRc_job(rs.getString(3)==null?"":rs.getString(3));
	            res.setRc_job_cont(rs.getString(4)==null?"":rs.getString(4));	            
	         }
	         
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	    	  rs.close();
		      pstm.close();
		      closeConnection();
	      }
	      return res;
	}	
	
	public int jobInsert(Insa_Rc_JobBean infoBean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int res=0;
		
		String query = " insert into INSA_RC_JOB \n"+
				" (REG_ID,\r\n"
				+ "       RC_NO,\r\n"
				+ "       RC_JOB,\r\n"
				+ "       RC_JOB_CONT\r\n"+
				" ) values ("+
				" ?,?,?,?"+
				" )";	
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,infoBean.getReg_id());
			pstmt.setInt(2,infoBean.getRc_no());
			pstmt.setString(3,infoBean.getRc_job().trim());
			pstmt.setString(4,infoBean.getRc_job_cont().trim());				        						
		   	pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			res=1;
		    
	  	} catch (Exception e) {
			e.printStackTrace();
			res=0;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return res;
		}
	}	
	
	public int jobUpdate(Insa_Rc_JobBean infoBean) throws SQLException {
	      getConnection();
	      PreparedStatement pstm=null;
	      int res=0;

	      String sql="UPDATE INSA_RC_JOB "
	      		+ "SET RC_JOB=?, "
	      		+ " RC_JOB_CONT=? "
	      		+ " WHERE RC_NO=? ";
	      
	      try {
	    	  conn.setAutoCommit(false);
	    	  
	         pstm=conn.prepareStatement(sql);
	         pstm.setString(1,infoBean.getRc_job().trim());
	         pstm.setString(2,infoBean.getRc_job_cont().trim());
	         pstm.setInt(3, infoBean.getRc_no());
	         res=pstm.executeUpdate();
	         
	         if(res>0) {
	        	 conn.commit();
	         }
	      } catch (SQLException e) {
	         e.printStackTrace();
	         res = 0;
	     	 conn.rollback();
	      }finally {
	         pstm.close();
	         conn.setAutoCommit(true);
	      }
	      closeConnection();
	      return res;
	}
	
	public int jobDelete(int rc_no) throws SQLException {
	      getConnection();
	      PreparedStatement pstm=null;
	      int res=0;
	      
	      String sql="delete from  INSA_RC_JOB "	      
	      		+ " WHERE RC_NO=? ";
	      
	      try {
	    	  conn.setAutoCommit(false);
	    	  
	         pstm=conn.prepareStatement(sql);	     
	         pstm.setInt(1, rc_no);
	         res=pstm.executeUpdate();
	         
	         conn.commit();
	      
	      } catch (SQLException e) {
	         e.printStackTrace();
	         res = 0;
	     	 conn.rollback();
	      }finally {
	         pstm.close();
	         conn.setAutoCommit(true);
	      }
	      closeConnection();
	      return res;
	}
	
	public List<Insa_Rc_BnBean> selectInsaAllBn() throws SQLException{
		//테이블 INSA_RC_BENEFIT
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      List<Insa_Rc_BnBean> res=new ArrayList<Insa_Rc_BnBean>();
	      
	      String sql=
	            "  SELECT "
	               + " a.reg_id,"
	               + "a.rc_no,"
	               + "a.rc_bene_cont, a.rc_bene_st, b.rc_nm "
	               + " FROM INSA_RC_BENEFIT a, insa_rc_code b where a.rc_bene_st = b.rc_code and b.rc_gubun = '1'  ORDER BY a.rC_NO" ;

	      try {
	         pstm=conn.prepareStatement(sql);
	         rs=pstm.executeQuery();
	         
	         while(rs.next()) {
	        	Insa_Rc_BnBean tmp= new Insa_Rc_BnBean();
	            tmp.setReg_id(rs.getString(1));
	            tmp.setRc_no(rs.getInt(2));
	            tmp.setRc_bene_cont(rs.getString(3));
	            tmp.setRc_bene_st(rs.getString(4));
	            tmp.setRc_nm(rs.getString(5));

	            res.add(tmp);
	         }

	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	         rs.close();
	         pstm.close();
	         closeConnection();
	      }
	      return res;
	   }

	public Insa_Rc_BnBean InsaBnselectOne(int rc_no) throws SQLException {
		//테이블 INSA_RC_INFO
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      Insa_Rc_BnBean res=new Insa_Rc_BnBean();
	      
	      String sql=" SELECT * FROM INSA_RC_BENEFIT WHERE RC_NO= ?";
	      
	      try {
	         pstm=conn.prepareStatement(sql);
	         pstm.setInt(1, rc_no);
	         rs=pstm.executeQuery();
	         while(rs.next()) {
	            res.setReg_id(rs.getString(1));
	            res.setRc_no(rs.getInt(2));
	            res.setRc_bene_cont(rs.getString(3));
	            res.setRc_bene_st(rs.getString(4));
	         }
	         
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	    	  rs.close();
		      pstm.close();
		      closeConnection();
	      }
	      return res;
	   }
	
	public Insa_Rc_BnBean InsaBnselectOneSt(String rc_bene_st) throws SQLException {
		//테이블 INSA_RC_INFO
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      Insa_Rc_BnBean res=new Insa_Rc_BnBean();
	      
	      String sql=" SELECT * FROM INSA_RC_BENEFIT WHERE rc_bene_st= ?";
	      
	      try {
	         pstm=conn.prepareStatement(sql);
	         pstm.setString(1, rc_bene_st);
	         rs=pstm.executeQuery();
	         while(rs.next()) {
	            res.setReg_id(rs.getString(1));
	            res.setRc_no(rs.getInt(2));
	            res.setRc_bene_cont(rs.getString(3));
	            res.setRc_bene_st(rs.getString(4));
	         }
	         
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	    	  rs.close();
		      pstm.close();
		      closeConnection();
	      }
	      return res;
	   }	
 
	public int bnUpdate(Insa_Rc_BnBean infoBean) throws SQLException {
	      getConnection();
	      PreparedStatement pstm=null;
	      int res=0;
	     

	      String sql="UPDATE INSA_RC_BENEFIT "
	      		+ "SET RC_BENE_CONT=?, RC_BENE_ST=? "
	      		+ " WHERE RC_NO=? ";
	      
	      try {
	    	  conn.setAutoCommit(false);
	    	  
	         pstm=conn.prepareStatement(sql);
	         pstm.setString(1,infoBean.getRc_bene_cont().trim());
	         pstm.setString(2,infoBean.getRc_bene_st().trim());
	         pstm.setInt(3, infoBean.getRc_no());
	         res=pstm.executeUpdate();
	         
	         if(res>0) {
	        	 conn.commit();
	         }
	      } catch (SQLException e) {
	         e.printStackTrace();
	         res = 0;
	     	 conn.rollback();
	      }finally {
	         pstm.close();
	         closeConnection();
	      }
	      return res;
	   }		
	
	public int bnInsert(Insa_Rc_BnBean infoBean)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int res=0;
		
		String query = " insert into INSA_RC_BENEFIT \n"+
				" (REG_ID,\r\n"
				+ "       RC_NO,\r\n"
				+ "       RC_BENE_CONT,\r\n"
				+ "       RC_BENE_ST\r\n"+
				" ) values ("+
				" ?,?,?,?"+
				" )";	
		
		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,infoBean.getReg_id());
			pstmt.setInt(2,infoBean.getRc_no());
			pstmt.setString(3,infoBean.getRc_bene_cont().trim());
			pstmt.setString(4,infoBean.getRc_bene_st().trim());				        						
		   	pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			res=1;
		    
	  	} catch (Exception e) {
			e.printStackTrace();
			res=0;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return res;
		}
	}		
	//채용공고 완료--------------------------------------------------------------------------------------------------------------------------

	




	


	/*2021-07-02 인사관리>조직관리>채용공고*/
	public Vector InsaRecruit(String user_id, String auth_rw)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
				 query = "SELECT a.USER_ID,\n"
	    				+ " a.BR_ID,\n"
	    				+ " b.BR_NM,\n"
	    				+ " a.USER_NM,\n"
	    				+ " a.ID,\n"
	    				+ " a.USER_PSD,\n"
	    				+ " a.USER_CD,\n"
	    				+ "  text_decrypt(a.user_ssn, 'pw' ) USER_SSN,\n"
	    				+ " a.DEPT_ID,\n"
	    				+ " c.NM AS DEPT_NM,\n"
	    				+ " a.USER_H_TEL,\n"
	    				+ " a.USER_M_TEL,\n"
						+ " a.IN_TEL,\n"
						+ " a.HOT_TEL,\n"		
	    				+ " a.USER_EMAIL,\n"
	    				+ " a.USER_POS,\n"
	    				+ " a.addr, \n"
						+ " a.use_yn, a.user_work, a.user_i_tel,  pp.jg_dt,  pp.pos , \n"
						+ " TRUNC(TO_DATE(r.enter_dt, 'YYYYMMDD')/12) e_year ,    \n"
					 	+ " TRUNC(TO_DATE(r.enter_dt, 'YYYYMMDD') -   "
						+ " TRUNC(TO_DATE(r.enter_dt, 'YYYYMMDD')/12) * 12) e_month \n"
			    		+ " FROM USERS a, BRANCH b, (select * from CODE where c_st='0002') c,  \n "
		        		+ "      ( select*from insa_rc r,) rr  \n"
		  				+ "where a.BR_ID = b.BR_ID and a.user_id  = rr.reg_id(+)  \n"
	    				+ "and a.DEPT_ID = c.CODE(+) and a.user_pos in ('대표이사','감사','팀장', '이사', '부장', '차장', '과장','대리','사원','인턴사원') \n"
	    				+ "and nvl(a.use_yn,'Y')='Y' and a.dept_id not in ( '1000', '8888') \n"
		  				+ "and a.id not like 'develop%' and a.USER_ID NOT IN ('000177')"	//	조민규님,외부개발자 3명은 리스트에서 제외/ 임원(감사)은 추가(20181113)
		  				+ "	";
	
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
			System.out.println("[InsaCardDatabase:InsaCard]"+e);
			System.out.println("[InsaCardDatabase:InsaCard]"+query);
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
	
	public List<Insa_Rc_rcBean> selectInsaRcAll() throws SQLException{
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      List<Insa_Rc_rcBean> res=new ArrayList<Insa_Rc_rcBean>();
	      
	      String sql=" SELECT R.reg_id, R.rc_no, U.USER_NM AS rc_name, R.rc_title,\r\n"
	    		  + "	      R.rc_branch,R.rc_type,R.rc_hire_per,R.rc_bran_addr,\r\n"
	    		  + "	      R.rc_bran_tel,R.rc_job_contA,R.rc_job_contB,R.rc_job_contC,R.rc_job_contD,\r\n"
	    		  + "	      R.rc_apl_st_dt, R.rc_apl_ed_dt,\r\n"
	    		  + "	      R.rc_pass_dt, R.rc_apl_mat,R.rc_manager,R.rc_tel, R.rc_reg_dt, R.rc_edu , C.RC_NM \r\n"
	    		  + "  FROM INSA_RC_RECRUIT R, USERS U , INSA_RC_CODE C \r\n"
	    		  + "  WHERE R.REG_ID=U.USER_ID AND R.Rc_TYPE= C.RC_CODE AND C.RC_GUBUN = '1' \r\n"
	    		  + "  ORDER BY RC_NO DESC" ;

	      try {
	         pstm=conn.prepareStatement(sql); 
	         rs=pstm.executeQuery();
	         while(rs.next()) {
	        	 Insa_Rc_rcBean tmp= new Insa_Rc_rcBean();
		         tmp.setReg_id(rs.getString(1));
		         tmp.setRc_no(rs.getInt(2));
		         tmp.setReg_name(rs.getString(3));
		         tmp.setRc_title(rs.getString(4));
		         tmp.setRc_branch(rs.getString(5));
		         tmp.setRc_type(rs.getString(6));
		         tmp.setRc_hire_per(rs.getInt(7));
		         tmp.setRc_bran_addr(rs.getString(8));
		         tmp.setRc_bran_tel(rs.getString(9));
		         tmp.setRc_job_contA(rs.getString(10));
		         tmp.setRc_job_contB(rs.getString(11));
		         tmp.setRc_job_contC(rs.getString(12));
		         tmp.setRc_job_contD(rs.getString(13));
		         tmp.setRc_apl_st_dt(rs.getString(14));
		         tmp.setRc_apl_ed_dt(rs.getString(15));
		         tmp.setRc_pass_dt(rs.getString(16));
		         tmp.setRc_apl_mat(rs.getString(17));
		         tmp.setRc_manager(rs.getString(18));
		         tmp.setRc_tel(rs.getString(19));
		         tmp.setRc_reg_dt(rs.getDate(20));
		         tmp.setRc_edu(rs.getString(21));
		         tmp.setRc_nm(rs.getString(22));
		         res.add(tmp);	 
	         }
	      } catch (SQLException e) {
	    	  e.printStackTrace();
	         
	      }finally {
	         rs.close();
	         pstm.close();
	         closeConnection();
	      }
	      return res;
	   }
	
	public int listCount(Insa_Rc_SearchCriteria scri)  {
        getConnection();
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        int res = 0;
        
        String sql = " SELECT COUNT(rc_no) "
              + " FROM INSA_RC_RECRUIT "
              + " WHERE 1=1 "
              + " AND rc_no > 0 "
              + " ORDER BY rc_no DESC ";
        System.out.println(sql);
        try {
           pstm = conn.prepareStatement(sql);
     //      System.out.println("03.query 준비: " + sql);
           
           rs = pstm.executeQuery();
      //     System.out.println("04.query 실행 및 리턴");
           
           if(rs.next()) {
              res = rs.getInt(1);
           }
           
        } catch (SQLException e) {
       //    System.out.println("03/04 단계 에러");
           e.printStackTrace();
        }finally {
			try {
				if(rs!=null) {rs.close();}
				if(pstm!=null) {pstm.close();}				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        //   System.out.println("05.db 종료\n");
        }
        closeConnection();
        return res;
     }
  

	public Insa_Rc_rcBean InsaRecselectOne(int rc_no) throws SQLException {
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      Insa_Rc_rcBean res=new Insa_Rc_rcBean();
	      
	      String sql=
	      	" SELECT " + 
	      		"R.reg_id," + 
	      		"R.rc_no," + 
	      		"U.USER_NM AS rc_name, " + 
	      		"R.rc_title, " + 
	      		"R.rc_branch," + 
	      		"R.rc_type," + 
	      		"R.rc_hire_per," + 
	      		"R.rc_bran_addr," + 
	      		"R.rc_bran_tel," + 
	      		"R.rc_job_contA," + 
	      		"R.rc_job_contB," + 
	      		"R.rc_job_contC," + 
	      		"R.rc_job_contD," + 
	      		"R.rc_apl_st_dt," + 
	      		"R.rc_apl_ed_dt," + 
	      		"R.rc_pass_dt," + 
	      		"R.rc_apl_mat," + 
	      		"R.rc_manager," + 
	      		"R.rc_tel," + 
	      		"R.rc_reg_dt," +
	      		"R.rc_edu, c.rc_nm  , e.rc_nm edu_nm " +
	      	" FROM INSA_RC_RECRUIT R , (select * from insa_rc_code where rc_gubun = '1')  c ,  USERS U , (select * from insa_rc_code where rc_gubun = '2')  e " + 
	      	" WHERE R.REG_ID=U.USER_ID and R.rc_type = c.rc_code and  r.rc_edu = e.rc_code(+) " +
	      	" and  r.RC_NO= ? ";
	      
	      try {
	         pstm=conn.prepareStatement(sql);
	         pstm.setInt(1, rc_no);
	         rs=pstm.executeQuery();
	         
	         while(rs.next()) {
	        	    res.setReg_id(rs.getString(1));
	        	    res.setRc_no(rs.getInt(2));
	        	    res.setReg_name(rs.getString(3));
	        	    res.setRc_title(rs.getString(4));
	        	    res.setRc_branch(rs.getString(5));
	        	    res.setRc_type(rs.getString(6));
	        	    res.setRc_hire_per(rs.getInt(7));
	        	    res.setRc_bran_addr(rs.getString(8));
	        	    res.setRc_bran_tel(rs.getString(9));
	        	    res.setRc_job_contA(rs.getString(10));
	        	    res.setRc_job_contB(rs.getString(11));
	        	    res.setRc_job_contC(rs.getString(12));
	        	    res.setRc_job_contD(rs.getString(13));
	        	    res.setRc_apl_st_dt(rs.getString(14));
	        	    res.setRc_apl_ed_dt(rs.getString(15));
	        	    res.setRc_pass_dt(rs.getString(16));
	        	    res.setRc_apl_mat(rs.getString(17));
	        	    res.setRc_manager(rs.getString(18));
	        	    res.setRc_tel(rs.getString(19));
	        	    res.setRc_reg_dt(rs.getDate(20));
	        	    res.setRc_edu(rs.getString(21));
	        	    res.setRc_nm(rs.getString(22));
	        	    res.setEdu_nm(rs.getString(23));
	         }
	         
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	    	  rs.close();
		      pstm.close();
		      closeConnection();
	      }
	      return res;
	   }
	
	 public int InsaDelete(int rc_no, String table_nm) throws SQLException {
         getConnection(); 
         PreparedStatement pstm = null;
         int res = 0;
         
         String sql = "DELETE FROM "+ table_nm+ " WHERE RC_NO=?";
         
         try {
       	    conn.setAutoCommit(false);
            pstm = conn.prepareStatement(sql);
            pstm.setInt(1, rc_no);
            
            res = pstm.executeUpdate();
            
            if(res>0) {
            	conn.commit();
            }
            
         } catch (SQLException e) {
            e.printStackTrace();
            conn.rollback();
         }finally {
        	 pstm.close();
        	 closeConnection();
         }
         return res;
      }
	 
	 public int InsaCodeDelete(String rc_gubun, String rc_code) throws SQLException {
         getConnection(); 
         PreparedStatement pstm = null;
         int res = 0;
         
         String sql = "DELETE FROM INSA_RC_CODE WHERE rc_gubun=? and rc_code=? ";
         
         try {
       	    conn.setAutoCommit(false);
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, rc_gubun);
            pstm.setString(2, rc_code);
            
            res = pstm.executeUpdate();
            
            if(res>0) {
            	conn.commit();
            }
            
         } catch (SQLException e) {
            e.printStackTrace();
            conn.rollback();
         }finally {
        	 pstm.close();
        	 closeConnection();
         }
         return res;
      }

	 public int InsaRcMultiDelete(String[] rc_no) throws SQLException {
	      getConnection();
	      PreparedStatement pstm=null;
	      int res=0;
	      int[] cnt=null;
	      
	      String sql="DELETE FROM INSA_RC_RECRUIT WHERE RC_NO=?";
	      
	      try {
	    	  conn.setAutoCommit(false);
	         pstm=conn.prepareStatement(sql);
	         
	         for( int i=0; i<rc_no.length; i++) {
	            pstm.setString(1,rc_no[i]);
	            pstm.addBatch();
	         }
	         cnt=pstm.executeBatch();
	         
	         for(int i=0; i<cnt.length; i++) {
	            if(cnt[i]==-2) { 
	               res++;
	            }
	         }
	         
	         if(res==rc_no.length) {
	            conn.commit();
	         }
	      } catch (SQLException e) {
	         e.printStackTrace();
	         conn.rollback();
	      }finally {
	    	  pstm.close();
	    	  closeConnection();
	      }
	      
	      return res;
	   }
 
	
	public List<Insa_Rc_QfBean> selectInsaAllQf() throws SQLException{
		//테이블 INSA_RC_QF
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      List<Insa_Rc_QfBean> res=new ArrayList<Insa_Rc_QfBean>();
	      
	      String sql=
	            "  SELECT "
	               + "a.reg_id,"
	               + "a.rc_no,"
	               + "a.rc_edu,"
	               + "a.rc_qf_var1, a.rc_qf_var2, a.rc_qf_var3, a.rc_qf_var4, a.rc_qf_var5, a.rc_qf_var6, a.rc_qf_var7, a.rc_qf_var8, a.rc_qf_var9, "
	               + "b.rc_nm "
	               + " FROM INSA_RC_QF a, insa_rc_code b where a.rc_edu = b.rc_code and b.rc_gubun = '2' ORDER BY a.RC_NO " ;

	      try {
	         pstm=conn.prepareStatement(sql);
	         rs=pstm.executeQuery();
	         
	         while(rs.next()) {
	        	Insa_Rc_QfBean tmp= new Insa_Rc_QfBean();
	            tmp.setReg_id(rs.getString(1));
	            tmp.setRc_no(rs.getInt(2));
	            tmp.setRc_edu(rs.getString(3));	            
	            tmp.setRc_qf_var1(rs.getString(4));
	            tmp.setRc_qf_var2(rs.getString(5));
	            tmp.setRc_qf_var3(rs.getString(6));
	            tmp.setRc_qf_var4(rs.getString(7));
	            tmp.setRc_qf_var5(rs.getString(8));
	            tmp.setRc_qf_var6(rs.getString(9));
	            tmp.setRc_qf_var7(rs.getString(10));
	            tmp.setRc_qf_var8(rs.getString(11));
	            tmp.setRc_qf_var9(rs.getString(12));
	            tmp.setRc_nm(rs.getString(13));
	            res.add(tmp);
	         }
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	         rs.close();
	         pstm.close();
	         closeConnection();
	      }
	      return res;
	   }
	
	
	public Insa_Rc_QfBean InsaQfselectOne(int rc_no) throws SQLException {
		//테이블 INSA_RC_INFO
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      Insa_Rc_QfBean res=new Insa_Rc_QfBean();
	      
	      String sql=" SELECT * FROM INSA_RC_QF WHERE RC_NO= ?";
	      
	      try {
	         pstm=conn.prepareStatement(sql);
	         pstm.setInt(1, rc_no);
	         rs=pstm.executeQuery();
	         
	         while(rs.next()) {
	            res.setReg_id(rs.getString(1));
	            res.setRc_no(rs.getInt(2));
	            res.setRc_edu(rs.getString(3));
	            res.setRc_qf_var1(rs.getString(4));
	            res.setRc_qf_var2(rs.getString(5));
	            res.setRc_qf_var3(rs.getString(6));
	            res.setRc_qf_var4(rs.getString(7));
	            res.setRc_qf_var5(rs.getString(8));
	            res.setRc_qf_var6(rs.getString(9));
	            res.setRc_qf_var7(rs.getString(10));
	            res.setRc_qf_var8(rs.getString(11));
	            res.setRc_qf_var9(rs.getString(12));
	         }
	         
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	    	  rs.close();
		      pstm.close();
		      closeConnection();
	      }
	      return res;
	   }
	
	public Insa_Rc_QfBean InsaQfselectOne2(String rc_edu) throws SQLException {
		//테이블 INSA_RC_INFO
	      getConnection();
	      PreparedStatement pstm=null;
	      ResultSet rs=null;
	      Insa_Rc_QfBean res=new Insa_Rc_QfBean();
	      
	      String sql=" SELECT * FROM INSA_RC_QF WHERE rc_edu= ?";
	      
	      try {
	         pstm=conn.prepareStatement(sql);
	         pstm.setString(1, rc_edu);
	         rs=pstm.executeQuery();
	         
	         while(rs.next()) {
	            res.setReg_id(rs.getString(1));
	            res.setRc_no(rs.getInt(2));
	            res.setRc_edu(rs.getString(3));
	            res.setRc_qf_var1(rs.getString(4));
	            res.setRc_qf_var2(rs.getString(5));
	            res.setRc_qf_var3(rs.getString(6));
	            res.setRc_qf_var4(rs.getString(7));
	            res.setRc_qf_var5(rs.getString(8));
	            res.setRc_qf_var6(rs.getString(9));
	            res.setRc_qf_var7(rs.getString(10));
	            res.setRc_qf_var8(rs.getString(11));
	            res.setRc_qf_var9(rs.getString(12));
	         }
	         
	      } catch (SQLException e) {
	         e.printStackTrace();
	      }finally {
	    	  rs.close();
		      pstm.close();
		      closeConnection();
	      }
	      return res;
	   }	

	public int QfUpdate(Insa_Rc_QfBean qbBean) throws SQLException {
	      getConnection();
	      PreparedStatement pstm=null;
	      int res=0;

	      String sql="UPDATE INSA_RC_QF "
	      		+ "SET RC_EDU=?, rc_qf_var1=?,rc_qf_var2=?,rc_qf_var3=?,rc_qf_var4=?,rc_qf_var5=?,rc_qf_var6=?,rc_qf_var7=?,rc_qf_var8=?,rc_qf_var9=? "
	      		+ " WHERE RC_NO=? ";
	      
	      try {
	    	  conn.setAutoCommit(false);
	    	  
	         pstm=conn.prepareStatement(sql);
	         pstm.setString(1,qbBean.getRc_edu());
	         pstm.setString(2,qbBean.getRc_qf_var1());
	         pstm.setString(3,qbBean.getRc_qf_var2());
	         pstm.setString(4,qbBean.getRc_qf_var3());
	         pstm.setString(5,qbBean.getRc_qf_var4());
	         pstm.setString(6,qbBean.getRc_qf_var5());
	         pstm.setString(7,qbBean.getRc_qf_var6());
	         pstm.setString(8,qbBean.getRc_qf_var7());
	         pstm.setString(9,qbBean.getRc_qf_var8());
	         pstm.setString(10,qbBean.getRc_qf_var9());
	         pstm.setInt(11, qbBean.getRc_no());
	         res=pstm.executeUpdate();
	         
	         if(res>0) {
	        	 conn.commit();
	         }
	         System.out.println("QfUpdate res"+res);
	      } catch (SQLException e) {
	         e.printStackTrace();
	         res = 0;
	     	 conn.rollback();
	      }finally {
	         pstm.close();
	         closeConnection();
	      }
	      return res;
	   }
	
	public int QfInsert(Insa_Rc_QfBean qbBean) throws SQLException {
	      getConnection();
	      PreparedStatement pstm=null;
	      int res=0;

	      String sql="INSERT INTO INSA_RC_QF (reg_id,rc_no,rc_edu,rc_qf_var1,rc_qf_var2,rc_qf_var3,rc_qf_var4,rc_qf_var5,rc_qf_var6,rc_qf_var7,rc_qf_var8,rc_qf_var9) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
	      
	      try {
	    	  conn.setAutoCommit(false);
	    	  
	         pstm=conn.prepareStatement(sql);
	         pstm.setString(1,qbBean.getReg_id());
	         pstm.setInt(2,qbBean.getRc_no());
	         pstm.setString(3,qbBean.getRc_edu());	         
	    	 pstm.setString(4,qbBean.getRc_qf_var1());
	         pstm.setString(5,qbBean.getRc_qf_var2());
	         pstm.setString(6,qbBean.getRc_qf_var3());
	         pstm.setString(7,qbBean.getRc_qf_var4());
	         pstm.setString(8,qbBean.getRc_qf_var5());
	         pstm.setString(9,qbBean.getRc_qf_var6());
	         pstm.setString(10,qbBean.getRc_qf_var7());
	         pstm.setString(11,qbBean.getRc_qf_var8());
	         pstm.setString(12,qbBean.getRc_qf_var9());
	         res=pstm.executeUpdate();
	         pstm.close();
	         
	         if(res>0) {
	        	 conn.commit();
	         }
	         System.out.println("QfInsert res"+res);
	      } catch (SQLException e) {
	         e.printStackTrace();
	         res = 0;
	     	 conn.rollback();
	      }finally {
	         pstm.close();
	         closeConnection();
	      }
	      return res;
	   }
	
	public int RcUpdate(Insa_Rc_rcBean rcBean) throws SQLException {
	      getConnection();
	      PreparedStatement pstm=null;
	      int res=0;

	      String sql="UPDATE INSA_RC_RECRUIT "
	      		+ "SET rc_branch=?, rc_type=?, rc_hire_per=?, rc_apl_ed_dt=replace(?,'-',''), rc_pass_dt=replace(?,'-',''), rc_apl_mat=?, rc_manager=?, rc_tel=?, rc_edu=? "
	      		+ " WHERE RC_NO=? ";
	      
	      try {
	    	  conn.setAutoCommit(false);
	    	  
	         pstm=conn.prepareStatement(sql);

	         pstm.setString(1,rcBean.getRc_branch());
	         pstm.setString(2,rcBean.getRc_type());
	         pstm.setInt(3, rcBean.getRc_hire_per());	         
	         pstm.setString(4,rcBean.getRc_apl_ed_dt());
	         pstm.setString(5,rcBean.getRc_pass_dt());
	         pstm.setString(6,rcBean.getRc_apl_mat());
	         pstm.setString(7,rcBean.getRc_manager());
	         pstm.setString(8,rcBean.getRc_tel());
	         pstm.setString(9,rcBean.getRc_edu());	         
	         pstm.setInt(10, rcBean.getRc_no());
	         res=pstm.executeUpdate();
	         
	         if(res>0) {
	        	 conn.commit();
	         }
	      
	      } catch (SQLException e) {
	         e.printStackTrace();
	         res = 0;
	     	 conn.rollback();
	      }finally {
	         pstm.close();
	         closeConnection();
	      }
	      return res;
	   }
	
		public int RcInsert(Insa_Rc_rcBean rcBean) throws SQLException {
	      getConnection();
	      PreparedStatement pstm=null;
	      int res=0;

	      String sql="INSERT INTO INSA_RC_RECRUIT (reg_id, rc_no, rc_branch, rc_type, rc_hire_per, rc_apl_ed_dt, rc_pass_dt, rc_apl_mat, rc_manager, rc_tel, rc_edu, rc_reg_dt) VALUES(?,?,?,?,?,?,?,?,?,?,?,sysdate)";
	      
	      try {
	    	  conn.setAutoCommit(false);
	    	  
	         pstm=conn.prepareStatement(sql);
	         
	         pstm.setString(1,rcBean.getReg_id());
	         pstm.setInt(2,rcBean.getRc_no());
	         pstm.setString(3,rcBean.getRc_branch());
	         pstm.setString(4,rcBean.getRc_type());
	         pstm.setInt(5, rcBean.getRc_hire_per());	         
	         pstm.setString(6,rcBean.getRc_apl_ed_dt());
	         pstm.setString(7,rcBean.getRc_pass_dt());
	         pstm.setString(8,rcBean.getRc_apl_mat());
	         pstm.setString(9,rcBean.getRc_manager());
	         pstm.setString(10,rcBean.getRc_tel());
	         pstm.setString(11,rcBean.getRc_edu());	         
	         
	         res=pstm.executeUpdate();
	         pstm.close();
	         
	         if(res>0) {
	        	 conn.commit();
	         }
	         System.out.println("RcInsert res"+res);
	      } catch (SQLException e) {
	         e.printStackTrace();
	         res = 0;
	     	 conn.rollback();
	      }finally {
	         pstm.close();
	         closeConnection();
	      }
	      return res;
	   }
	
	

		//청구서작성 리스트 조회
		public Vector getList(String gubun)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			query = " select a.* "+
					" from INSA_RC_CODE a "+		
					" where a.rc_gubun='"+gubun+ "'"; 	
			query += " order by 1, 2 ";
				
				
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
				System.out.println("[InsaRcDatabase:getList]\n"+e);
				System.out.println("[InsaRcDatabase:getList]\n"+query);
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
				public Hashtable getCodeCase(String gubun, String code)
				{
					getConnection();
					PreparedStatement pstmt = null;
					ResultSet rs = null;					
					String query = "";
					Hashtable ht = new Hashtable();

					query = " select a.* "+
							" from INSA_RC_CODE a "+		
							" where a.rc_gubun='"+gubun+ "' and a.rc_code ='"+code+"'"; 	
					
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
						System.out.println("[InsaRcDatabase:getCodeCase]\n"+e);
						System.out.println("[InsaRcDatabase:getCodeCase]\n"+query);
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
				
				public int CodeUpdate(String rc_gubun, String rc_code, String rc_nm) throws SQLException {
				      getConnection();
				      PreparedStatement pstm=null;
				      int res=0;

				      String sql="UPDATE INSA_RC_CODE "
				      		+ "SET rc_nm=? "
				      		+ " WHERE rc_gubun=? and RC_code=? ";
				      
				      try {
				    	  conn.setAutoCommit(false);
				    	  
				         pstm=conn.prepareStatement(sql);

				         pstm.setString(1,rc_nm);
				         pstm.setString(2,rc_gubun);				         	        
				         pstm.setString(3,rc_code);
				         res=pstm.executeUpdate();
				         
				         if(res>0) {
				        	 conn.commit();
				         }
				      
				      } catch (SQLException e) {
				         e.printStackTrace();
				         res = 0;
				     	 conn.rollback();
				      }finally {
				         pstm.close();
				         closeConnection();
				      }
				      return res;
				   }
				
					public int CodeInsert(String rc_gubun, String rc_code, String rc_nm) throws SQLException {
				      getConnection();
				      PreparedStatement pstm=null;
				      int res=0;

				      String sql="INSERT INTO INSA_RC_CODE (rc_gubun, rc_code, rc_nm) VALUES(?,?,?)";
				      
				      try {
				    	  conn.setAutoCommit(false);
				    	  
				         pstm=conn.prepareStatement(sql);
				         pstm.setString(1,rc_gubun);				         	        
				         pstm.setString(2,rc_code);
				         pstm.setString(3,rc_nm);
				         res=pstm.executeUpdate();
				         pstm.close();
				         
				         if(res>0) {
				        	 conn.commit();
				         }
				         System.out.println("CodeInsert res"+res);
				      } catch (SQLException e) {
				         e.printStackTrace();
				         res = 0;
				     	 conn.rollback();
				      }finally {
				         pstm.close();
				         closeConnection();
				      }
				      return res;
				   }
								

	
}