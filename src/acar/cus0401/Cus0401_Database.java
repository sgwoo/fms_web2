/**
 * 고객관리 차량리스트
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 10. 15. Wed.
 * @ last modify date : 
 */
package acar.cus0401;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
import acar.cont.*;

public class Cus0401_Database
{
	private Connection conn = null;
	public static Cus0401_Database db;
	
	public static Cus0401_Database getInstance()
	{
		if(Cus0401_Database.db == null)
			Cus0401_Database.db = new Cus0401_Database();
		return Cus0401_Database.db;
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
	*	차량리스트 Bean에 데이터 넣기 2003.10.15. Wed.
	*/
	 private Cus0401_scBean makeCus0401_scBean(ResultSet results) throws DatabaseException {

        try {
            Cus0401_scBean bean = new Cus0401_scBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));			//자동차관리번호
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));			//계약관리번호
			bean.setRent_l_cd(results.getString("RENT_L_CD"));				//계약번호
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_jnm(results.getString("CAR_JNM"));					//차종명
			bean.setCar_nm(results.getString("CAR_NM"));
			bean.setBrch_id(results.getString("BRCH_ID"));
			bean.setMng_id(results.getString("MNG_ID"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setRent_start_dt(results.getString("RENT_START_DT"));
			bean.setRent_end_dt(results.getString("RENT_END_DT"));
			bean.setServ_id(results.getString("SERV_ID"));
			bean.setServ_dt(results.getString("SERV_DT"));
			bean.setNext_serv_dt(results.getString("NEXT_SERV_DT"));
			bean.setTot_dist(results.getString("TOT_DIST"));
			bean.setAverage_dist(results.getString("AVERAGE_DIST"));
			bean.setToday_dist(results.getString("TODAY_DIST"));
			bean.setRent_way(results.getString("RENT_WAY"));

			return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	차량정보 Bean에 데이터 넣기 2003.10.21. Tue.
	*/
	 private Cus0401_carinfoBean makeCus0401_carinfoBean(ResultSet results) throws DatabaseException {

        try {
            Cus0401_carinfoBean bean = new Cus0401_carinfoBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));			//자동차관리번호
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));			//계약관리번호
			bean.setRent_l_cd(results.getString("RENT_L_CD"));				//계약번호
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setCar_jnm(results.getString("CAR_JNM"));
			bean.setCar_nm(results.getString("CAR_NM"));
			bean.setCar_num(results.getString("CAR_NUM"));
			bean.setInit_reg_dt(results.getString("INIT_REG_DT"));
			bean.setCar_kd(results.getString("CAR_KD"));
			bean.setCar_use(results.getString("CAR_USE"));
			bean.setCar_form(results.getString("CAR_FORM"));
			bean.setCar_y_form(results.getString("CAR_Y_FORM"));
			bean.setMot_form(results.getString("MOT_FORM"));
			bean.setColo(results.getString("COLO"));
			bean.setDpm(results.getString("DPM"));
			bean.setConti_rat(results.getString("CONTI_RAT"));
			bean.setFuel_kd(results.getString("FUEL_KD"));
			bean.setAge_scp(results.getString("AGE_SCP"));
			bean.setIns_com_nm(results.getString("INS_COM_NM"));
			bean.setIns_start_dt(results.getString("INS_START_DT"));
			bean.setIns_exp_dt(results.getString("INS_EXP_DT"));
			bean.setAgnt_imgn_tel(results.getString("AGNT_IMGN_TEL"));
			bean.setAcc_tel(results.getString("ACC_TEL"));
			bean.setVins_spe(results.getString("VINS_SPE"));
			bean.setVins_cacdt_amt(results.getString("VINS_CACDT_AMT"));
			bean.setChe_st_dt(results.getString("CHE_ST_DT"));
			bean.setChe_end_dt(results.getString("CHE_END_DT"));

			return bean;

        }catch (SQLException e) {
			System.out.println("[Cus0401_Database:makeCus0401_carinfoBean(ResultSet results)]"+e);
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	차량진단 Bean에 데이터 넣기 2003.12.23. 화.
	*/
	 private SpeedCheckBean makeSpeedCheckBean(ResultSet results) throws DatabaseException {

        try {
            SpeedCheckBean bean = new SpeedCheckBean();

		    bean.setChk_id(results.getString("CHK_ID"));
			bean.setChk_nm(results.getString("CHK_NM"));
			bean.setChk_cont(results.getString("CHK_CONT"));

			return bean;

        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
	*	차량리스트 상세정보2 2003.11.11.
	*/
	public Cus0401_scBean[] getCarList(ConditionBean cnd){

		getConnection();
		Collection<Cus0401_scBean> col = new ArrayList<Cus0401_scBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		String subQuery2 = "";
		String orderQuery = "";
		String brchQuery = "";

		//gubun3 N:미정비, Y:정비, P:계획
		//gubun2 1:당월, 2:당일, 3:연기, 4:기간, 5:검색
		if(cnd.getGubun3().equals("N")){
			subQuery += " AND g.serv_dt is null  \n";
			if(cnd.getGubun2().equals("1")){
				subQuery += " AND s.next_serv_dt like to_char(sysdate,'yyyymm')||'%'  \n";
			}else if(cnd.getGubun2().equals("2")){
				subQuery += " AND s.next_serv_dt = to_char(sysdate,'yyyymmdd')  \n";
			}else if(cnd.getGubun2().equals("4")){
				if(!cnd.getSt_dt().equals("")){	
					subQuery += " AND s.next_serv_dt BETWEEN replace('"+cnd.getSt_dt()+"','-','') AND replace('"+cnd.getEnd_dt()+"','-','')  \n";
				}
			}else if(cnd.getGubun2().equals("5")){
				subQuery += "";
			}else{
				subQuery += "";
			}
		}else if(cnd.getGubun3().equals("Y")){
			if(cnd.getGubun2().equals("1")){
				subQuery += " AND g.serv_dt like to_char(sysdate,'yyyymm')||'%'  \n";
			}else if(cnd.getGubun2().equals("2")){
				subQuery += " AND g.serv_dt = to_char(sysdate,'yyyymmdd' \n) ";
			}else if(cnd.getGubun2().equals("4")){
				if(!cnd.getSt_dt().equals("")){		
					subQuery += " AND g.serv_dt BETWEEN replace('"+cnd.getSt_dt()+"','-','') AND replace('"+cnd.getEnd_dt()+"','-','')  \n";
				}
			}else if(cnd.getGubun2().equals("5")){
				subQuery += "";
			}else{
				subQuery += "";
			}
		}else if(cnd.getGubun3().equals("P")){
			if(cnd.getGubun2().equals("1")){
				subQuery += " AND nvl(s.next_serv_dt,g.serv_dt) like to_char(sysdate,'yyyymm')||'%' \n";
			}else if(cnd.getGubun2().equals("2")){
				subQuery += " AND nvl(s.next_serv_dt,g.serv_dt) = to_char(sysdate,'yyyymmdd')  \n";
			}else if(cnd.getGubun2().equals("4")){
				if(!cnd.getSt_dt().equals("")){	
					subQuery += " AND nvl(s.next_serv_dt,g.serv_dt) BETWEEN replace('"+cnd.getSt_dt()+"','-','') AND replace('"+cnd.getEnd_dt()+"','-','')  \n";
				}
			}else if(cnd.getGubun2().equals("5")){
				subQuery += "";
			}else{
				subQuery += "";
			}
		}else{
			subQuery += " ";
		}

		if(cnd.getGubun4().equals("1")){				subQuery += " and nvl(b.use_yn,'Y')='Y' AND b.car_st='1' \n";
		}else if(cnd.getGubun4().equals("2")){			subQuery += " and nvl(b.use_yn,'Y')='Y' AND b.car_st='3' \n";
		}else if(cnd.getGubun4().equals("3")){			subQuery += " and nvl(b.use_yn,'Y')='Y' AND f.rent_way='1' \n";
		}else if(cnd.getGubun4().equals("4")){			subQuery += " and nvl(b.use_yn,'Y')='Y' AND f.rent_way<>'1' \n";
		}else if(cnd.getGubun4().equals("5")){			subQuery += " and nvl(b.use_yn,'Y')='Y' \n";
		}else if(cnd.getGubun4().equals("6")){			subQuery += " and nvl(b.use_yn,'Y')='N' \n";
		}
		
		if(!cnd.getT_wd().equals("")){
			switch (AddUtil.parseInt(cnd.getS_kd()))
			{
				case 0  : subQuery2 = " AND a.car_no = '"+cnd.getT_wd()+"'  \n";			break;	//최조화면뜰때 조회건없도록...
				case 1  : subQuery2 = " AND c.firm_nm like '%"+cnd.getT_wd()+"%'  \n";		break;
				case 2  : subQuery2 = " AND c.client_nm like '%"+cnd.getT_wd()+"%'  \n";	break;
				case 3  : subQuery2 = " AND b.rent_l_cd like '%"+cnd.getT_wd()+"%'  \n";	break;
				case 4  : subQuery2 = " AND a.car_no like '%"+cnd.getT_wd()+"%'  \n";		break;
				case 5  : subQuery2 = " AND a.car_num like '%"+cnd.getT_wd()+"%'  \n";		break;
				case 6  : subQuery2 = " AND b.brch_id = '"+cnd.getT_wd()+"'  \n";			break;
				case 7  : subQuery2 = " AND h.r_site like '%"+cnd.getT_wd()+"%'  \n";		break;
				case 8  : subQuery2 = " AND b.mng_id = '"+cnd.getT_wd()+"'  \n";			break;
				case 9  : subQuery2 = " AND e.car_name like '%"+cnd.getT_wd()+"%'  \n";		break;
				case 10 : subQuery2 = " AND b.bus_id2 = '"+cnd.getT_wd()+"'  \n";			break;
				case 11 : subQuery2 = " AND b.bus_id = '"+cnd.getT_wd()+"'  \n";			break;
				default : subQuery2 = " ";													break;
			}
		}



		//정렬
		if(cnd.getSort_gubun().equals("")){
			orderQuery = "";
		}else{
			if(cnd.getSort_gubun().equals("0")){
				orderQuery = " ORDER BY rent_l_cd "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("1")){
				orderQuery = " ORDER BY firm_nm "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("2")){
				orderQuery = " ORDER BY car_no "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("3")){
				orderQuery = " ORDER BY car_nm "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("4")){
				orderQuery = " ORDER BY serv_dt "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("5")){
				orderQuery = " ORDER BY next_serv_dt "+cnd.getAsc();
			}else if(cnd.getSort_gubun().equals("6")){
				orderQuery = " ORDER BY init_reg_dt "+cnd.getAsc();
			}else{
				orderQuery = "";
			}			
		}
		
		query = " SELECT a.car_mng_id car_mng_id, b.rent_mng_id rent_mng_id, b.rent_l_cd rent_l_cd,DECODE(c.firm_nm,'',c.client_nm,c.firm_nm) firm_nm, \n"+
				"        a.car_no car_no, n.car_nm car_jnm, e.car_name car_nm, b.brch_id brch_id, b.mng_id mng_id,  \n"+
				"        a.init_reg_dt init_reg_dt, f.rent_start_dt rent_start_dt, f.rent_end_dt rent_end_dt, f.rent_way,  \n"+
				"        g.serv_id SERV_ID, g.serv_dt serv_dt, s.next_serv_dt next_serv_dt,  \n"+
				"        vt.tot_dist TOT_DIST,  \n"+
			//	"        decode(vt.tot_dist,'',0,0,0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST,  \n"+
			//	"        decode(vt.tot_dist,'',0,0,0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST,  \n"+
				"       0  as AVERAGE_DIST,  \n"+
				"       0  as TODAY_DIST  \n"+
				" FROM   car_reg a, cont b, client c, car_etc d, car_nm e, car_mng n, client_site h, v_tot_dist vt,  \n"+  
				"        (select * from service a where next_serv_dt = (select min(next_serv_dt) from service where a.car_mng_id = car_mng_id and serv_dt is null)) s,  \n"+
				"	     (select * from fee a where rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id = rent_mng_id and a.rent_l_cd=rent_l_cd)) f,  \n"+
				"	     (select * from service a where a.tot_dist is not null and a.serv_dt||a.serv_id = (select max(serv_dt||serv_id) from service where a.car_mng_id = car_mng_id and serv_dt is not null and tot_dist is not null)) g,  \n"+
				"	     (select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) i,  \n"+
				"        (select car_mng_id, max(decode(use_yn,'N','0','1')||reg_dt) max_reg_dt from cont where car_st<>'4' group by car_mng_id) b2"+		
				" WHERE  a.car_mng_id = b.car_mng_id  \n"+
				"        AND b.client_id = c.client_id  \n"+
				"        AND b.rent_mng_id = d.rent_mng_id AND b.rent_l_cd = d.rent_l_cd  \n"+
				"        AND b.rent_mng_id = f.rent_mng_id  AND b.rent_l_cd = f.rent_l_cd  \n"+
				"        AND d.car_id= e.car_id AND d.car_seq = e.car_seq  \n"+
				"        AND e.car_comp_id = n.car_comp_id AND e.car_cd = n.code  \n"+
				"        AND b.car_mng_id = g.car_mng_id(+) and b.rent_mng_id=g.rent_mng_id(+) and b.rent_l_cd=g.rent_l_cd(+) \n"+
				"        AND b.client_id = h.client_id(+) AND b.r_site = h.seq(+)  \n"+
				"        AND a.car_mng_id = vt.car_mng_id(+)  \n"+
				"        AND b.client_id = i.client_id(+)  \n"+
				"        AND b.car_mng_id = s.car_mng_id(+) and b.rent_mng_id=s.rent_mng_id(+) and b.rent_l_cd=s.rent_l_cd(+) \n"+
				"        AND b.car_mng_id=b2.car_mng_id and decode(b.use_yn,'N','0','1')||b.reg_dt=b2.max_reg_dt \n"+
				brchQuery+
				subQuery +
				subQuery2 +
				orderQuery;

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeCus0401_scBean(rs));
			}
            rs.close();
            pstmt.close();



		}catch(SQLException e){
			System.out.println("[Cus0401_Database:getCarList(ConditionBean cnd)]"+e);
			System.out.println("[Cus0401_Database:getCarList(ConditionBean cnd)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Cus0401_scBean[])col.toArray(new Cus0401_scBean[0]);
		}		
	}

	/**
	*	차량리스트 상세정보 2003.10.15.
	*/
	public Cus0401_carinfoBean getCarinfo(String car_mng_id){
		getConnection();
		Cus0401_carinfoBean carinfo = new Cus0401_carinfoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.car_mng_id CAR_MNG_ID, b.rent_mng_id RENT_MNG_ID, b.rent_l_cd RENT_L_CD, a.car_no CAR_NO, n.car_nm CAR_JNM, d.car_name CAR_NM, a.car_num CAR_NUM, a.init_reg_dt INIT_REG_DT, a.car_kd CAR_KD, a.car_use CAR_USE, a.car_form CAR_FORM, a.car_y_form CAR_Y_FORM, a.mot_form MOT_FORM, c.colo COLO, a.dpm DPM, a.conti_rat CONTI_RAT, a.fuel_kd FUEL_KD, e.age_scp AGE_SCP, e.ins_com_nm INS_COM_NM, e.ins_start_dt INS_START_DT, e.ins_exp_dt INS_EXP_DT, e.agnt_imgn_tel AGNT_IMGN_TEL, e.acc_tel ACC_TEL, e.vins_spe VINS_SPE, e.vins_cacdt_amt VINS_CACDT_AMT, f.che_st_dt CHE_ST_DT, f.che_end_dt CHE_END_DT "+
			" FROM car_reg a, cont b, car_etc c, car_nm d, car_mng n "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_start_dt INS_START_DT, ir.ins_exp_dt INS_EXP_DT, ir.age_scp AGE_SCP, ir.agnt_imgn_tel AGNT_IMGN_TEL, ir.acc_tel ACC_TEL, ir.vins_spe VINS_SPE, ir.vins_cacdt_amt VINS_CACDT_AMT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id and  to_char(sysdate,'YYYYMMDD')  between to_char(to_date(ins_start_dt) + 1 , 'yyyymmdd')  and ins_exp_dt and ins_sts <> '3'   )) e "+
			", (select a.car_mng_id CAR_MNG_ID, a.che_st_dt CHE_ST_DT, a.che_end_dt CHE_END_DT from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id= car_mng_id)) f "+
			" WHERE a.car_mng_id = b.car_mng_id "+
//			" AND b.use_yn = 'Y' "+
			" AND b.rent_mng_id = c.rent_mng_id "+
			" AND b.rent_l_cd = c.rent_l_cd "+
			" AND c.car_id = d.car_id "+
			" AND c.car_seq = d.car_seq "+
			" AND d.car_comp_id = n.car_comp_id "+
			" AND d.car_cd = n.code "+
			" AND a.car_mng_id = e.car_mng_id "+
			" AND a.car_mng_id = f.car_mng_id(+) "+
			" AND a.car_mng_id = '"+car_mng_id+"'";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				carinfo = makeCus0401_carinfoBean(rs);
			}
            rs.close();
            pstmt.close();
		}catch(SQLException e){
			System.out.println("[Cus0401_Database:getCarinfo(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return carinfo;
		}		
	}

	/**
	*	차량리스트 상세정보
	*/
	public Cus0401_carinfoBean getCarinfo(String car_mng_id, String rent_l_cd){
		getConnection();
		Cus0401_carinfoBean carinfo = new Cus0401_carinfoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " SELECT a.car_mng_id CAR_MNG_ID, b.rent_mng_id RENT_MNG_ID, b.rent_l_cd RENT_L_CD, a.car_no CAR_NO, n.car_nm CAR_JNM, d.car_name CAR_NM, a.car_num CAR_NUM, "+
				"        a.init_reg_dt INIT_REG_DT, a.car_kd CAR_KD, a.car_use CAR_USE, a.car_form CAR_FORM, a.car_y_form CAR_Y_FORM, a.mot_form MOT_FORM, c.colo COLO, a.dpm DPM, "+
				"        a.conti_rat CONTI_RAT, a.fuel_kd FUEL_KD, e.age_scp AGE_SCP, e.ins_com_nm INS_COM_NM, e.ins_start_dt INS_START_DT, e.ins_exp_dt INS_EXP_DT, "+
				"        e.agnt_imgn_tel AGNT_IMGN_TEL, e.acc_tel ACC_TEL, e.vins_spe VINS_SPE, e.vins_cacdt_amt VINS_CACDT_AMT, f.che_st_dt CHE_ST_DT, f.che_end_dt CHE_END_DT "+
				" FROM   car_reg a, cont b, car_etc c, car_nm d, car_mng n, "+
				"        ( select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_start_dt INS_START_DT, ir.ins_exp_dt INS_EXP_DT, ir.age_scp AGE_SCP, ir.agnt_imgn_tel AGNT_IMGN_TEL, ir.acc_tel ACC_TEL, ir.vins_spe VINS_SPE, ir.vins_cacdt_amt VINS_CACDT_AMT "+
				"          from   insur ir, ins_com ic "+
				"          where  ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id and  to_char(sysdate,'YYYYMMDD')  between to_char(to_date(ins_start_dt) + 1 , 'yyyymmdd')  and ins_exp_dt and ins_sts <> '3'   )"+
				"        ) e, "+
				"        ( select a.car_mng_id CAR_MNG_ID, a.che_st_dt CHE_ST_DT, a.che_end_dt CHE_END_DT "+
				"          from   car_maint a "+
				"          where  seq_no = (select max(seq_no) from car_maint where a.car_mng_id= car_mng_id)) f "+
				" WHERE "+
				" a.car_mng_id = '"+car_mng_id+"' "+
 				" and a.car_mng_id = b.car_mng_id "+
				" AND b.rent_l_cd = '"+rent_l_cd+"' "+
				" AND b.rent_mng_id = c.rent_mng_id AND b.rent_l_cd = c.rent_l_cd "+
				" AND c.car_id = d.car_id AND c.car_seq = d.car_seq "+
				" AND d.car_comp_id = n.car_comp_id AND d.car_cd = n.code "+
				" AND a.car_mng_id = e.car_mng_id(+) "+
				" AND a.car_mng_id = f.car_mng_id(+) "+
				" ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				carinfo = makeCus0401_carinfoBean(rs);
			}
            rs.close();
            pstmt.close();

		}catch(SQLException e){
			System.out.println("[Cus0401_Database:getCarinfo(String car_mng_id, String rent_l_cd)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return carinfo;
		}		
	}

	/**
	*	 법인고객차량관리자 조회 (car_mgr) 2003.10.28.
	*/
	public Vector getCarMgr(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = " SELECT rent_mng_id, rent_l_cd, mgr_id, RTRIM(mgr_st) mgr_st, mgr_nm, mgr_dept, mgr_title, mgr_tel, mgr_m_tel, mgr_email, use_yn"+
						" FROM car_mgr"+
						" WHERE rent_mng_id = ? AND rent_l_cd = ? AND mgr_st<>'대표이사' AND nvl(use_yn,'Y')='Y' "+
						" ORDER BY mgr_id";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mng_id);
			pstmt.setString(2, l_cd);
		    rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				CarMgrBean car_mgr = new CarMgrBean();
				car_mgr.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				car_mgr.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));	
				car_mgr.setMgr_id(rs.getString("MGR_ID")==null?"":rs.getString("MGR_ID"));
				car_mgr.setMgr_st(rs.getString("MGR_ST")==null?"":rs.getString("MGR_ST"));
				car_mgr.setMgr_nm(rs.getString("MGR_NM")==null?"":rs.getString("MGR_NM"));
				car_mgr.setMgr_dept(rs.getString("MGR_DEPT")==null?"":rs.getString("MGR_DEPT"));
				car_mgr.setMgr_title(rs.getString("MGR_TITLE")==null?"":rs.getString("MGR_TITLE"));
				car_mgr.setMgr_tel(rs.getString("MGR_TEL")==null?"":rs.getString("MGR_TEL"));
				car_mgr.setMgr_m_tel(rs.getString("MGR_M_TEL")==null?"":rs.getString("MGR_M_TEL"));
				car_mgr.setMgr_email(rs.getString("MGR_EMAIL")==null?"":rs.getString("MGR_EMAIL"));
				car_mgr.setUse_yn(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				rtn.add(car_mgr);
			}
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Cus0401_Database:getCarMgr]\n"+e);
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
	*	 법인고객차량관리자 사용여부 조회 (car_mgr) 2003.10.28.
	*/
	public Vector getCarMgrAll(String mng_id, String l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = " SELECT rent_mng_id, rent_l_cd, mgr_id, RTRIM(mgr_st) mgr_st, mgr_nm, mgr_dept, mgr_title, mgr_tel, mgr_m_tel, mgr_email, use_yn"+
						" FROM car_mgr"+
						" WHERE rent_mng_id = ? AND rent_l_cd = ? AND mgr_st<>'대표이사'"+
						" ORDER BY mgr_id";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, mng_id);
			pstmt.setString(2, l_cd);
		    rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				CarMgrBean car_mgr = new CarMgrBean();
				car_mgr.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				car_mgr.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));	
				car_mgr.setMgr_id(rs.getString("MGR_ID")==null?"":rs.getString("MGR_ID"));
				car_mgr.setMgr_st(rs.getString("MGR_ST")==null?"":rs.getString("MGR_ST"));
				car_mgr.setMgr_nm(rs.getString("MGR_NM")==null?"":rs.getString("MGR_NM"));
				car_mgr.setMgr_dept(rs.getString("MGR_DEPT")==null?"":rs.getString("MGR_DEPT"));
				car_mgr.setMgr_title(rs.getString("MGR_TITLE")==null?"":rs.getString("MGR_TITLE"));
				car_mgr.setMgr_tel(rs.getString("MGR_TEL")==null?"":rs.getString("MGR_TEL"));
				car_mgr.setMgr_m_tel(rs.getString("MGR_M_TEL")==null?"":rs.getString("MGR_M_TEL"));
				car_mgr.setMgr_email(rs.getString("MGR_EMAIL")==null?"":rs.getString("MGR_EMAIL"));
				car_mgr.setUse_yn(rs.getString("USE_YN")==null?"":rs.getString("USE_YN"));
				rtn.add(car_mgr);
			}
            rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Cus0401_Database:getCarMgrYn]\n"+e);
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
	*	법인고객차량관리자 사용여부 수정 2003.10.28.
	*/
	public int setCarMgrYn(String rent_mng_id, String rent_l_cd, String[] mgr_id){
		getConnection();
		PreparedStatement pstmt = null;
		int result = -1;
		String query, query1 = "";
		
		if(!(mgr_id==null)){
			//체크된거 사용함으로 수정.
			query = "UPDATE car_mgr SET use_yn = 'Y' WHERE rent_mng_id='"+rent_mng_id+
				"' AND rent_l_cd='"+rent_l_cd+"' AND mgr_id in ('";
					
			for(int i=0 ; i<mgr_id.length ; i++){
				if(i == (mgr_id.length -1))	query += mgr_id[i];
				else						query += mgr_id[i]+"', '";
			}
			query+="')";

			//체크된거 이외 사용안함으로 수정.
			query1 = "UPDATE car_mgr SET use_yn = 'N' WHERE rent_mng_id='"+rent_mng_id+
				"' AND rent_l_cd='"+rent_l_cd+"' AND mgr_id not in ('";

			for(int i=0 ; i<mgr_id.length ; i++){
				if(i == (mgr_id.length -1))	query1 += mgr_id[i];
				else						query1 += mgr_id[i]+"', '";
			}
			query1+="')";
		}else{
			query = "UPDATE car_mgr SET use_yn = 'N' WHERE rent_mng_id='"+rent_mng_id+"' AND rent_l_cd='"+rent_l_cd+"'";
		}


		try{
			conn.setAutoCommit(false);
			
			if(!(mgr_id==null)){
				pstmt = conn.prepareStatement(query);
				result = pstmt.executeUpdate();
				pstmt = conn.prepareStatement(query1);
				result = pstmt.executeUpdate();
				pstmt.close();
			}else{
				pstmt = conn.prepareStatement(query);
				result = pstmt.executeUpdate();
				pstmt.close();
			}
			
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
	*	차량번호이력 전체  - 2003.10.28.
	*/
	public Vector getCar_no_his(String car_no){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = "SELECT car_mng_id,car_no,car_name,init_reg_dt,rent_l_cd,firm_nm,cls_dt,cls_st "+
			" FROM ( SELECT a.car_mng_id CAR_MNG_ID, a.car_no CAR_NO, e.car_name CAR_NAME, a.init_reg_dt INIT_REG_DT, b.rent_l_cd RENT_L_CD,decode(d.firm_nm,'',d.client_nm,d.firm_nm) FIRM_NM, c.cls_dt CLS_DT, c.cls_st CLS_ST FROM car_reg a, cont b, cls_cont c, client d, car_nm e, car_etc f "+
			" WHERE a.car_mng_id = b.car_mng_id "+
			" AND b.rent_mng_id = c.rent_mng_id(+) "+
			" AND b.rent_l_cd = c.rent_l_cd(+) "+
			" AND b.client_id = d.client_id "+
			" AND b.rent_mng_id = f.rent_mng_id "+
			" AND b.rent_l_cd = f.rent_l_cd  "+
			" AND f.car_id = e.car_id and f.car_seq=e.car_seq "+
			" )  WHERE car_no = ? ";
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,car_no);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();
			while(rs.next()){
				Hashtable ht = new Hashtable();
				for(int pos=1; pos<=rsmd.getColumnCount(); pos++){
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		}catch(Exception e){
			System.out.println("[Cus0401_Database:getCar_no_his()]"+e);
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
	*	스케쥴 2003.12.05.금
	*/
	public Cus0401_scBean[] getCarListYM(String year, String mon, String user_id){
		getConnection();
		Collection<Cus0401_scBean> col = new ArrayList<Cus0401_scBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.car_mng_id car_mng_id, b.rent_mng_id rent_mng_id, b.rent_l_cd rent_l_cd,DECODE(c.firm_nm,'',c.client_nm,c.firm_nm) firm_nm, a.car_no car_no, n.car_nm CAR_JNM, e.car_name CAR_NM, b.brch_id brch_id, b.mng_id mng_id "+
			" ,a.init_reg_dt init_reg_dt, f.rent_start_dt rent_start_dt, f.rent_end_dt rent_end_dt, g.serv_id SERV_ID, g.serv_dt serv_dt, g.next_serv_dt next_serv_dt, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,0,0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,0,0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST "+
			" FROM car_reg a, cont b, client c, car_etc d, car_nm e, car_mng n, client_site h, v_tot_dist vt, "+
			"	(select * from fee a where rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id = rent_mng_id and a.rent_l_cd=rent_l_cd)) f, "+
			"	(select * from service a where serv_dt||serv_id = (select max(serv_dt||serv_id) from service where a.car_mng_id = car_mng_id)) g, "+
			"	(select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) i "+
			" WHERE a.car_mng_id = b.car_mng_id "+
			" AND nvl(b.use_yn,'Y') = 'Y' "+
			" AND b.client_id = c.client_id "+
			" AND b.rent_mng_id = d.rent_mng_id "+
			" AND b.rent_l_cd = d.rent_l_cd "+
			" AND b.rent_mng_id = f.rent_mng_id(+) "+
			" AND b.rent_l_cd = f.rent_l_cd(+) "+
			" AND d.car_id= e.car_id "+
			" AND d.car_seq = e.car_seq "+
			" AND e.car_comp_id = n.car_comp_id "+
			" AND e.car_cd = n.code "+
			" AND a.car_mng_id = g.car_mng_id(+) "+
			" AND b.client_id = h.client_id(+) "+
			" AND b.r_site = h.seq(+) "+
			" AND a.car_mng_id = vt.car_mng_id(+) "+
			" AND b.client_id = i.client_id(+) "+
			" AND b.mng_id = '"+user_id+"' "+
			" and g.next_serv_dt like '"+year+mon+"%'";
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeCus0401_scBean(rs));
			}
            rs.close();
            pstmt.close();

		}catch(SQLException e){
			System.out.println("[Cus0401_Database:getCarListYM(String year, String mon)]"+e);
			System.out.println("[Cus0401_Database:getCarListYM(String year, String mon)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Cus0401_scBean[])col.toArray(new Cus0401_scBean[0]);
		}		
	}

	/**
	*	처리된 업무 스케쥴 2003.12.17.금
	*/
	public Cus0401_scBean[] getCarListYM_cmplt(String year, String mon, String user_id){
		getConnection();
		Collection<Cus0401_scBean> col = new ArrayList<Cus0401_scBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT a.car_mng_id car_mng_id, b.rent_mng_id rent_mng_id, b.rent_l_cd rent_l_cd,DECODE(c.firm_nm,'',c.client_nm,c.firm_nm) firm_nm, a.car_no car_no, e.car_name car_nm, b.brch_id brch_id, b.mng_id mng_id "+
			" ,a.init_reg_dt init_reg_dt, f.rent_start_dt rent_start_dt, f.rent_end_dt rent_end_dt, g.serv_id SERV_ID, g.serv_dt serv_dt, g.next_serv_dt next_serv_dt, "+
			" vt.tot_dist TOT_DIST, "+
			" decode(vt.tot_dist,'',0,0,0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST, "+
			" decode(vt.tot_dist,'',0,0,0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST "+
			" FROM car_reg a, cont b, client c, car_etc d, car_nm e, client_site h, v_tot_dist vt, "+
			"	(select * from fee a where rent_st = (select max(to_number(rent_st)) from fee where a.rent_mng_id = rent_mng_id and a.rent_l_cd=rent_l_cd)) f, "+
			"	(select * from service a where serv_dt||serv_id = (select max(serv_dt||serv_id) from service where a.car_mng_id = car_mng_id)) g, "+
			"	(select * from cycle_vst a where seq = (select max(seq) from cycle_vst where a.client_id = client_id)) i "+
			" WHERE a.car_mng_id = b.car_mng_id "+
			" AND nvl(b.use_yn,'Y') = 'Y' "+
			" AND b.client_id = c.client_id "+
			" AND b.rent_mng_id = d.rent_mng_id "+
			" AND b.rent_l_cd = d.rent_l_cd "+
			" AND b.rent_mng_id = f.rent_mng_id(+) "+
			" AND b.rent_l_cd = f.rent_l_cd(+) "+
			" AND d.car_id= e.car_id(+) "+
			" AND a.car_mng_id = g.car_mng_id(+) "+
			" AND b.client_id = h.client_id(+) "+
			" AND b.r_site = h.seq(+) "+
			" AND a.car_mng_id = vt.car_mng_id(+) "+
			" AND b.client_id = i.client_id(+) "+
			" AND b.mng_id = '"+user_id+"' "+	//정비건에대한 checker로 바꿔야함.
			" and g.serv_dt like '"+year+mon+"%'";
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				col.add(makeCus0401_scBean(rs));
			}
            rs.close();
            pstmt.close();

		}catch(SQLException e){
			System.out.println("[Cus0401_Database:getCarListYM(String year, String mon)]"+e);
			System.out.println("[Cus0401_Database:getCarListYM(String year, String mon)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return (Cus0401_scBean[])col.toArray(new Cus0401_scBean[0]);
		}		
	}

	/**
	*	 차량진단빈 조회 (speedcheck) 2003.12.23.화.
	*/
	public SpeedCheckBean[] getSpeedCheck()
	{
		getConnection();
		Collection<SpeedCheckBean> col = new ArrayList<SpeedCheckBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		SpeedCheckBean spchk = new SpeedCheckBean();
		String query = " SELECT chk_id, chk_nm, chk_cont "+
						" FROM speedcheck ";
		try{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
    	
			while(rs.next())
			{				
				col.add(makeSpeedCheckBean(rs));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Cus0401_Database:getSpeedCheck]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return (SpeedCheckBean[])col.toArray(new SpeedCheckBean[0]);
		}			
	}
	/**
	*	업무추진현황 - 2003.12.03.수.
	*/
	public int[] getUpChu2(){
		getConnection();
		int tg[] = new int[12];
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = "SELECT  a.sac MSAC, a.sec MSEC, c.cs1 MCS1, c.cs2 MCS2, c.cs3 MCS3, a.sc MSC, b.sac DSAC, b.sec DSEC, d.cs1 DCS1, d.cs2 DCS2, d.cs3 DCS3, b.sc DSC  "+
				" from "+
				"(SELECT nvl(sum(a.sac),0) sac, nvl(sum(b.sec),0) sec, nvl(sum(c.s_cnt),0) sc "+
				"		FROM (select nvl(mng_id,'999999') mng_id, nvl(count(0),0) sac from cont where nvl(use_yn,'Y') = 'Y' group by mng_id) a, 	  "+
				"			 (select nvl(mng_id,'999999') mng_id, nvl(sum(decode(substr(b.next_serv_dt,1,6),to_char(sysdate,'yyyymm'),1,0)),0) sec "+
				"				from cont a, service b   "+
				"				where a.car_mng_id = b.car_mng_id and nvl(a.use_yn,'Y') = 'Y'   "+
				"				group by mng_id) b,      "+
				"			 (SELECT checker, nvl(count(0),0) S_CNT FROM service b where b.serv_dt like to_char(sysdate,'yyyymm')||'%' GROUP BY checker ) c "+
				"           ,users d                  	  "+
				"              WHERE d.user_id=a.mng_id(+) and d.user_id = b.mng_id(+) and d.user_id = c.checker(+)  "+
				"              AND d.user_id not in ('000006','000002') AND d.dept_id='0002'  "+
				") a, "+
				"(SELECT nvl(sum(a.sac),0) sac, nvl(sum(b.sec),0) sec, nvl(sum(c.s_cnt),0) sc "+
				"		FROM (select nvl(mng_id,'999999') mng_id, nvl(count(0),0) sac from cont where nvl(use_yn,'Y') = 'Y' group by mng_id) a, 	 "+
				"			 (select nvl(mng_id,'999999') mng_id, nvl(sum(decode(b.next_serv_dt,to_char(sysdate,'yyyymmdd'),1,0)),0) sec "+
				"				from cont a, service b "+
				"				where a.car_mng_id = b.car_mng_id and nvl(a.use_yn,'Y') = 'Y' "+
				"				group by mng_id) b, "+
				"			 (SELECT checker, nvl(count(0),0) S_CNT FROM service b where b.serv_dt=to_char(sysdate,'yyyymmdd') GROUP BY checker ) c "+
				"           ,users d                  	 "+
				"              WHERE d.user_id=a.mng_id(+) and d.user_id = b.mng_id(+) and d.user_id = c.checker(+) "+
				"             AND d.user_id not in ('000006','000002') AND d.dept_id='0002' "+
				") b, "+
				"(SELECT nvl(sum(decode(checker_st,'1',1,0)),0) CS1, "+
				"	  nvl(sum(decode(checker_st,'2',1,0)),0) CS2, "+
				"	  nvl(sum(decode(checker_st,'3',1,0)),0) CS3 "+
				"  FROM service a, users d "+
				"  where d.user_id=a.checker(+) and serv_dt like to_char(sysdate,'yyyymm')||'%' "+
				"  AND d.user_id not in ('000006','000002') AND d.dept_id='0002' "+
				") c, "+
				"(SELECT nvl(sum(decode(checker_st,'1',1,0)),0) CS1, "+
				"	  nvl(sum(decode(checker_st,'2',1,0)),0) CS2, "+
				"	  nvl(sum(decode(checker_st,'3',1,0)),0) CS3 "+
				"  FROM service a, users d "+
				"  where d.user_id=a.checker(+) and serv_dt=to_char(sysdate,'yyyymmdd') "+
				"  AND d.user_id not in ('000006','000002') AND d.dept_id='0002' "+
				") d ";

		try{
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
				while(rs.next()){
					tg[0] = rs.getInt("MSAC");
					tg[1] = rs.getInt("MSEC");
					tg[2] = rs.getInt("MCS1");
					tg[3] = rs.getInt("MCS2");
					tg[4] = rs.getInt("MCS3");
					tg[5] = rs.getInt("MSC");
					tg[6] = rs.getInt("DSAC");
					tg[7] = rs.getInt("DSEC");
					tg[8] = rs.getInt("DCS1");
					tg[9] = rs.getInt("DCS2");
					tg[10] = rs.getInt("DCS3");
					tg[11] = rs.getInt("DSC");
				}
				rs.close();
				pstmt.close();
		
			}catch(SQLException e){
				System.out.println("[Cus0401_Database:getUpChu2()]"+e);
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