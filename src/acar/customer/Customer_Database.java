package acar.customer;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.util.*;
import java.text.*;
import acar.database.*;
import acar.common.*;

public class Customer_Database
{
	private Connection conn = null;
	public static Customer_Database db;
	
	public static Customer_Database getInstance()
	{
		if(Customer_Database.db == null)
			Customer_Database.db = new Customer_Database();
		return Customer_Database.db;
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
    * 자동차 정비건 견적서 ; 부품,작업 등록 2004.7.26.
    */
	public int insertServItem(Customer_Bean bean){

		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		String query,query1 = "";
		int result = 0;
		int seq_no = 0;		
		int chk = 0;

		query  = " INSERT INTO serv_item(car_mng_id,serv_id,seq_no,item_st,item_id,item,wk_st,count,price,amt,labor,bpm,item_cd,reg_id,reg_dt, regcode ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,to_char(sysdate,'YYYYMMDD'), ?)";

		query1 = " SELECT NVL(MAX(seq_no)+1,1) FROM serv_item WHERE car_mng_id=? AND serv_id=?";
		
		//입력체크
		String query2 = "select count(0) from serv_item where car_mng_id=? and serv_id=? and seq_no=?";

		try{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query1);
			pstmt2.setString(1, bean.getCar_mng_id());
			pstmt2.setString(2, bean.getServ_id());
			rs = pstmt2.executeQuery();
			if(rs.next()){
				seq_no = rs.getInt(1);
			}
			rs.close();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query2);
			pstmt3.setString(1, bean.getCar_mng_id());
			pstmt3.setString(2, bean.getServ_id());
			pstmt3.setInt	(3, seq_no);
	    	rs2 = pstmt3.executeQuery();
			if(rs2.next()){
				chk = rs2.getInt(1);	
			}
			rs2.close();
			pstmt3.close();

			if(chk==0){
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,  bean.getCar_mng_id	());
				pstmt.setString	(2,  bean.getServ_id	());
				pstmt.setInt	(3,  seq_no				  );
				pstmt.setString	(4,  bean.getItem_st	());
				pstmt.setString	(5,  bean.getItem_id	());
				pstmt.setString	(6,  bean.getItem		());
				pstmt.setString	(7,  bean.getWk_st		());
				pstmt.setInt	(8,  bean.getCount		());
				pstmt.setInt	(9,  bean.getPrice		());
				pstmt.setInt	(10, bean.getAmt		());
				pstmt.setInt	(11, bean.getLabor		());
				pstmt.setString	(12, bean.getBpm		());
				pstmt.setString	(13, bean.getItem_cd	());
				pstmt.setString	(14, bean.getReg_id		());
				pstmt.setString	(15, bean.getRegcode	());
				result = pstmt.executeUpdate();
				pstmt.close();
			}
			conn.commit();

		}catch(Exception e){
			System.out.println("[Customer_Database:insertServItem(Customer_Bean bean)]"+e);

			System.out.println("[bean.getCar_mng_id	()]"+bean.getCar_mng_id	());
			System.out.println("[bean.getServ_id	()]"+bean.getServ_id	());
			System.out.println("[seq_no				  ]"+seq_no				  );
			System.out.println("[bean.getItem_st	()]"+bean.getItem_st	());
			System.out.println("[bean.getItem_id	()]"+bean.getItem_id	());
			System.out.println("[bean.getItem		()]"+bean.getItem		());
			System.out.println("[bean.getWk_st		()]"+bean.getWk_st		());
			System.out.println("[bean.getCount		()]"+bean.getCount		());
			System.out.println("[bean.getPrice		()]"+bean.getPrice		());
			System.out.println("[bean.getAmt		()]"+bean.getAmt		());
			System.out.println("[bean.getLabor		()]"+bean.getLabor		());
			System.out.println("[bean.getBpm		()]"+bean.getBpm		());
			System.out.println("[bean.getItem_cd	()]"+bean.getItem_cd	());
			System.out.println("[bean.getReg_id		()]"+bean.getReg_id		());

			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
				if(rs2 != null) rs2.close();
			          if(pstmt != null) pstmt.close();
			          if(pstmt2 != null) pstmt2.close();
			          if(pstmt3 != null) pstmt3.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	} 


/**
    * 자동차 정비건 견적서 ; 부품,작업 등록 2004.7.26.
    */
	public int updateServItem(Customer_Bean bean){

		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;

		query = "UPDATE serv_item SET item_st=?,item_id=?,item=?,wk_st=?,count=?,price=?,amt=?,labor=?,bpm=?,item_cd=? WHERE car_mng_id=? AND serv_id=? AND seq_no=? ";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getItem_st());
			pstmt.setString(2, bean.getItem_id());
			pstmt.setString(3, bean.getItem());
			pstmt.setString(4, bean.getWk_st());
			pstmt.setInt(5, bean.getCount());
			pstmt.setInt(6, bean.getPrice());
			pstmt.setInt(7, bean.getAmt());
			pstmt.setInt(8, bean.getLabor());
			pstmt.setString(9, bean.getBpm());
			pstmt.setString(10, bean.getItem_cd());
			pstmt.setString(11, bean.getCar_mng_id());
			pstmt.setString(12, bean.getServ_id());
			pstmt.setInt(13, bean.getSeq_no());

			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		 }catch(Exception se){
		 	System.out.println("[Customer_Database:updateServItem(Customer_Bean bean)]"+se);	
            try{
                conn.rollback();
            }catch(SQLException _ignored){}

		}finally{
			try{
			conn.setAutoCommit(true);
          		 if(pstmt != null) pstmt.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	} 


	//차량번호로 차량관리번호 가져가기
	public Hashtable Serach(String car_no, String js_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

query = "SELECT a.car_mng_id CAR_MNG_ID, b.rent_mng_id RENT_MNG_ID, b.rent_l_cd RENT_L_CD, a.car_no CAR_NO, n.car_nm CAR_JNM, d.car_name CAR_NM, a.car_num CAR_NUM, a.init_reg_dt INIT_REG_DT, a.car_kd CAR_KD, a.car_use CAR_USE, a.car_form CAR_FORM, a.car_y_form CAR_Y_FORM, a.mot_form MOT_FORM, c.colo COLO, a.dpm DPM, a.conti_rat CONTI_RAT, a.fuel_kd FUEL_KD, e.age_scp AGE_SCP, e.ins_com_nm INS_COM_NM, e.ins_start_dt INS_START_DT, e.ins_exp_dt INS_EXP_DT, e.agnt_imgn_tel AGNT_IMGN_TEL, e.acc_tel ACC_TEL, e.vins_spe VINS_SPE, e.vins_cacdt_amt VINS_CACDT_AMT, f.che_st_dt CHE_ST_DT, f.che_end_dt CHE_END_DT, a.first_serv_dt FIRST_SERV_DT, a.cycle_serv CYCLE_SERV, a.tot_serv TOT_SERV, b.mng_id MNG_ID, a.guar_gen_y GUAR_GEN_Y, a.guar_gen_km, a.guar_endur_y, a.guar_endur_km, a.maint_st_dt, a.maint_end_dt, a.test_st_dt, a.test_end_dt "+
					", vt.tot_dist as TOT_DIST "+
					", decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST " +
					", decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST " +
			" FROM car_reg a, cont b, car_etc c, car_nm d, car_mng n, v_tot_dist vt  "+
				", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_start_dt INS_START_DT, ir.ins_exp_dt INS_EXP_DT, ir.age_scp AGE_SCP, ir.agnt_imgn_tel AGNT_IMGN_TEL, ir.acc_tel ACC_TEL, ir.vins_spe VINS_SPE, ir.vins_cacdt_amt VINS_CACDT_AMT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) e "+
				", (select a.car_mng_id CAR_MNG_ID, a.che_st_dt CHE_ST_DT, a.che_end_dt CHE_END_DT from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id= car_mng_id)) f "+
			" WHERE a.car_mng_id = b.car_mng_id "+
			" AND nvl(b.use_yn,'Y') = 'Y' "+
			" AND b.rent_mng_id = c.rent_mng_id "+
			" AND b.rent_l_cd = c.rent_l_cd "+
			" AND c.car_id = d.car_id "+
			" AND c.car_seq = d.car_seq "+
			" AND d.car_comp_id = n.car_comp_id "+
			" AND d.car_cd = n.code "+
			" AND a.car_mng_id = vt.car_mng_id(+) "+
			" AND a.car_mng_id = e.car_mng_id "+
			" AND a.car_mng_id = f.car_mng_id(+) "+
			" AND a.car_no = '"+car_no+"' ";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[Customer_Database:Serach]"+e);
			System.out.println("[Customer_Database:Serach]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}


	/**
    * 자동차 정비건 작업 및 부품 중복조회
    */
    public int getServ_itemCheck(String car_mng_id, String serv_id, String item, int labor, int amt){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        String query = "";
        
		query = "SELECT count(0) "+
				"  FROM serv_item "+
				" WHERE car_mng_id = ? AND serv_id = ? AND item = ? AND labor = ? AND amt = ? ";

        try{
            pstmt = conn.prepareStatement(query);
    		pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			pstmt.setString(3, item);
			pstmt.setInt   (4, labor);
			pstmt.setInt   (5, amt);
    		rs = pstmt.executeQuery();

            if(rs.next()){                
				count = rs.getInt(1);
            }

			rs.close();
			pstmt.close();

        }catch(SQLException e){
			 System.out.println("[Customer_Database:getServ_itemCheck()]"+e);
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


	/**
    * 자동차 정비건 작업 및 부품 중복조회
    */
    public int getServiceCheck(String car_mng_id, String serv_id){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        String query = "";
        
		query = "SELECT count(0) "+
				"  FROM service "+
				" WHERE car_mng_id = ? AND serv_id = ?  ";

        try{
            pstmt = conn.prepareStatement(query);
    		pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
    		rs = pstmt.executeQuery();

            if(rs.next()){                
				count = rs.getInt(1);
            }

			rs.close();
			pstmt.close();

        }catch(SQLException e){
			 System.out.println("[Customer_Database:getServ_itemCheck()]"+e);
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

/**
	*	정비작업 이나 부품 전체 삭제하기 2004.7.27.
	*/
	public int delServ_item_all(String car_mng_id, String serv_id){
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "DELETE serv_item WHERE car_mng_id=? AND serv_id=? ";		


		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_id);
			result = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		 }catch(Exception se){
		 	System.out.println("[Customer_Database:delServ_item_all(String car_mng_id, String serv_id)]"+se);
            try{
                conn.rollback();
            }catch(SQLException _ignored){}	
		}finally{
			try{
			    conn.setAutoCommit(true);
               		   if(pstmt != null) pstmt.close();
            
            }catch(SQLException _ignored){}
			closeConnection();
		}
		return result;
	}


	/**
	 * 차량관리번호로 정비순번 조회 2004.7.19.
	 */
	public String getServ_id(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String serv_id = "";

		query = "SELECT NVL(LPAD(MAX(serv_id)+1,6,'0'),'000001') FROM service WHERE car_mng_id=? and serv_id not like 'NN%'";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				serv_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();	
		}catch(SQLException e){
			System.out.println("[Customer_Database:getServ_id(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return serv_id;
		}
	}


	/**
	 * 차량관리번호로 정비순번 조회 2004.7.19.
	 */
	 /*
	public String getServ_id2(String car_mng_id){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String serv_id = "";

		query = "SELECT car_mng_id, sum( amt ), NVL(LPAD(MAX(serv_id),6,'0'),'000001') FROM serv_item WHERE car_mng_id=? and serv_id not like 'NN%' group by car_mng_id ";
		
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				serv_id = rs.getString(1)==null?"":rs.getString(1);
			}
		}catch(SQLException e){
			System.out.println("[Customer_Database:getServ_id2(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return serv_id;
		}
	}
	*/

public Hashtable getServ_id2(String car_mng_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht2 = new Hashtable();
		int count = 0;

		String query = "";

		query = "SELECT car_mng_id, sum( amt ) as amt,  SUM(labor) AS labor, NVL(LPAD(MAX(serv_id),6,'0'),'000001') as serv_id FROM serv_item WHERE car_mng_id= '"+car_mng_id+"' and serv_id = '"+serv_id+"' and serv_id not like 'NN%' group by car_mng_id ";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht2.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[Customer_Database:getServ_id2]"+e);
			System.out.println("[Customer_Database:getServ_id2]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht2;
		}
	}



	/**
	 *	자동차관리번호로 계약관리번호, 계약번호 가져오기 2003.10.16.목. Yongsoon Kwon
	 */
public Hashtable getRent_id(String car_mng_id)	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query =  " SELECT a.rent_mng_id, a.rent_l_cd "+
						" FROM cont a"+
						" WHERE a.car_mng_id='"+car_mng_id+"'"+
						" AND nvl(a.use_yn,'Y')='Y'"+
						" ";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();	

		} catch (SQLException e) {
			System.out.println("[Customer_Database:getMaster_Car]"+e);
			System.out.println("[Customer_Database:getMaster_Car]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}


	/**
	*	 일반정비/보증정비 등록 2004.8.2.
	*/
	public int updateService_g(ServInfoBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		String query = "";
		int result = 0;
				
		query = " UPDATE service SET "+
				"   rent_mng_id	=?,"+
				"   rent_l_cd	=?,"+
				"	serv_st		=?,"+
				"	serv_jc		=?,"+
				"	serv_dt		=replace(?,'-',''),"+
				"	off_id		=?,"+
				"	ipgoza		=?,"+
				"	ipgodt		=replace(?,'-',''),"+
				"	chulgoza	=?,"+
				"	chulgodt	=replace(?,'-',''),"+
				"	cust_nm		=?,"+
				"	cust_tel	=?,"+
				"	cust_rel	=?,"+
				"	sup_amt		=?,"+
				"	add_amt		=?,"+
				"	rep_amt		=?,"+
				"	dc			=?,"+
				"	tot_amt		=?,"+
				"	checker		=?,"+
				"	spdchk_dt	=replace(?,'-',''),"+
				"	tot_dist	=?,"+
				"	next_serv_dt=replace(?,'-',''),"+
				"	rep_cont	=?,"+
				"	checker_st	=?,"+ 
				"	accid_id	=?,"+
				"	cust_act_dt	=replace(?,'-',''),"+
				"	set_dt		=replace(?,'-',''),"+
				"	update_id	=?,"+
				"	update_dt	=to_char(sysdate,'YYYYMMDD'), "+
				"	r_labor		=?,"+
				"	r_amt		=?,"+
				"	r_dc		=?,"+
				"	r_j_amt		=? "+
				" WHERE car_mng_id=? AND serv_id=? ";
		
		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getRent_mng_id	());
			pstmt.setString(2,  bean.getRent_l_cd	());
			pstmt.setString(3,  bean.getServ_st		());
			pstmt.setString(4,  bean.getServ_jc		());
			pstmt.setString(5,  bean.getServ_dt		());
			pstmt.setString(6,  bean.getOff_id		());
			pstmt.setString(7,  bean.getIpgoza		());
			pstmt.setString(8,  bean.getIpgodt		());
			pstmt.setString(9,  bean.getChulgoza	());
			pstmt.setString(10, bean.getChulgodt	());
			pstmt.setString(11, bean.getCust_nm		());
			pstmt.setString(12, bean.getCust_tel	());
			pstmt.setString(13, bean.getCust_rel	());
			pstmt.setInt   (14, bean.getSup_amt		());
			pstmt.setInt   (15, bean.getAdd_amt		());
			pstmt.setInt   (16, bean.getRep_amt		());
			pstmt.setInt   (17, bean.getDc			());
			pstmt.setInt   (18, bean.getTot_amt		());
			pstmt.setString(19, bean.getChecker		());
			pstmt.setString(20, bean.getSpdchk_dt	());
			pstmt.setInt   (21, AddUtil.parseInt(bean.getTot_dist()));
			pstmt.setString(22, bean.getNext_serv_dt());
			pstmt.setString(23, bean.getRep_cont	());
			pstmt.setString(24, bean.getChecker_st	());
			pstmt.setString(25, bean.getAccid_id	());
			pstmt.setString(26, bean.getCust_act_dt	());
			pstmt.setString(27, bean.getSet_dt		());
			pstmt.setString(28, bean.getUpdate_id	());
			pstmt.setInt   (29, bean.getR_labor		());
			pstmt.setInt   (30, bean.getR_amt		());
			pstmt.setInt   (31, bean.getR_dc		());
			pstmt.setInt   (32, bean.getR_j_amt		());		
			pstmt.setString(33, bean.getCar_mng_id	());
			pstmt.setString(34, bean.getServ_id		());
						
			result = pstmt.executeUpdate();
 			pstmt.close();
			conn.commit();
		}catch(Exception e){
			System.out.println("[Customer_Database:updateService_g(ServInfoBean bean)]"+e);

			System.out.println("[bean.getRent_mng_id	()]"+bean.getRent_mng_id	());
			System.out.println("[bean.getRent_l_cd		()]"+bean.getRent_l_cd		());
			System.out.println("[bean.getServ_st		()]"+bean.getServ_st		());
			System.out.println("[bean.getServ_jc		()]"+bean.getServ_jc		());
			System.out.println("[bean.getServ_dt		()]"+bean.getServ_dt		());
			System.out.println("[bean.getOff_id			()]"+bean.getOff_id			());
			System.out.println("[bean.getIpgoza			()]"+bean.getIpgoza			());
			System.out.println("[bean.getIpgodt			()]"+bean.getIpgodt			());
			System.out.println("[bean.getChulgoza		()]"+bean.getChulgoza		());
			System.out.println("[bean.getChulgodt		()]"+bean.getChulgodt		());
			System.out.println("[bean.getCust_nm		()]"+bean.getCust_nm		());
			System.out.println("[bean.getCust_tel		()]"+bean.getCust_tel		());
			System.out.println("[bean.getCust_rel		()]"+bean.getCust_rel		());
			System.out.println("[bean.getSup_amt		()]"+bean.getSup_amt		());
			System.out.println("[bean.getAdd_amt		()]"+bean.getAdd_amt		());
			System.out.println("[bean.getRep_amt		()]"+bean.getRep_amt		());
			System.out.println("[bean.getDc				()]"+bean.getDc				());
			System.out.println("[bean.getTot_amt		()]"+bean.getTot_amt		());
			System.out.println("[bean.getChecker		()]"+bean.getChecker		());
			System.out.println("[bean.getSpdchk_dt		()]"+bean.getSpdchk_dt		());
			System.out.println("[bean.getTot_dist		()]"+bean.getTot_dist		());
			System.out.println("[bean.getNext_serv_dt	()]"+bean.getNext_serv_dt	());
			System.out.println("[bean.getRep_cont		()]"+bean.getRep_cont		());
			System.out.println("[bean.getChecker_st		()]"+bean.getChecker_st		());
			System.out.println("[bean.getAccid_id		()]"+bean.getAccid_id		());
			System.out.println("[bean.getCust_act_dt	()]"+bean.getCust_act_dt	());
			System.out.println("[bean.getSet_dt			()]"+bean.getSet_dt			());
			System.out.println("[bean.getUpdate_id		()]"+bean.getUpdate_id		());
			System.out.println("[bean.getR_labor		()]"+bean.getR_labor		());
			System.out.println("[bean.getR_amt			()]"+bean.getR_amt			());
			System.out.println("[bean.getR_dc			()]"+bean.getR_dc			());
			System.out.println("[bean.getR_j_amt		()]"+bean.getR_j_amt		());
			System.out.println("[bean.getCar_mng_id		()]"+bean.getCar_mng_id		());
			System.out.println("[bean.getServ_id		()]"+bean.getServ_id		());

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
	*	 순회점검 등록 2004.7.19.
	*/
	public int insertService(ServInfoBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String query, query1, query2 = "";
		int result = 0;

	
		query2 = "INSERT INTO service(car_mng_id, serv_id, rent_mng_id, rent_l_cd, off_id, serv_st, serv_dt, checker, spdchk_dt, tot_dist, next_serv_dt, rep_cont, next_rep_cont, checker_st, spdchk, r_amt, r_j_amt, r_labor, sup_amt, add_amt, rep_amt, dc, tot_amt, set_dt, reg_id, reg_dt,accid_id ) VALUES(?,?,?,?,?,?,replace(?,'-',''),?,replace(?,'-',''),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?, to_char(sysdate,'YYYYMMDD'),?) ";
		query1 = "SELECT car_mng_id, serv_id FROM service WHERE car_mng_id=? AND serv_id=? ";
		query = " UPDATE service SET rent_mng_id=?,rent_l_cd=?,off_id=?,serv_st=?,serv_dt=replace(?,'-',''),checker=?,spdchk_dt=replace(?,'-',''),tot_dist=?,next_serv_dt=?,rep_cont=?,next_rep_cont=?,checker_st=?,spdchk=?,r_amt=?,r_j_amt=?,r_labor=?,sup_amt=?, add_amt=?, rep_amt=?, dc=?, tot_amt=?, set_dt=?, update_id=?, update_dt=to_char(sysdate,'YYYYMMDD') WHERE car_mng_id = ? AND serv_id = ? ";

		try{

			conn.setAutoCommit(false);

			if(bean.getRent_mng_id().equals("")||bean.getRent_l_cd().equals("")){
				CommonDataBase c_db = CommonDataBase.getInstance();
				Hashtable ht = c_db.getRent_id(bean.getCar_mng_id());
				bean.setRent_mng_id((String)ht.get("RENT_MNG_ID"));
				bean.setRent_l_cd((String)ht.get("RENT_L_CD"));
			}
			if(bean.getServ_st().equals("1"))	bean.setOff_id("000086");	//순회점검

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, bean.getCar_mng_id());
			pstmt.setString(2, bean.getServ_id());
			rs = pstmt.executeQuery();
			if(rs.next()){
				pstmt2 = conn.prepareStatement(query);
				pstmt2.setString	(1, bean.getRent_mng_id());
				pstmt2.setString	(2, bean.getRent_l_cd());
				pstmt2.setString	(3, bean.getOff_id());
				pstmt2.setString	(4, bean.getServ_st());
				pstmt2.setString	(5, bean.getServ_dt());
				pstmt2.setString	(6, bean.getChecker());
				pstmt2.setString	(7, bean.getSpdchk_dt());
				pstmt2.setInt	(8, AddUtil.parseInt(bean.getTot_dist()));
				pstmt2.setString	(9, bean.getNext_serv_dt());
				pstmt2.setString	(10, bean.getRep_cont());
				pstmt2.setString	(11, bean.getNext_rep_cont());
				pstmt2.setString	(12, bean.getChecker_st());
				pstmt2.setString	(13, bean.getSpd_chk());
				pstmt2.setInt	(14, bean.getR_amt());
				pstmt2.setInt	(15, bean.getR_j_amt());
				pstmt2.setInt	(16, bean.getR_labor());
				pstmt2.setInt	(17, bean.getSup_amt());
				pstmt2.setInt	(18, bean.getAdd_amt());
				pstmt2.setInt	(19, bean.getRep_amt());
				pstmt2.setInt	(20, bean.getDc());
				pstmt2.setInt	(21, bean.getTot_amt());
				pstmt2.setString	(22, bean.getSet_dt());
				pstmt2.setString	(23, bean.getReg_id());
				pstmt2.setString	(24, bean.getCar_mng_id());
				pstmt2.setString	(25, bean.getServ_id());
				result = pstmt2.executeUpdate();
				pstmt2.close();
			}else{ //등록
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.setString	(1, bean.getCar_mng_id());
				pstmt2.setString	(2, bean.getServ_id());
				pstmt2.setString	(3, bean.getRent_mng_id());
				pstmt2.setString	(4, bean.getRent_l_cd());
				pstmt2.setString	(5, bean.getOff_id());
				pstmt2.setString	(6, bean.getServ_st());
				pstmt2.setString	(7, bean.getServ_dt());
				pstmt2.setString	(8, bean.getChecker());
				pstmt2.setString	(9, bean.getSpdchk_dt());
				pstmt2.setInt	(10, AddUtil.parseInt(bean.getTot_dist()));
				pstmt2.setString	(11, bean.getNext_serv_dt());
				pstmt2.setString	(12, bean.getRep_cont());
				pstmt2.setString	(13, bean.getNext_rep_cont());
				pstmt2.setString	(14, bean.getChecker_st());
				pstmt2.setString	(15, bean.getSpd_chk());
				pstmt2.setInt	(16, bean.getR_amt());
				pstmt2.setInt	(17, bean.getR_j_amt());
				pstmt2.setInt	(18, bean.getR_labor());
				pstmt2.setInt	(19, bean.getSup_amt());
				pstmt2.setInt	(20, bean.getAdd_amt());
				pstmt2.setInt	(21, bean.getRep_amt());
				pstmt2.setInt	(22, bean.getDc());
				pstmt2.setInt	(23, bean.getTot_amt());
				pstmt2.setString	(24, bean.getSet_dt());
				pstmt2.setString	(25, bean.getReg_id());
				pstmt2.setString	(26, bean.getAccid_id());
				result = pstmt2.executeUpdate();
				pstmt2.close();
			}
			rs.close();
			pstmt.close();	

			conn.commit();
		}catch(Exception e){
			System.out.println("[Customer_Database:insertService(ServInfoBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
              	if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}
	}


	/**
	 * 점포명으로 업체아이디 가져오기
	 */

	public String getOff_id(String off_nm, String gubun){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String off_nms = "";
		String off_id = "";

		if(gubun.equals("sm")){
		off_nms = "스피드메이트 " + off_nm;
		}else if(gubun.equals("an")){
		off_nms = "애니카랜드 " + off_nm;
		}else{
			off_nms = "%"+off_nm+"%";
		}

		query = "SELECT max(off_id)as off_id FROM serv_off WHERE off_nm like '"+off_nms+"' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				off_id = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();	
		}catch(SQLException e){
			System.out.println("[Customer_Database:getOff_id(String off_nm)]"+e);
			System.out.println("[Customer_Database:getOff_id(String off_nm)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return off_id;
		}
	}



	/**
	 * 명함관리 등록업체 담당자 이름 체크
	 */

	public String getEmp_nm(String off_id, String emp_nms){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String emp_nm = "";

	query = "SELECT emp_nm FROM SERV_EMP WHERE off_id = '"+off_id+"' and emp_nm = '"+emp_nms+"' ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while(rs.next()){
				emp_nm = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt.close();	
		}catch(SQLException e){
			System.out.println("[Customer_Database:getEmp_nm]"+e);
			System.out.println("[Customer_Database:getEmp_nm]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null)	rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return emp_nm;
		}
	}


	/**
	*	정비업체정보 등록 2004.03.17.
	*/

	public int insertServOff(ServOffBean bean){
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
        ResultSet rs = null;
		int result = -1;
		String off_id = "";
		String query, query1 = "";

		query1= "SELECT NVL(LPAD(MAX(off_id)+1,6,'0'),'000001') FROM serv_off";
		query = " INSERT INTO serv_off "+
				" (off_id, car_comp_id, off_nm, off_st, own_nm, ent_no, off_sta, off_item, off_tel, off_fax, "+
				"  homepage, off_post, off_addr, bank, acc_no, acc_nm, note, reg_dt, reg_id, upd_dt, "+
				"  upd_id, br_id, off_type, ven_code)"+
			    " VALUES"+
			    " (?,?,?,?,?,replace(?,'-',''),?,?,?,?,"+
				"  ?,?,?,?,?,?,?,to_char(sysdate,'yyyymmdd'),?,?,"+
				"  ?,?,?,?) ";

		try{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			rs = pstmt.executeQuery();

            if(rs.next()){
				off_id = rs.getString(1);
            }
			rs.close();
			pstmt.close();	
			
            pstmt2 = conn.prepareStatement(query);
			pstmt2.setString(1, off_id.trim());
			pstmt2.setString(2, bean.getCar_comp_id().trim()); 
			pstmt2.setString(3, bean.getOff_nm().trim()); 
			pstmt2.setString(4, bean.getOff_st().trim()); 
			pstmt2.setString(5, bean.getOwn_nm().trim()); 
			pstmt2.setString(6, bean.getEnt_no().trim()); 
			pstmt2.setString(7, bean.getOff_sta().trim()); 
			pstmt2.setString(8, bean.getOff_item().trim()); 
			pstmt2.setString(9, bean.getOff_tel().trim()); 
			pstmt2.setString(10, bean.getOff_fax().trim()); 
			pstmt2.setString(11, bean.getHomepage().trim()); 
			pstmt2.setString(12, bean.getOff_post().trim()); 
			pstmt2.setString(13, bean.getOff_addr().trim()); 
			pstmt2.setString(14, bean.getBank().trim()); 
			pstmt2.setString(15, bean.getAcc_no().trim()); 
			pstmt2.setString(16, bean.getAcc_nm().trim()); 
			pstmt2.setString(17, bean.getNote());
			pstmt2.setString(18, bean.getReg_id());	//등록자
			pstmt2.setString(19, bean.getUpd_dt());	//수정일
			pstmt2.setString(20, bean.getUpd_id());	//수정자
			pstmt2.setString(21, bean.getBr_id());	//영업소코드
			pstmt2.setString(22, bean.getOff_type());	//1:정비업체, 2:탁송업체
			pstmt2.setString(23, bean.getVen_code());	//네오엠거래처
          
			result = pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

		}catch(Exception e){
			System.out.println("[Customer_Database:insertServOff(ServOffBean bean)]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
              	if(pstmt != null) pstmt.close();
				if(pstmt2 != null) pstmt2.close();
				
			}catch(Exception ignore){}

			closeConnection();
			return result;
		}		
	}

	/**
    * 스피드메이트 등록 중복체크
    */
    public int getRe_ServiceCheck(String car_mng_id, String serv_dt, String tot_dist, long tot_amt){
        getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        String query = "";
        
		query = "SELECT count(0) "+
				"  FROM service "+
				" WHERE car_mng_id = ? AND serv_dt = ? AND tot_dist = ? and tot_amt = ? ";

        try{
            pstmt = conn.prepareStatement(query);
    		pstmt.setString(1, car_mng_id);
			pstmt.setString(2, serv_dt);
			pstmt.setString(3, tot_dist);
			pstmt.setLong(4, tot_amt);
    		rs = pstmt.executeQuery();

            if(rs.next()){                
				count = rs.getInt(1);
            }

			rs.close();
			pstmt.close();

        }catch(SQLException e){
			 System.out.println("[Customer_Database:getRe_ServiceCheck()]"+e);
 			 System.out.println("[Customer_Database:getRe_ServiceCheck()]"+query);
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

public Hashtable getServ_id_tire(String car_mng_id, String serv_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht2 = new Hashtable();
		int count = 0;

		String query = "";

		query = "SELECT car_mng_id, sum( nvl(labor,amt) ) as amt, NVL(LPAD(MAX(serv_id),6,'0'),'000001') as serv_id FROM serv_item WHERE car_mng_id= '"+car_mng_id+"' and serv_id = '"+serv_id+"' and serv_id not like 'NN%' group by car_mng_id ";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht2.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Customer_Database:getServ_id2]"+e);
			System.out.println("[Customer_Database:getServ_id2]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht2;
		}
	}


//차량번호로 차량관리번호 가져가기
	public Hashtable speed_Serach(String car_no, String js_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		query = " select a.*, b.rent_mng_id, b.rent_l_cd, d.rent_st, '' rent_s_cd, b.car_st, b.mng_id as mng_id, e.user_nm, d.st_dt, d.end_dt, c.cls_dt  \n"+
				" from   (SELECT b.CAR_MNG_ID, b.car_no, B.CAR_NM, b.init_reg_dt, c.car_no AS car_no2, c.min_cha_seq, c.min_cha_dt, c.min_cha_dt AS s_cha_dt, \n"+
				"                TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') end_cha_dt "+
				"         FROM   CAR_REG b, "+
				"                (SELECT car_mng_id, car_no, MIN(cha_seq) min_cha_seq, MAX(cha_seq) max_cha_seq, MIN(cha_dt) min_cha_dt, COUNT(0) cnt FROM CAR_CHANGE GROUP BY car_mng_id, car_no ) c, "+
				"                CAR_CHANGE d "+
				"         WHERE  b.car_mng_id=c.car_mng_id AND c.car_mng_id=d.car_mng_id(+) AND c.max_cha_seq+1=d.cha_seq(+) AND c.car_no ='"+car_no+"' \n"+//차량번호 
				"                AND '"+js_dt+"' BETWEEN c.min_cha_dt AND TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') \n"+ //위반일자 
				"         ORDER BY b.car_mng_id, c.min_cha_seq "+
				"	     ) a,"+
				"        cont b, cls_cont c, users e, cont_etc f, car_reco i, sui j, "+	    
				"        (select f.rent_mng_id, f.rent_l_cd, f.rent_st, min(f.rent_start_dt) st_dt, case when max(sf.use_e_dt) > max(f.rent_end_dt) then max(sf.use_e_dt) else max(f.rent_end_dt)  end end_dt "+
				"	      from   fee f, scd_fee sf \n"+
				"         where  f.rent_mng_id = sf.rent_mng_id and f.rent_l_cd = sf.rent_l_cd and f.rent_st = sf.rent_st and sf.bill_yn='Y' "+
				"	      group by f.rent_mng_id, f.rent_l_cd, f.rent_st "+
				"	     ) d,  \n"+
                "        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) d2 "+
				" where  a.car_mng_id=b.car_mng_id and b.car_st not in ('2')  \n"+ 
				"        and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)  \n"+
				"        and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+) and b.bus_id2=e.user_id  \n"+
				"        and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd "+
				"        AND c.rent_mng_id=i.rent_mng_id(+) AND c.rent_l_cd=i.rent_l_cd(+) \n"+
                "        AND b.rent_mng_id=d2.rent_mng_id AND b.rent_l_cd=d2.rent_l_cd  \n"+
                "        and a.car_mng_id=j.car_mng_id(+) "+
				"        and '"+js_dt+"' BETWEEN decode(f.rent_suc_dt,'',NVL(d.st_dt,b.rent_start_dt),decode(f.suc_rent_st,d.rent_st,nvl(f.car_deli_dt,f.rent_suc_dt),NVL(d.st_dt,b.rent_start_dt))) AND "+
				"	                     CASE WHEN c.cls_st='8' THEN nvl(j.migr_dt,nvl(j.cont_dt,c.cls_dt)) WHEN d.rent_st=d2.rent_st THEN NVL(NVL(nvl(i.reco_dt,c.cls_dt),d.end_dt),b.rent_end_dt) ELSE nvl(d.end_dt, b.rent_end_dt) END \n"+ 
				" union all \n"+
		        //--단기대여인 경우
				" select a.*, b.rent_mng_id, b.rent_l_cd, '1' rent_st, c.rent_s_cd, b.car_st, decode(c.rent_st,'4',c.cust_id,b.mng_id) as mng_id, e.user_nm, nvl(c.deli_dt,c.deli_plan_dt) st_dt, nvl(c.ret_dt,c.ret_plan_dt) end_dt, '' cls_dt "+
				" from   (SELECT b.CAR_MNG_ID, b.car_no, B.CAR_NM, b.init_reg_dt, c.car_no AS car_no2, c.min_cha_seq, c.min_cha_dt, c.min_cha_dt AS s_cha_dt, \n"+
				" TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') end_cha_dt FROM CAR_REG b, (SELECT car_mng_id, \n"+
                " car_no, MIN(cha_seq) min_cha_seq, MAX(cha_seq) max_cha_seq, MIN(cha_dt) min_cha_dt, COUNT(0) cnt FROM CAR_CHANGE GROUP BY car_mng_id, \n"+
                " car_no ) c, CAR_CHANGE d WHERE b.car_mng_id=c.car_mng_id AND c.car_mng_id=d.car_mng_id(+) AND c.max_cha_seq+1=d.cha_seq(+) AND c.car_no ='"+car_no+"' \n"+//차량번호 
				" AND '"+js_dt+"' BETWEEN c.min_cha_dt AND TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') \n"+ //위반일자 
				" ORDER BY b.car_mng_id, c.min_cha_seq ) a,"+
				" cont b, rent_cont c, users e "+
				" where  a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id(+) and b.car_st='2' and c.use_st in ('2','3','4') "+
				" and decode(c.rent_st,'4',c.cust_id,c.bus_id)=e.user_id "+
				" and '"+js_dt+"' BETWEEN SUBSTR(c.deli_dt,0,8) AND SUBSTR(nvl(c.ret_dt,nvl(c.ret_plan_dt,decode(c.use_st,'2','99999999'))),0,8) ";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Customer_Database:speed_Serach]"+e);
			System.out.println("[Customer_Database:speed_Serach]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}


//기관명으로 기관번호 가져가기
	public Hashtable fine_off_search(String fine_off)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";


		query = " SELECT gov_id FROM FINE_GOV WHERE gov_nm LIKE '%"+fine_off+"%' ";


		try {
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Customer_Database:fine_off_search]"+e);
			System.out.println("[Customer_Database:fine_off_search]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	
		//기관부서로 기관번호 가져가기(wetax excel upload)
		public Hashtable fine_off_search_wetax(String fine_off)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			Hashtable ht = new Hashtable();
			int count = 0;

			String query = "";


			query = " SELECT gov_id FROM FINE_GOV WHERE gov_dept_code = '"+fine_off+"' ";


			try {
				pstmt = conn.prepareStatement(query);
		    		rs = pstmt.executeQuery(); 
				ResultSetMetaData rsmd = rs.getMetaData();

				if(rs.next()){	
					for(int pos =1; pos <= rsmd.getColumnCount();pos++){
						 String columnName = rsmd.getColumnName(pos);
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
					}
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				System.out.println("[Customer_Database:fine_off_search]"+e);
				System.out.println("[Customer_Database:fine_off_search]"+query);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null )			rs.close();
	                if(pstmt != null)		pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return ht;
			}
		}



	//차량번호로 차량관리번호 가져가기
	public Hashtable Serach2(String car_no, String js_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";


		query = "SELECT b.rent_start_dt, g.cls_dt, b.rent_end_dt, a.car_mng_id CAR_MNG_ID, b.rent_mng_id RENT_MNG_ID, b.rent_l_cd RENT_L_CD, a.car_no CAR_NO, n.car_nm CAR_JNM, d.car_name CAR_NM, a.car_num CAR_NUM, a.init_reg_dt INIT_REG_DT, a.car_kd CAR_KD, a.car_use CAR_USE, a.car_form CAR_FORM, a.car_y_form CAR_Y_FORM, a.mot_form MOT_FORM, c.colo COLO, a.dpm DPM, a.conti_rat CONTI_RAT, a.fuel_kd FUEL_KD, e.age_scp AGE_SCP, e.ins_com_nm INS_COM_NM, e.ins_start_dt INS_START_DT, e.ins_exp_dt INS_EXP_DT, e.agnt_imgn_tel AGNT_IMGN_TEL, e.acc_tel ACC_TEL, e.vins_spe VINS_SPE, e.vins_cacdt_amt VINS_CACDT_AMT, f.che_st_dt CHE_ST_DT, f.che_end_dt CHE_END_DT, a.first_serv_dt FIRST_SERV_DT, a.cycle_serv CYCLE_SERV, a.tot_serv TOT_SERV, b.mng_id MNG_ID, a.guar_gen_y GUAR_GEN_Y, a.guar_gen_km, a.guar_endur_y, a.guar_endur_km, a.maint_st_dt, a.maint_end_dt, a.test_st_dt, a.test_end_dt "+
			", vt.tot_dist as TOT_DIST "+
			", decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD'))))) as AVERAGE_DIST " +
			", decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(b.dlv_dt,a.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(b.dlv_dt,a.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST " +
			" FROM car_reg a, cont b, car_etc c, car_nm d, car_mng n, v_tot_dist vt  "+
			", (select ir.car_mng_id CAR_MNG_ID, ic.ins_com_nm INS_COM_NM, ir.ins_start_dt INS_START_DT, ir.ins_exp_dt INS_EXP_DT, ir.age_scp AGE_SCP, ir.agnt_imgn_tel AGNT_IMGN_TEL, ir.acc_tel ACC_TEL, ir.vins_spe VINS_SPE, ir.vins_cacdt_amt VINS_CACDT_AMT from insur ir, ins_com ic where ir.ins_com_id = ic.ins_com_id and ir.ins_st = (select max(ins_st) from insur where car_mng_id = ir.car_mng_id)) e "+
			", (select a.car_mng_id CAR_MNG_ID, a.che_st_dt CHE_ST_DT, a.che_end_dt CHE_END_DT from car_maint a where seq_no = (select max(seq_no) from car_maint where a.car_mng_id= car_mng_id)) f, cls_cont g "+
			" WHERE a.car_mng_id = b.car_mng_id "+
			" AND nvl(b.use_yn,'N') = 'N' "+
			" AND b.rent_mng_id = c.rent_mng_id "+
			" AND b.rent_l_cd = c.rent_l_cd "+
			" AND b.rent_mng_id = g.rent_mng_id "+
			" AND b.rent_l_cd = g.rent_l_cd "+
			" AND c.car_id = d.car_id "+
			" AND c.car_seq = d.car_seq "+
			" AND d.car_comp_id = n.car_comp_id "+
			" AND d.car_cd = n.code "+
			" AND a.car_mng_id = vt.car_mng_id(+) "+
			" AND a.car_mng_id = e.car_mng_id "+
			" AND a.car_mng_id = f.car_mng_id(+) "+
			" AND g.cls_st <> '6' "+
			" AND a.car_no = '"+car_no+"' "+
			" AND SUBSTR('"+js_dt+"',0,4) BETWEEN substr(b.rent_start_dt, 0,4) AND SUBSTR(nvl(g.cls_dt,b.rent_end_dt) ,0,4)";


		try {
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Customer_Database:Serach2]"+e);
			System.out.println("[Customer_Database:Serach2]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}






///////////////////////////////////////////////////////////


@SuppressWarnings({ "unchecked", "rawtypes" })
	public Hashtable newSpeedSearch (String car_no, String js_dt, String query_rent_mng_id) {
		getConnection();

		PreparedStatement pstmt = null;

		ResultSet rs = null;

		Hashtable ht = new Hashtable();

		String query = "";

    query = "SELECT a.car_mng_id, \n"
        + "       b.rent_mng_id, \n"
        + "       b.rent_l_cd, \n"
        + "       '' rent_s_cd, \n"
//      + "         b.car_st, \n"
        + "       b.mng_id AS mng_id \n"
//      + "         e.user_nm, \n"
//      + "         d.st_dt, \n"
//      + "         d.end_dt, \n"
//      + "         c.cls_dt \n"
        + "  FROM \n"
        + "      (SELECT b.CAR_MNG_ID \n"
//      + "                b.car_no, \n"
//      + "                B.CAR_NM, \n"
//      + "                b.init_reg_dt, \n"
//      + "                c.car_no AS car_no2, \n"
//      + "                c.min_cha_seq, \n"
//      + "                c.min_cha_dt \n"
//      + "                c.min_cha_dt AS s_cha_dt, \n"
//      + "                TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') end_cha_dt \n"
        + "         FROM CAR_REG b, \n"
        + "             (SELECT car_mng_id, \n"
        + "                     car_no, \n"
        + "                     MIN(cha_seq) min_cha_seq, \n"
        + "                     MAX(cha_seq) max_cha_seq, \n"
        + "                     MIN(cha_dt) min_cha_dt \n"
//      + "                       COUNT(0) cnt \n"
        + "                FROM CAR_CHANGE \n"
        + "               GROUP BY car_mng_id, \n"
        + "                     car_no \n"
        + "              ) c, \n"
        + "              CAR_CHANGE d \n"
        + "        WHERE b.car_mng_id = c.car_mng_id \n"
        + "              AND c.car_mng_id = d.car_mng_id(+) \n"
        + "              AND c.max_cha_seq + 1 = d.cha_seq(+) \n"
        + "              AND c.car_no = '" + car_no + "' \n"
        + "              AND '" + js_dt + "' BETWEEN c.min_cha_dt AND TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')), 'YYYYMMDD') - 1, 'YYYYMMDD') \n"
        + "     ORDER BY b.car_mng_id, \n"
        + "              c.min_cha_seq \n"
        + "       ) a, \n"
        + "       cont b, \n"
        + "       cls_cont c, \n"
        + "       users e, \n"
        + "      (SELECT f.rent_mng_id, \n"
        + "              f.rent_l_cd, \n"
        + "              min(f.rent_start_dt) st_dt, \n"
        + "              CASE \n"
        + "                  WHEN max(sf.use_e_dt) > max(f.rent_end_dt) \n"
        + "                  THEN max(sf.use_e_dt) \n"
        + "                  ELSE max(f.rent_end_dt) \n"
        + "              END end_dt \n"
        + "         FROM fee f, \n"
        + "              scd_fee sf \n"
        + "        WHERE f.rent_mng_id = sf.rent_mng_id \n"
        + "              AND f.rent_l_cd = sf.rent_l_cd \n"
        + "              AND nvl(sf.bill_yn, 'Y') = 'Y' \n"
//      + "                AND '" + js_dt + "' > f.rent_start_dt \n"
        + "        GROUP BY f.rent_mng_id, \n"
        + "              f.rent_l_cd \n"
        + "       ) d \n"
        + " WHERE a.car_mng_id = b.car_mng_id \n"
        + "       AND b.rent_mng_id IN " + query_rent_mng_id + " \n"
        + "       AND b.car_st NOT IN ('2') \n"
        + "       AND b.rent_mng_id = c.rent_mng_id(+) \n"
        + "       AND b.rent_l_cd = c.rent_l_cd(+) \n"
        + "       AND b.rent_mng_id = d.rent_mng_id(+) \n"
        + "       AND b.rent_l_cd = d.rent_l_cd(+) \n"
        + "       AND b.bus_id2 = e.user_id \n"
        + "       AND '" + js_dt + "' between d.st_dt AND nvl(c.cls_dt, d.end_dt) \n"
        + " UNION ALL \n"
        + "SELECT a.car_mng_id, \n"
        + "       b.rent_mng_id, \n"
        + "       b.rent_l_cd, \n"
        + "       c.rent_s_cd, \n"
//        + "       b.car_st, \n"
        + "       decode(c.rent_st, '4', c.cust_id, b.mng_id) AS mng_id \n"
//        + "       e.user_nm, \n"
//        + "       nvl(c.deli_dt, c.deli_plan_dt) st_dt, \n"
//        + "       nvl(c.ret_dt, c.ret_plan_dt) end_dt, \n"
//        + "       '' cls_dt \n"
        + "  FROM \n"
        + "      (SELECT b.CAR_MNG_ID, \n"
        + "              b.car_no, \n"
//        + "              B.CAR_NM, \n"
//        + "              b.init_reg_dt, \n"
//        + "              c.car_no AS car_no2, \n"
        + "              c.min_cha_seq, \n"
        + "              c.min_cha_dt \n"
//        + "              c.min_cha_dt AS s_cha_dt, \n"
//        + "              TO_CHAR(TO_DATE(NVL(d.cha_dt, to_char(sysdate,'YYYYMMDD')), 'YYYYMMDD') - 1, 'YYYYMMDD') end_cha_dt \n"
        + "         FROM CAR_REG b, \n"
        + "             (SELECT car_mng_id, \n"
        + "                     car_no, \n"
        + "                     MIN(cha_seq) min_cha_seq, \n"
        + "                     MAX(cha_seq) max_cha_seq, \n"
        + "                     MIN(cha_dt) min_cha_dt \n"
//        + "                     COUNT(0) cnt \n"
        + "                FROM CAR_CHANGE \n"
        + "               GROUP BY car_mng_id, \n"
        + "                     car_no \n"
        + "              ) c, \n"
        + "              CAR_CHANGE d \n"
        + "        WHERE b.car_mng_id = c.car_mng_id \n"
        + "              AND c.car_mng_id = d.car_mng_id(+) \n"
        + "              AND c.max_cha_seq + 1 = d.cha_seq(+) \n"
        + "              AND c.car_no = '" + car_no + "' \n"
        + "              AND '" + js_dt + "' BETWEEN c.min_cha_dt AND TO_CHAR(TO_DATE(NVL(d.cha_dt, to_char(sysdate,'YYYYMMDD')), 'YYYYMMDD') - 1, 'YYYYMMDD') \n"
        + "     ORDER BY b.car_mng_id, \n"
        + "              c.min_cha_seq \n"
        + "       ) a, \n"
        + "       cont b, \n"
        + "       rent_cont c, \n"
        + "       users e \n"
        + " WHERE a.car_mng_id = b.car_mng_id \n"
        + "       AND a.car_mng_id = c.car_mng_id(+) \n"
        + "       AND b.car_st = '2' \n"
        + "       AND c.use_st <>'5' \n"
        + "       AND decode(c.rent_st,'4', c.cust_id, c.bus_id) = e.user_id \n"
        + "       AND '" + js_dt + "' BETWEEN SUBSTR(nvl(c.deli_dt, c.deli_plan_dt), 0, 8) AND SUBSTR(nvl(c.ret_dt, nvl(c.ret_plan_dt, decode(c.use_st, '2', '99999999'))), 0, 8) \n";

	try {
			pstmt = conn.prepareStatement(query);

			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();

			if (rs.next()) {
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);

					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Customer_Database:newSpeedSearch]" + e);
			System.out.println("[Customer_Database:newSpeedSearch]" + query);

			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}

			closeConnection();
		}

		return ht;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Hashtable newSearch2 (String car_no, String js_dt, String queryIn) {
		getConnection();

		PreparedStatement pstmt = null;

		ResultSet rs = null;

		Hashtable ht = new Hashtable();

		String query = "";

    query = "SELECT a.car_mng_id CAR_MNG_ID, \n"
        + "       b.rent_mng_id RENT_MNG_ID, \n"
        + "       b.rent_l_cd RENT_L_CD, \n"
        + "       b.mng_id MNG_ID \n"
        + "  FROM car_reg a, \n"
        + "       cont b, \n"
        + "       car_etc c, \n"
        + "       car_nm d, \n"
        + "       car_mng n, \n"
        + "       v_tot_dist vt , \n"
        + "       (SELECT ir.car_mng_id CAR_MNG_ID, \n"
        + "              ic.ins_com_nm INS_COM_NM, \n"
        + "              ir.ins_start_dt INS_START_DT, \n"
        + "              ir.ins_exp_dt INS_EXP_DT, \n"
        + "              ir.age_scp AGE_SCP, \n"
        + "              ir.agnt_imgn_tel AGNT_IMGN_TEL, \n"
        + "              ir.acc_tel ACC_TEL, \n"
        + "              ir.vins_spe VINS_SPE, \n"
        + "              ir.vins_cacdt_amt VINS_CACDT_AMT \n"
        + "         FROM insur ir, \n"
        + "              ins_com ic \n"
        + "        WHERE ir.ins_com_id = ic.ins_com_id \n"
        + "              AND ir.ins_st = \n"
        + "              (SELECT max(ins_st) \n"
        + "                FROM insur \n"
        + "               WHERE car_mng_id = ir.car_mng_id \n"
        + "              ) \n"
        + "       ) e , \n"
        + "       (SELECT a.car_mng_id CAR_MNG_ID, \n"
        + "              a.che_st_dt CHE_ST_DT, \n"
        + "              a.che_end_dt CHE_END_DT \n"
        + "         FROM car_maint a \n"
        + "        WHERE seq_no = \n"
        + "              (SELECT max(seq_no) \n"
        + "                FROM car_maint \n"
        + "               WHERE a.car_mng_id = car_mng_id \n"
        + "              ) \n"
        + "       ) f, \n"
        + "       cls_cont g \n"
        + " WHERE a.car_mng_id = b.car_mng_id \n"
        + "       AND a.car_mng_id in " + queryIn + " \n"
        + "       AND nvl(b.use_yn,'N') = 'N' \n"
        + "       AND b.rent_mng_id = c.rent_mng_id \n"
        + "       AND b.rent_l_cd = c.rent_l_cd \n"
        + "       AND b.rent_mng_id = g.rent_mng_id \n"
        + "       AND b.rent_l_cd = g.rent_l_cd \n"
        + "       AND c.car_id = d.car_id \n"
        + "       AND c.car_seq = d.car_seq \n"
        + "       AND d.car_comp_id = n.car_comp_id \n"
        + "       AND d.car_cd = n.code \n"
        + "       AND a.car_mng_id = vt.car_mng_id(+) \n"
        + "       AND a.car_mng_id = e.car_mng_id \n"
        + "       AND a.car_mng_id = f.car_mng_id(+) \n"
        + "       AND g.cls_st <> '6' \n"
        + "       AND a.car_no = '"+car_no+"' \n"
        + "       AND SUBSTR('"+js_dt+"', 0, 4) BETWEEN substr(b.rent_start_dt, 0, 4) AND SUBSTR(nvl(g.cls_dt, b.rent_end_dt), 0, 4) \n";

		try {
			pstmt = conn.prepareStatement(query);

			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();

			if (rs.next()) {
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);

					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Customer_Database:newSearch2]" + e);
			System.out.println("[Customer_Database:newSearch2]" + query);

			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}

			closeConnection();
		}

		return ht;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Hashtable newGetCarMngId (String car_no) {
		getConnection();

		PreparedStatement pstmt = null;

		ResultSet rs = null;

		Hashtable ht = new Hashtable();

		String query = "";

		query = "SELECT car_mng_id " + ""
				  + "  FROM car_reg " + " "
				  + " WHERE car_no = '" + car_no + "' ";

		try {
			pstmt = conn.prepareStatement(query);

			rs = pstmt.executeQuery();

			int i = 0;

			while (rs.next()) {
				ht.put(String.valueOf(i), (rs.getString(1)) == null ? "" : rs.getString(1).trim());

				i++;
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Customer_Database:newGetCarMngId]" + e);
			System.out.println("[Customer_Database:newGetCarMngId]" + query);

			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}

			closeConnection();
		}

		return ht;
	}






//법인번호로 고객정보 가져오기
public Hashtable client_search_info(String search_num)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";


		query = " SELECT * FROM CLIENT WHERE TEXT_DECRYPT(ssn, 'pw' )  = '"+search_num+"' ";


		try {
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Customer_Database:client_search_info]"+e);
			System.out.println("[Customer_Database:client_search_info]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}



//사업자번호로 가져오기 
public Hashtable client_search_enp_info(String search_num)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";


//		query = " SELECT * FROM CLIENT WHERE enp_no  = replace('"+search_num+"' , '-', '')";
		
		query = "SELECT * FROM (\r\n" + 
				"SELECT a.*, TEXT_DECRYPT(a.ssn, 'pw' ) ssn_de,  ROW_NUMBER() OVER (partition BY a.enp_no ORDER BY a.client_id) AS rn \r\n" + 
				"FROM   CLIENT a\r\n" + 
				"WHERE enp_no  = replace('"+search_num+"' , '-', '')\r\n" + 
				") WHERE rn=1\r\n" + 
				" ";
		
		


		try {
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Customer_Database:client_search_enp_info]"+e);
			System.out.println("[Customer_Database:client_search_enp_info]"+query);
	  		e.printStackTrace();
		} finally {
			try{
              if(rs != null )			rs.close();
              if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}



//차량번호로 차량관리번호 가져가기
	public Hashtable Serach_c_id(String car_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";

		query = " select a.*, b.rent_mng_id, b.rent_l_cd, '' rent_s_cd, b.car_st, b.mng_id as mng_id, e.user_nm, d.st_dt, d.end_dt, c.cls_dt  \n"+
				" from   (SELECT b.CAR_MNG_ID, b.car_no, B.CAR_NM, b.init_reg_dt, c.car_no AS car_no2, c.min_cha_seq, c.min_cha_dt, c.min_cha_dt AS s_cha_dt, \n"+
				" TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') end_cha_dt FROM CAR_REG b, (SELECT car_mng_id, \n"+
                " car_no, MIN(cha_seq) min_cha_seq, MAX(cha_seq) max_cha_seq, MIN(cha_dt) min_cha_dt, COUNT(0) cnt FROM CAR_CHANGE GROUP BY car_mng_id, \n"+
                " car_no ) c, CAR_CHANGE d WHERE b.car_mng_id=c.car_mng_id AND c.car_mng_id=d.car_mng_id(+) AND c.max_cha_seq+1=d.cha_seq(+) AND c.car_no ='"+car_no+"' \n"+//차량번호 
				" ORDER BY b.car_mng_id, c.min_cha_seq ) a,"+
				"   cont b, cls_cont c, users e,"+	    
				"( select f.rent_mng_id, f.rent_l_cd, min(f.rent_start_dt) st_dt, case when max(sf.use_e_dt) > max(f.rent_end_dt) then max(sf.use_e_dt) else max(f.rent_end_dt)  end end_dt from fee f, scd_fee sf \n"+
				" where f.rent_mng_id = sf.rent_mng_id and f.rent_l_cd = sf.rent_l_cd  and  nvl(sf.bill_yn, 'Y') = 'Y'  group by f.rent_mng_id, f.rent_l_cd ) d  \n"+
				" where a.car_mng_id=b.car_mng_id and b.car_st in ('2')  \n"+ 
				"   and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)  \n"+
				"   and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+) and b.bus_id2=e.user_id  \n"+
				"";



		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[Customer_Database:Serach_c_id]"+e);
			System.out.println("[Customer_Database:Serach_c_id]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	//과태료등록시 위반일시에 맞는 고객찾기(20190829)
	//위 Hashtable speed_Serach(String car_no, String js_dt) 와 같은 쿼리를 벡터화 -> 입력누락등으로 정확한 일시비교가 불가능해 2건 이상이면 자동화안되게 하기위함.  
	public Vector getFine_maker(String car_no, String js_dt){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select a.*, b.rent_mng_id, b.rent_l_cd, d.rent_st, '' rent_s_cd, b.car_st, b.mng_id as mng_id, e.user_nm, d.st_dt, d.end_dt, c.cls_dt  \n"+
					 " from   (SELECT b.CAR_MNG_ID, b.car_no, B.CAR_NM, b.init_reg_dt, c.car_no AS car_no2, c.min_cha_seq, c.min_cha_dt, c.min_cha_dt AS s_cha_dt, \n"+
					 "                TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') end_cha_dt "+
					 "         FROM   CAR_REG b, "+
					 "                (SELECT car_mng_id, car_no, MIN(cha_seq) min_cha_seq, MAX(cha_seq) max_cha_seq, MIN(cha_dt) min_cha_dt, COUNT(0) cnt FROM CAR_CHANGE GROUP BY car_mng_id, car_no ) c, "+
					 "                CAR_CHANGE d "+
					 "         WHERE  b.car_mng_id=c.car_mng_id AND c.car_mng_id=d.car_mng_id(+) AND c.max_cha_seq+1=d.cha_seq(+) AND c.car_no ='"+car_no+"' \n"+//차량번호 
					 "                AND replace('"+js_dt+"','-','') BETWEEN c.min_cha_dt AND TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') \n"+ //위반일자 
					 "         ORDER BY b.car_mng_id, c.min_cha_seq "+
					 "	     ) a,"+
					 "        cont b, cls_cont c, users e, cont_etc f, car_reco i, sui j, "+	    
					 "        (select f.rent_mng_id, f.rent_l_cd, f.rent_st, min(f.rent_start_dt) st_dt, case when max(sf.use_e_dt) > max(f.rent_end_dt) then max(sf.use_e_dt) else max(f.rent_end_dt)  end end_dt "+
					 "	      from   fee f, scd_fee sf \n"+
					 "         where  f.rent_mng_id = sf.rent_mng_id and f.rent_l_cd = sf.rent_l_cd and f.rent_st = sf.rent_st and sf.bill_yn='Y' "+
					 "	      group by f.rent_mng_id, f.rent_l_cd, f.rent_st "+
					 "	     ) d,  \n"+
					 "        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) d2 "+
					 " where  a.car_mng_id=b.car_mng_id and b.car_st not in ('2')  \n"+ 
					 "        and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)  \n"+
					 "        and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+) and b.bus_id2=e.user_id  \n"+
					 "        and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd "+
					 "        AND c.rent_mng_id=i.rent_mng_id(+) AND c.rent_l_cd=i.rent_l_cd(+) \n"+
					 "        AND b.rent_mng_id=d2.rent_mng_id AND b.rent_l_cd=d2.rent_l_cd  \n"+
					 "        and a.car_mng_id=j.car_mng_id(+) "+
					 "        and replace('"+js_dt+"','-','') BETWEEN decode(f.rent_suc_dt,'',NVL(d.st_dt,b.rent_start_dt),decode(f.suc_rent_st,d.rent_st,nvl(f.car_deli_dt,f.rent_suc_dt),NVL(d.st_dt,b.rent_start_dt))) AND "+
					 "	                     CASE WHEN c.cls_st='8' THEN nvl(j.migr_dt,nvl(j.cont_dt,c.cls_dt)) WHEN d.rent_st=d2.rent_st THEN NVL(NVL(nvl(i.reco_dt,c.cls_dt),d.end_dt),b.rent_end_dt) ELSE nvl(d.end_dt, b.rent_end_dt) END \n"+ 
					 " union all \n"+
					 //--단기대여인 경우
					 " select a.*, b.rent_mng_id, b.rent_l_cd, '1' rent_st, c.rent_s_cd, b.car_st, decode(c.rent_st,'4',c.cust_id,b.mng_id) as mng_id, e.user_nm, nvl(c.deli_dt,c.deli_plan_dt) st_dt, nvl(c.ret_dt,c.ret_plan_dt) end_dt, '' cls_dt "+
					 " from   (SELECT b.CAR_MNG_ID, b.car_no, B.CAR_NM, b.init_reg_dt, c.car_no AS car_no2, c.min_cha_seq, c.min_cha_dt, c.min_cha_dt AS s_cha_dt, \n"+
					 " TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') end_cha_dt FROM CAR_REG b, (SELECT car_mng_id, \n"+
					 " car_no, MIN(cha_seq) min_cha_seq, MAX(cha_seq) max_cha_seq, MIN(cha_dt) min_cha_dt, COUNT(0) cnt FROM CAR_CHANGE GROUP BY car_mng_id, \n"+
					 " car_no ) c, CAR_CHANGE d WHERE b.car_mng_id=c.car_mng_id AND c.car_mng_id=d.car_mng_id(+) AND c.max_cha_seq+1=d.cha_seq(+) AND c.car_no ='"+car_no+"' \n"+//차량번호 
					 " AND replace('"+js_dt+"','-','') BETWEEN c.min_cha_dt AND TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') \n"+ //위반일자 
					 " ORDER BY b.car_mng_id, c.min_cha_seq ) a,"+
					 " cont b, rent_cont c, users e "+
					 " where  a.car_mng_id=b.car_mng_id and a.car_mng_id=c.car_mng_id(+) and b.car_st='2' and c.use_st in ('2','3','4') "+
					 " and decode(c.rent_st,'4',c.cust_id,c.bus_id)=e.user_id "+
					 " and replace('"+js_dt+"','-','') BETWEEN SUBSTR(c.deli_dt,0,8) AND SUBSTR(nvl(c.ret_dt,nvl(c.ret_plan_dt,decode(c.use_st,'2','99999999'))),0,8) ";
		
		try {
			    pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next()){				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[Customer_Database:getFine_maker]\n"+e);
			System.out.println("[Customer_Database:getFine_maker]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();
			return vt;
		}
	}
	
	//차량번호로 차량관리번호 가져가기 - 계약일부터
		public Hashtable carNo_SearchNew(String car_no, String js_dt)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			Hashtable ht = new Hashtable();
			int count = 0;

			String query = "";

		//	query = " select a.*, b.rent_mng_id, b.rent_l_cd, d.rent_st, '' rent_s_cd, b.car_st, b.mng_id as mng_id, e.user_nm, d.st_dt, d.end_dt, c.cls_dt  \n" +
		/*	query = " select a.car_mng_id, a.car_no, b.rent_mng_id, b.rent_l_cd, b.mng_id as mng_id \n"+
					" from   (SELECT b.CAR_MNG_ID, b.car_no, B.CAR_NM, b.init_reg_dt, c.car_no AS car_no2, c.min_cha_seq, c.min_cha_dt, c.min_cha_dt AS s_cha_dt, \n"+
					"                TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') end_cha_dt "+
					"         FROM   CAR_REG b, "+
					"                (SELECT car_mng_id, car_no, MIN(cha_seq) min_cha_seq, MAX(cha_seq) max_cha_seq, MIN(cha_dt) min_cha_dt, COUNT(0) cnt FROM CAR_CHANGE GROUP BY car_mng_id, car_no ) c, "+
					"                CAR_CHANGE d "+
					"         WHERE  b.car_mng_id=c.car_mng_id AND c.car_mng_id=d.car_mng_id(+) AND c.max_cha_seq+1=d.cha_seq(+) AND c.car_no ='"+car_no+"' \n"+//차량번호 
					"                AND '"+js_dt+"' BETWEEN c.min_cha_dt AND TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') \n"+ //위반일자 
					"         ORDER BY b.car_mng_id, c.min_cha_seq "+
					"	     ) a,"+
					"        cont b, cls_cont c,  cont_etc f, car_reco i, sui j, "+	    
					"        (select f.rent_mng_id, f.rent_l_cd, f.rent_st, min(f.rent_start_dt) st_dt, case when max(sf.use_e_dt) > max(f.rent_end_dt) then max(sf.use_e_dt) else max(f.rent_end_dt)  end end_dt "+
					"	      from   fee f, scd_fee sf \n"+
					"         where  f.rent_mng_id = sf.rent_mng_id and f.rent_l_cd = sf.rent_l_cd and f.rent_st = sf.rent_st and sf.bill_yn='Y' "+
					"	      group by f.rent_mng_id, f.rent_l_cd, f.rent_st "+
					"	     ) d,  \n"+
	                "        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) d2 "+
					" where  a.car_mng_id=b.car_mng_id and b.car_st not in ('2')  \n"+ 
					"        and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)  \n"+
					"        and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+)  \n"+
					"        and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd "+
					"        AND c.rent_mng_id=i.rent_mng_id(+) AND c.rent_l_cd=i.rent_l_cd(+) \n"+
	                "        AND b.rent_mng_id=d2.rent_mng_id AND b.rent_l_cd=d2.rent_l_cd  \n"+
	                "        and a.car_mng_id=j.car_mng_id(+) "+
					"        and '"+js_dt+"' BETWEEN decode(f.rent_suc_dt,'', to_char(to_date(b.rent_dt) - 7 , 'yyyymmdd' ) ,decode(f.suc_rent_st,d.rent_st,nvl(f.car_deli_dt,f.rent_suc_dt),NVL(d.st_dt,b.rent_start_dt))) AND "+
					"	                     CASE WHEN c.cls_st='8' THEN nvl(j.migr_dt,nvl(j.cont_dt,c.cls_dt)) WHEN d.rent_st=d2.rent_st THEN NVL(NVL(nvl(i.reco_dt,c.cls_dt),d.end_dt),b.rent_end_dt) ELSE nvl(d.end_dt, b.rent_end_dt) END "; 
					*/
  /* 20200130 보유차 포함 */
			query = " select a.car_mng_id, a.car_no, b.rent_mng_id, b.rent_l_cd, b.car_st,  b.mng_id as mng_id \n"+
					" from   (select car_no, car_mng_id from  car_reg where car_no ='"+car_no+"' \n"+//차량번호 
					"	     ) a,"+
					"        cont b, cls_cont c,  cont_etc f, car_reco i, sui j, "+	    
					"        (select f.rent_mng_id, f.rent_l_cd, f.rent_st, min(f.rent_start_dt) st_dt, case when max(sf.use_e_dt) > max(f.rent_end_dt) then max(sf.use_e_dt) else max(f.rent_end_dt)  end end_dt "+
					"	      from   fee f, scd_fee sf \n"+
					"         where  f.rent_mng_id = sf.rent_mng_id and f.rent_l_cd = sf.rent_l_cd and f.rent_st = sf.rent_st and sf.bill_yn='Y' "+
					"	      group by f.rent_mng_id, f.rent_l_cd, f.rent_st "+
					"	     ) d,  \n"+
	                "        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) d2 "+
					" where  a.car_mng_id=b.car_mng_id   \n"+ 
					"        and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)  \n"+
					"        and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+)  \n"+
					"        and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd "+
					"        AND c.rent_mng_id=i.rent_mng_id(+) AND c.rent_l_cd=i.rent_l_cd(+) \n"+
	                "        AND b.rent_mng_id=d2.rent_mng_id AND b.rent_l_cd=d2.rent_l_cd  \n"+
	                "        and a.car_mng_id=j.car_mng_id(+) "+
	                "		 and '"+js_dt+"'  BETWEEN decode(f.rent_suc_dt,'', to_char(to_date(b.rent_dt) - 10 , 'yyyymmdd' ) ,decode(f.suc_rent_st,d.rent_st,nvl(f.car_deli_dt,f.rent_suc_dt),NVL(d.st_dt,b.rent_start_dt))) AND  "+
                    "			CASE WHEN c.cls_st='8' THEN nvl(j.migr_dt,nvl(j.cont_dt,c.cls_dt)) WHEN d.rent_st=d2.rent_st THEN nvl(NVL(NVL(nvl(i.reco_dt,c.cls_dt),d.end_dt),b.rent_end_dt), to_char(sysdate,'YYYYMMdd') ) ELSE nvl(nvl(d.end_dt, b.rent_end_dt), to_char(sysdate,'YYYYMMdd') ) END ";
			

			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery(); 
				ResultSetMetaData rsmd = rs.getMetaData();

				if(rs.next()){	
					for(int pos =1; pos <= rsmd.getColumnCount();pos++){
						 String columnName = rsmd.getColumnName(pos);
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
					}
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				System.out.println("[Customer_Database:speed_Serach]"+e);
				System.out.println("[Customer_Database:speed_Serach]"+query);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null )			rs.close();
	                if(pstmt != null)		pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return ht;
			}
		}
		
		//차량번호로 차량관리번호 가져가기 - 계약일부터
		public Hashtable carNo_Search(String car_no, String js_dt)
				{
					getConnection();
					PreparedStatement pstmt = null;
					ResultSet rs = null;

					Hashtable ht = new Hashtable();
					int count = 0;

					String query = "";

				//	query = " select a.*, b.rent_mng_id, b.rent_l_cd, d.rent_st, '' rent_s_cd, b.car_st, b.mng_id as mng_id, e.user_nm, d.st_dt, d.end_dt, c.cls_dt  \n" +
					query = " select a.car_mng_id, a.car_no, b.rent_mng_id, b.rent_l_cd, b.mng_id as mng_id \n"+
							" from   (SELECT b.CAR_MNG_ID, b.car_no, B.CAR_NM, b.init_reg_dt, c.car_no AS car_no2, c.min_cha_seq, c.min_cha_dt, c.min_cha_dt AS s_cha_dt, \n"+
							"                TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') end_cha_dt "+
							"         FROM   CAR_REG b, "+
							"                (SELECT car_mng_id, car_no, MIN(cha_seq) min_cha_seq, MAX(cha_seq) max_cha_seq, MIN(cha_dt) min_cha_dt, COUNT(0) cnt FROM CAR_CHANGE GROUP BY car_mng_id, car_no ) c, "+
							"                CAR_CHANGE d "+
							"         WHERE  b.car_mng_id=c.car_mng_id AND c.car_mng_id=d.car_mng_id(+) AND c.max_cha_seq+1=d.cha_seq(+) AND c.car_no ='"+car_no+"' \n"+//차량번호 
							"                AND '"+js_dt+"' BETWEEN c.min_cha_dt AND TO_CHAR(TO_DATE(NVL(d.cha_dt,TO_CHAR(SYSDATE,'YYYYMMDD')),'YYYYMMDD')-1,'YYYYMMDD') \n"+ //위반일자 
							"         ORDER BY b.car_mng_id, c.min_cha_seq "+
							"	     ) a,"+
							"        cont b, cls_cont c,  cont_etc f, car_reco i, sui j, "+	    
							"        (select f.rent_mng_id, f.rent_l_cd, f.rent_st, min(f.rent_start_dt) st_dt, case when max(sf.use_e_dt) > max(f.rent_end_dt) then max(sf.use_e_dt) else max(f.rent_end_dt)  end end_dt "+
							"	      from   fee f, scd_fee sf \n"+
							"         where  f.rent_mng_id = sf.rent_mng_id and f.rent_l_cd = sf.rent_l_cd and f.rent_st = sf.rent_st and sf.bill_yn='Y' "+
							"	      group by f.rent_mng_id, f.rent_l_cd, f.rent_st "+
							"	     ) d,  \n"+
			                "        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) d2 "+
							" where  a.car_mng_id=b.car_mng_id and b.car_st not in ('2')  \n"+ 
							"        and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+)  \n"+
							"        and b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+)  \n"+
							"        and b.rent_mng_id=f.rent_mng_id and b.rent_l_cd=f.rent_l_cd "+
							"        AND c.rent_mng_id=i.rent_mng_id(+) AND c.rent_l_cd=i.rent_l_cd(+) \n"+
			                "        AND b.rent_mng_id=d2.rent_mng_id AND b.rent_l_cd=d2.rent_l_cd  \n"+
			                "        and a.car_mng_id=j.car_mng_id(+) "+
							"        and '"+js_dt+"' BETWEEN decode(f.rent_suc_dt,'', to_char(to_date(b.rent_dt) - 10 , 'yyyymmdd' ) ,decode(f.suc_rent_st,d.rent_st,nvl(f.car_deli_dt,f.rent_suc_dt),NVL(d.st_dt,b.rent_start_dt))) AND "+
							"	                     CASE WHEN c.cls_st='8' THEN nvl(j.migr_dt,nvl(j.cont_dt,c.cls_dt)) WHEN d.rent_st=d2.rent_st THEN NVL(NVL(nvl(i.reco_dt,c.cls_dt),d.end_dt),b.rent_end_dt) ELSE nvl(d.end_dt, b.rent_end_dt) END "; 
									

					try {
						pstmt = conn.prepareStatement(query);
				    	rs = pstmt.executeQuery(); 
						ResultSetMetaData rsmd = rs.getMetaData();

						if(rs.next()){	
							for(int pos =1; pos <= rsmd.getColumnCount();pos++){
								 String columnName = rsmd.getColumnName(pos);
								 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
							}
						}
						rs.close();
						pstmt.close();

					} catch (SQLException e) {
						System.out.println("[Customer_Database:speed_Serach]"+e);
						System.out.println("[Customer_Database:speed_Serach]"+query);
				  		e.printStackTrace();
					} finally {
						try{
			                if(rs != null )			rs.close();
			                if(pstmt != null)		pstmt.close();
						}catch(Exception ignore){}
						closeConnection();
						return ht;
					}
			}
		//본동자동차용  - 계약일 10일전 계약부터 use_yn = 'Y' 인걸로  일차  처리 
		public Hashtable carNo_SearchNewB(String car_no, String js_dt)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			Hashtable ht = new Hashtable();
			int count = 0;

			String query = "";

		
			query = "select a.car_mng_id, a.car_no, b.rent_mng_id, b.rent_l_cd, b.car_st,  b.mng_id as mng_id \n"+
					"	from car_reg a , cont b \n"+
					"	where a.car_mng_id = b.car_mng_id \n"+
					" and '"+js_dt+"' between  to_char(to_date(b.rent_dt) - 10 , 'yyyymmdd' ) and b.rent_end_dt \n"+
					" and nvl(b.use_yn, 'Y' ) = 'Y'\n"+
					" and a.car_no = '"+car_no+"' ";
			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery(); 
				ResultSetMetaData rsmd = rs.getMetaData();

				if(rs.next()){	
					for(int pos =1; pos <= rsmd.getColumnCount();pos++){
						 String columnName = rsmd.getColumnName(pos);
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
					}
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				System.out.println("[Customer_Database:speed_Serach]"+e);
				System.out.println("[Customer_Database:speed_Serach]"+query);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null )			rs.close();
	                if(pstmt != null)		pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return ht;
			}
		}
		

}