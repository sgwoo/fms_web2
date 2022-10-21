/**
 * 업무현황(개인)
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 8. 6.
 * @ last modify date : 
 */
package acar.cus_pre;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;

public class CusPre_Database
{
	private Connection conn = null;
	public static CusPre_Database db;
	
	public static CusPre_Database getInstance()
	{
		if(CusPre_Database.db == null)
			CusPre_Database.db = new CusPre_Database();
		return CusPre_Database.db;
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

	/**
	*	거래처,자동차(렌트,리스,일반식,기본식,맞춤식)관리 및 영업(최초,담당) 현황 조회 2004.08.06.
	*/
	public int[] getCusPre(String user_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] st = new int[13];
		String query = "select u.user_id, nvl(a.cnt,0) ccd, nvl(b.cnt,0) ccg, nvl(c.cnt,0) rcd, nvl(d.cnt,0) rcg, nvl(grc,0), nvl(brc,0), nvl(mrc,0), nvl(glc,0), nvl(blc,0), nvl(mlc,0), nvl(k.cnt,0) fbc, nvl(l.cnt,0) nbc, nvl(m.cnt,0) nmc "+
						" from (select bus_id2 as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228')  "+
						" group by bus_id2) u, "+
						//--업체수=단독
						" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt  "+
						" from (select a.bus_id2, a.client_id, count(0) cnt  "+
						" 	 from cont a  "+
						" 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')  "+
						" 	 	  and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_st <> '4'  "+
						" 	group by a.bus_id2, a.client_id, a.r_site) a  "+
						" group by bus_id2 ) a, "+
						//--업체수=공동(관리)
						" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt  "+
						" from (select a.mng_id, a.client_id, count(0) cnt  "+
						" 	 from cont a  "+
						" 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')  "+
						" 	 	   and a.bus_id2<>a.mng_id and a.car_st <> '4'  "+
						" 	group by a.mng_id, a.client_id, a.r_site) a  "+
						" group by mng_id ) b, "+
						//--자동차 단독
						" (select nvl(a.mng_id,bus_id2) as user_id, count(0) cnt  "+
						" from cont a, fee b  "+
						" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1'  "+
						" 	and a.client_id not in ('000231', '000228')   "+
						" 	and a.car_mng_id is not null  "+
						" group by nvl(a.mng_id,bus_id2)) c, "+
						//--자동차 공동(관리)
						" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt  "+
						" from cont a, fee b  "+
						" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1'  "+
						" 	and a.client_id not in ('000231', '000228') and b.rent_way='1'  "+
						" 	and a.mng_id=a.mng_id2 and a.car_mng_id is not null  "+
						" group by a.mng_id ) d, "+
						//--렌트--------------------------------------------------------------------------------------
						" (select nvl(a.mng_id,bus_id2) as user_id, "+
						" 	   nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'1',1,0),0)),0) grc, "+
						" 	   nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'2',1,0),0)),0) brc, "+
						" 	   nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'3',1,0),0)),0) mrc, "+
						" 	   nvl(sum(decode(a.car_st,'1',1,0)),0) tot_rc, "+
						" 	   nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'1',1,0),0)),0) glc, "+
						" 	   nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'2',1,0),0)),0) blc, "+
						" 	   nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'3',1,0),0)),0) mlc, "+
						" 	   nvl(sum(decode(a.car_st,'3',1,0)),0) tot_lc, "+
						" 	   nvl(sum(decode(b.rent_way,'1',1,0)),0) tot_gc, "+
						" 	   nvl(sum(decode(b.rent_way,'2',1,0)),0) tot_bc, "+
						" 	   nvl(sum(decode(b.rent_way,'3',1,0)),0) tot_mc, count(0) tot "+
						" from cont a, fee b  "+
						" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y'  "+
						" 	and b.rent_st='1' and a.client_id not in ('000231', '000228')  "+
						" 	and a.car_mng_id is not null  "+
						" group by nvl(a.mng_id,bus_id2) ) e, "+
						//--------최초영업--------------------------------------------------------------------------------
						" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt  "+
						" from cont a, fee b  "+
						" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1'  "+
						" 	and a.client_id not in ('000231', '000228')  "+
						" 	and a.car_mng_id is not null  "+
						" group by a.bus_id) k, "+
						//---------영업담당
						" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt  "+
						" from cont a, fee b  "+
						" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1'  "+
						" 	and a.client_id not in ('000231', '000228')  "+
						" 	and a.car_mng_id is not null  "+
						" group by a.bus_id2) l, "+
						//--------관리담당
						" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt  "+
						" from cont a, fee b  "+
						" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1'  "+
						" 	and a.client_id not in ('000231', '000228') "+
						" 	and a.car_mng_id is not null  "+
						" group by a.mng_id) m "+
						//
						" where u.user_id = a.user_id(+) "+
						" and u.user_id = b.user_id(+) "+
						" and u.user_id = c.user_id(+) "+
						" and u.user_id = d.user_id(+) "+
						" and u.user_id = e.user_id(+) "+
						" and u.user_id = k.user_id(+) "+
						" and u.user_id = l.user_id(+) "+
						" and u.user_id = m.user_id(+) "+
						" and u.user_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,user_id);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				st[0] = rs.getInt(2);
				st[1] = rs.getInt(3);
				st[2] = rs.getInt(4);
				st[3] = rs.getInt(5);
				st[4] = rs.getInt(6);
				st[5] = rs.getInt(7);
				st[6] = rs.getInt(8);
				st[7] = rs.getInt(9);
				st[8] = rs.getInt(10);
				st[9] = rs.getInt(11);
				st[10] = rs.getInt(12);
				st[11] = rs.getInt(13);
				st[12] = rs.getInt(14);
			}
			rs.close();
			pstmt.close();

		}catch(Exception e){
			System.out.println("[CusPre_Database:getCusPre(String user_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return st;
		}
	}

	/**
	*	거래처방문 추진 현황 조회 2004.08.07.
	*/
	public int[] getCusPre_client(String user_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] st = new int[7];
		String query = "SELECT a.mng_id, nvl(a.vm_all_cnt,0), nvl(a.vm_est_cnt,0), nvl(b.vm_cnt,0), nvl(a.vd_all_cnt,0), nvl(a.vd_est_cnt,0), nvl(b.vd_cnt,0) "+
						" FROM (select a.mng_id, "+
						"			nvl(sum(decode(substr(b.vst_est_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) vm_all_cnt, "+
						"			nvl(sum(decode(b.vst_dt,'',decode(substr(b.vst_est_dt,1,6),to_char(sysdate,'yyyymm'),1,0),0)),0) vm_est_cnt, "+
						"			nvl(sum(decode(b.vst_est_dt,to_char(sysdate,'yyyymmdd'),1,0)),0) vd_all_cnt, "+
						"			nvl(sum(decode(b.vst_dt,'',decode(b.vst_est_dt,to_char(sysdate,'yyyymmdd'),1,0),0)),0) vd_est_cnt "+
						"		from (select client_id,mng_id from cont where use_yn = 'Y'  group by client_id,mng_id) a, cycle_vst b "+
						"		where a.client_id = b.client_id "+
						"		group by a.mng_id) a, "+
						"	  ( select visiter, nvl(sum(decode(substr(vst_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) vm_cnt, nvl(sum(decode(vst_dt,to_char(sysdate,'yyyymmdd'),1,0)),0) vd_cnt from cycle_vst  group by visiter ) b"+
						" WHERE a.mng_id = b.visiter(+) "+
						"	AND a.mng_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				st[0] = rs.getInt(2);
				st[1] = rs.getInt(3);
				st[2] = rs.getInt(4);
				st[3] = rs.getInt(5);
				st[4] = rs.getInt(6);
				st[5] = rs.getInt(7);
			}
			rs.close();
			pstmt.close();

		}catch(Exception e){
			System.out.println("[CusPre_Database:getCusPre_client(String user_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return st;
		}
	}

	/**
	*	거래처방문 추진 현황 조회 2004.08.07.
	*/
	public int[] getCusPre_car(String user_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] st = new int[6];
		String query = "SELECT b.checker, nvl(a.sm_all_cnt,0), nvl(a.sm_est_cnt,0), nvl(b.sm_cnt,0), nvl(a.sd_all_cnt,0), nvl(a.sd_est_cnt,0), nvl(b.sd_cnt,0) "+
						" FROM (select nvl(a.mng_id,'999999') mng_id,  "+
						" 			nvl(sum(decode(substr(b.next_serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) sm_all_cnt,  "+
						" 			nvl(sum(decode(b.serv_dt,'',decode(substr(b.next_serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0),0)),0) sm_est_cnt,  "+
						" 			nvl(sum(decode(b.next_serv_dt,to_char(sysdate,'yyyymmdd'),1,0)),0) sd_all_cnt,  "+
						" 			nvl(sum(decode(b.serv_dt,'',decode(b.next_serv_dt,to_char(sysdate,'yyyymmdd'),1,0),0)),0) sd_est_cnt  "+
						"		from cont a, service b  "+
						"		where a.car_mng_id = b.car_mng_id  "+
						"		  and a.use_yn = 'Y'  and a.car_st <> '4'   "+
						"		group by a.mng_id) a, "+
						"	  (SELECT checker, nvl(sum(decode(substr(serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) sm_cnt, nvl(sum(decode(substr(serv_dt,1,6),to_char(sysdate,'yyyymmdd'),1,0)),0) sd_cnt FROM service GROUP BY checker ) b "+
						" WHERE a.mng_id = b.checker(+) "+
						"   AND a.mng_id = ? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,user_id);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				st[0] = rs.getInt(2);
				st[1] = rs.getInt(3);
				st[2] = rs.getInt(4);
				st[3] = rs.getInt(5);
				st[4] = rs.getInt(6);
				st[5] = rs.getInt(7);
			}
			rs.close();
			pstmt.close();

		}catch(Exception e){
			System.out.println("[CusPre_Database:getCusPre_car(String user_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return st;
		}
	}

	//계약 검색 : 리스트 조회(cont,car_reg,client,fee,users,car_pur,car_etc,allot) - 예비 배정 추가
	public Vector getContList(String br_id, String user_id, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = "";

		query = " select /*+  merge(a) */ a.*,  c.car_no, c.car_nm, c.init_reg_dt,  decode(c.init_reg_dt, null, 'id', 'ud') as REG_GUBUN,  \n"+
				"        b.user_nm as re_bus_nm, n.emp_nm, a.rent_way,  c.car_num, '' reg_ext_dt, ''car_id,  \n"+
				"  '' rpt_no, '' cpt_cd, ''car_id,   cc.cls_st, c.fuel_kd as scan_file \n" +
				" from   cont_n_view a, users b, car_reg c, cls_cont cc , \n"+
				"        (select i.* from end_cont_mm i,(select rent_mng_id, rent_l_cd, max(seq) seq from end_cont_mm group by rent_mng_id, rent_l_cd ) ii where i.rent_mng_id = ii.rent_mng_id and i.rent_l_cd= ii.rent_l_cd and i.seq = ii.seq ) c, \n"+
				"        (select a.rent_mng_id, a.rent_l_cd, b.emp_nm from commi a, car_off_emp b where a.agnt_st='1' and a.emp_id=b.emp_id ) n \n"+
				" where  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') AND c.re_bus_id = b.user_id(+) AND a.rent_mng_id = c.rent_mng_id(+) AND a.rent_l_cd = c.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=n.rent_mng_id(+) and a.rent_l_cd=n.rent_l_cd(+) and a.car_mng_id = c.car_mng_id \n"+
				"        and a.rent_mng_id=cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+)  \n"+			
				" ";

		if(!user_id.equals(""))			query += " and  ( nvl(a.mng_id,a.bus_id2)='"+user_id+"'  or a.mng_id2 ='"+user_id+"' ) ";

		if(gubun.equals("1"))			query += " and a.rent_start_dt between to_char(sysdate-30,'yyyy-mm-dd') and to_char(sysdate,'yyyy-mm-dd') order by a.rent_start_dt ";
		else if(gubun.equals("2"))		query += " and ( (a.rent_end_dt between to_char(sysdate-30,'yyyy-mm-dd') and to_char(sysdate+30, 'yyyy-mm-dd')) or ( a.rent_end_dt < to_char(sysdate-30,'yyyy-mm-dd')) ) order by a.rent_end_dt desc ";


		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();

            while(rs.next())
            {
				RentListBean bean = new RentListBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setRent_dt(rs.getString("RENT_DT"));				//계약일자
			    bean.setDlv_dt(rs.getString("DLV_DT"));					//출고일자
			    bean.setClient_id(rs.getString("CLIENT_ID"));					//고객ID
			    bean.setClient_nm(rs.getString("CLIENT_NM"));					//고객 대표자명
			    bean.setFirm_nm(rs.getString("FIRM_NM"));						//상호
			    bean.setBr_id(rs.getString("BRCH_ID"));						//상호
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));					//자동차관리ID
			    bean.setInit_reg_dt(rs.getString("INIT_REG_DT"));					//최초등록일
			    bean.setReg_gubun(rs.getString("REG_GUBUN"));					//최초등록일
			    bean.setCar_no(rs.getString("CAR_NO"));						//차량번호
				bean.setCar_nm(rs.getString("CAR_NM"));						//차종
			    bean.setCar_num(rs.getString("CAR_NUM"));						//차대번호
			    bean.setRent_way(rs.getString("RENT_WAY"));					//대여방식
			    bean.setCon_mon(rs.getString("CON_MON"));						//대여개월
			    bean.setCar_id(rs.getString("CAR_ID"));						//차명ID
			    bean.setRent_start_dt(rs.getString("RENT_START_DT"));				//대여개시일
			    bean.setRent_end_dt(rs.getString("RENT_END_DT"));					//대여종료일
			    bean.setReg_ext_dt(rs.getString("REG_EXT_DT"));					//등록예정일?
			    bean.setRpt_no(rs.getString("RPT_NO"));						//계출번호
			    bean.setCpt_cd(rs.getString("CPT_CD"));						//은행코드
			    bean.setBus_id(rs.getString("BUS_ID"));
				bean.setBus_id2(rs.getString("BUS_ID2"));					
			    bean.setMng_id(rs.getString("MNG_ID"));					
				bean.setUse_yn(rs.getString("USE_YN"));					
				bean.setRent_st(rs.getString("RENT_ST"));					
				bean.setCls_st(rs.getString("CLS_ST"));					
				bean.setCar_st(rs.getString("CAR_ST"));					
			
				bean.setRe_bus_nm(rs.getString("RE_BUS_NM"));  //진행 담당자
				bean.setEmp_nm(rs.getString("EMP_NM"));  //진행 담당자
				
				bean.setScan_file(rs.getString("SCAN_FILE"));  //연료 
			    
			    rtn.add(bean);
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getContList]\n"+e);
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
	*	당일 거래처 방문 예정 2004.08.13. - 당해년도만 
	*/
	public Vector getVst_estList(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String who = "";

		if(!user_id.equals("")) who = " and c.mng_id=? ";
		else					who = " and c.mng_id is not null ";

		query = "select a.client_id, nvl(a.firm_nm,a.client_nm) firm_nm, a.client_nm, b.vst_dt, b.vst_est_dt, b.vst_est_cont, c.mng_id, b.seq "+
				" from client a, cycle_vst b, (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') c "+
				" where a.client_id = b.client_id "+
				" and a.client_id = c.client_id "+
				" and b.vst_est_dt = to_char(sysdate,'yyyymmdd') "+
				who+
				"union "+
				" select a.client_id, nvl(a.firm_nm,a.client_nm) firm_nm, a.client_nm, b.vst_dt, b.vst_est_dt, b.vst_est_cont, c.mng_id, b.seq "+
				" from client a, cycle_vst b, (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y' ) c "+
				" where a.client_id = b.client_id "+
				" and a.client_id = c.client_id "+
				" and b.vst_dt is null and b.vst_est_dt < to_char(sysdate,'yyyymmdd') and b.vst_est_dt like to_char(sysdate,'YYYY')||'%' "+
				who+
				"union "+
				"select a.client_id, nvl(a.firm_nm,a.client_nm) firm_nm, a.client_nm, b.vst_dt, b.vst_est_dt, b.vst_est_cont, c.mng_id, b.seq "+
				" from client a, cycle_vst b, (SELECT DISTINCT client_id, mng_id2 as mng_id FROM cont WHERE use_yn = 'Y' and mng_id is not null ) c "+
				" where a.client_id = b.client_id "+
				" and a.client_id = c.client_id "+
				" and b.vst_est_dt = to_char(sysdate,'yyyymmdd') "+
				who+
				"union "+
				" select a.client_id, nvl(a.firm_nm,a.client_nm) firm_nm, a.client_nm, b.vst_dt, b.vst_est_dt, b.vst_est_cont, c.mng_id, b.seq "+
				" from client a, cycle_vst b, (SELECT DISTINCT client_id, mng_id2 as mng_id FROM cont WHERE use_yn = 'Y' and mng_id is not null) c "+
				" where a.client_id = b.client_id "+
				" and a.client_id = c.client_id "+
				" and b.vst_dt is null and b.vst_est_dt < to_char(sysdate,'yyyymmdd')  and b.vst_est_dt like to_char(sysdate,'YYYY')||'%' "+
				who;
		try 
		{
			pstmt = conn.prepareStatement(query);

			if(!user_id.equals("")){
				pstmt.setString(1, user_id);
				pstmt.setString(2, user_id);
				pstmt.setString(3, user_id);
				pstmt.setString(4, user_id);
			}

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
			System.out.println("[CusPre_Database:getVst_estList(String user_id)]\n"+e);
			System.out.println("[CusPre_Database:getVst_estList(String user_id)]\n"+query);
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

	/*
	*	당일 자동차 정비 예정 2004.08.13. - 예비배정 추가
	*/
	public Vector getNext_servList(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String who = "";

		if(!user_id.equals("")) who = " and b.mng_id = ? ";
		else					who = " and b.mng_id is not null ";

		query = "select a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls \n"+
				" from \n"+
				"	(select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls \n"+
				"    from client a, (SELECT DISTINCT client_id,car_mng_id,mng_id FROM cont WHERE use_yn = 'Y') b, car_reg c, service d \n"+
				"	 where nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id \n"+
				"	 and b.car_mng_id = c.car_mng_id \n"+
				"	 and c.car_mng_id = d.car_mng_id \n"+
				"	 and d.next_serv_dt = to_char(sysdate,'yyyymmdd') \n"+
				who+" ) a, service b \n"+
				" where a.car_mng_id = b.car_mng_id \n"+
				" and a.serv_id  = b.serv_id \n"+
				" union \n"+
				" select a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls \n"+
				" from (select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls \n"+
				" from client a, \n"+
				" 	 (SELECT DISTINCT client_id,car_mng_id,mng_id FROM cont WHERE use_yn = 'Y') b, \n"+
				" 	 car_reg c, service d \n"+
				" where nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id \n"+
				" and b.car_mng_id = c.car_mng_id \n"+
				" and c.car_mng_id = d.car_mng_id \n"+
			//	" and d.next_serv_dt<=to_char(sysdate,'yyyymmdd') and d.serv_dt is null \n"+
				" and d.next_serv_dt<=to_char(sysdate,'yyyymmdd') and substr(d.next_serv_dt,1,4) = to_char(sysdate, 'yyyy') and d.serv_dt is null \n"+
				who+" ) a, service b \n"+
				" where a.car_mng_id = b.car_mng_id \n"+
				" and a.serv_id  = b.serv_id \n"+  //예비배정
				" union \n"+
				"select a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls \n"+
				" from (select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls \n"+
				" from client a,  \n"+
				" 	 (SELECT DISTINCT client_id,car_mng_id, mng_id2 as mng_id FROM cont WHERE use_yn = 'Y' and mng_id is not null) b,  \n"+
				" 	 car_reg c, service d \n"+
				" where nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id \n"+
				" and b.car_mng_id = c.car_mng_id \n"+
				" and c.car_mng_id = d.car_mng_id \n"+
				" and d.next_serv_dt = to_char(sysdate,'yyyymmdd') \n"+
				who+" ) a, service b \n"+
				" where a.car_mng_id = b.car_mng_id \n"+
				" and a.serv_id  = b.serv_id \n"+
				" union \n"+
				" select a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls \n"+
				" from (select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls \n"+
				" from client a, "+
				" 	 (SELECT DISTINCT client_id, car_mng_id, mng_id2 as mng_id FROM cont WHERE use_yn = 'Y' and mng_id is not null) b, \n"+
				" 	 car_reg c, service d \n"+
				" where nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id "+
				" and b.car_mng_id = c.car_mng_id \n"+
				" and c.car_mng_id = d.car_mng_id \n"+
				" and d.next_serv_dt<=to_char(sysdate,'yyyymmdd') and d.serv_dt is null \n"+
				who+" ) a, service b \n"+
				" where a.car_mng_id = b.car_mng_id \n"+
				" and a.serv_id  = b.serv_id ";

/*

		query = "select a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls, \n"+
				" vt.tot_dist AS TOT_DIST, decode( vt.tot_dist, '', 0, '0',  0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, round( "+
				" vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))))) AS AVERAGE_DIST, "+
				" decode( vt.tot_dist, '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist + round( vt.tot_dist "+
				" / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) * ( to_date( to_char( sysdate, "+
				" 'YYYYMMDD' ), 'YYYYMMDD' ) - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST "+
				" from \n"+
				"	(select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls, c.init_reg_dt \n"+
				"    from client a, (SELECT DISTINCT client_id,car_mng_id,mng_id FROM cont WHERE use_yn = 'Y') b, car_reg c, service d \n"+
				"	 where nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id \n"+
				"	 and b.car_mng_id = c.car_mng_id \n"+
				"	 and c.car_mng_id = d.car_mng_id \n"+
				"	 and d.next_serv_dt = to_char(sysdate,'yyyymmdd') \n"+
				who+" ) a, service b, v_tot_dist vt, cont e \n"+
				" where a.car_mng_id = b.car_mng_id \n"+
				" AND a.car_mng_id = vt.car_mng_id(+)  AND a.car_mng_id = e.car_mng_id "+
				" and a.serv_id  = b.serv_id \n"+
				" union \n"+
				" select a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls, \n"+
				" vt.tot_dist AS TOT_DIST, decode( vt.tot_dist, '', 0, '0',  0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, round( "+
				" vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))))) AS AVERAGE_DIST, "+
				" decode( vt.tot_dist, '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist + round( vt.tot_dist "+
				" / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) * ( to_date( to_char( sysdate, "+
				" 'YYYYMMDD' ), 'YYYYMMDD' ) - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST "+
				" from (select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls, c.init_reg_dt  \n"+
				" from client a, \n"+
				" 	 (SELECT DISTINCT client_id,car_mng_id,mng_id FROM cont WHERE use_yn = 'Y') b, \n"+
				" 	 car_reg c, service d \n"+
				" where nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id \n"+
				" and b.car_mng_id = c.car_mng_id \n"+
				" and c.car_mng_id = d.car_mng_id \n"+
			//	" and d.next_serv_dt<=to_char(sysdate,'yyyymmdd') and d.serv_dt is null \n"+
				" and d.next_serv_dt<=to_char(sysdate,'yyyymmdd') and substr(d.next_serv_dt,1,4) = to_char(sysdate, 'yyyy') and d.serv_dt is null \n"+
				who+" ) a, service b, v_tot_dist vt, cont e  \n"+
				" where a.car_mng_id = b.car_mng_id \n"+
				" AND a.car_mng_id = vt.car_mng_id(+)  AND a.car_mng_id = e.car_mng_id "+
				" and a.serv_id  = b.serv_id \n"+  //예비배정
				" union \n"+
				"select a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls, \n"+
				" vt.tot_dist AS TOT_DIST, decode( vt.tot_dist, '', 0, '0',  0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, round( "+
				" vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))))) AS AVERAGE_DIST, "+
				" decode( vt.tot_dist, '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist + round( vt.tot_dist "+
				" / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) * ( to_date( to_char( sysdate, "+
				" 'YYYYMMDD' ), 'YYYYMMDD' ) - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST "+
				" from (select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls, c.init_reg_dt  \n"+
				" from client a,  \n"+
				" 	 (SELECT DISTINCT client_id,car_mng_id, mng_id2 as mng_id FROM cont WHERE use_yn = 'Y' and mng_id is not null) b,  \n"+
				" 	 car_reg c, service d \n"+
				" where nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id \n"+
				" and b.car_mng_id = c.car_mng_id \n"+
				" and c.car_mng_id = d.car_mng_id \n"+
				" and d.next_serv_dt = to_char(sysdate,'yyyymmdd') \n"+
				who+" ) a, service b, v_tot_dist vt, cont e  \n"+
				" where a.car_mng_id = b.car_mng_id \n"+
				" AND a.car_mng_id = vt.car_mng_id(+)  AND a.car_mng_id = e.car_mng_id "+
				" and a.serv_id  = b.serv_id \n"+
				" union \n"+
				" select a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls, \n"+
				" vt.tot_dist AS TOT_DIST, decode( vt.tot_dist, '', 0, '0',  0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, round( "+
				" vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))))) AS AVERAGE_DIST, "+
				" decode( vt.tot_dist, '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist + round( vt.tot_dist "+
				" / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) * ( to_date( to_char( sysdate, "+
				" 'YYYYMMDD' ), 'YYYYMMDD' ) - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST "+
				" from (select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls, c.init_reg_dt  \n"+
				" from client a, "+
				" 	 (SELECT DISTINCT client_id, car_mng_id, mng_id2 as mng_id FROM cont WHERE use_yn = 'Y' and mng_id is not null) b, \n"+
				" 	 car_reg c, service d \n"+
				" where nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id "+
				" and b.car_mng_id = c.car_mng_id \n"+
				" and c.car_mng_id = d.car_mng_id \n"+
				" and d.next_serv_dt<=to_char(sysdate,'yyyymmdd') and d.serv_dt is null \n"+
				who+" ) a, service b, v_tot_dist vt, cont e  \n"+
				" where a.car_mng_id = b.car_mng_id \n"+
				" AND a.car_mng_id = vt.car_mng_id(+)  AND a.car_mng_id = e.car_mng_id "+
				" and a.serv_id  = b.serv_id ";
*/
		try 
		{
			pstmt = conn.prepareStatement(query);

			if(!user_id.equals("")){
				pstmt.setString(1, user_id);
				pstmt.setString(2, user_id);
				pstmt.setString(3, user_id);
				pstmt.setString(4, user_id);
			}	
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
			System.out.println("[CusPre_Database:getNext_servList(String user_id)]\n"+e);
			System.out.println("[CusPre_Database:getNext_servList(String user_id)]\n"+query);
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

	/*
	*	당일 운행자 검사/정기검사 D-7일 예정 2004.08.16. - 점검은 최초4년주기(렌트):20100108
	*	d-30, d+30으로 변경 20050601 - 예비배정중 일반식 포함 수정 - 2007/06/18
	*/
	public Vector getCar_maintList(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String who1 = "";
		String who2 = "";

 
		if(!user_id.equals("")){
			who1 = " AND decode(b.mng_id, '000003', '000013', '000004','000013','000005','000013' ,'000006','000013','000037','000013','000035','000013', '000031','000013','000077','000013','000144','000013','000126','000013',  '000026', '000013',  b.mng_id) = '"+user_id+"' ";
			who2 = " AND b.mng_id  = '"+user_id+"' ";
		}else{
			who1 = " and b.mng_id is not null ";
			who2 = " and b.mng_id is not null ";
		}
		
		//if(user_id.equals("000006") || user_id.equals("000004") || user_id.equals("000029")){
		//	who1 = "";
		//	who2 = "";
		//}
		/*
		query = "SELECT a.m1_chk, a.car_mng_id, b.rent_l_cd, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000006','000013','000037','000013', '000077','000013',b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e,\n"+
		//		" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id,  case when mng_id is null then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else mng_id end mng_id  from cont c, users u  where c.bus_id2 = u.user_id and c.use_yn = 'Y' ) b, "+
				" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id,  case when mng_id is null then case when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else mng_id end mng_id  from cont c, users u  where c.bus_id2 = u.user_id and c.use_yn = 'Y' ) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d "+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id \n"+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
	//			" AND substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd') \n"+
				" AND ( (substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd')) or ( a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd')) )    \n"+
		//		" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who1+
				" \n union \n"+
				"SELECT  a.m1_chk, a.car_mng_id, b.rent_l_cd, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000006','000013','000037','000013', '000077','000013',b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e,\n"+
		//		" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id,  case when mng_id is null then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else mng_id end mng_id  from cont c, users u  where c.bus_id2 = u.user_id and c.use_yn = 'Y' ) b, "+
				" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id,  case when mng_id is null then case when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else mng_id end mng_id  from cont c, users u  where c.bus_id2 = u.user_id and c.use_yn = 'Y' ) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d "+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id \n"+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
		//		" AND a.maint_end_dt between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd') \n"+
				" AND ( ( a.maint_end_dt between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd')) or (  a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and a.test_end_dt between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd') ) )  \n"+
//				" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who1+
				" \n union \n"+
				" SELECT  a.m1_chk, a.car_mng_id, b.rent_l_cd, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000006','000013','000037','000013', '000077','000013',b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e, \n"+
			//	" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id,  case when mng_id is null then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else  mng_id  end  mng_id  from cont c, users u  where c.bus_id2 = u.user_id and c.use_yn = 'Y') b, "+
				" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id,  case when mng_id is null then case when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else  mng_id  end  mng_id  from cont c, users u  where c.bus_id2 = u.user_id and c.use_yn = 'Y') b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d \n"+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id \n"+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
				" AND ( (substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd')) or ( a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd')) )    \n"+
		//		" AND substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  < to_char(sysdate,'YYYYMMdd') \n"+
		//		" and d.che_dt is null "+
		//		" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who1+
				" \n union \n"+
				" SELECT  a.m1_chk, a.car_mng_id, b.rent_l_cd, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000006','000013','000037','000013', '000077','000013',b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e, \n"+
			//	" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id,  case when mng_id is null then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else  mng_id  end  mng_id  from cont c, users u  where c.bus_id2 = u.user_id and c.use_yn = 'Y') b, "+
				" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id,  case when mng_id is null then case when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else  mng_id  end  mng_id  from cont c, users u  where c.bus_id2 = u.user_id and c.use_yn = 'Y') b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d \n"+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id \n"+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
				" AND ( (a.maint_end_dt < to_char(sysdate,'YYYYMMdd')) or (  a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and a.test_end_dt < to_char(sysdate,'YYYYMMdd')  ) )  \n"+
		//		" AND a.maint_end_dt < to_char(sysdate,'YYYYMMdd') \n"+
//				" and d.che_dt is null "+
			//	" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who1+
				" \n union \n"+                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
				" SELECT a.m1_chk, a.car_mng_id,  b.rent_l_cd, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000006','000013','000037','000013', '000077','000013',b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e,\n"+
				" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id, mng_id2 as mng_id from cont where use_yn = 'Y' and mng_id is not null) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d \n"+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id "+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
				" AND ( (substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd')) or ( a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd')) )    \n"+
			//	" AND substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8) between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd') \n"+
			//	" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who2+
				" \n union \n"+                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
				" SELECT a.m1_chk, a.car_mng_id, b.rent_l_cd, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000006','000013','000037','000013', '000077','000013',b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e,\n"+
				" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id, mng_id2 as mng_id from cont where use_yn = 'Y' and mng_id is not null) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d \n"+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id "+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
			//	" AND a.maint_end_dt between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd') \n"+
				" AND ( ( a.maint_end_dt between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd')) or (  a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and a.test_end_dt between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd') ) )  \n"+
			//	" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)\n"+
				who2+
				" \n union \n"+
				" SELECT a.m1_chk, a.car_mng_id, b.rent_l_cd, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000006','000013','000037','000013', '000077','000013',b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e, \n"+
				" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id, mng_id2 as mng_id from cont where use_yn = 'Y' and mng_id is not null) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d \n"+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id \n"+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
				" AND ( (substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd')) or ( a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd')) )    \n"+
		//		" AND substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8) < to_char(sysdate,'YYYYMMdd') \n"+
	//				" and d.che_dt is null "+
//				" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who2+   
				" \n union \n"+
				" SELECT a.m1_chk, a.car_mng_id, b.rent_l_cd, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000006','000013','000037','000013', '000077','000013',b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e, \n"+
				" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id, mng_id2 as mng_id from cont where use_yn = 'Y' and mng_id is not null) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d \n"+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id \n"+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
				" AND ( (a.maint_end_dt < to_char(sysdate,'YYYYMMdd')) or (  a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and a.test_end_dt < to_char(sysdate,'YYYYMMdd')  ) )  \n"+
//				" AND a.maint_end_dt < to_char(sysdate,'YYYYMMdd') \n"+
//				" and d.che_dt is null "+
		//		" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who2+    decode(rm.use_yn , 'N', '', nvl(rm.m1_chk, a.m1_chk ) )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
				" order by 7 ";
*/				
				/* 20100118 변경 만료+30일보다 작은거 전체로 */ 
				query = "SELECT decode(rm.use_yn , 'N', '','X', '', a.m1_chk )  m1_chk, nvl(rm.m1_dt, a.m1_dt ) m1_dt,  a.car_mng_id, b.rent_mng_id,  b.rent_l_cd, b.fee_rent_st, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000005','000013' ,'000006','000013','000037','000013','000035','000013', '000031','000013','000077','000013','000144','000013','000126','000013',  '000026', '000013',   b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e,\n"+
				"   ( select m.* from car_maint_req m , (select car_mng_id, rent_l_cd, max(m1_no)  m1_no from car_maint_req  group by car_mng_id, rent_l_cd ) m1  \n" +
				"     where  m.car_mng_id = m1.car_mng_id and m.rent_l_cd = m1.rent_l_cd and m.m1_no = m1.m1_no  ) rm,   \n" +
		//		" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id,  case when mng_id is null then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else mng_id end mng_id  from cont c, users u  where c.bus_id2 = u.user_id and c.use_yn = 'Y' ) b, "+
				" 	 (select rent_mng_id, rent_l_cd, fee_rent_st, car_mng_id, client_id,  case when   mng_id is null then case when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else  nvl(mng_id2, mng_id)   end mng_id  from cont_n_view c, users u  where c.bus_id2 = u.user_id and nvl(c.use_yn, 'Y') = 'Y'  ) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d "+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id \n"+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
				" and b.car_mng_id = rm.car_mng_id(+)  \n" +
		//		" and b.car_mng_id = rm.car_mng_id(+) and b.rent_l_cd = rm.rent_l_cd(+) \n" +
	//			" AND substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd') \n"+
				" AND ( (substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= to_char(sysdate+30,'yyyymmdd')) or ( a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= to_char(sysdate+30,'yyyymmdd') ) or (  a.car_no like '%허%' and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= to_char(sysdate+30,'yyyymmdd')) )    \n"+
		//		" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who1+
				" \n union \n"+
				"SELECT  decode(rm.use_yn , 'N', '',  'X', '',  a.m1_chk  )  m1_chk,  nvl(rm.m1_dt, a.m1_dt ) m1_dt, a.car_mng_id, b.rent_mng_id, b.rent_l_cd,  b.fee_rent_st, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000005','000013' ,'000006','000013','000037','000013','000035','000013', '000031','000013','000077','000013','000144','000013', '000126','000013', '000026', '000013',   b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e,\n"+
				"   ( select m.* from car_maint_req m , (select car_mng_id, rent_l_cd, max(m1_no)  m1_no from car_maint_req  group by car_mng_id, rent_l_cd ) m1  \n" +
				"     where  m.car_mng_id = m1.car_mng_id and m.rent_l_cd = m1.rent_l_cd and m.m1_no = m1.m1_no ) rm,   \n" +
		//		" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id,  case when mng_id is null then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else mng_id end mng_id  from cont c, users u  where c.bus_id2 = u.user_id and c.use_yn = 'Y' ) b, "+
				" 	 (select rent_mng_id, rent_l_cd, fee_rent_st,  car_mng_id, client_id,  case when   mng_id is null then case when u.dept_id ='0003' then '000013' else bus_id2 end  when  substr(mng_id ,0, 1) = '1' then case when u.dept_id ='0001' then '000013' when u.dept_id ='0003' then '000013' else bus_id2 end else  nvl(mng_id2, mng_id)  end mng_id  from cont_n_view c, users u  where c.bus_id2 = u.user_id and nvl(c.use_yn, 'Y') = 'Y' ) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d "+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id \n"+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
				" and b.car_mng_id = rm.car_mng_id(+) \n" +
		//		" and b.car_mng_id = rm.car_mng_id(+) and b.rent_l_cd = rm.rent_l_cd(+) \n" +
		//		" AND a.maint_end_dt between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd') \n"+
				" AND ( ( a.maint_end_dt <= to_char(sysdate+30,'yyyymmdd')) or (  a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and a.test_end_dt <= to_char(sysdate+30,'yyyymmdd')  ) or (  a.car_no like '%허%' and a.test_end_dt <= to_char(sysdate+30,'yyyymmdd') ) )  \n"+
//				" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who1+	
				/*
				" \n union \n"+                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
				" SELECT a.m1_chk, a.car_mng_id,  b.rent_l_cd, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000006','000013','000037','000013', '000077','000013',b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e,\n"+
				" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id, mng_id2 as mng_id from cont where use_yn = 'Y' and mng_id is not null) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d \n"+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id "+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
				" AND ( (substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= to_char(sysdate+30,'yyyymmdd')) or ( a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= to_char(sysdate+30,'yyyymmdd')) )    \n"+
			//	" AND substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8) between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd') \n"+
			//	" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who2+			
				" \n union \n"+                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
				" SELECT a.m1_chk, a.car_mng_id, b.rent_l_cd, a.car_ext, a.car_use, a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt, decode(b.mng_id, '000003', '000013', '000004','000013','000006','000013','000037','000013', '000077','000013',b.mng_id) mng_id, a.off_ls \n"+
				" FROM car_reg a, client c, sui e,\n"+
				" 	 (select rent_mng_id, rent_l_cd, car_mng_id, client_id, mng_id2 as mng_id from cont where use_yn = 'Y' and mng_id is not null) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d \n"+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id "+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
			//	" AND a.maint_end_dt between to_char(sysdate-30,'yyyymmdd') and to_char(sysdate+30,'yyyymmdd') \n"+
				" AND ( ( a.maint_end_dt  <= to_char(sysdate+30,'yyyymmdd')) or (  a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and a.test_end_dt <= to_char(sysdate+30,'yyyymmdd') ) )  \n"+
			//	" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)\n"+
				who2+ */
				" order by 9, 5 ";  
				
				
				
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getCar_maintList(String user_id)]\n"+e);
			System.out.println("[CusPre_Database:getCar_maintList(String user_id)]\n"+query);
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

  //광주지점폐쇄로 인해 박영규과장인 관리담당자로 배정 - 20131016
	public Vector getCar_maintList(String user_id, String s_kd, String t_wd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String who1 = "";
		String who2 = "";
		
		String sub_q1 = "";
	
		if(!user_id.equals("")){
			who1 = " AND decode(b.mng_id, '000003', '000013', '000004','000013','000005','000013' ,'000006','000013','000037','000013','000035','000013', '000031','000013','000077','000013','000144','000013', '000126','000013', '000026', '000013',   b.mng_id) = '"+user_id+"' ";
			who2 = " AND b.mng_id  = '"+user_id+"' ";
		}else{
			who1 = " and b.mng_id is not null ";
			who2 = " and b.mng_id is not null ";
		}
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			if (s_kd.equals("2")){
				sub_q1 = " AND a.car_no like  '%"+t_wd+"%'";
			} else {
				sub_q1 = " AND nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";
			}	
		}	
						
				/* 20100118 변경 만료+30일보다 작은거 전체로 */ //용도변경이 되는 경우도 있음. 
			query = "SELECT  /*+ rule */  b.RENT_END_DT, decode(b.rent_way_cd, 1,'일반식','3','기본식')as rent_way , decode(rm.use_yn , 'N', '','X', '', a.m1_chk ) m1_chk, nvl(rm.m1_dt, a.m1_dt ) m1_dt,  a.car_mng_id, b.rent_mng_id,  b.rent_l_cd, b.fee_rent_st, a.car_ext, a.car_use, \n"+
			          "   a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt,    \n"+
				" decode(b.mng_id, '000003', '000013', '000004','000013','000005','000013' ,'000006','000013','000037','000013','000035','000013', '000031','000013','000077','000013','000144','000013', '000126','000013', '000026', '000013', b.mng_id) mng_id, a.off_ls, decode(b.car_st, '4', b.car_mng_id, nvl(rrm.car_mng_id, '0'))  rrm  , a.car_nm  \n"+
				" FROM car_reg a, client c, sui e,\n"+
				"   ( select m.* from car_maint_req m , (select car_mng_id, max(m1_no)  m1_no from car_maint_req  group by car_mng_id ) m1     where  m.car_mng_id = m1.car_mng_id and m.m1_no = m1.m1_no  ) rm,   \n" +
				"        ( select car_mng_id  from rent_cont where rent_st = '12' and use_st = '2' ) rrm,    \n" +  //월렌트여부
				" 	 (select rent_mng_id, rent_l_cd, fee_rent_st, car_mng_id, client_id, rent_way_cd, RENT_END_DT, car_st,   decode(c.car_st, '4', mng_id2,  '2', nvl(mng_id, '000013') , nvl(mng_id, bus_id2) ) mng_id  from cont_n_view c, users u  where c.bus_id2 = u.user_id and nvl(c.use_yn, 'Y') = 'Y' ) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d "+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id \n"+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
				" and b.car_mng_id = rm.car_mng_id(+) \n" +
				" and b.car_mng_id = rrm.car_mng_id(+) \n" +		
	//20131218 이후 점검x		
	                   //	" AND ( (substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= to_char(sysdate+30,'yyyymmdd')) or ( a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= to_char(sysdate+30,'yyyymmdd') ) or (  a.car_no like '%허%' and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= to_char(sysdate+30,'yyyymmdd')) )    \n"+
	//20140912 점검제외		
		//		" AND ( (substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= to_char(sysdate+30,'yyyymmdd')) or ( a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= '20131118'  ) or (  a.car_no like '%허%' and substr(a.test_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <=  '20131118') )   \n"+
				" AND  substr(a.maint_end_dt, 0,4) || substr(a.init_reg_dt, 5, 8)  <= to_char(sysdate+30,'yyyymmdd')     \n"+
		//		" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who1+ sub_q1+
				" \n union \n"+
				"SELECT /*+ rule */  b.RENT_END_DT, decode(b.rent_way_cd, 1,'일반식','3','기본식')as rent_way , decode(rm.use_yn , 'N', '', 'X', '',  a.m1_chk  )  m1_chk, nvl(rm.m1_dt, a.m1_dt ) m1_dt, a.car_mng_id, b.rent_mng_id, b.rent_l_cd,  b.fee_rent_st, a.car_ext, a.car_use, \n"+
				"   a.car_kd, a.car_doc_no, e.cont_dt, nvl(c.firm_nm,c.client_nm) firm_nm, a.car_no, a.init_reg_dt, a.maint_st_dt, a.maint_end_dt, d.che_dt,   \n"+
				"  decode(b.mng_id, '000003', '000013', '000004','000013','000005','000013' ,'000006','000013','000037','000013','000035','000013', '000031','000013','000077','000013','000144','000013','000126','000013', '000026', '000013',  b.mng_id) mng_id, a.off_ls,   decode(b.car_st, '4',  b.car_mng_id,  nvl(rrm.car_mng_id, '0')) rrm , a.car_nm   \n"+
				" FROM car_reg a, client c, sui e,\n"+
				"   ( select m.* from car_maint_req m , (select car_mng_id, max(m1_no)  m1_no from car_maint_req  group by car_mng_id ) m1      where  m.car_mng_id = m1.car_mng_id and m.m1_no = m1.m1_no ) rm,   \n" +
				"        ( select car_mng_id  from rent_cont where rent_st = '12' and use_st = '2' ) rrm,    \n" +  //월렌트여부		
				" 	 (select rent_mng_id, rent_l_cd, fee_rent_st,  car_mng_id, client_id, rent_way_cd, RENT_END_DT, car_st,  decode(c.car_st, '4', mng_id2,  '2', nvl(mng_id, '000013') , nvl(mng_id, bus_id2)  ) mng_id  from cont_n_view c, users u  where c.bus_id2 = u.user_id and nvl(c.use_yn, 'Y') = 'Y' ) b, \n"+
				" 	 (select a.car_mng_id, a.che_end_dt, a.che_dt from car_maint a where a.seq_no = (select max(seq_no) from car_maint where car_mng_id=a.car_mng_id)) d "+
				" WHERE nvl(a.prepare,'0') not in ('4','5') and a.car_mng_id = b.car_mng_id \n"+
				" AND b.client_id = c.client_id \n"+
				" AND a.car_mng_id = d.car_mng_id(+) \n"+
				" AND a.car_mng_id = e.car_mng_id(+) \n"+
				" and b.car_mng_id = rm.car_mng_id(+)  \n" +
				" and b.car_mng_id = rrm.car_mng_id(+) \n" +
		
			// 20131218 이후 점검x	
		//	         " AND ( ( a.maint_end_dt <= to_char(sysdate+30,'yyyymmdd')) or (  a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and a.test_end_dt <= to_char(sysdate+30,'yyyymmdd')  ) or (  a.car_no like '%허%' and a.test_end_dt <= to_char(sysdate+30,'yyyymmdd') ) )  \n"+
		//20140912 점검제외			
			//	" AND ( ( a.maint_end_dt <= to_char(sysdate+30,'yyyymmdd')) or (  a.car_no like '%허%' and to_char(add_months(to_date(a.init_reg_dt), 48), 'yyyymmdd')  <= to_char(sysdate,'YYYYMMdd') and a.test_end_dt <='20131118'  ) or (  a.car_no like '%허%' and a.test_end_dt <='20131118' ) )  \n"+
				" AND   a.maint_end_dt <= to_char(sysdate+30,'yyyymmdd')  \n"+
//				" and a.maint_end_dt=d.che_end_dt(+) and d.che_dt is null \n"+
				" and a.maint_end_dt=d.che_end_dt(+)  \n"+
				who1 + sub_q1+	
				" order by 9, 5 ";  

				
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getCar_maintList(String user_id, String s_kd, String t_wd)]\n"+e);
			System.out.println("[CusPre_Database:getCar_maintList(String user_id, String s_kd, String t_wd)]\n"+query);
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
    
    
	/*
	*	고객 정비요청 미실시건 D-7일 예정 2004.08.16. - 예비 배정 추가
	*/
	public Vector getCust_IresList(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT a.rent_mng_id, a.rent_l_cd, a.ires_id, nvl(c.firm_nm,c.client_nm) firm_nm, a.ires_nm, d.car_no, a.ser_hope_dt, a.ires_title, b.mng_id, a.pr_yn "+
				" FROM ires a, cont b, client c, car_reg d "+
				" WHERE a.rent_mng_id = b.rent_mng_id "+
				" AND a.rent_l_cd = b.rent_l_cd "+
				" AND a.client_id = c.client_id "+
				" AND a.car_mng_id = d.car_mng_id "+
				//" AND a.pr_yn = 'N' "+
				" AND a.ser_hope_dt between to_char(sysdate-7,'yyyymmdd') and to_char(sysdate,'yyyymmdd') "+
				" AND b.mng_id = ?" +
				" union "+  //예비배정
				"SELECT a.rent_mng_id, a.rent_l_cd, a.ires_id, nvl(c.firm_nm,c.client_nm) firm_nm, a.ires_nm, d.car_no, a.ser_hope_dt, a.ires_title, b.mng_id2 as mng_id, a.pr_yn "+
				" FROM ires a, cont b, client c, car_reg d "+
				" WHERE a.rent_mng_id = b.rent_mng_id "+
				" AND a.rent_l_cd = b.rent_l_cd "+
				" AND a.client_id = c.client_id "+
				" AND a.car_mng_id = d.car_mng_id "+
				//" AND a.pr_yn = 'N' "+
				" AND a.ser_hope_dt between to_char(sysdate-7,'yyyymmdd') and to_char(sysdate,'yyyymmdd') "+
				" AND b.mng_id = ?";

		try 
		{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);
			pstmt.setString(2, user_id);
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
			System.out.println("[CusPre_Database:getCust_IresList(String user_id)]\n"+e);
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
	*	업무현황(전체) - 당일 2004.09.02.
	*/
	public Vector getCusPreAll_day(){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "SELECT s.checker, vac, vec, vc, sac, sec, sc "+
						" FROM (SELECT b.checker, nvl(a.sd_all_cnt,0) sac, nvl(a.sd_est_cnt,0) sec, nvl(b.sd_cnt,0) sc  "+
						"  FROM (select nvl(a.mng_id,'999999') mng_id,   "+
						"  			nvl(sum(decode(b.next_serv_dt,to_char(sysdate,'yyyymmdd'),1,0)),0) sd_all_cnt,   "+
						"  			nvl(sum(decode(b.serv_dt,'',decode(b.next_serv_dt,to_char(sysdate,'yyyymmdd'),1,0),0)),0) sd_est_cnt   "+
						" 		from cont a, service b   "+
						" 		where a.car_mng_id = b.car_mng_id   "+
						" 		  and a.use_yn = 'Y'    "+
						" 		group by a.mng_id) a,  "+
						" 	  (SELECT checker, nvl(sum(decode(serv_dt,to_char(sysdate,'yyyymmdd'),1,0)),0) sd_cnt FROM service GROUP BY checker ) b  "+
						"  WHERE a.mng_id = b.checker(+)  "+
						" ) s, "+
						" (SELECT a.mng_id, nvl(a.vd_all_cnt,0) vac, nvl(a.vd_est_cnt,0) vec, nvl(b.vd_cnt,0) vc  "+
						"  FROM (select a.mng_id,  "+
						" 			nvl(sum(decode(b.vst_est_dt,to_char(sysdate,'yyyymmdd'),1,0)),0) vd_all_cnt,  "+
						" 			nvl(sum(decode(b.vst_dt,'',decode(b.vst_est_dt,to_char(sysdate,'yyyymmdd'),1,0),0)),0) vd_est_cnt  "+
						" 		from (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') a, cycle_vst b  "+
						" 		where a.client_id = b.client_id  "+
						" 		group by a.mng_id) a,  "+
						" 	  ( select visiter, nvl(sum(decode(vst_dt,to_char(sysdate,'yyyymmdd'),1,0)),0) vd_cnt from cycle_vst  group by visiter ) b "+
						"  WHERE a.mng_id = b.visiter(+) "+
						" ) v "+
						" WHERE s.checker=v.mng_id "+
						"   AND s.checker != '000006' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
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

		}catch(Exception e){
			System.out.println("[CusPre_Database:getCusPreAll_day()]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}

	/**
	*	업무현황(전체) - 당월 2004.09.06.
	*/
	public Vector getCusPreAll_month(){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "SELECT s.checker, vac, vec, vc, sac, sec, sc, cs1, cs2, cs3 "+
						" FROM (SELECT b.checker, nvl(a.sd_all_cnt,0) sac, nvl(a.sd_est_cnt,0) sec, nvl(b.sd_cnt,0) sc  "+
						"  FROM (select nvl(a.mng_id,'999999') mng_id,   "+
						"  			nvl(sum(decode(substr(b.next_serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) sd_all_cnt,   "+
						"  			nvl(sum(decode(b.serv_dt,'',decode(substr(b.next_serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0),0)),0) sd_est_cnt   "+
						" 		from cont a, service b   "+
						" 		where a.car_mng_id = b.car_mng_id   "+
						" 		  and a.use_yn = 'Y'    "+
						" 		group by a.mng_id) a,  "+
						" 	  (SELECT checker, nvl(sum(decode(substr(serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) sd_cnt FROM service GROUP BY checker ) b  "+
						"  WHERE a.mng_id = b.checker(+)  "+
						" ) s, "+
						" (SELECT a.mng_id, nvl(a.vd_all_cnt,0) vac, nvl(a.vd_est_cnt,0) vec, nvl(b.vd_cnt,0) vc  "+
						"  FROM (select a.mng_id,  "+
						" 			nvl(sum(decode(substr(b.vst_est_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) vd_all_cnt,  "+
						" 			nvl(sum(decode(b.vst_dt,'',decode(substr(b.vst_est_dt,1,6),to_char(sysdate,'yyyymm'),1,0),0)),0) vd_est_cnt  "+
						" 		from (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') a, cycle_vst b  "+
						" 		where a.client_id = b.client_id  "+
						" 		group by a.mng_id) a,  "+
						" 	  ( select visiter, nvl(sum(decode(substr(vst_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) vd_cnt from cycle_vst  group by visiter ) b "+
						"  WHERE a.mng_id = b.visiter(+) "+
						" ) v, "+
						"(SELECT checker, nvl(sum(decode(checker_st,'1',decode(substr(serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0),1,0)),0) cs1, "+
						"	  nvl(sum(decode(checker_st,'2',decode(substr(serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0),1,0)),0) cs2, "+
						"	  nvl(sum(decode(checker_st,'3',decode(substr(serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0),1,0)),0) cs3 "+
						"  FROM service "+
						"  GROUP BY checker "+
						" ) cs "+
						" WHERE s.checker = v.mng_id "+
						"   AND s.checker = cs.checker "+
						"   AND s.checker != '000006' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
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

		}catch(Exception e){
			System.out.println("[CusPre_Database:getCusPreAll_month()]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}

	/**
	*	업무현황(전체) - 당해 2004.09.06.
	*/
	public Vector getCusPreAll_year(){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "SELECT s.checker, vac, vec, vc, sac, sec, sc "+
						" FROM (SELECT b.checker, nvl(a.sd_all_cnt,0) sac, nvl(a.sd_est_cnt,0) sec, nvl(b.sd_cnt,0) sc  "+
						"  FROM (select nvl(a.mng_id,'999999') mng_id,   "+
						"  			nvl(sum(decode(substr(b.next_serv_dt,1,4),to_char(sysdate,'yyyy'),1,0)),0) sd_all_cnt,   "+
						"  			nvl(sum(decode(b.serv_dt,'',decode(substr(b.next_serv_dt,1,4),to_char(sysdate,'yyyy'),1,0),0)),0) sd_est_cnt   "+
						" 		from cont a, service b   "+
						" 		where a.car_mng_id = b.car_mng_id   "+
						" 		  and a.use_yn = 'Y'    "+
						" 		group by a.mng_id) a,  "+
						" 	  (SELECT checker, nvl(sum(decode(substr(serv_dt,1,4),to_char(sysdate,'yyyy'),1,0)),0) sd_cnt FROM service GROUP BY checker ) b  "+
						"  WHERE a.mng_id = b.checker(+)  "+
						" ) s, "+
						" (SELECT a.mng_id, nvl(a.vd_all_cnt,0) vac, nvl(a.vd_est_cnt,0) vec, nvl(b.vd_cnt,0) vc  "+
						"  FROM (select a.mng_id,  "+
						" 			nvl(sum(decode(substr(b.vst_est_dt,1,4),to_char(sysdate,'yyyy'),1,0)),0) vd_all_cnt,  "+
						" 			nvl(sum(decode(b.vst_dt,'',decode(substr(b.vst_est_dt,1,4),to_char(sysdate,'yyyy'),1,0),0)),0) vd_est_cnt  "+
						" 		from (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') a, cycle_vst b  "+
						" 		where a.client_id = b.client_id  "+
						" 		group by a.mng_id) a,  "+
						" 	  ( select visiter, nvl(sum(decode(substr(vst_dt,1,4),to_char(sysdate,'yyyy'),1,0)),0) vd_cnt from cycle_vst  group by visiter ) b "+
						"  WHERE a.mng_id = b.visiter(+) "+
						" ) v "+
						" WHERE s.checker=v.mng_id "+
						"   AND s.checker != '000006' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
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

		}catch(Exception e){
			System.out.println("[CusPre_Database:getCusPreAll_day()]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}

	/**
	*	년도별 현황(순회방문) - 2004.09.17.
	*/
	public int[] getTg_year_vst(String year){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] tg = new int[12];
		String query = "select nvl(sum(decode(substr(vst_dt,5,2),'01',1,0)),0) s01, "+
					"	    nvl(sum(decode(substr(vst_dt,5,2),'02',1,0)),0) s02, "+
					"	    nvl(sum(decode(substr(vst_dt,5,2),'03',1,0)),0) s03, "+
					"		nvl(sum(decode(substr(vst_dt,5,2),'04',1,0)),0) s04, "+
					"		nvl(sum(decode(substr(vst_dt,5,2),'05',1,0)),0) s05, "+
					"		nvl(sum(decode(substr(vst_dt,5,2),'06',1,0)),0) s06, "+
					"		nvl(sum(decode(substr(vst_dt,5,2),'07',1,0)),0) s07, "+
					"		nvl(sum(decode(substr(vst_dt,5,2),'08',1,0)),0) s08, "+
					"		nvl(sum(decode(substr(vst_dt,5,2),'09',1,0)),0) s09, "+
					"		nvl(sum(decode(substr(vst_dt,5,2),'10',1,0)),0) s010, "+
					"		nvl(sum(decode(substr(vst_dt,5,2),'11',1,0)),0) s011, "+
					"		nvl(sum(decode(substr(vst_dt,5,2),'12',1,0)),0) s012 "+  	   
					" from cycle_vst "+
					" where vst_dt like '"+year+"%' ";

		try{
			pstmt = conn.prepareStatement(query);			
			rs = pstmt.executeQuery();
			while(rs.next()){
				tg[0] = rs.getInt(1);
				tg[1] = rs.getInt(2);
				tg[2] = rs.getInt(3);
				tg[3] = rs.getInt(4);
				tg[4] = rs.getInt(5);
				tg[5] = rs.getInt(6);
				tg[6] = rs.getInt(7);
				tg[7] = rs.getInt(8);
				tg[8] = rs.getInt(9);
				tg[9] = rs.getInt(10);
				tg[10] = rs.getInt(11);
				tg[11] = rs.getInt(12);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_year_vst(String year)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return tg;
		}
	}

	/**
	*	년도별 현황(자동차정비,순회점검) - 2004.09.18.
	*/
	public int[] getTg_year_serv1(String year){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] tg = new int[12];
		String query = "select nvl(sum(decode(substr(serv_dt,5,2),'01',1,0)),0) s1,  "+
						"	   nvl(sum(decode(substr(serv_dt,5,2),'02',1,0)),0) s2,  "+
						"	   nvl(sum(decode(substr(serv_dt,5,2),'03',1,0)),0) s3,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'04',1,0)),0) s4,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'05',1,0)),0) s5,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'06',1,0)),0) s6,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'07',1,0)),0) s7,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'08',1,0)),0) s8,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'09',1,0)),0) s9,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'10',1,0)),0) s10,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'11',1,0)),0) s11,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'12',1,0)),0) s12  	    "+
						" from service  "+
						" where serv_dt like '"+year+"%' "+
						" group by serv_st "+
						" having serv_st ='1' "+
						" order by serv_st ";


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				tg[0] = rs.getInt(1);
				tg[1] = rs.getInt(2);
				tg[2] = rs.getInt(3);
				tg[3] = rs.getInt(4);
				tg[4] = rs.getInt(5);
				tg[5] = rs.getInt(6);
				tg[6] = rs.getInt(7);
				tg[7] = rs.getInt(8);
				tg[8] = rs.getInt(9);
				tg[9] = rs.getInt(10);
				tg[10] = rs.getInt(11);
				tg[11] = rs.getInt(12);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_year_serv1(String year)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return tg;
		}
	}

	/**
	*	년도별 현황(자동차정비,일반정비) - 2004.09.18.
	*/
	public int[] getTg_year_serv2(String year){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] tg = new int[12];
		String query = "select nvl(sum(decode(substr(serv_dt,5,2),'01',1,0)),0) s1,   "+
						"	   nvl(sum(decode(substr(serv_dt,5,2),'02',1,0)),0) s2,   "+
						"	   nvl(sum(decode(substr(serv_dt,5,2),'03',1,0)),0) s3,   "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'04',1,0)),0) s4,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'05',1,0)),0) s5,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'06',1,0)),0) s6,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'07',1,0)),0) s7,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'08',1,0)),0) s8,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'09',1,0)),0) s9,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'10',1,0)),0) s10, "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'11',1,0)),0) s11, "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'12',1,0)),0) s12  "+
						" from service  "+
						" where serv_dt like '"+year+"%' "+
						" group by serv_st "+
						" having serv_st ='2' "+
						" order by serv_st ";


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				tg[0] = rs.getInt(1);
				tg[1] = rs.getInt(2);
				tg[2] = rs.getInt(3);
				tg[3] = rs.getInt(4);
				tg[4] = rs.getInt(5);
				tg[5] = rs.getInt(6);
				tg[6] = rs.getInt(7);
				tg[7] = rs.getInt(8);
				tg[8] = rs.getInt(9);
				tg[9] = rs.getInt(10);
				tg[10] = rs.getInt(11);
				tg[11] = rs.getInt(12);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_year_serv2(String year)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return tg;
		}
	}

	/**
	*	년도별 현황(자동차정비,보증수리) - 2004.09.18.
	*/
	public int[] getTg_year_serv3(String year){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] tg = new int[12];
		String query = "select nvl(sum(decode(substr(serv_dt,5,2),'01',1,0)),0) s1,  "+
						"	   nvl(sum(decode(substr(serv_dt,5,2),'02',1,0)),0) s2,  "+
						"	   nvl(sum(decode(substr(serv_dt,5,2),'03',1,0)),0) s3,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'04',1,0)),0) s4,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'05',1,0)),0) s5,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'06',1,0)),0) s6,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'07',1,0)),0) s7,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'08',1,0)),0) s8,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'09',1,0)),0) s9,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'10',1,0)),0) s10,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'11',1,0)),0) s11,  "+
						"		nvl(sum(decode(substr(serv_dt,5,2),'12',1,0)),0) s12  	    "+
						" from service  "+
						" where serv_dt like '"+year+"%' "+
						" group by serv_st "+
						" having serv_st ='3' "+
						" order by serv_st ";


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				tg[0] = rs.getInt(1);
				tg[1] = rs.getInt(2);
				tg[2] = rs.getInt(3);
				tg[3] = rs.getInt(4);
				tg[4] = rs.getInt(5);
				tg[5] = rs.getInt(6);
				tg[6] = rs.getInt(7);
				tg[7] = rs.getInt(8);
				tg[8] = rs.getInt(9);
				tg[9] = rs.getInt(10);
				tg[10] = rs.getInt(11);
				tg[11] = rs.getInt(12);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_year_serv3(String year)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return tg;
		}
	}

	/**
	*	년도별 현황(자동차검사_정기) - 2004.09.18.
	*/
	public int[] getTg_year_maint(String year){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] tg = new int[12];
		String query = "select nvl(sum(decode(substr(che_dt,5,2),'01',1,0)),0) s1,  "+
						"	   nvl(sum(decode(substr(che_dt,5,2),'02',1,0)),0) s2,  "+
						"	   nvl(sum(decode(substr(che_dt,5,2),'03',1,0)),0) s3,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'04',1,0)),0) s4,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'05',1,0)),0) s5,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'06',1,0)),0) s6,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'07',1,0)),0) s7,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'08',1,0)),0) s8,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'09',1,0)),0) s9,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'10',1,0)),0) s10,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'11',1,0)),0) s11,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'12',1,0)),0) s12  	    "+
						" from car_maint  "+
						" where che_dt like '"+year+"%' and che_kd='1' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				tg[0] = rs.getInt(1);
				tg[1] = rs.getInt(2);
				tg[2] = rs.getInt(3);
				tg[3] = rs.getInt(4);
				tg[4] = rs.getInt(5);
				tg[5] = rs.getInt(6);
				tg[6] = rs.getInt(7);
				tg[7] = rs.getInt(8);
				tg[8] = rs.getInt(9);
				tg[9] = rs.getInt(10);
				tg[10] = rs.getInt(11);
				tg[11] = rs.getInt(12);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_year_maint(String year)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return tg;
		}
	}

	/**
	*	년도별 현황(자동차검사_정밀) - 2004.09.18.
	*/
	public int[] getTg_year_maint2(String year){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] tg = new int[12];
		String query = "select nvl(sum(decode(substr(che_dt,5,2),'01',1,0)),0) s1,  "+
						"	   nvl(sum(decode(substr(che_dt,5,2),'02',1,0)),0) s2,  "+
						"	   nvl(sum(decode(substr(che_dt,5,2),'03',1,0)),0) s3,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'04',1,0)),0) s4,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'05',1,0)),0) s5,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'06',1,0)),0) s6,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'07',1,0)),0) s7,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'08',1,0)),0) s8,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'09',1,0)),0) s9,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'10',1,0)),0) s10,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'11',1,0)),0) s11,  "+
						"		nvl(sum(decode(substr(che_dt,5,2),'12',1,0)),0) s12  	    "+
						" from car_maint  "+
						" where che_dt like '"+year+"%' and che_kd='2' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				tg[0] = rs.getInt(1);
				tg[1] = rs.getInt(2);
				tg[2] = rs.getInt(3);
				tg[3] = rs.getInt(4);
				tg[4] = rs.getInt(5);
				tg[5] = rs.getInt(6);
				tg[6] = rs.getInt(7);
				tg[7] = rs.getInt(8);
				tg[8] = rs.getInt(9);
				tg[9] = rs.getInt(10);
				tg[10] = rs.getInt(11);
				tg[11] = rs.getInt(12);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_year_maint2(String year)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return tg;
		}
	}

	/**
	*	년도별 현황(고객요청) - 2004.09.18.
	*/
	public int[] getTg_year_ires(String year){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] tg = new int[12];
		String query = "select nvl(sum(decode(substr(reg_dt,5,2),'01',1,0)),0) s1,  "+
						"	   nvl(sum(decode(substr(reg_dt,5,2),'02',1,0)),0) s2,  "+
						"	   nvl(sum(decode(substr(reg_dt,5,2),'03',1,0)),0) s3,  "+
						"		nvl(sum(decode(substr(reg_dt,5,2),'04',1,0)),0) s4,  "+
						"		nvl(sum(decode(substr(reg_dt,5,2),'05',1,0)),0) s5,  "+
						"		nvl(sum(decode(substr(reg_dt,5,2),'06',1,0)),0) s6,  "+
						"		nvl(sum(decode(substr(reg_dt,5,2),'07',1,0)),0) s7,  "+
						"		nvl(sum(decode(substr(reg_dt,5,2),'08',1,0)),0) s8,  "+
						"		nvl(sum(decode(substr(reg_dt,5,2),'09',1,0)),0) s9,  "+
						"		nvl(sum(decode(substr(reg_dt,5,2),'10',1,0)),0) s10,  "+
						"		nvl(sum(decode(substr(reg_dt,5,2),'11',1,0)),0) s11,  "+
						"		nvl(sum(decode(substr(reg_dt,5,2),'12',1,0)),0) s12  	    "+
						" from ires  "+
						" where reg_dt like '"+year+"%' ";

		try{
			pstmt = conn.prepareStatement(query);			
			rs = pstmt.executeQuery();
			while(rs.next()){
				tg[0] = rs.getInt(1);
				tg[1] = rs.getInt(2);
				tg[2] = rs.getInt(3);
				tg[3] = rs.getInt(4);
				tg[4] = rs.getInt(5);
				tg[5] = rs.getInt(6);
				tg[6] = rs.getInt(7);
				tg[7] = rs.getInt(8);
				tg[8] = rs.getInt(9);
				tg[9] = rs.getInt(10);
				tg[10] = rs.getInt(11);
				tg[11] = rs.getInt(12);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_year_ires(String year)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return tg;
		}
	}

	/**
	*	년도별 현황(배차) - 2004.10.1.
	*/
	public int[] getTg_year_deli(String year){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] tg = new int[12];
		String query = "select nvl(sum(decode(substr(deli_dt,5,2),'01',1,0)),0) s01, "+
						"	   nvl(sum(decode(substr(deli_dt,5,2),'02',1,0)),0) s02,  "+
						"	   nvl(sum(decode(substr(deli_dt,5,2),'03',1,0)),0) s03,  "+
						"		nvl(sum(decode(substr(deli_dt,5,2),'04',1,0)),0) s04,  "+
						"		nvl(sum(decode(substr(deli_dt,5,2),'05',1,0)),0) s05,  "+
						"		nvl(sum(decode(substr(deli_dt,5,2),'06',1,0)),0) s06,  "+
						"		nvl(sum(decode(substr(deli_dt,5,2),'07',1,0)),0) s07,  "+
						"		nvl(sum(decode(substr(deli_dt,5,2),'08',1,0)),0) s08,  "+
						"		nvl(sum(decode(substr(deli_dt,5,2),'09',1,0)),0) s09,  "+
						"		nvl(sum(decode(substr(deli_dt,5,2),'10',1,0)),0) s010,  "+
						"		nvl(sum(decode(substr(deli_dt,5,2),'11',1,0)),0) s011,  "+
						"		nvl(sum(decode(substr(deli_dt,5,2),'12',1,0)),0) s012    "+	   
						" from rent_cont "+
						" where deli_dt like '"+year+"' "+
						" and rent_st in ('1','2','3','6','7','9','10') "+
						" and use_st <> '5' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				tg[0] = rs.getInt(1);
				tg[1] = rs.getInt(2);
				tg[2] = rs.getInt(3);
				tg[3] = rs.getInt(4);
				tg[4] = rs.getInt(5);
				tg[5] = rs.getInt(6);
				tg[6] = rs.getInt(7);
				tg[7] = rs.getInt(8);
				tg[8] = rs.getInt(9);
				tg[9] = rs.getInt(10);
				tg[10] = rs.getInt(11);
				tg[11] = rs.getInt(12);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_year_deli(String year)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return tg;
		}
	}

	/**
	*	년도별 현황(반차) - 2004.10.1.
	*/
	public int[] getTg_year_ret(String year){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] tg = new int[12];
		String query = "select nvl(sum(decode(substr(ret_dt,5,2),'01',1,0)),0) s01, "+
						"	   nvl(sum(decode(substr(ret_dt,5,2),'02',1,0)),0) s02,  "+
						"	   nvl(sum(decode(substr(ret_dt,5,2),'03',1,0)),0) s03,  "+
						"		nvl(sum(decode(substr(ret_dt,5,2),'04',1,0)),0) s04,  "+
						"		nvl(sum(decode(substr(ret_dt,5,2),'05',1,0)),0) s05,  "+
						"		nvl(sum(decode(substr(ret_dt,5,2),'06',1,0)),0) s06,  "+
						"		nvl(sum(decode(substr(ret_dt,5,2),'07',1,0)),0) s07,  "+
						"		nvl(sum(decode(substr(ret_dt,5,2),'08',1,0)),0) s08,  "+
						"		nvl(sum(decode(substr(ret_dt,5,2),'09',1,0)),0) s09,  "+
						"		nvl(sum(decode(substr(ret_dt,5,2),'10',1,0)),0) s010,  "+
						"		nvl(sum(decode(substr(ret_dt,5,2),'11',1,0)),0) s011,  "+
						"		nvl(sum(decode(substr(ret_dt,5,2),'12',1,0)),0) s012 "+
						" from rent_cont "+
						" where ret_dt like '"+year+"%' "+
						" and rent_st in ('1','2','3','6','7','9','10') "+
						" and use_st <> '5' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				tg[0] = rs.getInt(1);
				tg[1] = rs.getInt(2);
				tg[2] = rs.getInt(3);
				tg[3] = rs.getInt(4);
				tg[4] = rs.getInt(5);
				tg[5] = rs.getInt(6);
				tg[6] = rs.getInt(7);
				tg[7] = rs.getInt(8);
				tg[8] = rs.getInt(9);
				tg[9] = rs.getInt(10);
				tg[10] = rs.getInt(11);
				tg[11] = rs.getInt(12);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_year_ret(String year)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return tg;
		}
	}

	/**
	*	거래처와자동차 단독,공동관리 및 자동차(렌트,리스,일반식,기본식,맞춤식)관리 현황 조회 20040922.
	*/
	public int[] getTg_md(String cmd){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] st = new int[10];
		String subQuery = "", subQuery1 = "", subQuery2="";
		if(cmd.equals("m")){
			subQuery  = " and a.rent_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery1 = " and rent_start_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery2 = " and rent_end_dt like to_char(sysdate,'yyyymm')||'%' ";
		}else if(cmd.equals("d")){
			subQuery  = " and a.rent_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery1 = " and rent_start_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery2 = " and rent_end_dt like to_char(sysdate,'yyyymmdd')||'%' ";
		}

		String query = "select nvl(a.cnt,0), nvl(b.cnt,0), nvl(c.cnt,0), nvl(d.cnt,0), nvl(e.grc,0), nvl(e.bmrc,0), nvl(e.glc,0), nvl(e.bmlc,0), nvl(f.cnt,0) rsc, nvl(g.cnt,0) rec "+
						" from (select  count(0) cnt "+
						"		from (select a.bus_id2, count(0) cnt   "+
						" 				from cont a   "+
						" 				where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2)  "+
						" 			group by a.bus_id2, client_id ) "+
						"		) a, "+
						"	    (select count(0) cnt "+
						"		 from ( select client_id,count(0) cnt from cont a  "+
						"	             where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id "+
						"	   			group by client_id) "+
						"		)b, "+
						"	 (select  count(0) cnt   "+
						"	  from cont a, fee b   "+
						"	   where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1'   "+
						"	   	and a.client_id not in ('000231', '000228') and b.rent_way='1' "+
						"	 	and a.mng_id=nvl(a.mng_id2,a.mng_id) and a.car_mng_id is not null  "+
						"	 )c,   "+
						"	 (select  count(0) cnt   "+
						"	  from cont a, fee b   "+
						"	   where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1'   "+
						"	   	and a.client_id not in ('000231', '000228') and b.rent_way='1'   "+
						"		and a.mng_id=a.mng_id2 and a.car_mng_id is not null  "+
						"	)d,   "+
						"	(select a.grc, a.glc, b.bmrc, b.bmlc  "+
						"	 from  "+
						"		(select nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'1',1,0),0)),0) grc,  "+
						"				nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'1',1,0),0)),0) glc  "+
						" 		from cont a, fee b  "+
						" 		 where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y'  "+   
						" 		and b.rent_st='1' and a.client_id not in ('000231', '000228')     "+
						" 		and a.mng_id = nvl(a.mng_id2, a.mng_id)  "+
						" 		and a.car_mng_id is not null  "+
						"		) a,	  "+
						"		(select nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'2',1,0),0)),0)+nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'3',1,0),0)),0) bmrc,  "+
						" 				nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'2',1,0),0)),0)+nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'3',1,0),0)),0) bmlc  "+
						" 		from cont a, fee b  "+
						" 		where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y'  "+
						" 		and b.rent_st='1' and a.client_id not in ('000231', '000228')  "+
						" 		and a.car_mng_id is not null  "+
						"		) b  "+ 
						"	 )e, "+
						"	(select count(0) cnt from cont where use_yn = 'Y' "+subQuery1+" ) f, "+
						"   (select count(0) cnt from cont where use_yn = 'Y' "+subQuery2+" ) g ";
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				st[0] = rs.getInt(1);
				st[1] = rs.getInt(2);
				st[2] = rs.getInt(3);
				st[3] = rs.getInt(4);
				st[4] = rs.getInt(5);
				st[5] = rs.getInt(6);
				st[6] = rs.getInt(7);
				st[7] = rs.getInt(8);
				st[8] = rs.getInt(9);
				st[9] = rs.getInt(10);
			}
			rs.close();
			pstmt.close();

		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_md(String cmd)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return st;
		}
	}

	/**
	*	거래처와자동차 업무진행 현황 조회 20040922.
	* 20041009 수정
	*/
	public int[] getTg_md_pre(String cmd){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] st = new int[6];
		String subQuery1="", subQuery11="", subQuery2 = "",subQuery22="";
		if(cmd.equals("m")){
			subQuery1 	= " substr(b.next_serv_dt,1,6),to_char(sysdate,'yyyymm') ";
			subQuery11 	= " b.serv_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery2 	= " substr(b.vst_est_dt,1,6),to_char(sysdate,'yyyymm') ";
			subQuery22 	= " b.vst_dt like to_char(sysdate,'yyyymm')||'%' ";
		}else if(cmd.equals("d")){
			subQuery1 	= " substr(b.next_serv_dt,1,8),to_char(sysdate,'yyyymmdd') ";
			subQuery11 	= " b.serv_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery2 	= " substr(b.vst_est_dt,1,8),to_char(sysdate,'yyyymmdd') ";
			subQuery22	= " b.vst_dt like to_char(sysdate,'yyyymmdd')||'%' ";
		}

		String query = "SELECT  a.vac, a.vec, a.vc, b.sac, b.sec, b.sc "+
						" FROM (SELECT nvl(sum(a.cnt),0) vac, nvl(sum(b.v_est_cnt),0) vec, nvl(sum(c.v_cnt),0) vc "+
						"		 FROM (select a.user_id, a.cnt+b.cnt cnt  "+
						"				from (select nvl(a.bus_id2,'999999') as user_id, nvl(count(0),0) cnt "+
						"				 from (select a.bus_id2, a.client_id, count(0) cnt    "+
						"				 	 from cont a    "+
						"				 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')    "+
						"			 	 	  and a.bus_id2=nvl(a.mng_id,a.bus_id2)    "+
						"				 	group by a.bus_id2, a.client_id, a.r_site) a    "+
						"				 group by bus_id2 ) a, 	 "+
						"				( select nvl(a.mng_id,'999999') as user_id, nvl(count(0),0) cnt "+
						"				 from (select a.mng_id, a.client_id, count(0) cnt   "+
						"				 	 from cont a   "+
						"				 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')   "+
						"				 	 	   and a.bus_id2<>a.mng_id   "+
						"				 	group by a.mng_id, a.client_id, a.r_site) a   "+
						"				 group by mng_id ) b 		 "+
						"				where a.user_id=b.user_id(+) ) a, 	 "+
						"  		 (select a.mng_id MNG_ID, nvl(sum(decode("+subQuery2+",1,0)),0) V_EST_CNT "+
						"			from (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') a, cycle_vst b     "+
						"			where a.client_id = b.client_id   "+
						"			group by a.mng_id) b,    		 "+
						"		  ( select visiter, nvl(count(0),0) V_CNT from cycle_vst b where "+subQuery22+"  group by visiter ) c "+
						"		  ,users d "+
						"	 WHERE d.user_id = a.user_id(+) and d.user_id= b.mng_id(+) and d.user_id = c.visiter(+) "+
						"	 AND d.user_id not in ('000006','000002','000001') AND d.dept_id='0002' "+
						"	) a,   "+
						"	  (SELECT nvl(sum(a.sac),0) sac, nvl(sum(b.sec),0) sec, nvl(sum(c.s_cnt),0) sc "+
						"		FROM (select nvl(mng_id,'999999') mng_id, nvl(count(0),0) sac from cont where use_yn = 'Y' and car_mng_id is not null group by mng_id) a, 	 "+
						"			 (select nvl(mng_id,'999999') mng_id, nvl(sum(decode("+subQuery1+",1,0)),0) sec "+
						"				from cont a, service b  "+
						"				where a.car_mng_id = b.car_mng_id and a.use_yn = 'Y'  "+
						"				group by mng_id) b,     "+
						"			 (SELECT checker, nvl(count(0),0) S_CNT FROM service b where "+subQuery11+" GROUP BY checker ) c "+
						"            ,users d                  	 "+
						"              WHERE d.user_id=a.mng_id(+) and d.user_id = b.mng_id(+) and d.user_id = c.checker(+) "+
						"              AND d.user_id not in ('000006','000002','000001') AND d.dept_id='0002' "+
						"	) b ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				st[0] = rs.getInt(1);
				st[1] = rs.getInt(2);
				st[2] = rs.getInt(3);
				st[3] = rs.getInt(4);
				st[4] = rs.getInt(5);
				st[5] = rs.getInt(6);
			}
			rs.close();
			pstmt.close();

		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_md_pre(String cmd)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return st;
		}
	}

	public int[] getTg_md_pre2(String cmd, String dept_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] st = new int[6];
		String subQuery1="", subQuery11="", subQuery2 = "",subQuery22="";
		if(cmd.equals("m")){
			subQuery1  = " substr(b.next_serv_dt,1,6),to_char(sysdate,'yyyymm') ";
			subQuery11 = " b.serv_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery2  = " substr(b.vst_est_dt,1,6),to_char(sysdate,'yyyymm') ";
			subQuery22 = " b.vst_dt like to_char(sysdate,'yyyymm')||'%' ";
		}else if(cmd.equals("d")){
			subQuery1  = " substr(b.next_serv_dt,1,8),to_char(sysdate,'yyyymmdd') ";
			subQuery11 = " b.serv_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery2  = " substr(b.vst_est_dt,1,8),to_char(sysdate,'yyyymmdd') ";
			subQuery22 = " b.vst_dt like to_char(sysdate,'yyyymmdd')||'%' ";
		}

		String query = "SELECT  a.vac, a.vec, a.vc, b.sac, b.sec, b.sc "+
						" FROM (SELECT nvl(sum(a.cnt),0) vac, nvl(sum(b.v_est_cnt),0) vec, nvl(sum(c.v_cnt),0) vc "+
						"		 FROM (select a.user_id, a.cnt+b.cnt cnt  "+
						"				from (select nvl(a.bus_id2,'999999') as user_id, nvl(count(0),0) cnt "+
						"				 from (select a.bus_id2, a.client_id, count(0) cnt    "+
						"				 	 from cont a    "+
						"				 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')    "+
						"			 	 	  and a.bus_id2=nvl(a.mng_id,a.bus_id2)    "+
						"				 	group by a.bus_id2, a.client_id, a.r_site) a    "+
						"				 group by bus_id2 ) a, 	 "+
						"				( select nvl(a.mng_id,'999999') as user_id, nvl(count(0),0) cnt "+
						"				 from (select a.mng_id, a.client_id, count(0) cnt   "+
						"				 	 from cont a   "+
						"				 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')   "+
						"				 	 	   and a.bus_id2<>a.mng_id   "+
						"				 	group by a.mng_id, a.client_id, a.r_site) a   "+
						"				 group by mng_id ) b 		 "+
						"				where a.user_id=b.user_id(+) ) a, 	 "+
						"  		 (select a.mng_id MNG_ID, nvl(sum(decode("+subQuery2+",1,0)),0) V_EST_CNT "+
						"			from (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') a, cycle_vst b     "+
						"			where a.client_id = b.client_id   "+
						"			group by a.mng_id) b,    		 "+
						"		  ( select visiter, nvl(count(0),0) V_CNT from cycle_vst b where "+subQuery22+"  group by visiter ) c "+
						"		  ,users d "+
						"	 WHERE d.user_id = a.user_id(+) and d.user_id= b.mng_id(+) and d.user_id = c.visiter(+) "+
						"	 AND d.user_id not in ('000006','000002','000001') AND d.dept_id='"+dept_id+"' "+
						"	) a,   "+
						"	  (SELECT nvl(sum(a.sac),0) sac, nvl(sum(b.sec),0) sec, nvl(sum(c.s_cnt),0) sc "+
						"		FROM (select nvl(mng_id,'999999') mng_id, nvl(count(0),0) sac from cont where use_yn = 'Y' and car_mng_id is not null group by mng_id) a, 	 "+
						"			 (select nvl(mng_id,'999999') mng_id, nvl(sum(decode("+subQuery1+",1,0)),0) sec "+
						"				from cont a, service b  "+
						"				where a.car_mng_id = b.car_mng_id and a.use_yn = 'Y'  "+
						"				group by mng_id) b,     "+
						"			 (SELECT checker, nvl(count(0),0) S_CNT FROM service b where "+subQuery11+" GROUP BY checker ) c "+
						"            ,users d                  	 "+
						"              WHERE d.user_id=a.mng_id(+) and d.user_id = b.mng_id(+) and d.user_id = c.checker(+) "+
						"              AND d.user_id not in ('000006','000002','000001') AND d.dept_id='"+dept_id+"' "+
						"	) b ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				st[0] = rs.getInt(1);
				st[1] = rs.getInt(2);
				st[2] = rs.getInt(3);
				st[3] = rs.getInt(4);
				st[4] = rs.getInt(5);
				st[5] = rs.getInt(6);
			}
			rs.close();
			pstmt.close();

		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_md_pre2(String cmd, String dept_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return st;
		}
	}

	/**
	*	당월 배차,반차 현황 조회 20040922.
	*   1:단기대여, 2:정비대차, 3:사고대차, 6:차량정비(점검), 7:차량정비(정비), 9:보험대차, 10:지연대차
	*/
	public Vector getTg_rs(String cmd){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String subQuery1="", subQuery2 = "";
		if(cmd.equals("m")){
			subQuery1 = " deli_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery2 = " ret_dt like to_char(sysdate,'yyyymm')||'%' ";
		}else if(cmd.equals("d")){
			subQuery1 = " deli_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery2 = " ret_dt like to_char(sysdate,'yyyymmdd')||'%' ";
		}

		String query = "select c.user_id id, nvl(rsd1,0) rsd1, nvl(rsr1,0) rsr1, nvl(rsd2,0) rsd2, nvl(rsr2,0) rsr2, nvl(rsd3,0) rsd3, nvl(rsr3,0) rsr3, nvl(rsd6,0)+nvl(rsd7,0) rsd67, nvl(rsr6,0)+nvl(rsr7,0) rsr67, nvl(rsd9,0) rsd9, nvl(rsr9,0) rsr9, nvl(rsd10,0) rsd10, nvl(rsr10,0) rsr10 "+
						"		, nvl(rsd1,0)+nvl(rsr1,0)+nvl(rsd2,0)+nvl(rsr2,0)+nvl(rsd3,0)+nvl(rsr3,0)+nvl(rsd6,0)+nvl(rsr6,0)+nvl(rsd7,0)+nvl(rsr7,0)+nvl(rsd9,0)+nvl(rsr9,0)+nvl(rsd10,0)+nvl(rsr10,0) tot "+
						" from (select deli_mng_id, "+
						"           nvl(sum(decode(rent_st,'1',1,'12',1,0)),0) rsd1, "+
						"			nvl(sum(decode(rent_st,'2',1,0)),0) rsd2, "+
						"			nvl(sum(decode(rent_st,'3',1,0)),0) rsd3, "+
						"			nvl(sum(decode(rent_st,'6',1,0)),0) rsd6, "+
						"			nvl(sum(decode(rent_st,'7',1,0)),0) rsd7, "+
						"			nvl(sum(decode(rent_st,'9',1,0)),0) rsd9, "+
						"			nvl(sum(decode(rent_st,'10',1,0)),0) rsd10 "+
						"		from rent_cont "+
						"		where "+subQuery1+
						"		  and use_st <> '5' "+
						"		group by deli_mng_id) a, "+
						"		(select ret_mng_id, "+
						"           nvl(sum(decode(rent_st,'1',1,'12',1,0)),0) rsr1, "+
						"			nvl(sum(decode(rent_st,'2',1,0)),0) rsr2, "+
						"			nvl(sum(decode(rent_st,'3',1,0)),0) rsr3, "+
						"			nvl(sum(decode(rent_st,'6',1,0)),0) rsr6, "+
						"			nvl(sum(decode(rent_st,'7',1,0)),0) rsr7, "+
						"			nvl(sum(decode(rent_st,'9',1,0)),0) rsr9, "+
						"			nvl(sum(decode(rent_st,'10',1,0)),0) rsr10 "+
						"		from rent_cont "+
						"		where "+subQuery2+
						"		  and use_st <> '5' "+
						"		group by ret_mng_id) b, users c "+
						" where c.user_id = a.deli_mng_id(+) "+
						"  and  c.user_id = b.ret_mng_id(+) "+
						"  and  c.dept_id = '0002' and c.user_id not in ('000002','000006','000001') "+
						" order by tot desc ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
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

		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_md_rs()]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}

	/**
	*	업무현황(전체) -  2004.09.23.
	* 20041008 수정 
	*/
	public Vector getCusPreAll_md(String cmd){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String subQuery1="", subQuery11="", subQuery2="", subQuery22="", subQuery3 = "", subQuery4 = "", subQuery5 ="", subQuery6="";
		if(cmd.equals("m")){
			subQuery1  = " substr(b.next_serv_dt,1,6),to_char(sysdate,'yyyymm') ";
			subQuery11 = " b.serv_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery2  = " substr(b.vst_est_dt,1,6),to_char(sysdate,'yyyymm') ";
			subQuery22 = " b.vst_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery3  = " serv_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery4  = " che_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery5  = " ser_hope_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery6  = " check_dt like to_char(sysdate,'yyyymm')||'%' ";
		}else if(cmd.equals("d")){
			subQuery1  = " substr(b.next_serv_dt,1,8),to_char(sysdate,'yyyymmdd') ";
			subQuery11 = " b.serv_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery2  = " substr(b.vst_est_dt,1,8),to_char(sysdate,'yyyymmdd') ";
			subQuery22 = " b.vst_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery3  = " serv_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery4  = " che_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery5  = " ser_hope_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery6  = " check_dt like to_char(sysdate,'yyyymmdd')||'%' ";
		}

		String query = "SELECT u.user_id USER_ID, nvl(vac,0) VAC, nvl(vec,0) VEC, nvl(vc,0) VC, nvl(sac,0) SAC, nvl(sec,0) SEC, nvl(sc,0) SC, nvl(cs1,0) CS1, nvl(cs2,0) CS2, nvl(cs3,0) CS3, nvl(mac1,0) MAC1, nvl(mac2,0) MAC2, nvl(irh,0) IRH, nvl(irc,0) IRC, decode(nvl(sec,0),0,0,(nvl(vc,0)*100/decode(nvl(vec,0),0,1,vec) + nvl(sc,0)*100/decode(nvl(sec,0),0,1,sec))/2) VS_RATE  "+
						" FROM (SELECT d.user_id, nvl(a.sac,0) sac, nvl(b.sec,0) sec, nvl(c.s_cnt,0) sc   "+
						"		FROM (select nvl(mng_id,'999999') mng_id, nvl(count(0),0) sac from cont where use_yn = 'Y' and car_mng_id is not null group by mng_id) a, "+	//자동차전체
						"			 (select nvl(mng_id,'999999') mng_id, nvl(sum(decode("+subQuery1+",1,0)),0) sec  "+
						"				from cont a, service b "+
						"				where a.car_mng_id = b.car_mng_id and a.use_yn = 'Y' "+
						"				group by mng_id) b,    "+	//예정
						" 			 (SELECT checker, nvl(count(0),0) S_CNT FROM service b where "+subQuery11+" GROUP BY checker ) c "+	//정비
						"			, users d "+
						"		WHERE d.user_id=a.mng_id(+) AND d.user_id=b.mng_id(+) AND d.user_id=c.checker(+) "+
						" ) s,  "+
						" (SELECT a.user_id, nvl(a.cnt,0) vac, nvl(b.v_est_cnt,0) vec, nvl(c.v_cnt,0) vc    "+
						" FROM (select a.user_id, nvl(a.cnt,0)+nvl(b.cnt,0) cnt "+
						"			from (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt   "+
						"			 from (select a.bus_id2, a.client_id, count(0) cnt   "+
						"			 	 from cont a   "+
						"			 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')   "+
						"			 	 	  and a.bus_id2=nvl(a.mng_id,a.bus_id2)   "+
						"			 	group by a.bus_id2, a.client_id, a.r_site) a   "+
						"			 group by bus_id2 ) a, "+	//단독
						"			( select nvl(a.mng_id,'999999') as user_id, count(0) cnt  "+
						"			 from (select a.mng_id, a.client_id, count(0) cnt  "+
						"			 	 from cont a  "+
						"			 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')  "+
						"			 	 	   and a.bus_id2<>a.mng_id  "+
						"			 	group by a.mng_id, a.client_id, a.r_site) a  "+
						"			 group by mng_id ) b "+		//공동
						"			where a.user_id=b.user_id(+) ) a, "+	//거래처전체
						"  	 (select a.mng_id MNG_ID, nvl(sum(decode("+subQuery2+",1,0)),0) V_EST_CNT    "+
						"		from (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') a, cycle_vst b    "+
						" 		where a.client_id = b.client_id  "+
						"		group by a.mng_id) b,    "+		//예정
						" 	  ( select visiter, nvl(count(0),0) V_CNT from cycle_vst b where "+subQuery22+"  group by visiter ) c  "+	//방문
						"  WHERE a.user_id = b.mng_id(+) and a.user_id = c.visiter(+) "+
						" ) v,  "+
						"(SELECT checker, nvl(sum(decode(checker_st,'1',1,0)),0) CS1,  "+
						"	  nvl(sum(decode(checker_st,'2',1,0)),0) CS2,  "+
						"	  nvl(sum(decode(checker_st,'3',1,0)),0) CS3  "+
						"  FROM service "+
						"  where "+subQuery3+" "+
						"  GROUP BY checker  "+
						" ) cs, "+
						" ( select che_no,nvl(sum(decode(che_kd,'1',1,0)),0) mac1, nvl(sum(decode(che_kd,'2',1,0)),0) mac2 "+
						"   from car_maint "+
						"   where "+subQuery4+
						"   group by che_no ) ma, "+
						" (select b.mng_id, nvl(count(0),0) irh "+
						"    from ires a, cont b where "+subQuery5+
						"	  and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+
						"	group by b.mng_id "+
						" ) irh, "+
						" (select checker, nvl(count(0),0) irc from ires where "+subQuery6+" group by checker "+
						" ) irc, "+
						"  users u "+
						" WHERE u.user_id = s.user_id(+) AND u.user_id = v.user_id(+)  "+
						" AND u.user_id = cs.checker(+)  AND u.user_id = ma.che_no(+) "+
						" AND u.user_id = irh.mng_id(+) AND u.user_id=irc.checker(+)  "+
						" AND u.user_id not in ('000006','000002','000001') AND u.dept_id='0002' "+
						" ORDER BY vs_rate desc ";
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
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

		}catch(Exception e){
			System.out.println("[CusPre_Database:getCusPreAll_md(String cmd)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}

	/**
	*	업무현황(전체) -  2004.09.23.
	* 20041008 수정 
	*/
	public Vector getCusPreAll_md2(String cmd, String dept_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String subQuery1="", subQuery11="", subQuery2="", subQuery22="", subQuery3 = "", subQuery4 = "", subQuery5 ="", subQuery6="";
		if(cmd.equals("m")){
			subQuery1  = " substr(b.next_serv_dt,1,6),to_char(sysdate,'yyyymm') ";
			subQuery11 = " b.serv_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery2  = " substr(b.vst_est_dt,1,6),to_char(sysdate,'yyyymm') ";
			subQuery22 = " b.vst_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery3  = " serv_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery4  = " che_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery5  = " ser_hope_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery6  = " check_dt like to_char(sysdate,'yyyymm')||'%' ";
		}else if(cmd.equals("d")){
			subQuery1  = " substr(b.next_serv_dt,1,8),to_char(sysdate,'yyyymmdd') ";
			subQuery11 = " b.serv_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery2  = " substr(b.vst_est_dt,1,8),to_char(sysdate,'yyyymmdd') ";
			subQuery22 = " b.vst_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery3  = " serv_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery4  = " che_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery5  = " ser_hope_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery6  = " check_dt like to_char(sysdate,'yyyymmdd')||'%' ";
		}

		String query = "SELECT u.user_id USER_ID, nvl(vac,0) VAC, nvl(vec,0) VEC, nvl(vc,0) VC, nvl(sac,0) SAC, nvl(sec,0) SEC, nvl(sc,0) SC, nvl(cs1,0) CS1, nvl(cs2,0) CS2, nvl(cs3,0) CS3, nvl(mac1,0) MAC1, nvl(mac2,0) MAC2, nvl(irh,0) IRH, nvl(irc,0) IRC, decode(nvl(sec,0),0,0,(nvl(vc,0)*100/decode(nvl(vec,0),0,1,vec) + nvl(sc,0)*100/decode(nvl(sec,0),0,1,sec))/2) VS_RATE  "+
						" FROM (SELECT d.user_id, nvl(a.sac,0) sac, nvl(b.sec,0) sec, nvl(c.s_cnt,0) sc   "+
						"		FROM (select nvl(mng_id,'999999') mng_id, nvl(count(0),0) sac from cont where use_yn = 'Y' and car_mng_id is not null group by mng_id) a, "+	//자동차전체
						"			 (select nvl(mng_id,'999999') mng_id, nvl(sum(decode("+subQuery1+",1,0)),0) sec  "+
						"				from cont a, service b "+
						"				where a.car_mng_id = b.car_mng_id and a.use_yn = 'Y' "+
						"				group by mng_id) b,    "+	//예정
						" 			 (SELECT checker, nvl(count(0),0) S_CNT FROM service b where "+subQuery11+" GROUP BY checker ) c "+	//정비
						"			, users d "+
						"		WHERE d.user_id=a.mng_id(+) AND d.user_id=b.mng_id(+) AND d.user_id=c.checker(+) "+
						" ) s,  "+
						" (SELECT a.user_id, nvl(a.cnt,0) vac, nvl(b.v_est_cnt,0) vec, nvl(c.v_cnt,0) vc    "+
						" FROM (select a.user_id, nvl(a.cnt,0)+nvl(b.cnt,0) cnt "+
						"			from (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt   "+
						"			 from (select a.bus_id2, a.client_id, count(0) cnt   "+
						"			 	 from cont a   "+
						"			 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')   "+
						"			 	 	  and a.bus_id2=nvl(a.mng_id,a.bus_id2)   "+
						"			 	group by a.bus_id2, a.client_id, a.r_site) a   "+
						"			 group by bus_id2 ) a, "+	//단독
						"			( select nvl(a.mng_id,'999999') as user_id, count(0) cnt  "+
						"			 from (select a.mng_id, a.client_id, count(0) cnt  "+
						"			 	 from cont a  "+
						"			 	 where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')  "+
						"			 	 	   and a.bus_id2<>a.mng_id  "+
						"			 	group by a.mng_id, a.client_id, a.r_site) a  "+
						"			 group by mng_id ) b "+		//공동
						"			where a.user_id=b.user_id(+) ) a, "+	//거래처전체
						"  	 (select a.mng_id MNG_ID, nvl(sum(decode("+subQuery2+",1,0)),0) V_EST_CNT    "+
						"		from (SELECT DISTINCT client_id,mng_id FROM cont WHERE use_yn = 'Y') a, cycle_vst b    "+
						" 		where a.client_id = b.client_id  "+
						"		group by a.mng_id) b,    "+		//예정
						" 	  ( select visiter, nvl(count(0),0) V_CNT from cycle_vst b where "+subQuery22+"  group by visiter ) c  "+	//방문
						"  WHERE a.user_id = b.mng_id(+) and a.user_id = c.visiter(+) "+
						" ) v,  "+
						"(SELECT checker, nvl(sum(decode(checker_st,'1',1,0)),0) CS1,  "+
						"	  nvl(sum(decode(checker_st,'2',1,0)),0) CS2,  "+
						"	  nvl(sum(decode(checker_st,'3',1,0)),0) CS3  "+
						"  FROM service "+
						"  where "+subQuery3+" "+
						"  GROUP BY checker  "+
						" ) cs, "+
						" ( select che_no,nvl(sum(decode(che_kd,'1',1,0)),0) mac1, nvl(sum(decode(che_kd,'2',1,0)),0) mac2 "+
						"   from car_maint "+
						"   where "+subQuery4+
						"   group by che_no ) ma, "+
						" (select b.mng_id, nvl(count(0),0) irh "+
						"    from ires a, cont b where "+subQuery5+
						"	  and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+
						"	group by b.mng_id "+
						" ) irh, "+
						" (select checker, nvl(count(0),0) irc from ires where "+subQuery6+" group by checker "+
						" ) irc, "+
						"  users u "+
						" WHERE u.user_id = s.user_id(+) AND u.user_id = v.user_id(+)  "+
						" AND u.user_id = cs.checker(+)  AND u.user_id = ma.che_no(+) "+
						" AND u.user_id = irh.mng_id(+) AND u.user_id=irc.checker(+)  "+
						" AND u.user_id not in ('000006','000002','000001') AND u.dept_id='"+dept_id+"' "+
						" ORDER BY vs_rate desc ";
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
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

		}catch(Exception e){
			System.out.println("[CusPre_Database:getCusPreAll_md2(String cmd, String dept_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}

	/**
	*	거래처와자동차 단독,공동관리 및 자동차(렌트,리스,일반식,기본식,맞춤식)관리 현황 조회 20040922.
	*/
	public int[] getTg_md2(String cmd, String dept_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int[] st = new int[10];
		String subQuery = "", subQuery1 = "", subQuery2="";
		String b_subQuery = "", b_subQuery1 = "", b_subQuery2="";
		if(cmd.equals("m")){
			subQuery  = " and a.rent_dt like to_char(sysdate,'yyyymm')||'%'  ";
			subQuery1 = " and rent_start_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery2 = " and rent_end_dt like to_char(sysdate,'yyyymm')||'%' ";
		}else if(cmd.equals("d")){
			subQuery  = " and a.rent_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery1 = " and rent_start_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery2 = " and rent_end_dt like to_char(sysdate,'yyyymmdd')||'%' ";
		}

		if(dept_id.equals("0007")){
			b_subQuery  += " and a.BRCH_ID in ('B1','N1')";
			b_subQuery1 += " and a.BRCH_ID in ('B1','N1')";
			b_subQuery2 += " and a.BRCH_ID in ('B1','N1')";
		}

		if(dept_id.equals("0008")){
			b_subQuery  = " and a.BRCH_ID in ('D1')";
			b_subQuery1 = " and a.BRCH_ID in ('D1')";
			b_subQuery2 = " and a.BRCH_ID in ('D1')";
		}

		String query = "select nvl(a.cnt,0), nvl(b.cnt,0), nvl(c.cnt,0), nvl(d.cnt,0), nvl(e.grc,0), nvl(e.bmrc,0), nvl(e.glc,0), nvl(e.bmlc,0), nvl(f.cnt,0) rsc, nvl(g.cnt,0) rec "+
						" from (select  count(0) cnt "+
						"		from (select a.bus_id2, count(0) cnt   "+
						" 				from cont a   "+
						" 				where nvl(a.use_yn,'Y')='Y'  "+b_subQuery+" and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2)  "+
						" 			group by a.bus_id2, client_id ) "+
						"		) a, "+
						"	    (select count(0) cnt "+
						"		 from ( select client_id,count(0) cnt from cont a  "+
						"	             where nvl(a.use_yn,'Y')='Y'  "+b_subQuery+" and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id "+
						"	   			group by client_id) "+
						"		)b, "+
						"	 (select  count(0) cnt   "+
						"	  from cont a, fee b   "+
						"	   where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y'  "+b_subQuery+" and b.rent_st='1'   "+
						"	   	and a.client_id not in ('000231', '000228') and b.rent_way='1' "+
						"	 	and a.mng_id=nvl(a.mng_id2,a.mng_id) and a.car_mng_id is not null  "+
						"	 )c,   "+
						"	 (select  count(0) cnt   "+
						"	  from cont a, fee b   "+
						"	   where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y'  "+b_subQuery+" and b.rent_st='1'   "+
						"	   	and a.client_id not in ('000231', '000228') and b.rent_way='1'   "+
						"		and a.mng_id=a.mng_id2 and a.car_mng_id is not null  "+
						"	)d,   "+
						"	(select a.grc, a.glc, b.bmrc, b.bmlc  "+
						"	 from  "+
						"		(select nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'1',1,0),0)),0) grc,  "+
						"				nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'1',1,0),0)),0) glc  "+
						" 		from cont a, fee b  "+
						" 		 where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y'  "+b_subQuery+"  "+   
						" 		and b.rent_st='1' and a.client_id not in ('000231', '000228')     "+
						" 		and a.mng_id = nvl(a.mng_id2, a.mng_id)  "+
						" 		and a.car_mng_id is not null  "+
						"		) a,	  "+
						"		(select nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'2',1,0),0)),0)+nvl(sum(decode(a.car_st,'1',decode(b.rent_way,'3',1,0),0)),0) bmrc,  "+
						" 				nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'2',1,0),0)),0)+nvl(sum(decode(a.car_st,'3',decode(b.rent_way,'3',1,0),0)),0) bmlc  "+
						" 		from cont a, fee b  "+
						" 		where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y'  "+b_subQuery+"  "+
						" 		and b.rent_st='1' and a.client_id not in ('000231', '000228')  "+
						" 		and a.car_mng_id is not null  "+
						"		) b  "+ 
						"	 )e, "+
						"	(select count(0) cnt from cont a where a.use_yn = 'Y' "+subQuery1+" "+b_subQuery+" ) f, "+
						"   (select count(0) cnt from cont a where a.use_yn = 'Y' "+subQuery2+" "+b_subQuery+" ) g ";
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				st[0] = rs.getInt(1);
				st[1] = rs.getInt(2);
				st[2] = rs.getInt(3);
				st[3] = rs.getInt(4);
				st[4] = rs.getInt(5);
				st[5] = rs.getInt(6);
				st[6] = rs.getInt(7);
				st[7] = rs.getInt(8);
				st[8] = rs.getInt(9);
				st[9] = rs.getInt(10);
			}

			rs.close();
			pstmt.close();

		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_md2(String cmd, String dept_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return st;
		}
	}

	/**
	*	당월 배차,반차 현황 조회 20040922.
	*   1:단기대여, 2:정비대차, 3:사고대차, 6:차량정비(점검), 7:차량정비(정비), 9:보험대차, 10:지연대차
	*/
	public Vector getTg_rs2(String cmd, String dept_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String subQuery1="", subQuery2 = "";
		if(cmd.equals("m")){
			subQuery1 = " deli_dt like to_char(sysdate,'yyyymm')||'%' ";
			subQuery2 = " ret_dt like to_char(sysdate,'yyyymm')||'%' ";
		}else if(cmd.equals("d")){
			subQuery1 = " deli_dt like to_char(sysdate,'yyyymmdd')||'%' ";
			subQuery2 = " ret_dt like to_char(sysdate,'yyyymmdd')||'%' ";
		}

		String query = "select c.user_id id, nvl(rsd1,0) rsd1, nvl(rsr1,0) rsr1, nvl(rsd2,0) rsd2, nvl(rsr2,0) rsr2, nvl(rsd3,0) rsd3, nvl(rsr3,0) rsr3, nvl(rsd6,0)+nvl(rsd7,0) rsd67, nvl(rsr6,0)+nvl(rsr7,0) rsr67, nvl(rsd9,0) rsd9, nvl(rsr9,0) rsr9, nvl(rsd10,0) rsd10, nvl(rsr10,0) rsr10 "+
						"		, nvl(rsd1,0)+nvl(rsr1,0)+nvl(rsd2,0)+nvl(rsr2,0)+nvl(rsd3,0)+nvl(rsr3,0)+nvl(rsd6,0)+nvl(rsr6,0)+nvl(rsd7,0)+nvl(rsr7,0)+nvl(rsd9,0)+nvl(rsr9,0)+nvl(rsd10,0)+nvl(rsr10,0) tot "+
						" from (select deli_mng_id,"+
						"           nvl(sum(decode(rent_st,'1',1,'12',1,0)),0) rsd1, "+
						"			nvl(sum(decode(rent_st,'2',1,0)),0) rsd2, "+
						"			nvl(sum(decode(rent_st,'3',1,0)),0) rsd3, "+
						"			nvl(sum(decode(rent_st,'6',1,0)),0) rsd6, "+
						"			nvl(sum(decode(rent_st,'7',1,0)),0) rsd7, "+
						"			nvl(sum(decode(rent_st,'9',1,0)),0) rsd9, "+
						"			nvl(sum(decode(rent_st,'10',1,0)),0) rsd10 "+
						"		from rent_cont "+
						"		where "+subQuery1+
						"		  and use_st <> '5' "+
						"		group by deli_mng_id) a, "+
						"		(select ret_mng_id, "+
						"           nvl(sum(decode(rent_st,'1',1,'12',1,0)),0) rsr1, "+
						"			nvl(sum(decode(rent_st,'2',1,0)),0) rsr2, "+
						"			nvl(sum(decode(rent_st,'3',1,0)),0) rsr3, "+
						"			nvl(sum(decode(rent_st,'6',1,0)),0) rsr6, "+
						"			nvl(sum(decode(rent_st,'7',1,0)),0) rsr7, "+
						"			nvl(sum(decode(rent_st,'9',1,0)),0) rsr9, "+
						"			nvl(sum(decode(rent_st,'10',1,0)),0) rsr10 "+
						"		from rent_cont "+
						"		where "+subQuery2+
						"		  and use_st <> '5' "+
						"		group by ret_mng_id) b, users c "+
						" where c.user_id = a.deli_mng_id(+) "+
						"  and  c.user_id = b.ret_mng_id(+) "+
						"  and  c.dept_id = '"+dept_id+"' and c.user_id not in ('000002','000006','000001') "+
						" order by tot desc ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
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

		}catch(Exception e){
			System.out.println("[CusPre_Database:getTg_rs2(String cmd, String dept_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
			}catch(Exception ex){}
			closeConnection();
			return vt;
		}
	}


	/*
	*	당해 자동차 주행거리 7000km 초과 리스트
	*/
	public Vector getOver_7000km(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String who = "";

		if(!user_id.equals("")) who = " and b.mng_id = '"+user_id+"' ";
		else					who = " and b.mng_id is not null ";

		query = " select DISTINCT a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls, \n"+
				"        vt.tot_dist AS TOT_DIST, "+
				"        CASE WHEN NVL( vt.tot_dist, '0' ) = '0' THEN 0 WHEN vt.tot_dt = nvl( e.dlv_dt, a.init_reg_dt ) THEN 0 "+
				"             ELSE round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( replace(e.dlv_dt, '-', ''), a.init_reg_dt ), 'YYYYMMDD' ))) "+
				"             END AS AVERAGE_DIST, "+
				"        x.today_dist , e.rent_mng_id, e.rent_l_cd, e.fee_rent_st "+ 
				" from \n"+
				"	     ( select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls, c.init_reg_dt \n"+
				"          from   client a, (SELECT DISTINCT client_id,car_mng_id,mng_id FROM cont WHERE use_yn = 'Y') b, car_reg c, service d \n"+
				"	       where  nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id \n"+
				"	              and b.car_mng_id = c.car_mng_id \n"+
				"	              and c.car_mng_id = d.car_mng_id \n"+
//				"	              AND d.next_serv_dt <= to_char( sysdate, 'yyyymmdd' ) AND substr( d.next_serv_dt, 1, 4 ) = to_char( sysdate, 'yyyy' ) AND d.serv_dt IS NULL \n"+
				                  who+" ) a, "+
				"        service b, "+
				"		 ( SELECT vt.car_mng_id, vt.tot_dist AS TOT_DIST, decode( vt.tot_dist, \n"+
				"                 '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), \n"+
				"                 0, round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) \n"+
				"                 - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))))) \n"+
				"                 AS AVERAGE_DIST, decode( vt.tot_dist, '', 0, '0', 0, decode( \n"+
				"                 vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist \n"+
				"                 + round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) \n"+
				"                 - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) \n"+
				"                 * ( to_date( to_char( sysdate, 'YYYYMMDD' ), 'YYYYMMDD' ) \n"+
				"                 - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST \n"+
				"          FROM   v_tot_dist vt, cont e, car_reg a  WHERE e.car_mng_id = vt.car_mng_id(+) AND e.car_mng_id = a.car_mng_id ) x, "+
				"		 v_tot_dist vt, cont_n_view e , fee f, "+
				"        ( select car_mng_id, MAX(serv_dt) as serv_dt from SERVICE where  tot_dist >1 and serv_dt is not NULL GROUP BY car_mng_id ) c \n"+
				" where  a.car_mng_id = b.car_mng_id  and a.car_mng_id = x.car_mng_id and e.rent_mng_id = f.rent_mng_id   and e.rent_l_cd = f.rent_l_cd \n"+
				"        AND a.car_mng_id = vt.car_mng_id(+)  AND a.car_mng_id = e.car_mng_id and x.today_dist - vt.tot_dist > 10000 and e.use_yn ='Y' and f.rent_way = '1'\n"+
				"        and a.serv_id  = b.serv_id \n"+
				"        AND b.car_mng_id=c.car_mng_id AND b.serv_dt=c.serv_dt \n"+
				" UNION ALL "+
				" SELECT DISTINCT a.car_mng_id, '', e.FIRM_NM, "+
					  " a.car_no, d.serv_dt, d.next_serv_dt, "+
					   " d.next_rep_cont, b.MNG_ID, '', "+
					   " vt.tot_dist, "+
				" CASE "+
				" WHEN NVL( vt.tot_dist, '0' ) = '0' THEN 0 "+
				" WHEN vt.tot_dt = nvl( b.dlv_dt, a.init_reg_dt ) THEN 0 "+
				" ELSE round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - "+
				" 	   to_date( nvl( replace( b.dlv_dt, '-', '' ), a.init_reg_dt ), "+
				" 	   'YYYYMMDD' ))) "+
				" END AS AVERAGE_DIST, decode( vt.tot_dist, '', 0, '0', 0, decode( "+
				" 	   vt.tot_dt, nvl( b.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist "+
				" 	   + round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) "+
				" 	   - to_date( nvl( b.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) "+
				" 	   * ( to_date( to_char( sysdate, 'YYYYMMDD' ), 'YYYYMMDD' ) "+
				" 	   - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST, b.RENT_MNG_ID, "+
				" 	   b.RENT_L_CD, '' "+
				" FROM car_reg a, cont b, v_tot_dist vt, "+
				" 	 ( SELECT car_mng_id, next_rep_cont, max( next_serv_dt ) AS next_serv_dt, "+
				" 			  max( serv_dt ) AS serv_dt "+
				" 	   FROM service "+
				" 	   GROUP BY car_mng_id, next_rep_cont ) d, client e, "+
				" 	 ( SELECT a.mng_id, a.car_mng_id, b.user_nm AS mng_nm "+
				" 	   FROM cont a, users b "+
				" 	   WHERE a.use_yn = 'Y' "+
				" 		 AND a.mng_id = b.user_id ) us, "+
				" 	 ( SELECT vt.car_mng_id, vt.tot_dist AS TOT_DIST, decode( vt.tot_dist, "+
				" 			  '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), "+
				" 			  0, round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) "+
				" 			  - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))))) "+
				" 			  AS AVERAGE_DIST, decode( vt.tot_dist, '', 0, '0', 0, decode( "+
				" 			  vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist "+
				" 			  + round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) "+
				" 			  - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) "+
				" 			  * ( to_date( to_char( sysdate, 'YYYYMMDD' ), 'YYYYMMDD' ) "+
				" 			  - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST "+
				" 	   FROM v_tot_dist vt, cont e, car_reg a "+
				" 	   WHERE e.car_mng_id = vt.car_mng_id(+) "+
				" 		 AND e.car_mng_id = a.car_mng_id ) x "+
				" WHERE nvl( b.use_yn, 'Y' ) = 'Y' "+
				"   AND b.car_st = '2' "+
				"   AND nvl( a.off_ls, '0' ) = '0' "+
				"   AND a.car_mng_id = b.car_mng_id "+
				"   AND b.car_mng_id = d.car_mng_id(+) "+
				"   AND a.car_mng_id = x.car_mng_id(+) "+
				"   AND b.CLIENT_ID = e.CLIENT_ID(+) "+
				"   AND a.car_mng_id = us.car_mng_id(+) "+
				"   AND decode( a.prepare, '', '1', '7', '1', a.prepare ) NOT IN ( '4', '5', '6', '8' )  "+
				"   AND a.car_mng_id = vt.car_mng_id(+) "+
				"   AND d.next_serv_dt <= to_char( sysdate, 'yyyymmdd' ) "+
				"   AND substr( d.next_serv_dt, 1, 4 ) = to_char( sysdate, 'yyyy' ) "+
//				"   AND b.mng_id = '000026' "+
				who+"   AND x.today_dist - vt.tot_dist >= 10000 ";

/*
		query = "select DISTINCT a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls, \n"+
				"  x.TOT_DIST, x.AVERAGE_DIST, x.today_dist , e.rent_mng_id, e.rent_l_cd, e.fee_rent_st \n"+ 		
				" from \n"+
				"	(select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls, c.init_reg_dt \n"+
				"    from client a, (SELECT DISTINCT client_id,car_mng_id,mng_id FROM cont WHERE use_yn = 'Y') b, car_reg c, service d \n"+
				"	 where nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id \n"+
				"	 and b.car_mng_id = c.car_mng_id \n"+
				"	 and c.car_mng_id = d.car_mng_id \n"+
				"	 AND d.next_serv_dt <= to_char( sysdate, 'yyyymmdd' ) AND substr( d.next_serv_dt, 1, 4 ) = to_char( sysdate, 'yyyy' ) AND d.serv_dt IS NULL \n"+
				who+" ) a, service b, ( SELECT vt.car_mng_id, vt.tot_dist AS TOT_DIST, decode( vt.tot_dist,  '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ),  0, round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' )))))  AS AVERAGE_DIST, \n" +
				" decode( vt.tot_dist, '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist + round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' )  - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) * ( to_date( to_char( sysdate, 'YYYYMMDD' ), 'YYYYMMDD' )  - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST \n"+
				"  FROM v_tot_dist vt, cont e, car_reg a  WHERE e.car_mng_id = vt.car_mng_id(+) AND e.car_mng_id = a.car_mng_id ) x, cont_n_view e , fee f \n"+
				" where a.car_mng_id = b.car_mng_id  and a.car_mng_id = x.car_mng_id and e.rent_mng_id = f.rent_mng_id   and e.rent_l_cd = f.rent_l_cd \n"+
				" AND a.car_mng_id = e.car_mng_id and x.today_dist - x.tot_dist > 7000 and e.use_yn ='Y' and f.rent_way = '1'\n"+
				" and a.serv_id  = b.serv_id \n"+
				" UNION ALL \n"+
				" SELECT DISTINCT a.car_mng_id, '', e.FIRM_NM,  a.car_no, d.serv_dt, d.next_serv_dt, d.next_rep_cont, b.MNG_ID, '', \n"+
				"  x.TOT_DIST, x.AVERAGE_DIST, x.today_dist , b.RENT_MNG_ID,   b.RENT_L_CD, ''  \n"+ 
				" FROM car_reg a, cont b, "+
				" 	 ( SELECT car_mng_id, next_rep_cont, max( next_serv_dt ) AS next_serv_dt,  max( serv_dt ) AS serv_dt  FROM service  GROUP BY car_mng_id, next_rep_cont ) d, client e, \n"+
				" 	 ( SELECT a.mng_id, a.car_mng_id, b.user_nm AS mng_nm  FROM cont a, users b   WHERE a.use_yn = 'Y' AND a.mng_id = b.user_id ) us, \n"+
				" 	 ( SELECT vt.car_mng_id, vt.tot_dist AS TOT_DIST, decode( vt.tot_dist, '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' )  - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' )))))  AS AVERAGE_DIST, \n"+
				"       decode( vt.tot_dist, '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist  + round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' )  - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) * ( to_date( to_char( sysdate, 'YYYYMMDD' ), 'YYYYMMDD' ) - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST \n"+
				" 	   FROM v_tot_dist vt, cont e, car_reg a WHERE e.car_mng_id = vt.car_mng_id(+) AND e.car_mng_id = a.car_mng_id ) x "+
				" WHERE nvl( b.use_yn, 'Y' ) = 'Y'  AND b.car_st = '2' AND nvl( a.off_ls, '0' ) = '0' \n"+
				"   AND a.car_mng_id = b.car_mng_id  AND b.car_mng_id = d.car_mng_id(+)  AND a.car_mng_id = x.car_mng_id(+)  AND b.CLIENT_ID = e.CLIENT_ID(+) \n"+
				"   AND a.car_mng_id = us.car_mng_id(+) AND decode( a.prepare, '', '1', '7', '1', a.prepare ) NOT IN ( '4', '5', '6', '8' )  \n"+			
				"   AND d.next_serv_dt <= to_char( sysdate, 'yyyymmdd' )  AND substr( d.next_serv_dt, 1, 4 ) = to_char( sysdate, 'yyyy' ) \n"+//			
				who+"   AND x.today_dist - x.tot_dist >= 7000 \n";
	*/	
		query +="order by next_serv_dt ";				


		try 
		{
			pstmt = conn.prepareStatement(query);

//			if(!user_id.equals("")){
//				pstmt.setString(1, user_id);
//				pstmt.setString(2, user_id);
//				pstmt.setString(3, user_id);
//				pstmt.setString(4, user_id);
//			}	
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
			System.out.println("[CusPre_Database:getOver_7000km(String user_id)]\n"+e);
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

	//월렌트 계약개시,만료현황
	public Vector getRentMonContList(String br_id, String user_id, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select e.firm_nm, e.client_nm, b.car_no, b.car_nm, a.*, c.user_nm as bus_nm, d.user_nm as mng_nm, \n"+
				"        decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기') rent_st_nm,   \n"+
				"        decode(a.use_st,'1','예약','2','배차','3','반차','4','종료') use_st_nm  \n"+
				" from   RENT_CONT a, car_reg b, users c, users d, client e  \n"+
				" where  a.use_st IN ('1','2') and a.rent_st='12' \n"+
				"        and a.car_mng_id=b.car_mng_id and a.bus_id=c.user_id and a.mng_id=d.user_id(+) and a.cust_id=e.client_id \n"+
				" ";

		//담당자
		if(!user_id.equals(""))			query += " and a.bus_id||a.mng_id like '%"+user_id+"%' ";

		//구분
		if(gubun.equals("1"))			query += " and substr(a.deli_dt,1,8) between to_char(sysdate-10,'yyyymmdd') and to_char(sysdate,'yyyymmdd') ";
		else if(gubun.equals("2"))		query += " and ( (substr(a.ret_plan_dt,1,8) between to_char(sysdate-10,'yyyymmdd') and to_char(sysdate+10, 'yyyymmdd')) or ( substr(a.ret_plan_dt,1,8) < to_char(sysdate-10,'yyyymmdd')) ) ";

		//정렬
		if(gubun.equals("1"))			query += " order by a.deli_dt, e.firm_nm ";
		else if(gubun.equals("2"))		query += " order by substr(a.ret_plan_dt,1,8), e.firm_nm ";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getRentMonContList]\n"+e);
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

	//월렌트 미수스케줄
	public Vector getRentMonSettleList(String br_id, String user_id, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select e.firm_nm, e.client_nm, b.car_no, b.car_nm, a.*, c.user_nm as bus_nm, d.user_nm as mng_nm, \n"+
				"        decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트','대기') rent_st_nm,   \n"+
				"        decode(a.use_st,'1','예약','2','배차','3','반차','4','종료') use_st_nm, \n"+
				"        decode(f.rent_st,'1','보증금','2','선납대여료','3','대여료','4','정산금','5','연장대여료','') scd_rent_st_nm, \n"+
				"        decode(f.paid_st,'1','현금','2','신용카드','3','자동이체','4','무통장입금','') scd_paid_st_nm, \n"+
				"        NVL(f.est_dt,SUBSTR(a.deli_dt,1,8)) est_dt, (f.rent_s_amt+f.rent_v_amt) rent_amt, \n"+
				"        substr(nvl(a.deli_dt,a.deli_plan_dt),1,8) start_dt, substr(nvl(a.ret_dt,a.ret_plan_dt),1,8) end_dt \n"+
				" from   RENT_CONT a, car_reg b, users c, users d, client e, scd_rent f  \n"+
				" where  a.rent_st='12' AND a.use_st<>'5' \n"+
				"        and a.car_mng_id=b.car_mng_id and a.bus_id=c.user_id and a.mng_id=d.user_id(+) and a.cust_id=e.client_id \n"+
				"        and a.rent_s_cd=f.rent_s_cd \n"+
				"        and f.rent_s_amt>0 and f.pay_dt is null and nvl(f.bill_yn,'Y')='Y' \n"+
				" ";

		if(!user_id.equals(""))			query += " and a.bus_id||a.mng_id like '%"+user_id+"%' ";

		query += " and NVL(f.est_dt,SUBSTR(a.deli_dt,1,8)) < to_char(sysdate+10,'yyyymmdd') ORDER BY decode(a.use_st,'1',1,0), NVL(f.est_dt,SUBSTR(a.deli_dt,1,8)), substr(nvl(a.deli_dt,a.deli_plan_dt),1,8) ";



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getRentMonSettleList]\n"+e);
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

	//정비미확인리스트
	public Vector getServConfList(String br_id, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+ rule */ a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.serv_id, a.accid_id, d.client_id, \n"+
				"        a.serv_dt, a.tot_dist, a.serv_st, \n"+
				"        decode(a.serv_st,'1','순회점검','2','일반정비','3','보증정비','7','재리스정비','4','운행자차','5','사고자차') serv_st_nm, \n"+
				"        a.r_labor, a.r_amt, a.rep_amt, \n"+
				"        b.off_nm, d.firm_nm, e.car_no, e.car_nm, e.car_num, g.user_nm, \n"+
				"        p1.p_st3 pay_st1, p1.p_pay_dt pay_dt1, p1.reqseq||p1.i_seq pay_id1, \n"+
				"        p2.p_st3 pay_st2, p2.p_pay_dt pay_dt2, p2.reqseq||p2.i_seq pay_id2, \n"+
				"        decode(p3.item_code,'','','법인카드') pay_st3, p3.buy_dt pay_dt3, p3.cardno||p3.buy_id pay_id3, \n"+
				"        decode(p4.j_seq,'','',a.jung_st||'회차') pay_st4, p4.pay_dt pay_dt4, \n"+
				"        f.user_id1, to_char(f.user_dt1,'YYYYMMDD') user_dt1, g3.user_nm as user_nm1, "+
				"        f.user_id2, to_char(f.user_dt2,'YYYYMMDD') user_dt2, g4.user_nm as user_nm2, "+
				"        f.user_id3, to_char(f.user_dt3,'YYYYMMDD') user_dt3, g5.user_nm as user_nm3, "+
				"        f.user_id4, to_char(f.user_dt4,'YYYYMMDD') user_dt4, g6.user_nm as user_nm4 "+
				" from   service a, serv_off b, cont c, client d, car_reg e, \n"+
				"        (select * from doc_settle where doc_st='41') f, \n"+
				"        users g, BRANCH g2, users g3, users g4, users g5, users g6,\n"+
				"        /*출금조회*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='11' and a.reqseq=b.reqseq) p1, \n"+
				"        /*출금직접*/(select a.*, b.p_pay_dt from pay_item a, pay b where a.p_gubun='99' and a.reqseq=b.reqseq and a.acct_code in ('45700','45600') and a.p_cd5 is not null) p2, \n"+
				"        /*법인카드*/(select a.*, b.buy_dt from card_doc_item a, card_doc b where a.cardno=b.cardno and a.buy_id=b.buy_id) p3, \n"+
				"        /*정비정산*/(select a.*, a.j_yy||a.j_mm yymm from mj_jungsan a where a.j_g_amt>0 and a.j_yy||a.j_mm > '200912') p4 \n"+
				" where  nvl(a.reg_dt,a.serv_dt) > '20121031' \n"+
				"        and a.off_id=b.off_id and b.car_comp_id in ('0041','0043')\n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and a.car_mng_id||a.serv_id = f.doc_id(+) \n"+
				"        and a.checker=g.user_id \n"+
				"        and g.br_id=g2.br_id \n"+
				"        and f.user_id1=g3.user_id(+) \n"+
				"        and f.user_id2=g4.user_id(+) \n"+
				"        and f.user_id3=g5.user_id(+) \n"+
				"        and f.user_id4=g6.user_id(+) \n"+
				"        and a.car_mng_id=p1.p_cd1(+) and a.serv_id=p1.p_cd2(+)  \n"+
				"        and a.car_mng_id=p2.p_cd3(+) and a.serv_id=p2.p_cd5(+)  \n"+
				"        and a.car_mng_id=p3.item_code(+) and a.serv_id=p3.serv_id(+)  \n"+
				"        and a.off_id=p4.j_acct(+) and a.jung_st=p4.j_seq(+) and substr(a.set_dt,1,6)=p4.yymm(+)  \n"+
				"        and a.rep_amt>0 \n"+
				" ";

		query += " and f.user_dt2 is null \n";

		if(!user_id.equals(""))			query += " and a.checker = '"+user_id+"' ";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getServConfList]\n"+e);
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

	//월렌트 계약개시,만료현황
	public Vector getRmRentMonContList(String br_id, String user_id, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		//개시현황
		if(gubun.equals("1")){

			query = " SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.car_no, B.CAR_NM, c.firm_nm, "+
					"        d.rent_start_dt, d.rent_end_dt, d.con_mon, e.con_day, f1.user_nm AS bus_nm, f2.user_nm AS mng_nm "+
					" FROM   CONT a, CAR_REG b, CLIENT c, FEE d, FEE_ETC e, USERS f1, USERS f2  "+
					" WHERE  a.car_st='4' AND a.use_yn='Y' AND a.rent_l_cd NOT LIKE 'RM%' "+
					"        AND a.car_mng_id=b.car_mng_id AND a.CLIENT_ID=c.client_id "+
					"        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd AND d.RENT_ST='1'     "+
					"        AND d.rent_mng_id=e.rent_mng_id AND d.rent_l_cd=e.rent_l_cd AND d.RENT_ST=e.rent_st "+
					"        AND a.BUS_ID=f1.user_id AND a.MNG_ID=f2.user_id \n"+
					" ";

			//담당자
			if(!user_id.equals(""))			query += " and a.bus_id||a.bus_id2||a.mng_id like '%"+user_id+"%' ";

			query += " and d.rent_start_dt between to_char(sysdate-10,'yyyymmdd') and to_char(sysdate,'yyyymmdd') ";

			query += " order by d.rent_start_dt, c.firm_nm ";

		//만료현황
		}else{
			query = " SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.car_no, B.CAR_NM, c.firm_nm, "+
					"        e.use_s_dt AS rent_start_dt, e.use_e_dt AS rent_end_dt, d.con_mon, d.con_day, f1.user_nm AS bus_nm, f2.user_nm AS mng_nm "+
					" FROM   CONT a, CAR_REG b, CLIENT c, "+
					"        (SELECT a.rent_mng_id, a.rent_l_cd, to_char(sum(a.con_mon)) con_mon, to_char(sum(b.con_day)) con_day FROM FEE a, FEE_ETC b WHERE a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.RENT_ST=b.rent_st GROUP BY a.rent_mng_id, a.rent_l_cd) d, "+
					"        (SELECT rent_mng_id, rent_l_cd, MIN(use_s_dt) use_s_dt, MAX(use_e_dt) use_e_dt FROM SCD_FEE WHERE bill_yn='Y' GROUP BY rent_mng_id, rent_l_cd) e, "+
					"        USERS f1, USERS f2  "+
					" WHERE  a.car_st='4' AND a.use_yn='Y' AND a.rent_l_cd NOT LIKE 'RM%' "+
					"        AND a.car_mng_id=b.car_mng_id AND a.CLIENT_ID=c.client_id "+
					"        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd "+
					"        AND d.rent_mng_id=e.rent_mng_id AND d.rent_l_cd=e.rent_l_cd "+
					"        AND a.BUS_ID=f1.user_id AND a.MNG_ID=f2.user_id \n"+
					" ";

			//담당자
			if(!user_id.equals(""))			query += " and a.bus_id||a.bus_id2||a.mng_id like '%"+user_id+"%' ";

			query += " and ( (e.use_e_dt between to_char(sysdate-10,'yyyymmdd') and to_char(sysdate+10, 'yyyymmdd')) or ( e.use_e_dt < to_char(sysdate-10,'yyyymmdd')) ) ";

			query += " order by e.use_e_dt, c.firm_nm ";

		}



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getRmRentMonContList]\n"+e);
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

	//월렌트 미수스케줄
	public Vector getRmRentMonSettleList(String br_id, String user_id, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.car_no, B.CAR_NM, c.firm_nm, DECODE(a.use_yn,'N','종료','대여') use_st_nm, "+
				"        e.use_s_dt AS rent_start_dt, e.use_e_dt AS rent_end_dt, d.con_mon, d.con_day, f1.user_nm AS bus_nm, f2.user_nm AS mng_nm, "+
				"        e.fee_tm||'회차'||DECODE(e.tm_st1,0,'','잔액') AS scd_rent_st_nm, e.fee_est_dt AS est_dt, e.fee_s_amt+e.fee_v_amt AS rent_amt, g.cms_start_dt, g.reg_st as cms_reg_st "+
				" FROM   CONT a, CAR_REG b, CLIENT c,  "+
				"        (SELECT a.rent_mng_id, a.rent_l_cd, to_char(sum(a.con_mon)) con_mon, to_char(sum(b.con_day)) con_day FROM FEE a, FEE_ETC b WHERE a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.RENT_ST=b.rent_st GROUP BY a.rent_mng_id, a.rent_l_cd) d,  "+
				"        SCD_FEE e,  "+
				"        USERS f1, USERS f2, CMS_MNG g  "+
				" WHERE  a.car_st='4' AND a.use_yn='Y' AND a.rent_l_cd NOT LIKE 'RM%' "+
				"        AND a.car_mng_id=b.car_mng_id AND a.CLIENT_ID=c.client_id "+
				"        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd  "+   
				"        AND d.rent_mng_id=e.rent_mng_id AND d.rent_l_cd=e.rent_l_cd AND NVL(e.bill_yn,'Y')='Y' and e.rc_dt is null "+
				"        AND a.BUS_ID=f1.user_id AND a.MNG_ID=f2.user_id \n"+
				"        AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+)  "+   
				" ";

		if(!user_id.equals(""))			query += " and a.bus_id||a.bus_id2||a.mng_id like '%"+user_id+"%' ";

		query += " and e.fee_est_dt < to_char(sysdate+10,'yyyymmdd') ORDER BY decode(a.use_yn,'N',1,0), e.fee_est_dt, e.use_s_dt ";



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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getRmRentMonSettleList]\n"+e);
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

	//일반식 차량 예상주행거리 5000km 경과 미정비 리스트
	public Vector getLcRentWayGeneralNotServList(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, "+
				"        d.firm_nm, e.car_no, E.CAR_NM, "+
				"        g.f_rent_start_dt, "+
				"        b.rent_start_dt, c.AGREE_DIST, "+
				"        TRUNC(5000/(c.agree_dist/365)) dist_days, "+
				"        TRUNC(sysdate-TO_DATE(b.rent_start_dt,'YYYYMMDD')) start_days, "+
				"        a.bus_id, a.bus_id2, a.mng_id "+
				" from   cont a, fee b, FEE_ETC c, CLIENT d, CAR_REG e, "+
				"        (select rent_mng_id, rent_l_cd, COUNT(0) serv_cnt from service GROUP BY rent_mng_id, rent_l_cd) f, "+
				"        (select client_id, MIN(rent_start_dt) f_rent_start_dt from cont group by client_id) g "+
				" where  a.car_st IN ('1','3') AND a.use_yn='Y' "+
				"        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd and b.rent_st='1' AND b.rent_way='1' "+
				"        AND b.rent_mng_id=c.rent_mng_id AND b.RENT_L_CD=c.rent_l_cd AND b.RENT_ST=c.rent_st "+
				"        AND a.client_id=d.client_id "+
				"        AND a.car_mng_id=e.car_mng_id "+    
				"        AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+) AND NVL(f.serv_cnt,0)=0 "+
				"        AND a.client_id=g.client_id "+
				"        AND c.AGREE_DIST > 0 "+
				"        AND TRUNC(5000/(c.agree_dist/365)) < TRUNC(sysdate-TO_DATE(b.rent_start_dt,'YYYYMMDD')) "+   
				" ";

		if(!user_id.equals(""))			query += " and a.bus_id2 = '"+user_id+"' ";

		query += " order by b.rent_start_dt desc ";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getLcRentWayGeneralNotServList]\n"+e);
			System.out.println("[CusPre_Database:getLcRentWayGeneralNotServList]\n"+query);
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

	/*
	*	당해 자동차 주행거리 10000km 초과 리스트
	*/
	public Vector getOver_10000km(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String who = "";

		if(!user_id.equals("")) who = " and b.mng_id = '"+user_id+"' ";
		else					who = " and b.mng_id is not null ";

		query = " select DISTINCT a.car_mng_id, a.serv_id, a.firm_nm, a.car_no, b.serv_dt, a.next_serv_dt, a.next_rep_cont, a.mng_id, a.off_ls, \n"+
				"        vt.tot_dist AS TOT_DIST, "+
				"        CASE WHEN NVL( vt.tot_dist, '0' ) = '0' THEN 0 WHEN vt.tot_dt = nvl( e.dlv_dt, a.init_reg_dt ) THEN 0 "+
				"             ELSE round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - to_date( nvl( replace(e.dlv_dt, '-', ''), a.init_reg_dt ), 'YYYYMMDD' ))) "+
				"             END AS AVERAGE_DIST, "+
				"        x.today_dist , e.rent_mng_id, e.rent_l_cd, e.fee_rent_st "+ 
				" from \n"+
				"	     ( select d.car_mng_id, d.serv_id, nvl(a.firm_nm,a.client_nm) firm_nm, c.car_no, d.next_serv_dt, d.next_rep_cont, b.mng_id, c.off_ls, c.init_reg_dt \n"+
				"          from   client a, (SELECT DISTINCT client_id,car_mng_id,mng_id FROM cont WHERE use_yn = 'Y') b, car_reg c, service d \n"+
				"	       where  nvl(c.prepare,'0') not in ('4','5') and a.client_id = b.client_id \n"+
				"	              and b.car_mng_id = c.car_mng_id \n"+
				"	              and c.car_mng_id = d.car_mng_id \n"+
				                  who+" ) a, "+
				"        service b, "+
				"		 ( SELECT vt.car_mng_id, vt.tot_dist AS TOT_DIST, decode( vt.tot_dist, \n"+
				"                 '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), \n"+
				"                 0, round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) \n"+
				"                 - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))))) \n"+
				"                 AS AVERAGE_DIST, decode( vt.tot_dist, '', 0, '0', 0, decode( \n"+
				"                 vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist \n"+
				"                 + round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) \n"+
				"                 - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) \n"+
				"                 * ( to_date( to_char( sysdate, 'YYYYMMDD' ), 'YYYYMMDD' ) \n"+
				"                 - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST \n"+
				"          FROM   v_tot_dist vt, cont e, car_reg a  WHERE e.car_mng_id = vt.car_mng_id(+) AND e.car_mng_id = a.car_mng_id ) x, "+
				"		 v_tot_dist vt, cont_n_view e , fee f, "+
				"        ( select car_mng_id, MAX(serv_dt) as serv_dt from SERVICE where  tot_dist >1 and serv_dt is not NULL GROUP BY car_mng_id ) c \n"+
				" where  a.car_mng_id = b.car_mng_id  and a.car_mng_id = x.car_mng_id and e.rent_mng_id = f.rent_mng_id   and e.rent_l_cd = f.rent_l_cd \n"+
				"        AND a.car_mng_id = vt.car_mng_id(+)  AND a.car_mng_id = e.car_mng_id and x.today_dist - vt.tot_dist > 10000 and e.use_yn ='Y' and f.rent_way = '1'\n"+
				"        and a.serv_id  = b.serv_id \n"+
				"        AND b.car_mng_id=c.car_mng_id AND b.serv_dt=c.serv_dt \n"+
				" UNION ALL "+
				" SELECT DISTINCT a.car_mng_id, '', e.FIRM_NM, "+
					  " a.car_no, d.serv_dt, d.next_serv_dt, "+
					   " d.next_rep_cont, b.MNG_ID, '', "+
					   " vt.tot_dist, "+
				" CASE "+
				" WHEN NVL( vt.tot_dist, '0' ) = '0' THEN 0 "+
				" WHEN vt.tot_dt = nvl( b.dlv_dt, a.init_reg_dt ) THEN 0 "+
				" ELSE round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) - "+
				" 	   to_date( nvl( replace( b.dlv_dt, '-', '' ), a.init_reg_dt ), "+
				" 	   'YYYYMMDD' ))) "+
				" END AS AVERAGE_DIST, decode( vt.tot_dist, '', 0, '0', 0, decode( "+
				" 	   vt.tot_dt, nvl( b.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist "+
				" 	   + round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) "+
				" 	   - to_date( nvl( b.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) "+
				" 	   * ( to_date( to_char( sysdate, 'YYYYMMDD' ), 'YYYYMMDD' ) "+
				" 	   - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST, b.RENT_MNG_ID, "+
				" 	   b.RENT_L_CD, '' "+
				" FROM car_reg a, cont b, v_tot_dist vt, "+
				" 	 ( SELECT car_mng_id, next_rep_cont, max( next_serv_dt ) AS next_serv_dt, "+
				" 			  max( serv_dt ) AS serv_dt "+
				" 	   FROM service "+
				" 	   GROUP BY car_mng_id, next_rep_cont ) d, client e, "+
				" 	 ( SELECT a.mng_id, a.car_mng_id, b.user_nm AS mng_nm "+
				" 	   FROM cont a, users b "+
				" 	   WHERE a.use_yn = 'Y' "+
				" 		 AND a.mng_id = b.user_id ) us, "+
				" 	 ( SELECT vt.car_mng_id, vt.tot_dist AS TOT_DIST, decode( vt.tot_dist, "+
				" 			  '', 0, '0', 0, decode( vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), "+
				" 			  0, round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) "+
				" 			  - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))))) "+
				" 			  AS AVERAGE_DIST, decode( vt.tot_dist, '', 0, '0', 0, decode( "+
				" 			  vt.tot_dt, nvl( e.dlv_dt, a.init_reg_dt ), 0, vt.tot_dist "+
				" 			  + round( vt.tot_dist / ( to_date( vt.tot_dt, 'YYYYMMDD' ) "+
				" 			  - to_date( nvl( e.dlv_dt, a.init_reg_dt ), 'YYYYMMDD' ))) "+
				" 			  * ( to_date( to_char( sysdate, 'YYYYMMDD' ), 'YYYYMMDD' ) "+
				" 			  - to_date( vt.tot_dt, 'YYYYMMDD' )))) AS TODAY_DIST "+
				" 	   FROM v_tot_dist vt, cont e, car_reg a "+
				" 	   WHERE e.car_mng_id = vt.car_mng_id(+) "+
				" 		 AND e.car_mng_id = a.car_mng_id ) x "+
				" WHERE nvl( b.use_yn, 'Y' ) = 'Y' "+
				"   AND b.car_st = '2' "+
				"   AND nvl( a.off_ls, '0' ) = '0' "+
				"   AND a.car_mng_id = b.car_mng_id "+
				"   AND b.car_mng_id = d.car_mng_id(+) "+
				"   AND a.car_mng_id = x.car_mng_id(+) "+
				"   AND b.CLIENT_ID = e.CLIENT_ID(+) "+
				"   AND a.car_mng_id = us.car_mng_id(+) "+
				"   AND decode( a.prepare, '', '1', '7', '1', a.prepare ) NOT IN ( '4', '5', '6', '8' )  "+
				"   AND a.car_mng_id = vt.car_mng_id(+) "+
				"   AND d.next_serv_dt <= to_char( sysdate, 'yyyymmdd' ) "+
				"   AND substr( d.next_serv_dt, 1, 4 ) = to_char( sysdate, 'yyyy' ) "+
				who+"   AND x.today_dist - vt.tot_dist >= 10000 ";


		query +="order by next_serv_dt ";				


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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getOver_10000km(String user_id)]\n"+e);
			System.out.println("[CusPre_Database:getOver_10000km(String user_id)]\n"+query);
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

	//현시점 약정주행거리와 예상주행거리 차이가 1000km 이상인 차량 리스트
	public Vector getLcRentAgreeTodayDistCha1000List(String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, b.rent_st, "+
				"        d.firm_nm, e.car_no, E.CAR_NM,  "+
				"        g.f_rent_start_dt, "+
				"        b.rent_start_dt, c.AGREE_DIST, c.sh_km,c.over_bas_km, "+
				"        TRUNC((c.agree_dist/365)*TRUNC(sysdate-TO_DATE(b.rent_start_dt,'YYYYMMDD'))) rent_est_dist, "+
				"        TRUNC(sysdate-TO_DATE(b.rent_start_dt,'YYYYMMDD')) start_days,  "+
				"        TRUNC(decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,e.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,e.init_reg_dt),'YYYYMMDD')))*(sysdate-to_date(vt.tot_dt,'YYYYMMDD'))))) as TODAY_DIST, "+
				"        TRUNC(decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,e.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,e.init_reg_dt),'YYYYMMDD')))*(sysdate-to_date(vt.tot_dt,'YYYYMMDD')))))-TRUNC((c.agree_dist/365)*TRUNC(sysdate-TO_DATE(b.rent_start_dt,'YYYYMMDD')))-DECODE(c.over_bas_km,0,c.sh_km,c.over_bas_km) cha_dist, "+
				"        a.bus_id, a.bus_id2, a.mng_id "+
				" from   cont a, fee b, CLIENT d, CAR_REG e,        "+
				"        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) f, FEE_ETC c,  "+
				"        (select client_id, MIN(rent_start_dt) f_rent_start_dt from cont group by client_id) g, "+
				"         v_tot_dist vt   "+
				" where  a.car_st IN ('1','3') AND a.use_yn='Y'  "+
				"        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd  "+
				"        AND a.client_id=d.client_id "+
				"        AND a.car_mng_id=e.car_mng_id  "+             
				"        AND b.RENT_MNG_ID=f.rent_mng_id AND b.rent_l_cd=f.rent_l_cd AND b.RENT_ST=f.rent_st "+
				"        AND f.rent_mng_id=c.rent_mng_id AND f.RENT_L_CD=c.rent_l_cd AND f.RENT_ST=c.rent_st "+
				"        AND a.client_id=g.client_id "+
				"        AND a.CAR_MNG_ID=vt.car_mng_id(+) "+
				"        AND c.AGREE_DIST > 0  "+
				"        AND e.dist_cng IS null "+
				"        AND TRUNC(decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,e.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,e.init_reg_dt),'YYYYMMDD')))*(sysdate-to_date(vt.tot_dt,'YYYYMMDD')))))-TRUNC((c.agree_dist/365)*TRUNC(sysdate-TO_DATE(b.rent_start_dt,'YYYYMMDD')))-DECODE(c.over_bas_km,0,c.sh_km,c.over_bas_km) > 1000  "+
				" ";

		if(!user_id.equals(""))			query += " and a.bus_id2 = '"+user_id+"' ";

		query += " order by b.rent_start_dt desc ";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getLcRentAgreeTodayDistCha1000List]\n"+e);
			System.out.println("[CusPre_Database:getLcRentAgreeTodayDistCha1000List]\n"+query);
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

		//차량정비 특이사항 
	public Vector getCar_maintReList(String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.*, b.user_nm "+
		 	   " from   car_board a, users  b  "+
			   " where a.reg_id = b.user_id "+   
				" ";

		if(!car_mng_id.equals(""))			query += " and a.car_mng_id = '"+car_mng_id+"' ";

		query += " order by a.reg_dt desc ";

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CusPre_Database:getCar_maintReList]\n"+e);
			System.out.println("[CusPre_Database:getCar_maintReList]\n"+query);
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
	 ** 검사 특이사항 
	 */
	public int insertCusPreComment(String car_mng_id, String user_id, String comment, String rent_mng_id, String rent_l_cd )
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int count = 0;
		int seq = 0;
			 
		String query = "select max(nvl(seq, 0)) + 1  from car_board where car_mng_id='"+car_mng_id + "'" ;

		String query2 = "insert into car_board ( car_mng_id, seq, gubun, reg_id, reg_dt, content , rent_mng_id, rent_l_cd ) " +
		                     " values ( ?, ?, '1', ?, to_char(sysdate,'YYYYMMdd') , ? , ? , ?  )" ;

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				seq = rs.getInt(1);
			}
			rs.close();
		   pstmt.close();
		
			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1,  car_mng_id	);
			pstmt2.setInt(2, seq	);
			pstmt2.setString(3,  user_id	);
			pstmt2.setString(4,  comment	);
			pstmt2.setString(5,  rent_mng_id	);
			pstmt2.setString(6,  rent_l_cd	);
			
			count = pstmt2.executeUpdate();			    
			pstmt2.close();			
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[CusPre_Database:insertCusPreComment]"+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{					
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
                if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}


}