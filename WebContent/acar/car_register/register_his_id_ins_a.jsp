<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.car_register.*, acar.car_scrap.*, acar.insur.*, acar.common.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="cr_bean2" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="ins_bean" class="acar.insur.InsurBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%

	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 		= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String cha_cau 		= request.getParameter("cha_cau")==null?"":request.getParameter("cha_cau");
	String car_ext2		= request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	String car_use2		= request.getParameter("car_use")==null?"":request.getParameter("car_use");
		
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();			
	
	//차량정보
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	String o_car_no = cr_bean.getCar_no();
	
	ch_bean.setCar_mng_id	(car_mng_id);
	ch_bean.setCha_car_no	(request.getParameter("cha_car_no"));
	ch_bean.setCha_dt	(AddUtil.ChangeString(request.getParameter("cha_dt")));
	ch_bean.setCha_cau	(request.getParameter("cha_cau"));
	ch_bean.setCha_cau_sub	(request.getParameter("cha_cau_sub"));
	ch_bean.setReg_id	(user_id);
	
	if(cha_cau.equals("1")){
		ch_bean.setCar_ext	(car_ext2);//지역
	}else{
		ch_bean.setCar_ext	(cr_bean.getCar_ext());//지역
	}
	
	
	int result = 0;
	
	String i_result = "";
	int flag = 0;
		
	
		result = crd.insertCarHis(ch_bean);
		int count=0;
		
		System.out.println("==자동차번호이력===========");
		System.out.println("car_no	="+cr_bean.getCar_no());
		System.out.println("cha_cau	="+cha_cau);
		System.out.println("car_ext2="+car_ext2);
		System.out.println("cr_bean.getCar_ext()="+cr_bean.getCar_ext());
		System.out.println("car_use2="+car_use2);
		System.out.println("ch_bean.getCha_car_no()="+ch_bean.getCha_car_no());
		System.out.println("cr_bean.getCar_no()="+cr_bean.getCar_no());
		
		System.out.println("==자동차번호이력 수정자===========");
		System.out.println("reg_id	="+ user_id);
	
		//자동차등록증 변경
		if(cha_cau.equals("1") || cha_cau.equals("2")){
				
			if(!ch_bean.getCha_car_no().equals(cr_bean.getCar_no())){//상단차량번호와 변경번호가 틀릴때
			
				//렌트차량번호 대폐차 넘기기-------------------------------
				if((ch_bean.getCha_car_no().indexOf("허") == -1 && cr_bean.getCar_no().indexOf("허") != -1) || 
  			   (ch_bean.getCha_car_no().indexOf("하") == -1 && cr_bean.getCar_no().indexOf("하") != -1) || 
	  		   (ch_bean.getCha_car_no().indexOf("호") == -1 && cr_bean.getCar_no().indexOf("호") != -1)){
					String car_ext = c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext());
					int result2 = sc_db.car_scrap_i(cr_bean.getCar_no(), cr_bean.getCar_nm(), AddUtil.getDate(), car_ext);
				}
			
				cr_bean.setCar_no(request.getParameter("cha_car_no"));//변경차량번호
			}
			
			if(cha_cau.equals("1")){
				cr_bean.setCar_ext(car_ext2);//지역
			}
			if(cha_cau.equals("2")){
				cr_bean.setCar_use	(car_use2);//용도		
				cr_bean.setMaint_st_dt	(request.getParameter("maint_st_dt")==null?"":request.getParameter("maint_st_dt"));			//검사유효기간1
				cr_bean.setMaint_end_dt	(request.getParameter("maint_end_dt")==null?"":request.getParameter("maint_end_dt"));			//검사유효기간2
				cr_bean.setCar_end_dt	(request.getParameter("car_end_dt")==null?"":request.getParameter("car_end_dt"));			//차량만료일
				cr_bean.setTest_st_dt	(request.getParameter("test_st_dt")==null?"":request.getParameter("test_st_dt"));			//점검유효기간1
				cr_bean.setTest_end_dt	(request.getParameter("test_end_dt")==null?"":request.getParameter("test_end_dt"));			//점검유효기간2		
			}
		
			cr_bean.setUpdate_id	(user_id);
		         		
			count = crd.updateCarMain(cr_bean);		
		
			cr_bean2 = crd.getCarRegBean(car_mng_id);
		
			//사용본거지가 제대로 수정되지 않았을 경우 처리
			if(cha_cau.equals("1") && !cr_bean2.getCar_ext().equals(car_ext2)){
				count = crd.updateCarExt(car_mng_id, car_ext2);
				System.out.println("car_ext2="+car_ext2);
				System.out.println("cr_bean2.getCar_ext()="+cr_bean2.getCar_ext());
			}
			//용도변경이 제대로 수정되지 않았을 경우 처리
			if(cha_cau.equals("2") && !cr_bean2.getCar_use().equals(car_use2)){
				count = crd.updateCarUse(car_mng_id, car_use2);
				System.out.println("car_use2="+car_use2);
				System.out.println("cr_bean2.getCar_use()="+cr_bean2.getCar_use());
			}
		}else{
			if(!ch_bean.getCha_car_no().equals(cr_bean.getCar_no())){//상단차량번호와 변경번호가 틀릴때
			
				//렌트차량번호 대폐차 넘기기-------------------------------
				if((ch_bean.getCha_car_no().indexOf("허") == -1 && cr_bean.getCar_no().indexOf("허") != -1) || 
				   (ch_bean.getCha_car_no().indexOf("하") == -1 && cr_bean.getCar_no().indexOf("하") != -1) || 
				   (ch_bean.getCha_car_no().indexOf("호") == -1 && cr_bean.getCar_no().indexOf("호") != -1)){
					String car_ext = c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext());
					int result2 = sc_db.car_scrap_i(cr_bean.getCar_no(), cr_bean.getCar_nm(), AddUtil.getDate(), car_ext);
				}
				cr_bean.setCar_no(request.getParameter("cha_car_no"));//변경차량번호
				cr_bean.setUpdate_id	(user_id);
				count = crd.updateCarMain(cr_bean);
			}
		}
		
	//용도변경외 번호변경시 보험변경요청에 등록
	if(!cha_cau.equals("2") && !o_car_no.equals(ch_bean.getCha_car_no())){
			//보험변경요청 프로시저 호출
			String  d_flag2 =  ec_db.call_sp_ins_cng_req("차량번호 변경", o_car_no, car_mng_id, ch_bean.getCha_car_no());
	//용도변경 번호변경시 보험변경요청에 등록
	}else if(cha_cau.equals("2") && !o_car_no.equals(ch_bean.getCha_car_no())){
				
				String gubun2 = "해지";
				
				String ins_st = ai_db.getInsSt(car_mng_id);
				
				
				String reg_code  = Long.toString(System.currentTimeMillis());
				
				ins_bean = ai_db.getIns(car_mng_id, ins_st);
				
				InsurExcelBean ins = new InsurExcelBean();
				
				ins.setReg_code		(reg_code);
				ins.setSeq				(1);
				ins.setReg_id			(ck_acar_id);
				ins.setGubun			(gubun2);
				ins.setCar_mng_id (car_mng_id);
				ins.setIns_st	    (ins_st);
				
				ins.setValue01		(o_car_no);
				ins.setValue02		(ins_bean.getIns_con_no());
				ins.setValue03		(cr_bean.getCar_nm());
				ins.setValue04		(ch_bean.getCha_dt());
				ins.setValue05		(ch_bean.getCha_car_no());
				ins.setValue06		("용도변경");
				ins.setValue07		("");
				ins.setValue08		("");
				ins.setValue09		(ins_bean.getIns_com_id());
				
				
				if(ins.getValue01().equals("null") && ins.getValue02().equals("null") && ins.getValue03().equals("null") && ins.getValue04().equals("null")){
					i_result = "용도변경 보험해지 보험내용을 정상적으로 가져오지 못했습니다.";
				}else{
					//중복체크
					int over_cnt = ic_db.getCheckOverInsExcelCom(gubun2, "", "", "", car_mng_id, ins_st);
					if(over_cnt > 0){
						i_result = "용도변경 보험해지  이미 등록되어 있습니다.";
					}else{
						if(!ic_db.insertInsExcelCom(ins)){
							flag += 1;
							i_result = "용도변경 보험해지 등록에러입니다.";
						}else{
							i_result = "용도변경 보험해지 정상 등록되었습니다.";
						}
					}
				}
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
<%if(result >= 1){%>
	alert("등록되었습니다.");
		<%if(!i_result.equals("")){%>
			alert("<%=i_result%>");
		<%}%>	
	parent.parent.location.href = "./register_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=car_mng_id%>&cmd=<%=cmd%>&st=<%=st%>&ref_dt1=<%=ref_dt1%>&ref_dt2=<%=ref_dt2%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>&q_sort_nm=<%=q_sort_nm%>&q_sort=<%=q_sort%>"; 
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
<%}%>
//-->
</script>
</body>
</html>
