<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ page import="acar.client.*,acar.doc_settle.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String client_id = request.getParameter("client_id")==null? "":request.getParameter("client_id");
	int seq = request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String current_date = AddUtil.getDate3();
	String gubun = request.getParameter("gubun")==null? "":request.getParameter("gubun");
	String crime = request.getParameter("crime")==null?"":request.getParameter("crime");
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	//���� ��ฮ��Ʈ
	Vector conts = new Vector();
	int cont_size = 0;
	
	if(seq == 0){
		conts = s_db.getContComplaintList(client_id);
		cont_size = conts.size();
	}else{
		conts = s_db.getContComplaintList(client_id, seq);
		cont_size = conts.size();	
	}
	
	String crime_name = "";
	String criminal_law = "";
	// ����
	if(crime.equals("0")){
		crime_name = "Ⱦ��";
		criminal_law = "Ⱦ �� (����355��1��)";
	}
	
	DocSettleBean doc = d_db.getDocSettleCommi("49", client_id+""+String.valueOf(seq));
	UsersBean ub = umd.getUsersBean(doc.getUser_id1());
		
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <title>FMS</title>
    <!-- <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link> -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style>
	*{
		font-family: serif;
	}
</style>
</head>
<body topmargin=0 leftmargin=0 onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">

</object>
	<table style="width:100%;margin:auto;">
		<tr><td colspan="2" style="height:80px;"></td></tr>
		<tr>
			<td colspan="2" align="center" style="font-weight:bold;"><font size="5">�� &nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;&nbsp;�� &nbsp;&nbsp;��</font></td>
		</tr>
		<tr><td colspan="2" style="height:110px;"></td></tr>
		<tr>
			<td style="vertical-align:top;width:10px;font-size:14px;font-weight:bold;text-align:right;">�� &nbsp;&nbsp;�� &nbsp;&nbsp;�� &#58;&nbsp;</td>
			<td style="font-size:14px">
				<p>(��)�Ƹ���ī</p>
				<p>����� �������� �ǻ���� 8, 802 (���ǵ���, �������)</p>
				<p>��ǥ�̻� &nbsp;�� �� �� &nbsp;&nbsp;�繫��:02-392-4242</p>
			</td>
		</tr>
		<tr><td colspan="2" style="height:60px;"></td></tr>
		<tr>
			<td style="vertical-align:top;font-size:14px;font-weight:bold;text-align:right;">��Ҵ븮�� &#58;&nbsp;</td>
			<td style="font-size:14px">
				<p><%=ub.getUser_nm()%> (�������: <%=ub.getUser_ssn().substring(0,6)%>)</p>
				<p>����� �������� �ǻ���� 8, 802 (���ǵ���, �������)</p>
				<p>�޴��� : <%=ub.getUser_m_tel()%> &nbsp;&nbsp;�繫�� : <%=ub.getHot_tel()%></p>
			</td>
		</tr>
		<tr><td colspan="2" style="height:60px;"></td></tr>
		<tr>
			<td style="vertical-align:top;font-size:14px;font-weight:bold;text-align:right;">�� &nbsp;����� &#58;&nbsp;</td>
			<td style="font-size:14px">
				<p><%=client.getClient_nm()%> (������� : <%=client.getSsn1()%>)</p>
				<p><%if(!client.getO_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getO_zip()%> 
            		              <%if(!client.getO_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getO_addr()%></p>
				<p>�޴��� : <%=AddUtil.phoneFormat(client.getM_tel())%></p>
			</td>
		</tr>
		<tr><td colspan="2" style="height:40px;"></td></tr>
		<tr>
			<td style="font-size:14px;text-align:right;">�� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�� &#58;&nbsp;</td>
			<td style="font-size:14px"><%=criminal_law%></td>
		</tr>
		<tr><td colspan="2" style="height:30px;"></td></tr>
		<tr>
			<td colspan="2" style="padding-left:50px;padding-right:50px;font-size:15px;font-family:Gulim;line-height:1.7em;" border=1>
				<span style="font-family:Gulim;">&nbsp;&nbsp;�� ������� �ǰ������ <%=crime_name%> ���Ƿ� ����� ����� ������, ����</span>
				<span style="font-family:Gulim;">(<%
					if(cont_size > 0){
						for(int i=0; i<cont_size; i++){
							Hashtable cont = (Hashtable)conts.elementAt(i);
				%><%if(i>0){%>, <%}%><%=cont.get("CAR_NO")%>, <%=cont.get("CAR_NM")%>
				<%
						}
					}
				%>
				 )�� ���Ͽ� <%if(gubun.equals("1")){%>������<%}else{%>�뿩�Ḧ<%}%> �ݳ� �޾� �ǰ���ο� ���� �����</span>
				<span style="font-family:Gulim;">ó���� ������ �����Ƿ� ��� ���� ��ü�� ����ϰ��� �մϴ�.</span>
			</td>
		</tr>
		<tr><td colspan="2" style="height:40px;"></td></tr>
		<tr>
			<td colspan="2" align="center" style="font-size:16px"><span style="font-family:Gulim;"><%=current_date%></span></td>
		</tr>
		<tr>
			<td colspan="2" style="text-align:center;"><img src="/acar/main_car_hp/images/ceo_text.jpg"></td>
		</tr>
	</table>
</body>
<script>
	function onprint(){
		factory.printing.header = ""; //��������� �μ�
		factory.printing.footer = ""; //�������ϴ� �μ�
		factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin = 5.0; //��������   
		factory.printing.rightMargin = 5.0; //��������
		factory.printing.topMargin = 0.0; //��ܿ���    
		factory.printing.bottomMargin = 0.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}
</script>
</html>