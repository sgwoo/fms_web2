package acar.memo;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
//import acar.cont.*;

public class Memo_Database
{
	private Connection conn = null;
	public static Memo_Database db;
	
	public static Memo_Database getInstance()
	{
		if(Memo_Database.db == null)
			Memo_Database.db = new Memo_Database();
		return Memo_Database.db;
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

	/**
	*	메모 Bean에 데이터 넣기 2004.2.17.화.
	*/
	 private MemoBean makeMemoBean(ResultSet results) throws DatabaseException {

        try {

			MemoBean bean = new MemoBean();

			bean.setMemo_id(results.getString("MEMO_ID"));
			bean.setDept_id(results.getString("DEPT_ID"));
			bean.setSend_id(results.getString("SEND_ID"));
			bean.setRece_id(results.getString("RECE_ID"));
			bean.setTitle  (results.getString("TITLE"));
			bean.setContent(results.getString("CONTENT"));
			bean.setMemo_dt(results.getString("MEMO_DT"));
			bean.setRece_yn(results.getString("RECE_YN"));
			bean.setAnonym_yn(results.getString("ANONYM_YN"));
			bean.setAnrece_yn(results.getString("ANRECE_YN"));

			return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	보낸메세지 리스트 2004.2.17.화.
	*/
	public MemoBean[] getSendList(String send_id){
		getConnection();
		Collection<MemoBean> col = new ArrayList<MemoBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";

		query = "SELECT memo_id, dept_id, send_id, rece_id, title, content, memo_dt, rece_yn, anonym_yn, anrece_yn FROM memo WHERE send_id=? and nvl(use_yn, 'Y' ) = 'Y'  ORDER BY memo_id DESC ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,send_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeMemoBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Memo_Database:getSendList(String send_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (MemoBean[])col.toArray(new MemoBean[0]);
		}		
	}

	/**
	*	받은메세지 리스트 2004.2.17.화.
	*/
	public MemoBean[] getReceList(String rece_id){
		getConnection();
		Collection<MemoBean> col = new ArrayList<MemoBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";

		query = "SELECT memo_id,dept_id,send_id,rece_id,title,content,memo_dt,rece_yn,anonym_yn,anrece_yn FROM memo WHERE rece_id LIKE '%"+rece_id+"%'  and  nvl(use_yn, 'Y' ) = 'Y' ORDER BY memo_id DESC";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeMemoBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Memo_Database:getReceList(String rece_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (MemoBean[])col.toArray(new MemoBean[0]);
		}
	}

	/**
	 *	메세지 보내기(등록) 2004.2.18.수.
	 */
	public boolean sendMemo(MemoBean bean){
		getConnection();
		boolean flag = true;
		String query_seq="";
		String query="";
		Statement stmt1 = null;
		Statement stmt2 = null;
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);

			query_seq = "SELECT ltrim(NVL(TO_CHAR(MAX(TO_NUMBER(memo_id))+1, '000000'), '000001')) memo_id "+
					  	" FROM memo ";

			stmt1 = conn.createStatement();
			rs = stmt1.executeQuery(query_seq);

			while(rs.next())
			{
				bean.setMemo_id(rs.getString("MEMO_ID")==null?"000001":rs.getString("MEMO_ID"));
			}
			rs.close();
			stmt1.close();

			query = "INSERT INTO memo(memo_id, dept_id, send_id, rece_id, title, content, memo_dt, rece_yn, anonym_yn, anrece_yn) VALUES "+
					"('"+bean.getMemo_id()+"','"+bean.getDept_id()+"','"+bean.getSend_id()+"',\n"+
					" '"+bean.getRece_id()+"','"+bean.getTitle().trim()+"','"+bean.getContent().trim()+"',\n"+
					" TO_CHAR(SYSDATE,'YYYYMMDD'),'','"+bean.getAnonym_yn().trim()+"','"+bean.getAnrece_yn().trim()+"')";

			stmt2 = conn.createStatement();
			stmt2.executeUpdate(query);
			stmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[Memo_Database:sendMemo(MemoBean bean)]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null ) rs.close();
                if(stmt1 != null) stmt1.close();
                if(stmt2 != null) stmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	메세지 보내기(등록)-고객접속화면개발시 고객정비예약신청시 메모등록 2004.5.28.
	 */
	public boolean sendMemo_ires(MemoBean bean){
		getConnection();
		boolean flag = true;
		String query_seq="";
		String query="";
		Statement stmt1 = null;
		Statement stmt2 = null;
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);

			query_seq = "SELECT ltrim(NVL(TO_CHAR(MAX(TO_NUMBER(memo_id))+1, '000000'), '000001')) memo_id "+
					  	" FROM memo ";

			stmt1 = conn.createStatement();
			rs = stmt1.executeQuery(query_seq);

			while(rs.next())
			{
				bean.setMemo_id(rs.getString("MEMO_ID")==null?"000001":rs.getString("MEMO_ID"));
			}
			rs.close();
			stmt1.close();

			query = "INSERT INTO memo(memo_id, dept_id, send_id, rece_id, title, content, memo_dt, rece_yn, rent_mng_id, rent_l_cd, ires_id, anonym_yn, anrece_yn) VALUES "+
					"('"+bean.getMemo_id()+"','"+bean.getDept_id()+"','"+bean.getSend_id()+"',\n"+
					" '"+bean.getRece_id()+"','"+bean.getTitle().trim()+"','"+bean.getContent().trim()+"',\n"+
					" TO_CHAR(SYSDATE,'YYYYMMDD'),'','"+bean.getRent_mng_id()+"','"+bean.getRent_l_cd()+"','"+bean.getIres_id()+"','"+bean.getAnonym_yn().trim()+"','"+bean.getAnrece_yn().trim()+"')";


			stmt2 = conn.createStatement();
			stmt2.executeUpdate(query);
			stmt2.close();

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[Memo_Database:sendMemo_ires(MemoBean bean)]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null ) rs.close();
                if(stmt1 != null) stmt1.close();
                if(stmt2 != null) stmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	메세지 삭제하기 - 고객접속화면개발시 고객정비예약 취소시 메모에서도 삭제 2004.5.28. Yongsoon Kwon.
	 */
	public boolean deleteMemo_ires(String rent_mng_id, String rent_l_cd, String ires_id){
		getConnection();
		boolean flag = true;
		String query="";
		Statement stmt1 = null;

		query = "DELETE FROM memo WHERE rent_mng_id='"+rent_mng_id+"' AND rent_l_cd='"+rent_l_cd+"' AND ires_id='"+ires_id+"' ";


		try{

			conn.setAutoCommit(false);

			stmt1 = conn.createStatement();
			int result = stmt1.executeUpdate(query);
			stmt1.close();

			if(result<=0) flag = false;

			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[Memo_Database:deleteMemo_ires(String rent_mng_id, String rent_l_cd, String ires_id)]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(stmt1 != null) stmt1.close();
			}catch(Exception ignore){}
			
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	메모 수신확인 2004.2.19.목.
	 */
	public boolean rece_yn(String memo_id, String user_id){
		getConnection();
		boolean flag = true;
		String q_rece_yn="";
		String query="";
		Statement stmt1 = null;
		Statement stmt2 = null;
		ResultSet rs = null;
		try 
		{
			conn.setAutoCommit(false);
				
			q_rece_yn = "SELECT rece_yn FROM memo WHERE memo_id='"+memo_id+"' and nvl(use_yn, 'Y') =  'Y' ";

			stmt1 = conn.createStatement();
			rs = stmt1.executeQuery(q_rece_yn);

			while(rs.next())
			{
				q_rece_yn = rs.getString("RECE_YN")==null?"":rs.getString("RECE_YN");
			}
			rs.close();
			stmt1.close();

			if(q_rece_yn.indexOf(user_id)<0){
				if(q_rece_yn.equals("")){
					q_rece_yn += user_id;
				}else{
					q_rece_yn += " "+user_id;
				}

				query = "UPDATE memo SET rece_yn='"+q_rece_yn+"' WHERE memo_id='"+memo_id+"' ";
				stmt2 = conn.createStatement();
				stmt2.executeUpdate(query);
				stmt2.close();
			}
			conn.commit();
		
	  	} catch (Exception e) {
			System.out.println("[Memo_Database:rece_yn(String memo_id, String user_id)]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null ) rs.close();
                if(stmt1 != null) stmt1.close();
                if(stmt2 != null) stmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	*	메모세부내용 2004.2.18.수.
	*/
	public MemoBean getMemo(String memo_id){
		getConnection();
		MemoBean memo = new MemoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT memo_id,dept_id,send_id,rece_id,title,content,memo_dt,rece_yn,anonym_yn,anrece_yn FROM memo WHERE memo_id=? and nvl(use_yn, 'Y' ) = 'Y'  ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,memo_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				memo = makeMemoBean(rs);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Memo_Database:getMemo(String memo_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return memo;
		}		
	}

	/**
	*	받은메세지 중 미수신된것 리스트 2004.2.20.금.
	*/
	public MemoBean[] getRece_n_List(String user_id){
		getConnection();
		Collection<MemoBean> col = new ArrayList<MemoBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "select a.* from (select * from memo where rece_id like '%"+user_id+"%') a, (select memo_id from memo where rece_yn not like '%"+user_id+"%' or rece_yn is null) b where a.memo_id =b.memo_id";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeMemoBean(rs));
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Memo_Database:getRece_n_List(String user_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (MemoBean[])col.toArray(new MemoBean[0]);
		}
	}

	/**
	 *	메세지 일괄 삭제하기 - 20071218
	 */
	public boolean deleteAutoMemos(String b_day){
		getConnection();
		boolean flag = true;
		String query1 = "";
		Statement stmt1 = null;
		int result = 0;

		query1 = " DELETE from memo where rece_id='000085' and substr(title,1,4) in ('[배차]','[반차]','[취소]','[예약]') and content='냉무' and memo_dt < to_char(sysdate-"+b_day+",'YYYYMMDD')";

		try{

			conn.setAutoCommit(false);

			stmt1 = conn.createStatement();
			result = stmt1.executeUpdate(query1);



			if(result<=0) flag = false;

			stmt1.close();
			conn.commit();

	  	} catch (Exception e) {
			System.out.println("[Memo_Database:deleteAutoMemos]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(stmt1 != null) stmt1.close();
			}catch(Exception ignore){}
			
			closeConnection();
			return flag;
		}			
	}

	/**
	*	알람메모 삭제대상갯수 : 20071218
	*/
	public int getAutoMemoDel(String b_day){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int count = 0;

		query = " select count(0) from memo where rece_id='000085' and substr(title,1,4) in ('[배차]','[반차]','[취소]','[예약]') and content='냉무' and memo_dt < to_char(sysdate-"+b_day+",'YYYYMMDD')";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		}catch(SQLException e){
			System.out.println("[Memo_Database:getAutoMemoDel]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return count;
		}
	}

}