package acar.cont;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;


public class LcScanDatabase
{
	private Connection conn = null;
	public static LcScanDatabase db;
	
	public static LcScanDatabase getInstance()
	{
		if(LcScanDatabase.db == null)
			LcScanDatabase.db = new LcScanDatabase();
		return LcScanDatabase.db;
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


	//select-----------------------------------------------------------------------------------------------------------------------------------------

	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean[] getLcScanList(String rent_mng_id, String rent_l_cd)
	{
		getConnection();

		Collection<LcScanBean> col = new ArrayList<LcScanBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM lc_scan WHERE rent_mng_id=? AND rent_l_cd=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				LcScanBean bean = new LcScanBean();
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
				col.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScan]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return (LcScanBean[])col.toArray(new LcScanBean[0]);
		}				
	}


	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean getLcScan(String rent_mng_id, String rent_l_cd, String seq)
	{
		getConnection();

		LcScanBean bean = new LcScanBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM lc_scan WHERE rent_mng_id=? AND rent_l_cd=? AND seq=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, seq);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScan]\n"+e);
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



	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean getLcScanCase(String rent_mng_id, String rent_l_cd, String file_st)
	{
		getConnection();

		LcScanBean bean = new LcScanBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM lc_scan WHERE rent_mng_id=? AND rent_l_cd=? AND file_st=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, file_st);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScan]\n"+e);
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

	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean getLcScanCase2(String rent_mng_id, String rent_l_cd, String file_st, String rent_st)
	{
		getConnection();

		LcScanBean bean = new LcScanBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM lc_scan WHERE rent_mng_id=? AND rent_l_cd=? AND file_st=? AND nvl(rent_st,'1')=? ";

		if(file_st.equals("17") || file_st.equals("18") || file_st.equals("2") || file_st.equals("4")){
			query += " AND LOWER(file_type) = '.jpg' ";		
		}

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, file_st);
			pstmt.setString(4, rent_st);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScan2]\n"+e);
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

	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean getScScanCase2(String car_mng_id, String rent_s_cd, String file_st, String rent_st)
	{
		getConnection();

		LcScanBean bean = new LcScanBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM sc_scan WHERE car_mng_id=? AND rent_s_cd=? AND file_st=? AND nvl(rent_st,'1')=? ";

		if(file_st.equals("1") || file_st.equals("2")){
			query += " AND LOWER(file_type) = '.jpg' ";		
		}

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, rent_s_cd);
			pstmt.setString(3, file_st);
			pstmt.setString(4, rent_st);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getScScanCase2]\n"+e);
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

	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean getLcScanCase(String rent_mng_id, String rent_l_cd, String file_st, String file_cont)
	{
		getConnection();

		LcScanBean bean = new LcScanBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM lc_scan WHERE rent_mng_id=? AND rent_l_cd=? AND file_st=?";
		
		if(!file_cont.equals(""))	query += " AND file_cont like '%"+file_cont+"%'";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, file_st);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScan]\n"+e);
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

	/*계약관련 스캔파일(LC_SCAN 테이블) 최근 파일 조회*/
	public LcScanBean[] getLcScanList(String client_id)
	{
		getConnection();

		Collection<LcScanBean> col = new ArrayList<LcScanBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String query = "";
		String a_table = "";
		String b_table = "";

		/* 
 		query = "  select a.*, b.client_id "+
				"  from   lc_scan a, cont c , ( select b.client_id, a.file_st, max(a.reg_dt||a.rent_mng_id) max_scan from lc_scan a, cont b where a.rent_l_cd=b.rent_l_cd and b.client_id=?  and b.rent_l_cd not like 'RM%'  group by b.client_id, a.file_st) b \n"+
 			    "  where  a.rent_l_cd=c.rent_l_cd and a.file_st in ('2','3','4','6','7','8') and c.rent_l_cd not like 'RM%'  \n"+
			    "         and c.client_id=b.client_id and a.file_st=b.file_st and a.reg_dt||a.rent_mng_id=b.max_scan";
        */

		query = " SELECT * FROM lc_scan WHERE rent_mng_id=?"; //미사용
    
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client_id);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				LcScanBean bean = new LcScanBean();
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
				col.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScanList]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return (LcScanBean[])col.toArray(new LcScanBean[0]);
		}				
	}

	/*계약관련 스캔파일(LC_SCAN 테이블) 고객관련 모든 파일 조회*/
	public LcScanBean[] getLcScanClientList(String client_id)
	{
		getConnection();

		Collection<LcScanBean> col = new ArrayList<LcScanBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String query = "";

		query = " select a.*, b.rent_dt from lc_scan a, cont b "+
				" where b.client_id=? and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and b.rent_l_cd not like 'RM%' order by b.rent_dt, b.rent_l_cd, a.file_st, a.file_name";


		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client_id);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				LcScanBean bean = new LcScanBean();
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
//				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
				bean.setUpd_dt		(rs.getString(14));
				col.add(bean);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScanClientList]\n"+e);
			System.out.println("[LcScanDatabase:getLcScanClientList]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return (LcScanBean[])col.toArray(new LcScanBean[0]);
		}				
	}

	//insert-----------------------------------------------------------------------------------------------------------------------------------------

	public String getSeqNext(String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String item_id = "";
		String query = "";

		query = " select nvl(ltrim(to_char(to_number(max(seq)+1), '00')), '01') seq"+
				" from lc_scan "+
				" where rent_l_cd='"+l_cd+"'";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				item_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getSeqNext]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return item_id;
		}		
	}

	/*계약관련서류 스캔파일(LC_SCAN 테이블) 등록*/
	public int insertLcScan(LcScanBean bean)
	{
		getConnection();

		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " INSERT INTO lc_scan"+
				" (rent_mng_id, rent_l_cd, seq, file_st, file_cont, file_name, reg_id, reg_dt, upd_id, upd_dt, file_path, file_type, rent_st)"+
				" VALUES "+
				" (?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?) ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getRent_mng_id	());
			pstmt.setString	(2,		bean.getRent_l_cd	());
			pstmt.setString	(3,		bean.getSeq			());
			pstmt.setString	(4,		bean.getFile_st		());
			pstmt.setString	(5,		bean.getFile_cont	());
			pstmt.setString	(6,		bean.getFile_name	());
			pstmt.setString	(7,		bean.getReg_id		());
			pstmt.setString	(8,		bean.getUpd_id		());
			pstmt.setString	(9,		bean.getUpd_dt		());
			pstmt.setString	(10,	bean.getFile_path	());
			pstmt.setString	(11,	bean.getFile_type	());
			pstmt.setString	(12,	bean.getRent_st		());

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[LcScanDatabase:insertLcScan]\n"+e);

			System.out.println("[bean.getRent_mng_id	()]\n"+bean.getRent_mng_id	());
			System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
			System.out.println("[bean.getSeq			()]\n"+bean.getSeq			());
			System.out.println("[bean.getFile_st		()]\n"+bean.getFile_st		());
			System.out.println("[bean.getFile_cont		()]\n"+bean.getFile_cont	());
			System.out.println("[bean.getFile_name		()]\n"+bean.getFile_name	());
			System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id		());
			System.out.println("[bean.getUpd_id			()]\n"+bean.getUpd_id		());
			System.out.println("[bean.getUpd_dt			()]\n"+bean.getUpd_dt		());
			System.out.println("[bean.getFile_path		()]\n"+bean.getFile_path	());
			System.out.println("[bean.getFile_type		()]\n"+bean.getFile_type	());
			System.out.println("[bean.getRent_st		()]\n"+bean.getRent_st		());

			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	//update-----------------------------------------------------------------------------------------------------------------------------------------

	/*차명 기본정보(LC_SCAN 테이블) 한건 수정*/
	public int updateLcScan(LcScanBean bean)
	{
		getConnection();

		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";

		query = " UPDATE lc_scan SET "+
			"	file_cont	= ?, "+
			"	file_name	= ?, "+
			"	upd_id		= ?, "+
			"	upd_dt		= to_char(sysdate,'YYYYMMDD'), "+
			"	file_path	= ?, "+
			"	file_type	= ? "+
			" WHERE	rent_mng_id	= ?	AND rent_l_cd = ? AND seq = ? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getFile_cont	()	);
			pstmt.setString	(2,		bean.getFile_name	()	);
			pstmt.setString	(3,		bean.getUpd_id		()	);
			pstmt.setString	(4,		bean.getFile_path	()	);
			pstmt.setString	(5,		bean.getFile_type	()	);
			pstmt.setString	(6,		bean.getRent_mng_id	()	);
			pstmt.setString	(7,		bean.getRent_l_cd	()	);
			pstmt.setString	(8,		bean.getSeq			()	);

		    result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[LcScanDatabase:updateLcScan]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}		

	/*차명 기본정보(LC_SCAN 테이블) 한건 수정*/
	public int updateLcScanEtc(LcScanBean bean)
	{
		getConnection();

		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";

		query = " UPDATE lc_scan SET "+
				"	file_cont	= ?, "+
				"	rent_st		= ?  "+
				" WHERE	rent_mng_id	= ?	AND rent_l_cd = ? AND seq = ? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getFile_cont	()	);
			pstmt.setString	(2,		bean.getRent_st		()	);
			pstmt.setString	(3,		bean.getRent_mng_id	()	);
			pstmt.setString	(4,		bean.getRent_l_cd	()	);
			pstmt.setString	(5,		bean.getSeq			()	);

		    result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[LcScanDatabase:updateLcScanEtc]\n"+e);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}		

	//delete-----------------------------------------------------------------------------------------------------------------------------------------

	/*스캔파일 (LC_SCAN 테이블) 삭제 */
	public int deleteLcScan(LcScanBean bean)
	{
		getConnection();

		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";

		query = " DELETE lc_scan WHERE rent_mng_id = ?	AND rent_l_cd = ? AND seq = ? ";

		try 
		{
			conn.setAutoCommit(false);
					
			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getRent_mng_id()	);
			pstmt.setString	(2,		bean.getRent_l_cd()		);
			pstmt.setString	(3,		bean.getSeq()			);

		    result = pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[LcScanDatabase:deleteLcScan]\n"+e);
	  		e.printStackTrace();
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}		

	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean getLcScanClientCase(String client_id, String file_st)
	{
		getConnection();

		LcScanBean bean = new LcScanBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.* FROM lc_scan a, cont b "+
				" WHERE a.file_st=? and b.client_id=? "+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd not like 'RM%' "; 

		if(file_st.equals("17") || file_st.equals("18") || file_st.equals("2") || file_st.equals("4")){
			query += " AND LOWER(a.file_type) = '.jpg' ";		
		}

		query += " order by a.reg_dt desc";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, file_st);
			pstmt.setString(2, client_id);

		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScanClientCase]\n"+e);
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

	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean getLcScanClientCase(String client_id, String file_st, String file_cont)
	{
		getConnection();

		LcScanBean bean = new LcScanBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.* FROM lc_scan a, cont b "+
				" WHERE a.file_st=? and replace(a.file_cont,' ','')=replace(?,' ','') and b.client_id=?  and b.rent_l_cd not like 'RM%' "+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd order by a.reg_dt desc";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, file_st);
			pstmt.setString(2, file_cont);
			pstmt.setString(3, client_id);


		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScanClientCase]\n"+e);
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

	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean getLcScanNewCase(String rent_mng_id, String rent_l_cd, String file_st)
	{
		getConnection();

		LcScanBean bean = new LcScanBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM lc_scan WHERE rent_mng_id=? AND rent_l_cd=? AND file_st=? and seq = (SELECT max(seq) FROM lc_scan WHERE rent_mng_id=? AND rent_l_cd=? AND file_st=?) ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, file_st);
			pstmt.setString(4, rent_mng_id);
			pstmt.setString(5, rent_l_cd);
			pstmt.setString(6, file_st);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScanNewCase]\n"+e);
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

	public String getSeqNextS(String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String item_id = "";
		String query = "";

		query = " select nvl(ltrim(to_char(to_number(max(seq)+1), '00')), '01') seq"+
				" from sc_scan "+
				" where rent_s_cd='"+l_cd+"'";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
   	
			if(rs.next())
			{				
				item_id = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getSeqNextS]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return item_id;
		}		
	}

	/*계약관련서류 스캔파일(LC_SCAN 테이블) 등록*/
	public int insertScScan(LcScanBean bean)
	{
		getConnection();

		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";
		query = " INSERT INTO sc_scan"+
				" (car_mng_id, rent_s_cd, seq, file_st, file_cont, file_name, reg_id, reg_dt, upd_id, upd_dt, file_path, file_type, rent_st)"+
				" VALUES "+
				" (?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ?) ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getRent_mng_id	());
			pstmt.setString	(2,		bean.getRent_l_cd	());
			pstmt.setString	(3,		bean.getSeq			());
			pstmt.setString	(4,		bean.getFile_st		());
			pstmt.setString	(5,		bean.getFile_cont	());
			pstmt.setString	(6,		bean.getFile_name	());
			pstmt.setString	(7,		bean.getReg_id		());
			pstmt.setString	(8,		bean.getUpd_id		());
			pstmt.setString	(9,		bean.getUpd_dt		());
			pstmt.setString	(10,	bean.getFile_path	());
			pstmt.setString	(11,	bean.getFile_type	());
			pstmt.setString	(12,	bean.getRent_st		());

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[LcScanDatabase:insertScScan]\n"+e);

			System.out.println("[bean.getRent_mng_id	()]\n"+bean.getRent_mng_id	());
			System.out.println("[bean.getRent_l_cd		()]\n"+bean.getRent_l_cd	());
			System.out.println("[bean.getSeq			()]\n"+bean.getSeq			());
			System.out.println("[bean.getFile_st		()]\n"+bean.getFile_st		());
			System.out.println("[bean.getFile_cont		()]\n"+bean.getFile_cont	());
			System.out.println("[bean.getFile_name		()]\n"+bean.getFile_name	());
			System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id		());
			System.out.println("[bean.getUpd_id			()]\n"+bean.getUpd_id		());
			System.out.println("[bean.getUpd_dt			()]\n"+bean.getUpd_dt		());
			System.out.println("[bean.getFile_path		()]\n"+bean.getFile_path	());
			System.out.println("[bean.getFile_type		()]\n"+bean.getFile_type	());
			System.out.println("[bean.getRent_st		()]\n"+bean.getRent_st		());

			e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean getLcScanS(String car_mng_id, String rent_s_cd, String seq)
	{
		getConnection();

		LcScanBean bean = new LcScanBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM sc_scan WHERE car_mng_id=? AND rent_s_cd=? AND seq=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, rent_s_cd);
			pstmt.setString(3, seq);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScanS]\n"+e);
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

	/*스캔파일 (LC_SCAN 테이블) 삭제 */
	public int deleteLcScanS(LcScanBean bean)
	{
		getConnection();

		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";

		query = " DELETE sc_scan WHERE car_mng_id = ?	AND rent_s_cd = ? AND seq = ? ";

		try 
		{
			conn.setAutoCommit(false);
					
			pstmt = conn.prepareStatement(query);

			pstmt.setString	(1,		bean.getRent_mng_id()	);
			pstmt.setString	(2,		bean.getRent_l_cd()		);
			pstmt.setString	(3,		bean.getSeq()			);

		    result = pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[LcScanDatabase:deleteLcScanS]\n"+e);
	  		e.printStackTrace();
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}		

	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean getLcScanClientCaseS(String client_id, String file_st)
	{
		getConnection();

		LcScanBean bean = new LcScanBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String f_query = "";

		query = " SELECT a.* FROM lc_scan a, cont b "+
				" WHERE a.file_st=? and b.client_id=? "+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and  b.rent_l_cd not like 'RM%'  ";

		if(file_st.equals("17") || file_st.equals("18") || file_st.equals("2") || file_st.equals("4")){
			query += " AND LOWER(a.file_type) = '.jpg' ";		
		}

		query +=" union all \n"+
                " SELECT a.* FROM sc_scan a, rent_cont b "+
				" WHERE a.file_st=? and b.cust_st='1' and b.cust_id=? "+
				" and a.car_mng_id=b.car_mng_id and a.rent_s_cd=b.rent_s_cd ";

		if(file_st.equals("17") || file_st.equals("18") || file_st.equals("2") || file_st.equals("4")){
			query += " AND LOWER(a.file_type) = '.jpg' ";		
		}

		f_query = "select * from ("+query+") order by reg_dt desc, seq desc ";

//System.out.println("getLcScanClientCaseS: "+query);

		try{
			pstmt = conn.prepareStatement(f_query);
			pstmt.setString(1, file_st);
			pstmt.setString(2, client_id);
			pstmt.setString(3, file_st);
			pstmt.setString(4, client_id);

		   	rs = pstmt.executeQuery();

			if(rs.next())
			{
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScanClientCaseS]\n"+e);
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

	/*계약관련 스캔파일(LC_SCAN 테이블) 조회*/
	public LcScanBean[] getLcScanListS(String car_mng_id, String rent_s_cd)
	{
		getConnection();

		Collection<LcScanBean> col = new ArrayList<LcScanBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT * FROM sc_scan WHERE car_mng_id=? AND rent_s_cd=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, rent_s_cd);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				LcScanBean bean = new LcScanBean();
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
				col.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScanListS]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return (LcScanBean[])col.toArray(new LcScanBean[0]);
		}				
	}

	/*계약관련 스캔파일(LC_SCAN 테이블) 최근 파일 조회*/
	public LcScanBean[] getLcScanListS(String client_id)
	{
		getConnection();

		Collection<LcScanBean> col = new ArrayList<LcScanBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String query = "";
		String a_table = "";
		String b_table = "";
	
		/*
		a_table = " select a.*, b.cust_id from sc_scan a, rent_cont b where a.rent_s_cd=b.rent_s_cd and a.file_st in ('2','3','4','6','7','8')";

		b_table = " select b.cust_id, a.file_st, max(a.reg_dt||a.car_mng_id) max_scan from sc_scan a, rent_cont b where a.rent_s_cd=b.rent_s_cd and b.cust_id=? group by b.cust_id, a.file_st";

		query = " select a.* from ("+a_table+") a, ("+b_table+") b where a.cust_id=b.cust_id and a.file_st=b.file_st and a.reg_dt||a.car_mng_id=b.max_scan";
		*/

		query = " SELECT * FROM lc_scan WHERE rent_mng_id=?"; //미사용


		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, client_id);
		   	rs = pstmt.executeQuery();

			while(rs.next())
			{
				LcScanBean bean = new LcScanBean();
				bean.setRent_mng_id	(rs.getString(1));
				bean.setRent_l_cd	(rs.getString(2));
				bean.setSeq			(rs.getString(3));
				bean.setFile_st		(rs.getString(4));
				bean.setFile_cont	(rs.getString(5));
				bean.setFile_name	(rs.getString(6));
				bean.setReg_id		(rs.getString(7));
				bean.setReg_dt		(rs.getString(8));
				bean.setUpd_id		(rs.getString(9));
				bean.setUpd_dt		(rs.getString(10));
				bean.setFile_path	(rs.getString(11));
				bean.setFile_type	(rs.getString(12));
				bean.setRent_st		(rs.getString(13));
				col.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[LcScanDatabase:getLcScanListS]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return (LcScanBean[])col.toArray(new LcScanBean[0]);
		}				
	}

}