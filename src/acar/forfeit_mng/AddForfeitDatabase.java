/*
 * 과태료/범칙금
 */
package acar.forfeit_mng;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.common.*;
import acar.account.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class AddForfeitDatabase {

    private static AddForfeitDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized AddForfeitDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AddForfeitDatabase();
        return instance;
    }
    
    private AddForfeitDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }


	// Bean -------------------------------------------------------------------------------------------------

	/**
     * 과태료,범칙금 빈
     */
    private FineBean makeFineBean(ResultSet results) throws DatabaseException {

        try {
            FineBean bean = new FineBean();

		    bean.setCar_mng_id(results.getString("CAR_MNG_ID")); 		//자동차관리번호
			bean.setRent_mng_id(results.getString("RENT_MNG_ID"));		//계약관리번호
			bean.setRent_l_cd(results.getString("RENT_L_CD"));			//계약번호
			bean.setCar_no(results.getString("CAR_NO"));
			bean.setFirm_nm(results.getString("FIRM_NM"));
			bean.setFine_st(results.getString("FINE_ST"));
			bean.setCar_nm(results.getString("CAR_NM"));
			bean.setCar_name(results.getString("CAR_NAME"));			
			bean.setSeq_no(results.getInt("SEQ_NO"));					//SEQ_NO
			bean.setCall_nm(results.getString("CALL_NM"));				//통화자
			bean.setTel(results.getString("TEL"));						//전화번호
			bean.setFax(results.getString("FAX"));						//팩스
			bean.setVio_dt(results.getString("VIO_DT"));				//위반일시
			bean.setVio_dt_view(results.getString("VIO_DT_VIEW"));
			bean.setVio_pla(results.getString("VIO_PLA"));				//위반장소
			bean.setVio_cont(results.getString("VIO_CONT"));			//위반내용
			bean.setPaid_st(results.getString("PAID_ST"));				//납부구분
			bean.setRec_dt(results.getString("REC_DT"));				//영수일자
			bean.setPaid_end_dt(results.getString("PAID_END_DT"));		//납부기한
			bean.setPaid_amt(results.getInt("PAID_AMT"));				//납부금액
			bean.setPaid_amt2(results.getInt("PAID_AMT2"));				//납부금액
			bean.setProxy_dt(results.getString("PROXY_DT"));			//대납일자
			bean.setPol_sta(results.getString("POL_STA"));				//경찰서
			bean.setPaid_no(results.getString("PAID_NO"));				//납부고지서번호
			bean.setFault_st(results.getString("FAULT_ST"));			//과실구분
			bean.setFault_nm(results.getString("FAULT_NM"));			//업무과실자
			bean.setFault_amt(results.getInt("FAULT_AMT"));				//업무과실자금액
			bean.setDem_dt(results.getString("DEM_DT"));				//청구일자
			bean.setColl_dt(results.getString("COLL_DT"));				//수금일자
			bean.setRec_plan_dt(results.getString("REC_PLAN_DT"));		//입금예정일
			bean.setNote(results.getString("NOTE"));					//특이사항
			bean.setNo_paid_yn(results.getString("NO_PAID_YN"));		//면제여부
			bean.setNo_paid_cau(results.getString("NO_PAID_CAU"));		//면제사유
			bean.setUpdate_id(results.getString("UPDATE_ID"));			//최종수정자
			bean.setUpdate_dt(results.getString("UPDATE_DT"));			//최종수정일
			bean.setObj_dt1(results.getString("OBJ_DT1"));				//1차이의신청일자
			bean.setObj_dt2(results.getString("OBJ_DT2"));				//1차이의신청일자
			bean.setObj_dt3(results.getString("OBJ_DT3"));				//1차이의신청일자
			bean.setBill_doc_yn(results.getString("BILL_DOC_YN"));		//거래명세서 포함여부
			bean.setBill_mon(results.getString("BILL_MON"));			//거래명세서 포함월
			bean.setVat_yn(results.getString("VAT_YN"));				//부가가치세 포함여부
			bean.setTax_yn(results.getString("TAX_YN"));				//세금계산서 발행여부
			bean.setF_dem_dt(results.getString("F_DEM_DT"));			//최초청구일
			bean.setE_dem_dt(results.getString("E_DEM_DT"));			//최종청구일
			bean.setBusi_st(results.getString("BUSI_ST"));				//거래구분
			bean.setRent_s_cd(results.getString("RENT_S_CD"));			//단기계약번호
			bean.setNotice_dt(results.getString("NOTICE_DT"));			//사실확인접수일자
			bean.setObj_end_dt(results.getString("OBJ_END_DT"));		//의견진술기한
			bean.setExt_dt(results.getString("EXT_DT"));				//세금계산서발행일자
			bean.setMng_id(results.getString("MNG_ID"));				//과태료담당자
			bean.setFile_name(results.getString("FILE_NAME"));			//스캔파일
			bean.setFile_type(results.getString("FILE_TYPE"));			//스캔파일			
			bean.setIncom_dt(results.getString("INCOM_DT"));			//입금원장
			bean.setIncom_seq(results.getInt("INCOM_SEQ"));				//입금원장
			bean.setFile_name2(results.getString("FILE_NAME2"));			//스캔파일
			bean.setFile_type2(results.getString("FILE_TYPE2"));			//스캔파일
			bean.setReg_id(results.getString("REG_ID"));			//최초등록자
			bean.setDmidx(results.getInt("DMIDX"));
			bean.setFine_gb(results.getString("FINE_GB"));
			bean.setFine_nm(results.getString("FINE_NM"));
			bean.setRent_st(results.getString("RENT_ST"));
			bean.setRe_reg_id(results.getString("RE_REG_ID"));			//재등록자
			bean.setRe_reg_dt(results.getString("RE_REG_DT"));			//재등록일
			bean.setVio_st(results.getString("VIO_ST"));				//위반구분
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	/**
     * 과태료/면책금 등록시 계약 조회 빈
     */
    private RentListBean makeRegListBean(ResultSet results) throws DatabaseException {

        try {
            RentListBean bean = new RentListBean();

		    bean.setRent_mng_id(results.getString("RENT_MNG_ID"));					//계약관리ID
		    bean.setRent_l_cd(results.getString("RENT_L_CD"));					//계약코드
		    bean.setRent_dt(results.getString("RENT_DT"));					//계약일자
		    bean.setDlv_dt(results.getString("DLV_DT"));					//출고일자
		    bean.setClient_id(results.getString("CLIENT_ID"));					//고객ID
		    bean.setClient_nm(results.getString("CLIENT_NM"));					//고객 대표자명
		    bean.setFirm_nm(results.getString("FIRM_NM"));						//상호
		    bean.setO_tel(results.getString("O_TEL"));						//사무실전화
		    bean.setFax(results.getString("FAX"));						//FAX
		    bean.setBr_id(results.getString("BR_ID"));						//
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));					//자동차관리ID
		    bean.setInit_reg_dt(results.getString("INIT_REG_DT"));					//최초등록일
		    bean.setReg_gubun(results.getString("REG_GUBUN"));					//최초등록일
		    bean.setCar_no(results.getString("CAR_NO"));						//차량번호
		    bean.setCar_num(results.getString("CAR_NUM"));						//차대번호
		    bean.setRent_way(results.getString("RENT_WAY"));					//대여방식
		    bean.setCon_mon(results.getString("CON_MON"));						//대여개월
		    bean.setCar_id(results.getString("CAR_ID"));						//차명ID
		    bean.setImm_amt(results.getInt("IMM_AMT"));						//자차면책금
		    bean.setCar_name(results.getString("CAR_NAME"));					//차명
		    bean.setCar_nm(results.getString("CAR_NM"));
		    bean.setRent_start_dt(results.getString("RENT_START_DT"));				//대여개시일
		    bean.setRent_end_dt(results.getString("RENT_END_DT"));					//대여종료일
		    bean.setReg_ext_dt(results.getString("REG_EXT_DT"));					//등록예정일
		    bean.setRpt_no(results.getString("RPT_NO"));						//계출번호
		    bean.setCpt_cd(results.getString("CPT_CD"));						//은행코드
		    //bean.setBank_nm(results.getString("BANK_NM"));						//은행명
		    
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }
	}

	
	// 조회 -------------------------------------------------------------------------------------------------

	//과태료 리스트 조회(수금현황)
	public Vector getFineList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String standard_dt = "decode(a.rec_plan_dt, '',decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt), a.rec_plan_dt)";
		String s_query = "";
		if(s_kd.equals("17")){
			s_query = " , (select user_id, user_nm from users where user_nm like '"+t_wd+"%') k";
		}

		String query = "";

		query = " select /*+  no_merge(b) */ \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_id, b.client_nm, '' scan_file,\n"+
				"        cr.car_no, cr.first_car_no,cr.car_nm, cn.car_name, decode(a.coll_dt, '','미수금','수금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3', '외부업체과실') fault_st, a.fault_nm, a.vio_pla, a.vio_cont, a.dly_days,\n"+
				"        decode(a.fault_st, '1', a.paid_amt, '2', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt), '3', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt)) paid_amt,\n"+
				"        b.use_yn, b.mng_id, b.rent_st, decode(a.paid_st, '2','고객납입','3','회사대납','1','납부자변경','4','수금납입','미정') paid_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2),'') vio_dt,\n"+
				"        nvl2(a.rec_plan_dt,substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2),'') rec_plan_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt,\n"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,\n"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm) cust_nm,"+
				"        decode(a.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id,g.bus_id)) bus_id2, a.mng_id as fine_mng_id, a.reg_id \n"+
				" from   fine a, cont_n_view b, car_reg cr, car_etc ce, car_nm cn ,  rent_cont g, client h, users i, cont j "+s_query+" \n"+
				" where\n"+
				"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.sub_l_cd=j.rent_l_cd(+) \n"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+) \n"+
				"        and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y' and a.paid_st in ('3','4') ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM')";
		//당월-수금
//		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM') and a.coll_dt is not null";
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr(a.coll_dt,1,6) = to_char(SYSDATE, 'YYYYMM')";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM') and a.coll_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-수금
//		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD') and (a.coll_dt is not null or a.coll_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and a.coll_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and "+standard_dt+" < to_char(SYSDATE, 'YYYYMMDD') and (a.coll_dt is null or a.coll_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and "+standard_dt+" < to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and "+standard_dt+" < to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
//		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.coll_dt is not null";
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.coll_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.coll_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and (a.coll_dt is null or a.coll_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.coll_dt is not null";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.coll_dt is null";
		}


		if(gubun5.equals("3"))			query += " and a.fault_st='1'";//고객과실
		else if(gubun5.equals("5"))		query += " and a.fault_st='2'";//업무상과실
		else if(gubun5.equals("12"))	query += " and a.fault_st='2' and g.rent_st in ('4','5') ";//업무대여과실
		else if(gubun5.equals("2"))		query += " and a.fault_st='3'";//외부업체과실

		//해지미청구분 	
		if(!gubun5.equals("6"))			query += " and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='Y'";//해지분이 아니면 조건걸음

		//퇴사자해지분(장기+퇴사자해지+매각)
//		if(gubun5.equals("7"))			query += " and b.use_yn='N' and a.rent_s_cd is null and b.bus_id2 in (select user_id from users where dept_id='9999') and b.car_mng_id in (select car_mng_id from sui where cont_dt is not null)";
		//퇴사자해지분(단기+퇴사자해지+매각)
//		if(gubun5.equals("7"))			query += " and b.use_yn='N' and a.rent_s_cd is not null and b.bus_id2 in (select user_id from users where dept_id='9999') and b.car_mng_id in (select car_mng_id from sui where cont_dt is not null)";
		//퇴사자해지분(장기+퇴사자해지+대납)
//		if(gubun5.equals("7"))			query += " and b.use_yn='N' and a.rent_s_cd is null and b.bus_id2 in (select user_id from users where dept_id='9999') and a.proxy_dt is not null ";
		//퇴사자해지분(단기+퇴사자해지+대납)
//		if(gubun5.equals("7"))			query += " and b.use_yn='N' and a.rent_s_cd is not null and b.bus_id2 in (select user_id from users where dept_id='9999') and a.proxy_dt is not null ";
		//퇴사자해지분(퇴사자해지)
		if(gubun5.equals("7"))			query += " and b.use_yn='N' and decode(a.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id,g.bus_id)) in (select user_id from users where dept_id='9999')";

		//해지분(해지+매각+거래없는고객+납부기한2011이전+장기대여차량)
		if(gubun5.equals("8"))			query += " and b.use_yn='N' and b.car_mng_id in (select car_mng_id from sui where cont_dt is not null) and b.client_id not in (select client_id from cont where use_yn='Y' group by client_id)";
		//해지분(해지+매각+거래없는고객+납부기한2011이전+보유차량)
//		if(gubun5.equals("8"))			query += " and b.use_yn='N' and b.car_mng_id in (select car_mng_id from sui where cont_dt is not null) and a.rent_s_cd is not null and g.cust_st='1' and g.cust_id not in (select client_id from cont where use_yn='Y' group by client_id)";
		//해지분(해지+매각+보유차+납부기한2011이전)
//		if(gubun5.equals("8"))			query += " and b.use_yn='N' and b.car_mng_id in (select car_mng_id from sui where cont_dt is not null) and b.car_st='2'";

		//보유차-단기미연결분
		if(gubun5.equals("9"))			query += " and b.car_st='2' and a.rent_s_cd is null";

		if(gubun5.equals("10"))			query += " and a.vio_cont like '%통행료%' ";
		if(gubun5.equals("11"))			query += " and a.vio_cont not like '%통행료%'";

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				query += " and a.dly_days between 1 and 30";
			}else if(gubun4.equals("3")){ //부실연체
				query += " and a.dly_days between 31 and 60";
			}else if(gubun4.equals("4")){ //악성연체
				query += " and a.dly_days between 61 and 1000";
			}else{}
		}

		//if(!br_id.equals("S1") && !br_id.equals(""))		query += " and b.brch_id='"+br_id+"'";

		/*검색조건*/
			
		if(s_kd.equals("1"))		query += " and nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm,b.firm_nm)||decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트'), '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm||h.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '')||nvl(cr.first_car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and nvl(b.mng_id,b.bus_id2)= '"+t_wd+"'\n";
		else if(s_kd.equals("14"))	query += " and decode(a.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id))= '"+t_wd+"'\n";

		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.pol_sta like '%"+t_wd+"%'\n";
		else if(s_kd.equals("15"))	query += " and nvl(a.vio_cont, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("16"))	query += " and nvl(a.mng_id, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("17"))	query += "  and a.FAULT_NM = k.user_id ";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

//		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.rec_plan_dt "+sort+", a.coll_dt, b.firm_nm";
		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.paid_end_dt "+sort+", a.coll_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm,b.firm_nm) "+sort+", a.coll_dt, a.rec_plan_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.proxy_dt "+sort+", b.firm_nm, a.rec_plan_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.coll_dt, b.firm_nm, a.rec_plan_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm, a.rec_plan_dt";
		else if(sort_gubun.equals("6"))	query += " order by b.use_yn desc, decode(a.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id,g.bus_id)) "+sort+", b.firm_nm, a.rec_plan_dt";
	
//System.out.println("getFineList(: "+query);

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
	    	//System.out.println(query);
	    	
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return vt;
		}
	}

	/**
	 *	과태료/범칙금 관리 검색통계(수금현황)
	 */
	public Vector getFineStat(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
       
		sub_query = " select /*+  no_merge(b) */ \n"+
					"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm,  b.client_nm,\n"+
					"        c.car_no, c.car_nm, decode(a.coll_dt, '','미수금','수금') gubun,\n"+
					"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','마스타과실') fault_st, a.vio_pla,\n"+
					"        decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, b.mng_id, b.rent_st,\n"+
					"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2),'') vio_dt,\n"+
					"        nvl2(a.rec_plan_dt,substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2),'') rec_plan_dt,\n"+
					"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt\n"+
					" from   fine a, cont_n_view b, car_reg c \n"+
					" where\n"+
					"        a.car_mng_id=b.car_mng_id(+) and a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
					"        and a.car_mng_id = c.car_mng_id(+) and a.paid_st <> '2' and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y' ";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		sub_query += " and substr(a.rec_plan_dt,1,6) = to_char(SYSDATE, 'YYYYMM')";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	sub_query += " and substr(a.rec_plan_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.coll_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	sub_query += " and substr(a.rec_plan_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.coll_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	sub_query += " and a.rec_plan_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	sub_query += " and a.rec_plan_dt = to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	sub_query += " and a.rec_plan_dt = to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt is null";
		//연체-계획
		}else if(gubun2.equals("3") && gubun3.equals("1")){	sub_query += " and a.rec_plan_dt < to_char(SYSDATE, 'YYYYMMDD') and (a.coll_dt is null or a.coll_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//연체-수금
		}else if(gubun2.equals("3") && gubun3.equals("2")){	sub_query += " and a.rec_plan_dt < to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//연체-미수금
		}else if(gubun2.equals("3") && gubun3.equals("3")){	sub_query += " and a.rec_plan_dt < to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	sub_query += " and a.rec_plan_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	sub_query += " and a.rec_plan_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.coll_dt not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	sub_query += " and a.rec_plan_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.coll_dt is null";
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	sub_query += " and a.rec_plan_dt <= to_char(SYSDATE, 'YYYYMMDD') and (a.coll_dt is null or a.coll_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	sub_query += " and a.rec_plan_dt <= to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	sub_query += " and a.rec_plan_dt <= to_char(SYSDATE, 'YYYYMMDD') and a.coll_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	sub_query += " and a.coll_dt not null";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	sub_query += " and a.coll_dt is null";
		}

		/*연체조회*/

		if(gubun2.equals("3")){
			if(gubun4.equals("2")){	//일반연체		
				sub_query += " and a.dly_days between 1 and 30";
			}else if(gubun4.equals("3")){ //부실연체
				sub_query += " and a.dly_days between 31 and 60";
			}else if(gubun4.equals("4")){ //악성연체
				sub_query += " and a.dly_days between 61 and 1000";
			}else{}
		}

//		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id='"+br_id+"'";

		/*검색조건*/
			
		if(s_kd.equals("2"))		sub_query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	sub_query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	sub_query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	sub_query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	sub_query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	sub_query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	sub_query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	sub_query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	sub_query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	sub_query += " and a.pol_sta like '%"+t_wd+"%'\n";
		else						sub_query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		

		query = " select '계획' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where substr(rec_plan_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where rec_plan_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where rec_plan_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (coll_dt is null or coll_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) c\n"+
				" union all\n"+
				" select '수금' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where substr(rec_plan_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and coll_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where rec_plan_dt = to_char(SYSDATE, 'YYYY-MM-DD') and coll_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where rec_plan_dt < to_char(SYSDATE, 'YYYY-MM-DD') and coll_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) c\n"+
				" union all\n"+
				" select '미수금' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where substr(rec_plan_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and coll_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where rec_plan_dt = to_char(SYSDATE, 'YYYY-MM-DD') and coll_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where rec_plan_dt < to_char(SYSDATE, 'YYYY-MM-DD') and coll_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where substr(rec_plan_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where substr(rec_plan_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and coll_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where rec_plan_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where rec_plan_dt = to_char(SYSDATE, 'YYYY-MM-DD') and coll_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where rec_plan_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (coll_dt is null or coll_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where rec_plan_dt < to_char(SYSDATE, 'YYYY-MM-DD') and coll_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) c";

		try {
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next())
			{
				IncomingBean fee = new IncomingBean();
				fee.setGubun(rs.getString(1));
				fee.setGubun_sub(rs.getString(2));
				fee.setTot_su1(rs.getInt(3));
				fee.setTot_amt1(rs.getInt(4));
				fee.setTot_su2(rs.getInt(5));
				fee.setTot_amt2(rs.getInt(6));
				fee.setTot_su3(rs.getInt(7));
				fee.setTot_amt3(rs.getInt(8));
				vt.add(fee);
			}
			rs.close();
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineStat]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}	

	//과태료 리스트 조회(지출현황)
	public Vector getFineExpList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
			//String standard_dt = "decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt)";
		String standard_dt = "decode(nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')), '',a.paid_end_dt, nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')))";
		String s_query = "";
		if(s_kd.equals("16")){
			s_query = " , (select user_id, user_nm from users where user_nm like '"+t_wd+"%') k";
		}		
		String query = "";
		query = " select /*+  no_merge(b) */ \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, nvl(b.firm_nm, b.client_nm) firm_nm, b.client_nm, ''scan_file,\n"+
				"        cr.car_no, cr.first_car_no,cr.car_nm , cn.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				"        decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st, \n"+
				"        a.pol_sta, decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt, e.gov_nm, \n"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm) cust_nm, a.fault_nm \n"+
				" from   fine a, cont_n_view b, car_reg cr,  car_etc ce, car_nm cn ,  fine_gov e, rent_cont g, client h, users i, rent_cust j "+s_query+"\n"+
				" where\n"+
				"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)  \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+
				"        and a.paid_amt > 0 and a.pol_sta=e.gov_id(+)";

		/*상세조회&&세부조회*/

//	if(!gubun2.equals("5")){

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM')";// and a.paid_st <> '2'
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is not null";// and a.paid_st <> '2'
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is null";// and a.paid_st <> '2'
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";// and a.paid_st <> '2'
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and (a.proxy_dt is null or a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.proxy_dt is not null";
		//검색-미지출
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.proxy_dt is null";
		//접수일자
		}else if(gubun2.equals("7")){	query += " and a.rec_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		}
//	}

		if(gubun4.equals("2"))			query += " and a.fault_st='1'";
		else if(gubun4.equals("3"))		query += " and a.fault_st='2'";
		else if(gubun4.equals("4"))		query += " and a.paid_st='2'";
		else if(gubun4.equals("5"))		query += " and a.paid_st='3'";
		else if(gubun4.equals("6"))		query += " and a.paid_st='1'";
		else if(gubun4.equals("7"))		query += " and a.paid_st='4'";
		else if(gubun4.equals("8"))		query += " and a.paid_st<>'1'";
		else if(gubun4.equals("9"))		query += " and a.fault_st='3'";
		

		/*검색조건*/
	if(!t_wd.equals("")){	
		if(s_kd.equals("2"))		query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '')||nvl(cr.first_car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and nvl(a.mng_id, nvl(b.mng_id,b.bus_id2))= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.pol_sta||e.gov_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("14"))	query += " and nvl(a.rec_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("15"))	query += " and nvl(a.vio_cont, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("16"))	query += " and a.FAULT_NM = k.user_id ";
		else if(s_kd.equals("17"))	query += " and nvl(a.proxy_dt, '') like '%"+t_wd+"%'\n";  //대납일자
		else						query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
	}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.vio_dt "+sort+", a.paid_end_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.vio_dt, a.paid_end_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.proxy_dt "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.proxy_dt, b.firm_nm, a.paid_end_dt";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("6"))	query += " order by e.gov_nm "+sort+", a.rec_dt, cr.car_no, b.firm_nm, a.paid_end_dt";



//System.out.println(query);
	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineExpList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineExpList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}
	
	

	/**
	 *	과태료/범칙금 관리 검색통계(지출현황)
	 */
	public Vector getFineExpStat(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
       
		sub_query = " select /*+  merge(b) */ \n"+
					"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm,\n"+
					"        c.car_no, c.car_nm, decode(a.proxy_dt,'','미출금','출금') gubun,\n"+
					"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','마스타과실') fault_st, a.vio_pla, a.paid_no, "+
					"        decode(a.paid_st, '1','미정','2','고객납입','3','회사대납') paid_st,"+
					"        a.pol_sta, decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, b.mng_id, b.rent_st,\n"+
					"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
					"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
					"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt\n"+
					" from   fine a, cont_n_view b, car_reg c \n"+
					" where\n"+
					"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
					"        and a.car_mng_id = c.car_mng_id(+) and a.paid_amt > 0";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		sub_query += " and substr(a.paid_end_dt,1,6) = to_char(SYSDATE, 'YYYYMM')";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	sub_query += " and substr(a.paid_end_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	sub_query += " and substr(a.paid_end_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	sub_query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	sub_query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	sub_query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	sub_query += " and a.vio_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	sub_query += " and a.vio_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	sub_query += " and a.vio_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	sub_query += " and a.proxy_dt not null";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	sub_query += " and a.proxy_dt is null";
		//접수일자
		}else if(gubun2.equals("6")){	sub_query += " and a.rec_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		}
		//to_char(to_date(req_dt, 'YYYYMMDD')+7, 'YYYYMMDD') -> 일주일까지쳐줌

		if(gubun4.equals("2"))			sub_query += " and a.fault_st='1'";
		else if(gubun4.equals("3"))		sub_query += " and a.fault_st='2'";
		else if(gubun4.equals("4"))		sub_query += " and a.paid_st='2'";
		else if(gubun4.equals("5"))		sub_query += " and a.paid_st in ('1','3')";
		
//		if(!br_id.equals("S1") && !br_id.equals(""))		sub_query += " and b.brch_id='"+br_id+"'";

		/*검색조건*/
			
		if(s_kd.equals("2"))		sub_query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	sub_query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	sub_query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	sub_query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	sub_query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	sub_query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	sub_query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	sub_query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	sub_query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	sub_query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	sub_query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	sub_query += " and a.pol_sta like '%"+t_wd+"%'\n";
		else if(s_kd.equals("14"))	sub_query += " and nvl(a.rec_dt, '') like '%"+t_wd+"%'\n";
		else						sub_query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		

		query = " select '계획' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+
					" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where substr(paid_end_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where paid_end_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where paid_end_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (proxy_dt is null or proxy_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) c\n"+
				" union all\n"+
				" select '출금' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from\n"+ 
					" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where substr(paid_end_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and proxy_dt is not null) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where paid_end_dt = to_char(SYSDATE, 'YYYY-MM-DD') and proxy_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b,\n"+	
					" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where paid_end_dt < to_char(SYSDATE, 'YYYY-MM-DD') and proxy_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) c\n"+
				" union all\n"+
				" select '미출금' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where substr(paid_end_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and proxy_dt is null ) a,\n"+
					" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where paid_end_dt = to_char(SYSDATE, 'YYYY-MM-DD') and proxy_dt is null) b,\n"+
					" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where paid_end_dt < to_char(SYSDATE, 'YYYY-MM-DD') and proxy_dt is null ) c\n"+
				" union all\n"+
				" select '비율' gubun, 'N' gubun_sub, a.*, b.*, c.*\n"+
				" from \n"+
					" ( select decode(a.tot_su1, 0,0, to_number(to_char((b.tot_su1/a.tot_su1)*100, 999.99))) tot_su1, decode(a.tot_amt1, 0,0, to_number(to_char((b.tot_amt1/a.tot_amt1)*100, 999.99))) tot_amt1 from \n"+
						" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where substr(paid_end_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') ) a,\n"+
						" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where substr(paid_end_dt,1,7) = to_char(SYSDATE, 'YYYY-MM') and proxy_dt is not null ) b\n"+
					" ) a,\n"+
					" ( select decode(a.tot_su2, 0,0, to_number(to_char((b.tot_su2/a.tot_su2)*100, 999.99))) tot_su2, decode(a.tot_amt2, 0,0, to_number(to_char((b.tot_amt2/a.tot_amt2)*100, 999.99))) tot_amt2 from \n"+
						" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where paid_end_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) a,\n"+
						" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where paid_end_dt = to_char(SYSDATE, 'YYYY-MM-DD') and proxy_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) b,\n"+
					" ( select decode(a.tot_su3, 0,0, to_number(to_char((b.tot_su3/a.tot_su3)*100, 999.99))) tot_su3, decode(a.tot_amt3, 0,0, to_number(to_char((b.tot_amt3/a.tot_amt3)*100, 999.99))) tot_amt3 from \n"+
						" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where paid_end_dt < to_char(SYSDATE, 'YYYY-MM-DD') and (proxy_dt is null or proxy_dt = to_char(SYSDATE, 'YYYY-MM-DD')) ) a,\n"+
						" ( select count(*) tot_su3, nvl(sum(paid_amt),0) tot_amt3 from ("+sub_query+") where paid_end_dt < to_char(SYSDATE, 'YYYY-MM-DD') and proxy_dt = to_char(SYSDATE, 'YYYY-MM-DD') ) b\n"+
					" ) c";

		try {
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next())
			{
				IncomingBean fee = new IncomingBean();
				fee.setGubun(rs.getString(1));
				fee.setGubun_sub(rs.getString(2));
				fee.setTot_su1(rs.getInt(3));
				fee.setTot_amt1(rs.getInt(4));
				fee.setTot_su2(rs.getInt(5));
				fee.setTot_amt2(rs.getInt(6));
				fee.setTot_su3(rs.getInt(7));
				fee.setTot_amt3(rs.getInt(8));
				vt.add(fee);
			}
			rs.close();
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineStat]"+e);
			e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}	

	//과태료 리스트 조회(지출현황) - 팝업 엑셀 리스트
	public Vector getFineExpListExcel(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select /*+  no_merge(b) */ \n"+
				" a.paid_no, cr.car_no, b.firm_nm, c.o_addr, replace(b.rent_start_dt,'-','') rent_start_dt, replace(b.rent_end_dt,'-','') rent_end_dt,\n"+
				" nvl2(TEXT_DECRYPT(c.ssn, 'pw' ) ,substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,1,6)||'-'||substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,7,7),'') ssn,\n"+
				" nvl2(c.enp_no,substr(c.enp_no,1,3)||'-'||substr(c.enp_no,4,2)||'-'||substr(c.enp_no,6,5),'') enp_no,\n"+
				" nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt\n"+
				" from fine a, cont_n_view b, client c, car_reg cr \n"+
				" where\n"+
				" a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id = cr.car_mng_id(+) and b.client_id=c.client_id and a.paid_amt > 0";

		/*상세조회&&세부조회*/

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and substr(a.paid_end_dt,1,6) = to_char(SYSDATE, 'YYYYMM')";
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr(a.paid_end_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is not null";
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and substr(a.paid_end_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is null";
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and a.paid_end_dt = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and a.vio_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.vio_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and a.vio_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.coll_dt is not null";
		//검색-미수금
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.coll_dt is null";
		}

		if(gubun4.equals("2"))			query += " and a.fault_st='1'";
		else if(gubun4.equals("3"))		query += " and a.fault_st='2'";
		
		//if(!br_id.equals("S1") && !br_id.equals(""))		query += " and b.brch_id='"+br_id+"'";

		/*검색조건*/
			
		if(s_kd.equals("2"))		query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and nvl(cr.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.pol_sta like '%"+t_wd+"%'\n";
		else						query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.vio_dt "+sort+", a.paid_end_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.vio_dt, a.paid_end_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.proxy_dt "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.proxy_dt, b.firm_nm, a.paid_end_dt";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm, a.paid_end_dt";
	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineExpListExcel]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineExpListExcel]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}

	//과태료 리스트 조회(지출현황) - 팝업 엑셀 리스트2 (선택리스트)
	public Hashtable getFineExpListExcel(String ch_m_id, String ch_l_cd, String ch_c_id, String ch_seq_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.DEM_DT, a.E_DEM_DT, c.CON_AGNT_EMAIL, \n"+
				"        a.file_name, a.paid_no, \n"+
				"        cr.car_no,  b.firm_nm,  b.client_id, '' scan_file, \n"+

				"        replace(decode(h.rent_suc_dt,'',decode(b.car_st,'2',DECODE(b.rent_start_dt,'--',b.reg_dt,b.rent_start_dt),decode(a.car_mng_id,j.car_mng_id,j.car_rent_st,b.rent_start_dt)),decode(h.suc_rent_st,b.rent_st,h.rent_suc_dt,b.rent_start_dt)),'-','') rent_start_dt, \n"+
			    "        decode(cr.prepare,'9',to_char(sysdate+30,'YYYYMMDD'),DECODE(nvl(f.cls_st,f2.cls_st),'8',NVL(g.migr_dt,to_char(sysdate,'YYYYMMDD')),'6',NVL(g.migr_dt,to_char(sysdate,'YYYYMMDD')),replace(NVL(i.reco_dt,NVL(nvl(f.cls_dt,f2.cls_dt),e2.rent_end_dt)),'-',''))) rent_end_dt, \n"+

				"        c.o_addr, decode(cr.prepare, '2','매각', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해', '9', '미회수', '예비') prepare, \n"+
				"        nvl2(TEXT_DECRYPT(c.ssn, 'pw' ) ,substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,1,6)||'-'||substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,7,7),'') ssn, \n"+
				"        nvl2(c.enp_no,substr(c.enp_no,1,3)||'-'||substr(c.enp_no,4,2)||'-'||substr(c.enp_no,6,5),'') enp_no, \n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'.'||substr(a.vio_dt,5,2)||'.'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt, \n"+
				"        a.rent_s_cd, a.rent_st, \n"+
				"        decode(a.rent_s_cd,'',c.client_st,e.client_st) client_st, \n"+
				"        decode(a.rent_s_cd,'',c.firm_nm,e.firm_nm) firm_nm2, \n"+
				"        decode(a.rent_s_cd,'',c.client_id,e.client_id) client_id2, \n"+
				"        decode(a.rent_s_cd,'',TEXT_DECRYPT(c.ssn, 'pw' ) ,TEXT_DECRYPT(e.ssn, 'pw' ) ) ssn2, \n"+
				"        decode(a.rent_s_cd,'',c.enp_no,e.enp_no) enp_no2, \n"+
				"        decode(a.rent_s_cd,'',replace(b.rent_start_dt,'-',''),substr(d.deli_dt,1,8)) rent_start_dt2, \n"+
				"        decode(a.rent_s_cd,'',replace(b.rent_end_dt,'-',''),substr(nvl(d.ret_dt,d.ret_plan_dt),1,8)) rent_end_dt2 \n"+
				" from   fine a, cont_n_view b, car_reg cr, client c, rent_cont d, client e, cls_cont f, cls_etc f2, sui g, taecha j,  \n"+
				"        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt \n"+
				"         from   ( "+
				"                  SELECT DECODE(rent_st,'1','신규','연장') AS fee_st, rent_mng_id, rent_l_cd, rent_st, rent_start_dt, rent_end_dt, rent_dt "+
				"                  FROM   FEE \n"+
				"                  where  rent_mng_id='"+ch_m_id+"' and rent_l_cd='"+ch_l_cd+"' "+
				"                  UNION ALL \n"+
				"                  SELECT '임의' fee_st, rent_mng_id, rent_l_cd, rent_st, use_s_dt as rent_start_dt, use_e_dt as rent_end_dt, '' AS rent_dt "+
				"                  FROM   scd_fee "+
				"                  where  rent_mng_id='"+ch_m_id+"' and rent_l_cd='"+ch_l_cd+"' and tm_st2='3' AND tm_st1='0' "+
				"                ) \n"+
				"         group by rent_mng_id, rent_l_cd \n"+
				"        ) e2, \n"+
				"	     car_reco i, cont_etc h \n"+
				" where \n"+
				"        a.rent_mng_id = '"+ch_m_id+"'    \n"+
				"        and a.rent_l_cd = '"+ch_l_cd+"'  \n"+
				"        and a.car_mng_id = '"+ch_c_id+"' \n"+
				"        and a.seq_no = '"+ch_seq_no+"'   \n"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.car_mng_id = cr.car_mng_id(+) and b.client_id=c.client_id \n"+
				"        and a.rent_s_cd=d.rent_s_cd(+) and d.cust_id=e.client_id(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=f2.rent_mng_id(+) and a.rent_l_cd=f2.rent_l_cd(+) \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
			    "        and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+) and nvl(j.no,'0')='0' \n"+
				"        AND a.rent_mng_id=e2.rent_mng_id AND a.rent_l_cd=e2.rent_l_cd \n"+
				"        AND a.rent_mng_id=i.rent_mng_id(+) AND a.rent_l_cd=i.rent_l_cd(+) \n"+
				"        AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd \n"+
				" ";


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
			System.out.println("[AddForfeitDatabase:getFineExpListExcel]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineExpListExcel]\n"+query);
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


	public Hashtable getFineExpListExcel(String ch_m_id, String ch_l_cd, String ch_c_id, String ch_seq_no, String ch_rent_st) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.DEM_DT, a.E_DEM_DT, c.CON_AGNT_EMAIL, \n"+
				"        a.file_name, a.paid_no, \n"+
				"        cr.car_no,  b.firm_nm,  b.client_id, '' scan_file, \n"+
				"        replace(decode(h.rent_suc_dt,'',decode(b.car_st,'2',DECODE(b.rent_start_dt,'--',b.reg_dt,b.rent_start_dt),decode(a.car_mng_id,j.car_mng_id,j.car_rent_st,k.rent_start_dt)),decode(h.suc_rent_st,k.rent_st,h.rent_suc_dt,k.rent_start_dt)),'-','') rent_start_dt, \n"+
			    "        decode(cr.prepare,'9',to_char(sysdate+30,'YYYYMMDD'),DECODE(nvl(f.cls_st,f2.cls_st),'8',NVL(g.migr_dt,to_char(sysdate,'YYYYMMDD')),'6',NVL(g.migr_dt,to_char(sysdate,'YYYYMMDD')),replace(NVL(i.reco_dt,NVL(nvl(f.cls_dt,f2.cls_dt),CASE WHEN a.vio_dt>k.rent_end_dt THEN e2.rent_end_dt ELSE k.rent_end_dt end)),'-',''))) rent_end_dt, \n"+
				"        c.o_addr, decode(cr.prepare, '2','매각', '3','보관', '4','말소', '5','도난', '6','해지', '8','수해', '9', '미회수', '예비') prepare, \n"+
				"        nvl2(TEXT_DECRYPT(c.ssn, 'pw' ) ,substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,1,6)||'-'||substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,7,7),'') ssn, \n"+
				"        nvl2(c.enp_no,substr(c.enp_no,1,3)||'-'||substr(c.enp_no,4,2)||'-'||substr(c.enp_no,6,5),'') enp_no, \n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'.'||substr(a.vio_dt,5,2)||'.'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt, \n"+
				"        a.rent_s_cd, a.rent_st, \n"+
				"        decode(a.rent_s_cd,'',c.client_st,e.client_st) client_st, \n"+
				"        decode(a.rent_s_cd,'',c.firm_nm,e.firm_nm) firm_nm2, \n"+
				"        decode(a.rent_s_cd,'',c.client_id,e.client_id) client_id2, \n"+
				"        decode(a.rent_s_cd,'',TEXT_DECRYPT(c.ssn, 'pw' ) ,TEXT_DECRYPT(e.ssn, 'pw' ) ) ssn2, \n"+
				"        decode(a.rent_s_cd,'',c.enp_no,e.enp_no) enp_no2, \n"+
				"        decode(a.rent_s_cd,'',replace(b.rent_start_dt,'-',''),substr(d.deli_dt,1,10)) rent_start_dt2, \n"+
				"        decode(a.rent_s_cd,'',replace(b.rent_end_dt,'-',''),substr(nvl(d.ret_dt,d.ret_plan_dt),1,10)) rent_end_dt2, \n"+
				// VVV운전면허번호추가(20180830)
			//	"		 DECODE(d.cust_id,'',DECODE(l1.lic_no,'',DECODE(l1.mgr_lic_no,'','-',l1.mgr_lic_no),l1.lic_no),DECODE(l2.lic_no,'',DECODE(l2.mgr_lic_no,'',DECODE(l1.mgr_lic_no,'','-',l1.mgr_lic_no),l2.mgr_lic_no),l2.lic_no))AS lic_no \n"+
				//	VV대표자의 운전면허번호가 없고  차량이용자의 운전면허번호만 있는경우 차량이용자(운전면허번호 이름) 꼴로 표시되게..(20190718)
				"		 DECODE(d.cust_id,'',DECODE(l1.lic_no,'',DECODE(l1.mgr_lic_no,'','-',l1.mgr_lic_no||'<br>차량이용자('||l1.mgr_lic_emp||')'),l1.lic_no),DECODE(l2.lic_no,'',DECODE(l2.mgr_lic_no,'',DECODE(l1.mgr_lic_no,'','-',l1.mgr_lic_no||'<br>차량이용자('||l1.mgr_lic_emp||')'),l2.mgr_lic_no||'<br>차량이용자('||l2.mgr_lic_emp||')'),l2.lic_no))AS lic_no \n"+
				" from   fine a, cont_n_view b, car_reg cr, client c, rent_cont d, client e, cls_cont f, cls_etc f2, sui g, taecha j, \n"+
				"        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt \n"+
				"         from   ( "+
				"                  SELECT DECODE(rent_st,'1','신규','연장') AS fee_st, rent_mng_id, rent_l_cd, rent_st, rent_start_dt, rent_end_dt, rent_dt "+
				"                  FROM   FEE \n"+
				"                  where  rent_mng_id='"+ch_m_id+"' and rent_l_cd='"+ch_l_cd+"' "+
				"                  UNION ALL \n"+
				"                  SELECT '임의' fee_st, rent_mng_id, rent_l_cd, rent_st, use_s_dt as rent_start_dt, use_e_dt as rent_end_dt, '' AS rent_dt "+
				"                  FROM   scd_fee "+
				"                  where  rent_mng_id='"+ch_m_id+"' and rent_l_cd='"+ch_l_cd+"' and tm_st2='3' AND tm_st1='0' "+
				"                ) \n"+
				"         group by rent_mng_id, rent_l_cd \n"+
				"        ) e2, \n"+
				"	     car_reco i, cont_etc h, fee k, \n"+
				// VVV운전면허번호추가(20180830)
				"		 cont l1, cont l2, client ee \n"+
//				"		 ( SELECT rent_l_cd, rent_mng_id, lic_no FROM car_mgr WHERE mgr_id = '0') m1, \n"+
//				"		 ( SELECT rent_l_cd, rent_mng_id, lic_no FROM car_mgr WHERE mgr_id = '0') m2 \n"+
				" where \n"+
				"        a.rent_mng_id = '"+ch_m_id+"'    \n"+
				"        and a.rent_l_cd = '"+ch_l_cd+"'  \n"+
				"        and a.car_mng_id = '"+ch_c_id+"' \n"+
				"        and a.seq_no = '"+ch_seq_no+"'   \n"+
				"        and decode(b.car_st,'4','1',nvl(a.rent_st,'"+ch_rent_st+"')) = '"+ch_rent_st+"'   \n"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.car_mng_id = cr.car_mng_id(+) and b.client_id=c.client_id \n"+
				"        and a.rent_s_cd=d.rent_s_cd(+) and d.cust_id=e.client_id(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=f2.rent_mng_id(+) and a.rent_l_cd=f2.rent_l_cd(+) \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
			    "        and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+) and nvl(j.no,'0')='0' \n"+
				"        AND a.rent_mng_id=e2.rent_mng_id(+) AND a.rent_l_cd=e2.rent_l_cd(+) \n"+
				"        AND a.rent_mng_id=i.rent_mng_id(+) AND a.rent_l_cd=i.rent_l_cd(+) \n"+
				"        AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd \n"+
				"        and a.rent_mng_id=k.rent_mng_id and a.rent_l_cd=k.rent_l_cd and decode(b.car_st,'4','1',nvl(a.rent_st,'"+ch_rent_st+"'))=k.rent_st \n"+
				// VVV운전면허번호추가(20180830)
				"		 and a.rent_mng_id=l1.rent_mng_id and a.rent_l_cd=l1.rent_l_cd \n"+
//				"		 AND l1.rent_mng_id = m1.rent_mng_id(+) AND l1.rent_l_cd = m1.rent_l_cd(+) \n"+
//				"		 AND l2.rent_mng_id = m2.rent_mng_id(+) AND l2.rent_l_cd = m2.rent_l_cd(+) \n"+
				"		 AND d.sub_l_cd = l2.rent_l_cd(+) AND l2.client_id = ee.client_id(+) \n"+
				" ";


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
			System.out.println("[AddForfeitDatabase:getFineExpListExcel]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineExpListExcel]\n"+query);
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


public Hashtable getFineExpListExcel_old(String ch_m_id, String ch_l_cd, String ch_c_id, String ch_seq_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select /*+  no_merge(b) */ a.DEM_DT, a.E_DEM_DT, c.CON_AGNT_EMAIL, \n"+
				" a.file_name, a.paid_no, "+
				" cr.car_no,  b.firm_nm,  b.client_id, '' scan_file, "+
				" replace(b.rent_start_dt,'-','') rent_start_dt, replace(b.rent_end_dt,'-','') rent_end_dt,\n"+
				" c.o_addr, "+
				" nvl2(TEXT_DECRYPT(c.ssn, 'pw' ) ,substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,1,6)||'-'||substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,7,7),'') ssn,\n"+
				" nvl2(c.enp_no,substr(c.enp_no,1,3)||'-'||substr(c.enp_no,4,2)||'-'||substr(c.enp_no,6,5),'') enp_no,\n"+
				" nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'.'||substr(a.vio_dt,5,2)||'.'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				" a.rent_s_cd, "+
				" decode(a.rent_s_cd,'',c.client_st,e.client_st) client_st, "+
				" decode(a.rent_s_cd,'',c.firm_nm,e.firm_nm) firm_nm2, "+
				" decode(a.rent_s_cd,'',c.client_id,e.client_id) client_id2, "+
				" decode(a.rent_s_cd,'',c.ssn,e.ssn) ssn2, "+
				" decode(a.rent_s_cd,'',c.enp_no,e.enp_no) enp_no2,  \n"+
				" decode(a.rent_s_cd,'',replace(b.rent_start_dt,'-',''),substr(d.deli_dt,1,10)) rent_start_dt2,  \n"+
				" decode(a.rent_s_cd,'',replace(b.rent_end_dt,'-',''),substr(nvl(d.ret_dt,d.ret_plan_dt),1,10)) rent_end_dt2  \n"+
				" from fine a, cont_n_view b, car_reg cr, client c, rent_cont d, client e\n"+
				" where\n"+
				" a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id = cr.car_mng_id(+) and b.client_id=c.client_id"+// and a.paid_amt > 0
				" and a.rent_s_cd=d.rent_s_cd(+) and d.cust_id=e.client_id(+)"+
				" and a.rent_mng_id = '"+ch_m_id+"'"+
				" and a.rent_l_cd = '"+ch_l_cd+"'"+
				" and a.car_mng_id = '"+ch_c_id+"'"+
				" and a.seq_no = '"+ch_seq_no+"'";
	
//System.out.println(query);

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
			System.out.println("[AddForfeitDatabase:getFineExpListExcel]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineExpListExcel]\n"+query);
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


	//과태료 리스트 조회한것 이의신청 수정 - 팝업 엑셀 리스트2 (선택리스트)
	public boolean updateFineExpListExcel(String ch_m_id, String ch_l_cd, String ch_c_id, String ch_seq_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update fine set\n"+
				" note=note||'\n 테스트 "+AddUtil.getDate()+" 이의신청'"+
				" where\n"+
				" rent_mng_id = '"+ch_m_id+"'"+
				" and rent_l_cd = '"+ch_l_cd+"'"+
				" and car_mng_id = '"+ch_c_id+"'"+
				" and seq_no = '"+ch_seq_no+"'";
	
		try {
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(query);           
		    pstmt.executeUpdate();
		    pstmt.close();
		    con.commit();
	    }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:getFineExpListExcel]"+se);
				con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");    
	
		} finally {
			try{
				 con.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return flag;
		}
	}

    /**
     * 과태료/범칙금 조회리스트
     */
    public FineBean [] getForfeitAll(String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;

        String query = "";
		query = " select /*+  no_merge(b) */ "+
				"        a.car_mng_id, a.rent_mng_id, a.rent_l_cd, a.seq_no, decode(a.coll_dt, '','미수금','수금') gubun,"+
				"        a.vio_dt, a.vio_pla, decode(a.fault_st, '1','고객과실','2','업무상과실', '3','마스타과실') fault_nm, a.paid_amt, a.paid_amt2,"+
				"        decode(a.coll_dt, null,'', substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2)) as COLL_DT,"+
				"        decode(a.rec_plan_dt, null,'', substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2)) as REC_PLAN_DT,"+
				"        b.firm_nm, cr.car_no, b.mng_id, cr.car_nm, cn.car_name, a.obj_dt1, a.obj_dt2, a.obj_dt3, a.bill_doc_yn, a.bill_mon, a.fault_amt,"+ 
				"        a.vat_yn, a.tax_yn, a.f_dem_dt, a.e_dem_dt, a.busi_st, a.rent_s_cd, a.notice_dt, a.obj_end_dt, a.ext_dt, a.mng_id, "+
				"        a.file_name, a.file_type, a.incom_dt, a.incom_seq, a.file_name2, a.file_type2, a.reg_id, a.rent_st, a.re_reg_id, a.re_reg_dt, a.vio_st  \n"+
				" from   fine a, cont_n_view b, car_reg cr,  car_etc c, car_nm cn \n"+
				" where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n "+
				"	and a.car_mng_id = cr.car_mng_id  and c.car_id=cn.car_id(+)  and    c.car_seq=cn.car_seq(+)  "+
				"        and a.paid_amt > 0 and a.paid_st in ('1','3') and nvl(a.no_paid_yn,'N') <> 'Y' ";	
	
        Collection<FineBean> col = new ArrayList<FineBean>();
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            while(rs.next()){                
				col.add(makeFineBean(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[AddForfeitDatabase:getForfeitAll]"+se);
			throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (FineBean[])col.toArray(new FineBean[0]);
    }

	// 과태료 건별 스케줄 리스트 통계
	public IncomingBean getFineScdStat(String m_id, String l_cd, String c_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		IncomingBean ins_m = new IncomingBean();

		String sub_query = "";
		sub_query = " select decode(a.fault_st, '1', a.paid_amt, '2', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt)) paid_amt,"+
					" a.coll_dt, a.dly_amt from fine a"+
					" where a.paid_amt > 0 and a.proxy_dt is not null and nvl(a.no_paid_yn,'N') <> 'Y'"+//a.paid_st ='3'
					" and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and a.car_mng_id='"+c_id+"'"; // and a.accid_id='"+accid_id+"' and a.serv_id='"+serv_id+"'";

		String query = "";
		query = " select a.*, b.*, c.* from\n"+
					" ( select count(*) tot_su1, nvl(sum(paid_amt),0) tot_amt1 from ("+sub_query+") where coll_dt is null) a, \n"+
					" ( select count(*) tot_su2, nvl(sum(paid_amt),0) tot_amt2 from ("+sub_query+") where coll_dt is not null) b, \n"+
					" ( select count(*) tot_su3, nvl(sum(dly_amt),0) tot_amt3 from ("+sub_query+") where dly_amt > 0) c";
		
		try {
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
			{
				ins_m.setTot_su1(rs.getInt(1));
				ins_m.setTot_amt1(rs.getInt(2));
				ins_m.setTot_su2(rs.getInt(3));
				ins_m.setTot_amt2(rs.getInt(4));
				ins_m.setTot_su3(rs.getInt(5));
				ins_m.setTot_amt3(rs.getInt(6));
			}
			
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineScdStat]\n"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ins_m;
	}

	// 과태료 건별 스케줄 리스트 조회
	public Vector getFineScd(String m_id, String l_cd, String c_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select decode(a.coll_dt, '','미수금','수금') gubun,\n"+
					" a.seq_no, a.fault_st, nvl(a.vio_pla,'') vio_pla,\n"+
					" decode(a.fault_st, '1', a.paid_amt, '2', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt)) paid_amt,"+
					" a.dly_amt, a.dly_days,\n"+
					" nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2),'') vio_dt,\n"+
					" nvl2(a.rec_plan_dt,substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2),'') rec_plan_dt,\n"+
					" nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
					" nvl2(a.ext_dt,substr(a.ext_dt,1,4)||'-'||substr(a.ext_dt,5,2)||'-'||substr(a.ext_dt,7,2),'') ext_dt\n"+
					" from fine a\n"+
					" where\n"+
					" a.paid_st ='3' and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y'"+//a.paid_st ='3' and //a.proxy_dt is not null and 
					" and a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and a.car_mng_id='"+c_id+"'";// and a.accid_id='"+accid_id+"'";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
			while(rs.next())
			{				
	            FineBean bean = new FineBean();

				bean.setRent_mng_id(m_id); 
				bean.setRent_l_cd(l_cd); 
			    bean.setCar_mng_id(c_id); 					
				bean.setSeq_no(rs.getInt("seq_no")); 
				bean.setGubun(rs.getString("gubun")); 
				bean.setFault_st(rs.getString("fault_st"));					
				bean.setVio_pla(rs.getString("VIO_PLA"));				
				bean.setPaid_amt(rs.getInt("PAID_AMT"));
				bean.setDly_amt(rs.getInt("dly_amt")); 
				bean.setDly_days(rs.getString("dly_days")); 
				bean.setVio_dt(rs.getString("VIO_DT"));								
				bean.setColl_dt(rs.getString("COLL_DT"));				
				bean.setRec_plan_dt(rs.getString("REC_PLAN_DT"));	
				bean.setExt_dt(rs.getString("EXT_DT"));	
				
				vt.add(bean);	
			}
			rs.close();
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}

	/**
	 *	과태료 건별 스케줄 한회차 면책금 쿼리(한 라인)
	 */
	public FineBean getScdCase(String m_id, String l_cd, String c_id, String seq_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		FineBean bean = new FineBean();
		String query =  " select seq_no, fine_st, fault_st, paid_no, vio_dt, vio_pla, vio_cont, paid_st, pol_sta, fault_nm, fault_amt, paid_amt, coll_dt, rec_plan_dt"+
						" from fine"+
						" where RENT_MNG_ID=? and RENT_L_CD=? and CAR_MNG_ID=? and SEQ_NO=?";
		try {
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, c_id);
			pstmt.setString(4, seq_no);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setRent_mng_id(m_id); 
				bean.setRent_l_cd(l_cd); 
			    bean.setCar_mng_id(c_id); 					
			    bean.setSeq_no(rs.getInt("seq_no")); 					
				bean.setFine_st(rs.getString("fine_st"));					
				bean.setFault_st(rs.getString("fault_st"));					
				bean.setPaid_no(rs.getString("paid_no"));				
				bean.setVio_pla(rs.getString("VIO_PLA"));				
				bean.setVio_cont(rs.getString("vio_cont")); 
				bean.setVio_dt(rs.getString("VIO_DT"));								
				bean.setPaid_st(rs.getString("paid_st"));				
				bean.setPol_sta(rs.getString("pol_sta"));				
				bean.setFault_nm(rs.getString("fault_nm"));
				bean.setFault_amt(rs.getInt("fault_amt"));
				bean.setPaid_amt(rs.getInt("PAID_AMT"));
				bean.setColl_dt(rs.getString("COLL_DT"));	
				bean.setRec_plan_dt(rs.getString("REC_PLAN_DT"));										
			}
			rs.close();
            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getScdCase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}				
		return bean;
	}


	// 등록 -------------------------------------------------------------------------------------------------

	/**
     * 과태료 범칙금 등록
     */
    public int insertForfeit(FineBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String seqQuery = "";
        String car_mng_id = "";
        String rent_mng_id = "";
        String rent_l_cd = "";
        int seq_no = 0;
        int count = 0;
        car_mng_id = bean.getCar_mng_id().trim();
        rent_mng_id = bean.getRent_mng_id().trim();
        rent_l_cd = bean.getRent_l_cd().trim();
                
        seqQuery = "select nvl(max(SEQ_NO)+1,1) from fine where car_mng_id='" + car_mng_id +"' and rent_mng_id='" + rent_mng_id +"' and rent_l_cd='" + rent_l_cd +"'\n";

        query = " INSERT INTO FINE(SEQ_NO,CAR_MNG_ID,RENT_MNG_ID,RENT_L_CD,FINE_ST,CALL_NM,TEL,FAX,VIO_DT,VIO_PLA,"+
					" VIO_CONT,PAID_ST,REC_DT,PAID_END_DT,PAID_AMT,PROXY_DT,POL_STA,PAID_NO,FAULT_ST,FAULT_NM,DEM_DT,COLL_DT,"+
					" REC_PLAN_DT,NOTE,NO_PAID_YN,NO_PAID_CAU,REG_ID,REG_DT,UPDATE_ID,UPDATE_DT,OBJ_DT1,OBJ_DT2,OBJ_DT3,BILL_DOC_YN,"+
					" FAULT_AMT,BILL_MON,VAT_YN,TAX_YN,F_DEM_DT,E_DEM_DT,BUSI_ST,NOTICE_DT,OBJ_END_DT,RENT_S_CD, MNG_ID, REG_CODE, FINE_GB,PAID_AMT2, RENT_ST, vio_st )\n"+
				" values(?,?,?,?,?,?,?,?,replace(?,'-',''),?,?,?,replace(?,'-',''),replace(?,'-',''),replace(?,',',''),"+
				" replace(?,'-',''),?,?,?,?,replace(?,'-',''),replace(?,'-',''),replace(?,'-',''),?,?,?,?,to_char(sysdate,'YYYYMMDD'),?,to_char(sysdate,'YYYYMMDD'),replace(?,'-',''),replace(?,'-',''),replace(?,'-',''),?,"+
				" ?,?,?,?,replace(?,'-',''),replace(?,'-',''),?,replace(?,'-',''),replace(?,'-',''), ?, ?, ?, ?,?,?,?)\n";

       try{
            con.setAutoCommit(false);

            stmt = con.createStatement();
            rs = stmt.executeQuery(seqQuery);
            if(rs.next())
            	seq_no = rs.getInt(1);
            rs.close();
			stmt.close();
            pstmt = con.prepareStatement(query);

            pstmt.setInt(1,     seq_no						);
            pstmt.setString(2,  car_mng_id					);
            pstmt.setString(3,  rent_mng_id					);
            pstmt.setString(4,  rent_l_cd					);
            pstmt.setString(5,  bean.getFine_st().trim()	);
            pstmt.setString(6,  bean.getCall_nm().trim()	);
            pstmt.setString(7,  bean.getTel().trim()		);
            pstmt.setString(8,  bean.getFax().trim()		);
            pstmt.setString(9,  bean.getVio_dt().trim()		);
            pstmt.setString(10, bean.getVio_pla().trim()	);
            pstmt.setString(11, bean.getVio_cont().trim()	);
            pstmt.setString(12, bean.getPaid_st().trim()	);
            pstmt.setString(13, bean.getRec_dt().trim()		);
            pstmt.setString(14, bean.getPaid_end_dt().trim());
            pstmt.setInt(15,    bean.getPaid_amt()			);
            pstmt.setString(16, bean.getProxy_dt().trim()	);
            pstmt.setString(17, bean.getPol_sta().trim()	);
            pstmt.setString(18, bean.getPaid_no().trim()	);
            pstmt.setString(19, bean.getFault_st().trim()	);
            pstmt.setString(20, bean.getFault_nm().trim()	);
            pstmt.setString(21, bean.getDem_dt().trim()		);
            pstmt.setString(22, bean.getColl_dt().trim()	);
            pstmt.setString(23, bean.getRec_plan_dt().trim());
            pstmt.setString(24, bean.getNote().trim()		);
            pstmt.setString(25, bean.getNo_paid_yn().trim()	);
            pstmt.setString(26, bean.getNo_paid_cau().trim());
            pstmt.setString(27, bean.getUpdate_id().trim()	);
            pstmt.setString(28, bean.getUpdate_id().trim()	);
            pstmt.setString(29, bean.getObj_dt1().trim()	);
            pstmt.setString(30, bean.getObj_dt2().trim()	);
            pstmt.setString(31, bean.getObj_dt3().trim()	);
            pstmt.setString(32, bean.getBill_doc_yn().trim());
            pstmt.setInt(33,    bean.getFault_amt()			);
            pstmt.setString(34, bean.getBill_mon().trim()	);
            pstmt.setString(35, bean.getVat_yn().trim()		);
            pstmt.setString(36, bean.getTax_yn().trim()		);
            pstmt.setString(37, bean.getF_dem_dt().trim()	);
            pstmt.setString(38, bean.getE_dem_dt().trim()	);
            pstmt.setString(39, bean.getBusi_st().trim()	);
            pstmt.setString(40, bean.getNotice_dt().trim()	);
            pstmt.setString(41, bean.getObj_end_dt().trim()	);
            pstmt.setString(42, bean.getRent_s_cd().trim()	);
            pstmt.setString(43, bean.getMng_id().trim()		);
            pstmt.setString(44, bean.getReg_code().trim()	);
            pstmt.setString(45, bean.getFine_gb().trim()	);
            pstmt.setInt(46,    bean.getPaid_amt2()			);
			pstmt.setString(47, bean.getRent_st().trim()	);
            pstmt.setString(48, bean.getVio_st().trim()		);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddForfeitDatabase:insertForfeit]"+se);

				System.out.println("[seq_no						]"+seq_no						);
				System.out.println("[car_mng_id					]"+car_mng_id					);
				System.out.println("[rent_mng_id				]"+rent_mng_id					);
				System.out.println("[rent_l_cd					]"+rent_l_cd					);
				System.out.println("[bean.getFine_st().trim()	]"+bean.getFine_st().trim()	);
				System.out.println("[bean.getCall_nm().trim()	]"+bean.getCall_nm().trim()	);
				System.out.println("[bean.getTel().trim()		]"+bean.getTel().trim()		);
				System.out.println("[bean.getFax().trim()		]"+bean.getFax().trim()		);
				System.out.println("[bean.getVio_dt().trim()	]"+bean.getVio_dt().trim()		);
				System.out.println("[bean.getVio_pla().trim()	]"+bean.getVio_pla().trim()	);
				System.out.println("[bean.getVio_cont().trim()	]"+bean.getVio_cont().trim()	);
				System.out.println("[bean.getPaid_st().trim()	]"+bean.getPaid_st().trim()	);
				System.out.println("[bean.getRec_dt().trim()	]"+bean.getRec_dt().trim()		);
				System.out.println("[bean.getPaid_end_dt().trim()]"+bean.getPaid_end_dt().trim());
				System.out.println("[bean.getPaid_amt()			]"+bean.getPaid_amt()			);
				System.out.println("[bean.getProxy_dt().trim()	]"+bean.getProxy_dt().trim()	);
				System.out.println("[bean.getPol_sta().trim()	]"+bean.getPol_sta().trim()	);
				System.out.println("[bean.getPaid_no().trim()	]"+bean.getPaid_no().trim()	);
				System.out.println("[bean.getFault_st().trim()	]"+bean.getFault_st().trim()	);
				System.out.println("[bean.getFault_nm().trim()	]"+bean.getFault_nm().trim()	);
				System.out.println("[bean.getDem_dt().trim()	]"+bean.getDem_dt().trim()		);
				System.out.println("[bean.getColl_dt().trim()	]"+bean.getColl_dt().trim()	);
				System.out.println("[bean.getRec_plan_dt().trim()]"+bean.getRec_plan_dt().trim());
				System.out.println("[bean.getNote().trim()		]"+bean.getNote().trim()		);
				System.out.println("[bean.getNo_paid_yn().trim()]"+bean.getNo_paid_yn().trim()	);
				System.out.println("[bean.getNo_paid_cau().trim()]"+bean.getNo_paid_cau().trim());
				System.out.println("[bean.getUpdate_id().trim()	]"+bean.getUpdate_id().trim()	);
				System.out.println("[bean.getUpdate_id().trim()	]"+bean.getUpdate_id().trim()	);
				System.out.println("[bean.getObj_dt1().trim()	]"+bean.getObj_dt1().trim()	);
				System.out.println("[bean.getObj_dt2().trim()	]"+bean.getObj_dt2().trim()	);
				System.out.println("[bean.getObj_dt3().trim()	]"+bean.getObj_dt3().trim()	);
				System.out.println("[bean.getBill_doc_yn().trim()]"+bean.getBill_doc_yn().trim());
				System.out.println("[bean.getFault_amt()		]"+bean.getFault_amt()			);
				System.out.println("[bean.getBill_mon().trim()	]"+bean.getBill_mon().trim()	);
				System.out.println("[bean.getVat_yn().trim()	]"+bean.getVat_yn().trim()		);
				System.out.println("[bean.getTax_yn().trim()	]"+bean.getTax_yn().trim()		);
				System.out.println("[bean.getF_dem_dt().trim()	]"+bean.getF_dem_dt().trim()	);
				System.out.println("[bean.getE_dem_dt().trim()	]"+bean.getE_dem_dt().trim()	);
				System.out.println("[bean.getBusi_st().trim()	]"+bean.getBusi_st().trim()	);
				System.out.println("[bean.getNotice_dt().trim()	]"+bean.getNotice_dt().trim()	);
				System.out.println("[bean.getObj_end_dt().trim()]"+bean.getObj_end_dt().trim()	);
				System.out.println("[bean.getRent_s_cd().trim()	]"+bean.getRent_s_cd().trim()	);
				System.out.println("[bean.getMng_id().trim()	]"+bean.getMng_id().trim()		);
				System.out.println("[bean.getReg_code().trim()	]"+bean.getReg_code().trim()	);
				System.out.println("[bean.getFine_gb().trim()	]"+bean.getFine_gb().trim()	);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return seq_no;
    }
    
    public void insertFineWetaxTemp(Map<String, Object> param) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	if(con == null) throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
//        ResultSet rs = null;
        
        String gubun = (String) param.get("gubun");
        String car_no  = (String) param.get("car_no");
        String gov_nm  = (String) param.get("gov_nm");
        String paid_no = (String) param.get("paid_no");
        String vio_pla = (String) param.get("vio_pla");
        String vio_cont  = (String) param.get("vio_cont");
        int paid_amt = (int) param.get("paid_amt");
        String paid_end_dt = (String) param.get("paid_end_dt");
        String vio_dt = (String) param.get("vio_dt");
        String impose_dt = (String) param.get("impose_dt");
        
        
        String query = "";
        
        query = "insert into fine_temp2 (seq, car_no, gov_nm, paid_no, vio_dt, vio_pla, vio_cont, paid_amt, paid_end_dt, impose_dt, reg_dt)\r\n" + 
        		" values(FINE_SEQ_2.NEXTVAL, '"+car_no+"', '"+gov_nm+"', '"+paid_no+"', '"+vio_dt+"', '"+vio_pla+"', '"+vio_cont+"', '"+paid_amt+"', '"+paid_end_dt+"', '"+impose_dt+"', SYSDATE )";
        
        try{
            con.setAutoCommit(false);
            stmt = con.createStatement();
            pstmt = con.prepareStatement(query);
            
            pstmt.executeUpdate();
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
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
    }
    
    
    /**
     * 과태료 범칙금 등록(OCR)
     */
    public int insertOcrForfeit(FineBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        String seqQuery = "";
        String car_mng_id = "";
        String rent_mng_id = "";
        String rent_l_cd = "";
        int seq_no = 0;
        int count = 0;
        car_mng_id = bean.getCar_mng_id().trim();
        rent_mng_id = bean.getRent_mng_id().trim();
        rent_l_cd = bean.getRent_l_cd().trim();
                
        seqQuery = "select nvl(max(SEQ_NO)+1,1) from fine where car_mng_id='" + car_mng_id +"' and rent_mng_id='" + rent_mng_id +"' and rent_l_cd='" + rent_l_cd +"'\n";

        query = " INSERT INTO FINE(SEQ_NO,CAR_MNG_ID,RENT_MNG_ID,RENT_L_CD,FINE_ST,CALL_NM,TEL,FAX,VIO_DT,VIO_PLA,"+
					" VIO_CONT,PAID_ST,REC_DT,PAID_END_DT,PAID_AMT,PROXY_DT,POL_STA,PAID_NO,FAULT_ST,FAULT_NM,DEM_DT,COLL_DT,"+
					" REC_PLAN_DT,NOTE,NO_PAID_YN,NO_PAID_CAU,REG_ID,REG_DT,UPDATE_ID,UPDATE_DT,OBJ_DT1,OBJ_DT2,OBJ_DT3,BILL_DOC_YN,"+
					" FAULT_AMT,BILL_MON,VAT_YN,TAX_YN,F_DEM_DT,E_DEM_DT,BUSI_ST,NOTICE_DT,OBJ_END_DT,RENT_S_CD, MNG_ID, REG_CODE, FINE_GB,PAID_AMT2, RENT_ST, vio_st, FILE_NAME, email_yn )\n"+
				" values(?,?,?,?,?,?,?,?,regexp_replace(?, '[^0-9]'),?,?,?,replace(?,'-',''),regexp_replace(?, '[^0-9]'),replace(?,',',''),"+
				" replace(?,'-',''),?, Regexp_replace(?, '[^0-9]'),?,?,replace(?,'-',''),replace(?,'-',''),replace(?,'-',''),?,?,?,?,to_char(sysdate,'YYYYMMDD'),?,to_char(sysdate,'YYYYMMDD'),replace(?,'-',''),replace(?,'-',''),replace(?,'-',''),?,"+
				" ?,?,?,?,replace(?,'-',''),replace(?,'-',''),?,replace(?,'-',''),regexp_replace(?, '[^0-9]'), ?, ?, ?, ?,?,?,?,?,?)\n";

       try{
            con.setAutoCommit(false);

            stmt = con.createStatement();
            rs = stmt.executeQuery(seqQuery);
            if(rs.next())
            	seq_no = rs.getInt(1);
            rs.close();
			stmt.close();

            pstmt = con.prepareStatement(query);

            pstmt.setInt(1,     seq_no						);
            pstmt.setString(2,  car_mng_id					);
            pstmt.setString(3,  rent_mng_id					);
            pstmt.setString(4,  rent_l_cd					);
            pstmt.setString(5,  bean.getFine_st().trim()	);
            pstmt.setString(6,  bean.getCall_nm().trim()	);
            pstmt.setString(7,  bean.getTel().trim()		);
            pstmt.setString(8,  bean.getFax().trim()		);
            pstmt.setString(9,  bean.getVio_dt().trim()		);
            pstmt.setString(10, bean.getVio_pla().trim()	);
            pstmt.setString(11, bean.getVio_cont().trim()	);
            pstmt.setString(12, bean.getPaid_st().trim()	);
            pstmt.setString(13, bean.getRec_dt().trim()		);
            pstmt.setString(14, bean.getPaid_end_dt().trim());
            pstmt.setInt(15,    bean.getPaid_amt()			);
            pstmt.setString(16, bean.getProxy_dt().trim()	);
            pstmt.setString(17, bean.getPol_sta().trim()	);
            pstmt.setString(18, bean.getVio_dt().trim()		);
            pstmt.setString(19, bean.getFault_st().trim()	);
            pstmt.setString(20, bean.getFault_nm().trim()	);
            pstmt.setString(21, bean.getDem_dt().trim()		);
            pstmt.setString(22, bean.getColl_dt().trim()	);
            pstmt.setString(23, bean.getRec_plan_dt().trim());
            pstmt.setString(24, bean.getNote().trim()		);
            pstmt.setString(25, bean.getNo_paid_yn().trim()	);
            pstmt.setString(26, bean.getNo_paid_cau().trim());
            pstmt.setString(27, bean.getUpdate_id().trim()	);
            pstmt.setString(28, bean.getUpdate_id().trim()	);
            pstmt.setString(29, bean.getObj_dt1().trim()	);
            pstmt.setString(30, bean.getObj_dt2().trim()	);
            pstmt.setString(31, bean.getObj_dt3().trim()	);
            pstmt.setString(32, bean.getBill_doc_yn().trim());
            pstmt.setInt(33,    bean.getFault_amt()			);
            pstmt.setString(34, bean.getBill_mon().trim()	);
            pstmt.setString(35, bean.getVat_yn().trim()		);
            pstmt.setString(36, bean.getTax_yn().trim()		);
            pstmt.setString(37, bean.getF_dem_dt().trim()	);
            pstmt.setString(38, bean.getE_dem_dt().trim()	);
            pstmt.setString(39, bean.getBusi_st().trim()	);
            pstmt.setString(40, bean.getNotice_dt().trim()	);
            pstmt.setString(41, bean.getObj_end_dt().trim()	);
            pstmt.setString(42, bean.getRent_s_cd().trim()	);
            pstmt.setString(43, bean.getMng_id().trim()		);
            pstmt.setString(44, bean.getReg_code().trim()	);
            pstmt.setString(45, bean.getFine_gb().trim()	);
            pstmt.setInt(46,    bean.getPaid_amt2()			);
			pstmt.setString(47, bean.getRent_st().trim()	);
            pstmt.setString(48, bean.getVio_st().trim()		);
            pstmt.setString(49, bean.getFile_name().trim()	);
            pstmt.setString(50, bean.getEmail_yn().trim()	);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddForfeitDatabase:insertForfeit]"+se);

				System.out.println("[seq_no						]"+seq_no						);
				System.out.println("[car_mng_id					]"+car_mng_id					);
				System.out.println("[rent_mng_id				]"+rent_mng_id					);
				System.out.println("[rent_l_cd					]"+rent_l_cd					);
				System.out.println("[bean.getFine_st().trim()	]"+bean.getFine_st().trim()	);
				System.out.println("[bean.getCall_nm().trim()	]"+bean.getCall_nm().trim()	);
				System.out.println("[bean.getTel().trim()		]"+bean.getTel().trim()		);
				System.out.println("[bean.getFax().trim()		]"+bean.getFax().trim()		);
				System.out.println("[bean.getVio_dt().trim()	]"+bean.getVio_dt().trim()		);
				System.out.println("[bean.getVio_pla().trim()	]"+bean.getVio_pla().trim()	);
				System.out.println("[bean.getVio_cont().trim()	]"+bean.getVio_cont().trim()	);
				System.out.println("[bean.getPaid_st().trim()	]"+bean.getPaid_st().trim()	);
				System.out.println("[bean.getRec_dt().trim()	]"+bean.getRec_dt().trim()		);
				System.out.println("[bean.getPaid_end_dt().trim()]"+bean.getPaid_end_dt().trim());
				System.out.println("[bean.getPaid_amt()			]"+bean.getPaid_amt()			);
				System.out.println("[bean.getProxy_dt().trim()	]"+bean.getProxy_dt().trim()	);
				System.out.println("[bean.getPol_sta().trim()	]"+bean.getPol_sta().trim()	);
				System.out.println("[bean.getPaid_no().trim()	]"+bean.getPaid_no().trim()	);
				System.out.println("[bean.getFault_st().trim()	]"+bean.getFault_st().trim()	);
				System.out.println("[bean.getFault_nm().trim()	]"+bean.getFault_nm().trim()	);
				System.out.println("[bean.getDem_dt().trim()	]"+bean.getDem_dt().trim()		);
				System.out.println("[bean.getColl_dt().trim()	]"+bean.getColl_dt().trim()	);
				System.out.println("[bean.getRec_plan_dt().trim()]"+bean.getRec_plan_dt().trim());
				System.out.println("[bean.getNote().trim()		]"+bean.getNote().trim()		);
				System.out.println("[bean.getNo_paid_yn().trim()]"+bean.getNo_paid_yn().trim()	);
				System.out.println("[bean.getNo_paid_cau().trim()]"+bean.getNo_paid_cau().trim());
				System.out.println("[bean.getUpdate_id().trim()	]"+bean.getUpdate_id().trim()	);
				System.out.println("[bean.getUpdate_id().trim()	]"+bean.getUpdate_id().trim()	);
				System.out.println("[bean.getObj_dt1().trim()	]"+bean.getObj_dt1().trim()	);
				System.out.println("[bean.getObj_dt2().trim()	]"+bean.getObj_dt2().trim()	);
				System.out.println("[bean.getObj_dt3().trim()	]"+bean.getObj_dt3().trim()	);
				System.out.println("[bean.getBill_doc_yn().trim()]"+bean.getBill_doc_yn().trim());
				System.out.println("[bean.getFault_amt()		]"+bean.getFault_amt()			);
				System.out.println("[bean.getBill_mon().trim()	]"+bean.getBill_mon().trim()	);
				System.out.println("[bean.getVat_yn().trim()	]"+bean.getVat_yn().trim()		);
				System.out.println("[bean.getTax_yn().trim()	]"+bean.getTax_yn().trim()		);
				System.out.println("[bean.getF_dem_dt().trim()	]"+bean.getF_dem_dt().trim()	);
				System.out.println("[bean.getE_dem_dt().trim()	]"+bean.getE_dem_dt().trim()	);
				System.out.println("[bean.getBusi_st().trim()	]"+bean.getBusi_st().trim()	);
				System.out.println("[bean.getNotice_dt().trim()	]"+bean.getNotice_dt().trim()	);
				System.out.println("[bean.getObj_end_dt().trim()]"+bean.getObj_end_dt().trim()	);
				System.out.println("[bean.getRent_s_cd().trim()	]"+bean.getRent_s_cd().trim()	);
				System.out.println("[bean.getMng_id().trim()	]"+bean.getMng_id().trim()		);
				System.out.println("[bean.getReg_code().trim()	]"+bean.getReg_code().trim()	);
				System.out.println("[bean.getFine_gb().trim()	]"+bean.getFine_gb().trim()	);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return seq_no;
    }
    
    /**
     * FINE_TEMP REG_YN 업데이트
     */
    public int updateFineTempRegYn(String temp_paid_no, String temp_vio_dt, String seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        int seq_no = 0;
        int count = 0;
        
        String where = "WHERE SEQ ='"+seq+"'";
		
		if(temp_paid_no == null || temp_paid_no.isEmpty()) {
		} else {
			where += "AND PAID_NO = '"+temp_paid_no+"'";
		}
		
		if(temp_vio_dt == null || temp_vio_dt.isEmpty()) {
		} else {
			where += "AND VIO_DT='"+temp_vio_dt+"'";
		}
         

        query = "update fine_temp \r\n" + 
        		"	    set reg_yn = 'Y', del_yn = 'Y'\r\n" + 
        		"	    where seq = "+seq+"";

       try{
            con.setAutoCommit(false);

            stmt = con.createStatement();
			stmt.close();
			seq_no = 1;
            pstmt = con.prepareStatement(query);

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddForfeitDatabase:insertForfeit]"+se);
				System.out.println("[bean.getPaid_no().trim()	]"+temp_paid_no	);
				System.out.println("[bean.getVio_dt().trim()	]"+temp_vio_dt	);
				System.out.println("[bean.seq().trim()	]"+seq	);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return seq_no;
    }
    
    /**
     * FINE_TEMP DEL_YN2 업데이트
     */
    public int updateFineTempRegYn2(String temp_paid_no, String temp_vio_dt, String seq) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	PreparedStatement pstmt = null;
    	Statement stmt = null;
    	ResultSet rs = null;
    	String query = "";
    	int seq_no = 0;
    	int count = 0;
    	
    	String where = "WHERE SEQ ='"+seq+"'";
    	
    	if(temp_paid_no == null || temp_paid_no.isEmpty()) {
    	} else {
    		where += "AND PAID_NO = '"+temp_paid_no+"'";
    	}
    	
    	if(temp_vio_dt == null || temp_vio_dt.isEmpty()) {
    	} else {
    		where += "AND VIO_DT='"+temp_vio_dt+"'";
    	}
    	
    	
    	query = "update fine_temp \r\n" + 
    			"	    set del_yn2 = 'Y'\r\n" + 
    			"	    where seq = "+seq+"";
    	
    	try{
    		con.setAutoCommit(false);
    		
    		stmt = con.createStatement();
    		stmt.close();
    		seq_no = 1;
    		pstmt = con.prepareStatement(query);
    		
    		count = pstmt.executeUpdate();
    		
    		pstmt.close();
    		con.commit();
    		
    	}catch(Exception se){
    		try{
    			System.out.println("[AddForfeitDatabase:insertForfeit]"+se);
    			System.out.println("[bean.getPaid_no().trim()	]"+temp_paid_no	);
    			System.out.println("[bean.getVio_dt().trim()	]"+temp_vio_dt	);
    			System.out.println("[bean.seq().trim()	]"+seq	);
    			
    			con.rollback();
    		}catch(SQLException _ignored){}
    		throw new DatabaseException("exception");
    	}finally{
    		try{
    			con.setAutoCommit(true);
    			if(rs != null) rs.close();
    			if(stmt != null) stmt.close();
    			if(pstmt != null) pstmt.close();
    		}catch(SQLException _ignored){}
    		connMgr.freeConnection(DATA_SOURCE, con);
    		con = null;
    	}
    	
    	return seq_no;
    }
    
    /**
     * FINE_TEMP REG_YN 업데이트
     */
    public void updateFineTemp2RegYn(String paid_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        Statement stmt = null;
        ResultSet rs = null;
        String query = "";
        int seq_no = 0;
        int count = 0;

        query = "update fine_temp2 \r\n" + 
        		"	    set reg_yn = 'Y'\r\n" +
        		" where paid_no =  '"+paid_no+"' "; 

       try{
            con.setAutoCommit(false);

            stmt = con.createStatement();
			stmt.close();
			seq_no = 1;
            pstmt = con.prepareStatement(query);

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddForfeitDatabase:insertForfeit]"+se);
				System.out.println("paid_no"+paid_no	);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

    }
    
	// 수정 -------------------------------------------------------------------------------------------------

	/**
	 *	과태료 연체료 계산 : forfeit_c.jsp
	 */
	public boolean calDelay(String m_id, String l_cd, String c_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		//연체일 있는 경우(입금:입금일>입금예정일, 미입금:현재날자>입금예정일)
		String query1 = "";
		query1= " UPDATE FINE SET"+
				" dly_days=TRUNC(NVL(TO_DATE(coll_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(rec_plan_dt, 'YYYYMMDD')),"+
				" dly_amt=(TRUNC(((paid_amt)*0.18*TRUNC(TO_DATE(rec_plan_dt, 'YYYYMMDD')- NVL(TO_DATE(coll_dt, 'YYYYMMDD'), SYSDATE)))/365) * -1)"+
				" WHERE car_mng_id=? "+//and accid_id=?//rent_mng_id=? and rent_l_cd=? and +// and serv_id=?"+
				" and SIGN(TRUNC(NVL(TO_DATE(coll_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(rec_plan_dt, 'YYYYMMDD'))) > 0";
	
		//연체일 없는 경우(입금:입금일=입금예정일, 입금일<입금예정일(선수), 미입금:현재날짜<입금예정일)
		String query2 = "";
		query2= " UPDATE FINE set"+
				" dly_days = '0',"+
				" dly_amt = 0"+
				" WHERE car_mng_id=? "+//and accid_id=?//rent_mng_id=? and rent_l_cd=? and +// and serv_id=?"+
				" and SIGN(TRUNC(NVL(TO_DATE(coll_dt, 'YYYYMMDD'), SYSDATE) - TO_DATE(rec_plan_dt, 'YYYYMMDD'))) < 1";
		try 
		{
			con.setAutoCommit(false);	
			pstmt1 = con.prepareStatement(query1);
			pstmt1.setString(1, c_id);
		    pstmt1.executeUpdate();
			pstmt1.close();

		    pstmt2 = con.prepareStatement(query2);
			pstmt2.setString(1, c_id);
		    pstmt2.executeUpdate();		    		    
		    pstmt2.close();
		    con.commit();
		} catch (Exception e) {
            try{
				System.out.println("[AddForfeitDatabase:calDelay]"+e);
                con.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	  		flag = false;    
	  
		} finally {
			try{
				con.setAutoCommit(true);	
				if(pstmt1 != null )		pstmt1.close();
				if(pstmt2 != null)		pstmt2.close();
			}
			catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return flag;
	}

	/**
	 *	과태료 스케줄 변동사항 : 입금처리, 입금취소, 청구금액 수정, 입금일자 수정 forfeit_c.jsp
	 */
	public boolean updateFineScd(FineBean cng_fine, String cmd, String pay_yn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query1 = " UPDATE FINE SET coll_dt=replace(?, '-', ''), ext_dt=replace(?, '-', ''), ext_id=?, update_dt=to_char(sysdate, 'YYYYMMDD'), update_id=?"+
						" WHERE rent_mng_id=? and rent_l_cd=? and car_mng_id=? and seq_no=?";

		try 
		{
			con.setAutoCommit(false);
		
			pstmt = con.prepareStatement(query1);
			pstmt.setString(1, cng_fine.getColl_dt());
			pstmt.setString(2, cng_fine.getExt_dt());
			pstmt.setString(3, cng_fine.getExt_id());
			pstmt.setString(4, cng_fine.getUpdate_id());
			pstmt.setString(5, cng_fine.getRent_mng_id());
			pstmt.setString(6, cng_fine.getRent_l_cd());
			pstmt.setString(7, cng_fine.getCar_mng_id());
			pstmt.setInt(8, cng_fine.getSeq_no());
		    pstmt.executeUpdate();
			pstmt.close();

			if( cmd.equals("p") || (cmd.equals("u")&&pay_yn.equals("Y")) ){
				flag = calDelay(cng_fine.getRent_mng_id(), cng_fine.getRent_l_cd(), cng_fine.getCar_mng_id());
			}

			con.commit();
		    
	  	} catch (Exception e) {
            try{
				System.out.println("[AddForfeitDatabase:updateFineScd]"+e);
                con.rollback();
            }catch(SQLException _ignored){}
			e.printStackTrace();
	  		flag = false;
		} finally {
			try{	
				con.setAutoCommit(true);
				if(pstmt != null )		pstmt.close();
			}
			catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return flag;
	}


    /**
     * 과태료/범칙금 수정
     */
    public int updateForfeit(FineBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        String rent_mng_id = "";
        String rent_l_cd = "";
        int seq_no = 0;
        int count = 0;
        seq_no = bean.getSeq_no();
        car_mng_id = bean.getCar_mng_id().trim();
        rent_mng_id = bean.getRent_mng_id().trim();
        rent_l_cd = bean.getRent_l_cd().trim();
 		
 		                
        query = " update fine set FINE_ST=?,CALL_NM=?,TEL=?,FAX=?,VIO_DT=replace(?,'-',''),VIO_PLA=?,VIO_CONT=?,"+
					" PAID_ST=?,REC_DT=replace(?,'-',''),PAID_END_DT=replace(?,'-',''),PAID_AMT=replace(?,',',''),"+
					" PROXY_DT=replace(?,'-',''),POL_STA=?,PAID_NO=?,FAULT_ST=?,FAULT_NM=?,DEM_DT=replace(?,'-',''),"+
					" COLL_DT=replace(?,'-',''),REC_PLAN_DT=replace(?,'-',''),NOTE=?,NO_PAID_YN=?,NO_PAID_CAU=?,\n"+
					" UPDATE_ID=?,UPDATE_DT=to_char(sysdate,'YYYYMMDD'),"+
					" OBJ_DT1=replace(?,'-',''), OBJ_DT2=replace(?,'-',''), OBJ_DT3=replace(?,'-',''), BILL_DOC_YN=?,"+
					" FAULT_AMT=?, BILL_MON=?, VAT_YN=?, TAX_YN=?, F_DEM_DT=replace(?,'-',''), E_DEM_DT=replace(?,'-',''), "+
					" BUSI_ST=?, rent_s_cd=?, notice_dt=replace(?,'-',''), obj_end_dt=replace(?,'-',''), mng_id=?, "+
					" incom_dt = replace(?,'-',''), incom_seq = ?, fine_gb = ?, PAID_AMT2=replace(?,',',''), RENT_ST = ?, vio_st = ? "+
				" where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";
         
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, bean.getFine_st().trim());
            pstmt.setString(2, bean.getCall_nm().trim());
            pstmt.setString(3, bean.getTel().trim());
            pstmt.setString(4, bean.getFax().trim());
            pstmt.setString(5, bean.getVio_dt().trim());
            pstmt.setString(6, bean.getVio_pla().trim());
            pstmt.setString(7, bean.getVio_cont().trim());
            pstmt.setString(8, bean.getPaid_st().trim());
            pstmt.setString(9, bean.getRec_dt().trim());
            pstmt.setString(10, bean.getPaid_end_dt().trim());
            pstmt.setInt(11, bean.getPaid_amt());
            pstmt.setString(12, bean.getProxy_dt().trim());
            pstmt.setString(13, bean.getPol_sta().trim());
            pstmt.setString(14, bean.getPaid_no().trim());
            pstmt.setString(15, bean.getFault_st().trim());
            pstmt.setString(16, bean.getFault_nm().trim());
            pstmt.setString(17, bean.getDem_dt().trim());
            pstmt.setString(18, bean.getColl_dt().trim());
            pstmt.setString(19, bean.getRec_plan_dt().trim());
            pstmt.setString(20, bean.getNote().trim());
            pstmt.setString(21, bean.getNo_paid_yn().trim());
            pstmt.setString(22, bean.getNo_paid_cau().trim());
            pstmt.setString(23, bean.getUpdate_id().trim());
			pstmt.setString(24, bean.getObj_dt1().trim());
			pstmt.setString(25, bean.getObj_dt2().trim());
			pstmt.setString(26, bean.getObj_dt3().trim());
			pstmt.setString(27, bean.getBill_doc_yn().trim());
			pstmt.setInt(28, bean.getFault_amt());
			pstmt.setString(29, bean.getBill_mon().trim());
            pstmt.setString(30, bean.getVat_yn().trim());
            pstmt.setString(31, bean.getTax_yn().trim());
            pstmt.setString(32, bean.getF_dem_dt().trim());
            pstmt.setString(33, bean.getE_dem_dt().trim());
            pstmt.setString(34, bean.getBusi_st().trim());
            pstmt.setString(35, bean.getRent_s_cd().trim());
            pstmt.setString(36, bean.getNotice_dt().trim());
			pstmt.setString(37, bean.getObj_end_dt().trim());
			pstmt.setString(38, bean.getMng_id().trim());
			pstmt.setString(39, bean.getIncom_dt().trim());
			pstmt.setInt(40, bean.getIncom_seq());
			pstmt.setString(41, bean.getFine_gb().trim());
            pstmt.setInt(42, bean.getPaid_amt2());
			
			pstmt.setString(43, bean.getRent_st().trim());
            pstmt.setString(44, bean.getVio_st().trim());

            pstmt.setInt   (45, seq_no);
            pstmt.setString(46, car_mng_id);
            pstmt.setString(47, rent_mng_id);
            pstmt.setString(48, rent_l_cd);
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:updateForfeit]"+se);
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

    public int deleteForfeit(FineBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        String rent_mng_id = "";
        String rent_l_cd = "";
        int seq_no = 0;
        int count = 0;
        seq_no = bean.getSeq_no();
        car_mng_id = bean.getCar_mng_id().trim();
        rent_mng_id = bean.getRent_mng_id().trim();
        rent_l_cd = bean.getRent_l_cd().trim();
 		
 		                
        query = " delete from fine where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";
         
       try{
			con.setAutoCommit(false);
			           
            pstmt = con.prepareStatement(query);            
            pstmt.setInt(1, seq_no);
            pstmt.setString(2, car_mng_id);
            pstmt.setString(3, rent_mng_id);
            pstmt.setString(4, rent_l_cd);            
            pstmt.executeUpdate();

			pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AddForfeitDatabase:deleteForfeit]"+se);
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
		count=2;
        return count;
    }
    
    /**
     * 과태료,범칙금 통화기록.
     */
    public int updateFineCall(FineCallBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
        
                
        query="update fine_call set CAR_NO=?,RENT_MNG_ID=?,RENT_L_CD=?,CALL_DT=?,CALL_CONT=?,REG_NM=?\n"
				+ "where car_mng_id=?";
            
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, bean.getCar_no().trim());
            pstmt.setString(2, bean.getRent_mng_id().trim());
            pstmt.setString(3, bean.getRent_l_cd().trim());
            pstmt.setString(4, bean.getCall_dt().trim());
            pstmt.setString(5, bean.getCall_cont().trim());
            pstmt.setString(6, bean.getReg_nm().trim());
            pstmt.setString(7, bean.getCar_mng_id().trim());
                        
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:updateFineCall]"+se);
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
     * 과태료, 범칙금 세부조회(car_mng_id, rent_mng_id).
     */
    public FineBean [] getForfeitDetailAll(String car_mng_id, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " select decode(a.fine_gb, '1','지로','2','송금','') as fine_nm, a.fine_gb, a.dmidx, b.car_no, c.client_id, d.firm_nm, d.client_nm, e.car_id, g.car_nm, f.car_name, a.seq_no, a.car_mng_id,"+
				" a.rent_mng_id, a.rent_l_cd, a.fine_st, a.call_nm, a.tel, a.fax,"+
				" decode(a.vio_dt,null,'',substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분') as VIO_DT_VIEW,"+
				" a.vio_dt, a.vio_pla, a.vio_cont, a.paid_st,"+
				" decode(a.rec_dt,null,'',substr(a.rec_dt,1,4)||'-'||substr(a.rec_dt,5,2)||'-'||substr(a.rec_dt,7,2)) as REC_DT,"+
				" decode(a.paid_end_dt,null,'',substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2)) as PAID_END_DT,"+
				" a.paid_amt, a.paid_amt2, decode(a.proxy_dt,null,'',substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2)) as PROXY_DT,"+
				" h.gov_nm as pol_sta, a.paid_no, a.fault_st, a.fault_nm, decode(a.dem_dt,null,'',substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2)) as DEM_DT,"+
				" decode(a.coll_dt,null,'',substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2)) as COLL_DT,"+
				" decode(a.rec_plan_dt,null,'',substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2)) as REC_PLAN_DT,"+
				" decode(a.obj_dt1,null,'',substr(a.obj_dt1,1,4)||'-'||substr(a.obj_dt1,5,2)||'-'||substr(a.obj_dt1,7,2)) as obj_dt1,"+
				" decode(a.obj_dt2,null,'',substr(a.obj_dt2,1,4)||'-'||substr(a.obj_dt2,5,2)||'-'||substr(a.obj_dt2,7,2)) as obj_dt2,"+
				" decode(a.obj_dt3,null,'',substr(a.obj_dt3,1,4)||'-'||substr(a.obj_dt3,5,2)||'-'||substr(a.obj_dt3,7,2)) as obj_dt3,"+
				" a.note, a.no_paid_yn, a.no_paid_cau, a.update_id, a.update_dt, a.bill_doc_yn, a.bill_mon, a.fault_amt,"+
				" a.vat_yn, a.tax_yn, a.f_dem_dt, a.e_dem_dt, a.busi_st, a.rent_s_cd, a.notice_dt, a.obj_end_dt, a.ext_dt, a.mng_id, a.file_name, a.file_type, a.incom_dt, a.incom_seq, a.file_name2, a.file_type2, "+
				" a.reg_id, a.rent_st, a.re_reg_id, a.re_reg_dt, a.vio_st \n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f, car_mng g, fine_gov h \n"
				+ "where a.car_mng_id='" + car_mng_id + "' and a.rent_l_cd='" + rent_l_cd + "'\n"
				+ "and a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"
				+ "and e.car_id = f.car_id(+) and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"
				+ "and a.pol_sta=h.gov_id "
				+ "order by a.vio_dt desc, a.seq_no ";

        Collection<FineBean> col = new ArrayList<FineBean>();
        
  //      System.out.println("getForfeitDetailAll: FineBean [] "+query);
        
        try{
           	stmt = con.createStatement();

            rs = stmt.executeQuery(query);
            while(rs.next()){
                
				col.add(makeFineBean(rs));
 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (FineBean[])col.toArray(new FineBean[0]);
    }

    /**
     * 과태료, 범칙금 한건 세부조회(car_mng_id, rent_mng_id, seq_no).
     */
    public FineBean getForfeitDetailAll(String car_mng_id, String rent_mng_id, String rent_l_cd, String seq_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		FineBean bean = new FineBean();
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " select decode(a.fine_gb, 1,'지로',2,'송금','') as fine_nm, a.fine_gb, a.dmidx, b.car_no, c.client_id, d.firm_nm, d.client_nm, e.car_id, g.car_nm, f.car_name, a.seq_no, a.car_mng_id,"+
				" a.rent_mng_id, a.rent_l_cd, a.fine_st, a.call_nm, a.tel, a.fax,"+
				" decode(a.vio_dt,null,'',substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분') as VIO_DT_VIEW,"+
				" a.vio_dt, a.vio_pla, a.vio_cont, a.paid_st,"+
				" decode(a.rec_dt,null,'',substr(a.rec_dt,1,4)||'-'||substr(a.rec_dt,5,2)||'-'||substr(a.rec_dt,7,2)) as REC_DT,"+
				" decode(a.paid_end_dt,null,'',substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2)) as PAID_END_DT,"+
				" a.paid_amt,a.paid_amt2, decode(a.proxy_dt,null,'',substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2)) as PROXY_DT,"+
				" a.pol_sta, a.paid_no, a.fault_st, a.fault_nm, decode(a.dem_dt,null,'',substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2)) as DEM_DT,"+
				" decode(a.coll_dt,null,'',substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2)) as COLL_DT,"+
				" decode(a.rec_plan_dt,null,'',substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2)) as REC_PLAN_DT,"+
				" decode(a.obj_dt1,null,'',substr(a.obj_dt1,1,4)||'-'||substr(a.obj_dt1,5,2)||'-'||substr(a.obj_dt1,7,2)) as obj_dt1,"+
				" decode(a.obj_dt2,null,'',substr(a.obj_dt2,1,4)||'-'||substr(a.obj_dt2,5,2)||'-'||substr(a.obj_dt2,7,2)) as obj_dt2,"+
				" decode(a.obj_dt3,null,'',substr(a.obj_dt3,1,4)||'-'||substr(a.obj_dt3,5,2)||'-'||substr(a.obj_dt3,7,2)) as obj_dt3,"+		
				" a.note, a.no_paid_yn, a.no_paid_cau, a.update_id, a.update_dt, a.bill_doc_yn, a.bill_mon, a.fault_amt, a.ext_dt, \n"+
				" a.vat_yn, a.tax_yn, a.f_dem_dt, a.e_dem_dt, a.busi_st, a.rent_s_cd, a.notice_dt, a.obj_end_dt, a.mng_id, a.file_name, a.file_type, a.incom_dt, a.incom_seq, "+
				" a.file_name2, a.file_type2, a.reg_id, a.rent_st, a.re_reg_id, a.re_reg_dt, a.vio_st, a.reg_dt \n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f, car_mng g\n"				
				+ "where a.car_mng_id='" + car_mng_id + "' and a.rent_mng_id='" + rent_mng_id + "' and a.rent_l_cd='" + rent_l_cd + "' and a.seq_no='" + seq_no + "'\n"
				+ "and a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"			
				+ "and e.car_id = f.car_id(+) and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n";

//	System.out.println("getForfeitDetailAll FineBean: "+query);
       
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){                
				bean = makeFineBean(rs); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[AddForfeitDatabase:getForfeitDetailAll]"+se);
			System.out.println("[AddForfeitDatabase:getForfeitDetailAll]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

    /**
     * 납부고지서번호 중복 체크.
     */
    public int getPaidNo(String paid_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		Statement stmt = null;
        ResultSet rs = null;
        int count = 0;
        String query = "";
        
        query = "select count(paid_no) from fine where paid_no='" + paid_no + "'\n";

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	count = rs.getInt(1);

            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[AddForfeitDatabase:getPaidNo]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    /**
     * 위반일시 중복 체크.
     */
    public int getVioDt(String vio_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		Statement stmt = null;
        ResultSet rs = null;
        int count = 0;
        String query = "";
        
        query = "select count(paid_no) from fine where vio_dt='" + vio_dt + "'\n";

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next())
            	count = rs.getInt(1);

            rs.close();
            stmt.close();
        }catch(SQLException se){
			System.out.println("[AddForfeitDatabase:getVioDt]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

    /**
     * 과태료 범칙금 등록시 계약 조회 ( 2002/1/10 ) - Kim JungTae
     */
    public RentListBean [] getCarRentListAll( String gubun, String rent_l_cd, String firm_nm, String car_no ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        
        String query = "";
        
        query = "select a.*, cr.car_no, cr.first_car_no, cr.car_nm, '' car_name, cr.car_num, cr.init_reg_dt, '' car_id, cc.cls_dt, b.reco_dt, c.car_deli_dt, c.rent_suc_dt , '' scan_file, decode(cr.init_reg_dt, null, 'id', 'ud') as  reg_gubun,  \n"+
        		     "	cp.rpt_no,   decode(cp.reg_ext_dt, '', '', substr(cp.reg_ext_dt, 1, 4) || '-' || substr(cp.reg_ext_dt, 5, 2) || '-'||substr(cp.reg_ext_dt, 7, 2)) REG_EXT_DT , '' cpt_cd  , cc.cls_st \n" +
        		     "    from cont_n_view a, car_reco b, cont_etc c , car_reg cr , cls_cont cc, car_pur cp  ";
   		
		if(gubun.equals("rent_l_cd"))	query += " where a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)    and a.rent_mng_id = cp.rent_mng_id(+) and a.rent_l_cd = cp.rent_l_cd(+)  and a.rent_mng_id = cc.rent_mng_id(+) and a.rent_l_cd = cc.rent_l_cd(+) and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) and a.car_mng_id = cr.car_mng_id(+)  and a.rent_l_cd like '%"+rent_l_cd+"%' order by a.rent_dt desc";
		if(gubun.equals("firm_nm"))		query += " where a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)    and a.rent_mng_id = cp.rent_mng_id(+) and a.rent_l_cd = cp.rent_l_cd(+)  and a.rent_mng_id = cc.rent_mng_id(+) and a.rent_l_cd = cc.rent_l_cd(+) and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) and a.car_mng_id = cr.car_mng_id(+) and a.firm_nm like '%"+firm_nm+"%' order by a.rent_dt desc";
		if(gubun.equals("car_no"))		query += " where a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)    and a.rent_mng_id = cp.rent_mng_id(+) and a.rent_l_cd = cp.rent_l_cd(+)  and a.rent_mng_id = cc.rent_mng_id(+) and a.rent_l_cd = cc.rent_l_cd(+) and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) and a.car_mng_id = cr.car_mng_id(+) and cr.car_no||' '||cr.first_car_no like '%"+car_no+"%' order by a.use_yn desc, a.rent_dt desc";

	//System.out.println(query);
	
        Collection<RentListBean> col = new ArrayList<RentListBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
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
			    bean.setFirst_car_no(rs.getString("FIRST_CAR_NO"));						//차량번호
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
				bean.setCar_name(rs.getString("CAR_NAME"));					
				bean.setCar_nm(rs.getString("CAR_NM"));					
				bean.setUse_yn(rs.getString("USE_YN"));					
				bean.setCls_dt(rs.getString("CLS_DT"));		
				bean.setReco_dt(rs.getString("RECO_DT"));	                     //차량반납일
				bean.setCar_deli_dt(rs.getString("CAR_DELI_DT"));				 //차량인도일	
				bean.setRent_suc_dt(rs.getString("RENT_SUC_DT"));				 //차량인도일	
			    
			    col.add(bean);
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }


	//과태료담당자 미정 리스트 조회/처리
	public void getFineMngIdNullList(String s_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		int count = 0;

		query = " select"+
				" a.*, decode(c.rent_s_cd, '',nvl(b.bus_id2,nvl(b.mng_id,b.bus_id)), decode(c.cust_st,'4',c.cust_id,c.bus_id)) fine_mng_id"+
				" from fine a, cont b, rent_cont c"+
				" where a.mng_id is null and a.fault_nm is null"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and a.car_mng_id=c.car_mng_id(+) and a.rent_s_cd=c.rent_s_cd(+)"+
//				" and substr(a.vio_dt,1,6) "+s_dt+
//				" and a.vio_dt like '%"+s_dt+"%'"+
				" order by a.reg_dt desc";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);

			while(rs.next())
			{				

				query2 = " update fine set mng_id=? where car_mng_id=? and seq_no=? and rent_mng_id=? and rent_l_cd=?";

				if(!rs.getString("fine_mng_id").equals("")){
					pstmt = con.prepareStatement(query2);
		            pstmt.setString(1, rs.getString("fine_mng_id"));
			        pstmt.setString(2, rs.getString("car_mng_id"));
				    pstmt.setInt   (3, AddUtil.parseInt(rs.getString("seq_no")));
					pstmt.setString(4, rs.getString("rent_mng_id"));
		            pstmt.setString(5, rs.getString("rent_l_cd"));
					count = pstmt.executeUpdate();
					pstmt.close();
				}
			}
			rs.close();
            stmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineMngIdNullList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineMngIdNullList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
	}

	//과태료 수금완료인데 미지출상태인 과태료 리스트 조회
	public Vector getFineCollNoPayList() throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" c.car_no, c.car_nm, b.rent_l_cd,"+
				" decode(m.car_mng_id,'','보유','매각') sui_st,"+
				" decode(b.use_yn,'Y','대여','해지') use_st,"+
				" decode(b.car_st,'2','단기','장기') car_st,"+
				" d.firm_nm,"+
				" h.min_dt, h.max_dt,"+
				" decode(e.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(e.cust_st,'4',g.user_nm,f.firm_nm) cust_nm,"+
				" substr(e.deli_dt,1,8) deli_dt, substr(nvl(e.ret_dt,e.ret_plan_dt),1,8) ret_dt,"+
				" o.user_nm as bus_nm, j.user_nm as bus_nm2, k.user_nm as mng_nm,"+
				" n.user_nm as fault_nm,"+
				" substr(a.vio_dt,1,8) vio_dt,"+
				" i.gov_nm,"+
				" a.vio_pla, a.vio_cont,"+
				" decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st,"+
				" a.rec_dt, a.PAID_END_DT, a.COLL_DT"+
				" from fine a, cont b, car_reg c, client d, rent_cont e, client f, users g, "+
				" (select rent_mng_id, rent_l_cd, min(rent_start_dt) min_dt, max(rent_end_dt) max_dt from fee group by rent_mng_id, rent_l_cd) h,"+
				" fine_gov i, users j, users k, cls_cont l, sui m, users n, users o"+
				" where"+
				" a.proxy_dt is null and a.COLL_DT is not null"+
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.car_mng_id=c.CAR_MNG_ID"+
				" and b.client_id=d.client_id"+
				" and a.car_mng_id=e.car_mng_id(+) and a.rent_s_cd=e.rent_s_cd(+)"+
				" and e.cust_id=f.client_id(+)"+
				" and e.cust_id=g.user_id(+)"+
				" and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+)"+
				" and a.pol_sta=i.gov_id(+)"+
				" and b.bus_id2=j.user_id(+)"+
				" and b.mng_id=k.user_id(+)"+
				" and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+)"+
				" and a.car_mng_id=m.car_mng_id(+)"+
				" and a.fault_nm=n.user_id(+)"+
				" and b.bus_id=o.user_id(+)"+
				" order by i.gov_st, i.gov_nm, c.car_no, a.vio_dt";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineMngIdNullList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineMngIdNullList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;			
		}
		return vt;
	}
	
	//과태료 수금완료인데 미지출상태인 과태료 리스트 조회
	public Vector getFineCollNoPayStatList(String gubun1, String gubun2, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"+
				" c.car_no, c.car_nm, b.rent_mng_id, b.rent_l_cd, a.car_mng_id, a.seq_no,"+
				" decode(m.car_mng_id,'','보유','매각') sui_st,"+
				" decode(b.use_yn,'Y','대여','해지') use_st,"+
				" decode(b.car_st,'2','단기','장기') car_st,"+
				" d.firm_nm,"+
				" h.min_dt, h.max_dt,"+
				" decode(e.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','장기대기','12','월렌트') rent_st,"+
				" decode(e.cust_st,'4',g.user_nm,f.firm_nm) cust_nm,"+
				" substr(e.deli_dt,1,8) deli_dt, substr(nvl(e.ret_dt,e.ret_plan_dt),1,8) ret_dt,"+
				" o.user_nm as bus_nm, j.user_nm as bus_nm2, k.user_nm as mng_nm, p.user_nm as fine_mng_nm,"+
				" n.user_nm as fault_nm,"+
				" substr(a.vio_dt,1,8) vio_dt,"+
				" i.gov_nm,"+
				" a.vio_pla, a.vio_cont,"+
				" decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st,"+
				" a.rec_dt, a.PAID_END_DT, a.COLL_DT, a.paid_amt"+
				" from fine a, cont b, car_reg c, client d, rent_cont e, client f, users g, "+
				" (select rent_mng_id, rent_l_cd, min(rent_start_dt) min_dt, max(rent_end_dt) max_dt from fee group by rent_mng_id, rent_l_cd) h,"+
				" fine_gov i, users j, users k, cls_cont l, sui m, users n, users o, users p"+
				" where"+
				" a.proxy_dt is null and a.COLL_DT is not null";


		if(gubun1.equals("1")) query += " and a.fault_st='1'";
		if(gubun1.equals("2")) query += " and a.fault_st='2'";

		if(gubun2.equals("1")) query += " and a.paid_st='1'";
		if(gubun2.equals("2")) query += " and a.paid_st='2'";
		if(gubun2.equals("3")) query += " and a.paid_st='3'";
		if(gubun2.equals("4")) query += " and a.paid_st='4'";
		if(gubun2.equals("5")) query += " and a.paid_st in ('2','3','4')";

		query +=
				" and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				" and b.car_mng_id=c.CAR_MNG_ID"+
				" and b.client_id=d.client_id"+
				" and a.car_mng_id=e.car_mng_id(+) and a.rent_s_cd=e.rent_s_cd(+)"+
				" and e.cust_id=f.client_id(+)"+
				" and e.cust_id=g.user_id(+)"+
				" and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+)"+
				" and a.pol_sta=i.gov_id(+)"+
				" and b.bus_id2=j.user_id(+)"+
				" and b.mng_id=k.user_id(+)"+
				" and a.rent_mng_id=l.rent_mng_id(+) and a.rent_l_cd=l.rent_l_cd(+)"+
				" and a.car_mng_id=m.car_mng_id(+)"+
				" and a.fault_nm=n.user_id(+)"+
				" and b.bus_id=o.user_id(+)"+
				" and a.mng_id=p.user_id(+)"+
				" ";

		if(!t_wd.equals("")){
			if(s_kd.equals("1")) query += " and c.car_no like '%"+t_wd+"%' ";
			if(s_kd.equals("2")) query += " and a.vio_dt like '%"+t_wd+"%' ";
			if(s_kd.equals("3")) query += " and a.vio_pla like '%"+t_wd+"%' ";
			if(s_kd.equals("4")) query += " and a.vio_cont like '%"+t_wd+"%' ";
			if(s_kd.equals("5")) query += " and a.paid_no like '%"+t_wd+"%' ";
			if(s_kd.equals("6")) query += " and i.gov_nm like '%"+t_wd+"%' ";
			if(s_kd.equals("7")) query += " and a.paid_amt like '%"+t_wd+"%' ";
			if(s_kd.equals("8")) query += " and a.mng_id like '%"+t_wd+"%' ";
		}

		if(sort_gubun.equals("1")) query += " order by a.vio_dt ";
		if(sort_gubun.equals("2")) query += " order by a.coll_dt ";
		if(sort_gubun.equals("3")) query += " order by a.paid_end_dt ";
		if(sort_gubun.equals("4")) query += " order by c.car_no ";
		if(sort_gubun.equals("5")) query += " order by i.gov_st||i.gov_nm ";
		if(sort_gubun.equals("6")) query += " order by p.user_nm ";

		if(asc.equals("1")) query += " desc ";


		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineMngIdNullList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineMngIdNullList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;			
		}
		return vt;
	}
	 
     /**
     * 과태료, 범칙금 한건 세부조회(rent_mng_id, rent_mng_id, seq_no, exp_amt) - 재무회계
     */
    public FineBean getForfeitDetailncom(String rent_mng_id, String rent_l_cd, String seq_no, int exp_amt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		FineBean bean = new FineBean();
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " select b.car_no, c.client_id, d.firm_nm, d.client_nm, e.car_id, g.car_nm, f.car_name, a.seq_no, a.car_mng_id,"+
				" a.rent_mng_id, a.rent_l_cd, a.fine_st, a.call_nm, a.tel, a.fax,"+
				" decode(a.vio_dt,null,'',substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분') as VIO_DT_VIEW,"+
				" a.vio_dt, a.vio_pla, a.vio_cont, a.paid_st,"+
				" decode(a.rec_dt,null,'',substr(a.rec_dt,1,4)||'-'||substr(a.rec_dt,5,2)||'-'||substr(a.rec_dt,7,2)) as REC_DT,"+
				" decode(a.paid_end_dt,null,'',substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2)) as PAID_END_DT,"+
				" a.paid_amt,a.paid_amt2, decode(a.proxy_dt,null,'',substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2)) as PROXY_DT,"+
				" a.pol_sta, a.paid_no, a.fault_st, a.fault_nm, decode(a.dem_dt,null,'',substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2)) as DEM_DT,"+
				" decode(a.coll_dt,null,'',substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2)) as COLL_DT,"+
				" decode(a.rec_plan_dt,null,'',substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2)) as REC_PLAN_DT,"+
				" decode(a.obj_dt1,null,'',substr(a.obj_dt1,1,4)||'-'||substr(a.obj_dt1,5,2)||'-'||substr(a.obj_dt1,7,2)) as obj_dt1,"+
				" decode(a.obj_dt2,null,'',substr(a.obj_dt2,1,4)||'-'||substr(a.obj_dt2,5,2)||'-'||substr(a.obj_dt2,7,2)) as obj_dt2,"+
				" decode(a.obj_dt3,null,'',substr(a.obj_dt3,1,4)||'-'||substr(a.obj_dt3,5,2)||'-'||substr(a.obj_dt3,7,2)) as obj_dt3,"+
				" a.ext_dt,"+
				" a.note, a.no_paid_yn, a.no_paid_cau, a.update_id, a.update_dt, a.bill_doc_yn, a.bill_mon, a.fault_amt, \n"+
				" a.vat_yn, a.tax_yn, a.f_dem_dt, a.e_dem_dt, a.busi_st, a.rent_s_cd, a.notice_dt, a.obj_end_dt, a.mng_id, a.file_name, a.file_type, a.incom_dt, a.incom_seq, "+
				" a.file_name2, a.file_type2, a.reg_id, a.rent_st, a.re_reg_id, a.re_reg_dt, a.vio_st \n"
				+ "from fine a, car_reg b, cont c, client d, car_etc e, car_nm f, car_mng g\n"			
				+ "where a.rent_mng_id='" + rent_mng_id + "' and a.rent_l_cd='" + rent_l_cd + "' and a.seq_no='" + seq_no + "' and a.paid_amt = " + exp_amt + "\n"
				+ "and a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id\n"
				+ "and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"			
				+ "and e.car_id = f.car_id(+) and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n";
       
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){                
				bean = makeFineBean(rs); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
    
        /**
     * 과태료/범칙금 수정 - 재무회계
     */
    public int updateForfeitIncom(FineBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        String car_mng_id = "";
        String rent_mng_id = "";
        String rent_l_cd = "";
        int seq_no = 0;
        int count = 0;
        seq_no = bean.getSeq_no();
        car_mng_id = bean.getCar_mng_id().trim();
        rent_mng_id = bean.getRent_mng_id().trim();
        rent_l_cd = bean.getRent_l_cd().trim();
 		
 		                
        query = " update fine set FINE_ST=?,CALL_NM=?,TEL=?,FAX=?,VIO_DT=replace(?,'-',''),VIO_PLA=?,VIO_CONT=?,"+
					" PAID_ST=?,REC_DT=replace(?,'-',''),PAID_END_DT=replace(?,'-',''),PAID_AMT=replace(?,',',''),"+
					" PROXY_DT=replace(?,'-',''),POL_STA=?,PAID_NO=?,FAULT_ST=?,FAULT_NM=?,DEM_DT=replace(?,'-',''),"+
					" COLL_DT=replace(?,'-',''),REC_PLAN_DT=replace(?,'-',''),NOTE=?,NO_PAID_YN=?,NO_PAID_CAU=?,\n"+
					" UPDATE_ID=?,UPDATE_DT=to_char(sysdate,'YYYYMMDD'),"+
					" OBJ_DT1=replace(?,'-',''), OBJ_DT2=replace(?,'-',''), OBJ_DT3=replace(?,'-',''), BILL_DOC_YN=?,"+
					" FAULT_AMT=?, BILL_MON=?, VAT_YN=?, TAX_YN=?, F_DEM_DT=replace(?,'-',''), E_DEM_DT=replace(?,'-',''), BUSI_ST=?, rent_s_cd=?, notice_dt=replace(?,'-',''), obj_end_dt=replace(?,'-','')"+
				" where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";
         
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);
            
            pstmt.setString(1, bean.getFine_st().trim());
            pstmt.setString(2, bean.getCall_nm().trim());
            pstmt.setString(3, bean.getTel().trim());
            pstmt.setString(4, bean.getFax().trim());
            pstmt.setString(5, bean.getVio_dt().trim());
            pstmt.setString(6, bean.getVio_pla().trim());
            pstmt.setString(7, bean.getVio_cont().trim());
            pstmt.setString(8, bean.getPaid_st().trim());
            pstmt.setString(9, bean.getRec_dt().trim());
            pstmt.setString(10, bean.getPaid_end_dt().trim());
            pstmt.setInt(11, bean.getPaid_amt());
            pstmt.setString(12, bean.getProxy_dt().trim());
            pstmt.setString(13, bean.getPol_sta().trim());
            pstmt.setString(14, bean.getPaid_no().trim());
            pstmt.setString(15, bean.getFault_st().trim());
            pstmt.setString(16, bean.getFault_nm().trim());
            pstmt.setString(17, bean.getDem_dt().trim());
            pstmt.setString(18, bean.getColl_dt().trim());
            pstmt.setString(19, bean.getRec_plan_dt().trim());
            pstmt.setString(20, bean.getNote().trim());
            pstmt.setString(21, bean.getNo_paid_yn().trim());
            pstmt.setString(22, bean.getNo_paid_cau().trim());
            pstmt.setString(23, bean.getUpdate_id().trim());
			pstmt.setString(24, bean.getObj_dt1().trim());
			pstmt.setString(25, bean.getObj_dt2().trim());
			pstmt.setString(26, bean.getObj_dt3().trim());
			pstmt.setString(27, bean.getBill_doc_yn().trim());
			pstmt.setInt(28, bean.getFault_amt());
			pstmt.setString(29, bean.getBill_mon().trim());
            pstmt.setString(30, bean.getVat_yn().trim());
            pstmt.setString(31, bean.getTax_yn().trim());
            pstmt.setString(32, bean.getF_dem_dt().trim());
            pstmt.setString(33, bean.getE_dem_dt().trim());
            pstmt.setString(34, bean.getBusi_st().trim());
            pstmt.setString(35, bean.getRent_s_cd().trim());
            pstmt.setString(36, bean.getNotice_dt().trim());
			pstmt.setString(37, bean.getObj_end_dt().trim());
            pstmt.setInt(38, seq_no);
            pstmt.setString(39, car_mng_id);
            pstmt.setString(40, rent_mng_id);
            pstmt.setString(41, rent_l_cd);
            
            pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
            	count = 1;
				System.out.println("[AddForfeitDatabase:updateForfeitIncom]"+se);
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
     * 과태료/범칙금 스캔파일 수정
     */
    public int updateForfeitFileName(String car_mng_id, String rent_mng_id, String rent_l_cd, int seq_no, String file_name) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0; 		
 		                
        query = " update fine set FILE_NAME=? "+
				" where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";
         
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, file_name	);
            pstmt.setInt   (2, seq_no		);
            pstmt.setString(3, car_mng_id	);
            pstmt.setString(4, rent_mng_id	);
            pstmt.setString(5, rent_l_cd	);
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:updateForfeitFileName]"+se);
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
     * 과태료/범칙금 스캔파일 수정
     */
    public int updateForfeitFileName(String car_mng_id, String rent_mng_id, String rent_l_cd, int seq_no, String file_name, String file_type, String file_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0; 		
 		                
        query = " update fine set ";
		
		if(file_st.equals("1")) query += " FILE_NAME=?, FILE_TYPE=? ";
		if(file_st.equals("2")) query += " FILE_NAME2=?, FILE_TYPE2=? ";

		query += " where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";
         
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, file_name	);
            pstmt.setString(2, file_type	);
            pstmt.setInt   (3, seq_no		);
            pstmt.setString(4, car_mng_id	);
            pstmt.setString(5, rent_mng_id	);
            pstmt.setString(6, rent_l_cd	);
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:updateForfeitFileName]"+se);
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
     * 과태료 범칙금 등록시 계약 조회
     */
    public RentListBean [] getCarRentListAll2( String gubun, String rent_l_cd, String firm_nm, String car_no ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String subQuery = "";
        
        String query = "";
        
        query = "select a.*, cr.car_no, cr.first_car_no, cr.car_nm, cr.car_num, cr.init_reg_dt, c.car_id, cc.cls_dt, b.reco_dt, c.car_deli_dt, c.rent_suc_dt , '' scan_file, decode(cr.init_reg_dt, null, 'id', 'ud') as  reg_gubun,  \n"+
        		     "	cp.rpt_no,   decode(cp.reg_ext_dt, '', '', substr(cp.reg_ext_dt, 1, 4) || '-' || substr(cp.reg_ext_dt, 5, 2) || '-'||substr(cp.reg_ext_dt, 7, 2)) REG_EXT_DT , '' cpt_cd  , cc.cls_st \n" +
        		     "    from cont_n_view a, car_reco b, cont_etc c , car_reg cr , cls_cont cc, car_pur cp  ";
        		                  
		if(gubun.equals("rent_l_cd"))	query += " where a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)    and a.rent_mng_id = cp.rent_mng_id(+) and a.rent_l_cd = cp.rent_l_cd(+)  and a.rent_mng_id = cc.rent_mng_id(+) and a.rent_l_cd = cc.rent_l_cd(+) and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) and a.car_mng_id = cr.car_mng_id(+)  and a.rent_l_cd like '%"+rent_l_cd+"%' order by a.rent_dt desc";
		if(gubun.equals("firm_nm"))		query += " where a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)    and a.rent_mng_id = cp.rent_mng_id(+) and a.rent_l_cd = cp.rent_l_cd(+)  and a.rent_mng_id = cc.rent_mng_id(+) and a.rent_l_cd = cc.rent_l_cd(+) and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) and a.car_mng_id = cr.car_mng_id(+) and a.firm_nm like '%"+firm_nm+"%' order by a.rent_dt desc";
		if(gubun.equals("car_no"))		query += " where a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)    and a.rent_mng_id = cp.rent_mng_id(+) and a.rent_l_cd = cp.rent_l_cd(+)  and a.rent_mng_id = cc.rent_mng_id(+) and a.rent_l_cd = cc.rent_l_cd(+) and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) and a.car_mng_id = cr.car_mng_id(+) and cr.car_no||' '||cr.first_car_no like '%"+car_no+"%' order by a.use_yn desc, a.rent_dt desc";

        Collection<RentListBean> col = new ArrayList<RentListBean>();
        try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery(query);

            while(rs.next()){
                
				RentListBean bean = new RentListBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//계약관리ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//계약코드
			    bean.setRent_dt(rs.getString("RENT_DT"));				//계약일자
			    bean.setDlv_dt(rs.getString("DLV_DT"));					//출고일자
			    bean.setClient_id(rs.getString("CLIENT_ID"));					//고객ID
			    bean.setClient_nm(rs.getString("CLIENT_NM"));					//고객 대표자명
			    bean.setFirm_nm(rs.getString("FIRM_NM"));						//상호
			    bean.setBr_id(rs.getString("BR_ID"));						//상호
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));					//자동차관리ID
			    bean.setInit_reg_dt(rs.getString("INIT_REG_DT"));					//최초등록일
			    bean.setReg_gubun(rs.getString("REG_GUBUN"));					//최초등록일
			    bean.setCar_no(rs.getString("CAR_NO"));						//차량번호
			    bean.setFirst_car_no(rs.getString("FIRST_CAR_NO"));						//차량번호
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
				bean.setCar_name(rs.getString("CAR_NAME"));					
				bean.setCar_nm(rs.getString("CAR_NM"));					
				bean.setUse_yn(rs.getString("USE_YN"));					
				bean.setCls_dt(rs.getString("CLS_DT"));					
			    
			    col.add(bean);
 
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (RentListBean[])col.toArray(new RentListBean[0]);
    }
    
    
	//과태료 리스트 조회 - 납부예정 (미수금관련) - 수금이 되어도 납부때문에 떠야 함.
	public Vector getFineExpPreList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		
		String standard_dt = "decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt)";
		
		String query = "";
		query = " select /*+  merge(b) */ a.fine_gb, \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm,  '' scan_file,\n"+
				"        cr.car_no, cr.first_car_no, cr.car_nm , cn.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				"        decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st,"+
				"        a.pol_sta, a.paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt, a.e_dem_dt, \n"+
				"        e.gov_nm, a.reg_dt, "+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm"+
				" from   fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j ,  car_reg cr,  car_etc ce, car_nm cn \n"+
				" where  a.paid_amt > 0 and a.pol_sta=e.gov_id(+) and (a.vio_cont like '%통행료%' or a.vio_cont like '%주차요금%' or a.note like '%엑셀파일로%') \n"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+) \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+
				" ";

		/*상세조회&&세부조회*/

//	if(!gubun2.equals("5")){

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and substr(a.notice_dt,1,6) = to_char(SYSDATE, 'YYYYMM')";// and a.paid_st <> '2'
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr(a.notice_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is not null";// and a.paid_st <> '2'
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and substr(a.notice_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is null";// and a.paid_st <> '2'
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";// and a.paid_st <> '2'
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and a.notice_dt <= to_char(SYSDATE, 'YYYYMMDD') and (a.proxy_dt is null or a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and a.notice_dt <= to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and a.notice_dt <= to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and a.notice_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.notice_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and a.notice_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.proxy_dt is not null";
		//검색-미지출
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.proxy_dt is null";
		//접수일자
		}else if(gubun2.equals("7")){	query += " and a.rec_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		}
//	}

		if(gubun4.equals("2"))			query += " and a.fault_st='1'";
		else if(gubun4.equals("3"))		query += " and a.fault_st='2'";
		else if(gubun4.equals("4"))		query += " and a.paid_st='2'";
		else if(gubun4.equals("5"))		query += " and a.paid_st='3'";
		else if(gubun4.equals("6"))		query += " and a.paid_st='1'";
		else if(gubun4.equals("7"))		query += " and a.paid_st='4'";
		else if(gubun4.equals("8"))		query += " and a.paid_st<>'1'";

		if(gubun5.equals("1"))			query += " ";
		else if(gubun5.equals("2"))		query += " and a.fine_gb='1'";
		else if(gubun5.equals("3"))		query += " and a.fine_gb='2'";
		

		/*검색조건*/
	if(!t_wd.equals("")){	
		if(s_kd.equals("2"))		query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '')||nvl(cr.first_car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and nvl(a.mng_id, nvl(b.mng_id,b.bus_id2))= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.pol_sta||e.gov_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("14"))	query += " and nvl(a.rec_dt, a.notice_dt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("15"))	query += " and nvl(a.vio_cont, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("20"))	query += " and nvl(a.proxy_est_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("21"))	query += " and nvl(a.note, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
	}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.vio_dt "+sort+", a.paid_end_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.vio_dt, a.paid_end_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.proxy_dt "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.proxy_dt, b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("6"))	query += " order by e.gov_nm "+sort+", a.rec_dt, cr.car_no, b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("7"))	query += " order by a.reg_dt "+sort+"  ";
	
// System.out.println("[AddForfeitDatabase:getFineExpList]\n"+query);

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineExpPreList(]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineExpPreList(]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	
	 /**
     * 과태료/범칙금 - 일일 아마존카 대납관련 납부에정일 등록, 청구월: 납부일 + 15일 후 돌아오는 대여료 출금일 - 선납분은 청구일계산, 
     */
    public boolean updateForfeitProxyDt(String car_mng_id, String rent_mng_id, String rent_l_cd, int seq_no, String proxy_est_dt, String user_id, String gubun) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        String query = "";
        String query1 = "";
        
        ResultSet rs = null;
        boolean flag = true;
        String dem_dt = "";    
          
     	String sResult = "";
		CallableStatement cstmt = null;
		        		            		                
        query = " update fine set proxy_est_dt=replace(?, '-', ''), dem_dt = ?, update_id = ? , update_dt=to_char(sysdate, 'yyyymmdd') "+
				" where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=? ";           





       try{
            con.setAutoCommit(false);
            
            if (gubun.equals("1")||gubun.equals("2")) {
	            cstmt = con.prepareCall("{ ? =  call F_getFineDemDt( ?, ?, ?, ? ) }");
	
				cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			    cstmt.setString(2, rent_mng_id );
	            cstmt.setString(3, rent_l_cd );
	            cstmt.setString(4, car_mng_id );
	            cstmt.setInt(5, seq_no );
	           
	           	cstmt.execute();
	           	sResult = cstmt.getString(1); // 결과값
	           	cstmt.close();
			}
			   
//	System.out.println("dem_dt 계산 =" + sResult);
		
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, proxy_est_dt	);
            if (gubun.equals("1")||gubun.equals("2")) {
            	pstmt.setString(2, sResult	);
            } else {           
            	pstmt.setString(2, "" );            		
            }		
            pstmt.setString(3, user_id	);
            pstmt.setInt   (4, seq_no		);
            pstmt.setString(5, car_mng_id	);
            pstmt.setString(6, rent_mng_id	);
            pstmt.setString(7, rent_l_cd	);            
            pstmt.executeUpdate();             
            pstmt.close();
            con.commit();

/*
				System.out.println("[AddForfeitDatabase:updateForfeitProxyDt]"+query);
				System.out.println("[AddForfeitDatabase:proxy_est_dt]"+proxy_est_dt);
				System.out.println("[AddForfeitDatabase:sResult]"+sResult);
				System.out.println("[AddForfeitDatabase:user_id]"+user_id);
				System.out.println("[AddForfeitDatabase:seq_no]"+seq_no);
				System.out.println("[AddForfeitDatabase:car_mng_id]"+car_mng_id);
				System.out.println("[AddForfeitDatabase:rent_mng_id]"+rent_mng_id);
				System.out.println("[AddForfeitDatabase:rent_l_cd]"+rent_l_cd);
				System.out.println("[AddForfeitDatabase:gubun]"+gubun);
*/
        }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:updateForfeitProxyDt]"+se);
				System.out.println("[AddForfeitDatabase:updateForfeitProxyDt]"+query);
				System.out.println("[AddForfeitDatabase:proxy_est_dt]"+proxy_est_dt);
				System.out.println("[AddForfeitDatabase:sResult]"+sResult);
				System.out.println("[AddForfeitDatabase:user_id]"+user_id);
				System.out.println("[AddForfeitDatabase:seq_no]"+seq_no);
				System.out.println("[AddForfeitDatabase:car_mng_id]"+car_mng_id);
				System.out.println("[AddForfeitDatabase:rent_mng_id]"+rent_mng_id);
				System.out.println("[AddForfeitDatabase:rent_l_cd]"+rent_l_cd);
				System.out.println("[AddForfeitDatabase:gubun]"+gubun);

				flag = false;
				con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
          
                if(cstmt != null) cstmt.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }
	
	//과태료 리스트 조회 - 납부현황
	public Vector getFineExpPreProxyList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		
		String standard_dt = "decode(nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')), '',a.paid_end_dt, nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')))";
				
		String query = "";
		query = " select /*+  merge(b) */ \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm,  '' scan_file,\n"+
				"        cr.car_no, cr.first_car_no, cr.car_nm,cnb.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				"        decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st,"+
				"        a.pol_sta, a.paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt,\n"+
				"        nvl2(a.e_dem_dt,substr(a.e_dem_dt,1,4)||'-'||substr(a.e_dem_dt,5,2)||'-'||substr(a.e_dem_dt,7,2),'') e_dem_dt,\n"+
				"        e.gov_nm,"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm"+
				" from   fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j ,  car_reg cr,  car_etc ce, car_nm cn \n"+
				" where\n"+
				"        a.paid_amt > 0 and a.coll_dt is null and a.pol_sta=e.gov_id(+) and (a.vio_cont like '%통행료%' or a.vio_cont like '%주차요금%' )"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id "+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+)  \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+
				" ";

     /* gubun1 :proxy_dt 납입일자 */
		
		if(gubun2.equals("1"))			query += "  and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD') ";
		else if(gubun2.equals("2"))		query += "  and substr(a.proxy_dt,1,6) = to_char(SYSDATE, 'YYYYMM') ";
		else if(gubun2.equals("3"))		query += "  and a.proxy_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' ";
		else if(gubun2.equals("4"))		query += "  and a.proxy_dt is not null ";
	
		
		if(gubun4.equals("2"))			query += " and a.fault_st='1'";
		else if(gubun4.equals("3"))		query += " and a.fault_st='2'";
		else if(gubun4.equals("4"))		query += " and a.paid_st='2'";
		else if(gubun4.equals("5"))		query += " and a.paid_st='3'";
		else if(gubun4.equals("6"))		query += " and a.paid_st='1'";
		else if(gubun4.equals("7"))		query += " and a.paid_st='4'";
		else if(gubun4.equals("8"))		query += " and a.paid_st<>'1'";
		
		//if(!br_id.equals("S1") && !br_id.equals(""))		query += " and b.brch_id='"+br_id+"'";

		/*검색조건*/
	if(!t_wd.equals("")){	
	//	if(s_kd.equals("2"))		query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
	//	else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		if(s_kd.equals("2"))	query += " and nvl(cr.car_no, '')||nvl(cr.first_car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and nvl(a.mng_id, nvl(b.mng_id,b.bus_id2))= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
//		else if(s_kd.equals("13"))	query += " and a.pol_sta like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and a.pol_sta||e.gov_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("14"))	query += " and nvl(a.rec_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("15"))	query += " and nvl(a.vio_cont, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
	}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.vio_dt "+sort+", a.paid_end_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.proxy_dt, a.vio_dt, a.paid_end_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.proxy_dt "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.proxy_dt, b.firm_nm, a.paid_end_dt";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("6"))	query += " order by e.gov_nm "+sort+", a.rec_dt, cr.car_no, b.firm_nm, a.paid_end_dt";
	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    
    			
    	//	System.out.println(query);
    		 
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineExpPreProxyList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineExpPreProxyList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	//과태료 납부한 것중 청구예정리스트 - 최초청구발행
	public Vector getFinePreDemList(String client_id, String r_site, String m_id, String l_cd, String s_yy, String s_mm, String s_dd, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String sort, String asc)throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
		String search = "";
		String search_dt = "";


		query = " select /*+  merge(b) */ \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd,  b.firm_nm, b.client_nm, '' scan_file,\n"+
				"        cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				"        decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st,"+
				"        a.pol_sta, a.paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt,\n"+
				"        e.gov_nm, "+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm) cust_nm, a.fault_nm"+
				" from   fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i,  rent_cust j , car_reg cr,  car_etc ce, car_nm cn \n"+
				" where\n"+
				"        a.paid_amt > 0 and a.coll_dt is null and a.proxy_dt is not null and a.e_dem_dt is null "+
				"        and (a.vio_cont like '%통행료%' or a.vio_cont like '%주차요금%' )"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+)   \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+		
				"        and a.pol_sta=e.gov_id(+) "+
				" ";
				
		if(!client_id.equals(""))	query += " and b.client_id='"+client_id+"'";
		if(!r_site.equals(""))		query += " and b.r_site='"+r_site+"'";
		if(!m_id.equals(""))		query += " and b.rent_mng_id='"+m_id+"'";
		if(!l_cd.equals(""))		query += " and b.rent_l_cd='"+l_cd+"'";


		if(s_kd.equals("1"))		search = " cr.car_no";
		else if(s_kd.equals("2"))	search = " cr.car_nm";

		if(!t_wd.equals(""))		query += " and "+search+" like '%"+t_wd+"%'";

		query += " order by a.vio_dt";

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

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFinePreDemList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFinePreDemList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	//과태료  청구메일발송
	public Vector getFinePreDemList1(String client_id, String r_site, String m_id, String l_cd, String st_dt, String end_dt, String gubun2, String s_kd, String t_wd,  String sort, String asc)throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
		String search = "";
		String search_dt = "a.proxy_dt";

		query = " select /*+  merge(b) */ \n"+
				"        nvl(g.cust_id,b.client_id) client_id, a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm, '' scan_file,\n"+
				"        cr.car_no, cr.first_car_no, cr.car_nm,cnb.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				"        decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st,"+
				"        a.pol_sta, a.paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        a.dem_dt dem_dt,\n"+
				"        e.gov_nm, e.tel, "+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm "+
				" from   fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j, car_reg cr,  car_etc ce, car_nm cn \n"+ 
				" where\n"+
				"        a.coll_dt is null and (a.vio_cont like '%통행료%' or a.vio_cont like '%주차요금%' )"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)  \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+			
				"        and a.pol_sta=e.gov_id(+) "+
				" ";
				

		if(!client_id.equals(""))	query += " and b.client_id='"+client_id+"'";
		if(!r_site.equals(""))		query += " and b.r_site='"+r_site+"'";
		if(!m_id.equals(""))		query += " and b.rent_mng_id='"+m_id+"'";
		if(!l_cd.equals(""))		query += " and b.rent_l_cd='"+l_cd+"'";


		if(s_kd.equals("1"))		search = " cr.car_no";
		else if(s_kd.equals("2"))	search = " cr.car_nm";

		if(!t_wd.equals(""))		query += " and "+search+" like '%"+t_wd+"%'";

		query += " order by a.vio_dt";

		try {
			
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    
    		ResultSetMetaData rsmd = rs.getMetaData();    
    			
    //		System.out.println(query);
    		 
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
			System.out.println("[AddForfeitDatabase:getFinePreDemList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFinePreDemList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
		//과태료  청구메일발송 - 사전에 발송
	public Vector getFinePreDemList3( String m_id, String l_cd, String c_id, int seq_no,  String sort, String asc)throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
		String search = "";
		String search_dt = "a.proxy_dt";

		query = " select a.NOTICE_DT, \n"+
				"        nvl(g.cust_id,b.client_id) client_id, a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm, \n"+
				"        cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, a.vio_pla, a.vio_cont, a.paid_no,  "+
				"        a.pol_sta, decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, \n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        a.dem_dt dem_dt,\n"+
				"        e.gov_nm, e.tel, "+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm "+
				" from   fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j , car_reg cr,  car_etc ce, car_nm cn \n"+
				" where\n"+
				"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"	     and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id  and a.rent_l_cd = ce.rent_l_cd  \n"+
                "	     and ce.car_id=cn.car_id  and    ce.car_seq=cn.car_seq  \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+) \n"+		
				"        and a.pol_sta=e.gov_id(+) "+
				" ";
				
	
		if(!m_id.equals(""))		query += " and a.rent_mng_id='"+m_id+"'";
		if(!l_cd.equals(""))		query += " and a.rent_l_cd='"+l_cd+"'";
		if(!c_id.equals(""))		query += " and a.car_mng_id='"+c_id+"'";
		if(seq_no > 0 )				query += " and a.seq_no="+seq_no;

		query += " order by a.vio_dt";


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

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFinePreDemList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFinePreDemList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	//과태료 납부한 것중 청구예정리스트 -청구일자 없는 경우는 납부일의 다음달 5일
	public Vector getFinePreDemList(String client_id, String r_site, String m_id, String l_cd, String st_dt, String end_dt, String gubun2, String s_kd, String t_wd,  String sort, String asc)throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
		String search = "";
		String search_dt = "a.proxy_dt";

		query = " select /*+  merge(b) */ \n"+
				"        nvl(g.cust_id,b.client_id) client_id, a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd,  b.firm_nm,  b.client_nm, '' scan_file,\n"+
				"        cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				"        decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st,"+
				"        a.pol_sta,decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        a.dem_dt dem_dt,\n"+
				"        e.gov_nm, "+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm "+
				" from   fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j , car_reg cr,  car_etc ce, car_nm cn \n"+
				" where\n"+
				"		 a.paid_amt > 0 and a.coll_dt is null and a.proxy_dt is not null  and (a.vio_cont like '%통행료%' or a.vio_cont like '%주차요금%' )"+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)  \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+			
				"        and a.pol_sta=e.gov_id(+) "+
				" ";
				

		if(!client_id.equals(""))	query += " and b.client_id='"+client_id+"'";
		if(!r_site.equals(""))		query += " and b.r_site='"+r_site+"'";
		if(!m_id.equals(""))		query += " and b.rent_mng_id='"+m_id+"'";
		if(!l_cd.equals(""))		query += " and b.rent_l_cd='"+l_cd+"'";


		//기간검색
		if(gubun2.equals("1"))		query += " and substr("+search_dt+",1,8) = to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("2"))		query += " and substr("+search_dt+",1,6) = to_char(sysdate,'YYYYMM')";
		if(gubun2.equals("3")){
			if(!st_dt.equals("") && !end_dt.equals(""))	query += " and "+search_dt+" between '"+st_dt+"' and '"+end_dt+"'";
		}

		if(s_kd.equals("1"))		search = " cr.car_no";
		else if(s_kd.equals("2"))	search = " cr.car_nm";

		if(!t_wd.equals(""))		query += " and "+search+" like '%"+t_wd+"%'";

		query += " order by a.vio_dt";

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

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFinePreDemList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFinePreDemList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	// 과태료 메일내역
	public Vector getFinePreDemList2( String m_id, String l_cd, String dem_dt, String e_dem_dt, String sort, String asc)throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
	
		query = " select /*+  merge(b) */ \n"+
				" nvl(g.cust_id,b.client_id) client_id, a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd,  b.firm_nm, b.client_nm, \n"+
				" cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, a.vio_pla, a.vio_cont, a.paid_no, a.pol_sta, decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, \n"+
				" nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				" nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				" nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				" nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				" a.dem_dt, a.e_dem_dt, \n"+
				" e.gov_nm, "+
				" decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				" nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm, a.FILE_NAME, a.FILE_TYPE, a.FILE_NAME2, a.FILE_TYPE2 "+
				" from fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j , car_reg cr,  car_etc ce, car_nm cn \n"+
				" where\n"+
				" a.paid_amt > 0 and a.proxy_dt is not null  AND a.COLL_DT IS null  and (a.vio_cont like '%통행료%' or a.vio_cont like '%주차요금%' )"+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+)  \n"+
				" and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+			
				" and a.pol_sta=e.gov_id(+) "+
				" ";

	
		if(!m_id.equals(""))		query += " and a.rent_mng_id='"+m_id+"'";
		if(!l_cd.equals(""))		query += " and a.rent_l_cd='"+l_cd+"'";		
		if(!dem_dt.equals(""))		query += " and a.dem_dt ='"+dem_dt+"'";
		if(!e_dem_dt.equals(""))	query += " and a.e_dem_dt ='"+e_dem_dt+"'";

		query += " order by a.e_dem_dt, a.vio_dt";

//System.out.println("getFinePreDemList2: "+query);

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

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFinePreDemList2]\n"+e);
			System.out.println("[AddForfeitDatabase:getFinePreDemList2]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	

	// 선납과태료 메일내역 2012.11.15 rgs
	public Vector getFinePreDemList_sn( String m_id, String l_cd, String dem_dt, String e_dem_dt, String sort, String asc)throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
	
		query = " select /*+  merge(b) */ \n"+
				" nvl(g.cust_id,b.client_id) client_id, a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm, \n"+
				" cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, a.vio_pla, a.vio_cont, a.paid_no, a.pol_sta, decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, \n"+
				" nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				" nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				" nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				" nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				" a.dem_dt, a.e_dem_dt, \n"+
				" e.gov_nm, "+
				" decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				" nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm, a.FILE_NAME, a.FILE_TYPE, a.FILE_NAME2, a.FILE_TYPE2 "+
				" from fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j , car_reg cr,  car_etc ce, car_nm cn \n"+
				" where \n"+
				" a.paid_amt > 0  /* and a.proxy_dt is not null */ AND a.COLL_DT IS null  and (a.vio_cont like '%통행료%' or a.vio_cont like '%주차요금%' ) \n"+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)  \n"+
				" and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+) \n"+			
				" and a.pol_sta=e.gov_id(+) /* and a.e_dem_dt is null */ \n"+
				" ";

	
		if(!m_id.equals(""))		query += " and a.rent_mng_id='"+m_id+"' \n";
		if(!l_cd.equals(""))		query += " and a.rent_l_cd='"+l_cd+"' \n";		
		if(!dem_dt.equals(""))		query += " and a.dem_dt ='"+dem_dt+"' \n";
		if(!e_dem_dt.equals("")&&!e_dem_dt.equals("null")){	
			query += " and a.e_dem_dt ='"+e_dem_dt+"' \n";
		}else{
			query += " and a.e_dem_dt = TO_char(SYSDATE,'yyyymmdd') \n";
		}


//System.out.println("e_dem_dt="+e_dem_dt);
		query += " order by a.e_dem_dt, a.vio_dt";

//System.out.println("getFinePreDemList_sn: "+query);

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

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFinePreDemList_sn]\n"+e);
			System.out.println("[AddForfeitDatabase:getFinePreDemList_sn]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


	// 과태료 메일내역
	public Vector getFinePreDemList2_2( String m_id, String l_cd, String dem_dt, String e_dem_dt, String sort, String asc)throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
	
		query = " select /*+  merge(b) */ \n"+
				" nvl(g.cust_id,b.client_id) client_id, a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm, \n"+
				" cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, a.vio_pla, a.vio_cont, a.paid_no, a.pol_sta, decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, \n"+
				" nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				" nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				" nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				" nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				" a.dem_dt, a.e_dem_dt, \n"+
				" e.gov_nm, "+
				" decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				" nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm, a.FILE_NAME, a.FILE_TYPE, a.FILE_NAME2, a.FILE_TYPE2 "+
				" from fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j,  car_reg cr,  car_etc ce, car_nm cn \n"+
				" where\n"+
				" a.paid_amt > 0 "+
//				" and a.proxy_dt is not null  "+ //and (a.vio_cont like '%통행료%' or a.vio_cont like '%주차요금%' )
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)   \n"+
				" and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+			
				" and a.pol_sta=e.gov_id(+) "+
				" and a.paid_st = '1'";

	
		if(!m_id.equals(""))		query += " and a.rent_mng_id='"+m_id+"'";
		if(!l_cd.equals(""))		query += " and a.rent_l_cd='"+l_cd+"'";		
		if(!dem_dt.equals(""))		query += " and a.dem_dt ='"+dem_dt+"'";
		if(!e_dem_dt.equals(""))	query += " and a.e_dem_dt ='"+e_dem_dt+"'";

		query += " order by a.e_dem_dt, a.vio_dt";

//System.out.println("getFinePreDemList2_2: "+query);

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

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFinePreDemList2]\n"+e);
			System.out.println("[AddForfeitDatabase:getFinePreDemList2]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	// 과태료 메일내역
	public Vector getFinePreDemList2( String pack_id )throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
	
		query = " select /*+  merge(b) */ \n"+
				" nvl(g.cust_id,b.client_id) client_id, a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm, \n"+
				" cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, a.vio_pla, a.vio_cont, a.paid_no, a.pol_sta, decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, \n"+
				" nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				" nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				" nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				" nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				" a.dem_dt, a.e_dem_dt, \n"+
				" e.gov_nm, "+
				" decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				" nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm, a.FILE_NAME, a.FILE_TYPE, a.FILE_NAME2, a.FILE_TYPE2, b.bus_id2 "+
				" from ESTI_PACK c, fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j , car_reg cr,  car_etc ce, car_nm cn \n"+
				" where\n"+
				" c.pack_id='"+pack_id+"' and c.est_id=a.rent_mng_id||a.rent_l_cd||a.car_mng_id||a.seq_no "+
				" and a.paid_amt > 0 and a.proxy_dt is not null  and (a.vio_cont like '%통행료%' or a.vio_cont like '%주차요금%' )"+
				" and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+)   \n"+
				" and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+			
				" and a.pol_sta=e.gov_id(+) "+
				" ";

		query += " order by a.e_dem_dt, a.vio_dt";

//System.out.println("email: "+query);

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

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFinePreDemList2( String pack_id )]\n"+e);
			System.out.println("[AddForfeitDatabase:getFinePreDemList2( String pack_id )]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	 /**
     * 과태료/범칙금 - 일일 아마존카 대납관련  - 청구서 발생일 등록
     */
    public boolean updateForfeitPrintDemDt(String car_mng_id, String rent_mng_id, String rent_l_cd, int seq_no, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
     
        String query = "";
     
        boolean flag = true;
        String dem_dt = "";
                  
      		                
        query = " update fine set e_dem_dt = to_char(sysdate, 'yyyymmdd'), update_id = ? , update_dt=to_char(sysdate, 'yyyymmdd') "+
				" where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";
            
//System.out.println(query);         
       try{
            con.setAutoCommit(false);
                                 
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, user_id	);
            pstmt.setInt   (2, seq_no		);
            pstmt.setString(3, car_mng_id	);
            pstmt.setString(4, rent_mng_id	);
            pstmt.setString(5, rent_l_cd	);            
            pstmt.executeUpdate();             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:updateForfeitPrintDemDt]"+se);
				System.out.println("[AddForfeitDatabase:updateForfeitPrintDemDt]"+query);
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
    
    /**
     * 과태료/범칙금 - 일일 아마존카 대납관련  - 청구서 발생일 등록 및 메일 발송 완료 여부 플래그 변경
     */
    public boolean updateForfeitPrintDemDt2(String car_mng_id, String rent_mng_id, String rent_l_cd, int seq_no, String user_id) throws DatabaseException, DataSourceEmptyException{
    	Connection con = connMgr.getConnection(DATA_SOURCE);
    	
    	if(con == null)
    		throw new DataSourceEmptyException("Can't get Connection !!");
    	PreparedStatement pstmt = null;
    	
    	String query = "";
    	
    	boolean flag = true;
    	String dem_dt = "";
    	
    	
    	query = " update fine set e_dem_dt = to_char(sysdate, 'yyyymmdd'), update_id = ? , update_dt=to_char(sysdate, 'yyyymmdd'), email_cmplt_yn = 'Y' "+
    			" where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";
    	
//System.out.println(query);         
    	try{
    		con.setAutoCommit(false);
    		
    		pstmt = con.prepareStatement(query);            
    		pstmt.setString(1, user_id	);
    		pstmt.setInt   (2, seq_no		);
    		pstmt.setString(3, car_mng_id	);
    		pstmt.setString(4, rent_mng_id	);
    		pstmt.setString(5, rent_l_cd	);            
    		pstmt.executeUpdate();             
    		pstmt.close();
    		con.commit();
    		
    	}catch(SQLException se){
    		try{
    			System.out.println("[AddForfeitDatabase:updateForfeitPrintDemDt]"+se);
    			System.out.println("[AddForfeitDatabase:updateForfeitPrintDemDt]"+query);
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
    
    
    //과태료 리스트 조회 - 납부예정 - 수금이 되어도 납부가 안된건은 조회가 되어야 함.
	public Vector getFineExpPreListR2(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		
		String standard_dt = "decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt)";

		String query = "";
		query = " select /*+  merge(b) */ \n"+
				" a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm, ''  scan_file,\n"+
				" cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				" decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				" decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st,"+
				" a.pol_sta, decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				" nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				" nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				" nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				" nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				" nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt, a.e_dem_dt, \n"+
				" e.gov_nm, a.reg_dt,"+
				" decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				" nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm"+
				" from fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j , car_reg cr,  car_etc ce, car_nm cn \n"+
				" where\n"+
				" a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+)  \n"+
				" and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+
				" and a.paid_amt > 0 and a.pol_sta=e.gov_id(+) and (a.vio_cont not like '%통행료%' and a.vio_cont not like '%주차요금%')";

		/*상세조회&&세부조회*/

//	if(!gubun2.equals("5")){

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and substr(a.notice_dt,1,6) = to_char(SYSDATE, 'YYYYMM')";// and a.paid_st <> '2'
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr(a.notice_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is not null";// and a.paid_st <> '2'
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and substr(a.notice_dt,1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is null";// and a.paid_st <> '2'
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and a.notice_dt = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";// and a.paid_st <> '2'
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and a.notice_dt <= to_char(SYSDATE, 'YYYYMMDD') and (a.proxy_dt is null or a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and a.notice_dt <= to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and a.notice_dt <= to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and a.notice_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.notice_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and a.notice_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.proxy_dt is not null";
		//검색-미지출
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.proxy_dt is null";
		//접수일자
		}else if(gubun2.equals("7")){	query += " and a.rec_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		}
//	}

		if(gubun4.equals("2"))			query += " and a.fault_st='1'";
		else if(gubun4.equals("3"))		query += " and a.fault_st='2'";
		else if(gubun4.equals("4"))		query += " and a.paid_st='2'";
		else if(gubun4.equals("5"))		query += " and a.paid_st='3'";
		else if(gubun4.equals("6"))		query += " and a.paid_st='1'";
		else if(gubun4.equals("7"))		query += " and a.paid_st='4'";
		else if(gubun4.equals("8"))		query += " and a.paid_st<>'1'";
		

		/*검색조건*/
	if(!t_wd.equals("")){	
		if(s_kd.equals("2"))		query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '')||nvl(cr.first_car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and nvl(a.mng_id, nvl(b.mng_id,b.bus_id2))= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.pol_sta||e.gov_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("14"))	query += " and nvl(a.rec_dt, a.notice_dt) like '%"+t_wd+"%'\n";
		else if(s_kd.equals("15"))	query += " and nvl(a.vio_cont, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("20"))	query += " and nvl(a.proxy_est_dt, '') like '%"+t_wd+"%'\n";
		else						query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
	}

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.vio_dt "+sort+", a.paid_end_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.vio_dt, a.paid_end_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.proxy_dt "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.proxy_dt, b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("6"))	query += " order by e.gov_nm "+sort+", a.rec_dt, cr.car_no, b.firm_nm, a.paid_end_dt";

//System.out.println("[AddForfeitDatabase:getFineExpPreListR2]\n"+query);	

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineExpPreListR2]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineExpPreListR2]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
    
    /**
     * 과태료, 범칙금 한건 세부조회(String car_no, String vio_dt, int paid_amt).
     */
    public FineBean getForfeitCancelCar(String car_no, String vio_dt, int paid_amt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
		FineBean bean = new FineBean();
        Statement stmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = " select b.car_no, c.client_id, d.firm_nm, d.client_nm, e.car_id, g.car_nm, f.car_name, a.seq_no, a.car_mng_id,"+
				"        a.rent_mng_id, a.rent_l_cd, a.fine_st, a.call_nm, a.tel, a.fax,"+
				"        decode(a.vio_dt,null,'',substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분') as VIO_DT_VIEW,"+
				"        a.vio_dt, a.vio_pla, a.vio_cont, a.paid_st,"+
				"        decode(a.rec_dt,null,'',substr(a.rec_dt,1,4)||'-'||substr(a.rec_dt,5,2)||'-'||substr(a.rec_dt,7,2)) as REC_DT,"+
				"        decode(a.paid_end_dt,null,'',substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2)) as PAID_END_DT,"+
				"        a.paid_amt,a.paid_amt2, decode(a.proxy_dt,null,'',substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2)) as PROXY_DT,"+
				"        a.pol_sta, a.paid_no, a.fault_st, a.fault_nm, decode(a.dem_dt,null,'',substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2)) as DEM_DT,"+
				"        decode(a.coll_dt,null,'',substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2)) as COLL_DT,"+
				"        decode(a.rec_plan_dt,null,'',substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2)) as REC_PLAN_DT,"+
				"        decode(a.obj_dt1,null,'',substr(a.obj_dt1,1,4)||'-'||substr(a.obj_dt1,5,2)||'-'||substr(a.obj_dt1,7,2)) as obj_dt1,"+
				"        decode(a.obj_dt2,null,'',substr(a.obj_dt2,1,4)||'-'||substr(a.obj_dt2,5,2)||'-'||substr(a.obj_dt2,7,2)) as obj_dt2,"+
				"        decode(a.obj_dt3,null,'',substr(a.obj_dt3,1,4)||'-'||substr(a.obj_dt3,5,2)||'-'||substr(a.obj_dt3,7,2)) as obj_dt3,"+
				"        a.ext_dt,"+
				"        a.note, a.no_paid_yn, a.no_paid_cau, a.update_id, a.update_dt, a.bill_doc_yn, a.bill_mon, a.fault_amt, \n"+
				"        a.vat_yn, a.tax_yn, a.f_dem_dt, a.e_dem_dt, a.busi_st, a.rent_s_cd, a.notice_dt, a.obj_end_dt, a.mng_id, a.file_name, a.file_type, a.incom_dt, a.incom_seq, a.file_name2, a.file_type2, "+
				"        a.reg_id, a.rent_st, a.re_reg_id, a.re_reg_dt, a.vio_st \n"
				+ "from  fine a, car_reg b, car_change b2, cont c, client d, car_etc e, car_nm f, car_mng g\n"			
				+ "where a.vio_dt='" + vio_dt + "' and a.paid_amt=" + paid_amt + "  \n"
				+ "      and a.car_mng_id=b.car_mng_id\n"
				+ "      and a.car_mng_id=b2.car_mng_id\n"
				+ "      and b2.car_no='" + car_no + "'\n"
				+ "      and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "      and c.client_id = d.client_id\n"
				+ "      and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd\n"			
				+ "      and e.car_id = f.car_id(+) and e.car_seq=f.car_seq and f.car_comp_id=g.car_comp_id and f.car_cd=g.code\n"
				+ "      ";
       
        try{
           	stmt = con.createStatement();
            rs = stmt.executeQuery(query);
            if(rs.next()){                
				bean = makeFineBean(rs); 
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
    


	public Vector getForfeitSearchList(String vio_dt, String vio_pla1, String vio_pla2, String vio_pla3, String paid_amt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String t_wd = vio_pla1+""+vio_pla2+""+vio_pla3;
						
		String query = "";

		query = " select a.*, (a.paid_amt) ext_amt, c.car_no, c.car_nm, c.car_mng_id, nvl(h.ven_code,d.ven_code) ven_code, nvl(h.firm_nm,d.firm_nm) firm_nm "+
				" from   fine a, cont b, car_reg c, client d, rent_cont g, client h, cont j\n"+
				" where  a.paid_amt>0 \n";

		if(!vio_dt.equals(""))			query += " and a.vio_dt like '%"+vio_dt+"%'";

		if(!paid_amt.equals(""))		query += " and a.paid_amt='"+paid_amt+"'";

		if(!t_wd.equals(""))			query += " and a.vio_pla like '%"+vio_pla1+"%"+vio_pla2+"%"+vio_pla3+"%'";

		query += "       and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and b.car_mng_id=c.car_mng_id \n"+
				"        and b.client_id=d.client_id \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) "+
				"        and g.cust_id=h.client_id(+) "+
				"        and g.sub_l_cd=j.rent_l_cd(+) "+
				" ";



		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    
    			
    		//System.out.println(query);
    		 
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getForfeitSearchList]\n"+e);
			System.out.println("[AddForfeitDatabase:getForfeitSearchList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	//도로공사 환불건 조회  
	public Vector getForfeitSearchList(String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
								
		String query = "";

		query = " select a.*, (a.paid_amt) ext_amt, c.car_no, c.car_nm, c.car_mng_id, nvl(h.ven_code,d.ven_code) ven_code, nvl(h.firm_nm,d.firm_nm) firm_nm "+
				" from   fine a, cont b, car_reg c, client d, rent_cont g, client h, cont j\n"+
				" where  a.paid_amt>0 and a.note = '엑셀파일로 한꺼번에 등록후 환불' \n";

		if(!st_dt.equals(""))			query += " and a.coll_dt = replace('"+st_dt+"' , '-', '') ";	
					/*검색조건*/
		if(!t_wd.equals("")){	
			if(s_kd.equals("1"))		query += " and nvl(d.firm_nm, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("2"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";	
		}

		query += "       and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"        and b.car_mng_id=c.car_mng_id \n"+
				"        and b.client_id=d.client_id \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) "+
				"        and g.cust_id=h.client_id(+) "+
				"        and g.sub_l_cd=j.rent_l_cd(+) "+
				" ";

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.vio_dt "+sort+", a.paid_end_dt, d.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, d.firm_nm "+sort+", a.vio_dt, a.paid_end_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.coll_dt "+sort+", d.firm_nm, a.paid_end_dt";
		
		
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    
    			
    	//	System.out.println(query);
    		 
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getForfeitSearchList]\n"+e);
			System.out.println("[AddForfeitDatabase:getForfeitSearchList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}



		//과태료 청구예정리스트 조회 - 선납입현황
	public Vector getFineExpPreProxyList1(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String coll_yn,  String sort_gubun, String asc, String coll_yes) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		
		String standard_dt = "decode(nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')), '',a.paid_end_dt, nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')))";
				
		String query = "";
		query = " select /*+  merge(b) */ substr(k.OTIME,1,4)||'-'||substr(k.OTIME,5,2)||'-'||substr(k.OTIME,7,2) as RD_TIME, K.OTIME, \n"+
				" a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm,  b.client_nm, '' scan_file,\n"+
				" cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				" decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				" decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st,"+
				" a.pol_sta, decode(a.paid_amt2,'',a.paid_amt,0,a.paid_amt, a.paid_amt2) paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				" nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				" nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				" nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				" nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				" nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt,\n"+
				" nvl2(a.e_dem_dt,substr(a.e_dem_dt,1,4)||'-'||substr(a.e_dem_dt,5,2)||'-'||substr(a.e_dem_dt,7,2), '') e_dem_dt,\n"+
				" e.gov_nm,"+
				" decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				" nvl(decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm), '$$') cust_nm, a.fault_nm"+
				" from fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j, im_dmail_result_4 k ,  car_reg cr,  car_etc ce, car_nm cn \n"+
				" where\n"+
				" a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id=b.car_mng_id "+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and    ce.car_seq=cn.car_seq(+) \n"+
				" and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+) and a.DMIDX = k.DMIDX(+) "+
				" and a.paid_amt > 0 and a.pol_sta=e.gov_id(+) and (a.vio_cont like '%통행료%' or a.vio_cont like '%주차요금%' )";
  
		
		if(!coll_yn.equals("Y")){		 query += "and a.coll_dt is null";				}		
//System.out.println(coll_yes);	
		if(coll_yes.equals("Y")){		 query += "and a.coll_dt is not null";				}
		
		 /* gubun1 :proxy_dt 납입일자 */
		if(gubun2.equals("1"))			query += "  and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD') ";
		else if(gubun2.equals("2"))		query += "  and substr(a.proxy_dt,1,6) = to_char(SYSDATE, 'YYYYMM') ";
		else if(gubun2.equals("3"))		query += "  and a.proxy_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' ";
		else if(gubun2.equals("4"))		query += "  and a.proxy_dt is not null ";
		else if(gubun2.equals("5"))		query += "  and substr(a.proxy_dt,1,6) = to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";
		
		if(gubun4.equals("2"))			query += " and a.fault_st='1'";
		else if(gubun4.equals("3"))		query += " and a.fault_st='2'";
		else if(gubun4.equals("4"))		query += " and a.paid_st='2'";
		else if(gubun4.equals("5"))		query += " and a.paid_st='3'";
		else if(gubun4.equals("6"))		query += " and a.paid_st='1'";
		else if(gubun4.equals("7"))		query += " and a.paid_st='4'";
		else if(gubun4.equals("8"))		query += " and a.paid_st<>'1'";
		

		/*검색조건*/
		if(!t_wd.equals("")){	
			if(s_kd.equals("2"))		query += " and nvl(cr.car_no, '')||nvl(cr.first_car_no, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("5"))	query += " and a.paid_amt like '%"+t_wd+"%'\n";
			else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("8"))	query += " and nvl(a.mng_id, nvl(b.mng_id,b.bus_id2))= '"+t_wd+"'\n";
			else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
			else if(s_kd.equals("10"))	query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("11"))	query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("12"))	query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
			else if(s_kd.equals("3"))	query += " and a.pol_sta||e.gov_nm like '%"+t_wd+"%'\n";
			else if(s_kd.equals("14"))	query += " and nvl(a.rec_dt, '') like '%"+t_wd+"%'\n";
			else if(s_kd.equals("15"))	query += " and nvl(a.vio_cont, '') like '%"+t_wd+"%'\n";
			else						query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		}
		

		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.vio_dt "+sort+", a.paid_end_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, a.e_dem_dt desc , b.firm_nm "+sort+", a.proxy_dt, a.vio_dt, a.paid_end_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.proxy_dt "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.proxy_dt, b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("6"))	query += " order by b.use_yn desc, e.gov_nm "+sort+", a.rec_dt, cr.car_no, b.firm_nm, a.paid_end_dt";

//System.out.println(query);	

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineExpPreProxyList1]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineExpPreProxyList1]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	//과태료 리스트 조회(수금현황)
	public Vector getClientFineList(String client_id, String bus_id2) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = "";
		query = " select /*+  merge(b) */ \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd,  b.firm_nm, b.client_nm, '' scan_file,\n"+
				"        cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, decode(a.coll_dt, '','미수금','수금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3', '외부업체과실') fault_st, a.fault_nm, a.vio_pla, a.vio_cont, a.dly_days,\n"+
				"        decode(a.fault_st, '1', a.paid_amt, '2', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt), '3', decode(nvl(a.fault_amt,0), 0, a.paid_amt, a.fault_amt)) paid_amt,"+
				"        b.use_yn, b.mng_id, b.rent_st, decode(a.paid_st, '2','고객납입','3','회사대납','1','납부자변경','4','수금납입','미정') paid_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2),'') vio_dt, a.vio_dt as vio_dt2, \n"+
				"        nvl2(a.rec_plan_dt,substr(a.rec_plan_dt,1,4)||'-'||substr(a.rec_plan_dt,5,2)||'-'||substr(a.rec_plan_dt,7,2),'') rec_plan_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt,\n"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm) cust_nm,"+
				"        decode(a.rent_s_cd,'',b.bus_id2,decode(g.rent_st,'2',j.bus_id2,'3',j.bus_id2,'1',g.bus_id,'4',g.cust_id,'5',g.cust_id)) bus_id2, a.mng_id as fine_mng_id, "+
				"        a.file_name, a.file_name2, a.file_type, a.file_type2, c.gov_nm, nvl(a.reg_dt,a.update_dt) reg_dt, b.use_yn, cc.cls_dt, cc.cls_st, a.note  "+
				" from   fine a, cont_n_view b, rent_cont g, client h, users i, cont j, fine_gov c , car_reg cr,  car_etc ce, car_nm cn, cls_cont cc \n"+
				" where  \n"+
				"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and  ce.car_seq=cn.car_seq(+)  \n"+
                       		"	and a.rent_mng_id = cc.rent_mng_id(+)  and a.rent_l_cd = cc.rent_l_cd(+)  \n"+
				"        and decode(g.cust_st,'1',h.client_id,'4','',b.client_id)='"+client_id+"' and a.coll_dt is null and a.fault_st='1' "+//미수 고객과실
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.sub_l_cd=j.rent_l_cd(+) and a.pol_sta=c.gov_id"+
				"        and a.paid_amt > 0 and nvl(a.no_paid_yn,'N') <> 'Y' and a.paid_st in ('3','4') and decode(a.fault_st,'2','Y',nvl(a.bill_yn,'Y'))='Y'"+
				" ";

		/*정렬조건*/
		query += " order by a.vio_dt";
	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
	    	//System.out.println(query);
	    	
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getClientFineList]\n"+e);
			System.out.println("[AddForfeitDatabase:getClientFineList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return vt;
		}
	}

    /**
     * 할부 첨부파일 수정
     */
    public int updateLendBankFileName(String alt_st, String lend_id, String file_name, String file_type) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0; 		
 		              
		if(alt_st.equals("allot")){
	        query = " update allot		set FILE_NAME=?, FILE_TYPE=? "+
					" where rent_l_cd=? ";
		}else{
	        query = " update lend_bank	set FILE_NAME=?, FILE_TYPE=? "+
					" where lend_id=? ";
		}
         
       try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, file_name	);
            pstmt.setString(2, file_type	);
            pstmt.setString(3, lend_id	);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:updateLendBankFileName]"+se);
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

	//과태료등록시 계약조회
	public Vector getFineSearchContList(String car_no, String vio_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT \n"+
				"        a.car_mng_id, a.car_no, a.CAR_NM, \n"+
				"        DECODE(a.car_no,a.first_car_no,'',a.first_car_no) cng_car_no,  \n"+
				"        c.use_yn, DECODE(c.use_yn,'N','해지','Y','대여','미결') use_yn_nm,  \n"+
				"        0 scan_cnt2, \n"+
				"        c.rent_mng_id, c.rent_l_cd, c.car_st, DECODE(e.rent_st,'1',c.rent_dt,e.rent_dt) rent_dt,  \n"+
				"        d.firm_nm, \n"+
				"        f.car_deli_dt, \n"+
				"        e.fee_st, e.rent_st, e.rent_start_dt, e.rent_end_dt, \n"+
				"        i.reco_dt, g.cls_dt, g2.cls_dt as est_cls_dt, \n"+
				"        NVL(f.rent_suc_dt,h.cls_dt) rent_suc_dt, decode(h.cls_st,'4','차종변경','5','계약승계') cng_cls_st_nm, \n"+
				"        DECODE(e.rent_st,'1',NVL(f.car_deli_dt,DECODE(c.car_st,'2',NVL(c.rent_start_dt,c.reg_dt),e.rent_start_dt)),e.rent_start_dt) deli_dt, \n"+
				"        NVL(i.reco_dt,NVL(g.cls_dt,e.rent_end_dt)) ret_dt, \n"+
				"        decode(g.cls_st,'6','매각','8','매입옵션','') cls_st, \n"+
				"        decode(g.cls_st,'6',j.migr_dt,'8',j.migr_dt,'') migr_dt, \n"+
				"        decode(g.cls_st,'6',j.cont_dt,'8',j.cont_dt,'') cont_dt, decode(a.prepare,'9','장기미회수') prepare_nm, \n"+
				"        decode(l.rent_st,'4',l.cust_id,c.mng_id) as mng_id \n"+
				" FROM   (SELECT * FROM car_reg where car_mng_id IN (SELECT car_mng_id FROM car_change WHERE car_no = '"+car_no+"' GROUP BY car_mng_id)) a,  \n"+
	//			" FROM   (SELECT * FROM car_reg where car_mng_id IN (SELECT car_mng_id FROM car_change WHERE car_no LIKE '%"+car_no+"%' GROUP BY car_mng_id)) a,  \n"+
				"        CONT c, CLIENT d, \n"+

				"        (SELECT DECODE(a.rent_st,'1','신규','연장') AS fee_st, a.rent_mng_id, a.rent_l_cd, a.rent_st, "+
				"	             min(a.rent_dt) rent_dt, MIN(a.rent_start_dt) rent_start_dt, MAX(NVL(b.rent_end_dt,a.rent_end_dt)) rent_end_dt \n"+
				"         FROM   fee a, fee_im b  \n"+
				"         WHERE  a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+) AND a.RENT_ST=b.rent_st(+) \n"+
				"         GROUP BY a.rent_mng_id, a.rent_l_cd, a.rent_st \n"+
				"        ) e, \n"+

                "        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) e2, "+
				"        CONT_ETC f, \n"+
				"        CLS_CONT g, cls_etc g2,\n"+
				"        (SELECT rent_mng_id, rent_l_cd, cls_st, cls_dt, reg_dt FROM CLS_CONT WHERE cls_st IN ('4','5')) h, \n"+
				"        car_reco i, sui j, cont k, rent_cont l \n"+
				" WHERE  a.car_mng_id=c.car_mng_id \n"+
				"        AND c.client_id=d.client_id \n"+
				"        AND c.rent_mng_id=e.rent_mng_id AND c.rent_l_cd=e.rent_l_cd \n"+
				"        AND c.rent_mng_id=e2.rent_mng_id AND c.rent_l_cd=e2.rent_l_cd \n"+
				"        AND c.rent_mng_id=f.rent_mng_id(+) AND c.rent_l_cd=f.rent_l_cd(+) \n"+
				"        AND c.rent_mng_id=g.rent_mng_id(+) AND c.rent_l_cd=g.rent_l_cd(+) \n"+
				"        AND c.rent_mng_id=g2.rent_mng_id(+) AND c.rent_l_cd=g2.rent_l_cd(+) \n"+
				"        AND c.rent_mng_id=h.rent_mng_id(+) AND c.reg_dt=h.reg_dt(+) \n"+
				"        AND c.rent_mng_id=i.rent_mng_id(+) AND c.rent_l_cd=i.rent_l_cd(+) \n"+
				"        AND a.car_mng_id=j.car_mng_id(+) \n"+
				"        AND c.car_mng_id=k.car_mng_id(+) AND c.rent_end_dt=k.reg_dt(+) \n"+
				"        and k.car_mng_id = l.car_mng_id(+) \n"+
				" ";


		if(!vio_dt.equals("")) query += " and replace('"+vio_dt+"','-','') between decode(f.rent_suc_dt,'',DECODE(c.car_st,'2',NVL(c.rent_start_dt,c.reg_dt),DECODE(e.rent_st,'1',NVL(f.car_deli_dt,e.rent_start_dt),e.rent_start_dt)),decode(f.suc_rent_st,e.rent_st,nvl(f.car_deli_dt,f.rent_suc_dt),e.rent_start_dt)) "+
                                        "                                  AND CASE when a.prepare='9' then TO_CHAR(SYSDATE+30,'YYYYMMDD') "+
				                                                                  " when c.use_yn='Y' AND c.car_st='2' THEN TO_CHAR(SYSDATE,'YYYYMMDD') "+
                                                                                  " WHEN c.use_yn='N' AND c.car_st='2' and nvl(nvl(g.cls_st,g2.cls_st),'0') not in ('6') AND k.rent_start_dt IS NULL THEN nvl(c.rent_end_dt,nvl(g.cls_dt,g2.cls_dt)) "+
				                                                                  " WHEN c.use_yn='N' AND c.car_st='2' and nvl(nvl(g.cls_st,g2.cls_st),'0') not in ('6') AND k.rent_start_dt IS not NULL THEN k.rent_start_dt "+
                                                                                  " WHEN nvl(g.cls_st,g2.cls_st) in ('6','8') then nvl(j.migr_dt,to_char(sysdate,'YYYYMMDD')) "+
				                                                                  " WHEN e.rent_st=e2.rent_st THEN NVL(nvl(i.reco_dt,nvl(g.cls_dt,g2.cls_dt)),e.rent_end_dt) "+
                                                                                  " ELSE e.rent_end_dt END ";

		query += " ORDER BY c.use_yn DESC, c.reg_dt DESC, e.rent_end_dt desc ";



		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
	    	
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineSearchContList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineSearchContList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return vt;
		}
	}

	//과태료등록시 계약조회
	public Vector getFineSearchSContList(String car_no, String vio_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = "";
		query = " SELECT /*+ RULE */  \n"+ 
				"        a.car_mng_id, a.car_no, a.CAR_NM,  \n"+ 
				"        DECODE(a.car_no,b.car_no,'',b.car_no) cng_car_no,  \n"+            
				"        e.rent_s_cd, e.cust_id, e.sub_l_cd, e.sub_c_id, e.rent_dt,  \n"+  
				"        DECODE(e.cust_st,'4',f.user_nm,d.firm_nm) firm_nm,  \n"+ 
				"        decode(e.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무지원','6','차량정비','7','차량점검','8','사고수리','11','장기대기','12','월렌트', '-') rent_st_nm, \n"+ 
				"        decode(e.use_st,'2','배차','3','반차','4','종료') use_st_nm, \n"+
				"        e.deli_dt, e.ret_dt  \n"+                   
				" FROM   CAR_REG a,  \n"+  
				"        (SELECT car_mng_id, car_no FROM CAR_CHANGE GROUP BY car_mng_id, car_no) b,   \n"+ 
				"        rent_cont e, CLIENT d, USERS f  \n"+ 
				" WHERE  a.car_mng_id=b.car_mng_id   \n"+ 
				"        AND a.car_no||' '||b.car_no LIKE '%"+car_no+"%'  \n"+         
				"        AND a.car_mng_id=e.car_mng_id \n"+ 
				"        AND e.use_st IN ('2','3','4') \n"+ 
				"        AND e.cust_id=d.client_id(+) \n"+ 
				"        AND e.cust_id=f.user_id(+)    \n"+
				" ";

		if(!vio_dt.equals("")) query += " and replace('"+vio_dt+"','-','') between e.deli_dt and nvl(e.ret_dt,to_char(sysdate,'YYYYMMDD'))";

		query += " ORDER BY decode(e.use_st,'2',0,1), e.deli_dt desc  ";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
	    	//System.out.println(query);
	    	
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineSearchSContList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineSearchSContList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return vt;
		}
	}



	//과태료 리스트 조회(지출현황)
	public Vector getSFineList(String reg_id, String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
			//String standard_dt = "decode(a.dem_dt, '',a.paid_end_dt, a.dem_dt)";
		String standard_dt = "decode(nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')), '',a.paid_end_dt, nvl(a.dem_dt, to_char(sysdate, 'yyyymmdd')))";
		String s_query = "";
		if(s_kd.equals("16")){
			s_query = " , (select user_id, user_nm from users where user_nm like '"+t_wd+"%') k";
		}		
		String query = "";
		query = " select /*+  no_merge(b) */ \n"+
				"        a.car_mng_id, a.seq_no, a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.client_nm, '' scan_file,\n"+
				"        cr.car_no, cr.first_car_no, cr.car_nm, cn.car_name, decode(a.proxy_dt,'',decode(a.paid_st,'2','고객납입','1','-','미출금'),'출금') gubun,\n"+
				"        decode(a.fault_st, '1','고객과실', '2','업무상과실', '3','외부업체과실') fault_st, a.vio_pla, a.vio_cont, a.paid_no, "+
				"        decode(a.paid_st, '1','납부자변경','2','고객납입','3','회사대납','4','수금납입') paid_st, \n"+
				"        a.pol_sta, a.paid_amt, b.use_yn, nvl(a.mng_id, nvl(b.mng_id,b.bus_id2)) mng_id, b.rent_st,\n"+
				"        nvl2(a.vio_dt,substr(a.vio_dt,1,4)||'-'||substr(a.vio_dt,5,2)||'-'||substr(a.vio_dt,7,2)||' '||substr(a.vio_dt,9,2)||'시'||substr(a.vio_dt,11,2)||'분','') vio_dt,\n"+
				"        nvl2(a.paid_end_dt,substr(a.paid_end_dt,1,4)||'-'||substr(a.paid_end_dt,5,2)||'-'||substr(a.paid_end_dt,7,2),'') paid_end_dt,\n"+
				"        nvl2(a.proxy_dt,substr(a.proxy_dt,1,4)||'-'||substr(a.proxy_dt,5,2)||'-'||substr(a.proxy_dt,7,2),'') proxy_dt,\n"+
				"        nvl2(a.coll_dt,substr(a.coll_dt,1,4)||'-'||substr(a.coll_dt,5,2)||'-'||substr(a.coll_dt,7,2),'') coll_dt,\n"+
				"        nvl2(a.dem_dt,substr(a.dem_dt,1,4)||'-'||substr(a.dem_dt,5,2)||'-'||substr(a.dem_dt,7,2),'') dem_dt, e.gov_nm, \n"+
				"        decode(g.rent_st,'1','단기대여','2','정비대차','3','사고대차','9','보험대차','10','지연대차','4','업무대여','5','업무대여','6','차량정비','7','차량정비','8','사고수리','11','예약대기','12','월렌트') res_st,"+
				"        decode(g.cust_st,'1',h.firm_nm, '4',i.user_nm, j.cust_nm) cust_nm, a.fault_nm \n"+
				" from   fine a, cont_n_view b, fine_gov e, rent_cont g, client h, users i, rent_cust j,  car_reg cr,  car_etc ce, car_nm cn  "+s_query+"\n"+
				" where\n"+
				"        a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"+
				"	and a.car_mng_id = cr.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"+
                       		"	and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+)  \n"+
				"        and a.rent_s_cd=g.rent_s_cd(+) and g.cust_id=h.client_id(+) and g.cust_id=i.user_id(+) and g.cust_id=j.cust_id(+)"+
				"        and a.paid_amt > 0 and a.pol_sta=e.gov_id(+)";

		/*상세조회&&세부조회*/

		if(gubun1.equals("1"))		query += " and a.reg_id in ('000058','000155') ";
		else if(gubun1.equals("2") || gubun1.equals("3"))	query += " and a.reg_id in ('000121','000056', '000107')  ";
		else						query += " ";

//	if(!gubun2.equals("5")){

		//당월-계획
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM')";// and a.paid_st <> '2'
		//당월-수금
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is not null";// and a.paid_st <> '2'
		//당월-미수금
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and substr("+standard_dt+",1,6) = to_char(SYSDATE, 'YYYYMM') and a.proxy_dt is null";// and a.paid_st <> '2'
		//당일-계획
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-수금
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";// and a.paid_st <> '2'
		//당일-미수금
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and "+standard_dt+" = to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";// and a.paid_st <> '2'
		//당일+연체-계획
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and (a.proxy_dt is null or a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD'))";
		//당일+연체-수금
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt = to_char(SYSDATE, 'YYYYMMDD')";
		//당일+연체-미수금
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and "+standard_dt+" <= to_char(SYSDATE, 'YYYYMMDD') and a.proxy_dt is null";
		//기간-계획
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//기간-수금
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is not null";
		//기간-미수금
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and "+standard_dt+" BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.proxy_dt is null";
		//검색-수금
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.proxy_dt is not null";
		//검색-미지출
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.proxy_dt is null";
		//접수일자
		}else if(gubun2.equals("7")){	query += " and a.rec_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		}
//	}

		if(gubun4.equals("2"))			query += " and a.fault_st='1'";
		else if(gubun4.equals("3"))		query += " and a.fault_st='2'";
		else if(gubun4.equals("4"))		query += " and a.paid_st='2'";
		else if(gubun4.equals("5"))		query += " and a.paid_st='3'";
		else if(gubun4.equals("6"))		query += " and a.paid_st='1'";
		else if(gubun4.equals("7"))		query += " and a.paid_st='4'";
		else if(gubun4.equals("8"))		query += " and a.paid_st<>'1'";
		else if(gubun4.equals("9"))		query += " and a.fault_st='3'";
		else							query += "                     ";
		

		/*검색조건*/
	if(!t_wd.equals("")){	
		if(s_kd.equals("2"))		query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(cr.car_no, '')||nvl(cr.first_car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.paid_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and nvl(a.mng_id, nvl(b.mng_id,b.bus_id2))= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and cr.car_nm||cn.car_name like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.vio_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(a.vio_pla, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.paid_no) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.pol_sta||e.gov_nm like '%"+t_wd+"%'\n";
		else if(s_kd.equals("14"))	query += " and nvl(a.rec_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("15"))	query += " and nvl(a.vio_cont, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("16"))	query += "  and a.FAULT_NM = k.user_id ";
		else						query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
	}


		//검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0")?" asc":" desc";

		/*정렬조건*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.vio_dt "+sort+", a.paid_end_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.vio_dt, a.paid_end_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, a.proxy_dt "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.paid_amt "+sort+", a.proxy_dt, b.firm_nm, a.paid_end_dt";
//		else if(sort_gubun.equals("4"))	query += " order by b.use_yn desc, dly_day "+sort+", rc_dt, firm_nm, fee_est_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, cr.car_no "+sort+", b.firm_nm, a.paid_end_dt";
		else if(sort_gubun.equals("6"))	query += " order by e.gov_nm "+sort+", a.rec_dt, cr.car_no, b.firm_nm, a.paid_end_dt";



//System.out.println("getSFineList: "+query);
	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getSFineList]\n"+e);
			System.out.println("[AddForfeitDatabase:getSFineList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}


	/**
     * 과태료 최초 등록시 메일보낼 seq_no 값 가져오기 
     */

public Hashtable getForfeitSeq_no(String car_mng_id, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select car_mng_id, rent_mng_id, rent_l_cd, max(seq_no) as seq_no from fine where car_mng_id='" + car_mng_id + "' and rent_mng_id='" + rent_mng_id + "' and rent_l_cd='" + rent_l_cd + "'  GROUP BY  car_mng_id, rent_mng_id, rent_l_cd ";
	
//System.out.println(query);

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
			System.out.println("[AddForfeitDatabase:getForfeitSeq_no]\n"+e);
			System.out.println("[AddForfeitDatabase:getForfeitSeq_no]\n"+query);
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



/**
     * 인천과태료 등록시 중복체크
     */
    public int getFineCheck(String car_mng_id, String vio_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
		ResultSet rs = null;
        String query = "";
        int count = 0; 		
 		                
        query = " select count(0) from fine  "+
				" where  car_mng_id=? and vio_dt=replace(?,'-','') and paid_st = '1' ";


	   try{
            con.setAutoCommit(false);
           
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, car_mng_id		);
            pstmt.setString(2, vio_dt.trim()	);
            rs = pstmt.executeQuery();
            if(rs.next()){                
				count = rs.getInt(1);
            }

			rs.close();
			pstmt.close(); 

            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:getFineCheck]"+se);
				System.out.println("[AddForfeitDatabase:getFineCheck]"+query);
				con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	public String getFineSearchRentst(String ch_m_id, String ch_l_cd, String ch_vio_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		String rent_st = "";
		String query = "";

		query = " select decode(a.car_st,'4','1',b.rent_st) rent_st \n"+
				" from   cont a, fee b, cls_cont c, cls_etc c2, sui g, cont_etc h, car_reco i, taecha e, car_reg j, "+
				"        (select max(to_number(rent_st)) rent_st from fee where rent_mng_id = '"+ch_m_id+"' and rent_l_cd = '"+ch_l_cd+"') d, \n"+
				"        (select rent_st, max(use_e_dt) use_e_dt from scd_fee where rent_mng_id = '"+ch_m_id+"' and rent_l_cd = '"+ch_l_cd+"' and bill_yn='Y' GROUP BY rent_st) f \n"+
				" where \n"+
				"        a.rent_mng_id = '"+ch_m_id+"' and a.rent_l_cd = '"+ch_l_cd+"' and a.car_st<>'2'  \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd   \n"+
				"        and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=c2.rent_mng_id(+) and a.rent_l_cd=c2.rent_l_cd(+) \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd   \n"+
				"        and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.no,'0')='0' \n"+
				"        and a.car_mng_id=j.car_mng_id \n"+
			    "        AND b.RENT_ST=f.rent_st(+) \n"+
				"        and substr('"+ch_vio_dt+"',1,8) between decode(h.rent_suc_dt,'',decode(b.rent_st,'1',decode(e.car_mng_id,'',b.rent_start_dt,e.car_rent_st),b.rent_start_dt),decode(h.suc_rent_st,b.rent_st,nvl(h.car_deli_dt,h.rent_suc_dt),b.rent_start_dt)) "+
				"            and case when j.prepare='9' then to_char(sysdate+30,'YYYYMMDD') "+
                "                     when a.car_st='4' AND nvl(c.cls_dt,c2.cls_dt) IS NULL then f.use_e_dt "+
                "                     when a.car_st='4' AND nvl(c.cls_dt,c2.cls_dt) IS NOT NULL then nvl(i.reco_dt,nvl(c.cls_dt,c2.cls_dt)) "+
				"				      when b.rent_st=d.rent_st and nvl(c.cls_dt,c2.cls_dt) is null then '99999999' "+
				"                     when b.rent_st=d.rent_st and nvl(c.cls_dt,c2.cls_dt) is not null and nvl(c.cls_st,c2.cls_st) in ('6','8')  then NVL(g.migr_dt,to_char(sysdate,'YYYYMMDD')) "+
				"                     when b.rent_st=d.rent_st and nvl(c.cls_dt,c2.cls_dt) is not null and nvl(c.cls_st,c2.cls_st) not in ('6','8') then nvl(i.reco_dt,nvl(c.cls_dt,c2.cls_dt)) "+
				"                     when b.rent_st<d.rent_st AND b.rent_end_dt >= f.use_e_dt then b.rent_end_dt "+
				"                     when b.rent_st<d.rent_st AND b.rent_end_dt < f.use_e_dt then f.use_e_dt "+
			    "                end "+
				" union all "+
				" SELECT '1' rent_st  "+
				" FROM   cont a, rent_cont b "+
				" WHERE  a.rent_mng_id='"+ch_m_id+"' AND a.rent_l_cd='"+ch_l_cd+"' and a.car_st='2' "+
				"        AND a.car_mng_id=b.car_mng_id AND b.use_st IN ('2','3','4') "+
				"        AND substr('"+ch_vio_dt+"',1,8) BETWEEN SUBSTR(deli_dt,1,8) AND SUBSTR(NVL(nvl(ret_dt,ret_plan_dt),TO_CHAR(SYSDATE,'YYYYMMDD')),1,8) "+
				" ";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{				
				rent_st = rs.getString(1);		
			}
			rs.close();
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineSearchRentst]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineSearchRentst]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return rent_st;
	}


	 /**
     * 과태료/범칙금 - 중복처리분
     */
    public boolean updateForfeitReReg(String car_mng_id, int seq_no, String re_reg_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";     
        boolean flag = true;
      		                
        query = " update fine set re_reg_dt = to_char(sysdate, 'yyyymmdd'), re_reg_id = ? "+
				" where seq_no=? and car_mng_id=? ";
            
       try{
            con.setAutoCommit(false);
                                 
            pstmt = con.prepareStatement(query);            
            pstmt.setString(1, re_reg_id	);
            pstmt.setInt   (2, seq_no		);
            pstmt.setString(3, car_mng_id	);
            pstmt.executeUpdate();             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:updateForfeitReReg]"+se);
				System.out.println("[AddForfeitDatabase:updateForfeitReReg]"+query);
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

	public Vector getFineCheckList(String car_mng_id, String vio_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " select * from fine  "+
				" where  car_mng_id='"+car_mng_id+"' and vio_dt=regexp_replace('"+vio_dt+"','[^0-9]') and paid_st = '1' order by seq_no desc";
	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineCheckList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineCheckList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}
	
	public Vector getFineCheckList2(String car_mng_id, String vio_dt) throws DatabaseException, DataSourceEmptyException
	{
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
			throw new DataSourceEmptyException("Can't get Connection !!");
		
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select * from fine  "+
				" where  car_mng_id='"+car_mng_id+"' and substr(vio_dt,1,11) = SUBSTR(REPLACE(trim(REPLACE(replace('"+vio_dt+"','-',''),':','')),' ',''),1,11) and paid_st = '1' order by seq_no desc";
		
		try {
			stmt = con.createStatement();
//			System.out.println(query);
			rs = stmt.executeQuery(query);
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
			stmt.close();
			
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineCheckList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineCheckList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
		
	}

	public Vector getFineRegConsList(String st, String car_mng_id, String vio_dt) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(st.equals("cons_oksms")){

			query = " SELECT a.rent_l_cd, d.firm_nm, e.car_no, e.car_nm, a.from_comp, a.from_dt, a.to_comp, a.to_dt, b.reg_dt, start_dt, end_dt \n"+
					" FROM   consignment a, CONS_OKSMS b, cont c, client d, car_reg e \n"+ 
					" where  nvl(a.car_mng_id,c.car_mng_id)='"+car_mng_id+"' \n"+ 
					"        AND a.cons_no = b.CONS_NO AND a.SEQ = b.SEQ AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd \n"+
					"        AND nvl(a.client_id,c.client_id)=d.client_id \n"+ 
					"        AND nvl(a.car_mng_id,c.car_mng_id)=e.car_mng_id \n"+
					"        AND a.reg_dt BETWEEN TO_CHAR(TO_DATE('"+vio_dt+"','YYYYMMDD')-30,'YYYYMMDD')  AND  TO_CHAR(TO_DATE('"+vio_dt+"','YYYYMMDD')+30,'YYYYMMDD') \n"+
					" ORDER BY a.from_dt, a.reg_dt ";

		}else{	

			query = " SELECT a.rent_l_cd, d.firm_nm, e.car_no, e.car_nm, a.from_comp, a.from_dt, a.to_comp, a.to_dt, b.content, b.upd_ymd, b.upd_time \n"+  
					" FROM   CONSIGNMENT a, alink.TMSG_QUEUE b, cont c, client d, car_reg e \n"+  
					" WHERE  nvl(a.car_mng_id,c.car_mng_id)='"+car_mng_id+"' \n"+ 
					"        AND a.CONS_NO||a.seq = b.LINK_KEY \n"+ 
					" 		 AND b.TMSG_TYPE ='2' \n"+
					"        AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd \n"+
					"        AND nvl(a.client_id,c.client_id)=d.client_id \n"+ 
					"        AND nvl(a.car_mng_id,c.car_mng_id)=e.car_mng_id \n"+
					"        AND b.upd_ymd BETWEEN TO_CHAR(TO_DATE('"+vio_dt+"','YYYYMMDD')-30,'YYYYMMDD')  AND  TO_CHAR(TO_DATE('"+vio_dt+"','YYYYMMDD')+30,'YYYYMMDD') \n"+
					" ORDER BY a.from_dt, a.reg_dt ";
		}
	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineRegConsList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineRegConsList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}
	
	//협력업체 과태료관리 리스트(20190902)
	public Vector getFineOffList(String s_kd, String t_wd, String gubun1, String gubun2, String s_dt, String e_dt, String user_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String date = "";
		
		query += 	" SELECT a.fault_nm, a.car_mng_id, a.paid_end_dt, a.proxy_dt, a.rent_l_cd, a.rent_mng_id, a.seq_no, \n " +
						"			   b.car_no, b.car_nm, \n "+
						"			   TO_CHAR(TO_date(a.vio_dt, 'YYYYMMDDhh24mi'),'YYYY-MM-DD hh24:mi') AS vio_dt \n "+
				   	   	"	 FROM fine a, car_reg b \n "+
				   	   	"	 WHERE a.car_mng_id = b.car_mng_id \n "+
				   	   	"		  AND a.fault_st = '3' ";
		
		if(!s_kd.equals("") && !t_wd.equals("")){
			if(s_kd.equals("1")){			query += "	AND a.fault_nm like '%" +t_wd+ "%' ";		}
			else if(s_kd.equals("2")){	query += "	AND b.car_no like '%" +t_wd+ "%' ";			}
			else if(s_kd.equals("3")){	query += "	AND b.car_nm like '%" +t_wd+ "%' ";			}
		}
		
		if(!gubun1.equals("") && (!s_dt.equals("") || !e_dt.equals(""))){
			if(gubun1.equals("1")){			date = "SUBSTR(a.vio_dt,0,8)";				}
			else if(gubun1.equals("2")){	date = "a.paid_end_dt";	}
			else if(gubun1.equals("3")){	date = "a.proxy_dt";			}
			query +=	"	AND "+date+" BETWEEN '"+s_dt+"' AND '"+e_dt+"' ";
		}
		
		//협력업체는 본인것만 확인가능
		if(!user_nm.equals("")){		query += "	AND a.fault_nm like '%" +user_nm+ "%' ";		}
		
		query +=	"	 ORDER BY decode(a.proxy_dt,'','1','2'), a.vio_dt desc ";	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineOffList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineOffList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	//협력업체 과태료관리 리스트- 탁송건 조회(20190902)
	public Vector getFineOffConsList(String rent_l_cd, String rent_mng_id, String vio_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query += 	" SELECT a.reg_dt, c.user_nm, a.from_place, a.to_place \n "+
				   	   	"	 FROM consignment a, cons_oksms b, users c \n "+
				   	   	"	 WHERE a.cons_no = b.cons_no(+) AND a.seq = b.seq(+) \n "+
				   	   	"		  AND a.reg_id = c.user_id \n"+
				   	   	"	 	  AND a.rent_L_cd = '"+ rent_l_cd +"' AND a.rent_mng_id = '"+ rent_mng_id +"' \n "+
				   	   	"		  AND '"+ vio_dt +"' BETWEEN NVL(b.start_dt,'200000000000') AND NVL(b.end_dt,'999999999999') ";
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineOffConsList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineOffConsList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	//납부일자 수정(20190909)
	public boolean updateFineProxy_dt(String m_id, String l_cd, String c_id, String seq_no, String proxy_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update fine set\n"+
					" proxy_dt='"+proxy_dt.replaceAll("-","")+"'"+
					" where\n"+
					" rent_mng_id = '"+m_id+"'"+
					" and rent_l_cd = '"+l_cd+"'"+
					" and car_mng_id = '"+c_id+"'"+
					" and seq_no = '"+seq_no+"'";
		try {
			con.setAutoCommit(false);
			pstmt = con.prepareStatement(query);           
		    pstmt.executeUpdate();
		    pstmt.close();
		    con.commit();
	    }catch(SQLException se){
            try{
				System.out.println("[AddForfeitDatabase:updateFineProxy_dt]"+se);
				con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");	
		} finally {
			try{
				 con.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
			return flag;
		}
	}
	
	public Vector getFineTempList(String paid_no) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " select * from fine_temp2  "+
				" where  paid_no='"+paid_no+"'";
	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineCheckList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineCheckList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}
	
	public Vector getUnRegList() throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

        query = " select * from fine_temp2 where reg_yn ='N'";
	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
            stmt.close();

		} catch (SQLException e) {
			System.out.println("[AddForfeitDatabase:getFineCheckList]\n"+e);
			System.out.println("[AddForfeitDatabase:getFineCheckList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;

	}
	
}
