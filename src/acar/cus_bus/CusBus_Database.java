/**
 * 고객지원 -> 영업지원
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 8. 11.
 * @ last modify date : 
 */
package acar.cus_bus;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;

public class CusBus_Database
{
	private Connection conn = null;
	public static CusBus_Database db;
	
	public static CusBus_Database getInstance()
	{
		if(CusBus_Database.db == null)
			CusBus_Database.db = new CusBus_Database();
		return CusBus_Database.db;
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

	/*
	*	개시 계약 검색 : 2004.08.11.
	*/
	public Vector getContList_s(String year, String mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = " SELECT /*+  merge(a) */  a.*,  c.car_no, c.car_nm,   a.rent_way FROM cont_n_view a, car_reg c WHERE  a.car_mng_id = c.car_mng_id(+) ";

		if(mon.equals(""))	query += " and  a.rent_start_dt like '"+year+"%' ";
		else				query += " and  a.rent_start_dt like '"+year+"-"+mon+"%' ";

		query += " AND a.use_yn = 'Y' ORDER BY a.rent_start_dt ";
		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();

            while(rs.next())
            {
				RentListBean bean = new RentListBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setClient_nm(rs.getString("CLIENT_NM"));			//고객 대표자명
			    bean.setFirm_nm(rs.getString("FIRM_NM"));				//상호
			    bean.setCar_no(rs.getString("CAR_NO"));					//차량번호
				bean.setCar_nm(rs.getString("CAR_NM"));					//차종
			    bean.setRent_way(rs.getString("RENT_WAY"));				//대여방식
			    bean.setCon_mon(rs.getString("CON_MON"));				//대여개월
			    bean.setRent_start_dt(rs.getString("RENT_START_DT"));	//대여개시일
			    bean.setBus_id(rs.getString("BUS_ID"));					//최초영업
				bean.setBus_id2(rs.getString("BUS_ID2"));				//영업담당
			    bean.setMng_id(rs.getString("MNG_ID"));					//관리담당
				bean.setCar_st(rs.getString("CAR_ST"));					//일반,기본,맞춤
			    
			    rtn.add(bean);
            }
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CusBus_Database:getContList_s(String year, String mon)]\n"+e);
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

	/*
	*	만료예정 계약 검색 : 2004.08.11.
	*/
	public Vector getContList_e(String year, String mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = " SELECT /*+  merge(a) */  a.*,  c.car_no, c.car_nm,   a.rent_way  FROM cont_n_view a, car_reg c WHERE  a.car_mng_id = c.car_mng_id(+) ";

		if(mon.equals(""))	query += " and a.rent_end_dt like '"+year+"%' ";
		else				query += " and a.rent_end_dt like '"+year+"-"+mon+"%' ";

		query += " AND a.use_yn = 'Y' ORDER BY a.rent_end_dt ";
		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();

            while(rs.next())
            {
				RentListBean bean = new RentListBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setClient_nm(rs.getString("CLIENT_NM"));			//고객 대표자명
			    bean.setFirm_nm(rs.getString("FIRM_NM"));				//상호
			    bean.setCar_no(rs.getString("CAR_NO"));					//차량번호
				bean.setCar_nm(rs.getString("CAR_NM"));					//차종
			    bean.setRent_start_dt(rs.getString("RENT_START_DT"));	//대여개시일
				bean.setRent_end_dt(rs.getString("RENT_END_DT"));		//대여만료일
				bean.setCar_st(rs.getString("CAR_ST"));					//일반,기본,맞춤
				bean.setRent_way(rs.getString("RENT_WAY"));				//대여방식
				bean.setBus_id2(rs.getString("BUS_ID2"));				//영업담당
			    bean.setMng_id(rs.getString("MNG_ID"));					//관리담당
		    
			    rtn.add(bean);
            }
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CusBus_Database:getContList_e(String year, String mon)]\n"+e);
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

	/*
	*	관리자배정 할 계약 검색 : 2004.08.11.
	*/
	public Vector getContList_c(String year, String mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		
		String query = " SELECT /*+  merge(a) */  a.*,  c.car_no, c.car_nm,  a.rent_way  FROM cont_n_view a, car_reg c WHERE  a.car_mng_id = c.car_mng_id(+) ";

		if(mon.equals(""))	query += " a.rent_dt like '"+year+"%' ";
		else				query += " a.rent_dt like '"+year+"-"+mon+"%' ";

		query += " AND a.use_yn = 'Y' ORDER BY a.rent_dt ";
		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();

            while(rs.next())
            {
				RentListBean bean = new RentListBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setClient_nm(rs.getString("CLIENT_NM"));			//고객 대표자명
			    bean.setFirm_nm(rs.getString("FIRM_NM"));				//상호
			    bean.setCar_no(rs.getString("CAR_NO"));					//차량번호
				bean.setCar_nm(rs.getString("CAR_NM"));					//차종
			    bean.setRent_dt(rs.getString("RENT_DT"));			  	//계약일
				bean.setCon_mon(rs.getString("CON_MON"));				//대여개월
				bean.setCar_st(rs.getString("CAR_ST"));					//일반,기본,맞춤
				bean.setRent_way(rs.getString("RENT_WAY"));				//대여방식
				bean.setBus_id(rs.getString("BUS_ID"));					//최초영업
				bean.setBus_id2(rs.getString("BUS_ID2"));				//영업담당
			    bean.setMng_id(rs.getString("MNG_ID"));					//관리담당
		    
			    rtn.add(bean);
            }
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CusBus_Database:getContList_c(String year, String mon)]\n"+e);
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
     * 관리자 지정 2004.08.12.
    */
	public int setMng_id(String rent_mng_id, String rent_l_cd, String mng_id){

		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
		query = "UPDATE cont SET mng_id=? WHERE rent_mng_id=? AND rent_l_cd=?";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,mng_id);
			pstmt.setString(2,rent_mng_id);
			pstmt.setString(3,rent_l_cd);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[CusBus_Database:setMng_id(String rent_mng_id, String rent_l_cd, String mng_id)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
                if(pstmt != null) pstmt.close();
                conn.setAutoCommit(true);
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	/**
     * 관리자 지정 2004.08.12.
    */
	public int setMng_id(String rent_mng_id, String rent_l_cd, String mng_id, String mode){

		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		if(mode.equals("2"))	query = "UPDATE cont SET mng_id2=? WHERE rent_mng_id=? AND rent_l_cd=?";
		else					query = "UPDATE cont SET mng_id=?  WHERE rent_mng_id=? AND rent_l_cd=?";

		try{
			conn.setAutoCommit(false);
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,mng_id);
			pstmt.setString(2,rent_mng_id);
			pstmt.setString(3,rent_l_cd);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[CusBus_Database:setMng_id(String rent_mng_id, String rent_l_cd, String mng_id, String mode)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
                if(pstmt != null) pstmt.close();
                conn.setAutoCommit(true);
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}
	
	
	
	/*
	*	관리자배정 할 계약 검색 : 2008.01.08.
	*/
	
	public Vector getContList_c(String dt, String ref_dt1, String ref_dt2, String gubun1, String gubun2, String gubun3, String gubun4, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = "";
		String dt_query = "";        
		String s_dt1 = "to_char(sysdate,'YYYYMMDD')";
		String s_dt2 = "to_char(sysdate,'YYYYMM')";
		String s_dt3 = "between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')";
					
		if (gubun1.equals("1")){ 
				dt_query = " and a.rent_way_cd= '1' \n";
		}
		else if (gubun1.equals("3")){ 
				dt_query = " and  a.rent_way_cd  in ( '3' , '2' )\n";
			
		} 
		else if (gubun1.equals("9")){ 
				dt_query = " and a.rent_way_cd= '9' \n";
		}	
		 	
		query = "SELECT a.*, nvl(c.t_amt,0) t_amt, substr(d.o_addr,1,instr(d.o_addr,' ')) || substr(substr(o_addr,instr(d.o_addr,' ')+1),1,instr(substr(d.o_addr,instr(o_addr,' ')+1),' ')) sido, c.r_fee_est_dt,  case when  TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(c.r_fee_est_dt, 'YYYYMMDD')))   < 0 then 0 else TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(c.r_fee_est_dt, 'YYYYMMDD')))  end dly_month, \n"+
				" c.dly_fee_amt, e.est_area , cr.car_no, cr.car_nm, cr.init_reg_dt ,a.rent_way  \n"+
				" FROM  cont_n_view a,  (  select rent_mng_id, rent_l_cd, max(ext_agnt) ext_agnt,  max(rent_dt) rent_dt, max(to_number(rent_st)) rent_st  from fee group by  rent_mng_id, rent_l_cd ) b, \n"+
				"       client d,  cont_etc e, car_reg cr , \n"+
				"       ( select a.rent_mng_id , a.rent_l_cd, sum( b.fee_s_amt + b.fee_v_amt) t_amt,  min(r_fee_est_dt) r_fee_est_dt, sum(case when r_fee_est_dt < to_char(sysdate,'YYYYMMDD')  then fee_s_amt + fee_v_amt else 0 end) dly_fee_amt  \n"+
				"	      from cont_n_view a, scd_fee b, cls_cont c  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and  a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and b.rc_yn='0' and nvl(b.bill_yn,'Y')<>'N' and nvl(c.cls_st,'0')<>'2' group by a.rent_mng_id , a.rent_l_cd ) c, \n"+
				"       users u1, users u2, users u3, users u4 "+
				" WHERE a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.use_yn = 'Y' and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and a.client_id = d.client_id \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)   and a.rent_mng_id=b.rent_mng_id(+)   and a.rent_l_cd=b.rent_l_cd(+)  and a.car_mng_id = cr.car_mng_id(+) \n"+
				"        and decode(b.rent_st,'1',a.bus_id,b.ext_agnt)=u1.user_id and a.bus_id2=u2.user_id and a.mng_id=u3.user_id(+) and a.mng_id2=u4.user_id(+) "+
		    	 dt_query ;
		
		if(gubun3.equals("1") && !gubun4.equals("")) query += " and u1.user_nm='"+gubun4+"'";
		if(gubun3.equals("2") && !gubun4.equals("")) query += " and u2.user_nm='"+gubun4+"'";
		if(gubun3.equals("3") && !gubun4.equals("")) query += " and u3.user_nm='"+gubun4+"'";
		if(gubun3.equals("4") && !gubun4.equals("")) query += " and u4.user_nm='"+gubun4+"'";

		query += "\n order by a.bus_id2, a.rent_way, substr(d.o_addr,1,instr(d.o_addr,' ')) || substr(substr(o_addr,instr(d.o_addr,' ')+1),1,instr(substr(d.o_addr,instr(o_addr,' ')+1),' ')), nvl(b.rent_dt,a.rent_dt)";
		
		
		try 
		{
			pstmt = conn.prepareStatement(query);
			
		    rs = pstmt.executeQuery();

            while(rs.next())
            {
				RentListBean bean = new RentListBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setClient_nm(rs.getString("CLIENT_NM"));			//고객 대표자명
			    bean.setFirm_nm(rs.getString("FIRM_NM"));				//상호
			    bean.setCar_no(rs.getString("CAR_NO"));					//차량번호
				bean.setCar_nm(rs.getString("CAR_NM"));					//차종
			    bean.setRent_dt(rs.getString("RENT_DT"));			  	//계약일
				bean.setCon_mon(rs.getString("CON_MON"));				//대여개월
				bean.setCar_st(rs.getString("CAR_ST"));					//일반,기본,맞춤
				bean.setRent_way(rs.getString("RENT_WAY"));				//대여방식
				bean.setBus_id(rs.getString("BUS_ID"));					//최초영업
				bean.setBus_id2(rs.getString("BUS_ID2"));				//영업담당
			    bean.setMng_id(rs.getString("MNG_ID"));					//관리담당
			    bean.setMng_id2(rs.getString("MNG_ID2"));				//예비배정자
			    bean.setImm_amt(rs.getInt("T_AMT"));					//받을어음
			    bean.setCpt_cd(rs.getString("SIDO"));					//지역
			    bean.setDlv_dt(rs.getString("R_FEE_EST_DT"));			//연체일
			    bean.setCar_ja(rs.getInt("DLY_MONTH"));				    //연체개월수
			    bean.setReg_amt(rs.getInt("DLY_FEE_AMT"));				//연체금액
			    bean.setInit_reg_dt(rs.getString("INIT_REG_DT"));		//최초등록일
				bean.setEst_area(rs.getString("EST_AREA"));				//차량이용지역
			             
		    
			    rtn.add(bean);
            }
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CusBus_Database:getContList_c(String dt, String ref_dt1, String ref_dt2, String gubun1, String gubun2, String gubun3, String gubun4, String sort)]\n"+e);
			System.out.println("[CusBus_Database:getContList_c(String dt, String ref_dt1, String ref_dt2, String gubun1, String gubun2, String gubun3, String gubun4, String sort)]\n"+query);
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
    
}