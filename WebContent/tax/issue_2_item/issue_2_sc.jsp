<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "10");
	
	int cnt = 3; //현황 출력 영업소 총수
	//if(cnt > 0 && cnt < 5) cnt = 5; //기본 
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-250;//현황 라인수만큼 제한 아이프레임 사이즈
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
		fm.reg_gu.value = "2";
		fm.mail_auto_yn.value = document.form1.mail_auto_yn.value;
		if(confirm('청구서를 전체 발행하시겠습니까?')){
			fm.target = "i_no";
			fm.action = "tax_reg_step1.jsp";
			fm.submit();					
		}
	}
	
	//선택출력
	function select_tax(){
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
		
		fm.mail_auto_yn.value = document.form1.mail_auto_yn.value;
		
		if(confirm('청구서를 선택 발행하시겠습니까?')){
			fm.target = "i_no";
			fm.action = "tax_reg_step1.jsp";
			fm.submit();	
		}
	}

	//업체별 스케줄 확인
	function ClientTaxScd(client_id, site_id, r_req_dt, tax_out_dt, s_st){
		var fm = document.form1;
		var SUBWIN="issue_2_client_scd.jsp?client_id="+client_id+"&site_id="+site_id+"&r_req_dt="+r_req_dt+"&tax_out_dt="+tax_out_dt+"&s_st="+s_st;	
		window.open(SUBWIN, "ClientTaxScd", "left=100, top=100, width=900, height=300, scrollbars=yes, status=yes");
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td>
	      <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	      <select name="mail_auto_yn">
        <option value="Y">거래명세서 발행시 메일 자동발송</option>
        <option value="N">거래명세서 발행후 메일 수동발송</option>
        </select>
		    <a href="javascript:select_tax();"><img src="/acar/images/center/button_stbh.gif" align="absmiddle" border="0"></a>&nbsp;
		    <a href="javascript:all_tax();"><img src="/acar/images/center/button_jcbh.gif" align="absmiddle" border="0"></a>&nbsp;
	      <%}%>
	    </td>
    </tr>  
    <tr> 
      <td height="<%=height%>"><iframe src="issue_2_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
