<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//���� ������ ����Ʈ �̵�
	function list_move(bus_id2)
	{
		var fm = document.form1;
		var url = "";
		fm.gubun1.value = '7';
		fm.gubun2.value = '2';
		fm.gubun3.value = '3';	
		fm.gubun4.value = '';			
		fm.s_kd.value = '8';		
		fm.t_wd.value = bus_id2;			
		url = "/acar/settle_acc/settle_s_frame.jsp";
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}				
-->
</script>
</head>

<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String search_kd = request.getParameter("search_kd")==null?"":request.getParameter("search_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String dept_id = request.getParameter("dept_id")==null?"0001":request.getParameter("dept_id");	
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String tot_dly_amt = request.getParameter("tot_dly_amt")==null?"0":request.getParameter("tot_dly_amt");
	String tot_dly_per = request.getParameter("tot_dly_per")==null?"0":request.getParameter("tot_dly_per");
	float dly_per1 = 0;
	float dly_per2 = 0;
	String per2 = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='dept_id' value='<%=dept_id%>'>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='gubun4' value='1'>
<input type='hidden' name='s_kd' value=''>
<input type='hidden' name='t_wd' value=''>
    <tr> 
        <td class="line">          
            <TABLE align=center border=0 width=100% cellspacing=1 cellpadding=0>
        <%//��ü�� �׷���
			Vector feedps = st_db.getStatSettleList7(brch_id, dept_id, save_dt, "");
			int feedp_size = feedps.size();
			if(feedp_size > 0){
				for (int i = 0 ; i < feedp_size ; i++){
					IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);
					dly_per1 = Float.parseFloat(feedp.getTot_su3())*125;
					if(feedp.getTot_su4().equals("")){
						dly_per2 = Float.parseFloat(feedp.getTot_amt2())/Float.parseFloat(tot_dly_amt)*100;
						per2 = (dly_per2==0)?"0.0":Float.toString(dly_per2).substring(0,Float.toString(dly_per2).indexOf(".")+3);
					}else{
						per2 = feedp.getTot_su4();
					}
					if(dly_per1 > 500) dly_per1=500;
					%>
                <TR> 
                  <TD style='background:e2fff8;' width="6%" align=center><a href="javascript:list_move('<%=feedp.getGubun()%>');" onMouseOver="window.status=''; return true"><%=c_db.getNameById(feedp.getGubun(), "USER")%></a></TD>
                  <TD style='background:e2fff8;' width="6%" align=center>
        		  <a href="javascript:list_move('<%=feedp.getGubun()%>');" onMouseOver="window.status=''; return true">
                      <%/* if(feedp.getGubun().equals("000010"))		out.print("������");	//���ֿ�
        					else if(feedp.getGubun().equals("000011"))	out.print("������");	//���
        					else if(feedp.getGubun().equals("000012"))	out.print("������");	//�̱���
        					else if(feedp.getGubun().equals("000013"))	out.print("�ǿ��");	//Ȳ����
        					else if(feedp.getGubun().equals("000020"))	out.print("���¿�");	//����ȣ
        					else if(feedp.getGubun().equals("000023"))	out.print("��̰�");	//�۹���
        					else if(feedp.getGubun().equals("000025"))	out.print("������");	//������
        					else if(feedp.getGubun().equals("000026"))	out.print("������");	//�豤��
        					else if(feedp.getGubun().equals("000034"))	out.print("���ǻ�");	//���ؿ�
        					if(feedp.getGubun().equals("000010"))		out.print("���ǻ�");	//���ֿ�
        					else if(feedp.getGubun().equals("000011"))	out.print("������");	//���
        					else if(feedp.getGubun().equals("000012"))	out.print("������");	//�̱���
        					else if(feedp.getGubun().equals("000013"))	out.print("������");	//Ȳ����
        					else if(feedp.getGubun().equals("000020"))	out.print("��̰�");	//����ȣ
        					else if(feedp.getGubun().equals("000023"))	out.print("������");	//�۹���
        					else if(feedp.getGubun().equals("000025"))	out.print("���¿�");	//������
        					else if(feedp.getGubun().equals("000026"))	out.print("�ǿ��");	//�豤��
        					else if(feedp.getGubun().equals("000034"))	out.print("������");	//���ؿ�*/
        					//2007���ݱ�
        					/*if(feedp.getGubun().equals("000010"))		out.print("��̰�");	//���ֿ�
        					else if(feedp.getGubun().equals("000011"))	out.print("���");		//���
        					else if(feedp.getGubun().equals("000012"))	out.print("������");	//�̱���
        					else if(feedp.getGubun().equals("000013"))	out.print("����");	//Ȳ����
        					else if(feedp.getGubun().equals("000020"))	out.print("������");	//����ȣ
        					else if(feedp.getGubun().equals("000023"))	out.print("����ȭ");	//�۹���
        					else if(feedp.getGubun().equals("000025"))	out.print("������");	//������
        					else if(feedp.getGubun().equals("000026"))	out.print("��漱");	//�豤��
        					else if(feedp.getGubun().equals("000034"))	out.print("���¿�");	//���ؿ�
        					//2007���Ϲݱ�
        					if(feedp.getGubun().equals("000010"))		out.print("������");	//���ֿ�
        					else if(feedp.getGubun().equals("000011"))	out.print("������");	//���
        					else if(feedp.getGubun().equals("000012"))	out.print("");			//�̱���
        					else if(feedp.getGubun().equals("000013"))	out.print("��̰�");	//Ȳ����
        					else if(feedp.getGubun().equals("000020"))	out.print("��漱");	//����ȣ
        					else if(feedp.getGubun().equals("000023"))	out.print("���¿�");	//�۹���
        					else if(feedp.getGubun().equals("000025"))	out.print("����");	//������
        					else if(feedp.getGubun().equals("000026"))	out.print("����ȭ");	//�豤��
        					else if(feedp.getGubun().equals("000034"))	out.print("");			//���ؿ� 
        					else if(feedp.getGubun().equals("000079"))	out.print("Ȳ����");	//��켮
        					else if(feedp.getGubun().equals("000083"))	out.print("�ǿ��");	//����� */
        					//2008���ݱ�
        					if(feedp.getGubun().equals("000010"))		out.print("���¿�");	//���ֿ�
        					else if(feedp.getGubun().equals("000011"))	out.print("���¿�");	//���
        					else if(feedp.getGubun().equals("000013"))	out.print("����");		//Ȳ����
        					else if(feedp.getGubun().equals("000020"))	out.print("�ǿ��");	//����ȣ
        					else if(feedp.getGubun().equals("000023"))	out.print("������");	//�۹���
        					else if(feedp.getGubun().equals("000025"))	out.print("������");	//������
        					else if(feedp.getGubun().equals("000026"))	out.print("������");	//�豤��
        					else if(feedp.getGubun().equals("000079"))	out.print("����ȭ");    //��켮
        					else if(feedp.getGubun().equals("000083"))	out.print("����");	//�����
        					else if(feedp.getGubun().equals("000091"))	out.print("���ǻ�");	//�����
        					else if(feedp.getGubun().equals("000090"))	out.print("��̰�");	//����ȯ
        					else if(feedp.getGubun().equals("000066"))	out.print("������");	//������
        					else if(feedp.getGubun().equals("000088"))	out.print("������");	//������
        					
        					//if(feedp.getBr_id().equals("B1"))			out.print("������");
        					if(feedp.getBr_id().equals("D1"))			out.print("�ڿ���");
        					%>
        
        					</a>
        		  </TD>
                  <TD align="center" width="11%"><input type="text" name="per1" value="<%=AddUtil.parseFloatCipher(feedp.getTot_su3(),2)%>" size="5" class="whitenum">%</TD>
                  <TD align="center" width="11%"><input type="text" name="per2" value="<%=AddUtil.parseFloatCipher(per2,2)%>" size="5" class="whitenum">%</TD>
                  <TD><img src=../../images/result1.gif width=<%=Float.toString(dly_per1).substring(0,Float.toString(dly_per1).indexOf("."))%> height=10></TD>
                </TR>
                <%	}
        			}else{%>
                <TR align="center"> 
                  <TD colspan="4">��ϵ� �ڷᰡ �����ϴ�.</TD>
                </TR>
        <%}%>
            </TABLE>
        </td>
    </tr>
</form>
</table>

</body>
</html>
