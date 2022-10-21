package acar.car_register;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.con_ins.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class AddCarRegDatabase {

    private static AddCarRegDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized AddCarRegDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AddCarRegDatabase();
        return instance;
    }
    
    private AddCarRegDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }


	//자동차등록----------------------------------------------------------------------------------------------------------------

    /**
     * 자동차등록 등록.
     */
    public String insertCarReg(CarRegBean bean, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        PreparedStatement pstmt3 = null;
        PreparedStatement pstmt4 = null;
        PreparedStatement pstmt5 = null;
    	Statement stmt = null;
		CallableStatement cstmt = null;
		CallableStatement cstmt2 = null;
		CallableStatement cstmt3 = null;
		CallableStatement cstmt4 = null;
		ResultSet rs = null;
    	ResultSet rs1 = null;
    	ResultSet rs2 = null;
    	ResultSet rs3 = null;
        String query = "";
        String query1 = "";
        String query2 = "";
   		String query3 = "";
	    String query4 = "";
   		String query5 = "";
   		String query6 = "";
   		String query7 = "";
   		String query8 = "";
   		String query9 = "";
	    String car_mng_id = "";
   		String car_l_cd = "";
 		String car_doc_no = "";
		String car_doc_no_dt = "";
		String car_gu = "";
        int count = 0;
        String query3_sub1 = " ";
		String query3_sub2 = " ";
		String query3_for_acq_ex_dt1 = " ACQ_EX_DT, ";		// 납부일자 자동 입력		2017.12.07
		String query3_for_acq_ex_dt2 = " (SELECT to_char(sysdate,'YYYYMMDD') FROM DUAL),";
         
		String uni_query = "";
   		String car_num = "";
   		
   		
		query1 = " SELECT "+
				 " nvl(lpad(max(CAR_MNG_ID)+1,6,'0'),'000001') car_mng_id,"+
				 " decode(to_char(sysdate,'yy'), substr(max(car_l_cd),1,2), to_char(sysdate,'yy')||lpad(substr(max(car_l_cd),3,6)+1,4,0), to_char(sysdate,'yy')||'0001') car_l_cd"+
				 " FROM CAR_REG";

//    	query2 = " SELECT decode(to_char(sysdate,'yy'), substr(max(car_l_cd),1,2), to_char(sysdate,'yy')||lpad(substr(max(car_l_cd),3,6)+1,4,0), to_char(sysdate,'yy')||'0001') FROM car_reg";

		if(bean.getAcq_amt() == 0){			// 취득세가 0일 경우 
			query3_sub1 = "ACQ_RE, ";			// 문의처에 '면제' 입력 	2017.11.29
			query3_sub2 = "'면제',";
			query3_for_acq_ex_dt1 = " ";		// 납부일자 입력 제한		2017.12.07
			query3_for_acq_ex_dt2 = " ";
		}
		
		query3 = " INSERT INTO CAR_REG("+
				" CAR_MNG_ID, CAR_NO, CAR_NUM, INIT_REG_DT, CAR_KD, CAR_USE, CAR_NM, CAR_FORM, MOT_FORM, CAR_Y_FORM,"+
				" DPM, TAKING_P, TIRE, FUEL_KD,	CONTI_RAT, LOAN_ST, LOAN_B_AMT,	LOAN_S_AMT, LOAN_S_RAT, REG_AMT,"+
				" ACQ_AMT, ACQ_ACQ, "+// ACQ_ACQ에 취득세 자동입력 2017.11.29
				query3_for_acq_ex_dt1 +//납부일자 자동 입력 2017.11.29
				query3_sub1 +
				" NO_M_AMT, STAMP_AMT,	ETC, MAINT_ST_DT, MAINT_END_DT, FIRST_CAR_NO, CAR_END_DT, TEST_ST_DT, TEST_END_DT,"+
				" REG_DT, REG_NM, CAR_L_CD, GUAR_GEN_Y, GUAR_GEN_KM, GUAR_ENDUR_Y, GUAR_ENDUR_KM, CAR_EXT, CAR_DOC_NO, REG_PAY_DT, max_kg, reg_amt_card, no_amt_card,"+
				" UPDATE_ID, UPDATE_DT,"+
				" ACQ_AMT_CARD,"+//지역이 서울이 아닐 경우 취득세결재 신용카드 체크	2017.12.13
				" acq_is_p, acq_is_o, first_car_ext, import_car_amt, import_tax_amt, import_tax_dt, import_spe_tax_amt, car_length, car_width )\n"+
				" VALUES("+
				" ?,?,upper(?),replace(?,'-',''),?,?,upper(?),upper(?),upper(?),?,"+
				" ?,?,?,?,?,?,?,?,?,?,"+
				" ?,?,"+
				query3_for_acq_ex_dt2 +
				query3_sub2 +
				" ?,?,?,replace(?,'-',''),replace(?,'-',''),?,replace(?,'-',''),replace(?,'-',''),replace(?,'-',''),"+
				" to_char(sysdate,'YYYYMMDD'),?,?,?,?,?,?,?, ?,replace(?,'-',''),?, ?, ?, "+
				"?, sysdate, "+
				"?, "+//지역이 서울이 아닐 경우 취득세결재 신용카드 체크	2017.12.13
				"?, ?, ?, ?, ?, replace(?,'-',''), ?, ?, ?)\n";



        query4 = " INSERT INTO CAR_CHANGE(CAR_MNG_ID,CHA_SEQ,CHA_DT,CHA_CAU,CHA_CAU_SUB,CAR_NO,CAR_EXT) VALUES (?,?,replace(?,'-',''),?,?,?,?)";

		query5 = " UPDATE CONT SET CAR_MNG_ID=? WHERE RENT_MNG_ID=? AND RENT_L_CD=?";

		query6 = " select substr(replace(?,' ',''), 3,2)||'-'||substr(replace(?,' ',''), 6,2)||'-'||nvl(ltrim(to_char(to_number(max(substr(car_doc_no,7,4))+1), '0000')), '0001') car_doc_no"+
				" from car_reg "+
				" where car_doc_no like substr(replace(?,' ','') ,3,2)||'-'||substr(replace(?,' ',''), 6,2)||'-'||'%'";

		query7 = " select car_gu from cont where RENT_MNG_ID=? AND RENT_L_CD=? ";

		query8 = " UPDATE car_reg SET prepare='7', secondhand = '', rm_yn='N' WHERE CAR_MNG_ID=?";

		query9 = "{CALL P_ESTI_REG_SH(?, ?, ?)}";

		
		uni_query = "	SELECT '"+ bean.getCar_num().trim() + "' "+
				"	  FROM dual "+
				"	 WHERE NOT EXISTS (SELECT 1 "+
				"	                     FROM CAR_REG "+
				"	                    WHERE car_num = '"+ bean.getCar_num().trim()  +"')";    
		

        try{
            con.setAutoCommit(false);
            
          //car_num 중복 체크  - 차대번호가 등록이 안되어 있다면 
			stmt = con.createStatement();
	        rs = stmt.executeQuery(uni_query);
	        if(rs.next()){
	            	car_num = rs.getString(1);				
			}
			rs.close();
			
			if ( !car_num.equals("") ) {
			
	            //CAR_MNG_ID 생성, CAR_L_CD 생성
	            stmt = con.createStatement();
	            rs1 = stmt.executeQuery(query1);
	            if(rs1.next()){
	            	car_mng_id	= rs1.getString(1).trim();
					car_l_cd	= rs1.getString(2).trim();
				}
	            rs1.close();
	      		stmt.close();
	
				//차량구분
				pstmt1 = con.prepareStatement(query7);
	            pstmt1.setString(1, rent_mng_id);
	            pstmt1.setString(2, rent_l_cd);
			   	rs2 = pstmt1.executeQuery();
				if(rs2.next())
				{
					car_gu = rs2.getString(1);
				}
				rs2.close();
				pstmt1.close();
	
				//CAR_DOC_NO 생성 : 2005.07.06 추가
				car_doc_no_dt = bean.getInit_reg_dt();
				//중고차는 현재날짜
				if(car_gu.equals("2"))	car_doc_no_dt = AddUtil.getDate();
				car_doc_no_dt = AddUtil.ChangeDate2(car_doc_no_dt);
				pstmt5 = con.prepareStatement(query6);
	            pstmt5.setString(1, car_doc_no_dt);
	            pstmt5.setString(2, car_doc_no_dt);
	            pstmt5.setString(3, car_doc_no_dt);
	            pstmt5.setString(4, car_doc_no_dt);
			   	rs3 = pstmt5.executeQuery();
				if(rs3.next())
				{
					car_doc_no = rs3.getString(1);
				}
				rs3.close();
				pstmt5.close();
	
				//CAR_REG 레코드 생성
				pstmt2 = con.prepareStatement(query3);	
				pstmt2.setString(1,  car_mng_id						);
				pstmt2.setString(2,  bean.getCar_no().trim()		);
				pstmt2.setString(3,  bean.getCar_num().trim()		);
				pstmt2.setString(4,  bean.getInit_reg_dt().trim()	);
				pstmt2.setString(5,  bean.getCar_kd().trim()		);
				pstmt2.setString(6,  bean.getCar_use().trim()		);
				pstmt2.setString(7,  bean.getCar_nm().trim()		);
				pstmt2.setString(8,  bean.getCar_form().trim()		);
				pstmt2.setString(9,  bean.getMot_form().trim()		);
				pstmt2.setString(10, bean.getCar_y_form().trim()	);
				pstmt2.setString(11, bean.getDpm().trim()			);
				pstmt2.setInt   (12, bean.getTaking_p()				);
				pstmt2.setString(13, bean.getTire().trim()			);
				pstmt2.setString(14, bean.getFuel_kd().trim()		);
				pstmt2.setString(15, bean.getConti_rat().trim()		);
				pstmt2.setString(16, bean.getLoan_st().trim()		);
				pstmt2.setInt   (17, bean.getLoan_b_amt()			);
				pstmt2.setInt   (18, bean.getLoan_s_amt()			);
				pstmt2.setString(19, bean.getLoan_s_rat().trim()	);
				pstmt2.setInt   (20, bean.getReg_amt()				);
				pstmt2.setInt   (21, bean.getAcq_amt()				);
				pstmt2.setInt   (22, bean.getAcq_amt()				);	// 자동차 관리 페이지 등록수수료 취득세 입력 시 취득세 부분에도 같은 값 입력 2017. 11. 29
				pstmt2.setInt   (23, bean.getNo_m_amt()				);
				pstmt2.setInt   (24, bean.getStamp_amt()			);
				pstmt2.setInt   (25, bean.getEtc()					);
				pstmt2.setString(26, bean.getMaint_st_dt().trim()	);
				pstmt2.setString(27, bean.getMaint_end_dt().trim()	);
				pstmt2.setString(28, bean.getCar_no().trim()		);
				pstmt2.setString(29, bean.getCar_end_dt().trim()	);
				pstmt2.setString(30, bean.getTest_st_dt().trim()	);
				pstmt2.setString(31, bean.getTest_end_dt().trim()	);
				pstmt2.setString(32, bean.getReg_nm().trim()		);
				pstmt2.setString(33, car_l_cd						);
				pstmt2.setString(34, bean.getGuar_gen_y().trim()	);
				pstmt2.setString(35, bean.getGuar_gen_km().trim()	);
				pstmt2.setString(36, bean.getGuar_endur_y().trim()	);
				pstmt2.setString(37, bean.getGuar_endur_km().trim()	);
				pstmt2.setString(38, bean.getCar_ext().trim()		);
				pstmt2.setString(39, car_doc_no						);
				pstmt2.setString(40, bean.getReg_pay_dt().trim()	);
				pstmt2.setString(41, bean.getMax_kg().trim()		);
				pstmt2.setString(42, bean.getReg_amt_card().trim()	);
				pstmt2.setString(43, bean.getNo_amt_card().trim()	);
				pstmt2.setString(44, bean.getUpdate_id().trim()		);
				pstmt2.setString(45, bean.getAcq_amt_card()			);
				pstmt2.setString(46, bean.getAcq_is_p().trim()		);
				pstmt2.setString(47, bean.getAcq_is_o().trim()		);
				pstmt2.setString(48, bean.getCar_ext().trim()		);
				pstmt2.setInt   (49, bean.getImport_car_amt()		);
				pstmt2.setInt   (50, bean.getImport_tax_amt()		);
				pstmt2.setString(51, bean.getImport_tax_dt().trim()	);
				pstmt2.setInt   (52, bean.getImport_spe_tax_amt()	);
				pstmt2.setInt   (53, bean.getCar_length()			);
				pstmt2.setInt   (54, bean.getCar_width()			);
				
	            count = pstmt2.executeUpdate();
				pstmt2.close();
	
				//CONT.car_mng_id 수정
				pstmt4 = con.prepareStatement(query5);
	            pstmt4.setString(1, car_mng_id);
				pstmt4.setString(2, rent_mng_id);
				pstmt4.setString(3, rent_l_cd);						
				pstmt4.executeUpdate();
				pstmt4.close();
	
				//CAR_CHANGE : 자동차등록번호 변경관리 레코드 생성
				pstmt3 = con.prepareStatement(query4);
	            pstmt3.setString(1, car_mng_id);
	            pstmt3.setString(2, "1");
	            pstmt3.setString(3, bean.getInit_reg_dt().trim());            
	            pstmt3.setString(4, "5");            
	            pstmt3.setString(5, "");            
	            pstmt3.setString(6, bean.getCar_no().trim());            
				pstmt3.setString(7, bean.getCar_ext().trim());            
				pstmt3.executeUpdate();
				pstmt3.close();
	
				con.commit();
	
				//자산양수차량인 경우 월렌트 비결정, 재리스결정
				if(car_gu.equals("2")){
					pstmt4 = con.prepareStatement(query8);
		            pstmt4.setString(1, car_mng_id);
					pstmt4.executeUpdate();
					pstmt4.close();
	
					String set_code = "CAR"+AddUtil.getDate(4)+""+car_mng_id; 
	
					//재리스견적
					cstmt = con.prepareCall(query9);		
					cstmt.setString(1, car_mng_id);			
					cstmt.setString(2, set_code);			
					cstmt.setInt   (3, 20000);			
					cstmt.execute();
					cstmt.close();
	
					cstmt2 = con.prepareCall(query9);		
					cstmt2.setString(1, car_mng_id);			
					cstmt2.setString(2, set_code);			
					cstmt2.setInt   (3, 30000);			
					cstmt2.execute();
					cstmt2.close();
	
					cstmt3 = con.prepareCall(query9);		
					cstmt3.setString(1, car_mng_id);			
					cstmt3.setString(2, set_code);			
					cstmt3.setInt   (3, 40000);			
					cstmt3.execute();
					cstmt3.close();
					
					cstmt4 = con.prepareCall(query9);		
					cstmt4.setString(1, car_mng_id);			
					cstmt4.setString(2, set_code);			
					cstmt4.setInt   (3, 10000);			
					cstmt4.execute();
					cstmt4.close();
	
				}
	
	           
			}
			
			con.commit();
		}catch(Exception se){
            try{
				System.out.println("[AddCarRegDatabase:insertCarReg]="+se);

				System.out.println("[car_mng_id							]="+car_mng_id						);
				System.out.println("[bean.getCar_no().trim()			]="+bean.getCar_no().trim()			);
				System.out.println("[bean.getCar_num().trim()			]="+bean.getCar_num().trim()			);
				System.out.println("[bean.getInit_reg_dt().trim()		]="+bean.getInit_reg_dt().trim()		);
				System.out.println("[bean.getCar_kd().trim()			]="+bean.getCar_kd().trim()			);
				System.out.println("[bean.getCar_use().trim()			]="+bean.getCar_use().trim()			);
				System.out.println("[bean.getCar_nm().trim()			]="+bean.getCar_nm().trim()			);
				System.out.println("[bean.getCar_form().trim()			]="+bean.getCar_form().trim()		);
				System.out.println("[bean.getMot_form().trim()			]="+bean.getMot_form().trim()		);
				System.out.println("[bean.getCar_y_form().trim()		]="+bean.getCar_y_form().trim()		);
				System.out.println("[bean.getDpm().trim()				]="+bean.getDpm().trim()				);
				System.out.println("[bean.getTaking_p()					]="+bean.getTaking_p()				);
				System.out.println("[bean.getTire().trim()				]="+bean.getTire().trim()			);
				System.out.println("[bean.getFuel_kd().trim()			]="+bean.getFuel_kd().trim()			);
				System.out.println("[bean.getConti_rat().trim()			]="+bean.getConti_rat().trim()		);
				System.out.println("[bean.getLoan_st().trim()			]="+bean.getLoan_st().trim()			);
				System.out.println("[bean.getLoan_b_amt()				]="+bean.getLoan_b_amt()				);
				System.out.println("[bean.getLoan_s_rat().trim()		]="+bean.getLoan_s_rat().trim()		);
				System.out.println("[bean.getReg_amt()					]="+bean.getReg_amt()				);
				System.out.println("[bean.getAcq_amt()					]="+bean.getAcq_amt()				);
				System.out.println("[bean.getAcq_acq()					]="+bean.getAcq_acq()				);
				System.out.println("[bean.getNo_m_amt()					]="+bean.getNo_m_amt()				);
				System.out.println("[bean.getStamp_amt()				]="+bean.getStamp_amt()				);
				System.out.println("[bean.getEtc()						]="+bean.getEtc()					);
				System.out.println("[bean.getMaint_st_dt().trim()		]="+bean.getMaint_st_dt().trim()		);
				System.out.println("[bean.getMaint_end_dt().trim()		]="+bean.getMaint_end_dt().trim()	);
				System.out.println("[bean.getCar_no().trim()			]="+bean.getCar_no().trim()			);
				System.out.println("[bean.getCar_end_dt().trim()		]="+bean.getCar_end_dt().trim()		);
				System.out.println("[bean.getTest_st_dt().trim()		]="+bean.getTest_st_dt().trim()		);
				System.out.println("[bean.getTest_end_dt().trim()		]="+bean.getTest_end_dt().trim()		);
				System.out.println("[bean.getReg_nm().trim()			]="+bean.getReg_nm().trim()			);
				System.out.println("[car_l_cd							]="+car_l_cd							);
				System.out.println("[bean.getGuar_gen_y().trim()		]="+bean.getGuar_gen_y().trim()		);
				System.out.println("[bean.getGuar_gen_km().trim()		]="+bean.getGuar_gen_km().trim()		);
				System.out.println("[bean.getGuar_endur_y().trim()		]="+bean.getGuar_endur_y().trim()	);
				System.out.println("[bean.getGuar_endur_km().trim()		]="+bean.getGuar_endur_km().trim()	);
				System.out.println("[bean.getCar_ext().trim()			]="+bean.getCar_ext().trim()			);
				System.out.println("[car_doc_no							]="+car_doc_no						);
				System.out.println("[bean.getReg_pay_dt().trim()		]="+bean.getReg_pay_dt().trim()		);
				System.out.println("[bean.getMax_kg().trim()			]="+bean.getMax_kg().trim()			);
				System.out.println("[bean.getReg_amt_card().trim()		]="+bean.getReg_amt_card().trim()	);
				System.out.println("[bean.getNo_amt_card().trim()		]="+bean.getNo_amt_card().trim()		);


			    con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(rs1 != null) rs1.close();
                if(rs2 != null) rs2.close();
                if(rs3 != null) rs3.close();
                if(stmt != null) stmt.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt3 != null) pstmt3.close();
                if(pstmt4 != null) pstmt4.close();
                if(pstmt5 != null) pstmt5.close();
				if(cstmt != null)  cstmt.close();
				if(cstmt2 != null)  cstmt2.close();
				if(cstmt3 != null)  cstmt3.close();
				if(cstmt4 != null)  cstmt4.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return car_mng_id.trim();
    }

	/**
     * 할부관리 자동차관리번호 체크
     */

    public String getCar_mng_id2(String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
    	ResultSet rs = null;
        String query = "";
        String car_mng_id2 = "";
                
		query = "select car_mng_id from allot where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"'";

       try{
   
				//자동차등록번호(할부등록)임시번호여부
	            stmt = con.createStatement();
	            rs = stmt.executeQuery(query);        
	            
	            while(rs.next()){
					car_mng_id2 = rs.getString(1)==null?"":rs.getString(1).trim();            	
				}
				
		  rs.close();
	           stmt.close();
		}catch(SQLException se){
			System.out.println("[AddCarRegDatabase:getCar_mng_id2]="+se);
            throw new DatabaseException("exception");
        }finally{
            try{
		if(rs != null) rs.close();
                  if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return car_mng_id2;
    }


	/**
     * 할부관리 자동차관리번호 체크
     */
     
      public String getCar_mng_id3(String car_mng_id2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
    	ResultSet rs = null;
          String query = "";
            String car_mng_id3 = "";
                
		query = "select car_mng_id from scd_alt_case where car_mng_id='"+car_mng_id2+"'";

       try{
   
				//자동차등록번호(할부등록)임시번호여부
	            stmt = con.createStatement();
	            rs = stmt.executeQuery(query);        
	            
	            while(rs.next()){
					car_mng_id3 = rs.getString(1)==null?"":rs.getString(1).trim();           
				}
				
		  rs.close();
	           stmt.close();
		}catch(SQLException se){
			System.out.println("[AddCarRegDatabase:getCar_mng_id3]="+se);
            throw new DatabaseException("exception");
        }finally{
            try{
		if(rs != null) rs.close();
                  if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return car_mng_id3;
    }
    
    
    /* 
    public String getCar_mng_id3(String car_mng_id2) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	Statement stmt = null;
    	ResultSet rs = null;
        String query = "";
        String car_mng_id3 = "";
                
		query = "select car_mng_id from scd_alt_case where car_mng_id='"+car_mng_id2+"'";

       try{
         

			//자동차등록번호(할부등록)임시번호여부
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);            
            if(rs.next()){
            	car_mng_id3 = rs.getString(1)==null?"":rs.getString(1).trim();            	
			}else{				
			}
            rs.close();
            stmt.close();
       

		}catch(SQLException se){
            try{
				System.out.println("[AddCarRegDatabase:getCar_mng_id3]="+se);
			
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
             
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return car_mng_id3;
    }
*/

	/**
     * 자동차등록 등록시 관련 처리들.
     */
    public int updateAllotCar(String car_mng_id, String car_mng_id2, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        String query1 = "";
        String query2 = "";
        int count = 0;
                
		query1 = "insert into fine_call(car_mng_id) values('"+car_mng_id+"')";

		query2 = "update allot set car_mng_id='"+car_mng_id+"', imsi_chk='0' where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"'";


            
       try{
            con.setAutoCommit(false);

			pstmt1 = con.prepareStatement(query1);
			count = pstmt1.executeUpdate();
			pstmt1.close();
			
			pstmt2 = con.prepareStatement(query2);
			count = pstmt2.executeUpdate();
			pstmt2.close();


            con.commit();

		}catch(Exception se){
            try{
				System.out.println("[AddCarRegDatabase:updateAllotCar]="+se);
				System.out.println("[AddCarRegDatabase:car_mng_id]="+car_mng_id);
				System.out.println("[AddCarRegDatabase:car_mng_id2]="+car_mng_id2);
				System.out.println("[AddCarRegDatabase:rent_mng_id]="+rent_mng_id);
				System.out.println("[AddCarRegDatabase:rent_l_cd]="+rent_l_cd);
			    con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

	/**
     * 자동차등록 등록시 관련 처리들.
     */
    public int updateAllotCar2(String car_mng_id, String car_mng_id2, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt3 = null;
   		String query3 = "";
        int count = 0;
                

		query3 = "update scd_alt_case set car_mng_id='"+car_mng_id+"' where car_mng_id='"+car_mng_id2+"'";

            
       try{
            con.setAutoCommit(false);

			pstmt3 = con.prepareStatement(query3);
			count = pstmt3.executeUpdate();
			pstmt3.close();

            con.commit();

		}catch(Exception se){
            try{
				System.out.println("[AddCarRegDatabase:updateAllotCar2]="+se);
				System.out.println("[AddCarRegDatabase:car_mng_id]="+car_mng_id);
				System.out.println("[AddCarRegDatabase:car_mng_id2]="+car_mng_id2);
				System.out.println("[AddCarRegDatabase:rent_mng_id]="+rent_mng_id);
				System.out.println("[AddCarRegDatabase:rent_l_cd]="+rent_l_cd);
			    con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt3 != null) pstmt3.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return count;
    }

	//자동차보험관련-----------------------------------------------------------------------------------------

    /**
     * 보험 유무 판단
     */    
    public int getInsurTF(String car_mng_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        int tf = 0;
		query = "select count(CAR_MNG_ID) from insur where car_mng_id='" + car_mng_id + "'\n";
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next()){
                tf = rs.getInt(1);
			}

			rs.close();
            stmt.close();	
        }catch (SQLException e) {
			System.out.println("[AddCarRegDatabase:getInsurTF]"+e);
            throw new DatabaseException(e.getMessage());
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return tf;
    }

	/**
     * 자동차등록 등록시 관련 처리들.
     */
    public int upCarRegScan(String car_mng_id, String filename) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query = "update car_reg set scanfile=? where car_mng_id=? ";
            
       try{
		   con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, filename);
			pstmt.setString(2, car_mng_id);
			count = pstmt.executeUpdate();
   			pstmt.close();
			con.commit();
			
		}catch(SQLException se){
            try{
				System.out.println("[AddCarRegDatabase:upCarRegScan]="+se);
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
     * 자동차등록 등록시 관련 처리들.
     */
    public String getScanFile(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		ResultSet rs = null;
        String query = "";
		String filename = "";
                
		query = "SELECT scanfile FROM car_reg WHERE car_mng_id=? ";
            
       try{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
			rs = pstmt.executeQuery();
			while(rs.next()){
				filename = rs.getString(1)==null?"":rs.getString(1);
			}
			
			rs.close();
            pstmt.close();
		}catch(SQLException se){
			System.out.println("[AddCarRegDatabase:getScanFile]="+se);
            throw new DatabaseException("exception");
        }finally{
            try{
				if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return filename;
    }


/**
     * 자동차등록 등기등록시 관련 처리들.
     */
    public int Updatedg_no(CarRegBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
		query = "update car_reg set dg_id=? , dg_dt = replace(?, '-', ''), dg_no = ?, dg_yn = ? where car_mng_id=? ";

			
       try{
		   con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
			pstmt.setString(1, bean.getDg_id().trim());
			pstmt.setString(2, bean.getDg_dt().trim());
			pstmt.setString(3, bean.getDg_no().trim());
			pstmt.setString(4, bean.getDg_yn().trim());
			pstmt.setString(5, bean.getCar_mng_id().trim());
			count = pstmt.executeUpdate();
       		pstmt.close();
			con.commit();

		}catch(SQLException se){
            try{
				System.out.println("[AddCarRegDatabase:Updatedg_no]="+se);
				System.out.println("[AddCarRegDatabase:Updatedg_no]="+query);
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



public Hashtable dg_list(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

	
		query = "select * from car_reg where car_mng_id = ? ";

		try{
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, car_mng_id);
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

		}catch(SQLException e){
			System.out.println("[AddCarRegDatabase:dg_list(String car_mng_id)]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			return ht;
		}		
	}






}
