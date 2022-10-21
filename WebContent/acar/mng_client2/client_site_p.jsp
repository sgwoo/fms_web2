<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.client.*, acar.util.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	
	
	Vector c_sites = al_db.getClientSites(client_id);
	int c_site_size = c_sites.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function reg_site(cmd){
		var fm = document.form1;
		fm.cmd.value = cmd;
		if(cmd == 'i'){
			if(fm.seq.value != '')		{alert('이미 등록된 사용본거지입니다');		return;	}
			if(!confirm('등록하시겠습니까?')){	return;	}
			if(fm.r_site.value == '')	{alert('사용본거지를 입력하십시오');		return;	}
		}else if(cmd == 'u'){
			if(fm.seq.value == '')		{alert('등록되지 않은 사용본거지입니다');	return;	}
			if(!confirm('수정하시겠습니까?')){	return;	}
			if(fm.r_site.value == '')	{alert('사용본거지를 입력하십시오');		return;	}
		}else{
			if(!confirm('삭제하시겠습니까?')){	return;	}
			var len = fm.elements.length;
			var cnt=0;
			var idnum="";
			for(var i=0 ; i<len ; i++){
				var ck = fm.elements[i];
				if(ck.name == 'del'){
					if(ck.checked == true){
						cnt++;
						idnum = ck.value;
					}
				}
			}
			if(cnt == 0){ alert("삭제할 사용본거지를 선택하세요."); return; }
		}
		fm.target = "i_no";		
		fm.submit();
	}

	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == "del"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}

	//상단에 디스플레이
	function UpdateDisp(seq, r_site){
		var fm = document.form1;
		fm.seq.value = seq;
		fm.r_site.value = r_site;
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>

<body onload="javascript:document.form1.r_site.focus();">

<form name='form1' method='post' action='/acar/mng_client2/client_site_i_a.jsp'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>
<input type='hidden' name='reg_id' value='<%=user_id%>'>
<input type='hidden' name='reg_dt' value='<%=Util.getDate()%>'>
<input type="hidden" name="seq" value="">
<input type="hidden" name="cmd" value="">
  <table border="0" cellspacing="0" cellpadding="0" width=320>
    <tr> 
      <td colspan='2'>거래처 : <%=firm_nm%></td>
    </tr>
    <tr> 
      <td>사용본거지 
        <input type='text' size='35' name='r_site' class='text' value='' maxlength='100' style='IME-MODE: active'>
      </td>
      <td width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td align="right">
      <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  <a href='javascript:reg_site("i")' onMouseOver="window.status=''; return true">등록</a>&nbsp;
      <%	}%>
      <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  <a href='javascript:reg_site("u")' onMouseOver="window.status=''; return true">수정</a>&nbsp;
      <%	}%>
      <%	if(auth_rw.equals("5") || auth_rw.equals("6")){%>
	  <a href='javascript:reg_site("d")' onMouseOver="window.status=''; return true">삭제</a>&nbsp;
      <%	}%>
	  <a href='javascript:close()' onMouseOver="window.status=''; return true">닫기</a></td>
      <td width="20">&nbsp;</td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=300>
          <tr> 
            <td width='60' class='title'>NO</td>
            <td class='title'>사용본거지</td>
            <td class='title' width="30"><input type="checkbox" name="all_del" value="Y" onclick='javascript:AllSelect()'></td>
          </tr>
          <%if(c_site_size > 0){
				for(int i = 0; i < c_site_size ; i++){
					ClientSiteBean site = (ClientSiteBean)c_sites.elementAt(i);%>
          <tr> 
            <td align='center' width='60'><%=i+1%></td>
            <td>&nbsp;<a href="javascript:UpdateDisp('<%=site.getSeq()%>','<%=site.getR_site()%>')"><%=Util.htmlBR(site.getR_site())%></a></td>
            <td width="30" align="center"> 
              <input type="checkbox" name="del" value="<%=site.getSeq()%>">
            </td>
          </tr>
          <%	}
			}else{%>
          <tr> 
            <td colspan='3' align='center'>등록된 데이타가 없습니다</td>
          </tr>
          <%}%>
        </table>
      </td>
      <td width='20'></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
