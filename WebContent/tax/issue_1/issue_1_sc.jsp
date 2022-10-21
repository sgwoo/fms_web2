<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.user_mng.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "09");
	
	int cnt = 2; //현황 출력 영업소 총수
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-240;//현황 라인수만큼 제한 아이프레임 사이즈
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//전체출력
	function all_tax(){
		var fm = inner.document.form1;	
		fm.reg_st.value = "all";
		fm.reg_gu.value = "1";
		if(document.form1.ebill_yn.checked == true)	fm.ebill_yn.value = 'Y';		
		fm.target = "i_no";
		fm.action = "tax_reg_step1.jsp";
		fm.submit();	
		
		fm.tax_out_dt2.value = '';									
	}
	//선택출력
	function select_tax(){
		var fm = inner.document.form1;	
		fm.reg_st.value = "select";				
		fm.reg_gu.value = "1";		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("세금계산서를 발행할 계약을 선택하세요.");
			return;
		}	
		if(document.form1.ebill_yn.checked == true)	fm.ebill_yn.value = 'Y';
		fm.target = "i_no";
		fm.action = "tax_reg_step1.jsp";
		fm.submit();	
		
		fm.tax_out_dt2.value = '';				
	}	
	
	//업체 통합선택출력
	function select_tax_case(){
		var fm = inner.document.form1;	
		fm.reg_st.value = "select";				
		fm.reg_gu.value = "2";		
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("세금계산서를 발행할 계약을 선택하세요.");
			return;
		}	
		if(document.form1.ebill_yn.checked == true)	fm.ebill_yn.value = 'Y';
		fm.tax_out_dt2.value = document.form1.tax_out_dt2.value;
		if(fm.tax_out_dt2.value == ''){ alert('통합 발행할 세금일자를 입력하십시오.'); return; }
		fm.target = "i_no";
		fm.action = "tax_reg_step1_case.jsp";
		fm.submit();	
		
		fm.tax_out_dt2.value = '';		
	}	
		
	//자동전표
	function autodocu_reg(){
		var fm = document.form1;	
		if(fm.reg_code.value == ''){ alert('등록코드가 없음.'); return;}
		fm.target = "i_no";	
		fm.action = "tax_reg_step4.jsp";
		fm.submit();						
	}	
	//메일발송
	function dmail_reg(){
		var fm = document.form1;	
		if(fm.reg_code.value == ''){ alert('등록코드가 없음.'); return;}
		fm.target = "i_no";	
		fm.action = "tax_reg_step5_2_m.jsp";
		fm.submit();						
	}		
	//트러스빌
	function ebill_reg(){
		var fm = document.form1;	
		if(fm.reg_code.value == ''){ alert('등록코드가 없음.'); return;}
		fm.target = "i_no";	
		fm.action = "tax_reg_step5_1_t.jsp";
		fm.submit();						
	}	
	
	//변경화면
	function cng_schedule(cng_st)
	{
		var fm = inner.document.form1;	
		window.open("about:blank", "CNGSCD", "left=50, top=50, width=950, height=600, scrollbars=yes");				
		fm.cng_st.value = cng_st;		
		fm.tax_out_dt.value = document.form1.tax_out_dt.value;
		if(fm.tax_out_dt.value == ''){ alert('변경할 세금일자를 입력하십시오.'); return; }
		fm.action = "fee_scd_all_cngscd.jsp";
		fm.target = "CNGSCD";
		fm.submit();
		
		fm.tax_out_dt.value = '';
	}					
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='client_mng_c.jsp' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='client_id' value=''>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='reg_gu' value='1'>
<input type='hidden' name='cng_st' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td>
	  <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
	  코드 : <input type='text' name='reg_code' value='' size='13' class=text>&nbsp;
	  <a href="javascript:autodocu_reg()"><img src="/acar/images/center/button_jdjp.gif" align="absmiddle" border="0"></a>&nbsp;
	  <a href="javascript:ebill_reg()"><img src="/acar/images/center/button_trusbill.gif" align="absmiddle" border="0"></a>&nbsp;	  
	  <a href="javascript:dmail_reg()"><img src="/acar/images/center/button_send_mail.gif" align="absmiddle" border="0"></a>&nbsp;	 
	  /&nbsp;
	  <%}%>
	  <%if(nm_db.getWorkAuthUser("회계업무",user_id)){%>
	  세금일자 : <input type='text' name='tax_out_dt' value='' size='11' class=text>&nbsp;
	  <a href="javascript:cng_schedule('tax_out_dt');"><img src=/acar/images/center/button_ch_tax.gif border=0 align=absmiddle></a>&nbsp;/&nbsp;	  
	  <%}%>
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  <input type="checkbox" name="ebill_yn" value="Y" checked>전자세금계산서&nbsp;

	   <a href="javascript:select_tax();"><img src="/acar/images/center/button_stbh.gif" align="absmiddle" border="0"></a>&nbsp;

	   <a href="javascript:all_tax();"><img src="/acar/images/center/button_jcbh.gif" align="absmiddle" border="0"></a>&nbsp;
	   
	  <%if(nm_db.getWorkAuthUser("회계업무",user_id)){%>
	  /&nbsp;세금일자 : <input type='text' name='tax_out_dt2' value='' size='10' class=text>&nbsp;
	  <a href="javascript:select_tax_case();"><img src=/acar/images/center/button_rep_all.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
	  <%}%>
	   
	  <%}%>
	  </td>
    </tr>  
    <tr> 
      <td height="<%=height%>"><iframe src="issue_1_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0></iframe></td><!--모니터높이 - sh 길이 - 상단메뉴 길이 - (라인수*40)-->
    </tr>  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
