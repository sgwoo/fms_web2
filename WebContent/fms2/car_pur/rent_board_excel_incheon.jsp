<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=rent_board_excel_incheon.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	
	
	//��õ����
	Hashtable br = c_db.getBranch("I1");
	
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<!--<link rel=stylesheet type="text/css" href="/include/table_t.css">-->
<body>
<% int col_cnt = 29;%>
<table border="0" cellspacing="0" cellpadding="0" width=1870>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(��)�Ƹ���ī �ڵ��� �űԵ�� ��û ����Ʈ (<%=AddUtil.getDate()%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width=1870>
	<!--
    <tr>
        <td class='line'>
	        <table border="1" cellspacing="1" cellpadding="0" width='100%'>
			-->
		        <tr>
        			<td colspan="13" align='center' style="font-size : 15pt;" height="40">�������� �Է� </td>				  				  
        			<td colspan="9" align='center' style="font-size : 15pt;">����� �Է� </td>
					<td colspan="7" align='center' style="font-size : 15pt;">��Ÿ�Է�</td>				  
       			</tr>
		        <tr>
                  <td colspan="2"  align='center' style="font-size : 8pt;" height="30">����</td>				
                  <td colspan="3"  align='center' style="font-size : 8pt;">����������</td>
                  <td colspan="6" align='center' style="font-size : 8pt;">����������</td>
                  <td colspan="2" align='center' style="font-size : 8pt;">����������</td>
                  <td align='center' style="font-size : 8pt;">����</td>
	              <td align='center' style="font-size : 8pt;">ä��</td>
	              <td colspan="3" align='center' style="font-size : 8pt;">Ư�̻���</td>
                  <td colspan="4" align='center' style="font-size : 8pt;">��������</td>
                  <td align='center' style="font-size : 8pt;">������ȣ</td>
	              <td colspan="3" align='center' style="font-size : 8pt;">���������(����)</td>
                  <td colspan="2" align='center' style="font-size : 8pt;">���Ⱑ�� �� ��������</td>
                  <td rowspan='2' align='center' style="font-size : 8pt;">�������</td>
              </tr>
		        <tr>
		          <td width='30' align='center' style="font-size : 8pt;">����</td>
		          <td width='30' align='center' style="font-size : 8pt;">����</td>
		          <td width='70' align='center' style="font-size : 8pt;">�����ڸ�</td>
	              <td width='60' align='center' style="font-size : 8pt;">���ι�ȣ</td>
	              <td width='150' align='center' style="font-size : 8pt;">��뺻����</td>
	              <td width='50' align='center' style="font-size : 8pt;">������������</td>
	              <td width='100' align='center' style="font-size : 8pt;">����</td>
	              <td width='50' align='center' style="font-size : 8pt;">����������</td>
	              <td width='100' align='center' style="font-size : 8pt;">�����ȣ</td>
	              <td width='60' align='center' style="font-size : 8pt;">����������ȣ</td>
	              <td width='80' align='center' style="font-size : 8pt;">���ް���</td>
	              <td width='60' align='center' style="font-size : 8pt;">���ԽŰ��ȣ</td>
	              <td width='60' align='center' style="font-size : 8pt;">���ԽŰ���</td>
	              <td width='60' align='center' style="font-size : 8pt;">����ȣ</td>
	              <td width='60' align='center' style="font-size : 8pt;">ä������</td>
	              <td width='50' align='center' style="font-size : 8pt;">����</td>
	              <td width='60' align='center' style="font-size : 8pt;">���ǹ�ȣ</td>
	              <td width='60' align='center' style="font-size : 8pt;">��ȣ��Ư�̻���</td>
	              <td width='50' align='center' style="font-size : 8pt;">����������</td>
	              <td width='50' align='center' style="font-size : 8pt;">�ֹι�ȣ</td>
	              <td width='50' align='center' style="font-size : 8pt;">�ּ�</td>
	              <td width='50' align='center' style="font-size : 8pt;">������</td>
	              <td width='80' align='center' style="font-size : 8pt;">����ī�ο���ȣ</td>
	              <td width='70' align='center' style="font-size : 8pt;">����ڸ�</td>
	              <td width='60' align='center' style="font-size : 8pt;">���ι�ȣ</td>
	              <td width='150' align='center' style="font-size : 8pt;">�ּ�</td>
	              <td width='60' align='center' style="font-size : 8pt;">�ڵ������Ⱑ��������ȣ</td>
	              <td width='60' align='center' style="font-size : 8pt;">�ڵ�������������ȣ</td>
	          </tr>		
		  		<%	for(int i=0;i < vid_size;i++){
						rent_l_cd = vid[i];
						Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);						
						total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CAR_AMT")));
						
						String tax_exempt = "";						
						//ģȯ���� ��漼 ����
						if(!String.valueOf(ht.get("JG_G_7")).equals("")){
							if(String.valueOf(ht.get("JG_G_7")).equals("1") || String.valueOf(ht.get("JG_G_7")).equals("2")){
								tax_exempt = "����";
							}else if(String.valueOf(ht.get("JG_G_7")).equals("3") || String.valueOf(ht.get("JG_G_7")).equals("4")){
								tax_exempt = "����";
							}							
						}
				%>
		        <tr>
        			<td align='center' style="font-size : 8pt;"><%=i+1%></td>
        		    <td align='center' style="font-size : 8pt;">
					<%if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){//X%>
					<%if(String.valueOf(ht.get("CAR_ST")).equals("�����뿩")){%>��Ʈ<%}else{%><%=ht.get("CAR_ST")%><%}%>
					<%}else{%>
					����
					<%}%>
					</td>
        		    <td align='center' style="font-size : 8pt;">(��)�Ƹ���ī</td>
        		    <td align='center' style="font-size : 8pt;">115611-0019610</td>
        		    <td align='center' style="font-size : 8pt;"><%=br.get("BR_ADDR")%></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;">
        		        <%if(!tax_exempt.equals("")){ %><span style="color:blue; letter-spacing: -1px;font-weight:bold;"><b>[����]</b></span><%}%>
        		   		<%if(ht.get("JG_G_16").equals("1")){ %><span style="color:red; letter-spacing: -1px;font-weight:bold;">[������]</span><%}%>
						<%if(ht.get("JG_G_7").equals("3")){ %><span style="color:darkorange; letter-spacing: -1px;">[��]</span><%}%>
						<%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%>
						<%-- <%if(String.valueOf(ht.get("DIESEL_YN")).equals("3") || String.valueOf(ht.get("DIESEL_YN")).equals("4") || String.valueOf(ht.get("DIESEL_YN")).equals("5")){%>
        		    	<font color=red><b>[������]<%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></b></font> --%>
        		    <%-- 	<%}else{%>
        		    	<%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%>
        		    	<%}% --%>
        		    </td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NUM")%></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        			<td align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"><%=ht.get("TMP_DRV_NO")%><%if(String.valueOf(ht.get("TMP_DRV_NO")).equals("")){%>�ӽÿ���̹߱�<%}%></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>																				
        		    <td align='center' style="font-size : 8pt;">
        		    <%if(String.valueOf(ht.get("NEW_LICENSE_PLATE")).equals("1") || String.valueOf(ht.get("NEW_LICENSE_PLATE")).equals("2")){%>
							<!--<span style="color:red; letter-spacing: -1px;">[����]</span>-->
					<%}else{%>
					        <span style="color:red; letter-spacing: -1px;">(��)</span>
					<%}%>         		    
        		    <%=ht.get("EST_CAR_NO")%></td>
        			<td align='center' style="font-size : 8pt;">
					<%//		if((!String.valueOf(ht.get("JG_G_7")).equals("") && !String.valueOf(ht.get("JG_G_7")).equals("null")) || (String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409") || String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802")))){%>
					<%//		}else{%>
					<%=ht.get("ACQ_CNG_COM")%>
					<%//		} //20220504 �����������ó������ ��ϵ� ������ ���̰� ��%>
					</td>
        			<td align='center' style="font-size : 8pt;"><%=ht.get("APP_ST")%></td>	
               		<td align='center' style="font-size : 8pt;">
               		<%=ht.get("ADDR")%>
					<%-- <%if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("����ĳ��Ż")){%>
					����� �������� ���ǵ��� 16-2
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("�Ｚī��")){%>
					����� �߱� �����2�� 250
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("IBKĳ��Ż")){%>					
					����� ������ ������� 414 (��ġ��)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("�츮���̳���")){%>					
					����� ���ʱ� ���ʵ� 1337-20
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("����ĳ��Ż")){%>					
					����� �߱� �Ұ��� 110 ��ȭ���� 10��
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("BSĳ��Ż")){%>					
					�λ�� �λ����� ������ 259-4 �λ�������������� 9��
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("����ĳ��Ż")){%>					
					�λ걤���� �λ����� ���Ϸ� 6 (������)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("�Ե�ĳ��Ż")){%>					
					����� ������ ���ﵿ 736-1
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("����ĳ��Ż")){%>					
					����� �������� ���ǵ��� 15-21					
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("�ϳ�ĳ��Ż")){%>					
					����� ������ ������� 126 (���ﵿ �������13��)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("DGBĳ��Ż")){%>					
					����� ������ ���ַ�30�� 39 (���,�Ｚ�����Ͼ���18��)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("�޸�����������")){%>					
					����� �������� ����������6�� 15 (���ǵ���)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("�ѱ���Ƽ�׷�ĳ��Ż")){%>					
					����� ���α� â��÷� 120 (���ǵ�, �����÷��̽�)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("KBĳ��Ż")){%>					
					��⵵ ������ �ȴޱ� ȿ���� 295 (�ΰ赿)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("�޸���ĳ��Ż")){%>					
					����� �������� ����������2�� 11 (���ǵ���)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("KTĳ��Ż")){%>					
					����� ������ �Ｚ�� 511 (�Ｚ��,���Ÿ��12��)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("������ĳ��Ż�ڸ���")){%>					
					����� ������ ������� 317 (���ﵿ,����Ÿ��10��)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("�Ե����丮��")){%>	
					��⵵ �Ⱦ�� ���ȱ� ���ķ� 88 (ȣ�赿, �ſ�����Ÿ�� 8��)
					<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("������ĳ��Ż")){%>	
					�λ�� �λ����� ���Ϸ� 1 (������, �λ����� ���������� 9��)
					<%}else{%>										
					<%}%> --%>
					</td>						
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;">
        		    <%if(String.valueOf(ht.get("JG_G_7")).equals("3") || String.valueOf(ht.get("CAR_ST")).equals("����")){%>
        		    <%}else{%>
        		    <%	if(String.valueOf(ht.get("UDT_ST")).equals("2")){%>
        		    �λ�
        		    <%	}else if(String.valueOf(ht.get("UDT_ST")).equals("3")){%>
        		    ����
        		    <%	}else if(String.valueOf(ht.get("UDT_ST")).equals("5")){%>
        		    �뱸
        		    <%	}%>
        		    <%}%>        		    
        		    </td>
		        </tr>
				<%	}%>
<!--				
		    </table>
	    </td>
    </tr>  		    		  
	-->
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

