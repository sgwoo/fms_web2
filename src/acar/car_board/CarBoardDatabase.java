
package acar.car_board;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;

public class CarBoardDatabase
{
	private Connection conn = null;
	public static CarBoardDatabase db;
	
	public static CarBoardDatabase getInstance()
	{
		if(CarBoardDatabase.db == null)
			CarBoardDatabase.db = new CarBoardDatabase();
		return CarBoardDatabase.db;
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
	    	System.out.println(" I can't get a connection........");
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


	//차량관련 게시판 
	public Vector getCarBoardList(String car_mng_id,  String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = "";

		query = " select a.* " +
				" from  car_board a \n"+			
				"  where a.car_mng_id = '" + car_mng_id + "'";

		if(!gubun.equals(""))			query += " where  a.gubun = '"+ gubun+"'";
		query += " order by a.reg_dt  ";
		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();

            while(rs.next())
            {
				CarBoardBean bean = new CarBoardBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setReg_dt(rs.getString("REG_DT"));				//등록일 
			    bean.setReg_id(rs.getString("REG_ID"));					//
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));					//
			    bean.setContent(rs.getString("CONTENT"));				
			    bean.setGubun(rs.getString("GUBUN"));				
			    bean.setSeq(rs.getInt("SEQ"));  //진행 담당자
					    
			    rtn.add(bean);
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CarBoardDatabase:getCarBoardList]\n"+e);
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
	 *	대여료메모 insert
	 */
	public boolean insertCarBoardMemo(CarBoardBean bean)
	{
		getConnection();
		boolean flag = true;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int  seq = 0;
		
		String   query_id = "select nvl(max(seq)+1, 1)  from car_board  where car_mng_id = '" + bean.getCar_mng_id() + "' ";	
		  
		
		String query =  " insert into car_board ("+
						" CAR_MNG_ID, SEQ,  RENT_MNG_ID, RENT_L_CD, GUBUN, REG_ID, REG_DT, CONTENT )"+
						" values ( ?, ?, ?, ?, ?, ?, replace(?, '-', ''), ?) ";
		try {
			conn.setAutoCommit(false);

			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query_id);
			if(rs.next())
			{
			   	seq = rs.getInt(1);
			}
			rs.close();
			stmt.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setInt(2, seq);
			pstmt.setString(3, bean.getRent_mng_id());
			pstmt.setString(4, bean.getRent_l_cd());
			pstmt.setString(5, bean.getGubun());
			pstmt.setString(6, bean.getReg_id());			
			pstmt.setString(7, bean.getReg_dt());
			pstmt.setString(8, bean.getContent());		
	
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[CarBoardDatabase:insertCarBoardMemo]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	public boolean deleteCarBoardMemo(CarBoardBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " delete from car_board where car_mng_id=? and seq=? ";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setInt(2, bean.getSeq	());			
	
		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[CarBoardDatabase:deleteCarBoardMemo]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
                if(pstmt != null) pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

}