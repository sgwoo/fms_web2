<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSelectStatEtc_list_y1(settle_year);
	int vt_size = vt.size();
	
	
	long total_amt1[]	 		= new long[13];
	long total_amt2[]	 		= new long[13];
	long total_amt3[]	 		= new long[13];
	

%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//���θ���Ʈ
function view_stat(content_code, settle_month){
	window.open('select_stat_etc_list_y1_sub_list.jsp?settle_year=<%=settle_year%>&content_code='+content_code+'&settle_month='+settle_month, "STAT_LIST", "left=300, top=20, width=1250, height=800, scrollbars=yes, status=yes, resize");
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=<%=table_width%>>
	<tr>
	  <td align="center"><%=AddUtil.parseInt(settle_year)%>�� ������(�˸���/ģ����/����)�߼���Ȳ</td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			      <td rowspan='2'width="50" class="title">����</td>
				  <td rowspan='2' width="70" class="title">����</td>
				  <td rowspan='2' width="80" class="title">�ڵ�</td>
				  <td colspan='3' class="title">�հ�</td>
				  <%for (int j = 0 ; j < 12 ; j++){%>
                  <td colspan='3' class=title><%=j+1%>��</td>
				  <%}%>				  
			    </tr>
			    <tr>
			      <%for (int j = 0 ; j < 13 ; j++){%>
				  <td width="60" class="title">�Ǽ�</td>
				  <td width="60" class="title">����</td>
				  <td width="60" class="title">����</td>
				  <%}%>
			    </tr>				    
			    <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					if(String.valueOf(ht.get("MSG_TYPE")).equals("�˸���")){
						for(int j = 0 ; j < 13 ; j++){
							if( j == 0 ){
								total_amt1[j]	= total_amt1[j] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
								total_amt2[j]	= total_amt2[j] + AddUtil.parseLong(String.valueOf(ht.get("Y_CNT")));
								total_amt3[j]	= total_amt3[j] + AddUtil.parseLong(String.valueOf(ht.get("N_CNT")));
							}else{
								total_amt1[j]	= total_amt1[j] + AddUtil.parseLong(String.valueOf(ht.get("CNT_"+j)));
								total_amt2[j]	= total_amt2[j] + AddUtil.parseLong(String.valueOf(ht.get("Y_CNT_"+j)));
								total_amt3[j]	= total_amt3[j] + AddUtil.parseLong(String.valueOf(ht.get("N_CNT_"+j)));
							}
						}
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("MSG_TYPE")%></td>
				  <td align="center"><%=ht.get("TEMPLATE_CODE")%></td>
				  <td align="right"><%=ht.get("CNT")%></td>
				  <td align="right"><%=ht.get("Y_CNT")%></td>
				  <td align="right"><%=ht.get("N_CNT")%></td>
				  <%for(int j = 1 ; j <= 12 ; j++){ %>
				  <td align="right"><a href="javascript:view_stat('<%=ht.get("TEMPLATE_CODE")%>','<%=AddUtil.addZero2(j)%>')"><%=ht.get("CNT_"+j)%></a></td>
				  <td align="right"><%=ht.get("Y_CNT_"+j)%></td>
				  <td align="right"><%=ht.get("N_CNT_"+j)%></td>
				  <%} %>
			    </tr>
			    <%	}}%>	
			    <tr> 
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>			
				  <td class="title">&nbsp;</td>
				  <%for(int j = 0 ; j <= 12 ; j++){ %>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1[j])%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2[j])%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3[j])%></td>
				  <%} %>				  				 
			    </tr>	
			    
			    <tr>
                  <td colspan='42' class=h></td>
                </tr>
			    
			    <tr>
			      <td rowspan='2' width="50" class="title">����</td>
				  <td rowspan='2' width="70" class="title">����</td>
				  <td rowspan='2' width="80" class="title">�ڵ�</td>
				  <td colspan='3' class="title">�հ�</td>
				  <%for (int j = 0 ; j < 12 ; j++){%>
                  <td colspan='3' class=title><%=j+1%>��</td>
				  <%}%>				  
			    </tr>
			    <tr>
			      <%for (int j = 0 ; j < 13 ; j++){%>
				  <td width="60" class="title">�Ǽ�</td>
				  <td width="60" class="title">����</td>
				  <td width="60" class="title">����</td>
				  <%}%>
			    </tr>					    
			    		 
			    <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					if(!String.valueOf(ht.get("MSG_TYPE")).equals("�˸���")){						
				%>	
			    <tr>
				  <td class="title">-</td>
				  <td align="center"><%=ht.get("MSG_TYPE")%></td>
				  <td align="center"><%=ht.get("TEMPLATE_CODE")%></td>
				  <td align="right"><%=ht.get("CNT")%></td>
				  <td align="right"><%=ht.get("Y_CNT")%></td>
				  <td align="right"><%=ht.get("N_CNT")%></td>
				  <%for(int j = 1 ; j <= 12 ; j++){ %>
				  <td align="right"><%=ht.get("CNT_"+j)%></td>
				  <td align="right"><%=ht.get("Y_CNT_"+j)%></td>
				  <td align="right"><%=ht.get("N_CNT_"+j)%></td>
				  <%} %>
			    </tr>
			    <%	}}%>							       
			</table>
		</td>
	</tr>

  </table>   
  <table border="0" cellspacing="1" cellpadding="0" width=700>
    <tr>
	  <td>&nbsp;* ���۰�� </td>	  
    </tr>	
    <%	vt = ad_db.getSelectStatEtc_list_y1_code(settle_year);
		vt_size = vt.size(); 
	%>		
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			      <td width="120" class="title">����</td>
			      <td width="120" class="title">����ڵ�</td>
				  <td width="100" class="title">�Ǽ�</td>				  
				  <td width="360" class="title">�ǹ�</td>
			    </tr>	
			    <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					if(String.valueOf(ht.get("MSG_TYPE")).equals("�˸���")){	
						
						String code_nm = "";
						if(String.valueOf(ht.get("REPORT_CODE")).equals("1000")){ 	code_nm = "����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("2001")){ 	code_nm = "�޽��� ���ۺҰ�"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3027")){ 	code_nm = "īī������ ������� ���� �����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3032")){ 	code_nm = "�޽��� ���� ���� ����(��������1000��)"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3034")){ 	code_nm = "�޽����� ���ø��� ��ġ���� ����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3049")){ 	code_nm = "���νý��� ������ �޽��� ���� ����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3050")){ 	code_nm = "ģ���ƴѰ��,�˸�������,7�ϰ��̻��,��������"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("E901")){ 	code_nm = "���Ź�ȣ�� ���� ���"; }
				%>	    
			    <tr>
			      <td align="center"><%=ht.get("MSG_TYPE")%></td>
			      <td align="center"><%=ht.get("REPORT_CODE")%></td>
				  <td align="right"><%=ht.get("CNT")%></td>
				  <td align="center"><%=code_nm %></td>				  
			    </tr>	
			    <%}}%>
			    <tr>
                  <td colspan='4' class=h></td>
                </tr>	
			    <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					if(String.valueOf(ht.get("MSG_TYPE")).equals("ģ����")){	
						
						String code_nm = "";
						if(String.valueOf(ht.get("REPORT_CODE")).equals("1000")){ 	code_nm = "����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("2001")){ 	code_nm = "�޽��� ���ۺҰ�"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3027")){ 	code_nm = "īī������ ������� ���� �����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3032")){ 	code_nm = "�޽��� ���� ���� ����(��������1000��)"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3034")){ 	code_nm = "�޽����� ���ø��� ��ġ���� ����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3049")){ 	code_nm = "���νý��� ������ �޽��� ���� ����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3050")){ 	code_nm = "ģ���ƴѰ��,�˸�������,7�ϰ��̻��,��������"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3054")){ 	code_nm = "�޽��� �߼� ������ �ð� �ƴ�"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("E901")){ 	code_nm = "���Ź�ȣ�� ���� ���"; }
				%>	    
			    <tr>
			      <td align="center"><%=ht.get("MSG_TYPE")%></td>
			      <td align="center"><%=ht.get("REPORT_CODE")%></td>
				  <td align="right"><%=ht.get("CNT")%></td>
				  <td align="center"><%=code_nm %></td>				  
			    </tr>	
			    <%}}%>
			    <tr>
                  <td colspan='4' class=h></td>
                </tr>	
			    <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					if(String.valueOf(ht.get("MSG_TYPE")).equals("�幮��")){	
						
						String code_nm = "";
						if(String.valueOf(ht.get("REPORT_CODE")).equals("1000")){ 	code_nm = "����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("1022")){ 	code_nm = "�̵�Ϲ߽Ź�ȣ"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("2000")){ 	code_nm = "���۽ð��ʰ�"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("2001")){ 	code_nm = "���۽���(��������)"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3001")){ 	code_nm = "�����ھ���"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3004")){ 	code_nm = "�ܸ��⼭���Ͻ�����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3010")){ 	code_nm = "MMS�������ܸ�"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3013")){ 	code_nm = "���񽺰ź�"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3014")){ 	code_nm = "��Ÿ"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3015")){ 	code_nm = "���۰�ξ���"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3018")){ 	code_nm = "�߽Ź�ȣ ���۹��� �ΰ����� ���� �߽Ź�ȣ"; }
				%>	    
			    <tr>
			      <td align="center"><%=ht.get("MSG_TYPE")%></td>
			      <td align="center"><%=ht.get("REPORT_CODE")%></td>
				  <td align="right"><%=ht.get("CNT")%></td>
				  <td align="center"><%=code_nm %></td>				  
			    </tr>	
			    <%}}%>
			    <tr>
                  <td colspan='4' class=h></td>
                </tr>	
			    <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					if(String.valueOf(ht.get("MSG_TYPE")).equals("�ܹ���")){	
						
						String code_nm = "";
						if(String.valueOf(ht.get("REPORT_CODE")).equals("1000")){ 	code_nm = "����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("1022")){ 	code_nm = "�̵�Ϲ߽Ź�ȣ"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("2000")){ 	code_nm = "���۽ð��ʰ�"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("2001")){ 	code_nm = "���۽���(��������)"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("2003")){ 	code_nm = "�ܸ��� ��������"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3001")){ 	code_nm = "�����ھ���"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3003")){ 	code_nm = "���Ź�ȣ ���Ŀ���"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3004")){ 	code_nm = "�ܸ��⼭���Ͻ�����"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3008")){ 	code_nm = "��Ÿ �ܸ��⹮��"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3010")){ 	code_nm = "MMS�������ܸ�"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3013")){ 	code_nm = "���񽺰ź�"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3014")){ 	code_nm = "��Ÿ"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3015")){ 	code_nm = "���۰�ξ���"; }
						if(String.valueOf(ht.get("REPORT_CODE")).equals("3018")){ 	code_nm = "�߽Ź�ȣ ���۹��� �ΰ����� ���� �߽Ź�ȣ"; }
				%>	    
			    <tr>
			      <td align="center"><%=ht.get("MSG_TYPE")%></td>
			      <td align="center"><%=ht.get("REPORT_CODE")%></td>
				  <td align="right"><%=ht.get("CNT")%></td>
				  <td align="center"><%=code_nm %></td>				  
			    </tr>	
			    <%}}%>
			</table>
		</td>
	</tr>			    
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
