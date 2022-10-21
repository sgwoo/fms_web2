<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//신용조회 대체키(개인) 조회하기
	
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"0":request.getParameter("gubun5");	
	
	Vector vt = new Vector();
	int vt_size = 0;
		
	if(!gubun2.equals("")){
		vt = a_db.getContEvalKeyList(gubun1, gubun2, gubun3);
		vt_size = vt.size();
	}
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;			
		if(fm.gubun2.value == '')		{ alert('생년월일을 입력하십시오.'); 	return;}
		if(fm.gubun2.value.length < 6 || fm.gubun2.value.length > 6)		{ alert('생년월일을 확인하십시오.'); 	return;}		
		fm.submit();
	}
	
	//셋팅
	function set_eval_key(key_nice, key_kcb){		
		opener.document.form1.key_nice.value 		= key_nice;
		opener.document.form1.key_kcb.value 		= key_kcb;
		self.close();
	}	
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.gubun1.focus();">
<p>
<form name='form1' action='search_eval_key.jsp' method='post'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>신용조회 대체키 조회</span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>
    <tr>
	<td>&nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 성명 :	
	    <input type='text' name='gubun1' size='15' class='text' value='<%=gubun1%>' style='IME-MODE: active'>
	    &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 생년월일 :
	    <input type='text' name='gubun2' size='15' class='text' value='<%=gubun2%>' style='IME-MODE: active'> (-빼고, 6자리)
	    &nbsp;&nbsp;<img src=/acar/images/center/arrow.gif> 휴대폰번호 :
	    <input type='text' name='gubun3' size='15' class='text' value='<%=gubun3%>' style='IME-MODE: active'>
	    &nbsp;&nbsp;
	    <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>
    <tr>
	<td class=line2></td>		
    </tr>
    <tr>
	<td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="5%" class='title'>연번</td>
                    <td width="25%" class='title'>성명</td>
                    <td width="16%" class='title'>생년월일</td>
                    <td width="18%" class='title'>휴대폰번호</td>
                    <td width="18%" class='title'>NICE</td>		  
                    <td width="18%" class='title'>KCB</td>                    
                </tr>
                <%if(vt_size > 0){
                	for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ht.get("NAME")%></td>		  
                    <td align='center'><%=ht.get("BIRTH_DT")%></td>
                    <td align='center'><%=ht.get("M_TEL")%></td>
                    <td align='center'>
                    <%if(from_page.equals("/acar/sms_gate/v5_sms_cre_i2.jsp")){%>
                    <a href="javascript:set_eval_key('<%=ht.get("KEY_NICE")%>','<%=ht.get("KEY_KCB")%>')" onMouseOver="window.status=''; return true">
                    <%}%>
                    <%=ht.get("KEY_NICE")%>
                    <%if(from_page.equals("/acar/sms_gate/v5_sms_cre_i2.jsp")){%>
                    </a>
                    <%}%>                    
                    </td>
                    <td align='center'>
                    <%if(from_page.equals("/acar/sms_gate/v5_sms_cre_i2.jsp")){%>
                    <a href="javascript:set_eval_key('<%=ht.get("KEY_NICE")%>','<%=ht.get("KEY_KCB")%>')" onMouseOver="window.status=''; return true">
                    <%}%>
                    <%=ht.get("KEY_KCB")%>
                    <%if(from_page.equals("/acar/sms_gate/v5_sms_cre_i2.jsp")){%>
                    </a>
                    <%}%>                    
                    </td>
                </tr>    				
    		<%	}
    		  }else{%>		
                <tr> 
                    <td align='center' colspan='6'>검색된 결과가 없습니다.</td>
                </tr>    				    		  
    		<%}%>  
            </table>
        </td>
	</tr>
	<tr>
	    <td></td>
	</tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>