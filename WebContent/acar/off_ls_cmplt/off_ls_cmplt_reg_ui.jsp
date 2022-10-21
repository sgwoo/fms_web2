<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.offls_sui.*, acar.car_register.*, acar.car_scrap.*, acar.cont.*, acar.insur.*, acar.common.* "%>
<%@ page import="java.io.*,java.text.SimpleDateFormat,java.util.Calendar "%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%

	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();		

	String auth_rw = request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id");
	String gubun = request.getParameter("gubun");
	
	String i_result = "";
	int flag = 0;
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	

	SuiBean sui = olsD.getSui(car_mng_id);
	sui.setCar_mng_id(car_mng_id);
	sui.setSui_nm(request.getParameter("sui_nm"));
	sui.setSsn(request.getParameter("ssn1")+request.getParameter("ssn2"));
	sui.setRelation(request.getParameter("relation"));
	sui.setH_tel(request.getParameter("h_tel"));
	sui.setM_tel(request.getParameter("m_tel"));
	sui.setCont_dt(request.getParameter("cont_dt")==null?"":request.getParameter("cont_dt"));
	sui.setH_addr(request.getParameter("h_addr"));
	sui.setH_zip(request.getParameter("h_zip"));
	sui.setD_addr(request.getParameter("d_addr"));
	sui.setD_zip(request.getParameter("d_zip"));
	sui.setCar_nm(request.getParameter("car_nm"));
	sui.setCar_relation(request.getParameter("car_relation"));
	sui.setCar_addr(request.getParameter("car_addr"));
	sui.setCar_zip(request.getParameter("car_zip"));
	sui.setCar_ssn(request.getParameter("car_ssn1")+request.getParameter("car_ssn2"));
	sui.setCar_h_tel(request.getParameter("car_h_tel"));
	sui.setCar_m_tel(request.getParameter("car_m_tel"));
	sui.setEtc(request.getParameter("etc"));
	sui.setAss_st_dt(request.getParameter("ass_st_dt"));
	sui.setAss_ed_dt(request.getParameter("ass_ed_dt"));
	sui.setAss_st_km(AddUtil.parseDigit3(request.getParameter("ass_st_km")));
	sui.setAss_ed_km(AddUtil.parseDigit3(request.getParameter("ass_ed_km")));
	sui.setAss_wrt(request.getParameter("ass_wrt"));
	sui.setMm_pr(request.getParameter("mm_pr")==null?0:AddUtil.parseDigit(request.getParameter("mm_pr")));
	sui.setCont_pr(request.getParameter("cont_pr")==null?0:AddUtil.parseDigit(request.getParameter("cont_pr")));
	sui.setJan_pr(request.getParameter("jan_pr")==null?0:AddUtil.parseDigit(request.getParameter("jan_pr")));
	sui.setModify_id(user_id);
	sui.setCont_pr_dt(request.getParameter("cont_pr_dt")==null?"":request.getParameter("cont_pr_dt"));
	sui.setJan_pr_dt(request.getParameter("jan_pr_dt")==null?"":request.getParameter("jan_pr_dt"));
	if(sui.getMigr_dt().equals("")){
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy:MM:dd-hh:mm:ss");
		String datetime1 = sdf1.format(cal.getTime());
		sui.setUdt_dt(datetime1);
	}
	String o_migr_dt = sui.getMigr_dt();
	sui.setMigr_dt(request.getParameter("migr_dt")==null?"":request.getParameter("migr_dt"));
	String n_migr_dt = sui.getMigr_dt();
	sui.setMigr_no(request.getParameter("migr_no")==null?"":request.getParameter("migr_no"));
	String enp_no1 = request.getParameter("enp_no1")==null?"":request.getParameter("enp_no1");
	String enp_no2 = request.getParameter("enp_no2")==null?"":request.getParameter("enp_no2");
	String enp_no3 = request.getParameter("enp_no3")==null?"":request.getParameter("enp_no3");
	sui.setEnp_no(enp_no1+enp_no2+enp_no3);
	sui.setEmail(request.getParameter("email")==null?"":request.getParameter("email"));
	sui.setClient_id(request.getParameter("client_id")==null?"":request.getParameter("client_id"));
    sui.setSui_st("2");
  
	
    
	int result = 0;
	if(gubun.equals("u")){
		result = olsD.upSui(sui);
	}else if(gubun.equals("i")){
		result = olsD.inSui(sui);
	}else if(gubun.equals("p")){
		result = olsD.upSui(sui);
		result = olsD.regCls_cont(sui);
		
		//렌트차량번호 대폐차 넘기기-------------------------------
		
		//차량정보
		CarRegDatabase crd = CarRegDatabase.getInstance();
		cr_bean = crd.getCarRegBean(car_mng_id);
		
		if(cr_bean.getCar_use().equals("1")){//cr_bean.getCar_no().length() > 8 && 
			String car_ext = c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext());
			if(sc_db.getScrapCheck(cr_bean.getCar_no())==0){
				int result2 = sc_db.car_scrap_i(cr_bean.getCar_no(), cr_bean.getCar_nm(), AddUtil.getDate(), car_ext);
			}
		}
	}
	
	
	
	if(/* gubun.equals("u") ||  */gubun.equals("p")){
		if(o_migr_dt.equals("") && !n_migr_dt.equals("")){
			//보험변경요청 프로시저 호출
			//String  d_flag2 =  ec_db.call_sp_ins_cng_req("매각 명의이전일 등록", "", car_mng_id, "");

				String gubun2 = "해지";
				
				String ins_st = ai_db.getInsSt(car_mng_id);
				
				
				String reg_code  = Long.toString(System.currentTimeMillis());
				
				Hashtable i_ht = ai_db.getInsClsMng2(car_mng_id, ins_st);				
				
				InsurExcelBean ins = new InsurExcelBean();
				
				ins.setReg_code		(reg_code);
				ins.setSeq				(1);
				ins.setReg_id			(ck_acar_id);
				ins.setGubun			(gubun2);
				ins.setCar_mng_id (car_mng_id);
				ins.setIns_st	    (ins_st);
				
				ins.setValue01		(String.valueOf(i_ht.get("CAR_NO")));
				ins.setValue02		(String.valueOf(i_ht.get("INS_CON_NO")));
				ins.setValue03		(String.valueOf(i_ht.get("CAR_NM")));
				ins.setValue04		(String.valueOf(i_ht.get("MIGR_DT")));
				ins.setValue05		("없음");
				ins.setValue06		(String.valueOf(i_ht.get("CAU")));
				ins.setValue07		("");
				ins.setValue08		("");
				ins.setValue09		(String.valueOf(i_ht.get("INS_COM_ID")));
				
		/* 		System.out.println(car_mng_id);
				System.out.println(ins.getValue01());
				System.out.println(ins.getValue02());
				System.out.println(ins.getValue03());
				System.out.println(ins.getValue04()); */
				
				
				if(ins.getValue01().equals("null") && ins.getValue02().equals("null") && ins.getValue03().equals("null") && ins.getValue04().equals("null")){
					i_result = "보험내용을 정상적으로 가져오지 못했습니다.";
				}else{
					//중복체크
					int over_cnt = ic_db.getCheckOverInsExcelCom(gubun2, "", "", "", car_mng_id, ins_st);
					if(over_cnt > 0){
						i_result = "이미 등록되어 있습니다.";
					}else{
						if(!ic_db.insertInsExcelCom(ins)){
							flag += 1;
							i_result = "등록에러입니다.";
						}else{
							i_result = "정상 등록되었습니다.";
						}
					}
				}

		}
	}
	
	
	String actn_id = request.getParameter("actn_id")==null?"":request.getParameter("actn_id");
	
	String actn_dt = request.getParameter("actn_dt")==null?"":request.getParameter("actn_dt"); //경매일자
	
	int result1 = 0;
	// 현대글로비스인 경우 1,2회차 낙찰은 출품수수료 있음 - 입금예정일 등록
	if ( actn_id.equals("000502")) {	
		result1 = olsD.upScd_sui_ip_est(car_mng_id, actn_dt);
	}
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result > 0){
	if(gubun.equals("i")){%>
		alert("등록되었습니다.");
		parent.location.href = "/acar/off_ls_cmplt/off_ls_cmplt_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&actn_dt=<%=actn_dt%>";
	<%}else if(gubun.equals("u")){%>
		alert("수정되었습니다.");
		<%if(!i_result.equals("")){%>
			alert("<%=i_result%>");
		<%}%>
		parent.parent.location.href = "/acar/off_ls_cmplt/off_ls_cmplt_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&actn_dt=<%=actn_dt%>";
	<%}else if(gubun.equals("p")){%>
		alert("매각처리되었습니다.");				
		<%if(!i_result.equals("")){%>
			alert("<%=i_result%>");
		<%}%>
		parent.parent.parent.location.href = "/acar/off_ls_cmplt/off_ls_cmplt_grid_frame.jsp?auth_rw=<%=auth_rw%>";
	<%}%>
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	location.href = "/acar/off_ls_cmplt/off_ls_cmplt_reg.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}%>
//-->
</script>

</body>
</html>
