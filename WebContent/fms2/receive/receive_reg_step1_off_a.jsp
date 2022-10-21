<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="java.util.*, acar.util.*,  acar.receive.*"%>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int flag = 0;
	int count = 1;	
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
%>

<%
	String cons_no	 	= "";

	String n_ven_code	 	= request.getParameter("n_ven_code")==null?"":request.getParameter("n_ven_code");
	String n_ven_name	 	= request.getParameter("n_ven_name")==null?"":request.getParameter("n_ven_name");
	String re_rate	 	= request.getParameter("re_rate")==null?"":request.getParameter("re_rate");
	String re_dept	 	= request.getParameter("re_dept")==null?"":request.getParameter("re_dept");
	String re_nm	 	= request.getParameter("re_nm")==null?"":request.getParameter("re_nm");
	String re_fax	 	= request.getParameter("re_fax")==null?"":request.getParameter("re_fax");
	String re_tel	 	= request.getParameter("re_tel")==null?"":request.getParameter("re_tel");
	String re_phone	 	= request.getParameter("re_phone")==null?"":request.getParameter("re_phone");		
	String re_mail	 	= request.getParameter("re_mail")==null?"":request.getParameter("re_mail");
	
	String bank_cd	 	= request.getParameter("bank_cd")==null?"":request.getParameter("bank_cd");
	String bank_nm	 	= request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm");
	String bank_no	 	= request.getParameter("bank_no")==null?"":request.getParameter("bank_no");
	String re_bank_cd	 	= request.getParameter("re_bank_cd")==null?"":request.getParameter("re_bank_cd");
	String re_bank_nm	 	= request.getParameter("re_bank_nm")==null?"":request.getParameter("re_bank_nm");
	String re_bank_no	 	= request.getParameter("re_bank_no")==null?"":request.getParameter("re_bank_no");
	String req_dt	 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");	
		
	int size = request.getParameter("size")==null?0:AddUtil.parseDigit(request.getParameter("size"));
			

	String today	 	= AddUtil.getDate();
	int    after_cnt	= 0;
			
	String rent_mng_id	[] 		= request.getParameterValues("rent_mng_id");
	String rent_l_cd	[] 		= request.getParameterValues("rent_l_cd");
	String band_amt		[] 		= request.getParameterValues("band_amt");
	String basic_dt		[] 		= request.getParameterValues("basic_dt");

	
	//1. 추심의뢰 등록----------------------------------------------------------------------------------------	
		
	for(int i=0; i<size; i++){

		ClsBandBean cls = new ClsBandBean();
		
		cls.setRent_mng_id		(rent_mng_id  	[i] ==null?"": rent_mng_id  	[i]);
		cls.setRent_l_cd		(rent_l_cd    	[i] ==null?"": rent_l_cd    	[i]);
		cls.setReq_dt(req_dt);  //위임일자
		cls.setN_ven_code(n_ven_code);// 위임업체코드
		cls.setN_ven_name(n_ven_name); //위임업체명일
		cls.setRe_rate(25); //수수료	
		cls.setReg_id(user_id); //담당자id	
			
		cls.setRe_dept(re_dept);
		cls.setRe_nm(re_nm);
		cls.setRe_fax(re_fax);
		cls.setRe_tel(re_tel);
		cls.setRe_phone(re_phone);
		cls.setRe_mail(re_mail);
		cls.setBank_cd(bank_cd);
		cls.setBank_nm(bank_nm);
		cls.setBank_no(bank_no);
		cls.setRe_bank_cd(re_bank_cd);
		cls.setRe_bank_nm(re_bank_nm);
		cls.setRe_bank_no(re_bank_no);	
		cls.setBasic_dt	(basic_dt   	[i] ==null?"": basic_dt    	[i]); //해지일 
		cls.setBand_amt(AddUtil.parseInt(band_amt[i]) ); //채권 
		cls.setTot_amt(AddUtil.parseInt(band_amt[i]) ); //채권 
			
		if(!re_db.insertClsBand(cls))	flag += 1;
		
	}
%>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    

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

    fm.action='/fms2/receive/receive_d7_frame.jsp';
 
    fm.target='d_content';		
    fm.submit();
   <% }  %>  
    
<%	
	} %>
</script>
</body>
</html>
