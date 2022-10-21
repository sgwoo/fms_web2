<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.receive.*"%>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int flag = 0;
	int count = 1;	
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	//기존에 등록되어 있는지 여부	
			
	ClsBandBean cls = new ClsBandBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd(rent_l_cd);
	cls.setReq_dt(request.getParameter("req_dt"));  //위임일자
	cls.setN_ven_code(request.getParameter("n_ven_code")==null?"":	request.getParameter("n_ven_code"));// 위임업체코드
	cls.setN_ven_name(request.getParameter("n_ven_name")==null?"":	request.getParameter("n_ven_name")); //위임업체명일
	cls.setRe_rate(request.getParameter("re_rate")==null?0:			AddUtil.parseDigit(request.getParameter("re_rate"))); //수수료	
	cls.setReg_id(user_id); //담당자id	
		
	cls.setRe_dept(request.getParameter("re_dept")==null?"":request.getParameter("re_dept"));
	cls.setRe_nm(request.getParameter("re_nm")==null?"":request.getParameter("re_nm"));
	cls.setRe_fax(request.getParameter("re_fax")==null?"":request.getParameter("re_fax"));
	cls.setRe_tel(request.getParameter("re_tel")==null?"":request.getParameter("re_tel"));
	cls.setRe_phone(request.getParameter("re_phone")==null?"":request.getParameter("re_phone"));
	cls.setRe_mail(request.getParameter("re_mail")==null?"":request.getParameter("re_mail"));
	cls.setBank_cd(request.getParameter("bank_cd")==null?"":request.getParameter("bank_cd"));
	cls.setBank_nm(request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm"));
	cls.setBank_no(request.getParameter("bank_no")==null?"":request.getParameter("bank_no"));
	cls.setRe_bank_cd(request.getParameter("re_bank_cd")==null?"":request.getParameter("re_bank_cd"));
	cls.setRe_bank_nm(request.getParameter("re_bank_nm")==null?"":request.getParameter("re_bank_nm"));
	cls.setRe_bank_no(request.getParameter("re_bank_no")==null?"":request.getParameter("re_bank_no"));	
	cls.setBand_amt(request.getParameter("band_amt")==null?0:			AddUtil.parseDigit(request.getParameter("band_amt")));
	cls.setBasic_dt(request.getParameter("basic_dt")==null?"":		request.getParameter("basic_dt"));
	cls.setNo_re_amt(request.getParameter("no_re_amt")==null?0:	AddUtil.parseDigit(request.getParameter("no_re_amt")));
	cls.setCar_jan_amt(request.getParameter("car_jan_amt")==null?0:	AddUtil.parseDigit(request.getParameter("car_jan_amt")));
	cls.setTot_amt(request.getParameter("tot_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tot_amt")));
	cls.setRe_st(request.getParameter("re_st")==null?"":				request.getParameter("re_st"));           //미회수차량 위임방법
	cls.setRemarks(request.getParameter("remarks")==null?"":				request.getParameter("remarks"));         //미회수차량 위임방법
	
	if(!re_db.insertClsBand(cls))	flag += 1;
		
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
%>
<form name='form1'  method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>

<script language='javascript'>
	

<%	if(flag != 0){ 	//채권추심테이블에 저장 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//채권추심테이블에 저장 성공.. %>
	
    alert('처리되었습니다');		
   
  <% if ( from_page.equals("/fms2/receive/receive_7_i.jsp") ) { %>
    	
	parent.close();				
  
    <% } else { %>
    	var fm = document.form1;	
	fm.s_kd.value = '5';
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action='/fms2/receive/receive_d7_frame.jsp';
 
    fm.target='d_content';		
    fm.submit();
   <% }  %>  
    
<%	
	} %>
</script>
</body>
</html>
