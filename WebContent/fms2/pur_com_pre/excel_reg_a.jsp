<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.car_office.*, acar.cont.*, acar.car_mst.*"%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//출고영업소
	String value1[]  = request.getParameterValues("value1");//계출번호
	String value2[]  = request.getParameterValues("value2");//요청일시(20181108)
	String value3[]  = request.getParameterValues("value3");//차명
	String value4[]  = request.getParameterValues("value4");//사양
	String value5[]  = request.getParameterValues("value5");//외장색상
	String value6[]  = request.getParameterValues("value6");//내장색상
	String value7[]  = request.getParameterValues("value7");//가니쉬색상 2021.07.21 추가
	String value8[]  = request.getParameterValues("value8");//소비자가
	String value9[]  = request.getParameterValues("value9");//계약금
	String value10[]  = request.getParameterValues("value10");//계약금지급일자
	String value11[] = request.getParameterValues("value11");//출고예정일
	String value12[] = request.getParameterValues("value12");//비고
	String value13[] = request.getParameterValues("value13");//담당자
	String value14[] = request.getParameterValues("value14");//고객명
	String value15[] = request.getParameterValues("value15");//고객주소지
	String value16[] = request.getParameterValues("value16");//아마존카계약번호
	String value17[] = request.getParameterValues("value17");//엔진구분
	String value18[] = request.getParameterValues("value18");//에이전트노출여부
	String value19[] = request.getParameterValues("value19");//자체영업여부
	//String value20[] = request.getParameterValues("value20");//Q코드
	String value20[] = request.getParameterValues("value20");//계약금지급방식
	String value21[] = request.getParameterValues("value21");//카드/금융사
	String value22[] = request.getParameterValues("value22");//계좌종류
	String value23[] = request.getParameterValues("value23");//카드/계좌번호
	String value24[] = request.getParameterValues("value24");//적요/예금주
	String value25[] = request.getParameterValues("value25");//계약금지출예정일
	
	
	
	String car_off_nm 	= "";
	String car_off_id 	= "";
	String com_con_no 	= "";
	String req_dt		= "";	//요청일시 추가(20181108)
	String car_nm 	  	= "";
	String opt 		  	= "";
	String colo 	  	= "";
	String in_col	  	= "";
	String garnish_col	  	= "";
	int    car_amt 	  	= 0;
	int    con_amt 	  	= 0;
	String con_pay_dt 	= "";
	String dlv_est_dt 	= "";
	String etc 			= "";
	String bus_nm 		= "";
	String firm_nm 		= "";
	String addr 		= "";
	String rent_l_cd	= "";
	String eco_yn 		= "";
	String agent_view_yn = "";
	String bus_self_yn = "";
	//String q_reg_dt = "";

	int 	flag  = 0;
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
		
	

	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		result[i] = "";
		
		car_off_nm 		= value0[i]  ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value0[i],"-",""),"_ ","")," ","");
		com_con_no 		= value1[i]  ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value1[i],"-",""),"_ ","")," ","");
		req_dt			= value2[i]	 ==null?"":value2[i];	//요청일시 추가(20181108)
		car_nm 			= value3[i]  ==null?"":value3[i];
		opt 			= value4[i]  ==null?"":value4[i];
		colo 			= value5[i]  ==null?"":value5[i];
		in_col			= value6[i]  ==null?"":value6[i];
		garnish_col		= value7[i]	 == null ? "" : value7[i];	 // 가니쉬 색상 추가.
		car_amt 		= value8[i]  ==null?0:AddUtil.parseDigit(AddUtil.replace(AddUtil.replace(AddUtil.replace(value8[i],"-",""),"_ ","")," ",""));
		con_amt 		= value9[i]  ==null?0:AddUtil.parseDigit(AddUtil.replace(AddUtil.replace(AddUtil.replace(value9[i],"-",""),"_ ","")," ",""));
		con_pay_dt 		= value10[i]  ==null?"":AddUtil.replace(AddUtil.replace(value10[i]," ",""),"-","");
		dlv_est_dt 		= value11[i] ==null?"":AddUtil.replace(AddUtil.replace(value11[i]," ",""),"-","");
		etc 			= value12[i] ==null?"":value12[i];
		bus_nm 			= value13[i] ==null?"":value13[i];
		firm_nm 		= value14[i] ==null?"":value14[i];
		addr 			= value15[i] ==null?"":value15[i];
		rent_l_cd 		= value16[i] ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value16[i],"-",""),"_ ","")," ","");
		eco_yn 			= value17[i] ==null?"":value17[i];
		agent_view_yn	= value18[i] ==null?"":AddUtil.replace(value18[i]," ","");
		bus_self_yn		= value19[i] ==null?"":AddUtil.replace(value19[i]," ","");
		//q_reg_dt		= value20[i] ==null?"":AddUtil.replace(value20[i]," ","");
		
		
		CarOffPreBean bean = cop_db.getCarOffPreComConNo(com_con_no);
		
		//out.println("<br>"+com_con_no);
		
		String o_rent_l_cd = bean.getRent_l_cd();
		String o_q_reg_dt = bean.getQ_reg_dt();
		
		bean.setCar_nm			(car_nm);	
		bean.setOpt				(opt);	
		bean.setColo			(colo);	
		bean.setIn_col			(in_col);	
		bean.setGarnish_col		(garnish_col);	
		bean.setCar_amt			(car_amt);	
		bean.setCon_amt			(con_amt);	
		bean.setCon_pay_dt		(con_pay_dt);		
		bean.setDlv_est_dt		(dlv_est_dt);	
		bean.setEtc				(etc);
		bean.setReq_dt			(req_dt);	//요청일시 추가(20181108)
		bean.setEco_yn			(eco_yn);	//엔진구분(20191122)
		bean.setAgent_view_yn	(agent_view_yn);	//에이전트 차량 보이기(20220421)
		bean.setBus_self_yn		(bus_self_yn);	//자체영업여부(20220822)
		//bean.setQ_reg_dt		(q_reg_dt);	//Q코드(20220822)
		
		bean.setTrf_st0			(value20[i] ==null?"":AddUtil.replace(value20[i]," ",""));	//계약금지급방식
		bean.setCon_bank		(value21[i] ==null?"":AddUtil.replace(value21[i]," ",""));	//카드/금융사
		bean.setAcc_st0			(value22[i] ==null?"":AddUtil.replace(value22[i]," ",""));	//계좌종류
		bean.setCon_acc_no		(value23[i] ==null?"":AddUtil.replace(value23[i]," ",""));	//카드/계좌번호
		bean.setCon_acc_nm		(value24[i] ==null?"":AddUtil.replace(value24[i]," ",""));	//적요/예금주
		bean.setCon_est_dt		(value25[i] ==null?"":AddUtil.replace(AddUtil.replace(value25[i]," ",""),"-",""));	//계약금지출예정일
		
		if(bean.getTrf_st0().equals("현금")) 				bean.setTrf_st0("1");
		if(bean.getTrf_st0().equals("후불카드")) 			bean.setTrf_st0("3");
		if(bean.getTrf_st0().equals("카드")) 				bean.setTrf_st0("3");
		
		//등록
		if(bean.getSeq() == 0){
		
			if(car_off_nm.equals("강서")) 				car_off_nm = "강서구청영업소";
			else if(car_off_nm.equals("강서구청")) 		car_off_nm = "강서구청영업소";
			else if(car_off_nm.equals("강서구청대리점")) 	car_off_nm = "강서구청영업소";
			else if(car_off_nm.equals("법인")) 			car_off_nm = "B2B사업운영팀";
			else if(car_off_nm.equals("법인판매")) 		car_off_nm = "B2B사업운영팀";
			else if(car_off_nm.equals("숭실대")) 			car_off_nm = "숭실대대리점";
			else if(car_off_nm.equals("숭실대판매점")) 		car_off_nm = "숭실대대리점";
			else if(car_off_nm.equals("을지로")) 			car_off_nm = "을지로대리점";
			else if(car_off_nm.equals("증산")) 			car_off_nm = "증산대리점";
			else if(car_off_nm.equals("학익")) 			car_off_nm = "학익대리점";
			
			if(car_off_nm.equals("B2B사업운영팀")) 		car_off_id = "03900";
			else if(car_off_nm.equals("강서구청영업소")) 	car_off_id = "02176";
			else if(car_off_nm.equals("분당서현전시장")) 	car_off_id = "04741";
			else if(car_off_nm.equals("숭실대대리점")) 		car_off_id = "00998";
			else if(car_off_nm.equals("영등포중앙대리점")) 	car_off_id = "04128";
			else if(car_off_nm.equals("을지로대리점")) 		car_off_id = "04500";
			else if(car_off_nm.equals("증산대리점")) 		car_off_id = "03548";
			else if(car_off_nm.equals("총신대")) 			car_off_id = "00588";
			else if(car_off_nm.equals("학익대리점")) 		car_off_id = "03579";
			else if(car_off_nm.equals("효성강남대로본사")) 	car_off_id = "03923";

			bean.setCar_off_nm		(car_off_nm);
			bean.setCar_off_id		(car_off_id);
			bean.setCom_con_no		(com_con_no);
			bean.setReg_id			(ck_acar_id);		
			bean.setUse_yn			("Y");	
			bean.setBus_nm			(bus_nm);	
			bean.setFirm_nm			(firm_nm);	
			bean.setAddr			(addr);
			
			
			
			//insert
			flag1 = cop_db.insertCarOffPre(bean);
			
			result[i] = "등록되었습니다.";
		
		//수정
		}else{
			
			//out.println(bus_nm);
			//out.println(bean.getBus_nm());
			
			if(!bus_nm.equals("")){
			
				//기존 예약자가 있다
				if(!bean.getBus_nm().equals("")){
					//예약자가 다른 경우 : 기존예약자 취소후 후순위자로 등록
					if(!bean.getBus_nm().equals(bus_nm)){
					
						//update 기존계약자취소
						flag2 = cop_db.updateCarOffPreResCls(bean.getSeq(), bean.getR_seq());
					
						//새계약자 등록
						bean.setBus_nm			(bus_nm);	
						bean.setFirm_nm			(firm_nm);	
						bean.setAddr			(addr);	
						
						//if(q_reg_dt.equals("Y")){
						//	bean.setCust_q("Q");
						//}
					
						//insert
						flag3 = cop_db.insertCarOffPreRes(bean);
					
						result[i] = "기존계약자 취소후 새계약자 등록되었습니다.";
					
					//예약자가 같은 경우 : 수정
					}else{
						bean.setFirm_nm			(firm_nm);	
						bean.setAddr			(addr);	
					
						//update
						flag2 = cop_db.updateCarOffPreRes(bean);
					
						result[i] = "수정되었습니다.";
					}
				}else{
					//예약자 등록
					bean.setBus_nm			(bus_nm);	
					bean.setFirm_nm			(firm_nm);	
					bean.setAddr			(addr);
					
					//if(q_reg_dt.equals("Y")){
					//	bean.setCust_q("Q");
					//}
				
					//insert
					flag3 = cop_db.insertCarOffPreRes(bean);
				
					result[i] = "계약자 등록 및 수정되었습니다.";
				}
			}
			
			//update
			flag1 = cop_db.updateCarOffPre(bean);
			
			//변경일때 Q코드등록일
			//if(o_q_reg_dt.equals("") && q_reg_dt.equals("Y")){
			//	flag1 = cop_db.updateCarOffPreQ(bean);
			//}
			
			
			if(result[i].equals("")) result[i] = "수정되었습니다.";
			
		}
		
		//계약 매칭
		if(!rent_l_cd.equals("")){
			//계약매칭처리
			if(o_rent_l_cd.equals("")){
			
				//계약등록 확인
				Hashtable cont = a_db.getContCase(rent_l_cd);
				
				//20190221 컨버전 미처리 : 잘못 입력분 찾을수 없음.
				if(!String.valueOf(cont.get("RENT_L_CD")).equals("") && !String.valueOf(cont.get("RENT_L_CD")).equals("null")){
				
					//차량기본정보
					ContCarBean car 	= a_db.getContCarNew(String.valueOf(cont.get("RENT_MNG_ID")), rent_l_cd);
				
					//자동차기본정보
					CarMstBean cm_bean = cmb.getCarNmCase(car.getCar_id(), car.getCar_seq());
				
					//컨버전
					//bean.setCar_nm			(cm_bean.getCar_nm());	
					//bean.setOpt				(cm_bean.getCar_name()+" "+car.getOpt());	
					//bean.setColo			(car.getColo());	
					//bean.setIn_col			(car.getIn_col());	
					//bean.setCar_amt			(car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt());
				
					//result[i] = result[i]+" 계약매칭 및 차량정보 컨버전되었습니다.";
					
				}
				
			}	
			
			bean.setRent_l_cd			(rent_l_cd);
			
			//update
			flag1 = cop_db.updateCarOffPre(bean);
		}
		
		//out.println("(결과)"+result[i]);
		
	}
	

	
	int ment_cnt=0;
	
	//if(1==1)return;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 등록하기
</p>
<form action="excel_result.jsp" method="post" name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%for (int i = start_row; i < value_line; i++) {
	//if(result[i].equals("수정되었습니다.")||result[i].equals("등록되었습니다.")) continue;
	ment_cnt++;
%>
	<input type="hidden" name='car_off_nm' value='<%=value0[i] ==null?"":value0[i]%>'>
	<input type="hidden" name='com_con_no' value='<%=value1[i] ==null?"":value1[i]%>'>
	<input type="hidden" name='result' value='<%=result[i]%>'>
	<%if (i==value_line-1) {%>
	<input type="hidden" name="ment_cnt" value="<%=ment_cnt%>"/>
	<%}%>
<%}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
	document.form1.submit();
//-->
</SCRIPT>
</BODY>
</HTML>