<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
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
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String req_dt 		= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String rent_seq 	= request.getParameter("rent_seq")==null?"":request.getParameter("rent_seq");
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
	
	String con_agnt_nm 		= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_dept 	= request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept");
	String con_agnt_title 	= request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title");
	String con_agnt_email 	= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel 	= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	String accid_id  		= request.getParameter("tm")==null?"":request.getParameter("tm");
	String bus_id2  		= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	String seq[] 		= request.getParameterValues("seq");
	String item_g[] 	= request.getParameterValues("item_g");
	String item_car_no[] = request.getParameterValues("item_car_no");
	String item_car_nm[] = request.getParameterValues("item_car_nm");
	String item_dt1[] 	= request.getParameterValues("item_dt1");
	String item_dt2[] 	= request.getParameterValues("item_dt2");
	String item_supply[] = request.getParameterValues("item_supply");
	String item_value[] = request.getParameterValues("item_value");
	String item_amt[] 	= request.getParameterValues("item_amt");
	String l_cd[] 		= request.getParameterValues("l_cd");
	String c_id[] 		= request.getParameterValues("c_id");
	String tm[] 		= request.getParameterValues("tm");
	
	String item_id = "";
	String reg_gu = "";
	int vid_size = 0;
	int flag = 0;
	
	count 	 = "1";
	vid_size = l_cd.length;
	
	out.println("선택건수 ="+count+"<br><br>");	
	out.println("거래명세서 리스트수 ="+vid_size+"<br><br>");
//if(1==1)return;

	//실행코드 가져오기
	String reg_code  = Long.toString(System.currentTimeMillis());
	out.println("실행코드="+reg_code+"<br>");

	//사용할 item_id 가져오기
	//item_id = IssueDb.getItemIdNext(req_y+req_m+req_d);
	item_id = IssueDb.getItemIdNext(req_dt);
	out.println("item_id="+item_id+"<br><br>");

	//[1단계] 거래명세서 리스트 생성

	for(int i=0;i < 1;i++){
		
		TaxItemListBean til_bean = new TaxItemListBean();
		
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
		}else if(item_g[i].equals("과태료")){
			til_bean.setGubun("8");
		}else if(item_g[i].equals("Self")){
			til_bean.setGubun("9");
		}else if(item_g[i].equals("self")){
			til_bean.setGubun("9");
		}else if(item_g[i].equals("보험대차")){
		 	til_bean.setGubun("10");
		}else if(item_g[i].equals("대차료")){
		 	til_bean.setGubun("11");
		}else if(item_g[i].equals("휴차료")){
		 	til_bean.setGubun("12");
		}
		til_bean.setReg_id	(bus_id2);
		til_bean.setReg_code	(reg_code);
		til_bean.setRent_seq	(rent_seq);
		til_bean.setItem_dt	(req_dt);
		
		if(bus_id2.equals("")){
			til_bean.setReg_id	(user_id);			
		}
		if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
		//gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 
		
//		accid_id = tm[i];
	}
	
	//[2단계] 거래명세서 생성
	Vector vt = IssueDb.getTaxItemListSusi(reg_code);
	int vt_size = vt.size();
	for(int i=0;i < vt_size;i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		TaxItemBean ti_bean = new TaxItemBean();
		ti_bean.setClient_id		(client_id);
		ti_bean.setSeq			(i_site_id);
		ti_bean.setItem_dt		(req_dt);
		ti_bean.setTax_id		("");
		ti_bean.setItem_id		(String.valueOf(ht.get("ITEM_ID")));
		ti_bean.setItem_hap_str		(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"원");
		ti_bean.setItem_hap_num		(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
		ti_bean.setItem_man		(String.valueOf(ht.get("ITEM_MAN")));
		ti_bean.setCust_st		(cust_st);
		
		if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
	}
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		<%if(go_url.equals("../accid_mng2/accid_s5_frame.jsp")){%>
		fm.action = '/acar/accid_mng2/accid_s5_frame.jsp';
		<%}else{%>
//		if(fm.gubun1.value == '5')	fm.action = '/tax/issue_3/issue_3_frame5.jsp';
//		if(fm.gubun1.value == '6')	fm.action = '/tax/issue_3/issue_3_frame6.jsp';				
		fm.action = '/acar/accid_mng/accid_u_frame.jsp';				
		<%}%>
		fm.target = 'd_content';
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
<input type='hidden' name='brch_id' 	value='<%=o_br_id%>'>
<input type='hidden' name='tax_g' 		value='<%=tax_g%>'>
<input type='hidden' name='tax_bigo' 	value='<%=tax_bigo%>'>
<%if(gubun1.equals("6") || gubun1.equals("5")){%>
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
<input type='hidden' name='con_agnt_m_tel' 	value='<%=con_agnt_m_tel%>'>

  <input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">  
  <input type="hidden" name="m_id" value="<%=rent_mng_id%>">
  <input type="hidden" name="l_cd" value="<%=rent_l_cd%>">      
  <input type="hidden" name="c_id" value="<%=car_mng_id%>">  
  <input type="hidden" name="accid_id" value="<%=accid_id%>">      
  <input type="hidden" name="mode" value="8">  

</form>
<a href="javascript:go_step()">2단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생
		//이미 작성한 거래명서세 리스트 삭제
		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;%>
		alert("거래명세서 리스트 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
