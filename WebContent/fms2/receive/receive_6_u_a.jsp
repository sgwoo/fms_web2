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
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	int flag = 0;
	int count = 1;	
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	//기존에 등록되어 있는지 여부	
		
	ClsSuitBean cls = re_db.getClsSuitInfo(rent_mng_id, rent_l_cd);
	
	from_page = "/fms2/receive/receive_d6_frame.jsp";	
			
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd(rent_l_cd);
	cls.setReq_dt(request.getParameter("req_dt"));  //위임일자
	cls.setReq_rem(request.getParameter("req_rem")==null?"":	request.getParameter("req_rem"));// 위임업체코드
	cls.setS_type(request.getParameter("s_type")==null?"":	request.getParameter("s_type")); //위임업체명일
	cls.setSuit_dt(request.getParameter("suit_dt")==null?"":	request.getParameter("suit_dt")); //위임업체명일
	cls.setSuit_no(request.getParameter("suit_no")==null?"":	request.getParameter("suit_no")); //위임업체명일
	cls.setSuit_amt(request.getParameter("suit_amt")==null?0:			AddUtil.parseDigit(request.getParameter("suit_amt"))); //수수료
	cls.setAmt1(request.getParameter("amt1")==null?0:			AddUtil.parseDigit(request.getParameter("amt1"))); //소송비용
	cls.setUpd_id(user_id); //담당자id	
	
	System.out.println("stype:"+cls.getS_type());
	
	if(!re_db.updateClsSuit(cls))	flag += 1;
		
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
	fm.s_kd.value = '2';
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action='/fms2/receive/receive_d6_frame.jsp';
 
    fm.target='d_content';		
    fm.submit();
   <% }  %>  
    
<%	
	} %>
</script>
</body>
</html>
