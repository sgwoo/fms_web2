package acar.accid;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.con_ins_m.*;
import acar.car_service.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class AccidDatabase{

    private static AccidDatabase instance;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE = "acar"; 
 
    public static synchronized AccidDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AccidDatabase();
        return instance;
    }
    
    private AccidDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

	// 사고등록 -------------------------------------------------------------------------------------------------
	

	//등록전 계약리스트 조회
	public Vector getRentList(String br_id, String s_gubun1, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		 query = " select   v.rent_mng_id, v.rent_l_cd, v.car_mng_id, v.use_yn,  v.firm_nm, c.car_no, c.car_nm, c.car_num, v.rent_start_dt, v.rent_end_dt, a.cls_dt, c.init_reg_dt  \n"+
			      "	from cont_n_view v, car_reg c, cls_cont a \n"+
                		      "	where v.car_mng_id = c.car_mng_id and v.rent_mng_id = a.rent_mng_id(+) and v.rent_l_cd = a.rent_l_cd(+)	\n";	
	
		if(s_kd.equals("1"))		query += " and v.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_num like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and v.rent_l_cd like '%"+t_wd+"%'";
	

		if(s_kd.equals("2"))		query += " order by v.use_yn desc, c.car_no, v.rent_dt desc";		
		else						query += " order by v.use_yn desc, v.rent_dt desc";		

		try {
         
			pstmt = con.prepareStatement(query);
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
		}catch(SQLException se){
         	  System.out.println("[AccidDatabase:getRentList]="+se);
			  throw new DatabaseException();
        }finally{
            try{
                if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//등록전 계약 한건 상세내역 조회
	public Hashtable getRentCase(String m_id, String l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
	

		query = " select /*+  merge(a) */ c.car_nm, b.CON_AGNT_EMAIL, DECODE(cn.s_st,'100','100','409','100','101','101','112','112','102','102','104','104','105','105','601','601','602','602','300','102','301','103','302','105',cn.s_st) s_st_cd, "+
				"        a.brch_id, a.client_id, a.firm_nm, a.client_nm, d.r_site r_site, a.car_st, "+
				"        a.car_mng_id, c.car_no, c.car_nm, cn.car_name, c.init_reg_dt, d.user_nm, a.car_ja, c.car_num, c.car_use, a.use_yn, "+
				"        nvl(d.user_m_tel, '02-392-4242') user_m_tel, a.bus_id2,  a.rent_way, c.MAINT_ST_DT, c.MAINT_END_DT, d.br_id, opt, cn.jg_code, b.client_st \n"+
				" from   cont_n_view a, CLIENT b, users d, car_reg c,  car_etc g, car_nm cn,  client_site d \n"+
				" where  a.rent_mng_id=? and a.rent_l_cd=?"+
				"        and nvl(a.mng_id, a.bus_id2)=d.user_id(+) AND a.CLIENT_ID =b.CLIENT_ID and a.car_mng_id = c.car_mng_id(+)  \n"+
				"	and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
				"       and a.client_id=d.client_id(+) and a.r_site =d.SEQ(+)   \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
                       
		try {
          
			pstmt = con.prepareStatement(query);

    		pstmt.setString(1, m_id);
    		pstmt.setString(2, l_cd);

	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
            pstmt.close();	
            
		}catch(SQLException se){
          		System.out.println("[AccidDatabase:getRentCase]="+se);
          		System.out.println("[AccidDatabase:getRentCase]="+query);
          		System.out.println("[AccidDatabase:getRentCase]="+m_id);
          		System.out.println("[AccidDatabase:getRentCase]="+m_id);
			    throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }


	/**
     * 사고기록 등록 : car_accid_all_i_a.jsp
     */
    public String insertAccident(AccidentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        String accid_id = "";
        int count = 0;
                
        query = " INSERT INTO accident"+
				" (CAR_MNG_ID, ACCID_ID, RENT_MNG_ID, RENT_L_CD, ACCID_ST,"+
				" OUR_CAR_NM, OUR_DRIVER, OUR_TEL, OUR_M_TEL, OUR_SSN,"+	//10
				" OUR_LIC_KD, OUR_LIC_NO, OUR_INS, OUR_NUM, OUR_POST,"+
				" OUR_ADDR, ACCID_DT, ACCID_CITY, ACCID_GU, ACCID_DONG,"+	//20
				" ACCID_POINT, ACCID_CONT, OT_CAR_NO, OT_CAR_NM, OT_DRIVER,"+
				" OT_TEL, OT_M_TEL, OT_INS, OT_NUM, OT_INS_NM,"+			//30
				" OT_INS_TEL, OT_INS_M_TEL, OT_POL_STA, OT_POL_NM, OT_POL_TEL,"+
				" OT_POL_M_TEL, HUM_AMT, HUM_NM, HUM_TEL, MAT_AMT,"+		//40
				" MAT_NM, MAT_TEL, ONE_AMT, ONE_NM, ONE_TEL,"+
				" MY_AMT, MY_NM, MY_TEL, REF_DT, EX_TOT_AMT,"+				//50
				" TOT_AMT, REC_AMT, REC_DT, REC_PLAN_DT, SUP_AMT,"+
				" SUP_DT, INS_SUP_AMT, INS_SUP_DT, INS_TOT_AMT,"+			//59	
				" SUB_RENT_GU, SUB_FIRM_NM, SUB_RENT_ST, SUB_RENT_ET, SUB_ETC,"+	//64
				" REG_DT, REG_ID, UPDATE_DT, UPDATE_ID, OUR_LIC_DT, "+				//69
				" OUR_TEL2, OT_SSN, OT_LIC_KD, OT_LIC_NO, OT_TEL2,"+				//74
				" OUR_DAM_ST, OT_DAM_ST, ACCID_ADDR, ACCID_CONT2, IMP_FAULT_ST,"+	//79
				" IMP_FAULT_SUB, OUR_FAULT_PER, OT_POL_ST, OT_POL_NUM, OT_POL_FAX, R_SITE, MEMO,"+//86*/
				" RENT_S_CD, ACCID_TYPE, ACCID_TYPE_SUB, SETTLE_ST,"+
				" DAM_TYPE1, DAM_TYPE2, DAM_TYPE3, DAM_TYPE4,"+
				" speed, weather, road_stat, road_stat2, bus_id2, acc_id, acc_dt, reg_ip "+
				" )\n"+			
				" values(?, ?, ?, ?, ?, ?, ?, ?, ?, replace(?,'-',''),"+
				" ?, ?, ?, ?, ?, ?, replace(replace(?,' ',''),'-',''), ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, ?, ?, ?,"+		//59
				" ?, ?, replace(?,'-',''), replace(?,'-',''), ?,"+
				" to_char(sysdate,'YYYYMMDD'), ?, to_char(sysdate,'YYYYMMDD'), ?, replace(?,'-',''),"+	//69
				" ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?,"+					//79
				" ?, ?, ?, ?, ?, ?, ?,"+										//86
				" ?, ?, ?, ?,"+
				" ?, ?, ?, ?,"+
				" ?, ?, ?, ?, ?, ?, replace(?,'-',''), ? "+
				" )\n";

		query1 = " select nvl(lpad(max(ACCID_ID)+1,6,'0'),'000001') from accident ";
    
	   try{
            con.setAutoCommit(false);

            pstmt1 = con.prepareStatement(query1);
			rs = pstmt1.executeQuery();
            if(rs.next()){
				accid_id = rs.getString(1);
            }
			rs.close();
			pstmt1.close();
			
            pstmt = con.prepareStatement(query);
            pstmt.setString (1,  bean.getCar_mng_id().trim()	);
			pstmt.setString (2,  accid_id.trim()				);
			pstmt.setString (3,  bean.getRent_mng_id().trim()	);
			pstmt.setString (4,  bean.getRent_l_cd().trim()		);			
			pstmt.setString (5,  bean.getAccid_st().trim()		);
			pstmt.setString (6,  bean.getOur_car_nm().trim()	);
			pstmt.setString (7,  bean.getOur_driver().trim()	);
			pstmt.setString (8,  bean.getOur_tel().trim()		);
			pstmt.setString (9,  bean.getOur_m_tel().trim()		);
			pstmt.setString (10, bean.getOur_ssn().trim()		);
			pstmt.setString (11, bean.getOur_lic_kd().trim()	);
			pstmt.setString (12, bean.getOur_lic_no().trim()	);
			pstmt.setString (13, bean.getOur_ins().trim()		);
			pstmt.setString (14, bean.getOur_num().trim()		);
			pstmt.setString (15, bean.getOur_post().trim()		);
			pstmt.setString (16, bean.getOur_addr().trim()		);
			pstmt.setString (17, bean.getAccid_dt().trim()		);
			pstmt.setString (18, bean.getAccid_city().trim()	);
			pstmt.setString (19, bean.getAccid_gu().trim()		);
			pstmt.setString (20, bean.getAccid_dong().trim()	);
			pstmt.setString (21, bean.getAccid_point().trim()	);
			pstmt.setString (22, bean.getAccid_cont().trim()	);
			pstmt.setString (23, bean.getOt_car_no().trim()		);
			pstmt.setString (24, bean.getOt_car_nm().trim()		);
			pstmt.setString (25, bean.getOt_driver().trim()		);
			pstmt.setString (26, bean.getOt_tel().trim()		);
			pstmt.setString (27, bean.getOt_m_tel().trim()		);
			pstmt.setString (28, bean.getOt_ins().trim()		);
			pstmt.setString (29, bean.getOt_num().trim()		);
			pstmt.setString (30, bean.getOt_ins_nm().trim()		);
			pstmt.setString (31, bean.getOt_ins_tel().trim()	);
			pstmt.setString (32, bean.getOt_ins_m_tel().trim()	);
			pstmt.setString (33, bean.getOt_pol_sta().trim()	);
			pstmt.setString (34, bean.getOt_pol_nm().trim()		);
			pstmt.setString (35, bean.getOt_pol_tel().trim()	);
			pstmt.setString (36, bean.getOt_pol_m_tel().trim()	);
			pstmt.setInt	(37, bean.getHum_amt()				);
			pstmt.setString (38, bean.getHum_nm().trim()		);
			pstmt.setString (39, bean.getHum_tel().trim()		);
			pstmt.setInt	(40, bean.getMat_amt()				);
			pstmt.setString (41, bean.getMat_nm().trim()		);
			pstmt.setString (42, bean.getMat_tel().trim()		);
			pstmt.setInt	(43, bean.getOne_amt()				);
			pstmt.setString (44, bean.getOne_nm().trim()		);
			pstmt.setString (45, bean.getOne_tel().trim()		);
			pstmt.setInt	(46, bean.getMy_amt()				);
			pstmt.setString (47, bean.getMy_nm().trim()			);
			pstmt.setString (48, bean.getMy_tel().trim()		);
			pstmt.setString (49, bean.getRef_dt().trim()		);
			pstmt.setString (50, bean.getRec_plan_dt().trim()	);
			pstmt.setInt	(51, bean.getEx_tot_amt()			);
			pstmt.setInt	(52, bean.getTot_amt()				);
			pstmt.setInt	(53, bean.getRec_amt()				);
			pstmt.setString (54, bean.getRec_dt().trim()		);
			pstmt.setInt	(55, bean.getSup_amt()				);
			pstmt.setString (56, bean.getSup_dt().trim()		);
			pstmt.setInt	(57, bean.getIns_sup_amt()			);
			pstmt.setString (58, bean.getIns_sup_dt().trim()	);
			pstmt.setInt	(59, bean.getIns_tot_amt()			);
			pstmt.setString (60, bean.getSub_rent_gu().trim()	);
			pstmt.setString (61, bean.getSub_firm_nm().trim()	);
			pstmt.setString (62, bean.getSub_rent_st().trim()	);
			pstmt.setString (63, bean.getSub_rent_et().trim()	);
			pstmt.setString (64, bean.getSub_etc().trim()		);
//			pstmt.setString (65, bean.getReg_dt().trim()		);
			pstmt.setString (65, bean.getReg_id().trim()		);
//			pstmt.setString (67, bean.getUpdate_dt().trim()		);
			pstmt.setString (66, bean.getUpdate_id().trim()		);
			pstmt.setString (67, bean.getOur_lic_dt().trim()	);
			pstmt.setString (68, bean.getOur_tel2().trim()		);
			pstmt.setString (69, bean.getOt_ssn().trim()		);
			pstmt.setString (70, bean.getOt_lic_kd().trim()		);
			pstmt.setString (71, bean.getOt_lic_no().trim()		);
			pstmt.setString (72, bean.getOt_tel2().trim()		);
			pstmt.setString (73, bean.getOur_dam_st().trim()	);
			pstmt.setString (74, bean.getOt_dam_st().trim()		);
			pstmt.setString (75, bean.getAccid_addr().trim()	);
			pstmt.setString (76, bean.getAccid_cont2().trim()	);
			pstmt.setString (77, bean.getImp_fault_st().trim()	);
			pstmt.setString (78, bean.getImp_fault_sub().trim()	);
			pstmt.setInt	(79, bean.getOur_fault_per()		);
			pstmt.setString (80, bean.getOt_pol_st().trim()		);
			pstmt.setString (81, bean.getOt_pol_num().trim()	);
			pstmt.setString (82, bean.getOt_pol_fax().trim()	);
			pstmt.setString (83, bean.getR_site().trim()		);
			pstmt.setString (84, bean.getMemo().trim()			);
			pstmt.setString (85, bean.getRent_s_cd().trim()		);
			pstmt.setString (86, bean.getAccid_type().trim()	);
			pstmt.setString (87, bean.getAccid_type_sub().trim());
			pstmt.setString (88, bean.getSettle_st().trim()		);
			pstmt.setString (89, bean.getDam_type1().trim()		);
			pstmt.setString (90, bean.getDam_type2().trim()		);
			pstmt.setString (91, bean.getDam_type3().trim()		);
			pstmt.setString (92, bean.getDam_type4().trim()		);
			pstmt.setString (93, bean.getSpeed()				);
			pstmt.setString (94, bean.getWeather().trim()		);
			pstmt.setString (95, bean.getRoad_stat().trim()		);
			pstmt.setString (96, bean.getRoad_stat2().trim()	);
			pstmt.setString (97, bean.getBus_id2().trim()		);
			pstmt.setString (98, bean.getAcc_id().trim()		);
			pstmt.setString (99, bean.getAcc_dt().trim()		);
			pstmt.setString (100, bean.getReg_ip().trim()		);
            count = pstmt.executeUpdate();
            
            pstmt.close(); 
            con.commit();

		}catch(Exception se){
            try{
				System.out.println("[AccidDatabase:insertAccident]\n"+se);

				System.out.println("[bean.getCar_mng_id().trim()		]\n"+bean.getCar_mng_id().trim()		);
				System.out.println("[accid_id.trim()					]\n"+accid_id.trim()					);
				System.out.println("[bean.getRent_mng_id().trim()		]\n"+bean.getRent_mng_id().trim()		);
				System.out.println("[bean.getRent_l_cd().trim()			]\n"+bean.getRent_l_cd().trim()			);
				System.out.println("[bean.getAccid_st().trim()			]\n"+bean.getAccid_st().trim()			);
				System.out.println("[bean.getOur_car_nm().trim()		]\n"+bean.getOur_car_nm().trim()		);
				System.out.println("[bean.getOur_driver().trim()		]\n"+bean.getOur_driver().trim()		);
				System.out.println("[bean.getOur_tel().trim()			]\n"+bean.getOur_tel().trim()			);
				System.out.println("[bean.getOur_m_tel().trim()			]\n"+bean.getOur_m_tel().trim()			);
				System.out.println("[bean.getOur_ssn().trim()			]\n"+bean.getOur_ssn().trim()			);
				System.out.println("[bean.getOur_lic_kd().trim()		]\n"+bean.getOur_lic_kd().trim()		);
				System.out.println("[bean.getOur_lic_no().trim()		]\n"+bean.getOur_lic_no().trim()		);
				System.out.println("[bean.getOur_ins().trim()			]\n"+bean.getOur_ins().trim()			);
				System.out.println("[bean.getOur_num().trim()			]\n"+bean.getOur_num().trim()			);
				System.out.println("[bean.getOur_post().trim()			]\n"+bean.getOur_post().trim()			);
				System.out.println("[bean.getOur_addr().trim()			]\n"+bean.getOur_addr().trim()			);
				System.out.println("[bean.getAccid_dt().trim()			]\n"+bean.getAccid_dt().trim()			);
				System.out.println("[bean.getAccid_city().trim()		]\n"+bean.getAccid_city().trim()		);
				System.out.println("[bean.getAccid_gu().trim()			]\n"+bean.getAccid_gu().trim()			);
				System.out.println("[bean.getAccid_dong().trim()		]\n"+bean.getAccid_dong().trim()		);
				System.out.println("[bean.getAccid_point().trim()		]\n"+bean.getAccid_point().trim()		);
				System.out.println("[bean.getAccid_cont().trim()		]\n"+bean.getAccid_cont().trim()		);
				System.out.println("[bean.getOt_car_no().trim()			]\n"+bean.getOt_car_no().trim()			);
				System.out.println("[bean.getOt_car_nm().trim()			]\n"+bean.getOt_car_nm().trim()			);
				System.out.println("[bean.getOt_driver().trim()			]\n"+bean.getOt_driver().trim()			);
				System.out.println("[bean.getOt_tel().trim()			]\n"+bean.getOt_tel().trim()			);
				System.out.println("[bean.getOt_m_tel().trim()			]\n"+bean.getOt_m_tel().trim()			);
				System.out.println("[bean.getOt_ins().trim()			]\n"+bean.getOt_ins().trim()			);
				System.out.println("[bean.getOt_num().trim()			]\n"+bean.getOt_num().trim()			);
				System.out.println("[bean.getOt_ins_nm().trim()			]\n"+bean.getOt_ins_nm().trim()			);
				System.out.println("[bean.getOt_ins_tel().trim()		]\n"+bean.getOt_ins_tel().trim()		);
				System.out.println("[bean.getOt_ins_m_tel().trim()		]\n"+bean.getOt_ins_m_tel().trim()		);
				System.out.println("[bean.getOt_pol_sta().trim()		]\n"+bean.getOt_pol_sta().trim()		);
				System.out.println("[bean.getOt_pol_nm().trim()			]\n"+bean.getOt_pol_nm().trim()			);
				System.out.println("[bean.getOt_pol_tel().trim()		]\n"+bean.getOt_pol_tel().trim()		);
				System.out.println("[bean.getOt_pol_m_tel().trim()		]\n"+bean.getOt_pol_m_tel().trim()		);
				System.out.println("[bean.getHum_amt()					]\n"+bean.getHum_amt()					);
				System.out.println("[bean.getHum_nm().trim()			]\n"+bean.getHum_nm().trim()			);
				System.out.println("[bean.getHum_tel().trim()			]\n"+bean.getHum_tel().trim()			);
				System.out.println("[bean.getMat_amt()					]\n"+bean.getMat_amt()					);
				System.out.println("[bean.getMat_nm().trim()			]\n"+bean.getMat_nm().trim()			);
				System.out.println("[bean.getMat_tel().trim()			]\n"+bean.getMat_tel().trim()			);
				System.out.println("[bean.getOne_amt()					]\n"+bean.getOne_amt()					);
				System.out.println("[bean.getOne_nm().trim()			]\n"+bean.getOne_nm().trim()			);
				System.out.println("[bean.getOne_tel().trim()			]\n"+bean.getOne_tel().trim()			);
				System.out.println("[bean.getMy_amt()					]\n"+bean.getMy_amt()					);
				System.out.println("[bean.getMy_nm().trim()				]\n"+bean.getMy_nm().trim()				);
				System.out.println("[bean.getMy_tel().trim()			]\n"+bean.getMy_tel().trim()			);
				System.out.println("[bean.getRef_dt().trim()			]\n"+bean.getRef_dt().trim()			);
				System.out.println("[bean.getRec_plan_dt().trim()		]\n"+bean.getRec_plan_dt().trim()		);
				System.out.println("[bean.getEx_tot_amt()				]\n"+bean.getEx_tot_amt()				);
				System.out.println("[bean.getTot_amt()					]\n"+bean.getTot_amt()					);
				System.out.println("[bean.getRec_amt()					]\n"+bean.getRec_amt()					);
				System.out.println("[bean.getRec_dt().trim()			]\n"+bean.getRec_dt().trim()			);
				System.out.println("[bean.getSup_amt()					]\n"+bean.getSup_amt()					);
				System.out.println("[bean.getSup_dt().trim()			]\n"+bean.getSup_dt().trim()			);
				System.out.println("[bean.getIns_sup_amt()				]\n"+bean.getIns_sup_amt()				);
				System.out.println("[bean.getIns_sup_dt().trim()		]\n"+bean.getIns_sup_dt().trim()		);
				System.out.println("[bean.getIns_tot_amt()				]\n"+bean.getIns_tot_amt()				);
				System.out.println("[bean.getSub_rent_gu().trim()		]\n"+bean.getSub_rent_gu().trim()		);
				System.out.println("[bean.getSub_firm_nm().trim()		]\n"+bean.getSub_firm_nm().trim()		);
				System.out.println("[bean.getSub_rent_st().trim()		]\n"+bean.getSub_rent_st().trim()		);
				System.out.println("[bean.getSub_rent_et().trim()		]\n"+bean.getSub_rent_et().trim()		);
				System.out.println("[bean.getSub_etc().trim()			]\n"+bean.getSub_etc().trim()			);
				System.out.println("[bean.getReg_dt().trim()			]\n"+bean.getReg_dt().trim()			);
				System.out.println("[bean.getReg_id().trim()			]\n"+bean.getReg_id().trim()			);
				System.out.println("[bean.getUpdate_dt().trim()			]\n"+bean.getUpdate_dt().trim()			);
				System.out.println("[bean.getUpdate_id().trim()			]\n"+bean.getUpdate_id().trim()			);
				System.out.println("[bean.getOur_lic_dt().trim()		]\n"+bean.getOur_lic_dt().trim()		);
				System.out.println("[bean.getOur_tel2().trim()			]\n"+bean.getOur_tel2().trim()			);
				System.out.println("[bean.getOt_ssn().trim()			]\n"+bean.getOt_ssn().trim()			);
				System.out.println("[bean.getOt_lic_kd().trim()			]\n"+bean.getOt_lic_kd().trim()			);
				System.out.println("[bean.getOt_lic_no().trim()			]\n"+bean.getOt_lic_no().trim()			);
				System.out.println("[bean.getOt_tel2().trim()			]\n"+bean.getOt_tel2().trim()			);
				System.out.println("[bean.getOur_dam_st().trim()		]\n"+bean.getOur_dam_st().trim()		);
				System.out.println("[bean.getOt_dam_st().trim()			]\n"+bean.getOt_dam_st().trim()			);
				System.out.println("[bean.getAccid_addr().trim()		]\n"+bean.getAccid_addr().trim()		);
				System.out.println("[bean.getAccid_cont2().trim()		]\n"+bean.getAccid_cont2().trim()		);
				System.out.println("[bean.getImp_fault_st().trim()		]\n"+bean.getImp_fault_st().trim()		);
				System.out.println("[bean.getImp_fault_sub().trim()		]\n"+bean.getImp_fault_sub().trim()		);
				System.out.println("[bean.getOur_fault_per()			]\n"+bean.getOur_fault_per()			);
				System.out.println("[bean.getOt_pol_st().trim()			]\n"+bean.getOt_pol_st().trim()			);
				System.out.println("[bean.getOt_pol_num().trim()		]\n"+bean.getOt_pol_num().trim()		);
				System.out.println("[bean.getOt_pol_fax().trim()		]\n"+bean.getOt_pol_fax().trim()		);
				System.out.println("[bean.getR_site().trim()			]\n"+bean.getR_site().trim()			);
				System.out.println("[bean.getMemo().trim()				]\n"+bean.getMemo().trim()				);
				System.out.println("[bean.getRent_s_cd().trim()			]\n"+bean.getRent_s_cd().trim()			);
				System.out.println("[bean.getAccid_type().trim()		]\n"+bean.getAccid_type().trim()		);
				System.out.println("[bean.getAccid_type_sub().trim()	]\n"+bean.getAccid_type_sub().trim()	);
				System.out.println("[bean.getSettle_st().trim()			]\n"+bean.getSettle_st().trim()			);
				System.out.println("[bean.getDam_type1().trim()			]\n"+bean.getDam_type1().trim()			);
				System.out.println("[bean.getDam_type2().trim()			]\n"+bean.getDam_type2().trim()			);
				System.out.println("[bean.getDam_type3().trim()			]\n"+bean.getDam_type3().trim()			);
				System.out.println("[bean.getDam_type4().trim()			]\n"+bean.getDam_type4().trim()			);
				System.out.println("[bean.getSpeed()					]\n"+bean.getSpeed()					);
				System.out.println("[bean.getWeather().trim()			]\n"+bean.getWeather().trim()			);
				System.out.println("[bean.getRoad_stat().trim()			]\n"+bean.getRoad_stat().trim()			);
				System.out.println("[bean.getRoad_stat2().trim()		]\n"+bean.getRoad_stat2().trim()		);
				System.out.println("[bean.getReg_ip().trim()			]\n"+bean.getReg_ip().trim()			);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return accid_id;
    }

    /**
     * 자기신체사고-자손 등록.
     */
    public int insertOneAccid(OneAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        int seq_no = 0;
        int count = 0;
                
        query = " INSERT INTO one_accid(CAR_MNG_ID, ACCID_ID, SEQ_NO, NM, SEX,"+
				" HOSP, HOSP_TEL, INS_NM, INS_TEL, TEL,"+
				" AGE, RELATION, DIAGNOSIS, ETC, WOUND_ST, one_accid_st, ot_seq_no)\n"+
				" values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\n";

		query1= " select nvl(max(seq_no)+1,1) from one_accid where car_mng_id=? and accid_id=?";
    
       try{
            con.setAutoCommit(false);

            pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, bean.getCar_mng_id().trim());
            pstmt1.setString(2, bean.getAccid_id().trim());
			rs = pstmt1.executeQuery();
            if(rs.next()){
				seq_no = rs.getInt(1);
            }
			rs.close();
			pstmt1.close();

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
			pstmt.setString(2, bean.getAccid_id().trim());
			pstmt.setInt   (3, seq_no);
			pstmt.setString(4, bean.getNm().trim());
			pstmt.setString(5, bean.getSex().trim());
			pstmt.setString(6, bean.getHosp().trim());
			pstmt.setString(7, bean.getHosp_tel().trim());
			pstmt.setString(8, bean.getIns_nm().trim());
			pstmt.setString(9, bean.getIns_tel().trim());
			pstmt.setString(10, bean.getTel().trim());
			pstmt.setString(11, bean.getAge().trim());
			pstmt.setString(12, bean.getRelation().trim());
			pstmt.setString(13, bean.getDiagnosis().trim());
			pstmt.setString(14, bean.getEtc().trim());           
			pstmt.setString(15, bean.getWound_st().trim());           
			pstmt.setString(16, bean.getOne_accid_st().trim());           
			pstmt.setInt   (17, bean.getOt_seq_no());           
            count = pstmt.executeUpdate();
            
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:insertOneAccid]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 보험금청구내역 insert (휴차/대차료 보험회사 청부 내용)
     */
    public int insertMyAccid(MyAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " INSERT INTO MY_ACCID"+
				" (CAR_MNG_ID, ACCID_ID, REQ_GU, REQ_ST, CAR_NM,"+
				" CAR_NO, DAY_AMT, USE_ST, USE_ET, INS_NM,"+	
				" INS_TEL, REQ_AMT, REQ_DT, PAY_AMT, PAY_DT,"+	
				" USE_DAY, INS_TEL2, INS_FAX, INS_ADDR, INS_COM, RE_REASON, VAT_YN, MC_S_AMT, MC_V_AMT, INS_NUM, SEQ_NO, OT_FAULT_PER , BUS_ID2, "+				
				" REG_ID, REG_DT, INS_COM_ID, INS_ETC, USE_HOUR, INS_ZIP, APP_DOCS "+
				" )\n"+			
				" values(?, ?, ?, ?, ?,"+					
				" ?, ?, replace(?,'-',''), replace(?,'-',''), ?,"+
				" ?, ?, replace(?,'-',''), ?, replace(?,'-',''),"+		
				" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				" ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, ? )\n";
    
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            pstmt.setString(1,  bean.getCar_mng_id().trim()	);
			pstmt.setString(2,  bean.getAccid_id().trim()	);
			pstmt.setString(3,  bean.getIns_req_gu().trim()	);
			pstmt.setString(4,  bean.getIns_req_st().trim()	);
			pstmt.setString(5,  bean.getIns_car_nm().trim()	);
			pstmt.setString(6,  bean.getIns_car_no().trim()	);
			pstmt.setInt   (7,  bean.getIns_day_amt()		);
			pstmt.setString(8,  bean.getIns_use_st().trim()	);
			pstmt.setString(9,  bean.getIns_use_et().trim()	);
			pstmt.setString(10, bean.getIns_nm().trim()		);
			pstmt.setString(11, bean.getIns_tel().trim()	);
			pstmt.setInt   (12, bean.getIns_req_amt()		);
			pstmt.setString(13, bean.getIns_req_dt().trim()	);
			pstmt.setInt   (14, bean.getIns_pay_amt()		);
			pstmt.setString(15, bean.getIns_pay_dt().trim()	);
			pstmt.setString(16, bean.getIns_use_day().trim());  
			pstmt.setString(17, bean.getIns_tel2().trim()	);
			pstmt.setString(18, bean.getIns_fax().trim()	);
			pstmt.setString(19, bean.getIns_addr().trim()	);
			pstmt.setString(20, bean.getIns_com().trim()	);
			pstmt.setString(21, bean.getRe_reason().trim()	);
			pstmt.setString(22, bean.getVat_yn().trim()		);
			pstmt.setInt   (23, bean.getMc_s_amt()			);
			pstmt.setInt   (24, bean.getMc_v_amt()			);
			pstmt.setString(25, bean.getIns_num().trim()	);
			pstmt.setInt   (26, bean.getSeq_no()			);
			pstmt.setInt   (27, bean.getOt_fault_per()		);
			pstmt.setString(28, bean.getBus_id2()			);
			pstmt.setString(29, bean.getReg_id()			);
			pstmt.setString(30, bean.getIns_com_id().trim()	);
			pstmt.setString(31, bean.getIns_etc().trim()	);
			pstmt.setString(32, bean.getUse_hour().trim()	);
			pstmt.setString(33, bean.getIns_zip().trim()	);
			pstmt.setString(34, bean.getApp_docs().trim()	);
            count = pstmt.executeUpdate();
            
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:insertMyAccid]\n"+se);

				System.out.println("[bean.getCar_mng_id().trim()	]\n"+bean.getCar_mng_id().trim()	);
				System.out.println("[bean.getAccid_id().trim()		]\n"+bean.getAccid_id().trim()		);
				System.out.println("[bean.getIns_req_gu().trim()	]\n"+bean.getIns_req_gu().trim()	);
				System.out.println("[bean.getIns_req_st().trim()	]\n"+bean.getIns_req_st().trim()	);
				System.out.println("[bean.getIns_car_nm().trim()	]\n"+bean.getIns_car_nm().trim()	);
				System.out.println("[bean.getIns_car_no().trim()	]\n"+bean.getIns_car_no().trim()	);
				System.out.println("[bean.getIns_day_amt()			]\n"+bean.getIns_day_amt()			);
				System.out.println("[bean.getIns_use_st().trim()	]\n"+bean.getIns_use_st().trim()	);
				System.out.println("[bean.getIns_use_et().trim()	]\n"+bean.getIns_use_et().trim()	);
				System.out.println("[bean.getIns_nm().trim()		]\n"+bean.getIns_nm().trim()		);
				System.out.println("[bean.getIns_tel().trim()		]\n"+bean.getIns_tel().trim()		);
				System.out.println("[bean.getIns_req_amt()			]\n"+bean.getIns_req_amt()			);
				System.out.println("[bean.getIns_req_dt().trim()	]\n"+bean.getIns_req_dt().trim()	);
				System.out.println("[bean.getIns_pay_amt()			]\n"+bean.getIns_pay_amt()			);
				System.out.println("[bean.getIns_pay_dt().trim()	]\n"+bean.getIns_pay_dt().trim()	);
				System.out.println("[bean.getIns_use_day().trim()	]\n"+bean.getIns_use_day().trim()	);
				System.out.println("[bean.getIns_tel2().trim()		]\n"+bean.getIns_tel2().trim()		);
				System.out.println("[bean.getIns_fax().trim()		]\n"+bean.getIns_fax().trim()		);
				System.out.println("[bean.getIns_addr().trim()		]\n"+bean.getIns_addr().trim()		);
				System.out.println("[bean.getIns_com().trim()		]\n"+bean.getIns_com().trim()		);
				System.out.println("[bean.getRe_reason().trim()		]\n"+bean.getRe_reason().trim()		);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 인적사항 등록
     */
    public int insertOtAccid(OtAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        int seq_no = 0;
        int count = 0;
                
        query = " INSERT INTO ot_accid("+
				" CAR_MNG_ID, ACCID_ID, SEQ_NO, OT_CAR_NO, OT_CAR_NM, OT_DRIVER, OT_TEL, OT_M_TEL,"+
				" OT_INS, OT_NUM, OT_INS_NM, OT_INS_TEL, OT_INS_M_TEL,"+
				" OT_SSN, OT_LIC_KD, OT_LIC_NO, OT_TEL2, OT_DAM_ST, OT_FAULT_PER,"+
				" HUM_NM, HUM_TEL, HUM_M_TEL, MAT_NM, MAT_TEL, MAT_M_TEL,"+
				" SERV_DT, OFF_NM, OFF_TEL, OFF_FAX, SERV_AMT, SERV_CONT, SERV_NM,"+
				" REG_DT, REG_ID"+
				" )\n"+
				" values(?,?,?,?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,?,  ?,?,?,?,?,?,  replace(?,'-',''),?,?,?,?,?,?,  to_char(sysdate,'YYYYMMDD'),?)\n";

		query1= " select nvl(max(seq_no)+1,1) from ot_accid where car_mng_id=? and accid_id=?";
    
       try{
            con.setAutoCommit(false);

            pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, bean.getCar_mng_id().trim());
            pstmt1.setString(2, bean.getAccid_id().trim());
			rs = pstmt1.executeQuery();
            if(rs.next()){
				seq_no = rs.getInt(1);
            }
			rs.close();
			pstmt1.close();

            pstmt = con.prepareStatement(query);
            pstmt.setString(1,  bean.getCar_mng_id().trim()		);
			pstmt.setString(2,  bean.getAccid_id().trim()		);
			pstmt.setInt   (3,  seq_no							);
			pstmt.setString(4,  bean.getOt_car_no().trim()		);
			pstmt.setString(5,  bean.getOt_car_nm().trim()		);
			pstmt.setString(6,  bean.getOt_driver().trim()		);
			pstmt.setString(7,  bean.getOt_tel().trim()			);
			pstmt.setString(8,  bean.getOt_m_tel().trim()		);
			pstmt.setString(9,  bean.getOt_ins().trim()			);
			pstmt.setString(10, bean.getOt_num().trim()			);
			pstmt.setString(11, bean.getOt_ins_nm().trim()		);
			pstmt.setString(12, bean.getOt_ins_tel().trim()		);
			pstmt.setString(13, bean.getOt_ins_m_tel().trim()	);
			pstmt.setString(14, bean.getOt_ssn().trim()			);
			pstmt.setString(15, bean.getOt_lic_kd().trim()		);
			pstmt.setString(16, bean.getOt_lic_no().trim()		);
			pstmt.setString(17, bean.getOt_tel2().trim()		);
			pstmt.setString(18, bean.getOt_dam_st().trim()		);
			pstmt.setInt   (19, bean.getOt_fault_per()			);
			pstmt.setString(20, bean.getHum_nm().trim()			);
			pstmt.setString(21, bean.getHum_tel().trim()		);
			pstmt.setString(22, bean.getHum_m_tel().trim()		);
			pstmt.setString(23, bean.getMat_nm().trim()			);
			pstmt.setString(24, bean.getMat_tel().trim()		);
			pstmt.setString(25, bean.getMat_m_tel().trim()		);
			pstmt.setString(26, bean.getServ_dt().trim()		);
			pstmt.setString(27, bean.getOff_nm().trim()			);
			pstmt.setString(28, bean.getOff_tel().trim()		);
			pstmt.setString(29, bean.getOff_fax().trim()		);
			pstmt.setInt   (30, bean.getServ_amt()				);
			pstmt.setString(31, bean.getServ_cont().trim()		);
			pstmt.setString(32, bean.getServ_nm().trim()		);
			pstmt.setString(33, bean.getReg_id().trim()			);
            count = pstmt.executeUpdate();
            
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:insertOtAccid]\n"+se);

				System.out.println("[bean.getCar_mng_id().trim()	]\n"+bean.getCar_mng_id().trim()	);
				System.out.println("[bean.getAccid_id().trim()		]\n"+bean.getAccid_id().trim()		);
				System.out.println("[seq_no							]\n"+seq_no							);
				System.out.println("[bean.getOt_car_no().trim()		]\n"+bean.getOt_car_no().trim()		);
				System.out.println("[bean.getOt_car_nm().trim()		]\n"+bean.getOt_car_nm().trim()		);
				System.out.println("[bean.getOt_driver().trim()		]\n"+bean.getOt_driver().trim()		);
				System.out.println("[bean.getOt_tel().trim()		]\n"+bean.getOt_tel().trim()		);
				System.out.println("[bean.getOt_m_tel().trim()		]\n"+bean.getOt_m_tel().trim()		);
				System.out.println("[bean.getOt_ins().trim()		]\n"+bean.getOt_ins().trim()		);
				System.out.println("[bean.getOt_num().trim()		]\n"+bean.getOt_num().trim()		);
				System.out.println("[bean.getOt_ins_nm().trim()		]\n"+bean.getOt_ins_nm().trim()		);
				System.out.println("[bean.getOt_ins_tel().trim()	]\n"+bean.getOt_ins_tel().trim()	);
				System.out.println("[bean.getOt_ins_m_tel().trim()	]\n"+bean.getOt_ins_m_tel().trim()	);
				System.out.println("[bean.getOt_ssn().trim()		]\n"+bean.getOt_ssn().trim()		);
				System.out.println("[bean.getOt_lic_kd().trim()		]\n"+bean.getOt_lic_kd().trim()		);
				System.out.println("[bean.getOt_lic_no().trim()		]\n"+bean.getOt_lic_no().trim()		);
				System.out.println("[bean.getOt_tel2().trim()		]\n"+bean.getOt_tel2().trim()		);
				System.out.println("[bean.getOt_dam_st().trim()		]\n"+bean.getOt_dam_st().trim()		);
				System.out.println("[bean.getOt_fault_per()			]\n"+bean.getOt_fault_per()			);
				System.out.println("[bean.getHum_nm().trim()		]\n"+bean.getHum_nm().trim()		);
				System.out.println("[bean.getHum_tel().trim()		]\n"+bean.getHum_tel().trim()		);
				System.out.println("[bean.getHum_m_tel().trim()		]\n"+bean.getHum_m_tel().trim()		);
				System.out.println("[bean.getMat_nm().trim()		]\n"+bean.getMat_nm().trim()		);
				System.out.println("[bean.getMat_tel().trim()		]\n"+bean.getMat_tel().trim()		);
				System.out.println("[bean.getMat_m_tel().trim()		]\n"+bean.getMat_m_tel().trim()		);
				System.out.println("[bean.getServ_dt().trim()		]\n"+bean.getServ_dt().trim()		);
				System.out.println("[bean.getOff_nm().trim()		]\n"+bean.getOff_nm().trim()		);
				System.out.println("[bean.getOff_tel().trim()		]\n"+bean.getOff_tel().trim()		);
				System.out.println("[bean.getOff_fax().trim()		]\n"+bean.getOff_fax().trim()		);
				System.out.println("[bean.getServ_amt()				]\n"+bean.getServ_amt()				);
				System.out.println("[bean.getServ_cont().trim()		]\n"+bean.getServ_cont().trim()		);
				System.out.println("[bean.getServ_nm().trim()		]\n"+bean.getServ_nm().trim()		);
				System.out.println("[bean.getReg_id().trim()		]\n"+bean.getReg_id().trim()		);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null)	pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }


	// 사고 수정 -------------------------------------------------------------------------------------------------

	/**
     * 사고기록 수정
     */
    public int updateAccident(AccidentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update accident set"+
				"			RENT_MNG_ID=?, RENT_L_CD=?, ACCID_ST=?, OUR_CAR_NM=?, OUR_DRIVER=?,"+
				"			OUR_TEL=?, OUR_M_TEL=?, OUR_SSN=replace(?,'-',''), OUR_LIC_KD=?, OUR_LIC_NO=?,"+
				"			OUR_INS=?, OUR_NUM=?, OUR_POST=?, OUR_ADDR=?, ACCID_DT=replace(?,'-',''),"+
				"			ACCID_CITY=?, ACCID_GU=?, ACCID_DONG=?, ACCID_POINT=?, ACCID_CONT=?,"+
				"			OT_CAR_NO=?, OT_CAR_NM=?, OT_DRIVER=?, OT_TEL=?, OT_M_TEL=?,"+
				"			OT_INS=?, OT_NUM=?, OT_INS_NM=?, OT_INS_TEL=?, OT_INS_M_TEL=?,"+
				"			OT_POL_STA=?, OT_POL_NM=?, OT_POL_TEL=?, OT_POL_M_TEL=?, HUM_AMT=?,"+
				"			HUM_NM=?, HUM_TEL=?, MAT_AMT=?, MAT_NM=?, MAT_TEL=?,"+
				"			ONE_AMT=?, ONE_NM=?, ONE_TEL=?, MY_AMT=?, MY_NM=?,"+
				"			MY_TEL=?, REF_DT=replace(?,'-',''), EX_TOT_AMT=?, TOT_AMT=?, REC_AMT=?,"+
				"			REC_DT=replace(?,'-',''), REC_PLAN_DT=replace(?,'-',''), SUP_AMT=?, SUP_DT=replace(?,'-',''), INS_SUP_AMT=?,"+
				"			INS_SUP_DT=replace(?,'-',''), INS_TOT_AMT=?\n,"+//57
				"			SUB_RENT_GU=?, SUB_FIRM_NM=?, SUB_RENT_ST=replace(?,'-',''), SUB_RENT_ET=replace(?,'-',''), SUB_ETC=?,"+
				"			ACC_DT=replace(?,'-',''), ACC_ID=?, UPDATE_DT=replace(?,'-',''), UPDATE_ID=?, OUR_LIC_DT=replace(?,'-',''),"+
				"			OUR_TEL2=?, OT_SSN=replace(?,'-',''), OT_LIC_NO=?, OT_LIC_KD=?, OT_TEL2=?,"+
				"			OUR_DAM_ST=?, OT_DAM_ST=?, ACCID_ADDR=?, ACCID_CONT2=?, IMP_FAULT_ST=?,"+
				"			IMP_FAULT_SUB=?, OUR_FAULT_PER=?, OT_POL_ST=?, OT_POL_NUM=?, OT_POL_FAX=?, MEMO=?,"+
				"			CAR_IN_DT=replace(?,'-',''), CAR_OUT_DT=replace(?,'-',''), INS_END_DT=replace(?,'-',''), "+//83+3
				"			RENT_S_CD=?, ACCID_TYPE=?, ACCID_TYPE_SUB=?, SPEED=?, ROAD_STAT=?, ROAD_STAT2=?, WEATHER=?,"+//92
				"			HUM_END_DT=replace(?,'-',''), MAT_END_DT=replace(?,'-',''), ONE_END_DT=replace(?,'-',''), MY_END_DT=replace(?,'-',''),"+//96
				"			SETTLE_ST=?, SETTLE_DT=replace(?,'-',''), SETTLE_ID=?, SETTLE_CONT=?,"+//100
				"			DAM_TYPE1=?, DAM_TYPE2=?, DAM_TYPE3=?, DAM_TYPE4=?,"+//104
				"			SETTLE_ST1=?, SETTLE_DT1=replace(?,'-',''), SETTLE_ID1=?,"+
				"			SETTLE_ST2=?, SETTLE_DT2=replace(?,'-',''), SETTLE_ID2=?,"+
				"			SETTLE_ST3=?, SETTLE_DT3=replace(?,'-',''), SETTLE_ID3=?,"+
				"			SETTLE_ST4=?, SETTLE_DT4=replace(?,'-',''), SETTLE_ID4=?,"+
				"			SETTLE_ST5=?, SETTLE_DT5=replace(?,'-',''), SETTLE_ID5=?, SETTLE_NOTE=?, pre_doc = ? , pre_cls = ? , asset_st = ?   "+//120
				" where car_mng_id=? and accid_id=?\n";
    
       try{
            con.setAutoCommit(false);
            			
            pstmt = con.prepareStatement(query);
            
			pstmt.setString(1,  bean.getRent_mng_id().trim()	);
			pstmt.setString(2,  bean.getRent_l_cd().trim()		);
			pstmt.setString(3,  bean.getAccid_st().trim()		);
			pstmt.setString(4,  bean.getOur_car_nm().trim()		);
			pstmt.setString(5,  bean.getOur_driver().trim()		);
			pstmt.setString(6,  bean.getOur_tel().trim()		);
			pstmt.setString(7,  bean.getOur_m_tel().trim()		);
			pstmt.setString(8,  bean.getOur_ssn().trim()		);
			pstmt.setString(9,  bean.getOur_lic_kd().trim()		);
			pstmt.setString(10, bean.getOur_lic_no().trim()		);
			pstmt.setString(11, bean.getOur_ins().trim()		);
			pstmt.setString(12, bean.getOur_num().trim()		);
			pstmt.setString(13, bean.getOur_post().trim()		);
			pstmt.setString(14, bean.getOur_addr().trim()		);
			pstmt.setString(15, bean.getAccid_dt().trim()		);
			pstmt.setString(16, bean.getAccid_city().trim()		);
			pstmt.setString(17, bean.getAccid_gu().trim()		);
			pstmt.setString(18, bean.getAccid_dong().trim()		);
			pstmt.setString(19, bean.getAccid_point().trim()	);
			pstmt.setString(20, bean.getAccid_cont().trim()		);
			pstmt.setString(21, bean.getOt_car_no().trim()		);
			pstmt.setString(22, bean.getOt_car_nm().trim()		);
			pstmt.setString(23, bean.getOt_driver().trim()		);
			pstmt.setString(24, bean.getOt_tel().trim()			);
			pstmt.setString(25, bean.getOt_m_tel().trim()		);
			pstmt.setString(26, bean.getOt_ins().trim()			);
			pstmt.setString(27, bean.getOt_num().trim()			);
			pstmt.setString(28, bean.getOt_ins_nm().trim()		);
			pstmt.setString(29, bean.getOt_ins_tel().trim()		);
			pstmt.setString(30, bean.getOt_ins_m_tel().trim()	);
			pstmt.setString(31, bean.getOt_pol_sta().trim()		);
			pstmt.setString(32, bean.getOt_pol_nm().trim()		);
			pstmt.setString(33, bean.getOt_pol_tel().trim()		);
			pstmt.setString(34, bean.getOt_pol_m_tel().trim()	);
			pstmt.setInt   (35, bean.getHum_amt()				);
			pstmt.setString(36, bean.getHum_nm().trim()			);
			pstmt.setString(37, bean.getHum_tel().trim()		);
			pstmt.setInt   (38, bean.getMat_amt()				);
			pstmt.setString(39, bean.getMat_nm().trim()			);
			pstmt.setString(40, bean.getMat_tel().trim()		);
			pstmt.setInt   (41, bean.getOne_amt()				);
			pstmt.setString(42, bean.getOne_nm().trim()			);
			pstmt.setString(43, bean.getOne_tel().trim()		);
			pstmt.setInt   (44, bean.getMy_amt()				);
			pstmt.setString(45, bean.getMy_nm().trim()			);
			pstmt.setString(46, bean.getMy_tel().trim()			);
			pstmt.setString(47, bean.getRef_dt().trim()			);
			pstmt.setInt   (48, bean.getEx_tot_amt()			);
			pstmt.setInt   (49, bean.getTot_amt()				);
			pstmt.setInt   (50, bean.getRec_amt()				);
			pstmt.setString(51, bean.getRec_dt().trim()			);
			pstmt.setString(52, bean.getRec_plan_dt().trim()	);
			pstmt.setInt   (53, bean.getSup_amt()				);
			pstmt.setString(54, bean.getSup_dt().trim()			);
			pstmt.setInt   (55, bean.getIns_sup_amt()			);
			pstmt.setString(56, bean.getIns_sup_dt().trim()		);
			pstmt.setInt   (57, bean.getIns_tot_amt()			);
			pstmt.setString(58, bean.getSub_rent_gu().trim()	);
			pstmt.setString(59, bean.getSub_firm_nm().trim()	);
			pstmt.setString(60, bean.getSub_rent_st().trim()	);
			pstmt.setString(61, bean.getSub_rent_et().trim()	);
			pstmt.setString(62, bean.getSub_etc().trim()		);
			pstmt.setString(63, bean.getAcc_dt().trim()			);
			pstmt.setString(64, bean.getAcc_id().trim()			);
			pstmt.setString(65, bean.getUpdate_dt().trim()		);
			pstmt.setString(66, bean.getUpdate_id().trim()		);
			pstmt.setString(67, bean.getOur_lic_dt().trim()		);
			pstmt.setString(68, bean.getOur_tel2().trim()		);
			pstmt.setString(69, bean.getOt_ssn().trim()			);
			pstmt.setString(70, bean.getOt_lic_no().trim()		);
			pstmt.setString(71, bean.getOt_lic_kd().trim()		);
			pstmt.setString(72, bean.getOt_tel2().trim()		);
			pstmt.setString(73, bean.getOur_dam_st().trim()		);
			pstmt.setString(74, bean.getOt_dam_st().trim()		);
			pstmt.setString(75, bean.getAccid_addr().trim()		);
			pstmt.setString(76, bean.getAccid_cont2().trim()	);
			pstmt.setString(77, bean.getImp_fault_st().trim()	);
			pstmt.setString(78, bean.getImp_fault_sub().trim()	);
			pstmt.setInt   (79, bean.getOur_fault_per()			);
			pstmt.setString(80, bean.getOt_pol_st().trim()		);
			pstmt.setString(81, bean.getOt_pol_num().trim()		);
			pstmt.setString(82, bean.getOt_pol_fax().trim()		);
			pstmt.setString(83, bean.getMemo().trim()			);
			pstmt.setString(84, bean.getCar_in_dt().trim()		);
			pstmt.setString(85, bean.getCar_out_dt().trim()		);
			pstmt.setString(86, bean.getIns_end_dt().trim()		);
			pstmt.setString(87, bean.getRent_s_cd().trim()		);
			pstmt.setString(88, bean.getAccid_type().trim()		);
			pstmt.setString(89, bean.getAccid_type_sub().trim()	);
			pstmt.setString(90, bean.getSpeed().trim()			);
			pstmt.setString(91, bean.getRoad_stat().trim()		);
			pstmt.setString(92, bean.getRoad_stat2().trim()		);
			pstmt.setString(93, bean.getWeather().trim()		);
			pstmt.setString(94, bean.getHum_end_dt().trim()		);
			pstmt.setString(95, bean.getMat_end_dt().trim()		);
			pstmt.setString(96, bean.getOne_end_dt().trim()		);
			pstmt.setString(97, bean.getMy_end_dt().trim()		);
			pstmt.setString(98, bean.getSettle_st().trim()		);
			pstmt.setString(99, bean.getSettle_dt().trim()		);
			pstmt.setString(100, bean.getSettle_id().trim()		);
			pstmt.setString(101, bean.getSettle_cont().trim()	);
			pstmt.setString(102, bean.getDam_type1().trim()		);
			pstmt.setString(103, bean.getDam_type2().trim()		);
			pstmt.setString(104, bean.getDam_type3().trim()		);
			pstmt.setString(105, bean.getDam_type4().trim()		);
			pstmt.setString(106, bean.getSettle_st1().trim()	);
			pstmt.setString(107, bean.getSettle_dt1().trim()	);
			pstmt.setString(108, bean.getSettle_id1().trim()	);
			pstmt.setString(109, bean.getSettle_st2().trim()	);
			pstmt.setString(110, bean.getSettle_dt2().trim()	);
			pstmt.setString(111, bean.getSettle_id2().trim()	);
			pstmt.setString(112, bean.getSettle_st3().trim()	);
			pstmt.setString(113, bean.getSettle_dt3().trim()	);
			pstmt.setString(114, bean.getSettle_id3().trim()	);
			pstmt.setString(115, bean.getSettle_st4().trim()	);
			pstmt.setString(116, bean.getSettle_dt4().trim()	);
			pstmt.setString(117, bean.getSettle_id4().trim()	);
			pstmt.setString(118, bean.getSettle_st5().trim()	);
			pstmt.setString(119, bean.getSettle_dt5().trim()	);
			pstmt.setString(120, bean.getSettle_id5().trim()	);
			pstmt.setString(121, bean.getSettle_note().trim()	);
			pstmt.setString(122, bean.getPre_doc().trim()	);
			pstmt.setString(123, bean.getPre_cls().trim()	);
			pstmt.setString(124, bean.getAsset_st().trim()	);
      
         	pstmt.setString(125, bean.getCar_mng_id().trim()	);
			pstmt.setString(126, bean.getAccid_id().trim()		);

			count = pstmt.executeUpdate();
            
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateAccident]\n"+se);

				System.out.println("[bean.getRent_mng_id().trim()	]\n"+bean.getRent_mng_id().trim()	);
				System.out.println("[bean.getRent_l_cd().trim()		]\n"+bean.getRent_l_cd().trim()		);
				System.out.println("[bean.getAccid_st().trim()		]\n"+bean.getAccid_st().trim()		);
				System.out.println("[bean.getOur_car_nm().trim()	]\n"+bean.getOur_car_nm().trim()	);
				System.out.println("[bean.getOur_driver().trim()	]\n"+bean.getOur_driver().trim()	);
				System.out.println("[bean.getOur_tel().trim()		]\n"+bean.getOur_tel().trim()		);
				System.out.println("[bean.getOur_m_tel().trim()		]\n"+bean.getOur_m_tel().trim()		);
				System.out.println("[bean.getOur_ssn().trim()		]\n"+bean.getOur_ssn().trim()		);
				System.out.println("[bean.getOur_lic_kd().trim()	]\n"+bean.getOur_lic_kd().trim()	);
				System.out.println("[bean.getOur_lic_no().trim()	]\n"+bean.getOur_lic_no().trim()	);
				System.out.println("[bean.getOur_ins().trim()		]\n"+bean.getOur_ins().trim()		);
				System.out.println("[bean.getOur_num().trim()		]\n"+bean.getOur_num().trim()		);
				System.out.println("[bean.getOur_post().trim()		]\n"+bean.getOur_post().trim()		);
				System.out.println("[bean.getOur_addr().trim()		]\n"+bean.getOur_addr().trim()		);
				System.out.println("[bean.getAccid_dt().trim()		]\n"+bean.getAccid_dt().trim()		);
				System.out.println("[bean.getAccid_city().trim()	]\n"+bean.getAccid_city().trim()	);
				System.out.println("[bean.getAccid_gu().trim()		]\n"+bean.getAccid_gu().trim()		);
				System.out.println("[bean.getAccid_dong().trim()	]\n"+bean.getAccid_dong().trim()	);
				System.out.println("[bean.getAccid_point().trim()	]\n"+bean.getAccid_point().trim()	);
				System.out.println("[bean.getAccid_cont().trim()	]\n"+bean.getAccid_cont().trim()	);
				System.out.println("[bean.getOt_car_no().trim()		]\n"+bean.getOt_car_no().trim()		);
				System.out.println("[bean.getOt_car_nm().trim()		]\n"+bean.getOt_car_nm().trim()		);
				System.out.println("[bean.getOt_driver().trim()		]\n"+bean.getOt_driver().trim()		);
				System.out.println("[bean.getOt_tel().trim()		]\n"+bean.getOt_tel().trim()		);
				System.out.println("[bean.getOt_m_tel().trim()		]\n"+bean.getOt_m_tel().trim()		);
				System.out.println("[bean.getOt_ins().trim()		]\n"+bean.getOt_ins().trim()		);
				System.out.println("[bean.getOt_num().trim()		]\n"+bean.getOt_num().trim()		);
				System.out.println("[bean.getOt_ins_nm().trim()		]\n"+bean.getOt_ins_nm().trim()		);
				System.out.println("[bean.getOt_ins_tel().trim()	]\n"+bean.getOt_ins_tel().trim()	);
				System.out.println("[bean.getOt_ins_m_tel().trim()	]\n"+bean.getOt_ins_m_tel().trim()	);
				System.out.println("[bean.getOt_pol_sta().trim()	]\n"+bean.getOt_pol_sta().trim()	);
				System.out.println("[bean.getOt_pol_nm().trim()		]\n"+bean.getOt_pol_nm().trim()		);
				System.out.println("[bean.getOt_pol_tel().trim()	]\n"+bean.getOt_pol_tel().trim()	);
				System.out.println("[bean.getOt_pol_m_tel().trim()	]\n"+bean.getOt_pol_m_tel().trim()	);
				System.out.println("[bean.getHum_amt()				]\n"+bean.getHum_amt()				);
				System.out.println("[bean.getHum_nm().trim()		]\n"+bean.getHum_nm().trim()		);
				System.out.println("[bean.getHum_tel().trim()		]\n"+bean.getHum_tel().trim()		);
				System.out.println("[bean.getMat_amt()				]\n"+bean.getMat_amt()				);
				System.out.println("[bean.getMat_nm().trim()		]\n"+bean.getMat_nm().trim()		);
				System.out.println("[bean.getMat_tel().trim()		]\n"+bean.getMat_tel().trim()		);
				System.out.println("[bean.getOne_amt()				]\n"+bean.getOne_amt()				);
				System.out.println("[bean.getOne_nm().trim()		]\n"+bean.getOne_nm().trim()		);
				System.out.println("[bean.getOne_tel().trim()		]\n"+bean.getOne_tel().trim()		);
				System.out.println("[bean.getMy_amt()				]\n"+bean.getMy_amt()				);
				System.out.println("[bean.getMy_nm().trim()			]\n"+bean.getMy_nm().trim()			);
				System.out.println("[bean.getMy_tel().trim()		]\n"+bean.getMy_tel().trim()		);
				System.out.println("[bean.getRef_dt().trim()		]\n"+bean.getRef_dt().trim()		);
				System.out.println("[bean.getEx_tot_amt()			]\n"+bean.getEx_tot_amt()			);
				System.out.println("[bean.getTot_amt()				]\n"+bean.getTot_amt()				);
				System.out.println("[bean.getRec_amt()				]\n"+bean.getRec_amt()				);
				System.out.println("[bean.getRec_dt().trim()		]\n"+bean.getRec_dt().trim()		);
				System.out.println("[bean.getRec_plan_dt().trim()	]\n"+bean.getRec_plan_dt().trim()	);
				System.out.println("[bean.getSup_amt()				]\n"+bean.getSup_amt()				);
				System.out.println("[bean.getSup_dt().trim()		]\n"+bean.getSup_dt().trim()		);
				System.out.println("[bean.getIns_sup_amt()			]\n"+bean.getIns_sup_amt()			);
				System.out.println("[bean.getIns_sup_dt().trim()	]\n"+bean.getIns_sup_dt().trim()	);
				System.out.println("[bean.getIns_tot_amt()			]\n"+bean.getIns_tot_amt()			);
				System.out.println("[bean.getSub_rent_gu().trim()	]\n"+bean.getSub_rent_gu().trim()	);
				System.out.println("[bean.getSub_firm_nm().trim()	]\n"+bean.getSub_firm_nm().trim()	);
				System.out.println("[bean.getSub_rent_st().trim()	]\n"+bean.getSub_rent_st().trim()	);
				System.out.println("[bean.getSub_rent_et().trim()	]\n"+bean.getSub_rent_et().trim()	);
				System.out.println("[bean.getSub_etc().trim()		]\n"+bean.getSub_etc().trim()		);
				System.out.println("[bean.getReg_dt().trim()		]\n"+bean.getReg_dt().trim()		);
				System.out.println("[bean.getReg_id().trim()		]\n"+bean.getReg_id().trim()		);
				System.out.println("[bean.getUpdate_dt().trim()		]\n"+bean.getUpdate_dt().trim()		);
				System.out.println("[bean.getUpdate_id().trim()		]\n"+bean.getUpdate_id().trim()		);
				System.out.println("[bean.getOur_lic_dt().trim()	]\n"+bean.getOur_lic_dt().trim()	);
				System.out.println("[bean.getOur_tel2().trim()		]\n"+bean.getOur_tel2().trim()		);
				System.out.println("[bean.getOt_ssn().trim()		]\n"+bean.getOt_ssn().trim()		);
				System.out.println("[bean.getOt_lic_no().trim()		]\n"+bean.getOt_lic_no().trim()		);
				System.out.println("[bean.getOt_lic_kd().trim()		]\n"+bean.getOt_lic_kd().trim()		);
				System.out.println("[bean.getOt_tel2().trim()		]\n"+bean.getOt_tel2().trim()		);
				System.out.println("[bean.getOur_dam_st().trim()	]\n"+bean.getOur_dam_st().trim()	);
				System.out.println("[bean.getOt_dam_st().trim()		]\n"+bean.getOt_dam_st().trim()		);
				System.out.println("[bean.getAccid_addr().trim()	]\n"+bean.getAccid_addr().trim()	);
				System.out.println("[bean.getAccid_cont2().trim()	]\n"+bean.getAccid_cont2().trim()	);
				System.out.println("[bean.getImp_fault_st().trim()	]\n"+bean.getImp_fault_st().trim()	);
				System.out.println("[bean.getImp_fault_sub().trim()	]\n"+bean.getImp_fault_sub().trim()	);
				System.out.println("[bean.getOur_fault_per()		]\n"+bean.getOur_fault_per()		);
				System.out.println("[bean.getOt_pol_st().trim()		]\n"+bean.getOt_pol_st().trim()		);
				System.out.println("[bean.getOt_pol_num().trim()	]\n"+bean.getOt_pol_num().trim()	);
				System.out.println("[bean.getOt_pol_fax().trim()	]\n"+bean.getOt_pol_fax().trim()	);
				System.out.println("[bean.getMemo().trim()			]\n"+bean.getMemo().trim()			);
				System.out.println("[bean.getCar_in_dt().trim()		]\n"+bean.getCar_in_dt().trim()		);
				System.out.println("[bean.getCar_out_dt().trim()	]\n"+bean.getCar_out_dt().trim()	);
				System.out.println("[bean.getIns_end_dt().trim()	]\n"+bean.getIns_end_dt().trim()	);
				System.out.println("[bean.getRent_s_cd().trim()		]\n"+bean.getRent_s_cd().trim()		);
				System.out.println("[bean.getAccid_type().trim()	]\n"+bean.getAccid_type().trim()	);
				System.out.println("[bean.getAccid_type_sub().trim()]\n"+bean.getAccid_type_sub().trim());
				System.out.println("[bean.getSpeed().trim()			]\n"+bean.getSpeed().trim()			);
				System.out.println("[bean.getRoad_stat().trim()		]\n"+bean.getRoad_stat().trim()		);
				System.out.println("[bean.getRoad_stat2().trim()	]\n"+bean.getRoad_stat2().trim()	);
				System.out.println("[bean.getWeather().trim()		]\n"+bean.getWeather().trim()		);
				System.out.println("[bean.getHum_end_dt().trim()	]\n"+bean.getHum_end_dt().trim()	);
				System.out.println("[bean.getMat_end_dt().trim()	]\n"+bean.getMat_end_dt().trim()	);
				System.out.println("[bean.getOne_end_dt().trim()	]\n"+bean.getOne_end_dt().trim()	);
				System.out.println("[bean.getMy_end_dt().trim()		]\n"+bean.getMy_end_dt().trim()		);
				System.out.println("[bean.getSettle_st().trim()		]\n"+bean.getSettle_st().trim()		);
				System.out.println("[bean.getSettle_dt().trim()		]\n"+bean.getSettle_dt().trim()		);
				System.out.println("[ bean.getSettle_id().trim()	]\n"+ bean.getSettle_id().trim()	);
				System.out.println("[ bean.getSettle_cont().trim()	]\n"+ bean.getSettle_cont().trim()	);
				System.out.println("[ bean.getDam_type1().trim()	]\n"+ bean.getDam_type1().trim()	);
				System.out.println("[ bean.getDam_type2().trim()	]\n"+ bean.getDam_type2().trim()	);
				System.out.println("[ bean.getDam_type3().trim()	]\n"+ bean.getDam_type3().trim()	);
				System.out.println("[ bean.getDam_type4().trim()	]\n"+ bean.getDam_type4().trim()	);
				System.out.println("[ bean.getSettle_st1().trim()	]\n"+ bean.getSettle_st1().trim()	);
				System.out.println("[ bean.getSettle_dt1().trim()	]\n"+ bean.getSettle_dt1().trim()	);
				System.out.println("[ bean.getSettle_id1().trim()	]\n"+ bean.getSettle_id1().trim()	);
				System.out.println("[ bean.getSettle_st2().trim()	]\n"+ bean.getSettle_st2().trim()	);
				System.out.println("[ bean.getSettle_dt2().trim()	]\n"+ bean.getSettle_dt2().trim()	);
				System.out.println("[ bean.getSettle_id2().trim()	]\n"+ bean.getSettle_id2().trim()	);
				System.out.println("[ bean.getSettle_st3().trim()	]\n"+ bean.getSettle_st3().trim()	);
				System.out.println("[ bean.getSettle_dt3().trim()	]\n"+ bean.getSettle_dt3().trim()	);
				System.out.println("[ bean.getSettle_id3().trim()	]\n"+ bean.getSettle_id3().trim()	);
				System.out.println("[ bean.getSettle_st4().trim()	]\n"+ bean.getSettle_st4().trim()	);
				System.out.println("[ bean.getSettle_dt4().trim()	]\n"+ bean.getSettle_dt4().trim()	);
				System.out.println("[ bean.getSettle_id4().trim()	]\n"+ bean.getSettle_id4().trim()	);
				System.out.println("[ bean.getSettle_st5().trim()	]\n"+ bean.getSettle_st5().trim()	);
				System.out.println("[ bean.getSettle_dt5().trim()	]\n"+ bean.getSettle_dt5().trim()	);
				System.out.println("[ bean.getSettle_id5().trim()	]\n"+ bean.getSettle_id5().trim()	);
				System.out.println("[ bean.getSettle_note().trim()	]\n"+ bean.getSettle_note().trim()	);
				System.out.println("[ bean.getCar_mng_id().trim()	]\n"+ bean.getCar_mng_id().trim()	);
				System.out.println("[ bean.getAccid_id().trim()		]\n"+ bean.getAccid_id().trim()		);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 자손 수정  : car_accid_all_u_a.jsp
     */
    public int updateOneAccid(OneAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update one_accid set"+
				" NM=?, SEX=?, HOSP=?, HOSP_TEL=?, INS_NM=?, INS_TEL=?, TEL=?, AGE=?, RELATION=?, DIAGNOSIS=?,"+
				" ETC=?, ONE_ACCID_ST=?, WOUND_ST=?, ot_seq_no=?\n"+
				" where car_mng_id=? and accid_id=? and seq_no=?\n";

    
       try{
            con.setAutoCommit(false);
            			
            pstmt = con.prepareStatement(query);
            			
			pstmt.setString(1, bean.getNm().trim());
			pstmt.setString(2, bean.getSex().trim());
			pstmt.setString(3, bean.getHosp().trim());
			pstmt.setString(4, bean.getHosp_tel().trim());
			pstmt.setString(5, bean.getIns_nm().trim());
			pstmt.setString(6, bean.getIns_tel().trim());
			pstmt.setString(7, bean.getTel().trim());
			pstmt.setString(8, bean.getAge().trim());
			pstmt.setString(9, bean.getRelation().trim());
			pstmt.setString(10, bean.getDiagnosis().trim());
			pstmt.setString(11, bean.getEtc().trim());
			pstmt.setString(12, bean.getOne_accid_st().trim());
			pstmt.setString(13, bean.getWound_st().trim());
			pstmt.setInt   (14, bean.getOt_seq_no());
			pstmt.setString(15, bean.getCar_mng_id().trim());
			pstmt.setString(16, bean.getAccid_id().trim());
			pstmt.setInt   (17, bean.getSeq_no());

            count = pstmt.executeUpdate();
             
            pstmt.close(); 
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateOneAccid]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

   /**
     * 보험금청구내역 update (휴차/대차료 보험회사 청구내용)
     */
    public int updateMyAccid(MyAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE MY_ACCID SET"+
				" REQ_GU=?, REQ_ST=?, CAR_NM=?, CAR_NO=?, DAY_AMT=?,"+
				" USE_ST=replace(?,'-',''), USE_ET=replace(?,'-',''), INS_NM=?, INS_TEL=?, REQ_AMT=?,"+	
				" REQ_DT=replace(?,'-',''), PAY_AMT=?, PAY_DT=replace(?,'-',''), USE_DAY=?, INS_TEL2=?, INS_FAX=?, INS_ADDR=?, INS_COM=?, RE_REASON=?, "+
				" VAT_YN=?, MC_S_AMT=?, MC_V_AMT=?, INS_NUM=?, OT_FAULT_PER=?, pay_gu=? ,  incom_dt = replace(?,'-',''), incom_seq = ?, "+				
				" BUS_ID2 = ?, UPDATE_ID=?, UPDATE_DT=to_char(sysdate,'YYYYMMDD'), "+	
				" ins_com_id=?, ins_etc=?, use_hour=?, INS_ZIP=?, APP_DOCS=? "+
				" where car_mng_id=? and accid_id=? and seq_no=?\n";
    
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
			pstmt.setString(1, bean.getIns_req_gu().trim());
			pstmt.setString(2, bean.getIns_req_st().trim());
			pstmt.setString(3, bean.getIns_car_nm().trim());
			pstmt.setString(4, bean.getIns_car_no().trim());
			pstmt.setInt   (5, bean.getIns_day_amt());
			pstmt.setString(6, bean.getIns_use_st().trim());
			pstmt.setString(7, bean.getIns_use_et().trim());
			pstmt.setString(8, bean.getIns_nm().trim());
			pstmt.setString(9, bean.getIns_tel().trim());
			pstmt.setInt   (10, bean.getIns_req_amt());
			pstmt.setString(11, bean.getIns_req_dt().trim());
			pstmt.setInt   (12, bean.getIns_pay_amt());
			pstmt.setString(13, bean.getIns_pay_dt().trim());
			pstmt.setString(14, bean.getIns_use_day().trim());  
			pstmt.setString(15, bean.getIns_tel2().trim());
			pstmt.setString(16, bean.getIns_fax().trim());
			pstmt.setString(17, bean.getIns_addr().trim());			
			pstmt.setString(18, bean.getIns_com().trim());	
			pstmt.setString(19, bean.getRe_reason().trim());			
			pstmt.setString(20, bean.getVat_yn().trim());		
			pstmt.setInt   (21, bean.getMc_s_amt());
			pstmt.setInt   (22, bean.getMc_v_amt());		
			pstmt.setString(23, bean.getIns_num().trim());	
			pstmt.setInt   (24, bean.getOt_fault_per());		
			pstmt.setString(25, bean.getPay_gu().trim());					
			pstmt.setString(26, bean.getIncom_dt());	
			pstmt.setInt   (27, bean.getIncom_seq());				
			pstmt.setString(28, bean.getBus_id2());			
			pstmt.setString(29, bean.getUpdate_id());	
			pstmt.setString(30, bean.getIns_com_id().trim());	
			pstmt.setString(31, bean.getIns_etc().trim());	
			pstmt.setString(32, bean.getUse_hour().trim());	
			pstmt.setString(33, bean.getIns_zip().trim());			
			pstmt.setString(34, bean.getApp_docs().trim());			
				
            pstmt.setString(35, bean.getCar_mng_id().trim());
			pstmt.setString(36, bean.getAccid_id().trim());
			pstmt.setInt   (37, bean.getSeq_no());		

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateMyAccid]\n"+se);

				System.out.println("[bean.getSeq_no()]\n"+bean.getSeq_no());
				System.out.println("[bean.getOt_fault_per()]\n"+bean.getOt_fault_per());

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 인적사항 수정
     */
    public int updateOtAccid(OtAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update ot_accid set"+
				" OT_CAR_NO=?, OT_CAR_NM=?, OT_DRIVER=?, OT_TEL=?, OT_M_TEL=?,"+
				" OT_INS=?, OT_NUM=?, OT_INS_NM=?, OT_INS_TEL=?, OT_INS_M_TEL=?,"+
				" OT_SSN=replace(?,'-',''), OT_LIC_NO=?, OT_LIC_KD=?, OT_TEL2=?,"+
				" OT_DAM_ST=?, OT_FAULT_PER=?, HUM_NM=?, HUM_TEL=?, HUM_M_TEL=?, MAT_NM=?, MAT_TEL=?, MAT_M_TEL=?,"+
				" SERV_DT=replace(?,'-',''), OFF_NM=?, OFF_TEL=?, OFF_FAX=?, SERV_AMT=?, SERV_CONT=?, SERV_NM=?,"+
				" UPDATE_DT=to_char(sysdate,'YYYYMMDD'), UPDATE_ID=?,"+
				" amor_req_amt=?, amor_req_dt=replace(?,'-',''), amor_pay_amt=?, amor_pay_dt=replace(?,'-',''), amor_st=?, amor_req_id=?, amor_type=? "+
				" where car_mng_id=? and accid_id=? and seq_no=?\n";

    
       try{
            con.setAutoCommit(false);
            			
            pstmt = con.prepareStatement(query);

			pstmt.setString(1,  bean.getOt_car_no	().trim());
			pstmt.setString(2,  bean.getOt_car_nm	().trim());
			pstmt.setString(3,  bean.getOt_driver	().trim());
			pstmt.setString(4,  bean.getOt_tel		().trim());
			pstmt.setString(5,  bean.getOt_m_tel	().trim());
			pstmt.setString(6,  bean.getOt_ins		().trim());
			pstmt.setString(7,  bean.getOt_num		().trim());
			pstmt.setString(8,  bean.getOt_ins_nm	().trim());
			pstmt.setString(9,  bean.getOt_ins_tel	().trim());
			pstmt.setString(10, bean.getOt_ins_m_tel().trim());
			pstmt.setString(11, bean.getOt_ssn		().trim());
			pstmt.setString(12, bean.getOt_lic_no	().trim());
			pstmt.setString(13, bean.getOt_lic_kd	().trim());
			pstmt.setString(14, bean.getOt_tel2		().trim());
			pstmt.setString(15, bean.getOt_dam_st	().trim());
			pstmt.setInt   (16, bean.getOt_fault_per()       );
			pstmt.setString(17, bean.getHum_nm		().trim());
			pstmt.setString(18, bean.getHum_tel		().trim());
			pstmt.setString(19, bean.getHum_m_tel	().trim());
			pstmt.setString(20, bean.getMat_nm		().trim());
			pstmt.setString(21, bean.getMat_tel		().trim());
			pstmt.setString(22, bean.getMat_m_tel	().trim());
			pstmt.setString(23, bean.getServ_dt		().trim());
			pstmt.setString(24, bean.getOff_nm		().trim());
			pstmt.setString(25, bean.getOff_tel		().trim());
			pstmt.setString(26, bean.getOff_fax		().trim());
			pstmt.setInt   (27, bean.getServ_amt	()       );
			pstmt.setString(28, bean.getServ_cont	().trim());
			pstmt.setString(29, bean.getServ_nm		().trim());
			pstmt.setString(30, bean.getUpdate_id	().trim());
			pstmt.setInt   (31, bean.getAmor_req_amt()       );
			pstmt.setString(32, bean.getAmor_req_dt	().trim());
			pstmt.setInt   (33, bean.getAmor_pay_amt()       );
			pstmt.setString(34, bean.getAmor_pay_dt	().trim());
			pstmt.setString(35, bean.getAmor_st		().trim());
			pstmt.setString(36, bean.getAmor_req_id	().trim());
			pstmt.setString(37, bean.getAmor_type	().trim());
			pstmt.setString(38, bean.getCar_mng_id	().trim());
			pstmt.setString(39, bean.getAccid_id	().trim());
			pstmt.setInt   (40, bean.getSeq_no		()       );

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateOtAccid]\n"+se);

				System.out.println("[bean.getOt_car_no	().trim()]\n"+bean.getOt_car_no		().trim());
				System.out.println("[bean.getOt_car_nm	().trim()]\n"+bean.getOt_car_nm		().trim());
				System.out.println("[bean.getOt_driver	().trim()]\n"+bean.getOt_driver		().trim());
				System.out.println("[bean.getOt_tel		().trim()]\n"+bean.getOt_tel		().trim());
				System.out.println("[bean.getOt_m_tel	().trim()]\n"+bean.getOt_m_tel		().trim());
				System.out.println("[bean.getOt_ins		().trim()]\n"+bean.getOt_ins		().trim());
				System.out.println("[bean.getOt_num		().trim()]\n"+bean.getOt_num		().trim());
				System.out.println("[bean.getOt_ins_nm	().trim()]\n"+bean.getOt_ins_nm		().trim());
				System.out.println("[bean.getOt_ins_tel	().trim()]\n"+bean.getOt_ins_tel	().trim());
				System.out.println("[bean.getOt_ins_m_tel().trim()]\n"+bean.getOt_ins_m_tel	().trim());
				System.out.println("[bean.getOt_ssn		().trim()]\n"+bean.getOt_ssn		().trim());
				System.out.println("[bean.getOt_lic_no	().trim()]\n"+bean.getOt_lic_no		().trim());
				System.out.println("[bean.getOt_lic_kd	().trim()]\n"+bean.getOt_lic_kd		().trim());
				System.out.println("[bean.getOt_tel2	().trim()]\n"+bean.getOt_tel2		().trim());
				System.out.println("[bean.getOt_dam_st	().trim()]\n"+bean.getOt_dam_st		().trim());
				System.out.println("[bean.getOt_fault_per()       ]\n"+bean.getOt_fault_per	()       );
				System.out.println("[bean.getHum_nm		().trim()]\n"+bean.getHum_nm		().trim());
				System.out.println("[bean.getHum_tel	().trim()]\n"+bean.getHum_tel		().trim());
				System.out.println("[bean.getHum_m_tel	().trim()]\n"+bean.getHum_m_tel		().trim());
				System.out.println("[bean.getMat_nm		().trim()]\n"+bean.getMat_nm		().trim());
				System.out.println("[bean.getMat_tel	().trim()]\n"+bean.getMat_tel		().trim());
				System.out.println("[bean.getMat_m_tel	().trim()]\n"+bean.getMat_m_tel		().trim());
				System.out.println("[bean.getServ_dt	().trim()]\n"+bean.getServ_dt		().trim());
				System.out.println("[bean.getOff_nm		().trim()]\n"+bean.getOff_nm		().trim());
				System.out.println("[bean.getOff_tel	().trim()]\n"+bean.getOff_tel		().trim());
				System.out.println("[bean.getOff_fax	().trim()]\n"+bean.getOff_fax		().trim());
				System.out.println("[bean.getServ_amt	()       ]\n"+bean.getServ_amt		()       );
				System.out.println("[bean.getServ_cont	().trim()]\n"+bean.getServ_cont		().trim());
				System.out.println("[bean.getServ_nm	().trim()]\n"+bean.getServ_nm		().trim());
				System.out.println("[bean.getUpdate_id	().trim()]\n"+bean.getUpdate_id		().trim());
				System.out.println("[bean.getAmor_req_amt()       ]\n"+bean.getAmor_req_amt	()       );
				System.out.println("[bean.getAmor_req_dt().trim()]\n"+bean.getAmor_req_dt	().trim());
				System.out.println("[bean.getAmor_pay_amt()       ]\n"+bean.getAmor_pay_amt	()       );
				System.out.println("[bean.getAmor_pay_dt().trim()]\n"+bean.getAmor_pay_dt	().trim());
				System.out.println("[bean.getAmor_st	().trim()]\n"+bean.getAmor_st		().trim());
				System.out.println("[bean.getAmor_req_id().trim()]\n"+bean.getAmor_req_id	().trim());
				System.out.println("[bean.getCar_mng_id	().trim()]\n"+bean.getCar_mng_id	().trim());
				System.out.println("[bean.getAccid_id	().trim()]\n"+bean.getAccid_id		().trim());
				System.out.println("[bean.getSeq_no		()       ]\n"+bean.getSeq_no		()       );

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }



	// 사고조회 -------------------------------------------------------------------------------------------------
	
    /**
     * 사고기록 개별조회 : car_accid_all_u.jsp
     */
    public AccidentBean getAccidentBean(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        AccidentBean bean = new AccidentBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from accident where car_mng_id=? and accid_id=?";

        try{
           
			pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		rs = pstmt.executeQuery();
            if (rs.next()){
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					//자동차관리번호
				bean.setAccid_id(rs.getString("ACCID_ID"));
				bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd(rs.getString("RENT_L_CD"));
				bean.setAccid_st(rs.getString("ACCID_ST"));
				bean.setOur_car_nm(rs.getString("OUR_CAR_NM"));
				bean.setOur_driver(rs.getString("OUR_DRIVER"));
				bean.setOur_tel(rs.getString("OUR_TEL"));
				bean.setOur_m_tel(rs.getString("OUR_M_TEL"));
				bean.setOur_ssn(rs.getString("OUR_SSN"));
				bean.setOur_lic_kd(rs.getString("OUR_LIC_KD"));
				bean.setOur_lic_no(rs.getString("OUR_LIC_NO"));
				bean.setOur_ins(rs.getString("OUR_INS"));
				bean.setOur_num(rs.getString("OUR_NUM"));
				bean.setOur_post(rs.getString("OUR_POST"));
				bean.setOur_addr(rs.getString("OUR_ADDR"));
				bean.setAccid_dt(rs.getString("ACCID_DT"));
				bean.setAccid_city(rs.getString("ACCID_CITY"));
				bean.setAccid_gu(rs.getString("ACCID_GU"));
				bean.setAccid_dong(rs.getString("ACCID_DONG"));
				bean.setAccid_point(rs.getString("ACCID_POINT"));
				bean.setAccid_cont(rs.getString("ACCID_CONT"));
				bean.setOt_car_no(rs.getString("OT_CAR_NO"));
				bean.setOt_car_nm(rs.getString("OT_CAR_NM"));
				bean.setOt_driver(rs.getString("OT_DRIVER"));
				bean.setOt_tel(rs.getString("OT_TEL"));
				bean.setOt_m_tel(rs.getString("OT_M_TEL"));
				bean.setOt_ins(rs.getString("OT_INS"));
				bean.setOt_num(rs.getString("OT_NUM"));
				bean.setOt_ins_nm(rs.getString("OT_INS_NM"));
				bean.setOt_ins_tel(rs.getString("OT_INS_TEL"));
				bean.setOt_ins_m_tel(rs.getString("OT_INS_M_TEL"));
				bean.setOt_pol_sta(rs.getString("OT_POL_STA"));
				bean.setOt_pol_nm(rs.getString("OT_POL_NM"));
				bean.setOt_pol_tel(rs.getString("OT_POL_TEL"));
				bean.setOt_pol_m_tel(rs.getString("OT_POL_M_TEL"));
				bean.setHum_amt(rs.getInt("HUM_AMT"));
				bean.setHum_nm(rs.getString("HUM_NM"));
				bean.setHum_tel(rs.getString("HUM_TEL"));
				bean.setMat_amt(rs.getInt("MAT_AMT"));
				bean.setMat_nm(rs.getString("MAT_NM"));
				bean.setMat_tel(rs.getString("MAT_TEL"));
				bean.setOne_amt(rs.getInt("ONE_AMT"));
				bean.setOne_nm(rs.getString("ONE_NM"));
				bean.setOne_tel(rs.getString("ONE_TEL"));
				bean.setMy_amt(rs.getInt("MY_AMT"));
				bean.setMy_nm(rs.getString("MY_NM"));
				bean.setMy_tel(rs.getString("MY_TEL"));
				bean.setRef_dt(rs.getString("REF_DT"));
				bean.setEx_tot_amt(rs.getInt("EX_TOT_AMT"));
				bean.setTot_amt(rs.getInt("TOT_AMT"));
				bean.setRec_amt(rs.getInt("REC_AMT"));
				bean.setRec_dt(rs.getString("REC_DT"));
				bean.setRec_plan_dt(rs.getString("REC_PLAN_DT"));
				bean.setSup_amt(rs.getInt("SUP_AMT"));
				bean.setSup_dt(rs.getString("SUP_DT"));
				bean.setIns_sup_amt(rs.getInt("INS_SUP_AMT"));
				bean.setIns_sup_dt(rs.getString("INS_SUP_DT"));
				bean.setIns_tot_amt(rs.getInt("INS_TOT_AMT"));
				bean.setSub_rent_gu(rs.getString("SUB_RENT_GU"));
				bean.setSub_firm_nm(rs.getString("SUB_FIRM_NM"));
				bean.setSub_rent_st(rs.getString("SUB_RENT_ST"));
				bean.setSub_rent_et(rs.getString("SUB_RENT_ET"));
				bean.setSub_etc(rs.getString("SUB_ETC"));
				bean.setReg_dt(rs.getString("REG_DT"));
				bean.setReg_id(rs.getString("REG_ID"));
				bean.setUpdate_dt(rs.getString("UPDATE_DT"));
				bean.setUpdate_id(rs.getString("UPDATE_ID"));
				bean.setOur_lic_dt(rs.getString("OUR_LIC_DT"));
				bean.setOur_tel2(rs.getString("OUR_TEL2"));
				bean.setOt_ssn(rs.getString("OT_SSN"));
				bean.setOt_lic_kd(rs.getString("OT_LIC_KD"));
				bean.setOt_lic_no(rs.getString("OT_LIC_NO"));
				bean.setOt_tel2(rs.getString("OT_TEL2"));
				bean.setOur_dam_st(rs.getString("OUR_DAM_ST"));
				bean.setOt_dam_st(rs.getString("OT_DAM_ST"));
				bean.setAccid_addr(rs.getString("ACCID_ADDR"));
				bean.setAccid_cont2(rs.getString("ACCID_CONT2"));
				bean.setImp_fault_st(rs.getString("IMP_FAULT_ST"));
				bean.setImp_fault_sub(rs.getString("IMP_FAULT_SUB"));
				bean.setOur_fault_per(rs.getInt("OUR_FAULT_PER"));
				bean.setOt_pol_st(rs.getString("OT_POL_ST"));
				bean.setOt_pol_num(rs.getString("OT_POL_NUM"));
				bean.setOt_pol_fax(rs.getString("OT_POL_FAX"));
				bean.setR_site(rs.getString("R_SITE"));
				bean.setMemo(rs.getString("MEMO"));
				bean.setCar_in_dt(rs.getString("CAR_IN_DT"));
				bean.setCar_out_dt(rs.getString("CAR_OUT_DT"));
				bean.setIns_end_dt(rs.getString("INS_END_DT"));
				bean.setRent_s_cd(rs.getString("RENT_S_CD"));
				bean.setAccid_type(rs.getString("ACCID_TYPE"));
				bean.setAccid_type_sub(rs.getString("ACCID_TYPE_SUB"));
				bean.setSpeed(rs.getString("SPEED"));
				bean.setRoad_stat(rs.getString("ROAD_STAT"));
				bean.setRoad_stat2(rs.getString("ROAD_STAT2"));
				bean.setWeather(rs.getString("WEATHER"));
				bean.setHum_end_dt(rs.getString("HUM_END_DT"));
				bean.setMat_end_dt(rs.getString("MAT_END_DT"));
				bean.setOne_end_dt(rs.getString("ONE_END_DT"));
				bean.setMy_end_dt(rs.getString("MY_END_DT"));
				bean.setSettle_st(rs.getString("SETTLE_ST"));
				bean.setSettle_dt(rs.getString("SETTLE_DT"));
				bean.setSettle_id(rs.getString("SETTLE_ID"));
				bean.setSettle_cont(rs.getString("SETTLE_CONT"));
				bean.setSettle_note(rs.getString("SETTLE_NOTE"));
				bean.setSettle_st1(rs.getString("SETTLE_ST1"));
				bean.setSettle_dt1(rs.getString("SETTLE_DT1"));
				bean.setSettle_id1(rs.getString("SETTLE_ID1"));
				bean.setSettle_st2(rs.getString("SETTLE_ST2"));
				bean.setSettle_dt2(rs.getString("SETTLE_DT2"));
				bean.setSettle_id2(rs.getString("SETTLE_ID2"));
				bean.setSettle_st3(rs.getString("SETTLE_ST3"));
				bean.setSettle_dt3(rs.getString("SETTLE_DT3"));
				bean.setSettle_id3(rs.getString("SETTLE_ID3"));
				bean.setSettle_st4(rs.getString("SETTLE_ST4"));
				bean.setSettle_dt4(rs.getString("SETTLE_DT4"));
				bean.setSettle_id4(rs.getString("SETTLE_ID4"));
				bean.setSettle_st5(rs.getString("SETTLE_ST5"));
				bean.setSettle_dt5(rs.getString("SETTLE_DT5"));
				bean.setSettle_id5(rs.getString("SETTLE_ID5"));
				bean.setDam_type1(rs.getString("DAM_TYPE1"));
				bean.setDam_type2(rs.getString("DAM_TYPE2"));
				bean.setDam_type3(rs.getString("DAM_TYPE3"));
				bean.setDam_type4(rs.getString("DAM_TYPE4"));

//				bean.setAmor_amt	(rs.getInt   ("AMOR_AMT"));
//				bean.setAmor_nm		(rs.getString("AMOR_NM"));
//				bean.setAmor_tel	(rs.getString("AMOR_TEL"));
//				bean.setAmor_end_dt	(rs.getString("AMOR_END_DT"));

				bean.setAcc_dt(rs.getString("ACC_DT"));
				bean.setAcc_id(rs.getString("ACC_ID"));
				bean.setReg_ip(rs.getString("REG_IP"));

				bean.setPre_doc(rs.getString("PRE_DOC"));
				bean.setPre_cls(rs.getString("PRE_CLS"));
				
				bean.setAsset_st(rs.getString("ASSET_ST"));
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getAccidentBean]\n"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
	
	
    /**
     * 인적사고 조회
     */
    public OneAccidBean [] getOneAccid(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from one_accid where car_mng_id=? and accid_id=?";

        Collection<OneAccidBean> col = new ArrayList<OneAccidBean>();

		try{

            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());    		
    		rs = pstmt.executeQuery();

            while(rs.next()){                
	            OneAccidBean bean = new OneAccidBean();
				bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					
				bean.setAccid_id(rs.getString("ACCID_ID"));
				bean.setSeq_no(rs.getInt("SEQ_NO"));
				bean.setNm(rs.getString("NM"));
				bean.setSex(rs.getString("SEX"));
				bean.setHosp(rs.getString("HOSP"));
				bean.setHosp_tel(rs.getString("HOSP_TEL"));
				bean.setIns_nm(rs.getString("INS_NM"));
				bean.setIns_tel(rs.getString("INS_TEL"));
				bean.setTel(rs.getString("TEL"));
				bean.setAge(rs.getString("AGE"));
				bean.setRelation(rs.getString("RELATION"));
				bean.setDiagnosis(rs.getString("DIAGNOSIS"));
				bean.setEtc(rs.getString("ETC"));							
				bean.setOne_accid_st(rs.getString("ONE_ACCID_ST"));							
				bean.setWound_st(rs.getString("WOUND_ST"));							

				col.add(bean); 
            }

            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getOneAccid]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (OneAccidBean[])col.toArray(new OneAccidBean[0]);
    }

    /**
     * 인적사고 조회
     */
    public OneAccidBean [] getOneAccid(String car_mng_id, String accid_id, String one_accid_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from one_accid where car_mng_id=? and accid_id=? and one_accid_st=?";

        Collection<OneAccidBean> col = new ArrayList<OneAccidBean>();

		try{

            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());    		
    		pstmt.setString(3, one_accid_st.trim());    		
    		rs = pstmt.executeQuery();

            while(rs.next()){                
	            OneAccidBean bean = new OneAccidBean();
				bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					
				bean.setAccid_id(rs.getString("ACCID_ID"));
				bean.setSeq_no(rs.getInt("SEQ_NO"));
				bean.setNm(rs.getString("NM"));
				bean.setSex(rs.getString("SEX"));
				bean.setHosp(rs.getString("HOSP"));
				bean.setHosp_tel(rs.getString("HOSP_TEL"));
				bean.setIns_nm(rs.getString("INS_NM"));
				bean.setIns_tel(rs.getString("INS_TEL"));
				bean.setTel(rs.getString("TEL"));
				bean.setAge(rs.getString("AGE"));
				bean.setRelation(rs.getString("RELATION"));
				bean.setDiagnosis(rs.getString("DIAGNOSIS"));
				bean.setEtc(rs.getString("ETC"));							
				bean.setOne_accid_st(rs.getString("ONE_ACCID_ST"));							
				bean.setWound_st(rs.getString("WOUND_ST"));							

				col.add(bean); 
            }

            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getOneAccid]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (OneAccidBean[])col.toArray(new OneAccidBean[0]);
    }


    /**
     * 상대차량 인적사항 조회
     */
    public OtAccidBean [] getOtAccid(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from ot_accid where car_mng_id=? and accid_id=?";

        Collection col = new ArrayList<OtAccidBean>();

		try{

            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());    		
    		rs = pstmt.executeQuery();

            while(rs.next()){                
	            OtAccidBean bean = new OtAccidBean();
				bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					
				bean.setAccid_id(rs.getString("ACCID_ID"));
				bean.setSeq_no(rs.getInt("SEQ_NO"));
				bean.setOt_car_no(rs.getString("OT_CAR_NO"));
				bean.setOt_car_nm(rs.getString("OT_CAR_NM"));
				bean.setOt_driver(rs.getString("OT_DRIVER"));
				bean.setOt_tel(rs.getString("OT_TEL"));
				bean.setOt_m_tel(rs.getString("OT_M_TEL"));
				bean.setOt_ins(rs.getString("OT_INS"));
				bean.setOt_num(rs.getString("OT_NUM"));
				bean.setOt_ins_nm(rs.getString("OT_INS_NM"));
				bean.setOt_ins_tel(rs.getString("OT_INS_TEL"));
				bean.setOt_ins_m_tel(rs.getString("OT_INS_M_TEL"));
				bean.setOt_ssn(rs.getString("OT_SSN"));
				bean.setOt_lic_kd(rs.getString("OT_LIC_KD"));
				bean.setOt_lic_no(rs.getString("OT_LIC_NO"));
				bean.setOt_tel2(rs.getString("OT_TEL2"));
				bean.setOt_dam_st(rs.getString("OT_DAM_ST"));
				bean.setOt_fault_per(rs.getInt("OT_FAULT_PER"));
				bean.setHum_nm(rs.getString("HUM_NM"));
				bean.setHum_tel(rs.getString("HUM_TEL"));
				bean.setHum_m_tel(rs.getString("HUM_M_TEL"));
				bean.setMat_nm(rs.getString("MAT_NM"));
				bean.setMat_tel(rs.getString("MAT_TEL"));
				bean.setMat_m_tel(rs.getString("MAT_M_TEL"));
				bean.setServ_dt(rs.getString("SERV_DT"));
				bean.setOff_nm(rs.getString("OFF_NM"));
				bean.setOff_tel(rs.getString("OFF_TEL"));
				bean.setOff_fax(rs.getString("OFF_FAX"));
				bean.setServ_amt(rs.getInt("SERV_AMT"));
				bean.setServ_cont(rs.getString("SERV_CONT"));
				bean.setServ_nm(rs.getString("SERV_NM"));
				bean.setReg_dt(rs.getString("REG_DT"));
				bean.setReg_id(rs.getString("REG_ID"));
				bean.setUpdate_dt(rs.getString("UPDATE_DT"));
				bean.setUpdate_id(rs.getString("UPDATE_ID"));
				bean.setAmor_req_amt	(rs.getInt   ("AMOR_REQ_AMT"));
				bean.setAmor_req_dt		(rs.getString("AMOR_REQ_DT"));
				bean.setAmor_pay_amt	(rs.getInt   ("AMOR_PAY_AMT"));
				bean.setAmor_pay_dt		(rs.getString("AMOR_PAY_DT"));
				bean.setAmor_st			(rs.getString("AMOR_ST"));
				bean.setAmor_req_id		(rs.getString("AMOR_REQ_ID"));
				bean.setAmor_type		(rs.getString("AMOR_TYPE"));


				col.add(bean); 
            }

            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getOtAccid]\n"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (OtAccidBean[])col.toArray(new OtAccidBean[0]);
    }

    /**
     * 상대차량 인적사항 조회
     */
    public OtAccidBean [] getOtAccid(String car_mng_id, String accid_id, String serv_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from ot_accid where car_mng_id=? and accid_id=? and serv_dt is not null";

        Collection<OtAccidBean> col = new ArrayList<OtAccidBean>();

		try{

            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());    		
    		rs = pstmt.executeQuery();

            while(rs.next()){                
	            OtAccidBean bean = new OtAccidBean();
				bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					
				bean.setAccid_id(rs.getString("ACCID_ID"));
				bean.setSeq_no(rs.getInt("SEQ_NO"));
				bean.setOt_car_no(rs.getString("OT_CAR_NO"));
				bean.setOt_car_nm(rs.getString("OT_CAR_NM"));
				bean.setOt_driver(rs.getString("OT_DRIVER"));
				bean.setOt_tel(rs.getString("OT_TEL"));
				bean.setOt_m_tel(rs.getString("OT_M_TEL"));
				bean.setOt_ins(rs.getString("OT_INS"));
				bean.setOt_num(rs.getString("OT_NUM"));
				bean.setOt_ins_nm(rs.getString("OT_INS_NM"));
				bean.setOt_ins_tel(rs.getString("OT_INS_TEL"));
				bean.setOt_ins_m_tel(rs.getString("OT_INS_M_TEL"));
				bean.setOt_ssn(rs.getString("OT_SSN"));
				bean.setOt_lic_kd(rs.getString("OT_LIC_KD"));
				bean.setOt_lic_no(rs.getString("OT_LIC_NO"));
				bean.setOt_tel2(rs.getString("OT_TEL2"));
				bean.setOt_dam_st(rs.getString("OT_DAM_ST"));
				bean.setOt_fault_per(rs.getInt("OT_FAULT_PER"));
				bean.setHum_nm(rs.getString("HUM_NM"));
				bean.setHum_tel(rs.getString("HUM_TEL"));
				bean.setHum_m_tel(rs.getString("HUM_M_TEL"));
				bean.setMat_nm(rs.getString("MAT_NM"));
				bean.setMat_tel(rs.getString("MAT_TEL"));
				bean.setMat_m_tel(rs.getString("MAT_M_TEL"));
				bean.setServ_dt(rs.getString("SERV_DT"));
				bean.setOff_nm(rs.getString("OFF_NM"));
				bean.setOff_tel(rs.getString("OFF_TEL"));
				bean.setOff_fax(rs.getString("OFF_FAX"));
				bean.setServ_amt(rs.getInt("SERV_AMT"));
				bean.setServ_cont(rs.getString("SERV_CONT"));
				bean.setServ_nm(rs.getString("SERV_NM"));
				bean.setReg_dt(rs.getString("REG_DT"));
				bean.setReg_id(rs.getString("REG_ID"));
				bean.setUpdate_dt(rs.getString("UPDATE_DT"));
				bean.setUpdate_id(rs.getString("UPDATE_ID"));
				bean.setAmor_req_amt	(rs.getInt   ("AMOR_REQ_AMT"));
				bean.setAmor_req_dt		(rs.getString("AMOR_REQ_DT"));
				bean.setAmor_pay_amt	(rs.getInt   ("AMOR_PAY_AMT"));
				bean.setAmor_pay_dt		(rs.getString("AMOR_PAY_DT"));
				bean.setAmor_st			(rs.getString("AMOR_ST"));
				bean.setAmor_req_id		(rs.getString("AMOR_REQ_ID"));
				bean.setAmor_type		(rs.getString("AMOR_TYPE"));

				col.add(bean); 
            }

            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getOtAccid]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (OtAccidBean[])col.toArray(new OtAccidBean[0]);
    }

    /**
     * 사고기록 개별조회 : car_accid_all_u.jsp
     */
    public OtAccidBean getOtAccidBean(String car_mng_id, String accid_id, String seq_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        OtAccidBean bean = new OtAccidBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from ot_accid where car_mng_id=? and accid_id=? and seq_no=?";
        
        try{

			pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		pstmt.setString(3, seq_no);
    		rs = pstmt.executeQuery();

            if (rs.next()){
				bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					
				bean.setAccid_id(rs.getString("ACCID_ID"));
				bean.setSeq_no(rs.getInt("SEQ_NO"));
				bean.setOt_car_no(rs.getString("OT_CAR_NO"));
				bean.setOt_car_nm(rs.getString("OT_CAR_NM"));
				bean.setOt_driver(rs.getString("OT_DRIVER"));
				bean.setOt_tel(rs.getString("OT_TEL"));
				bean.setOt_m_tel(rs.getString("OT_M_TEL"));
				bean.setOt_ins(rs.getString("OT_INS"));
				bean.setOt_num(rs.getString("OT_NUM"));
				bean.setOt_ins_nm(rs.getString("OT_INS_NM"));
				bean.setOt_ins_tel(rs.getString("OT_INS_TEL"));
				bean.setOt_ins_m_tel(rs.getString("OT_INS_M_TEL"));
				bean.setOt_ssn(rs.getString("OT_SSN"));
				bean.setOt_lic_kd(rs.getString("OT_LIC_KD"));
				bean.setOt_lic_no(rs.getString("OT_LIC_NO"));
				bean.setOt_tel2(rs.getString("OT_TEL2"));
				bean.setOt_dam_st(rs.getString("OT_DAM_ST"));
				bean.setOt_fault_per(rs.getInt("OT_FAULT_PER"));
				bean.setHum_nm(rs.getString("HUM_NM"));
				bean.setHum_tel(rs.getString("HUM_TEL"));
				bean.setHum_m_tel(rs.getString("HUM_M_TEL"));
				bean.setMat_nm(rs.getString("MAT_NM"));
				bean.setMat_tel(rs.getString("MAT_TEL"));
				bean.setMat_m_tel(rs.getString("MAT_M_TEL"));
				bean.setServ_dt(rs.getString("SERV_DT"));
				bean.setOff_nm(rs.getString("OFF_NM"));
				bean.setOff_tel(rs.getString("OFF_TEL"));
				bean.setOff_fax(rs.getString("OFF_FAX"));
				bean.setServ_amt(rs.getInt("SERV_AMT"));
				bean.setServ_cont(rs.getString("SERV_CONT"));
				bean.setServ_nm(rs.getString("SERV_NM"));
				bean.setReg_dt(rs.getString("REG_DT"));
				bean.setReg_id(rs.getString("REG_ID"));
				bean.setUpdate_dt(rs.getString("UPDATE_DT"));
				bean.setUpdate_id(rs.getString("UPDATE_ID"));
				bean.setAmor_req_amt	(rs.getInt   ("AMOR_REQ_AMT"));
				bean.setAmor_req_dt		(rs.getString("AMOR_REQ_DT"));
				bean.setAmor_pay_amt	(rs.getInt   ("AMOR_PAY_AMT"));
				bean.setAmor_pay_dt		(rs.getString("AMOR_PAY_DT"));
				bean.setAmor_st			(rs.getString("AMOR_ST"));
				bean.setAmor_type		(rs.getString("AMOR_TYPE"));
				bean.setAmor_req_id		(rs.getString("AMOR_REQ_ID"));
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getOtAccidBean]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    
    /**
     * 보험청구내역 (휴차료/대차료) : car_accid_all_u.jsp
     */
    public MyAccidBean getMyAccid(String car_mng_id, String accid_id, int seq_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        MyAccidBean bean = new MyAccidBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        //
        
        query = " select * from my_accid where car_mng_id=? and accid_id=? and seq_no=?";
        
        try{

            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		pstmt.setInt   (3, seq_no);
    		rs = pstmt.executeQuery();

            if (rs.next()){
			    bean.setCar_mng_id	(rs.getString("CAR_MNG_ID")); 					
				bean.setAccid_id	(rs.getString("ACCID_ID"));
				bean.setSeq_no		(rs.getInt   ("SEQ_NO"));
				bean.setIns_req_gu	(rs.getString("REQ_GU"));
				bean.setIns_req_st	(rs.getString("REQ_ST"));
				bean.setIns_car_nm	(rs.getString("CAR_NM"));
				bean.setIns_car_no	(rs.getString("CAR_NO"));
				bean.setIns_day_amt	(rs.getInt   ("DAY_AMT"));
				bean.setIns_use_st	(rs.getString("USE_ST"));
				bean.setIns_use_et	(rs.getString("USE_ET"));
				bean.setIns_use_day	(rs.getString("USE_DAY"));		
				bean.setIns_nm		(rs.getString("INS_NM"));
				bean.setIns_tel		(rs.getString("INS_TEL"));
				bean.setIns_tel2	(rs.getString("INS_TEL2"));
				bean.setIns_fax		(rs.getString("INS_FAX"));
				bean.setIns_addr	(rs.getString("INS_ADDR"));
				bean.setIns_com		(rs.getString("INS_COM"));
				bean.setIns_req_amt	(rs.getInt   ("REQ_AMT"));
				bean.setIns_req_dt	(rs.getString("REQ_DT"));
				bean.setIns_pay_amt	(rs.getInt   ("PAY_AMT"));
				bean.setIns_pay_dt	(rs.getString("PAY_DT"));
				bean.setRe_reason	(rs.getString("RE_REASON"));
				bean.setVat_yn		(rs.getString("VAT_YN"));
				bean.setMc_s_amt	(rs.getInt   ("MC_S_AMT"));
				bean.setMc_v_amt	(rs.getInt   ("MC_V_AMT"));
				bean.setIns_num		(rs.getString("INS_NUM"));
				bean.setOt_fault_per(rs.getInt   ("OT_FAULT_PER"));
				bean.setPay_gu		(rs.getString("PAY_GU"));
				bean.setBus_id2		(rs.getString("BUS_ID2"));
				bean.setReg_dt		(rs.getString("REG_DT"));
				bean.setReg_id		(rs.getString("REG_ID"));
				bean.setUpdate_dt	(rs.getString("UPDATE_DT"));
				bean.setUpdate_id	(rs.getString("UPDATE_ID"));
				bean.setIns_com_id	(rs.getString("INS_COM_ID")==null?"":rs.getString("INS_COM_ID"));
				bean.setIns_etc		(rs.getString("INS_ETC")==null?"":rs.getString("INS_ETC"));
				bean.setUse_hour	(rs.getString("USE_HOUR")==null?"":rs.getString("USE_HOUR"));
				bean.setDoc_req_dt	(rs.getString("doc_req_dt")==null?"":rs.getString("doc_req_dt"));
				bean.setDoc_reg_dt	(rs.getString("doc_reg_dt")==null?"":rs.getString("doc_reg_dt"));
				bean.setIns_zip		(rs.getString("INS_ZIP")==null?"":rs.getString("INS_ZIP"));
				bean.setApp_docs	(rs.getString("APP_DOCS")==null?"":rs.getString("APP_DOCS"));

			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getMyAccid]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 보험청구내역 (휴차료/대차료) : car_accid_all_u.jsp
     */
    public MyAccidBean getMyAccid(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        MyAccidBean bean = new MyAccidBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from my_accid where car_mng_id=? and accid_id=?";
        
        try{

            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		rs = pstmt.executeQuery();

            if (rs.next()){
			    bean.setCar_mng_id	(rs.getString("CAR_MNG_ID")); 					
				bean.setAccid_id	(rs.getString("ACCID_ID"));
				bean.setSeq_no		(rs.getInt   ("SEQ_NO"));
				bean.setIns_req_gu	(rs.getString("REQ_GU"));
				bean.setIns_req_st	(rs.getString("REQ_ST"));
				bean.setIns_car_nm	(rs.getString("CAR_NM"));
				bean.setIns_car_no	(rs.getString("CAR_NO"));
				bean.setIns_day_amt	(rs.getInt   ("DAY_AMT"));
				bean.setIns_use_st	(rs.getString("USE_ST"));
				bean.setIns_use_et	(rs.getString("USE_ET"));
				bean.setIns_use_day	(rs.getString("USE_DAY"));		
				bean.setIns_nm		(rs.getString("INS_NM"));
				bean.setIns_tel		(rs.getString("INS_TEL"));
				bean.setIns_tel2	(rs.getString("INS_TEL2"));
				bean.setIns_fax		(rs.getString("INS_FAX"));
				bean.setIns_addr	(rs.getString("INS_ADDR"));
				bean.setIns_com		(rs.getString("INS_COM"));
				bean.setIns_req_amt	(rs.getInt   ("REQ_AMT"));
				bean.setIns_req_dt	(rs.getString("REQ_DT"));
				bean.setIns_pay_amt	(rs.getInt   ("PAY_AMT"));
				bean.setIns_pay_dt	(rs.getString("PAY_DT"));
				bean.setRe_reason	(rs.getString("RE_REASON"));
				bean.setVat_yn		(rs.getString("VAT_YN"));
				bean.setMc_s_amt	(rs.getInt   ("MC_S_AMT"));
				bean.setMc_v_amt	(rs.getInt   ("MC_V_AMT"));
				bean.setIns_num		(rs.getString("INS_NUM"));
				bean.setOt_fault_per(rs.getInt   ("OT_FAULT_PER"));
				bean.setPay_gu		(rs.getString("PAY_GU"));
				bean.setBus_id2		(rs.getString("BUS_ID2"));
				bean.setReg_dt		(rs.getString("REG_DT"));
				bean.setReg_id		(rs.getString("REG_ID"));
				bean.setUpdate_dt	(rs.getString("UPDATE_DT"));
				bean.setUpdate_id	(rs.getString("UPDATE_ID"));
				bean.setIns_com_id	(rs.getString("INS_COM_ID")==null?"":rs.getString("INS_COM_ID"));
				bean.setIns_etc		(rs.getString("INS_ETC")==null?"":rs.getString("INS_ETC"));
				bean.setUse_hour	(rs.getString("USE_HOUR")==null?"":rs.getString("USE_HOUR"));
				bean.setDoc_req_dt	(rs.getString("doc_req_dt")==null?"":rs.getString("doc_req_dt"));
				bean.setDoc_reg_dt	(rs.getString("doc_reg_dt")==null?"":rs.getString("doc_reg_dt"));
				bean.setIns_zip		(rs.getString("INS_ZIP")==null?"":rs.getString("INS_ZIP"));
				bean.setApp_docs	(rs.getString("APP_DOCS")==null?"":rs.getString("APP_DOCS"));


			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getMyAccid]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 상대차량 인적사항 조회
     */
    public MyAccidBean [] getMyAccidList(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from my_accid where car_mng_id=? and accid_id=?";

        Collection col = new ArrayList<MyAccidBean>();

		try{

            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());    		
    		rs = pstmt.executeQuery();

            while(rs.next()){                
	            MyAccidBean bean = new MyAccidBean();
			    bean.setCar_mng_id	(rs.getString("CAR_MNG_ID")); 					
				bean.setAccid_id	(rs.getString("ACCID_ID"));
				bean.setSeq_no		(rs.getInt   ("SEQ_NO"));
				bean.setIns_req_gu	(rs.getString("REQ_GU"));
				bean.setIns_req_st	(rs.getString("REQ_ST"));
				bean.setIns_car_nm	(rs.getString("CAR_NM"));
				bean.setIns_car_no	(rs.getString("CAR_NO"));
				bean.setIns_day_amt	(rs.getInt   ("DAY_AMT"));
				bean.setIns_use_st	(rs.getString("USE_ST"));
				bean.setIns_use_et	(rs.getString("USE_ET"));
				bean.setIns_use_day	(rs.getString("USE_DAY"));		
				bean.setIns_nm		(rs.getString("INS_NM"));
				bean.setIns_tel		(rs.getString("INS_TEL"));
				bean.setIns_tel2	(rs.getString("INS_TEL2"));
				bean.setIns_fax		(rs.getString("INS_FAX"));
				bean.setIns_addr	(rs.getString("INS_ADDR"));
				bean.setIns_com		(rs.getString("INS_COM"));
				bean.setIns_req_amt	(rs.getInt   ("REQ_AMT"));
				bean.setIns_req_dt	(rs.getString("REQ_DT"));
				bean.setIns_pay_amt	(rs.getInt   ("PAY_AMT"));
				bean.setIns_pay_dt	(rs.getString("PAY_DT"));
				bean.setRe_reason	(rs.getString("RE_REASON"));
				bean.setVat_yn		(rs.getString("VAT_YN"));
				bean.setMc_s_amt	(rs.getInt   ("MC_S_AMT"));
				bean.setMc_v_amt	(rs.getInt   ("MC_V_AMT"));
				bean.setIns_num		(rs.getString("INS_NUM"));
				bean.setOt_fault_per(rs.getInt   ("OT_FAULT_PER"));
				bean.setPay_gu		(rs.getString("PAY_GU"));
				bean.setBus_id2		(rs.getString("BUS_ID2"));
				bean.setReg_dt		(rs.getString("REG_DT"));
				bean.setReg_id		(rs.getString("REG_ID"));
				bean.setUpdate_dt	(rs.getString("UPDATE_DT"));
				bean.setUpdate_id	(rs.getString("UPDATE_ID"));
				bean.setIns_com_id	(rs.getString("INS_COM_ID")==null?"":rs.getString("INS_COM_ID"));
				bean.setIns_etc		(rs.getString("INS_ETC")==null?"":rs.getString("INS_ETC"));
				bean.setUse_hour	(rs.getString("USE_HOUR")==null?"":rs.getString("USE_HOUR"));
				bean.setDoc_req_dt	(rs.getString("doc_req_dt")==null?"":rs.getString("doc_req_dt"));
				bean.setDoc_reg_dt	(rs.getString("doc_reg_dt")==null?"":rs.getString("doc_reg_dt"));
				bean.setIns_zip		(rs.getString("INS_ZIP")==null?"":rs.getString("INS_ZIP"));
				bean.setApp_docs	(rs.getString("APP_DOCS")==null?"":rs.getString("APP_DOCS"));

				col.add(bean); 
            }

            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getMyAccidList]\n"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (MyAccidBean[])col.toArray(new MyAccidBean[0]);
    }

	/**
     * 차량별 사고 리스트 조회 : car_accid_list.jsp
     */
    public AccidentBean [] getCarAccidList(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
           	String query =	" select /*+  merge(a) */"+
						"        a.rent_mng_id, a.rent_l_cd, a.firm_nm, a.client_nm, c.car_no, b.car_mng_id,"+
						"        b.accid_id, b.accid_st,"+
						"        b.our_driver, b.accid_dt, b.accid_addr, b.accid_cont, b.accid_cont2,"+
						"        b.sub_rent_gu, b.sub_firm_nm"+
						" from   cont_n_view a, accident b, car_reg c "+
						" where  b.car_mng_id='"+car_mng_id+"'"+
						"        and a.car_mng_id = c.car_mng_id and  a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
						" order by b.accid_dt";

		Collection<AccidentBean> col = new ArrayList<AccidentBean>();

        try{

			pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){               
	            AccidentBean bean = new AccidentBean();
				bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd(rs.getString("RENT_L_CD"));
				bean.setFirm_nm(rs.getString("FIRM_NM"));
				bean.setClient_nm(rs.getString("CLIENT_NM"));
				bean.setCar_no(rs.getString("CAR_NO"));
				bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					
				bean.setAccid_id(rs.getString("ACCID_ID"));
				bean.setAccid_st(rs.getString("ACCID_ST"));			
				bean.setOur_driver(rs.getString("OUR_DRIVER"));
				bean.setAccid_dt(rs.getString("ACCID_DT"));
				bean.setAccid_addr(rs.getString("ACCID_ADDR"));
				bean.setAccid_cont(rs.getString("ACCID_CONT"));
				bean.setAccid_cont2(rs.getString("ACCID_CONT2"));			
				bean.setSub_rent_gu(rs.getString("SUB_RENT_GU"));			
				bean.setSub_firm_nm(rs.getString("SUB_FIRM_NM"));			
				col.add(bean); 
            }

            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getCarAccidList]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (AccidentBean[])col.toArray(new AccidentBean[0]);
    }

	/**
     * 차량별 사고 리스트 조회 : car_accid_list.jsp
     */
    public Vector getCarAccidInsList(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

			query = " select /*+  merge(b) */"+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm,  cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,\n"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, \n"+
				"        decode(a.accid_type, '1','차대차','2','차대인','3','차량단독','4','차대열차') accid_type_nm,"+
				"        a.our_ins, nvl(a.hum_amt,0) hum_amt, nvl(a.mat_amt,0) mat_amt, nvl(a.one_amt,0) one_amt, nvl(a.my_amt,0) my_amt,"+
				"        nvl(e.tot_amt,0) tot_amt, nvl(e.cust_amt,0) cust_amt, nvl(f.req_amt,0) req_amt, a.settle_st \n"+
				" from   accident a, cont_n_view b, my_accid f, car_reg c,  car_etc g, car_nm cn , "+
				"        (select car_mng_id, accid_id, sum(tot_amt) tot_amt, sum(cust_amt) cust_amt from service group by car_mng_id, accid_id) e \n"+
				" where  a.car_mng_id='"+car_mng_id+"'"+
				"        and a.car_mng_id = c.car_mng_id and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and a.car_mng_id=f.car_mng_id(+) and a.accid_id=f.accid_id(+)"+
				"        and a.car_mng_id=e.car_mng_id(+) and a.accid_id=e.accid_id(+)"+
				"	and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) \n"+
				" order by a.accid_dt";

        try{

            con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getCarAccidInsList]\n"+se);
			System.out.println("[AccidDatabase:getCarAccidInsList]\n"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


	// 사고기록 -------------------------------------------------------------------------------------------------
	

	//사고기록 리스트
	public Vector getAccidSList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */"+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm,  cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, a.our_num, a.settle_st"+
				" from   accident a, cont_n_view b, insur e, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) f, ins_com g,"+
				"        rent_cont h, cont i, client j, users k,  car_reg c,  car_etc g1, car_nm cn  "+
				" where  a.car_mng_id = c.car_mng_id and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and e.car_mng_id=f.car_mng_id and e.ins_st=f.ins_st and e.ins_com_id=g.ins_com_id and a.car_mng_id=e.car_mng_id"+
				"	and a.rent_mng_id = g1.rent_mng_id(+)  and a.rent_l_cd = g1.rent_l_cd(+)  \n"+
                       		"	and g1.car_id=cn.car_id(+)  and    g1.car_seq=cn.car_seq(+) "+
				"        and a.rent_s_cd=h.rent_s_cd(+) and h.sub_l_cd=i.rent_l_cd(+) and h.cust_id=j.client_id(+) and h.cust_id=k.user_id(+)";
	
		if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!gubun3.equals(""))		query += " and a.accid_st = '"+gubun3+"'";

		if(gubun4.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun4.equals("2"))		query += " and c.car_use='2'";

		if(!brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and b.firm_nm||j.firm_nm like '%"+t_wd+"%'";
			else if(s_kd.equals("2"))	query += " and b.rent_l_cd like '%"+t_wd+"%'";
			else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
			else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";		
			else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
			else if(s_kd.equals("6"))	query += " and a.our_driver like '%"+t_wd+"%'";
			else if(s_kd.equals("7"))	query += " and a.ot_car_no like '%"+t_wd+"%'";
			else if(s_kd.equals("8"))	query += " and a.ot_driver like '%"+t_wd+"%'";
			else if(s_kd.equals("9"))	query += " and g.ins_com_nm like '%"+t_wd+"%'";
			else if(s_kd.equals("10"))	query += " and b.mng_id like '%"+t_wd+"%'";
			else if(s_kd.equals("99"))	query += " and a.car_mng_id = '"+t_wd+"'";
		}

		if(sort.equals("1"))		query += " order by a.accid_dt";
		else if(sort.equals("2"))	query += " order by b.firm_nm";
		else if(sort.equals("3"))	query += " order by c.car_no";
		else if(sort.equals("4"))	query += " order by c.car_nm";
		else if(sort.equals("5"))	query += " order by g.ins_com_nm";
		
		if(asc.equals("0"))			query += " asc";
		else if(asc.equals("1"))	query += " desc";

		try {
        
			
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
             	System.out.println("[AccidDatabase:getAccidSList]="+se);
             	System.out.println("[AccidDatabase:getAccidSList]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트
	public Vector getAccidSList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */  "+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, a.acc_id, "+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독')  accid_st_nm, "+
				"        a.our_num, a.settle_st, "+ 
				"        decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(i.cust_st, '1',j.firm_nm, '4',k.user_nm,l.cust_nm) cust_nm"+
				" from   accident a, cont_n_view b,  insur e, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) f, ins_com g, "+
				"        rent_cont i, client j, users k, rent_cust l,  car_reg c,  car_etc g1, car_nm cn \n"+
				" where  a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and  a.car_mng_id = c.car_mng_id  and e.car_mng_id=f.car_mng_id and e.ins_st=f.ins_st and e.ins_com_id=g.ins_com_id and a.car_mng_id=e.car_mng_id"+
				"	     and a.rent_mng_id = g1.rent_mng_id(+)  and a.rent_l_cd = g1.rent_l_cd(+)  \n"+
                "	     and g1.car_id=cn.car_id(+)  and    g1.car_seq=cn.car_seq(+) "+
				"        and a.car_mng_id=i.car_mng_id(+) and a.rent_s_cd=i.rent_s_cd(+) and i.cust_id=j.client_id(+) and i.cust_id=k.user_id(+) and i.cust_id=l.cust_id(+) \n"+
				" ";
	
		//현재 s_st는 무조건 3
		
		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";

			if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(!gubun3.equals(""))		query += " and nvl(a.settle_st,'0')='"+gubun3+"'";

			if(gubun4.equals("1") && gubun5.equals("2"))		query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물
			else if(gubun4.equals("1") && gubun5.equals("4"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차
			else if(gubun4.equals("1") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type3,'N')='N' and (a.dam_type2 = 'Y' or a.dam_type4 = 'Y')";//물적(대물+자차)
			else if(gubun4.equals("2") && gubun5.equals("1"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대인
			else if(gubun4.equals("2") && gubun5.equals("3"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//자손
			else if(gubun4.equals("2") && gubun5.equals(""))	query += " and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type4,'N')='N' and (a.dam_type1 = 'Y' or a.dam_type3 = 'Y')";//인적(대인+자손)
			else if(gubun4.equals("3") && gubun5.equals("5"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물+대인
			else if(gubun4.equals("3") && gubun5.equals("6"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//대물+자손
			else if(gubun4.equals("3") && gubun5.equals("7"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차+대인
			else if(gubun4.equals("3") && gubun5.equals("8"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='Y'";//자차+자손
			else if(gubun4.equals("3") && gubun5.equals(""))	query += " and ((a.dam_type1 = 'Y' and a.dam_type2 = 'Y') or (a.dam_type2 = 'Y' and a.dam_type3 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type1 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type3 = 'Y'))";//복합
			else if(gubun4.equals("4") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//미등록
			
			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";

		}else{
		
			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";
			
			if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5")){
				if(!st_dt.equals("") && end_dt.equals("")){
					query += " and a.accid_dt like replace('"+st_dt+"%','-','')";
				}else if(!st_dt.equals("") && !end_dt.equals("")){
					query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
				}
			}
			
			if(!gubun3.equals(""))		query += " and nvl(a.settle_st,'0')='"+gubun3+"'";
			
			if(gubun4.equals("1") && gubun5.equals("2"))		query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물
			else if(gubun4.equals("1") && gubun5.equals("4"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차
			else if(gubun4.equals("1") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type3,'N')='N' and (a.dam_type2 = 'Y' or a.dam_type4 = 'Y')";//물적(대물+자차)
			else if(gubun4.equals("2") && gubun5.equals("1"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대인
			else if(gubun4.equals("2") && gubun5.equals("3"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//자손
			else if(gubun4.equals("2") && gubun5.equals(""))	query += " and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type4,'N')='N' and (a.dam_type1 = 'Y' or a.dam_type3 = 'Y')";//인적(대인+자손)
			else if(gubun4.equals("3") && gubun5.equals("5"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물+대인
			else if(gubun4.equals("3") && gubun5.equals("6"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//대물+자손
			else if(gubun4.equals("3") && gubun5.equals("7"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차+대인
			else if(gubun4.equals("3") && gubun5.equals("8"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='Y'";//자차+자손
			else if(gubun4.equals("3") && gubun5.equals(""))	query += " and ((a.dam_type1 = 'Y' and a.dam_type2 = 'Y') or (a.dam_type2 = 'Y' and a.dam_type3 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type1 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type3 = 'Y'))";//복합
			else if(gubun4.equals("4") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//미등록
			
			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";
			
			
			if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and b.firm_nm||j.firm_nm||k.user_nm||decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and  c.car_no||' '||decode(c.first_car_no,c.car_no,'',c.first_car_no) like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and DECODE(i.rent_st,'12',i.mng_id,'',decode(b.car_st,'2',nvl(nvl(a.acc_id,a.reg_id),nvl(b.mng_id,b.bus_id2)),nvl(b.mng_id,b.bus_id2)),i.bus_id) like '%"+t_wd+"%'";
				else if(s_kd.equals("11"))	query += " and DECODE(i.rent_st,'',b.bus_id2,i.bus_id) like '%"+t_wd+"%'";
				else if(s_kd.equals("12"))	query += " and a.accid_id='"+t_wd+"'";
				else if(s_kd.equals("99"))	query += " and a.car_mng_id = '"+t_wd+"'";
			}

		}

		if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by c.car_no "+asc;
		else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
		else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;

	//    System.out.println("query="+ query);
		try {
         
			pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
       			System.out.println("[AccidDatabase:getAccidSList]="+se);
       			System.out.println("[AccidDatabase:getAccidSList]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트
	public Vector getAccidGList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st, String user_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";


			query = " select /*+  merge(b) */ \n"+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn, \n"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, \n"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, a.our_num, a.settle_st, h2.pic_cnt2 as pic_cnt \n"+
				" from   accident a, cont_n_view b,  car_reg c,  car_etc g1, car_nm cn ,  \n"+
				"        insur e, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) f, ins_com g,  \n"+			
				"        (select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) accid_id, count(0) pic_cnt2 from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PIC_ACCID' group by content_seq) h2 "+
				" where  a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.car_mng_id=e.car_mng_id and a.car_mng_id = c.car_mng_id  \n"+
				"	     and e.car_mng_id=f.car_mng_id and e.ins_st=f.ins_st  \n"+
				"	     and e.ins_com_id=g.ins_com_id  \n"+
				"	     and a.rent_mng_id = g1.rent_mng_id(+) and a.rent_l_cd = g1.rent_l_cd(+)  \n"+
                "	     and g1.car_id=cn.car_id(+)  and g1.car_seq=cn.car_seq(+) \n"+
				"        and a.car_mng_id=h2.car_mng_id(+) and a.accid_id=h2.accid_id(+) \n"+
				" ";

		
		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
			else if(s_kd.equals("2"))	query += " and b.firm_nm like '%"+t_wd+"%'";
			else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
			else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
			else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
			else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
			else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
		}

		if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by c.car_no "+asc;
		else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
		else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;

		try {
          

			pstmt = con.prepareStatement(query);
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
//          		System.out.println("[AccidDatabase:getAccidGList]="+query);
		}catch(SQLException se){
          		System.out.println("[AccidDatabase:getAccidGList]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트 현황
	public Hashtable getAccidSListStat(String br_id, String gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
        
		if(gubun.equals("1")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident where accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and accid_st='1') a,"+
					" (select count(0) su2 from accident where accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and accid_st='2') b,"+
					" (select count(0) su3 from accident where accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and accid_st='3') c,"+
					" (select count(0) su4 from accident where accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and accid_st='4') d,"+
					" (select count(0) su5 from accident where accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and accid_st='5') e";
		}else if(gubun.equals("2")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%' and accid_st='1') a,"+
					" (select count(0) su2 from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%' and accid_st='2') b,"+
					" (select count(0) su3 from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%' and accid_st='3') c,"+
					" (select count(0) su4 from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%' and accid_st='4') d,"+
					" (select count(0) su5 from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%' and accid_st='5') e";
		}else{
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident where accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and accid_st='1') a,"+
					" (select count(0) su2 from accident where accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and accid_st='2') b,"+
					" (select count(0) su3 from accident where accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and accid_st='3') c,"+
					" (select count(0) su4 from accident where accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and accid_st='4') d,"+
					" (select count(0) su5 from accident where accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and accid_st='5') e";
		}
	
		try {
           
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
            pstmt.close();
            
		}catch(SQLException se){
         		System.out.println("[AccidDatabase:getAccidSListStat]="+se);
		         throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고기록 리스트 현황
	public Hashtable getAccidSListStat(String br_id, String gubun, String car_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String sub_query = "";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query += " and a.rent_l_cd like '"+br_id+"%'"; 

		if(car_st.equals("1"))	sub_query += " and b.car_use='1'"; 
		if(car_st.equals("2"))	sub_query += " and b.car_use='2'"; 

		if(gubun.equals("1")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, car_reg b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, car_reg b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from accident a, car_reg b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from accident a, car_reg b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id "+sub_query+") d,"+
					" (select count(0) su5 from accident a, car_reg b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id "+sub_query+") e";
		}else if(gubun.equals("2")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, car_reg b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, car_reg b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from accident a, car_reg b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from accident a, car_reg b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id "+sub_query+") d,"+
					" (select count(0) su5 from accident a, car_reg b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id "+sub_query+") e";
		}else{
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, car_reg b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, car_reg b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from accident a, car_reg b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from accident a, car_reg b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id "+sub_query+") d,"+
					" (select count(0) su5 from accident a, car_reg b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id "+sub_query+") e";
		}
	
		try {
        
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
           	System.out.println("[AccidDatabase:getAccidSListStat]="+se);
		    throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }


	//사고기록 리스트
	public Vector getAccidS2List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

				query = " select /*+  merge(b) */"+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				"        decode(e.one_accid_st, '1','자손','2','대인', '대인') one_accid_st_nm,"+
				"        decode(e.wound_st, '1','경상','2','중상','3','사망', '경상') wound_st_nm,"+
				"        e.one_accid_st, e.nm, e.hosp, e.diagnosis, a.settle_st"+
				" from   accident a, cont_n_view b, one_accid e , car_reg c,  car_etc g, car_nm cn "+
				" where  e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				"	and a.car_mng_id = c.car_mng_id and  a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
			
	
		if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";


		if(!gubun3.equals(""))		query += " and a.accid_st = '"+gubun3+"'";

		if(gubun4.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun4.equals("2"))		query += " and c.car_use='2'";


		if(gubun5.equals("1"))		query += " and nvl(e.one_accid_st,'1') = '1'";
		if(gubun5.equals("2"))		query += " and nvl(e.one_accid_st,'1') <> '1'";

		if(!brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 

		if(s_kd.equals("1"))		query += " and b.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and b.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
		else if(s_kd.equals("6"))	query += " and a.our_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("7"))	query += " and a.ot_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	query += " and a.ot_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("9"))	query += " and a.our_ins like '%"+t_wd+"%'";
		else if(s_kd.equals("10"))	query += " and b.mng_id like '%"+t_wd+"%'";

		if(sort.equals("1"))		query += " order by a.accid_dt";
		else if(sort.equals("2"))	query += " order by b.firm_nm";
		else if(sort.equals("3"))	query += " order by c.car_no";
		else if(sort.equals("4"))	query += " order by c.car_nm||cn.car_name";
		else if(sort.equals("5"))	query += " order by a.our_ins";

		if(asc.equals("0"))			query += " asc";
		else if(asc.equals("1"))	query += " desc";

		try {
          

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           		System.out.println("[AccidDatabase:getAccidS2List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트
	public Vector getAccidS2List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */"+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				"        decode(e.one_accid_st, '1','자손','2','대인', '대인') one_accid_st_nm,"+
				"        decode(e.wound_st, '1','경상','2','중상','3','사망', '경상') wound_st_nm,"+
				"        nvl(e.one_accid_st,'1') one_accid_st, e.nm, e.hosp, e.diagnosis, a.settle_st, a.settle_st1, a.settle_st3"+
				" from   accident a, cont_n_view b, one_accid e, car_reg c,  car_etc g, car_nm cn "+
				" where  e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id \n"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"	and a.car_mng_id = c.car_mng_id and  a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
				;
	
		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";

			if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(!gubun3.equals(""))		query += " and decode(nvl(e.one_accid_st,'1'),'1',nvl(a.settle_st3,'0'),nvl(a.settle_st1,'0'))='"+gubun3+"'";

			if(gubun5.equals("1"))		query += " and nvl(e.one_accid_st,'1') = '1'";
			if(gubun5.equals("2"))		query += " and nvl(e.one_accid_st,'1') <> '1'";


			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";

		}else{

			if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and b.firm_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and e.nm like '%"+t_wd+"%'";
			}

		}

		if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by c.car_no "+asc;
		else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
		else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;

		try {
          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           		System.out.println("[AccidDatabase:getAccidS2List]="+se);
		        throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


	//사고기록 리스트 현황
	public Hashtable getAccidSList2Stat(String br_id, String gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";

		if(gubun.equals("1")){
			query = " select su1, su2, (su1+su2) tot_su from"+
					" (select count(0) su1 from accident a, one_accid b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and nvl(b.one_accid_st,'1')='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) a,"+
					" (select count(0) su2 from accident a, one_accid b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and nvl(b.one_accid_st,'1')='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) b";
		}else if(gubun.equals("2")){
			query = " select su1, su2, (su1+su2) tot_su from"+
					" (select count(0) su1 from accident a, one_accid b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and nvl(b.one_accid_st,'1')='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) a,"+
					" (select count(0) su2 from accident a, one_accid b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and nvl(b.one_accid_st,'1')='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) b";
		}else{
			query = " select su1, su2, (su1+su2) tot_su from"+
					" (select count(0) su1 from accident a, one_accid b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and nvl(b.one_accid_st,'1')='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) a,"+
					" (select count(0) su2 from accident a, one_accid b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and nvl(b.one_accid_st,'1')='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) b";
		}
	
		try {
        

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
          		System.out.println("[AccidDatabase:getAccidSList2Stat]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고기록 리스트 현황
	public Hashtable getAccidSList2Stat(String br_id, String gubun, String car_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String sub_query = "";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query += " and rent_l_cd like '"+br_id+"%'"; 
		if(car_st.equals("1"))	sub_query += " and c.car_use='1'"; 
		if(car_st.equals("2"))	sub_query += " and c.car_use='2'";

		if(gubun.equals("1")){
			query = " select su1, su2, (su1+su2) tot_su from"+
					" (select count(0) su1 from accident a, one_accid b, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and nvl(b.one_accid_st,'1')>'1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, one_accid b, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and nvl(b.one_accid_st,'1')='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") b";
		}else if(gubun.equals("2")){
			query = " select su1, su2, (su1+su2) tot_su from"+
					" (select count(0) su1 from accident a, one_accid b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and nvl(b.one_accid_st,'1')>'1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, one_accid b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and nvl(b.one_accid_st,'1')='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") b";
		}else{
			query = " select su1, su2, (su1+su2) tot_su from"+
					" (select count(0) su1 from accident a, one_accid b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and nvl(b.one_accid_st,'1')>'1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, one_accid b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and nvl(b.one_accid_st,'1')='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") b";
		}
	
		try {
           

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
           	System.out.println("[AccidDatabase:getAccidSList2Stat]="+se);
	        throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }


	//사고기록 리스트-물적사고관리(자차)
	public Vector getAccidS3List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

			query = " select /*+  merge(b) */"+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				"        e.serv_dt, e.ipgodt, e.chulgodt, e.tot_amt, e.cust_amt, e.set_dt, e.cust_pay_dt, e.rep_cont, f.off_nm, a.settle_st"+
				" from   accident a, cont_n_view b, service e, serv_off f , car_reg c,  car_etc g, car_nm cn \n"+
				" where  e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and e.off_id=f.off_id \n"+
				"	     and a.car_mng_id = c.car_mng_id and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	     and g.car_id=cn.car_id(+) and g.car_seq=cn.car_seq(+) ";
	
		if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";


		if(!gubun3.equals(""))		query += " and a.accid_st = '"+gubun3+"'";

		if(gubun4.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun4.equals("2"))		query += " and c.car_use='2'";

		if(gubun6.equals("1"))		query += " and e.set_dt is not null";
		if(gubun6.equals("2"))		query += " and e.set_dt is null";
		
		if(!brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 

		if(s_kd.equals("1"))		query += " and b.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and b.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
		else if(s_kd.equals("6"))	query += " and a.our_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("7"))	query += " and a.ot_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	query += " and a.ot_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("9"))	query += " and a.our_ins like '%"+t_wd+"%'";
		else if(s_kd.equals("10"))	query += " and b.mng_id like '%"+t_wd+"%'";

		if(sort.equals("1"))		query += " order by a.accid_dt";
		else if(sort.equals("2"))	query += " order by b.firm_nm";
		else if(sort.equals("3"))	query += " order by c.car_no";
		else if(sort.equals("4"))	query += " order by c.car_nm||cn.car_name";
		else if(sort.equals("5"))	query += " order by a.our_ins";

		if(asc.equals("0"))			query += " asc";
		else if(asc.equals("1"))	query += " desc";


		try {
          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
          
				System.out.println("[AccidDatabase:getAccidS3List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
        return vt;
    }

	//사고기록 리스트-물적사고관리(자차)
	public Vector getAccidS3List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

	query = " select /*+  merge(b) */"+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				"        e.serv_dt, e.ipgodt, e.chulgodt, e.tot_amt, e.cust_amt, e.set_dt, e.cust_pay_dt, e.rep_cont, f.off_nm, a.settle_st"+
				" from   accident a, cont_n_view b, service e, serv_off f,  car_reg c,  car_etc g, car_nm cn "+
				" where  e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and e.off_id=f.off_id \n" +
				"	     and a.car_mng_id = c.car_mng_id and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	     and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
	
		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";

			if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(!gubun3.equals(""))		query += " and nvl(a.settle_st4,'0')='"+gubun3+"'";


			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";

		}else{

			if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and b.firm_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and f.off_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("9"))	query += " and e.serv_dt like '"+t_wd+"%'";
				else if(s_kd.equals("10"))	query += " and e.ipgodt like '%"+t_wd+"%'";
				else if(s_kd.equals("11"))	query += " and e.chulgodt like '%"+t_wd+"%'";
			}

		}

		if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by c.car_no "+asc;
		else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
		else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;
		else if(sort.equals("5"))	query += " order by f.off_nm "+asc;
		else if(sort.equals("6"))	query += " order by e.serv_dt "+asc;
		else if(sort.equals("7"))	query += " order by e.ipgodt "+asc;
		else if(sort.equals("8"))	query += " order by e.chulgodt "+asc;

		try {
        
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
        		System.out.println("[AccidDatabase:getAccidS3List]="+se);
		        throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트-물적사고관리(대물)
	public Vector getAccidS3List2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */"+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, \n"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				" e.serv_dt, '' ipgodt, '' chulgodt, e.serv_amt tot_amt, 0 cust_amt, e.ot_driver set_dt, '' cust_pay_dt, e.serv_cont rep_cont, e.off_nm, a.settle_st"+
				" from accident a, cont_n_view b, ot_accid e, car_reg c,  car_etc g, car_nm cn \n"+
				" where e.serv_dt is not null and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id \n"+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
           		" and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

		if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!gubun3.equals(""))		query += " and a.accid_st = '"+gubun3+"'";

		if(gubun4.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun4.equals("2"))		query += " and c.car_use='2'";
		
		if(!brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 

		if(s_kd.equals("1"))		query += " and b.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and b.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
		else if(s_kd.equals("6"))	query += " and a.our_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("7"))	query += " and a.ot_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	query += " and a.ot_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("9"))	query += " and a.our_ins like '%"+t_wd+"%'";
		else if(s_kd.equals("10"))	query += " and b.mng_id like '%"+t_wd+"%'";

		if(sort.equals("1"))		query += " order by a.accid_dt";
		else if(sort.equals("2"))	query += " order by b.firm_nm";
		else if(sort.equals("3"))	query += " order by c.car_no";
		else if(sort.equals("4"))	query += " order by c.car_nm||cn.car_name";
		else if(sort.equals("5"))	query += " order by a.our_ins";

		if(asc.equals("0"))			query += " asc";
		else if(asc.equals("1"))	query += " desc";

		try {
          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidS3List]="+se);
		        throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트-물적사고관리(대물)
	public Vector getAccidS3List2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */"+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				" e.serv_dt, '' ipgodt, '' chulgodt, e.serv_amt tot_amt, 0 cust_amt, e.ot_driver set_dt, '' cust_pay_dt, e.serv_cont rep_cont, e.off_nm, a.settle_st"+
				" from accident a, cont_n_view b, ot_accid e,  car_reg c,  car_etc g, car_nm cn \n"+
				" where e.serv_dt is not null and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n" +
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
	
		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";

			if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(!gubun3.equals(""))		query += " and nvl(a.settle_st2,'0')='"+gubun3+"'";


			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";

		}else{

			if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and b.firm_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and e.off_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("9"))	query += " and e.serv_dt like '"+t_wd+"%'";
				else if(s_kd.equals("10"))	query += " and e.serv_dt like '"+t_wd+"%'";
				else if(s_kd.equals("11"))	query += " and e.serv_dt like '"+t_wd+"%'";
			}

		}

		if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by c.car_no "+asc;
		else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
		else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;
		else if(sort.equals("5"))	query += " order by e.off_nm "+asc;
		else if(sort.equals("6"))	query += " order by e.serv_dt "+asc;
		else if(sort.equals("7"))	query += " order by e.serv_dt "+asc;
		else if(sort.equals("8"))	query += " order by e.serv_dt "+asc;

		try {
       
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
         
				System.out.println("[AccidDatabase:getAccidS3List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트-물적사고관리(대물)
	public Vector getAccidS3List24(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
        String query1 = "";
        String query2 = "";

		query1 = " select  '4' gubun,"+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_use, c.car_no, c.first_car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, b.brch_id,"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, a.settle_st2, a.settle_st4, a.our_num,"+
				"        e.serv_id, e.serv_dt, substr(e.ipgodt,1,8) ipgodt, substr(e.chulgodt,1,8) chulgodt, e.tot_amt, e.cust_amt, e.set_dt, e.cust_pay_dt, e.rep_cont, f.off_nm, a.settle_st, e.estimate_num, e.scan_file, nvl(h2.pic_cnt,0) pic_cnt, h2.attach_seq, h2.file_type "+
				" from   accident a, cont_n_view b, service e, serv_off f,  car_reg c,  car_etc g, car_nm cn, \n"+
				"        (select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) serv_id, count(0) pic_cnt, max(seq) attach_seq, MAX(file_type) file_type from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='SERVICE' group by content_seq) h2 \n"+
				" where  e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and e.off_id=f.off_id" + 
				"	     and a.car_mng_id = c.car_mng_id and a.rent_mng_id = g.rent_mng_id(+) and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	     and g.car_id=cn.car_id(+) and g.car_seq=cn.car_seq(+) "+
  			    "        and e.car_mng_id=h2.car_mng_id(+) and e.serv_id=h2.serv_id(+)\n";

		query2 = " select  '2' gubun,"+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_use, c.car_no, c.first_car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, b.brch_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, a.settle_st2, a.settle_st4, a.our_num,"+
				" '' serv_id, e.serv_dt, '' ipgodt, '' chulgodt, e.serv_amt tot_amt, 0 cust_amt, e.ot_driver set_dt, '' cust_pay_dt, e.serv_cont rep_cont, e.off_nm, a.settle_st, '' estimate_num, '' scan_file, 0 pic_cnt, 0 attach_seq, '' file_type "+
				" from accident a, cont_n_view b, ot_accid e , car_reg c,  car_etc g, car_nm cn \n"+
				" where e.serv_dt is not null and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

	
		query = " select * from ( \n"+query1+"\n union all \n"+query2+"\n ) where car_mng_id is not null ";		


		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and car_use='1'"; 
			if(gubun1.equals("2"))		query += " and car_use='2'";

			if(gubun2.equals("1"))		query += " and accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and accid_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and accid_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(!gubun3.equals(""))		query += " and decode(gubun,'2',nvl(settle_st2,'0'),nvl(settle_st4,'0'))='"+gubun3+"'";


			if(!gubun6.equals(""))		query += " and accid_st = '"+gubun6+"'";

		}else{

			if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and firm_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and car_no||' '||first_car_no like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and car_nm||car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and reg_id like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and off_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("9"))	query += " and serv_dt like '"+t_wd+"%'";
				else if(s_kd.equals("10"))	query += " and ipgodt like '%"+t_wd+"%'";
				else if(s_kd.equals("11"))	query += " and chulgodt like '%"+t_wd+"%'";
				else if(s_kd.equals("12"))	query += " and estimate_num like '%"+t_wd+"%'";
			}

		}

		if(sort.equals("1"))		query += " order by firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by car_no "+asc;
		else if(sort.equals("3"))	query += " order by car_nm||car_name "+asc;
		else if(sort.equals("4"))	query += " order by accid_dt "+asc;
		else if(sort.equals("5"))	query += " order by off_nm "+asc;
		else if(sort.equals("6"))	query += " order by serv_dt "+asc;
		else if(sort.equals("7"))	query += " order by ipgodt "+asc;
		else if(sort.equals("8"))	query += " order by chulgodt "+asc;

		try {
           

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){           
				System.out.println("[AccidDatabase:getAccidS3List24]="+se);
				System.out.println("[AccidDatabase:getAccidS3List24]="+query);
		         throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트-물적사고관리(외부업체용)
	public Vector getAccidG3List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
        String query1 = "";
        String query2 = "";

		query1 = " select  /*+  merge(b) */  '4' gubun,"+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_use, c.car_no, c.first_car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, b.brch_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, a.settle_st2, a.settle_st4, a.our_num,"+
				" e.serv_id, e.serv_dt, substr(e.ipgodt,1,8) ipgodt, substr(e.chulgodt,1,8) chulgodt, e.tot_amt, e.cust_amt, e.set_dt, e.cust_pay_dt, e.rep_cont, f.off_nm, a.settle_st, e.estimate_num, e.scan_file"+
				" from accident a, cont_n_view b, service e, serv_off f, car_reg c,  car_etc g, car_nm cn "+
				" where e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" and e.off_id=f.off_id" +
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

		query = " select * from ( \n"+query1+"\n ) where car_mng_id is not null ";		

		if(gubun1.equals("1"))		query += " and car_use='1'"; 
		if(gubun1.equals("2"))		query += " and car_use='2'";

		String s_dt = "";
		if(gubun3.equals("0"))		s_dt = "accid_dt";
		else if(gubun3.equals("1"))	s_dt = "serv_dt";

		if(gubun2.equals("1"))		query += " and "+s_dt+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	query += " and "+s_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and "+s_dt+" like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	query += " and "+s_dt+" like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	query += " and "+s_dt+" between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))								query += " and brch_id in ('S1','K1')"; 


		if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and firm_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and car_no||' '||first_car_no like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and car_nm||car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and reg_id like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and off_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("9"))	query += " and serv_dt like '"+t_wd+"%'";
				else if(s_kd.equals("10"))	query += " and ipgodt like '%"+t_wd+"%'";
				else if(s_kd.equals("11"))	query += " and chulgodt like '%"+t_wd+"%'";
				else if(s_kd.equals("12"))	query += " and estimate_num like '%"+t_wd+"%'";

		}

		if(sort.equals("1"))		query += " order by firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by car_no "+asc;
		else if(sort.equals("3"))	query += " order by car_nm||car_name "+asc;
		else if(sort.equals("4"))	query += " order by accid_dt "+asc;
		else if(sort.equals("5"))	query += " order by off_nm "+asc;
		else if(sort.equals("6"))	query += " order by serv_dt "+asc;
		else if(sort.equals("7"))	query += " order by ipgodt "+asc;
		else if(sort.equals("8"))	query += " order by chulgodt "+asc;

		try {
           

			pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidG3List]="+se);
		         throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트 현황-물적사고
	public Hashtable getAccidSList3Stat(String br_id, String gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";

		if(gubun.equals("1")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, service b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) a,"+
					" (select count(0) su2 from accident a, service b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) b,"+
					" (select count(0) su3 from accident a, service b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) c,"+
					" (select count(0) su4 from accident a, service b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) d,"+
					" (select count(0) su5 from accident a, service b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) e";
		}else if(gubun.equals("2")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) a,"+
					" (select count(0) su2 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) b,"+
					" (select count(0) su3 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) c,"+
					" (select count(0) su4 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) d,"+
					" (select count(0) su5 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) e";
		}else{
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) a,"+
					" (select count(0) su2 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) b,"+
					" (select count(0) su3 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) c,"+
					" (select count(0) su4 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) d,"+
					" (select count(0) su5 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) e";
		}

		try {
      

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidSList3Stat]="+se);
		         throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고기록 리스트 현황-물적사고
	public Hashtable getAccidSList3Stat(String br_id, String gubun, String car_st, String gubun5) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String sub_query = "";
		String sub_table = "service";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query += " and a.rent_l_cd like '"+br_id+"%'"; 
		if(car_st.equals("1"))	sub_query += " and c.car_use='1'"; 
		if(car_st.equals("2"))	sub_query += " and c.car_use='2'";
		if(gubun5.equals("2")){
			sub_table = "ot_accid"; 
			sub_query += " and b.serv_dt is not null";
		}else{
			sub_table = "service"; 
		}

		if(gubun.equals("1")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") d,"+
					" (select count(0) su5 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") e";
		}else if(gubun.equals("2")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") d,"+
					" (select count(0) su5 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") e";
		}else{
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") d,"+
					" (select count(0) su5 from accident a, "+sub_table+" b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") e";
		}

		try {

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
            
				System.out.println("[AccidDatabase:getAccidSList3Stat]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고기록 리스트-면책금
	public Vector getAccidS4List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */ "+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.first_car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				" decode(b.car_ja,0,300000,'',300000,b.car_ja) car_ja, e.serv_dt, e.ipgodt, e.chulgodt,"+
				" decode(e.tot_amt,0,decode(e.sup_amt+e.add_amt,0,e.rep_amt,e.sup_amt+e.add_amt),e.tot_amt) tot_amt, e.cust_amt, e.set_dt, e.cust_req_dt, e.cust_pay_dt, e.rep_cont, f.off_nm, a.settle_st"+
				" from accident a, cont_n_view b, service e, serv_off f,  car_reg c,  car_etc g1, car_nm cn ,\n"+
				" rent_cont g, client h, users i"+
				" where e.cust_amt > 0 and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and e.off_id=f.off_id and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.cust_id(+) and g.cust_id=i.cust(+) \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g1.rent_mng_id(+)  and a.rent_l_cd = g1.rent_l_cd(+)  \n"+
                       		"	and g1.car_id=cn.car_id(+)  and    g1.car_seq=cn.car_seq(+) ";
	
		if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!gubun3.equals(""))		query += " and a.accid_st = '"+gubun3+"'";

		if(gubun4.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun4.equals("2"))		query += " and c.car_use='2'";

		if(gubun5.equals("1"))		query += " and e.cust_pay_dt is not null";
		if(gubun5.equals("2"))		query += " and e.cust_pay_dt is null";

		if(!brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 

		if(s_kd.equals("1"))		query += " and b.firm_nm||h.firm_nm||i.user_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and b.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
		else if(s_kd.equals("6"))	query += " and a.our_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("7"))	query += " and a.ot_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	query += " and a.ot_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("9"))	query += " and a.our_ins like '%"+t_wd+"%'";
		else if(s_kd.equals("10"))	query += " and b.mng_id like '%"+t_wd+"%'";

		if(sort.equals("1"))		query += " order by a.accid_dt";
		else if(sort.equals("2"))	query += " order by b.firm_nm";
		else if(sort.equals("3"))	query += " order by c.car_no";
		else if(sort.equals("4"))	query += " order by c.car_nm||cn.car_name";
		else if(sort.equals("5"))	query += " order by a.our_ins";

		if(asc.equals("0"))			query += " asc";
		else if(asc.equals("1"))	query += " desc";

		try {
         

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           	System.out.println("[AccidDatabase:getAccidS3List]="+se);
		    throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트-면책금
	public Vector getAccidS4List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */ "+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.first_car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				" decode(b.car_ja,0,300000,'',300000,b.car_ja) car_ja, e.serv_dt, e.ipgodt, e.chulgodt, nvl(e.no_dft_yn,'N') no_dft_yn,"+
				" decode(e.tot_amt,0,decode(e.sup_amt+e.add_amt,0,e.rep_amt,e.sup_amt+e.add_amt),e.tot_amt) tot_amt, e.cust_amt, e.set_dt, e.cust_req_dt, e.cust_plan_dt, e.cust_pay_dt, e.rep_cont, f.off_nm, a.settle_st"+
				" from accident a, cont_n_view b, service e, serv_off f, scd_ext se , car_reg c,  car_etc g, car_nm cn \n"+
				" where e.cust_amt > 0 and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+
				" and b.rent_mng_id = se.rent_mng_id and b.rent_l_cd = se.rent_l_cd  and e.serv_id=se.ext_id  and se.ext_st = '3' and nvl(se.bill_yn, 'Y') = 'Y' "+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and e.off_id=f.off_id \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
	
		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";


			if(gubun2.equals("1"))		query += " and e.cust_plan_dt = to_char(sysdate,'YYYYMMDD')";
			else if(gubun2.equals("2"))	query += " and e.cust_plan_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and e.cust_plan_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and e.cust_plan_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and e.cust_plan_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(gubun3.equals("0"))		query += " and nvl(e.no_dft_yn,'N') = 'N' and e.cust_pay_dt is null";
			if(gubun3.equals("1"))		query += " and nvl(e.no_dft_yn,'N') = 'N' and e.cust_pay_dt is not null";
			if(gubun3.equals("2"))		query += " and nvl(e.no_dft_yn,'N') = 'Y'";//손비
			if(gubun3.equals("3"))		query += " and nvl(e.no_dft_yn,'N') = 'N' and e.cust_pay_dt is null and e.cust_plan_dt < to_char(sysdate,'YYYYMMDD')";


		}else{
			
			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";

			if(gubun2.equals("1"))		query += " and e.cust_plan_dt = to_char(sysdate,'YYYYMMDD')";
			else if(gubun2.equals("2"))	query += " and e.cust_plan_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and e.cust_plan_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and e.cust_plan_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and e.cust_plan_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
			
			if(gubun3.equals("0"))		query += " and nvl(e.no_dft_yn,'N') = 'N' and e.cust_pay_dt is null";
			if(gubun3.equals("1"))		query += " and nvl(e.no_dft_yn,'N') = 'N' and e.cust_pay_dt is not null";
			if(gubun3.equals("2"))		query += " and nvl(e.no_dft_yn,'N') = 'Y'";//손비
			if(gubun3.equals("3"))		query += " and nvl(e.no_dft_yn,'N') = 'N' and e.cust_pay_dt is null and e.cust_plan_dt < to_char(sysdate,'YYYYMMDD')";


			if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and b.firm_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and e.cust_req_dt like '"+t_wd+"%'";
				else if(s_kd.equals("9"))	query += " and e.cust_pay_dt like '"+t_wd+"%'";
				else if(s_kd.equals("11"))	query += " and e.bus_id2 like '%"+t_wd+"%'";
			}

		}

		if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by c.car_no "+asc;
		else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
		else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;
		else if(sort.equals("5"))	query += " order by e.cust_req_dt "+asc;
		else if(sort.equals("6"))	query += " order by e.cust_pay_dt "+asc;


		if(gubun3.equals("4")){//면책금 미청구리스트----------------------------------------------------------------------------------------

		query = " select /*+  merge(b) */ "+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.first_car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				" decode(b.car_ja,0,300000,'',300000,b.car_ja) car_ja, e.serv_dt, e.ipgodt, e.chulgodt, nvl(e.no_dft_yn,'N') no_dft_yn,"+
				" decode(e.tot_amt,0,decode(e.sup_amt+e.add_amt,0,e.rep_amt,e.sup_amt+e.add_amt),e.tot_amt) tot_amt, e.cust_amt, e.set_dt, e.cust_req_dt, e.cust_plan_dt, e.cust_pay_dt, e.rep_cont, f.off_nm, a.settle_st"+
				" from accident a, cont_n_view b, service e, serv_off f, car_reg c,  car_etc g, car_nm cn \n"+
				" where "+
				" a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and e.off_id=f.off_id"+
				" and a.car_mng_id=e.car_mng_id and a.accid_id=e.accid_id"+
				" and a.accid_st in ('2','3')"+//쌍방,가해 
				" and nvl(e.no_dft_yn,'N')='N'"+//면제아님
				" and e.cust_amt = 0 "+//면책금0원
				" and decode(e.tot_amt,0,decode(e.sup_amt+e.add_amt,0,e.rep_amt,e.sup_amt+e.add_amt),e.tot_amt)>0 "+//정비금액0원이상
				" and substr(a.accid_dt,1,8) > '20061231'"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
				

			if(!t_wd.equals("")){
				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and b.firm_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and e.cust_req_dt like '"+t_wd+"%'";
				else if(s_kd.equals("9"))	query += " and e.cust_pay_dt like '"+t_wd+"%'";
			}

			if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
			else if(sort.equals("2"))	query += " order by c.car_no "+asc;
			else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
			else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;
			else if(sort.equals("5"))	query += " order by e.cust_req_dt "+asc;
			else if(sort.equals("6"))	query += " order by e.cust_pay_dt "+asc;

		}
		try {
            con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
				System.out.println("[AccidDatabase:getAccidS3List]="+se);
				System.out.println("[AccidDatabase:getAccidS3List]="+query);
			     throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


	//사고기록 리스트 현황-면책금
	public Hashtable getAccidSList4Stat(String br_id, String gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		 

		if(gubun.equals("1")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) a,"+
					" (select count(0) su2 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) b,"+
					" (select count(0) su3 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) c,"+
					" (select count(0) su4 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) d,"+
					" (select count(0) su5 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) e";
		}else if(gubun.equals("2")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) a,"+
					" (select count(0) su2 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) b,"+
					" (select count(0) su3 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) c,"+
					" (select count(0) su4 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) d,"+
					" (select count(0) su5 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) e";
		}else{
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) a,"+
					" (select count(0) su2 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) b,"+
					" (select count(0) su3 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) c,"+
					" (select count(0) su4 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) d,"+
					" (select count(0) su5 from accident a, service b where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id) e";
		}

		try {
          
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
         
				System.out.println("[AccidDatabase:getAccidSList4Stat]="+se);
		  
              throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고기록 리스트 현황-면책금
	public Hashtable getAccidSList4Stat(String br_id, String gubun, String car_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String sub_query = "";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query += " and a.rent_l_cd like '"+br_id+"%'"; 
		if(car_st.equals("1"))	sub_query += " and c.car_use='1'"; 
		if(car_st.equals("2"))	sub_query += " and c.car_use='2'";

		if(gubun.equals("1")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") d,"+
					" (select count(0) su5 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") e";
		}else if(gubun.equals("2")){
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") d,"+
					" (select count(0) su5 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") e";
		}else{
			query = " select su1, su2, su3, su4, su5, (su1+su2+su3+su4+su5) tot_su from"+
					" (select count(0) su1 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select count(0) su2 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='2' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") b,"+
					" (select count(0) su3 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='3' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") c,"+
					" (select count(0) su4 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='4' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") d,"+
					" (select count(0) su5 from accident a, service b, car_reg c where b.cust_amt > 0 and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.accid_st='5' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.car_mng_id=c.car_mng_id "+sub_query+") e";
		}

		try {
          

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidSList4Stat]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }


	//사고기록 리스트-휴/대차료
	public Vector getAccidS5List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */ "+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				" decode(e.req_gu, '1','휴차료','2','대차료', decode(c.car_use), '1','휴차료','대차료')) req_gu,"+			
				" a.our_ins, e.use_st, e.use_et, e.req_amt, e.pay_dt, a.settle_st, e.re_reason "+
				" from accident a, cont_n_view b, my_accid e , car_reg c,  car_etc g, car_nm cn \n"+
				" where e.req_st='1' and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
				
	
		if(gubun2.equals("1"))		query += " and e.req_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	query += " and e.req_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and e.req_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";


		if(!gubun3.equals(""))		query += " and a.accid_st = '"+gubun3+"'";

		if(gubun4.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun4.equals("2"))		query += " and c.car_use='2'";

		if(gubun5.equals("1"))		query += " and e.pay_dt is not null";
		if(gubun5.equals("2"))		query += " and e.pay_dt is null";

		if(!brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 

		if(s_kd.equals("1"))		query += " and b.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and b.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
		else if(s_kd.equals("6"))	query += " and a.our_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("7"))	query += " and a.ot_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	query += " and a.ot_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("9"))	query += " and a.our_ins like '%"+t_wd+"%'";
		else if(s_kd.equals("10"))	query += " and b.mng_id like '%"+t_wd+"%'";

		if(sort.equals("1"))		query += " order by b.use_yn desc , a.accid_dt";
		else if(sort.equals("2"))	query += " order by b.use_yn desc , b.firm_nm";
		else if(sort.equals("3"))	query += " order by b.use_yn desc , c.car_no";
		else if(sort.equals("4"))	query += " order by b.use_yn desc , c.car_nm||cn.car_name";
		else if(sort.equals("5"))	query += " order by b.use_yn desc , a.our_ins";

		if(asc.equals("0"))			query += " asc";
		else if(asc.equals("1"))	query += " desc";

		try {
        
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidS5List]="+se);
		         throw new DatabaseException("exception");
        }finally{
            try{
          
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트-휴/대차료
	public Vector getAccidS5List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */ "+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+			
				" decode(e.req_gu, '1','휴차료','2','대차료', decode(c.car_use, '1','1','2')) req_gu,"+
				" nvl(a.sub_firm_nm,'') sub_firm_nm, a.our_ins, e.ins_com, e.ins_nm, e.use_st, e.use_et, e.req_amt, e.req_dt, e.pay_amt, e.pay_dt, a.settle_st, a.settle_st5, "+
				" decode(d.ext_pay_amt,0,0,(e.req_amt-d.ext_pay_amt)) def_amt,"+
				" a.our_fault_per, (100-a.our_fault_per) ot_fault_per, case when b.mng_id = '' then b.bus_id2 when b.mng_id is null then b.bus_id2 else b.mng_id end bus_id2, e.re_reason, "+
				" d.ext_pay_amt, e.doc_req_dt, e.doc_reg_dt "+
				" from accident a, cont_n_view b, my_accid e,  car_reg c,  car_etc g, car_nm cn , \n"+
				"	   (select rent_mng_id, rent_l_cd, ext_id, sum(ext_pay_amt) ext_pay_amt from scd_ext where ext_st='6' group by rent_mng_id, rent_l_cd, ext_id) d "+
				" where a.accid_dt >= '20080101' "+
				" and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id"+ 
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and e.accid_id||to_char(e.seq_no)=d.ext_id "+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
				
	
		if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		query += " and c.car_use='2'";

		if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1','K2')"; 
		if(brch_id.equals("B1"))								query += " and b.brch_id in ('B1','N1')"; 
		if(brch_id.equals("D1"))								query += " and b.brch_id in ('D1')"; 

		if(gubun3.equals("0")){
				
			query += " and e.req_dt is not null and e.pay_dt is null";

			if(gubun2.equals("1"))		query += " and e.req_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and e.req_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and e.req_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and e.req_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	{
				if(!st_dt.equals("") && !end_dt.equals("")){
					query += " and e.req_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";			
				}
			}
		}else{

			if(gubun3.equals("1"))		query += " and e.pay_dt is not null";
			if(gubun3.equals("2"))		query += " and e.pay_dt is not null and e.req_amt>e.pay_amt and e.pay_amt>0";//손비
			
			if(gubun2.equals("1"))		query += " and e.pay_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and e.pay_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and e.pay_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and e.pay_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	{
				if(!st_dt.equals("") && !end_dt.equals("")){
					query += " and e.pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";			
				}
			}		
		}

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
			else if(s_kd.equals("2"))	query += " and b.firm_nm like '%"+t_wd+"%'";
			else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
			else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
			else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
			else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
			else if(s_kd.equals("7"))	query += " and case when b.mng_id = '' then b.bus_id2 when b.mng_id is null then b.bus_id2 else b.mng_id end like '%"+t_wd+"%'";
			else if(s_kd.equals("8"))	query += " and e.ins_com like '%"+t_wd+"%'";
			else if(s_kd.equals("9"))	query += " and e.req_dt like '"+t_wd+"%'";
			else if(s_kd.equals("10"))	query += " and e.pay_dt like '"+t_wd+"%'";
			else if(s_kd.equals("11"))	query += " and e.bus_id2 like '%"+t_wd+"%'";
		}

		if(sort.equals("1"))		query += " order by b.use_yn desc, b.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by b.use_yn desc, c.car_no "+asc;
		else if(sort.equals("3"))	query += " order by b.use_yn desc, c.car_nm||cn.car_name "+asc;
		else if(sort.equals("4"))	query += " order by b.use_yn desc, a.accid_dt "+asc;
		else if(sort.equals("5"))	query += " order by b.use_yn desc, e.ins_com "+asc;
		else if(sort.equals("6"))	query += " order by b.use_yn desc, e.req_dt "+asc;
		else if(sort.equals("7"))	query += " order by b.use_yn desc, e.pay_dt "+asc;

		try {
          

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){       
				System.out.println("[AccidDatabase:getAccidS5List]="+se);
				System.out.println("[AccidDatabase:getAccidS5List]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트-휴/대차료 - 2008년이후 사고건만 조회 :  - 미청구분
	public Vector getAccidS5List2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */ "+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				"        decode(e.req_gu, '1','휴차료','2','대차료', decode(c.car_use, '1','휴차료','대차료')) req_gu,"+
				"        nvl(a.sub_firm_nm,'') sub_firm_nm, a.our_ins, e.ins_com, e.ins_nm, e.use_st, e.use_et, e.req_amt, e.req_dt, e.pay_amt, e.pay_dt, a.settle_st, a.settle_st5, decode(e.pay_amt,0,0,(e.req_amt-e.pay_amt)) def_amt,"+
				"        a.our_fault_per, (100-a.our_fault_per) ot_fault_per,  b.bus_id2, e.re_reason, e.doc_req_dt, e.doc_reg_dt, "+
				"        decode(d.sub_c_id,'','N','Y') rent_cont_yn "+
				" from   accident a, cont_n_view b, my_accid e, car_reg c,  car_etc g, car_nm cn,  \n"+ 
				"  (select sub_c_id, accid_id from rent_cont where use_st in ('2','3','4') AND sub_c_id IS NOT NULL AND accid_id IS NOT null group by sub_c_id, accid_id ) d "+
				" where  a.accid_dt >= '20080101' "+
				"        and a.car_mng_id=e.car_mng_id(+) and a.accid_id=e.accid_id(+) "+
				"        and nvl(e.req_st, '0')  = '0' and e.req_dt is  null and e.pay_dt is null and nvl(e.bill_yn,'Y')='Y'"+
				"        and a.accid_st in ('1','3') and (100-a.our_fault_per)>0"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
				"        and a.car_mng_id=d.sub_c_id(+) and a.accid_id=d.accid_id(+)  \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
					
		if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		query += " and c.car_use='2'";

		if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1','K2', 'I1', 'S2')"; 
		if(brch_id.equals("B1"))								query += " and b.brch_id in ('B1','N1')"; 
		if(brch_id.equals("D1"))								query += " and b.brch_id in ('D1')"; 

		if(gubun3.equals("0")){
				
			query += " and e.req_dt is not null and e.pay_dt is null";

			if(gubun2.equals("1"))		query += " and e.req_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and e.req_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and e.req_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and e.req_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	{
				if(!st_dt.equals("") && !end_dt.equals("")){
					query += " and e.req_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";			
				}
			}
		}else{

			if(gubun3.equals("1"))		query += " and e.pay_dt is not null";
			if(gubun3.equals("2"))		query += " and e.pay_dt is not null and e.req_amt>e.pay_amt and e.pay_amt>0";//손비
			
			if(gubun2.equals("1"))		query += " and e.req_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and e.req_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and e.pay_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and e.pay_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	{
				if(!st_dt.equals("") && !end_dt.equals("")){
					query += " and e.pay_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";			
				}
			}		
		}

			if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and b.firm_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and case when b.mng_id = '' then b.bus_id2 when b.mng_id is null then b.bus_id2 else b.mng_id end like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and e.ins_com like '%"+t_wd+"%'";
				else if(s_kd.equals("9"))	query += " and e.req_dt like '"+t_wd+"%'";
				else if(s_kd.equals("10"))	query += " and e.pay_dt like '"+t_wd+"%'";
				else if(s_kd.equals("11"))	query += " and e.bus_id2 like '%"+t_wd+"%'";
			}


		if(sort.equals("1"))		query += " order by  b.use_yn desc,  decode(nvl(e.re_reason,''), '', 1, 2) asc, b.firm_nm "+asc+",			decode(d.sub_c_id,'','N','Y') desc, a.accid_dt desc";
		else if(sort.equals("2"))	query += " order by  b.use_yn desc,  decode(nvl(e.re_reason,''), '', 1, 2) asc, c.car_no "+asc+",			decode(d.sub_c_id,'','N','Y') desc, a.accid_dt desc";
		else if(sort.equals("3"))	query += " order by  b.use_yn desc,  decode(nvl(e.re_reason,''), '', 1, 2) asc, c.car_nm||cn.car_name "+asc+", decode(d.sub_c_id,'','N','Y') desc, a.accid_dt desc";
		else if(sort.equals("4"))	query += " order by  b.use_yn desc,  decode(nvl(e.re_reason,''), '', 1, 2) asc, a.accid_dt "+asc+",			decode(d.sub_c_id,'','N','Y') desc, a.accid_dt desc";
		else if(sort.equals("5"))	query += " order by  b.use_yn desc,  decode(nvl(e.re_reason,''), '', 1, 2) asc, e.ins_com "+asc+",			decode(d.sub_c_id,'','N','Y') desc, a.accid_dt desc";
		else if(sort.equals("6"))	query += " order by  b.use_yn desc,  decode(nvl(e.re_reason,''), '', 1, 2) asc, e.req_dt "+asc+",			decode(d.sub_c_id,'','N','Y') desc, a.accid_dt desc ";
		else if(sort.equals("7"))	query += " order by  b.use_yn desc,  decode(nvl(e.re_reason,''), '', 1, 2) asc, e.pay_dt "+asc+",			decode(d.sub_c_id,'','N','Y') desc, a.accid_dt desc";

		try {
          

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
       
				System.out.println("[AccidDatabase:getAccidS5List2]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트
	public String getInserNm(String c_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ins_nm = "";
        String query = "";

		query = " select c.ins_com_nm"+
				" from insur a, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) b, ins_com c"+
				" where a.car_mng_id='"+c_id+"'"+
				" and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st and a.ins_com_id=c.ins_com_id";
	
		try {
         

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			if(rs.next())
				ins_nm = rs.getString(1);

            rs.close();
            pstmt.close();

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getInserNm]="+se);
			
              throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ins_nm;
    }


	//사고기록 리스트 현황
	public Hashtable getAccidSList5Stat(String br_id, String gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String sub_query = "";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query += " and a.rent_l_cd like '"+br_id+"%' "; 

		if(gubun.equals("1")){
			query = " select su1, su2, (su1+su2) tot_su, amt1, amt2, (amt1+amt2) tot_amt from"+
					" (select count(0) su1, nvl(sum(b.req_amt),0) amt1 from accident a, my_accid b where b.req_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and b.req_gu='1' and b.req_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id "+sub_query+" ) a,"+
					" (select count(0) su2, nvl(sum(b.req_amt),0) amt2 from accident a, my_accid b where b.req_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and b.req_gu='2' and b.req_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id "+sub_query+" ) b";
		}else if(gubun.equals("2")){
			query = " select su1, su2, (su1+su2) tot_su, amt1, amt2, (amt1+amt2) tot_amt from"+
					" (select count(0) su1, nvl(sum(b.req_amt),0) amt1 from accident a, my_accid b where b.req_dt like to_char(sysdate,'YYYYMM')||'%' and b.req_gu='1' and b.req_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id "+sub_query+" ) a,"+
					" (select count(0) su2, nvl(sum(b.req_amt),0) amt2 from accident a, my_accid b where b.req_dt like to_char(sysdate,'YYYYMM')||'%' and b.req_gu='2' and b.req_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id "+sub_query+" ) b";
		}else{
			query = " select su1, su2, (su1+su2) tot_su, amt1, amt2, (amt1+amt2) tot_amt from"+
					" (select count(0) su1, nvl(sum(b.req_amt),0) amt1 from accident a, my_accid b where b.req_dt like to_char(sysdate,'YYYYMMDD')||'%' and b.req_gu='1' and b.req_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id "+sub_query+" ) a,"+
					" (select count(0) su2, nvl(sum(b.req_amt),0) amt2 from accident a, my_accid b where b.req_dt like to_char(sysdate,'YYYYMMDD')||'%' and b.req_gu='2' and b.req_st='1' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id "+sub_query+" ) b";
		}
	
		try {
        

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
            
				System.out.println("[AccidDatabase:getAccidSList2Stat]="+se);
			     throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고기록 리스트
	public Vector getAccidS6List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */ "+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				" a.our_ins, a.hum_amt, a.mat_amt, a.one_amt, a.my_amt, e.tot_amt, a.settle_st"+
				" from accident a, cont_n_view b,  car_reg c,  car_etc g, car_nm cn,  \n"+
				" (select car_mng_id, accid_id, sum(tot_amt) tot_amt from service group by car_mng_id, accid_id) e"+
				" where "+
				" a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=e.car_mng_id(+) and a.accid_id=e.accid_id(+)  \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";	

		if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";


		if(!gubun3.equals(""))		query += " and a.accid_st = '"+gubun3+"'";

		if(gubun4.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun4.equals("2"))		query += " and c.car_use='2'";

		if(!brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 

		if(s_kd.equals("1"))		query += " and b.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and b.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.accid_dt like '%"+t_wd+"%'";
		else if(s_kd.equals("6"))	query += " and a.our_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("7"))	query += " and a.ot_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	query += " and a.ot_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("9"))	query += " and a.our_ins like '%"+t_wd+"%'";
		else if(s_kd.equals("10"))	query += " and b.mng_id like '%"+t_wd+"%'";

		if(sort.equals("1"))		query += " order by a.accid_dt";
		else if(sort.equals("2"))	query += " order by b.firm_nm";
		else if(sort.equals("3"))	query += " order by c.car_no";
		else if(sort.equals("4"))	query += " order by c.car_nm||cn.car_name";
		else if(sort.equals("5"))	query += " order by a.our_ins";

		if(asc.equals("0"))			query += " asc";
		else if(asc.equals("1"))	query += " desc";

		try {
          

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
        
				System.out.println("[AccidDatabase:getAccidS6List]="+se);
		         throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트
	public Vector getAccidS6List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */ "+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				" a.our_ins, a.hum_amt, a.mat_amt, a.one_amt, a.my_amt, e.tot_amt, a.settle_st"+
				" from accident a, cont_n_view b, car_reg c,  car_etc g, car_nm cn,  \n"+
				" (select car_mng_id, accid_id, sum(tot_amt) tot_amt from service group by car_mng_id, accid_id) e"+
				" where (a.hum_amt+a.mat_amt+a.one_amt+a.my_amt+e.tot_amt)>0"+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=e.car_mng_id(+) and a.accid_id=e.accid_id(+) \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
	
		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";

			if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(!gubun3.equals(""))		query += " and nvl(a.settle_st,'0')='"+gubun3+"'";

			if(gubun4.equals("1") && gubun5.equals("2"))		query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물
			else if(gubun4.equals("1") && gubun5.equals("4"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차
			else if(gubun4.equals("1") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type3,'N')='N' and (a.dam_type2 = 'Y' or a.dam_type4 = 'Y')";//물적(대물+자차)
			else if(gubun4.equals("2") && gubun5.equals("1"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대인
			else if(gubun4.equals("2") && gubun5.equals("3"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//자손
			else if(gubun4.equals("2") && gubun5.equals(""))	query += " and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type4,'N')='N' and (a.dam_type1 = 'Y' or a.dam_type3 = 'Y')";//인적(대인+자손)
			else if(gubun4.equals("3") && gubun5.equals("5"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물+대인
			else if(gubun4.equals("3") && gubun5.equals("6"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//대물+자손
			else if(gubun4.equals("3") && gubun5.equals("7"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차+대인
			else if(gubun4.equals("3") && gubun5.equals("8"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='Y'";//자차+자손
			else if(gubun4.equals("3") && gubun5.equals(""))	query += " and ((a.dam_type1 = 'Y' and a.dam_type2 = 'Y') or (a.dam_type2 = 'Y' and a.dam_type3 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type1 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type3 = 'Y'))";//복합
			
			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";

		}else{

			if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and b.firm_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
			}

		}

		if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by c.car_no "+asc;
		else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
		else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;

		try {
         

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidS6List]="+se);
			     throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트 현황-보험보상금
	public Hashtable getAccidSList6Stat(String br_id, String gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";

		if(gubun.equals("1")){
			query = " select amt1, amt2, amt3, amt4, (amt1+amt2+amt3+amt4) tot_amt from"+
					" (select nvl(sum(hum_amt),0) amt1 from accident where accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%') a,"+
					" (select nvl(sum(mat_amt),0) amt2 from accident where accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%') b,"+
					" (select nvl(sum(one_amt),0) amt3 from accident where accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%') c,"+
					" (select nvl(sum(b.tot_amt),0) amt4 from accident a, service b where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd) d";
		}else if(gubun.equals("2")){
			query = " select amt1, amt2, amt3, amt4, (amt1+amt2+amt3+amt4) tot_amt from"+
					" (select nvl(sum(hum_amt),0) amt1 from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%') a,"+
					" (select nvl(sum(mat_amt),0) amt2 from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%') b,"+
					" (select nvl(sum(one_amt),0) amt3 from accident where accid_dt like to_char(sysdate,'YYYYMM')||'%') c,"+
					" (select nvl(sum(b.tot_amt),0) amt4 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd) d";
		}else{
			query = " select amt1, amt2, amt3, amt4, (amt1+amt2+amt3+amt4) tot_amt from"+
					" (select nvl(sum(hum_amt),0) amt1 from accident where accid_dt like to_char(sysdate,'YYYYMMDD')||'%') a,"+
					" (select nvl(sum(mat_amt),0) amt2 from accident where accid_dt like to_char(sysdate,'YYYYMMDD')||'%') b,"+
					" (select nvl(sum(one_amt),0) amt3 from accident where accid_dt like to_char(sysdate,'YYYYMMDD')||'%') c,"+
					" (select nvl(sum(b.tot_amt),0) amt4 from accident a, service b where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd) d";
		}
	
		try {

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
          
				System.out.println("[AccidDatabase:getAccidSList2Stat]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
          
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고기록 리스트 현황-보험보상금
	public Hashtable getAccidSList6Stat(String br_id, String gubun, String car_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String sub_query = "";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query += " and a.rent_l_cd like '"+br_id+"%'"; 
		if(car_st.equals("1"))	sub_query += " and c.car_use='1'"; 
		if(car_st.equals("2"))	sub_query += " and c.car_use='2'";

		if(gubun.equals("1")){
			query = " select amt1, amt2, amt3, amt4, (amt1+amt2+amt3+amt4) tot_amt from"+
					" (select nvl(sum(a.hum_amt),0) amt1 from accident a, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select nvl(sum(a.mat_amt),0) amt2 from accident a, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.car_mng_id=c.car_mng_id "+sub_query+") b,"+
					" (select nvl(sum(a.one_amt),0) amt3 from accident a, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.car_mng_id=c.car_mng_id "+sub_query+") c,"+
					" (select nvl(sum(b.tot_amt),0) amt4 from accident a, service b, car_reg c where a.accid_dt like to_char(add_months(sysdate,-1),'YYYYMM')||'%' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=c.car_mng_id "+sub_query+") d";
		}else if(gubun.equals("2")){
			query = " select amt1, amt2, amt3, amt4, (amt1+amt2+amt3+amt4) tot_amt from"+
					" (select nvl(sum(a.hum_amt),0) amt1 from accident a, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select nvl(sum(a.mat_amt),0) amt2 from accident a, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.car_mng_id=c.car_mng_id "+sub_query+") b,"+
					" (select nvl(sum(a.one_amt),0) amt3 from accident a, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.car_mng_id=c.car_mng_id "+sub_query+") c,"+
					" (select nvl(sum(b.tot_amt),0) amt4 from accident a, service b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMM')||'%' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=c.car_mng_id "+sub_query+") d";
		}else{
			query = " select amt1, amt2, amt3, amt4, (amt1+amt2+amt3+amt4) tot_amt from"+
					" (select nvl(sum(a.hum_amt),0) amt1 from accident a, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.car_mng_id=c.car_mng_id "+sub_query+") a,"+
					" (select nvl(sum(a.mat_amt),0) amt2 from accident a, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.car_mng_id=c.car_mng_id "+sub_query+") b,"+
					" (select nvl(sum(a.one_amt),0) amt3 from accident a, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.car_mng_id=c.car_mng_id "+sub_query+") c,"+
					" (select nvl(sum(b.tot_amt),0) amt4 from accident a, service b, car_reg c where a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%' and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=c.car_mng_id "+sub_query+") d";
		}
	
		try {

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
         
				System.out.println("[AccidDatabase:getAccidSList2Stat]="+se);
		        throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고기록 리스트-비용
	public Vector getAccidS7List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */ "+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				" a.our_ins, nvl(a.hum_amt,0) hum_amt, nvl(a.mat_amt,0) mat_amt, nvl(a.one_amt,0) one_amt, nvl(a.my_amt,0) my_amt, nvl(e.tot_amt,0) tot_amt, nvl(e.cust_amt,0) cust_amt, nvl(f.req_amt,0) req_amt, a.settle_st"+
				" from accident a, cont_n_view b, my_accid f, car_reg c,  car_etc g, car_nm cn , \n"+
				" (select car_mng_id, accid_id, sum(tot_amt) tot_amt, sum(cust_amt) cust_amt from service group by car_mng_id, accid_id) e"+
				" where "+
				" a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=f.car_mng_id(+) and a.accid_id=f.accid_id(+)"+
				" and a.car_mng_id=e.car_mng_id(+) and a.accid_id=e.accid_id(+) \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";	


		if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";


		if(!gubun3.equals(""))		query += " and a.accid_st = '"+gubun3+"'";

		if(gubun4.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun4.equals("2"))		query += " and c.car_use='2'";

		if(!brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 

		if(s_kd.equals("1"))		query += " and b.firm_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and b.rent_l_cd like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
		else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
		else if(s_kd.equals("6"))	query += " and a.our_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("7"))	query += " and a.ot_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("8"))	query += " and a.ot_driver like '%"+t_wd+"%'";
		else if(s_kd.equals("9"))	query += " and a.our_ins like '%"+t_wd+"%'";
		else if(s_kd.equals("10"))	query += " and b.mng_id like '%"+t_wd+"%'";

		if(sort.equals("1"))		query += " order by a.accid_dt";
		else if(sort.equals("2"))	query += " order by b.firm_nm";
		else if(sort.equals("3"))	query += " order by c.car_no";
		else if(sort.equals("4"))	query += " order by c.car_nm||cn.car_name";
		else if(sort.equals("5"))	query += " order by a.our_ins";

		if(asc.equals("0"))			query += " asc";
		else if(asc.equals("1"))	query += " desc";

		try {
           
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
            
				System.out.println("[AccidDatabase:getAccidS7List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고기록 리스트-비용
	public Vector getAccidS7List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */ "+
				" a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				" a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				" decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm,"+
				" a.our_ins, nvl(a.hum_amt,0) hum_amt, nvl(a.mat_amt,0) mat_amt, nvl(a.one_amt,0) one_amt, nvl(a.my_amt,0) my_amt, nvl(e.tot_amt,0) tot_amt, nvl(e.cust_amt,0) cust_amt, nvl(f.req_amt,0) req_amt, a.settle_st"+
				" from accident a, cont_n_view b, my_accid f, car_reg c,  car_etc g, car_nm cn , \n"+
				" (select car_mng_id, accid_id, sum(tot_amt) tot_amt, sum(cust_amt) cust_amt from service group by car_mng_id, accid_id) e"+
				" where "+
				" a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=f.car_mng_id(+) and a.accid_id=f.accid_id(+)"+
				" and a.car_mng_id=e.car_mng_id(+) and a.accid_id=e.accid_id(+) \n"+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
	

		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";

			if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(!gubun3.equals(""))		query += " and nvl(a.settle_st,'0')='"+gubun3+"'";

			if(gubun4.equals("1") && gubun5.equals("2"))		query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물
			else if(gubun4.equals("1") && gubun5.equals("4"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차
			else if(gubun4.equals("1") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type3,'N')='N' and (a.dam_type2 = 'Y' or a.dam_type4 = 'Y')";//물적(대물+자차)
			else if(gubun4.equals("2") && gubun5.equals("1"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대인
			else if(gubun4.equals("2") && gubun5.equals("3"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//자손
			else if(gubun4.equals("2") && gubun5.equals(""))	query += " and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type4,'N')='N' and (a.dam_type1 = 'Y' or a.dam_type3 = 'Y')";//인적(대인+자손)
			else if(gubun4.equals("3") && gubun5.equals("5"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물+대인
			else if(gubun4.equals("3") && gubun5.equals("6"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//대물+자손
			else if(gubun4.equals("3") && gubun5.equals("7"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차+대인
			else if(gubun4.equals("3") && gubun5.equals("8"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='Y'";//자차+자손
			else if(gubun4.equals("3") && gubun5.equals(""))	query += " and ((a.dam_type1 = 'Y' and a.dam_type2 = 'Y') or (a.dam_type2 = 'Y' and a.dam_type3 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type1 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type3 = 'Y'))";//복합
			
			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";

		}else{

			if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and b.firm_nm like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and c.car_no||' '||c.first_car_no like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and a.our_ins like '%"+t_wd+"%'";
			}

		}

		if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by c.car_no "+asc;
		else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
		else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;

//System.out.println("[AccidDatabase:getAccidS7List]="+query);


		try {
           
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
          
				System.out.println("[AccidDatabase:getAccidS7List]="+se);
				System.out.println("[AccidDatabase:getAccidS7List]="+query);
		         throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//견적서 관리번호 생성
	public String getEstimateNum(String code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String estimate_num = "";
		String query = "select '"+code+"'|| nvl(ltrim(to_char(to_number(max(substr(estimate_num, 7, 3))+1), '000')), '001') ID "+
						" from service "+
						" where estimate_num like '%"+code+"%'";


		try {
          

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				estimate_num = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getEstimateNum]="+se);
		         throw new DatabaseException("exception");
        }finally{
            try{
           
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return estimate_num;
    }

	//현재예상누적주행거리
	public String getTodayDist(String c_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String today_dist = "0";
		String query = "";
		query = " select "+
				"        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,a.dlv_dt,0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(a.dlv_dt,'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as today_dist"+
				" from   CONT a, v_tot_dist vt, "+
				"        (select a.car_mng_id, a.serv_dt, a.tot_dist from SERVICE a where a.serv_dt||a.serv_id=(select max(serv_dt||serv_id) from service where car_mng_id=a.car_mng_id)) b"+
				" where  a.car_mng_id='"+c_id+"' and nvl(a.use_yn,'Y')='Y' "+
				"        and a.car_mng_id=vt.car_mng_id(+) and a.car_mng_id=b.car_mng_id(+)";

		try {
          

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				today_dist = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
            
				System.out.println("[AccidDatabase:getTodayDist]="+se);
				System.out.println("[AccidDatabase:getTodayDist]="+query);
			     throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return today_dist;
    }

	/**
    * 차량별 사고사진 리스트 bean
    */    
    private PicAccidBean makePicAccidBean(ResultSet results) throws DatabaseException {
        try {
            PicAccidBean bean = new PicAccidBean();
			bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					
			bean.setAccid_id(results.getString("ACCID_ID"));
			bean.setSeq(results.getString("SEQ"));			
			bean.setFilename(results.getString("FILENAME"));
			bean.setFile_path(results.getString("FILE_PATH"));
			
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
     * 차량별 사고사진 리스트 조회
     */
    public PicAccidBean [] getPicAccidList(String c_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       	String query =	" select * from pic_accid where car_mng_id='"+c_id+"' and accid_id='"+accid_id+"' order by seq";

		Collection col = new ArrayList();

        try{

			pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);
            while(rs.next()){               
				col.add(makePicAccidBean(rs)); 
            }

            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getPicAccidList]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (PicAccidBean[])col.toArray(new PicAccidBean[0]);
    }

    /**
     * 사고차량사진 등록
     */
    public int insertPicAccid(PicAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
        int seq_no = 0;
        int count = 0;
                
        query = " INSERT INTO pic_accid (CAR_MNG_ID, ACCID_ID, SEQ, FILENAME, REG_ID, REG_DT, FILE_PATH)\n"+
				" values(?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ? )\n";

		query1= " select nvl(max(seq)+1,1) from pic_accid where car_mng_id=? and accid_id=?";
    
       try{
            con.setAutoCommit(false);

            pstmt1 = con.prepareStatement(query1);
            pstmt1.setString(1, bean.getCar_mng_id().trim());
            pstmt1.setString(2, bean.getAccid_id().trim());
			rs = pstmt1.executeQuery();
            if(rs.next()){
				seq_no = rs.getInt(1);
            }
			rs.close();
			pstmt1.close();

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
			pstmt.setString(2, bean.getAccid_id().trim());
			pstmt.setInt   (3, seq_no);
			pstmt.setString(4, bean.getFilename().trim());
			pstmt.setString(5, bean.getReg_id().trim());
			pstmt.setString(6, bean.getFile_path().trim());
            count = pstmt.executeUpdate();
            pstmt.close(); 

            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:insertPicAccid]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 사고차량사진 삭제
     */
    public int deletePicAccid(String c_id, String accid_id, String seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " delete from PIC_ACCID where car_mng_id='"+c_id+"' and accid_id='"+accid_id+"' and seq="+seq;
    
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:deletePicAccid]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
	 *	면책금/휴차료/대차료 메모
	 */
	public Vector getInsMemo(String m_id, String l_cd, String c_id, String tm_st, String accid_id, String serv_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query =	" select * from tel_mm"+
						" where RENT_MNG_ID='"+m_id+"' and RENT_L_CD='"+l_cd+"' and CAR_MNG_ID='"+c_id+"'"+
						" ";

		query += " order by REG_DT desc, REG_DT_TIME desc ";		

		try {
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{
				InsMemoBean ins_mm = new InsMemoBean();
				ins_mm.setRent_mng_id(rs.getString("RENT_MNG_ID")==null?"":rs.getString("RENT_MNG_ID"));
				ins_mm.setRent_l_cd(rs.getString("RENT_L_CD")==null?"":rs.getString("RENT_L_CD"));
				ins_mm.setCar_mng_id(rs.getString("CAR_MNG_ID")==null?"":rs.getString("CAR_MNG_ID"));
				ins_mm.setTm_st(rs.getString("TM_ST")==null?"":rs.getString("TM_ST"));
				ins_mm.setAccid_id(rs.getString("ACCID_ID")==null?"":rs.getString("ACCID_ID"));
				ins_mm.setServ_id(rs.getString("SERV_ID")==null?"":rs.getString("SERV_ID"));
				ins_mm.setSeq(rs.getString("SEQ")==null?"":rs.getString("SEQ"));
				ins_mm.setReg_id(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				ins_mm.setReg_dt(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				ins_mm.setContent(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));
				ins_mm.setSpeaker(rs.getString("SPEAKER")==null?"":rs.getString("SPEAKER"));
				vt.add(ins_mm);
			}
            rs.close();
            pstmt.close();

		} catch (SQLException e) {
          
				System.out.println("[AccidDatabase:getInsMemo]\n"+e);
                throw new DatabaseException("exception");
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}				
		return vt;
	}

	/**	
	 *	면책금/휴차료/대차료 메모 insert
	 */
	public boolean insertInsMemo(InsMemoBean ins_mm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String s_seq = "";
		String query_id = " select nvl(ltrim(to_char(to_number(MAX(seq))+1, '000000')), '000001') ID from tel_mm";

		String query =  " insert into tel_mm ("+
						" RENT_MNG_ID, RENT_L_CD, CAR_MNG_ID, ACCID_ID, SERV_ID,"+
						" TM_ST, SEQ, REG_ID, REG_DT, CONTENT, SPEAKER, REG_DT_TIME)"+//12
						" values ( ?, ?, ?, ?, ?,  ?, ?, ?, replace(?, '-', ''), ?, ?, ?)";
		try {

			con.setAutoCommit(false);

			pstmt1 = con.prepareStatement(query_id);
	    	rs = pstmt1.executeQuery();
			if(rs.next())
			{
				s_seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();

			pstmt2 = con.prepareStatement(query);
			pstmt2.setString(1, ins_mm.getRent_mng_id());
			pstmt2.setString(2, ins_mm.getRent_l_cd());
			pstmt2.setString(3, ins_mm.getCar_mng_id());
			pstmt2.setString(4, ins_mm.getAccid_id());
			pstmt2.setString(5, ins_mm.getServ_id());
			pstmt2.setString(6, ins_mm.getTm_st());
			pstmt2.setString(7, s_seq);
			pstmt2.setString(8, ins_mm.getReg_id());
			pstmt2.setString(9, ins_mm.getReg_dt());
			pstmt2.setString(10, ins_mm.getContent());
			pstmt2.setString(11, ins_mm.getSpeaker());
			pstmt2.setString(12, s_seq);
		    pstmt2.executeUpdate();
			pstmt2.close();
			
            con.commit();

	  	} catch (Exception e) {
            try{
		  		flag = false;
				System.out.println("[AccidDatabase:insertInsMemo]\n"+e);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
		} finally {
			try{	
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return flag;
	}	


	//사고현황---------------------------------------------------------------------------------------------------------------


	//사고현황-연간/월간
	public String [] getAccidStat1List(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String su[] = new String[13];

		query = " select substr(a.accid_dt,1,6)||count(*) m_su"+
					" from accident a, cont b"+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		query += " and substr(a.accid_dt,1,8) between to_char(add_months(to_date('"+st_dt+"','YYYYMMDD'),-1),'YYYYMMDD') and '"+end_dt+"'";//'"+st_dt+"'시작전월부터
		if(!brch_id.equals(""))							query += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	query += " and b.brch_id = '"+br_id+"'"; 
		if(!gubun3.equals(""))							query += " and a.accid_st = '"+gubun3+"'";

		query += " group by substr(a.accid_dt,1,6) order by substr(a.accid_dt,1,6)";

		try {

          
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{				
				String value = rs.getString(1);

				if(!value.substring(0,4).equals(st_dt.substring(0,4))){
					su[0]=value.substring(6);
				}else{
					su[AddUtil.parseInt(value.substring(4,6))] = value.substring(6);
				}
			}

            rs.close();
            pstmt.close();

		}catch(SQLException se){
          
				System.out.println("[AccidDatabase:getAccidStat1List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return su;
    }

	//사고현황-연간/월간
	public String [] getAccidStat1List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String su[] = new String[13];

		query = " select  /*+  merge(b) */ substr(a.accid_dt,1,6)||count(*) m_su"+
				" from accident a, cont_n_view b, car_reg c "+
				" where a.rent_mng_id=a.rent_mng_id  and  a.rent_l_cd=b.rent_l_cd and a.car_mng_id = c.car_mng_id  "+
				" and substr(a.accid_dt,1,8) between to_char(add_months(to_date('"+st_dt+"','YYYYMMDD'),-1),'YYYYMMDD') and '"+end_dt+"'";

		if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		query += " and c.car_use='2'";

		if(!br_id.equals("S1") && !br_id.equals(""))	query += " and b.brch_id = '"+br_id+"'"; 

		if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

		query += " group by substr(a.accid_dt,1,6) order by substr(a.accid_dt,1,6)";


		try {

       
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			while(rs.next())
			{				
				String value = rs.getString(1);

				if(!value.substring(0,4).equals(st_dt.substring(0,4))){
					su[0]=value.substring(6);
				}else{
					su[AddUtil.parseInt(value.substring(4,6))] = value.substring(6);
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidStat1List]="+se);
			     throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return su;
    }

	
	//사고현황-기간
	public Vector getAccidStat2List(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select substr(a.accid_dt,1,6) accid_dt, a.accid_st, a.our_dam_st, a.accid_type"+
					" from accident a, cont b"+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and substr(a.accid_dt,1,8) between to_char(add_months(to_date('"+st_dt+"','YYYYMMDD'),-1),'YYYYMMDD') and '"+end_dt+"'";//'"+st_dt+"'시작전월부터
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";


		query = " select\n"+ 
				" a.accid_dt, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8,\n"+ 
				" nvl(j.su9,0) su9, nvl(k.su10,0) su10, nvl(l.su11,0) su11, nvl(m.su12,0) su12\n"+ 
				" from\n"+ 
				" ( select accid_dt, count(*) tot_su from ("+sub_query+") group by accid_dt ) a,\n"+ 
				" ( select accid_dt, count(*) su1 from ("+sub_query+") where accid_st='1' group by accid_dt ) b,\n"+ 
				" ( select accid_dt, count(*) su2 from ("+sub_query+") where accid_st='2' group by accid_dt ) c,\n"+ 
				" ( select accid_dt, count(*) su3 from ("+sub_query+") where accid_st='3' group by accid_dt ) d,\n"+ 
				" ( select accid_dt, count(*) su4 from ("+sub_query+") where accid_st='8' group by accid_dt ) e,\n"+ 
				" ( select accid_dt, count(*) su5 from ("+sub_query+") where accid_st='6' group by accid_dt ) f,\n"+ 
				" ( select accid_dt, count(*) su6 from ("+sub_query+") where our_dam_st='1' group by accid_dt ) g,\n"+ 
				" ( select accid_dt, count(*) su7 from ("+sub_query+") where our_dam_st='2' group by accid_dt ) h,\n"+ 
				" ( select accid_dt, count(*) su8 from ("+sub_query+") where our_dam_st='3' group by accid_dt ) i,\n"+ 
				" ( select accid_dt, count(*) su9 from ("+sub_query+") where accid_type='1' group by accid_dt ) j,\n"+ 
				" ( select accid_dt, count(*) su10 from ("+sub_query+") where accid_type='2' group by accid_dt ) k,\n"+ 
				" ( select accid_dt, count(*) su11 from ("+sub_query+") where accid_type='3' group by accid_dt ) l,\n"+ 
				" ( select accid_dt, count(*) su12 from ("+sub_query+") where accid_type='4' group by accid_dt ) m\n"+ 
				" where \n"+ 
				" a.accid_dt=b.accid_dt(+) and a.accid_dt=c.accid_dt(+) and a.accid_dt=d.accid_dt(+) and a.accid_dt=e.accid_dt(+) and a.accid_dt=f.accid_dt(+)\n"+ 
				" and a.accid_dt=g.accid_dt(+) and a.accid_dt=h.accid_dt(+) and a.accid_dt=i.accid_dt(+)\n"+ 
				" and a.accid_dt=j.accid_dt(+) and a.accid_dt=k.accid_dt(+) and a.accid_dt=l.accid_dt(+) and a.accid_dt=m.accid_dt(+)";
		try {

       

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidStat2List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고현황-기간
	public Vector getAccidStat2List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select  /*+  merge(b) */ substr(a.accid_dt,1,6) accid_dt, a.accid_st, a.our_dam_st, a.accid_type,"+
					" nvl(a.dam_type1,'N') dam_type1, nvl(a.dam_type2,'N') dam_type2, nvl(a.dam_type3,'N') dam_type3, nvl(a.dam_type4,'N') dam_type4"+
					" from accident a, cont_n_view b, car_reg c"+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = c.car_mng_id \n";

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt between to_char(add_months(sysdate,-1),'YYYYMM')||'01' and to_char(sysdate,'YYYYMM')||'31'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt between to_char(add_months(to_date('"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"01','YYYYMMDD'),-1),'YYYYMMDD') and '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"31'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt between to_char(add_months(to_date('"+AddUtil.getDate(1)+"0101','YYYYMMDD'),-1),'YYYYMMDD') and '"+AddUtil.getDate(1)+"1231'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between to_char(add_months(to_date('"+st_dt+"','YYYYMMDD'),-1),'YYYYMMDD') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" a.accid_dt, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, "+
				" nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8,\n"+ 
				" nvl(j.su9,0) su9, nvl(k.su10,0) su10, nvl(l.su11,0) su11, nvl(m.su12,0) su12\n"+ 
				" from\n"+ 
				" ( select accid_dt, count(0) tot_su from ("+sub_query+") group by accid_dt ) a,\n"+ 
				" ( select accid_dt, count(0) su1 from ("+sub_query+") where accid_st='1' group by accid_dt ) b,\n"+ 
				" ( select accid_dt, count(0) su2 from ("+sub_query+") where accid_st='2' group by accid_dt ) c,\n"+ 
				" ( select accid_dt, count(0) su3 from ("+sub_query+") where accid_st='3' group by accid_dt ) d,\n"+ 
				" ( select accid_dt, count(0) su4 from ("+sub_query+") where accid_st='8' group by accid_dt ) e,\n"+ 
				" ( select accid_dt, count(0) su5 from ("+sub_query+") where accid_st='6' group by accid_dt ) f,\n"+ 
				" ( select accid_dt, count(0) su6 from ("+sub_query+") where dam_type2='N' and dam_type4='N' and (dam_type1 = 'Y' or dam_type3 = 'Y') group by accid_dt ) g,\n"+ 
				" ( select accid_dt, count(0) su7 from ("+sub_query+") where dam_type1='N' and dam_type3='N' and (dam_type2 = 'Y' or dam_type4 = 'Y') group by accid_dt ) h,\n"+ 
				" ( select accid_dt, count(0) su8 from ("+sub_query+") where ((dam_type1 = 'Y' and dam_type2 = 'Y') or (dam_type2 = 'Y' and dam_type3 = 'Y') or (dam_type4 = 'Y' and dam_type1 = 'Y') or (dam_type4 = 'Y' and dam_type3 = 'Y')) group by accid_dt ) i,\n"+ 
				" ( select accid_dt, count(0) su9 from ("+sub_query+") where accid_type='1' group by accid_dt ) j,\n"+ 
				" ( select accid_dt, count(0) su10 from ("+sub_query+") where accid_type='2' group by accid_dt ) k,\n"+ 
				" ( select accid_dt, count(0) su11 from ("+sub_query+") where accid_type='3' group by accid_dt ) l,\n"+ 
				" ( select accid_dt, count(0) su12 from ("+sub_query+") where accid_type='4' group by accid_dt ) m\n"+ 
				" where \n"+ 
				" a.accid_dt=b.accid_dt(+) and a.accid_dt=c.accid_dt(+) and a.accid_dt=d.accid_dt(+) and a.accid_dt=e.accid_dt(+) and a.accid_dt=f.accid_dt(+)\n"+ 
				" and a.accid_dt=g.accid_dt(+) and a.accid_dt=h.accid_dt(+) and a.accid_dt=i.accid_dt(+)\n"+ 
				" and a.accid_dt=j.accid_dt(+) and a.accid_dt=k.accid_dt(+) and a.accid_dt=l.accid_dt(+) and a.accid_dt=m.accid_dt(+)";
		try {
        

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidStat2List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 전월갯수
     */
    public int getLastMonthSu(String br_id, String brch_id, String dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
		ResultSet rs = null;
        String query = "";
        int su = 0;

		query = " select count(*)"+
					" from accident a, cont b"+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.accid_dt like to_char(to_date('"+dt+"','YYYYMM')-1,'YYYYMM')||'%'";

		if(!brch_id.equals(""))							query += " and b.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	query += " and b.brch_id = '"+br_id+"'"; 

    
       try{
           

			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				su = rs.getInt(1);
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
           
				System.out.println("[AccidDatabase:getLastMonthSu]\n"+se);
                 throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return su;
    }

	//사고현황-차량별
	public Vector getAccidStat3List(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select a.car_mng_id, a.accid_st, a.our_dam_st, a.accid_type"+
					" from accident a, cont b"+
					" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and substr(a.accid_dt,1,8) between '"+st_dt+"' and '"+end_dt+"'";//'"+st_dt+"'시작전월부터
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		query = " select\n"+ 
				" a.car_mng_id, a.tot_su, n.car_no,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8,\n"+ 
				" nvl(j.su9,0) su9, nvl(k.su10,0) su10, nvl(l.su11,0) su11, nvl(m.su12,0) su12\n"+ 
				" from\n"+ 
				" ( select car_mng_id, count(*) tot_su from ("+sub_query+") group by car_mng_id ) a,\n"+ 
				" ( select car_mng_id, count(*) su1 from ("+sub_query+") where accid_st='1' group by car_mng_id ) b,\n"+ 
				" ( select car_mng_id, count(*) su2 from ("+sub_query+") where accid_st='2' group by car_mng_id ) c,\n"+ 
				" ( select car_mng_id, count(*) su3 from ("+sub_query+") where accid_st='3' group by car_mng_id ) d,\n"+ 
				" ( select car_mng_id, count(*) su4 from ("+sub_query+") where accid_st='8' group by car_mng_id ) e,\n"+ 
				" ( select car_mng_id, count(*) su5 from ("+sub_query+") where accid_st='6' group by car_mng_id ) f,\n"+ 
				" ( select car_mng_id, count(*) su6 from ("+sub_query+") where our_dam_st='1' group by car_mng_id ) g,\n"+ 
				" ( select car_mng_id, count(*) su7 from ("+sub_query+") where our_dam_st='2' group by car_mng_id ) h,\n"+ 
				" ( select car_mng_id, count(*) su8 from ("+sub_query+") where our_dam_st='3' group by car_mng_id ) i,\n"+ 
				" ( select car_mng_id, count(*) su9 from ("+sub_query+") where accid_type='1' group by car_mng_id ) j,\n"+ 
				" ( select car_mng_id, count(*) su10 from ("+sub_query+") where accid_type='2' group by car_mng_id ) k,\n"+ 
				" ( select car_mng_id, count(*) su11 from ("+sub_query+") where accid_type='3' group by car_mng_id ) l,\n"+ 
				" ( select car_mng_id, count(*) su12 from ("+sub_query+") where accid_type='4' group by car_mng_id ) m, car_reg n\n"+ 
				" where \n"+ 
				" a.car_mng_id=b.car_mng_id(+) and a.car_mng_id=c.car_mng_id(+) and a.car_mng_id=d.car_mng_id(+) and a.car_mng_id=e.car_mng_id(+) and a.car_mng_id=f.car_mng_id(+)\n"+ 
				" and a.car_mng_id=g.car_mng_id(+) and a.car_mng_id=h.car_mng_id(+) and a.car_mng_id=i.car_mng_id(+)\n"+ 
				" and a.car_mng_id=j.car_mng_id(+) and a.car_mng_id=k.car_mng_id(+) and a.car_mng_id=l.car_mng_id(+) and a.car_mng_id=m.car_mng_id(+)"+
				" and a.car_mng_id=n.car_mng_id";

		if(sort.equals("1"))		query += " order by n.car_no "+asc;
		if(sort.equals("2"))		query += " order by a.tot_su "+asc+", n.car_no";
		if(sort.equals("3"))		query += " order by nvl(b.su1,0) "+asc+", n.car_no";
		if(sort.equals("4"))		query += " order by nvl(c.su2,0) "+asc+", n.car_no";
		if(sort.equals("5"))		query += " order by nvl(d.su3,0) "+asc+", n.car_no";
		if(sort.equals("6"))		query += " order by nvl(e.su4,0) "+asc+", n.car_no";
		if(sort.equals("7"))		query += " order by nvl(f.su5,0) "+asc+", n.car_no";
		if(sort.equals("8"))		query += " order by nvl(g.su6,0) "+asc+", n.car_no";
		if(sort.equals("9"))		query += " order by nvl(h.su7,0) "+asc+", n.car_no";
		if(sort.equals("10"))		query += " order by nvl(i.su8,0) "+asc+", n.car_no";
		if(sort.equals("11"))		query += " order by nvl(j.su9,0) "+asc+", n.car_no";
		if(sort.equals("12"))		query += " order by nvl(k.su10,0) "+asc+", n.car_no";
		if(sort.equals("13"))		query += " order by nvl(l.su11,0) "+asc+", n.car_no";
		if(sort.equals("14"))		query += " order by nvl(m.su12,0) "+asc+", n.car_no";

		try {

          

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
         
				System.out.println("[AccidDatabase:getAccidStat3List]="+se);
			      throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고현황-차량별
	public Vector getAccidStat3List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select  /*+  merge(b) */ a.car_mng_id, a.accid_st, a.our_dam_st, a.accid_type,"+
					" nvl(a.dam_type1,'N') dam_type1, nvl(a.dam_type2,'N') dam_type2, nvl(a.dam_type3,'N') dam_type3, nvl(a.dam_type4,'N') dam_type4"+
					" from accident a, cont_n_view b, car_reg c "+
					" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = c.car_mng_id \n";

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.car_mng_id, a.tot_su, n.car_no,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8,\n"+ 
				" nvl(j.su9,0) su9, nvl(k.su10,0) su10, nvl(l.su11,0) su11, nvl(m.su12,0) su12\n"+ 
				" from\n"+ 
				" ( select car_mng_id, count(0) tot_su from ("+sub_query+") group by car_mng_id ) a,\n"+ 
				" ( select car_mng_id, count(0) su1 from ("+sub_query+") where accid_st='1' group by car_mng_id ) b,\n"+ 
				" ( select car_mng_id, count(0) su2 from ("+sub_query+") where accid_st='2' group by car_mng_id ) c,\n"+ 
				" ( select car_mng_id, count(0) su3 from ("+sub_query+") where accid_st='3' group by car_mng_id ) d,\n"+ 
				" ( select car_mng_id, count(0) su4 from ("+sub_query+") where accid_st='8' group by car_mng_id ) e,\n"+ 
				" ( select car_mng_id, count(0) su5 from ("+sub_query+") where accid_st='6' group by car_mng_id ) f,\n"+ 

				" ( select car_mng_id, count(0) su6 from ("+sub_query+") where dam_type2='N' and dam_type4='N' and (dam_type1 = 'Y' or dam_type3 = 'Y') group by car_mng_id ) g,\n"+ 
				" ( select car_mng_id, count(0) su7 from ("+sub_query+") where dam_type1='N' and dam_type3='N' and (dam_type2 = 'Y' or dam_type4 = 'Y') group by car_mng_id ) h,\n"+ 
				" ( select car_mng_id, count(0) su8 from ("+sub_query+") where ((dam_type1 = 'Y' and dam_type2 = 'Y') or (dam_type2 = 'Y' and dam_type3 = 'Y') or (dam_type4 = 'Y' and dam_type1 = 'Y') or (dam_type4 = 'Y' and dam_type3 = 'Y')) group by car_mng_id ) i,\n"+ 
				" ( select car_mng_id, count(0) su9 from ("+sub_query+") where accid_type='1' group by car_mng_id ) j,\n"+ 
				" ( select car_mng_id, count(0) su10 from ("+sub_query+") where accid_type='2' group by car_mng_id ) k,\n"+ 
				" ( select car_mng_id, count(0) su11 from ("+sub_query+") where accid_type='3' group by car_mng_id ) l,\n"+ 
				" ( select car_mng_id, count(0) su12 from ("+sub_query+") where accid_type='4' group by car_mng_id ) m, car_reg n\n"+ 
				" where \n"+ 
				" a.car_mng_id=b.car_mng_id(+) and a.car_mng_id=c.car_mng_id(+) and a.car_mng_id=d.car_mng_id(+) and a.car_mng_id=e.car_mng_id(+) and a.car_mng_id=f.car_mng_id(+)\n"+ 
				" and a.car_mng_id=g.car_mng_id(+) and a.car_mng_id=h.car_mng_id(+) and a.car_mng_id=i.car_mng_id(+)\n"+ 
				" and a.car_mng_id=j.car_mng_id(+) and a.car_mng_id=k.car_mng_id(+) and a.car_mng_id=l.car_mng_id(+) and a.car_mng_id=m.car_mng_id(+)"+
				" and a.car_mng_id=n.car_mng_id";

		if(sort.equals("1"))		query += " order by n.car_no "+asc;
		if(sort.equals("2"))		query += " order by a.tot_su "+asc+", n.car_no";
		if(sort.equals("3"))		query += " order by nvl(b.su1,0) "+asc+", n.car_no";
		if(sort.equals("4"))		query += " order by nvl(c.su2,0) "+asc+", n.car_no";
		if(sort.equals("5"))		query += " order by nvl(d.su3,0) "+asc+", n.car_no";
		if(sort.equals("6"))		query += " order by nvl(e.su4,0) "+asc+", n.car_no";
		if(sort.equals("7"))		query += " order by nvl(f.su5,0) "+asc+", n.car_no";
		if(sort.equals("8"))		query += " order by nvl(g.su6,0) "+asc+", n.car_no";
		if(sort.equals("9"))		query += " order by nvl(h.su7,0) "+asc+", n.car_no";
		if(sort.equals("10"))		query += " order by nvl(i.su8,0) "+asc+", n.car_no";
		if(sort.equals("11"))		query += " order by nvl(j.su9,0) "+asc+", n.car_no";
		if(sort.equals("12"))		query += " order by nvl(k.su10,0) "+asc+", n.car_no";
		if(sort.equals("13"))		query += " order by nvl(l.su11,0) "+asc+", n.car_no";
		if(sort.equals("14"))		query += " order by nvl(m.su12,0) "+asc+", n.car_no";

		try {

          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidStat3List]="+se);
			     throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


	//사고현황-고객별
	public Vector getAccidStat4List(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select b.client_id, a.accid_st, a.our_dam_st, a.accid_type"+
					" from accident a, cont b"+
					" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and substr(a.accid_dt,1,8) between '"+st_dt+"' and '"+end_dt+"'";//'"+st_dt+"'시작전월부터
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		query = " select\n"+ 
				" a.client_id, a.tot_su, nvl(n.firm_nm,n.client_nm) firm_nm,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8,\n"+ 
				" nvl(j.su9,0) su9, nvl(k.su10,0) su10, nvl(l.su11,0) su11, nvl(m.su12,0) su12\n"+ 
				" from\n"+ 
				" ( select client_id, count(*) tot_su from ("+sub_query+") group by client_id ) a,\n"+ 
				" ( select client_id, count(*) su1 from ("+sub_query+") where accid_st='1' group by client_id ) b,\n"+ 
				" ( select client_id, count(*) su2 from ("+sub_query+") where accid_st='2' group by client_id ) c,\n"+ 
				" ( select client_id, count(*) su3 from ("+sub_query+") where accid_st='3' group by client_id ) d,\n"+ 
				" ( select client_id, count(*) su4 from ("+sub_query+") where accid_st='8' group by client_id ) e,\n"+ 
				" ( select client_id, count(*) su5 from ("+sub_query+") where accid_st='6' group by client_id ) f,\n"+ 
				" ( select client_id, count(*) su6 from ("+sub_query+") where our_dam_st='1' group by client_id ) g,\n"+ 
				" ( select client_id, count(*) su7 from ("+sub_query+") where our_dam_st='2' group by client_id ) h,\n"+ 
				" ( select client_id, count(*) su8 from ("+sub_query+") where our_dam_st='3' group by client_id ) i,\n"+ 
				" ( select client_id, count(*) su9 from ("+sub_query+") where accid_type='1' group by client_id ) j,\n"+ 
				" ( select client_id, count(*) su10 from ("+sub_query+") where accid_type='2' group by client_id ) k,\n"+ 
				" ( select client_id, count(*) su11 from ("+sub_query+") where accid_type='3' group by client_id ) l,\n"+ 
				" ( select client_id, count(*) su12 from ("+sub_query+") where accid_type='4' group by client_id ) m, client n\n"+ 
				" where \n"+ 
				" a.client_id=b.client_id(+) and a.client_id=c.client_id(+) and a.client_id=d.client_id(+) and a.client_id=e.client_id(+) and a.client_id=f.client_id(+)\n"+ 
				" and a.client_id=g.client_id(+) and a.client_id=h.client_id(+) and a.client_id=i.client_id(+)\n"+ 
				" and a.client_id=j.client_id(+) and a.client_id=k.client_id(+) and a.client_id=l.client_id(+) and a.client_id=m.client_id(+)"+
				" and a.client_id=n.client_id";

		if(sort.equals("1"))		query += " order by nvl(n.firm_nm,n.client_nm) "+asc;
		if(sort.equals("2"))		query += " order by a.tot_su "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("3"))		query += " order by nvl(b.su1,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("4"))		query += " order by nvl(c.su2,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("5"))		query += " order by nvl(d.su3,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("6"))		query += " order by nvl(e.su4,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("7"))		query += " order by nvl(f.su5,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("8"))		query += " order by nvl(g.su6,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("9"))		query += " order by nvl(h.su7,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("10"))		query += " order by nvl(i.su8,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("11"))		query += " order by nvl(j.su9,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("12"))		query += " order by nvl(k.su10,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("13"))		query += " order by nvl(l.su11,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("14"))		query += " order by nvl(m.su12,0) "+asc+", nvl(n.firm_nm,n.client_nm)";

		try {

          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidStat4List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고현황-고객별
	public Vector getAccidStat4List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select  /*+  merge(b) */ b.client_id, a.accid_st, a.our_dam_st, a.accid_type,"+
					" nvl(a.dam_type1,'N') dam_type1, nvl(a.dam_type2,'N') dam_type2, nvl(a.dam_type3,'N') dam_type3, nvl(a.dam_type4,'N') dam_type4"+
					" from accident a, cont_n_view b, car_reg c"+
					" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = c.car_mng_id ";

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.client_id, a.tot_su, nvl(n.firm_nm,n.client_nm) firm_nm,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8,\n"+ 
				" nvl(j.su9,0) su9, nvl(k.su10,0) su10, nvl(l.su11,0) su11, nvl(m.su12,0) su12\n"+ 
				" from\n"+ 
				" ( select client_id, count(*) tot_su from ("+sub_query+") group by client_id ) a,\n"+ 
				" ( select client_id, count(*) su1 from ("+sub_query+") where accid_st='1' group by client_id ) b,\n"+ 
				" ( select client_id, count(*) su2 from ("+sub_query+") where accid_st='2' group by client_id ) c,\n"+ 
				" ( select client_id, count(*) su3 from ("+sub_query+") where accid_st='3' group by client_id ) d,\n"+ 
				" ( select client_id, count(*) su4 from ("+sub_query+") where accid_st='8' group by client_id ) e,\n"+ 
				" ( select client_id, count(*) su5 from ("+sub_query+") where accid_st='6' group by client_id ) f,\n"+ 
				" ( select client_id, count(*) su6 from ("+sub_query+") where dam_type2='N' and dam_type4='N' and (dam_type1 = 'Y' or dam_type3 = 'Y') group by client_id ) g,\n"+ 
				" ( select client_id, count(*) su7 from ("+sub_query+") where dam_type1='N' and dam_type3='N' and (dam_type2 = 'Y' or dam_type4 = 'Y') group by client_id ) h,\n"+ 
				" ( select client_id, count(*) su8 from ("+sub_query+") where ((dam_type1 = 'Y' and dam_type2 = 'Y') or (dam_type2 = 'Y' and dam_type3 = 'Y') or (dam_type4 = 'Y' and dam_type1 = 'Y') or (dam_type4 = 'Y' and dam_type3 = 'Y')) group by client_id ) i,\n"+ 
				" ( select client_id, count(*) su9 from ("+sub_query+") where accid_type='1' group by client_id ) j,\n"+ 
				" ( select client_id, count(*) su10 from ("+sub_query+") where accid_type='2' group by client_id ) k,\n"+ 
				" ( select client_id, count(*) su11 from ("+sub_query+") where accid_type='3' group by client_id ) l,\n"+ 
				" ( select client_id, count(*) su12 from ("+sub_query+") where accid_type='4' group by client_id ) m, client n\n"+ 
				" where \n"+ 
				" a.client_id=b.client_id(+) and a.client_id=c.client_id(+) and a.client_id=d.client_id(+) and a.client_id=e.client_id(+) and a.client_id=f.client_id(+)\n"+ 
				" and a.client_id=g.client_id(+) and a.client_id=h.client_id(+) and a.client_id=i.client_id(+)\n"+ 
				" and a.client_id=j.client_id(+) and a.client_id=k.client_id(+) and a.client_id=l.client_id(+) and a.client_id=m.client_id(+)"+
				" and a.client_id=n.client_id";

		if(sort.equals("1"))		query += " order by nvl(n.firm_nm,n.client_nm) "+asc;
		if(sort.equals("2"))		query += " order by a.tot_su "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("3"))		query += " order by nvl(b.su1,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("4"))		query += " order by nvl(c.su2,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("5"))		query += " order by nvl(d.su3,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("6"))		query += " order by nvl(e.su4,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("7"))		query += " order by nvl(f.su5,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("8"))		query += " order by nvl(g.su6,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("9"))		query += " order by nvl(h.su7,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("10"))		query += " order by nvl(i.su8,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("11"))		query += " order by nvl(j.su9,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("12"))		query += " order by nvl(k.su10,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("13"))		query += " order by nvl(l.su11,0) "+asc+", nvl(n.firm_nm,n.client_nm)";
		if(sort.equals("14"))		query += " order by nvl(m.su12,0) "+asc+", nvl(n.firm_nm,n.client_nm)";

		try {

        
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
          
				System.out.println("[AccidDatabase:getAccidStat4List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고현황-보험회사
	public Vector getAccidStat5List(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select c.ins_com_id, a.accid_st, a.our_dam_st, a.accid_type \n"+
					" from accident a, cont b, insur c, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) d \n"+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
					" and c.car_mng_id=d.car_mng_id and c.ins_st=d.ins_st \n"+
					" and a.car_mng_id=c.car_mng_id";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and substr(a.accid_dt,1,8) between '"+st_dt+"' and '"+end_dt+"'";
		if(!brch_id.equals(""))							sub_query += " and b.brch_id = '"+brch_id+"'";

		query = " select\n"+ 
				" a.ins_com_id, a.tot_su, n.ins_com_nm,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8,\n"+ 
				" nvl(j.su9,0) su9, nvl(k.su10,0) su10, nvl(l.su11,0) su11, nvl(m.su12,0) su12\n"+ 
				" from\n"+ 
				" ( select ins_com_id, count(*) tot_su from ("+sub_query+") group by ins_com_id ) a,\n"+ 
				" ( select ins_com_id, count(*) su1 from ("+sub_query+") where accid_st='1' group by ins_com_id ) b,\n"+ 
				" ( select ins_com_id, count(*) su2 from ("+sub_query+") where accid_st='2' group by ins_com_id ) c,\n"+ 
				" ( select ins_com_id, count(*) su3 from ("+sub_query+") where accid_st='3' group by ins_com_id ) d,\n"+ 
				" ( select ins_com_id, count(*) su4 from ("+sub_query+") where accid_st='8' group by ins_com_id ) e,\n"+ 
				" ( select ins_com_id, count(*) su5 from ("+sub_query+") where accid_st='6' group by ins_com_id ) f,\n"+ 
				" ( select ins_com_id, count(*) su6 from ("+sub_query+") where our_dam_st='1' group by ins_com_id ) g,\n"+ 
				" ( select ins_com_id, count(*) su7 from ("+sub_query+") where our_dam_st='2' group by ins_com_id ) h,\n"+ 
				" ( select ins_com_id, count(*) su8 from ("+sub_query+") where our_dam_st='3' group by ins_com_id ) i,\n"+ 
				" ( select ins_com_id, count(*) su9 from ("+sub_query+") where accid_type='1' group by ins_com_id ) j,\n"+ 
				" ( select ins_com_id, count(*) su10 from ("+sub_query+") where accid_type='2' group by ins_com_id ) k,\n"+ 
				" ( select ins_com_id, count(*) su11 from ("+sub_query+") where accid_type='3' group by ins_com_id ) l,\n"+ 
				" ( select ins_com_id, count(*) su12 from ("+sub_query+") where accid_type='4' group by ins_com_id ) m, ins_com n\n"+ 
				" where \n"+ 
				" a.ins_com_id=b.ins_com_id(+) and a.ins_com_id=c.ins_com_id(+) and a.ins_com_id=d.ins_com_id(+) and a.ins_com_id=e.ins_com_id(+) and a.ins_com_id=f.ins_com_id(+)\n"+ 
				" and a.ins_com_id=g.ins_com_id(+) and a.ins_com_id=h.ins_com_id(+) and a.ins_com_id=i.ins_com_id(+)\n"+ 
				" and a.ins_com_id=j.ins_com_id(+) and a.ins_com_id=k.ins_com_id(+) and a.ins_com_id=l.ins_com_id(+) and a.ins_com_id=m.ins_com_id(+)"+
				" and a.ins_com_id=n.ins_com_id";

		if(sort.equals("1"))		query += " order by n.ins_com_nm "+asc;
		if(sort.equals("2"))		query += " order by a.tot_su "+asc+", n.ins_com_nm";
		if(sort.equals("3"))		query += " order by nvl(b.su1,0) "+asc+", n.ins_com_nm";
		if(sort.equals("4"))		query += " order by nvl(c.su2,0) "+asc+", n.ins_com_nm";
		if(sort.equals("5"))		query += " order by nvl(d.su3,0) "+asc+", n.ins_com_nm";
		if(sort.equals("6"))		query += " order by nvl(e.su4,0) "+asc+", n.ins_com_nm";
		if(sort.equals("7"))		query += " order by nvl(f.su5,0) "+asc+", n.ins_com_nm";
		if(sort.equals("8"))		query += " order by nvl(g.su6,0) "+asc+", n.ins_com_nm";
		if(sort.equals("9"))		query += " order by nvl(h.su7,0) "+asc+", n.ins_com_nm";
		if(sort.equals("10"))		query += " order by nvl(i.su8,0) "+asc+", n.ins_com_nm";
		if(sort.equals("11"))		query += " order by nvl(j.su9,0) "+asc+", n.ins_com_nm";
		if(sort.equals("12"))		query += " order by nvl(k.su10,0) "+asc+", n.ins_com_nm";
		if(sort.equals("13"))		query += " order by nvl(l.su11,0) "+asc+", n.ins_com_nm";
		if(sort.equals("14"))		query += " order by nvl(m.su12,0) "+asc+", n.ins_com_nm";

		try {

         
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidStat5List]="+se);
			     throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고현황-보험회사
	public Vector getAccidStat5List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select  /*+  merge(b) */ a.our_ins, a.accid_st, a.our_dam_st, a.accid_type,\n"+
					" nvl(a.dam_type1,'N') dam_type1, nvl(a.dam_type2,'N') dam_type2, nvl(a.dam_type3,'N') dam_type3, nvl(a.dam_type4,'N') dam_type4"+
					" from accident a, cont_n_view b , car_reg c \n"+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.our_ins is not null and a.car_mng_id =  c.car_mng_id ";

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.our_ins, a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8,\n"+ 
				" nvl(j.su9,0) su9, nvl(k.su10,0) su10, nvl(l.su11,0) su11, nvl(m.su12,0) su12\n"+ 
				" from\n"+ 
				" ( select our_ins, count(*) tot_su from ("+sub_query+") group by our_ins ) a,\n"+ 
				" ( select our_ins, count(*) su1 from ("+sub_query+") where accid_st='1' group by our_ins ) b,\n"+ 
				" ( select our_ins, count(*) su2 from ("+sub_query+") where accid_st='2' group by our_ins ) c,\n"+ 
				" ( select our_ins, count(*) su3 from ("+sub_query+") where accid_st='3' group by our_ins ) d,\n"+ 
				" ( select our_ins, count(*) su4 from ("+sub_query+") where accid_st='8' group by our_ins ) e,\n"+ 
				" ( select our_ins, count(*) su5 from ("+sub_query+") where accid_st='6' group by our_ins ) f,\n"+ 
				" ( select our_ins, count(*) su6 from ("+sub_query+") where dam_type2='N' and dam_type4='N' and (dam_type1 = 'Y' or dam_type3 = 'Y') group by our_ins ) g,\n"+ 
				" ( select our_ins, count(*) su7 from ("+sub_query+") where dam_type1='N' and dam_type3='N' and (dam_type2 = 'Y' or dam_type4 = 'Y') group by our_ins ) h,\n"+ 
				" ( select our_ins, count(*) su8 from ("+sub_query+") where ((dam_type1 = 'Y' and dam_type2 = 'Y') or (dam_type2 = 'Y' and dam_type3 = 'Y') or (dam_type4 = 'Y' and dam_type1 = 'Y') or (dam_type4 = 'Y' and dam_type3 = 'Y')) group by our_ins ) i,\n"+ 
				" ( select our_ins, count(*) su9 from ("+sub_query+") where accid_type='1' group by our_ins ) j,\n"+ 
				" ( select our_ins, count(*) su10 from ("+sub_query+") where accid_type='2' group by our_ins ) k,\n"+ 
				" ( select our_ins, count(*) su11 from ("+sub_query+") where accid_type='3' group by our_ins ) l,\n"+ 
				" ( select our_ins, count(*) su12 from ("+sub_query+") where accid_type='4' group by our_ins ) m\n"+ 
				" where \n"+ 
				" a.our_ins=b.our_ins(+) and a.our_ins=c.our_ins(+) and a.our_ins=d.our_ins(+) and a.our_ins=e.our_ins(+) and a.our_ins=f.our_ins(+)\n"+ 
				" and a.our_ins=g.our_ins(+) and a.our_ins=h.our_ins(+) and a.our_ins=i.our_ins(+)\n"+ 
				" and a.our_ins=j.our_ins(+) and a.our_ins=k.our_ins(+) and a.our_ins=l.our_ins(+) and a.our_ins=m.our_ins(+)";

		if(sort.equals("1"))		query += " order by a.our_ins "+asc;
		if(sort.equals("2"))		query += " order by a.tot_su "+asc+", n.ins_com_nm";
		if(sort.equals("3"))		query += " order by nvl(b.su1,0) "+asc+", n.ins_com_nm";
		if(sort.equals("4"))		query += " order by nvl(c.su2,0) "+asc+", n.ins_com_nm";
		if(sort.equals("5"))		query += " order by nvl(d.su3,0) "+asc+", n.ins_com_nm";
		if(sort.equals("6"))		query += " order by nvl(e.su4,0) "+asc+", n.ins_com_nm";
		if(sort.equals("7"))		query += " order by nvl(f.su5,0) "+asc+", n.ins_com_nm";
		if(sort.equals("8"))		query += " order by nvl(g.su6,0) "+asc+", n.ins_com_nm";
		if(sort.equals("9"))		query += " order by nvl(h.su7,0) "+asc+", n.ins_com_nm";
		if(sort.equals("10"))		query += " order by nvl(i.su8,0) "+asc+", n.ins_com_nm";
		if(sort.equals("11"))		query += " order by nvl(j.su9,0) "+asc+", n.ins_com_nm";
		if(sort.equals("12"))		query += " order by nvl(k.su10,0) "+asc+", n.ins_com_nm";
		if(sort.equals("13"))		query += " order by nvl(l.su11,0) "+asc+", n.ins_com_nm";
		if(sort.equals("14"))		query += " order by nvl(m.su12,0) "+asc+", n.ins_com_nm";

		try {

         
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidStat5List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
          
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고현황-정비업체
	public Vector getAccidStat6List(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select b.off_id, b.tot_amt"+
					" from accident a, service b, cont c"+
					" where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id"+
					" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
					" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd";

		if(!st_dt.equals("") && !end_dt.equals(""))		sub_query += " and nvl(b.serv_dt,substr(a.accid_dt,1,8)) between '"+st_dt+"' and '"+end_dt+"'";//'"+st_dt+"'시작전월부터
		if(!brch_id.equals(""))							sub_query += " and c.brch_id = '"+brch_id+"'";
		if(!br_id.equals("S1") && !br_id.equals(""))	sub_query += " and c.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" a.off_id, a.tot_su, a.tot_amt,"+
				" n.off_nm, n.ent_no, n.off_tel, n.off_fax\n"+  
				" from\n"+ 
				" ( select off_id, count(*)  tot_su, sum(nvl(tot_amt,0)) tot_amt from ("+sub_query+") group by off_id ) a,\n"+ 
				" serv_off n\n"+ 
				" where \n"+ 
				" a.off_id=n.off_id";

		if(sort.equals("1"))		query += " order by n.off_nm "+asc;
		if(sort.equals("2"))		query += " order by a.tot_su "+asc+", n.off_nm";
		if(sort.equals("3"))		query += " order by a.tot_amt "+asc+", n.off_nm";

		try {

            con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
            	System.out.println("[AccidDatabase:getAccidStat6List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고현황-정비업체
	public Vector getAccidStat6List(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select  /*+  merge(c) */ b.off_id, b.tot_amt"+
					" from accident a, service b, cont_n_view c, car_reg d "+
					" where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id"+
					" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
					" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.car_mng_id = d.car_mng_id ";

		if(gubun1.equals("1"))		sub_query += " and d.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and d.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and c.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and c.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and c.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.off_id, a.tot_su, a.tot_amt,"+
				" n.off_nm, n.ent_no, n.off_tel, n.off_fax\n"+  
				" from\n"+ 
				" ( select off_id, count(*)  tot_su, sum(nvl(tot_amt,0)) tot_amt from ("+sub_query+") group by off_id ) a,\n"+ 
				" serv_off n\n"+ 
				" where \n"+ 
				" a.off_id=n.off_id";

		if(sort.equals("1"))		query += " order by n.off_nm "+asc;
		if(sort.equals("2"))		query += " order by a.tot_su "+asc+", n.off_nm";
		if(sort.equals("3"))		query += " order by a.tot_amt "+asc+", n.off_nm";

		try {

      
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidStat6List]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고현황-제조사/연식별-사고대수&보유대수
	public Vector getAccidStat01(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";
		String sub_query2 = "";

		//사고대수
		sub_query = " select  /*+  merge(b) */ cn.car_comp_id, substr(c.init_reg_dt,1,4) init_reg_dt \n"+
					" from accident a, cont_n_view b, car_reg c,  car_etc g, car_nm cn\n"+
					" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
					"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                    "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		//보유대수
		sub_query2 = " select  /*+  merge(b) */ cn.car_comp_id \n"+
					" from cont_n_view b,  car_reg c,  car_etc g, car_nm cn\n"+
					" where nvl(b.use_yn,'Y')='Y'   \n"+
					"	and b.car_mng_id = c.car_mng_id  and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+)  \n"+
                       			"	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";				
					
		if(gubun1.equals("1"))		sub_query2 += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query2 += " and c.car_use='2'";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query2 += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query2 += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query2 += " and b.brch_id = '"+br_id+"'"; 



		query = " select\n"+ 
				" a.car_comp_id, a.tot_su, n.nm, \n"+  
				" nvl(a.su1,0)  su1,  nvl(a.su2,0)  su2,  nvl(a.su3,0) su3,   nvl(a.su4,0)  su4,  nvl(a.su5,0)  su5, "+
				" nvl(a.su6,0)  su6,  nvl(a.su7,0)  su7,  nvl(a.su8,0) su8,   nvl(a.su9,0)  su9,  nvl(a.su10,0) su10,  "+
				" nvl(a.su11,0) su11, nvl(a.su12,0) su12, nvl(a.su13,0) su13, nvl(a.su14,0) su14, nvl(a.su15,0) su15, "+
				" nvl(a.su16,0) su16, nvl(a.su17,0) su17, nvl(a.su18,0) su18, nvl(a.su19,0) su19, nvl(a.su20,0) su20,  "+
				" nvl(g.car_su,0) car_su\n"+ 
				" from\n"+ 
				" ( select car_comp_id, count(*) tot_su, "+
				"          count(decode(init_reg_dt,'2000',init_reg_dt)) su1, "+
				"          count(decode(init_reg_dt,'2001',init_reg_dt)) su2, "+
				"          count(decode(init_reg_dt,'2002',init_reg_dt)) su3, "+
				"          count(decode(init_reg_dt,'2003',init_reg_dt)) su4, "+
				"          count(decode(init_reg_dt,'2004',init_reg_dt)) su5, "+
				"          count(decode(init_reg_dt,'2005',init_reg_dt)) su6, "+
				"          count(decode(init_reg_dt,'2006',init_reg_dt)) su7, "+
				"          count(decode(init_reg_dt,'2007',init_reg_dt)) su8, "+
				"          count(decode(init_reg_dt,'2008',init_reg_dt)) su9, "+
				"          count(decode(init_reg_dt,'2009',init_reg_dt)) su10, "+
				"          count(decode(init_reg_dt,'2010',init_reg_dt)) su11, "+
				"          count(decode(init_reg_dt,'2011',init_reg_dt)) su12, "+
				"          count(decode(init_reg_dt,'2012',init_reg_dt)) su13, "+
				"          count(decode(init_reg_dt,'2013',init_reg_dt)) su14, "+
				"          count(decode(init_reg_dt,'2014',init_reg_dt)) su15, "+
				"          count(decode(init_reg_dt,'2015',init_reg_dt)) su16, "+
				"          count(decode(init_reg_dt,'2016',init_reg_dt)) su17, "+
				"          count(decode(init_reg_dt,'2017',init_reg_dt)) su18, "+
				"          count(decode(init_reg_dt,'2019',init_reg_dt)) su19, "+
				"          count(decode(init_reg_dt,'2020',init_reg_dt)) su20  "+
				"   from   ("+sub_query+") "+
				"   group by car_comp_id "+
				" ) a,\n"+ 
//				" ( select car_comp_id, count(*) su1 from ("+sub_query+") where init_reg_dt='2000' group by car_comp_id ) b,\n"+ 
//				" ( select car_comp_id, count(*) su2 from ("+sub_query+") where init_reg_dt='2001' group by car_comp_id ) c,\n"+ 
//				" ( select car_comp_id, count(*) su3 from ("+sub_query+") where init_reg_dt='2002' group by car_comp_id ) d,\n"+ 
//				" ( select car_comp_id, count(*) su4 from ("+sub_query+") where init_reg_dt='2003' group by car_comp_id ) e,\n"+ 
//				" ( select car_comp_id, count(*) su5 from ("+sub_query+") where init_reg_dt='2004' group by car_comp_id ) f,\n"+ 
//				" ( select car_comp_id, count(*) su6 from ("+sub_query+") where init_reg_dt='2005' group by car_comp_id ) h,\n"+ 
//				" ( select car_comp_id, count(*) su7 from ("+sub_query+") where init_reg_dt='2006' group by car_comp_id ) i,\n"+ 
//				" ( select car_comp_id, count(*) su8 from ("+sub_query+") where init_reg_dt='2007' group by car_comp_id ) j,\n"+ 
				" ( select car_comp_id, count(*) car_su from ("+sub_query2+") group by car_comp_id ) g,\n"+ 
				" code n\n"+ 
				" where \n"+ 
//				" a.car_comp_id=b.car_comp_id(+) and a.car_comp_id=c.car_comp_id(+) and a.car_comp_id=d.car_comp_id(+) and a.car_comp_id=e.car_comp_id(+) and a.car_comp_id=f.car_comp_id(+) and a.car_comp_id=h.car_comp_id(+) and a.car_comp_id=g.car_comp_id(+) and a.car_comp_id=i.car_comp_id(+) and "+
				" a.car_comp_id=g.car_comp_id(+)\n"+ 
				" and n.c_st='0001' and n.code<>'0000' and a.car_comp_id=n.code "+
				" order by a.tot_su desc";


		try {

         
	//		System.out.println ("query=" + query );
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
          
				System.out.println("[AccidDatabase:getAccidStat01]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고현황-제조사/연식별-사고대수만
	public Hashtable getAccidStat01(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String car_comp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";
		String sub_query = "";

		sub_query = " select  /*+  merge(b) */ cn.car_comp_id, substr(c.init_reg_dt,1,4) init_reg_dt \n"+
					" from accident a, cont_n_view b, car_reg c,  car_etc g, car_nm cn\n"+
					" where cn.car_comp_id='"+car_comp_id+"' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
					"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                    "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";
                       			
		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" a.car_comp_id, a.tot_su, n.nm,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, nvl(h.su6,0) su6, nvl(i.su7,0) su7, nvl(j.su8,0) su8\n"+ 
				" from\n"+ 
				" ( select car_comp_id, count(0) tot_su from ("+sub_query+") group by car_comp_id) a,\n"+ 
				" ( select car_comp_id, count(0) su1 from ("+sub_query+") where init_reg_dt='2000' group by car_comp_id ) b,\n"+ 
				" ( select car_comp_id, count(0) su2 from ("+sub_query+") where init_reg_dt='2001' group by car_comp_id ) c,\n"+ 
				" ( select car_comp_id, count(0) su3 from ("+sub_query+") where init_reg_dt='2002' group by car_comp_id ) d,\n"+ 
				" ( select car_comp_id, count(0) su4 from ("+sub_query+") where init_reg_dt='2003' group by car_comp_id ) e,\n"+ 
				" ( select car_comp_id, count(0) su5 from ("+sub_query+") where init_reg_dt='2004' group by car_comp_id ) f,\n"+ 
				" ( select car_comp_id, count(0) su6 from ("+sub_query+") where init_reg_dt='2005' group by car_comp_id ) h,\n"+ 
				" ( select car_comp_id, count(0) su7 from ("+sub_query+") where init_reg_dt='2006' group by car_comp_id ) i,\n"+ 
				" ( select car_comp_id, count(0) su8 from ("+sub_query+") where init_reg_dt='2007' group by car_comp_id ) j,\n"+ 
				" code n\n"+ 
				" where \n"+ 
				" a.car_comp_id=b.car_comp_id(+) and a.car_comp_id=c.car_comp_id(+) and a.car_comp_id=d.car_comp_id(+) and a.car_comp_id=e.car_comp_id(+) and a.car_comp_id=f.car_comp_id(+) and a.car_comp_id=h.car_comp_id(+) and a.car_comp_id=i.car_comp_id(+) and a.car_comp_id=j.car_comp_id(+)\n"+ 
				" and n.c_st='0001' and n.code<>'0000' and a.car_comp_id=n.code "+
				" order by a.tot_su desc";


		try {

         
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
           
			 System.out.println("[AccidDatabase:getAccidStat01_in]="+se);
			
              throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }


	//사고현황-차종별
	public Vector getAccidStat02(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select  /*+  merge(b) */ cn.car_comp_id, cn.car_cd\n"+
					" from accident a, cont_n_view b, car_reg c,  car_etc g, car_nm cn\n"+
					" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
					"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                    "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";                    			
				
		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.car_comp_id, a.car_cd, a.tot_su, n.car_nm\n"+  
				" from\n"+ 
				" ( select car_comp_id, car_cd, count(*) tot_su from ("+sub_query+") group by car_comp_id, car_cd) a,\n"+ 
				" car_mng n\n"+ 
				" where \n"+ 
				" a.car_comp_id=n.car_comp_id and a.car_cd=n.code"+
				" order by a.tot_su desc";

		try {

          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           		System.out.println("[AccidDatabase:getAccidStat02]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고현황-차종별-제조사별
	public Vector getAccidStat02(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String car_comp_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String sub_query = "";

		sub_query = " select  /*+  merge(b) */ cn.car_comp_id, cn.car_cd\n"+
					" from accident a, cont_n_view b,  car_reg c,  car_etc g, car_nm cn\n"+
					" where c.car_comp_id='"+car_comp_id+"' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\n"+
					"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                    "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) ";                 
				

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" a.car_comp_id, a.car_cd, a.tot_su, n.car_nm\n"+  
				" from\n"+ 
				" ( select car_comp_id, car_cd, count(0) tot_su from ("+sub_query+") group by car_comp_id, car_cd) a,\n"+ 
				" car_mng n\n"+ 
				" where \n"+ 
				" a.car_comp_id=n.car_comp_id and a.car_cd=n.code"+
				" order by a.tot_su desc";

		try {

        
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
          
				System.out.println("[AccidDatabase:getAccidStat02_in]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


	//사고현황-사고유형별
	public Hashtable getAccidStat03(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String sub_query = "";
		String query = "";

		sub_query = " select  /*+  merge(b) */ a.accid_st, a.our_dam_st, a.accid_type"+
					" from accident a, cont_n_view b, car_reg c \n"+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = c.car_mng_id \n";

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8,\n"+ 
				" nvl(j.su9,0) su9, nvl(k.su10,0) su10, nvl(l.su11,0) su11, nvl(m.su12,0) su12\n"+ 
				" from\n"+ 
				" ( select count(*) tot_su from ("+sub_query+")) a,\n"+ 
				" ( select count(*) su1 from ("+sub_query+") where accid_st='1') b,\n"+ 
				" ( select count(*) su2 from ("+sub_query+") where accid_st='2') c,\n"+ 
				" ( select count(*) su3 from ("+sub_query+") where accid_st='3') d,\n"+ 
				" ( select count(*) su4 from ("+sub_query+") where accid_st='5') e,\n"+ 
				" ( select count(*) su5 from ("+sub_query+") where accid_st='4') f,\n"+ 
				" ( select count(*) su6 from ("+sub_query+") where our_dam_st='1') g,\n"+ 
				" ( select count(*) su7 from ("+sub_query+") where our_dam_st='2') h,\n"+ 
				" ( select count(*) su8 from ("+sub_query+") where our_dam_st='3') i,\n"+ 
				" ( select count(*) su9 from ("+sub_query+") where accid_type='1') j,\n"+ 
				" ( select count(*) su10 from ("+sub_query+") where accid_type='2') k,\n"+ 
				" ( select count(*) su11 from ("+sub_query+") where accid_type='3') l,\n"+ 
				" ( select count(*) su12 from ("+sub_query+") where accid_type='4') m\n";

		try {

          

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
         
				System.out.println("[AccidDatabase:getAccidStat03]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
           
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고현황-월별
	public Hashtable getAccidStat04(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String sub_query = "";
		String query = "";

		sub_query = " select  /*+  merge(b) */ substr(a.accid_dt,5,2) accid_dt, a.accid_st, a.our_dam_st, a.accid_type"+
					" from accident a, cont_n_view b, car_reg c"+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = c.car_mng_id \n";

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 


		query = " select\n"+ 
				" a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8,\n"+ 
				" nvl(j.su9,0) su9, nvl(k.su10,0) su10, nvl(l.su11,0) su11, nvl(m.su12,0) su12\n"+ 
				" from\n"+ 
				" ( select count(*) tot_su from ("+sub_query+")) a,\n"+ 
				" ( select count(*) su1 from ("+sub_query+") where accid_dt='01') b,\n"+ 
				" ( select count(*) su2 from ("+sub_query+") where accid_dt='02') c,\n"+ 
				" ( select count(*) su3 from ("+sub_query+") where accid_dt='03') d,\n"+ 
				" ( select count(*) su4 from ("+sub_query+") where accid_dt='04') e,\n"+ 
				" ( select count(*) su5 from ("+sub_query+") where accid_dt='05') f,\n"+ 
				" ( select count(*) su6 from ("+sub_query+") where accid_dt='06') g,\n"+ 
				" ( select count(*) su7 from ("+sub_query+") where accid_dt='07') h,\n"+ 
				" ( select count(*) su8 from ("+sub_query+") where accid_dt='08') i,\n"+ 
				" ( select count(*) su9 from ("+sub_query+") where accid_dt='09') j,\n"+ 
				" ( select count(*) su10 from ("+sub_query+") where accid_dt='10') k,\n"+ 
				" ( select count(*) su11 from ("+sub_query+") where accid_dt='11') l,\n"+ 
				" ( select count(*) su12 from ("+sub_query+") where accid_dt='12') m\n";

		try {

          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidStat04]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고현황-요일별
	public Hashtable getAccidStat05(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String sub_query = "";
		String query = "";

		sub_query = " select  /*+  merge(b) */ to_char(to_date(substr(accid_dt,1,8),'YYYYMMDD'), 'DY') day"+
					" from accident a, cont_n_view b, car_reg c"+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = c.car_mng_id \n";

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7\n"+ 
				" from\n"+ 
				" ( select count(0) tot_su from ("+sub_query+")) a,\n"+ 
				" ( select count(0) su1 from ("+sub_query+") where day='월') b,\n"+ 
				" ( select count(0) su2 from ("+sub_query+") where day='화') c,\n"+ 
				" ( select count(0) su3 from ("+sub_query+") where day='수') d,\n"+ 
				" ( select count(0) su4 from ("+sub_query+") where day='목') e,\n"+ 
				" ( select count(0) su5 from ("+sub_query+") where day='금') f,\n"+ 
				" ( select count(0) su6 from ("+sub_query+") where day='토') g,\n"+ 
				" ( select count(0) su7 from ("+sub_query+") where day='일') h\n";

		try {

         

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
           
				System.out.println("[AccidDatabase:getAccidStat05]="+se);
			     throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고현황-요일별
	public Hashtable getAccidStat06(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String sub_query = "";
		String query = "";

		sub_query = " select  /*+  merge(b) */ accid_type_sub"+
					" from accident a, cont_n_view b, car_reg c "+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id  = c.car_mng_id \n";

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7, nvl(i.su8,0) su8\n"+ 
				" from\n"+ 
				" ( select count(*) tot_su from ("+sub_query+")) a,\n"+ 
				" ( select count(*) su1 from ("+sub_query+") where accid_type_sub='1') b,\n"+ 
				" ( select count(*) su2 from ("+sub_query+") where accid_type_sub='2') c,\n"+ 
				" ( select count(*) su3 from ("+sub_query+") where accid_type_sub='3') d,\n"+ 
				" ( select count(*) su4 from ("+sub_query+") where accid_type_sub='4') e,\n"+ 
				" ( select count(*) su5 from ("+sub_query+") where accid_type_sub='5') f,\n"+ 
				" ( select count(*) su6 from ("+sub_query+") where accid_type_sub='6') g,\n"+ 
				" ( select count(*) su7 from ("+sub_query+") where accid_type_sub='7') h,\n"+
				" ( select count(*) su8 from ("+sub_query+") where accid_type_sub='8') i\n";

		try {

           
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
          
				System.out.println("[AccidDatabase:getAccidStat06]="+se);
			    throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고현황-요일별
	public Hashtable getAccidStat07(String br_id, String gubun1, String gubun2, String gubun3, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String sub_query = "";
		String query = "";

		sub_query = " select  /*+  merge(b) */ a.weather, a.road_stat, a.road_stat2"+
					" from accident a, cont_n_view b, car_reg c "+
					" where a.rent_mng_id=a.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and a.car_mng_id = c.car_mng_id \n";

		if(gubun1.equals("1"))		sub_query += " and c.car_use='1'"; 
		if(gubun1.equals("2"))		sub_query += " and c.car_use='2'";

		if(gubun2.equals("1"))		sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))	sub_query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
		else if(gubun2.equals("4"))	sub_query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	sub_query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

		if(!brch_id.equals("S1") && !brch_id.equals(""))	sub_query += " and b.brch_id = '"+brch_id+"'"; 
		if(brch_id.equals("S1"))							sub_query += " and b.brch_id in ('S1','K1')"; 
		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id = '"+br_id+"'"; 

		query = " select\n"+ 
				" a.tot_su,\n"+  
				" nvl(b.su1,0) su1, nvl(c.su2,0) su2, nvl(d.su3,0) su3, nvl(e.su4,0) su4, nvl(f.su5,0) su5, \n"+ 
				" nvl(g.su6,0) su6, nvl(h.su7,0) su7\n"+ 
				" from\n"+ 
				" ( select count(0) tot_su from ("+sub_query+")) a,\n"+ 
				" ( select count(0) su1 from ("+sub_query+") where road_stat='1') b,\n"+ 
				" ( select count(0) su2 from ("+sub_query+") where road_stat='2') c,\n"+ 
				" ( select count(0) su3 from ("+sub_query+") where weather='1') d,\n"+ 
				" ( select count(0) su4 from ("+sub_query+") where weather='2') e,\n"+ 
				" ( select count(0) su5 from ("+sub_query+") where weather='3') f,\n"+ 
				" ( select count(0) su6 from ("+sub_query+") where weather='4') g,\n"+ 
				" ( select count(0) su7 from ("+sub_query+") where weather='5') h\n";

		try {

        

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
         
				System.out.println("[AccidDatabase:getAccidStat07]="+se);
			 
              throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

    /**
     * 사고기록 개별조회 : car_accid_all_u.jsp
     */
    public void getMoveDataOtAccid() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs2 = null;
		PreparedStatement pstmt3 = null;
        String query = "";

		String query1 = "";
        String query2 = "";
        int seq_no = 0;
        int count = 0;
        
        query = " select * from accident where ot_driver is null and ot_ins is not null";
        
		query2= " select nvl(max(seq_no)+1,1) from ot_accid where car_mng_id=? and accid_id=?";

		query1 = " INSERT INTO ot_accid("+
						" CAR_MNG_ID, ACCID_ID, SEQ_NO, OT_CAR_NO, OT_CAR_NM, OT_DRIVER, OT_TEL, OT_M_TEL,"+
						" OT_INS, OT_NUM, OT_INS_NM, OT_INS_TEL, OT_INS_M_TEL,"+
						" OT_SSN, OT_LIC_KD, OT_LIC_NO, OT_TEL2, OT_DAM_ST, OT_FAULT_PER,"+
						" HUM_NM, HUM_TEL, HUM_M_TEL, MAT_NM, MAT_TEL, MAT_M_TEL,"+
						" SERV_DT, OFF_NM, OFF_TEL, OFF_FAX, SERV_AMT, SERV_CONT, SERV_NM,"+
						" REG_DT, REG_ID"+
						" )\n"+
						" values(?,?,?,?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,?,  ?,?,?,?,?,?,  replace(?,'-',''),?,?,?,?,?,?,  to_char(sysdate,'YYYYMMDD'),?)\n";


        try{

			con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();

			pstmt2 = con.prepareStatement(query2);

			pstmt3 = con.prepareStatement(query1);


            while (rs.next()){

		        OtAccidBean bean = new OtAccidBean();

			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));
				bean.setAccid_id(rs.getString("ACCID_ID"));
				bean.setSeq_no(1);
				bean.setOt_car_no(rs.getString("OT_CAR_NO"));
				bean.setOt_car_nm(rs.getString("OT_CAR_NM"));
				bean.setOt_driver(rs.getString("OT_DRIVER"));
				bean.setOt_tel(rs.getString("OT_TEL"));
				bean.setOt_m_tel(rs.getString("OT_M_TEL"));
				bean.setOt_ins(rs.getString("OT_INS"));
				bean.setOt_num(rs.getString("OT_NUM"));
				bean.setOt_ins_nm(rs.getString("OT_INS_NM"));
				bean.setOt_ins_tel(rs.getString("OT_INS_TEL"));
				bean.setOt_ins_m_tel(rs.getString("OT_INS_M_TEL"));
				bean.setOt_ssn(rs.getString("OT_SSN"));
				bean.setOt_lic_kd(rs.getString("OT_LIC_KD"));
				bean.setOt_lic_no(rs.getString("OT_LIC_NO"));
				bean.setOt_tel2(rs.getString("OT_TEL2"));
				bean.setOt_dam_st(rs.getString("OT_DAM_ST"));
				bean.setOt_fault_per(100-rs.getInt("OUR_FAULT_PER"));
				bean.setHum_nm(rs.getString("HUM_NM"));
				bean.setHum_tel(rs.getString("HUM_TEL"));
				bean.setMat_nm(rs.getString("MAT_NM"));
				bean.setMat_tel(rs.getString("MAT_TEL"));
				bean.setReg_dt(rs.getString("REG_DT"));
				bean.setReg_id(rs.getString("REG_ID"));
				bean.setUpdate_dt(rs.getString("UPDATE_DT"));
				bean.setUpdate_id(rs.getString("UPDATE_ID"));


				pstmt2.clearParameters();
				pstmt2.setString(1, bean.getCar_mng_id().trim());
				pstmt2.setString(2, bean.getAccid_id().trim());
				rs2 = pstmt2.executeQuery();
				if(rs2.next()){
					seq_no = rs2.getInt(1);
				}
				rs2.close();

				pstmt3.clearParameters();
				pstmt3.setString(1, bean.getCar_mng_id().trim());
				pstmt3.setString(2, bean.getAccid_id().trim());
				pstmt3.setInt   (3, seq_no);
				pstmt3.setString(4, bean.getOt_car_no().trim());
				pstmt3.setString(5, bean.getOt_car_nm().trim());
				pstmt3.setString(6, bean.getOt_driver().trim());
				pstmt3.setString(7, bean.getOt_tel().trim());
				pstmt3.setString(8, bean.getOt_m_tel().trim());
				pstmt3.setString(9, bean.getOt_ins().trim());
				pstmt3.setString(10, bean.getOt_num().trim());
				pstmt3.setString(11, bean.getOt_ins_nm().trim());
				pstmt3.setString(12, bean.getOt_ins_tel().trim());
				pstmt3.setString(13, bean.getOt_ins_m_tel().trim());
				pstmt3.setString(14, bean.getOt_ssn().trim());
				pstmt3.setString(15, bean.getOt_lic_kd().trim());
				pstmt3.setString(16, bean.getOt_lic_no().trim());
				pstmt3.setString(17, bean.getOt_tel2().trim());
				pstmt3.setString(18, bean.getOt_dam_st().trim());
				pstmt3.setInt   (19, bean.getOt_fault_per());
				pstmt3.setString(20, bean.getHum_nm().trim());
				pstmt3.setString(21, bean.getHum_tel().trim());
				pstmt3.setString(22, bean.getHum_m_tel().trim());
				pstmt3.setString(23, bean.getMat_nm().trim());
				pstmt3.setString(24, bean.getMat_tel().trim());
				pstmt3.setString(25, bean.getMat_m_tel().trim());
				pstmt3.setString(26, bean.getServ_dt().trim());
				pstmt3.setString(27, bean.getOff_nm().trim());
				pstmt3.setString(28, bean.getOff_tel().trim());
				pstmt3.setString(29, bean.getOff_fax().trim());
				pstmt3.setInt   (30, bean.getServ_amt());
				pstmt3.setString(31, bean.getServ_cont().trim());
				pstmt3.setString(32, bean.getServ_nm().trim());
				pstmt3.setString(33, bean.getReg_id().trim());
				count = pstmt3.executeUpdate();            

			}            
            rs.close();
            pstmt.close();
			pstmt2.close();
			pstmt3.close(); 

			con.commit();

        }catch(SQLException se){
			try{
				System.out.println("[AccidDatabase:getMoveDataOtAccid]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
            throw new DatabaseException("exception");
        }finally{
            try{
				con.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
				if(rs2 != null )	rs2.close();
                if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

    /**
     * 사고규모-인적사고 체크 수정
     */
    public void getMoveDataOneAccid() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;

        query = " select * from one_accid";
        
        try{

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            while (rs.next()){

				updateOneAccidSt(rs.getString("CAR_MNG_ID"), rs.getString("ACCID_ID"), rs.getString("ONE_ACCID_ST"));

			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getMoveDataOtAccid]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

    /**
     * 사고규모-인적사고 수정
     */
    public int updateOneAccidSt(String c_id, String accid_id, String one_accid_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update accident set";

		if(one_accid_st.equals("1"))	query += " dam_type3='Y'";
		else							query += " dam_type1='Y'";

		query += " where car_mng_id='"+c_id+"' and accid_id='"+accid_id+"'";

				
       try{
            con.setAutoCommit(false);           			
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateOneAccidSt]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 사고규모-물적-대물사고 체크 수정
     */
    public void getMoveDataOtAccidSt() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;

        query = " select * from ot_accid where off_nm is not null";
        
        try{

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            while (rs.next()){

				updateOtAccidSt(rs.getString("CAR_MNG_ID"), rs.getString("ACCID_ID"));

			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getMoveDataOtAccid]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

    /**
     * 사고규모-물적-대물사고 수정
     */
    public int updateOtAccidSt(String c_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update accident set dam_type2='Y'"+
				" where car_mng_id='"+c_id+"' and accid_id='"+accid_id+"'";

				
       try{
            con.setAutoCommit(false);           			
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateOneAccidSt]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 사고규모-물적-자차사고 체크 수정
     */
    public void getMoveDataServiceSt() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;

        query = " select b.car_mng_id, b.accid_id from service a, accident b where a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id";

        try{

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            while (rs.next()){

				count++;

				String car_mng_id = rs.getString("CAR_MNG_ID");
				String accid_id2 = rs.getString("ACCID_ID");

				updateServiceSt(car_mng_id, accid_id2);

			}
            
            rs.close();
            pstmt.close();            

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getMoveDataOtAccid]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

    /**
     * 사고규모-물적-자차사고 수정
     */
    public int updateServiceSt(String c_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update accident set dam_type4='Y'"+
				" where car_mng_id='"+c_id+"' and accid_id='"+accid_id+"'";

				
       try{
            con.setAutoCommit(false);           			
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateOneAccidSt]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 사고규모-자차-종결처리 조회
     */
    public void getMoveDataSettle() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;

		//면책금있을때
        query = " select a.car_mng_id, a.accid_id, b.cust_pay_dt dt from accident a, service b"+
				" where a.dam_type4='Y' and a.settle_dt is null and b.tot_amt=0 and b.cust_amt>0 and b.cust_pay_dt is not null"+
				" and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and nvl(a.settle_st,'0')='0' ";

		//면책금없을때-지출완료-일자비교
//        query = " select a.car_mng_id, a.accid_id, b.set_dt dt from accident a, service b"+
//				" where a.dam_type4='Y' and a.settle_dt is null and b.cust_amt=0 and b.set_dt is not null"+
//				" and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.serv_dt<b.set_dt";

		//면책금없을때-지출완료-일자비교
//        query = " select a.car_mng_id, a.accid_id, b.set_dt dt from accident a, service b"+
//				" where a.dam_type4='Y' and a.settle_dt is null and b.cust_amt=0 and b.set_dt is not null"+
//				" and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.serv_dt>=b.set_dt";

		//면책금없을때-정비비없을때
//        query = " select a.car_mng_id, a.accid_id, b.serv_dt dt from accident a, service b"+
//				" where a.dam_type4='Y' and a.tot_amt=0 and b.set_dt is null"+
//				" and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id and b.serv_dt is not null";
        
        try{

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            while (rs.next()){

				count = updateSettle4(rs.getString("CAR_MNG_ID"), rs.getString("ACCID_ID"), rs.getString("DT"));

			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getMoveDataOtAccid]\n"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
    }

    /**
     * 사고규모-자차-종결처리
     */
    public int updateSettle4(String c_id, String accid_id, String dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update accident set settle_st4='1', settle_dt4='"+dt+"', settle_id4=reg_id"+
				" where car_mng_id='"+c_id+"' and accid_id='"+accid_id+"'";

				
       try{
            con.setAutoCommit(false);           			
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateOneAccidSt]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 서비스조회
     */
   
    public ServiceBean [] getServiceList( String car_mng_id, String accid_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = "select"+
				" a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD,"+
				" a.off_id OFF_ID, b.off_nm OFF_NM, a.serv_dt, a.serv_st SERV_ST,"+
				" a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT,"+
				" a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT, "+
				" nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT,"+
				" nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT,"+
				" a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT,"+
				" nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT,"+
				" nvl2(a.cust_req_dt,substr(a.cust_req_dt,1,4)||'-'||substr(a.cust_req_dt,5,2)||'-'||substr(a.cust_req_dt,7,2),'') CUST_REQ_DT,"+
				" nvl2(a.cust_pay_dt,substr(a.cust_pay_dt,1,4)||'-'||substr(a.cust_pay_dt,5,2)||'-'||substr(a.cust_pay_dt,7,2),'') CUST_PAY_DT,"+
				" a.cust_amt CUST_AMT, decode(a.cust_pay_dt,'','',se.pay_amt) ext_amt, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, a.serv_jc SERV_JC,"+
				" a.cust_serv_dt CUST_SERV_DT, a.next_serv_dt NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK,\n"+
				" a.ipgodt IPGODT, a.chulgodt CHULGODT, b.OFF_TEL, b.OFF_FAX, a.scan_file, a.reg_id, a.cls_amt, a.r_labor, a.r_amt, a.r_j_amt, " +
				" a.cust_s_amt, a.cust_v_amt, a.cls_s_amt, a.cls_v_amt, a.ext_cau, a.sac_yn, a.sac_dt, a.ext_amt as dly_amt, a.reg_dt, a.no_dft_yn, a.no_dft_cau , a.file_path" +
				" from service a, serv_off b, ( select rent_mng_id, rent_l_cd, ext_id, sum(ext_pay_amt) pay_amt from scd_ext where ext_st = '3' and ext_pay_amt > 0 group by rent_mng_id, rent_l_cd, ext_id) se  \n"
				+ " where a.car_mng_id=? and a.accid_id=?  \n"
				+ " and a.rent_mng_id = se.rent_mng_id(+) and a.rent_l_cd = se.rent_l_cd(+)  and a.serv_id = se.ext_id(+)	\n"
				+ " and a.off_id=b.off_id(+) order by serv_dt,  serv_id desc\n"; 

		
        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){

	            ServiceBean bean = new ServiceBean();
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					//자동차관리번호
				bean.setServ_id(rs.getString("SERV_ID")); 
				bean.setAccid_id(rs.getString("ACCID_ID")); 
				bean.setRent_mng_id(rs.getString("RENT_MNG_ID")); 
				bean.setRent_l_cd(rs.getString("RENT_L_CD")); 
				bean.setOff_id(rs.getString("OFF_ID"));
				bean.setOff_nm(rs.getString("OFF_NM")); 
				bean.setOff_tel(rs.getString("OFF_TEL")); 
				bean.setOff_fax(rs.getString("OFF_FAX")); 
				bean.setServ_dt(rs.getString("SERV_DT")); 
				bean.setServ_st(rs.getString("SERV_ST")); 
				bean.setChecker(rs.getString("CHECKER")); 
				bean.setTot_dist(rs.getString("TOT_DIST")); 
				bean.setRep_nm(rs.getString("REP_NM")); 
				bean.setRep_tel(rs.getString("REP_TEL")); 
				bean.setRep_m_tel(rs.getString("REP_M_TEL")); 
				bean.setRep_amt(rs.getInt("REP_AMT")); 
				bean.setSup_amt(rs.getInt("SUP_AMT")); 
				bean.setAdd_amt(rs.getInt("ADD_AMT")); 
				bean.setDc(rs.getInt("DC")); 
				bean.setTot_amt(rs.getInt("TOT_AMT")); 
				bean.setSup_dt(rs.getString("SUP_DT")); 
				bean.setSet_dt(rs.getString("SET_DT")); 
				bean.setBank(rs.getString("BANK")); 
				bean.setAcc_no(rs.getString("ACC_NO")); 
				bean.setAcc_nm(rs.getString("ACC_NM")); 
				bean.setRep_item(rs.getString("REP_ITEM")); 
				bean.setRep_cont(rs.getString("REP_CONT")); 
				bean.setCust_plan_dt(rs.getString("CUST_PLAN_DT")); 
				bean.setCust_req_dt(rs.getString("CUST_REQ_DT")); 
				bean.setCust_pay_dt(rs.getString("CUST_PAY_DT")); 
				bean.setCust_amt(rs.getInt("CUST_AMT")); 
				bean.setExt_amt(rs.getInt("EXT_AMT")); 
				bean.setCust_agnt(rs.getString("CUST_AGNT"));
				bean.setAccid_dt(rs.getString("ACCID_DT"));
				bean.setBill_doc_yn(rs.getString("BILL_DOC_YN"));
				bean.setBill_mon(rs.getString("BILL_MON"));
				bean.setServ_jc(rs.getString("SERV_JC"));
				bean.setCust_serv_dt(rs.getString("CUST_SERV_DT"));
				bean.setNext_serv_dt(rs.getString("NEXT_SERV_DT"));
				bean.setNext_rep_cont(rs.getString("NEXT_REP_CONT"));
				bean.setSpd_chk(rs.getString("SPDCHK"));  
				bean.setIpgodt(rs.getString("IPGODT"));  
				bean.setChulgodt(rs.getString("CHULGODT"));  
				bean.setScan_file(rs.getString("SCAN_FILE"));  
				bean.setReg_id(rs.getString("REG_ID")); 
				bean.setReg_dt(rs.getString("REG_DT")); 
				bean.setCls_amt(rs.getInt("CLS_AMT"));  
				bean.setDly_amt(rs.getInt("DLY_AMT"));  
				
				bean.setR_labor(rs.getInt("R_LABOR"));  
				bean.setR_amt(rs.getInt("R_AMT"));  
				bean.setR_j_amt(rs.getInt("R_J_AMT"));  
				
				bean.setCust_s_amt(rs.getInt("cust_s_amt"));  	
				bean.setCust_v_amt(rs.getInt("cust_v_amt"));  	
				bean.setCls_s_amt(rs.getInt("cls_s_amt"));  	
				bean.setCls_v_amt(rs.getInt("cls_v_amt"));  
				bean.setExt_cau(rs.getString("ext_cau"));	
				bean.setSac_yn(rs.getString("sac_yn"));	
				bean.setSac_dt(rs.getString("sac_dt"));				
				bean.setNo_dft_yn(rs.getString("no_dft_yn"));	
				bean.setNo_dft_cau(rs.getString("no_dft_cau"));				
								
				bean.setFile_path(rs.getString("file_path"));								
				col.add(bean);
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AccidDatabase:getServiceList]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (ServiceBean[])col.toArray(new ServiceBean[0]);
    }


    /**
     * 서비스조회
     */
   
    public ServiceBean [] getServiceList2( String car_mng_id, String accid_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
		query = "select"+
				" a.car_mng_id CAR_MNG_ID, a.serv_id SERV_ID, a.accid_id ACCID_ID, a.rent_mng_id RENT_MNG_ID, a.rent_l_cd RENT_L_CD,"+
				" a.off_id OFF_ID, nvl(b.off_nm, '') OFF_NM, a.serv_dt SERV_DT, a.serv_st SERV_ST,"+
				" a.checker CHECKER, a.tot_dist TOT_DIST, a.rep_nm REP_NM, a.rep_tel REP_TEL, a.rep_m_tel REP_M_TEL, a.rep_amt REP_AMT,"+
				" a.sup_amt SUP_AMT, a.add_amt ADD_AMT, a.dc DC, a.tot_amt TOT_AMT,"+
				" nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT,"+
				" nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT,"+
				" a.bank BANK, a.acc_no ACC_NO, a.acc_nm ACC_NM, a.rep_item REP_ITEM, a.rep_cont REP_CONT,"+
				" nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT,"+
				" a.cust_amt CUST_AMT, a.cust_agnt CUST_AGNT, a.accid_dt ACCID_DT, a.bill_doc_yn, a.bill_mon, nvl(a.serv_jc,'N') SERV_JC,"+
				" a.cust_serv_dt CUST_SERV_DT, a.next_serv_dt NEXT_SERV_DT, a.next_rep_cont NEXT_REP_CONT, a.spdchk SPDCHK,\n"+
				" a.ipgodt IPGODT, a.chulgodt CHULGODT, b.OFF_TEL, b.OFF_FAX, a.reg_id, a.r_labor, a.r_amt, a.r_j_amt, \n"+
				" a.cust_s_amt, a.cust_v_amt, a.cls_s_amt, a.cls_v_amt, a.ext_cau, a.sac_yn, a.sac_dt , a.jung_st" +
				" from service a, serv_off b\n"
				+ " where a.car_mng_id=? and a.accid_id=?\n"
				+ " and a.off_id=b.off_id(+) order by serv_dt desc \n"; 

        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		
    		rs = pstmt.executeQuery();

            while(rs.next()){

	            ServiceBean bean = new ServiceBean();
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					//자동차관리번호
				bean.setServ_id(rs.getString("SERV_ID")); 
				bean.setAccid_id(rs.getString("ACCID_ID")); 
				bean.setRent_mng_id(rs.getString("RENT_MNG_ID")); 
				bean.setRent_l_cd(rs.getString("RENT_L_CD")); 
				bean.setOff_id(rs.getString("OFF_ID"));
				bean.setOff_nm(rs.getString("OFF_NM")); 
				bean.setOff_tel(rs.getString("OFF_TEL")); 
				bean.setOff_fax(rs.getString("OFF_FAX")); 
				bean.setServ_dt(rs.getString("SERV_DT")); 
				bean.setServ_st(rs.getString("SERV_ST")); 
				bean.setChecker(rs.getString("CHECKER")); 
				bean.setTot_dist(rs.getString("TOT_DIST")); 
				bean.setRep_nm(rs.getString("REP_NM")); 
				bean.setRep_tel(rs.getString("REP_TEL")); 
				bean.setRep_m_tel(rs.getString("REP_M_TEL")); 
				bean.setRep_amt(rs.getInt("REP_AMT")); 
				bean.setSup_amt(rs.getInt("SUP_AMT")); 
				bean.setAdd_amt(rs.getInt("ADD_AMT")); 
				bean.setDc(rs.getInt("DC")); 
				bean.setTot_amt(rs.getInt("TOT_AMT")); 
				bean.setSup_dt(rs.getString("SUP_DT")); 
				bean.setSet_dt(rs.getString("SET_DT")); 
				bean.setBank(rs.getString("BANK")); 
				bean.setAcc_no(rs.getString("ACC_NO")); 
				bean.setAcc_nm(rs.getString("ACC_NM")); 
				bean.setRep_item(rs.getString("REP_ITEM")); 
				bean.setRep_cont(rs.getString("REP_CONT")); 
				bean.setCust_plan_dt(rs.getString("CUST_PLAN_DT")); 
				bean.setCust_amt(rs.getInt("CUST_AMT")); 
				bean.setCust_agnt(rs.getString("CUST_AGNT"));
				bean.setAccid_dt(rs.getString("ACCID_DT"));
				bean.setBill_doc_yn(rs.getString("BILL_DOC_YN"));
				bean.setBill_mon(rs.getString("BILL_MON"));
				bean.setServ_jc(rs.getString("SERV_JC"));
				bean.setCust_serv_dt(rs.getString("CUST_SERV_DT"));
				bean.setNext_serv_dt(rs.getString("NEXT_SERV_DT"));
				bean.setNext_rep_cont(rs.getString("NEXT_REP_CONT"));
				bean.setSpd_chk(rs.getString("SPDCHK"));  
				bean.setIpgodt(rs.getString("IPGODT"));  
				bean.setChulgodt(rs.getString("CHULGODT"));  
				bean.setReg_id(rs.getString("REG_ID"));  
				
				bean.setR_labor(rs.getInt("R_LABOR"));  
				bean.setR_amt(rs.getInt("R_AMT"));  
				bean.setR_j_amt(rs.getInt("R_J_AMT"));  
				
				bean.setCust_s_amt(rs.getInt("cust_s_amt"));  	
				bean.setCust_v_amt(rs.getInt("cust_v_amt"));  	
				bean.setCls_s_amt(rs.getInt("cls_s_amt"));  	
				bean.setCls_v_amt(rs.getInt("cls_v_amt"));  
				bean.setExt_cau(rs.getString("ext_cau"));	
				bean.setSac_yn(rs.getString("sac_yn"));	
				bean.setSac_dt(rs.getString("sac_dt"));	
				
				bean.setJung_st(rs.getString("jung_st"));	
					
				col.add(bean);
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AccidDatabase:getServiceList]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (ServiceBean[])col.toArray(new ServiceBean[0]);
    }
	
	
	/**
     * 서비스 개별조회 : car_accid_all_u.jsp
     */
    public ServiceBean getService( String car_mng_id, String accid_id ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		ServiceBean sb = new ServiceBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select"+
				" a.car_mng_id, a.serv_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, a.off_id, b.off_nm, b.off_tel, b.off_fax,"+
				" nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') SERV_DT,"+
				" a.serv_st, a.checker, a.tot_dist, a.rep_nm, a.rep_tel, a.rep_m_tel, a.rep_amt, a.sup_amt,"+
				" a.add_amt, a.dc, a.tot_amt, nvl2(a.sup_dt,substr(a.sup_dt,1,4)||'-'||substr(a.sup_dt,5,2)||'-'||substr(a.sup_dt,7,2),'') SUP_DT,"+
				" nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') SET_DT,"+
				" a.bank, a.acc_no, a.acc_nm, a.rep_item, a.rep_cont,"+
				" nvl2(a.cust_plan_dt,substr(a.cust_plan_dt,1,4)||'-'||substr(a.cust_plan_dt,5,2)||'-'||substr(a.cust_plan_dt,7,2),'') CUST_PLAN_DT,"+
				" a.cust_amt, a.cust_agnt, a.accid_dt, cust_req_dt, cust_pay_dt, a.reg_dt, a.reg_id, update_dt, update_id, scan_file, no_dft_yn, no_dft_cau, bill_doc_yn, bill_mon,\n"+ 
				" a.r_labor, a.r_amt, a.r_j_amt, a.cust_s_amt, a.cust_v_amt, a.cls_s_amt, a.cls_v_amt, a.ext_cau, a.sac_yn, a.sac_dt \n"+ 
				" from service a, serv_off b\n"+
				" where a.car_mng_id='"+car_mng_id+"' and a.accid_id='"+accid_id+"'\n"+
				" and a.off_id=b.off_id order by serv_id asc \n";

        try{

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
            if (rs.next()){
                sb = makeServiceBean(rs);
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getService]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sb;
    }
	/**
     * 서비스
     */    
    private ServiceBean makeServiceBean(ResultSet results) throws DatabaseException {
        try {
            ServiceBean bean = new ServiceBean();
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 					
			bean.setServ_id(results.getString("SERV_ID")); 
			bean.setAccid_id(results.getString("ACCID_ID")); 
			bean.setRent_mng_id(results.getString("RENT_MNG_ID")); 
			bean.setRent_l_cd(results.getString("RENT_L_CD")); 
			bean.setOff_id(results.getString("OFF_ID"));
			bean.setOff_nm(results.getString("OFF_NM")); 
			bean.setServ_dt(results.getString("SERV_DT")); 
			bean.setServ_st(results.getString("SERV_ST")); 
			bean.setChecker(results.getString("CHECKER")); 
			bean.setTot_dist(results.getString("TOT_DIST")); 
			bean.setRep_nm(results.getString("REP_NM")); 
			bean.setRep_tel(results.getString("REP_TEL")); 
			bean.setRep_m_tel(results.getString("REP_M_TEL")); 
			bean.setRep_amt(results.getInt("REP_AMT")); 
			bean.setSup_amt(results.getInt("SUP_AMT")); 
			bean.setAdd_amt(results.getInt("ADD_AMT")); 
			bean.setDc(results.getInt("DC")); 
			bean.setTot_amt(results.getInt("TOT_AMT")); 
			bean.setSup_dt(results.getString("SUP_DT")); 
			bean.setSet_dt(results.getString("SET_DT")); 
			bean.setBank(results.getString("BANK")); 
			bean.setAcc_no(results.getString("ACC_NO")); 
			bean.setAcc_nm(results.getString("ACC_NM")); 
			bean.setRep_item(results.getString("REP_ITEM")); 
			bean.setRep_cont(results.getString("REP_CONT")); 
			bean.setCust_plan_dt(results.getString("CUST_PLAN_DT")); 
			bean.setCust_amt(results.getInt("CUST_AMT")); 
			bean.setCust_agnt(results.getString("CUST_AGNT"));
			bean.setAccid_dt(results.getString("ACCID_DT"));
			//추가
			bean.setOff_tel(results.getString("OFF_TEL"));
			bean.setOff_fax(results.getString("OFF_FAX")); 
			bean.setCust_req_dt(results.getString("CUST_REQ_DT"));
			bean.setCust_pay_dt(results.getString("CUST_PAY_DT"));
			bean.setReg_dt(results.getString("REG_DT"));
			bean.setReg_id(results.getString("REG_ID"));
			bean.setUpdate_dt(results.getString("UPDATE_DT"));
			bean.setUpdate_id(results.getString("UPDATE_ID"));
			bean.setScan_file(results.getString("SCAN_FILE"));
			bean.setNo_dft_yn(results.getString("NO_DFT_YN"));
			bean.setNo_dft_cau(results.getString("NO_DFT_CAU"));
			bean.setBill_doc_yn(results.getString("BILL_DOC_YN"));
			bean.setBill_mon(results.getString("BILL_MON"));
			
			
			bean.setR_labor(results.getInt("R_LABOR"));  
			bean.setR_amt(results.getInt("R_AMT"));  
			bean.setR_j_amt(results.getInt("R_J_AMT"));  
			
			bean.setCust_s_amt(results.getInt("cust_s_amt"));  	
			bean.setCust_v_amt(results.getInt("cust_v_amt"));  	
			bean.setCls_s_amt(results.getInt("cls_s_amt"));  	
			bean.setCls_v_amt(results.getInt("cls_v_amt"));  
			bean.setExt_cau(results.getString("ext_cau"));		
			
			bean.setSac_yn(results.getString("sac_yn"));		
			bean.setSac_dt(results.getString("sac_dt"));				

            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

    /**
     * 마지막 사고코드 조회
     */
    public String getMaxAccid_id(String c_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		String accid_id = "";
        String query = "";

		query = " select max(accid_id) from accident where car_mng_id='"+c_id+"'";

        try{

			pstmt = con.prepareStatement(query);
    		rs = pstmt.executeQuery();
			if(rs.next()){				
				accid_id = rs.getString(1)==null?"":rs.getString(1);
			}
            
            rs.close();
            pstmt.close();            

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getMaxAccid_id]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return accid_id;
    }

    /**
     * 견적서 스캔 업로드
     */
    public int scanUpLoad(String c_id, String accid_id, String serv_id, String filename, String estimate_num) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update service set scan_file='"+filename+"'";

		if(!estimate_num.equals("")) query += ", estimate_num='"+estimate_num+"'";

		query += " where car_mng_id='"+c_id+"' ";

		if(!serv_id.equals(""))		query += " and serv_id='"+serv_id+"'";
		if(!accid_id.equals(""))	query += " and accid_id='"+accid_id+"'";

				
       try{
            con.setAutoCommit(false);           			
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:scanUpLoad]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
     * 사고기록 삭제
     */
    public int deleteAccident(AccidentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		PreparedStatement pstmt6 = null;
		PreparedStatement pstmt7 = null;
        String query = "";
        int f_count = 0;
		int count = 0;
                
		String query1 = " delete from accident  where car_mng_id=? and accid_id=?";
		String query2 = " delete from service   where car_mng_id=? and accid_id=?";
		String query3 = " delete from my_accid  where accid_id=?";
		String query4 = " delete from one_accid where accid_id=?";
		String query5 = " delete from ot_accid  where accid_id=?";
		String query6 = " delete from pic_accid where accid_id=?";
		String query7 = " delete from doc_settle where doc_st='45' and doc_id=?";
    
       try{
            con.setAutoCommit(false);
            			
            pstmt1 = con.prepareStatement(query1);           
          	pstmt1.setString(1, bean.getCar_mng_id().trim());
			pstmt1.setString(2, bean.getAccid_id().trim());
			f_count = pstmt1.executeUpdate();
			pstmt1.close(); 
            
            pstmt2 = con.prepareStatement(query2);           
          	pstmt2.setString(1, bean.getCar_mng_id().trim());
			pstmt2.setString(2, bean.getAccid_id().trim());
			count = pstmt2.executeUpdate();
			pstmt2.close(); 

            pstmt3 = con.prepareStatement(query3);           
			pstmt3.setString(1, bean.getAccid_id().trim());
			count = pstmt3.executeUpdate();
			pstmt3.close(); 

            pstmt4 = con.prepareStatement(query4);           
			pstmt4.setString(1, bean.getAccid_id().trim());			
			count = pstmt4.executeUpdate();
			pstmt4.close(); 

            pstmt5 = con.prepareStatement(query5);           
			pstmt5.setString(1, bean.getAccid_id().trim());			
			count = pstmt5.executeUpdate();
			pstmt5.close(); 

            pstmt6 = con.prepareStatement(query6);           
			pstmt6.setString(1, bean.getAccid_id().trim());			
			count = pstmt6.executeUpdate();
			pstmt6.close(); 

            pstmt7 = con.prepareStatement(query7);           
          	pstmt7.setString(1, bean.getCar_mng_id().trim()+""+bean.getAccid_id().trim());
			f_count = pstmt7.executeUpdate();
			pstmt7.close(); 
            

            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:deleteAccident]\n"+se);
                con.rollback();
				f_count = 0;
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
				if(pstmt2 != null) pstmt2.close();
				if(pstmt3 != null) pstmt3.close();
				if(pstmt4 != null) pstmt4.close();
				if(pstmt5 != null) pstmt5.close();
				if(pstmt6 != null) pstmt6.close();
				if(pstmt7 != null) pstmt7.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return f_count;
    }
    
    //등록전 계약리스트 조회
	public Vector getRentList(String dept_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

			     
		query = " select  /*+  merge(a) */ distinct  a.firm_nm, u.user_nm, u.user_m_tel,  c.con_agnt_email "+
				" from cont_n_view a, users u, client c "+
				" where a.client_id = c.client_id and a.bus_id2 = u.user_id and  c.con_agnt_email is not null and a.use_yn = 'Y' " +
				" and u.dept_id = '"+ dept_id + "'"; 

		try {
         
			pstmt = con.prepareStatement(query);
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
		}catch(SQLException se){
         	  System.out.println("[AccidDatabase:getRentList]="+se);
			  throw new DatabaseException();
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
    
	//사고 차량시세하락손해청구 리스트
	public Vector getAccidS8List2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String search_dt = "";

		query = " select \n"+
				"         a.car_mng_id, a.accid_id, a.accid_st, a.rent_mng_id, a.rent_l_cd, \n"+
				"         b.use_yn, b.client_id, i.firm_nm, i.client_nm, \n"+
				"         f.car_no, f.car_nm, c.car_name, \n"+
				"         k.user_nm as mng_nm, \n"+
				"         j.user_nm as reg_nm, \n"+
				"         a.accid_dt, a.sub_etc, a.settle_st6, decode(a.settle_st,'1','종결','진행') settle_st_nm,  \n"+
				"         b.dlv_dt, \n"+
				"         trunc(months_between(to_date(substr(a.accid_dt,1,8),'YYYYMMDD'), to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'))/12,0)+1 dlv_mon, \n"+
				"         t.amor_car_amt car_amt, \n"+
				"         trunc(t.amor_car_amt*20/100,0) car_amt_20p, \n"+
				"         h.tot_amt, \n"+
				"         decode(trunc(months_between(to_date(substr(a.accid_dt,1,8),'YYYYMMDD'), to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'))/12,0), \n"+
				"                     1, trunc(h.tot_amt*10/100*t.ot_fault_per/100,0), \n"+
				"                     0, trunc(h.tot_amt*15/100*t.ot_fault_per/100,0)) req_est_amt, \n"+
				"         decode('','','미청구') as pay_yn, '' pay_dt, '' req_dt, 0 pay_amt, 0 req_amt, \n"+
				"         decode(a.accid_st,'1','피해','3','쌍방') as accid_st_nm, 100-a.our_fault_per as ot_fault_per, \n"+
				"         t.amor_req_dt, t.amor_req_amt, t.amor_pay_dt, t.amor_pay_amt, t.amor_est_id "+
				" from    accident a, ot_accid t, \n"+
				"         (select car_mng_id, accid_id, sum(decode(r_j_amt,0,tot_amt,trunc((r_labor+r_j_amt)*1.1,0))) tot_amt from service group by car_mng_id, accid_id) h, \n"+
				"         cont b, car_reg f, car_etc g, client i, \n"+
				"         car_nm c, car_mng d, users j, users k \n"+
				" where   "+
				"         a.accid_st in ('1','3') \n"+// --피해,쌍방사고
				"         and a.accid_dt >= '20070101' \n"+
				"         and a.car_mng_id=t.car_mng_id and a.accid_id=t.accid_id and t.amor_car_amt >0  and t.ot_fault_per>0 \n"+
				"         and a.car_mng_id=h.car_mng_id and a.accid_id=h.accid_id \n"+
				"         and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and b.rent_l_cd not like 'RM%' \n"+
				"         and a.car_mng_id=f.car_mng_id \n"+
				"	      and to_char(add_months(to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'),24),'YYYYMMDD') >= substr(a.accid_dt,1,8) \n"+ //--출고2년이내
				"         and b.rent_mng_id=g.rent_mng_id and b.rent_l_cd=g.rent_l_cd \n"+
				"         and trunc(t.amor_car_amt*20/100,0) < h.tot_amt \n"+//--수리비용이 잔가의 20% 초과여부
				"         and b.client_id=i.client_id \n"+
				"         and g.car_id=c.car_id and g.car_seq=c.car_seq and c.car_comp_id=d.car_comp_id and c.car_cd=d.code \n"+
				"         and a.reg_id=j.user_id \n"+
				"         and b.mng_id=k.user_id \n"+
				" ";		


		if(gubun1.equals("1"))					query += " and f.car_use='1'"; 
		if(gubun1.equals("2"))					query += " and f.car_use='2'";

		if(brch_id.equals("S1"))				query += " and b.brch_id in ('S1','K1','K2', 'I1', 'S2')"; 
		if(brch_id.equals("B1"))				query += " and b.brch_id in ('B1','N1')"; 
		if(brch_id.equals("N1"))				query += " and b.brch_id in ('B1','N1')"; 
		if(brch_id.equals("D1"))				query += " and b.brch_id in ('D1')"; 

		if(gubun3.equals("0"))					query += " and nvl(t.amor_st,'N')='Y' and t.amor_pay_dt is null";		//미수금
		if(gubun3.equals("1"))					query += " and nvl(t.amor_st,'N')='Y' and t.amor_pay_dt is not null";	//수금
		if(gubun3.equals("4"))					query += " and t.amor_st is null";										//미청구
	
		search_dt = "a.accid_dt";

		if(gubun3.equals("0"))					search_dt = "t.amor_req_dt";
		if(gubun3.equals("1"))					search_dt = "t.amor_pay_dt";
		if(gubun3.equals("3"))					search_dt = "a.accid_dt";


		if(gubun2.equals("1"))					query += " and "+search_dt+" like to_char(sysdate,'YYYYMMDD')||'%'";
		else if(gubun2.equals("2"))				query += " and "+search_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("4"))				query += " and "+search_dt+" like '"+AddUtil.getDate(1)+"%'";
		else if(gubun2.equals("5"))	{
			if(!st_dt.equals("") && !end_dt.equals("")){
												query += " and "+search_dt+" between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";			
			}
		}

		if(!t_wd.equals("")){
			if(s_kd.equals("1"))				query += " and b.rent_l_cd like '%"+t_wd+"%'";
			else if(s_kd.equals("2"))			query += " and i.firm_nm like '%"+t_wd+"%'";
			else if(s_kd.equals("3"))			query += " and f.car_no||' '||f.first_car_no like '%"+t_wd+"%'";
			else if(s_kd.equals("4"))			query += " and f.car_nm||c.car_name like '%"+t_wd+"%'";
			else if(s_kd.equals("5"))			query += " and a.accid_dt like '"+t_wd+"%'";
			else if(s_kd.equals("6"))			query += " and a.our_num like '%"+t_wd+"%'";
			else if(s_kd.equals("7"))			query += " and case when b.mng_id = '' then b.bus_id2 when b.mng_id is null then b.bus_id2 else b.mng_id end like '%"+t_wd+"%'";
			else if(s_kd.equals("8"))			query += " and t.ins_com like '%"+t_wd+"%'";
			else if(s_kd.equals("9"))			query += " and t.amor_req_dt like '"+t_wd+"%'";
			else if(s_kd.equals("10"))			query += " and t.amor_pay_dt like '"+t_wd+"%'";
			else if(s_kd.equals("11"))			query += " and nvl(t.amor_req_id,case when b.mng_id = '' then b.bus_id2 when b.mng_id is null then b.bus_id2 else b.mng_id end) like '%"+t_wd+"%'";
			else if(s_kd.equals("accid_id"))	query += " and a.car_mng_id||a.accid_id='"+t_wd+"'";
		}

		if(sort.equals("1"))		query += " order by  i.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by  f.car_no "+asc;
		else if(sort.equals("3"))	query += " order by  f.car_nm||c.car_name "+asc;
		else if(sort.equals("4"))	query += " order by  a.accid_dt "+asc;
		else if(sort.equals("5"))	query += " order by  t.ins_com "+asc;
		else if(sort.equals("6"))	query += " order by  t.amor_req_dt "+asc;
		else if(sort.equals("7"))	query += " order by  t.amor_pay_dt "+asc;


		try {
          

			pstmt = con.prepareStatement(query);
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

//				System.out.println("[AccidDatabase:getAccidS8List2]="+query);
		}catch(SQLException se){       
				System.out.println("[AccidDatabase:getAccidS8List2]="+se);
				System.out.println("[AccidDatabase:getAccidS8List2]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고 차량시세하락손해청구 리스트 - 201905년 사고부터 등록일기준 5년이내로 변경 
	public Hashtable getAccidAmor(String car_mng_id, String accid_id, String accid_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
        String query = "";

        String query1 = "";
        
        if ( AddUtil.parseInt(accid_dt) > 20190430 ) {
        	query1 = " to_char(add_months(to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'),60),'YYYYMMDD') >= substr(a.accid_dt,1,8)";  //--출고5년이내
        } else {
        	query1 = " to_char(add_months(to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'),24),'YYYYMMDD') >= substr(a.accid_dt,1,8)";  //--출고2년이내
        }
        
		query = " select \n"+
				"         a.car_mng_id, a.accid_id, a.accid_st, a.rent_mng_id, a.rent_l_cd, \n"+
				"         b.use_yn, b.client_id, i.firm_nm, i.client_nm, \n"+
				"         f.car_no, f.car_nm, c.car_name, \n"+
				"         k.user_nm as mng_nm, \n"+
				"         j.user_nm as reg_nm, \n"+
				"         a.accid_dt, a.sub_etc, a.settle_st6, decode(a.settle_st,'1','종결','진행') settle_st_nm,  \n"+
				"         b.dlv_dt, \n"+
				"         trunc(months_between(to_date(substr(a.accid_dt,1,8),'YYYYMMDD'), to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'))/12,0)+1 dlv_mon, \n"+
				"         t.amor_car_amt car_amt, \n"+
				"         trunc(t.amor_car_amt*20/100,0) car_amt_20p, \n"+
				"         h.tot_amt, \n"+
				"         decode(trunc(months_between(to_date(substr(a.accid_dt,1,8),'YYYYMMDD'), to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'))/12,0), \n"+
				"                     1, trunc(h.tot_amt*10/100*t.ot_fault_per/100,0), \n"+
				"                     0, trunc(h.tot_amt*15/100*t.ot_fault_per/100,0)) req_est_amt, \n"+
				"         decode('','','미청구') as pay_yn, '' pay_dt, '' req_dt, 0 pay_amt, 0 req_amt, \n"+
				"         decode(a.accid_st,'1','피해','3','쌍방') as accid_st_nm, 100-a.our_fault_per as ot_fault_per, \n"+
				"         t.amor_req_dt, t.amor_req_amt, t.amor_pay_dt, t.amor_pay_amt, t.amor_est_id "+
				" from    accident a, ot_accid t, \n"+
				"         (select car_mng_id, accid_id, sum(decode(r_j_amt,0,tot_amt,trunc((r_labor+r_j_amt)*1.1,0))) tot_amt from service group by car_mng_id, accid_id) h, \n"+
				"         cont b, car_reg f, car_etc g, client i, \n"+
				"         car_nm c, car_mng d, users j, users k \n"+
				" where   a.car_mng_id='"+car_mng_id+"' and a.accid_id='"+accid_id+"' "+
				"         and a.car_mng_id=t.car_mng_id and a.accid_id=t.accid_id and t.amor_car_amt >0 and t.ot_fault_per>0\n"+
				"         and a.car_mng_id=h.car_mng_id and a.accid_id=h.accid_id \n"+
				"         and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd not like 'RM%' \n"+
				"         and a.car_mng_id=f.car_mng_id  and "+ query1 +  						
			//	"	      and to_char(add_months(to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'),24),'YYYYMMDD') >= substr(a.accid_dt,1,8) \n"+ //--출고2년이내
			
				"         and b.rent_mng_id=g.rent_mng_id and b.rent_l_cd=g.rent_l_cd \n"+
				"         and trunc(t.amor_car_amt*20/100,0) < h.tot_amt \n"+//--수리비용이 잔가의 20% 초과여부
				"         and b.client_id=i.client_id \n"+
				"         and g.car_id=c.car_id and g.car_seq=c.car_seq and c.car_comp_id=d.car_comp_id and c.car_cd=d.code \n"+
				"         and a.reg_id=j.user_id \n"+
				"         and b.mng_id=k.user_id \n"+
				" ";		

		try {
          

			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){       
				System.out.println("[AccidDatabase:getAccidAmor]="+se);
				System.out.println("[AccidDatabase:getAccidAmor]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }
	
	//사고 차량시세하락손해청구 리스트 - 
		public Hashtable getAccidAmor(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
	        Connection con = connMgr.getConnection(DATA_SOURCE);

	        if(con == null)
	            throw new DataSourceEmptyException("Can't get Connection !!");

			PreparedStatement pstmt = null;
			ResultSet rs = null;

			Hashtable ht = new Hashtable();
	        String query = "";

			query = " select \n"+
					"         a.car_mng_id, a.accid_id, a.accid_st, a.rent_mng_id, a.rent_l_cd, \n"+
					"         b.use_yn, b.client_id, i.firm_nm, i.client_nm, \n"+
					"         f.car_no, f.car_nm, c.car_name, \n"+
					"         k.user_nm as mng_nm, \n"+
					"         j.user_nm as reg_nm, \n"+
					"         a.accid_dt, a.sub_etc, a.settle_st6, decode(a.settle_st,'1','종결','진행') settle_st_nm,  \n"+
					"         b.dlv_dt, \n"+
					"         trunc(months_between(to_date(substr(a.accid_dt,1,8),'YYYYMMDD'), to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'))/12,0)+1 dlv_mon, \n"+
					"         t.amor_car_amt car_amt, \n"+
					"         trunc(t.amor_car_amt*20/100,0) car_amt_20p, \n"+
					"         h.tot_amt, \n"+
					"         decode(trunc(months_between(to_date(substr(a.accid_dt,1,8),'YYYYMMDD'), to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'))/12,0), \n"+
					"                     1, trunc(h.tot_amt*10/100*t.ot_fault_per/100,0), \n"+
					"                     0, trunc(h.tot_amt*15/100*t.ot_fault_per/100,0)) req_est_amt, \n"+
					"         decode('','','미청구') as pay_yn, '' pay_dt, '' req_dt, 0 pay_amt, 0 req_amt, \n"+
					"         decode(a.accid_st,'1','피해','3','쌍방') as accid_st_nm, 100-a.our_fault_per as ot_fault_per, \n"+
					"         t.amor_req_dt, t.amor_req_amt, t.amor_pay_dt, t.amor_pay_amt, t.amor_est_id "+
					" from    accident a, ot_accid t, \n"+
					"         (select car_mng_id, accid_id, sum(decode(r_j_amt,0,tot_amt,trunc((r_labor+r_j_amt)*1.1,0))) tot_amt from service group by car_mng_id, accid_id) h, \n"+
					"         cont b, car_reg f, car_etc g, client i, \n"+
					"         car_nm c, car_mng d, users j, users k \n"+
					" where   a.car_mng_id='"+car_mng_id+"' and a.accid_id='"+accid_id+"' "+
					"         and a.car_mng_id=t.car_mng_id and a.accid_id=t.accid_id and t.amor_car_amt >0 and t.ot_fault_per>0\n"+
					"         and a.car_mng_id=h.car_mng_id and a.accid_id=h.accid_id \n"+
					"         and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd not like 'RM%' \n"+
					"         and a.car_mng_id=f.car_mng_id \n"+
					
					"	      and to_char(add_months(to_date(nvl(b.dlv_dt,f.init_reg_dt),'YYYYMMDD'),24),'YYYYMMDD') >= substr(a.accid_dt,1,8) \n"+ //--출고2년이내
				
					"         and b.rent_mng_id=g.rent_mng_id and b.rent_l_cd=g.rent_l_cd \n"+
					"         and trunc(t.amor_car_amt*20/100,0) < h.tot_amt \n"+//--수리비용이 잔가의 20% 초과여부
					"         and b.client_id=i.client_id \n"+
					"         and g.car_id=c.car_id and g.car_seq=c.car_seq and c.car_comp_id=d.car_comp_id and c.car_cd=d.code \n"+
					"         and a.reg_id=j.user_id \n"+
					"         and b.mng_id=k.user_id \n"+
					" ";		

			try {
	          

				pstmt = con.prepareStatement(query);
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

			}catch(SQLException se){       
					System.out.println("[AccidDatabase:getAccidAmor]="+se);
					System.out.println("[AccidDatabase:getAccidAmor]="+query);
				    throw new DatabaseException("exception");
	        }finally{
	            try{
	              
	                if(rs != null) rs.close();
	                if(pstmt != null) pstmt.close();
	            }catch(SQLException _ignored){}
	            connMgr.freeConnection(DATA_SOURCE, con);
				con = null;
	        }
	        return ht;
	    }

    /**
     * 사고기록 개별조회 : car_accid_all_u.jsp
     */
    public AccidentBean getAccidentBeanPay(String car_mng_id, String serv_dt, String off_id, int rep_amt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        AccidentBean bean = new AccidentBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from accident where (car_mng_id, accid_id) in (select car_mng_id, accid_id from service where car_mng_id= ? and serv_dt=replace(?,'-','') and off_id=? and rep_amt=?)";
        
        try{
           
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, car_mng_id	);
			pstmt.setString(2, serv_dt		);
			pstmt.setString(3, off_id		);
			pstmt.setInt   (4, rep_amt		);
    		rs = pstmt.executeQuery();
            if (rs.next()){
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					//자동차관리번호
				bean.setAccid_id(rs.getString("ACCID_ID"));
				bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));
				bean.setRent_l_cd(rs.getString("RENT_L_CD"));
				bean.setAccid_st(rs.getString("ACCID_ST"));
				bean.setOur_car_nm(rs.getString("OUR_CAR_NM"));
				bean.setOur_driver(rs.getString("OUR_DRIVER"));
				bean.setOur_tel(rs.getString("OUR_TEL"));
				bean.setOur_m_tel(rs.getString("OUR_M_TEL"));
				bean.setOur_ssn(rs.getString("OUR_SSN"));
				bean.setOur_lic_kd(rs.getString("OUR_LIC_KD"));
				bean.setOur_lic_no(rs.getString("OUR_LIC_NO"));
				bean.setOur_ins(rs.getString("OUR_INS"));
				bean.setOur_num(rs.getString("OUR_NUM"));
				bean.setOur_post(rs.getString("OUR_POST"));
				bean.setOur_addr(rs.getString("OUR_ADDR"));
				bean.setAccid_dt(rs.getString("ACCID_DT"));
				bean.setAccid_city(rs.getString("ACCID_CITY"));
				bean.setAccid_gu(rs.getString("ACCID_GU"));
				bean.setAccid_dong(rs.getString("ACCID_DONG"));
				bean.setAccid_point(rs.getString("ACCID_POINT"));
				bean.setAccid_cont(rs.getString("ACCID_CONT"));
				bean.setOt_car_no(rs.getString("OT_CAR_NO"));
				bean.setOt_car_nm(rs.getString("OT_CAR_NM"));
				bean.setOt_driver(rs.getString("OT_DRIVER"));
				bean.setOt_tel(rs.getString("OT_TEL"));
				bean.setOt_m_tel(rs.getString("OT_M_TEL"));
				bean.setOt_ins(rs.getString("OT_INS"));
				bean.setOt_num(rs.getString("OT_NUM"));
				bean.setOt_ins_nm(rs.getString("OT_INS_NM"));
				bean.setOt_ins_tel(rs.getString("OT_INS_TEL"));
				bean.setOt_ins_m_tel(rs.getString("OT_INS_M_TEL"));
				bean.setOt_pol_sta(rs.getString("OT_POL_STA"));
				bean.setOt_pol_nm(rs.getString("OT_POL_NM"));
				bean.setOt_pol_tel(rs.getString("OT_POL_TEL"));
				bean.setOt_pol_m_tel(rs.getString("OT_POL_M_TEL"));
				bean.setHum_amt(rs.getInt("HUM_AMT"));
				bean.setHum_nm(rs.getString("HUM_NM"));
				bean.setHum_tel(rs.getString("HUM_TEL"));
				bean.setMat_amt(rs.getInt("MAT_AMT"));
				bean.setMat_nm(rs.getString("MAT_NM"));
				bean.setMat_tel(rs.getString("MAT_TEL"));
				bean.setOne_amt(rs.getInt("ONE_AMT"));
				bean.setOne_nm(rs.getString("ONE_NM"));
				bean.setOne_tel(rs.getString("ONE_TEL"));
				bean.setMy_amt(rs.getInt("MY_AMT"));
				bean.setMy_nm(rs.getString("MY_NM"));
				bean.setMy_tel(rs.getString("MY_TEL"));
				bean.setRef_dt(rs.getString("REF_DT"));
				bean.setEx_tot_amt(rs.getInt("EX_TOT_AMT"));
				bean.setTot_amt(rs.getInt("TOT_AMT"));
				bean.setRec_amt(rs.getInt("REC_AMT"));
				bean.setRec_dt(rs.getString("REC_DT"));
				bean.setRec_plan_dt(rs.getString("REC_PLAN_DT"));
				bean.setSup_amt(rs.getInt("SUP_AMT"));
				bean.setSup_dt(rs.getString("SUP_DT"));
				bean.setIns_sup_amt(rs.getInt("INS_SUP_AMT"));
				bean.setIns_sup_dt(rs.getString("INS_SUP_DT"));
				bean.setIns_tot_amt(rs.getInt("INS_TOT_AMT"));
				bean.setSub_rent_gu(rs.getString("SUB_RENT_GU"));
				bean.setSub_firm_nm(rs.getString("SUB_FIRM_NM"));
				bean.setSub_rent_st(rs.getString("SUB_RENT_ST"));
				bean.setSub_rent_et(rs.getString("SUB_RENT_ET"));
				bean.setSub_etc(rs.getString("SUB_ETC"));
				bean.setReg_dt(rs.getString("REG_DT"));
				bean.setReg_id(rs.getString("REG_ID"));
				bean.setUpdate_dt(rs.getString("UPDATE_DT"));
				bean.setUpdate_id(rs.getString("UPDATE_ID"));
				bean.setOur_lic_dt(rs.getString("OUR_LIC_DT"));
				bean.setOur_tel2(rs.getString("OUR_TEL2"));
				bean.setOt_ssn(rs.getString("OT_SSN"));
				bean.setOt_lic_kd(rs.getString("OT_LIC_KD"));
				bean.setOt_lic_no(rs.getString("OT_LIC_NO"));
				bean.setOt_tel2(rs.getString("OT_TEL2"));
				bean.setOur_dam_st(rs.getString("OUR_DAM_ST"));
				bean.setOt_dam_st(rs.getString("OT_DAM_ST"));
				bean.setAccid_addr(rs.getString("ACCID_ADDR"));
				bean.setAccid_cont2(rs.getString("ACCID_CONT2"));
				bean.setImp_fault_st(rs.getString("IMP_FAULT_ST"));
				bean.setImp_fault_sub(rs.getString("IMP_FAULT_SUB"));
				bean.setOur_fault_per(rs.getInt("OUR_FAULT_PER"));
				bean.setOt_pol_st(rs.getString("OT_POL_ST"));
				bean.setOt_pol_num(rs.getString("OT_POL_NUM"));
				bean.setOt_pol_fax(rs.getString("OT_POL_FAX"));
				bean.setR_site(rs.getString("R_SITE"));
				bean.setMemo(rs.getString("MEMO"));
				bean.setCar_in_dt(rs.getString("CAR_IN_DT"));
				bean.setCar_out_dt(rs.getString("CAR_OUT_DT"));
				bean.setIns_end_dt(rs.getString("INS_END_DT"));
				bean.setRent_s_cd(rs.getString("RENT_S_CD"));
				bean.setAccid_type(rs.getString("ACCID_TYPE"));
				bean.setAccid_type_sub(rs.getString("ACCID_TYPE_SUB"));
				bean.setSpeed(rs.getString("SPEED"));
				bean.setRoad_stat(rs.getString("ROAD_STAT"));
				bean.setRoad_stat2(rs.getString("ROAD_STAT2"));
				bean.setWeather(rs.getString("WEATHER"));
				bean.setHum_end_dt(rs.getString("HUM_END_DT"));
				bean.setMat_end_dt(rs.getString("MAT_END_DT"));
				bean.setOne_end_dt(rs.getString("ONE_END_DT"));
				bean.setMy_end_dt(rs.getString("MY_END_DT"));
				bean.setSettle_st(rs.getString("SETTLE_ST"));
				bean.setSettle_dt(rs.getString("SETTLE_DT"));
				bean.setSettle_id(rs.getString("SETTLE_ID"));
				bean.setSettle_cont(rs.getString("SETTLE_CONT"));
				bean.setSettle_st1(rs.getString("SETTLE_ST1"));
				bean.setSettle_dt1(rs.getString("SETTLE_DT1"));
				bean.setSettle_id1(rs.getString("SETTLE_ID1"));
				bean.setSettle_st2(rs.getString("SETTLE_ST2"));
				bean.setSettle_dt2(rs.getString("SETTLE_DT2"));
				bean.setSettle_id2(rs.getString("SETTLE_ID2"));
				bean.setSettle_st3(rs.getString("SETTLE_ST3"));
				bean.setSettle_dt3(rs.getString("SETTLE_DT3"));
				bean.setSettle_id3(rs.getString("SETTLE_ID3"));
				bean.setSettle_st4(rs.getString("SETTLE_ST4"));
				bean.setSettle_dt4(rs.getString("SETTLE_DT4"));
				bean.setSettle_id4(rs.getString("SETTLE_ID4"));
				bean.setSettle_st5(rs.getString("SETTLE_ST5"));
				bean.setSettle_dt5(rs.getString("SETTLE_DT5"));
				bean.setSettle_id5(rs.getString("SETTLE_ID5"));
				bean.setDam_type1(rs.getString("DAM_TYPE1"));
				bean.setDam_type2(rs.getString("DAM_TYPE2"));
				bean.setDam_type3(rs.getString("DAM_TYPE3"));
				bean.setDam_type4(rs.getString("DAM_TYPE4"));
				bean.setBus_id2(rs.getString("BUS_ID2")); //사고시점 담당자

//				bean.setAmor_amt	(rs.getInt   ("AMOR_AMT"));
//				bean.setAmor_nm		(rs.getString("AMOR_NM"));
//				bean.setAmor_tel	(rs.getString("AMOR_TEL"));
//				bean.setAmor_end_dt	(rs.getString("AMOR_END_DT"));

				bean.setAcc_dt(rs.getString("ACC_DT"));
				bean.setAcc_id(rs.getString("ACC_ID"));



			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getAccidentBeanPay]\n"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	//담당자별 사고기록 리스트
	public Vector getAccidUList(String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */  "+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, a.our_num, a.settle_st, h.pic_cnt,"+
				"        decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(i.cust_st, '1',j.firm_nm, '4',k.user_nm,l.cust_nm) cust_nm"+
				" from   accident a, cont_n_view b,  insur e, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) f, ins_com g, "+
				"       (select car_mng_id, accid_id, count(*) pic_cnt from pic_accid group by car_mng_id, accid_id) h,  car_reg c,  car_etc g1, car_nm cn , \n"+
				"        rent_cont i, client j, users k, rent_cust l "+
				" where  a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and e.car_mng_id=f.car_mng_id and e.ins_st=f.ins_st and e.ins_com_id=g.ins_com_id and a.car_mng_id=e.car_mng_id"+
				"        and a.car_mng_id=h.car_mng_id(+) and a.accid_id=h.accid_id(+)"+
				"        and a.car_mng_id=i.car_mng_id(+) and a.rent_s_cd=i.rent_s_cd(+) and i.cust_id=j.client_id(+) and i.cust_id=k.user_id(+) and i.cust_id=l.cust_id(+) "+
				"        and nvl(a.settle_st,'0')='0' "+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g1.rent_mng_id(+)  and a.rent_l_cd = g1.rent_l_cd(+)  \n"+
                       		"	and g1.car_id=cn.car_id(+)  and    g1.car_seq=cn.car_seq(+) \n"+                       		
				"        and DECODE(i.rent_st,'12',i.mng_id,'',decode(b.car_st,'2',nvl(nvl(a.acc_id,a.reg_id),nvl(b.mng_id,b.bus_id2)),nvl(b.mng_id,b.bus_id2)),i.bus_id) = '"+user_id+"' "+					
				" order by a.accid_dt ";

		try {

			pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
       			System.out.println("[AccidDatabase:getAccidSList]="+se);
       			System.out.println("[AccidDatabase:getAccidSList]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

   /**
     * 보험금청구내역 update (휴차/대차료 보험회사 청구내용)
     */
    public int updateMyAccidDocReqDt(MyAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE MY_ACCID SET "+
				" doc_req_dt=to_char(sysdate,'YYYYMMDD') "+
				" where car_mng_id=? and accid_id=? and seq_no=? ";
    
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
			pstmt.setString(2, bean.getAccid_id().trim());
			pstmt.setInt   (3, bean.getSeq_no());		
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateMyAccidDocReqDt]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

   /**
     * 보험금청구내역 update (휴차/대차료 보험회사 청구내용)
     */
    public int updateMyAccidDocRegDt(MyAccidBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE MY_ACCID SET "+
				" doc_reg_dt=to_char(sysdate,'YYYYMMDD') "+
				" where car_mng_id=? and accid_id=? and seq_no=? ";
    
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
			pstmt.setString(2, bean.getAccid_id().trim());
			pstmt.setInt   (3, bean.getSeq_no());		
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateMyAccidDocRegDt]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	//담당자별 사고기록 리스트
	public Vector getResCarTaechaMyaccidSearch(String use_s_dt, String use_e_dt, String ins_com) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select e.firm_nm, c.car_no as a_car_no, c.car_nm as a_car_nm, b.accid_dt, a.* \n"+
				" from   my_accid a, accident b, car_reg c, cont d, client e \n"+
				" where  a.car_no is not null \n"+
				"        and replace(replace(a.ins_com,'해상',''),'화재','')=replace(replace(nvl('"+ins_com+"',a.ins_com),'해상',''),'화재','') \n"+
				"        and substr(nvl(a.use_st,to_char(sysdate,'YYYYMMDD')),1,8) >= to_char(to_date(substr(replace('"+use_s_dt+"','-',''),1,8),'YYYYMMDD')-30,'YYYYMMDD') \n"+
				"        and substr(nvl(a.use_et,to_char(sysdate,'YYYYMMDD')),1,8) <= to_char(to_date(substr(replace('"+use_e_dt+"','-',''),1,8),'YYYYMMDD')+30,'YYYYMMDD') \n"+
				"        and a.car_mng_id=b.car_mng_id and a.accid_id=b.accid_id \n"+
				"        and b.car_mng_id=c.car_mng_id \n"+
				"        and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd and d.rent_l_cd not like 'RM%' \n"+
				"        and d.client_id=e.client_id \n"+
				" ";

	

		try {
         

			pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
       			System.out.println("[AccidDatabase:getResCarTaechaMyaccidSearch]="+se);
       			System.out.println("[AccidDatabase:getResCarTaechaMyaccidSearch]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
     * 사고중복등록여부
     */
    public int getAccidRegChk(AccidentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
		ResultSet rs = null;
        String query = "";
        int su = 0;

		query = " select count(*) "+
				" from   accident "+
				" where  car_mng_id=? and rent_l_cd=? "+
				"        and substr(accid_dt,1,8) between to_char(to_date(substr(replace(?,'-',''),1,8),'YYYYMMDD')-4,'YYYYMMDD') "+
				"                                 and     to_char(to_date(substr(replace(?,'-',''),1,8),'YYYYMMDD')+3,'YYYYMMDD')  ";
    
       try{
           

			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getCar_mng_id	()); 
			pstmt.setString	(2,		bean.getRent_l_cd	()); 
			pstmt.setString	(3,		bean.getAccid_dt	()); 
			pstmt.setString	(4,		bean.getAccid_dt	()); 
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				su = rs.getInt(1);
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){           
				System.out.println("[AccidDatabase:getAccidRegChk]\n"+se);

                 throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return su;
    }

	//대차료미납현황
	public Vector getAccidS9List(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";


		query = " SELECT  \n"+
				"        c.car_no, e.rent_dt, b.accid_dt, b.rent_mng_id, b.rent_l_cd, f.firm_nm, \n"+
				"        d.ins_com_f_nm, b.accid_st,  \n"+
				"        a.car_mng_id, a.accid_id, a.seq_no, a.req_st,  \n"+
				"        a.ins_com_id,  \n"+
				"        d.ins_com_f_nm, \n"+
				"        a.ins_com, a.car_no AS d_car_no, a.CAR_NM AS d_car_nm,  \n"+
				"        a.req_amt, a.req_dt, NVL(h.pay_amt,0) pay_amt, h.pay_dt,  \n"+
				"        h.cnt, \n"+
				"        a.req_amt-NVL(h.pay_amt,0) def_amt, \n"+
			    "        (TRUNC(((a.req_amt-NVL(h.pay_amt,0))*0.05*TRUNC(TO_DATE(NVL(h.pay_dt,a.req_dt), 'YYYYMMDD')- sysdate))/365) * -1) dly_amt, \n"+
				"        TRUNC(sysdate - TO_DATE(NVL(h.pay_dt,a.req_dt), 'YYYYMMDD')) dly_days, \n"+
				"        decode(b.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, \n"+
				"        decode(a.req_gu, '1','휴차료','2','대차료') req_gu, \n"+
				"        a.re_reason, a.doc_req_dt, a.doc_reg_dt, \n"+
				"        NVL(a.bus_id2,e.bus_id2) bus_id2, \n"+
				"        g.f_doc_reg_dt, g.f_doc_cnt \n"+
				" FROM   \n"+
				"        MY_ACCID a, ACCIDENT b, CAR_REG c, INS_COM d, CONT e, client f, \n"+
				"        ( select a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id,  \n"+
				"                 sum(a.ext_pay_amt) pay_amt, MAX(a.ext_pay_dt) pay_dt, COUNT(*) cnt \n"+
				" 		 from   scd_ext a, cont b \n"+
				" 		 where  a.ext_st='6' \n"+
				" 			    and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" 		 group by a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id \n"+
				" 	   ) h, \n"+
				"      ( SELECT car_mng_id, car_no AS accid_id, paid_no AS seq_no, MAX(reg_dt) f_doc_reg_dt, COUNT(*) f_doc_cnt \n"+
				"        FROM   FINE_DOC_LIST \n"+
				"        WHERE  doc_id LIKE '법무%' \n"+
				"        GROUP BY car_mng_id, car_no, paid_no \n"+
				"      ) g \n"+
				" WHERE  nvl(a.req_st,'0')<>'0' AND a.req_amt>0  \n"+
				"        AND a.car_mng_id=b.car_mng_id AND a.accid_id=b.accid_id \n"+
				"        AND b.car_mng_id=c.car_mng_id \n"+
				"        and a.ins_com=d.ins_com_nm(+) \n"+
				"        AND b.rent_mng_id=e.rent_mng_id AND b.rent_l_cd=e.rent_l_cd  and e.rent_l_cd not like 'RM%' \n"+
				"        AND e.client_id=f.client_id "+
				"        and a.car_mng_id=h.car_mng_id(+) and a.accid_id||a.seq_no=h.ext_id(+) \n"+				
				"        and a.car_mng_id=g.car_mng_id(+) and a.accid_id=g.accid_id(+) and a.seq_no=g.seq_no(+) \n"+				
				" ";

		if(!gubun1.equals(""))			query += "  AND a.req_dt  >= replace('"+gubun1+"','-','') \n"; 
		if(!gubun2.equals(""))			query += "  AND e.rent_dt >= replace('"+gubun2+"','-','') \n"; 
		if(!gubun3.equals(""))			query += "  AND a.req_amt-NVL(h.pay_amt,0) >= replace('"+gubun3+"',',','') \n"; 
		if(!gubun4.equals(""))			query += "  AND TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.req_dt,'YYYYMMDD'))) >= "+gubun4+" \n";

		if(gubun5.equals("1"))			query += "  AND NVL(h.pay_amt,0) > 0 \n";
		if(gubun5.equals("2"))			query += "  AND NVL(h.pay_amt,0) = 0 \n";

		if(gubun6.equals("1"))			query += "  AND g.f_doc_reg_dt is not null \n";
		if(gubun6.equals("2"))			query += "  AND g.f_doc_reg_dt is null \n";

		if(gubun6.equals("3"))			query += "  AND nvl(a.req_st,'0')='3' \n";

		String search = "";
		String what = "";
		
		if(s_kd.equals("1"))	what = "upper(nvl(f.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(e.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(NVL(a.bus_id2,e.bus_id2), ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.ins_com, ' '))";	

		if(!t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}

		if(sort.equals("1"))		query += " order by  decode(a.req_st,'3',1,0), a.ins_com "+asc+", a.req_dt ";
		else if(sort.equals("2"))	query += " order by  decode(a.req_st,'3',1,0), a.req_dt  "+asc;
		else if(sort.equals("3"))	query += " order by  decode(a.req_st,'3',1,0), c.car_no  "+asc+", a.req_dt ";

		try {
          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){       
				System.out.println("[AccidDatabase:getAccidS9List]="+se);
				System.out.println("[AccidDatabase:getAccidS9List]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//대차료미납현황
	public Vector getAccidS9List(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";


		query = " SELECT  \n"+
				"        c.car_no, e.rent_dt, b.accid_dt, b.rent_mng_id, b.rent_l_cd, f.firm_nm, \n"+
				"        d.ins_com_f_nm, b.accid_st,  \n"+
				"        a.car_mng_id, a.accid_id, a.seq_no, a.req_st,  \n"+
				"        a.ins_com_id,  \n"+
				"        d.ins_com_f_nm, \n"+
				"        a.ins_com, a.car_no AS d_car_no, a.CAR_NM AS d_car_nm,  \n"+
				"        a.req_amt, a.req_dt, NVL(h.pay_amt,0) pay_amt, h.pay_dt,  \n"+
				"        h.cnt, \n"+
				"        a.req_amt-NVL(h.pay_amt,0) def_amt, \n"+
			    "        (TRUNC(((a.req_amt-NVL(h.pay_amt,0))*0.05*TRUNC(TO_DATE(NVL(h.pay_dt,a.req_dt), 'YYYYMMDD')- sysdate))/365) * -1) dly_amt, \n"+
				"        TRUNC(sysdate - TO_DATE(NVL(h.pay_dt,a.req_dt), 'YYYYMMDD')) dly_days, \n"+
				"        decode(b.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, \n"+
				"        decode(a.req_gu, '1','휴차료','2','대차료') req_gu, \n"+
				"        a.re_reason, a.doc_req_dt, a.doc_reg_dt, \n"+
				"        NVL(a.bus_id2,e.bus_id2) bus_id2, \n"+
				"        g.f_doc_reg_dt, g.f_doc_cnt \n"+
				" FROM   \n"+
				"        MY_ACCID a, ACCIDENT b, CAR_REG c, INS_COM d, CONT e, client f, \n"+
				"        ( select a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id,  \n"+
				"                 sum(a.ext_pay_amt) pay_amt, MAX(a.ext_pay_dt) pay_dt, COUNT(*) cnt \n"+
				" 		 from   scd_ext a, cont b \n"+
				" 		 where  a.ext_st='6' \n"+
				" 			    and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" 		 group by a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id \n"+
				" 	   ) h, \n"+
				"      ( SELECT car_mng_id, car_no AS accid_id, paid_no AS seq_no, MAX(reg_dt) f_doc_reg_dt, COUNT(*) f_doc_cnt \n"+
				"        FROM   FINE_DOC_LIST \n"+
				"        WHERE  doc_id LIKE '법무%' \n"+
				"        GROUP BY car_mng_id, car_no, paid_no \n"+
				"      ) g \n"+
				" WHERE  nvl(a.req_st,'0')<>'0' AND a.req_amt>0  \n"+
				"        AND a.car_mng_id=b.car_mng_id AND a.accid_id=b.accid_id \n"+
				"        AND b.car_mng_id=c.car_mng_id \n"+
				"        and a.ins_com=d.ins_com_nm(+) \n"+
				"        AND b.rent_mng_id=e.rent_mng_id AND b.rent_l_cd=e.rent_l_cd  and e.rent_l_cd not like 'RM%' \n"+
				"        AND e.client_id=f.client_id "+
				"        and a.car_mng_id=h.car_mng_id(+) and a.accid_id||a.seq_no=h.ext_id(+) \n"+				
				"        and a.car_mng_id=g.car_mng_id(+) and a.accid_id=g.accid_id(+) and a.seq_no=g.seq_no(+) \n"+				
				" ";

		if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.req_dt like replace('"+st_dt+"%', '-','')";
		if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";


		if(!gubun1.equals(""))			query += "  AND a.req_dt  >= replace('"+gubun1+"','-','') \n"; 
		if(!gubun2.equals(""))			query += "  AND e.rent_dt >= replace('"+gubun2+"','-','') \n"; 
		if(!gubun3.equals(""))			query += "  AND a.req_amt-NVL(h.pay_amt,0) >= replace('"+gubun3+"',',','') \n"; 
		if(!gubun4.equals(""))			query += "  AND TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.req_dt,'YYYYMMDD'))) >= "+gubun4+" \n";

		if(gubun5.equals("1"))			query += "  AND NVL(h.pay_amt,0) > 0 \n";
		if(gubun5.equals("2"))			query += "  AND NVL(h.pay_amt,0) = 0 \n";

		if(gubun6.equals("1"))			query += "  AND g.f_doc_reg_dt is not null \n";
		if(gubun6.equals("2"))			query += "  AND g.f_doc_reg_dt is null \n";

		if(gubun6.equals("3"))			query += "  AND nvl(a.req_st,'0')='3' \n";

		String search = "";
		String what = "";
		
		if(s_kd.equals("1"))	what = "upper(nvl(f.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(e.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(NVL(a.bus_id2,e.bus_id2), ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.ins_com, ' '))";	

		if(!t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}

		if(sort.equals("1"))		query += " order by  decode(a.req_st,'3',1,0), a.ins_com "+asc+", a.req_dt ";
		else if(sort.equals("2"))	query += " order by  decode(a.req_st,'3',1,0), a.req_dt  "+asc;
		else if(sort.equals("3"))	query += " order by  decode(a.req_st,'3',1,0), c.car_no  "+asc+", a.req_dt ";

		try {
          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){       
				System.out.println("[AccidDatabase:getAccidS9List]="+se);
				System.out.println("[AccidDatabase:getAccidS9List]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//대차료미납현황
	public Vector getAccidS9List(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";



		query = " SELECT "+
//				"        p.filename, p.reg_dt, \n"+
		        "        nvl(ass.suit_dt,g.serv_dt) serv_dt ,nvl(h2.pic_cnt,0) pic_cnt, h2.attach_seq, h2.file_type, \n"+
				"        c.car_no, c.car_nm, e.rent_dt, b.accid_dt, b.rent_mng_id, b.rent_l_cd, f.firm_nm, \n"+
				"        d.ins_com_f_nm, b.accid_st,  \n"+
				"        a.car_mng_id, a.accid_id, a.seq_no, a.req_st,  \n"+
				"        a.ins_com_id,  \n"+
				"        d.ins_com_f_nm, \n"+
				"        a.ins_com, a.car_no AS d_car_no, a.CAR_NM AS d_car_nm,  \n"+
				"        a.req_amt, a.req_dt, NVL(h.pay_amt,0) pay_amt, h.pay_dt,  \n"+
				"        h.cnt, \n"+
				"        a.req_amt-NVL(h.pay_amt,0) def_amt, trunc(NVL(h.pay_amt,0)/a.req_amt*100) def_per, to_char((NVL(h.pay_amt,0)/a.req_amt*100),'00.00') def_per2, \n"+
			    "        (TRUNC(((a.req_amt-NVL(h.pay_amt,0))*0.05*TRUNC(TO_DATE(NVL(h.pay_dt,a.req_dt), 'YYYYMMDD')- sysdate))/365) * -1) dly_amt, \n"+
				"        TRUNC(sysdate - TO_DATE(NVL(h.pay_dt,a.req_dt), 'YYYYMMDD')) dly_days, \n"+
				"        decode(b.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, \n"+
				"        decode(a.req_gu, '1','휴차료','2','대차료') req_gu, \n"+
				"        a.re_reason, a.doc_req_dt, a.doc_reg_dt, \n"+
				"        NVL(a.bus_id2,e.bus_id2) bus_id2, \n"+
				"        g.f_doc_reg_dt, g.f_doc_cnt ,\n"+
				" 		decode(ass.suit_type, '1','분심위','2','민사소송', 'N', '소송불가' , '' ) suit_nm, ass.suit_dt , ass.mean_dt \n"+				
				" FROM   \n"+
				"        MY_ACCID a, ACCIDENT b, CAR_REG c, INS_COM d, CONT e, client f, accid_suit ass, \n"+
				"        ( select a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id,  \n"+
				"                 sum(a.ext_pay_amt) pay_amt, MAX(a.ext_pay_dt) pay_dt, COUNT(*) cnt \n"+
				" 		 from   scd_ext a, cont b \n"+
				" 		 where  a.ext_st='6' \n"+
				" 			    and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" 		 group by a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id \n"+
				" 	   ) h, \n"+
				"      ( SELECT max(serv_dt) serv_dt, car_mng_id, car_no AS accid_id, paid_no AS seq_no, MAX(reg_dt) f_doc_reg_dt, COUNT(*) f_doc_cnt \n"+
				"        FROM   FINE_DOC_LIST \n"+
				"        WHERE  doc_id LIKE '법무%' \n"+
				"        GROUP BY car_mng_id, car_no, paid_no \n"+
				"      ) g, "+
//				"        pic_resrent_accid p \n"+
			    "        ( select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7,6) accid_id, SUBSTR(content_seq,13,1) seq_no, count(0) pic_cnt, max(seq) attach_seq, MAX(file_type) file_type from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PIC_RESRENT_ACCID' group by content_seq ) h2 "+
				" WHERE  nvl(a.req_st,'0') not in ('0','3') AND a.req_amt>0  \n"+   //nvl(a.req_st,'0') <> '0'
				"        AND a.car_mng_id=b.car_mng_id AND a.accid_id=b.accid_id \n"+
				"        AND b.car_mng_id=c.car_mng_id \n"+
				"        and a.ins_com=d.ins_com_nm(+) \n"+
				"        AND b.rent_mng_id=e.rent_mng_id AND b.rent_l_cd=e.rent_l_cd  and e.rent_l_cd not like 'RM%' \n"+
				"        AND e.client_id=f.client_id "+
				"        and a.car_mng_id=h.car_mng_id(+) and a.accid_id||a.seq_no=h.ext_id(+) \n"+		
				"        and a.car_mng_id=ass.car_mng_id(+) and a.accid_id=ass.accid_id(+)"+
				"        and a.car_mng_id=g.car_mng_id(+) and a.accid_id=g.accid_id(+) and a.seq_no=g.seq_no(+) "+
//				"	     AND a.car_mng_id=p.car_mng_id(+) AND a.accid_id=p.accid_id(+) \n"+				
				"        and a.car_mng_id=h2.car_mng_id(+) and a.accid_id=h2.accid_id(+) and a.seq_no=h2.seq_no(+) "+
				" ";

		if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.req_dt like replace('"+st_dt+"%', '-','')";
		if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";


		if(!gubun1.equals(""))			query += "  AND a.req_dt  >= replace('"+gubun1+"','-','') \n"; 
		if(!gubun2.equals(""))			query += "  AND e.rent_dt >= replace('"+gubun2+"','-','') \n"; 
		if(!gubun3.equals(""))			query += "  AND a.req_amt-NVL(h.pay_amt,0) >= replace('"+gubun3+"',',','') \n"; 
		if(!gubun4.equals(""))			query += "  AND TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.req_dt,'YYYYMMDD'))) >= "+gubun4+" \n";
		if(!gubun7.equals(""))			query += "  AND a.req_amt-NVL(h.pay_amt,0) >= 0 and trunc(NVL(h.pay_amt,0)/a.req_amt*100) < "+gubun7+" \n"; 

		if(gubun5.equals("1"))			query += "  AND NVL(h.pay_amt,0) > 0 \n";
		if(gubun5.equals("2"))			query += "  AND NVL(h.pay_amt,0) = 0 \n";

		if(gubun6.equals("1"))			query += "  AND g.f_doc_reg_dt is not null \n";
		if(gubun6.equals("2"))			query += "  AND g.f_doc_reg_dt is null \n";

		if(gubun6.equals("3"))			query += "  AND nvl(a.req_st,'0')='3' \n";
		if(gubun6.equals("4"))			query += "  AND nvl(a.req_st,'0')<>'3' \n";

		String search = "";
		String what = "";
		
		if(s_kd.equals("1"))	what = "upper(nvl(f.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(e.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(NVL(a.bus_id2,e.bus_id2), ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.ins_com, ' '))";	

		if(!t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}

		if(sort.equals("1"))		query += " order by  decode(a.req_st,'3',1,0), a.ins_com "+asc+", a.req_dt ";
		else if(sort.equals("2"))	query += " order by  decode(a.req_st,'3',1,0), a.req_dt  "+asc;
		else if(sort.equals("3"))	query += " order by  decode(a.req_st,'3',1,0), c.car_no  "+asc+", a.req_dt ";
		else if(sort.equals("4"))	query += " order by  decode(a.req_st,'3',1,0), b.accid_dt  "+asc+", decode(h.pay_amt,0,0,1), a.ins_com ";

//	System.out.println("[AccidDatabase:getAccidS9List]="+query);

		try {
          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){       
				System.out.println("[AccidDatabase:getAccidS9List]="+se);
				System.out.println("[AccidDatabase:getAccidS9List]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

//대차료미납현황_완료현황
	public Vector getAccidS9_2List(String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String gubun7, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";


		query = " SELECT  \n"+
				"        c.car_no, e.rent_dt, b.accid_dt, b.rent_mng_id, b.rent_l_cd, f.firm_nm, \n"+
				"        d.ins_com_f_nm, b.accid_st,  \n"+
				"        a.car_mng_id, a.accid_id, a.seq_no, a.req_st,  \n"+
				"        a.ins_com_id,  \n"+
				"        d.ins_com_f_nm, \n"+
				"        a.ins_com, a.car_no AS d_car_no, a.CAR_NM AS d_car_nm,  \n"+
				"        a.req_amt, a.req_dt, NVL(h.pay_amt,0) pay_amt, h.pay_dt,  \n"+
				"        h.cnt, \n"+
				"        a.req_amt-NVL(h.pay_amt,0) def_amt, trunc(NVL(h.pay_amt,0)/a.req_amt*100) def_per, to_char((NVL(h.pay_amt,0)/a.req_amt*100),'00.00') def_per2, \n"+
			    "        (TRUNC(((a.req_amt-NVL(h.pay_amt,0))*0.05*TRUNC(TO_DATE(NVL(h.pay_dt,a.req_dt), 'YYYYMMDD')- sysdate))/365) * -1) dly_amt, \n"+
				"        TRUNC(sysdate - TO_DATE(NVL(h.pay_dt,a.req_dt), 'YYYYMMDD')) dly_days, \n"+
				"        decode(b.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, \n"+
				"        decode(a.req_gu, '1','휴차료','2','대차료') req_gu, \n"+
				"        a.re_reason, a.doc_req_dt, a.doc_reg_dt, \n"+
				"        NVL(a.bus_id2,e.bus_id2) bus_id2, \n"+
				"        g.f_doc_reg_dt, g.f_doc_cnt \n"+
				" FROM   \n"+
				"        MY_ACCID a, ACCIDENT b, CAR_REG c, INS_COM d, CONT e, client f, \n"+
				"        ( select a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id,  \n"+
				"                 sum(a.ext_pay_amt) pay_amt, MAX(a.ext_pay_dt) pay_dt, COUNT(*) cnt \n"+
				" 		 from   scd_ext a, cont b \n"+
				" 		 where  a.ext_st='6' \n"+
				" 			    and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				" 		 group by a.rent_mng_id, a.rent_l_cd, a.ext_id, b.car_mng_id \n"+
				" 	   ) h, \n"+
				"      ( SELECT car_mng_id, car_no AS accid_id, paid_no AS seq_no, MAX(reg_dt) f_doc_reg_dt, COUNT(*) f_doc_cnt \n"+
				"        FROM   FINE_DOC_LIST \n"+
				"        WHERE  doc_id LIKE '법무%' \n"+
				"        GROUP BY car_mng_id, car_no, paid_no \n"+
				"      ) g \n"+
				" WHERE  nvl(a.req_st,'0') in ('3') AND a.req_amt>0  \n"+
				"        AND a.car_mng_id=b.car_mng_id AND a.accid_id=b.accid_id \n"+
				"        AND b.car_mng_id=c.car_mng_id \n"+
				"        and a.ins_com=d.ins_com_nm(+) \n"+
				"        AND b.rent_mng_id=e.rent_mng_id AND b.rent_l_cd=e.rent_l_cd  and e.rent_l_cd not like 'RM%' \n"+
				"        AND e.client_id=f.client_id "+
				"        and a.car_mng_id=h.car_mng_id(+) and a.accid_id||a.seq_no=h.ext_id(+) \n"+				
				"        and a.car_mng_id=g.car_mng_id(+) and a.accid_id=g.accid_id(+) and a.seq_no=g.seq_no(+) \n"+				
				" ";

		if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.req_dt like replace('"+st_dt+"%', '-','')";
		if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.req_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";


		if(!gubun1.equals(""))			query += "  AND a.req_dt  >= replace('"+gubun1+"','-','') \n"; 
		if(!gubun2.equals(""))			query += "  AND e.rent_dt >= replace('"+gubun2+"','-','') \n"; 
		if(!gubun3.equals(""))			query += "  AND a.req_amt-NVL(h.pay_amt,0) >= replace('"+gubun3+"',',','') \n"; 
		if(!gubun4.equals(""))			query += "  AND TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(a.req_dt,'YYYYMMDD'))) >= "+gubun4+" \n";
		if(!gubun7.equals(""))			query += "  AND a.req_amt-NVL(h.pay_amt,0) >= 0 and trunc(NVL(h.pay_amt,0)/a.req_amt*100) < "+gubun7+" \n"; 

		if(gubun5.equals("1"))			query += "  AND NVL(h.pay_amt,0) > 0 \n";
		if(gubun5.equals("2"))			query += "  AND NVL(h.pay_amt,0) = 0 \n";

		if(gubun6.equals("1"))			query += "  AND g.f_doc_reg_dt is not null \n";
		if(gubun6.equals("2"))			query += "  AND g.f_doc_reg_dt is null \n";

		if(gubun6.equals("3"))			query += "  AND nvl(a.req_st,'0')='3' \n";
		if(gubun6.equals("4"))			query += "  AND nvl(a.req_st,'0')<>'3' \n";

		String search = "";
		String what = "";
		
		if(s_kd.equals("1"))	what = "upper(nvl(f.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(e.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.car_no, ' '))";		
		if(s_kd.equals("4"))	what = "upper(nvl(NVL(a.bus_id2,e.bus_id2), ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.ins_com, ' '))";	

		if(!t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}

		if(sort.equals("1"))		query += " order by  decode(a.req_st,'3',1,0), a.ins_com "+asc+", a.req_dt ";
		else if(sort.equals("2"))	query += " order by  decode(a.req_st,'3',1,0), a.req_dt  "+asc;
		else if(sort.equals("3"))	query += " order by  decode(a.req_st,'3',1,0), c.car_no  "+asc+", a.req_dt ";
		else if(sort.equals("4"))	query += " order by  decode(a.req_st,'3',1,0), b.accid_dt  "+asc+", decode(h.pay_amt,0,0,1), a.ins_com ";

//System.out.println("[AccidDatabase:getAccidS9_2List]="+query);

		try {
          
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){       
				System.out.println("[AccidDatabase:getAccidS9_2List]="+se);
				System.out.println("[AccidDatabase:getAccidS9_2List]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
              
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고이중등록체크리스트
	public Vector getRegChkAccidList() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " SELECT /*+ RULE */ \n"+
				"        b.firm_nm, c1.car_no, d.user_nm, c.car_mng_id, c.accid_id,c.rent_l_cd,  \n"+
				"        decode(c.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, \n"+
				"        c.accid_dt, c.reg_dt, g.user_nm AS reg_nm,  \n"+
				"        DECODE(e.accid_id,'','','등록') serv_st, e.tot_amt, \n"+
				"        DECODE(f.accid_id,'','','등록') res_st, \n"+
				"        (nvl(h.pic_cnt,0)+nvl(h2.pic_cnt2,0)) as pic_cnt, \n"+
				"        i.my_cnt \n"+
				" FROM  \n"+
				"        ( \n"+
				" 	       SELECT car_mng_id, accid_dt, rent_l_cd, COUNT(*)  \n"+
				" 	       FROM   ACCIDENT  \n"+
				" 	       GROUP BY car_mng_id, accid_dt, rent_l_cd  \n"+
				" 	       HAVING COUNT(*)>1 \n"+
				"        ) a, cont_n_view b, car_reg c1,  ACCIDENT c, USERS d, \n"+
				"        (SELECT car_mng_id, accid_id, SUM(tot_amt) tot_amt, MIN(off_id) off_id1, MAX(off_id) off_id2 FROM SERVICE GROUP BY car_mng_id, accid_id) e, \n"+
				"        (SELECT sub_c_id, accid_id FROM RENT_CONT where use_st<>'5' GROUP BY sub_c_id, accid_id) f, \n"+
				"        USERS g, \n"+
				"        (SELECT  accid_id, car_mng_id, COUNT(*) pic_cnt FROM PIC_ACCID GROUP BY accid_id, car_mng_id) h, \n"+
				"        (SELECT  accid_id, car_mng_id, COUNT(*) my_cnt FROM my_ACCID GROUP BY accid_id, car_mng_id) i, \n"+
				"        (select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) accid_id, count(0) pic_cnt2 from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PIC_ACCID' group by content_seq) h2 "+
				" WHERE  a.car_mng_id=b.car_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.use_yn='Y' and a.car_mng_id = c1.car_mng_id  \n"+
				"        AND a.car_mng_id=c.car_mng_id AND a.accid_dt=c.accid_dt \n"+
				"        AND NVL(c.bus_id2,b.bus_id2)=d.user_id \n"+
				"        AND c.car_mng_id=e.car_mng_id(+) AND c.accid_id=e.accid_id(+) \n"+
				"        AND c.car_mng_id=f.sub_c_id(+) AND c.accid_id=f.accid_id(+) \n"+
				"        AND c.reg_id=g.user_id(+) \n"+
				"        AND c.car_mng_id=h.car_mng_id(+) AND c.accid_id=h.accid_id(+) \n"+
				"        AND c.car_mng_id=i.car_mng_id(+) AND c.accid_id=i.accid_id(+) \n"+
			    "        and c.car_mng_id=h2.car_mng_id(+) and c.accid_id=h2.accid_id(+) "+
				" ORDER BY d.user_nm, c.accid_dt DESC \n"+
				" ";

	

		try {
         

			pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
       			System.out.println("[AccidDatabase:getRegChkAccidList]="+se);
       			System.out.println("[AccidDatabase:getRegChkAccidList]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }




//등록전 계약 한건 상세내역 조회
	public Hashtable getRentCaseClient(String m_id, String l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";

		query = " select b.etc_cms "+
				" from cont a, client b"+
				" where a.client_id = b.client_id and a.rent_mng_id =? and a.rent_l_cd=?  ";

	
		try {
          
			pstmt = con.prepareStatement(query);

    		pstmt.setString(1, m_id);
    		pstmt.setString(2, l_cd);

	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
            pstmt.close();	
            
		}catch(SQLException se){
          		System.out.println("[AccidDatabase:getRentCaseClient]="+se);
          		System.out.println("[AccidDatabase:getRentCaseClient]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	//사고기록 리스트
	public Vector getAccidCarHList(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */  "+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id,"+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, a.our_num, a.settle_st, h.pic_cnt,"+
				"        decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(i.cust_st, '1',j.firm_nm, '4',k.user_nm,l.cust_nm) cust_nm, a.reg_dt "+
				" from   accident a, cont_n_view b,  insur e,  car_reg c,  car_etc g1, car_nm cn ,\n"+
				"  (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) f, ins_com g, (select car_mng_id, accid_id, count(*) pic_cnt from pic_accid group by car_mng_id, accid_id) h, rent_cont i, client j, users k, rent_cust l"+
				" where  a.car_mng_id='"+car_mng_id+"' and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and e.car_mng_id=f.car_mng_id and e.ins_st=f.ins_st and e.ins_com_id=g.ins_com_id and a.car_mng_id=e.car_mng_id"+
				"        and a.car_mng_id=h.car_mng_id(+) and a.accid_id=h.accid_id(+)"+
				"        and a.car_mng_id=i.car_mng_id(+) and a.rent_s_cd=i.rent_s_cd(+) and i.cust_id=j.client_id(+) and i.cust_id=k.user_id(+) and i.cust_id=l.cust_id(+) "+
				"	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g1.rent_mng_id(+)  and a.rent_l_cd = g1.rent_l_cd(+)  \n"+
                       		"	and g1.car_id=cn.car_id(+)  and    g1.car_seq=cn.car_seq(+)  \n"+
				" order by a.accid_dt desc ";
	
		try {
         

			pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
       			System.out.println("[AccidDatabase:getAccidSList]="+se);
       			System.out.println("[AccidDatabase:getAccidSList]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//사고종결미처리현황
	public Vector getAccidSettleStat(String loan_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " SELECT a.mng_id, a.t_cnt, a.n_cnt, a.y_cnt, to_char(a.y_per,'999.99') y_per, b.user_nm, b.loan_st, b.dept_id, c.br_nm, d.nm AS dept_nm \n"+
				" FROM \n"+
				"        ( \n"+
				"          select DECODE(c.rent_st,'12',c.mng_id,'',decode(b.car_st,'2',nvl(nvl(a.acc_id,a.reg_id),nvl(b.mng_id,b.bus_id2)),nvl(b.mng_id,b.bus_id2)),c.bus_id) mng_id,  \n"+
				"                 count(*) t_cnt,  \n"+
				"                 COUNT(DECODE(nvl(a.settle_st,'0'),'0',a.rent_l_cd)) n_cnt, \n"+
				"                 COUNT(DECODE(nvl(a.settle_st,'0'),'1',a.rent_l_cd)) y_cnt, \n"+
				"                 trunc(COUNT(DECODE(nvl(a.settle_st,'0'),'1',a.rent_l_cd))/count(*)*100,2) y_per \n"+
				"          from   accident a, cont b, rent_cont c \n"+
				"          where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and b.rent_l_cd not like 'RM%' \n"+
//				"                 and b.use_yn='Y' \n"+
				"                 and a.car_mng_id=c.car_mng_id(+) and a.rent_s_cd=c.rent_s_cd(+) "+
				"          group by DECODE(c.rent_st,'12',c.mng_id,'',decode(b.car_st,'2',nvl(nvl(a.acc_id,a.reg_id),nvl(b.mng_id,b.bus_id2)),nvl(b.mng_id,b.bus_id2)),c.bus_id) \n"+
				"        ) a, USERS b, BRANCH c, (SELECT * FROM CODE WHERE c_st='0002') d \n"+
				" WHERE a.mng_id=b.user_id \n"+
				"       AND b.loan_st='"+loan_st+"' and b.use_yn='Y' \n"+
				"       AND b.br_id=c.br_id AND b.dept_id=d.code \n"+
				" order by b.loan_st, b.dept_id, b.user_id";
	

		try {
        
			
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
             	System.out.println("[AccidDatabase:getAccidSettleStat]="+se);
             	System.out.println("[AccidDatabase:getAccidSettleStat]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	//보험사별대차료입금현황
	public Vector getMyAccidInsComDtStat(String s_yy, String s_mm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " SELECT INS_COM, COUNT(req_dt) req_cnt, SUM(req_amt) req_amt, COUNT(pay_dt) pay_cnt, SUM(pay_amt) pay_amt,  \n"+
				"        decode(SUM(req_amt),0,'0.00',SUM(pay_amt),'100.00',decode(sum(pay_amt),0,'0.00',TO_CHAR(trunc(SUM(pay_amt)/SUM(req_amt)*100,2),'999.99'))) pay_per \n"+
				" FROM \n"+
				"        ( \n"+
				"          SELECT INS_COM, req_dt, req_amt, '' pay_dt, 0 pay_amt FROM  MY_ACCID WHERE req_dt LIKE '"+s_yy+""+s_mm+"%' \n"+
				"          UNION all \n"+
				"          SELECT c.ins_com, '' req_dt, 0 req_amt, a.ext_pay_dt pay_dt, a.ext_pay_amt pay_amt FROM SCD_EXT a, ACCIDENT b, MY_ACCID c  \n"+
				"          WHERE  a.ext_st='6' AND a.ext_pay_dt LIKE '"+s_yy+""+s_mm+"%'  \n"+
				"                 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.car_mng_id=c.car_mng_id AND b.accid_id=c.accid_id AND a.ext_id=c.accid_id||c.seq_no \n"+
				"        )   \n"+
				" GROUP BY INS_COM \n"+
				" ORDER BY INS_COM";
	

		try {
        
			
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
             	System.out.println("[AccidDatabase:getMyAccidInsComDtStat]="+se);
             	System.out.println("[AccidDatabase:getMyAccidInsComDtStat]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	
	//보험사별대차료입금현황
	public Vector getMyAccidInsComDtStat2(String s_yy, String s_mm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String subQuery = "";
		String subQuery2 = "";


		if(!s_mm.equals("")){
			subQuery  += " and a.ext_pay_dt >= '"+s_yy+""+s_mm+"01' "; 
			subQuery2 += " and a.ext_pay_dt like '"+s_yy+""+s_mm+"%' "; 
		}else{
			subQuery  += " and a.ext_pay_dt >= '"+s_yy+"0101' "; 
			subQuery2 += " and a.ext_pay_dt like '"+s_yy+"%' "; 
		}

		query = " SELECT c.ins_com, count(pay_dt) pay_cnt, sum(c.req_amt ) req_amt, sum( e.a_ext_pay_amt ) pay_amt \n"+
				" FROM SCD_EXT a, "+
				" ( select a.rent_mng_id, a.rent_l_cd, b.accid_id, b.ins_com, sum(a.ext_pay_amt) a_ext_pay_amt  \n"+
				" from scd_ext a, my_accid b , accident c \n"+
				" where a.ext_st = '6' "+subQuery+"  \n"+
				" and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  \n"+
				" and c.car_mng_id = b.car_mng_id and c.accid_id = b.accid_id	and a.ext_id=b.accid_id||b.seq_no \n"+
				" group by a.rent_mng_id, a.rent_l_cd , b.accid_id, b.ins_com) e, \n"+
				" ACCIDENT b, MY_ACCID c, car_reg d  \n"+
				" WHERE a.ext_st='6'  "+subQuery2+" AND c.CAR_MNG_ID = d.CAR_MNG_ID  \n"+
				" AND a.rent_mng_id=b.rent_mng_id   AND a.rent_l_cd=b.rent_l_cd  \n"+
				" AND a.rent_mng_id=e.rent_mng_id  and a.rent_l_cd=e.rent_l_cd  and substr(a.ext_id, 1, 6)= e.accid_id and  c.ins_com = e.ins_com \n"+
				" AND b.car_mng_id=c.car_mng_id AND b.accid_id=c.accid_id AND a.ext_id=c.accid_id||c.seq_no group by c.ins_com "+
				"";

		try {
        
			
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
	    //	System.out.println("query="+query);	    	
	    	
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

		}catch(SQLException se){
             	System.out.println("[AccidDatabase:getMyAccidInsComDtStat]="+se);
             	System.out.println("[AccidDatabase:getMyAccidInsComDtStat]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


//보험사별대차료입금현황
	public Vector getMyAccidInsComDtStatYear(int s_yy, String s_mm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String subQuery = "";
		String subQuery2 = "";


		if(!s_mm.equals("")){
			subQuery  += " and a.ext_pay_dt >= '"+s_yy+""+s_mm+"01' "; 
			subQuery2 += " and a.ext_pay_dt like '"+s_yy+""+s_mm+"%' "; 
		}else{
			subQuery  += " and a.ext_pay_dt >= '"+s_yy+"0101' "; 
			subQuery2 += " and a.ext_pay_dt like '"+s_yy+"%' "; 
		}

		query = " SELECT c.ins_com, count(pay_dt) pay_cnt, sum(c.req_amt ) req_amt, sum( e.a_ext_pay_amt ) pay_amt \n"+
				" FROM SCD_EXT a, "+
				" ( select a.rent_mng_id, a.rent_l_cd, b.accid_id, b.ins_com, sum(a.ext_pay_amt) a_ext_pay_amt  \n"+
				" from scd_ext a, my_accid b , accident c \n"+
				" where a.ext_st = '6' "+subQuery+"  \n"+
				" and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  \n"+
				" and c.car_mng_id = b.car_mng_id and c.accid_id = b.accid_id	and a.ext_id=b.accid_id||b.seq_no \n"+
				" group by a.rent_mng_id, a.rent_l_cd , b.accid_id, b.ins_com) e, \n"+
				" ACCIDENT b, MY_ACCID c, car_reg d  \n"+
				" WHERE a.ext_st='6'  "+subQuery2+" AND c.CAR_MNG_ID = d.CAR_MNG_ID  \n"+
				" AND a.rent_mng_id=b.rent_mng_id   AND a.rent_l_cd=b.rent_l_cd  \n"+
				" AND a.rent_mng_id=e.rent_mng_id  and a.rent_l_cd=e.rent_l_cd  and substr(a.ext_id, 1, 6)= e.accid_id and  c.ins_com = e.ins_com \n"+
				" AND b.car_mng_id=c.car_mng_id AND b.accid_id=c.accid_id AND a.ext_id=c.accid_id||c.seq_no group by c.ins_com "+
				"";

		try {
        
			
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
             	System.out.println("[AccidDatabase:getMyAccidInsComDtStat]="+se);
             	System.out.println("[AccidDatabase:getMyAccidInsComDtStat]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }



	//보험사별대차료입금현황
	public Vector getMyAccidInsComDtStatList(String ins_com, String s_yy, String s_mm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " SELECT c.rent_mng_id, c.rent_l_cd, b.car_no, c.accid_dt, a.* \n"+
				" FROM \n"+
				"        ( \n"+
				"          SELECT car_mng_id, accid_id, INS_COM, req_dt, req_amt, '' pay_dt, 0 pay_amt FROM  MY_ACCID WHERE req_dt LIKE '"+s_yy+""+s_mm+"%' \n"+
				"          UNION all \n"+
				"          SELECT c.car_mng_id, c.accid_id, c.ins_com, '' req_dt, 0 req_amt, a.ext_pay_dt pay_dt, a.ext_pay_amt pay_amt FROM SCD_EXT a, ACCIDENT b, MY_ACCID c  \n"+
				"          WHERE  a.ext_st='6' AND a.ext_pay_dt LIKE '"+s_yy+""+s_mm+"%'  \n"+
				"                 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.car_mng_id=c.car_mng_id AND b.accid_id=c.accid_id AND a.ext_id=c.accid_id||c.seq_no \n"+
				"        ) a, CAR_REG b, ACCIDENT c  \n"+
				" WHERE  nvl(a.ins_com,'-')=nvl('"+ins_com+"','-') and a.car_mng_id=b.car_mng_id  AND a.car_mng_id=c.car_mng_id AND a.accid_id=c.accid_id "+
				" ORDER BY a.req_dt, a.pay_dt ";

//	System.out.println("[AccidDatabase:getMyAccidInsComDtStat]="+query);	


		try {
        
			
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
             	System.out.println("[AccidDatabase:getMyAccidInsComDtStat]="+se);
             	System.out.println("[AccidDatabase:getMyAccidInsComDtStat]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


//보험사별대차료입금현황
	public Vector getMyAccidInsComDtStatList2(String ins_com, String s_yy, String s_mm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";
		String subQuery ="";
		String subQuery2 ="";


		if(!s_mm.equals("")){
			subQuery  += " and a.ext_pay_dt >= '"+s_yy+""+s_mm+"01' "; 
			subQuery2 += " and a.ext_pay_dt like '"+s_yy+""+s_mm+"%' "; 
		}else{
			subQuery  += " and a.ext_pay_dt >= '"+s_yy+"0101' "; 
			subQuery2 += " and a.ext_pay_dt like '"+s_yy+"%' "; 
		}

		query = " SELECT c.ins_com, d.car_no, b.ACCID_ID, c.SEQ_NO, c.car_mng_id, b.ACCID_DT, \n"+
				" b.rent_mng_id,  a.rent_l_cd, a.ext_pay_dt AS pay_dt, c.req_dt, c.req_amt, e.a_ext_pay_amt as pay_amt  \n"+
				" FROM SCD_EXT a,  \n"+
				" ( select a.rent_mng_id, a.rent_l_cd, b.accid_id, b.ins_com, sum(a.ext_pay_amt) a_ext_pay_amt  \n"+
				" from scd_ext a, my_accid b , accident c \n"+
				" where a.ext_st = '6' "+subQuery+"       \n"+
				" and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  \n"+
				" and c.car_mng_id = b.car_mng_id and c.accid_id = b.accid_id and a.ext_id=b.accid_id||b.seq_no \n"+
				" and nvl(b.ins_com,'-')=nvl('"+ins_com+"','-') \n"+
				" group by a.rent_mng_id, a.rent_l_cd , b.accid_id, b.ins_com) e,  \n"+
				" ACCIDENT b, MY_ACCID c, car_reg d  \n"+
				" WHERE a.ext_st='6'  "+subQuery2+"  AND c.CAR_MNG_ID = d.CAR_MNG_ID  \n"+
			    " AND a.rent_mng_id=b.rent_mng_id   AND a.rent_l_cd=b.rent_l_cd AND a.rent_mng_id=e.rent_mng_id   \n"+
				" and a.rent_l_cd=e.rent_l_cd  and substr(a.ext_id, 1, 6)= e.accid_id and  c.ins_com = e.ins_com \n"+
				" AND b.car_mng_id=c.car_mng_id  AND b.accid_id=c.accid_id AND a.ext_id=c.accid_id||c.seq_no \n"+
				"";

		try {
			
			pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
             	System.out.println("[AccidDatabase:getMyAccidInsComDtStatList2]="+se);
             	System.out.println("[AccidDatabase:getMyAccidInsComDtStatList2]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
            
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }



     /**
     * 면책금 선청구 정비업체 등록
     */
    public int updateRegServOff(String c_id, String accid_id, String serv_id, String off_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update service set off_id='"+off_id+"'" +
	              " where car_mng_id='"+c_id+"'  and serv_id='"+serv_id+"' ";

				
       try{
            con.setAutoCommit(false);           			
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateRegServOff]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

//해지정산후 수리 - 보유차가 아닌 게약번호로 변경

     /**
     * 사고 계약변호 변경
     */
    public int updateAccidentRent(String c_id, String accid_id, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update accident  set rent_l_cd='"+rent_l_cd+"' , rent_mng_id = '" + rent_mng_id + "'" +
	              " where car_mng_id='"+c_id+"'  and accid_id='"+accid_id+"' ";

				
       try{
            con.setAutoCommit(false);           			
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateAccidentRent]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

      public int updateServicetRent(String c_id, String accid_id, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update service  set rent_l_cd='"+rent_l_cd+"' , rent_mng_id = '" + rent_mng_id + "'" +
	              " where car_mng_id='"+c_id+"'  and accid_id='"+accid_id+"' ";
				
       try{
            con.setAutoCommit(false);           			
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateServicetRent]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
	
	


/**
	 *	정비 견적서 삭제
	 */
	
	public boolean del_accidScanFile(String car_mng_id, String accid_id )throws DatabaseException, DataSourceEmptyException{
        
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		boolean flag = true;

		String query = "delete FROM pic_resrent_accid WHERE car_mng_id = ? and accid_id = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			con.setAutoCommit(true);

			pstmt = con.prepareStatement(query);
				
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, accid_id);
			
		    pstmt.executeUpdate();
			pstmt.close();

			con.commit();
		
		}catch(Exception se){
            try{
				System.out.println("[AccidDatabase:del_accidScanFile]\n"+se);
				flag = false;
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
              
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }  


//대차계약서 스캔파일 불러오기
 public PicResrentAccidBean getScanSearch(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PicResrentAccidBean p_bean = new PicResrentAccidBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from pic_resrent_accid where car_mng_id = ? and accid_id = ? ";

		
        try{
           
			pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());
    		rs = pstmt.executeQuery();
            if (rs.next()){
			    p_bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					//자동차관리번호
				p_bean.setAccid_id(rs.getString("ACCID_ID"));
				p_bean.setSeq(rs.getString("SEQ"));
				p_bean.setFilename(rs.getString("FILENAME"));
				p_bean.setReg_dt(rs.getString("REG_DT"));
				p_bean.setReg_id(rs.getString("REG_ID"));
				

			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[AccidDatabase:getScanSearch]\n"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return p_bean;
    }





	/**
	 *	사고관리 > 보상금관리 > 대차료미납현황에사 바로 대차료청구상태를 최고장종결로 수정.
	 */
	
	public boolean updateIns_req_st(String car_mng_id, String accid_id, String seq )throws DatabaseException, DataSourceEmptyException{
        
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		boolean flag = true;

		String query = "update my_accid set  req_st = '3' WHERE car_mng_id = ? and accid_id = ? and seq_no = ? ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			con.setAutoCommit(true);

			pstmt = con.prepareStatement(query);
				
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, accid_id);
			pstmt.setString(3, seq);
			
		    pstmt.executeUpdate();
			pstmt.close();

			con.commit();
		
		}catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateIns_req_st]\n"+se);
				flag = false;
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
              
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }  


//사고기록 리스트 - 과실확정전 사전결재 
	public Vector getAccidPList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select   "+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, a.acc_id, "+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독')  accid_st_nm, "+
				"        a.our_num, a.settle_st, h2.pic_cnt2 as pic_cnt,"+
				"        decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(i.cust_st, '1',j.firm_nm, '4',k.user_nm,l.cust_nm) cust_nm"+
				" from   accident a, cont_n_view b,  insur e, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) f, ins_com g, "+
				"        (select car_mng_id, accid_id, count(0) pic_cnt from pic_accid group by car_mng_id, accid_id) h, "+
				"        rent_cont i, client j, users k, rent_cust l,  car_reg c,  car_etc g1, car_nm cn, \n"+
				"        (select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) accid_id, count(0) pic_cnt2 from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PIC_ACCID' group by content_seq) h2 "+
				" where  a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and  a.car_mng_id = c.car_mng_id  and e.car_mng_id=f.car_mng_id and e.ins_st=f.ins_st and e.ins_com_id=g.ins_com_id and a.car_mng_id=e.car_mng_id"+
				"        and a.car_mng_id=h.car_mng_id(+) and a.accid_id=h.accid_id(+)"+
				"	     and a.rent_mng_id = g1.rent_mng_id(+)  and a.rent_l_cd = g1.rent_l_cd(+)  \n"+
                "	     and g1.car_id=cn.car_id(+)  and    g1.car_seq=cn.car_seq(+) "+
				"        and a.car_mng_id=i.car_mng_id(+) and a.rent_s_cd=i.rent_s_cd(+) and i.cust_id=j.client_id(+) and i.cust_id=k.user_id(+) and i.cust_id=l.cust_id(+) \n"+
			    "        and a.car_mng_id=h2.car_mng_id(+) and a.accid_id=h2.accid_id(+)  and a.pre_doc = 'P' "+
				" ";
	
		if(s_st.equals("1")){

			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";


			if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
			else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
			else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
			else if(gubun2.equals("5"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
			if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

		}else if(s_st.equals("2")){

			if(!gubun3.equals(""))		query += " and nvl(a.settle_st,'0')='"+gubun3+"'";

			if(gubun4.equals("1") && gubun5.equals("2"))		query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물
			else if(gubun4.equals("1") && gubun5.equals("4"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차
			else if(gubun4.equals("1") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type3,'N')='N' and (a.dam_type2 = 'Y' or a.dam_type4 = 'Y')";//물적(대물+자차)
			else if(gubun4.equals("2") && gubun5.equals("1"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대인
			else if(gubun4.equals("2") && gubun5.equals("3"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//자손
			else if(gubun4.equals("2") && gubun5.equals(""))	query += " and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type4,'N')='N' and (a.dam_type1 = 'Y' or a.dam_type3 = 'Y')";//인적(대인+자손)
			else if(gubun4.equals("3") && gubun5.equals("5"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물+대인
			else if(gubun4.equals("3") && gubun5.equals("6"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//대물+자손
			else if(gubun4.equals("3") && gubun5.equals("7"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차+대인
			else if(gubun4.equals("3") && gubun5.equals("8"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='Y'";//자차+자손
			else if(gubun4.equals("3") && gubun5.equals(""))	query += " and ((a.dam_type1 = 'Y' and a.dam_type2 = 'Y') or (a.dam_type2 = 'Y' and a.dam_type3 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type1 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type3 = 'Y'))";//복합
			else if(gubun4.equals("4") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//미등록
			
			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";

		}else{
		
			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
			if(gubun1.equals("2"))		query += " and c.car_use='2'";
			
			if(s_st.equals("3")){   //과실확정전 사전결재가 아닌 경우만 해당 
				if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
				else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
				else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
				else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
				else if(gubun2.equals("5")){
					if(!st_dt.equals("") && end_dt.equals("")){
						query += " and a.accid_dt like replace('"+st_dt+"%','-','')";
					}else if(!st_dt.equals("") && !end_dt.equals("")){
						query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
					}
				}			
			}
			
			if(!gubun3.equals(""))		query += " and nvl(a.settle_st,'0')='"+gubun3+"'";
			
			if(gubun4.equals("1") && gubun5.equals("2"))		query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물
			else if(gubun4.equals("1") && gubun5.equals("4"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차
			else if(gubun4.equals("1") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type3,'N')='N' and (a.dam_type2 = 'Y' or a.dam_type4 = 'Y')";//물적(대물+자차)
			else if(gubun4.equals("2") && gubun5.equals("1"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대인
			else if(gubun4.equals("2") && gubun5.equals("3"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//자손
			else if(gubun4.equals("2") && gubun5.equals(""))	query += " and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type4,'N')='N' and (a.dam_type1 = 'Y' or a.dam_type3 = 'Y')";//인적(대인+자손)
			else if(gubun4.equals("3") && gubun5.equals("5"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물+대인
			else if(gubun4.equals("3") && gubun5.equals("6"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//대물+자손
			else if(gubun4.equals("3") && gubun5.equals("7"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차+대인
			else if(gubun4.equals("3") && gubun5.equals("8"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='Y'";//자차+자손
			else if(gubun4.equals("3") && gubun5.equals(""))	query += " and ((a.dam_type1 = 'Y' and a.dam_type2 = 'Y') or (a.dam_type2 = 'Y' and a.dam_type3 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type1 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type3 = 'Y'))";//복합
			else if(gubun4.equals("4") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//미등록
			
			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";
			
			
			if(!t_wd.equals("")){

				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
				else if(s_kd.equals("2"))	query += " and b.firm_nm||j.firm_nm||k.user_nm||decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') like '%"+t_wd+"%'";
				else if(s_kd.equals("3"))	query += " and  c.car_no||' '||decode(c.first_car_no,c.car_no,'',c.first_car_no) like '%"+t_wd+"%'";
				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
				else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
				else if(s_kd.equals("8"))	query += " and DECODE(i.rent_st,'12',i.mng_id,'',decode(b.car_st,'2',nvl(nvl(a.acc_id,a.reg_id),nvl(b.mng_id,b.bus_id2)),nvl(b.mng_id,b.bus_id2)),i.bus_id) like '%"+t_wd+"%'";
				else if(s_kd.equals("11"))	query += " and DECODE(i.rent_st,'',b.bus_id2,i.bus_id) like '%"+t_wd+"%'";
				else if(s_kd.equals("12"))	query += " and a.accid_id='"+t_wd+"'";
				else if(s_kd.equals("99"))	query += " and a.car_mng_id = '"+t_wd+"'";
			}
			

		}

		if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
		else if(sort.equals("2"))	query += " order by c.car_no "+asc;
		else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
		else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;




		try {
         

			pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
       			System.out.println("[AccidDatabase:getAccidSList]="+se);
       			System.out.println("[AccidDatabase:getAccidSList]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    
     public int updatePredocDesc(String c_id, String accid_id, String p_doc_desc, String pr_dt ,int pr_amt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update accident  set pre_doc= 'Y',  settle_cont =settle_cont ||', '||'"+  p_doc_desc +"' , "+ 
         				"   sub_etc =sub_etc ||', '||'"+  p_doc_desc +"' , pre_doc_dt =replace('" + pr_dt + "', '-', '')  , pre_doc_amt = " + pr_amt  +
	              " where car_mng_id='"+c_id+"'  and accid_id='"+accid_id+"' ";
	              
	
				
       try{
            con.setAutoCommit(false);           			
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updatePredocDesc]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
     * 면책금 선청구 정비업체 등록
     */
    public int updateServ_dt(String doc_id, String serv_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update fine_doc_list set serv_dt= replace('"+serv_dt+"','-','')" +
	              " where doc_id='"+doc_id+"' ";

				
       try{
            con.setAutoCommit(false);           			
            pstmt = con.prepareStatement(query);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AccidDatabase:updateServ_dt]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    
   	//자산 양수차량 등록 계약리스트 조회
	public Vector getRentCommList( String s_gubun1, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
      String query = "";
             
		 query = " select a.rent_mng_id, a.rent_l_cd, a.dlv_dt , c.sh_base_dt base_dt , b.car_mng_id, b.car_no, b.car_nm, b.fuel_kd, b.init_reg_dt, b.car_doc_no, b.car_use  \n"+
					  "		from cont a, car_reg b , commi c \n"+
					  "	   where a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd \n"+
					  "		 and a.car_mng_id = b.car_mng_id and a.car_gu = '2' and c.agnt_st = '6' \n"+
				//	  "		 and nvl(b.asset_yn, 'N' ) = 'N' \n"+
					  "     and a.car_st =  '2' ";
     
    
		if(s_kd.equals("car_no"))	query += " and b.car_no||' '||b.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("init_reg_dt"))	query += " and  b.init_reg_dt like '"+t_wd+"%'";
		else if(s_kd.equals("rent_dt"))	   query += " and  c.sh_base_dt like '"+t_wd+"%'";
		    
		query += " order by a.rent_dt desc , a.use_yn desc";		
		
//		System.out.println("rentcommlist="+ query);

		try {
         
			pstmt = con.prepareStatement(query);
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
		}catch(SQLException se){
         	  System.out.println("[AccidDatabase:getRentCommList]="+se);
			  throw new DatabaseException();
        }finally{
            try{
                if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	    // 양수차량 정보 
	public Hashtable getContCommDetail(String ch_m_id, String ch_l_cd, String ch_c_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		
		query = " select\n"+
				" a.rent_mng_id, a.rent_l_cd, replace(nvl(b.rent_dt,a.rent_dt),' ','') as rent_dt, c.car_nm, \n"+
				" c.car_no,  a.car_mng_id, a.car_st, d.sh_base_dt base_dt , c.init_reg_dt , c.fuel_kd , c.car_doc_no  \n"+			
				" from cont a, fee b, car_reg c , commi d \n"+	
				" where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd \n"+
				"     and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd \n"+
			   "		and a.car_mng_id = c.car_mng_id and a.car_gu = '2' and d.agnt_st = '6' \n"+
				"     and a.rent_mng_id = '"+ch_m_id+"'"+
				"     and a.rent_l_cd = '"+ch_l_cd+"'" +		
	          "    and a.car_mng_id = '"+ch_c_id+"'";
	
//System.out.println("[ConditionDatabase:getLoanListExcel]\n"+query);

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[AccidDatabase:getContCommDetail]\n"+e);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}
	
	//사고기록 조회팝업 리스트(20181114)
	public Vector getAccidSListPop(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+  merge(b) */  "+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn, "+
				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, "+
				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독') accid_st_nm, "+
				"        nvl(a.sub_firm_nm,'') sub_firm_nm, a.our_ins, e.ins_com, e.ins_nm, e.use_st, e.use_et, e.req_amt, e.req_dt, e.pay_amt, e.pay_dt, a.settle_st, a.settle_st5, "+
				"        a.our_fault_per, (100-a.our_fault_per) ot_fault_per, case when b.mng_id = '' then b.bus_id2 when b.mng_id is null then b.bus_id2 else b.mng_id end bus_id2, e.re_reason, "+
				"        d.ext_pay_amt, e.doc_req_dt, e.doc_reg_dt "+
				" from accident a, cont_n_view b, my_accid e,  car_reg c,  car_etc g, car_nm cn , "+
				"        (select rent_mng_id, rent_l_cd, ext_id, sum(ext_pay_amt) ext_pay_amt from scd_ext where ext_st='6' group by rent_mng_id, rent_l_cd, ext_id) d \n"+
				" where  a.accid_dt >= '20080101' "+
				"        and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id "+
				"	     and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  \n"+
                "	     and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and e.accid_id||to_char(e.seq_no)=d.ext_id "+
				"        and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+) \n"+
                "		 and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) "+
                "		 AND (e.req_gu='2' OR (e.req_gu not IN ('1','2') AND c.car_use NOT IN('1'))) "+
				" ";
			
			query += "	and a.car_mng_id = '"+car_mng_id+"'";
			
			if(!accid_id.equals("")){
				query += "	and a.accid_id = '"+accid_id+"'";
			}
			
			query += " order by a.accid_dt desc";
			
		try {
			pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
       			System.out.println("[AccidDatabase:getAccidSListPop]="+se);
       			System.out.println("[AccidDatabase:getAccidSListPop]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
	
	//사고대차 조회팝업 리스트(반차/연장리스트)(20181205)
	public Vector getRentContCarPop(String car_mng_id, String rent_s_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " select /*+ leading(A H F) index(a RENT_CONT_IDX4) index(i CAR_NM_IDX1) */ \n"+
				"        a.rent_s_cd, a.car_mng_id, a.etc, \n"+
				"        decode(a.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,\n"+
				"        decode(a.cust_st, '','아마존카', '4',e.user_nm, d.client_nm) cust_nm, \n"+
				"        decode(a.cust_st, '','아마존카', '4',e.user_nm, d.firm_nm) firm_nm, \n"+
				"        a.rent_dt, a.rent_start_dt, a.rent_end_dt, a.deli_plan_dt, a.ret_plan_dt, a.deli_dt, a.ret_dt, b.rent_tot_amt, a.brch_id, a.bus_id, \n"+
				"        c.car_no, c.init_reg_dt, c.car_nm, i.car_name, g.user_nm as bus_nm, g2.user_nm as mng_nm, \n"+
				"        c2.car_no as d_car_no, a.cust_id, e.loan_st, replace(a.sub_l_cd,' ','') as sub_l_cd,  \n"+
				"		 c2.car_mng_id as d_car_mng_id, k.rent_mng_id, c2.car_nm AS d_car_nm, h2.car_st as d_car_st \n"+
				" from   RENT_CONT a, RENT_FEE b, CAR_REG c, CLIENT d, USERS e, users g, users g2, \n"+
				"        (select  /*+ index(a CONT_IDX5) */  a.* FROM CONT a, (SELECT car_mng_id, min(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%'   group by car_mng_id) b WHERE a.car_mng_id=b.car_mng_id AND a.rent_l_cd=b.rent_l_cd) h, "+
				"        (select  /*+ index(a CONT_IDX5) */  a.* FROM CONT a, (SELECT car_mng_id, min(rent_l_cd) rent_l_cd from cont where rent_l_cd not like 'RM%'   group by car_mng_id) b WHERE a.car_mng_id=b.car_mng_id AND a.rent_l_cd=b.rent_l_cd) h2, "+
				"        car_reg c2, \n"+
				"        car_etc f, \n"+
				"        car_nm i, CAR_MNG j, cont k \n"+
				" where  a.use_st='2' and a.rent_s_cd=b.rent_s_cd(+) and a.car_mng_id=c.car_mng_id and a.cust_id=d.client_id(+) and a.cust_id=e.user_id(+) \n"+
				"        and a.bus_id=g.user_id(+) and a.mng_id=g2.user_id(+) "+
				"		 and a.car_mng_id=h.car_mng_id "+
				"		 and a.sub_c_id=c2.car_mng_id(+) \n"+
				"        and h.rent_mng_id=f.rent_mng_id and h.rent_l_cd=f.rent_l_cd "+
				"	     and f.car_id=i.car_id and f.car_seq=i.car_seq and i.car_comp_id=j.car_comp_id and i.car_cd=j.code \n "+
				"	     and a.sub_l_cd = k.rent_l_cd \n "+
				"		 and h2.car_mng_id = c2.car_mng_id \n"+
				" ";
			
			if(!car_mng_id.equals("")){
				query += "	and a.car_mng_id = '"+car_mng_id+"'";
			}
			if(!rent_s_cd.equals("")){
				query += "	and a.rent_s_cd = '"+rent_s_cd+"'";
			}
			
			query += " order by a.rent_dt desc";
			
		try {
			pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
       			System.out.println("[AccidDatabase:getRentContCarPop]="+se);
       			System.out.println("[AccidDatabase:getRentContCarPop]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
	
	//사고대차인도 탁송조회팝업 리스트(20181212)
	public Hashtable getConsForAccidPop(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
        String query = "";

		query = " SELECT * FROM( \n"+
				" 		SELECT a.*, b.firm_nm, c.nm as cons_cau_nm, \n"+
				" 			   decode(a.cons_st,'1','편도','2','왕복') as cons_st_nm, 	\n"+
				" 			   nvl(a.from_dt,nvl(a.from_est_dt,a.from_req_dt)) f_dt, 	\n"+
				" 			   nvl(a.to_dt,nvl(a.to_est_dt,a.to_req_dt)) t_dt 	\n"+
				"     	  FROM CONSIGNMENT a, client b, \n"+
				"			   (select * from code where c_st='0015' and code<>'0000') c \n"+
				"     	  WHERE a.client_id=b.client_id(+) AND a.cons_cau=c.nm_cd(+) \n"+
				"			AND a.car_mng_id ='" + car_mng_id + "' \n"+
				"           AND a.cons_cau = '5' \n"+	//사고대차인도 건 조회
				"     	  ORDER BY a.cons_no DESC \n"+
				" ) WHERE ROWNUM = 1 \n"+
				" ";
			
		try {
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}	
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
       			System.out.println("[AccidDatabase:getConsForAccidPop]="+se);
       			System.out.println("[AccidDatabase:getConsForAccidPop]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }
	
	//사고기록 조회팝업 리스트(20190130) - accident table
	public Vector getAccidentListPop(String car_mng_id, String rent_l_cd, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
        String query = "";

		query = " SELECT a.*, b.user_nm as reg_nm, c.car_no, c.car_nm, \n" +
				"		 decode(a.accid_st,'1','피해','2','가해','3','쌍방','8','단독','6','수해') as accid_st_han \n"+
				"   from accident a, users b, car_reg c \n"+
				"   where a.reg_id = b.user_id and a.car_mng_id = c.car_mng_id \n"+
			//	"	  and a.accid_st in('1','3') \n"+
				"     and a.car_mng_id='"+car_mng_id+"'";
		
		if(!rent_l_cd.equals("")){ query +=	"	and a.rent_l_cd='"+rent_l_cd+"'";	}
		
		if(!accid_id.equals("")){ query +=	"	and a.accid_id='"+accid_id+"'";		}
		
		query += "	order by a.accid_dt desc	";
			
		try {
			pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
       			System.out.println("[AccidDatabase:getAccidentListPop]="+se);
       			System.out.println("[AccidDatabase:getAccidentListPop]="+query);
			    throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
	
	 /**
     * 사고종결안된건 여부
     */
    public int getAccidSettleChk(String rent_mng_id , String rent_l_cd ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
		ResultSet rs = null;
        String query = "";
        int su = 0;

		query = " select count(*) "+
				" from   accident "+
				" where  rent_mng_id=? and rent_l_cd=? "+
				"        and nvl(settle_st , '0' ) <> '1'  ";    
       try{
           

			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id); 
			pstmt.setString	(2,		rent_l_cd	); 			
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				su = rs.getInt(1);
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){           
				System.out.println("[AccidDatabase:getAccidSettleChk]\n"+se);

                 throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return su;
    }

    /**
     * 사고종결안된건 여부
     */
    public int getAccidSettleClsCnt(String rent_mng_id , String rent_l_cd ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
		ResultSet rs = null;
        String query = "";
        int su = 0;

		query = " select count(*) "+
				" from   accident "+
				" where  rent_mng_id=? and rent_l_cd=? "+
				"        and nvl(pre_cls , 'N' ) = 'Y' ";    
       try{
           

			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		rent_mng_id); 
			pstmt.setString	(2,		rent_l_cd	); 			
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{				
				su = rs.getInt(1);
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){           
				System.out.println("[AccidDatabase:getAccidSettleChk]\n"+se);

                 throw new DatabaseException("exception");
        }finally{
            try{
               
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return su;
    }	
    
    /**
     * 사고 소송조회 
     */
    public AccidSuitBean getAccidSuitBean(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		AccidSuitBean bean = new AccidSuitBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        
        query = " select * from accid_suit where car_mng_id=? and accid_id=? ";
   
        try{

			pstmt = con.prepareStatement(query);
    		pstmt.setString(1, car_mng_id.trim());
    		pstmt.setString(2, accid_id.trim());    		
    		rs = pstmt.executeQuery();   		    		
    		
            if (rs.next()){
				bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); 					
				bean.setAccid_id(rs.getString("ACCID_ID"));			
				bean.setSuit_type(rs.getString("SUIT_TYPE"));
				bean.setSuit_dt(rs.getString("SUIT_DT"));
				bean.setSuit_no(rs.getString("SUIT_NO"));
				bean.setOur_fault_per	(rs.getInt   ("OUR_FAULT_PER"));
				bean.setJ_fault_per	(rs.getInt   ("J_FAULT_PER"));
				bean.setReq_amt	(rs.getInt   ("REQ_AMT"));
				bean.setReq_id	(rs.getString   ("REQ_ID"));
				bean.setReq_rem	(rs.getString   ("REQ_REM"));
				bean.setReq_dt	(rs.getString("REQ_DT"));
				bean.setMean_dt	(rs.getString("MEAN_DT"));
				bean.setDoc_dt	(rs.getString("DOC_DT"));
				bean.setPay_amt	(rs.getInt   ("PAY_AMT"));
				bean.setPay_dt		(rs.getString("PAY_DT"));				
				bean.setSuit_st(rs.getString("SUIT_ST"));
				bean.setSuit_rem(rs.getString("SUIT_REM"));
				bean.setReg_dt(rs.getString("REG_DT"));
				bean.setReg_id(rs.getString("REG_ID"));
				bean.setUpdate_dt(rs.getString("UPDATE_DT"));
				bean.setUpdate_id(rs.getString("UPDATE_ID"));
				bean.setSuit_amt	(rs.getInt   ("SUIT_AMT"));
				bean.setLoan_amt	(rs.getInt   ("LOAN_AMT"));
			
			}
            
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[getAccidSuitBean]\n"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
        
    /**
     * 자기신체사고-자손 등록.
     */
    public int insertAccidSuit(AccidSuitBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;       
       
        String query = "";     
        int count = 0;
      
        query = " INSERT INTO accid_suit(CAR_MNG_ID, ACCID_ID, suit_type, suit_dt,"+
				" suit_no, our_fault_per, j_fault_per, req_amt, req_dt,"+
				" pay_amt, pay_dt, suit_st, suit_rem, reg_dt, reg_id, req_id, req_rem)\n"+
				" values(?, ?, ?, replace(?,'-',''),  ?, ?, ?, ?, replace(?,'-',''),  ?, replace(?,'-',''), ?, ?, to_char(sysdate,'YYYYMMdd'),  ? ,  ?, ? )\n";
	    
       try{
            con.setAutoCommit(false);
        
            pstmt = con.prepareStatement(query);
            pstmt.setString(1, bean.getCar_mng_id().trim());
			pstmt.setString(2, bean.getAccid_id().trim());			
			pstmt.setString(3, bean.getSuit_type().trim());
			pstmt.setString(4, bean.getSuit_dt().trim());
			
			pstmt.setString(5, bean.getSuit_no().trim());
			pstmt.setInt   (6, bean.getOur_fault_per());  
			pstmt.setInt   (7, bean.getJ_fault_per());  
			pstmt.setInt   (8, bean.getReq_amt());  
			pstmt.setString(9, bean.getReq_dt().trim());
			
			pstmt.setInt   (10, bean.getPay_amt());  
			pstmt.setString(11, bean.getPay_dt().trim());			
			pstmt.setString(12, bean.getSuit_st().trim());
			pstmt.setString(13, bean.getSuit_rem().trim());
			pstmt.setString(14, bean.getReg_id().trim());
			pstmt.setString(15, bean.getReq_id().trim());
			pstmt.setString(16, bean.getReq_rem().trim());
					        
            count = pstmt.executeUpdate();
            
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[insertAccidSuit]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);             
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    
    public boolean deleteAccidSuit(String c_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        boolean result = true;
                
        query = " delete from ACCID_SUIT where car_mng_id='"+c_id+"' and accid_id='"+accid_id+"'";
    
       try{
            con.setAutoCommit(false);

            pstmt = con.prepareStatement(query);
            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
        	result = false;
            try{
				System.out.println("[AccidDatabase:deleteAccidSuit]\n"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return result;
    }
    
   
	
    /**
     * 인적사항 수정
     */
    public int updateAccidSuit(AccidSuitBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update accid_suit  set"+
				" suit_type=?, suit_dt=replace(?,'-',''), suit_no=?, our_fault_per=?, j_fault_per=?,"+
				" req_amt=?, req_dt=replace(?,'-',''), pay_amt=?, pay_dt=replace(?,'-',''), suit_st=?,"+
				" suit_rem=?, UPDATE_DT=to_char(sysdate,'YYYYMMDD'), UPDATE_ID=? ,"+
				" req_id=?, req_rem = ?, mean_dt = replace(?,'-',''), doc_dt=replace(?,'-',''),  "+
				" suit_amt=?, loan_amt = ?  "+
				" where car_mng_id=? and accid_id=? \n";
        	
       try{
            con.setAutoCommit(false);
            			
            pstmt = con.prepareStatement(query);
                                		
			pstmt.setString(1, bean.getSuit_type().trim());
			pstmt.setString(2, bean.getSuit_dt().trim());			
			pstmt.setString(3, bean.getSuit_no().trim());
			pstmt.setInt   (4, bean.getOur_fault_per());  
			pstmt.setInt   (5, bean.getJ_fault_per());  
			
			pstmt.setInt   (6, bean.getReq_amt());  
			pstmt.setString(7, bean.getReq_dt().trim());			
			pstmt.setInt   (8, bean.getPay_amt());  
			pstmt.setString(9, bean.getPay_dt().trim());			
			pstmt.setString(10, bean.getSuit_st().trim());
			
			pstmt.setString(11, bean.getSuit_rem().trim());
			pstmt.setString(12, bean.getUpdate_id().trim());
			
			pstmt.setString(13, bean.getReq_id().trim());			
			pstmt.setString(14, bean.getReq_rem().trim());
			pstmt.setString(15, bean.getMean_dt().trim());
			pstmt.setString(16, bean.getDoc_dt().trim());
		
			pstmt.setInt(17, bean.getSuit_amt());
			pstmt.setInt(18, bean.getLoan_amt());
						
			pstmt.setString(19, bean.getCar_mng_id().trim());
			pstmt.setString(20, bean.getAccid_id().trim());	
		
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[updateAccidSuit]\n"+se);
	
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
       
        return count;
    }
    
    /**
     *  소송일 
     */
    public int updateAccidSuitDoc_dt(String c_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " update accid_suit  set"+
				" doc_dt = to_char(sysdate,'YYYYMMdd')"+
				" where car_mng_id=? and accid_id=? \n";

       try{
            con.setAutoCommit(false);
            			
            pstmt = con.prepareStatement(query);
                              								
			pstmt.setString(1, c_id);
			pstmt.setString(2, accid_id);	
		
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[updateAccidSuitDoc_dt]\n"+se);
	
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
       
        return count;
    }
    

  //사고기록 리스트 - 소송현황 
  	public Vector getAccidSuitList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String brch_id, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String asc, String s_st) throws DatabaseException, DataSourceEmptyException{
          Connection con = connMgr.getConnection(DATA_SOURCE);

          if(con == null)
              throw new DataSourceEmptyException("Can't get Connection !!");

  		PreparedStatement pstmt = null;
  		ResultSet rs = null;
  		Vector vt = new Vector();
          String query = "";

  		query = " select   "+
  				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.client_id, b.firm_nm, b.client_nm, c.car_no, c.car_nm, cn.car_name, b.use_yn,"+
  				"        a.accid_id, a.accid_st, a.accid_dt, a.accid_addr, a.accid_cont, a.accid_cont2, a.reg_id, a.acc_id, "+
  				"        decode(a.accid_st, '1','피해','2','가해','3','쌍방','4','운행자차','5','사고자차','6','수해','7','재리스정비', '8', '단독')  accid_st_nm, "+
  				"        a.our_num, a.settle_st, h2.pic_cnt2 as pic_cnt,"+
  				"        decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
  				"        decode(i.cust_st, '1',j.firm_nm, '4',k.user_nm,l.cust_nm) cust_nm , \n" +
  				"        decode(ass.suit_type, '1','분심위','2','민사소송', 'N', '소송불가' , '' ) suit_nm, ass.suit_dt , ass.mean_dt "+
  				" from   accident a, cont_n_view b,  accid_suit ass, insur e, (select car_mng_id, max(ins_st) ins_st from insur group by car_mng_id) f, ins_com g, "+
  				"        (select car_mng_id, accid_id, count(0) pic_cnt from pic_accid group by car_mng_id, accid_id) h, "+
  				"        rent_cont i, client j, users k, rent_cust l,  car_reg c,  car_etc g1, car_nm cn, \n"+
  				"        (select SUBSTR(content_seq,1,6) car_mng_id, SUBSTR(content_seq,7) accid_id, count(0) pic_cnt2 from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PIC_ACCID' group by content_seq) h2 "+
  				" where  a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
  				"        and  a.car_mng_id = c.car_mng_id  and e.car_mng_id=f.car_mng_id and e.ins_st=f.ins_st and e.ins_com_id=g.ins_com_id and a.car_mng_id=e.car_mng_id"+
  				"        and a.car_mng_id=h.car_mng_id(+) and a.accid_id=h.accid_id(+)"+
  				"        and a.car_mng_id=ass.car_mng_id and a.accid_id=ass.accid_id"+
  				"	     and a.rent_mng_id = g1.rent_mng_id(+)  and a.rent_l_cd = g1.rent_l_cd(+)  \n"+
                  "	     and g1.car_id=cn.car_id(+)  and    g1.car_seq=cn.car_seq(+) "+
  				"        and a.car_mng_id=i.car_mng_id(+) and a.rent_s_cd=i.rent_s_cd(+) and i.cust_id=j.client_id(+) and i.cust_id=k.user_id(+) and i.cust_id=l.cust_id(+) \n"+
  			    "        and a.car_mng_id=h2.car_mng_id(+) and a.accid_id=h2.accid_id(+) "+
  				" ";
  	

  		if(s_st.equals("1")){

  			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
  			if(gubun1.equals("2"))		query += " and c.car_use='2'";


  			if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
  			else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
  			else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
  			else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
  			else if(gubun2.equals("5"))	query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";

  			if(!brch_id.equals("S1") && !brch_id.equals(""))		query += " and b.brch_id = '"+brch_id+"'"; 
  			if(brch_id.equals("S1"))								query += " and b.brch_id in ('S1','K1')"; 

  		}else if(s_st.equals("2")){

  			if(!gubun3.equals(""))		query += " and nvl(a.settle_st,'0')='"+gubun3+"'";

  			if(gubun4.equals("1") && gubun5.equals("2"))		query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물
  			else if(gubun4.equals("1") && gubun5.equals("4"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차
  			else if(gubun4.equals("1") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type3,'N')='N' and (a.dam_type2 = 'Y' or a.dam_type4 = 'Y')";//물적(대물+자차)
  			else if(gubun4.equals("2") && gubun5.equals("1"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대인
  			else if(gubun4.equals("2") && gubun5.equals("3"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//자손
  			else if(gubun4.equals("2") && gubun5.equals(""))	query += " and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type4,'N')='N' and (a.dam_type1 = 'Y' or a.dam_type3 = 'Y')";//인적(대인+자손)
  			else if(gubun4.equals("3") && gubun5.equals("5"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물+대인
  			else if(gubun4.equals("3") && gubun5.equals("6"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//대물+자손
  			else if(gubun4.equals("3") && gubun5.equals("7"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차+대인
  			else if(gubun4.equals("3") && gubun5.equals("8"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='Y'";//자차+자손
  			else if(gubun4.equals("3") && gubun5.equals(""))	query += " and ((a.dam_type1 = 'Y' and a.dam_type2 = 'Y') or (a.dam_type2 = 'Y' and a.dam_type3 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type1 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type3 = 'Y'))";//복합
  			else if(gubun4.equals("4") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//미등록
  			
  			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";

  		}else{
  		
  			if(gubun1.equals("1"))		query += " and c.car_use='1'"; 
  			if(gubun1.equals("2"))		query += " and c.car_use='2'";
  			  			
  			if(s_st.equals("3")){   //과실확정전 사전결재가 아닌 경우만 해당 
  				if(gubun2.equals("1"))		query += " and a.accid_dt like to_char(sysdate,'YYYYMMDD')||'%'";
  				else if(gubun2.equals("2"))	query += " and a.accid_dt like to_char(sysdate,'YYYYMM')||'%'";
  				else if(gubun2.equals("3"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+""+AddUtil.addZero(st_dt)+"%'";
  				else if(gubun2.equals("4"))	query += " and a.accid_dt like '"+AddUtil.getDate(1)+"%'";
  				else if(gubun2.equals("5")){
  					if(!st_dt.equals("") && end_dt.equals("")){
  						query += " and a.accid_dt like replace('"+st_dt+"%','-','')";
  					}else if(!st_dt.equals("") && !end_dt.equals("")){
  						query += " and a.accid_dt between replace('"+st_dt+"','-','') and replace('"+end_dt+"','-','')";
  					}
  				}			
  			}
  			
  			if(!gubun3.equals(""))		query += " and nvl(a.settle_st,'0')='"+gubun3+"'";
  			
  			if(gubun4.equals("1") && gubun5.equals("2"))		query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물
  			else if(gubun4.equals("1") && gubun5.equals("4"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차
  			else if(gubun4.equals("1") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type3,'N')='N' and (a.dam_type2 = 'Y' or a.dam_type4 = 'Y')";//물적(대물+자차)
  			else if(gubun4.equals("2") && gubun5.equals("1"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대인
  			else if(gubun4.equals("2") && gubun5.equals("3"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//자손
  			else if(gubun4.equals("2") && gubun5.equals(""))	query += " and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type4,'N')='N' and (a.dam_type1 = 'Y' or a.dam_type3 = 'Y')";//인적(대인+자손)
  			else if(gubun4.equals("3") && gubun5.equals("5"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//대물+대인
  			else if(gubun4.equals("3") && gubun5.equals("6"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='Y' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='N'";//대물+자손
  			else if(gubun4.equals("3") && gubun5.equals("7"))	query += " and nvl(a.dam_type1,'N')='Y' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='Y'";//자차+대인
  			else if(gubun4.equals("3") && gubun5.equals("8"))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='Y' and nvl(a.dam_type4,'N')='Y'";//자차+자손
  			else if(gubun4.equals("3") && gubun5.equals(""))	query += " and ((a.dam_type1 = 'Y' and a.dam_type2 = 'Y') or (a.dam_type2 = 'Y' and a.dam_type3 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type1 = 'Y') or (a.dam_type4 = 'Y' and a.dam_type3 = 'Y'))";//복합
  			else if(gubun4.equals("4") && gubun5.equals(""))	query += " and nvl(a.dam_type1,'N')='N' and nvl(a.dam_type2,'N')='N' and nvl(a.dam_type3,'N')='N' and nvl(a.dam_type4,'N')='N'";//미등록
  			
  			if(!gubun6.equals(""))		query += " and a.accid_st = '"+gubun6+"'";
  			
  			
  			if(!t_wd.equals("")){

  				if(s_kd.equals("1"))		query += " and b.rent_l_cd like '%"+t_wd+"%'";
  				else if(s_kd.equals("2"))	query += " and b.firm_nm||j.firm_nm||k.user_nm||decode(i.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') like '%"+t_wd+"%'";
  				else if(s_kd.equals("3"))	query += " and  c.car_no||' '||decode(c.first_car_no,c.car_no,'',c.first_car_no) like '%"+t_wd+"%'";
  				else if(s_kd.equals("4"))	query += " and c.car_nm||cn.car_name like '%"+t_wd+"%'";
  				else if(s_kd.equals("5"))	query += " and a.accid_dt like '"+t_wd+"%'";
  				else if(s_kd.equals("6"))	query += " and a.our_num like '%"+t_wd+"%'";
  				else if(s_kd.equals("7"))	query += " and a.reg_id like '%"+t_wd+"%'";
  				else if(s_kd.equals("8"))	query += " and DECODE(i.rent_st,'12',i.mng_id,'',decode(b.car_st,'2',nvl(nvl(a.acc_id,a.reg_id),nvl(b.mng_id,b.bus_id2)),nvl(b.mng_id,b.bus_id2)),i.bus_id) like '%"+t_wd+"%'";
  				else if(s_kd.equals("11"))	query += " and DECODE(i.rent_st,'',b.bus_id2,i.bus_id) like '%"+t_wd+"%'";
  				else if(s_kd.equals("12"))	query += " and a.accid_id='"+t_wd+"'";
  				else if(s_kd.equals("99"))	query += " and a.car_mng_id = '"+t_wd+"'";
  			}
  			

  		}

  		if(sort.equals("1"))		query += " order by b.firm_nm "+asc;
  		else if(sort.equals("2"))	query += " order by c.car_no "+asc;
  		else if(sort.equals("3"))	query += " order by c.car_nm||cn.car_name "+asc;
  		else if(sort.equals("4"))	query += " order by a.accid_dt "+asc;
  		else if(sort.equals("5"))	query += " order by ass.req_dt "+asc;

  

  		try {
           

  			pstmt = con.prepareStatement(query);
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


  		}catch(SQLException se){
         			System.out.println("[AccidDatabase:getAccidSList]="+se);
         			System.out.println("[AccidDatabase:getAccidSList]="+query);
  			    throw new DatabaseException("exception");
          }finally{
              try{
               
                  if(rs != null) rs.close();
                  if(pstmt != null) pstmt.close();
              }catch(SQLException _ignored){}
              connMgr.freeConnection(DATA_SOURCE, con);
  			con = null;
          }
          return vt;
      }
 	
	
 	 /**
     *  과실미확정 소송 종결 
     */
    public boolean updateAccidMean_dt(String c_id, String accid_id, String mean_dt , String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
        boolean flag = true;
        
        query = " update accid_suit set mean_dt = replace(?, '-', '') , update_dt = to_char(sysdate , 'yyyymmdd'), update_id =?  "+
				" where car_mng_id=? and accid_id=? \n";

       try{
            con.setAutoCommit(false);
            			
            pstmt = con.prepareStatement(query);
                 
            pstmt.setString(1, mean_dt);
            pstmt.setString(2, user_id);
			pstmt.setString(3, c_id);
			pstmt.setString(4, accid_id);	
		
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[updateAccidMean_dt]\n"+se);
				flag = false;	
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
       
        return flag;
    }
    
}