<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*, acar.user_mng.*, acar.client.*"%>
<jsp:useBean id="IssueDb" class="tax.IssueDatabase" scope="page"/>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String reg_id 		= request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String gubun 		= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String reg_code 	= request.getParameter("item_reg_code")==null?"":request.getParameter("item_reg_code");
	String item_id 		= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String tax_no 		= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String reg_dt 		= request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String site_id 		= request.getParameter("site_id")==null?"":request.getParameter("site_id");
	
	if(gubun.length() >1 && reg_code.equals("") && tax_no.equals("")){
		if(gubun.length() == 28){//ex:1=201109210710013860==008812
			String t_gubun = gubun;
			gubun 		= t_gubun.substring(0,1);
			reg_code 	= t_gubun.substring(1,20);
			client_id	= t_gubun.substring(22,28);
		}
		if(gubun.length() == 30){//ex:1=201109210710013860=01=008812
			String t_gubun = gubun;
			gubun 		= t_gubun.substring(0,1);
			reg_code 	= t_gubun.substring(1,20);
			site_id 	= t_gubun.substring(21,23);
			client_id	= t_gubun.substring(24,30);
		}
	}
	
	if(!reg_code.equals("") && tax_no.equals("")){
		gubun = "1";
	}
	if(reg_code.equals("") && !tax_no.equals("")){
		gubun = "2";
	}
	
	Hashtable ht = IssueDb.getTaxItemMailCase(gubun, reg_code, item_id, client_id, site_id);
	
	//������
	ClientBean client = al_db.getNewClient(client_id);
	
	//��������
	ClientSiteBean site = al_db.getClientSite(client_id, site_id);
	
	//��꼭�����
	UsersBean taxer_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("���ݰ�꼭�����"));
	
	if(String.valueOf(ht.get("CLIENT_ID")).equals("null") || String.valueOf(ht.get("CLIENT_ID")).equals("")){
		ht.put("NAME", 		client.getFirm_nm());
		ht.put("CLIENT_ID", client_id);
		ht.put("SEQ", 		site_id);
		ht.put("ITEM_DT",	AddUtil.getDate());
		ht.put("TAX_CNT",	"1");
		ht.put("TAX_YEAR",	AddUtil.getDate(1));
		ht.put("TAX_MON",	AddUtil.getDate(2));
	}
%>

<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>�ŷ����� ���ϸ�</title>
<style type="text/css">
<!--
.style1 {
	color: #747474;
	font-weight: bold;
}
.style2 {color: #747474}
.style3 {
	color: #ff00ff;
	font-weight: bold;
}
.style4 {color: #626262}
.style5 {color: #376100}
.style6 {
	color: #FFFFFF;
	font-weight: bold;
}
.style8 {color: #696969}
.style9 {
	color: #f75802;
	font-weight: bold;
}
-->
</style>


</head>
<body topmargin=0 leftmargin=0>

<div style="width: 700px; margin: 0 auto;">
	<div style="padding: 5px 10px; text-align: left;">
		<a href="https://www.amazoncar.co.kr" target="_blank">
			<img src="https://www.amazoncar.co.kr/resources/images/logo_1.png" style="width: 150px;"/>
		</a>
	</div>
	<div style="text-align: center; width: 700px; background-color: #9bb345; border: 1px solid #d2e38d; border-radius: 10px;">
		<div style="text-align: center; width: 700px; background-color: #FFFFFF; border-radius: 10px; margin: 8px 0px;">
			<!-- title_start -->
			<div style="padding: 20px 20px;">
				<span style="font-size:20px;">�Ƹ���ī �ŷ����� ���� �ȳ���</span>
			</div>
			<div style="margin: 30px 20px; font-family: nanumgothic; font-size:13px; border: 3px solid #e0e0e0;">
				<div style="padding: 10px 0px 10px 50px; text-align: left; line-height: 22px;">
					<span style="font-weight: bold;"><%=ht.get("NAME")%></span>&nbsp;��<br>
					<span style="color: #FF00FF; font-weight: bold;"><%=ht.get("TAX_MON")%>��</span> �ŷ������� ����Ǿ����ϴ�.<br>
					�Ʒ� "�ŷ����� �����ϱ�" ��ư�� �����ø� �ٷ� Ȯ�ΰ����մϴ�.
				</div>
			</div>
			<!-- title_end -->	
			<!-- content_start -->
			<div style="margin: 20px 20px;">
				<table border=0 cellspacing=0 cellpadding=0 style="width: 100%;">
					<tr>
						<th style="text-align: center; width: 40%; border-top: 2px solid #aea8b7; border-bottom: 1px solid #dfdde2; background-color: #efeef1;"><span style="font-family:nanumgothic;font-size:12px;">�߱�����</span></th>
						<td style="text-align: center; width: 60%; border-top: 2px solid #aea8b7; border-bottom: 1px solid #dfdde2;">&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=ht.get("ITEM_DT")%></span></td>
					</tr>
					<tr>
						<th style="text-align: center; width: 40%; border-bottom: 2px solid #aea8b7; background-color: #efeef1;"><span style="font-family:nanumgothic;font-size:12px;">�����Ǽ�</span></th>
						<td style="text-align: center; width: 60%; border-bottom: 2px solid #aea8b7;">&nbsp;<span style="font-family:nanumgothic;font-size:12px;"><%=ht.get("TAX_CNT")%> ��</span></td>
					</tr>
				</table>
			</div>
			<div style="padding: 10px 20px;">
				<%-- <a href="https://fms.amazoncar.co.kr/service/tax_index.jsp?client_id=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>&gubun=tax_item" target="_blank" style="padding: 5px 15px; background: #efefef; text-decoration: none; border-radius: 5px; color: #000000; border: 1px solid #000; font-size: 15px;"> --%>
				<a href="https://client.amazoncar.co.kr/clientIndex?clientId=<%=ht.get("CLIENT_ID")%>&r_site=<%=ht.get("SEQ")%>&s_yy=<%=ht.get("TAX_YEAR")%>&s_mm=<%=ht.get("TAX_MON")%>&gubun=tax_item" target="_blank" style="padding: 5px 15px; background: #efefef; text-decoration: none; border-radius: 5px; color: #000000; border: 1px solid #000; font-size: 15px;">
					�ŷ����� �����ϱ�
				</a>
			</div>
			<!-- 
			<div style="padding: 10px 20px; text-align: right; font-size: 10px;">
				�� <a href="http://fms1.amazoncar.co.kr/mailing/tax_bill/bill_doc_info.jsp" target="_blank">���Ź��</a>
			</div>
			 -->
			<div style="margin: 0px 20px 10px 20px; font-family: nanumgothic; font-size: 13px; line-height: 22px; background-color: #f3f3f3; border: 1px solid #d6d6d6; border-radius: 5px;">
				<div style="margin: 3px; padding: 10px; background-color: #FFF; border: 1px solid #FFF; border-radius: 5px;">
					���ݰ�꼭 ��¥������ ���Ͻø� �ݵ�� <span style="color: #349BD4; font-weight:bold;">ȸ������ <%=taxer_bean.getUser_nm()%></span> (<%=taxer_bean.getHot_tel()%>) ���� �����ֽñ� �ٶ��ϴ�.
				</div>
			</div>
			<div style="padding: 25px 0px 10px 0px;">
				<div style="margin: 0px 15px; padding: 20px; font-family: nanumgothic; font-size: 11px; border-top: 1px dotted; border-bottom: 1px dotted;">
					�� ������ �߽����� �����̹Ƿ� �ñ��� ������ <a href="mailto:tax@amazoncar.co.kr"><span style="font-size: 11px; color: #af2f98; font-family: nanumgothic;">���Ÿ���(tax@amazoncar.co.kr)</span></a>�� �����ֽñ� �ٶ��ϴ�.</span>
				</div>
			</div>
			<!-- content_end -->
			<!-- footer_start -->
			<div style="margin: 10px 15px 0px 15px; padding-bottom: 20px; font-family: nanumgothic; font-size: 11px; line-height: 20px;">
				<div>
					<table border=0 cellspacing=0 cellpadding=0 style="width: 100%; font-family: nanumgothic; font-size: 11px;">
						<tr>
							<td rowspan="5" style="width: 150px;">
								<img src="https://www.amazoncar.co.kr/resources/images/logo_1.png" style="width: 150px; padding-right: 10px;"/>
							</td>
							<td style="width: 60px; text-align: center;">����</td>
							<td style="width: 85px; color: red;">02-757-0802</td>
							<td style="width: 60px; text-align: center;">��ȭ��</td>
							<td style="width: 85px; color: red;">02-2038-8661</td>
							<td style="width: 60px; text-align: center;">����</td>
							<td style="width: 85px; color: red;">02-537-5877</td>
							<td style="width: 60px; text-align: center;">����</td>
							<td style="width: 85px; color: red;">02-2038-2492</td>
						</tr>
						<tr>
							<td style="width: 60px; text-align: center;">��õ</td>
							<td style="width: 85px; color: red;">032-554-8820</td>
							<td style="width: 60px; text-align: center;">����</td>
							<td style="width: 85px; color: red;">031-546-8858</td>
							<td style="width: 60px; text-align: center;">����</td>
							<td style="width: 85px; color: red;">042-824-1770</td>
							<td style="width: 60px; text-align: center;">�뱸</td>
							<td style="width: 85px; color: red;">053-582-2998</td>
						</tr>
						<tr>
							<td style="width: 60px; text-align: center;">�λ�</td>
							<td style="width: 85px; color: red;">051-851-0606</td>
							<td style="width: 60px; text-align: center;">����</td>
							<td colspan="5" style="width: 85px; color: red;">062-385-0133</td>
						</tr>
						<tr>
							<td colspan="8" style="height: 8px;"></td>
						</tr>
						<tr>
							<td style="width: 60px; text-align: center;">������</td>
							<td style="width: 85px; color: red;">02-392-4242</td>
							<td style="width: 60px; text-align: center;">�ѹ�</td>
							<td colspan="5" style="width: 85px; color: red;">02-392-4243</td>
						</tr>
					</table>
				</div>
				<div style="padding: 20px 0px 0px 0px; text-align: center;">
					<span style="font-family: nanumgothic;">
						���� �������� �ǻ���� 8 802 (���ǵ���, �������) | ���θ� : �ֽ�ȸ�� �Ƹ���ī | ��ǥ�̻� : ������
					</span><br>
					<span style="color: #a1a1a2;">Copyright(c) 2004 by amazoncar. All right reserved webmaster@amazoncar.co.kr</span>
				</div>
			</div>
			<!-- footer_end -->
		</div>
	</div>
</div>

</body>
</html>