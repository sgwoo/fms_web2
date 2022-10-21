/**
 * 운행차검사관리
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 11. 12. 수.
 * @ last modify date : 
 */
package acar.cus0403;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
import acar.car_maint.*;

public class Cus0403_Database
{
	private Connection conn = null;
	public static Cus0403_Database db;
	
	public static Cus0403_Database getInstance()
	{
		if(Cus0403_Database.db == null)
			Cus0403_Database.db = new Cus0403_Database();
		return Cus0403_Database.db;
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
	*	차량리스트 Bean에 데이터 넣기 2003.11.27.목.
	*/
	 private Cus0403_scBean makeCus0403_scBean(ResultSet results) throws DatabaseException {

        try {
            Cus0403_scBean bean = new Cus0403_scBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));			//자동차관리번호
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));			//계약관리번호
			bean.setRent_l_cd(results.getString("RENT_L_CD"));				//계약번호
			bean.setClient_id(results.getString("CLIENT_ID"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_jnm(results.getString("CAR_JNM"));
			bean.setCar_nm(results.getString("CAR_NM"));
			bean.setBrch_id(results.getString("BRCH_ID"));
			bean.setMng_id(results.getString("MNG_ID"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setRent_start_dt(results.getString("RENT_START_DT"));
			bean.setRent_end_dt(results.getString("RENT_END_DT"));
			bean.setServ_dt(results.getString("SERV_DT"));
			bean.setNext_serv_dt(results.getString("NEXT_SERV_DT"));
			bean.setMaint_st_dt(results.getString("MAINT_ST_DT"));
			bean.setMaint_end_dt(results.getString("MAINT_END_DT"));
			bean.setTot_dist(results.getString("TOT_DIST"));
			bean.setChe_dt(results.getString("CHE_DT"));

			return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	차량리스트 상세정보2 2003.11.11.
	*/
	public Cus0403_scBean[] getCarList(ConditionBean cnd){
		getConnection();
		Collection<Cus0403_scBean> col = new ArrayList<Cus0403_scBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		String subQuery2 = "";
		String orderQuery = "";
		String brchQuery = "";

		if(!cnd.getBr_id().equals("")){
			//brchQuery = " AND b.brch_id = '"+cnd.getBr_id()+"' ";
		}

		//gubun3 세부조회 		//gubun2 상세조회
		if(cnd.getGubun3().equals("N")){
			subQuery += " AND j.mcd IS NULL ";
			if(cnd.getGubun2().equals("1")){
				subQuery += " AND j.med BETWEEN to_char(sysdate-30,'yyyymmdd') AND to_char(sysdate+30,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("2")){
				subQuery += " AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+24,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("3")){
				subQuery += " AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+29,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("4")){
				subQuery += " AND j.med BETWEEN REPLACE('"+ cnd.getSt_dt() +"','-','') AND REPLACE('" + cnd.getEnd_dt() +"','-','') ";
			}else if(cnd.getGubun2().equals("5")){
				
			}
		}else if(cnd.getGubun3().equals("Y")){
			subQuery += " AND j.mcd is not null ";
			if(cnd.getGubun2().equals("1")){
				subQuery += " AND j.med BETWEEN to_char(sysdate-30,'yyyymmdd') AND to_char(sysdate+30,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("2")){
				subQuery += " AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+24,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("3")){
				subQuery += " AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+29,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("4")){
				subQuery += " AND j.med BETWEEN REPLACE('"+ cnd.getSt_dt() +"','-','') AND REPLACE('" + cnd.getEnd_dt() +"','-','') ";
			}else if(cnd.getGubun2().equals("5")){
				
			}
		}else if(cnd.getGubun3().equals("P")){
			subQuery += " AND j.mcd is null ";
			if(cnd.getGubun2().equals("1")){
				subQuery += " AND j.med BETWEEN to_char(sysdate-30,'yyyymmdd') AND to_char(sysdate+30,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("2")){
				subQuery += " AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+24,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("3")){
				subQuery += " AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+29,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd') ";
			}else if(cnd.getGubun2().equals("4")){
				subQuery += " AND j.med BETWEEN REPLACE('"+ cnd.getSt_dt() +"','-','') AND REPLACE('" + cnd.getEnd_dt() +"','-','') ";
			}else if(cnd.getGubun2().equals("5")){
				
			}
		}else{
			subQuery += " ";
		}

		if(!cnd.getT_wd().equals("")){
			switch (AddUtil.parseInt(cnd.getS_kd()))
			{
				case 0 : subQuery2 = " AND a.car_no = '"+cnd.getT_wd()+"' "; break;
				case 1 : subQuery2 = " AND c.firm_nm like '%"+cnd.getT_wd()+"%' "; break;
				case 2 : subQuery2 = " AND c.client_nm like '%"+cnd.getT_wd()+"%' "; break;
				case 3 : subQuery2 = " AND b.rent_l_cd like '%"+cnd.getT_wd()+"%' "; break;
				case 4 : if(cnd.getT_wd().equals("")){
							subQuery2 = " AND a.car_no = '"+cnd.getT_wd()+"'  ";					
						}else{
							subQuery2 = " AND a.car_no like '%"+cnd.getT_wd()+"%' ";
						}
						break;	//최조화면뜰때 조회건없도록...
				case 5 : subQuery2 = " AND a.car_num like '%"+cnd.getT_wd()+"%' "; break;
				case 6 : subQuery2 = " AND b.brch_id = '"+cnd.getT_wd()+"' "; break;
				case 7 : subQuery2 = " AND h.r_site like '%"+cnd.getT_wd()+"%' "; break;
				case 8 : subQuery2 = " AND b.mng_id = '"+cnd.getT_wd()+"' "; break;
				case 9 : subQuery2 = " AND e.car_name like '%"+cnd.getT_wd()+"%' "; break;
				case 10 : subQuery2 = " AND b.bus_id = '"+cnd.getT_wd()+"' AND f.rent_way='2' "; break;
				default : subQuery2 = " "; break;
			}
		}
		
		if(cnd.getSort_gubun().equals("")){
			orderQuery = "";
		}else{
			if(cnd.getSort_gubun().equals("1")){
				orderQuery = " ORDER BY firm_nm "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("2")){
				orderQuery = " ORDER BY car_no "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("3")){
				orderQuery = " ORDER BY car_nm "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("4")){
				orderQuery = " ORDER BY maint_end_dt "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("5")){
				orderQuery = " ORDER BY che_dt "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("6")){
				orderQuery = " ORDER BY init_reg_dt "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("7")){
				orderQuery = " ORDER BY maint_st_dt "+cnd.getAsc();
			}else{
				orderQuery = "";
			}
		}

		query = "SELECT "+
			"	        a.car_mng_id car_mng_id, b.rent_mng_id rent_mng_id, b.rent_l_cd rent_l_cd,  \n"+  
			"           c.client_id CLIENT_ID, DECODE(c.firm_nm,'',c.client_nm,c.firm_nm) firm_nm, \n"+  
			"           a.car_no car_no, n.car_nm CAR_JNM, e.car_name car_nm, b.brch_id brch_id, b.mng_id mng_id,  \n"+  
			"           a.init_reg_dt init_reg_dt, f.rent_start_dt rent_start_dt, f.rent_end_dt rent_end_dt, g.serv_dt serv_dt, g.next_serv_dt next_serv_dt,  \n"+  
			"           a.maint_st_dt MAINT_ST_DT, a.maint_end_dt MAINT_END_DT, g.tot_dist TOT_DIST, j.che_dt CHE_DT  \n"+  
			" FROM car_reg a, cont b, client c, car_etc d, car_nm e, car_mng n, client_site h, \n"+  
		//	" FROM car_reg a, cont b, client c, car_etc d, car_nm e, car_mng n, client_site h, v_car_maint j,  \n"+  
			"	(select * from fee a where rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id = rent_mng_id and a.rent_l_cd=rent_l_cd)) f, \n"+  
			"	(select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) g,  \n"+  
			"	(select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) i,  \n"+  
		//	"	(select * from v_car_maint where seq_no = (select max(seq_no) from car_maint where a.car_mng_id = car_mng_id)) j "+
			"	(select * from car_maint a  where seq_no = (select max(seq_no) from car_maint where a.car_mng_id = car_mng_id)) j "+
			" WHERE a.car_mng_id = b.car_mng_id  \n"+  
			" AND nvl(b.use_yn,'Y') = 'Y'  \n"+  
			" AND b.client_id = c.client_id  \n"+  
			" AND b.rent_mng_id = d.rent_mng_id  \n"+  
			" AND b.rent_l_cd = d.rent_l_cd  \n"+  
			" AND b.rent_mng_id = f.rent_mng_id(+)  \n"+  
			" AND b.rent_l_cd = f.rent_l_cd(+)  \n"+  
			" AND d.car_id= e.car_id  \n"+  
			" AND d.car_seq = e.car_seq  \n"+  
			" AND e.car_comp_id = n.car_comp_id  \n"+  
			" AND e.car_cd = n.code  \n"+  
			" AND a.car_mng_id = g.car_mng_id(+)  \n"+  
			" AND b.client_id = h.client_id(+)  \n"+  
			" AND b.r_site = h.seq(+)  \n"+  
			" AND b.client_id = i.client_id(+)  \n"+  
			" AND a.car_mng_id = j.car_mng_id(+)  \n"+  
	

			brchQuery+
			subQuery +
			subQuery2 +
			orderQuery;


		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeCus0403_scBean(rs));
			}
		    rs.close();
            pstmt.close();	

		}catch(SQLException e){
			System.out.println("[Cus0403_Database:getCarList(ConditionBean cnd)]"+e);
			System.out.println("[Cus0403_Database:getCarList(ConditionBean cnd)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Cus0403_scBean[])col.toArray(new Cus0403_scBean[0]);
		}		
	}


	/**
	*	차량리스트 스케쥴 2003.11.11.
	*/
	public Cus0403_scBean[] getCarListYM(String year, String mon,String user_id){
		getConnection();
		Collection<Cus0403_scBean> col = new ArrayList<Cus0403_scBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.car_mng_id car_mng_id, b.rent_mng_id rent_mng_id, b.rent_l_cd rent_l_cd, c.client_id CLIENT_ID, DECODE(c.firm_nm,'',c.client_nm,c.firm_nm) firm_nm, a.car_no car_no, n.car_nm CAR_JNM, e.car_name CAR_NM, b.brch_id brch_id, b.mng_id mng_id  \n"+  
			" ,a.init_reg_dt init_reg_dt, f.rent_start_dt rent_start_dt, f.rent_end_dt rent_end_dt, g.serv_dt serv_dt, g.next_serv_dt next_serv_dt, nvl(j.che_st_dt,a.maint_st_dt) MAINT_ST_DT, nvl(j.che_end_dt,a.maint_end_dt) MAINT_END_DT, g.tot_dist TOT_DIST, j.che_dt CHE_DT  \n"+  
			" FROM car_reg a, cont b, client c, car_etc d, car_nm e, car_mng n, client_site h,  \n"+  
			"	(select * from fee a where rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id = rent_mng_id and a.rent_l_cd=rent_l_cd)) f, "+
			"	(select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) g,  \n"+  
			"	(select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) i,  \n"+  
			"	(select * from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id = car_mng_id)) j  \n"+  
			" WHERE a.car_mng_id = b.car_mng_id  \n"+  
			" AND nvl(b.use_yn,'Y') = 'Y'  \n"+  
			" AND b.client_id = c.client_id  \n"+  
			" AND b.rent_mng_id = d.rent_mng_id  \n"+  
			" AND b.rent_l_cd = d.rent_l_cd  \n"+  
			" AND b.rent_mng_id = f.rent_mng_id(+)  \n"+  
			" AND b.rent_l_cd = f.rent_l_cd(+)  \n"+  
			" AND d.car_id = e.car_id  \n"+  
			" AND d.car_seq = e.car_seq  \n"+  
			" AND e.car_comp_id = n.car_comp_id  \n"+  
			" AND e.car_cd = n.code  \n"+  
			" AND a.car_mng_id = g.car_mng_id(+)  \n"+  
			" AND b.client_id = h.client_id(+)  \n"+  
			" AND b.r_site = h.seq(+)  \n"+  
			" AND b.client_id = i.client_id(+)  \n"+  
			" AND a.car_mng_id = j.car_mng_id(+)  \n"+  
			" AND b.mng_id = '"+user_id+"'  \n"+  
			" AND nvl(j.che_end_dt,a.maint_end_dt like '"+year+mon+"%'";
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeCus0403_scBean(rs));
			}
		    rs.close();
            pstmt.close();	
		}catch(SQLException e){
			System.out.println("[Cus0403_Database:getCarListYM(String year, String mon)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Cus0403_scBean[])col.toArray(new Cus0403_scBean[0]);
		}		
	}

	/**
	*	처리완료된 정기검사 스케쥴 2003.12.17.
	*/
	public Cus0403_scBean[] getCarListYM_cmplt(String year, String mon,String user_id){
		getConnection();
		Collection<Cus0403_scBean> col = new ArrayList<Cus0403_scBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.car_mng_id car_mng_id, b.rent_mng_id rent_mng_id, b.rent_l_cd rent_l_cd, c.client_id CLIENT_ID, DECODE(c.firm_nm,'',c.client_nm,c.firm_nm) firm_nm, a.car_no car_no, e.car_name car_nm, b.brch_id brch_id, b.mng_id mng_id  \n"+  
			" ,a.init_reg_dt init_reg_dt, f.rent_start_dt rent_start_dt, f.rent_end_dt rent_end_dt, g.serv_dt serv_dt, g.next_serv_dt next_serv_dt, nvl(j.che_st_dt,a.maint_st_dt) MAINT_ST_DT, nvl(j.che_end_dt,a.maint_end_dt) MAINT_END_DT, g.tot_dist TOT_DIST, j.che_dt CHE_DT  \n"+  
			" FROM car_reg a, cont b, client c, car_etc d, car_nm e, client_site h,  \n"+  
			"	(select * from fee a where rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id = rent_mng_id and a.rent_l_cd=rent_l_cd)) f,  \n"+  
			"	(select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) g,  \n"+  
			"	(select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) i,  \n"+  
			"	(select * from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id = car_mng_id)) j  \n"+  
			" WHERE a.car_mng_id = b.car_mng_id  \n"+  
			" AND nvl(b.use_yn,'Y') = 'Y'  \n"+  
			" AND b.client_id = c.client_id  \n"+  
			" AND b.rent_mng_id = d.rent_mng_id  \n"+  
			" AND b.rent_l_cd = d.rent_l_cd  \n"+  
			" AND b.rent_mng_id = f.rent_mng_id(+)  \n"+  
			" AND b.rent_l_cd = f.rent_l_cd(+)  \n"+  
			" AND d.car_id= e.car_id(+)  \n"+  
			" AND a.car_mng_id = g.car_mng_id(+)  \n"+  
			" AND b.client_id = h.client_id(+) \n"+  
			" AND b.r_site = h.seq(+)  \n"+  
			" AND b.client_id = i.client_id(+)  \n"+  
			" AND a.car_mng_id = j.car_mng_id(+)  \n"+  
			" AND b.mng_id = '"+user_id+"'  \n"+  
			" AND nvl(j.che_end_dt,a.maint_end_dt) like '"+year+mon+"%'";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeCus0403_scBean(rs));
			}
		    rs.close();
            pstmt.close();	
		}catch(SQLException e){
			System.out.println("[Cus0403_Database:getCarListYM(String year, String mon)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Cus0403_scBean[])col.toArray(new Cus0403_scBean[0]);
		}		
	}

	/**
	*	업무추진현황 - 2003.12.03.수.
	* cus0402에서 cus0403으로 옮김. Yongsoon Kwon. 20041105.
	*/
	public int[] getUpChu(ConditionBean cnd){
		getConnection();
		int tg[] = new int[7];
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

		query = "select a.p_mc, b.v_mc, c.ns_mc, d.s_mc, e.a_mc, f.nm_mc, g.m_mc  \n"+   
				" from  (select count(0) p_mc	  	from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT  		 FROM cont b, client c, (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d WHERE b.client_id = c.client_id AND nvl(b.use_yn,'Y') = 'Y'   "+subQuery2+" 		 AND c.client_id = d.client_id(+)  	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)	WHERE  vst_est_dt like to_char(sysdate,'yyyymm')||'%') a,   \n"+  
				"		(select count(0) v_mc		from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT  		 FROM cont b, client c, (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d WHERE b.client_id = c.client_id AND nvl(b.use_yn,'Y') = 'Y'   "+subQuery2+" 		 AND c.client_id = d.client_id(+)  	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt) WHERE  vst_dt like to_char(sysdate,'yyyymm')||'%') b, \n"+  
				"		(select count(0) ns_mc		from cont b, car_reg d, (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) c where b.car_mng_id = c.car_mng_id(+) and b.car_mng_id = d.car_mng_id and nvl(b.use_yn,'Y') = 'Y' AND substr(next_serv_dt,1,6) <= to_char(sysdate,'yyyymm') "+subQuery2+" ) c,  \n"+  
				"		(select count(0) s_mc		from cont b,car_reg d, 	(select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) c where b.car_mng_id = c.car_mng_id(+) and b.car_mng_id = d.car_mng_id and nvl(b.use_yn,'Y') = 'Y' AND to_date(serv_dt,'YYYYMMDD') <= sysdate AND serv_dt like to_char(sysdate,'yyyymm')||'%' "+subQuery2+" ) d,  \n"+  
				"		(select count(0) a_mc from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%' ) e,  \n"+  
				"		(select count(0) nm_mc from v_car_maint where mcd is null AND med BETWEEN to_char(sysdate-30,'yyyymmdd') AND to_char(sysdate+30,'yyyymmdd')  ) f,  \n"+  
				"		(select count(0) m_mc from v_car_maint where mcd is not null AND med BETWEEN to_char(sysdate-30,'yyyymmdd') AND to_char(sysdate+30,'yyyymmdd')  ) g ";
		try{
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				while(rs.next()){
					tg[0] = rs.getInt("P_MC");
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
				System.out.println("[Cus0403_Database:getUpChu(ConditionBean cnd)]"+e);
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


		query = "select a.nv_mc, b.v_mc, c.ns_mc, d.s_mc, e.a_mc, f.nm_mc, g.m_mc   \n"+  
				" from   	(select count(0) nv_mc   	from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client C, (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d   		 WHERE b.client_id = c.client_id AND nvl(b.use_yn,'Y') = 'Y'   "+subQuery2+"		 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where vst_est_dt = to_char(sysdate,'yyyymmdd')) a,    \n"+  
				"			(select count(0) v_mc		from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client C, (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d   		 WHERE b.client_id = c.client_id AND nvl(b.use_yn,'Y') = 'Y'   "+subQuery2+"		 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where vst_dt = to_char(sysdate,'yyyymmdd')) b,   \n"+   
				"			(select count(0) ns_mc		from cont a, car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and nvl(a.use_yn,'Y') = 'Y'  AND next_serv_dt = to_char(sysdate,'yyyymmdd') "+subQuery2+" ) c,   \n"+  
				"			(select count(0) s_mc		from cont a,car_reg c, 		 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and nvl(a.use_yn,'Y') = 'Y'  AND serv_dt = to_char(sysdate,'yyyymmdd') "+subQuery2+" ) d,   \n"+  
				"			(select count(0) a_mc       from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%') e,   \n"+    
				"			(select count(0) nm_mc      from v_car_maint where mcd is null AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+24,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd')  ) f,   \n"+   
				"			(select count(0) m_mc       from v_car_maint where mcd is not null AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+24,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd')  ) g";
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
				System.out.println("[Cus0403_Database:getUpChu_dd(ConditionBean cnd)]"+e);
				System.out.println("[Cus0403_Database:getUpChu_dd(ConditionBean cnd)]"+query);
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

		query = "select a.nv_mc, b.v_mc, c.ns_mc, d.s_mc, e.a_mc, f.nm_mc, g.m_mc \n"+  
				" from   	(select count(0) nv_mc   	from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client c, (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d  WHERE b.client_id = c.client_id AND nvl(b.use_yn,'Y') = 'Y'   	"+subQuery2+"	 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where vst_est_dt < to_char(sysdate,'yyyymmdd')) a,    \n"+  
				"			(select count(0) v_mc		from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client c, (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d  WHERE b.client_id = c.client_id AND nvl(b.use_yn,'Y') = 'Y'   	"+subQuery2+"	 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where vst_est_dt < to_char(sysdate,'yyyymmdd') and vst_dt = to_char(sysdate,'yyyymmdd')) b,   \n"+  
				"			(select count(0) ns_mc		from cont a, car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and nvl(a.use_yn,'Y') = 'Y'  AND next_serv_dt < to_char(sysdate,'yyyymmdd') "+subQuery2+" ) c,	 \n"+  
				"			(select count(0) s_mc		from cont a,car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and nvl(a.use_yn,'Y') = 'Y'  AND serv_dt = to_char(sysdate,'yyyymmdd') "+subQuery2+" ) d,   \n"+  
				"			(select count(0) a_mc from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%') e,  \n"+  
				"			(select count(0) nm_mc from v_car_maint where mcd is null AND to_char(sysdate,'yyyymmdd') BETWEEN to_char(to_date(med,'yyyymmdd')+29,'yyyymmdd')	AND to_char(to_date(med,'yyyymmdd')+30,'yyyymmdd') ) f,   \n"+  
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
				System.out.println("[Cus0403_Database:getUpChu_delay(ConditionBean cnd)]"+e);
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

		query = "select a.nv_mc, b.v_mc, c.ns_mc, d.s_mc, e.a_mc, f.nm_mc, g.m_mc  \n"+  
				" from   	(select count(0) nv_mc   	from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client C   		 	  , (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d   		 WHERE b.client_id = c.client_id AND nvl(b.use_yn,'Y') = 'Y'   	"+subQuery2+"	 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)  	 where  nvl(substr(vst_est_dt,1,6),'199901') <= to_char(sysdate,'yyyymm')) a,    \n"+  
				"			(select count(0) v_mc		from (SELECT C.CLIENT_ID CLIENT_ID, d.vst_dt VST_DT, d.vst_est_dt VST_EST_DT   		 FROM cont b, client C   		 	  , (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) d   		 WHERE b.client_id = c.client_id AND nvl(b.use_yn,'Y') = 'Y'   	"+subQuery2+"	 AND c.client_id = d.client_id(+)   	 	 GROUP BY C.CLIENT_ID , d.vst_dt, d.vst_est_dt)		where  to_date(vst_est_dt,'YYYYMMDD') > sysdate       AND vst_dt like to_char(sysdate,'yyyymm')||'%'  ) b,   \n"+  
			    "			(select count(0) ns_mc		from cont a, car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and nvl(a.use_yn,'Y') = 'Y'  AND nvl(substr(next_serv_dt,1,6),'199901') <= substr(to_char(sysdate,'yyyymm'),1,6) "+subQuery2+" ) c,   \n"+  
				"			(select count(0) s_mc		from cont a,car_reg c,  	 (select * from service a where serv_id = (select max(serv_id) from service where a.car_mng_id = car_mng_id)) b  where a.car_mng_id = b.car_mng_id(+)  and a.car_mng_id = c.car_mng_id  and nvl(a.use_yn,'Y') = 'Y'  AND b.next_serv_dt > to_char(sysdate,'YYYYMMDD')  AND serv_dt like to_char(sysdate,'yyyymm')||'%' "+subQuery2+" ) d,   \n"+  
				"			(select count(0) a_mc from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%') e,   \n"+  
				"			(select count(0) nm_mc		from car_reg a, cont b,  	(select * from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id = car_mng_id)) j  where a.car_mng_id = b.car_mng_id   and a.car_mng_id = j.car_mng_id(+)  and nvl(b.use_yn,'Y') = 'Y'   AND j.che_dt IS NULL  ) f,   \n"+  
				"			(select count(0) m_mc   	from car_reg a, cont b,  	(select * from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id = car_mng_id)) j  where a.car_mng_id = b.car_mng_id   and a.car_mng_id = j.car_mng_id(+)  and nvl(b.use_yn,'Y') = 'Y'   AND j.che_dt < to_char(sysdate,'YYYYMMDD')  ) g ";


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
				System.out.println("[Cus0403_Database:getUpChu_total(ConditionBean cnd)]"+e);
				System.out.println("[Cus0403_Database:getUpChu_total(ConditionBean cnd)]"+query);
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

}
