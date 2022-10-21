<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>


<%
	String s_width = request.getParameter("s_width")==null?"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");
	String sh_height = request.getParameter("sh_height")==null?"":request.getParameter("sh_height");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String t_wd1 = request.getParameter("t_wd1")==null?"":request.getParameter("t_wd1");
	String t_wd2 = request.getParameter("t_wd2")==null?"":request.getParameter("t_wd2");
	String s_br = request.getParameter("s_br")==null?"":request.getParameter("s_br");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");
	String gubun8 = request.getParameter("gubun8")==null?"":request.getParameter("gubun8");
	String chk1 = request.getParameter("chk1")==null?"":request.getParameter("chk1");
	String chk2 = request.getParameter("chk2")==null?"":request.getParameter("chk2");
	String chk3 = request.getParameter("chk3")==null?"":request.getParameter("chk3");
	String chk4 = request.getParameter("chk4")==null?"":request.getParameter("chk4");
	String chk5 = request.getParameter("chk5")==null?"":request.getParameter("chk5");
	String chk6 = request.getParameter("chk6")==null?"":request.getParameter("chk6");
	String chk7 = request.getParameter("chk7")==null?"":request.getParameter("chk7");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"1":request.getParameter("idx");
	
	String cgs_ok = request.getParameter("cgs_ok")==null?"":request.getParameter("cgs_ok");  //추가
	String dggj_ok = request.getParameter("dggj_ok")==null?"":request.getParameter("dggj_ok"); //추가
	
	String hidden_value = "?s_width="+s_width+"&s_height="+s_height+"&auth_rw="+auth_rw+"&s_kd="+s_kd+"&t_wd="+t_wd+"&t_wd1="+t_wd1+"&t_wd2="+t_wd2+"&s_br="+s_br+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+"&gubun7="+gubun7+"&gubun8="+gubun8+"&chk1="+chk1+"&chk2="+chk2+"&chk3="+chk3+"&chk4="+chk4+"&chk5="+chk5+"&chk6="+chk6+"&chk7="+chk7+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+"&idx="+idx;
	
	
	
	String reg_st 		= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");//all-전체발행,select선택발행
	String reg_gu 		= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-일괄발행,2-통합발행,3-개별발행
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":AddUtil.replace(request.getParameter("tax_out_dt"),"-","");//세금일자
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String tax_code 	= request.getParameter("tax_code")==null?"":request.getParameter("tax_code");
	String sender_nm 	= request.getParameter("sender_nm")==null?"":request.getParameter("sender_nm");
	
	String ebill_yn 	= request.getParameter("ebill_yn")==null?"N":request.getParameter("ebill_yn");//트러스빌사용여부
	String tax_out_dt2 	= request.getParameter("tax_out_dt2")==null?"":request.getParameter("tax_out_dt2");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	
	
	//프로시저 호출
	int flag4 = 0;
	String  d_flag1 =  ad_db.call_sp_tax_ebill_etc(sender_nm, reg_code);
	if (!d_flag1.equals("0")) flag4 = 1;
	System.out.println(" 기타 세금계산서 프로시저 등록 "+reg_code);
	System.out.println(d_flag1);
	System.out.println(AddUtil.getDate());
%>
<html><head><title>FMS</title>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.reg_gu.value == '1')		fm.action = '/tax/issue_1/issue_1_frame.jsp';
		if(fm.reg_gu.value == '2')		fm.action = '/tax/issue_2/issue_2_frame.jsp';
		if(fm.reg_gu.value == '3_1')		fm.action = '/tax/issue_3/issue_3_frame1.jsp';
		if(fm.reg_gu.value == '3_2')		fm.action = '/tax/issue_3/issue_3_frame2.jsp';
		if(fm.reg_gu.value == '3_3')		fm.action = '/tax/issue_3/issue_3_frame3.jsp';
		if(fm.reg_gu.value == '3_4')		fm.action = '/tax/issue_3/issue_3_frame4.jsp';
		if(fm.reg_gu.value == '3_5')		fm.action = '/tax/issue_3/issue_3_frame5.jsp';
		if(fm.reg_gu.value == '3_6')		fm.action = '/tax/issue_3/issue_3_frame6.jsp';
		if(fm.reg_gu.value == '3_7')		fm.action = '/tax/issue_3/issue_3_frame7.jsp';
		if(fm.reg_gu.value == '3_8')		fm.action = '/tax/issue_3/issue_3_frame8.jsp';
		if(fm.reg_gu.value == '3_9' && fm.go_url.value != '')	fm.action = 'http://fms1.amazoncar.co.kr<%=go_url%>';
		if(fm.reg_gu.value == '3_9' && fm.go_url.value == '')	fm.action = '/tax/issue_3/issue_3_frame9.jsp';		
		if(fm.reg_gu.value == 'tax_mng_eu')	fm.action = '/tax/tax_mng/tax_mng_frame.jsp';		
		if(fm.reg_gu.value == '6')		fm.action = '/tax/issue_6/issue_6_frame.jsp';				
		if(fm.reg_gu.value == '7')		fm.action = '/tax/issue_7/issue_7_frame.jsp';				
		
		if(fm.tax_out_dt2.value != '')		fm.action = '/tax/issue_1/issue_1_frame.jsp';
		
		if(fm.action == '')			fm.action = '/tax/issue_1/issue_1_frame.jsp';
		
		fm.target = 'd_content';	
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' target='d_content' method="POST">
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' value='<%=t_wd%>'>
  <input type='hidden' name='t_wd1' value='<%=t_wd1%>'>
  <input type='hidden' name='t_wd2' value='<%=t_wd2%>'>
  <input type='hidden' name='s_br' value='<%=s_br%>'>
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' value='<%=gubun5%>'>
  <input type='hidden' name='gubun6' value='<%=gubun6%>'>  
  <input type='hidden' name='chk1' value='<%=chk1%>'>
  <input type='hidden' name='chk2' value='<%=chk2%>'>
  <input type='hidden' name='chk3' value='<%=chk3%>'>
  <input type='hidden' name='chk4' value='<%=chk4%>'>
  <input type='hidden' name='chk5' value='<%=chk5%>'>  
  <input type='hidden' name='chk6' value='<%=chk6%>'>  
  <input type='hidden' name='chk7' value='<%=chk7%>'>      
  <input type='hidden' name='st_dt' value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <input type='hidden' name='sort' value='<%=sort%>'>
  <input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='reg_st' 		value='<%=reg_st%>'>
<input type='hidden' name='reg_gu' 		value='<%=reg_gu%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='ebill_yn' 	value='<%=ebill_yn%>'>
<input type='hidden' name='tax_out_dt2' value='<%=tax_out_dt2%>'>

</form>
<script language='javascript'>
<!--
<%	if(flag4 > 0){//에러발생%>
		alert("거래명세서 이메일 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>	
		if(document.form1.reg_gu.value == 'tax_mng_eu'){
			alert("정상처리되었습니다. 계산서가 변경되었으니 네오엠 전표를 확인하세요.");
		}else{	
			alert("정상발급!!");
		}
		go_step();
		
<%	}%>
//-->	
</script>
</body>
</html>