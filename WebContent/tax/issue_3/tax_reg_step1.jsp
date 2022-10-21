<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.client.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.bill_mng.*, acar.car_register.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	out.println("세금계산서 발행하기 1단계"+"<br><br>");
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "11");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String req_dt 		= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String tax_dt 		= request.getParameter("tax_dt")==null?"":request.getParameter("tax_dt");
	String seq_no 		= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String rent_s_cd	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	String cust_st		= request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	
	String count 		= request.getParameter("count")==null?"":request.getParameter("count");
	String i_site_id 	= request.getParameter("i_site_id")==null?"":request.getParameter("i_site_id");
	String o_br_id 		= request.getParameter("o_br_id")==null?"":request.getParameter("o_br_id");
	String tax_g 		= request.getParameter("tax_g")==null?"":request.getParameter("tax_g");
	String tax_bigo 	= request.getParameter("tax_bigo")==null?"":request.getParameter("tax_bigo");
	String req_y 		= request.getParameter("req_y")==null?"":request.getParameter("req_y");	
	String req_m 		= request.getParameter("req_m")==null?"":AddUtil.addZero(request.getParameter("req_m"));	
	String req_d 		= request.getParameter("req_d")==null?"":AddUtil.addZero(request.getParameter("req_d"));	
	String tax_bigo_t 	= request.getParameter("tax_bigo_t")==null?"":request.getParameter("tax_bigo_t");
	String tax_bigo_50 	= request.getParameter("tax_bigo_50")==null?"":request.getParameter("tax_bigo_50");
	
	String con_agnt_nm 		= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_dept 	= request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept");
	String con_agnt_title 	= request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title");
	String con_agnt_email 	= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel 	= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	String con_agnt_nm2 		= request.getParameter("con_agnt_nm2")==null?"":request.getParameter("con_agnt_nm2");
	String con_agnt_dept2 	= request.getParameter("con_agnt_dept2")==null?"":request.getParameter("con_agnt_dept2");
	String con_agnt_title2 	= request.getParameter("con_agnt_title2")==null?"":request.getParameter("con_agnt_title2");
	String con_agnt_email2 	= request.getParameter("con_agnt_email2")==null?"":request.getParameter("con_agnt_email2");
	String con_agnt_m_tel2 	= request.getParameter("con_agnt_m_tel2")==null?"":request.getParameter("con_agnt_m_tel2");	
	String pubform		 	= request.getParameter("pubform")==null?"":request.getParameter("pubform");
	String car_use		 	= request.getParameter("car_use")==null?"":request.getParameter("car_use");
	String i_taxregno 	= request.getParameter("i_taxregno")==null?"":request.getParameter("i_taxregno");
	
	String o_client_id 	= request.getParameter("o_client_id")==null?"":request.getParameter("o_client_id");
	
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	if(!o_client_id.equals("") && !o_client_id.equals(client_id)){
		ClientBean client2 = al_db.getClient(client_id); //변경된 고객 정보
		con_agnt_nm 	= client2.getCon_agnt_nm();
		con_agnt_dept 	= client2.getCon_agnt_dept();
		con_agnt_title 	= client2.getCon_agnt_title();
		con_agnt_email 	= client2.getCon_agnt_email();
		con_agnt_m_tel 	= client2.getCon_agnt_m_tel();	
		con_agnt_nm2 	= client2.getCon_agnt_nm2();
		con_agnt_dept2 	= client2.getCon_agnt_dept2();
		con_agnt_title2 = client2.getCon_agnt_title2();
		con_agnt_email2 = client2.getCon_agnt_email2();
		con_agnt_m_tel2 = client2.getCon_agnt_m_tel2();
		
		out.println(o_client_id+" ");
		out.println(client2.getCon_agnt_email()+" ");
		out.println(con_agnt_email+" ");
	}
		
	String seq[] 		= request.getParameterValues("seq");
	String item_g[] 	= request.getParameterValues("item_g");
	String item_car_no[] 	= request.getParameterValues("item_car_no");
	String item_car_nm[] 	= request.getParameterValues("item_car_nm");
	String item_dt1[] 	= request.getParameterValues("item_dt1");
	String item_dt2[] 	= request.getParameterValues("item_dt2");
	String item_supply[] 	= request.getParameterValues("item_supply");
	String item_value[] 	= request.getParameterValues("item_value");
	String item_amt[] 	= request.getParameterValues("item_amt");
	String l_cd[] 		= request.getParameterValues("l_cd");
	String c_id[] 		= request.getParameterValues("c_id");
	String tm[] 		= request.getParameterValues("tm");
	String rent_st[] 	= request.getParameterValues("rent_st");
	
	String item_id = "";
	String reg_gu = "";
	int vid_size = 0;
	int flag = 0;
	int notreg = 0;
	
	vid_size = l_cd.length;
	
	if(req_dt.equals("")) 			req_dt=req_y+req_m+req_d;
	if(tax_dt.equals("")) 			tax_dt = req_dt;
	
	if(reg_gu.equals("3_9")){
		tax_dt = tax_dt;
	}
	
	
	out.println("선택건수 ="+count+"<br><br>");	
	out.println("거래명세서 리스트수 ="+vid_size+"<br><br>");
	//if(1==1)return;

	//실행코드 가져오기
	String reg_code  = Long.toString(System.currentTimeMillis());
	out.println("실행코드="+reg_code+"<br>");

	//사용할 item_id 가져오기
	item_id = IssueDb.getItemIdNext(req_y+req_m+req_d);
	out.println("item_id="+item_id+"<br><br>");

	//int for_i = 0;
	//if(reg_gu.equals("3_9")){
	//	for_i = 1;
	//}
	
	//[1단계] 거래명세서 리스트 생성
	for(int i=0;i < vid_size;i++){
		
		
		String today 		= AddUtil.getDate(4);
		//세금계산서일자가 오늘보다 크면 처리안함.
		if(AddUtil.parseInt(AddUtil.replace(tax_dt,"-","")) > AddUtil.parseInt(today)){
			notreg++;
			System.out.println(item_id+":세금계산서일자가 오늘보다 크면 처리안함");
			
			continue;
		}
		
		TaxItemListBean til_bean = new TaxItemListBean();
		
		
		if(AddUtil.parseDigit(item_supply[i]) >0 || AddUtil.parseDigit(item_supply[i]) <0){
			
			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(AddUtil.parseInt(seq[i]));
			til_bean.setItem_g(item_g[i]);
			if(!item_car_no[i].equals("미등록")){
				til_bean.setItem_car_no(item_car_no[i]);
			}
			til_bean.setItem_car_nm(item_car_nm[i]);
			til_bean.setItem_dt1(item_dt1[i]);
			til_bean.setItem_dt2(item_dt2[i]);
			til_bean.setItem_supply(AddUtil.parseDigit(item_supply[i]));
			til_bean.setItem_value(AddUtil.parseDigit(item_value[i]));
			til_bean.setRent_l_cd(l_cd[i]);
			til_bean.setCar_mng_id(c_id[i]);
			til_bean.setTm(tm[i]);
			til_bean.setRent_st(rent_st[i]==null?"":rent_st[i]);
			if(item_g[i].equals("선납금")){
				til_bean.setGubun("3");
			}else if(item_g[i].equals("개시대여료")){
			 	til_bean.setGubun("4");
			}else if(item_g[i].equals("위약금")){
				til_bean.setGubun("5");
			}else if(item_g[i].equals("차량매각대금")){
				til_bean.setGubun("6");
			}else if(item_g[i].equals("차량수리비")){
				til_bean.setGubun("7");
			}else if(item_g[i].equals("차량손해면책금")){
				til_bean.setGubun("7");
			}else if(item_g[i].equals("정보제공 수수료")){
				til_bean.setGubun("7");
			}else if(item_g[i].equals("과태료")){
				til_bean.setGubun("8");
			}else if(item_g[i].equals("단기대여")){
				til_bean.setGubun("9");
			}else if(item_g[i].equals("월렌트")){
				til_bean.setGubun("16");
			}else if(item_g[i].equals("정비대차")){
				til_bean.setGubun("17");
			}else if(item_g[i].equals("보험대차")){
			 	til_bean.setGubun("10");
			}else if(item_g[i].equals("대차료")){
			 	til_bean.setGubun("11");
				til_bean.setRent_seq(seq_no);
			}else if(item_g[i].equals("휴차료")){
			 	til_bean.setGubun("12");
			}else if(item_g[i].equals("승계수수료")){
			 	til_bean.setGubun("14");
			}
			
			//카드사캐쉬백수익-두바이카
			if(car_use.equals("4")){
				til_bean.setGubun("7");
			}
			
			til_bean.setReg_id		(user_id);
			til_bean.setReg_code		(reg_code);
			til_bean.setItem_dt		(tax_dt);
			
			til_bean.setCar_use		(car_use);
			
			//차량등록정보
			if(til_bean.getCar_use().equals("") && !til_bean.getCar_mng_id().equals("")){
				cr_bean = crd.getCarRegBean(til_bean.getCar_mng_id());
				til_bean.setCar_use		(cr_bean.getCar_use());
			}
			
			
			if(reg_gu.equals("3_9") && til_bean.getItem_supply() == 0) continue;
			
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
			//gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여, 14 승계수수료, 15 해지관련, 16 월렌트, 17 정비대차, 18 캐쉬백수익 
			
		}
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'tax_reg_step2.jsp';
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='client_id' 	value='<%=client_id%>'>
<input type='hidden' name='site_id' 	value='<%=i_site_id%>'>
<input type='hidden' name='reccotaxregno' value='<%=i_taxregno%>'>
<input type='hidden' name='brch_id' 	value='<%=o_br_id%>'>
<input type='hidden' name='tax_g' 		value='<%=tax_g%>'>
<input type='hidden' name='tax_bigo' 	value='<%=tax_bigo%>'>
<input type='hidden' name='tax_bigo_t' 	value='<%=tax_bigo_t%>'>
<input type='hidden' name='tax_dt' 		value='<%=tax_dt%>'>
<input type='hidden' name='tax_bigo_50'	value='<%=tax_bigo_50%>'>

<%if(gubun1.equals("6") || gubun1.equals("9")){%>
<input type='hidden' name='req_dt' 		value='<%=req_dt%>'>
<%}else{%>
<input type='hidden' name='req_dt' 		value='<%=req_y+req_m+req_d%>'>
<%}%>
<input type='hidden' name='reg_gu' 		value='3_<%=gubun1%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='item_list_cnt' value='<%=vid_size%>'>

<input type='hidden' name='con_agnt_nm' 	value='<%=con_agnt_nm%>'>
<input type='hidden' name='con_agnt_dept' 	value='<%=con_agnt_dept%>'>
<input type='hidden' name='con_agnt_title' 	value='<%=con_agnt_title%>'>
<input type='hidden' name='con_agnt_email' 	value='<%=con_agnt_email%>'>
<input type='hidden' name='con_agnt_m_tel' 	value='<%=con_agnt_m_tel%>'>
<input type='hidden' name='con_agnt_nm2' 		value='<%=con_agnt_nm2%>'>
<input type='hidden' name='con_agnt_dept2' 	value='<%=con_agnt_dept2%>'>
<input type='hidden' name='con_agnt_title2' value='<%=con_agnt_title2%>'>
<input type='hidden' name='con_agnt_email2' value='<%=con_agnt_email2%>'>
<input type='hidden' name='con_agnt_m_tel2' value='<%=con_agnt_m_tel2%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>
<input type="hidden" name="rent_s_cd" value="<%=rent_s_cd%>">      
<input type="hidden" name="cust_st" value="<%=cust_st%>">             
<input type="hidden" name="pubform" value="<%=pubform%>">             

</form>
<a href="javascript:go_step()">2단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생
		//이미 작성한 거래명서세 리스트 삭제
		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;%>
		alert("거래명세서 리스트 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>

		<%if(notreg > 0){%>
			alert('세금계산서일자가 오늘보다 커 발행되지 않습니다');
		<%}else{%>
			go_step();
		<%}%>

<%	}%>
//-->
</script>
</body>
</html>
