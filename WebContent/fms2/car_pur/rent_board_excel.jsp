<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%//@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.util.*"%>
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
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function onprint(){
factory.printing.header 		= ""; //��������� �μ�
factory.printing.footer 		= ""; //�������ϴ� �μ�
factory.printing.portrait 		= false; //true-�����μ�, false-�����μ�    
factory.printing.leftMargin 	= 14.0; //��������   
factory.printing.rightMargin 	= 10.0; //��������
factory.printing.topMargin 		= 10.0; //��ܿ���    
factory.printing.bottomMargin 	= 5.0; //�ϴܿ���
factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<table border="0" cellspacing="0" cellpadding="0" width=940>
    <tr>
	  <td align='center'>(��)�Ƹ���ī �ڵ�����ϸ���Ʈ</td>
	</tr>
    <tr>
	  <td align='right'><%=AddUtil.getDate()%></td>
	</tr>
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='30' class='title'>����</td>
        			<td width='30' class='title'>����</td>
        			<td width='150' class='title'>����</td>
        			<td width='150' class='title'>�����ȣ</td>
        			<td width='70' class='title'>������ȣ</td>
        			<td width='60' class='title'>�ӽù�ȣ</td>
        			<td width='80' class='title'>���ް���</td>
        			<td width='60' class='title'>��ϼ�</td>
        			<td width='60' class='title'>��漼</td>
        			<td width='80' class='title'>���θ�</td>
        			<td width='70' class='title'>��Ϲ�ȣ</td>
        			<td width='100' class='title'>�ּ�</td>
		        </tr>
		  		  <%	for(int i=0;i < vid_size;i++){
							rent_l_cd = vid[i];
									
							Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);
									
							total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CAR_AMT")));
									
							//��ϼ�
							long tax_amt2 = 0;
							
							if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){
								
					      	}else{
					        	if(String.valueOf(ht.get("S_ST")).equals("8") || String.valueOf(ht.get("S_ST")).equals("7")){//ȭ��
					        		if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802"))){
					        			
					        		}else{
					        			tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX3")));
									}
								}else{
									if(String.valueOf(ht.get("CAR_ST")).equals("��Ʈ")){//��Ʈ
										tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX2")));
									}else{//����
										if(String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")){
											//���� ���� 50���� �氨
											tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX2")));
										}else{
											tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX5")));
										}
									}
								}
							}
							
							total_amt2 	= total_amt2 + tax_amt2;
								
							//��漼
							long tax_amt3 = 0;
							
							if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){
								if(String.valueOf(ht.get("S_ST")).equals("8") || String.valueOf(ht.get("S_ST")).equals("7")){//ȭ��
									if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802"))){
										
									}else{
										tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX5")));
									}
								}else{
									if(String.valueOf(ht.get("CAR_ST")).equals("��Ʈ")){//��Ʈ
										tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
									}else{//����
										if(String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")){
											//���� ���� 50���� �氨
											tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
										}else{
											tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX7")));
										}
									}
								}
							}else{
								if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
									//���� ���� 50���� �氨
									tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
								}else{
									tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
								}
							}
							
							//ģȯ���� ��漼 ����
							if(!String.valueOf(ht.get("JG_G_7")).equals("")){
								if(String.valueOf(ht.get("JG_G_7")).equals("1") || String.valueOf(ht.get("JG_G_7")).equals("2")){
									//if(AddUtil.parseInt(String.valueOf(ht.get("DLV_DT"))) >= 20210101){
										//20210101 ���̺긮�� ��漼 �������� �Ϻ� ��� 900000->400000
										tax_amt3 = tax_amt3 - 400000;
									//}else{
										//20200101 ���̺긮�� ��漼 �������� �Ϻ� ���  1400000->900000
										//tax_amt3 = tax_amt3 - 900000;	
									//}
								}else if(String.valueOf(ht.get("JG_G_7")).equals("3") || String.valueOf(ht.get("JG_G_7")).equals("4")){
									tax_amt3 = tax_amt3 - 1400000;
								}
								if(tax_amt3 < 0)	tax_amt3 = 0;
							}
							//���� ���� 50���� �氨-> 2022�� 75����
							if(String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
								if(AddUtil.parseInt(String.valueOf(ht.get("DLV_DT"))) >= 20220101){
									if(tax_amt3<750000){
										tax_amt3 = 0;
									}else{
										tax_amt3 = tax_amt3-750000;
									}
								}else{
									if(tax_amt3<500000){
										tax_amt3 = 0;
									}else{
										tax_amt3 = tax_amt3-500000;
									}
								}
							}
									
							total_amt3 	= total_amt3 + tax_amt3;
						%>
		        <tr>
					<td align='center'><%=i+1%></td>
					<td align='center'><!-- ���� -->
						      <%if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){//X%>
						        <%if(String.valueOf(ht.get("CAR_ST")).equals("�����뿩")){%>��Ʈ<%}else{%><%=ht.get("CAR_ST")%><%}%>
						      <%}else{%>
						        ����
						      <%}%>
					</td>
        		  	<td align='center'><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td><!-- ���� -->
        		  	<td align='center'><%=ht.get("CAR_NUM")%></td><!-- �����ȣ -->
        		  	<td align='center'><%=ht.get("EST_CAR_NO")%></td><!-- ������ȣ -->
        		  	<td align='center'><%=ht.get("TMP_DRV_NO")%></td><!-- �ӽù�ȣ -->
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%></td><!-- ���ް��� -->
        			<td align='right'><%=Util.parseDecimal(tax_amt2)%></td><!-- ��ϼ� -->
					<td align='right'><%=Util.parseDecimal(tax_amt3)%></td><!-- ��漼 -->
        			<td align='center'><!-- ���θ� -->
								<%//if((!String.valueOf(ht.get("JG_G_7")).equals("") && !String.valueOf(ht.get("JG_G_7")).equals("null")) || (String.valueOf(ht.get("CAR_ST")).equals("����") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")))){%>
								<%//}else{%>
									<%=ht.get("ACQ_CNG_COM")%>
								<%//}//20220504 �����������ó������ ��ϵ� ������ ���̰� ��%>
					</td>
        			<td align='center'><%=ht.get("APP_ST")%></td><!-- ��Ϲ�ȣ -->
              		<td align='center'><!-- �ּ� -->
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
		        </tr>
						<%}%>
		        <tr>
        			<td align='center' colspan='7'>�հ�</td>
        			<td align='right' ><%=Util.parseDecimal(total_amt2)%></td>
        			<td align='right' ><%=Util.parseDecimal(total_amt3)%></td>
        			<td colspan='3'>&nbsp;<%=Util.parseDecimal(total_amt2+total_amt3)%>(��ϼ�+��漼)</td>
		        </tr>
		    </table>
	    </td>
    </tr>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>