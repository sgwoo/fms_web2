package acar.insur;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;
import acar.account.*;
import acar.common.*;
import acar.util.*;
import acar.mng_exp.*;
import java.awt.print.*;

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

public class InsComDatabase
{
	private Connection conn = null;
	public static InsComDatabase db;
	
	public static InsComDatabase getInstance()
	{
		if(InsComDatabase.db == null)
			InsComDatabase.db = new InsComDatabase();
		return InsComDatabase.db;
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


	//중복입력 체크
	public int getCheckOverInsExcelCom(String gubun, String use_st, String rent_mng_id, String rent_l_cd, String car_mng_id, String ins_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0) cnt from ins_excel_com "+
				" where gubun='"+gubun+"' "+
				" ";

		if(!use_st.equals(""))	query += " and use_st='"+use_st+"' ";
		else					query += " and use_st not in ('취소')";

		if(gubun.equals("가입")){
			query += " and rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' ";
		}else if(gubun.equals("갱신") || gubun.equals("해지")){
			query += " and car_mng_id='"+car_mng_id+"' and ins_st='"+ins_st+"' ";
		}

		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			//System.out.println("[InsComDatabase:getCheckOverInsExcelCom]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//중복입력 체크
		public int getCheckOverInsExcelCom(String gubun, String use_st, String rent_mng_id, String rent_l_cd, String car_mng_id, String ins_st, String value08, String value09, String value10, String value11, String value12)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";

			query = " select count(0) cnt from ins_excel_com "+
					" where gubun='"+gubun+"' "+
					" ";

			if(!use_st.equals(""))	query += " and use_st='"+use_st+"' ";
			else					query += " and use_st not in ('취소')";

			if(gubun.equals("배서")){
				query += " and rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' ";
				query += " and car_mng_id='"+car_mng_id+"' and ins_st='"+ins_st+"' ";

				if(value11.equals("장기임차인 변경, 해지")){
					query += " and value11 like '%해지%' ";
				}else{
					query += " and value08='"+value08+"' ";
					query += " and nvl(value09,'-')=nvl('"+value09+"','-') ";
					query += " and nvl(value10,'-')=nvl('"+value10+"','-') ";
				}
			}

			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:getCheckOverInsExcelCom]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null)		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}
	
	//reg_code, seq 로  중복입력 체크
	public int getCheckOverInsExcelCom(String gubun, String reg_code, String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0) cnt from ins_excel_com "+
				" where gubun='"+gubun+"' "+
				" and reg_code='"+reg_code+"' "+
				" and seq='"+seq+"' "+
				" and end_dt is null "+
				" and use_st not in ('취소') "+
				" ";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			//System.out.println("[InsComDatabase:getCheckOverInsExcelCom]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

	//car_mng_id, ins_st 로  중복입력 체크
		public int getCheckOverInsExcel(String car_mng_id, String ins_st)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";

			query = " select count(0) cnt from ins_excel "+
					" where value11='"+car_mng_id+"' "+
					" and value12='"+ins_st+"' "+
					" and gubun is null "+
					" ";
			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:getCheckOverInsExcel(String car_mng_id, String ins_st)]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null)		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}

		//car_mng_id, ins_st 로  중복입력 체크
			public int getCheckOverInsExcelCom(String car_mng_id, String ins_st)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				int count = 0;
				String query = "";

				query = " select count(0) cnt from ins_excel_com "+
						" where car_mng_id='"+car_mng_id+"' "+
						" and ins_st='"+ins_st+"' "+
						" and end_dt IS NOT NULL "+
						" ";
				
				try {
					pstmt = conn.prepareStatement(query);
			    	rs = pstmt.executeQuery();
		    		ResultSetMetaData rsmd = rs.getMetaData();
		    	
					if(rs.next())
					{				
						count = rs.getInt(1);
					}
					rs.close();
					pstmt.close();
				} catch (SQLException e) {
					//System.out.println("[InsComDatabase:getCheckOverInsExcel(String car_mng_id, String ins_st)]"+ e);
			  		e.printStackTrace();
				} finally {
					try{
		                if(rs != null)		rs.close();
		                if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return count;
				}
			}
			
			//ins_con_no, enp_no, car_mng_id, 변경전, 변경후 
			public int getCheckOverInsExcelCom2(String ins_con_no, String enp_no, String car_mng_id, String before, String after)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				int count = 0;
				String query = "";

				query = " select count(0) cnt from ins_excel_com "+
						" where car_mng_id='"+car_mng_id+"' "+
						" and value15='"+ins_con_no+"' "+
						" and value05='"+enp_no+"' "+
						" and value09='"+before+"' "+
						" and value10='"+after+"' "+
						" and use_st='완료' "+
						" ";
				
				try {
					pstmt = conn.prepareStatement(query);
			    	rs = pstmt.executeQuery();
		    		ResultSetMetaData rsmd = rs.getMetaData();
		    	
					if(rs.next())
					{				
						count = rs.getInt(1);
					}
					rs.close();
					pstmt.close();
				} catch (SQLException e) {
					//System.out.println("[InsComDatabase:getCheckOverInsExcel(String ins_con_no, String enp_no, String car_mng_id, String before, String after)]"+ e);
			  		e.printStackTrace();
				} finally {
					try{
		                if(rs != null)		rs.close();
		                if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return count;
				}
			}
			
			//car_mng_id, ins_st로 삭제
			public boolean deleteInsExcelCom(String car_mng_id, String ins_st)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				boolean flag = false;
				String query = "";

				query = " delete from ins_excel_com "+
						" where car_mng_id='"+car_mng_id+"' "+
						" and ins_st='"+ins_st+"' "+
						" ";
				
				try {
					conn.setAutoCommit(false);
					pstmt = conn.prepareStatement(query);
					pstmt.executeUpdate();
					pstmt.close();
					
					conn.commit();
					flag = true;
					
				} catch (SQLException e) {
					//System.out.println("[InsComDatabase:getCheckOverInsExcelCom(String car_mng_id, String ins_st)]"+ e);
			  		e.printStackTrace();
			  		flag = false;
					conn.rollback();
				} finally {
					try{
		                if(rs != null)		rs.close();
		                if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return flag;
				}
			}
			//car_mng_id, ins_st로 삭제
			public boolean deleteInsExcel(String car_mng_id, String ins_st)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				boolean flag = false;
				String query = "";
				
				query = " update ins_excel set gubun='Y'"+
						" where value11='"+car_mng_id+"' "+
						" and value12='"+ins_st+"' "+
						" ";
				
				try {
					conn.setAutoCommit(false);
					pstmt = conn.prepareStatement(query);
					pstmt.executeUpdate();
					pstmt.close();
					
					conn.commit();
					flag = true;
					
				} catch (SQLException e) {
					//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
					e.printStackTrace();
					flag = false;
					conn.rollback();
				} finally {
					try{
						if(rs != null)		rs.close();
						if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return flag;
				}
			}
			
			//reg_code, seq로 삭제
			public boolean deleteInsExcelCom2(String reg_code, String seq)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				boolean flag = false;
				String query = "";

				query = " update ins_excel_com "+
						" set use_st = '취소' "+
						" where reg_code='"+reg_code+"' "+
						" and seq='"+seq+"' "+
						" and gubun='증명' "+
						" ";
				
				try {
					conn.setAutoCommit(false);
					pstmt = conn.prepareStatement(query);
					pstmt.executeUpdate();
					pstmt.close();
					
					conn.commit();
					flag = true;
					
				} catch (SQLException e) {
					//System.out.println("[InsComDatabase:getCheckOverInsExcelCom(String car_mng_id, String ins_st)]"+ e);
			  		e.printStackTrace();
			  		flag = false;
					conn.rollback();
				} finally {
					try{
		                if(rs != null)		rs.close();
		                if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return flag;
				}
			}
			//증명 비고 업데이트
			public boolean updateInsExcelCom2(InsurExcelBean ins)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				boolean flag = false;
				String query = "";
				
				query = " update ins_excel_com set "+
						" etc = ?"+
						" where reg_code= ? "+
						" and seq=? "+
						" and gubun='증명' "+
						" ";
				
				try {
					conn.setAutoCommit(false);
					pstmt = conn.prepareStatement(query);
					pstmt.setString	(1,  ins.getEtc());
					pstmt.setString	(2,  ins.getReg_code());
					pstmt.setInt	(3,  ins.getSeq());
					pstmt.executeUpdate();
					pstmt.close();
					
					conn.commit();
					flag = true;
					
				} catch (SQLException e) {
					//System.out.println("[InsComDatabase:getCheckOverInsExcelCom(String car_mng_id, String ins_st)]"+ e);
					e.printStackTrace();
					flag = false;
					conn.rollback();
				} finally {
					try{
						if(rs != null)		rs.close();
						if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return flag;
				}
			}
			//증명 비고 업데이트
			public boolean updateInsExcelCom3(InsurExcelBean ins)
			{
				getConnection();
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				boolean flag = false;
				String query = "";
				
				query = " update ins_excel_com set "+
						" use_st = ?"+
						" where reg_code= ? "+
						" and seq=? "+
						" and gubun='증명' "+
						" ";
				
				try {
					conn.setAutoCommit(false);
					pstmt = conn.prepareStatement(query);
					pstmt.setString	(1,  ins.getUse_st());
					pstmt.setString	(2,  ins.getReg_code());
					pstmt.setInt	(3,  ins.getSeq());
					pstmt.executeUpdate();
					pstmt.close();
					
					conn.commit();
					flag = true;
					
				} catch (SQLException e) {
					//System.out.println("[InsComDatabase:getCheckOverInsExcelCom(String car_mng_id, String ins_st)]"+ e);
					e.printStackTrace();
					flag = false;
					conn.rollback();
				} finally {
					try{
						if(rs != null)		rs.close();
						if(pstmt != null)	pstmt.close();
					}catch(Exception ignore){}
					closeConnection();
					return flag;
				}
			}
		//car_mng_id,  변경전, 변경후 로  중복입력 체크
			public int getCheckOverInsExcel(String car_mng_id,  String begin, String after)
				{
					getConnection();
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					int count = 0;
					String query = "";

					query = " select count(0) cnt from ins_excel "+
							" where value11='"+car_mng_id+"' "+
							" and value07='"+begin+"' "+
							" and value08='"+after+"' "+
							" and gubun is null "+
							" ";
					
					try {
						pstmt = conn.prepareStatement(query);
				    	rs = pstmt.executeQuery();
			    		ResultSetMetaData rsmd = rs.getMetaData();
			    	
						if(rs.next())
						{				
							count = rs.getInt(1);
						}
						rs.close();
						pstmt.close();
					} catch (SQLException e) {
						//System.out.println("[InsComDatabase:getCheckOverInsExcel(String car_mng_id, String ins_st)]"+ e);
				  		e.printStackTrace();
					} finally {
						try{
			                if(rs != null)		rs.close();
			                if(pstmt != null)	pstmt.close();
						}catch(Exception ignore){}
						closeConnection();
						return count;
					}
				}
			
			// 임직원운정한정과 BASE임차인정보 리스트가 2개 나오는경우, 임직원운전한정 리스트에서 빼기
			public int getCheckOverInsExcel(String car_mng_id)
			{
				getConnection();
				int count = 0;
				String query = "select COUNT(*) FROM ins_excel WHERE value11 = '"+car_mng_id+"'  AND reg_code LIKE '%BASE%' AND GUBUN IS NULL";
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				try 
				{
					pstmt = conn.prepareStatement(query);
					rs = pstmt.executeQuery();
					if(rs.next()){
						count = rs.getInt(1);
					}
					rs.close();
					pstmt.close();
					
			  	} catch (Exception e) {
					//System.out.println("[InsDatabase:getCheckOverInsExcel(String rent_mng_id)]"+ e);
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
			
			// 차량번호가 중복되는 경우
			/*public int getCheckOverInsExcelCarNo(String car_mng_id)
			{
				getConnection();
				int count = 0;
				String query ="";
				query = " SELECT count(0)cnt  FROM (                 "+
						" SELECT *  FROM (                 "+
						" SELECT decode(a.gubun,'N','0','Y','1','0') as gubun , d.car_mng_id                "+
						" FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f              "+
						" WHERE a.reg_code LIKE '%ICQ%'                                                     "+
						" 		AND a.value06 IS NOT null  and a.value01 not in ('대차등록','매각 명의이전일 등록')      "+
						" 		AND a.value03 = b.rent_l_cd                                                 "+
						" 		AND b.car_mng_id = c.car_mng_id                                             "+
						" 		AND b.car_mng_id = d.car_mng_id                                             "+
						" 		AND d.ins_sts='1'                                                           "+
						" 		AND d.INS_COM_ID = f.INS_COM_ID                                             "+
						" 		AND b.CLIENT_ID = e.CLIENT_ID                                               "+
						" UNION all                                                                         "+
						" SELECT decode(a.gubun,'N','0','Y','1','0') as gubun ,    d.car_mng_id             "+
						" FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f,             "+
						" (SELECT car_mng_id, MAX(rent_mng_id) rent_mng_id, MAX(reg_dt) reg_dt FROM cont    "+
						" GROUP BY car_mng_Id) g, rent_cont h, client e2                                    "+
						" WHERE a.reg_code LIKE '%ICQ%'                                                     "+
						"       AND a.value06 IS NOT null  and a.value01 not in ('대차등록','매각 명의이전일 등록')            "+
						"       AND a.value03 = b.car_mng_id                                                      "+
						"       AND b.car_mng_id = c.car_mng_id                                                   "+
						"       AND b.car_mng_id = d.car_mng_id                                                   "+
						"       AND d.ins_sts='1'                                                                 "+
						"       AND d.INS_COM_ID = f.INS_COM_ID                                                   "+
						"       AND b.CLIENT_ID = e.CLIENT_ID                                                     "+
						"       AND b.car_mng_id=g.car_mng_id AND b.rent_mng_id=g.rent_mng_id                     "+
						"       AND b.reg_dt=g.reg_dt AND a.value02=h.rent_s_cd(+) AND a.value03=h.car_mng_id(+)  "+
						"       AND h.cust_id=e2.client_id(+)                                                     "+
						" UNION all                                                                          "+
						" SELECT decode(a.gubun,'N','0','Y','1','0') as gubun ,    d.car_mng_id              "+
						" FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f,              "+
						" (SELECT car_mng_id, MAX(rent_mng_id) rent_mng_id, MAX(reg_dt) reg_dt FROM cont     "+
						" GROUP BY car_mng_Id) g, rent_cont h, client e2                                     "+
						" WHERE a.reg_code LIKE '%ICQ%'                                                      "+
						"      AND a.value06 IS NOT null  and a.value01 in ('대차등록')                               "+
						"      AND a.value06 in ('연령범위','대물배상')                                                   "+
						"      AND a.value03 = b.car_mng_id                                                       "+
						"      AND b.car_mng_id = c.car_mng_id                                                    "+
						"      AND b.car_mng_id = d.car_mng_id                                                    "+
						"      AND d.ins_sts='1'                                                                  "+
						"      AND d.INS_COM_ID = f.INS_COM_ID                                                    "+
						"      AND b.CLIENT_ID = e.CLIENT_ID                                                      "+
						"      AND b.car_mng_id=g.car_mng_id AND b.rent_mng_id=g.rent_mng_id AND b.reg_dt=g.reg_dt "+ 
						"      AND a.value02=h.rent_s_cd(+) AND a.value03=h.car_mng_id(+)                         "+
						"      AND h.cust_id=e2.client_id(+)                                                      "+
						"      AND a.reg_dt > '20170331'                                                          "+
						" UNION all                                                                                "+
						" SELECT decode(a.gubun,'N','0','Y','1','0') as gubun ,    d.car_mng_id                    "+
						" FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f                     "+
						" WHERE a.reg_code LIKE '%ICQ%'                                                            "+
						"		AND a.value06 IS NOT null  and a.value01 in ('차량번호 변경')                            "+
						"		AND a.value03 = b.car_mng_id                                                       "+
						"		AND NVL(b.use_yn,'Y') ='Y'                                                         "+
						"		AND b.car_mng_id = c.car_mng_id                                                    "+
						"		AND b.car_mng_id = d.car_mng_id                                                    "+
						"		AND d.ins_sts='1'                                                                  "+
						"		AND d.INS_COM_ID = f.INS_COM_ID                                                    "+
						"		AND b.CLIENT_ID = e.CLIENT_ID                                                      "+
						"		AND a.reg_dt > '20170331'                                                          "+
						" UNION all                                                                         "+
						" SELECT decode(a.gubun,'N','0','Y','1','0') as gubun , d.car_mng_id                "+
						" FROM ins_excel a , cont b , car_reg c , insur d, client e, ins_com f              "+
						" WHERE a.reg_code LIKE '%BASE%'                                                    "+
						" 		AND a.value06 IS NOT null                                                   "+
						" 		AND a.value03 = b.rent_l_cd                                                 "+
						" 		AND b.car_mng_id = c.car_mng_id                                             "+
						" 		AND b.car_mng_id = d.car_mng_id                                             "+
						" 		AND d.ins_sts='1'                                                           "+
						" 		AND d.INS_COM_ID = f.INS_COM_ID                                             "+
						" 		AND b.CLIENT_ID = e.CLIENT_ID                                               "+
						"  ) WHERE car_mng_id ='"+car_mng_id+"' AND GUBUN = '0'                                     "+
						"  )                                      ";
				
				PreparedStatement pstmt = null;
				ResultSet rs = null;
				try 
				{
					pstmt = conn.prepareStatement(query);
					rs = pstmt.executeQuery();
					if(rs.next()){
						count = rs.getInt(1);
					}
					rs.close();
					pstmt.close();
					
			  	} catch (Exception e) {
					System.out.println("[InsDatabase:getCheckOverInsExcelCarNo(String car_mng_id)]"+ e);
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
*/
	

	/**
	 * 보험변경 엑셀등록
	 */
	public boolean insertInsExcelCom(InsurExcelBean ins)
	{
		getConnection();
		boolean flag = true;
		String query = "insert into ins_excel_com (reg_code, seq, gubun,  "+
						" value01, value02, value03, value04, value05, value06, value07, value08, value09, value10, "+
						" value11, value12, value13, value14, value15, value16, value17, value18, value19, value20,  "+
						" value21, value22, value23, value24, value25, value26, value27, value28, value29, value30,  "+
						" value31, value32, value33, value36,"+
			            " reg_id, reg_dt, "+
						" use_st, rent_mng_id, rent_l_cd, car_mng_id, ins_st, value42 , "+
						" value43, value44, value45, value46, value47, value48, value49, value50, value34, value35, "+
						" value51, value52, value37, value39, value38, value53 "+
						" ) values("+
						" ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?,"+
						" ?, sysdate, "+
						" '등록', ?, ?, ?, ?, ?,  "+
						" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, ?  "+
						" )";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  ins.getReg_code());
			pstmt.setInt	(2,  ins.getSeq		());
		    pstmt.setString	(3,  ins.getGubun	());
		    
			pstmt.setString	(4,  ins.getValue01	());
			pstmt.setString	(5,  ins.getValue02	());
			pstmt.setString	(6,  ins.getValue03	());
			pstmt.setString	(7,  ins.getValue04	());
			pstmt.setString	(8,  ins.getValue05	());
			pstmt.setString	(9,  ins.getValue06	());
			pstmt.setString	(10, ins.getValue07	());
			pstmt.setString	(11, ins.getValue08	());
			pstmt.setString	(12, ins.getValue09	());
			pstmt.setString	(13, ins.getValue10	());
			
			pstmt.setString	(14, ins.getValue11	());
			pstmt.setString	(15, ins.getValue12	());
			pstmt.setString	(16, ins.getValue13	());
			pstmt.setString	(17, ins.getValue14	());
			pstmt.setString	(18, ins.getValue15	());
			pstmt.setString	(19, ins.getValue16	());
			pstmt.setString	(20, ins.getValue17	());
			pstmt.setString	(21, ins.getValue18	());
			pstmt.setString	(22, ins.getValue19	());
			pstmt.setString	(23, ins.getValue20	());
			
			pstmt.setString	(24, ins.getValue21	());
			pstmt.setString	(25, ins.getValue22	());
			pstmt.setString	(26, ins.getValue23	());
			pstmt.setString	(27, ins.getValue24	());
			pstmt.setString	(28, ins.getValue25	());
			pstmt.setString	(29, ins.getValue26	());
			pstmt.setString	(30, ins.getValue27	());
			pstmt.setString	(31, ins.getValue28	());
			pstmt.setString	(32, ins.getValue29	());
			pstmt.setString	(33, ins.getValue30	());
			
			pstmt.setString	(34, ins.getValue31	());
			pstmt.setString	(35, ins.getValue32	());
			pstmt.setString	(36, ins.getValue33	());
			pstmt.setString	(37, ins.getValue36	());
			
			pstmt.setString	(38, ins.getReg_id	());			
			pstmt.setString	(39, ins.getRent_mng_id());			
			pstmt.setString	(40, ins.getRent_l_cd());			
			pstmt.setString	(41, ins.getCar_mng_id());			
			pstmt.setString	(42, ins.getIns_st	());			
			pstmt.setString	(43, ins.getValue21	());			
		
			pstmt.setString	(44, ins.getValue43	());			
			pstmt.setString	(45, ins.getValue44	());			
			pstmt.setString	(46, ins.getValue45	());			
			pstmt.setString	(47, ins.getValue46	());			
			pstmt.setString	(48, ins.getValue47	());			
			pstmt.setString	(49, ins.getValue48	());			
			pstmt.setString	(50, ins.getValue49	());			
			pstmt.setString	(51, ins.getValue50	());
			pstmt.setString	(52, ins.getValue34	());
			pstmt.setString	(53, ins.getValue35	());
			pstmt.setString	(54, ins.getValue51	());
			pstmt.setString	(55, ins.getValue52	());
			pstmt.setString	(56, ins.getValue37	());
			pstmt.setString	(57, ins.getValue39	());
			pstmt.setString	(58, ins.getValue38	());
			pstmt.setString	(59, ins.getValue53	());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			//System.out.println("[InsComDatabase:insertInsExcelCom]"+ e);
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

	/**
	 * 보험변경 엑셀등록
	 */
	public boolean updateInsExcelCom(InsurExcelBean ins)
	{
		getConnection();
		boolean flag = true;
		String query = " update ins_excel_com set "+
						"       value01=?, value02=?, value03=?, value04=?, value05=?, value06=?, value07=?, value08=?, value09=?, value10=?, "+
						"       value11=?, value12=?, value13=?, value14=?, value15=?, value16=?, value17=?, value18=?, value19=?, value20=?, "+
						"       value21=?, value22=?, value23=?, value24=?, value25=?, value26=?, value27=?, value28=?, value29=?, value30=?, "+
						"       value31=?, value32=?, value33=?, value34=?, value35=?, value36=?, value37=?, value38=?, value39=?, value40=?, "+
						"       value41=?, value42=?, value43=?, value44=?, value45=?, value46=?, value47=?, value48=?, value49=?, value50=?, "+
						"       etc=? "+
						" where reg_code=? and seq=? ";

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  ins.getValue01	());
			pstmt.setString	(2,  ins.getValue02	());
			pstmt.setString	(3,  ins.getValue03	());
			pstmt.setString	(4,  ins.getValue04	());
			pstmt.setString	(5,  ins.getValue05	());
			pstmt.setString	(6,  ins.getValue06	());
			pstmt.setString	(7,  ins.getValue07	());
			pstmt.setString	(8,  ins.getValue08	());
			pstmt.setString	(9,  ins.getValue09	());
			pstmt.setString	(10, ins.getValue10	());
			pstmt.setString	(11, ins.getValue11	());
			pstmt.setString	(12, ins.getValue12	());
			pstmt.setString	(13, ins.getValue13	());
			pstmt.setString	(14, ins.getValue14	());
			pstmt.setString	(15, ins.getValue15	());
			pstmt.setString	(16, ins.getValue16	());
			pstmt.setString	(17, ins.getValue17	());
			pstmt.setString	(18, ins.getValue18	());
			pstmt.setString	(19, ins.getValue19	());
			pstmt.setString	(20, ins.getValue20	());
			pstmt.setString	(21, ins.getValue21	());
			pstmt.setString	(22, ins.getValue22	());
			pstmt.setString	(23, ins.getValue23	());
			pstmt.setString	(24, ins.getValue24	());
			pstmt.setString	(25, ins.getValue25	());
			pstmt.setString	(26, ins.getValue26	());
			pstmt.setString	(27, ins.getValue27	());
			pstmt.setString	(28, ins.getValue28	());
			pstmt.setString	(29, ins.getValue29	());
			pstmt.setString	(30, ins.getValue30	());
			pstmt.setString	(31, ins.getValue31	());
			pstmt.setString	(32, ins.getValue32	());
			pstmt.setString	(33, ins.getValue33	());
			pstmt.setString	(34, ins.getValue34	());
			pstmt.setString	(35, ins.getValue35	());
			pstmt.setString	(36, ins.getValue36	());
			pstmt.setString	(37, ins.getValue37	());
			pstmt.setString	(38, ins.getValue38	());
			pstmt.setString	(39, ins.getValue39	());
			pstmt.setString	(40, ins.getValue40	());
			pstmt.setString	(41, ins.getValue41	());
			pstmt.setString	(42, ins.getValue42	());
			pstmt.setString	(43, ins.getValue43	());
			pstmt.setString	(44, ins.getValue44	());
			pstmt.setString	(45, ins.getValue45	());
			pstmt.setString	(46, ins.getValue46	());
			pstmt.setString	(47, ins.getValue47 ());
			pstmt.setString	(48, ins.getValue48	());
			pstmt.setString	(49, ins.getValue49	());
			pstmt.setString	(50, ins.getValue50	());
			pstmt.setString	(51, ins.getEtc		());
			pstmt.setString	(52, ins.getReg_code());
			pstmt.setInt	(53, ins.getSeq		());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			//System.out.println("[InsComDatabase:updateInsExcelCom]"+ e);
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

	/**
	 * 보험변경 엑셀등록
	 */
	public boolean updateInsExcelComUseSt(InsurExcelBean ins)
	{
		//System.out.println("ins.getUse_st	():"+ ins.getUse_st	());
		getConnection();
		boolean flag = true;

		String query = " update ins_excel_com set "+
						"       use_st=?, "+
						"       req_id=?, "+
						"       req_dt=sysdate ";
		/*분담금할증한정 금액을 자동으로 입력하기위함 */
		if(ins.getGubun().equals("가입")){ query += ",value22='15000'";} 
		if(ins.getGubun().equals("갱신")){ query += ",value38='15000'";} 
		if(ins.getGubun().equals("배서")){ query += ",value24='15000'";}  
			
	    query += " where reg_code=? and seq=? ";

	    
		if(ins.getUse_st().equals("확인")){
			query = " update ins_excel_com set "+
						"       use_st=?, "+
						"       cof_code=? "+
						" where reg_code=? and seq=? ";
		}
		if(ins.getUse_st().equals("완료")){
			query = " update ins_excel_com set "+
						"       use_st=?, "+
						"       end_id=?, "+
						"       end_dt=sysdate "+
						" where reg_code=? and seq=? ";
		}
		if(ins.getUse_st().equals("취소")){
			query = " update ins_excel_com set "+
						"       use_st=? "+
						" where reg_code=? and seq=? ";
		}
		if(ins.getUse_st().equals("반려")){
			query = " update ins_excel_com set "+
					"       use_st='요청',"+
					"       save_yn='N' "+
					" where reg_code=? and seq=? ";
		}
		if(ins.getUse_st().equals("반려등록")){
			query = " update ins_excel_com set "+
					"       use_st='등록', value22='' "+
					" where reg_code=? and seq=? ";
		}
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			if(ins.getUse_st().equals("취소")){
				pstmt.setString	(1, ins.getUse_st	());
				pstmt.setString	(2, ins.getReg_code	());
				pstmt.setInt	(3, ins.getSeq		());
			
			}else if(ins.getUse_st().equals("반려")){
				pstmt.setString	(1, ins.getReg_code	());
				pstmt.setInt	(2, ins.getSeq		());
				
			}else if(ins.getUse_st().equals("반려등록")){
				pstmt.setString	(1, ins.getReg_code	());
				pstmt.setInt	(2, ins.getSeq		());
				
			}else{
				if(ins.getUse_st().equals("요청")){
					pstmt.setString	(1, ins.getUse_st	());
					pstmt.setString	(2, ins.getReq_id	());
				}else if(ins.getUse_st().equals("확인")){
					pstmt.setString	(1, ins.getUse_st	());
					pstmt.setString	(2, ins.getCof_code	());
				}else if(ins.getUse_st().equals("완료")){
					pstmt.setString	(1, ins.getUse_st	());
					pstmt.setString	(2, ins.getEnd_id	());
				}
				pstmt.setString	(3, ins.getReg_code	());
				pstmt.setInt	(4, ins.getSeq		());
			}

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			//System.out.println("[InsComDatabase:updateInsExcelComUseSt]"+ e);
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

	/**
	 * 보험변경 엑셀등록
	 */
	public boolean updateInsExcelComActCode(String reg_code, int seq, String act_code)
	{
		getConnection();
		boolean flag = true;

		String query = " update ins_excel_com set "+
						"       act_code=? "+
						" where reg_code=? and seq=? and use_st='확인'  "; //and end_dt is null

		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1, act_code);
			pstmt.setString	(2, reg_code);
			pstmt.setInt	(3, seq);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			//System.out.println("[InsComDatabase:updateInsExcelComActCode]"+ e);
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

	//보험사 보험관리 반영 프로시저
	public String call_sp_ins_excel_com_new(String act_code, String user_id)
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
    	String query1 = "{CALL P_INS_EXCEL_COM_NEW  (?, ?)}";
		
		try {

			//처리 프로시저 호출
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, act_code);
			cstmt.setString(2, user_id);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			//System.out.println("[InsComDatabase:call_sp_ins_excel_com_new]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	//보험사 보험관리 반영 프로시저
	public String call_sp_ins_excel_com_ext(String act_code, String user_id)
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_INS_EXCEL_COM_EXT  (?, ?)}";
		
		try {

			//처리 프로시저 호출
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, act_code);
			cstmt.setString(2, user_id);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			//System.out.println("[InsComDatabase:call_sp_ins_excel_com_ext]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	

	//보험사 보험관리 반영 프로시저
	public String call_sp_ins_excel_com_cng(String act_code, String user_id)
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_INS_EXCEL_COM_CNG  (?, ?)}";
		
		try {

			//처리 프로시저 호출
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, act_code);
			cstmt.setString(2, user_id);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			//System.out.println("[InsComDatabase:call_sp_ins_excel_com_cng]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	//보험사 보험관리 반영 프로시저
	public String call_sp_ins_excel_com_cls(String act_code, String user_id)
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_INS_EXCEL_COM_CLS  (?, ?)}";
		
		try {

			//처리 프로시저 호출
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, act_code);
			cstmt.setString(2, user_id);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			//System.out.println("[InsComDatabase:call_sp_ins_excel_com_cls]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	




	//가입현황 리스트
	public Vector getInsComNewList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = "SELECT A.*, (CASE WHEN A.TAKING_P IS NULL THEN A.JG_G_17_TEMP ELSE A.TAKING_P END ) AS JG_G_CODE\r\n" + 
				"  FROM(" + 
				" SELECT A.*,(CASE WHEN TRIM(REPLACE(A.VALUE04, ' ', '')) = '리스' \r\n" + 
				"	         THEN 0 \r\n" + 
				"		     ELSE (SELECT JG_G_17\r\n" + 
				"		             FROM ESTI_JG_VAR\r\n" + 
				"					WHERE SH_CODE = A.JG_CODE AND SEQ = ( SELECT MAX(SEQ) FROM ESTI_JG_VAR WHERE SH_CODE = A.JG_CODE))\r\n" + 
				"			 END) AS JG_G_17_TEMP" +
				" FROM (" +
				" SELECT A.*, B.CAR_ID, B.CAR_SEQ, C.JG_CODE " +
				" FROM (" +
				" select CASE WHEN d.TAKING_P <=6 THEN '승용'\r\n" + 
				" 		 	 WHEN d.TAKING_P >=11 THEN '승합'\r\n" + 
				" 		 	 WHEN d.TAKING_P IN (7,8,9,10)  THEN '다인승'\r\n" + 
				" 			 ELSE ''\r\n" + 
				" 		END AS car_kd, a.value07 age_scp, a.value08 vins_gcp_kd, NVL2(a.value13,'가입','미가입')  blackbox_yn, a.value10 com_emp_yn, "+
				" 		a.reg_code, a.seq, a.gubun, a.use_st, a.reg_id, a.reg_dt, a.req_id, a.req_dt, a.cof_code, a.end_id, a.end_dt, "+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.ins_st, a.etc, "+
				"        a.value01, a.value02, a.value03, a.value04, a.value05, a.value06, a.value07, a.value08, a.value09, a.value10, "+
				"        a.value11, a.value12, a.value13, a.value14, a.value15, a.value16, a.value17, a.value18, a.value19, a.value20, "+
				"        a.value21, a.value22, a.value23, a.value24, a.value25, a.value26, a.value27, a.value28, a.value29, a.value30, "+
				"        a.value31, a.value32, a.value33, DECODE(a.value34,'1','영업용','2','업무용',a.value34) value34, (CASE WHEN C.INS_COM_NM = '삼성화재' \r\n" + 
				"					  THEN nvl(a.insur_code,(SELECT AA.INSUR_CODE FROM CAR_REG AA WHERE A.VALUE05 = AA.CAR_NUM))\r\n" + 
				"					  ELSE '' \r\n" + 
				"					  END ) AS INSUR_CODE, "+
				"        decode(value35,'','', '1', '법인', '2', '개인', '개인사업자') value35, value37, value38, "+
				"        to_char(a.reg_dt,'YYYYMMDD') as reg_dt2, b.user_nm as reg_nm, c.ins_com_nm, d.taking_p, a.save_yn "+
			    " from   ins_excel_com a, users b, ins_com c, car_reg d "+
				" where  a.gubun='가입' and a.reg_id=b.user_id(+) AND a.value14=c.ins_com_id " +
				" and	 a.value04 = d.car_no(+) " ;
		//보험사
		if(!gubun1.equals(""))	query += " and a.value14='"+gubun1+"'";

		//상태
		if(!gubun2.equals(""))	query += " and a.use_st='"+gubun2+"'";

		//기간
		if(gubun3.equals("당일"))			query += " and to_char(a.reg_dt,'YYYYMMDD')= to_char(sysdate,'YYYYMMDD')";
		else if(gubun3.equals("전일"))	query += " and to_char(a.reg_dt,'YYYYMMDD')= to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun3.equals("당해"))	query += " and to_char(a.reg_dt,'YYYY')= to_char(sysdate,'YYYY')";
		else if(gubun3.equals("당월"))	query += " and to_char(a.reg_dt,'YYYYMM')= to_char(sysdate,'YYYYMM')";
		else if(gubun3.equals("전월"))	query += " and to_char(a.reg_dt,'YYYYMM')= to_char(add_months(sysdate,-1), 'YYYYMM')";
		else if(gubun3.equals("기간")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and to_char(a.reg_dt,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and to_char(a.reg_dt,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		//차량번호
		if(s_kd.equals("1"))	what = "a.value04";	
		//차대번호
		if(s_kd.equals("2"))	what = "a.value05";	
		//차명
		if(s_kd.equals("3"))	what = "a.value03";	
		//고객명
		if(s_kd.equals("4"))	what = "a.value01";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like '%"+t_wd+"%' ";
		}	
		query += " ) A, CAR_ETC B, CAR_NM C \r\n" + 
				"					   WHERE A.RENT_MNG_ID = B.RENT_MNG_ID\r\n" + 
				"					     AND A.RENT_L_CD = B.RENT_L_CD\r\n" + 
				"					     AND B.CAR_ID = C.CAR_ID\r\n" + 
				"					     AND B.CAR_SEQ = C.CAR_SEQ\r\n" + 
				") A" + 
				" order by LENGTH(a.VALUE33), a.REG_CODE, a.SEQ desc" +
				") A ";
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
			//System.out.println("[InsComDatabase:getInsComNewList]\n"+e);
			//System.out.println("[InsComDatabase:getInsComNewList]\n"+query);
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
	
	
	////임직원 가입 정보
	public Hashtable getCompareAmt(String car_kd, String ins_com_nm, String age_scp, String vins_gcp_kd, String blackbox_yn, String com_emp_yn, double discountPer )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		
		
		query = "SELECT A.*\r\n" + 
				"      , (RINS_PCP_AMT + VINS_PCP_AMT + VINS_GCP_AMT + VINS_BACDT_AMT + VINS_CANOISR_AMT + VINS_SHARE_EXTRA_AMT) TOTAL_AMT\r\n" + 
				" FROM(\r\n" + 
				"		SELECT SEQ, CAR_KD, INS_COM_NM, AGE_SCP, VINS_GCP_KD\r\n" + 
				"		     , BLACKBOX_YN, COM_EMP_YN, VINS_SHARE_EXTRA_AMT\r\n" + 
				"		     , (CASE WHEN "+discountPer+" != 0 THEN ROUND(RINS_PCP_AMT - (RINS_PCP_AMT * "+discountPer+")) ELSE RINS_PCP_AMT END)  AS RINS_PCP_AMT\r\n" + 
				"		     , (CASE WHEN "+discountPer+" != 0 THEN ROUND(VINS_PCP_AMT - (VINS_PCP_AMT * "+discountPer+")) ELSE VINS_PCP_AMT END)  AS VINS_PCP_AMT\r\n" + 
				"		     , (CASE WHEN "+discountPer+" != 0 THEN ROUND(VINS_GCP_AMT - (VINS_GCP_AMT * "+discountPer+")) ELSE VINS_GCP_AMT END)  AS VINS_GCP_AMT\r\n" + 
				"		     , (CASE WHEN "+discountPer+" != 0 THEN ROUND(VINS_BACDT_AMT - (VINS_BACDT_AMT * "+discountPer+")) ELSE VINS_BACDT_AMT END)  AS VINS_BACDT_AMT\r\n" + 
				"		     , (CASE WHEN "+discountPer+" != 0 THEN ROUND(VINS_CANOISR_AMT - (VINS_CANOISR_AMT * "+discountPer+")) ELSE VINS_CANOISR_AMT END)  AS VINS_CANOISR_AMT\r\n" + 
				"		  FROM (\r\n" + 
				"				SELECT * \r\n" + 
				"				  FROM INSUR_TABLE \r\n" + 
				"				 WHERE CAR_KD  = ? \r\n" + 
				"				   AND ins_com_nm = ? \r\n" + 
				"				   AND AGE_SCP = ? \r\n" + 
				"				   AND VINS_GCP_KD = ? \r\n" + 
				"				   AND BLACKBOX_YN = ? \r\n" + 
				"				   AND COM_EMP_YN  = ? \r\n" + 
				"			   ) A WHERE 1=1\r\n" + 
				"	) A WHERE 1=1";
				
				
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  car_kd			);
			pstmt.setString	(2,  ins_com_nm		);
			pstmt.setString	(3,  age_scp		);
			pstmt.setString	(4,  vins_gcp_kd	);
			pstmt.setString	(5,  blackbox_yn	);
			pstmt.setString	(6,  com_emp_yn		);
			
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
			
			System.out.println("[InsDatabase:getInsComEmpInfo2(String car_mng_id, String ins_st)]"+ e);
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

	//갱신현황 리스트
	public Vector getInsComExtList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = "select CASE WHEN f.TAKING_P <=6 THEN '승용' \r\n" + 
				"        WHEN f.TAKING_P >=11 THEN '승합' \r\n" + 
				"        WHEN f.TAKING_P IN (7,8,9,10)  THEN '다인승' \r\n" + 
				"        ELSE '' \r\n" + 
				"        END AS car_kd, a.value14 age_scp, a.value15 vins_gcp_kd, decode(a.value42, 'Y', '가입', '미가입') com_emp_yn, \r\n" + 
				"        a.reg_code, a.seq, a.gubun, a.use_st, a.reg_id, a.reg_dt, a.req_id, a.req_dt, a.cof_code, a.end_id, a.end_dt, \r\n" + 
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.ins_st, a.etc, \r\n" + 
				"        a.value01, a.value02, a.value03, a.value04, a.value05, a.value06, a.value07, a.value08, a.value09, a.value10, \r\n" + 
				"        a.value11, a.value12, a.value13, a.value14, a.value15, a.value16, a.value17, a.value18, a.value19, a.value20, \r\n" + 
				"        a.value21, a.value22, a.value23, a.value24, a.value25, a.value26, a.value27, a.value28, a.value29, a.value30, \r\n" + 
				"        a.value31, a.value32, a.value33, a.value34, a.value35, a.value36, a.value37, a.value38, a.value39, a.value40, \r\n" + 
				"        a.value41, a.value42, NVL(a.value43,'N') value43, NVL(a.value44,'N') value44, NVL(a.value45,'N') value45, \r\n" + 
				"        NVL(a.value46,'N') value46, NVL(a.value47,'N') value47, a.value48, a.value49, DECODE(a.value50,'1','영업용','2','업무용',a.value50) value50, \r\n" + 
				"        decode(a.value51,'','', '1', '법인', '2', '개인', '개인사업자') value51, NVL(a.value52,'N') value52, NVL(a.value53,'N') value53,   \r\n" + 
				"        to_char(a.reg_dt,'YYYYMMDD') as reg_dt2, b.user_nm as reg_nm, c.ins_com_nm , e.JG_CODE, f.insur_code\r\n" + 
				" from   ins_excel_com a, users b, ins_com c, car_etc d, car_nm e, car_reg f, (SELECT car_mng_id FROM cont GROUP BY car_mng_id) g  \r\n" + 
				" where  a.gubun='갱신' and a.reg_id=b.user_id(+) AND a.value30=c.ins_com_id \r\n" + 															
				" 		AND a.RENT_L_CD = d.RENT_L_CD(+) AND a.RENT_MNG_ID = d.RENT_MNG_ID(+) AND a.car_mng_id = f.CAR_MNG_ID(+) \r\n" + 
				" 		AND d.CAR_ID = e.CAR_ID(+) AND d.CAR_SEQ= e.CAR_SEQ(+) AND f.car_mng_id=g.car_mng_id ";
		//보험사
		if(!gubun1.equals(""))	query += " and a.value30='"+gubun1+"'";

		//상태
		if(!gubun2.equals(""))	query += " and a.use_st='"+gubun2+"'";

		//기간(보험시작일기준으로 변경요청옴)
		//if(gubun3.equals("당일"))			query += " and to_char(a.value03,'YYYYMMDD')= to_char(sysdate,'YYYYMMDD')";
		//else if(gubun3.equals("전일"))	query += " and to_char(a.value03,'YYYYMMDD')= to_char(sysdate-1,'YYYYMMDD')";
	/*	else if(gubun3.equals("기간")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and to_char(a.value03,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and to_char(a.value03,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
	*/	
		if(gubun3.equals("당일"))			query += " and replace(a.value03, '-','') = to_char(sysdate,'YYYYMMDD')";
		else if(gubun3.equals("전일"))	query += " and to_char(replace(a.value03, '-',''),'YYYYMMDD')= to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun3.equals("당해"))	query += " and TO_CHAR(TO_DATE(REPLACE(a.value03, '-', ''),'YYYYMMDD'),'YYYY')= to_char(sysdate,'YYYY')";
		else if(gubun3.equals("당월"))	query += " and TO_CHAR(TO_DATE(REPLACE(a.value03, '-', ''),'YYYYMMDD'),'YYYYMM') = to_char(sysdate,'YYYYMM')";
		else if(gubun3.equals("전월"))	query += " and TO_CHAR(TO_DATE(REPLACE(a.value03, '-', ''),'YYYYMMDD'),'YYYYMM') = to_char(add_months(sysdate, -1),'YYYYMM')";
		else if(gubun3.equals("기간")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and replace(a.value03, '-','') like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and replace(a.value03, '-','') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		//차량번호
		if(s_kd.equals("1"))	what = "a.value04";	
		//차대번호
		if(s_kd.equals("2"))	what = "a.value05";	
		//차명
		if(s_kd.equals("3"))	what = "a.value06";	
		//고객명
		if(s_kd.equals("4"))	what = "a.value23";	
		//시작일
		if(s_kd.equals("5"))	what = "a.value03";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("5")){
				query += " and replace("+what+",'-','') like replace('%"+t_wd+"%','-','') ";
			}else{
				query += " and "+what+" like '%"+t_wd+"%' ";			
			}

		}	

		query += " order by a.reg_dt desc";	

		
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
			//System.out.println("[InsComDatabase:getInsComExtList]\n"+e);
			//System.out.println("[InsComDatabase:getInsComExtList]\n"+query);
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

	//배서현황 리스트
	public Vector getInsComCngList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select a.reg_code, a.seq, a.gubun, a.use_st, a.reg_id, a.reg_dt, a.req_id, a.req_dt, a.cof_code, a.end_id, a.end_dt, "+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.ins_st, a.etc, "+
				"        a.value01, a.value02, a.value03, a.value04, a.value05, a.value06, a.value07, a.value08, a.value09, a.value10, "+
				"        a.value11, a.value12, a.value13, a.value14, a.value15, a.value16, a.value17, a.value18, a.value19, a.value20, "+
				"        a.value21, a.value22, a.value23, a.value24, a.value25, a.value26, a.value27, a.value28, NVL(a.value29,'N') value29, NVL(a.value30,'N') value30, "+
				"        NVL(a.value31,'N') value31, NVL(a.value32,'N') value32, NVL(a.value33,'N') value33, a.value34, a.value35, a.value36, "+
				"        decode(a.value37,'','', '1', '법인', '2', '개인', '개인사업자') value37,  "+
				"        a.value38, NVL(a.value39,'N') value39, NVL(a.value40,'N') value40, "+
				"        a.value41, a.value42, a.value43, a.value44, a.value45, "+
				"        to_char(reg_dt,'YYYYMMDD') as reg_dt2, b.user_nm as reg_nm, c.ins_com_nm "+
			    " from   ins_excel_com a, users b, ins_com c "+
				" where  a.gubun='배서' and a.reg_id=b.user_id(+) AND a.value14=c.ins_com_id ";

		//보험사
		if(!gubun1.equals(""))	query += " and a.value14='"+gubun1+"'";

		//상태
		if(!gubun2.equals(""))	query += " and a.use_st='"+gubun2+"'";

		//기간
		if(gubun3.equals("당일"))			query += " and to_char(a.reg_dt,'YYYYMMDD')= to_char(sysdate,'YYYYMMDD')";
		else if(gubun3.equals("전일"))	query += " and to_char(a.reg_dt,'YYYYMMDD')= to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun3.equals("당해"))	query += " and to_char(a.reg_dt,'YYYY')= to_char(sysdate,'YYYY')";
		else if(gubun3.equals("당월"))	query += " and substr(to_char(a.reg_dt,'YYYYMM'), 1,6)= to_char(sysdate,'YYYYMM')";
		else if(gubun3.equals("전월"))	query += " and to_char(a.reg_dt,'YYYYMM')= to_char(add_months(sysdate, -1),'YYYYMM')";
		else if(gubun3.equals("기간")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and to_char(a.reg_dt,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and to_char(a.reg_dt,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		//차량번호
		if(s_kd.equals("1"))	what = "a.value01";	
		//증권번호
		if(s_kd.equals("2"))	what = "a.value02";	
		//차명
		if(s_kd.equals("3"))	what = "a.value04";	
		//고객명
		if(s_kd.equals("4"))	what = "a.value03";	
		//배서항목명
		if(s_kd.equals("5"))	what = "a.value08";	
		//비고
		if(s_kd.equals("6"))	what = "a.value11";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like '%"+t_wd+"%' ";
		}	

		query += " order by a.reg_dt desc";	

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
			//System.out.println("[InsComDatabase:getInsComCngList]\n"+e);
			//System.out.println("[InsComDatabase:getInsComCngList]\n"+query);
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
	
	

	//배서현황 리스트 (결제금액 중복건)
		public int getCheckOverInsCng(String ins_con_no, String ins_st, String ch_amt)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";
			
			query = " SELECT count(*) cnt "+
					" FROM INS_EXCEL_COM "+
					" WHERE GUBUN='배서' "+
					" AND VALUE02 = '"+ins_con_no+"' "+
					" AND ins_st ='"+ins_st+"' "+
					" AND value17='"+ch_amt+"' "+
					" AND value17 <> '0' "+
					" AND VALUE17 IS NOT null "+
					" ";
			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:getCheckOverInsCng(String ins_con_no, String ins_st, String ch_amt)]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null)		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}
		
		//배서현황 결제금액 중복건 값변경
		public boolean updateInsExcelComCng(String reg_code, String seq)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			String query = "";
			
			query =	" UPDATE INS_EXCEL_COM SET "+
					" value17 ='0', value19 ='0' , "+ 
					" value20 ='0', value21 ='0' , "+
					" value22 ='0', value23 ='0' , "+
					" value27 ='0', etc='동일 결제금액건' "+
					" WHERE REG_CODE = '"+reg_code+"' "+
					" AND SEQ ='"+seq+"' "+
					" ";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				flag = true;
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				flag = false;
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
		}

	//해지현황 리스트
	public Vector getInsComClsList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select a.reg_code, a.seq, a.gubun, a.use_st, a.reg_id, a.reg_dt, a.req_id, a.req_dt, a.cof_code, a.end_id, a.end_dt, "+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.ins_st, a.etc, "+
				"        a.value01, a.value02, a.value03, a.value04, a.value05, a.value06, a.value07, a.value08, a.value09, a.value10, "+
				"        a.value11, a.value12, a.value13, a.value14, a.value15, a.value16, a.value17, a.value18, a.value19, a.value20, "+
				"        a.value21, a.value22, a.value23, a.value24, a.value25, a.value26, a.value27, a.value28, a.value29, a.value30, "+
				"        to_char(reg_dt,'YYYYMMDD') as reg_dt2, b.user_nm as reg_nm, c.ins_com_nm, a.save_yn "+
			    " from   ins_excel_com a, users b, ins_com c "+
				" where  a.gubun='해지' and a.reg_id=b.user_id(+) AND a.value09=c.ins_com_id ";

		//보험사
		if(!gubun1.equals(""))	query += " and a.value09='"+gubun1+"'";

		//상태
		if(!gubun2.equals(""))	query += " and a.use_st='"+gubun2+"'";

		//기간
		if(gubun3.equals("당일"))			query += " and to_char(a.reg_dt,'YYYYMMDD')= to_char(sysdate,'YYYYMMDD')";
		else if(gubun3.equals("전일"))	query += " and to_char(a.reg_dt,'YYYYMMDD')= to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun3.equals("당해"))	query += " and to_char(a.reg_dt,'YYYY')= to_char(sysdate,'YYYY')";
		else if(gubun3.equals("당월"))	query += " and to_char(a.reg_dt,'YYYYMM')= to_char(sysdate,'YYYYMM')";
		else if(gubun3.equals("전월"))	query += " and to_char(a.reg_dt,'YYYYMM')= to_char(add_months(sysdate,-1), 'YYYYMM')";
		else if(gubun3.equals("기간")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and to_char(a.reg_dt,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and to_char(a.reg_dt,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		//차량번호
		if(s_kd.equals("1"))	what = "a.value01";	
		//증권번호
		if(s_kd.equals("2"))	what = "a.value02";	
		//차명
		if(s_kd.equals("3"))	what = "a.value03";	
		//등록자
		if(s_kd.equals("4"))	what = "b.user_nm";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like '%"+t_wd+"%' ";
		}	

		query += " order by a.reg_dt, a.reg_code, a.seq ";	
		
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
			//System.out.println("[InsComDatabase:getInsComClsList]\n"+e);
			//System.out.println("[InsComDatabase:getInsComClsList]\n"+query);
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
	
	

	//가입증명서
	public Vector getInsComFileList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

			
		query =	"  SELECT /*+ rule */ a.* FROM ( \r\n" + 
				" 	SELECT a.SEQ, a.CONTENT_SEQ, a.FILE_TYPE, a.reg_date, TO_CHAR(a.REG_DATE,'YYYYMMDD') reg_dt2, a.FILE_NAME,  nvl(b.INS_COM_ID, g.value14) ins_com_id, decode(h.sort,0,'',h.sort) sort, \r\n" + 
				"			nvl(b.INS_CON_NO,g.value15) ins_con_no, b.INS_START_DT, DECODE(d.CAR_MNG_ID, '',b.INS_EXP_DT, d.exp_dt) ins_exp_dt, nvl(c.CAR_NO, g.value04) car_no , nvl(c.CAR_NM,g.value03) CAR_NM, e.ins_com_nm, f.user_nm as reg_nm, \r\n" + 
				"			nvl(g.rent_l_cd, i.rent_l_cd) AS rent_l_cd, nvl(g.rent_mng_id, i.rent_mng_id) AS rent_mng_id, j.FIRM_NM, j.ENP_NO, b.ins_st, decode(b.ins_st, '0', '가입', '갱신') gubun, '' value12 \r\n" + 
				" 	FROM   (SELECT * FROM ACAR_ATTACH_FILE WHERE seq in (SELECT max(TO_NUMBER(SEQ)) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE ='INSUR' AND ISDELETED='N' GROUP BY CONTENT_SEQ)) a, insur b, car_reg c, ins_cls d, ins_com e, users f, \r\n" + 
				" 	(SELECT * FROM ins_excel_com WHERE gubun='가입' AND use_st <> '취소') g, file_sort h, (SELECT CLIENT_ID, CAR_MNG_ID, RENT_L_CD, RENT_MNG_ID FROM cont WHERE USE_YN = 'Y') i, client j      \r\n" + 
				" 	WHERE  a.content_code='INSUR' AND a.isdeleted='N' \r\n" + 
				"  		AND a.CONTENT_SEQ NOT like '%#_%' ESCAPE '#' \r\n" + 
				"  		AND a.content_seq = b.ins_con_no(+) 	\r\n" + 
				"  		AND b.car_mng_id=c.car_mng_id(+)	\r\n" + 
				"  		AND b.car_mng_id=d.car_mng_id(+) 	\r\n" + 
				"  		AND b.ins_st=d.ins_st(+) 	\r\n" + 
				"  		AND b.ins_com_id=e.ins_com_id(+) 	\r\n" + 
				"  		AND b.CAR_MNG_ID = i.CAR_MNG_ID(+) 	\r\n" + 
				"  		AND i.CLIENT_ID = j.CLIENT_ID(+) 	\r\n" + 
				"  		AND a.reg_userseq=f.user_id(+)	\r\n" + 
				"  		AND a.content_seq = g.VALUE15(+) 	\r\n" + 
				"  		AND a.seq = h.SEQ(+)\r\n" + 
				" 	UNION ALL \r\n" + 
				" 	SELECT a.SEQ, a.CONTENT_SEQ, a.FILE_TYPE, a.reg_date, TO_CHAR(a.REG_DATE,'YYYYMMDD') reg_dt2, a.FILE_NAME,b.INS_COM_ID,  decode(h.sort,0,'',h.sort) sort, \r\n" + 
				"			b.INS_CON_NO, b.INS_START_DT, DECODE(d.CAR_MNG_ID, '',b.INS_EXP_DT, d.exp_dt) ins_exp_dt, c.CAR_NO, c.CAR_NM, e.ins_com_nm, f.user_nm as reg_nm, \r\n" + 
				"			 i.RENT_L_CD , i.RENT_MNG_ID, j.FIRM_NM, j.ENP_NO, b.ins_st, decode(b.ins_st, '0', '가입', '갱신') gubun, '' value12  \r\n" + 
				" 	FROM   (SELECT * FROM ACAR_ATTACH_FILE WHERE seq in (SELECT max(TO_NUMBER(SEQ)) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE ='INSUR' AND ISDELETED='N' GROUP BY CONTENT_SEQ)) a, insur b, car_reg c, ins_cls d,  ins_com e, users f,\r\n" + 
				"			file_sort h , cont i, client j   			\r\n" + 
				" 	WHERE  a.content_code='INSUR' AND a.isdeleted='N'  \r\n" + 
				" 		AND b.ins_con_no IS NOT NULL \r\n" + 
				" 		AND b.car_mng_id=c.car_mng_id(+) \r\n" + 
				"  		AND b.car_mng_id=d.car_mng_id(+) 	\r\n" + 
				"  		AND b.ins_st=d.ins_st(+) 	\r\n" + 
				"  		AND b.ins_com_id=e.ins_com_id(+) \r\n" + 
				"	 	AND a.reg_userseq=f.user_id(+) \r\n" + 
				"	 	AND i.CLIENT_ID = j.CLIENT_ID(+) \r\n" + 
				"	 	AND b.INS_CON_NO||'_'||b.INS_START_DT ||'_'||b.INS_EXP_DT = a.CONTENT_SEQ(+)\r\n" + 
				"	 	AND a.seq = h.seq (+)\r\n" + 
				"	 	AND b.CAR_MNG_ID = i.CAR_MNG_ID\r\n" +
				"		AND i.reg_dt||i.rent_l_cd=(select max(reg_dt||rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=b.car_mng_id)\r\n" +
				" 	UNION ALL \r\n" + 
				" 	SELECT a.SEQ, a.CONTENT_SEQ, a.FILE_TYPE, a.reg_date, TO_CHAR(a.REG_DATE,'YYYYMMDD') reg_dt2, a.FILE_NAME,  nvl(b.INS_COM_ID, g.value14) ins_com_id, decode(h.sort,0,'',h.sort) sort, \r\n" + 
				"			nvl(b.INS_CON_NO,g.value15) ins_con_no, b.INS_START_DT, DECODE(d.CAR_MNG_ID, '',b.INS_EXP_DT, d.exp_dt) ins_exp_dt, nvl(c.CAR_NO, g.value04) car_no , nvl(c.CAR_NM,g.value03) CAR_NM, e.ins_com_nm, f.user_nm as reg_nm, \r\n" + 
				"			g.rent_l_cd, g.rent_mng_id, j.FIRM_NM, j.ENP_NO, b.ins_st, g.gubun, g.value12 \r\n" + 
				" 	FROM   (SELECT * FROM ACAR_ATTACH_FILE WHERE seq in (SELECT max(TO_NUMBER(SEQ)) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE ='INSUR' AND ISDELETED='N' GROUP BY CONTENT_SEQ)) a, insur b, car_reg c, ins_cls d, ins_com e, users f, \r\n" + 
				" 	(SELECT * FROM ins_excel_com WHERE gubun='배서' AND use_st = '완료') g, file_sort h, cont i, client j      \r\n" + 
				" 	WHERE  a.content_code='INSUR' AND a.isdeleted='N' \r\n" + 
				"  		AND a.CONTENT_SEQ NOT like '%#_%' ESCAPE '#' \r\n" + 
				"  		AND a.content_seq = b.ins_con_no(+) 	\r\n" + 
				"  		AND b.car_mng_id=c.car_mng_id(+)	\r\n" + 
				"  		AND b.car_mng_id=d.car_mng_id(+) 	\r\n" + 
				"  		AND b.ins_st=d.ins_st(+) 	\r\n" + 
				"  		AND b.ins_com_id=e.ins_com_id(+) 	\r\n" + 
				"  		AND b.CAR_MNG_ID = i.CAR_MNG_ID(+) 	\r\n" + 
				"  		AND i.RENT_L_CD = g.rent_l_cd 	\r\n" + 
				"  		AND i.CLIENT_ID = j.CLIENT_ID(+) 	\r\n" + 
				"  		AND a.reg_userseq=f.user_id(+)	\r\n" + 
				"  		AND a.content_seq = g.VALUE15 	\r\n" + 
				"  		AND a.seq = h.SEQ(+)\r\n" + 
				"	)a WHERE 1=1  ";

		//보험사
		if(!gubun1.equals(""))	query += " and a.ins_com_id='"+gubun1+"'";
		if(gubun4.equals("신규"))	{
			query += " and (a.INS_ST = '0' OR a.INS_ST is NULL) and a.gubun <> '배서'";
		} else if(gubun4.equals("갱신"))	{
			query += " and (a.INS_ST <> '0' and a.INS_ST IS NOT NULL) and a.gubun <> '배서'";
		} else if(gubun4.equals("변경"))	{
			query += " and a.gubun = '배서'";
		}


		//기간
		if(gubun3.equals("당일"))			query += " and to_char(a.reg_date,'YYYYMMDD')= to_char(sysdate,'YYYYMMDD')";
		else if(gubun3.equals("전일"))	query += " and to_char(a.reg_date,'YYYYMMDD')= to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun3.equals("기간")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and to_char(a.reg_date,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and to_char(a.reg_date,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		//차량번호
		if(s_kd.equals("1"))	what = "a.car_no";	
		//증권번호
		if(s_kd.equals("2"))	what = "a.ins_con_no";	
		//차명
		if(s_kd.equals("3"))	what = "a.car_nm";	
		//상호명
		if(s_kd.equals("4"))	what = "a.FIRM_NM";	
		//사업자번호
		if(s_kd.equals("5"))	what = "a.ENP_NO";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like '%"+t_wd+"%' ";
		}	

		if(gubun3.equals("당일"))			query += " order by to_char(a.reg_date,'YYYYMMDD'), TO_NUMBER(sort)";
		else if(gubun3.equals("전일"))	query += " order by to_char(a.reg_date,'YYYYMMDD'), TO_NUMBER(sort)";
		else if(gubun3.equals("기간")){
			query += " order by to_char(a.reg_date,'YYYYMMDD') desc, TO_NUMBER(sort)";
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
			//System.out.println("[InsComDatabase:getInsComFileList]\n"+e);
			//System.out.println("[InsComDatabase:getInsComFileList]\n"+query);
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
	//기타증명서
	public Vector getInsComFileList2(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " SELECT a.SEQ, DECODE(substr(a.CONTENT_SEQ,0,5),'E0038','렌터카공제조합','E0008','DB손해보험','E0007','삼성화재','렌터카공제조합') INS_COM, "+
				"        DECODE(substr(a.CONTENT_SEQ,INSTR(a.CONTENT_SEQ,'_',-1)+1,LENGTH(a.CONTENT_SEQ)),'2','갱신','3','배서','4','해지') AS TYPE, "+
				"         a.FILE_TYPE, a.reg_date, TO_CHAR(a.REG_DATE,'YYYYMMDD') reg_dt2, a.FILE_NAME,  "+
				"        f.user_nm as reg_nm   "+
				" FROM   ACAR_ATTACH_FILE a, users f  "+
				" WHERE  a.content_code='INSUR' AND a.isdeleted='N' "+
				" 		 AND SUBSTR(a.CONTENT_SEQ,INSTR(a.CONTENT_SEQ,'_',-1)+1,LENGTH(a.CONTENT_SEQ)) IN ('2','3','4')  "+
				"        AND a.reg_userseq=f.user_id(+) "+
				" ";

		//보험사
		if(!gubun1.equals(""))	query += " and DECODE(substr(a.CONTENT_SEQ,0,5),'E0038','0038','E0008','0008','E0007','0007','0038')='"+gubun1+"'";


		//기간
		if(gubun3.equals("당일"))			query += " and to_char(a.reg_date,'YYYYMMDD')= to_char(sysdate,'YYYYMMDD')";
		else if(gubun3.equals("전일"))	query += " and to_char(a.reg_date,'YYYYMMDD')= to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun3.equals("기간")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and to_char(a.reg_date,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and to_char(a.reg_date,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		//파일명
		if(s_kd.equals("1"))	what = "a.FILE_NAME";	
		//등록자
		if(s_kd.equals("2"))	what = "f.user_nm";	
		/*//차명
		if(s_kd.equals("3"))	what = "c.car_nm";	
*/
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like '%"+t_wd+"%' ";
		}	

		query += " order by a.reg_date desc";	

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
			//System.out.println("[InsComDatabase:getInsComFileList2]\n"+e);
			//System.out.println("[InsComDatabase:getInsComFileList2]\n"+query);
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
	
	//가입증명서
		public Vector getInsComFileList(String car_mng_id)
		{
			
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String what = "";

			query = " SELECT * FROM ( "+               
					"	SELECT ROW_NUMBER() OVER (ORDER BY  TO_NUMBER(to_char(reg_date,'YYYYMMDD')) desc ) num, "+
					"	seq, content_code, content_seq, file_name, file_size, file_type, save_file, save_folder, reg_userseq, reg_date, isdeleted, to_char(reg_date,'YYYYMMDD') reg_dt "+  
					"	FROM ACAR_ATTACH_FILE a, INSUR b  "+
					"	WHERE CAR_MNG_ID='"+car_mng_id+"' AND INS_ST= (SELECT MAX(TO_NUMBER(INS_ST)) FROM INSUR WHERE CAR_MNG_ID='"+car_mng_id+"') AND ISDELETED ='N' "+
					"	AND a.CONTENT_SEQ = b.INS_CON_NO  "+
					" )WHERE num = 1 "+
			
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
				//System.out.println("[InsComDatabase:getInsComFileList]\n"+e);
				//System.out.println("[InsComDatabase:getInsComFileList]\n"+query);
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

		//가입증명서 요청리스트
		public Vector getInsComFilereqList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String what = "";

			query = "  SELECT a.REG_CODE, a.SEQ, a.GUBUN, a.USE_ST, a.REG_ID, TO_CHAR(a.REG_DT,'YYYYMMDDHH24MI') REG_DT, a.RENT_MNG_ID, a.RENT_L_CD, "+ 
			 		"  	a.CAR_MNG_ID, a.INS_ST, a.VALUE01 INS_CON_NO, a.VALUE02 CAR_NO, a.VALUE03 CAR_NUM,  "+
			 		"  	a.VALUE04 INS_START_DT, a.VALUE05 INS_EXP_DT, a.VALUE06 FIRM_NM, a.VALUE08 CAR_NM, "+ 
			 		"  	CASE WHEN e.car_st='5' THEN '1288147957' WHEN f.client_st='2' THEN SUBSTR(text_decrypt(f.ssn, 'pw'),0,6) ELSE f.enp_no END AS enp_no,  "+ 
			 		"  	b.ISDELETED, b.SEQ FILE_SEQ, b.CONTENT_SEQ, b.FILE_NAME, b.FILE_TYPE, "+ 
			 		"	substr(c.USER_NM,0,3) REG_NM, DECODE(d.INS_STS,'1','진행','해지') INS_STS, "+
			 		"	a.ETC, g.INS_COM_NM, c.USER_M_TEL  "+
			 		"   FROM INS_EXCEL_COM a, "+
			 		"   		(SELECT * FROM ACAR_ATTACH_FILE WHERE seq in (SELECT max(TO_NUMBER(SEQ)) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE ='INSUR' AND ISDELETED='N' GROUP BY CONTENT_SEQ)) b, "+
			 		"   		USERS c, "+
			 		"   		insur d, "+
			 		"   		cont_n_view e, "+
			 		"   		client f,  "+
			 		"   		ins_com g "+
			 		"   WHERE a.GUBUN ='증명'  "+
			 		"   AND a.REG_ID = c.USER_ID "+ 
			 		"   AND a.VALUE01||'_'||a.VALUE04 ||'_'||a.VALUE05 = b.CONTENT_SEQ(+)  "+
			 		"   AND a.CAR_MNG_ID = d.CAR_MNG_ID "+
			 		"   AND a.INS_ST = d.INS_ST "+
			 		"   AND a.RENT_MNG_ID = e.RENT_MNG_ID "+
			 		"   AND a.RENT_L_CD = e.RENT_L_CD "+
			 		"   AND e.CLIENT_ID = f.CLIENT_ID "+
			 		"   AND d.INS_COM_ID = g.INS_COM_ID "+
			 		"";	
			//보험사
			if(!gubun1.equals(""))	query += " and d.ins_com_id='"+gubun1+"'";

			//상태
			if(!gubun2.equals("")) query += " and a.use_st='"+gubun2+"'";
			
			//기간
			if(gubun3.equals("당일"))			query += " and to_char(a.reg_dt,'YYYYMMDD')= to_char(sysdate,'YYYYMMDD')";
			else if(gubun3.equals("전일"))	query += " and to_char(a.reg_dt,'YYYYMMDD')= to_char(sysdate-1,'YYYYMMDD')";
			else if(gubun3.equals("기간")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and to_char(a.reg_dt,'YYYYMMDD') like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and to_char(a.reg_dt,'YYYYMMDD') between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			//차량번호
			if(s_kd.equals("1"))	what = "a.VALUE02";	
			//증권번호
			if(s_kd.equals("2"))	what = "a.VALUE01";	
			//상호
			if(s_kd.equals("3"))	what = "a.VALUE06";	
			//차대번호
			if(s_kd.equals("4"))	what = "a.VALUE03";	
			//사업자번호
			if(s_kd.equals("5"))	what = "CASE WHEN e.car_st='5' THEN '1288147957' WHEN f.client_st='2' THEN SUBSTR(text_decrypt(f.ssn, 'pw'),0,6) ELSE f.enp_no END";	
			//등록자
			if(s_kd.equals("6"))	what = "c.USER_NM";	

			if(!s_kd.equals("") && !t_wd.equals("")){
				query += " and "+what+" like '%"+t_wd+"%' ";
			}	

			query += " order by a.reg_dt desc";	

			
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
				//System.out.println("[InsComDatabase:getInsComFileList]\n"+e);
				//System.out.println("[InsComDatabase:getInsComFileList]\n"+query);
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

		
		//가입증명서 요청정보
		public Hashtable getInsComFilereqSelect(String file_seq)
		{
			getConnection();
			Hashtable ht = new Hashtable();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";

			query = "  SELECT a.REG_CODE, a.SEQ, a.GUBUN, a.USE_ST, a.REG_ID, TO_CHAR(a.REG_DT,'YYYYMMDD') REG_DT, a.RENT_MNG_ID, a.RENT_L_CD, "+ 
			 		"  	a.CAR_MNG_ID, a.INS_ST, a.VALUE01 INS_CON_NO, a.VALUE02 CAR_NO, a.VALUE03 CAR_NUM,  "+
			 		"  	a.VALUE04 INS_START_DT, a.VALUE05 INS_EXP_DT, a.VALUE06 FIRM_NM, a.VALUE08 CAR_NM, "+ 
			 		"  	CASE WHEN e.car_st='5' THEN '1288147957' WHEN f.client_st='2' THEN SUBSTR(text_decrypt(f.ssn, 'pw'),0,6) ELSE f.enp_no END AS enp_no,  "+ 
			 		"  	b.ISDELETED, b.SEQ FILE_SEQ, b.CONTENT_SEQ, b.FILE_NAME, b.FILE_TYPE, b.FILE_SIZE, "+ 
			 		"	substr(c.USER_NM,0,3) REG_NM, DECODE(d.INS_STS,'1','진행','해지') INS_STS, DECODE(c.HOT_TEL,'',c.USER_M_TEL,c.HOT_TEL) TEL "+
			 		"   FROM INS_EXCEL_COM a, "+
			 		"   		(SELECT * FROM ACAR_ATTACH_FILE WHERE seq in (SELECT max(TO_NUMBER(SEQ)) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE ='INSUR' AND ISDELETED='N' GROUP BY CONTENT_SEQ)) b, "+
			 		"   		USERS c, "+
			 		"   		insur d, "+
			 		"   		cont_n_view e, "+
			 		"   		client f  "+
			 		"   WHERE a.GUBUN ='증명'  "+
			 		"   AND a.REG_ID = c.USER_ID "+ 
			 		"   AND a.VALUE01||'_'||a.VALUE04 ||'_'||a.VALUE05 = b.CONTENT_SEQ(+)  "+
			 		"   AND a.CAR_MNG_ID = d.CAR_MNG_ID "+
			 		"   AND a.INS_ST = d.INS_ST "+
			 		"   AND a.RENT_MNG_ID = e.RENT_MNG_ID "+
			 		"   AND a.RENT_L_CD = e.RENT_L_CD "+
			 		"   AND e.CLIENT_ID = f.CLIENT_ID "+
			 		"   AND b.seq = '"+ file_seq +"'  "+
			 		"";	
		
			
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
				//System.out.println("[InsComDatabase:getInsComFileList]\n"+e);
				//System.out.println("[InsComDatabase:getInsComFileList]\n"+query);
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
		
		//가입증명서 파일 검색
		public Hashtable getInsComFileSelect(String file_seq)
		{
			getConnection();
			Hashtable ht = new Hashtable();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";

			query =	"  SELECT /*+ rule */ a.* FROM ( \r\n" + 
					" 	SELECT a.SEQ, a.CONTENT_SEQ, a.FILE_TYPE, a.FILE_SIZE, a.reg_date, TO_CHAR(a.REG_DATE,'YYYYMMDD') reg_dt2, a.FILE_NAME,  nvl(b.INS_COM_ID, g.value14) ins_com_id, decode(h.sort,0,'',h.sort) sort, \r\n" + 
					"			nvl(b.INS_CON_NO,g.value15) ins_con_no, b.INS_START_DT, DECODE(d.CAR_MNG_ID, '',b.INS_EXP_DT, d.exp_dt) ins_exp_dt, nvl(c.CAR_NO, g.value04) car_no , nvl(c.CAR_NM,g.value03) CAR_NM, e.ins_com_nm, f.user_nm as reg_nm, \r\n" + 
					"			nvl(g.rent_l_cd, i.rent_l_cd) rent_l_cd, nvl(g.rent_mng_id, i.rent_mng_id) rent_mng_id, j.FIRM_NM, DECODE(f.HOT_TEL,'',f.USER_M_TEL,f.HOT_TEL) TEL \r\n" + 
					" 	FROM   (SELECT * FROM ACAR_ATTACH_FILE WHERE seq in (SELECT max(TO_NUMBER(SEQ)) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE ='INSUR' AND ISDELETED='N' GROUP BY CONTENT_SEQ)) a, insur b, car_reg c, ins_cls d, ins_com e, users f, \r\n" + 
					" 	(SELECT * FROM ins_excel_com WHERE gubun='가입' AND use_st <> '취소') g, file_sort h, cont i,  client j   \r\n" + 
					" 	WHERE  a.content_code='INSUR' AND a.isdeleted='N' \r\n" + 
					"  		AND a.CONTENT_SEQ NOT like '%#_%' ESCAPE '#' \r\n" + 
					"  		AND a.content_seq = b.ins_con_no(+) 	\r\n" + 
					"  		AND b.car_mng_id=c.car_mng_id(+)	\r\n" + 
					"  		AND b.car_mng_id=d.car_mng_id(+) 	\r\n" + 
					"  		AND b.ins_st=d.ins_st(+) 	\r\n" + 
					"  		AND b.ins_com_id=e.ins_com_id(+) 	\r\n" + 
					"  		AND a.reg_userseq=f.user_id(+)	\r\n" + 
					"  		AND a.content_seq = g.VALUE15(+) 	\r\n" + 
					"  		AND a.seq = h.SEQ(+)\r\n" + 
					"  		AND b.CAR_MNG_ID = i.CAR_MNG_ID\r\n" +
					"		AND i.reg_dt||i.rent_l_cd=(select max(reg_dt||rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=b.car_mng_id)\r\n" +
					"		AND i.CLIENT_ID = j.CLIENT_ID\r\n" +
					" 	UNION ALL \r\n" + 
					" 	SELECT a.SEQ, a.CONTENT_SEQ, a.FILE_TYPE, a.FILE_SIZE, a.reg_date, TO_CHAR(a.REG_DATE,'YYYYMMDD') reg_dt2, a.FILE_NAME,b.INS_COM_ID,  decode(h.sort,0,'',h.sort) sort, \r\n" + 
					"			b.INS_CON_NO, b.INS_START_DT, DECODE(d.CAR_MNG_ID, '',b.INS_EXP_DT, d.exp_dt) ins_exp_dt, c.CAR_NO, c.CAR_NM, e.ins_com_nm, f.user_nm as reg_nm, \r\n" + 
					"			 i.RENT_L_CD , i.RENT_MNG_ID, j.FIRM_NM, DECODE(f.HOT_TEL,'',f.USER_M_TEL,f.HOT_TEL) TEL  \r\n" + 
					" 	FROM   (SELECT * FROM ACAR_ATTACH_FILE WHERE seq in (SELECT max(TO_NUMBER(SEQ)) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE ='INSUR' AND ISDELETED='N' GROUP BY CONTENT_SEQ)) a, insur b, car_reg c, ins_cls d,  ins_com e, users f,\r\n" + 
					"			file_sort h , cont i  , client j 			\r\n" + 
					" 	WHERE  a.content_code='INSUR' AND a.isdeleted='N'  \r\n" + 
					" 		AND b.ins_con_no IS NOT NULL \r\n" + 
					" 		AND b.car_mng_id=c.car_mng_id(+) \r\n" + 
					"  		AND b.car_mng_id=d.car_mng_id(+) 	\r\n" + 
					"  		AND b.ins_st=d.ins_st(+) 	\r\n" + 
					"  		AND b.ins_com_id=e.ins_com_id(+) \r\n" + 
					"	 	AND a.reg_userseq=f.user_id(+) \r\n" + 
					"	 	AND b.INS_CON_NO||'_'||b.INS_START_DT ||'_'||b.INS_EXP_DT = a.CONTENT_SEQ(+)\r\n" + 
					"	 	AND a.seq = h.seq (+)\r\n" + 
					"	 	AND b.CAR_MNG_ID = i.CAR_MNG_ID\r\n" +
					"		AND i.reg_dt||i.rent_l_cd=(select max(reg_dt||rent_l_cd) from cont where rent_l_cd not like 'RM%' and car_mng_id=b.car_mng_id)\r\n" + 
					"		AND i.CLIENT_ID = j.CLIENT_ID\r\n" + 
					"	)a WHERE 1=1  \r\n"+
			 		"   AND a.seq = '"+ file_seq +"'  "+
			 		"";	
		
			
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
				//System.out.println("[InsComDatabase:getInsComFileList]\n"+e);
				//System.out.println("[InsComDatabase:getInsComFileList]\n"+query);
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
	
		//계약 정보
		public Hashtable getContInfo(String rent_mng_id, String rent_l_cd)
		{
			getConnection();
			Hashtable ht = new Hashtable();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";

			query = "  SELECT * FROM CONT "+ 
			 		"   WHERE rent_mng_id ='"+ rent_mng_id +"'  "+
			 		"   AND rent_l_cd = '"+ rent_l_cd +"'  "+
			 		"";	
		
			
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
				//System.out.println("[InsComDatabase:getInsComFileList]\n"+e);
				//System.out.println("[InsComDatabase:getInsComFileList]\n"+query);
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
	
		
	//보험미요청현황 리스트
	public Vector getInsComRegList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select a.reg_code, a.seq, a.gubun, a.use_st, a.reg_dt, a.reg_dt2, b.user_nm as reg_nm, c.ins_com_nm, "+
				"        a.firm_nm, a.ssn, a.car_nm, a.car_no, a.car_num, a.cng_item, a.a_item, a.b_item "+ 
			    " from ("+
		
                "  		 select reg_code, seq, gubun, use_st, reg_dt, to_char(reg_dt,'YYYYMMDD') reg_dt2, reg_id, "+
				"               value01 as firm_nm,  "+
				"               value02 as ssn,  "+
				"               value03 as car_nm, "+
				"               value04 as car_no, "+
				"               value05 as car_num, "+
				"               value07 as ins1, "+
				"               value08 as ins2, "+
				"               value09 as ins3, "+
				"               value10 as ins4, "+
				"               value11 as bk1, "+
				"               value12 as bk2, "+
				"               value13 as bk3, "+
				"               '' as cng_item, "+
				"               '' as a_item, "+
				"               '' as b_item, "+
				"               value14 AS ins_com_id "+
				"        from   ins_excel_com "+
				"        where  use_st='등록' and gubun='가입' "+

                "        union all "+

                "  		 select reg_code, seq, gubun, use_st, reg_dt, to_char(reg_dt,'YYYYMMDD') reg_dt2, reg_id, "+
				"               value23 as firm_nm,  "+
				"               value25 as ssn,  "+
				"               value06 as car_nm, "+
				"               value04 as car_no, "+
				"               value05 as car_num, "+
				"               value14 as ins1, "+
				"               value15 as ins2, "+
				"               value16 as ins3, "+
				"               value21 as ins4, "+
				"               value27 as bk1, "+
				"               value28 as bk2, "+
				"               value29 as bk3, "+
				"               '' as cng_item, "+
				"               '' as a_item, "+
				"               '' as b_item, "+
				"               value30 AS ins_com_id "+
				"        from   ins_excel_com "+
				"        where  use_st='등록' and gubun='갱신' "+

                "        union all "+

                "  		 select reg_code, seq, gubun, use_st, reg_dt, to_char(reg_dt,'YYYYMMDD') reg_dt2, reg_id, "+
				"               value03 as firm_nm,  "+
				"               value05 as ssn,  "+
				"               value04 as car_nm, "+
				"               value01 as car_no, "+
				"               value02 as car_num, "+
				"               value06 as ins1, "+
				"               value07 as ins2, "+
				"               value08 as ins3, "+
				"               value10 as ins4, "+
				"               '' as bk1, "+
				"               '' as bk2, "+
				"               '' as bk3, "+
				"               value08 as cng_item, "+
				"               value09 as a_item, "+
				"               value10 as b_item, "+
				"               value14 AS ins_com_id "+
				"        from   ins_excel_com "+
				"        where  use_st='등록' and gubun='배서' "+

				"	   ) a, users b, ins_com c "+
				" where a.reg_id=b.user_id(+) AND a.ins_com_id=c.ins_com_id ";

		if(!gubun1.equals(""))	query += " and a.ins_com_id='"+gubun1+"'";

		if(!gubun2.equals(""))	query += " and a.gubun='"+gubun2+"'";

		if(s_kd.equals("1"))	what = "a.car_no";	
		if(s_kd.equals("2"))	what = "a.car_num";	
		if(s_kd.equals("3"))	what = "a.car_nm";	
		if(s_kd.equals("4"))	what = "a.firm_nm";	

		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like '%"+t_wd+"%' ";
		}	

		query += " order by a.reg_dt desc";	

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
			//System.out.println("[InsComDatabase:getInsComRegList]\n"+e);
			//System.out.println("[InsComDatabase:getInsComRegList]\n"+query);
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

	public InsurExcelBean getInsExcelCom(String reg_code, String seq)
	{
		getConnection();
		InsurExcelBean bean = new InsurExcelBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select reg_code, seq, gubun, use_st, reg_id, reg_dt, req_id, req_dt, cof_code, end_id, end_dt, "+
				"        rent_mng_id, rent_l_cd, car_mng_id, ins_st, etc, "+
				"        value01, value02, value03, value04, value05, value06, value07, value08, value09, value10, "+
				"        value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, "+
				"        value21, value22, value23, value24, value25, value26, value27, value28, value29, value30, "+
				"        value31, value32, value33, value34, value35, value36, value37, value38, value39, value40, "+
				"        value41, value42, value43, value44, value45 "+
				" from   ins_excel_com "+
				" where  reg_code=? and seq=?"+
				"  ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, reg_code);
			pstmt.setString(2, seq);

	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setReg_code	(rs.getString("reg_code")	==null?"":rs.getString("reg_code"));
				bean.setSeq			(rs.getString("seq")		==null?0:Integer.parseInt(rs.getString("seq")));
				bean.setGubun		(rs.getString("gubun")		==null?"":rs.getString("gubun"));
				bean.setUse_st 		(rs.getString("use_st")		==null?"":rs.getString("use_st"));
				bean.setReg_id		(rs.getString("reg_id")		==null?"":rs.getString("reg_id"));
				bean.setReg_dt		(rs.getString("reg_dt")		==null?"":rs.getString("reg_dt"));
				bean.setReq_id 		(rs.getString("req_id")		==null?"":rs.getString("req_id"));
				bean.setReq_dt 		(rs.getString("req_dt")		==null?"":rs.getString("req_dt"));
				bean.setCof_code	(rs.getString("cof_code")	==null?"":rs.getString("cof_code"));
				bean.setEnd_dt 		(rs.getString("end_dt")		==null?"":rs.getString("end_dt"));
				bean.setEnd_id 		(rs.getString("end_id")		==null?"":rs.getString("end_id"));
				bean.setRent_mng_id	(rs.getString("rent_mng_id")==null?"":rs.getString("rent_mng_id"));
				bean.setRent_l_cd	(rs.getString("rent_l_cd")	==null?"":rs.getString("rent_l_cd"));			
				bean.setCar_mng_id	(rs.getString("car_mng_id")	==null?"":rs.getString("car_mng_id"));
				bean.setIns_st		(rs.getString("ins_st")		==null?"":rs.getString("ins_st"));
				bean.setEtc			(rs.getString("etc")		==null?"":rs.getString("etc"));
				bean.setValue01		(rs.getString("value01")	==null?"":rs.getString("value01"));
				bean.setValue02		(rs.getString("value02")	==null?"":rs.getString("value02"));
				bean.setValue03		(rs.getString("value03")	==null?"":rs.getString("value03"));
				bean.setValue04		(rs.getString("value04")	==null?"":rs.getString("value04"));
				bean.setValue05		(rs.getString("value05")	==null?"":rs.getString("value05"));
				bean.setValue06		(rs.getString("value06")	==null?"":rs.getString("value06"));
				bean.setValue07		(rs.getString("value07")	==null?"":rs.getString("value07"));
				bean.setValue08		(rs.getString("value08")	==null?"":rs.getString("value08"));
				bean.setValue09		(rs.getString("value09")	==null?"":rs.getString("value09"));
				bean.setValue10		(rs.getString("value10")	==null?"":rs.getString("value10"));
				bean.setValue11		(rs.getString("value11")	==null?"":rs.getString("value11"));
				bean.setValue12		(rs.getString("value12")	==null?"":rs.getString("value12"));
				bean.setValue13		(rs.getString("value13")	==null?"":rs.getString("value13"));
				bean.setValue14		(rs.getString("value14")	==null?"":rs.getString("value14"));
				bean.setValue15		(rs.getString("value15")	==null?"":rs.getString("value15"));
				bean.setValue16		(rs.getString("value16")	==null?"":rs.getString("value16"));
				bean.setValue17		(rs.getString("value17")	==null?"":rs.getString("value17"));
				bean.setValue18		(rs.getString("value18")	==null?"":rs.getString("value18"));
				bean.setValue19		(rs.getString("value19")	==null?"":rs.getString("value19"));
				bean.setValue20		(rs.getString("value20")	==null?"":rs.getString("value20"));
				bean.setValue21		(rs.getString("value21")	==null?"":rs.getString("value21"));
				bean.setValue22		(rs.getString("value22")	==null?"":rs.getString("value22"));
				bean.setValue23		(rs.getString("value23")	==null?"":rs.getString("value23"));
				bean.setValue24		(rs.getString("value24")	==null?"":rs.getString("value24"));
				bean.setValue25		(rs.getString("value25")	==null?"":rs.getString("value25"));
				bean.setValue26		(rs.getString("value26")	==null?"":rs.getString("value26"));
				bean.setValue27		(rs.getString("value27")	==null?"":rs.getString("value27"));
				bean.setValue28		(rs.getString("value28")	==null?"":rs.getString("value28"));
				bean.setValue29		(rs.getString("value29")	==null?"":rs.getString("value29"));
				bean.setValue30		(rs.getString("value30")	==null?"":rs.getString("value30"));
				bean.setValue31		(rs.getString("value31")	==null?"":rs.getString("value31"));
				bean.setValue32		(rs.getString("value32")	==null?"":rs.getString("value32"));
				bean.setValue33		(rs.getString("value33")	==null?"":rs.getString("value33"));
				bean.setValue34		(rs.getString("value34")	==null?"":rs.getString("value34"));
				bean.setValue35		(rs.getString("value35")	==null?"":rs.getString("value35"));
				bean.setValue36		(rs.getString("value36")	==null?"":rs.getString("value36"));
				bean.setValue37		(rs.getString("value37")	==null?"":rs.getString("value37"));
				bean.setValue38		(rs.getString("value38")	==null?"":rs.getString("value38"));
				bean.setValue39		(rs.getString("value39")	==null?"":rs.getString("value39"));
				bean.setValue40		(rs.getString("value40")	==null?"":rs.getString("value40"));
				bean.setValue41		(rs.getString("value41")	==null?"":rs.getString("value41"));
				bean.setValue42		(rs.getString("value42")	==null?"":rs.getString("value42"));
				bean.setValue43		(rs.getString("value43")	==null?"":rs.getString("value43"));
				bean.setValue44		(rs.getString("value44")	==null?"":rs.getString("value44"));
				bean.setValue45		(rs.getString("value45")	==null?"":rs.getString("value45"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			//System.out.println("[InsComDatabase:(InsurExcelBean)getInsExcelCom]"+ e);
			//System.out.println("[InsComDatabase:(InsurExcelBean)getInsExcelCom]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}	

	public Hashtable getInsExcelComCase(String reg_code, String seq)
	{
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select reg_code, seq, gubun, use_st, reg_id, reg_dt, req_id, req_dt, cof_code, end_id, end_dt, "+
				"        rent_mng_id, rent_l_cd, car_mng_id, ins_st, etc, "+
				"        value01, value02, value03, value04, value05, value06, value07, value08, value09, value10, "+
				"        value11, value12, value13, value14, value15, value16, value17, value18, value19, value20, "+
				"        value21, value22, value23, value24, value25, value26, value27, value28, value29, value30, "+
				"        value31, value32, value33, value34, value35, value36, value37, value38, value39, value40, "+
				"        value41, value42, value43, value44, value45, value46, value47, value48, value49, value50  "+
				" from   ins_excel_com "+
				" where  reg_code=? and seq=?"+
				"  ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, reg_code);
			pstmt.setString(2, seq);
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
			//System.out.println("[InsComDatabase:(Hashtable)getInsExcelCom]"+ e);
			//System.out.println("[InsComDatabase:(Hashtable)getInsExcelCom]"+ query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}	

    /**
     * 프로시져 호출
     */
    public boolean call_sp_ins_cng_req_com(String reg_code, int seq) 
	{
		getConnection();

		CallableStatement cstmt = null;
		boolean sResult = false;   
		
    	String query1 = "{CALL P_INS_CNG_REQ_COM     (?,?)}";

	    try{

			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, reg_code);
			cstmt.setInt   (2, seq);
			cstmt.execute();
			cstmt.close();
			sResult = true;

	  	} catch (Exception e) {
			//System.out.println("[InsDatabase:call_sp_ins_cng_req_com]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}
    
    /**
     * 프로시져 호출
     */
    public boolean call_sp_ins_cng_base_case2() 
	{
		getConnection();

		CallableStatement cstmt = null;
		boolean sResult = false;   
		
    	String query1 = "{CALL P_INS_CNG_BASE_CASE2 ()}";

	    try{

			cstmt = conn.prepareCall(query1);				
			cstmt.execute();
			cstmt.close();
			sResult = true;

	  	} catch (Exception e) {
			//System.out.println("[InsDatabase:call_sp_ins_cng_req_com]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}
    
	//차량번호,최초등록일로 rent_l_cd 값 얻기
	public String getAcarAttachFile()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rent_l_cd = "";
		String query = "";

		query ="SELECT * FROM "+
				"ACAR_ATTACH_FILE " +
				"WHERE CONTENT_CODE ='INSUR'"+
				"";
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){				
				rent_l_cd = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			//System.out.println("[InsDatabase:getRent_l_cd]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
	                if(rs != null )		rs.close();
            		if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rent_l_cd;
		}

	}
	
	public Vector getAcarAttachFile(String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query ="SELECT * FROM "+
				"ACAR_ATTACH_FILE " +
				"WHERE CONTENT_CODE ='INSUR'"+
				"AND SEQ ='"+seq+" '"+
				"";
		
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
					 ht.put(columnName, (rs.getString(columnName))==null?" ":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			//System.out.println("[InsDatabase:getInsComList]"+ e);
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
	
	//등록전 계약리스트 조회
	public Vector getRentList(String s_kd, String t_wd, String gubun3, String st_dt, String end_dt) {
       	getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		 query =  "  SELECT  v.rent_mng_id, v.rent_l_cd, v.car_mng_id, v.use_yn, a.CLS_ST, substr(b.firm_nm,0,15) firm_nm, "+
				  "  CASE WHEN v.car_st='5' THEN '1288147957' WHEN b.client_st='2' THEN SUBSTR(text_decrypt(b.ssn, 'pw'),0,6) ELSE b.enp_no END AS enp_no, "+  
		 		  "  c.car_no, REPLACE(d.INS_CON_NO,'-') INS_CON_NO, c.car_nm, c.car_num, v.rent_start_dt, v.rent_end_dt, a.cls_dt, c.init_reg_dt, "+  
			      "	 		 INS_START_DT, INS_EXP_DT, d.INS_ST, d.INS_STS, e.INS_COM_NM "+
			      "	 FROM  	insur d, cont v, car_reg c, cls_cont a, CLIENT b, INS_COM e  "+
			      "	 WHERE d.CAR_MNG_ID =  v.CAR_MNG_ID  AND d.CAR_MNG_ID =c.CAR_MNG_ID AND v.RENT_L_CD = a.RENT_L_CD(+) AND v.RENT_MNG_ID = a.RENT_MNG_ID(+) "+
			      "  AND v.CLIENT_ID =  b.CLIENT_ID "+
			      "  AND d.INS_COM_ID = e.INS_COM_ID "+
			      "  AND d.ins_con_no IS NOT NULL "+			    
			      "  AND v.RENT_L_CD NOT LIKE 'RM%' "+
		 		  "";
		 
		//기간
		if(gubun3.equals("당해"))			query += " and ( d.ins_exp_dt like to_char(sysdate,'YYYY')||'%' or d.ins_start_dt like to_char(sysdate,'YYYY')||'%' )";
		else if(gubun3.equals("전년"))	query += " and ( d.ins_exp_dt like to_char(add_months(sysdate,-12),'YYYY')||'%' or d.ins_start_dt like to_char(add_months(sysdate,-12),'YYYY')||'%' )";
		else if(gubun3.equals("기간")){
			if(!st_dt.equals("") && !end_dt.equals("")) {
				query += " and ((substr(d.ins_start_dt,1,4) >= replace('"+st_dt+"', '-','')  AND substr(d.ins_exp_dt,1,4) <=  replace('"+end_dt+"', '-',''))  \r\n" + 
						"	or  d.ins_start_dt like replace('"+end_dt+"', '-','')||'%' ) ";
			}
		}
		 
		 
		 
		if(s_kd.equals("1"))		query += " and b.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and v.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and CASE WHEN v.car_st='5' THEN '1288147957' WHEN b.client_st='2' THEN SUBSTR(text_decrypt(b.ssn, 'pw'),0,6) ELSE b.enp_no END like '%"+t_wd+"%'";
		

		if(s_kd.equals("1"))		query += " order by v.use_yn desc, INS_START_DT desc, firm_nm";		
		else if(s_kd.equals("2"))		query += " order by c.car_no, firm_nm, INS_START_DT desc";		
		else						query += " order by c.car_no, firm_nm, INS_START_DT desc";	
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
					 ht.put(columnName, (rs.getString(columnName))==null?" ":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			//System.out.println("[InsDatabase:getInsComList]"+ e);
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
	//등록전 계약리스트 조회
		public Hashtable getInusrInfo(String car_mng_id, String ins_st, String rent_l_cd) {
	       	getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "";
/*
			query = ""+
					"SELECT e.CAR_NO, e.CAR_NM, DECODE(a.car_st,'5','(주)아마존카/')||d.firm_nm AS firm_nm,\r\n" + 
					"		 CASE WHEN a.car_st='5' THEN '1288147957' WHEN d.client_st='2' THEN SUBSTR(text_decrypt(d.ssn, 'pw'),0,6) ELSE d.enp_no END AS enp_no,\r\n" + 
					"b.INS_CON_NO, b.CAR_MNG_ID, b.INS_ST, b.INS_STS, b.COM_EMP_YN, INS_START_DT, INS_EXP_DT, c.COM_EMP_START_DT, c.COM_EMP_EXP_DT \r\n" + 
					"FROM cont a, insur b, INS_COM_EMP_INFO c, client d, CAR_REG e\r\n" + 
					"WHERE a.CAR_MNG_ID = b.CAR_MNG_ID \r\n" + 
					"AND b.CAR_MNG_ID  = c.CAR_MNG_ID\r\n" + 
					"AND b.INS_ST = c.INS_ST\r\n" + 
					"AND c.CLIENT_ID = d.CLIENT_ID\r\n" + 
					"AND b.CAR_MNG_ID = e.CAR_MNG_ID "+
					"AND a.CAR_MNG_ID = '"+car_mng_id+"' "+
					"";*/
			
			 query =  "  SELECT  v.rent_mng_id, v.rent_l_cd, v.car_mng_id, v.use_yn, a.CLS_ST, substr(v.firm_nm,0,15) firm_nm, "+
			 		  "			 CASE WHEN v.car_st='5' THEN '1288147957' WHEN b.client_st='2' THEN SUBSTR(text_decrypt(b.ssn, 'pw'),0,6) ELSE b.enp_no END AS enp_no, "+  
			 		  "			 c.car_no, REPLACE(d.INS_CON_NO,'-') INS_CON_NO, c.car_nm, c.car_num, v.rent_start_dt, v.rent_end_dt, a.cls_dt, c.init_reg_dt, "+  
				      "	 		 INS_START_DT, INS_EXP_DT, d.INS_ST, d.INS_STS, e.INS_COM_NM  "+
				      "	 FROM  insur d, cont_n_view v, car_reg c, cls_cont a, CLIENT b, INS_COM e  "+
				      "	 WHERE d.CAR_MNG_ID =  v.CAR_MNG_ID  AND d.CAR_MNG_ID =c.CAR_MNG_ID AND v.RENT_L_CD = a.RENT_L_CD(+) AND v.RENT_MNG_ID = a.RENT_MNG_ID(+) "+
				      "  AND v.CLIENT_ID =  b.CLIENT_ID "+
			 		  "  AND d.ins_con_no IS NOT NULL "+
			 		  "  AND d.INS_COM_ID = e.INS_COM_ID "+
			 		//  "  AND d.ins_con_no like 'P%' "+
			 		//  "  AND d.ins_start_dt between v.RENT_START_DT and v.RENT_END_DT "+]
			 		//  "	AND ((d.ins_start_dt between v.RENT_START_DT and v.RENT_END_DT) OR (v.RENT_START_DT = '--' and v.USE_YN = 'Y' and v.RENT_END_DT ='--' ))"+ 
			 		  "	 AND d.car_mng_id ='"+car_mng_id+"' "+
			 		  "	 AND d.ins_st ='"+ins_st+"' "+
			 		  "	 AND v.rent_l_cd ='"+rent_l_cd+"' "+
			 		  "";

				try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				while(rs.next())
				{				
					for(int pos =1; pos <= rsmd.getColumnCount();pos++)
					{
						 String columnName = rsmd.getColumnName(pos);
						 ht.put(columnName, (rs.getString(columnName))==null?" ":rs.getString(columnName).trim());
					}
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				//System.out.println("[InsDatabase:getInsComList]"+ e);
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
		
		//보험 요청으로 바로등록
		public boolean insertInsExcelCom2(InsurExcelBean ins)
		{
			getConnection();
			boolean flag = true;
			String query = "insert into ins_excel_com (reg_code, seq, gubun,  "+
							" value01, value02, value03, value04, value05, value06, value07, value08, value09, value10, "+
							" value11, value12, value13, value14, value15, value16, value17, value18, value19, value20,  "+
							" value21, value22, value23, value24, value25, value26, value27, value28, value29, value30,  "+
							" value31, value32, value33, value36,"+
				            " reg_id, reg_dt, req_id, req_dt, "+
							" use_st, rent_mng_id, rent_l_cd, car_mng_id, ins_st, value42 , "+
							" value43, value44, value45, value46, value47, value48, value49, value50, value51 "+
							" ) values("+
							" ?, ?, ?, "+
							" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
							" ?, ?, ?, ?,"+
							" ?, sysdate,?, sysdate, "+
							" '요청', ?, ?, ?, ?, ?,  "+
							" ?, ?, ?, ?, ?, ?, ?, ?, ? "+
							" )";

			PreparedStatement pstmt = null;

			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,  ins.getReg_code());
				pstmt.setInt	(2,  ins.getSeq		());
			    pstmt.setString	(3,  ins.getGubun	());
			    
				pstmt.setString	(4,  ins.getValue01	());
				pstmt.setString	(5,  ins.getValue02	());
				pstmt.setString	(6,  ins.getValue03	());
				pstmt.setString	(7,  ins.getValue04	());
				pstmt.setString	(8,  ins.getValue05	());
				pstmt.setString	(9,  ins.getValue06	());
				pstmt.setString	(10, ins.getValue07	());
				pstmt.setString	(11, ins.getValue08	());
				pstmt.setString	(12, ins.getValue09	());
				pstmt.setString	(13, ins.getValue10	());
				
				pstmt.setString	(14, ins.getValue11	());
				pstmt.setString	(15, ins.getValue12	());
				pstmt.setString	(16, ins.getValue13	());
				pstmt.setString	(17, ins.getValue14	());
				pstmt.setString	(18, ins.getValue15	());
				pstmt.setString	(19, ins.getValue16	());
				pstmt.setString	(20, ins.getValue17	());
				pstmt.setString	(21, ins.getValue18	());
				pstmt.setString	(22, ins.getValue19	());
				pstmt.setString	(23, ins.getValue20	());
				
				pstmt.setString	(24, ins.getValue21	());
				pstmt.setString	(25, ins.getValue22	());
				pstmt.setString	(26, ins.getValue23	());
				pstmt.setString	(27, ins.getValue24	());
				pstmt.setString	(28, ins.getValue25	());
				pstmt.setString	(29, ins.getValue26	());
				pstmt.setString	(30, ins.getValue27	());
				pstmt.setString	(31, ins.getValue28	());
				pstmt.setString	(32, ins.getValue29	());
				pstmt.setString	(33, ins.getValue30	());
				
				pstmt.setString	(34, ins.getValue31	());
				pstmt.setString	(35, ins.getValue32	());
				pstmt.setString	(36, ins.getValue33	());
				pstmt.setString	(37, ins.getValue36	());
				
				pstmt.setString	(38, ins.getReg_id	());			
				pstmt.setString	(39, ins.getReq_id	());			
				pstmt.setString	(40, ins.getRent_mng_id());			
				pstmt.setString	(41, ins.getRent_l_cd());			
				pstmt.setString	(42, ins.getCar_mng_id());			
				pstmt.setString	(43, ins.getIns_st	());			
				pstmt.setString	(44, ins.getValue21	());			
			                     
				pstmt.setString	(45, ins.getValue43	());			
				pstmt.setString	(46, ins.getValue44	());			
				pstmt.setString	(47, ins.getValue45	());			
				pstmt.setString	(48, ins.getValue46	());			
				pstmt.setString	(49, ins.getValue47	());			
				pstmt.setString	(50, ins.getValue48	());			
				pstmt.setString	(51, ins.getValue49	());			
				pstmt.setString	(52, ins.getValue50	());			
				pstmt.setString	(53, ins.getValue51	());			

				pstmt.executeUpdate();
				pstmt.close();

				conn.commit();
			    
		  	} catch (Exception e) {
				//System.out.println("[InsComDatabase:insertInsExcelCom]"+ e);
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
		
		//가입증명요청 중복입력 체크
		public int getCheckOverInsExcelCom3(String ins_con_no, String ins_start_dt,String ins_exp_dt, String firm_nm )
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";

			query = " select count(0) cnt from ins_excel_com "+
					" where gubun='증명' "+
					" and use_st in ('완료','요청')"+
					" and value01='"+ins_con_no+"' "+
					" and value04='"+ins_start_dt+"' "+
					" and value05='"+ins_exp_dt+"' "+
					" and value06='"+firm_nm+"' "+
					" ";
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:getCheckOverInsExcelCom]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null)		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}
		//가입증명요청 중복입력 체크
		public int getCheckOverInsExcelCom4(String ins_con_no, String ins_start_dt)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";

			query =	"SELECT count(*) cnt FROM (\r\n" + 
					"  SELECT /*+ rule */ a.* FROM ( \r\n" + 
					" 	SELECT a.SEQ, a.CONTENT_SEQ, a.FILE_TYPE, a.reg_date, TO_CHAR(a.REG_DATE,'YYYYMMDD') reg_dt2, a.FILE_NAME,  nvl(b.INS_COM_ID, g.value14) ins_com_id, decode(h.sort,0,'',h.sort) sort, \r\n" + 
					"			nvl(b.INS_CON_NO,g.value15) ins_con_no, b.INS_START_DT, DECODE(d.CAR_MNG_ID, '',b.INS_EXP_DT, d.exp_dt) ins_exp_dt, nvl(c.CAR_NO, g.value04) car_no , nvl(c.CAR_NM,g.value03) CAR_NM, e.ins_com_nm, f.user_nm as reg_nm \r\n" + 
					" 	FROM   (SELECT * FROM ACAR_ATTACH_FILE WHERE seq in (SELECT max(TO_NUMBER(SEQ)) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE ='INSUR' AND ISDELETED='N' GROUP BY CONTENT_SEQ)) a, insur b, car_reg c, ins_cls d, ins_com e, users f, \r\n" + 
					" 	(SELECT * FROM ins_excel_com WHERE gubun='가입' AND use_st <> '취소') g, file_sort h \r\n" + 
					" 	WHERE  a.content_code='INSUR' AND a.isdeleted='N' \r\n" + 
					"  		AND a.CONTENT_SEQ NOT like '%#_%' ESCAPE '#' \r\n" + 
					"  		AND a.content_seq = b.ins_con_no(+) 	\r\n" + 
					"  		AND b.car_mng_id=c.car_mng_id(+)	\r\n" + 
					"  		AND b.car_mng_id=d.car_mng_id(+) 	\r\n" + 
					"  		AND b.ins_st=d.ins_st(+) 	\r\n" + 
					"  		AND b.ins_com_id=e.ins_com_id(+) 	\r\n" + 
					"  		AND a.reg_userseq=f.user_id(+)	\r\n" + 
					"  		AND a.content_seq = g.VALUE15(+) 	\r\n" + 
					"  		AND a.seq = h.SEQ(+)\r\n" + 
					" 	UNION ALL \r\n" + 
					" 	SELECT a.SEQ, a.CONTENT_SEQ, a.FILE_TYPE, a.reg_date, TO_CHAR(a.REG_DATE,'YYYYMMDD') reg_dt2, a.FILE_NAME,b.INS_COM_ID,  decode(h.sort,0,'',h.sort) sort, \r\n" + 
					"			b.INS_CON_NO, b.INS_START_DT, DECODE(d.CAR_MNG_ID, '',b.INS_EXP_DT, d.exp_dt) ins_exp_dt, c.CAR_NO, c.CAR_NM, e.ins_com_nm, f.user_nm as reg_nm \r\n" + 
					" 	FROM   (SELECT * FROM ACAR_ATTACH_FILE WHERE seq in (SELECT max(TO_NUMBER(SEQ)) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE ='INSUR' AND ISDELETED='N' GROUP BY CONTENT_SEQ)) a, insur b, car_reg c, ins_cls d,  ins_com e, users f,\r\n" + 
					"			file_sort h  			\r\n" + 
					" 	WHERE  a.content_code='INSUR' AND a.isdeleted='N'  \r\n" + 
					" 		AND b.ins_con_no IS NOT NULL \r\n" + 
					" 		AND b.car_mng_id=c.car_mng_id(+) \r\n" + 
					"  		AND b.car_mng_id=d.car_mng_id(+) 	\r\n" + 
					"  		AND b.ins_st=d.ins_st(+) 	\r\n" + 
					"  		AND b.ins_com_id=e.ins_com_id(+) \r\n" + 
					"	 	AND a.reg_userseq=f.user_id(+) \r\n" + 
					"	 	AND b.INS_CON_NO||'_'||b.INS_START_DT ||'_'||b.INS_EXP_DT = a.CONTENT_SEQ(+)\r\n" + 
					"	 	AND a.seq = h.seq (+)\r\n" + 
					"	)a WHERE 1=1  \r\n" + 
					"		AND ins_con_no= '"+ins_con_no+"'\r\n" + 
					"		AND ins_start_dt = '"+ins_start_dt+"'\r\n" + 
					"	)\r\n" + 
					"	";
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:getCheckOverInsExcelCom]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null)		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}
		
		
		
		//배서현황 피보험자건 양식리스트
		public Vector getinsConfCngList(String rent_l_cd, String rent_mng_id, String car_mng_id, String ins_st, String reg_code,  String seq ) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String what = "";


			query =" "+
					"  SELECT 	a.RENT_L_CD,a.RENT_MNG_ID, a.CAR_MNG_ID , c.car_no, c.CAR_NM, e.CAR_NAME, b.CON_F_NM, \r\n" + 
					"  			h.INS_COM_NM, nvl(b.FIRM_EMP_NM, b.CON_F_NM)  BEF_FIRM,  \r\n" + 
					"  			CASE WHEN LENGTH(b.ENP_NO)> 6 THEN substr(replace(b.ENP_NO,'-',''), 1, 3)||'-'||substr(replace(b.ENP_NO,'-',''), 4, 2)||'-'||substr(replace(b.ENP_NO,'-',''), 6, 5)\r\n" + 
					"  				ELSE  b.ENP_NO END AS BEF_SSN,\r\n" + 
					"  			decode(f.client_st,1, substr(f.ENP_NO, 1, 3)||'-'||substr(f.ENP_NO, 4, 2)||'-'||substr(f.ENP_NO, 6, 5), \r\n" + 
					"  			substr( TEXT_DECRYPT(f.ssn, 'pw' ), 1, 6)) AFT_SSN,\r\n" + 
					"  			 g.VALUE36 AFT_FIRM "+	
					"  FROM  cont a, insur b, car_reg c, car_etc d,  car_nm e, client f, INS_EXCEL_COM g, INS_COM h\r\n" + 
					"  WHERE a.RENT_L_CD='"+rent_l_cd+"' AND a.RENT_MNG_ID='"+rent_mng_id+"' \r\n" + 
					"  AND b.CAR_MNG_ID='"+car_mng_id+"' AND b.INS_ST='"+ins_st+"'\r\n" + 
					"  AND g.REG_CODE='"+reg_code+"' AND g.SEQ='"+seq+"'\r\n" + 
					"  AND f.CLIENT_NM <> 'test'\r\n" + 
					"  AND a.CAR_MNG_ID = b.CAR_MNG_ID  \r\n" + 
					"  AND a.CAR_MNG_ID = c.CAR_MNG_ID\r\n" + 
					"  AND a.RENT_MNG_ID = d.RENT_MNG_ID\r\n" + 
					"  AND a.RENT_L_CD = d.RENT_L_CD\r\n" + 
					"  AND d.CAR_ID =e.CAR_ID\r\n" + 
					"  AND d.CAR_SEQ = e.CAR_SEQ\r\n" + 
					"  AND a.CLIENT_ID = f.CLIENT_ID\r\n" + 
					"  AND b.CAR_MNG_ID = g.CAR_MNG_ID\r\n" + 
					"  AND b.INS_ST = g.INS_ST\r\n" + 
					"  AND g.VALUE14 = h.INS_COM_ID\r\n" + 
					"  "+
					"";
			
			//보험사
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
				//System.out.println("[InsComDatabase:getInsComNewList]\n"+e);
				//System.out.println("[InsComDatabase:getInsComNewList]\n"+query);
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
		
		//배서현황 피보험자건 추가
		public boolean updateInsExcelComConfCng(String reg_code, String seq)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			String query = "";
			
			query =	" UPDATE INS_EXCEL_COM SET "+
					" value38 ='피보험자변경건' "+ 
					" WHERE REG_CODE = '"+reg_code+"' "+
					" AND SEQ ='"+seq+"' "+
					" AND GUBUN = '배서'"+
					" ";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				flag = true;
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				flag = false;
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
		}
		
		//해지현황 피보험자건 양식리스트
		public Vector getinsConfClsList(String car_mng_id, String ins_st, String reg_code,  String seq ) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String what = "";


			query =" "+
					" SELECT a.VALUE01 car_no, VALUE03 car_name, b.FIRM_EMP_NM BEF_FIRM, b.ENP_NO BEF_SSN \r\n" + 
					"FROM INS_EXCEL_COM a, insur b , INS_COM c\r\n" + 
					"WHERE GUBUN ='해지' \r\n" + 
					"AND b.CAR_MNG_ID='"+car_mng_id+"' AND b.INS_ST='"+ins_st+"'\r\n" + 
					"AND a.REG_CODE='"+reg_code+"' AND a.SEQ='"+seq+"'\r\n" + 
					"AND a.CAR_MNG_ID = b.CAR_MNG_ID \r\n" + 
					"AND a.INS_ST = b.INS_ST\r\n" + 
					"AND b.INS_COM_ID = c.INS_COM_ID "+
					"";
			
			//보험사
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
				//System.out.println("[InsComDatabase:getInsComNewList]\n"+e);
				//System.out.println("[InsComDatabase:getInsComNewList]\n"+query);
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
		
		//해지현황 피보험자건 추가
		public boolean updateInsExcelComConfCng2(String reg_code, String seq)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			String query = "";
			
			query =	" UPDATE INS_EXCEL_COM SET "+
					" value10 ='피보험자변경건' "+ 
					" WHERE REG_CODE = '"+reg_code+"' "+
					" AND SEQ ='"+seq+"' "+
					" AND GUBUN = '해지'"+
					" ";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				flag = true;
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				flag = false;
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
		}
		
		//피보험자 등록 확인
		public int getCheckConfCnt(String car_mng_id)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";

			query = ""+
					"  SELECT count(*) cnt\r\n" + 
					"	FROM INS_EXCEL_COM \r\n" + 
					"	WHERE gubun IN ('배서','해지')  \r\n" + 
					"	AND use_st NOT IN ('완료','취소') AND DECODE(GUBUN,'배서',VALUE38, '해지', VALUE10) ='피보험자변경건' \r\n" + 
					"	AND CAR_MNG_ID='"+car_mng_id+"' "+
					" ";
			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:getCheckOverInsExcelCom]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null)		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}
	
		//보험가입 순서 업로드
		public boolean updateInsExcelComSort(int seq, int sort)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			String query = "";
		
			
			query = " 	MERGE INTO FILE_SORT USING DUAL\r\n" + 
					"        ON (seq ="+seq+" )\r\n" + 
					"	WHEN MATCHED THEN\r\n" + 
					"        UPDATE SET SORT = "+sort+"\r\n" + 
					"    WHEN NOT MATCHED THEN\r\n" + 
					"        INSERT (\r\n" + 
					"            seq, sort\r\n" + 
					"        )\r\n" + 
					"        VALUES (\r\n" + 
					"          "+seq+","+sort+"\r\n" + 
					"		)";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				flag = true;
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				flag = false;
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
		}
				
		
		//차량번호로 가입증명서 등록 파일 seq 찾기 
		public int getFileSeq(String car_no)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";

			query = ""+
					"	SELECT  /*+ rule */ a.seq \r\n" + 
					" 	FROM   (SELECT * FROM ACAR_ATTACH_FILE WHERE seq in (SELECT max(TO_NUMBER(SEQ)) FROM ACAR_ATTACH_FILE WHERE CONTENT_CODE ='INSUR' AND ISDELETED='N' GROUP BY CONTENT_SEQ)) a, \r\n" + 
					" 	(SELECT * FROM ins_excel_com WHERE gubun='가입' AND use_st <> '취소') g\r\n" + 
					" 	WHERE  a.content_code='INSUR' AND a.isdeleted='N' \r\n" + 
					"  		AND a.CONTENT_SEQ NOT like '%#_%' ESCAPE '#' \r\n" + 
					"  		AND a.content_seq = g.VALUE15(+) 	\r\n" + 
					"  		AND g.value04 ='"+car_no+"'"+
					" ";
			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:getCheckOverInsExcelCom]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null)		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}
		
		//보험손해율/사고율현황
		public Vector getinsRatioList(String gubun1, String st_dt, String end_dt) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String what = "";

			query = " select * FROM ( \r\n";

					
			query +=" SELECT grouping_id(SUBSTR(save_dt,1,4)) id2, SUBSTR(save_dt,1,4) year, "+
			        "        CASE grouping_id(SUBSTR(save_dt,1,4), save_dt) when 1 THEN '소계' when 3 THEN '총합계' ELSE save_dt END save_dt,\r\n" + 
					"        sum(amt1) amt1, sum(amt2) amt2, \r\n" + 
					"        CASE grouping_id(SUBSTR(save_dt,1,4), save_dt) when 1 THEN ROUND(sum(amt2)/sum(amt1)*100,1) when ROUND(sum(amt2)/sum(amt1)*100,1) THEN 0 ELSE avg(ratio1) END ratio1, \r\n" + 
					"        sum(round(cnt1)) cnt1, sum(cnt2) cnt2, \r\n" + 
					"        CASE grouping_id(SUBSTR(save_dt,1,4), save_dt) when 1 THEN ROUND(sum(cnt2)/sum(cnt1)*100,1) when ROUND(sum(cnt2)/sum(cnt1)*100,1) THEN 0 ELSE avg(ratio2) END ratio2, \r\n" + 
					"        sum(amt3) amt3, sum(amt4) amt4, \r\n" + 
					"        CASE grouping_id(SUBSTR(save_dt,1,4), save_dt) when 1 THEN ROUND(NVL(sum(amt4)/ DECODE(sum(amt3)* 100, 0 , NULL ,sum(amt3)* 100),0),1) when (CASE WHEN MAX(AMT3) = MAX(0) THEN MAX(0) ELSE ROUND(sum(amt4)/sum(amt3)*100,1) END) THEN 0 ELSE avg(ratio3) END ratio3 \r\n" +					
					"FROM    ins_stat_ratio\r\n" + 
					"WHERE 1=1 ";
			
			if(!gubun1.equals("")) {
				query += " and ins_com_id='"+gubun1+"' \r\n";	
			}
			
			if(!st_dt.equals("")) {
				query += " and save_dt between '"+st_dt+"' and '"+end_dt+"' \r\n";	
			}			
			 
			query += "GROUP BY ROLLUP (SUBSTR(save_dt,1,4), save_dt) \r\n" + 
					"";
			
			query += ")\r\n" + 
					"ORDER BY id2, year desc, save_dt";
			
			//보험사
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
				System.out.println("[InsComDatabase:getInsComNewList]\n"+e);
				System.out.println("[InsComDatabase:getInsComNewList]\n"+query);
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
		
		/**
		 * 보험손해/사고율현황 조회
		 */
		public Hashtable getInsRatioSelect(String save_dt)
		{
			getConnection();
			Hashtable ht = new Hashtable();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			query = " SELECT * FROM ins_stat_ratio WHERE SAVE_DT ='"+save_dt+"'"+
			 		"";	
		
			
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
				//System.out.println("[InsComDatabase:getInsRatioSelect]\n"+e);
				//System.out.println("[InsComDatabase:getInsRatioSelect]\n"+query);
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
		
		//car_mng_id, ins_st로 삭제
		public boolean updateInsRatio(String gubun, String value01, String value02, long value03, long value04, float value05, float value06 )
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			String query = "";
			
			query = " update ins_stat_ratio set "+
					" AMT1 = ?,"+
					" AMT2 = ?,"+
					" CNT1 = ?,"+
					" CNT2 = ?,"+
					" ratio1 =  round(?/?*100,1),"+
					" ratio2 = round(?/?*100,1)"+
					" where save_dt= ? "+
					" ";  
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.setLong	(1,  value03);
				pstmt.setLong	(2,  value04);
				pstmt.setFloat	(3,  value05);
				pstmt.setFloat	(4,  value06);
				
				pstmt.setFloat	(5,  value04);
				pstmt.setFloat	(6,  value03);

				pstmt.setFloat	(7,  value06);
				pstmt.setFloat	(8,  value05);
				
				pstmt.setString	(9,  value02);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				flag = true;
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:getCheckOverInsExcelCom(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				flag = false;
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
		}
		
		//car_mng_id, ins_st로 삭제
		public boolean updateInsRatio(String gubun, String value01, String value02, long value03, long value04, float value05, float value06, long value07, long value08, String save_dt, String modify_dt )
				{
					getConnection();
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					boolean flag = false;
					String query = "";
					
					query = " update ins_stat_ratio set "+
							" AMT1 = ?,"+
							" AMT2 = ?,"+
							" CNT1 = ?,"+
							" CNT2 = ?,"+
							" ratio1 =  round(?/?*100,1),"+
							" ratio2 = round(?/?*100,1),"+
							" AMT3 = ?,"+
							" AMT4 = ?,"+
							" save_dt = ?,"+
							" ratio3 = (case when "+value07+" = 0 or "+value08+" = 0 then 0 else round(?/?*100,1) end)"+							
							" where save_dt= ? "+
							" ";  
					
					try {
						conn.setAutoCommit(false);
						pstmt = conn.prepareStatement(query);

						pstmt.setLong	(1,  value03);
						pstmt.setLong	(2,  value04);
						
						pstmt.setFloat	(3,  value05);
						pstmt.setFloat	(4,  value06);
						pstmt.setFloat	(5,  value04);
						pstmt.setFloat	(6,  value03);
						pstmt.setFloat	(7,  value06);
					
						pstmt.setFloat	(8,  value05);
						pstmt.setLong	(9,  value07);
					
						pstmt.setLong	(10, value08);
						pstmt.setString	(11, modify_dt);
						pstmt.setFloat	(12, value08);
						pstmt.setFloat	(13, value07);
						
						pstmt.setString	(14, save_dt);
						pstmt.executeUpdate();
						pstmt.close();
						
						conn.commit();
						flag = true;
						
					} catch (SQLException e) {
						//System.out.println("[InsComDatabase:getCheckOverInsExcelCom(String car_mng_id, String ins_st)]"+ e);
						e.printStackTrace();
						flag = false;
						conn.rollback();
					} finally {
						try{
							if(rs != null)		rs.close();
							if(pstmt != null)	pstmt.close();
						}catch(Exception ignore){}
						closeConnection();
						return flag;
					}
		}
		
		
		/**
		 * 보험손해/사고율현황 등록
		 */
		public boolean insertInsRatio(String gubun, String value01, String value02, long value03, long value04, float value05, float value06 )
		{
			getConnection();
			boolean flag = true;
			String query = "insert into ins_stat_ratio (gubun, ins_com_id, save_dt, "+
							" amt1, amt2, cnt1, cnt2, ratio1, ratio2  "+
							" ) values("+
							" ?, ?, ?, "+
							" ?, ?, ?, ?, round(?/?*100,1), round(?/?*100,1) "+
							" )";

			PreparedStatement pstmt = null; 

			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				
				pstmt.setString	(1,  gubun);
				pstmt.setString	(2,  value01);
			    pstmt.setString	(3,  value02);			    
				pstmt.setLong	(4,  value03);
				pstmt.setLong	(5,  value04);
				pstmt.setFloat	(6,  value05);
				pstmt.setFloat	(7,  value06);
				
				pstmt.setLong	(8,  value04);
				pstmt.setLong	(9,  value03);
				
				pstmt.setFloat	(10, value06);
				pstmt.setFloat	(11, value05);
				
				pstmt.executeUpdate();
				pstmt.close();

				conn.commit();
			    
		  	} catch (Exception e) {
				System.out.println("[InsComDatabase:insertInsRatio]"+ e);
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
		
		/**
		 * 보험손해/사고율현황 등록
		 */
		public boolean insertInsRatio(String gubun, String value01, String value02, long value03, long value04, float value05, float value06, long value07, long value08 )
		{
			getConnection();
			boolean flag = true;
			String query = "insert into ins_stat_ratio (gubun, ins_com_id, save_dt, "+
							" amt1, amt2, cnt1, cnt2, ratio1, ratio2, amt3, amt4, ratio3  "+
							" ) values("+
							" ?, ?, ?, "+
							" ?, ?, ?, ?, round(?/?*100,1), round(?/?*100,1), "+
							" ?, ?, (case when "+value07+" = 0 or "+value08+" = 0 then 0 else round(?/?*100,1) end)"+
							" )";

			PreparedStatement pstmt = null; 

			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				
				pstmt.setString	(1,  gubun);
				pstmt.setString	(2,  value01);
			    pstmt.setString	(3,  value02);			    
				pstmt.setLong	(4,  value03);
				pstmt.setLong	(5,  value04);
				pstmt.setFloat	(6,  value05);
				pstmt.setFloat	(7,  value06);
				
				pstmt.setLong	(8,  value04);
				pstmt.setLong	(9,  value03);
				
				pstmt.setFloat	(10, value06);
				pstmt.setFloat	(11, value05);
				
				pstmt.setLong	(12, value07);
				pstmt.setLong	(13, value08);
				pstmt.setLong	(14, value08);
				pstmt.setLong	(15, value07);
				
				pstmt.executeUpdate();
				pstmt.close();

				conn.commit();
			    
		  	} catch (Exception e) {
				System.out.println("[InsComDatabase:insertInsRatio]"+ e);
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
		
		public int getCheckOverInsExcel(String car_mng_id,  String ins_st, String ins_value, String car_value)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";

			query = " SELECT count(0) cnt FROM INS_EXCEL " +
					" WHERE value11 = '" + car_mng_id + "' " +
					" AND value12 = '" + ins_st + "' " +
					// " AND value07='"+ins_value+"' "+
					" AND value08 = '" + car_value + "' " +
					" AND gubun is null " +
					" ";
			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if( rs.next() ){				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch ( SQLException e ) {
		  		e.printStackTrace();
			} finally {
				try{
	                if( rs != null )		rs.close();
	                if( pstmt != null ) 	pstmt.close();
				}catch( Exception ignore ){}
				closeConnection();
				return count;
			}
		}
		
		
		public int getCheckOverInsExcelCom(String car_mng_id,  String ins_st, String ins_value, String car_value)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";

			query = " SELECT count(0) cnt FROM INS_EXCEL_COM " +
					" WHERE gubun = '배서' " +
					" AND use_st NOT IN ('취소', '완료')" +
					" AND car_mng_id = '" + car_mng_id + "' " +
					" AND ins_st = '" + ins_st + "' " +
					" AND value08 = '블랙박스' " +
					" AND value09 = '" + ins_value + "' " +
					" AND value10 = '" + car_value + "' " +
					" ";
			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if( rs.next() ){				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch( SQLException e ){
		  		e.printStackTrace();
			} finally {
				try{
	                if( rs != null )		rs.close();
	                if( pstmt != null )	pstmt.close();
				}catch( Exception ignore ){}
				closeConnection();
				return count;
			}
		}
		
		
		//보험견적비교(차명기준)
		public Vector getEstCprListByCarNm(String car_nm, String air_as_yn, String air_ds_yn, String age_scp, String vins_pcp_kd, String vins_gcp_kd, String vins_bacdt_kd, String com_emp_yn) {
	       	getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			 query = "SELECT  d.INS_ST, d.INS_STS, e.INS_COM_NM, (c.CAR_NM||' '||cn.CAR_NAME) car_name, d.ins_rent_dt, \r\n" + 
			 		"			(nvl(d.rins_pcp_amt,0)+nvl(d.vins_pcp_amt,0)+nvl(d.vins_gcp_amt,0)+nvl(d.vins_bacdt_amt,0)+nvl(d.vins_canoisr_amt,0)+nvl(d.vins_share_extra_amt,0)+ \r\n" + 
			 		"			nvl(d.vins_cacdt_cm_amt,0)+ nvl(d.vins_spe_amt,0)) tot_amt,\r\n" + 
			 		"    		d.rins_pcp_amt, d.vins_pcp_amt, d.vins_gcp_amt, d.vins_bacdt_amt, d.vins_canoisr_amt, d.vins_share_extra_amt, d.vins_cacdt_cm_amt, d.vins_spe_amt,\r\n" + 
			 		"    		v.rent_mng_id, v.rent_l_cd, v.car_mng_id, v.use_yn, a.CLS_ST, substr(b.firm_nm,0,15) firm_nm, \r\n" + 
			 		"  			CASE WHEN v.car_st='5' THEN '1288147957' WHEN b.client_st='2' THEN SUBSTR(text_decrypt(b.ssn, 'pw'),0,6) ELSE b.enp_no END AS enp_no, \r\n" + 
			 		"  			c.car_no, REPLACE(d.INS_CON_NO,'-') INS_CON_NO, c.car_nm, c.car_num, v.rent_start_dt, v.rent_end_dt, a.cls_dt, c.init_reg_dt, \r\n" + 
			 		"	 		INS_START_DT, INS_EXP_DT\r\n" + 
			 		"	FROM  	insur d, cont v, car_reg c, cls_cont a, CLIENT b, INS_COM e, car_etc g, car_nm cn \r\n" + 
			 		"	WHERE 	d.CAR_MNG_ID =  v.CAR_MNG_ID  AND d.CAR_MNG_ID =c.CAR_MNG_ID AND v.RENT_L_CD = a.RENT_L_CD(+) AND v.RENT_MNG_ID = a.RENT_MNG_ID(+) \r\n" + 
			 		"  AND v.CLIENT_ID =  b.CLIENT_ID \r\n" + 
			 		"  AND d.INS_COM_ID = e.INS_COM_ID \r\n" + 
			 		"  and v.rent_mng_id = g.rent_mng_id(+)  \r\n" + 
			 		"  and v.rent_l_cd = g.rent_l_cd(+)  \r\n" + 
			 		"  AND g.car_id=cn.car_id(+)  \r\n" + 
			 		"  AND g.car_seq=cn.car_seq(+) \r\n" + 
			 		"  AND d.ins_con_no IS NOT NULL \r\n" + 
			 		"  AND v.RENT_L_CD NOT LIKE 'RM%' \r\n" + 
			 		"  AND d.INS_START_DT LIKE '%0210'\r\n" + 
			 		"  AND d.AIR_AS_YN  ='"+air_as_yn+"'\r\n" + 
			 		"  AND d.AIR_DS_YN = '"+air_ds_yn+"'\r\n" + 
			 		"  AND AGE_SCP = '"+age_scp+"'\r\n" + 
			 		"  --AND VINS_PCP_KD = '"+vins_pcp_kd+"'\r\n" + 
			 		"  AND VINS_GCP_KD= '"+vins_gcp_kd+"' \r\n" + 
			 		"  --AND VINS_BACDT_KD = '"+vins_bacdt_kd+"' \r\n" + 
			 		"  AND COM_EMP_YN='"+com_emp_yn+"' \r\n" + 
			 		"  AND (c.CAR_NM||' '||cn.CAR_NAME) = '"+car_nm+"' \r\n" + 
			 		"--  AND BLACKBOX_YN='Y'\r\n" + 
			 		"  ORDER by d.REG_DT DESC ";
			 
		
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
						 ht.put(columnName, (rs.getString(columnName))==null?" ":rs.getString(columnName).trim());
					}
					vt.add(ht);	
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				//System.out.println("[InsDatabase:getInsComList]"+ e);
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
		
		//보험견적비교(자종기준)
				public Vector getEstCprListByJgcode(String jg_code, String air_as_yn, String air_ds_yn, String age_scp, String vins_pcp_kd, String vins_gcp_kd, String vins_bacdt_kd, String com_emp_yn) {
			       	getConnection();
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					Vector vt = new Vector();
					String query = "";

					 query = "SELECT  d.INS_ST, d.INS_STS, e.INS_COM_NM, (c.CAR_NM||' '||cn.CAR_NAME) car_name, d.ins_rent_dt, \r\n" + 
					 		"			(nvl(d.rins_pcp_amt,0)+nvl(d.vins_pcp_amt,0)+nvl(d.vins_gcp_amt,0)+nvl(d.vins_bacdt_amt,0)+nvl(d.vins_canoisr_amt,0)+nvl(d.vins_share_extra_amt,0)+ \r\n" + 
					 		"			nvl(d.vins_cacdt_cm_amt,0)+ nvl(d.vins_spe_amt,0)) tot_amt,\r\n" + 
					 		"    		d.rins_pcp_amt, d.vins_pcp_amt, d.vins_gcp_amt, d.vins_bacdt_amt, d.vins_canoisr_amt, d.vins_share_extra_amt, d.vins_cacdt_cm_amt, d.vins_spe_amt,\r\n" + 
					 		"    		v.rent_mng_id, v.rent_l_cd, v.car_mng_id, v.use_yn, a.CLS_ST, substr(b.firm_nm,0,15) firm_nm, \r\n" + 
					 		"  			CASE WHEN v.car_st='5' THEN '1288147957' WHEN b.client_st='2' THEN SUBSTR(text_decrypt(b.ssn, 'pw'),0,6) ELSE b.enp_no END AS enp_no, \r\n" + 
					 		"  			c.car_no, REPLACE(d.INS_CON_NO,'-') INS_CON_NO, c.car_nm, c.car_num, v.rent_start_dt, v.rent_end_dt, a.cls_dt, c.init_reg_dt, \r\n" + 
					 		"	 		INS_START_DT, INS_EXP_DT\r\n" + 
					 		"	FROM  	insur d, cont v, car_reg c, cls_cont a, CLIENT b, INS_COM e, car_etc g, car_nm cn \r\n" + 
					 		"	WHERE 	d.CAR_MNG_ID =  v.CAR_MNG_ID  AND d.CAR_MNG_ID =c.CAR_MNG_ID AND v.RENT_L_CD = a.RENT_L_CD(+) AND v.RENT_MNG_ID = a.RENT_MNG_ID(+) \r\n" + 
					 		"  AND v.CLIENT_ID =  b.CLIENT_ID \r\n" + 
					 		"  AND d.INS_COM_ID = e.INS_COM_ID \r\n" + 
					 		"  and v.rent_mng_id = g.rent_mng_id(+)  \r\n" + 
					 		"  and v.rent_l_cd = g.rent_l_cd(+)  \r\n" + 
					 		"  AND g.car_id=cn.car_id(+)  \r\n" + 
					 		"  AND g.car_seq=cn.car_seq(+) \r\n" + 
					 		"  AND d.ins_con_no IS NOT NULL \r\n" + 
					 		"  AND v.RENT_L_CD NOT LIKE 'RM%' \r\n" + 
					 		"  AND d.INS_START_DT LIKE '%0210'\r\n" + 
					 		"  AND d.AIR_AS_YN  ='"+air_as_yn+"'\r\n" + 
					 		"  AND d.AIR_DS_YN = '"+air_ds_yn+"'\r\n" + 
					 		"  AND AGE_SCP = '"+age_scp+"'\r\n" + 
					 		"  --AND VINS_PCP_KD = '"+vins_pcp_kd+"'\r\n" + 
					 		"  AND VINS_GCP_KD= '"+vins_gcp_kd+"' \r\n" + 
					 		"  --AND VINS_BACDT_KD = '"+vins_bacdt_kd+"' \r\n" + 
					 		"  AND COM_EMP_YN='"+com_emp_yn+"' \r\n" + 
					 		"  AND cn.jg_code = '"+jg_code+"' \r\n" + 
					 		"--  AND BLACKBOX_YN='Y'\r\n" + 
					 		"  ORDER by d.REG_DT DESC ";
					 
				
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
								 ht.put(columnName, (rs.getString(columnName))==null?" ":rs.getString(columnName).trim());
							}
							vt.add(ht);	
						}
						rs.close();
						pstmt.close();
					} catch (SQLException e) {
						//System.out.println("[InsDatabase:getInsComList]"+ e);
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
	
		//가입증명서 파일 논리적 삭제
		public boolean deleteInsComFile(String seq)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			String query = "";
			
			query = " update acar_attach_file set ISDELETED='Y'"+
					" where seq='"+seq+"' "+
					" ";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				flag = true;
				
			} catch (SQLException e) {
				e.printStackTrace();
				flag = false;
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}
		}
		
//		// 보험 가입현황 업데이트
//		public void updateInsur(Map<String, Object> param) throws DatabaseException, DataSourceEmptyException{
//		{
//			getConnection();
//			PreparedStatement pstmt = null;
//			ResultSet rs = null;
//			boolean flag = false;
//			String query = "";
//			
//			String insur_code = (String) param.get("insur_code");
//			String value15 = (String) param.get("value15");
//			int value17 = (int) param.get("value17");
//			int value18 = (int) param.get("value18");
//			int value19 = (int) param.get("value19");
//			int value20 = (int) param.get("value20");
//			int value21 = (int) param.get("value21");
//			String reg_code = (String) param.get("reg_code");
//			int seq = (int) param.get("seq");
//			
//			
//			query = "";
//			
//			try {
//				conn.setAutoCommit(false);
//				pstmt = conn.prepareStatement(query);
//				pstmt.executeUpdate();
//				pstmt.close();
//				
//				conn.commit();
//				flag = true;
//				
//			} catch (SQLException e) {
//				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
//				e.printStackTrace();
//				flag = false;
//				conn.rollback();
//			} finally {
//				try{
//					if(rs != null)		rs.close();
//					if(pstmt != null)	pstmt.close();
//				}catch(Exception ignore){}
//				closeConnection();
//				return flag;
//			}
//		}
		
		public void updateInsur(Map<String, Object> param) throws DatabaseException, DataSourceEmptyException, SQLException{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			String query = "";
			
			String insur_code = (String) param.get("insur_code");
			String value15 = (String) param.get("value15");
			int value17 = Integer.parseInt(String.valueOf(param.get("value17")));
			int value18 = Integer.parseInt(String.valueOf(param.get("value18")));
			int value19 = Integer.parseInt(String.valueOf(param.get("value19")));
			int value20 = Integer.parseInt(String.valueOf(param.get("value20")));
			int value21 = Integer.parseInt(String.valueOf(param.get("value21")));
			String reg_code = (String) param.get("reg_code");
			String value26 = (String) param.get("value26");
			int seq = Integer.parseInt(String.valueOf(param.get("seq")));
			int value25 = value17 + value18 + value19 + value20 + value21;
			
			
			query = "update INS_EXCEL_COM " +
					"set INSUR_CODE = '"+insur_code+"', VALUE15 = '"+value15+"', VALUE17 = '"+value17+"', VALUE18 = '"+value18+"'," +
					"VALUE19 = '"+value19+"', VALUE20 = '"+value20+"', VALUE21 = '"+value21+"'," +
					" VALUE25 = '"+value25+"', save_yn = 'Y'" +
					"where USE_ST='요청' and REG_CODE = '"+reg_code+"' and SEQ = '"+seq+"'";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				flag = true;
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				flag = false;
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
			}
	    }
		
		public void updateInsurCls(Map<String, Object> param) throws DatabaseException, DataSourceEmptyException, SQLException{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			String query = "";
			
			String etc = (String) param.get("etc");
			String value07 = (String) param.get("value07");
			int value08 = Integer.parseInt(String.valueOf(param.get("value08")));
			String reg_code = (String) param.get("reg_code");
			int seq = Integer.parseInt(String.valueOf(param.get("seq")));
			
			
			query = "update INS_EXCEL_COM " +
					"set  VALUE07 = '"+value07+"', VALUE08 = '"+value08+"', ETC = '"+etc+"'," +
					"save_yn = 'Y'" +
					"where USE_ST='요청' and REG_CODE = '"+reg_code+"' and SEQ = '"+seq+"'";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				flag = true;
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				flag = false;
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
			}
		}
		
		public void comfirmInsur(Map<String, Object> param) throws DatabaseException, DataSourceEmptyException, SQLException{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			String query = "";
			
			String reg_code = (String) param.get("reg_code");
			int seq = Integer.parseInt(String.valueOf(param.get("seq")));
			
			
			query = "update INS_EXCEL_COM " +
					"set USE_ST='확인', " +
					"COF_DT=sysdate, "+
					"COF_CODE=to_char(trunc(to_number(sysdate-to_date('19700101','YYYYMMDDhh24miss'))*(1000*60*60),0)) " +
					"where USE_ST='요청' and REG_CODE = '"+reg_code+"' and SEQ = '"+seq+"'";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				flag = true;
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				flag = false;
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
			}
		}
		
		public Vector getInsurCode(String reg_code, int seq)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String what = "";

			query ="SELECT INSUR_CODE, VALUE05, VALUE14  FROM INS_EXCEL_COM WHERE REG_CODE = '"+reg_code+"' AND SEQ = '"+seq+"'";

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
		
		public void updateInsurCode(String insur_code, String value05) throws DatabaseException, DataSourceEmptyException, SQLException{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			boolean flag = false;
			String query = "";
			
			query = "update CAR_REG " +
					"set INSUR_CODE = '"+insur_code+"'" +
					"where CAR_NUM='"+value05+"'";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				flag = true;
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				flag = false;
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
			}
	    }
		
		public void updateContEtc(String value10, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException, SQLException{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			
			query = "update CONT_ETC " +
					"set COM_EMP_YN = '"+value10+"'" +
					"where RENT_MNG_ID='"+rent_mng_id+"' AND RENT_L_CD= '"+rent_l_cd+"'";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
			}
	    }
		
		// car_mng_id 찾기
		public String getCarMngId(String rent_mng_id, String rent_l_cd)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String car_mng_id = "";
			String query = "";

			query ="SELECT CAR_MNG_ID FROM CONT WHERE RENT_MNG_ID = '"+rent_mng_id+"' AND RENT_L_CD = '"+rent_l_cd+"' ";
			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    	
				if(rs.next()){				
					car_mng_id = rs.getString(1);
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				//System.out.println("[InsDatabase:getRent_l_cd]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
		                if(rs != null )		rs.close();
	            		if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return car_mng_id;
			}

		}
		
		public void updateCompEmpYn(String car_mng_id, String ins_st, String value10) throws DatabaseException, DataSourceEmptyException, SQLException{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			
			query = "update INSUR " +
					"set COM_EMP_YN = '"+value10+"'" +
					"where car_mng_id='"+car_mng_id+"' AND INS_ST= '"+ins_st+"'";
			
			try {
				conn.setAutoCommit(false);
				pstmt = conn.prepareStatement(query);
				pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
				
			} catch (SQLException e) {
				//System.out.println("[InsComDatabase:deleteInsExcel(String car_mng_id, String ins_st)]"+ e);
				e.printStackTrace();
				conn.rollback();
			} finally {
				try{
					if(rs != null)		rs.close();
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
			}
	    }
}
