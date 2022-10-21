<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%	
	int rc_no=Integer.parseInt(request.getParameter("rc_no"));

	InsaRcDatabase icd = new InsaRcDatabase();
	Insa_Rc_InfoBean dto = icd.InsaRcselectOne(rc_no);
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function infoCan(){ 
		opener.window.location='recruit_comInfo_sc.jsp';
		close();
	}
//-->	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='' action='recruit_comInfo_up.jsp' method='post' target='cominfoList'>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width="800">
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ȸ�簳��</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				<input type="hidden" name="rc_no" value="<%=dto.getRc_no()%>">
	        	<tr>
	        		<td class='title' width='20%'>��������</th>
	        		<td width='40%'>&nbsp;<input type="text" name="rc_cur_dt" size='4' value="<%=dto.getRc_cur_dt()==null?AddUtil.getDate2(1)-1:dto.getRc_cur_dt()%>"/> ��12��31��</td>
	        		<td width='40%'></td>
	        	</tr>          
	        	<tr>
	        		<td class='title' width='20%'>�ں��Ѱ�</th>
	        		<td width='40%'>&nbsp;<input type="text" name="rc_tot_capital" size='4' value="<%=dto.getRc_tot_capital() %>" onBlur='javascript:this.value=parseDecimal(this.value);'/> ���</td>
	        		<td width='40%'></td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>�ڻ��Ѱ�</th>
	        		<td width='40%'>&nbsp;<input type="text"  name="rc_tot_asset" size='4' value="<%=dto.getRc_tot_asset()%>" onBlur='javascript:this.value=parseDecimal(this.value);'/> ���</td>
	        		<td width='40%'></td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>�����</th>
	        		<td width='40%'>&nbsp;<input type="text" name="rc_sales" size='4' value="<%=dto.getRc_sales()%>" onBlur='javascript:this.value=parseDecimal(this.value);'/> ���</td>
	        		<td width='40%'>&nbsp;�����Ѿ�</td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>��������Ȳ</th>
	        		<td width='40%'>&nbsp;<input type="text" name="rc_per_off" size='2' value="<%=dto.getRc_per_off()%>"> ��</td>
	        		<td width='40%'>&nbsp;10���̻� �ټ��� (<input type="text" name="rc_per_off_per" size='2' value="<%=dto.getRc_per_off_per()%>"> %)</td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>�ּ�/����ó</th>
	        		<td width='40%' colspan="2">&nbsp;Ȩ����������</td>
	        	</tr>  
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	  
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ȳ</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%' >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>          
                <tr>
	        		<td class='title' width='20%'>������ü��</th>
	        		<td width='40%'>&nbsp;<input type="text" name="rc_num_com" size='4' value="<%=dto.getRc_num_com()%>" onBlur='javascript:this.value=parseDecimal(this.value);'> ����</td>
	        		<td width='40%' name="info" >&nbsp;�ڵ����뿩������� ���ȸ������</td>
	        	</tr>  
	        	<tr>
	        		<td class='title' width='20%'>�������</th>
	        		<td width='40%'>&nbsp;<input type="text" name="rc_busi_rank" size='4' value="<%=dto.getRc_busi_rank()%>"> ��</td>
	        		<td width='40%'>&nbsp;������/�����������</td>
	        	</tr>   
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	
    <tr>
        <td align='right'>
                
	        	<input type="hidden" name="info" value="<%=dto.getRc_no()%>">
				<button value="<%=dto.getRc_no()%>" style="float:right;" onclick="infoCan();" >�ݱ�</button>
				&nbsp;&nbsp;
				<button type="submit" value="<%=dto.getRc_no()%>" style="float:right;">����</button>
        </td>
    </tr>        
  </table>  
</form>
</body>
</html>
