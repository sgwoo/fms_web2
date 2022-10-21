<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*,acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	InsaRcDatabase icd = new InsaRcDatabase();

	List<Insa_Rc_rcBean> list=icd.selectInsaRcAll();
	
	int count = 0;
	
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
<style type="text/css">
	td{text-align: center;}
</style>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width="1280">
    <tr>
	    <td style="float:left"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채용공고</span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr><td class=line2></td></tr>
	<tr>
    	<td class="line" width='1280'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				<tr>
		        	<td class='title'>언변</td>		         
		         	<td class='title'>채용공고</td>
		         	<td class='title'>접수마감일</td>
		         	<td class='title'>작성자</td>
		         	<td class='title'>작성일</td>
		      	</tr>  
		      	<%
				   	if(list.size()==0){
			  	%>
			   	<tr>
					<td colspan="5">-----글이 존재하지 않습니다.-----</td>
				</tr>   				   
				<%
				   	}else{
				      	for(Insa_Rc_rcBean dto:list){
				      		
				      		count++;
				%>
				<tr>
					<td><%=count%></td>				      
				    <td style="text-align:left; margin-left:10px;"><a href="recruit_notice.jsp?rc_no=<%=dto.getRc_no()%>" target='_self'><%=dto.getRc_branch() %> <%=dto.getRc_nm() %> <%=dto.getRc_hire_per() %>명</a></td>
				    <td><%=AddUtil.ChangeDate2(dto.getRc_apl_ed_dt()) %></td> 
				    <td><%=dto.getReg_name() %></td>
				    <td><%=dto.getRc_reg_dt() %></td>
				</tr>
				<%
				      	}
				   	}
				%>
            </table>
	    </td>
    </tr>
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_write.jsp?rc_no=0', 'qfList', 'left=350, top=50, width=850, height=800, scrollbars=yes, status=yes');">등록</button>
		</td>
	</tr>     
    <tr> 
        <td class=h></td>
    </tr>  	  
  </table>
  
  <br>
</form>
</body>
</html>
