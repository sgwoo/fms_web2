<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_tax(tax_no, idx){
		var fm = document.form1;
		fm.tax_no.value = tax_no;
		fm.idx.value = idx;
		fm.action = "tax_mng_c.jsp";
		fm.target = "d_content";		
		fm.submit();
	}
	
	function  viewTaxInvoice(pubCode){
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=680px, height=760px");
		document.form1.action="https://www.trusbill.or.kr/jsp/directTax/TaxViewIndex.jsp";
		document.form1.method="post";
		document.form1.pubCode.value=pubCode;
		document.form1.docType.value="T"; //세금계산서
		document.form1.userType.value="S"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
		document.form1.target="taxInvoice";
		document.form1.submit();
		document.form1.target="_self";
		document.form1.pubCode.value="";
		taxInvoice.focus();
		return;
	}
	
	function  viewTaxInvoice2(pubCode){
		var iMyHeight;
		width = (window.screen.width-635)/2
		if(width<0)width=0;
		iMyWidth = width; 
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=680px, height=760px");
		document.form1.action="https://www.trusbill.or.kr/jsp/directTax/TaxViewIndex.jsp";
		document.form1.method="post";
		document.form1.pubCode.value=pubCode;
		document.form1.docType.value="T"; //세금계산서
		document.form1.userType.value="R"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
		document.form1.target="taxInvoice";
		document.form1.submit();
		document.form1.target="_self";
		document.form1.pubCode.value="";
		taxInvoice.focus();
		return;
	}
	
	function  SaleEBill(ebill_st, tax_no){
		var taxInvoice = window.open("about:blank", "SaleEBill", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=750px, height=700px");
		document.form1.action="saleebill_reg.jsp";
		document.form1.method="post";
		document.form1.tax_no.value=tax_no;
		document.form1.ebill_st.value=ebill_st;		
		document.form1.target="SaleEBill";
		document.form1.submit();
		document.form1.target="_self";
		document.form1.tax_no.value="";
		document.form1.ebill_st.value="";
	}	
	
	function autodocu_reg(tax_no, idx){
		var fm = document.form1;
		fm.tax_no.value = tax_no;
		fm.idx.value = idx;
		fm.action = "tax_autodocu.jsp";
		fm.target = "i_no";
		fm.submit();
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
			
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	
	String hidden_value = "";
		
		//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "10");
			
	if(t_wd.equals("") && st_dt.equals("") && end_dt.equals("")){
	  st_dt = AddUtil.getDate();
	  end_dt = AddUtil.getDate();
	}

	hidden_value = "?auth_rw="+auth_rw+"&s_width="+s_width+"&s_height="+s_height+"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc;

	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
%>

<input type='hidden' name='tax_no' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>

<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    
    <tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./exp_reg_sc_in.jsp<%=hidden_value%>" name="RegList" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>
	
</table>

</body>
</html>
