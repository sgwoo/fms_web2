/**
 * 거래처관리
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 11. 25. 화.
 * @ last modify date : 
 */
package acar.cus0402;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;

public class Cus0402_Database
{
	private Connection conn = null;
	public static Cus0402_Database db;
	
	public static Cus0402_Database getInstance()
	{
		if(Cus0402_Database.db == null)
			Cus0402_Database.db = new Cus0402_Database();
		return Cus0402_Database.db;
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
	
	/**
	*	차량 리스트 Bean에 데이터 넣기 2003.11.25. 화.
	*/
	 private Cus0402_scBean makeCus0402_scBean(ResultSet results) throws DatabaseException {

        try {
            Cus0402_scBean bean = new Cus0402_scBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));			//자동차관리번호
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));			//계약관리번호
			bean.setRent_l_cd(results.getString("RENT_L_CD"));				//계약번호
			bean.setClient_id(results.getString("CLIENT_ID"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_nm(results.getString("CAR_NM"));
			bean.setBrch_id(results.getString("BRCH_ID"));
			bean.setMng_id(results.getString("MNG_ID"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setRent_start_dt(results.getString("RENT_START_DT"));
			bean.setRent_end_dt(results.getString("RENT_END_DT"));
			bean.setServ_dt(results.getString("SERV_DT"));
			bean.setNext_serv_dt(results.getString("NEXT_SERV_DT"));
			bean.setVst_dt(results.getString("VST_DT"));
			bean.setVst_est_dt(results.getString("VST_EST_DT"));
			bean.setTot_dist(results.getString("TOT_DIST"));

			return bean;

        }catch (SQLException e) {
			System.out.println("[Cus0402_Database:makeCus0402_scBean(ResultSet results)]"+e);
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	거래처별 순회방문 리스트 Bean에 데이터 넣기 2003.11.26. 수.
	*/
	 public Cycle_vstBean makeCycle_vstBean(ResultSet results) throws DatabaseException {

        try {
            Cycle_vstBean bean = new Cycle_vstBean();

		    bean.setClient_id(results.getString("CLIENT_ID"));
			bean.setSeq(results.getString("SEQ"));
			bean.setVst_dt(results.getString("VST_DT"));
			bean.setVisiter(results.getString("VISITER"));
			bean.setVst_title(results.getString("VST_TITLE"));
			bean.setVst_cont(results.getString("VST_CONT"));
			bean.setVst_est_dt(results.getString("VST_EST_DT"));
			bean.setVst_est_cont(results.getString("VST_EST_CONT"));
			bean.setUpdate_id(results.getString("UPDATE_ID"));
			bean.setUpdate_dt(results.getString("UPDATE_DT"));

			return bean;

        }catch (SQLException e) {
			System.out.println("[Cus0402_Database:makeCycle_vstBean(ResultSet results)]"+e);
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	거래처별 순회방문 리스트 2003.11.26.수.
	*/
	public Cycle_vstBean[] getCycle_vstList(String client_id){
		getConnection();
		Collection<Cycle_vstBean> col = new ArrayList<Cycle_vstBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT client_id, seq, vst_dt, visiter, vst_title, vst_cont, vst_est_dt, vst_est_cont, update_id, update_dt "+
				" FROM cycle_vst "+
				" WHERE client_id = ? and vst_dt is not null "+
				" ORDER BY seq desc";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,client_id);
			rs = pstmt.executeQuery();

			while(rs.next()){
				col.add(makeCycle_vstBean(rs));
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[Cus0402_Database:getCycle_vstList(String client_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Cycle_vstBean[])col.toArray(new Cycle_vstBean[0]);
		}		
	}

	/**
	*	거래처별 순회방문 개별 조회 2003.11.26.수.
	*/
	public Cycle_vstBean getCycle_vstList(String client_id, String seq){
		getConnection();
		Cycle_vstBean bean = new Cycle_vstBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT client_id, seq, vst_dt, visiter, vst_title, vst_cont, vst_est_dt, vst_est_cont, update_id, update_dt "+
				" FROM cycle_vst "+
				" WHERE client_id=? AND seq=?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,client_id);
			pstmt.setString(2,seq);
			rs = pstmt.executeQuery();

			while(rs.next()){
				bean.setClient_id(rs.getString("CLIENT_ID")==null?"":rs.getString("CLIENT_ID"));
				bean.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				bean.setVst_dt(rs.getString("VST_DT")==null?"":rs.getString("VST_DT"));
				bean.setVisiter(rs.getString("VISITER")==null?"":rs.getString("VISITER"));
				bean.setVst_title(rs.getString("VST_TITLE")==null?"":rs.getString("VST_TITLE"));
				bean.setVst_cont(rs.getString("VST_CONT")==null?"":rs.getString("VST_CONT"));
				bean.setVst_est_dt(rs.getString("VST_EST_DT")==null?"":rs.getString("VST_EST_DT"));
				bean.setVst_est_cont(rs.getString("VST_EST_CONT")==null?"":rs.getString("VST_EST_CONT"));
				bean.setUpdate_id(rs.getString("UPDATE_ID")==null?"":rs.getString("UPDATE_ID"));
				bean.setUpdate_dt(rs.getString("UPDATE_DT")==null?"":rs.getString("UPDATE_DT"));
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[Cus0402_Database:getCycle_vstList(String client_id, String seq)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return bean;
		}		
	}

	/**
     * 거래처 순회방문 등록 2003.11.26.수.
    */
	public String insertCycle_vst(Cycle_vstBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String seq = "";
		String query1 = "";
		String query = "";
		int result = 0;

		query = "INSERT INTO cycle_vst(client_id,seq,vst_dt,visiter,vst_title,vst_cont,vst_est_dt,vst_est_cont,update_id,update_dt) "+
				" VALUES(?,?,?,?,?,?,?,?,?,?)";
		
		query1="SELECT NVL(LPAD(MAX(seq)+1,6,'0'),'000001') FROM cycle_vst WHERE client_id=?";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
            pstmt.setString(1, bean.getClient_id());
			rs = pstmt.executeQuery();
            if(rs.next()){
				seq = rs.getString(1);
            }
			rs.close();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1,bean.getClient_id());
			pstmt2.setString(2,seq);
			pstmt2.setString(3,bean.getVst_dt());
			pstmt2.setString(4,bean.getVisiter());
			pstmt2.setString(5,bean.getVst_title());
			pstmt2.setString(6,bean.getVst_cont());
			pstmt2.setString(7,bean.getVst_est_dt());
			pstmt2.setString(8,bean.getVst_est_cont());
			pstmt2.setString(9,bean.getUpdate_id());
			pstmt2.setString(10,bean.getUpdate_dt());
			result = pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
		}catch(Exception e){
			System.out.println("[Cus0402_Database:insertCycle_vst(Cycle_vstBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null ) rs.close();
          		if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return seq;
		}
	}   

	/**
     * 거래처 순회방문 수정 2003.11.26.수.
    */
	public String updateCycle_vst(Cycle_vstBean bean){

		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "UPDATE cycle_vst SET vst_dt=?,visiter=?,vst_title=?,vst_cont=?,vst_est_dt=?,vst_est_cont=?,update_id=?,update_dt=? "+
				" WHERE client_id=? AND seq=?";

		try{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,bean.getVst_dt());
			pstmt.setString(2,bean.getVisiter());
			pstmt.setString(3,bean.getVst_title());
			pstmt.setString(4,bean.getVst_cont());
			pstmt.setString(5,bean.getVst_est_dt());
			pstmt.setString(6,bean.getVst_est_cont());
			pstmt.setString(7,bean.getUpdate_id());
			pstmt.setString(8,bean.getUpdate_dt());
			pstmt.setString(9,bean.getClient_id());
			pstmt.setString(10,bean.getSeq());
			result = pstmt.executeUpdate();
			 pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Cus0402_Database:updateCycle_vst(Cycle_vstBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
			   conn.setAutoCommit(true);
              		  if(pstmt != null) pstmt.close();
             
			}catch(Exception ignore){}

			closeConnection();
			return bean.getSeq();
		}
	}

	
	/**
     * 거래처 순회방문 수정 2003.11.26.수.
    */
	public int deleteCycle_vst(String client_id, String seq){

		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "DELETE cycle_vst WHERE client_id=? AND seq=?";

		try{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,client_id);
			pstmt.setString(2,seq);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		}catch(SQLException e){
			System.out.println("[Cus0402_Database:deleteCycle_vst(String client_id, String seq)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				  conn.setAutoCommit(true);
            			  if(pstmt != null) pstmt.close();
                 
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}

	/**
	*	거래처 조회 2003.12.02.화.
	 *	gubun - 1:상호, 2:계약자명, 3: 전화번호, 4:휴대폰, 5: 주소
	 */
	public Vector getClientList(ConditionBean cnd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";
		String subQuery2 = "";
		String orderQuery = "";
		String brchQuery = "";

		//gubun3,gubun2 세부조회
		if(cnd.getGubun3().equals("N")){
			subQuery += " AND nvl(substr(d.vst_est_dt,1,6),'199901') <= to_char(sysdate,'yyyymm') ";
			if(cnd.getGubun2().equals("1")){
				subQuery += " AND d.vst_est_dt like to_char(sysdate,'yyyymm')||'%' ";
			}else if(cnd.getGubun2().equals("2")){
				subQuery += " AND d.vst_est_dt = to_char(sysdate,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("3")){
				subQuery += " AND d.vst_est_dt < to_char(sysdate,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("4")){
				subQuery += " AND d.vst_est_dt BETWEEN replace('"+cnd.getSt_dt()+"','-','') AND replace('"+cnd.getEnd_dt()+"','-','') ";
			}else if(cnd.getGubun2().equals("5")){
				subQuery += "";
			}else{
				subQuery += "";
			}
		}else if(cnd.getGubun3().equals("Y")){
			subQuery += " AND d.vst_dt <= to_char(sysdate,'yyyymmdd') ";
			if(cnd.getGubun2().equals("1")){
				subQuery += " AND d.vst_dt like to_char(sysdate,'yyyymm')||'%' ";
			}else if(cnd.getGubun2().equals("2")){
				subQuery += " AND d.vst_dt = to_char(sysdate,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("3")){
				subQuery += " AND d.vst_dt < to_char(sysdate,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("4")){
				subQuery += " AND d.vst_dt BETWEEN replace('"+cnd.getSt_dt()+"','-','') AND replace('"+cnd.getEnd_dt()+"','-','') ";
			}else if(cnd.getGubun2().equals("5")){
				subQuery += " AND d.vst_dt like to_char(sysdate,'yyyymm')||'%' ";
			}else{
				subQuery += "";
			}
		}else if(cnd.getGubun3().equals("P")){
			subQuery += " ";
			if(cnd.getGubun2().equals("1")){
				subQuery += " AND d.vst_est_dt like to_char(sysdate,'yyyymm')||'%' ";
			}else if(cnd.getGubun2().equals("2")){
				subQuery += " AND d.vst_est_dt = to_char(sysdate,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("3")){
				subQuery += " AND d.vst_est_dt < to_char(sysdate,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("4")){
				subQuery += " AND d.vst_est_dt BETWEEN replace('"+cnd.getSt_dt()+"','-','') AND replace('"+cnd.getEnd_dt()+"','-','') ";
			}else if(cnd.getGubun2().equals("5")){
				subQuery += " ";
			}else{
				subQuery += "";
			}
		}else{
			subQuery += " ";
		}

		switch (AddUtil.parseInt(cnd.getS_kd()))
		{
		case 1 : subQuery2 = " AND c.firm_nm like '%"+cnd.getT_wd()+"%' "; break;
		case 2 : subQuery2 = " AND c.client_nm like '%"+cnd.getT_wd()+"%' "; break;
		case 8 : subQuery2 = " AND b.mng_id = '"+cnd.getT_wd()+"' "; break;
		case 10 : subQuery2 = " AND b.bus_id2 = '"+cnd.getT_wd()+"' "; break;
		case 11 : subQuery2 = " AND b.bus_id = '"+cnd.getT_wd()+"' "; break;
		default : subQuery2 = " "; break;
		}
		
		//정렬
		if(cnd.getSort_gubun().equals("")){
			orderQuery = "";
		}else{
			if(cnd.getSort_gubun().equals("0")){
				orderQuery = " ORDER BY client_st "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("1")){
				orderQuery = " ORDER BY firm_nm "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("2")){
				orderQuery = " ORDER BY client_nm "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("4")){
				orderQuery = " ORDER BY vst_dt "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("5")){
				orderQuery = " ORDER BY vst_est_dt "+cnd.getAsc();
			}else{
				orderQuery = "";
			}			
		}

		query ="SELECT C.CLIENT_ID CLIENT_ID, C.CLIENT_ST CLIENT_ST, C.CLIENT_NM CLIENT_NM, nvl(C.FIRM_NM, C.client_nm) FIRM_NM,"+
				" decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '개인사업(일반)', '4', '개인사업(간이)', '5','개인사업(면세)') CLIENT_ST_NM,"+
				" C.CON_AGNT_NM CON_AGNT_NM, C.O_TEL O_TEL, C.M_TEL M_TEL, C.HOMEPAGE HOMEPAGE, "+
				" C.FAX FAX, C.O_ADDR O_ADDR, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT "+
				"FROM cont b, client C "+
				", (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d "+
			" WHERE b.client_id = c.client_id AND b.use_yn = 'Y' "+
			" AND c.client_id = d.client_id(+) "+
			brchQuery+
			subQuery +
			subQuery2 +
			" GROUP BY C.CLIENT_ID , C.CLIENT_ST , C.CLIENT_NM , nvl(C.FIRM_NM, C.client_nm) , decode(C.CLIENT_ST, '1', '법인', '2', '개인', '3', '개인사업(일반)', '4', '개인사업(간이)', '5','개인사업자(면세)') , C.CON_AGNT_NM , C.O_TEL , C.M_TEL , C.HOMEPAGE ,C.FAX , C.O_ADDR, d.vst_dt, d.vst_est_dt "+
			orderQuery;
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
			System.out.println("[Cus0402_Database:getClientList(ConditionBean cnd)]"+e);
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
	*	업무추진현황 - 2003.12.03.수.
	*/
	public int[] getUpChu(ConditionBean cnd){
		getConnection();
		int tg[] = new int[6];
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query, subQuery2 = "";

		switch (AddUtil.parseInt(cnd.getS_kd()))
		{
		case 0 : subQuery2 = " "; break;
		case 6 : subQuery2 = " AND b.brch_id = '"+cnd.getS_brch()+"' "; break;
		case 8 : subQuery2 = " AND b.mng_id = '"+cnd.getS_bus()+"' "; break;
		default : subQuery2 = " "; break;
		}

		query = "select a.vac MVAC, a.vec MVEC, a.vc MVC, b.vac DVAC, b.vec DVEC, b.vc DVC "+
				" from (SELECT nvl(sum(a.cnt),0) vac, nvl(sum(b.v_est_cnt),0) vec, nvl(sum(c.v_cnt),0) vc "+
				"		 FROM (select a.user_id, a.cnt+b.cnt cnt   "+
				"				from (select nvl(a.bus_id2,'999999') as user_id, nvl(count(0),0) cnt  "+
				"				 from (select a.bus_id2, a.client_id, count(0) cnt     "+
				"				 	 from cont a     "+
				"				 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')     "+
				"			 	 	  and a.bus_id2=nvl(a.mng_id,a.bus_id2)     "+
				"				 	group by a.bus_id2, a.client_id, a.r_site) a     "+
				"				 group by bus_id2 ) a, 	  "+
				"				( select nvl(a.mng_id,'999999') as user_id, nvl(count(0),0) cnt  "+
				"				 from (select a.mng_id, a.client_id, count(0) cnt    "+
				"				 	 from cont a    "+
				"				 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')    "+
				"				 	 	   and a.bus_id2<>a.mng_id    "+
				"				 	group by a.mng_id, a.client_id, a.r_site) a    "+
				"				 group by mng_id ) b 		  "+
				"				where a.user_id=b.user_id(+) ) a, 	  "+
				" 		 (select a.mng_id MNG_ID, nvl(sum(decode(substr(b.vst_est_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) V_EST_CNT "+
				"			from (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') a, cycle_vst b      "+
				"			where a.client_id = b.client_id    "+
				"			group by a.mng_id) b,    		  "+
				"		  ( select visiter, nvl(count(0),0) V_CNT from cycle_vst b where b.vst_dt like to_char(sysdate,'yyyymm')||'%'  group by visiter ) c "+
				"		  ,users d  "+
				"	 WHERE d.user_id = a.user_id(+) and d.user_id= b.mng_id(+) and d.user_id = c.visiter(+)  "+
				"	 AND d.user_id not in ('000006','000002') AND d.dept_id='0002'  "+
				" ) a, "+
				" (SELECT nvl(sum(a.cnt),0) vac, nvl(sum(b.v_est_cnt),0) vec, nvl(sum(c.v_cnt),0) vc "+
				"		 FROM (select a.user_id, a.cnt+b.cnt cnt "+
				"				from (select nvl(a.bus_id2,'999999') as user_id, nvl(count(0),0) cnt "+
				"				 from (select a.bus_id2, a.client_id, count(0) cnt "+
				"				 	 from cont a "+
				"				 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+
				"			 	 	  and a.bus_id2=nvl(a.mng_id,a.bus_id2) "+
				"				 	group by a.bus_id2, a.client_id, a.r_site) a "+
				"				 group by bus_id2 ) a, 	 "+
				"				( select nvl(a.mng_id,'999999') as user_id, nvl(count(0),0) cnt "+
				"				 from (select a.mng_id, a.client_id, count(0) cnt "+
				"				 	 from cont a "+
				"				 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+
				"				 	 	   and a.bus_id2<>a.mng_id "+
				"				 	group by a.mng_id, a.client_id, a.r_site) a "+
				"				 group by mng_id ) b 		 "+
				"				where a.user_id=b.user_id(+) ) a, 	 "+
				"  		 (select a.mng_id MNG_ID, nvl(sum(decode(substr(b.vst_est_dt,1,8),to_char(sysdate,'yyyymmdd'),1,0)),0) V_EST_CNT "+
				"			from (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') a, cycle_vst b "+
				"			where a.client_id = b.client_id "+
				"			group by a.mng_id) b,    		 "+
				"		  ( select visiter, nvl(count(0),0) V_CNT from cycle_vst b where b.vst_dt=to_char(sysdate,'yyyymmdd')  group by visiter ) c "+
				"		  ,users d "+
				"	 WHERE d.user_id = a.user_id(+) and d.user_id= b.mng_id(+) and d.user_id = c.visiter(+) "+
				"	 AND d.user_id not in ('000006','000002') AND d.dept_id='0002' "+
				" ) b	";
	
		try{
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				while(rs.next()){
					tg[0] = rs.getInt("MVAC");
					tg[1] = rs.getInt("MVEC");
					tg[2] = rs.getInt("MVC");
					tg[3] = rs.getInt("DVAC");
					tg[4] = rs.getInt("DVEC");
					tg[5] = rs.getInt("DVC");
				}
				rs.close();
				pstmt.close();
		
			}catch(SQLException e){
				System.out.println("[Cus0402_Database:getUpChu(ConditionBean cnd)]"+e);
				e.printStackTrace();
			}finally{
				try{
					if(rs != null ) rs.close();
					if(pstmt != null) pstmt.close();
				}catch(Exception ignore){}

				closeConnection();
				return tg;
			}
	}
	/**
	*	업무추진현황 - 2003.12.03.수.
	*/
	public int[] getUpChu2(ConditionBean cnd){
		getConnection();
		int tg[] = new int[6];
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT  a.sac MSAC, a.sec MSEC, a.sc MSC, b.sac DSAC, b.sec DSEC, b.sc DSC  "+
				" from "+
				"(SELECT nvl(sum(a.sac),0) sac, nvl(sum(b.sec),0) sec, nvl(sum(c.s_cnt),0) sc "+
				"		FROM (select nvl(mng_id,'999999') mng_id, nvl(count(0),0) sac from cont where use_yn = 'Y' group by mng_id) a, 	  "+
				"			 (select nvl(mng_id,'999999') mng_id, nvl(sum(decode(substr(b.next_serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) sec "+
				"				from cont a, service b   "+
				"				where a.car_mng_id = b.car_mng_id and a.use_yn = 'Y'   "+
				"				group by mng_id) b,      "+
				"			 (SELECT checker, nvl(count(0),0) S_CNT FROM service b where substr(b.serv_dt,1,6) like to_char(sysdate,'yyyymm')||'%' GROUP BY checker ) c "+
				"           ,users d                  	  "+
				"              WHERE d.user_id=a.mng_id(+) and d.user_id = b.mng_id(+) and d.user_id = c.checker(+)  "+
				"              AND d.user_id not in ('000006','000002') AND d.dept_id='0002'  "+
				") a, "+
				"(SELECT nvl(sum(a.sac),0) sac, nvl(sum(b.sec),0) sec, nvl(sum(c.s_cnt),0) sc "+
				"		FROM (select nvl(mng_id,'999999') mng_id, nvl(count(0),0) sac from cont where use_yn = 'Y' group by mng_id) a, 	 "+
				"			 (select nvl(mng_id,'999999') mng_id, nvl(sum(decode(b.next_serv_dt,to_char(sysdate,'yyyymmdd'),1,0)),0) sec "+
				"				from cont a, service b "+
				"				where a.car_mng_id = b.car_mng_id and a.use_yn = 'Y' "+
				"				group by mng_id) b, "+
				"			 (SELECT checker, nvl(count(0),0) S_CNT FROM service b where b.serv_dt=to_char(sysdate,'yyyymmdd') GROUP BY checker ) c "+
				"           ,users d                  	 "+
				"              WHERE d.user_id=a.mng_id(+) and d.user_id = b.mng_id(+) and d.user_id = c.checker(+) "+
				"             AND d.user_id not in ('000006','000002') AND d.dept_id='0002' "+
				") b ";

		try{
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				while(rs.next()){
					tg[0] = rs.getInt("MSAC");
					tg[1] = rs.getInt("MSEC");
					tg[2] = rs.getInt("MSC");
					tg[3] = rs.getInt("DSAC");
					tg[4] = rs.getInt("DSEC");
					tg[5] = rs.getInt("DSC");
				}

				rs.close();
				pstmt.close();

			}catch(SQLException e){
				System.out.println("[Cus0402_Database:getUpChu2(ConditionBean cnd)]"+e);
				e.printStackTrace();
			}finally{
				try{
					if(rs != null ) rs.close();
					if(pstmt != null) pstmt.close();
				}catch(Exception ignore){}

				closeConnection();
				return tg;
			}
	}

	/**
	*	업무추진현황_일단위 - 2003.12.11.목.
	*/
	public int[] getUpChu_dd(ConditionBean cnd){
		getConnection();
		int tg[] = new int[7];
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query, subQuery2 = "";

		switch (AddUtil.parseInt(cnd.getS_kd()))
		{
		case 0 : subQuery2 = " "; break;
		case 6 : subQuery2 = " AND brch_id = '"+cnd.getS_brch()+"' "; break;
		case 8 : subQuery2 = " AND mng_id = '"+cnd.getS_bus()+"' "; break;
		default : subQuery2 = " "; break;
		}


		query = "select a.nv_mc, b.v_mc, c.ns_mc, d.s_mc, e.a_mc, f.nm_mc, g.m_mc  "+
				" from   	(select count(0) nv_mc   	from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client C, (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d   		 WHERE b.client_id = c.client_id AND b.use_yn = 'Y'   "+subQuery2+"		 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where vst_est_dt = to_char(sysdate,'yyyymmdd')) a,   "+
				"			(select count(0) v_mc		from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client C, (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d   		 WHERE b.client_id = c.client_id AND b.use_yn = 'Y'   "+subQuery2+"		 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where vst_dt = to_char(sysdate,'yyyymmdd')) b,  "+  
				"			(select count(0) ns_mc		from cont a, car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and a.use_yn = 'Y'  AND next_serv_dt = to_char(sysdate,'yyyymmdd') "+subQuery2+" ) c,  "+
				"			(select count(0) s_mc		from cont a,car_reg c, 		 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and a.use_yn = 'Y'  AND serv_dt = to_char(sysdate,'yyyymmdd') "+subQuery2+" ) d,  "+  
				"			(select count(0) a_mc from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%') e,  "+  
				"			(select count(0) nm_mc from v_car_maint where mcd is null AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+24,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd')  ) f,  "+  
				"			(select count(0) m_mc from v_car_maint where mcd is not null AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+24,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd')  ) g";
			try{
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				while(rs.next()){
					tg[0] = rs.getInt("NV_MC");
					tg[1] = rs.getInt("V_MC");
					tg[2] = rs.getInt("NS_MC");
					tg[3] = rs.getInt("S_MC");
					tg[4] = rs.getInt("A_MC");
					tg[5] = rs.getInt("NM_MC");
					tg[6] = rs.getInt("M_MC");
				}
				rs.close();
				pstmt.close();
				
			}catch(SQLException e){
				System.out.println("[Cus0402_Database:getUpChu_dd(ConditionBean cnd)]"+e);
				e.printStackTrace();
			}finally{
				try{
					if(rs != null ) rs.close();
					if(pstmt != null) pstmt.close();
				}catch(Exception ignore){}

				closeConnection();
				return tg;
			}
	}

	/**
	*	업무추진현황_연기건 - 2003.12.11.목.
	*/
	public int[] getUpChu_delay(ConditionBean cnd){
		getConnection();
		int tg[] = new int[7];
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query, subQuery2 = "";

		switch (AddUtil.parseInt(cnd.getS_kd()))
		{
		case 0 : subQuery2 = " "; break;
		case 6 : subQuery2 = " AND brch_id = '"+cnd.getS_brch()+"' "; break;
		case 8 : subQuery2 = " AND mng_id = '"+cnd.getS_bus()+"' "; break;
		default : subQuery2 = " "; break;
		}

		query = "select a.nv_mc, b.v_mc, c.ns_mc, d.s_mc, e.a_mc, f.nm_mc, g.m_mc "+  
				" from   	(select count(0) nv_mc   	from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client c, (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d  WHERE b.client_id = c.client_id AND b.use_yn = 'Y'   	"+subQuery2+"	 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where vst_est_dt < to_char(sysdate,'yyyymmdd')) a,   "+
				"			(select count(0) v_mc		from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client c, (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d  WHERE b.client_id = c.client_id AND b.use_yn = 'Y'   	"+subQuery2+"	 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where vst_est_dt < to_char(sysdate,'yyyymmdd') and vst_dt = to_char(sysdate,'yyyymmdd')) b,  "+
				"			(select count(0) ns_mc		from cont a, car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and a.use_yn = 'Y'  AND next_serv_dt < to_char(sysdate,'yyyymmdd') "+subQuery2+" ) c,	"+
				"			(select count(0) s_mc		from cont a,car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and a.use_yn = 'Y'  AND serv_dt = to_char(sysdate,'yyyymmdd') "+subQuery2+" ) d,  "+  
				"			(select count(0) a_mc from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%') e,  "+  
				"			(select count(0) nm_mc from v_car_maint where mcd is null AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+29,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd') ) f,  "+  
				"			(select count(0) m_mc from v_car_maint where mcd is not null AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+29,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd') ) g ";
			try{
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				while(rs.next()){
					tg[0] = rs.getInt("NV_MC");
					tg[1] = rs.getInt("V_MC");
					tg[2] = rs.getInt("NS_MC");
					tg[3] = rs.getInt("S_MC");
					tg[4] = rs.getInt("A_MC");
					tg[5] = rs.getInt("NM_MC");
					tg[6] = rs.getInt("M_MC");
				}
				rs.close();
				pstmt.close();
				
			}catch(SQLException e){
				System.out.println("[Cus0402_Database:getUpChu_delay(ConditionBean cnd)]"+e);
				e.printStackTrace();
			}finally{
				try{
					if(rs != null ) rs.close();
					if(pstmt != null) pstmt.close();
				}catch(Exception ignore){}

				closeConnection();
				return tg;
			}
	}

	/**
	*	업무추진현황_전체_담당자별 - 2003.12.11.목.
	*/
	public int[] getUpChu_total(ConditionBean cnd){
		getConnection();
		int tg[] = new int[7];
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query, subQuery2 = "";

		switch (AddUtil.parseInt(cnd.getS_kd()))
		{
		case 0 : subQuery2 = " "; break;
		case 6 : subQuery2 = " AND brch_id = '"+cnd.getS_brch()+"' "; break;
		case 8 : subQuery2 = " AND mng_id = '"+cnd.getS_bus()+"' "; break;
		default : subQuery2 = " "; break;
		}

		query = "select a.nv_mc, b.v_mc, c.ns_mc, d.s_mc, e.a_mc, f.nm_mc, g.m_mc "+ 
				" from   	(select count(0) nv_mc   	from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client C   		 	  , (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d   		 WHERE b.client_id = c.client_id AND b.use_yn = 'Y'   	"+subQuery2+"	 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where  nvl(substr(vst_est_dt,1,6),'199901') <= to_char(sysdate,'yyyymm')) a,   "+
				"			(select count(0) v_mc		from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client C   		 	  , (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d   		 WHERE b.client_id = c.client_id AND b.use_yn = 'Y'   	"+subQuery2+"	 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)		where  vst_est_dt > to_char(sysdate,'yyyymmdd')       AND substr(vst_dt,1,6) = to_char(sysdate,'yyyymm')  ) b,  "+
			    "			(select count(0) ns_mc		from cont a, car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and a.use_yn = 'Y'  AND nvl(substr(next_serv_dt,1,6),'199901') <= substr(to_char(sysdate,'yyyymm'),1,6) "+subQuery2+" ) c,  "+
				"			(select count(0) s_mc		from cont a,car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and a.use_yn = 'Y'  AND to_date(b.next_serv_dt,'YYYYMMDD') > sysdate  AND serv_dt like to_char(sysdate,'yyyymm')||'%' "+subQuery2+" ) d,  "+
				"			(select count(0) a_mc from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%') e,  "+
				"			(select count(0) nm_mc		from car_reg a, cont b,  	(select * from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id = car_mng_id)) j  where a.car_mng_id = b.car_mng_id   and a.car_mng_id = j.car_mng_id(+)  and b.use_yn = 'Y'   AND j.che_dt IS NULL  ) f,  "+
				"			(select count(0) m_mc   	from car_reg a, cont b,  	(select * from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id = car_mng_id)) j  where a.car_mng_id = b.car_mng_id   and a.car_mng_id = j.car_mng_id(+)  and b.use_yn = 'Y'   AND j.che_dt < to_char(sysdate,'YYYYMMDD')  ) g ";


			try{
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				while(rs.next()){
					tg[0] = rs.getInt("NV_MC");
					tg[1] = rs.getInt("V_MC");
					tg[2] = rs.getInt("NS_MC");
					tg[3] = rs.getInt("S_MC");
					tg[4] = rs.getInt("A_MC");
					tg[5] = rs.getInt("NM_MC");
					tg[6] = rs.getInt("M_MC");
				}
				rs.close();
				pstmt.close();
				
			}catch(SQLException e){
				System.out.println("[Cus0402_Database:getUpChu_total(ConditionBean cnd)]"+e);
				e.printStackTrace();
			}finally{
				try{
					if(rs != null ) rs.close();
					if(pstmt != null) pstmt.close();
				}catch(Exception ignore){}

				closeConnection();
				return tg;
			}
	}

	/**
	*	업무추진현황_전체_all - 2004.01.07.
	*/
	public int[] getUpChu_total_all(){
		getConnection();
		int tg[] = new int[7];
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query, subQuery2 = "";

		query = "select a.nv_mc, b.v_mc, c.ns_mc, d.s_mc, e.a_mc, f.nm_mc, g.m_mc "+ 
				" from   	(select count(0) nv_mc   	from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client C   		 	  , (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d   		 WHERE b.client_id = c.client_id AND b.use_yn = 'Y' AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where  nvl(substr(vst_est_dt,1,6),'199901') <= to_char(sysdate,'yyyymm')) a,   "+
				"			(select count(0) v_mc		from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client C   		 	  , (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d   		 WHERE b.client_id = c.client_id AND b.use_yn = 'Y' AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)		where  to_date(vst_est_dt,'YYYYMMDD') > sysdate       AND vst_dt like to_char(sysdate,'yyyymm')||'%'  ) b,  "+
			    "			(select count(0) ns_mc		from cont a, car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and a.use_yn = 'Y'  AND nvl(substr(next_serv_dt,1,6),'199901') <= substr(to_char(sysdate,'yyyymm'),1,6)) c,  "+
				"			(select count(0) s_mc		from cont a,car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and a.use_yn = 'Y'  AND to_date(b.next_serv_dt,'YYYYMMDD') > sysdate  AND serv_dt like to_char(sysdate,'yyyymm')||'%' ) d,  "+
				"			(select count(0) a_mc from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%') e,  "+
				"			(select count(0) nm_mc		from car_reg a, cont b,  	(select * from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id = car_mng_id)) j  where a.car_mng_id = b.car_mng_id   and a.car_mng_id = j.car_mng_id(+)  and b.use_yn = 'Y'   AND j.che_dt IS NULL ) f,  "+
				"			(select count(0) m_mc   	from car_reg a, cont b,  	(select * from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id = car_mng_id)) j  where a.car_mng_id = b.car_mng_id   and a.car_mng_id = j.car_mng_id(+)  and b.use_yn = 'Y'   AND j.che_dt < to_char(sysdate,'YYYYMMDD') ) g ";


			try{
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				while(rs.next()){
					tg[0] = rs.getInt("NV_MC");
					tg[1] = rs.getInt("V_MC");
					tg[2] = rs.getInt("NS_MC");
					tg[3] = rs.getInt("S_MC");
					tg[4] = rs.getInt("A_MC");
					tg[5] = rs.getInt("NM_MC");
					tg[6] = rs.getInt("M_MC");
				}
				rs.close();
				pstmt.close();
				
			}catch(SQLException e){
				System.out.println("[Cus0402_Database:getUpChu_total_all()]"+e);
				e.printStackTrace();
			}finally{
				try{
					if(rs != null ) rs.close();
					if(pstmt != null) pstmt.close();
				}catch(Exception ignore){}

				closeConnection();
				return tg;
			}
	}


	/**
	*	순회방문 년월단위 조회 2003.12.5.금.
	*/
	public Cycle_vstBean[] getCycle_vstYM(String year, String mon, String user_id){
		getConnection();
		Collection<Cycle_vstBean> col = new ArrayList<Cycle_vstBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_id, a.update_dt "+
				" FROM cycle_vst a "+
				" WHERE a.vst_est_dt like '"+year+mon+"%' "+
				" AND a.visiter = '"+user_id+"'";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while(rs.next()){
				col.add(makeCycle_vstBean(rs));
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[Cus0402_Database:getCycle_vstYM(String year, String mon)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Cycle_vstBean[])col.toArray(new Cycle_vstBean[0]);
		}		
	}

	/**
	*	처리완료된 순회방문 년월단위 조회 2003.12.17.금.
	*/
	public Cycle_vstBean[] getCycle_vstYM_cmplt(String year, String mon, String user_id){
		getConnection();
		ArrayList<Cycle_vstBean> col = new ArrayList<Cycle_vstBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.client_id, a.seq, a.vst_dt, a.visiter, a.vst_title, a.vst_cont, a.vst_est_dt, a.vst_est_cont, a.update_id, a.update_dt "+
				" FROM cycle_vst a "+
				" WHERE a.vst_dt like '"+year+mon+"%' "+
				" AND a.visiter = '"+ user_id +"' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while(rs.next()){
				col.add(makeCycle_vstBean(rs));
			}
			rs.close();
			pstmt.close();

		}catch(SQLException e){
			System.out.println("[Cus0402_Database:getCycle_vstYM(String year, String mon)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Cycle_vstBean[])col.toArray(new Cycle_vstBean[0]);
		}		
	}

/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/


/**
	*	차량별 주행거리 리스트
	*/
	public Vector getCarDistStat(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select decode(st,'service','정비','maint','검사','cons','탁송','cls','해지') st, tot_dt, tot_dist "+
				" from   v_dist "+
				" where  car_mng_id='"+car_mng_id+"' "+
				" order by tot_dt desc";

		try 
		{
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
			System.out.println("[Cus0402_Database:getCarDistStat]\n"+e);
			System.out.println("[Cus0402_Database:getCarDistStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

}