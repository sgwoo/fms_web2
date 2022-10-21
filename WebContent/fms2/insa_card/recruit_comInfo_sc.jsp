<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
    
	InsaRcDatabase icd = new InsaRcDatabase();
	List<Insa_Rc_InfoBean> list=icd.selectInsaAll();
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function modifyInfo(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width="800">
	<%	if(list.size()==0){%>
   	<tr>
		<td>-----���� �������� �ʽ��ϴ�.-----</td>
	</tr>   
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_comInfo.jsp?rc_no=0', 'cominfoList', 'left=350, top=50, width=850, height=350, scrollbars=yes, status=yes');">���</button>
		</td>
	</tr>  		
	<%	}else{%>
	<%		for(Insa_Rc_InfoBean dto:list){%>
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_comInfo.jsp?rc_no=<%=dto.getRc_no()%>', 'cominfoList', 'left=350, top=50, width=850, height=350, scrollbars=yes, status=yes');">����</button>
		</td>
	</tr>   
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ȸ�簳��(<%=dto.getRc_cur_dt()%>��12��31�� �������)</span></td>
	  </tr>
    <tr>
    	<td class=line2></td>
    </tr>
    <tr>
        <td class="line" width='1280'>  
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   				
	        	<tr>
	        		<td class='title' width='20%'>��������</th>
	        		<td width='40%'>&nbsp;2000��04��19��</td>
	        		<td width='40%'></td>
	        	</tr>          
                <tr>
	        		<td class='title' width='20%'>����</th>
	        		<td width='40%'>&nbsp;�ڵ����뿩��, �ڵ����Ӵ��</td>
	        		<td width='40%'></td>
	        	</tr>  
	        	<tr>
	        		<td class='title' width='20%'>�ں��Ѱ�</th>
	        		<td width='40%'>&nbsp;<%=AddUtil.parseDecimal(dto.getRc_tot_capital()) %> ���</td>
	        		<td width='40%'></td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>�ڻ��Ѱ�</th>
	        		<td width='40%'>&nbsp;<%=AddUtil.parseDecimal(dto.getRc_tot_asset())%> ���</td>
	        		<td width='40%'></td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>�����</th>
	        		<td width='40%'>&nbsp;<%=AddUtil.parseDecimal(dto.getRc_sales())%> ���</td>
	        		<td width='40%'>&nbsp;<%=dto.getRc_cur_dt()%> �����Ѿ�</td>
	        	</tr>   
	        	<tr>
	        		<td class='title' width='20%'>��������Ȳ</th>
	        		<td width='40%'>&nbsp;<%=dto.getRc_per_off()%> ��</td>
	        		<td width='40%'>&nbsp;10���̻� �ټ���(<%=dto.getRc_per_off_per()%>%)</td>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ȳ(<%=dto.getRc_cur_dt()%>��12��31�� �������)</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='1280' >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>          
                <tr>
	        		<td class='title' width='20%'>������ü��</th>
	        		<td width='40%'>&nbsp;<%=AddUtil.parseDecimal(dto.getRc_num_com())%>����</td>
	        		<td width='40%'>&nbsp;�ڵ����뿩������� ���ȸ������</td>
	        	</tr>  
	        	<tr>
	        		<td class='title' width='20%'>�������</th>
	        		<td width='40%'>&nbsp;<%=dto.getRc_busi_rank()%>��</td>
	        		<td width='40%'>&nbsp;������/�����������</td>
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
	<!-- 
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<button type="submit" name="rc_no" value="rc_no" style="float:right;" onclick="javascript:modifyInfo('recruit_comInfo.jsp?rc_no=0', 'cominfoList', 'left=350, top=50, width=850, height=350, scrollbars=yes, status=yes');">�߰����</button>
		</td>
	</tr>
	 -->
	<%
	   }
	%>  

  </table>
  
</form>
</body>
</html>