
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String nm = request.getParameter("nm")==null?"":request.getParameter("nm");
	//String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String reg_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	String ud_id = request.getParameter("ud_id")==null?"":request.getParameter("ud_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	
	Vector vtp = CardDb.getUserSearchListPP(user_id, "", "", "PP", use_yn);
	int vtp_size = vtp.size();
	
	Vector vt = CardDb.getUserSearchListCD("", "", "AA", use_yn);
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="user_m_search2.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	
	function setCode(code, name){
		var fm = document.form1;	
		var idx = toInt(fm.idx.value);	
		
		if(fm.nm.value == 'user_case_id'){
			opener.form1.<%=nm%>[idx-1].value 		= code;				
		}else{
			opener.form1.<%=nm%>.value 				= code;		
		}	

		if(fm.idx.value != ''){
			opener.form1.user_nm[idx].value 		= name;		
		}else{
			opener.form1.user_nm.value 				= name;					
		}
			
		if(fm.go_url.value != ''){
			opener.parent.cd_foot.location.href = fm.go_url.value+'?<%=nm%>='+code;
		}
		window.close();
	}
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "uid"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}
	
	//추가하기
	function plus(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];	
			if(ck.name == "uid2"){		
					idnum=ck.value;
			}
			
		}
//alert(idnum);		
		fm.target = "i_no";
		fm.action = "user_m_search2_a.jsp?";
		
		fm.submit();
	}
	
	
	//등록하기
	function save(){
		fm = document.form1;
		var idx = toInt(fm.idx.value);	
			
		var len=fm.elements.length;
		var cnt=0;
		var clen=0;
		var idnum="";
		var id="";
		var de_code="";
		var idnm="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "uid"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("직원을 선택하세요.");
			return;
		}	
				
		if(!confirm("선택하시겠습니까?"))	return;
		
	
		for(var j=0 ; j<len ; j++){
			var ck=fm.elements[j];		
			if(ck.name == "uid"){		
				if(ck.checked == true){
					clen=get_length(ck.value);
					de_code = ck.value.substring(0,4)
					id = ck.value.substring(5,11);
					idnm = ck.value.substring(12, clen);
//					alert("id="+ id);
				    setCode1(de_code, id, idnm, idx-1, cnt);
				    idx=idx+1;
	//	alert(de_code);	
				}
			}
			
		}	
		opener.cng_input1('0');
		window.close();
	
	}	
	
	
	function setCode1(de_code, code, name, idx1, cnt){
	 //   alert("setid="+ code + ":setidnm="+name + ":setk=" + idx1);	
	//	alert(code);	
		opener.form1.user_case_id[idx1].value 	= code;				
		opener.form1.user_nm[idx1].value 		= name;		
		opener.form1.dept_id[idx1].value 		= de_code;
		opener.form1.r_dept_id[idx1].value 		= de_code;		
		opener.form1.user_su.value 				= cnt;
//		opener.form1.dept_id[idx1].value 		= '<%=dept_id%>';
//		opener.form1.r_dept_id[idx1].value 		= '<%=dept_id%>';		
	}
	
	
	function part_del(u_id){
		var fm = document.form1;
		fm.ud_id.value = u_id;
		fm.cmd.value = 'd';
		fm.target = "i_no";		
		fm.action = "user_m_search2_a.jsp?";
		fm.submit();
	}
	
	//새로고침
	function self_reload(){
		var fm = document.form1;
		fm.target = "_self";		
		fm.action = "user_m_search2.jsp?";
		fm.submit();
	}	
//-->
</script>


</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
  <input type='hidden' name='nm' value='<%=nm%>'>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="use_yn" value="<%=use_yn%>"> 
  <input type="hidden" name="go_url" value="<%=go_url%>">
  <input type="hidden" name="dept_id" value="<%=dept_id%>">
  <input type="hidden" name="ud_id" value="">
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="cmd" value="">
 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    	<tr>
		<td >
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>재무회계 > 법인전표관리 > <span class=style5>파트너관리</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
	<tr> 
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 파트너 리스트</td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr>
		<td class="line" >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='15%' class='title'>연번</td>
					<td width='15%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
					<td width='20%' class='title'>코드</td>
					<td width='30%' class='title'>이름</td>
					<td width='20%' class='title'>-</td>					
			</tr>
			<%if(vtp_size > 0){
				for (int i = 0 ; i < vtp_size ; i++){
					Hashtable htp = (Hashtable)vtp.elementAt(i);%>			
			<tr>
				<td align="center"><%=i+1%></td>
			<input type="hidden" name="user_su" value="<%=vtp_size%>">
			<input type="hidden" name="dept_id" value="<%=htp.get("DEPT_ID")%>">
            <td align="center"><input name="uid" type="checkbox" value="<%=htp.get("DEPT_ID")%>^<%=htp.get("USER_ID")%>^<%=htp.get("USER_NM")%>" <%if(dept_id.equals("PPPP")){%>checked<%}%> ></td>
            <td align="center"><%=htp.get("USER_ID")%></td>
            <td align="center"><%=htp.get("USER_NM")%></td>
            <td align="center"><%if(dept_id.equals("PPPP")){%><a href="javascript:part_del('<%=htp.get("USER_ID")%>');"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a><%}%></td>			
			</tr>
			<%	}%>
			<%}else{%>
			<tr>		  
				<td colspan="5" align="center">등록된 데이타가 없습니다.</td>
			</tr>
			<%}%>		  
			</table>
		</td>
	</tr>
	<tr>
		<td align="right">
			<a href="javascript:save();"><img src=/acar/images/center/button_conf.gif border=0 align=absmiddle></a>
			&nbsp;
			<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
		</td>
	</tr>
	<tr><td class=h></td></tr>
	<tr> 
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> 파트너 등록</td>
    </tr>
    <tr><td class=line2></td></tr>
	<tr>
		<td class="line" >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='45%' class='title'>추가할 파트너 이름</td>
				</tr>
				<tr>
					<td align="center">
						<select name='uid2'>	
							<%	for (int i = 0 ; i < vt_size ; i++){
								Hashtable ht = (Hashtable)vt.elementAt(i);%>			
								<option value='<%=ht.get("USER_ID")%>^<%=reg_id%>'><%=ht.get("USER_NM")%></option>
							<%}%>
						</select>&nbsp;&nbsp;<a href="javascript:plus();"><img src=/acar/images/center/button_in_plus.gif border=0 align=absmiddle></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
		<td class=h></td>
    </tr>
	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>

