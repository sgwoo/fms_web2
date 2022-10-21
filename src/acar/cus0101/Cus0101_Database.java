/**
 * 차량매니저배정 관리
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 11. 17. 월.
 * @ last modify date : 
 */
package acar.cus0101;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;
import acar.common.*;
import acar.client.*;

public class Cus0101_Database
{
	private Connection conn = null;
	public static Cus0101_Database db;
	
	public static Cus0101_Database getInstance()
	{
		if(Cus0101_Database.db == null)
			Cus0101_Database.db = new Cus0101_Database();
		return Cus0101_Database.db;
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
	

//계약 검색 : 리스트 조회(cont,car_reg,client,fee,users,car_pur,car_etc,allot)
	public Vector getContList_View2(String s_kd, String t_wd, String s_brch, String cont_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = "";

		if(s_kd.equals("5")){ //차명조회

			query = " select /*+  merge(a) */ a.* , c.init_reg_dt,  c.car_no, c.car_num, '' cpt_cd ,  '' scan_file , cc.cls_st , decode(c.init_reg_dt, null, 'id', 'ud') as  reg_gubun,  '' car_id , \n" +
					"a.rent_way,  cp.rpt_no ,   decode(cp.reg_ext_dt, '', '', substr(cp.reg_ext_dt, 1, 4) || '-' || substr(cp.reg_ext_dt, 5, 2) || '-'||substr(cp.reg_ext_dt, 7, 2)) REG_EXT_DT   \n"+
					"  from cont_n_view a, car_reg c, cls_cont cc, car_change b , car_pur cp  \n" +
					" where a.car_mng_id=b.car_mng_id and a.car_mng_id = c.car_mng_id \n"+
				         " and a.rent_mng_id = cc.rent_mng_id(+)  and a.rent_l_cd = cc.rent_l_cd(+)  \n"+
				        " and a.rent_mng_id = cp.rent_mng_id(+)  and a.rent_l_cd = cp.rent_l_cd(+)  \n"+
					" and a.brch_id like '%"+ s_brch +"%' and nvl(b.car_no,c.car_no) like '%"+t_wd+"%'";				


			if(cont_st.equals("0"))		query += " and a.rent_st='1' and cc.cls_st is null and a.car_st!='2'"; 
			else if(cont_st.equals("1"))	query += " and a.rent_st='3' and cc.cls_st is null and a.car_st!='2'"; 
			else if(cont_st.equals("2"))	query += " and a.rent_st='5' and cc.cls_st is null and a.car_st!='2'"; 
			else if(cont_st.equals("3"))	query += " and a.rent_st='2' and cc.cls_st is null and a.car_st!='2'"; 
			else if(cont_st.equals("4"))	query += " and a.rent_st='4' and cc.cls_st is null and a.car_st!='2'"; 
			else if(cont_st.equals("5"))	query += " and cc.cls_st is null and a.car_st='2' and nvl(a.use_yn,'Y')='Y'";
			else if(cont_st.equals("6"))	query += " and cc.cls_st = '1'"; 
			else if(cont_st.equals("7"))	query += " and cc.cls_st = '2'"; 
			else if(cont_st.equals("8"))	query += " and cc.cls_st = '3'"; 
			else if(cont_st.equals("9"))	query += " and cc.cls_st = '4'"; 
			else if(cont_st.equals("10"))	query += " and cc.cls_st = '5'"; 
			else if(cont_st.equals("11"))	query += " and cc.cls_st = '6'"; 
			else if(cont_st.equals("12"))	query += " and cc.cls_st = '7'"; 
			else if(cont_st.equals("13"))	query += " and a.rent_st='6' and cc.cls_st is null and a.car_st!='2'";
			else if(cont_st.equals("14"))	query += " and cc.cls_st = '8'";	
			else if(cont_st.equals("23"))	query += " and cc.cls_st = '9'";	
			else if(cont_st.equals("15"))	query += " and a.car_st = '1' and a.rent_way = '1' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("16"))	query += " and a.car_st = '1' and a.rent_way = '2' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("17"))	query += " and a.car_st = '1' and a.rent_way = '3' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("18"))	query += " and a.car_st = '3' and a.rent_way = '1' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("19"))	query += " and a.car_st = '3' and a.rent_way = '2' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("20"))	query += " and a.car_st = '3' and a.rent_way = '3' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("21"))	query += " and a.car_st = '1' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("22"))	query += " and a.car_st = '3' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("23"))	query += " and cc.cls_st = '9'";				
						
			query +=" order by a.car_mng_id desc, a.use_yn desc, a.rent_dt desc, a.reg_dt desc, a.rent_mng_id";

		}else{

			query = " select  /*+  merge(a) */  a.*, c.init_reg_dt, c.car_no, c.car_num, '' cpt_cd , '' scan_file , cc.cls_st ,  decode(c.init_reg_dt, null, 'id', 'ud') as  reg_gubun,  '' car_id,  \n"+
					" a.rent_way,   cp.rpt_no ,   decode(cp.reg_ext_dt, '', '', substr(cp.reg_ext_dt, 1, 4) || '-' || substr(cp.reg_ext_dt, 5, 2) || '-'||substr(cp.reg_ext_dt, 7, 2)) REG_EXT_DT   \n"+
					" from cont_n_view a, car_reg c, cls_cont cc, car_pur cp   where a.car_mng_id = c.car_mng_id \n"+
				         " and a.rent_mng_id = cc.rent_mng_id(+)  and a.rent_l_cd = cc.rent_l_cd(+)  \n"+
				         " and a.rent_mng_id = cp.rent_mng_id(+)  and a.rent_l_cd = cp.rent_l_cd(+)  \n"+
					"and a.brch_id like '%"+ s_brch +"%'";

			if(s_kd.equals("1"))			query += " and upper(nvl(a.rent_l_cd, ' ')) like upper('%"+ t_wd +"%')";
			else if(s_kd.equals("2"))		query += " and nvl(a.rent_dt, ' ') like '%"+ t_wd +"%' ";
			else if(s_kd.equals("3"))		query += " and nvl(a.firm_nm, ' ') like '%"+ t_wd +"%' ";
			else if(s_kd.equals("4"))		query += " and nvl(a.client_nm, ' ') like '%"+ t_wd +"%' ";
//			else if(s_kd.equals("5"))		query += " and (nvl(car_no, ' ') like '%"+ t_wd +"%' or nvl(first_car_no, ' ') like '%"+ t_wd +"%')";
			else if(s_kd.equals("6"))		query += " and nvl(b.init_reg_dt, ' ') like '%"+ t_wd +"%' ";
			else if(s_kd.equals("7"))		query += " and nvl(b.car_num, ' ') like '%"+ t_wd +"%' ";
			else if(s_kd.equals("8"))		query += " and nvl(a.con_mon, ' ') like '%"+ t_wd +"%' ";
			else if(s_kd.equals("9"))		query += " and nvl(a.rent_start_dt, ' ') like '%"+ t_wd +"%' ";
	//		else if(s_kd.equals("10"))		query += " and nvl(cpt_cd, ' ') like '%"+ t_wd +"%' ";
			else if(s_kd.equals("11"))		query += " and nvl(a.rent_end_dt, ' ') like '%"+ t_wd +"%' ";
			else if(s_kd.equals("12"))		
				if(t_wd.equals(""))			query += " and a.bus_id2 is null ";
				else						query += " and a.bus_id2='"+ t_wd +"' ";
			else if(s_kd.equals("13"))		
				if(t_wd.equals(""))			query += " and a.mng_id is null ";
				else						query += " and a.mng_id='"+ t_wd +"' ";

			if(cont_st.equals("0"))			query += " and a.rent_st='1' and cc.cls_st is null and a.car_st!='2'"; 
			else if(cont_st.equals("1"))	query += " and a.rent_st='3' and cc.cls_st is null and a.car_st!='2'"; 
			else if(cont_st.equals("2"))	query += " and a.rent_st='5' and cc.cls_st is null and a.car_st!='2'"; 
			else if(cont_st.equals("3"))	query += " and a.rent_st='2' and cc.cls_st is null and a.car_st!='2'"; 
			else if(cont_st.equals("4"))	query += " and a.rent_st='4' and cc.cls_st is null and a.car_st!='2'"; 
			else if(cont_st.equals("5"))	query += " and cc.cls_st is null and a.car_st='2' and nvl(a.use_yn,'Y')='Y'";
			else if(cont_st.equals("6"))	query += " and cc.cls_st = '1'"; 
			else if(cont_st.equals("7"))	query += " and cc.cls_st = '2'"; 
			else if(cont_st.equals("8"))	query += " and cc.cls_st = '3'"; 
			else if(cont_st.equals("9"))	query += " and cc.cls_st = '4'"; 
			else if(cont_st.equals("10"))	query += " and cc.cls_st = '5'"; 
			else if(cont_st.equals("11"))	query += " and cc.cls_st = '6'"; 
			else if(cont_st.equals("12"))	query += " and cc.cls_st = '7'"; 
			else if(cont_st.equals("13"))	query += " and a.rent_st='6' and cc.cls_st is null and a.car_st!='2'";
			else if(cont_st.equals("14"))	query += " and cc.cls_st = '8'";	
			else if(cont_st.equals("15"))	query += " and a.car_st = '1' and a.rent_way = '1' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("16"))	query += " and a.car_st = '1' and a.rent_way = '2' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("17"))	query += " and a.car_st = '1' and a.rent_way = '3' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("18"))	query += " and a.car_st = '3' and a.rent_way = '1' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("19"))	query += " and a.car_st = '3' and a.rent_way = '2' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("20"))	query += " and a.car_st = '3' and a.rent_way = '3' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("21"))	query += " and a.car_st = '1' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("22"))	query += " and a.car_st = '3' and nvl(a.use_yn,'Y')='Y'";	
			else if(cont_st.equals("23"))	query += " and cc.cls_st = '9'";	


			query +=" order by a.use_yn desc, a.rent_dt, a.rent_mng_id";
		}

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
			    bean.setCar_num(rs.getString("CAR_NUM"));						//차대번호
			    bean.setRent_way(rs.getString("RENT_WAY"));					//대여방식
			    bean.setCon_mon(rs.getString("CON_MON"));						//대여개월
			    bean.setCar_id(rs.getString("CAR_ID"));						//차명ID
			    bean.setRent_start_dt(rs.getString("RENT_START_DT"));				//대여개시일
			    bean.setRent_end_dt(rs.getString("RENT_END_DT"));					//대여종료일
			    bean.setReg_ext_dt(rs.getString("REG_EXT_DT"));					//등록예정일?
			    bean.setRpt_no(rs.getString("RPT_NO"));						//계출번호
			    bean.setCpt_cd(rs.getString("CPT_CD"));						//은행코드
			    bean.setBus_id2(rs.getString("BUS_ID2"));					
			    bean.setMng_id(rs.getString("MNG_ID"));					
				bean.setUse_yn(rs.getString("USE_YN"));					
				bean.setRent_st(rs.getString("RENT_ST"));					
				bean.setCls_st(rs.getString("CLS_ST"));					
				bean.setCar_st(rs.getString("CAR_ST"));					
				bean.setScan_file(rs.getString("SCAN_FILE"));					
			    
			    rtn.add(bean);
            }
             rs.close();
             pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Cus0101_Database:getContList_View2]\n"+e);
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