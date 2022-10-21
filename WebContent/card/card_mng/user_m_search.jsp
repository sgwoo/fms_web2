
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String nm = request.getParameter("nm")==null?"":request.getParameter("nm");
	//String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	
	Vector vt = new Vector();
	
	//카드종류 리스트 조회
	if (dept_id.equals("9999") ) {
		vt = CardDb.getUserSearchList("", dept_id, t_wd, "N");
	}else if (dept_id.equals("AAAA") ) {
		vt = CardDb.getUserSearchList("", "", "AA", use_yn);
	}else if (dept_id.equals("TTTT") ) {
		vt = CardDb.getUserSearchList("", "", "TT", use_yn);
	} else {
		if(t_wd.equals("")){
			vt = CardDb.getUserSearchList("", dept_id, t_wd, use_yn);
		}else{
			vt = CardDb.getUserSearchList("", dept_id, t_wd, "");
		}
	}	
	int vt_size = vt.size();
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="user_m_search.jsp";
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
	
	//등록하기
	function save(){
		fm = document.form1;
		var idx = toInt(fm.idx.value);	
			
		var len=fm.elements.length;
		var cnt=0;
		var clen=0;
		var idnum="";
		var id="";
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
					id = ck.value.substring(0,6);
					idnm = ck.value.substring(7, clen);
				//	alert("id="+ id + ":idnm="+idnm + ":k=" + k);
				    setCode1(id, idnm, idx-1, cnt);
				    idx=idx+1;
			
				}
			}
			
		}	
		opener.cng_input1('0');
		window.close();
	
	}	
	
	
	function setCode1(code, name, idx1, cnt){
	 //   alert("setid="+ code + ":setidnm="+name + ":setk=" + idx1);	
	
		opener.form1.user_case_id[idx1].value 	= code;				
		opener.form1.user_nm[idx1+1].value 		= name;		
		opener.form1.dept_id[idx1].value 		= '<%=dept_id%>';
		opener.form1.r_dept_id[idx1].value 		= '<%=dept_id%>';		
		opener.form1.user_su.value 				= cnt;	
	}
	
//-->
</script>


</head>
<body>
<form action="./user_m_search.jsp" name="form1" method="POST">
  <input type='hidden' name='nm' value='<%=nm%>'>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="use_yn" value="<%=use_yn%>"> 
  <input type="hidden" name="go_url" value="<%=go_url%>">
  <input type="hidden" name="dept_id" value="<%=dept_id%>">
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
      <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_sm.gif align=absmiddle>&nbsp;
        <input name="t_wd" type="text" class="text" value="" size="20" onKeyDown="javasript:enter()" style='IME-MODE: active'>
        &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr><td class=line2></td></tr>
    <tr>
      <td class="line" >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>연번</td>
            <td width='10%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
            <td width='35%' class='title'>코드</td>
            <td width='45%' class='title'>이름</td>
          </tr>
          <%if(vt_size > 0){
				for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>			
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><input name="uid" type="checkbox" value="<%=ht.get("USER_ID")%>^<%=ht.get("USER_NM")%>" ></td>
            <td align="center">
			<%=ht.get("USER_ID")%>
			</td>
            <td align="center"><%=ht.get("USER_NM")%></td>
          </tr>
		  <%	}%>
		  <%}else{%>
          <tr>		  
            <td colspan="4" align="center">등록된 데이타가 없습니다.</td>
          </tr>
		  <%}%>		  
        </table>
	</td>
  </tr>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td align="right">
       <a href="javascript:save();"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a> 
      	&nbsp;
	  <a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
  </table>
</form>
</body>
</html>

