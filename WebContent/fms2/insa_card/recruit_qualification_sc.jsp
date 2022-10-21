<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	InsaRcDatabase icd = new InsaRcDatabase();
	List<Insa_Rc_QfBean> list=icd.selectInsaAllQf();
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>지원자격/근무조건</span></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
   	<%	if(list.size()==0){%>
   	<tr>
		<td>-----글이 존재하지 않습니다.-----</td>
	</tr> 
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_qualification.jsp?rc_no=0', 'qfList', 'left=350, top=50, width=850, height=450, scrollbars=yes, status=yes');">등록</button>
		</td>
	</tr> 	  
	<%	}else{
			for(Insa_Rc_QfBean dto:list){
	%>    
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_qualification.jsp?rc_no=<%=dto.getRc_no()%>', 'qfList', 'left=350, top=50, width=850, height=450, scrollbars=yes, status=yes');">수정</button>
		</td>
	</tr>   
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				<input type="hidden" name="reg_id" value="<%=dto.getReg_id()%>">
				<input type="hidden" name="rc_no" value="<%=dto.getRc_no()%>">
				<input type="hidden" nmae="rc_edu" value="<%=dto.getRc_edu()%>">				
	        	<tr>
	        		<td class='title' width='20%'>학력조건</th>
	        		<td width='80%'>&nbsp;<b><%=dto.getRc_nm() %></b></td>
	        	</tr>
	        	<tr>
	        		<td class='title' width='20%'>고용형태</th>
	        		<td width='80%'>&nbsp;<%=dto.getRc_qf_var1()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>경력조건</th>
	        		<td width='80%'>&nbsp;<%=dto.getRc_qf_var2()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>임금</th>
	        		<td width='80%'>&nbsp;<%=dto.getRc_qf_var3()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>초임연봉</th>
	        		<td width='80%'>&nbsp;<%=dto.getRc_qf_var4()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>근무형태</th>
	        		<td width='80%'>&nbsp;<%=dto.getRc_qf_var5()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>근로시간</th>
	        		<td width='80%'>&nbsp;<%=dto.getRc_qf_var6()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>근무시간</th>
	        		<td width='80%'>&nbsp;<%=dto.getRc_qf_var7()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>사회보험</th>
	        		<td width='80%'>&nbsp;<%=dto.getRc_qf_var8()%></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>퇴직급여</th>
	        		<td width='80%'>&nbsp;<%=dto.getRc_qf_var9()%></td>
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
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_qualification.jsp?rc_no=0', 'qfList', 'left=350, top=50, width=850, height=450, scrollbars=yes, status=yes');">추가등록</button>
		</td>
	</tr>
	<%
	   }
	%>   
  </table>

</form>
</body>
</html>
