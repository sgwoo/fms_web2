<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	InsaRcDatabase icd = new InsaRcDatabase();

	//코드 리스트 - 직종
	Vector vt_job = icd.getList("1");
	int vt_size = vt_job.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function modifyInfo(theURL,winName,features) { 
		window.open(theURL,winName,features);
	}
//-->	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form2' action='' method='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width="800">
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>직종</span></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
   	<%	if(vt_size==0){%>
   	<tr>
		<td>-----글이 존재하지 않습니다.-----</td>
	</tr> 
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_code.jsp?rc_gubun=1&rc_code=0', 'qfList', 'left=350, top=50, width=850, height=200, scrollbars=yes, status=yes');">등록</button>
		</td>
	</tr> 	  
	<%	}else{
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt_job.elementAt(i);			
	%>    
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_code.jsp?rc_gubun=1&rc_code=<%=ht.get("RC_CODE")%>', 'qfList', 'left=350, top=50, width=850, height=200, scrollbars=yes, status=yes');">수정</button>
		</td>
	</tr>   
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				<input type="hidden" name="rc_gubun" value="<%=ht.get("RC_GUBUN")%>">
				<input type="hidden" name="rc_code" value="<%=ht.get("RC_CODE")%>">
	        	<tr>
	        		<td class='title' width='20%'>직종</th>
	        		<td width='80%'>&nbsp;<b><%=ht.get("RC_NM")%></b></td>
	        	</tr>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	  
    <%
	     }
	%>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_code.jsp?rc_gubun=1&rc_code=0', 'qfList', 'left=350, top=50, width=850, height=200, scrollbars=yes, status=yes');">추가등록</button>
		</td>
	</tr>
	<%
	   }
	%>   
    <tr>
        <td class=h></td>
    </tr> 
    <tr>
        <td><hr></td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>
  
<%  
  	//코드 리스트 - 학력조건
	vt_job = icd.getList("2");
	vt_size = vt_job.size();
%>	
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>학력조건</span></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
   	<%	if(vt_size==0){%>
   	<tr>
		<td>-----글이 존재하지 않습니다.-----</td>
	</tr> 
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_code.jsp?rc_gubun=2&rc_code=0', 'qfList', 'left=350, top=50, width=850, height=600, scrollbars=yes, status=yes');">등록</button>
		</td>
	</tr> 	  
	<%	}else{
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt_job.elementAt(i);			
	%>    
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_code.jsp?rc_gubun=2&rc_code=<%=ht.get("RC_CODE")%>', 'qfList', 'left=350, top=50, width=850, height=600, scrollbars=yes, status=yes');">수정</button>
		</td>
	</tr>   
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				<input type="hidden" name="rc_gubun" value="<%=ht.get("RC_GUBUN")%>">
				<input type="hidden" name="rc_code" value="<%=ht.get("RC_CODE")%>">
	        	<tr>
	        		<td class='title' width='20%'>학력조건</th>
	        		<td width='80%'>&nbsp;<b><%=ht.get("RC_NM")%></b></td>
	        	</tr>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	  
    <%
	     }
	%>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_code.jsp?rc_gubun=2&rc_code=0', 'qfList', 'left=350, top=50, width=850, height=600, scrollbars=yes, status=yes');">추가등록</button>
		</td>
	</tr>
	<%
	   }
	%>   
  </table>
</form>
</body>
</html>
