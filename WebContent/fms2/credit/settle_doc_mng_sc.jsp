<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//과태금 세부내용 보기
	function view_fine_doc(doc_id,gov_id){
		var fm = document.form1;
		fm.doc_id.value = doc_id;
		fm.gov_id.value = gov_id;
		fm.target = "d_content";
		fm.action = "settle_doc_mng_c.jsp";
		fm.submit();
	}
	
		// 세부내용 보기
	function view_fine_doc3(doc_id,gov_id){
		var fm = document.form1;
		fm.doc_id.value = doc_id;
		fm.gov_id.value = gov_id;
		fm.target = "d_content";
		fm.action = "settle_doc3_mng_c.jsp";
		fm.submit();
	}
	
	//수신기관 보기 
	function view_fine_gov(gov_id){
		window.open("../settle_doc_reg/fine_gov_c.jsp?gov_id="+gov_id, "view_FINE_GOV", "left=200, top=200, width=560, height=150, scrollbars=yes");
	}
	
	//출력하기
	function FineDocPrint(doc_id, title){
		var fm = document.form1;
		var SUMWIN = "";
		if ( title == '계약해지 및 납부최고' ){
			SUMWIN="cont_canel_doc_print.jsp?doc_id="+doc_id;	
		} else if ( title == '계약해지 및 차량반납 통보' ){
			SUMWIN="cont_canel_doc_print_4.jsp?doc_id="+doc_id;	
		} else if ( title == '대차료 차액분 납부최고' ){
			SUMWIN="myaccid_canel_doc_print.jsp?doc_id="+doc_id;		
		} else {
			SUMWIN="cont_canel_doc_print_5.jsp?doc_id="+doc_id;		
		}
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}
	
	
	function FineDocPrint1(doc_id, title){
		var fm = document.form1;
		var SUMWIN = "";
	
		 if ( title == '대차료 차액분 납부최고' ){
			SUMWIN="myaccid_sue_doc_print.jsp?doc_id="+doc_id;		
		}
		window.open(SUMWIN, "DocPrint", "left=50, top=50, width=750, height=600, scrollbars=yes, status=yes");			
	}

	//안내메일발송 보기
	function doc_email_view(doc_id, title){
		var fm = document.form1;
		if (title == '계약해지 및 납부최고' ) {
			fm.action="/mailing/pay/cont_cancel.jsp?doc_id="+doc_id;	
		} else if (title == '계약해지 및 차량반납 통보' ) {
			fm.action="/mailing/pay/cont_cancel_re.jsp?doc_id="+doc_id;			
	//	} else if (title == '대차료 차액분 납부최고' ) {
	//		fm.action="/mailing/pay/myaccid_cancel.jsp?doc_id="+doc_id;	
		} else {
			fm.action="/mailing/pay/cont_cancel_2.jsp?doc_id="+doc_id;				
		}
		fm.target="_blank";
		fm.submit();
	}	
	
	function label_print(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "settle_doc_label_print.jsp";
		fm.submit();
	}		
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='doc_id' value=''>
<input type='hidden' name='gov_id' value=''>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td width=100%>
      <table border="0" cellspacing="0" cellpadding="0" width=100%>
		<tr>
		    <td align='center'>
				  <iframe src="./settle_doc_mng_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort=<%=sort%>&asc=<%=asc%>" name="i_no" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
				  </iframe>
			</td>
		</tr>
	   </table>
      </td>
  </tr>
</table>
</form>
</body>
</html>
